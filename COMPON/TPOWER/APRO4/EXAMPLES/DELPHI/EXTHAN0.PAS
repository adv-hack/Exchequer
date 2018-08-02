{*********************************************************}
{*                     EXTHAN0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Uses RegisterTriggerHandler with TApdComPort.         *}
{*********************************************************}

unit Exthan0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ooMisc, AdPort, ADTrmEmu;

type
  TMyListBox = class(TListBox)
    procedure TriggerAvail(var Message : TMessage); message APW_TRIGGERAVAIL;
  end;

  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Register: TButton;
    Memo1: TMemo;
    procedure RegisterClick(Sender: TObject);
    procedure ListBoxKeyPress(Sender: TObject; var Key: Char);
  private
    ListBox1 : TMyListBox;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  GlobalPort : TApdComPort;

implementation

{$R *.DFM}

procedure TMyListBox.TriggerAvail(var Message : TMessage);
var
  I : Word;
  S : String;
begin
  S := '';
  for I := 1 to Message.wParam do
    S := S + GlobalPort.GetChar;
  Items.Add(S);
end;

procedure TForm1.RegisterClick(Sender: TObject);
begin
  GlobalPort := ApdComPort1;
  ListBox1 := TMyListBox.Create(Self);
  ListBox1.Name := 'ListBox1';
  ListBox1.Parent := Self;
  ListBox1.Top := Memo1.Top + Memo1.Height + 8;
  ListBox1.Left := 8;
  ListBox1.Show;
  ListBox1.OnKeyPress := ListBoxKeyPress;
  ApdComPort1.Dispatcher.RegisterWndTriggerHandler(ListBox1.Handle);
end;

procedure TForm1.ListBoxKeyPress(Sender: TObject; var Key: Char);
begin
  GlobalPort.Output := Key;
end;

end.
