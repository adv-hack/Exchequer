unit THDetF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Enterprise01_TLB, ExtCtrls, ComCtrls, ListF, Mask, Buttons;

type
  TfrmTHDetail = class(TForm)
    PageControl1: TPageControl;
    tabMain: TTabSheet;
    panButtonIndent: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    memAcDetails: TMemo;
    Label4: TLabel;
    Label6: TLabel;
    edtAcCode: TEdit;
    Label1: TLabel;
    lvLines: TListView;
    Label2: TLabel;
    Label3: TLabel;
    edtPeriodYear: TEdit;
    edtYourRef: TEdit;
    Label5: TLabel;
    edtAltRef: TEdit;
    tabFooter: TTabSheet;
    GroupBox1: TGroupBox;
    chkManualVAT: TCheckBox;
    Label7: TLabel;
    edtVATCtrlGL: TEdit;
    GroupBox2: TGroupBox;
    lblLineType1: TLabel;
    edtLineType1: TEdit;
    lblLineType2: TLabel;
    edtLineType2: TEdit;
    lblLineType3: TLabel;
    edtLineType3: TEdit;
    lblLineType4: TLabel;
    edtLineType4: TEdit;
    GroupBox3: TGroupBox;
    chkSettleDiscTaken: TCheckBox;
    Label8: TLabel;
    edtSettleDiscPerc: TEdit;
    Label9: TLabel;
    edtSettleDiscDays: TEdit;
    Label10: TLabel;
    edtNotTakenTotal: TEdit;
    Label11: TLabel;
    edtNotTakenDisc: TEdit;
    Label12: TLabel;
    edtNotTakenVAT: TEdit;
    Label13: TLabel;
    edtNotTakenNet: TEdit;
    Panel1: TPanel;
    Label14: TLabel;
    edtTakenTotal: TEdit;
    Label15: TLabel;
    edtTakenDisc: TEdit;
    Label16: TLabel;
    edtTakenVAT: TEdit;
    Label17: TLabel;
    edtTakenNet: TEdit;
    Panel2: TPanel;
    Label18: TLabel;
    edtTHTotal: TEdit;
    edtTotalVAT: TEdit;
    Label19: TLabel;
    edtNetTotal: TEdit;
    Label20: TLabel;
    lvVATSplit: TListView;
    Panel3: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnView: TButton;
    edtTransDate: TMaskEdit;
    edtDueDate: TMaskEdit;
    tabDelivery: TTabSheet;
    GroupBox4: TGroupBox;
    edtDelAddr1: TEdit;
    edtDelAddr2: TEdit;
    edtDelAddr3: TEdit;
    edtDelAddr4: TEdit;
    edtDelAddr5: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lvLinesDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure edtAcCodeExit(Sender: TObject);
  private
    { Private declarations }
    FTHDetail    : ITransaction;
    FMode        : TDialogMode;
    FNeedRefresh : Boolean;
  protected
    procedure DisplayLine (DlgMode : TDialogMode);
    procedure LoadLines;
    procedure SetDelAddr;
    procedure SetAccountDetails;
    Procedure SetMode (Value : TDialogMode);
    Procedure SetTHDetail (Value : ITransaction);
    Procedure UpdateTHObject;
  public
    { Public declarations }
    Property THDetail : ITransaction Read FTHDetail Write SetTHDetail;
    Property Mode : TDialogMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;

implementation

{$R *.DFM}

Uses TLDetF, SelCust;

{----------------------------------------}

procedure TfrmTHDetail.FormCreate(Sender: TObject);
begin
  // Initialise local variables
  FTHDetail   := Nil;
  fMode        := mdAdd;
  FNeedRefresh := False;
end;

{----------------------------------------}

procedure TfrmTHDetail.FormDestroy(Sender: TObject);
begin
  // Explicitly release reference to interface
  FTHDetail := Nil;
end;

{----------------------------------------}

