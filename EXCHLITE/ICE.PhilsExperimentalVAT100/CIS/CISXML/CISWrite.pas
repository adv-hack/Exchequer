unit CISWrite;

interface

uses
 Contnrs, GMXML, CISXCnst;

Type
  TCISMessageType = (cisReturn, cisVerification);

  TIRSender = (irsIndividual, irsCompany, irsAgent, irsBureau, irsPartnership, irsTrust,
                    irsGovernment, irsOther);

  TSubContractorRec = Record
    scForeName1,
    scForeName2,
    scSurname : string[35];
    scTradingName : string[56];
    scUTR : string[12];
    scNINO : string[9];
    scCRN  : string[8];
    scVerificationNo : string[13];
    scUnMatchedRate : Boolean;
    scTotalPayments,
    scCostOfMaterials,
    scTotalDeducted : Double;
  end;

  TCISMessageRec = Record
    cisType : TCISMessageType;
    cisTestOnly : Boolean;
    //Length of the next 2 fields is not documented, so to be
    //absolutely safe, we'll change them to Strings and move them to the object itself
{    cisSenderID : string[20]; //*
    cisSenderAuthentication : string[20]; //*}
    cisTaxOfficeNumber : string[3];
    cisTaxOfficeReference : string[10];
    cisVendorID : string[4];
    cisMonth : Byte;
    cisYear : SmallInt;
    cisCurrency : String[3];
    cisIRMark : string[20];
    cisIRSender : TIRSender;
    cisContractorUTR : string[12];
    cisContractorAORef : string[13];
    cisProductName : String[100];
    cisProductVersion : string[20];
    cisNilIndicator, cisEmploymentStatus,
    cisSubContractorVerification, cisInactivity : Boolean;
  end;

  TCISSubContractor = Class
  private
    FDataRec : TSubContractorRec;
    function GetDouble(const Index: Integer): Double;
    procedure SetDouble(const Index: Integer; const Value: Double);
    function GetString(const Index: Integer): string;
    function GetUnmatchedRate: Boolean;
    procedure SetString(const Index: Integer; const Value: string);
    procedure SetUnmatchedRate(const Value: Boolean);
  public
    property Forename1 : string Index 1 read GetString write SetString;
    property Forename2 : string Index 2 read GetString write SetString;
    property Surname : string Index 3 read GetString write SetString;
    property TradingName : string Index 4 read GetString write SetString;
    property UTR : string Index 5 read GetString write SetString;
    property NINO : string Index 6 read GetString write SetString;
    property CRN : string Index 7 read GetString write SetString;
    property VerificationNumber : string Index 8 read GetString write SetString;
    property TotalPayments : Double Index 1 read GetDouble write SetDouble;
    property CostOfMaterials : Double Index 2 read GetDouble write SetDouble;
    property TotalDeducted : Double Index 3 read GetDouble write SetDouble;
    property UnmatchedRate : Boolean read GetUnmatchedRate write SetUnmatchedRate;
  end;

  TCISSubContractors = Class
  private
    FList : TObjectList;
    FDocument : TGmXML;
    function GetItem(Index: Integer): TCISSubContractor;
    procedure WriteItem(SubContractor : TCISSubContractor);
  public
    constructor Create;
    destructor Destroy; override;
    function Add : TCISSubContractor;
    function Delete(Index : Integer) : Integer;
    procedure WriteItems;
    property Items[Index : Integer] : TCISSubContractor read GetItem;
    property Document : TGmXML read FDocument write FDocument;
  end;

  TCISXMLBase = Class
  private
    FDataRec : TCISMessageRec;
    FDocument : TGmXML;
    FSubContractors : TCISSubContractors;
    FSenderID,
    FSenderAuthentication : String;
    function GetInt(const Index: Integer): Integer;
    procedure SetInt(const Index, Value: Integer);
    function GetBool(const Index: Integer): Boolean;
    procedure SetBool(const Index: Integer; const Value: Boolean);
  protected
    function GetString(const Index: Integer): string;
    procedure SetString(const Index: Integer; const Value: string);
    procedure WriteGovTalkHeader;
    procedure WriteMessageDetails;
    procedure WriteSenderDetails;
    procedure WriteGovTalkDetails;
    procedure WriteBody;
    procedure WriteIRHeader;
    procedure WriteCISReturn;
    procedure WriteKeys;
    procedure WriteMessage;
    function FormatPeriod(AMonth : Byte; AYear : Integer) : string;
    procedure CreateIRMark;
    function SenderString : string;
    procedure WriteDeclarations;
    procedure WriteContractor;
    procedure WriteNilReturn;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteXMLToFile(const FileName : string);

    property SubContractors : TCISSubContractors read FSubContractors;
    property ProductName : string Index 1 read GetString write SetString;
    property ProductVersion : string Index 2 read GetString write SetString;
    property SenderID : string Index 3 read GetString write SetString;
    property SenderAuthentication : string Index 4 read GetString write SetString;
    property TaxOfficNumber : string Index 5 read GetString write SetString;
    property TaxOfficeReference : string Index 6 read GetString write SetString;
    property VendorID : string Index 7 read GetString write SetString;
    property CurrencyCode : string Index 8 read GetString write SetString;
    property ContractorUTR : string Index 9 read GetString write SetString;
    property ContractorAORef : string Index 10 read GetString write SetString;
    property IRMark : string Index 11 read GetString;

    property Month : Integer Index 1 read GetInt write SetInt;
    property Year : Integer Index 2 read GetInt write SetInt;

    property NilIndicator : Boolean Index 1 read GetBool write SetBool;
    property EmploymentStatus : Boolean Index 2 read GetBool write SetBool;
    property SubContractorVerification : Boolean Index 3 read GetBool write SetBool;
    property Inactivity : Boolean Index 4 read GetBool write SetBool;
    property TestMessage : Boolean Index 5 read GetBool write SetBool;
  end;

  TCISXMLReturn = Class(TCISXMLBase)
    constructor Create;
  end;

  TCISXMLVerification = Class(TCISXMLBase)
    constructor Create;
  end;



implementation

uses
  SysUtils, InternetFiling_TLB, Dialogs;

const
  {$I VerModu.pas}

  YesNoString : Array[False..True] of String = (YN_NO, YN_YES);

{ TCISXMLBase }

constructor TCISXMLBase.Create;
begin
  FDocument := TGmXML.Create(nil);
  FDocument.Encoding := 'UTF-8';
  FSubContractors := TCISSubContractors.Create;
  FSubContractors.Document := FDocument;
  FillChar(FDataRec, SizeOf(FDataRec), 0);
  FDataRec.cisCurrency := 'GBP';
  FDataRec.cisProductName := EXCHEQUER_PRODUCT_NAME;
  FDataRec.cisProductVersion := CurrVersion;
  FSenderID := '';
  FSenderAuthentication := ''
end;

destructor TCISXMLBase.Destroy;
begin
  FDocument.Free;
  FSubContractors.Free;
  inherited;
end;

function TCISXMLBase.GetString(const Index: Integer): string;
begin
  Case Index of
    1  : Result := FDataRec.cisProductName;
    2  : Result := FDataRec.cisProductVersion;
    3  : Result := FSenderID;
    4  : Result := FSenderAuthentication;
    5  : Result := FDataRec.cisTaxOfficeNumber;
    6  : Result := FDataRec.cisTaxOfficeReference;
    7  : Result := FDataRec.cisVendorID;
    8  : Result := FDataRec.cisCurrency;
    9  : Result := FDataRec.cisContractorUTR;
   10  : Result := FDataRec.cisContractorAORef;
   11  : Result := FDataRec.cisIRMark;
  end;
end;

procedure TCISXMLBase.SetString(const Index: Integer; const Value: string);
begin
  Case Index of
    1  : FDataRec.cisProductName := Value;
    2  : FDataRec.cisProductVersion := Value;
    3  : FSenderID := Value;
    4  : FSenderAuthentication := Value;
    5  : FDataRec.cisTaxOfficeNumber := Value;
    6  : FDataRec.cisTaxOfficeReference := Value;
    7  : FDataRec.cisVendorID := Value;
    8  : FDataRec.cisCurrency := Value;
    9  : FDataRec.cisContractorUTR := Value;
   10  : FDataRec.cisContractorAORef := Value;
  end;
end;

procedure TCISXMLBase.WriteGovTalkDetails;
begin
  FDocument.Nodes.AddOpenTag(GOV_TALK_DETAILS);

  WriteKeys;
  
  FDocument.Nodes.AddOpenTag(GOV_TALK_TARGET);
  FDocument.Nodes.AddLeaf(GOV_TALK_TARGET_ORG).AsString := GOV_TALK_TARGET_ORG_VALUE;
  FDocument.Nodes.AddCloseTag; //Target

  //Channel
  FDocument.Nodes.AddOpenTag(GOV_TALK_CHANNEL_ROUTING);
  FDocument.Nodes.AddOpenTag(GOV_TALK_CHANNEL);
  FDocument.Nodes.AddLeaf(GOV_TALK_CHANNEL_URI).AsString := FDataRec.cisVendorID;
  FDocument.Nodes.AddLeaf(GOV_TALK_CHANNEL_PRODUCT).AsString := FDataRec.cisProductName;
  FDocument.Nodes.AddLeaf(GOV_TALK_CHANNEL_VERSION).AsString := FDataRec.cisProductVersion;
  FDocument.Nodes.AddCloseTag; //Channel
  FDocument.Nodes.AddCloseTag; //Channel Routing

  FDocument.Nodes.AddCloseTag; //GovTalk Details

end;

procedure TCISXMLBase.WriteMessageDetails;
begin
  FDocument.Nodes.AddOpenTag(MESSAGE_DETAILS);
  FDocument.Nodes.AddLeaf(MESSAGE_CLASS).AsString := MESSAGE_CLASS_RETURN;
  FDocument.Nodes.AddLeaf(MESSAGE_QUALIFIER).AsString := 'request';
  FDocument.Nodes.AddLeaf(MESSAGE_FUNCTION).AsString := 'submit';
  FDocument.Nodes.AddLeaf(MESSAGE_CORRELATION_ID);
  FDocument.Nodes.AddLeaf(MESSAGE_TRANSFORMATION).AsString := 'XML';
  if FDataRec.cisTestOnly then
    FDocument.Nodes.AddLeaf(MESSAGE_GATEWAY_TEST).AsInteger := 1
  else
    FDocument.Nodes.AddLeaf(MESSAGE_GATEWAY_TEST).AsInteger := 0;
  FDocument.Nodes.AddCloseTag;
end;

procedure TCISXMLBase.WriteSenderDetails;
begin
  FDocument.Nodes.AddOpenTag(SENDER_DETAILS);
  FDocument.Nodes.AddOpenTag(SENDER_ID_AUTHENTICATION_HEAD);
  FDocument.Nodes.AddLeaf(SENDER_ID).AsString := FSenderID;
  FDocument.Nodes.AddOpenTag(SENDER_ID_AUTHENTICATION);
  FDocument.Nodes.AddLeaf(SENDER_ID_METHOD).AsString := 'clear';
  FDocument.Nodes.AddLeaf(SENDER_ID_ROLE).AsString := 'principal';
  FDocument.Nodes.AddLeaf(SENDER_ID_VALUE).AsString := FSenderAuthentication;
  FDocument.Nodes.AddCloseTag; //Authentication
  FDocument.Nodes.AddCloseTag; //Authentication Head
  FDocument.Nodes.AddCloseTag; //Sender Details
end;

procedure TCISXMLBase.WriteGovTalkHeader;
begin
  //Start Header
  FDocument.Nodes.AddOpenTag(GOV_TALK_HEADER);

  WriteMessageDetails;
  WriteSenderDetails;

  FDocument.Nodes.AddCloseTag; //Header
  //End Header

  WriteGovTalkDetails;

end;

procedure TCISXMLBase.WriteXMLToFile(const FileName: string);
begin
  WriteMessage;
  FDocument.SaveToFile(FileName);
end;

procedure TCISXMLBase.WriteBody;
begin
  FDocument.Nodes.AddOpenTag(IR_BODY);
  with FDocument.Nodes.AddOpenTag(IR_ENVELOPE) do
    Attributes.AddAttribute(XMLNS, IR_CIS_URL);
  WriteIRHeader;
  WriteCISReturn;
  FDocument.Nodes.AddCloseTag; //Envelope
  FDocument.Nodes.AddCloseTag; //Body
end;

procedure TCISXMLBase.WriteCISReturn;
begin
  FDocument.Nodes.AddOpenTag(CIS_RETURN);
  WriteContractor;
  WriteNilReturn;
  FSubContractors.WriteItems;
  WriteDeclarations;
  FDocument.Nodes.AddCloseTag;
end;

procedure TCISXMLBase.WriteIRHeader;
begin
  FDocument.Nodes.AddOpenTag(IR_HEADER);
  WriteKeys;
  FDocument.Nodes.AddLeaf(IR_HEADER_PERIOD_END).AsString :=
     FormatPeriod(FDataRec.cisMonth, FDataRec.cisYear);
  FDocument.Nodes.AddLeaf(IR_HEADER_CURRENCY).AsString := FDataRec.cisCurrency;
  with FDocument.Nodes.AddLeaf(IR_HEADER_MARK) do
    Attributes.AddAttribute(GOV_TALK_TYPE, 'generic');
  FDocument.Nodes.AddLeaf(IR_HEADER_SENDER).AsString := SenderString;
  FDocument.Nodes.AddCloseTag;
end;

procedure TCISXMLBase.WriteKeys;
begin
  FDocument.Nodes.AddOpenTag(GOV_TALK_KEYS);
  with FDocument.Nodes.AddLeaf(GOV_TALK_KEY) do
  begin
    Attributes.AddAttribute(GOV_TALK_TYPE, TAX_OFFICE_NO);
    AsString := FDataRec.cisTaxOfficeNumber;
  end;
  with FDocument.Nodes.AddLeaf(GOV_TALK_KEY) do
  begin
    Attributes.AddAttribute(GOV_TALK_TYPE, TAX_OFFICE_REF);
    AsString := FDataRec.cisTaxOfficeReference;
  end;
  FDocument.Nodes.AddCloseTag; //Keys
end;

function TCISXMLBase.FormatPeriod(AMonth: Byte; AYear: Integer): string;
begin
  Result := Format('%d-%.2d-05', [AYear, AMonth]);
end;

procedure TCISXMLBase.WriteMessage;
begin
  FDocument.Nodes.Clear;

  with FDocument.Nodes.AddOpenTag(GOV_TALK_MESSAGE) do
    Attributes.AddAttribute(XMLNS, GOV_TALK_URL);
  FDocument.Nodes.AddLeaf(GOV_TALK_ENVELOPE_VERSION).AsString := GOV_TALK_ENVELOPE_VERSION_VALUE;

  WriteGovTalkHeader;
  WriteBody;

  FDocument.Nodes.AddCloseTag; //Message
  CreateIRMark;
end;

procedure TCISXMLBase.CreateIRMark;
//Uses Mark Green's FBI Components to calculate the IR Mark and add it into the xml
var
  FPosting: _Posting;
  wsXML : WideString;
begin
  FPosting := CoPosting.Create;
  Try
    wsXML := FDocument.Text;
    //Remove any tabs
    wsXML := StringReplace(wsXML, Chr(9), '', [rfReplaceAll]);
    FDataRec.cisIRMark := FPosting.AddIRMark(wsXML, 4);
    FDocument.Nodes.Clear;
    FDocument.Text := wsXML;
  Finally
    FPosting := nil;
  End;
end;

function TCISXMLBase.GetInt(const Index: Integer): Integer;
begin
  Case Index of
    1 : Result := FDataRec.cisMonth;
    2 : Result := FDataRec.cisYear;
  end;
end;

procedure TCISXMLBase.SetInt(const Index, Value: Integer);
begin
  Case Index of
    1 : FDataRec.cisMonth := Byte(Value);
    2 : FDataRec.cisYear := Value;
  end;
end;

function TCISXMLBase.SenderString: string;
begin
  Case FDataRec.cisIRSender of
    irsIndividual  :  Result := 'Individual';
    irsCompany     :  Result := 'Company';
    irsAgent       :  Result := 'Agent';
    irsBureau      :  Result := 'Bureau';
    irsPartnership :  Result := 'Partnership';
    irsTrust       :  Result := 'Trust';
    irsGovernment  :  Result := 'Government';
    irsOther       :  Result := 'Other';
  end;
end;

procedure TCISXMLBase.WriteDeclarations;
begin
  FDocument.Nodes.AddOpenTag(CIS_DECLARATIONS);
  if not FDataRec.cisInactivity then
  begin
    FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_EMPLOYMENT_STATUS).AsString :=
        YesNoString[FDataRec.cisEmploymentStatus];
    FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_VERIFICATION).AsString :=
        YesNoString[FDataRec.cisSubContractorVerification];
  end;
  FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_INFORMATION_CORRECT).AsString := YN_YES;
  if FDataRec.cisInactivity then
    FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_INACTIVITY).AsString := YN_YES;
  FDocument.Nodes.AddCloseTag;
