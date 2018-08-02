unit TestF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
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

{$R *.DFM}

Uses ChainU, CheckSec;

procedure TForm1.Button1Click(Sender: TObject);
begin
  If CheckHookSecurity (DLLChain.ModuleName, 1, 'Hook Security Test App') Then
    ShowMessage ('Security OK')
  Else
    ShowMessage ('Security Sucks');
end;

end.
