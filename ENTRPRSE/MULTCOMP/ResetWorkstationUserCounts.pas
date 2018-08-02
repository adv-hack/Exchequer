unit ResetWorkstationUserCounts;

interface

Uses Classes, Dialogs, SysUtils, GlobVar, VarConst, BtrvU2;

// Remove the supplied User Count record - assumes we are currently positioned on it
//
// Return Values:-
//
//   0        AOK
//   1        Invalid Company
//   2        Invalid Company Path
//   100000+  Error opening company ExchqSS.Dat
//   200000+  Error starting DB Transaction
//   300000+  Error Reading/Locking ExchqSS record
//   400000+  Error Reading/Locking User Count record
//   500000+  Error Updating ExchqSS record
//   600000+  Error Deleting ExchqSS record
//   700000+  Error Ending DB Transaction
//   800000+  Error Aborting DB Transaction
//
Function RemoveWorkstationUserCount (UserCountRec : CompRec) : Integer;

// MH 14/02/2012 v7.0.2 ABSEXCH-13994: Added function to reset user counts for a workstation
Procedure ResetWorkstationUCounts (Const ResetEnter1, ResetToolkit, ResetTrade : Boolean);


implementation

Uses BTKeys1U, APIUtil, TermServ, EntLicence, UserSec, SQLUtils;

Const
  {$I FilePath.Inc}

//=========================================================================

// Copied from TMCMSecurity.Create (oMCMSec.pas)
Function GetWorkstationId : ShortString;
Begin // GetWorkstationId
  Try
    // Get global TerminalServices object
    With TerminalServices Do
    Begin
      // Check to see if running under Terminal Server
      If IsTerminalServerSession Then
        // Running under Terminal Server use SessionId instead of Computer Name
        Result := 'TS-Session:' + IntToStr(SessionId)
      Else
        // Not running under Terminal Server or some sort of error
        Result := UpperCase(WinGetComputerName);
    End; { With TerminalServices }
  Except
    On Exception Do
      // Windows Workstation Name
      Result := UpperCase(WinGetComputerName);
  End;
End; // GetWorkstationId

//-------------------------------------------------------------------------

// Remove the supplied User Count record - assumes we are currently positioned on it
//
// Return Values:-
//
//   0        AOK
//   1        Invalid Company
//   2        Invalid Company Path
//   100000+  Error opening company ExchqSS.Dat
//   200000+  Error starting DB Transaction
//   300000+  Error Reading/Locking ExchqSS record
//   400000+  Error Reading/Locking User Count record
//   500000+  Error Updating ExchqSS record
//   600000+  Error Deleting User Count record
//   700000+  Error Ending DB Transaction
//   800000+  Error Aborting DB Transaction
//
Function RemoveWorkstationUserCount (UserCountRec : CompRec) : Integer;
Var
  UserCountRecPos : Integer;
  sKey : Str255;
  lStatus : Integer;
  sPath : ShortString;
  bUnlockSys : Boolean;
