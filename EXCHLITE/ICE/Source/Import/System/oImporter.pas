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
  TSystemDataImporter = class(TAutoObject, IImportBox)
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
  uVATImport,
  uCurrencyImport,
  uCCDeptImport,
  uDocNumberImport,
  uGLCodeImport,
  uSystemSettingsImport,
  uPeriodImport,
  uVersionImport,
  uCommon,
  uHistory,
  uConsts
  ;

function TSystemDataImporter.DoImport(const pCompanyCode, pDataPath, pXML, pXSL,
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
            if FirstRecord then
            begin
              LogMessage(Title + ' for Company ' + pCompanyCode + ' ver ' + PluginVer);
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

function TSystemDataImporter.GetTableImporter(
  pReference: LongWord): _ImportBase;
begin
  Result := nil;
  case pReference of
    cVersionTable:
      begin
        Result := TVersionImport.Create;
        Title  := 'Version details import';
      end;
    cSystemSettingsTable:
      begin
        Result := TSystemSettingsImport.Create;
        Title  := 'System Settings import';
      end;
    cVATTable:
      begin
        Result := TVATImport.Create;
        Title  := 'VAT Rates import';
      end;
    cCurrencyTable:
      begin
        Result := TCurrencyImport.Create;
        Title  := 'Currency Details import';
      end;
    cCostCentreTable:
      begin
        Result := TCCDeptImport.Create;
        Title  := 'Cost Centre import';
        TCCDeptImport(Result).ImportType := cdImportCostCentres;
      end;
    cDeptTable:
      begin
        Result := TCCDeptImport.Create;
        Title  := 'Department import';
        TCCDeptImport(Result).ImportType := cdImportDepartments;
      end;
    cDocNumbersTable:
      begin
        Result := TDocNumberImport.Create;
        Title  := 'Document Numbers import';
      end;
    cGLCodeTable:
      begin
        Result := TGLCodeImport.Create;
        Title  := 'G/L Codes import';
      end;
    cPeriodTable:
      begin
        Result := TPeriodImport.Create;
        Title  := 'User-Defined Periods import';
      end;
  end;
end;

procedure TSystemDataImporter.Initialize;
begin
  inherited;
  FirstRecord := True;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSystemDataImporter, Class_SystemDataImporter,
    ciMultiInstance, tmApartment);
end.
