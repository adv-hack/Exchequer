unit WiseIntf;

interface

Uses SysUtils, WiseUtil;

// Wrapper functions to allow them to be called from WISE Setup Programs

function Wise7_GetEnterpriseDir (Var DLLParams: ParamRec) : LongBool; StdCall; Export;
function Wise7_AddCOMPlugIn (Var DLLParams: ParamRec) : LongBool; StdCall; Export;
function Wise7_AddDLLPlugIn (Var DLLParams: ParamRec) : LongBool; StdCall; Export;
function Wise7_AddToToolsMenu(Var DLLParams: ParamRec) : LongBool; StdCall; Export;
function Wise7_RemoveCOMPlugIn(var DLLParams: ParamRec) : LongBool; StdCall; Export;
function Wise7_RemoveDLLPlugIn(var DLLParams: ParamRec) : LongBool; StdCall; Export;
function Wise7_AddLSTFileToReplFile(Var DLLParams: ParamRec) : LongBool; StdCall; Export;
function Wise7_AddTCMPlugIn (Var DLLParams: ParamRec) : LongBool; StdCall; Export;
function Wise7_AddToSysSetupMenu(Var DLLParams: ParamRec) : LongBool; StdCall; Export;
function Wise7_IsSQLVersion(Var DLLParams: ParamRec) : LongBool;

implementation

Uses SetFuncs;

//---------------------------------------------------------------------------

// Wrapper function around GetEnterpriseDir to allow it to be called from
// the WISE Setup Programs.  The following WISE Script Variables are
// used:-
//
//   Variable          | Used for
//  -------------------+-------------------------------------------
//   ENTDIR              Set to Enterprise Directory
//   FUNCRES             Set to function result:-
//
//                         0        OK
//                         1001     Unknown Exception
//                         1002     Unable to Find Enterprise Directory
//                         1003     EnterpriseDir PChar too short
//
// Note: The function result is set to TRUE if the function succeeds
//
Function Wise7_GetEnterpriseDir (Var DLLParams: ParamRec) : LongBool;
Var
  EnterpriseDir : PChar;
  Res           : SmallInt;
Begin { Wise7_GetEnterpriseDir }
  EnterpriseDir := StrAlloc (255);
  Try
    // Call standard function to get the path
    Res := GetEnterpriseDir (EnterpriseDir);

    // Set the Wise script variables
    If (Res = 0) Then SetVariable (DllParams, 'ENTDIR', EnterpriseDir);
    SetVariable (DllParams, 'FUNCRES', IntToStr(Res));

    Result := (Res = 0);
  Finally
    StrDispose (EnterpriseDir);
  End;
End; { Wise7_GetEnterpriseDir }

//---------------------------------------------------------------------------

// Wrapper function around AddCOMPlugIn to allow it to be called from
// the WISE Setup Programs.  The following WISE Script Variables are
// used:-
//
//   Variable          | Used for
//  -------------------+-------------------------------------------
//   ENTDIR              Path to Enterprise Directory (MS-DOS 8.3 Format)
//   PLUGIN              Path to new Plug-In (MS-DOS 8.3 Format)
//   PLUGINDESC          Description of new Plug-In
//   FUNCRES             Set to function result:-
//
//                         0        OK
//                         1001     Unknown Exception, see EnterpriseDir for details
//                         1002     EnterpriseDir is not a valid Enterprise system
//                         1003     PlugInPath does not point to a valid COM Plug-In
//
// Note: The function result is set to TRUE if the function succeeds
//
function Wise7_AddCOMPlugIn (Var DLLParams: ParamRec) : LongBool;
Var
  EnterpriseDir, PlugInPath, PlugInDesc : PChar;
  TempStr                               : String;
  Res                                   : SmallInt;
