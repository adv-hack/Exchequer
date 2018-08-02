{*********************************************************}
{*                    EXTMAIN0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* How to use TApdTerminal with the alClient alignment   *}
{*      option.                                          *}
{*********************************************************}

unit Extmain0;

interface

uses
  WinTypes,
  WinProcs,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  Forms,
  Dialogs,
  ADTrmEmu,
  AdPort, OoMisc;

type
  TEXTMainForm = class(TForm)
    ApdComPort1: TApdComPort;
    AdTerminal1: TAdTerminal;
    procedure ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure WMGetMinMaxInfo(var Msg : TWMGetMinMaxInfo);
      message WM_GETMINMAXINFO;
  public
    { Public declarations }
  end;

var
  EXTMainForm: TEXTMainForm;

implementation

{$R *.DFM}

procedure TEXTMainForm.WMGetMinMaxInfo(var Msg : TWMGetMinMaxInfo);
var
  FrameWidth : Word;
  FrameHeight : Word;
  NewWidth : Word;
  NewHeight : Word;
begin
  FrameWidth := Width - ClientWidth - 1;
  FrameHeight := Height - ClientHeight - 1;
  NewWidth := (AdTerminal1.CharWidth * AdTerminal1.Columns)
              + FrameWidth;
  NewHeight := (AdTerminal1.CharHeight * AdTerminal1.Rows)
               + FrameHeight;

  Msg.MinMaxInfo^.ptMaxSize.Y := NewHeight;
  Msg.MinMaxInfo^.ptMaxSize.X := NewWidth;
  Msg.MinMaxInfo^.ptMaxTrackSize.Y := NewHeight;
  Msg.MinMaxInfo^.ptMaxTrackSize.X := NewWidth;
end;

procedure TEXTMainForm.ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Insert then
    AdTerminal1.ScrollBack := not AdTerminal1.Scrollback;
end;

end.
