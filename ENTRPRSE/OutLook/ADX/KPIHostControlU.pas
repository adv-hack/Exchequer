unit KPIHostControlU;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics, StdCtrls,
  Variants, AppEvnts, ExtCtrls,
  IKPIHost_TLB,
  KPICommon,
  KPIUtils,
  KPIAvailablePluginsU,
  KPIBasePanelU,
  KPIDataPanelU,
  KPIChartPanelU;

type
  TPushOptions = (poWantColumns, poWantData);
  TPushOptionsSet = set of TPushOptions;

  TKPIDataHost = class;
  TPanelDragObject = class;

  TKPIHostType = (htUnknown, htForm, htWebPage);

  TActionState = (asNone, asDragging, asResizing);

  TKPIHostControl = class(TScrollBox)
    procedure WMMovePanel(var Msg: TMessage); message WM_MOVEPANEL;
  private
    { Private declarations }
    FLastHeight, FLastWidth : LongInt;
    FNextTop : LongInt;
    FInitialised : Boolean;
    FHostType: TKPIHostType;
    FActionState: TActionState;
    FOnRedrawLayout: TNotifyEvent;
    FDragPanel: TPanel;
    FDragObject: TPanelDragObject;
    FDraggedPanel: TKPIBasePanel;

    // Intercepted Windows Messages
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMInfo(var Message: TMessage); message WM_CUSTOMINFO;
    procedure WMResize(var Message: TWMSize); message WM_SIZE;

    // Mouse handlers, for resizing the panels.
    procedure ControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    // Property setters
    procedure SetActionState(const Value: TActionState);
    procedure SetHostType(const Value: TKPIHostType);

    // Drag/drop handlers.
    procedure ControlDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ControlDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ControlEndDrag(Sender, Target: TObject; X, Y: Integer);

    // If FDraggedPanel is assigned, this moves it to a new location, based on
    // the supplied co-ordinates (note that the panel will probably not end up
    // at precisely these co-ordinates, as panels are constrained to specific
    // display areas).
    procedure MovePanel(ToX, ToY: Integer);

    // RedrawLayout is called when the panels need to be redrawn (such as after
    // resizing or dragging a panel). It relies on the OnRedrawLayout event
    // handler being assigned, otherwise it does nothing.
    procedure RedrawLayout;

    // ActionState indicates if panels are currently being resized or dragged.
    property ActionState: TActionState read FActionState write SetActionState;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // Returns the handle of the host application (Outlook, or IRIS Enterprise).
    function GetHostHandle : HWND;

    // Creates a new panel, and initialises it with information read from the
    // supplied host.
    function NewDataPanel(Host: TKPIDataHost): TKPIDataPanel;
    function NewChartPanel(Host: TKPIDataHost): TKPIChartPanel;

    // StartDrag is called when the user starts to drag one of the panels, and
    // initialises and displays drag object (using a hidden panel, rather than
    // the panel actually being dragged, so that the size is constrained to
    // something reasonable).
    procedure StartDrag(Sender: TObject; var DragObject: TDragObject);

    // HostType tells the control whether it is running in a web-page (as
    // with Outlook Today) or on an actual form.
    property HostType: TKPIHostType read FHostType write SetHostType;

    // If assigned, the OnRedrawLayout handler is called when all the panels
    // need to be redrawn.
    property OnRedrawLayout: TNotifyEvent read FOnRedrawLayout write FOnRedrawLayout;

  published
    { Published declarations }
  end;

  { Acts as a Host to the Data Plug-In and interfaces it with the TBasePanel,
    the TKPIManager object and the Authentication Plug-In. }
  TKPIDataHost = class(TObject)
  private
    FDisplay : TKPIBasePanel;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FPluginInfo : TKPIPluginInfo;
    FStatus : EnumDataPluginStatus;

    // Cache of configuration settings for this plug-in instance
    FConfigSettings : ANSIString;

    // Uniquely identifies this plug-in instance for the messaging system
    FInstanceId : Integer;

    // This instance of the Plug-In should be created/Destroyed using the CreatePlugin and
    // DestroyPlugin methods which check to see if it is already in existence and only
    // destroy it if it was created by the paired CreatePlugin call.
    FPlugin : IDataPlugin;

    // The number of minutes between each data refresh of the plug-in. If this
    // is zero, the data is loaded when the ActiveX control is first displayed,
    // but is not subsequently updated.
    FInterval: Integer;

    // Holds the number of timer-clicks (usually minutes) till the next data
    // update. Decremented with each click until it reaches zero, at which
    // point the data is updated, and the value is set back to FInterval.
    FNextUpdate: Integer;

    // Set to True if the plug-in has successfully logged in and displayed
    // data.
    FRunning: Boolean;

    function CreatePlugin : Byte;
    procedure DestroyPlugin (Const Status : Byte);
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
  public
    // Label Style -- determines the display of the title label for the panel.
    LabelStyle: TKPILabelStyle;

    Property InstanceId : Integer Read FInstanceId;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;

    constructor Create;
    destructor Destroy; Override;

    procedure ConnectToHost(Host : TKPIHostControl);
    procedure DisconnectFromHost;

