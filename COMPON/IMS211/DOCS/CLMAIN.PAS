unit clmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mssocket, StdCtrls;

type
  TForm1 = class(TForm)
    ConnectButton: TButton;
    RecvMemo: TMemo;
    msClientSocket1: TmsClientSocket;
    procedure ConnectButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ConnectButtonClick(Sender: TObject);
var
  TempStream: TStream;
begin
  TempStream:=TMemoryStream.Create;
  try
    msClientSocket1.Connect;
    msClientSocket1.RecvStream(TempStream,-1,0);
    TempStream.Position:=0;
    RecvMemo.Lines.LoadFromStream(TempStream);
    msClientSocket1.Disconnect;
  finally
    TempStream.Free;
  end;
end;

end.
