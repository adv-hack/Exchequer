unit KPILayoutManagerU;

interface

uses SysUtils, Classes, gmXML, KPIHostControlU;

type
  TKPIDisplayPanels = class;

  { TKPIDisplayPanel contains the layout details for a single 'panel', which
    contains a KPI data section. }
  TKPIDisplayPanel = class(TCollectionItem)
  private
    FID: string;
    FTitle: string;
    FInterval: Integer;
    FConfiguration: WideString;
    FHeight: Integer;
    FDataHost: TKPIDataHost;
    FInstanceID: Integer;
    FOwner: TKPIDisplayPanels;
    procedure SetID(const Value: string);
    procedure SetDataHost(const Value: TKPIDataHost);
    function GetInstanceID: Integer;
    procedure SetConfiguration(const Value: WideString);
    function GetConfiguration: WideString;
  public
    // The ID of the plugin.
    property ID: string read FID write SetID;
    // The InstanceID of the plugin, to identify the correct panel/host when
    // the same plugin appears more than once on the web-page.
    property InstanceID: Integer read GetInstanceID write FInstanceID;
    // The display caption for the plugin.
    property Title: string read FTitle write FTitle;
    // The display height of the panel.
    property Height: Integer read FHeight write FHeight;
    // The XML fragment containing the configuration details for the panel.
    property Configuration: WideString read GetConfiguration write SetConfiguration;
    // The update interval, in minutes.
    property Interval: Integer read FInterval write FInterval;
    // Holds a reference the Data Host object (as held in the Section Manager).
    property DataHost: TKPIDataHost read FDataHost write SetDataHost;
    // Holds a reference to the Display Panels collection which contains this
    // panel.
    property Owner: TKPIDisplayPanels read FOwner write FOwner;
    // Copies the supplied object, which must be a TKPIDisplayPanel (if it is
    // not, an exception is raised). If Source is nil, it is ignored.
    procedure Assign(Source: TPersistent); override;
  end;

  TKPIPanelCallback = procedure(Panel: TKPIDisplayPanel) of object;

  { TKPIDisplayPanels is a collection of Display Panels. }
  TKPIDisplayPanels = class(TCollection)
  private
    function GetItems(Index: Integer): TKPIDisplayPanel;
    procedure SetItems(Index: Integer; const Value: TKPIDisplayPanel);
    function GetByID(Id: string): TKPIDisplayPanel;
    function GetByInstance(Id: string; InstanceID: Integer): TKPIDisplayPanel;
  public
    constructor Create;
    // Adds a new Display Panel for the specified plug-in.
    function Add(ID, Title: string): TKPIDisplayPanel;
    // Deletes the specified Display Panel.
    procedure DeletePanel(ID: string; InstanceID: Integer);
    // Inserts a new Display Panel for the specified plug-in.
    function Insert(Index: Integer; ID, Title: string): TKPIDisplayPanel;
    // Indexed access to the list of panels.
    property Items[Index: Integer]: TKPIDisplayPanel read GetItems write SetItems; default;
    // Indexed access by plug-in id
    property ByID[Id: string]: TKPIDisplayPanel read GetByID;
    // Indexed access by plug-in id and instance id.
    property ByInstance[Id: string; InstanceID: Integer]: TKPIDisplayPanel read GetByInstance;
  end;

  { TKPIDisplayArea contains the layout details for one area of the page.
    Each area can contain multiple panels. }
  TKPIDisplayArea = class(TCollectionItem)
  private
    FPanels: TKPIDisplayPanels;
    FTop: Integer;
    FLeft: Integer;
    FHeight: Integer;
    FWidth: Integer;
    FPercentWidth: Integer;
    FPercentLeft: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetPercentWidth(const Value: Integer);
    procedure SetPercentLeft(const Value: Integer);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    // Moves the specified panel from its display area into this display area,
    // at the specified index position (the index position indicates the order
    // in which the panels appear).
    procedure GrabPanel(Panel: TKPIDisplayPanel; Index: Integer);
    // Finds the first panel whose Y location is greater than or equal to the
    // supplied parameter, and returns the index (if no panels are found the
    // returned index will be one greater than the last panel in the list).
    function FindPanelIndexByPosition(YPos: Integer): Integer;
    // Collection of Display Panels.
    property Panels: TKPIDisplayPanels read FPanels;
    // The height of the area. For most areas this is actually irrelevant, as
    // the area will occupy all the available height (areas are usually
    // columns).
    property Height: Integer read FHeight write SetHeight;
    // The actual pixel width of the area.
    property Width: Integer read FWidth write SetWidth;
    // The top and left of the area. These are only set when the area panels
    // are actually drawn on screen.
    property Top: Integer read FTop write SetTop;
    property Left: Integer read FLeft write SetLeft;
    // The percentage width of the area, to allow the width of the areas to
    // be re-scaled when the host is resized.
    property PercentWidth: Integer read FPercentWidth write SetPercentWidth;
    // The left position as a percentage of the width of the host.
    property PercentLeft: Integer read FPercentLeft write SetPercentLeft;
  end;

  { TKPIDisplayAreas is a collection of Display Areas. }
  TKPIDisplayAreas = class(TCollection)
  private
    function GetItems(Index: Integer): TKPIDisplayArea;
    procedure SetItems(Index: Integer; const Value: TKPIDisplayArea);
  public
    constructor Create;
    // Adds a new display area. Display Areas are initially stored in the order
    // in which they are added, but this can be changed by amending the Index
    // property of the individual Display Areas.
    function Add(Height, Width: Integer): TKPIDisplayArea;
    // Returns the area that contains the specified location, or nil if no
    // matching area can be found.
    function FindByPosition(X, Y: Integer): TKPIDisplayArea;
    // Returns the area with the least number of panels.
    function LeastUsed: TKPIDisplayArea;
    // Returns true if a plugin exists against the specified id.
    function PluginExists(Id: string): Boolean;
    // Returns true if a plugin exists against the specified id and instance
    // id.
    function PluginInstanceExists(Id: string; InstanceID: Integer): Boolean;
    // Reads the areas and panels from the supplied XML node.
    procedure ReadFromXML(Node: TgmXMLNode);
    // Indexed access to the list of areas.
    property Items[Index: Integer]: TKPIDisplayArea read GetItems write SetItems; default;
  end;

  { The TKPILayoutManager class is the main class for handling the creation,
    saving, and loading of the layout details for the web page. The details
    are stored in the username.dat file, which is then read by the web page
    and the main KPI Section Manager in order to determine the required
    layout. }
  TKPILayoutManager = class(TObject)
  private
    FFileName: string;
    FWebAreas: TKPIDisplayAreas;
    FFormAreas: TKPIDisplayAreas;
    FComment: string;
    FControlWidth: Integer;
    FControlHeight: Integer;
    FShowBorders: Boolean;
    procedure LoadXMLFromFile(XML: TgmXML; FileName: string);
    procedure SetFileName(const Value: string);
    procedure SaveXMLToFile(XML: TgmXML; FileName: string; WithCompression: Boolean = True);
  public
    constructor Create;
    destructor Destroy; override;
    // Clears the existing layout.
    procedure Clear;
    // Loads the details.
    procedure LoadFromFile(FileName: string);
    // Locates the Area and Panel that holds the plug-in specified by the
    // supplied ID and Instance ID. Returns False if no matching plug-in
    // can be found
    function LocatePlugin(ID: string; InstanceID: Integer;
      var Area: TKPIDisplayArea; var Panel: TKPIDisplayPanel): Boolean;
    // Clears the existing layout, and sets up the default layout.
    procedure ResetWebLayout;
    procedure ResetFormLayout;
    // Resizes the layout areas to fit within the specified width and height.
    procedure Resize(ToWidth, ToHeight: Integer);
    // Saves the current details. If the FileName parameter is blank, the
    // currently assigned FileName will be used instead.
    procedure SaveToFile(FileName: string);
    // Calls the specified procedure for each panel in the layout.
    procedure ForEachPanel(PanelCallbackProc: TKPIPanelCallback);
    // Collection of Display Areas for a web-page layout.
    property WebAreas: TKPIDisplayAreas read FWebAreas;
    // Collection of Display Areas for a Windows form layout.
    property FormAreas: TKPIDisplayAreas read FFormAreas;
    // The filename of the configuration file (username.dat).
    property FileName: string read FFileName write SetFileName;
    // Any comment from the Config section of the configuration file.
    property Comment: string read FComment write FComment;
    // The height of the ActiveX control, in pixels.
    property ControlHeight: Integer read FControlHeight write FControlHeight;
    // The width of the ActiveX control, as a percentage;
    property ControlWidth: Integer read FControlWidth write FControlWidth;
    // Whether or not a border should be drawn round the panels.
    property ShowBorders: Boolean read FShowBorders write FShowBorders;
  end;

