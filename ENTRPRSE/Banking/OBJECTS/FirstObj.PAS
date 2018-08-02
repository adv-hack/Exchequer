unit FirstObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ExpObj, CustAbsU;

type
  TFirstNatRec = Record
    ToRef    : string[30];
    FromRef  : string[15];
    ToSort   : string[6];
    ToAcc    : string[11];
    ToAcc2   : string[20];
    Amount   : longint;
    AccType   : String[1];
  end;

  TFirstNatExportObject = Class(TExportObject)
  private
     FromSort : string[6];
     FromAcc  : string[11];
     SeqNo    : Integer;
     function Filler(HowMuch : Integer) : string;
     function InstallHeader : string;
     function UserHeader(const ADate : string) : string;
     function Contra : string;
     function UserTrailer : string;
     function InstallTrailer : string;
     function StandardHeader(const Prefix : string) : string;
     function GetAccountCode : string;
  public
     function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
     function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                    override;
     function CreateOutFile(const AFileName : string;
                            const EventData :
                            TAbsEnterpriseSystem) : integer; override;
     function CloseOutFile : integer; override;
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;

implementation

uses
  SysUtils;

function TFirstNatExportObject.CloseOutFile: integer;
begin
  WriteLn(OutFile, Contra);
  WriteLn(OutFile, UserTrailer);
  WriteLn(OutFile, InstallTrailer);
  Result := inherited CloseOutFile;
end;

function TFirstNatExportObject.Contra: string;
begin
  Result := StandardHeader('12');
end;

function TFirstNatExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := inherited CreateOutFile(AFilename, EventData);
  if Result = 0 then
  begin
    WriteLn(OutFile, InstallHeader);
    WriteLn(OutFile, UserHeader(ProcControl.PDate));
    SeqNo := 1;
  end;
end;

function TFirstNatExportObject.Filler(HowMuch : Integer): string;
begin
  Result := StringOfChar('0', HowMuch);
end;

function TFirstNatExportObject.GetAccountCode: string;
//Stub to allow testing - change once we know where the user a/c code will be stored
begin
  Result := '12345678999';
end;

function TFirstNatExportObject.InstallHeader: string;
begin
  Result := StandardHeader('02');
end;

function TFirstNatExportObject.InstallTrailer: string;
begin
  Result := StandardHeader('94');
end;

function TFirstNatExportObject.StandardHeader(
  const Prefix: string): string;
begin
  Result := Prefix + Filler(178);
end;

function TFirstNatExportObject.UserHeader(const ADate : string): string;
//Date should be in format yyyymmdd - the function will then reduce it to yymmdd to meet the required
//format
begin
  Result := '04' + Filler(16) + Copy(ADate, 3, 6) + Filler(156);
end;

function TFirstNatExportObject.UserTrailer: string;
begin
  Result := StandardHeader('92');
end;

function TFirstNatExportObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
//Overrided method to deal with ac length of 11 plus possible extended Acc Code
var
  TempStr : string;
  Target : TAbsCustomer;
  AcError : Boolean;
begin
  AcError := False;
  Result := True;
  GetEventData(EventData);
  with EventData do
  begin
    Target := GetTarget(EventData);

    if Target.acPayType <> 'B' then
    begin
      Result := False;
      LogIt(Target.acCompany + ': PayType not set to Bacs');
    end;
    TempStr := Target.acBankSort;
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      LogIt(Target.acCompany + ': Invalid sort code - ' + TempStr);
      Result := False;
    end;

    //Account is 11 characters. However, if it is blank then we check User Field 4 for extended ac code.
    TempStr := Target.acBankAcc;
    if Trim(TempStr) = '' then
    begin
      TempStr := Target.acUserDef4;
      AcError := Trim(TempStr) = '';
    end
    else
      AcError := Length(TempStr) <> 11;
    if AcError or not AllDigits(TempStr) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Invalid account - ' + TempStr);
    end;
  end; {with EventData}
end;

function TFirstNatExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
{check user bank a/c & sort code - override to deal with 11 digit ac code}
var
  TempStr : Shortstring;
begin
  Result := True;
  with EventData.Setup do
  begin
    TempStr := UserBankAcc;
    if (Length(TempStr) <> 11) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
    end;
    TempStr := UserBankSort;
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
    end;
    if Result then
    begin
      FromSort := UserBankSort;
      FromAcc := UserBankAcc;
      LogIt('Validate system - successful');
    end;
  end; {with EventData.Setup}
end;

function TFirstNatExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;

var
  OutRec  : TFirstNatRec;
  OutString : string;
  Target : TAbsCustomer;
begin
  Result := True;
  if Mode = wrPayLine then {don't want the contra}
  begin
    FillChar(OutRec, SizeOf(OutRec), #0);
    GetEventData(EventData);
    with EventData, OutRec do
    begin

      if IsReceipt then
        Target := Customer
      else
        Target := Supplier;

      ToSort := Target.acBankSort;
      ToAcc  := Target.acBankAcc;
      if Trim(ToAcc) = '' then
      begin
        ToAcc := Filler(11);
        ToAcc2 := LJVar(Target.acUserDef4, 20);
      end
      else
        ToAcc2 := Filler(20);

      if Trim(Target.acUserDef3) = '' then
        AccType := '1'
      else
        AccType := Copy(Target.acUserDef3, 1, 1);

      FromRef := LJVar(Bacs_Safe(Target.acCompany), 15);
      {$IFDEF EX600}
      with TAbsInvoice5(Transaction) do
        ToRef := Bacs_Safe(LJVar(thOurRef + ' - ' + thYourRef20, 30));
      {$ELSE}
      ToRef := Bacs_Safe(LJVar(Transaction.thOurRef + ' - ' + Transaction.thYourRef, 30));
      {$ENDIF}
      Amount := Pennies(Transaction.thTotalInvoiced);
      TotalPenceWritten := TotalPenceWritten + Amount;
      inc(TransactionsWritten);

      OutString := '10' +  FromSort + FromAcc + ZerosAtFront(SeqNo, 10) +
                   ToSort + ToAcc + AccType + ZerosAtFront(Amount, 11) + Filler(12) +
                   ToRef + FromRef + Filler(15) + ToAcc2 + Filler(30);

      Result := WriteThisRec(OutString);

      Inc(SeqNo);
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;



end.
