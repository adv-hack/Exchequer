unit uMatchingExportManager;
{
  This class handles the processing which is common to all the Exporter
  classes, and is used by each of the T...DataExporter classes (in the
  various oExporter.pas units).

  The main processing is done by the ancestor class (TBaseExportManager), and
  this class simply overrides the GetTableExporter method to return the
  appropriate table for the Transaction Export.
}
interface

uses SysUtils, Classes,
  // ICE units
  uExportBaseClass,
  uBaseExportManager,
  uMatchingExport
  ;

type
  TMatchingExportManager = class(TBaseExportManager)
  protected
    function GetTableExporter(pReference: Longword): _ExportBase; override;
  end;

implementation

uses
  // ICE units
  uConsts,
  uCommon
  ;

{ TMatchingExportManager }

function TMatchingExportManager.GetTableExporter(
  pReference: Longword): _ExportBase;
begin
  Result := nil;
  case pReference of
    cMatchingTable: Result := TMatchingExport.Create;
  end;
end;

end.
