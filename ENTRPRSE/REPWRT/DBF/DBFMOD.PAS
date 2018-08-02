unit DbfMod;

interface

uses
  SysUtils, Classes, Halcn6db, DB;

type
  TdmDbf = class(TDataModule)
    dsTable: THalcyonDataSet;
    dsCreate: TCreateHalcyonDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDbf: TdmDbf;

implementation

{$R *.dfm}

end.
