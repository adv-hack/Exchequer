unit CustDetF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Enterprise01_TLB, ExtCtrls, ComCtrls, ListF;

type
  TfrmCustDetail = class(TForm)
    PageControl1: TPageControl;
    tabMain: TTabSheet;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtAcCode: TEdit;
    edtAcAltRef: TEdit;
    edtAcCompany: TEdit;
    panButtonIndent: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    tabLedger: TTabSheet;
    lvTrans: TListView;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    edtAcContact: TEdit;
    Label3: TLabel;
    edtAddr1: TEdit;
    edtAddr2: TEdit;
    edtAddr3: TEdit;
    edtAddr4: TEdit;
    edtAddr5: TEdit;
    edtPostCode: TEdit;
    Label7: TLabel;
    GroupBox4: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    edtEmailAddr: TEdit;
    edtPhone: TEdit;
    edtFax: TEdit;
    edtMobile: TEdit;
    Label1: TLabel;
    edtAcBalance: TEdit;
    Bevel1: TBevel;
    tabDefaults: TTabSheet;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtAcCode2: TEdit;
    edtAcAltRef2: TEdit;
    edtAcCompany2: TEdit;
    GroupBox5: TGroupBox;
    Label14: TLabel;
    edtDelAddr1: TEdit;
    edtDelAddr2: TEdit;
    edtDelAddr3: TEdit;
    edtDelAddr4: TEdit;
    edtDelAddr5: TEdit;
    GroupBox6: TGroupBox;
    Label13: TLabel;
    edtUser1: TEdit;
    edtUser2: TEdit;
    edtUser3: TEdit;
    edtUser4: TEdit;
    Panel1: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnView: TButton;
    btnViewNotes: TButton;
    tabBalances: TTabSheet;
    GroupBox7: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    edtAcCode3: TEdit;
    edtAcAltRef3: TEdit;
    edtAcCompany3: TEdit;
    GroupBox8: TGroupBox;
    Bevel2: TBevel;
    Label18: TLabel;
    edtThisPr: TEdit;
    edtThisYTD: TEdit;
    Label19: TLabel;
    edtLastYTD: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    edtCrLimit: TEdit;
    edtCommitted: TEdit;
    Label22: TLabel;
    edtCrAvail: TEdit;
    Label23: TLabel;
    btnMatching: TButton;
    procedure FormCreate(Sender: TObject);
    procedure edtAcCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnViewNotesClick(Sender: TObject);
    procedure btnMatchingClick(Sender: TObject);
  private
    { Private declarations }
    FAccDetail   : IAccount;
    FMode        : TDialogMode;
    FNeedRefresh : Boolean;
  protected
    procedure ShowTransDlg(DlgMode : TDialogMode);
    Procedure SetAccDetail (Value : IAccount);
    Procedure SetMode (Value : TDialogMode);
    procedure SetupItem (lvItem : TListItem; TH : ITransaction);
  public
    { Public declarations }
    Property AccDetail : IAccount Read FAccDetail Write SetAccDetail;
    Property Mode : TDialogMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;

implementation

{$R *.DFM}

Uses THDetF, NoteLstF, THMatchF;

procedure TfrmCustDetail.FormCreate(Sender: TObject);
begin
  // Initialise local variables
  FAccDetail   := Nil;
  fMode        := mdAdd;
  FNeedRefresh := False;
end;

{----------------------------------------}

procedure TfrmCustDetail.FormDestroy(Sender: TObject);
begin
  // Explicitly release reference to interface
  FAccDetail := Nil;
end;

{----------------------------------------}

