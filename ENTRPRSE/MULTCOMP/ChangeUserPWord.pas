unit ChangeUserPWord;

// Routines for changing a Group Users Password

interface

Uses Classes, Dialogs, Forms, SysUtils;

// Displays the change password dialog to allow the Bureau Administators
// password to be changed
Procedure ChangeBureauAdminPassword (Const ParentForm : TForm);

// Displays the change password dialog to allow the users password
// to be changed
//
//   UserCode             The UserCode of the User who's password
//                        is to be changed
//
//   AskForCurrentPword   True=Ask for current password, False=only
//                        enter new password
//
Procedure ChangeUserPassword (Const ParentForm : TForm; Const UserCode : ShortString; Const AskForCurrentPword : Boolean);

// Controls the process of displaying the dialogs to enter the old and new
// passwords.  The current password is passed into the function in the
// UserPassword field and the changed password is returned in it.  The
// AskForCurrentPword controls whether the user has to enter the current
// password correctly in order to change the password.
Function ProcessUserPasswordEntry (Const ParentForm : TForm; Var UserPassword : ShortString; Const AskForCurrentPword : Boolean) : Boolean;


implementation

Uses GlobVar, VarConst, BtrvU2,
     GroupUsersFile,  // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
     PWordDlg,        // Password Entry dialog
     SavePos,         // Object encapsulating the btrieve saveposition/restoreposition functions
     BTKeys1U, BTSupU1;

//-------------------------------------------------------------------------

// Displays the change password dialog to allow the Bureau Administators
// password to be changed
Procedure ChangeBureauAdminPassword (Const ParentForm : TForm);
Var
  bLocked   : Boolean;
  sKey      : Str255;
  iLockPos  : LongInt;
  iStatus   : SmallInt;
