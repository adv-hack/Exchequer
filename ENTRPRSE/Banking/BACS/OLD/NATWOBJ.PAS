unit NatWObj;

interface

uses
  CustAbsU, NatW01, ExpObj;

type
   TNatWestExportObject = Class(TExportObject)
     protected
       Options   : TNatWestOptionsRec;
       function NatWestDate(const ADate : string) : string;
       procedure ReadIniFile;
     public
       function WriteRec(const EventData : TAbsEnterpriseSystem;
                                    Mode : word) : Boolean; override;
       function CreateOutFile(const AFileName : string;
                              const EventData :
                              TAbsEnterpriseSystem) : integer; override;

   end;

var

  NatWestExportObject : TNatWestExportObject;


implementation

Uses
  SysUtils,  IniFiles;


function TNatwestExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
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
                  Date := NatWestDate(ProcControl.PDate);
                  CompRef       := Options.BankRef;
                  CompAcc       := UserBankAcc;
                  CompACType    := '00';
                  CompSort      := RemoveHyphens(UserBankSort);
                  DestName      := Target.acCompany;
                  DestAcc       := Target.acBankAcc;
                  DestACType    := '00';
                  DestSort      := Target.acBankSort;

                  if not IsBlank(Bacs_Safe(Target.acBankRef)) then
                    DestRef := Bacs_Safe(Target.acBankRef)
                  else
                    DestRef := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

                  Amount := Pennies(Transaction.thTotalInvoiced);
                  RemAdvReq     := Options.Advice[1];

                  TotalPenceWritten := TotalPenceWritten + Amount;
                  inc(TransactionsWritten);

                  {write record here}

                  with OutRec do
                  begin
                    OutString :=
                    Date         + Sep +
                    IntToStr(CompRef)  + Sep +
                    CompAcc      + Sep +
                    CompACType   + Sep +
                    CompSort     + Sep +
                    DestName     + Sep +
                    DestAcc      + Sep +
                    DestACType   + Sep +
                    DestSort     + Sep +
                    DestRef      + Sep +
                    Pounds(Amount)+ Sep +
                    RemAdvReq;
                  end;
                  Result := WriteThisRec(OutString);

                end;
    end; {case}


  end; {with}
end;

function TNatwestExportObject.NatWestDate(const ADate : string) : string;
begin
  Result := Copy(ADate, 7, 2) + '/' +
            Copy(ADate, 5, 2) + '/' +
            Copy(ADate, 3, 2);
end;

procedure TNatwestExportObject.ReadIniFile;
var
  TheIni : TIniFile;
begin
  TheIni := TIniFile.Create(RequiredPath + IniFileName);
  Try
    with Options do
    begin
      BankRef := TheIni.ReadInteger('Autopay','BankRef',0);
      Advice  := TheIni.ReadString('Autopay','AdviceRequired','N');
    end;
  Finally
    TheIni.Free;
  End;
end;

function TNatwestExportObject.CreateOutFile(const AFileName : string;
                                            const EventData :
                                     TAbsEnterpriseSystem) : integer;
begin
  Result := Inherited CreateOutFile(AFilename, EventData);
  if Result = 0 then
  begin
    ReadIniFile;
    if Options.BankRef = 0 then
    begin
      ShowExportMessage('Error','Invalid System Bank Ref','Run aborted');
      Result := -1;
      Failed := flUserID;
    end;
  end;
end;




end.
