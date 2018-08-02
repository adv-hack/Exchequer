unit UniSepaDebitClass;

interface

uses
  SEPADebitClass;

type
  //Descendant of SEPACreditClass to allow Unicredit-specific output
  TUniSEPADebitClass = class(TSEPADebitClass)
  protected
    procedure WritePaymentType; override;
  public
    procedure WriteInitiatingParty; override;
  end;

implementation

uses
  XMLConst;

{ TUniSEPADebitClass }

procedure TUniSEPADebitClass.WriteInitiatingParty;
begin
  OpenTag(XML_INITIATING_PARTY);

  AddNode(XML_NAME, FCompanyName);

  CloseTag;
end;

procedure TUniSEPADebitClass.WritePaymentType;
begin
  OpenTag(XML_PAYMENT_TYPE_INFO);

  OpenTag(XML_SERVICE_LEVEL);
  AddNode(XML_CODE, 'SEPA');
  CloseTag; //service level

  CloseTag; //Payment type
end;

end.
 