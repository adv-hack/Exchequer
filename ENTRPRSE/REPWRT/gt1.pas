unit gt1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GuiEng, StdCtrls;

type
  TfrmGuiTest = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Engine : TReportWriterEngine;
    procedure GotRecs(Sender : TObject);
    procedure CheckRecord(Count, Total : Integer; var Abort : Boolean);
  public
    { Public declarations }
  end;

var
  frmGuiTest: TfrmGuiTest;

implementation

{$R *.dfm}
uses
  McParser;

procedure TfrmGuiTest.GotRecs(Sender : TObject);
var
  i : integer;
  s : string;
  Res : Boolean;
begin
  Res := Engine.GetFirst;

  while Res do
  begin
    s := '';
    for i := 0 to 3 do
      s := s + Engine.Fields[i].Value + ' ';

    ListBox1.Items.Add(s);

    Res := Engine.GetNext;
  end;

end;

procedure TfrmGuiTest.Button1Click(Sender: TObject);
begin

  //Set file number & index
  Engine.FileNo := 1; //Customers
  Engine.IndexNo := 0; //no index - step through

  with Engine.AddInput do
  begin
    InputType := 7;
    StringFrom := 'CASH01';
    StringTo := 'WEST01';
  end;

  with Engine.AddField do
  begin
    VarName := 'ACACC';
    Filter := 'R1 > I1[1] AND R1 < I1[2]';
  end;

  with Engine.AddField do
  begin
    VarName := 'ACCOMP';
    SortOrder := '1A';
  end;

  with Engine.AddField do
  begin
    VarName := 'ACPRBAL';
    DecPlaces := 2;
    Period := 'YTD';
    Year := '2003';
  end;

  with Engine.AddField do
  begin
    CalcField := True;
    DecPlaces := 2;
    Calculation := 'R3 * 2';
  end;


  Engine.Execute;
end;

procedure TfrmGuiTest.CheckRecord(Count, Total : Integer; var Abort : Boolean);
begin
  Label1.Caption := IntToStr(Count) + '/' + IntToStr(Total);
  Label1.Repaint;
  Application.ProcessMessages;
  Sleep(1);
end;

procedure TfrmGuiTest.FormCreate(Sender: TObject);
begin
  //Create RW Engine
  Engine := TReportWriterEngine.Create;
  Engine.OnSelectionsDone := GotRecs;
  Engine.OnCheckRecord := CheckRecord;

end;

procedure TfrmGuiTest.FormDestroy(Sender: TObject);
begin
  Engine.Free;
end;

end.
