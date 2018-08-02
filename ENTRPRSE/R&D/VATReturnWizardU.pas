unit VATReturnWizardU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BorBtns, StdCtrls, Mask, TEditVal, ExtCtrls, bkgroup, ComCtrls,
  Rep_UnmatchedSalesReceipts,
  Rep_OrderPaymentsVATReturn,
  BtSupU3,
  SBSComp2,
  BtrvU2,
  BtSupU1,
  OrderPaymentsUnmatchedReceipts,
  EnterToTab,
  VATSub;

type
  TVATReturnStage = (vrsTaxPeriod, vrsUnmatchedSRCsSearch, vrsUnmatchedSRCsReport,
                     vrsVATReturn, vrsSaveVATToPDF, vrsGenerateNOMs,
                     vrsPostAccrualNOM, vrsSubmitReturn, vrsClosePeriod,
                     vrsPostContraNOM, vrsFinished);

  TProcessStage = (psNotStarted, psRunning, psCompleted);

  // Wizard to handle the VAT Return process
  TVATReturnWizard = class(TForm)
    PageControl: TPageControl;
    TaxPeriodPage: TTabSheet;
    Label85: Label8;
    Label81: Label8;
    edtPeriodYear: TEditPeriod;
    pnlButtons: TPanel;
    btnNext: TButton;
    btnCancel: TButton;
    lblVATContraGLCode: TLabel;
    edtContraPeriod: TEditPeriod;
    lblContraPeriod: TLabel;
    Bevel1: TBevel;
    edtCostCentre: Text8Pt;
    edtDepartment: Text8Pt;
    lblCostCentre: TLabel;
    lblDepartment: TLabel;
    EnterToTab1: TEnterToTab;
    edtVATContraGLCode: Text8Pt;
    chkIncludeOrderPaymentSRCs: TCheckBox;
    VatReturnImg: TImage;
    Bevel2: TBevel;
    chkClosePeriod: TCheckBox;
    chkExportToXML: TCheckBox;
    VATReturnPage: TTabSheet;
    ClosePeriodPage: TTabSheet;
    lblCompletedSalesReceiptsCheck: TLabel;
    lblSalesReceiptsCheck: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblCompletedSalesReceiptsReport: TLabel;
    lblSalesReceiptsReport: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblCompletedVATReturn: TLabel;
    lblVATReturn: TLabel;
    pnlProgress: TPanel;
    lblProgress: TLabel;
    ProgressBar: TProgressBar;
    lblCompletedVATReturnPDF: TLabel;
    lblVATReturnPDF: TLabel;
    lblCompletedNominalJournals: TLabel;
    lblNominalJournals: TLabel;
    lblCompletedAccrualPosting: TLabel;
    lblAccrualPosting: TLabel;
    lblCompletedClosePeriod: TLabel;
    lblClosePeriod: TLabel;
    lblCompletedContraPosting: TLabel;
    lblContraPosting: TLabel;
    FinishPage: TTabSheet;
    lblVATReturnCompleted: TLabel;
    lblVATReturnPDFFileName: TLabel;
    txtVATReturnPDFFileName: TStaticText;
    lblCompletedSubmittingToHMRC: TLabel;
    lblSubmittingToHMRC: TLabel;
    lblCompletedVATReturnPage: TLabel;
    ErrorList: TListBox;
    lblIncompleteVATSubmissionDetails: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtPeriodYearExit(Sender: TObject);
    procedure chkExportToXMLClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelClick(Sender: TObject);
    procedure edtCostCentreExit(Sender: TObject);
    procedure edtDepartmentExit(Sender: TObject);
    procedure chkIncludeOrderPaymentSRCsClick(Sender: TObject);
    procedure edtVATContraGLCodeExit(Sender: TObject);
    procedure chkClosePeriodClick(Sender: TObject);
    procedure edtContraPeriodExit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FStage: TVATReturnStage;
    FUnmatchedReceipts: TOrderPaymentsUnmatchedReceipts;
    FVATReturnPDFFileName: string;
    FVATReturnXMLFileName: string;
    FVATSubmissionForm: TVATSubForm;
    FVATReturn: ^TOrderPaymentsVATReturn;
    FIncludeOrderPayments: Boolean;
    FClosePeriod: Boolean;
    FSubmitReturn: Boolean;
    FCancelled: Boolean;
    CRepParam  :  VATRepPtr;
    CRepParam2 :  ISVATRepPtr;
    PParam     :  TPrintParamPtr;
    CompPr     :  String;
    HookEngaged  :  Boolean;
    ExportOption :  Boolean;
    // PKR. 15/09/2015. ABSEXCH-16835. Moved here so that it is accessible to multiple methods.
    ValidVATSetup: Boolean;
    procedure SetLastValues;

    // Moves to the next stage in the process. This is only required for
    // actions which are internal to this form -- other actions post the
    // WM_CONTINUEVATRETURN message instead.
    procedure NextStage;

    // Updates the supplied stage process label, based on the processing
    // stage -- this label is the small 'indicator' item that appears to
    // the left of the stage description, and changes between a greyed-out
    // arrow-head, a normal arrow-head, and a tick.
    procedure UpdateProcessLabel(Lbl: TLabel; ProcessStage: TProcessStage);

    // Enables or disables the Order Payments controls.
    procedure EnableOrderPayments(Enable: Boolean);

    // Shows or hides the Progress Bar panel. The Msg is set as the label
    // caption. This also sets the Progress Bar position to zero.
    procedure ShowProgressPanel(ShowPanel: Boolean; Msg: string = '');

    // Methods to handle the different report stages. RunStageProcess() will
    // select and call the correct routine for the current stage (as dictated
    // by the FStage variable).
    procedure RunStageProcess;
    procedure RunUnmatchedSRCSearch(RepParam: VATRepPtr);
    procedure RunUnmatchedSRCReport(RepParam: VATRepPtr; AOwner: TObject);
    procedure RunVATReturn(RepParam: VATRepPtr; AOwner: TObject);

    // Generates the Accrual Nominal Journal and the Contra Nominal Journal
    procedure GenerateNOMS;

    // Generates a Nominal Journal transaction for the VAT liability from the
    // current list of outstanding Order Payments Sales Receipts. Used by
    // GeneratAccrualNOM and GenerateContraNOM below.
    procedure GenerateNOM(Year, Period: Integer; AsContra: Boolean);

    // Generates an accrual Nominal Journal transaction for the VAT liability
    // from the current list of outstanding Order Payments Sales Receipts
    procedure GenerateAccrualNOM;

    // Generates a contra Nominal Journal transaction for the VAT liability
    // from the current list outstanding Order Payments Sales Receipts, for the
    // following Tax Period.
    procedure GenerateContraNOM;

    // Launches the thread for posting the Nominal Daybook
    procedure PostNominalJournals;

    // Launches the Submit VAT Return system
    procedure SubmitVATReturn;

    // Event handler for updating the progress bar
    procedure OnProgress(Count: Integer; var Cancelled: Boolean);

    // Event handler used when the WMContinueVATReturn message is received to
    // let the form know that an external process (generally a print preview)
    // has been finished and the VAT Return process can move on to the next
    // stage.
    procedure OnContinue;

    // Event handler used when the WMCancelVATReturn message is received to
    // let the form know that an external process has cancelled and that the
    // VAT Return should therefore also be cancelled.
    procedure OnCancel;

    // Checks that the supplied control contains a valid Cost Centre or
    // Department code, and displays the pop-up select dialog if it does not.
    function CheckCCDept(Sender: Text8pt; ForCostCentre: Boolean): Boolean;

    // Checks that the supplied control contains a valid GL Code, and displays
    // the pop-up select dialog if it does not.
    function CheckGLCode(Sender: Text8pt): Boolean;

    // Checks that the Contra Period/Year control contains a valid year and
    // period
    function CheckContraPeriod(Sender: TEditPeriod): Boolean;

    // Saves the VAT Return as a PDF file
    procedure SaveToPDF;

    // Closes the current VAT Period
    procedure ClosePeriod;

    // Enables/disables the 'Next' and 'Close' buttons
    procedure EnableButtons(Enable: Boolean);

    // Checks that the required input values (on the first page) are valid
    function Validate: Boolean;

    // Error handler -- adds the supplied message to the list of errors
    // displayed on the final page.
    procedure OnError(Msg: string);

    // CJS 2015-01-06 - ABSEXCH-15929 - add Audit Notes for auto-generated VAT nominals
    // Adds an audit note for the VAT Nominal transactions
    function AddAuditNote: integer;

  protected
    // Message handlers for messages received from TForm_PrintPreviewWizard in
    // PrintPreviewWizard.pas (the preview form is created by the reports).
    procedure WMThreadFinished(var Message: TMessage); message WM_THREADFINISHED;
    procedure WMContinueVATReturn(var Message: TMessage); message WM_CONTINUEVATRETURN;
    procedure WMCancelVATReturn(var Message: TMessage); message WM_CANCELVATRETURN;
  public

  end;

