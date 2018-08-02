unit Animalu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, ExtCtrls, Halcn6Nv, Db, Halcn6DB;

type
  TMainForm = class(TForm)
    HalcyonDataSet1: THalcyonDataSet;
    DataSource1: TDataSource;
    HalcyonNavigator1: THalcyonNavigator;
    DBImage1: TDBImage;
    DBEdit1: TDBEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
   HalcyonDataset1.Open;
end;

end.
