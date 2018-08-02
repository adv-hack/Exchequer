unit AdminF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, IniFiles, ComCtrls, StdCtrls, ExtCtrls, FileUtil,
  EnterToTab;

const
  InvalidServiceStr = '*** INVALID ***';

type
  TfrmAdminMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    PageControl1: TPageControl;
    tabshServices: TTabSheet;
    tabshDefaults: TTabSheet;
    Label1: TLabel;
    btnAddService: TButton;
    btnDeleteService: TButton;
    lvServices: TListView;
    btnEditService: TButton;
    Bevel1: TBevel;
    tabshSettings: TTabSheet;
    Label2: TLabel;
    btnAddDefault: TButton;
    btnDeleteDefault: TButton;
    lvDefaults: TListView;
    Label3: TLabel;
    Label4: TLabel;
    edtANCPath: TEdit;
    btnEditSettings: TButton;
    btnCancelSettings: TButton;
    Label5: TLabel;
    Label6: TLabel;
    edtContractNo: TEdit;
    btnBrowse: TButton;
    chkExtendedMode: TCheckBox;
    Label7: TLabel;
    Label8: TLabel;
    edtANCAccountNo: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    edtSystemId: TEdit;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddServiceClick(Sender: TObject);
    procedure btnEditServiceClick(Sender: TObject);
    procedure btnDeleteServiceClick(Sender: TObject);
    procedure btnAddDefaultClick(Sender: TObject);
    procedure btnDeleteDefaultClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnEditSettingsClick(Sender: TObject);
    procedure btnCancelSettingsClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure chkExtendedModeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure InitSettingFields(Const DispMode : Byte);
    procedure SetExtendedFields(Const DisplayEnabled : Boolean);

    procedure DisplayService (Const DispMode : Byte);
    Function  GetServiceCode : ShortString;
    procedure SaveServices;

    procedure DisplayDefault (Const DispMode : Byte);
    Function  GetDefaultCode : ShortString;
    procedure SaveDefaults;
  public
    { Public declarations }
    oConfigIni : TIniFile;

    Function GetDefaultServiceCode(Const DefCode : ShortString) : ShortString;
    Function  GetServiceDesc(Const ServiceCode : ShortString) : ShortString;
  end;

var
  frmAdminMain: TfrmAdminMain;

implementation

{$R *.dfm}

{$WARNINGS OFF}
Uses piMisc, ServiceF, DefaultF, ShellAPI, ShlObj, VerInfo;
{$WARNINGS OFF}

//---------------------------------------------------------------------------

procedure TfrmAdminMain.FormCreate(Sender: TObject);
Var
  NumItems, I  : SmallInt;
  sService     : ShortString;
begin
  Caption := Application.Title;

  // Open .INI file
