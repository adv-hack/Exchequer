unit UserSec;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

Uses Classes, DateUtils, Dialogs, Forms, SysUtils, Windows;


// Returns the number of users licenced for the specified system and the number
// currently logged in.  Assumes Company.Dat already open
// NOTE: Used by oMCMSec dynamically - update if changed
Function GetCurrentUserCounts (Const SysId                       : Char;
                               Var   TotalLicenced, LicencesUsed : SmallInt) : LongInt; Export;

// Returns the true number of users using a company data set in the specified
// system.  NOTE:  assumes Company.Dat already open
// NOTE: Used by oMCMSec dynamically - update if changed
Function GetSystemUserInstances (Const SysId      : Char;
                                 Const CompanyId  : LongInt;
                                 Var   TotalUsers : SmallInt) : LongInt; Export;

// Sets up a Company / Workstation Cross-Reference Record for the specified system
// NOTE: Used by oMCMSec dynamically - update if changed
Function AddLoginRef (Const SysId      : Char;
                      Const CompanyId  : LongInt;
                            WStationId : ShortString;
                            UserId     : ShortString) : LongInt; Export;

// Sets up a Company / Workstation Cross-Reference Record for the specified system
// and returns the Company Code
//
// Return Values:-
//   0              AOK
//   1000           Unknown Error
//   1001           Unknown Exception
//   1002           User Count Exceeded
//   1003           Invalid Company Id
//  10001           Unknown Error locking existing Company XRef record
//  10002           Timed Out trying to get and lock existing Company XRef record
//  11000-11099     Btrieve Error updating existing Company XRef record
//  12000-12099     Btrieve Error adding new Company XRef record
// 100000+          Error in GetCurrentUserCounts getting current user counts
Function AddLoginRefWithCoCode (Const SysId      : Char;
                                Const CompanyId  : LongInt;
                                      WStationId : ShortString;
                                      UserId     : ShortString;
                                Var   CompCode   : ShortString) : LongInt; Export;

// Removes an existing Company / Workstation Cross-Reference Record, Removed is
// returned as True if a reference was found and removed/decremented
Function RemoveLoginRefEx (Const SysId      : Char;
                           Const CompanyId  : LongInt;
                                 WStationId : ShortString;
                                 UserId     : ShortString;
                           Var   Removed    : Boolean) : LongInt; Export;

// Removes an existing Company / Workstation Cross-Reference Record
Function RemoveLoginRef (Const SysId      : Char;
                         Const CompanyId  : LongInt;
                               WStationId : ShortString;
                               UserId     : ShortString) : LongInt; Export;

// Removes all User Counts Cross-Reference records for a specific Company Id -
// used by Ent / TK / Trade etc when exclusive access is gained to the data
// files during startup.
// NOTE: Used by oMCMSec dynamically - update if changed
// MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
// MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandoned v7.1 branch
Function RemoveCIDLoginRefEx (Const CompanyId  : LongInt; Const RemoveExchequer, RemoveToolkit, RemoveTrade : Boolean) : LongInt; Export;
Function RemoveCIDLoginRef (Const CompanyId  : LongInt) : LongInt; Export;

// Opens ExchqSS.Dat and resets the Enterprise Logged In User Count
Function ResetEntUserCount (Const DataPath : ShortString) : LongInt;

// Resets all User Counts for all companies - assumes Company.Dat is open
Function ResetUserCounts (Var ErrInfo : ShortString) : LongInt;

// Checks the passed User Count details to see if they have expired, returns
// true if the expiry date has expired
Function CheckUCountExpiry (Const UCIdx : Byte; Const Lock : Boolean) : Boolean;

// Looks for an existing Company / Workstation Cross-Reference record for the
// Workstation / User on any company.  This indicates whether any new logins
// will use a User Count Licence.
Function CheckForUserLogin (Const SysId      : Char;
                            Const WStationId : ShortString;
                            Const UserId     : ShortString) : Boolean; Export;


// Finds and locks the specified access control record to prevent multiple login/
// logout attempts occuring in parallel as that can cause user count corruption
Function LockControlRec (Const SysId : Char) : LongInt; Export;

// Releases the specified access control record
Procedure UnlockControlRec (Const SysId : Char); Export;

// Formats the Workstation Id for index usage
Function FullWIDKey (Const WStationId : ShortString) : ShortString;


implementation

Uses BtrvU2, GlobVar, VarConst, ETStrU, ETDateU, ETMiscU, BtKeys1U, SecWarn2,
     CompUtil, SecureU, BtSupU1, LicRec, WLicFile, HelpSupU, EntLic, SerialU,
     GlobExch, sysU3, VarFPosU, LicFuncU, ConvData, CompId, SecSup2U,

     // MH 26/02/2013 v7.0.2 ABSEXCH-14083: Added experimental clear-down of cache for Siclops issues
     SQLUtils,
     //ODS,

     LogUtil;

//---------------------------------------------------------------------------

// FullNomKey equivalent for 2 byte integers
Function FullNomKey2 (Const TheNum : SmallInt) : ShortString;
Var
  TmpS : ShortString;
Begin { FullNomKey2 }
  TmpS := '  ';
  Move (TheNum, TmpS[1], 2);
  Result := TmpS;
End; { FullNomKey2 }

//--------------------------------

Function FullWIDKey (Const WStationId : ShortString) : ShortString;
Begin { FullWIDKey }
  Result := LJVar(UpperCase(Trim(WStationId)),40);
End; { FullWIDKey }

//--------------------------------

Function FullUIDKey (Const UserId : ShortString) : ShortString;
Begin { FullUIDKey }
  Result := LJVar(UpperCase(Trim(UserId)),40);
End; { FullUIDKey }

//--------------------------------

