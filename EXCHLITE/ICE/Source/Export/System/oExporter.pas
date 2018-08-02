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
  uSystemExportManager;

type
  TSystemDataExporter = class(TAutoObject, IExportBox)
  private
    Manager: TSystemExportManager;
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
  // ICE units
  uConsts
  ;

// ===========================================================================
// TSystemDataExporter
// ===========================================================================

destructor TSystemDataExporter.Destroy;
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

function TSystemDataExporter.DoExport(const pCompanyCode, pDataPath,
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
  Manager.CompanyCode := pCompanyCode;
  if (pUserReference > 0) then
    Result := Manager.ExportTable(pUserReference, Params)
  else
    Result := ExportAll;
end;

// ---------------------------------------------------------------------------

function TSystemDataExporter.ExportAll: LongWord;
begin
  Result := Manager.ExportTable(cVersionTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cSystemSettingsTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cVATTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cCurrencyTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cCostCentreTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cDeptTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cDocNumbersTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cGLCodeTable, Params);
  if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
    Result := Manager.ExportTable(cPeriodTable, Params);
end;

// ---------------------------------------------------------------------------

function TSystemDataExporter.Get_XmlCount: Integer;
begin
  If Assigned(Manager) Then
    Result := Manager.Get_XMLCount;
end;

// ---------------------------------------------------------------------------

function TSystemDataExporter.Get_XmlList(Index: Integer): WideString;
begin
  if Assigned(Manager) then
    Result := Manager.Get_XmlList(Index);
end;

// ---------------------------------------------------------------------------

procedure TSystemDataExporter.Initialize;
begin
  inherited;
  Manager := TSystemExportManager.Create;
end;

// ---------------------------------------------------------------------------

initialization
  TAutoObjectFactory.Create(ComServer, TSystemDataExporter,
    Class_SystemDataExporter, ciMultiInstance, tmApartment);

// ---------------------------------------------------------------------------

end.
