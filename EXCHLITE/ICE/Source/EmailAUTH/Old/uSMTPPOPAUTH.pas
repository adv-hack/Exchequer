unit uSMTPPOPAUTH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdSMTP, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdMessageClient, IdPOP3, StdCtrls, IdIntercept,
  IdSSLIntercept, IdSSLOpenSSL, Mask, AdvSpin, IdMessage, SmtpProt,
  Pop3Prot;

type
  TForm1 = class(TForm)
    SMTP: TIdSMTP;
    IdConnectionInterceptOpenSSL1: TIdConnectionInterceptOpenSSL;
    btnSend: TButton;
    edtHost: TEdit;
    Label1: TLabel;
    edtUser: TEdit;
    Label2: TLabel;
    edtPassword: TEdit;
    Label3: TLabel;
    edtTo: TEdit;
    Label4: TLabel;
    ckbAuth: TCheckBox;
    edtMessage: TEdit;
    Label5: TLabel;
    edtPort: TAdvSpinEdit;
    ListBox1: TListBox;
    Label6: TLabel;
    IdMessage: TIdMessage;
    Button1: TButton;
    SmtpCli1: TSmtpCli;
    procedure btnSendClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnSendClick(Sender: TObject);
var
  lStr: TStringList;
begin
{ add an attachement

TIdAttachment.Create(IdMsgSend.MessageParts, OpenDialog1.FileName);

}



  IdMessage.ReceiptRecipient.Address := edtTo.Text;
  IdMessage.Body.Text := edtMessage.Text;
  IdMessage.Subject := 'test';
  IdMessage.From.Address := 'vinicios.demoura@iris.co.uk';

  SMTP.Port := edtPort.Value;
  SMTP.Host := edtHost.Text;
  
  if ckbAuth.Checked then
  begin
    lStr:= TStringList.Create;
    SMTP.UserId := edtUser.Text;
    Smtp.Password := edtPassword.Text;
//    SMTP.InterceptEnabled := True;
    SMTP.AuthenticationType := atLogin;
    SMTP.Connect;
    if SMTP.Connected then
    begin
      ShowMessage('smtp connected');
//      lStr.Assign(SMTP.AuthSchemesSupported);
//      ListBox1.Items.AddStrings(lStr);

      smtp.Send(IdMessage);
      smtp.Disconnect;
    end
    else
      ShowMessage('could not connect');

    lStr.Free;
  end
  else
    SMTP.QuickSend(edtHost.Text, 'test', edtTo.Text, 'vinicios.demoura@iris.co.uk', edtMessage.Text);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SmtpCli1.AuthType := smtpAuthAutoSelect;
  SmtpCli1.Host := edtHost.Text;
  SmtpCli1.Username := edtUser.Text;
  SmtpCli1.Password := edtPassword.Text;
  SmtpCli1.Port := edtPort.Text;
  SmtpCli1.HdrFrom := 'thebarstool@yahoo.co.uk';
  SmtpCli1.HdrTo := 'vinicios.demoura@iris.co.uk';
  SmtpCli1.HdrSubject := 'test';
  SmtpCli1.MailMessage.Add('hola');

  SmtpCli1.Connect;

  SmtpCli1.

  if SmtpCli1.Connected then
    SmtpCli1.Mail;

end;

end.