// Builds Index 1 for the WId / UserId / CompanyId without the UniqueKey segment
Function BuildWUKKey (Const CompanyId  : LongInt;
                      Const WStationId : ShortString;
                      Const UserId     : ShortString) : ShortString;
Begin { BuildWUKKey }
  Result := FullWIDKey (WStationId) + FullUIDKey (UserId) + FullNomKey(CompanyId);
End; { BuildWUKKey }

//---------------------------------------------------------------------------

// Checks the specified index in Company.Dat to determine a unique key
Function UniqueKey2 (Const IdxNo   : SmallInt;
                     Const RecPFix : ShortString;
                     Const CurrKey : ShortString) : ShortString;
Var
  TmpRecAddr         : LongInt;
  TmpKPath, TmpStat  : Integer;
  lCompany           : CompRec;
  KeyS               : Str255;
  KeyNo, lStatus     : SmallInt;
Begin { UniqueKey2 }
  Result := CurrKey;

  // Save current position and record
  lCompany := Company^;
  TmpKPath := GetPosKey;
  TmpStat := Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOff,BOff);

  // Loop around checking for
  KeyNo := 0;
  Repeat
    Inc (KeyNo);
    KeyS := RecPFix + CurrKey + FullNomKey2 (KeyNo);

    lStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, IdxNo, KeyS);
  Until (lStatus In [4, 9]);

  Result := CurrKey + FullNomKey2 (KeyNo);

  // restore original position and record
  If (TmpStat = 0) Then TmpStat := Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOn,BOff);
  Company^ := lCompany;
End; { UniqueKey2 }

//---------------------------------------------------------------------------

// Returns the number of users licenced for the specified system and the number
// currently logged in.  NOTE:  assumes Company.Dat already open
//
// Return Value:-
//   0              AOK
//   1000           Unknown Exception
//   10000..10099   Error reading Setup Record from Company.Dat
Function GetCurrentUserCounts (Const SysId                       : Char;
                               Var   TotalLicenced, LicencesUsed : SmallInt) : LongInt;
Var
  TmpRecAddr         : LongInt;
  TmpKPath, TmpStat  : Integer;
  lCompany           : CompRec;
  lStatus, EntFull   : SmallInt;
  KeyS               : Str255;
  CurWSID, CurUID    : ShortString;
Begin { GetCurrentUserCounts }
  Try
    Result := 0;    { Unknown Error }

    TotalLicenced := 0;
    LicencesUsed := 0;

    // Save current position in Company.Dat
    TmpKPath:=GetPosKey;
    TmpStat:=Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOff,BOff);

    // Get Total Licenced User Count
    KeyS := cmSetup + CmSetupCode;
    lStatus := Find_Rec(B_GetEq, F[CompF], CompF, lCompany, CompCodeK, KeyS);
    If (lStatus = 0) Then Begin
      { Decode User Count }
      With SyssCompany^.CompOpt Do
        Case SysId Of
          { Enterprise Global User Count }
          // HM 08/01/02: Added Enterprise 30-Day User Count Support
          //cmUserCount      : TotalLicenced := DeCode_Usrs(OptEntUserSecurity, OptEntUserRelease);
          cmUserCount      : Begin
                               // Decode the Enterprise full User Count
                               TotalLicenced := DeCode_Usrs(OptEntUserSecurity, OptEntUserRelease);

                               // Need to check 30-Day vs Full User Counts
                               If Not CheckUCountExpiry (ucEnterprise30, True) Then Begin
                                 // 30-Day is valid - return greater of full and 30-day
                                 If (TotalLicenced < OptSecurity[ucEnterprise30].rcUserCount) Then
                                   TotalLicenced := OptSecurity[ucEnterprise30].rcUserCount;
                               End; { If }
                             End;

          { Toolkit Global User Count }
          cmTKUserCount    : Begin
                               // Need to check 30-Day vs Full User Counts
                               If Not CheckUCountExpiry (ucToolkit30, True) Then Begin
                                 // 30-Day is valid - return greater of full and 30-day
                                 If (OptSecurity[ucToolkitFull].rcUserCount > OptSecurity[ucToolkit30].rcUserCount) Then
                                   TotalLicenced := OptSecurity[ucToolkitFull].rcUserCount
                                 Else
                                   TotalLicenced := OptSecurity[ucToolkit30].rcUserCount;
                               End { If }
                               Else
                                 // No 30-Day code
                                 TotalLicenced := OptSecurity[ucToolkitFull].rcUserCount;
                             End;

          { Trade Counter Global User Count }
          cmTradeUserCount : TotalLicenced := OptSecurity[ucTradeCounter].rcUserCount;
        Else
          Raise Exception.Create ('UserSec.GetCurrentUserCounts - Invalid System Security Id');
        End; { Case SysId }
    End { If (lStatus = 0)  }
    Else
      Result := 10000 + lStatus;

    If (Result = 0) Then Begin
      // Get current logged in user count by counting the xref records for
      // unique Workstation Id / User Id combos - Company Id irrelevent
      CurWSID := '';
      CurUID := '';
      KeyS := SysId;
      lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, lCompany, CompPathK, KeyS);
      While (lStatus = 0) And (lCompany.RecPFix = SysId) Do Begin
        With lCompany.UserRef Do
          // Check to see if checnged to new WSID/UID combo
          If (CurWSId <> ucWStationId) Or (CurUID <> ucUserId) Then Begin
            { Cache up current WSID/UID so changes can be recognized }
            CurWSId := ucWStationId;
            CurUID := ucUserId;

            Inc (LicencesUsed);
          End; { If (CurWSId ... }

        lStatus := Find_Rec(B_GetNext, F[CompF], CompF, lCompany, CompPathK, KeyS);
      End; { While }
    End; { If (Result = 0) }

    // Restore original position in Company.Dat
    If (TmpStat = 0) Then TmpStat:=Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOn,BOff);
  Except
    On Ex:Exception Do
      Result := 1000;
  End;
