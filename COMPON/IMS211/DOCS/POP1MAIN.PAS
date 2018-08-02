unit Pop1Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, msmsg, Mssocket, Mspop, ComCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ServerEdit: TEdit;
    UserNameEdit: TEdit;
    PasswordEdit: TEdit;
    BodyMemo: TMemo;
    msPOPClient1: TmsPOPClient;
    msMessage1: TmsMessage;
    RetrieveButton: TButton;
    procedure RetrieveButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.RetrieveButtonClick(Sender: TObject);
begin
  msPOPClient1.Host:=ServerEdit.Text;
  msPOPClient1.UserName:=UserNameEdit.Text;
  msPOPClient1.Password:=PasswordEdit.Text;
  msPOPClient1.Login;
  if msPOPClient1.TotalMessages>0 then
  begin
    msPOPClient1.Retrieve;
    BodyMemo.Lines:=msMessage1.Body;
  end
  else
    ShowMessage('There are no messages');
  msPOPClient1.Logout;
end;

end.
