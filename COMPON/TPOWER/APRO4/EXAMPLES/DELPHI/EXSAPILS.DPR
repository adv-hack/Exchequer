{*********************************************************}
{*                     ExSapiLs.DPR                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Lists all installed SAPI voice recognition and speech *}
{* synthesis engines.  Provides a large amount of detail *}
{* on each engine.                                       *}
{*********************************************************}
program ExSapiLs;

uses
  Forms,
  ExSapiL0 in 'ExSapiL0.pas' {Form1},
  ExSapiL1 in 'ExSapiL1.pas' {frmLoading};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
