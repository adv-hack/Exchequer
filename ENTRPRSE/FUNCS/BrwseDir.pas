unit BrwseDir;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, FileCtrl, ShellCtrls2005;

type
  TFakeDirListBox = Record
    Directory : string;
  end;

  TFrmDirBrowse = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    lDir: TLabel;
    btnCreateNew: TButton;
    stvDirectory: TShellTreeView2005;
    procedure lbDirectoryChange(Sender: TObject);
    procedure DriveComboBox1Change(Sender: TObject);
    procedure btnCreateNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure stvDirectoryChange(Sender: TObject; Node: TTreeNode);
    procedure stvDirectoryAddFolder(Sender: TObject; AFolder: TShellFolder;
      var CanAdd: Boolean);
  protected
    procedure SetDirectory(const Value: string);
    function  GetDirectory : string;
  public
    lbDirectory : TFakeDirListBox;
    property Directory : string read GetDirectory write SetDirectory;
  end;

  TBrowseDirDialog = class
    private
      fKeepCurrDir,
      fAddBackSlash : boolean;
      fDirectory : string;
    protected
      procedure SetDirectory(const Value: string);
      procedure SetBoolean(const Index: Integer; const Value: boolean);
    public
      property KeepCurrDir : boolean index 1 read fKeepCurrDir write SetBoolean;
      property AddBackslash : boolean index 2 read fAddBackSlash write SetBoolean;
      property Directory : string read fDirectory write SetDirectory;
      function Execute : boolean;
      constructor Create;
  end;

var
  FrmDirBrowse: TFrmDirBrowse;

implementation
uses
  DiskUtil;

{$R *.DFM}

procedure TFrmDirBrowse.lbDirectoryChange(Sender: TObject);
begin
//  Directory := lbDirectory.Directory;
  Directory := stvDirectory.Selected.GetNamePath;
end;

procedure TFrmDirBrowse.DriveComboBox1Change(Sender: TObject);
begin
  Directory := stvDirectory.Selected.GetNamePath;
end;

procedure TFrmDirBrowse.btnCreateNewClick(Sender: TObject);
var
  sNewDirName : string;
begin
  if InputQuery('Create Sub-Directory of ' + lDir.caption, 'New Directory Name', sNewDirName) then begin
    if CreateDir(IncludeTrailingBackslash(lDir.caption) + sNewDirName)
    then stvDirectory.Refresh(stvDirectory.Selected)
    else MessageDlg('Error Creating Dir : ' + IncludeTrailingBackslash(lDir.caption)
    + sNewDirName, mtError, [mbOK], 0);
  end;{if}
end;

procedure TFrmDirBrowse.SetDirectory(const Value: string);
begin
  if DirectoryExists(Value) then
  begin
//    lbDirectory.Directory := Value;
    stvDirectory.Path := Value;
    stvDirectory.Selected.MakeVisible;
    If stvDirectory.SelectedFolder.SubFolders Then stvDirectory.Selected.Expand(False);

    lDir.Caption := Value;
  end;
end;

function TFrmDirBrowse.GetDirectory: string;
begin
//  Result := lbDirectory.Directory;
  Result := stvDirectory.Path;
end;

{ TBrowseDirDialog }

constructor TBrowseDirDialog.Create;
begin
  inherited Create;
  KeepCurrDir := true;
  AddBackSlash := true;
end;

procedure TBrowseDirDialog.SetBoolean(const Index: Integer; const Value: boolean);
begin
  case Index of
    1: fKeepCurrDir := Value;
    2: fAddBackSlash := Value;
  end;
end;

procedure TBrowseDirDialog.SetDirectory(const Value: string);
begin
  fDirectory := Value;
end;

function TBrowseDirDialog.Execute: boolean;
var
  CurrDir : string;
begin
  if KeepCurrDir then
    CurrDir := GetCurrentDir;

  with TFrmDirBrowse.Create(nil) do
    try
      Directory := self.Directory;
      Result := ShowModal = mrOK;
      self.Directory := Directory;
      if AddBackSlash then
        self.Directory := IncludeTrailingBackslash(self.Directory);
    finally
      Release;
    end;

  if KeepCurrDir then
    SetCurrentDir(CurrDir);
end;

procedure TFrmDirBrowse.FormCreate(Sender: TObject);
begin
  FillChar(lbDirectory, SizeOf(lbDirectory), #0);
end;

procedure TFrmDirBrowse.FormShow(Sender: TObject);
begin
  if (Trim(lbDirectory.Directory) <> '') and DirectoryExists(lbDirectory.Directory) then
  begin
    Directory := lbDirectory.Directory;
  end;
end;

procedure TFrmDirBrowse.btnOKClick(Sender: TObject);
begin
  lbDirectory.Directory := stvDirectory.Path;
end;

procedure TFrmDirBrowse.stvDirectoryChange(Sender: TObject;
  Node: TTreeNode);
begin
  if DirectoryExists(stvDirectory.Path) then lDir.Caption := stvDirectory.Path;
  btnOK.Enabled := DirectoryExists(stvDirectory.Path);
  btnCreateNew.Enabled := btnOK.Enabled;
end;

procedure TFrmDirBrowse.stvDirectoryAddFolder(Sender: TObject;
  AFolder: TShellFolder; var CanAdd: Boolean);
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

end.