//    procedure Configure(PluginInfo : TKPIPluginInfo; oConfigXML : TGmXMLNode); overload;

    procedure Configure(PluginInfo : TKPIPluginInfo; Configuration: ANSIString); //overload;

    procedure ConfigurePlugin;
    procedure ConfigureInterval;
    procedure ConfigureLabel;

    procedure UpdateLabel;
    
    procedure DrillDown (const UniqueId : ShortString);
    procedure Login;
    procedure RemovePlugin(const ID: string; const InstanceID: Integer);

    // Called when a message has been received from the plug-in - typically
    // from a drill-down window displayed by the DrillDown event.
    procedure ProcessMessage (var Message: TMessage);

    // Creates a plug-in instance and pushes the column info and data down into
    // the display control.
    procedure PushData;

    procedure Resize(Host: TKPIHostControl);

    procedure ShowBorders(Show: Boolean);

    procedure Highlight(const Value: Boolean);

    // Called after a successful login to run through rechecking the logins
    // for all plug-ins requiring the same authentication system
    procedure CheckLogin (Const AuthenticationId : ShortString; Force: Boolean = False);

    property Plugin: IDataPlugin read FPlugin; // v.006 BJH
    property PluginInfo: TKPIPluginInfo read FPluginInfo;
    property Configuration: ANSIString read FConfigSettings write FConfigSettings;
    property Interval: Integer read FInterval write FInterval;
    property NextUpdate: Integer read FNextUpdate write FNextUpdate;
    property Running: Boolean read FRunning write FRunning;

  end; // TKPIDataHost

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

procedure Register;

implementation

uses Dialogs, COMObj,
  gmXML,
  PageConfiguration,
  KPIUpdateIntervalDlgU,
  KPILayoutManagerU,
  KPIAuthenticationPluginsU,
  KPIManagerU,
  KPIConfigLabelFormU;

Var
  lInstanceId : TBits;

// =============================================================================

procedure Register;
begin
  RegisterComponents('IEOutlook', [TKPIHostControl]);
end;

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
// TKPIHostControl
// =============================================================================

procedure TKPIHostControl.ControlDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
{
  if (TPanelDragObject(Source).Control is TKPIBasePanel) then
    FDraggedPanel := TPanelDragObject(Source).Control as TKPIBasePanel;
}
  ActionState := asNone;
  PostMessage(self.Handle, WM_MOVEPANEL, X, Y);
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.ControlDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TPanelDragObject;
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.ControlEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  FDragObject.Free;
  FDragObject := nil;
  ActionState := asNone;
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.ControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ControlPoint: TPoint;
  ActionType: Integer;
begin
  if (Sender is TKPIBasePanel) then
  begin
    ReleaseCapture;
    ControlPoint := Point(X, Y);
    ActionType := CoordinatesToAction((Sender as TKPIBasePanel), ControlPoint.X, ControlPoint.Y);
    if (ActionType = ResizeBottom) then
    begin
{$IFDEF KPI_DEBUG}
  KPIManager.Log('Starting resize');
{$ENDIF}
      ActionState := asResizing;
      (Sender as TKPIBasePanel).BringToFront;
      PostMessage((Sender as TKPIBasePanel).Handle, WM_SYSCOMMAND, ActionType, 0);
    end;
  end
  else if (ActionState <> asDragging) then
    ActionState := asNone;
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.ControlMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ControlPoint: TPoint;
  ActionType: Integer;
  Area: TKPIDisplayArea;
  Panel: TKPIDisplayPanel;
begin
  if (Sender is TKPIBasePanel) then
  begin
    with (Sender as TKPIBasePanel) do
    begin
      ControlPoint := Point(X, Y);
      ActionType := CoordinatesToAction((Sender as TKPIBasePanel), ControlPoint.X, ControlPoint.Y);
      if (ActionType = ResizeBottom) then
      begin
        Cursor := ActionToCursor(ActionType);
        { While the mouse is captured for resizing, no Mouse Move events will
          be received until the mouse is released, so if we receive a Mouse
          Move event while the ActionState is set to asResizing, it means that
          the user has actually just finished resizing. }
        if (ActionState = asResizing) then
        begin
          ActionState := asNone;
          { Find the plug-in that was being resized, and set the height to the
            new height of the panel. }
          Area := nil;
          Panel := nil;
          if KPIManager.LayoutManager.LocatePlugin(PluginInfo.dpPluginId, InstanceID, Area, Panel) then
          begin
            Panel.Height := (Sender as TKPIBasePanel).Height;
            Panel.DataHost.Height := Panel.Height;
            KPIManager.SaveConfiguration;
          end;
          RedrawLayout;
        end;
      end
      else if (ActionState <> asDragging) then
      begin
        Cursor := crDefault;
        ActionState := asNone;
      end;
    end;
  end
  else if (ActionState <> asDragging) then
    ActionState := asNone;
end;

// -----------------------------------------------------------------------------

constructor TKPIHostControl.Create(AOwner: TComponent);
begin // Create
  inherited Create(AOwner);

  FLastHeight := -1;
  FLastWidth := -1;
  FInitialised := False;

  Align := alClient;
  BorderStyle := bsNone;
  Color := clWindow;

