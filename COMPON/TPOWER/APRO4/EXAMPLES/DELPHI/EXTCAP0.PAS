{*********************************************************}
{*                     EXTCAP0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*       Shows all TApdTerminal capture options.         *}
{*********************************************************}

unit Extcap0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdPort, OoMisc, ADTrmEmu, StdCtrls;

type
  TExtCapExample = class(TForm)
    ApdComPort1: TApdComPort;
    AdTerminal1: TAdTerminal;
    Label1: TLabel;
    procedure ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExtCapExample: TExtCapExample;

implementation

{$R *.DFM}

procedure TExtCapExample.ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_Insert :
      AdTerminal1.ScrollBack := not AdTerminal1.Scrollback;
    vk_F8 :
      try
        AdTerminal1.Capture := cmOn;
      except
        ShowMessage('Failed to start capture');
      end;
    vk_F9 :
      try
        AdTerminal1.Capture := cmOff;
      except
        ShowMessage('Failed to close capture file');
      end;
  end;
end;

end.
