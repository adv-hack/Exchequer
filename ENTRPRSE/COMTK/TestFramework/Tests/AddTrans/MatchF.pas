unit MatchF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    FDocType : TDocTypes;
    TransO : ITransaction;
    function FindLastPayment : Boolean;
    function AddInvoice : Boolean;
    procedure DoMatch;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

function TfrmTestTemplate1.AddInvoice: Boolean;
begin
  if FExtraParam = 'SRC' then
    FDoctype := dtSIN
  else
    FDocType := dtPIN;

  TransO := oToolkit.Transaction.Add(FDocType);

  with TransO do
  begin

    thAcCode :=  oToolkit.Transaction.thAcCode;

    ImportDefaults;

    thTransDate := oToolkit.Transaction.thTransDate;
    thCurrency := 1; //Base

    with thLines.Add do
    begin
      tlStockCode := '';
      tlDescr := 'Matching Test';
      tlQty := 1;
      ImportDefaults;

      tlVATCode := 'Z';
      tlNetValue := oToolkit.Transaction.thLines[1].tlNetValue;

      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';
      tlGLCode := 54050;
      if Trim(tlLocation) = '' then
        tlLocation := 'AAA';

      Save;
    end;

    FResult := Save(True);

    Result := FResult = 0;

  end; // With TransO

end;

procedure TfrmTestTemplate1.DoMatch;
begin
  With oToolkit.Transaction.thMatching.Add do
  begin
    // Copy details in from SIN
    maDocRef := TransO.thOurRef;
    maDocCurrency := TransO.thCurrency;
    maDocValue := TransO.thTotals[TransTotInCcy];

    TransO := nil;

    // Copy details in from SRC
    maPayRef := oToolkit.Transaction.thOurRef;
    maPayCurrency := oToolkit.Transaction.thCurrency;
    maPayValue := oToolkit.Transaction.thTotals[TransTotInCcy];

    // generate Base Equivalent of matched amount
    maBaseValue := oToolkit.Functions.entConvertAmount(maDocValue, maDocCurrency, 0, 0);

    FResult := Save;
  end;

end;

function TfrmTestTemplate1.FindLastPayment: Boolean;
begin
  with oToolkit.Transaction do
  begin
    Index := thIdxOurRef;
    FResult := GetLessThanOrEqual(FExtraParam + 'ZZZZZZ');
    Result := FResult = 0;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  if FindLastPayment then
    if AddInvoice then
      DoMatch;
end;

end.
