unit Main02;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, RPDefine, RPBase, RPCanvas, RPrinter;

type
  TForm1 = class(TForm)
    ReportPrinter1: TReportPrinter;
    Button1: TButton;
    Label1: TLabel;
    procedure ReportPrinter1Print(Sender: TObject);
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

procedure TForm1.ReportPrinter1Print(Sender: TObject);
begin
  With Sender as TBaseReport do begin
    SetFont('Arial',72);
    Home;
    Print('Hello World!');
  end; { with }
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ReportPrinter1.Execute;
  Label1.Caption := 'Report printed!';
end;

end.
