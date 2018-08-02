unit ConvertAmountF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise04_TLB, TESTFORMTEMPLATE, StdCtrls;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    FInputValue : Double;
    FExpectedValue : Double;
    FActualValue : Double;
    FRateType : Integer;
    FCurrencyFrom, FCurrencyTo : Integer;
  public
    { Public declarations }
    Procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

uses
  Math;

const
  I_INPUT_VALUE = 0;
  I_EXPECTED_VALUE = 1;

  I_CURRENCY_FROM = 2;
  I_CURRENCY_TO = 3;

  I_RATE_TYPE = 4;




{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.RunTest;
var
  WhichTest : Integer;
begin
  SplitExtraParam;
  FInputValue := StrToFloat(FExtraParamList[I_INPUT_VALUE]);
  FExpectedValue := StrToFloat(FExtraParamList[I_EXPECTED_VALUE]);
  FRateType := StrToInt(FExtraParamList[I_RATE_TYPE]);
  FCurrencyFrom := StrToInt(FExtraParamList[I_CURRENCY_FROM]);
  FCurrencyTo := StrToInt(FExtraParamList[I_CURRENCY_TO]);

  FActualValue := oToolkit.Functions.entConvertAmount(FInputValue, FCurrencyFrom, FCurrencyTo, FRateType);

  if IsZero(Abs(FActualValue) - Abs(FExpectedValue), 0.00000001) then
    FResult := 0
  else
    FResult := 1;
end;

end.
