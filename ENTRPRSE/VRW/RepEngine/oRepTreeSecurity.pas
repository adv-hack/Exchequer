unit oRepTreeSecurity;

interface

uses Classes, Dialogs, SysUtils, RepTreeIF, VRWReportDataIF;

// Returns an IUserReportSecurity object for the specified report
// allowing the per user security to be read and changed
Function GetReportSecurity (Const RepCode : ShortString) : IReportSecurity;

// Returns TRUE if a specific User Security record exists for the specified
// Group/Report and User, the permission is returned in RepPermissions.
Function GetUserPermissions(Const RepCode, UserCode : ShortString; Var RepPermissions : TReportPermissionType) : Boolean;

implementation

Uses GlobVar, VarConst, VarRec2U, BtrvU2, ETStrU, SavePos, StrUtil;

Type
  // Generic interface for objects which implement a specific import type
  IUserReportSecurityFunctions = Interface(IUserReportSecurity)
    ['{BA3F5153-C7FC-4C8C-9D29-52FC81D83D7F}']
    // --- Internal Methods to implement Public Properties ---
    Function GetOrigPermission : TReportPermissionType;

    // ------------------ Public Properties ------------------
    Property ursOrigPermission : TReportPermissionType Read GetOrigPermission;

    // ------------------- Public Methods --------------------
    Procedure StoreOrigPermission;
  End; // IUserReportSecurityFunctions

  //------------------------------

  TUserReportSecurity = Class(TInterfacedObject, IUserReportSecurity, IUserReportSecurityFunctions)
  Private
    FUserRec : PassEntryType;
    FOrigPermission : TReportPermissionType;
    FPermission : TReportPermissionType;
  Protected
    Constructor Create (Const UserRec : PassEntryType);
    Destructor Destroy; Override;

    // IUserReportSecurity
    Function GetName : ShortString;
    Function GetPermission : TReportPermissionType;
    Procedure SetPermission (Value : TReportPermissionType);

    // IUserReportSecurityFunctions
    Function GetOrigPermission : TReportPermissionType;
    Procedure StoreOrigPermission;
  End; // TUserReportSecurity

  //------------------------------

  TReportSecurity = Class(TInterfacedObject, IReportSecurity)
  Private
    FReportDets : TVRWReportDataRec;
    FUserList : TInterfaceList;
  Protected
    Constructor Create (Const RepCode : ShortString);
    Destructor Destroy; Override;

    // Search for specific records for the report item for the individual users
    Procedure CheckReportSecurity;

    // Recursively process the Report Tree upwards from the specified report
    // to check the security for each user at each level, remove users from
    // the list that don't have permissions to see the group
    Procedure CheckTreePermissions (Const CheckGroup : ShortString);

    // Deletes any User Security for the specified Report/User
    Procedure DeleteTreeSecurity (Const RepCode, UserCode : ShortString);

    // Removes any User Security records for items off the specified group
    Procedure RemoveSubItemSecurity (GroupCode, UserCode : ShortString);

    // Adds a User Security Record for the specified Report/User
    Procedure SetTreeSecurity (Const RepCode, UserCode : ShortString; Const RepPermissions : TReportPermissionType);

    // IReportSecurity
    Function GetReportCode : ShortString;
    Function GetReportDesc : ShortString;
    Function GetReportFile : ShortString;
    Function GetType : TReportType;
    Function GetPermittedUserCount : SmallInt;
    Function GetPermittedUsers (Index: SmallInt) : IUserReportSecurity;
    Function GetPermittedUsersByName (Name: ShortString) : IUserReportSecurity;

    Function IndexOf (Const Name: ShortString) : LongInt;
    Procedure Save;
  Public
  End; // IReportSecurity

//=========================================================================

Function GetReportSecurity (Const RepCode : ShortString) : IReportSecurity;
Begin // GetReportSecurity
  Result := TReportSecurity.Create(RepCode);
End; // GetReportSecurity

//=========================================================================

// Returns TRUE if a specific User Security record exists for the specified
// Group/Report and User, the permission is returned in RepPermissions.
Function GetUserPermissions(Const RepCode, UserCode : ShortString; Var RepPermissions : TReportPermissionType) : Boolean;
Var
  sKey    : ShortString;
  iStatus : SmallInt;
