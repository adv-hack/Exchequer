{-----------------------------------------------------------------------------
 Unit Name: uExportBaseClass
 Author:    vmoura
 History:

  This unit is just a base class to the ExChequer files...
  The ideia behind this class is create a new overrided class using this methods and
  properties. On the main class, call loadfromdb to be able to get
  the records from exchequer adding a TXMLDOC with the xml record already inserted
  into the xml (BuildXmlRecord). In this way, when i use the property XmlRecord,
  i can typecast the object in the list and get the real XML text...

  This base class can be modified to support all classes whithout any impact on others

  01-10-2006 -> i've changed the fPeriodfrom, fPeriodto: TDatetime to
               fParam1 and fparam2: Olevariant. It will give more
               flexibility to use in other system. Also, it will able us
               to use these params in the way we want


-----------------------------------------------------------------------------}

unit uExportBaseClass;

interface

uses Classes, Forms, SysUtils, Variants,
  MSXML2_TLB,
  uXmlBaseClass,
  uBaseClass,
  uConsts,
  uEXCHBaseClass
;

{$I ice.inc}

type
  _ExportBase = class(_Base)
  private
    fList: TList;
    fFiles: TStringList;
    fParam1: OleVariant;
    fParam2: Olevariant;
    fParam4: OleVariant;
    fParam3: OleVariant;
    fSearchPath: SmallInt;
    fUserReference: Integer;
    fXMLFile: WideString;
    fXSDFile: WideString;
    fXSLFile: Widestring;
    fActiveXMLDoc: TXMLDoc;
    fCDATASections: string;
    fDescription: WideString;
    fUseFiles: Boolean;
    function GetXmlRecord(Index: Integer): WideString;
  protected
    procedure Clear; virtual;

    procedure CreateXMLDoc;

    function BuildXmlRecord(pRec: Pointer): Boolean; overload; virtual; abstract;
    function BuildXmlRecord(pRec: IUnknown): Boolean; overload; virtual; abstract;

    procedure SetAsCDATASection(const CDATASection: string);
    procedure RemoveComments;

    procedure DeleteFiles(FromDir: string; Filter: string);

    property ActiveXMLDoc: TXMLDoc read fActiveXMLDoc write fActiveXMLDoc;
  public
    constructor Create;
    destructor Destroy; Override;
    procedure SaveToXml(pIndex: Integer; Const pFile: String; pOptions:
      TXmlSaveOptions); Virtual;
    function LoadFromDB: Boolean; Virtual; Abstract;

    property XmlRecord[Index: Integer]: WideString Read GetXmlRecord;
  published
    // set a searchkey and path  that will be load when call loadlist
    property Param1: OleVariant Read fParam1 Write fParam1;
    property Param2: OleVariant Read fParam2 Write fParam2;
    property Param3: OleVariant Read fParam3 Write fParam3;
    property Param4: OleVariant Read fParam4 Write fParam4;
    property SearchPath: SmallInt Read fSearchPath Write fSearchPath;

    // list of stored "records"
    property List: TList Read fList Write fList;

    // List of XML files (used instead of List if 'UseFiles' is true -- instead
    // of storing all the XML documents in List, they are written out to
    // file, and the file names are stored in Files).
    property Files: TStringList read fFiles;

    property UseFiles: Boolean read fUseFiles write fUseFiles;

    // set what table will be used...
    property UserReference: Integer Read fUserReference Write fUserReference;
    property XMLFile: WideString read fXMLFile write fXMLFile;
    property XSLFile: Widestring read fXSLFile write fXSLFile;
    property XSDFile: WideString read fXSDFile write fXSDFile;
    property Description: WideString read fDescription write fDescription;

  end;

implementation

uses
  uCompression,
  uCrypto,
  uCommon;

{-----------------------------------------------------------------------------
  Procedure: SaveToXml
  Author:    vmoura

  Save the xml built up with records
-----------------------------------------------------------------------------}
Procedure _ExportBase.SaveToXml(pIndex: Integer; Const pFile: String; pOptions:
  TXmlSaveOptions);
Var
  lXml: WideString;
Begin
  // check index and the xml
  If (pIndex >= 0) And (pIndex < fList.Count) And (XmlRecord[pIndex] <> '') Then
  Begin
    lXml := XmlRecord[pIndex];

    If soDoRemoveChars In pOptions Then
      lXml := _RemoveXmlCharacters(lXml);

    TXMLDoc(fList[pIndex]).SaveXml(lXml, pFile);

    If soDoEncrypt In pOptions Then // encrypt stuff
      _EncryptFile(pFile);

    If soDoCompress In pOptions Then // compress stuff
      _CompressFile(pFile);
  End;
End;

procedure _ExportBase.Clear;
Var
  lObj: TObject;
  lCont: Integer;
Begin
  // to free and delete the object from memory. Only clear doesn't help...
  Try
    For lCont := fList.Count - 1 Downto 0 Do
      If fList[lCont] <> Nil Then
      Begin
        lObj := TObject(fList[lCont]);
        FreeAndNil(lObj);
        fList.Delete(lCont);
      End;
  Except
  End;

  fList.Clear;
