unit RefundF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, StrUtils, Math, Mask, Menus, EnterToTab, ClipBrd,
  GlobVar, VarConst, EntWindowSettings, OrderPaymentsInterfaces,
  ExtCtrls, ComCtrls, RefundPaymentFrame, ContactsManager;

Type
  TfrmOrderPaymentRefundNotificationMode = (opnDontNotify, opnNotifyOnRefund);

  TfrmOrderPaymentRefund = class(TForm)
    panRefund: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    lblCreditCardPayment: TLabel;
    Label28: TLabel;
    Label1: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    btnRefund: TButton;
    btnCancel: TButton;
    chkPrintVATReceipt: TCheckBox;
    scrollPayments: TScrollBox;
    lstCreditCardPayment: TComboBox;
    edtRefundReason: TEdit;
    ccyTotalRefund: TCurrencyEdit;
    ccyTotalVATRefund: TCurrencyEdit;
    ccyTotalGoodsREfund: TCurrencyEdit;
    EnterToTab1: TEnterToTab;
    mnuPopup: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    optStoreCoordinates: TMenuItem;
    N3: TMenuItem;
    panManualVATWarning: TPanel;
    Label8: TLabel;
    edtRefundDate: TEditDate;
    procedure FormCreate(Sender: TObject);
    procedure btnRefundClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    FNotificationHandle : THandle;
    FOrderPaymentTransInfo : IOrderPaymentsTransactionPaymentInfo;

    PaymentFrames : Array of TframePaymentDetails;

    FColorsChanged : Boolean;
    FSettings : IWindowSettings;

    accountContacts :TContactsManager;
    
    Procedure ConfigureDialog;
    Procedure ConfigureForCreditCards;
    procedure LoadPaymentsList;

    procedure OnUpdateTotals(Sender: TObject);

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
    Property NotificationHandle : THandle Read FNotificationHandle Write FNotificationHandle;
    Property OrderPaymentTransInfo : IOrderPaymentsTransactionPaymentInfo Read FOrderPaymentTransInfo;

    Constructor Create (      AOwner : TComponent;
                        Const ParentForm : TForm;
                        Const OPTransInfo : IOrderPaymentsTransactionPaymentInfo); ReIntroduce;
    Destructor Destroy; Override;
  end;


// Displays Refund window for SOR/SDN/SIN transactions
Procedure OPDisplayRefundWindow (Const OPTransInfo : IOrderPaymentsTransactionPaymentInfo;
                                 Const ParentForm : TForm;
                                 Const NotifyMode : TfrmOrderPaymentRefundNotificationMode = opnDontNotify);

implementation

{$R *.dfm}

Uses ETStrU, ETMiscU, ETDateU, BTSupU1, InvListU, {HelpContextIds,}
     AuditNotes, BtrvU2, ExWrap1U, CurrncyU, PWarnU, UA_Const, VarRec2U, PassWr2U, BTKeys1U,
     RpDevice, RpDefine,  // Printing Interface
     PrintFrm,  // Exchequer Form Printing funcs
     PrntDlg2,  // Print Dialog and roles functions
     DayBk2,    // Transaction Daybooks
     AccountContactRoleUtil,
     oCreditCardGateway,
     oOrderPaymentsRefundManager,
     oOPPayment, oOrderPaymentsSRC;

Const
  MinWindowHeight = 330;

//=========================================================================

// Displays Refund window for SOR/SDN/SIN transactions
Procedure OPDisplayRefundWindow (Const OPTransInfo : IOrderPaymentsTransactionPaymentInfo;
                                 Const ParentForm : TForm;
                                 Const NotifyMode : TfrmOrderPaymentRefundNotificationMode = opnDontNotify);
var
  frmRefund : TfrmOrderPaymentRefund;
Begin // OPDisplayRefundWindow
  frmRefund := TfrmOrderPaymentRefund.Create (Application.MainForm, ParentForm, OPTransInfo);
  If (NotifyMode <> opnDontNotify) Then
    frmRefund.NotificationHandle := ParentForm.Handle;
  frmRefund := NIL;
End; // OPDisplayRefundWindow

//=========================================================================

