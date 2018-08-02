unit PrntDlgF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Enterprise01_TLB, ExtCtrls, AdvGlowButton,
  AdvOfficePager, AdvOfficePagerStylers, psvDialogs;

type
  TfrmPrintDlg = class(TForm)
    OfficeStyler: TAdvOfficePagerOfficeStyler;
    OfficePager: TAdvOfficePager;
    opPrinter: TAdvOfficePage;
    btnPrinterCancel: TAdvGlowButton;
    pnlDLLDetails: TPanel;
    opEmail: TAdvOfficePage;
    opFax: TAdvOfficePage;
    btnPrinterOK: TAdvGlowButton;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    lstOutputTo: TRadioGroup;
    GroupBox2: TGroupBox;
    Label21: TLabel;
    lstPrinters: TComboBox;
    Label25: TLabel;
    edtCopies: TEdit;
    Label26: TLabel;
    edtFormName: TEdit;
    btnPrinterSetup: TAdvGlowButton;
    btnPrinterBrowse: TAdvGlowButton;
    GroupBox11: TGroupBox;
    lstFormCompression: TComboBox;
    chkSendReader: TCheckBox;
    GroupBox12: TGroupBox;
    radEmail: TRadioButton;
    radPreviewEmail: TRadioButton;
    GroupBox13: TGroupBox;
    Label27: TLabel;
    Label28: TLabel;
    edtEmailCover: TEdit;
    edtEmailForm: TEdit;
    GroupBox14: TGroupBox;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    edtSenderName: TEdit;
    edtSenderEmail: TEdit;
    edtToName: TEdit;
    edtToAddress: TEdit;
    edtCCName: TEdit;
    edtCCAddress: TEdit;
    edtEmailSubject: TEdit;
    lstEmailPriority: TComboBox;
    memEmailMessage: TMemo;
    btnBrowseEmailForm: TAdvGlowButton;
    btnBrowseEmailCover: TAdvGlowButton;
    GroupBox15: TGroupBox;
    Label37: TLabel;
    lstMapiFaxPrinters: TComboBox;
    GroupBox16: TGroupBox;
    Label38: TLabel;
    Label39: TLabel;
    edtFaxCover: TEdit;
    edtFaxForm: TEdit;
    GroupBox17: TGroupBox;
    radFax: TRadioButton;
    radFaxPreview: TRadioButton;
    GroupBox18: TGroupBox;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    edtFaxSenderName: TEdit;
    edtFaxSenderNumber: TEdit;
    edtFaxRecipName: TEdit;
    edtFaxRecipNumber: TEdit;
    edtFaxDesc: TEdit;
    lstFaxPriority: TComboBox;
    memFaxMessage: TMemo;
    btnEmailOK: TAdvGlowButton;
    btnEmailCancel: TAdvGlowButton;
    btnFaxOK: TAdvGlowButton;
    btnFaxCancel: TAdvGlowButton;
    btnFaxPrinterSetup: TAdvGlowButton;
    btnBrowseFaxForm: TAdvGlowButton;
    btnBrowseFaxCover: TAdvGlowButton;
    psvOpenDialog: TpsvOpenDialog;
    procedure btnBrowseEmailCoverClick(Sender: TObject);
    procedure btnBrowseEmailFormClick(Sender: TObject);
    procedure btnBrowseFaxCoverClick(Sender: TObject);
    procedure btnBrowseFaxFormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrinterSetupClick(Sender: TObject);
    procedure btnPrinterOKClick(Sender: TObject);
    procedure btnEmailOKClick(Sender: TObject);
    procedure btnFaxOKClick(Sender: TObject);
    procedure btnFaxPrinterSetupClick(Sender: TObject);
    procedure btnPrinterBrowseClick(Sender: TObject);
    procedure btnPrinterCancelClick(Sender: TObject);
    procedure OfficePagerChange(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    lPrintJob   : IPrintJob;
    FToolkit: IToolkit;
    function SelectFormName(AFormName: string): string;
  public
    { Public declarations }
    Procedure SetPrinterObject(Const PrintJob      : IPrintJob;
                               Const WindowCaption : ShortString);
    property  Toolkit: IToolkit read FToolkit write FToolkit;
  end;

var
  frmPrintDlg: TfrmPrintDlg;

implementation

{$R *.DFM}

Uses PreviewF;

procedure MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@r));
    InflateRect(r, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@r));
    SetWindowRgn(Handle, rgn, True);
    Invalidate;
  end;
