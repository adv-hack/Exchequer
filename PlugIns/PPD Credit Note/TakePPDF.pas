unit TakePPDF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StrUtils, CustABSU, Enterprise04_TLB, StdCtrls, TEditVal, Mask,
  Math, ExtCtrls, EnterpriseBeta_TLB;

Type
  TfrmTakePPDMode = (moCustomer, moSupplier);

  //------------------------------

  TfrmTakePPD = class(TForm)
    btnCreateSJC: TButton;
    btnCancel: TButton;
    lblTransDate: Label8;
    edxJCTransDate: TEditDate;
    Label5: TLabel;
    ccyDiscountPercentage: TCurrencyEdit;
    Label2: TLabel;
    lblAcCode: Label8;
    Label3: TLabel;
    lblDefaultPPDPercentage: TLabel;
    Label6: TLabel;
    lblDefaultPPDDays: TLabel;
    Bevel3: TBevel;
    Label8: TLabel;
    Label9: TLabel;
    lblDefaultExpiry: TLabel;
    lblInvoiceOurRef: Label8;
    lblInvoiceTransDate: TLabel;
    Bevel1: TBevel;
    Label1: TLabel;
    lblPPDValue: Label8;
    Label12: TLabel;
    lblInvoiceRemaining: Label8;
    Label13: TLabel;
    lblAcCompany: Label8;
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateSJCClick(Sender: TObject);
    procedure ccyDiscountPercentageKeyPress(Sender: TObject;
      var Key: Char);
    procedure ccyDiscountPercentageExit(Sender: TObject);
  private
    { Private declarations }
    FMode : TfrmTakePPDMode;
    FToolkit : IToolkit;
    FPPDTotal : Double;
    FPPDRate : Double;
    FTransactionDate : String;
    procedure UpdateInvoiceTotals;
  public
    { Public declarations }
    Property PPDRate : Double Read FPPDRate;
    Property PPDTotal : Double Read FPPDTotal;
    Property TransactionDate : String Read FTransactionDate;

    Procedure SetDetails (Const Mode : TfrmTakePPDMode; Const oToolkit : IToolkit);
  end;

Procedure DisplayPPDDialog (Const Mode : TfrmTakePPDMode; Const EventData : TAbsEnterpriseSystem);

implementation

{$R *.dfm}

Uses HandlerU, oIni, CtkUtil04, ETDateU, ETMiscU, CreateCreditNote;

//=========================================================================

Procedure DisplayPPDDialog (Const Mode : TfrmTakePPDMode; Const EventData : TAbsEnterpriseSystem);
var
  frmTakePPD: TfrmTakePPD;
  oPPDSettings : TPPDSettingIni;
  oToolkit : IToolkit;
  DisplayDialog : Boolean;
  Res : Integer;

  //------------------------------

  Procedure MsgBox (Const Message : ANSIString);
  Begin // MsgBox
    Application.MessageBox(PCHAR(Message), sPlugInTitle);
  End; // MsgBox

  //------------------------------

  // Returns TRUE if the transaction does not have the "PPD Taken" flag set in the nominated User Defined Field
  Function CheckForTakenFlag (Const UDefFieldNo : Integer) : Boolean;
  Var
    sSearchText : String;
  Begin // CheckForTakenFlag
    With TAbsInvoice8(EventData.Transaction) Do
    Begin
      Case UDefFieldNo Of
        -1 : sSearchText := '';  // Disabled - always continue
        1  : sSearchText := thUser1;
        2  : sSearchText := thUser2;
        3  : sSearchText := thUser3;
        4  : sSearchText := thUser4;
        5  : sSearchText := thUser5;
        6  : sSearchText := thUser6;
        7  : sSearchText := thUser7;
        8  : sSearchText := thUser8;
        9  : sSearchText := thUser9;
        10 : sSearchText := thUser10;
      Else
        Result := True;
      End; // Case UDefFieldNo

      Result := (Pos('PPD TAKEN', UpperCase(Trim(sSearchText))) = 0) And (Pos('PPD GIVEN', UpperCase(Trim(sSearchText))) = 0);
    End; // With TAbsInvoice8(EventData.Transaction)
  End; // CheckForTakenFlag

  //------------------------------

