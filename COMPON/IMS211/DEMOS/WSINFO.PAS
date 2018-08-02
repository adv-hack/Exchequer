unit wsinfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TWSInfoDlg = class(TForm)
    InfoMemo: TMemo;
    ShowButton: TButton;
    procedure ShowButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WSInfoDlg: TWSInfoDlg;

implementation

{$R *.DFM}

uses msWSock;

procedure TWSInfoDlg.ShowButtonClick(Sender: TObject);
var
  s: string;
begin
  with InfoMemo.Lines, msWinsock.WinsockInfo do
  begin
    Clear;
    Add('Winsock version: $'+IntToHex(Version,4));
    Add('High version: $'+IntToHex(HighVersion,4));
    Add('Description: '+Description);
    Add('System status: '+SystemStatus);
    Add('Maximum sockets: '+IntToStr(MaxSockets));
    Add('Local host: '+msWinsock.LocalName);
    s:=msWinsock.LocalAddress;
    Add('Local address: '+s);
    try
      Add('Local host after reverse lookup: '+msWinsock.msGetHostByAddr(s));
    except
      Add('Unable to perform reverse lookup');
    end;
  end;
end;

end.
