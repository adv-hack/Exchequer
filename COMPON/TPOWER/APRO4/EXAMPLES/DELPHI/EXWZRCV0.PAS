{*********************************************************}
{*                     EXWZRCV0.PAS                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to connect to a telnet server, and   *}
{*        automatically download a file using zmodem     *}
{*        (similar to ExZRecv but uses Winsock).         *}
{*********************************************************}

unit EXWZRCV0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdProtcl, AdPStat, AdPort, StdCtrls, AdWnPort,
  FileCtrl, AwWnSock, AdStatLt, OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    ApdWinsockPort1: TApdWinsockPort;
    Edit1: TEdit;
    AdTerminal1: TAdTerminal;
    AdVT100Emulator1: TAdVT100Emulator;
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure Button1Click(Sender: TObject);
    procedure ApdWinsockPort1TriggerData(CP: TObject; TriggerHandle: Word);
    procedure ApdWinsockPort1WsConnect(Sender: TObject);
    procedure ApdWinsockPort1WsDisconnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

var
  ZModemHandle : Word;

{$R *.DFM}

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  ZModemHandle := ApdWinsockPort1.AddDataTrigger('rz'#13,False);
  AdTerminal1.Active := True;
  AdTerminal1.SetFocus;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not ApdWinsockPort1.Open then
    ApdWinsockPort1.WsAddress := Edit1.Text;
  ApdWinsockPort1.Open := not(ApdWinsockPort1.Open);
end;

procedure TForm1.ApdWinsockPort1TriggerData(CP: TObject; TriggerHandle: Word);
begin
  if TriggerHandle = ZModemHandle then begin
    ApdWinsockPort1.RemoveTrigger(ZModemHandle);
    AdTerminal1.Active := False;
    ApdProtocol1.StartReceive;
  end;
end;

procedure TForm1.ApdWinsockPort1WsConnect(Sender: TObject);
begin
  ApdProtocol1ProtocolFinish(Self, 0);
  Button1.Caption := 'Disconnect';
end;

procedure TForm1.ApdWinsockPort1WsDisconnect(Sender: TObject);
begin
  Button1.Caption := 'Connect';
end;

end.
