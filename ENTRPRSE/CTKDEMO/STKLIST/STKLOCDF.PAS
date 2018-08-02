unit StkLocDF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, StkListF, StkLocLF, Enterprise01_TLB;

type
  TfrmStkLocDetl = class(TForm)
    GroupBox1: TGroupBox;
    Label827: TLabel;
    Label831: TLabel;
    Label836: TLabel;
    Label835: TLabel;
    Label837: TLabel;
    Label838: TLabel;
    Label834: TLabel;
    Label86: TLabel;
    edtMinStk: TEdit;
    edtMaxStk: TEdit;
    edtInStock: TEdit;
    edtPosted: TEdit;
    edtAlloc: TEdit;
    edtFree: TEdit;
    edtOnOrder: TEdit;
    edtPicked: TEdit;
    GroupBox2: TGroupBox;
    Label828: TLabel;
    Label829: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    WIPLab: TLabel;
    Label88: TLabel;
    Label810: TLabel;
    CCLab: TLabel;
    Label85: TLabel;
    LabCur2: TLabel;
    Label3: TLabel;
    lstCostPriceCcy: TComboBox;
    edtCostPrice: TEdit;
    edtReorderPrice: TEdit;
    lstReorderCcy: TComboBox;
    edtSalesGL: TEdit;
    edtCOSGL: TEdit;
    edtWOGL: TEdit;
    edtSVGL: TEdit;
    edtWIPGL: TEdit;
    edtSupplier: TEdit;
    edtBinLoc: TEdit;
    edtCC: TEdit;
    edtDept: TEdit;
    SRSBox2: TScrollBox;
    Label818: TLabel;
    Label819: TLabel;
    Label820: TLabel;
    Label821: TLabel;
    Label822: TLabel;
    Label823: TLabel;
    Label824: TLabel;
    Label825: TLabel;
    edtPriceA: TEdit;
    edtPriceB: TEdit;
    edtPriceC: TEdit;
    edtPriceD: TEdit;
    edtPriceE: TEdit;
    edtPriceF: TEdit;
    edtPriceG: TEdit;
    edtPriceH: TEdit;
    lstCcyA: TComboBox;
    lstCcyB: TComboBox;
    lstCcyC: TComboBox;
    lstCcyD: TComboBox;
    lstCcyE: TComboBox;
    lstCcyF: TComboBox;
    lstCcyH: TComboBox;
    lstCcyG: TComboBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    edtLocCode: TEdit;
    edtLocDesc: TEdit;
    Label2: TLabel;
    edtStkCode: TEdit;
    edtStkDesc: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FStkLoc      : IStockLocation;
    FMode        : TDialogMode;
    FNeedRefresh : Boolean;
  protected
    procedure SetStkLoc(const Value: IStockLocation);
    Procedure SetMode (Value : TDialogMode);
  public
    { Public declarations }
    Property StkLocDetail : IStockLocation Read FStkLoc Write SetStkLoc;
    Property Mode : TDialogMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;

implementation

{$R *.DFM}

{----------------------------------------}

procedure TfrmStkLocDetl.FormCreate(Sender: TObject);
Var
  I : Byte;
begin
  // Initialise local variables
  FStkLoc      := Nil;
  fMode        := mdAdd;
  FNeedRefresh := False;

  With oToolkit.SystemSetup Do Begin
    For I := 0 To 90 Do
      lstCcyA.Items.Add (ssCurrency[I].scSymbol);
    lstCcyB.Items.Assign(lstCcyA.Items);
    lstCcyC.Items.Assign(lstCcyA.Items);
    lstCcyD.Items.Assign(lstCcyA.Items);
    lstCcyE.Items.Assign(lstCcyA.Items);
    lstCcyF.Items.Assign(lstCcyA.Items);
    lstCcyG.Items.Assign(lstCcyA.Items);
    lstCcyH.Items.Assign(lstCcyA.Items);
    lstCostPriceCcy.Items.Assign(lstCcyA.Items);
    lstReorderCcy.Items.Assign(lstCcyA.Items);
  End; { With oToolkit.SystemSetup }
