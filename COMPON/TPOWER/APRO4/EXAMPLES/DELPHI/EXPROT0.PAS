{*********************************************************}
{*                     EXPROT0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*Shows protocol transfer combined with ApdProtocolStatus*}
{*   and ApdProtocolLog components.                      *}
{*********************************************************}

unit Exprot0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdProtcl, AdPStat, AdPort, AdExcept,
  ADTrmEmu, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    Upload: TButton;
    Download: TButton;
    ApdProtocolLog1: TApdProtocolLog;
    AdTerminal1: TAdTerminal;
    AdVT100Emulator1: TAdVT100Emulator;
    OpenDialog1: TOpenDialog;
    procedure UploadClick(Sender: TObject);
    procedure DownloadClick(Sender: TObject);
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure ApdProtocol1ProtocolError(CP: TObject; ErrorCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.UploadClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    AdTerminal1.Active := False;
    ApdProtocol1.StartTransmit;
  end;
end;

procedure TForm1.DownloadClick(Sender: TObject);
begin
  AdTerminal1.Active := False;
  ApdProtocol1.StartReceive;
end;

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  ShowMessage('Protocol finished: '+ErrorMsg(ErrorCode));
  AdTerminal1.Active := True;
end;

procedure TForm1.ApdProtocol1ProtocolError(CP: TObject;
  ErrorCode: Integer);
begin
  ShowMessage('Protocol finished: '+ErrorMsg(ErrorCode));
end;

end.