Procedure TfrmCustDetail.SetMode (Value : TDialogMode);
Begin { SetMode }
  FMode := Value;

  // Enable/Disable fields according to dialog purpose
  edtAcCode.ReadOnly    := (FMode <> mdAdd);
  edtAcAltRef.ReadOnly  := Not (FMode In [mdAdd, mdEdit]);
  edtAcCompany.ReadOnly := Not (FMode In [mdAdd, mdEdit]);

  edtAcContact.ReadOnly := edtAcCompany.ReadOnly;
  edtAddr1.ReadOnly := edtAcCompany.ReadOnly;
  edtAddr2.ReadOnly := edtAcCompany.ReadOnly;
  edtAddr3.ReadOnly := edtAcCompany.ReadOnly;
  edtAddr4.ReadOnly := edtAcCompany.ReadOnly;
  edtAddr5.ReadOnly := edtAcCompany.ReadOnly;
  edtPostCode.ReadOnly := edtAcCompany.ReadOnly;

  edtEmailAddr.ReadOnly := edtAcCompany.ReadOnly;
  edtPhone.ReadOnly := edtAcCompany.ReadOnly;
  edtFax.ReadOnly := edtAcCompany.ReadOnly;
  edtMobile.ReadOnly := edtAcCompany.ReadOnly;

  edtDelAddr1.ReadOnly := edtAcCompany.ReadOnly;
  edtDelAddr2.ReadOnly := edtAcCompany.ReadOnly;
  edtDelAddr3.ReadOnly := edtAcCompany.ReadOnly;
  edtDelAddr4.ReadOnly := edtAcCompany.ReadOnly;
  edtDelAddr5.ReadOnly := edtAcCompany.ReadOnly;

  edtUser1.ReadOnly := edtAcCompany.ReadOnly;
  edtUser2.ReadOnly := edtAcCompany.ReadOnly;
  edtUser3.ReadOnly := edtAcCompany.ReadOnly;
  edtUser4.ReadOnly := edtAcCompany.ReadOnly;

  // Enable/Disable buttons as required
  btnSave.Enabled := (FMode In [mdAdd, mdEdit]);
  If btnSave.Enabled Then btnCancel.Caption := '&Cancel' Else btnCancel.Caption := '&Close';

  // Hide Ledger if adding a new customer
  tabLedger.TabVisible := (FMode In [mdEdit, mdView]);
  // Disable Add/Edit Transaction Buttons if not viewing the account
  btnAdd.Enabled := (FMode = mdView);
  btnEdit.Enabled := btnAdd.Enabled;
End; { SetMode }

{----------------------------------------}

Procedure TfrmCustDetail.SetAccDetail (Value : IAccount);
Var
  TmpBal : Double;
  I      : Smallint;
Begin { SetAccDetail }
  If (FAccDetail <> Value) Then Begin
    FAccDetail := Value;

    With oToolkit, FAccDetail Do Begin
      // Set window title
      If (FMode = mdAdd) Then
        Caption := 'Add New Customer'
      Else
        Caption := 'Customer Record - ' + Trim(acCode) + ', ' + Trim(acCompany);

      // Always start on 'Main' tab
      PageControl1.ActivePage := tabMain;

      // Display Fields
      edtAcCode.Text := Trim(acCode);
      edtAcCode2.Text := edtAcCode.Text;
      edtAcCode3.Text := edtAcCode.Text;
      edtAcAltRef.Text := Trim(acAltCode);
      edtAcAltRef2.Text := edtAcAltRef.Text;
      edtAcAltRef3.Text := edtAcAltRef.Text;
      edtAcCompany.Text := Trim(acCompany);
      edtAcCompany2.Text := edtAcCompany.Text;
      edtAcCompany3.Text := edtAcCompany.Text;

      edtAcContact.Text := Trim(acContact);
      edtAddr1.Text := Trim(acAddress[1]);
      edtAddr2.Text := Trim(acAddress[2]);
      edtAddr3.Text := Trim(acAddress[3]);
      edtAddr4.Text := Trim(acAddress[4]);
      edtAddr5.Text := Trim(acAddress[5]);
      edtPostCode.Text := Trim(acPostCode);

      edtEmailAddr.Text := Trim(acEmailAddr);
      edtPhone.Text := Trim(acPhone);
      edtFax.Text := Trim(acFax);
      edtMobile.Text := Trim(acPhone2);

      edtDelAddr1.Text := Trim(acDelAddress[1]);
      edtDelAddr2.Text := Trim(acDelAddress[2]);
      edtDelAddr3.Text := Trim(acDelAddress[3]);
      edtDelAddr4.Text := Trim(acDelAddress[4]);
      edtDelAddr5.Text := Trim(acDelAddress[5]);

      edtUser1.Text := Trim(acUserDef1);
      edtUser2.Text := Trim(acUserDef2);
      edtUser3.Text := Trim(acUserDef3);
      edtUser4.Text := Trim(acUserDef4);

      If (FMode = mdAdd) Then Begin
        edtAcBalance.Text := 'N/A';
        edtThisPr.Text := 'N/A';
        edtThisYTD.Text := 'N/A';
        edtLastYTD.Text := 'N/A';
        edtCommitted.Text := 'N/A';
        edtCrAvail.Text := 'N/A';
      End { If (FMode = mdAdd) }
      Else Begin
        // Refresh SystemSetup details to ensure correct F6 Period/Year picked up
        SystemSetup.Refresh;

        // YTD Balance for Current F6 Period/Year
        acHistory.acPeriod := 100 + SystemSetup.ssCurrentPeriod;
        acHistory.acYear := 0;
        TmpBal := acHistory.acBalance;
        edtAcBalance.Text := Format ('%0.2n', [TmpBal]);

        // Committed Balance for Current F6 Period
        acHistory.acPeriod := 0;
        acHistory.acYear := 0;
        edtCommitted.Text := Format ('%0.2n', [acHistory.acCommitted]);

        // Credit Available - Credit Limit - Balance - Committed
        edtCrAvail.Text := Format ('%0.2n', [acCreditLimit - TmpBal - acHistory.acCommitted]);
        // Supp -> edtCrAvail.Text := Format ('%0.2n', [acCreditLimit + TmpBal + acHistory.acCommitted]);

        // Sales for current F6 period
        acHistory.acPeriod := 0;
        acHistory.acYear := 0;
        edtThisPr.Text := Format ('%0.2n', [acHistory.acSales]);
        // Supp -> edtThisPr.Text := Format ('%0.2n', [acHistory.acCosts]);

        // Total Sales for the F6 Year up to the F6 Period
        acHistory.acPeriod := 100 + SystemSetup.ssCurrentPeriod;
        acHistory.acYear := 0;
        edtThisYTD.Text := Format ('%0.2n', [acHistory.acSales]);
        // Supp -> edtThisYTD.Text := Format ('%0.2n', [acHistory.acCosts]);

        // Total Sales for the previous Year
        acHistory.acPeriod := -99;
        acHistory.acYear := -1;
        edtLastYTD.Text := Format ('%0.2n', [acHistory.acSales]);
        // Supp -> ??? edtLastYTD.Text := Format ('%0.2n', [acHistory.acCosts]);
      End; { Else }
      edtCrLimit.Text := Format ('%0.2f', [acCreditLimit]);
    End; { With FAccDetail }
  End; { If (FAccDetail <> Value) }
