{*********************************************************}
{*                     EXPLOG0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*          Shows protocol history logging.              *}
{*********************************************************}

unit Explog0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdProtcl, AdPStat, AdPort, OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ListBox1: TListBox;
    TransmitAll: TButton;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    Label1: TLabel;
    AdTerminal1: TAdTerminal;
    procedure ApdProtocol1ProtocolLog(CP: TObject; Log: Word);
    procedure TransmitAllClick(Sender: TObject);
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ApdProtocol1ProtocolLog(CP: TObject; Log: Word);
begin
  if Log = lfTransmitOK then
    ListBox1.Items.Add(ApdProtocol1.FileName);
end;

procedure TForm1.TransmitAllClick(Sender: TObject);
begin
  AdTerminal1.Active := False;
  ApdProtocol1.StartTransmit;
end;

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  AdTerminal1.Active := True;
  AdTerminal1.SetFocus;
end;

end.
