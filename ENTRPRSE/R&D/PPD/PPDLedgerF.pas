unit PPDLedgerF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, GlobVar, VarConst, oPPDLedgerTransactions,
  ExtCtrls, StrUtils, CommCtrl, EnterToTab, BTSupU1, Tranl1U,
  EntWindowSettings, Menus, ExBtth1u, ActnList;

type
  TfrmPPDLedger = class(TForm)
    lvTransactions: TListView;
    btnGivePPD: TButton;
    btnClose: TButton;
    btnTagInvoice: TButton;
    lstTransactionIndex: TComboBox;
    edtFind: TEdit;
    lblFind: TLabel;
    btnFind: TButton;
    btnViewInvoice: TButton;
    panProgress: TPanel;
    EnterToTab1: TEnterToTab;
    PopupMenu1: TPopupMenu;
    mnuoptGivePPD: TMenuItem;
    mnuoptTagInvoice: TMenuItem;
    mnuOptViewInvoice: TMenuItem;
    N2: TMenuItem;
    Properties1: TMenuItem;
    N1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    N3: TMenuItem;
    panHeader: TPanel;
    imgCheckBox: TImage;
    pmHeader: TPopupMenu;
    alMain: TActionList;
    aTagAll: TAction;
    aUntagAll: TAction;
    agAll1: TMenuItem;
    UntagAll1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure lvTransactionsCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure btnGivePPDClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnTagInvoiceClick(Sender: TObject);
    procedure btnViewInvoiceClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure lstTransactionIndexClick(Sender: TObject);
    procedure lvTransactionsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Properties1Click(Sender: TObject);
    procedure lvTransactionsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvTransactionsAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure lvTransactionsColumnDragged(Sender: TObject);
    procedure imgCheckBoxClick(Sender: TObject);
    procedure aTagAllExecute(Sender: TObject);
    procedure aUntagAllExecute(Sender: TObject);
  private
    { Private declarations }
    TransactionListIntf : IPPDLedgerTransactionList;
    FAccount : CustRec;
    ExLocal : TdPostExLocal;  //PR: 16/06/2015 ABSEXCH-16546 Changed ExLocal to TdPostExLocal as we need to update account balance
    OriginalListViewWindowProc : TWndMethod;
    DispTransPtr : TFInvDisplay;

    // details of last find
    LastSearchText : String;
    LastSearchFound : TListItem;

    FSettings : IWindowSettings;

    FLedgerHandle : HWND;

    procedure LoadList;
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    procedure ListViewWindowProcEx(var Message: TMessage);
    procedure ShowPPDCreditNote(CreditNote : InvRec);

    // MH 10/06/2015 v7.0.14 ABSEXCH-16530: Forgot to code the Tag/Untag button caption
    procedure UpdateTagButtonCaption;
    procedure SetTransactionState(AChecked: Boolean);
  public
    { Public declarations }
    Constructor Create (AOwner : TComponent; Const AccountRec : CustRec; HLedger : HWND); Reintroduce;

    //PR: 21/05/2015 Handle to customer/supplier ledger so we can send an update message after creating credit note
    property LedgerHandle : HWND read FLedgerHandle write FLedgerHandle;
  end;

// Displays the PPD Ledger window for the specified Account
//PR: 21/05/2015 Added ledger handle as parameter to allow update of customer/supplier ledger
Procedure DisplayPPDLedger(Const AccountRec : CustRec; HLedger : HWND);

implementation

{$R *.dfm}

Uses SalTxl1U, PromptPaymentDiscountFuncs, ETDateU, oTakePPD;

var
  PPDDispTrans : TFInvDisplay;

//=========================================================================

// Displays the PPD Ledger window for the specified Account
Procedure DisplayPPDLedger(Const AccountRec : CustRec; HLedger : HWND);
Var
  CreateNew : Boolean;
  I : Integer;
