unit AdminF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ExtCtrls, StdCtrls, UserF, IniIntf;

type
  TfrmAdmin = class(TForm)
    PageControl1: TPageControl;
    tabshDept: TTabSheet;
    tabshUsers: TTabSheet;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuoptExit: TMenuItem;
    mnuHelp: TMenuItem;
    mnuoptAbout: TMenuItem;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    btnAddDept: TButton;
    btnDeleteDept: TButton;
    Label1: TLabel;
    lvDepartments: TListView;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    btnAddUser: TButton;
    btnEditUser: TButton;
    btnDeleteUser: TButton;
    lvUsers: TListView;
    Label3: TLabel;
    lstCompanies: TComboBox;
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuoptExitClick(Sender: TObject);
    procedure mnuoptAboutClick(Sender: TObject);
    procedure lstCompaniesClick(Sender: TObject);
    procedure btnAddDeptClick(Sender: TObject);
    procedure btnDeleteDeptClick(Sender: TObject);
    procedure btnAddUserClick(Sender: TObject);
    procedure btnEditUserClick(Sender: TObject);
    procedure btnDeleteUserClick(Sender: TObject);
  private
    { Private declarations }
    Function EditUser(Const Mode     : TUserDetsDlgMode;
                      Var   UserDets : TUserData) : Boolean;
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

implementation

{$R *.DFM}

Uses MCMIntF, PIMisc, ExchequerRelease;

{-------------------------------------------}

procedure TfrmAdmin.FormCreate(Sender: TObject);
begin
  // Set Caption to Application Name
  Self.Caption := Application.Title;

  // Load company Details and load details for first company
  FillCompanyList(lstCompanies);
  lstCompaniesClick(Sender);

  // Default To User tab and resize form
  PageControl1.ActivePage := tabshUsers;
  PageControl1Change(Sender);
end;

{-------------------------------------------}

procedure TfrmAdmin.FormDestroy(Sender: TObject);
begin
end;

{-------------------------------------------}

// Stop Window Updating whilst we resize everything
procedure TfrmAdmin.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  If AllowChange Then
    LockWindowUpDate(Handle);
end;

{-------------------------------------------}

// Resize window for selected tab
procedure TfrmAdmin.PageControl1Change(Sender: TObject);
begin
  If (PageControl1.ActivePage = tabshDept) Then Begin
    // Department List
    Self.ClientWidth := 296;
    PageControl1.Width := 286;
  End { If (PageControl1.ActivePage = tabshDept) }
  Else
    If (PageControl1.ActivePage = tabshUsers) Then Begin
      // User Department List
      Self.ClientWidth := 402;
      PageControl1.Width := 392;
    End; { If (PageControl1.ActivePage = tabshUsers) }

  lstCompanies.Width := PageControl1.Left + PageControl1.Width - lstCompanies.Left;

  LockWindowUpDate(0);
end;

{-------------------------------------------}

// File-Exit menu option
procedure TfrmAdmin.mnuoptExitClick(Sender: TObject);
begin
  Close;
end;

{-------------------------------------------}

// Help-About menu option
procedure TfrmAdmin.mnuoptAboutClick(Sender: TObject);
Var
  sCapt, sText : ANSIString;
  slAboutText  : TStringList;
  iPos         : Byte;
begin
  sCapt := 'About...';
  sText := '';
  slAboutText := TStringList.Create;
  Try
    PIMakeAboutText (Trim(Self.Caption),
                     ExchequerModuleVersion (emGenericPlugIn, sVersionNo),
                     slAboutText);
    For iPos := 0 To 4 Do
      sText := sText + slAboutText[IPos] + #13;
    Delete (sText, Length(sText), 1);
  Finally
    FreeAndNIL (slAboutText);
  End;

  Application.MessageBox (PCHAR(sText), PCHAR(sCapt), 0);
end;

{-------------------------------------------}

// Company selected from list - open settings for new company and reload details
procedure TfrmAdmin.lstCompaniesClick(Sender: TObject);
Var
  CompInfo : TCompanyInfo;
