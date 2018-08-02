{*********************************************************}
{*                     ExSapiPh.DPR                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates using the TApdSapiPhone component in a   *}
{* more complex voice telephony application.             *}
{*********************************************************}

program ExSapiPh;

uses
  Forms,
  ExSapiP0 in 'ExSapiP0.pas' {Form1};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
