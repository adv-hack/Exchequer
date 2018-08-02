unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPBase, RPSystem, RPDefine, StdCtrls, RPRave, RVCsBars;

type
  TForm1 = class(TForm)
    ReportSystem1: TReportSystem;
    ReportLB: TListBox;
    DescMemo: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    RaveProject: TRaveProject;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ReportLBClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RaveProjectCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ShowNotice: boolean = true;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  RaveProject.Open;
  RaveProject.GetReportList(ReportLB.Items,true);
end;

procedure TForm1.ReportLBClick(Sender: TObject);
begin
  RaveProject.SelectReport(ReportLB.Items[ReportLB.ItemIndex],true);
  RaveProject.ReportDescToMemo(DescMemo);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  RaveProject.Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  RaveProject.Execute;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ReportLB.ItemIndex := 0;
  ReportLBClick(nil);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  RaveProject.Design;
  RaveProject.GetReportList(ReportLB.Items,true);
end;

procedure TForm1.RaveProjectCreate(Sender: TObject);
begin
  RVCsBars.RaveRegister;
end;

end.
