unit Setdir16;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FileCtrl;

type
  ShortString = String;
  SmallInt = Integer;

  TDirectoryDialog = class(TForm)
    HelpBtn: TButton;
    Panel1: TPanel;
    Bevel1: TBevel;
    ExitBtn: TButton;
    BackBtn: TButton;
    NextBtn: TButton;
    TitleLbl: TLabel;
    InstrLbl: TLabel;
    Image1: TImage;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Path: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DirectoryListBox1Change(Sender: TObject);
  private
    { Private declarations }
    FExitCode : Char;
    OldCrntDir : String;

    Procedure SetContext(Value : THelpContext);
    Procedure SetInstructions(Value : ShortString);
    Procedure SetTitle(Value : ShortString);

    Function  GetPath : String;
    Procedure SetPath(Value : String);
    Function  ValidOk(VCode : Char) : Boolean;
  public
    { Public declarations }
    ValidMode   : Char;
    CurrMode    : Char;
    WantFindEnt : Byte;
    SCuD        : Boolean;
    GlobFlags   : Array [1..3] Of Integer;
    Property InstallPath : String read GetPath write SetPath;
    Property ExitCode : Char read FExitCode write FExitCode;
    Property HelpContextID : THelpContext write SetContext;
    Property Instructions : ShortString write SetInstructions;
    Property Title : ShortString write SetTitle;
  end;

Var
  DirectoryDialog: TDirectoryDialog;

implementation

{$R *.DFM}

Uses SetupU;

Const
  DS_FullSystem : LongInt = 54000000;
  DS_NewCompany : LongInt = 7000000;
  DS_ConnectKit : LongInt = 9000000;

{ Initialise local variables }
procedure TDirectoryDialog.FormCreate(Sender: TObject);
begin
  ExitCode := '?';

  { Save Current Directory }
  {OldCrntDir := GetCurrentDir;}
  ValidMode := #0;
  CurrMode  := #0;
end;

procedure TDirectoryDialog.FormDestroy(Sender: TObject);
begin
  { Restore Current Directory }
  {SetCurrentDir(OldCrntDir);}
end;

{ Sets the Help Context ID for a Dialog }
Procedure TDirectoryDialog.SetContext(Value : THelpContext);
Begin
  If (Value <> Self.HelpContext) Then Begin
    Self.HelpContext := Value;
  End; { If }
End;

{ Sets the Instruction Label text }
Procedure TDirectoryDialog.SetInstructions(Value : ShortString);
begin
  InstrLbl.Caption := Value;
end;

{ Sets the Title Label text }
Procedure TDirectoryDialog.SetTitle(Value : ShortString);
begin
  TitleLbl.Caption := Value;
end;

{ Help Button }
procedure TDirectoryDialog.HelpBtnClick(Sender: TObject);
begin
  If (HelpContext <> 0) Then
    Application.HelpContext (HelpContext);
end;

{ Exit Installation Button }
procedure TDirectoryDialog.ExitBtnClick(Sender: TObject);
begin
  ExitCode := '?';
  Close;
end;

{ << Back button }
procedure TDirectoryDialog.BackBtnClick(Sender: TObject);
begin
  If ValidOk('B') Then Begin
    ExitCode := 'B';
    Close;
  End; { If }
end;

{ Next >> button }
procedure TDirectoryDialog.NextBtnClick(Sender: TObject);
begin
  If ValidOk('N') Then Begin
    ExitCode := 'N';
    Close;
  End { If }
end;

procedure TDirectoryDialog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If (ExitCode = '?') Then Begin
    If (Application.MessageBox ('Are you sure you want to abort this installation?',
        'Install', MB_ICONQUESTION OR MB_YESNO) = IDYES) Then Begin
      ExitCode := 'X';
      CanClose := True;
    End { If }
    Else
      CanClose := False;
  End { If }
  Else
    CanClose := True;
end;

Function TDirectoryDialog.GetPath : String;
Begin
  Result := Path.Text;
End;

Procedure TDirectoryDialog.SetPath(Value : String);
Var
  Pos  : SmallInt;
  OK   : Boolean;
