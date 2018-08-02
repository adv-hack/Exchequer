unit ModRels;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, StrUtils, Windows, WiseUtil, IniFiles, LicRec;

{ Sets the Module Release Codes as detailed in the licence dfile }
function SCD_SetupLicence(var DLLParams: ParamRec): LongBool; StdCall; export;

{ HM 23/11/99: Added to ensure correct country code set in data }
Function GetCountryCode (Const W_Country : ShortString) : ShortString;

// Sets the User count where applicable
Procedure SetUserCount (Const UserCount : SmallInt);

// Updates the Enterprise Module Release Codes (in SyssMod^) to the standard
// specified within the passed licence.  NOTE: Uses global Syss and SyssMod
// records during security routines
Procedure UpdateModRels (Const LicRec : EntLicenceRecType);

implementation

Uses BtrvU2, GlobVar, VarConst, ETStrU, ETDateU, ETMiscU, BtKeys1U, SecWarn2,
     CompUtil, SecureU, BtSupU1, WLicFile, HelpSupU, EntLic, SerialU,
     GlobExch, sysU3, VarFPosU, LicFuncU,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     // MH 16/04/2018 2018-R1 ABSEXCH-20406: Initialise SystemSetup DataVersionNo for New MSSQL Installations
     AddSystemSetupFields,

     // MH 12/01/2017 2017R1 ABSEXCH-17996: Added support for Information Table
     oInformationTable, InformationTableFuncs,
     SecSup2U;


{ DEFINE locDBUG}


{ HM 23/11/99: Added to ensure correct country code set in data }
Function GetCountryCode (Const W_Country : ShortString) : ShortString;
Begin { GetCountryCode }
  { W_Country: 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }
  If (W_Country = '2') Then
    Result := NZCCode     { New Zealand }
  Else
    If (W_Country = '3') Then
      Result := SingCCode   { Singapore }
    Else
      If (W_Country = '4') Then
        Result := AUSCCode    { Australia }
      Else
        If (W_Country = '5') Then
          Result := IECCode     { Ireland }
        Else
          If (W_Country = '6') Then
            Result := SACCode     { South Africa }
          Else
            Result := UKCCode;    { United Kingdom or Any! }
End; { GetCountryCode }

//-------------------------------------------------------------------------}

// Updates the Enterprise Module Release Codes (in SyssMod^) to the standard
// specified within the passed licence.  NOTE: Uses global Syss and SyssMod
// records during security routines
//
// HM 24/01/02: Moved out of SCD_SetupLicence so that it could be used by
// ReplicateEntLicence2
Procedure UpdateModRels (Const LicRec : EntLicenceRecType);

  { Sets the passed Release Code info }
  Procedure SetModuleRelease (Const ModNo, AllowCode : Byte);
  Begin { SetModuleRelease }
    Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes

    With SyssMod^.ModuleRel Do Begin
      // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
      //ModuleSec [ModNo, BOff] := Get_ModuleSecurity(ModNo, BOn);
      ModuleSec [ModNo, BOff] := Generate_ESN_BaseSecurity (Syss.EXISN, ModNo, 0, 0);
      ModuleSec [ModNo, BOn]  := '';
      RelDates  [ModNo]       := 0.0;

      Case AllowCode Of
        0 : ;     { None }

        1 : Begin { 30-Day }
              // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
              //ModuleSec[ModNo, BOn] := Gen_ModRelCode(ModuleSec[ModNo, BOff], True);
              {$IFDEF EN561}
                ModuleSec [ModNo, BOn] := Generate_ESN_BaseRelease (ModuleSec [ModNo, BOff], ModNo, 0, 1, ExNewVer);
              {$ELSE}
                ModuleSec [ModNo, BOn] := Generate_ESN_BaseRelease (ModuleSec [ModNo, BOff], ModNo, 0, True, ExNewVer);
              {$ENDIF}
              RelDates[ModNo] := CalcNewRelDate(MaxDaysSecy);
            End;
        2 : Begin { Full }
              // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
              //ModuleSec[ModNo, BOn] := Gen_ModRelCode(ModuleSec[ModNo, BOff], False);
              {$IFDEF EN561}
                ModuleSec [ModNo, BOn] := Generate_ESN_BaseRelease (ModuleSec [ModNo, BOff], ModNo, 0, 0, ExNewVer);
              {$ELSE}
                ModuleSec [ModNo, BOn] := Generate_ESN_BaseRelease (ModuleSec [ModNo, BOff], ModNo, 0, False, ExNewVer);
              {$ENDIF}
            End;
      End; { Case }

      {$IFDEF locDBUG}
      DBug.Add ('SetModuleRelease (ModNo=' + IntToStr(ModNo) + ', AllowCode=' + IntToStr(AllowCode) + ')');
      {$ENDIF}
    End; { With SyssMod^ }
  End; { SetModuleRelease }

  //---------------------------

Begin { UpdateModRels }
  {$IFDEF locDBUG}
  DBug.Add ('Update Mod Rels');
  {$ENDIF}

  { Apply Release Codes from ENTRPRSE.DAT }
  With LicRec, SyssMod^ Do Begin
    { 1: Multi-Currency }
    If (licEntCVer = 2) Then
      SetModuleRelease (1, 2)
    Else
      SetModuleRelease (1, 0);

    { 2: Job Costing }
    SetModuleRelease (2, licModules[modJobCost]);

    { 3: Report Writer }
    SetModuleRelease (3, licModules[modRepWrt]);

    { 4: Toolkit DLL }
    // HM 30/10/00: Modified as wasn't working when upgrading from Full Runtime to Full Developer, as this gave a total of 4!
    //SetModuleRelease (4, licModules[modToolDLL] + licModules[modToolDLLR]);
    If (licModules[modToolDLL] > licModules[modToolDLLR]) Then
      SetModuleRelease (4, licModules[modToolDLL])
    Else
      SetModuleRelease (4, licModules[modToolDLLR]);

    { 5: Telesales }
    SetModuleRelease (5, licModules[modTeleSale]);

    { 6: Account Stock Analysis }
    SetModuleRelease (6, licModules[modAccStk]);

    { 7: E-Business }
    SetModuleRelease (7, licModules[modEBus]);

    { 8: Paperless }
    SetModuleRelease (8, licModules[modPaperless]);

    { 9: OLE Save Functions }
    SetModuleRelease (9, licModules[modOLESave]);

    { 10: Commitment Accounting }
    SetModuleRelease (10, licModules[modCommit]);

    { 11: Trade Counter }
    SetModuleRelease (11, licModules[modTrade]);

    { 12: Standard Works Order Processing }
    SetModuleRelease (12, licModules[modStdWOP]);

    { 13: Professional Works Order Processing }
    SetModuleRelease (13, licModules[modProWOP]);

    { 14: Sentimail }
    SetModuleRelease (14, licModules[modElerts]);

    { 15: Enhanced Security }
    SetModuleRelease (15, licModules[modEnhSec]);

    { 16: CIS/RCT }
    SetModuleRelease (16, licModules[modCISRCT]);

    { 17: Applications & Valuations }
    SetModuleRelease (17, licModules[modAppVal]);

    { 18: Full Stock Control (v5.61) }
    SetModuleRelease (18, licModules[modFullStock]);

    { 19: Visual Report Writer (v5.61) }
    SetModuleRelease (19, licModules[modVisualRW]);

    { 20: Goods Returns (v5.70) }
    SetModuleRelease (20, licModules[modGoodsRet]);

    // 21: eBanking (v5.71)
    SetModuleRelease (21, licModules[modEBanking]);

    // 22: Outlook Dynamic Dashboard (v5.71)
    SetModuleRelease (22, licModules[modOutlookDD]);

    // 23: Importer (v6.00)
    SetModuleRelease (23, licModules[modImpMod]);

    // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
    // 24: 2018-R1 - GDPR
    SetModuleRelease (24, licModules[modGDPR]);
    // 25: 2018-R1 - Pervasive File Encryption
    SetModuleRelease (25, licModules[modPervEncrypt]);
  End; { With EntLicR, SyssMod^ }
