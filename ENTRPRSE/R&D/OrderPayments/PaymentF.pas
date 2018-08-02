unit PaymentF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, StrUtils, Math, Mask, Menus, EnterToTab, ClipBrd,
  GlobVar, VarConst, EntWindowSettings, oOrderPaymentsTransactionInfo,
  ContactsManager, ExtCtrls;

Type
  // Note: Refunds against SDN's not allowed, refunds against SIN's use different UI
  TfrmOrderPaymentModes = (oprSORPayment, oprSDNPayment, oprSINPayment);

  TfrmOrderPaymentNotificationMode = (opnDontNotify, opnNotifyOnPayment);

Type
  TfrmOrderPayment = class(TForm)
    panManualVATWarning: TPanel;
    panPayment: TPanel;
    Label1: TLabel;
    lblGLDesc: TLabel;
    lblPaymentReference: TLabel;
    lblCreditCrdPayment: TLabel;
    lblOutstanding: TLabel;
    lblPaymentCCDept: TLabel;
    radFullPayment: TRadioButton;
    radPartPayment: TRadioButton;
    edtPaymentReference: TEdit;
    btnTakePayment: TButton;
    btnCancel: TButton;
    lstCreditCardPayment: TComboBox;
    ccyPartPaymentAmount: TCurrencyEdit;
    ccyPartPaymentOutstanding: TCurrencyEdit;
    chkPrintVATReceipt: TCheckBox;
    edtPaymentGL: Text8Pt;
    edtPaymentCostCentre: Text8Pt;
    edtPaymentDepartment: Text8Pt;
    EnterToTab1: TEnterToTab;
    mnuPopup: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    optStoreCoordinates: TMenuItem;
    N3: TMenuItem;
    panContactDetails: TPanel;
    lstCreditCardContact: TComboBox;
    radContactRole: TRadioButton;
    radManualContact: TRadioButton;
    edtContactName: Text8Pt;
    lblContactDetails: TLabel;
    labManualVATWarning: TLabel;
    Label3: TLabel;
    edtReceiptDate: TEditDate;
    procedure FormCreate(Sender: TObject);
    procedure btnTakePaymentClick(Sender: TObject);
    procedure DoCheckyChecky(Sender: TObject);
    procedure ccyPartPaymentAmountChange(Sender: TObject);
    procedure ccyPartPaymentAmountExit(Sender: TObject);
    procedure edtPaymentGLExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure edtPaymentCostCentreExit(Sender: TObject);
    procedure lstCreditCardPaymentChange(Sender: TObject);
    procedure DoCheckyChecky2(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FMode : TfrmOrderPaymentModes;
    FNotificationHandle : THandle;
    FOrderPaymentTransInfo : IOrderPaymentsTransactionInfo;

    FColorsChanged : Boolean;
    FSettings : IWindowSettings;

    accountContacts :TContactsManager;

    oGLCode              : integer;
    oPaymentProvider     : int64;
    oMerchantID          : int64;
    oCostCentre          : string;
    oDepartment          : string;
    oPaymentProviderDesc : string;

    Procedure ConfigureDialog;
    Procedure ConfigureForCreditCards;
  public
    { Public declarations }
    Property Mode : TfrmOrderPaymentModes Read FMode;
    Property NotificationHandle : THandle Read FNotificationHandle Write FNotificationHandle;
    Property OrderPaymentTransInfo : IOrderPaymentsTransactionInfo Read FOrderPaymentTransInfo;

    Constructor Create (      AOwner : TComponent;
                        Const DlgMode : TfrmOrderPaymentModes;
                        Const ParentForm : TForm;
                        Const OPTransInfo : IOrderPaymentsTransactionInfo); ReIntroduce;
    Destructor Destroy; Override;
  end;


// Displays Payment window for SOR/SDN/SIN transactions
Procedure OPDisplayPaymentWindow (Const OPTransInfo : IOrderPaymentsTransactionInfo;
                                  Const ParentForm : TForm;
                                  Const NotifyMode : TfrmOrderPaymentNotificationMode = opnDontNotify);

implementation

{$R *.dfm}

Uses ETStrU, ETDateU, ETMiscU, BTSupU1, InvListU, {HelpContextIds,}
     AuditNotes, ExWrap1U, CurrncyU, PWarnU, UA_Const, VarRec2U, PassWr2U, BTKeys1U,
     DefProcU,   // Form Printing
     DayBk2,    // MH 22/10/2014 ABSEXCH-15698: Update the SIN daybook if open
     oCreditCardGateway,
     oOPPayment, apiUtil, oOrderPaymentsSRC;

//=========================================================================

// Displays Payment window for SOR/SDN/SIN transactions
Procedure OPDisplayPaymentWindow (Const OPTransInfo : IOrderPaymentsTransactionInfo;
                                  Const ParentForm : TForm;
                                  Const NotifyMode : TfrmOrderPaymentNotificationMode = opnDontNotify);
var
  frmPayment : TfrmOrderPayment;
  DlgMode : TfrmOrderPaymentModes;
Begin // OPDisplayPaymentWindow
  // Display Payment dialog
  Case OPTransInfo.optTransaction.InvDocHed Of
    SOR : DlgMode := oprSORPayment;
    SDN : DlgMode := oprSDNPayment;
    SIN : DlgMode := oprSINPayment;
  Else
    Raise Exception.Create ('OPDisplayPaymentWindow: Invalid Transaction Type (' + IntToStr(Ord(OPTransInfo.optTransaction.InvDocHed)) + ')');
  End; // OPTransInfo.Transaction.InvDocHed

  frmPayment := TfrmOrderPayment.Create (Application.MainForm, DlgMode, ParentForm, OPTransInfo);
  If (NotifyMode <> opnDontNotify) Then
    frmPayment.NotificationHandle := ParentForm.Handle;
  frmPayment := NIL;
End; // OPDisplayPaymentWindow

//=========================================================================

Constructor TfrmOrderPayment.Create (      AOwner : TComponent;
                                     Const DlgMode : TfrmOrderPaymentModes;
                                     Const ParentForm : TForm;
                                     Const OPTransInfo : IOrderPaymentsTransactionInfo);
Begin // Create
  Inherited Create (AOwner);

  FNotificationHandle := 0;

  If Assigned(ParentForm) Then
  Begin
    Self.Left := ParentForm.Left + (ParentForm.Width Div 2) - (Self.Width Div 2);
    // MH 30/06/2015 2015-R1: Fixed fault in passing where window was appearing off screen
	If (Self.Left <= 0) Then
      Self.Left := 1;

    Self.Top := ParentForm.Top + (ParentForm.Height Div 2) - (Self.Height Div 2);
	// MH 30/06/2015 2015-R1: Fixed fault in passing where window was appearing off screen
    If (Self.Top <= 0) Then
      Self.Top := 1;
  End; // If Assigned(ParentForm)

  // Load the saved window position / colours - needs to be before the ConfigureDialog call
  // which can change the height due to the Manual VAT warning label
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

  // Setup local structures and configure the dialog
  FMode := DlgMode;
  FOrderPaymentTransInfo := OPTransInfo;
  ConfigureDialog;
  ConfigureForCreditCards;

  DoCheckyChecky(Self);
End; // Create

//------------------------------

Destructor TfrmOrderPayment.Destroy;
Begin // Destroy
  If Assigned(FSettings) And (optStoreCoordinates.Checked Or FColorsChanged) Then
  Begin
    FSettings.WindowToSettings(Self);
    FSettings.ParentToSettings(Self,ccyPartPaymentAmount);
    FSettings.SaveSettings(optStoreCoordinates.Checked);
  End; // If Assigned(FSettings) And (optStoreCoordinates.Checked Or FColorsChanged)
  FSettings := NIL;

  FOrderPaymentTransInfo := NIL;

  Inherited Destroy;
End; // Destroy

//------------------------------

procedure TfrmOrderPayment.FormCreate(Sender: TObject);
Begin // FormCreate
  // DO NOT USE - Use TfrmOrderPayment.Create instead
End; // FormCreate

//------------------------------

procedure TfrmOrderPayment.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//-------------------------------------------------------------------------

Procedure TfrmOrderPayment.ConfigureDialog;
Var
  CCDept: CCDepType;
  FoundCode, Offset : LongInt;
Begin // ConfigureDialog
  // Caption
  Case FMode Of
    oprSORPayment    : Caption := 'Take Order Payment - ' + FOrderPaymentTransInfo.optTransaction.OurRef;
    oprSDNPayment    : Caption := 'Take Delivery Payment - ' + FOrderPaymentTransInfo.optTransaction.OurRef;
    oprSINPayment    : Caption := 'Take Invoice Payment - ' + FOrderPaymentTransInfo.optTransaction.OurRef;
  Else
    Caption := 'Unknown Mode';
  End; // Case FMode

  // MH 16/12/2014 ABSEXCH-15940: Show the Manual VAT warning for transactions with Manual VAT enabled
  labManualVATWarning.Caption := 'Warning: This transaction has ' + CCVATName^ + ' Content Amended set, please check figures';
  panManualVATWarning.Visible := FOrderPaymentTransInfo.optTransaction.ManVAT;
  ClientHeight := panPayment.Top + panPayment.Height;

  // Disable part payments for SDN/SIN transactions which only support Full payments
  If (FMode = oprSDNPayment) Then
  Begin
    radPartPayment.Enabled := False;
    ccyPartPaymentAmount.Enabled := False;
    ccyPartPaymentAmount.Color := ccyPartPaymentOutstanding.Color;
    ccyPartPaymentAmount.Text := '';
    lblOutstanding.Font.Color := clBtnShadow;
    ccyPartPaymentOutstanding.Enabled := False;
    ccyPartPaymentOutstanding.Text := '';
  End; // If (FMode = oprSDNPayment)

  // Populate form with transaction details ----------------------------------------

  // Payment Details
  radFullPayment.Caption := 'Full Payment - ' + FOrderPaymentTransInfo.optCurrencySymbol + FormatFloat(GenRealMask, FOrderPaymentTransInfo.optMaxPayment);
  If ccyPartPaymentAmount.Enabled Then
  Begin
    ccyPartPaymentAmount.CurrencySymb := FOrderPaymentTransInfo.optCurrencySymbol;
    ccyPartPaymentAmount.Value := 0.0;
  End; // If ccyPartPaymentAmount.Enabled

  If ccyPartPaymentOutstanding.Enabled Then
  Begin
    ccyPartPaymentOutstanding.CurrencySymb := FOrderPaymentTransInfo.optCurrencySymbol;
    ccyPartPaymentOutstanding.Value := 0.0;
  End; // If ccyPartPaymentOutstanding.Enabled
  ccyPartPaymentAmountChange(Self);

  edtPaymentGL.Text := IntToStr(FOrderPaymentTransInfo.GetDefaultPaymentGL);
  If GetNom(Self, edtPaymentGL.Text, FoundCode, -1, SUPPRESS_INACTIVE_GLCODES) Then
    lblGLDesc.Caption := Nom.Desc
  Else
    lblGLDesc.Caption := '';

  // Cost Centre / Department ------------------------------------------------------
  If (Not Syss.UseCCDep) Then
  Begin
    // Hide CC/Dept Fields
    lblPaymentCCDept.Visible := False;
    edtPaymentCostCentre.Visible := False;
    edtPaymentDepartment.Visible := False;

    // Move other fields up and resize dialog
    Offset := edtPaymentReference.Top - edtPaymentCostCentre.Top;
    lblPaymentReference.Top := lblPaymentReference.Top - Offset;
    edtPaymentReference.Top := edtPaymentReference.Top - Offset;
    chkPrintVATReceipt.Top := chkPrintVATReceipt.Top - Offset;
    btnTakePayment.Top := btnTakePayment.Top - Offset;
    btnCancel.Top := btnCancel.Top - Offset;
    Self.ClientHeight := Self.ClientHeight - Offset;
  End // If (Not Syss.UseCCDep)
  Else
  Begin
    // Load defaults from somewhere
    FillChar(CCDept, SizeOf(CCDept), #0);
    CCDept := GetCustProfileCCDep(FOrderPaymentTransInfo.optAccount.CustCC,FOrderPaymentTransInfo.optAccount.CustDep,CCDept,1);
    edtPaymentCostCentre.Text := CCDept[BOn];
    edtPaymentDepartment.Text := CCDept[BOff];
  End; // Else

  // Transaction Date ------------------------------------------------------
  edtReceiptDate.DateValue := Today;
End; // ConfigureDialog

//------------------------------

procedure TfrmOrderPayment.ConfigureForCreditCards;
var
  index : integer;
  ccpRoleContacts : TArrayOfAccountContacts;
  ccpRoleID : integer;
  defaultOptionIndex : integer;
  defaultIsCCPayment : boolean;

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
  ccpRoleContacts := nil;

    // PKR. 16/11/2015. ABSEXCH-16697. Re-order payment menthods.
    // Non Card Payment is now last on the list, and Pay By Card is first on the list.
    // If there is no CC add-in, then Non Card Payment will be item 0.
    // If there is a CC add-in, then Pay by Card will be item 0, so 0 works for both cases.
  DefaultOptionIndex := 0;

  defaultIsCCPayment := false;

  lstCreditCardPayment.Enabled := (CreditCardPaymentGateway.ccpgInstalled and CreditCardPaymentGateway.ccpgLicenced) and
                                  CreditCardPaymentGateway.ccpgCompanyEnabled And
                                  ChkAllowed_In(uaAllowCreditCardPayment);

  If lstCreditCardPayment.Enabled Then
  Begin
    // Populate list with the mode specific Credit Card Options
    // PKR. 16/11/2015. ABSEXCH-16697. Re-order the payment options.
    AddCreditCardOption (ccaRequestPayment);                // Request a payment
    AddCreditCardOption (ccaRequestPaymentAuthorisation);   // Request a card authentication

    // PKR. 16/11/2015. ABSEXCH-16697. Re-order payment options.  Moved here because you cannot
    // set the index if there are no items in the list.  Non Card Payment is now added at the end of the list.
    lstCreditCardPayment.ItemIndex := 0;

    defaultIsCCPayment := true;

    // 24/09/2014. PKR. If the originating transaction already has a credit card authorisation (card authentication)
    //  then add the option to request a payment using that authorisation (authentication).
    if (self.FOrderPaymentTransInfo.optTransaction.thOrderPaymentFlags and thopfCreditCardAuthorisationTaken) <> 0 then
    begin
      // Authorisation taken bit is set, so add the option.
      AddCreditCardOption (ccaRequestPaymentUsingExistingAuth); // Request a payment using an existing authorisation code

      // PKR. 30/1/2015. ABSEXCH-16105. As we already have an authorisation, the default should be this action
      lstCreditCardPayment.ItemIndex := lstCreditCardPayment.Items.IndexOf(CreditCardActionDescriptions[ccaRequestPaymentUsingExistingAuth]);
      DefaultOptionIndex := lstCreditCardPayment.ItemIndex;
      defaultIsCCPayment := true;
    end;

    // Load Credit Card Contact Roles for the Customer Account into the lstCreditCardContact drop-down, disable field if no roles defined
    // Empty the combo box list
    lstCreditCardContact.Items.Clear;

    // Create a Contact Manager object
    accountContacts := NewContactsManager;
    // Set the customer account for the contacts manager
    accountContacts.SetCustomerRecord(self.OrderPaymentTransInfo.optAccount.CustCode);

    // MH 18/02/2015 v7.1 ABSEXCH-16151: Allow Contact Name to be edited
    edtContactName.Text := Trim(FOrderPaymentTransInfo.optAccount.Contact);

    // Load up the combo box with contact names which have the Credit Card payment role
    ccpRoleId := accountContacts.GetRoleIdByDescription('Credit Card Payment');
    ccpRoleContacts := accountContacts.GetContactListByRole(ccpRoleId);

    if Length(ccpRoleContacts) > 0 then
    begin
      // Populate the combo box
      for index := 0 to Length(ccpRoleContacts)-1 do
      begin
        lstCreditCardContact.AddItem(ccpRoleContacts[index].contactDetails.acoContactName, ccpRoleContacts[index]);
      end;
      lstCreditCardContact.Enabled := true;

      // Select the first name in the list
      lstCreditCardContact.ItemIndex := 0;

      // MH 18/02/2015 v7.1 ABSEXCH-16151: Allow Contact Name to be edited
      radContactRole.Tag := 1;  // Can be enabled
      radContactRole.Checked := True;
      radManualContact.Tag := 1;  // Can be enabled
    end
    else
    begin
      // No contacts found with this role, so disable the field
      lstCreditCardContact.Enabled := false;
      lstCreditCardContact.Text := 'No contacts available';

      // MH 18/02/2015 v7.1 ABSEXCH-16151: Allow Contact Name to be edited
      radContactRole.Tag := 0;  // Cannot be enabled
	  // MH 19/08/2015 2015-R1 ABSEXCH-16726: Fixed enabled status
      radManualContact.Tag := 1;  // Can be enabled
      radManualContact.Checked := True;
    end;

    // Force the call to GetDefaults, otherwise it will never happen unless the
    //  user selects a different CC Payment option.
    lstCreditCardPaymentChange(nil);
  End // If lstCreditCardPayment.Enabled
  Else
  Begin
    lblCreditCrdPayment.Font.Color := clBtnShadow;
    lblContactDetails.Font.Color := lblCreditCrdPayment.Font.Color;

    // MH 18/02/2015 v7.1 ABSEXCH-16151: Allow Contact Name to be edited
    radContactRole.Tag := 0;  // Cannot be enabled
    radManualContact.Tag := 0;  // Cannot be enabled
    edtContactName.Enabled := False;
    edtContactName.Color := clBtnFace;
  End; // Else

  // NON-CARD PAYMENT OPTION
  AddCreditCardOption (ccaNoAction);

  // Set the default entry in the combo box.
  lstCreditCardPayment.ItemIndex := defaultOptionIndex;

  // MH 18/02/2015 v7.1 ABSEXCH-16151: Allow Contact Name to be edited
  DoCheckyChecky2(Self);  // Update fields for selected radio button
End; // ConfigureForCreditCards

//-------------------------------------------------------------------------

procedure TfrmOrderPayment.btnTakePaymentClick(Sender: TObject);
var
  iPayment : IOrderPaymentsPayment;
  // MH 18/02/2015 v7.1 ABSEXCH-16151: Pass manual contact details through to Payment object as fake account contact
  FakeAccountContact : TAccountContact;
  Dbl : Double;
  FoundNom : LongInt;
  FoundCode : Str20;
  bValid : Boolean;
  Res : Integer;
  index : integer;
begin
  // MH 18/02/2015 v7.1 ABSEXCH-16151: Pass manual contact details through to Payment object as fake account contact
  FakeAccountContact := NIL;

  // Validate the Payment Amount
  bValid := radFullPayment.Checked;
  If (Not bValid) Then
  Begin
    // MH 19/09/2014 ABSEXCH-15647: Copied out and rounded due to issues
    Dbl := Round_Up(ccyPartPaymentAmount.Value, 2);
    bValid := radPartPayment.Checked And (Dbl > 0) And (Dbl <= FOrderPaymentTransInfo.optMaxPayment);
    If (Not bValid) Then
    Begin
      MessageDlg ('The Part Payment value must be greater than zero and cannot exceed the Full Payment value', mtWarning, [mbOK], 0);
      If ccyPartPaymentAmount.CanFocus Then
        ccyPartPaymentAmount.SetFocus;
    End; // If (Not bValid)
  End; // If (Not bValid)

  // MH 18/02/2015 v7.1 ABSEXCH-16151: Validate manual contact details
  If bValid And radManualContact.Checked and edtContactName.Enabled Then
  Begin
    bValid := CreditCardPaymentGateway.ValidateContactName(edtContactName.Text);
    If (Not bValid) Then
    Begin
      MessageDlg ('The Contact Name must contain at least a Firstname or Initial and a Surname', mtWarning, [mbOK], 0);
      If edtContactName.CanFocus Then
        edtContactName.SetFocus;
    End; // If (Not bValid)
  End; // If bValid And radManualContact.Checked and edtContactName.Enabled

  // MH 29/06/2015 2015-R1 ABSEXCH-16507: Added in Payment Date on Payment window
  // Validate the Payment Date
  If bValid Then
  Begin
    bValid := ValidDate(edtReceiptDate.DateValue);
    If (Not bValid) Then
    Begin
      MessageDlg ('The Receipt Date must be set', mtWarning, [mbOK], 0);
      If edtReceiptDate.CanFocus Then
        edtReceiptDate.SetFocus;
    End; // If (Not bValid)
  End; // If bValid

  // Validate the GL Code
  If bValid Then
  Begin
    bValid := GetNom (Self, edtPaymentGL.Text, FoundNom, IfThen(Syss.UseGLClass, 11, 77), SUPPRESS_INACTIVE_GLCODES);
    If bValid Then
    Begin
      // Check Currency
      bValid := (Nom.DefCurr = 0) Or (Nom.DefCurr = FOrderPaymentTransInfo.optCurrency);
      If (Not bValid) Then
        MessageDlg ('The Currency defined against the GL Code must be the same as the order currency', mtWarning, [mbOK], 0);
    End // If bValid
    Else
      MessageDlg ('The GL Code is not valid', mtWarning, [mbOK], 0);

    If (Not bValid) And edtPaymentGL.CanFocus Then
      edtPaymentGL.SetFocus;
  End; // If bValid

  If bValid And edtPaymentCostCentre.Visible Then
  Begin
    bValid := GetCCDep(Self, edtPaymentCostCentre.Text, FoundCode, True, -1);
    If (Not bValid) Then
    Begin
      MessageDlg ('A valid Cost Centre must be specified', mtWarning, [mbOK], 0);
      If edtPaymentCostCentre.CanFocus Then
        edtPaymentCostCentre.SetFocus;
    End; // If (Not bValid)
  End; // If bValid And edtPaymentCostCentre.Visible

  If bValid And edtPaymentDepartment.Visible Then
  Begin
    bValid := GetCCDep(Self, edtPaymentDepartment.Text, FoundCode, False, -1);
    If (Not bValid) Then
    Begin
      MessageDlg ('A valid Department must be specified', mtWarning, [mbOK], 0);
      If edtPaymentDepartment.CanFocus Then
        edtPaymentDepartment.SetFocus;
    End; // If (Not bValid)
  End; // If bValid And edtPaymentDepartment.Visible

  If bValid Then
  Begin
    // PKR. 19/02/2015. ABSEXCH-16193.  Disable the Cancel button because it could be pressed
    //  in the interval between clicking Take Payment and the modal status dialog being displayed.
    btnCancel.Enabled := false;
    // PKR. 30/1/2015. ABSEXCH-16106. Disable this button to prevent multiple clicks.
    btnTakePayment.Enabled := false;

    // Create a Payment object
    iPayment := NewOrderPayment;
    iPayment.oppOrderPaymentTransInfo := FOrderPaymentTransInfo;
    If radFullPayment.Checked Then
    Begin
      iPayment.oppPaymentType := ptFull;
      iPayment.oppPaymentValue := FOrderPaymentTransInfo.optMaxPayment;
    End // If radFullPayment.Checked
    Else
    Begin
      iPayment.oppPaymentType := ptPart;
      // MH 19/09/2014 ABSEXCH-15647: Copied out and rounded due to issues
      iPayment.oppPaymentValue := Round_Up(ccyPartPaymentAmount.Value, 2);
    End; // Else
    iPayment.oppPaymentGLCode := Nom.NomCode;
    iPayment.oppPaymentReference := edtPaymentReference.Text;
    // MH 29/06/2015 2015-R1 ABSEXCH-16507: Added in Payment Date on Payment window
    iPayment.oppSRCTransDate := edtReceiptDate.DateValue;

    // Credit Card Option - Extract the Credit Card Action from the selected items Object
    iPayment.oppCreditCardAction := enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]);
    // ABSEXCH-15856. PKR. 05/12/2014. Credit Card payments can take some time, so set an hourglass cursor
    if iPayment.oppCreditCardAction <> ccaNoAction then
    begin
      Screen.Cursor := crHourglass;
    end;

    If edtPaymentCostCentre.Visible Then
    Begin
      // Pass CC/Dept out to Payment object
      // PKR. 24/07/2015. ABSEXCH-16684. Non-CC Payments not being populated correctly.
      iPayment.oppPaymentCostCentre := edtPaymentCostCentre.Text;
      iPayment.oppPaymentDepartment := edtPaymentDepartment.Text;
    End; // If edtPaymentCostCentre.Visible

    iPayment.oppPaymentGLCode     := StrToInt(edtPaymentGL.Text);
    iPayment.oppProvider          := oPaymentProvider;
    iPayment.oppMerchantID        := oMerchantId;

    // For part payments it pro-ratas the payment value across the lines
    // Executes the appropriate credit card operation and creates the exchequer transactions, etc...

    // Get the details from the selected contact (if any)
    // If there isn't one, we'll pick them up from the customer record.
    if (lstCreditCardContact.Enabled) And radContactRole.Checked then
    begin
      // Contacts are enabled, but we might not have any
      index := lstCreditCardContact.ItemIndex;
      if (index >=0) then
      begin
        iPayment.SetContactDetails(lstCreditCardContact.Items.Objects[index] as TAccountContact);
      end;
    end
    // MH 18/02/2015 v7.1 ABSEXCH-16151: Pass manual contact details through to Payment object as fake account contact
    Else If edtContactName.Enabled and radManualContact.Checked Then
    Begin
      FakeAccountContact := TAccountContact.Create;
      FakeAccountContact.contactDetails.acoContactName := edtContactName.Text;
      FakeAccountContact.contactDetails.acoContactPhoneNumber := Trim(FOrderPaymentTransInfo.optAccount.Phone);
      FakeAccountContact.contactDetails.acoContactEmailAddress := Trim(FOrderPaymentTransInfo.optAccount.EmailAddr);
      FakeAccountContact.contactDetails.acoContactHasOwnAddress := False;
      iPayment.SetContactDetails(FakeAccountContact);
    End; // If edtContactName.Enabled and radManualContact.Checked

    Res := iPayment.CreatePayment;
    If (Res = 0) Then
    Begin
      // MH 27/10/2014 ABSEXCH-15698: Update the SIN daybook if open
      OrdPay_UpdateDaybooks (FOrderPaymentTransInfo.ExLocal^.LInv.OurRef);

      If chkPrintVATReceipt.Checked Then
      Begin
        // MH 02/10/2014: Print the Payment SRC as a VAT Receipt
        Control_DefProcess(31,  // fmOrdPayVATReceipt = 31; { Order Payments - printing SRC as VAT Receipt }
                           IdetailF, IdFolioK,
                           FullNomKey(FOrderPaymentTransInfo.ExLocal^.LInv.FolioNum),FOrderPaymentTransInfo.ExLocal^,BOn);
      End; // If chkPrintVATReceipt.Checked

      // Send a message to the window that called this routine so it can update
      If (FNotificationHandle <> 0) Then
        PostMessage (FNotificationHandle, WM_RefreshButtons, 0, 0);
    End // If (Res = 0)
    Else
    begin
      // Not successful.
      // ABSEXCH-15933. PKR. 15/12/2014. Check whether it was a credit card payment request and
      //  handle Res accordingly.
      if iPayment.oppCreditCardAction <> ccaNoAction then
      begin
        // Check for credit card validation errors
        if (ccValidationErrors(Res) >= veInvalidPaymentProvider) and
           (ccValidationErrors(Res) <= veInvalidGrossTotal) then
        begin
          CCGatewayReportValidationError(Res);
          // Report this back as an error status from the portal
          Res := Ord(gsiError);
          Screen.Cursor := crDefault;
        end;

        // ABSEXCH-15875. PKR. 05/12/2014. Cancelling a transaction at the Payment Provider is not passed back to the host app.
        // This was a bug in the Payment Portal. These code changes take advantage of the correct codes that are now passed back.

        // NOTE: Because Exchequer uses 0 = Success as standard, we have switched the first two of these values
        //  so OK is actually 0 and Pending is actually 1.
      end  // Credit card action
      else
      begin
        // Not a Credit Card action.

        ReportOrderPaymentError(Res, 'Payment');
      end;
    end; // Not successful

    // MH 18/02/2015 v7.1 ABSEXCH-16151: Pass manual contact details through to Payment object as fake account contact
    FreeAndNIL(FakeAccountContact);

    //Close form
    PostMessage(Handle, WM_CLOSE, 0, 0);
  End; // If Valid
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPayment.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPayment.DoCheckyChecky(Sender: TObject);
begin
  ccyPartPaymentAmount.Enabled := radPartPayment.Checked;
  lblOutstanding.Font.Color := IfThen(radPartPayment.Checked, clBlack, clBtnShadow);
  ccyPartPaymentOutstanding.Font.Color := IfThen(radPartPayment.Checked, edtPaymentGL.Font.Color, clBtnShadow);
