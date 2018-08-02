unit popmain;

{$I msdef.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ComCtrls, ExtCtrls,
{$IFDEF VER120}
  ImgList,
{$ENDIF}
  msmsg,  msMsgCls, popsu,
  IniFiles, Menus, StdCtrls, Mssocket, Mspop;

type
  TPopForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    ListView1: TListView;
    RetrieveButton: TSpeedButton;
    CancelButton: TSpeedButton;
    ImageList1: TImageList;
    SetupButton: TSpeedButton;
    ExitButton: TSpeedButton;
    ProgressBar1: TProgressBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Retrieve1: TMenuItem;
    Cancel1: TMenuItem;
    Exit1: TMenuItem;
    Setup1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Bevel1: TBevel;
    msPOPClient1: TmsPOPClient;
    msMessage1: TmsMessage;
    procedure msPOP1Cancel(Sender: TObject);
    procedure msPOP1Open(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure SetupButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure RetrieveButtonClick(Sender: TObject);
    procedure msPOPClient1Connecting(Sender: TObject);
    procedure msPOPClient1Connected(Sender: TObject);
    procedure msPOPClient1Disconnected(Sender: TObject);
    procedure msPOPClient1RetrievingMessage(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure msPOPClient1TransferProgress(Sender: TObject; Perc,
      ByteCount, LineCount: Longint);
  private
    { Private declarations }
    Item : TListItem;
    IniName : string;
    procedure EnableControls;
    procedure DisableControls;
  public
    { Public declarations }
  end;

var
  PopForm: TPopForm;

implementation

uses popview, msabout;

{$R *.DFM}

procedure TPopForm.EnableControls;
begin
  RetrieveButton.Enabled:=true;
  CancelButton.Enabled:=false;
  SetupButton.Enabled:=true;
  ExitButton.Enabled:=true;
  Retrieve1.Enabled:=true;
  Cancel1.Enabled:=false;
  Exit1.Enabled:=true;
  Setup1.Enabled:=true;
  Help1.Enabled:=true;
end;

procedure TPopForm.DisableControls;
begin
  RetrieveButton.Enabled:=false;
  CancelButton.Enabled:=true;
  SetupButton.Enabled:=false;
  ExitButton.Enabled:=false;
  Retrieve1.Enabled:=false;
  Cancel1.Enabled:=true;
  Exit1.Enabled:=false;
  Setup1.Enabled:=false;
  Help1.Enabled:=false;
end;

procedure TPopForm.msPOP1Cancel(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Canceled';
end;

procedure TPopForm.msPOP1Open(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Opening connection';
end;

procedure TPopForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TPopForm.ListView1DblClick(Sender: TObject);
var
  TempMessage : TmsMessage;
begin
  TempMessage:=TmsMessage.Create(Self);
  try
    if ListView1.Selected<>nil then
    begin
      MsgViewDlg:=TMsgViewDlg.Create(Self);
      TempMessage.LoadFromStream(ListView1.Selected.Data);
      MsgViewDlg.MailMessage:=TempMessage;
      MsgViewDlg.ShowModal;
      MsgViewDlg.Free;
    end;
  finally
    TempMessage.Free;
  end;
end;

procedure TPopForm.SetupButtonClick(Sender: TObject);
begin
  with TSetupDlg.Create(Self) do
  try
    ServerEdit.Text:=msPOPClient1.Host;
    UserNameEdit.Text:=msPOPClient1.UserName;
    PasswordEdit.Text:=msPOPClient1.Password;
    LogFileNameEdit.Text:=msPOPClient1.LogFileName;
    if ShowModal=mrOk then
    begin
      msPOPClient1.Host:=ServerEdit.Text;
      msPOPClient1.UserName:=UserNameEdit.Text;
      msPOPClient1.Password:=PasswordEdit.Text;
      msPOPClient1.LogFileName:=LogFileNameEdit.Text;
    end;
  finally
    free;
  end;
end;

procedure TPopForm.FormCreate(Sender: TObject);
begin
  IniName:=ChangeFileExt(Application.ExeName,'.ini');
  with TIniFile.Create(IniName) do
  try
    msPOPClient1.Host:=ReadString('Setup','Server','');
    msPOPClient1.UserName:=ReadString('Setup','User Name','');
    msPOPClient1.Password:=ReadString('Setup','Password','');
    msPOPClient1.LogFileName:=ReadString('Setup','Log File','');
  finally
    free;
  end;
end;

procedure TPopForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with TIniFile.Create(IniName) do
  try
    WriteString('Setup','Server',msPOPClient1.Host);
    WriteString('Setup','User Name',msPOPClient1.UserName);
    WriteString('Setup','Password',msPOPClient1.Password);
    WriteString('Setup','Log File',msPOPClient1.LogFileName);
  finally
    free;
  end;
end;

procedure TPopForm.About1Click(Sender: TObject);
begin
  with TAboutDlg.Create(Self) do
  try
    ProgramName.Caption:='TmsPOPClient Component Demo (1 of 2)';
    ShowModal;
  finally
    Free;
  end;
end;

procedure TPopForm.FormResize(Sender: TObject);
begin
  Bevel1.Width:=Width;
end;

procedure TPopForm.RetrieveButtonClick(Sender: TObject);
var
  i: Integer;
  TempStream : TMemoryStream;
begin
  DisableControls;
  ListView1.Items.Clear;
  try
    with msPOPClient1 do
    begin
      LogIn;
      for i:= 0 to msPOPClient1.TotalMessages-1 do
      begin
        msPOPClient1.CurrentMessage:=i;
        Retrieve;
        TempStream:=TMemoryStream.Create;
        MailMessage.SaveToStream(TempStream);
        Item:=ListView1.Items.Add;
        Item.Caption:=msPOPClient1.MailMessage.Subject;
        if Item.Caption='' then Item.Caption:='No Subject';
        Item.ImageIndex:=0;
        Item.Data:=TempStream;
        ProgressBar1.Position:=0;
        Next;
      end;
      LogOut;
    end;
  finally
    EnableControls;
  end;
end;

procedure TPopForm.msPOPClient1Connecting(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Connecting to the server '+msPOPClient1.Host;
end;

procedure TPopForm.msPOPClient1Connected(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Connected';
end;

procedure TPopForm.msPOPClient1Disconnected(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Disconnected';
end;

procedure TPopForm.msPOPClient1RetrievingMessage(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Retrieving the message '+
    IntToStr(msPOPClient1.CurrentMessage+1)+' of '+IntToStr(msPOPClient1.TotalMessages);
end;

procedure TPopForm.CancelButtonClick(Sender: TObject);
begin
  msPOPClient1.Cancel;
  StatusBar1.Panels[0].Text:='Operation has been canceled';
end;

procedure TPopForm.msPOPClient1TransferProgress(Sender: TObject; Perc,
  ByteCount, LineCount: Longint);
begin
  ProgressBar1.Position:=Perc;
end;

end.
