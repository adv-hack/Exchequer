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
  uMatchingExportManager;

type
  TMatchingDataExporter = class(TAutoObject, IExportBox)
  private
    Manager: TMatchingExportManager;
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

destructor TMatchingDataExporter.Destroy;
begin
  Params.DataPath := '';
  Params.XMLPath  := '';
  Params.Param1   := '';
  Params.Param2   := '';
  if Assigned(Manager) then
    FreeAndNil(Manager);
  inherited;
end;

function TMatchingDataExporter.DoExport(const pCompanyCode, pDataPath,
  pXMLPath: WideString; pParam1, pParam2, pParam3, pParam4: OleVariant;
  pUserReference: LongWord): LongWord;
begin
  Result := S_OK;

  { The Matching plug-in is no longer required, and the plug-in should not be
    used any more. But just in case... }
  Exit;
  
  Params.DataPath := pDataPath;
  Params.XMLPath  := pXMLPath;
  Params.Param1   := pParam1;
  Params.Param2   := pParam2;
  Params.Param3   := pParam3;
  Params.Param4   := pParam4;
  Manager.ClearXMLList;
  Manager.CompanyCode := pCompanyCode;
  Manager.Title := 'Matching export';

  Result := Manager.ExportTable(cMatchingTable, Params)

end;

function TMatchingDataExporter.Get_XmlCount: Integer;
begin
  If Assigned(Manager) Then
    Result := Manager.Get_XMLCount;
end;

function TMatchingDataExporter.Get_XmlList(Index: Integer): WideString;
begin
  if Assigned(Manager) then
    Result := Manager.Get_XmlList(Index);
end;

procedure TMatchingDataExporter.Initialize;
begin
  inherited;
  Manager := TMatchingExportManager.Create;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMatchingDataExporter, Class_MatchingDataExporter,
    ciMultiInstance, tmApartment);
end.