Begin // DisplayPPDLedger
  // Check for an existing PPD Ledger window and activate that if it exists
  CreateNew := True;
  For I := 0 To (Application.MainForm.MDIChildCount - 1) Do
  Begin
    If (Application.MainForm.MDIChildren[I] Is TfrmPPDLedger) Then
    Begin
      // Activate the existing window
      Application.MainForm.MDIChildren[I].Show;
      TfrmPPDLedger(Application.MainForm.MDIChildren[I]).LedgerHandle := HLedger;
      CreateNew := False;
      Break;
    End; // If (Screen.Forms[I] Is TfrmPPDLedger)
  End; // For I

  If CreateNew Then
  begin
    TfrmPPDLedger.Create(Application.MainForm, AccountRec, HLedger);
  end;
End; // DisplayPPDLedger

//=========================================================================

Constructor TfrmPPDLedger.Create (AOwner : TComponent; Const AccountRec : CustRec; HLedger : HWND);
Var
  I : IPPDLedgerTransactionListIndexEnum;
begin
  Inherited Create (Owner);

  ClientHeight := 196;
  ClientWidth := 1073;

  FAccount := AccountRec;
  Caption := 'PPD Ledger for ' + Trim(FAccount.CustCode);
  btnGivePPD.Caption := PPDGiveTakeWord(FAccount.CustSupp) + ' PPD';

  // Use a local MTExLocal instance to isolate data access
  ExLocal.Create(91);
  ExLocal.Open_System(CustF, SysF);

  // Load any previously saved colours and positions
  FSettings := GetWindowSettings(Self.Name);
  If Assigned(FSettings) Then
    FSettings.LoadSettings;

  If Assigned(FSettings) And (Not FSettings.UseDefaults) Then
  Begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(Self);
    FSettings.SettingsToParent(lvTransactions);
  End; // If Assigned(FSettings) And (Not FSettings.UseDefaults)

  TransactionListIntf := NIL;
  DispTransPtr := NIL;

  // Load the Index descriptions
  lstTransactionIndex.Items.Clear;
  For I := Low(IPPDLedgerTransactionListIndexEnum) To High(IPPDLedgerTransactionListIndexEnum) Do
    lstTransactionIndex.Items.Add(PPDLedgerTransactionListIndexDescriptions[I]);
  lstTransactionIndex.ItemIndex := 0;

  // Redirect the list view's WindowProc so we can detect the checkbox being changed
  OriginalListViewWindowProc := lvTransactions.WindowProc;
  lvTransactions.WindowProc := ListViewWindowProcEx;

  LastSearchText := '';
  LastSearchFound := NIL;

  FLedgerHandle := HLedger;
end;

//------------------------------

procedure TfrmPPDLedger.FormCreate(Sender: TObject);
Begin // FormCreate
  // DO NOT USE
End; // FormCreate

//------------------------------

procedure TfrmPPDLedger.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//------------------------------

procedure TfrmPPDLedger.FormDestroy(Sender: TObject);
begin
  // Release the transaction list interface
  TransactionListIntf := NIL;

  ExLocal.Close_Files;
  ExLocal.Destroy;

  If Assigned(FSettings) Then
  Begin
    FSettings.WindowToSettings(Self);
    FSettings.ParentToSettings(Self, edtFind);
    FSettings.ParentToSettings(lvTransactions, lvTransactions);
    // Save Columns?
    FSettings.SaveSettings(SaveCoordinates1.Checked);
    FSettings := nil;
  End; // If Assigned(FSettings)
end;

//------------------------------

procedure TfrmPPDLedger.FormActivate(Sender: TObject);
begin
  // First time in, build the list of transactions
  If (Not Assigned(TransactionListIntf)) Then
  Begin
    panProgress.Visible := True;
    Try
      // Create a TPPDLedgerTransactionList instance to manage the qualifying transactions for the list
      TransactionListIntf := CreatePPDLedgerTransactionList(FAccount);
      TransactionListIntf.Index := IPPDLedgerTransactionListIndexEnum(lstTransactionIndex.ItemIndex);

      // Scan the trader ledger to identify transactions qualifying for PPD
      TransactionListIntf.LoadTransactions (ExLocal);
      LoadList;
    Finally
      panProgress.Visible := False;
    End; // Try..Finally
  End; // If (Not Assigned(TransactionListIntf))