end;

procedure TfrmPrintDlg.btnBrowseEmailCoverClick(Sender: TObject);
begin
  edtEmailCover.Text := SelectFormName(edtEmailCover.Text);
end;

procedure TfrmPrintDlg.btnBrowseEmailFormClick(Sender: TObject);
begin
  edtEmailForm.Text := SelectFormName(edtEmailForm.Text);
end;

procedure TfrmPrintDlg.btnBrowseFaxCoverClick(Sender: TObject);
begin
  edtFaxCover.Text := SelectFormName(edtFaxCover.Text);
end;

procedure TfrmPrintDlg.btnBrowseFaxFormClick(Sender: TObject);
begin
  edtFaxForm.Text := SelectFormName(edtFaxForm.Text);
end;

procedure TfrmPrintDlg.FormCreate(Sender: TObject);
begin
  OfficePager.ActivePage := opPrinter;
  OfficePagerChange(nil);
end;

Procedure TfrmPrintDlg.SetPrinterObject(Const PrintJob      : IPrintJob;
                                        Const WindowCaption : ShortString);
Var
  PrinterNo : SmallInt;
Begin // SetPrinterObject
  // Make local copy of the reference to the Print Job object
  lPrintJob := PrintJob;

  // Set topical Caption for dialog
  Caption := WindowCaption;

  // Load the system details and print job defaults into the dialog
  With lPrintJob Do Begin
    With pjSystemPrinters Do Begin
      // Load Printers List
      If (prCount > 0) Then
        For PrinterNo := 1 To prCount Do Begin
          lstPrinters.Items.Add (prPrinters[PrinterNo].pdName);
          lstMAPIFaxPrinters.Items.Add (prPrinters[PrinterNo].pdName);
        End; // For PrinterNo

      // Setup Default Printer - Check Print Job first then
      // Windows Default Printer
      If (pjPrinterIndex >= 0) And (pjPrinterIndex <= pjSystemPrinters.prCount) Then
        lstPrinters.ItemIndex := pjPrinterIndex - 1
      Else
        If (pjSystemPrinters.prDefaultPrinter >= 0) And (pjSystemPrinters.prDefaultPrinter <= pjSystemPrinters.prCount) Then
          lstPrinters.ItemIndex := pjSystemPrinters.prDefaultPrinter - 1;
    End; // With pjSystemPrinters

    // Default to Printer
    lstOutputTo.ItemIndex := 0;

    // Setup Form - Check for default
    If (pjForms.pfCount > 0) Then
      edtFormName.Text := pjForms[1].fdFormName;

    // Setup Printer details
    edtCopies.Text := IntToStr(pjCopies);

    // *** EMAIL TAB ***
    With pjEmailInfo Do Begin
      edtEmailForm.Text  := edtFormName.Text;
      edtEmailCover.Text := emCoverSheet;

      // Compression
      Case emFormCompression Of
        emZIPNone  : lstFormCompression.ItemIndex := 0;
        emZIPPKZIP : lstFormCompression.ItemIndex := 1;
        emZIPEDZ   : lstFormCompression.ItemIndex := 2;
      End; // Case emFormCompression

      // Send Reader Flag
      chkSendReader.Checked := emSendReader;

      // Sender Details
      edtSenderName.Text  := emSenderName;
      edtSenderEmail.Text := emSenderAddress;

      // To Details - Check default address exists
      If (emToRecipients.eaCount > 0) Then Begin
        edtToName.Text    := emToRecipients.eaItems[1].emlName;
        edtToAddress.Text := emToRecipients.eaItems[1].emlAddress;
      End; // If (emToRecipients.eaCount > 0)

      // Subject
      edtEmailSubject.Text := emSubject;

      // Priority
      Case emPriority Of
        epLow    : lstEmailPriority.ItemIndex := 0;
        epNormal : lstEmailPriority.ItemIndex := 1;
        epHigh   : lstEmailPriority.ItemIndex := 2;
      End; // Case emPriority

      // Message
      memEmailMessage.Text := emMessageText;
    End; // With pjEmailInfo

    // *** FAX TAB ***
    With pjFaxInfo Do Begin
      // Only select a printer for MAPI faxing
      lstMAPIFaxPrinters.Enabled := (pjFaxInfo.fxType = fmMAPI);
      If (Not lstMAPIFaxPrinters.Enabled) Then Begin
        // select Fax printer
        If (pjFaxInfo.fxFaxPrinterIndex >= 0) And (pjFaxInfo.fxFaxPrinterIndex <= pjSystemPrinters.prCount) Then
          lstMAPIFaxPrinters.ItemIndex := pjFaxInfo.fxFaxPrinterIndex - 1;
      End // If (Not lstMAPIFaxPrinters.Enabled)
      Else Begin
        // Select default printer
        If (pjSystemPrinters.prDefaultPrinter >= 0) And (pjSystemPrinters.prDefaultPrinter <= pjSystemPrinters.prCount) Then
          lstMAPIFaxPrinters.ItemIndex := pjSystemPrinters.prDefaultPrinter - 1;
      End; // Else

      // Forms
      edtFaxForm.Text := edtFormName.Text;
      edtFaxCover.Text := pjFaxInfo.fxCoverSheet;

      // Sender Details
      edtFaxSenderName.Text := pjFaxInfo.fxSenderName;
      edtFaxSenderNumber.Text := pjFaxInfo.fxSenderFaxNumber;

      // Recipient Details
      edtFaxRecipName.Text := pjFaxInfo.fxRecipientName;
      edtFaxRecipNumber.Text := pjFaxInfo.fxRecipientFaxNumber;

      // Fax Description & Cover Sheet Message
      edtFaxDesc.Text := pjFaxInfo.fxFaxDescription;
      memFaxMessage.Text := pjFaxInfo.fxMessageText;

      // Fax Priority
      Case pjFaxInfo.fxPriority Of
        fpOffPeak : lstFaxPriority.ItemIndex := 0;
        fpNormal  : lstFaxPriority.ItemIndex := 1;
        fpUrgent  : lstFaxPriority.ItemIndex := 2;
      End; // Case pjFaxInfo.fxPriority
    End; // With pjFaxInfo
  End; // With lPrintJob
