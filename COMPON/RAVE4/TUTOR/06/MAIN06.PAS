unit Main06;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, DBTables, RPDefine, RPBase, RPSystem;

type
  TForm1 = class(TForm)
    ReportSystem1: TReportSystem;
    Table1: TTable;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ReportSystem1BeforePrint(Sender: TObject);
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

procedure TForm1.Button1Click(Sender: TObject);
begin
  ReportSystem1.Execute;
end;

procedure TForm1.ReportSystem1BeforePrint(Sender: TObject);
begin
  Table1.First;
end;

procedure TForm1.ReportSystem1Print(Sender: TObject);
begin
  With Sender as TBaseReport,Table1 do begin
    ClearTabs;
    SetTab(1.0,pjCenter,1.0,5,BOXLINEALL,0);
    SetTab(NA,pjLeft,4.0,5,BOXLINEALL,0);
    SetTab(NA,pjCenter,1.5,5,BOXLINEALL,0);

    SetFont('Arial',18);
    Home;
    PrintCenter('Customer List',PageWidth / 2.0);
    CRLF;
    CRLF;
    SetFont('Times New Roman',14);
    AdjustLine;
    While not EOF do begin
    { Print headers }
      TabJustify := tjCenter;
      Println(#9'No'#9'Name'#9'Phone #');
      TabJustify := tjNone;

    { Print as many lines as we can }
      With Table1 do begin
        While (LinesLeft > 0) and not EOF do begin
          PrintTab(FieldByName('CUSTNO').AsString);
          PrintTab(FieldByName('COMPANY').AsString);
          PrintTab(FieldByName('PHONE').AsString);
          CRLF;
          Next; { Get next record in Table1 }
        end; { while }
        If not EOF then begin
          NewPage;
        end; { if }
      end; { with }
    end; { while }
  end; { with }
end;

end.
