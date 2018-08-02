unit pass2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TCustom;

type
  TfrmPassWord = class(TForm)
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    Panel1: TPanel;
    edtPass: TEdit;
    Label1: TLabel;
    edtConfirm: TEdit;
    Label2: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPassWord: TfrmPassWord;

implementation

{$R *.dfm}

procedure TfrmPassWord.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ActiveControl = btnOK then
  begin
    if Trim(edtPass.Text) <> Trim(edtConfirm.Text) then
    begin
      ShowMessage('Confirmation does not match password');
      CanClose := False;
      ActiveControl := edtPass;
    end;
  end;
end;

end.
