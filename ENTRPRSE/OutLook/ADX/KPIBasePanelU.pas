unit KPIBasePanelU;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Graphics, Controls, StdCtrls,
  ComCtrls, ExtCtrls, GmXML, Menus, KPIAvailablePluginsU;

type
  // ---------------------------------------------------------------------------

  TDisplayPhase = (dpBlank, dpConfigError, dpLogin, dpLoading, dpDisplay, dpUpdating);

  // ---------------------------------------------------------------------------

  TConfigureEvent = procedure of object;
  TRemoveEvent    = procedure(const ID: string; const InstanceID: Integer) of object;
  TShowBordersEvent = procedure(Show: Boolean) of object;
  TDrillDownEvent = procedure(const UniqueId : ShortString) of object;
  TLoginEvent     = procedure of object;
  TRefreshEvent   = procedure of object;

  // ---------------------------------------------------------------------------

  TKPIBasePanel = class(TCustomPanel)
  private
    FCaptionPanel: TPanel;
    FCaptionLabel: TLabel;
    FInfoLabel: TLabel;

    FDisplayPhase: TDisplayPhase;

    FOnConfigure: TConfigureEvent;
    FOnDrillDown: TDrillDownEvent;
    FOnLogin: TLoginEvent;

    FPluginInfo: TKPIPluginInfo;
    FInstanceID: Integer;
    FOnRemove: TRemoveEvent;

    FAddColumnMenuItem: TMenuItem;
    FRemoveColumnMenuItem: TMenuItem;
    FOnRemoveColumn: TNotifyEvent;
    FOnAddColumn: TNotifyEvent;
    FBordersMenuItem: TMenuItem;
    FIncludeBorders: Boolean;
    FOnShowBorders: TShowBordersEvent;
    FOnConfigureInterval: TConfigureEvent;
    FOnConfigureLabel: TConfigureEvent;
    FOnRefresh: TRefreshEvent;

    // -------------------------------------------------------------------------
    // Event handlers
    // -------------------------------------------------------------------------

    // Event Handler for 'Configure Plug-In' label and menu option
    procedure ConfigClick(Sender: TObject);
    // Event Handler for 'Configure Label' label and menu option
    procedure ConfigLabelClick(Sender: TObject);
    // Event Handler for 'Login' label and menu option
    procedure LoginClick(Sender: TObject);
    // Event Handler for 'Remove Plug-in' menu option
    procedure RemoveClick(Sender: TObject);
    // Event Handler for 'Add Column' menu option
    procedure AddColumnClick(Sender: TObject);
    // Event Handler for 'Remove Column' menu option
    procedure RemoveColumnClick(Sender: TObject);
    // Event Handler for 'Borders' menu option
    procedure BordersClick(Sender: TObject);
    // Event Handler for 'Update Interval' menu option
    procedure UpdateIntervalClick(Sender: TObject);
    // Event Handler for 'Update Now' menu option
    procedure UpdateNowClick(Sender: TObject);

  protected
    FMenu: TPopupMenu;

    procedure DisplayPhaseChanged; virtual;
    procedure OnPopup(Sender: TObject);
    procedure Paint; override;

    // -------------------------------------------------------------------------
    // Property Get/Set methods
    // -------------------------------------------------------------------------
    function GetCaption : ShortString;
    procedure SetCaption (Value : ShortString);
    procedure SetDisplayPhase (Value : TDisplayPhase);

  public
    property CaptionPanel: TPanel read FCaptionPanel;
    property CaptionLabel: TLabel read FCaptionLabel;
    property Caption : ShortString Read GetCaption Write SetCaption;
    property DisplayPhase : TDisplayPhase Read FDisplayPhase Write SetDisplayPhase;

    property OnConfigure : TConfigureEvent Read FOnConfigure Write FOnConfigure;
    property OnConfigureInterval: TConfigureEvent read FOnConfigureInterval write FOnConfigureInterval;
    property OnConfigureLabel : TConfigureEvent Read FOnConfigureLabel Write FOnConfigureLabel;
    property OnDrillDown : TDrillDownEvent Read FOnDrillDown Write FOnDrillDown;
    property OnLogin : TLoginEvent Read FOnLogin Write FOnLogin;
    property OnRemove: TRemoveEvent read FOnRemove write FOnRemove;
    property OnAddColumn: TNotifyEvent read FOnAddColumn write FOnAddColumn;
    property OnRemoveColumn: TNotifyEvent read FOnRemoveColumn write FOnRemoveColumn;
    property OnShowBorders: TShowBordersEvent read FOnShowBorders write FOnShowBorders;
    property OnRefresh: TRefreshEvent read FOnRefresh write FOnRefresh;

    property PluginInfo: TKPIPluginInfo read FPluginInfo;
    property InstanceID: Integer read FInstanceID;
    property IncludeBorders: Boolean read FIncludeBorders write FIncludeBorders;

    property BevelInner;
    property BevelOuter;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Color;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;

    // Called when the section is about to be destroyed. Use this instead of
    // the Destroy method for releasing resources.
    procedure DisconnectFromHost; virtual;

    // Called by TSectionHost immediately after the Base Section is created, to
    // allow further set-up to be done.
    procedure Initialise(PluginInfo: TKPIPlugInInfo; InstanceID: Integer); virtual;

    // Configures the section display based on the details supplied by the XML
    // string from the plug-in
    procedure ConfigureDisplay(const Details: ANSIString); virtual;

    // Loads the supplied XML data into the section.
    procedure LoadData(const Data : ANSIString); virtual;

    procedure ResizeHandler(Sender: TObject); virtual;
    
  published

  end;

