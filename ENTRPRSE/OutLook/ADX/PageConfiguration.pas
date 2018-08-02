unit PageConfiguration;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, CheckLst, ComCtrls, Contnrs,
  KPIAvailablePluginsU,
  KPIManagerU,
  KPILayoutManagerU,
  KPICommon;

type
  TLayoutPanel = class(TPanel)
  private
    FTitleLabel: TLabel;
    FKPIPanel: TKPIDisplayPanel;
    FIsSelected: Boolean;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetIsSelected(const Value: Boolean);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Title: string read GetTitle write SetTitle;
    property KPIPanel: TKPIDisplayPanel read FKPIPanel write FKPIPanel;
    property IsSelected: Boolean read FIsSelected write SetIsSelected;
  end;
  TLayoutArea = class(TPanel)
  private
    FPanels: TList;
    FSelected: TLayoutPanel;
    FArea: TKPIDisplayArea;
    procedure SetSelected(const Value: TLayoutPanel);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddPanel(WithCaption: string; KPIPanel: TKPIDisplayPanel): TLayoutPanel;

    // Finds the first panel whose Y location is greater than or equal to the
    // supplied parameter, and returns the index (if no panels are found the
    // returned index will be one greater than the last panel in the list).
    function FindPanelByPosition(YPos: Integer): Integer;

    procedure RedrawLayout;
    property Panels: TList read FPanels;
    property Area: TKPIDisplayArea read FArea write FArea;
    property Selected: TLayoutPanel read FSelected write SetSelected;
  end;
  TDisplayController = class(TObject)
  private
    FDisplay: TScrollBox;
    FColumns: TObjectList;
    FPluginColumnCount: Integer;
    FOutlookColumnCount: Integer;
    FLayoutManager: TKPILayoutManager;
    FSelected: TLayoutPanel;
    procedure ClearColumns;
    procedure SetDisplay(const Value: TScrollBox);
    procedure SetSelected(const Value: TLayoutPanel);
    procedure OnColumnClick(Sender: TObject);
    procedure OnPanelClick(Sender: TObject);
    procedure SetOutlookColumnCount(const Value: Integer);
    procedure SetPluginColumnCount(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure RedrawLayout;
    property Display: TScrollBox read FDisplay write SetDisplay;
    property OutlookColumnCount: Integer read FOutlookColumnCount write SetOutlookColumnCount;
    property PluginColumnCount: Integer read FPluginColumnCount write SetPluginColumnCount;
    property LayoutManager: TKPILayoutManager read FLayoutManager;
    property Columns: TObjectList read FColumns;
    property Selected: TLayoutPanel read FSelected write SetSelected;
  end;

  TPanelDragObject = class(TDragControlObject)
  private
    FDragImages: TDragImageList;
    FData: String;
    FX, FY: Integer;
  protected
    function GetDragImages: TDragImageList; override;
  public
    constructor Create(Control: TControl; Data: String); reintroduce;
    constructor CreateWithHotSpot(Control: TWinControl; X, Y: Integer);
    destructor Destroy; override;
    property Data: String read FData;
  end;

  TActionState = (asNone, asDragging, asResizing);
  TPageConfigurationDlg = class(TForm)
    pnlButtons: TPanel;
    btnOk: TButton;
    btnDelete: TButton;
    pnlMain: TPanel;
    lblLayout: TLabel;
    boxLayout: TScrollBox;
    pnlPlugins: TPanel;
    lblPlugins: TLabel;
    lstPlugins: TCheckListBox;
    Splitter1: TSplitter;
    pnlLayoutOptions: TPanel;
    lblOutlookColumns: TLabel;
    lblPluginColumns: TLabel;
    txtOutlookColumns: TEdit;
    spinOutlookColumns: TUpDown;
    spinPluginColumns: TUpDown;
    txtPluginColumns: TEdit;
    TitleBar: TPanel;
    Image1: TImage;
    DateLbl: TLabel;
    btnCancel: TButton;

    procedure FormCreate(Sender: TObject);
    procedure txtOutlookColumnsChange(Sender: TObject);
    procedure txtPluginColumnsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure ApplicationOnMessage(var Msg: TMsg; var Handled: boolean);
    procedure StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure SharedEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ColumnDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ColumnDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnOkClick(Sender: TObject);
    procedure WMMovePanel(var Msg: TMessage); message WM_MOVEPANEL;
    procedure FormDestroy(Sender: TObject);
    procedure boxLayoutClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    FStoredOnMessage: TMessageEvent;

    FDisplayController: TDisplayController;
    FDragObject: TPanelDragObject;
    FDragPanel: TPanel;

    FDragTargetArea: TLayoutArea;
    FDraggedPanel: TLayoutPanel;

    FActionState: TActionState;

    // Callback method used by PopulatePluginList to add the next plug-in to
    // the list.
    procedure AddPlugIn(PlugInInfo: TKPIPluginInfo);
    // Redraws all the columns and panels
    procedure RedrawLayout;

    // Moves a panel from one area to another
    procedure MovePanel(ToY: Integer);

    procedure SetActionState(const Value: TActionState);

    property ActionState: TActionState read FActionState write SetActionState;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Fills the plug-in list with a list of the plug-ins read from the
    // Section Manager.
    procedure PopulatePluginList;
  end;

implementation

{$R *.dfm}

uses KPIUtils;

const
  SCALING = 2;

// =============================================================================

procedure FixControlStyles(Parent: TControl);
var
  I: Integer;
begin
  Parent.ControlStyle := Parent.ControlStyle + [csDisplayDragImage];
  if Parent is TWinControl then
    with TWinControl(Parent) do
      for I := 0 to ControlCount - 1 do
        FixControlStyles(Controls[I]);
end;

// =============================================================================

type
  TControlCracker = class(Controls.TControl)
  end;

// =============================================================================
// TLayoutPanel
// =============================================================================

constructor TLayoutPanel.Create(AOwner: TComponent);
begin
  inherited;
  Color := clWhite; // $00EEFFFF; // Cream
  FTitleLabel := TLabel.Create(self);
  FTitleLabel.Align := alTop;
  FTitleLabel.Caption := '';
  FTitleLabel.Font.Name := 'Small Fonts';
  FTitleLabel.Font.Size := 7;
  FTitleLabel.Font.Style := [];
  FTitleLabel.Color := clBtnFace;
  InsertControl(FTitleLabel);
  FTitleLabel.Show;
//  Cursor := crSizeAll;
end;

// -----------------------------------------------------------------------------

function TLayoutPanel.GetTitle: string;
begin
  Result := Copy(FTitleLabel.Caption, 2, Length(FTitleLabel.Caption));
end;

// -----------------------------------------------------------------------------

procedure TLayoutPanel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  BeginDrag(False);
end;

procedure TLayoutPanel.Paint;
var
  Rect: TRect;
begin
  Rect := GetClientRect;
  with Canvas do
  begin
    Brush.Color := Color;
    FillRect(Rect);
    Brush.Style := bsClear;
    if FIsSelected then
    begin
      Pen.Color := clWindowText;
      Pen.Style := psDot;
    end
    else
    begin
      Pen.Color := cl3DLight;
      Pen.Style := psDot;
    end;
    Rectangle(Rect);
  end;
end;

// -----------------------------------------------------------------------------

procedure TLayoutPanel.SetIsSelected(const Value: Boolean);
begin
  FIsSelected := Value;
  Invalidate;
end;

procedure TLayoutPanel.SetTitle(const Value: string);
begin
  FTitleLabel.Caption := ' ' + Value;
  FTitleLabel.ShowHint := True;
  FTitleLabel.Hint := Value;
end;

// =============================================================================
// TLayoutArea
// =============================================================================

function TLayoutArea.AddPanel(WithCaption: string; KPIPanel: TKPIDisplayPanel): TLayoutPanel;
var
  Pnl: TLayoutPanel;
begin
  Pnl := TLayoutPanel.Create(self);
  Pnl.Caption := '';
  Pnl.SetBounds(2, 2, ClientWidth - 4, Trunc(KPIPanel.Height / SCALING));
//  Pnl.DragMode := dmAutomatic;
  InsertControl(Pnl);
  FPanels.Add(Pnl);
  Pnl.Title := WithCaption;
  Pnl.KPIPanel := KPIPanel;
  Result := Pnl;
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

constructor TLayoutArea.Create(AOwner: TComponent);
begin
  inherited;
  FPanels := TList.Create;
  Color := clWhite;
end;

// -----------------------------------------------------------------------------

destructor TLayoutArea.Destroy;
var
  i: Integer;
  Pnl: TLayoutPanel;
begin
  for i := FPanels.Count - 1 downto 0 do
  begin
    Pnl := TLayoutPanel(FPanels[i]);
    RemoveControl(Pnl);
    Pnl.Free;
    FPanels[i] := nil;
  end;
  FPanels.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TLayoutArea.FindPanelByPosition(YPos: Integer): Integer;
var
  Entry: Integer;
  Pnl: TLayoutPanel;
begin
  Result := FPanels.Count;
  for Entry := 0 to FPanels.Count - 1 do
  begin
    Pnl := FPanels[Entry];
    if (Pnl.Top >= YPos) then
    begin
      Result := Entry;
      Break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLayoutArea.RedrawLayout;
var
  Entry: Integer;
  Pnl: TLayoutPanel;
  X, Y, W, H: Integer;
  Spacing: Integer;
begin
  Spacing := 8;
  X := 2;
  Y := Spacing;
  W := ClientWidth - 4;
  for Entry := 0 to FPanels.Count - 1 do
  begin
    Pnl := FPanels[Entry];
    H := Pnl.Height;
    Pnl.SetBounds(X, Y, W, H);
    Y := Y + H + Spacing;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLayoutArea.SetSelected(const Value: TLayoutPanel);
var
  Entry: Integer;
  Pnl: TLayoutPanel;
begin
  FSelected := Value;
  for Entry := 0 to FPanels.Count - 1 do
  begin
    Pnl := FPanels[Entry];
    if Pnl = Value then
      Pnl.IsSelected := True
    else
      Pnl.IsSelected := False;
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TDisplayController
// =============================================================================

procedure TDisplayController.ClearColumns;
begin
  FColumns.Clear;
end;

// -----------------------------------------------------------------------------

constructor TDisplayController.Create;
begin
  inherited Create;
  FColumns := TObjectList.Create;
  FColumns.OwnsObjects := True;
  FLayoutManager := TKPILayoutManager.Create;
  FLayoutManager.LoadFromFile(KPIManager.ConfigFileName);
end;

// -----------------------------------------------------------------------------

destructor TDisplayController.Destroy;
begin
  ClearColumns;
  FLayoutManager.Free;
  FColumns.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TDisplayController.OnColumnClick(Sender: TObject);
begin
  if (Sender is TLayoutArea) then
    Selected := nil;
end;

// -----------------------------------------------------------------------------

procedure TDisplayController.OnPanelClick(Sender: TObject);
begin
  if (Sender is TLayoutPanel) then
    Selected := (Sender as TLayoutPanel);
end;

// -----------------------------------------------------------------------------

procedure TDisplayController.RedrawLayout;
var
  Column: TLayoutArea;
  X, W: Integer;
  BaseW: Integer;
  UnitPercent: Double;
  AreaIndex: Integer;
  PanelIndex: Integer;
  Area: TKPIDisplayArea;
  Panel: TLayoutPanel;
begin
  ClearColumns;
  if (FDisplay <> nil) then
  begin
    X := 0;
    BaseW := FDisplay.ClientWidth - 16;
    UnitPercent := BaseW / 100;
    for AreaIndex := 0 to FLayoutManager.WebAreas.Count - 1 do
    begin
      { Add the display area }
      Area := FLayoutManager.WebAreas[AreaIndex];
      // Area width is stored as a percentage. Calculate the actual pixel width.
      W := Trunc(Area.Width * UnitPercent);
      // Create and show the visual display for the area.
      Column := TLayoutArea.Create(nil);
      Column.SetBounds(X, 20, W, FDisplay.ClientHeight - 20);
      Column.Area := Area;
      Column.OnClick := OnColumnClick;
      X := X + Column.Width + 4;
      FDisplay.InsertControl(Column);
      Column.Show;
      FColumns.Add(Column);
      { Add the panels }
      for PanelIndex := 0 to Area.Panels.Count - 1 do
      begin
        Panel := Column.AddPanel(Area.Panels.Items[PanelIndex].Title, Area.Panels.Items[PanelIndex]);
        Panel.OnClick := OnPanelClick;
      end;
    end;
  end;
  FDisplay.Invalidate;
end;

// -----------------------------------------------------------------------------

procedure TDisplayController.SetDisplay(const Value: TScrollBox);
begin
  FDisplay := Value;
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

procedure TDisplayController.SetOutlookColumnCount(const Value: Integer);
begin
  FOutlookColumnCount := Value;
end;

// -----------------------------------------------------------------------------

procedure TDisplayController.SetPluginColumnCount(const Value: Integer);
begin
  FPluginColumnCount := Value;
end;

// -----------------------------------------------------------------------------

procedure TDisplayController.SetSelected(const Value: TLayoutPanel);
var
  Entry: Integer;
  Column: TLayoutArea;
begin
  FSelected := Value;
  for Entry := 0 to Columns.Count - 1 do
  begin
    Column := TLayoutArea(Columns[Entry]);
    Column.Selected := Value;
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TPageConfigurationDlg
// =============================================================================

procedure TPageConfigurationDlg.AddPlugIn(PlugInInfo: TKPIPluginInfo);
var
  ItemIndex: Integer;
begin
  if lstPlugins.Items.IndexOf(PlugInInfo.dpCaption) = -1 then
  begin
    lstPlugins.AddItem(PlugInInfo.dpCaption, PlugInInfo);
    ItemIndex := lstPlugins.Count - 1;
    lstPlugins.Checked[ItemIndex] := PluginInfo.dpActive;
  end;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.ApplicationOnMessage(var Msg: TMsg; var Handled: boolean);
var
  WinControl: TControl;
  ControlPoint: TPoint;
  Action: Integer;
begin
  if Msg.message = WM_LBUTTONDOWN then
  begin
    WinControl := FindDragTarget(Msg.pt, True);
    if Assigned(WinControl) and (WinControl is TLayoutPanel) then
    begin
      ReleaseCapture;
      ControlPoint := WinControl.ScreenToClient(Msg.pt);
      Action := CoordinatesToAction(WinControl, ControlPoint.X, ControlPoint.Y);
      if (Action = ResizeBottom) then
      begin
        PostMessage(Msg.hWnd, WM_SYSCOMMAND, Action, 0);
        FActionState := asResizing;
        Handled := True;
      end;
    end
    else
      ActionState := asNone;
  end
  else if Msg.message = WM_MOUSEMOVE then
  begin
    WinControl := FindDragTarget(Msg.pt, True);
    if Assigned(WinControl) and (WinControl is TLayoutPanel) then
    begin
      ControlPoint := WinControl.ScreenToClient(Msg.pt);
      WinControl.Cursor := ActionToCursor(
        CoordinatesToAction(WinControl, ControlPoint.X, ControlPoint.Y));

      if (FActionState = asResizing) then
      begin
        // Resize the actual panel.
        (WinControl as TLayoutPanel).Height := WinControl.Height;
        (WinControl as TLayoutPanel).KPIPanel.Height := WinControl.Height * SCALING;
        ActionState := asNone;
        RedrawLayout;
      end;

    end
    else
      ActionState := asNone;
  end;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.boxLayoutClick(Sender: TObject);
begin
  FDisplayController.Selected := nil;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.btnDeleteClick(Sender: TObject);
var
  ID: string;
  InstanceID: Integer;
  Panel: TKPIDisplayPanel;
begin
  if (FDisplayController.Selected <> nil) then
  begin
    ID := FDisplayController.Selected.KPIPanel.ID;
    InstanceID := FDisplayController.Selected.KPIPanel.InstanceID;
    Panel := FDisplayController.Selected.KPIPanel;
    FDisplayController.Selected := nil;
    Panel.Owner.DeletePanel(ID, InstanceID);
    RedrawLayout;
  end;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.btnOkClick(Sender: TObject);
begin
  btnOk.Enabled := False;
  FDisplayController.LayoutManager.SaveToFile(KPIManager.ConfigFileName);
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.ColumnDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  PlugInInfo: TKPIPluginInfo;
begin
  FDragTargetArea := Sender as TLayoutArea;
  if (TPanelDragObject(Source).Control is TLayoutPanel) then
  begin
    FDraggedPanel  := TPanelDragObject(Source).Control as TLayoutPanel;
  end
  else
  begin
    PlugInInfo := TKPIPluginInfo(lstPlugins.Items.Objects[lstPlugins.ItemIndex]);
    FDragTargetArea.Area.Panels.Add(PlugInInfo.dpPlugInId, PlugInInfo.dpCaption);
    FDraggedPanel := nil;
    FDragTargetArea := nil;
  end;
  FActionState := asNone;
  PostMessage(self.Handle, WM_MOVEPANEL, X, Y);
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.ColumnDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TPanelDragObject;
end;

// -----------------------------------------------------------------------------

constructor TPageConfigurationDlg.Create(AOwner: TComponent);
begin
  inherited;
  FDisplayController := TDisplayController.Create;
  FDisplayController.Display := boxLayout;
  FActionState := asNone;
  FDragPanel := TPanel.Create(self);
  FDragPanel.Parent := self;
  FDragPanel.Visible := False;
  DateLbl.Caption := FormatDateTime('dd mmmm yyyy', Now);
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

destructor TPageConfigurationDlg.Destroy;
begin
  FDisplayController.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.FormCreate(Sender: TObject);
begin
  PopulatePluginList;
  FStoredOnMessage := Application.OnMessage;
  Application.OnMessage := ApplicationOnMessage;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.FormDestroy(Sender: TObject);
begin
  Application.OnMessage := FStoredOnMessage;
  FStoredOnMessage := nil;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.FormShow(Sender: TObject);
begin
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.MovePanel(ToY: Integer);
var
  KPIArea: TKPIDisplayArea;
  KPIPanel: TKPIDisplayPanel;
  PanelPos: Integer;
begin
  if (FDragTargetArea <> nil) and (FDraggedPanel <> nil) then
  begin
    KPIArea  := FDragTargetArea.Area;
    KPIPanel := FDraggedPanel.KPIPanel;
    PanelPos := FDragTargetArea.FindPanelByPosition(ToY);
    FDragTargetArea := nil;
    FDraggedPanel := nil;
    FDisplayController.ClearColumns;
    KPIArea.GrabPanel(KPIPanel, PanelPos);
  end;
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.PopulatePluginList;
begin
  lstPlugins.Clear;
  KPIManager.ForEachPlugin(AddPlugIn);
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.RedrawLayout;
var
  i, j: Integer;
  Column: TLayoutArea;
  Panel: TLayoutPanel;
begin
  FDisplayController.RedrawLayout;
  FixControlStyles(self);
  for i := 0 to FDisplayController.Columns.Count - 1 do
  begin
    Column := TLayoutArea(FDisplayController.Columns[i]);
    for j := 0 to Column.Panels.Count - 1 do
    begin
      Panel := TLayoutPanel(Column.Panels[j]);
      Panel.OnStartDrag := StartDrag;
      Panel.OnEndDrag   := SharedEndDrag;
    end;
    Column.OnDragDrop := ColumnDragDrop;
    Column.OnDragOver := ColumnDragOver;
  end;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.SetActionState(const Value: TActionState);
begin
  FActionState := Value;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.SharedEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  // All draggable controls share this event handler
  FDragObject.Free;
  FDragObject := nil;
  ActionState := asNone;
  if FDisplayController.Selected <> nil then
    FDisplayController.Selected.Invalidate;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.StartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  Pt: TPoint;
begin
  GetCursorPos(Pt);
  // Make cursor pos relative to object to be dragged
  if (Sender is TCheckListBox) then
  begin
    Pt := TCheckListBox(Sender).ScreenToClient(Pt);
    with Sender as TCheckListBox do
    begin
      FDragPanel.SetBounds(Left, Pt.Y, TCheckListBox(Sender).Width, 100);
    end;
    // Pass info to drag object
    FDragObject := TPanelDragObject.CreateWithHotSpot(FDragPanel, Pt.X, Pt.Y - FDragPanel.Top);
  end
  else if (Sender is TLayoutPanel) then
  begin
    Pt := TLayoutPanel(Sender).ScreenToClient(Pt);
    // Pass info to drag object
    FDragObject := TPanelDragObject.CreateWithHotSpot(TLayoutPanel(Sender), Pt.X, Pt.Y);
  end
  else
    Exit;
  ActionState := asDragging;
  DragObject := FDragObject;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.txtOutlookColumnsChange(Sender: TObject);
begin
  FDisplayController.OutlookColumnCount := spinOutlookColumns.Position;
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.txtPluginColumnsChange(Sender: TObject);
begin
  FDisplayController.PluginColumnCount := spinPluginColumns.Position;
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

procedure TPageConfigurationDlg.WMMovePanel(var Msg: TMessage);
begin
  MovePanel(Msg.LParam);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TPanelDragObject
// =============================================================================

constructor TPanelDragObject.Create(Control: TControl; Data: String);
begin
  inherited Create(Control);
  FData := Data;
end;

// -----------------------------------------------------------------------------

constructor TPanelDragObject.CreateWithHotSpot(Control: TWinControl; X,
  Y: Integer);
begin
  inherited Create(Control);
  FX := X;
  FY := Y;
end;

// -----------------------------------------------------------------------------

destructor TPanelDragObject.Destroy;
begin
  FDragImages.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TPanelDragObject.GetDragImages: TDragImageList;
var
  Bmp: TBitmap;
  BmpIdx: Integer;
  Rect: TRect;
begin
  if not Assigned(FDragImages) then
    FDragImages := TDragImageList.Create(nil);
  Result := FDragImages;
  Result.Clear;
  Bmp := TBitmap.Create;
  try
    Bmp.Canvas.Font.Name := 'Arial';
    Bmp.Canvas.Font.Style := Bmp.Canvas.Font.Style + [fsItalic];

    Bmp.Height := self.Control.Height;
    Bmp.Width  := Self.Control.Width;

    // Fill background with olive
    Bmp.Canvas.Brush.Color := clOlive;
    Bmp.Canvas.FloodFill(0, 0, clWhite, fsSurface);

    Rect := Control.BoundsRect;
    Rect.Top := 0;
    Rect.Left := 0;
    Rect.Right := Bmp.Width - 1;
    Rect.Bottom := Bmp.Height - 1;
    Bmp.Canvas.DrawFocusRect(Rect);

    Result.Width := Bmp.Width;
    Result.Height := Bmp.Height;

    // Make olive pixels transparent, whilst adding bmp to list
    BmpIdx := Result.AddMasked(Bmp, clOlive);
    //Set the drag image and hot spot
    Result.SetDragImage(BmpIdx, FX, FY);
  finally
    Bmp.Free;
  end
end;

// -----------------------------------------------------------------------------

end.

