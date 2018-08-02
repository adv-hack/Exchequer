unit CISWrite;

interface

uses
 Contnrs, GMXML, CISXCnst;

Type
  TCISMessageType = (cisReturn, cisVerification);

  TIRSender = (irsIndividual, irsCompany, irsAgent, irsBureau, irsPartnership, irsTrust,
                    irsGovernment, irsOther);

  TSCAction = (scaMatch, scaVerify);
  TSCType = (sctSoleTrader, sctPartnership, sctTrust, sctCompany);


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
    scAction : TSCAction;
    scType   : TSCType;
    scPartnershipName : string[56];
    scPartnershipUTR : string[12];
    // VDM: 25/01/2007  Subcontractors field
    scWorksRef: String[20];
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
    function GetAction: TSCAction;
    function GetType: TSCType;
    procedure SetAction(const Value: TSCAction);
    procedure SetType(const Value: TSCType);
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
    property Action : TSCAction read GetAction write SetAction;
    property BusinessType : TSCType read GetType write SetType;
    property PartnershipName : string Index 9 read GetString write SetString;
    property PartnershipUTR : string Index 10 read GetString write SetString;
    // VDM: 25/01/2007 Subcontractors field
    property WorksRef: String index 11 read GetString write SetString;
    //
  end;

  TCISSubContractors = Class
  private
    FList : TObjectList;
    FDocument : TGmXML;
    FMessageType : TCISMessageType;
    function GetItem(Index: Integer): TCISSubContractor;
    procedure WriteItem(SubContractor : TCISSubContractor);
    function GetMessageType: TCISMessageType;
    procedure SetMessageType(const Value: TCISMessageType);
  public
    constructor Create;
    destructor Destroy; override;
    function Add : TCISSubContractor;
    procedure Delete(Index : Integer);
    procedure WriteItems;
    property Items[Index : Integer] : TCISSubContractor read GetItem;
    property Document : TGmXML read FDocument write FDocument;
    property MessageType : TCISMessageType read GetMessageType write SetMessageType;
  end;

  //----------------------------------------------------------------------------
  TCISXMLBase = Class
  private
    FSubContractors : TCISSubContractors;
    FSenderID,
    FSenderAuthentication : String;
    function GetInt(const Index: Integer): Integer;
    procedure SetInt(const Index, Value: Integer);
    function GetBool(const Index: Integer): Boolean;
    procedure SetBool(const Index: Integer; const Value: Boolean);
  protected
    // ABSEXCH-13793. Made protected so that derived classes can access them.
    FDocument : TGmXML;
    FDataRec : TCISMessageRec;
    fEncoding: String;

    function GetString(const Index: Integer): string;
    procedure SetString(const Index: Integer; const Value: string);
    procedure WriteGovTalkHeader;
    
    // ABSEXCH-13793. Made Virtual so they can be overridden in derived classes.
    //  This lets us use create similar GovTalk format XML files.
    procedure WriteMessageDetails; virtual;
    procedure WriteSenderDetails; virtual;
    procedure WriteGovTalkDetails; virtual;
    procedure WriteBody; virtual;
    procedure WriteIRHeader; virtual;
    procedure WriteCISReturn;
    procedure WriteKeys; virtual;
    procedure CreateIRMark; virtual;
    function SenderString : string; virtual;
    
    procedure WriteMessage;
    function FormatPeriod(AMonth : Byte; AYear : Integer) : string;
    procedure WriteDeclarations;
    procedure WriteContractor;
    procedure WriteNilReturn;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteXMLToFile(const FileName : string); virtual;

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

    // VDM: 08/03/2007 sender type
    property IRSender: String index 12 read GetString write SetString;

    property Month : Integer Index 1 read GetInt write SetInt;
    property Year : Integer Index 2 read GetInt write SetInt;

    property NilIndicator : Boolean Index 1 read GetBool write SetBool;
    property EmploymentStatus : Boolean Index 2 read GetBool write SetBool;
    property SubContractorVerification : Boolean Index 3 read GetBool write SetBool;
    property Inactivity : Boolean Index 4 read GetBool write SetBool;
    property TestMessage : Boolean Index 5 read GetBool write SetBool;

    // VDM: 30/01/2007 Subcontractors field
    property Encoding: String read fEncoding write fEncoding;
  end;
  //----------------------------------------------------------------------------

  TCISXMLReturn = Class(TCISXMLBase)
    constructor Create;
  end;

  TCISXMLVerification = Class(TCISXMLBase)
    constructor Create;
  end;

function IRSenderStrtoType(const pValue: String): TIRSender;

