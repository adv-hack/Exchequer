unit SalesTestF;

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
 AddSales;

{$R *.dfm}
procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin
 oToolkit.Configuration.OverwriteTransactionNumbers := true;
end;

procedure TfrmTestTemplate1.RunTest;
var
  fAddSalesQuote : TAddSalesQuote;
  param : longint;
begin
   SplitExtraParam;
   param := StrToInt(FExtraParamList[0]);
   fAddSalesQuote := GetSalesQuoteObject;
   fResult := -1;
   {Ignored Errors:}

   if(Assigned(fAddSalesQuote)) then
   begin
     try
       fAddSalesQuote.toolkit := oToolkit;
       fAddSalesQuote.ExpectedResult := param;

       case fAddSalesQuote.ExpectedResult of
         0 : fResult := fAddSalesQuote.SaveSalesQuote;
         1 : fResult := fAddSalesQuote.CopyTransaction;
         2 : fResult := fAddSalesQuote.ConvertToOrder;
         3 : fResult := fAddSalesQuote.ConvertToInvoice;
       end;
     finally
       fAddSalesQuote.Free;
     end;
   end
   else
     fResult := -1;
end;
end.