begin
  If (lstCompanies.ItemIndex >= 0) Then Begin
    // extract data from selected company in list
    CompInfo := TCompanyInfo(lstCompanies.Items.Objects[lstCompanies.ItemIndex]);

    Settings.CompanyPath := CompInfo.Path;

    Settings.ReadDeptsIntoListView (lvDepartments);
    Settings.ReadUsersIntoListView (lvUsers);
  End; { If (lstCompanies.ItemIndex >= 0) }
end;

{-------------------------------------------}

// Add Department button
procedure TfrmAdmin.btnAddDeptClick(Sender: TObject);
Var
  NewDept : String;
begin
  If InputQuery('Add Department Code', 'Please enter the new Department Code below.', NewDept) Then Begin
    // User entered code
    Case Settings.AddDept(lvDepartments, NewDept) Of
      { AOK }
      0 : ;

      { Already Exists }
      1 : MessageDlg('The Department Code ' + QuotedStr(NewDept) + ' already exists', mtWarning, [mbOK], 0);

      { Cannot be blank }
      2 : MessageDlg('The Department Code cannot be blank', mtWarning, [mbOK], 0);
    End; { Case Settings.AddDept }
  End; { If InputQuery... }
end;

{-------------------------------------------}

// Delete Department button
procedure TfrmAdmin.btnDeleteDeptClick(Sender: TObject);
begin
  If Assigned(lvDepartments.Selected) Then
    // Check to see if it is used
    If Settings.CanDeleteDept(lvDepartments.Selected.Caption) Then Begin
      // Confirm the deletion
      If (MessageDlg('Are you sure you want to delete the Department Code ' + QuotedStr(lvDepartments.Selected.Caption), mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
        // Delete Code
        Settings.DeleteDepartment (lvDepartments, lvDepartments.Selected.Caption);
      End; { If (MessageDlg }
    End { If Settings.CanDeleteDept }
    Else
      // Error - Department code is being used
      MessageDlg('The Department Code ' + QuotedStr(lvDepartments.Selected.Caption) + ' is being used and cannot be deleted.', mtWarning, [mbOk], 0);
end;

{-------------------------------------------}

// Generic func for using the User Detail window
Function TfrmAdmin.EditUser(Const Mode     : TUserDetsDlgMode;
                            Var   UserDets : TUserData) : Boolean;
begin
  Result := False;

  With TfrmUserDetails.Create(Self) Do
    Try
      DispUser(Mode, UserDets);

      If (ShowModal = mrOk) Then
        // Save changes
        Result := True;
    Finally
      Free;
    End;
end;

{-------------------------------------------}

// Add User button
procedure TfrmAdmin.btnAddUserClick(Sender: TObject);
Var
  UserDets : TUserData;
begin
  // Create new user details
  UserDets := TUserData.Create;
  With UserDets Do Begin
    UserCode := '';
    UserType := 2;
    DeptCode := '';
  End; { With }

  If EditUser (moAdd, UserDets) Then Begin
    // Add new user
    Settings.AddNewUser (lvUsers, UserDets);

    // NOTE: UserDets is used in Settings object so should not be Free'd
  End { If EditUser }
  Else
    UserDets.Free;
end;

{-------------------------------------------}

// Edit User button
procedure TfrmAdmin.btnEditUserClick(Sender: TObject);
Var
  UserDets : TUserData;
Begin
  If Assigned(lvUsers.Selected) Then Begin
    UserDets := Settings.GetUserDets (lvUsers.Selected.Caption);

    If EditUser (moEdit, UserDets) Then Begin
      // update listview
      Settings.UpdateForEdit (lvUsers);

      // NOTE: As EditUser is usinf the UserDets object from Settings, it is already updated!
    End; { If EditUser }
  End; { If }
end;

{-------------------------------------------}

// Delete User button
procedure TfrmAdmin.btnDeleteUserClick(Sender: TObject);
Var
  UserDets : TUserData;
begin
  If Assigned(lvUsers.Selected) Then Begin
    UserDets := Settings.GetUserDets (lvUsers.Selected.Caption);

    If EditUser (moDelete, UserDets) Then
      Settings.DeleteUser (lvUsers, UserDets.UserCode);
  End; { If }
end;

end.