Constructor TfrmOrderPaymentRefund.Create (      AOwner : TComponent;
                                           Const ParentForm : TForm;
                                           Const OPTransInfo : IOrderPaymentsTransactionPaymentInfo);
Begin // Create
  Inherited Create (AOwner);

  If Assigned(ParentForm) Then
  Begin
    Self.Left := ParentForm.Left + (ParentForm.Width Div 2) - (Self.Width Div 2);
    If (Self.Left <= 0) Then
      Self.Left := 1;
    Self.Top := ParentForm.Top + (ParentForm.Height Div 2) - (Self.Height Div 2);
    If (Self.Top <= 0) Then
      Self.Top := 1;
  End; // If Assigned(ParentForm)

  // Setup local structures and configure the dialog
  FOrderPaymentTransInfo := OPTransInfo;
  ConfigureDialog;
  ConfigureForCreditCards;

  // Load the saved window position / colours
  FColorsChanged := False;
  FSettings := GetWindowSettings(Self.ClassName);
  If Assigned(FSettings) Then
  Begin
    FSettings.LoadSettings;

    If (Not FSettings.UseDefaults) Then
    Begin
      FSettings.SettingsToWindow(Self);
      FSettings.SettingsToParent(Self);
    End; // If (Not FSettings.UseDefaults)
  End; // If Assigned(FSettings)

  LoadPaymentsList;
End; // Create

//------------------------------

Destructor TfrmOrderPaymentRefund.Destroy;
Begin // Destroy
  If Assigned(FSettings) And (optStoreCoordinates.Checked Or FColorsChanged) Then
  Begin
    FSettings.WindowToSettings(Self);
    FSettings.ParentToSettings(Self,edtRefundReason);
    FSettings.SaveSettings(optStoreCoordinates.Checked);
  End; // If Assigned(FSettings) And (optStoreCoordinates.Checked Or FColorsChanged)
  FSettings := NIL;

  FOrderPaymentTransInfo := NIL;

  Inherited Destroy;
End; // Destroy

//------------------------------

procedure TfrmOrderPaymentRefund.FormCreate(Sender: TObject);
Begin // FormCreate
  // DO NOT USE - Use TfrmOrderPayment.Create instead
End; // FormCreate

//------------------------------

procedure TfrmOrderPaymentRefund.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//------------------------------

Procedure TfrmOrderPaymentRefund.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X:=Width;
    ptMinTrackSize.Y:=MinWindowHeight;

    ptMaxTrackSize.X:=Width;
    ptMaxTrackSize.Y:=Screen.Height;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo

//-------------------------------------------------------------------------

procedure TfrmOrderPaymentRefund.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  LockWindowUpdate(self.Handle);
  try
    scrollPayments.VertScrollBar.Position := scrollPayments.VertScrollBar.Position + scrollPayments.VertScrollBar.Increment;
    Handled := True;
  finally
    LockWindowUpdate(0);
  end;
end;

//------------------------------

procedure TfrmOrderPaymentRefund.FormMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  LockWindowUpdate(self.Handle);
  try
    scrollPayments.VertScrollBar.Position := scrollPayments.VertScrollBar.Position - scrollPayments.VertScrollBar.Increment;
    Handled := True;
  finally
    LockWindowUpdate(0);
  end;
end;

//-------------------------------------------------------------------------

Procedure TfrmOrderPaymentRefund.ConfigureDialog;
Begin // ConfigureDialog
  // Caption
  Caption := 'Refund ' + FOrderPaymentTransInfo.optTransaction.OurRef;

  // Set currency symbols on footer totals - need to set value to cause the field to paint properly
  ccyTotalGoodsRefund.CurrencySymb := FOrderPaymentTransInfo.optCurrencySymbol;
  ccyTotalGoodsRefund.Value := 0.0;
  ccyTotalVATRefund.CurrencySymb := FOrderPaymentTransInfo.optCurrencySymbol;
  ccyTotalVATRefund.Value := 0.0;
  ccyTotalRefund.CurrencySymb := FOrderPaymentTransInfo.optCurrencySymbol;
  ccyTotalRefund.Value := 0.0;

  // MH 16/12/2014 ABSEXCH-15940: Show the Manual VAT warning for transactions with Manual VAT enabled
  panManualVATWarning.Caption := 'Warning: This transaction has ' + CCVATName^ + ' Content Amended set, please check figures';
  panManualVATWarning.Visible := FOrderPaymentTransInfo.optTransaction.ManVAT;
  ClientHeight := panRefund.Top + panRefund.Height;
