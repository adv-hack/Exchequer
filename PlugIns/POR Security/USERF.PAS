unit UserF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniIntf;

type
  TUserDetsDlgMode = (moAdd, moEdit, moDelete);

  TfrmUserDetails = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtUserCode: TEdit;
    lstUserType: TComboBox;
    lstDepartment: TComboBox;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstUserTypeClick(Sender: TObject);
  private
    { Private declarations }
    FMode     : TUserDetsDlgMode;
    FUserDets : TUserData;
  public
    { Public declarations }
    Procedure DispUser(Const Mode : TUserDetsDlgMode; Const UserDets : TUserData);
  end;

implementation

{$R *.DFM}

procedure TfrmUserDetails.FormCreate(Sender: TObject);
Var
  I : Byte;
begin
  // Load User Types
  For I := Low(UserTypes) To High(UserTypes) Do
    lstUserType.Items.Add (UserTypes[I]);

  // Load Departments
  Settings.ReadDeptsIntoList (lstDepartment.Items);
end;

{-------------------------------------------}

procedure TfrmUserDetails.btnSaveClick(Sender: TObject);
Var
  OK : Boolean;
begin
  OK := True;

  With FUserDets Do Begin
    // Validate User Code
    If (FMode = moAdd) Then Begin
      UserCode := UpperCase(Trim(edtUserCode.Text));
      // Check Code not blank
      OK := (UserCode <> '');
      If OK Then Begin
        // Check doesn't already exist
        OK := Settings.ValidUserCode (UserCode);
        If (Not OK) Then
          MessageDlg('A User with this code already exists', mtError, [mbOK], 0);
      End { If }
      Else
        MessageDlg('The User Code cannot be blank', mtError, [mbOK], 0);
    End; { If (FMode = moAdd) }

    If OK Then Begin
      // User Type
      OK := (lstUserType.ItemIndex >= 0);
      If OK Then
        UserType := lstUserType.ItemIndex
      Else
        MessageDlg('The User Type must be set', mtError, [mbOK], 0);
    End; { If OK }

    If OK Then Begin
      // Department Code - Check user type
      If (UserType > 0) Then Begin
        // Manager or Departmental User
        OK := (lstDepartment.ItemIndex >= 0);
        If OK Then
          DeptCode := Trim(lstDepartment.Text)
        Else
          MessageDlg('The Department Code must be set', mtError, [mbOK], 0);
      End { If (UserType > 0) }
      Else
        // Global User - No department code wanted
        DeptCode := '';
    End; { If OK }
  End; { With FUserDets }

  If OK Then
    ModalResult := mrOk;
end;

{-------------------------------------------}

Procedure TfrmUserDetails.DispUser(Const Mode : TUserDetsDlgMode; Const UserDets : TUserData);
Begin { DispUser }
  FMode := Mode;
  FUserDets := UserDets;

  With FUserDets Do Begin
    // do context-senetive caption
    Case FMode Of
      moAdd    : Caption := 'Add New User';
      moEdit   : Caption := 'Edit User ' + Trim(UserCode);
      moDelete : Caption := 'Delete User ' + Trim(UserCode);
    End; { Case }

    // enable fields dependant on mode
    edtUserCode.Enabled := (Mode = moAdd);
    lstUserType.Enabled := (Mode <> moDelete);
    lstDepartment.Enabled := (Mode <> moDelete);

    // Change 'Save' to 'Delete' if deleting a user
    If (Mode = moDelete) Then
      btnSave.Caption := '&Delete';

    // Display fields
    edtUserCode.Text := Trim(UserCode);

    lstUserType.ItemIndex := UserType;
    lstUserTypeClick(Self);

    lstDepartment.ItemIndex := Settings.CheckForString (lstDepartment.Items, DeptCode);
  End; { With UserDets }
End; { DispUser }

{-------------------------------------------}

procedure TfrmUserDetails.lstUserTypeClick(Sender: TObject);
begin
  // Department only needed for Managers and Users
  lstDepartment.Enabled := (lstUserType.ItemIndex > 0) and (FMode <> moDelete);
end;

{-------------------------------------------}
end.
