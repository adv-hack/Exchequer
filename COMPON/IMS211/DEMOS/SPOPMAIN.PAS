unit spopmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, Buttons, Menus,
{$IFDEF VER120}
  ImgList,
{$ENDIF}
  IniFiles, Mssocket, Mspop, msmsg, msUtils;

type
  TSelForm = class(TForm)
    ButtonBar: TPanel;
    StatusBar: TStatusBar;
    ServerListView: TListView;
    UpdateHeadersButton: TSpeedButton;
    RetrieveButton: TSpeedButton;
    DeleteButton: TSpeedButton;
    RetrieveCopyButton: TSpeedButton;
    ResetAllButton: TSpeedButton;
    TransferMailButton: TSpeedButton;
    CancelButton: TSpeedButton;
    SetupButton: TSpeedButton;
    ExitButton: TSpeedButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    UpdateHeaders1: TMenuItem;
    MarktoRetrieve1: TMenuItem;
    MarktoRetrieveaCopy1: TMenuItem;
    MarktoDelete1: TMenuItem;
    ResetAll1: TMenuItem;
    Cancel1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Setup1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    StateImgList: TImageList;
    msPOPClient1: TmsPOPClient;
    msMessage: TmsMessage;
    MailBoxListView: TListView;
    MsgImageList: TImageList;
    PopupMenu1: TPopupMenu;
    Show1: TMenuItem;
    SavetoFile1: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure SetupButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitButtonClick(Sender: TObject);
    procedure UpdateHeadersButtonClick(Sender: TObject);
    procedure msPOPClient1Connecting(Sender: TObject);
    procedure msPOPClient1Connected(Sender: TObject);
    procedure msPOPClient1Disconnected(Sender: TObject);
    procedure RetrieveButtonClick(Sender: TObject);
    procedure RetrieveCopyButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure ResetAllButtonClick(Sender: TObject);
    procedure TransferMailButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure MailBoxListViewDblClick(Sender: TObject);
    procedure MailBoxListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure SavetoFile1Click(Sender: TObject);
    procedure msPOPClient1TransferProgress(Sender: TObject; Perc,
      ByteCount, LineCount: Longint);
  private
    { Private declarations }
    IniName: string;
    SaveAsIs: boolean;
    procedure AddMessageToMailBox(Msg: TmsMessage);
    procedure EnableControls;
    procedure DisableControls;
    procedure AddMessageStreamToMailBox(Stream: TStream; MsgNo: Integer);
  public
    { Public declarations }
  end;

var
  SelForm: TSelForm;

implementation

uses spopsu, popview;

{$R *.DFM}

procedure TSelForm.SetupButtonClick(Sender: TObject);
begin
  with TsPOPSetupDlg.Create(Self) do
  try
    ServerEdit.Text:=msPOPClient1.Host;
    UserNameEdit.Text:=msPOPClient1.UserName;
    PasswordEdit.Text:=msPOPClient1.Password;
    LogFileNameEdit.Text:=msPOPClient1.LogFileName;
    AsIsCheckBox.Checked:=SaveAsIs;
    if ShowModal=mrOk then
    begin
      msPOPClient1.Host:=ServerEdit.Text;
      msPOPClient1.UserName:=UserNameEdit.Text;
      msPOPClient1.Password:=PasswordEdit.Text;
      msPOPClient1.LogFileName:=LogFileNameEdit.Text;
      SaveAsIs:=AsIsCheckBox.Checked;
    end;
  finally
    Free;
  end;
end;

procedure TSelForm.FormCreate(Sender: TObject);
begin
  IniName:=ChangeFileExt(Application.ExeName,'.ini');
  with TIniFile.Create(IniName) do
  try
    msPOPClient1.Host:=ReadString('Setup','Server','');
    msPOPClient1.UserName:=ReadString('Setup','User Name','');
    msPOPClient1.Password:=ReadString('Setup','Password','');
    msPOPClient1.LogFileName:=ReadString('Setup','Log File','');
    SaveAsIs:=ReadBool('Setup','Save as is',false);
  finally
    free;
  end;
  EnableControls;
end;

