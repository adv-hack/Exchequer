{*********************************************************}
{* ABBREVIA: ZIPPER.DPR                                  *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program zipper;

uses
  Forms,
  Uzip in 'Uzip.pas' {Form1};

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