Begin { Wise7_AddCOMPlugIn }
  EnterpriseDir := StrAlloc (255);
  PlugInPath := StrAlloc (255);
  PlugInDesc := StrAlloc (255);
  Try
    // Get info from Wise Script
    GetVariable (DllParams, 'ENTDIR', TempStr);
    StrPCopy (EnterpriseDir, TempStr);
    GetVariable (DllParams, 'PLUGIN', TempStr);
    StrPCopy (PlugInPath, TempStr);
    GetVariable (DllParams, 'PLUGINDESC', TempStr);
    StrPCopy (PlugInDesc, TempStr);

    // Call standard function to add the COM Plug-In
    Res := AddCOMPlugIn (EnterpriseDir, PlugInPath, PlugInDesc);

    // Set the Wise script variables
    SetVariable (DllParams, 'FUNCRES', IntToStr(Res));

    Result := (Res = 0);
  Finally
    StrDispose (EnterpriseDir);
    StrDispose (PlugInPath);
    StrDispose (PlugInDesc);
  End;
End; { Wise7_AddCOMPlugIn }

//---------------------------------------------------------------------------

// Wrapper function around AddDLLPlugIn to allow it to be called from
// the WISE Setup Programs.  The following WISE Script Variables are
// used:-
//
//   Variable          | Used for
//  -------------------+-------------------------------------------
//   ENTDIR              Path to Enterprise Directory (MS-DOS 8.3 Format)
//   DLLNAME             Name of Delphi DLL Plug-In excluding Path and Extension
//   PLUGINDESC          Description of new Plug-In
//   FUNCRES             Set to function result:-
//
//                         0        OK
//                         1001     Unknown Exception, see EnterpriseDir for details
//                         1002     EnterpriseDir is not a valid Enterprise system
//                         1003     DLLName does not point to a valid Delphi DLL Plug-In
//
// Note: The function result is set to TRUE if the function succeeds
//
function Wise7_AddDLLPlugIn (Var DLLParams: ParamRec) : LongBool;
Var
  EnterpriseDir, DllName, PlugInDesc : PChar;
  TempStr                            : String;
  Res                                : SmallInt;
Begin { Wise7_AddDLLPlugIn }
  EnterpriseDir := StrAlloc (255);
  DllName := StrAlloc (255);
  PlugInDesc := StrAlloc (255);
  Try
    // Get info from Wise Script
    GetVariable (DllParams, 'ENTDIR', TempStr);
    StrPCopy (EnterpriseDir, TempStr);
    GetVariable (DllParams, 'DLLNAME', TempStr);
    StrPCopy (DllName, TempStr);
    GetVariable (DllParams, 'PLUGINDESC', TempStr);
    StrPCopy (PlugInDesc, TempStr);

    // Call standard function to add the DLL Plug-In
    Res := AddDLLPlugIn (EnterpriseDir, DllName, PlugInDesc);

    // Set the Wise script variables
    SetVariable (DllParams, 'FUNCRES', IntToStr(Res));

    Result := (Res = 0);
  Finally
    StrDispose (EnterpriseDir);
    StrDispose (DllName);
    StrDispose (PlugInDesc);
  End;
End; { Wise7_AddDLLPlugIn }

//---------------------------------------------------------------------------

function Wise7_AddToToolsMenu(Var DLLParams: ParamRec) : LongBool;
// Wrapper function around AddToToolsMenu to allow it to be called from
// the WISE Setup Programs.  The following WISE Script Variables are
// used:-
//
//   Variable          | Used for
//  -------------------+-------------------------------------------
//   TOOLNAME           The Name displayed in the tools menu
//   TOOLCOMMAND        The command used to run the item
//   TOOLPARAMS         The parameters to pass to the EXE
//   TOOLSTARTDIR       The Directory to start the application in
//   FUNCRES            Set to function result:-
//
//                         0         OK
//                         1001-1003 Errors from GetEnterpriseDir
//                         1100      File to run from the tools menu, does not exist.
//
// Note: The function result is set to TRUE if the function succeeds
//
var
  pName, pCommand, pParams, pStartDir : PChar;
  sTemp : string;
  iRes : integer;
