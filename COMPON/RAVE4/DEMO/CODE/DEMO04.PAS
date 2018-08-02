unit Demo04;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, RPShell, RPLabel, RPDefine, RPBase,
  RPSystem;

type
  TDemo04Form = class(TForm)
    ReportSystem1: TReportSystem;
    LabelShell1: TLabelShell;
    Table1: TTable;
    Table1CustNo: TFloatField;
    Table1Company: TStringField;
    Table1Addr1: TStringField;
    Table1Addr2: TStringField;
    Table1City: TStringField;
    Table1State: TStringField;
    Table1Zip: TStringField;
    Table1Country: TStringField;
    Table1Phone: TStringField;
    Table1FAX: TStringField;
    Table1TaxRate: TFloatField;
    Table1Contact: TStringField;
    Table1LastInvoiceDate: TDateTimeField;
    procedure LabelShell1LabelAfter(ReportPrinter: TBaseReport;
      LabelShell: TLabelShell; var Valid: Boolean);
    procedure LabelShell1LabelPrint(ReportPrinter: TBaseReport;
      LabelShell: TLabelShell; var Valid: Boolean);
    procedure LabelShell1ReportBefore(ReportPrinter: TBaseReport;
      LabelShell: TLabelShell);
    procedure ReportSystem1Print(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Demo04Form: TDemo04Form;

implementation

{$R *.DFM}

procedure TDemo04Form.LabelShell1ReportBefore(ReportPrinter: TBaseReport;
  LabelShell: TLabelShell);
begin
  Table1.First;
  ReportPrinter.SetFont('Arial',12);
end;


procedure TDemo04Form.LabelShell1LabelPrint(ReportPrinter: TBaseReport;
  LabelShell: TLabelShell; var Valid: Boolean);
begin
  With ReportPrinter,Table1 do begin
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


procedure TDemo04Form.LabelShell1LabelAfter(ReportPrinter: TBaseReport;
  LabelShell: TLabelShell; var Valid: Boolean);
begin
  Table1.Next;
  Valid := not Table1.EOF;
end;

procedure TDemo04Form.ReportSystem1Print(Sender: TObject);
begin
  LabelShell1.Execute(Sender as TBaseReport);
end;

end.
