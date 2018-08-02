unit VATSub;
{$HINTS OFF}
(*
ABSEXCH-14371
VAT100 XML Submission form.

Requires FBI Components (for the time being).
Requires a directory structure like this, for each company:

%COMPANY_ROOT%\AUDIT\VAT100\Rawfiles\Sent\
%COMPANY_ROOT%\AUDIT\VAT100\Rawfiles\Received\

where %COMPANY_ROOT% is the directory where that company's data is stored.

--------------------------------------------------------------------------------
HMRC submissions work like this:

1) Submit XML file to HMRC site
2) Receive Acknowledgement from HMRC, containing a polling interval, a polling URL
   and a CorrelationID (whic identifies this transaction).
3) Poll the URL at the specified interval (typically 10 seconds), specifying the
   CorrelationID.
4) Receive a response from HMRC.  This will indicate whether the submission was
   successful or not.  It will list any errors in the submitted data.
5) Submit a Delete Request, specifying the CorrelationID.
6) Receive a Delete Response from HMRC.
7) Stop polling.

At step 4) above, another Acknowledgement may be received if they haven't 
 processed the submission yet (can happen at busy times), so keep polling until
 a response is received.

The conversation between Exchequer and HMRC is handled by the FBI COM object.
When FBI polls and receives a reply, it calls the supplied Callback function in
the host application.  In this case, it is the Callback function defined in
VAT100Callback.pas, which simply calls the Callback function on this form.

IMPORTANT NOTE:
Do not update the UI within the Callback method.  The FBI components call this
from a separate thread, which will cause problems when trying to update the UI.
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  VarConst,
  ComCtrls, ImgList, GlobVar, Printers,
  Clipbrd,
  SyncObjs, BtSupU1,
  HTTPApp,
  gmXML,
  COMObj,
  HMRCSubmissionSettings;

const
  vat100RootDir = 'AUDIT\VAT100\';  // Log file goes in here
  vatRawFiles   = 'RawFiles\';      // Generated XML goes in here
  InboxDir      = 'Received\';      // HMRC replies go in here
  OutboxDir     = 'Sent\';          // Generated XML moved to here on success
  LogFilename   = 'VAT100.log';     // Name of log file

  DEFAULT_POLL_INTERVAL = 10;       // Seconds
  DEFAULT_URL_ATOM      = 'localhost';
  DEFAULT_PORT          = '64193';

  maxDeleteRequests = 3;

  DISCLAIMER1 = 'IMPORTANT: THIS IS A TEST SUBMISSION ONLY.  ';
  DISCLAIMER2 = 'THE VAT RETURN WILL NOT BE PROCESSED BY HMRC';
  DISCLAIMER3 = 'UNTIL A LIVE SUBMISSION IS MADE.            ';

  crlf = chr(13) + chr(10);
type
  TSubStates = (ssIdle, ssSubmitted, ssPolling, ssDeleting, ssSuccess, ssHMRCError, ssSubError, ssError);
  // NB. ssHMRCError = error response from HMRC.
  //     ssError     = system failure on our side.
  //     ssSubError  = error in the submitted data.

  TVatReturnDetail = record
    period                 : string;
    VATDueOnOutputs        : double;
    VATDueOnECAcquisitions : double;
    TotalVAT               : double;
    VATReclaimedOnInputs   : double;
    NetVAT                 : double;
    NetSalesAndOutputs     : double;
    NetPurchasesAndInputs  : double;
    NetECSupplies          : double;
    NetECAcquisitions      : double;
  end;

type
  TURLType =(urlLive, urlTest);  //PL 28/06/2017 2017-R2 ABSEXCH-18567 VAT100 - new Test URL

  TVatSubForm = class(TForm)
    Panel1: TPanel;
    PageCtrl: TPageControl;
    sheetSubmission: TTabSheet;
    sheetNarrative: TTabSheet;
    richNarrative: TRichEdit;
    Panel3: TPanel;
    PrintDialog: TPrintDialog;
    Panel4: TPanel;
    Label1: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    lblVatPeriod: TLabel;
    lblBox1: TLabel;
    lblBox2: TLabel;
    lblBox3: TLabel;
    lblBox4: TLabel;
    lblBox5: TLabel;
    lblBox6: TLabel;
    lblBox7: TLabel;
    lblBox8: TLabel;
    lblBox9: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label6: TLabel;
    Shape28: TShape;
    Shape29: TShape;
    Shape30: TShape;
    Shape31: TShape;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    btnPanel: TPanel;
    btnSubmit: TButton;
    btnPrint: TButton;
    btnCancel: TButton;
    pnlTest: TPanel;
    grpSubmission: TRadioGroup;
    testCombo: TComboBox;
    Button2: TButton;
    errorSheet: TTabSheet;
    errorMemo: TMemo;
    Label15: TLabel;
    procedure btnSubmitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnPrintClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure testComboEnter(Sender: TObject);
    procedure testComboExit(Sender: TObject);
    procedure PageCtrlChange(Sender: TObject);
  private
    { Private declarations }
    fOwnerHandle : HWND;

    InXMLDoc : TgmXML;
    OutXMLDoc: TgmXML;

    URLatom          : string;
    URLPort          : string;

    FFilingServiceURL: string;

    // Response values from HMRC
    hmrcClass        : string;
    qualifier        : string;
    hmrcFunction     : string;
    transactionID    : string;
    correlationID    : string;
    responseEndPoint : string;
    gatewayTimestamp : string;
    // PKR. 17/10/2014. ABSEXCH-15740. Added to allow live site testing (TIL - Test-In-Live).
    submissionClass  : Widestring;
    submissionURL    : Widestring;

    submissionState  : TsubStates;

    // Mailbox data
    xmlFileName      : string;
    xmlReceipt       : string;

    returnDetail     : TVATReturnDetail;

    // The URL of the HMRC Filing Service
    serviceURL : string;

    procedure SubmitVATReturn;

    procedure GetHMRCResponseHeaderDetails(aNode : TgmXMLNode);
    procedure HandleHMRCMessage(aMessage : wideString);
    procedure ExtractHMRCErrors(aMessage : wideString);
    function  ConvertHMRCDateStamp(timeStamp : string) : string;

    procedure LogDisclaimer;
    procedure LogVATMessage(msgText : string);

    procedure ExtractVATReturnFields(aFilename : string; var aDetail : TVatReturnDetail);
    function  SetDocumentClass(aSubmissionClass : string; var aXmlDoc : TgmXML) : boolean;

    function StripResponseEnvelope(aResponse : string) : string;
    function ReinstateLTGT(aXML : widestring) : widestring;

    function ReturnSubmitted(aVatPer : string) : TSubStates;
    procedure ReadConfig;
