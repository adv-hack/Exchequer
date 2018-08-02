unit DiscDetF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Enterprise01_TLB, ListF, StdCtrls, ComCtrls, QtyBrkF;

type
  TfrmAcDiscDetlF = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    tabshDiscount: TTabSheet;
    tabshQtyBreaks: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lblStkDesc: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtStockCode: TEdit;
    edtUnitPrice: TEdit;
    edtDiscPerc: TEdit;
    lstDiscType: TComboBox;
    lstBands: TComboBox;
    lstCcy: TComboBox;
    edtDiscVal: TEdit;
    edtMarkUp: TEdit;
    btnSelectStk: TButton;
    lvQtyBreaks: TListView;
    btnAddQBrk: TButton;
    btnEditQBrk: TButton;
    btnViewQBrk: TButton;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSelectStkClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure lstDiscTypeClick(Sender: TObject);
    procedure btnAddQBrkClick(Sender: TObject);
    procedure btnEditQBrkClick(Sender: TObject);
    procedure btnViewQBrkClick(Sender: TObject);
  private
    { Private declarations }
    FDiscDetail  : IAccountDiscount;
    FMode        : TDialogMode;
    FNeedRefresh : Boolean;

    procedure DisplayQtyBreak (DlgMode : TQtyBrkDlgMode);
  protected
    procedure SetDiscDetail(const Value: IAccountDiscount);
    Procedure SetMode (Value : TDialogMode);
  public
    { Public declarations }
    Property DiscDetail : IAccountDiscount Read FDiscDetail Write SetDiscDetail;
    Property Mode : TDialogMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;

var
  frmAcDiscDetlF: TfrmAcDiscDetlF;

implementation

{$R *.DFM}

Uses StkSelct;

{----------------------------------------}

procedure TfrmAcDiscDetlF.FormCreate(Sender: TObject);
Var
  I : Byte;
begin
  // Initialise local variables
  FDiscDetail  := Nil;
  FMode        := mdAdd;
  FNeedRefresh := False;

  // Load currency List
  With oToolkit Do Begin
    lstCcy.Clear;

    For I := 0 To SystemSetup.ssMaxCurrency Do
      lstCcy.Items.Add (SystemSetup.ssCurrency[I].scSymbol);
  End; { With }
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.FormDestroy(Sender: TObject);
begin
  // Explicitly release reference to interface
  FDiscDetail := Nil;
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.SetDiscDetail(const Value: IAccountDiscount);
Var
  TmpStk : IStock;