procedure TSelForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with TIniFile.Create(IniName) do
  try
    WriteString('Setup','Server',msPOPClient1.Host);
    WriteString('Setup','User Name',msPOPClient1.UserName);
    WriteString('Setup','Password',msPOPClient1.Password);
    WriteString('Setup','Log File',msPOPClient1.LogFileName);
    WriteBool('Setup','Save as is',SaveAsIs);
  finally
    free;
  end;
  msPOPClient1.SaveLogFile;
end;

procedure TSelForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TSelForm.UpdateHeadersButtonClick(Sender: TObject);
var
  Item: TListItem;
  DT: TDateTime;
  TZ: ShortString;
  SenderName: string;
  Size: LongInt;
  i: Integer;
begin
  DisableControls;
  try
    ServerListView.Items.Clear;
    StatusBar.Panels[1].Text:='';
    with msPOPClient1 do
    begin
      Login;
      StatusBar.Panels[1].Text:=IntToStr(TotalMessages)+'  messages on server';
      for i:=0 to msPOPClient1.TotalMessages-1 do
      begin
        msPOPClient1.CurrentMessage:=i;
        RetrieveHeaders;
        Size:=GetSize;
        Item:=ServerListView.Items.Add;
        Item.Caption:=MailMessage.Subject;
        SenderName:=MailMessage.Sender.Name;
        if SenderName='' then
          SenderName:=MailMessage.Sender.Address;
        Item.SubItems.Add(SenderName);
        Item.SubItems.Add(IntToStr(Size));
        MailDateToDateTime(MailMessage.Headers.GetFieldBody('Date'),DT,TZ);
        Item.SubItems.Add(DateTimeToStr(DT));
      end;
      Logout;
    end;
  finally
    EnableControls;
  end;
end;

procedure TSelForm.msPOPClient1Connecting(Sender: TObject);
begin
  StatusBar.Panels[0].Text:='Connecting to the server';
end;

procedure TSelForm.msPOPClient1Connected(Sender: TObject);
begin
  StatusBar.Panels[0].Text:='Connected';
end;

procedure TSelForm.msPOPClient1Disconnected(Sender: TObject);
begin
  StatusBar.Panels[0].Text:='Disconnected';
end;

procedure TSelForm.RetrieveButtonClick(Sender: TObject);
var
  i: Integer;
begin
  with ServerListView do
  begin
    for i:=0 to Items.Count-1 do
    begin
      if Items[i].Selected then
        Items[i].StateIndex:=0;
    end;
  end;
end;

procedure TSelForm.RetrieveCopyButtonClick(Sender: TObject);
var
  i: Integer;
begin
  with ServerListView do
  begin
    for i:=0 to Items.Count-1 do
    begin
      if Items[i].Selected then
        Items[i].StateIndex:=1;
    end;
  end;
end;

procedure TSelForm.DeleteButtonClick(Sender: TObject);
var
  i: Integer;
begin
  with ServerListView do
  begin
    for i:=0 to Items.Count-1 do
    begin
      if Items[i].Selected then
        Items[i].StateIndex:=2;
    end;
  end;
end;

procedure TSelForm.ResetAllButtonClick(Sender: TObject);
var
  i: Integer;
begin
  with ServerListView do
  begin
    for i:=0 to Items.Count-1 do
        Items[i].StateIndex:=-1;
  end;
end;

procedure TSelForm.AddMessageToMailBox(Msg: TmsMessage);
var
  Item: TListItem;
  TempStream: TStream;
begin
  TempStream:=TMemoryStream.Create;
  Item:=MailBoxListView.Items.Add;
  Item.Caption:=Msg.Subject;
  Item.ImageIndex:=0;
  Msg.SaveToStream(TempStream);
  Item.Data:=TempStream;
end;

procedure TSelForm.AddMessageStreamToMailBox(Stream: TStream; MsgNo: Integer);
var
  Item: TListItem;
begin
  Item:=MailBoxListView.Items.Add;
  Item.Caption:='Msg No '+IntToStr(MsgNo);
  Item.ImageIndex:=0;
  Item.Data:=Stream;
end;

procedure TSelForm.TransferMailButtonClick(Sender: TObject);
var
  i: Integer;
  Stream: TStream;
