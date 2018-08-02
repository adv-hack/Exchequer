unit DM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPConBDE, DBTables, RPDefine, RPCon, RPConDS, Db;

type
  TDataModule2 = class(TDataModule)
    CustomerTable: TTable;
    OrdersTable: TTable;
    ItemsTable: TTable;
    PartsTable: TTable;
    ClientsTable: TTable;
    ClientsCXN: TRPTableConnection;
    MasterTable: TTable;
    BioLifeTable: TTable;
    VendorsTable: TTable;
    CustrOrdQuery: TQuery;
    CustOrdCXN: TRPQueryConnection;
    CustomerCXN: TRPTableConnection;
    OrdersCXN: TRPTableConnection;
    PartsCXN: TRPTableConnection;
    BioLifeCXN: TRPTableConnection;
    MasterCXN: TRPTableConnection;
    ItemsCXN: TRPTableConnection;
    VendorsCXN: TRPTableConnection;
    ItemsTableOrderNo: TFloatField;
    ItemsTableItemNo: TFloatField;
    ItemsTablePartNo: TFloatField;
    ItemsTableQty: TIntegerField;
    ItemsTableDiscount: TFloatField;
    ItemsTableListPrice: TCurrencyField;
    ItemsTableTotalPrice: TCurrencyField;
    CustomMasterCXN: TRPCustomConnection;
    CustomDetail1CXN: TRPCustomConnection;
    CustomDetail2CXN: TRPCustomConnection;
    CustomCXN: TRPCustomConnection;
    procedure CustomCXNGetCols(Connection: TRPCustomConnection);
    procedure CustomCXNGetRow(Connection: TRPCustomConnection);
    procedure CustomCXNEOF(Connection: TRPCustomConnection;
      var EOF: Boolean);
    procedure ItemsTableCalcFields(DataSet: TDataSet);
    procedure CustomMasterCXNGetCols(Connection: TRPCustomConnection);
    procedure CustomMasterCXNGetRow(Connection: TRPCustomConnection);
    procedure CustomMasterCXNOpen(Connection: TRPCustomConnection);
    procedure CustomDetail1CXNGetCols(Connection: TRPCustomConnection);
    procedure CustomDetail1CXNGetRow(Connection: TRPCustomConnection);
    procedure CustomDetail1CXNOpen(Connection: TRPCustomConnection);
    procedure CustomDetail2CXNGetCols(Connection: TRPCustomConnection);
    procedure CustomDetail2CXNGetRow(Connection: TRPCustomConnection);
    procedure CustomDetail2CXNOpen(Connection: TRPCustomConnection);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{$R *.DFM}

procedure TDataModule2.CustomCXNGetCols(
  Connection: TRPCustomConnection);
begin
  With Connection do begin
    WriteField('Index',dtInteger,8,'Index Field','This field is the index of each row.');
    WriteField('Name',dtString,30,'Name Field','This field is the name of each row.');
    WriteField('Amount',dtFloat,20,'Amount Field','This field is the amount of each row.');
  end; { with }
end;

procedure TDataModule2.CustomCXNGetRow(
  Connection: TRPCustomConnection);
begin
  With Connection do begin
    WriteIntData('',DataIndex);
    WriteStrData('','Name' + IntToStr(DataIndex));
    WriteFloatData('',DataIndex * 123.45);
  end; { with }
end;

procedure TDataModule2.CustomCXNEOF(Connection: TRPCustomConnection;
  var EOF: Boolean);
begin
  EOF := (Connection.DataIndex > 1000);
end;

procedure TDataModule2.ItemsTableCalcFields(DataSet: TDataSet);
begin
  With ItemsTable do begin
    ItemsTableTotalPrice.AsCurrency := FieldByName('ListPrice').AsCurrency *
     FieldByName('Qty').AsInteger *
     ((100.0 - FieldByName('Discount').AsFloat) / 100.0);
  end; { with }
end;

procedure TDataModule2.CustomMasterCXNGetCols(Connection: TRPCustomConnection);
begin
  Connection.WriteField('MasterKey',dtInteger,8,'','');
  Connection.WriteField('MasterName',dtString,40,'','');
end;

procedure TDataModule2.CustomMasterCXNGetRow(Connection: TRPCustomConnection);

var
  S1: string;

begin
  Connection.WriteIntData('',Connection.DataIndex);
  S1 := MoneyToLongName(Connection.DataIndex);
  Delete(S1,Length(S1) - 10,11); { Delete " and 00/100" from end }
  Connection.WriteStrData('','Master (' + S1 + ')');
end;

procedure TDataModule2.CustomMasterCXNOpen(Connection: TRPCustomConnection);
begin
  Connection.DataRows := 10;
end;

procedure TDataModule2.CustomDetail1CXNGetCols(Connection: TRPCustomConnection);
begin
  Connection.WriteField('MasterKey',dtInteger,8,'','');
  Connection.WriteField('Detail1Key',dtInteger,8,'','');
  Connection.WriteField('Detail1Name',dtString,40,'','');
end;

procedure TDataModule2.CustomDetail1CXNGetRow(Connection: TRPCustomConnection);

var
  S1: string;

begin
  Connection.WriteIntData('',Connection.DataIndex div 10);
  Connection.WriteIntData('',Connection.DataIndex mod 10);
  S1 := MoneyToLongName(Connection.DataIndex);
  Delete(S1,Length(S1) - 10,11); { Delete " and 00/100" from end }
  Connection.WriteStrData('','Detail #1 (' + S1 + ')');
end;

procedure TDataModule2.CustomDetail1CXNOpen(Connection: TRPCustomConnection);
begin
  Connection.DataRows := 100;
end;

procedure TDataModule2.CustomDetail2CXNGetCols(Connection: TRPCustomConnection);
begin
  Connection.WriteField('MasterKey',dtInteger,8,'','');
  Connection.WriteField('Detail1Key',dtInteger,8,'','');
  Connection.WriteField('Detail2Key',dtInteger,8,'','');
  Connection.WriteField('Detail2Name',dtString,40,'','');
end;

procedure TDataModule2.CustomDetail2CXNGetRow(Connection: TRPCustomConnection);

var
  S1: string;

begin
  Connection.WriteIntData('',Connection.DataIndex div 100);
  Connection.WriteIntData('',(Connection.DataIndex div 10) mod 10);
  Connection.WriteIntData('',Connection.DataIndex mod 10);
  S1 := MoneyToLongName(Connection.DataIndex);
  Delete(S1,Length(S1) - 10,11); { Delete " and 00/100" from end }
  Connection.WriteStrData('','Detail #2 (' + S1 + ')');
end;

procedure TDataModule2.CustomDetail2CXNOpen(Connection: TRPCustomConnection);
begin
  Connection.DataRows := 1000;
end;

end.