// Main entry point
procedure VATReturn(AOwner: TComponent);

Implementation

Uses
  Math,
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  InvListU,
  ReportKU,
  {$IFDEF CU}
    ExWrap1U,
    Event1U,
    CustWinU,
  {$ENDIF}
  BrwseDir,
  GenWarnU,
  PWarnU,
  SysU1,
  SysU2,
  BTSupU2,
  BtKeys1U,
  PostingU,
  CurrncyU,
  SetVATU,
  DLLInt,
  BasePrintPreview,
  ReportU,
  TransactionOriginator,
  AuditNotes,
  StrUtil,
  RegUtil;

{$R *.DFM}

// -----------------------------------------------------------------------------

procedure VATReturn(AOwner: TComponent);
var
  ReportWizard: TVATReturnWizard;
begin
  ReportWizard := TVATReturnWizard.Create(AOwner);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TVATReturnWizard
// =============================================================================

procedure TVATReturnWizard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Action := caFree;

  if Assigned(FVATReturn) then
  begin
    DeletePrintFile(FVATReturn.RepFiler1.FileName);
    Dispose(FVATReturn, Destroy);
  end;

  if Assigned(CRepParam) then
    Dispose(CRepParam);

  if Assigned(CRepParam2) then
    Dispose(CRepParam2);

  if Assigned(PParam) then
  begin
    Dispose(PParam);
    if Assigned(PParam^.UFont) then
      PParam^.UFont.Free;
  end;
{
  if Assigned(FVATSubmissionForm) then
    FreeAndNil(FVATSubmissionForm);
}
end;

// -----------------------------------------------------------------------------

// Create the report input form.
procedure TVATReturnWizard.FormCreate(Sender: TObject);
var
  VSYr,VSPr
     :  Word;

  CVYr,CVPr,
  NYear,
  n          :  Integer;

  {$IFDEF CU}
    HKStr    :  Str255;
    ExLocal  :  TdExLocal;

  {$ENDIF}
  NextTaxDate: LongDate;

  FBIRegistryKey: string;
