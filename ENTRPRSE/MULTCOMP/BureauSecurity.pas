unit BureauSecurity;

interface

Uses Classes, Controls, Forms, SysUtils, Windows,
     GroupsFile,      // Definition of Groups.Dat (GroupF) and utility functions
     GroupUsersFile;  // Definition of GroupUsr.Dat (GroupUsersF) and utility functions

Type
  // Enumeration used to identify the type of user logged into the Bureau Module
  TLoggedInUserType = (utNotLoggedIn, utSystem, utAdmin, utNormal);

  //------------------------------

  TBureauSecurityManager = Class(TObject)
  Private
    // The Group Details for the Logged In User
    FGroupDetails : GroupFileRecType;
    // The User Details for the Logged In User
    FUserDetails : GroupUsersFileRecType;
    // The type of user logged in
    FUserType : TLoggedInUserType;

    Function GetGroupCode : ShortString;
    Function GetUserCode : ShortString;
    Function GetUserPermissions (Index : TUserPermissions) : Boolean;

    // Configures the internal User record for the SYSTEM login
    Procedure InitSystemUser;
    // Configures the internal User record for the ADMIN login
    Procedure InitAdminUser;
  Public
    // Displays the Bureau Login dialog

    // The Group Code for the logged in user
    Property smGroupCode : ShortString Read GetGroupCode;

    // The UserCode of the logged in user
    Property smUserCode : ShortString Read GetUserCode;

    Property smUserPermissions [Index : TUserPermissions] : Boolean Read GetUserPermissions;

    // The type of user logged into the Bureau Module
    Property smUserType : TLoggedInUserType Read FUserType;


    Constructor Create;


    // Re-initialises everything ready for a login attempt
    Procedure InitLoginDetails;

    // Displays the Bureau Login dialog
    Function Login (Const SplashHandle : hWnd) : Boolean;

    // Validates a User Id for the Login dialog.  If valid it returns
    // True and loads the User and Users Group details
    Function ValidLoginId (UserCode : ShortString) : Boolean;

    // Validates the Password for the loaded User
    Function ValidPassword (UserPword : ShortString) : Boolean;
  End; // TBureauSecurityManager


// Access function for a global SecurityManager object which is
// automatically created by the routine the first time it is called.
Function SecurityManager : TBureauSecurityManager;

implementation

Uses GlobVar, VarConst, BtrvU2,
     {$IFNDEF BUREAUDLL}
     BureauLoginF,   // MCM Login dialog for Bureau Module
     SecSup2U,       // Enterprise Security routines
     {$ENDIF} // BUREAUDLL
     VAOUtil,
     Crypto;         // Encryption functions
     //BTKeys1U;

Var
  oSecurityManager : TBureauSecurityManager;

//=========================================================================

// Access function for a global BureauSecurity object which is
// automatically created by the routine the first time it is called.
Function SecurityManager : TBureauSecurityManager;
Begin { SecurityManager }
  If (Not Assigned(oSecurityManager)) Then
  Begin
    oSecurityManager := TBureauSecurityManager.Create;
  End; // If (Not Assigned(oSecurityManager))

  Result := oSecurityManager;
End; { SecurityManager }

//=========================================================================

Constructor TBureauSecurityManager.Create;
Begin // Create
  Inherited Create;

  FUserType := utNotLoggedIn;
End; // Create

//-------------------------------------------------------------------------

Function TBureauSecurityManager.GetGroupCode : ShortString;
Begin // GetGroupCode
  Result := FGroupDetails.grGroupCode;
End; // GetGroupCode

//------------------------------

Function TBureauSecurityManager.GetUserCode : ShortString;
Begin // GetUserCode
  Result := FUserDetails.guUserCode;
End; // GetUserCode

//------------------------------

Function TBureauSecurityManager.GetUserPermissions (Index : TUserPermissions) : Boolean;
Begin // GetUserCode
  If (Ord(Index) >= Low(FUserDetails.guPermissions)) And (Ord(Index) <= High(FUserDetails.guPermissions)) Then
  Begin
    Result := FUserDetails.guPermissions[Ord(Index)];
  End //
  Else
  Begin
    Raise Exception.Create ('TBureauSecurityManager.GetUserPermissions: Invalid Array Index (' + IntToStr(Ord(Index)) + ')');
  End; // Else
End; // GetUserCode

//-------------------------------------------------------------------------

Function TBureauSecurityManager.Login (Const SplashHandle : hWnd) : Boolean;
{$IFNDEF BUREAUDLL}
Var
  frmBureauLogin : TfrmBureauLogin;
{$ENDIF} // BUREAUDLL
Begin // Login
{$IFNDEF BUREAUDLL}
  InitLoginDetails;

  frmBureauLogin := TfrmBureauLogin.Create(Application);
  Try
    frmBureauLogin.SplashHandle := splashHandle;

    Result := (frmBureauLogin.ShowModal = mrOK);
  Finally
    FreeAndNIL(frmBureauLogin);
  End; // Try..Finally
{$ELSE}
  Result := False;
{$ENDIF} // BUREAUDLL
End; // Login

//-------------------------------------------------------------------------