Begin // DisplayPPDDialog
  // 1) .Ini file must be setup
  oPPDSettings := TPPDSettingIni.Create(TAbsSetup7(EventData.Setup).ssCompanyCode);
  DisplayDialog := oPPDSettings.Valid;
  If DisplayDialog Then
  Begin
    // Perform checks on transaction eligibility
    // 2) Must be SIN or PIN
    DisplayDialog := ((Mode = moCustomer) And (EventData.Transaction.thInvDocHed = CUSIN)) Or
                     ((Mode = moSupplier) And (EventData.Transaction.thInvDocHed = CUPIN));
    If DisplayDialog Then
    Begin
      // 3) Transaction Date must be on or after 01/04/2015
      DisplayDialog := (EventData.Transaction.thTransDate >= '20150401');
      If DisplayDialog Then
      Begin
        // 4) Check for PPD Taken flag in User Defined Field
        DisplayDialog := CheckForTakenFlag(oPPDSettings.UserDefinedFieldNo);
        If DisplayDialog Then
        Begin
          // 5) Transaction must be fully outstanding
          DisplayDialog := (EventData.Transaction.thSettled = 0.0);
          If (Not DisplayDialog) Then
            MsgBox ('Prompt Payment Discount cannot be taken as the transaction is partially settled');
        End // If DisplayDialog
        Else
          MsgBox ('Prompt Payment Discount has already been ' + IfThen(Mode = moCustomer, 'given', 'taken') + ' for this transaction');
      End // If DisplayDialog
      Else
        MsgBox ('Prompt Payment Discount only applies to transactions from 01/04/2015');
    End // If DisplayDialog
    Else
      MsgBox ('Prompt Payment Discount cannot be ' + IfThen(Mode = moCustomer, 'given', 'taken') + ' for this transaction type');
  End // If DisplayDialog
  Else
    MsgBox ('The ' + sPlugInTitle + ' is not correctly configured for this company');

  //------------------------------

  If DisplayDialog Then
  Begin
    // Create COM Toolkit .EXE instance for transaction operations
    oToolkit := CreateToolkitWithBackdoor;
    Try
      With oToolkit.Configuration Do
      Begin
        DataDirectory := EventData.Setup.ssDataPath;
        OverwriteTransactionNumbers := True;
        AutoSetTransCurrencyRates := True;
        AutoSetPeriod := True;
        UpdateAccountBalances := True;
      End; // With oToolkit.Configuration

      // Set operator name for Originator on created transactions
      (oToolkit.Configuration As IBetaConfig).UserID := EventData.UserName;

      Res := oToolkit.OpenToolkit;
      If (Res = 0) Then
      Begin
        // Load the transaction/account in the COM Toolkit
        oToolkit.Transaction.Index := thIdxOurRef;
        Res := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(EventData.Transaction.thOurRef));

        If (Res = 0) Then
        Begin
          // Display the PPD window
          frmTakePPD := TfrmTakePPD.Create(Application.MainForm);
          Try
            frmTakePPD.SetDetails (Mode, oToolkit);
            If (frmTakePPD.ShowModal = mrOK) Then
            Begin
              AddCreditNote (oToolkit, oPPDSettings, frmTakePPD.PPDRate, frmTakePPD.PPDTotal, frmTakePPD.TransactionDate, EventData.UserName);
            End; // If (frmTakePPD.ShowModal = mrOK)
          Finally
            frmTakePPD.Free;
          End; // Try..Finally
        End // If (Res = 0)
        Else
          MsgBox ('Error ' + IntToStr(Res) + ' - ' + oToolkit.LastErrorString + ' - loading the Transaction');

        oToolkit.CloseToolkit;
      End // If (Res = 0)
      Else
        MsgBox ('Error ' + IntToStr(Res) + ' - ' + oToolkit.LastErrorString + ' - opening the COM Toolkit');
    Finally
      oToolkit := NIL;
    End; // Try..Finally
  End; // If DisplayDialog

  FreeAndNIL(oPPDSettings);
End; // DisplayPPDDialog

//=========================================================================

procedure TfrmTakePPD.FormDestroy(Sender: TObject);
begin
  // shutdown toolkits
  FToolkit := NIL;
end;

//-------------------------------------------------------------------------

Procedure TfrmTakePPD.SetDetails (Const Mode : TfrmTakePPDMode; Const oToolkit : IToolkit);
Var
  ExpiryDate : String;
  Res : Integer;
