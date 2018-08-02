unit Adhocprn;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, DBTables, RPDefine, RPBase, RPShell,
  RPTable, RPDBTabl, RPSystem;

type
  TfrmAdhocprn = class(TForm)
    DBTablePrinter1: TDBTablePrinter;
    Table1: TTable;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Database1: TDatabase;
    ListBox1: TListBox;
    Label3: TLabel;
    Button1: TButton;
    ReportSystem1: TReportSystem;
    DBTablePrinter1ReportHeader: TTableSection;
    DBTablePrinter1BodyHeader: TTableSection;
    Label4: TLabel;
    Edit1: TEdit;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ReportSystem1BeforePrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdhocprn: TfrmAdhocprn;

implementation

{$R *.DFM}

procedure TfrmAdhocprn.ComboBox1Change(Sender: TObject);
begin
  With Database1 do begin
    Connected := false;
    AliasName := ComboBox1.Text;
    Session.GetTableNames('RPProDB','',true,true,ComboBox2.Items);
    Connected := true;
    ListBox1.Items.Clear;
  end; { with }
end;

procedure TfrmAdhocprn.FormCreate(Sender: TObject);
begin
  Session.GetAliasNames(ComboBox1.Items);
end;

procedure TfrmAdhocprn.ComboBox2Change(Sender: TObject);
begin
  With Table1 do begin
    Active := false;
    DatabaseName := ComboBox1.Text;
    TableName := ComboBox2.Text;
    Active := true;
    GetFieldNames(ListBox1.Items);
  end; { with }
end;

procedure TfrmAdhocprn.Button1Click(Sender: TObject);

var
  Factor: double;
  CurrentWidth: double;
  DesiredWidth: double;
  TC: TTableColumn;
  Field: TField;
  I1: integer;

begin
  With DBTablePrinter1 do begin
  { Delete all current columns in DBTablePrinter }
    While TableColumns > 0 do begin
      TableColumn[TableColumns].Free;
    end; { while }

  { Add columns to DBTablePrinter1 }
    DesiredWidth := 7.5;
    CurrentWidth := 0.0;
    For I1 := 0 to (ListBox1.Items.Count - 1) do begin
      If ListBox1.Selected[I1] then begin
        With CreateColumn(ListBox1.Items[I1]) as TDBTableColumn do begin
          FieldName := ListBox1.Items[I1];
          Heading := ListBox1.Items[I1];
          Field := Table1.FindField(ListBox1.Items[I1]);
          If Field <> nil then begin
            Width := Field.DisplayWidth / 10.0;
            CurrentWidth := CurrentWidth + Width;
          end; { if }
{ !!! Put code here to modify other TDBTableColumn properties !!! }
        { Justify := pjCenter; }
        { OverflowMethod := omWrap; }
        { Totals := true; }
        end; { with }
      end; { if }
    end; { for }

  { Figure out conversion factor }
    Factor := DesiredWidth / CurrentWidth;
    For I1 := 1 to TableColumns do begin
      TC := TableColumn[I1];
      TC.Width := TC.Width * Factor;
    end; { for }

  { Init the report header text }
    TableSection[stReportHeader].Text := Edit1.Text;
{ !!! Put code here to modify other TTableSection properties !!! }
  { CreateSection(SectionName[stBodyFooter],stBodyFooter); }
  { TableSection[stBodyFooter].OutputType := otGrandTotals; }
  end; { with }

{ Execute the report }
  DBTablePrinter1.Execute(nil);
end;

procedure TfrmAdhocprn.ReportSystem1BeforePrint(Sender: TObject);
begin
	with Sender as TBaseReport do
		SetPaperSize(DMPAPER_LETTER, 0, 0);
end;

end.
