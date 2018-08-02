unit XmlOutpt;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

// The Delphi Magazine Issue 48, August 1999
// Code from XML : A Delphi Implementation
// By David Baer
// Pages 8 - 19

interface

uses Classes, SysUtils;

type
  TXmlNodeType = (xntDocument, xntElement, xntText,
      xntComment, xntCDATASection);

const
  XmlNodeNames: array[xntDocument..xntCDATASection] of String =
      ('#document', '', '#text', '#comment', '#cdata-section');

type
  EXmlDError = class(Exception);

  TXmlName = String;

  TXmlDDocument = class;
  TXmlDStructureNode = class;
  TXmlDElement = class;
  TXmlDCDATASection = class;
  TXmlDComment = class;
  TXmlDText = class;
  TXmlDAttrList = class;

  TXmlDNode = class(TPersistent)
    private
      FPreviousSibling: TXmlDNode;
      FNextSibling:     TXmlDNode;
      FParentNode:      TXmlDStructureNode;
      FNodeType:        TXmlNodeType;
    protected
      function GetFirstChild: TXmlDNode; virtual;
      function GetLastChild: TXmlDNode; virtual;
      function GetOwnerDocument: TXmlDDocument;
      function GetNodeName: TXmlName; virtual;
      function GetNodeValue: String; virtual;
      procedure SetNodeName(const Value: TXmlName); virtual;
      procedure SetNodeValue(const Value: String); virtual;
      function GetLevel: Integer;
      procedure WriteToStream(Stream: TStream;
          FormattedForPrint: Boolean); virtual; abstract;
      procedure WriteFormattedPrefix(Stream: TStream);
      procedure WriteFormattedSuffix(Stream: TStream);
    public
      constructor Create;
      function CloneNode(RecurseChildren: Boolean = False): TXmlDNode;
          virtual; abstract;
      procedure AppendChild(NewNode: TXmlDNode); virtual;
      function ReplaceChild(NewNode: TXmlDNode; OldNode: TXmlDNode):
          TXmlDNode; virtual;
      procedure InsertBefore(NewNode: TXmlDNode; ThisNode: TXmlDNode);
      function RemoveChild(ThisNode: TXmlDNode): TXmlDNode; virtual;
      function HasChildNodes: Boolean; virtual;
      property FirstChild: TXmlDNode read GetFirstChild;
      property LastChild: TXmlDNode read GetLastChild;
      property PreviousSibling: TXmlDNode read FPreviousSibling;
      property NextSibling: TXmlDNode read FNextSibling;
      property ParentNode: TXmlDStructureNode read FParentNode;
      property OwnerDocument: TXmlDDocument read GetOwnerDocument;
      property NodeName: TXmlName read GetNodeName write SetNodeName;
      property NodeType: TXmlNodeType read FNodeType;
      property NodeValue: String read GetNodeValue write SetNodeValue;
      property Level: Integer read GetLevel;
  end;

  TXmlDStructureNode = class(TXmlDNode)
    private
      FFirstChild:      TXmlDNode;
      FLastChild:       TXmlDNode;
    protected
      procedure CloneChildren(FromNode: TXmlDStructureNode);
      procedure WriteChildrenToStream(Stream: TStream;
          FormattedForPrint:Boolean);
    public
      destructor Destroy; override;
      function GetFirstChild: TXmlDNode; override;
      function GetLastChild: TXmlDNode; override;
      procedure AppendChild(NewNode: TXmlDNode); override;
      function ReplaceChild(NewNode: TXmlDNode; OldNode: TXmlDNode):
          TXmlDNode; override;
      function RemoveChild(ThisNode: TXmlDNode): TXmlDNode; override;
      function HasChildNodes: Boolean; override;
    end;

  TXmlDContentNode = class(TXmlDNode)
    private
      FValue: String;
    protected
      function GetNodeValue: String; override;
      procedure SetNodeValue(const Value: String); override;
  end;

  TXmlDDocument = class(TXmlDStructureNode)
    private
      FDocumentElement: TXmlDElement;
      FDocumentTypeDefinition: String;
    protected
      procedure WriteToStream(Stream: TStream; FormattedForPrint: Boolean); override;
    public
      constructor Create;
      function CloneNode(RecurseChildren: Boolean): TXmlDNode;
          override;
      procedure Clear;
      procedure AppendChild(NewNode: TXmlDNode); override;
      function ReplaceChild(NewNode: TXmlDNode; OldNode: TXmlDNode):
          TXmlDNode; override;
      procedure InsertBefore(NewNode: TXmlDNode; ThisNode: TXmlDNode);
      function RemoveChild(ThisNode: TXmlDNode): TXmlDNode; override;
      function CreateCDATASection(const Text: String): TXmlDCDATASection;
      function CreateComment(const Text: String): TXmlDComment;
      function CreateElement(const TagName: TXmlName): TXmlDElement;
          overload;
      function CreateElement(const TagName: TXmlName;
          const Data: String): TXmlDElement; overload;
      function CreateElement(const TagName: TXmlName;
          const Data: String; const AttrName: TXmlName;
          const AttrValue: String): TXmlDElement; overload;
      function CreateElement(const TagName: TXmlName;
          const Data: String; const AttrNames: array of TXmlName;
          const AttrValues: array of String): TXmlDElement; overload;
      function CreateElement(const TagName: TXmlName;
          const AttrNames: array of TXmlName;
          const AttrValues: array of String): TXmlDElement; overload;
      function CreateTextNode(const Text: String): TXmlDText;
      function CreateProcessingInst(const Text : String) : TXmlDText;

      procedure SaveToStream(Stream: TStream;
          FormattedForPrint: Boolean = False);
      procedure SaveToFile(const FileName: String;
          FormattedForPrint: Boolean = False);
      property DocumentElement: TXmlDElement read FDocumentElement;
      property DocumentTypeDefinition: String
          read FDocumentTypeDefinition write FDocumentTypeDefinition;
  end;

  TXmlDElement = class(TXmlDStructureNode)
    private
      FNodeName:        TXmlName;
      FAttrList:        TXmlDAttrList;
    protected
      function GetNodeName: TXmlName; override;
      procedure SetNodeName(const Value: TXmlName); override;
      procedure WriteToStream(Stream: TStream;
          FormattedForPrint: Boolean); override;
    public
      constructor Create;
      destructor Destroy; override;
      function CloneNode(RecurseChildren: Boolean): TXmlDNode;
          override;
      property AttrList: TXmlDAttrList read FAttrList;
  end;

  TXmlDText = class(TXmlDContentNode)
  protected
    procedure WriteToStream(Stream: TStream;
        FormattedForPrint: Boolean); override;
  public
    constructor Create;
    function CloneNode(RecurseChildren: Boolean): TXmlDNode; override;
  end;

  TXmlDComment = class(TXmlDContentNode)
  protected
    procedure WriteToStream(Stream: TStream;
        FormattedForPrint: Boolean); override;
  public
    constructor Create;
    function CloneNode(RecurseChildren: Boolean): TXmlDNode; override;
  end;

  TXmlDCDATASection = class(TXmlDContentNode)
  protected
    procedure WriteToStream(Stream: TStream;
        FormattedForPrint: Boolean); override;
  public
    constructor Create;
    function CloneNode(RecurseChildren: Boolean): TXmlDNode; override;
  end;

  TXmlDAttrList = class(TPersistent)
  private
    List:     TStringList;
  protected
    function GetCount: Integer;
    function GetValues(const Name: TXmlName): String;
    function GetNames(Index: Integer): TXmlName;
    procedure SetValues(const Name: TXmlName; const Value: String);
    procedure WriteToStream(Stream: TStream);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    property Count: Integer read GetCount;
    property Names[Index: Integer]: TXmlName read GetNames;
    property Values[const Name: TXmlName]: String read GetValues
        write SetValues; default;
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  XmlUtil;
  