End; { GetCurrentUserCounts }

//---------------------------------------------------------------------------

// Returns the true number of users using a company data set in the specified
// system.  NOTE:  assumes Company.Dat already open
//
// Return Value:-
//   0              AOK
//   1000           Unknown Exception
Function GetSystemUserInstances (Const SysId      : Char;
                                 Const CompanyId  : LongInt;
                                 Var   TotalUsers : SmallInt) : LongInt;
Var
  TmpRecAddr         : LongInt;
  TmpKPath, TmpStat  : Integer;
  lCompany           : CompRec;
  lStatus, TK, TK30  : SmallInt;
  KeyS               : Str255;
Begin { GetSystemUserInstances }
  Try
    Result := 0;    { Unknown Error }

    TotalUsers := 0;

    // Save current position in Company.Dat
    TmpKPath:=GetPosKey;
    TmpStat:=Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOff,BOff);

    // MH 26/02/2013 v7.0.2 ABSEXCH-14083: Added experimental clear-down of cache for Siclops issues
    If SQLUtils.UsingSQL Then
    Begin
      DiscardCachedData(FileNames[CompF]);
    End; // If SQLUtils.UsingSQL

    // Get current logged in user count by summing the instance count on the
    // xref records for the SystemId + Company Id
    KeyS := SysId + FullNomKey(CompanyId);
    lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, lCompany, CompCodeK, KeyS);
    While (lStatus = 0) And (lCompany.RecPFix = SysId) And (lCompany.UserRef.ucCompanyId = CompanyId) Do Begin
      With lCompany.UserRef Do
        Inc (TotalUsers, ucRefCount);

      lStatus := Find_Rec(B_GetNext, F[CompF], CompF, lCompany, CompCodeK, KeyS);
    End; { While }

    // Restore original position in Company.Dat
    If (TmpStat = 0) Then TmpStat:=Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOn,BOff);
  Except
    On Ex:Exception Do
      Result := 1000;
  End;
End; { GetSystemUserInstances }

//---------------------------------------------------------------------------

// Looks for an existing Company / Workstation Cross-Reference record for the
// specified details and leaves CompF positioned on it if found.
Function FindUserXRef (Const SysId      : Char;
                       Const CompanyId  : LongInt;
                       Const WStationId : ShortString;
                       Const UserId     : ShortString) : Boolean;
Var
  KeyS     : Str255;
  lStatus  : SmallInt;
Begin { FindUserXRef }
  Result := False;

  // Build partial key for available details
  KeyS := SysId + BuildWUKKey (CompanyId, WStationId, UserId);

  lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);

  // Check whether the correct record was found
  With Company^, UserRef Do
    Result := (lStatus = 0) And
              (RecPFix = SysId) And                           { Type of User Count recrd }
              (ucCompanyId = CompanyId) And                   { Company Id that User is logged into }
              (Trim(ucWStationId) = Trim(WStationId)) And     { Computer Name that user is logged in on }
              (Trim(ucUserId) = Trim(UserId));                { Windows User Name of logged in user }
End; { FindUserXRef }

//---------------------------------------------------------------------------

// Looks for an existing Company / Workstation Cross-Reference record for the
// Workstation / User on any company.  This indicates whether any new logins
// will use a User Count Licence.
Function CheckForUserLogin (Const SysId      : Char;
                            Const WStationId : ShortString;
                            Const UserId     : ShortString) : Boolean;
Var
  TmpRecAddr         : LongInt;
  TmpKPath, TmpStat  : Integer;
  lCompany           : ^CompRec;
  KeyS               : Str255;
  lStatus            : SmallInt;
Begin { CheckForUserLogin }
  Result := False;

  // Save current position in Company.Dat
  New (lCompany);
  lCompany^ := Company^;
  TmpKPath:=GetPosKey;
  TmpStat:=Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOff,BOff);

  // Build partial key for available details
  KeyS := SysId + BuildWUKKey (0, WStationId, UserId);

  lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);

  // Check whether the correct record was found
  With Company^, UserRef Do
    Result := (lStatus = 0) And
              (RecPFix = SysId) And                           { Type of User Count recrd }
              (Trim(ucWStationId) = Trim(WStationId)) And     { Computer Name that user is logged in on }
              (Trim(ucUserId) = Trim(UserId));                { Windows User Name of logged in user }

  // Restore original position in Company.Dat
  If (TmpStat = 0) Then TmpStat:=Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOn,BOff);
  Company^ := lCompany^;
End; { CheckForUserLogin }

//---------------------------------------------------------------------------

// Returns True if the specified CompanyId is valid for this Company.Dat
Function ValidateCID (Const CompanyID : LongInt; Var CompCode : ShortString) : Boolean;
Var
  TmpRecAddr         : LongInt;
  TmpKPath, TmpStat  : Integer;
  lCompany           : ^CompRec;
  lStatus            : SmallInt;
  KeyS               : Str255;
Begin { ValidateCID }
  Result := False;
  CompCode := '';

  // Save current position in Company.Dat
  TmpKPath:=GetPosKey;
  TmpStat:=Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOff,BOff);

  // Setup local record for data access
  New (lCompany);

  // Run through Company Details records to find a matching Company Id
  KeyS := cmCompDet;
  lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, lCompany^, CompCodeK, KeyS);
//ShowMessage ('EntComp.UserSec.ValidateCID'#13'lStatus='+IntToStr(lStatus)+#13'RecPFix'+lCompany.RecPFix);
  While (lStatus = 0) And (lCompany.RecPFix = cmCompDet) And (Not Result) Do Begin
