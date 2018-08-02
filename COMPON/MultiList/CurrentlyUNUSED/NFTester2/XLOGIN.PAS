unit login;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls, TCustom, NeilProc, VarConst, CardProc;

type
  TFrmLogin = class(TForm)
    Label1: TLabel;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    Bevel1: TBevel;
    Label2: TLabel;
    lDate: TLabel;
    Label3: TLabel;
    edPassword: Text8Pt;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    iTries : integer;
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  FrmLogin: TFrmLogin;}

implementation

{$R *.DFM}

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  lDate.Caption := DateToStr(Date);
end;

procedure TFrmLogin.btnOKClick(Sender: TObject);
var
  sPassWord : string;
begin
  sPassWord := UpperCase(edPassword.Text);
  if sPassWord = UpperCase(Syss.OpPassW) then LoginMode := lmOperator
  else if sPassWord = UpperCase(Syss.Password) then LoginMode := lmMaster
    else if sPassWord = '..SBS..' then LoginMode := lmUser
      else if sPassWord = '--SBS--' then LoginMode := lmDebug;

  if LoginMode in [lmOperator, lmMaster, lmUser, lmDebug] then
    begin
      ModalResult := mrOK;
      case LoginMode of
        lmUser : TechSuppLog('Logged in under SBS Password 1');
        lmDebug : TechSuppLog('Logged in under SBS Password 2');
      end;{case}
    end
  else begin
    MsgBox('The password you have supplied is incorrect.',mtError,[mbOK],mbOK,'Password Error');
    inc(iTries);
    if iTries = 3 then ModalResult := mrCancel;
  end;{if}
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  LoginMode := lmNone;
  iTries := 0;
end;

end.