implementation

uses Graphics, Dialogs, ZLib, KPIUtils;

const
  { Identifying string -- appears unencrypted at the start of the file. The
    first byte indicates whether or not the file is compressed, and the last
    byte is intended to be the version number. }
  VER_1_FILE_ID            = #221#175#180#173#100;
  VER_1_COMPRESSED_FILE_ID = #222#175#180#173#100;

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
// TKPIDisplayPanel
// =============================================================================

procedure TKPIDisplayPanel.Assign(Source: TPersistent);
begin
  if (Source <> nil) then
  begin
    if (Source is TKPIDisplayPanel) then
    begin
      FID             := TKPIDisplayPanel(Source).ID;
      FTitle          := TKPIDisplayPanel(Source).Title;
      FInterval       := TKPIDisplayPanel(Source).Interval;
      FConfiguration  := TKPIDisplayPanel(Source).Configuration;
      FHeight         := TKPIDisplayPanel(Source).Height;
      FDataHost       := TKPIDisplayPanel(Source).DataHost;
    end
    else
      raise Exception.CreateFmt('Cannot assign a %s to a TKPIDisplayPanel',
                                [Source.ClassName]);
  end;
end;

// -----------------------------------------------------------------------------

function TKPIDisplayPanel.GetConfiguration: WideString;
begin
  if (FDataHost = nil) then
    Result := FConfiguration
  else
    Result := DataHost.Configuration;
