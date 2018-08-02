unit oImporter;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, ComObj, ActiveX, StdVcl,
  // ICE units
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb,
  DSRImport_TLB,
  IrisClientSync_TLB,
  uImportBaseClass,
  uTransactionTracker,
  uXMLBaseClass;

type
  TDripfeedDataImporter = class(TAutoObject, IImportBox)
  private
    Tracker: TTransactionTracker;
    oToolkit: IToolkit;
    ToolkitIsOpen: Boolean;
    function OpenToolkit(DataPath: string): LongInt;
    function GetTableImporter(pReference: LongWord): _ImportBase;
  protected
    function DoImport(const pCompanyCode, pDataPath, pXML, pXSL, pXSD: WideString;
      pUserReference: LongWord): LongWord; safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses
  ComServ,
  uCommon,
  uConsts,
  uDripfeedImport,
  uHistory,
  CTKUtil
  ;

// ===========================================================================
// TDripfeedDataImporter
// ===========================================================================

destructor TDripfeedDataImporter.Destroy;
begin
  if Assigned(Tracker) then
  begin
//    Tracker.UpdateDocumentNumbers;
    Tracker.Free;
    Tracker := nil;
  end;
  if Assigned(oToolkit) then
  begin
    oToolkit.CloseToolkit;
    oToolkit := nil;
  end;
  ToolkitIsOpen := False;
  inherited;
end;

// ---------------------------------------------------------------------------

function TDripfeedDataImporter.DoImport(const pCompanyCode, pDataPath, pXML, pXSL,
  pXSD: WideString; pUserReference: LongWord): LongWord;
var
  lTable: _ImportBase;
  Header: TXMLHeader;
  TempXMLDoc: TXMLDoc;
  FirstRecord: Boolean;
begin
  Result := S_OK;
  if not ToolkitIsOpen then
  begin
    OpenToolkit(pDataPath);
    Tracker.DataPath := pDataPath;
    FirstRecord := True;
  end
  else
    FirstRecord := False;
  TempXMLDoc := TXMLDoc.Create;
  try
    { If pXML refers to a valid file, then try to load the file... }
    if FileExists(pXML) then
      TempXMLDoc.Load(pXML)
    else
      { ...otherwise assume that pXML holds the actual XML as a string, and try
        to load it into the XML document. }
      TempXMLDoc.LoadXml(pXML);
    if (TempXMLDoc.Doc.xml <> '') then
    begin
      if _GetXMLHeader(TempXMLDoc, Header) then
      begin
        { Get the appropriate Importer object, as identified by the datatype
          id number from the XML. }
        lTable := GetTableImporter(Header.datatype);
        if Assigned(lTable) then
        begin
          with lTable do
          begin
            CompanyCode := pCompanyCode;
            if FirstRecord then
              LogMessage('Dripfeed import for Company ' + CompanyCode + ' ver ' + PluginVer);
            { Copy the XML from the temporary document into the importer's
              document. }
            XMLDoc.Load(TempXMLDoc.Doc.xml);
            { Set up the other Importer parameters. }
            DataPath := pDataPath;
            UserReference := pUserReference;
            { Get the records from the xml... }
            if Extract then
            begin
              { ...and save them into the database. }
              if not SaveListtoDb then
                Result := cIMPORTINGXMLERROR;
            end
            else
              Result := cEXTRACTRECORDFROMXMLERROR;
          end;
          (lTable as TDripfeedImport).oToolkit := nil;
          FreeAndNil(lTable);
        end
        else
          Result := cEXCHINVALIDTABLE;
      end
      else
        Result := cLOADINGXMLHEADERERROR;
    end
    else
      Result := cLOADINGFILEERROR;
  finally
    TempXMLDoc.Free;
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedDataImporter.GetTableImporter(
  pReference: LongWord): _ImportBase;
begin
  Result := TDripfeedImport.Create;
  (Result as TDripfeedImport).oToolkit := oToolkit;
end;

// ---------------------------------------------------------------------------

procedure TDripfeedDataImporter.Initialize;
begin
  inherited;
  ToolkitIsOpen := False;
end;

// ---------------------------------------------------------------------------

function TDripfeedDataImporter.OpenToolkit(DataPath: string): LongInt;
var
  oConfig: IConfiguration;
begin
  { Open the table. }
  oToolkit := CreateToolkitWithBackdoor;
  oConfig := oToolkit.Configuration;
  try
    oConfig.DataDirectory := DataPath;
    oConfig.AutoSetTransCurrencyRates   := False;
    oConfig.AutoSetPeriod               := False;
    oConfig.AutoSetStockCost	          := False;
    oConfig.OverwriteTransactionNumbers	:= True;
    oConfig.UpdateAccountBalances	      := True;
    oConfig.UpdateStockLevels	          := False;
    oConfig.ValidateJobCostingFields    := True;
  finally
    oConfig := nil;
  end;
  Result := oToolkit.OpenToolkit;
  { Also create the Transaction Tracker, for updating Document Numbers }
  Tracker := TTransactionTracker.Create;
  ToolkitIsOpen := True;
end;

// ---------------------------------------------------------------------------

initialization
  TAutoObjectFactory.Create(ComServer, TDripfeedDataImporter, Class_DripfeedDataImporter,
    ciMultiInstance, tmApartment);

// ---------------------------------------------------------------------------

end.
