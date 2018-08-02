{*********************************************************}
{*                    EXTRACE0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*            Shows all tracing options.                 *}
{*********************************************************}

unit Extrace0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort, ExtCtrls, OoMisc, ADTrmEmu;

type
  TExampleTrace = class(TForm)
    TraceOps: TRadioGroup;
    ApdComPort1: TApdComPort;
    Quit: TButton;
    AdTerminal1: TAdTerminal;
    procedure QuitClick(Sender: TObject);
    procedure TraceOpsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExampleTrace: TExampleTrace;

implementation

{$R *.DFM}

procedure TExampleTrace.QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TExampleTrace.TraceOpsClick(Sender: TObject);
begin
  ApdComPort1.Tracing := TTraceLogState(TraceOps.ItemIndex);
  TraceOps.ItemIndex := Ord(ApdComPort1.Tracing);
  AdTerminal1.SetFocus;
end;

end.
