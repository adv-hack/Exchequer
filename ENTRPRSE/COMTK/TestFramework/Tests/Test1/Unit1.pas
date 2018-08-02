unit Unit1;

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
  public
    { Public declarations }
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.RunTest;
var
  Res : integer;
  oTrans : ITransaction;
begin
  with oToolkit.Transaction do
  begin
    oTrans := Add(dtSOR);
    with oTrans do
    begin
      thAcCode := FExtraParam;
      ImportDefaults;
      thTransDate := FormatDateTime('yyyymmdd', Date);

      with thLines.Add do
      begin
        tlStockCode := 'BAT-9PP3-ALK';
        tlQty := 20;
        tlGLCode := 52010;

        tlCostCentre := 'AAA';
        tlDepartment := '#01';
        tlLocation := 'AAA';

        Save;
      end;
    end;

    FResult := oTrans.Save(True);
  end;
end;

end.