Begin // RemoveWorkstationUserCount
  // NOTE: Have decided to fail silently wherever possible - last think we need is more
  // errors occurring from the user count security
  Result := 0;

  // Save the User Count record's record position for later reference
  GetPos(F[CompF], CompF, UserCountRecPos);

  // Find the Company record for the User Count record so we can get the data path
  sKey := FullCompCodeKey(cmCompDet, UserCountRec.UserRef.ucName);
  lStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
  If (lStatus = 0) Then
  Begin
    // Check if data path is valid - it is possible that different paths are used to access
    // the same company dataset and it may not be currently valid
    sPath := IncludeTrailingPathDelimiter(Trim(Company^.CompDet.CompPath));
    If SQLUtils.ValidCompany(sPath) Then
    Begin
      // Open Exchqss for the company
      lStatus := Open_File(F[SysF], sPath + FileNames[SysF], 0);
      If (lStatus = 0) Then
      Begin
        Try
          // Begin a database transaction to ensure atomic updates to the two separate user counts in
          // ExchqSS.Dat and Company.Dat
          lStatus := Ctrl_BTrans(1019);
          If (lStatus = 0) Then
          Begin
            // MH 24/01/2017 2017-R1 ABSEXCH-13259: Removed ExchqSS side of Toolkit User Counts -
            // extensively restructured this routine to allow the Toolkit Reset to avoid updating
            // ExchqSS as that is a nightmare time-sucking black hole in the SQL Emulator

            // Re-read the User Count record using the previously stored position  - the lookup
            // of the Company record moved the current position - this also puts us in the
            // correct position for the Delete call which then allows us to continue the loop
            // where we left off in the parent routine which called this routine
            sKey := '';
            Move (UserCountRecPos, Company^, SizeOf(UserCountRecPos));
            lStatus := Find_Rec(B_GetDirect + B_SingNWLock, F[CompF], CompF, RecPtr[CompF]^, CompPathK, sKey);
            If (lStatus = 0) Then
            Begin
              Try
                // MH 24/01/2017 2017-R1 ABSEXCH-13259: Handle Toolkit User Counts separately to avoid Exchqss
                If (UserCountRec.RecPFix = cmTKUserCount) Then
                Begin
                  // Delete the User Count Record
                  lStatus := Delete_Rec (F[CompF], CompF, CompPathK);
                  If (lStatus <> 0) Then
                    // Error Deleting User Count record
                    Result := 600000 + lStatus;
                End // If (UserCountRec.RecPFix = cmTKUserCount)
                Else Begin
                  // Read the appropriate system setup record containing the user counts
                  If (UserCountRec.RecPFix = cmUserCount) Then
                    // Exchequer User Counts are stored in the main System Setup record
                    sKey := SysNames[SysR]
                  Else If (UserCountRec.RecPFix = cmTradeUserCount) Then
                    // Trade Counter User Counts are stored in the Module Release Code record
                    sKey := SysNames[ModRR]
                  Else
                    // Shouldn't ever happen
                    Raise Exception.Create ('RemoveWorkstationUserCount: Unknown RecPFix (' + IntToStr(Ord(UserCountRec.RecPFix))  + '), please contact your technical support');

                  // Apply a Single No-Wait record lock - use no wait so it fails instantly if someone
                  // else is editing system setup for example - don't want to to appear to hang whilst it
                  // waits on a Wait Lock
                  lStatus := Find_Rec(B_GetEq + B_SingNWLock, F[SysF], SysF, RecPtr[SysF]^, 0, sKey);
                  If (lStatus = 0) Then
                  Begin
                    bUnlockSys := True;
                    Try
                      // Reduce the User Count in the System Setup record
                      Case Company^.RecPFix Of
                        // Exchequer
                        cmUserCount      : Syss.EntULogCount := Syss.EntULogCount - Company^.UserRef.ucRefCount;
                        // Trade Counter
                        cmTradeUserCount : Syss.Modules.TrdLogUCount := Syss.Modules.TrdLogUCount - Company^.UserRef.ucRefCount;
                      Else
                        // Shouldn't ever happen
                        Raise Exception.Create ('RemoveWorkstationUserCount: Unknown RecPFix (' + IntToStr(Ord(Company^.RecPFix))  + '), please contact your technical support');
                      End; // Case UserCountRec.RecPFix

                      // Update the System Setup Record
                      lStatus := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, 0);
                      If (lStatus = 0) Then
                      Begin
                        // Put_Rec will remove the record lock
                        bUnlockSys := False;

                        // Delete the User Count Record
                        lStatus := Delete_Rec (F[CompF], CompF, CompPathK);
                        If (lStatus <> 0) Then
                          // Error Deleting User Count record
                          Result := 600000 + lStatus;
                      End // If (lStatus = 0)
                      Else
                        // Error Updating ExchqSS record
                        Result := 500000 + lStatus;
                    Finally
                      If bUnlockSys Then
                      Begin
                        // Unlock the System Setup record
                        Find_Rec(B_Unlock, F[SysF], SysF, RecPtr[SysF]^, 0, sKey);
                      End; // If bUnlockSys
                    End; // Try..Finally
                  End // If (lStatus = 0)
                  Else
                    // Error Reading/Locking ExchqSS record
                    Result := 300000 + lStatus;
                End; // Else
              Finally
                If (lStatus <> 0) Then
                Begin
                  // Unlock the User Count record
                  Find_Rec(B_Unlock, F[CompF], CompF, RecPtr[CompF]^, CompPathK, sKey);
                End; // If (lStatus <> 0)
              End; // Try..Finally
            End // If (lStatus = 0)
            Else
              // Error Reading/Locking User Count record
              Result := 400000 + lStatus;
          End // If (lStatus = 0)
          Else
            // Error starting DB Transaction
            Result := 200000 + lStatus;

          //------------------------------

          If (lStatus = 0) then
          Begin
            // Updates successful so commit them
            lStatus := Ctrl_BTrans(B_EndTrans);
            If (lStatus <> 0) Then
              // Error Ending DB Transaction
              Result := 700000 + lStatus;
          End // If (lStatus = 0)
          Else
          Begin
            // Something failed along the way so abort the transaction and enter the retry mechanism
            lStatus := Ctrl_BTrans(B_AbortTrans);
            If (lStatus <> 0) Then
              // Error Aborting DB Transaction
              Result := 800000 + lStatus;
          End; // Else

          //------------------------------

          // For the SQL Edition we need to drop the cache as the SQL Emulator doesn't seem to be
          // aware that it has just deleted a record!
          If SQLUtils.UsingSQL Then
          Begin
            DiscardCachedData(MultCompNam);
          End; // If SQLUtils.UsingSQL
        Finally
          Close_File(F[SysF]);
        End; // Try..Finally
      End // If (lStatus = 0)
      Else
        // Error opening company ExchqSS.Dat
        Result := 100000 + lStatus;
    End // If SQLUtils.ValidCompany(Trim(Company^.CompDet.CompPath))
    Else
      Result := 2; // Invalid Company Path
  End // If (lStatus = 0)
  Else
    Result := 1;  // Invalid Company
