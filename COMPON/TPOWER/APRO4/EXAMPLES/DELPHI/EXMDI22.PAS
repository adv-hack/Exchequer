{*********************************************************}
{*                     EXMDI22.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

unit Exmdi22;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdTrmEmu, EXMDI20;

type
  TForm3 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    AdTerminal1 : TAdTerminal;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

procedure TForm3.FormCreate(Sender: TObject);
begin
  {Create the terminal window on the fly...}
  AdTerminal1 := TAdTerminal.Create(Parent);
  AdTerminal1.Parent := Self;
  AdTerminal1.Active := False;
  AdTerminal1.Align := alClient;

  {...hook it up to the comport on Form1 and show it}
  AdTerminal1.ComPort := Form1.ComPort1;
  AdTerminal1.Active := True;
  Show;
end;

end.