{ TXmlDNode }

procedure TXmlDNode.AppendChild(NewNode: TXmlDNode);
begin
  raise EXmlDError.Create('AppendChild operation requested on ' +
      'invalid node type');
end;

constructor TXmlDNode.Create;
begin
  inherited Create;
end;

function TXmlDNode.GetFirstChild: TXmlDNode;
begin
  Result := nil;
end;

function TXmlDNode.GetLastChild: TXmlDNode;
begin
  Result := nil;
end;

function TXmlDNode.GetLevel: Integer;
var
  ParentNode: TXmlDStructureNode;
begin
  Result := 0;
  ParentNode := FParentNode;
  while ParentNode <> nil do
  begin
    Inc(Result);
    ParentNode := ParentNode.FParentNode;
  end;
end;

function TXmlDNode.GetNodeName: TXmlName;
begin
  Result := XmlNodeNames[FNodeType];
end;

function TXmlDNode.GetNodeValue: String;
begin
  Result := '';
end;

function TXmlDNode.GetOwnerDocument: TXmlDDocument;
var
  ParentNode: TXmlDStructureNode;
begin
  ParentNode := FParentNode;
  while ParentNode <> nil do
    ParentNode := ParentNode.FParentNode;
  Result := ParentNode as TXmlDDocument;
