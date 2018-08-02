unit AddAdjF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    procedure AddADJ;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddADJ;
var
  TransO : ITransaction3;
  Res    : SmallInt;
  iSign : Integer;
  oLine : ITransactionLine3;
begin
  ReadParams;
  if UpperCase(FExtraParam) = 'OUT' then
    iSign := -1
  else
    iSign := 1;

  // Create an Add Transaction object for an ADJ
  TransO := oToolkit.Transaction.Add(dtADJ) as ITransaction3;

  With TransO as ITransaction3 Do
  Begin
    // Copy in the standard header fields for this exercise

    // Bring in any ADJ defaults
    ImportDefaults;

    thCompanyRate := 1;
    thDailyRate := 1;

    oLine := thLines.Add as ITransactionLine3;
    With oLine Do Begin
      // Stock Item
      if FExtraParam = 'BUILD' then
      begin
        tlStockCode := 'CAMERAKIT-ALL';
        tlBOMKitLink := 1; //Build
        tlQty := 1;
      end
      else
      begin
        tlStockCode := 'BAT-1.5AA-ALK';
        tlQty := 1000 * iSign;
      end;

      tlJobCode := 'BATH01';
      tlAnalysisCode := 'B-MATERIAL';

      // Bring in any ADJ defaults - Line Desc, GL Code, Cost, Loc, CC, Dept, etc...
      ImportDefaults;

      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';
      tlLocation := 'ENG';

      if iSign = 1 then
        tlCost := 3.25;
      tlQtyMul := 1;

      Save;
    End;


    // Save the Transaction - True = auto calculate totals
    FResult := Save(True);
  end;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  AddAdj;
end;

end.
 