Begin // GetUserPermissions
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveDataBlock (@RTSecurity, SizeOf(RTSecurity));
      SaveFilePosition (RTSecurityF, GetPosKey);

      sKey := BuildUserRepKey (RepCode, UserCode);
      iStatus := Find_Rec(B_GetEq, F[RTSecurityF], RTSecurityF, RecPtr[RTSecurityF]^, RTSecUserIdx, sKey);
      If (iStatus = 0) Then
      Begin
        Result := True;
        RepPermissions := RTSecurity.rtsSecurity;
      End // If (iStatus = 0)
      Else
      Begin
        Result := False;
        RepPermissions := rptShowEdit;
      End; // Else

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (@RTSecurity);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // GetUserPermissions

//=========================================================================

Constructor TUserReportSecurity.Create (Const UserRec : PassEntryType);
Begin // Create
  Inherited Create;

  FUserRec := UserRec;
  FPermission := rptShowEdit;
End; // Create

//------------------------------

Destructor TUserReportSecurity.Destroy;
Begin // Destroy

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TUserReportSecurity.GetName : ShortString;
Begin // GetName
  Result := Trim(FUserRec.Login);
End; // GetName

//------------------------------

Function TUserReportSecurity.GetPermission : TReportPermissionType;
Begin // GetPermission
  Result := FPermission;
End; // GetPermission
Procedure TUserReportSecurity.SetPermission (Value : TReportPermissionType);
Begin // SetPermission
  FPermission := Value;
End; // SetPermission

//------------------------------

Function TUserReportSecurity.GetOrigPermission : TReportPermissionType;
Begin // GetOrigPermission
  Result := FOrigPermission;
End; // GetOrigPermission

Procedure TUserReportSecurity.StoreOrigPermission;
Begin // StoreOrigPermission
  FOrigPermission := FPermission;
End; // StoreOrigPermission

//=========================================================================

Constructor TReportSecurity.Create (Const RepCode : ShortString);
Var
  sKey, sWantCode   : ShortString;
  iStatus, iUserIdx : SmallInt;
  FSpec   : FileSpec;
Begin // Create
  Inherited Create;

  FUserList := TInterfaceList.Create;

  // Find the Report Details
  sKey := '';
  sWantCode := PadString(psRight, RepCode, ' ', 50);
  iStatus := Find_Rec(B_GetEq, F[VRWReportDataF], VRWReportDataF, RecPtr[VRWReportDataF]^, rtIdxRepName, sWantCode);
  if (iStatus = 0) then
  begin
    // Found Group/Report
    FReportDets := VRWReportDataRec;

    // Load the User Records and build up a list of users allowed to run the VRW
    sKey := PassUCode + #0 + #0;
    iStatus := Find_Rec(B_GetGEq, F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK, sKey);
