unit uRelCode;

interface

uses
  SecSup2U, GlobVar, VarRec2U, Controls;

type
  TRelCode = class
  private
    fSecDate: TDate;
  public
    function GetCode(ESN: string): string;
    property SecDate: TDate read fSecDate write fSecDate;
  end;

implementation

uses SysUtils;

//*** TRelCode *****************************************************************

function TRelCode.GetCode(ESN: string): string;
var
ISNArray: ISNArrayType;
CharIndex, TestInt: integer;
begin
  for CharIndex:= 0 to 6 do
  begin
    TestInt:= StrToIntDef(Copy(ESN, Succ(CharIndex * 3), Succ(Succ(CharIndex) * 3)), -1);
    if TestInt <> -1 then ISNArray[CharIndex]:= TestInt;
  end;

  Result:= Generate_ESN_BaseSecurity(ISNArray, 248, 0, 0);
end;

//******************************************************************************

end.
