unit ReplSysF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, WiseUtil;


{ Replications the licencing details around the various companies in the MCM }
function SCD_ReplicateLicence(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Replicates setup details from SysR and ModrR in W_FromDir to all companies }
{ with matching ISN in the COMPANY.DAT in W_CompDir.                         }
{ Note: Calls REPLICATEENTLICENCE2 with ResetCountry=False                   }
Function REPLICATEENTLICENCE (Const W_CompDir : ShortString; Var W_ErrDir : ShortString) : LongInt; StdCall; export;

{ Replicates setup details from SysR and ModrR in W_FromDir to all companies }
{ with matching ISN in the COMPANY.DAT in W_CompDir.                         }
Function REPLICATEENTLICENCE2 (Const W_CompDir              : ShortString;
                               Var   W_ErrDir               : ShortString;
                               Const ResetCountry,
                                     ResetESN,
                                     CopyPaperless,
                                     CheckFileSizes         : Boolean) : LongInt;

implementation


Uses GlobVar, VarConst, BtrvU2, EtDateU, EtMiscU, EtStrU, BtKeys1U, CompUtil, IniFiles,
     GlobExcH, BtSupU1, TCompObj, SerialU, SysU3, LicRec, WLicFile, VarFPosU,
     EntLic, LicFuncU, SecSup2U, HelpSupU, ModRels,
{$IFDEF SQLHELPER}
     CreateAuditTrail,
{$ENDIF}
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     ChkSizeF;     // Data File Size checking routine


{ Replicates the licencing details around the various companies in the MCM }
//
//  1000        Unknown Error
//  1001        Unknown Exception
//  1002        Incorrect security parameter
//  1003        Btrieve Not Running
//  1004        Unknown Error reading SysR
//  1005        Unknown Error reading ModR
//  1006        Unknown Error reading EDI2R
//  1100..1199  Error Opening Exchqss.dat
//  1200..1299  Error opening Company.Dat
//  1300..1399  Error Opening SysF in Company
//  1400..1499  Error Opening PwrdF in Company
//  1500..1599  Error Locking SysR in company
//  1600..1699  Error Locking ModR in company
//  1700..1799  Error Locking EDI2R in company
//  1800        Unknown Error updating ESN in Company.Dat
//  1801..1898  Error reading Setup in Company.Dat
//  1899        Error Locking Setup in Company.Dat
//  1900        Error Updating Setup in Company.Dat
function SCD_ReplicateLicence(var DLLParams: ParamRec): LongBool; StdCall; export;
Var
  TempLicR                         : CDLicenceRecType;
  DLLStatus                        : LongInt;
  WiseStr, W_InstMod, Params,
  W_LicType, W_LicFile, W_MainDir  : ANSIString;
  W_MainDirs                       : ShortString;
  ResetCountry, ReplPaper          : Boolean;
Begin { SCD_ReplicateLicence }
  Params := DLLParams.szParam;

  { Check security parameter to ensure not called by anyone }
  If (Copy (Params, 1, 7) = 'BNO38SG') And (Length(Params) = 7) Then Begin
    ResetCountry := False;
    ReplPaper    := False;

    { Get directory of main company }
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    FixPath (W_MainDir);

    { Get Installation Type from WISE - 0=Install, 1=Upgrade, 2=Auto-Upgrade }
    GetVariable(DLLParams, 'I_TYPE', W_LicType);
    If (UpperCase(Trim(W_LicType)) = '1') Then Begin
      { Upgrade - Get Temporary Licence File }
      GetVariable(DLLParams, 'I_LICFILE', W_LicFile);
      If FileExists (W_LicFile) Then Begin
        { Read ~VBxxx.TMP from Temporary Directory }
        If ReadLicFile (W_LicFile, TempLicR) Then Begin
          ResetCountry := TempLicR.licResetCountry;
        End; { If ReadLicFile (W_LicFile, TempLicR) }
      End; { If }
    End; { If (UpperCase(Trim(W_LicType)) = '1') }

    GetVariable(DLLParams, 'V_INSTTYPE', WiseStr);
    If (WiseStr = 'B') Then Begin
      { Check to see if Paperless settings (Email Addr, etc...) need to be replicated }
      GetVariable(DLLParams, 'V_INSTMOD', W_InstMod);
      If (Pos('J', W_InstMod) > 0) Then Begin
        { Paperless Module being installed }
        GetVariable(DLLParams, 'VP_STATUS', WiseStr);
        ReplPaper := (WiseStr = '2');
      End; { If (Pos('J', W_InstMod) > 0) }
    End; { If (WiseStr = 'B')  }

    W_MainDirs := W_MainDir;
    DLLStatus := ReplicateEntLicence2 (W_MainDirs, W_MainDirs, ResetCountry, False, ReplPaper, True);
  End { If }
  Else Begin
    { Incorrect security parameter }
    DLLStatus := 1002;
  End; { Else }

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_ReplicateLicence }