//ShowMessage ('EntComp.UserSec.ValidateCID'#13'FindCompanyId='+IntToStr(CompanyId)+#13'DBCompanyId='+IntToStr(lCompany.CompDet.CompId));
    If (lCompany.CompDet.CompId = CompanyId) Then
    Begin
      // Company Id found
      CompCode := lCompany.CompDet.CompCode;
      Result := True;
    End // If (lCompany.CompDet.CompId = CompanyId)
    Else
      // try next company detail record
      lStatus := Find_Rec(B_GetNext, F[CompF], CompF, lCompany^, CompCodeK, KeyS);
  End; { While }

  // Restore original position in Company.Dat
  If (TmpStat = 0) Then TmpStat:=Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOn,BOff);
  Dispose (lCompany);
End; { ValidateCID }

//---------------------------------------------------------------------------

// Sets up a Company / Workstation Cross-Reference Record for the specified system
//
// Return Values:-
//   0              AOK
//   1000           Unknown Error
//   1001           Unknown Exception
//   1002           User Count Exceeded
//   1003           Invalid Company Id
//  10001           Unknown Error locking existing Company XRef record
//  10002           Timed Out trying to get and lock existing Company XRef record
//  11000-11099     Btrieve Error updating existing Company XRef record
//  12000-12099     Btrieve Error adding new Company XRef record
// 100000+          Error in GetCurrentUserCounts getting current user counts
Function AddLoginRef (Const SysId      : Char;
                      Const CompanyId  : LongInt;
                            WStationId : ShortString;
                            UserId     : ShortString) : LongInt;
Var
  CompCode : ShortString;
Begin // AddLoginRef
  CompCode := '';
  Result := AddLoginRefWithCoCode (SysId, CompanyId, WStationId, UserId, CompCode);
End; // AddLoginRef

//------------------------------

// Sets up a Company / Workstation Cross-Reference Record for the specified system
// and returns the Company Code
//
// Return Values:-
//   0              AOK
//   1000           Unknown Error
//   1001           Unknown Exception
//   1002           User Count Exceeded
//   1003           Invalid Company Id
//  10001           Unknown Error locking existing Company XRef record
//  10002           Timed Out trying to get and lock existing Company XRef record
//  11000-11099     Btrieve Error updating existing Company XRef record
//  12000-12099     Btrieve Error adding new Company XRef record
// 100000+          Error in GetCurrentUserCounts getting current user counts
Function AddLoginRefWithCoCode (Const SysId      : Char;
                                Const CompanyId  : LongInt;
                                      WStationId : ShortString;
                                      UserId     : ShortString;
                                Var   CompCode   : ShortString) : LongInt;
Var
  KeyS                         : Str255;
  lStatus                      : SmallInt;
  LockPos, Res                 : LongInt;
  OK, Locked, GotRec, FiniLoop : Boolean;
  TotalLicenced, LicencesUsed  : SmallInt;
  ExitTime                     : TDateTime;
Begin { AddLoginRefWithCoCode }
  Result := 1000;
  CompCode := '';

//ShowMessage ('EntComp.UserSec.AddLoginRef'#13'CompanyId='+IntToStr(CompanyId));

  Try
    // Ensure consistent formatting of WSID / UID
    WStationId := FullWIDKey (WStationId);
    UserId     := FullUIDKey (UserId);

    // Check that the Company Id is valid
    If ValidateCID (CompanyID, CompCode) Then Begin
      // HM 06/08/03: Rewrote this section as there was a window where a program logging
      // out could delete the record seen by FindUserXRef so that the locking routine
      // within GetMultiRec when into an infinite loop with Error 8's (Invalid Position)

      // retry several times as record could be being updated by
      // other processes on the same machine
      Randomize;
      ExitTime := IncSecond(Now, 30); // Retry automatically for 30 seconds
      FiniLoop := False;
      Repeat
        // Check for an existing Company / Workstation Cross-Reference Record for
        // this SysId / Company Id / WStation Id / User Id
        GotRec := FindUserXRef (SysId, CompanyId, WStationId, UserId);

        If GotRec Then
        Begin
          // Existing xref record found - try to lock it
          lStatus := GetPos(F[CompF],CompF,LockPos);
          If (lStatus = 0) Then
          Begin
            SetDataRecOfsPtr(CompF,LockPos,RecPtr[CompF]^);
            lStatus:=GetDirect(F[CompF],CompF,RecPtr[CompF]^,CompPathK,B_SingNWLock+B_MultLock);  // Multi No-Wait Lock

            If (lStatus = 0) Then
            Begin
              // Got and locked - Update record
              Inc (Company^.UserRef.ucRefCount);
              lStatus := Put_Rec (F[CompF], CompF, RecPtr[CompF]^, CompPathK);
              If (lStatus <> 0) Then
                // Error incrementing Reference Count
                Result := 11000 + lStatus
              Else
                // AOK
                Result := 0;

              // Unlock record
              UnlockMultiSing(F[CompF], CompF, LockPos);

              // Exit the loop - update either done or failed
              FiniLoop := True;
            End; // If (lStatus = 0)
          End; // If (lStatus = 0)

          If (Not FiniLoop) Then
          Begin
            // Exit the loop if we have passed the timeout
            FiniLoop := (Now > ExitTime);

            If FiniLoop Then
              // Error 10002 - Timed Out trying to get and lock existing Company XRef record
              Result := 10002
            Else
              // Going to go around the loop again - Wait for random period between 1/100 and 1/5th
              // of a second to allow other apps a chance to clear up whatever the problem is
              Delay(10 + Random(190), True);
          End; // If (Not FiniLoop)
        End; // If GotRec

        // Drop out of the loop if there is no record to update, or if the update has
        // either completed successfully or failed, or if the timeout as kicked in
      Until (Not GotRec) Or FiniLoop;