End; // ConfigureDialog

//------------------------------

procedure TfrmOrderPaymentRefund.ConfigureForCreditCards;
var
  index : integer;
  ccpRoleContacts : TArrayOfAccountContacts;
  ccpRoleID : integer;

  Procedure AddCreditCardOption (Const CreditCardOption : enumCreditCardAction);
  Var
    EnumVal : LongInt;
    EnumPtr : Pointer Absolute EnumVal;
  Begin // AddCreditCardOption
    EnumVal := Ord(CreditCardOption);
    lstCreditCardPayment.AddItem (CreditCardActionDescriptions[CreditCardOption], EnumPtr);
  End; // AddCreditCardOption

Begin // ConfigureForCreditCards
  // Always populate the Credit Card combo with the No Action option as the default - KH decided to
  // always show the credit card option as a selling feature to try and encourage people to buy it.
  lstCreditCardPayment.Clear;
  AddCreditCardOption (ccaNoAction);
  lstCreditCardPayment.ItemIndex := 0;

  // Implement User Permission check
  // MH 03/02/2015 v7.1 ABSEXCH-16122: Corrected to check REFUND permission
  lstCreditCardPayment.Enabled := (CreditCardPaymentGateway.ccpgInstalled and CreditCardPaymentGateway.ccpgLicenced) and
                                  CreditCardPaymentGateway.ccpgCompanyEnabled And
                                  ChkAllowed_In(uaAllowCreditCardRefund);
  If lstCreditCardPayment.Enabled Then
  Begin
    // Populate list with the mode specific Credit Card Options
    AddCreditCardOption (ccaRequestRefund);

    // PKR. 15/05/2015. ABSEXCH-16424. Contact details no longer needed for Refunds.
    // Removed the contact combo box and code that populates it.

  End // If lstCreditCardPayment.Enabled
  Else
  Begin
    lblCreditCardPayment.Font.Color := clBtnShadow;
  End; // Else
End; // ConfigureForCreditCards

//-------------------------------------------------------------------------

procedure TfrmOrderPaymentRefund.LoadPaymentsList;
Var
  I, NextTop : Integer;
  bGotCreditCardPayment : Boolean;
Begin // LoadPaymentsList
  // MH 05/08/2015 2015-R1 ABSEXCH-16694: Disable the option for Credit Card Refunds if no Credit Card Payments
  bGotCreditCardPayment := False;

  NextTop := 1;
  For I := 0 To (FOrderPaymentTransInfo.oppiPaymentCount - 1) Do
  Begin
    // Create a new entry in the dynamic array storing the frames
    SetLength(PaymentFrames, Length(PaymentFrames) + 1);

    PaymentFrames[Length(PaymentFrames) - 1] := TframePaymentDetails.Create(Self);
    With PaymentFrames[Length(PaymentFrames) - 1] Do
    Begin
      // Create a new instance of the frame to display the payment details and
      // position it within the scrollbox
      Name := Name + IntToStr(Length(PaymentFrames));
      Parent := scrollPayments;
      Top := NextTop;
      Left := 1;
      SetColours(edtRefundReason.Font, edtRefundReason.Color);

      // Setup event handler so the frames can notify the form to recalculate the refund totals
      OnUpdateTotals := Self.OnUpdateTotals;

      // Set reference to Payment Header interface
      PaymentInfo := FOrderPaymentTransInfo.oppiPayments[I];

	  // MH 16/12/2014 ABSEXCH-15940: Pass through the Manual VAT Setting for the Refund Detail window
      ManualVAT := FOrderPaymentTransInfo.optTransaction.ManVAT;

      // Update position for next frame
      NextTop := NextTop + Height;
    End; // With PaymentFrames[Length(PaymentFrames) - 1]

    // MH 05/08/2015 2015-R1 ABSEXCH-16694: Disable the option for Credit Card Refunds if no Credit Card Payments
    If (Not bGotCreditCardPayment) Then
      bGotCreditCardPayment := (FOrderPaymentTransInfo.oppiPayments[I].opphCreditCardType <> '');
  End; // For I

  // Automatically resize form to hide any gap at the bottom of the scroll-box
  If (NextTop < scrollPayments.ClientHeight) Then
  Begin
    // Check we don't make it smaller than the minimum
    If ((Self.Height - (scrollPayments.ClientHeight - NextTop)) > MinWindowHeight) Then
      Self.Height := Self.Height - (scrollPayments.ClientHeight - NextTop)
    Else
      Self.Height := MinWindowHeight;
  End; // If (NextTop < scrollPayments.ClientHeight)

  // MH 05/08/2015 2015-R1 ABSEXCH-16694: Disable the option for Credit Card Refunds if no Credit Card Payments
  If (Not bGotCreditCardPayment) Then
  Begin
    lstCreditCardPayment.ItemIndex := 0;
    lstCreditCardPayment.Enabled := False;
  End // If (Not bGotCreditCardPayment)
  Else
    // MH 05/08/2015 2015-R1 ABSEXCH-16695: Default to Credit Card Refund if Credit Card Payment detected
    lstCreditCardPayment.ItemIndex := 1;