//ShowMessage ('SectionHost: ' + IntToStr(Self.Handle));

  FNextTop := 0;

  ActionState := asNone;

  FDragPanel := TPanel.Create(self);
  FDragPanel.Parent := self;
  FDragPanel.Visible := False;

  self.OnDragOver := ControlDragOver;
  self.OnDragDrop := ControlDragDrop;
  self.OnEndDrag  := ControlEndDrag;
  self.OnMouseMove := ControlMouseMove;

end; // Create

// -----------------------------------------------------------------------------

destructor TKPIHostControl.Destroy;
begin // Destroy

  // Disconnect from KPIManager
  KPIManager.DisconnectFromHost;

  inherited Destroy;
end; // Destroy

// -----------------------------------------------------------------------------

function TKPIHostControl.GetHostHandle : HWND;
{ Starting from the window handle of the OCX Panel we work back through the
  hierarchy of parents to get the root parent which should be the hosting app,
  i.e. Outlook or IE }
Var
  hHandle, hPrevHandle : hWnd;
Begin // GetHostHandle
  hPrevHandle := 0;

  hHandle := GetParent(Self.Handle);
  While (hHandle <> 0) Do
  Begin
    hPrevHandle := hHandle;
    hHandle := GetParent(hPrevHandle);
  End; // While (hHandle <> 0)

  Result := hPrevHandle;
End; // GetHostHandle

// -----------------------------------------------------------------------------

procedure TKPIHostControl.MovePanel(ToX, ToY: Integer);
var
  Area: TKPIDisplayArea;
  Panel: TKPIDisplayPanel;
  ID: string;
  InstanceID: Integer;
  PanelPos: Integer;
begin
  Area := nil;
  Panel := nil;
  if (FDraggedPanel <> nil) then
  begin
    ID := FDraggedPanel.PluginInfo.dpPluginId;
    InstanceID := FDraggedPanel.InstanceID;
    if KPIManager.LayoutManager.LocatePlugin(ID, InstanceID, Area, Panel) then
    begin
      Area := KPIManager.LayoutManager.WebAreas.FindByPosition(ToX, ToY);
      if (Area <> nil) then
      begin
        PanelPos := Area.FindPanelIndexByPosition(ToY);
        Area.GrabPanel(Panel, PanelPos);
      end;
    end;
    FDraggedPanel := nil;
  end;
  KPIManager.SaveConfiguration;
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

function TKPIHostControl.NewChartPanel(Host: TKPIDataHost): TKPIChartPanel;
var
  W, X: Integer;
  Units: Double;
begin
  Result := TKPIChartPanel.Create(Self);
  with Result do
  begin
    Parent := Self;
    Units := (self.Width / 100);
    W := Trunc(Units * Host.Width);
    X := Trunc(Units * Host.Left);
    SetBounds(X, Host.Top, W - (GetSystemMetrics(SM_CXVSCROLL) + 4), Host.Height);
    FNextTop := FNextTop + Height;
    Initialise(Host.PluginInfo, Host.InstanceId);
    OnMouseDown := self.ControlMouseDown;
    OnMouseMove := self.ControlMouseMove;
    CaptionLabel.OnStartDrag := self.StartDrag;
  end;
end;

// -----------------------------------------------------------------------------

function TKPIHostControl.NewDataPanel(Host: TKPIDataHost): TKPIDataPanel;
var
  W, X: Integer;
  Units: Double;
begin // NewKPIDataPanel
  Result := TKPIDataPanel.Create(Self);
  with Result do
  begin
    Parent := Self;
    Units := (self.Width / 100);
    W := Trunc(Units * Host.Width);
    X := Trunc(Units * Host.Left);
    SetBounds(X, Host.Top, W - (GetSystemMetrics(SM_CXVSCROLL) + 4), Host.Height);
    FNextTop := FNextTop + Height;
    Visible := True;
    Initialise(Host.PluginInfo, Host.InstanceId);
    OnMouseDown := self.ControlMouseDown;
    OnMouseMove := self.ControlMouseMove;
    CaptionLabel.OnStartDrag := self.StartDrag;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.RedrawLayout;
begin
  if Assigned(FOnRedrawLayout) then
    OnRedrawLayout(self);
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.SetActionState(const Value: TActionState);
begin
  FActionState := Value;
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.SetHostType(const Value: TKPIHostType);
begin
  FHostType := Value;
  KPIManager.HostType := FHostType;
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.StartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  Pt: TPoint;
begin
  GetCursorPos(Pt);
  // Make cursor pos relative to object to be dragged
  if (Sender is TLabel) then
  begin
    FDraggedPanel := ((Sender as TLabel).Parent.Parent) as TKPIBasePanel;
    with Sender as TLabel do
    begin
      Pt := ScreenToClient(Pt);
      FDragPanel.SetBounds(Left, Pt.Y, (Sender as TLabel).Width, 48);
    end;
    // Pass info to drag object
    FDragObject := TPanelDragObject.CreateWithHotSpot(FDragPanel, Pt.X, Pt.Y - FDragPanel.Top);
    ActionState := asDragging;
    DragObject := FDragObject;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.WMInfo(var Message: TMessage);
