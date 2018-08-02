{*********************************************************}
{*                    EXFLIST0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*Shows a TApdProtocol OnNextFile event handler that     *}
{*      transmits a list of files.                       *}
{*********************************************************}

unit Exflist0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdProtcl, AdPStat, AdPort, StdCtrls, AdExcept,
  OoMisc, ADTrmEmu;

type
  TExampleFList = class(TForm)
    ApdComPort1: TApdComPort;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    ApdProtocolLog1: TApdProtocolLog;
    AddFiles: TButton;
    AdTerminal1: TAdTerminal;
    procedure ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ApdProtocol1ProtocolError(CP: TObject; ErrorCode: Integer);
    procedure AddFilesClick(Sender: TObject);
    procedure ApdProtocol1ProtocolNextFile(CP: TObject;
      var FName: TPassString);
  private
    { Private declarations }
    FileList : TStringList;
    FileIndex : Word;
  public
    { Public declarations }
    constructor Create(AComponent : TComponent); override;
  end;

var
  ExampleFList: TExampleFList;

implementation

{$R *.DFM}

constructor TExampleFList.Create(AComponent : TComponent);
begin
  inherited Create(AComponent);
  FileList := TStringList.Create;
end;

procedure TExampleFList.ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_PRIOR then
    ApdProtocol1.StartTransmit
  else if Key = VK_NEXT then
    ApdProtocol1.StartReceive;
end;

procedure TExampleFList.ApdProtocol1ProtocolError(CP: TObject;
  ErrorCode: Integer);
begin
  ShowMessage('Fatal protocol error: ' + ErrorMsg(ErrorCode));
end;

procedure TExampleFList.AddFilesClick(Sender: TObject);
begin
  FileList.Add('EXFLIST.DPR');
  FileList.Add('EXFLIST0.PAS');
  FileList.Add('EXFLIST0.DFM');
  FileIndex := 0;

  AdTerminal1.WriteString('Files added!');
  AdTerminal1.SetFocus;
end;

procedure TExampleFList.ApdProtocol1ProtocolNextFile(CP: TObject;
  var FName: TPassString);
begin
  try
    FName := FileList[FileIndex];
    Inc(FileIndex);
  except
    FName := '';
  end;
end;

end.