end;

//------------------------------

procedure TfrmPPDLedger.FormResize(Sender: TObject);
Const
  BorderPix = 4;
begin
  // Align buttons to right border
  btnGivePPD.Left := ClientWidth - BorderPix - btnGivePPD.Width;
  btnClose.Left := btnGivePPD.Left;
  btnTagInvoice.Left := btnGivePPD.Left;
  btnViewInvoice.Left := btnGivePPD.Left;

  // Align Index to bottom
  lstTransactionIndex.Left := BorderPix;
  lstTransactionIndex.Top := ClientHeight - panHeader.Height - lstTransactionIndex.Height;

  // Fit ListView in middle
  lvTransactions.Left := BorderPix;
  lvTransactions.Width := btnGivePPD.Left - BorderPix - lvTransactions.Left;
  lvTransactions.Top := panHeader.Height;
  lvTransactions.Height := lstTransactionIndex.Top - BorderPix - lvTransactions.Top;


  // Make Position of Header panel in sync with ListView.
  panHeader.Left  := BorderPix;
  panHeader.Width := lvTransactions.Width;

  // Centre progress panel over listview
  panProgress.Left := lvTransactions.Left + ((lvTransactions.Width - panProgress.Width) Div 2);

  // Align Find to bottom right of listview
  btnFind.Top := ClientHeight - panHeader.Height - edtFind.Height;
  btnFind.Left := lvTransactions.Left + lvTransactions.Width - btnFind.Width;

  edtFind.Top := ClientHeight - panHeader.Height - edtFind.Height ;
  edtFind.Left := btnFind.Left - 1 - edtFind.Width;
  lblFind.Top := edtFind.Top + 3;
  lblFind.Left := edtFind.Left - lblFind.Width - BorderPix;
end;

//------------------------------

Procedure TfrmPPDLedger.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X := 650;
    ptMinTrackSize.Y := 199;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.ListViewWindowProcEx(var Message: TMessage);
begin
  // Complicated Windows API/Messaging stuff to detect the clicking of a checkbox in a listview
  // row - copied from http://delphi.about.com/od/delphitips2007/qt/listviewchecked.htm
  If Message.Msg = CN_NOTIFY Then
  Begin
    if PNMHdr(Message.LParam)^.Code = LVN_ITEMCHANGED then
    begin
      with PNMListView(Message.LParam)^ do
      begin
        if (uChanged and LVIF_STATE) <> 0 then
        begin
          if ((uNewState and LVIS_STATEIMAGEMASK) shr 12) <> ((uOldState and LVIS_STATEIMAGEMASK) shr 12) then
          begin
            lvTransactions.Items[iItem].Selected := True;
            TransactionListIntf.Transactions[iItem].tdSelected := lvTransactions.Items[iItem].Checked;

            // MH 10/06/2015 v7.0.14 ABSEXCH-16530: Forgot to code the Tag/Untag button caption
            UpdateTagButtonCaption;
          end;
        end;
      end;
    end;

    //original ListView message handling
    OriginalListViewWindowProc(Message) ;
  End // if Message.Msg = CN_NOTIFY
  Else
    //original ListView message handling
    OriginalListViewWindowProc(Message) ;
end;

//------------------------------

procedure TfrmPPDLedger.lvTransactionsColumnDragged(Sender: TObject);
Var
  ColumnOrder, NewColumnOrder: array of Integer;
  I, iNext : Integer;
