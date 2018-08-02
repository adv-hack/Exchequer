unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmLogin = class(TForm)
    edPassword: TEdit;
    Label1: TLabel;
    Bevel1: TBevel;
    btnCancel: TButton;
    btnOK: TButton;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
