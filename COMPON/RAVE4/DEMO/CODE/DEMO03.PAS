unit Demo03;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, RPShell, RPDefine, RPBase, RPSystem;

type
  TDemo03Form = class(TForm)
    ReportSystem1: TReportSystem;
    MasterShell1: TMasterShell;
    DetailShell1: TDetailShell;
    Table2: TTable;
    Table3: TTable;
    Table4: TTable;
    Table1: TTable;
    ReportShell1: TReportShell;
    procedure ReportShell1ReportBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure ReportShell1RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure ReportShell1GroupAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);

    procedure MasterShell1BodyBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure MasterShell1RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure MasterShell1GroupAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);

    procedure DetailShell1BodyBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure DetailShell1RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure DetailShell1RowAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);

    procedure ReportSystem1Print(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Demo03Form: TDemo03Form;

implementation

{$R *.DFM}

procedure TDemo03Form.ReportShell1ReportBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  Table1.First;
  With ReportPrinter do begin
    ClearTabs;
    SetTab(1.0,pjCenter,1.0,5,BOXLINEALL,100);
    SetTab(NA,pjLeft,3.5,5,BOXLINEALL,100);
    SetTab(NA,pjCenter,2.0,5,BOXLINEALL,100);
    SaveTabs(1);

    ClearTabs;
    SetTab(1.5,pjCenter,1.0,5,BOXLINEALL,10);
    SetTab(NA,pjCenter,2.0,5,BOXLINEALL,10);
    SetTab(NA,pjCenter,2.0,5,BOXLINEALL,10);
    SaveTabs(2);

    ClearTabs;
    SetTab(2.0,pjCenter,0.5,5,BOXLINELEFTRIGHT,0);
    SetTab(NA,pjLeft,2.5,5,BOXLINELEFTRIGHT,0);
    SaveTabs(3);

    SetFont('Arial',18);
    FontColor := clWhite;
    SaveFont(1);

    SetFont('Arial',12);
    SaveFont(2);

    SetFont('Times New Roman',10);
    SaveFont(3);
  end; { with }
end;

procedure TDemo03Form.ReportShell1RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  With ReportPrinter,Table1 do begin
    If ReportShell.IsNewPage then begin
      TabJustify := tjCenter;
      Println(#9'No'#9'Name'#9'Phone #');
      TabJustify := tjNone;
    end; { if }
    PrintTab(FieldByName('CUSTNO').AsString);
    Print(#9 + FieldByName('COMPANY').AsString);
    Print(#9 + FieldByName('PHONE').AsString);
    CRLF;
  end; { with }
end;

procedure TDemo03Form.ReportShell1GroupAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  Table1.Next;
  Valid := not Table1.EOF;
end;



procedure TDemo03Form.MasterShell1BodyBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  With Table1 do begin
    Table2.SetRange([FieldByName('CUSTNO').AsInteger],
     [FieldByName('CUSTNO').AsInteger]);
    Table2.First;
  end; { with }
end;

procedure TDemo03Form.MasterShell1RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  With ReportPrinter,Table2 do begin
    If ReportShell.IsNewPage then begin
      TabJustify := tjCenter;
      Println(#9'Order #'#9'Sold'#9'Shipped');
      TabJustify := tjNone;
    end; { if }
    PrintTab(FieldByName('ORDERNO').AsString);
    Print(#9 + FieldByName('SALEDATE').AsString);
    Print(#9 + FieldByName('SHIPDATE').AsString);
    CRLF;
  end; { with }
end;

procedure TDemo03Form.MasterShell1GroupAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  Table2.Next;
  Valid := not Table2.EOF;
end;



procedure TDemo03Form.DetailShell1BodyBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  With Table2 do begin
    Table3.SetRange([FieldByName('ORDERNO').AsInteger],
     [FieldByName('ORDERNO').AsInteger]);
    Table3.First;
  end; { with }
end;

procedure TDemo03Form.DetailShell1RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  With ReportPrinter,Table3 do begin
    If ReportShell.IsNewPage then begin
      TabJustify := tjCenter;
      Underline := true;
      Println(#9'Qty'#9'Description');
      Underline := false;
      TabJustify := tjNone;
    end; { if }
    Print(#9 + FieldByName('QTY').AsString);
    If Table4.FindKey([FieldByName('PARTNO').AsInteger]) then begin
      Print(#9 + Table4.FieldByName('DESCRIPTION').AsString);
    end else begin
      Print(#9'(unknown)');
    end; { else }
    CRLF;
  end; { with }
end;

procedure TDemo03Form.DetailShell1RowAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  Table3.Next;
  Valid := not Table3.EOF;
end;


procedure TDemo03Form.ReportSystem1Print(Sender: TObject);
begin
  ReportShell1.Execute(Sender as TBaseReport);
end;

end.