end;

function TXmlDNode.HasChildNodes: Boolean;
begin
  Result := False;
end;

procedure TXmlDNode.InsertBefore(NewNode, ThisNode: TXmlDNode);
begin
  if ThisNode = FParentNode.FFirstChild then
    FParentNode.FFirstChild := NewNode;
  if ThisNode.FPreviousSibling <> nil then
    ThisNode.FPreviousSibling.FNextSibling := NewNode;
  NewNode.FPreviousSibling := ThisNode.FPreviousSibling;
  ThisNode.FPreviousSibling := NewNode;
  NewNode.FNextSibling := ThisNode;
end;

function TXmlDNode.RemoveChild(ThisNode: TXmlDNode): TXmlDNode;
begin
  raise EXmlDError.Create('RemoveChild operation requested on ' +
      'invalid node type');
end;

function TXmlDNode.ReplaceChild(NewNode, OldNode: TXmlDNode): TXmlDNode;
begin
  raise EXmlDError.Create('ReplaceChild operation requested on ' +
      'invalid node type');
end;

procedure TXmlDNode.SetNodeName(const Value: TXmlName);
begin
end;

procedure TXmlDNode.SetNodeValue(const Value: String);
begin
end;

procedure TXmlDNode.WriteFormattedPrefix(Stream: TStream);
var
  S:  String;
begin
  S := StringOfChar(' ', (Level - 1) * 2);
  Stream.WriteBuffer(Pointer(S)^, Length(S));
end;

procedure TXmlDNode.WriteFormattedSuffix(Stream: TStream);
const
  CRLF:  String[3] = #13#10;
begin
  Stream.WriteBuffer(CRLF[1], 2);
end;

{ TXmlDStructureNode }

procedure TXmlDStructureNode.AppendChild(NewNode: TXmlDNode);
begin
  NewNode.FParentNode := Self;
  if FFirstChild = nil then
  begin
    FFirstChild := NewNode;
    FLastChild := NewNode;
  end
  else
  begin
    FLastChild.FNextSibling := NewNode;
    NewNode.FPreviousSibling := FLastChild;
    FLastChild := NewNode;
  end;
end;

procedure TXmlDStructureNode.CloneChildren(FromNode: TXmlDStructureNode);
var
  N:  TXmlDNode;
begin
  N := FromNode.FFirstChild;
  while N <> nil do
  begin
    AppendChild(N.CloneNode(True));
    N := N.NextSibling;
  end;
end;

destructor TXmlDStructureNode.Destroy;
var
  Node: TXmlDNode;
  NextNode: TXmlDNode;
begin
  Node := FFirstChild;
  while (Node <> nil) do
  begin
    NextNode := Node.FNextSibling;
    Node.Free;
    Node := NextNode;
  end;
  inherited Destroy;
end;

function TXmlDStructureNode.GetFirstChild: TXmlDNode;
begin
  Result := FFirstChild;
end;

function TXmlDStructureNode.GetLastChild: TXmlDNode;
begin
  Result := FLastChild;
end;

function TXmlDStructureNode.HasChildNodes: Boolean;
begin
  Result := FFirstChild <> nil;
end;

function TXmlDStructureNode.RemoveChild(ThisNode: TXmlDNode): TXmlDNode;
begin
  Result := FFirstChild;
  while ((Result <> nil) and (Result <> ThisNode)) do
    Result := Result.FNextSibling;
  if Result <> nil then
  begin
    if FFirstChild = FLastChild then
    begin
      FFirstChild := nil;
      FLastChild := nil;
    end
    else if Result = FFirstChild then
    begin
      FFirstChild := FFirstChild.FNextSibling;
      FFirstChild.FPreviousSibling := nil;
    end
    else if Result = FLastChild then
    begin
      FLastChild := FLastChild.FPreviousSibling;
      FLastChild.FNextSibling := nil;
    end
    else
    begin
      Result.FPreviousSibling.FNextSibling := Result.FNextSibling;
      Result.FNextSibling.FPreviousSibling := Result.FPreviousSibling;
    end;
    Result.FNextSibling := nil;
    Result.FPreviousSibling := nil;
    Result.FParentNode := nil;
  end;
