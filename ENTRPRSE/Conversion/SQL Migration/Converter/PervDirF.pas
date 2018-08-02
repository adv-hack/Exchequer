unit PervDirF;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellCtrls2005, StdCtrls, ExtCtrls, BaseF, EnterToTab;

type
  TfrmSelectExchPervasiveDir = class(TfrmCommonBase)
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
    Function ValidEntDir (Const TestDir : ShortString) : Boolean;
    procedure CheckContinueButton;
  public
    { Public declarations }
    Property InstallPath : String read GetPath write SetPath;
  end;

implementation

{$R *.dfm}

Uses DiskUtil, FileCtrl, DllIntf;

//=========================================================================

procedure TfrmSelectExchPervasiveDir.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := Application.Title;

  FInChange := False;
end;

//-------------------------------------------------------------------------

procedure TfrmSelectExchPervasiveDir.ShellTreeView20051AddFolder(Sender: TObject; AFolder: TShellFolder; var CanAdd: Boolean);
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

procedure TfrmSelectExchPervasiveDir.ShellTreeView20051Change(Sender: TObject; Node: TTreeNode);
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

procedure TfrmSelectExchPervasiveDir.edtPathChange(Sender: TObject);
begin
  FInChange := True;
  Try
    InstallPath := edtPath.Text;
  Finally
    FInChange := False;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

procedure TfrmSelectExchPervasiveDir.edtPathKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

Function TfrmSelectExchPervasiveDir.ValidPath (Path : ShortString) : Boolean;
Begin // ValidPath
  Path := UpperCase(Trim(Path));
  Result := (Length(Path) >= 2);
  If Result Then
    Result := (Path[1] In ['A'..'Z']) And (Path[2] = ':');
End; // ValidPath

//-------------------------------------------------------------------------

Function TfrmSelectExchPervasiveDir.GetPath : String;
Begin
  Result := edtPath.Text;
End;

Procedure TfrmSelectExchPervasiveDir.SetPath(Value : String);
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

Function TfrmSelectExchPervasiveDir.ValidEntDir (Const TestDir : ShortString) : Boolean;
Begin // ValidEntDir
  Result := FileExists (TestDir + 'Enter1.Exe') And
            FileExists (TestDir + 'Excheqr.Sys') And
            FileExists (TestDir + 'COMPANY.DAT') And
            FileExists (TestDir + 'ENTRPRSE.DAT') And
            FileExists (TestDir + 'EXCHQSS.DAT') And
            FileExists (TestDir + 'CUST\CUSTSUPP.DAT') And
            FileExists (TestDir + 'TRANS\DOCUMENT.DAT') And
            // MH 22/06/2012 v7.0 ABSEXCH-12956/ABSEXCH-12957: Extended to check for new v7.0 data files
            FileExists (TestDir + 'CURRENCYHISTORY.DAT') And
            FileExists (TestDir + 'TRANS\GLBUDGETHISTORY.DAT');
End; // ValidEntDir

//------------------------------

procedure TfrmSelectExchPervasiveDir.CheckContinueButton;
Begin // CheckContinueButton
  //btnContinue.Enabled := ValidEntDir(IncludeTrailingPathDelimiter(ShellTreeView20051.Path));
  btnContinue.Enabled := ValidEntDir(IncludeTrailingPathDelimiter(edtPath.Text));
End; // CheckContinueButton

//------------------------------

procedure TfrmSelectExchPervasiveDir.btnContinueClick(Sender: TObject);
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
    OK := ValidEntDir(IncludeTrailingPathDelimiter(TmpPath));
  End // If ValidPath
  Else
  Begin
    OK := False;
    MessageDlg ('The specified directory is not a valid path for conversion', mtError, [mbOK, mbHelp], 201);
  End; // Else

  If OK Then
  Begin
    Res := CheckExchequer600PervasiveDir (TmpPath);
    Case Res Of
      0     : Begin // AOK
                OK := True;
              End; // AOK

      1, 2  : Begin // Not a valid v6.00 Pervasive Edition
                OK := False;
                MessageDlg ('The specified directory does not contain a valid Exchequer v6.00 Pervasive Edition', mtError, [mbOK, mbHelp], 202);
              End; // Not a valid v6.00 Pervasive Edition

      3     : Begin // The Data is in use
                OK := False;
              End; // The Data is in use

      255   : Begin // Unknown Exception
                OK := False;
                MessageDlg ('An unknown error has occurred whilst validating the specified directory, please contact your technical support', mtError, [mbOK], 0);
              End; // Unknown Exception
    Else
    End; // Case Res
  End; // If OK

  If OK Then
  Begin
    // Warn if installation not on local hard disk
    sDrive := ExtractFileDrive(TmpPath);
    If (GetDriveType(PChar(sdrive)) <> DRIVE_FIXED) Then
      OK := (MessageDlg ('The specified Exchequer directory is not on a local hard disk, this may result in the conversion being significantly slower. ' +
                         'Do you want to continue?', mtWarning, [mbYes, mbNo, mbHelp], 204) = mrYes);
  End; // If OK

  If OK Then
    ModalResult := mrOK
end;

//-------------------------------------------------------------------------

procedure TfrmSelectExchPervasiveDir.ShellTreeView20051Editing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

//-------------------------------------------------------------------------

end.