begin
  // Hack: Because the painting of the first column (OurRef) doesn't work properly if the Expiry
  // Date column is positioned first at runtime, this routine ensures that the OurRef column is
  // always positioned first.

  // Use a dynamic array to retrieve the column order from the listview - the Index properties
  // in the TListView are not reliable so this bypasses the VCL component - the new order (post
  // column drag) will be represented in this array
  SetLength(ColumnOrder, lvTransactions.Columns.Count);
  ListView_GetColumnOrderArray(lvTransactions.Handle, lvTransactions.Columns.Count, PInteger(ColumnOrder));

  // Check if the OurRef column is first (OurRef = ID 0)
  If (ColumnOrder[0] <> 0) Then
  Begin
    // OurRef not first - create a dynamic array and resort the columns with OurRef (ID 0) first
    SetLength(NewColumnOrder, lvTransactions.Columns.Count);
    NewColumnOrder[0] := 0;
    iNext := 1;
    For I := Low(ColumnOrder) To High(ColumnOrder) Do
      If (ColumnOrder[I] <> 0) Then
      Begin
        NewColumnOrder[iNext] := ColumnOrder[I];
        iNext := iNext + 1;
      End; // If (ColumnOrder[I] <> 0)

    // Send the column order array into the lsitview - bypasses the VCL which doesn't work properly
    ListView_SetColumnOrderArray(lvTransactions.Handle, lvTransactions.Columns.Count, PInteger(NewColumnOrder));
  End; // If (ColumnOrder[0] <> 0)
end;

//------------------------------

procedure TfrmPPDLedger.lvTransactionsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
                                                     State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  // If the PPD Expiry column is first then the OurRef column will inherit its colours so we need
  // to correct that - unfortunately nothing seems to work

  // Doesn't work
  //Sender.Canvas.Font.Assign(edtFind.Font);

  // Setting font details individually doesn't work either
  //lvTransactions.Canvas.Font.Style := edtFind.Font.Style;
  //lvTransactions.Canvas.Font.Color := edtFind.Font.Color;

  // Copy hack from DrawSubItem - no difference
//  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color + 1;
//  Sender.Canvas.Brush.Color := edtFind.Color;

  // Just in case SEnder != lvTransactions - made no difference
//  lvTransactions.Canvas.Brush.Color := edtFind.Color - 1;
//  lvTransactions.Canvas.Brush.Color := edtFind.Color;

  // Try using ListView property off Item
//  Item.ListView.Brush.Color := edtFind.Color - 1;
//  Item.ListView.Brush.Color := edtFind.Color;
//  Item.ListView.Canvas.Brush.Color := edtFind.Color - 1;
//  Item.ListView.Canvas.Brush.Color := edtFind.Color;

  // Try bypassing the VCL component - doesn't work
//  ListView_SetBKColor(lvTransactions.Handle, edtFind.Color);
//  ListView_SetTextBkColor(lvTransactions.Handle, edtFind.Color);
end;

procedure TfrmPPDLedger.lvTransactionsAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  // Try the advanced version - no difference
//  If (Stage = cdPrePaint) Then
//    Sender.Canvas.Brush.Color := edtFind.Color;
end;

//------------------------------

procedure TfrmPPDLedger.lvTransactionsCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  DaysLeftBeforeExpiry : Integer;
  ExpiryDate : string;
  TextColour : TColor;
  BackColour : TColor;
  Font : TFont;
  bApplyDefaultColours : Boolean;