//      // Check for an existing Company / Workstation Cross-Reference Record for
//      // this SysId / Company Id / WStation Id / User Id
//      If FindUserXRef (SysId, CompanyId, WStationId, UserId) Then Begin
//        // Existing xref record found - lock and increment ref count
//        Locked := False;
//        If GetMultiRec(B_GetDirect, B_MultLock, KeyS, CompCodeK, CompF, BOn, Locked) Then Begin
//          // Get Position
//          lStatus := GetPos (F[CompF], CompF, LockPos);
//
//          // Update record
//          Inc (Company^.UserRef.ucRefCount);
//          lStatus := Put_Rec (F[CompF], CompF, RecPtr[CompF]^, CompPathK);
//          If (lStatus <> 0) Then
//            // Error incrementing Reference Count
//            Result := 11000 + lStatus
//          Else
//            // AOK
//            Result := 0;
//
//          // Unlock record
//          UnlockMultiSing(F[CompF], CompF, LockPos);
//        End { If GetMultiRec }
//        Else
//          // Error locking Company XRef record
//          Result := 10001;
//      End { If FindUserXRef }
//      Else Begin

      If (Not GotRec) Then Begin
        // No existing xref record for this company - Check User Count Security
        OK := CheckForUserLogin (SysId, WStationId, UserId);

        If (Not OK) Then Begin
          // No existing Login for WID / UID - Check Security Counts for free licences
          Res := GetCurrentUserCounts (SysId, TotalLicenced, LicencesUsed);
          If (Res = 0) Then
            OK := (LicencesUsed < TotalLicenced)
          Else
            // Error Getting current user counts
            Result := 100000 + Res;
        End; { If (Not OK) }

        If OK Then Begin
          // Security OK - generate new xref record
          FillChar (Company^, SizeOf(Company^), #0);
          With Company^ Do Begin
            RecPFix := SysId;

            With UserRef Do Begin
              ucCompanyId  := CompanyId;     { Company Id that User is logged into }
              ucWStationId := WStationId;    { Computer Name that user is logged in on }
              ucUserId     := UserId;        { Windows User Name of logged in user }

              ucCode := UniqueKey2 (CompCodeK, RecPFix, FullNomKey (ucCompanyId));
              // MH 15/02/2013 v7.0.2 ABSEXCH-13994: Added Company Code to reduce data operations
              //                                     required when removing Ghost Users 
              ucName := CompCode;
              ucPath := UniqueKey2 (CompPathK, RecPFix, BuildWUKKey (ucCompanyId, ucWStationId, ucUserId));

              ucRefCount   := 1;             { Reference Count for this record }
            End; { With UserRef }
          End; { With Company }

          // Add record into database
          lStatus := Add_Rec (F[CompF], CompF, RecPtr[CompF]^, CompCodeK);
          If (lStatus = 0) Then
            // AOK
            Result := 0
          Else
            // Error adding XRef Reference record
            Result := 12000 + lStatus;
        End { If OK }
        Else
          // User Count Exceeded
          Result := 1002;
      End; { Else }
    End { If ValidateCID (CompanyID) }
    Else
      // Invalid Company Id
      Result := 1003;
  Except
    On Exception Do
    Result := 1001;
  End;
End; { AddLoginRefWithCoCode }

//---------------------------------------------------------------------------

// Removes an existing Company / Workstation Cross-Reference Record, Removed is
// returned as True if a reference was found and removed/decremented
//
// Return Values:-
//   0              AOK
//   1000           Unknown Error
//   1001           Unknown Exception
//  10001           Unknown Error locking existing Company XRef record
//  11000-11099     Btrieve Error updating existing Company XRef record
//  12000-12099     Btrieve Error deleting Company XRef record
Function RemoveLoginRefEx (Const SysId      : Char;
                           Const CompanyId  : LongInt;
                                 WStationId : ShortString;
                                 UserId     : ShortString;
                           Var   Removed    : Boolean) : LongInt;
Var
  KeyS     : Str255;
  lStatus  : SmallInt;
  LockPos  : LongInt;
  Locked   : Boolean;
Begin { RemoveLoginRefEx }
  Result := 1000;
  Removed := False;

  Try
    // Ensure consistent formatting of WSID / UID
    WStationId := FullWIDKey (WStationId);
    UserId     := FullUIDKey (UserId);

    // Check for an existing Company / Workstation Cross-Reference Record for
    // this SysId / Company Id / WStation Id / User Id
    If FindUserXRef (SysId, CompanyId, WStationId, UserId) Then Begin
      // Existing xref record found - lock it and check ref count
      Locked := False;
      If GetMultiRec(B_GetDirect, B_MultLock, KeyS, CompCodeK, CompF, BOn, Locked) Then Begin
        // Check Ref Count
        If (Company^.UserRef.ucRefCount <= 1) Then Begin
          // Delete it
          lStatus := Delete_Rec (F[CompF], CompF, 0);
          If (lStatus = 0) Then Begin
            // AOK - Set removed to true to indicate removal of a login reference
            Result := 0;
            Removed := True;
          End { If (lStatus = 0) }
          Else
            // Error deleting XRef record
            Result := 12000 + lStatus;
        End { If (Company^.UserRef.ucRefCount <= 1) }
        Else Begin
          // Still logged in - reduce count and update
          lStatus := GetPos (F[CompF], CompF, LockPos);

          // Update record
          Dec (Company^.UserRef.ucRefCount);
          lStatus := Put_Rec (F[CompF], CompF, RecPtr[CompF]^, CompPathK);
          If (lStatus <> 0) Then
            // Error incrementing Reference Count
            Result := 11000 + lStatus
          Else Begin
            // AOK - Set removed to true to indicate removal of a login reference
            Result := 0;
            Removed := True;
          End; { Else }

          // Unlock record
          UnlockMultiSing(F[CompF], CompF, LockPos);
        End; { Else }
      End { If GetMultiRec }
      Else
        // Error locking Company XRef record
        Result := 10001;
    End { If }
    Else
      // Error finding existing Login Reference record - Do Anything?
      Result := 0;
  Except
    On Exception Do
      Result := 1001;
  End;
End; { RemoveLoginRefEx }

//---------------------------------------------------------------------------

// Removes an existing Company / Workstation Cross-Reference Record
Function RemoveLoginRef (Const SysId      : Char;
                         Const CompanyId  : LongInt;
                               WStationId : ShortString;
                               UserId     : ShortString) : LongInt;
Var
  DummyBool : Boolean;
Begin
  Result := RemoveLoginRefEx(SysId, CompanyId, WStationId, UserId, DummyBool);
End;

//---------------------------------------------------------------------------

// Removes all User Counts Cross-Reference records for a specific Company Id -
// used by Ent / TK / Trade etc when exclusive access is gained to the data
// files during startup.
//
// If a Company Id of 0 is specified then ALL XRef records will be deleted. 
//
// NOTE: Assumes Company.Dat is open, doesn't save / restore positions
//
// Return Values:-
//   0              AOK
//   1000           Unknown Exception
//  10000+          Error deleting Enterprise User Count XRef records
//  20000+          Error deleting Toolkit User Count XRef records
//  30000+          Error deleting Trade Counter User Count XRef records
//
// MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
// MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandonded v7.1 branch
//
Function RemoveCIDLoginRefEx (Const CompanyId  : LongInt; Const RemoveExchequer, RemoveToolkit, RemoveTrade : Boolean) : LongInt;
Var
  TmpRecAddr         : LongInt;
  TmpKPath, TmpStat  : Integer;
  lCompany           : CompRec;

  Function RemoveSysIdLoginRefs (Const SysId : Char; Const CompanyId  : LongInt; Const ErrOfs : LongInt) : LongInt;
  Var
    KeyS     : Str255;
    lStatus  : SmallInt;
    LockPos  : LongInt;
  Begin { RemoveSysIdLoginRefs }
    Result := 0;

    Try
      KeyS := SysId + FullNomKey (CompanyId);
      lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
      While (lStatus = 0) And
            (Company^.RecPFix = SysId) And
           ((Company^.UserRef.ucCompanyId = CompanyId) Or (CompanyId = 0)) Do Begin
        Delete_Rec (F[CompF], CompF, 0);

        lStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
      End; { While ... }
    Except
      On Exception Do
        Result := ErrOfs;
    End;
  End; { RemoveSysIdLoginRefs }

Begin // RemoveCIDLoginRefEx
  Try
    // Save current position and record
    lCompany := Company^;
    TmpKPath := GetPosKey;
    TmpStat := Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOff,BOff);

    If RemoveExchequer Then
    Begin
      { Remove Enterprise User Count records }
      Result := RemoveSysIdLoginRefs (cmUserCount, CompanyId, 10000);
    End; // If RemoveExchequer

    { Remove Toolkit User Count records }
    If (Result = 0) And RemoveToolkit Then
    Begin
      Result := RemoveSysIdLoginRefs (cmTKUserCount, CompanyId, 20000);
    End; // If (Result = 0) And RemoveToolkit

    { Remove Trade Counter User Count records }
    If (Result = 0) And RemoveTrade Then
    Begin
      Result := RemoveSysIdLoginRefs (cmTradeUserCount, CompanyId, 30000);
    End; // If (Result = 0) And RemoveTrade

    // restore original position and record
    If (TmpStat = 0) Then TmpStat := Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOn,BOff);
    Company^ := lCompany;
  Except
    On Exception Do
      Result := 1000;
  End;
