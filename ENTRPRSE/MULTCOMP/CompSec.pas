unit CompSec;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, WiseUtil, IniFiles;

{ Sets up the Company Count Security }
function SCD_SetupCompanyCount(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Returns the number of unique Companies in Company.Dat, -1=Error }
Function GetActualCompanyCount : LongInt; StdCall; export;

{ Returns the licenced Company Count stored in SyssCompany^ }
Function GetLicencedCompanyCount : LongInt; StdCall; export;

// Runs through the Company Data Sets in the MCM and initialise their
// CompanySynch flag to NewSynch.  BtrMode can be used to open the Exchqss.Dat
// files in exclusive mode if required.
Function ResetCompanySynchFlags (Const NewSynch : Byte; Const BtrMode : SmallInt = 0): LongInt;

{ Used by the Directory Dialog in Setup.DLL to check that a company }
{ can be added for that Company.Dat                                 }
Function Setup_CheckCompCount (Const CompPath : ShortString) : WordBool; StdCall; Export;

// Internal routine called by SQLHelp as a wrapper for Setup_CheckCompCount
Function Setup_CheckCompCountW (var DLLParams: ParamRec) : WordBool;

implementation

Uses BtrvU2, GlobVar, VarConst, VarRec2U, ETStrU, ETDateU, ETMiscU, BtKeys1U,
     SecWarn2, CompUtil, SecureU, BtSupU1, LicRec, WLicFile, HelpSupU, EntLic,
     SerialU, GlobExch, sysU3, VarFPosU, LicFuncU, ConvData, CompId, CompWDlg,
     UserSec, SecSup2U, oExchqSS, SQLUtils, oBtrieveFile;

{-------------------------------------------------------------------------}

{ Returns the licenced Company Count stored in SyssCompany^ }
Function GetLicencedCompanyCount : LongInt;
Begin { GetLicencedCompanyCount }
  With SyssCompany^.CompOpt Do
    Result := OptSecurity[ucCompanies].rcUserCount; //DeCode_Usrs(OptSecurity[ucCompanies].rcSecurity, OptSecurity[ucCompanies].rcRelease);
End; { GetLicencedCompanyCount }

{-------------------------------------------------------------------------}

// Returns the number of unique Companies in Company.Dat
//
// NOTE: Assumes Company.Dat is already open
//
Function GetActualCompanyCount : LongInt;
Begin { GetActualCompanyCount }
  Result := -1;

  With TCompanyIdCacheType.Create Do
    Try
      { Load all company details into the cache }
      BuildCache;

      { Return total number of unique Company Id's from Cache }
      //Result := CacheTotal;

      // Return total number of companies that aren't marked as Demo Data
      Result := LiveCompanies;
    Finally
      Free;
    End;
End; { GetActualCompanyCount }

{-------------------------------------------------------------------------}

{ Used by the Directory Dialog in Setup.DLL to check that a company }
{ can be added for that Company.Dat                                 }
Function Setup_CheckCompCount (Const CompPath : ShortString) : WordBool;
Var
  DLLStatus         : LongInt;
  LStatus, CompCnt  : SmallInt;

Ver        :  Integer;
Rev        :  Integer;
Typ        :  Char;
DumBlock   :  BtrvU2.FileVar;
Begin { Setup_CheckCompCount }
  DLLStatus := 0;
  Result := False;

  { Check Btrieve is running - often comes in handy :-) }
  //If Check4BtrvOk Then Begin
  If GetBtrvVer(DumBlock,Ver,Rev,Typ,1) Then
  Begin