begin
  bApplyDefaultColours := True;

  // Check its the PPD Expiry column
  If (SubItem = 10) Then
  Begin
    //Check if we've got a date. also need to remove separators in order to use Date2Store function
    ExpiryDate := AnsiReplaceStr(Item.SubItems[SubItem-1], '/', '');
    If (Trim(ExpiryDate) <> '') Then
    Begin
      //How many days left?
      DaysLeftBeforeExpiry := NoDays(EtDateU.Today, Date2Store(ExpiryDate));

      //Set colours appropriately
      Font := Sender.Canvas.Font;
      TextColour := Sender.Canvas.Font.Color;
      BackColour := Sender.Canvas.Brush.Color;
      SetPPDColours(DaysLeftBeforeExpiry, TextColour, BackColour, Font);
      Sender.Canvas.Font.Color := TextColour;
      // Hack: There appears to be a bug where the color isn't set properly internally, so we need
      // to force the change to a different value and then back to what we want
      Sender.Canvas.Brush.Color := BackColour - 1;
      Sender.Canvas.Brush.Color := BackColour;

      bApplyDefaultColours := False;
    End; // If (Trim(ExpiryDate) <> '')
  End; // If (SubItem = 10)

  If bApplyDefaultColours Then
  Begin
    Sender.Canvas.Font.Assign(edtFind.Font);
    // Hack: There appears to be a bug where the color isn't set properly internally, so we need
    // to force the change to a different value and then back to what we want
    Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color + 1;
    Sender.Canvas.Brush.Color := edtFind.Color;
  End; // If bApplyDefaultColours
end;

//------------------------------

procedure TfrmPPDLedger.lvTransactionsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  If Selected Then
    // MH 10/06/2015 v7.0.14 ABSEXCH-16530: Forgot to code the Tag/Untag button caption
    UpdateTagButtonCaption;

  If Selected And Assigned(DispTransPtr) Then
  Begin
    // MH 10/06/2015 v7.0.14 ABSEXCH-16538: Only update the view transaction window if it is still open
    If Assigned(DispTransPtr.TransForm[0]) Then
    Begin
      // Need to overwrite the global transaction for the View window to pick up
      Inv := TransactionListIntf.Transactions[lvTransactions.Selected.Index].tdTransaction;

      // Set the LastDocHed to tell it which window to open - I don't know why it can't look at Inv
      DispTransPtr.LastDocHed := Inv.InvDocHed;

      If (DispTransPtr.LastFolio <> Inv.FolioNum) Then
        DispTransPtr.Display_Trans(100, Inv.FolioNum, BOff, False);
    End; // If Assigned(DispTransPtr.TransForm[0])
  End; // If Selected And Assigned(DispTransPtr)
end;

//-------------------------------------------------------------------------

// MH 10/06/2015 v7.0.14 ABSEXCH-16530: Forgot to code the Tag/Untag button caption
procedure TfrmPPDLedger.UpdateTagButtonCaption;
Var
  bGotTagged : Boolean;
  I : Integer;
Begin // UpdateTagButtonCaption
  If Assigned(lvTransactions.Selected) Then
  Begin
    If lvTransactions.Selected.Checked Then
      btnTagInvoice.Caption := 'Un&tag Invoice'
    Else
      btnTagInvoice.Caption := '&Tag Invoice';
  End // If Assigned(lvTransactions.Selected)
  Else
    btnTagInvoice.Caption := '&Tag Invoice';

  mnuoptTagInvoice.Caption := btnTagInvoice.Caption;


  // MH 25/06/2015 v7.0.14 ABSEXCH-16592: Enable/Disable Give PPD Button depending on whether
  // any transactions are actually tagged
  If Assigned(lvTransactions.Selected) Then
    bGotTagged := lvTransactions.Selected.Checked
  Else
    bGotTagged := False;

  If (Not bGotTagged) Then
  Begin
    For I := 0 To (TransactionListIntf.Count - 1) Do
    Begin
      bGotTagged := TransactionListIntf.Transactions[I].tdSelected;
      If bGotTagged Then
        Break;
    End; // For I
  End; // If (Not bGotTagged)

  btnGivePPD.Enabled := bGotTagged;
End; // UpdateTagButtonCaption

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.LoadList;
Var
  TransactionIntf : IPPDLedgerTransactionDetails;
  SelectedCaption : String;
  I : Integer;
