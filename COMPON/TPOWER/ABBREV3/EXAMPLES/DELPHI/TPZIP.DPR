{*********************************************************}
{* ABBREVIA: TPZIP.DPR                                   *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program TPZip;

uses
  Forms,
  ubasedlg in 'UBASEDLG.PAS' {BaseDirDlg},
  udemodlg in 'UDEMODLG.PAS' {DemoDlg},
  dgAbout in 'DGABOUT.PAS' {dlgAboutBox},
  usplash in 'USPLASH.PAS' {Splash},
  UMain in 'Umain.pas' {Form1};

{$IFDEF WIN32}
  {$R TPZIP.R32}
{$ELSE}
  {$R TPZIP.R16}
{$ENDIF}

begin
  Application.Title := 'TP Zip';
  Application.HelpFile := 'Tpzip31.hlp';
  Application.CreateForm(TForm1, Form1);
  Splash := TSplash.Create( Application );
  Splash.Show;
  Splash.Refresh;
  Application.Run;
end.
