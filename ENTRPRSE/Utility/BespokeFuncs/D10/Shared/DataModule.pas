unit DataModule;

interface

uses
  ADOSQLUtil, Controls, Dialogs, SysUtils, APIUtil, Classes, DB, ADODB
  , BespokeFuncsInterface;

type
  TSQLDataModule = class(TDataModule)
    ADOConnectionBespoke: TADOConnection;
    ADOConnection_Create: TADOConnection;
    qCreateTables: TADOQuery;
    qTableExists: TADOQuery;
    qDatabaseExists: TADOQuery;
    qFillList: TADOQuery;
    qAddDiscount: TADOQuery;
    qEditDiscount: TADOQuery;
    qDeleteDiscount: TADOQuery;
    qDiscountClash: TADOQuery;
    ADOConnectionAdmin: TADOConnection;
    ADOConnectionStandard: TADOConnection;
    qCreateBespokeUser: TADOQuery;
    qCreateExchUser: TADOQuery;
    qCreateDatabase: TADOQuery;
    qDeleteDatabase: TADOQuery;
    qLoginExists: TADOQuery;
    qUserExists: TADOQuery;
    qCreateLogin: TADOQuery;
    qCreateUserDatabase: TADOQuery;
    qSQL: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public

  end;

//  procedure SetColumnParameters(TheQuery : TADOQuery; NewDiscountRec : TDiscountRec);

{var
  SQLDataModule: TSQLDataModule;}

implementation

{$R *.dfm}
{
procedure SetColumnParameters(TheQuery : TADOQuery; NewDiscountRec : TDiscountRec);
begin
  TheQuery.Parameters.ParamByName('diCompanyCode').Value := NewDiscountRec.diCompanyCode;
  TheQuery.Parameters.ParamByName('diDiscountGroup').Value := NewDiscountRec.diDiscountGroup;
  TheQuery.Parameters.ParamByName('diBand').Value := NewDiscountRec.diBand;
  TheQuery.Parameters.ParamByName('diQtyFrom').Value := NewDiscountRec.diQtyFrom;
//  TheQuery.Parameters.ParamByName('diQtyTo').Value := NewDiscountRec.diQtyTo;
//  TheQuery.Parameters.ParamByName('diDateFrom').Value := NewDiscountRec.diDateFrom;
//  TheQuery.Parameters.ParamByName('diDateTo').Value := NewDiscountRec.diDateTo;
  TheQuery.Parameters.ParamByName('diDiscountPercent').Value := NewDiscountRec.diDiscountPercent;
end;
}
procedure TSQLDataModule.DataModuleCreate(Sender: TObject);
{var
  asDatabaseName : ANSIString;
  iResult : integer;}
begin
{  try
    ADOConnection_Bespoke.Connected := TRUE;
  except
    if MsgBox('Database ' + QuotedStr(ADOConnection_Bespoke.DefaultDatabase) + ' does not exist.'#13#13
    + 'Do you wish to create a new Database ?', mtWarning, [mbYes, mbNo], mbNo, 'Create SQL Database') = mrYes then
    begin
      ExecuteSQL(SQLDataModule.qCreateTables, FALSE);
    end;{if}
{  end;{try}

end;

end.