implementation

uses Dialogs, KPIHostControlU, KPIUtils, KPIManagerU;

var
  SectionNo : LongInt = 1;

// =============================================================================
// TKPIBasePanel
// =============================================================================

procedure TKPIBasePanel.AddColumnClick(Sender: TObject);
begin
  if Assigned(FOnAddColumn) then
    OnAddColumn(self);
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.BordersClick(Sender: TObject);
begin
  if Assigned(FOnShowBorders) then
    OnShowBorders(FBordersMenuItem.Checked);
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.ConfigClick(Sender: TObject);
{ Event Handler for 'Configure Plug-In' label and menu option. }
begin
  if Assigned(FOnConfigure) then
    FOnConfigure;
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.ConfigLabelClick(Sender: TObject);
begin
  if Assigned(FOnConfigureLabel) then
    FOnConfigureLabel;
end;

procedure TKPIBasePanel.ConfigureDisplay(const Details: ANSIString);
begin

end;

// -----------------------------------------------------------------------------

constructor TKPIBasePanel.Create(AOwner: TComponent);
begin // Create
  inherited Create(AOwner);

  FDisplayPhase := dpBlank;

  //Name := 'TKPIBasePanel' + IntToStr(SectionNo);
  Inc(SectionNo);

  // Set up the Panel itself
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BorderStyle := bsNone;
  self.Caption := '';

  Color := clWindow;

  // Set up the Caption Bar
  FCaptionPanel := TPanel.Create(Self);
  with FCaptionPanel do
  begin
    Parent := Self;
    Name := 'panCaptionBar' + IntToStr(SectionNo);

    SetBounds(0, 0, 100, 17);
    Align := alTop;

    Alignment := taLeftJustify;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    Caption := '';

    with Font do
    begin
      Name := 'Tahoma';
      Size := 8;
      Style := [fsBold];
    end;
  end; // With FCaptionPanel

  // Set up the label in the Caption Bar (to get the indented effect)
  FCaptionLabel := TLabel.Create(Self);
  With FCaptionLabel Do
  Begin
    Parent := FCaptionPanel;
    Name := 'lblCaption' + IntToStr(SectionNo);

    SetBounds(9, 0, Self.Width-9, 13);   // LTWH
    AutoSize := False;
    Caption := '';
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Name := 'Tahoma';
    Font.Size := 8;
    Font.Style := [fsBold];
    ParentFont := False;

    { The caption label is used for dragging the whole panel }
    Cursor := crSizeAll;
    DragMode := dmAutomatic;

  End; // With FCaptionLabel

  OnResize    := ResizeHandler;

  FIncludeBorders := False;

