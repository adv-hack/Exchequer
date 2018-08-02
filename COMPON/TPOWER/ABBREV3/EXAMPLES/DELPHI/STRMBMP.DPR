{*********************************************************}
{* ABBREVIA: STRMBMP.DPR                                 *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program StrmBmp;

uses
  Forms,
  StrmBmpU in 'StrmBmpU.pas' {Form1};

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
