unit Demo07;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, RPTable, RPDBTabl, DB, DBTables, RPShell, RPDefine,
  RPBase, RPSystem;

type
  TDemo07Form = class(TForm)
    ReportSystem1: TReportSystem;
    DBTablePrinter1: TDBTablePrinter;
    DBTablePrinter2: TDBTablePrinter;
    DBTablePrinter3: TDBTablePrinter;
    Table1: TTable;
    Table2: TTable;
    Table3: TTable;
    Table4: TTable;
    DBTablePrinter1CustomerNumber: TDBTableColumn;
    DBTablePrinter1CompanyName: TDBTableColumn;
    DBTablePrinter1PhoneNumber: TDBTableColumn;
    DBTablePrinter2OrderNumber: TDBTableColumn;
    DBTablePrinter2SoldDate: TDBTableColumn;
    DBTablePrinter2ShippedDate: TDBTableColumn;
    DBTablePrinter3Quantity: TDBTableColumn;
    DBTablePrinter3Description: TDBTableColumn;
    DBTablePrinter2BodyHeader: TTableSection;
    DBTablePrinter3PageFooter: TTableSection;
    procedure ReportSystem1Print(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Demo07Form: TDemo07Form;

implementation

{$R *.DFM}

procedure TDemo07Form.ReportSystem1Print(Sender: TObject);
begin
  DBTablePrinter1.Execute(Sender as TBaseReport);
end;

end.
