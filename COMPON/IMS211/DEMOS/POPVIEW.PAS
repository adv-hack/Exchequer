unit popview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls, ComCtrls, msmsg,
{$IFDEF VER120}
  ImgList,
{$ENDIF}
  ShellApi;

type
  TMsgViewDlg = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FromLabel: TLabel;
    DateLabel: TLabel;
    SubjectLabel: TLabel;
    AttListView: TListView;
    BodyMemo: TMemo;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Execute1: TMenuItem;
    Save1: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AttListViewDblClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { Private declarations }
    TempPath : string;
    FMessage : TmsCustomMessage;
    procedure AddFileToListView(const FileName : string);
    procedure SetMessage(Value : TmsCustomMessage);
  public
    { Public declarations }
    property MailMessage : TmsCustomMessage write SetMessage;
  end;

var
  MsgViewDlg: TMsgViewDlg;

implementation

{$R *.DFM}

uses msUtils;

procedure TMsgViewDlg.AddFileToListView(const FileName : string);
var
  Item : TListItem;
  Icon : TIcon;
  j : word;
begin
  Item:=AttListView.Items.Add;
  Item.Caption:=ExtractFileName(FileName);
  Icon:=TIcon.Create;
  j:=0;
  Icon.Handle:=ExtractAssociatedIcon(hInstance,PChar(FileName),j);
  if Icon.Handle<>0 then
    Item.ImageIndex:=ImageList1.AddIcon(Icon);
end;

procedure TMsgViewDlg.SetMessage(Value : TmsCustomMessage);
var
  i : Integer;
  Path : string;
  s1, s2 : string;
  DT : TDateTime;
  TZ: ShortString;
begin
  FMessage:=Value;
  BodyMemo.Lines:=FMessage.Body;
  s1:=FMessage.Headers.GetFieldBody('From');
  SplitAddress(s1,s1,s2);
  if s2<>'' then
    FromLabel.Caption:=s2
  else
    FromLabel.Caption:=s1;
  s1:=FMessage.Headers.GetFieldBody('Date');
  MailDateToDateTime(s1,DT,TZ);
  if DT<>0 then
    DateLabel.Caption:=DateTimeToStr(DT)+' '+TZ
  else
    DateLabel.Caption:='Unknown';
  SubjectLabel.Caption:=FMessage.Headers.GetFieldBody('Subject');
  if FMessage.Attachments.Count=0 then
  begin
    AttListView.Visible:=false;
  end;
  for i:=0 to FMessage.Attachments.Count-1 do
  begin
    FMessage.SaveAttachment(i,TempPath);
    Path:=TempPath+FMessage.Attachments[i].FileName;
    AddFileToListView(Path);
  end;
end;

procedure TMsgViewDlg.FormCreate(Sender: TObject);
var
  Buf : PChar;
begin
  Buf:=StrAlloc(255);
  GetTempPath(255,Buf);
  TempPath:=StrPas(Buf);
  StrDispose(Buf);
end;

procedure TMsgViewDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i : Integer;
  F : file;
begin
  if Assigned(FMessage) then
  begin
    for i:=0 to FMessage.Attachments.Count-1 do
    begin
      AssignFile(F,TempPath+FMessage.Attachments[i].FileName);
      System.Erase(F);
    end;
  end;
end;

procedure TMsgViewDlg.AttListViewDblClick(Sender: TObject);
var
  s : string;
  TheHandle : THandle;
  i : Integer;
begin
  if AttListView.Selected<>nil then
  begin
    i:=AttListView.Selected.Index;
    s:=TempPath+AttListView.Items[i].Caption;
    TheHandle:=ShellExecute(Application.Handle,'Open',PChar(s),nil,nil,SW_SHOW);
    if TheHandle<=HINSTANCE_ERROR then
      raise Exception.Create('Unable to run ShellExec. Error code='+IntToStr(TheHandle));
  end;
end;

procedure TMsgViewDlg.Save1Click(Sender: TObject);
begin
  if AttListView.Selected<>nil then
  begin
    SaveDialog1.FileName:=AttListView.Items[AttListView.Selected.Index].Caption;
    if SaveDialog1.Execute then
      FMessage.Attachments[AttListView.Selected.Index].Contents.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TMsgViewDlg.PopupMenu1Popup(Sender: TObject);
begin
  if AttListView.Selected=nil then
  begin
    Execute1.Enabled:=false;
    Save1.Enabled:=false;
  end
  else
  begin
    Execute1.Enabled:=true;
    Save1.Enabled:=true;
  end;
end;

end.