//  oConfigIni := TIniFile.Create (ExtractFilePath(Application.ExeName) + 'ENANCEXP.INI');
  oConfigIni := TIniFile.Create (GetEnterpriseDirectory + 'ENANCEXP.INI');

  With oConfigIni Do Begin
    // Load Services
    NumItems := ReadInteger('ServiceCodes','NumCodes',0);
    If (NumItems > 0) Then
      For I := 1 To NumItems Do Begin
        { Service details }
        sService := Trim(ReadString('ServiceCodes','Code'+IntToStr(I),''));

        If (sService <> '') And (sService[4] = '-') Then
          With lvServices.Items.Add Do Begin
            Caption := Trim(UpperCase(Copy(sService,1,3)));
            SubItems.Add (Trim(Copy(sService,5,Length(sService))));
          End; { With lvServices.Items.Add }
      End; { For }

    // Load Defaults
    NumItems := ReadInteger('DefaultCodes','NumDefaults',0);
    If (NumItems > 0) Then
      For I := 1 To NumItems Do Begin
        { Service details }
        sService := Trim(ReadString('DefaultCodes','Def'+IntToStr(I),''));

        If (sService <> '') And (Pos('-', sService) > 0) Then
          With lvDefaults.Items.Add Do Begin
            Caption := UpperCase(Trim(Copy (sService, 1, Pos('-', sService) - 1)));
            SubItems.Add (Trim(Copy (sService, Pos('-', sService) + 1, 3)));
            SubItems.Add (GetServiceDesc(SubItems[0]));
          End; { With lvServices.Items.Add }
      End; { For }

    // Settings
    edtANCPath.Text := ReadString ('Settings', 'ANCPath', '');
    edtContractNo.Text := ReadString ('Settings', 'ANCContractNo', '');
    chkExtendedMode.Checked := ReadBool ('Settings', 'ExtendedMode', False);
    edtANCAccountNo.Text := ReadString ('Settings', 'ANCAccountNo', '');
    edtSystemId.Text := ReadString ('Settings', 'SystemId', '');
    If (edtANCPath.Text = '') Or (edtContractNo.Text = '') Or Not DirectoryExists(edtANCPath.Text) Then Begin
      PageControl1.ActivePage := tabshSettings;
      If (edtANCPath.Text = '') Or Not DirectoryExists(edtANCPath.Text) Then
        MessageDlg ('The ANC Path setting is invalid, this must be set correctly before ' +
                    'the Plug-In can be used', mtWarning, [mbOk], 0);
      If (edtContractNo.Text = '') Then
        MessageDlg ('The ANC Contract Number is not set, this must be set correctly before ' +
                    'the Plug-In can be used', mtWarning, [mbOk], 0);
    End; { If (edtANCPath.Text = '') ... }
  End; { With oConfigIni }

  InitSettingFields(0);
end;

//---------------------------------------------------------------------------

procedure TfrmAdminMain.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(oConfigIni);
end;

//---------------------------------------------------------------------------

procedure TfrmAdminMain.SetExtendedFields(Const DisplayEnabled : Boolean);
Begin // SetExtendedFields
  // ANC Account No
  edtANCAccountNo.ReadOnly := Not DisplayEnabled;
  If edtANCAccountNo.ReadOnly Then edtANCAccountNo.Color := clBtnFace Else edtANCAccountNo.Color := clWindow;

  // System Id - Backdoor flag
  edtSystemId.ReadOnly := Not DisplayEnabled;
  If edtSystemId.ReadOnly Then edtSystemId.Color := clBtnFace Else edtSystemId.Color := clWindow;
End; // SetExtendedFields

//-------------------------------------------------------------------------

// 0=View, 1=Edit
procedure TfrmAdminMain.InitSettingFields(Const DispMode : Byte);
Begin { InitSettingFields }
  // ANC Path
  edtANCPath.ReadOnly := (DispMode = 0);
  If edtANCPath.ReadOnly Then edtANCPath.Color := clBtnFace Else edtANCPath.Color := clWindow;

  // Browse button
  btnBrowse.Enabled := (DispMode = 1);

  // ANC Contract Number
  edtContractNo.ReadOnly := (DispMode = 0);
  If edtContractNo.ReadOnly Then edtContractNo.Color := clBtnFace Else edtContractNo.Color := clWindow;

  // Extended Mode
  chkExtendedMode.Enabled := (DispMode = 1);
  SetExtendedFields(chkExtendedMode.Enabled And chkExtendedMode.Checked);

  // Edit/Save Button
  If (DispMode = 1) Then
    btnEditSettings.Caption := '&Save'
  Else
    btnEditSettings.Caption := '&Edit';

  // NA/Cancel Button
  btnCancelSettings.Visible := (DispMode = 1);
End; { InitSettingFields }

//---------------------------------------------------------------------------

procedure TfrmAdminMain.About1Click(Sender: TObject);
Var
  slAboutText : TStringList;
  iPos        : Byte;
  sText       : ANSIString;
begin
  slAboutText := TStringList.Create;
  Try
    PIMakeAboutText (Application.Title,
                     ANCVer + ' (DLL)',
                     slAboutText);

    For iPos := 0 To 4 Do
      sText := sText + slAboutText[IPos] + #13;
    Delete (sText, Length(sText), 1);
  Finally
    FreeAndNIL (slAboutText);
  End;

  Application.MessageBox (PCHAR(sText), 'About...', 0);
