unit SysCode;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses GlobVar, VarConst, LicRec, Base34;

// SysCode Format
//
//  AA-BB-CC-DDEEFFGG-
//
//  AA - licLicType + licType + licCountry
//  BB - licentCVer + licEntModVer + licEntClSvr
//  CC - User Count
//  DD - Module Status - MC + JC + RepWrt
//  EE - Module Status - DLL + TeleS + AccStkAnal
//  FF - Module Status - 7 + 8 + 9
//  GG - Module Status - 10 + 11 + 12

{ Generates a alphanumeric code to describe the system }
Function GenSysCode (Const TempLicR : EntLicenceRecType) : ShortString;


implementation

Uses HelpSupU;

{ Generates a alphanumeric code to describe the system }
Function GenSysCode (Const TempLicR : EntLicenceRecType) : ShortString;
Var
  B34Str : ShortString;
  SI     : SmallInt;

  Function ModRelByte(N : SmallInt) : Byte;
  Var
    RM : Byte;
  Begin { ModRelByte }
    RM:=ModRelMode(N);

    If (Not Check_RelDateExp(N,BOff)) then
      { 30-Day }
      Result := 1
    Else
      Case RM of
        1  :  Result := 2;
      Else
        Result := 0;
      End; { Case }
  End; { ModRelByte }

Begin  { GenSysCode }
  With TempLicR Do Begin
    { AA - licLicType + licType + licCountry }
    SI := licLicType + (10 * licType) + (100 * licCountry);
    Encode34I (SI, B34Str);
    Result := B34Str + '-';

    { BB - licEntCVer + licEntModVer + licEntClSvr }
    SI := licEntCVer + (10 * licEntModVer) + (100 * licEntClSvr);
    Encode34I (SI, B34Str);
    Result := Result + B34Str + '-';

    { CC - User Count }
    SI := licUserCnt;
    Encode34I (SI, B34Str);
    Result := Result + B34Str + '-';
  End; { With TempLicR }

  With SyssMod^, ModuleRel Do Begin
    { DD  - Module Status - MC + JC + RepWrt }
    SI := ModRelByte(1) + (10 * ModRelByte(2)) + (100 * ModRelByte(3));
    Encode34I (SI, B34Str);
    Result := Result + B34Str;

    { EE  - Module Status - DLL + TeleS + AccStkAnal }
    SI := ModRelByte(4) + (10 * ModRelByte(5)) + (100 * ModRelByte(6));
    Encode34I (SI, B34Str);
    Result := Result + B34Str;

    { FF  - Module Status - 7 + 8 + 9 }
    SI := ModRelByte(7) + (10 * ModRelByte(8)) + (100 * ModRelByte(9));
    Encode34I (SI, B34Str);
    Result := Result + B34Str;

    { GG  - Module Status - 10 + 11 + 12 }
    SI := ModRelByte(10) + (10 * ModRelByte(11)) + (100 * ModRelByte(12));
    Encode34I (SI, B34Str);
    Result := Result + B34Str;
  End; { With SyssMod^, ModuleRel }
End; { GenSysCode }

end.
