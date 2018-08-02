unit uStaticExportManager;
{
  The main processing is done by the ancestor class (TBaseExportManager), and
  this class simply overrides the GetTableExporter method to return the
  appropriate tables for the Static Export.
}
interface

uses SysUtils, Classes,
  // ICE units
  uExportBaseClass,
  uBaseExportManager
  ;

type
  TStaticExportManager = class(TBaseExportManager)
  protected
    function GetTableExporter(pReference: Longword): _ExportBase; override;
  end;

implementation

uses
  // ICE units
  uConsts,
  uCommon,
  uGLStructureExport,
  uCustExport,
  uStockExport
  ;

{ TStaticExportManager }

function TStaticExportManager.GetTableExporter(
  pReference: Longword): _ExportBase;
begin
  Result := nil;
  case pReference of
    cGLStructureTable:
      begin
        Result := TGLStructureExport.Create;
        Title  := 'G/L Structure export';
      end;
    cCustTable:
      begin
        Result := TCustExport.Create;
        Title  := 'Customer export';
        TCustExport(Result).ExportType := csExportCustomers;
      end;
    cSupplierTable:
      begin
        Result := TCustExport.Create;
        Title  := 'Supplier export';
        TCustExport(Result).ExportType := csExportSuppliers;
      end;
    cStockTable:
      begin
        Result := TStockExport.Create;
        Title  := 'Stock export';
      end;
  end;
end;

end.