begin
  pName := StrAlloc (255);
  pCommand := StrAlloc (255);
  pParams := StrAlloc (255);
  pStartDir := StrAlloc (255);
  try
    // Get info from Wise Script
    GetVariable (DllParams, 'TOOLNAME', sTemp);
    StrPCopy (pName, sTemp);
    GetVariable (DllParams, 'TOOLCOMMAND', sTemp);
    StrPCopy (pCommand, sTemp);
    GetVariable (DllParams, 'TOOLPARAMS', sTemp);
    StrPCopy (pParams, sTemp);
    GetVariable (DllParams, 'TOOLSTARTDIR', sTemp);
    StrPCopy (pStartDir, sTemp);

    // Call standard function to add the item into the tools menu
    iRes := AddToToolsMenu(pName, pCommand, pParams, pStartDir);

    // Set the Wise script variables
    SetVariable (DllParams, 'FUNCRES', IntToStr(iRes));
    Result := (iRes = 0);
  Finally
    StrDispose(pName);
    StrDispose(pCommand);
    StrDispose(pParams);
    StrDispose(pStartDir);
  End;
end;{Wise7_AddToToolsMenu}

Function Wise7_RemoveCOMPlugIn(var DLLParams: ParamRec) : LongBool;
Var
  pPlugInPath, pEnterpriseDir : PChar;
  Res : SmallInt;
  sPlugInPath : string;
Begin { Wise7_RemoveCOMPlugIn }
  pEnterpriseDir := StrAlloc (255);
  Try
    // Call standard function to get the path
    Res := GetEnterpriseDir (pEnterpriseDir);

    pPlugInPath := StrAlloc (255);

    GetVariable (DllParams, 'REMOVEPIPATH', sPlugInPath);
    StrPCopy (pPlugInPath, sPlugInPath);

    Res := RemoveCOMPlugIn(pEnterpriseDir, pPlugInPath);

{    sPlugInPath := ExtractFilename(sPlugInPath);
    StrPCopy (pPlugInPath, sPlugInPath);
    RemoveFromSysSetupMenu(pPlugInPath);}

    StrDispose (pPlugInPath);

    // Set the Wise script variables
    SetVariable (DllParams, 'FUNCRES', IntToStr(Res));

    Result := (Res = 0);
  Finally
    StrDispose (pEnterpriseDir);
  End;
End; { Wise7_RemoveCOMPlugIn }

Function Wise7_RemoveDLLPlugIn(var DLLParams: ParamRec) : LongBool;
Var
  pPlugInPath, pEnterpriseDir : PChar;
  Res : SmallInt;
  sPlugInPath : string;
Begin { Wise7_RemoveDLLPlugIn }
  pEnterpriseDir := StrAlloc (255);
  Try
    // Call standard function to get the path
    Res := GetEnterpriseDir (pEnterpriseDir);

    pPlugInPath := StrAlloc (255);

    GetVariable (DllParams, 'REMOVEPIPATH', sPlugInPath);
    StrPCopy (pPlugInPath, sPlugInPath);

    Res := RemoveDLLPlugIn(pEnterpriseDir, pPlugInPath);

{    sPlugInPath := ExtractFilename(sPlugInPath);
    StrPCopy (pPlugInPath, sPlugInPath);
    RemoveFromSysSetupMenu(pPlugInPath);}

    StrDispose (pPlugInPath);

    // Set the Wise script variables
    SetVariable (DllParams, 'FUNCRES', IntToStr(Res));

    Result := (Res = 0);
  Finally
    StrDispose (pEnterpriseDir);
  End;
End; { Wise7_RemoveDLLPlugIn }

function Wise7_AddLSTFileToReplFile(Var DLLParams: ParamRec) : LongBool;
Var
  EnterpriseDir, LSTFile : PChar;
  TempStr                            : String;
  Res                                : SmallInt;
