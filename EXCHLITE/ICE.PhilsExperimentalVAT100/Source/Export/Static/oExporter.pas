unit oExporter;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, Classes, ComObj, ActiveX, StdVcl,
  // ICE units
  IrisClientSync_TLB,
  DSRExport_TLB,
  uExportBaseClass,
  uBaseExportManager,
  uStaticExportManager;

type
  TStaticDataExporter = class(TAutoObject, IExportBox)
  private
    Manager: TStaticExportManager;
    Params: TExportParams;
    function ExportAll: LongWord;
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

uses ComServ,
  SysU2,
  // ICE units
  uConsts
  ;

// ===========================================================================
// TStaticDataExporter
// ===========================================================================

destructor TStaticDataExporter.Destroy;
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

function TStaticDataExporter.DoExport(const pCompanyCode, pDataPath,
  pXMLPath: WideString; pParam1, pParam2, pParam3, pParam4: OleVariant;
  pUserReference: LongWord): LongWord;
begin
  Result := S_OK;
  Params.DataPath := pDataPath;
  Params.XMLPath  := pXMLPath;
  Params.Param1   := pParam1;
  Params.Param2   := pParam2;
  Params.Param3   := pParam3;
  Params.Param4   := pParam4;
  Manager.ClearXMLList;
  Manager.CompanyCode := pCompanyCode;
  if (pUserReference > 0) then
    Result := Manager.ExportTable(pUserReference, Params)
  else
    Result := ExportAll;
end;

// ---------------------------------------------------------------------------

function TStaticDataExporter.ExportAll: LongWord;
begin
  Result := Manager.ExportTable(cGLStructureTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cCustTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cSupplierTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cStockTable, Params);
end;

// ---------------------------------------------------------------------------

function TStaticDataExporter.Get_XmlCount: Integer;
begin
  If Assigned(Manager) Then
    Result := Manager.Get_XMLCount;
end;

// ---------------------------------------------------------------------------

function TStaticDataExporter.Get_XmlList(Index: Integer): WideString;
begin
  if Assigned(Manager) then
    Result := Manager.Get_XmlList(Index);
end;

// ---------------------------------------------------------------------------

procedure TStaticDataExporter.Initialize;
begin
  inherited;
  Manager := TStaticExportManager.Create;
end;

// ---------------------------------------------------------------------------

initialization
  TAutoObjectFactory.Create(ComServer, TStaticDataExporter, Class_StaticDataExporter,
    ciMultiInstance, tmApartment);

// ---------------------------------------------------------------------------

end.