begin
  inherited;

  // Original dialog dimensions
  ClientHeight := 377;
  ClientWidth  := 446;

  // CA 05/09/2012 ABSEXCH-12708
  ExportOption := False;

  FStage := vrsTaxPeriod;
  PageControl.ActivePage := TaxPeriodPage;

  FCancelled := False;
  FIncludeOrderPayments := False;
  FClosePeriod := False;
  FSubmitReturn := False;

  lblSalesReceiptsCheck.Enabled := False;
  lblSalesReceiptsReport.Enabled := False;
  lblSubmittingToHMRC.Enabled := False;

  { CJS 2013-08-08 - Added graphic and check for country code }
  if (CurrentCountry = UKCCode) then
  begin
    // ABSEXCH-13793. 08/05/2013. Add option to export VAT Return to XML format
    chkExportToXML.Visible := True;
    VATReturnImg.Visible := True;
    btnNext.Enabled := True;
  end;

  New(Self.CRepParam);
  New(Self.CRepParam2);

  try
    With Self.CRepParam^ do
    Begin
      FillChar(Self.CRepParam^,Sizeof(Self.CRepParam^),0);
      VATEndD:=SyssVat.VATRates.CurrPeriod;

      {$IFDEF CU}
        HookEngaged:=EnableCustBtns(MiscBase+1,05);
      {$ELSE}
        HookEngaged:=BOff;
      {$ENDIF}

      If (HookEngaged) then
      Begin
        {$IFDEF CU}
          ExLocal.Create;
          HKStr:=TextExitHook(MiscBase+1,5,'',ExLocal);

          If (Copy(HKStr,3,1)<>'/') then
            HKStr:='01/2000';

          VPr:=IntStr(Copy(HKStr,1,2));
          NYear:=IntStr(Copy(HKStr,4,4));

          ExLocal.Destroy;
        {$ENDIF}
      end
      else
      Begin
        NYear:=Part_Date('Y',VATEndd);
        VPr:=Part_Date('M',VATEndd);
      end;

      VYr:=TxlateYrVal(NYear,BOn);
      CVYr:=NYear; CVPr:=VPr;

      edtPeriodYear.InitPeriod(VPr,VYr,BOn,BOn);

      edtPeriodYear.PeriodsInYear:=12;

      CompPr := edtPeriodYear.Text;

      // CJS 2015-07-09 - ABSEXCH-16365 - default contra period to start of next VAT period
      // Calc_NewVATPeriod returns the current VAT Period, based on the last
      // VAT Return date. We want the start of the period AFTER this, so we add
      // a month to VAT Return date.
      NextTaxDate := Calc_NewVATPeriod(SyssVAT.VATRates.VATReturnDate, SyssVAT.VATRates.VATInterval);
      NextTaxDate := DateToStr8(IncMonth(Str8ToDate(NextTaxDate), 1));
      edtContraPeriod.DateValue := NextTaxDate;

    end;
  except
    on E:Exception do
    begin
      Dispose(Self.CRepParam);
      Self.CRepParam:=nil;
      FCancelled := True;
      FStage := vrsFinished;
      OnError('An error occurred while preparing the VAT Return: ' + E.Message);
    end;
  end;

  try
    with Self.CRepParam2^ do
      FillChar(Self.CRepParam2^,Sizeof(Self.CRepParam2^), 0);

  except
    on E:Exception do
    begin
      Dispose(Self.CRepParam2);
      Self.CRepParam2:=nil;
      FCancelled := True;
      FStage := vrsFinished;
      OnError('An error occurred while preparing the VAT Return: ' + E.Message);
    end;
  end;

  New(PParam);

  try
    With PParam^ do
    Begin
      FillChar(PParam^,Sizeof(PParam^),0);

      UFont:=TFont.Create;

      try
        UFont.Assign(Application.MainForm.Font);
      except
        UFont.Free;
        UFont:=nil;
      end;

      {$IFDEF Rp}
        Orient:=RPDefine.PoLandscape;
      {$ENDIF}

      With PDevRec do
      Begin
        DevIdx:=-1;
        Preview:=BOn;
        NoCopies:=1;
      end;
    end;
  except
    on E:Exception do
    begin
      Dispose(PParam);
      PParam := nil;
      FCancelled := True;
      FStage := vrsFinished;
      OnError('An error occurred while preparing the VAT Return: ' + E.Message);
    end;
  end;

  chkClosePeriod.Visible:=BoChkAllowed_In(True, 50) and (Not HookEngaged) and (ICEDFM=0);

  Caption:=CCVATName^+' '+Caption;

  SetLastValues;

  // If the "Close Period after Report" checkbox is checked...
  If (chkClosePeriod.Checked) then
  With CRepParam^ do
  Begin
    edtPeriodYear.InitPeriod(VPr,VYr,BOn,BOn);
    edtPeriodYear.PeriodsInYear := 12;
    chkClosePeriod.Checked := BOff;
  end;

  EnableOrderPayments(False);

  // Check that the VAT details have been set up. Disable the HMRC Submission if not.
  ValidVATSetup := (Trim(SyssVat.VATRAtes.VAT100SenderType) <> '') and
                   (Trim(SyssVAT.VATRAtes.VAT100UserID) <> '') and
                   (Trim(SyssVAT.VATRAtes.VAT100Password) <> '') and
                   (Trim(Syss.UserVATReg) <> '');

  // PKR. 11/09/2015. ABSEXCH-16835. Can submit VAT 100 without setting up credentials.
  // Also shouldn't be able to submit VAT 100 if Close Period not checked.

  chkExportToXML.Enabled := ValidVATSetup and chkClosePeriod.Checked;
  lblIncompleteVATSubmissionDetails.Visible := not ValidVATSetup;

  // ABSEXCH-16835. If the VAT details are incomplete, don't allow online submission.
  if (not self.chkExportToXML.Enabled) then
  begin
    self.chkExportToXML.Checked := false;
  end;

  // CJS 2015-08-21 - 2015 R1 - ABSEXCH-16774 - VAT100 Submission
  // Check that the FBI Sub-System is installed. Disable the HMRC Submission if not.
  FBIRegistryKey := 'TypeLib\{67C620EB-3F2D-46F6-BC15-C554CABF73EE}';
  if not RegUtil.RegKeyExists(HKEY_CLASSES_ROOT, FBIRegistryKey) then
  begin
    chkExportToXML.Enabled := False;
    lblIncompleteVATSubmissionDetails.Caption := 'FBI (Filing By Internet) Sub-System is not installed';
    lblIncompleteVATSubmissionDetails.Visible := True;
  end;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

// -----------------------------------------------------------------------------

// Exit event from the Period/Year input field.
// Enables the "Close VAT period after report" checkbox if it's the end of a VAT period.
procedure TVATReturnWizard.edtPeriodYearExit(Sender: TObject);
var
  NextTaxDate: LongDate;

begin
  inherited;
  // CJS 2015-05-28 - ABSEXCH-16434 - disable Order Payments for closed periods
  // Disable the Order Payments options if the user has selected a period
  // previous to the current VAT Period.
  chkIncludeOrderPaymentSRCs.Enabled := (CompPr <= edtPeriodYear.Text);

  // Disable the Close Period option if the user has selected a period
  // other than the current VAT Period.
  If (chkClosePeriod.Visible) then
  Begin
    With CRepParam^ do
      chkClosePeriod.Enabled := (CompPr = edtPeriodYear.Text);

    // Uncheck the checkbox if it is disabled.
    If (chkClosePeriod.Checked) and (Not chkClosePeriod.Enabled) then
      chkClosePeriod.Checked := BOff;
  end;

  // CJS 2015-07-09 - ABSEXCH-16365 - default contra period to start of next VAT period
  // The DateValue is only the year + month, so specify a day that will always
  // be valid so that we have a full date to pass to Str8ToDate().
  NextTaxDate := edtPeriodYear.DateValue + '28';
  NextTaxDate := DateToStr8(IncMonth(Str8ToDate(NextTaxDate), 1));
  edtContraPeriod.DateValue := NextTaxDate;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.btnNextClick(Sender: TObject);
Var
  VSYr,VSPr,
  AVPr,
  mrResult:  Word;
  CVYr,CVPr,
  NYear,
  n  :  Integer;
  ExportMode  : String;
  VATChk      :  Char;
  Msg: string;
begin
  // For the first page only, we need to validate the user-input
  if (PageControl.ActivePage = TaxPeriodPage) then
  begin
    if Validate Then
    begin
      with Self.CRepParam^ do
      begin
        edtPeriodYearExit(Nil);

        btnNext.Enabled:=BOff;

        edtPeriodYear.InitPeriod(VPr,VYr,BOff,BOff);

        NYear:=ConvTxYrVal(VYr,BOff);

        VSYr:=NYear; VSPr:=VPr;

        VISYr:=VYr; VISPr:=VPr;

        If (VPr=2) then {* Compensate for period 2 *}
          AVPr:=Pred(Monthdays[VPr])
        else
          AVPr:=Monthdays[VPr];

        VATEndD:=StrDate(NYear,VPr,Monthdays[VPr]);

        VATStartD:=StrDate(NYear,VPr,AVPr);

        {VATStartD:=VATEndD;}

        AutoCloseVAT:=chkClosePeriod.Checked;

        With CRepParam2^ do
        Begin
          VPr:=CRepParam^.VPr;
          VYr:=CRepParam^.VYr;
        end;

        // ABSEXCH-13793. 08/05/2013. Add option to export VAT Return to
        // XML format with an HMRC GovLink wrapper.
        if FSubmitReturn then
          CRepParam^.WantXMLOutput := True;

        OnContinue;

      end;

      inherited;
    end // if Validate ...
  end // if (PageControl.ActivePage = TaxPeriodPage) ...
  else
    OnContinue;
