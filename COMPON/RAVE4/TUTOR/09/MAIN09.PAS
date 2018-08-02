unit Main09;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, RPShell, RPDefine, RPBase, RPSystem,
  StdCtrls;

type
  TForm1 = class(TForm)
    ReportSystem1: TReportSystem;
    MasterShell1: TMasterShell;
    DetailShell1: TDetailShell;
    Table1: TTable;
    Table2: TTable;
    Table3: TTable;
    Button1: TButton;
    procedure MasterShell1BodyBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure MasterShell1RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure DetailShell1BodyBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure DetailShell1RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure DetailShell1RowAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure MasterShell1GroupAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure ReportSystem1Print(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.MasterShell1BodyBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  Table1.First;
  With ReportPrinter do begin
    ClearTabs;
    SetTab(1.5,pjCenter,1.0,5,BOXLINEALL,10);
    SetTab(NA,pjCenter,2.0,5,BOXLINEALL,10);
    SetTab(NA,pjCenter,2.0,5,BOXLINEALL,10);
    SaveTabs(1);

    ClearTabs;
    SetTab(2.0,pjCenter,0.5,5,BOXLINELEFTRIGHT,0);
    SetTab(NA,pjLeft,2.5,5,BOXLINELEFTRIGHT,0);
    SaveTabs(2);

    SetFont('Arial',12);
    SaveFont(1);

    SetFont('Times New Roman',10);
    SaveFont(2);
  end; { with }
end;

procedure TForm1.MasterShell1RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  With ReportPrinter,Table1 do begin
    If ReportShell.IsNewPage then begin
      TabJustify := tjCenter;
      Println(#9'Order #'#9'Sold'#9'Shipped');
      TabJustify := tjNone;
    end; { if }
    Print(#9 + FieldByName('ORDERNO').AsString);
    Print(#9 + FieldByName('SALEDATE').AsString);
    Print(#9 + FieldByName('SHIPDATE').AsString);
    CRLF;
  end; { with }
end;

procedure TForm1.DetailShell1BodyBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  With Table1 do begin
    Table2.SetRange([FieldByName('ORDERNO').AsInteger],
     [FieldByName('ORDERNO').AsInteger]);
    Table2.First;
  end; { with }
end;

procedure TForm1.DetailShell1RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  With ReportPrinter,Table2 do begin
    If ReportShell.IsNewPage then begin
      TabJustify := tjCenter;
      Underline := true;
      Println(#9'Qty'#9'Description');
      Underline := false;
      TabJustify := tjNone;
    end; { if }
    Print(#9 + FieldByName('QTY').AsString);
    If Table3.FindKey([FieldByName('PARTNO').AsInteger]) then begin
      Print(#9 + Table3.FieldByName('DESCRIPTION').AsString);
    end else begin
      Print(#9'(unknown)');
    end; { else }
    CRLF;
  end; { with }
end;

procedure TForm1.DetailShell1RowAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  Table2.Next;
  Valid := not Table2.EOF;
end;

procedure TForm1.MasterShell1GroupAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  Table1.Next;
  Valid := not Table1.EOF;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ReportSystem1.Execute;
end;

procedure TForm1.ReportSystem1Print(Sender: TObject);
begin
  MasterShell1.Execute(Sender as TBaseReport);
end;

end.
