unit MT103Helper;

interface

type
  TWriteLineProc = procedure(const s : string) of Object;

  TMT103HelperObject = Class
  protected
    FWriteLine : TWriteLineProc;
  public
    procedure WriteSenderRef(const Ref : string);
    procedure WriteValueDateAndAmount(const ADate : string; Value : Double; Currency : string);
    procedure WriteOurBIC(const BIC : string);
    procedure WriteOurIBAN(const IBAN : string);
    procedure WriteTheirBIC(const BIC : string);
    procedure WriteTheirIBAN(const IBAN : string);
    procedure WriteTheirName(const TheirName : string);
    procedure WritePaymentDetails(const Details : string);
    procedure WriteChargingInstructions;
    procedure WriteEndOfRecord;

    property WriteLine : TWriteLineProc read FWriteLine write FWriteLine;
  end;


implementation

uses
  SysUtils, StrUtils;

{ TMT103HelperObject }

procedure TMT103HelperObject.WriteChargingInstructions;
begin
  FWriteLine(':71A:/SHA');
end;

procedure TMT103HelperObject.WriteEndOfRecord;
begin
  FWriteLine('-');
  FWriteLine('');
end;

procedure TMT103HelperObject.WriteOurBIC(const BIC : string);
begin
  FWriteLine(':57A:' + BIC);
end;

procedure TMT103HelperObject.WriteOurIBAN(const IBAN : string);
begin
  FWriteLine(':50A:/' + IBAN);
end;

procedure TMT103HelperObject.WritePaymentDetails(const Details : string);
begin
  FWriteLine(':70:/REC/SCT ' + Details);
end;

procedure TMT103HelperObject.WriteSenderRef(const Ref : string);
begin
  FWriteLine(':20:' + Ref);
end;

procedure TMT103HelperObject.WriteTheirBIC(const BIC : string);
begin
  FWriteLine(':57A:' + BIC);
end;

procedure TMT103HelperObject.WriteTheirIBAN(const IBAN : string);
begin
  FWriteLine(':59:/' + IBAN);
end;

procedure TMT103HelperObject.WriteTheirName(const TheirName : string);
begin
  FWriteLine(TheirName);
end;

procedure TMT103HelperObject.WriteValueDateAndAmount(const ADate : string; Value : Double; Currency : string);
begin
  FWriteLine(':32A:' + ADate + Currency + AnsiReplaceStr(Trim(Format('%10.2f', [Value])), '.', ','));
end;

end.
