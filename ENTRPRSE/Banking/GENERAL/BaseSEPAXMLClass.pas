unit BaseSEPAXMLClass;

interface

uses
  GmXML, Classes, XmlConst;

type
  //TBaseSEPAXMLClass is a helper class to allow a BACS object to write out xml files
  //in SEPA format.
  //It is a base class which should never be instantiated as we have descendant classes for
  //Credits and Debits (SEPACreditClass.pas and SEPADebitClass.pas in Entrprse\Banking\General)
  TBaseSEPAXMLClass = Class
  protected
    FGmXML : TGmXML;

    FMessageID : string;
    FOriginatorID : string;
    FOriginatorTag : string;

    FPaymentID : string;
    FPaymentMethod : string; //TRF or DD

    FCompanyBIC : string;
    FCompanyIBAN : string;
    FCompanyName : string;

    FExecutionDate : string;
    FCurrency : string;
    FCompanyCountry: String;
    FCommpanyAddr : array[1..5] of String;
    FPaymentData : TPaymentData;

    function GetCommpanyAddr(Index: Integer): String;
    procedure SetCommpanyAddr(Index: Integer; AValue: String);

    function GetMessageID : string;
    procedure SetMessageID(const Value : string);

    function GetOriginatorID : string;
    procedure SetOriginatorID(const Value : string);

    function GetOriginatorTag : string;
    procedure SetOriginatorTag(const Value : string);

    function GetPaymentID : string;
    procedure SetPaymentID(const Value : string);

    function NewNode(const ATag : string) : TGmXMLNode;

    function GetDDHeader(DDSeq : TDirectDebitSequence) : string;

    procedure WriteDebtorAgent(const BIC : string); virtual;
    procedure WriteDebtorDetails(const AName : string; const IBAN : string); virtual;

    procedure WriteCreditorDetails(const AName : string; const IBAN : string); virtual;
    procedure WriteCreditorAgent(const BIC : string); virtual;

    procedure WritePaymentID; virtual;
    procedure WriteAmount; virtual;

    procedure WriteChargeBearer; virtual;

    function WriteInEuros(Value : Double) : string; virtual;

    procedure WritePaymentType; virtual;

    function GetRunNo : string;
    function GetPaymentInfoID(DDSeq : TDirectDebitSequence) : string; virtual;

  public
    constructor Create;
    destructor Destroy; override;


    procedure WriteXMLDocumentHeader; virtual; abstract;
    procedure WriteXMLGroupHeader(NoOfTrans : Integer; SumOfTrans : Double); virtual;
    procedure WriteInitiatingParty; virtual;
    procedure WriteXMLPaymentInfo(DDSeq : TDirectDebitSequence; NoOfTrans : Integer; SumOfTrans : Double); virtual;

    procedure WriteXMLPayment(APaymentData : TPaymentData); virtual; abstract;

    procedure AddNode(const ATag: string; const Contents : string; AttName : string = ''; AttValue : string = '');  overload;
    procedure AddNode(const ATag: string; const Contents : Integer; AttName : string = ''; AttValue : string = ''); overload;
    procedure AddNode(const ATag: string; const Contents : Double; AttName : string = ''; AttValue : string = '');  overload;

    procedure OpenTag(const ATag : string);
    procedure CloseTag;


    function WriteXML(const OutFile : string) : boolean;

    procedure SetPaymentInfoID; virtual; abstract;

    property PaymentData : TPaymentData read FPaymentData write FPaymentData;

    property MessageID : string read GetMessageID write SetMessageID;
    property OriginatorID : string read GetOriginatorID write SetOriginatorID;
    property OriginatorTag : string read GetOriginatorTag write SetOriginatorTag;
    property PaymentID : string read GetPaymentID write SetPaymentID;

    property CompanyBIC : string read FCompanyBIC write FCompanyBIC;
    property CompanyIBAN : string read FCompanyIBAN write FCompanyIBAN;
    property CompanyName : string read FCompanyName write FCompanyName;

    property ExecutionDate : string read FExecutionDate write FExecutionDate;
    //HV 09/05/2018 2018-R1.1 ABSEXCH-20015: Thomas Pink - HSBC-MT103 Priority Payments (XML Foramt) Add Company Address Details
    property CommpanyAddr[Index: Integer]: String read GetCommpanyAddr write SetCommpanyAddr;
    property CompanyCountry: String read FCompanyCountry write FCompanyCountry;
  end;

implementation

uses
  SysUtils;

{ TBaseSEPAXMLClass }

