unit TLDetF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Enterprise01_TLB, ListF, StdCtrls, ComCtrls, ExtCtrls, Buttons;

type
  TfrmLineDetail = class(TForm)
    PageControl1: TPageControl;
    tabMain: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtStockCode: TEdit;
    lblLocation: TLabel;
    edtLocation: TEdit;
    edtDesc: TEdit;
    GroupBox2: TGroupBox;
    lblQtyMul: TLabel;
    edtQtyMul: TEdit;
    Label4: TLabel;
    edtQty: TEdit;
    Label5: TLabel;
    edtUnitPrice: TEdit;
    Label6: TLabel;
    edtDiscount: TEdit;
    edtTotal: TEdit;
    Label7: TLabel;
    GroupBox3: TGroupBox;
    lblJobCode: TLabel;
    lblAnalCode: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtJobCode: TEdit;
    edtAnalCode: TEdit;
    edtGLCode: TEdit;
    edtCostPrice: TEdit;
    tabFooter: TTabSheet;
    GroupBox4: TGroupBox;
    lblUserField1: TLabel;
    lblUserField2: TLabel;
    lblUserField3: TLabel;
    lblUserField4: TLabel;
    edtUserField1: TEdit;
    edtUserField2: TEdit;
    edtUserField3: TEdit;
    edtUserField4: TEdit;
    GroupBox6: TGroupBox;
    lstVATCode: TComboBox;
    panButtons: TPanel;
    btnCancel: TButton;
    GroupBox5: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    edtLineDate: TEdit;
    lstLineType: TComboBox;
    btnOK: TButton;
    tabshSerial: TTabSheet;
    lvSerial: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtStockCodeExit(Sender: TObject);
    procedure edtLocationExit(Sender: TObject);
    procedure edtDescExit(Sender: TObject);
    procedure edtQtyExit(Sender: TObject);
    procedure edtUnitPriceExit(Sender: TObject);
    procedure edtDiscountExit(Sender: TObject);
    procedure edtQtyMulExit(Sender: TObject);
    procedure lstVATCodeClick(Sender: TObject);
    procedure edtCostPriceExit(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }
    FTH          : ITransaction;
    FTLDetail    : ITransactionLine;
    FMode        : TDialogMode;
    FNeedRefresh : Boolean;
  protected
    procedure CalcTotal;
    Procedure SetTLDetail (Value : ITransactionLine);
    Procedure SetMode (Value : TDialogMode);
  public
    { Public declarations }
    Property TH : ITransaction Read FTH Write FTH;
    Property TLDetail : ITransactionLine Read FTLDetail Write SetTLDetail;
    Property Mode : TDialogMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;


implementation

{$R *.DFM}

Uses StkSelct;

{----------------------------------------}

procedure TfrmLineDetail.FormCreate(Sender: TObject);
Const
  VATCodeList : Array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
Var
  I : SmallInt;
begin
  FTH          := Nil;
  FTLDetail    := Nil;
  fMode        := mdAdd;
  FNeedRefresh := False;

  PageControl1.ActivePage := tabMain;

  With oToolkit.SystemSetup Do Begin
    lstVATCode.Clear;
    For I := Low(VATCodeList) To High(VatCodeList) Do
      with ssVATRates[VATCodeList[I]] Do
        lstVATCode.Items.Add (svCode);
  End; { With }

  With oToolkit.SystemSetup.ssUserFields Do Begin
    lstLineType.Clear;
    lstLineType.Items.Add('Normal');
    If ufLineType1Enabled Then lstLineType.Items.Add(ufLineType1);
    If ufLineType2Enabled Then lstLineType.Items.Add(ufLineType2);
    If ufLineType3Enabled Then lstLineType.Items.Add(ufLineType3);
    If ufLineType4Enabled Then lstLineType.Items.Add(ufLineType4);
  End; { With oToolkit.SystemSetup.ssUserFields }
end;

{----------------------------------------}

procedure TfrmLineDetail.FormDestroy(Sender: TObject);
begin
  FTH := Nil;
  FTLDetail := Nil;
end;

{----------------------------------------}

