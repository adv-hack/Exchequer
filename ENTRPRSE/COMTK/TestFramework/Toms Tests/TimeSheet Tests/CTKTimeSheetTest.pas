unit CTKTimeSheetTest;

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
end;

procedure TfrmTestTemplate1.RunTest;
var
  tran : ITransaction;
  searchKey : shortstring;
begin
   with oToolkit.Customer do
   begin
    tran := oToolkit.Transaction.Add(dtTSH);

     With tran do
     Begin
      thEmployeeCode := 'JIMF01';
      thSettleDiscDays := 20;

      ImportDefaults;

       With thLines.Add Do Begin
        tlJobCode := 'TAI-IN1';
        tlAnalysisCode := 'B-Direct';
        tlStockCode := 'GENERAL';
        tlCurrency := 1;

        tlDescr := 'Toolkit';
        tlQty := 40;
        //30126
        Save;
       End;

       fResult := Save(true);
     end;
   end;
end;
end.