end;

procedure TCISXMLBase.WriteContractor;
begin
  FDocument.Nodes.AddOpenTag(CIS_CONTRACTOR);
  FDocument.Nodes.AddLeaf(CIS_CONTRACTOR_UTR).AsString :=  FDataRec.cisContractorUTR;
  FDocument.Nodes.AddLeaf(CIS_CONTRACTOR_AOREF).AsString := FDataRec.cisContractorAORef;
  FDocument.Nodes.AddCloseTag;
end;

function TCISXMLBase.GetBool(const Index: Integer): Boolean;
begin
  Case Index of
    1 : Result := FDataRec.cisNilIndicator;
    2 : Result := FDataRec.cisEmploymentStatus;
    3 : Result := FDataRec.cisSubContractorVerification;
    4 : Result := FDataRec.cisInactivity;
    5 : Result := FDataRec.cisTestOnly;
  end;
end;

procedure TCISXMLBase.SetBool(const Index: Integer; const Value: Boolean);
begin
  Case Index of
    1 : FDataRec.cisNilIndicator := Value;
    2 : FDataRec.cisEmploymentStatus := Value;
    3 : FDataRec.cisSubContractorVerification := Value;
    4 : FDataRec.cisInactivity := Value;
    5 : FDataRec.cisTestOnly := Value;
  end;
