unit ClcTestF;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    edtAccCode: TEdit;
    edtStockCode: TEdit;
    btnCalculate: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edtQuantity: TEdit;
    Label4: TLabel;
    edtCost: TEdit;
    Label5: TLabel;
    btnFixedCalc: TButton;
    Button2: TButton;
    Publisher: TLabel;
    Label6: TLabel;
    edtPublisher: TEdit;
    edtCompanyCode: TEdit;
    btnOverwritePrice: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnCalculateClick(Sender: TObject);
    procedure btnFixedCalcClick(Sender: TObject);
    procedure edtAccCodeExit(Sender: TObject);
    procedure edtStockCodeExit(Sender: TObject);
    procedure edtPublisherExit(Sender: TObject);
    procedure edtCompanyCodeExit(Sender: TObject);
    procedure btnOverwritePriceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  CalcWrap, Dllsk01U, InitDLLU;

{$R *.DFM}

{$I Exchdll.inc}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ReadCalcCostIni('C:\EBiz');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i : integer;
begin
  if assigned(lstPriceInfoLocn) then
    for i := 0 to lstPriceInfoLocn.Count -1 do
      Memo1.Lines.Add(lstPriceInfoLocn.Strings[i] + '    ' +
        PStr255(lstPriceInfoLocn.Objects[i])^)
  else
    ShowMessage('The data list has not been initialised');
end;

procedure TForm1.btnCalculateClick(Sender: TObject);
var
  Result : integer;
  Acc,
  Stock,
  Pub    : array[0..255] of char;
  Comp   : char;
  Cost : double;
  Res : integer;
begin
  edtCost.Text := '';
  StrPCopy(Acc, edtAccCode.Text);
  StrPCopy(Stock, edtStockCode.Text);
  StrPCopy(Pub, edtPublisher.Text);
  Comp := edtCompanyCode.Text[1];
  // Currency code hard coded to 0
  Res := CalculatePrice(Acc, Stock, Pub, Comp, 0, StrToFloat(edtQuantity.Text), Cost);
  ShowMessage('Call to CalculatePrice = ' + IntToStr(Res));
  edtCost.Text := FloatToStr(Cost);
end;

procedure TForm1.btnFixedCalcClick(Sender: TObject);
var
  PriceInfo : ^TBatchStkPriceRec;
  Result : integer;
begin
  edtCost.Text := '';
  Result := Ex_InitDLL;
  ShowMessage('Ex_InitDLL = ' + IntToStr(Result));
  new(PriceInfo);
  with PriceInfo^ do
  begin
    CustCode := edtAccCode.Text;
    // CustCode := 'AMBE01';
    StockCode := edtStockCode.Text;
    // StockCode := 'DRV/SCSI/500MB';
    Currency := 1;
    Qty := 1;
    Result := Ex_CalcStockPrice(PriceInfo, SizeOf(PriceInfo^));
    ShowMessage('Ex_CalcStockPrice = '+IntToStr(Result));
    edtCost.Text := FloatToStr(Price);
  end;
  dispose(PriceInfo);
  Result := Ex_CloseDLL;
  ShowMessage('Ex_CloseDLL = ' + IntToStr(Result));
end;

procedure TForm1.edtAccCodeExit(Sender: TObject);
begin
  edtAccCode.Text := UpperCase(edtAccCode.Text);
end;

procedure TForm1.edtStockCodeExit(Sender: TObject);
begin
  edtStockCode.Text := UpperCase(edtStockCode.Text);
end;

procedure TForm1.edtPublisherExit(Sender: TObject);
begin
  edtPublisher.Text := UpperCase(edtPublisher.Text);
end;

procedure TForm1.edtCompanyCodeExit(Sender: TObject);
begin
  edtCompanyCode.Text := UpperCase(edtCompanyCode.Text);
end;

procedure TForm1.btnOverwritePriceClick(Sender: TObject);
begin
  ShowMessage(IntToStr(ProcessPriceUpdate('c:\EBiz\Export')));
end;

end.
