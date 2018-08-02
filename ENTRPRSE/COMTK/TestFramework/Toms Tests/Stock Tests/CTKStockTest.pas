unit CTKStockTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb;

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
 strUtils;
{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin
  case StrToInt(FExtraParam) of
    30006 : oToolkit.Configuration.DefaultNominalCode := 2;
    30274 : oToolkit.Configuration.DefaultVATCode := 'H';
    30294 : oToolkit.Configuration.DefaultVATCode := 'I';
  end;
end;

procedure TfrmTestTemplate1.RunTest;
var
  stockItem : IStock4;
  searchKey : shortstring;
  funcRes : longint;
begin
   with oToolkit.Stock do
   begin
        Index := acIdxCode;
        searchKey := BuildCodeIndex('BAT-1.5D-ALK01');
        funcRes := GetEqual(searchKey);


      {stBalSheetGL  Stock Value(2201)
       stCOSGL       Cost of Sales(62010)
       stPAndLGL     Closing Stk/Write Offs(76060)
       stSalesGL     Sales(52010)
       stWIPGL       BOM/Finished Goods(2201)}

      {Ignored Errors 30274, 30293, 30294, 30297}

       if(funcRes = 0) or (StrToInt(FExtraParam) = 30272) then
       begin
        if(StrToInt(FExtraParam) = 30272) or (StrToInt(FExtraParam) = 30273)
          or (StrToInt(FExtraParam) = 5) then
         stockItem := Add as IStock4
        else
         stockItem := Update as IStock4;

          if(Assigned(stockItem)) then
          begin
               with stockItem do
               begin
                  case StrToInt(FExtraParam) of
                         5 : stCode := 'BAT-1.5D-ALK01';
                     30270 : stParentCode := 'NotAParent';
                     30271 : stType := 4;
                     30272 : stType := 1;
                     30273 : begin
                              stCode := 'STO-CKC-ODE1';
                              stBalSheetGL := 2201;
                              stCosGL := 62010;
                              stPAndLGL := 76060;
                              stSalesGL := 52010;
                              stWIPGL := 2201;
                              stSalesReturnGL := 2271;
                              stPurchaseReturnGL := 2272;

                              stParentCode := 'NotAParent';
                             end;
                     30274 : stVATCode := 'H';
                     30275 : stSupplier := 'NotASupplier';
                     302801 : begin
                               stBalSheetGL := -1;
                               stCosGL := 62010;
                               stPAndLGL := 76060;
                               stSalesGL := 52010;
                               stWIPGL := 2201;
                              end;
                     302802 : begin
                               stBalSheetGL := 2201;
                               stCosGL := -1;
                               stPAndLGL := 76060;
                               stSalesGL := 52010;
                               stWIPGL := 2201;
                              end;
                     302803 : begin
                               stBalSheetGL := 2201;
                               stCosGL := 62010;
                               stPAndLGL := -1;
                               stSalesGL := 52010;
                               stWIPGL := 2201;
                              end;
                     302804 : begin
                               stBalSheetGL := 2201;
                               stCosGL := 62010;
                               stPAndLGL := 76060;
                               stSalesGL := -1;
                               stWIPGL := 2201;
                              end;
                     302805 : begin
                               stBalSheetGL := 2201;
                               stCosGL := 62010;
                               stPAndLGL := 76060;
                               stSalesGL := 52010;
                               stWIPGL := -1;
                              end;
                     30287 : stCostCentre := 'NotACostCenter';
                     30288 : stDepartment := 'NotADepartment';
                     30291 : stLocation := 'NotALocation';
                     30293 : stDepartment := 'fixme';
                     30294 : stInclusiveVATCode := 'M';
                     30295 : stAnalysisCode := 'NotAnAnalysisCode';
                     30296 : stDepartment := 'fixme';
                     30297 : stWOPIssuedWIPGL := 9999;

                     30298 : stSalesReturnGL := 1337;
                     30299 : stPurchaseReturnGL := 1337;
                  end;

                 fResult := stockItem.Save;
               end;
          end;
       end;
   end;
end;
end.
