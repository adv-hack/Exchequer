unit Demo05;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, RPDefine, RPBase, RPSystem, DB, DBTables, RPShell, RPMemo;

type
  TDemo05Form = class(TForm)
    ReportSystem1: TReportSystem;
    DetailShell1: TDetailShell;
    Table1: TTable;
    procedure DetailShell1RowAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure DetailShell1RowBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure DetailShell1RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure ReportSystem1Print(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MemoBuf: TMemoBuf;
  end;

var
  Demo05Form: TDemo05Form;

implementation

{$R *.DFM}

procedure TDemo05Form.DetailShell1RowAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  Table1.Next;
  Valid := not Table1.EOF;
end;

procedure TDemo05Form.DetailShell1RowBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);

var
  Y,M,D: word;

begin
{ Only print if this customer is older than 3 years ago }
  DecodeDate(Date,Y,M,D);
  Y := Y - 3;
  Valid := (Table1.FieldByName('LASTINVOICEDATE').AsDateTime < EncodeDate(Y,M,D));
end;

procedure TDemo05Form.DetailShell1RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  With ReportPrinter do begin
    With MemoBuf,Table1 do begin
      PrintStart := SectionLeft;
      PrintEnd := SectionRight;
      RestoreBuffer;
      Justify := pjBlock;
      ReplaceAll('%COMPANY%',FieldByName('COMPANY').AsString,false);
      ReplaceAll('%CUSTNO%',FieldByName('CUSTNO').AsString,false);
      ReplaceAll('%LASTDATE%',DateToStr(
       FieldByName('LASTINVOICEDATE').AsDateTime),false);
      ReplaceAll('%CONTACT%',FieldByName('CONTACT').AsString,false);
      SetFont('Times New Roman',14);
      Home;
      PrintMemo(MemoBuf,0,false);
    end; { with }
  end; { with }
end;

procedure TDemo05Form.ReportSystem1Print(Sender: TObject);

var
  FileStream: TFileStream;

begin
  MemoBuf := TMemoBuf.Create;
  try
    FileStream := TFileStream.Create('DEMO05.TXT',
     fmOpenRead or fmShareDenyWrite);
    try
      MemoBuf.LoadFromStream(FileStream,0);
    finally
      FileStream.Free;
    end; { tryf }
    MemoBuf.SaveBuffer; { Save off original copy }
    Table1.First;
    DetailShell1.Execute(Sender as TBaseReport);
  finally
    MemoBuf.Free;
  end; { tryf }
end;

end.