End; { UpdateModRels }

//-------------------------------------------------------------------------

{ Sets the User count where applicable }
Procedure SetUserCount (Const UserCount : SmallInt);

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

Begin { SetUserCount }
  With Syss Do Begin
    { Update User Count }
    // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
    Syss.ExUsrSec := Generate_ESN_BaseSecurity (Syss.EXISN, 254, 0, 0);
    Syss.ExUsrRel := Gen_UsrRelCode(Syss.ExUsrSec,UserCount);
  End; { With Syss }
End; { SetUserCount }

{-------------------------------------------------------------------------}


{ Sets the Module Release Codes if not already set }
// 1000        Unknown Exception
// 1001        Incorrect security parameter
// 1002        Btrieve Not Running
// 1003        Missing Licence File
// 1004        Failed to read Licence File
// 1005        Error Writing Licence File
// 1006        Error Reading Licence File
// 1100..1199  Btrieve Error Opening Exchqss.dat
// 1200..1299  Btrieve Error Opening ExchqChk.Dat
// 1300..1399  Btrieve Error locking ModRR
// 1500..1599  Btrieve Error updating ModRR
// 1600..1699  Btrieve Error getting ModR Record Position
// 1700..1799  Btrieve Error getting SysR Record Position
// 1800..1899  Btrieve Error locking SysR
// 1900..1999  Btrieve Error reading SysR
// 2000..2099  Btrieve Error reading ModR
// 2100..2199  Btrieve Error updating SysR
// 2200..2299  Btrieve Error rereading ModRR
// 2300..2399  Btrieve Error reading EDI2R
// 2400..2499  Btrieve Error locking EDI2R
// 2500..2599  Btrieve Error getting EDI2R Record Position
// 2600..2699  Btrieve Error rereading EDI2R
// 2700..2799  Btrieve Error updating ModRR
// 2800..2899  Btrieve Error Opening Company.Dat
// 10000+      Error in SCD_SecWarnWizard
function SCD_SetupLicence(var DLLParams: ParamRec): LongBool;
Var
  W_Country, W_Install,
  W_InstType, W_MainDir, W_LicFile, W_LicType : String;
  EDI2RLockPos,
  ModRLockPos, SysRLockPos, DLLStatus         : LongInt;
  SysKey, MiscKey                             : Str255;
  Params                                      : ANSIString;
  TempLicR                                    : CDLicenceRecType;
  EntLicR                                     : EntLicenceRecType;
  LStatus                                     : Integer;
  SecChkOk, SysLocked, ModLocked, MiscLocked  : Boolean;
  DoneRelCode                                 : Byte;
  {$IFDEF locDBUG}
  DBug                                        : TStringList;
  {$ENDIF}

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

  { Opens ExchQss.Dat which contain the release code info }
  Function OpenEntFiles : Boolean;
  Begin { OpenEntFiles }
    DLLStatus := 0;

    { Open ExchQss.Dat }
    If Not OpenDataFile (SysF, W_MainDir) Then Begin
      { Error Opening Exchqss.dat }
      DLLStatus := 1100 + LStatus;
    End; { If }

    If (DLLStatus = 0) Then
      { Open ExchqChk.Dat }
      If Not OpenDataFile (PwrdF, W_MainDir) Then Begin
        { Error Opening ExchqChk.Dat }
        DLLStatus := 1200 + LStatus;
      End; { If }

    If (DLLStatus = 0) Then
      { Open Company.Dat }
      If Not OpenDataFile (CompF, W_MainDir) Then Begin
        { Error Opening Company.Dat }
        DLLStatus := 2800 + LStatus;
      End; { If }

    Result := (DllStatus = 0);
  End; { OpenEntFiles }

  {-------------------------------------------------------------------------}

  { Closes ExchQss.Dat }
  Procedure CloseEntFiles;
  Begin { CloseEntFiles }
    Close_File(F[CompF]);
    Close_File(F[SysF]);
    Close_File(F[PwrdF]);
  End; { CloseEntFiles }

  {-------------------------------------------------------------------------}

  // HM 22/06/00: Ensure all SysF records present
  Procedure CheckSysF;
  Const
    SysChk  :  Array[0..9] of SysrecTypes = (CUR2,CUR3,GCU2,GCU3,GCUR,EDI1R,EDI2R,EDI3R,CstmFR,CstmFR2);
  Var
    c,cs,n,m, I  : Byte;
    LOk, Locked  : Boolean;
    SysCount     : SysrecTypes;
  Begin { CheckSysF }
    For I := Low(SysChk) To High(SysChk) Do Begin
      { Check to see if record exists }
      SysCount := SysChk[I];
      Locked := BOff;
      LOk := GetMultiSys(BOff,Locked,SysCount);

      If (Not LOk) Then Begin
        { Not found - add new record }
        Case SysCount of
          GCUR,
          GCU2,
          GCU3  :  With SyssGCur1P^, GhostRates Do Begin
                     FillChar(SyssGCur1P^, Sizeof(SyssGCur1P^), 0);
                     IDCode := SysNames[SysCount];
                     Move(SyssGCur1P^, Syss, Sizeof(SyssGCur1P^));
                   end;

          CUR2,
          CUR3  :  With SyssCurr1P^ Do Begin
                     FillChar(SyssCurr1P^, Sizeof(SyssCurr1P^), 0);
                     IDCode := SysNames[SysCount];
                     Move(SyssCurr1P^, Syss, Sizeof(SyssCurr1P^));
                   end;

          EDI1R,
          EDI2R,
          EDI3R :  With SyssEDI1^ Do Begin
                     FillChar(SyssEDI1^, Sizeof(SyssEDI1^), 0);
                     IDCode := SysNames[SysCount];
                     Move(SyssEDI1^, Syss, Sizeof(SyssEdI1^));
                   end;

          // HM 29/04/01: Added new sys records for v4.40
          CstmFR,
          CstmFR2: With SyssCstm^, CustomSettings Do Begin
                     FillChar(SyssCstm^,Sizeof(SyssCstm^),0);
                     IDCode:=SysNames[SysCount];

                     (* MH 25/10/2011 v6.9: These fields have been relocated to a new table
                     If (SysCount=CstmFR) Then Begin
                       {Remaining two JC fields}
                       fCaptions[1]:='User Def 3';
                       fCaptions[2]:='User Def 4';
                       cs:=3;
                     End
                     Else
                       cs:=1;

                     m:=1;

                     For c := cs to High(CustomSettings.fCaptions) do Begin
                       fCaptions[c]:='User Def '+Form_Int(m,0);

                       Inc(m);

                       If (m>4) then
                         m:=1;
                     End;
                     *)

                     Move(SyssCstm^,Syss,Sizeof(SyssCstm^));
                   end;
        End; { Case SysCount }

        Status := Add_Rec(F[SysF],SysF,RecPtr[SysF]^,0);
        Report_BError(SysF,Status);
      End; { If (Not LOk) }
    End; { For I }
  End; { CheckSysF }

  {-------------------------------------------------------------------------}

  { Reads the duplicated Release Codes records from SysF and Pwrd }
  Function ReadEntRecords : Boolean;
  Begin { ReadEntRecords }
    DllStatus := 0;

    { Get EDI2R Record - Paperless Module }
    SysKey := SysNames[EDI2R];
    LStatus := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, SysK, SysKey);
    If (LStatus = 0) Then Begin
      { Copy record into dupli record }
      Move (Syss, SyssEDI2^, SizeOf(SyssEDI2^));

      { Lock Paperless Module record }
      ModLocked := False;
      If GetMultiRec(B_GetDirect,B_SingLock,SysKey,SysK,SysF,BOn,ModLocked) Then Begin
        { Get record position }
        LStatus := GetPos(F[SysF], SysF, EDI2RLockPos);
        If (LStatus <> 0) Then Begin
          { Error getting EDI2R Record Position }
          Result := False;
          DLLStatus := 2500 + LStatus;
        End; { If }
      End { If }
      Else Begin
        { Error locking EDI2R }
        Result := False;
        DLLStatus := 2400 + LStatus;
      End; { If }
    End { If }
    Else Begin
      { Error reading EDI2R }
      Result := False;
      DLLStatus := 2300 + LStatus;
    End; { Else }

    If (DLLStatus = 0) And (Lstatus = 0) Then Begin
      { Get ModR record }
      SysKey := SysNames[ModRR];
      LStatus := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, SysK, SysKey);