begin
  If (FDiscDetail <> Value) Then Begin
    FDiscDetail := Value;

    With FDiscDetail Do Begin
      // Set window title
      If (FMode = mdAdd) Then
        Caption := 'Add New Discount'
      Else
        Caption := 'Discount Record - ' + Trim(adStockCode);

      PageControl1.ActivePage := tabshDiscount;

      // Display Fields
      edtStockCode.Text := adStockCode;
      TmpStk := adStockCodeI;
      If Assigned(TmpStk) Then Begin
        lblStkDesc.Caption := TmpStk.stDesc[1];
        TmpStk := NIL;
      End; { If Assigned(TmpStk) }

      lstDiscType.ItemIndex := Ord(adType);
      lstDiscTypeClick(Self);

      lstBands.ItemIndex := Ord (adPriceBand[1]) - Ord('A');

      lstCcy.ItemIndex := adCurrency;
      edtUnitPrice.Text := Format ('%8.2f', [adPrice]);

      edtDiscPerc.Text := Format ('%3.2f', [adDiscPercent]);
      edtDiscVal.Text := Format ('%8.2f', [adDiscValue]);

      edtMarkUp.Text := Format ('%8.2f', [adMarkupMarginPercent]);
    End; { With FDiscDetail }
  End; { If (FDiscDetail <> Value) }
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.SetMode(Value: TDialogMode);
begin
  FMode := Value;

  // Enable/Disable fields according to dialog purpose
  edtStockCode.ReadOnly := (FMode <> mdAdd);

  lstDiscType.Enabled := (FMode In [mdAdd, mdEdit]);
  lstDiscTypeClick(Self);

  lstBands.Enabled := lstDiscType.Enabled;

  lstCcy.Enabled := lstDiscType.Enabled;
  edtUnitPrice.ReadOnly := Not lstDiscType.Enabled;

  edtDiscPerc.ReadOnly := Not lstDiscType.Enabled;
  edtDiscVal.ReadOnly := Not lstDiscType.Enabled;

  edtMarkUp.ReadOnly := Not lstDiscType.Enabled;

  btnSave.Enabled := (FMode In [mdAdd, mdEdit]);
  If btnSave.Enabled Then btnCancel.Caption := '&Cancel' Else btnCancel.Caption := '&Close';

  btnAddQBrk.Enabled := btnSave.Enabled;
  btnEditQBrk.Enabled := btnAddQBrk.Enabled;
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.btnSaveClick(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  With FDiscDetail Do Begin
    // Copy detail into Discount Interface
    adStockCode   := edtStockCode.Text;
    adType        := lstDiscType.ItemIndex;
    adCurrency    := lstCcy.ItemIndex;
    adPriceBand   := lstBands.Text;
    adPrice       := StrToFloat(edtUnitPrice.Text);
    adDiscPercent := StrToFloat(edtDiscPerc.Text);
    If (adDiscPercent = 0.0) Then
      adDiscValue := StrToFloat(edtDiscVal.Text)
    Else
      adDiscValue := 0.0;
    adMarkupMarginPercent := StrToFloat(edtMarkup.Text);

    // Save Account Discount
    FuncRes := FDiscDetail.Save;
    If (FuncRes = 0) Then Begin
      // Close dialog
      FNeedRefresh := True;
      Close;
    End { If (FuncRes = 0) }
    Else
      // Error saving account details
      MessageDlg ('The following error occured saving the Discount Record:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
  End; { With FDiscDetail }
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    mdAdd  : ; { No Action Required }
    mdEdit : FDiscDetail.Cancel;
    mdView : ; { No Action Required }
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.btnSelectStkClick(Sender: TObject);
Var
  StockI : IStock;
  StkKey : ShortString;
begin
  StkKey := edtStockCode.Text;
  StockI := SelectStock (oToolkit, 0, StkKey);
  If Assigned(StockI) Then Begin
    edtStockCode.Text := StockI.stCode;
    lblStkDesc.Caption := StockI.stDesc[1];
  End; { If Assigned(StockI) }

  StockI := NIL;
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.PageControl1Change(Sender: TObject);
Var
  Res : LongInt;
begin
  If (PageControl1.ActivePage = tabshQtyBreaks) Then
    With lvQtyBreaks, FDiscDetail.adQtyBreaks Do Begin
      // Clear out any existing details
      Items.Clear;

      // Load Qty Breaks
      Res := GetFirst;
      While (Res = 0) Do Begin
        With Items.Add Do Begin
          // Save position of Qty Break record for later editing
          SavePosition;
          Data := Pointer(FDiscDetail.adQtyBreaks.Position);

          Caption := FloatToStr(qbQuantityFrom);
          SubItems.Add (FloatToStr(qbQuantityTo));

          Case qbType Of
            DiscSpecialPrice : Begin
                                 SubItems.Add ('Price');
                                 SubItems.Add (Format ('%8.2n', [qbPrice]));
                               End;
            DiscBandPrice    : Begin
                                 SubItems.Add ('Band');
                                 SubItems.Add ('');
                                 SubItems.Add (qbPriceBand);
                                 If (qbDiscPercent <> 0) Then
                                   SubItems.Add (Format ('%8.2n%s', [qbDiscPercent, '%']))
                                 Else Begin
                                   SubItems.Add ('');
                                   SubItems.Add (Format ('%8.2n', [qbDiscValue]));
                                 End; { Else }
                               End;
            DiscMargin,
            DiscMarkup       : Begin
                                 If (qbType = DiscMarkup) Then
                                   SubItems.Add ('Mark Up')
                                 Else
                                   SubItems.Add ('Margin');

                                 SubItems.Add ('');
                                 SubItems.Add ('');
                                 SubItems.Add ('');
                                 SubItems.Add ('');
                                 SubItems.Add (Format ('%8.2n%s', [qbMarkupMarginPercent, '%']));
                               End;
          End; { Case qbType  }
        End; { With Items.Add }

        Res := GetNext;
      End; { While (Res = 0) }
    End; { With lvQtyBreaks }
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.lstDiscTypeClick(Sender: TObject);
begin
  tabshQtyBreaks.TabVisible := (lstDiscType.ItemIndex = Ord(DiscQtyBreak));
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.DisplayQtyBreak (DlgMode : TQtyBrkDlgMode);
var
  FuncRes : LongInt;
begin
  With lvQtyBreaks, oToolkit, FDiscDetail, adQtyBreaks Do
    // Check 1 item is selected for editing
    If (DlgMode = qmdAdd) Or (SelCount = 1) Then Begin
      If (DlgMode <> qmdAdd) Then Begin
        // Retrieve selected Discount Details for View/Edit using the position
        // previously stored in the list view item
        adQtyBreaks.Position := LongInt(Selected.Data);
        FuncRes := RestorePosition;

        //FuncRes := GetEqual(BuildIndex(Selected.Caption, StrToInt(Selected.SubItems[0])));
        If (FuncRes <> 0) Then
          MessageDlg ('The following error occured getting the Quantity Break Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                      mtError, [mbOk], 0);
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create Qty Break Detail window
        With TfrmQtyBreak.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Discount details for detail dialog
            StockCode := FDiscDetail.adStockCode;
            Case DlgMode Of
              qmdAdd  : QtyBreak := adQtyBreaks.Add;
              qmdEdit : QtyBreak := adQtyBreaks.Update;
              qmdView : QtyBreak := adQtyBreaks;         // No clone object available at this time
            End; { Case }

            // Check we got a valid interface
            If Assigned (QtyBreak) Then Begin
              // Display dialog
              ShowModal;

              // Reload list if changes were made
              If NeedRefresh Then PageControl1Change(Self);
            End { If Assigned (DiscDetail) }
            Else
              ShowMessage ('The Quantity Break Detail is not available - someone else may be editing it');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.btnAddQBrkClick(Sender: TObject);
begin
  DisplayQtyBreak (qmdAdd);
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.btnEditQBrkClick(Sender: TObject);
begin
  DisplayQtyBreak (qmdEdit);
end;

{----------------------------------------}

procedure TfrmAcDiscDetlF.btnViewQBrkClick(Sender: TObject);
begin
  DisplayQtyBreak (qmdView);
end;

{----------------------------------------}

end.
