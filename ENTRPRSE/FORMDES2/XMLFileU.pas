unit XMLFileU;

interface

uses SysUtils, Classes, GlobType, gmXML;

type
  TEFXReportFileInfo = record
    IsValid: Boolean;
    Version: SmallInt;
    Compressed: Boolean;
  end;

  TXMLFile = class(TObject)
  private
    XML: TgmXML;
    FileSpec: string;
    FNode: TgmXMLNode;
    FNodeIndex: Integer;
    FRootNode: TgmXMLNode;
    FWithCompression: Boolean;
    FErrorMessage: string;

    procedure ReadFont(var Font: fdFontDefType; TagName: string; FromNode: TgmXMLNode = nil);

    { Reads the various record types from the XML. }
    procedure ReadHeader(var FormDef: FormDefRecType);
    procedure ReadText(var FormDef: FormDefRecType);
    procedure ReadLine(var FormDef: FormDefRecType);
    procedure ReadBitmap(var FormDef: FormDefRecType);
    procedure ReadTable(var FormDef: FormDefRecType);
    procedure ReadPage(var FormDef: FormDefRecType);
    procedure ReadFormula(var FormDef: FormDefRecType);
    procedure ReadBox(var FormDef: FormDefRecType);
    procedure ReadDbField(var FormDef: FormDefRecType);
    procedure ReadFieldCol(var FormDef: FormDefRecType);
    procedure ReadFormulaCol(var FormDef: FormDefRecType);
    procedure ReadGroup(var FormDef: FormDefRecType);
    procedure ReadStrings(var FormDef: FormDefRecType);

    { Finds the node which matches the specified property name, and returns the
      value. Returns Default if the node cannot be found. }
    function ReadXML(Nodes: TgmXMLNodeList; PropertyName: ShortString;
      Default: string): string; overload;
    function ReadXML(Nodes: TgmXMLNodeList; PropertyName: ShortString;
      Default: Integer): Integer; overload;
    function ReadXML(Nodes: TgmXMLNodeList; PropertyName: ShortString;
      Default: Boolean): Boolean; overload;

    { Adds the various record types to the XML (FormDef must hold an
      appropriate record). }
    procedure WriteHeader(FormDef: FormDefRecType);
    procedure WriteText(FormDef: FormDefRecType);
    procedure WriteLine(FormDef: FormDefRecType);
    procedure WriteBitmap(FormDef: FormDefRecType);
    procedure WriteTable(FormDef: FormDefRecType);
    procedure WritePage(FormDef: FormDefRecType);
    procedure WriteFormula(FormDef: FormDefRecType);
    procedure WriteBox(FormDef: FormDefRecType);
    procedure WriteDbField(FormDef: FormDefRecType);
    procedure WriteFieldCol(FormDef: FormDefRecType);
    procedure WriteFormulaCol(FormDef: FormDefRecType);
    procedure WriteGroup(FormDef: FormDefRecType);
    procedure WriteStrings(FormDef: FormDefRecType);

    procedure WriteFont(Font: fdFontDefType; TagName: string);

  public
    constructor Create;
    destructor Destroy; override;

    { Adds a new entry to the XML file, based on the supplied record. }
    function AddRec(FormDef: FormDefRecType): LongInt;

    { Starts a new XML file. }
    procedure StartNewFile(FileSpec: string; WithCompression: Boolean);

    { Finishes a new XML file, and writes it to disk. }
    procedure CloseNewFile;

    { Opens an XML file for reading, and loads the first node into
      the Node property. Returns 0 on success. }
    function OpenFile(FileSpec: string): LongInt;

    { Closes the currently open XML file. }
    procedure CloseFile;

    { Reads the contents of the current node into the FormDef record. }
    procedure ReadNode(var FormDef: FormDefRecType);

    { Locates the next node, and sets it as the current node. Returns 9 if
      there are no more nodes in the XML. }
    function NextNode: LongInt;

    { Returns the version details of the specified file. }
    class function Version(FileName: ShortString): TEFXReportFileInfo;

    { Holds a reference to the current node in the XML. Only valid when reading
      an XML file. }
    property Node: TgmXMLNode read FNode write FNode;

    property ErrorMessage: string read FErrorMessage;
  end;

implementation

uses Graphics, Dialogs, ZLib;

const
  { Identifying string -- appears unencrypted at the start of the new format
    report files. The first byte indicates whether or not the file is
    compressed, and the last byte is intended to be the version number. }
  VER_2_FILE_ID            = #221#145#146#158#200;
  VER_2_COMPRESSED_FILE_ID = #222#145#146#158#200;

procedure ExpandStream(inpStream, outStream: TStream);
{ Uses ZLib to uncompress the data from inpStream, outputting the uncompressed
  results in outStream. Used by the TVRWReportFile.Read routine. }
var
  InpBuf,OutBuf: Pointer;
  OutBytes,sz: integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  sz := inpStream.size-inpStream.Position;
  if sz > 0 then try
    GetMem(InpBuf,sz);
    inpStream.Read(InpBuf^,sz);
    DecompressBuf(InpBuf,sz,0,OutBuf,OutBytes);
    outStream.Write(OutBuf^,OutBytes);
  finally
    if InpBuf <> nil then FreeMem(InpBuf);
    if OutBuf <> nil then FreeMem(OutBuf);
  end;
  outStream.Position := 0;
end;

// =============================================================================
// TXMLFile
// =============================================================================

function TXMLFile.AddRec(FormDef: FormDefRecType): LongInt;
var
  Node: TgmXMLNode;
begin
  { Create the common XML elements. }
  if not (FormDef.fdFieldClass in [fdcMaxSize]) then
  begin
    // <entry fdRepClass="0" fdFieldOrder="0" fdControlId="" fdGroup="">
    Node := XML.Nodes.AddOpenTag('entry');
    Node.Attributes.AddAttribute('fdRepClass', IntToStr(Ord(FormDef.fdRepClass)));
    Node.Attributes.AddAttribute('fdFieldOrder', IntToStr(FormDef.fdFieldOrder));
    Node.Attributes.AddAttribute('fdFieldClass', IntToStr(Ord(FormDef.fdFieldClass)));
    Node.Attributes.AddAttribute('fdControlId', FormDef.fdControlId);
    Node.Attributes.AddAttribute('fdGroup', FormDef.fdGroup);

    { Determine the field type, and call the appropriate create function. }
    case FormDef.fdFieldClass of
      fdcHeader:     WriteHeader(FormDef);
      fdcText:       WriteText(FormDef);
      fdcLine:       WriteLine(FormDef);
      fdcBitmap:     WriteBitmap(FormDef);
      fdcTable:      WriteTable(FormDef);
      fdcPage:       WritePage(FormDef);
      fdcFormula:    WriteFormula(FormDef);
      fdcBox:        WriteBox(FormDef);
      fdcDbfield:    WriteDbField(FormDef);
      fdcFieldCol:   WriteFieldCol(FormDef);
      fdcFormulaCol: WriteFormulaCol(FormDef);
      fdcGroup:      WriteGroup(FormDef);
      fdcStrings:    WriteStrings(FormDef);
    end;

    XML.Nodes.AddCloseTag;  // entry
  end;

  Result := 0;  // All Ok.
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.CloseFile;
begin
  XML.Nodes.Clear;
  FNode := nil;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.CloseNewFile;
var
  Stream: TFileStream;
  CompressionStream: TCompressionStream;
