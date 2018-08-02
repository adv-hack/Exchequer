unit Crystal;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, SetupU, Registry;

function SCD_FindCrystalDir (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation


// Looks in Windows Registry to determine if Crystal Reports is installed and
// returns it to WISE by setting the V_CRYSTALDIR variable. It looks at the
// following entry in the registry which can be found with Crystal 5..7.
//
//   [HKEY_CLASSES_ROOT\CrystalReports\DefaultIcon]
//   @="D:\\CRW\\CRW32.EXE,1"
//
//  0           AOK
//  1000        Unknown Exception
//
Function SCD_FindCrystalDir (var DLLParams: ParamRec): LongBool;
Var
  DLLStatus    : LongInt;
  EntRegO      : TRegistry;
  DefaultIcon  : ShortString;
Begin { SCD_FindCrystalDir }
  Try
    DLLStatus := 0;   { Unknown Error }
    DefaultIcon := '';

    EntRegO := TRegistry.Create;
    Try
      With EntRegO Do Begin
        Access := KEY_READ;

        // HM 13/01/03: Modified to check for v9.0 registry entries as need to
        // copy files to a different directory
        RootKey := HKEY_LOCAL_MACHINE;
        If KeyExists('SOFTWARE\Crystal Decisions\9.0\Crystal Reports') Then
          If OpenKey('SOFTWARE\Crystal Decisions\9.0\Crystal Reports', False) Then Begin
            If ValueExists('CommonFiles') Then Begin
              DefaultIcon := ReadString ('CommonFiles');
              SetVariable(DLLParams, 'V_CRYSTALDIR', DefaultIcon);
            End; { If KeyExists('CommonFiles') }

            CloseKey;
          End; { If OpenKey('SOFTWARE\Crystal Decisions\9.0\Crystal Reports', False) }

        // Check path is set validly, else continue with old pre-v9.0 test
        If (DefaultIcon = '') Or (Not DirectoryExists(DefaultIcon)) Then Begin
          // Extract the path of the CRW icon from the registry
          RootKey := HKEY_CLASSES_ROOT;

          If KeyExists('CrystalReports\DefaultIcon') Then
            If OpenKey('CrystalReports\DefaultIcon', False) Then Begin
              If KeyExists('') Then Begin
                DefaultIcon := ExtractFilePath(ReadString (''));
                SetVariable(DLLParams, 'V_CRYSTALDIR', DefaultIcon)
              End; { If KeyExists('') }

              CloseKey;
            End; { If OpenKey }
        End; { If (DefaultIcon = '') Or (Not DirectoryExists(DefaultIcon)) }
      End; { With EntRegO }
    Finally
      EntRegO.Free;
    End;
  Except
    On Ex:Exception Do Begin
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_FindCrystalDir }

end.
