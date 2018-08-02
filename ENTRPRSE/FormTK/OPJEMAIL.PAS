unit oPJEmail;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     RpDevice,
     oEmlArr,                  // TEmailAddressArray object
     oEmlAtt,                  // IStringArrayRW Attachments object
     EnterpriseForms_TLB,
     Enterprise01_TLB;

type
  TEFPrintJobEmailInfo = class(TAutoIntfObject, IEFPrintJobEmailInfo)
  private
    // Local Reference to parent PrintJob object
    FPrintJob : TObject;

    // To Recipipients sub-object
    FToRecipientsO  : TEFEmailAddressArray;
    FToRecipientsI  : IEFEmailAddressArray;
    // CC Recipipients sub-object
    FCCRecipientsO  : TEFEmailAddressArray;
    FCCRecipientsI  : IEFEmailAddressArray;
    // BCC Recipipients sub-object
    FBCCRecipientsO : TEFEmailAddressArray;
    FBCCRecipientsI : IEFEmailAddressArray;
    // Attachments sub-object
    FAttachmentsO   : TEFStringListReadWrite;
    FAttachmentsI   : IEFStringListReadWrite;

    // Email Cover Sheet (needs to be local so it doesn't interfere with fax cover sheet)
    FCoverSheet     : String[8];
  protected
    // IEFPrintJobEmailInfo
    function Get_emType: TEFEmailType; safecall;
    function Get_emSenderName: WideString; safecall;
    procedure Set_emSenderName(const Value: WideString); safecall;
    function Get_emSenderAddress: WideString; safecall;
    procedure Set_emSenderAddress(const Value: WideString); safecall;
    function Get_emToRecipients: IEFEmailAddressArray; safecall;
    function Get_emCCRecipients: IEFEmailAddressArray; safecall;
    function Get_emBCCRecipients: IEFEmailAddressArray; safecall;
    function Get_emSubject: WideString; safecall;
    procedure Set_emSubject(const Value: WideString); safecall;
    function Get_emMessageText: WideString; safecall;
    procedure Set_emMessageText(const Value: WideString); safecall;
    function Get_emAttachments: IEFStringListReadWrite; safecall;
    function Get_emPriority: TEFEmailPriority; safecall;
    procedure Set_emPriority(Value: TEFEmailPriority); safecall;
    function Get_emCoverSheet: WideString; safecall;
    procedure Set_emCoverSheet(const Value: WideString); safecall;
    function Get_emSMTPServer: WideString; safecall;
    function Get_emFormCompression: TEFFormCompression; safecall;
    procedure Set_emFormCompression(Value: TEFFormCompression); safecall;
    function Get_emSendReader: WordBool; safecall;
    procedure Set_emSendReader(Value: WordBool); safecall;

    // Local methods
  public
    Constructor Create (Const PrintJob : TObject);
    Destructor Destroy; override;

    Function  CheckJobInfo : Integer;
    procedure Initialise;
    procedure UpdatePrnSetup;
  End; { TEFPrintJobEmailInfo }

implementation

Uses ComServ,
     GlobVar,          // Exchequer Global Constants/Types
     VarConst,         // Exchequer Global Constants/Types/Variables
     StrUtil,          // Standard String Functions
     Register,         // FormDes routines for accessing EFD Files
     oPrntJob,         // TEFPrintJob object
     MiscFunc,         // Miscellaneous Functions / Types / Constants for the Form TK
     PrintU,
     LogUtil;

//-----------------------------------------------------------------------------

Constructor TEFPrintJobEmailInfo.Create (Const PrintJob : TObject);
Begin { Create }
  OutputDebug('TEFPrintJobEmailInfo.Create Start');
  Inherited Create (ComServer.TypeLib, IEFPrintJobEmailInfo);

  FPrintJob := PrintJob;

  // To Recipipients sub-object
  FToRecipientsO := TEFEmailAddressArray.Create ('To Email Address');
  FToRecipientsI := FToRecipientsO;

  // CC Recipipients sub-object
  FCCRecipientsO := TEFEmailAddressArray.Create ('CC Email Address');
  FCCRecipientsI := FCCRecipientsO;

  // BCC Recipipients sub-object
  FBCCRecipientsO := TEFEmailAddressArray.Create ('BCC Email Address');
  FBCCRecipientsI := FBCCRecipientsO;

  // Attachments sub-object
  FAttachmentsO := TEFStringListReadWrite.Create (2, 'Email Attachment Filename');
  FAttachmentsI := FAttachmentsO;

  Initialise;
  OutputDebug('TEFPrintJobEmailInfo.Create End');
End;

//----------------------------------------

