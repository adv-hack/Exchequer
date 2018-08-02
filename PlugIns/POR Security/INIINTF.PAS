unit IniIntf;

interface

Uses Classes, ComCtrls, Dialogs, FileCtrl, Messages, StdCtrls, SysUtils,
     Windows, IniFiles;

const
  {$IFDEF EX600}
    sVersionNo = '107';
  {$ELSE}
    sVersionNo = 'v5.70.106';
  {$ENDIF}
  PlugInName = 'Exchequer POR Daybook Security Plug-In';


Const
  DeptSection = 'Departments';
  UserSection = 'Users';

  UserTypes   : Array [0..2] Of String = ('Global', 'Manager', 'User');

Type
  TUserData = Class(TObject)
  Public
    UserCode  : String[12];
    UserType  : Byte;       // 0=Global, 1=Departmental Manager, 2=Departmental User
    DeptCode  : String[20];
  End; { TUserData }

  TPORSecuritySettings = Class(TObject)
  Private
    FCompanyPath : String;

    FDeptList    : TStringList;
    FUserList    : TStringList;

    FIniFile     : TIniFile;
  Protected
    Procedure SetCompanyPath(Value : String);
  Public
    Constructor Create; Virtual;
    Destructor Destroy; Override;

    // Misc methods
    Function  CheckForString (TheList : TStrings; TheStr : String) : SmallInt;

    // Department methods
    Function  AddDept(DeptList : TListView; NewDept : String) : SmallInt;
    Function  CanDeleteDept(DelDept : String) : Boolean;
    Procedure DeleteDepartment (DeptList : TListView; DeptCode : String);
    Procedure ReadDeptsIntoList (DeptList : TStrings);
    Procedure ReadDeptsIntoListView (DeptList : TListView);
    Procedure WriteDeptsToIni;

    // User methods
    Procedure AddNewUser (UserList : TListView; UserDets : TUserData);
    Procedure ClearUserList;
    Procedure DeleteUser (UserList : TListView; Const UserCode : String);
    Function  GetUserDets (Const UserCode : String) : TUserData;
    Procedure ReadUsersIntoListView (UserList : TListView);
    Procedure UpdateForEdit (UserList : TListView);
    Function  ValidUserCode (Const NewUser : String) : Boolean;
    Procedure WriteUsersToIni;

    // Properties
    Property CompanyPath : String Read FCompanyPath Write SetCompanyPath;
  End; { TPORSecuritySettings }
  
Var
  Settings : TPORSecuritySettings;

implementation

{-------------------------------------------}

// Create object, initialise local variables, etc...
Constructor TPORSecuritySettings.Create;
Begin { Create }
  Inherited Create;

  FCompanyPath := '';

  FDeptList := TStringList.Create;
  FDeptList.Duplicates := dupIgnore;
  FDeptList.Sorted := True;

  FUserList := TStringList.Create;
  FUserList.Sorted := True;
End; { Create }

{-------------------------------------------}

// Destroy object, destroy/reset local variables
Destructor TPORSecuritySettings.Destroy;
Begin { Destroy }
  // Destroy any pre-existing INI File object
  If Assigned(FIniFile) Then Begin
    FIniFile.UpdateFile;
    FIniFile.Destroy;
    FIniFile := NIL;
  End; { If Assigned(FIniFile) }

  // Destroy Departments list
  FDeptList.Destroy;

  // Destroy Users list }
  ClearUserList;
  FUserList.Destroy;

  Inherited Destroy;
End; { Destroy }

{-------------------------------------------}

// Empties the internal User List
Procedure TPORSecuritySettings.ClearUserList;
Var
  UserData  : TUserData;
  I         : SmallInt;
Begin { ClearUserList }
  If Assigned(FUserList) And (FUserList.Count > 0) Then
    For I := 0 To Pred(FUserList.Count) Do
      TUserData(FUserList.Objects[I]).Free;

  FUserList.Clear;
End; { ClearUserList }

{-------------------------------------------}

// Write method for CompanyPath property - open PORDEPT.DAT ini file in specified directory
Procedure TPORSecuritySettings.SetCompanyPath(Value : String);
Var
  FTempList : TStrings;
  UserData  : TUserData;
  I         : SmallInt;
