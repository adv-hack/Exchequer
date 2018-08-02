unit GLF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, TEditVal, ExtCtrls;

type
  TfrmGLs = class(TForm)
    Panel1: TPanel;
    ceSales: TCurrencyEdit;
    ceCOS: TCurrencyEdit;
    ceClosing: TCurrencyEdit;
    ceStockVal: TCurrencyEdit;
    ceBOM: TCurrencyEdit;
    ceBank: TCurrencyEdit;
    ceSalesRet: TCurrencyEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cePurchRet: TCurrencyEdit;
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadCodes;
    procedure SaveCodes;
  end;

var
  frmGLs: TfrmGLs;

implementation

{$R *.dfm}
uses
  AddRec;

{ TfrmGLs }

procedure TfrmGLs.LoadCodes;
begin
  ceSales.Value := GLObject.SalesGL;
  ceCOS.Value := GLObject.COSGL;
  ceClosing.Value := GLObject.ClosingGL;
  ceStockVal.Value := GLObject.StockValueGL;
  ceBOM.Value := GLObject.BOMGL;
  ceSalesRet.Value := GLObject.SalesReturnGL;
  cePurchRet.Value := GLObject.PurchReturnGL;
  ceBank.Value := GLObject.BankGL;
end;

procedure TfrmGLs.SaveCodes;
begin
  GLObject.SalesGL := Trunc(ceSales.Value);
  GLObject.COSGL := Trunc(ceCOS.Value);
  GLObject.ClosingGL := Trunc(ceClosing.Value);
  GLObject.StockValueGL := Trunc(ceStockVal.Value);
  GLObject.BOMGL := Trunc(ceBOM.Value);
  GLObject.SalesReturnGL := Trunc(ceSalesRet.Value);
  GLObject.PurchReturnGL := Trunc(cePurchRet.Value);
  GLObject.BankGL := Trunc(ceBank.Value);

end;

end.
