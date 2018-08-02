unit UniSepaCreditClass;

interface

uses
  SEPACreditClass;

type
  //Descendant of SEPACreditClass to allow Unicredit-specific output
  TUniSEPACreditClass = class(TSEPACreditClass)
  protected
    procedure WritePaymentType; override;
    procedure WriteInitiatingParty; override;
  end;

implementation

uses
  XMLConst;

{ TUniSEPACreditClass }

procedure TUniSEPACreditClass.WriteInitiatingParty;
begin
  OpenTag(XML_INITIATING_PARTY);

  AddNode(XML_NAME, FCompanyName);

  CloseTag;
end;

procedure TUniSEPACreditClass.WritePaymentType;
begin
  OpenTag(XML_PAYMENT_TYPE_INFO);

  OpenTag(XML_SERVICE_LEVEL);
  AddNode(XML_CODE, 'SEPA');
  CloseTag; //service level

  CloseTag; //Payment type
end;

end.
 