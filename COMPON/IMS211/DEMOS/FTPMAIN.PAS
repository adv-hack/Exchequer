unit Ftpmain;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Buttons, Menus, IniFiles,
{$IFDEF VER120}
  ImgList,
{$ENDIF}
  msFTP, msFTPCls, Mssocket, msWSock, ComCtrls, StdCtrls, msDef;

type
  TFTPForm = class(TForm)
    ToolBar: TPanel;
    ConnectButton: TSpeedButton;
    DisconnectButton: TSpeedButton;
    ChDirButton: TSpeedButton;
    UpdButton: TSpeedButton;
    RetrieveFileButton: TSpeedButton;
    StoreFileButton: TSpeedButton;
    MkDirButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    CancelButton: TSpeedButton;
    ExitButton: TSpeedButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Connect1: TMenuItem;
    Disconnect1: TMenuItem;
    Retrieve1: TMenuItem;
    Store1: TMenuItem;
    Cancel1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Directory1: TMenuItem;
    Change1: TMenuItem;
    ChangeUp1: TMenuItem;
    Create1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    RenameButton: TSpeedButton;
    Rename1: TMenuItem;
    Delete1: TMenuItem;
    StatusBar: TStatusBar;
    LogMemo: TMemo;
    LogOnOffButton: TSpeedButton;
    FTPListView: TListView;
    msFTPClient1: TmsFTPClient;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure RetrieveFileButtonClick(Sender: TObject);
    procedure StoreFileButtonClick(Sender: TObject);
    procedure UpdButtonClick(Sender: TObject);
    procedure MkDirButtonClick(Sender: TObject);
    procedure ChDirButtonClick(Sender: TObject);
    procedure DisconnectButtonClick(Sender: TObject);
    procedure RenameButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FTPListViewDblClick(Sender: TObject);
    procedure agFTP1LineTransmitted(Sender: TObject; const TheLine: String);
    procedure LogOnOffButtonClick(Sender: TObject);
    procedure msFTPClient1DataTransferStart(Sender: TObject);
    procedure msFTPClient1DataTransferTerminate(Sender: TObject);
    procedure msFTPClient1Connecting(Sender: TObject);
    procedure msFTPClient1Connected(Sender: TObject);
    procedure msFTPClient1Disconnected(Sender: TObject);
    procedure msFTPClient1DataTransferProgress(Sender: TObject;
      ByteCount: Longint);
  private
    { Private declarations }
    IniName : string;
    FTPEntry : TmsFTPDirEntry;
    TheFileSize : LongInt;
    procedure EnableControls;
    procedure DisableControls;
    function GetFileSize(const FileName : string) : LongInt;
    procedure FillFTPListView;
    procedure UpdateFTPListView;
  public
    { Public declarations }
  end;

var
  FTPForm: TFTPForm;

implementation

uses FtpConn, msAbout, ftptrans;

{$R *.DFM}

procedure TFTPForm.EnableControls;
var
  i : Integer;
  Btn : TSpeedButton;
begin
  with ToolBar do
  begin
    for i:=0 to ControlCount-1 do
    if Controls[i] is TSpeedButton then
    begin
      Btn:=(Controls[i] as TSpeedButton);
      if Btn.Tag=1 then Btn.Enabled:=true
      else
      if Btn.Tag>=2 then Btn.Enabled:=false;
    end;
  end;
  Directory1.Enabled:=false;
  for i:=0 to File1.Count-1 do
  begin
    if File1[i].Tag=1 then File1[i].Enabled:=true
    else
    if File1[i].Tag=2 then File1[i].Enabled:=false;
  end;
end;

procedure TFTPForm.DisableControls;
var
  i : Integer;
  Btn : TSpeedButton;
