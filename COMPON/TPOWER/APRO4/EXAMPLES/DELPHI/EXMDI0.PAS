{*********************************************************}
{*                      EXMDI0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*MDI terminal example, one port per MDI child.          *}
{*********************************************************}

unit Exmdi0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs;

type
  TEXMDIF0 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EXMDIF0: TEXMDIF0;

implementation

{$R *.DFM}

end.
