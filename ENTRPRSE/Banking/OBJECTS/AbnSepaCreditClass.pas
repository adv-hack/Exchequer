unit AbnSepaCreditClass;

interface

uses
  SepaCreditClass, XmlConst;

type
  TAbnSEPACreditClass = Class(TSepaCreditClass)
  public
    procedure WriteInitiatingParty; override;
  end;

implementation

{ TAbnSEPACreditClass }

procedure TAbnSEPACreditClass.WriteInitiatingParty;
begin
  OpenTag(XML_INITIATING_PARTY);

  AddNode(XML_NAME, FCompanyName);

  CloseTag;
end;

end.
 