begin
  with ToolBar do
  begin
    for i:=0 to ControlCount-1 do
    if Controls[i] is TSpeedButton then
    begin
      Btn:=(Controls[i] as TSpeedButton);
      if Btn.Tag=1 then
       Btn.Enabled:=false
      else
       Btn.Enabled:=true;
    end;
  end;
  Directory1.Enabled:=true;
  for i:=0 to File1.Count-1 do
  begin
    if File1[i].Tag=1 then File1[i].Enabled:=false
    else
    if File1[i].Tag>=2 then File1[i].Enabled:=true;
  end;
end;

procedure TFTPForm.FormCreate(Sender: TObject);
begin
  EnableControls;
  IniName:=ChangeFileExt(Application.ExeName,'.ini');
  with TIniFile.Create(IniName) do
  try
    msFTPClient1.Host:=ReadString('Setup','Server','ftp.borland.com');
    msFTPClient1.UserName:=ReadString('Setup','User Name','anonymous');
    msFTPClient1.Password:=ReadString('Setup','Password','guest@');
    msFTPClient1.TransferType:=TmsTransferType(ReadInteger('Setup','Transfer Type',0));
    msFTPClient1.PassiveMode:=ReadBool('Setup','Passive Mode',false);
    msFTPClient1.LogFileName:=ReadString('Setup','Log File','');
    LogOnOffButton.Down:=ReadBool('Setup','Log Memo',true);
    msFTPClient1.Proxy:=ReadString('Setup','Proxy Server','');
    msFTPClient1.ProxyPort:=ReadInteger('Setup','Proxy Port',21);
    msFTPClient1.ProxyType:=TmsProxyType(ReadInteger('Setup','Proxy Type',0));
    LogMemo.Visible:=LogOnOffButton.Down;
  finally
    free;
  end;
end;

procedure TFTPForm.ConnectButtonClick(Sender: TObject);
var
  Proceed : boolean;
  i : Integer;
begin
  Proceed:=false;
  with TFTPConnectDlg.Create(Self) do
  try
    ServerEdit.Text:=msFTPClient1.Host;
    UserNameEdit.Text:=msFTPClient1.UserName;
    PasswordEdit.Text:=msFTPClient1.Password;
    TransferTypeComboBox.ItemIndex:=Ord(msFTPClient1.TransferType);
    PassiveModeCheckBox.Checked:=msFTPClient1.PassiveMode;
    LogFileNameEdit.Text:=msFTPClient1.LogFileName;
    ProxyPortUpDown.Position:=msFTPClient1.ProxyPort;
    ProxyServerEdit.Text:=msFTPClient1.Proxy;
    ServerTypeRadioGroup.ItemIndex:=Ord(msFTPClient1.ProxyType);
    if ShowModal=mrOK then
    begin
      Proceed:=true;
      msFTPClient1.Host:=ServerEdit.Text;
      msFTPClient1.UserName:=UserNameEdit.Text;
      msFTPClient1.Password:=PasswordEdit.Text;
      msFTPClient1.TransferType:=TmsTransferType(TransferTypeComboBox.ItemIndex);
      msFTPClient1.PassiveMode:=PassiveModeCheckBox.Checked;
      msFTPClient1.LogFileName:=LogFileNameEdit.Text;
      msFTPClient1.Proxy:=ProxyServerEdit.Text;
      msFTPClient1.ProxyPort:=ProxyPortUpDown.Position;
      msFTPClient1.ProxyType:=TmsProxyType(ServerTypeRadioGroup.ItemIndex);
    end;
  finally
    Free;
  end;
  if Proceed then
  begin
    msFTPClient1.Login;
    UpdateFTPListView;
  end;
end;

