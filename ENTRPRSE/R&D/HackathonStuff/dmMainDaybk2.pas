unit dmMainDaybk2;

interface

uses
  SysUtils, Classes, SQLCallerU, DB, ADODB, SQLUtils, GlobVar, Dialogs;

type
  TModuleType = (
                  mtNone = 0,
                  mtSales = 1,
                  mtPurchase = 2
                );

  TMainDataModule = class(TDataModule)
    connMain: TADOConnection;
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FModuleType: TModuleType;
  public
    { Public declarations }
    constructor Create(aModuleType: TModuleType);
  end;

var
  MainDataModule: TMainDataModule;

implementation

{$R *.dfm}

{ TDataModule1 }

constructor TMainDataModule.Create(aModuleType: TModuleType);
var
  lConnStr: String;
  lRes: Integer;
begin
  lConnStr := '';
  FModuleType := aModuleType;
  lRes := GetConnectionString(SQLUtils.GetCompanyCode(SetDrive), False, lConnStr);
  if (lRes = 0) then
  begin
    //Initialise main connection
    connMain := TADOConnection.Create(nil);
    connMain.ConnectionString := lConnStr;
    connMain.Connected := True;
  end
  else
    ShowMessage('Could not retrieve ConnectionStr using GetConnectionString fn, Error code=' + IntToStr(lRes));
end;

procedure TMainDataModule.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(connMain) then
    FreeAndNil(connMain);
end;

end.
