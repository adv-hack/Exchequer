{*********************************************************}
{*                    EXTAPIA0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* TAPI example that can answer calls                    *}
{*********************************************************}

unit extapia0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdTStat, AdPort, OoMisc, ADTrmEmu,
  AdTapi;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdTapiDevice1: TApdTapiDevice;
    ApdTapiStatus1: TApdTapiStatus;
    ApdTapiLog1: TApdTapiLog;
    Answer: TButton;
    Hangup: TButton;
    AdTerminal1: TAdTerminal;
    procedure AnswerClick(Sender: TObject);
    procedure HangupClick(Sender: TObject);
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

procedure TForm1.AnswerClick(Sender: TObject);
begin
  ApdTapiDevice1.AutoAnswer;
  AdTerminal1.WriteString('waiting for incoming calls'^M^J);
end;

procedure TForm1.HangupClick(Sender: TObject);
begin
  ApdTapiDevice1.CancelCall;
  AdTerminal1.WriteString(^M^J'not waiting for incoming calls'^M^J);
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  AdTerminal1.SetFocus;
end;

end.
