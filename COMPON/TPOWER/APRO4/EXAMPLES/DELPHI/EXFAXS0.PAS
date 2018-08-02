{*********************************************************}
{*                     EXFAXS0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*     Shows the use of the fax send component.          *}
{*********************************************************}

unit Exfaxs0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdFax, AdFStat, AdPort, StdCtrls, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdSendFax1: TApdSendFax;
    ApdFaxStatus1: TApdFaxStatus;
    Send: TButton;
    procedure SendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SendClick(Sender: TObject);
begin
  ApdSendFax1.StartTransmit;
end;

end.