end;

// -----------------------------------------------------------------------------

// Handles a change in state of the "Export to XML" checkbox.
procedure TVATReturnWizard.chkExportToXMLClick(Sender: TObject);
var
  XMLFilePath : string;
begin
  inherited;
  FSubmitReturn := chkExportToXML.Checked;
  lblSubmittingToHMRC.Enabled := FSubmitReturn;
  if FSubmitReturn then
  begin
    lblSubmittingToHMRC.Font.Color := clWindowText;
    XMLFilePath := SetDrive + 'AUDIT\VAT100\Rawfiles\';
    if not DirectoryExists(XMLFilePath) then
    begin
      // Switch off this option
      chkExportToXML.Checked := false;
      FSubmitReturn := False;
      OnError('The VAT100 XML working directories do not exist.' +chr(13)+chr(10)+
              'This option is not currently available.');
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.SetLastValues;
begin
  LastValueObj.GetAllLastValuesFull(self);
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.RunUnmatchedSRCSearch(RepParam: VATRepPtr);
begin
  FUnmatchedReceipts := TOrderPaymentsUnmatchedReceipts.Create;
  try
    try
      FUnmatchedReceipts.OnUpdateProgress := OnProgress;
      ShowProgressPanel(True, 'Searching for unmatched Sales Receipts');
      FUnmatchedReceipts.Process(RepParam);
    finally
      NextStage;
    end;
  except
    on E:Exception do
      OnError('Order Payments: check for unmatched Sales Receipts failed: ' + E.Message);
  end;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.RunUnmatchedSRCReport(RepParam: VATRepPtr; AOwner: TObject);
var
  SRCReport: ^TUnmatchedSalesReceiptsReport;
begin
  New(SRCReport, Create(self));
  try
    try
      if (Assigned(RepParam)) then
        SRCReport.RepParam^ := RepParam^;

      SRCReport.OnProgress := OnProgress;
      SRCReport.NoDeviceP  := False;
      SRCReport.OrderPaymentsUnmatchedReceipts := FUnmatchedReceipts;

      pnlProgress.Visible  := True;

      SRCReport.RDevRec.feJobtitle := 'Unmatched Sales Receipt';
      ShowProgressPanel(True, 'Building unmatched Sales Receipts report');
      if (SRCReport.Start) then
      begin

        SRCReport.Process;
        SRCReport.Finish;
      end;
    except
      on E:Exception do
      begin
        OnError('An error occurred while running the Unmatched Sales Receipt report: ' + E.Message);
      end;
    end;

  finally
    ShowProgressPanel(False);
    Dispose(SRCReport, Destroy);
  end; { try...}
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.btnCancelClick(Sender: TObject);
begin
  OnCancel;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.OnCancel;
begin
  FCancelled := True;
  // If we are already on the Finish page, or we are on the first (input) page,
  // just exit straight away
  if (FStage in [vrsTaxPeriod, vrsFinished]) then
    Close
  else
  // For any other page, force us to the Finish page
  begin
    // Stop the generation of the VAT Return
    if (FStage = vrsVATReturn) then
      FVATReturn.RepAbort := FCancelled;
    if (FStage = vrsSubmitReturn) then
      ErrorList.Items.Add('VAT Submission to HMRC was cancelled.');
    FStage := vrsFinished;
    NextStage;
  end;
end;

// -----------------------------------------------------------------------------

// CJS 2015-02-17 - ABSEXCH-16162 - drill-down on VAT Report
// Removed the 'toPDF' option for this function, as printing to PDF is now
// handled completely separately.
procedure TVATReturnWizard.RunVATReturn(RepParam: VATRepPtr; AOwner: TObject);
var
  CanPrint: Boolean;
  mbRet: Word;
begin
  if not Assigned(FVATReturn) then
  begin
    // Create a TOrderPaymentsVATReturn instance
    New(FVATReturn, Create(self));
  end;

  CanPrint := True;

  try
    try
      if (Assigned(RepParam)) then
        FVATReturn.CRepParam^ := RepParam^;

      FVATReturn.OnUpdateProgress := OnProgress;
      if FIncludeOrderPayments then
        FVATReturn.OrderPaymentsUnmatchedReceipts := FUnmatchedReceipts;

      ShowProgressPanel(True, 'Building VAT Return');
      FVATReturn.RDevRec.Preview := True;
      if (FVATReturn.Start) then
      begin
        // Generate the report.
        FVATReturn.Process;

        // If the user cancelled the VAT Return, give them the opportunity
        // to display the details already generated
        if FCancelled then
        begin
          mbRet := MessageDlg('VAT Return cancelled' +
                              #13#10#13#10 +
                              'Do you wish to print the information processed so far?',
                              mtConfirmation,[mbYes,mbNo],0);
          CanPrint := (mbRet = mrYes);
        end;

        if CanPrint then
        begin
          FVATReturn.Finish;
          FVATReturnXMLFileName := FVATReturn.CRepParam.XMLOutputFile;
        end;
        pnlProgress.Visible := False;
      end
      else
        OnCancel;

    except
      on E:Exception do
      begin
        OnError('An error occurred while running the VAT Return report: ' + E.Message);
      end;
    end;
  finally
    ShowProgressPanel(False);
  end; { try...}
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.RunStageProcess;
var
  StartedOk: Boolean;