end;

function TXmlDStructureNode.ReplaceChild(NewNode,
  OldNode: TXmlDNode): TXmlDNode;
var
  NextNode: TXmlDNode;
begin
  if OldNode = FLastChild then
  begin
    Result := RemoveChild(OldNode);
    AppendChild(NewNode);
  end
  else
  begin
    NextNode := OldNode.FNextSibling;
    Result := RemoveChild(OldNode);
    InsertBefore(NewNode, NextNode);
  end;
end;

procedure TXmlDStructureNode.WriteChildrenToStream(Stream: TStream;
    FormattedForPrint: Boolean);
var
  N:  TXmlDNode;
begin
  N := FFirstChild;
  while (N <> nil) do
  begin
    N.WriteToStream(Stream, FormattedForPrint);
    N := N.FNextSibling;
  end;
end;

{ TXmlDContentNode }

function TXmlDContentNode.GetNodeValue: String;
begin
  Result := FValue;
end;

procedure TXmlDContentNode.SetNodeValue(const Value: String);
begin
  FValue := Value;
end;

{ TXmlDDocument }

procedure TXmlDDocument.AppendChild(NewNode: TXmlDNode);
begin
  if NewNode.NodeType = xntElement then
  begin
    if FDocumentElement <> nil then
      raise EXmlDError.Create('Second document element add attempted');
    FDocumentElement := TXmlDElement(NewNode);
  end;
  inherited AppendChild(NewNode);
end;

procedure TXmlDDocument.Clear;
var
  Node: TXmlDNode;
  NextNode: TXmlDNode;
begin
  Node := FFirstChild;
  while (Node <> nil) do
  begin
    NextNode := Node.FNextSibling;
    Node.Free;
    Node := NextNode;
  end;
  FFirstChild := nil;
  FLastChild := nil;
  FDocumentElement := nil;
end;

function TXmlDDocument.CloneNode(RecurseChildren: Boolean): TXmlDNode;
var
  Clone: TXmlDDocument;
begin
  Clone := TXmlDDocument.Create;
  if RecurseChildren then
    Clone.CloneChildren(Self);
  Result := Clone;
end;

constructor TXmlDDocument.Create;
begin
  inherited Create;
  FNodeType := xntDocument;
end;

function TXmlDDocument.CreateCDATASection(const Text: String): TXmlDCDATASection;
begin
  Result := TXmlDCDATASection.Create;
  Result.NodeValue := Text;
end;

function TXmlDDocument.CreateComment(const Text: String): TXmlDComment;
begin
  Result := TXmlDComment.Create;
  Result.NodeValue := Text;
end;

function TXmlDDocument.CreateElement(const TagName: TXmlName): TXmlDElement;
begin
  Result := TXmlDElement.Create;
  Result.NodeName := TagName;
end;

function TXmlDDocument.CreateElement(const TagName: TXmlName;
  const Data: String): TXmlDElement;
begin
  Result := TXmlDElement.Create;
  Result.NodeName := TagName;
  if Data <> '' then
    Result.AppendChild(OwnerDocument.CreateTextNode(Data));
end;

function TXmlDDocument.CreateElement(const TagName: TXmlName;
  const Data: String; const AttrName: TXmlName;
  const AttrValue: String): TXmlDElement;
begin
  Result := TXmlDElement.Create;
  Result.NodeName := TagName;

  if AttrName <> '' then
    Result.FAttrList.Values[AttrName] := EntRef(AttrValue);

  if Data <> '' then
    Result.AppendChild(OwnerDocument.CreateTextNode(Data));
end;

function TXmlDDocument.CreateElement(const TagName: TXmlName;
  const Data: String; const AttrNames: array of TXmlName;
  const AttrValues: array of String): TXmlDElement;
var
  i : integer;
begin
  if (Low(AttrNames) <> Low(AttrValues)) or
      (High(AttrNames) <> High(AttrValues)) then
    raise EXmlDError.Create('Invalid CreateElement call');

  Result := TXmlDElement.Create;
  Result.NodeName := TagName;

  for I := Low(AttrNames) to High(AttrNames) do
    if AttrNames[I] <> '' then
      Result.FAttrList.Values[AttrNames[I]] := EntRef(AttrValues[I]);

  if Data <> '' then
    Result.AppendChild(OwnerDocument.CreateTextNode(Data));
end;

//-----------------------------------------------------------------------------------

