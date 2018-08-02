unit smtpmain;

interface

uses
  SysUtils, WinProcs, WinTypes, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, ExtCtrls, StdCtrls, SMTPSu,IniFiles, mssmtp,
  Menus, ShellAPI, Mssocket, msDef, msmsg, ComCtrls;

type
  TSMTPForm = class(TForm)
    ToolBar: TPanel;
    SendButton: TSpeedButton;
    SetupButton: TSpeedButton;
    ExitButton: TSpeedButton;
    SendInfoPanel: TPanel;
    ToEdit: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    SubjectEdit: TEdit;
    CancelButton: TSpeedButton;
    BodyMemo: TMemo;
    AttachButton: TSpeedButton;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Send1: TMenuItem;
    Cancel1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Attach1: TMenuItem;
    Setup1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel2: TPanel;
    ListBox1: TListBox;
    msSMTPClient1: TmsSMTPClient;
    msMessage1: TmsMessage;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    procedure ExitButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SetupButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AttachButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure About1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure msSMTPClient1Connecting(Sender: TObject);
    procedure msSMTPClient1Connected(Sender: TObject);
    procedure msSMTPClient1Disconnected(Sender: TObject);
    procedure msSMTPClient1Preparing(Sender: TObject);
    procedure msSMTPClient1Sending(Sender: TObject);
    procedure msSMTPClient1Sent(Sender: TObject);
    procedure msSMTPClient1TransferProgress(Sender: TObject; Perc,
      ByteCount, LineCount: Longint);
  private
    { Private declarations }
    IniName : string;
    procedure EnableControls;
    procedure DisableControls;
  protected
    procedure WMDropFiles(var Msg : TMessage); message WM_DROPFILES;
  public
    { Public declarations }
  end;

var
  SMTPForm: TSMTPForm;

implementation

uses msabout;

{$R *.DFM}

procedure TSMTPForm.EnableControls;
var
  i : Integer;
  SB : TSpeedButton;
begin
  for i:=0 to ToolBar.ControlCount-1 do
  if ToolBar.Controls[i] is TSpeedButton then
  begin
    SB:=ToolBar.Controls[i] as TSpeedButton;
    SB.Enabled:=SB.Tag<>1;
  end;
  ListBox1.Enabled:=true;
  Send1.Enabled:=true;
  Cancel1.Enabled:=false;
  Attach1.Enabled:=true;
  Exit1.Enabled:=true;
  Setup1.Enabled:=true;
  Help1.Enabled:=true;
  SendInfoPanel.Enabled:=true;
  BodyMemo.Enabled:=true;
  Cursor:=crDefault;
  ListBox1.Cursor:=crDefault;
end;

procedure TSMTPForm.DisableControls;
var
  i : Integer;
  SB : TSpeedButton;
begin
  for i:=0 to ToolBar.ControlCount-1 do
  if ToolBar.Controls[i] is TSpeedButton then
  begin
    SB:=ToolBar.Controls[i] as TSpeedButton;
    SB.Enabled:=SB.Tag=1;
  end;
  ListBox1.Enabled:=false;
  Send1.Enabled:=false;
  Cancel1.Enabled:=true;
  Attach1.Enabled:=false;
  Exit1.Enabled:=false;
  Setup1.Enabled:=false;
  Help1.Enabled:=false;
  SendInfoPanel.Enabled:=false;
  BodyMemo.Enabled:=false;
  Cursor:=crHourGlass;
  ListBox1.Cursor:=crHourGlass;
end;

procedure TSMTPForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TSMTPForm.SendButtonClick(Sender: TObject);
var
  i : Integer;
begin
  msMessage1.Recipients.Clear;
  msMessage1.Recipients.AddAddress(ToEdit.Text,'');
  msMessage1.Subject:=SubjectEdit.Text;
  msMessage1.Body:=BodyMemo.Lines;
  msMessage1.Attachments.Clear;
  for i:=0 to ListBox1.Items.Count-1 do
    msMessage1.Attachments.AddFile(ListBox1.Items[i]);
  DisableControls;
  try
    msSMTPClient1.Send;
  finally
    EnableControls;
  end;
end;

procedure TSMTPForm.CancelButtonClick(Sender: TObject);
begin
  msSMTPClient1.Cancel;
end;