begin
  case FStage of
    vrsTaxPeriod          : begin
                              NextStage;
                            end;

    // Runs the routines for building a list (in FUnmatchedReceipts) of all
    // receipts that are either not fully allocated, or were allocated outside
    // of the Order Payments system
    vrsUnmatchedSRCsSearch: begin
                              PageControl.ActivePage := VATReturnPage;
                              if FIncludeOrderPayments then
                              begin
                                btnNext.Enabled := False;
                                UpdateProcessLabel(lblCompletedSalesReceiptsCheck, psRunning);
                                RunUnmatchedSRCSearch(CRepParam);
                                UpdateProcessLabel(lblCompletedSalesReceiptsCheck, psCompleted);
                                Application.ProcessMessages;
                              end
                              else
                              begin
                                NextStage;
                              end;
                            end;

    // Runs the report of all receipts that were not created by the Order
    // Payments system (using the the list in FUnmatchedReceipts)
    vrsUnmatchedSRCsReport: begin
                              if FIncludeOrderPayments then
                              begin
                                btnNext.Enabled := False;
                                UpdateProcessLabel(lblCompletedSalesReceiptsReport, psRunning);
                                RunUnmatchedSRCReport(CRepParam, Owner);
                                UpdateProcessLabel(lblCompletedSalesReceiptsReport, psCompleted);
                              end
                              else
                              begin
                                NextStage;
                              end;
                            end;

    // Runs (and displays) the main VAT Return report
    vrsVATReturn          : begin
                              UpdateProcessLabel(lblCompletedVATReturn, psRunning);
                              btnNext.Enabled := False;
                              RunVATReturn(CRepParam, Owner);
                              UpdateProcessLabel(lblCompletedVATReturn, psCompleted);
                              if FClosePeriod then
                              begin
                                lblCompletedVATReturnPage.Visible := True;
                                btnNext.Caption := 'Close period';
                                btnNext.Enabled := True;
                              end
                              else
                              begin
                                // The period is not being closed, so skip
                                // over the Close Period page and go directly
                                // to the final page
                                btnNext.Visible := False;
                                btnCancel.Caption := '&Close';
                                FStage := vrsFinished;
                                NextStage;
                              end;
                            end;

    // Automatically saves the generated VAT Return report to a PDF file
    vrsSaveVATToPDF       : begin
                              EnableButtons(False);
                              PageControl.ActivePage := ClosePeriodPage;
                              btnNext.Visible := False;
                              UpdateProcessLabel(lblCompletedVATReturnPDF, psRunning);
                              SaveToPDF;
                              UpdateProcessLabel(lblCompletedVATReturnPDF, psCompleted);
                              NextStage;
                            end;

    // Generates the Accrual and Contra nominal transactions for the unmatched
    // Order Payments receipts
    vrsGenerateNOMs       : begin
                              if FIncludeOrderPayments then
                              begin
                                EnableButtons(False);
                                UpdateProcessLabel(lblCompletedNominalJournals, psRunning);
                                GenerateNOMs;
                                UpdateProcessLabel(lblCompletedNominalJournals, psCompleted);
                                ShowProgressPanel(False, '');
                              end;
                              NextStage;
                            end;

    // Automatically posts the accrual nominal transaction that was raised in
    // the previous stage. Note that because the posting routines cannot work
    // on individual transactions this actual posts the whole nominal daybook
    vrsPostAccrualNOM     : begin
                              if FIncludeOrderPayments then
                              begin
                                EnableButtons(False);
                                UpdateProcessLabel(lblCompletedAccrualPosting, psRunning);
                                PostNominalJournals;
                              end
                              else
                                NextStage;
                            end;

    // Displays the VAT Submission form to allow the user to submit the VAT XML
    // file
    vrsSubmitReturn       : begin
                              EnableButtons(False);
                              UpdateProcessLabel(lblCompletedAccrualPosting, psCompleted);
                              if FSubmitReturn then
                              begin
                                UpdateProcessLabel(lblCompletedSubmittingToHMRC, psRunning);
                                SubmitVATReturn;
                              end
                              else
                              begin
                                NextStage;
                              end;
                            end;

    // Closes the current VAT Period. There is no check of the FClosePeriod
    // flag because if we get this far it must have been set to True.
    vrsClosePeriod        : begin
                              EnableButtons(False);
                              UpdateProcessLabel(lblCompletedSubmittingToHMRC, psCompleted);
                              UpdateProcessLabel(lblCompletedClosePeriod, psRunning);
                              ClosePeriod;
                            end;

    // Posts the contra nominal transaction for the unmatched Order Payments
    // receipts. Because this is called after closing the period these will be
    // posted into the next VAT period
    vrsPostContraNOM      : begin
                              UpdateProcessLabel(lblCompletedClosePeriod, psCompleted);
                              // Removed, as it is currently not possible to
                              // post in future periods
                              {
                              if FIncludeOrderPayments then
                              begin
                                EnableButtons(False);
                                UpdateProcessLabel(lblCompletedContraPosting, psRunning);
                                PostNominalJournals;
                              end
                              else
                              }
                                NextStage;
                            end;

    // Displays the final page, showing any errors or warnings, and displaying
    // the path of the PDF file (if one was created)
    vrsFinished           : begin
                              // UpdateProcessLabel(lblCompletedContraPosting, psCompleted);
                              if FCancelled then
                                lblVATReturnCompleted.Caption := 'VAT Return cancelled';
                              PageControl.ActivePage := FinishPage;
                              btnNext.Visible := False;
                              btnCancel.Caption := '&Close';
                              if (FVATReturnPDFFileName <> '') then
                                txtVATReturnPDFFileName.Caption := FVATReturnPDFFileName
                              else
                              begin
                                lblVATReturnPDFFileName.Visible := False;
                                txtVATReturnPDFFileName.Visible := False;
                              end;
                              if (ErrorList.Items.Count = 0) then
                                ErrorList.Items.Add('No errors or warnings');
                              //RB 13/07/2018 2018-R1 ABSEXCH-21288: Access Violation when closing VAT Return Wizard.
                              ShowProgressPanel(False);
                            end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.OnContinue;
begin
  EnableButtons(True);
  if (FStage < vrsFinished) then
    Inc(FStage);
  RunStageProcess;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.OnProgress(Count: Integer; var Cancelled: Boolean);
begin
  ProgressBar.Position := Count;
  if (FCancelled) then
    Cancelled := True;
  Application.ProcessMessages;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.WMContinueVATReturn(var Message: TMessage);
begin
  OnContinue;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.WMCancelVATReturn(var Message: TMessage);
begin
  OnCancel;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.ShowProgressPanel(ShowPanel: Boolean; Msg: string);
begin
  pnlProgress.Visible := ShowPanel;
  lblProgress.Caption := Msg;
  ProgressBar.Position := 0;
  Application.ProcessMessages;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.GenerateAccrualNOM;
var
  Year, Period: Integer;
begin
  // CJS 2015-07-09 - ABSEXCH-16414 - Transaction date of accrual nom for VAT Return
  Year   := edtPeriodYear.EYear;
  Period := edtPeriodYear.EPeriod;
  GenerateNOM(Year, Period, False);
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.GenerateContraNOM;
var
  Year, Period: Integer;
begin
  Year   := GetLocalPr(0).CYr;
  Period := GetLocalPr(0).CPr;
  GenerateNOM(Year, Period, True);
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.GenerateNOM(Year, Period: Integer; AsContra: Boolean);
var
  n: VATType;
  VATCode: Char;
  VATAmount: Double;
  GoodsAmount: Double;
  TotalVAT: Double;
  TotalGoods: Double;
  LineNo: Integer;
  FuncRes: Integer;
  SignMultiplier: Double;
  ProgressUnit: Double;
  Progress: Double;
  TestPeriod: Byte;
  TestDate: LongDate;
  TestJulianDay: Real;