end;

//---------------------------------------------------------------------------

Function TfrmAdminMain.GetServiceCode : ShortString;
Begin { GetServiceCode }
  If (lvServices.ItemIndex >= 0) Then
    Result := lvServices.Items[lvServices.ItemIndex].Caption
  Else
    Raise Exception.Create('A Service Code must be selected')
End; { GetServiceCode }

//---------------------------------------------------------------------------

Function TfrmAdminMain.GetServiceDesc(Const ServiceCode : ShortString) : ShortString;
Var
  ListItem : TListItem;
Begin { GetServiceDesc }
  Result := InvalidServiceStr;

  If (lvServices.Items.Count > 0) Then Begin
    ListItem := lvServices.FindCaption(0, ServiceCode, False, True, False);
    If Assigned(ListItem) Then
      Result := ListItem.SubItems[0];
  End; { If (lvServices.Items.Count > 0) }
End; { GetServiceDesc }

//---------------------------------------------------------------------------

procedure TfrmAdminMain.SaveServices;
Var
  I : SmallInt;
Begin { SaveServices }
  With oConfigIni Do Begin
    // Delete current Service Codes section
    EraseSection ('ServiceCodes');

    WriteInteger('ServiceCodes','NumCodes',lvServices.Items.Count);
    If (lvServices.Items.Count > 0) Then
      For I := 0 To Pred(lvServices.Items.Count) Do
        With lvServices.Items[I] Do Begin
          WriteString('ServiceCodes',
                      'Code'+IntToStr(I + 1),
                      Format('%-3.3s-%s', [Caption, SubItems[0]]));
        End; { With lvServices.Items[I] }
  End; { With oConfigIni }
End; { SaveServices }

//---------------------------------------------------------------------------

// 0=Add, 1=Edit, 2=Delete
procedure TfrmAdminMain.DisplayService (Const DispMode : Byte);
begin
  With TfrmServiceDetail.Create (Self) Do
    Try
      Displaymode := DispMode;

      Case DispMode Of
        0 : Begin
              Caption := 'Add New Service Code';

              // Initialise new service
              ServiceCode := '';
              ServiceDesc := '';
            End;
        1 : Begin
              Caption := 'Edit Service Code';

              // load service details
              ServiceCode := GetServiceCode;
              ServiceDesc := GetServiceDesc(ServiceCode);
            End;
        2 : Begin
              Caption := 'Delete Service Code';

              // load service details
              ServiceCode := GetServiceCode;
              ServiceDesc := GetServiceDesc(ServiceCode);
            End;
      Else
        Raise Exception.Create (Format('TfrmAdminMain.DisplayService - Invalid DispMode value (%d)', [DispMode]));
      End; { Case DispMode }

      If (ShowModal = mrOk) Then Begin
        Case DispMode Of
          0   : With lvServices.Items.Add Do Begin
                  Caption := ServiceCode;
                  SubItems.Add(ServiceDesc);
                End; { With lvServices.Items.Add }
          1   : With lvServices.Items[lvServices.ItemIndex] Do Begin
                  Caption := ServiceCode;
                  SubItems[0] := ServiceDesc;
                End; { With lvServices.Items[lvServices.ItemIndex] }
          2   : lvServices.DeleteSelected;
        End; { Case DispMode }

        // Save changes
        SaveServices;
      End; { If (ShowModal = mrOk) }
    Finally
      Free;
    End;
end;

//------------------------------------

procedure TfrmAdminMain.btnAddServiceClick(Sender: TObject);
begin
  DisplayService (0);
end;

//------------------------------------

procedure TfrmAdminMain.btnEditServiceClick(Sender: TObject);
begin
  If (lvServices.ItemIndex >= 0) Then DisplayService (1);
end;

//------------------------------------

procedure TfrmAdminMain.btnDeleteServiceClick(Sender: TObject);
begin
  If (lvServices.ItemIndex >= 0) Then DisplayService (2);
