unit dmMainTraderList;

interface

uses
  SysUtils, Classes, DB, ADODB, SQLUtils, GlobVar, Dialogs;

type
 { TModuleType = (
                  mtNone = 0,
                  mtCustomer = 1,
                  mtSupplier = 2,
                  mtConsumer = 3
                );   }

  TdmTraderList = class(TDataModule)
    connTrader: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(aOwner : TComponent); overload;
  end;

var
  dmTraderList: TdmTraderList;

implementation

{$R *.dfm}

constructor TdmTraderList.Create(aOwner : TComponent);
begin
  inherited Create(aOwner);
end;

end.