begin

  // CJS 2015-05-28 - ABSEXCH-16434 - Nominals from Order Payments are sign-inverted
  if AsContra then
    SignMultiplier := 1.0
  else
    SignMultiplier := -1.0;

  // Set up the progress bar variables
  if (FUnmatchedReceipts.Count > 0) then
    ProgressUnit := 100 / (FUnmatchedReceipts.Count * 2.0)
  else
    ProgressUnit := 1.0;
  Progress := ProgressBar.Position;

  // Set up the header details
  Blank(Inv, Sizeof(Inv));

  Inv.RunNo     := 0;
  Inv.NomAuto   := True;
  Inv.InvDocHed := NMT;
  Inv.TransDate := Today;
  Inv.AcPr      := Period;
  Inv.AcYr      := Year;
  Inv.TransDesc := 'VAT Liability';

  // The contra must be posted into the period selected by the user
  if AsContra then
  begin
    Inv.AcPr := edtContraPeriod.EPeriod;
    Inv.AcYr := edtContraPeriod.EYear;
  end
  else
  begin
    // Base the Transaction date on the assigned Period/Year
    Inv.TransDate := Pr2Date(Inv.AcPr, Inv.AcYr, nil);
    // Now we need to find the last day of the Period. Because we might be
    // using user-defined periods, and because periods are not necessarily
    // by month, the only way to do this is to keep stepping forwards through
    // the days until we reach the next period.
    TestPeriod := Inv.AcPr;
    TestJulianDay := LongDateToJulian(Inv.TransDate);
    while (TestPeriod = Inv.AcPr) do
    begin
      TestJulianDay := TestJulianDay + 1;
      TestDate := JulianToLongDate(TestJulianDay);
      Date2Pr(TestDate, TestPeriod, Inv.AcYr, nil);
    end;
    TestJulianDay := TestJulianDay - 1;
    Inv.TransDate := JulianToLongDate(TestJulianDay);
    Date2Pr(Inv.TransDate, Inv.AcPr, Inv.AcYr, nil);
  end;

  // Do not allow the transaction to be edited by the user
  Inv.ExternalDoc := True;

  Inv.NLineCount := 1;
  Inv.ILineCount := 1;
  Inv.OpName     := EntryRec^.Login;
  TransactionOriginator.SetOriginator(Inv);

  {$IFDEF MC_On}
  Inv.Currency := 1;
  {$ELSE}
  Inv.Currency := 0;
  {$ENDIF}

  Inv.CXrate   := SyssCurr.Currencies[Inv.Currency].CRates;
  Inv.VATCRate := SyssCurr.Currencies[Syss.VATCurr].CRates;

  SetTriRec(Inv.Currency, Inv.UseORate, Inv.CurrTriR);
  SetTriRec(Syss.VATCurr, Inv.UseORate, Inv.VATTriR);

  SetNextDocNos(Inv, True);

  Inv.NOMVATIO := 'O';

  // Set up the default line details
  Blank(Id, SizeOf(Id));

  Id.FolioRef := Inv.FolioNum;
  Id.IdDocHed := NMT;
  Id.LineNo   := LastAddrD;
  Id.NomCode  := StrToIntDef(edtVATContraGLCode.Text, 0);
  Id.Currency := 1;
  Id.PYr      := Year;
  Id.PPr      := Period;
  Id.Qty      := 1;
  Id.DocPRef  := Inv.OurRef;
  Id.NOMIOFlg := 2; // Manual VAT
  Id.Payment  := 'T';
  Id.CXrate   := Inv.CXrate;
  Id.CCDep[True]  := edtCostCentre.Text;
  Id.CCDep[False] := edtDepartment.Text;
  Id.PDate    := Today;
  if (Syss.UsePayIn) then
    Id.StockCode := Pre_PostPayInKey(PayInCode, '');

  // Scan through all the VAT types
  TotalGoods := 0.0;
  TotalVAT := 0.0;
  LineNo   := 1;
  for n := VStart to VEnd do
  begin
    // Get the totals for this VAT Code
    VATCode := SyssVat.VATRates.VAT[n].Code;
    FUnmatchedReceipts.Cache.TotalGoodsAndVAT(VATCode, GoodsAmount, VATAmount);
    GoodsAmount := GoodsAmount * SignMultiplier;
    VATAmount   := VATAmount * SignMultiplier;

    // CJS 2015-07-10 - ABSEXCH-16654 - Zero-VAT VAT Return NOMs exclude net and gross values
    // If there is a value against this VAT Code, add a line to the NOM
    if not IsZero(GoodsAmount) then
    begin
      // Set up the line-specific values
      Id.VATCode   := VATCode;
      Id.VAT       := VATAmount;
      Id.NetValue  := GoodsAmount;
      Id.ABSLineNo := LineNo;
      Id.Desc      := 'VAT ' + VATCode + ' Liability';

      Inv.InvVatAnal[n] := VATAmount;
      Inv.ManVAT        := True;

      // Store the line and report any errors
      FuncRes := Add_Rec(F[IdetailF], IdetailF, Id, 0);
      if (FuncRes <> 0) then
      begin
        OnError('Unable to store VAT Journal Line for VAT Code ' + VATCode +', error ' + IntToStr(FuncRes));
      end;

      LineNo := LineNo + 2;
      TotalVAT := TotalVAT + VATAmount;
      TotalGoods := TotalGoods + GoodsAmount;
    end;

    // Update the progress bar
    Progress := Progress + ProgressUnit;
    ProgressBar.Position := Trunc(Progress);
    Application.ProcessMessages;
  end;

  // If we found at least one VAT entry with values (and hence added at least
  // one line), add a line for the total VAT amount, and store the transaction
  // header
  if not IsZero(TotalVAT) then
  begin
    // CJS 2015-07-08 - ABSEXCH-16430 - VAT Return creates VAT-only nominal for order payments
    // Corrected NetValue

    // Set up the line-specific values
    Id.NOMIOFlg  := 0;
    Id.VATCode   := ' ';
    Id.VAT       := 0.0;
    Id.NetValue  := (TotalGoods + TotalVAT) * -1.0;
    Id.ABSLineNo := LineNo;
    Id.Desc      := 'Total VAT Liability';

    // Store the line and report any errors
    FuncRes := Add_Rec(F[IdetailF], IdetailF, Id, 0);
    if (FuncRes <> 0) then
    begin
      OnError('Unable to store balancing VAT Journal Line, error ' + IntToStr(FuncRes));
    end;

    // Finish the transaction header and store it
    Inv.InvNetVal := TotalGoods;
    Inv.InvVat    := TotalVAT;
    Inv.TotalInvoiced := TotalGoods + TotalVAT;

    FuncRes := Add_Rec(F[InvF], InvF, Inv, 0);
    if (FuncRes <> 0) then
    begin
      OnError('Unable to store VAT Journal Header, error ' + IntToStr(FuncRes));
    end;
    // CJS 2015-01-06 - ABSEXCH-15929 - add Audit Notes for auto-generated VAT nominals
    AddAuditNote;
  end;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.GenerateNOMS;