End; // RemoveCIDLoginRefEx

//------------------------------

// MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
// MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandoned v7.1 branch
Function RemoveCIDLoginRef (Const CompanyId  : LongInt) : LongInt;
Begin // RemoveCIDLoginRef
  Result := RemoveCIDLoginRefEx (CompanyId, True, True, True);
End; // RemoveCIDLoginRef

//---------------------------------------------------------------------------

// Opens ExchqSS.Dat and resets the Enterprise Logged In User Count
//
// Errors:-
//   1000          Unknown Exception
//   1001          Unknown Error reading or locking SysR
//   1002          Unknown Error reading or locking ModRR
//  10000          Btrieve Error opening ExchqSS.Dat
Function ResetEntUserCount (Const DataPath : ShortString) : LongInt;
Var
  SLocked : Boolean;
  lStatus : SmallInt;
Begin { ResetEntUserCount }
  Result := 0;

  Try
    // Open ExchQss.Dat in the Company Data Set
    lStatus := Open_File(F[SysF], DataPath + FileNames[SysF], 0);
    If (lStatus = 0) Then Begin
      // Get SysR - Lock it and reset the Logged in User Count
      SLocked := True;
      If GetMultiSys(False, SLocked, SysR) Then Begin
        Syss.EntULogCount := 0;
        PutMultiSys(SysR, True);
      End { If GetMultiSys }
      Else
        // Error reading sysR
        Result := 1001;

      If (Result = 0) Then Begin
        // Get ModRR - Lock it and reset the Toolkit and Trade Counter Logged in User Counts
        SLocked := True;
        If GetMultiSys(False, SLocked, ModRR) Then Begin
          SyssMod^.ModuleRel.TKLogUCount := 0;
          SyssMod^.ModuleRel.TrdLogUCount := 0;
          PutMultiSys(ModRR, True);
        End { If GetMultiSys }
        Else
          // Error reading ModRR
          Result := 1002;
      End; { If (Result = 0) }

      { Close ExchQSS.Dat }
      Close_File(F[SysF]);
    End { If (LStatus = 0) }
    Else
      // Error opening SysF in Company Data Set
      Result := 10000 + LStatus;
  Except
    On Exception Do
      Result := 1000;
  End;
