unit Btr6_Directory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls, WiseAPI, FileCtrl, FilCtl95;

type
  TfrmBtr6Directory = class(TSetupTemplate)
    Path: TComboBox;
    DriveComboBox1: TDrive95ComboBox;
    DirectoryListBox1: TDirectory95ListBox;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure PathChange(Sender: TObject);
  private
    { Private declarations }
    InChange : Boolean;

    Function  GetPath : String;
    Procedure SetPath(Value : String);

    Function  ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
    Property InstallPath : String read GetPath write SetPath;
  end;

{ 'Installation Directory' dialog for IAO Btrieve v6.15 Pre-Installer }
function btr6DirectoryDlg (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand;

//=========================================================================

{ 'Installation Directory' dialog for IAO Btrieve v6.15 Pre-Installer }
function btr6DirectoryDlg (var DLLParams: ParamRec): LongBool;
Var
  frmBtr6Directory : TfrmBtr6Directory;
  DlgPN, DefDrv, WiseStr : String;
Begin // btr6DirectoryDlg
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  frmBtr6Directory := TfrmBtr6Directory.Create(Application);
  Try
    With frmBtr6Directory Do
    Begin
      Caption := Branding.pbProductName + ' Btrieve v6.15 Pre-Installer';

      // Insert product name into window
      ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [InstrLbl]);

      // Get default installation directory from WISE
      GetVariable(DLLParams, 'V_MAINDIR', DefDrv);

      // MH 14/09/06: Modified as it wasn't remembered c:\iaoffice unless the dir existed, in
      // which case you can't install into it.  The mod causes c:\iaoffice to be in the edit
      // box even if the dir doesn't exist
      //InstallPath := DefDrv;
      Path.Text := DefDrv;
      PathChange(frmBtr6Directory);


      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
              End;
        'N' : Begin { Next }
                SetVariable(DLLParams,'V_MAINDIR',InstallPath);
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With frmBtr6Directory }
  Finally
    frmBtr6Directory.Free;
  End;
End; // btr6DirectoryDlg

//=========================================================================

Function TfrmBtr6Directory.ValidOk(VCode : Char) : Boolean;
Var
  TmpPath : String;
Begin // ValidOk
  Result := True;

  If (VCode = 'N') Then
  Begin
    { Check its a valid drive letter path }
    TmpPath := IncludeTrailingPathDelimiter(UpperCase(Trim(Path.Text)));
    Result := (TmpPath[1] In ['C'..'Z']) And (TmpPath[2] = ':');
    If (Not Result) Then
      MessageDlg ('The path must be a valid drive and path combination', mtWarning, [mbOk], 0);

    If Result Then
    Begin
      { Check not installing it in the root of the drive }
      Result := (Length(TmpPath) > 3) Or ((Length(TmpPath) = 3) And (TmpPath[3] <> '\'));
      If (Not Result) Then
        MessageDlg ('The path cannot be the root directory of a drive', mtWarning, [mbOk], 0)
    End; // If Result

    If Result Then
    Begin
      // MH 06/09/06: Modified to prevent long filenames using spaces
      Result := (Pos(' ', TmpPath) = 0);
      If (Not Result) Then
        MessageDlg ('The Btrieve v6.15 Engine cannot be installed in a directory path containing spaces', mtWarning, [mbOk], 0)
    End; // Else

    If Result Then
    Begin
      // MH 07/09/06: Added checks for existing system
      If DirectoryExists(TmpPath) Then
      Begin
        If FileExists (TmpPath + 'Enter1.Exe') Or FileExists (TmpPath + 'Excheqr.Exe') Or
           FileExists (TmpPath + 'COMPANY.DAT') Or FileExists (TmpPath + 'EXCHQSS.DAT') Or
           FileExists (TmpPath + 'CUST\CUSTSUPP.DAT') Or FileExists (TmpPath + 'TRANS\DOCUMENT.DAT') Then
        Begin
          MessageDlg ('A system already exists in this directory and cannot be overwritten', mtWarning, [mbOK], 0);
          Result := False;
        End; // If FileExists (...
      End; // If DirectoryExists(TmpPath)
    End; // If Result
  End; // If (VCode = 'N')
End; // ValidOk

//-------------------------------------------------------------------------

Function TfrmBtr6Directory.GetPath : String;
Begin
  Result := Path.Text;
End;
Procedure TfrmBtr6Directory.SetPath(Value : String);
Var
//  Pos  : SmallInt;
//  OK   : Boolean;
  sPath : ShortString;

  Function ValidPath (Path : ShortString) : Boolean;
  Begin // ValidPath
    Path := UpperCase(Trim(Path));
    Result := (Length(Path) >= 2);
    If Result Then
      Result := (Path[1] In ['A'..'Z']) And (Path[2] = ':');
  End; // ValidPath

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
    DriveComboBox1.Drive := sPath[1];
    DirectoryListBox1.Directory := sPath;
  End; // If ValidPath(sPath) And DirectoryExists(sPath)
End;

//-------------------------------------------------------------------------

procedure TfrmBtr6Directory.DirectoryListBox1Change(Sender: TObject);
begin
  inherited;

  If (Not InChange) Then
    Path.Text := IncludeTrailingPathDelimiter(DirectoryListBox1.Directory);
end;

//-------------------------------------------------------------------------

procedure TfrmBtr6Directory.PathChange(Sender: TObject);
begin
  inherited;
  InChange := True;
  Try
    InstallPath := Path.Text;
  Finally
    InChange := False;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

end.
