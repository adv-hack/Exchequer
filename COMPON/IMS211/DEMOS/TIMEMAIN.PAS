unit TimeMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mssocket, Buttons, StdCtrls, ExtCtrls, ComCtrls;

type
  TTimeForm = class(TForm)
    msClientSocket1: TmsClientSocket;
    Panel1: TPanel;
    Label1: TLabel;
    ServerComboBox: TComboBox;
    ConnectButton: TSpeedButton;
    CancelButton: TSpeedButton;
    PaintBox1: TPaintBox;
    StatusBar: TStatusBar;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure msClientSocket1Connecting(Sender: TObject);
    procedure msClientSocket1Connected(Sender: TObject);
    procedure msClientSocket1Disconnected(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
    function NetTimeToDateTime(NetTime: LongInt): TDateTime;
    procedure DrawClock(DT: TDateTime);
  public
    { Public declarations }
  end;

var
  TimeForm: TTimeForm;

implementation

{$R *.DFM}

const
  SecsInDay = 86400;
  Shift = 2;

function TTimeForm.NetTimeToDateTime(NetTime : LongInt) : TDateTime;
var
  i : Integer;
  r : Double;
begin
  r:=0;
  for i:=0 to 3 do
    r:=r*256+((NetTime shr (8*i)) and $000000FF);
  Result:=r/SecsInDay+Shift;
end;

procedure TTimeForm.FormCreate(Sender: TObject);
begin
  ServerComboBox.ItemIndex:=0;
end;

procedure TTimeForm.DrawClock(DT : TDateTime);
var
  Hour, Min, Sec, MSec : word;
  r : Integer;
  Angle : real;
begin
  DecodeTime(DT,Hour,Min,Sec,MSec);
  if Hour>12 then Hour:=Hour-12;
  with PaintBox1 do
  begin
    Canvas.Brush.Color:=clBtnFace;
    Canvas.Pen.Color:=clBlue;
    Canvas.Pen.Width:=2;
    Canvas.Ellipse(2,2,Width-2,Height-2);
    Canvas.Pen.Width:=4;
    Canvas.Pen.Color:=clRed;
    Canvas.MoveTo(Width div 2, Height div 2);
    r:=(Width div 2)-15;
    Angle:=pi*Hour/6+2*pi*Min/12/60;
    Canvas.LineTo(Width div 2+Round(r*Sin(Angle)),Width div 2-Round(r*Cos(Angle)));
    Canvas.MoveTo(Width div 2, Height div 2);
    r:=(Width div 2)-4;
    Angle:=pi*Min/30;
    Canvas.LineTo(Width div 2+Round(r*Sin(Angle)),Width div 2-Round(r*Cos(Angle)));
    Canvas.MoveTo(Width div 2, Height div 2);
    r:=(Width div 2)-4;
    Angle:=pi*Sec/30;
    Canvas.Pen.Color:=clGreen;
    Canvas.Pen.Width:=1;
    Canvas.LineTo(Width div 2+Round(r*Sin(Angle)),Width div 2-Round(r*Cos(Angle)));
  end;
end;

procedure TTimeForm.ConnectButtonClick(Sender: TObject);
var
  TempStream: TStream;
  NetTime: Longint;
  DT: TDateTime;
  rc: Integer;
begin
  ServerComboBox.Enabled:=false;
  ConnectButton.Enabled:=false;
  CancelButton.Enabled:=true;
  try
    msClientSocket1.Host:=ServerComboBox.Text;
    msClientSocket1.Connect;
    TempStream:=TMemoryStream.Create;
    try
      msClientSocket1.RecvStream(TempStream,4,0);
      TempStream.Position:=0;
      rc:=TempStream.Read(NetTime,4);
      if rc<>4 then
        raise Exception.Create('Error receiving data');
      DT:=NetTimeToDateTime(NetTime);
      Label2.Caption:=FormatDateTime('ddd, mmm dd yyyy',DT);
      Label3.Caption:=FormatDateTime('hh:mm:ss "UTC"',DT);
      DrawClock(DT);
    finally
      TempStream.Free;
    end;
    msClientSocket1.Disconnect;
  finally
    ServerComboBox.Enabled:=true;
    ConnectButton.Enabled:=true;
    CancelButton.Enabled:=false;
  end;
end;

procedure TTimeForm.msClientSocket1Connecting(Sender: TObject);
begin
  StatusBar.SimpleText:='Connecting to '+msClientSocket1.Host;
end;

procedure TTimeForm.msClientSocket1Connected(Sender: TObject);
begin
  StatusBar.SimpleText:='Connected';
end;

procedure TTimeForm.msClientSocket1Disconnected(Sender: TObject);
begin
  StatusBar.SimpleText:='Disconnected';
end;

procedure TTimeForm.CancelButtonClick(Sender: TObject);
begin
  msClientSocket1.Cancel;
end;

end.