Destructor TEFPrintJobEmailInfo.Destroy;
Begin { Destroy }
  // Local Reference to parent PrintJob object
  FPrintJob := NIL;

  // To Recipipients sub-object
  FToRecipientsO := NIL;
  FToRecipientsI := NIL;

  // CC Recipipients sub-object
  FCCRecipientsO := NIL;
  FCCRecipientsI := NIL;

  // BCC Recipipients sub-object
  FBCCRecipientsO := NIL;
  FBCCRecipientsI := NIL;

  // Attachments sub-object
  FAttachmentsO := NIL;
  FAttachmentsI := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

procedure TEFPrintJobEmailInfo.Initialise;
begin
  With SyssEDI2^.EDI2Value, FPrintJob as TEFPrintJob Do Begin
    // Email Cover Sheet
    FCoverSheet := '';

    // Setup Email/SMTP switch
    PrintJobSetupInfo.feEmailMAPI := EmUseMAPI;

    // Initalise all sub-objects as well
    FToRecipientsO.Initialise;
    FCCRecipientsO.Initialise;
    FBCCRecipientsO.Initialise;
    FAttachmentsO.Initialise;

    // Setup Email Priority to Normal
    PrintJobSetupInfo.feEmailPriority := 1;
  End; { With SyssEDI2^.EDI2Value, FPrintJob as TEFPrintJob }
end;

//-----------------------------------------------------------------------------

procedure TEFPrintJobEmailInfo.UpdatePrnSetup;
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do Begin
    // Setup Printer Index
    DevIdx := ((FPrintJob as TEFPrintJob) As IEFPrintJob).pjFileInfo.fiAttachmentPrinterIndex;

    // Cover Sheet
    feCoverSheet := FCoverSheet;

    // Get Email Addresses from sub-objects
    feEmailTo := FToRecipientsO.ExtractAddresses;
    feEmailCC := FCCRecipientsO.ExtractAddresses;
    feEmailBCC := FBCCRecipientsO.ExtractAddresses;

    //PR: 06/06/2011 Setup friendly file name for emailing ABSEXCH-11390
    feEmailFName := DefaultDocName(FDefPrintMode, feEmailMAPI);

    // Get Attachments from sub-object
    feEmailAttach := FAttachmentsO.ExtractAttachments;
  End; { With FPrintJob as TEFPrintJob }
end;

//-----------------------------------------------------------------------------

// Validates the email details
Function TEFPrintJobEmailInfo.CheckJobInfo : Integer;
Begin { CheckJobInfo }
  Result := 0;

  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do Begin
    // Sender Email Address set
    //If (Trim(feEmailFromAd) = '') Then
    If Not ValidateEmailAddress(feEmailFromAd) Then
      Result := 3000;

    // At least one To Address
    If (Result = 0) And (FToRecipientsI.eaCount = 0) Then
      Result := 3001;

    // Subject Set
    If (Result = 0) And (Trim(feEmailSubj) = '') Then
      Result := 3002;

    // Cover Sheet blank or of correct form type
    If (Result = 0) And (Trim(FCoverSheet) <> '') And (FormsListI.pfCount > 0) Then
      // Test form type of coversheet against the first form in the print job
      If (GetFormType (FCoverSheet) <> GetFormType (FormsListI.pfForms[1].fdFormName)) Then
        // Error - Forms of different types cannot be included within the same print job
        Result := 3003;
  End; { With FPrintJob as TEFPrintJob, PrintJobSetupInfo }
End; { CheckJobInfo }

//-----------------------------------------------------------------------------

function TEFPrintJobEmailInfo.Get_emType: TEFEmailType;
begin
  With FPrintJob as TEFPrintJob Do
    If PrintJobSetupInfo.feEmailMAPI Then
      Result := emtMAPI
    Else
      Result := emtSMTP;
end;

//----------------------------------------

function TEFPrintJobEmailInfo.Get_emSenderName: WideString;
begin
  With FPrintJob as TEFPrintJob Do
    Result := PrintJobSetupInfo.feEmailFrom;
end;

procedure TEFPrintJobEmailInfo.Set_emSenderName(const Value: WideString);
begin
  With FPrintJob as TEFPrintJob Do
    PrintJobSetupInfo.feEmailFrom := Value;
end;

//----------------------------------------

function TEFPrintJobEmailInfo.Get_emSenderAddress: WideString;
begin
  With FPrintJob as TEFPrintJob Do
    Result := PrintJobSetupInfo.feEmailFromAd;
end;


procedure TEFPrintJobEmailInfo.Set_emSenderAddress(const Value: WideString);
begin
  With FPrintJob as TEFPrintJob Do
    PrintJobSetupInfo.feEmailFromAd := Value;
end;

//----------------------------------------

function TEFPrintJobEmailInfo.Get_emToRecipients: IEFEmailAddressArray;
begin
  Result := FToRecipientsI;
end;