begin // WMInfo
  ShowMessage ('TKPIHostControl.WMInfo');
end; // WMInfo

// -----------------------------------------------------------------------------

// Intercept the WM_WindowPosChanged message and use that to trigger the sizing of the controls
// and loading of the data as the control isn't initialized enough to do it during the Create
procedure TKPIHostControl.WMMovePanel(var Msg: TMessage);
begin
  MovePanel(Msg.WParam, Msg.LParam);
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.WMResize(var Message: TWMSize);
begin
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

procedure TKPIHostControl.WMWindowPosChanged(var Message: TWMWindowPosChanged);
Begin // WMWindowPosChanged
  Inherited;
  // Check the size has changed before re-organsing everything
  If (Height <> FLastHeight) Or (Width <> FLastWidth) Then
  Begin
    FLastHeight := Height;
    FLastWidth := Width;

    KPIManager.OnResize(self);
  End; // If (Height <> FLastHeight) Or (Width <> FLastWidth)

  If (Not FInitialised) Then
  Begin
    // Connect to KPIManager
    FInitialised := True;
    KPIManager.ConnectToHost(Self);
    FixControlStyles(self);
  End; // If (Not FInitialised)
End; // WMWindowPosChanged

// -----------------------------------------------------------------------------

// =============================================================================
// TKPIDataHost
// =============================================================================

Constructor TKPIDataHost.Create;
Begin // Create
  Inherited Create;

  FConfigSettings := '';
  FDisplay := NIL;
  FPluginInfo := NIL;
  FStatus := psConfigError;

  // Allocate the next available instance number to the plug-in - never free the numbers
  // as that may cause issues with a newly enabled plug-in having the same Id as a previously
  // disabled plug-in
  FInstanceId := lInstanceId.OpenBit;
  lInstanceId.Bits[FInstanceId] := True;
End; // Create

// -----------------------------------------------------------------------------

destructor TKPIDataHost.Destroy;
begin // Destroy
  FConfigSettings := '';

  // Remove reference to Display object - it is owned by the SectionHost ActiveX control
  FDisplay := nil;

  inherited Destroy;
end; // Destroy

// -----------------------------------------------------------------------------

function TKPIDataHost.CreatePlugin : Byte;
begin
  if (not Assigned(FPlugin)) then
  begin
    // Create the plug-in and pass in the configuration and authentication information
    // so that it can work out which way is up
    FPlugin := FPluginInfo.CreateInstance(FInstanceID); // v.004 BJH
    FPlugin.dpConfiguration := FConfigSettings +
      '<Areas>' + IntToStr(KPIManager.ActiveAreas.Count) + '</Areas>';
    FPlugin.dpMessageId := FInstanceId;
    Result := 1;
    if Running then
      Result := 2;
  end // If (Not Assigned(FPlugin))
  else if Running then
    Result := 2
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.DestroyPlugin (Const Status : Byte);
Begin // DestroyPlugin
  If (Status = 1) Then FPlugin := NIL;
End; // DestroyPlugin

// -----------------------------------------------------------------------------
(*
procedure TKPIDataHost.Configure(PluginInfo : TKPIPluginInfo; oConfigXML : TGmXMLNode);
Var
//  oXMLNode : TGmXMLNode;
  oXMLAttr : TGmXmlAttribute;
  I : SmallInt;

  function NodeToString(ANode: TGmXmlNode) : ANSIString;
  var
    ICount: integer;
  begin
    if ANode.IsLeafNode then
      Result := Format('<%s>%s</%s>', [ANode.Name, ANode.AsString, ANode.Name])
    else
    begin
      Result := '<' + ANode.Name + '>';
      for ICount := 0 to ANode.Children.Count-1 do
        Result := Result + NodeToString (ANode.Children.Node[ICount]);
      Result := Result + '</' + ANode.Name + '>';
    end;
  end;

Begin // Configure
  // Keep local handle to the Plug-In wrapper object
  FPluginInfo := PluginInfo;

  // Default to active.
  FPluginInfo.dpActive := True;

  if (oConfigXML <> nil) then
  begin
    // Extract the Display configuration attributes
    oXMLAttr := oConfigXML.Attributes.ElementByName['height'];
    FDisplayHeight := StrToIntDef(oXMLAttr.Value, 100);

    // Extract the XML configuration settings and store locally for later use by the plug-in
    If (oConfigXML.Children.Count > 0) Then
    Begin
      For I := 0 To (oConfigXML.Children.Count - 1) Do
      Begin
        FConfigSettings := FConfigSettings + NodeToString(oConfigXML.Children.Node[I]);
        if (Lowercase(oConfigXML.Children.Node[I].Name) = 'active') then
          FPluginInfo.dpActive := oConfigXML.Children.Node[I].AsBoolean;
      End; // For I
    End; // If Assigned(oXMLNode)
  end
  else
    FDisplayHeight := 100;
End; // Configure
*)
// -----------------------------------------------------------------------------

procedure TKPIDataHost.Configure(PluginInfo: TKPIPluginInfo; Configuration: ANSIString);

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

var
  XML: TgmXML;
  StyleNode: TgmXMLNode;
