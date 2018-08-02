unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise04_TLB, CtkUtil04, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Res : Integer;
begin
  oToolkit := CreateToolkitWithBackdoor;
  oToolkit.Configuration.DataDirectory := Edit1.Text;

  Res := oToolkit.OpenToolkit;
  ShowMessage(IntToStr(Res));
  oToolkit := nil;
end;

end.
