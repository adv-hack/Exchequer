unit setupdi2;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, FileCtrl, Buttons;

type
  TDirectoryDialog = class(TSetupTemplate)
    Path: TComboBox;
    btnFindEnt: TButton;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFindEntClick(Sender: TObject);
    procedure PathClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    OldCrntDir : String;
    FFindEnt : Byte;
    LocPosData  : Array [1..2] Of LongInt;

    Function  CheckSpace (ReqLong : LongInt) : Boolean;
    Function  GetPath : String;
    Procedure SetPath(Value : String);
    Procedure SetFindEnt(Value : Byte);

    Function  ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
    SCuD      : Boolean;
    ValidMode : Char;
    CurrMode  : Char;
    Property InstallPath : String read GetPath write SetPath;

    { 0=Off, 1=Exchequer, 2=Exchequer DOS, 3-Either }
    Property WantFindEnt : Byte Read FFindEnt Write SetFindEnt;
  end;

{var
  DirectoryDialog: TDirectoryDialog;   }

implementation

{$R *.DFM}

Uses DiskU, FindDlg3;

Const
  DS_FullSystem : LongInt = 60000000;
  DS_NewCompany : LongInt = 7000000;
  DS_ConnectKit : LongInt = 9000000;

  posEditHOfs   = 1;
  posDirHOfs    = 2;

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
  inherited;

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
    Else Begin
      { Check not installing it in the root of the drive }
      Result := (ValidMode = 'X'); { Cripple Reports directory can be anywhere }

      If (Not Result) Then
        { All non-CR paths cannot be the root of a drive - causes major errors }
        Result := (Length(TmpPath) > 3) Or ((Length(TmpPath) = 3) And (TmpPath[3] <> '\'));

      If (Not Result) Then
        MessageDlg ('The path cannot be the root directory of a drive', mtWarning, [mbOk], 0)
      Else
        { Check install specific details }
        Case ValidMode Of
          '1' : Begin { Pervasive.SQL CD Image }
                  { Validation ??? }
                End;

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
          'I' : Begin { Install Exchequer }
                  { Check for existing system }
                  If DirectoryExists(Path.Text) Then Begin
                    TmpPath := Path.Text;
                    If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                      TmpPath := TmpPath + '\';

                    { Check directory doesnt already contain data }
                    If FileExists (TmpPath + 'EXCHQSS.DAT') Then Begin
                      Result := (MessageDlg ('Exchequer Data already exists in this directory. Do you want to overwrite it?',
                                             mtConfirmation,
                                             [mbYes, mbNo],
                                             0) = mrYes);
                      GlobFlags[1] := Ord(Result);
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
          'n' : Begin { Local Exchequer dir for program files on workstation }
                  { Check for existing system }
                  If DirectoryExists(Path.Text) Then Begin
                    TmpPath := Path.Text;
                    If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                      TmpPath := TmpPath + '\';

                    { Check directory doesnt already contain data }
                    Result := Not FileExists (TmpPath + 'EXCHQSS.DAT');
                    If (Not Result) Then Begin
                      MessageDlg ('This directory contains an Exchequer System and cannot be overwritten', mtWarning, [mbOk], 0);
                    End { If }
                    Else Begin
                      { No data - check for Exchequer .EXE's }
                      Result := Not FileExists (TmpPath + 'ENTER1.EXE');
                      If (Not Result) Then Begin
                        Result := (MessageDlg ('Exchequer Program Files already exists in this directory. Do you want to overwrite them?',
                                               mtConfirmation,
                                               [mbYes, mbNo],
                                               0) = mrYes);
                        GlobFlags[1] := Ord(Result);
                      End; { If (Not Result) }
                    End; { Else }
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
                        { Check we haven't got Exchequer data files }
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
                          MessageDlg ('This directory contains an Exchequer System', mtWarning, [mbOk], 0);
                      End { If }
                      Else
                        MessageDlg ('This directory does not contain a valid Exchequer System', mtWarning, [mbOk], 0);
                  End { If }
                  Else
                    MessageDlg ('This is not a valid path', mtWarning, [mbOk], 0);
                End; { U }

          'C',        { New Company - Main System Directory }
          'N',        { Workstation Installation - Network Directory }
          'R',        { Register }
          'W',        { Workstation }
          'u' : Begin { Upgrade existing Exchequer }
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
                      { Exchequer System - Check Currency Version is correct }
                      If (CurrMode = 'S') Then Begin
                        { Single Currency - check for DEFPF044.SYS and not DEFMC044.SYS }
                        Result := FileExists (TmpPath + 'DEFPF044.SYS') And Not FileExists (TmpPath + 'DEFMC044.SYS');

                        If (Not Result) Then
                          MessageDlg ('This directory contains a Multi Currency Exchequer ' +
                                      'and this setup program can only upgrade ' +
                                      'Single Currency versions of Exchequer', mtWarning, [mbOk], 0);
                      End { If }
                      Else Begin
                        { Multi Currency - check for DEFMC044.SYS and not DEFPF044.SYS }
                        Result := FileExists (TmpPath + 'DEFMC044.SYS') And Not FileExists (TmpPath + 'DEFPF044.SYS');

                        If (Not Result) Then
                          MessageDlg ('This directory contains a Single Currency Exchequer ' +
                                      'and this setup program can only upgrade ' +
                                      'Multi Currency versions of Exchequer', mtWarning, [mbOk], 0);
                      End; { Else }
                    End { If }
                    Else
                      MessageDlg ('This directory does not contain a valid Exchequer System', mtWarning, [mbOk], 0);

                    (* HM 14/08/98: Removed chack as install will now install it if required
                    If Result And (ValidMode = 'C') Then Begin
                      { Check for multi-company manager }
                      Result := FileExists (TmpPath + 'MCompMan.Sys');

                      If (Not Result) Then
                        MessageDlg ('This System is not using the Multi-Company Manager', mtWarning, [mbOk], 0);
                    End; { If }
                    *)

                    If Result And (ValidMode = 'N') Then Begin
                      { Check for Replication List, ENTWREPL.LST, in network dir }
                      Result := FileExists (TmpPath + 'EntWRepl.Lst');

                      If (Not Result) Then
                        MessageDlg ('This System does not have the replication files installed', mtWarning, [mbOk], 0);
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
                    { Check to see if it is a valid Exchequer system }
                    Result := FileExists (TmpPath + '\ENTER1.EXE') And
                              DirectoryExists (TmpPath + '\FORMS');

                    If Result Then Begin
                      { Check DDF files aren't there }
                      Result := Not FileExists (TmpPath + '\FIELD.DDF');

                      If (Not Result) Then
                        Result := (MessageDlg ('Connectivity Kit files already exist in this directory. Do you want to overwrite them?',
                                               mtConfirmation,
                                               [mbYes, mbNo],
                                               0) = mrYes);
                    End { If }
                    Else Begin
                      { Check to see if it is a valid Exchequer system }
                      Result := FileExists (TmpPath + '\EXCHEQR.EXE');

                      If Result Then Begin
                        { Check DDF files aren't there }
                        Result := (Not FileExists (TmpPath + '\ENTCOMP.DLL')) And
                                  (Not FileExists (TmpPath + '\ENTEROLE.EXE')) And
                                  (Not FileExists (TmpPath + '\FIELD.DDF'));

                        If (Not Result) Then
                          Result := (MessageDlg ('Connectivity Kit files already exist in this directory. Do you want to overwrite them?',
                                                 mtConfirmation,
                                                 [mbYes, mbNo],
                                                 0) = mrYes);
                      End { If }
                      Else
                        MessageDlg ('This directory does not contain a valid Exchequer System', mtWarning, [mbOk], 0);
                    End; { Else }
                  End { If }
                  Else
                    MessageDlg ('This directory does not contain a valid Exchequer System', mtWarning, [mbOk], 0);
                End;
          'B',        { Upgrade Connectivity Kit }
          'r',        { Register Connectivity Kit }
          'w' : Begin { Workstation Setup - Connectivity Kit }
                  { Check for data files }
                  Result := FileExists (TmpPath + '\EXCHQSS.DAT') And
                            FileExists (TmpPath + '\TRANS\DETAILS.DAT');

                  If Result Then Begin
                    { Check to see if it is a valid Exchequer system }
                    Result := FileExists (TmpPath + '\ENTER1.EXE') And
                              DirectoryExists (TmpPath + '\FORMS');

                    If Result Then Begin
                      { Check DDF files are there }
                      Result := FileExists (TmpPath + '\FIELD.DDF');

                      If (Not Result) Then
                        MessageDlg ('This directory does not contain any elements of the Exchequer' +
                                    ' Connectivity Kit', mtWarning, [mbOk], 0);
                    End { If }
                    Else Begin
                      { Check to see if it is a valid Exchequer system }
                      Result := FileExists (TmpPath + '\EXCHEQR.EXE');

                      If Result Then Begin
                        { Check Multi-Company Manager DLL is there }
                        Result := FileExists (TmpPath + '\ENTCOMP.DLL');

                        If (Not Result) Then
                          MessageDlg ('This directory does not contain any elements of the Exchequer' +
                                      ' Connectivity Kit', mtWarning, [mbOk], 0);
                      End { If }
                      Else
                        MessageDlg ('This directory does not contain any elements of the Exchequer' +
                                    ' Connectivity Kit', mtWarning, [mbOk], 0);
                    End; { Else }
                  End { If }
                  Else
                    MessageDlg ('This directory does not contain any elements of the Exchequer' +
                                ' Connectivity Kit', mtWarning, [mbOk], 0);
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
                    { Check it isn't an Exchequer system }
                    Result := (Not FileExists (TmpPath + '\ENTER1.EXE')) And
                              (Not DirectoryExists (TmpPath + '\FORMS'));

                    If (Not Result) Then
                      MessageDlg ('This directory contains an Exchequer System, ' +
                                  'Companies cannot be added into Exchequer Systems ' +
                                  'using this Installation Program.', mtWarning, [mbOk], 0);
                  End { If }
                  Else
                    MessageDlg ('This directory does not contain a Multi-Company enabled Exchequer System.',
                                mtWarning, [mbOk], 0);
                End;
          'z' : Begin { Upgrade Toolkit DLL }
                  Result := FileExists (TmpPath + '\ENTDLL16.DLL') Or FileExists (TmpPath + '\ENTDLL32.DLL');

                  If (Not Result) Then
                    MessageDlg ('This directory does not contain the Exchequer Toolkit DLL.',
                                mtWarning, [mbOk], 0);
                End;
          'Y' : Begin
                  Result := FileExists (TmpPath + '\EXCHDLL.INI');

                  If (Not Result) Then
                    MessageDlg ('This directory does not contain the Toolkit DLL Configuration File.',
                                mtWarning, [mbOk], 0);
                End;
          'V',        { Compass - Exchequer Installation }
          'v' : Begin { Customisation - Exchequer Installation }
                  { Next }
                  Result := DirectoryExists(Path.Text);

                  If Result Then Begin
                    { Check directory contents }
                    TmpPath := Path.Text;
                    If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                      TmpPath := TmpPath + '\';

                    { Check for files }
                    If (ValidMode = 'V') Then
                      { Compass - Exchequer Installation }
                      Result := FileExists (TmpPath + 'EXCHQSS.DAT')
                    Else
                      { Customisation - Exchequer Installation }
                      Result := FileExists (TmpPath + 'ENTER1.EXE') And
                                FileExists (TmpPath + 'EXCHQSS.DAT') And
                                DirectoryExists (TmpPath + '\FORMS');

                    If Not Result Then
                      MessageDlg ('This directory does not contain a valid Exchequer System', mtWarning, [mbOk], 0);
                  End { If }
                  Else
                    MessageDlg ('This is not a valid path', mtWarning, [mbOk], 0);
                End;

          '2' : Begin { Single CD - Upgrade existing Exchequer DOS/Exchequer }
                  { Next }
                  Result := DirectoryExists(Path.Text);

                  If Result Then Begin
                    { Check directory contents }
                    TmpPath := Path.Text;
                    If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                      TmpPath := TmpPath + '\';

                    { Check for data file }
                    Result := (FileExists (TmpPath + 'ENTER1.EXE') Or FileExists (TmpPath + 'REX.BAT')) And
                              FileExists (TmpPath + 'EXCHQSS.DAT');

                    If Result Then Begin
                      { Exchequer System - Check for licencing files }
                      Result := FileExists (TmpPath + 'ENTRPRSE.DAT') { Or FileExists (TmpPath + 'ENTSCD.DAT')};
                      If Result Then Begin
                        { Check Currency Version is correct }
                        If (CurrMode = 'S') Then Begin
                          { Single Currency - check for DEFPF044.SYS and not DEFMC044.SYS }
                          Result := FileExists (TmpPath + 'DEFPF044.SYS') And Not FileExists (TmpPath + 'DEFMC044.SYS');

                          If (Not Result) Then
                            MessageDlg ('This directory contains a Multi Currency Exchequer ' +
                                        'and this setup program can only upgrade ' +
                                        'Single Currency versions of Exchequer', mtWarning, [mbOk], 0);
                        End { If }
                        Else Begin
                          { Multi Currency - check for DEFMC044.SYS and not DEFPF044.SYS }
                          Result := FileExists (TmpPath + 'DEFMC044.SYS') And Not FileExists (TmpPath + 'DEFPF044.SYS');

                          If (Not Result) Then
                            MessageDlg ('This directory contains a Single Currency Exchequer ' +
                                        'and this setup program can only upgrade ' +
                                        'Multi Currency versions of Exchequer', mtWarning, [mbOk], 0);
                        End; { Else }
                      End { If }
                      Else Begin
                        { No Single-CD licences found }
                        MessageDlg ('This directory does not contain a valid Exchequer Licence. ' +
                                    'Check you have run the correct conversion programs.', mtWarning, [mbOk], 0);
                      End; { Else }
                    End { If }
                    Else
                      MessageDlg ('This directory does not contain a valid Exchequer System', mtWarning, [mbOk], 0);
                  End { If }
                  Else
                    MessageDlg ('This is not a valid path', mtWarning, [mbOk], 0);
                End; { u }
        End; { Case }
    End; { Else }

    If Result Then Begin
      { Check disk space }
      If (ValidMode In ['I', 'U']) Then
        { Check for full system }
        Result := CheckSpace (DS_FullSystem);

      If (ValidMode In ['c', 'k']) Then
        { Check for new company }
        Result := CheckSpace (DS_NewCompany);

      If (ValidMode In ['A']) Then
        { Check for Connectivity Kit }
        Result := CheckSpace (DS_ConnectKit);
    End; { If }
  End; { If }
End;

Function TDirectoryDialog.CheckSpace (ReqLong : LongInt) : Boolean;
Var
  fDriveNo          : Smallint;
  FreeSpace, ReqDbl : Double;
Begin
  Result := False;
  ReqDbl := ReqLong;

  { Calculate drive number }
  fDriveNo:=Ord(UPCase(Path.Text[1]))-64;

  { get free space on drive }
  FreeSpace := sbsDiskFree(fDriveNo);

  { Check it }
  Result := (FreeSpace > ReqDbl) Or (FreeSpace <= 0);

  If (Not Result) Then Begin
    { Not enough disk space }
    ReqLong := Trunc(ReqDbl-FreeSpace) Div 1024;
    Result := (MessageDlg ('There is not enough disk space free to install the ' +
                           'files in the drive you specified. Another ' + IntToStr(ReqLong) + 'k is required.' +
                           #10#13#10#13 +
                           'Do you want to continue anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes);
  End; { If }
End;

procedure TDirectoryDialog.FormCreate(Sender: TObject);
begin
  inherited;

  { Save Current Directory }
  OldCrntDir := GetCurrentDir;
  ValidMode := #0;
  CurrMode  := #0;
  SCuD := False;   { Default to non Single-CD }

  WantFindEnt := 0;

  { Generate postion data for dynamic resizing }
  LocPosData[posEditHOfs] := Self.Height - Path.Top;
  LocPosData[posDirHOfs]  := Self.Height - DirectoryListBox1.Height;
end;

procedure TDirectoryDialog.FormDestroy(Sender: TObject);
begin
  inherited;

  { Restore Current Directory }
  SetCurrentDir(OldCrntDir);
end;

Procedure TDirectoryDialog.SetFindEnt(Value : Byte);
Begin { SetFindEnt }
  FFindEnt := Value;
  btnFindEnt.Visible := (Value > 0);

  If (btnFindEnt.Visible) Then Begin
    { Convert combo to drop-down type }
    Path.Style := csDropDown;
  End; { If }
End;  { SetFindEnt }

procedure TDirectoryDialog.btnFindEntClick(Sender: TObject);
var
  frmFindDlg : TfrmFindDlg;
  I          : SmallInt;
  TmpStr     : ShortString;
begin
  inherited;

  If (FFindEnt > 0) And btnFindEnt.Visible Then Begin
    { Setup dialog }
    frmFindDlg := TfrmFindDlg.Create(Self);
    Try
      //frmFindDlg.DriveComboBox1.Drive := DriveComboBox1.Drive;
      frmFindDlg.FindMode := FFindEnt;
      frmFindDlg.CurrMode := Self.CurrMode;
      frmFindDlg.PathList := Path;

      Case FFindEnt Of
        1 : Begin { Find Exchequer }
              frmFindDlg.Title := 'Find Exchequer Directory';
            End;
        2 : Begin { Find Exchequer DOS }
              frmFindDlg.Title := 'Find Exchequer DOS Directory';
            End;
        3 : Begin { Find Exchequer DOS OR Exchequer Win}
              frmFindDlg.Title := 'Find System Directory';
            End;
      End; { Case }

      frmFindDlg.ShowModal;

      { run through list deleting any duplicate paths }
      If (Path.Items.Count > 1) Then Begin
        TmpStr := Path.Text;

        I := 1;
        While I <= Pred(Path.Items.Count) Do Begin
          If (Path.Items[I] = Path.Items[Pred(I)]) Then Begin
            { Delete duplicate item }
            Path.Items.Delete(I);
          End { If }
          Else Begin
            { AOK - move to next }
            Inc (I);
          End; { Else }
        End; { While }

        Path.Text := TmpStr;
      End; { If }

      If (frmFindDlg.ExitCode = 'N') Then Begin
        { A path was selected - setup drive/dir to look at it }
        Path.Text := frmFindDlg.lstDirs.Items[frmFindDlg.lstDirs.ItemIndex];
        PathClick(Sender);
      End; { If }
    Finally
      frmFindDlg.Free;
    End;
  End; { If }
end;

procedure TDirectoryDialog.PathClick(Sender: TObject);
begin
  inherited;

  InstallPath := Path.Text;
end;

procedure TDirectoryDialog.FormResize(Sender: TObject);
begin
  inherited;

  Path.Top := Self.Height - LocPosData[posEditHOfs];
  DirectoryListBox1.Height := Self.Height - LocPosData[posDirHOfs];
  btnFindEnt.Top := BackBtn.Top;

end;

end.
