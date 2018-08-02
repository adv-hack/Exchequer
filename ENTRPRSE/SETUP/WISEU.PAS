unit wiseu;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses Classes, Dialogs, Forms, WinTypes, WinProcs, SysUtils;

type
{$ifndef WIN32}
  { 16-Bit - Delphi 1.0 }
  ParamRec = record
     wStructLen: Word;   { The length of the structure }
     hMainWnd: HWnd;     { Handle to main window }
     wMaxReplaces: Word; { Maximum number of replaces }
     wRepNameWidth: Word;{ The width of a replace name }
     wRepStrWidth: Word; { The width of each replace string }
     wCurrReps: Word;    { Current number of replace strings }
     szRepName: PChar;   { The actual replace names }
     szRepStr: PChar;    { The actual replace values }
     wRunMode: Word;     { The installation mode }
     fLogFile: Integer;  { A file handle to the log file }
     szParam: PChar;     { String parameter from Wise Installation = System }
  end;
{$else}
  { 32-Bit - Delphi 2.0 }
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
{$endif}

procedure GetVariable (var DLLParams: ParamRec; const VarName: string; var VarValue: string); export;
procedure SetVariable (var DLLParams: ParamRec; const VarName: string; const NewValue: string); export;

Function GetEnterDir (Var DLLParams: ParamRec): LongBool; StdCall; export;
Function ExecFile (Var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

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


Function GetEnterDir (Var DLLParams: ParamRec): LongBool;
Var
  DlgPN : String;
Begin { GetEnterDir }
  Result := False;

  GetVariable(DLLParams, 'INST', DlgPN);

  ShowMessage ('Inst: ' + DlgPN + #13 +
               'ExeName: ' + Application.ExeName);
End; { GetEnterDir }


Function ExecFile (Var DLLParams: ParamRec): LongBool;
Var
  Res : LongInt;
Begin { ExecFile }
  Result := False;
  Res := WinExec('f:\setup\test\bin\modules.bin', SW_SHOWNORMAL);
End; { ExecFile }



end.
