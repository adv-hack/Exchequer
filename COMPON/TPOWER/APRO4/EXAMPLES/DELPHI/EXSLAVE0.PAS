{*********************************************************}
{*                    EXSLAVE0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

unit ExSlave0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AdPort, Buttons, OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    AdTerminal1: TAdTerminal;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormShow(Sender: TObject);
begin
  ApdComPort1.Open := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ApdComPort1.Open := False;
end;

end.
