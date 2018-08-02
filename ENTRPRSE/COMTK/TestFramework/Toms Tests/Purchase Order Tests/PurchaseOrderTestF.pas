unit PurchaseOrderTestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb, strutils;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RunTest; override;
    procedure ChangeToolkitSettings; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation
uses
 AddPurchaseOrder;

{$R *.dfm}
procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin
 oToolkit.Configuration.OverwriteTransactionNumbers := true;
end;

procedure TfrmTestTemplate1.RunTest;
var
  fAddPurchaseQuote : TAddPurchaseQuote;
  param : longint;
begin
   SplitExtraParam;
   param := StrToInt(FExtraParamList[0]);
   fAddPurchaseQuote := GetPurchaseQuoteObject;
   fResult := -1;
   {Ignored Errors:}

   if(Assigned(fAddPurchaseQuote)) then
   begin
     try
       fAddPurchaseQuote.toolkit := oToolkit;
       fAddPurchaseQuote.ExpectedResult := param;

       case fAddPurchaseQuote.ExpectedResult of
         0 : fResult := fAddPurchaseQuote.SavePurchaseQuote;
         1 : fResult := fAddPurchaseQuote.CopyTransaction;
         2 : fResult := fAddPurchaseQuote.ConvertToOrder;
         3 : fResult := fAddPurchaseQuote.ConvertToInvoice;
       end;
     finally
       fAddPurchaseQuote.Free;
       ShowMessage(IntToStr(fResult));
     end;
   end
   else
     fResult := -1;
end;
end.