const
  DefaultLabelStyle =
    '     <LabelStyle>' + #13#10 +
    '       <Caption></Caption>' + #13#10 +
    '       <Font>Tahoma</Font>' + #13#10 +
    '       <FontSize>8</FontSize>' + #13#10 +
    '       <FontColor>0</FontColor>' + #13#10 +
    '       <Bold>1</Bold>' + #13#10 +
    '       <Italic>0</Italic>' + #13#10 +
    '       <BackColor>-2147483633</BackColor>' + #13#10 +
    '     </LabelStyle>';
begin
  // Keep local handle to the Plug-In wrapper object
  FPluginInfo := PluginInfo;

  // Default to active.
  FPluginInfo.dpActive := True;

  { Extract the Label Style details from the configuration, and store them. }
  XML := TgmXML.Create(nil);
  try
    XML.Text := Configuration;
    StyleNode := XML.Nodes.NodeByName['LabelStyle'];
    if (StyleNode = nil) then
    begin
      XML.Text := DefaultLabelStyle;
      StyleNode := XML.Nodes.NodeByName['LabelStyle'];
    end;
    LabelStyle.DefaultCaption := FPluginInfo.dpCaption;
    LabelStyle.Caption := ReadElement(StyleNode, 'Caption');
    if (LabelStyle.Caption = '') then
      LabelStyle.Caption := FPluginInfo.dpCaption;
    LabelStyle.FontName := ReadElement(StyleNode, 'Font');
    LabelStyle.FontSize := StrToIntDef(ReadElement(StyleNode, 'FontSize'), 8);
    LabelStyle.FontColor := StrToIntDef(ReadElement(StyleNode, 'FontColor'), 0);
    if (StrToIntDef(ReadElement(StyleNode, 'Bold'), 0) = 1) then
      LabelStyle.FontStyle := LabelStyle.FontStyle + [fsBold];
    if (StrToIntDef(ReadElement(StyleNode, 'Italic'), 0) = 1) then
      LabelStyle.FontStyle := LabelStyle.FontStyle + [fsItalic];
    LabelStyle.BackColor := StrToIntDef(ReadElement(StyleNode, 'BackColor'), 13421772);
  finally
    XML.Free;
  end;

  // Install the configuration details (these should be an XML fragment,
  // and contain information that needs to be passed to the plug-in, such
  // as the Company id).
  FConfigSettings := Configuration;
end;

// -----------------------------------------------------------------------------

// Called by the KPIManager singleton to connect the KPIDataHost to the SectionHost
procedure TKPIDataHost.ConnectToHost(Host : TKPIHostControl);
begin
//  ShowMessage ('TKPIDataHost.ConnectToSectionHost');

  // Create a new Display control within the SectionHost
  case FPluginInfo.dpDisplayType of
    dtDataList: begin
                   FDisplay := Host.NewDataPanel(self);
                   FDisplay.OnConfigure := ConfigurePlugin;
                   FDisplay.OnConfigureInterval := ConfigureInterval;
                   FDisplay.OnConfigureLabel := ConfigureLabel;
                   FDisplay.OnDrillDown := DrillDown;
                   FDisplay.OnLogin := Login;
                   FDisplay.OnRemove := RemovePlugin;
                   FDisplay.OnAddColumn := KPIManager.IncrementAreas;
                   FDisplay.OnRemoveColumn := KPIManager.DecrementAreas;
                   FDisplay.OnShowBorders := KPIManager.ShowBorders;
                   FDisplay.IncludeBorders := KPIManager.LayoutManager.ShowBorders;
                   FDisplay.OnRefresh := PushData;
                   FDisplay.Height := Height;
                end; // dtDataList
    dtChart: begin
               FDisplay := Host.NewChartPanel(self);
               FDisplay.OnConfigure := ConfigurePlugin;
               FDisplay.OnConfigureInterval := ConfigureInterval;
               FDisplay.OnConfigureLabel := ConfigureLabel;
               FDisplay.OnDrillDown := DrillDown;
               FDisplay.OnLogin := Login;
               FDisplay.OnRemove := RemovePlugin;
               FDisplay.OnAddColumn := KPIManager.IncrementAreas;
               FDisplay.OnRemoveColumn := KPIManager.DecrementAreas;
               FDisplay.OnShowBorders := KPIManager.ShowBorders;
               FDisplay.IncludeBorders := KPIManager.LayoutManager.ShowBorders;
               FDisplay.OnRefresh := PushData;
               FDisplay.Height := Height;
             end; // dtChart
  else
    raise Exception.Create('TKPIDataHost.ConnectToSectionHost: Unknown Display Type (' + IntToStr(Ord(FPluginInfo.dpDisplayType)) + ')');
  end; // Case FPluginInfo.dpDisplayType

  UpdateLabel;

  // Check authentication so the data can be reloaded
  PushData;
end;

// -----------------------------------------------------------------------------

// Called by the KPIManager singleton to disconnect the KPIDataHost from the SectionHost
procedure TKPIDataHost.DisconnectFromHost;
Begin
//  ShowMessage ('TKPIDataHost.DisconnectFromSectionHost');
  if (FDisplay <> nil) then
  begin
    FDisplay.DisconnectFromHost;
    FDisplay.Free;
    FDisplay := NIL;
  end;