//      ShowMessage('Result is: ' + inttostr(LStatus));
      
      If (LStatus = 0) Then Begin
        { Copy record into dupli record }
        Move (Syss, SyssMod^, SizeOf(SyssMod^));

        { Lock Module Release record }
        ModLocked := False;
        If GetMultiRec(B_GetDirect,B_SingLock,SysKey,SysK,SysF,BOn,ModLocked) Then Begin
          { Get record position }
          LStatus := GetPos(F[SysF], SysF, ModRLockPos);
          If (LStatus <> 0) Then Begin
            { Error getting ModR Record Position }
            Result := False;
            DLLStatus := 1600 + LStatus;
          End; { If }
        End { If }
        Else Begin
          { Error locking ModR }
          Result := False;
          DLLStatus := 1300 + LStatus;
        End; { If }
      End { If }
      Else Begin
        { Error reading ModR }
        Result := False;
        DLLStatus := 2000 + LStatus;
      End; { Else }
    End; { If (DLLStatus = 0) And (Lstatus = 0) }

    If (DLLStatus = 0) And (Lstatus = 0) Then Begin
      { Get SysR record }
      SysKey := SysNames[SysR];
      LStatus := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, SysK, SysKey);
      If (LStatus = 0) Then Begin
        { Lock System Setup record }
        SysLocked := False;
        If GetMultiRec(B_GetDirect,B_SingLock,SysKey,SysK,SysF,BOn,SysLocked) Then Begin
          { Get record position }
          LStatus := GetPos(F[SysF], SysF, SysRLockPos);
          If (LStatus <> 0) Then Begin
            { Error getting SysR Record Position }
            Result := False;
            DLLStatus := 1700 + LStatus;
          End; { If }
        End { If }
        Else Begin
          { Error locking SysR }
          Result := False;
          DLLStatus := 1800 + LStatus;
        End; { If }
      End { If }
      Else Begin
        { Error reading SysR }
        Result := False;
        DLLStatus := 1900 + LStatus;
      End; { Else }
    End; { If }

    Result := (DllStatus = 0);
  End; { ReadEntRecords }

  {-------------------------------------------------------------------------}

  { Updates the duplicated release codes in SysF }
  Procedure UpdateEntRecords;
  Var
    SyssBackup : SysRec;
  Begin { UpdateEntRecords }
    // MH 13/01/2017 ABSEXCH-17996: Save/Restore the Syss record as it gets overwritten with SyssMod^ and SyssEDI2^
    // causing any functions using Syss to misbehave after this routine was called
    SyssBackup := Syss;
    Try
      { Update SysR }
      LStatus := Put_Rec(F[SysF],SysF,RecPtr[SysF]^,SysK);
      If (LStatus <> 0) Then Begin
        { Error updating SysR }
        DLLStatus := 2100 + LStatus;
      End; { If }

      If (DLLStatus = 0) And (LStatus = 0) Then Begin
        { Update ModRR in SysF }
        Move(ModRLockPos,Syss,Sizeof(ModRLockPos));
        LStatus:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);
        If (LStatus = 0) Then Begin
          Move (SyssMod^, Syss, SizeOf (Syss));

          { Save changes to Module Release Codes record }
          LStatus := Put_Rec(F[SysF],SysF,RecPtr[SysF]^,SysK);
          If (LStatus <> 0) Then Begin
            { Error updating ModRR }
            DLLStatus := 1500 + LStatus;
          End; { If }
        End { If }
        Else Begin
          { Error rereading ModRR }
          DLLStatus := 2200 + LStatus;
        End; { Else }
      End; { If }

      If (DLLStatus = 0) And (LStatus = 0) Then Begin
        { Update EDI2R in SysF }
        Move(EDI2RLockPos,Syss,Sizeof(EDI2RLockPos));
        LStatus:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);
        If (LStatus = 0) Then Begin
          Move (SyssEDI2^, Syss, SizeOf (Syss));

          { Save changes to Paperless Module Setup record }
          LStatus := Put_Rec(F[SysF],SysF,RecPtr[SysF]^,SysK);
          If (LStatus <> 0) Then Begin
            { Error updating EDI2R }
            DLLStatus := 2700 + LStatus;
          End; { If }
        End { If }
        Else Begin
          { Error rereading ModRR }
          DLLStatus := 2600 + LStatus;
        End; { Else }
      End; { If }
    Finally
      Syss := SyssBackup;
    End; // Try..Finally
  End; { UpdateEntRecords }

  {-------------------------------------------------------------------------}

  { Writes the Licence Details back to ENTRPRSE.DAT }
  Procedure WriteEnterpriseLic;
  Begin { WriteEnterpriseLic }
    If Not WriteEntLic (W_MainDir + EntLicFName, EntLicR) Then Begin
      { Error writing new licence file }
      DLLStatus := 1005
    End; { If }
  End; { WriteEnterpriseLic }

  {-------------------------------------------------------------------------}
  { Sets the System ISN to its initialised value }
  Procedure SetSyssISN(Const Force : Boolean);
  Var
    SNoB    : SerialNoType;
    pDir    : PChar;
    Res, I  : LongInt;
  Begin { SetSyssISN }
    { Check to see if ISN needs to be set }
    With Syss Do Begin
      If ((ExISN[1] = 0) And (ExISN[2] = 0) And (ExISN[3] = 0) And
          (ExISN[4] = 0) And (ExISN[5] = 0) And (ExISN[6] = 0)) Or Force Then Begin
        { Get CD Serial Number as array of bytes }
        SNoB := SNoStrToSNoByte (TempLicR.licSerialNo);

        { Setup ISN with CD Serial Bytes}
        (* HM 29/09/99: Modified ESN calculation to be heavy on local Serial Number
        ExISN[2] := SNoB[1];
        ExISN[3] := SNoB[2];
        ExISN[5] := SNoB[3];
        ExISN[6] := SNoB[4];
        *)
        ExISN[1] := SNoB[1];
        ExISN[4] := SNoB[2];

        { Get hard disk Serial Number from windows drive }
        pDir := StrAlloc(Max_Path);
        Res := GetWindowsDirectory(pDir, StrBufSize(pDir));
        If (Res > 0) Then Begin
          SNoB := GetDriveSerialB(pDir[0]);

          { HM 29/09/99: Modified ESN calculation to be heavy on local Serial Number }
          ExISN[2] := SNoB[1];
          ExISN[3] := SNoB[2];
          ExISN[5] := SNoB[3];
          ExISN[6] := SNoB[4];
        End { If }
        Else Begin
          { Failed to get local HD Number - set randomly }
          ExISN[2] := 1 + Random (253);
          ExISN[3] := 1 + Random (253);
          ExISN[5] := 1 + Random (253);
          ExISN[6] := 1 + Random (253);
        End; { Else }
        StrDispose(pDir);
      End; { If }

      { All zero's is considered to be 'NOT SET' - so make sure that 1 in 281.4 billion chance doesn't happen }
      If (ExISN[1] = 0) And (ExISN[2] = 0) And (ExISN[3] = 0) And
         (ExISN[4] = 0) And (ExISN[5] = 0) And (ExISN[6] = 0) Then Begin
        { local HD is zero - bummer! - set randomly }
        ExISN[2] := 1 + Random (253);
        ExISN[3] := 1 + Random (253);
        ExISN[5] := 1 + Random (253);
        ExISN[6] := 1 + Random (253);
      End; { If }

      { Update EntLicR with new ISN }
      For I := Low(ExISN) To High(ExISN) Do
        EntLicR.licISN[I] := ExISN[I];
    End; { With }
  End; { SetSyssISN }

  {-------------------------------------------------------------------------}

  // MH 05/07/07: Modified to set the ESN in Company Options due to problems in MS SQL Edition
  Function UpdateCompOpt : LongInt;
  Var
    KeyS    : Str255;
    lStatus : SmallInt;
  Begin // UpdateCompOpt
    // Load/Create Company Options record
    LoadCompanyOpt;
    Company^.CompOpt.optSystemESN := Syss.EXISN;
    LStatus := Put_Rec(F[CompF], CompF, RecPtr[CompF]^, CompCodeK);
    If (lStatus = 0) Then
      Result := 0
    Else
      Result := 2900 + lStatus;
  End; // UpdateCompOpt

  //-------------------------------------------------------------------------

  { New Installation - Setup Release Codes and Create ENTRPRSE.DAT licence file }
  Procedure NewInstall;
  Begin { NewInstall }
    { Setup Enterprise licence }
    //EntLicR := TempLicR;
    EntLicR := licCopyCDLicToEntLic (TempLicR);
