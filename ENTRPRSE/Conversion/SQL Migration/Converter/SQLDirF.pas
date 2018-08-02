unit SQLDirF;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellCtrls2005, StdCtrls, ExtCtrls, BaseF, EnterToTab;

type
  TfrmSelectExchSQLDir = class(TfrmCommonBase)
    InstrLbl: TLabel;
    ShellTreeView20051: TShellTreeView2005;
    edtPath: TComboBox;
    btnContinue: TButton;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ShellTreeView20051AddFolder(Sender: TObject;
      AFolder: TShellFolder; var CanAdd: Boolean);
    procedure ShellTreeView20051Change(Sender: TObject; Node: TTreeNode);
    procedure edtPathChange(Sender: TObject);
    procedure edtPathKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnContinueClick(Sender: TObject);
    procedure ShellTreeView20051Editing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
  private
    { Private declarations }
    FInChange : Boolean;
    Function  GetPath : String;
    Procedure SetPath(Value : String);
    Function ValidPath (Path : ShortString) : Boolean;
    Function ValidExchSQLDir (Const TestDir : ShortString) : Boolean;
    procedure CheckContinueButton;
  public
    { Public declarations }
    Property InstallPath : String read GetPath write SetPath;
  end;

implementation

{$R *.dfm}

Uses DiskUtil, FileCtrl, DllIntf;

//=========================================================================

procedure TfrmSelectExchSQLDir.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := Application.Title;

  FInChange := False;
end;

//-------------------------------------------------------------------------

procedure TfrmSelectExchSQLDir.ShellTreeView20051AddFolder(Sender: TObject; AFolder: TShellFolder; var CanAdd: Boolean);
Var
  DriveInfo : DriveInfoType;
begin
  If (AFolder.Level = 1) Then
  Begin
    // Filter out Control Panel and CD/DVD Drives
    CanAdd := (UpperCase(AFolder.DisplayName) <> 'CONTROL PANEL');
    If CanAdd Then
    Begin
      DriveInfo.drDrive := AFolder.PathName[1];
      If GetDriveInfo (DriveInfo) Then
      Begin
        CanAdd := Not (DriveInfo.drDriveType In [dtFloppy, dtCDROM])
      End; // If GetDriveInfo (DriveInfo)
    End; // If CanAdd
  End; // If (AFolder.Level = 1)
end;

//-------------------------------------------------------------------------

procedure TfrmSelectExchSQLDir.ShellTreeView20051Change(Sender: TObject; Node: TTreeNode);
Var
  sPath : ShortString;
  Thing, ss, sl : Byte;
begin
  If ValidPath(ShellTreeView20051.Path) Then
  Begin
    If (Not FInChange) Then
    Begin
      edtPath.Text := ShellTreeView20051.Path;
      edtPath.SelStart := Length(edtPath.Text);
    End // If (Not FInChange)
    Else
    Begin
      // Update the path in the edit box to have the correct capitalisation for the valid part of the path
      ss := edtPath.SelStart;
      sl := edtPath.SelLength;
      Thing := Length(ShellTreeView20051.Path);
      If (Length(edtPath.Text) < Thing) Then Thing := Length(edtPath.Text);
      sPath := edtPath.Text;
      Delete(sPath, 1, Thing);
      edtPath.Text := Copy (ShellTreeView20051.Path, 1, Thing) + sPath;
      edtPath.SelStart := ss;
      edtPath.SelLength := sl;
    End; // Else

    CheckContinueButton;
  End; // If ValidPath(ShellTreeView20051.Path)
end;

//-------------------------------------------------------------------------

procedure TfrmSelectExchSQLDir.edtPathChange(Sender: TObject);
begin
  FInChange := True;
  Try
    InstallPath := edtPath.Text;
  Finally
    FInChange := False;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

procedure TfrmSelectExchSQLDir.edtPathKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
Var
  sDir    : ShortString;
  iFolders, iPos : SmallInt;
begin
  If (Key = VK_RIGHT) And (Shift = [ssCtrl]) And ShellTreeView20051.SelectedFolder.SubFolders Then
  Begin
    // Extract the incomplete directory name from the edit field and search the sub-directories
    // off the selected directory in the list for a match
    If (Length(edtPath.Text) > Length(ShellTreeView20051.Path)) Then
    Begin
      sDir := Trim(UpperCase(Copy (edtPath.Text, Length(IncludeTrailingPathDelimiter(ShellTreeView20051.Path))+1, 100)));

      For iFolders := 0 To (ShellTreeView20051.Selected.Count - 1) Do
      Begin
        iPos := Pos(sDir, Trim(UpperCase(ShellTreeView20051.Selected.Item[iFolders].Text)));
        If (iPos = 1) Then
        Begin
          edtPath.Text := IncludeTrailingPathDelimiter(ShellTreeView20051.Path) + IncludeTrailingPathDelimiter(ShellTreeView20051.Selected.Item[iFolders].Text);
          edtPath.SelLength := 0;
          edtPath.SelStart := Length(edtPath.Text);
          edtPathChange(Sender);
          Break;
        End; // If (iPos = 1)
      End; // For iFolders
    End; // If (Length(edtPath.Text) > Length(ShellTreeView20051.Path))

    CheckContinueButton;
  End; // If (Key = VK_RIGHT) And (Shift = ssCtrl)
