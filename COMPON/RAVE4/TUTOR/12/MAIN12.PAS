unit Main12;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, RPShell, DB, DBTables, RPDefine, RPBase, RPSystem,
  StdCtrls, RPMemo;

type
  TForm1 = class(TForm)
    ReportSystem1: TReportSystem;
    Table1: TTable;
    DetailShell1: TDetailShell;
    Button1: TButton;
    procedure ReportSystem1Print(Sender: TObject);
    procedure DetailShell1RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure DetailShell1RowAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure DetailShell1RowBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    MemoBuf: TMemoBuf;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ReportSystem1Print(Sender: TObject);

var
  FileStream: TFileStream;

begin
  MemoBuf := TMemoBuf.Create;
  try
    FileStream := TFileStream.Create('TUTOR12.TXT',
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

procedure TForm1.DetailShell1RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  With ReportPrinter do begin
    With MemoBuf,Table1 do begin
      PrintStart := SectionLeft;
      PrintEnd := SectionRight;
      RestoreBuffer;
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

procedure TForm1.DetailShell1RowBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
{ Only print if this customer is older than 1/1/94 }
  Valid := (Table1.FieldByName('LASTINVOICEDATE').AsDateTime <
   EncodeDate(1994,1,1));
end;

end.