Begin // LoadList
  // Temporarily disable the redirection of the list view's WindowProc whilst we load it, otherwise
  // it starts writing back to the objects as each row is added with Checked = False
  lvTransactions.WindowProc := OriginalListViewWindowProc;
  Try
    // Remember the selected row so we can reposition on that
    If Assigned(lvTransactions.Selected) Then
      SelectedCaption := lvTransactions.Selected.Caption
    Else
      SelectedCaption := '';

    // Remove any existing data
    lvTransactions.Clear;

    For I := 0 To (TransactionListIntf.Count - 1) Do
    Begin
      TransactionIntf := TransactionListIntf.Transactions[I];

      With lvTransactions.Items.Add Do
      Begin
        Checked := TransactionIntf.tdSelected;
        Caption := TransactionIntf.tdOurRef;
        SubItems.Add (TransactionIntf.tdTransactionDate);
        SubItems.Add (IfThen(TransactionIntf.tdSettledValueInBase <> 0.0, FormatCurFloat(GenRealMask, TransactionIntf.tdSettledValueInBase, BOff, 0), ''));
        SubItems.Add (FormatCurFloat(GenRealMask, TransactionIntf.tdOutstandingValueInBase, BOff, 0));
        SubItems.Add (FormatCurFloat(GenRealMask, TransactionIntf.tdTotalValueInBase, BOff, 0));
        SubItems.Add (FormatCurFloat(GenRealMask, TransactionIntf.tdOriginalValueInCcy, BOff, TransactionIntf.tdCurrency));
        SubItems.Add (TransactionIntf.tdYourRef);
        SubItems.Add (TransactionIntf.tdDateDue);
        SubItems.Add (TransactionIntf.tdStatus);
        SubItems.Add (FormatCurFloat(GenRealMask, TransactionIntf.tdPPDValueInCcy, BOff, TransactionIntf.tdCurrency));
        SubItems.Add (TransactionIntf.tdPPDExpiry);

        If (SelectedCaption = TransactionIntf.tdOurRef) Then
        Begin
          Selected := True;
          MakeVisible(False);
        End; // If (SelectedCaption = TransactionIntf.tdOurRef)
      End; // With lvTransactions.Items.Add
    End; // For I
  Finally
    lvTransactions.WindowProc := ListViewWindowProcEx;
  End; // Try..Finally
End; // LoadList

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.btnGivePPDClick(Sender: TObject);
var
  i : integer;
  Res : Integer;
  TakePPD : ITakePPD;
begin
  //get an instance of a ppd interface
  TakePPD := GetTakePPD;
  Try
    Cursor := crHourglass;
    //Populate settings
    TakePPD.tpDate := EtDateU.Today;
    TakePPD.tpExLocal := @ExLocal;
    TakePPD.tpAccount := Cust;

    //Add selected invoices
    for i := 0 to TransactionListIntf.Count - 1 do
      if TransactionListIntf.Transactions[i].tdSelected then
        TakePPD.AddInvoice(TransactionListIntf.Transactions[i].tdTransaction);

    //Give/Take the PPD
    Res := TakePPD.Execute;

    if (Res = 0) then
    begin
      //PR: 11/06/2015 ABSEXCH-16525 Reload the transactions to remove any that have just been processed
      TransactionListIntf.LoadTransactions (ExLocal);
      LoadList;

      //PR: 12/06/2015 Message changed at request of Ande Pearson
      if Cust.acPPDMode = pmPPDEnabledWithManualCreditNote then
        ShowMessage('PPD has been successfully taken on the selected transaction(s).'#13#13 +
                    'This Supplier is configured for ''Manual PCR'' creation. Please add the credit note(s) and allocate to the invoice(s)')
      else  //Display credit note
        ShowPPDCreditNote(TakePPD.tpCreditNote);
    end
    else
      ShowMessage('Unable to complete process: ' + TakePPD.tpErrorString);
  Finally
    Cursor := crDefault;
    TakePPD := nil;
  End;
end;

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.btnTagInvoiceClick(Sender: TObject);
begin
  // Tag Invoice
  If Assigned(lvTransactions.Selected) Then
  Begin
    lvTransactions.Selected.Checked := Not lvTransactions.Selected.Checked;


    // MH 10/06/2015 v7.0.14 ABSEXCH-16530: Forgot to code the Tag/Untag button caption
    UpdateTagButtonCaption;
  End; // If Assigned(lvTransactions.Selected)
