{*********************************************************}
{*                    ExScrip0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates the use of ApdScript with ApdProtocol    *}
{*      and ApdProtocolStatus displayed on an AdTerminal.*}
{*********************************************************}  

unit ExScrip0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdScript, AdPort, AdProtcl, AdPStat,
  OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Start: TButton;
    ApdScript1: TApdScript;
    Quit: TButton;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    AdTerminal1: TAdTerminal;
    procedure StartClick(Sender: TObject);
    procedure ApdScript1ScriptFinish(CP: TObject; Condition: Integer);
    procedure QuitClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.StartClick(Sender: TObject);
begin
  ApdScript1.StartScript;
end;

procedure TForm1.ApdScript1ScriptFinish(CP: TObject; Condition: Integer);
begin
  ShowMessage('Script finished!');
end;

procedure TForm1.QuitClick(Sender: TObject);
begin
  Close;
end;

end.
