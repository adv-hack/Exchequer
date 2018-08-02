{*********************************************************}
{*                     EXFAXB0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*Shows how a TApdSendFax component and a TApdReceiveFax *}
{*     component on the same form can share a single     *}
{*        TApdFaxStatus component.                       *}
{*********************************************************}

unit Exfaxb0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdPort, StdCtrls, AdFax, AdFStat, OoMisc, AdExcept;

type
  TForm1 = class(TForm)
    ApdReceiveFax1: TApdReceiveFax;
    ApdSendFax1: TApdSendFax;
    ApdFaxStatus1: TApdFaxStatus;
    SendFax: TButton;
    ApdComPort1: TApdComPort;
    ReceiveFax: TButton;
    procedure SendFaxClick(Sender: TObject);
    procedure ReceiveFaxClick(Sender: TObject);
    procedure ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SendFaxClick(Sender: TObject);
begin
  {Make sure required properties are set}
  if (ApdSendFax1.FaxFile = '') and (ApdSendFax1.FaxFileList.Count = 0) then begin
    ShowMessage('You must enter a file to fax in the'+#13#10+
                '   FaxFile or FaxFileList property');
    exit;
  end;
  if ApdSendFax1.PhoneNumber = '' then begin
    ShowMessage('You must enter a phone number'+#13#10+
                '  in the PhoneNumber property');
    exit;
  end;

  {Link to the status display}
  ApdSendFax1.StatusDisplay := ApdFaxStatus1;
  ApdFaxStatus1.Fax := ApdSendFax1;

  {Send the fax}
  ApdSendFax1.StartTransmit;
end;

procedure TForm1.ReceiveFaxClick(Sender: TObject);
begin
  {Line to the status display}
  ApdReceiveFax1.StatusDisplay := ApdFaxStatus1;
  ApdFaxStatus1.Fax := ApdReceiveFax1;

  {Receive faxes}
  ApdReceiveFax1.StartReceive;
end;

procedure TForm1.ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
begin
  ShowMessage('Fax finished: ' + ErrorMsg(ErrorCode));
end;

end.
