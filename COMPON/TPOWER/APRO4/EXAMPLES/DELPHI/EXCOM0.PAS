{*********************************************************}
{*                      EXCOM0.PAS                       *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*    TApdComPort with an OnTriggerAvail handler.        *}
{*********************************************************}

unit Excom0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Test: TButton;
    procedure TestClick(Sender: TObject);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.TestClick(Sender: TObject);
  {TestClick button click - Send output}
begin
  ApdComPort1.OutPut := 'ATZ'^M;
end;

procedure TForm1.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
  {Event OnTriggerAvail - Example how OnTriggerAvail works} 
var
  I : Word;
  C : Char;
  S : String;
begin
  S := '';
  for I := 1 to Count do begin
    C := ApdComPort1.GetChar;
    case C of
      #0..#31 : {Don't display} ;
      else S := S + C;
    end;
  end;
  ShowMessage('Got an OnTriggerAvail event for: ' + S);
end;

end.