Procedure TfrmLineDetail.SetMode (Value : TDialogMode);
Begin { SetMode }
  FMode := Value;

  With oToolkit, SystemSetup Do Begin
    btnOK.Enabled := True;
    btnCancel.Enabled := (FMode in [mdAdd, mdEdit]);

    // Check System Setup switch for Quantity Multiplier field
    lblQtyMul.Visible := ssInputPackQtyOnLine;
    edtQtyMul.Visible := lblQtyMul.Visible;

    // Check system Setup switch for Locations
    lblLocation.Visible := ssUseLocations;
    edtLocation.Visible := lblLocation.Visible;

    // Check Job Costing Release Code
    edtJobCode.Visible := (ssReleaseCodes.rcJobCosting <> rcDisabled);
    lblJobCode.Visible := edtJobCode.Visible;
    lblAnalCode.Visible := edtJobCode.Visible;
    edtAnalCode.Visible := edtJobCode.Visible;

    edtStockCode.ReadOnly := Not (FMode in [mdAdd, mdEdit]);
    edtLocation.ReadOnly := edtStockCode.ReadOnly;
    edtDesc.ReadOnly := edtStockCode.ReadOnly;

    edtQtyMul.ReadOnly := edtStockCode.ReadOnly;
    edtQty.ReadOnly := edtStockCode.ReadOnly;
    edtUnitPrice.ReadOnly := edtStockCode.ReadOnly;
    edtDiscount.ReadOnly := edtStockCode.ReadOnly;
    edtTotal.ReadOnly := edtStockCode.ReadOnly;

    edtJobCode.ReadOnly := edtStockCode.ReadOnly;
    edtAnalCode.ReadOnly := edtStockCode.ReadOnly;
    lstVATCode.Enabled := Not edtStockCode.ReadOnly;
    edtGLCode.ReadOnly := edtStockCode.ReadOnly;
    edtCostPrice.ReadOnly := edtStockCode.ReadOnly;

    lstLineType.Enabled := Not edtStockCode.ReadOnly;
    edtLineDate.ReadOnly := edtStockCode.ReadOnly;

    edtUserField1.ReadOnly := edtStockCode.ReadOnly;
    edtUserField2.ReadOnly := edtStockCode.ReadOnly;
    edtUserField3.ReadOnly := edtStockCode.ReadOnly;
    edtUserField4.ReadOnly := edtStockCode.ReadOnly;
  End; { With oToolkit.SystemSetup }
End; { SetMode }

{----------------------------------------}

// Enable/Disable fields according to dialog purpose
Procedure TfrmLineDetail.SetTLDetail (Value : ITransactionLine);
begin
  If (FTlDetail <> Value) Then Begin
    FTLDetail := Value;

    With FTLDetail, oToolkit, Functions, SystemSetup Do Begin
      // Set window title
      Case FMode Of
        mdAdd  : Caption := 'Add ' + Trim(tlOurRef) + ' Transaction Line';
        mdEdit : Caption := 'Edit ' + Trim(tlOurRef) + ' Transaction Line';
      Else
        Caption := tlOurRef + ' Transaction Line';
      End; { Case }

      PageControl1.ActivePage := tabMain;

      // 'Data Entry' tab
      edtStockCode.Text := tlStockCode;
      edtLocation.Text := tlLocation;
      edtDesc.Text := tlDescr;

      edtQtyMul.Text := Format('%0.' + IntToStr(ssQtyDecimals) + 'n', [tlQtyMul]);
      edtQty.Text := Format('%0.' + IntToStr(ssQtyDecimals) + 'n', [tlQty]);
      edtUnitPrice.Text := Format('%0.2n', [tlNetValue]);
      If (tlDiscFlag = '%') Then
        edtDiscount.Text := Format('%0.2n', [tlDiscount * 100]) + '%'
      Else
        edtDiscount.Text := Format('%0.2n', [tlDiscount]);
      edtTotal.Text := Format('%0.2n', [entLineTotal(True, 0)]);

      edtJobCode.Text := tlJobCode;
      edtAnalCode.Text := tlAnalysisCode;
      lstVATCode.Text := tlVATCode;
      edtGLCode.Text := IntToStr(tlGLCode);
      edtCostPrice.Text := Format('%0.' + IntToStr(ssCostDecimals) + 'n', [tlCost]);

      // 'Footer' Tab
      With ssUserFields Do Begin
        lblUserField1.Visible := ufLine1Enabled;
        If lblUserField1.Visible Then lblUserField1.Caption := ufLine1;
        lblUserField2.Visible := ufLine2Enabled;
        If lblUserField2.Visible Then lblUserField2.Caption := ufLine2;
        lblUserField3.Visible := ufLine3Enabled;
        If lblUserField3.Visible Then lblUserField3.Caption := ufLine3;
        lblUserField4.Visible := ufLine4Enabled;
        If lblUserField4.Visible Then lblUserField4.Caption := ufLine4;
      End; { With ssUserFields }

      edtUserField1.Visible := lblUserField1.Visible;
      If edtUserField1.Visible Then edtUserField1.Text := tlUserField1;
      edtUserField2.Visible := lblUserField2.Visible;
      If edtUserField2.Visible Then edtUserField2.Text := tlUserField2;
      edtUserField3.Visible := lblUserField3.Visible;
      If edtUserField3.Visible Then edtUserField3.Text := tlUserField3;
      edtUserField4.Visible := lblUserField4.Visible;
      If edtUserField4.Visible Then edtUserField4.Text := tlUserField4;

      If (tlLineType < lstLineType.Items.Count) Then
        lstLineType.ItemIndex := tlLineType;
      edtLineDate.Text := entFormatDate (tlLineDate, '');
    End; { With FTLDetail, oToolkit, Functions, SystemSetup }
  End; { If (FTlDetail <> Value) }
