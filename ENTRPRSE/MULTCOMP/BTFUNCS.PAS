unit BtFuncs;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses Classes, Dialogs, FileCtrl, Forms, Registry, SysUtils,
     WinTypes, WinProcs, DLLWise, IniFiles;


{ Sets up the v6.15 Local Workstation Engine for the main Enterprise Setup }
function SCD_SetupLocalBtrieve(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Runs W32MKDE.EXE in main Enterprise directory }
function SCD_EntRunBtrieve(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Workstation Setup }
function SCD_SetupWorkstation(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Sets up the v6.15 Local Workstation Engine for the Workstation Setup }
function SCD_SetupWorkstationBtrieve(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Setups up the Client-Server Requesters }
function SCD_SetupV8Engine(var DLLParams: ParamRec): LongBool; StdCall; export;

// Registers the COM Objects for the Workgroup Engine
function SCD_SetupWorkgroupCOM(var DLLParams: ParamRec): LongBool; StdCall; export;

// Configures the P.SQL v8 WGE registry entries
function SCD_Setupv8WGEReg(var DLLParams: ParamRec): LongBool; StdCall; export;


implementation

Uses CompUtil, APIUtil, GlobVar, VarConst, SetupReg, LicRec, EntLic, VarFPosU, ComObj;


{ Runs W32MKDE.EXE in main Enterprise directory }
function SCD_EntRunBtrieve(var DLLParams: ParamRec): LongBool;
Var
  MainComp : String;
  LNull    : Array [0..255] Of Char;
  LStr     : String[255];
  Res      : LongInt;
