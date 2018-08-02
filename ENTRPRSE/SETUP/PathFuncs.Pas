Unit PathFuncs;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Interface

{$IFDEF SETD}
Uses Forms, WiseUtil;

// Adds the path specified in V_ADDPATH to the environment path and updates Windows
Function SCD_AddToPath (var DLLParams: ParamRec): LongBool; StdCall; export;
{$ENDIF}

// Adds the path specified to the environment path and updates Windows
// NOTE: Code requires the app to be running as Administrator under UAC
Procedure UpdateEnvironmentPath (Const NewPath : ShortString);

implementation

Uses Windows, Messages, SysUtils, Registry;

//=========================================================================

{$IFDEF SETD}
// Adds the path specified in V_ADDPATH to the environment path and updates Windows
Function SCD_AddToPath (var DLLParams: ParamRec): LongBool;
Var
  V_AddPath : String;
Begin // SCD_AddToPath
  GetVariable (DLLParams, 'V_ADDPATH', V_AddPath);
  UpdateEnvironmentPath (V_AddPath);
  Result := False;
End; // SCD_AddToPath
{$ENDIF}

//-------------------------------------------------------------------------

// Broadcasts a message to all applications (including Windows) to tell it the PATH has changed
Procedure BroadCastUpdateMessage;
Var
  lParam, wParam : Integer;
  Buf     : Array[0..10] of Char;
  aResult : Cardinal;
Begin // BroadCastUpdateMessage
  Buf := 'Environment';
  wParam := 0;
  lParam := Integer(@Buf[0]);
  SendMessageTimeout (HWND_BROADCAST,
                      WM_SETTINGCHANGE,
                      wParam,
                      lParam,
                      SMTO_NORMAL,
                      4000,
                      aResult);
End; // BroadCastUpdateMessage

//------------------------------

// Adds the path specified to the environment path and updates Windows
// NOTE: Code requires the app to be running as Administrator under UAC
Procedure UpdateEnvironmentPath (Const NewPath : ShortString);
Const
  RegSection = '\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\';
Var
  Reg : TRegistry;
  sEnvPath, sNewPath  : ANSIString;
Begin // UpdateEnvironmentPath
  // Get the current PATH value from the registry
  Reg := TRegistry.Create;
  Try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    If Reg.OpenKey(RegSection, False) Then
    Begin
      If Reg.ValueExists('Path') Then
      Begin
        sEnvPath := Reg.ReadString('Path');

        // Add our new path onto it at the start - if it doesn't already exist
        // in the PATH
        sNewPath := IncludeTrailingPathDelimiter(NewPath) + ';';
        If (Pos(sNewPath, sEnvPath) = 0) Then
        Begin
          // Update the PATH in the registry
          Reg.WriteExpandString('Path', sNewPath + sEnvPath);

          // Post a message to cause Windows/other apps to detect the change
          BroadCastUpdateMessage;
        End // If (Pos(sNewPath, sEnvPath) = 0)
        Else
        Begin
          // MH 03/10/2013 v7.0.6 ABSEXCH-14450: Modified to correct PATH if broken
          If (Reg.GetDataType('Path') <> rdExpandString) Then
          Begin
            // Update the PATH in the registry
            Reg.WriteExpandString('Path', sEnvPath);

            // Post a message to cause Windows/other apps to detect the change
            BroadCastUpdateMessage;
          End; // If (Reg.GetDataType('Path') <> rdExpandString)
        End; // Else
      End; // If Reg.ValueExists('Path')

      Reg.CloseKey;
    End; // If Reg.OpenKey(RegSection, False)
  Finally
    Reg.Free;
  End; // Try..Finally
End; // UpdateEnvironmentPath

//=========================================================================

End.