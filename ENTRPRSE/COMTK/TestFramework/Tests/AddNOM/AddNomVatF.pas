unit AddNomVatF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    procedure AddNomInCurrency;
    procedure AddNomInBase;
  protected
    procedure RunTest; override;
  public
    { Public declarations }
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddNomInBase;
var
  TransO : ITransaction2;
  LineO : ITransactionLine2;
  Res    : SmallInt;
begin
  // Create an Add Transaction object for a NOM
  TransO := oToolkit.Transaction.Add(dtNMT) as ITransaction2;

  with TransO do
  begin
    ImportDefaults;

    thTransDate := '20110701';
    thTotalVAT := -20;
    thNetValue := 20;

    with TransO.thAsNOM as ITransactionAsNom2 do
      tnVATIO := vioOutput;

    // Line 1 - Debit Line
    with thLines.Add do begin
      // Description
      tlDescr := 'Debit';

      // GL Code
      tlGLCode := 77020;

      tlCurrency := 1;
      tlDailyRate := 1;
      tlCompanyRate := 1;

      tlNetValue := 120;

      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';

      // Save Line into Transaction
      Save;
    end; // With thLines.Add

    // Line 2 - Credit Line
    LineO := thLines.Add as ITransactionLine2;
    with LineO.tlAsNOM as ITransactionLineAsNom2 do
      tlnNomVATType := nlvAuto;

    with LineO do
    begin
      // Description
      tlDescr := 'Credit';

      // GL Code
      tlGLCode := 2010;
      tlStockCode := 'PayRef27';

      tlDailyRate := 1;
      tlCompanyRate := 1;

      tlCurrency := 1;
      tlNetValue := -100;

      tlVatCode := 'S';
      tlVatAmount := -20;

      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';

      // Save Line into Transaction
      Save;
    end; // With thLines.Add

    // Save the Transaction - True = auto calculate totals
    FResult := Save(True);
  end; // With TransO

  // Remove reference to Transaction Object to destroy it
  TransO := Nil;
  LineO := nil;
end;

procedure TfrmTestTemplate1.AddNomInCurrency;
var
  TransO : ITransaction2;
  LineO : ITransactionLine2;
  Res    : SmallInt;
begin
  // Create an Add Transaction object for a NOM
  TransO := oToolkit.Transaction.Add(dtNMT) as ITransaction2;

  with TransO do
  begin
    ImportDefaults;

    thTransDate := '20110701';
    thTotalVAT := 30.17;
    thNetValue := -30.17;

    with TransO.thAsNOM as ITransactionAsNom2 do
      tnVATIO := vioOutput;

    // Line 1 - Debit Line
    LineO := thLines.Add as ITransactionLine2;
    with LineO.tlAsNOM as ITransactionLineAsNom2 do
      tlnNomVATType := nlvAuto;

    with LineO do
    begin
      // Description
      tlDescr := 'Debit';

      // GL Code
      tlGLCode := 77020;

      tlCurrency := 4;
      tlDailyRate := 2.9;
      tlCompanyRate := 2.9;

      tlNetValue := 500;

      tlVatCode := 'S';
      tlVatAmount := 87.5;


      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';

      // Save Line into Transaction
      Save;
    end; // With thLines.Add

    // Line 2 - Credit Line
      // Description
    with thLines.Add do begin
      tlDescr := 'Credit';

      // GL Code
      tlGLCode := 2015;
      tlStockCode := 'PayRef27';

      tlCurrency := 2;
      tlDailyRate := 0.71;
      tlCompanyRate := 0.71;

      tlNetValue := -285.32;


      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';

      // Save Line into Transaction
      Save;
    end; // With thLines.Add

    // Save the Transaction - True = auto calculate totals
    FResult := Save(True);
  end; // With TransO

  // Remove reference to Transaction Object to destroy it
  TransO := Nil;
  LineO := nil;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  if UpperCase(Copy(FExtraParam, 1, 1)) = 'C' then
    AddNomInCurrency
  else
    AddNomInBase;
end;

end.
