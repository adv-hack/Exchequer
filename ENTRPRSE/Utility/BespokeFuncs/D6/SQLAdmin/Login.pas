unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , APIUtil, StdCtrls, ExtCtrls, Dialogs, SpecialPassword;

const
  iKey = 34;

type
  TfrmLogin = class(TForm)
    Label1: TLabel;
    edPassword: TEdit;
    Bevel1: TBevel;
    btnCancel: TButton;
    btnOK: TButton;
    procedure btnCancelClick(Sender: TObject);
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

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.btnOKClick(Sender: TObject);
begin
  if CheckPassword({iKey,} edPassword.Text)
  then ModalResult := mrOK
  else MsgBox('Incorrect Password', mtWarning, [mbOK], mbOK, 'Login');
end;

end.
