{*********************************************************}
{*                      ExSapiB.DPR                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to create a simple voice telephony   *}
{* application using SAPI                                *}
{*********************************************************}
program ExSapiB;

uses
  Forms,
  ExSapiB0 in 'ExSapiB0.pas' {Form1};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