End; // LoadPaymentsList

//-------------------------------------------------------------------------

// Event handler called from payment frames when something has occurred which changes
// the refund value
procedure TfrmOrderPaymentRefund.OnUpdateTotals(Sender: TObject);
Var
  TotalGoodsRefund, TotalVATRefund : Double;
  I : Integer;
Begin // OnUpdateTotals
  TotalGoodsRefund := 0.0;
  TotalVATRefund := 0.0;

  // Run through the payment frames accumulating the refund values to update the totals
  For I := Low(PaymentFrames) To High(PaymentFrames) Do
  Begin
    TotalGoodsRefund := TotalGoodsRefund + PaymentFrames[I].RefundGoods;
    TotalVATRefund := TotalVATRefund + PaymentFrames[I].RefundVAT;
  End; // For I

  ccyTotalGoodsRefund.Value := TotalGoodsRefund;
  ccyTotalVATRefund.Value := TotalVATRefund;
  ccyTotalRefund.Value := TotalGoodsRefund + TotalVATRefund;
End; // OnUpdateTotals

//-------------------------------------------------------------------------

procedure TfrmOrderPaymentRefund.btnRefundClick(Sender: TObject);
Var
  oRefundManager : TOrderPaymentsRefundManager;
  PrintJobSetup  :  TSBSPrintSetupInfo;
  bValid, bPrint, bGotOne : Boolean;
  Res, I, FormCount : Integer;
  FormDefName : Str10;
  ThisFont   : TFont;
  ThisOrient : TOrientation;
  sKey, sDesc : Str255;
  index  : integer;