End; // SetPrinterObject

procedure TfrmPrintDlg.btnPrinterSetupClick(Sender: TObject);
begin
  With lPrintJob Do
    If PrinterSetupDialog Then
      // Settings changed - update form
      If (pjPrinterIndex >= 0) And (pjPrinterIndex <= pjSystemPrinters.prCount) Then
        lstPrinters.ItemIndex := pjPrinterIndex - 1;
end;

procedure TfrmPrintDlg.btnPrinterOKClick(Sender: TObject);
Var
  oTempPrintFile : IPrintTempFile;
  Res            : LongInt;
begin
  // Update the Print Job with the details
  With lPrintJob Do Begin
    pjCopies := StrToInt(edtCopies.Text);
    pjPrinterIndex := lstPrinters.ItemIndex + 1
  End; // With lPrintJob

  Case lstOutputTo.ItemIndex Of
    0 : Begin // Printer
          Res := lPrintJob.PrintToPrinter;
          If (Res <> 0) Then ShowMessage ('Error ' + IntToStr(Res));
        End;  // Printer
{
    1 : Begin // Preview (EDF)
          // Print the Job to a temporary file which can be used for a preview window
          oTempPrintFile := lPrintJob.PrintToTempFile(pdPrinter);
          Try
            // Check the Temporary file was created successfully
            If (oTempPrintFile.pfStatus = 0) Then
              Res := oTempPrintFile.DisplayPreviewWindow(ptEDFReader)
            Else
              ShowMessage ('PrintToTempFile Error : ' + IntToStr(oTempPrintFile.pfStatus));
          Finally
            oTempPrintFile := NIL;
          End;
        End;  // Preview (EDF)
}
    1 : Begin // Preview (Window)
          // Print the Job to a temporary file which can be used for a preview window
          oTempPrintFile := lPrintJob.PrintToTempFile(pdPrinter);
          Try
            // Check the Temporary file was created successfully
            If (oTempPrintFile.pfStatus = 0) Then Begin
              Res := oTempPrintFile.DisplayPreviewWindow(ptEDFReader);