end;

//-------------------------------------------------------------------------

// MH 18/02/2015 v7.1 ABSEXCH-16151: Reacts to radio buttons for Contact Role / Manual Entry
procedure TfrmOrderPayment.DoCheckyChecky2(Sender: TObject);
begin
  // Check the tags to determine if the individual radio buttons can be enabled - 0 = NO, 1 = YES

  // PKR. 04/11/2015. ABSEXCH-16725. Contact details aren't required for Payment Authorisation
  // as the Payment Provider already has those details.
  radContactRole.Enabled := (radContactRole.Tag > 0) And (enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]) <> ccaNoAction) and
                                                         (enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]) <> ccaRequestPaymentUsingExistingAuth);
  radManualContact.Enabled := (radManualContact.Tag > 0) And (enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]) <> ccaNoAction) and
                                                             (enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]) <> ccaRequestPaymentUsingExistingAuth);

  // Enable the fields if a Credit Card option is selected and the appropriate radio button is selected
  lstCreditCardContact.Enabled := radContactRole.Checked And (enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]) <> ccaNoAction) and
                                                             (enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]) <> ccaRequestPaymentUsingExistingAuth);
  edtContactName.Enabled := radManualContact.Checked And (enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]) <> ccaNoAction) and
                                                         (enumCreditCardAction(lstCreditCardPayment.Items.Objects[lstCreditCardPayment.ItemIndex]) <> ccaRequestPaymentUsingExistingAuth);
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPayment.ccyPartPaymentAmountChange(Sender: TObject);
var
  Dbl : Double;
