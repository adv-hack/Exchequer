unit Demo08;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, RPTable, RPShell, RPDefine, RPBase, RPSystem;

type
  TDemo08Form = class(TForm)
    ReportSystem1: TReportSystem;
    TablePrinter1: TTablePrinter;
    TablePrinter1ReportHeader: TTableSection;
    TablePrinter1Name: TTableColumn;
    TablePrinter1Phone: TTableColumn;
    TablePrinter1Notes: TTableColumn;
    TablePrinter1Height: TTableColumn;
    TablePrinter1BodyHeader: TTableSection;
    procedure TablePrinter1InitTable(TablePrinter: TTablePrinter;
      var Valid: Boolean);
    procedure TablePrinter1GetNextRow(TablePrinter: TTablePrinter;
      var Valid: Boolean);
    procedure TablePrinter1NameRowSetup(TableColumn: TTableColumn);
    procedure TablePrinter1PhoneRowSetup(TableColumn: TTableColumn);
    procedure TablePrinter1HeightRowSetup(TableColumn: TTableColumn);
    procedure TablePrinter1NotesRowSetup(TableColumn: TTableColumn);
    procedure ReportSystem1Print(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  Names: array[1..5] of string[20] = ('Fred Flintstone','George Jetson',
   'Bugs Bunny','Mickey Mouse','Donald Duck');
  PhoneNums: array[1..5] of string[20] = ('1-800-CAVEMAN','1-800-SPROCKET',
   '1-800-CARROTS','1-800-CHEESES','1-800-FEATHERS');
  Heights: array[1..5] of double = (6.75,5.88,4.45,3.12,4.29);
  Notes: array[1..5] of string =
   ('Mr. Flintstone is a very important customer, eats a lot!',
    'Outstanding P.O. #545456388 dated 4/3/2076 for $123,655,878.99 (4 - pillow cases)',
    'He is very wrascally, always ship produce C.O.D.',
    'Credit is good as per cosignee Mr. Disney',
    'Cannot understand over the phone, always request fax backup of orders');

var
  Demo08Form: TDemo08Form;
  Index: word;

implementation

{$R *.DFM}

procedure TDemo08Form.TablePrinter1InitTable(TablePrinter: TTablePrinter;
  var Valid: Boolean);
begin
  Index := 1;
  Valid := true;
end;

procedure TDemo08Form.TablePrinter1GetNextRow(TablePrinter: TTablePrinter;
  var Valid: Boolean);
begin
  Inc(Index);
  Valid := Index <= 5;
end;

procedure TDemo08Form.TablePrinter1NameRowSetup(TableColumn: TTableColumn);
begin
  TableColumn.MemoBuf.Text := Names[Index];
end;

procedure TDemo08Form.TablePrinter1PhoneRowSetup(
  TableColumn: TTableColumn);
begin
  TableColumn.MemoBuf.Text := PhoneNums[Index];
end;

procedure TDemo08Form.TablePrinter1HeightRowSetup(
  TableColumn: TTableColumn);
begin
  TableColumn.MemoBuf.Text := FloatToStr(Heights[Index]);
end;

procedure TDemo08Form.TablePrinter1NotesRowSetup(
  TableColumn: TTableColumn);
begin
  TableColumn.MemoBuf.Text := Notes[Index];
end;

procedure TDemo08Form.ReportSystem1Print(Sender: TObject);
begin
  TablePrinter1.Execute(Sender as TBaseReport);
end;

end.