procedure TFTPForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with TIniFile.Create(IniName) do
  try
    WriteString('Setup','Server',msFTPClient1.Host);
    WriteString('Setup','User Name',msFTPClient1.UserName);
    WriteString('Setup','Password',msFTPClient1.Password);
    WriteInteger('Setup','Transfer Type',Ord(msFTPClient1.TransferType));
    WriteBool('Setup','Passive Mode',msFTPClient1.PassiveMode);
    WriteString('Setup','Log File',msFTPClient1.LogFileName);
    WriteBool('Setup','Log Memo',LogOnOffButton.Down);
    WriteString('Setup','Proxy Server',msFTPClient1.Proxy);
    WriteInteger('Setup','Proxy Port',msFTPClient1.ProxyPort);
    WriteInteger('Setup','Proxy Type',Ord(msFTPClient1.ProxyType));
  finally
    free;
  end;
end;

procedure TFTPForm.About1Click(Sender: TObject);
begin
  with TAboutDlg.Create(Self) do
  try
    ProgramName.Caption:='TmsFTPClient Component Demo';
    ProductVersion.Caption:=msVersion;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFTPForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFTPForm.FillFTPListView;
var
  Item : TListItem;
  i : Integer;
begin
  for i:=0 to msFTPClient1.DirList.Count-1 do
  begin
    FTPEntry:=msFTPClient1.DirList[i];
    Item:=FTPListView.Items.Add;
    Item.Caption:=FTPEntry.FileName;
    Item.SubItems.Add(IntToStr(FTPEntry.Size));
    Item.SubItems.Add(DateTimeToStr(FTPEntry.Date));
    Item.StateIndex:=Ord(FTPEntry.Kind)-1;
  end;
end;

procedure TFTPForm.UpdateFTPListView;
begin
  FTPListView.Items.Clear;
  msFTPClient1.GetDirList;
  FillFTPListView;
end;

procedure TFTPForm.RetrieveFileButtonClick(Sender: TObject);
begin
  if FTPListView.Selected<>nil then
  begin
    FTPEntry:=msFTPClient1.DirList[FTPListView.Selected.Index];
    if (FTPEntry.FileName<>'') and (FTPEntry.Kind=fkFile) then
    begin
      SaveDialog1.FileName:=FTPEntry.FileName;
      if SaveDialog1.Execute then
      begin
        TheFileSize:=FTPEntry.Size;
        if TheFileSize=-1 then
          TheFileSize:=msFTPClient1.GetFileSize(FTPEntry.FileName);
        msFTPClient1.RetrieveFile(FTPEntry.FileName,SaveDialog1.FileName);
      end;
    end;
  end;
end;

function TFTPForm.GetFileSize(const FileName : string) : LongInt;
var
  f : file;
begin
  AssignFile(f,FileName);
  Reset(f,1);
  try
    Result:=FileSize(f);
  finally
    CloseFile(f);
  end;
end;

procedure TFTPForm.StoreFileButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    TheFileSize:=GetFileSize(OpenDialog1.FileName);
    msFTPClient1.StoreFile(OpenDialog1.FileName,ExtractFileName(OpenDialog1.FileName));
    UpdateFTPListView;
  end;
end;

procedure TFTPForm.UpdButtonClick(Sender: TObject);
begin
  msFTPClient1.ChangeToUpperDirectory;
  UpdateFTPListView;
end;

procedure TFTPForm.MkDirButtonClick(Sender: TObject);
var
  DirName : string;
begin
  DirName:='';
  if InputQuery('Create Directory','Type a Name of Directory:',DirName) then
  begin
    msFTPClient1.MakeDirectory(DirName);
    UpdateFTPListView;
  end;
end;

procedure TFTPForm.ChDirButtonClick(Sender: TObject);
var
  DirName : string;
begin
  DirName:='';
  if InputQuery('Change Directory','Type a Name of Directory:',DirName) then
  begin
    msFTPClient1.ChangeDirectory(DirName);
    UpdateFTPListView;
  end;
end;

procedure TFTPForm.DisconnectButtonClick(Sender: TObject);
begin
  msFTPClient1.Logout;
//  EnableControls;
  FTPListView.Items.Clear;
end;

procedure TFTPForm.RenameButtonClick(Sender: TObject);
var
  OldName, NewName : string;