Procedure TfrmTHDetail.SetMode (Value : TDialogMode);
Begin { SetMode }
  FMode := Value;

  // Enable/Disable fields according to dialog purpose
  btnSave.Enabled := (FMode In [mdAdd, mdEdit]);
  btnCancel.Enabled := True;

  edtAcCode.ReadOnly := (FMode <> mdAdd);
  edtTransDate.ReadOnly := Not (FMode In [mdAdd, mdEdit]);
  edtDueDate.ReadOnly := edtTransDate.ReadOnly;
  edtPeriodYear.ReadOnly := edtTransDate.ReadOnly;
  edtYourRef.ReadOnly := edtTransDate.ReadOnly;
  edtAltRef.ReadOnly := edtTransDate.ReadOnly;

  chkManualVAT.Enabled := Not edtTransDate.ReadOnly;
  edtVATCtrlGL.ReadOnly := edtTransDate.ReadOnly;
  edtSettleDiscPerc.ReadOnly := edtTransDate.ReadOnly;
  edtSettleDiscDays.ReadOnly := edtTransDate.ReadOnly;
  chkSettleDiscTaken.Enabled := Not edtTransDate.ReadOnly;

  edtDelAddr1.ReadOnly := edtTransDate.ReadOnly;
  edtDelAddr2.ReadOnly := edtTransDate.ReadOnly;
  edtDelAddr3.ReadOnly := edtTransDate.ReadOnly;
  edtDelAddr4.ReadOnly := edtTransDate.ReadOnly;
  edtDelAddr5.ReadOnly := edtTransDate.ReadOnly;

  btnAdd.Enabled := (FMode In [mdAdd, mdEdit]);
  btnEdit.Enabled := btnAdd.Enabled;
  btnDelete.Enabled := btnAdd.Enabled;
End; { SetMode }

{----------------------------------------}

// Enable/Disable fields according to dialog purpose
Procedure TfrmTHDetail.SetTHDetail (Value : ITransaction);
Const
  VATCodeList : Array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
Var
  thAccountI : IAccount;
  RNum       : Double;
  I          : Integer;