Begin { SCD_EntRunBtrieve }
  { Get Installation Directories from WISE }
  { Main Company }
  GetVariable(DLLParams, 'V_MAINDIR', MainComp);
  FixPath (MainComp);

  { Not already running - run a new copy }
  FillChar (LNull, SizeOf (LNull), #0);
  LStr:=MainComp + 'W32MKDE.EXE';
  StrPCopy(LNull,LStr);

  Res := WinExec(LNull, SW_MINIMIZE);
  {If (Res <= 31) Then ;  { Its buggered up!!! };

  Result := False;
End;  { SCD_EntRunBtrieve }

{-----------------------------------------------------------------------------}

{ Sets up the v6.15 Local Workstation Engine for the main Enterprise Setup }
// 1000        Unknown Error
// 1001        Unknown Exception
// 1002        Unknown Exception whilst Registering Btrieve
// 1003        Unknown Exception whilst Registering OLE Server
// 1004        Unknown Exception whilst Registering Graph OCX
// 1005        Unknown Exception whilst Registering COM Customisation
function WorkStationSetup(var   DLLParams: ParamRec;
                          Const RegBtrieve, RegOle, RegGraph, RegCom, SetSysDir : Boolean;
                          Const PSQLVer, PSQLWGEVer : SmallInt): LongInt;
Var
  EntLicR    : EntLicenceRecType;
  WiseStr    : String;
  DLLStatus  : LongInt;
  IsCS       : Boolean;
Begin { WorkStationSetup }
  Try
    DLLStatus := 1000;   { Unknown Error }

    With TSetupEntRegistry.Create Do
      Try
        { Get Registration Directory from WISE (Where the .EXE's/.DLL's are) }
        GetVariable(DLLParams, 'V_REGDIR', WiseStr);
//ShowMessage (WiseStr);

        // MH 16/11/06: Modified to allow COM Objects to be registered to the long filename,
        //              causes problems under Windows Vista otherwise
        EntDir := IncludeTrailingPathDelimiter(WiseStr);
        //FixPath (WiseStr);
        //EntDir := WiseStr;

        { Check for Local Program Files }
        GetVariable(DLLParams, 'V_DATADIR', WiseStr);
        FixPath (WiseStr);
        DataDir := WiseStr;

        If SetSysDir Then
        Begin
          SetupSystemDir(DataDir);
        End; // If SetSysDir

        If RegBtrieve Then Begin
          DLLStatus := 1002;   { Unknown Error }

          { Always setup locally at this point }
          ClientServer := False;

          // HM 04/10/01: Modified to use Licence File instead of Wise Variables to
          // determine whether to configure as Single-User or Multi-User
          ExMainCoPath^ := EntDir;
          If ReadEntLic (EntLicFName, EntLicR) Then Begin
            With EntLicR, TIniFile.Create(EntDir + 'WSTATION\SETUP.USR') Do
              Try
                // First check for specific override in SETUP.USR
                If ValueExists ('BtrConfig', 'MultiUser') Then Begin
                  // Use override setting
                  If ReadBool ('BtrConfig', 'MultiUser', True) Then
                    // Always configure as multi-user
                    UserCount := 2
                  Else
                    // Always configure as single-user
                    UserCount := 1;
                End { If ValueExists ('BtrConfig', 'MultiUser') }
                Else
                  // For single-user systems take module licences into account
                  If (licUserCnt = 1) Then Begin
                    // Determine from user count licencing
                    If (licUserCounts[ucToolkit30] > 1) Or       // 30-Day Toolkit User Count
                       (licUserCounts[ucToolkitFull] > 1) Or     // Full Toolkit User Count
                       (licUserCounts[ucTradeCounter] > 1) Then  // Trade Counter User Count
                      UserCount := 2
                  End; { If (EntLicR.licUserCnt = 1) }

                // HM 22/07/03: Take Client-Server flag from licence
                IsCS := (licEntClSvr = 1);
              Finally
                Free;
              End;
          End { If ReadEntLic }
          Else Begin
            { Get User Count from Enterprise directory }
            GetVariable(DLLParams, 'L_UCOUNT', WiseStr);
            UserCount := StrToInt(WiseStr);

            { Get Client-Server version from Enterprise directory for later use }
            GetVariable(DLLParams, 'L_CLSVR', WiseStr);
            IsCS := (Trim(WiseStr) = '1');
          End; { Else }

          { Setup Btrieve }
          PSQLWorkgroupVer := PSQLWGEVer;
          SetupBtrieve615;
        End; { If RegBtrieve }

        If RegOle Then Begin
          DLLStatus := 1003;   { Unknown Error }
          SetupOLESvr;
        End; { If RegOle }

        If RegGraph Then Begin
          DLLStatus := 1004;   { Unknown Error }

          SetupGraph;
        End; { If RegGraph }

        If RegCOM Then Begin
          DLLStatus := 1005;   { Unknown Error }

          SetupCOMCustom;
        End; { If RegGraph }

        // HM 09/02/99: Added section to setup as Client-Server where relevent
        If RegBtrieve And IsCS Then Begin
          { Always setup locally at this point }
          ClientServer := True;
          //ClientServerODBC := ????  unknown - doesn't work reliably as of 09/02/00
          PervasiveVersion := PSQLVer;

          { Setup Btrieve }
          SetupBtrieve615;
        End; { If }

        DLLStatus := 0;
      Finally
        Free;
      End;
  Except
    On Ex:Exception Do
      DLLStatus := 1001;
  End;

  Result := DLLStatus;
End; { WorkStationSetup }

{-----------------------------------------------------------------------------}

{ Sets up the v6.15 Local Workstation Engine for the main Enterprise Setup }
// 1000        Unknown Error
// 1001        Unknown Exception
function SCD_SetupLocalBtrieve(var DLLParams: ParamRec): LongBool;
Var
  WiseStr    : String;
  DLLStatus  : LongInt;
  bSetSysDir : Boolean;
Begin { SCD_SetupLocalBtrieve }
  // HM 22/11/04: Only set VAO SystemDir setting if VAO.INF doesn't exist in
  // the target directory - under Terminal Services this was resetting the path
  // for all users.
  GetVariable(DLLParams, 'V_REGDIR', WiseStr);
  FixPath (WiseStr);
  bSetSysDir := Not FileExists(WiseStr + 'VAO.INF');

  DLLStatus := WorkStationSetup (DLLParams,
                                 True,       // RegBtrieve
                                 False,      // RegOle
                                 False,      // RegGraph
                                 False,      // RegCom
                                 bSetSysDir, //True,     // SetSysDir
                                 0,          // PSQLVer
                                 0);         // PSQLWGEVer

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_SetupLocalBtrieve }

{-----------------------------------------------------------------------------}

{ Sets up the v6.15 Local Workstation Engine for the Workstation Setup }
// 1000        Unknown Error
// 1001        Unknown Exception
function SCD_SetupWorkstation(var DLLParams: ParamRec): LongBool;
Var
  DLLStatus                   : LongInt;
  PSQLVer, WGEVer, WGEGenuine : String;
Begin { SCD_SetupWorkstation }
  // HM 22/07/03: Modified to pass the C/S Engine version into WorkstationSetup to support P.SQL v8
  GetVariable (DllParams, 'CS_ENGVER', PSQLVer);

  // MH 17/10/06: Modified to check the Genuine P.SQL WGE flag - if 'Y' then skip the Workgroup
  // configuration as it just totally screws the genuine product
  GetVariable (DllParams, 'WG_GENUINE', WGEGenuine);
  If (WGEGenuine <> 'Y') Then
    // HM 08/10/03: Modified to pass the WGE Engine version into WorkstationSetup to support P.SQL v8 workgroup
    GetVariable (DllParams, 'WG_VERSION', WGEVer)
  Else
    WGEVer := '0';  // Disable setting of v8.10 WGE registry settings

  DLLStatus := WorkStationSetup (DLLParams,
                                 True,                       // RegBtrieve
                                 True,                       // RegOle
                                 True,                       // RegGraph
                                 True,                       // RegCom
                                 True,                       // SetSysDir
                                 StrToIntDef (PSQLVer, 0),   // PSQLVer
                                 StrToIntDef (WGEVer, 0));   // PSQLWGEVer

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_SetupWorkstation }