{-----------------------------------------------------------------------------}


{ Replicates setup details from SysR and ModrR in W_FromDir to all companies }
{ with matching ISN in the COMPANY.DAT in W_CompDir.                         }
Function REPLICATEENTLICENCE2 (Const W_CompDir              : ShortString;
                               Var   W_ErrDir               : ShortString;
                               Const ResetCountry,
                                     ResetESN,
                                     CopyPaperless,
                                     CheckFileSizes         : Boolean) : LongInt;
Var
  LicR              : EntLicenceRecType;
  DLLStatus         : LongInt;
  LocEDI2,
  LocSys,
  LocMod            : ^Sysrec;
  LStatus           : Integer;
  KeyS              : Str255;
  W_FromDir         : String;
  L_ErrDir          : ShortString;
  ResetUseGLClasses : Boolean;

  {-------------------------------------------------------------------------}

  { Check to see if Btrieve file exists and attempt to open it. Returns True }
  { if opened OK, status code is stored in globally to main proc in LStatus  }
  Function OpenDataFile (Const FileNo : Integer; Const FilePath : ShortString) : Boolean;
  Begin { OpenDataFile }
    LStatus := 12;

{$IFDEF EXSQL}
    if SQLUtils.TableExists(FilePath + FileNames[FileNo]) then
{$ELSE}
    If FileExists (FilePath + FileNames[FileNo]) Then
{$ENDIF}
    Begin
      { Open specified file }
      LStatus := Open_File(F[FileNo], FilePath + FileNames[FileNo], 0);
    End; { If FileExists (FilePath) }

    Result := (LStatus = 0);
  End; { OpenDataFile }

  {-------------------------------------------------------------------------}

  { Open SysF/PWordF in main directory and check that the system is valid and }
  { make copies of licencing info to be copied to other companies             }
  Function CacheMainLicInfo : LongInt;
  Var
    CompO     : TCompany;
    KeyS      : Str255;
    LStatus   : Integer;
    WantLock  : Boolean;
  Begin { CacheMainLicInfo }
    Try
      Result := 0;

      CompO := TCompany.Create (W_FromDir);
      Try
        { Cache up SysR and ModR }
        If CompO.OpenDataFile(SysF) Then Begin
          WantLock := False;
          If GetMultiSys(False, WantLock, SysR) Then
            locSys^ := Syss
          Else
            Result := 1004;

          If (Result = 0) Then Begin
            WantLock := False;
            If GetMultiSys(False, WantLock, ModRR) Then
              Move (SyssMod^, locMod^, SizeOf(SyssMod^))
            Else
              Result := 1005;
          End; { If (DLLStatus = 0) }

          If (Result = 0) And CopyPaperless Then Begin
            WantLock := False;
            If GetMultiSys(False, WantLock, EDI2R) Then
              Move (SyssEDI2^, locEDI2^, SizeOf(SyssEDI2^))
            Else
              Result := 1006;
          End; { If (DLLStatus = 0) }
        End { If CompO.Open(SysF) }
        Else Begin
          { Error Opening SysF }
          Result := 1100 + CompO.DLLStatus;
        End; { Else }
      Finally
        CompO.Free;
      End;
    Except
      On Ex:Exception Do Begin
        GlobExceptHandler(Ex);
        Result := 1001;
      End; { On }
    End;
  End; { CacheMainLicInfo }

  {-------------------------------------------------------------------------}

  Function CheckCompany(CompPath : String) : LongInt;
  Var
    CompO      : TCompany;
    oCoPath    : ShortString;
    oCompID    : LongInt;
    oCompSynch : Byte;
    oCompData  : Byte;
  Begin { CheckCompany }
    Result := 0;

    L_ErrDir := CompPath;

    FixPath(CompPath);

    Try
      CompO := TCompany.Create (CompPath);
      Try
        If CompO.SystemFound Then Begin
          { Open files required }
          If CompO.OpenDataFile(SysF) Then Begin
            If CompO.OpenDataFile(PwrdF) Then Begin
              If CompO.CheckISN(locSys^.ExIsn) Or ResetESN Then Begin
                If CompO.LockSys(SysR) Then Begin
                  { Copy in SysR Details and update }
                  With Syss Do Begin
                    { User Count }
                    ExUsrSec   := LocSys^.ExUsrSec;
                    ExUsrRel   := LocSys^.ExUsrRel;
                    UsrRelDate := LocSys^.UsrRelDate;

                    { Release Codes }
                    ExSecurity := LocSys^.ExSecurity;
                    ExRelease  := LocSys^.ExRelease;
                    RelDate    := LocSys^.RelDate;

                    // MH 20/07/06: Added replication of Grace Period flag
                    GracePeriod := LocSys^.GracePeriod;

                    { Misc }
                    ExISN     := LocSys^.ExISN;
                    ExDemoVer := LocSys^.ExDemoVer;

                    { HM 23/11/99: Added to copy country code from main company }
                    If ResetCountry Then
                      USRCntryCode := LocSys^.USRCntryCode;

                    // HM 09/02/05: Replicate the Back door disablement out to all companies
                    IgnoreBDPW := LocSys^.IgnoreBDPW;

                    // MH 13/11/06: Reset the 'Use GL Classes' flag for the first upgrade (Exchequer only)
                    If ResetUseGLClasses Then
                      UseGLClass := False;
                  End; { With Syss }

                  CompO.UpdateSys(SysR);
                End { If }
                Else Begin
                  { Error Locking SysR in company }
                  Result := 1500 + CompO.DLLStatus;
                End; { Else }

                If (Result = 0) Then Begin
                  { Copy in ModRR Details and update }
                  If CompO.LockSys(ModRR) Then Begin
                    { Copy in ModR Details and update }
                    oCompID    := SyssMod^.ModuleRel.CompanyID;
                    oCompSynch := SyssMod^.ModuleRel.CompanySynch;
                    oCompData  := SyssMod^.ModuleRel.CompanyDataType;
                    Move (LocMod^, SyssMod^, SizeOf(SyssMod^));
                    SyssMod^.ModuleRel.CompanyID    := oCompID;
                    SyssMod^.ModuleRel.CompanySynch := oCompSynch;
                    SyssMod^.ModuleRel.CompanyDataType := oCompData;
