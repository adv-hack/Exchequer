Unit uSMTPindy10;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin;

Type
  TForm1 = Class(TForm)
    Memo1: TMemo;
    edtUser: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtPassword: TEdit;
    edtPOPHost: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    seSMTP: TSpinEdit;
    Label7: TLabel;
    sePOP: TSpinEdit;
    edtSubject: TEdit;
    edtMessage: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    edtTo: TEdit;
    Label10: TLabel;
    Label1: TLabel;
    edtSMTPHost: TEdit;
    ckbAuthentication: TCheckBox;
    Label2: TLabel;
    edtFrom: TEdit;
    rbtls: TRadioGroup;
    rbAuth: TRadioGroup;
    ckbSASL: TCheckBox;
    ckbPassTh: TCheckBox;
    rbSSLVersion: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    Memo2: TMemo;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  Form1: TForm1;

Implementation

uses
uPOP3, uMailMessage, uSMTP, uMailMessageAttach, uIMAP, uMAPI
;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  lPOP3: TPOP3;
  lMsgCount, lCont: Integer;
  lMsg: TMailMessage;
begin
  lPOP3:= TPOP3.Create;

  Memo1.Lines.Clear;

  lPOP3.Host := edtPOPHost.Text;
  lPOP3.UserName := edtUser.Text;
  lPOP3.Password := edtPassword.Text;
  lPOP3.IncomingPort := sePOP.Value;

  lPOP3.UseAuthentication := ckbAuthentication.Checked;

  lPOP3.Connected := True;

  If lPOP3.Connected Then
  Begin
    lMsgCount := lPOP3.MessageCount;

    For lCont := lMsgCount - 1 downto 0 Do
    Begin
      lMsg := lPOP3[lCont];
      if lMsg <> nil then
      begin
        Memo1.Lines.Add(lMsg.SenderName + ' ' + lMsg.SenderAddress + ' ' + lMsg.Subject);
        Memo2.Lines.Text := lMsg.Body.Text;
//        Memo2.Lines.SaveToFile('c:\' + inttostr(lcont) + '.txt');
      end;

      lMsg.Free;  
    End;
  End;

  lPOP3.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  lSmtp: TSMTP;
  lMail: TMailMessage;
begin
  lSmtp:= TSMTP.Create;

  lSmtp.Host := edtSMTPHost.Text;
  lSmtp.UserName := edtUser.Text;
  lSmtp.Password := edtPassword.Text;
  lSmtp.OutgoingPort := seSMTP.Value;

  lSmtp.UseAuthentication := ckbAuthentication.Checked;

  lSmtp.Connected := True;

  if lSmtp.Connected then
  begin
    lMail:= TMailMessage.Create;
    lMail.LoadFileFromDir('C:\Projects\Ice\Bin\Outbox\{0B52F809-4AAC-4E08-BA33-A8D7E3FD8891}', '*.xml');
    lMail.SenderName := 'vhmoura';
    lMail.SenderAddress := 'vhmoura@yahoo.com';
    lMail.Body.Text := 'hello there...';
    lMail.Subject := 'Test Authentication';
    lMail.To_.Add('vinicios.demoura@iris.co.uk');
//    with lMail.AddAttachment do
//      FileName := 'c:\2.xml';

     if lSmtp.SendMail(lMail) then
      ShowMessage('Sent')
    else
      ShowMessage('not Sent');
      
    lMail.Free;
  end;

  lSmtp.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  lIMAP: TIMAPReceiver;
  lMsgCount, lCont: Integer;
  lMsg: TMailMessage;
begin
  lIMAP:= TIMAPReceiver.Create;
  lIMAP.MailBox := 'inbox';
  lImap.MailBoxSeparator := '.';

  Memo1.Lines.Clear;

  lIMAP.Host := edtPOPHost.Text;
  lIMAP.UserName := edtUser.Text;
  lIMAP.Password := edtPassword.Text;
  lIMAP.IncomingPort := sePOP.Value;

  lIMAP.UseAuthentication := ckbAuthentication.Checked;

  lIMAP.Connected := True;

  If lIMAP.Connected Then
  Begin
    lIMAP.SelectMailBox;

    lMsgCount := lIMAP.MessageCount;

    For lCont := 1 To lMsgCount Do
    Begin
      lMsg := lIMAP[lCont];
      if lMsg <> nil then
      begin
        Memo1.Lines.Add(lMsg.SenderName + ' ' + lMsg.SenderAddress + ' ' + lMsg.Subject);
        Memo2.Lines.Text := lMsg.Body.Text;
      end;

      lMsg.Free;
    End;
  End;

  lIMAP.Free;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  lMAPI: TMAPI;
  lMsgCount, lCont: Integer;
  lMsg: TMailMessage;
begin
  lMAPI:= TMAPI.Create;

  Memo1.Lines.Clear;

  lMAPI.UserName := edtUser.Text;

  lMAPI.Connected := True;

  If lMAPI.Connected Then
  Begin
    lMsgCount := lMAPI.MessageCount;

    For lCont := lMsgCount - 1 downTo 0 Do
    Begin
      lMsg := lMAPI[lCont];
      if lMsg <> nil then
      begin
        Memo1.Lines.Add(lMsg.SenderName + ' ' + lMsg.SenderAddress + ' ' + lMsg.Subject);
        Memo2.Lines.Text := lMsg.Body.Text;
      end;

      lMsg.Free;
    End;
  End;

  lMAPI.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  lMAPI: TMAPI;
  lMail: TMailMessage;
begin
  lMAPI:= TMAPI.Create;

  lMAPI.Connected := True;

  if lMAPI.Connected then
  begin
    lMail:= TMailMessage.Create;
    lMail.SenderName := 'vhmoura';
    lMail.SenderAddress := 'vinicios.demoura@iris.co.uk';
    lMail.Body.Text := 'hello there...';
    lMail.Subject := 'Test Authentication';
    lMail.To_.Add('redbaron@exchequer.com');
    with lMail.AddAttachment do
      FileName := 'c:\2.xml';

     if lMAPI.SendMail(lMail) then
      ShowMessage('Sent')
    else
      ShowMessage('not Sent');

    lMail.Free;
  end;

  lMAPI.Free;
end;

End.

