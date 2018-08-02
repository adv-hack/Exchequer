unit AddStockF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    function FindExampleProduct : Boolean;
    procedure AddStockRec;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddStockRec;
var
  oStock : IStock4;
begin
  oStock := oToolkit.Stock.Add as IStock4;

  oStock.stCode := 'ZZZZ01';
  oStock.stType := stTypeProduct;
  oStock.stDesc[1] := 'Test Stock Item';
  oStock.stDesc[2] := 'Line 2';

  oStock.stBalSheetGL := oToolkit.Stock.stBalSheetGL;
  oStock.stCosGL := oToolkit.Stock.stCosGL;
  oStock.stPAndLGL := oToolkit.Stock.stPAndLGL;
  oStock.stPurchaseReturnGL := (oToolkit.Stock as IStock4).stPurchaseReturnGL;
  oStock.stSalesGL := oToolkit.Stock.stSalesGL;
  oStock.stSalesReturnGL := (oToolkit.Stock as IStock4).stSalesReturnGL;
  oStock.stWIPGL := oToolkit.Stock.stWIPGL;

  FResult := oStock.Save;
end;

function TfrmTestTemplate1.FindExampleProduct: Boolean;
//Find the first product in the stock list to use as a template for GL Codes, etc.
var
  Res : Integer;
begin
  with oToolkit.Stock do
  begin
    Res := GetFirst;
    while (Res = 0) and (stType <> stTypeProduct) do
      GetNext;

    Result := Res = 0;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  FResult := -1;
  if FindExampleProduct then
    AddStockRec;
end;

end.
