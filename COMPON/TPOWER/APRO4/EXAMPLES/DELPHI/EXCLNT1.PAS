{*********************************************************}
{*                     EXCLNT1.PAS                       *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*       This client portion works with ExServer         *}
{*           to implement a basic Winsock connection.    *}
{*********************************************************}
   {note: fill in wsAddress (property) in ApdWinsockPort1}
           {IP address}
unit ExClnt1;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdPort, AdWnPort, AdWUtil, OoMisc;

type
  TForm1 = class(TForm)
    ApdWinsockPort1: TApdWinsockPort;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ApdWinsockPort1WsConnect(Sender: TObject);
    procedure ApdWinsockPort1TriggerAvail(CP: TObject; Count: Word);
    procedure ApdWinsockPort1WsError(Sender: TObject; ErrCode: Integer);
    procedure ApdWinsockPort1WsDisconnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
  {Connect button click - attempts to connect}
begin
  ApdWinsockPort1.Open := not(ApdWinsockPort1.Open);
  if ApdWinsockPort1.Open then
    Label1.Caption := 'Attempting to connect';
end;

procedure TForm1.ApdWinsockPort1WsConnect(Sender: TObject);
  {Event OnWsConnect -change Button1 after connected}
begin
  Label1.Caption := 'Connected';
  Button1.Caption := 'Disconnect';
  ApdWinsockPort1.Output := 'Hello from Client';
end;

procedure TForm1.ApdWinsockPort1TriggerAvail(CP: TObject; Count: Word);
  {Event OnTriggerAvail}
var
  I : Word;
begin
  for I := 1 to Count do
    Label2.Caption := Label2.Caption + ApdWinsockPort1.GetChar;
end;

procedure TForm1.ApdWinsockPort1WsError(Sender: TObject; ErrCode: Integer);
  {Event WsError - display error in Label3}
begin
  Label1.Caption := 'Error...';
  Label3.Caption := 'Code: ' + IntToStr(ErrCode);
end;

procedure TForm1.ApdWinsockPort1WsDisconnect(Sender: TObject);
  {Event WsDisconnect - Change Button1 back}
begin
  Label1.Caption := '';
  Label2.Caption := '';
  Button1.Caption := 'Connect';
end;

end.