end;

procedure TCISXMLBase.WriteNilReturn;
begin
  if FDataRec.cisNilIndicator then
    FDocument.Nodes.AddLeaf(CIS_NIL_RETURN).AsString := YN_YES;
end;

{ TCISSubContractor }

function TCISSubContractor.GetDouble(const Index: Integer): Double;
begin
  Case Index of
    1 : Result := FDataRec.scTotalPayments;
    2 : Result := FDataRec.scCostOfMaterials;
    3 : Result := FDataRec.scTotalDeducted;
  end;
end;

function TCISSubContractor.GetString(const Index: Integer): string;
begin
  Case Index of
    1 : Result := FDataRec.scForeName1;
    2 : Result := FDataRec.scForeName2;
    3 : Result := FDataRec.scSurName;
    4 : Result := FDataRec.scTradingName;
    5 : Result := FDataRec.scUTR;
    6 : Result := FDataRec.scNINO;
    7 : Result := FDataRec.scCRN;
    8 : Result := FDataRec.scVerificationNo;
  end;
end;

function TCISSubContractor.GetUnmatchedRate: Boolean;
begin
  Result := FDataRec.scUnMatchedRate;
end;

procedure TCISSubContractor.SetDouble(const Index: Integer;
  const Value: Double);
begin
  Case Index of
    1 : FDataRec.scTotalPayments := Value;
    2 : FDataRec.scCostOfMaterials := Value;
    3 : FDataRec.scTotalDeducted := Value;
  end;
