unit KPIChartPanelU;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Graphics, Controls, StdCtrls,
  ComCtrls, ExtCtrls, GmXML, Menus, KPIBasePanelU, Chart, Series;

type
  // ---------------------------------------------------------------------------

  TKPIChartPanel = class(TKPIBasePanel)
  private
    FChart: TChart;
    FSeries: TBarSeries;

    // -------------------------------------------------------------------------
    // Chart handling
    // -------------------------------------------------------------------------
    procedure ClearChart;
    procedure AddSeries(oSeries: TgmXMLNode);
    procedure AddPoint(oPoint: TgmXMLNode);

  protected
    procedure DisplayPhaseChanged; override;

    // -------------------------------------------------------------------------
    // Event handlers
    // -------------------------------------------------------------------------
    procedure ResizeHandler(Sender: TObject); override;

  public

    destructor Destroy; override;

    procedure ConfigureDisplay(const Details: ANSIString); override;

    // Configures the chart based on the data supplied by the XML string from
    // the plug-in
    procedure LoadData(const Data : ANSIString); override;

  end;

var
  DebugList : TListBox;

Procedure DebugMessage (Const DebugStr : ShortString);

implementation

uses Dialogs, KPIHostControlU;

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

// =============================================================================
// TKPIChartPanel
// =============================================================================

destructor TKPIChartPanel.Destroy;
begin
  if Assigned(FChart) then
    FreeAndNil(FChart);
  inherited;
end;

procedure TKPIChartPanel.ResizeHandler(Sender: TObject);
begin
  inherited;
  { TODO: Chart-specific resizing }
  if Assigned(FChart) then
  begin
    with FChart do
    begin
      Top := CaptionPanel.Top + CaptionPanel.Height;
      Left := CaptionPanel.Left;
      Width := self.Width;
      Height := self.Height - CaptionPanel.Height - 5;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIChartPanel.LoadData(const Data: ANSIString);
var
  oXMLData: TGmXML;
  oDataNode, oSeries, oPoint: TGmXMLNode;
  iSeries, iPoint: SmallInt;
begin
  inherited;
  // Remove any existing data from the chart
  ClearChart;
  // Run through the XML loading up the list
  oXMLData := TGmXML.Create(nil);
  try
    oXMLData.Text := Data;
    oDataNode     := oXMLData.Nodes.NodeByName['data'];
    if Assigned(oDataNode) then
    begin
      // Copy the data into the chart
      for iSeries := 0 to (oDataNode.Children.Count - 1) do
      begin
        // Start a new series
        oSeries := oDataNode.Children.Node[iSeries];
        AddSeries(oSeries);
        // Add all the values for the series
        for iPoint := 0 to (oSeries.Children.Count - 1) do
        begin
          oPoint := oSeries.Children.Node[iPoint];
          AddPoint(oPoint);

          Application.ProcessMessages;
        end;
      end;
    end;
  finally
    oXMLData.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIChartPanel.DisplayPhaseChanged;
var
  MenuItem: TMenuItem;
begin
  inherited;

  if not Assigned(FMenu) then
  begin
    FMenu := TPopupMenu.Create(self);
    MenuItem := TMenuItem.Create(self);
    MenuItem.Caption := 'Configure';
    FMenu.Items.Add(MenuItem);

    MenuItem := TMenuItem.Create(self);
    MenuItem.Caption := '-';
    FMenu.Items.Add(MenuItem);

    MenuItem := TMenuItem.Create(self);
    MenuItem.Caption := 'Cancel';
    FMenu.Items.Add(MenuItem);
  end;

  if not Assigned(FChart) then
  begin
    FChart := TChart.Create(self);
    InsertControl(FChart);
    With FChart Do
    Begin
      Name := 'chart';
      Visible := False;
//      OnDblClick := DataListDblClick;
      PopupMenu := FMenu;
    End;
  end;

  // Hide any non-required controls
  If Assigned(FChart) Then FChart.Visible := (DisplayPhase in [dpDisplay, dpUpdating]);

  // Configure the controls
  Case DisplayPhase Of
    dpLoading     : Begin
                        FChart.Visible := False;
                      End; // dsdpLoading
    dpDisplay, dpUpdating     :
                    Begin
                        FChart.Visible := True;
                      End; // dsdpDisplay
  End; // Case FDisplayPhase

end;

// -----------------------------------------------------------------------------

procedure TKPIChartPanel.ConfigureDisplay(const Details: ANSIString);
begin
  inherited;
  { TODO: ConfigureDisplay }
end;

// -----------------------------------------------------------------------------

procedure TKPIChartPanel.AddSeries(oSeries: TgmXMLNode);
var
  Series: TBarSeries;
begin
  Series := TBarSeries.Create(self);
  with Series do
  begin
    ParentChart := FChart;
  end;
  FSeries := Series;
end;

// -----------------------------------------------------------------------------

procedure TKPIChartPanel.AddPoint(oPoint: TgmXMLNode);
var
  ValueNode: TgmXMLNode;
  Value: Double;
begin
  ValueNode := oPoint.Children.NodeByName['value'];
  if (ValueNode <> nil) then
  begin
    Value := StrToFloatDef(ValueNode.AsString, 0);
    FSeries.AddBar(Value, '', clRed);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIChartPanel.ClearChart;
begin
  FChart.SeriesList.Clear;
end;

// -----------------------------------------------------------------------------

end.