//    function  SelectNode(xnRoot: IXmlNode; const nodePath: WideString): IXmlNode;

    {
      Sets up the URL for the web-service
    }
    procedure PrepareWebService;

    {
      Calls the Exchequer HMRCFiling web-service which handles submissions to
      HMRC. ServiceQuery should be the web-service query string (note that the
      CallWebService method supplies the actual web-server address, so this
      should not be included in the ServiceQuery).

      This method returns the web-service response. If the response was an
      empty string, an error occurred (and will have been reported to the
      user via the Error tab)
    }
    function CallWebService(ServiceQuery: WideString): WideString;
    procedure DisplayError(ErrorMessage: string);
    function GetURL(Const URLType : TURLType): string;
  public
    { Public declarations }
    companyRoot      : string;
    procedure SetXMLFile(xmlFile : string);
  published
    property OwnerHandle : HWnd read FOwnerHandle write FOwnerHandle;
  end;

procedure SetRichEditMargins(const mLeft, mRight, mTop, mBottom: extended;
                             const re : TRichEdit; const aPrinter : TPrinter);
function GetFileDate(TheFileName: string): string;

var
  VatSubForm : TVATSubForm;

implementation

uses
  SQLUtils,
  SQLCallerU,
  ADOConnect,
  CustIntU,
  Inifiles,
  FileUtil,
  ActiveX, VatXMLConst, vatUtils, StrUtil;

{$R *.dfm}


// -----------------------------------------------------------------------------

procedure TVatSubForm.FormCreate(Sender: TObject);
begin
  submissionState := ssIdle;

  // Set up the root location of the Inbox and Outbox folders
  // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings. Replace IncludeTrailingBackslash.
  companyRoot := IncludeTrailingPathDelimiter(SetDrive);

  btnPrint.Enabled := False;
  testCombo.ItemIndex := 0;

  errorSheet.TabVisible := False;

  InXMLDoc  := TgmXML.Create(self);
  OutXMLDoc := TgmXML.Create(self);
  OutXMLDoc.IncludeHeader := True;

  PrepareWebService;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.FormShow(Sender: TObject);
var
  obSuccess : Boolean;
  ibSuccess : Boolean;
begin
  if submissionState = ssError then
  begin
    Close;
  end;

  ReadConfig;

  PageCtrl.ActivePageIndex := 0;

  // Test whether the VAT100 folders are present.  If not, try to create them.
  // If that fails, then we cannot continue.
  {
  obSuccess := true;
  if not DirectoryExists(companyRoot + vat100RootDir + vatRawFiles + OutboxDir) then
  begin
    obSuccess := ForceDirectories(companyRoot + vat100RootDir + vatRawFiles + OutboxDir);
  end;

  ibSuccess := true;
  if not DirectoryExists(companyRoot + vat100RootDir + vatRawFiles + InboxDir) then
  begin
    ibSuccess := ForceDirectories(companyRoot + vat100RootDir + vatRawFiles + InboxDir);
  end;

  if (not obSuccess) or (not ibSuccess) then
  begin
    ShowMessage('Configuration error: The VAT100 working' + crlf +
                'directory structure can not be found or created.');
    Close;
  end;
  }

  // PKR. 16/10/2014. ABSEXCH-15736.  Only show the Use Test radio buttons if logged in as System.
  pnlTest.Visible := SBSIN;

  Screen.Cursor := crDefault;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { CJS 2013-08-09 - ABSEXCH-14525 - VAT100 form opens unnecessarily }
  Action := caFree;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.SetXMLFile(xmlFile : string);
begin
  xmlFilename := xmlFile;

  // Get the data from the XML file
  ExtractVATReturnFields(xmlFilename, returnDetail);

  // Display it in the UI fields
  lblVatPeriod.Caption := returnDetail.period;
  lblBox1.Caption := vatUtils.FormatVatValue_Double(returnDetail.VATDueOnOutputs);
  lblBox2.Caption := vatUtils.FormatVatValue_Double(returnDetail.VATDueOnECAcquisitions);
  lblBox3.Caption := vatUtils.FormatVatValue_Double(returnDetail.TotalVAT);
  lblBox4.Caption := vatUtils.FormatVatValue_Double(returnDetail.VATReclaimedOnInputs);
  lblBox5.Caption := vatUtils.FormatVatValue_Double(returnDetail.NetVAT);
  lblBox6.Caption := vatUtils.FormatVatValue_Int(returnDetail.NetSalesAndOutputs);
  lblBox7.Caption := vatUtils.FormatVatValue_Int(returnDetail.NetPurchasesAndInputs);
  lblBox8.Caption := vatUtils.FormatVatValue_Int(returnDetail.NetECSupplies);
  lblBox9.Caption := vatUtils.FormatVatValue_Int(returnDetail.NetECAcquisitions);
end;

