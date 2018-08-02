unit TimeSheetF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    FCurrency : Boolean;
  public
    { Public declarations }
    procedure RunTest; override;
    procedure AddTSH;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddTSH;
var
  TransO : ITransaction;
begin
  if (ParamCount > 0) and (UpperCase(ParamStr(1)) = 'CURRENCY') then
    FCurrency := True
  else
    FCurrency := False;

  // Create an Add Transaction object for a TSH
  TransO := oToolkit.Transaction.Add(dtTSH);

  With TransO Do Begin
    // Copy in the standard header fields for this exercise
    thTransDate := '20110701';

    // Employee Code
    thEmployeeCode := 'JIMF01';

    // Week/Month Reference
    thSettleDiscDays := 20;
    thCurrency := 1;

    // Bring in any timesheet defaults
    ImportDefaults;

    // Add detail line
    With thLines.Add Do Begin
      // Job Details
      tlJobCode := 'PAV';

      // Employee Rate Code & Rate Code currency
      tlStockCode := 'ELEC-DOUB';
      ImportDefaults;

      if FCurrency then
      begin
        tlCurrency := 7;
        tlChargeCurrency := 1;

        tlDailyRate := 2;
        tlCompanyRate := 1.62;
      end;

      // Description
      tlDescr := 'Test';

      // Hours
      tlQty := 10;

      // Bring in defaults from Employee and Time Rate:- Anal, Cost, Charge Ccy, Charge, CC, Dept, ...


      // Save Line into Transaction
      Save;
    End; // With thLines.Add

    // Save the Transaction - True = auto calculate totals
    FResult := Save(True);
  End; // With TransO

  // Remove reference to Transaction Object to destroy it
  TransO := Nil;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  AddTSH;
end;

end.
