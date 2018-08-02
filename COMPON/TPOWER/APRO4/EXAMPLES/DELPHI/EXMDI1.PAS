{*********************************************************}
{*                      EXMDI1.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

unit Exmdi1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdPort, OoMisc, ADTrmEmu;

type
  TEXMDIF1 = class(TForm)
    ComPort1: TApdComPort;
    AdTerminal1: TAdTerminal;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EXMDIF1: TEXMDIF1;

implementation

{$R *.DFM}

end.
