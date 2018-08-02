unit BarclaysBMSepaObj;
{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$H-}

uses
  CustAbsU, NatW01, ExpObj, BaseSEPAExportClass, LegacySepaObj, MT103Helper;

type
  TBarclaysBMSepaObject = Class(TLegacySepaObject)
  protected //PR: 21/12/2016 ABSEXCH-18048 Changed from private to protected
    FMT103 : TMT103HelperObject;
  public
    procedure WriteALine(const s : string);
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                                 Mode : word) : Boolean; override;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils, EtDateU;

const
  Filler3 = ',,,';
  Filler5 = ',,,,,';


{ TBankLineObject }


constructor TBarclaysBMSepaObject.Create;
begin
  inherited;
  FMT103 := TMT103HelperObject.Create;
  FMT103.WriteLine := WriteALine;
end;

destructor TBarclaysBMSepaObject.Destroy;
begin
  if Assigned(FMT103) then
    FMT103.Free;
  inherited;
end;

procedure TBarclaysBMSepaObject.WriteALine(const s: string);
begin
  WriteThisRec(s);
end;

function TBarclaysBMSepaObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  pence : longint;
  Amount : Double;
  OutString : string;
  Target : TAbsCustomer4;
begin
  Result := True;
  if Mode <> wrContra then
  Try
    GetEventData(EventData);
    with EventData do
    begin
      Target := TAbsCustomer4(GetTarget(EventData));

      Amount := ProcControl.Amount;
      TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
      inc(TransactionsWritten);

      with FMT103 do
      begin
        WriteSenderRef(Transaction.thOurRef);
        WriteValueDateAndAmount(YYMMDD(ProcControl.PDate), ProcControl.Amount, 'EUR');
        WriteOurIBAN(FSepaObject.CompanyIBAN);
        WriteTheirBIC(Target.acBankSortCode);
        WriteTheirIBAN(Target.acBankAccountCode);
        // HV 20/10/2016 2017-R1 ABSEXCH-17620: Reduce the number of characters exported from 45 to 35
        WriteTheirName(Trim(Copy(Bacs_Safe(Target.acCompany), 1, 35)));
        WritePaymentDetails('');
        WriteChargingInstructions;
        WriteEndOfRecord;
      end;

    end;
  Except
    on E:Exception do
    begin
      Result := False;
      LogIt('Exception in WriteRec: ' + E.Message);
    end;
  End;

end;

end.
