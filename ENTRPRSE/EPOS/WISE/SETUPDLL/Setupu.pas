unit SetupU;

interface

{uses Dialogs, FileCtrl, Forms, Registry, TReg2, WinTypes, WinProcs, SysUtils;}
uses Windows, SysUtils;

type
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

  procedure GetVariable (var DLLParams: ParamRec; const VarName: string; var VarValue: string); export;
  procedure SetVariable (var DLLParams: ParamRec; const VarName: string; const NewValue: string); export;


implementation

{  Uses SetupDi2, wstcfg, CompType, CDVerU, SerialU;}

{ Retrieves a WISE Variable Value }
procedure GetVariable(var DLLParams: ParamRec; const VarName: string; var VarValue: string);
var
  i: Integer;
  szVarName: array[0..255] of char;
begin
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
end;

{ Sets a WISE Variable value }
procedure SetVariable(var DLLParams: ParamRec; const VarName: string; const NewValue: string);
var
  i: Integer;
  szVarName: array[0..255] of char;
begin
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
end;

end.

