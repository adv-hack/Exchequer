unit nntppst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TArticleForm = class(TForm)
    Panel1: TPanel;
    BodyMemo: TMemo;
    Label2: TLabel;
    NewsGroupsEdit: TEdit;
    Label3: TLabel;
    SubjectEdit: TEdit;
    Panel2: TPanel;
    AttachButton: TButton;
    PostButton: TButton;
    CancelButton: TButton;
    Label4: TLabel;
    AttComboBox: TComboBox;
    OpenDialog1: TOpenDialog;
    procedure AttachButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ArticleForm: TArticleForm;

implementation

{$R *.DFM}

procedure TArticleForm.AttachButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    AttComboBox.Items.Add(OpenDialog1.FileName);
end;

end.