Begin { SetTHDetail }
  If (FTHDetail <> Value) Then Begin
    FTHDetail := Value;

    With FTHDetail, oToolkit, Functions, SystemSetup Do Begin
      // Set window title
      If (FMode = mdAdd) Then
        Caption := 'Add New Transaction'
      Else
        Caption := 'Transaction Record - ' + Trim(thOurRef);

      // Always start on 'Main' tab
      PageControl1.ActivePage := tabMain;

      // Main Tab - Display Fields
      edtAcCode.Text := thAcCode;
      SetAccountDetails;
      edtTransDate.Text := EntFormatDate(thTransDate, 'DDMMYYYY');
      edtDueDate.Text := EntFormatDate(thDueDate, 'DDMMYYYY');

      edtPeriodYear.Text := entFormatPeriodYear(thPeriod, thYear);
      edtYourRef.Text := thYourRef;
      edtAltRef.Text := thLongYourRef;

      // Footer Tab - Display Fields
      // VAT Totals by Rate
      chkManualVAT.Checked := thManualVAT;
      edtVATCtrlGL.Text := IntToStr(thControlGL);
      For I := Low(VatCodeList) To High(VATCodeList) Do
        With lvVATSplit.Items.Add Do Begin
          Caption := ssVATRates[VatCodeList[I]].svDesc;
          SubItems.Add (Format('%0.2n', [thGoodsAnalysis[VatCodeList[I]]]));
          SubItems.Add (Format('%0.2n', [thVATAnalysis[VatCodeList[I]]]));
        End; { With lvVATSplit.SubItems.Add }

      // Line Type Totals - Set Caption and hide as necessary
      With ssUserFields Do Begin
        // setup user field text labels
        lblLineType1.Visible := ufLineType1Enabled;
        If lblLineType1.Visible Then lblLineType1.Caption := ufLineType1;
        lblLineType2.Visible := ufLineType2Enabled;
        If lblLineType2.Visible Then lblLineType2.Caption := ufLineType2;
        lblLineType3.Visible := ufLineType3Enabled;
        If lblLineType3.Visible Then lblLineType3.Caption := ufLineType3;
        lblLineType4.Visible := ufLineType4Enabled;
        If lblLineType4.Visible Then lblLineType4.Caption := ufLineType4;
      End; { With ssUserFields }

      // Line Type Split
      edtLineType1.Visible := lblLineType1.Visible;
      If edtLineType1.Visible Then edtLineType1.Text := Format('%0.2n', [thLineTypeAnalysis[1]]);
      edtLineType2.Visible := lblLineType2.Visible;
      If edtLineType2.Visible Then edtLineType2.Text := Format('%0.2n', [thLineTypeAnalysis[2]]);
      edtLineType3.Visible := lblLineType3.Visible;
      If edtLineType3.Visible Then edtLineType3.Text := Format('%0.2n', [thLineTypeAnalysis[3]]);
      edtLineType4.Visible := lblLineType4.Visible;
      If edtLineType4.Visible Then edtLineType4.Text := Format('%0.2n', [thLineTypeAnalysis[4]]);

      // Settlement Discount
      edtSettleDiscPerc.Text := Format('%0.2f', [thSettleDiscPerc * 100]);
      edtSettleDiscDays.Text := Format('%d', [thSettleDiscDays]);
      chkSettleDiscTaken.Checked := thSettleDiscTaken;

      edtNotTakenNet.Text := Format('%0.2n', [thNetValue]);
      edtNotTakenVAT.Text := Format('%0.2n', [thTotalVAT]);
      edtNotTakenDisc.Text := Format('%0.2n', [thTotalLineDiscount]);
      edtNotTakenTotal.Text := Format('%0.2n', [thNetValue + thTotalVAT - thTotalLineDiscount]);

      edtTakenNet.Text := edtNotTakenNet.Text;
      edtTakenVAT.Text := edtNotTakenVAT.Text;
      edtTakenDisc.Text := Format('%0.2n', [thTotalLineDiscount + thSettleDiscAmount]);
      edtTakenTotal.Text := Format('%0.2n', [thNetValue + thTotalVAT - thTotalLineDiscount - thSettleDiscAmount]);

      // Load ListView with Transaction Lines
      LoadLines;

      // Transaction Totals
      RNum := thNetValue - thTotalLineDiscount;
      If thSettleDiscTaken Then RNum := RNum - thSettleDiscAmount;
      edtNetTotal.Text := Format('%0.2n', [RNum]);
      edtTotalVAT.Text := Format('%0.2n', [thTotalVAT]);
      edtTHTotal.Text := Format('%0.2n', [RNum + thTotalVAT]);

      // Delivery Address
      SetDelAddr;
    End; { With FTHDetail }
  End; { If (FTHDetail <> Value) }
End; { SetTHDetail }

{----------------------------------------}

// Load listview with the transaction's lines
procedure TfrmTHDetail.LoadLines;
Var
  I : Integer;
Begin { LoadLines }
  With FTHDetail, oToolkit, thLines, Functions, SystemSetup Do Begin
    // Clear out any pre-existing lines
    lvLines.Items.Clear;

    // check we got some Transaction Lines to load
    If (thLineCount > 0) Then
      // run through list - list is 1 based
      For I := 1 To thLineCount Do
        With thLines[I], lvLines.Items.Add Do Begin
          Caption := tlStockCode;
          If (tlQty <> 0.0) Then
            SubItems.Add(Format('%0.' + IntToStr(ssQtyDecimals) + 'f', [tlQty]))
          Else
            SubItems.Add('');
          SubItems.Add(tlDescr + ' (' + IntToStr(tlLineNo) + ')');
          If (tlQty <> 0.0) Then
            SubItems.Add(Format('%0.2n', [entLineTotal(True, 0)]))
          Else
            SubItems.Add('');
          SubItems.Add(tlVATCode + tlInclusiveVATCode);
          If (tlQty <> 0.0) Then
            SubItems.Add(Format('%0.' + IntToStr(ssCostDecimals) + 'n', [tlNetValue]));
          If (tlDiscount <> 0.0) Then Begin
            If (tlDiscFlag = '%') Then
              // Percentage
              SubItems.Add(Format('%0.2f%s', [tlDiscount * 100, tlDiscFlag]))
            Else
              // Fixed Amount
              SubItems.Add(Format('%0.2f%s', [tlDiscount, tlDiscFlag]))
          End { If (tlDiscount <> 0.0) }
          Else
            // Sales Band
            SubItems.Add(tlDiscFlag);
        End; { With thLines[I] }
  End; { With FTHDetail, oToolkit, Transaction, thLines, Functions, SystemSetup }
