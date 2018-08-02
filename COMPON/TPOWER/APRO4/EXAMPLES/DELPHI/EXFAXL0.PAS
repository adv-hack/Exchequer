{*********************************************************}
{*                     EXFAXL0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*Shows how to use the OnFaxNext event to send multiple  *}
{*      faxes.                                           *} 
{*********************************************************}

unit Exfaxl0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdFax, AdFStat, AdPort, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdSendFax1: TApdSendFax;
    ApdFaxStatus1: TApdFaxStatus;
    ApdFaxLog1: TApdFaxLog;
    AddFiles: TButton;
    SendFax: TButton;
    procedure AddFilesClick(Sender: TObject);
    procedure ApdSendFax1FaxNext(CP: TObject;
              var APhoneNumber, AFaxFile, ACoverFile: TPassString);
    procedure SendFaxClick(Sender: TObject);
  private
    { Private declarations }
    FaxList  : TStringList;
    FaxIndex : Word;
  public
    { Public declarations }
    constructor Create(AComponent : TComponent); override;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

constructor TForm1.Create(AComponent : TComponent);
begin
  inherited Create(AComponent);
  FaxList := TStringList.Create;
end;

procedure TForm1.AddFilesClick(Sender: TObject);
begin
  FaxList.Add('260-7151^..\APROLOGO.APF');
  FaxList.Add('260-7151^..\APROLOGO.APF');
  FaxIndex := 0;
  ShowMessage('Fax files added!');
end;

procedure TForm1.ApdSendFax1FaxNext(CP: TObject;
          var APhoneNumber, AFaxFile, ACoverFile: TPassString);
var
  S : String;
  CaretPos : Byte;
begin
  try
    S := FaxList[FaxIndex];
    CaretPos := Pos('^', S);
    APhoneNumber := Copy(S, 1, CaretPos-1);
    AFaxFile := Copy(S, CaretPos+1, 255);
    ACoverFile := '';
    Inc(FaxIndex);
  except
    APhoneNumber := '';
    AFaxFile := '';
    ACoverFile := '';
  end;
end;

procedure TForm1.SendFaxClick(Sender: TObject);
begin
  ApdSendFax1.StartTransmit;
end;

end.
