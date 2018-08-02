{*********************************************************}
{*                    EXWNSOC0.PAS                       *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Shows Winsock information.                            *}
{*********************************************************}

unit Exwnsoc0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AdSocket, AdPort, AdWnPort;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblVersion: TLabel;
    lblHighVersion: TLabel;
    lblDescription: TLabel;
    lblStatus: TLabel;
    lblMaxSockets: TLabel;
    lblLocalHost: TLabel;
    lblLocalAddress: TLabel;
    ListBox1: TListBox;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);

begin
  { this information is available from the TApdSocket class }
  With TApdSocket.Create(Self) do try
    { Get the Winsock version number and translate it into a readable string }
    lblVersion.Caption := IntToStr(LOBYTE(WsVersion)) + '.' + IntToStr(HIBYTE(WsVersion));

    { Do the same for the HighVersion property }
    lblHighVersion.Caption := IntToStr(LOBYTE(HighVersion)) + '.' + IntToStr(HIBYTE(HighVersion));

    { Get a description from the Winsock DLL }
    lblDescription.Caption := Description;

    { Display the system status }
    lblStatus.Caption := SystemStatus;

    { Display the maximum number of suckets supported }
    lblMaxSockets.Caption := IntToStr(MaxSockets);

    { Display the local host and local address }
    lblLocalHost.Caption := LocalHost;
    lblLocalAddress.Caption := LocalAddress;

  finally
    Free;
  end;

  { local network addresses are accessible from the TApdWinsockPort }
  with TApdWinsockPort.Create(Self) do try
     ListBox1.Items.AddStrings(WsLocalAddresses);
  finally
    Free;
  end;
end;

end.