implementation

uses
  SysUtils, InternetFiling_TLB, Dialogs, ActiveX, Classes;

const
  {$I W:\Entrprse\R&D\VerModu.pas}

  YesNoString : Array[False..True] of String = (YN_NO, YN_YES);

  SCActionString : Array[scaMatch..scaVerify] of string = ('match', 'verify');
  SCTypeString   : Array[sctSoleTrader..sctCompany] of string = ('soletrader','partnership',
                                                                 'trust','company');

  // VDM: 08/03/2007 support sender type
  SCIRSender : array[irsIndividual..irsOther] of String = (cIRSenderIndividual, cIRSenderCompany,
    cIRSenderAgent, cIRSenderBureau, cIRSenderPartnership, cIRSenderTrust,
    cIRSenderGovernment, cIRSenderOther);

// VDM: 08/03/2007  convert a sender string to tirsender type
//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 If no valid return type found then raise exception.
function IRSenderStrtoType(const pValue: String): TIRSender;
var
  lCont: Integer;
  Found : Boolean;
begin
  Result := TIRSender(0);
  Found := False;
  for lCont:= Ord(Low(SCIRSender)) to Ord(High(SCIRSender)) do
    if lowercase(SCIRSender[TIRSender(lCont)]) = lowercase(pValue) then
    begin
      Result := TIRSender(lCont);
      Found := True;
      Break;
    end;

  if not Found then
    raise Exception.Create('Unknown IR Sender in IRSenderStrtoType: ' + QuotedStr(pValue));
end;


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

  // VDM: 12/03/2007  field is not being set by exchequer...
  VendorID := EXCHEQUER_VENDOR_ID;
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
   // VDM: 08/03/2007
   12  : Result := SCIRSender[FDataRec.cisIRSender];
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
   // VDM: 08/03/2007
   12  : FDataRec.cisIRSender := IRSenderStrtoType(Trim(Value));
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

  // VDM: 25/01/2007 Subcontractors verification
  //FDocument.Nodes.AddLeaf(MESSAGE_CLASS).AsString := MESSAGE_CLASS_RETURN;
  case FDataRec.cisType of
    cisReturn : FDocument.Nodes.AddLeaf(MESSAGE_CLASS).AsString := MESSAGE_CLASS_RETURN;
    cisVerification: FDocument.Nodes.AddLeaf(MESSAGE_CLASS).AsString := MESSAGE_CLASS_VERIFY;
  end;

  FDocument.Nodes.AddLeaf(MESSAGE_QUALIFIER).AsString := 'request';
  FDocument.Nodes.AddLeaf(MESSAGE_FUNCTION).AsString := 'submit';
  FDocument.Nodes.AddLeaf(MESSAGE_CORRELATION_ID);
  FDocument.Nodes.AddLeaf(MESSAGE_TRANSFORMATION).AsString := 'XML';

//  if FDataRec.cisTestOnly then
//    FDocument.Nodes.AddLeaf(MESSAGE_GATEWAY_TEST).AsInteger := 1
//  else
//    FDocument.Nodes.AddLeaf(MESSAGE_GATEWAY_TEST).AsInteger := 0;
  // VDM: 01/06/2007 James reported that some sites are not able to send their submissions
  // because the test gateway node is zero!! the ggw spec says that 0 IS acceptable!
  if FDataRec.cisTestOnly then
    FDocument.Nodes.AddLeaf(MESSAGE_GATEWAY_TEST).AsString := '1';
//  else
//    FDocument.Nodes.AddLeaf(MESSAGE_GATEWAY_TEST).AsString := '';

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
    // VDM: 25/01/2007 Subcontractors verification
    //Attributes.AddAttribute(XMLNS, IR_CIS_URL)
    case FDataRec.cisType of
      cisReturn: Attributes.AddAttribute(XMLNS, IR_CIS_URL);
      cisVerification: Attributes.AddAttribute(XMLNS, IR_CIS_URL_REQUEST);
    end;

  WriteIRHeader;
  WriteCISReturn;
  FDocument.Nodes.AddCloseTag; //Envelope
  FDocument.Nodes.AddCloseTag; //Body
end;

