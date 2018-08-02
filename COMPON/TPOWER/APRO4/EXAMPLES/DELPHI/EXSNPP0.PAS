{*********************************************************}
{*                    ExSNPP0.PAS                        *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates the use a Simple Network Paging Protocol *}
{*      (SNPP) for transmitting alphanumeric page        *}
{*      requests over TCP/IP networks (e.g. Internet).   *}
{*********************************************************}

{ note: A paging service must provide an SNPP server as a
        facility before a pager may be contacted via SNPP.}

unit ExSNPP0;

interface

uses
{$ifndef WIN32 }
  WinTypes, WinProcs,
{$else }
  Windows,
{$endif }
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, OoMisc, AdPort, AdWnPort, AdPager;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Memo1: TMemo;
    Label3: TLabel;
    ApdWinsockPort1: TApdWinsockPort;
    Button1: TButton;
    ApdSNPPPager1: TApdSNPPPager;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure ApdSNPPPager1Logout(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ApdSNPPPager1.Quit;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  WsAddr, WsPortID: string;
  P: Integer;
begin
  Button1.Caption := 'Please Wait';
  Button1.Enabled := FALSE;

  { extract WinSock address and port# }
  P := Pos(':', Edit1.Text);
  WsAddr   := Copy(Edit1.Text, 1, P - 1);
  WsPortID := Copy(Edit1.Text, P + 1, Length(Edit1.Text) - P);
  ApdWinsockPort1.WsAddress := WsAddr;
  ApdWinsockPort1.WsPort    := WsPortID;

  ApdSNPPPager1.PagerID      := Edit2.Text;
  ApdSNPPPager1.Message      := Memo1.Lines;
  ApdSNPPPager1.Send;
end;

procedure TForm1.ApdSNPPPager1Logout(Sender: TObject);
begin
  Button1.Caption := 'Send';
  Button1.Enabled := TRUE;
end;

end.
  