{$IFDEF KPI_DEBUG}
  KPIManager.Log(FCaptionLabel.Name + ' created');
{$ENDIF KPI_DEBUG}
End; // Create

// -----------------------------------------------------------------------------

destructor TKPIBasePanel.Destroy;
begin
{$IFDEF KPI_DEBUG}
  KPIManager.Log(FCaptionPanel.Name + ' destroyed');
{$ENDIF KPI_DEBUG}
  inherited Destroy;
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.DisconnectFromHost;
begin

end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.DisplayPhaseChanged;
begin

end;

// -----------------------------------------------------------------------------

function TKPIBasePanel.GetCaption : ShortString;
begin
  Result := FCaptionLabel.Caption;
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.Initialise(PluginInfo: TKPIPluginInfo; InstanceID: Integer);
var
  MenuItem: TMenuItem;
begin
  FPluginInfo := PluginInfo;
  FInstanceID := InstanceID;

  FMenu := TPopupMenu.Create(self);

  if PlugInInfo.dpSupportsConfiguration then
  begin
    MenuItem := TMenuItem.Create(self);
    MenuItem.Caption := 'Configure...';
    MenuItem.OnClick := ConfigClick;
    FMenu.Items.Add(MenuItem);
  end;

  MenuItem := TMenuItem.Create(self);
  MenuItem.Caption := 'Configure label...';
  MenuItem.OnClick := ConfigLabelClick;
  FMenu.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(self);
  MenuItem.Caption := 'Update interval...';
  MenuItem.OnClick := UpdateIntervalClick;
  FMenu.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(self);
  MenuItem.Caption := 'Update now';
  MenuItem.OnClick := UpdateNowClick;
  FMenu.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(self);
  MenuItem.Caption := 'Remove control';
  MenuItem.OnClick := RemoveClick;
  FMenu.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(self);
  MenuItem.Caption := '-';
  FMenu.Items.Add(MenuItem);

  FAddColumnMenuItem := TMenuItem.Create(self);
  FAddColumnMenuItem.Caption := 'Add column';
  FAddColumnMenuItem.OnClick := AddColumnClick;
  FMenu.Items.Add(FAddColumnMenuItem);

  FRemoveColumnMenuItem := TMenuItem.Create(self);
  FRemoveColumnMenuItem.Caption := 'Remove column';
  FRemoveColumnMenuItem.OnClick := RemoveColumnClick;
  FMenu.Items.Add(FRemoveColumnMenuItem);

  MenuItem := TMenuItem.Create(self);
  MenuItem.Caption := '-';
  FMenu.Items.Add(MenuItem);

  FBordersMenuItem := TMenuItem.Create(self);
  FBordersMenuItem.Caption := 'Borders';
  FBordersMenuItem.AutoCheck := True;
  FBordersMenuItem.OnClick := BordersClick;
  FMenu.Items.Add(FBordersMenuItem);

  MenuItem := TMenuItem.Create(self);
  MenuItem.Caption := '-';
  FMenu.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(self);
  MenuItem.Caption := 'Cancel';
  FMenu.Items.Add(MenuItem);

  FMenu.OnPopup := OnPopup;

  PopupMenu := FMenu;
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.LoadData(const Data: ANSIString);
begin

end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.LoginClick(Sender: TObject);
{ Event Handler for 'Login' label and menu option. }
begin
  if Assigned(FOnLogin) then
    FOnLogin;
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.OnPopup(Sender: TObject);
begin
  FAddColumnMenuItem.Enabled    := KPIManager.ActiveAreas.Count < 3;
  FRemoveColumnMenuItem.Enabled := KPIManager.ActiveAreas.Count > 1;
  FBordersMenuItem.Checked      := KPIManager.LayoutManager.ShowBorders;
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.Paint;
var
  Rect: TRect;
