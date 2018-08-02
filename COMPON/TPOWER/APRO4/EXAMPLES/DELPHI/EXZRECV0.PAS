{*********************************************************}
{*                     EXZRECV0.PAS                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Shows how to set up a data trigger to listen for a    *}
{*      Zmodem file receive and start the protocol       *}
{*      automatically. Works together with ExZSend.      *}
{*********************************************************}

unit Exzrecv0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdProtcl, AdPStat, AdPort, OoMisc,
  ADTrmEmu, AdTapi;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ApdComPort1: TApdComPort;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    AdTerminal1: TAdTerminal;
    ApdTapiDevice1: TApdTapiDevice;
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure Button1Click(Sender: TObject);
    procedure ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
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
  ZModemHandle := ApdComPort1.AddDataTrigger('rz'#13,False);
  AdTerminal1.Active := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ApdTapiDevice1.AutoAnswer;
end;

procedure TForm1.ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
begin
  if TriggerHandle = ZModemHandle then begin
    ApdComPort1.RemoveTrigger(ZModemHandle);
    AdTerminal1.Active := False;
    ApdProtocol1.StartReceive;
  end;
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  ZModemHandle := ApdComPort1.AddDataTrigger('rz'#13,False);
end;

end.
