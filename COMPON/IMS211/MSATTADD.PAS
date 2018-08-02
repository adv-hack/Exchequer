(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msattadd;

{$I msdef.inc}

interface

uses
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TAttEditDlg = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    FileNameEdit: TEdit;
    BrowseButton: TButton;
    OKButton: TButton;
    CancelButton: TButton;
    HelpButton: TButton;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    ContentTypeEdit: TEdit;
    Label3: TLabel;
    EncodingBox: TComboBox;
    procedure BrowseButtonClick(Sender: TObject);
    procedure FileNameEditExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AttEditDlg: TAttEditDlg;

implementation

uses msUtils;

{$R *.DFM}

procedure TAttEditDlg.BrowseButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    FileNameEdit.Text:=OpenDialog1.FileName;
    FileNameEditExit(Sender);
  end;
end;

procedure TAttEditDlg.FileNameEditExit(Sender: TObject);
begin
  if FileNameEdit.Text<>'' then
  begin
    ContentTypeEdit.Text:=GetContentType(FileNameEdit.Text);
    if (UpperCase(ContentTypeEdit.Text)='TEXT/PLAIN') or
      (UpperCase(ContentTypeEdit.Text)='TEXT/RTF') or
      (UpperCase(ContentTypeEdit.Text)='TEXT/HTML') then
         EncodingBox.ItemIndex:=2
    else
    if (UpperCase(ContentTypeEdit.Text)='MESSAGE/RFC822') then
         EncodingBox.ItemIndex:=0
    else
      EncodingBox.ItemIndex:=1;
  end;
end;

end.
