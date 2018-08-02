unit uSystemExportManager;
{
  This class handles the processing which is common to all the Exporter
  classes, and is used by each of the T...DataExporter classes (in the
  various oExporter.pas units).

  The main processing is done by the ancestor class (TBaseExportManager), and
  this class simply overrides the GetTableExporter method to return the
  appropriate tables for the System Export.
}
interface

uses SysUtils, Classes,
  // ICE units
  uExportBaseClass,
  uBaseExportManager
  ;

type
  TSystemExportManager = class(TBaseExportManager)
  protected
    function GetTableExporter(pReference: Longword): _ExportBase; override;
  end;

implementation

uses
  // ICE units
  uConsts,
  uCommon,
  uVATExport,
  uCurrencyExport,
  uCCDeptExport,
  uDocNumberExport,
  uGLCodeExport,
  uSystemSettingsExport,
  uPeriodExport,
  uVersionExport
  ;

{ TSystemExportManager }

function TSystemExportManager.GetTableExporter(
  pReference: Longword): _ExportBase;
begin
  Result := nil;
  case pReference of
    cSystemSettingsTable:
      begin
        Result := TSystemSettingsExport.Create;
        Title  := 'System Settings export';
      end;
    cVATTable:
      begin
        Result := TVATExport.Create;
        Title  := 'VAT Table export';
      end;
    cCurrencyTable:
      begin
        Result := TCurrencyExport.Create;
        Title  := 'Currency Table export';
      end;
    cCostCentreTable:
      begin
        Result := TCCDeptExport.Create;
        Title  := 'Cost Centre export';
        TCCDeptExport(Result).ExportType := cdExportCostCentres;
      end;
    cDeptTable:
      begin
        Result := TCCDeptExport.Create;
        Title  := 'Department export';
        TCCDeptExport(Result).ExportType := cdExportDepartments;
      end;
    cDocNumbersTable:
      begin
        Result := TDocNumberExport.Create;
        Title  := 'Document Numbers export';
      end;
    cGLCodeTable:
      begin
        Result := TGLCodeExport.Create;
        Title  := 'G/L Code export';
      end;
    cPeriodTable:
      begin
        Result := TPeriodExport.Create;
        Title  := 'Period Table export';
      end;
    cVersionTable:
      begin
        Result := TVersionExport.Create;
        Title  := 'Version Details export';
      end;
  end;
end;

end.
