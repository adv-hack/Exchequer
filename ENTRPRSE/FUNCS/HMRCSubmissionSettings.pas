unit HMRCSubmissionSettings;
{ HMRCSubmissionSettings.pas
 PL 28/06/2017 2017-R2
 ABSEXCH-18567 VAT100 - new Test URL
 ABSEXCH-18566 Govlink - Change TEST URL}

interface
uses SysUtils, MSXML2_TLB;


type
  THMRCSubmissionSetting = class(TObject)
  private
    FGOVLINK_LIVE_URL,
    FGOVLINK_DEV_URL,
    FVAT100_LIVE_URL,
    FVAT100_DEV_URL,
    FErrorMessageGovLive,
    FErrorMessageGovTest,
    FErrorMessageVATLive,
    FErrorMessageVATTest : string;
    FXML: IXMLDOMDocument;

    procedure InitURLs();
    function GetErrorCode: Integer;
    function GetErrorReason : string;
    function ReadErroMessage(index : Integer): String;

  public
    constructor Create;
    destructor Destroy; override;

    Property GOVLINK_LIVE_URL : String read FGOVLINK_LIVE_URL;
    Property GOVLINK_DEV_URL  : String read FGOVLINK_DEV_URL;
    Property VAT100_LIVE_URL    : String read FVAT100_LIVE_URL;
    Property VAT100_DEV_URL     : String read FVAT100_DEV_URL;
    property ErrorCode : Integer read GetErrorCode;
    property ErrorReason : String read GetErrorReason;
    property ErrorMessageGovLive : string read FErrorMessageGovLive;
    property ErrorMessageGovTest : string read FErrorMessageGovTest;
    property ErrorMessageVATLive : string read FErrorMessageVATLive;
    property ErrorMessageVATTest : string read FErrorMessageVATTest;
  end;

  function HMRCSubmissionSetting : THMRCSubmissionSetting;

implementation

uses  FileUtil;

var
  FHMRCSubmissionSetting  : THMRCSubmissionSetting;

{ THMRCSubmissionSettings}

function HMRCSubmissionSetting : THMRCSubmissionSetting;
begin
  if not Assigned(FHMRCSubmissionSetting) then
    FHMRCSubmissionSetting  := THMRCSubmissionSetting.Create;

  Result := FHMRCSubmissionSetting;
end;

constructor THMRCSubmissionSetting.Create;
begin
  inherited Create;

  FGOVLINK_LIVE_URL   := EmptyStr;
  FGOVLINK_DEV_URL    := EmptyStr;
  FVAT100_LIVE_URL    := EmptyStr;
  FVAT100_DEV_URL     := EmptyStr;
  FErrorMessageGovLive := EmptyStr;
  FErrorMessageGovTest := EmptyStr;
  FErrorMessageVATLive := EmptyStr;
  FErrorMessageVATTest := EmptyStr;

  FXML := CoDOMDocument.Create as IXMLDOMDocument;
  InitURLs();

end;

destructor THMRCSubmissionSetting.Destroy;
begin
  inherited Destroy;
end;

//Returns Errorcode if any from XLM Parser.
function THMRCSubmissionSetting.GetErrorCode: Integer;
begin
  Result := 0;
  if Assigned(FXML) then
    Result := FXML.parseError.errorCode;
end;

//Returns Error reason from XLM Parser if there is any errorcode.
function THMRCSubmissionSetting.GetErrorReason : string;
begin
  Result := EmptyStr;
  if GetErrorCode <> 0 then
    Result := FXML.parseError.reason;

end;

{--------------------------------------------------------------------------
 Procedure to Read URLs and stroring into string when singleton object is
 being created.
---------------------------------------------------------------------------}
Procedure THMRCSubmissionSetting.InitURLs();
var
  lFilePath : string;
  lNode: IXMLDOMNode;
  I,
  J : Integer;
begin
  lFilepath := GetEnterpriseDirectory + 'HMRCSubmissionSettings.XML';
  FXML.Load(lFilepath);

  //Loading parent node to check the node childcount
  lNode := FXML.selectSingleNode('HMRCSubmissionSettings');
  J := lNode.childNodes.length;

  if (J>= 4) then {childcount check}
  begin
    for I := 1 to J do
    begin
      if Assigned(FXML) then
      begin
      // if desired node is there it'll read URL else it'll Read Error accordingly.
        case I of
          1 : begin
                lNode := FXML.selectSingleNode('HMRCSubmissionSettings/GOVLINK_LIVE');
                if  Assigned(lNode) then
                  FGOVLINK_LIVE_URL := lNode.text
                else
                  FErrorMessageGovLive := ReadErroMessage(i);
              end;

          2 : begin
                lNode := FXML.selectSingleNode('HMRCSubmissionSettings/GOVLINK_TEST');
                if  Assigned(lNode) then
                  FGOVLINK_DEV_URL  := lNode.text
                else
                  FErrorMessageGovTest := ReadErroMessage(i);
              end;

          3 : begin
                lNode := FXML.selectSingleNode('HMRCSubmissionSettings/VAT100_LIVE');
                if  Assigned(lNode) then
                  FVAT100_LIVE_URL  := lNode.text
                else
                  FErrorMessageVATLive := ReadErroMessage(i);
              end;

          4 : begin
                lNode := FXML.selectSingleNode('HMRCSubmissionSettings/VAT100_TEST');
                if  Assigned(lNode) then
                  FVAT100_DEV_URL   := lNode.text
                else
                  FErrorMessageVATTest := ReadErroMessage(i);
              end;
        end;
      end;
    end;
  end
  else  //if invalid XML file structure or number of node is lessthan 4
  begin  //Read errors for all the nodes
    for I:=1 to 4 do
    begin
      case I of
        1 : FErrorMessageGovLive := ReadErroMessage(I);

        2 : FErrorMessageGovTest := ReadErroMessage(I);

        3 : FErrorMessageVATLive := ReadErroMessage(I);

        4 : FErrorMessageVATTest := ReadErroMessage(I);
      end;
    end;
  end;
end;

//function to Return Error Messege according to node Indexing
function THMRCSubmissionSetting.ReadErroMessage(index : Integer): String;
begin
  case index of
    1 : Result := 'Error accesing node /HMRCSubmissionSettings/GOVLINK_LIVE. Error: Invalid XML node';

    2 : Result := 'Error accesing node /HMRCSubmissionSettings/GOVLINK_TEST. Error: Invalid XML node';

    3 : Result := 'Error accesing node /HMRCSubmissionSettings/VAT100_LIVE. Error: Invalid XML node';

    4 : Result := 'Error accesing node /HMRCSubmissionSettings/VAT100_TEST. Error: Invalid XML node';
  end;
end;


end.
