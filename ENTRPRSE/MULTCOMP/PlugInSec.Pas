unit PlugInSec;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

// MH 08/01/2010: Added function to check on Plug-In Release Code statuses
//
//   0   Not Licenced
//   1   30-Day Licence
//   2   Full Licence
// -ve   Error - panic!
//
Function CheckPlugInLicence (Const PlugInCode : ShortString) : LongInt; StdCall; Export;

implementation

Uses BtrvU2, GlobVar, VarConst, ETStrU, ETDateU, ETMiscU, BtKeys1U, SecWarn2,
     CompUtil, SecureU, BtSupU1, LicRec, WLicFile, HelpSupU, EntLic, SerialU,
     GlobExch, sysU3, VarFPosU, LicFuncU, ConvData, CompId, SecSup2U, LogUtil,
     EnterpriseSecurity_TLB;

//=========================================================================

// MH 08/01/2010: Added function to check on Plug-In Release Code statuses
//
//   0   Not Licenced
//   1   30-Day Licence
//   2   Full Licence
//
//  -1   Invalid Security Type - Release Code type required
//  -2   Unknown Security Type
//
Function CheckPlugInLicence (Const PlugInCode : ShortString) : LongInt;
Var
  LStatus : SmallInt;
  KeyS    : Str255;
  Expire : Boolean;
Begin // CheckPlugInLicence
  Result := -1;

  // Build key string to find security record
  KeyS := cmPlugInSecurity + PlugInCode;
  LStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);
  If (LStatus = 0) Then
  Begin
    If (Company^.PlugInSec.hkSecType In [SecSystemOnly, SecSystemAndUser]) Then
    Begin
      Case Company^.PlugInSec.hkSysRelStatus Of
        SysExpired  : Result := 0; // Not Licenced
        Sys30Day    : Result := 1;  // 30-Day Licence
        SysReleased : Result := 2; // Full Licence
      Else
        Result := -2;  // Unknown Security Type
      End; // Case hkSysRelStatus
    End // If (Company^.PlugInSechkSecType In [SecSystemOnly, SecSystemAndUser])
    Else
      Result := -1;  // Incorrect Security Type
  End // If (Result = 0)
  Else
    // No record found = not licenced
    Result := 0;
End; // CheckPlugInLicence

//=========================================================================

End.