{-----------------------------------------------------------------------------}

{ Sets up the v6.15 Local Workstation Engine for the Workstation Setup }
// 1000        Unknown Error
// 1001        Unknown Exception
function SCD_SetupWorkstationBtrieve(var DLLParams: ParamRec): LongBool;
Var
  DLLStatus                   : LongInt;
  PSQLVer, WGEVer, WGEGenuine : String;
Begin { SCD_SetupWorkstationBtrieve }
  // HM 22/07/03: Modified to pass the C/S Engine version into WorkstationSetup to support P.SQL v8
  GetVariable (DllParams, 'CS_ENGVER', PSQLVer);

  // MH 17/10/06: Modified to check the Genuine P.SQL WGE flag - if 'Y' then skip the Workgroup
  // configuration as it just totally screws the genuine product
  GetVariable (DllParams, 'WG_GENUINE', WGEGenuine);
  If (WGEGenuine <> 'Y') Then
    // HM 08/10/03: Modified to pass the WGE Engine version into WorkstationSetup to support P.SQL v8 workgroup
    GetVariable (DllParams, 'WG_VERSION', WGEVer)
  Else
    WGEVer := '0';  // Disable setting of v8.10 WGE registry settings

  DLLStatus := WorkStationSetup (DLLParams,
                                 True,                       // RegBtrieve
                                 False,                      // RegOle
                                 False,                      // RegGraph
                                 False,                      // RegCom
                                 True,                       // SetSysDir
                                 StrToIntDef (PSQLVer, 0),   // PSQLVer
                                 StrToIntDef (WGEVer, 0));   // PSQLWGEVer

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_SetupWorkstationBtrieve }

{-----------------------------------------------------------------------------}

{ Sets up the v8 Client-Server Engine for the Workstation Setup }
// 1000        Unknown Error
// 1001        Unknown Exception
function SCD_SetupV8Engine(var DLLParams: ParamRec): LongBool;
Var
  DLLStatus       : LongInt;
  PSQLVer, WGEVer : String;
Begin { SCD_SetupV8Engine }
  // HM 22/07/03: Modified to pass the C/S Engine version into WorkstationSetup to support P.SQL v8
  GetVariable (DllParams, 'CS_ENGVER', PSQLVer);

  DLLStatus := WorkStationSetup (DLLParams,
                                 True,                       // RegBtrieve
                                 False,                      // RegOle
                                 False,                      // RegGraph
                                 False,                      // RegCom
                                 False,                      // SetSysDir
                                 StrToIntDef (PSQLVer, 0),   // PSQLVer
                                 StrToIntDef (WGEVer, 0));   // PSQLWGEVer

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_SetupV8Engine }

//-------------------------------------------------------------------------

// Registers the COM Objects for the Workgroup Engine
// 1000        Unknown Error
// 1001        Unknown Exception
function SCD_SetupWorkgroupCOM(var DLLParams: ParamRec): LongBool;
Var
  cmdFile, cmdPath, cmdParams : PChar;
  V_RegDir, WG_Version        : String;
  DLLStatus                   : LongInt;