Begin // SetDetails
  FMode := Mode;
  FToolkit := oToolkit;

  FPPDTotal := 0.0;
  FPPDRate := 0.0;
  FTransactionDate := '';

  Caption := IfThen(Mode = moCustomer, 'Give', 'Take') + ' Prompt Payment Discount - ' + FToolkit.Transaction.thOurRef;
  lblTransDate.Caption := IfThen(Mode = moCustomer, 'SJC', 'PJC') + ' Transaction Date';
  btnCreateSJC.Caption := 'Create ' + IfThen(Mode = moCustomer, 'SJC', 'PJC');

  lblAcCode.Caption := FToolkit.Transaction.thAcCode;
  lblAcCompany.Caption := FToolkit.Transaction.thAcCodeI.acCompany;
  lblDefaultPPDPercentage.Caption := Format('%0.2f', [FToolkit.Transaction.thAcCodeI.acDefSettleDisc]) + '%';
  lblDefaultPPDDays.Caption := IntToStr(FToolkit.Transaction.thAcCodeI.acDefSettleDays);

  edxJCTransDate.DateValue := FormatDateTime('yyyymmdd', Now);
  ccyDiscountPercentage.Value := FToolkit.Transaction.thAcCodeI.acDefSettleDisc;

  lblInvoiceOurRef.Caption := FToolkit.Transaction.thOurRef;
  lblInvoiceTransDate.Caption := POutDate(FToolkit.Transaction.thTransDate);
  UpdateInvoiceTotals;

  If (FToolkit.Transaction.thAcCodeI.acDefSettleDays > 0) Then
  Begin
    ExpiryDate := CalcDueDate(FToolkit.Transaction.thTransDate, FToolkit.Transaction.thAcCodeI.acDefSettleDays);
    lblDefaultExpiry.Caption := '(Default PPD Expiry: ' + POutDate(ExpiryDate) + ')';
    If (ExpiryDate < Today) Then
      lblDefaultExpiry.Font.Color := clRed;
  End // If (FToolkit.Transaction.thAcCodeI.acDefSettleDays > 0)
  Else
    lblDefaultExpiry.Caption := '';
End; // SetDetails

//-------------------------------------------------------------------------

procedure TfrmTakePPD.UpdateInvoiceTotals;
Begin // UpdateInvoiceTotals
  FPPDRate := ccyDiscountPercentage.Value;

  If (FPPDRate > 0.0) Then
    FPPDTotal := Round_Up(FToolkit.Transaction.thTotals[TransTotInCcy] * Round_Up(FPPDRate / 100, 4), 2)
  Else
    FPPDTotal := 0.0;

  lblPPDValue.Caption := Format('%0.2f', [FPPDTotal]);
  lblInvoiceRemaining.Caption := Format('%0.2f', [Round_Up(FToolkit.Transaction.thTotals[TransTotInCcy] - FPPDTotal, 2)]);
End; // UpdateInvoiceTotals

//-------------------------------------------------------------------------

procedure TfrmTakePPD.btnCreateSJCClick(Sender: TObject);
begin
  // Move focus to Create button to ensure all OnExit events have kicked off
  btnCreateSJC.SetFocus;
  If (ActiveControl = btnCreateSJC) Then
  Begin
    UpdateInvoiceTotals;

    If (FPPDTotal > 0.0) Then
    Begin
      FTransactionDate := edxJCTransDate.DateValue;
      ModalResult := mrOK
    End // If (FPPDTotal > 0.0)
    Else
    Begin
      Application.MessageBox('PPD Value must be greater than zero', sPlugInTitle);
      If ccyDiscountPercentage.CanFocus Then
        ccyDiscountPercentage.SetFocus;
    End; // Else
  End; // If (ActiveControl = btnCreateSJC)
end;

//-------------------------------------------------------------------------

procedure TfrmTakePPD.ccyDiscountPercentageKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '-') then
    Key := #0;
end;

//------------------------------

procedure TfrmTakePPD.ccyDiscountPercentageExit(Sender: TObject);
begin
  If (ccyDiscountPercentage.Value > 100.00) Then
    ccyDiscountPercentage.Value := 100.00;
  UpdateInvoiceTotals;
end;

//-------------------------------------------------------------------------

end.