//ShowMessage ('TempLicR.licCDKey=' + TempLicR.licCDKey + #13 +
//             'TempLicR.licProductType=' + IntToStr(TempLicR.licProductType) + #13 +
//             'EntLicR.licCDKey=' + EntLicR.licCDKey + #13 +
//             'EntLicR.licProductType=' + IntToStr(EntLicR.licProductType));

    { Apply Release Codes from ~VBxxx.TMP }
    With Syss, EntLicR Do Begin
      { Default Company Name to that in Licence file }
      UserName := licCompany;

      // HM 08/01/02: Moved SetSyssISN here from the main proc as the ESN is
      //              now required to calculate the Module Security Codes
      SetSyssISN(True);

      UpdateModRels (EntLicR);
    End; { With Syss, EntLicR }
  End; { NewInstall }

  {-------------------------------------------------------------------------}

  { Read Licence Details from ENTRPRSE.DAT }
  Procedure ReadEnterpriseLic;
  Begin { ReadEnterpriseLic }
    If Not ReadEntLic (W_MainDir + EntLicFName, EntLicR) Then Begin
      { Error reading Enterprise Licence }
      DLLStatus := 1006;
    End; { If Not ReadEntLic }
  End; { ReadEnterpriseLic }

  {-------------------------------------------------------------------------}

  { Upgrade an existing Enterprise with Licence changes where applicable }
  Procedure UpdateEntLic;
  Var
    Changed : Boolean;
    I       : Byte;
  Begin { UpdateEntLic }
    {$IFDEF locDBUG}
    DBug.Add ('UpdateEntLic');
    {$ENDIF}

    { Apply changes between ~VBxxx.TMP and ENTRPRSE.DAT }
    Changed := False;
    If TempLicR.licResetModRels Then Begin
      {$IFDEF locDBUG}
      DBug.Add ('  Reset EntLicR.licModules:');
      {$ENDIF}

      FillChar (EntLicR.licModules, SizeOf(EntLicR.licModules), #0);
      Changed := True;
    End; { If (TempLicR.licOptions[1] = 1) }

    EntLicR.licLicType := TempLicR.licLicType;
    EntLicR.licType    := TempLicR.licType;
    EntLicR.licCountry := TempLicR.licCountry;

    EntLicR.licCompany := TempLicR.licCompany;
    EntLicR.licDealer  := TempLicR.licDealer;
    //EntLicR.licISN
    //EntLicR.licESN2

    //EntLicR.licSerialNo

    { Enterprise Version }
    If (EntLicR.licEntCVer <> TempLicR.licEntCVer) Then Begin
      { Currency ver changed - reset release codes }
      EntLicR.licEntCVer := TempLicR.licEntCVer;
      Changed := True;
    End; { If }
    EntLicR.licEntModVer := TempLicR.licEntModVer;
    EntLicR.licEntClSvr  := TempLicR.licEntClSvr;
    EntLicR.licUserCnt   := TempLicR.licUserCnt;

    { Pervasive.SQL }
    EntLicR.licClServer  := TempLicR.licClServer;
    EntLicR.licCSUserCnt := TempLicR.licCSUserCnt;

    // HM 16/10/03: Added support for workgroup Engine flag
    If (TempLicR.licPSQLWGEVer > 0) Then
      EntLicR.licPSQLWGEVer := TempLicR.licPSQLWGEVer;

    { Enterprise Modules }
    For I := 1 To modLast Do Begin
      { Check for changes in mod rel codes }
      {$IFDEF locDBUG}
      DBug.Add (Format ('  %2d     %1d     %1d', [I, EntLicR.licModules[I], TempLicR.licModules[I]]));
      {$ENDIF}

      // HM 30/11/01: Added special case for WOP as Std & Pro relcodes are interdependant
      If (Not TempLicR.licResetModRels) And (I In [modStdWOP, modProWOP]) Then Begin
        // Do it all on the Std WOP pass - ignore the Pro WOP pass
        If (I = modStdWOP) Then Begin
          // Std WOP pass - setup Std and Pro WOP RelCode statii
{ShowMessage ('Existing WOP Codes: ' + #13 +
             Format ('Std: Ent-%d / CD-%d', [EntLicR.licModules[modStdWOP], TempLicR.licModules[modStdWOP]]) + #13 +
             Format ('Pro: Ent-%d / CD-%d', [EntLicR.licModules[modProWOP], TempLicR.licModules[modProWOP]])); }

          If (TempLicR.licModules[modStdWOP] > 0) Then Begin
            // Std WOP relcode is set - remove any pre-existing Pro WOP licence
            If (TempLicR.licModules[modStdWOP] > EntLicR.licModules[modStdWOP]) Then
              EntLicR.licModules[modStdWOP] := TempLicR.licModules[modStdWOP];
            EntLicR.licModules[modProWOP] := 0;
            Changed := True;
          End; { If (TempLicR.licModules[modStdWOP] > 0) }
          If (TempLicR.licModules[modProWOP] > 0) Then Begin
            // Pro WOP relcode is set - remove any pre-existing Std WOP licence
            EntLicR.licModules[modStdWOP] := 0;
            If (TempLicR.licModules[modProWOP] > EntLicR.licModules[modProWOP]) Then
              EntLicR.licModules[modProWOP] := TempLicR.licModules[modProWOP];
            Changed := True;
          End; { If (TempLicR.licModules[modProWOP] > 0) }
{ShowMessage ('Reset WOP Codes: ' + #13 +
             Format ('Std: Ent-%d / CD-%d', [EntLicR.licModules[modStdWOP], TempLicR.licModules[modStdWOP]]) + #13 +
             Format ('Pro: Ent-%d / CD-%d', [EntLicR.licModules[modProWOP], TempLicR.licModules[modProWOP]])); }
        End; { If (I = modStdWOP) }
      End { If (Not TempLicR.licResetModRels) And (I In [modStdWOP, modProWOP]) }
      Else
        // Standard Module or all Module Release Codes are being reset
        If (EntLicR.licModules[I] < TempLicR.licModules[I]) Or TempLicR.licResetModRels Then Begin
          { Module status changed }
          EntLicR.licModules[I] := TempLicR.licModules[I];
          Changed := True;
        End; { If }

      {$IFDEF locDBUG}
      DBug.Add (Format ('         %1d', [EntLicR.licModules[I]]));
      {$ENDIF}
    End; { For }

    { Enterprise Module User counts - RelCodes set in SCD_SetupCompanyCount (CompSec.Pas) }

    // HM 26/02/02: Modified to check Module Status from Updated Enterprise Licence rather
    // than the CD Licence, as that didn't work for modules left as Auto and was resetting
    // the User Counts to zero.

    { Toolkit DLL }
    If ((EntLicR.licModules[modToolDLL] + EntLicR.licModules[modToolDLLR]) > 0) Then Begin
      // RelCode Status is specified - Set User Count if is not an 'Auto' upgrade module
      If Not ((TempLicR.licType In [1, 2]) And ((TempLicR.licModules[modToolDLL] + TempLicR.licModules[modToolDLLR]) = 0)) Then Begin
        // Not an 'Auto' type module upgrade - reset user counts
        EntLicR.licUserCounts[ucToolkit30] := TempLicR.licUserCounts[ucToolkit30];
        EntLicR.licUserCounts[ucToolkitFull] := TempLicR.licUserCounts[ucToolkitFull];
      End; { If }
    End { If ((EntLicR.licModules[modToolDLL] ... }
    Else Begin
      // Upgrade/Auto-Upgrade Licence
      EntLicR.licUserCounts[ucToolkit30] := 0;
      EntLicR.licUserCounts[ucToolkitFull] := 0;
    End; { Else }

    { Trade Counter }
    If (EntLicR.licModules[modTrade] > 0) Then Begin
      // RelCode Status is specified - Set User Count if is not an 'Auto' upgrade module
      If Not ((TempLicR.licType In [1, 2]) And (TempLicR.licModules[modTrade] = 0)) Then
        // Not an 'Auto' type module upgrade - reset user counts
        EntLicR.licUserCounts[ucTradeCounter] := TempLicR.licUserCounts[ucTradeCounter];
    End { If (EntLicR.licModules[modTrade] > 0) }
    Else
      EntLicR.licUserCounts[ucTradeCounter] := 0;

    { Elerts aka Sentimail }
    // HM 26/02/02: Was incorrectly referencing the array using ucElerts which maps onto the Report Writer Module!
    If (EntLicR.licModules[modElerts] > 0) Then Begin
      // RelCode Status is specified - Set User Count if is not an 'Auto' upgrade module
      If Not ((TempLicR.licType In [1, 2]) And (TempLicR.licModules[modElerts] = 0)) Then
        // Not an 'Auto' type module upgrade - reset user counts
        EntLicR.licUserCounts[ucElerts] := TempLicR.licUserCounts[ucElerts]
    End { If (EntLicR.licModules[modElerts] > 0) }
    Else
      EntLicR.licUserCounts[ucElerts] := 0;

    { MCM - Company Count }
    If (TempLicR.licUserCounts[ucCompanies] > 0) Then Begin
      { Count specified - 0 = Auto (Leave As Currently Set) }
      EntLicR.licUserCounts[ucCompanies] := TempLicR.licUserCounts[ucCompanies];

      // NOTE: Release Code details set later in SCD_SetupCompanyCount (CompSec.Pas)
    End; { If }

    { Licence Expiry Date }
    //EntLicR.licExpiry ???

    { Copy options flags across }
    EntLicR.licResetModRels := TempLicR.licResetModRels;
    EntLicR.licResetCountry := TempLicR.licResetCountry;

    // HM 08/01/02: Changed so that UpdateModRels is ALWAYS called - to force
    //              the security codes to be recalculated for the new v5.00
    //              ESN based system
    {If Changed Then}
      { Rebuild release codes }
      UpdateModRels (EntLicR);

    // MH 01/12/05: Added new fields for LITE Licencing support
    EntLicR.licProductType := TempLicR.licProductType;
    EntLicR.licCDKey := TempLicR.licCDKey;
    EntLicR.licEntEdition := TempLicR.licEntEdition;

    // MH 19/11/12 v7.0: Added new field for Small Business Edition licensing support
    EntLicR.licExchequerEdition := TempLicR.licExchequerEdition;
  End; { UpdateEntLic }

  {-------------------------------------------------------------------------}

  { Resets the system expiry to either 30-days (Installs) or 7-days (Upgrades) }
  Procedure SetEntExpiry;
  Var
    RelDateStr                                       : LongDate;
    CurRel, v1FullExSec, FullExSec, CurSecy, SecDays : LongInt;
    Rd, Rm, Ry                                       : Word;
  Begin { SetEntExpiry }
    With Syss Do Begin
      If (UpperCase(Trim(W_InstType)) = 'A') Then Begin
        { Install }
        // MH 10/07/06: Added check for LITE and extended LITE demo period
        If (W_Install <> 'L') Then
          // Exchequer
          SecDays := MaxDaysSecy  // 30
        Else
        Begin
          // LITE / IAO
          If (EntLicR.licLicType In [1, 2]) Then
            // Demo Licence
            SecDays := 60
          Else
            // Full licence
            SecDays := MaxDaysSecy;  // 30
        End; // Else
        RelDate := CalcNewRelDate(SecDays);
      End { If }
      Else Begin
        { Upgrade - Reset to 7 days if > 7 remaining on release code or if }
        { a full release code has been given                               }
        JulCal (RelDate, Rd, Rm, Ry);
        RelDateStr := StrDate (Ry, Rm, Rd);
        SecDays := NoDays (Today, RelDateStr);

        If (SecDays > 7) Then Begin
          { More than 7 days till expiry - reset to 7 }
          RelDate := CalcNewRelDate (7);
        End { If }
        Else Begin
          { Expired or full release code }
          If FullyReleased Then
            { Full Code - Reset Expiry to 7 day }
            RelDate := CalcNewRelDate (7);

          (*
          CurSecy := Calc_Security(ExSecurity,BOff);

          If (CurSecy=0) then Begin
            CurSecy:=Set_Security;
            ExSecurity:=Calc_SecStr(CurSecy,BOff);
          End; { If }

          FullExSec:=CurSecy+SecRelCode;

          v1FullExSec:=CurSecy+v1SecRelCode;

          CurRel:=Calc_Security(ExRelease,BOn);

          If ((CurRel = FullExSec) Or (CurRel = v1FullExSec)) Then Begin
             { Full Code - Reset Expiry to 7 day }
            RelDate := CalcNewRelDate (7);
          End; { Else }
          *)
        End; { Else }
      End; { Else }

      //ExSecurity := Calc_SecStr (CurSecy, BOff);
      // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
      //ExSecurity := Get_ISNSecurity(ExISN);
      ExSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 0, 0, 0);
      Blank (ExRelease, Sizeof(ExRelease));
    End; { With Syss }
  End; { SetEntExpiry }

  {-------------------------------------------------------------------------}

  { Compares the duplicated details in SysR and PWrdF, and checks the ESN in }
  { the licence file matches that in SysR. All details are reset if any     }
  { tampering has been found.                                                }
  Function CheckSystemSecurity : Boolean;
  Begin { CheckSystemSecurity }
    { Check Licence ESN and SysR ESN match }
    Result := (Syss.ExISN[1] = EntLicR.licISN[1]) And (Syss.ExISN[2] = EntLicR.licISN[2]) And
              (Syss.ExISN[3] = EntLicR.licISN[3]) And (Syss.ExISN[4] = EntLicR.licISN[4]) And
              (Syss.ExISN[5] = EntLicR.licISN[5]) And (Syss.ExISN[6] = EntLicR.licISN[6]);

    If Result Then Begin
      { ESN matches - check SysR and PwrdF match }
      Result := CompareVSecure(BOn, BOff);
    End { If Result }
    Else Begin
      { ESN's don't match - reset all security items }
      FillChar (Syss.ExISN, SizeOf(Syss.ExISN), #0);
      CompareVSecure(BOn, BOff);
    End; { Else }
  End; { CheckSystemSecurity }

  {-------------------------------------------------------------------------}

  { Setup the Paperless Options in SysF }
  Procedure ConfigPaperless;
  Var
    UsrIniF      : TIniFile;
    WiseStr      : String;
  Begin { ConfigPaperless }
    { Check Paperless is being installed }
    GetVariable(DLLParams, 'V_INSTMOD', WiseStr);
    If (Pos ('J', WiseStr) > 0) Then Begin
      { Installing Paperless Module - check to see if need to reset global settings }
      GetVariable(DLLParams, 'VP_STATUS', WiseStr);
      If (WiseStr = '2') Then Begin
        UsrIniF := TIniFile.Create (W_MainDir + '\WSTATION\SETUP.USR');
        Try
          { Initialise EDI2R record in SysF from .INI file settings }
          With SyssEDI2^.EDI2Value Do Begin
            { Check email method }
            If (UsrIniF.ReadString ('Entrprse', 'PEmail', 'A') = 'A') Then Begin
              { SMTP }
              EmUseMAPI := False;
              EmSMTP    := UsrIniF.ReadString ('Entrprse', 'PEmailSMTP', '');
            End { If SMTP }
            Else Begin
              emUseMapi := True;
              emSMTP    := '';
            End; { Else }
            EmName      := UsrIniF.ReadString ('Entrprse', 'PEmailName', '');
            EmAddress   := UsrIniF.ReadString ('Entrprse', 'PEmailAddr', '');
            EmPriority  := 1; { Normal }

            { Email Attachments }
            If (UsrIniF.ReadString ('Entrprse', 'PEmailAttach', 'A') = 'B') Then Begin
              { Adobe Acrobat }
              emAttchMode := 1;     { Adobe PDF }
              EmailPrnN   := 'Acrobat PDFWriter';
            End { If Adobe Acrobat }
            Else Begin
              { Enterprse EDF / PDF}
              If (UsrIniF.ReadString ('Entrprse', 'PEmailAttach', 'A') = 'A') Then
                { Enterprse EDF }
                emAttchMode := 0
              Else
                { Enterprse PDF }
                emAttchMode := 2;
              EmailPrnN   := UsrIniF.ReadString ('Entrprse', 'PEmailPrn', '');
            End; { Else }

            WiseStr := UsrIniF.ReadString ('Entrprse', 'PFax', 'A');
            If (Length(WiseStr) > 0) Then
              Case WiseStr[1] Of
                { Enterprise eComms }
                'A'  : Begin
                         FxUseMAPI  := 0;
                         FaxPrnN    := 'Print to Fax';
                         FaxDLLPath := 'FAXSRV\';
                       End;
                { MAPI / Microsoft Fax / Microsoft Exchange }
                'B'  : Begin
                         FxUseMAPI := 1;
                         FaxPrnN   := 'Microsoft Fax';
                         FaxDLLPath := '';
                       End;
                { Unknown 3rd Party }
                'C'  : Begin
                         FxUseMAPI  := 2;
                         //FaxPrnN   := 'Microsoft Fax'; { Unknown leave as default }
                         FaxDLLPath := '';
                       End;
                { FaxNow3 }
                'D'  : Begin
                         FxUseMAPI  := 2;
                         FaxPrnN    := 'FaxNow!';
                         FaxDLLPath := '';
                       End;
                { FaxNow5 }
                'E'  : Begin
                         FxUseMAPI  := 2;
                         FaxPrnN    := 'FaxNow!';
                         FaxDLLPath := '';
                       End;
              End; { Case WiseStr[1] }
            FxName  := UsrIniF.ReadString ('Entrprse', 'PFaxName', '');
            FxPhone := UsrIniF.ReadString ('Entrprse', 'PFaxNo', '');
          End; { With SyssEDI2^ }
        Finally
          UsrIniF.Free;
        End; { Finally }
      End; { If (WiseStr = '2') }
    End; { If (Pos ('J', WiseStr) > 0) }
  End; { ConfigPaperless }

  {-------------------------------------------------------------------------}

  // MH 13/11/06: Reset the 'Use GL Classes' flag for the first upgrade (Exchequer only)
  Procedure CheckGLClassesFlag (Const IsInstall : Boolean);
  Var
    UsrIniF      : TIniFile;
  Begin // CheckGLClassesFlag
    // Exchequer Only - Exclude for LITE/IAO
    If (W_Install <> 'L') Then
    Begin
      // Check Setup.Usr for flag to indicate whether this process has already been done
      UsrIniF := TIniFile.Create (W_MainDir + '\WSTATION\SETUP.USR');
      Try
        // GLClassesReset - 0=Do Reset, 1=Do Reset on Companies, 2=Already Reset
        If IsInstall Then
        Begin
          // For new installations it shouldn't ever reset the flags
          UsrIniF.WriteInteger('V571', 'GLClassesReset', 2);
        End // If IsInstall
        Else
        Begin
          // Upgrade / Auto-Upgrade
          If (UsrIniF.ReadInteger('V571', 'GLClassesReset', 0) = 0) Then
          Begin
            Syss.UseGLClass := False;

            // Set GLClassesReset to 1 - "Do Reset on Companies" for SCD_ReplicateLicence
            // to pickup so it can perform the process across all companies
            UsrIniF.WriteInteger('V571', 'GLClassesReset', 1);
          End; // If (UsrIniF.ReadInteger('V571', 'GLClassesReset', 0) = 0)
        End; // Else
      Finally
        UsrIniF.Free;
      End; { Finally }
    End; // If (W_Install <> 'L')
  End; // CheckGLClassesFlag

  {-------------------------------------------------------------------------}

Begin { SCD_SetupLicence }
//ShowMessage ('SCD_SetupLicence.Start');

  {$IFDEF locDBUG}
  DBug := TStringList.Create;
  {$ENDIF}

  Try
    DLLStatus := 0;    { Unknown Error }
    SecChkOk  := True; { Security Checked OK }

    { Check security parameter to ensure not called by anyone }
    Params := DLLParams.szParam;
    If (Copy (Params, 1, 5) = '7FSN2') And (Length(Params) = 5) Then Begin
      //ShowMessage ('SCD_SetupLicence.CheckBtrieve');
      { Check Btrieve is running - often comes in handy :-) }
      If Check4BtrvOk Then Begin

        {------------------------------------------------------------------}

        { Get directory of data to set codes in }
        GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
        FixPath (W_MainDir);

        { Setup path of help file }
        Application.HelpFile := W_MainDir + 'ENTRPRSE.HLP';

        { Get Installation Type from WISE - 0=Install, 1=Upgrade, 2=Auto-Upgrade }
        GetVariable(DLLParams, 'I_TYPE', W_LicType);

        { Get Installation Type from WISE - A=Install, B=Upgrade, C=Add Company }
        GetVariable(DLLParams, 'V_INSTTYPE', W_InstType);

        { Get Country version from WISE - 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }
        GetVariable(DLLParams, 'I_COUNTRY', W_Country);

        GetVariable(DLLParams, 'V_INSTALL', W_Install); // 'E' = Exchequer, 'L' = LITE/IAO

        If (UpperCase(Trim(W_LicType)) <> '2') Then Begin
          { Not Auto-Upgrade - Get path of Temporary Licence File }
          GetVariable(DLLParams, 'I_LICFILE', W_LicFile);
          If FileExists (W_LicFile) Then Begin
            { Read ~VBxxx.TMP from Temporary Directory }
            If Not ReadLicFile (W_LicFile, TempLicR) Then Begin
              { Failed to read Licence File }
              DLLStatus := 1004;
            End; { If Not ReadLicFile (W_LicFile, TempLicR) }
          End { If }
          Else Begin
            { Cannot find temporary licence file }
            DLLStatus := 1003;
          End; { Else }
        End; { If }

        {------------------------------------------------------------------}

//ShowMessage ('SCD_SetupLicence.1 Status = ' + IntToStr(DLLStatus));

        If (DLLStatus = 0) Then Begin
          { Open the Enterprise Files }
          If OpenEntFiles Then Begin
            // HM 22/06/00: Ensure all SysF records present
            CheckSysF;

//ShowMessage ('SCD_SetupLicence.2 Status = ' + IntToStr(DLLStatus));

            { Load SysR, ModRR, etc... }
            ReadEntRecords;

//ShowMessage ('SCD_SetupLicence.3 Status = ' + IntToStr(DLLStatus));

            { Check if its an Auto-Upgrade }
            If (UpperCase(Trim(W_LicType)) <> '2') Then Begin
              { Check to see if its a New Installation or an Upgrade }
              If (UpperCase(Trim(W_InstType)) = 'A') Then Begin
                { New Installation  }
                NewInstall;

                { Set Country Code according to licence }
                Syss.USRCntryCode := GetCountryCode(W_Country);

                // MH 13/11/06: Reset the 'Use GL Classes' flag for the first upgrade (Exchequer only)
                CheckGLClassesFlag(True);

                If (DLLStatus = 0) Then
                Begin
                  // MH 05/07/07: Modified to set the ESN in Company Options due to problems in MS SQL Edition
                  DllStatus := UpdateCompOpt;
                End; // If (DLLStatus = 0)
//ShowMessage ('SCD_SetupLicence.4 Status = ' + IntToStr(DLLStatus));
              End { If New_Installation }
              Else Begin
                { Upgrade - Read Licence Details from existing ENTRPRSE.DAT }
                ReadEnterpriseLic;

                { Check that the Security is OK for Upgrades }
                SecChkOk := CheckSystemSecurity;

                If SecChkOk Then Begin
                  { Set ISN }
                  SetSyssISN(False);

                  { Apply Licence changes where applicable }
                  UpdateEntLic;
                End; { If SecChkOk }

                { Check flag to reset country code }
                If TempLicR.licResetCountry Then
                  { Set Country Code according to licence }
                  Syss.USRCntryCode := GetCountryCode(W_Country);

                // MH 13/11/06: Reset the 'Use GL Classes' flag for the first upgrade (Exchequer only)
                CheckGLClassesFlag(False);

//ShowMessage ('SCD_SetupLicence.5 Status = ' + IntToStr(DLLStatus));
              End; { Else }

              If SecChkOk Then Begin
                { Set Demo Flag }
                Syss.ExDemoVer := (EntLicR.licLicType In [1, 2]);


                { Set User Count }
                SetUserCount(EntLicR.licUserCnt);

                { Configure Paperless Module }
                ConfigPaperless;

//ShowMessage ('SCD_SetupLicence.6 Status = ' + IntToStr(DLLStatus));
              End; { If SecChkOk }
            End { If }
            Else Begin
              { Auto-Upgrade - Read Licence Details from ENTRPRSE.DAT }
              ReadEnterpriseLic;

              { Check that the Security is OK for Upgrades }
              SecChkOk := CheckSystemSecurity;

              If SecChkOk Then Begin
                // HM 08/01/02: Changed so that UpdateModRels is called for Auto-Upgrades to
                //              force the security codes to be recalculated for the new v5.00
                //              ESN based system
                UpdateModRels (EntLicR);
              End; { If SecChkOk }

              // MH 13/11/06: Reset the 'Use GL Classes' flag for the first upgrade (Exchequer only)
              CheckGLClassesFlag(False);

//ShowMessage ('SCD_SetupLicence.7 Status = ' + IntToStr(DLLStatus));
            End; { Else }

            If (DLLStatus = 0) And SecChkOk Then
              { Set 30/7 Day Release Code Expiry }
              SetEntExpiry;

            // MH 06/03/06: Added check for LITE as we don't want the popup window
            // for security during the install
            If (DLLStatus = 0) And (W_Install <> 'L') Then
            Begin
              { Display Security Warning }
              If (UpperCase(Trim(W_InstType)) = 'A') Then
                DLLStatus := SCD_SecWarnWizard (W_MainDir, W_MainDir, 1, EntLicR, DoneRelCode)
              Else
                DLLStatus := SCD_SecWarnWizard (W_MainDir, W_MainDir, 2, EntLicR, DoneRelCode);

//ShowMessage ('SCD_SetupLicence.8 Status = ' + IntToStr(DLLStatus));

              { 1 is also a valid return valid }
              If (DLLStatus = 1) Then DLLStatus := 0;
            End; { If }

            If (DLLStatus = 0) Then
            Begin
              // HM 14/12/04: Disable backdoor password for VAO systems, don't reenable it
              // for non-VAO systems as some sites (e.g. Us) have it disabled normally
              If FileExists(W_MainDir + 'VAO.INF') Then
              Begin
                Syss.IgnoreBDPW := True;
              End; // If FileExists(W_MainDir + 'VAO.INF')

              // HM 06/11/00: Added this to ensure TrackSecUpdates doesn't change Entrprse.Dat
              ExMainCoPath^ := 'Wibble';

              { Update PWrdF shadow record }
              TrackSecUpdates(BOff);

              // HM 06/11/00: Added this to ensure TrackSecUpdates doesn't change Entrprse.Dat
              ExMainCoPath^ := '';

              { Update Database }
              UpdateEntRecords;
//ShowMessage ('SCD_SetupLicence.9 Status = ' + IntToStr(DLLStatus));

              // MH 12/01/2017 2017R1 ABSEXCH-17996: Added support for Information Table
              If SQLUtils.UsingSQL Then
              Begin
                // Update the Information Table from the Global SyssMod^ record
                InformationTableFuncs.CheckModuleReleaseCodes (True);
                InformationTableFuncs.CheckLicenceOnlyComponents (EntLicR, True);

                If (UpperCase(Trim(W_InstType)) = 'A') Then
                Begin
                  // MH 16/04/2018 2018-R1 ABSEXCH-20406: Initialise SystemSetup DataVersionNo for New MSSQL Installations
                  SetDataVersion(W_MainDir, V_CURRENTVERSION);
                End; // If (UpperCase(Trim(W_InstType)) = 'A')
              End; // If SQLUtils.UsingSQL
            End; { If }

            If (DLLStatus = 0) Then
              { Update ENTRPRSE.DAT }
              WriteEnterpriseLic;
          End; { If }

          CloseEntFiles;
        End; { If }

        {------------------------------------------------------------------}

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
      GlobExceptHandler(Ex);
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);

  {$IFDEF locDBUG}
  DBug.SaveToFile ('c:\modrel.txt');
  DBug.Free;
  {$ENDIF}

//ShowMessage ('SCD_SetupLicence.Fini Status = ' + IntToStr(DLLStatus));
End; { SCD_SetupLicence }

end.

