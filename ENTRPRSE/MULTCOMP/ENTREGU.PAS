unit EntRegU;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Dialogs, Forms, SysUtils, Windows;

Var
  SystemDir : String;       { Directory containing Enterprise System files }
  DllStatus : SmallInt;     { Status, 0 = AOK }


Procedure RegisterSystem(Const MultiUserBtr, OCXOnly, IsConnect : Boolean); Export;
Procedure SetClServer(Const ClServer : Boolean); Export;
Procedure ModRexBat (ExeDir : ShortString);

Function DllStatusOk : Boolean;
Function TimeVal : LongInt;

implementation

Uses IniFiles, Registry, RegProg, RexSave;

Const
  DefBtrOpt    = '/L:20 /F:50 /H:60 /T:15 /M:512 /U:3 /W: /I: /B:16 /G:100:1000';
  BtrBaseKey   = 'SOFTWARE\Btrieve Technologies\Microkernel Workstation Engine\Version  6.15';
  BtrIntfKey   = '\Microkernel Interface\Settings';
  BtrSettKey   = '\Settings';
  BtrMaxF      = 'Max Files';
  BtrMaxHand   = 'Max Handles';
  BtrMaxLock   = 'Max Locks';
  BtrCreate    = 'Create 5x Files';
  BtrCompBuf   = 'Compression Buffer Size';
  BtrMaxClient = 'Max Clients';
  BtrWorker    = 'Worker Threads';
  BtrBackG     = 'Background Threads';
  BtrLocalFS   = 'File Sharing On Local Drives';
  BtrRemote    = 'File Sharing On Remote Drives';
  BtrBundle    = 'Systrans Bundle Limit';
  BtrTimeLimit = 'Systrans Time Limit';
  BtrDiskWait  = 'Disk Wait Limit';
  BtrLocal     = 'Local';
  BtrRequester = 'Requester';


{ Returns True if machine is running Windows NT }
Function IS_WinNT  :  Boolean;
Var
  OSVerIRec : TOSVersionInfo;
Begin
  Result:=False;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) then
    Result:=(OSVerIRec.dwPlatformId=VER_PLATFORM_WIN32_NT);
end;


{ Returns True if no errors have occurred }
Function DllStatusOk : Boolean;
Begin
  Result := (DllStatus = 0);
End;


{ Returns time in seconds }
Function TimeVal : LongInt;
Var
  Hour, Min, Sec, MSec : Word;
begin
  DecodeTime(Now, Hour, Min, Sec, MSec);

  Result := Sec + (60 * (Min + (Hour * 60)));
end;

