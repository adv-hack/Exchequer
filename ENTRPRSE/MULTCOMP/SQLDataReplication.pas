unit SQLDataReplication;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, WiseUtil, IniFiles;

// Called by upgrades to import data across all companies
function SCD_SQLDataImport(var DLLParams: ParamRec): LongBool; StdCall; export;

// Called by upgrades to import data to the common section
function SCD_SQLCommonDataImport(var DLLParams: ParamRec): LongBool; StdCall; export;

// Returns a StringList containing the Company Codes, returns NIL if failed to open Company.Dat.
// Calling routine is responsible for destrying StringList.
Function GetCompanyList (Const MainDirPath : String) : TStringList;

implementation

Uses GlobVar, VarConst, BtrvU2, CompUtil, GlobExch, uSQLClass, SQLUtils, ActiveX, SQLH_MemMap,
     APIUtil;

//=========================================================================

{ Checks for the Enterprise Data Files in the specified path }
Function IsValidCompany (CompPath : ShortString) : Boolean;
Begin { IsValidCompany }
  CompPath := IncludeTrailingBackSlash(Trim(CompPath));

  Result := DirectoryExists (CompPath);

  If Result Then
    Result := SQLUtils.ValidCompany(CompPath);
End; { IsValidCompany }

//-------------------------------------------------------------------------

Function GetCompanyList (Const MainDirPath : String) : TStringList;
Var
  LStatus     : SmallInt;
  KeyS        : Str255;
Begin // GetCompanyList
  { Open Company.Dat in Main Directory }
  LStatus := Open_File(F[CompF], MainDirPath + FileNames[CompF], 0);
  If (LStatus = 0) Then
  Begin
    Result := TStringList.Create;
    Try
      // Process all companies and cache details in stringlist for later usage
      KeyS := cmCompDet;
      LStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
      While (LStatus = 0) And (Company^.RecPFix = cmCompDet) Do
      Begin
        // Check the Data Set exists
        If IsValidCompany (Company.CompDet.CompPath) Then
          Result.Add(Company.CompDet.CompCode);

        LStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
      End; // While (LStatus = 0) And (DLLStatus = 0)
    Finally
      Close_File(F[CompF]);
    End; // Try..Finally
  End // If (LStatus = 0)
  Else
    Result := NIL;
End; // GetCompanyList

//-------------------------------------------------------------------------

// Called by upgrades to import data to the common section
function SCD_SQLCommonDataImport(var DLLParams: ParamRec): LongBool; StdCall; export;
Var
  W_MainDir, W_Error : String;
  DLLStatus        : LongInt;
  oCachedCompanies : TStringList;
  MMCache : TGlobalSetupData;