End;

// -----------------------------------------------------------------------------

// Creates a plug-in instance and pushes the column info and data down into the
// Display control for display.
procedure TKPIDataHost.PushData;
Var
  PluginStatus : Byte;
Begin // PushData
  if KPIManager.ExclusiveOpInProgress then EXIT; // v.006 BJH
  if (FDisplay = nil) or (FDisplay.DisplayPhase = dpUpdating) then
    Exit;
  try

    PluginStatus := CreatePlugin;
    Try
      KPIManager.ExclusiveOpInProgress := true; // v.006 BJH

      FPlugin.dpMessageID := FInstanceId; // v.004 BJH

      FPlugin.CheckIDPFile(FPluginInfo.dpInfoFile);

      FDisplay.Caption := CaptionWithoutExtension(LabelStyle.Caption) + GetExtension(FPlugin.dpCaption);

      FStatus := FPlugin.dpStatus;

      If (FPlugin.dpStatus = psConfigError) Then
      Begin
        // Configuration Error - Configuration Required
        FDisplay.DisplayPhase := dpConfigError;
      End // If (FPlugin.dpStatus = psConfigError)
      Else If (FPlugin.dpStatus = psAuthenticationError) Then
      Begin
        // Authentication Error - Check for previous successful logins
        FDisplay.DisplayPhase := dpLogin;
        CheckLogin(FPluginInfo.dpAuthenticationId);
      End // If (FPlugin.dpStatus = psAuthenticationError)
      Else If (FPlugin.dpStatus = psReady) Then
      Begin
        // Ready - Load Data
        if Running then
          FDisplay.DisplayPhase := dpUpdating
        else
          FDisplay.DisplayPhase := dpLoading;
        FStatus := FPlugin.dpStatus;

        If Supports(FPlugin, IDataListPlugin) Then
        Begin
//          if not Running then
          FDisplay.ConfigureDisplay((FPlugin As IDataListPlugin).dlpColumns);
          FDisplay.LoadData((FPlugin As IDataListPlugin).GetData);
        End
        else if Supports(FPlugin, IChartPlugin) then
        begin
          FDisplay.LoadData((FPlugin As IChartPlugin).GetData);
        end;

        if (Interval > 0) then
        begin
          NextUpdate := Interval;
          Running := True;
        end;
        FDisplay.DisplayPhase := dpDisplay;
      End; // If (FPlugin.dpStatus = psReady)
      FConfigSettings := FPlugin.dpConfiguration;
      FStatus := FPlugin.dpStatus;
    Finally
      DestroyPlugin (PluginStatus);
      KPIManager.ExclusiveOpInProgress := false; // v.006 BJH
    End; // Try..Finally
  except
    on E:Exception do
    begin
      if (FDisplay = nil) then
      begin
        { Error was probably triggered because the user closed Outlook while
          the KPI system was initialising or resetting. Ignore it. }
      end
      else
        { Re-raise }
        raise;
    end;
  end;
End; // PushData

// -----------------------------------------------------------------------------

procedure TKPIDataHost.ConfigureInterval;
var
  Dlg: TKPIUpdateIntervalDlg;
  PluginStatus : Byte;
begin
  PluginStatus := CreatePlugin;
  Dlg := TKPIUpdateIntervalDlg.Create(nil);
  try
    Dlg.Interval := FInterval;
    Dlg.ShowModal;
    if (Dlg.ModalResult = mrOk) then
    begin
      FInterval := Dlg.Interval;
      KPIManager.SaveConfiguration;
    end;
  finally
    Dlg.Free;
    DestroyPlugin (PluginStatus);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.ConfigurePlugin;
Var
  PluginStatus : Byte;
  AuthPluginInfo: TKPIAuthenticationPluginInfo;
Begin // ConfigurePlugin
  if KPIManager.ExclusiveOpInProgress then EXIT; // v.006 BJH
  PluginStatus := CreatePlugin;
  Try
    KPIManager.ExclusiveOpInProgress := true; // v.006 BJH

    { Locate the authentication plug-in info, and retrieve the AuthenticationState
      so that is can be passed to the plug-in. }
    AuthPluginInfo := KPIManager.AuthenticationPlugins[FPluginInfo.dpAuthenticationID];
    FPlugin.Authenticate(AuthPluginInfo.apAuthenticationState);

    FPlugin.CheckIDPFile(FPluginInfo.dpInfoFile); // v.006 BJH  Tell the plugin controller which plugin is to be configured
    FPlugin.dpMessageID := FInstanceId;           // v.006 BJH

    If FPlugin.Configure(KPIManager.HostHandle) Then
    Begin
      // Download the changed configuration and refresh the plug-in
      FConfigSettings := FPlugin.dpConfiguration;
      FPlugin.dpConfiguration := fConfigSettings;
//      FPluginInfo.dpConfiguration := FConfigSettings;
      KPIManager.SaveConfiguration;
      KPIManager.ExclusiveOpInProgress := false; // v.006 BJH
      PushData;
    End; // If FPlugin.Configure
  Finally
    DestroyPlugin (PluginStatus);
    KPIManager.ExclusiveOpInProgress := false; // v.006 BJH
  End; // Try..Finally
