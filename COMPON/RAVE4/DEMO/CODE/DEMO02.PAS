unit Demo02;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, RPShell, RPDefine, RPBase, RPSystem;

type
  TDemo02Form = class(TForm)
    ReportSystem1: TReportSystem;
    DetailShell1: TDetailShell;
    Table1: TTable;
    procedure DetailShell1BodyBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure DetailShell1BodyAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure DetailShell1RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure ReportSystem1Print(Sender: TObject);
    procedure DetailShell1BodyHeader(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure DetailShell1RowAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Demo02Form: TDemo02Form;

implementation

{$R *.DFM}

procedure TDemo02Form.DetailShell1BodyBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  Table1.Open;
  Table1.First;
  With ReportPrinter do begin
    ClearTabs;
    SetTab(1.0,pjCenter,1.0,5,BOXLINEALL,0);
    SetTab(NA,pjLeft,4.0,5,BOXLINEALL,0);
    SetTab(NA,pjCenter,1.5,5,BOXLINEALL,0);
    SaveTabs(1);

    SetFont('Arial',18);
    SaveFont(1);

    SetFont('Times New Roman',14);
    SaveFont(2);
  end; { with }
end;

procedure TDemo02Form.DetailShell1BodyAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  Table1.Close;
end;

procedure TDemo02Form.DetailShell1RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  With ReportPrinter,Table1 do begin
    If ReportShell.IsNewPage then begin
      TabJustify := tjCenter;
      Println(#9'No'#9'Name'#9'Phone #');
      TabJustify := tjNone;
    end; { if }
    PrintTab(FieldByName('CUSTNO').AsString);
    PrintTab(FieldByName('COMPANY').AsString);
    PrintTab(FieldByName('PHONE').AsString);
    CRLF;
  end; { with }
end;

procedure TDemo02Form.ReportSystem1Print(Sender: TObject);
begin
  DetailShell1.Execute(Sender as TBaseReport);
end;

procedure TDemo02Form.DetailShell1BodyHeader(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  With ReportPrinter do begin
    PrintCenter('Customer List',PageWidth / 2.0);
    CRLF;
    CRLF;
  end; { with }
end;

procedure TDemo02Form.DetailShell1RowAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  Table1.Next;
  Valid := not Table1.EOF;
end;

end.