end;

{----------------------------------------}

procedure TfrmLineDetail.btnOKClick(Sender: TObject);
Var
  FuncRes : LongInt;
  TmpStr : ShortString;
begin
  btnOK.SetFocus;

  If (FMode In [mdAdd, mdEdit]) Then Begin
    // Add or Edit
    With FTLDetail Do Begin
      // Copy miscellaneous detail back into Line structure
      tlJobCode := edtJobCode.Text;
      tlAnalysisCode := edtAnalCode.Text;
      tlGLCode := StrToInt (edtGLCode.Text);
      tlCost := StrtoFloat (edtCostPrice.Text);

      tlUserField1 := edtUserField1.Text;
      tlUserField2 := edtUserField2.Text;
      tlUserField3 := edtUserField3.Text;
      tlUserField4 := edtUserField4.Text;

      // Calculate VAT - all fields in TL should already be set (including any Settlement discount on header)
      CalcVATAmount;
    End; { With }

    If (FMode = mdAdd) Then
      // Adding Line - Add into list updating Transaction Totals as required
      FTLDetail.Save;

    // No Save operation for Editing Transaction Lines
    FNeedRefresh := True;
    Close;
  End { If }
  Else Begin
    // View
    FNeedRefresh := False;
    Close;
  End; { Else }
end;

{----------------------------------------}

procedure TfrmLineDetail.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    mdAdd  : ;                     // No action required
    mdEdit : FTLDetail.Cancel;     // Cancel update - restoring original line details
    mdView : ;                     // No action required
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

{----------------------------------------}

procedure TfrmLineDetail.edtStockCodeExit(Sender: TObject);
Var
  oCust  : IAccount;
  oStock : IStock;
  StkKey : ShortString;
begin
  If (Not edtStockCode.ReadOnly) Then Begin
    // Check for blank Stock Code
    StkKey := Trim(edtStockCode.Text);
    If (StkKey <> '') Then Begin
      // Stock Code is set - Run up the validation/selection dialog
      oStock := SelectStock (oToolkit, 2, StkKey);

      If Assigned(oStock) Then Begin
        // Got a Stock inteface - check for changes
        If (oStock.stCode <> FTLDetail.tlStockCode) Then
          With FTLDetail Do Begin
            // AOK - setup line details
            tlStockCode := oStock.stCode;
            edtStockCode.Text := tlStockCode;

            // Description - Single line only
            edtDesc.Text := oStock.stDesc[1];
            edtDescExit(Sender);

            // Unit Price
            CalcStockPrice;
            edtUnitPrice.Text := Format('%0.2f', [tlNetValue]);
            edtUnitPriceExit(Sender);

            // Cost Price
            edtCostPrice.Text := Format('%0.2f', [oStock.stCostPrice]);
            edtCostPriceExit(Sender);

            // Get default vat code - need customer object first - need extra code to handle 'Inclusive' VAT
            oCust := FTH.thAcCodeI;
            If Assigned(oCust) Then
              tlVATCode := entDefaultVATCode(oCust.acVATCode, oStock.stVATCode)
            Else
              tlVATCode := oStock.stVATCode;
            oCust := NIL;
            lstVATCode.Text := tlVATCode;

            // Default Line Type
            tlLineType := oStock.stDefaultLineType;
            lstLineType.Itemindex := tlLineType;
          End { With FTLDetail }
      End { If Assigned(oStock) }
      Else
        FTLDetail.tlStockCode := '';

      edtStockCode.Text := FTLDetail.tlStockCode;

      oStock := Nil;
    End; { If (StkKey <> '') }
  End; { If (Not edtStockCode.ReadOnly) }
end;

{----------------------------------------}

