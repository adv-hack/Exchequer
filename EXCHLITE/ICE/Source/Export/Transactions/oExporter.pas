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
  uTransactionExportManager;

type
  TTransactionDataExporter = class(TAutoObject, IExportBox)
  private
    Manager: TTransactionExportManager;
    Params: TExportParams;
  protected
    function DoExport(const pCompanyCode, pDataPath: WideString;
                      const pXMLPath: WideString; pParam1: OleVariant;
                      pParam2: OleVariant; pParam3: OleVariant; pParam4: OleVariant;
                      pUserReference: LongWord): LongWord; safecall;
    function Get_XmlCount: Integer; safecall;
    function Get_XmlList(Index: Integer): WideString; safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses ComServ, uConsts;

destructor TTransactionDataExporter.Destroy;
begin
  Params.DataPath := '';
  Params.XMLPath  := '';
  Params.Param1   := '';
  Params.Param2   := '';
  if Assigned(Manager) then
    FreeAndNil(Manager);
  inherited;
end;

function TTransactionDataExporter.DoExport(const pCompanyCode, pDataPath,
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
  begin
    Result := Manager.ExportTable(cOPENINGBALANCETABLE, Params);
//    if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
//      Result := Manager.ExportTable(cHISTORYTABLE, Params);
//    if (Result = S_OK) or (Result = cNODATATOBEEXPORTED) then
//      Result := Manager.ExportTable(cTRANSACTIONTABLE, Params);
  end;

end;

function TTransactionDataExporter.Get_XmlCount: Integer;
begin
  if Assigned(Manager) then
    Result := Manager.Get_XMLCount;
end;

function TTransactionDataExporter.Get_XmlList(Index: Integer): WideString;
begin
  if Assigned(Manager) then
    Result := Manager.Get_XmlList(Index);
end;

procedure TTransactionDataExporter.Initialize;
begin
  inherited;
  Manager := TTransactionExportManager.Create;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTransactionDataExporter, Class_TransactionDataExporter,
    ciMultiInstance, tmApartment);
end.