Begin { Wise7_AddLSTFileToReplFile }
  EnterpriseDir := StrAlloc (255);
  LSTFile := StrAlloc (255);
  Try
    // Get info from Wise Script
    GetVariable (DllParams, 'ENTDIR', TempStr);
    StrPCopy (EnterpriseDir, TempStr);
    GetVariable (DllParams, 'LSTFILE', TempStr);
    StrPCopy (LSTFile, TempStr);

    // Call standard function to add the LstFile
    Res := AddLSTFileToReplFile(EnterpriseDir, LSTFile);

    // Set the Wise script variables
    SetVariable (DllParams, 'FUNCRES', IntToStr(Res));

    Result := (Res = 0);
  Finally
    StrDispose (EnterpriseDir);
    StrDispose (LSTFile);
  End;{try}
End; { Wise7_AddLSTFileToReplFile }

// Wrapper function around AddCOMPlugIn to allow it to be called from
// the WISE Setup Programs.  The following WISE Script Variables are
// used:-
//
//   Variable          | Used for
//  -------------------+-------------------------------------------
//   ENTDIR              Path to Enterprise Directory (MS-DOS 8.3 Format)
//   PLUGIN              COM Name of new Plug-In (e.g. EnterpriseTradePlugIn.Addcustomer)
//   FUNCRES             Set to function result:-
//
//                         0        OK
//                         1001     Unknown Exception, see EnterpriseDir for details
//                         1002     EnterpriseDir is not a valid Enterprise system
//
// Note: The function result is set to TRUE if the function succeeds
//
function Wise7_AddTCMPlugIn (Var DLLParams: ParamRec) : LongBool;
Var
  EnterpriseDir, PlugInName : PChar;
  TempStr                               : String;
  Res                                   : SmallInt;
Begin { Wise7_AddCOMPlugIn }
  EnterpriseDir := StrAlloc (255);
  PlugInName := StrAlloc (255);
  Try
    // Get info from Wise Script
    GetVariable (DllParams, 'ENTDIR', TempStr);
    StrPCopy (EnterpriseDir, TempStr);
    GetVariable (DllParams, 'PLUGIN', TempStr);
    StrPCopy (PlugInName, TempStr);

    // Call standard function to add the COM Plug-In
    Res := AddTCMPlugIn (EnterpriseDir, PlugInName);

    // Set the Wise script variables
    SetVariable (DllParams, 'FUNCRES', IntToStr(Res));

    Result := (Res = 0);
  Finally
    StrDispose (EnterpriseDir);
    StrDispose (PlugInName);
  End;
End; { Wise7_AddCOMPlugIn }

function Wise7_AddToSysSetupMenu(Var DLLParams: ParamRec) : LongBool;
// Wrapper function around AddToToolsMenu to allow it to be called from
// the WISE Setup Programs.  The following WISE Script Variables are
// used:-
//
//   Variable          | Used for
//  -------------------+-------------------------------------------
//   TOOLNAME           The Name displayed in the tools menu
//   TOOLCOMMAND        The command used to run the item
//   TOOLPARAMS         The parameters to pass to the EXE
//   TOOLSTARTDIR       The Directory to start the application in
//   TOOLPLUGINFILE     The PluginFile used to identifiy the option to remove
//   FUNCRES            Set to function result:-
//
//                         0         OK
//                         1001-1003 Errors from GetEnterpriseDir
//                         1100      File to run from the tools menu, does not exist.
//
// Note: The function result is set to TRUE if the function succeeds
//
var
  pPlugInFile, pName, pCommand, pParams, pStartDir : PChar;
  sTemp : string;
  iRes : integer;
