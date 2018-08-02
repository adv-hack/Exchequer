{*********************************************************}
{*                     ExSapiDl.DPR                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to access all the built in           *}
{* configuration dialogs in SAPI                         *}
{*********************************************************}
program ExSapiDl;

uses
  Forms,
  ExSapiD0 in 'ExSapiD0.pas' {Form1};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
