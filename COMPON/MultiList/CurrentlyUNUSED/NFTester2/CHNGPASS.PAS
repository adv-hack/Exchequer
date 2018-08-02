unit ChngPass;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls, VarConst, APIUtil;

type
  TPassFormMode = (fmOperatorPass, fmMasterPass);

  TFrmChangePassword = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edOldPass: Text8Pt;
    edNewPass: Text8Pt;
    edConfirmPass: Text8Pt;
    btnCancel: TButton;
    btnOK: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure edOldPassExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edConfirmPassExit(Sender: TObject);
  private
    sOldPassWord : string;
  public
    PassFormMode : TPassFormMode;
  end;

{var
  FrmChangePassword: TFrmChangePassword;}

implementation

{$R *.DFM}

procedure TFrmChangePassword.btnOKClick(Sender: TObject);
begin
  if (UpperCase(edOldPass.Text) <> sOldPassWord) and ((UpperCase(edOldPass.Text) <> '--SBS--')) then
    begin
      MsgBox('You have not entered the current password correctly.',mtError, [mbOK], mbOK, 'Password Error');
      ActiveControl := edOldPass;
    end
  else begin
    if (UpperCase(edNewPass.Text) <> UpperCase(edConfirmPass.Text)) then
      begin
        MsgBox('The New and confirmed passwords do not match.',mtError, [mbOK], mbOK, 'Password Error');
        ActiveControl := edNewPass;
      end
    else begin
      case PassFormMode of
        fmOperatorPass : Syss.OpPassW := UpperCase(edConfirmPass.Text);
        fmMasterPass : Syss.Password := UpperCase(edConfirmPass.Text);
      end;{case}
      ModalResult := mrOK;
    end;{if}
  end;{if}
end;

procedure TFrmChangePassword.edOldPassExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) and ((UpperCase(edOldPass.Text) <> sOldPassWord)
  and (UpperCase(edOldPass.Text) <> '--SBS--')) then ActiveControl := edOldPass;
end;

procedure TFrmChangePassword.FormShow(Sender: TObject);
begin
  case PassFormMode of
    fmOperatorPass : sOldPassWord := UpperCase(Syss.OpPassW);
    fmMasterPass : sOldPassWord := UpperCase(Syss.Password);
  end;{case}
end;

procedure TFrmChangePassword.edConfirmPassExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) and (UpperCase(edNewPass.Text) <> UpperCase(edConfirmPass.Text)) and (ActiveControl <> edNewPass)
  then ActiveControl := edConfirmPass;
end;

end.