Begin { SetCompanyPath }
  // Remove any padding from path
  Value := UpperCase(Trim(Value));

  If (Value <> FCompanyPath) Then Begin
    // Keep compy of path to determine changes
    FCompanyPath := Value;

    // changing companies - clear out any pre-existing data from previous company
    FDeptList.Clear;
    ClearUserList;

    // Destroy any pre-existing INI File object
    If Assigned(FIniFile) Then Begin
      FIniFile.UpdateFile;
      FIniFile.Destroy;
      FIniFile := NIL;
    End; { If Assigned(FIniFile) }

    // Check validity if path
    If DirectoryExists(Value) Then Begin
      // Create new INI File object for correct directory
      FIniFile := TIniFile.Create(IncludeTrailingBackslash(Value) + 'ENPORSEC.DAT');

      // Load Department List from .INI
      FTempList := TStringList.Create;
      Try
        // Load Department details from .INI file
        FIniFile.ReadSectionValues(DeptSection, FTempList);

        If (FTempList.Count > 0) Then
          For I := 0 To Pred(FTempList.Count) Do
            FDeptList.Add (FTempList.Values[FTempList.Names[I]]);

        // Load User List from .INI file
        FTempList.Clear;
        FIniFile.ReadSectionValues(UserSection, FTempList);

        If (FTempList.Count > 0) Then
          For I := 0 To Pred(FTempList.Count) Do Begin
            // Get Type and Department details as well and store in associated object
            UserData := TUserData.Create;
            With UserData Do Begin
              UserCode  := Trim(FTempList.Values[FTempList.Names[I]]);
              UserType  := FIniFile.ReadInteger('User:'+UpperCase(UserCode), 'Type', 2);
              DeptCode  := FIniFile.ReadString('User:'+UpperCase(UserCode), 'Dept', '');
            End; { UserData }
            FUserList.AddObject (UserData.UserCode, UserData);
          End; { For }
      Finally
        FTempList.Destroy;
      End;
    End { If }
    Else
      // Invalid Path
      MessageDlg('The Company Directory ' + QuotedStr(Value) + ' does not exist, please notify your ' +
                 'system administrator that the Multi-Company Manager has an invalid company.',
                 mtError, [mbOK], 0);
  End { If (Value <> FCompanyPath) }
End; { SetCompanyPath }

{-------------------------------------------}

Procedure TPORSecuritySettings.ReadDeptsIntoList (DeptList : TStrings);
Begin { ReadDeptsIntoList }
  DeptList.Assign (FDeptList);
End; { ReadDeptsIntoList }

{-------------------------------------------}

// Reads the Departments from the .INI file into an internal list
Procedure TPORSecuritySettings.ReadDeptsIntoListView (DeptList : TListView);
Var
  I       : SmallInt;
Begin { ReadDeptsIntoListView }
  With DeptList Do Begin
    // Clear out any pre-existing crap from ListView
    Items.Clear;

    If (FDeptList.Count > 0) Then
      For I := 0 To Pred(FDeptList.Count) Do Begin
         With Items.Add Do
           Caption := FDeptList[I];
        End; { For I }
  End; { With DeptList }
End; { ReadDeptsIntoListView }

{-------------------------------------------}

// Performs a case-insensitive look for the string in a list, returns -1 if not found, and
// the index within the StringList if found
Function TPORSecuritySettings.CheckForString (TheList : TStrings; TheStr : String) : SmallInt;
Var
  I : SmallInt;
