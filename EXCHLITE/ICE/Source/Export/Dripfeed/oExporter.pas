unit oExporter;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, ComObj, ActiveX, StdVcl,
  // ICE units
  IrisClientSync_TLB,
  DSRExport_TLB,
  uExportBaseClass,
  uBaseExportManager,
  uDripfeedExportManager;

type
  TDripfeedDataExporter = class(TAutoObject, IExportBox)
  private
    Manager: TDripfeedExportManager;
    Params: TExportParams;
  protected
    function DoExport(const pCompanyCode, pDataPath, pXMLPath: WideString; pParam1,
      pParam2, pParam3, pParam4: OleVariant; pUserReference: LongWord): LongWord; safecall;
    function Get_XmlCount: Integer; safecall;
    function Get_XmlList(Index: Integer): WideString; safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses
  ComServ,
  uConsts
  ;

// ==========================================================================
// TDripfeedDataExporter
// ==========================================================================

destructor TDripfeedDataExporter.Destroy;
begin
  Params.DataPath := '';
  Params.XMLPath  := '';
  Params.Param1   := '';
  Params.Param2   := '';
  if Assigned(Manager) then
    FreeAndNil(Manager);
  inherited;
end;

// ---------------------------------------------------------------------------

function TDripfeedDataExporter.DoExport(const pCompanyCode, pDataPath,
  pXMLPath: WideString; pParam1, pParam2, pParam3, pParam4: OleVariant;
  pUserReference: LongWord): LongWord;
{ Main entry point. Note that the pUserReference parameter is ignored for this
  particular exporter, as there is only one valid export type. }
begin
  Result := S_OK;
  Params.DataPath := pDataPath;
  Params.XMLPath  := pXMLPath;
  Params.Param1   := pParam1;
  Params.Param2   := pParam2;
  Params.Param3   := pParam3;
  Params.Param4   := pParam4;
  if Assigned(Manager) then
  begin
    Manager.ClearXMLList;
    Manager.CompanyCode := pCompanyCode;
    Result := Manager.ExportTable(pUserReference, Params);
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedDataExporter.Get_XmlCount: Integer;
{ Returns a count of the number of records created by the exporter. This will
  obviously only be valid after an export has been run. }
begin
  if Assigned(Manager) Then
    Result := Manager.Get_XMLCount;
end;

// ---------------------------------------------------------------------------

function TDripfeedDataExporter.Get_XmlList(Index: Integer): WideString;
{ Returns either the file name (including the full path) of the exported
  record, or a string containing the full XML of the record. }
begin
  if Assigned(Manager) then
    Result := Manager.Get_XmlList(Index);
end;

// ---------------------------------------------------------------------------

procedure TDripfeedDataExporter.Initialize;
begin
  inherited;
  Manager := TDripfeedExportManager.Create;
end;

// ---------------------------------------------------------------------------

initialization
  TAutoObjectFactory.Create(ComServer, TDripfeedDataExporter, Class_DripfeedDataExporter,
    ciMultiInstance, tmApartment);

end.
