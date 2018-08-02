{*********************************************************}
{*                     RCVFAX0.PAS                       *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description*************************}
{* Shows how to wait for and answer incoming fax calls    *}
{**********************************************************}

unit Rcvfax0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdFax, AdFStat, AdPort, StdCtrls, ExtCtrls,
  AdExcept, AdTapi, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdFaxStatus1: TApdFaxStatus;
    ApdFaxLog1: TApdFaxLog;
    Panel1: TPanel;
    rfFaxClass: TRadioGroup;
    rfNameStyle: TRadioGroup;
    Label1: TLabel;
    rfDirectory: TEdit;
    Label2: TLabel;
    rfModemInit: TEdit;
    Panel2: TPanel;
    rfReceiveList: TListBox;
    Label3: TLabel;
    rfReceiveFaxes: TButton;
    rfExit: TButton;
    ApdReceiveFax1: TApdReceiveFax;
    rfSelectPort: TButton;
    ApdTapiDevice1: TApdTapiDevice;
    procedure ApdReceiveFax1FaxError(CP: TObject; ErrorCode: Integer);
    procedure rfExitClick(Sender: TObject);
    procedure rfDirectoryChange(Sender: TObject);
    procedure rfModemInitChange(Sender: TObject);
    procedure rfFaxClassClick(Sender: TObject);
    procedure rfNameStyleClick(Sender: TObject);
    procedure rfReceiveFaxesClick(Sender: TObject);
    procedure ApdReceiveFax1FaxLog(CP: TObject; LogCode: TFaxLogCode);
    procedure ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
    procedure rfSelectPortClick(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
    procedure ApdTapiDevice1TapiPortClose(Sender: TObject);
  private
    { Private declarations }
    InProgress : Boolean;
  public
    { Public declarations }
    constructor Create(AComponent : TComponent); override;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function LimitS(const S : String; Len : Word) : String;
  {-Truncate S at Len}
begin
  if Length(S) > Len then
    Result := Copy(S, 1, Len) + '...'
  else
    Result := S;
end;

constructor TForm1.Create(AComponent : TComponent);
  {-Create the form}
begin
  inherited Create(AComponent);
  rfDirectory.Text := ApdReceiveFax1.DestinationDir;
  rfModemInit.Text := ApdReceiveFax1.ModemInit;
  InProgress := False;
end;

procedure TForm1.ApdReceiveFax1FaxError(CP: TObject; ErrorCode: Integer);
  {-Display a fax error message}
begin
  ShowMessage('Fax error: ' + ErrorMsg(ErrorCode));
end;

procedure TForm1.rfExitClick(Sender: TObject);
  {-Exit the application}
begin
  Close;
end;

procedure TForm1.rfDirectoryChange(Sender: TObject);
  {-Set the received directory}
begin
  ApdReceiveFax1.DestinationDir := rfDirectory.Text;
end;

procedure TForm1.rfModemInitChange(Sender: TObject);
  {-Set the modem init string}
begin
  ApdReceiveFax1.ModemInit := rfModemInit.Text;
end;

procedure TForm1.rfFaxClassClick(Sender: TObject);
  {-Set the fax class}
begin
  ApdReceiveFax1.FaxClass := TFaxClass(rfFaxClass.ItemIndex+1);
end;

procedure TForm1.rfNameStyleClick(Sender: TObject);
  {-Set the naming style}
begin
  ApdReceiveFax1.FaxNameMode := TFaxNameMode(rfNameStyle.ItemIndex+1);
end;

procedure TForm1.rfReceiveFaxesClick(Sender: TObject);
  {-Start receiving faxes}
begin
  if not InProgress then begin
    InProgress := True;
    ApdReceiveFax1.FaxClass := TFaxClass(rfFaxClass.ItemIndex+1);
    ApdReceiveFax1.DestinationDir := rfDirectory.Text;
    ApdReceiveFax1.ModemInit := rfModemInit.Text;

    if (ApdComPort1.TapiMode = tmOn) or
       ((ApdComPort1.TapiMode = tmAuto) and
        (ApdTapiDevice1.SelectedDevice <> '')) then begin
      {Tell TAPI to configure and open the port}
      ApdTapiDevice1.ConfigAndOpen;
    end else begin
      {Open the port and start receiving}
      ApdComPort1.Open := True;
      ApdReceiveFax1.StartReceive;
    end;
  end else
    MessageBeep(0);
end;

procedure TForm1.ApdReceiveFax1FaxLog(CP: TObject; LogCode: TFaxLogCode);
  {-Process fax logging events}
var
  FSize : LongInt;
  F     : File;
  S     : String;
begin
  if LogCode = AdFax.lfaxReceiveOK then begin
    {Get the file size}
    AssignFile(F, ApdReceiveFax1.FaxFile);
    Reset(F, 1);
    FSize := FileSize(F);
    CloseFile(F);

    {Add an entry to the displayed list box of received files}
    S := Format('%-25S %-20S %-20S',
                [LimitS(ExtractFileName(ApdReceiveFax1.FaxFile), 20),
                 IntToStr(FSize),
                 DateTimeToStr(Now)]);
    rfReceiveList.Items.Add(S);
  end;
end;

procedure TForm1.ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
begin
  if ApdComPort1.TapiMode = tmOn then
    if ApdTapiDevice1.CancelCall then
      {Call cancelled immediately, clear InProgress flag}
      InProgress := False
    else
      {CancelCall proceeding in background, waiting for OnTapiPortClose}
  else begin
    {Not using TAPI, just close the port and clear the InProgress flag}
    ApdComPort1.Open := False;
    InProgress := False;
  end;
end;

procedure TForm1.rfSelectPortClick(Sender: TObject);
begin
  ApdTapiDevice1.SelectDevice;
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  {TAPI port is configured and open, star the fax session}
  ApdReceiveFax1.StartReceive;
end;

procedure TForm1.ApdTapiDevice1TapiPortClose(Sender: TObject);
begin
  InProgress := False;
end;

end.
