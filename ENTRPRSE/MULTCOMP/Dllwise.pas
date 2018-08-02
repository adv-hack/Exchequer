unit DLLWise;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses Dialogs, FileCtrl, Forms, WinTypes, WinProcs, SysUtils;

type
  { ifndef WIN32}
    (*
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
    *)
  { else}
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
  { endif}

function  EntRegister(var DLLParams: ParamRec): LongBool; StdCall; export;
function  EntRegConnect(var DLLParams: ParamRec): LongBool; StdCall; export;
function  EntClientServer(var DLLParams: ParamRec): LongBool; StdCall; export;
function  EntInitCompany(var DLLParams: ParamRec): LongBool; StdCall; export;
function  EntDataCopy(var DLLParams: ParamRec): LongBool; StdCall; export;
function  EntRunBtrieve(var DLLParams: ParamRec): LongBool; StdCall; export;
//function  EntCompanyWiz(var DLLParams: ParamRec): LongBool; StdCall; export;
function  EntModRexBat(var DLLParams: ParamRec): LongBool; StdCall; export;
function  EntRegDataSources(var DLLParams: ParamRec): LongBool; StdCall; export;

procedure GetVariable (var DLLParams: ParamRec; const VarName: string; var VarValue: string); export;
procedure SetVariable (var DLLParams: ParamRec; const VarName: string; const NewValue: string); export;

implementation

{$IFNDEF HMTEST}
  Uses {EntDataU,} EntInitU, EntRegU, EntReplU, CompUtil, GlobVar, VarConst,
{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}
  EntOdbcU;
{$ENDIF}

{Var
  OutF : TextFile;}

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


{ Registers the Btrieve, Graph OCX, OLE Server }
function EntRegister(var DLLParams: ParamRec): LongBool;
var
  MultiUserBtr, OCXOnly : Boolean;
  DlgPN                 : String;
begin
  DllStatus := 0;
  Result := False;

  { Get default installation directory from WISE }
  GetVariable(DLLParams, 'DLGDIR', DlgPN);
  FixPath (DlgPN);

  If DirectoryExists (DlgPN) And FileExists (DlgPN + 'W32MKDE.EXE') Then Begin
    { Set the Enterprise System path }
    SystemDir := DlgPN;

    { Get the Btrieve Multi/Single User Flag }
    GetVariable(DLLParams, 'WANTMUBTR', DlgPN);
    MultiUserBtr := (DlgPN[1] = 'Y');

    { Get the OCX Flag }
    GetVariable(DLLParams, 'WANTREGISTER', DlgPN);
    OCXOnly := (DlgPN[1] <> 'Y');

    { Call the register routine }
    RegisterSystem(MultiUserBtr, OCXOnly, False);

    Result := (DLLStatus <> 0);
  End { If }
  Else Begin
    { Error - system directory is dud }
    MessageDlg ('Invalid System Directory', mtError, [mbOk], 0);
    Result := True;
  End; { If }
end;


{ Registers the Btrieve, OLE Server }
function EntRegConnect(var DLLParams: ParamRec): LongBool;
var
  MultiUserBtr, OCXOnly : Boolean;
  DlgPN                 : String;
begin
  {$IFDEF HMTEST}
    ShowMessage ('EntRegConnect Test');
    Result := False;
  {$ELSE}
    DllStatus := 0;

    { Get default installation directory from WISE }
    GetVariable(DLLParams, 'DLGDIR', DlgPN);
    FixPath (DlgPN);

    If DirectoryExists (DlgPN) And FileExists (DlgPN + 'W32MKDE.EXE') Then Begin
      { Set the Enterprise System path }
      SystemDir := DlgPN;

      { Get the Btrieve Multi/Single User Flag }
      GetVariable(DLLParams, 'WANTMUBTR', DlgPN);
      MultiUserBtr := (DlgPN[1] = 'Y');

      { Set the OCX Only Flag if OLE is not installed }
      OCXOnly := Not FileExists (SystemDir + 'EnterOLE.EXE');

      { Call the register routine }
      RegisterSystem(MultiUserBtr, OCXOnly, True);

      Result := (DLLStatus <> 0);
    End { If }
    Else Begin
      { Error - system directory is dud }
      MessageDlg ('Invalid System Directory', mtError, [mbOk], 0);
      Result := True;
    End; { If }
  {$ENDIF}
end;


{ Sets the Btrieve Requester flag in the Registry }
function EntClientServer(var DLLParams: ParamRec): LongBool;
var
  ClServer : Boolean;
  DlgPN    : String;
