unit uBaseExportManager;
{
  This class handles the processing which is common to all the Exporter
  classes, and is used by each of the T...DataExporter classes (in the
  various oExporter.pas units).

  The individual export systems (Static, System, etc.) inherit from this
  class, and override the GetTableExporter method to return the appropriate
  exporter classes.
}
interface

uses SysUtils, Classes,
  // ICE units
  uExportBaseClass,
  uBaseClass
  ;

type
  TExportParams = record
    DataPath: string;
    XMLPath: string;
    Param1: OleVariant;
    Param2: OleVariant;
    Param3: OleVariant;
    Param4: OleVariant;
  end;
  TBaseExportManager = class(_Base)
  private
    fCompanyCode: string;
    fXmlList: TStringList;
    fTitle: string;
  protected
    function BeforeExport(TableID: LongWord; Params: TExportParams): Boolean; virtual;
    function GetTableExporter(pReference: Longword): _ExportBase; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearXMLList;
    function ExportTable(TableID: LongWord; Params: TExportParams): LongWord;
    function Get_XmlCount: Integer;
    function Get_XmlList(Index: Integer): WideString;
    property CompanyCode: string read fCompanyCode write fCompanyCode;
    property Title: string read fTitle write fTitle;
  end;

implementation

uses
  // ICE units
  uConsts,
  uHistory,
  uCommon
  ;

// ==========================================================================
// TBaseExportManager
// ==========================================================================

function TBaseExportManager.BeforeExport(TableID: LongWord;
  Params: TExportParams): Boolean;
begin
  { Base procedure does nothing. Can be overridden by descendant classes to
    provide any initialisation required by all the exporters handled by this
    manager. }
  Result := True;
end;

// ---------------------------------------------------------------------------

constructor TBaseExportManager.Create;
begin
  inherited Create;
  fXMLList := TStringList.Create;
  fTitle   := 'Export';
end;

// ---------------------------------------------------------------------------

procedure TBaseExportManager.ClearXMLList;
begin
  fXmlList.Clear;
end;

// ---------------------------------------------------------------------------

destructor TBaseExportManager.Destroy;
begin
  FreeAndNil(fXMLList);
  inherited;
end;

// ---------------------------------------------------------------------------

function TBaseExportManager.ExportTable(TableID: LongWord;
  Params: TExportParams): LongWord;
var
  Exporter: _ExportBase;
  ExporterDetails: TDataTransportDetails;
  liCont: Integer;
begin
  Result := S_OK;
  // Get the appropriate Exporter for the data.
  Exporter := GetTableExporter(TableID);
  // Get the other Exporter Details for this table.
  ExporterDetails := _GetDataTransportDetails(TableID);
  if Assigned(Exporter) then
  begin
    LogMessage(Title + ' for Company ' + CompanyCode + ' ver ' + PluginVer);
    BeforeExport(TableID, Params);
    with Exporter do
    try
      // Initialise the Exporter.
      UserReference := TableID;
      XMLFile       := Params.XMLPath + ExporterDetails.BaseFile + '.xml';
      XSLFile       := Params.XMLPath + ExporterDetails.BaseFile + '.xsl';
      XSDFile       := Params.XMLPath + ExporterDetails.BaseFile + '.xsd';
      // Set the Exchequer path.
      DataPath := Params.DataPath;
      // Set the "search" parameters
      Param1 := Params.Param1;
      Param2 := Params.Param2;
      Param3 := Params.Param3;
      Param4 := Params.Param4;
      // Load the records from the Exchequer database
      if LoadFromDB then
      begin
        if Exporter.UseFiles then
        begin
          // Copy the XML file names to the store (to be read by the calling
          // program).
          for liCont := 0 to Files.Count - 1 do
            fXMLList.Add(Files[liCont]);
        end
        else
          // Copy the XML strings to the store (to be read by the calling
          // program).
          for liCont := 0 to List.Count - 1 do
            fXmlList.Add(XmlRecord[liCont]);
      end
      else
        Result := cNODATATOBEEXPORTED;
    finally // with Exporter do...
      FreeAndNil(_ExportBase(Exporter));
    end;
  end
  else
    Result := cEXCHINVALIDTABLE;
end;

// ---------------------------------------------------------------------------

function TBaseExportManager.Get_XmlCount: Integer;
begin
  Result := fXMLList.Count;
end;

// ---------------------------------------------------------------------------

function TBaseExportManager.Get_XmlList(Index: Integer): WideString;
begin
  // Check the index
  if Assigned(fXmlList) and (Index >= 0) and (Index < fXmlList.Count) then
  try
    Result := fXmlList[Index];
  except
    Result := '';
  end;
end;

// ---------------------------------------------------------------------------

function TBaseExportManager.GetTableExporter(
  pReference: Longword): _ExportBase;
begin
  Result := nil;
end;

// ---------------------------------------------------------------------------

end.
