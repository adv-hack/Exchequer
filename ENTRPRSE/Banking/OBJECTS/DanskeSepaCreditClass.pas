unit DanskeSepaCreditClass;

interface

uses
  SEPACreditClass;

type
  //Descendant of SEPACreditClass to allow Ulster Bank-specific output
  TDanskeSEPACreditClass = class(TSEPACreditClass)
  protected
    procedure WritePaymentType; override;
    procedure WriteInitiatingParty; override;
    procedure WriteDebtorDetails(const AName : string; const IBAN : string); override;
  end;

implementation

uses
  XMLConst;

{ TDanskeSEPACreditClass }

procedure TDanskeSEPACreditClass.WriteDebtorDetails(const AName,
  IBAN: string);
begin
  //Debtor Name
  OpenTag(XML_DEBTOR);
  AddNode(XML_NAME, AName);

  OpenTag(XML_POSTAL_ADDRESS);
  AddNode(XML_COUNTRY, Copy(IBAN, 1, 2));
  CloseTag;

  CloseTag;

  //Debtor Account
  OpenTag(XML_DEBTOR_ACCOUNT);
  OpenTag(XML_ID);
  AddNode(XML_IBAN, IBAN);
  CloseTag; // XML_ID
  CloseTag; //XML_DEBTOR_ACCOUNT
end;

procedure TDanskeSEPACreditClass.WriteInitiatingParty;
begin
  inherited;
end;

procedure TDanskeSEPACreditClass.WritePaymentType;
begin
  OpenTag(XML_PAYMENT_TYPE_INFO);

  OpenTag(XML_SERVICE_LEVEL);
  AddNode(XML_CODE, 'SEPA');
  CloseTag; //service level

  CloseTag; //Payment type
end;

end.
 