begin
  // Run through the frames and check a refund has been specified and validate the details
  bValid := True;
  bPrint := False;
  bGotOne := False;
  For I := Low(PaymentFrames) To High(PaymentFrames) Do
  Begin
    // skip if the SRC hasn't been ticked for refund or no refund value has been specified
    If PaymentFrames[I].RefundRequired And ((PaymentFrames[I].RefundGoods <> 0.0) Or (PaymentFrames[I].RefundVAT <> 0.0)) Then
    Begin
      // Check that a refund value has been set
      bGotOne := True;

      // Perform any required validation within the frame
      bValid := PaymentFrames[I].Validate;
      If (Not bValid) Then
        Break;
    End; // If PaymentFrames[I].RefundRequired And ((PaymentFrames[I].RefundGoods <> 0.0) Or (PaymentFrames[I].RefundVAT <> 0.0))
  End; // For I

  // Validate this form here
  If bValid Then
  Begin
    // At least one refund must be specified
    bValid := bGotOne;
    If (Not BValid) Then
    Begin
      MessageDlg ('No Refund Value has been specified', mtWarning, [mbOK], 0);
      If scrollPayments.CanFocus Then
        scrollPayments.SetFocus;
    End; // If (Not BValid)
  End; // If bValid

  // MH 30/06/2015 2015-R1 ABSEXCH-16507: Added Refund Date into Refund dialog
  If bValid Then
  Begin
    bValid := ValidDate(edtRefundDate.DateValue);
    If (Not bValid) Then
    Begin
      MessageDlg ('The Refund Date must be set', mtWarning, [mbOK], 0);
      If edtRefundDate.CanFocus Then
        edtRefundDate.SetFocus;
    End; // If (Not bValid)
  End; // If bValid

  If bValid then
  begin
    // PKR. 30/1/2015. ABSEXCH-16106. Prevent multiple clicks of this button.
    btnRefund.Enabled := false;
    // PKR. 24/02/2015. ABSEXCH-16193. Prevent Cancel while waiting for the portal to respond.
    btnCancel.Enabled := false;

    // Setup default printer details and display the print dialog
    FillChar(PrintJobSetup, SizeOf(PrintJobSetup), #0);
    PrintJobSetup.NoCopies := 1;
    PrintJobSetup.DevIdx := -1;

    With FOrderPaymentTransInfo.ExLocal^ Do
    Begin
      // The customer record is needed for Credit Cards.

      // Load customer account to pickup form def set
      sKey := FullCustCode(FOrderPaymentTransInfo.optTransaction.CustCode);
      Res := LFind_Rec(B_GetEq, CustF, CustCodeK, sKey);

      // Want a VAT receipt?
      if chkPrintVATReceipt.Checked Then
      Begin
        If (Res = 0) Then
          FormDefName := pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[66]   // 'Order Refund (SRC) as VAT Receipt'
        Else
          FormDefName := pfGetMultiFrmDefs(0).FormDefs.PrimaryForm[66];   // 'Order Refund (SRC) as VAT Receipt'

        PrintJobSetup.feMiscOptions[10] := True; {Get fax and eml cover sheet from account settings}
        AssignToGlobal(CustF);

        // Look for a Send Receipt Contact Role for the Customer
        SetEcommsFromCust_WithRole (LCust, PrintJobSetup, FOrderPaymentTransInfo.ExLocal, BOn, riSendReceipt);

        PrintJobSetup.feEmailSubj := 'VAT Receipt From ' + Syss.UserName;

        Case LCust.StatDMode of
          0 : PrintJobSetup.fePrintMethod := 0; // Print Hard Copy -> Printer
          1 : PrintJobSetup.fePrintMethod := 1; // Via Fax -> Fax
          2 : PrintJobSetup.fePrintMethod := 2; // Via email -> Email
          3 : PrintJobSetup.fePrintMethod := 1; // Fax & Hard Copy -> Fax
          4 : PrintJobSetup.fePrintMethod := 2; // email & Hard Copy -> Email
        End; // Case LCust.StatDMode

        ThisFont:=TFont.Create;
        Try
          bPrint := pfSelectFormPrinter(PrintJobSetup, BOn, FormDefName, ThisFont, ThisOrient);
        Finally
          ThisFont.Free;
        End; // Try..Finally

        If bPrint Then
          // Initialise a new form printing batch
          pfInitNewBatch(BOff,BOn);
      End; // if chkPrintVATReceipt.Checked
    End; // With FOrderPaymentTransInfo.ExLocal^
  End; // If bValid and chkPrintVATReceipt.Checked

  If bValid Then
  Begin
    // Run through the payment frames and execute each refund in turn
    FormCount := 0;
    For I := Low(PaymentFrames) To High(PaymentFrames) Do
    Begin
      If PaymentFrames[I].RefundRequired Then
      Begin
        // Create refund object and populate the details - create a new one for each payment
        // to avoid any potential cross-polination of details
        oRefundManager := TOrderPaymentsRefundManager.Create (FOrderPaymentTransInfo.ExLocal);
        Try
          // PKR. Added for credit card refunds.
          // Pass in the customer record so we can get contact details, addresses etc.
          oRefundManager.rmAccount := FOrderPaymentTransInfo.ExLocal^.LCust;

          // PKR. 15/05/2015. ABSEXCH-16424. Contact details no longer needed for Refunds
          // as it is handled by the Portal.  Code that used contact details removed.

          // Pass in reference to Payment Info interface from frame to access details
          oRefundManager.rmPaymentInfo := FOrderPaymentTransInfo;
          // Pass in reference to PaymentHeader interface from frame to access refund details
          oRefundManager.rmPaymentTransaction := PaymentFrames[I].PaymentInfo;
          oRefundManager.rmRefundReason := edtRefundReason.Text;

          // MH 05/08/2015 2015-R1 ABSEXCH-16694: Automatically do a 'Create SRC Only' refund for non-Credit Card Transactions
          If (PaymentFrames[I].PaymentInfo.opphCreditCardType = '') Then
            // Not a Credit Card Payment - automatically do a refund to SRC only 
            oRefundManager.rmCreditCardAction := ccaNoAction
          Else
            // Credit Card Option - Extract the Credit Card Action from the selected items Object
            oRefundManager.rmCreditCardAction := enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]);

          // MH 30/06/2015 2015-R1 ABSEXCH-16625: Added Refund Date into Refund dialog
          oRefundManager.rmRefundDate := edtRefundDate.DateValue;

          Res := oRefundManager.ExecuteRefund;
          If (Res = 0) Then
          Begin
            If bPrint Then
            Begin
              // Add this SRC into the batch of forms to be printed
              With FOrderPaymentTransInfo.ExLocal^ Do
                pfAddBatchForm(PrintJobSetup,
                               31,
                               FormDefName,
                               InvF, InvFolioK, FullNomKey(LInv.FolioNum),
                               IDetailF, IdFolioK, FullNomKey(LInv.FolioNum),
                               'VAT Receipt ' + LInv.OurRef,
                               nil,
                               BOn);
              FormCount := FormCount + 1;
            End; // If bPrint
          End // If (Res = 0)
          Else
          begin
            // Check for validation errors
            if (ccValidationErrors(Res) >= veInvalidPaymentProvider) and
               (ccValidationErrors(Res) <= veInvalidGrossTotal) then
            begin
              CCGatewayReportValidationError(Res);
              // Report this back as an error status from the portal
              Res := Ord(gsiError);
              Screen.Cursor := crDefault;
            end
            else //PR: 03/02/2015 ABSEXCH-15934 Added error reporting
            begin
              // PKR. 05/02/2015. Except when it's a credit card action because that is handled elsewhere.
              if oRefundManager.rmCreditCardAction = ccaNoAction then
              begin
                ReportOrderPaymentError(Res, 'Refund');
              end;
            end;
          end;
        Finally
          FreeAndNIL(oRefundManager);
        End; // Try..Finally
      End; // If PaymentFrames[I].RefundRequired
    End; // For I

    // MH 22/10/2014 ABSEXCH-15698: Update the SIN daybook if open
    OrdPay_UpdateDaybooks (FOrderPaymentTransInfo.ExLocal^.LInv.OurRef);

    If bPrint And (FormCount > 0) Then
    Begin
      // Load SRC and print
      sDesc := 'VAT Receipt' + IfThen(FormCount > 1, 's', '') + ' for Refund against ' + FOrderPaymentTransInfo.optTransaction.OurRef;
      pfPrintBatch (sDesc, PrintJobSetup.NoCopies, True, sDesc);
    End; // If bPrint And (FormCount > 0)

    // Send a message to the window that called this routine so it can update
    If (FNotificationHandle <> 0) Then
      PostMessage (FNotificationHandle, WM_RefreshButtons, 0, 0);

    //PR: 01/09/2014 Changed from Close; to avoid random crashes.
    PostMessage(Self.Handle, WM_CLOSE, 0, 0);
  End; // If bValid
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPaymentRefund.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPaymentRefund.PropFlgClick(Sender: TObject);
Var
  I : Integer;
begin
  If (FSettings.Edit(Self, edtRefundReason) = mrOK) Then
  Begin
    For I := Low(PaymentFrames) To High(PaymentFrames) Do
      PaymentFrames[I].SetColours(edtRefundReason.Font, edtRefundReason.Color);
    FColorsChanged := True;
  End; // If (FSettings.Edit(Self, edtRefundReason) = mrOK)
end;

//=========================================================================

end.
