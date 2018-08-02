{*********************************************************}
{* ABBREVIA: CONTENTS.DPR                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program ExCBrows;

uses
  Forms,
  ExCBrowu in 'ExCBrowu.pas' {Form1};

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