end;

procedure TCISSubContractor.SetString(const Index: Integer;
  const Value: string);
begin
  Case Index of
    1 : FDataRec.scForeName1 := Value;
    2 : FDataRec.scForeName2 := Value;
    3 : FDataRec.scSurName := Value;
    4 : FDataRec.scTradingName := Value;
    5 : FDataRec.scUTR := Value;
    6 : FDataRec.scNINO := Value;
    7 : FDataRec.scCRN := Value;
    8 : FDataRec.scVerificationNo := Value;
  end;
end;

procedure TCISSubContractor.SetUnmatchedRate(const Value: Boolean);
begin
   FDataRec.scUnMatchedRate := Value;
end;

{ TCISSubContractors }

function TCISSubContractors.Add: TCISSubContractor;
begin
  Result := TCISSubContractor.Create;
  FList.Add(Result);
end;

constructor TCISSubContractors.Create;
begin
  FList := TObjectList.Create(True);
end;

function TCISSubContractors.Delete(Index: Integer): Integer;
begin
  FList.Delete(Index);
end;


destructor TCISSubContractors.Destroy;
begin
  FList.Free;
  inherited;
end;

function TCISSubContractors.GetItem(Index: Integer): TCISSubContractor;
begin
  Result := TCISSubContractor(FList.Items[Index]);