End; { ResetEntUserCount }

//---------------------------------------------------------------------------

// Resets all User Counts for all companies - assumes Company.Dat is open
//
// Errors:-
//   1000          Unknown Exception
//   1001          Unknown Error reading or locking SysR
//  10000          Btrieve Error opening ExchqSS.Dat
//  20000+         Error in RemoveCIDLoginRef with 20k offset
Function ResetUserCounts (Var ErrInfo : ShortString) : LongInt;
Var
  KeyS    : Str255;
  lStatus : LongInt;
  FPath   : ShortString;
  SLocked : Boolean;
Begin { ResetUserCounts }
  Result := 0;
  ErrInfo := '';

  Try
    KeyS := cmCompDet;
    lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    While (LStatus = 0) And (Result = 0) And (Company^.RecPFix = cmCompDet) Do Begin
      // Set Error Info to company details - if there is a problem it can be
      // narrowed down to at least one company
      ErrInfo := Trim(Company.CompDet.CompCode) + ' - ' + Trim(Company.CompDet.CompName);

      // Company Data Set - Check the Data Set exists
      If IsValidCompany (Company.CompDet.CompPath) Then Begin
        // ensure company dir path is formatted correctly
        FPath := IncludeTrailingBackslash(Trim(Company.CompDet.CompPath));

        // Reset the Enterprise Logged In User Count
        Result := ResetEntUserCount (FPath);
      End; { If IsValidCompany (... }

      lStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    End; { While (lStatus = 0) ... }

    If (Result = 0) Then Begin
      // Remove all Company / Workstation Cross-Reference records
      Result := RemoveCIDLoginRef (0);
      If (Result <> 0) Then Result := Result + 20000;
    End; { If (Result = 0) }
  Except
    On Exception Do
      Result := 1000;
  End;
End; { ResetUserCounts }

{-------------------------------------------------------------------------}

// Checks the passed User Count details to see if they have expired, returns
// true if the expiry date has expired.  If newly expired the expiry date
// will be reset to 0, the Lock parameter controls whether the security
// record is reread and locked before the update or just updated
Function CheckUCountExpiry (Const UCIdx : Byte; Const Lock : Boolean) : Boolean;
Var
  RelDOW     : Byte;
  RelDateStr : LongDate;
  SecDays    : LongInt;
  Rd,Rm,Ry   : Word;
  CurrTime   : TimeTyp;
Begin { CheckUCountExpiry }
  // Check to see if it is a 30-Day user count before continuing
  If (UCIdx In uc30DaySet) Then Begin
    // 30-Day count - check expiry date
    With SyssCompany^.CompOpt.OptSecurity[UCIdx] Do Begin
      // Convert Julian Expiry Date to Day, Month Year values
      JulCal(rcExpiry, Rd, Rm, Ry);

      // Reformat as YYYYMMDD string
      RelDateStr := StrDate(Ry,Rm,Rd);

      // Calculate number of days between today and the expiry date
      SecDays := ABS(NoDays(Today,RelDateStr));

      // Get current time and Day of week to see if we can expire it now
      GetCurrTime(CurrTime);
      RelDOW := DayofWeek(Today);

      // Avoid triggering outside office hours, or on a Fri-Mon
      Result := ((RelDateStr < Today) And (RelDOW In [2..4]) and (CurrTime.HH >= 9) and (CurrTime.HH < 17)) Or
                (SecDays > AbsMaxDays) Or        // Unless its passed 45 days
                (rcExpiry = 0);                  // or it has already expired
    End; { With SyssCompany^.CompOpt.OptSecurity[UCIdx] }

    If Result and (SyssCompany^.CompOpt.OptSecurity[UCIdx].rcExpiry <> 0) Then Begin
      // Newly Expired - reset data to prevent date being moved back to re-enable

      If Lock Then
        // Reload and Lock the security record
        LoadnLockCompanyOpt;

      // Reset expiry date
      With SyssCompany^.CompOpt.OptSecurity[UCIdx] Do Begin
        rcUserCount := 0;
        rcExpiry := 0;
      End; { With }

      // Update secrec unlocking as appropriate
      PutCompanyOpt (Lock);
    End; { If }
  End { If (UCIdx In uc30DaySet) }
  Else
    // Not a 30-Day user count entry
    Result := False;
End; { CheckUCountExpiry }

{-------------------------------------------------------------------------}

Function BuildAccessControlIdx(Const RecPFix, SystemId : Char) : ShortString;
Begin // BuildAccessControlIdx
  Result := RecPFix + SystemId + StringOfChar (' ', CompCodeLen - 1);
End; // BuildAccessControlIdx

//------------------------------

// Finds and locks the specified access control record to prevent multiple login/
// logout attempts occuring in parallel as that can cause user count corruption
//
//   0     AOK
//   1000  Unknown Error
//   1001  Timeout
Function LockControlRec (Const SysId : Char) : LongInt;
Var
  ExitTime : TDateTime;
  sKey     : Str255;
  iStatus, LastErr, LastErrType : SmallInt;
  Retry    : Boolean;
  Timeout  : Boolean;
  LockPos  : LongInt;
Begin // LockControlRec
//ODS.OutputString ('LockControlRec.Start');
  LastErrType := -1;
  LastErr := -1;

  Result := 1000;

  ExitTime := IncSecond(Now, 30); // Retry automatically for 30 seconds
  TimeOut := False;
  Repeat
    Retry := False;
                                   
    // Check that the access control record exists
    sKey := BuildAccessControlIdx(cmAccessControl, cmAccessControl{SysId});
    iStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
    Case iStatus Of
      // 0 - Lock the Access Control Record
      0   : Begin
              // Get record position and lock the record - use a multi-lock as other System Ids
              // may need to be locked at the same time by other processes
              iStatus := GetPos(F[CompF], CompF, LockPos);
              If (iStatus = 0) Then
              Begin
                SetDataRecOfsPtr(CompF, LockPos, RecPtr[CompF]^);
                iStatus := GetDirect(F[CompF], CompF, RecPtr[CompF]^, CompPathK, B_SingNWLock+B_MultLock);  // Multi No-Wait Lock
                If (iStatus = 0) Then
                Begin
                  Retry := False;
                  Result := 0;
                End // If (iStatus = 0)
                Else
                Begin
                  Retry := True;  // Record lock failed
                  LastErrType := 0;
                  LastErr := iStatus;

                  // MH 26/02/2013 v7.0.2 ABSEXCH-14083: Added (missing) pause to allow apps to de-sync
                  //                                     whilst in this loop
//ODS.OutputString ('LockControlRec.LockErrorPause (iStatus=' + IntToStr(iStatus) + ')');
                  Sleep(10 + Random(190));
                End; // Else
              End // If (iStatus = 0)
              Else
              Begin
                Retry := True; // Get Position failed - in theory this can't happen
                LastErrType := 1;
                LastErr := iStatus;
              End; // Else

              If Retry Then Application.ProcessMessages;
            End; // 0

       // 4 - Add Access Control Record and retry
      4   : Begin
              // Initialise the ACR
              FillChar(Company^, SizeOf(Company^), #0);
              Company^.RecPFix := cmAccessControl;
              Company^.AccessControl.acCode := cmAccessControl{SysId} + StringOfChar (' ', CompCodeLen - 1);
              Company^.AccessControl.acPath := cmAccessControl{SysId} + StringOfChar (' ', CompPathLen - 1);
              Company^.AccessControl.acSystemId := cmAccessControl{SysId};

              iStatus := Add_Rec (F[CompF], CompF, RecPtr[CompF]^, CompCodeK);
              Retry := True;
            End; // 4
    Else
      // MH 26/02/2013 v7.0.2 ABSEXCH-14083: Added experimental clear-down of cache for Siclops issues
//ODS.OutputString ('LockControlRec.ReadErrorPause (iStatus=' + IntToStr(iStatus) + ')');
      Sleep(10 + Random(190));
    End; // Case iStatus

    If (Now > ExitTime) Then
    Begin
      TimeOut := True;
      Result := 1001;  // Timeout

      // Write Log
      LogDir := IncludeTrailingPathDelimiter(SetDrive) + 'Logs\';
      With TLogFile.Create ('User Count Control') Do
      Begin
        Try
          Add ('Log Type : LockControlRec Timeout');
          Add ('');
          Case LastErrType Of
            0 : Add ('Lock Error: ' + IntToStr(LastErr));
            1 : Add ('GetPosition Error: ' + IntToStr(LastErr));
          End; // Case LastErrType
          SaveLog;
        Finally
          Free;
        End; // Try..Finally
      End; // With TLogFile.Create ('User Count Control')
    End; // If (Now > ExitTime)
  Until (Not Retry) Or TimeOut;
//ODS.OutputString ('LockControlRec.Finish');
End; // LockControlRec

//------------------------------

// Releases the specified access control record
Procedure UnlockControlRec (Const SysId : Char);
Var
  ExitTime : TDateTime;
  sKey     : Str255;
  iStatus, LastErr, LastErrType : SmallInt;
  Retry    : Boolean;
  Timeout  : Boolean;
  LockPos  : LongInt;
Begin // UnlockControlRec
//ODS.OutputString ('UnlockControlRec.Start');
  LastErr := -1;
  LastErrType := -1;

  ExitTime := IncSecond(Now, 30); // Retry automatically for 30 seconds
  TimeOut := False;
  Repeat
    Retry := False;

    // Check that the access control record exists
    sKey := BuildAccessControlIdx(cmAccessControl, cmAccessControl{SysId});
    iStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
    Case iStatus Of
      // 0 - Lock the Access Control Record
      0   : Begin
              // Get record position and lock the record - use a multi-lock as other System Ids
              // may need to be locked at the same time by other processes
              iStatus := GetPos(F[CompF], CompF, LockPos);
              If (iStatus = 0) Then
              Begin
                // Unlock record
                iStatus := UnlockMultiSing(F[CompF], CompF, LockPos);
                If (iStatus = 0) Then
                Begin
                  Retry := False;
                End // If (iStatus = 0)
                Else
                Begin
                  Retry := True;  // Record unlock failed
                  LastErrType := 0;
                  LastErr := iStatus;
                End; // Else
              End // If (iStatus = 0)
              Else
              Begin
                Retry := True; // Get Position failed - in theory this can't happen
                LastErrType := 1;
                LastErr := iStatus;
              End; // Else
            End; // 0

      // 4 - Record Not Found
      4   : Begin
              Retry := False;
            End; // 4
    End; // Case iStatus

    If (Now > ExitTime) Then
    Begin
      Timeout := True;

      // Write Log
      LogDir := IncludeTrailingPathDelimiter(SetDrive) + 'Logs\';
      With TLogFile.Create ('User Count Control') Do
      Begin
        Try
          Add ('Log Type : UnlockControlRec Timeout');
          Add ('');
          Case LastErrType Of
            0 : Add ('Unlock Error: ' + IntToStr(LastErr));
            1 : Add ('GetPosition Error: ' + IntToStr(LastErr));
          End; // Case LastErrType
          SaveLog;
        Finally
          Free;
        End; // Try..Finally
      End; // With TLogFile.Create ('User Count Control')
    End; // If (Now > ExitTime)

    If Retry And (Not TimeOut) Then Application.ProcessMessages;
  Until (Not Retry) Or TimeOut;
//ODS.OutputString ('UnlockControlRec.Finish');
End; // UnlockControlRec

//-------------------------------------------------------------------------

end.