begin
  pName := StrAlloc (255);
  pCommand := StrAlloc (255);
  pParams := StrAlloc (255);
  pStartDir := StrAlloc (255);
  pPlugInFile := StrAlloc (255);
  try
    // Get info from Wise Script
    GetVariable (DllParams, 'TOOLNAME', sTemp);
    StrPCopy (pName, sTemp);
    GetVariable (DllParams, 'TOOLCOMMAND', sTemp);
    StrPCopy (pCommand, sTemp);
    GetVariable (DllParams, 'TOOLPARAMS', sTemp);
    StrPCopy (pParams, sTemp);
    GetVariable (DllParams, 'TOOLSTARTDIR', sTemp);
    StrPCopy (pStartDir, sTemp);
    GetVariable (DllParams, 'TOOLPLUGINFILE', sTemp);
    sTemp := ExtractFilename(sTemp);
    StrPCopy (pPlugInFile, sTemp);


    // Call standard function to add the item into the tools menu
    iRes := AddToSysSetupMenu(pName, pCommand, pParams, pStartDir, pPlugInFile);

    // Set the Wise script variables
    SetVariable (DllParams, 'FUNCRES', IntToStr(iRes));
    Result := (iRes = 0);
  Finally
    StrDispose(pName);
    StrDispose(pCommand);
    StrDispose(pParams);
    StrDispose(pStartDir);
    StrDispose(pPlugInFile);
  End;
end;{Wise7_AddToSysSetupMenu}

function Wise7_RemoveFromSysSetupMenu(Var DLLParams: ParamRec) : LongBool;
// Wrapper function around AddToToolsMenu to allow it to be called from
// the WISE Setup Programs.  The following WISE Script Variables are
// used:-
//
//   Variable          | Used for
//  -------------------+-------------------------------------------
//   TOOLPLUGINFILE     The PluginFile used to identifiy the option to remove
//   FUNCRES            Set to function result:-
//
//                         0         OK
//                         1001-1003 Errors from GetEnterpriseDir
//
// Note: The function result is set to TRUE if the function succeeds
//
var
  pPlugInFile : PChar;
  sTemp : string;
  iRes : integer;
begin
  pPlugInFile := StrAlloc (255);
  try
    // Get info from Wise Script
    GetVariable (DllParams, 'TOOLPLUGINFILE', sTemp);
    sTemp := ExtractFilename(sTemp);
    StrPCopy (pPlugInFile, sTemp);

    // Call standard function to add the item into the tools menu
    iRes := RemoveFromSysSetupMenu(pPlugInFile);

    // Set the Wise script variables
    SetVariable (DllParams, 'FUNCRES', IntToStr(iRes));
    Result := (iRes = 0);
  Finally
    StrDispose(pPlugInFile);
  End;
end;{Wise7_RemoveFromSysSetupMenu}

function Wise7_IsSQLVersion(Var DLLParams: ParamRec) : LongBool;
Var
//  EnterpriseDir, DllName, PlugInDesc : PChar;
//  TempStr                            : String;
  iRes : SmallInt;
Begin { Wise7_IsSQLVersion }
//  EnterpriseDir := StrAlloc (255);
//  DllName := StrAlloc (255);
//  PlugInDesc := StrAlloc (255);
//  Try
    // Get info from Wise Script
{    GetVariable (DllParams, 'ENTDIR', TempStr);
    StrPCopy (EnterpriseDir, TempStr);
    GetVariable (DllParams, 'DLLNAME', TempStr);
    StrPCopy (DllName, TempStr);
    GetVariable (DllParams, 'PLUGINDESC', TempStr);
    StrPCopy (PlugInDesc, TempStr);}

    // Call standard function
    iRes := IsSQLVersion;

    // Set the Wise script variables
//    SetVariable (DllParams, 'FUNCRES', IntToStr(iRes));

    Result := (iRes = 1);
//  Finally
//    StrDispose (EnterpriseDir);
//    StrDispose (DllName);
//    StrDispose (PlugInDesc);
//  End;
End; { Wise7_IsSQLVersion }


end.
