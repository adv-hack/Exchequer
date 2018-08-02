unit oImporter;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, ComObj, ActiveX, StdVcl,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb,
  DSRImport_TLB,
  IrisClientSync_TLB,
  uImportBaseClass,
  uTransactionTracker,
  uICEDripFeed,
  uXMLBaseClass,
  uOpeningBalanceDB,
  uConsts;

type
  TTransactionDataImporter = class(TAutoObject, IImportBox)
  private
    oToolkit: IToolkit;
    Tracker: TTransactionTracker;
    ToolkitIsOpen: Boolean;
    OBCrossRef: TOBCrossReference;
    HasImported: Boolean;
    Title: string;
    function ActivateDripFeed(Header: TXMLHeader): Boolean;
    function OpenOBRef(DataPath: string): LongInt;
    function OpenSystemSettings(DataPath: string): LongInt;
    function OpenToolkit(DataPath: string): LongInt;
    function OpenTracker(DataPath: string): Boolean;
    function GetTableImporter(pReference: LongWord): _ImportBase;
  protected
    function DoImport(const pCompanyCode, pDataPath, pXML, pXSL, pXSD: WideString;
      pUserReference: LongWord): LongWord; safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses ComServ,
  uCommon,
  uBaseClass,
  uTransactionImport,
  uHistoryImport,
  uOpeningBalanceImport,
  uOBMatchingImport,
  uHistory,
  EntLicence,
  Dialogs,
  ComnUnit
  ;

function TTransactionDataImporter.ActivateDripFeed(Header: TXMLHeader): Boolean;
begin
  Result := True;
  if not Tracker.DripFeed.IsActive then
  begin
    { Set start date }
    Tracker.DripFeed.StartYear   := Header.StartYear;
    Tracker.DripFeed.StartPeriod := Header.StartPeriod;
    { Set end date }
    Tracker.DripFeed.EndYear   := Header.EndYear;
    Tracker.DripFeed.EndPeriod := Header.EndPeriod;
    { Switch to drip-feed mode }
    Tracker.DripFeed.IsActive := False;
    Result := Tracker.DripFeed.Save;
    { Set the purge year }
//    Syss.AuditYr := Header.StartYear - 1;
//    Syss.AuditPr := 0;
  end;
end;

destructor TTransactionDataImporter.Destroy;
begin
  Close_File(F[SysF]);
  if Assigned(oToolkit) then
  begin
    oToolkit.CloseToolkit;
    oToolkit := nil;
  end;
  { If this is a Practice system, record the last used document numbers }
  if HasImported and (EnterpriseLicence.elProductType = ptLITEAcct) then
    Tracker.UpdateDocumentNumbers;
  Tracker.Free;
  ToolkitIsOpen := False;
  inherited;
end;

