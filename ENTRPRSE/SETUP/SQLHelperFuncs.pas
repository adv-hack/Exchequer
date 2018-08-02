unit SQLHelperFuncs;

interface

Uses Windows, SysUtils, WiseUtil, Classes, strutil, Dialogs;

Function SQLHLPR_CreateSQLDatabase(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_CreateSQLCompany(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_SQLDataImport(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_ImportCompData(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_ImportCommonData(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_ReplicateFiles(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_InitialiseImporterJobs(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_ConvertData(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_SetupLicence(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_SetupCompanyCount(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_EntCompanyWizard(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_ReplicateLicence(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_EntDataCopy(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_CopyMainSecurity(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_ArchiveFiles(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_GenRootLocFiles(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_GenLocFiles(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_CreateAuditTrail(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SQLHLPR_CreateVAT100Dirs(Var DLLParams: ParamRec): LongBool; StdCall; export;

Function SQLHLPR_CheckCompanyCount(Const CompPath : ShortString) : WordBool; StdCall; export;
Function SQLHLPR_CompanyExists(Const ExchequerPath, CompCode : ShortString) : WordBool; StdCall; export;

// MH 07/04/2017 2017-R1 ABSEXCH-18512: Example VRW Reports
Function SQLHLPR_AddDirectoryToReplicationList(Var DLLParams: ParamRec): LongBool; StdCall; export;

// MH 08/01/2018 2017-R1 ABSEXCH-19316: Initialise SQL Posting Flags
Function SQLHLPR_InitialiseSQLPostingFlags(Var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

Uses SQLH_MemMap, APIUtil;

Const
  // List of Wise Variables being supported by the memory map, for performance reasons
  // the most commonly used stuff should be at the top so that it is found first.
  WiseVariables : Array [1..33] Of String =
    (
      'V_MAINDIR',                // All
      'V_DLLERROR',               // All
      'L_DBTYPE',                 // fnCreateSQLDatabase / fnCreateSQLCompany / fnSQLImportCompData / fnDataCopyWizard
      'V_COMPDIR',                // fnCreateSQLCompany / fnEntCompanyWizard / fnDataCopyWizard / fnCopyMainSecurity
      'V_INSTTYPE',               // fnSetupLicence / fnEntCompanyWizard / fnReplicateLicence / fnArchiveFiles
      'I_COUNTRY',                // fnSetupLicence / fnEntCompanyWizard / fnCopyMainSecurity
      'V_INSTALL',                // fnSetupLicence / fnEntCompanyWizard / fnDataCopyWizard
      'V_DEMODATA',               // fnCreateSQLCompany / fnEntCompanyWizard
      'V_GETCOMPCODE',            // fnCreateSQLCompany / fnEntCompanyWizard
      'V_GETCOMPNAME',            // fnCreateSQLCompany / fnEntCompanyWizard
      'I_TYPE',                   // fnSetupLicence / fnReplicateLicence
      'I_LICFILE',                // fnSetupLicence / fnReplicateLicence
      'V_INSTMOD',                // fnSetupLicence / fnReplicateLicence
      'VP_STATUS',                // fnSetupLicence / fnReplicateLicence
      'WG_SERVERPC',              // fnGenRootLocFiles / fnGenLocFiles
      'V_ROOTDIR',                // fnGenRootLocFiles
      'SQLSERVER',                // fnCreateSQLDatabase
      'V_SQLDBNAME',              // fnCreateSQLDatabase
      'SQL_DATA',                 // fnCreateSQLCompany
      'SQL_USERLOGIN',            // fnCreateSQLCompany
      'SQL_USERPASS',             // fnCreateSQLCompany
      'V_SQLCREATEDB',            // fnCreateSQLDatabase
      'V_SQLCREATECOMP',          // fnCreateSQLCompany
      'V_SQLIMPORTDATA',          // fnSQLImportCompData
      'V_ENTDATAVER',             // fnConvertData
      'D_COMPCODE',               // fnEntCompanyWizard
      'D_COMPNAME',               // fnEntCompanyWizard
      'I_LICTYPE',                // fnEntCompanyWizard
      'L_BASE',                   // fnEntCompanyWizard
      'L_CURRVER',                // fnEntCompanyWizard
      // MH 22/10/2013 v7.0.7 ABSEXCH-14684: Added support for SQL protocol
      'V_SQLPROTOCOL',            // fnCreateSQLDatabase
      // MH 07/04/2017 2017-R1 ABSEXCH-18512: Example VRW Reports
      'V_REPLICATIONDIRECTORY',   // fnReplicateFilesInDir
      'V_REPLICATIONFILESPEC'     // fnReplicateFilesInDir
    );

//=========================================================================

Procedure LoadMapFromSetup (Var DLLParams: ParamRec);
Var
  I : LongInt;
  VarValue : ANSIString;
Begin // LoadMapFromSetup
//ShowMessage ('LoadMapFromSetup.Start');
  GlobalSetupMap.Params := DLLParams.szParam;

  For I := Low(WiseVariables) To High(WiseVariables) Do
  Begin
//ShowMessage (WiseVariables[I]);
    GetVariable (DLLParams, WiseVariables[I], VarValue);
    GlobalSetupMap.AddVariable (WiseVariables[I], VarValue);
  End; // For I
//ShowMessage ('LoadMapFromSetup.Fini');
End; // LoadMapFromSetup

//------------------------------

Procedure UpdateSetupFromMap (Var DLLParams: ParamRec);
Var
  I : LongInt;
Begin // UpdateSetupFromMap
//ShowMessage ('UpdateSetupFromMap.Start');
  For I := 1 To GlobalSetupMap.VariableCount Do
  Begin
    With GlobalSetupMap.Variables[I] Do
    Begin
      If vdChanged Then
      Begin
        SetVariable (DLLParams, vdName, vdValue);
      End; // If gvdChanged
    End; // With GlobalSetupMap.Variables[I]
  End; // For I
//ShowMessage ('UpdateSetupFromMap.Fini');
End; // UpdateSetupFromMap

//-------------------------------------------------------------------------

Function RunSQLHelper (Var DLLParams: ParamRec; Const FunctionId : LongInt; Const DebugMode : Boolean = False) : LongBool;
Var
  sVMainDir : ShortString;
  Idx       : LongInt;
Begin // RunSQLHelper
//ShowMessage ('RunSQLHelper.Start');
  GlobalSetupMap.FunctionId := FunctionID;

//ShowMessage ('RunSQLHelper.1');
  // Get variables from WISE setup
  LoadMapFromSetup (DLLParams);

//ShowMessage ('RunSQLHelper.2');
  // Call the SQL Helper Function - .EXE will be in main exchequer directory
  Idx := GlobalSetupMap.IndexOf ('V_MAINDIR');
//ShowMessage ('RunSQLHelper.3 - Idx=' + IntToStr(Idx));
  sVMainDir := GlobalSetupMap.Variables[Idx].vdValue;
//ShowMessage ('RunSQLHelper.4 - sVMainDir=' + sVMainDir);

//ShowMessage ('Run ' + IncludeTrailingPathDelimiter(sVMainDir) + 'SQLHELPR.EXE /SQLBODGE');
  If DebugMode Then
    ShowMessage(' Run ' + IncludeTrailingPathDelimiter(sVMainDir) + 'SQLHELPR.EXE /SQLBODGE Now')
  Else
    RunApp(IncludeTrailingPathDelimiter(sVMainDir) + 'SQLHELPR.EXE /SQLBODGE', True);

//ShowMessage ('RunSQLHelper.5');
  // Copy any changes back into Wise setup
  UpdateSetupFromMap(DLLParams);

//ShowMessage ('RunSQLHelper.6');
  Result := GlobalSetupMap.Result;
//ShowMessage ('RunSQLHelper.Fini');
End; // RunSQLHelper

//-------------------------------------------------------------------------

Function SQLHLPR_CreateSQLDatabase(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_CreateSQLDatabase
//ShowMessage ('SQLHLPR_CreateSQLDatabase.Start');
  Result := RunSQLHelper(DLLParams, fnCreateSQLDatabase);
//ShowMessage ('SQLHLPR_CreateSQLDatabase.Fini');
End; // SQLHLPR_CreateSQLDatabase

//------------------------------

Function SQLHLPR_CreateSQLCompany(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_CreateSQLCompany
//ShowMessage ('SQLHLPR_CreateSQLCompany.Start');
  Result := RunSQLHelper(DLLParams, fnCreateSQLCompany);
//ShowMessage ('SQLHLPR_CreateSQLCompany.Fini');
End; // SQLHLPR_CreateSQLCompany

//------------------------------

Function SQLHLPR_SQLDataImport(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_SQLDataImport
//ShowMessage ('SQLHLPR_SQLDataImport.Start');
  Result := RunSQLHelper(DLLParams, fnSQLDataImport);
//ShowMessage ('SQLHLPR_SQLDataImport.Fini');
End; // SQLHLPR_SQLDataImport

//------------------------------

Function SQLHLPR_ImportCompData(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_ImportCompData
//ShowMessage ('SQLHLPR_ImportCompData.Start');
  Result := RunSQLHelper(DLLParams, fnSQLImportCompData);
//ShowMessage ('SQLHLPR_ImportCompData.Fini');
End; // SQLHLPR_ImportCompData

//------------------------------

Function SQLHLPR_ImportCommonData(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_ImportCommonData
//ShowMessage ('SQLHLPR_ImportCommonData.Start');
  Result := RunSQLHelper(DLLParams, fnImportCommonData);
//ShowMessage ('SQLHLPR_ImportCommonData.Fini');
End; // SQLHLPR_ImportCommonData

//------------------------------

Function SQLHLPR_ReplicateFiles(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_ReplicateFiles
//ShowMessage ('SQLHLPR_ReplicateFiles.Start');
  Result := RunSQLHelper(DLLParams, fnReplicateFiles);
//ShowMessage ('SQLHLPR_ReplicateFiles.Fini');
End; // SQLHLPR_ReplicateFiles

//------------------------------

Function SQLHLPR_InitialiseImporterJobs(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_InitialiseImporterJobs
//ShowMessage ('SQLHLPR_InitialiseImporterJobs.Start');
  Result := RunSQLHelper(DLLParams, fnInitImporterJobs);
//ShowMessage ('SQLHLPR_InitialiseImporterJobs.Fini');
End; // SQLHLPR_InitialiseImporterJobs

//------------------------------

Function SQLHLPR_ConvertData(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_ConvertData
//ShowMessage ('SQLHLPR_ConvertData.Start');
  Result := RunSQLHelper(DLLParams, fnConvertData);
//ShowMessage ('SQLHLPR_ConvertData.Fini');
End; // SQLHLPR_ConvertData

//------------------------------

Function SQLHLPR_SetupLicence(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_SetupLicence
//ShowMessage ('SQLHLPR_SetupLicence.Start');
  Result := RunSQLHelper(DLLParams, fnSetupLicence);
//ShowMessage ('SQLHLPR_SetupLicence.Fini');
End; // SQLHLPR_SetupLicence

//------------------------------

Function SQLHLPR_SetupCompanyCount(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_SetupCompanyCount
//ShowMessage ('SQLHLPR_SetupCompanyCount.Start');
  Result := RunSQLHelper(DLLParams, fnSetupCompanyCount);
//ShowMessage ('SQLHLPR_SetupCompanyCount.Fini');
End; // SQLHLPR_SetupCompanyCount

//------------------------------

Function SQLHLPR_EntCompanyWizard(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_EntCompanyWizard
//ShowMessage ('SQLHLPR_EntCompanyWizard.Start');
  Result := RunSQLHelper(DLLParams, fnEntCompanyWizard);
//ShowMessage ('SQLHLPR_EntCompanyWizard.Fini');
End; // SQLHLPR_EntCompanyWizard

//------------------------------

Function SQLHLPR_ReplicateLicence(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_ReplicateLicence
//ShowMessage ('SQLHLPR_ReplicateLicence.Start');
  Result := RunSQLHelper(DLLParams, fnReplicateLicence);
//ShowMessage ('SQLHLPR_ReplicateLicence.Fini');
End; // SQLHLPR_ReplicateLicence

//------------------------------

Function SQLHLPR_EntDataCopy(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_EntDataCopy
//ShowMessage ('SQLHLPR_EntDataCopy.Start');
  Result := RunSQLHelper(DLLParams, fnDataCopyWizard);
//ShowMessage ('SQLHLPR_EntDataCopy.Fini');
End; // SQLHLPR_EntDataCopy

//------------------------------

Function SQLHLPR_CopyMainSecurity(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_CopyMainSecurity
//ShowMessage ('SQLHLPR_CopyMainSecurity.Start');
  Result := RunSQLHelper(DLLParams, fnCopyMainSecurity);
//ShowMessage ('SQLHLPR_CopyMainSecurity.Fini');
End; // SQLHLPR_CopyMainSecurity

//------------------------------

Function SQLHLPR_ArchiveFiles(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_ArchiveFiles
//ShowMessage ('SQLHLPR_ArchiveFiles.Start');
  Result := RunSQLHelper(DLLParams, fnArchiveFiles);
//ShowMessage ('SQLHLPR_ArchiveFiles.Fini');
End; // SQLHLPR_ArchiveFiles

//------------------------------

Function SQLHLPR_GenRootLocFiles(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_GenRootLocFiles
//ShowMessage ('SQLHLPR_GenRootLocFiles.Start');
  Result := RunSQLHelper(DLLParams, fnGenRootLocFiles);
//ShowMessage ('SQLHLPR_GenRootLocFiles.Fini');
End; // SQLHLPR_GenRootLocFiles

//------------------------------

Function SQLHLPR_GenLocFiles(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_GenLocFiles
//ShowMessage ('SQLHLPR_GenLocFiles.Start');
  Result := RunSQLHelper(DLLParams, fnGenLocFiles);
//ShowMessage ('SQLHLPR_GenLocFiles.Fini');
End; // SQLHLPR_GenLocFiles

//------------------------------

Function SQLHLPR_CreateAuditTrail(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_CreateAuditTrail
  Result := RunSQLHelper(DLLParams, fnCreateAuditTrail);
End; // SQLHLPR_CreateAuditTrail

//------------------------------

Function SQLHLPR_CreateVAT100Dirs(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_CreateVAT100Dirs
  Result := RunSQLHelper(DLLParams, fnCreateVAT100Dirs);
End; // SQLHLPR_CreateVAT100Dirs

//-----------------------------------

// ABSEXCH-18512 - Example VRW Reports
Function SQLHLPR_AddDirectoryToReplicationList(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_AddDirectoryToReplicationList
  Result := RunSQLHelper(DLLParams, fnReplicateFilesInDir);
End; // SQLHLPR_AddDirectoryToReplicationList

//-----------------------------------

// MH 08/01/2018 2017-R1 ABSEXCH-19316: Initialise SQL Posting Flags
Function SQLHLPR_InitialiseSQLPostingFlags(Var DLLParams: ParamRec): LongBool;
Begin // SQLHLPR_InitialiseSQLPostingFlags
  Result := RunSQLHelper(DLLParams, fnInitialiseSQLPostingFlags);
End; // SQLHLPR_InitialiseSQLPostingFlags

//-------------------------------------------------------------------------

// Called from the Directory dialog in Setup.Dll when specifying the Main Exchequer directory
// whilst adding a company.  Checks the number of companies installed against the licence and
// returns TRUE if it is OK to add another company.
Function SQLHLPR_CheckCompanyCount(Const CompPath : ShortString) : WordBool;
Begin // SQLHLPR_CheckCompanyCount
//ShowMessage ('SQLHLPR_CheckCompanyCount.Start');
  GlobalSetupMap.FunctionId := fnCheckCompanyCount;
  GlobalSetupMap.AddVariable ('V_MAINDIR', CompPath);

  // Call the SQL Helper Function - .EXE will be in main exchequer directory
  RunApp(IncludeTrailingPathDelimiter(CompPath) + 'SQLHELPR.EXE /SQLBODGE', True);

  Result := GlobalSetupMap.Result;
//ShowMessage ('SQLHLPR_CheckCompanyCount.Fini');
End; // SQLHLPR_CheckCompanyCount

//-------------------------------------------------------------------------

Function SQLHLPR_CompanyExists(Const ExchequerPath, CompCode : ShortString) : WordBool;
Begin // SQLHLPR_CompanyExists
//ShowMessage ('SQLHLPR_CompanyExists.Start');
  GlobalSetupMap.FunctionId := fnCompanyExists;
  GlobalSetupMap.AddVariable ('V_MAINDIR', ExchequerPath);
  GlobalSetupMap.AddVariable ('V_COMPCODE', CompCode);

  // Call the SQL Helper Function - .EXE will be in main exchequer directory
  RunApp(IncludeTrailingPathDelimiter(ExchequerPath) + 'SQLHELPR.EXE /SQLBODGE', True);

  Result := GlobalSetupMap.Result;
//ShowMessage ('SQLHLPR_CompanyExists.Fini');
End; // SQLHLPR_CompanyExists

//=========================================================================

end.