procedure TfrmLineDetail.CalcTotal;
begin { CalcTotal }
  With FTLDetail Do Begin
    If FTH.thSettleDiscTaken Then
      edtTotal.Text := Format('%0.2f', [entLineTotal(oToolkit.SystemSetup.ssShowInvoiceDisc, FTH.thSettleDiscPerc)])
    Else
      edtTotal.Text := Format('%0.2f', [entLineTotal(oToolkit.SystemSetup.ssShowInvoiceDisc, 0)]);
  End; { With FTLDetail }
End; { CalcTotal }

{----------------------------------------}

procedure TfrmLineDetail.edtLocationExit(Sender: TObject);
begin
  If Not edtLocation.ReadOnly Then
    FTLDetail.tlLocation := edtLocation.Text;
end;

{----------------------------------------}

procedure TfrmLineDetail.edtDescExit(Sender: TObject);
begin
  If Not edtDesc.ReadOnly Then
    FTLDetail.tlDescr := edtDesc.Text;
end;

{----------------------------------------}

procedure TfrmLineDetail.edtQtyExit(Sender: TObject);
begin
  If Not edtQty.ReadOnly Then Begin
    FTLDetail.tlQty := StrToFloat(edtQty.Text);
    CalcTotal;
  End; { If edtQty.Enabled }
end;

{----------------------------------------}

procedure TfrmLineDetail.edtUnitPriceExit(Sender: TObject);
begin
  If Not edtUnitPrice.ReadOnly Then Begin
    FTLDetail.tlNetValue := StrToFloat(edtUnitPrice.Text);
    CalcTotal;
  End; { If edtUnitPrice.Enabled }
end;

{----------------------------------------}

procedure TfrmLineDetail.edtDiscountExit(Sender: TObject);
Var
  TmpStr : ShortString;
begin
  If Not edtDiscount.ReadOnly Then Begin
    With FTLDetail Do Begin
      TmpStr := Trim(edtDiscount.Text);
      If (TmpStr = '') Then Begin
        // No discount
        tlDiscount := 0.0;
        tlDiscFlag := ' ';
      End { If (TmpStr = '') }
      Else
        If (Pos ('%', TmpStr) > 0) Then Begin
          // Percentage
          Delete (TmpStr, Pos ('%', TmpStr), 1);
          tlDiscount := StrToFloat(TmpStr) / 100;
          tlDiscFlag := '%';
        End { If (Pos ('%', edtDiscount.Text) > 0) }
        Else Begin
          // Fixed Amount
          tlDiscount := StrToFloat(TmpStr);
          tlDiscFlag := ' ';
        End; { Else }
    End; { With FTLDetail }
    CalcTotal;
  End; { If Not edtDiscount.ReadOnly }
end;

{----------------------------------------}

procedure TfrmLineDetail.edtQtyMulExit(Sender: TObject);
begin
  If Not edtQtyMul.ReadOnly Then
    FTLDetail.tlQtyMul := StrToFloat(edtQtyMul.Text);
end;

{----------------------------------------}

procedure TfrmLineDetail.lstVATCodeClick(Sender: TObject);
begin
  If lstVATCode.Enabled Then
    FTLDetail.tlVatCode := Copy (lstVATCode.Text + ' ', 1, 1);
end;

{----------------------------------------}

procedure TfrmLineDetail.edtCostPriceExit(Sender: TObject);
begin
  If Not edtCostPrice.ReadOnly Then
    FTLDetail.tlCost := StrToFloat(edtCostPrice.Text);
end;

{----------------------------------------}

procedure TfrmLineDetail.PageControl1Change(Sender: TObject);
Var
  I : SmallInt;
begin
  If (PageControl1.ActivePage = tabshSerial) Then
    With FTLDetail, tlSerialBatch Do Begin
      // Clear out any existing items
      lvSerial.Items.Clear;

      // Load Serial Number List
      If tlUsesSerialBatchNo And (tlCount > 0) Then
        For I := 1 To tlCount Do
          With lvSerial.Items.Add, tlUsedSerialBatch[I] Do Begin
            Case snType Of
              snTypeSerial    : Caption := snSerialNo;
              snTypeBatch     : Begin
                                  Caption := 'Qty: ' + FloatToStr(snBatchQuantity);
                                  SubItems.Add (snBatchNo);
                                End;
              snTypeBatchSale : Begin
                                  Caption := 'Used: ' + FloatToStr(snBatchQuantitySold);
                                  SubItems.Add (snBatchNo);
                                End;
            End; { Case snType }
          End; { With lvSerial.Items.Add, tlUsedSerialBatch[I] }
    End; { With FTLDetail, tlSerialBatch }
end;

end.