end;

// -----------------------------------------------------------------------------

function TKPIDisplayPanel.GetInstanceID: Integer;
begin
  if (FDataHost = nil) then
    Result := 0
  else
    Result := DataHost.InstanceID;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayPanel.SetID(const Value: string);
begin
  FID := Value;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayPanel.SetDataHost(const Value: TKPIDataHost);
begin
  FDataHost := Value;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayPanel.SetConfiguration(const Value: WideString);
begin
  FConfiguration := Value;
  if (FDataHost <> nil) then
    DataHost.Configuration := Value;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TKPIDisplayPanels
// =============================================================================

function TKPIDisplayPanels.Add(ID, Title: string): TKPIDisplayPanel;
begin
  Result := TKPIDisplayPanel(inherited Add);
  Result.ID     := ID;
  Result.Title  := Title;
  Result.Height := 100;
  Result.Owner  := self;
end;

// -----------------------------------------------------------------------------

constructor TKPIDisplayPanels.Create;
begin
  inherited Create(TKPIDisplayPanel);
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayPanels.DeletePanel(ID: string; InstanceID: Integer);
var
  Panel: TKPIDisplayPanel;
begin
  Panel := GetByInstance(ID, InstanceID);
  if (Panel <> nil) then
  begin
    self.Delete(Panel.Index);
  end;
end;

// -----------------------------------------------------------------------------

function TKPIDisplayPanels.GetByID(Id: string): TKPIDisplayPanel;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if Items[i].ID = Id then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TKPIDisplayPanels.GetByInstance(Id: string;
  InstanceID: Integer): TKPIDisplayPanel;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if (Items[i].ID = Id) and
       (Items[i].InstanceID = InstanceID) then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TKPIDisplayPanels.GetItems(Index: Integer): TKPIDisplayPanel;
begin
  Result := TKPIDisplayPanel(inherited GetItem(Index));
end;

// -----------------------------------------------------------------------------

function TKPIDisplayPanels.Insert(Index: Integer; ID,
  Title: string): TKPIDisplayPanel;
begin
  Result := TKPIDisplayPanel(inherited Insert(Index));
  Result.ID     := ID;
  Result.Title  := Title;
  Result.Height := 100;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayPanels.SetItems(Index: Integer;
  const Value: TKPIDisplayPanel);
begin
  inherited SetItem(Index, Value);
end;

// =============================================================================
// TKPIDisplayArea
// =============================================================================

constructor TKPIDisplayArea.Create(Collection: TCollection);
begin
  inherited;
  FPanels := TKPIDisplayPanels.Create;
end;

// -----------------------------------------------------------------------------

destructor TKPIDisplayArea.Destroy;
begin
  FPanels.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TKPIDisplayArea.FindPanelIndexByPosition(YPos: Integer): Integer;
var
  Entry: Integer;
  Pnl: TKPIDisplayPanel;