end;

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.btnViewInvoiceClick(Sender: TObject);
Var
  DispTrans : TFInvDisplay;
begin
  If Assigned(lvTransactions.Selected) Then
  Begin
    If (DispTransPtr=nil) then
    Begin
      DispTrans := TFInvDisplay.Create(Self);
      DispTransPtr := DispTrans;
    end
    else
      DispTrans := DispTransPtr;

    Try
      // Need to overwrite the global transaction for the View window to pick up
      Inv := TransactionListIntf.Transactions[lvTransactions.Selected.Index].tdTransaction;

      // Set the LastDocHed to tell it which window to open - I don't know why it can't look at Inv
      DispTrans.LastDocHed := Inv.InvDocHed;

      // MH 25/06/2015 v7.0.14 ABSEXCH-16589: View Window not opening if viewing same transaction again
      If (DispTrans.LastFolio <> Inv.FolioNum) Or (Not Assigned(DispTransPtr.TransForm[0])) Then
        DispTrans.Display_Trans(100, Inv.FolioNum, BOff, False);
    Except
      DispTrans.Free;
    End;
  End; // If Assigned(lvTransactions.Selected)
end;

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.btnFindClick(Sender: TObject);
Var
  sSearchText : String;
  CurrentSearchRow : TListItem;
  Found : Boolean;
  StartSearchRowIdx, NextSearchRowIdx, ColIdx : Integer;

  //------------------------------

  Function MatchText (Const SearchText, ColumnText : String) : Boolean;
  Begin // MatchText
    Result := (Pos(SearchText, UpperCase(Trim(ColumnText))) > 0);
  End; // MatchText

  //------------------------------

  Function MoveToNextRow (Const CurrentRowIdx : Integer) : Integer;
  Begin // MoveToNextRow
    // move to next row, wrap around to start if we pass the end
    Result := CurrentRowIdx + 1;
    If (Result >= lvTransactions.Items.Count) Then
      Result := 0;
  End; // MoveToNextRow

  //------------------------------

begin
  // Perform a case insensitive search from the selected row onwards
  sSearchText := UpperCase(Trim(edtFind.Text));
  If (sSearchText <> '') Then
  Begin
    // Reset the Last Found record if we have changed to a different search
    If (LastSearchText <> sSearchText) Then
      LastSearchFound := NIL;

    // Work out where to start
    If (Not Assigned(lvTransactions.Selected)) Then
      // Nothing selected - start at top
      NextSearchRowIdx := 0
    Else
    Begin
      // Row Selected - search that row first, unless it was the row we perviously found for the same seach
      If (lvTransactions.Selected = LastSearchFound) Then
        // Still on the previous result for this search, so move to the next row
        NextSearchRowIdx := MoveToNextRow (lvTransactions.Selected.Index)
      Else
        // Not last search result - search the current row first
        NextSearchRowIdx := lvTransactions.Selected.Index;
    End; // Else

    // Record the starting position so we can drop out of the loop when we get back to where we
    // started, otherwise it will never end if the search text doesn't exist in the list
    StartSearchRowIdx := NextSearchRowIdx;

    // Search through the rows until we have either found the specified text or we have gotten
    // back to our starting position
    Repeat
      // Get the row object from the listview
      If (NextSearchRowIdx >= 0) And (NextSearchRowIdx < lvTransactions.Items.Count) Then
        CurrentSearchRow := lvTransactions.Items[NextSearchRowIdx]
      Else
        // Shouldn't ever happen, but JIC
        CurrentSearchRow := NIL;

      Found := False;
      If Assigned(CurrentSearchRow) Then
      Begin
        // Search column text for a matching value
        Found := MatchText (sSearchText, CurrentSearchRow.Caption);
        ColIdx := 0;
        While (Not Found) And (ColIdx < CurrentSearchRow.SubItems.Count) Do
        Begin
          Found := MatchText (sSearchText, CurrentSearchRow.SubItems[ColIdx]);
          Inc(ColIdx);
        End; // While (Not Found) And (ColIdx < SubItems.Count)

        If Found Then
        Begin
          CurrentSearchRow.Selected := True;
          CurrentSearchRow.MakeVisible(False);
        End; // If Found
      End; // If Assigned(CurrentSearchRow)

      // Move to next row - wrap around to top at end of list
      NextSearchRowIdx := MoveToNextRow (NextSearchRowIdx);
    Until Found Or (NextSearchRowIdx = StartSearchRowIdx) Or (Not Assigned(CurrentSearchRow));

    // Record details of search and results so the Find Next behaviour works properly
    LastSearchText := sSearchText;
    If Found Then
      LastSearchFound := lvTransactions.Selected
    Else
    Begin
      MessageDlg ('The text ' + QuotedStr(StringReplace(Trim(edtFind.Text), '&', '&&', [rfReplaceAll])) + ' was not found in the list', mtInformation, [mbOK], 0);
      LastSearchFound := NIL;
      If edtFind.CanFocus Then
        edtFind.SetFocus;
    End; // Else
  End; // If (sSearchText <> '')
