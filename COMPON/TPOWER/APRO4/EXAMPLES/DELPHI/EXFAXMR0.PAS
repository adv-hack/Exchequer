{*********************************************************}
{*                     EXFAXMR0.PAS                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*Shows how to use the ApdReceiveFax1.StartManualReceive *}
{*********************************************************}

{
  To use this example, a phone should be plugged into the 'phone' jack on the
  modem.  Have someone send a fax to you, then pick up the phone handset when
  it rings.  Once you hear the fax tones, click the 'Start Receive' button.
  The phone handset should disconnect, and the modem will receive the fax.
}

unit exfaxmr0;

interface

uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ADTrmEmu,
  AdFax,
  AdFStat,
  AdPort, OoMisc;

type
  TForm1 = class(TForm)
    ApdReceiveFax1: TApdReceiveFax;
    ApdComPort1: TApdComPort;
    ApdFaxStatus1: TApdFaxStatus;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    AdTerminal1: TAdTerminal;
    procedure Button1Click(Sender: TObject);
    procedure ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
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
begin
  AdTerminal1.Active := False;
  ApdReceiveFax1.StartManualReceive(True);
end;

procedure TForm1.ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
begin
  AdTerminal1.Active := True;
end;

end.
