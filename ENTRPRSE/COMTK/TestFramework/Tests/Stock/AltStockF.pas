unit AltStockF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    procedure AddAltCode;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }
const
  I_STOCK_CODE = 0;
  I_AC_CODE = 1;
  I_ALT_CODE = 2;

procedure TfrmTestTemplate1.AddAltCode;
var
  sStockCode : string;
  sAcCode : string;
  sAltCode : string;

  oAlt : IAltStockCode;
begin
  with oToolkit do
  begin
    sStockCode := FExtraParamList[I_STOCK_CODE];
    sAcCode := FExtraParamList[I_AC_CODE];
    sAltCode := FExtraParamList[I_ALT_CODE];

    FResult := Stock.GetEqual(Stock.BuildCodeIndex(sStockCode));
    if FResult = 0 then
    begin
      oAlt := (Stock as IStock2).stAltStockCode.Add;
      Try
        oAlt.ascAltCode := sAltCode;
        oAlt.ascAltDesc := sAltCode + ' Description';
        oAlt.ascAcCode := sAcCode;

        FResult := oAlt.Save;
      Finally
        oAlt := nil;
      End;
    end;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  SplitExtraParam;
  AddAltCode;
end;

end.
