unit FTPResumeDemoMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, IniFiles, Mssocket, msFTP;

type
  TResumeForm = class(TForm)
    Panel1: TPanel;
    LogMemo: TMemo;
    StatusBar: TStatusBar;
    Label1: TLabel;
    ServerEdit: TEdit;
    Label2: TLabel;
    UserNameEdit: TEdit;
    Label3: TLabel;
    PasswordEdit: TEdit;
    Label4: TLabel;
    FileNameEdit: TEdit;
    Label5: TLabel;
    StartButton: TButton;
    CancelButton: TButton;
    RemoteDirectoryEdit: TEdit;
    SpeedButton1: TSpeedButton;
    msFTPClient1: TmsFTPClient;
    OpenDialog: TOpenDialog;
    ResumeButton: TButton;
    Label7: TLabel;
    OperationComboBox: TComboBox;
    procedure StartButtonClick(Sender: TObject);
    procedure OnLineTransferred(Sender: TObject; const TheLine: String);
    procedure SpeedButton1Click(Sender: TObject);
    procedure msFTPClient1Connected(Sender: TObject);
    procedure msFTPClient1Connecting(Sender: TObject);
    procedure msFTPClient1Disconnected(Sender: TObject);
    procedure msFTPClient1DataTransferStart(Sender: TObject);
    procedure msFTPClient1DataTransferTerminate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ResumeButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure msFTPClient1DataTransferProgress(Sender: TObject;
      ByteCount: Longint);
  private
    { Private declarations }
    IniFileName: string;
    function GetFileSize(const FileName: string): LongInt;
  public
    { Public declarations }
  end;

var
  ResumeForm: TResumeForm;

implementation

{$R *.DFM}

procedure TResumeForm.StartButtonClick(Sender: TObject);
begin
  CancelButton.Enabled:=true;
  ResumeButton.Enabled:=false;
  StartButton.Enabled:=false;
  try
    msFTPClient1.Host:=ServerEdit.Text;
    msFTPClient1.UserName:=UserNameEdit.Text;
    msFTPClient1.Password:=PasswordEdit.Text;
    msFTPClient1.Login;
    if RemoteDirectoryEdit.Text<>'' then
      msFTPClient1.CurrentDirectory:=RemoteDirectoryEdit.Text;
    if OperationComboBox.ItemIndex=0 then {Upload}
      msFTPClient1.StoreFile(FileNameEdit.Text,ExtractFileName(FileNameEdit.Text))
    else {Download}
      msFTPClient1.RetrieveFile(ExtractFileName(FileNameEdit.Text),FileNameEdit.Text);
    msFTPClient1.Logout;
  finally
    CancelButton.Enabled:=false;
    ResumeButton.Enabled:=true;
    StartButton.Enabled:=true;
  end;
end;

procedure TResumeForm.OnLineTransferred(Sender: TObject;
  const TheLine: String);
begin
  LogMemo.Lines.Add(TheLine);
end;

procedure TResumeForm.SpeedButton1Click(Sender: TObject);
begin
  if FileNameEdit.Text<>'' then
    OpenDialog.FileName:=FileNameEdit.Text;
  if OpenDialog.Execute then
    FileNameEdit.Text:=OpenDialog.FileName;
end;

procedure TResumeForm.msFTPClient1Connected(Sender: TObject);
begin
  StatusBar.SimpleText:='Connected';
end;

procedure TResumeForm.msFTPClient1Connecting(Sender: TObject);
begin
  StatusBar.SimpleText:='Connecting to the server';
end;

procedure TResumeForm.msFTPClient1Disconnected(Sender: TObject);
begin
  StatusBar.SimpleText:='Disconnected';
end;

procedure TResumeForm.msFTPClient1DataTransferStart(Sender: TObject);
begin
  StatusBar.SimpleText:='Opaning data connection';
end;

procedure TResumeForm.msFTPClient1DataTransferTerminate(Sender: TObject);
begin
  StatusBar.SimpleText:='Data connection closed';
end;

procedure TResumeForm.CancelButtonClick(Sender: TObject);
begin
  msFTPClient1.CancelDataTransfer;
end;

function TResumeForm.GetFileSize(const FileName: string): LongInt;
var
  f: file;
begin
  AssignFile(f,FileName);
  Reset(f,1);
  try
    Result:=FileSize(f);
  finally
    CloseFile(f);
  end;
end;

procedure TResumeForm.ResumeButtonClick(Sender: TObject);
var
  Marker: LongInt;
begin
  CancelButton.Enabled:=true;
  ResumeButton.Enabled:=false;
  StartButton.Enabled:=false;
  try
    msFTPClient1.Host:=ServerEdit.Text;
    msFTPClient1.UserName:=UserNameEdit.Text;
    msFTPClient1.Password:=PasswordEdit.Text;
    msFTPClient1.Login;
    if RemoteDirectoryEdit.Text<>'' then
      msFTPClient1.CurrentDirectory:=RemoteDirectoryEdit.Text;
    if OperationComboBox.ItemIndex=0 then {Upload}
    begin
      Marker:=msFTPClient1.GetFileSize(ExtractFileName(FileNameEdit.Text));
      {Go slightly back, because some servers are returning the size occupied}
      {by the file, not actual number of bytes}
      Marker:=Marker-1024;
      if Marker<0 then Marker:=0;
      msFTPClient1.ResumeStoreFile(FileNameEdit.Text,ExtractFileName(FileNameEdit.Text),
        Marker);
    end
    else {Download}
    begin
      Marker:=GetFileSize(FileNameEdit.Text);
      msFTPClient1.ResumeRetrieveFile(ExtractFileName(FileNameEdit.Text),FileNameEdit.Text,
        Marker);
    end;
    msFTPClient1.Logout;
  finally
    CancelButton.Enabled:=false;
    ResumeButton.Enabled:=true;
    StartButton.Enabled:=true;
  end;
end;

procedure TResumeForm.FormCreate(Sender: TObject);
begin
  IniFileName:=ChangeFileExt(ParamStr(0),'.ini');
  with TIniFile.Create(IniFileName) do
  try
    OperationComboBox.ItemIndex:=ReadInteger('Setup','Operation',0);
    ServerEdit.Text:=ReadString('Setup','Server','');
    UserNameEdit.Text:=ReadString('Setup','User Name','');
    PasswordEdit.Text:=ReadString('Setup','Password','');
    RemoteDirectoryEdit.Text:=ReadString('Setup','Remote Directory','');
    FileNameEdit.Text:=ReadString('Setup','File Name','');
  finally
    Free;
  end;
end;

procedure TResumeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with TIniFile.Create(IniFileName) do
  try
    WriteInteger('Setup','Operation',OperationComboBox.ItemIndex);
    WriteString('Setup','Server',ServerEdit.Text);
    WriteString('Setup','User Name',UserNameEdit.Text);
    WriteString('Setup','Password',PasswordEdit.Text);
    WriteString('Setup','Remote Directory',RemoteDirectoryEdit.Text);
    WriteString('Setup','File Name',FileNameEdit.Text);
  finally
    Free;
  end;
end;

procedure TResumeForm.msFTPClient1DataTransferProgress(Sender: TObject;
  ByteCount: Longint);
begin
  StatusBar.SimpleText:=IntToStr(ByteCount)+' bytes transferred';
end;

end.
