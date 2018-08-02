{*********************************************************}
{* ABBREVIA: UNZIP.DPR                                   *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program CabExt;

uses
  Forms,
  CabExt1 in 'CabExt1.pas' {Form1};

begin
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
