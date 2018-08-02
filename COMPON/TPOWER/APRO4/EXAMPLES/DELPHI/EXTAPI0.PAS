{*********************************************************}
{*                     EXTAPI0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}


{**********************Description************************}
{* TAPI example that can answer calls and dial calls.    *}
{*********************************************************}

unit EXTAPI0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort, AdTapi, AdTStat, OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    Dial: TButton;
    ApdTapiDevice1: TApdTapiDevice;
    ApdComPort1: TApdComPort;
    ApdTapiStatus1: TApdTapiStatus;
    Config: TButton;
    Answer: TButton;
    Cancel: TButton;
    ApdTapiLog1: TApdTapiLog;
    AdTerminal1: TAdTerminal;
    procedure DialClick(Sender: TObject);
    procedure ConfigClick(Sender: TObject);
    procedure AnswerClick(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(CP: TObject);
    procedure ApdTapiDevice1TapiPortClose(CP: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ApdTapiDevice1TapiConnect(Sender: TObject);
    procedure ApdTapiDevice1TapiFail(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DialClick(Sender: TObject);
begin
  ApdTapiDevice1.Dial('522-1049');
end;

procedure TForm1.AnswerClick(Sender: TObject);
begin
  AdTerminal1.WriteString(' ** Waiting for incoming call...');
  ApdTapiDevice1.AutoAnswer;
end;

procedure TForm1.ConfigClick(Sender: TObject);
begin
  ApdTapiDevice1.ShowConfigDialog;
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(CP: TObject);
begin
  AdTerminal1.WriteString(#13#10#13#10' ** TAPI port opened'#13#10);
  AdTerminal1.SetFocus;
end;

procedure TForm1.ApdTapiDevice1TapiPortClose(CP: TObject);
begin
  if csDesigning in ComponentState then Exit;
  AdTerminal1.WriteString(#13#10#13#10' ** TAPI port closed'#13#10);
end;

procedure TForm1.CancelClick(Sender: TObject);
begin
  ApdTapiDevice1.CancelCall;
end;

procedure TForm1.ApdTapiDevice1TapiConnect(Sender: TObject);
begin
  AdTerminal1.WriteString(#13#10#13#10' ** TAPI connect'#13#10);
end;

procedure TForm1.ApdTapiDevice1TapiFail(Sender: TObject);
begin
  if csDesigning in ComponentState then Exit;
  AdTerminal1.WriteString(#13#10#13#10' ** TAPI fail'#13#10);
end;

end.