begin
  // Set up the progress bar
  ShowProgressPanel(True, 'Generating Nominal Journals');
  ProgressBar.Position := 0;

  // Generate the Accrual NOM
  try
    GenerateAccrualNOM;
  except
    on E:Exception do
    begin
      FCancelled := True;
      FStage := vrsFinished;
      OnError('An error occurred while generating the accrual Nominal Journal: ' + E.Message);
      Exit;
    end;
  end;

  // Generate the Contra NOM
  try
    GenerateContraNOM;
  except
    on E:Exception do
    begin
      FCancelled := True;
      FStage := vrsFinished;
      OnError('An error occurred while generating the contra Nominal Journal: ' + E.Message);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.OnError(Msg: string);
begin
  ShowMessage(Msg);
  ErrorList.Items.Add(Msg);
  FCancelled := True;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.edtCostCentreExit(Sender: TObject);
begin
  CheckCCDept((Sender as Text8pt), True);
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.edtDepartmentExit(Sender: TObject);
begin
  CheckCCDept((Sender as Text8pt), False);
end;

// -----------------------------------------------------------------------------

function TVATReturnWizard.CheckCCDept(Sender: Text8pt; ForCostCentre: Boolean): Boolean;
var
  FoundCode: Str20;
begin
  Result := True;

  // Prepare the search key, based on the current contents of the text control
  FoundCode := Trim(Sender.Text);

  if (ActiveControl <> btnCancel) and
     (ActiveControl <> chkIncludeOrderPaymentSRCs) and
     (Syss.UseCCDep) then
  begin
    Sender.StillEdit := True;
    Result := (GetCCDep(self.Owner, FoundCode, FoundCode, ForCostCentre, 2));
    if (Result) then
    begin
      Sender.StillEdit := False;
      Sender.Text      := FoundCode;
    end
    else
      Sender.SetFocus;
  end;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.EnableOrderPayments(Enable: Boolean);
begin
  lblVATContraGLCode.Enabled := Enable;
  lblContraPeriod.Enabled    := Enable;
  edtVATContraGLCode.Enabled := Enable;
  edtContraPeriod.Enabled    := Enable;

  if (Syss.UseCCDep) then
  begin
    lblCostCentre.Enabled      := Enable;
    lblDepartment.Enabled      := Enable;
    edtCostCentre.Enabled      := Enable;
    edtDepartment.Enabled      := Enable;
  end;

  if Enable then
  begin
    edtVATContraGLCode.Color := clWindow;
    edtContraPeriod.Color    := clWindow;
    if (Syss.UseCCDep) then
    begin
      edtCostCentre.Color      := clWindow;
      edtDepartment.Color      := clWindow;
    end;
  end
  else
  begin
    edtVATContraGLCode.Color := clBtnFace;
    edtContraPeriod.Color    := clBtnFace;
    edtCostCentre.Color      := clBtnFace;
    edtDepartment.Color      := clBtnFace;
  end;

end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.chkIncludeOrderPaymentSRCsClick(
  Sender: TObject);
begin
  FIncludeOrderPayments := chkIncludeOrderPaymentSRCs.Checked;
  EnableOrderPayments(FIncludeOrderPayments);
  if FIncludeOrderPayments then
    edtVATContraGLCode.SetFocus;

  lblSalesReceiptsCheck.Enabled := FIncludeOrderPayments;
  lblSalesReceiptsReport.Enabled := FIncludeOrderPayments;
end;

// -----------------------------------------------------------------------------

function TVATReturnWizard.CheckGLCode(Sender: Text8pt): Boolean;
var
  FoundCode :  Str20;
  FoundLong :  LongInt;
begin
  Result    := True;
  FoundLong := 0;

  // Prepare the search key, based on the current contents of the text control
  FoundCode := Trim(Sender.Text);

  if (ActiveControl <> btnCancel) and
     (ActiveControl <> chkIncludeOrderPaymentSRCs) then
  begin
    Sender.StillEdit := True;

    Result := GetNom(self, FoundCode, FoundLong, 2);
    if (Result) then
    begin
      Sender.StillEdit := False;
      Sender.Text := Form_Int(FoundLong, 0);
    end
    else
      Sender.SetFocus;
  end;

end;

// -----------------------------------------------------------------------------

function TVATReturnWizard.CheckContraPeriod(Sender: TEditPeriod): Boolean;
begin
  Result := True;
  if (ActiveControl <> btnCancel) and
     (ActiveControl <> chkIncludeOrderPaymentSRCs) and
     (edtContraPeriod.DateValue <= edtPeriodYear.DateValue) then
  begin
    ShowMessage('The Contra Period/Year must be greater than the Period/Year of the VAT Return');
    edtContraPeriod.SetFocus;
    Result := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.edtVATContraGLCodeExit(Sender: TObject);
begin
  CheckGLCode((Sender as Text8pt));
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.chkClosePeriodClick(Sender: TObject);
var
  Msg: string;
begin
  FClosePeriod := chkClosePeriod.Checked;
  // PKR. 15/09/2015. ABSEXCH-16835. Don't allow submission of credentials not complete (ValidVATSetup).
  chkExportToXML.Enabled := FClosePeriod and ValidVATSetup;
  lblClosePeriod.Enabled := FClosePeriod;
  lblNominalJournals.Enabled := FIncludeOrderPayments;
  lblAccrualPosting.Enabled := FIncludeOrderPayments;
  lblContraPosting.Enabled := FIncludeOrderPayments;
  if not FClosePeriod then
  begin
    chkExportToXML.Checked := False;
    FSubmitReturn := False;
  end
  else
  begin
    // Warn about implications of closing the VAT period
    Msg := Format('Closing the %s period will prevent you from posting ' +
           'any future transactions to this %s period again. ' +
           #13 +
           'You should only close the current %s period once you have ' +
           'confirmed the report is correct. ' +
           #13 +
           'You can also close the period via the %s setup screen (F5). ' +
           #13 +
           'Please confirm you wish to close the current %s period.',
           [CCVATName^, CCVATName^, CCVATName^, CCVATName^, CCVATName^]);

    // If the user elects NOT to close the VAT period, then uncheck that option.
    chkClosePeriod.Checked:=(CustomDlg(Application.MainForm,
                             'Please Note!',
                             'The ' + CCVATName^ + ' period is about to be closed',
                             Msg,
                             mtWarning,
                             [mbYes,mbNo])=mrOK);
  end;
end;