function TTransactionDataImporter.DoImport(const pCompanyCode, pDataPath, pXML, pXSL,
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
    OpenSystemSettings(pDataPath);
    FirstRecord := True;
  end
  else
    FirstRecord := False;
  if Tracker = nil then
    OpenTracker(pDataPath);
  if OBCrossRef = nil then
    OpenOBRef(pDataPath);
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
          if (Tracker <> nil) and (Tracker.DripFeed.ErrorCode in [ERR_DF_NO_DATAPATH,  ERR_DF_INVALID_FILE]) then
            lTable.LogMessage('Could not open drip-feed file: ' + Tracker.DripFeed.ErrorMessage);
          with lTable do
          begin
            if FirstRecord then
              LogMessage(Title + ' import for Company ' + pCompanyCode + ' ver ' + PluginVer);
            IncludeTrace := False;
//            Trace('File: ' + pXML);
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
              HasImported := True;
            end
            else
              Result := cEXTRACTRECORDFROMXMLERROR;
          end;
          if (lTable is TOpeningBalanceImport) then
          begin
            (lTable as TOpeningBalanceImport).oToolkit := nil;
            if Assigned(Tracker) then
            begin
              if Tracker.DripFeed.IsValidForSaving then
              begin
                if not ActivateDripFeed(Header) then
                  lTable.LogMessage('Failed to activate drip-feed mode. Error: ' +
                                    IntToStr(Tracker.DripFeed.ErrorCode));
              end
              else
                lTable.LogMessage('Could not activate drip-feed mode. ' +
                                  Tracker.DripFeed.ErrorMessage);
            end
            else
              lTable.LogMessage('Drip-feed Manager not created');
          end;
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

function TTransactionDataImporter.GetTableImporter(
  pReference: LongWord): _ImportBase;
begin
  Result := nil;
  case pReference of
    cTRANSACTIONTABLE:
    begin
      Result := TTransactionImport.Create;
      (Result as TTransactionImport).oToolkit := oToolkit;
      Title := 'Transaction';
    end;
    cHISTORYTABLE: Result := THistoryImport.Create;
    cOPENINGBALANCETABLE:
    begin
      Result := TOpeningBalanceImport.Create;
      (Result as TOpeningBalanceImport).oToolkit := oToolkit;
      (Result as TOpeningBalanceImport).OBCrossRef := OBCrossRef;
      Title := 'Opening Balance';
    end;
    cOBMATCHINGTABLE:
    begin
      Result := TOBMatchingImport.Create;
      (Result as TOBMatchingImport).oToolkit := oToolkit;
      (Result as TOBMatchingImport).OBCrossRef := OBCrossRef;
      Title := 'Matching Records';
    end;
  end;
end;

procedure TTransactionDataImporter.Initialize;
begin
  inherited;
  ToolkitIsOpen := False;
  HasImported   := False;
end;

function TTransactionDataImporter.OpenTracker(DataPath: string): Boolean;
begin
  if (Tracker = nil) then
  begin
    Tracker := TTransactionTracker.Create;
    Tracker.Datapath := DataPath;
    if (Tracker.DripFeed.ErrorCode in [ERR_DF_NO_DATAPATH, ERR_DF_INVALID_FILE]) then
      Result := False
    else
      Result := True;
  end
  else
    Result := True;
end;

function TTransactionDataImporter.OpenToolkit(DataPath: string): LongInt;
var
  oConfig: IConfiguration;
  a, b, c : longint;
begin
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit2;
  if Assigned(oToolkit) then
  begin
    uCommon.EncodeOpCode(97, a, b, c);
    oToolkit.Configuration.SetDebugMode(a, b, c);
  end
  else
    UpdateLog('TTransactionDataImporter.OpenToolkit: Unable to create COM Toolkit',
              cCONNECTINGDBERROR);
  { Open the table. }
  oConfig := oToolkit.Configuration;
  try
    oConfig.DataDirectory := DataPath;
    oConfig.AutoSetTransCurrencyRates   := False;
    oConfig.AutoSetPeriod               := False;
    oConfig.AutoSetStockCost	          := False;
    oConfig.OverwriteTransactionNumbers	:= False;
    oConfig.UpdateAccountBalances	      := True;
    oConfig.UpdateStockLevels	          := False; //  True;
    oConfig.ValidateJobCostingFields    := True;
  finally
    oConfig := nil;
  end;
  Result := oToolkit.OpenToolkit;
  ToolkitIsOpen := (Result = 0);
end;

function TTransactionDataImporter.OpenSystemSettings(
  DataPath: string): LongInt;
var
  Key: Str255;
  ErrorCode: Integer;
  FuncRes: LongInt;
begin
  ErrorCode := 0;

  { Get the identifier for the main System Settings record (the System Settings
    table holds multiple types of information -- the identifier allows the
    program to locate the correct record for specific information). }
  Key := SysNames[SYSR];

  SetDrive := DataPath;

  { Open the System Settings table... }
  FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  if (FuncRes = 0) then
  begin

    { ...and find the main System Settings record. }
    FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);

    if FuncRes <> 0 then
      ErrorCode := cEXCHLOADINGVALUEERROR;

  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  if (ErrorCode <> 0) then
    UpdateLog('TTransactionDataImporter.OpenSystemSettings:',
              ErrorCode,
              'Error: ' + IntToStr(FuncRes));

  Result := FuncRes;
end;

function TTransactionDataImporter.OpenOBRef(DataPath: string): LongInt;
begin
  OBCrossRef := TOBCrossReference.Create;
  Result := OBCrossRef.InitFile;
  if (Result = 0) then
    Result := OBCrossRef.CreateFile(DataPath);
  if (Result <> 0) then
    UpdateLog('TTransactionDataImporter.OpenOBRef:',
              cCONNECTINGDBERROR,
              'Error: ' + IntToStr(Result));
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTransactionDataImporter, Class_TransactionDataImporter,
    ciMultiInstance, tmApartment);
end.
