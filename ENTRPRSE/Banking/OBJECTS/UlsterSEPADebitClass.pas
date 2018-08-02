unit UlsterSEPADebitClass;

interface

uses
  SEPADebitClass, XMLConst;

type
  TUlsterSEPADebitClass = Class(TSEPADebitClass)
  protected
    FBatchNo : Integer;
    procedure WriteCreditorAgent(const BIC : string); override;
    procedure WriteTransaction; override;
    procedure WriteInitiatingParty; override;
    procedure WriteChargeBearer; override;
    function  CleanEndToEndID(const E2E : string) : string;
    function GetPaymentInfoID(DDSeq : TDirectDebitSequence) : string; override;
  public
    procedure WriteXMLPaymentInfo(DDSeq : TDirectDebitSequence; NoOfTrans : Integer; SumOfTrans : Double); override;
    procedure WriteXMLPayment(APaymentData : TPaymentData); override;
    constructor Create;
  end;


implementation

uses
  SysUtils, StrUtils;

{ TBaseUlsterSEPAXmlClass }

function TUlsterSEPADebitClass.CleanEndToEndID(const E2E: string): string;
var
  i : integer;
begin
  i := Length(E2E) - 8; //Start of OurRef
  //Remove spaces in name and replace space between name and our ref with '/'
  Result := AnsiReplaceStr(Copy(E2E, 1, i - 1), ' ', '') + '/' + Copy(E2E, i, 9);
end;

constructor TUlsterSEPADebitClass.Create;
begin
  inherited;
  FBatchNo := 0;
end;

function TUlsterSEPADebitClass.GetPaymentInfoID(
  DDSeq: TDirectDebitSequence): string;
begin
  Result := AnsiReplaceStr(inherited GetPaymentInfoID(DDSeq), ' ', '');
end;

procedure TUlsterSEPADebitClass.WriteChargeBearer;
begin
  //Do nothing - Ulster DD file doesn't include charge bearer
end;

procedure TUlsterSEPADebitClass.WriteCreditorAgent(const BIC: string);
begin
  inherited;
  WriteCreditorSchemeInfo;
end;

procedure TUlsterSEPADebitClass.WriteInitiatingParty;
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

procedure TUlsterSEPADebitClass.WriteTransaction;
begin
  //MandateID & date
  WriteMandateInfo;
end;

procedure TUlsterSEPADebitClass.WriteXMLPayment(
  APaymentData: TPaymentData);
begin
  APaymentData.Ref := CleanEndToEndID(APaymentData.Ref);
  inherited;
end;

procedure TUlsterSEPADebitClass.WriteXMLPaymentInfo(
  DDSeq: TDirectDebitSequence; NoOfTrans: Integer; SumOfTrans: Double);
begin
  //Ulster requires unique payment id, so use run number & batch no
  inc(FBatchNo);
  FPaymentID := 'BACS ' + GetRunNo + '-' + IntToStr(FBatchNo);
  inherited;
end;

end.