//ShowMessage ('EntComp2.ReplSysF.ReplicateEntLicence2.CheckCompany: ' + IntToStr(SyssMod^.ModuleRel.CompanyDataType));

                    CompO.UpdateSys(ModRR);
                  End { If }
                  Else Begin
                    { Error Locking ModR in company }
                    Result := 1600 + CompO.DLLStatus;
                  End; { Else }
                End; { If }

                If (Result = 0) And CopyPaperless Then Begin
                  { Copy in EDI2R Details and update }
                  If CompO.LockSys(EDI2R) Then Begin
                    { Copy in EDI2R Details and update }
                    Move (LocEDI2^, SyssEDI2^, SizeOf(SyssEDI2^));

                    CompO.UpdateSys(EDI2R);
                  End { If }
                  Else Begin
                    { Error Locking EDI2 in company }
                    Result := 1700 + CompO.DLLStatus;
                  End; { Else }
                End; { If }

                If (Result = 0) Then Begin
                  // HM 06/11/00: Added this to ensure TrackSecUpdates doesn't change Entrprse.Dat
                  oCoPath := ExMainCoPath^;
                  ExMainCoPath^ := 'Wibble';

                  { Update PWordF shadow record }
                  TrackSecUpdates(False);

                  // HM 06/11/00: Added this to ensure TrackSecUpdates doesn't change Entrprse.Dat
                  ExMainCoPath^ := oCoPath;
                End; { If (Result = 0) }
              End { If }
              Else Begin
                { Invalid ESN }
                MessageDlg ('The company ''' + Syss.UserName + ''' in ''' + CompPath + ''' belongs to a ' +
                            'different installation and any licence changes have not been applied. ' +
                            'To link this company to this installation contact your Technical Support.',
                            mtWarning, [mbOk], 0);
              End; { Else }
            End { If CompO.Open(PwrdF) }
            Else Begin
              { Error Opening PwrdF }
              Result := 1400 + CompO.DLLStatus;
            End; { Else }
          End { If CompO.Open(SysF) }
          Else Begin
            { Error Opening SysF }
            Result := 1300 + CompO.DLLStatus;
          End; { Else }
        End; { If }
      Finally
        CompO.Free;
      End;
    Except
      On Ex:Exception Do Begin
        GlobExceptHandler(Ex);
        DLLStatus := 1001;
      End; { On }
    End;
  End; { CheckCompany }

  {-------------------------------------------------------------------------}

  // Resynchronise the ESN in Entrprse.Dat with the main company
  Procedure ResyncLicence;
  Begin { ResyncLicence }
    If ReadEntLic (EntLicFName, LicR) Then Begin
      With LicR Do Begin
        licISN[1] := LocSys^.ExISN[1];
        licISN[2] := LocSys^.ExISN[2];
        licISN[3] := LocSys^.ExISN[3];
        licISN[4] := LocSys^.ExISN[4];
        licISN[5] := LocSys^.ExISN[5];
        licISN[6] := LocSys^.ExISN[6];
      End; { With LicR }

      WriteEntLic (EntLicFName, LicR);
    End { If ReadEntLic (EntLicFName, LicR) }
    Else
      MessageDlg ('The Licence cannot be read and resynchronised', mtWarning, [mbOk], 0);
  End; { ResyncLicence }

  {-------------------------------------------------------------------------}

  // Generates a Random ESN to replace a Zero ESN
  Procedure CreateNewESN;
  Var
    I : Byte;
  Begin { CreateNewESN }
    For I := 1 To 6 Do
      LocSys^.ExISN[I] := 1 + Random (253);
  End; { CreateNewESN }

  {-------------------------------------------------------------------------}

  // Updates the setup record in CompF with the new ESN
  Function UpdateCompESN (Const ResetESN : Boolean) : LongInt;
  Var
    KeyS    : Str255;
    lStatus : SmallInt;
    Locked  : Boolean;
    LockPos : LongInt;
  Begin { UpdateCompESN }
    Result := 1800;

    { Find Setup record }
    KeyS := cmSetup + CmSetupCode;
    lStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^,CompCodeK,KeyS);
    If (LStatus = 0) Then Begin
      { Lock it }
      Locked := False;
      If GetMultiRec(B_GetDirect, B_SingLock, KeyS, CompCodeK, CompF, BOn, Locked) Then Begin
        { Copy in User Count Sec/Rel codes }
        Company^.CompOpt.OptEntUserSecurity := LocSys^.ExUsrSec;
        Company^.CompOpt.OptEntUserRelease  := LocSys^.ExUsrRel;
        Company^.CompOpt.OptEntUserExpiry   := LocSys^.UsrRelDate;

        If ResetESN Then
          With Company^.CompOpt Do Begin
            { Copy in new ESN }
            optSystemESN := LocSys^.EXISN;

            // Enterprise 30-Day User Count
            Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
            OptSecurity[ucEnterprise30].rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 247, 0, 0);

            // Company Count
            Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
            OptSecurity[ucCompanies].rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 253, 0, 1);

            // Toolkit DLL - 30-day User Count
            Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
            OptSecurity[ucToolkit30].rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 1004, 0, 1);

            // Toolkit DLL - Full User Count
            Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
            OptSecurity[ucToolkitFull].rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 4, 0, 1);

            // Trade Counter User Count
            Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
            OptSecurity[ucTradeCounter].rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 11, 0, 1);

            // Available Elerts
            Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
            OptSecurity[ucElerts].rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 14, 0, 1);
          End; { With Company^.CompOpt }

        { Update Company.Dat }
        LStatus := Put_Rec(F[CompF], CompF, RecPtr[CompF]^, CompCodeK);
        If (lStatus = 0) Then
          Result := 0
        Else
          Result := 1900 + LStatus;
      End { If }
      Else
        Result := 1899;
    End { If }
    Else
      Result := 1800 + lStatus;
  End; { UpdateCompESN }

  {-------------------------------------------------------------------------}

  // Updates the Enterprise System, User Count and Module SecCodes/RelCodes
  // in Locsys, LocMod for the new ESN
  Procedure RecalcEnterpriseCodes;
  Var
    RelDateStr         : LongDate;
    SecDays            : LongInt;
    Rd, Rm, Ry         : Word;

    { Generates the final User Release Code }
    Function Gen_UsrRelCode (SecStr  :  Str20;
                             NoUsrs  :  LongInt)  :  Str20;
    Var
      SecNo  :  LongInt;
    Begin { Gen_UsrRelCode }
      SecNo:=Calc_Security(SecStr,BOff);

      If (SecNo>MaxUsrRel) then
        SecNo:=MaxUsrRel;

      SecNo:=SecNo+(NoUsrs*UsrSeed);

      Gen_UsrRelCode:=Calc_SecStr(SecNo,BOn);
    End; { Gen_UsrRelCode }

  Begin { RecalcEnterpriseCodes }
    // Replace global Syss as security routines all work directly off it
    Syss := LocSys^;
    SyssMod^.ModuleRel := LocMod^.Modules;

    With LicR, Syss Do Begin
      // System Release Code - examine existing Sec/Rel Codes to determine current status
      JulCal (RelDate, Rd, Rm, Ry);
      RelDateStr := StrDate (Ry, Rm, Rd);
      SecDays := NoDays (Today, RelDateStr);

      Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
      If False And FullyReleased Then Begin
        { Fully Released }
        ExSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 0, 0, 0);
        {$IFDEF EN561}
          ExRelease  := Generate_ESN_BaseRelease (Syss.ExSecurity, 0, 0, 0, ExNewVer);
        {$ELSE}
          ExRelease  := Generate_ESN_BaseRelease (Syss.ExSecurity, 0, 0, False, ExNewVer);
        {$ENDIF}
      End { If FullyReleased }
      Else Begin
        { Current or Expired 30-Day - Leave Expiry Date unchanged }
        ExSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 0, 0, 0);
        ExRelease  := '';
        //RelDate := CalcNewRelDate (7);
      End; { Else }

      // Full User Count - use Licence to determine valid User Count
      Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
      ExUsrSec := Generate_ESN_BaseSecurity (Syss.EXISN, 254, 0, 0);
      ExUsrRel := Gen_UsrRelCode (Syss.ExUsrSec, LicR.licUserCnt);
      //UsrRelDate :=   Not used?

      // Enterprise Modules - use Licence to determine status
      Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
      UpdateModRels (LicR);
    End; { With LicR }

    // Update cache copy of Syss with changes
    LocSys^ := Syss;
    LocMod^.Modules := SyssMod^.ModuleRel;
  End; { RecalcEnterpriseCodes }

  {-------------------------------------------------------------------------}

  Function UpdatePlugInSecurity : LongInt;
  Var
    KeyS       : Str255;
    LStatus    : SmallInt;
    SecurityNo : LongInt;
  Begin { UpdatePlugInSecurity }
    Result := 0;

    KeyS := cmPlugInSecurity;
    LStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);
    While (LStatus = 0) And (Company^.RecPFix = cmPlugInSecurity) Do Begin
      With Company^.PlugInSec Do Begin
        // Recalculate the Plug-In Security Codes
        SecurityNo := StrToInt(Copy (hkId, 11, 6));

        // System
        Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
        hkSysSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 252, PI_CheckSum(SecurityNo), 0);

        // User Count
        Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
        hkUCSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 250, PI_CheckSum(SecurityNo), 0);
      End; { With Company^.PlugInSec }

      // Update Plug-In details
      Put_Rec(F[CompF], CompF, RecPtr[CompF]^, CompPathK);

      // Get next Plug-In
      LStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);
    End; { While }
  End; { UpdatePlugInSecurity }

  {-------------------------------------------------------------------------}

  // MH 13/11/06: Check whether to reset the 'Use GL Classes' flag
  Procedure CheckGLClassesFlag;
  Var
    UsrIniF : TIniFile;
  Begin // CheckGLClassesFlag
    ResetUseGLClasses := False;

    // Check Setup.Usr for flag to indicate whether this process has already been done
    UsrIniF := TIniFile.Create (W_CompDir + '\WSTATION\SETUP.USR');
    Try
      // GLClassesReset - 0=Do Reset, 1=Do Reset on Companies, 2=Already Reset
      If (UsrIniF.ReadInteger('V571', 'GLClassesReset', 2) = 1) Then
      Begin
        ResetUseGLClasses := True;

        // Set GLClassesReset to 2 - "Already Reset" to prevent the reset process from being repeated
        UsrIniF.WriteInteger('V571', 'GLClassesReset', 2);
      End; // If (UsrIniF.ReadInteger('V571', 'GLClassesReset', 0) = 0)
    Finally
      UsrIniF.Free;
    End; { Finally }
  End; // CheckGLClassesFlag

  //-------------------------------------------------------------------------

  // MH 06/02/07: Modified to delete Docs\HG.Jpg from all company datasets
  Procedure EraseHughGrant;
  Var
    FName : ANSIString;
  Begin // EraseHughGrant
    FName := IncludeTrailingPathDelimiter(Trim(Company^.CompDet.CompPath)) + 'Docs\HG.JPG';
    If FileExists (FName) Then
    Begin
      Try
        DeleteFile(PCHAR(FName));
      Except
        ; // Bury any exceptions
      End; // Try..Finally
    End; // If FileExists (IncludeTrailingPathDelimiter(Trim(Company^.CompDet.CompPath)) + 'Docs\HG.JPG')
  End; // EraseHughGrant

  //------------------------------

Begin { ReplicateEntLicence2 }
  Try
    L_ErrDir  := '';

    Try
      DLLStatus := 1000;   { Unknown Error }

      W_FromDir := W_ErrDir;

      { Check Btrieve is running - often comes in handy :-) }
      If Check4BtrvOk Then Begin
        New (LocSys);
        New (LocMod);
        New (LocEDI2);

        { Open main Enterprise System and get local copy of master records }
        DLLStatus := CacheMainLicInfo;

        If ResetESN Then Begin
          // Generate a new random ESN
          CreateNewESN;

          // Read the Enterprise Licence in Entrprse.Dat and update the ESN
          ResyncLicence;

          // Regenerate Enterprise licencing info in cached records (SysR, ModRR)
          RecalcEnterpriseCodes;
        End; { If ResetESN }

        If (DLLStatus = 0) Then Begin
          // Open Company.Dat and run through all companies updating details
          // NOTE: Do main company again as impossible to 100% detect main dir
          //       in this way.
          L_ErrDir := W_CompDir;
          If OpenDataFile (CompF, W_CompDir) Then Begin
            // Update ESN and Licencing in Company.Dat
            DLLStatus := UpdateCompESN (ResetESN);

            // HM 24/01/02: Recalculate the Plug-In Security Codes
            If (DLLStatus = 0) And ResetESN Then
              DLLStatus := UpdatePlugInSecurity;

            // MH 13/11/06: Check whether to reset the 'Use GL Classes' flag
            CheckGLClassesFlag;

            If (DLLStatus = 0) Then Begin
              { Run through ALL Companies check ISN, setting codes etc }
              LStatus := Find_Rec(B_StepFirst, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
              While (LStatus = 0) And (DLLStatus = 0) Do Begin
                { Check its a company }
                If (Company^.RecPFix = cmCompDet) Then Begin
                  DLLStatus := CheckCompany(Company^.CompDet.CompPath);

                  // HM 28/07/03: Added section to check the data file sizes during upgrades for the
                  //              4Gb max file size

                  // HM and VM 12/04/2007 removed checkfiles section for v6.00 and SQL
//                  If CheckFileSizes Then
//                    With Company^.CompDet Do
//                      ChkFileSizes (Trim(CompCode),                                // Code
//                                    Trim(CompName),                                // Company Name
//                                    IncludeTrailingPathDelimiter(Trim(CompPath)),  // Path to data
//                                    False,                                         // Don't check Daily record
//                                    True);                                         // Check all files

                  // MH 06/02/07: Modified to delete Docs\HG.Jpg from all company datasets
                  EraseHughGrant;

                  {$IFDEF SQLHELPER}
                  // MH 03/03/2011 v6.7 ABSEXCH-10687: Create new company specific Audit directory is missing
                  CheckForAuditDir (Company^.CompDet.CompName, Company^.CompDet.CompPath);
                  {$ENDIF}
                End; { If }

                If (DLLStatus = 0) Then Begin
                  L_ErrDir  := W_CompDir;
                  LStatus := Find_Rec(B_StepNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
                End; { If }
              End; { While }
            End; { If (DLLStatus = 0) }

            Close_File (F[CompF]);

            If ResetESN Then
              With LocSys^ Do
                MessageDlg('The System ESN has been changed to ' + licESN7Str (ESNByteArrayType(LocSys^.ExISN), Ord(LocSys^.ExDemoVer)) +
                           ', please notify your '+#13+#10+'Dealer or Distributor.', mtInformation, [mbOK], 0);
          End { If Open CompF }
          Else Begin
            { Error opening Company.Dat }
            DLLStatus := 1200 + LStatus;
          End; { Else }
        End; { If (DLLStatus = 0) }

        Dispose (LocSys);
        Dispose (LocMod);
        Dispose (LocEDI2);
      End { If }
      Else Begin
        { Btrieve Not Running }
        DLLStatus := 1003;
      End; { Else }
    Except
      On Ex:Exception Do Begin
        GlobExceptHandler(Ex);
        DLLStatus := 1001;
      End; { On }
    End;
  Finally
    { NOTE: Cannot reset W_ErrDir at start as that will also reset W_CompDir }
    { if same string is passed in as both parameters                         }
    W_ErrDir := L_ErrDir;
  End;

  Result := DLLStatus;
End; { ReplicateEntLicence2 }


{-----------------------------------------------------------------------------}


{ Replicates setup details from SysR and ModrR in W_FromDir to all companies }
{ with matching ISN in the COMPANY.DAT in W_CompDir.                         }
Function REPLICATEENTLICENCE (Const W_CompDir : ShortString; Var W_ErrDir : ShortString) : LongInt;
Begin { REPLICATEENTLICENCE }
  Result := REPLICATEENTLICENCE2(W_CompDir, W_ErrDir, False, False, False, False);
End; { REPLICATEENTLICENCE }

end.