function TXmlDDocument.CreateElement(const TagName: TXmlName;
  const AttrNames: array of TXmlName;
  const AttrValues: array of String): TXmlDElement;
// Notes : Create an element with attributes only and no text value
var
  i : integer;
begin
  // Check number of attribute names matches number of attribute values
  if (Low(AttrNames) <> Low(AttrValues)) or
      (High(AttrNames) <> High(AttrValues)) then
    raise EXmlDError.Create('Invalid CreateElement call');

  Result := TXmlDElement.Create;
  Result.NodeName := TagName;

  for I := Low(AttrNames) to High(AttrNames) do
    if AttrNames[I] <> '' then
      Result.FAttrList.Values[AttrNames[I]] := EntRef(AttrValues[I]);
end;

//-----------------------------------------------------------------------------------

function TXmlDDocument.CreateTextNode(const Text: String): TXmlDText;
begin
  Result := TXmlDText.Create;
  Result.NodeValue := EntRef(Text);
end;

//-----------------------------------------------------------------------------------

function TXmlDDocument.CreateProcessingInst(const Text : String) : TXmlDText;
begin
  Result := TXmlDText.Create;
  Result.NodeValue := '<?' + Text + '?>';
end;

//-----------------------------------------------------------------------------------

procedure TXmlDDocument.InsertBefore(NewNode, ThisNode: TXmlDNode);
begin
  if NewNode.NodeType = xntElement then
  begin
    if FDocumentElement <> nil then
      raise EXmlDError.Create('Second document element add attempted');
    FDocumentElement := TXmlDElement(NewNode);
  end;
  inherited InsertBefore(NewNode, ThisNode);
end;

function TXmlDDocument.RemoveChild(ThisNode: TXmlDNode): TXmlDNode;
begin
  if ThisNode = FDocumentElement then
    FDocumentElement := nil;
  Result := inherited RemoveChild(ThisNode);
end;

function TXmlDDocument.ReplaceChild(NewNode,
  OldNode: TXmlDNode): TXmlDNode;
begin
  if OldNode = FDocumentElement then
    FDocumentElement := nil;
  if NewNode.NodeType = xntElement then
    FDocumentElement := TXmlDElement(NewNode);
  Result := inherited ReplaceChild(NewNode, OldNode);
end;

procedure TXmlDDocument.SaveToFile(const FileName: String;
    FormattedForPrint: Boolean);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream, FormattedForPrint); // jim = bug fix
  finally
    Stream.Free;
  end;
end;

procedure TXmlDDocument.SaveToStream(Stream: TStream; FormattedForPrint: Boolean = False);
begin
  WriteToStream(Stream, FormattedForPrint);
end;
                                   
procedure TXmlDDocument.WriteToStream(Stream: TStream; FormattedForPrint: Boolean);
var
  S:  String;
begin
  S := '<?xml version="1.0"?>';
  Stream.WriteBuffer(Pointer(S)^, Length(S));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
  if FDocumentTypeDefinition <> '' then
  begin
    S := '<!DOCTYPE ';
    if DocumentElement<> nil then
      S := S + DocumentElement.NodeName + ' ';
    S := S + FDocumentTypeDefinition + '>';
    Stream.WriteBuffer(Pointer(S)^, Length(S));
    if FormattedForPrint then
      WriteFormattedSuffix(Stream);
  end;
  WriteChildrenToStream(Stream, FormattedForPrint);
end;

function TXmlDElement.CloneNode(RecurseChildren: Boolean): TXmlDNode;
var
  Clone:  TXmlDElement;
begin
  Clone := TXmlDElement.Create;
  Clone.FNodeName := FNodeName;
  Clone.FAttrList.Assign(FAttrList);
  if RecurseChildren then
    Clone.CloneChildren(Self);
  Result := Clone;
end;

constructor TXmlDElement.Create;
begin
  inherited Create;
  FAttrList := TXmlDAttrList.Create;
  FNodeType := xntElement;
end;

destructor TXmlDElement.Destroy;
begin
  FAttrList.Free;
  inherited Destroy;
end;

function TXmlDElement.GetNodeName: TXmlName;
begin
  Result := FNodeName;
end;

procedure TXmlDElement.SetNodeName(const Value: TXmlName);
begin
  FNodeName := Value;
end;

procedure TXmlDElement.WriteToStream(Stream: TStream;
    FormattedForPrint: Boolean);
var
  S:  String;
  Formatted: Boolean;
