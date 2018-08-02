unit SetRang1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ExtCtrls, Db, StdCtrls, Halcn6DB, Halcn6Nv;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    HalcyonDataSet1: THalcyonDataSet;
    Button1: TButton;
    CB1: TComboBox;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label2: TLabel;
    CB2: TComboBox;
    Edit2: TEdit;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Button5: TButton;
    Button6: TButton;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    HalcyonNavigator1: THalcyonNavigator;
    edtSolve: TEdit;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  IndexExt: string;

implementation
uses gs6_glbl, gs6_tool;
{$R *.DFM}


procedure TForm1.Button1Click(Sender: TObject);
begin
   HalcyonDataset1.Open;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
   HalcyonDataset1.IndexFiles.Clear;
   HalcyonDataset1.IndexFiles.Add('testrnge'+IndexExt);
   HalcyonDataset1.IndexName := 'testrnge';
{
   if HalcyonDataset1.Active then
      if HalcyonDataSet1.DBFHandle.IndexMaster <> nil then
         Label7.Caption := HalcyonDataSet1.DBFHandle.IndexMaster.ExprHandlr.EnumerateType(gsSQLTypeVarDBF);
}
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   HalcyonDataset1.Reindex;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   sortstat: TgsSortStatus;
   ixunique: TgsIndexUnique;
begin
   if CheckBox2.Checked then
      sortstat := halcn6db.Ascending
   else
      sortstat := halcn6db.Descending;
   if CheckBox3.Checked then
      ixunique := halcn6db.Unique
   else
      ixunique := halcn6db.Duplicates;
   HalcyonDataset1.IndexFiles.Clear;
   DeleteFile('testrnge'+IndexExt);
   HalcyonDataset1.IndexOn('testrnge'+IndexExt,'testrnge',CB1.Text,CB2.Text,ixunique,sortstat);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
   HalcyonDataset1.SetRange(Edit1.Text,Edit2.Text);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
   Label5.Caption := IntToStr(HalcyonDataset1.RecordCount);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
   if ComboBox1.ItemIndex < 0 then exit;
   IndexExt :=  ComboBox1.Items[ComboBox1.ItemIndex];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   ShortDateFormat := 'mm/dd/yyyy';
   ComboBox1.ItemIndex := 0;
   IndexExt :=  ComboBox1.Items[ComboBox1.ItemIndex];
   CheckBox1.Checked := HalcyonDataset1.ExactCount;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
   HalcyonDataset1.ExactCount := CheckBox1.Checked;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
   edtSolve.Text := HalcyonDataset1.DBFHandle.IndexMaster.ExprHandlr.EnumerateType(gsSQLTypeVarDBF);
{   edtSolve.Text := HalcyonDataset1.IndexKeyValue(HalcyonDataset1.IndexCurrentOrder);}
end;

end.