begin
  FErrorMessage := '';
  XML.Nodes.AddCloseTag;  // report
  try
    Stream := TFileStream.Create(FileSpec, fmCreate);
    try
      if (FWithCompression) then
      begin
        Stream.Write(VER_2_COMPRESSED_FILE_ID, Length(VER_2_FILE_ID));
        CompressionStream := TCompressionStream.Create(clDefault, Stream);
        XML.SaveToStream(CompressionStream);
      end
      else
      begin
        CompressionStream := nil; // DLL issue.
        Stream.Write(VER_2_FILE_ID, Length(VER_2_FILE_ID));
        XML.SaveToStream(Stream);
      end;
    finally
      if Assigned(CompressionStream) then
        CompressionStream.Free;
      Stream.Free;
    end;
  except
    on E:Exception do
    begin
      FErrorMessage := 'Could not create report file ' + FileSpec + ' : ' +
                       #13#10#13#10 +
                       E.Message;
{$IFNDEF V6CONV}
      ShowMessage(FErrorMessage);
{$ENDIF}
    end;
  end;
end;

// -----------------------------------------------------------------------------

constructor TXMLFile.Create;
begin
  inherited Create;
  XML := TgmXML.Create(nil);
end;

// -----------------------------------------------------------------------------

destructor TXMLFile.Destroy;
begin
  XML.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TXMLFile.NextNode: LongInt;
begin
  Result := 0;
  FNodeIndex := FNodeIndex + 1;
  if (FNodeIndex < FRootNode.Children.Count) then
    Node := FRootNode.Children[FNodeIndex]
  else
    Result := 9;
end;

// -----------------------------------------------------------------------------

function TXMLFile.OpenFile(FileSpec: string): LongInt;
var
  InputStream: TFileStream;
  ResultStream: TMemoryStream;
  Version: array[0..Length(VER_2_FILE_ID) - 1] of Byte;
begin
  Result := 0;
  // MH 13/11/2008: Corrected sharing definition
  //InputStream := TFileStream.Create(FileSpec, fmOpenRead, fmShareDenyNone);
  InputStream := TFileStream.Create(FileSpec, fmOpenRead Or fmShareDenyNone);
  ResultStream := TMemoryStream.Create;
  try
    try
      { Read the header }
      InputStream.Read(Version, Length(VER_2_FILE_ID));
      { The first byte of the version array indicates whether the file is
        compressed or not }
      if (Version[0] = 221) then
        { Uncompressed file }
        ResultStream.LoadFromStream(InputStream)
      else
        { Compressed file: Expand into ResultStream }
        ExpandStream(InputStream, ResultStream);
      { Read the uncompressed XML data from ResultStream }
      ResultStream.Position := 0;
      XML.LoadFromStream(ResultStream);
      FRootNode := XML.Nodes.Root;
      if (FRootNode.Children <> nil) then
      begin
        FNodeIndex := 0;
        Node := FRootNode.Children[FNodeIndex];
        if (Node.Name <> 'entry') then
          Result := 30; // Not a valid report file.
      end
      else
        Result := 30; // Not a valid report file.
    except
      on Exception do
        Result := 2;  // I/O error.
    end;
  finally
    ResultStream.Free;
    InputStream.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadBitmap(var FormDef: FormDefRecType);
begin
  FormDef.Bitmap.fbXPos       := ReadXML(Node.Children, 'fbXPos', 0);
  FormDef.Bitmap.fbYPos       := ReadXML(Node.Children, 'fbYPos', 0);
  FormDef.Bitmap.fbWidth      := ReadXML(Node.Children, 'fbWidth', 0);
  FormDef.Bitmap.fbHeight     := ReadXML(Node.Children, 'fbHeight', 0);
  FormDef.Bitmap.fbBitmapPath := ReadXML(Node.Children, 'fbBitmapPath', '');
  FormDef.Bitmap.fbIf.fiIf    := ReadXML(Node.Children, 'fbIf', '');
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadBox(var FormDef: FormDefRecType);
begin
  FormDef.Box.fxXPos         := ReadXML(Node.Children, 'fxXPos', 0);
  FormDef.Box.fxYPos         := ReadXML(Node.Children, 'fxYPos', 0);
  FormDef.Box.fxWidth        := ReadXML(Node.Children, 'fxWidth', 0);
  FormDef.Box.fxHeight       := ReadXML(Node.Children, 'fxHeight', 0);
  FormDef.Box.fxPenWidth     := ReadXML(Node.Children, 'fxPenWidth', 0);
  FormDef.Box.fxPenColor     := TColor(ReadXML(Node.Children, 'fxPenColor', 0));
  FormDef.Box.fxLeftBorder   := ReadXML(Node.Children, 'fxLeftBorder', False);
  FormDef.Box.fxTopBorder    := ReadXML(Node.Children, 'fxTopBorder', False);
  FormDef.Box.fxRightBorder  := ReadXML(Node.Children, 'fxRightBorder', False);
  FormDef.Box.fxBottomBorder := ReadXML(Node.Children, 'fxBottomBorder', False);
  FormDef.Box.fxFill         := ReadXML(Node.Children, 'fxFill', False);
  FormDef.Box.fxIf.fiIf      := ReadXML(Node.Children, 'fxIf', '');
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadDbField(var FormDef: FormDefRecType);
begin
  FormDef.DbField.fdXPos        := ReadXML(Node.Children, 'fdXPos', 0);
  FormDef.DbField.fdYPos        := ReadXML(Node.Children, 'fdYPos', 0);
  FormDef.DbField.fdWidth       := ReadXML(Node.Children, 'fdWidth', 0);
  FormDef.DbField.fdHeight      := ReadXML(Node.Children, 'fdHeight', 0);

  ReadFont(FormDef.DbField.fdFont, 'fdFont');

  FormDef.DbField.fdShortCode   := ReadXML(Node.Children, 'fdShortCode', '');
  FormDef.DbField.fdFieldLen    := ReadXML(Node.Children, 'fdFieldLen', 0);
  FormDef.DbField.fdDecs        := ReadXML(Node.Children, 'fdDecs', 0);
  FormDef.DbField.fdAlign       := TAlignment(ReadXML(Node.Children, 'fdAlign', 0));
  FormDef.DbField.fdBlankIfZero := ReadXML(Node.Children, 'fdBlankIfZero', False);
  FormDef.DbField.fdIf.fiIf     := ReadXML(Node.Children, 'fdIf', '');
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadFieldCol(var FormDef: FormDefRecType);
begin
  FormDef.FieldCol.fdTitle       := ReadXML(Node.Children, 'fdTitle', '');
  FormDef.FieldCol.fdWidth       := ReadXML(Node.Children, 'fdWidth', 0);
  FormDef.FieldCol.fdSpare2      := ReadXML(Node.Children, 'fdSpare2', 0);
  FormDef.FieldCol.fdShortCode   := ReadXML(Node.Children, 'fdShortCode', '');
  FormDef.FieldCol.fdFieldLen    := ReadXML(Node.Children, 'fdFieldLen', 0);
  FormDef.FieldCol.fdAlign       := TAlignment(ReadXML(Node.Children, 'fdAlign', 0));

  ReadFont(FormDef.FieldCol.fdColFont, 'fdColFont');

  FormDef.FieldCol.fdWantSep     := ReadXML(Node.Children, 'fdWantSep', False);
  FormDef.FieldCol.fdDecs        := ReadXML(Node.Children, 'fdDecs', 0);
  FormDef.FieldCol.fdHidden      := ReadXML(Node.Children, 'fdHidden', False);
  FormDef.FieldCol.fdBlankIfZero := ReadXML(Node.Children, 'fdBlankIfZero', False);
  FormDef.FieldCol.fdIf.fiIf     := ReadXML(Node.Children, 'fdIf', '');
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadFont(var Font: fdFontDefType; TagName: string;
  FromNode: TgmXMLNode);