Begin { CheckForString }
  Result := -1;

  If (TheList.Count > 0) Then Begin
    TheStr := UpperCase(Trim(TheStr));

    For I := 0 To Pred(TheList.Count) Do
      If (UpperCase(Trim(TheList[I])) = TheStr) Then Begin
        Result := I;
        Break;
      End; { If (UpperCase(Trim(TheList[I]) = TheStr) }
  End; { If (TheList.Count > 0) }
End; { CheckForString }

{-------------------------------------------}

// Writes the Departments list out to PORDEPT.DAT after a change has been made
Procedure TPORSecuritySettings.WriteDeptsToIni;
Var
  I : SmallInt;
Begin { WriteDeptsToIni }
  If Assigned(FIniFile) Then
    With FIniFile Do Begin
      // Delete Departments section
      EraseSection (DeptSection);

      // Write Departments list to .INI
      If (FDeptList.Count > 0) Then
        For I := 0 To Pred(FDeptList.Count) Do
          WriteString (DeptSection, IntToStr(I), FDeptList[I]);

      // Flush .INI file buffer
      UpdateFile;
    End; { With FIniFile }
End; { WriteDeptsToIni }

{-------------------------------------------}

// Validates a new Department Code and adds into list if appropriate
// Return Codes: 0=AOK, 1=Already Exists 2=Cannot be Blank
Function TPORSecuritySettings.AddDept(DeptList : TListView; NewDept : String) : SmallInt;
Begin { AddDept }
  // Check Code is set
  NewDept := Trim(Copy(NewDept, 1, 20));
  If (NewDept <> '') Then Begin
    // Check Code doesn't already exist
    If (CheckForString (FDeptList, NewDept) = -1) Then Begin
      // Doesn't already exist - add into list
      FDeptList.Add(NewDept);
      WriteDeptsToIni;
      ReadDeptsIntoListView (DeptList);

      Result := 0;
    End { If (CheckForString (FDeptList, NewDept) = -1) }
    Else
      // Error Dept Code already exists
      Result := 1;
  End { If }
  Else
    // Error Dept Code is blank
    Result := 2;
End; { AddDept }

{-------------------------------------------}

// Returns True if the Department Code isn't being used by a User
Function TPORSecuritySettings.CanDeleteDept(DelDept : String) : Boolean;
Var
  I   : SmallInt;
Begin { CanDeleteDept }
  Result := True;

  If (FUserList.Count > 0) Then
    DelDept := UpperCase(Trim(DelDept));

    // Run trhough user list looking for matching department code
    For I := 0 To Pred(FUserList.Count) Do
      With FUserList.Objects[I] As TUserData Do
        If (UpperCase(Trim(DeptCode)) = DelDept) Then Begin
          // Matching department
          Result := False;
          Break;
        End; { If }
End; { CanDeleteDept }

{-------------------------------------------}

// Deletes the specified Department Code and reloads the ListView
Procedure TPORSecuritySettings.DeleteDepartment (DeptList : TListView; DeptCode : String);
Var
  LstIdx : SmallInt;
Begin { DeleteDepartment }
  // Find Department in List
  LstIdx := CheckForString (FDeptList, DeptCode);

  If (LstIdx >= 0) Then Begin
    // Delete list Entry
    FDeptList.Delete(LstIdx);

    // Update PORDEPT.DAT .INI file
    WriteDeptsToIni;

    // Update ListView
    ReadDeptsIntoListView (DeptList);
  End; { IF }
End; { DeleteDepartment }

{-------------------------------------------}

// Writes the user details out to the .INI file
Procedure TPORSecuritySettings.WriteUsersToIni;
Var
  UserData : TUserData;
  I        : SmallInt;
Begin { WriteUsersToIni }
  If Assigned(FIniFile) Then
    With FIniFile Do Begin
      // Delete Users section
      EraseSection (UserSection);

      // Write Departments list to .INI
      If (FUserList.Count > 0) Then
        For I := 0 To Pred(FUserList.Count) Do Begin
          // Write header entry in .INI file
          WriteString (UserSection, IntToStr(I), FUserList[I]);

          UserData := TUserData(FUserList.Objects[I]);
          With UserData Do Begin
            // Write User specific section
            WriteInteger('User:'+UpperCase(UserCode), 'Type', UserType);
            WriteString('User:'+UpperCase(UserCode), 'Dept', DeptCode);
          End; { With }
        End; { For I }

      // Flush .INI file buffer
      UpdateFile;
    End; { With FIniFile }

End; { WriteUsersToIni }

{-------------------------------------------}

// Reads the Users into an internal list
Procedure TPORSecuritySettings.ReadUsersIntoListView (UserList : TListView);
Var
  I       : SmallInt;
Begin { ReadUsersIntoListView }
  With UserList Do Begin
    // Clear out any pre-existing crap from ListView
    Items.Clear;

    If (FUserList.Count > 0) Then
      For I := 0 To Pred(FUserList.Count) Do Begin
        With Items.Add Do Begin
          Caption := FUserList[I];

          With FUserList.Objects[I] As TUserData Do Begin
            // User Type
            Try
              SubItems.Add (UserTypes[UserType]);
            Except
              On Exception Do
                SubItems.Add ('-ERROR-');
            End;

            // Department Code
            If (UserType <> 0) Then
              SubItems.Add (DeptCode);
          End; { UserData }
        End; { With Items.Add }
      End; { For I }
  End; { With UserList }
End; { ReadUsersIntoListView }

{-------------------------------------------}

Function TPORSecuritySettings.GetUserDets (Const UserCode : String) : TUserData;
Var
  LstIdx : SmallInt;
Begin { GetUserDets }
  Result := NIL;

  // Lookup user in list
  LstIdx := CheckForString (FUserList, UserCode);
  If (LstIdx >= 0) Then
    Result := TUserData(FUserList.Objects[LstIdx]);
End; { GetUserDets }

{-------------------------------------------}

// Returns True if the specified user code already exists
Function TPORSecuritySettings.ValidUserCode (Const NewUser : String) : Boolean;
Begin { ValidUserCode }
  Result := (CheckForString (FUserList, NewUser) = -1);
End; { ValidUserCode }

{-------------------------------------------}

// Adds a new user into the system
Procedure TPORSecuritySettings.AddNewUser (UserList : TListView; UserDets : TUserData);
Var
  UserData  : TUserData;
begin { AddNewUser }
  // Add User into list
  FUserList.AddObject (UserDets.UserCode, UserDets);

  UpdateForEdit (UserList);
End; { AddNewUser }

{-------------------------------------------}

// Saves changes caused by editing and reloads the list
Procedure TPORSecuritySettings.UpdateForEdit (UserList : TListView);
Begin { UpdateForEdit }
  // Update PORDEPT.DAT .INI file
  WriteUsersToIni;

  // reload listview
  ReadUsersIntoListView (UserList);
End; { UpdateForEdit }

{-------------------------------------------}

// Saves changes caused by editing and reloads the list
Procedure TPORSecuritySettings.DeleteUser (UserList : TListView; Const UserCode : String);
Var
  UserData  : TUserData;
  LstIdx    : SmallInt;
Begin { DeleteUser }
  LstIdx := CheckForString (FUserList, UserCode);

  If (LstIdx >= 0) Then Begin
    // Delete User details
    UserData  := TUserData(FUserList.Objects[LstIdx]);
    FUserList.Delete(LstIdx);
    UserData.Free;

    UpdateForEdit (UserList);
  End; { If }
End; { DeleteUser }

Initialization
  Settings := TPORSecuritySettings.Create;
Finalization
  If Assigned(Settings) Then Begin
    Settings.Destroy;
    Settings := Nil;
  End; { If }
end.