Begin // SCD_SQLCommonDataImport
  Try
    DLLStatus := 0;    { Unknown Error }
    W_Error := '';

    { Get directory of data to set codes in }
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    FixPath (W_MainDir);

    oCachedCompanies := GetCompanyList(W_MainDir);
    Try
      If Assigned(oCachedCompanies) Then
      Begin
        // Now run through the companies in the StringList importing the data - it is done this
        // way because we started getting error 3's on Company.Dat after calling ImportCompData
        // sometime in late Feb 08.
        If (oCachedCompanies.Count > 0) Then
        Begin
          // MH 24/04/08: Changed to call itself (SQLHelpr.Exe) in Import Company Data mode as
          // if called directly we got a .NET Broadcast Error when the .EXE unloaded.
          MMCache := GlobalSetupMap.MemMapData;
          Try
            GlobalSetupMap.FunctionId := fnSQLImportCompData;
            GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_GETCOMPCODE')].vdValue := oCachedCompanies.Strings[0];

            // Call the SQL Helper Function - .EXE will be in main exchequer directory
            RunApp(W_MainDir + 'SQLHELPR.EXE /SQLBODGE', True);

            Result := GlobalSetupMap.Result;
            If (Not Result) Then
            Begin
              // Get V_DLLERROR from SQLHelpr run
              DLLStatus := StrToIntDef(GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_DLLERROR')].vdValue, 0);
              W_Error := GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_SQLIMPORTDATA')].vdValue;
            End; // If (Not Result)
          Finally
            GlobalSetupMap.MemMapData := MMCache;
            GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_SQLIMPORTDATA')].vdValue := W_Error;
          End; // Try..Finally
        End; // If (oCachedCompanies.Count > 0)
      End // If (LStatus = 0)
      Else
        DLLStatus := 1001;
    Finally
      oCachedCompanies.Free;
    End; // Try..Finally
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // SCD_SQLCommonDataImport

//-------------------------------------------------------------------------

function SCD_SQLDataImport(var DLLParams: ParamRec): LongBool;
Var
  W_MainDir, W_SQLData         : String;
  DLLStatus, iCompany, Idx    : LongInt;
  oCachedCompanies : TStringList;
  MMCache : TGlobalSetupData;
Begin // SCD_SQLDataImport
  Try
    DLLStatus := 0;    { Unknown Error }

    { Get directory of data to set codes in }
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    FixPath (W_MainDir);

    // Get path of ZIP file to import
    GetVariable(DLLParams, 'SQL_DATA', W_SQLData);

    oCachedCompanies := GetCompanyList(W_MainDir);
    //oCachedCompanies := TStringList.Create;
    Try
      (**
      { Open Company.Dat in Main Directory }
      LStatus := Open_File(F[CompF], W_MainDir + FileNames[CompF], 0);
      If (LStatus = 0) Then
      Begin
        Try
          // Process all companies and cache details in stringlist for later usage
          KeyS := cmCompDet;
          LStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
          While (LStatus = 0) And (Company^.RecPFix = cmCompDet) And (DLLStatus = 0) Do
          Begin
            // Check the Data Set exists
            If IsValidCompany (Company.CompDet.CompPath) Then
              oCachedCompanies.Add(Company.CompDet.CompCode);

            LStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
          End; // While (LStatus = 0) And (DLLStatus = 0)
        Finally
          Close_File(F[CompF]);
        End; // Try..Finally
      **)
      If Assigned(oCachedCompanies) Then
      Begin
        // Now run through the companies in the StringList importing the data - it is done this
        // way because we started getting error 3's on Company.Dat after calling ImportCompData
        // sometime in late Feb 08.
        If (oCachedCompanies.Count > 0) Then
        Begin
          For iCompany := 0 To (oCachedCompanies.Count - 1) Do
          Begin
            // MH 24/04/08: Changed to call itself (SQLHelpr.Exe) in Import Company Data mode as
            // if called directly we got a .NET Broadcast Error when the .EXE unloaded.
            MMCache := GlobalSetupMap.MemMapData;
            Try
              GlobalSetupMap.FunctionId := fnSQLImportCompData;
              Idx := GlobalSetupMap.IndexOf('V_GETCOMPCODE');
              If (Idx > 0) Then
                GlobalSetupMap.Variables[Idx].vdValue := oCachedCompanies.Strings[iCompany]
              Else
                GlobalSetupMap.AddVariable ('V_GETCOMPCODE', oCachedCompanies.Strings[iCompany]);

              // Call the SQL Helper Function - .EXE will be in main exchequer directory
              RunApp(W_MainDir + 'SQLHELPR.EXE /SQLBODGE', True);

              Result := GlobalSetupMap.Result;
            Finally
              GlobalSetupMap.MemMapData := MMCache;
            End; // Try..Finally
          End; // For iCompany
        End; // If (oCachedCompanies.Count > 0)
      End // If (LStatus = 0)
      Else
        DLLStatus := 1001;
    Finally
      oCachedCompanies.Free;
    End; // Try..Finally
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // SCD_SQLDataImport

//=========================================================================

end.
