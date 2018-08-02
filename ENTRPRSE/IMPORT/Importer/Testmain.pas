unit Testmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

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

uses
  uUpdatePaths;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  UpdateImporterPaths('C:\EXCH63.PSQL\', 'ZZZZ01', 'Demonstration Company');
  ShowMessage('Done');
end;

end.
