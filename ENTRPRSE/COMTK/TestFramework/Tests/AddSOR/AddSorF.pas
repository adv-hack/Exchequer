unit AddSorF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  protected
    procedure RunTest; override;
    procedure AddSOR;
  public
    { Public declarations }
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddSOR;
var
  TransO : ITransaction;
  Res    : SmallInt;
  DocType : TDocTypes;
begin
  if UpperCase(FExtraParam) = 'POR' then
    DocType := dtPOR
  else
    DocType := dtSOR;
  // Create an Add Transaction object for the SPOP Transaction
  TransO := oToolkit.Transaction.Add(DocType) as ITransaction8;

  With TransO Do Begin

    // Customer/Supplier Account Code
      if DocType = dtPOR then
        thAcCode := 'ACEE02'
      else
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
      tlQtyPicked := 10;
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
  AddSOR;
end;

end.
 