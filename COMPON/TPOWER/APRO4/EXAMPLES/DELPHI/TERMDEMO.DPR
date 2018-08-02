{$I-,G+,X+,F+}

{Conditional defines that may affect this unit}
{$I AWDEFINE.INC}

{*********************************************************}
{*                   TERMDEMO.DPR 2.10                   *}
{*        Copyright (c) TurboPower Software 1996         *}
{*                 All rights reserved.                  *}
{*********************************************************}

program Termdemo;

uses
  Forms,
  Tdmain in 'TDMAIN.PAS' {MainForm},
  AdXPort {in '..\ADXPORT.PAS'};

{ Note : For the Delphi project manager to display the forms belonging to
         a project, the project must have the "in XXX.PAS" part of the 'USES'
         statement.  However, the "in XXX.PAS" statement will not search
         the directories declared in the project options; a path to these
         files must be present if the units & forms are not in the current
         directory.  Our choice was to leave the statements commented out
         and have the units & forms not appear in the project manager
         rather than have path assumptions hard-coded into the project. }

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TComPortOptions, ComPortOptions);
  Application.Run;
end.
