unit Main11;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, DBTables, RPSystem, RPDefine, RPBase,
  RPShell, RPLabel;

type
  TForm1 = class(TForm)
    LabelShell1: TLabelShell;
    ReportSystem1: TReportSystem;
    Table1: TTable;
    Button1: TButton;
    procedure LabelShell1ReportBefore(ReportPrinter: TBaseReport;
      LabelShell: TLabelShell);
    procedure LabelShell1LabelAfter(ReportPrinter: TBaseReport;
      LabelShell: TLabelShell; var Valid: Boolean);
    procedure LabelShell1LabelPrint(ReportPrinter: TBaseReport;
      LabelShell: TLabelShell; var Valid: Boolean);
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

procedure TForm1.LabelShell1ReportBefore(ReportPrinter: TBaseReport;
  LabelShell: TLabelShell);
begin
  Table1.First;
  ReportPrinter.SetFont('Arial',12);
end;

procedure TForm1.LabelShell1LabelAfter(ReportPrinter: TBaseReport;
  LabelShell: TLabelShell; var Valid: Boolean);
begin
  Table1.Next;
  Valid := not Table1.EOF;
end;

procedure TForm1.LabelShell1LabelPrint(ReportPrinter: TBaseReport;
  LabelShell: TLabelShell; var Valid: Boolean);
begin
  With ReportPrinter,Table1 do begin
    YPos := 1.0;

    Println(FieldByName('COMPANY').AsString);

    If FieldByName('ADDR1').AsString <> '' then begin
      Println(FieldByName('ADDR1').AsString);
    end; { if }

    If FieldByName('ADDR2').AsString <> '' then begin
      Println(FieldByName('ADDR2').AsString);
    end; { if }

    Print(FieldByName('CITY').AsString);
    If FieldByName('STATE').AsString <> '' then begin
      Print(', ' + FieldByName('STATE').AsString);
    end; { if }
    If FieldByName('ZIP').AsString <> '' then begin
      Print('  ' + FieldByName('ZIP').AsString);
    end; { if }
    CRLF;

    If FieldByName('COUNTRY').AsString <> 'US' then begin
      Println(UpperCase(FieldByName('COUNTRY').AsString));
    end; { if }
  end; { with }
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ReportSystem1.Execute;
end;

procedure TForm1.ReportSystem1Print(Sender: TObject);
begin
  LabelShell1.Execute(Sender as TBaseReport);
end;

end.