begin
  Result := FPanels.Count;
  for Entry := 0 to FPanels.Count - 1 do
  begin
    Pnl := FPanels[Entry];
    if (Pnl.DataHost.Top >= YPos) then
    begin
      Result := Entry;
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayArea.GrabPanel(Panel: TKPIDisplayPanel; Index: Integer);
var
  NewPanel: TKPIDisplayPanel;
begin
  { Create a new panel, and copy the details. }
  NewPanel := Panels.Insert(Index, Panel.ID, Panel.Title);
  NewPanel.Assign(Panel);

  { Delete the original panel. }
  TKPIDisplayPanels(Panel.GetOwner).Delete(Panel.Index);

end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayArea.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayArea.SetLeft(const Value: Integer);
begin
  FLeft := Value;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayArea.SetPercentLeft(const Value: Integer);
begin
  FPercentLeft := Value;
end;

procedure TKPIDisplayArea.SetPercentWidth(const Value: Integer);
begin
  FPercentWidth := Value;
end;

procedure TKPIDisplayArea.SetTop(const Value: Integer);
begin
  FTop := Value;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayArea.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TKPIDisplayAreas
// =============================================================================

function TKPIDisplayAreas.Add(Height, Width: Integer): TKPIDisplayArea;
begin
  Result := TKPIDisplayArea(inherited Add);
  Result.Height       := Height;
  Result.Width        := Width;
  Result.PercentWidth := Width;
end;

// -----------------------------------------------------------------------------

constructor TKPIDisplayAreas.Create;
begin
  inherited Create(TKPIDisplayArea);
end;

// -----------------------------------------------------------------------------

function TKPIDisplayAreas.FindByPosition(X, Y: Integer): TKPIDisplayArea;
var
  i: Integer;
  X1, Y1, X2, Y2: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    X1 := Items[i].Left;
    X2 := Items[i].Left + Items[i].Width - 1;
    Y1 := Items[i].Top;
    Y2 := Items[i].Top + Items[i].Height - 1;
    if (X1 < X) and (X2 > X) and (Y1 < Y) and (Y2 > Y) then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TKPIDisplayAreas.GetItems(Index: Integer): TKPIDisplayArea;
begin
  Result := TKPIDisplayArea(inherited GetItem(Index));
end;

// -----------------------------------------------------------------------------

function TKPIDisplayAreas.LeastUsed: TKPIDisplayArea;
var
  i: Integer;
  MinCount: Integer;
begin
  MinCount := -1;
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if ((Items[i].Panels.Count < MinCount) or (MinCount = -1)) then
    begin
      Result := Items[i];
      MinCount := Items[i].Panels.Count;
    end;
  end;
  if Result = nil then
  begin
    Result := Add(-1, 100);
  end;
end;

// -----------------------------------------------------------------------------