end;

{----------------------------------------}

procedure TfrmStkLocDetl.FormDestroy(Sender: TObject);
begin
  // Explicitly release reference to interface
  FStkLoc := Nil;
end;

{----------------------------------------}

procedure TfrmStkLocDetl.SetMode(Value: TDialogMode);
begin
  FMode := Value;

  // Enable/Disable fields according to dialog purpose
  edtLocCode.ReadOnly := (FMode <> mdAdd);
  edtStkCode.ReadOnly := edtLocCode.ReadOnly;

  // Misc
  edtSupplier.ReadOnly := (FMode = mdView);
  edtCC.ReadOnly := edtSupplier.ReadOnly;
  edtDept.ReadOnly := edtSupplier.ReadOnly;
  edtBinLoc.ReadOnly := edtSupplier.ReadOnly;
  lstCostPriceCcy.Enabled := Not edtSupplier.ReadOnly;
  edtCostPrice.ReadOnly := edtSupplier.ReadOnly;
  lstReorderCcy.Enabled := Not edtSupplier.ReadOnly;
  edtReorderPrice.ReadOnly := edtSupplier.ReadOnly;

  // Sales Price Bands
  lstCcyA.Enabled := Not edtSupplier.ReadOnly;
  edtPriceA.ReadOnly := edtSupplier.ReadOnly;
  lstCcyB.Enabled := Not edtSupplier.ReadOnly;
  edtPriceB.ReadOnly := edtSupplier.ReadOnly;
  lstCcyC.Enabled := Not edtSupplier.ReadOnly;
  edtPriceC.ReadOnly := edtSupplier.ReadOnly;
  lstCcyD.Enabled := Not edtSupplier.ReadOnly;
  edtPriceD.ReadOnly := edtSupplier.ReadOnly;
  lstCcyE.Enabled := Not edtSupplier.ReadOnly;
  edtPriceE.ReadOnly := edtSupplier.ReadOnly;
  lstCcyF.Enabled := Not edtSupplier.ReadOnly;
  edtPriceF.ReadOnly := edtSupplier.ReadOnly;
  lstCcyG.Enabled := Not edtSupplier.ReadOnly;
  edtPriceG.ReadOnly := edtSupplier.ReadOnly;
  lstCcyH.Enabled := Not edtSupplier.ReadOnly;
  edtPriceH.ReadOnly := edtSupplier.ReadOnly;

  // GL Codes
  edtSalesGL.ReadOnly := edtSupplier.ReadOnly;
  edtCOSGL.ReadOnly := edtSupplier.ReadOnly;
  edtWOGL.ReadOnly := edtSupplier.ReadOnly;
  edtSVGL.ReadOnly := edtSupplier.ReadOnly;
  edtWIPGL.ReadOnly := edtSupplier.ReadOnly;

  // Quantities
  edtMinStk.ReadOnly := Not (FMode In [mdAdd, mdEdit]);
  edtMaxStk.ReadOnly := edtMinStk.ReadOnly;

  // Enable/Disable buttons as required
  btnSave.Enabled := (FMode In [mdAdd, mdEdit]);
  If btnSave.Enabled Then btnCancel.Caption := '&Cancel' Else btnCancel.Caption := '&Close';
end;

{----------------------------------------}

procedure TfrmStkLocDetl.SetStkLoc(const Value: IStockLocation);
Var
  TempI : IDispatch;
