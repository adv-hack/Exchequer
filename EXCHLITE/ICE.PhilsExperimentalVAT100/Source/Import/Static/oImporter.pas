unit oImporter;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, ComObj, ActiveX, StdVcl,
  // ICE units
  DSRImport_TLB,
  IrisClientSync_TLB,
  uImportBaseClass,
  uXMLBaseClass;

type
  TStaticDataImporter = class(TAutoObject, IImportBox)
  private
    FirstRecord: Boolean;
    Title: string;
    function GetTableImporter(pReference: LongWord): _ImportBase;
  protected
    function DoImport(const pCompanyCode, pDataPath, pXML, pXSL, pXSD: WideString;
      pUserReference: LongWord): LongWord; safecall;
  public
    procedure Initialize; override;
  end;

implementation

uses ComServ,
  // ICE units
  uConsts,
  uGLStructureImport,
  uCustImport,
  uStockImport,
  uHistory,
  uCommon
  ;

function TStaticDataImporter.DoImport(const pCompanyCode, pDataPath, pXML, pXSL,
  pXSD: WideString; pUserReference: LongWord): LongWord;
var
  lTable: _ImportBase;
  Header: TXMLHeader;
  TempXMLDoc: TXMLDoc;
begin
  Result := S_OK;
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
            begin
              LogMessage(Title + ' for Company ' + CompanyCode + ' ver ' + PluginVer);
              FirstRecord := False;
            end;
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

function TStaticDataImporter.GetTableImporter(
  pReference: LongWord): _ImportBase;
begin
  Result := nil;
  case pReference of
    cGLStructureTable:
      begin
        Result := TGLStructureImport.Create;
        Title  := 'G/L Structure import';
      end;
    cCustTable:
      begin
        Result := TCustImport.Create;
        Title  := 'Customer import';
        TCustImport(Result).ImportType := csImportCustomers;
      end;
    cSupplierTable:
      begin
        Result := TCustImport.Create;
        Title  := 'Supplier import';
        TCustImport(Result).ImportType := csImportSuppliers;
      end;
    cStockTable:
      begin
        Result := TStockImport.Create;
        Title  := 'Stock import';
      end;
  end;
end;

procedure TStaticDataImporter.Initialize;
begin
  inherited;
  FirstRecord := True;
  Title := 'Static import';
end;

initialization
  TAutoObjectFactory.Create(ComServer, TStaticDataImporter, Class_StaticDataImporter,
    ciMultiInstance, tmApartment);
end.
