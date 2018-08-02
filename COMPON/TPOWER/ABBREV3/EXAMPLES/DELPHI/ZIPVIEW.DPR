{*********************************************************}
{* ABBREVIA: ZIPVIEW.DPR                                 *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program ZipView;

uses
  Forms,
  ZipView1 in 'ZipView1.PAS' {Form1};

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
