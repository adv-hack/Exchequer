unit UlsterSepaCreditXML;

interface

uses
  SEPACreditClass, XMLConst;

type
  //Descendant of SEPACreditClass to allow Ulster Bank-specific output
  TUlsterSEPACreditClass = class(TSEPACreditClass)
  protected
    procedure WritePaymentType; override;
    procedure WriteChargeBearer; override;
    procedure WriteInitiatingParty; override;
    procedure WriteDebtorDetails(const AName : string; const IBAN : string); override;
    function  CleanEndToEndID(const E2E : string) : string;
    function GetPaymentInfoID(DDSeq : TDirectDebitSequence) : string; override;
  public
    procedure WriteXMLPayment(APaymentData : TPaymentData); override;
  end;

implementation

uses
  StrUtils;

{ TUlsterSEPACreditClass }

function TUlsterSEPACreditClass.CleanEndToEndID(const E2E: string): string;
var
  i : integer;
begin
  i := Length(E2E) - 8; //Start of OurRef
  //Remove spaces in name and replace space between name and our ref with '/'
  Result := AnsiReplaceStr(Copy(E2E, 1, i - 1), ' ', '') + '/' + Copy(E2E, i, 9);
end;

function TUlsterSEPACreditClass.GetPaymentInfoID(
  DDSeq: TDirectDebitSequence): string;
begin
  Result := AnsiReplaceStr(inherited GetPaymentInfoID(DDSeq), ' ', '');
end;

procedure TUlsterSEPACreditClass.WriteChargeBearer;
begin
  //Ulster bank format doesn't include charge bearer, so do nothing
end;

procedure TUlsterSEPACreditClass.WriteDebtorDetails(const AName,
  IBAN: string);
begin
  OpenTag(XML_DEBTOR);
  AddNode(XML_NAME, FCompanyName);
  CloseTag;

  OpenTag(XML_DEBTOR_ACCOUNT);

  OpenTag(XML_ID);
  AddNode(XML_IBAN, FCompanyIBAN);
  CloseTag; //ID

  CloseTag; //Debtor Account
end;

procedure TUlsterSEPACreditClass.WriteInitiatingParty;
begin
  OpenTag(XML_INITIATING_PARTY);

  //Ulster requires name as well as ID
  AddNode(XML_NAME, FCompanyName);
  OpenTag(XML_ID);
  OpenTag(FOriginatorTag);
  OpenTag(XML_OTHER);

  AddNode(XML_ID, FOriginatorID);

  CloseTag; //other
  CloseTag; //originator
  CloseTag; //Id
  CloseTag; //initiating party
end;

procedure TUlsterSEPACreditClass.WritePaymentType;
begin
  OpenTag(XML_PAYMENT_TYPE_INFO);

  OpenTag(XML_SERVICE_LEVEL);
  AddNode(XML_CODE, 'SEPA');
  CloseTag; //service level

  CloseTag; //Payment type
end;

procedure TUlsterSEPACreditClass.WriteXMLPayment(
  APaymentData: TPaymentData);
begin
  APaymentData.Ref := CleanEndToEndID(APaymentData.Ref);
  inherited;
end;

end.