Begin { SCD_SetupWorkgroupCOM }
  DLLStatus := 1000;   { Unknown Error }

  Try
    { Get Registration Directory from WISE (Where the .EXE's/.DLL's are) }
    GetVariable(DLLParams, 'V_REGDIR', V_RegDir);
    FixPath (V_RegDir);

    // Get the WGE Engine version
    GetVariable (DllParams, 'WG_VERSION', WG_Version);

    If (WG_Version = '1') Then
    Begin
      // P.SQL v8 Workgroup
      If FileExists (V_RegDir + 'BIN\MKC.DLL') Then
        RegisterCOMServer (V_RegDir + 'BIN\MKC.DLL');
      If FileExists (V_RegDir + 'BIN\W3EXP010.DLL') Then
        RegisterCOMServer (V_RegDir + 'BIN\W3EXP010.DLL');
      If FileExists (V_RegDir + 'BIN\LEGACYLM.DLL') Then
        RegisterCOMServer (V_RegDir + 'BIN\LEGACYLM.DLL');
      If FileExists (V_RegDir + 'BIN\LICMGRRB.DLL') Then
        RegisterCOMServer (V_RegDir + 'BIN\LICMGRRB.DLL');
      If FileExists (V_RegDir + 'BIN\pvdrmsrb.DLL') Then
        RegisterCOMServer (V_RegDir + 'BIN\pvdrmsrb.DLL');
      If FileExists (V_RegDir + 'BIN\pvmsgrb.DLL') Then
        RegisterCOMServer (V_RegDir + 'BIN\pvmsgrb.DLL');
      If FileExists (V_RegDir + 'BIN\timgrrb.DLL') Then
        RegisterCOMServer (V_RegDir + 'BIN\timgrrb.DLL');

      If FileExists (V_RegDir + 'BIN\cnstring.DLL') Then
      Begin
        // Register component for OLEDB - regsvr32 /s /i:"Workgroup" /n .\cnstring.dll
        cmdFile := StrAlloc(255);
        Try
          StrPCopy (cmdFile, FindRegSvr32(V_RegDir));

          If FileExists (cmdFile) Then
          Begin
            cmdPath   := StrAlloc(255);
            cmdParams := StrAlloc(255);

            StrPCopy (cmdParams, '/s /i:"Workgroup" /n ' + V_RegDir + 'bin\cnstring.dll');
            StrPCopy (cmdPath,   V_RegDir + '\bin');

            RunApp (cmdFile + ' ' + cmdParams, True);

            StrDispose(cmdPath);
            StrDispose(cmdParams);
          End; // If FileExists (cmdFile)
        Finally
          StrDispose(cmdFile);
        End; // Try..Finally
      End; // If FileExists (V_RegDir + 'BIN\cnstring.DLL')
    End; // If (WG_Version = '1')
  Except
    On Ex:Exception Do
      DLLStatus := 1001;
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_SetupWorkgroupCOM }

//-------------------------------------------------------------------------

// Configures the P.SQL v8 WGE registry entries
function SCD_Setupv8WGEReg(var DLLParams: ParamRec): LongBool;
Var
  oReg : TRegistry;
  V_ExchLocal : ShortString;
Begin // SCD_Setupv8WGEReg
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_READ or KEY_WRITE;
    oReg.RootKey := HKEY_LOCAL_MACHINE;

    If oReg.OpenKey('SOFTWARE\Pervasive Software\Microkernel Router\Version 8\Settings', True) Then
    Begin
      oReg.WriteString ('Local', 'yes');
      oReg.WriteString ('Requester', 'yes');
      oReg.WriteInteger ('Target Engine', 2);
      oReg.WriteString ('Use Cache Engine', 'yes');

      oReg.CloseKey;
    End; // If oReg.OpenKey('SOFTWARE\Pervasive Software\Microkernel Router\Version 8\Settings', False)

    If oReg.OpenKey('SOFTWARE\Pervasive Software\MicroKernel Workgroup Engine\Version 8\Settings', True) Then
    Begin
      V_ExchLocal := WinGetWindowsDir[1] + ':\Excheqr\MKDE\';

      oReg.WriteString('File Version', '0800');
      oReg.WriteString('Trace File', V_ExchLocal + 'MKDE.TRA');
      oReg.WriteString('Transaction Log Directory', V_ExchLocal + 'Log');

      oReg.CloseKey;
    End; // If oReg.OpenKey('SOFTWARE\Pervasive Software\MicroKernel Workgroup Engine\Version 8\Settings', False)
  Finally
    oReg.Free;
  End; // Try..Finally

End; // SCD_Setupv8WGEReg

//-------------------------------------------------------------------------

end.

