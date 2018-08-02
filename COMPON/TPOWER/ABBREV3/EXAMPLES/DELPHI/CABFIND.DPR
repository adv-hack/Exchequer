{*********************************************************}
{* ABBREVIA: FINDER.DPR                                  *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program CabFind;

uses
  Forms,
  CabFind1 in 'CabFind1.pas' {Form1};

begin

  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
