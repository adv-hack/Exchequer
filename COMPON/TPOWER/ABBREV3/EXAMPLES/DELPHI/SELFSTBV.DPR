{*********************************************************}
{* ABBREVIA: SELFEXV.DPR                                 *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program Selfstbv;

uses
  Forms,
  Slfstbv1 in 'SLFSTBV1.PAS' {Form1};

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
