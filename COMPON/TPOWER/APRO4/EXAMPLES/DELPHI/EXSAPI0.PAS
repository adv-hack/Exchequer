{*********************************************************}
{*                     ExSapi0.PAS                       *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates using voice recognition and synthesis to *}
{* provide simple voice control and feedback in an       *}
{* Application                                           *}
{*********************************************************}
unit ExSapi0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OoMisc, AdSapiEn, Gauges;

type
  TPhraseType = (ptHelp, ptQuiet, ptDate, ptTime, ptQuit,
                 ptUnknown);

  TForm1 = class(TForm)
    Button1: TButton;
    ApdSapiEngine1: TApdSapiEngine;
    Memo1: TMemo;
    Gauge1: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    function AnalyzePhrase (Phrase : string) : TPhraseType;
    procedure SaySomething (Something : string);
    procedure Button1Click(Sender: TObject);
    procedure ApdSapiEngine1VUMeter(Sender: TObject; Level: Integer);
    procedure ApdSapiEngine1PhraseFinish(Sender: TObject;
      const Phrase: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function TForm1.AnalyzePhrase (Phrase : string) : TPhraseType;
begin
  Result := ptUnknown;
  if Phrase = 'help' then
    Result := ptHelp
  else if (Phrase = 'close') or (Phrase = 'exit') or
          (Phrase = 'goodbye') or (Phrase = 'end') or
          (Phrase = 'bye') then
    Result := ptQuit
  else if (Phrase = 'stop speaking') or (Phrase = 'hush') or
          (Phrase = 'be quiet') or (Phrase =  'quiet') or
          (Phrase = 'shut up') then
    Result := ptQuiet
  else if (Phrase = 'what time is it') or (Phrase = 'time') then
    Result := ptTime
  else if (Phrase = 'what day is it') or (Phrase = 'day') then
    Result := ptDate;
end;

procedure TForm1.SaySomething (Something : string);
begin
  Memo1.Lines.Add ('--> ' + Something);
  ApdSapiEngine1.Speak (Something);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  with ApdSapiEngine1.WordList do begin
    Clear;
    Add ('close');
    Add ('exit');
    Add ('goodbye');
    Add ('end');
    Add ('bye');

    Add ('stop speaking');
    Add ('hush');
    Add ('be quiet');
    Add ('quiet');
    Add ('shut up');

    Add ('what time is it');
    Add ('time');

    Add ('what day is it');
    Add ('day');

    Add ('help');
  end;
  
  SaySomething ('Welcome to the speech recognition demo.');
  SaySomething ('Say "Help" to get help');
  ApdSapiEngine1.Listen;
end;

procedure TForm1.ApdSapiEngine1VUMeter(Sender: TObject; Level: Integer);
begin
  Gauge1.Progress := Level;
end;

procedure TForm1.ApdSapiEngine1PhraseFinish(Sender: TObject;
  const Phrase: String);
begin
  Memo1.Lines.Add ('<-- ' + Phrase);
  case AnalyzePhrase (Phrase) of
    ptHelp :
      begin
        SaySomething ('You can say several things to this demo.');
        SaySomething ('"Help" will give you help.');
        if ApdSapiEngine1.Duplex = sdFull then
          SaySomething ('"Stop Speaking" will cause me to stop speaking the ' +
                        'current phrase.');
        SaySomething ('"What time is it?" will tell the current time.');
        SaySomething ('"What day is it?" will tell the current day.');
        SaySomething ('"Goodbye" will end this demo.');
      end;
    ptQuit :
      begin
        SaySomething ('Goodbye');
        ApdSapiEngine1.WaitUntilDoneSpeaking;
        Close;
      end;
    ptQuiet :
      ApdSapiEngine1.StopSpeaking;
    ptDate :
      SaySomething ('It is ' + FormatDateTime ('mmmm d, yyyy', Now) + '.');
    ptTime :
      SaySomething ('It is ' + FormatDateTime ('h:nam/pm', Now) + '.');
    ptUnknown :
      SaySomething ('I didn''t understand you.');
  end;
end;

end.