end;

//-------------------------------------------------------------------------

Function TfrmSelectExchSQLDir.ValidPath (Path : ShortString) : Boolean;
Begin // ValidPath
  Path := UpperCase(Trim(Path));
  Result := (Length(Path) >= 2);
  If Result Then
    Result := (Path[1] In ['A'..'Z']) And (Path[2] = ':');
End; // ValidPath

//-------------------------------------------------------------------------

Function TfrmSelectExchSQLDir.GetPath : String;
Begin
  Result := edtPath.Text;
End;

Procedure TfrmSelectExchSQLDir.SetPath(Value : String);
Var
  sPath : ShortString;
Begin
  // Find the last valid directory in the path and set the directory list box to show it
  sPath := IncludeTrailingPathDelimiter(Value);

  While ValidPath(sPath) And (Not DirectoryExists(sPath)) And (Length(sPath) > 3) Do
  Begin
    Delete(sPath, Length(sPath), 1);
    sPath := ExtractFilePath(sPath);
  End; // While (Not DirectoryExists(sPath))

  If ValidPath(sPath) And DirectoryExists(sPath) Then
  Begin
    // Remove any double slashes as this is easy to do and fix
    sPath := StringReplace (sPath, '\\', '\', [rfReplaceAll]);

    Try
      ShellTreeView20051.Path := sPath;
      ShellTreeView20051.Selected.MakeVisible;
      If ShellTreeView20051.SelectedFolder.SubFolders Then
        ShellTreeView20051.Selected.Expand(False);
    Except
      // Bury errors - it wouldn't give the user confidence in the install
    End;

    CheckContinueButton;
  End; // If ValidPath(sPath) And DirectoryExists(sPath)
End;

//-------------------------------------------------------------------------

Function TfrmSelectExchSQLDir.ValidExchSQLDir (Const TestDir : ShortString) : Boolean;
Begin // ValidExchSQLDir
  Result := FileExists (TestDir + 'Enter1.Exe') And
            // MH 06/05/2009: Modified for v6.01 to use the v10.1 emulator files
            FileExists (TestDir + 'ExchSQLEmulator.Dll') And
            //FileExists (TestDir + 'ICoreEmulator.Dll') And
            FileExists (TestDir + 'Excheqr.Sys') And
            (Not FileExists (TestDir + 'COMPANY.DAT')) And
            FileExists (TestDir + 'ENTRPRSE.DAT') And
            (Not FileExists (TestDir + 'EXCHQSS.DAT')) And
            (Not FileExists (TestDir + 'CUST\CUSTSUPP.DAT')) And
            (Not FileExists (TestDir + 'TRANS\DOCUMENT.DAT'));
End; // ValidExchSQLDir

//------------------------------

procedure TfrmSelectExchSQLDir.CheckContinueButton;
Begin // CheckContinueButton
  btnContinue.Enabled := ValidExchSQLDir(IncludeTrailingPathDelimiter(edtPath.Text));
End; // CheckContinueButton

//------------------------------

procedure TfrmSelectExchSQLDir.btnContinueClick(Sender: TObject);
Var
  TmpPath : ShortString;
  sDrive : ANSIString;
  OK : Boolean;
  Res : LongInt;
begin
  TmpPath := UpperCase(IncludeTrailingPathDelimiter(Trim(edtPath.Text)));

  // Check path is proper drive + directory format and exists
  If ValidPath(TmpPath) And DirectoryExists(TmpPath) Then
  Begin
    // Check for core program and data files
    OK := ValidExchSQLDir(IncludeTrailingPathDelimiter(TmpPath));
  End // If ValidPath
  Else
  Begin
    OK := False;
    MessageDlg ('The specified directory is not a valid path for conversion', mtError, [mbOK, mbHelp], 301);
  End; // Else

//  If OK Then
//  Begin
//    Res := CheckExchequer600PervasiveDir (TmpPath);
//    Case Res Of
//      0     : Begin // AOK
//                OK := True;
//              End; // AOK
//
//      1     : Begin // Not a valid v6.00 Pervasive Edition
//                OK := False;
//                MessageDlg ('The specified directory is not a valid path for conversion', mtError, [mbOK, mbHelp], 202);
//              End; // Not a valid v6.00 Pervasive Edition
//
//      2     : Begin // The Data is in use
//                OK := False;
//                MessageDlg ('The specified directory is still in use, all applications and services must be closed before the conversion can be run', mtError, [mbOK, mbHelp], 203);
//              End; // The Data is in use
//
//      255   : Begin // Unknown Exception
//                OK := False;
//                MessageDlg ('An unknown error has occurred whilst validating the specified directory, please contact your technical support', mtError, [mbOK], 0);
//              End; // Unknown Exception
//    Else
//    End; // Case Res
//  End; // If OK

  If OK Then
    ModalResult := mrOK
end;

//-------------------------------------------------------------------------

procedure TfrmSelectExchSQLDir.ShellTreeView20051Editing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

//-------------------------------------------------------------------------

end.