//PL 28/06/2017 2017-R2 ABSEXCH-18567 VAT100 - new Test URL
//Function To Return Submission URLs
function TVatSubForm.GetURL(Const URLType : TURLType): string;
begin
  with HMRCSubmissionSetting do
  begin
    if (ErrorCode = 0) and (ErrorReason = EmptyStr)  then
    begin
      if (URLType= urlLive) then
      begin
        if VAT100_LIVE_URL <> EmptyStr then
          Result := VAT100_LIVE_URL
        else
          raise Exception.Create(ErrorMessageVATLive);
      end
      else
      begin
        if VAT100_DEV_URL <> EmptyStr then
          Result := VAT100_DEV_URL
        else
          raise Exception.Create(ErrorMessageVATTest);
      end;
    end
    else
      raise Exception.Create( 'Error loading HMRCSubmissionSettings.XML . Error: ' + ErrorReason );
  end;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.SubmitVATReturn;
Var
  Resp           : TStringStream ;
  ole            : OleVariant;
  user, pass     : string;
  gatewayXML     : WideString;
  serviceQuery   : WideString;
  logText        : string;
  docType        : widestring;
  submissionURL  : widestring;
  exchUsername   : widestring;
  response       : Widestring;
  errorString    : string;
begin
  // Get the username
  exchUsername := UserProfile^.UserName;

  if (Trim(XMLFileName) = '') or
     (not FileExists(XMLFileName)) then
  begin
    logText := 'System Error : No VAT 100 XML file specified';
    LogVATMessage(logText);
    submissionState := ssError;
  end
  else
  begin
    // Load the XML file
    try
      OutXMLDoc.LoadFromFile(XMLFileName, False);

      // PKR. 16/10/2014. ABSEXCH-15735. Set the correct URL and Class for submissions.
      // This override can only be done when logged in as System.
      case grpSubmission.ItemIndex of
        0:  begin
              //HV 14/05/2018 2018-R1.1 ABSEXCH-20505 : VAT100 : New Live URL From XML
              submissionURL := GetURL(urlLive);
              submissionClass := MESSAGE_CLASS_VAT_RETURN;
              docType := 'STD';
            end;
        1:  begin
              //HV 14/05/2018 2018-R1.1 ABSEXCH-20505 : VAT100 : New Live URL From XML
              submissionURL := GetURL(urlLive);
              submissionClass := MESSAGE_CLASS_VAT_RETURN_TIL;
              docType := 'TIL';
              LogVatMessage('Test-In-Live (TIL) selected');
              LogDisclaimer;
            end;
        2:  begin
              //PL 28/06/2017 2017-R2 ABSEXCH-18567 VAT100 - new Test URL
              submissionURL := GetURL(urlTest);

              submissionClass := MESSAGE_CLASS_VAT_RETURN;
              docType := 'DEV';
              LogVatMessage('Development Test (DEV) selected');
              LogDisclaimer;
            end;
      end;

      // We need to go in and modify the XML so that the <Class> element matches the selection.
      // No need to update the IR Mark because that is calculated only on the BODY of the message
      // and the Class is in the header.
      // Then save the updated file.
      SetDocumentClass(submissionClass, OutXmlDoc);

      gatewayXML := StringReplace(OutXMLDoc.Text, #13#10, '', [rfReplaceAll]);

      // CJS 2015-09-24 - ABSEXCH-16922 - HMRC Filing VAT Submissions xml folder
      // Submit the return to the HMRCFiling service.
      serviceQuery := Format('SubmitToHMRC?companycode=%s&doctype=%s&xmldoc=%s&filename=%s&suburl=%s&username=%s&email=%s',
                             [CustIntU.CustomisationCompanyCode, docType, gatewayXML, XMLFileName, submissionURL, exchUsername, '']);
      response := CallWebService(serviceQuery);
      response := Trim(StripResponseEnvelope(response));

      if (response <> '') then
      begin
        richNarrative.Lines.Add('Response received');
        richNarrative.Lines.Add(response);

        // Convert &lt; to <, and &gt; to >
        response := ReinstateLTGT(response);

        HandleHMRCMessage(response);
      end
      else
      begin
        submissionState := ssError;
        btnSubmit.Enabled := True;
        // At the moment the only possible error that returns an empty string
        // is where the submission had previously been submitted and is still
        // being polled.
        errorString := CallWebService('GetLastErrorString');
        DisplayError(errorString);
      end;
    except
      on E: Exception do
      begin
        logText := 'An error occurred submitting the VAT Return' + crlf + E.Message;
        LogVatMessage(logText);
        DisplayError(logText);
        submissionState := ssError;
        btnSubmit.Enabled := true;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

// Replaces the submission class element with the one specified

//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Set result in function
function TVatSubForm.SetDocumentClass(aSubmissionClass : string; var aXmlDoc : TgmXML) : boolean;
var
  rNode : TgmXMLNode;
  hNode : TgmXMLNode;
  mNode : TgmXMLNode;
  cNode : TgmXMLNode;
  found : boolean;
begin
  Result := False;
  found := false;
  rNode := aXmlDoc.Nodes.Root; // <GovTalkMessage>
  if (rNode.Children <> nil) then
  begin
    hNode := rNode.Children.NodeByName['Header'];
    if (hNode <> nil) and (hNode.Children <> nil) then
    begin
      mNode := hNode.Children.NodeByName['MessageDetails'];
      if (mNode <> nil) and (mNode.Children <> nil) then
      begin
        cNode := mNode.Children.NodeByName['Class'];
        if (cNode <> nil) then
        begin
          cNode.AsString := aSubmissionClass;
          Result := True;
        end;
      end;
    end;
  end;

  {
  while (hNode <> nil) and (i < hNode.Count) do
  begin
    if (hNode[i].Name = 'Header') then
    begin
      mNode := hNode[i].Children; // Look for <MessageDetails>
      if (mNode[0].Name = 'MessageDetails') then
      begin
        cNode := mNode.Children; // Look for <Class>
        if (cNode[0].Name = 'Class') then
        begin
          cNode.AsString := aSubmissionClass; // Replace the field with the new submission class.
          found := true; // Quick escape route from the nested loops.
          break;
        end;
        if found then
          break;
        cNode := cNode.NextSibling;
      end;
      if found then
        break;
      mNode := mNode.NextSibling;
    end;
    if found then
      break;
    i := i + 1;
  end;
  }
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.LogDisclaimer;
begin
  LogVatMessage(DISCLAIMER1);
  LogVatMessage(DISCLAIMER2);
  LogVatMessage(DISCLAIMER3);
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.HandleHMRCMessage(aMessage : wideString);
// There are two fields in the messages from HMRC that we use to determine how
// to handle the message.
// These are Qualifier and Function.
// Valid Functions are : submit, delete, and list (currently unused)
// Valid Qualifiers are: acknowledgement, response, and error.
var
  DestinationDir  : string;
  logText         : string;
  rootNode        : TgmXMLNode;
begin
  // ABSEXCH-14499. PKR. 02/08/2013.  Logic restructured to prevent continuous
  //  polling for messages after an error is received.

  // Determine whether the submission was successful or not
  // This is done by extracting the "Qualifier" node from the returned XML.
  // It will be one of "acknowledgement", "error" or "response"
  InXMLDoc.Nodes.Clear;
  InXMLDoc.Text := aMessage;

  try
    rootNode := inXMLDoc.Nodes.Root;  // Should be <GovTalkMessage> element

    if rootNode <> nil then
    begin
      GetHMRCResponseHeaderDetails(rootnode);

      //............................................................................
      if Lowercase(HMRCFunction) = 'submit' then
      begin
        if Lowercase(qualifier) = 'acknowledgement' then
        begin
          // Received an acknowledgement.  The service polls for the response, so all
          //  we have to do is display the acknowledgement.
          logText := 'Acknowledgement received from HMRC';
          richNarrative.Clear;
          richNarrative.Lines.Add(logText);
          richNarrative.Lines.Add(ConvertHMRCDatestamp(gatewayTimestamp));
          richNarrative.Lines.Add('');
          richNarrative.Lines.Add('HMRC Correlation ID : ' + CorrelationId);

          // Switch to the narrative tab
          PageCtrl.ActivePageIndex := 1;

          btnCancel.Caption := 'Close';

          submissionState := ssSuccess;
          LogVatMessage(logText);
        end;

        if Lowercase(qualifier) = 'error' then
        begin
          // Received a submission error from HMRC, so log it and delete the request
          // Save the XML response in the Received folder.

          // Delete the request and stop polling for a response.
          // ABSEXCH-14499. PKR. 01/08/2013.
          submissionState := ssSubError;

          xmlReceipt := StringReplace(ExtractFileName(xmlFilename), 'VAT', 'VATReceipt', [rfIgnoreCase]);
          InXMLDoc.SaveToFile(companyRoot + vat100RootDir + vatRawFiles + InboxDir + xmlReceipt);

          logText := 'Submission of VAT 100 Return was unsuccessful';
          LogVatMessage(logText);

          richNarrative.Clear;
          richNarrative.Lines.Add(logText);
          richNarrative.Lines.Add(gatewayTimestamp);
          richNarrative.Lines.Add('');
          richNarrative.Lines.Add('HMRC Correlation ID : ' + CorrelationId);

          btnCancel.Caption := 'Close';

          // Extract any Messages and Narrative elements from HMRCs reply and display them.
          ExtractHMRCErrors(aMessage);

          // Switch to the narrative tab
          PageCtrl.ActivePageIndex := 1;
        end;
      end; // 'submit' function
    end;
  except
    on E: Exception do
    begin
      DisplayError(E.Message);
      LogVatMessage(E.Message);
      submissionState := ssError;
    end;
  end;

  screen.Cursor := crDefault;
end;

// -----------------------------------------------------------------------------

// ABSEXCH-14506. PKR. 02/08/2013.  Display errors returned from HMRC.
procedure TVatSubForm.ExtractHMRCErrors(aMessage : wideString);
var
  rootNode  : TgmXMLNode;
  GovTalkErrorsNode : TgmXMLNode;
  ErrorNode : TgmXMLNode;
  FieldNode: TgmXMLNode;
  BodyNode : TgmXMLNode;
  ApplicationErrorsNode: TgmXMLNode;
  NodeIndex: Integer;
  ErrorNodeIndex : Integer;
begin
  // Traverse the XML to find the ErrorResponse
  inXMLDoc.Text := aMessage;

  richNarrative.Lines.Add('VAT100 Submission Error Report. ' + DateTimeToStr(Now));
  richNarrative.Lines.Add(' ');
  richNarrative.Lines.Add('Failed submission of VAT100 Return : ' + ExtractFileName(xmlFilename));
  richNarrative.Lines.Add(' ');

  rootNode := inXMLDoc.Nodes.Root;
  if (rootNode <> nil) and (rootNode.Children <> nil) then
  begin
    bodyNode := rootNode.Children.NodeByName['GovTalkDetails'];
    if (bodyNode <> nil) and (bodyNode.Children <> nil) then
    begin
      GovTalkErrorsNode := bodyNode.Children.NodeByName['GovTalkErrors'];
      if (GovTalkErrorsNode <> nil) and (GovTalkErrorsNode.Children <> nil) then
      begin
        // Process the error (there will only be one Error entry in this section)
        ErrorNode := GovTalkErrorsNode.Children.NodeByName['Error'];
        if (ErrorNode.Children <> nil) then
        begin
          // Extract the details from the error
          for ErrorNodeIndex := 0 to ErrorNode.Children.Count - 1 do
          begin
            FieldNode := ErrorNode.Children[ErrorNodeIndex];
            if FieldNode.Name = 'RaisedBy' then
              richNarrative.Lines.Add('Error raised by : ' + FieldNode.AsString);
            if FieldNode.Name = 'Number' then
              richNarrative.Lines.Add('Error number    : ' + FieldNode.AsString);
            if FieldNode.Name = 'Type' then
              richNarrative.Lines.Add('Error type      : ' + FieldNode.AsString);
            if FieldNode.Name = 'Text' then
              richNarrative.Lines.Add(FieldNode.AsString);
          end;
        end;
      end;
    end;

    BodyNode := rootNode.Children.NodeByName['Body'];
    if (BodyNode <> nil) and (BodyNode.Children <> nil) then
    begin
      ApplicationErrorsNode := BodyNode.Children.NodeByName['ErrorResponse'];
      if (ApplicationErrorsNode <> nil) and (ApplicationErrorsNode.Children <> nil) then
      begin
        ApplicationErrorsNode := ApplicationErrorsNode.Children.NodeByName['Application'];
        if (ApplicationErrorsNode <> nil) and (ApplicationErrorsNode.Children <> nil) then
        begin
          for NodeIndex := 0 to ApplicationErrorsNode.Children.Count - 1 do
          begin
            // Process the errors (there might be more than one)
            ErrorNode := ApplicationErrorsNode.Children[NodeIndex];
            if (ErrorNode.Name = 'Error') and (ErrorNode.Children <> nil) then
            begin
              // Extract the details from the error
              for ErrorNodeIndex := 0 to ErrorNode.Children.Count - 1 do
              begin
                FieldNode := ErrorNode.Children[ErrorNodeIndex];
                // PKR. 29/03/2016. ABSEXCH-173890. Remove Warnings from code.
                if FieldNode <> nil then
                begin
                  if FieldNode.Name = 'RaisedBy' then
                    richNarrative.Lines.Add('Error raised by : ' + FieldNode.AsString);
                  if FieldNode.Name = 'Number' then
                    richNarrative.Lines.Add('Error number    : ' + FieldNode.AsString);
                  if FieldNode.Name = 'Type' then
                    richNarrative.Lines.Add('Error type      : ' + FieldNode.AsString);
                  if FieldNode.Name = 'Text' then
                    richNarrative.Lines.Add(FieldNode.AsString);
                  if FieldNode.Name = 'Location' then
                    richNarrative.Lines.Add('Location        : ' + FieldNode.AsString);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

// Input string is in this format: 2013-07-16T14:18:08.539
function TVatSubForm.ConvertHMRCDateStamp(timeStamp : string) : string;
var
  year, month, day, hour, min, sec : string;
begin
  year  := Copy(timestamp,  1, 4);
  month := Copy(timestamp,  6, 2);
  day   := Copy(timestamp,  9, 2);
  hour  := Copy(timestamp, 12, 2);
  min   := Copy(timestamp, 15, 2);
  sec   := Copy(timestamp, 18, 2);
  // Note: Ignoring the number of milliseconds in the timestamp.

  Result := Format('%s/%s/%s %s:%s:%s', [year, month, day, hour, min, sec]);
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.GetHMRCResponseHeaderDetails(aNode : TgmXMLNode);
var
  headerNode : TgmXMLNode;
  msgDetNode : TgmXMLNode;
  hValNode   : TgmXMLNode;
  NodeIndex : Integer;
begin
  // Clear the fields
  if aNode.Children <> nil then
  begin
    try
      // Extract the fields from the header.
      headerNode := aNode.Children.NodeByName['Header'];
      if (headerNode <> nil) and (headerNode.Children <> nil) then
      begin
        msgDetNode := headerNode.Children.NodeByName['MessageDetails'];
        if (msgDetNode <> nil) and (msgDetNode.Children <> nil) then
        begin
          for NodeIndex := 0 to msgDetNode.Children.Count - 1 do
          begin
            hValNode := msgDetNode.Children[NodeIndex];
            if hValNode.Name = 'Class' then
              hmrcClass        := hValNode.AsString;

            if hValNode.Name = 'Qualifier' then
              qualifier        := hValNode.AsString;

            if hValNode.Name = 'Function' then
              hmrcFunction     := hValNode.AsString;

            if hValNode.Name = 'TransactionID' then
              transactionID    := hValNode.AsString;

            if hValNode.Name = 'CorrelationID' then
              // Don't change the CorrelationID if it's already been set.
              if correlationID = '' then
                correlationID    := hValNode.AsString;

            if hValNode.Name = 'ResponseEndPoint' then
            begin
              responseEndPoint := hValNode.AsString;
            end;

            if hValNode.Name = 'GatewayTimestamp' then
            begin
              gatewayTimestamp := hValNode.AsString;
            end;
          end;
        end;
      end;
    except
      on E: Exception do
        begin
          DisplayError(E.Message);
        end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

// Log messages to the log file, which is a text file that can be found at:
//  <companyroot>\AUDIT\VAT100\Vat100.log
procedure TVatSubForm.LogVATMessage(msgText : string);
var
  logFile   : TextFile;
  logRecord : string;
  timestamp : TDateTime;
begin
  // open the log file
  if directoryExists(companyRoot) then
  begin
    AssignFile(logFile, companyRoot + vat100RootDir + logFilename);
    if fileExists(companyRoot + vat100RootDir + logFilename) then
    begin
      Append(logFile);
    end
    else
    begin
      ReWrite(logFile);
    end;

    // Compose the message record
    timestamp := Now;
    logRecord := Format('%s : %s', [DateTimeToStr(timestamp), msgText]);

    // Write the record to the log file
    writeln(logFile, logRecord);

    // Close  the log file
    CloseFile(logFile);
  end;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.btnSubmitClick(Sender: TObject);
var
  timeStamp  : string;
  proceed    : boolean;
  sentFile   : string;
  vatPerNode : TgmXMLNode;
  vatPer     : string;
  filename   : string;
  submissionState: TSubStates;
begin
  btnSubmit.Enabled := false;

  proceed := true;
  // Leave a blank line for the start of a new log.
  LogVatMessage(' ');

  // Determine whether we have already submitted a return for this period.
  // We need to check whether a file of the same name already exists in the Sent
  //  folder.  If it does, we probably don't want to submit it again.

  filename := ExtractFilename(xmlFilename);
  sentFile := companyRoot + vat100RootDir + vatRawFiles + OutboxDir + filename;

  // Don't allow the return to be sent if one has been submitted already.
  submissionState := ReturnSubmitted(returnDetail.Period);

  if submissionState = ssSubError then
  begin
    ShowMessage('A VAT return for this period has already been submitted to HMRC.');
    submissionState := ssSuccess;
  end
  else if submissionState = ssSuccess then
  begin
    // Ok to submit
    Screen.Cursor := crHourGlass;

    // Prevent the user from clicking Submit again.
    btnSubmit.Enabled := false;

    SubmitVATReturn;
  end;

  Screen.Cursor := crDefault;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  dlgResponse : integer;
begin
  CanClose := true;
  if CanClose then
  begin
    if (fOwnerHandle <> 0) then
    begin
      if (submissionState = ssSuccess) then
      begin
        // Submission was successful
        PostMessage(fOwnerHandle, WM_CONTINUEVATRETURN, 0, 0);
      end
      else
      begin
        // Submission was cancelled or failed.
        PostMessage(fOwnerHandle, WM_CANCELVATRETURN, 0, 0);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

// Allows the user to print the information from HMRC's submission receipt.
// ABSEXCH-14497. PKR. 01/08/2013.
procedure TVatSubForm.btnPrintClick(Sender: TObject);
var
  printCaption : string;
  thePrinter   : TPrinter;
begin
  if PrintDialog.Execute then
  begin
    thePrinter := Printer;

    printCaption := 'VAT100 Submission report. ' + DateTimeToStr(Now);

    SetRichEditMargins(1.0, 1.0, 1.0, 1.0, richNarrative, thePrinter);

    richNarrative.Print(printCaption);
  end;
end;

// -----------------------------------------------------------------------------

procedure SetRichEditMargins(const mLeft, mRight, mTop, mBottom: extended;
                             const re : TRichEdit; const aPrinter : TPrinter);
var
  ppiX, ppiY : integer;
  spaceLeft, spaceTop : integer;
  r : TRect;
begin
  // pixels per inch
  ppiX := GetDeviceCaps(aPrinter.Handle, LOGPIXELSX) ;
  ppiY := GetDeviceCaps(aPrinter.Handle, LOGPIXELSY) ;

  // non-printable margins
  spaceLeft := GetDeviceCaps(aPrinter.Handle, PHYSICALOFFSETX) ;
  spaceTop := GetDeviceCaps(aPrinter.Handle, PHYSICALOFFSETY) ;

  //calc margins
  R.Left := Round(ppiX * mLeft) - spaceLeft;
  R.Right := Printer.PageWidth - Round(ppiX * mRight) - spaceLeft;
  R.Top := Round(ppiY * mTop) - spaceTop;
  R.Bottom := Printer.PageHeight - Round(ppiY * mBottom) - spaceTop;

  // set margins
  re.PageRect := r;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.ExtractVATReturnFields(aFilename : string; var aDetail : TVATReturnDetail);
var
  rNode : TgmXMLNode;
  bNode : TgmXMLNode;
  hNode : TgmXMLNode;
  eNode : TgmXMLNode;
  lNode : TgmXMLNode;
  HeaderNode: TgmXMLNode;
  DeclarationNode: TgmXMLNode;
  PeriodNode: TgmXMLNode;
  NodeIndex: Integer;
begin
  try
    OutXMLDoc.LoadFromFile(aFilename, False);
    bNode := nil;
    rNode := OutXMLDoc.Nodes.Root; // GovTalkMessage node
    if (rNode <> nil) and (rNode.Children <> nil) then
      bNode := rNode.Children.NodeByName['Body'];
    if (bNode <> nil) and (bNode.Children <> nil) then
    begin
      hNode := bNode.Children.NodeByName['vat:IRenvelope'];

      if (hNode <> nil) and (hNode.Children <> nil) then
      begin
        HeaderNode := hNode.Children.NodeByName['vat:IRheader'];
        if (HeaderNode <> nil) and (HeaderNode.Children <> nil) then
        begin
          PeriodNode := HeaderNode.Children.NodeByName['vat:PeriodID'];
          if PeriodNode <> nil then
            aDetail.period := PeriodNode.AsString;
        end;

        DeclarationNode := hNode.Children.NodeByName['vat:VATDeclarationRequest'];
        if (DeclarationNode <> nil) and (DeclarationNode.Children <> nil) then
        begin
          for NodeIndex := 0 to DeclarationNode.Children.Count - 1 do
          begin
            lNode := DeclarationNode.Children[NodeIndex];
            if lNode.Name = 'vat:VATDueOnOutputs' then
              aDetail.VATDueOnOutputs := lNode.AsFloat;
            if lNode.Name = 'vat:VATDueOnECAcquisitions' then
              aDetail.VATDueOnECAcquisitions := lNode.AsFloat;
            if lNode.Name = 'vat:TotalVAT' then
              aDetail.TotalVAT := lNode.AsFloat;
            if lNode.Name = 'vat:VATReclaimedOnInputs' then
              aDetail.VATReclaimedOnInputs := lNode.AsFloat;
            if lNode.Name = 'vat:NetVAT' then
              aDetail.NetVAT := lNode.AsFloat;
            if lNode.Name = 'vat:NetSalesAndOutputs' then
              aDetail.NetSalesAndOutputs := lNode.AsFloat;
            if lNode.Name = 'vat:NetPurchasesAndInputs' then
              aDetail.NetPurchasesAndInputs := lNode.AsFloat;
            if lNode.Name = 'vat:NetECSupplies' then
              aDetail.NetECSupplies := lNode.AsFloat;
            if lNode.Name = 'vat:NetECAcquisitions' then
              aDetail.NetECAcquisitions := lNode.AsFloat;
          end;
        end;
      end;
    end;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.Button2Click(Sender: TObject);
Var
  Resp   : TStringStream ;
  ole    : OleVariant;
  user, pass,
  lHMRCDevURL: string;

  sResponse : widestring;
  vatPer    : string;
  serviceQuery : widestring;
  docType : widestring;
  submissionType : integer;
  exchUsername : widestring;
begin
  Resp := nil;
  case testCombo.ItemIndex of
    0:
      begin
        // TimeAndDate
        sResponse := CallWebService('TimeAndDate');
        ShowMessage(sResponse);

        richNarrative.Text := sResponse;
        Screen.Cursor := crDefault;
      end;
    1:
      begin
        // SubmitToHMRC
        //HV 14/05/2018 2018-R1.1 ABSEXCH-20505 : VAT100 : New Live URL From XML
        lHMRCDevURL := GetURL(urlTest);
        
        docType := 'DEV';
        submissionType := 1;
        exchUsername := UserProfile^.UserName;

        serviceQuery := Format('SubmitToHMRC?companycode=%s&doctype=%s&xmldoc=%s&suburl=%s&username=%s&email=%s',
                                [CustIntU.CustomisationCompanyCode, docType, OutXMLDoc.Text, lHMRCDevURL, exchUsername, '']);

        sResponse := CallWebService(serviceQuery);

        richNarrative.Lines.Add('Response received');
        richNarrative.Lines.Add(sResponse);

        ole := Unassigned;
        if Assigned(Resp) then
          Resp.Free;

        ShowMessage(sResponse);

        richNarrative.Text := sResponse;
        Screen.Cursor := crDefault;
      end;
    2:
      begin
        // GetLastErrorString
        sResponse := CallWebService('GetLastErrorString');

        ShowMessage(sResponse);

        richNarrative.Text := sResponse;
        Screen.Cursor := crDefault;
      end;
    3:
      begin
        // ReturnSubmittedFor
        vatPer := '2014-09';
        serviceQuery := Format('ReturnSubmittedFor?vatper=%s&companycode=%s',
                               [vatPer, CustIntU.CustomisationCompanyCode]);
        sResponse := CallWebService(serviceQuery);
        ShowMessage(sResponse);

        richNarrative.Text := sResponse;
        Screen.Cursor := crDefault;
      end;
    4:
      begin
        // ApplyIRMark
//        sResponse := hmrcFiling.ApplyIRMark(xmlDocument);
      end;
  end;
end;

// -----------------------------------------------------------------------------

function TVatSubForm.ReturnSubmitted(aVatPer : string) : TSubStates;
Var
  Resp       : TStringStream ;
  ole        : OleVariant;
  user, pass : string;
  sResponse  : widestring;
  vatPer     : string;
  serviceQuery: WideString;
begin
  serviceQuery := Format('ReturnSubmittedFor?vatper=%s&companycode=%s',
                          [aVatPer, CustIntU.CustomisationCompanyCode]);

  sResponse := CallWebService(serviceQuery);

  // TSubStates = (ssIdle, ssSubmitted, ssPolling, ssDeleting, ssSuccess, ssHMRCError, ssSubError, ssError);
  // NB. ssHMRCError = error response from HMRC.
  //     ssError     = system failure on our side.
  //     ssSubError  = error in the submitted data.
  if (sResponse = 'false') then // No VAT return submitted
    Result := ssSuccess
  else if (sResponse = 'true') then // VAT Return already submitted
    Result := ssSubError
  else
    Result := ssError;
end;

// -----------------------------------------------------------------------------

function TVatSubForm.StripResponseEnvelope(aResponse : string) : string;
var
  workStr : string;
begin
  // The response from the service is enclosed in an XML envelope like this:
  // <string xmlns="http://schemas.microsoft.com/2003/10/Serialization/">The time is 08/07/2015 10:32:51</string>
  Result := aResponse;

  // Try a string response
  workStr := StringReplace(aResponse, '<string xmlns="http://schemas.microsoft.com/2003/10/Serialization/">', '', []);
  if workStr <> aResponse then
  begin
    // Removed opening tag, so remove the end tag
    workStr := StringReplace(workStr, '</string>', '', []);
    Result := workStr;
    exit;
  end;

  // Test for empty entry (envelope-only)
  workStr := StringReplace(aResponse, '<string xmlns="http://schemas.microsoft.com/2003/10/Serialization/"/>', '', []);
  if workStr <> aResponse then
  begin
    Result := workStr;
    exit;
  end;

  // Try a boolean response
  workStr := StringReplace(aResponse, '<boolean xmlns="http://schemas.microsoft.com/2003/10/Serialization/">', '', []);
  if workStr <> aResponse then
  begin
    // Removed opening tag, so remove the end tag
    workStr := StringReplace(workStr, '</boolean>', '', []);
    Result := workStr;
    exit;
  end;
end;

// -----------------------------------------------------------------------------

function TVatSubForm.ReinstateLTGT(aXML : widestring) : widestring;
var
  workStr : widestring;
begin
  workStr := StringReplace(aXML, '&lt;', '<', [rfReplaceAll]);
  workStr := StringReplace(workStr, '&gt;', '>', [rfReplaceAll]);

  Result := workStr;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.ReadConfig;
var
  dNode : TgmXMLNode;
  rNode : TgmXMLNode;
  commentText : string;
begin
  if (FileExists(companyRoot + 'HMRCFiling.xml')) then
  begin
    InXMLDoc.LoadFromFile(companyRoot + 'HMRCFiling.xml');
    try
      rNode := InXMLDoc.Nodes.Root;
      // showmessage(rNode.NodeName);

      dNode := rNode.Children.NodeByName['URLatom'];
      if (dNode <> nil) then
        URLAtom := dNode.AsString
      else
        URLAtom := DEFAULT_URL_ATOM;

      dNode := rNode.Children.NodeByName['Port'];
      if (dNode <> nil) then
        URLPort := dNode.AsString
      else
        URLPort := DEFAULT_PORT;
    except
    end;
  end
  else
  begin
    // No config file found, so used defaults and create one
    URLAtom := DEFAULT_URL_ATOM;
    URLPort := DEFAULT_PORT;

    InXMLDoc.Nodes.Clear;
    InXMLDoc.Encoding := 'utf-8';
    InXMLDoc.AutoIndent := True; // looks better in Editor

    // Add a comment.
    {
    commentText := #13#10'  EDITING THIS FILE COULD PREVENT VAT 100 RETURN SUBMISSIONS FROM WORKING CORRECTLY'#13#10#13#10 +
                   '  This is used to build the full URL of the HMRCFilingService'#13#10 +
                   '  e.g.  http://localhost:64193/SubmitToHMRC'#13#10 +
                   '  Typical values in here:'#13#10 +
                   '  1) localhost'#13#10 +
                   '  2) An IP address'#13#10 +
                   '  3) A server nodename'#13#10;
    dNode := InXMLDoc.CreateNode(commentText, ntComment);
    InXMLDoc.ChildNodes.Add(dNode);
    }

    InXMLDoc.Nodes.AddOpenTag('HMRCService');
    InXMLDoc.Nodes.AddLeaf('URLatom').AsString := DEFAULT_URL_ATOM;
    InXMLDoc.Nodes.AddLeaf('Port').AsString := DEFAULT_PORT;
    InXMLDoc.Nodes.AddCloseTag; // HMRCService

    InXMLDoc.SaveToFile(companyRoot + 'HMRCFiling.xml');
  end;
end;

// -----------------------------------------------------------------------------

{
function TVatSubForm.SelectNode(xnRoot: TgmXMLNode; const nodePath: WideString): TgmXMLNode;
var
  intfSelect : IDomNodeSelect;
  dnResult : IDomNode;
  intfDocAccess : IXmlDocumentAccess;
  doc: TgmXML;
begin
  Result := nil;
  if (not Assigned(xnRoot)) or
     (not Supports(xnRoot.DOMNode, IDomNodeSelect, intfSelect)) then
  begin
    Exit;
  end;

  dnResult := intfSelect.selectNode(nodePath);
  if Assigned(dnResult) then
  begin
    if Supports(xnRoot.OwnerDocument, IXmlDocumentAccess, intfDocAccess) then
    begin
      doc := intfDocAccess.DocumentObject;
    end
    else
    begin
      doc := nil;
    end;

    Result := TXmlNode.Create(dnResult, nil, doc);
  end;
end;
}

// -----------------------------------------------------------------------------

// Used for reporting the time and date of a previous submission
function GetFileDate(TheFileName: string): string;
var
  FHandle: integer;
begin
  FHandle := FileOpen(TheFileName, 0);
  try
    Result := DateTimeToStr(FileDateToDateTime(FileGetDate(FHandle)));
  finally
    FileClose(FHandle);
  end;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.testComboEnter(Sender: TObject);
begin
  SendMessage(testCombo.handle, CB_SHOWDROPDOWN, Integer(True), 0);
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.testComboExit(Sender: TObject);
begin
  SendMessage(testCombo.handle, CB_SHOWDROPDOWN, Integer(False), 0);
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.PageCtrlChange(Sender: TObject);
begin
  btnPrint.Enabled := ((PageCtrl.ActivePage = sheetNarrative) and
                       (richNarrative.Lines.Count > 0));
end;

// -----------------------------------------------------------------------------

function TVatSubForm.CallWebService(ServiceQuery: WideString): WideString;
var
  Ole: OleVariant;
  Response: TStringStream;
begin
  Result := '';
  // Submit the return to the HMRCFiling service.
  try
    Ole := CreateOleObject('MSXML2.ServerXmlHttp');
    Ole.open('GET', FFilingServiceURL + serviceQuery, false);
    Ole.Send('');
    Response := TStringStream.Create(Ole.ResponseText);
    Result := Response.DataString;
    Result := StripResponseEnvelope(Result);

    Ole := Unassigned;
    if Assigned(Response) then
        Response.Free;

    // Replace HTML entities
    Result := StringReplace(Result, '&lt;',   '<', [rfReplaceAll]);
    Result := StringReplace(Result, '&gt;',   '>', [rfReplaceAll]);
    Result := StringReplace(Result, '&quot;', '"', [rfReplaceAll]);
    Result := StringReplace(Result, '&apos;', '''', [rfReplaceAll]);
    Result := StringReplace(Result, '&amp;',  '&', [rfReplaceAll]);
  except
    on E:EOleException do
    begin
      if (Pos('connection with the server', E.message) > 0) then
      begin
        DisplayError(E.message);
        DisplayError('');
        DisplayError('The Exchequer HMRC File service is not running or is not accessible.');
      end;
      Result := '';
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.DisplayError(ErrorMessage: string);
begin
  errorMemo.Lines.Add(ErrorMessage);
  errorSheet.TabVisible := true;
  PageCtrl.ActivePage := errorSheet;
end;

// -----------------------------------------------------------------------------

procedure TVatSubForm.PrepareWebService;
var
  Inifile: TIniFile;
  Path: string;
begin
  FFilingServiceURL := '';
  Path := IncludeTrailingPathDelimiter(GetEnterpriseDirectory) + 'HMRC Filing Service\HMRCFiling.ini';
  Inifile := TIniFile.Create(Path);
  try
    FFilingServiceURL := Inifile.ReadString('WebService', 'URL', 'localhost');
    FFilingServiceURL := 'http://' + FFilingServiceURL + ':64193/';
  finally
    Inifile.Free;
  end;
end;

end.