begin
  // MH 19/11/2014 Order Payments ABSEXCH-15835: Only process the field if enabled - does weird things on SDN's otherwise
  If Assigned(FOrderPaymentTransInfo) And ccyPartPaymentAmount.Enabled Then
  Begin
    // Call UnformatText to force it to process the entered text and update the Value property
    ccyPartPaymentAmount.UnFormatText;

    // MH 19/09/2014 ABSEXCH-15647: Copied out and rounded due to issues
    Dbl := Round_Up(ccyPartPaymentAmount.Value, 2);
    If (Dbl >= 0) And (Dbl <= FOrderPaymentTransInfo.optMaxPayment) Then
    Begin
      ccyPartPaymentOutstanding.Font.Color := IfThen(radPartPayment.Checked, edtPaymentGL.Font.Color, clBtnShadow);

      ccyPartPaymentOutstanding.Value := Round_Up (FOrderPaymentTransInfo.optMaxPayment - Dbl, 2);
      ccyPartPaymentOutstanding.FormatText;
    End // If (Dbl >= 0) And (Dbl <= FOrderPaymentTransInfo.optMaxPayment)
    Else
    Begin
      ccyPartPaymentOutstanding.Font.Color := clRed;
      ccyPartPaymentOutstanding.Text := 'ERROR';
    End; // Else
  End; // If Assigned(FOrderPaymentTransInfo) And ccyPartPaymentAmount.Enabled