Begin
  Pos := Length(Value);
  OK := True;

  Repeat
    If (Not OK) Then Begin
      Repeat
        Dec (Pos);
      Until (Pos = 0) Or (Value[Pos] In ['\', ':']);
    End; { If }

    OK := True;

    If (Pos > 0) Then Begin
      Try
        DirectoryListBox1.Directory := Copy(Value, 1, Pos);
      Except
        On Exception Do OK := False;
      End;
    End; { If }
  Until OK;

  If (Pos > 0) And (Pos < Length(Value)) Then Begin
    DirectoryListBox1Change(Self);

    If (Copy(Path.Text, Length(Path.Text), 1) = '\') And (Value[Pos] = '\') Then
      Inc (Pos);

    Path.Text := Path.Text + Copy(Value, Pos, Length(Value));
  End; { If }
End;

procedure TDirectoryDialog.DirectoryListBox1Change(Sender: TObject);
begin
  Path.Text := DirectoryListBox1.Directory;
end;

Function TDirectoryDialog.ValidOk(VCode : Char) : Boolean;
Var
  TmpPath : String;
Begin
  Result := True;

  If (VCode = 'N') Then Begin
    { Check its a valid drive letter path }
    TmpPath := UpperCase(Trim(Path.Text));
    Result := (TmpPath[1] In ['C'..'Z']) And (TmpPath[2] = ':');
    If (Not Result) Then
      MessageDlg ('The path must be a valid drive and path combination', mtWarning, [mbOk], 0)
    Else
      { Check install specific details }
      Case ValidMode Of
        'c',
        'k' : Begin { Install Company }
                Result := (Trim(Path.Text) <> '');

                If Result Then Begin
                  If DirectoryExists (Trim(Path.Text)) Then Begin
                    TmpPath := Path.Text;
                    If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                      TmpPath := TmpPath + '\';

                    { Check directory doesnt already contain data }
                    Result := Not FileExists (TmpPath + 'EXCHQSS.DAT');

                    If (Not Result) Then
                      MessageDlg ('Data files already exist in this directory', mtWarning, [mbOk], 0);
                  End; { If }
                End { If }
                Else
                  MessageDlg ('The Installation Path must be set', mtWarning, [mbOk], 0);
              End;
        'I' : Begin { Install Enterprise }
                { Check for existing system }
                If DirectoryExists(Path.Text) Then Begin
                  TmpPath := Path.Text;
                  If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                    TmpPath := TmpPath + '\';

                  { Check directory doesnt already contain data }
                  If FileExists (TmpPath + 'EXCHQSS.DAT') Then Begin
                    Result := (MessageDlg ('Exchequer Enterprise Data already exists in this directory. ' +
                                           'Do you want to overwrite it?',
                                           mtConfirmation,
                                           [mbYes, mbNo],
                                           0) = mrYes);
                  End { If }
                  Else
                    { AOK - No Data }
                    Result := True;
                End { If }
                Else Begin
                  { AOK - If Path is set }
                  Result := (Trim(Path.Text) <> '');

                  If (Not Result) Then
                    MessageDlg ('The Installation Path must be set', mtWarning, [mbOk], 0);
                End; { Else }
              End;
        'T',
        'Z' : Begin { Install Toolkit DLL }
                { Next }
                Result := (Trim(Path.Text) <> '');

                If (Not Result) Then
                  MessageDlg ('The Installation Path must be set', mtWarning, [mbOk], 0);
              End; { I }
        'U' : Begin { Upgrade existing Exchequer }
                { Next }
                Result := DirectoryExists(Path.Text);

                If Result Then Begin
                  { Check directory contents }
                  TmpPath := Path.Text;
                  If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                    TmpPath := TmpPath + '\';

                    { Check for data file }
                    Result := FileExists (TmpPath + 'EXCHQSS.DAT');
                    If Result Then Begin
                      { Check we haven't got Enterprise data files }
                      Result := Not DirectoryExists (TmpPath + '\FORMS');
                      If Result Then Begin
                        { Exchequer Only - Check Currency Version is correct }
                        If (CurrMode = 'S') Then Begin
                          { Single Currency - check for DEFPF044.SYS and not DEFMC044.SYS }
                          Result := FileExists (TmpPath + 'DEFPF044.SYS') And Not FileExists (TmpPath + 'DEFMC044.SYS');

                          If (Not Result) Then
                            MessageDlg ('This directory contains a Multi Currency ' +
                                        'Exchequer and this setup program can only upgrade ' +
                                        'Single Currency versions of Exchequer', mtWarning, [mbOk], 0);
                        End { If }
                        Else Begin
                          { Multi Currency - check for DEFMC044.SYS and not DEFPF044.SYS }
                          Result := FileExists (TmpPath + 'DEFMC044.SYS') And Not FileExists (TmpPath + 'DEFPF044.SYS');

                          If (Not Result) Then
                            MessageDlg ('This directory contains a Single Currency ' +
                                        'Exchequer and this setup program can only upgrade ' +
                                        'Multi Currency versions of Exchequer', mtWarning, [mbOk], 0);
                        End; { Else }
                      End { If }
                      Else
                        MessageDlg ('This directory contains an Exchequer Enterprise System', mtWarning, [mbOk], 0);
                    End { If }
                    Else
                      MessageDlg ('This directory does not contain a valid Exchequer System', mtWarning, [mbOk], 0);
                End { If }
                Else
                  MessageDlg ('This is not a valid path', mtWarning, [mbOk], 0);
              End; { U }

        'C',        { New Company - Main System Directory }
        'R',        { Register }
        'W',        { Workstation }
        'u' : Begin { Upgrade existing Enterprise }
                { Next }
                Result := DirectoryExists(Path.Text);

                If Result Then Begin
                  { Check directory contents }
                  TmpPath := Path.Text;
                  If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                    TmpPath := TmpPath + '\';

                    { Check for data file }
                    Result := FileExists (TmpPath + 'ENTER1.EXE') And
                              FileExists (TmpPath + 'EXCHQSS.DAT') And
                              DirectoryExists (TmpPath + '\FORMS');
                    If Result Then Begin
                      { Enterprise System - Check Currency Version is correct }
                      If (CurrMode = 'S') Then Begin
                        { Single Currency - check for DEFPF044.SYS and not DEFMC044.SYS }
                        Result := FileExists (TmpPath + 'DEFPF044.SYS') And Not FileExists (TmpPath + 'DEFMC044.SYS');

                        If (Not Result) Then
                          MessageDlg ('This directory contains a Multi Currency Exchequer ' +
                                      'Enterprise and this setup program can only upgrade ' +
                                      'Single Currency versions of Exchequer Enterprise', mtWarning, [mbOk], 0);
                      End { If }
                      Else Begin
                        { Multi Currency - check for DEFMC044.SYS and not DEFPF044.SYS }
                        Result := FileExists (TmpPath + 'DEFMC044.SYS') And Not FileExists (TmpPath + 'DEFPF044.SYS');

                        If (Not Result) Then
                          MessageDlg ('This directory contains a Single Currency Exchequer ' +
                                      'Enterprise and this setup program can only upgrade ' +
                                      'Multi Currency versions of Exchequer Enterprise', mtWarning, [mbOk], 0);
                      End; { Else }
                    End { If }
                    Else
                      MessageDlg ('This directory does not contain a valid Exchequer Enterprise System', mtWarning, [mbOk], 0);

                    If Result And (ValidMode = 'C') Then Begin
                      { Check for multi-company manager }
                      Result := FileExists (TmpPath + 'MCompMan.Sys');

                      If (Not Result) Then
                        MessageDlg ('This System is not using the Multi-Company Manager', mtWarning, [mbOk], 0);
                    End; { If }
                End { If }
                Else
                  MessageDlg ('This is not a valid path', mtWarning, [mbOk], 0);
              End; { u }
        'A' : Begin { Install Connectivity Kit }
                { Check for data files }
                Result := FileExists (TmpPath + '\EXCHQSS.DAT') And
                          FileExists (TmpPath + '\TRANS\DETAILS.DAT');

                If Result Then Begin
                  { Check to see if it is a valid enterprise system }
                  Result := FileExists (TmpPath + '\ENTER1.EXE') And
                            DirectoryExists (TmpPath + '\FORMS');

                  If Result Then Begin
                    { Check DDF files aren't there }
                    Result := Not FileExists (TmpPath + '\FIELD.DDF');

                    If (Not Result) Then
                      Result := (MessageDlg ('Connectivity Kit files already exist in this directory. ' +
                                             'Do you want to overwrite them?',
                                             mtConfirmation,
                                             [mbYes, mbNo],
                                             0) = mrYes);
                  End { If }
                  Else Begin
                    { Check to see if it is a valid enterprise system }
                    Result := FileExists (TmpPath + '\EXCHEQR.EXE');

                    If Result Then Begin
                      { Check DDF files aren't there }
                      Result := (Not FileExists (TmpPath + '\ENTCOMP.DLL')) And
                                (Not FileExists (TmpPath + '\ENTEROLE.EXE')) And
                                (Not FileExists (TmpPath + '\FIELD.DDF'));

                      If (Not Result) Then
                        Result := (MessageDlg ('Connectivity Kit files already exist in this directory. ' +
                                               'Do you want to overwrite them?',
                                               mtConfirmation,
                                               [mbYes, mbNo],
                                               0) = mrYes);
                    End { If }
                    Else
                      MessageDlg ('This directory does not contain a valid Exchequer ' +
                                  'or Exchequer Enterprise System', mtWarning, [mbOk], 0);
                  End; { Else }
                End { If }
                Else
                  MessageDlg ('This directory does not contain a valid Exchequer ' +
                              'or Exchequer Enterprise System', mtWarning, [mbOk], 0);
              End;
        'B',        { Upgrade Connectivity Kit }
        'r',        { Register Connectivity Kit }
        'w' : Begin { Workstation Setup - Connectivity Kit }
                { Check for data files }
                Result := FileExists (TmpPath + '\EXCHQSS.DAT') And
                          FileExists (TmpPath + '\TRANS\DETAILS.DAT');

                If Result Then Begin
                  { Check to see if it is a valid enterprise system }
                  Result := FileExists (TmpPath + '\ENTER1.EXE') And
                            DirectoryExists (TmpPath + '\FORMS');

                  If Result Then Begin
                    { Check DDF files are there }
                    Result := FileExists (TmpPath + '\FIELD.DDF');

                    If (Not Result) Then
                      MessageDlg ('This directory does not contain any elements of the Exchequer' +
                                  ' Enterprise Connectivity Kit', mtWarning, [mbOk], 0);
                  End { If }
                  Else Begin
                    { Check to see if it is a valid enterprise system }
                    Result := FileExists (TmpPath + '\EXCHEQR.EXE');

                    If Result Then Begin
                      { Check Multi-Company Manager DLL is there }
                      Result := FileExists (TmpPath + '\ENTCOMP.DLL');

                      If (Not Result) Then
                        MessageDlg ('This directory does not contain any elements of the Exchequer' +
                                    ' Enterprise Connectivity Kit', mtWarning, [mbOk], 0);
                    End { If }
                    Else
                      MessageDlg ('This directory does not contain any elements of the Exchequer' +
                                  ' Enterprise Connectivity Kit', mtWarning, [mbOk], 0);
                  End; { Else }
                End { If }
                Else
                  MessageDlg ('This directory does not contain any elements of the Exchequer' +
                              ' Enterprise Connectivity Kit', mtWarning, [mbOk], 0);
              End;
        'X' : Begin { Crystal Reports directory }
                Result := FileExists (TmpPath + '\CRW32.EXE');

                If (Not Result) Then Begin
                  { The known EXE is not their - confirm }
                  Result := (MessageDlg ('Warning: Crystal Reports could not be found in this directory, Continue?',
                                         mtConfirmation,
                                         [mbYes, mbNo],
                                         0) = mrYes);

                End; { If }
              End;
        'K' : Begin { Connectivity Kit - Add Company - System dir }
                { Check for data files }
                Result := FileExists (TmpPath + '\EXCHEQR.EXE') And
                          FileExists (TmpPath + '\EXCHQSS.DAT') And
                          FileExists (TmpPath + '\COMPANY.DAT') And
                          FileExists (TmpPath + '\TRANS\DETAILS.DAT');

                If Result Then Begin
                  { Check it isn't an enterprise system }
                  Result := (Not FileExists (TmpPath + '\ENTER1.EXE')) And
                            (Not DirectoryExists (TmpPath + '\FORMS'));

                  If (Not Result) Then
                    MessageDlg ('This directory contains an Exchequer Enterprise System, ' +
                                'Companies cannot be added into Exchequer Enterprise Systems ' +
                                'using this Installation Program.', mtWarning, [mbOk], 0);
                End { If }
                Else
                  MessageDlg ('This directory does not contain a Multi-Company enabled Exchequer System.',
                              mtWarning, [mbOk], 0);
              End;
        'z' : Begin { Upgrade Toolkit DLL }
                Result := FileExists (TmpPath + '\ENTDLL16.DLL') Or FileExists (TmpPath + '\ENTDLL32.DLL');

                If (Not Result) Then
                  MessageDlg ('This directory does not contain the Exchequer Enterprise Toolkit DLL.',
                              mtWarning, [mbOk], 0);
              End;
        'Y' : Begin { Toolkit Configuration }
                Result := FileExists (TmpPath + '\EXCHDLL.INI') And
                          (FileExists (TmpPath + '\ENTDLL16.DLL') Or FileExists (TmpPath + '\ENTDLL32.DLL'));

                If (Not Result) Then
                  MessageDlg ('This directory does not contain the Toolkit DLL Configuration File.',
                              mtWarning, [mbOk], 0);
              End;
        'y' : Begin { Data directory for Toolkit Configuration }
                Result := FileExists (TmpPath + '\EXCHQSS.DAT') And
                          FileExists (TmpPath + '\CUST\CUSTSUPP.DAT') And
                          FileExists (TmpPath + '\TRANS\DETAILS.DAT') And
                          FileExists (TmpPath + '\TRANS\DOCUMENT.DAT') And
                         (FileExists (TmpPath + '\DEFMC044.SYS') Or
                          FileExists (TmpPath + '\DEFPF044.SYS'));

                If (Not Result) Then
                  MessageDlg ('This directory does not contain a valid set of data files.',
                              mtWarning, [mbOk], 0);
              End;
      End; { Case }
  End; { If }
End;

end.