//ShowMessage ('User: ' + IntToStr(iStatus) + ' - ' + PassWord.PassEntryRec.Login + ' (' + IntToStr(FileRecLen[PwrdF]) + ')');
    While (iStatus = 0) And (PassWord.RecPfix = PassUCode) and (PassWord.SubType = #0) Do
    Begin
      If (PassWord.PassEntryRec.Access[193] = 1) Then
      Begin
        FUserList.Add (TUserReportSecurity.Create(PassWord.PassEntryRec));
      End; // If (PassWord.PassEntryRec.Access[193] = 1)

      iStatus := Find_Rec(B_GetNext, F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK, sKey);
    End; // While (iStatus = 0) And (LPassWord.RecPfix = PassUCode) and (LPassWord.SubType = #0)

    if (Trim(FReportDets.rtParentName) <> '') then
    begin
      // Recursively process the Report Tree upwards from the specified report
      // to check the security for each user at each level, remove users from
      // the list that don't have permissions to see the group
      CheckTreePermissions (FReportDets.rtParentName);
    End;

    // Search for specific records for the report item for the individual users
    CheckReportSecurity;

    // Run through the remaining users recording their status so changes can be tracked
    If (FUserList.Count > 0) Then
    Begin
      For iUserIdx := 0 To (FUserList.Count - 1) Do
      Begin
        (FUserList.Items[iUserIdx] As IUserReportSecurityFunctions).StoreOrigPermission;
      End; // For iUserIdx
    End; // If (FUserList.Count > 0)
  End // If (iStatus = 0) And (UpperCase(Trim(ReportTreeRec.ReportName)) = sWantCode)
  Else
    // This should never happen
    Raise Exception.Create ('TReportSecurity.Create: Invalid Report Code (' + RepCode + ')');
End; // Create

//------------------------------

Destructor TReportSecurity.Destroy;
Begin // Destroy
  FreeAndNIL(FUserList);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Search for specific records for the report item for the individual users
Procedure TReportSecurity.CheckReportSecurity;
Var
  oUserSecurity : IUserReportSecurity;
  Permissions   : TReportPermissionType;
  iUserIdx      : SmallInt;
Begin // CheckReportSecurity
  // Run through the list of users checking for a specific security record
  If (FUserList.Count > 0) Then
  Begin
    For iUserIdx := 0 To (FUserList.Count - 1) Do
    Begin
      oUserSecurity := FUserList.Items[iUserIdx] As IUserReportSecurity;
      Try
        If GetUserPermissions(FReportDets.rtRepName, oUserSecurity.ursName, Permissions) Then
        Begin
          oUserSecurity.ursPermission := Permissions;
        End; // If GetUserPermissions(FReportDets.ReportName, oUserSecurity.ursName, Permissions)
      Finally
        oUserSecurity := NIL;
      End; // Try..Finally
    End; // For iUserIdx
  End; // If (FUserList.Count > 0)
End; // CheckReportSecurity

//-------------------------------------------------------------------------

// Recursively process the Report Tree upwards from the specified report
// to check the security for each user at each level, remove users from
// the list that don't have permissions to see the group
Procedure TReportSecurity.CheckTreePermissions (Const CheckGroup : ShortString);
Var
  oUserSecurity     : IUserReportSecurity;
  Permissions       : TReportPermissionType;
  sKey              : ShortString;
  iStatus, iUserIdx : SmallInt;
Begin // CheckTreePermissions
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveDataBlock (@ReportTreeRec, SizeOf(ReportTreeRec));
      SaveFilePosition (ReportTreeF, GetPosKey);

      // Load the specified parent group if it exists
      sKey := FullNodeIDKey(CheckGroup);
      iStatus := Find_Rec(B_GetEq, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeChildIDK, sKey);
      If (iStatus = 0) Then
      Begin
        // If the group has a parent then process that first - the security checking must start
        // at the root of the tree
        If (Trim(ReportTreeRec.ParentID) <> '') And (Trim(ReportTreeRec.ParentID) <> '0') Then
        Begin
          // Recursively process the Report Tree upwards from the specified report
          // to check the security for each user at each level, remove users from
          // the list that don't have permissions to see the group
          CheckTreePermissions (ReportTreeRec.ParentId);
        End; // If (Trim(ReportTreeRec.ParentID) <> '') And (Trim(ReportTreeRec.ParentID) <> '0')

        // For each remaining user in the list check their permissions to this group
        iUserIdx := 0;
        While (FUserList.Count > 0) And (iUserIdx < FUserList.Count) Do
        Begin
          oUserSecurity := FUserList.Items[iUserIdx] As IUserReportSecurity;
          Try
            If GetUserPermissions(ReportTreeRec.ReportName, oUserSecurity.ursName, Permissions) Then
            Begin
              If (Permissions = rptHidden) Then
              Begin
                // User cannot see this group - remove the from the list
                oUserSecurity := NIL;
                FUserList.Delete(iUserIdx);
              End // If (Permissions = rptHidden)
              Else
                // OK - move to next user
                Inc(iUserIdx);
            End // If GetUserPermissions(FReportDets.ReportName, oUserSecurity.ursName, Permissions)
            Else
              // No permissions defined so assume Show and move to next user
              Inc(iUserIdx);
          Finally
            oUserSecurity := NIL;
          End; // Try..Finally
        End; // If (FUserList.Count > 0)
      End; // If (iStatus = 0)

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (@ReportTreeRec);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // CheckTreePermissions

//-------------------------------------------------------------------------

// Deletes any User Security for the specified Report/User
Procedure TReportSecurity.DeleteTreeSecurity (Const RepCode, UserCode : ShortString);
Var
  sKey    : ShortString;
  iStatus : SmallInt;
Begin // DeleteTreeSecurity
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveDataBlock (@RTSecurity, SizeOf(RTSecurity));
      SaveFilePosition (RTSecurityF, GetPosKey);

      // Find and delete the record
      sKey := BuildUserRepKey (RepCode, UserCode);
      iStatus := Find_Rec(B_GetEq + B_SingLock, F[RTSecurityF], RTSecurityF, RecPtr[RTSecurityF]^, RTSecUserIdx, sKey);
      If (iStatus = 0) Then
      Begin
        iStatus := Delete_Rec(F[RTSecurityF], RTSecurityF, RTSecUserIdx);
        If (iStatus <> 0) Then
        Begin
          MessageDlg ('Error ' + IntToStr(iStatus) + ' occurred deleting the security for ' + Trim(UserCode) +
                      ', please notify your Technical Support', mtError, [mbOK], 0);
        End; // If (iStatus <> 0)
      End; // If (iStatus = 0)

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (@RTSecurity);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // DeleteTreeSecurity

//-------------------------------------------------------------------------

// Removes any User Security records for items off the specified group
Procedure TReportSecurity.RemoveSubItemSecurity (GroupCode, UserCode : ShortString);
Var
  sKey    : ShortString;
  iStatus : SmallInt;
Begin // RemoveSubItemSecurity
  GroupCode := Trim(GroupCode);

  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveDataBlock (@ReportTreeRec, SizeOf(ReportTreeRec));
      SaveFilePosition (ReportTreeF, GetPosKey);

      // Run through all the sub-items for the specified group
      sKey := FullNodeIDKey(GroupCode);
      iStatus := Find_Rec(B_GetGEq, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, sKey);
      While (iStatus = 0) And (Trim(ReportTreeRec.ParentID) = GroupCode) Do
      Begin
        // Delete any specific user security for the report/group
        DeleteTreeSecurity (ReportTreeRec.ReportName, UserCode);

        // For groups process sub-items recursively
        If (ReportTreeRec.BranchType = 'H') Then
        Begin
          RemoveSubItemSecurity (ReportTreeRec.ChildID, UserCode);
        End; // If (ReportTreeRec.BranchType = 'H')

        iStatus := Find_Rec(B_GetNext, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, sKey);
      End; // While (iStatus = 0) And (Trim(ReportTreeRec.ParentID) = Trim(GroupCode))

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (@ReportTreeRec);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // RemoveSubItemSecurity

//-------------------------------------------------------------------------

// Adds a User Security Record for the specified Report/User
Procedure TReportSecurity.SetTreeSecurity (Const RepCode, UserCode : ShortString; Const RepPermissions : TReportPermissionType);
Var
  iStatus : SmallInt;
Begin // SetTreeSecurity
  // Delete any existing security records
  DeleteTreeSecurity (RepCode, UserCode);

  // Add the new record in
  FillChar (RTSecurity, SizeOf (RTSecurity), #0);
  With RTSecurity Do
  Begin
    rtsTreeCode := LJVar(Trim(RepCode), SizeOf(rtsTreeCode) - 1);
    rtsUserCode := LJVar(Trim(UserCode), SizeOf(rtsUserCode) - 1);
    rtsSecurity := RepPermissions;
  End; // With RTSecurity
  iStatus := Add_Rec(F[RTSecurityF], RTSecurityF, RecPtr[RTSecurityF]^, 0);
  If (iStatus <> 0) Then
  Begin
    MessageDlg ('Error ' + IntToStr(iStatus) + ' occurred adding the security for ' + Trim(UserCode) +
                ', please notify your Technical Support', mtError, [mbOK], 0);
  End; // If (iStatus <> 0)
End; // SetTreeSecurity

//-------------------------------------------------------------------------

Procedure TReportSecurity.Save;
Var
  oUserSecurity : IUserReportSecurityFunctions;
  iUserIdx      : SmallInt;
Begin // Save
  If (FUserList.Count > 0) Then
  Begin
    For iUserIdx := 0 To (FUserList.Count - 1) Do
    Begin
      oUserSecurity := FUserList.Items[iUserIdx] As IUserReportSecurityFunctions;
      Try
        // Check for changes to minimise the update
        If (oUserSecurity.ursPermission <> oUserSecurity.ursOrigPermission) Then
        Begin
          If (oUserSecurity.ursPermission = rptHidden) Then
          Begin
            // Add a User Security record for the Group/Report to hide it
            SetTreeSecurity (FReportDets.rtRepName, oUserSecurity.ursName, rptHidden);

            If (FReportDets.rtNodeType = 'H') Then
            Begin
              // Remove any User Security records for sub-items
              RemoveSubItemSecurity (FReportDets.rtRepName, oUserSecurity.ursName);
            End; // If (FReportDets.BranchType = 'H')
          End // If (oUserSecurity.ursPermission = rptHidden)
          Else If (oUserSecurity.ursPermission = rptShowEdit) Then
          Begin
            // Default Value - Remove any security records for this item to minimise the DB
            DeleteTreeSecurity (FReportDets.rtRepName, oUserSecurity.ursName);
          End // If (oUserSecurity.ursPermission = rptShowEdit)
          Else If (oUserSecurity.ursPermission = rptPrintOnly) Then
          Begin
            // Add a User Security record for the Report
            SetTreeSecurity (FReportDets.rtRepName, oUserSecurity.ursName, rptPrintOnly);
          End // If (oUserSecurity.ursPermission = rptPrintOnly)
          Else
            Raise Exception.Create ('TReportSecurity.Save: Unknown Permission Setting (' + IntToStr(Ord(oUserSecurity.ursPermission)) + ')');
        End; // If (oUserSecurity.ursPermission <> oUserSecurity.ursOrigPermission)
      Finally
        oUserSecurity := NIL;
      End; // Try..Finally
    End; // For iUserIdx
  End; // If (FUserList.Count > 0)
End; // Save

//-------------------------------------------------------------------------

Function TReportSecurity.GetReportCode : ShortString;
Begin // GetReportCode
  Result := FReportDets.rtRepName;
End; // GetReportCode

//------------------------------

Function TReportSecurity.GetReportDesc : ShortString;
Begin // GetReportDesc
  Result := Trim(FReportDets.rtRepDesc);
End; // GetReportDesc

//------------------------------

Function TReportSecurity.GetReportFile : ShortString;
Begin // GetReportDesc
  Result := Trim(FReportDets.rtFileName);
End; // GetReportDesc

//------------------------------

Function TReportSecurity.GetType : TReportType;
Begin // GetType
  If (FReportDets.rtNodeType = 'H') Then
    Result := rtGroup
  Else
    Result := rtReport;
End; // GetType

//------------------------------

Function TReportSecurity.GetPermittedUserCount : SmallInt;
Begin // GetPermittedUserCount
  Result := FUserList.Count;
End; // GetPermittedUserCount

//------------------------------

Function TReportSecurity.GetPermittedUsers (Index: SmallInt) : IUserReportSecurity;
Var
  oUser : TUserReportSecurity;
Begin // GetPermittedUsers
  If (Index >= 0) And (Index < FUserList.Count) Then
  Begin
    Result := FUserList.Items[Index] As IUserReportSecurity;
  End // If (Index >= 0) And (Index < FUserList.Count)
  Else
    Raise Exception.Create ('TReportSecurity.GetPermittedUsers: Invalid User Index (' + IntToStr(Index) + ')');
End; // GetPermittedUsers

//------------------------------

Function TReportSecurity.GetPermittedUsersByName (Name: ShortString) : IUserReportSecurity;
Var
  iUserIdx : SmallInt;
Begin // GetPermittedUsersByName
  iUserIdx := IndexOf (Name);
  If (iUserIdx >= 0) Then
  Begin
    Result := FUserList.Items[iUserIdx] As IUserReportSecurity;
  End // If (iUserIdx >= 0)
  Else
  Begin
    Raise Exception.Create ('TReportSecurity.GetPermittedUsersByName: Invalid User Name (' + Name + ')');
  End; // If (Not Assigned(Result))
End; // GetPermittedUsersByName

//------------------------------

Function TReportSecurity.IndexOf (Const Name: ShortString) : LongInt;
Var
  iUserIdx : SmallInt;
Begin // IndexOf
  Result := -1;

  If (FUserList.Count > 0) Then
  Begin
    For iUserIdx := 0 To (FUserList.Count - 1) Do
    Begin
      If (UpperCase(Trim((FUserList.Items[iUserIdx] As IUserReportSecurity).ursName)) = UpperCase(Trim(Name))) Then
      Begin
        Result := iUserIdx;
        Break;
      End; // If (UpperCase(Trim((FUserList.Items[iUserIdx] As IUserReportSecurity).ursName) = UpperCase(Trim(Name)))
    End; // For iUserIdx
  End; // If (FUserList.Count > 0)
End; // IndexOf

//-------------------------------------------------------------------------

end.