// -----------------------------------------------------------------------------

// CJS 2015-02-17 - ABSEXCH-16162 - drill-down on VAT Report
// Modified this function to run its own, independent copy of the VAT Return,
// specifically for PDF.
procedure TVATReturnWizard.SaveToPDF;
var
  i : Integer;
  PDFVATReturn: ^TOrderPaymentsVATReturn;
begin
  if Assigned(FVATReturn) then
  begin
    // Create a TOrderPaymentsVATReturn instance
    New(PDFVATReturn, Create(self));
    try
      PDFVATReturn.CRepParam := CRepParam;
      // Filename is Period/Year in format ppyyyy
      FVATReturnPDFFileName := IntToStr(PDFVATReturn.CRepParam.VPr) + IntToStr(PDFVATReturn.CRepParam.VYr + 1900);
      if Length(FVATReturnPDFFileName) = 5 then
        FVATReturnPDFFileName := '0' + FVATReturnPDFFileName;

      // If file already exists then we create a newfile as ppyyyy1, ppyyyy2,...ppyyyyn
      i := 1;
      while FileExists(SetDrive + 'Reports\' + FVATReturnPDFFileName + '.pdf') do
      begin
        inc(i);
        FVATReturnPDFFileName := Copy(FVATReturnPDFFileName, 1, 6) + IntToStr(i);
      end;
      FVATReturnPDFFileName := SetDrive + 'Reports\' + FVATReturnPDFFileName + '.pdf';

      try
        PDFVATReturn.OnUpdateProgress := OnProgress;
        if FIncludeOrderPayments then
          PDFVATReturn.OrderPaymentsUnmatchedReceipts := FUnmatchedReceipts;

        ShowProgressPanel(True, 'Saving VAT Return to PDF');

        PDFVATReturn.RDevRec.Preview := False;
        PDFVATReturn.NoDeviceP := True;
        PDFVATReturn.RDevRec.feEmailAtType := 2;
        PDFVATReturn.RDevRec.feEmailFName := '';
        PDFVATReturn.RDevRec.feOutputFileName := FVATReturnPDFFileName;
        PDFVATReturn.RDevRec.fePrintMethod := 7;

        if (PDFVATReturn.Start) then
        begin
          // Generate the report.
          PDFVATReturn.Process;

          PDFVATReturn.RDevRec.fePrintMethod := 4;
          PrintFileTo(PDFVATReturn.RDevRec, PDFVATReturn.RepFiler1.FileName, 'VAT Return');
          pnlProgress.Visible := False;
        end;

      except
        on E:Exception do
        begin
          OnError('An error occurred while running the VAT Return report: ' + E.Message);
        end;
      end;

    finally
      ShowProgressPanel(False);
      Dispose(PDFVATReturn);
    end;
  end;
  lblCompletedVATReturnPDF.Visible := True;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.NextStage;
begin
  // Post a message back to the this form to let it know that the
  // current process can continue. This results in a call to the OnContinue
  // function, which we cannot call directly from the RunStageProcess() function
  // because it would result in an unintentionally recursive call.
  PostMessage(self.Handle, WM_CONTINUEVATRETURN, 0, 0);
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.ClosePeriod;
begin
  Close_CurrPeriod(self);
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.WMThreadFinished(var Message: TMessage);
begin
  { TODO: Remove if definitely not required }
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.PostNominalJournals;
var
  StartedOk: Boolean;
begin
  AddPost2Thread(3, self, self, False, PParam, nil, StartedOk);
  if not StartedOk then
    OnError('Failed to start Nominal Post process');
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.UpdateProcessLabel(Lbl: TLabel;
  ProcessStage: TProcessStage);
begin
  case ProcessStage of
    psNotStarted: begin
                    Lbl.Visible := True;
                    Lbl.Caption := '4';
                    Lbl.Font.Color := cl3DLight
                  end;
    psRunning:    begin
                    Lbl.Caption := '4';
                    Lbl.Font.Color := clWindowText;
                    Lbl.Visible := True;
                  end;
    psCompleted:  begin
                    Lbl.Caption := 'b';
                    Lbl.Font.Color := clWindowText;
                    Lbl.Visible := True;
                  end;
  end;
  Application.ProcessMessages;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.SubmitVATReturn;
begin
  {$IFNDEF SOPDLL}
  if CRepParam.WantXMLOutput then
  begin
    // PKR. 11/09/2015. ABSEXCH-16834.  Should not be able to open multiple copies of the form.
    if (not Assigned(FVATSubmissionForm)) then
    begin
      FVATSubmissionForm := TVatSubForm.Create(self);
    end;
    // PKR. 07/04/2015. ABSEXCH-16331.  The submission form needs the handle of
    //  the wizard form so that it can send it a WM_CANCELVATRETURN or
    //  WM_CONTINUEVATRETURN message.
    FVATSubmissionForm.OwnerHandle := self.Handle;

    // Now submit the return to HMRC.
    // Show the VAT Return Submission Form
    FVATSubmissionForm.SetXMLFile(CRepParam.XMLOutputFile);
    FVATSubmissionForm.WindowState := wsNormal;
  end
  else
  {$ENDIF}
    NextStage;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.edtContraPeriodExit(Sender: TObject);
begin
  CheckContraPeriod((Sender as TEditPeriod));
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.EnableButtons(Enable: Boolean);
begin
  btnNext.Enabled := Enable;
  btnCancel.Enabled := Enable;
end;

// -----------------------------------------------------------------------------

function TVATReturnWizard.Validate: Boolean;
begin
  Result := True;
  if FIncludeOrderPayments then
  begin
    Result := CheckGLCode(edtVATContraGLCode);
    if Result then
      Result := CheckContraPeriod(edtContraPeriod);
    if Result then
      Result := CheckCCDept(edtCostCentre, True);
    if Result then
      Result := CheckCCDept(edtDepartment, False);
  end;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnWizard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not FCancelled then
  begin
    //  PS - 22-11-2015 - ABSEXCH-16912 - On 'VAT Return Wizard' clicking on 'x' on window to close window, window pop up stating VAT Return still running
    // If we are already on the Finish page, or we are on the first (input) page,
    // just exit straight away
    if not (FStage in [vrsTaxPeriod, vrsFinished]) then
    // For any other page, call OnCancel event to show appropriate event or page
    begin
      // call onCanel event so that apropriate message can be displyed.
      OnCancel;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TVATReturnWizard.AddAuditNote: integer;
var
  AuditNote : TAuditNote;
begin
  Result := 999;
  AuditNote := TAuditNote.Create(EntryRec^.Login, @F[PwrdF], nil);
  Try
    Result := AuditNote.AddNote(anTransaction, Inv.FolioNum, anCreate);
  Finally
    AuditNote.Free;
  End;
end;

// -----------------------------------------------------------------------------

end.
