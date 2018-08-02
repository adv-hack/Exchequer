unit AgentMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  SentimailAgentClass, ElVar;

procedure TForm1.Button1Click(Sender: TObject);
begin
  with TSentimailAgent.Create do
  Try
    DataPath := ParamStr(1);
    SentinelCode := ParamStr(2);
    UserId := ParamStr(3);
    Purpose := TSentinelPurpose(StrToInt(ParamStr(4)));

    Execute;
  Finally
    Free;
    Close;
  End;
end;

end.
