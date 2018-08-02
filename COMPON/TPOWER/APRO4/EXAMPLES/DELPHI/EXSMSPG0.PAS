{*********************************************************}
{*                   ExSMSPgr.PAS                        *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to use a GSM phone to send an SMS    *)
(* message                                               *}
{*********************************************************}

unit ExSMSPg0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdPort, OoMisc, AdGSM, AdPacket;

type
  TForm1 = class(TForm)
    btnSend: TButton;
    ApdGSMPhone1: TApdGSMPhone;
    ApdComPort1: TApdComPort;
    edtDestAddr: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    lblStatus: TLabel;
    memMessage: TMemo;
    Label3: TLabel;
    procedure btnSendClick(Sender: TObject);
    procedure ApdGSMPhone1GSMComplete(Pager: TApdCustomGSMPhone;
      State: TGSMStates; ErrorCode: Integer);
    procedure memMessageChange(Sender: TObject);
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
begin
  ApdGSMPhone1.SMSAddress := edtDestAddr.Text;
  ApdGSMPhone1.SMSMessage := memMessage.Text;
  ListBox1.Items.Add('Preparing to send message');
  ApdGSMPhone1.SendMessage;
  ListBox1.Items.Add('Message was sent');
end;

procedure TForm1.ApdGSMPhone1GSMComplete(Pager: TApdCustomGSMPhone;
  State: TGSMStates; ErrorCode: Integer);
begin
  if State = gsNone then begin
    ApdComport1.AddStringToLog('Successful Command');
    ListBox1.Items.Add('Successful Command');
  end else begin
    ApdComport1.AddStringToLog('Command Failure');
    ListBox1.Items.Add('Command Failure');
  end;
end;

procedure TForm1.memMessageChange(Sender: TObject);
begin
  Label3.Caption := 'Character count: ' + IntToStr(Length(memMessage.Text));
end;

end.
