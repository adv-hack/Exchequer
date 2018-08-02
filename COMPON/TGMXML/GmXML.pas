{******************************************************************************}
{                                                                              }
{                                GmXml.pas                                     }
{                                                                              }
{           Copyright (c) 2003 Graham Murt  - www.murtsoft.co.uk               }
{                                                                              }
{   Feel free to e-mail me with any comments, suggestions, bugs or help at:    }
{                                                                              }
{                           graham@murtsoft.co.uk                              }
{                                                                              }
{******************************************************************************}

unit GmXml;
{$H+}
interface

uses Classes, SysUtils, Dialogs;

const
  COMP_VERSION = 0.13;
  XML_SPECIFICATION = '<?xml version="1.0"%s?>';

type
  TGmXmlNode = class;
  TGmXmlNodeList = class;
  TGmXmlAttributes = class;

  TGmXmlEnumNodeEvent = procedure(Sender: TObject; ANode: TGmXmlNode) of object;

  // *** TGmXmlNodeElement ***

  //PR: ABSPLUG-2620 v2017 R2 Changed all 'string' declarations to 'AnsiString' to
  //                          allow compilation in D10.

  TGmXmlAttribute = class
  private
    FName: AnsiString;
    FValue: AnsiString;
    constructor Create;
    procedure SetName(AValue: AnsiString);
    procedure SetValue(AValue: AnsiString);
    procedure SetUntrimmedValue(AValue: AnsiString);
    function GetAsDisplayString: AnsiString;
  public
    property Name: AnsiString read FName write SetName;
    property Value: AnsiString read FValue write SetValue;
    property UntrimmedValue: AnsiString write SetUntrimmedValue;
    property AsDisplayString: AnsiString read GetAsDisplayString;
  end;

  // *** TGmXmlNode ***

  TGmXmlNode = class(TPersistent)
  private
    FChildren: TGmXmlNodeList;
    FElements: TGmXmlAttributes;
    FName: AnsiString;
    FParent: TGmXmlNode;
    FValue: AnsiString;
    // events...
    function GetAsString: AnsiString;
    function GetIsLeafNode: Boolean;
    function GetAsBoolean: Boolean;
    function GetAsFloat: Extended;
    function GetAsInteger: integer;
    function GetAsDisplayString: AnsiString;
    function GetLevel: integer;
    function CloseTag: AnsiString;
    function OpenTag: AnsiString;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsFloat(const Value: Extended);
    procedure SetAsInteger(const Value: integer);
    procedure SetAsString(const Value: AnsiString);
    procedure SetAsNonConvertedString(const Value: AnsiString); //NF: Added 23/11/2005
    procedure SetName(Value: AnsiString); virtual;
  public
    constructor Create(AParentNode: TGmXmlNode); virtual;
    destructor Destroy; override;
    procedure EnumerateNodes(ACallback: TGmXmlEnumNodeEvent);
    property AsString: AnsiString read GetAsString write SetAsString;
    property AsDisplayString: AnsiString read GetAsDisplayString;
    property AsNonConvertedString: AnsiString write SetAsNonConvertedString; //NF: Added 23/11/2005
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    property AsInteger: integer read GetAsInteger write SetAsInteger;
    property Attributes: TGmXmlAttributes read FElements write FElements;
    property Children: TGmXmlNodeList read FChildren;
    property IsLeafNode: Boolean read GetIsLeafNode;
    property Level: integer read GetLevel;
    property Name: AnsiString read FName write SetName;
    property Parent: TGmXmlNode read FParent;
  end;

  // *** TGmXmlNodeList ***

  TGmXmlNodeList = class
  private
    FCurrentNode: TGmXmlNode;
    FList: TList;
    function GetCount: integer;
    function GetNode(index: integer): TGmXmlNode;
    function GetNodeByName(AName: AnsiString): TGmXmlNode;
    procedure SetNodeByName(AName: AnsiString; ANode: TGmXmlNode);
    function GetRoot: TGmXmlNode;
    procedure AddNode(ANode: TGmXmlNode);
    procedure SetNode(index: integer; const Value: TGmXmlNode);
  public
    constructor Create(AParent: TGmXmlNode);
    destructor Destroy; override;
    function AddLeaf(AName: AnsiString): TGmXmlNode;
    function AddOpenTag(AName: AnsiString): TGmXmlNode;
    procedure AddCloseTag;
    //procedure NextNode;
    procedure Clear;
    property Count: integer read GetCount;
    property CurrentNode: TGmXmlNode read FCurrentNode write FCurrentNode;
    property Node[index: integer]: TGmXmlNode read GetNode write SetNode; default;
    property NodeByName[AName: AnsiString]: TGmXmlNode read GetNodeByName write SetNodeByName;
    property Root: TGmXmlNode read GetRoot;
  end;

  TGmXmlAttributes = class
  private
    FCurrentElement: TGmXmlAttribute;
    FList: TList;
    function GetCount: integer;
    function GetElement(index: integer): TGmXmlAttribute;
    function GetElementByName(AName: AnsiString): TGmXmlAttribute;
    procedure SetElementByName(AName: AnsiString; AElement: TGmXmlAttribute);
    function GetRoot: TGmXmlAttribute;
    procedure AddElement(AElement: TGmXmlAttribute);
    procedure SetElement(index: integer; const Value: TGmXmlAttribute);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    // MH 09/01/06: Added method to create new attributes
    procedure AddAttribute (const aName, aValue : AnsiString);

    property Count: integer read GetCount;
    property CurrentElement: TGmXmlAttribute read FCurrentElement write FCurrentElement;
    property Element[index: integer]: TGmXmlAttribute read GetElement write SetElement; default;
    property ElementByName[AName: AnsiString]: TGmXmlAttribute read GetElementByName write SetElementByName;
    property Root: TGmXmlAttribute read GetRoot;
  end;

  // *** TGmXML ***

  TGmXML = class(TComponent)
  private
    FAutoIndent: Boolean;
    FEncoding: AnsiString;
    FIncludeHeader: Boolean;
    FNodes: TGmXmlNodeList;
    FStrings: TSTringList;
    FXML_Stylesheet : AnsiString;
    function GetAbout: AnsiString;
    function GetDisplayText: AnsiString;
    function GetEncodingStr: AnsiString;
    function GetIndent(ALevel: integer): AnsiString;
    function GetText(ReplaceEscapeChars: Boolean): AnsiString;
    function GetXmlText: AnsiString;
    procedure SetAsText(Value: AnsiString);
    procedure SetAbout(Value: AnsiString);
    procedure SetAutoIndent(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromFile(AFileName: AnsiString; AppendNodes: Boolean = True);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(AFilename: AnsiString);
    procedure SaveToStream(Stream: TStream);
    property DisplayText: AnsiString read GetDisplayText;
    property Nodes: TGmXmlNodeList read FNodes;
    property Text: AnsiString read GetXmlText write SetAsText;
  published
    property About: AnsiString read GetAbout write SetAbout;
    property AutoIndent: Boolean read FAutoIndent write SetAutoIndent default True;
    property Encoding: AnsiString read FEncoding write FEncoding;
    property IncludeHeader: Boolean read FIncludeHeader write FIncludeHeader default True;
  end;

var
  // Global variable. Set this to True to allow attribute values to contain
  // spaces (gmXML contains a bug that will normally remove spaces from these
  // values -- this variable allows the previous behaviour to be preserved, in
  // case it is being relied upon).
  gmXMLAllowAttributeSpaces: Boolean = False;
  gmXMLDoTrimOnTagNames: Boolean = TRUE; // NF: 07/05/2009 - Fix for BGA, but should be applied globally
  gmXMLSupportComments: Boolean = False; // MH: 19/07/2010 - Added ability to process (and ignore) comments

procedure Register;

implementation

//------------------------------------------------------------------------------

// *** Unit Functions ***

function StrPos(const SubStr, S: AnsiString; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;

procedure ReplaceText(var AText: AnsiString; AFind, AReplace: AnsiString);
var
  Index: integer;
begin
  Index := 1;
  while StrPos(AFind, AText, Index) <> 0 do
  begin
    Index := StrPos(AFind, AText, Index);
    Delete(AText, Index, Length(AFind));
    Insert(AReplace, AText, Index);
    Inc(Index, Length(AReplace));
  end;
end;

//------------------------------------------------------------------------------

// MH 06/06/2016 2016-R2 ABSEXCH-17336: Added AsDisplayString property to Attribute
Function ExpandEscapedCharacters (Const OrigString : ANSIString) : ANSIString;
Begin // ExpandEscapedCharacters
  Result := OrigString;

{ Devious code follows! The GetAsEncodedString method above uses ReplaceText to
  replace all '&' occurrences with '&amp;' so that valid XML can be written to
  the file.

  However, suppose the incoming Value already contains '&amp;', or one of the
  other entities (this happens when loading an XML file): the '&' will be
  replaced with '&amp;', resulting in, for example, '&amp;gt;'.

  The GetAsDisplay AnsiString method will fix this problem for most of the
  entities -- it will convert '&amp;gt;' back to '&gt;', and then can correctly
  convert '&gt;' to '>'.

  However, this does not work for the '&amp;' entity. This gets converted into
  '&amp;amp;', which is converted to '&amp;', and is then not converted any
  further. To fix this, the ReplaceText function is called *twice*. The first
  call will convert any '&amp;amp;' occurrences (as created by GetAsEncodedString) to
  '&amp;', and the second call will then convert these into '&'. }

  ReplaceText(Result, '&amp;', '&');
  ReplaceText(Result, '&amp;', '&');

  ReplaceText(Result, '&lt;', '<');
  ReplaceText(Result, '&gt;', '>');
//  ReplaceText(Result, '&pos;', '''');
  ReplaceText(Result, '&apos;', ''''); // PR: 17/08/2007 - Changed, as it is wrong
  ReplaceText(Result, '&quot;', '"');
End; // ExpandEscapedCharacters


//-------------------------------------------------------------------------


// *** TGmXmlNodeElement ***

constructor TGmXmlAttribute.Create;
begin
  inherited;
  Name := '';
  Value := '';
end;

procedure TGmXmlAttribute.SetName(AValue: AnsiString);
begin
  FName := Trim(AValue);
end;

procedure TGmXmlAttribute.SetUntrimmedValue(AValue: AnsiString);
begin
  FValue := AValue;
  ReplaceText(FValue, '"', '');
end;

procedure TGmXmlAttribute.SetValue(AValue: AnsiString);
begin
  FValue := Trim(AValue);
  ReplaceText(FValue, '"', '');
end;

function TGmXmlAttribute.GetAsDisplayString: AnsiString;
Begin // GetAsDisplayString
  // MH 06/06/2016 2016-R2 ABSEXCH-17336: Added AsDisplayString property to Attribute
  Result := ExpandEscapedCharacters (FValue);
End; // GetAsDisplayString

//------------------------------------------------------------------------------

// *** TGmXmlNode ***

constructor TGmXmlNode.Create(AParentNode: TGmXmlNode);
begin
  inherited Create;
  FChildren := TGmXmlNodeList.Create(Self);
  FElements := TGmXmlAttributes.Create;
  FParent := AParentNode;
//  FElement.Name := '';
//  FElement.Value := '';
end;

destructor TGmXmlNode.Destroy;
begin
  FElements.Free;
  FChildren.Free;
  inherited Destroy;
end;

function TGmXmlNode.CloseTag: AnsiString;
begin
  Result := '</'+FName+'>';
end;

function TGmXmlNode.OpenTag: AnsiString;
var
  iPos : integer;
begin
  if FElements.Count = 0 then
  begin
    Result := Format('<%s>',[Name])
  end else
  begin
    Result := Format('<%s',[Name]);
    For iPos := 0 to FElements.Count -1 do
    begin
      Result := Result + Format(' %s="%s"',[FElements[iPos].Name, FElements[iPos].Value]);
    end;{for}
    Result := Result + '>';
  end;{if}
end;

procedure TGmXmlNode.EnumerateNodes(ACallback: TGmXmlEnumNodeEvent);
var
  ICount: integer;
begin
  for ICount := 0 to FChildren.Count-1 do
  begin
    if Assigned(ACallback) then ACallback(Self, FChildren[ICount]);
  end;
end;

function TGmXmlNode.GetAsBoolean: Boolean;
begin
  Result := Boolean(StrToInt(FValue));
end;

function TGmXmlNode.GetAsFloat: Extended;
begin
  Result := StrToFloat(FValue);
end;

function TGmXmlNode.GetAsInteger: integer;
begin
  Result := StrToInt(FValue);
end;

function TGmXmlNode.GetAsDisplayString: AnsiString;
begin
  // MH 06/06/2016 2016-R2 ABSEXCH-17336: Added AsDisplayString property to Attribute
  Result := ExpandEscapedCharacters (FValue);
end;

function TGmXmlNode.GetLevel: integer;
var
  AParent: TGmXmlNode;
begin
  AParent := Parent;
  Result := 0;
  while AParent <> nil do
  begin
    AParent := AParent.Parent;
    Inc(Result);
  end;
end;

procedure TGmXmlNode.SetAsBoolean(const Value: Boolean);
begin
  FValue := IntToStr(Ord(Value));
end;

procedure TGmXmlNode.SetAsFloat(const Value: Extended);
begin
  FValue := FloatToStr(Value);
end;

procedure TGmXmlNode.SetAsInteger(const Value: integer);
begin
  FValue := IntToStr(Value);
end;

procedure TGmXmlNode.SetAsString(const Value: AnsiString);
begin
  FValue := Value;

  // replace any illegal characters...
  ReplaceText(FValue, #0, '');
  ReplaceText(FValue, '&', '&amp;');
  ReplaceText(FValue, '<', '&lt;');
  ReplaceText(FValue, '>', '&gt;');
//  ReplaceText(FValue, '''', '&pos;');
  ReplaceText(FValue, '''', '&apos;'); // PR: 17/08/2007 - Changed, as it is wrong
  ReplaceText(FValue, '"', '&quot;');
end;

function TGmXmlNode.GetAsString: AnsiString;
begin
  Result := FValue;
end;

function TGmXmlNode.GetIsLeafNode: Boolean;
begin
  Result := FChildren.Count = 0;
end;

procedure TGmXmlNode.SetName(Value: AnsiString);
var
  sElements{, sElementName, sElementValue} : AnsiString;
  NewElement : TGmXmlAttribute;
  iQuoteMode, iMode, iChar : integer;

const
  MODE_ELEMENT = 0;
  MODE_VALUE = 1;

  QM_OUTSIDE = 0;
  QM_INSIDE = 1;

begin
  FName := Value;
  if FName[1] = '<' then Delete(FName, 1, 1);
  if FName[Length(FName)] = '>' then Delete(FName, Length(FName), 1);
  Trim(FName);  // NF: 07/05/2009 - Note: Useless line of code !
  if gmXMLDoTrimOnTagNames then FName := Trim(FName); // NF: 07/05/2009 - Fix for BGA, but should be applied globally

  // extract elements if they exist...
  if Pos('=', FName) <> 0 then
  begin
    NewElement := TGmXmlAttribute.Create;
    sElements := Copy(FName, Pos(' ', FName) + 1, Length(FName));
    iMode := MODE_ELEMENT;
    iQuoteMode := QM_OUTSIDE;

    For iChar := 1 to length(sElements) do
    begin
      if sElements[iChar] = '=' then
      begin
        iMode := MODE_VALUE;
      end else
      begin
        if sElements[iChar] = '"' then
        begin
          if iQuoteMode = QM_OUTSIDE then iQuoteMode := QM_INSIDE
          else begin
            iQuoteMode := QM_OUTSIDE;
            FElements.AddElement(NewElement);
            if iChar <> length(sElements)
            then begin
              NewElement := TGmXmlAttribute.Create;
              iMode := MODE_ELEMENT;
            end;{if}
          end;{if}
        end else
        begin
          if iMode = MODE_ELEMENT then NewElement.Name := NewElement.Name + sElements[iChar]
          else
          begin
            if gmXMLAllowAttributeSpaces then
              NewElement.UntrimmedValue := NewElement.Value + sElements[iChar]
            else
              NewElement.Value := NewElement.Value + sElements[iChar];
          end;
        end;{if}
      end;{if}
    end;{for}

    FName := Copy(FName, 1, Pos(' ', FName)-1);

{    sElementName := Copy(sElements, 1, Pos('=', sElements) -1);
    sElements := Copy(sElements, Pos('=', sElements) + 1, 255);
    if Pos('=', sElements) = 0 then sElementValue := sElements
    else
    sElementValue := Copy(sElements, Pos('=' + 1 , sElementName) -1);
    AElement := Copy(FName, Pos(' ', FName), Length(FName));
    FName := Copy(FName, 1, Pos(' ', FName)-1);
    FElement.Name := Copy(AElement, 0, Pos('=', AElement)-1);
    AElement := Copy(AElement, Pos('"', AElement), Length(AElement));
    ReplaceText(AElement, '"', '');
    FElement.Value := AElement;}
  end;
end;

//------------------------------------------------------------------------------

// *** TGmXmlNodeList ***

constructor TGmXmlNodeList.Create(AParent: TGmXmlNode);
begin
  inherited Create;
  FList := TList.Create;
  FCurrentNode := AParent;
end;

destructor TGmXmlNodeList.Destroy;
var
  ICount: integer;
begin
  for ICount := Count-1 downto 0 do
    Node[ICount].Free;
  FList.Free;
  inherited Destroy;
end;

function TGmXmlNodeList.AddLeaf(AName: AnsiString): TGmXmlNode;
begin
  Result := AddOpenTag(AName);
  AddCloseTag;
end;

function TGmXmlNodeList.AddOpenTag(AName: AnsiString): TGmXmlNode;
begin
  Result := TGmXmlNode.Create(FCurrentNode);
  Result.Name := AName;
  if FCurrentNode = nil then
    AddNode(Result)
  else
    FCurrentNode.Children.AddNode(Result);

  FCurrentNode := Result;
end;

procedure TGmXmlNodeList.AddCloseTag;
begin
  FCurrentNode := FCurrentNode.Parent;
end;

{procedure TGmXmlNodeList.NextNode;
var
  AIndex: integer;
begin
  AIndex := FList.IndexOf(FCurrentNode);
  if AIndex < FList.Count then
  FCurrentNode := TGmXmlNode(FList[AIndex]);
end;}

procedure TGmXmlNodeList.Clear;
var
  ICount: integer;
begin
  for ICount := 0 to FList.Count-1 do
  begin
    Node[ICount].Free;
    Node[ICount] := nil;
  end;
  FList.Clear;
  FCurrentNode := nil;
end;

function TGmXmlNodeList.GetCount: integer;
begin
  Result := FList.Count;
end;

function TGmXmlNodeList.GetNode(index: integer): TGmXmlNode;
begin
  Result := TGmXmlNode(FList[index]);
end;

function TGmXmlNodeList.GetNodeByName(AName: AnsiString): TGmXmlNode;
var
  ICount: integer;
begin
  Result := nil;
  for ICount := 0 to Count-1 do
  begin
    if Node[ICount].Name = AName then
    begin
      Result := Node[ICount];
      Exit;
    end else
    begin
      Result := Node[ICount].Children.GetNodeByName(AName);
      if Result <> nil then exit;
    end;{if}
  end;{for}
end;

procedure TGmXmlNodeList.SetNodeByName(AName: AnsiString; ANode: TGmXmlNode);
var
  ICount: integer;
begin
  for ICount := 0 to Count-1 do
  begin
    if Node[ICount].Name = AName then
    begin
      Node[ICount] := ANode;
      Exit;
    end;
  end;
end;

function TGmXmlNodeList.GetRoot: TGmXmlNode;
begin
  Result := nil;
  if Count > 0 then Result := Node[0];
end;

procedure TGmXmlNodeList.AddNode(ANode: TGmXmlNode);
begin
  FList.Add(ANode);
end;

procedure TGmXmlNodeList.SetNode(index: integer; const Value: TGmXmlNode);
begin
  FList[index] := Value;
end;

//------------------------------------------------------------------------------

// *** TGmXmlAttributes ***

constructor TGmXmlAttributes.Create;
begin
  inherited Create;
  FList := TList.Create;
//  FCurrentNode := AParent;
end;

destructor TGmXmlAttributes.Destroy;
var
  ICount: integer;
begin
  for ICount := Count-1 downto 0 do
    Element[ICount].Free;
  FList.Free;
  inherited Destroy;
end;

procedure TGmXmlAttributes.Clear;
var
  ICount: integer;
begin
  for ICount := 0 to FList.Count-1 do
  begin
    Element[ICount].Free;
    Element[ICount] := nil;
  end;
  FList.Clear;
  FCurrentElement := nil;
end;

function TGmXmlAttributes.GetCount: integer;
begin
  Result := FList.Count;
end;

function TGmXmlAttributes.GetElement(index: integer): TGmXmlAttribute;
begin
  Result := TGmXmlAttribute(FList[index]);
end;

function TGmXmlAttributes.GetElementByName(AName: AnsiString): TGmXmlAttribute;
var
  ICount: integer;
begin
  Result := nil;
  for ICount := 0 to Count-1 do
  begin
    if Element[ICount].Name = AName then
    begin
      Result := element[ICount];
      Exit;
    end;
  end;
end;

procedure TGmXmlAttributes.SetElementByName(AName: AnsiString; AElement: TGmXmlAttribute);
var
  ICount: integer;
begin
  for ICount := 0 to Count-1 do
  begin
    if Element[ICount].Name = AName then
    begin
      Element[ICount] := AElement;
      Exit;
    end;
  end;
end;

function TGmXmlAttributes.GetRoot: TGmXmlAttribute;
begin
  Result := nil;
  if Count > 0 then Result := Element[0];
end;

procedure TGmXmlAttributes.AddElement(AElement: TGmXmlAttribute);
begin
  FList.Add(AElement);
end;

procedure TGmXmlAttributes.SetElement(index: integer; const Value: TGmXmlAttribute);
begin
  FList[index] := Value;
end;

procedure TGmXmlAttributes.AddAttribute (const aName, aValue : AnsiString);
Var
  oAttr : TGmXmlAttribute;
Begin // AddAttribute
  oAttr := TGmXmlAttribute.Create;
  oAttr.Name := aName;
  oAttr.Value := aValue;
  AddElement(oAttr);
End; // AddAttribute

//------------------------------------------------------------------------------

// *** TGmXml ***

constructor TGmXml.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FXML_Stylesheet := '';
  FStrings := TStringList.Create;
  FNodes := TGmXmlNodeList.Create(nil);
  FIncludeHeader := True;
  FAutoIndent := True;
  FEncoding := '';
end;

destructor TGmXml.Destroy;
begin
  FNodes.Free;
  FStrings.Free;
  inherited Destroy;
end;

function TGmXml.GetAbout: AnsiString;
begin
  Result := Format('%s v%f', [ClassName, COMP_VERSION]);
end;

function TGmXml.GetDisplayText: AnsiString;
begin
  Result := GetText(True);
end;

function TGmXml.GetEncodingStr: AnsiString;
begin
  Result := '';
  if FEncoding <> '' then Result := Format(' encoding="%s"', [FEncoding]);
end;

function TGmXml.GetIndent(ALevel: integer): AnsiString;
begin
  Result := '';
  if FAutoIndent then Result := StringOfChar(' ', ALevel*2);

end;

function TGmXml.GetText(ReplaceEscapeChars: Boolean): AnsiString;

  procedure NodeToStringList(var AXml: TStringList; ANode: TGmXmlNode; AReplaceChars: Boolean);
  var
    ICount: integer;
    AValue: AnsiString;
  begin
    if ANode.IsLeafNode then
    begin
      if AReplaceChars then AValue := ANode.AsDisplayString else AValue := ANode.AsString;
      AXml.Add(GetIndent(ANode.Level) + ANode.OpenTag + AValue + ANode.CloseTag);
    end
    else
    begin
      AXml.Add(GetIndent(ANode.Level)+ANode.OpenTag);
      for ICount := 0 to ANode.FChildren.Count-1 do
        NodeToStringList(AXml, ANode.Children.Node[ICount], AReplaceChars);
      AXml.Add(GetIndent(ANode.Level)+ANode.CloseTag);
    end;
  end;

var
  ICount: integer;
begin
  FStrings.Clear;
  if FNodes.Count = 0 then Exit;

  if FIncludeHeader then
  begin
    FStrings.Add(Format(XML_SPECIFICATION, [GetEncodingStr]));
    if FXML_Stylesheet <> '' then FStrings.Add(FXML_Stylesheet);
  end;

  for ICount := 0 to FNodes.Count-1 do
    NodeToStringList(FStrings, FNodes.Node[ICount], ReplaceEscapeChars);
  Result := FStrings.Text;
end;

function TGmXml.GetXmlText: AnsiString;
begin
  Result := GetText(False);
end;

procedure TGmXml.SetAsText(Value: AnsiString);
var
  ACursor: integer;
  AText: AnsiString;
  ATag: AnsiString;
  AValue: AnsiString;
  ATags: AnsiString;
begin
  AText := Value;
  ACursor := 1;
  ATags := '';

// MH 06/01/06: Modified to stop it going past the end of the AnsiString
//  while ACursor <> Length(Value) do
  while ACursor < Length(Value) do
  begin
    AValue := '';
    if Value[ACursor] = '<' then
    begin
      // reading a tag
      ATag := '<';
      while Value[ACursor] <> '>' do
      begin
        Inc(ACursor);
        ATag := ATag + Value[ACursor];
      end;

      If gmXMLSupportComments And (Pos('<!--', ATag) = 1) Then
      Begin
        // Ignore comments
      End // If gmXMLSupportComments And (Pos('<!--', ATag) = 1)
      Else
      Begin
        // NF: Modified to handle blank tags e.g. <Blank/>
        // It always saves it as <Blank></Blank> (rather than <Blank/>) but at least it works now !
        if ATag[2] = '/' then
        begin
          Nodes.AddCloseTag;
        end else
        begin
          if ATag[2] = '?' then
          begin
            if Copy(ATag,2,15) = '?xml-stylesheet' then
            begin
              FXML_Stylesheet := ATag;
            end;
          end else
          begin
            if (ATag[Length(ATag) - 1] = '/')  and (ATag[Length(ATag)] = '>') then
            begin
              Nodes.AddOpenTag(StringReplace(ATag, '/','',[rfReplaceAll]));
              Nodes.AddCloseTag;
            end else
            begin
              Nodes.AddOpenTag(ATag);
            end;
          end;
        end;{if}
      End; // Else
    end
    else
    begin
      // reading a value...
      while (Value[ACursor]  <> '<') and (ACursor < Length(Value)) do
      begin
        AValue := AValue + Value[ACursor];
        Inc(ACursor);
      end;
      if Assigned(Nodes.CurrentNode) then
        // NF: This was changed so that it did not convert strings when reading the xml - i.e. it was changing &quot; to &amp;quot;
//        Nodes.CurrentNode.AsString := AValue;
        Nodes.CurrentNode.AsNonConvertedString := AValue;

      Dec(ACursor);
    end;
    Inc(ACursor);
  end;
end;

procedure TGmXml.SetAbout(Value: AnsiString);
begin
  // does nothing... (only needed to display property in Object Inspector)
end;

procedure TGmXML.SetAutoIndent(const Value: Boolean);
begin
  FAutoIndent := Value;
end;

procedure TGmXml.LoadFromFile(AFileName: AnsiString; AppendNodes: Boolean = True);
var
  AStream: TMemoryStream;
begin
  if not AppendNodes then
    self.Nodes.Clear;
  AStream := TMemoryStream.Create;
  try
    AStream.LoadFromFile(AFileName);
    AStream.Seek(0, soFromBeginning);
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TGmXml.LoadFromStream(Stream: TStream);
var
  ALines: TStringList;
begin
  if Stream.Size = 0 then Exit;
  ALines := TStringList.Create;
  try
    ALines.LoadFromStream(Stream);
    Text := ALines.Text;
  finally
    ALines.Free;
  end;
end;

procedure TGmXml.SaveToFile(AFilename: AnsiString);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    SaveToStream(AStream);
    AStream.SaveToFile(AFilename);
  finally
    AStream.Free;
  end;
end;

procedure TGmXml.SaveToStream(Stream: TStream);
begin
  GetText(False);
  FStrings.SaveToStream(Stream);
end;

procedure Register;
begin
  RegisterComponents('GmXML', [TGmXml]);
end;

procedure TGmXmlNode.SetAsNonConvertedString(const Value: AnsiString);
begin
  FValue := Value;
end;

end.
