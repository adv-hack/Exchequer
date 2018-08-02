unit newfold;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmNewFolder = class(TForm)
    btnOK: TButton;
    Button2: TButton;
    Panel1: TPanel;
    edtFolder: TEdit;
    Label1: TLabel;
    procedure edtFolderChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewFolder: TfrmNewFolder;

implementation

{$R *.dfm}

procedure TfrmNewFolder.edtFolderChange(Sender: TObject);
begin
  btnOk.Enabled := Trim(edtFolder.Text) <> '';
end;

end.
