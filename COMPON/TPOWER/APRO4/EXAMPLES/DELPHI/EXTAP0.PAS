{*********************************************************}
{*                    ExTap0.PAS                         *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates the use of how to send a TAP Page via    *}
{*       the ApdTAPPager component.                      *}
{*********************************************************}

unit ExTap0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, OoMisc, AdPort, AdPager;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdTAPPager1: TApdTAPPager;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Memo1: TMemo;
    Label3: TLabel;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure ApdTAPPager1TAPFinish(Sender: TObject);
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
  ApdTAPPager1.CancelCall;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Button1.Caption := 'Please Wait';
  Button1.Enabled := FALSE;
  ApdTAPPager1.PhoneNumber := Edit1.Text;
  ApdTAPPager1.PagerID     := Edit2.Text;
  ApdTAPPager1.Message     := Memo1.Lines;
  ApdTAPPager1.Send;
end;

procedure TForm1.ApdTAPPager1TAPFinish(Sender: TObject);
begin
  Button1.Caption := 'Send';
  Button1.Enabled := TRUE;
end;

end.
