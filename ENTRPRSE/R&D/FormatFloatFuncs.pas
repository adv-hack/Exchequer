Unit FormatFloatFuncs;

Interface

{$I DEFOVR.INC}

Uses GlobVar;

Const
  BlankIfZero = True;


Function FormatBFloat(Fmask  :  Str255;
                      Value  :  Double;
                      SBlnk  :  Boolean)  :  Str255;

Function FormatCurFloat(Fmask  :  Str255;
                        Value  :  Double;
                        SBlnk  :  Boolean;
                        Cr     :  Byte)  :  Str255;

Implementation

Uses SysUtils,    // FormatFloat
     CurrncyU;    // SSymb

//=========================================================================

Function FormatBFloat(Fmask  :  Str255;
                      Value  :  Double;
                      SBlnk  :  Boolean)  :  Str255;
Begin
  If (Value<>0.0) or (Not SBlnk) then
    Result:=FormatFloat(Fmask,Value)
  else
    Result:='';
end;

//-------------------------------------------------------------------------

Function FormatCurFloat(Fmask  :  Str255;
                        Value  :  Double;
                        SBlnk  :  Boolean;
                        Cr     :  Byte)  :  Str255;
Var
  GenStr  :  Str5;
Begin
  GenStr:='';

  {$IFDEF MC_On}
    GenStr:=SSymb(Cr);
  {$ENDIF}

  If (Value<>0.0) or (Not SBlnk) then
    Result:=GenStr+FormatFloat(Fmask,Value)
  else
    Result:='';
end;

//=========================================================================


End.
