unit AddDescLinesF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise04_TLB, TESTFORMTEMPLATE, StdCtrls;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.RunTest;
var
  oTrans : ITransaction;
  oLine : ITransactionLine3;
begin
  oTrans := oToolkit.Transaction.Add(dtSOR);
  Try
    oTrans.thAcCode := 'BEST01';
    oTrans.thTransDate := '20111201';
    oTrans.ImportDefaults;
    oLine := oTrans.thLines.Add as ITransactionLine3;
    oLine.tlStockCode := 'SIGN-24HR-CCTV';
    oLine.tlLocation := 'AAA';
    oLine.tlQty := 5;
    oLine.ImportDefaults;
    oLine.Save;

    oLine := oTrans.thLines.Add as ITransactionLine3;
    oLine.tlStockCode := 'BAT-1.5C-ALK';
    oLine.tlLocation := 'AAA';
    oLine.tlQty := 1;
    oLine.ImportDefaults;
    oLine.Save;

    oLine := oTrans.thLines[1] as ITransactionLine3;
    oLine.AddDescriptionLines;


    FResult := oTrans.Save(True);
  Finally
    oTrans := nil;
    oLine := nil;
  End;

end;

end.
 