begin
  Formatted := FormattedForPrint;
  if Formatted then
  begin
    if (FFirstChild <> nil) and (FFirstChild = FLastChild) and
        (FFirstChild.NodeType = xntText) and
        (Length(FFirstChild.NodeValue) < 48) then
      Formatted := False;
    WriteFormattedPrefix(Stream);
  end;
  S := '<' + FNodeName;
  Stream.WriteBuffer(Pointer(S)^, Length(S));
  if FAttrList.Count > 0 then
    FAttrList.WriteToStream(Stream);
  if FFirstChild <> nil then
  begin
    S := '>';
    Stream.WriteBuffer(Pointer(S)^, 1);
    if Formatted then
      WriteFormattedSuffix(Stream);
  end;
  if FFirstChild = nil then
    S := '/>'
  else
  begin
    WriteChildrenToStream(Stream, Formatted);
    if Formatted then
      WriteFormattedPrefix(Stream);
    S := '</' + FNodeName + '>';
  end;
  Stream.WriteBuffer(Pointer(S)^, Length(S));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
end;

{ TXmlDText }

function TXmlDText.CloneNode(RecurseChildren: Boolean): TXmlDNode;
begin
  Result := TXmlDText.Create;
  Result.NodeValue := NodeValue;
end;

constructor TXmlDText.Create;
begin
  inherited Create;
  FNodeType := xntText;
end;

procedure TXmlDText.WriteToStream(Stream: TStream;
    FormattedForPrint: Boolean);
begin
  if FormattedForPrint then
    WriteFormattedPrefix(Stream);
  Stream.WriteBuffer(Pointer(FValue)^, Length(FValue));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
end;

{ TXmlDComment }

function TXmlDComment.CloneNode(RecurseChildren: Boolean): TXmlDNode;
begin
  Result := TXmlDComment.Create;
  Result.NodeValue := NodeValue;
end;

constructor TXmlDComment.Create;
begin
  inherited Create;
  FNodeType := xntComment;
end;

procedure TXmlDComment.WriteToStream(Stream: TStream;
  FormattedForPrint: Boolean);
var
  S:  String;
begin
  if FormattedForPrint then
    WriteFormattedPrefix(Stream);
  S := '<!--' + FValue + '-->';
  Stream.WriteBuffer(Pointer(S)^, Length(S));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
end;

{ TXmlCDATASection }

function TXmlDCDATASection.CloneNode(RecurseChildren: Boolean): TXmlDNode;
begin
  Result := TXmlDCDATASection.Create;
  Result.NodeValue := NodeValue;
end;

constructor TXmlDCDATASection.Create;
begin
  inherited Create;
  FNodeType := xntCDATASection;
end;

procedure TXmlDCDATASection.WriteToStream(Stream: TStream;
    FormattedForPrint: Boolean);
var
  S:  String;
begin
  if FormattedForPrint then
    WriteFormattedPrefix(Stream);
  S := '<![CDATA[' + FValue + ']]>';
  Stream.WriteBuffer(Pointer(S)^, Length(S));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
end;

{ TXmlDAttrList }

procedure TXmlDAttrList.Assign(Source: TPersistent);
begin
  if Source is TXmlDAttrList then
    List.Assign(TXmlDAttrList(Source).List);
end;

procedure TXmlDAttrList.Clear;
begin
  List.Clear;
end;

constructor TXmlDAttrList.Create;
begin
  inherited Create;
  List := TStringList.Create;
end;

destructor TXmlDAttrList.Destroy;
begin
  List.Free;
  inherited Destroy;
end;

function TXmlDAttrList.GetCount: Integer;
begin
  Result := List.Count;
end;

function TXmlDAttrList.GetNames(Index: Integer): TXmlName;
begin
  Result := List.Names[Index];
end;

function TXmlDAttrList.GetValues(const Name: TXmlName): String;
begin
  Result := List.Values[Name];
end;

procedure TXmlDAttrList.SetValues(const Name: TXmlName;
  const Value: String);
begin
  List.Values[Name] := Value;
end;

procedure TXmlDAttrList.WriteToStream(Stream: TStream);
var
  I:  Integer;
  J:  Integer;
  S:  String;
begin
  for I := 0 to (List.Count - 1) do
  begin
    S := List[I];
    J := Pos('=', S);
    S := ' ' + Copy(S, 1, J) + '"' + Copy(S, J + 1, $7FFF) + '"';
    Stream.WriteBuffer(Pointer(S)^, Length(S));
  end;
end;

end.