procedure TCISXMLBase.WriteCISReturn;
begin
  // VDM: 25/01/2007 Subcontractors verification
  //FDocument.Nodes.AddOpenTag(CIS_RETURN);  original
  case FDataRec.cisType of
    cisReturn: FDocument.Nodes.AddOpenTag(CIS_RETURN);
    cisVerification: FDocument.Nodes.AddOpenTag(CIS_REQUEST);
  end;

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


  {retrieve necessary name space to be able to create the irmark}
  function GetNameSpace(pXML: WideString): String;
  var
    lXml : TGmXML;
  begin
    lXml := TGmXML.Create(nil);
    lXml.Text := pXML;

    with lXml.Nodes do
    try
      Result := NodeByName[IR_ENVELOPE].Attributes.ElementByName[XMLNS].Value;
    finally
      lXMl.Free;
    end; {with lXml.Nodes do}
  end; {function GetNameSpace(pXML: WideString): String;}


var
  FPosting: _Posting;
  wsXML : WideString;
  lNameSpace: WideString;
begin
  CoInitialize(nil);
  FPosting := CoPosting.Create;
  Try
    wsXML := FDocument.Text;
    //Remove any tabs
    wsXML := StringReplace(wsXML, Chr(9), '', [rfReplaceAll]);

    // VDM: 25/01/2007
    wsXML := StringReplace(wsXML, #13, '', [rfReplaceAll]);
    wsXML := StringReplace(wsXML, #10, '', [rfReplaceAll]);
    //

    lNameSpace := GetNameSpace(wsXML);

    //FDataRec.cisIRMark := FPosting.AddIRMark(wsXML, 4);

    // VDM: 25/01/2007  added to support namespaces instead of numbers...
    if Trim(lNameSpace) = '' then
      FDataRec.cisIRMark := FPosting.AddIRMark(wsXML, 4)
    else
      FDataRec.cisIRMark := FPosting.AddIRMark_2(wsXML, lNameSpace);
    //


    FDocument.Nodes.Clear;

    FDocument.Text := wsXML;

    // VDM: 30/01/2007  added to support GGW encoding
    if Trim(fEncoding) <> '' then
      FDocument.Encoding := fEncoding;
    //  
  Finally
    FPosting := nil;
  End;

  CoUninitialize;
end;

function TCISXMLBase.GetInt(const Index: Integer): Integer;
begin
  Case Index of
    1 : Result := FDataRec.cisMonth;
    2 : Result := FDataRec.cisYear;
    else  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
      raise Exception.Create('Invalid index in TCISXMLBase.GetInt: ' + IntToStr(Index));
  end
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
    irsIndividual  :  Result := cIRSenderIndividual; //'Individual';
    irsCompany     :  Result := cIRSenderCompany; //'Company';
    irsAgent       :  Result := cIRSenderAgent; //'Agent';
    irsBureau      :  Result := cIRSenderBureau; //'Bureau';
    irsPartnership :  Result := cIRSenderPartnership; //'Partnership';
    irsTrust       :  Result := cIRSenderTrust; //'Trust';
    irsGovernment  :  Result := cIRSenderGovernment; //'Government';
    irsOther       :  Result := cIRSenderOther; //'Other';
  end;

end;

procedure TCISXMLBase.WriteDeclarations;
begin
  // added by vini
(*  original
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
  *)

  case FDataRec.cisType of
    cisReturn :
    begin
      FDocument.Nodes.AddOpenTag(CIS_DECLARATIONS);
      // VDM: 12/03/2007   EMPLOYMENT_STATUS field not being set correctly
(*      if not FDataRec.cisInactivity then
      begin
        FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_EMPLOYMENT_STATUS).AsString :=
            YesNoString[FDataRec.cisEmploymentStatus];
        FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_VERIFICATION).AsString :=
            YesNoString[FDataRec.cisSubContractorVerification];
      end;*)

//      if FDataRec.cisEmploymentStatus then
        FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_EMPLOYMENT_STATUS).AsString :=
            YesNoString[FDataRec.cisEmploymentStatus];

//      if FDataRec.cisSubContractorVerification then
        FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_VERIFICATION).AsString :=
            YesNoString[FDataRec.cisSubContractorVerification];

      FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_INFORMATION_CORRECT).AsString := YN_YES;

      if FDataRec.cisInactivity then
        FDocument.Nodes.AddLeaf(CIS_DECLARATIONS_INACTIVITY).AsString := YN_YES;
        
      FDocument.Nodes.AddCloseTag;
    end;
    cisVerification: FDocument.Nodes.AddLeaf(CIS_DECLARATION).AsString := YN_YES;
  end;

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
    else  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
      raise Exception.Create('Invalid index in TCISXMLBase.GetBool: ' + IntToStr(Index));

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


function TCISSubContractor.GetAction: TSCAction;
begin
  Result := FDataRec.scAction;
end;