End; { SetAccDetail }

{----------------------------------------}

// Limit character entry into Account Code field
procedure TfrmCustDetail.edtAcCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Not (Key In [Ord('0')..Ord('9'), Ord('a')..Ord('z'), Ord('A')..Ord('Z')]) Then
    Key := 0;
end;

{----------------------------------------}

// Save button - store account details
procedure TfrmCustDetail.btnSaveClick(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  With FAccDetail Do Begin
    // Copy detail into AccDetail Interface
    acCode := Trim(edtAcCode.Text);
    acAltCode := Trim(edtAcAltRef.Text);
    acCompany := Trim(edtAcCompany.Text);

    acContact := Trim(edtAcContact.Text);
    acAddress[1] := Trim(edtAddr1.Text);
    acAddress[2] := Trim(edtAddr2.Text);
    acAddress[3] := Trim(edtAddr3.Text);
    acAddress[4] := Trim(edtAddr4.Text);
    acAddress[5] := Trim(edtAddr5.Text);
    acPostCode := Trim(edtPostCode.Text);

    acEmailAddr := Trim(edtEmailAddr.Text);
    acPhone := Trim(edtPhone.Text);
    acFax := Trim(edtFax.Text);
    acPhone2 := Trim(edtMobile.Text);

    acDelAddress[1] := Trim(edtDelAddr1.Text);
    acDelAddress[2] := Trim(edtDelAddr2.Text);
    acDelAddress[3] := Trim(edtDelAddr3.Text);
    acDelAddress[4] := Trim(edtDelAddr4.Text);
    acDelAddress[5] := Trim(edtDelAddr5.Text);

    acUserDef1 := Trim(edtUser1.Text);
    acUserDef2 := Trim(edtUser2.Text);
    acUserDef3 := Trim(edtUser3.Text);
    acUserDef4 := Trim(edtUser4.Text);

    acCreditLimit := StrToFloat(edtCrLimit.Text);

    // Save Account
    FuncRes := FAccDetail.Save;
    If (FuncRes = 0) Then Begin
      // Close dialog
      FNeedRefresh := True;
      Close;
    End { If (FuncRes = 0) }
    Else
      // Error saving account details
      MessageDlg ('The following error occured saving the Customer:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
  End; { With FAccDetail }
end;

{----------------------------------------}

// Cancel button - for updates free record lock
procedure TfrmCustDetail.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    mdAdd  : ; { No Action Required }
    mdEdit : FAccDetail.Cancel;
    mdView : ; { No Action Required }
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

{----------------------------------------}

// Sets up the caption and subitems of a listview line
procedure TfrmCustDetail.SetupItem (lvItem : TListItem; TH : ITransaction);
Begin { SetupItem }
  With lvItem, TH, oToolkit.Functions Do Begin
    Caption := thOurRef;
    SubItems.Clear;
    if entCanUpdate Then SubItems.Add ('*') Else SubItems.Add ('');
    SubItems.Add (entFormatDate (thTransDate, ''));  // Short-Date format
    SubItems.Add (Format('%0.2n', [thTotals[TransTotSignedInBase]]));

    SubItems.Add (thYourRef);
    SubItems.Add (thLongYourRef);
  End; { With lvItem }
End; { SetupItem }

{----------------------------------------}

procedure TfrmCustDetail.PageControl1Change(Sender: TObject);
Var
  FuncRes, Res   : LongInt;
  RNum           : Double;
begin
  If (PageControl1.ActivePage = tabLedger) Then Begin
    // Ledger - load transaction list if not already loaded
    If Assigned(oToolkit) and (lvTrans.Items.Count = 0) Then
      With lvTrans, oToolkit, Transaction Do Begin
        // Load list with Transactions for Customer
        Items.Clear;

        // Get First customer
        Index := thIdxAccount;
        FuncRes := GetGreaterThanOrEqual(BuildAccountIndex(FAccDetail.acCode));

        While (FuncRes = 0) And (thAcCode = FAccDetail.AcCode) Do Begin
          // Add into ListView
          SetupItem (Items.Add, Transaction);

          // Get next customer
          FuncRes := GetNext;
        End; { While (FuncRes = 0) }
      End; { With lvTrans, oToolkit, Transaction }
  End { If (PageControl1.ActivePage = tabLedger) }
end;

{----------------------------------------}

// Displays Transaction Detail window in different modes (mdAdd, mdEdit, mdView)
procedure TfrmCustDetail.ShowTransDlg(DlgMode : TDialogMode);
var
  FuncRes     : LongInt;
begin
  With lvTrans, oToolkit, Transaction Do
    // Check 1 item is selected for editing
    If (DlgMode = mdAdd) Or (SelCount = 1) Then Begin
      If (DlgMode <> mdAdd) Then Begin
        // Retrieve selected Transaction details for View/Edit
        Index := thIdxOurRef;
        FuncRes := GetEqual(BuildOurRefIndex(Selected.Caption));
        If (FuncRes <> 0) Then
          MessageDlg ('The following error occured getting the Transaction Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                      mtError, [mbOk], 0);
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create Transaction Detail window
        With TfrmTHDetail.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Transaction Interface on detail window
            Case DlgMode Of
              mdAdd  : THDetail := Transaction.Add(dtSIN);
              mdEdit : THDetail := Transaction.Update;
              mdView : THDetail := Transaction.Clone;
            End; { Case }

            // Check we got a valid interface
            If Assigned (THDetail) Then Begin
              // Display 'View Transaction' dialog
              ShowModal;

              If NeedRefresh Then Begin
                If (DlgMode = mdAdd) Then
                  // Add new row to end of list
                  SetupItem (Items.Add, THDetail)
                Else
                  // Update current row in listview
                  SetupItem (Selected, THDetail);
              End; { If }
            End { If Assigned (THDetail) }
            Else
              ShowMessage ('Invalid Transaction Interface');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmCustDetail.btnAddClick(Sender: TObject);
begin
  ShowTransDlg(mdAdd);
end;

{----------------------------------------}

procedure TfrmCustDetail.btnEditClick(Sender: TObject);
begin
  ShowTransDlg(mdEdit);
end;

{----------------------------------------}

procedure TfrmCustDetail.btnViewClick(Sender: TObject);
begin
  ShowTransDlg(mdView);
end;

{----------------------------------------}

procedure TfrmCustDetail.btnViewNotesClick(Sender: TObject);
var
  FuncRes : LongInt;
begin
  With lvTrans, oToolkit, Transaction Do
    // Retrieve selected Transaction
    If (SelCount = 1) Then Begin
      Index := thIdxOurRef;
      FuncRes := GetEqual(BuildOurRefIndex(Selected.Caption));
      If (FuncRes = 0) Then
        // Display Notes
        DisplayNotes ('Notes for ' + Trim(thOurRef), oToolkit, thNotes)
      Else
        MessageDlg ('The following error occured getting the Transaction Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                    mtError, [mbOk], 0);
    End; { If (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmCustDetail.btnMatchingClick(Sender: TObject);
var
  FuncRes : LongInt;
begin
  With lvTrans, oToolkit, Transaction Do
    // Retrieve selected Transaction
    If (SelCount = 1) Then Begin
      Index := thIdxOurRef;
      FuncRes := GetEqual(BuildOurRefIndex(Selected.Caption));
      If (FuncRes = 0) Then
        // Display Matching Information
        DisplayTHMatching ('Matching for ' + Trim(thOurRef), oToolkit, thMatching)
      Else
        MessageDlg ('The following error occured getting the Transaction Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                    mtError, [mbOk], 0);
    End; { If (SelCount = 1) }
end;

end.

