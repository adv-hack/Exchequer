unit nntpmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, msmsg, Mssocket, msNNTP;

type
  TForm1 = class(TForm)
    msNNTPClient1: TmsNNTPClient;
    msArticle1: TmsArticle;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ServerEdit: TEdit;
    NewsgroupEdit: TEdit;
    SearchEdit: TEdit;
    SearchButton: TButton;
    BodyMemo: TMemo;
    procedure SearchButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SearchButtonClick(Sender: TObject);
var
  i: Integer;
  Found: boolean;
begin
  msNNTPClient1.Host:=ServerEdit.Text;
  msNNTPClient1.Login;
  msNNTPClient1.Newsgroup:=NewsgroupEdit.Text;
  msNNTPClient1.GetOverview(msNNTPClient1.FirstArticle,
    msNNTPClient1.LastArticle);
  Found:=false;
  for i:=0 to msNNTPClient1.Overview.Count-1 do
  begin
    Found:=Pos(LowerCase(SearchEdit.Text),
      LowerCase(msNNTPClient1.Overview[i].Subject))>0;
    if Found then Break;
  end;
  if Found then
  begin
    msNNTPClient1.CurrentArticle:=msNNTPClient1.Overview[i].ArticleNo;
    msNNTPClient1.Retrieve;
    BodyMemo.Lines:=msArticle1.Body;
  end
  else
    ShowMessage('Cannot find the article');
  msNNTPClient1.Logout;
end;

end.