function TKPIDisplayAreas.PluginExists(Id: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  { For each area }
  for i := 0 to Count - 1 do
  begin
    { Look for a matching plugin }
    if Items[i].Panels.ByID[Id] <> nil then
    begin
      { If found, exit with True }
      Result := True;
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TKPIDisplayAreas.PluginInstanceExists(Id: string;
  InstanceID: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  { For each area }
  for i := 0 to Count - 1 do
  begin
    { Look for a matching plugin }
    if Items[i].Panels.ByInstance[Id, InstanceID] <> nil then
    begin
      { If found, exit with True }
      Result := True;
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayAreas.ReadFromXML(Node: TgmXMLNode);

  // ...........................................................................

  function ReadAttribute(Node: TgmXMLNode; Attribute: string): string;
  var
    Attr: TgmXMLAttribute;
  begin
    Attr := Node.Attributes.ElementByName[Attribute];
    if (Attr <> nil) then
      Result := Attr.Value
    else
      Result := '';
  end;

  // ...........................................................................

  function ReadElement(Node: TgmXMLNode; ElementName: string): string;
  var
    ElementNode: TgmXMLNode;
  begin
    ElementNode := Node.Children.NodeByName[ElementName];
    if (ElementNode <> nil) then
      Result := ElementNode.AsDisplayString
    else
      Result := '';
  end;

  // ...........................................................................

  function NodeToString(Node: TGmXmlNode): WideString;
  var
    ICount: integer;
  begin
    if Node.IsLeafNode then
      Result := Format('<%s>%s</%s>', [Node.Name, Node.AsDisplayString, Node.Name])
    else
    begin
      Result := '<' + Node.Name + '>';
      for ICount := 0 to Node.Children.Count-1 do
        Result := Result + NodeToString (Node.Children.Node[ICount]);
      Result := Result + '</' + Node.Name + '>';
    end;
  end;

  // ...........................................................................

  function ReadChildren(Node: TgmXMLNode): WideString;
  var
    i: Integer;
  begin
    Result := '';
    for i := 0 to (Node.Children.Count - 1) do
      Result := Result + StringReplace(NodeToString(Node.Children.Node[i]), '&', '&&', [rfReplaceAll]);
  end;

  // ...........................................................................

var
  EntryNode, AreaNode, PanelNode: TgmXMLNode;
  AreaIndex, PanelIndex: Integer;
  Area: TKPIDisplayArea;
  Height, Width: Integer;
  PanelId, PanelTitle: string;
  Panel: TKPIDisplayPanel;
begin
  { Load the display areas and panels. }
  EntryNode := Node.Children.NodeByName['KPIHost'];
  { Each host node will have one or more area nodes. }
  if (EntryNode <> nil) then
  begin
    for AreaIndex := 0 to EntryNode.Children.Count - 1 do
    begin
      { Read the area details }
      AreaNode := EntryNode.Children.Node[AreaIndex];
      Height := StrToIntDef(ReadAttribute(AreaNode, 'height'), -1);
      Width := StrToIntDef(ReadAttribute(AreaNode, 'width'), 100);
      { Add the area }
      Area := Add(Height, Width);
      { Each area can have one or more panels }
      for PanelIndex := 0 to AreaNode.Children.Count - 1 do
      begin
        { Read the basic panel details }
        PanelNode := AreaNode.Children.Node[PanelIndex];
        PanelId   := ReadAttribute(PanelNode, 'id');
        if (PanelId = '') then
          PanelId := 'Panel ' + IntToStr(PanelIndex + 1);
        PanelTitle := ReadAttribute(PanelNode, 'title');
        if (PanelTitle = '') then
          PanelTitle := PanelId;
        { Add the panel }
        Panel := Area.Panels.Add(PanelId, PanelTitle);
        { Add the additional details }
        Panel.Height   := StrToIntDef(ReadAttribute(PanelNode, 'height'), 100);
        Panel.Configuration  := ReadChildren(PanelNode);
        Panel.Interval := StrToIntDef(ReadAttribute(PanelNode, 'interval'), 0);
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDisplayAreas.SetItems(Index: Integer;
  const Value: TKPIDisplayArea);
begin
  inherited SetItem(Index, Value);
end;

// =============================================================================
// TKPILayoutManager
// =============================================================================

procedure TKPILayoutManager.Clear;
begin
  FFileName := '';
  FWebAreas.Clear;
  FFormAreas.Clear;
end;

// -----------------------------------------------------------------------------

procedure TKPILayoutManager.LoadXMLFromFile(XML: TgmXML; FileName: string);
var
  InputStream: TFileStream;
  ResultStream: TMemoryStream;
  Version: array[0..Length(VER_1_FILE_ID) - 1] of Byte;
begin
  ResultStream := nil;
  InputStream := TFileStream.Create(FileName, fmOpenRead, fmShareDenyNone);
  try
    { Read the header }
    InputStream.Read(Version, Length(VER_1_FILE_ID));
    ResultStream := TMemoryStream.Create;
    { The first byte of the version array indicates whether the file is
      compressed or not }
    if (Version[0] = 221) then
      { Uncompressed file }
      ResultStream.LoadFromStream(InputStream)
    else if (Version[0] = 222) then
      { Compressed file: Expand into ResultStream }
      ExpandStream(InputStream, ResultStream)
    else
      { Uncompressed file with no header }
    begin
      InputStream.Position := 0;
      ResultStream.LoadFromStream(InputStream);
    end;
    { Read the uncompressed XML data from ResultStream }
    ResultStream.Position := 0;
    XML.LoadFromStream(ResultStream);
  finally
    if Assigned(ResultStream) then
      ResultStream.Free;
    InputStream.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPILayoutManager.SaveXMLToFile(XML: TgmXML;
  FileName: string; WithCompression: Boolean);
var
  Stream: TFileStream;
  CompressionStream: TCompressionStream;
begin
  CompressionStream := nil;
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    if (WithCompression) then
    begin
      // Write the header (always uncompressed).
      Stream.Write(VER_1_COMPRESSED_FILE_ID, Length(VER_1_COMPRESSED_FILE_ID));
      // Compress the stream...
      CompressionStream := TCompressionStream.Create(clDefault, Stream);
      // ...and write it to the file stream.
      XML.SaveToStream(CompressionStream);
    end
    else
    begin
      // Write the header.
      Stream.Write(VER_1_FILE_ID, Length(VER_1_FILE_ID));
      // Write the actual XML.
      XML.SaveToStream(Stream);
    end;
  finally
    if Assigned(CompressionStream) then
      CompressionStream.Free;
    Stream.Free;
  end;
end;

constructor TKPILayoutManager.Create;
begin
  inherited Create;
  FWebAreas := TKPIDisplayAreas.Create;
  FFormAreas := TKPIDisplayAreas.Create;
  FShowBorders := False;
end;

// -----------------------------------------------------------------------------

destructor TKPILayoutManager.Destroy;
begin
  Clear;
  FWebAreas.Free;
  FFormAreas.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TKPILayoutManager.ForEachPanel(
  PanelCallbackProc: TKPIPanelCallback);
var
  i, j: Integer;
begin

  for i := 0 to WebAreas.Count - 1 do
  begin
    for j := 0 to WebAreas[i].Panels.Count - 1 do
      PanelCallBackProc(WebAreas[i].Panels[j]);
  end;

  for i := 0 to FormAreas.Count - 1 do
  begin
    for j := 0 to FormAreas[i].Panels.Count - 1 do
      PanelCallBackProc(FormAreas[i].Panels[j]);
  end;

end;

procedure TKPILayoutManager.LoadFromFile(FileName: string);

  // ...........................................................................

  function ReadElement(Node: TgmXMLNode; ElementName: string): string;
  var
    ElementNode: TgmXMLNode;
  begin
    ElementNode := Node.Children.NodeByName[ElementName];
    if (ElementNode <> nil) then
      Result := ElementNode.AsString
    else
      Result := '';
  end;

  // ...........................................................................

  function ReadBoolean(Node: TgmXMLNode; ElementName: string): Boolean;
  var
    ElementNode: TgmXMLNode;
  begin
    ElementNode := Node.Children.NodeByName[ElementName];
    if (ElementNode <> nil) then
      Result := ElementNode.AsBoolean
    else
      Result := False;
  end;

  // ...........................................................................

var
  XML: TgmXML;
  ConfigNode, LayoutNode: TgmXMLNode;
begin
  XML := TgmXML.Create(nil);
  try
    { Open the XML file }
    LoadXMLFromFile(XML, FileName);
    { Extract the XML nodes for the basic configuration details }
    ConfigNode := XML.Nodes.NodeByName['Config'];
    if (ConfigNode <> nil) and (not ConfigNode.IsLeafNode) then
    begin
      FComment       := ReadElement(ConfigNode, 'Comment');
      FControlHeight := StrToIntDef(ReadElement(ConfigNode, 'Height'), 0);
      FControlWidth  := StrToIntDef(ReadElement(ConfigNode, 'Width'), 0);
      FShowBorders   := ReadBoolean(ConfigNode, 'Borders');
    end;
    { Extract the XML nodes for the web-page layout details }
    LayoutNode := XML.Nodes.NodeByName['WebLayout'];
    if (LayoutNode <> nil) then
    begin
      { Import the layout details }
      WebAreas.ReadFromXML(LayoutNode);
    end
    else
      ResetWebLayout;
    { Extract the XML nodes for the Windows form layout details }
    LayoutNode := XML.Nodes.NodeByName['FormLayout'];
    if (LayoutNode <> nil) then
    begin
      { Import the layout details }
      FormAreas.ReadFromXML(LayoutNode);
    end
    else
      ResetFormLayout;
  finally
    XML.Free;
  end;
end;

// -----------------------------------------------------------------------------

function TKPILayoutManager.LocatePlugin(ID: string; InstanceID: Integer;
  var Area: TKPIDisplayArea; var Panel: TKPIDisplayPanel): Boolean;
var
  i, j: Integer;
begin
  for i := 0 to self.WebAreas.Count - 1 do
  begin
    for j := 0 to WebAreas[i].Panels.Count - 1 do
    begin
      if (WebAreas[i].Panels[j].ID = ID) and
         (WebAreas[i].Panels[j].InstanceID = InstanceID) then
      begin
        Area := WebAreas[i];
        Panel := WebAreas[i].Panels[j];
        Break;
      end;
    end;
    if Assigned(Area) then
      Break;
  end;
  Result := (Area <> nil);
end;

// -----------------------------------------------------------------------------

procedure TKPILayoutManager.ResetFormLayout;
begin
  // KPI display area for Windows form, full height, full width.
  FormAreas.Add(-1, 100);
end;

// -----------------------------------------------------------------------------

procedure TKPILayoutManager.ResetWebLayout;
begin
  { Clear the existing layout. }
  Clear;
  { Set up the defaults. }
  // KPI display area for web-page, full height, 100% width.
  WebAreas.Add(-1, 50);
end;

// -----------------------------------------------------------------------------

procedure TKPILayoutManager.Resize(ToWidth, ToHeight: Integer);
var
  i: Integer;
  Area: TKPIDisplayArea;
  Units: Double;
begin
  Units := (ToWidth / 100);
  for i := 0 to self.WebAreas.Count - 1 do
  begin
    Area := WebAreas[i];
    Area.Width := Trunc(Units * Area.PercentWidth);
    Area.Height := ToHeight;
    Area.Left := Trunc(Units * Area.PercentLeft);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPILayoutManager.SaveToFile(FileName: string);

  // ...........................................................................

  procedure CopyNode(ToXML: TgmXML; FromNode: TgmXMLNode);
  var
    i: Integer;
    Node: TgmXMLNode;
  begin
    ToXML.Nodes.AddOpenTag(FromNode.Name);
    for i := 0 to FromNode.Children.Count - 1 do
    begin
      Node := FromNode.Children[i];
      if Node.IsLeafNode then
        ToXML.Nodes.AddLeaf(Node.Name).AsString := Node.AsString
      else
        CopyNode(ToXML, Node);
    end;
    ToXML.Nodes.AddCloseTag;
  end;

  // ...........................................................................

  procedure AddNodesFromXMLFragment(ToXML: TgmXML; FromFragment: string);
  var
    TempXML: TgmXML;
    i: Integer;
    Node: TgmXMLNode;
  begin
    TempXML := TgmXML.Create(nil);
    try
      TempXML.Text := FromFragment;
      for i := 0 to TempXML.Nodes.Count - 1 do
      begin
        Node := TempXML.Nodes[i];
        if Node.IsLeafNode then
          ToXML.Nodes.AddLeaf(Node.Name).AsString := Node.AsString
        else
          CopyNode(ToXML, Node);
      end;
    finally
      TempXML.Free;
    end;
  end;

  // ...........................................................................

var
  XML: TgmXML;
  Node: TgmXMLNode;
  i, j: Integer;
  Area: TKPIDisplayArea;
  Panel: TKPIDisplayPanel;
begin
  XML := TgmXML.Create(nil);
  try
    { Initialise the file }
    XML.Encoding := 'ISO-8859-1';
    XML.Nodes.AddOpenTag('Root');

    { Save the basic configuration details }
    XML.Nodes.AddOpenTag('Config');
    XML.Nodes.AddLeaf('Comment').AsString := FComment;
    XML.Nodes.AddLeaf('Width').AsInteger  := FControlWidth;
    XML.Nodes.AddLeaf('Height').AsInteger := FControlHeight;
    XML.Nodes.AddLeaf('Borders').AsBoolean := FShowBorders;
    XML.Nodes.AddCloseTag;  // Config

    { Save the web layout }
    XML.Nodes.AddOpenTag('WebLayout');
    XML.Nodes.AddOpenTag('KPIHost');
    for i := 0 to WebAreas.Count - 1 do
    begin
      Area := WebAreas[i];
      Node := XML.Nodes.AddOpenTag('Area');
      Node.Attributes.AddAttribute('height', IntToStr(Area.Height));
      Node.Attributes.AddAttribute('width',  IntToStr(Area.PercentWidth));
      for j := 0 to Area.Panels.Count - 1 do
      begin
        Panel := Area.Panels[j];
        Node := XML.Nodes.AddOpenTag('Panel');
        Node.Attributes.AddAttribute('id',    Panel.ID);
        Node.Attributes.AddAttribute('height', IntToStr(Panel.Height));
        Node.Attributes.AddAttribute('interval', IntToStr(Panel.DataHost.Interval));

        { Write the Label Style details to the XML file }
        if (Panel.DataHost <> nil) then
        begin
          Node := XML.Nodes.AddOpenTag('LabelStyle');
          XML.Nodes.AddLeaf('Caption').AsString := Panel.DataHost.LabelStyle.Caption;
          XML.Nodes.AddLeaf('Font').AsString := Panel.DataHost.LabelStyle.FontName;
          XML.Nodes.AddLeaf('FontSize').AsInteger := Panel.DataHost.LabelStyle.FontSize;
          XML.Nodes.AddLeaf('FontColor').AsInteger := Panel.DataHost.LabelStyle.FontColor;
          XML.Nodes.AddLeaf('BackColor').AsInteger := Panel.DataHost.LabelStyle.BackColor;
          if (fsBold in Panel.DataHost.LabelStyle.FontStyle) then
            XML.Nodes.AddLeaf('Bold').AsInteger := 1
          else
            XML.Nodes.AddLeaf('Bold').AsInteger := 0;
          if (fsItalic in Panel.DataHost.LabelStyle.FontStyle) then
            XML.Nodes.AddLeaf('Italic').AsInteger := 1
          else
            XML.Nodes.AddLeaf('Italic').AsInteger := 0;
          XML.Nodes.AddCloseTag;
        end;

        if (Panel.DataHost <> nil) then
          AddNodesFromXMLFragment(XML, Panel.DataHost.Configuration)
        else
          AddNodesFromXMLFragment(XML, Panel.Configuration);
        XML.Nodes.AddCloseTag; // Panel
      end;
      XML.Nodes.AddCloseTag; // Area
    end;
    XML.Nodes.AddCloseTag; // KPIHost
    XML.Nodes.AddCloseTag; // WebLayout

    { Save the Windows form layout }
    XML.Nodes.AddOpenTag('FormLayout');
    XML.Nodes.AddOpenTag('KPIHost');
    for i := 0 to WebAreas.Count - 1 do
    begin
      Area := WebAreas[i];
      Node := XML.Nodes.AddOpenTag('Area');
      Node.Attributes.AddAttribute('height', IntToStr(Area.Height));
      Node.Attributes.AddAttribute('width',  IntToStr(Area.PercentWidth));
      for j := 0 to Area.Panels.Count - 1 do
      begin
        Panel := Area.Panels[j];
        Node := XML.Nodes.AddOpenTag('Panel');
        Node.Attributes.AddAttribute('id',    Panel.ID);
        Node.Attributes.AddAttribute('height', IntToStr(Panel.Height));
        Node.Attributes.AddAttribute('interval', IntToStr(Panel.DataHost.Interval));

        { Write the Label Style details to the XML file }
        if (Panel.DataHost <> nil) then
        begin
          Node := XML.Nodes.AddOpenTag('LabelStyle');
          XML.Nodes.AddLeaf('Caption').AsString := Panel.DataHost.LabelStyle.Caption;
          XML.Nodes.AddLeaf('Font').AsString := Panel.DataHost.LabelStyle.FontName;
          XML.Nodes.AddLeaf('FontSize').AsInteger := Panel.DataHost.LabelStyle.FontSize;
          XML.Nodes.AddLeaf('FontColor').AsInteger := Panel.DataHost.LabelStyle.FontColor;
          XML.Nodes.AddLeaf('BackColor').AsInteger := Panel.DataHost.LabelStyle.BackColor;
          if (fsBold in Panel.DataHost.LabelStyle.FontStyle) then
            XML.Nodes.AddLeaf('Bold').AsInteger := 1
          else
            XML.Nodes.AddLeaf('Bold').AsInteger := 0;
          if (fsItalic in Panel.DataHost.LabelStyle.FontStyle) then
            XML.Nodes.AddLeaf('Italic').AsInteger := 1
          else
            XML.Nodes.AddLeaf('Italic').AsInteger := 0;
          XML.Nodes.AddCloseTag;
        end;

        if (Panel.DataHost <> nil) then
          AddNodesFromXMLFragment(XML, Panel.DataHost.Configuration)
        else
          AddNodesFromXMLFragment(XML, Panel.Configuration);
        XML.Nodes.AddCloseTag; // Panel
      end;
      XML.Nodes.AddCloseTag; // Area
    end;
    XML.Nodes.AddCloseTag; // KPIHost
    XML.Nodes.AddCloseTag; // FormLayout

    { Finalise the file }
    XML.Nodes.AddCloseTag;  // Root

    { Save the file }
    SaveXMLToFile(XML, FileName);
//    XML.SaveToFile(FileName);

  finally
    XML.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPILayoutManager.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

// -----------------------------------------------------------------------------

end.
