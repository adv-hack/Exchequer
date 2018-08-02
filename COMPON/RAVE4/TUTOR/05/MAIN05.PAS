unit Main05;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, RPDefine, RPBase, RPCanvas, RPrinter, RPreview,
  RPFPrint, RPFiler;

type
  TForm1 = class(TForm)
    ReportPrinter1: TReportPrinter;
    Button1: TButton;
    ReportFiler1: TReportFiler;
    Button2: TButton;
    FilePrinter1: TFilePrinter;
    Button3: TButton;
    FilePreview1: TFilePreview;
    Button4: TButton;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    procedure ReportPrinter1Print(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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

procedure TForm1.Button2Click(Sender: TObject);
begin
  ReportFiler1.Execute;
  Label1.Caption := 'Report filed!';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ReportFiler1.Execute;
  FilePrinter1.Execute;
  Label1.Caption := 'File printed!';
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ReportFiler1.Execute;
  With FilePreview1 do begin
    Start;
    ZoomFactor := ZoomPageWidthFactor;
    Finish;
  end; { with }
  Label1.Caption := 'File previewed!';
end;

end.