end;

//------------------------------

procedure TfrmOrderPayment.ccyPartPaymentAmountExit(Sender: TObject);
Var
  Dbl : Double;
begin
  If (ActiveControl <> btnCancel) And (ActiveControl <> radFullPayment) Then
  Begin
    // Force an update of the Value field (just in case)
    ccyPartPaymentAmountChange(Self);

    // MH 19/09/2014 ABSEXCH-15647: Copied out and rounded due to issues
    Dbl := Round_Up(ccyPartPaymentAmount.Value, 2);

    // If the entered part payment value is invalid then display an error and force the focus back
    If (Dbl <= 0) Or (Dbl > FOrderPaymentTransInfo.optMaxPayment) Then
    Begin
      MessageDlg ('The Part Payment value must be greater than zero and cannot exceed the Full Payment value', mtWarning, [mbOK], 0);
      If ccyPartPaymentAmount.CanFocus Then
        ccyPartPaymentAmount.SetFocus;
    End; // If (Dbl <= 0) Or (Dbl > FOrderPaymentTransInfo.optMaxPayment)
  End; // If (ActiveControl <> btnCancel) And (ActiveControl <> radFullPayment)
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPayment.edtPaymentGLExit(Sender: TObject);
Var
  FoundCode  :  Str20;
  FoundNom   :  LongInt;
  FoundOk    :  Boolean;