//ShowMessage ('Ver: ' + IntToStr(Ver) + '.' + IntToStr(Rev) + Typ);  
    { Open Company.Dat in Main Directory }
    LStatus := Open_File(F[CompF], CompPath + FileNames[CompF], 0);
    If (LStatus = 0) Then Begin
      { Load company Security Dets }
      LoadCompanyOpt;

      { Get number of companies already in Company.Dat }
      CompCnt := GetActualCompanyCount;

      { Return TRUE if got spare slots which can be used }
      Result := (CompCnt < GetLicencedCompanyCount);

      { Close company.Dat }
      Close_File(F[CompF]);
    End { If }
    Else
      { Btrieve Error opening Company.Dat }
      DLLStatus := 10000 + LStatus;

    {--------------------}

  End { If }
  Else
    { Btrieve Not Running }
    DLLStatus := 1002;

  If (DLLStatus <> 0) Then
    MessageDlg('The following error occured checking the Company Count Security:-' +
               #13#13 + 'Status: ' + IntToStr(DLLStatus), mtWarning, [mbOK], 0);
End; { Setup_CheckCompCount }

//------------------------------

Function Setup_CheckCompCountW (var DLLParams: ParamRec) : WordBool;
Var
  W_MainDir : ANSIString;
Begin // Setup_CheckCompCountW
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  Result := Setup_CheckCompCount(W_MainDir);
End; // Setup_CheckCompCountW

{-------------------------------------------------------------------------}

// Runs through the Company Data Sets in the MCM and initialise their
// CompanySynch flag to NewSynch.  BtrMode can be used to open the Exchqss.Dat
// files in exclusive mode if required.
//
// Return Values:-
//   0             AOK
//   10200-10299   Error Opening ExchQSS.Dat in the specified mode
//   10400..10499  Error calling GetEqual for ModRR
//   10500..10599  Error calling Lock for ModRR
//   10600..10699  Error calling Update for ModRR
Function ResetCompanySynchFlags (Const NewSynch : Byte; Const BtrMode : SmallInt = 0): LongInt;
Const
  FNum    = CompF;
  KeyPath : Integer = CompPathK;
Var
  TmpComp              : ^CompRec;
  TmpRecAddr           : LongInt;
  TmpKPath, TmpStat    : Integer;
  KeyS, SysKey, FPath  : Str255;
  LStatus              : Smallint;
  SLocked              : Boolean;
  oExchqSSFile         : TExchqSSFile;
  sErr                 : ShortString;
Begin { ResetCompanySynchFlags }
  Result := 0;

  { Save starting position and record in Company.Dat }
  New (TmpComp);
  TmpComp^ := Company^;
  TmpKPath:=GetPosKey;
  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  { Process all companies }
  LStatus := Find_Rec(B_StepFirst, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
  While (LStatus = 0) And (Result = 0) Do
  Begin
    sErr := '';

    // Check its a Company Record
    If (Company.RecPFix = cmCompDet) Then
    Begin
      sErr := '(Comp:' + Company.CompDet.CompPath + ') ';

      // Check the Data Set exists
      If IsValidCompany (Company.CompDet.CompPath) Then
      Begin
        // ensure company dir path is formatted correctly
        FPath := IncludeTrailingBackslash(Trim(Company.CompDet.CompPath));

        // MH 12/11/07: Rewrite to use Client Id for SQL Compatibility
        oExchqSSFile := TExchqSSFile.Create;
        Try
          LStatus := oExchqSSFile.OpenFile (FPath + FileNames[SysF], False);
          If (LStatus = 0) Then
          Begin
            KeyS := SysNames[ModRR];
            LStatus := oExchqSSFile.GetEqual(KeyS);
            If (LStatus = 0) Then
            Begin
              // Lock
              LStatus := oExchqSSFile.Lock;
              If (LStatus = 0) Then
              Begin
                SyssMod^ := oExchqSSFile.SysMod;
                SyssMod^.ModuleRel.CompanySynch := NewSynch;
                oExchqSSFile.SysMod := SyssMod^;
                LStatus := oExchqSSFile.Update;
                If (LStatus <> 0) Then
                Begin
                  Result := 10600 + LStatus;
                  sErr := sErr + '(Upd:' + IntToStr(LStatus) + ') ';
                End; // If (LStatus <> 0)
              End // If (LStatus = 0)
              Else
              Begin
                Result := 10500 + LStatus;
                sErr := sErr + '(Lock:' + IntToStr(LStatus) + ') ';
              End; // Else
            End // If (LStatus = 0)
            Else
            Begin
              Result := 10400 + LStatus;
              sErr := sErr + '(GetEq:' + IntToStr(LStatus) + ') ';
            End; // Else
          End // If (LStatus = 0)
          Else
          Begin
            Result := 10200 + LStatus;
            sErr := sErr + '(Open:' + IntToStr(LStatus) + ') ';
          End; // Else
        Finally
          oExchqSSFile.Free;
        End; // Try..Finally

        (*
        // Open ExchQss.Dat in the Company Data Set
        LStatus := Open_File(F[SysF], FPath + FileNames[SysF], BtrMode);
        If (LStatus = 0) Then Begin
          // Get ModRR
          SLocked := True;
          If GetMultiSys(False, SLocked, ModRR) Then Begin
            SyssMod^.ModuleRel.CompanySynch := NewSynch;
            PutMultiSys(ModRR, True);
          End { If GetMultiSys }
          Else
            Result := 10400;

          { Close ExchQSS.Dat }
          Close_File(F[SysF]);
        End { If (LStatus = 0) }
        Else
          Result := 10200 + LStatus;
        *)
      End; { If IsValidCompany (... }
    End; // If (Company.RecPFix = cmCompDet)

    LStatus := Find_Rec(B_StepNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
  End; { While (LStatus = 0) }

  { restore company rec and pos }
  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);
  Company^ := TmpComp^;
  Dispose (TmpComp);

  If (Result <> 0) And (sErr <> '') Then
    MessageDlg ('ResetCompanySynchFlags: ' + IntToStr(Result) + ' - ' + sErr, mtError, [mbOK], 0);
End; { ResetCompanySynchFlags }

{-------------------------------------------------------------------------}

// Sets up the Company Count Security, all existing company records will
// have their CID checked and Set if required, and the Company Count
// Release Codes in Company.Dat will be updated.
//
// Errors:-
//   1000          Unknown Exception
//   1001          Incorrect security parameter
//   1002          Btrieve Not Running
//   1003          Missing Licence File
//   1004          Failed to read Licence File
//   1005          Error Writing Enterprise Licence
//   1006          Error reading Enterprise Licence
//
//   10000-10099   Btrieve Error Opening Company.Dat
//   10100-10199   Btrieve Error Updating MCM Setup Record
//
//  Stage1:
//   10200-10299   Btrieve Error Opening ExchQss.Dat in Company Data Set
//   10300-10399   Btrieve Error Reading ModRR from ExchQss.Dat in Company Data Set
//   10400-10499   Btrieve Error Updating ModRR from ExchQss.Dat in Company Data Set
//
//  Stage2:
//   11200-11299   Btrieve Error Opening ExchQss.Dat in Company Data Set
//   11300-11399   Btrieve Error Reading ModRR from ExchQss.Dat in Company Data Set
//   11400-11499   Btrieve Error Updating ModRR from ExchQss.Dat in Company Data Set
//   11500-11599   Btrieve Error Reading SysR from ExchQss.Dat in Company Data Set
//   11600-11699   Btrieve Error Updating SysR from ExchQss.Dat in Company Data Set
//
//  Stage3:
//   12200-12299   Btrieve Error Opening ExchQss.Dat in Company Data Set
//   12300-12399   Btrieve Error Reading ModRR from ExchQss.Dat in Company Data Set
//   12400-12499   Btrieve Error Updating Company Record in Company.Dat
//
Function SCD_SetupCompanyCount(var DLLParams: ParamRec): LongBool; StdCall; export;
Var
  W_MainDir                  : String;
  DLLStatus, CompCnt         : LongInt;
  LStatus                    : SmallInt;
  Params                     : ANSIString;
  EntLicR                    : EntLicenceRecType;
  ErrorSection, PrevES, sErr : ShortString;

  //--------------------------------------------------------

  Function GetCompanyCount : LongInt;
  Begin { GetCompanyCount }
    PrevES := ErrorSection; ErrorSection := '(GCC)';
    Result := 0;

    { Read Enterprise Licence file (Entrprse.Dat) }
    If (Not ReadEntLic (W_MainDir + EntLicFName, EntLicR)) Then
      { Error reading Enterprise Licence }
      DLLStatus := 1006;

    If (Result = 0) Then Begin
      { Check Company Count is set - should be OK but you never know! }
      If (EntLicR.licUserCounts[ucCompanies] = 0) Then Begin
        EntLicR.licUserCounts[ucCompanies] := 5;

        { Update Enterprise Licence with new Company Count }
        If Not WriteEntLic (W_MainDir + EntLicFName, EntLicR) Then
          Result := 1005;
      End; { Else }
    End; { If (Result = 0) }

    ErrorSection := PrevES;
  End; { GetCompanyCount }

  //--------------------------------------------------------

  { Generates the final User Release Code }
  Function Gen_UsrRelCode (SecStr  :  Str20;
                           NoUsrs  :  LongInt)  :  Str20;
  Var
    SecNo  :  LongInt;
  Begin { Gen_UsrRelCode }
    PrevES := ErrorSection; ErrorSection := '(GUSR)';

    SecNo:=Calc_Security(SecStr,BOff);

    If (SecNo>MaxUsrRel) then
      SecNo:=MaxUsrRel;

    SecNo:=SecNo+(NoUsrs*UsrSeed);

    Gen_UsrRelCode:=Calc_SecStr(SecNo,BOn);

    ErrorSection := PrevES;
  End; { Gen_UsrRelCode }

  //--------------------------------------------------------

  // MH 08/06/2015 v7.0.14 ABSEXCH-16490: Added <COMPCODE>.Company flag files into each company
  // directory so the SQL UNC support can validate the pathing
  Procedure SetupCompanyCodeFlagFile (Const Company : CompanyDetRec);
  Var
    NetFInfo : TSearchRec;
    SrchRes  : Integer;
    sCompanyDir : ShortString;
  Begin // SetupCompanyCodeFlagFile
    sCompanyDir := IncludeTrailingPathDelimiter(Trim(Company.CompPath));
    If DirectoryExists(sCompanyDir) Then
    Begin
      // Delete any pre-existing flag files
      Try
        SrchRes := FindFirst(sCompanyDir + '*.Company', faAnyFile, NetFInfo);
        Try
          While (SrchRes = 0) Do
          Begin
            SysUtils.DeleteFile (sCompanyDir + NetFInfo.Name);

            SrchRes := FindNext(NetFInfo);
          End; // While (SrchRes = 0)
        Finally
          FindClose (SrchRes);
        End;
      Except
        On Exception Do
          ;
      End;

      // Create a new flag file
      With TIniFile.Create(sCompanyDir + Trim(Company.CompCode) + '.Company') Do
      Begin
        Try
          WriteString('CompanyDetails', 'Code', Trim(Company.CompCode));
          WriteString('CompanyDetails', 'Path', Trim(Company.CompPath));
        Finally
          Free;
        End; // Try..Finally
      End; // With TIniFile.Create(sCompanyDir + Trim(Company.CompCode) + '.Company')
    End; // If DirectoryExists(sCompanyDir)
  End; // SetupCompanyCodeFlagFile

  //--------------------------------------------------------

  // Init the CompAnal flags used by the MCM Company list to zero
  Procedure InitAnalFlags;
  Var
    KeyS     : Str255;
    LStatus  : Smallint;
  Begin { InitAnalFlags }
    PrevES := ErrorSection; ErrorSection := '(IAF)';

    KeyS := cmCompDet;
    LStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    While (LStatus = 0) And (Company^.RecPFix = cmCompDet) Do Begin
      // MH 08/06/2015 v7.0.14 ABSEXCH-16490: Added <COMPCODE>.Company flag files into each company
      // directory so the SQL UNC support can validate the pathing
      SetupCompanyCodeFlagFile (Company^.CompDet);

      Company^.CompDet.CompAnal := 0;

      LStatus := Put_Rec(F[CompF], CompF, RecPtr[CompF]^, CompCodeK);

      LStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    End; { While ... }

    ErrorSection := PrevES;
  End; { InitAnalFlags }

  //--------------------------------------------------------

  // Stage 1: Run through the Company Data Sets in the MCM and initialise
  //          the CompanySynch flag to 0 for stage 2
  Function InitSynchFlags : LongInt;
  {Var
    KeyS, SysKey, FPath  : Str255;
    LStatus              : Smallint;}
  Begin { InitSynchFlags }
    PrevES := ErrorSection; ErrorSection := '(ISF)';

    // Reset the Company Synch flags to zero, opening each ExchQSS.Dat exlusively
    Result := ResetCompanySynchFlags (0, -4);

    (*
    Result := 0;

    LStatus := Find_Rec(B_StepFirst, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    While (LStatus = 0) And (Result = 0) Do Begin
      // Check its a Company Record
      If (Company.RecPFix = cmCompDet) Then
        // Check the Data Set exists
        If IsValidCompany (Company.CompDet.CompPath) Then Begin
          // ensure company dir path is formatted correctly
          FPath := IncludeTrailingBackslash(Trim(Company.CompDet.CompPath));

          // Open ExchQss.Dat in the Company Data Set
          LStatus := Open_File(F[SysF], FPath + FileNames[SysF], -4);
          If (LStatus = 0) Then Begin
            // Get ModRR
            SysKey := SysNames[ModRR];
            LStatus := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, SysK, SysKey);
            If (LStatus = 0) Then Begin
              { Copy record into dupli record and reset CompanySynch }
              Move (Syss, SyssMod^, SizeOf(SyssMod^));
              SyssMod^.ModuleRel.CompanySynch := 0;
              Move (SyssMod^, Syss, SizeOf(SyssMod^));

              { Update ModRR }
              DLLStatus := Put_Rec(F[SysF],SysF,RecPtr[SysF]^,SysK);
              If (DLLStatus <> 0) Then DLLStatus := 10400 + DLLStatus;
            End { If (LStatus = 0) }
            Else
              Result := 10300 + LStatus;

            { Close ExchQSS.Dat }
            Close_File(F[SysF]);
          End { If (LStatus = 0) }
          Else
            Result := 10200 + LStatus;
        End; { If IsValidCompany (... }

      LStatus := Find_Rec(B_StepNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    End; { While (LStatus = 0) }
    *)

    ErrorSection := PrevES;
  End; { InitSynchFlags }

  //--------------------------------------------------------

  // Stage 2: Run through the Company Data Sets in the MCM and check that the
  //          Company Id's are valid
  Function CheckCompanyIds : LongInt;
  Var
    oCompId              : TCompanyIdCacheType;
    KeyS, SysKey, FPath  : Str255;
    LStatus              : Smallint;
  Begin { CheckCompanyIds  }
    PrevES := ErrorSection; ErrorSection := '(ChkCID)';

    Result := 0;

    oCompId := TCompanyIdCacheType.Create;
    Try
      LStatus := Find_Rec(B_StepFirst, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
      While (LStatus = 0) And (Result = 0) Do Begin
        // Check its a Company Record
        If (Company.RecPFix = cmCompDet) Then
          // Check the Data Set exists
          If IsValidCompany (Company.CompDet.CompPath) Then Begin
            // ensure company dir path is formatted correctly
            FPath := IncludeTrailingBackslash(Trim(Company.CompDet.CompPath));

            // Open ExchQss.Dat in the Company Data Set
            // MH 16/06/08: Modified to open file normally as difficult to get everyone out in SQL
            //LStatus := Open_File(F[SysF], FPath + FileNames[SysF], -4);
            LStatus := Open_File(F[SysF], FPath + FileNames[SysF], 0);
            If (LStatus = 0) Then Begin
              // Get SysR - Reset Logged in User Count
              SysKey := SysNames[SysR];
              LStatus := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, SysK, SysKey);
              If (LStatus = 0) Then Begin
                { Update SysR }
                Syss.EntULogCount := 0;
                DLLStatus := Put_Rec(F[SysF],SysF,RecPtr[SysF]^,SysK);
                If (DLLStatus <> 0) Then DLLStatus := 11600 + DLLStatus;
              End { If (LStatus = 0)  }
              Else
                // Error reading sysR
                Result := 11500 + LStatus;

              If (Result = 0) Then Begin
                // Get ModRR - Check Company Id
                SysKey := SysNames[ModRR];
                LStatus := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, SysK, SysKey);
                If (LStatus = 0) Then Begin
                  { Copy record into dupli record and Check Company Id }
                  Move (Syss, SyssMod^, SizeOf(SyssMod^));

                  With SyssMod^.ModuleRel Do Begin
                    { Check Company Id is set correctly }
                    If (CompanyId = 0) Then
                      { Company Id not set - generate new Company Id }
                      CompanyId := oCompId.GenCompId
                    Else
                      { Check to see if CID exists in the CID cache }
                      If oCompId.CheckExists(CompanyId) Then
                        { Company Id already exists - check to see if CompanySynch is correct }
                        If (CompanySynch <> 1) Then
                          { Duplicate Company with same Company Id - Change company Id }
                          CompanyId := oCompId.GenCompId;

                    { Add Company Id into the cache }
                    oCompId.AddToCache (CompanyId);

                    { Set CompanySynch to indicate it has been processed }
                    CompanySynch := 1;

                    { Reset Toolkit and Trade Counter user count }
                    TKLogUCount := 0;
                    TrdLogUCount := 0;
                  End; { With SyssMod^.ModuleRel }

                  { Update ModRR }
                  Move (SyssMod^, Syss, SizeOf(SyssMod^));
                  DLLStatus := Put_Rec(F[SysF],SysF,RecPtr[SysF]^,SysK);
                  If (DLLStatus <> 0) Then DLLStatus := 11400 + DLLStatus;
                End { If (LStatus = 0) }
                Else
                  // Error reading ModRR
                  Result := 11300 + LStatus;
              End; { If (Result = 0)  }

              { Close ExchQSS.Dat }
              Close_File(F[SysF]);
            End { If (LStatus = 0) }
            Else
              // Error opening SysF in Company Data Set
              Result := 11200 + LStatus;
          End; { If IsValidCompany (... }

        LStatus := Find_Rec(B_StepNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
      End; { While (LStatus = 0) }
    Finally
      FreeAndNil(oCompId);
    End;

    ErrorSection := PrevES;
  End; { CheckCompanyIds  }

  //--------------------------------------------------------

  // Stage 3: Run through the Company Data Sets copying the Company Id's
  //          down into the MCM Company Records.
  Function ImportCompanyIds : LongInt;
  Var
    KeyS, SysKey, FPath  : Str255;
    LStatus              : Smallint;
  Begin { ImportCompanyIds }
    PrevES := ErrorSection; ErrorSection := '(ImpCID)';

    Result := 0;

    KeyS := cmCompDet;
    LStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    While (LStatus = 0) And (Result = 0) And (Company^.RecPFix = cmCompDet) Do Begin
      // Check the Data Set exists
      If IsValidCompany (Company.CompDet.CompPath) Then Begin
        // ensure company dir path is formatted correctly
        FPath := IncludeTrailingBackslash(Trim(Company.CompDet.CompPath));

        // Open ExchQss.Dat in the Company Data Set
        LStatus := Open_File(F[SysF], FPath + FileNames[SysF], 0);
        If (LStatus = 0) Then Begin
          // Get ModRR
          SysKey := SysNames[ModRR];
          LStatus := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, SysK, SysKey);
          If (LStatus = 0) Then Begin
            { Copy record into dupli record for access }
            Move (Syss, SyssMod^, SizeOf(SyssMod^));

            { Compy Company Id from data set into MCM Company Record }
            Company.CompDet.CompId := SyssMod^.ModuleRel.CompanyId;

            { Update Company Record in MCM }
            DLLStatus := Put_Rec (F[CompF], CompF, RecPtr[CompF]^, CompCodeK);
            If (DLLStatus <> 0) Then DLLStatus := 12400 + DLLStatus;
          End { If (LStatus = 0) }
          Else
            Result := 12300 + LStatus;

          { Close ExchQSS.Dat }
          Close_File(F[SysF]);
        End { If (LStatus = 0) }
        Else
          Result := 12200 + LStatus;
      End; { If IsValidCompany (... }

      LStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    End; { While (LStatus = 0) }

    ErrorSection := PrevES;
  End; { ImportCompanyIds }

  //--------------------------------------------------------
//  function bytearraytostr(pByte: array of byte): string;
//  var
//    lCont: Integer;
//  begin
//    result := '';
//    for lCont:= Low(pByte) to high(pByte) do
//      result := result + ' ' + inttostr(pByte[lCont]);
//  end; {function bytearraytostr(pByte: array of byte): string;}

Begin { SCD_SetupCompanyCount }
  sErr := '';
  ErrorSection := '(SCC)';
  Try
    DLLStatus := 0;    { Unknown Error }

    { Check security parameter to ensure not called by anyone }
    Params := DLLParams.szParam;
    If (Copy (Params, 1, 5) = 'FCK98') And (Length(Params) = 5) Then Begin
      { Check Btrieve is running - often comes in handy :-) }
      If Check4BtrvOk Then
      Begin

        {--------------------}

        { Get directory of data to set codes in }
        GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
        FixPath (W_MainDir);

        { Setup path of help file }
        Application.HelpFile := W_MainDir + 'ENTRPRSE.HLP';

        {--------------------}

        ErrorSection := '(SCC2)';

        { Open Company.Dat in Main Directory }
        // MH 16/06/08: Modified for alternate exclusivity test under SQL
        If SQLUtils.UsingSQL Then
        Begin
          If SQLUtils.ExclusiveAccess(W_MainDir) Then
            LStatus := Open_File(F[CompF], W_MainDir + FileNames[CompF], 0)
          Else
            LStatus := 3;
        End // If SQLUtils.UsingSQL
        Else
          LStatus := Open_File(F[CompF], W_MainDir + FileNames[CompF], -4);

        If (LStatus = 0) Then Begin
          //
          // Define the Owner Name to encrypt the file
          //
          ErrorSection := '(SCC3)';
          If Assigned(OwnerName) Then Begin
            LStatus := CtrlBOwnerName(F[CompF], False, 2);
            If (LStatus <> 0) And (LStatus <> 50) Then
              MessageDlg ('An Error ' + IntToStr(LStatus) + ' occurred updating the Company Security Detail',
                          mtInformation, [mbOk], 0);
          End; { If Assigned(OwnerName) }

          //
          // Init the CompAnal flags to zero
          //
          InitAnalFlags;

          //
          // Add the Licence Details into the MCM Setup Record
          //

          { Load the MCM Setup record (creating if necessary) }
          ErrorSection := '(SCC4)';
          LoadCompanyOpt;

          { Determine Correct Licence count for this Install Type }
          DLLStatus := GetCompanyCount;
          sErr := sErr + '(GCC: ' + IntToStr(DllStatus) + ') ';

          If (DLLStatus = 0) Then Begin
            ErrorSection := '(SCC5)';

            { Update the MCM Setup Record with the relevent release codes }
            With EntLicR, Company^.CompOpt Do Begin
              { Company Count }
              Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
              // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
              //CurSecy := Set_Security;
              With OptSecurity[ucCompanies] Do Begin
                rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 253, 0, 1);
                //rcSecurity := Calc_SecStr(CurSecy, False);
                rcUserCount := licUserCounts[ucCompanies];
              End; { With OptSecurity[ucCompanies] }

              //showmessage(bytearraytostr(optSystemESN) + '  ' + bytearraytostr(licISN));

              ErrorSection := '(SCC6)';

              { Check to see if Company ESN is not set, and the licence ESN is set }
              If (Not licESNSet(ESNByteArrayType(optSystemESN))) And licESNSet(licISN) Then
                { Company ESN not set - initialise to licence ESN }
                optSystemESN := ISNArrayType(licISN);

              //showmessage(bytearraytostr(optSystemESN) + '  ' + bytearraytostr(licISN));
              ErrorSection := '(SCC7)';

              { Global Enterprise User Count }
              Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
              // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
              //CurSecy  := Set_Security;
              //OptEntUserSecurity := Calc_SecStr(CurSecy, False);
              OptEntUserSecurity := Generate_ESN_BaseSecurity (optSystemESN, 254, 0, 0);
              OptEntUserRelease := Gen_UsrRelCode(OptEntUserSecurity,licUserCnt);
              OptEntUserExpiry := 0;

              ErrorSection := '(SCC8)';

              { Global Enterprise 30-Day User Count }
              // Not Currently Supported by the Setup Program - manual only via telephone
              // Leave any pre-existing 30-Day user count intact
              If (Trim(OptSecurity[ucEnterprise30].rcSecurity) = '') Then
                With OptSecurity[ucEnterprise30] Do Begin
                  // Initialise 30-Day User Count settings
                  Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
                  // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
                  //CurSecy := Set_Security;
                  //rcSecurity := Calc_SecStr(CurSecy, False);
                  rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 247, 0, 0);
                  rcUserCount := 0;
                  rcExpiry := 0;
                End; { With OptSecurity[ucEnterprise30] }

              ErrorSection := '(SCC9)';

              // Toolkit Full User Count ---------------------------------------
              With OptSecurity[ucToolkitFull] Do Begin
                { Calculate new Security Code }
                Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
                // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
                //CurSecy := Set_Security;
                //rcSecurity := Calc_SecStr(CurSecy, False);
                rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 4, 0, 1);
                { If Toolkit is licenced and there is a full user count then set the user count }
                If ((licModules[modToolDLL] > 0) Or (EntLicR.licModules[modToolDLLR] > 0)) And (licUserCounts[ucToolkitFull] > 0) Then
                  rcUserCount := licUserCounts[ucToolkitFull]
                Else
                  rcUserCount := 0;
                rcExpiry := 0;  // Not Currently Used
              End; { With OptSecurity[ucToolkitFull] }

              ErrorSection := '(SCC10)';

              // Toolkit 30-Day User Count ---------------------------------------
              With OptSecurity[ucToolkit30] Do Begin
                { Calculate new Security Code }
                Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
                // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
                //CurSecy := Set_Security;
                //rcSecurity := Calc_SecStr(CurSecy, False);
                rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 1004, 0, 1);
                { If Toolkit is licenced and there is a full user count then set the user count }
                If ((licModules[modToolDLL] > 0) Or (EntLicR.licModules[modToolDLLR] > 0)) And (licUserCounts[ucToolkit30] > 0) Then
                  rcUserCount := licUserCounts[ucToolkit30]
                Else
                  rcUserCount := 0;

                rcExpiry := CalcNewRelDate (30);
              End; { With OptSecurity[ucToolkit30] }

              ErrorSection := '(SCC11)';

              // Trade Counter User Count ---------------------------------------
              With OptSecurity[ucTradeCounter] Do Begin
                { Calculate new Security Code }
                Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
                // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
                //CurSecy := Set_Security;
                //rcSecurity := Calc_SecStr(CurSecy, False);
                rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 11, 0, 1);
                { If Trade Counter is licenced and there is a user count then generate a release code }
                If (licModules[modTrade] > 0) And (licUserCounts[ucTradeCounter] > 0) Then
                  rcUserCount := licUserCounts[ucTradeCounter]
                Else Begin
                  rcUserCount := 0;
                End; { Else }
                rcExpiry := 0;  // Not Currently Used
              End; { With OptSecurity[ucTradeCounter] }

              ErrorSection := '(SCC12)';

              // Elerts Sentinel Count -------------------------------------
              With OptSecurity[ucElerts] Do Begin
                { Calculate new Security Code }
                Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
                // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
                //CurSecy := Set_Security;
                //rcSecurity := Calc_SecStr(CurSecy, False);
                rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 14, 0, 1);
                { If Elerts is licenced and there is a Sentinel count then generate a release code }
                If (licModules[modElerts] > 0) And (licUserCounts[ucElerts] > 0) Then
                  rcUserCount := licUserCounts[ucElerts]
                Else
                  rcUserCount := 0;
                rcExpiry := 0;  // Not Currently Used
              End; { With OptSecurity[ucElerts] }
            End; { With }

            ErrorSection := '(SCC13)';

            { Update the file }
            DLLStatus := Put_Rec(F[CompF],CompF,RecPtr[CompF]^,CompCodeK);
            If (DLLStatus <> 0) Then DLLStatus := 10100 + DLLStatus;
            sErr := sErr + '(PutComp: ' + IntToStr(DllStatus) + ') ';

            //showmessage('status: ' + inttostr(DLLStatus));
          End; { If (DLLStatus = 0) }

          ErrorSection := '(SCC14)';

          //
          // Check the Company Records and Company Data Sets
          //
          If (DLLStatus = 0) Then Begin
            { Stage1: Initialise all Company Synch flags to 0 }
            DLLStatus := InitSynchFlags;
            sErr := sErr + '(IS: ' + IntToStr(DllStatus) + ') ';

            If (DLLStatus = 0) Then
            Begin
              { Stage2: Check the Company Id's in all Company Data Sets }
              DLLStatus := CheckCompanyIds;
              sErr := sErr + '(CheckCID: ' + IntToStr(DllStatus) + ') ';
            End; // If (DLLStatus = 0)

            If (DLLStatus = 0) Then
            Begin
              { Stage3: Copy all Company Id's down into the MCM Company Records }
              DLLStatus := ImportCompanyIds;
              sErr := sErr + '(ImportCID: ' + IntToStr(DllStatus) + ') ';
            End; // If (DLLStatus = 0)

            ErrorSection := '(SCC15)';

            If (DLLStatus = 0) Then
              { Remove any pre-existing user xref records from Company.Dat }
              RemoveCIDLoginRef (0);
          End; { If (DLLStatus = 0) }

          ErrorSection := '(SCC16)';

          //
          // Count the Unique Company Records and Display an annoying warning if > Licenced
          //
          CompCnt := GetActualCompanyCount;
          ErrorSection := '(SCC16a)';
          If (CompCnt > EntLicR.licUserCounts[ucCompanies]) Then
          Begin
            ErrorSection := '(SCC16b)';
            DisplayCompCountWarning (CompCnt, EntLicR.licUserCounts[ucCompanies]);
          End; // If (CompCnt > EntLicR.licUserCounts[ucCompanies])

          ErrorSection := '(SCC17)';

          { Close company.Dat }
          Close_File(F[CompF]);
        End { If }
        Else
        Begin
          { Btrieve Error opening Company.Dat }
          DLLStatus := 10000 + LStatus;
          sErr := sErr + '(OpenComp: ' + IntToStr(DllStatus) + ') ';
        End; // Else

        {--------------------}

        ErrorSection := '(SCC18)';

      End { If }
      Else Begin
        { Btrieve Not Running }
        DLLStatus := 1002;
      End; { Else }
    End { If }
    Else Begin
      { Incorrect security parameter }
      DLLStatus := 1001;
    End; { Else }
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex, ErrorSection);
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);

  If Result And (Trim(sErr) <> '') Then
    MessageDlg ('SCD_SetupCompanyCount: ' + sErr, mtError, [mbOK], 0);
End; { SCD_SetupCompanyCount }

{-------------------------------------------------------------------------}


end.