var
  FontNode, StyleNode: TgmXMLNode;
begin
  if (FromNode = nil) then
    FontNode := Node.Children.NodeByName[TagName]
  else
    FontNode := FromNode;
  if (FontNode <> nil) then
  begin
    Font.ffName  := ReadXML(FontNode.Children, 'ffName', 'Arial');
    Font.ffSize  := ReadXML(FontNode.Children, 'ffSize', 8);
    Font.ffColor := TColor(ReadXML(FontNode.Children, 'ffColor', 0));

    Font.ffStyle := [];

    StyleNode := FontNode.Children.NodeByName['ffStyle'];
    if ReadXML(StyleNode.Children, 'fsBold', False) then
      Font.ffStyle := Font.ffStyle + [fsBold];

    StyleNode := FontNode.Children.NodeByName['ffStyle'];
    if ReadXML(StyleNode.Children, 'fsItalic', False) then
      Font.ffStyle := Font.ffStyle + [fsItalic];

    StyleNode := FontNode.Children.NodeByName['ffStyle'];
    if ReadXML(StyleNode.Children, 'fsUnderline', False) then
      Font.ffStyle := Font.ffStyle + [fsUnderline];

    StyleNode := FontNode.Children.NodeByName['ffStyle'];
    if ReadXML(StyleNode.Children, 'fsStrikeOut', False) then
      Font.ffStyle := Font.ffStyle + [fsStrikeOut];

    Font.ffHeight := ReadXML(FontNode.Children, 'ffHeight', -12);
  end;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadFormula(var FormDef: FormDefRecType);
begin
  FormDef.Formula.ffXPos        := ReadXML(Node.Children, 'ffXPos', 0);
  FormDef.Formula.ffYPos        := ReadXML(Node.Children, 'ffYPos', 0);
  FormDef.Formula.ffWidth       := ReadXML(Node.Children, 'ffWidth', 0);
  FormDef.Formula.ffHeight      := ReadXML(Node.Children, 'ffHeight', 0);
  FormDef.Formula.ffAlign       := TAlignment(ReadXML(Node.Children, 'ffAlign', 0));

  ReadFont(FormDef.Formula.ffFont, 'ffFont');

  FormDef.Formula.ffFormula     := ReadXML(Node.Children, 'ffFormula', '');
  FormDef.Formula.ffDecs        := ReadXML(Node.Children, 'ffDecs', 0);
  FormDef.Formula.ffHidden      := ReadXML(Node.Children, 'ffHidden', False);
  FormDef.Formula.ffBlankIfZero := ReadXML(Node.Children, 'ffBlankIfZero', False);
  FormDef.Formula.ffIf.fiIf     := ReadXML(Node.Children, 'ffIf', '');
  FormDef.Formula.ffBarCode     := fdBarCodeType(ReadXML(Node.Children, 'ffBarCode', 0));
  FormDef.Formula.ffBCFlag1     := ReadXML(Node.Children, 'ffBCFlag1', 0);
  FormDef.Formula.ffBCFlag2     := ReadXML(Node.Children, 'ffBCFlag2', 0);
  FormDef.Formula.ffBCFlag3     := ReadXML(Node.Children, 'ffBCFlag3', 0);
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadFormulaCol(var FormDef: FormDefRecType);
begin
  FormDef.FormulaCol.ffTitle       := ReadXML(Node.Children, 'ffTitle', '');
  FormDef.FormulaCol.ffWidth       := ReadXML(Node.Children, 'ffWidth', 0);
  FormDef.FormulaCol.ffAlign       := TAlignment(ReadXML(Node.Children, 'ffAlign', 0));

  ReadFont(FormDef.FormulaCol.ffColFont, 'ffColFont');

  FormDef.FormulaCol.ffWantSep     := ReadXML(Node.Children, 'ffWantSep', False);
  FormDef.FormulaCol.ffFormula     := ReadXML(Node.Children, 'ffFormula', '');
  FormDef.FormulaCol.ffDecs        := ReadXML(Node.Children, 'ffDecs', 0);
  FormDef.FormulaCol.ffHidden      := ReadXML(Node.Children, 'ffHidden', False);
  FormDef.FormulaCol.ffBlankIfZero := ReadXML(Node.Children, 'ffBlankIfZero', False);
  FormDef.FormulaCol.ffIf.fiIf     := ReadXML(Node.Children, 'ffIf', '');
  FormDef.FormulaCol.ffBarCode     := fdBarCodeType(ReadXML(Node.Children, 'ffBarCode', 0));
  FormDef.FormulaCol.ffBCFlag1     := ReadXML(Node.Children, 'ffBCFlag1', 0);
  FormDef.FormulaCol.ffBCFlag2     := ReadXML(Node.Children, 'ffBCFlag2', 0);
  FormDef.FormulaCol.ffBCFlag3     := ReadXML(Node.Children, 'ffBCFlag3', 0);
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadGroup(var FormDef: FormDefRecType);
var
  SubNode: TgmXMLNode;
  i: Integer;