begin
  // Note: Copied from TCustRec3.edtAutoReceiptGLCodeExit
  If (Sender is Text8pt) Then
  Begin
    With (Sender as Text8pt) Do
    Begin
      AltMod:=Modified;

      FoundNom:=0;

      FoundCode:=Text;

      If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) then
      Begin
        StillEdit:=BOn;  // Prevents the edit field recopying the original value on return from a popup window

        // MH: As far as I can tell we need to use different modes if GL Classes are on:-
        //   11 = Bank Accounts if GL Classes are ON, but everything if they are OFF
        //   77 = Balance Sheet Only
        FoundOk := GetNom (Self, FoundCode, FoundNom, IfThen(Syss.UseGLClass, 11, 77), SUPPRESS_INACTIVE_GLCODES);

        {$IFDEF MC_ON}
        If (FoundOk) then
        Begin
          // Check the currency matches that defined for the account
          FoundOK := (Nom.DefCurr = 0) Or (Nom.DefCurr = FOrderPaymentTransInfo.optCurrency);
          If (Not FoundOK) Then
            MessageDlg('The Currency for the GL Code doesn''t match the Currency for the transaction', mtWarning, [mbOk], 0);
        End; // If (FoundOk)
        {$ENDIF}

        If (FoundOk) then
        Begin
          // MH 07/10/2014 ABSEXCH-15707: GL Description not updated when GL Code changed
          lblGLDesc.Caption := Nom.Desc;

          StillEdit:=BOff;
          Text:=Form_BInt(FoundNom,0);
        end
        else
        Begin
          // MH 07/10/2014 ABSEXCH-15707: GL Description not updated when GL Code changed
          lblGLDesc.Caption := '';

          SetFocus;
        End; // Else
      End; // If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text)
    End; // With (Sender as Text8pt)
  End; // If (Sender is Text8pt)
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPayment.edtPaymentCostCentreExit(Sender: TObject);
Var
  FoundCode : Str20;
  FoundOk, AltMod : Boolean;