//              Windows.SetParent(res, self.Handle);
              SetForeGroundWindow (Res);
            End // If (oTempPrintFile.pfStatus = 0)
            Else
              ShowMessage ('PrintToTempFile Error : ' + IntToStr(oTempPrintFile.pfStatus));
          Finally
            oTempPrintFile := NIL;
          End;
        End;  // Preview (Window)
{
    1 : Begin // Preview (ActiveX)
          // Print the Job to a temporary file which can be used for a preview window
          oTempPrintFile := lPrintJob.PrintToTempFile(pdPrinter);
          Try
            // Check the Temporary file was created successfully
            If (oTempPrintFile.pfStatus = 0) Then
              // Create the custom preview window
              With TfrmPreview.Create(Self) Do
                Try
                  // Pass in the temporary file object
                  SetTempPrint (oTempPrintFile);
                  ShowModal;
                Finally
                  Free;
                End // Try
            Else
              ShowMessage ('PrintToTempFile Error : ' + IntToStr(oTempPrintFile.pfStatus));
          Finally
            oTempPrintFile := NIL;
          End;
        End;  // Preview (ActiveX)

    4 : Begin // EDF File
          // Print the Job to a temporary file which can be used for a preview window
          oTempPrintFile := lPrintJob.PrintToTempFile(pdPrinter);
          Try
            // Check the Temporary file was created successfully
            If (oTempPrintFile.pfStatus = 0) Then Begin
              Res := oTempPrintFile.SaveAsFile ('c:\ex304.edf', saEDF);
              If (Res <> 0) Then ShowMessage ('Error ' + IntToStr(Res) + ' saving to EDF File');
            End // If (oTempPrintFile.pfStatus = 0)
            Else
              ShowMessage ('PrintToTempFile Error : ' + IntToStr(oTempPrintFile.pfStatus));
          Finally
            oTempPrintFile := NIL;
          End;
        End;  // EDF File
  Else
    ShowMessage ('This Output Method is not supported'); }
  End; // Case lstOutputTo.ListIndex
end;

procedure TfrmPrintDlg.btnEmailOKClick(Sender: TObject);
Var
  Res            : LongInt;
begin
  With lPrintJob Do Begin
    // Update the Print Job with the new details
    With pjEmailInfo Do Begin
      // Compression
      Case lstFormCompression.ItemIndex Of
        0 : emFormCompression := emZIPNone;
        1 : emFormCompression := emZIPPKZIP;
        2 : emFormCompression := emZIPEDZ;
      End; // Case lstFormCompression.ItemIndex

      // Send Attachment Reader
      emSendReader := chkSendReader.Checked;

      // Sender Details
      emSenderName    := edtSenderName.Text;
      emSenderAddress := edtSenderEmail.Text;

      // Recipient Details
      emToRecipients.Clear;
      emToRecipients.AddAddress (edtToName.Text, edtToAddress.Text);

      emCCRecipients.Clear;
      emCCRecipients.AddAddress (edtCCName.Text, edtCCAddress.Text);

      // Subject
      emSubject := edtEmailSubject.Text;

      // Priority
      Case lstEmailPriority.ItemIndex Of
        0 : emPriority := epLow;
        1 : emPriority := epNormal;
        2 : emPriority := epHigh;
      End; // Case lstEmailPriority.ItemIndex

      // Message
      emMessageText := memEmailMessage.Text;
    End; // With pjEmailInfo

    // Print the Job to a Temporary File
    With PrintToTempFile(pdEmail) Do
      // Check the Temporary file was created successfully
      If (pfStatus = 0) Then
        // Check whether previewing or sending email
        If radEmail.Checked Then Begin
          // Send Email
          Res := SendToDestination;
          If (Res <> 0) Then ShowMessage ('Error sending Email: ' + IntToStr(Res));
        End // If readEmail.Checked
        Else Begin
          // Preview in Internal Window
          Res := DisplayPreviewWindow(ptNonModal);
          SetForegroundWindow (Res);
        End // Else
      Else
        ShowMessage ('PrintToTempFile (Email): ' + IntToStr(pfStatus) + ' - ' + FToolkit.LastErrorString);
  End; // With lPrintJob
