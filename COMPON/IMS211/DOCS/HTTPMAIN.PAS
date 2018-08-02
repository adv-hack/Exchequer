unit httpmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mssocket, mshttp;

type
  TForm1 = class(TForm)
    URLEdit: TEdit;
    GetButton: TButton;
    ResultsMemo: TMemo;
    msHTTPClient1: TmsHTTPClient;
    procedure GetButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.GetButtonClick(Sender: TObject);
begin
  msHTTPClient1.URL:=URLEdit.Text;
  msHTTPClient1.Get;
  msHTTPClient1.InStream.Position:=0;
  ResultsMemo.Lines.LoadFromStream(msHTTPClient1.InStream);
end;

end.
