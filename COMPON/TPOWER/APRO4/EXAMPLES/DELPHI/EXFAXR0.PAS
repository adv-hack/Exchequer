{*********************************************************}
{*                     EXFAXR0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*     Shows the use of the fax receive component.       *}
{*********************************************************}

unit exfaxr0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdFax, AdFStat, AdPort, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdReceiveFax1: TApdReceiveFax;
    ApdFaxStatus1: TApdFaxStatus;
    Receive: TButton;
    procedure ReceiveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ReceiveClick(Sender: TObject);
begin
  ApdReceiveFax1.StartReceive;
end;

end.