begin
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If AltMod Or (FoundCode = '') Or (OrigValue <> Text) then
    Begin
      StillEdit:=BOn;

      FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,(Sender=edtPaymentCostCentre),2));

      If FoundOk Then
      Begin
        StillEdit:=BOff;

        Text:=FoundCode;
      End // If FoundOk
      Else
        If CanFocus Then
          SetFocus;
    End; // If AltMod Or (FoundCode = '') Or (OrigValue <> Text)
  End; // With (Sender as Text8pt)
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPayment.PropFlgClick(Sender: TObject);
begin
  If (FSettings.Edit(Self, ccyPartPaymentAmount) = mrOK) Then
    FColorsChanged := True;
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPayment.lstCreditCardPaymentChange(Sender: TObject);
var
  index        : integer;
  UDF5, UDF6, UDF7, UDF8, UDF9, UDF10 : string;
begin
  // If we've changed to a credit card option, then we need to get the default
  //  GLCode, CC and Department from the gateway.

  // The list is populated dynamically, so we need to determine what has been selected.
  index := lstCreditCardPayment.ItemIndex;

  // PKR. 29/01/2015. ABSEXCH-16099.  Added ccaRequestPaymentUsingExistingAuth.
  if (lstCreditCardPayment.Items[index] = CreditCardActionDescriptions[ccaRequestPaymentAuthorisation]) or
     (lstCreditCardPayment.Items[index] = CreditCardActionDescriptions[ccaRequestPayment]) or
     (lstCreditCardPayment.Items[index] = CreditCardActionDescriptions[ccaRequestPaymentUsingExistingAuth]) then
  begin
    // It's a payment request, so get the default values
    UDF5  := self.OrderPaymentTransInfo.optTransaction.DocUser5;
    UDF6  := self.OrderPaymentTransInfo.optTransaction.DocUser6;
    UDF7  := self.OrderPaymentTransInfo.optTransaction.DocUser7;
    UDF8  := self.OrderPaymentTransInfo.optTransaction.DocUser8;
    UDF9  := self.OrderPaymentTransInfo.optTransaction.DocUser9;
    UDF10 := self.OrderPaymentTransInfo.optTransaction.DocUser10;

    // ABSEXCH-15792. PKR. 03/12/2014. Set Payment Reference initially to the Payment Provider name.
    if CreditCardPaymentGateway.GetPaymentDefaultsEx(oGLCode,
                                                     oPaymentProvider,
                                                     oMerchantID,
                                                     oCostCentre,
                                                     oDepartment,
                                                     oPaymentProviderDesc,
                                                     UDF5, UDF6, UDF7, UDF8, UDF9, UDF10) then

    begin
      if (Length(oPaymentProviderDesc) > edtPaymentReference.MaxLength) then
      begin
        oPaymentProviderDesc := Copy(oPaymentProviderDesc, 1, edtPaymentReference.MaxLength);
      end;

      // Successful call, so load the values into the form
      // We only need GL Code, Cost Centre and Department
      if (oGLCode <> 0) then
      begin
        // PKR. 09/03/2015. ABSEXCH-16257. Description of GL Code not being displayed correctly.
        // By setting these fields on the edtPaymentGL field, we can take advantage of
        // the OnExit event to get the GL Code description.
        edtPaymentGL.OrigValue := '';
        edtPaymentGL.Text := IntToStr(oGLCode);
        edtPaymentGL.AltMod := true;
        edtPaymentGL.Modified := true; // Must be set AFTER setting the Text attribute.

        edtPaymentGLExit(edtPaymentGL);
      end;

      // ABSEXCH-16012. PKR. 09/01/2015. Don't overwrite existing values if the returned ones are blank.
      edtPaymentCostCentre.Enabled := edtPaymentCostCentre.Text = '';
      edtPaymentDepartment.Enabled := edtPaymentDepartment.Text = '';
      if (oCostCentre <> '') then
      begin
        edtPaymentCostCentre.Text := oCostCentre;
        edtPaymentCostCentre.Enabled := false; // Overridden, so disable editing
      end;
      if (oDepartment <> '') then
      begin
        edtPaymentDepartment.Text := oDepartment;
        edtPaymentDepartment.Enabled := false; // Overridden, so disable editing
      end;

      // ABSEXCH-15792. PKR. 03/12/2014. Set Payment Reference initially to the Payment Provider name.
      edtPaymentReference.Text  := oPaymentProviderDesc;

      // If those fields ore not blank (default exists) then disable them
      edtPaymentGL.Enabled := (edtPaymentGL.Text = '') or (edtPaymentGL.Text = '0');
    end
    else
    begin
      // ABSEXCH-15954. PKR. 02/01/2015. Enable fields if source not found.
      // Didn't find payment defaults so enable the various fields for edit
      edtPaymentGL.Enabled := true;
      edtPaymentCostCentre.Enabled := true;
      edtPaymentDepartment.Enabled := true;
    end;
  end
  // MH 18/02/2015 v7.1 ABSEXCH-16188: Re-enable GL/CC/Dept fields if switching from Credit Card to non-Credit Card operation
  Else
  Begin
    edtPaymentGL.Enabled := true;
    edtPaymentCostCentre.Enabled := true;
    edtPaymentDepartment.Enabled := true;
    edtPaymentReference.Text := '';
  End; // Else

  // MH 18/02/2015 v7.1 ABSEXCH-16151: Update the Contact name fields
  DoCheckyChecky2(Sender);
end;

//=========================================================================

procedure TfrmOrderPayment.FormShow(Sender: TObject);
begin
  if lstCreditCardPayment.Enabled then
  begin
    // Force the call to GetDefaults, otherwise it will never happen unless the user selects a different Payment option.
    lstCreditCardPaymentChange(nil);
  end;
end;

end.
