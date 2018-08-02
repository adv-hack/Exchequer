unit AbnSepaDebitClass;

interface

uses
  SepaDebitClass, XmlConst;

type
  TAbnSEPADebitClass = Class(TSepaDebitClass)
  protected
    procedure WriteTransaction; override;
  public
    procedure WriteInitiatingParty; override;
    procedure WriteXMLPaymentInfo(DDSeq : TDirectDebitSequence; NoOfTrans : Integer; SumOfTrans : Double); override;
  end;

implementation

{ TAbnSEPACreditClass }

procedure TAbnSEPADebitClass.WriteInitiatingParty;
begin
  OpenTag(XML_INITIATING_PARTY);

  AddNode(XML_NAME, FCompanyName);

  CloseTag;
end;

procedure TAbnSEPADebitClass.WriteTransaction;
begin
  //MandateID & date
  WriteMandateInfo;
end;

procedure TAbnSEPADebitClass.WriteXMLPaymentInfo(
  DDSeq: TDirectDebitSequence; NoOfTrans: Integer; SumOfTrans: Double);
begin
  inherited;

  //Creditor Scheme
  WriteCreditorSchemeInfo;
end;

end.