procedure TBaseSEPAXMLClass.AddNode(const ATag: string; const Contents: string; AttName : string = ''; AttValue : string = '');
var
  ANode : TGmXMLNode;
begin
  ANode := FGmXml.Nodes.AddLeaf(ATag);
  ANode.AsString := Contents;
  if (AttName <> '') and (AttValue <> '') then
    ANode.Attributes.AddAttribute(AttName, AttValue);
end;

procedure TBaseSEPAXMLClass.AddNode(const ATag: string; const Contents: Integer; AttName : string = ''; AttValue : string = '');
var
  ANode : TGmXMLNode;
begin
  ANode := FGmXml.Nodes.AddLeaf(ATag);
  ANode.AsInteger := Contents;
  if (AttName <> '') and (AttValue <> '') then
    ANode.Attributes.AddAttribute(AttName, AttValue);
end;

procedure TBaseSEPAXMLClass.AddNode(const ATag: string; const Contents: Double; AttName : string = ''; AttValue : string = '');
var
  ANode : TGmXMLNode;
begin
  ANode := FGmXml.Nodes.AddLeaf(ATag);
  ANode.AsFloat := Contents;
  if (AttName <> '') and (AttValue <> '') then
    ANode.Attributes.AddAttribute(AttName, AttValue);
end;

procedure TBaseSEPAXMLClass.CloseTag;
begin
  FGmXML.NOdes.AddCloseTag;
end;

constructor TBaseSEPAXMLClass.Create;
begin
  inherited;
  FGmXML := TGmXML.Create(nil);
  FGmXML.Encoding := XML_ENCODING;
  FOriginatorTag := XML_ORGANISATION_ID;
  FCurrency := 'EUR';
end;

destructor TBaseSEPAXMLClass.Destroy;
begin
  FreeAndNil(FGmXML);
  inherited;
end;

function TBaseSEPAXMLClass.GetCommpanyAddr(Index: Integer): String;
begin
  Result := FCommpanyAddr[Index];
end;

function TBaseSEPAXMLClass.GetDDHeader(
  DDSeq: TDirectDebitSequence): string;
begin
  Case DDSeq of
    ddNA        : Result := '';
    ddFirst     : Result := ' (First)';
    ddRecurring : Result := ' (Recurring)';
    ddFinal     : Result := ' (Final)';
    ddOneOff    : Result := ' (One-off)';
    else
      Result := '';
  end;
end;

function TBaseSEPAXMLClass.GetMessageID: string;
begin
  Result := FMessageID;
end;

function TBaseSEPAXMLClass.GetOriginatorID: string;
begin
  Result := FOriginatorID;
end;

//Creates a new Tag, adds it to the xml object and returns it to the caller
function TBaseSEPAXMLClass.GetOriginatorTag: string;
begin
  Result := FOriginatorTag;
end;

function TBaseSEPAXMLClass.GetPaymentID: string;
begin
  Result := FPaymentID;
end;

function TBaseSEPAXMLClass.GetPaymentInfoID(
  DDSeq: TDirectDebitSequence): string;
begin
  Result := FPaymentID + GetDDHeader(DDSeq);
end;

function TBaseSEPAXMLClass.GetRunNo: string;
var
  i : integer;
begin
  Result := '';
  i := Pos('-', FMessageId);
  if i > 0 then
    Result := Copy(FMessageId, i+1, Length(FMessageId));
end;

function TBaseSEPAXMLClass.NewNode(const ATag : string): TGmXMLNode;
begin
  Result := FGmXml.Nodes.AddLeaf(ATag);
end;


procedure TBaseSEPAXMLClass.OpenTag(const ATag: string);
begin
  FGmXML.Nodes.AddOpenTag(ATag);
end;

procedure TBaseSEPAXMLClass.SetCommpanyAddr(Index: Integer; AValue: String);
begin
  FCommpanyAddr[Index] := AValue;
end;

procedure TBaseSEPAXMLClass.SetMessageID(const Value: string);
begin
  FMessageID := Value;
end;

procedure TBaseSEPAXMLClass.SetOriginatorID(const Value: string);
begin
  FOriginatorID := Value;
end;

procedure TBaseSEPAXMLClass.SetOriginatorTag(const Value: string);
begin
  FOriginatorTag := Value;
end;

procedure TBaseSEPAXMLClass.SetPaymentID(const Value: string);
begin
  FPaymentID := Value;
end;

procedure TBaseSEPAXMLClass.WriteAmount;
begin
  AddNode(XML_INSTRUCTED_AMOUNT, WriteInEuros(PaymentData.Amount), XML_CURRENCY, 'EUR');