// Re-initialises everything ready for a login attempt
Procedure TBureauSecurityManager.InitLoginDetails;
Begin // InitLoginDetails
  // Reset the previous login details
  FUserType := utNotLoggedIn;
  FillChar (FGroupDetails, SizeOf(FGroupDetails), #0);
  FillChar (FUserDetails, SizeOf(FUserDetails), #0);
End; // InitLoginDetails

//------------------------------

// Configures the internal User record for the SYSTEM login
Procedure TBureauSecurityManager.InitSystemUser;
Begin // InitSystemUser
  FUserDetails.guUserCode := 'SYSTEM';
  FUserDetails.guUserName := 'System User';
{$IFNDEF BUREAUDLL}
  // Password not checked in Bureau DLL
  FUserDetails.guPassword := EncodeKey (23130, Generate_ESN_BaseSecurity(SyssCompany^.CompOpt.optSystemESN, 245, 0, 0));
{$ENDIF} // BUREAUDLL

  // Allow System user to do anything
  FillChar(FUserDetails.guPermissions, SizeOf(FUserDetails.guPermissions), Ord(True));
End; // InitSystemUser

//------------------------------

// Configures the internal User record for the ADMIN login
Procedure TBureauSecurityManager.InitAdminUser;
Begin // InitAdminUser
  FUserDetails.guUserCode := 'ADMIN';
  FUserDetails.guUserName := 'Bureau Administrator';
  FUserDetails.guPassword := SyssCompany^.CompOpt.OptBureauAdminPWord;

  // Allow Admin user to do most things, except some of the security routines which are
  // limited to System user each
  FillChar(FUserDetails.guPermissions, SizeOf(FUserDetails.guPermissions), Ord(True));

  // HM 07/12/04: Limit Bureau Administrators options under VAO
  If (VAOInfo.vaoMode = smVAO) Then
  Begin
    FUserDetails.guPermissions[Ord(upEditMCMOptions)] := False;

    FUserDetails.guPermissions[Ord(upAddCompany)] := False;
    FUserDetails.guPermissions[Ord(upEditCompany)] := False;
    FUserDetails.guPermissions[Ord(upDeleteCompany)] := False;
    FUserDetails.guPermissions[Ord(upBackupCompany)] := False;
    FUserDetails.guPermissions[Ord(upRestoreCompany)] := False;
  End; // If (VAOInfo.vaoMode = smVAO)
End; // InitAdminUser

//-------------------------------------------------------------------------

// Validates a User Id for the Login dialog.  If valid it returns
// True and loads the User and Users Group details
Function TBureauSecurityManager.ValidLoginId (UserCode : ShortString) : Boolean;
Var
  iStatus : SmallInt;
  sKey    : Str255;
Begin // ValidLoginId
  InitLoginDetails;

  // Check for the Enterprise Backdoor
  If (Trim(UserCode) = 'SYSTEM') Then
  Begin
    // Enterprise Backdoor user
    FUserType := utSystem;
    InitSystemUser;
    Result := True;
  End // If (Trim(UserCode) = 'SYSTEM')
  Else
  Begin
    // Check for the Bureau Mode Administrator
    If (Trim(UserCode) = 'ADMIN') Then
    Begin
      // Bureau Mode Administrator
      FUserType := utAdmin;
      InitAdminUser;
      Result := True;
    End // If (Trim(UserCode) = 'SYSTEM')
    Else
    Begin
      // Check for a valid Group-User User Id
      sKey := FullUserCode(UserCode);
      iStatus := Find_Rec(B_GetEq, F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersCodeK, sKey);
      If (iStatus = 0) Then
      Begin
        // Eureka! Valid Group User - store details internally and load the group details
        FUserType := utNormal;
        FUserDetails := GroupUsersFileRec^;

        // HM 07/12/04: Limit Bureau Administrators options under VAO
        If (VAOInfo.vaoMode = smVAO) Then
        Begin
          FUserDetails.guPermissions[Ord(upEditMCMOptions)] := False;

          FUserDetails.guPermissions[Ord(upAddCompany)] := False;
          FUserDetails.guPermissions[Ord(upEditCompany)] := False;
          FUserDetails.guPermissions[Ord(upDeleteCompany)] := False;
          FUserDetails.guPermissions[Ord(upBackupCompany)] := False;
          FUserDetails.guPermissions[Ord(upRestoreCompany)] := False;
        End; // If (VAOInfo.vaoMode = smVAO)

        sKey := FullGroupCodeKey(FUserDetails.guGroupCode);
        iStatus := Find_Rec(B_GetEq, F[GroupF], GroupF, RecPtr[GroupF]^, GroupCodeK, sKey);
        If (iStatus = 0) Then
        Begin
          FGroupDetails := GroupFileRec;
        End; // If (iStatus = 0)
      End; // If (iStatus = 0)

      Result := (iStatus = 0);
    End; // Else
  End; // Else
End; // ValidLoginId

//-------------------------------------------------------------------------

// Validates the Password for the loaded User
Function TBureauSecurityManager.ValidPassword (UserPword : ShortString) : Boolean;
Begin // ValidPassword
  Result := (EncodeKey (23130, Trim(UserPWord)) = FUserDetails.guPassword);
End; // ValidPassword

//-------------------------------------------------------------------------

Initialization
  oSecurityManager := NIL;
Finalization
  FreeAndNIL(oSecurityManager);
end.
