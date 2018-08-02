unit SinAndPinF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, Enterprise04_TLB, StdCtrls;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  protected
    procedure RunTest; override;
    procedure AddSPOPTrans (Const TransType : TDocTypes; Const TransDesc : ShortString);
  public
    { Public declarations }
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddSPOPTrans(const TransType: TDocTypes;
  const TransDesc: ShortString);
var
  TransO : ITransaction8;
  Res    : SmallInt;
begin
  // Create an Add Transaction object for the SPOP Transaction
  TransO := oToolkit.Transaction.Add(TransType) as ITransaction8;

  With TransO Do Begin

    // Customer/Supplier Account Code
    If (thDocType In [dtPOR, dtPIN]) then
      // Supplier Code for Purchase Transactions
      thAcCode :=  'ACEE02'
    Else
      // Customer Code for Sales Transactions
      thAcCode :=  'ABAP01';

    // Bring in defaults for Account:- Ctrl GL, Delivery Addr, Due Date, Settlement Disc, etc...

      thJobCode := 'BATH01';
      thAnalysisCode := 'B-DIRECT';

    ImportDefaults;


    thCurrency := 1; //Base
    with thLines.Add do
    begin
      tlStockCode := 'BAT-1.5D-ALK01';
      tlQty := 10;
      tlGLCode := 77020;
      tlNetValue := 5000;
      ImportDefaults;
      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';
      tlLocation := 'ENG';
      Save;
    end;


    FResult := Save(True);

  End; // With TransO

  // Remove reference to Transaction Object to destroy it
  TransO := Nil;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  AddSpopTrans(dtPIN, 'Test PIN');
  if FResult = 0 then
    AddSpopTrans(dtSIN, 'Test SIN');
end;

end.
 