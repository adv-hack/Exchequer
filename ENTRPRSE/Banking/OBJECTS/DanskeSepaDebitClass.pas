unit DanskeSepaDebitClass;

interface
uses
  SEPADebitClass, XMLConst;

type
  TDanskeSEPADebitClass = Class(TSEPADebitClass)
  protected
    procedure WriteXMLPaymentInfo(DDSeq : TDirectDebitSequence; NoOfTrans : Integer; SumOfTrans : Double); override;
    procedure WriteTransaction; override;
  end;

implementation

{ TDankseSEPADebitClass }

procedure TDanskeSEPADebitClass.WriteTransaction;
begin
  //MandateID & date
  WriteMandateInfo;
end;

procedure TDanskeSEPADebitClass.WriteXMLPaymentInfo(
  DDSeq: TDirectDebitSequence; NoOfTrans: Integer; SumOfTrans: Double);
begin
  inherited;

  WriteCreditorSchemeInfo;
end;

end.
 