End; { LoadLines }

{----------------------------------------}

Procedure TfrmTHDetail.UpdateTHObject;
Begin { UpdateTHObject }
  If (FMode In [mdAdd, mdEdit]) Then Begin
    // Add or Edit
    With FTHDetail, oToolkit.Functions Do Begin
      // Copy detail back into Transaction structure

      // Main Tab - Display Fields
      edtAcCodeExit(Self);    // Account Code
      thTransDate := Copy (edtTransDate.Text, 5,4) + Copy (edtTransDate.Text, 3,2) + Copy (edtTransDate.Text, 1,2);
      thDueDate := Copy (edtDueDate.Text, 5,4) + Copy (edtDueDate.Text, 3,2) + Copy (edtDueDate.Text, 1,2);
      //edtPeriodYear.Text := IntToStr(thPeriod) + '/' + IntToStr(thYear);
      thYourRef := edtYourRef.Text;
      thLongYourRef := edtAltRef.Text;

      // Footer Tab
      thManualVAT := chkManualVAT.Checked;
      thControlGL := StrToInt(edtVATCtrlGL.Text);
      thSettleDiscPerc := entRound(StrToFloat(edtSettleDiscPerc.Text) / 100, 2);
      thSettleDiscDays := StrToInt(edtSettleDiscDays.Text);
      thSettleDiscTaken := chkSettleDiscTaken.Checked;

      // Delivery Tab
      thDelAddress[1] := edtDelAddr1.Text;
      thDelAddress[2] := edtDelAddr2.Text;
      thDelAddress[3] := edtDelAddr3.Text;
      thDelAddress[4] := edtDelAddr4.Text;
      thDelAddress[5] := edtDelAddr5.Text;
    End; { With }
  End; { If (FMode In [mdAdd, mdEdit]) }
End; { UpdateTHObject }

{----------------------------------------}

