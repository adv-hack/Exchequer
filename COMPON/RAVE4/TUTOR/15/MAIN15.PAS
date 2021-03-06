unit Main15;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, RPShell, RPTable, RPDBTabl, RPDefine,
  RPBase, RPSystem, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
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
    DBTablePrinter1GroupHeader: TTableSection;
    DBTablePrinter2GroupHeader: TTableSection;
    DBTablePrinter2BodyFooter: TTableSection;
    DBTablePrinter3BodyFooter: TTableSection;
    DBTablePrinter3BodyHeader: TTableSection;
    procedure ReportSystem1Print(Sender: TObject);
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
  DBTablePrinter1.Execute(Sender as TBaseReport);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ReportSystem1.Execute;
end;

end.
