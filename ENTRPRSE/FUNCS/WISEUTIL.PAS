unit WiseUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$IFNDEF WIN32}
  Please note that this module is 32-bit only
{$ENDIF}

Uses SysUtils, Windows;

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

implementation

//----------------------------------------------------------------------------

// Retrieves a string variable from a WISE script
Procedure GetVariable (Var   DLLParams : ParamRec;
                       Const VarName   : String;
                       Var   VarValue  : String); Export;
Var
  I         : Word;
  szVarName : array[0..255] of char;
Begin { GetVariable }
  VarValue := '';
  szVarName[0] := '%';
  StrPCopy(@szVarName[1],VarName);
  StrCat(szVarName,'%');
  for i := 0 to DLLParams.wCurrReps do
  begin
     if (StrComp(szVarName,@DLLParams.szRepName[i * DLLParams.wRepNameWidth]) = 0) then
     begin
        VarValue := StrPas(@DLLParams.szRepStr[i * DLLParams.wRepStrWidth]);
        Exit;
     end;
  end;
End; { GetVariable }

//----------------------------------------------------------------------------

// Sets a string variable in a WISE script
Procedure SetVariable (Var   DLLParams : ParamRec;
                       Const VarName   : String;
                       Const NewValue  : String); Export;
Var
  i         : Word;
  szVarName : array[0..255] of char;
Begin { SetVariable }
  szVarName[0] := '%';
  StrPCopy(@szVarName[1],VarName);
  StrCat(szVarName,'%');
  for i := 0 to DLLParams.wCurrReps do
  begin
     if (StrComp(szVarName,@DLLParams.szRepName[i * DLLParams.wRepNameWidth]) = 0) then
     begin
        StrPCopy(@DLLParams.szRepStr[i * DLLParams.wRepStrWidth],NewValue);
        Exit;
     end;
  end;
  StrCopy(@DLLParams.szRepName[DLLParams.wCurrReps * DLLParams.wRepNameWidth],szVarName);
  StrPCopy(@DLLParams.szRepStr[DLLParams.wCurrReps * DLLParams.wRepStrWidth],NewValue);
  DLLParams.wCurrReps := DLLParams.wCurrReps + 1;
End; { SetVariable }

//----------------------------------------------------------------------------

end.