procedure TfrmTHDetail.btnSaveClick(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  If (FMode In [mdAdd, mdEdit]) Then Begin
    // Ensure all OnExit events are executed
    btnSave.SetFocus;

    // Add or Edit
    UpdateTHObject;

    // Save changes to Transaction
    FuncRes := FTHDetail.Save(True);     // Update Totals automatically
    If (FuncRes = 0) Then Begin
      // Close dialog
      FNeedRefresh := True;
      Close;
    End { If (FuncRes = 0) }
    Else
      MessageDlg ('The following error occured in line ' + IntToStr(FTHDetail.SaveErrorLine) + ' saving the Transaction:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
  End { If }
  Else Begin
    // View
    FNeedRefresh := False;
    Close;
  End; { Else }
end;

{----------------------------------------}

procedure TfrmTHDetail.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    mdAdd  : ; { No Action Required }
    mdEdit : FTHDetail.Cancel;
    mdView : ; { No Action Required }
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

{----------------------------------------}

// Displays Transaction Line window in different modes (mdAdd, mdEdit, mdView)
procedure TfrmTHDetail.DisplayLine (DlgMode : TDialogMode);
var
  FuncRes     : LongInt;
begin
  With lvLines Do
    // Check 1 item is selected for editing
    If (DlgMode = mdAdd) Or (SelCount = 1) Then Begin
      // AOK - setup edit dialog
      With TfrmLineDetail.Create(Self) Do
        Try
          // Position form nicely
          Left := Self.Left + 35;
          Top := Self.Top + 35;

          // Set dialog mode
          Mode := DlgMode;

          TH := FTHDetail;
          If (DlgMode = mdAdd) Then
            // Get new transaction line instance for Adding
            TLDetail := FTHDetail.thLines.Add
          Else
            // Pass the current selected line into Dialog
            TLDetail := FTHDetail.thLines[Selected.Index + 1];

          // Display 'View Transaction Line' dialog
          ShowModal;

          If NeedRefresh Then
            // Reload Transaction Lines
            LoadLines;
        Finally
          Free;
        End;
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmTHDetail.btnAddClick(Sender: TObject);
begin
  // ensure header object is up-to-date before adding a new line
  UpdateTHObject;

  // display add line dialog
  DisplayLine (mdAdd)
end;

{----------------------------------------}

procedure TfrmTHDetail.btnEditClick(Sender: TObject);
begin
  // ensure header object is up-to-date before editing line
  UpdateTHObject;

  // display edit line dialog
  DisplayLine (mdEdit)
end;

{----------------------------------------}

procedure TfrmTHDetail.btnDeleteClick(Sender: TObject);
begin
  // Check 1 item is selected for editing
  If (lvLines.SelCount = 1) Then
    If (MessageDlg ('Are you sure you want to Delete the currently selected transaction line?',
                    mtConfirmation, [MbYes, mbNo], 0) = mrYes) Then Begin
      // Delete Selected Line from Transaction in COM Object (NOTE: Only takes
      // effect when transaction saved).
      FTHDetail.thLines.Delete(lvLines.Selected.Index + 1); // Delete method on lines object

      // Also remove from ListView
      lvLines.Selected.Delete;
    End; { If }
end;

{----------------------------------------}

procedure TfrmTHDetail.btnViewClick(Sender: TObject);
begin
  DisplayLine (mdView)
end;

{----------------------------------------}

procedure TfrmTHDetail.lvLinesDblClick(Sender: TObject);
begin
  If (FMode = mdView) Then btnViewClick(Sender) Else btnEditClick(Sender);
end;

{----------------------------------------}

procedure TfrmTHDetail.SetAccountDetails;
Var
  thAccountI : IAccount;
begin
  // Get an Account Details interface for the transaction and check it is valid
  // NOTE: Must store locally as interface is generated each time it is referenced
  thAccountI := FTHDetail.thAcCodeI;
  If Assigned(thAccountI) Then Begin
    With thAccountI Do Begin
      memAcDetails.Clear;
      memAcDetails.Lines.Add(Trim(AcCompany));
      memAcDetails.Lines.Add(Trim(AcAddress[1]));
      memAcDetails.Lines.Add(Trim(AcAddress[2]));
      memAcDetails.Lines.Add(Trim(AcAddress[3]));
      memAcDetails.Lines.Add(Trim(AcAddress[4]));
      memAcDetails.Lines.Add(Trim(AcAddress[5]));
    End; { With thAccountI }

    // Destroy reference and the object
    thAccountI := Nil;
  End; { If Assigned(thAccountI) }
end;

{----------------------------------------}

procedure TfrmTHDetail.SetDelAddr;
begin
  With FTHDetail Do Begin
    edtDelAddr1.Text := thDelAddress[1];
    edtDelAddr2.Text := thDelAddress[2];
    edtDelAddr3.Text := thDelAddress[3];
    edtDelAddr4.Text := thDelAddress[4];
    edtDelAddr5.Text := thDelAddress[5];
  End; { With FTHDetail }
end;

{----------------------------------------}

procedure TfrmTHDetail.edtAcCodeExit(Sender: TObject);
Var
  oCust  : IAccount;
  AcKey  : ShortString;
begin
  If (Not edtAcCode.ReadOnly) Then Begin
    // Aun up the validation/selection dialog - blank codes not allowed
    AcKey := Trim(edtAcCode.Text);
    oCust := SelectAccount (oToolkit.Customer, AcKey);

    If Assigned(oCust) Then Begin
      // Got a Customer inteface - check for changes
      If (oCust.acCode <> FTHDetail.thAcCode) Then
        With oCust, FTHDetail Do Begin
          // AOK - bring in customer details
          thAcCode := oCust.acCode;
          edtAcCode.Text := thAcCode;

          // Set name & address fields
          SetAccountDetails;

          // Delivery Address
          thDelAddress.AssignAddress(acDelAddress);
          SetDelAddr;

        End; { With oCust }
    End { If (AcKey <> '') }
    Else Begin
      // Invalid Customer Code
      ShowMessage ('A Customer must be selected from the list');
      If edtAcCode.CanFocus Then edtAcCode.SetFocus;
    End; { Else }
  End; { If edtAcCode.Enabled }
end;

end.

