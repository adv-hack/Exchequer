unit nntpmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ShellAPI, msUtils, Menus, Buttons,
  IniFiles, msmsg, Mssocket, msNNTP;

type
  TNNTPForm = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Setup1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    RetrieveHeaders1: TMenuItem;
    RetrieveArticles1: TMenuItem;
    Post1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Cancel1: TMenuItem;
    Bevel1: TBevel;
    HeadersButton: TSpeedButton;
    ArticleButton: TSpeedButton;
    CancelButton: TSpeedButton;
    SetupButton: TSpeedButton;
    ExitButton: TSpeedButton;
    Bevel2: TBevel;
    NGEdit: TEdit;
    PostButton: TSpeedButton;
    N2: TMenuItem;
    ArGoSoftHomepage1: TMenuItem;
    msNNTPClient1: TmsNNTPClient;
    msArticle1: TmsArticle;
    ListNGButton: TSpeedButton;
    ListNewsgroups1: TMenuItem;
    SaveLogFile1: TMenuItem;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure SetupButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ArGoSoftHomepage1Click(Sender: TObject);
    procedure HeadersButtonClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListNGButtonClick(Sender: TObject);
    procedure msNNTPClient1Connecting(Sender: TObject);
    procedure msNNTPClient1Disconnected(Sender: TObject);
    procedure SaveLogFile1Click(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure msNNTPClient1Connected(Sender: TObject);
    procedure msNNTPClient1OverviewItemRetrieved(Sender: TObject;
      OverviewItem: TmsOverviewItem);
    procedure PostButtonClick(Sender: TObject);
    procedure msNNTPClient1TransferProgress(Sender: TObject; Perc,
      ByteCount, LineCount: Longint);
  private
    { Private declarations }
    IniFileName : string;
    UserName : string;
    UserAddress : string;
    procedure EnableControls;
    procedure DisableControls;
    procedure AddItemToListView(OvrItem: TmsOverviewItem);
  public
    { Public declarations }
  end;

var
  NNTPForm: TNNTPForm;

implementation

uses nntppst, popview, msabout, nntpsu, nntplst, msDef;

{$R *.DFM}

procedure TNNTPForm.DisableControls;
begin
  ListNGButton.Enabled:=false;
  ListNewsgroups1.Enabled:=false;
  HeadersButton.Enabled:=false;
  RetrieveHeaders1.Enabled:=false;
  ArticleButton.Enabled:=false;
  RetrieveArticles1.Enabled:=false;
  PostButton.Enabled:=false;
  Post1.Enabled:=false;
  CancelButton.Enabled:=true;
  Cancel1.Enabled:=true;
  SetupButton.Enabled:=false;
  Setup1.Enabled:=false;
  ExitButton.Enabled:=false;
  Exit1.Enabled:=false;
  Help1.Enabled:=false;
  ListView1.Cursor:=crHourGlass;
  NGEdit.Enabled:=false;
end;

procedure TNNTPForm.EnableControls;
begin
  ListNGButton.Enabled:=true;
  ListNewsgroups1.Enabled:=true;
  HeadersButton.Enabled:=true;
  RetrieveHeaders1.Enabled:=true;
  ArticleButton.Enabled:=true;
  RetrieveArticles1.Enabled:=true;
  PostButton.Enabled:=true;
  Post1.Enabled:=true;
  CancelButton.Enabled:=false;
  Cancel1.Enabled:=true;
  SetupButton.Enabled:=true;
  Setup1.Enabled:=true;
  ExitButton.Enabled:=true;
  Exit1.Enabled:=true;
  Help1.Enabled:=true;
  NGEdit.Enabled:=true;
  ListView1.Cursor:=crDefault;
end;

procedure TNNTPForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with TIniFile.Create(IniFileName) do
  try
    WriteString('Setup','Server',msNNTPClient1.Host);
    WriteString('Setup','User Name',UserName);
    WriteString('Setup','User Address',UserAddress);
    WriteString('Setup','Log File',msNNTPClient1.LogFileName);
  finally
    Free;
  end;
end;

procedure TNNTPForm.FormResize(Sender: TObject);
begin
  Bevel1.Width:=Width;
end;

procedure TNNTPForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TNNTPForm.SetupButtonClick(Sender: TObject);
begin
  with TSetupDlg.Create(Self) do
  try
    ServerEdit.Text:=msNNTPClient1.Host;
    UserNameEdit.Text:=UserName;
    UserAddressEdit.Text:=UserAddress;
    LogFileNameEdit.Text:=msNNTPClient1.LogFileName;
    if ShowModal=mrOk then
    begin
      msNNTPClient1.Host:=ServerEdit.Text;
      UserName:=UserNameEdit.Text;
      UserAddress:=UserAddressEdit.Text;
      msNNTPClient1.LogFileName:=LogFileNameEdit.Text;
    end;
  finally
    Close;
  end;
end;

procedure TNNTPForm.FormCreate(Sender: TObject);
begin
  IniFileName:=ChangeFileExt(Application.ExeName,'.ini');
  with TIniFile.Create(IniFileName) do
  try
    msNNTPClient1.Host:=ReadString('Setup','Server','');
    UserName:=ReadString('Setup','User Name','');
    UserAddress:=ReadString('Setup','User Address','');
    msNNTPClient1.LogFileName:=ReadString('Setup','Log File','');
  finally
    Free;
  end;
//  msNNTPClient1.SleepTime:=50;
end;

procedure TNNTPForm.ArGoSoftHomepage1Click(Sender: TObject);
var
  TheHandle : THandle;
begin
  TheHandle:=ShellExecute(Application.Handle,'Open','http://www.argosoft.com',
             nil,nil,SW_SHOW);
  if TheHandle<=HINSTANCE_ERROR then
    raise Exception.Create('Unable to run ShellExec. Error code='+IntToStr(TheHandle));
end;

procedure TNNTPForm.AddItemToListView(OvrItem: TmsOverviewItem);
var
  Item: TListItem;
begin
  Item:=ListView1.Items.Add;
  Item.Caption:=OvrItem.Subject;
  if OvrItem.SenderName<>'' then
    Item.SubItems.Add(OvrItem.SenderName)
  else
    Item.SubItems.Add(OvrItem.SenderAddress);
  Item.SubItems.Add(DateTimeToStr(OvrItem.Date));
  Item.SubItems.Add(IntToStr(OvrItem.Bytes));
  Item.Data:=Pointer(OvrItem.ArticleNo);
end;

procedure TNNTPForm.HeadersButtonClick(Sender: TObject);
begin
  ListView1.Items.Clear;
  DisableControls;
  try
    msNNTPClient1.Login;
    try
      msNNTPClient1.Newsgroup:=NGEdit.Text;
      StatusBar1.Panels[0].Text:=IntToStr(msNNTPClient1.TotalArticles)+' articles';
      msNNTPClient1.GetOverview(msNNTPClient1.FirstArticle,msNNTPClient1.LastArticle);
      msNNTPClient1.Logout;
    except
      on EmsServerError do
      begin
        msNNTPClient1.LogOut;
        raise;
      end
      else
        raise;
    end;
  finally
    EnableControls;
  end;
end;

procedure TNNTPForm.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected=nil then Exit;
  DisableControls;
  try
    msNNTPClient1.Login;
    try
      msNNTPClient1.Newsgroup:=NGEdit.Text;
      msNNTPClient1.RetrieveArticleByNumber(LongInt(ListView1.Selected.Data));
      msNNTPClient1.Logout;
    except
      on EmsServerError do
      begin
        msNNTPClient1.Logout;
        raise;
      end
      else
        raise;
    end;
    with TMsgViewDlg.Create(Self) do
    try
      MailMessage:=msArticle1;
      ShowModal;
    finally
      Free;
    end;
  finally
    EnableControls;
    ProgressBar1.Position:=0;
  end;
end;

procedure TNNTPForm.ListNGButtonClick(Sender: TObject);
begin
  with TNGListDlg.Create(Self) do
  try
    NNTPClient:=msNNTPClient1;
    if ShowModal=mrOk then
      NGEdit.Text:=ListBox1.Items[ListBox1.ItemIndex];
  finally
    Free;
  end;
end;

procedure TNNTPForm.msNNTPClient1Connecting(Sender: TObject);
begin
  StatusBar1.Panels[2].Text:='Connecting to the server';
end;

procedure TNNTPForm.msNNTPClient1Disconnected(Sender: TObject);
begin
  StatusBar1.Panels[2].Text:='Disconnected';
end;

procedure TNNTPForm.SaveLogFile1Click(Sender: TObject);
begin
  if msNNTPClient1.LogFileName<>'' then
    msNNTPClient1.SaveLogFile
  else
    MessageDlg('Log file is not assigned',mtError,[mbOk],0);
end;

procedure TNNTPForm.CancelButtonClick(Sender: TObject);
begin
  msNNTPClient1.Cancel;
end;

procedure TNNTPForm.msNNTPClient1Connected(Sender: TObject);
begin
  StatusBar1.Panels[2].Text:='Connected';
end;

procedure TNNTPForm.msNNTPClient1OverviewItemRetrieved(Sender: TObject;
  OverviewItem: TmsOverviewItem);
begin
  AddItemToListView(OverviewItem);
  StatusBar1.Panels[2].Text:=IntToStr(ListView1.Items.Count)+' headers retrieved.';
end;

procedure TNNTPForm.PostButtonClick(Sender: TObject);
var
  i: Integer;
begin
  with TArticleForm.Create(Self) do
  try
    NewsgroupsEdit.Text:=NGEdit.Text;
    if ShowModal=mrOk then
    begin
      msArticle1.Clear;
      msArticle1.Newsgroups:=NewsgroupsEdit.Text;
      msArticle1.Subject:=SubjectEdit.Text;
      msArticle1.Sender.Name:=UserName;
      msArticle1.Sender.Address:=UserAddress;
      msArticle1.Body.Text:=BodyMemo.Text;
      for i:=0 to AttComboBox.Items.Count-1 do
        msArticle1.Attachments.AddFile(AttComboBox.Items[i]);
      StatusBar1.Panels[2].Text:='Posting article';
      msNNTPClient1.Login;
      try
        msNNTPClient1.Post;
        msNNTPClient1.Logout;
        StatusBar1.Panels[2].Text:='Article has been successfully posted';
      except
        on EmsServerError do
        begin
          msNNTPClient1.Logout;
          raise;
        end
        else
          raise;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TNNTPForm.msNNTPClient1TransferProgress(Sender: TObject; Perc,
  ByteCount, LineCount: Longint);
begin
  ProgressBar1.Position:=Perc;
end;

end.