function TEFPrintJobEmailInfo.Get_emBCCRecipients: IEFEmailAddressArray;
begin
  Result := FBCCRecipientsI;
end;

function TEFPrintJobEmailInfo.Get_emCCRecipients: IEFEmailAddressArray;
begin
  Result := FCCRecipientsI;
end;

//----------------------------------------

function TEFPrintJobEmailInfo.Get_emSubject: WideString;
begin
  With FPrintJob as TEFPrintJob Do
    Result := PrintJobSetupInfo.feEmailSubj;
end;

procedure TEFPrintJobEmailInfo.Set_emSubject(const Value: WideString);
begin
  With FPrintJob as TEFPrintJob Do
    PrintJobSetupInfo.feEmailSubj := Value;
end;

//----------------------------------------


function TEFPrintJobEmailInfo.Get_emMessageText: WideString;
begin
  With FPrintJob as TEFPrintJob Do
    Result := PrintJobSetupInfo.feEmailMsg;
end;

procedure TEFPrintJobEmailInfo.Set_emMessageText(const Value: WideString);
begin
  With FPrintJob as TEFPrintJob Do
    PrintJobSetupInfo.feEmailMsg := Value;
end;

//----------------------------------------


function TEFPrintJobEmailInfo.Get_emAttachments: IEFStringListReadWrite;
begin
  Result := FAttachmentsI;
end;

//----------------------------------------

function TEFPrintJobEmailInfo.Get_emPriority: TEFEmailPriority;
begin
  With FPrintJob as TEFPrintJob Do
    Case PrintJobSetupInfo.feEmailPriority Of
      0 : Result := empLow;
      1 : Result := empNormal;
      2 : Result := empHigh;
    Else
      Raise Exception.Create ('IEFPrintJobEmailInfo.emPriority: Unhandled Email Priority (' + IntToStr(PrintJobSetupInfo.feEmailPriority) + ')');
    End; { Case PrintJobSetupInfo.feEmailPriority }
end;

procedure TEFPrintJobEmailInfo.Set_emPriority(Value: TEFEmailPriority);
begin
  With FPrintJob as TEFPrintJob Do
    Case Value Of
      empLow    : PrintJobSetupInfo.feEmailPriority := 0;
      empNormal : PrintJobSetupInfo.feEmailPriority := 1;
      empHigh   : PrintJobSetupInfo.feEmailPriority := 2;
    Else
      Raise EValidation.Create ('IEFPrintJobEmailInfo.emPriority: Unhandled Email Priority (' + IntToStr(Value) + ')');
    End; { Case PrintJobSetupInfo.feEmailPriority }
end;

//----------------------------------------

function TEFPrintJobEmailInfo.Get_emCoverSheet: WideString;
begin
  Result := FCoverSheet;
end;

procedure TEFPrintJobEmailInfo.Set_emCoverSheet(const Value: WideString);
begin
  FCoverSheet := Value;
end;

//----------------------------------------

function TEFPrintJobEmailInfo.Get_emSMTPServer: WideString;
begin
  Result := SyssEDI2^.EDI2Value.EmSMTP;
end;

//----------------------------------------

function TEFPrintJobEmailInfo.Get_emFormCompression: TEFFormCompression;
begin
  With FPrintJob as TEFPrintJob Do
    Case PrintJobSetupInfo.feEmailZIP Of
      0 : Result := fcNone;
      1 : Result := fcZIP;
      2 : Result := fcEDZ;
    Else
      Raise Exception.Create ('IEFPrintJobEmailInfo.emFormCompression: Unhandled Form compression Type (' + IntToStr(PrintJobSetupInfo.feEmailZIP) + ')');
    End; { Case PrintJobSetupInfo.feEmailZIP }
end;

procedure TEFPrintJobEmailInfo.Set_emFormCompression(Value: TEFFormCompression);
begin
  With FPrintJob as TEFPrintJob Do
    Case Value Of
      fcNone : PrintJobSetupInfo.feEmailZIP := 0;
      fcZIP  : PrintJobSetupInfo.feEmailZIP := 1;
      fcEDZ  : PrintJobSetupInfo.feEmailZIP := 2;
    Else
      Raise EValidation.Create ('IEFPrintJobEmailInfo.emFormCompression: Unhandled Form compression Type (' + IntToStr(Value) + ')');
    End; { Case Value }
end;

//----------------------------------------

function TEFPrintJobEmailInfo.Get_emSendReader: WordBool;
begin
  With FPrintJob as TEFPrintJob Do
    Result := PrintJobSetupInfo.feEmailReader;
end;

procedure TEFPrintJobEmailInfo.Set_emSendReader(Value: WordBool);
begin
  With FPrintJob as TEFPrintJob Do
    PrintJobSetupInfo.feEmailReader := Value;
end;

//-----------------------------------------------------------------------------

end.