End; // RemoveWorkstationUserCount

//-------------------------------------------------------------------------

Procedure FindAndResetWorkstationUserCounts (Const UserCountPrefix : Char; Const WorkstationId : ShortString);
Var
  sKey : Str255;
  lStatus : Integer;
Begin // FindAndResetWorkstationUserCounts
  // Run through the User Count records in Company.Dat looking for entries for this workstation,
  // Index 1 includes the Workstation Id
  sKey := UserCountPrefix + WorkstationId;
  lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompPathK, sKey);
  While (lStatus = 0) And (Company^.RecPFix = UserCountPrefix) And (Company^.UserRef.ucWStationId = WorkstationId)  Do
  Begin
    // There should only be a maximum of 1 record per workstation per company per UserCountPrefix
    // so there is no benefit to writing code to group the removals together, as (a) it shouldn't
    // happen and (b) it would make it a lot more complex
    RemoveWorkstationUserCount (Company^);

    lStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompPathK, sKey);
  End; // While (lStatus = 0) And (Company^.RecPFix = UserCountPrefix) And (Company^.UserRef.ucWStationId = WorkstationId)
End; // FindAndResetWorkstationUserCounts

//-------------------------------------------------------------------------

// MH 14/02/2012 v7.0.2 ABSEXCH-13994: Added function to reset user counts for a workstation
Procedure ResetWorkstationUCounts (Const ResetEnter1, ResetToolkit, ResetTrade : Boolean);
Var
  sWorkstation : ShortString;
Begin // ResetWorkstationUCounts
//ShowMessage ('ResetWorkstationUCounts (ResetEnter1=' + IntToStr(Ord(ResetEnter1)) +
//                                    ', ResetToolkit=' + IntToStr(Ord(ResetToolkit)) +
//                                    ', ResetTrade=' + IntToStr(Ord(ResetTrade)) + ')');

  sWorkstation := FullWIDKey(GetWorkstationId);

  If ResetEnter1 Then
    FindAndResetWorkstationUserCounts (cmUserCount, sWorkstation);

  If ResetToolkit Then
  Begin
    // Check Toolkit is licenced
    If (EnterpriseLicence.elModules[modToolDLLR] <> mrNone) Or (EnterpriseLicence.elModules[modToolDLL] <> mrNone) Then
    Begin
      FindAndResetWorkstationUserCounts (cmTKUserCount, sWorkstation);
    End; // If (EnterpriseLicence.elModules[modToolDLLR] <> mrNone) Or (EnterpriseLicence.elModules[modToolDLL] <> mrNone)
  End; // If ResetToolkit

  If ResetTrade Then
  Begin
    // Check Trade Counter is licenced
    If (EnterpriseLicence.elModules[modTrade] <> mrNone) Then
    Begin
      FindAndResetWorkstationUserCounts (cmTradeUserCount, sWorkstation);
    End; // If (EnterpriseLicence.elModules[modTrade] <> mrNone)
  End; // If ResetTrade
End; // ResetWorkstationUCounts

//=========================================================================

end.
