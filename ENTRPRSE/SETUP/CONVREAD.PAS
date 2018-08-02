unit ConvRead;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Setupbas, ExtCtrls, StdCtrls, BorBtns, TEditVal, FileCtrl;

type
  TfrmReady = class(TSetupTemplate)
    Label83: Label8;
    lblCnvDir: Label8;
    panBackup: TPanel;
    Label811: Label8;
    chkBackup: TBorCheck;
    panUsers: TPanel;
    Label813: Label8;
    chkUsers: TBorCheck;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DoCheckyChecky(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure panBackupClick(Sender: TObject);
    procedure panUsersClick(Sender: TObject);
  private
    { Private declarations }
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

procedure TfrmReady.FormCreate(Sender: TObject);
begin
  inherited;

  ExitMsg := 3;

  DoCheckyChecky(Sender);
end;

procedure TfrmReady.DoCheckyChecky(Sender: TObject);
begin
  inherited;

  NextBtn.Enabled := chkBackup.Checked And chkUsers.Checked;
end;

procedure TfrmReady.NextBtnClick(Sender: TObject);
begin
  If NextBtn.Enabled Then Begin
    inherited;

  End; { If NextBtn.Enabled }
end;

procedure TfrmReady.panBackupClick(Sender: TObject);
begin
  inherited;

  chkBackup.Checked := Not chkBackup.Checked;
  DoCheckyChecky(Sender);
end;

procedure TfrmReady.panUsersClick(Sender: TObject);
begin
  inherited;

  chkUsers.Checked := Not chkUsers.Checked;
  DoCheckyChecky(Sender);
end;

Function TfrmReady.ValidOk(VCode : Char) : Boolean;
Var
  ConvDir : String;


  { Calculates the current time in seconds }
  Function CurrentTime : Double;
  Var
    wHour, wMin, wSec, wMSec  : Word;
    lHour, lMin, lSec, lMSec : LongInt;
  begin
    Result := 0;

    { Get current time }
    DecodeTime(Now, wHour, wMin, wSec, wMSec);

    { Copy fields into longs to force compiler to work in LongInt mode  }
    { otherwise you can get Range Check Errors as it works in Word mode }
    lHour := wHour;
    lMin  := wMin;
    lSec  := wSec;
    lMSec := wMSec;

    { Calculate number of seconds since midbnight }
    Result := (lSec + (60 * (lMin + (lHour * 60)))) + (lMSec * 0.001);
  End;


  { Returns the Time in seconds since Windows was started }
  { NOTE: Wraps to 0 after approx 49.7 days (as if any    }
  { windows system has run that long without crashing!!!) }
  Procedure WaitForSecs (Const Secs : Double);
  Var
    stTime, fiTime, cuTime : Double;
  Begin
    Try
      { Get start time - this is used to detect the time wrapping around at midnight }
      stTime := CurrentTime;

      { Calculate end time }
      fiTime := stTime + Secs;

      Repeat
        { Let other apps do something }
        Application.ProcessMessages;

        { Get time again }
        cuTime := CurrentTime;

        { Exit loop if time has wrapped around or wait period has expired }
      Until (cuTime < stTime) Or (cuTime > fiTime);
    Except
      On Ex: Exception Do
        MessageDlg ('The following exception occurred in WaitForSecs: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    End;
  End;

  { Renames a File and checks it was deleted }
  Function RenameAndCheckFile (Const FilePath, OrigFile, RenFile : String) : Boolean;
  Var
    Res : Integer;
  Begin { RenameAndCheckFile }
    Result := True;

    If DirectoryExists (FilePath) And FileExists (FilePath + OrigFile) Then Begin
      { Delete any pre-existing rename file }
      If FileExists (FilePath + RenFile) Then Begin
        { Remove any potential read-only attributes }
        Res := FileSetAttr (FilePath + RenFile, 0);
        If (Res <> 0) Then
          ShowMessage ('Error removing Read-Only Attributes ' + FilePath + RenFile + ': ' + IntToStr(Res));

        { Delete file }
        Result := DeleteFile(FilePath + RenFile);

        If Result Then Begin
          { Wait for file deletion to finish }
          WaitForSecs (1);
        End; { If Result }
      End; { If FileExists (FilePath + RenFile) }

      If Result Then Begin
        { Remove any potential read-only attributes }
        Res := FileSetAttr (FilePath + OrigFile, 0);
        If (Res <> 0) Then
          ShowMessage ('Error removing Read-Only Attributes ' + FilePath + OrigFile + ': ' + IntToStr(Res));

        { Rename the target file }
        Result := RenameFile(FilePath + OrigFile, FilePath + RenFile);

        If Result Then Begin
          { Wait for file rename to finish }
          WaitForSecs (1);

          { check file not there - who's paraniod }
          Result := Not FileExists(FilePath + OrigFile);
          If (Not Result) Then Begin
            { Rename failed - original file still exists }
            MessageDlg ('Error renaming ' + OrigFile + ' in ' + FilePath + '. Please manually ' +
                        'rename it to ' + RenFile + ' and retry the conversion.', mtError, [mbOk], 0);
          End; { If (Not Result) }
        End { If Result }
        Else Begin
          { Rename failed }
          MessageDlg ('Error renaming ' + OrigFile + ' in ' + FilePath + '. Please manually ' +
                      'rename it to ' + RenFile + ' and retry the conversion.', mtError, [mbOk], 0);
        End; { Else }
      End { If Result }
      Else Begin
        { Cannot delete old rename file }
        MessageDlg ('Error deleting  ' + RenFile + ' in ' + FilePath + '. Please manually ' +
                    'delete it and retry the conversion.', mtError, [mbOk], 0);
      End; { Else }
    End; { If FileExists (FilePath) }
  End; { RenameAndCheckFile }


  Procedure ProcessDelList(Const ConvDir : ShortString);
  Var
    FileList                    : TStringList;
    DelFileN, DelFileP, BaseDir : ShortString;
  Begin { ProcessDelList }
    Try
      BaseDir  := ExtractFilePath(Application.ExeName);
      DelFileP := BaseDir + 'EXDELLST.DAT';

      If FileExists (DelFileP) Then Begin
        FileList := TStringList.Create;
        Try
          FileList.LoadFromFile (DelFileP);

          While (FileList.Count > 0) Do Begin
            DelFileN := Trim(UpperCase(FileList.Strings[0]));
            DelFileP := ConvDir + DelFileN;

            If FileExists (DelFileP) Then
              // HM 11/04/00 Modifed to allow Auto-Upgrades to work when converting from v4.30c to v4.31
              If (DelFileN <> 'ENTER1.EXE') Then Begin
                { Delete file }
                DeleteFile(DelFileP);
              End; { If FileExists }

            FileList.Delete(0);
          End; { While (FileList.Count > 0) }
        Finally
          FileList.Destroy;
        End;
      End; { If FileExists (DelFileN) }
    Except
      On Ex:Exception Do
        MessageDlg ('The following error occurred whilst preparing the conversion directory:' + #13#13 +
                    '"' + Ex.Message + '"', mtError, [mbOk], 0);
    End;
  End; { ProcessDelList }


Begin { ValidOK }
  Result := True;

  If (VCode = 'N') Then Begin
    Screen.Cursor := crHourGlass;
    Try
      ConvDir := Trim(lblCnvDir.Caption);
      Result := (Length(ConvDir) > 0);

      If Result Then Begin
        If Not (ConvDir[Length(ConvDir)] In [':', '\']) Then
          ConvDir := ConvDir + '\';

        Result := DirectoryExists(ConvDir);
        If Result Then Begin
          // HM 11/04/00 Modifed to allow Auto-Upgrades to work when converting from v4.30c to v4.31
          {Result := RenameAndCheckFile(ConvDir, 'Enter1.Exe', 'Enter1.Exo');}
          {If Result Then} Result := RenameAndCheckFile(ConvDir, 'EntComp.Dll', 'EntComp.Dlo');
          If Result Then Result := RenameAndCheckFile(ConvDir, 'SbsForm.Dll', 'SbsForm.Dlo');
          If Result Then Result := RenameAndCheckFile(ConvDir, 'Excheqr.Exe', 'Excheqr.Exo');

          If Result Then Begin
            { Process Delete List }
            ProcessDelList(ConvDir);
          End; { If }
        End { If Result }
        Else Begin
          { Directory Doesn't Exist }
          MessageDlg ('The conversion path must exist', mtError, [mbOk], 0);
        End; { Else }
      End { If Result }
      Else Begin
        { Path not set }
        MessageDlg ('The conversion path must be set', mtError, [mbOk], 0);
      End; { Else }
    Finally
      Screen.Cursor := crDefault;
    End;
  End; { If (VCode = 'N') }
End; { ValidOK }

end.
