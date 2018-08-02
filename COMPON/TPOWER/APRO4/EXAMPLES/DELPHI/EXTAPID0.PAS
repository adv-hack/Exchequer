{*********************************************************}
{*                    EXTAPID0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* TAPI example that can dial calls.                     *}
{*********************************************************}

unit extapid0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort, AdTapi, AdTStat, ExtCtrls,
  OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    ApdTapiDevice1: TApdTapiDevice;
    ApdTapiStatus1: TApdTapiStatus;
    ApdTapiLog1: TApdTapiLog;
    Dial: TButton;
    Hangup: TButton;
    ApdComPort1: TApdComPort;
    Label1: TLabel;
    edtPhoneNumber: TEdit;
    AdTerminal1: TAdTerminal;
    procedure DialClick(Sender: TObject);
    procedure HangupClick(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DialClick(Sender: TObject);
begin
  ApdTapiDevice1.Dial(edtPhoneNumber.Text);
end;

procedure TForm1.HangupClick(Sender: TObject);
begin
  ApdTapiDevice1.CancelCall;
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  AdTerminal1.SetFocus;
end;

end.