end;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura

  Create and initialize the dll
-----------------------------------------------------------------------------}
Constructor _ExportBase.Create;
Begin
  Inherited Create;
  fParam1 := null;
  fParam2 := null;

  fUseFiles := False;

  fList := TList.Create;
  fFiles := TStringList.Create;
End;

// ---------------------------------------------------------------------------

procedure _ExportBase.CreateXMLDoc;
{
  Creates a new XML document handler, and stores the reference in fActiveXMLDoc.

  These document handlers are stored in fList once they have been populated,
  and will be freed when the exporter is closed, so this method does not check
  whether or not there is an already-assigned fActiveXMLDoc.

  If an export fails and is therefore not stored into fList, it is important
  that fActiveXMLDoc is freed as soon as possible afterwards, and before any
  further call to CreateXMLDoc, otherwise we will have a memory leak.

  If the exporter is exporting directly to files, rather than storing the XML
  in fList, we *do* need to free any existing document handlers before creating
  a new one.
}
var
  MsgNode: IXMLDOMNode;
begin
  if UseFiles and Assigned(fActiveXMLDoc) then
    FreeAndNil(fActiveXMLDoc);

  fActiveXMLDoc := TXMLDoc.Create;
  fActiveXMLDoc.Load(XMLFile);

{ <message ... datatype="" desc="" xsl="" xsd=""> }

  MsgNode := _GetNodeByName(ActiveXMLDoc.Doc, 'message');
  MsgNode.attributes.getNamedItem('number').nodeValue := 0;
  MsgNode.attributes.getNamedItem('count').nodeValue := 0;
  MsgNode.attributes.getNamedItem('flag').nodeValue := 0;
  MsgNode.attributes.getNamedItem('plugin').nodeValue := 0;
  MsgNode.attributes.getNamedItem('datatype').nodeValue := UserReference;
  MsgNode.attributes.getNamedItem('xsl').nodeValue := ExtractFileName(XSLFile);
  MsgNode.attributes.getNamedItem('xsd').nodeValue := ExtractFileName(XSDFile);
  MsgNode.attributes.getNamedItem('desc').nodeValue := Description;
  MsgNode.attributes.getNamedItem('startperiod').nodeValue := 0;
  MsgNode.attributes.getNamedItem('startyear').nodeValue := 0;
  MsgNode.attributes.getNamedItem('endperiod').nodeValue := 0;
  MsgNode.attributes.getNamedItem('endyear').nodeValue := 0;

end;

// ---------------------------------------------------------------------------

Destructor _ExportBase.Destroy;
Begin
  Clear;
  if UseFiles and Assigned(fActiveXMLDoc) then
    FreeAndNil(fActiveXMLDoc);

  FreeAndNil(fFiles);
  FreeAndNil(fList);

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetXmlRecord
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ExportBase.GetXmlRecord(Index: integer): WideString;
Begin
  if (UseFiles) then
  begin
    if (Index >= 0) and (Index < fFiles.Count) then
      Result := fFiles[Index];
  end
  else
  begin
    If (Index >= 0) And (Index < fList.Count) Then
    begin
      Result := TXMLDoc(flist[Index]).Doc.xml;
      { The xml property of TXMLDoc will return the XML with the encoding
        instruction removed.

        (See:
        http://msdn.microsoft.com/library/en-us/dnxml/html/xmlencodings.asp,
        esp. the last two paragraphs of the 'Creating new XML documents'
        section).

        We need to put the encoding back in, otherwise reloading a saved copy
        of the file will choke over pound signs and some other characters. }
      Result := StringReplace(Result, '?>', ' encoding="ISO-8859-1"?>', []);
    end;
  end;
End;

// ---------------------------------------------------------------------------

procedure _ExportBase.RemoveComments;
begin
  { Remove any comments from the XML. }
  ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #9#13#10, '', [rfReplaceAll]));
  ActiveXMLDoc.RemoveComments(fCDATASections);
end;

// ---------------------------------------------------------------------------

procedure _ExportBase.SetAsCDATASection(const CDATASection: string);
begin
  fCDATASections := Trim(fCDATASections + ' ' + Trim(CDATASection));
end;

// ---------------------------------------------------------------------------

procedure _ExportBase.DeleteFiles(FromDir, Filter: string);
{ Deletes files from the specified directory. Filter should be a filename, and
  can include wildcards (e.g. '*.xml') }
var
  SearchRec: TSearchRec;
  Found: Integer;
  Path: string;
  Files: TStringList;
  Entry: Integer;
begin
  Files := TStringList.Create;
  try
    { Build a list of all the files. }
    Path := IncludeTrailingPathDelimiter(FromDir);
    Found := FindFirst(Path + Filter, faAnyFile, SearchRec);
    try
      while (Found = 0) do
      begin
        Files.Add(Path + SearchRec.Name);
        Found := FindNext(SearchRec);
      end;
    finally
      FindClose(SearchRec);
    end;
    { Delete the files. }
    for Entry := 0 to Files.Count - 1 do
      DeleteFile(Files[Entry]);
  finally
    Files.Free;
  end;
end;

// ---------------------------------------------------------------------------

end.

