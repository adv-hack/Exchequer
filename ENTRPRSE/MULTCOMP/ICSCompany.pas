// Utility functions for the ICSCOMP.EXE installer which installs a blank company for the
// IRIS Client-Synch utility
unit ICSCompany;

interface

Uses Classes, Dialogs, Forms, IniFiles, SysUtils,
     {$IFDEF COMP} WiseUtil, {$ENDIF}
     Windows;

// Extracts the command line parameters and returns them to the WISE script
function icsGetCommandLineParams(var DLLParams: ParamRec): LongBool; StdCall; export;

// Sends a Success message to the form identified by the V_WINHANDLE window handle
function icsSendInfoMsg(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

Uses Messages;

//=========================================================================

// Extracts the command line parameters and returns them to the WISE script
function icsGetCommandLineParams(var DLLParams: ParamRec): LongBool;
Var
  sCompCode, sCompName, sCompDir, sHandle, sParam : ShortString;
  iParam : SmallInt;

  // Extracts a nominated command line parameter from the command line
  //
  // Example = /DVDM /CODE="AAAA01" /NAME="Aardvaarks Are us" /INSTDIR="c:\program files\companyies\aaaa01" /HWND="102293"
  //
  Function ExtractParameter(Const ParamName : ShortString; Params : ShortString) : ShortString;
  Var
    sTemp  : ShortString;
    iIndex : SmallInt;
  Begin // ExtractParameter
    Result := '';

    // Search for the parameter
    iIndex := Pos('/' + UpperCase(ParamName) + '="', UpperCase(Params));
    If (iIndex > 0) Then
    Begin
      // Found parameter - make a local copy of the string from the end of the parameter name to
      // the end of the command line parameters - the first " in the string then indicates the
      // end of that parameter
      sTemp := Copy(Params, iIndex + Length(ParamName) + 3, 255);
      iIndex := Pos('"', sTemp);
      If (iIndex > 1) Then Result := Copy(sTemp, 1, iIndex - 1);
    End; // If (iIndex > 0)
  End; // ExtractParameter

Begin // icsGetCommandLineParams
  Result := False;  // Fail the install as default

  If (ParamCount > 0) Then
  Begin
    sCompCode := '';
    sCompName := '';
    sCompDir := '';

    // Check for /DVDM security parameter to stop unauthorised usage
    If FindCmdLineSwitch('DVDM', ['/'], True) Then
    Begin
      // Get full list of parameters and remove the path and exe name and then extract the
      // individual parameters
      sParam := Trim(CmdLine);
      iParam := Pos('.EXE ', sParam);
      Delete(sParam, 1, iParam+4);

      sCompCode := ExtractParameter('CODE', sParam);
      sCompName := ExtractParameter('NAME', sParam);
      sCompDir := ExtractParameter('INSTDIR', sParam);
      sHandle := ExtractParameter('HWND', sParam);

      If (sCompCode <> '') And (sCompName <> '') And (sCompDir <> '') And (sHandle <> '') Then
      Begin
        Result := True;

        // Update WISE Script with parameters
        SetVariable(DLLParams, 'V_COMPCODE', sCompCode);
        SetVariable(DLLParams, 'V_COMPNAME', sCompName);
        SetVariable(DLLParams, 'V_COMPDIR', sCompDir);
        SetVariable(DLLParams, 'V_WINHANDLE', sHandle);
      End; // If (sCompCode <> '') And (sCompName <> '') And (sCompDir <> '') And (sHandle <> '')
    End; //  If FindCmdLineSwitch('DVDM', ['/'], True)
  End; // If (ParamCount > 0)
End; // icsGetCommandLineParams

//=========================================================================

// Sends a Success message to the form identified by the V_WINHANDLE window handle
function icsSendInfoMsg(var DLLParams: ParamRec): LongBool;
Var
  W_Hwnd, W_Error : String;
  WParam, LParam, WinHandle : LongInt;
Begin // icsSendInfoMsg
  // Get the message type from the parameters:-
  //
  //   1  Error in SCD_GenRootLocFiles
  //   2  Error in SCD_EntCopyMainSecurity
  //   3  Error in SCD_EntCompanyWizard
  //   4  Success
  WParam := StrToIntDef(DLLParams.szParam, 0);
  If (WParam In [1..4]) Then
  Begin
    LParam := 0;

    If (WParam In [1..3]) Then
    Begin
      // Get Error Code
      GetVariable(DLLParams, 'V_DLLERROR', W_Error);
      LParam := StrToIntDef(W_Error, 0);
    End; // If (WParam In [1..3])

    // Get the hWnd in string form from the WISE Script and convert it into a longint
    // so we can send a message to it
    GetVariable(DLLParams, 'V_WINHANDLE', W_Hwnd);
    WinHandle := StrToIntDef(W_Hwnd, 0);
    If (WinHandle <> 0) Then
    Begin
      PostMessage (WinHandle, WM_USER + 1, WParam, LParam);
    End; // If (WinHandle <> 0) end
  End; // If (WParam In [1..4])

  Result := False;
End; // icsSendInfoMsg

//=========================================================================

end.