begin
  {$IFDEF HMTEST}
    ShowMessage ('EntClientServer');
    Result := False;
  {$ELSE}
    {Writeln (OutF, 'EntClientServer');}

    DllStatus := 0;

    { Get the Client Server Flag }
    GetVariable(DLLParams, 'WANTCSVR', DlgPN);
    ClServer := (DlgPN[1] = 'Y');

    { Call the register routine }
    SetClServer(ClServer);

    Result := (DLLStatus <> 0);

    {Writeln (OutF, '  Result:      ', Result);
    Writeln (OutF);}
  {$ENDIF}
end;


{ Resets the expiry date for the security }
function EntInitCompany(var DLLParams: ParamRec): LongBool;
Var
  ExeDir, DataDir, InstType, InstDir : String;
  Err, InstTypeIdx                   : Integer;
  DemoInst                           : Boolean;
Begin
  {$IFDEF HMTEST}
    Result := False;
  {$ELSE}
    {Writeln (OutF, 'EntInitCompany');}

    DllStatus := 0;

    { Get Installation Type from WISE }
    GetVariable(DLLParams, 'INSTTYPEIDX', InstType);
    Val (InstType, InstTypeIdx, Err);
    {Writeln (OutF, '  InstTypeIdx: ', InstTypeIdx);
    Writeln (OutF, '  Err:         ', Err);}

    If (Err = 0) And (InstTypeIdx In [0..3, 5]) Then Begin
      { Get Installation Type from WISE }
      GetVariable(DLLParams, 'MAINDIR', ExeDir);
      FixPath (ExeDir);

      If (InstTypeIdx In [0..3]) Then Begin
        { Install / Upgrade - Data in MAINDIR }
        DataDir := ExeDir;
      End { If }
      Else Begin
        { New Company }
        GetVariable(DLLParams, 'MAINDIR2', DataDir);
        FixPath (DataDir);
      End; { If }

      GetVariable(DLLParams, 'INST', InstDir);
      FixPath (InstDir);

      DemoInst := False;
      If (InstTypeIdx = 5) Then Begin
        { Additional Company - Work out if using demo data }
        GetVariable(DLLParams, 'WANTDEMOCOMP', InstType);
        If (Length(InstType) > 0) Then
          DemoInst := (UpperCase(InstType[1]) = 'Y');
      End; { If }

      { Check paths are valid }
{$IFDEF EXSQL}
      if ValidSystem(ExeDir) then begin
        if ValidCompany(DataDir) then begin
{$ELSE}
      If FileExists (ExeDir + 'ENTCOMP.DLL') And FileExists (ExeDir + 'COMPANY.DAT') Then Begin
        { Main Company Dir is ok - check data dir }
        If FileExists (DataDir + 'EXCHQSS.DAT') Then Begin
{$ENDIF}
          {Writeln (OutF, '  ExeDir:      ', ExeDir);
          Writeln (OutF, '  DataDir:     ', DataDir);}

          { Do the Biz!!! }
          InitCompany (ExeDir,
                       DataDir,
                       InstDir,
                       (InstTypeIdx In [0, 1, 5]),
                       (InstTypeIdx = 5),
                       (InstTypeIdx In [1, 5]) And (Not DemoInst),
                       (InstTypeIdx = 0),
                       (InstTypeIdx In [2, 3]));

          {Procedure InitCompany (ExeDir, DataDir : String;
                                 InitSecurity,
                                 WantMainSec,
                                 InitComp,
                                 IsDemo,
                                 IsUpdate : Boolean);}
        End { If }
        Else Begin
          DllStatus := 1;
          MessageDlg ('The directory containing the company data is invalid' + #10#13#10#13 + DataDir, mtError, [mbOk], 0);
        End; { Else }
      End { If }
      Else Begin
        DllStatus := 1;
        MessageDlg ('The directory containing the main company is invalid' + #10#13#10#13 + ExeDir, mtError, [mbOk], 0);
      End; { Else }
    End; { If }

    Result := (DllStatus <> 0) Or (Err <> 0);

    {ShowMessage ('DllStatus: ' + IntToStr(DllStatus) + #13 +
                 'Err: ' + IntToStr(Err));}
    {Writeln (OutF, '  Result:      ', Result);
    If Result Then Begin
      Writeln (OutF, '  DllStatus:   ', DllStatus);
      Writeln (OutF, '  Err:         ', Err);
    End; { If }
    {Writeln (OutF);}
  {$ENDIF}
End;

{ Copies data into a new company }
function EntDataCopy(var DLLParams: ParamRec): LongBool;
//Var
//  MainComp, NewComp, lDbType : String;
Begin
MessageDlg ('SCD_EntDataCopy Not Supported - please notify your technical support', mtError, [mbOK], 0);
(****
  {$IFDEF HMTEST}
    ShowMessage ('EntDataCopy');
    Result := False;
  {$ELSE}
    DllStatus := 0;

    { Get Installation Directories from WISE }
    { Main Company }
    GetVariable(DLLParams, 'MAINDIR', MainComp);
    FixPath (MainComp);

    { New Company }
    GetVariable(DLLParams, 'MAINDIR2', NewComp);

    FixPath (NewComp);

    {get database type}
    GetVariable(DLLParams, 'L_DBTYPE', lDbType);

{$IFDEF EXSQL}
    if SQLUtils.ValidSystem(MainComp) then
{$ELSE}
    { Check paths are valid }
    If FileExists (MainComp + 'ENTCOMP.DLL') And FileExists (MainComp + 'COMPANY.DAT') Then
{$ENDIF}
    Begin
      { Do the Biz!!! }
      CopyCompanyData (lDbType = '1', MainComp, NewComp, cdmExchequer);
    End { If }
    Else Begin
      DllStatus := 1;
      MessageDlg ('The directory containing the main company is invalid' + #10#13#10#13 +
                  MainComp, mtError, [mbOk], 0);
    End; { Else }

    Result := (DllStatus <> 0);
  {$ENDIF}
****)  
End;



{ Runs W32MKDE.EXE in currenct directory }
function EntRunBtrieve(var DLLParams: ParamRec): LongBool;
Var
  MainComp : String;
  LNull    : Array [0..255] Of Char;
  LStr     : String[255];
  Res      : LongInt;
Begin { EntRunBtrieve }
  {$IFDEF HMTEST}
    ShowMessage ('EntRunBtrieve');
    Result := False;
  {$ELSE}

    { Get Installation Directories from WISE }
    { Main Company }
    GetVariable(DLLParams, 'MAINDIR', MainComp);
    FixPath (MainComp);

    { Not already running - run a new copy }
    FillChar (LNull, SizeOf (LNull), #0);
    LStr:=MainComp + 'W32MKDE.EXE';
    StrPCopy(LNull,LStr);

    Res := WinExec(LNull, SW_MINIMIZE);
    {If (Res > 31) Then ;  { Its buggered up!!! };

    Result := False;
  {$ENDIF}
End;  { EntRunBtrieve }


(***
{ Does the Add Companies Wizard for the Connectivity Kit Install }
function EntCompanyWiz(var DLLParams: ParamRec): LongBool;
Var
  MainComp : String;
Begin { EntCompanyWiz }
  {$IFDEF HMTEST}
    ShowMessage ('EntCompanyWiz');
    Result := False;
  {$ELSE}
    { Get Installation Directories from WISE }
    { Main Company }
    GetVariable(DLLParams, 'MAINDIR', MainComp);
    FixPath (MainComp);

    { Get path of help file }
    Application.HelpFile := MainComp + 'ENTREAD.HLP';

    { need to open data files }
    SetDrive := MainComp;

    { Open data files }
    Open_System(MiscF, MiscF);
    Open_System(CompF, CompF);

    LoadCompanyOpt;

    CompListMode := 3;
    Form_CompanyList := TForm_CompanyList.Create(Application);
    Try
      Form_CompanyList.CmdParam := '';
      Form_CompanyList.SplashHandle := 0;
      Form_CompanyList.ShowModal;
    Finally
      Form_CompanyList.Free;
    End;

    Result := False;
  {$ENDIF}
End;  { EntCompanyWiz }
***)

{ Modifies REX.BAT to be Multi-Company Compatible }
function EntModRexBat(var DLLParams: ParamRec): LongBool;
Var
  MainComp : String;
Begin { EntModRexBat }
  {$IFDEF HMTEST}
    ShowMessage ('EntModRexBat');
    Result := False;
  {$ELSE}
    { Get Installation Directories from WISE }
    { Main Company }
    GetVariable(DLLParams, 'MAINDIR', MainComp);
    FixPath (MainComp);

    ModRexBat(MainComp);

    Result := False;
  {$ENDIF}
End;  { EntModRexBat }


{ Registers all Companies as Data Sources }
function EntRegDataSources(var DLLParams: ParamRec): LongBool;
Var
  MainComp : String;
Begin { EntRegDataSources }
  {$IFDEF HMTEST}
    ShowMessage ('EntRegDataSources');
    Result := False;
  {$ELSE}
    { Get Installation Directories from WISE }
    { Main Company }
    GetVariable(DLLParams, 'MAINDIR', MainComp);
    FixPath (MainComp);

    CheckForSources (MainComp);

    Result := False;
  {$ENDIF}
End;  { EntRegDataSources }


Initialization
  {Application.HelpFile := 'ENTREAD.HLP';}
  {AssignFile (OutF, 'EntComp.Txt');
  Rewrite    (OutF);}
Finalization
  {CloseFile (OutF);}
end.