begin
  FormDef.Group.fgXPos    := ReadXML(Node.Children, 'fgXPos', 0);
  FormDef.Group.fgYPos    := ReadXML(Node.Children, 'fgYPos', 0);
  FormDef.Group.fgWidth   := ReadXML(Node.Children, 'fgWidth', 0);
  FormDef.Group.fgHeight  := ReadXML(Node.Children, 'fgHeight', 0);
  FormDef.Group.fgIf.fiIf := ReadXML(Node.Children, 'fgIf', '');

  SubNode := Node.Children.NodeByName['fgRows_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    FormDef.Group.fgRows[i + 1] := SubNode.Children[i].AsInteger;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadHeader(var FormDef: FormDefRecType);
var
  SectionNode: TgmXMLNode;
begin
  FormDef.Header.fhMajVer      := ReadXML(Node.Children, 'fhMajVer', 0);
  FormDef.Header.fhMinVer      := ReadXML(Node.Children, 'fhMinVer', 0);
  FormDef.Header.fhFormType    := fdFormTypeType(ReadXML(Node.Children, 'fhFormType', 0));
  FormDef.Header.fhFormDescr   := ReadXML(Node.Children, 'fhFormDescr', '');
  FormDef.Header.fhCopies      := ReadXML(Node.Children, 'fhCopies', 1);
  FormDef.Header.fhPaperWidth  := ReadXML(Node.Children, 'fhPaperWidth', 0);
  FormDef.Header.fhPaperHeight := ReadXML(Node.Children, 'fhPaperHeight', 0);
  FormDef.Header.fhTopWaste    := ReadXML(Node.Children, 'fhTopWaste', 0);
  FormDef.Header.fhLeftWaste   := ReadXML(Node.Children, 'fhLeftWaste', 0);
  FormDef.Header.fhRightWaste  := ReadXML(Node.Children, 'fhRightWaste', 0);
  FormDef.Header.fhBottomWaste := ReadXML(Node.Children, 'fhBottomWaste', 0);

  FormDef.Header.fhSections := [];

  SectionNode := Node.Children.NodeByName['fhSections'];
  if ReadXML(SectionNode.Children, 'stPageHead', False) then
    FormDef.Header.fhSections := FormDef.Header.fhSections + [stPageHead];

  if ReadXML(SectionNode.Children, 'stBodyHead', False) then
    FormDef.Header.fhSections := FormDef.Header.fhSections + [stBodyHead];

  if ReadXML(SectionNode.Children, 'stBody', False) then
    FormDef.Header.fhSections := FormDef.Header.fhSections + [stBody];

  if ReadXML(SectionNode.Children, 'stBodyFoot', False) then
    FormDef.Header.fhSections := FormDef.Header.fhSections + [stBodyFoot];

  if ReadXML(SectionNode.Children, 'stPageFoot', False) then
    FormDef.Header.fhSections := FormDef.Header.fhSections + [stPageFoot];

  FormDef.Header.fhOrientation := fdOrientationType(ReadXML(Node.Children, 'fhOrientation', 0)); // fdOrientationType;  { = (fdoPortrait, fdoLandscape) }

  ReadFont(FormDef.Header.fhFont, 'fhFont');

  FormDef.Header.fhHeaderSep    := ReadXML(Node.Children, 'fhHeaderSep', 0);
  FormDef.Header.fhBodyHeadSep  := ReadXML(Node.Children, 'fhBodyHeadSep', 0);
  FormDef.Header.fhBodySep      := ReadXML(Node.Children, 'fhBodySep', 0);
  FormDef.Header.fhBodyFootSep  := ReadXML(Node.Children, 'fhBodyFootSep', 0);
  FormDef.Header.fhContinue     := ReadXML(Node.Children, 'fhContinue', '');
  FormDef.Header.fhSerialNo     := ReadXML(Node.Children, 'fhSerialNo', 0);
  FormDef.Header.fhSNoWidth     := ReadXML(Node.Children, 'fhSNoWidth', 0);
  FormDef.Header.fhPrinter      := ReadXML(Node.Children, 'fhPrinter', '');
  FormDef.Header.fhBinNo        := ReadXML(Node.Children, 'fhBinNo', 0);
  FormDef.Header.fhPaperNo      := ReadXML(Node.Children, 'fhPaperNo', 0);
  FormDef.Header.fhLblTop       := ReadXML(Node.Children, 'fhLblTop', 0);
  FormDef.Header.fhLblLeft      := ReadXML(Node.Children, 'fhLblLeft', 0);
  FormDef.Header.fhLblWidth     := ReadXML(Node.Children, 'fhLblWidth', 0);
  FormDef.Header.fhLblHeight    := ReadXML(Node.Children, 'fhLblHeight', 0);
  FormDef.Header.fhLblCols      := ReadXML(Node.Children, 'fhLblCols', 0);
  FormDef.Header.fhLblRows      := ReadXML(Node.Children, 'fhLblRows', 0);
  FormDef.Header.fhLblColGap    := ReadXML(Node.Children, 'fhLblColGap', 0);
  FormDef.Header.fhLblRowGap    := ReadXML(Node.Children, 'fhLblRowGap', 0);
  FormDef.Header.fhPurpose      := ReadXML(Node.Children, 'fhPurpose', 0);
  FormDef.Header.fhInpSNo       := ReadXML(Node.Children, 'fhInpSNo', False);
  FormDef.Header.fhPrintAdjBom  := ReadXML(Node.Children, 'fhPrintAdjBom', 0);
  FormDef.Header.fhDocSortMode  := ReadXML(Node.Children, 'fhDocSortMode', 0);
  FormDef.Header.fhShowBins     := ReadXML(Node.Children, 'fhShowBins', False);
  FormDef.Header.fhShowUseBy    := ReadXML(Node.Children, 'fhShowUseBy', False);
  FormDef.Header.fhStockOrder   := ReadXML(Node.Children, 'fhStockOrder', False);
  FormDef.Header.fhShowAddDesc  := ReadXML(Node.Children, 'fhShowAddDesc', False);
  FormDef.Header.fhSuppressDL   := ReadXML(Node.Children, 'fhSuppressDL', False);
  FormDef.Header.fhShowDescOnly := ReadXML(Node.Children, 'fhShowDescOnly', False);
  FormDef.Header.fhInclNewLines := ReadXML(Node.Children, 'fhInclNewLines', False);
  FormDef.Header.fhExplodeBoMs  := ReadXML(Node.Children, 'fhExplodeBoMs', False);
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadLine(var FormDef: FormDefRecType);
begin
  FormDef.Line.flXPos1    := ReadXML(Node.Children, 'flXPos1', 0);
  FormDef.Line.flYPos1    := ReadXML(Node.Children, 'flYPos1', 0);
  FormDef.Line.flXPos2    := ReadXML(Node.Children, 'flXPos2', 0);
  FormDef.Line.flYPos2    := ReadXML(Node.Children, 'flYPos2', 0);
  FormDef.Line.flPenWidth := ReadXML(Node.Children, 'flPenWidth', 0);
  FormDef.Line.flColor    := TColor(ReadXML(Node.Children, 'flColor', 0));
  FormDef.Line.flType     := TSBSDragLineType(ReadXML(Node.Children, 'flType', 0));
  FormDef.Line.flIf.fiIf  := ReadXML(Node.Children, 'flIf', '');
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadNode(var FormDef: FormDefRecType);
var
  Attr: TgmXMLAttribute;
begin
  { Read the header details (common to all records). }
  Attr := Node.Attributes.ElementByName['fdRepClass'];
  if (Attr <> nil) then
    FormDef.fdRepClass := fdRepClassType(StrToInt(Attr.Value));

  Attr := Node.Attributes.ElementByName['fdFieldOrder'];
  if (Attr <> nil) then
    FormDef.fdFieldOrder := StrToInt(Attr.Value);

  Attr := Node.Attributes.ElementByName['fdFieldClass'];
  if (Attr <> nil) then
    FormDef.fdFieldClass := fdFieldClassType(StrToInt(Attr.Value));

  Attr := Node.Attributes.ElementByName['fdControlId'];
  if (Attr <> nil) then
    FormDef.fdControlId := Attr.Value;

  Attr := Node.Attributes.ElementByName['fdGroup'];
  if (Attr <> nil) then
    FormDef.fdGroup := Attr.Value;

  { Determine the field type, and call the appropriate Read function. }
  case FormDef.fdFieldClass of
    fdcHeader:     ReadHeader(FormDef);
    fdcText:       ReadText(FormDef);
    fdcLine:       ReadLine(FormDef);
    fdcBitmap:     ReadBitmap(FormDef);
    fdcTable:      ReadTable(FormDef);
    fdcPage:       ReadPage(FormDef);
    fdcFormula:    ReadFormula(FormDef);
    fdcBox:        ReadBox(FormDef);
    fdcDbfield:    ReadDbField(FormDef);
    fdcFieldCol:   ReadFieldCol(FormDef);
    fdcFormulaCol: ReadFormulaCol(FormDef);
    fdcGroup:      ReadGroup(FormDef);
    fdcStrings:    ReadStrings(FormDef);
  end;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadPage(var FormDef: FormDefRecType);
begin
  FormDef.PageNo.fpXPos     := ReadXML(Node.Children, 'fpXPos', 0);
  FormDef.PageNo.fpYPos     := ReadXML(Node.Children, 'fpYPos', 0);
  FormDef.PageNo.fpWidth    := ReadXML(Node.Children, 'fpWidth', 0);
  FormDef.PageNo.fpHeight   := ReadXML(Node.Children, 'fpHeight', 0);
  FormDef.PageNo.fpLeading  := ReadXML(Node.Children, 'fpLeading', '');
  FormDef.PageNo.fpTrailing := ReadXML(Node.Children, 'fpTrailing', '');

  ReadFont(FormDef.PageNo.fpFont, 'fpFont');

  FormDef.PageNo.fpIf.fiIf  := ReadXML(Node.Children, 'fpIf', '');
  FormDef.PageNo.fpJustify  := TAlignment(ReadXML(Node.Children, 'fpJustify', 0));
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadStrings(var FormDef: FormDefRecType);
var
  i: Integer;
begin
  for i := 0 to Node.Children.Count - 1 do
    FormDef.FormStrings.fsSVStrs[i + 1] := Node.Children[i].AsDisplayString;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadTable(var FormDef: FormDefRecType);
var
  SubNode: TgmXMLNode;
  i: Integer;
begin
  FormDef.Table.frXPos   := ReadXML(Node.Children, 'frXPos', 0);
  FormDef.Table.frYPos   := ReadXML(Node.Children, 'frYPos', 0);
  FormDef.Table.frWidth  := ReadXML(Node.Children, 'frWidth', 0);
  FormDef.Table.frHeight := ReadXML(Node.Children, 'frHeight', 0);

  ReadFont(FormDef.Table.frFonts[1], 'frFont');

  SubNode := Node.Children.NodeByName['frFontSpare_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    ReadFont(FormDef.Table.frFontSpare[i + 1], 'frFontSpare', SubNode.Children[i]);

  SubNode := Node.Children.NodeByName['frEnable_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    FormDef.Table.frEnable[i + 1] := SubNode.Children[i].AsBoolean;

  SubNode := Node.Children.NodeByName['frEnableSpare_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    FormDef.Table.frEnableSpare[i + 1] := SubNode.Children[i].AsBoolean;

  SubNode := Node.Children.NodeByName['frPenWidth_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    FormDef.Table.frPenWidth[i + 1] := SubNode.Children[i].AsInteger;

  SubNode := Node.Children.NodeByName['frPenWSpare_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    FormDef.Table.frPenWSpare[i + 1] := SubNode.Children[i].AsInteger;

  SubNode := Node.Children.NodeByName['frColour_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    FormDef.Table.frColour[i + 1] := TColor(SubNode.Children[i].AsInteger);

  SubNode := Node.Children.NodeByName['frColourSpare_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    FormDef.Table.frColourSpare[i + 1] := TColor(SubNode.Children[i].AsInteger);

  SubNode := Node.Children.NodeByName['frSizes_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    FormDef.Table.frSizes[i + 1] := SubNode.Children[i].AsInteger;

  SubNode := Node.Children.NodeByName['frSizeSpare_Array'];
  for i := 0 to SubNode.Children.Count - 1 do
    FormDef.Table.frSizeSpare[i + 1] := SubNode.Children[i].AsInteger;

  FormDef.Table.frIf.fiIf := ReadXML(Node.Children, 'frIf', '');
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.ReadText(var FormDef: FormDefRecType);
begin
  FormDef.Text.ftXPos       := ReadXML(Node.Children, 'ftXPos', 0);
  FormDef.Text.ftYPos       := ReadXML(Node.Children, 'ftYPos', 0);
  FormDef.Text.ftWidth      := ReadXML(Node.Children, 'ftWidth', 0);
  FormDef.Text.ftHeight     := ReadXML(Node.Children, 'ftHeight', 0);
  FormDef.Text.ftText       := ReadXML(Node.Children, 'ftText', '');

  ReadFont(FormDef.Text.ftFont, 'ftFont');

  FormDef.Text.ftJustify    := TAlignment(ReadXML(Node.Children, 'ftJustify', 0));
  FormDef.Text.ftIf.fiIf    := ReadXML(Node.Children, 'ftIf', '');
  FormDef.Text.ftSymbolFont := ReadXML(Node.Children, 'ftSymbolFont', False);
end;

// -----------------------------------------------------------------------------

function TXMLFile.ReadXML(Nodes: TgmXMLNodeList; PropertyName: ShortString;
  Default: Boolean): Boolean;
var
  Node: TgmXMLNode;
begin
  Result := Default;
  if (Nodes <> nil) then
  begin
    Node := Nodes.NodeByName[PropertyName];
    if (Node <> nil) then
      Result := Node.AsBoolean;
  end;
end;

// -----------------------------------------------------------------------------

function TXMLFile.ReadXML(Nodes: TgmXMLNodeList; PropertyName: ShortString;
  Default: Integer): Integer;
var
  Node: TgmXMLNode;
begin
  Result := Default;
  if (Nodes <> nil) then
  begin
    Node := Nodes.NodeByName[PropertyName];
    if (Node <> nil) then
      Result := Node.AsInteger;
  end;
end;

// -----------------------------------------------------------------------------

function TXMLFile.ReadXML(Nodes: TgmXMLNodeList; PropertyName: ShortString;
  Default: string): string;
var
  Node: TgmXMLNode;
begin
  Result := Default;
  if (Nodes <> nil) then
  begin
    Node := Nodes.NodeByName[PropertyName];
    if (Node <> nil) then
      Result := Node.AsDisplayString;
  end;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.StartNewFile(FileSpec: string; WithCompression: Boolean);
begin
  self.FileSpec := FileSpec;
  FWithCompression := WithCompression;
  XML.Nodes.Clear;
  XML.Encoding := 'ISO-8859-1';
  XML.Nodes.AddOpenTag('report');
end;

// -----------------------------------------------------------------------------

class function TXMLFile.Version(FileName: ShortString): TEFXReportFileInfo;
var
  FileIn: TFileStream;
  Buffer: array[0..Length(VER_2_FILE_ID) - 1] of Char;
begin
  // MH 13/11/2008: Corrected sharing definition
  //FileIn := TFileStream.Create(FileName, fmOpenRead, fmShareDenyNone);
  FileIn := TFileStream.Create(FileName, fmOpenRead Or fmShareDenyNone);
  try
    { Read the first chunk of the file }
    FileIn.Read(Buffer, Length(Buffer));
    { Look for the version's file identifier }
    if (Buffer = VER_2_FILE_ID) then
    begin
      { New format file, uncompressed }
      Result.IsValid := True;
      Result.Version := 2;
      Result.Compressed := False;
    end
    else if (Buffer = VER_2_COMPRESSED_FILE_ID) then
    begin
      { New format file, compressed }
      Result.IsValid := True;
      Result.Version := 2;
      Result.Compressed := True;
    end
    else
    begin
      { If it wasn't found, this is not a valid report file. }
      Result.IsValid := False;
      Result.Version := 0;
      Result.Compressed := False;
    end;
  finally
    FileIn.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteBitmap(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('fbXPos').AsInteger      := FormDef.Bitmap.fbXPos;
  XML.Nodes.AddLeaf('fbYPos').AsInteger      := FormDef.Bitmap.fbYPos;
  XML.Nodes.AddLeaf('fbWidth').AsInteger     := FormDef.Bitmap.fbWidth;
  XML.Nodes.AddLeaf('fbHeight').AsInteger    := FormDef.Bitmap.fbHeight;
  XML.Nodes.AddLeaf('fbBitmapPath').AsString := FormDef.Bitmap.fbBitmapPath;
  XML.Nodes.AddLeaf('fbIf').AsString         := FormDef.Bitmap.fbIf.fiIf;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteBox(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('fxXPos').AsInteger         := FormDef.Box.fxXPos;
  XML.Nodes.AddLeaf('fxYPos').AsInteger         := FormDef.Box.fxYPos;
  XML.Nodes.AddLeaf('fxWidth').AsInteger        := FormDef.Box.fxWidth;
  XML.Nodes.AddLeaf('fxHeight').AsInteger       := FormDef.Box.fxHeight;
  XML.Nodes.AddLeaf('fxPenWidth').AsInteger     := FormDef.Box.fxPenWidth;
  XML.Nodes.AddLeaf('fxPenColor').AsInteger     := FormDef.Box.fxPenColor;
  XML.Nodes.AddLeaf('fxLeftBorder').AsBoolean   := FormDef.Box.fxLeftBorder;
  XML.Nodes.AddLeaf('fxTopBorder').AsBoolean    := FormDef.Box.fxTopBorder;
  XML.Nodes.AddLeaf('fxRightBorder').AsBoolean  := FormDef.Box.fxRightBorder;
  XML.Nodes.AddLeaf('fxBottomBorder').AsBoolean := FormDef.Box.fxBottomBorder;
  XML.Nodes.AddLeaf('fxFill').AsBoolean         := FormDef.Box.fxFill;
  XML.Nodes.AddLeaf('fxIf').AsString            := FormDef.Box.fxIf.fiIf;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteDbField(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('fdXPos').AsInteger        := FormDef.DbField.fdXPos;
  XML.Nodes.AddLeaf('fdYPos').AsInteger        := FormDef.DbField.fdYPos;
  XML.Nodes.AddLeaf('fdWidth').AsInteger       := FormDef.DbField.fdWidth;
  XML.Nodes.AddLeaf('fdHeight').AsInteger      := FormDef.DbField.fdHeight;

  WriteFont(FormDef.DbField.fdFont, 'fdFont');

  XML.Nodes.AddLeaf('fdSpare2').AsInteger      := FormDef.DbField.fdSpare2;
  XML.Nodes.AddLeaf('fdShortCode').AsString    := FormDef.DbField.fdShortCode;
  XML.Nodes.AddLeaf('fdFieldLen').AsInteger    := FormDef.DbField.fdFieldLen;
  XML.Nodes.AddLeaf('fdDecs').AsInteger        := FormDef.DbField.fdDecs;
  XML.Nodes.AddLeaf('fdAlign').AsInteger       := Ord(FormDef.DbField.fdAlign);
  XML.Nodes.AddLeaf('fdBlankIfZero').AsBoolean := FormDef.DbField.fdBlankIfZero;
  XML.Nodes.AddLeaf('fdIf').AsString           := FormDef.DbField.fdIf.fiIf;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteFieldCol(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('fdTitle').asString        := FormDef.FieldCol.fdTitle;
  XML.Nodes.AddLeaf('fdWidth').AsInteger       := FormDef.FieldCol.fdWidth;
  XML.Nodes.AddLeaf('fdSpare2').AsInteger      := FormDef.FieldCol.fdSpare2;
  XML.Nodes.AddLeaf('fdShortCode').AsString    := FormDef.FieldCol.fdShortCode;
  XML.Nodes.AddLeaf('fdFieldLen').AsInteger    := FormDef.FieldCol.fdFieldLen;
  XML.Nodes.AddLeaf('fdAlign').AsInteger       := Ord(FormDef.FieldCol.fdAlign);

  WriteFont(FormDef.FieldCol.fdColFont, 'fdColFont');

  XML.Nodes.AddLeaf('fdWantSep').AsBoolean     := FormDef.FieldCol.fdWantSep;
  XML.Nodes.AddLeaf('fdDecs').AsInteger        := FormDef.FieldCol.fdDecs;
  XML.Nodes.AddLeaf('fdHidden').AsBoolean      := FormDef.FieldCol.fdHidden;
  XML.Nodes.AddLeaf('fdBlankIfZero').AsBoolean := FormDef.FieldCol.fdBlankIfZero;
  XML.Nodes.AddLeaf('fdIf').AsString           := FormDef.FieldCol.fdIf.fiIf;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteFont(Font: fdFontDefType; TagName: string);
begin
  XML.Nodes.AddOpenTag(TagName);
  XML.Nodes.AddLeaf('ffName').AsString       := Font.ffName;
  XML.Nodes.AddLeaf('ffSize').AsInteger      := Font.ffSize;
  XML.Nodes.AddLeaf('ffColor').AsInteger     := Font.ffColor;

  XML.Nodes.AddOpenTag('ffStyle');
  XML.Nodes.AddLeaf('fsBold').AsBoolean      := fsBold in Font.ffStyle;
  XML.Nodes.AddLeaf('fsItalic').AsBoolean    := fsItalic in Font.ffStyle;
  XML.Nodes.AddLeaf('fsUnderline').AsBoolean := fsUnderline in Font.ffStyle;
  XML.Nodes.AddLeaf('fsStrikeOut').AsBoolean := fsStrikeOut in Font.ffStyle;
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddLeaf('ffPitch').AsInteger     := Ord(Font.ffPitch);
  XML.Nodes.AddLeaf('ffHeight').AsInteger    := Font.ffHeight;
  XML.Nodes.AddCloseTag;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteFormula(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('ffXPos').AsInteger        := FormDef.Formula.ffXPos;
  XML.Nodes.AddLeaf('ffYPos').AsInteger        := FormDef.Formula.ffYPos;
  XML.Nodes.AddLeaf('ffWidth').AsInteger       := FormDef.Formula.ffWidth;
  XML.Nodes.AddLeaf('ffHeight').AsInteger      := FormDef.Formula.ffHeight;

  WriteFont(FormDef.Formula.ffFont, 'ffFont');

  XML.Nodes.AddLeaf('ffFormula').AsString      := FormDef.Formula.ffFormula;
  XML.Nodes.AddLeaf('ffDecs').AsInteger        := FormDef.Formula.ffDecs;
  XML.Nodes.AddLeaf('ffAlign').AsInteger       := Ord(FormDef.Formula.ffAlign);
  XML.Nodes.AddLeaf('ffBlankIfZero').AsBoolean := FormDef.Formula.ffBlankIfZero;
  XML.Nodes.AddLeaf('ffIf').AsString           := FormDef.Formula.ffIf.fiIf;
  XML.Nodes.AddLeaf('ffHidden').AsBoolean      := FormDef.Formula.ffHidden;
  XML.Nodes.AddLeaf('ffBarCode').AsInteger     := Ord(FormDef.Formula.ffBarCode);
  XML.Nodes.AddLeaf('ffBCFlag1').AsInteger     := FormDef.Formula.ffBCFlag1;
  XML.Nodes.AddLeaf('ffBCFlag2').AsInteger     := FormDef.Formula.ffBCFlag2;
  XML.Nodes.AddLeaf('ffBCFlag3').AsInteger     := FormDef.Formula.ffBCFlag3;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteFormulaCol(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('ffTitle').AsString        := FormDef.FormulaCol.ffTitle;
  XML.Nodes.AddLeaf('ffWidth').AsInteger       := FormDef.FormulaCol.ffWidth;
  XML.Nodes.AddLeaf('ffAlign').AsInteger       := Ord(FormDef.FormulaCol.ffAlign);

  WriteFont(FormDef.FormulaCol.ffColFont, 'ffColFont');

  XML.Nodes.AddLeaf('ffWantSep').AsBoolean     := FormDef.FormulaCol.ffWantSep;
  XML.Nodes.AddLeaf('ffFormula').AsString      := FormDef.FormulaCol.ffFormula;
  XML.Nodes.AddLeaf('ffDecs').AsInteger        := FormDef.FormulaCol.ffDecs;
  XML.Nodes.AddLeaf('ffHidden').AsBoolean      := FormDef.FormulaCol.ffHidden;
  XML.Nodes.AddLeaf('ffBlankIfZero').AsBoolean := FormDef.FormulaCol.ffBlankIfZero;
  XML.Nodes.AddLeaf('ffIf').AsString           := FormDef.FormulaCol.ffIf.fiIf;
  XML.Nodes.AddLeaf('ffBarCode').AsInteger     := Ord(FormDef.FormulaCol.ffBarCode);
  XML.Nodes.AddLeaf('ffBCFlag1').AsInteger     := FormDef.FormulaCol.ffBCFlag1;
  XML.Nodes.AddLeaf('ffBCFlag2').AsInteger     := FormDef.FormulaCol.ffBCFlag2;
  XML.Nodes.AddLeaf('ffBCFlag3').AsInteger     := FormDef.FormulaCol.ffBCFlag3;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteGroup(FormDef: FormDefRecType);
var
  i: Integer;
begin
  XML.Nodes.AddLeaf('fgXPos').AsInteger   := FormDef.Group.fgXPos;
  XML.Nodes.AddLeaf('fgYPos').AsInteger   := FormDef.Group.fgYPos;
  XML.Nodes.AddLeaf('fgWidth').AsInteger  := FormDef.Group.fgWidth;
  XML.Nodes.AddLeaf('fgHeight').AsInteger := FormDef.Group.fgHeight;
  XML.Nodes.AddLeaf('fgIf').AsString      := FormDef.Group.fgIf.fiIf;

  XML.Nodes.AddOpenTag('fgRows_Array');
  for i := Low(FormDef.Group.fgRows) to High(FormDef.Group.fgRows) do
    XML.Nodes.AddLeaf('fgRows').AsInteger := FormDef.Group.fgRows[i];
  XML.Nodes.AddCloseTag;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteHeader(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('fhMajVer').AsInteger       := FormDef.Header.fhMajVer;
  XML.Nodes.AddLeaf('fhMinVer').AsInteger       := FormDef.Header.fhMinVer;
  XML.Nodes.AddLeaf('fhFormType').AsInteger     := Ord(FormDef.Header.fhFormType);
  XML.Nodes.AddLeaf('fhFormDescr').AsString     := FormDef.Header.fhFormDescr;
  XML.Nodes.AddLeaf('fhCopies').AsInteger       := FormDef.Header.fhCopies;
  XML.Nodes.AddLeaf('fhPaperWidth').AsInteger   := FormDef.Header.fhPaperWidth;
  XML.Nodes.AddLeaf('fhPaperHeight').AsInteger  := FormDef.Header.fhPaperHeight;
  XML.Nodes.AddLeaf('fhTopWaste').AsInteger     := FormDef.Header.fhTopWaste;
  XML.Nodes.AddLeaf('fhLeftWaste').AsInteger    := FormDef.Header.fhLeftWaste;
  XML.Nodes.AddLeaf('fhRightWaste').AsInteger   := FormDef.Header.fhRightWaste;
  XML.Nodes.AddLeaf('fhBottomWaste').AsInteger  := FormDef.Header.fhBottomWaste;

  // TPageStructureSet
  XML.Nodes.AddOpenTag('fhSections');
  XML.Nodes.AddLeaf('stPageHead').AsBoolean     := (stPageHead in FormDef.Header.fhSections);
  XML.Nodes.AddLeaf('stBodyHead').AsBoolean     := (stBodyHead in FormDef.Header.fhSections);
  XML.Nodes.AddLeaf('stBody').AsBoolean         := (stBody in FormDef.Header.fhSections);
  XML.Nodes.AddLeaf('stBodyFoot').AsBoolean     := (stBodyFoot in FormDef.Header.fhSections);
  XML.Nodes.AddLeaf('stPageFoot').AsBoolean     := (stPageFoot in FormDef.Header.fhSections);
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddLeaf('fhOrientation').AsInteger  := Ord(FormDef.Header.fhOrientation);

  WriteFont(FormDef.Header.fhFont, 'fhFont');

  XML.Nodes.AddLeaf('fhHeaderSep').AsInteger    := FormDef.Header.fhHeaderSep;
  XML.Nodes.AddLeaf('fhBodyHeadSep').AsInteger  := FormDef.Header.fhBodyHeadSep;
  XML.Nodes.AddLeaf('fhBodySep').AsInteger      := FormDef.Header.fhBodySep;
  XML.Nodes.AddLeaf('fhBodyFootSep').AsInteger  := FormDef.Header.fhBodyFootSep;
  XML.Nodes.AddLeaf('fhContinue').AsString      := FormDef.Header.fhContinue;
  XML.Nodes.AddLeaf('fhSerialNo').AsInteger     := FormDef.Header.fhSerialNo;
  XML.Nodes.AddLeaf('fhSNoWidth').AsInteger     := FormDef.Header.fhSNoWidth;
  XML.Nodes.AddLeaf('fhPrinter').AsString       := FormDef.Header.fhPrinter;
  XML.Nodes.AddLeaf('fhBinNo').AsInteger        := FormDef.Header.fhBinNo;
  XML.Nodes.AddLeaf('fhPaperNo').AsInteger      := FormDef.Header.fhPaperNo;
  XML.Nodes.AddLeaf('fhLblTop').AsInteger       := FormDef.Header.fhLblTop;
  XML.Nodes.AddLeaf('fhLblLeft').AsInteger      := FormDef.Header.fhLblLeft;
  XML.Nodes.AddLeaf('fhLblWidth').AsInteger     := FormDef.Header.fhLblWidth;
  XML.Nodes.AddLeaf('fhLblHeight').AsInteger    := FormDef.Header.fhLblHeight;
  XML.Nodes.AddLeaf('fhLblCols').AsInteger      := FormDef.Header.fhLblCols;
  XML.Nodes.AddLeaf('fhLblRows').AsInteger      := FormDef.Header.fhLblRows;
  XML.Nodes.AddLeaf('fhLblColGap').AsInteger    := FormDef.Header.fhLblColGap;
  XML.Nodes.AddLeaf('fhLblRowGap').AsInteger    := FormDef.Header.fhLblRowGap;
  XML.Nodes.AddLeaf('fhPurpose').AsInteger      := FormDef.Header.fhPurpose;
  XML.Nodes.AddLeaf('fhInpSNo').AsBoolean       := FormDef.Header.fhInpSNo;
  XML.Nodes.AddLeaf('fhPrintAdjBom').AsInteger  := FormDef.Header.fhPrintAdjBom;
  XML.Nodes.AddLeaf('fhDocSortMode').AsInteger  := FormDef.Header.fhDocSortMode;
  XML.Nodes.AddLeaf('fhShowBins').AsBoolean     := FormDef.Header.fhShowBins;
  XML.Nodes.AddLeaf('fhShowUseBy').AsBoolean    := FormDef.Header.fhShowUseBy;
  XML.Nodes.AddLeaf('fhStockOrder').AsBoolean   := FormDef.Header.fhStockOrder;
  XML.Nodes.AddLeaf('fhShowAddDesc').AsBoolean  := FormDef.Header.fhShowAddDesc;
  XML.Nodes.AddLeaf('fhSuppressDL').AsBoolean   := FormDef.Header.fhSuppressDL;
  XML.Nodes.AddLeaf('fhShowDescOnly').AsBoolean := FormDef.Header.fhShowDescOnly;
  XML.Nodes.AddLeaf('fhInclNewLines').AsBoolean := FormDef.Header.fhInclNewLines;
  XML.Nodes.AddLeaf('fhExplodeBoMs').AsBoolean  := FormDef.Header.fhExplodeBoMs;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteLine(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('flXPos1').AsInteger    := FormDef.Line.flXPos1;
  XML.Nodes.AddLeaf('flYPos1').AsInteger    := FormDef.Line.flYPos1;
  XML.Nodes.AddLeaf('flXPos2').AsInteger    := FormDef.Line.flXPos2;
  XML.Nodes.AddLeaf('flYPos2').AsInteger    := FormDef.Line.flYPos2;
  XML.Nodes.AddLeaf('flPenWidth').AsInteger := FormDef.Line.flPenWidth;
  XML.Nodes.AddLeaf('flColor').AsInteger    := FormDef.Line.flColor;
  XML.Nodes.AddLeaf('flType').AsInteger     := Ord(FormDef.Line.flType);
  XML.Nodes.AddLeaf('flIf').AsString        := FormDef.Line.flIf.fiIf;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WritePage(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('fpXPos').AsInteger    := FormDef.PageNo.fpXPos;
  XML.Nodes.AddLeaf('fpYPos').AsInteger    := FormDef.PageNo.fpYPos;
  XML.Nodes.AddLeaf('fpWidth').AsInteger   := FormDef.PageNo.fpWidth;
  XML.Nodes.AddLeaf('fpHeight').AsInteger  := FormDef.PageNo.fpHeight;
  XML.Nodes.AddLeaf('fpLeading').AsString  := FormDef.PageNo.fpLeading;
  XML.Nodes.AddLeaf('fpTrailing').AsString := FormDef.PageNo.fpTrailing;

  WriteFont(FormDef.PageNo.fpFont, 'fpFont');

  XML.Nodes.AddLeaf('fpIf').AsString       := FormDef.PageNo.fpIf.fiIf;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteStrings(FormDef: FormDefRecType);
var
  i: Integer;
begin
  for i := Low(FormDef.FormStrings.fsSVStrs) to High(FormDef.FormStrings.fsSVStrs) do
    XML.Nodes.AddLeaf('fsSVStrs').AsString := FormDef.FormStrings.fsSVStrs[i];
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteTable(FormDef: FormDefRecType);
var
  i: Integer;
begin
  XML.Nodes.AddLeaf('frXPos').AsInteger   := FormDef.Table.frXPos;
  XML.Nodes.AddLeaf('frYPos').AsInteger   := FormDef.Table.frYPos;
  XML.Nodes.AddLeaf('frWidth').AsInteger  := FormDef.Table.frWidth;
  XML.Nodes.AddLeaf('frHeight').AsInteger := FormDef.Table.frHeight;

  WriteFont(FormDef.Table.frFonts[1], 'frFont');

  XML.Nodes.AddOpenTag('frFontSpare_Array');
  for i := Low(FormDef.Table.frFontSpare) to High(FormDef.Table.frFontSpare) do
    WriteFont(FormDef.Table.frFontSpare[i], 'frFontSpare');
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddOpenTag('frEnable_Array');
  for i := Low(FormDef.Table.frEnable) to High(FormDef.Table.frEnable) do
    XML.Nodes.AddLeaf('frEnable').AsBoolean := FormDef.Table.frEnable[i];
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddOpenTag('frEnableSpare_Array');
  for i := Low(FormDef.Table.frEnableSpare) to High(FormDef.Table.frEnableSpare) do
    XML.Nodes.AddLeaf('frEnableSpare').AsBoolean := FormDef.Table.frEnableSpare[i];
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddOpenTag('frPenWidth_Array');
  for i := Low(FormDef.Table.frPenWidth) to High(FormDef.Table.frPenWidth) do
    XML.Nodes.AddLeaf('frPenWidth').AsInteger := FormDef.Table.frPenWidth[i];
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddOpenTag('frPenWSpare_Array');
  for i := Low(FormDef.Table.frPenWSpare) to High(FormDef.Table.frPenWSpare) do
    XML.Nodes.AddLeaf('frPenWSpare').AsInteger := FormDef.Table.frPenWSpare[i];
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddOpenTag('frColour_Array');
  for i := Low(FormDef.Table.frColour) to High(FormDef.Table.frColour) do
    XML.Nodes.AddLeaf('frColour').AsInteger := FormDef.Table.frColour[i];
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddOpenTag('frColourSpare_Array');
  for i := Low(FormDef.Table.frColourSpare) to High(FormDef.Table.frColourSpare) do
    XML.Nodes.AddLeaf('frColourSpare').AsInteger := FormDef.Table.frColourSpare[i];
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddOpenTag('frSizes_Array');
  for i := Low(FormDef.Table.frSizes) to High(FormDef.Table.frSizes) do
    XML.Nodes.AddLeaf('frSizes').AsInteger := FormDef.Table.frSizes[i];
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddOpenTag('frSizeSpare_Array');
  for i := Low(FormDef.Table.frSizeSpare) to High(FormDef.Table.frSizeSpare) do
    XML.Nodes.AddLeaf('frSizeSpare').AsInteger := FormDef.Table.frSizeSpare[i];
  XML.Nodes.AddCloseTag;

  XML.Nodes.AddLeaf('frIf').AsString := FormDef.Table.frIf.fiIf;
end;

// -----------------------------------------------------------------------------

procedure TXMLFile.WriteText(FormDef: FormDefRecType);
begin
  XML.Nodes.AddLeaf('ftXPos').AsInteger       := FormDef.Text.ftXPos;
  XML.Nodes.AddLeaf('ftYPos').AsInteger       := FormDef.Text.ftYPos;
  XML.Nodes.AddLeaf('ftWidth').AsInteger      := FormDef.Text.ftWidth;
  XML.Nodes.AddLeaf('ftHeight').AsInteger     := FormDef.Text.ftHeight;
  XML.Nodes.AddLeaf('ftText').AsString        := FormDef.Text.ftText;

  WriteFont(FormDef.Text.ftFont, 'ftFont');

  XML.Nodes.AddLeaf('ftJustify').AsInteger    := Ord(FormDef.Text.ftJustify);
  XML.Nodes.AddLeaf('ftIf').AsString          := FormDef.Text.ftIf.fiIf;
  XML.Nodes.AddLeaf('ftSymbolFont').AsBoolean := FormDef.Text.ftSymbolFont;
end;

// -----------------------------------------------------------------------------

end.
