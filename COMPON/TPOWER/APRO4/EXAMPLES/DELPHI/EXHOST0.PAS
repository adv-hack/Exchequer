{*********************************************************}
{*                     EXHOST0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}


{**********************Description************************}
{* Demonstrates how to processs strings from incoming    *}
{*      data.  This example works together with ExLogin  *}
{*      to show how a host program might request a user  *}
{*      name and password and process the returned       *}
{*      values using triggers.                           *}
{*********************************************************}

unit Exhost0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdPort, StdCtrls, OoMisc, ADTrmEmu, AdMdm;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Button1: TButton;
    AdTerminal1: TAdTerminal;
    AdModem1: TAdModem;
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure Button1Click(Sender: TObject);
    procedure ApdModem1ModemIsConnected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BufferString : String;
    WhatAmIDoing : Word;
  end;

{states we can be in waiting for data}
const
  BuildingUserName = 1;
  BuildingPassword = 2;
  NormalCharacterReads = 3;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
var
  c : Char;
  i : Word;
begin
  for i := 1 to Count do begin
    c := ApdComPort1.GetChar;
    case WhatAmIDoing of
      BuildingUserName :
        begin
          BufferString := BufferString + c;
          if c = #13 then begin
            {validate the username here}
            {....}
            {now we can reinitialize the buffer}
            BufferString := '';
            {and send a request for the password}
            ApdComPort1.Output := 'password?'#13;
            {and wait for ExLogin to respond}
            WhatAmIDoing := BuildingPassword;
          end;
        end;
      BuildingPassword :
        begin
          BufferString := BufferString + c;
          if c = #13 then begin
            {validate the password here}
            {....}
            {now we can reinitialize the buffer}
            BufferString := '';
            {and do whatever is the next step after password}
            {(ExLogin expects us to send one more "?")}
            ApdComPort1.Output := '?'#13;
            {...}
            WhatAmIDoing := NormalCharacterReads;
          end;
        end;
      NormalCharacterReads:
        {...process other messages or normal characters here...}
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  AdModem1.AutoAnswer;
end;

procedure TForm1.ApdModem1ModemIsConnected(Sender: TObject);
begin
   {send the request for the username}
   WhatAmIDoing := BuildingUserName;
   ApdComPort1.Output := 'Username?';
end;

end.
