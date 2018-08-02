{*********************************************************}
{*                     EXZSEND0.PAS                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Shows how to originate a data call and start a Zmodem *}
{* file send automatically.  Works together with ExZRecv.*}
(* In general, you will not want to start a protocol     *)
(* transfer from the OnTapiPortOpen event, you will      *)
(* usually want to conduct some form of authentication   *)
(* or synchronization so both sides start at roughly the *)
(* same time.                                            *)
{*********************************************************}

unit Exzsend0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdProtcl, AdPStat, AdPort, OoMisc, ADTrmEmu,
  AdTapi;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ApdComPort1: TApdComPort;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    Edit1: TEdit;
    Label1: TLabel;
    AdTerminal1: TAdTerminal;
    ApdTapiDevice1: TApdTapiDevice;
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure Button1Click(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  AdTerminal1.Active := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ApdTapiDevice1.Dial(Edit1.Text);
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  ApdProtocol1.StartTransmit;
  AdTerminal1.Active := False;
end;

end.