End; // ConfigurePlugin

// -----------------------------------------------------------------------------

procedure TKPIDataHost.ConfigureLabel;
var
  Dlg: TKPIConfigLabelForm;
begin
  if KPIManager.ExclusiveOpInProgress then
    Exit;
  KPIManager.ExclusiveOpInProgress := True;
  Dlg := TKPIConfigLabelForm.Create(nil);
  try
    Dlg.SetLabelStyle(LabelStyle);
    Dlg.ShowModal;
    if (Dlg.ModalResult = mrOk) then
    begin
      Dlg.GetLabelStyle(LabelStyle);
      KPIManager.SaveConfiguration;
      UpdateLabel;
    end;
  finally
    Dlg.Free;
    KPIManager.ExclusiveOpInProgress := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.UpdateLabel;
var
  PluginStatus: Byte;
begin
  { Use the Label Style details to update the display of the newly-created panel and label. }
  FDisplay.CaptionPanel.Color := LabelStyle.BackColor;
  FDisplay.CaptionLabel.Font.Name := LabelStyle.FontName;
  FDisplay.CaptionLabel.Font.Size := LabelStyle.FontSize;
  FDisplay.CaptionLabel.Font.Color := LabelStyle.FontColor;
  FDisplay.CaptionLabel.Font.Style := LabelStyle.FontStyle;

  FDisplay.CaptionLabel.Caption := LabelStyle.Caption;

  PluginStatus := CreatePlugin;
  try
    FDisplay.CaptionLabel.Caption := CaptionWithoutExtension(LabelStyle.Caption) + GetExtension(FPlugin.dpCaption);
  finally
    DestroyPlugin(PluginStatus);
  end;

  { In order to correctly get the height required by the font and size, we need
    to set the Canvas properties as well (I don't know why Delphi doesn't set
    these itself). }
  FDisplay.CaptionLabel.Canvas.Font.Name := LabelStyle.FontName;
  FDisplay.CaptionLabel.Canvas.Font.Size := LabelStyle.FontSize;
  FDisplay.CaptionLabel.Canvas.Font.Color := LabelStyle.FontColor;
  FDisplay.CaptionLabel.Canvas.Font.Style := LabelStyle.FontStyle;
  FDisplay.CaptionLabel.Height := FDisplay.CaptionLabel.Canvas.TextHeight(FDisplay.CaptionLabel.Caption) + 2;
  FDisplay.CaptionPanel.Height := FDisplay.CaptionLabel.Canvas.TextHeight(FDisplay.CaptionLabel.Caption) + 2;

  FDisplay.ResizeHandler(nil);
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.DrillDown (Const UniqueId : ShortString);
Var
  PluginStatus : Byte;
Begin // DrillDown
  if KPIManager.ExclusiveOpInProgress then EXIT; // v.006 BJH
  PluginStatus := CreatePlugin;
  Try
    KPIManager.ExclusiveOpInProgress := true; // v.006 BJH

    FPlugin.CheckIDPFile(FPluginInfo.dpInfoFile); // v.006 BJH  Tell the plugin controller which plugin is to be configured
    FPlugin.dpMessageID := FInstanceId;           // v.006 BJH

    if FPlugin.DrillDown (KPIManager.HostHandle, KPIManager.MessageHandle, UniqueId) then begin
      KPIManager.ExclusiveOpInProgress := false; // v.006 BJH
      PushData;
    end;
  Finally
    DestroyPlugin (PluginStatus);
    KPIManager.ExclusiveOpInProgress := false; // v.006 BJH
  End; // Try..Finally
End; // DrillDown

// -----------------------------------------------------------------------------

// Called after a successful login to run through rechecking the logins for all plug-ins
// requiring the same authentication system
procedure TKPIDataHost.CheckLogin (Const AuthenticationId : ShortString; Force: Boolean);
Var
  oAuthHost: TKPIAuthenticationPluginInfo;
  AuthPluginStatus, DataPluginStatus : Byte;
  sAuth : WideString;
Begin // CheckLogin
  If (FPluginInfo.dpAuthenticationId = AuthenticationId) and
     ((FStatus = psAuthenticationError) or Force) Then
  Begin
    oAuthHost := KPIManager.AuthenticationPlugins[FPluginInfo.dpAuthenticationId];
    If Assigned(oAuthHost) Then
    Begin
      // In theory this will already exist as this method is triggered via the Login method below
      DataPluginStatus := CreatePlugin;
      Try
        // In theory this will already exist as this method is triggered via the Login method below
        AuthPluginStatus := oAuthHost.CreatePlugin;
        Try
          // Get the details from the Plug-In of the Authentication Request (format spec'd by Authentication Plug-In)
          sAuth := FPlugin.dpAuthenticationRequest;
          If oAuthHost.CheckLogin(sAuth) Then
          Begin
            // Success - Pass the authentication info into the Plug-in for processing
            FPlugin.Authenticate(sAuth);

            // Recheck the status of the Plug-In
            PushData;
          End; // If oAuthHost.CheckLogin(sAuth)
        Finally
          oAuthHost.DestroyPlugin(AuthPluginStatus);
        End; // Try..Finally
      Finally
        DestroyPlugin (DataPluginStatus);
      End; // Try..Finally
    End // If Assigned(oAuthHost)
  End; // If (FStatus = psAuthenticationError)
