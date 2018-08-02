unit DeutscheSepaCreditClass;

interface

uses
  SEPACreditClass, XMLConst;

type
  //Descendant of SEPACreditClass to allow Ulster Bank-specific output
  TDeutscheSEPACreditClass = class(TSEPACreditClass)
  protected
    procedure WriteInitiatingParty; override;
    procedure WritePaymentType; override;
  end;

implementation

{ TDeutscheSEPACreditClass }

procedure TDeutscheSEPACreditClass.WriteInitiatingParty;
begin
  OpenTag(XML_INITIATING_PARTY);

  AddNode(XML_NAME, FCompanyName);

  CloseTag; //initiating party
end;

procedure TDeutscheSEPACreditClass.WritePaymentType;
begin
  OpenTag(XML_PAYMENT_TYPE_INFO);

  OpenTag(XML_SERVICE_LEVEL);
  AddNode(XML_CODE, 'SEPA');
  CloseTag; //service level

  CloseTag; //Payment type
end;

end.
