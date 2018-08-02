{*********************************************************}
{*                      ExSapi.DPR                       *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates using voice recognition and synthesis to *}
{* provide simple voice control and feedback in an       *}
{* Application                                           *}
{*********************************************************}
program ExSapi;

uses
  Forms,
  ExSapi0 in 'ExSapi0.pas' {Form1};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
