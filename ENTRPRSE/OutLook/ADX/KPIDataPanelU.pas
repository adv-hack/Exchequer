unit KPIDataPanelU;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Graphics, Controls, StdCtrls,
  ComCtrls, ExtCtrls, GmXML, Menus, KPIBasePanelU;

type
  TKPIGrid = class;

  TKPIFontStyle = (kfsUnset, kfsBold, kfsItalic, kfsUnderline, kfsStrikeOut);
  TKPIFontStyles = set of TKPIFontStyle;

  TKPIBorderSet = (bsBottom, bsRight, bsTop, bsLeft);
  TKPIBorder = record
    IsUsed: Boolean;
    Color: TColor;
    Style: TPenStyle;
  end;
  TKPIBorders = array[bsBottom..bsLeft] of TKPIBorder;

  { Class for holding style details }
  TKPIStyle = class
  private
    FFontSize: Integer;
    FFontName: string;
    FFontColor: TColor;
    FBackColor: TColor;
    FFontStyle: TKPIFontStyles;
    function GetHasValues: Boolean;
    function IsEqual(Border1, Border2: TKPIBorder): Boolean;
  public
    Borders: TKPIBorders;
    constructor Create;
    procedure Clear;
    function Clone: TKPIStyle;
    procedure Read(FromStyle: TKPIStyle); overload;
    procedure Read(FromNode: TgmXMLNode; Default: TKPIStyle = nil); overload;
    property FontName: string read FFontName write FFontName;
    property FontSize: Integer read FFontSize write FFontSize;
    property FontColor: TColor read FFontColor write FFontColor;
    property FontStyle: TKPIFontStyles read FFontStyle write FFontStyle;
    property BackColor: TColor read FBackColor write FBackColor;
    property HasValues: Boolean read GetHasValues;
  end;

  { Class to hold a list of styles, identified by a unique string id. }
  TKPIStyles = class
  private
    FList: TStringList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TKPIStyle;
    function GetStyle(Index: string): TKPIStyle;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Id: string; Style: TKPIStyle);
    procedure Clear;
    function Exists(Id: string): Boolean;
    procedure Remove(Id: string);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TKPIStyle read GetItem;
    property Style[Index: string]: TKPIStyle read GetStyle; default;
  end;

  { Formatting details for the grid header. }
  TDisplayHeader = class(TKPIStyle)
  end;

  { Formatting details for the grid rows. }
  TDisplayRow = class(TKPIStyle)
  end;

  TDisplayDefinition = class(TObject)
  private
    FHeaderStyle: TDisplayHeader;
    FRowStyle: TDisplayRow;
    FAltRowStyle: TDisplayRow;
    FUseHLines: Boolean;
    FUseVLines: Boolean;
    FVLineColor: TColor;
    FHLineColor: TColor;
    FHighlightStyle: TDisplayRow;
    FDefaultStyle: TKPIStyle;
  public
    constructor Create;
    destructor Destroy; override;
    property DefaultStyle: TKPIStyle read FDefaultStyle;
    property HeaderStyle: TDisplayHeader read FHeaderStyle;
    property RowStyle: TDisplayRow read FRowStyle;
    property AltRowStyle: TDisplayRow read FAltRowStyle;
    property HighlightStyle: TDisplayRow read FHighlightStyle;
    property UseVLines: Boolean read FUseVLines write FUseVLines;
    property UseHLines: Boolean read FUseHLines write FUseHLines;
    property VLineColor: TColor read FVLineColor write FVLineColor;
    property HLineColor: TColor read FHLineColor write FHLineColor;
  end;

  { TColumnDef holds formatting details for each column }
  TColumnType = (ctUnknown, ctString);
  TColumnWidthType = (cwtPixel, cwtPercent);
  TColumnDef = class(TObject)
  private
    FStyle: TKPIStyle;
    FGrid: TKPIGrid;
    FWidth: Integer;
    FTitle: string;
    FAlignment: TAlignment;
    FColumnType: TColumnType;
    FWidthType: TColumnWidthType;
    FColumnIndex: Integer;
    FPixelWidth: Integer;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetColumnIndex(const Value: Integer);
    procedure SetColumnType(const Value: TColumnType);
    procedure SetTitle(const Value: string);
    procedure SetWidth(const Value: Integer);
    procedure SetWidthType(const Value: TColumnWidthType);
    procedure SetPixelWidth(const Value: Integer);
  public
    constructor Create(Grid: TKPIGrid);
    destructor Destroy; override;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property ColumnIndex: Integer read FColumnIndex write SetColumnIndex;
    property ColumnType: TColumnType read FColumnType write SetColumnType;
    property PixelWidth: Integer read FPixelWidth write SetPixelWidth;
    property Style: TKPIStyle read FStyle write FStyle;
    property Title: string read FTitle write SetTitle;
    property Width: Integer read FWidth write SetWidth;
    property WidthType: TColumnWidthType read FWidthType write SetWidthType;
  end;
  TColumnDefinitions = array of TColumnDef;

  // ---------------------------------------------------------------------------

  { Individual column values are stored as strings }
  TColData = record
    Value: string;
    Style: TKPIStyle;
  end;
  TColDataArray = array of TColData;

  { Object to store each row, including an array of column data }
  TRow = class(TObject)
  private
    FColumns: TColDataArray;
    FGrid: TKPIGrid;
    FStyle: TKPIStyle;
    FUniqueId: string;
    procedure ClearColumns;
    procedure SetUniqueId(const Value: string);
    function GetColumns(Index: Integer): string;
    procedure SetColumns(Index: Integer; const Value: string);
    function GetColumnStyles(Index: Integer): TKPIStyle;
    procedure SetColumnStyles(Index: Integer; const Value: TKPIStyle);
  public
    constructor Create(Grid: TKPIGrid);
    destructor Destroy; override;
    property Columns[Index: Integer]: string read GetColumns write SetColumns;
    property ColumnStyles[Index: Integer]: TKPIStyle read GetColumnStyles write SetColumnStyles;
    property Style: TKPIStyle read FStyle;
    property UniqueId: string read FUniqueId write SetUniqueId;
  end;
  TRows = array of TRow;

  // ---------------------------------------------------------------------------

  { Data display grid }
  TKPIGrid = class(TListBox)
    procedure ListClick(Sender: TObject);
    procedure Measure(Control: TWinControl; Index: Integer;
      var Height: Integer);
  private
    FRows : TRows;
    FColumnDefs: TColumnDefinitions;
    FDisplayDef: TDisplayDefinition;
    FDrawingStyle: TKPIStyle;
    FIncludeHeader: Boolean;
    function HeaderIsEmpty: Boolean;
    function GetRow(Index: Integer): TRow;
    procedure SetRow(Index: Integer; const Value: TRow);
    function GetColumnDef(Index: Integer): TColumnDef;
    procedure SetColumnDef(Index: Integer; const Value: TColumnDef);
    procedure DrawRow(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    function GetColCount: Integer;
    function GetRowCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure ClearData;
    function AddColumn: TColumnDef;
    function AddRow: TRow;
    function ColumnFromPoint(X: Integer): Integer;
    property ColCount: Integer read GetColCount;
    property RowCount: Integer read GetRowCount;
    property Rows[Index: Integer]: TRow read GetRow write SetRow;
    property ColumnDef[Index: Integer]: TColumnDef read GetColumnDef write SetColumnDef;
    property DisplayDef: TDisplayDefinition read FDisplayDef;
    property IncludeHeader: Boolean read FIncludeHeader;
  end;

  // ---------------------------------------------------------------------------

  TKPIDataPanel = class(TKPIBasePanel)
  private
    { Private declarations }
    FDataList : TKPIGrid;
    FStyles   : TKPIStyles;

    // -------------------------------------------------------------------------
    // Event handlers
    // -------------------------------------------------------------------------
    procedure DataListDblClick(Sender: TObject);
    procedure DataListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DataListExit(Sender: TObject);

    // -------------------------------------------------------------------------
    // Data grid handling
    // -------------------------------------------------------------------------
    procedure ColumnInfoFromXML(Node: TgmXMLNode; Info: TColumnDef);
    procedure ReadStyleFromXML(Node: TgmXMLNode; Style: TKPIStyle);
    procedure ReadStyles(Node: TgmXMLNode);
    procedure AddRow(RowNode: TgmXMLNode);
    procedure ResizeColumns;
    procedure ClearGrid;

    function AttributeValue(Node: TgmXMLNode; AttributeName: string; ToLowercase: Boolean = True): string;

  protected
    procedure DisplayPhaseChanged; override;

    // -------------------------------------------------------------------------
    // Event handlers
    // -------------------------------------------------------------------------
    procedure ResizeHandler(Sender: TObject); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;

    procedure DisconnectFromHost; override;

    // Configures the list columns based on the XML string from the plug-in.
    procedure ConfigureDisplay(const Details: ANSIString); override;

    // Loads the supplied XML data into the grid.
    procedure LoadData(const Data : ANSIString); override;
  published

  end;

Var
  DebugList : TListBox;

Procedure DebugMessage (Const DebugStr : ShortString);

implementation

uses Dialogs, KPIHostControlU, StrUtil, KPIUtils;

const
  NULL_FONTNAME  = '';
  NULL_FONTSIZE  = -1;
  NULL_FONTSTYLE = [kfsUnset];
  NULL_FONTCOLOR = $01000000; // Special value indicating that the default style colour should be used
  NULL_BACKCOLOR = $01000000;
  NULL_BORDER: TKPIBorder = (IsUsed: False; Color: $000000; Style: psClear);

var
  DebugMsgNo : LongInt = 0;
  SectionNo : LongInt = 1;

Procedure DebugMessage (Const DebugStr : ShortString);
Begin // DebugMessage
  If Assigned(DebugList) Then
  Begin
    Inc (DebugMsgNo);
    DebugList.Items.Add (Format ('%5.5d: %s', [DebugMsgNo, DebugStr]));
    DebugList.ItemIndex := DebugList.Items.Count - 1;
  End; // If Assigned(DebugList)
End; // DebugMessage

// -----------------------------------------------------------------------------

function KPIFontStyleToDelphiFontStyle(FontStyles: TKPIFontStyles): TFontStyles;
begin
  Result := [];
  if (kfsBold in FontStyles) then
    Result := Result + [fsBold];
  if (kfsItalic in FontStyles) then
    Result := Result + [fsItalic];
  if (kfsUnderline in FontStyles) then
    Result := Result + [fsUnderline];
  if (kfsStrikeOut in FontStyles) then
    Result := Result + [fsStrikeOut];
end;

// =============================================================================
// TKPIDataPanel
// =============================================================================
constructor TKPIDataPanel.Create(AOwner: TComponent);
var
  Style: TKPIStyle;
begin
  inherited;
  { Create the list of styles, and add the defaults }
  FStyles := TKPIStyles.Create;
  Style := TKPIStyle.Create;
  try
    Style.FontName  := 'Verdana';
    Style.FontSize  := 8;
    Style.FontColor := clWindowText;
    Style.BackColor := clWindow;
    Style.FontStyle := [];
    FStyles.Add('default', Style.Clone);
    FStyles.Add('default.row', Style.Clone);
    FStyles.Add('default.row.alt', Style.Clone);

    Style.FontStyle := [kfsBold];
    Style.Borders[bsBottom].IsUsed := True;
    Style.Borders[bsBottom].Color  := clSilver;
    FStyles.Add('default.header', Style.Clone);

    Style.FontStyle := [];
    Style.BackColor := clHighlight;
    Style.FontColor := clHighlightText;
    Style.Borders[bsBottom] := NULL_BORDER;
    FStyles.Add('default.highlight', Style.Clone);
  finally
    Style.Free;
  end;
end;

// -----------------------------------------------------------------------------

destructor TKPIDataPanel.Destroy;
begin
  inherited Destroy;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.ResizeHandler(Sender: TObject);
begin
  inherited;
  if Assigned(FDataList) then
  begin
    with FDataList do
    begin
      Top := CaptionPanel.Top + CaptionPanel.Height + 2;
      Left := CaptionPanel.Left + 2;
      Width := Self.Width - 4;
      Height := Self.Height - CaptionPanel.Height - (5 + 4);
    end;
    ResizeColumns;
    FDataList.Invalidate;
  end;
end;

// -----------------------------------------------------------------------------

// Configures the list columns based on the XML string from the plug-in:-
//
//  <Columns>
//    <Column Title="Column 1" Type="String" Align="Left" Width="20%"></Column>
//    <Column Title="Column 2" Type="String" Align="Right" Width="80%"></Column>
//  </Columns>
//  <Header Font="Arial, [Bold], 8" Color="#CCCCCC">
//  <Rows Font="Arial, [], 8" Color="#FFFFFF" AltFont="" AltColor="#EEEEFF">
//  <AltRows Font="Arial, [], 8">
//
// Types:- "String"
//
// Align:- "Left", "Right", "Centre"
//
// Width:- "10px" = 10 pixels or "20%" = 20 percent of the available width
//
procedure TKPIDataPanel.ConfigureDisplay(const Details: ANSIString);
var
  oXMLData: TGmXML;
  oDataNode, oAltNode: TGmXMLNode;
  oAttr: TGmXMLAttribute;
  Col: Integer;
  ColumnInfo: TColumnDef;
  OldAttributeSpacesValue: Boolean;
begin
  if Assigned(FDataList) then
  begin
    FDataList.Clear;
    { Add the first row, to hold the column headers }
    FDataList.AddRow;
    OldAttributeSpacesValue := gmXMLAllowAttributeSpaces;
    gmXMLAllowAttributeSpaces := True;
    oXMLData := TGmXML.Create(nil);
    try
      oXMLData.Text := Details;

      { Read style definitions }
      oDataNode := oXMLData.Nodes.NodeByName['Styles'];
      if Assigned(oDataNode) then
        ReadStyles(oDataNode);

      FDataList.DisplayDef.DefaultStyle.Read(FStyles['default']);
      FDataList.DisplayDef.HeaderStyle.Read(FStyles['default.header']);
      FDataList.DisplayDef.RowStyle.Read(FStyles['default.row']);
      FDataList.DisplayDef.AltRowStyle.Read(FStyles['default.row.alt']);
      FDataList.DisplayDef.HighlightStyle.Read(FStyles['default.highlight']);

      { Read column definitions }
      oDataNode := oXMLData.Nodes.NodeByName['Columns'];
      if (Assigned(oDataNode) and (oDataNode.Children.Count > 0)) then
      begin
        for Col := 0 to oDataNode.Children.Count - 1 do
        begin
          ColumnInfo := FDataList.AddColumn;
          ColumnInfoFromXML(oDataNode.Children.Node[Col], ColumnInfo);
        end;
        ResizeColumns;
      end;

      { Extract header formatting details }
      oDataNode := oXMLData.Nodes.NodeByName['Header'];
      if Assigned(oDataNode) then
        ReadStyleFromXML(oDataNode, FDataList.DisplayDef.HeaderStyle);

      { Extract row formatting details }
      oDataNode := oXMLData.Nodes.NodeByName['Rows'];
      if Assigned(oDataNode) then
        ReadStyleFromXML(oDataNode, FDataList.DisplayDef.RowStyle);

      oAltNode := oXMLData.Nodes.NodeByName['AltRows'];
      if Assigned(oAltNode) then
        ReadStyleFromXML(oAltNode, FDataList.DisplayDef.AltRowStyle)

      else if Assigned(oDataNode) then
        ReadStyleFromXML(oDataNode, FDataList.DisplayDef.AltRowStyle);

      { Extract vertical and horizontal line information }
      oDataNode := oXMLData.Nodes.NodeByName['VLines'];
      if Assigned(oDataNode) then
      begin
        oAttr := oDataNode.Attributes.ElementByName['Color'];
        if Assigned(oAttr) then
          FDataList.DisplayDef.VLineColor := WebColorToDelphiColor(oAttr.Value);
        FDataList.DisplayDef.UseVLines := True;
      end;

      oDataNode := oXMLData.Nodes.NodeByName['HLines'];
      if Assigned(oDataNode) then
      begin
        oAttr := oDataNode.Attributes.ElementByName['Color'];
        if Assigned(oAttr) then
          FDataList.DisplayDef.HLineColor := WebColorToDelphiColor(oAttr.Value);
        FDataList.DisplayDef.UseHLines := True;
      end;

    finally
      oXMLData.Free;
      gmXMLAllowAttributeSpaces := OldAttributeSpacesValue;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.ReadStyles(Node: TgmXMLNode);
var
  i: Integer;
  StyleNode: TgmXMLNode;
  Style: TKPIStyle;
  Id: string;
  Attr: TgmXMLAttribute;
begin
  Style := TKPIStyle.Create;
  try
    for i := 0 to Node.Children.Count - 1 do
    begin
      StyleNode := Node.Children.Node[i];
      Attr := StyleNode.Attributes.ElementByName['Id'];
      if (Attr <> nil) then
      begin
        Id := Attr.Value;
        Style.Read(StyleNode, FStyles['default']);
        FStyles.Add(Id, Style.Clone);
      end;
    end;
  finally
    Style.Free;
  end;
end;

// -----------------------------------------------------------------------------

// Loads the list columns based on the XML string from the plug-in:-
//
//  <Data>
//    <Row UniqueId="ABAP01">
//      <Column>ABAP01</Column>
//      <Column>£1,234.56-</Column>
//    </Row>
//    <Row UniqueId="ACE01">
//      <Column>ACE01</Column>
//      <Column>£12,451.68 </Column>
//    </Row>
//  </Data>
//
procedure TKPIDataPanel.LoadData(const Data : ANSIString);
var
  oXMLData: TGmXML;
  oDataNode, oRow: TGmXMLNode;
  iRows: SmallInt;
begin
  inherited;
  FDataList.Items.BeginUpdate;
  // Remove any existing data from the listbox
  FDataList.ClearData;
  // Run through the XML loading up the list
  oXMLData := TGmXML.Create(nil);
  try
    oXMLData.Text := Data;
    oDataNode     := oXMLData.Nodes.NodeByName['Data'];
    if Assigned(oDataNode) then
    begin
      // Copy the data into the grid
      for iRows := 0 to (oDataNode.Children.Count - 1) do
      begin
        oRow := oDataNode.Children.Node[iRows];
        AddRow(oRow);
        Application.ProcessMessages;
      end;
    end;
    FDataList.TopIndex  := 0;
    FDataList.ItemIndex := -1;
  finally
    oXMLData.Free;
    FDataList.Items.EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.DataListDblClick(Sender: TObject);
var
  RowInfo: TRow;
  ColClicked: Integer;
  P: TPoint;
begin // DataListDblClick
  if Assigned(OnDrillDown) and (FDataList.ItemIndex > 0) then
  begin
    P := FDataList.ScreenToClient(Mouse.CursorPos);
    ColClicked := FDataList.ColumnFromPoint(P.X);
    RowInfo := FDataList.Rows[FDataList.ItemIndex];
    OnDrillDown('<id>' + RowInfo.UniqueId + '</id>' +
                '<column>' + IntToStr(ColClicked) + '</column>');
  end;
//    FOnDrillDown(FDataList.Selected.Caption);
end; // DataListDblClick

// -----------------------------------------------------------------------------

function TKPIDataPanel.AttributeValue(Node: TgmXMLNode; AttributeName: string; ToLowercase: Boolean = True): string;
var
  oAttr: TGmXmlAttribute;
begin
  oAttr := Node.Attributes.ElementByName[AttributeName];
  if (oAttr <> nil) then
  begin
    if ToLowercase then
      Result := Lowercase(oAttr.Value)
    else
      Result := oAttr.Value;
  end
  else
    Result := '';
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.ColumnInfoFromXML(Node: TgmXMLNode; Info: TColumnDef);
{ Extracts the column information from the supplied XML node, which is
  expected to be in this format:

    <Column Title="Caption" Type="String" Align="Left" Width="20%"></Column>

  Store the results in the supplied TColumnDef object. }
var
  Value: string;
  CharPos: Integer;
  StyleID: string;
  Style: TKPIStyle;
begin
  if (Node <> nil) then
  begin
    { Column title }
    Value := AttributeValue(Node, 'Title', False);
    Info.Title := Value;
    { Column type }
    Value := AttributeValue(Node, 'Type');
    if (Value = 'string') then
      Info.ColumnType := ctString
    else
      Info.ColumnType := ctUnknown;
    { Column alignment }
    Value := AttributeValue(Node, 'Align');
    if (Value = 'right') then
      Info.Alignment := taRightJustify
    else if ((Value = 'centre') or (Value = 'center')) then
      Info.Alignment := taCenter
    else
      Info.Alignment := taLeftJustify;
    { Column width }
    Value := AttributeValue(Node, 'Width');
    CharPos := Pos('%', Value);
    if (CharPos <> 0) then
    begin
      Info.Width     := StrToIntDef(Copy(Value, 1, CharPos - 1), 10);
      Info.WidthType := cwtPercent
    end
    else
    begin
      Info.Width     := StrToIntDef(Value, 50);
      Info.WidthType := cwtPixel;
    end;
    { Check for optional properties }

    // Read any style specifier.
    StyleID := AttributeValue(Node, 'Style');
    if (StyleID = '') then
      Style := nil
    else
    begin
      // Load the style. If it can't be found, use the default.
      Style := FStyles[StyleID];
      if Style = nil then
        Style := FStyles['default.row'];
    end;
    // Override the style with any other style parameters stored against
    // the node. This allows the plug-in to specify a particular style, then
    // amend specific details of it, like this:
    //
    //    <Column Title="column" Style="balance" FontSize="12"/>
    //
    Info.Style.Read(Node, Style);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.ReadStyleFromXML(Node: TgmXMLNode; Style: TKPIStyle);
var
  FromStyle: TKPIStyle;
  StyleID: string;
begin
  if (Node <> nil) then
  begin
    StyleID := AttributeValue(Node, 'Style');
    if (StyleID = '') then
      FromStyle := FStyles['default.row']
    else
    begin
      FromStyle := FStyles[StyleID];
      if FromStyle = nil then
        FromStyle := FStyles['default.row'];
    end;
    Style.Read(FromStyle);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.AddRow(RowNode: TgmXMLNode);
var
  Col: Integer;
  oAttr: TgmXMLAttribute;
  RowInfo: TRow;
  Style, FromStyle: TKPIStyle;
  StyleID: string;
begin
  if (RowNode <> nil) then
  begin
    // Extract the unique ID
    oAttr := RowNode.Attributes.ElementByName['UniqueId'];
    // Check for columns
    if (RowNode.Children.Count > 0) Then
    begin
      RowInfo := FDataList.AddRow;
      RowInfo.UniqueId := oAttr.Value;
      oAttr := RowNode.Attributes.ElementByName['Style'];
      if (oAttr <> nil) then
        RowInfo.Style.Read(FStyles[oAttr.Value]);
      for Col := 0 To (RowNode.Children.Count - 1) Do
      begin
        RowInfo.Columns[Col] := RowNode.Children.Node[Col].AsString;
        StyleID := AttributeValue(RowNode.Children.Node[Col], 'Style');
        if (StyleID <> '') then
        begin
          FromStyle := FStyles[StyleID];
          if (FromStyle = nil) then
            FromStyle := FStyles['default.row'];
          Style := TKPIStyle.Create;
          Style.Read(FromStyle);
          RowInfo.ColumnStyles[Col] := Style;
        end
        else
        begin
          Style := TKPIStyle.Create;
          Style.Read(RowNode.Children.Node[Col]);
          if Style.HasValues then
            RowInfo.ColumnStyles[Col] := Style
          else
            Style.Free;
        end;
      end; // For iCols
    end; // If (oRow.Children.Count > 0)
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.ResizeColumns;
var
  Col: Integer;
  Column: TColumnDef;
  Units: Double;
begin
  Units := (FDataList.Width - (GetSystemMetrics(SM_CXVSCROLL) + 4)) / 100;
  for Col := 0 to FDataList.ColCount - 1 do
  begin
    Column := FDataList.ColumnDef[Col];
    if (Column.WidthType = cwtPercent ) then
      { Percentage column, so resize it. }
      Column.PixelWidth := Trunc(Column.Width * Units)
    else
      Column.PixelWidth := Column.Width;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.ClearGrid;
begin
  FDataList.Clear;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.DisplayPhaseChanged;
begin
  inherited;

  If (Not Assigned(FDataList)) And (DisplayPhase In [dpLoading, dpDisplay, dpLogin]) Then
  Begin
    { Create the grid }
    FDataList := TKPIGrid.Create(self);
    With FDataList Do
    Begin
      Name := 'lstData';
      BorderStyle := bsNone;
      Visible := False;
      OnDblClick := DataListDblClick;
      OnKeyDown  := DataListKeyDown;
      OnExit     := DataListExit;
      PopupMenu := FMenu;
      Font.Name := 'Arial';
      Font.Size := 8;
    End; // With FDataList
    InsertControl(FDataList);
  end; // If (Not Assigned(FDataList)) And (FDisplayPhase In [dsdpLoading, dsdpDisplay])

  // Hide any non-required controls
  If Assigned(FDataList) Then FDataList.Visible := (DisplayPhase in [dpDisplay, dpUpdating]);

  // Configure the controls
  Case DisplayPhase Of
    dpLoading, dpUpdating     :      // v.006 BJH moved dpUpdating from below so that InfoLabel is visible
                      Begin
                        FDataList.Visible := False;
                      End; // dsdpLoading
    dpDisplay{, dpUpdating}     :
                    Begin
                        FDataList.Visible := True;
                      End; // dsdpDisplay
  End; // Case FDisplayPhase

end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.DisconnectFromHost;
begin
  inherited;
  if Assigned(FDataList) then
  begin
    ClearGrid;
    FreeAndNil(FDataList);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.DataListExit(Sender: TObject);
begin
  if (FDataList.ItemIndex <> -1) then
    FDataList.Selected[FDataList.ItemIndex] := False;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataPanel.DataListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    DataListDblClick(Sender);
end;

// =============================================================================
// TKPIGrid
// =============================================================================
function TKPIGrid.AddColumn: TColumnDef;
begin
  Result := TColumnDef.Create(self);
  if (High(FColumnDefs) = -1) then
    SetLength(FColumnDefs, 1)
  else
    SetLength(FColumnDefs, High(FColumnDefs) + 2);
  Result.ColumnIndex := High(FColumnDefs);
  FColumnDefs[Result.ColumnIndex] := Result;
  FIncludeHeader := not HeaderIsEmpty;
end;

// -----------------------------------------------------------------------------

function TKPIGrid.AddRow: TRow;
begin
  Result := TRow.Create(self);
  if (High(FRows) = -1) then
    SetLength(FRows, 1)
  else
    SetLength(FRows, High(FRows) + 2);
  FRows[High(FRows)] := Result;
  Items.Add('');
  ItemIndex := Count - 1;
end;

// -----------------------------------------------------------------------------

procedure TKPIGrid.Clear;
var
  i: Integer;
begin
  inherited;
  { Clear column info }
  for i := High(FColumnDefs) downto Low(FColumnDefs) do
    if Assigned(FColumnDefs[i]) then
    begin
      FColumnDefs[i].Free;
      FColumnDefs[i] := nil;
    end;
  SetLength(FColumnDefs, 0);

  { Clear row info }
  for i := High(FRows) downto Low(FRows) do
    if Assigned(FRows[i]) then
    begin
      FRows[i].Free;
      FRows[i] := nil;
    end;
  SetLength(FRows, 0);
  FIncludeHeader := False;
end;

// -----------------------------------------------------------------------------

procedure TKPIGrid.ClearData;
var
  i: Integer;
  MinRow: Integer;
begin
  MinRow := 1;
  { Clear row info, except for row 0 (which holds the column header) }
  for i := High(FRows) downto Low(FRows) + MinRow do
    if Assigned(FRows[i]) then
    begin
      FRows[i].Free;
      FRows[i] := nil;
    end;
  SetLength(FRows, 1);
  inherited Clear;
  Items.Add('');
end;

// -----------------------------------------------------------------------------

function TKPIGrid.ColumnFromPoint(X: Integer): Integer;
var
  Col, ColX: Integer;
  Info: TColumnDef;
begin
  ColX := 0;
  Result := 0;
  for Col := 0 to ColCount - 1 do
  begin
    Info := FColumnDefs[Col];
    ColX := ColX + Info.PixelWidth;
    if (X < ColX) then
    begin
      Result := Col;
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

constructor TKPIGrid.Create(AOwner: TComponent);
begin
  inherited;
  Style      := lbOwnerDrawVariable;
  OnDrawItem := DrawRow;
  OnClick    := ListClick;
  OnMeasureItem := Measure;
  FDisplayDef := TDisplayDefinition.Create;
  FDrawingStyle := TKPIStyle.Create;
  FIncludeHeader := False;
end;

// -----------------------------------------------------------------------------

destructor TKPIGrid.Destroy;
begin
  Clear;
  FDisplayDef.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TKPIGrid.DrawRow(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
	Offset: Integer;
  DisplayText: string;
  Col: Integer;
  X, Y, H: Integer;
  ColRect: TRect;
  Info: TColumnDef;
  OldColor: TColor;
  b: TKPIBorderSet;
const
  COLUMN_SPACING = 4;
begin
  FDrawingStyle.Clear;
  FDrawingStyle.Read(DisplayDef.DefaultStyle);
	with (Control as TListBox).Canvas do
	begin
    if (Index = 0) then
    begin
      FDrawingStyle.Read(DisplayDef.HeaderStyle);
    end
    else if (odSelected in State) then
    begin
      FDrawingStyle.Read(DisplayDef.HighlightStyle);
    end
    else
    begin
      if ((Index mod 2) = 1) then
        FDrawingStyle.Read(DisplayDef.RowStyle)
      else
        FDrawingStyle.Read(DisplayDef.AltRowStyle);
    end;
    Font.Name   := FDrawingStyle.FontName;
    Font.Style  := KPIFontStyleToDelphiFontStyle(FDrawingStyle.FontStyle);
    Font.Size   := FDrawingStyle.FontSize;
    Font.Color  := FDrawingStyle.FontColor;
    Brush.Color := FDrawingStyle.BackColor;

    FillRect(Rect);       { clear the rectangle }
    Offset := 2;          { provide default offset }
    H := TextHeight('Ag');
    Y := (Rect.Top + ((Rect.Bottom - Rect.Top) div 2)) - (H div 2);
    if (Index >= Low(FRows)) and (Index <= High(FRows)) then
    begin
      for Col := 0 to ColCount - 1 do
      begin
        OldColor := Brush.Color;
        Info := FColumnDefs[Col];
        DisplayText := Rows[Index].Columns[Col];

        X := Rect.Left + Offset;

        { Copy the default row style }
        if ((Index mod 2) = 1) then
          FDrawingStyle.Read(DisplayDef.RowStyle)
        else
          FDrawingStyle.Read(DisplayDef.AltRowStyle);

        { Override it with any style details set up against the row }
        FDrawingStyle.Read(Rows[Index].Style);

        { Override it with any style details set up against the column }
        FDrawingStyle.Read(Info.Style);

        { Override it with any style details set up against the cell }
        if (Rows[Index].ColumnStyles[Col] <> nil) then
          FDrawingStyle.Read(Rows[Index].ColumnStyles[Col]);

        if (Index > 0) and not (odSelected in State) then
        begin
          ColRect := Rect;
          ColRect.Left := X;
          ColRect.Right := ColRect.Left + Info.PixelWidth - COLUMN_SPACING;
          Brush.Color := FDrawingStyle.BackColor;
          FillRect(ColRect);
        end;
        if (Index > 0) then
        begin
          Font.Name := FDrawingStyle.FontName;
          Font.Style := KPIFontStyleToDelphiFontStyle(FDrawingStyle.FontStyle);
          Font.Size := FDrawingStyle.FontSize;
          if (odSelected in State) then
            Font.Color := clHighlightText
          else
            Font.Color := FDrawingStyle.FontColor;
        end;
        if Info.Alignment = taRightJustify then
        begin
          X := (Rect.Left + Offset + Info.PixelWidth - COLUMN_SPACING) -
               TextWidth(DisplayText);
        end;
        TextOut(X, Y, DisplayText);  { display the text }
        Brush.Color := OldColor;
        if (Col > 0) and DisplayDef.UseVLines then
        begin
          Pen.Color := DisplayDef.VLineColor;
          MoveTo(Rect.Left + Offset - COLUMN_SPACING, Rect.Top);
          LineTo(Rect.Left + Offset - COLUMN_SPACING, Rect.Bottom);
        end;
        for b := bsBottom to bsLeft do
        begin
          case b of
            bsBottom: MoveTo(Rect.Left + Offset, Rect.Bottom - 1);
            bsRight:  MoveTo(Rect.Left + Offset + Info.PixelWidth - COLUMN_SPACING, Rect.Top);
            bsTop:    MoveTo(Rect.Left + Offset, Rect.Top);
            bsLeft:   MoveTo(Rect.Left + Offset, Rect.Top);
          end;
          if FDrawingStyle.Borders[b].IsUsed then
          begin
            Pen.Color := FDrawingStyle.Borders[b].Color;
            Pen.Style := FDrawingStyle.Borders[b].Style;
            case b of
              bsBottom: LineTo(Rect.Left + Offset + Info.PixelWidth - COLUMN_SPACING, Rect.Bottom - 1);
              bsRight:  LineTo(Rect.Left + Offset + Info.PixelWidth - COLUMN_SPACING, Rect.Bottom - 1);
              bsTop:    LineTo(Rect.Left + Offset + Info.PixelWidth - COLUMN_SPACING, Rect.Top);
              bsLeft:   LineTo(Rect.Left + Offset, Rect.Bottom - 1);
            end;
          end;
        end;
        Offset := Offset + Info.PixelWidth;
      end;
    end;
    if DisplayDef.UseHLines then
    begin
      Pen.Color := DisplayDef.HLineColor;
      MoveTo(Rect.Left, Rect.Bottom - 1);
      LineTo(Rect.Right, Rect.Bottom - 1);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TKPIGrid.GetColCount: Integer;
begin
  Result := (High(FColumnDefs) - Low(FColumnDefs)) + 1;
end;

// -----------------------------------------------------------------------------

function TKPIGrid.GetColumnDef(Index: Integer): TColumnDef;
begin
  if ((Index >= Low(FColumnDefs)) and (Index <= High(FColumnDefs))) then
    Result := FColumnDefs[Index]
  else
    Result := nil;
end;

// -----------------------------------------------------------------------------

function TKPIGrid.GetRow(Index: Integer): TRow;
begin
  if ((Index >= Low(FRows)) and (Index <= High(FRows))) then
    Result := FRows[Index]
  else
    Result := nil;
end;

// -----------------------------------------------------------------------------

function TKPIGrid.GetRowCount: Integer;
begin
  Result := (High(FRows) - Low(FRows)) + 1;
end;

// -----------------------------------------------------------------------------

function TKPIGrid.HeaderIsEmpty: Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := Low(FColumnDefs) to High(FColumnDefs) do
    if (Trim(FColumnDefs[i].Title) <> '') then
    begin
      Result := False;
      Break;
    end;
end;

// -----------------------------------------------------------------------------

procedure TKPIGrid.ListClick(Sender: TObject);
begin
  if ItemIndex = 0 then
    ItemIndex := 1;
end;

// -----------------------------------------------------------------------------

procedure TKPIGrid.Measure(Control: TWinControl; Index: Integer;
  var Height: Integer);
begin
  if (Index = 0) and IncludeHeader then
    Height := 24
  else if (Index = 0) and not IncludeHeader then
    Height := 0
  else
    Height := 16;
end;

// -----------------------------------------------------------------------------

procedure TKPIGrid.SetColumnDef(Index: Integer; const Value: TColumnDef);
begin
  if ((Index >= Low(FColumnDefs)) and (Index <= High(FColumnDefs))) then
    FColumnDefs[Index] := Value;
end;

// -----------------------------------------------------------------------------

procedure TKPIGrid.SetRow(Index: Integer; const Value: TRow);
begin
  if ((Index >= Low(FRows)) and (Index <= High(FRows))) then
    FRows[Index] := Value;
end;

// =============================================================================
// TColumnDef
// =============================================================================
constructor TColumnDef.Create(Grid: TKPIGrid);
begin
  inherited Create;
  FGrid := Grid;
  FStyle := TKPIStyle.Create;
end;

// -----------------------------------------------------------------------------

destructor TColumnDef.Destroy;
begin
  FStyle.Free;
  inherited;
end;

procedure TColumnDef.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
end;

// -----------------------------------------------------------------------------

procedure TColumnDef.SetColumnIndex(const Value: Integer);
begin
  FColumnIndex := Value;
end;

// -----------------------------------------------------------------------------

procedure TColumnDef.SetColumnType(const Value: TColumnType);
begin
  FColumnType := Value;
end;

// -----------------------------------------------------------------------------

procedure TColumnDef.SetPixelWidth(const Value: Integer);
begin
  FPixelWidth := Value;
end;

// -----------------------------------------------------------------------------

procedure TColumnDef.SetTitle(const Value: string);
begin
  FTitle := Value;
  FGrid.Rows[0].Columns[FColumnIndex] := Value;
end;

// -----------------------------------------------------------------------------

procedure TColumnDef.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

// -----------------------------------------------------------------------------

procedure TColumnDef.SetWidthType(const Value: TColumnWidthType);
begin
  FWidthType := Value;
end;

// =============================================================================
// TRow
// =============================================================================
procedure TRow.ClearColumns;
var
  i: Integer;
begin
  for i := Low(FColumns) to High(FColumns) do
  begin
    if FColumns[i].Style <> nil then
      FColumns[i].Style.Free;
  end;
  SetLength(FColumns, 0);
end;

// -----------------------------------------------------------------------------

constructor TRow.Create(Grid: TKPIGrid);
begin
  inherited Create;
  FGrid := Grid;
  FStyle := TKPIStyle.Create;
end;

// -----------------------------------------------------------------------------

destructor TRow.Destroy;
begin
  ClearColumns;
  FStyle.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TRow.GetColumns(Index: Integer): string;
begin
  if (Index >= Low(FColumns)) and (Index <= High(FColumns)) then
    Result := FColumns[Index].Value;
end;

// -----------------------------------------------------------------------------

function TRow.GetColumnStyles(Index: Integer): TKPIStyle;
begin
  if ((Index >= Low(FColumns)) and (Index <= High(FColumns))) then
    Result := FColumns[Index].Style
  else
    Result := nil;
end;

// -----------------------------------------------------------------------------

procedure TRow.SetColumns(Index: Integer; const Value: string);
begin
  if (Index > High(FColumns)) then
  begin
    SetLength(FColumns, Index + 1);
    FColumns[Index].Style := nil;
  end;
  FColumns[Index].Value := Value;
end;

// -----------------------------------------------------------------------------

procedure TRow.SetColumnStyles(Index: Integer; const Value: TKPIStyle);
begin
  if (Index > High(FColumns)) then
  begin
    SetLength(FColumns, Index + 1);
    FColumns[Index].Value := '';
  end;
  FColumns[Index].Style := Value.Clone;
end;

// -----------------------------------------------------------------------------

procedure TRow.SetUniqueId(const Value: string);
begin
  FUniqueId := Value;
end;

// =============================================================================
// TDisplayDefinition
// =============================================================================
constructor TDisplayDefinition.Create;
begin
  inherited Create;
  FHeaderStyle    := TDisplayHeader.Create;
  FRowStyle       := TDisplayRow.Create;
  FAltRowStyle    := TDisplayRow.Create;
  FHighlightStyle := TDisplayRow.Create;
  FDefaultStyle   := TKPIStyle.Create;
end;

// -----------------------------------------------------------------------------

destructor TDisplayDefinition.Destroy;
begin
  FHighlightStyle.Free;
  FAltRowStyle.Free;
  FRowStyle.Free;
  FHeaderStyle.Free;
  inherited;
end;

// =============================================================================
// TKPIStyle
// =============================================================================
procedure TKPIStyle.Clear;
begin
  FFontName         := NULL_FONTNAME;
  FFontSize         := NULL_FONTSIZE;
  FFontStyle        := NULL_FONTSTYLE;
  FFontColor        := NULL_FONTCOLOR;
  FBackColor        := NULL_BACKCOLOR;
  Borders[bsBottom] := NULL_BORDER;
  Borders[bsRight]  := NULL_BORDER;
  Borders[bsTop]    := NULL_BORDER;
  Borders[bsLeft]   := NULL_BORDER;
end;

// -----------------------------------------------------------------------------

function TKPIStyle.Clone: TKPIStyle;
begin
  Result := TKPIStyle.Create;
  Result.Read(self);
end;

// -----------------------------------------------------------------------------

constructor TKPIStyle.Create;
begin
  inherited Create;
  Clear;
end;

// -----------------------------------------------------------------------------

function TKPIStyle.GetHasValues: Boolean;
begin
  Result := (FFontName <> NULL_FONTNAME) or
            (FFontSize <> NULL_FONTSIZE) or
            (FFontColor <> NULL_FONTCOLOR) or
            (FFontStyle <> NULL_FONTSTYLE) or
            (FBackColor <> NULL_BACKCOLOR) or
            (not IsEqual(Borders[bsBottom], NULL_BORDER)) or
            (not IsEqual(Borders[bsRight], NULL_BORDER)) or
            (not IsEqual(Borders[bsTop], NULL_BORDER)) or
            (not IsEqual(Borders[bsLeft], NULL_BORDER));
end;

// -----------------------------------------------------------------------------

function TKPIStyle.IsEqual(Border1, Border2: TKPIBorder): Boolean;
begin
  Result := (Border1.IsUsed = Border2.IsUsed) and
            (Border1.Color  = Border2.Color) and
            (Border1.Style  = Border2.Style);
end;

// -----------------------------------------------------------------------------

procedure TKPIStyle.Read(FromStyle: TKPIStyle);
begin
  if (FromStyle.FontName <> NULL_FONTNAME) then
    FFontName  := FromStyle.FontName;
  if (FromStyle.FontSize <> NULL_FONTSIZE) then
    FFontSize  := FromStyle.FontSize;
  if (FromStyle.FontColor <> NULL_FONTCOLOR) then
    FFontColor := FromStyle.FontColor;
  if (FromStyle.BackColor <> NULL_BACKCOLOR) then
    FBackColor := FromStyle.BackColor;
  if (FromStyle.FontStyle <> NULL_FONTSTYLE) then
    FFontStyle := FromStyle.FontStyle;
  if (not IsEqual(FromStyle.Borders[bsBottom], NULL_BORDER)) then
    Borders[bsBottom] := FromStyle.Borders[bsBottom];
  if (not IsEqual(FromStyle.Borders[bsRight], NULL_BORDER)) then
    Borders[bsRight] := FromStyle.Borders[bsRight];
  if (not IsEqual(FromStyle.Borders[bsTop], NULL_BORDER)) then
    Borders[bsTop] := FromStyle.Borders[bsTop];
  if (not IsEqual(FromStyle.Borders[bsLeft], NULL_BORDER)) then
    Borders[bsLeft] := FromStyle.Borders[bsLeft];
end;

// -----------------------------------------------------------------------------

procedure TKPIStyle.Read(FromNode: TgmXMLNode; Default: TKPIStyle);
var
  Attr: TgmXMLAttribute;
  Entries: TStringList;
  i: Integer;
  Entry: string;
  BorderStr, StyleStr: string;
  DefaultStyle: TKPIStyle;
begin
  if (Default = nil) then
  begin
    DefaultStyle := TKPIStyle.Create;
  end
  else
    DefaultStyle := Default.Clone;
  try
    // Read font name
    Attr := FromNode.Attributes.ElementByName['FontName'];
    if (Attr <> nil) then
      self.FFontName := Attr.Value
    else
      self.FFontName := DefaultStyle.FontName;
    // Read font size
    Attr := FromNode.Attributes.ElementByName['FontSize'];
    if (Attr <> nil) then
      self.FFontSize := StrToIntDef(Attr.Value, 8)
    else
      self.FFontSize := DefaultStyle.FontSize;
    // Read font color
    Attr := FromNode.Attributes.ElementByName['FontColor'];
    if (Attr <> nil) then
      self.FFontColor := WebColorToDelphiColor(Attr.Value)
    else
      self.FFontColor := DefaultStyle.FontColor;
    // Read background color
    Attr := FromNode.Attributes.ElementByName['BackColor'];
    if (Attr <> nil) then
      self.FBackColor := WebColorToDelphiColor(Attr.Value)
    else
      self.FBackColor := DefaultStyle.BackColor;
    // Read font style from the comma-separated list
    Attr := FromNode.Attributes.ElementByName['FontStyle'];
    if (Attr <> nil) then
    begin
      StyleStr := Attr.Value;
      Entries := TStringList.Create;
      try
        Split(StyleStr, ',', Entries);
        FFontStyle := [];
        for i := 0 to Entries.Count - 1 do
        begin
          Entry := Lowercase(Trim(Entries[i]));
          if (Entry = 'bold') then
            FFontStyle := FFontStyle + [kfsBold]
          else if (Entry = 'italic') then
            FFontStyle := FFontStyle + [kfsItalic]
          else if (Entry = 'underline') then
            FFontStyle := FFontStyle + [kfsUnderline]
          else if (Entry = 'strikeout') then
            FFontStyle := FFontStyle + [kfsStrikeOut];
        end;
      finally
        Entries.Free;
      end;
    end
    else
      self.FFontStyle := DefaultStyle.FontStyle;

    // Read border styles from the comma-separated list
    Attr := FromNode.Attributes.ElementByName['Borders'];
    if (Attr <> nil) then
    begin
      BorderStr := Attr.Value;
      Entries := TStringList.Create;
      try
        Split(BorderStr, ',', Entries);
        for i := 0 to Entries.Count - 1 do
        begin
          if (Entries[i] <> '0') then
          begin
            Borders[TKPIBorderSet(i)].IsUsed := True;
            Borders[TKPIBorderSet(i)].Color  := WebColorToDelphiColor(Entries[i]);
          end
          else
            Borders[TKPIBorderSet(i)] := NULL_BORDER;
        end;
      finally
        Entries.Free;
      end;
    end
    else
    begin
      self.Borders[bsBottom] := DefaultStyle.Borders[bsBottom];
      self.Borders[bsRight]  := DefaultStyle.Borders[bsRight];
      self.Borders[bsTop]    := DefaultStyle.Borders[bsTop];
      self.Borders[bsLeft]   := DefaultStyle.Borders[bsLeft];
    end;

  finally
    DefaultStyle.Free;
  end;
end;

// =============================================================================
// TKPIStyles
// =============================================================================
procedure TKPIStyles.Add(Id: string; Style: TKPIStyle);
begin
  if not Exists(Id) then
    FList.AddObject(Id, Style)
  else
    GetStyle(Id).Read(Style);
end;

// -----------------------------------------------------------------------------

procedure TKPIStyles.Clear;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
  begin
    if (FList.Objects[i] <> nil) then
    begin
      FList.Objects[i].Free;
      FList.Objects[i] := nil;
    end;
  end;
  FList.Clear;
end;

// -----------------------------------------------------------------------------

constructor TKPIStyles.Create;
begin
  inherited Create;
  FList := TStringList.Create;
end;

// -----------------------------------------------------------------------------

destructor TKPIStyles.Destroy;
begin
  FList.Clear;
  FList.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TKPIStyles.Exists(Id: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  Id := Lowercase(Id);
  for i := 0 to FList.Count - 1 do
  begin
    if Lowercase(FList[i]) = Id then
    begin
      Result := True;
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TKPIStyles.GetCount: Integer;
begin
  Result := FList.Count;
end;

// -----------------------------------------------------------------------------

function TKPIStyles.GetItem(Index: Integer): TKPIStyle;
begin
  if (Index > -1) and (Index < FList.Count) then
    Result := TKPIStyle(FList.Objects[Index])
  else
    raise Exception.Create('Index ' + IntToStr(Index) + ' for TKPIStyles is out of range');
end;

// -----------------------------------------------------------------------------

function TKPIStyles.GetStyle(Index: string): TKPIStyle;
var
  i: Integer;
begin
  Result := nil;
  Index := Lowercase(Index);
  for i := 0 to Count - 1 do
  begin
    if (Lowercase(FList[i]) = Index) then
    begin
      Result := TKPIStyle(FList.Objects[i]);
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIStyles.Remove(Id: string);
var
  i: Integer;
begin
  Id := Lowercase(Id);
  for i := 0 to Count - 1 do
  begin
    if (Lowercase(FList[i]) = Id) then
    begin
      FList.Objects[i].Free;
      FList.Delete(i);
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

end.
