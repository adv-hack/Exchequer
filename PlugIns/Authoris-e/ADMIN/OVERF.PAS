unit overf;

{ prutherford440 09:36 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  pword;

{$R *.DFM}


procedure TForm1.Button1Click(Sender: TObject);
begin
  with TfrmAdminPassword.Create(nil) do
  try
    Self.Label1.Caption := OverridePassword;
  Finally
    Free;
  End;
end;

end.
