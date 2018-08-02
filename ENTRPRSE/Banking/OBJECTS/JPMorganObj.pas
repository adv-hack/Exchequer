unit JPMorganObj;

interface

uses
  ExpObj, CustAbsU;

type
  TJPMorganExportObject = Class(TExportObject)
  private
     function MandateString(const oTarget : TAbsCustomer) : string;
     function GetHeader : string;
     function GetTrailer : string;
  public
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
     function ValidateSystem(const EventData : TAbsEnterpriseSystem): Boolean;  override;
     function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                      override;
     function CreateOutFile(const AFileName : string;
                            const EventData :
                            TAbsEnterpriseSystem) : integer; override;
     function CloseOutFile : integer; override;
  end;

var
  sClientID : string;
  iMandateNo : Byte;


implementation

uses
  SysUtils, IIfFuncs {$IFDEF MULTIBACS}, Multini, IniFiles {$ENDIF};

{ TJPMorganExportObject }
{$IFDEF MULTIBACS}
procedure ReadIniFile(const DataPath : string);
begin
  with TIniFile.Create(Datapath + 'JPMorgan.ini') do
  Try
    sClientID := ReadString('Settings', 'ClientID', '');
    iMandateNo := ReadInteger('Settings', 'MandateField', 0);
  Finally
    Free;
  End;
end;
{$ENDIF}

function TJPMorganExportObject.CloseOutFile: integer;
begin
  WriteThisRec(GetTrailer);
  Result := inherited CloseOutFile;
end;

function TJPMorganExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := inherited CreateOutFile(AFileName, EventData);
  WriteThisRec(GetHeader);
end;

function TJPMorganExportObject.MandateString(
  const oTarget: TAbsCustomer): string;
begin
  if IsReceipt and (iMandateNo > 0) then
  begin
    Case iMandateNo of
      1 : Result := oTarget.acUserDef1;
      2 : Result := oTarget.acUserDef2;
      3 : Result := oTarget.acUserDef3;
      4 : Result := oTarget.acUserDef4;
    end; //case
  end
  else
    Result := '';
  Result := Trim(Result);
end;

function TJPMorganExportObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := inherited ValidateRec(EventData);

  if Result and IsReceipt then //Check direct debit mandate on customer record
    Result := (iMandateNo in [1..4]) and (Trim(MandateString(EventData.Customer)) <> '');
end;

function TJPMorganExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := inherited ValidateSystem(EventData);

  if Result then
  begin
    {$IFDEF MULTIBACS}
    ReadIniFile(DataPath);
    if Trim(UserID) <> '' then
      sClientID := UserID;
    {$ENDIF}
    Result := (Trim(sClientID) <> '');
    if not Result then
      Failed := flBank;
  end;
end;

function TJPMorganExportObject.GetHeader : string;
begin
  Result := Format('FH,%s,%s,01100,,,,,,,,,,,,,,,,,,,,,,,,', [sClientID, FormatDateTime('YYYYMMDD,HHNNSS', Now)]);
end;

function TJPMorganExportObject.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
var
  OutString : string;
  Target : TAbsCustomer;
  Amount : longint;
begin
  Result := True;
  Target := GetTarget(EventData);

  if Mode = wrPayLine then {don't want the contra}
  begin
    GetEventData(EventData);
    Amount := Pennies(ProcControl.Amount);
    TotalPenceWritten := TotalPenceWritten + Amount;
    inc(TransactionsWritten);

    OutString := 'TR,' +
                 EventData.Transaction.thOurRef + ',' +
                 ProcControl.PDate + ',' +
                 'GB,,' +
                 Target.acBankSort + ',' +
                 Target.acBankAcc + ',' +
                 '0,' +
                 Format('%d', [Amount]) + ',' +
                 'GBP,GIR,' +
                 IIF(IsReceipt, '02,', '01,') +
                 IIF(IsReceipt, DirectDebitCode(Target.acDirDebMode), '99') + ',' +
                 UserBankAcc + ',,,' +
                 BACS_Safe(Trim(Copy(Target.acCompany, 1, 18))) + ',,' +
                 MandateString(Target) + ',,,,,,,,,' +
                 BACS_SAFE(Trim(Copy(EventData.Transaction.thYourRef, 1, 18)));
    Result := WriteThisRec(OutString);
  end;

end;

function TJPMorganExportObject.GetTrailer : string;
begin
  Result := Format('FT,%d,%d,%d,,,,,,,,,,,,,,,,,,,,,,,,', [TransactionsWritten, TransactionsWritten + 2, TotalPenceWritten]);
end;


end.
