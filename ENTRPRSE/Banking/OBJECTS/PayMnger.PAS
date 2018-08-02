unit PayMnger;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$H-}

uses
  CustAbsU, NatW01, ExpObj;

type
   TNatWestPayManagerObject = Class(TExportObject)
     protected
       Options   : TNatWestOptionsRec;
       function PaymentCategory(const Target : TAbsCustomer) : String;
       function EmptyFields(WhichOne : Integer) : string;
       function Currency : string;
     public
       function WriteRec(const EventData : TAbsEnterpriseSystem;
                                    Mode : word) : Boolean; override;
       function CreateOutFile(const AFileName : string;
                              const EventData :
                              TAbsEnterpriseSystem) : integer; override;
       function CloseOutFile : integer; override;
       function TruncateOutFile : boolean;



   end;

var

  NatWestExportObject : TNatWestPayManagerObject;


implementation

Uses
  SysUtils,  IniFiles, Classes;


function TNatWestPayManagerObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                                  Mode : word) : Boolean;
var
  OutRec : TNatWestPayRec;
  TempStr : string;
  pence : longint;
  OutString : string;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);
  FillChar(OutRec, SizeOf(OutRec), 0);
  with EventData, OutRec do
  begin
    Target := GetTarget(EventData);

    Case Mode of

    wrContra :  begin
                {nothing to do}
                  Result := True;
                end;
   wrPayLine :  begin
                  Date := StandardDate(ProcControl.PDate);
                  PMCompRef       := Bacs_Safe(Setup.ssUserName);//Options.BankRef;
                  CompAcc       := UserBankAcc;
                  CompACType    := '00';
                  CompSort      := RemoveHyphens(UserBankSort);
                  DestName      := Bacs_Safe(Target.acCompany);
                  DestAcc       := Target.acBankAcc;
                  DestACType    := '00';
                  DestSort      := RemoveHyphens(Target.acBankSort);

                  if not IsBlank(Bacs_Safe(Target.acBankRef)) then
                    DestRef := Bacs_Safe(Target.acBankRef)
                  else
                    DestRef := '';

                  PMRef := Bacs_Safe(Transaction.thOurRef + '-' + IntToStr(ProcControl.PayRun));


                  Amount := Pennies(Transaction.thTotalInvoiced);

                  TotalPenceWritten := TotalPenceWritten + Amount;
                  inc(TransactionsWritten);

                  {write record here}

                  with OutRec do
                  begin
                    OutString :=
                    ',,1,' +
                    PaymentCategory(Target) +
                    Copy(DestRef, 1, 15)  + Sep +
                    CompAcc      + Sep +
                    CompACType   + Sep +
                    CompSort     + Sep +
                    Currency + Sep +
                    Pounds(Amount)+ Sep +
                    Currency + Sep + Currency + Sep + Sep +
                    PMRef      + Sep +
                    Date         + Sep + Sep + Sep +
                    DestName     + Sep +
                    DestAcc      + Sep +
                    DestSort     + Sep + Sep + Sep +
                    DestACType   + Sep +
                    EmptyFields(1) +
                    PMRef      + Sep +
                    EmptyFields(2) +
                    PMCompRef + Sep +
                    EmptyFields(3);
                  end;
                  Result := WriteThisRec(OutString);

                end;
    end; {case}


  end; {with}
end;


function TNatWestPayManagerObject.CreateOutFile(const AFileName : string;
                                            const EventData :
                                     TAbsEnterpriseSystem) : integer;
var
  PayManFileHeader : AnsiString;
begin
{  ReadIniFile;
  if Options.BankRef = 0 then
  begin
    ShowExportMessage('Error','Field for Bank Reference number not specified','Run aborted');
    Result := -1;
    Failed := flUserID;
  end
  else}
  begin
    PayManFileHeader := NatWestPayManFileHeader1 +
                      NatWestPayManFileHeader2 +
                      NatWestPayManFileHeader3 +
                      NatWestPayManFileHeader4;

    Result := Inherited CreateOutFile(AFilename, EventData);
    WriteThisRec(PayManFileHeader);
  end;
end;

function TNatWestPayManagerObject.CloseOutFile : integer;
{last record shouldn't have a CR/LF after it.  As we don't have a contra or a trailer we
don't know the last record when we have it.  So there are 2 obvious approaches:
1.  Write records in arrears.  2.  Write the file as normal, then lose the last two bytes.
I'll try approach 2 for now as the file format has been tested and is correct apart from the
cr/lf - approach 2 changes things as little as possible}
begin
  Result := inherited CloseOutFile;
  if Result = 0 then
    if not TruncateOutFile then
      Result := -1;
end;

function TNatWestPayManagerObject.TruncateOutFile : Boolean;
{Delete the last two bytes from the file}
var
  OutF : TFileStream;
begin
  Result := True;
  Try
   OutF := TFileStream.Create(OutfileName, fmOpenReadWrite or fmShareExclusive);
   Try
     OutF.Size := OutF.Size - 2;
   Finally
     OutF.Free;
   End;
  Except
   Result := False;
  End;
end;


function TNatWestPayManagerObject.PaymentCategory(
  const Target: TAbsCustomer): String;
var
  SortCodeStart : Integer;
begin
  SortCodeStart := StrToInt(Copy(Target.acBankSort, 1, 2));
  if SortCodeStart in [1, 50..66] then
    Result := 'N,'
  else
    Result := 'O,';
end;

function TNatWestPayManagerObject.EmptyFields(WhichOne : Integer): string;
begin
  Case WhichOne of
    1  : Result := StringOfChar(Sep, 14);
    2  : Result := StringOfChar(Sep, 3);
    3  : Result := StringOfChar(Sep, 71);
  end;
end;

function TNatWestPayManagerObject.Currency: string;
begin
  Result := 'GBP';
end;

end.
