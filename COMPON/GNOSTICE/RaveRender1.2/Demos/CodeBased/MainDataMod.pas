unit MainDataMod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db;

type
  TdmMain = class(TDataModule)
    srcMaster: TDataSource;
    tblMaster: TTable;
    qryCustomer: TQuery;
    qryOrders: TQuery;
    srcCustomer: TDataSource;
    srcOrders: TDataSource;
    tblParts: TTable;
    srcParts: TDataSource;
    DataSource1: TDataSource;
    tblBiolife: TTable;
    tblBiolifeSpeciesNo: TFloatField;
    tblBiolifeCategory: TStringField;
    tblBiolifeCommon_Name: TStringField;
    tblBiolifeSpeciesName: TStringField;
    tblBiolifeLengthcm: TFloatField;
    tblBiolifeLength_In: TFloatField;
    tblBiolifeNotes: TMemoField;
    tblBiolifeGraphic: TGraphicField;
    tblCustomer: TTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation

{$R *.DFM}

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
	tblMaster.Open;
	tblBiolife.Open;
	tblCustomer.Open;
end;

procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
	tblMaster.Close;
	tblBiolife.Close;
	tblCustomer.Close;
end;

end.
