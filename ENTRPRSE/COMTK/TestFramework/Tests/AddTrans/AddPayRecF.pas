unit AddPayRecF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise04_TLB, TestConst, TESTFORMTEMPLATE, StdCtrls;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    procedure ProcessTrans;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.ProcessTrans;
var
  DocType : TDocTypes;
  TransO : ITransaction;
begin
  if FExtraParam <> '' then
  begin
    DocType := StringToDocType(UpperCase(FExtraParam));
    // Create an Add Transaction object for a SRC
    TransO := oToolkit.Transaction.Add(DocType);

    With TransO Do Begin
      // Copy in the standard header fields for this exercise
      thTransDate := '20010801';

      // Account Code
      if DocType in [dtSRC, dtSRI] then
        thAcCode := 'ABAP01'
      else
        thAcCode := 'ACEE02';

      With thLines.Add Do Begin
        // Payment Item
        tlStockCode := 'Payment';

        // Cheque Number
        tlDescr := '101234';

        // Qty
        tlQty := 1;

        // General Ledger Code
        tlGLCode := 2010;

        // Payment Value
        tlNetValue := 54.00;

        // Mark as Payment
        tlPayment := True;

        // Save Line into Transaction
        Save;
      End; // With thLines.Add

      if DocType in [dtPPI, dtSRI] then
      With thLines.Add Do Begin

        // Cheque Number
        tlDescr := 'Payment/Receipt Test';

        // Qty
        tlQty := 1;

        // General Ledger Code
        tlGLCode := 10010;

        // Payment Value
        tlNetValue := 54.00;

        // Mark as Payment
        tlPayment := False;

        tlVATCode := 'Z';

        tlCostCentre := 'AAA';
        tlDepartment := 'AAA';
        tlLocation := 'AAA';

        // Save Line into Transaction
        Save;
      End; // With thLines.Add

      // Save the Transaction - True = auto calculate totals
      FResult := Save(True);
    End; // With TransO

    // Remove reference to Transaction Object to destroy it
    TransO := Nil;

  end
  else
    FResult := E_INVALID_PARAMS;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  ProcessTrans;
end;

end.
 