{ Registers various items with the Registry }
Procedure RegisterSystem(Const MultiUserBtr, OCXOnly, IsConnect : Boolean);
Var
  Cmd, ExeDir, ExeName, Params : Array [0..255] Of Char;
  MaxTime                      : LongInt;
  DRes                         : Integer;
  {$H-}
  Tmp                          : String[255];
  {$H+}
  RegObj                       : TRegistry;
  RegisterProgress             : TRegisterProgress;

  { Registers the Enterprise OLE Server }
  Procedure RegEnterOle;
  Begin
    Tmp := SystemDir+'ENTEROLE.EXE /REGSERVER';
    FillChar (Cmd, SizeOf (Cmd), #0);
    StrPCopy (Cmd, Tmp);
    If (WinExec  (Cmd, SW_SHOW) <= 31) Then Begin
      MessageDlg ('An error occurred attempting to register the OLE Server', mtError, [mbOk], 0);
      DllStatus := 1;
    End; { If }
  End;

  { Returns True if the Btrieve tree is in the registry }
  Function BtrieveInstalled : Boolean;
  Begin
    Result := False;

    Try
      RegObj.RootKey := HKEY_LOCAL_MACHINE;
      If RegObj.KeyExists(BtrBaseKey + BtrSettKey) Then
        If RegObj.OpenKey(BtrBaseKey + BtrSettKey, False) Then
          { Key opened ok }
          Result := RegObj.ValueExists(BtrMaxF) And
                    RegObj.ValueExists(BtrMaxHand) And
                    RegObj.ValueExists(BtrMaxLock) And
                    RegObj.ValueExists(BtrCreate) And
                    RegObj.ValueExists(BtrCompBuf) And
                    RegObj.ValueExists(BtrMaxClient) And
                    RegObj.ValueExists(BtrWorker) And
                    RegObj.ValueExists(BtrBackG) And
                    RegObj.ValueExists(BtrLocalFS) And
                    RegObj.ValueExists(BtrRemote);
    Finally
      RegObj.CloseKey;
    End;

    If Result Then Begin
      Result := False;

      { Check interface settings as well }
      Try
        RegObj.RootKey := HKEY_LOCAL_MACHINE;
        If RegObj.KeyExists(BtrBaseKey + BtrIntfKey) Then
          If RegObj.OpenKey(BtrBaseKey + BtrIntfKey, False) Then
            { Key opened ok }
            Result := RegObj.ValueExists(BtrLocal) And
                      RegObj.ValueExists(BtrRequester);
      Finally
        RegObj.CloseKey;
      End;
    End; { If }
  End;

  { Registers Btrieve }
  Procedure RegBtrieve;
  Begin
    If (Not BtrieveInstalled) Then Begin
      Tmp := SystemDir+'W32MKDE.EXE -REGSERVER';
      FillChar (Cmd, SizeOf (Cmd), #0);
      StrPCopy (Cmd, Tmp);
      If (WinExec  (Cmd, SW_SHOW) > 31) Then Begin
        { AOK - wait 2 seconds for it to finish }
        MaxTime := TimeVal + 2;
        Repeat

        Until (TimeVal >= MaxTime);

        { Make sure the interface registry entries exist }
        Try
          RegObj.RootKey := HKEY_LOCAL_MACHINE;
          If Not RegObj.KeyExists(BtrBaseKey + BtrIntfKey) Then
            RegObj.CreateKey(BtrBaseKey + BtrIntfKey);

          If RegObj.KeyExists(BtrBaseKey + BtrIntfKey) Then Begin
            If RegObj.OpenKey(BtrBaseKey + BtrIntfKey, False) Then
              { Key opened ok }
              If Not RegObj.ValueExists(BtrLocal) Then Begin
                RegObj.WriteInteger (BtrLocal, 1);
              End; { If }

              If Not RegObj.ValueExists(BtrLocal) Then Begin
                ShowMessage ('Local Missing');
              End; { If }

              If Not RegObj.ValueExists(BtrRequester) Then Begin
                RegObj.WriteInteger (BtrRequester, 0);
              End; { If }

              If Not RegObj.ValueExists(BtrRequester) Then Begin
                ShowMessage ('Requester Missing');
              End; { If }
          End { If }
          Else
            ShowMessage ('Interface key missing');
        Finally
          RegObj.CloseKey;
        End;
      End { If }
      Else Begin
        MessageDlg ('An error occurred attempting to register the Btrieve Database Manager', mtError, [mbOk], 0);
        DllStatus := 1;
      End; { Else }
    End; { If }
  End;

  Procedure CheckDWord (Const Key : String;Const Value : Integer);
  Var
    DWord  : Integer;
  Begin
    DWord := RegObj.ReadInteger(Key);
    If (DWord < Value) Then Begin
      DWord := Value;
      RegObj.WriteInteger (Key, DWord);
    End; { If }
  End;

  Procedure CheckDWordIs (Const Key : String;Const Value : Integer);
  Var
    DWord  : Integer;
  Begin
    DWord := RegObj.ReadInteger(Key);
    If (DWord <> Value) Then Begin
      DWord := Value;
      RegObj.WriteInteger (Key, DWord);
    End; { If }
  End;

  Procedure CheckString (Const Key, Value : String);
  Var
    Str : String;
  Begin
    Str := RegObj.ReadString(Key);
    If (Str <> Value) Then Begin
      Str := Value;
      RegObj.WriteString (Key, Str);
    End; { If }
  End;

  Procedure UpdateBtrieve;
  Var
    DWord  : Integer;
    Str    : String;
  Begin
    Try
      RegObj.RootKey := HKEY_LOCAL_MACHINE;

      If RegObj.OpenKey(BtrBaseKey + BtrIntfKey, False) Then Begin
        CheckDWordIs (BtrLocal, 1);

        (* moved to seperate procedure called at end of install }
        If ClServer Then
          CheckDWordIs ('Requester', 1)
        Else
          CheckDWordIs ('Requester', 0);
        *)
      End { If }
      Else
        ShowMessage ('Warning: Btrieve Interface settings are missing');
    Finally
      RegObj.CloseKey;
    End;

    Try
      RegObj.RootKey := HKEY_LOCAL_MACHINE;

      If RegObj.OpenKey(BtrBaseKey + BtrSettKey, False) Then Begin
        CheckDWord  (BtrMaxF,      200);
        CheckDWord  (BtrMaxHand,   1000);
        { HM 20/10/98; Increased on EL's instructions }
        CheckDWord  (BtrMaxLock,   1000);
        {CheckDWord  (BtrMaxLock,   200);}
        CheckString (BtrCreate,    '1');
        CheckDWord  (BtrCompBuf,   6144);
        CheckDWord  (BtrMaxClient, 200);
        CheckDWord  (BtrWorker,    4);
        CheckDWord  (BtrBackG,     18);
        CheckString (BtrLocalFS,   '1');
        CheckString (BtrRemote,    '1');
        CheckString ('Create 5x Files', '0');
        CheckString ('Delete Tmp Files', '0');
        CheckString ('Startup Logo', '0');

        If MultiUserBtr Then Begin
          { Optimise for multi-user }
          CheckDWordIs(BtrBundle,    25);
          CheckDWordIs(BtrTimeLimit, 400);
          CheckDWordIs(BtrDiskWait,  0);
        End { If }
        Else Begin
          { Single user }
          CheckDWordIs(BtrBundle,    1000);
          CheckDWordIs(BtrTimeLimit, 2000);
          CheckDWordIs(BtrDiskWait,  1000);
        End; { Else }
      End; { If }
    Finally
      RegObj.CloseKey;
    End;
  End;

  { Set the Pervasive.SQL settings }
  Procedure DoPervySQL;
  Begin
    { HM 06/04/99: Added settings to initialise the P.SQL7 btrieve settings }
    If FileExists(SystemDir + 'W32SSET.EXE') Then Begin
      Try
        RegObj.RootKey := HKEY_LOCAL_MACHINE;

        If RegObj.OpenKey('SOFTWARE\Pervasive Software\Communications Requester\Version 7.00\Settings', True) Then Begin
          If Not RegObj.ValueExists('TCP connect timeout') Then Begin
            // "TCP connect timeout"=dword:0000000f
            RegObj.WriteInteger ('TCP connect timeout', $F);
          End; { If }
          If Not RegObj.ValueExists('Supported protocols') Then Begin
            // "Supported protocols"="SPX,TCPIP"
            RegObj.WriteString ('Supported protocols', 'SPX,TCPIP');
          End; { If }
          If Not RegObj.ValueExists('Runtime server') Then Begin
            // "Runtime server"="Yes"
            RegObj.WriteString ('Runtime server', 'Yes');
          End; { If }
          If Not RegObj.ValueExists('NumSatEntries') Then Begin
            // "NumSatEntries"=dword:00000000
            RegObj.WriteInteger ('NumSatEntries', 0);
          End; { If }
        End; { If }
      Finally
        RegObj.CloseKey;
      End;

      Try
        RegObj.RootKey := HKEY_LOCAL_MACHINE;

        If RegObj.OpenKey('SOFTWARE\Pervasive Software\Btrieve Requester\Version 7.0\Settings', True) Then Begin
          // "Splash Screen"="no"
          RegObj.WriteString ('Splash Screen', 'no');
        End; { If }
      Finally
        RegObj.CloseKey;
      End;

      Try
        RegObj.RootKey := HKEY_LOCAL_MACHINE;

        If RegObj.OpenKey('SOFTWARE\Pervasive Software\Microkernel Router\Version 7.01\Settings', True) Then Begin
          // "Local"="yes"
          RegObj.WriteString ('Local', 'yes');        // Always set

          // "Requester"="no"
          RegObj.WriteString ('Requester', 'no');   // Local

          // "Target Engine"=dword:00000002
          RegObj.WriteInteger ('Target Engine', 2);

          If Not RegObj.ValueExists('Load Retries') Then Begin
            // "Load Retries"=dword:00000005
            RegObj.WriteInteger ('Load Retries', 5);
          End; { If }
        End; { If }
      Finally
        RegObj.CloseKey;
      End;
    End; { If FileExists(SystemDir + 'W32SSET.EXE') }

    Try
      RegObj.RootKey := HKEY_LOCAL_MACHINE;

      { Pervasive.SQL 7 - Btrieve Settings for Client Engine }
      If RegObj.OpenKey('SOFTWARE\Pervasive Software\Microkernel Router\Version 7.0\Settings', True) Then Begin
        { HM 05/02/99: Check value exists before setting it }
        If RegObj.ValueExists('Local') Then Begin
          If (RegObj.GetDataType ('Local') = rdString) Then Begin
            RegObj.WriteString ('Local', 'yes');
          End { If }
          Else Begin
            RegObj.WriteInteger ('Local', 1);
          End; { Else }
        End; { If }

        If RegObj.ValueExists('Requester') Then Begin
          If (RegObj.GetDataType ('Requester') = rdString) Then Begin
            RegObj.WriteString ('Requester', 'No');
          End { If }
          Else Begin
            RegObj.WriteInteger ('Requester', 0);
          End; { Else }
        End; { If }

        { HM 07/04/99: Added for P.SQL Support }
        RegObj.WriteInteger ('Target Engine', 2);
      End; { If }
    Finally
      RegObj.CloseKey;
    End;

    Try
      RegObj.RootKey := HKEY_LOCAL_MACHINE;

      { Scaleable.SQL v4 - ODBC Settings to Local Engine }
      { Note: Also set in EntRegU (MCM) and EntReg2u (EntReg.Exe) }
      If RegObj.OpenKey('SOFTWARE\Pervasive Software\Scalable SQL Requester\Version 4.00\Settings', False) Then Begin
        { HM 05/02/99: Check value exists before setting it }
        If RegObj.ValueExists('Local') Then Begin
          If (RegObj.GetDataType ('Local') = rdString) Then Begin
            RegObj.WriteString ('local', 'yes');
          End { If }
          Else Begin
            RegObj.WriteInteger ('local', 1);
          End; { Else }
        End; { If }
        If RegObj.ValueExists('requester') Then Begin
          If (RegObj.GetDataType ('requester') = rdString) Then Begin
            RegObj.WriteString ('requester', 'no');
          End { If }
          Else Begin
            RegObj.WriteInteger ('requester', 0);
          End; { Else }
        End; { If }
        If RegObj.ValueExists('logins') Then Begin
          CheckDWord  ('logins', 10);
        End; { If }
        If RegObj.ValueExists('target engine') Then Begin
          RegObj.WriteInteger ('target engine', 0);
        End; { If }
      End; { If }
    Finally
      RegObj.CloseKey;
    End;
  End;

  Procedure DoDosBtrieve;
  Const
    Section = 'Btrieve Client';
    Ident   = 'options';
  Var
    IniF               : TIniFile;
    StrVal, Str1, Str2 : String;
    OptPos             : Integer;
  Begin
    IniF := TIniFile.Create(SystemDir + 'BTI.CFG');

    Try
      StrVal := IniF.ReadString(Section, Ident, DefBtrOpt);

      { Remove /M: Parameter }
      OptPos := Pos ('/M:', StrVal);
      If (OptPos > 0) Then Begin
        Str1 := Copy (StrVal, 1, Pred (OptPos));             { copy anything before /M: }
        Str2 := Copy (StrVal, Succ(OptPos), Length(StrVal)); { copy anything after the / }

        OptPos := Pos ('/', Str2);
        If (OptPos > 0) Then
          Str2 := Copy (Str2, Pos('/', Str2), Length(Str2))   { remove the M:512 bit }
        Else
          Str2 := '';

        StrVal := Str1 + Str2;
      End; { If }

      { Change /G: Parameter }
      OptPos := Pos ('/G:', StrVal);
      If (OptPos > 0) Then Begin
        Str1 := Copy (StrVal, 1, Pred (OptPos));             { copy anything before /G: }
        Str2 := Copy (StrVal, Succ(OptPos), Length(StrVal)); { copy anything after the / }

        OptPos := Pos ('/', Str2);
        If (OptPos > 0) Then
          Str2 := Copy (Str2, Pos('/', Str2), Length(Str2))   { remove the M:512 bit }
        Else
          Str2 := '';

        StrVal := Str1 + Str2;
      End; { If }

      If MultiUserBtr And (Not IS_WinNT) Then
        { Multi-User Optimisation (Win 95 only) }
        StrVal := Trim(StrVal) + ' /M:512:0 /G:1:1'
      Else
        { Single-User or NT }
        StrVal := Trim(StrVal) + ' /M:512 /G:100:5000';

      IniF.WriteString(Section, Ident, StrVal);
    Finally
      IniF.Free;
    End;
  End;

  Procedure RegGraph;
  Begin
    Tmp := SystemDir+'REGSVR32.EXE /s VCFI32.OCX';
    FillChar (Cmd, SizeOf (Cmd), #0);
    StrPCopy (Cmd, Tmp);
    If (WinExec  (Cmd, SW_SHOW) <= 31) Then Begin
      MessageDlg ('An error occurred attempting to register the Graph OCX', mtError, [mbOk], 0);
      DllStatus := 1;
    End; { If }
  End;

begin
  { Create progress screen }
  RegisterProgress := TRegisterProgress.Create(Application);
  Try
    { display progress screen }
    RegisterProgress.FormStyle := fsNormal;
    RegisterProgress.Show;
    RegisterProgress.Refresh;

    { Create registry access object }
    RegObj := TRegistry.Create;
    Try
      RegObj.Access := KEY_READ or KEY_WRITE;

      { register btrieve by running ? with ? switch }
      RegBtrieve;

      { Set the Pervasive.SQL settings }
      DoPervySQL;

      If (Not OCXOnly) And (DllStatus = 0) Then Begin
        { register Enterprise OLE Server by running ENTEROLE /REGSERVER }
        RegEnterOle;
      End; { If }

      { register graph OCX by running REGSRV32 ? }
      If (DllStatus = 0) And (Not IsConnect) Then
        RegGraph;

      { Reset Btrieve default values }
      If (DllStatus = 0) Then Begin
        MaxTime := TimeVal + 30;
        Repeat
          { check to see if the items are in the registry }
          If BtrieveInstalled Then Begin
            { update Btrieve settings }
            UpdateBtrieve;

            If (Not IsConnect) Then
              DoDosBtrieve;

            Break;
          End; { If }

          Application.ProcessMessages;
        Until (TimeVal >= MaxTime) Or (DLLStatus > 0);
      End; { If }

      If (DllStatus = 0) And (Not BtrieveInstalled) Then Begin
        MessageDlg ('Btrieve is not installed - registration aborted', mtError, [mbOk], 0);
        DllStatus := 1;
      End; { If }
    Finally
      RegObj.Free;
    End;
  Finally
    { Close Progress Screen }
    RegisterProgress.Free;
  End;
End; { RegisterSystem }


{ Modifies the REX.BAT to have the %1 %2 %3 %4 setting on the Excheqr command line }
Procedure ModRexBat (ExeDir : ShortString);
Var
  InFile, OutFile        : TextFile;
  CopName, FrName, InStr : String;
  Changed                : Boolean;


  { Generate Unique Filename }
  Function GetUniqueName : String;
  Var
    RepFName, SDrive : ANSIString;
    FVar             : SmallInt;
    Tmp              : String[5];
    I                : Byte;

    { Converts Long path to Short DOS 8.3 format path }
    Function PathToShort (Const FPath : ShortString) : ShortString;
    Var
      Temp1, Temp2 : PChar;
      PLen         : SmallInt;
    Begin
      Result := FPath;

      If (Trim(FPath) <> '') Then Begin
        Temp1 := StrAlloc (250);
        Temp2 := StrAlloc (250);

        StrPCopy (Temp1, Trim(FPath));
        PLen := GetShortPathName (Temp1, Temp2, StrBufSize (Temp2));
        If (PLen > 0) Then
          Result := Trim(StrPas(Temp2));

        StrDispose (Temp1);
        StrDispose (Temp2);
      End; { If }
    End;

  Begin
    Result := '';
    SDrive := PathToShort(ExeDir);

    FVar := 1;
    Repeat
      Tmp := Format('%5d', [FVar]);
      For I := 1 To 5 Do
        If (Tmp[I] = ' ') Then Tmp[I] := '0';

      RepFName := SDrive + 'REX' + Tmp {IntToStr(FVar)} + '.BAT';
      Inc (FVar);
    Until (Not FileExists (RepFName)) Or (FVar > 9999);

    Result := UpperCase(RepFName);
  End;


Begin
  { Check batch file exists - they may have called it something else }
  FrName := ExeDir + 'REX.BAT';
  If FileExists (FrName) Then Begin
    { Generate unique filename }
    CopName := GetUniqueName;

    { Copy REX.BAT to REXxxxxx.BAT - where xxxxx is a unique number (0 padded) }
    If RenameFile (FrName, CopName) Then Begin

      {$I-}

      Changed := False;

      { open backup file for reading }
      Assign (InFile, CopName);
      Reset (InFile);
      If (IOResult = 0) Then Begin
        { open rex.bat for writing }
        Assign (OutFile, FrName);
        Rewrite (OutFile);
        If (IOResult = 0) Then Begin
          { Read Orig bat-file copying into Rex.Bat }
          While (Not EOF(InFile)) And (IOResult = 0) Do Begin
            Readln (InFile, InStr);

            If (Copy (Trim(UpperCase(InStr)), 1, 7) = 'EXCHEQR') Then Begin
              { Check for % params }
              If (Pos('%1', InStr) = 0) Or (Pos('%2', InStr) = 0) Or
                 (Pos('%3', InStr) = 0) Or (Pos('%4', InStr) = 0) Then Begin
                { Not found add }
                Writeln (OutFile, 'rem ' + InStr);
                Writeln (OutFile, 'excheqr %1 %2 %3 %4');
                Changed := true;
              End { If }
              Else
                Writeln (OutFile, InStr);
            End { If }
            Else
              Writeln (OutFile, InStr);
          End; { While }

          { Close Rex.Bat }
          Close (OutFile);
        End;

        { Close Backup file }
        Close (InFile);
      End; { If }

      If Changed Then Begin
        { Display notification dialog if changes made }
        Form_REXWarn := TForm_REXWarn.Create(Application);
        Try
          Form_REXWarn.RexSave.Caption := CopName;

          Form_REXWarn.ShowModal;
        Finally
          Form_REXWarn.Free;
        End;
      End { If }
      Else
        { Delete copy file if no changes made }
        SysUtils.DeleteFile(CopName);

      {$I+}
    End; { If }
  End; { If }
End;


{ Sets the Btrieve Client-Server requester flag in the registry }
Procedure SetClServer(Const ClServer : Boolean);
Var
  RegObj : TRegistry;
Begin
  { Create registry access object }
  RegObj := TRegistry.Create;
  Try
    RegObj.Access := KEY_READ or KEY_WRITE;
    RegObj.LazyWrite := False;
    RegObj.RootKey := HKEY_LOCAL_MACHINE;

    If RegObj.OpenKey(BtrBaseKey + BtrIntfKey, False) Then Begin
      RegObj.WriteInteger (BtrLocal, 1);

      If ClServer Then
        RegObj.WriteInteger (BtrRequester, 1)
      Else
        RegObj.WriteInteger (BtrRequester, 0);

      RegObj.CloseKey;
    End { If }
    Else
      ShowMessage ('Warning: Btrieve Interface settings are missing');

    { Pervasive.SQL 7 - Btrieve Settings for Client Engine }
    If RegObj.OpenKey('SOFTWARE\Pervasive Software\Microkernel Router\Version 7.0\Settings', True) Then Begin
      RegObj.WriteString ('Local', 'No');

      If ClServer Then
        RegObj.WriteString ('Requester', 'yes')
      Else
        RegObj.WriteString ('Requester', 'No');
    End; { If }
    RegObj.CloseKey;

    If RegObj.OpenKey('SOFTWARE\Pervasive Software\Microkernel Router\Version 7.01\Settings', True) Then Begin
      // "Requester"="no"
      If ClServer Then
        RegObj.WriteString ('Requester', 'yes')   // Client-Server
      Else
        RegObj.WriteString ('Requester', 'no');   // Local
    End; { If }
  Finally
    RegObj.CloseKey;
    RegObj.Free;
  End;
End;



Procedure CloseMsg;
{Var
  Res               : Integer;
  lpText, lpCaption : PChar;}
Begin
 (* lpText := StrAlloc (255);
  lpCaption := StrAlloc (255);

  lpText := 'Started EntComp Finalization';
  lpCaption := 'Debugging';

  Res := MessageBox (0, lpText, lpCaption, MB_OK Or MB_ICONHAND Or MB_SYSTEMMODAL);

  StrDispose (lpText);
  StrDispose (lpCaption);*)

  {Application.MessageBox ('Started EntComp Finalization', 'Debugging', MB_OK Or MB_ICONHAND Or MB_SYSTEMMODAL);}
End;

Initialization
  DllStatus := 0;
Finalization
  CloseMsg;
end.
