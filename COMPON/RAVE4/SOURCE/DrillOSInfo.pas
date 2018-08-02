unit DrillOSInfo;

interface

Uses SysUtils, Windows;

Type
  TOSVersion = (osv31,   osv95,  osv98,
                osvME,   osvNT3, osvNT4,
                osv2000, osvXP,  osvNTOther,
                osvUnknown);

  //------------------------------

  TDrillOSInfo = Class(TObject)
  Private
    FOSVersion : TOSVersion;
  Public
    Property OSVersion : TOsVersion read FOSVersion;

    Constructor Create;
  End; { TDrillOSInfo }

  //------------------------------

Function OSInfo : TDrillOSInfo;


implementation

Var
  lOSInfo : TDrillOSInfo;

//=========================================================================

Function OSInfo : TDrillOSInfo;
Begin { OSInfo }
  If (Not Assigned(lOSInfo)) Then
    lOSInfo := TDrillOSInfo.Create;

  Result := lOSInfo;
End; { OSInfo }

//=========================================================================

Constructor TDrillOSInfo.Create;
var
  OSVerIRec : TOSVersionInfo;
Begin { Create }
  Inherited;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);
  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);
  GetVersionEx(OSVerIRec);

  case OSVerIRec.dwPlatformId of
    VER_PLATFORM_WIN32s        : FOSVersion := osv31;

    VER_PLATFORM_WIN32_WINDOWS : Case OSVerIRec.dwMinorVersion of
                                   0  : FOSVersion := osv95;
                                   10 : FOSVersion := osv98;
                                   90 : FOSVersion := osvME;
                                 End;{ Case OSVerIRec.dwMinorVersion }

    VER_PLATFORM_WIN32_NT      : Begin
                                   // NT Based
                                   FOSVersion := osvNTOther;

                                   // Check major/minor versions to try to identify it further
                                   Case OSVerIRec.dwMajorVersion of
                                     3 : FOSVersion := osvNT3;
                                     4 : FOSVersion := osvNT4;
                                     5 : Case OSVerIRec.dwMinorVersion Of
                                           0 : FOSVersion := osv2000;
                                           1 : FOSVersion := osvXP;
                                         End; { Case OSVerIRec.dwMinorVersion }
                                   End; { case OSVerIRec.dwMajorVersion }
                                 End;
  Else
    // Unknown Platform
    FOSVersion := osvUnknown;
  End; { case OSVerIRec.dwPlatformId }
End; { Create }

//=========================================================================

Initialization
  lOSInfo := NIL;
Finalization
  FreeAndNIL(lOSInfo);
end.