function TCISSubContractor.GetDouble(const Index: Integer): Double;
begin
  Case Index of
    1 : Result := FDataRec.scTotalPayments;
    2 : Result := FDataRec.scCostOfMaterials;
    3 : Result := FDataRec.scTotalDeducted;
    else  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
      raise Exception.Create('Invalid index in TCISXMLBase.GetDouble: ' + IntToStr(Index));
  end
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
    9 : Result := FDataRec.scPartnershipName;
   10 : Result := FDataRec.scPartnershipUTR;
   // VDM: 25/01/2007 Subcontractors field
   11 : Result := FDataRec.scWorksRef;
   //
  end;
end;

function TCISSubContractor.GetType: TSCType;
begin
  Result := FDataRec.scType;
end;

function TCISSubContractor.GetUnmatchedRate: Boolean;
begin
  Result := FDataRec.scUnMatchedRate;
end;

procedure TCISSubContractor.SetAction(const Value: TSCAction);
begin
  FDataRec.scAction := Value;
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
    9 : FDataRec.scPartnershipName := Value;
   10 : FDataRec.scPartnershipUTR := Value;
   // VDM: 25/01/2007 Subcontractors field
   11 : FDataRec.scWorksRef := Value;
   //
  end;
end;

procedure TCISSubContractor.SetType(const Value: TSCType);
begin
  FDataRec.scType := Value;
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

//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed function to procedure 
procedure TCISSubContractors.Delete(Index: Integer);
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

function TCISSubContractors.GetMessageType: TCISMessageType;
begin
  Result := FMessageType;
end;

procedure TCISSubContractors.SetMessageType(const Value: TCISMessageType);
begin
  FMessageType := Value;
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

  procedure WritePartnership;
  begin
    if SubContractor.BusinessType = sctPartnership then
    begin
      FDocument.Nodes.AddOpenTag(CIS_SUBCONTRACTOR_PARTNERSHIP);
      FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_NAME).AsString := SubContractor.PartnershipName;

      // VDM: 16/03/2007  seem that ggw failed if we include name and an empty utr node (verificaton only)...
      if FMessageType = cisVerification then
      begin
        if trim(SubContractor.PartnershipUTR) <> '' then
          FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_UTR).AsString := SubContractor.PartnershipUTR;
      end    
      else
        FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_UTR).AsString := SubContractor.PartnershipUTR;

      FDocument.Nodes.AddCloseTag;
    end;
  end;

begin
  FDocument.Nodes.AddOpenTag(CIS_SUBCONTRACTOR);
  //PR: 05/03/2007 Only need Action & BusinessType for Verification
  if FMessageType = cisVerification then
  begin
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_ACTION).AsString := SCActionString[SubContractor.Action];
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_TYPE).AsString :=
                SCTypeString[SubContractor.BusinessType];
  end;


  if SubContractor.TradingName <> '' then
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_TRADINGNAME).AsString := SubContractor.TradingName
  else
  // VDM: 26/01/2007 name is optional
  if (Trim(SubContractor.Forename1) <> '') and (Trim(SubContractor.Surname) <> '') then
  begin
    FDocument.Nodes.AddOpenTag(CIS_SUBCONTRACTOR_NAME);
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_FORENAME).AsString := SubContractor.Forename1;
    if SubContractor.Forename2 <> '' then
      FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_FORENAME).AsString := SubContractor.Forename2;
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_SURNAME).AsString := SubContractor.Surname;
    FDocument.Nodes.AddCloseTag;
  end;

  // VDM: 25/01/2007 Subcontractors verification
  if SubContractor.WorksRef <> '' then
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_WORKSREF).AsString := SubContractor.WorksRef;


  if SubContractor.UnmatchedRate then
    FDocument.Nodes.AddLeaf(CIS_SUBCONTRACTOR_UNMATCHED_RATE).AsString := YN_YES;

  WriteOptionalString(CIS_SUBCONTRACTOR_UTR, SubContractor.UTR);
  WriteOptionalString(CIS_SUBCONTRACTOR_CRN, SubContractor.CRN);
  WriteOptionalString(CIS_SUBCONTRACTOR_NINO, SubContractor.NINO);

  // VDM: 25/01/2007 Subcontractors partnership is optional
  // WritePartnership; original
  if (SubContractor.BusinessType = sctPartnership) and (SubContractor.PartnershipName <> '') then
    WritePartnership;

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
  FSubContractors.MessageType := cisReturn;
end;

{ TCISXMLVerification }

constructor TCISXMLVerification.Create;
begin
  inherited Create;
  FDataRec.cisType := cisVerification;
  FSubContractors.MessageType := cisVerification;
end;

end.