procedure TSMTPForm.SetupButtonClick(Sender: TObject);
begin
  with TSetupDlg.Create(Self) do
  try
    ServerEdit.Text:=msSMTPClient1.Host;
    UserAddressEdit.Text:=msMessage1.Sender.Address;
    UserNameEdit.Text:=msMessage1.Sender.Name;
    LogFileNameEdit.Text:=msSMTPClient1.LogFileName;
    ShowModal;
    if ModalResult=mrOk then
    begin
      msSMTPClient1.Host:=ServerEdit.Text;
      msMessage1.Sender.Address:=UserAddressEdit.Text;
      msMessage1.Sender.Name:=UserNameEdit.Text;
      msSMTPClient1.LogFileName:=LogFileNameEdit.Text;
    end;
  finally
    free;
  end;
end;

procedure TSMTPForm.FormCreate(Sender: TObject);
begin
  IniName:=ChangeFileExt(Application.ExeName,'.ini');
  with TIniFile.Create(IniName) do
  try
    msSMTPClient1.Host:=ReadString('Setup','Host','');
    msMessage1.Sender.Address:=ReadString('Setup','EMail Address','');
    msMessage1.Sender.Name:=ReadString('Setup','Name','');
    msSMTPClient1.LogFileName:=ReadString('Setup','Log File','');
  finally
    free;
  end;
//  msSMTPClient1.SleepTime:=200;
  DragAcceptFiles(Handle,true);
end;

procedure TSMTPForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with TIniFile.Create(IniName) do
  try
    WriteString('Setup','Host',msSMTPClient1.Host);
    WriteString('Setup','EMail Address',msMessage1.Sender.Address);
    WriteString('Setup','Name',msMessage1.Sender.Name);
    WriteString('Setup','Log File',msSMTPClient1.LogFileName);
  finally
    free;
  end;
  msSMTPClient1.SaveLogFile;
end;

procedure TSMTPForm.AttachButtonClick(Sender: TObject);
var
  i : Integer;
begin
  with TOpenDialog.Create(Self) do
  try
    Filter:='All Files (*.*)|*.*';
    Options:=[ofHideReadOnly,ofAllowMultiSelect];
    if Execute then
    begin
      for i:=0 to Files.Count-1 do
        ListBox1.Items.Add(Files[i]);
    end;
  finally
    Free;
  end;
end;

procedure TSMTPForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not SendInfoPanel.Enabled then
  begin
    MessageDlg('Transfer in Progress.  Click Cancel button first.',
               mtError,[mbOk],0);
    CanClose:=false;
  end
  else
    CanClose:=true;
end;

procedure TSMTPForm.About1Click(Sender: TObject);
begin
  with TAboutDlg.Create(Self) do
  try
    ProgramName.Caption:='TmsSMTPClient Component Demo';
    ShowModal;
  finally
    Free;
  end;
end;

procedure TSMTPForm.FormResize(Sender: TObject);
begin
  Bevel1.Width:=Width;
  Bevel2.Width:=Width;
end;

procedure TSMTPForm.WMDropFiles(var Msg : TMessage);
var
  FileName : PChar;
  Drop : THandle;
begin
  Drop:=THandle(Msg.wParam);
  FileName:=StrAlloc(255);
  try
    DragQueryFile(Drop,0,FileName,255);
    ListBox1.Items.Add(StrPas(FileName));
  finally
    StrDispose(FileName);
    DragFinish(Drop);
  end;
end;

procedure TSMTPForm.msSMTPClient1Connecting(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Connecting to '+msSMTPClient1.Host;
end;

procedure TSMTPForm.msSMTPClient1Connected(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Connected';
end;

procedure TSMTPForm.msSMTPClient1Disconnected(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Disconnected';
end;

procedure TSMTPForm.msSMTPClient1Preparing(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Preparing the message';
end;

procedure TSMTPForm.msSMTPClient1Sending(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Sending the message';
end;

procedure TSMTPForm.msSMTPClient1Sent(Sender: TObject);
begin
  MessageBeep(MB_ICONASTERISK);
  MessageDlg('Message has been sent',mtInformation,
              [mbOk],0);
end;

procedure TSMTPForm.msSMTPClient1TransferProgress(Sender: TObject; Perc,
  ByteCount, LineCount: Longint);
begin
  ProgressBar1.Position:=Perc;
end;

end.
