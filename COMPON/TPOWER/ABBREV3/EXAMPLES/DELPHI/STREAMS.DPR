{*********************************************************}
{* ABBREVIA: STREAMS.DPR                                 *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program Streams;

uses
  Forms,
  Streams1 in 'Streams1.pas' {Form1};

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