begin
  inherited;
  Rect := GetClientRect;
  if FIncludeBorders then
  begin
    Canvas.Pen.Color := clBtnFace;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := 1;
    Canvas.Rectangle(Rect);
  end
  else
  begin
    Canvas.Pen.Color := clBtnFace;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := 2;
    Canvas.MoveTo(Rect.Left, Rect.Bottom);
    Canvas.LineTo(Rect.Right, Rect.Bottom);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.RemoveClick(Sender: TObject);
begin
  if Assigned(FOnRemove) then
    OnRemove(PluginInfo.dpPluginId, InstanceID);
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.RemoveColumnClick(Sender: TObject);
begin
  if Assigned(FOnRemoveColumn) then
    OnRemoveColumn(self);
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.ResizeHandler(Sender: TObject);
begin
  FCaptionLabel.Width := FCaptionPanel.Width - (2 * FCaptionLabel.Left);

  If Assigned(FInfoLabel) Then
  begin
    FInfoLabel.Top := CaptionPanel.Top + CaptionPanel.Height + 2;
    FInfoLabel.Width := Self.Width - (2 * FInfoLabel.Left);
  end;

end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.SetCaption (Value : ShortString);
begin
  FCaptionLabel.Caption := Value;
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.SetDisplayPhase (Value : TDisplayPhase);
begin
  If (Value <> FDisplayPhase) Then
  Begin
    FDisplayPhase := Value;

    // Create any needed controls
    If (Not Assigned(FInfoLabel)) Then
    Begin
      FInfoLabel := TLabel.Create(Self);
      With FInfoLabel Do
      Begin
        Parent := Self;
        Name := 'lblInfoLink';

        SetBounds(9, CaptionPanel.Top + CaptionPanel.Height + 2, Self.Width-18, 13);   // LTWH

//        SetBounds(9, 19, Self.Width-18, 13);   // LTWH
        AutoSize := False;
        Cursor := crHandPoint;
        Caption := 'Configure';
        Font.Charset := DEFAULT_CHARSET;
        Font.Color := clWindowText;
        Font.Name := 'Tahoma';
        Font.Size := 8;
        Font.Style := [fsBold, fsUnderline];
        ParentFont := False;
        Visible := False;
      End; // With FInfoLabel
    End; // If (Not Assigned(FInfoLabel))

    If Assigned(FInfoLabel) Then FInfoLabel.Visible := (FDisplayPhase In [dpConfigError, dpLogin, dpUpdating]); // v.006 BJH added dpUpdating

    // Configure the controls
    Case FDisplayPhase Of
      dpBlank       : Begin
                          FInfoLabel.Visible := False;
                      End; // dpBlank
      dpConfigError : Begin
                          FInfoLabel.Caption := 'Configure';
                          FInfoLabel.OnClick := ConfigClick;
                          FInfoLabel.Visible := True;
                      End; // dpConfigError
      dpLogin       : Begin
                          FInfoLabel.Caption := 'Login';
                          FInfoLabel.OnClick := LoginClick;
                          FInfoLabel.Visible := True;
                      End; // dpLogin
      dpLoading     : Begin
                          FInfoLabel.Caption := 'Loading Data, Please Wait...';
                          FInfoLabel.OnClick := NIL;
                          FInfoLabel.Visible := True;
                      End; // dpLoading
      dpUpdating    : Begin // v.006 BJH
                          FInfoLabel.Caption := 'Updating Data, Please Wait...';
                          FInfoLabel.OnClick := NIL;
                          FInfoLabel.Visible := true;
                      End;
      dpDisplay{, dpUpdating}     :              // v.006 BJH allow the 'Updating...' message to the user
                      Begin
                          FInfoLabel.Visible := False;
                      End; // dpDisplay
    End; // Case FDisplayPhase

    DisplayPhaseChanged;

    ResizeHandler(self);

    Refresh;
  End; // If (Value <> FDisplayPhase)
End; // SetDisplayPhase

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.UpdateIntervalClick(Sender: TObject);
begin
  if Assigned(FOnConfigureInterval) then
    OnConfigureInterval;
end;

// -----------------------------------------------------------------------------

procedure TKPIBasePanel.UpdateNowClick(Sender: TObject);
begin
  if Assigned(FOnRefresh) then
    OnRefresh;
end;

end.
