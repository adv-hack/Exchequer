unit SerDetF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, comObj, Enterprise01_TLB;

type
  TSerialDlgMode = (sdAdd, {sdEdit,} sdView);

  TfrmSerialDet = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    edtSerial: TEdit;
    Label2: TLabel;
    edtInDoc: TEdit;
    Label3: TLabel;
    edtOutDoc: TEdit;
    Label4: TLabel;
    edtBatch: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtInLoc: TEdit;
    edtOutLoc: TEdit;
    lstInCcy: TComboBox;
    lstOutCcy: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtUnitCost: TEdit;
    Label10: TLabel;
    edtUnitSales: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label11: TLabel;
    edtOutDate: TEdit;
    Label12: TLabel;
    edtInDate: TEdit;
    Label13: TLabel;
    edtInQty: TEdit;
    Label14: TLabel;
    edtUseByDate: TEdit;
    edtBatchSold: TEdit;
    Label15: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FSerDetail   : ISerialBatch;
    FMode        : TSerialDlgMode;
    FNeedRefresh : Boolean;
  protected
    Procedure SetSerDetail (Value : ISerialBatch);
    Procedure SetMode (Value : TSerialDlgMode);
  public
    { Public declarations }
    Property SerDetail : ISerialBatch Read FSerDetail Write SetSerDetail;
    Property Mode : TSerialDlgMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;


implementation

{$R *.DFM}

Uses StkListF;

//------------------------------------------------

procedure TfrmSerialDet.FormCreate(Sender: TObject);
Var
  I : Byte;
begin
  // Initialise local variables
  FSerDetail   := Nil;
  fMode        := sdAdd;
  FNeedRefresh := False;

  // Load Currency Lists
  With oToolkit.SystemSetup Do
    For I := 1 To ssMaxCurrency Do Begin
      lstInCcy.Items.Add (ssCurrency[I].scSymbol);
      lstOutCcy.Items.Add (ssCurrency[I].scSymbol);
    End; { For I }
end;

//------------------------------------------------

procedure TfrmSerialDet.FormDestroy(Sender: TObject);
begin
  // Explicitly release reference to interface
  FSerDetail   := Nil;
end;

//------------------------------------------------

procedure TfrmSerialDet.SetMode(Value: TSerialDlgMode);
begin
  FMode := Value;

  // Enable/Disable fields according to dialog purpose
  edtSerial.ReadOnly := (FMode <> sdAdd);
  edtBatch.ReadOnly := edtSerial.ReadOnly;

  edtInDoc.ReadOnly := True;    // Doc Refs cannot be edited EVER
  edtInLoc.ReadOnly := (FMode <> sdAdd);
  lstInCcy.Enabled := (Not edtInLoc.ReadOnly);
  edtUnitCost.ReadOnly := edtInLoc.ReadOnly;
  edtInDate.ReadOnly := edtInLoc.ReadOnly;

  edtOutDoc.ReadOnly := True;    // Doc Refs cannot be edited EVER
  edtOutLoc.ReadOnly := edtInLoc.ReadOnly;
  lstOutCcy.Enabled := (Not edtInLoc.ReadOnly);
  edtUnitSales.ReadOnly := edtInLoc.ReadOnly;
  edtOutDate.ReadOnly := edtInLoc.ReadOnly;

  edtInQty.ReadOnly := edtInLoc.ReadOnly;
  edtBatchSold.ReadOnly := True;
  edtUseByDate.ReadOnly := edtInLoc.ReadOnly;
end;

//------------------------------------------------

procedure TfrmSerialDet.SetSerDetail(Value: ISerialBatch);
begin
  If (FSerDetail <> Value) Then Begin
    FSerDetail := Value;

    With FSerDetail Do Begin
      // Set window title
      If (FMode = sdAdd) Then
        Caption := 'Add New Serial/Batch'
      Else
        Case snType Of
          snTypeSerial    : Caption := 'Serial Number Record - ' + Trim(snSerialNo);
          snTypeBatch     : Caption := 'Batch Number Record - ' + Trim(snBatchNo);
          snTypeBatchSale : Caption := 'Batch Sales Record - ' + Trim(snBatchNo);
        End; { Case snType }

      // Display Fields
      edtSerial.Text := Trim(snSerialNo);
      edtBatch.Text := Trim(snBatchNo);

      edtInDoc.Text := snInDocRef;
      edtInLoc.Text := snInLocation;
      lstInCcy.ItemIndex := snCostPriceCurrency - 1;        // list is 0 based!
      edtUnitCost.Text := FloatToStr(snCostPrice);
      edtInDate.Text := {oToolkit.Functions.entFormatDate(}snInDate{, '')};

      edtOutDoc.Text := snOutDocRef;
      edtOutLoc.Text := snOutLocation;
      lstOutCcy.ItemIndex := snSalesPriceCurrency - 1;        // list is 0 based!
      edtUnitSales.Text := FloatToStr(snSalesPrice);
      edtOutDate.Text := {oToolkit.Functions.entFormatDate(}snOutDate{, '')};

      edtInQty.Text := FloatToStr(snBatchQuantity);
      edtBatchSold.Text := FloatToStr(snBatchQuantity - snBatchQuantitySold);
      edtUseByDate.Text := snUseByDate;
    End; { With FSerDetail }
  End; { If (FSerDetail <> Value) }
end;

//------------------------------------------------

procedure TfrmSerialDet.btnOKClick(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  With FSerDetail Do Begin
    // Copy detail into Serial Interface
    snSerialNo := edtSerial.Text;
    snBatchNo := edtBatch.Text;

    snInLocation := edtInLoc.Text;
    snCostPriceCurrency := lstInCcy.ItemIndex + 1;        // list is 0 based!
    snCostPrice := StrToFloat(edtUnitCost.Text);
    snInDate := edtInDate.Text;;

    snOutLocation := edtOutLoc.Text;
    snSalesPriceCurrency := lstOutCcy.ItemIndex + 1;        // list is 0 based!
    snSalesPrice := StrToFloat(edtUnitSales.Text);
    snOutDate := edtOutDate.Text;

    snBatchQuantity := StrToFloat(edtInQty.Text);
    snUseByDate := edtUseByDate.Text;

    snDailyRate := oToolkit.SystemSetup.ssCurrency[snCostPriceCurrency].scDailyRate;
    snCompanyRate := oToolkit.SystemSetup.ssCurrency[snCostPriceCurrency].scCompanyRate;

    // Save Location
    FuncRes := FSerDetail.Save;
    If (FuncRes = 0) Then Begin
      // Close dialog
      FNeedRefresh := True;
      Close;
    End { If (FuncRes = 0) }
    Else
      // Error saving Serial details
      MessageDlg ('The following error occured saving the Serial/Batch Record:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
  End; { With FLocDetail }
end;

//------------------------------------------------

procedure TfrmSerialDet.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    sdAdd  : ; { No Action Required }
    //sdEdit : FSerDetail.Cancel;
    sdView : ; { No Action Required }
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

//------------------------------------------------

end.
