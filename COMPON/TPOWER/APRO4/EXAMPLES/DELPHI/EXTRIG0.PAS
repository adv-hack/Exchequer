{*********************************************************}
{*                     EXTRIG0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* TApdComPort with all OnTriggerXxx event handlers.     *}
{*********************************************************}

{$APPTYPE CONSOLE}
unit Extrig0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, AdPort, OoMisc;

type
  TExTrigTest = class(TForm)
    ApdComPort1: TApdComPort;
    StartTest: TButton;
    Label1: TLabel;
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure ApdComPort1TriggerData(CP: TObject; TriggerHandle : Word);
    procedure ApdComPort1TriggerTimer(CP: TObject; TriggerHandle: Word);
    procedure StartTestClick(Sender: TObject);
  private
    { Private declarations }
    TimerHandle : Word;
    Data1Handle  : Word;
    Data2Handle  : Word;
    Data3Handle  : Word;
  public
    { Public declarations }
  end;

var
  ExTrigTest: TExTrigTest;

implementation

{$R *.DFM}

procedure WriteIt(C : Char);
begin
  if Ord(C) > 32 then
    Write(C)
  else
    Write('[', Ord(C), ']');
end;

procedure TExTrigTest.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
var
  I : Word;
  C : Char;
begin
  WriteLn('OnTriggerAvail event: ', Count, ' bytes received');
  for I := 1 to Count do begin
    C := ApdComPort1.GetChar;
    WriteIt(C);
  end;
  WriteLn;
  WriteLn('--------');
end;

procedure TExTrigTest.ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
begin
  WriteLn('OnTriggerData event: ', TriggerHandle);
end;

procedure TExTrigTest.ApdComPort1TriggerTimer(CP: TObject;
  TriggerHandle: Word);
begin
  WriteLn('OnTriggerTimer event: ', TriggerHandle);
end;

procedure TExTrigTest.StartTestClick(Sender: TObject);
begin
  TimerHandle := ApdComPort1.AddTimerTrigger;
  ApdComPort1.SetTimerTrigger(TimerHandle, 91, True);
  Data1Handle := ApdComPort1.AddDataTrigger('TI', True);
  Data2handle := ApdComPort1.AddDataTrigger('OK', True);
  Data3handle := ApdComPort1.AddDataTrigger('288', True);

  {Send a string to a modem that will hit all triggers}
  ApdComPort1.PutString('ATI'^M);
end;

end.
