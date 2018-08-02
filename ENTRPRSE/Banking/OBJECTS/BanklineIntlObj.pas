unit BanklineIntlObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$H-}

uses
  CustAbsU, NatW01, ExpObj, BaseSEPAExportClass, LegacySepaObj;

type
  TBankLineIntlObject = Class(TLegacySepaObject)
  private
    FCountry : string;
  protected
    function GetCurrency : string; virtual;
  public
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                                 Mode : word) : Boolean; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  end;

implementation

uses
  SysUtils, EtDateU;

const
  Filler3 = ',,,';
  Filler5 = ',,,,,';


{ TBankLineObject }


function TBankLineIntlObject.GetCurrency: string;
begin
  Result := ProcControl.PayCurr;
end;

function TBankLineIntlObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  //call inherited to set BIC & IBAN
  inherited ValidateSystem(EventData);

  //Can only check that combined value is 14 chars long, as can be either
  //numbers (uk sortcode + accountno) or alpha chars
  Failed := 0; //reset

  Result := Length(Trim(FSepaObject.UserBankSort) +
                   Trim(FSepaObject.UserBankAcc)) = 14;
  if not Result then
    Failed := flBank;
end;

function TBankLineIntlObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  pence : longint;
  Amount : Double;
  OutString : AnsiString;
  Target : TAbsCustomer9;
  DestRef, OurRef : string;
begin
  if Mode <> wrContra then
  begin
    GetEventData(EventData);
    with EventData do
    begin

      Target := TAbsCustomer9(GetTarget(EventData));

      DestRef := Copy(Setup.ssUserName, 1, 25) + ' ' + Transaction.thOurRef;

      OurRef := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
      Amount := ProcControl.Amount;
      TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
      inc(TransactionsWritten);

      OutString := Filler3 + //H01-H03
                   '04,' + //T001 Record type
                   ',,,,' + //T002-T005
                   Trim(Copy(Bacs_Safe(OurRef), 1, 18)) + ',' + //T006 Payment Ref
                   Target.acCountry + ',' +//T007 Country code
                   'N,' + //T008 Priority
                   ',' + //T009 Routing
                   FSepaObject.CompanyBIC + FSepaObject.CompanyIBAN + ',' + //T010 Debit A/C
                   ',' + //T011 Not used
                   ',' + //T012 Not used
                   GetCurrency + ',' +//T013 Currency
                   Trim(Format('%12.2f', [Amount])) + ',' +//T014 Payment Amount
                   FormatDate(ProcControl.PDate) + ',' + //T015 Execution Date
                   ',' + //T016 Credit date - not used
                   Filler5 + //T017-T021
                   Target.acBankSortCode + ',' + //T022
                   Filler5 + //T023-T027
                   Target.acBankAccountCode + ',' + //T028
                   ',' +  //T029 Not used
                   Trim(Copy(Bacs_Safe(Target.acCompany), 1, 35)) + ',' +//T030 Beneficiary name
                   Trim(Copy(Bacs_Safe(Target.acAddress[1]), 1, 35)) + //T031 Beneficiary Address 1
                   ',,,,,,' + //T031-T035
                   Trim(Copy(Bacs_Safe(DestRef), 1, 35)) + //T037 reference
                   StringOfChar(',', 5) +
                   GetCurrency + ',' +
                   StringOfChar(',', 36);

      Result := WriteThisRec(OutString);


    end;
  end
  else
    Result := True;

end;

end.
