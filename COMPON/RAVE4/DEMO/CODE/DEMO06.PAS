unit Demo06;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, RPShell, RPTable, RPDBTabl, RPDefine,
  RPBase, RPSystem;

type
  TDemo06Form = class(TForm)
    ReportSystem1: TReportSystem;
    DBTablePrinter1: TDBTablePrinter;
    Table1: TTable;
    DBTablePrinter1Company: TDBTableColumn;
    DBTablePrinter1Phone: TDBTableColumn;
    DBTablePrinter1Contact: TDBTableColumn;
    DBTablePrinter1ReportHeader: TTableSection;
    DBTablePrinter1BodyHeader: TTableSection;
    procedure ReportSystem1Print(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Demo06Form: TDemo06Form;

implementation

{$R *.DFM}

procedure TDemo06Form.ReportSystem1Print(Sender: TObject);
begin
  DBTablePrinter1.Execute(Sender as TBaseReport);
end;

end.