begin
  If (FStkLoc <> Value) Then Begin
    FStkLoc := Value;

    With FStkLoc, oToolkit.SystemSetup Do Begin
      // Set window title
      If (FMode = mdAdd) Then
        Caption := 'Add New Stock-Location Record'
      Else
        Caption := 'Stock-Location Record - ' + Trim(slStockCode) + ' at Location ' + Trim(slLocationCode);

      // Display Fields
      edtLocCode.Text := slLocationCode;
      TempI := slLocationCodeI;
      If Assigned(TempI) Then
        With TempI As ILocation Do
          edtLocDesc.Text := loName
      Else
        edtLocDesc.Text := '';
      TempI := Nil;
      edtStkCode.Text := slStockCode;
      TempI := slStockCodeI;
      If Assigned(TempI) Then
        With TempI As IStock Do
          edtStkDesc.Text := stDesc[1]
      Else
        edtStkDesc.Text := '';
      TempI := Nil;

      edtSupplier.Text := slSupplier;
      edtCC.Text := slCostCentre;
      edtDept.Text := slDepartment;
      edtBinLoc.Text := slBinLocation;
      lstCostPriceCcy.ItemIndex := slCostPriceCur;
      edtCostPrice.Text := Format ('%0.' + IntToStr(ssCostDecimals) + 'f', [slCostPrice]);
      lstReorderCcy.ItemIndex := slReorderCur;
      edtReorderPrice.Text := Format ('%0.' + IntToStr(ssCostDecimals) + 'f', [slReorderPrice]);

      // Sales Bands
      With slSalesBands['A'] Do Begin
        lstCcyA.ItemIndex := stCurrency;
        edtPriceA.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['A'] }
      With slSalesBands['B'] Do Begin
        lstCcyB.ItemIndex := stCurrency;
        edtPriceB.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['B'] }
      With slSalesBands['C'] Do Begin
        lstCcyC.ItemIndex := stCurrency;
        edtPriceC.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['C'] }
      With slSalesBands['D'] Do Begin
        lstCcyD.ItemIndex := stCurrency;
        edtPriceD.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['D'] }
      With slSalesBands['E'] Do Begin
        lstCcyE.ItemIndex := stCurrency;
        edtPriceE.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['E'] }
      With slSalesBands['F'] Do Begin
        lstCcyF.ItemIndex := stCurrency;
        edtPriceF.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['F'] }
      With slSalesBands['G'] Do Begin
        lstCcyG.ItemIndex := stCurrency;
        edtPriceG.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['G'] }
      With slSalesBands['H'] Do Begin
        lstCcyH.ItemIndex := stCurrency;
        edtPriceH.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['H'] }

      // GL Codes
      edtSalesGL.Text := IntToStr(slSalesGL);
      edtCOSGL.Text := IntToStr(slCostOfSalesGL);
      edtWOGL.Text := IntToStr(slPandLGL);
      edtSVGL.Text := IntToStr(slBalSheetGL);
      edtWIPGL.Text := IntToStr(slWIPGL);

      // Quantities
      edtMinStk.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [slQtyMin]);
      edtMaxStk.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [slQtyMax]);
      edtInStock.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [slQtyInStock]);
      edtPosted.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [slQtyPosted]);
      edtAlloc.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [slQtyAllocated]);
      edtPicked.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [slQtyPicked]);
      edtFree.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [slQtyFree]);
      edtOnOrder.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [slQtyOnOrder]);
    End; { With FStkLocl }
  End; { If (FStkLoc <> Value) }
end;

{----------------------------------------}

procedure TfrmStkLocDetl.btnSaveClick(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  With FStkLoc Do Begin
    // Copy detail back into Stock-Location Interface
    slLocationCode := edtLocCode.Text;
    slStockCode := edtStkCode.Text;

    slSupplier := edtSupplier.Text;
    slCostCentre := edtCC.Text;
    slDepartment := edtDept.Text;
    slBinLocation := edtBinLoc.Text;
    slCostPriceCur := lstCostPriceCcy.ItemIndex;
    slCostPrice := StrToFloat(edtCostPrice.Text);
    slReorderCur := lstReorderCcy.ItemIndex;
    slReorderPrice := StrToFloat(edtReorderPrice.Text);

    // Save Account
    FuncRes := FStkLoc.Save;
    If (FuncRes = 0) Then Begin
      // Close dialog
      FNeedRefresh := True;
      Close;
    End { If (FuncRes = 0) }
    Else
      ShowMessage ('Status ' + IntToStr(FuncRes));
  End; { With FStkDetail }
end;

procedure TfrmStkLocDetl.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    mdAdd  : ; { No Action Required }
    mdEdit : FStkLoc.Cancel;
    mdView : ; { No Action Required }
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

end.
