unit HKSecure;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

// Function to get Security Release Codes
Function hsGetSRC (Const NewFlg  : Byte;
                   Const EntPath : ShortString;
                   Const RecPtr  : Pointer) : LongInt; Register;

implementation

Uses GlobVar, VarConst, HelpSupU, SecureU, LicRec, EntLic, VarRec2U, VarFPosU,
     Secsup2U;

// Function to get Security Release Codes
Function hsGetSRC (Const NewFlg  : Byte;
                   Const EntPath : ShortString;
                   Const RecPtr  : Pointer) : LongInt;
Var
  LicR      : EntLicenceRecType;
  PlugInRec : ^HookSecurityRecType;
  CurSecy   : LongInt;
Begin { hsGetSRC }
  Result := 0;

  ExMainCoPath^ := '';

  If ReadEntLic (EntPath + EntLicFName, LicR) Then Begin
    PlugInRec := RecPtr;
    With PlugInRec^ Do Begin
      // Security Type - 0-System Rel Code, 1=User Count, 2=System + User Count

      { System Release Code - None/30-Day/Full }
      If (NewFlg = 255) Or ((hkSecType = 1) And (NewFlg In [0, 2])) Then Begin
        // New Security Record or Flag changed to include system security
        Sleep (100);
        CurSecy        := Set_Security;
        hkSysSecurity  := Get_ISNSecurity(ISNArrayType(LicR.licISN));
        hkSysRelStatus := 1;      // 30-Day
        hkSysExpiry    := CalcNewRelDate (30);
      End; { If ... }

      { User Count Security }
      If (NewFlg = 255) Or ((hkSecType = 0) And (NewFlg In [1, 2])) Then Begin
        // New Security Record or Flag changed to include user count
        Sleep (100);
        CurSecy      := Set_Security;
        hkUCSecurity := Calc_SecStr(CurSecy, False);
        hkLicUCount  := 1;
        hkCurrUCount := 0;
      End; { If ... }
    End; { With PlugInRec  }
  End { If ReadEntLic ... }
  Else
    Result := 10001;
End; { hsGetSRC }

end.