Begin // ChangeBureauAdminPassword
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (CompF, GetPosKey);
      SaveDataBlock (Company, SizeOf(Company^));

      //------------------------------

      // Get and lock the MCM Options record which contains the Bureau Admin PW
      bLocked := False;
      sKey := cmSetup + CmSetupCode;
      If GetMultiRec(B_GetEq, B_MultLock, sKey, CompCodeK, CompF, True, bLocked) And bLocked Then
      Begin
        // Get the record position of the locked record so we can unlock it later if the update isn't done or fails
        GetPos (F[CompF], CompF, iLockPos);
        Try
          // Display the password change wizard
          If ProcessUserPasswordEntry (ParentForm, Company^.CompOpt.OptBureauAdminPWord, True) Then
          Begin
            iStatus := Put_Rec (F[CompF], CompF, RecPtr[CompF]^, CompCodeK);
            If (iStatus = 0) Then
            Begin
              // No need to unlock the record now that the update has been done
              iLockPos := 0;
            End; // If (iStatus = 0)
          End; // If ProcessUserPasswordEntry (...
        Finally
          If (iLockPos <> 0) Then
          Begin
            // Move the record address into the record structure and use the
            // unlock command to free the record lock
            sKey := '';
            Move (iLockPos, Company^, SizeOf(iLockPos));
            iStatus := Find_Rec(B_Unlock, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
            If (iStatus = 0) Then
            Begin
              // Unlocked - reset lock flag
              iLockPos := 0;
            End; // If (iStatus = 0)
          End; // If (iLockPos <> 0)
        End; // Try..Finally
      End // If GetMultiRec(...
      Else
      Begin
        MessageDlg('The Users details could not be loaded', mtError, [mbOK], 0);
      End; // Else

      //------------------------------

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (Company);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // ChangeBureauAdminPassword

//-------------------------------------------------------------------------

// Displays the change password dialog to allow the users password
// to be changed
//
//   UserCode             The UserCode of the User who's password
//                        is to be changed
//
//   AskForCurrentPword   True=Ask for current password, False=only
//                        enter new password
//
Procedure ChangeUserPassword (Const ParentForm : TForm; Const UserCode : ShortString; Const AskForCurrentPword : Boolean);
Var
  bLocked   : Boolean;
  sKey      : Str255;
  iLockPos  : LongInt;
  iStatus   : SmallInt;
Begin // ChangeUserPassword
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (GroupUsersF, GetPosKey);
      SaveDataBlock (GroupUsersFileRec, SizeOf(GroupUsersFileRec^));

      //------------------------------

      // Get and lock the User record
      bLocked := False;
      sKey := FullUserCode (GroupUsersFileRec^.guUserCode);
      If GetMultiRec(B_GetEq, B_SingLock, sKey, GroupUsersCodeK, GroupUsersF, True, bLocked) And bLocked Then
      Begin
        // Get the record position of the locked record so we can unlock it later if the update isn't done or fails
        GetPos (F[GroupUsersF], GroupUsersF, iLockPos);
        Try
          // Display the password change wizard
          If ProcessUserPasswordEntry (ParentForm, GroupUsersFileRec^.guPassword, AskForCurrentPword) Then
          Begin
            iStatus := Put_Rec (F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersGroupCodeK);
            If (iStatus = 0) Then
            Begin
              // No need to unlock the record now that the update has been done
              iLockPos := 0;
            End; // If (iStatus = 0)
          End; // If ProcessUserPasswordEntry (...
        Finally
          If (iLockPos <> 0) Then
          Begin
            // Move the record address into the record structure and use the
            // unlock command to free the record lock
            sKey := '';
            Move (iLockPos, GroupUsersFileRec^, SizeOf(iLockPos));
            iStatus := Find_Rec(B_Unlock, F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersCodeK, sKey);
            If (iStatus = 0) Then
            Begin
              // Unlocked - reset lock flag
              iLockPos := 0;
            End; // If (iStatus = 0)
          End; // If (iLockPos <> 0)
        End; // Try..Finally
      End // If GetMultiRec(...
      Else
      Begin
        MessageDlg('The Users details could not be loaded', mtError, [mbOK], 0);
      End; // Else

      //------------------------------

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (GroupUsersFileRec);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // ChangeUserPassword

//-------------------------------------------------------------------------

// Controls the process of displaying the dialogs to enter the old and new
// passwords.  The current password is passed into the function in the
// UserPassword field and the changed password is returned in it.  The
// AskForCurrentPword controls whether the user has to enter the current
// password correctly in order to change the password.
Function ProcessUserPasswordEntry (Const ParentForm : TForm; Var UserPassword : ShortString; Const AskForCurrentPword : Boolean) : Boolean;
Var
  PasswordDialog     : TPasswordDialog;
  ExistingPW, TmpPwd : ShortString;
  State              : Byte;
  OK                 : Boolean;
Begin // ProcessUserPasswordEntry
  Result := False;

  PasswordDialog := TPasswordDialog.Create(ParentForm);
  Try
    OK := True;
    State := 1;

    UserPassword := UserPassword;

    Repeat
      Case State Of
        // Get Existing Password
        1 : If AskForCurrentPword And (UserPassword <> '') Then
            Begin
              { Get Existing Password - check against ExistingPw }
              PasswordDialog.Title := 'Current Password';
              PasswordDialog.Msg := 'Enter the current password to continue';
              OK := PasswordDialog.Execute;

              If OK Then
              Begin
                // Check got correct password
                If (PasswordDialog.PassWord = UserPassword) Then
                Begin
                  // Correct Password - move to next stage
                  State := 2;
                End // If (PasswordDialog.PassWord = ExistingPw)
                Else
                Begin
                  // invalid password - stay on this stage
                  MessageDlg ('The current password was entered incorrectly', mtWarning, [mbOk], 0)
                End; // Else
              End; // If OK
            End // If AskForCurrentPword And (Trim(UserPassword) <> '')
            Else
              State := 2;

        // Get new password
        2 : Begin
              PasswordDialog.Title := 'Enter New Password';
              PasswordDialog.Msg := 'Enter the new password';
              Ok := PasswordDialog.Execute;

              If Ok Then
              Begin
                { Got a new password }
                TmpPwd := PasswordDialog.PassWord;
                State := 3;
              End // If Ok
              Else
              Begin
                { Dialog Cancelled }
                MessageDlg ('Password not changed', mtInformation, [mbOk], 0);
              End; // Else
            End;

        // get new password again
        3 : Begin
              PasswordDialog.Title := 'Confirm Password';
              PasswordDialog.Msg := 'Re-enter the new password';
              Ok := PasswordDialog.Execute;

              If OK Then
              Begin
                 If (PasswordDialog.PassWord = TmpPwd) Then
                 Begin
                   // Password was retyped correctly
                   UserPassword := TmpPwd;
                   Result := True;
                   State := 4;
                 End // If (PasswordDialog.PassWord = TmpPwd)
                 Else
                 Begin
                   { Password was NOT retyped correctly }
                   State := 2;
                   MessageDlg ('The new password was not re-entered correctly', mtWarning, [mbOk], 0);
                 End; // Else
              End; // If OK
            End;
      End; { Case }
    Until (Not OK) Or (State = 4);
  Finally
    FreeAndNIL(PasswordDialog);
  End; { Try }
End; // ProcessUserPasswordEntry

//-------------------------------------------------------------------------

end.
