{*********************************************************}
{*                     EXMDI20.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*  MDI terminal example, one port shared among all MDI  *}
{*        children.                                      *}
{*********************************************************}

unit Exmdi20;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdPort, OoMisc;

type
  TForm1 = class(TForm)
    ComPort1: TApdComPort;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ComPort1.Open := True;
end;

end.
