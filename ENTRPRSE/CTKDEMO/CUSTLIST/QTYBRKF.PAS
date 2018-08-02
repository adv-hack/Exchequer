unit QtyBrkF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Enterprise01_TLB, StdCtrls, ComCtrls;


type
  TQtyBrkDlgMode = (qmdAdd, qmdEdit, qmdView);

  TfrmQtyBreak = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtUnitPrice: TEdit;
    edtDiscPerc: TEdit;
    lstDiscType: TComboBox;
    lstBands: TComboBox;
    lstCcy: TComboBox;
    edtDiscVal: TEdit;
    edtMarkUp: TEdit;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label11: TLabel;
    edtQtyFrom: TEdit;
    edtQtyTo: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FStockCode   : ShortString;
    FQtyBreak    : IQuantityBreak;
    FMode        : TQtyBrkDlgMode;
    FNeedRefresh : Boolean;
  protected
    procedure SetQtyBreak(const Value: IQuantityBreak);
    Procedure SetMode (Value : TQtyBrkDlgMode);
  public
    { Public declarations }
    Property StockCode : ShortString Read FStockCode Write FStockCode;
    Property QtyBreak : IQuantityBreak Read FQtyBreak Write SetQtyBreak;
    Property Mode : TQtyBrkDlgMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;

var
  frmQtyBreak: TfrmQtyBreak;

implementation

{$R *.DFM}

{$IFDEF STKEX}
  Uses StkListF;
{$ELSE}
  Uses ListF;
{$ENDIF}

{----------------------------------------}

procedure TfrmQtyBreak.FormCreate(Sender: TObject);
Var
  I : Byte;
begin
  // Initialise local variables
  FQtyBreak    := Nil;
  FMode        := qmdAdd;
  FNeedRefresh := False;

  FStockCode := '';

  // Load currency List
  With oToolkit Do Begin
    lstCcy.Clear;

    For I := 0 To SystemSetup.ssMaxCurrency Do
      lstCcy.Items.Add (SystemSetup.ssCurrency[I].scSymbol);
  End; { With }
end;

{----------------------------------------}

procedure TfrmQtyBreak.FormDestroy(Sender: TObject);
begin
  // Explicitly release reference to interface
  FQtyBreak := Nil;
end;

{----------------------------------------}

procedure TfrmQtyBreak.SetQtyBreak(const Value: IQuantityBreak);
Var
  TmpStk : IStock;
begin
  If (FQtyBreak <> Value) Then Begin
    FQtyBreak := Value;

    With FQtyBreak Do Begin
      // Set window title
      If (FMode = qmdAdd) Then
        Caption := 'Add New Quantity Break'
      Else
        Caption := Format ('Quantity Break Record - %s - %0.0f to %0.0f',
                           [Trim(FStockCode), qbQuantityFrom, qbQuantityTo]);

      // Display Fields
      edtQtyFrom.Text := FloatToStr(qbQuantityFrom);
      edtQtyTo.Text := FloatToStr(qbQuantityTo);

      lstDiscType.ItemIndex := Ord(qbType);
      lstBands.ItemIndex := Ord (qbPriceBand[1]) - Ord('A');

      lstCcy.ItemIndex := qbCurrency;
      edtUnitPrice.Text := Format ('%8.2f', [qbPrice]);

      edtDiscPerc.Text := Format ('%3.2f', [qbDiscPercent]);
      edtDiscVal.Text := Format ('%8.2f', [qbDiscValue]);

      edtMarkUp.Text := Format ('%8.2f', [qbMarkupMarginPercent]);
    End; { With FDiscDetail, FQtyBreak }
  End; { If (FQtyBreak <> Value) }
end;

{----------------------------------------}

procedure TfrmQtyBreak.SetMode(Value: TQtyBrkDlgMode);
begin
  FMode := Value;

  // Enable/Disable fields according to dialog purpose
  edtQtyTo.Enabled := (FMode = qmdAdd);

  lstDiscType.Enabled := (FMode In [qmdAdd, qmdEdit]);

  lstBands.Enabled := lstDiscType.Enabled;

  lstCcy.Enabled := lstDiscType.Enabled;
  edtUnitPrice.ReadOnly := Not lstDiscType.Enabled;

  edtDiscPerc.ReadOnly := Not lstDiscType.Enabled;
  edtDiscVal.ReadOnly := Not lstDiscType.Enabled;

  edtMarkUp.ReadOnly := Not lstDiscType.Enabled;

  btnSave.Enabled := (FMode In [qmdAdd, qmdEdit]);
  If btnSave.Enabled Then btnCancel.Caption := '&Cancel' Else btnCancel.Caption := '&Close';
end;

{----------------------------------------}

procedure TfrmQtyBreak.btnSaveClick(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  With FQtyBreak Do Begin
    // Copy detail into Discount Interface
    qbQuantityFrom := StrToFloat(edtQtyFrom.Text);
    If (FMode = qmdAdd) Then
      // Can't change To Qty on Qty Break when editing
      qbQuantityTo   := StrToFloat(edtQtyTo.Text);

    qbType        := lstDiscType.ItemIndex;
    qbCurrency    := lstCcy.ItemIndex;
    qbPriceBand   := lstBands.Text;
    qbPrice       := StrToFloat(edtUnitPrice.Text);
    qbDiscPercent := StrToFloat(edtDiscPerc.Text);
    If (qbDiscPercent = 0.0) Then
      qbDiscValue := StrToFloat(edtDiscVal.Text)
    Else
      qbDiscValue := 0.0;
    qbMarkupMarginPercent := StrToFloat(edtMarkup.Text);

    // Save Account Discount
    FuncRes := Save;
    If (FuncRes = 0) Then Begin
      // Close dialog
      FNeedRefresh := True;
      Close;
    End { If (FuncRes = 0) }
    Else
      // Error saving account details
      MessageDlg ('The following error occured saving the Quantity Break Record:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
  End; { With FDiscDetail }
end;

{----------------------------------------}

procedure TfrmQtyBreak.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    qmdAdd  : ; { No Action Required }
    qmdEdit : FQtyBreak.Cancel;
    qmdView : ; { No Action Required }
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

{----------------------------------------}

End.

