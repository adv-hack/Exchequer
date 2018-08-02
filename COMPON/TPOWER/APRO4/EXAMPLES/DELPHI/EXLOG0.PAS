{*********************************************************}
{*                     EXLOG0.PAS                        *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*     Shows all TApdComPort logging options.            *}
{*********************************************************}

unit Exlog0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, AdPort, OoMisc, ADTrmEmu;

type
  TExampleLog = class(TForm)
    LogOps: TRadioGroup;
    Quit: TButton;
    ApdComPort1: TApdComPort;
    AdTerminal1: TAdTerminal;
    procedure QuitClick(Sender: TObject);
    procedure LogOpsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExampleLog: TExampleLog;

implementation

{$R *.DFM}

procedure TExampleLog.QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TExampleLog.LogOpsClick(Sender: TObject);
const
  InClick : Boolean = False;
begin
  if not InClick then begin
    InClick := True;
    ApdComPort1.Logging := TTraceLogState(LogOps.ItemIndex);
    LogOps.ItemIndex := Ord(ApdComPort1.Logging);
    AdTerminal1.SetFocus;
    InClick := False;
  end;
end;

end.