end;

//---------------------------------------------------------------------------

Function TfrmAdminMain.GetDefaultCode : ShortString;
Begin { GetDefaultCode }
  If (lvDefaults.ItemIndex >= 0) Then
    Result := lvDefaults.Items[lvDefaults.ItemIndex].Caption
  Else
    Raise Exception.Create('A Default Code must be selected')
End; { GetDefaultCode }

//---------------------------------------------------------------------------

Function TfrmAdminMain.GetDefaultServiceCode(Const DefCode : ShortString) : ShortString;
Var
  ListItem : TListItem;
Begin { GetDefaultServiceCode }
  Result := InvalidServiceStr;

  If (lvDefaults.Items.Count > 0) Then Begin
    ListItem := lvDefaults.FindCaption(0, DefCode, False, True, False);
    If Assigned(ListItem) Then
      Result := ListItem.SubItems[0];
  End; { If (lvDefaults.Items.Count > 0) }
End; { GetDefaultServiceCode }

//---------------------------------------------------------------------------

procedure TfrmAdminMain.SaveDefaults;
Var
  I : SmallInt;
Begin { SaveDefaults }
  With oConfigIni Do Begin
    // Delete current Default Codes section
    EraseSection ('DefaultCodes');

    WriteInteger('DefaultCodes','NumDefaults',lvDefaults.Items.Count);
    If (lvDefaults.Items.Count > 0) Then
      For I := 0 To Pred(lvDefaults.Items.Count) Do
        With lvDefaults.Items[I] Do Begin
          WriteString('DefaultCodes',
                      'Def'+IntToStr(I + 1),
                      Format('%-2.2s-%s', [Caption, SubItems[0]]));
        End; { With lvServices.Items[I] }
  End; { With oConfigIni }
End; { SaveDefaults }

//---------------------------------------------------------------------------

// 0=Add, 1=Edit, 2=Delete
procedure TfrmAdminMain.DisplayDefault (Const DispMode : Byte);
begin { DisplayDefault }
  With TfrmDefaultDetail.Create (Self) Do
    Try
      Displaymode := DispMode;

      Case DispMode Of
        0 : Begin
              Caption := 'Add New Default Code';

              // Initialise new service
              DefaultCode := '';
              ServiceCode := '';
            End;
        2 : Begin
              Caption := 'Delete Default Code';

              // load service details
              DefaultCode := GetDefaultCode;
              ServiceCode := GetDefaultServiceCode(DefaultCode);
            End;
      Else
        Raise Exception.Create (Format('TfrmAdminMain.DisplayService - Invalid DispMode value (%d)', [DispMode]));
      End; { Case DispMode }

      If (ShowModal = mrOk) Then Begin
        Case DispMode Of
          0   : With lvDefaults.Items.Add Do Begin
                  Caption := DefaultCode;
                  SubItems.Add(ServiceCode);
                  SubItems.Add (GetServiceDesc(SubItems[0]));
                End; { With lvDefaults.Items.Add }
          2   : lvDefaults.DeleteSelected;
        End; { Case DispMode }

        // Save changes
        SaveDEfaults;
      End; { If (ShowModal = mrOk) }
    Finally
      Free;
    End;
end; { DisplayDefault }

//------------------------------------

procedure TfrmAdminMain.btnAddDefaultClick(Sender: TObject);
begin
  DisplayDefault (0);
end;

//------------------------------------

procedure TfrmAdminMain.btnDeleteDefaultClick(Sender: TObject);
begin
  DisplayDefault (2);
end;

//---------------------------------------------------------------------------

function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
  result := 0;
end;

//------------------------------------

procedure TfrmAdminMain.btnBrowseClick(Sender: TObject);
var
  TitleName : string;
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..MAX_PATH] of char;
  TempPath : array[0..MAX_PATH] of char;
  Directory: ANSIString;