end;

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.lstTransactionIndexClick(Sender: TObject);
begin
  // Change Index
  TransactionListIntf.Index := IPPDLedgerTransactionListIndexEnum(lstTransactionIndex.ItemIndex);
  LoadList;
end;

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.Properties1Click(Sender: TObject);
begin
  If Assigned(FSettings) Then
    FSettings.Edit(Self, lvTransactions);
end;

//-------------------------------------------------------------------------

procedure TfrmPPDLedger.ShowPPDCreditNote(CreditNote : InvRec);
begin
  //If we haven't already used the display form then create an instance
  if not Assigned(PPDDispTrans) then
    PPDDispTrans := TFInvDisplay.Create(Application.MainForm);

  Try
    // Need to overwrite the global transaction for the View window to pick up
    Inv := CreditNote;

    // Set the LastDocHed to tell it which window to open - I don't know why it can't look at Inv
    PPDDispTrans.LastDocHed := Inv.InvDocHed;

    If (PPDDispTrans.LastFolio <> Inv.FolioNum) Then
      PPDDispTrans.Display_Trans(100, Inv.FolioNum, BOff, False);

    //Update customer/supplier ledger
    PostMessage(LedgerHandle, WM_CustGetRec, 121, 0);
  Except
    PPDDispTrans.Free;
  End;

  //close PPD Ledger
  Close;
end;

//=========================================================================
//ABSEXCH-16671: Added functionality to Tag all and Untag All in PPD ledger.

procedure TfrmPPDLedger.imgCheckBoxClick(Sender: TObject);
begin
  with imgCheckBox.ClientToScreen(Point(1, imgCheckBox.Height)) Do
    pmHeader.Popup(X,Y);
end;


procedure TfrmPPDLedger.aTagAllExecute(Sender: TObject);
begin
  SetTransactionState(True);
end;

procedure TfrmPPDLedger.aUntagAllExecute(Sender: TObject);
begin
  SetTransactionState(False);
end;


procedure TfrmPPDLedger.SetTransactionState(AChecked : Boolean);
var
  I : Integer;
  lPos : Integer;
begin
  lPos := 0;
  if lvTransactions.Items.Count = 0 then Exit;
  if Assigned(lvTransactions.Selected) then
    lPos := lvTransactions.Selected.Index;       // Store record position to be restore after the opration complete. 
  try
    for I := 0 to lvTransactions.Items.Count -1 do
    begin
      lvTransactions.Items[I].Checked := AChecked;
    end;
  finally
    lvTransactions.ItemIndex := lPos;
  end;
end;


Initialization
  PPDDispTrans := nil;

end.
