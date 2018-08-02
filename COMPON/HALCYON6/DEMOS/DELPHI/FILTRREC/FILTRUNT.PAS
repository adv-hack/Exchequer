unit filtrunt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, StdCtrls, Grids, DBGrids, ExtCtrls, DBCtrls, GS6_Glbl, Halcn6DB;

type
  TForm1 = class(TForm)
    HalcyonDataSet1: THalcyonDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    CheckBox1: TCheckBox;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    Button3: TButton;
    edtFilter: TEdit;
    Button1: TButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     function CountInFile: integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function TForm1.CountInFile: integer;
var
   rn: longint;
begin
   Result := 0;
   if not HalcyonDataset1.Active then exit;
   rn := HalcyonDataset1.RecNo;
   with HalcyonDataset1.DBFHandle do
   begin
      gsGetRec(Top_Record);       {Get first index key, no DBF read}
      while not File_EOF do
      begin
         inc(Result);
         gsGetRec(Next_Record);   {Skip through the index, no DBF read}
      end;
      gsGetRec(rn);
   end;
end;




procedure TForm1.CheckBox1Click(Sender: TObject);
begin
   HalcyonDataset1.Filter := edtFilter.Text;
   HalcyonDataset1.Filtered := CheckBox1.Checked;
   HalcyonDataset1.Refresh;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   HalcyonDataset1.Open;
   ShortDateFormat := 'mm/dd/yyyy';
   edtFilter.Text := HalcyonDataset1.Filter;
   CheckBox1.Checked := HalcyonDataset1.Filtered;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   Label1.Caption := IntToStr(CountInFile);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   HalcyonDataset1.Filter := edtFilter.Text;
end;

end.
