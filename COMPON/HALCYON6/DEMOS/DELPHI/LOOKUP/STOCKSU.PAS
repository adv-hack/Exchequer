unit Stocksu;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Mask, ExtCtrls, Halcn6DB;

type
  TMainForm = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    EditACCT_NBR: TDBEdit;
    Label2: TLabel;
    EditSYMBOL: TDBEdit;
    Label3: TLabel;
    EditSHARES: TDBEdit;
    Label4: TLabel;
    EditPUR_PRICE: TDBEdit;
    Label5: TLabel;
    EditPUR_DATE: TDBEdit;
    DBNavigator: TDBNavigator;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    HalcyonDataSet1: THalcyonDataSet;
    DBLookupComboBox1: TDBLookupComboBox;
    HalcyonDataSet2: THalcyonDataSet;
    DataSource2: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  HalcyonDataset1.Open;
  HalcyonDataset2.Open;
end;

end.