begin
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  With BrowseInfo Do Begin
    // Parent Window
    hwndOwner := Self.Handle;

    // storage space for selected path
    pszDisplayName := @DisplayName;

    // Text message
    TitleName := 'Please specify the ANC directory';
    lpszTitle := PChar(TitleName);

    // Default directory
    If DirectoryExists(edtANCPath.Text) Then Begin
      Directory := edtANCPath.Text;
      lparam := Integer(PChar(Directory));
      lpfn := SelectDirCB;
    End; { If DirectoryExists(edtANCPath.Text) }

    // Flags
    ulFlags := BIF_RETURNONLYFSDIRS;            // File System Directories only
  End; { With BrowseInfo }

  // Directory dialog
  lpItemID := SHBrowseForFolder(BrowseInfo);

  If (lpItemId <> NIL) Then Begin
    SHGetPathFromIDList(lpItemID, TempPath);
    GlobalFreePtr(lpItemID);

    edtANCPath.Text := TempPath;
  End; { If (lpItemId <> NIL) }
end;

//---------------------------------------------------------------------------

procedure TfrmAdminMain.btnEditSettingsClick(Sender: TObject);
Var
  OK : Boolean;
begin
  If (btnEditSettings.Caption = '&Edit') Then Begin
    // Convert to Edit Mode
    InitSettingFields(1);
    If edtANCPath.CanFocus Then edtANCPath.SetFocus;
  End { If (btnEditSettings.Caption = '&Edit') }
  Else Begin
    // Validate and save changes
    OK := (Trim(edtANCPath.Text) <> '') And DirectoryExists(edtANCPath.Text);
    If OK Then Begin
      OK := (Trim(edtContractNo.Text) <> '');
      If (Not OK) Then Begin
        If edtContractNo.CanFocus Then edtContractNo.SetFocus;
        MessageDlg ('The ANC Contract Number is invalid', mtError, [mbOK], 0);
      End; { If (Not OK) }
    End { If OK }
    Else Begin
      If edtANCPath.CanFocus Then edtANCPath.SetFocus;
      MessageDlg ('The ANC Path is invalid', mtError, [mbOK], 0);
    End; { Else }

    If OK And chkExtendedMode.Checked Then
    Begin
      OK := (Trim(edtANCAccountNo.Text) <> '');
      If (Not OK) Then
      Begin
        If edtANCAccountNo.CanFocus Then edtANCAccountNo.SetFocus;
        MessageDlg ('The ANC Account Number is invalid', mtError, [mbOK], 0);
      End; // If (Not OK)
    End; // If OK And chkExtendedMode.Checked

    If OK Then Begin
      // Save changes
      oConfigIni.WriteString ('Settings', 'ANCPath', edtANCPath.Text);
      oConfigIni.WriteString ('Settings', 'ANCContractNo', edtContractNo.Text);
      oConfigIni.WriteBool ('Settings', 'ExtendedMode', chkExtendedMode.Checked);
      oConfigIni.WriteString ('Settings', 'ANCAccountNo', edtANCAccountNo.Text);
      oConfigIni.WriteString ('Settings', 'SystemId', edtSystemId.Text);

      // Restore to Edit mode
      InitSettingFields(0);
    End; { If OK }
  End; { Else }
end;

//------------------------------------

procedure TfrmAdminMain.btnCancelSettingsClick(Sender: TObject);
begin
  // Restore to Edit mode
  InitSettingFields(0);

  // Restore values
  With oConfigIni Do Begin
    edtANCPath.Text := ReadString ('Settings', 'ANCPath', '');
    edtContractNo.Text := ReadString ('Settings', 'ANCContractNo', '');
  End; { With oConfigIni }
end;

//---------------------------------------------------------------------------

procedure TfrmAdminMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

//---------------------------------------------------------------------------

procedure TfrmAdminMain.chkExtendedModeClick(Sender: TObject);
begin
  SetExtendedFields(chkExtendedMode.Enabled And chkExtendedMode.Checked);
end;

//-------------------------------------------------------------------------

procedure TfrmAdminMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
end;

//------------------------------

procedure TfrmAdminMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
end;

//-------------------------------------------------------------------------

end.
