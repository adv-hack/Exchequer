{*********************************************************}
{* ABBREVIA: COMPPAD.DPR                                 *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program CompPad;

uses
  Forms,
  ucomppad in 'UCOMPPAD.PAS' {Form1};

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
