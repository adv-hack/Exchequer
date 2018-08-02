unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, EnterToTab;

type
  TfrmMain = class(TForm)
    btnStartTest: TButton;
    shBanner: TShape;
    lblBanner: TLabel;
    Label1: TLabel;
    edtComputerDesc: TEdit;
    Label2: TLabel;
    EnterToTab1: TEnterToTab;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblProgress: TLabel;
    btnLeagueTable: TButton;
    Label9: TLabel;
    edtTestDirectory: TEdit;
    procedure btnStartTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLeagueTableClick(Sender: TObject);
  private
    { Private declarations }
    FTempDir : ShortString;
    Procedure WMSysCommand(Var Message : TMessage); Message WM_SysCommand;
    Function WriteTestFile : Int64;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

Uses Math, DateUtils, StrUtil, APIUtil, History, LeagueTableF;

Const
  CM_About   = $F0;

//=========================================================================

procedure TfrmMain.FormCreate(Sender: TObject);
Var
  SysMenuH : HWnd;
  sDrive : ANSIString;
  DriveType : SmallInt;
begin
  Caption := Application.Title;

  SysMenuH:=GetSystemMenu(Handle,False);
  AppendMenu(SysMenuH,MF_SEPARATOR,0,'');
  AppendMenu(SysMenuH,MF_String,CM_About,'About...');

  edtComputerDesc.Text := WinGetComputerName;

  // Disable description field if running from CD/DVD
  sDrive := ExtractFileDrive(Application.ExeName);
  DriveType := GetDriveType(PChar(sdrive));
  edtComputerDesc.Enabled := (DriveType <> DRIVE_CDROM);
  btnLeagueTable.Enabled := edtComputerDesc.Enabled;

  edtTestDirectory.Text := WinGetWindowsTempDir;
end;

//-------------------------------------------------------------------------

Procedure TfrmMain.WMSysCommand(Var Message : TMessage);
Var
  MsgText : ANSIString;
Begin // WMSysCommand
  If (Message.WParam = CM_About) Then
  Begin
    MsgText := Application.Title + '  (' + PerfTestVersion + ')'#13 + GetCopyrightMessage;
    Application.MessageBox (PCHAR(MsgText), 'About...', 0);
    Inherited
  End // If (Message.WParam = CM_About)
  Else
    Inherited;
End; // WMSysCommand

//-------------------------------------------------------------------------

procedure TfrmMain.btnStartTestClick(Sender: TObject);
Const
  NoTests = 5;
Var
  TestResults : Array[1..NoTests] Of Int64;
  Total : Int64;
  I : Byte;
  AverageTime, FreeSpace : Int64;
begin
  // Get Windows\Temp directory
  //FTempDir := WinGetWindowsTempDir;
  FTempDir := IncludeTrailingPathDelimiter(edtTestDirectory.Text);
  If DirectoryExists(FTempDir) Then
  Begin
    // Check for disk space
    FreeSpace := DiskFree(Ord(FTempDir[1]) - Ord('A') + 1);  // A: = 1, etc...
    If (FreeSpace > 204800000) Then
    Begin
      Try
        btnStartTest.Enabled := False;
        btnLeagueTable.Enabled := False;

        Total := 0;
        For I := Low(TestResults) To High(TestResults) Do
        Begin
          lblProgress.Caption := 'Running test ' + IntToStr(I) + ' of ' + IntToStr(NoTests);
          Application.ProcessMessages;

          TestResults[I] := WriteTestFile;
          Total := Total + TestResults[I];
        End; // For I

        AverageTime := Total Div NoTests;
        UpdateLeagueTable (edtComputerDesc.Text, AverageTime);
        ShowMessage (Format('This computer''s average test time is %0.3f seconds', [RoundTo(AverageTime / 1000,-3)]));

        If edtComputerDesc.Enabled Then
        Begin
          btnLeagueTableClick(Self);
        End; // If edtComputerDesc.Enabled
      Finally
        btnStartTest.Enabled := True;
        btnLeagueTable.Enabled := edtComputerDesc.Enabled;
        lblProgress.Caption := '';
      End; // Try..Finally
    End // If (FreeSpace > 204800000)
    Else
      MessageDlg ('There is not enough free disk space to perform the test, at least 200Mb is required to continue', mtError, [mbOK], 0);
  End // If DirectoryExists(FTempDir)
  Else
    MessageDlg ('The specified directory does not exist', mtError, [mbOK], 0);
end;

//-------------------------------------------------------------------------

Function TfrmMain.WriteTestFile : Int64;
Var
  OutF : TFileStream;
  StartTime, EndTime : TDateTime;
  Buffer : Array[1..200] Of Char;
  I, Res : LongInt;
  lpPathName, lpPrefixString, lpTempFileName : ANSIString;
  uUnique : UInt;
begin
  // generate temporary filename
  lpPathName := FTempDir;
  lpPrefixString := '~ex';
  uUnique := 0;
  lpTempFileName := StringOfChar(' ', 255);
  Res := GetTempFileName(PCHAR(lpPathName), PCHAR(lpPrefixString), uUnique, PCHAR(lpTempFileName));
  If (Res <> 0) Then
  Begin
    lpTempFileName := Trim(lpTempFileName);

    For I := Low(Buffer) To High(Buffer) Do
      Buffer[I] := 'Z';

    StartTime := Now;
    OutF := TFileStream.Create(lpTempFileName, fmCreate Or fmShareExclusive);
    Try
      For I := 1 To 500000 Do
      Begin
        OutF.Write (Buffer, SizeOf(Buffer));
      End; // For I
    Finally
      OutF.Free;
    End; // Try..Finally
    EndTime := Now;

    SysUtils.DeleteFile(lpTempFileName);

    Result := MilliSecondsBetween(StartTime, EndTime);
  End // If (Res <> 0)
  Else
    Raise Exception.Create ('Unable to generate temporary filename');
end;

//-------------------------------------------------------------------------

procedure TfrmMain.btnLeagueTableClick(Sender: TObject);
begin
  DisplayLeagueTable(Self, edtComputerDesc.Text);
end;

//=========================================================================

end.