begin
  if FTPListView.Selected<>nil then
  begin
    FTPEntry:=msFTPClient1.DirList[FTPListView.Selected.Index];
    if FTPEntry.Kind=fkLink then Exit;
    OldName:=FTPEntry.FileName;
    NewName:='';
    if OldName<>'' then
    begin
      if FTPEntry.Kind=fkDirectory then
      begin
        if InputQuery('Rename','Rename directory '+OldName+' to:',NewName) then
          msFTPClient1.RenameFile(OldName,NewName);
      end
      else
      begin
        if InputQuery('Rename File','Rename file '+OldName+' to:',NewName) then
          msFTPClient1.RenameFile(OldName,NewName);
      end;
      UpdateFTPListView;
    end;
  end;
end;

procedure TFTPForm.CancelButtonClick(Sender: TObject);
begin
  msFTPClient1.Cancel;
end;

procedure TFTPForm.DeleteButtonClick(Sender: TObject);
begin
  if FTPListView.Selected<>nil then
  begin
    FTPEntry:=msFTPClient1.DirList[FTPListView.Selected.Index];
    if FTPEntry.Kind=fkLink then Exit;
    if FTPEntry.FileName<>'' then
    begin
      if FTPEntry.Kind=fkDirectory then
        msFTPClient1.DeleteDirectory(FTPEntry.FileName)
      else
        msFTPClient1.EraseFile(FTPEntry.FileName);
      UpdateFTPListView;
    end;
  end;
end;

procedure TFTPForm.FTPListViewDblClick(Sender: TObject);
begin
  if FTPListView.Selected<>nil then
  begin
    FTPEntry:=msFTPClient1.DirList[FTPListView.Selected.Index];
    if FTPEntry.FileName='' then exit;
    if FTPEntry.Kind=fkDirectory then
    begin
      msFTPClient1.ChangeDirectory(FTPEntry.FileName);
      UpdateFTPListView;
    end
    else
    if FTPEntry.Kind=fkLink then
    begin
      try
        msFTPClient1.ChangeDirectory(FTPEntry.LinkPtr);
        UpdateFTPListView;
      except
        on EmsServerError do
        begin
          SaveDialog1.FileName:='';
          if SaveDialog1.Execute then
            msFTPClient1.RetrieveFile(FTPEntry.LinkPtr,SaveDialog1.FileName);
        end
        else
          raise;
      end;
    end
    else
      RetrieveFileButtonClick(Sender);
  end;
end;

procedure TFTPForm.agFTP1LineTransmitted(Sender: TObject;
  const TheLine: string);
begin
  LogMemo.Lines.Add(TheLine);
end;

procedure TFTPForm.LogOnOffButtonClick(Sender: TObject);
begin
  LogMemo.Visible:=LogOnOffButton.Down;
end;

procedure TFTPForm.msFTPClient1DataTransferStart(Sender: TObject);
begin
  StatusBar.SimpleText:='Opending data Connection';
  TransferForm.ShowProgress(0,-1);
  TransferForm.Show;
end;

procedure TFTPForm.msFTPClient1DataTransferTerminate(Sender: TObject);
begin
  if TransferForm.Showing then
    TransferForm.Hide;
  StatusBar.SimpleText:='Data transfer ended';
end;

procedure TFTPForm.msFTPClient1Connecting(Sender: TObject);
begin
  StatusBar.SimpleText:='Opening connection with '+msFTPClient1.Host;
end;

procedure TFTPForm.msFTPClient1Connected(Sender: TObject);
begin
  StatusBar.SimpleText:='Connected';
  DisableControls;
end;

procedure TFTPForm.msFTPClient1Disconnected(Sender: TObject);
begin
  StatusBar.SimpleText:='Disconnected';
  EnableControls;
end;

procedure TFTPForm.msFTPClient1DataTransferProgress(Sender: TObject;
  ByteCount: Longint);
begin
  TransferForm.ShowProgress(ByteCount,TheFileSize);
end;

end.