End; // CheckLogin

// -----------------------------------------------------------------------------

procedure TKPIDataHost.Login;
var
  oAuthHost: TKPIAuthenticationPluginInfo;
  sAuth : WideString;
  AuthPluginStatus, DataPluginStatus : Byte;
begin // Login
  DataPluginStatus := CreatePlugin;
  Try
    oAuthHost := KPIManager.AuthenticationPlugins[FPlugin.dpAuthenticationId];
    If Assigned(oAuthHost) Then
    Begin
      AuthPluginStatus := oAuthHost.CreatePlugin;
      Try
        // Get the details from the Plug-In of the Authentication Request (format spec'd by Authentication Plug-In)
        sAuth := FPlugin.dpAuthenticationRequest;
        If oAuthHost.Login(sAuth, KPIManager.HostHandle) Then
        Begin
          // Success - Pass the authentication info into the Plug-in for processing
          FPlugin.Authenticate(sAuth);

          // Recheck the status of the Plug-In
          PushData;

          // Update any other plug-ins with the same authentication service
          KPIManager.CheckLogins(FPlugin.dpAuthenticationId);
        End; // If oAuthHost.Login(sAuth)
      Finally
        oAuthHost.DestroyPlugin(AuthPluginStatus);
      End; // Try..Finally
    End // If Assigned(oAuthHost)
    Else
      MessageDlg('The Authentication Service could not be loaded, please contact your Technical Support.', mtError, [mbOK], 0);
  Finally
    DestroyPlugin (DataPluginStatus);
  End; // Try..Finally
End; // Login

// -----------------------------------------------------------------------------

procedure TKPIDataHost.ProcessMessage (var Message: TMessage);
{ Called when a message has been received from the plug-in - typically from a drill-down
  window displayed by the DrillDown event. }
begin
  ShowMessage (Format('TKPIDataHost.ProcessMessage(%s): %d', [FPluginInfo.dpPluginId, Message.wParam]));
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.Resize(Host: TKPIHostControl);
var
  W, X: Integer;
  Units: Double;
begin
  if (FDisplay <> nil) and (FPluginInfo <> nil) then
  begin
    Units := (Host.Width / 100);
    W := Trunc(Units * Width);
    X := Trunc(Units * Left);
    FDisplay.SetBounds(X, FDisplay.Top, W - (GetSystemMetrics(SM_CXVSCROLL) + 4), Height);  // LTWH
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.SetHeight(const Value: Integer);
begin
  FHeight := Value;
  if (FDisplay <> nil) then
    FDisplay.Height := FHeight;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.SetLeft(const Value: Integer);
begin
  FLeft := Value;
  if (FDisplay <> nil) then
    FDisplay.Left := FLeft;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.SetTop(const Value: Integer);
begin
  FTop := Value;
  if (FDisplay <> nil) then
    FDisplay.Top := FTop;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.SetWidth(const Value: Integer);
begin
  FWidth := Value;
  if (FDisplay <> nil) then
    FDisplay.Width := FWidth;
end;

// -----------------------------------------------------------------------------

function TKPIDataHost.GetHeight: Integer;
begin
  if (FDisplay <> nil) then
    Result := FDisplay.Height
  else
    Result := FHeight;
end;

// -----------------------------------------------------------------------------

function TKPIDataHost.GetLeft: Integer;
begin
  if (FDisplay <> nil) then
    Result := FDisplay.Left
  else
    Result := FLeft;
end;

// -----------------------------------------------------------------------------

function TKPIDataHost.GetTop: Integer;
begin
  if (FDisplay <> nil) then
    Result := FDisplay.Top
  else
    Result := FTop;
end;

// -----------------------------------------------------------------------------

function TKPIDataHost.GetWidth: Integer;
begin
  if (FDisplay <> nil) then
    Result := FDisplay.Width
  else
    Result := FWidth;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.Highlight(const Value: Boolean);
begin
  if Value then
  begin
//    FDisplay.Color := $00FFEEEE;
//    FDisplay.BevelInner := bvLowered;
//    FDisplay.BevelOuter := bvRaised;
  end
  else
  begin
//    FDisplay.Color := clWindow;
//    FDisplay.BevelInner := bvNone;
//    FDisplay.BevelOuter := bvNone;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.RemovePlugin(const ID: string;
  const InstanceID: Integer);
begin
  KPIManager.RemovePlugin(ID, InstanceID);
end;

// -----------------------------------------------------------------------------

procedure TKPIDataHost.ShowBorders(Show: Boolean);
begin
  if (FDisplay <> nil) then
  begin
    FDisplay.IncludeBorders := Show;
    FDisplay.Invalidate;
  end;
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
    Rect.Top := Rect.Bottom - 2;
    Bmp.Canvas.FillRect(Rect);

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

Initialization
  lInstanceId := TBits.Create;
  lInstanceId.Bits[lInstanceId.OpenBit] := True;  // Don't use zero as difficult to tell from not set!
Finalization
  lInstanceId.Free;
end.