end;

procedure TfrmPrintDlg.btnFaxOKClick(Sender: TObject);
Var
  Res : LongInt;
begin
  With lPrintJob Do Begin
    // Update the Print Job with the new details
    With pjFaxInfo Do Begin
      // Sender Details
      fxSenderName := edtFaxSenderName.Text;
      fxSenderFaxNumber := edtFaxSenderNumber.Text;

      // Recipient Details  (Only 1 recipient supported by Enterprise)
      fxRecipientName := edtFaxRecipName.Text;
      fxRecipientFaxNumber := edtFaxRecipNumber.Text;

      // Fax Desc & Message
      fxFaxDescription := edtFaxDesc.Text;
      fxMessageText := memFaxMessage.Text;

      Case lstFaxPriority.ItemIndex Of
        0 : fxPriority := fpOffPeak;
        1 : fxPriority := fpNormal;
        2 : fxPriority := fpUrgent;
      End; // Case lstFaxPriority.ItemIndex
    End; // With pjFaxInfo

    // Print the Job to a Temporary File
    With PrintToTempFile(pdFax) Do
      // Check the Temporary file was created successfully
      If (pfStatus = 0) Then
        // Check whether previewing or sending fax
        If radFax.Checked Then Begin
          // Send Fax
          Res := SendToDestination;
          If (Res <> 0) Then ShowMessage ('Error sending Fax: ' + IntToStr(Res));
        End // If radFax.Checked
        Else Begin
          // Preview in Internal Window
          Res := DisplayPreviewWindow(ptNonModal);
          SetForegroundWindow (Res);
        End // Else
      Else
        ShowMessage ('PrintToTempFile (Fax): ' + IntToStr(pfStatus) + ' - ' + FToolkit.LastErrorString);
  End; // With lPrintJob
end;

procedure TfrmPrintDlg.btnFaxPrinterSetupClick(Sender: TObject);
begin
  With lPrintJob Do
    If PrinterSetupDialog Then
      // Settings changed - update form
      If (pjPrinterIndex >= 0) And (pjPrinterIndex <= pjSystemPrinters.prCount) Then
        lstMapiFaxPrinters.ItemIndex := pjPrinterIndex - 1;
end;

procedure TfrmPrintDlg.btnPrinterBrowseClick(Sender: TObject);
begin
  edtFormName.Text := SelectFormName(edtFormName.Text);
end;

procedure TfrmPrintDlg.btnPrinterCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPrintDlg.OfficePagerChange(Sender: TObject);
begin
  if OfficePager.ActivePage = opPrinter then begin
    self.Height         := 225;
    OfficePager.Height  := 169;
  end
  else begin
    self.Height         := 425;
    OfficePager.Height  := 369;
  end;
  MakeRounded(self);
  MakeRounded(pnlRounded);
end;

procedure TfrmPrintDlg.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

function TfrmPrintDlg.SelectFormName(AFormName: string): string;
begin
   Result := AFormName;
   psvOpenDialog.InitialDir := IncludeTrailingBackslash(trim(FToolkit.Configuration.DataDirectory)) + 'FORMS\';
   if not psvOpenDialog.Execute then EXIT;
   result := ExtractFileName(psvOpenDialog.FileName);
   result := copy(result, 1, LastDelimiter('.', result) - 1); // lop off the extension
end;

end.
