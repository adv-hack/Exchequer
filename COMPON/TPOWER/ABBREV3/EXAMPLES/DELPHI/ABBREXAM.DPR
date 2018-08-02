{*********************************************************}
{* ABBREVIA: ABBREXAM.DPR                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program Abbrexam;

uses
  Forms,
  udemodlg in 'udemodlg.pas' {DemoDlg},
  uexample in 'Uexample.pas' {Form1};

begin
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDemoDlg, DemoDlg);
  Application.Run;
end.
