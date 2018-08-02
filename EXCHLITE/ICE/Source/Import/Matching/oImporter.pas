unit oImporter;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, ComObj, ActiveX, StdVcl,
  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,
//  Enterprise01_TLB,

  // ICE units
  DSRImport_TLB,
  IrisClientSync_TLB,
  uImportBaseClass,
  uXMLBaseClass;

type
  TMatchingDataImporter = class(TAutoObject, IImportBox)
  private
    isFileOpen: Boolean;
    function GetTableImporter(pReference: LongWord): _ImportBase;
    function OpenFile(DataPath: string): Integer;
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
  uMatchingImport
  ;

destructor TMatchingDataImporter.Destroy;
begin
  if isFileOpen then
  begin
    Close_File(F[PwrdF]);
    isFileOpen := False;
  end;
  inherited;
end;

function TMatchingDataImporter.DoImport(const pCompanyCode, pDataPath, pXML, pXSL,
  pXSD: WideString; pUserReference: LongWord): LongWord;
var
  lTable: _ImportBase;
  Header: TXMLHeader;
  TempXMLDoc: TXMLDoc;
  FirstRecord: Boolean;
begin
  Result := S_OK;

  { Matching Import is now done through the Opening Balance Import, and this
    plugin should be removed. Just in case, though... }
  Exit;

  if not isFileOpen then
  begin
    OpenFile(pDataPath);
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
            if FirstRecord then
              LogMessage('Matching import for Company ' + pCompanyCode);
            IncludeTrace := True;
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

function TMatchingDataImporter.GetTableImporter(
  pReference: LongWord): _ImportBase;
begin
  Result := nil;
  case pReference of
    cMatchingTable: Result := TMatchingImport.Create;
  end;
end;

procedure TMatchingDataImporter.Initialize;
begin
  inherited;
  isFileOpen := False;
end;

function TMatchingDataImporter.OpenFile(DataPath: string): Integer;
var
  FuncRes: LongInt;
begin
  Result := 0;
  if not isFileOpen then
  begin
    SetDrive := DataPath;
    { Open the file. }
    FuncRes := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
    if (FuncRes = 0) then
      isFileOpen := True;
    Result := FuncRes;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMatchingDataImporter, Class_MatchingDataImporter,
    ciMultiInstance, tmApartment);
end.
