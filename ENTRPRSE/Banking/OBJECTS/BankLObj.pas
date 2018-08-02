unit BankLObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$H-}

uses
  CustAbsU, NatW01, ExpObj;

type
  TBankLineObject = Class(TExportObject)
  private
    function FormatDate(const ADate: string): string;
    function getCompanyName(const ACompanyName: string): string; virtual; //HV 02/08/2016 2016-R3 ABSEXCH-17646: New format for Coutts Bank
  public
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                                 Mode : word) : Boolean; override;
  end;

  //HV 02/08/2016 2016-R3 ABSEXCH-17646: New format for Coutts Bank
  TBLCouttsObject = Class(TBankLineObject)
  private
    function getCompanyName(const ACompanyName: string): string; override;
  end;

implementation

uses
  SysUtils, EtDateU;

const
  Filler3 = ',,,';
  Filler5 = ',,,,,';

{ TBankLineObject }

function TBankLineObject.FormatDate(const ADate: string): string;
//Convert from yyyymmdd to ddmmyyyy
begin
  Result := Copy(ADate, 7, 2) +
            Copy(ADate, 5, 2) +
            Copy(ADate, 1, 4);
end;

function TBankLineObject.getCompanyName(
  const ACompanyName: string): string;
begin
  Result := Trim(Copy(Bacs_Safe(ACompanyName), 1, 35));
end;

function TBankLineObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  pence : longint;
  Amount : Double;
  OutString : string;
  Target : TAbsCustomer;
  DestRef, OurRef : string;
begin
  if Mode <> wrContra then
  begin
    GetEventData(EventData);
    with EventData do
    begin
      Target := GetTarget(EventData);

      if not IsBlank(Target.acBankRef) then
        DestRef := Target.acBankRef
      else
        DestRef := '';

      OurRef := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
      Amount := ProcControl.Amount;
      TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
      inc(TransactionsWritten);

      OutString := Filler3 + '01' + Filler5 + Trim(Copy(Bacs_Safe(OurRef), 1, 18)) + ',' + Filler3 +
                   UserBankSort + UserBankAcc + ',' + Filler3 +  //PR: 22/08/2011 Remove addition of 2 days to date  ABSEXCH-9867
                   Trim(Format('%8.2f', [Amount])) + ',,' + FormatDate(ProcControl.PDate) + ',' +
                   Filler5 +  Target.acBankSort + ',' + Filler5 +
                   Target.acBankAcc + ',,' +
                   getCompanyName(Target.acCompany)+
                    ',,,,' + Trim(Copy(Bacs_Safe(DestRef), 1, 18)) + StringOfChar(',', {44}43); //PR 04/06/2008 change from 44 to 43

      Result := WriteThisRec(OutString);
    end;
  end
  else
    Result := True;

end;

{ TBLCouttsObject }

function TBLCouttsObject.getCompanyName(
  const ACompanyName: string): string;
begin
  Result := Trim(Copy(Bacs_Safe(ACompanyName), 1, 18));
end;

end.