end;

procedure TBaseSEPAXMLClass.WriteChargeBearer;
begin
  AddNode(XML_CHARGE_BEARER, 'SLEV');
end;

procedure TBaseSEPAXMLClass.WriteCreditorAgent(const BIC : string);
begin
  OpenTag(XML_CREDITOR_AGENT);
  OpenTag(XML_FINANCIAL_INSTITUTION_ID);
  AddNode(XML_BIC, BIC);
  CloseTag; //Creditor Agent
  CloseTag; //Financial Inst
end;

procedure TBaseSEPAXMLClass.WriteCreditorDetails(const AName : string; const IBAN : string);
begin
  OpenTag(XML_CREDITOR);
  AddNode(XML_NAME, AName);
  CloseTag; //Creditor

  OpenTag(XML_CREDITOR_ACCOUNT);
  OpenTag(XML_ID);
  AddNode(XML_IBAN, IBAN);
  CloseTag; //ID
  CloseTag; //Creditor Account
end;

procedure TBaseSEPAXMLClass.WriteDebtorAgent(const BIC : string);
begin
  //Debtor BIC
  OpenTag(XML_DEBTOR_AGENT);
  OpenTag(XML_FINANCIAL_INSTITUTION_ID);
  AddNode(XML_BIC, BIC);
  CloseTag; //XML_FINANCIAL_INSTITUTION_ID
  CloseTag; //XML_DEBTOR_AGENT
end;

procedure TBaseSEPAXMLClass.WriteDebtorDetails(const AName : string; const IBAN : string);
begin
  //Debtor Name
  OpenTag(XML_DEBTOR);
  AddNode(XML_NAME, AName);
  CloseTag;

  //Debtor Account
  OpenTag(XML_DEBTOR_ACCOUNT);
  OpenTag(XML_ID);
  AddNode(XML_IBAN, IBAN);
  CloseTag; // XML_ID
  CloseTag; //XML_DEBTOR_ACCOUNT
end;

function TBaseSEPAXMLClass.WriteInEuros(Value: Double): string;
begin
  Result := Trim(Format('%18.2f', [Value]));
end;

procedure TBaseSEPAXMLClass.WriteInitiatingParty;
begin
  OpenTag(XML_INITIATING_PARTY);
  OpenTag(XML_ID);
  OpenTag(FOriginatorTag);
  OpenTag(XML_OTHER);

  AddNode(XML_ID, FOriginatorID);

  CloseTag; //other
  CloseTag; //originator
  CloseTag; //Id
  CloseTag; //initiating party
end;

procedure TBaseSEPAXMLClass.WritePaymentID;
begin
  OpenTag(XML_PAYMENT_ID);
  AddNode(XML_END_TO_END_ID, PaymentData.Ref);
  CloseTag;
end;

procedure TBaseSEPAXMLClass.WritePaymentType;
begin
  //Do nothing in base
end;

function TBaseSEPAXMLClass.WriteXML(const OutFile : string): boolean;
begin
  Try
    FGmXML.SaveToFile(OutFile);
    Result := True;
  Except
    Result := False;
  End;
end;

procedure TBaseSEPAXMLClass.WriteXMLGroupHeader(NoOfTrans : Integer; SumOfTrans : Double);
begin
  OpenTag(XML_GROUP_HEADER);

  //The group header contains MessageID, Creation Date/Time, Number of Transactions, Sum of Transactions (Header Control Sum)
  AddNode(XML_MESSAGE_ID, GetMessageID);
  AddNode(XML_CREATION_DATETIME, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss', Now));

  AddNode(XML_NO_OF_TRANSACTIONS, NoOfTrans);
  AddNode(XML_SUM_OF_TRANSACTIONS, WriteInEuros(SumOfTrans));

  //Company name and/or Id
  WriteInitiatingParty;

  CloseTag; // group header
end;

procedure TBaseSEPAXMLClass.WriteXMLPaymentInfo(DDSeq : TDirectDebitSequence; NoOfTrans : Integer; SumOfTrans : Double);
begin
  OpenTag(XML_PAYMENT_INFO);

  AddNode(XML_PAYMENT_INFO_ID, GetPaymentInfoID(DDSeq));
  AddNode(XML_PAYMENT_METHOD, FPaymentMethod);

  //Number and sum of transactions
  AddNode(XML_NO_OF_TRANSACTIONS, NoOfTrans);
  AddNode(XML_SUM_OF_TRANSACTIONS, WriteInEuros(SumOfTrans));

end;


end.
