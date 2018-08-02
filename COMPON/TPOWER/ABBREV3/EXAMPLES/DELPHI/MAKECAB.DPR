{*********************************************************}
{* ABBREVIA: MAKECAB.DPR                                 *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program MakeCab;

uses
  Forms,
  MakeCab1 in 'MakeCab1.pas' {Form1};

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
