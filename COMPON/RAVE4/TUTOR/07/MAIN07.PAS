unit Main07;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, RPShell, RPDefine, RPBase, RPSystem, DB, DBTables,
  StdCtrls;

type
  TForm1 = class(TForm)
    ReportSystem1: TReportSystem;
    DetailShell1: TDetailShell;
    Table1: TTable;
    Button1: TButton;
    procedure ReportSystem1Print(Sender: TObject);
    procedure DetailShell1BodyBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure DetailShell1BodyHeader(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure DetailShell1RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure DetailShell1RowAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
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

procedure TForm1.ReportSystem1Print(Sender: TObject);
begin
  DetailShell1.Execute(Sender as TBaseReport);
end;

procedure TForm1.DetailShell1BodyBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  Table1.First;
  With ReportPrinter do begin
    ClearTabs;
    SetTab(1.0,pjCenter,1.0,5,BOXLINEALL,0);
    SetTab(NA,pjLeft,4.0,5,BOXLINEALL,0);
    SetTab(NA,pjCenter,1.5,5,BOXLINEALL,0);
    SaveTabs(1); { Save the row tabs }

    SetFont('Arial',18);
    SaveFont(1); { Save the header font }

    SetFont('Times New Roman',14);
    SaveFont(2); { Save the row font }
  end; { with }
end;

procedure TForm1.DetailShell1BodyHeader(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  With ReportPrinter do begin
    PrintCenter('Customer List',PageWidth / 2.0);
    CRLF;
    CRLF;
  end; { with }
end;

procedure TForm1.DetailShell1RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  With ReportPrinter,Table1 do begin
    If ReportShell.IsNewPage then begin
      TabJustify := tjCenter;
      Println(#9'No'#9'Name'#9'Phone #');
      TabJustify := tjNone;
    end; { if }
    Print(#9 + FieldByName('CUSTNO').AsString);
    Print(#9 + FieldByName('COMPANY').AsString);
    Print(#9 + FieldByName('PHONE').AsString);
    CRLF;
  end; { with }
end;

procedure TForm1.DetailShell1RowAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  Table1.Next;
  Valid := not Table1.EOF;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ReportSystem1.Execute;
end;

end.
