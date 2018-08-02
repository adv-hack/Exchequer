unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPSystem, RPDefine, RPBase, RPHTFilr, StdCtrls, Buttons, DBCtrls, Db,
  Grids, DBGrids, ExtCtrls, DBTables;

type
  TMainForm = class(TForm)
    RPHTMLFiler1: TRPHTMLFiler;
    Table1: TTable;
    ButtonPanel: TPanel;
    PrintBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    SpacerPanel: TPanel;
    procedure PrintBtnClick(Sender: TObject);
    procedure RPHTMLFiler1Print(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.PrintBtnClick(Sender: TObject);
begin
  RPHTMLFiler1.Execute;
  ShowMessage('Print Completed Successfully!');
end;

procedure TMainForm.RPHTMLFiler1Print(Sender: TObject);

begin
  With Sender as TRPHTMLFiler do begin
    SetTab(0.5, pjCenter, 1.3, 0, BOXLINEALL, 0);
    SetTab(NA, pjCenter, 1.3, 0, BOXLINEALL, 0);
    SetTab(NA, pjCenter, 1.3, 0, BOXLINEALL, 0);
    SetTab(NA, pjCenter, 1.3, 0, BOXLINENONE, 0);
    SaveTabs(1);
    ClearTabs;

    SetTab(0.5, pjLeft, 1.3, 0, BOXLINEALL, 0);
    SetTab(NA, pjCenter, 1.3, 0, BOXLINEALL, 0);
    SetTab(NA, pjCenter, 1.3, 0, BOXLINEALL, 0);
    SetTab(NA, pjRight, 1.3, 0, BOXLINENONE, 0);
    SaveTabs(2);

    PrintImage('logo.jpg',-161,-102,'alignment="left"');
    PrintData('<hr>'#13#10);
    PrintData('<center><h1>Customer Listing</h1></center>'#13#10);
    PrintCenter('<p>(Produced by TRPHTMLFiler)</p>', 3.1);
    NewLine;

    RestoreTabs(1);
    Table1.DisableControls;
    Table1.First;
    Tab(-2, NA, -2, -2, NA);
    Print('CUSTOMER NO.');
    Tab(NA, NA, -2, -2, NA);
    Print('COMPANY');
    Tab(NA, NA, -2, -2, NA);
    Print('CONTACT');
    Tab(NA, NA, -2, -2, NA);
    Print('PHONE');
    NewLine;
    RestoreTabs(2);
    While (not Table1.Eof) do begin
      Tab(-2, NA, -2, -2, NA);
      Print(Table1.FieldByName('CustNo').AsString);
      Tab(NA, NA, -2, -2, NA);
      Print(Table1.FieldByName('Company').AsString);
      Tab(NA, NA, -2, -2, NA);
      Print(Table1.FieldByName('Contact').AsString);
      Tab(NA, NA, -2, -2, NA);
      Print(Table1.FieldByName('Phone').AsString);
      NewLine;
      Table1.Next;
    end; { while }
    Table1.First;
    Table1.EnableControls;
  end; { with }
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SpacerPanel.Width := ButtonPanel.BorderWidth;
  CancelBtn.Align := alRight;
  SpacerPanel.Align := alRight;
  PrintBtn.Align := alRight;
end;

procedure TMainForm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

end.