begin
  DisableControls;
  try
    with msPOPClient1 do
    begin
      Login;
      for i:=0 to TotalMessages-1 do
      begin
        CurrentMessage:=i;
        case ServerListView.Items[i].StateIndex of
          0:
          begin
            if SaveAsIs then
            begin
              Stream:=TMemoryStream.Create;
              RetrieveAsStream(Stream);
              AddMessageStreamToMailBox(Stream,i);
            end
            else
            begin
              Retrieve;
              AddMessageToMailBox(MailMessage);
            end;
            Delete;
          end;
          1:
          begin
            if SaveAsIs then
            begin
              Stream:=TMemoryStream.Create;
              RetrieveAsStream(Stream);
              AddMessageStreamToMailBox(Stream,i);
            end
            else
            begin
              Retrieve;
              AddMessageToMailBox(MailMessage);
            end;
          end;
          2:
          begin
            Delete;
          end;
        end;
      end;
      Logout;
    end;
    UpdateHeadersButtonClick(Self);
  finally
    EnableControls;
  end;
end;

procedure TSelForm.CancelButtonClick(Sender: TObject);
begin
  msPOPClient1.Cancel;
end;

procedure TSelForm.MailBoxListViewDblClick(Sender: TObject);
var
  TempMessage: TmsMessage;
begin
  if MailBoxListView.Selected<>nil then
  begin
    TempMessage:=TmsMessage.Create(Self);
    try
      MsgViewDlg:=TMsgViewDlg.Create(Self);
      TempMessage.LoadFromStream(MailBoxListView.Selected.Data);
      MsgViewDlg.MailMessage:=TempMessage;
      MsgViewDlg.ShowModal;
      MsgViewDlg.Free;
    finally
      TempMessage.Free;
    end;
  end;
end;

procedure TSelForm.MailBoxListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  StatusBar.Panels[2].Text:=IntToStr(MailBoxListView.Items.Count)+' messages retrieved';
end;

procedure TSelForm.DisableControls;
// Disable the buttons/manu items which are unaccessible
// during the communication with server
begin
  UpdateHeadersButton.Enabled:=false;
  UpdateHeaders1.Enabled:=false;
  RetrieveButton.Enabled:=false;
  MarktoRetrieve1.Enabled:=false;
  RetrieveCopyButton.Enabled:=false;
  MarktoRetrieveaCopy1.Enabled:=false;
  DeleteButton.Enabled:=false;
  MarktoDelete1.Enabled:=false;
  ResetAllButton.Enabled:=false;
  ResetAll1.Enabled:=false;
  CancelButton.Enabled:=true;
  Cancel1.Enabled:=true;
end;

procedure TSelForm.EnableControls;
begin
  UpdateHeadersButton.Enabled:=true;
  UpdateHeaders1.Enabled:=true;
  RetrieveButton.Enabled:=true;
  MarktoRetrieve1.Enabled:=true;
  RetrieveCopyButton.Enabled:=true;
  MarktoRetrieveaCopy1.Enabled:=true;
  DeleteButton.Enabled:=true;
  MarktoDelete1.Enabled:=true;
  ResetAllButton.Enabled:=true;
  ResetAll1.Enabled:=true;
  CancelButton.Enabled:=false;
  Cancel1.Enabled:=false;
end;

procedure TSelForm.PopupMenu1Popup(Sender: TObject);
begin
  if MailBoxListView.Selected<>nil then
  begin
    Show1.Enabled:=true;
    SaveToFile1.Enabled:=true;
  end
  else
  begin
    Show1.Enabled:=false;
    SaveToFile1.Enabled:=false;
  end;
end;

procedure TSelForm.Show1Click(Sender: TObject);
begin
  MailBoxListViewDblClick(Sender);
end;

procedure TSelForm.SavetoFile1Click(Sender: TObject);
var
  Stream: TMemoryStream;
begin
  if SaveDialog1.Execute then
  begin
    Stream:=TMemoryStream(MailBoxListView.Selected.Data);
    Stream.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TSelForm.msPOPClient1TransferProgress(Sender: TObject; Perc,
  ByteCount, LineCount: Longint);
begin
  if Perc<>-1 then
    StatusBar.Panels[0].Text:='Transferring data ('+IntToStr(Perc)+'%)';
end;

end.
