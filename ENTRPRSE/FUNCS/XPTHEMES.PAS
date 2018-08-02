unit XPThemes;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Forms, SysUtils, Windows;

// Dynamically loads UXTHEME.DLL to determine if Windows and
// the application are Themed.
Function XP_UsingThemes (Const CheckForManifestFile : Boolean = True) : Boolean;

implementation

// Dynamically loads UXTHEME.DLL to determine if Windows and
// the application are Themed.
Function XP_UsingThemes (Const CheckForManifestFile : Boolean = True) : Boolean;
Type
  ThemeBoolFunc = Function : Boolean; StdCall;
Var
  // Handle for UXTHEME.DLL
  hUXTheme       : THandle;
  hIsThemeActive : ThemeBoolFunc;
  hIsAppThemed   : ThemeBoolFunc;
Begin { XP_UsingThemes }
  Result := False;

  Try
    // Step 1: Try to dynamically load UXTHEME.DLL - this DLL is
    //         only available on Operating Systems supporting Themes.
    hUXTheme := LoadLibrary ('UXTHEME.DLL');
    If (hUXTheme > HInstance_Error) Then
    Begin
      // Step 2: Get Handle to IsThemeActive function to determine if
      //         Themes are being used by Windows, or if the classic
      //         look is being used.
      hIsThemeActive := GetProcAddress (hUXTheme, 'IsThemeActive');
      If hIsThemeActive Then
      Begin
        // Step 3: Get Handle to IsAppThemed function to determine if
        //         the Application has been Themed.
        hIsAppThemed := GetProcAddress (hUXTheme, 'IsAppThemed');
        Result := hIsAppThemed;
      End; { If hIsThemeActive }

      // Unload UXTHEME.DLL
      FreeLibrary (hUXTheme);
    End; { If (hUXTheme > HInstance_Error) }

    If Result And CheckForManifestFile Then
      // Step4: Optional check for the .Manifest file - No .Manifest = No Theme
      Result := FileExists (Application.ExeName + '.Manifest');
  Except
    // Oops - Trap any exception and return false
    On Exception Do
      Result := False;
  End;
End; { XP_UsingThemes }

end.
