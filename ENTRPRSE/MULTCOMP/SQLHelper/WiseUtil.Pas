unit WiseUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

{$IFNDEF WIN32}
  Please note that this module is 32-bit only
{$ENDIF}

{$IFNDEF SQLHELPER}
  This unit should only be used by SQLHelpr.Exe as it redefines standard Wise API calls to use the memory map
{$ENDIF}

Uses SysUtils, Windows, Dialogs;

type
  { 32-Bit - Delphi 2.0 -> }
  ParamRec = record
     wStructLen: DWORD;    { The length of the structure }
     hMainWnd: HWND;       { Handle to main window }
     wMaxReplaces: DWORD;  { Maximum number of replaces }
     wRepNameWidth: DWORD; { The width of a replace name }
     wRepStrWidth: DWORD;  { The width of each replace string }
     wCurrReps: DWORD;     { Current number of replace strings }
     szRepName: PChar;     { The actual replace names }
     szRepStr: PChar;      { The actual replace values }
     wRunMode: DWORD;      { The installation mode }
     fLogFile: DWORD;      { A file handle to the log file }
     szParam: PChar;       { String parameter from Wise Installation System }
  end;

  // Retrieves a string variable from a WISE script
  Procedure GetVariable (Var   DLLParams : ParamRec;
                         Const VarName   : String;
                         Var   VarValue  : String); Export;

  // Sets a string variable in a WISE script
  Procedure SetVariable (Var   DLLParams : ParamRec;
                         Const VarName   : String;
                         Const NewValue  : String); Export;

Var
  DummyParams : ParamRec;

implementation

Uses SQLH_MemMap;

//----------------------------------------------------------------------------

// Retrieves a string variable from a WISE script
Procedure GetVariable (Var   DLLParams : ParamRec;
                       Const VarName   : String;
                       Var   VarValue  : String); Export;
Var
  Idx : LongInt;
Begin { GetVariable }
  Idx := GlobalSetupMap.IndexOf(VarName);
  If (Idx > 0) Then
  Begin
    VarValue := GlobalSetupMap.Variables[Idx].vdValue;
  End // If (Idx > 0)
  Else
  Begin
    ShowMessage ('SQLHelpr.WiseUtil.GetVariable: Variable ' + VarName + ' not found');
    VarValue := '';
  End; // Else
End; { GetVariable }

//----------------------------------------------------------------------------

// Sets a string variable in a WISE script
Procedure SetVariable (Var   DLLParams : ParamRec;
                       Const VarName   : String;
                       Const NewValue  : String); Export;
Var
  Idx : LongInt;
Begin { SetVariable }
  Idx := GlobalSetupMap.IndexOf(VarName);
  If (Idx > 0) Then
    GlobalSetupMap.Variables[Idx].vdValue := NewValue
  Else
    ShowMessage ('SQLHelpr.WiseUtil.GetVariable: Variable ' + VarName + ' not found');
End; { SetVariable }

//----------------------------------------------------------------------------

Initialization
  FillChar (DummyParams, SizeOf(DummyParams), #0);
end.
