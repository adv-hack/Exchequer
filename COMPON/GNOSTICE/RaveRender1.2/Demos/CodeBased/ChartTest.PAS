unit ChartTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, TeeProcs, Chart, ExtCtrls, RPDefine, RPBase, RPSystem,
  StdCtrls, Buttons;

type
  TfrmTChartTest = class(TForm)
    Panel1: TPanel;
    TestChart: TChart;
    Series1: TBarSeries;
    PrintBtn: TBitBtn;
    ReportSystem1: TReportSystem;
    procedure PrintBtnClick(Sender: TObject);
    procedure ReportSystem1Print(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ReportSystem1BeforePrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTChartTest: TfrmTChartTest;

implementation

uses
  RPTChart;

{$R *.DFM}

procedure TfrmTChartTest.PrintBtnClick(Sender: TObject);
begin
  ReportSystem1.Execute;
end;

procedure TfrmTChartTest.ReportSystem1Print(Sender: TObject);
begin
  With Sender as TBaseReport do begin
    PrintTeeChart(Sender as TBaseReport, 1.0, 1.0, 1.0 + 6.5, 1.0 +
     CalcTeeChartHeight(6.5, TestChart), TestChart);
  end; { with }
end;

procedure TfrmTChartTest.FormCreate(Sender: TObject);
begin
  With Series1 do begin
    Add(  40, 'Pencil' , clRed ) ;
    Add(  60, 'Paper',  clBlue ) ;
    Add(  30, 'Ribbon', clGreen ) ;
    Add(  45, 'Crayon' , clYellow ) ;
    Add(  65, 'Glue',  clWhite ) ;
    Add(  35, 'Eraser', clPurple ) ;
  end; { with }
end;

procedure TfrmTChartTest.ReportSystem1BeforePrint(Sender: TObject);
begin
	with Sender as TBaseReport do
		SetPaperSize(DMPAPER_LETTER, 0, 0);
end;

end.