end;

procedure TCISSubContractors.WriteItem(SubContractor : TCISSubContractor);

  procedure WriteOptionalString(const Tag, Value : string);
  begin
    if Trim(Value) <> '' then
      FDocument.Nodes.AddLeaf(Tag).AsString := Value;
  end;

  procedure WriteOptionalDouble(const Tag : string; Value : Double);
  begin
    if Value <> 0.00 then
      FDocument.Nodes.AddLeaf(Tag).AsString := Format('%8.2f',[Value]);
  end;

begin
  FDocument.Nodes.AddOpenTag(CIS_SUBCONTRACTOR);

  if SubContractor.TradingName <> '' then
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_TRADINGNAME).AsString := SubContractor.TradingName
  else
  begin
    FDocument.Nodes.AddOpenTag(CIS_SUBCONTRACTOR_NAME);
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_FORENAME).AsString := SubContractor.Forename1;
    if SubContractor.Forename2 <> '' then
      FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_FORENAME).AsString := SubContractor.Forename2;
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_SURNAME).AsString := SubContractor.Surname;
    FDocument.Nodes.AddCloseTag;
  end;

  if SubContractor.UnmatchedRate then
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_UNMATCHED_RATE).AsString := YN_YES;

  WriteOptionalString(CIS_SUBCONTRACTOR_UTR, SubContractor.UTR);
  WriteOptionalString(CIS_SUBCONTRACTOR_NINO, SubContractor.NINO);
  WriteOptionalString(CIS_SUBCONTRACTOR_CRN, SubContractor.CRN);
  WriteOptionalString(CIS_SUBCONTRACTOR_VERIFICATION_NO, SubContractor.VerificationNumber);

  WriteOptionalDouble(CIS_SUBCONTRACTOR_TOTAL_PAYMENTS, SubContractor.TotalPayments);
  WriteOptionalDouble(CIS_SUBCONTRACTOR_COST_OF_MATERIALS, SubContractor.CostOfMaterials);
  WriteOptionalDouble(CIS_SUBCONTRACTOR_TOTAL_DEDUCTED, SubContractor.TotalDeducted);

  FDocument.Nodes.AddCloseTag;
end;

procedure TCISSubContractors.WriteItems;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
    WriteItem(FList[i] as TCISSubContractor);
end;

{ TCISXMLReturn }

constructor TCISXMLReturn.Create;
begin
  inherited Create;
  FDataRec.cisType := cisReturn;
end;

{ TCISXMLVerification }

constructor TCISXMLVerification.Create;
begin
  inherited Create;
  FDataRec.cisType := cisVerification;
end;

end.
