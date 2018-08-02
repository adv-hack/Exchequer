unit ControlTreeF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, StdCtrls, DesignerTypes, ExtCtrls, Menus, ImgList,
  ctrlDrag, Region, EnterToTab, EntWindowSettings;

type
  TfrmControlsTree = class(TForm)
    vtvRegionControls: TVirtualStringTree;
    pnlButtons: TPanel;
    ScrollBox1: TScrollBox;
    btnClose: TButton;
    btnBringToFront: TButton;
    btnSendToBack: TButton;
    btnRangeFilter: TButton;
    btnSelectionCriteria: TButton;
    btnPrintIf: TButton;
    btnProperties: TButton;
    btnFont: TButton;
    btnDeleteRestore: TButton;
    btnShowHide: TButton;
    btnDeleteRegion: TButton;
    pnlControl: TPanel;
    pnlName: TPanel;
    pnlDBField: TPanel;
    pnlStatusField: TPanel;
    RegionMenu: TPopupMenu;
    Hide1: TMenuItem;
    Delete2: TMenuItem;
    ilRegionIcons: TImageList;
    pnlRF: TPanel;
    pnlSEL: TPanel;
    pnlIF: TPanel;
    btnShowHideControl: TButton;
    EnterToTab1: TEnterToTab;
    PMenu_Main: TPopupMenu;
    MenItem_SaveCoordinates: TMenuItem;
    MenItem_SaveCoordinates2: TMenuItem;
    N1: TMenuItem;
    MenItem_ResetToDefault2: TMenuItem;
    MenItem_ResetToDefault: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure vtvRegionControlsInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure vtvRegionControlsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vtvRegionControlsFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vtvRegionControlsInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vtvRegionControlsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSendToBackClick(Sender: TObject);
    procedure btnBringToFrontClick(Sender: TObject);
    procedure btnRangeFilterClick(Sender: TObject);
    procedure btnSelectionCriteriaClick(Sender: TObject);
    procedure btnPrintIfClick(Sender: TObject);
    procedure btnPropertiesClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnDeleteRestoreClick(Sender: TObject);
    procedure btnShowHideClick(Sender: TObject);
    procedure vtvRegionControlsPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure vtvRegionControlsBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure vtvRegionControlsGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure vtvRegionControlsGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vtvRegionControlsDblClick(Sender: TObject);
    procedure btnShowHideControlClick(Sender: TObject);
    procedure btnDeleteRegionClick(Sender: TObject);
    procedure MenItem_SaveCoordinatesClick(Sender: TObject);
    procedure MenItem_ResetToDefaultClick(Sender: TObject);
    private
    { Private declarations }
    FDesignerWindow : TForm;
    FMinSizeX, FMinSizeY : LongInt;
    FRegionManager : IRegionManager;
    FRegionsList : TList;
    FOnSaveReport: TNotifyEvent;
    FRegion: TRegion;
    FControl: TBaseDragControl;
    FControlsPopup: TPopupMenu;
    FControlsPopupItems : Array [TControlContextItems] Of TMenuItem;
    FSettings : IWindowSettings;
    FSaveCoords, useDefaults : boolean;
    procedure HideButtons;
    procedure ShowRegionButtons;
    procedure UpdateRegionButtons;
    procedure ShowControlButtons;
    procedure UpdateControlButtons;
    procedure BuildPopupControlsMenu;
    function PreparePopupControlsMenu: Boolean;
    procedure PreparePopupRegionMenu;
    procedure SetDesignerWindow (Value : TForm);
    procedure SetRegionManager (Value : IRegionManager);
    // Control the minimum size that the form can resize to - works better than constraints
    procedure WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    procedure SetRegion(const Value: TRegion);
    procedure SetControl(const Value: TBaseDragControl);
    procedure SaveCoordinates;
    procedure LoadCoordinates;
  public
    { Public declarations }
    Property DesignerWindow : TForm Read FDesignerWindow Write SetDesignerWindow;
    Property RegionManager : IRegionManager Read FRegionManager Write SetRegionManager;
    Property RegionsList : TList Read FRegionsList Write FRegionsList;
    property Region: TRegion read FRegion write SetRegion;
    property Control: TBaseDragControl read FControl write SetControl;
    property OnSaveReport: TNotifyEvent read FOnSaveReport write FOnSaveReport;
  end;


implementation

{$R *.dfm}

Uses GlobalTypes, frmVRWRangeFilterDetailsU, VRWReportIF,
  DesignerUtil, StrUtils,
  ctrlText,              // TVRWTextControl
  ctrlImage,             // TVRWImageControl
  ctrlBox,               // TVRWBoxControl
  ctrlDBField,           // TVRWDBFieldControl
  ctrlFormula,           // TVRWFormulaControl
  ctrlTextPropertiesF,   // Text Properties dailog
  ctrlImagePropertiesF,  // Image Properties dialog
  ctrlBoxPropertiesF,    // Box Properties dialog
  ctrlDBFieldProperties, // DB Field Properties dialog
  ctrlFormulaProperties; // Formula Properties / Print If dialog


Type
  TControlsTreeNodeType = (tntReport, tntRegion, tntControl);

  TControlsTreeNode = Class(TObject)
  Private
    FRegion : TRegion;
    FRegionManager : IRegionManager;
    FControl : TBaseDragControl;
    Function GetNodeType : TControlsTreeNodeType;
  Public
    Property ctnRegion : TRegion Read FRegion;
    Property ctnRegionManager : IRegionManager Read FRegionManager;
    Property ctnControl : TBaseDragControl Read FControl;
    Property ctnNodeType : TControlsTreeNodeType Read GetNodeType;

    Constructor Create (RegionManager : IRegionManager; Region : TRegion; Control : TBaseDragControl);
    Destructor Destroy; Override;
  End; // TControlsTreeNode

  pControlsTreeNode = ^TControlsTreeNode;
  {

  }
const
  COL_CONTROL = 0;
  COL_NAME    = 1;
  COL_FIELD   = 2;
  COL_RF      = 3;
  COL_SEL     = 4;
  COL_IF      = 5;
  COL_STATUS  = 6;

//=========================================================================

Constructor TControlsTreeNode.Create (RegionManager : IRegionManager; Region : TRegion; Control : TBaseDragControl);
Begin // Create
  Inherited Create;
  FRegion := Region;
  FRegionManager := RegionManager;
  FControl := Control;
End; // Create

//------------------------------

Destructor TControlsTreeNode.Destroy;
Begin // Destroy
  FRegion := NIL;
  FControl := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TControlsTreeNode.GetNodeType : TControlsTreeNodeType;
Begin // GetNodeType
  If Assigned(FControl) Then
    Result := tntControl
  Else If Assigned(FRegion) Then
    Result := tntRegion
  Else
    Result := tntReport;
End; // GetNodeType

//=========================================================================

procedure TfrmControlsTree.FormCreate(Sender: TObject);
begin
  Height := 312;
  Width := 790;

  FMinSizeX := Width;
  FMinSizeY := Height;

  LoadCoordinates;

  btnShowHide.Top := btnBringToFront.Top;
  btnShowHide.Visible := False;
  btnDeleteRegion.Top := btnSendToBack.Top;
  btnDeleteRegion.Visible := False;

  FControlsPopup := TPopupMenu.Create(nil);
  BuildPopupControlsMenu;
  HideButtons;

  pnlStatusField.Width := (vtvRegionControls.Width - pnlStatusField.Left);
end;

//------------------------------

procedure TfrmControlsTree.FormDestroy(Sender: TObject);
begin
  SaveCoordinates;
  FSettings := nil;
  FControlsPopup.Free;
end;

procedure TfrmControlsTree.SaveCoordinates;
begin
  //TW 09/08/2011: Main Size/position save method.
  if FSaveCoords then
  begin
    FSettings.WindowToSettings(Self);
    FSettings.SaveSettings(true);
    MenItem_SaveCoordinates.Checked := false;
  end;
end;

procedure TfrmControlsTree.LoadCoordinates();
begin
  //TW 09/08/2011: Loads window size/position
  FSettings := GetWindowSettings(Self.Name);
  MenItem_SaveCoordinates.Enabled := true;
  MenItem_ResetToDefault.Enabled := true;
  FSaveCoords := false;

  if Assigned(FSettings) then
  begin
   FSettings.LoadSettings;

   if not FSettings.UseDefaults then
   begin
     //If the user saves the size/position after the form has been maximised
     //the windowstate is changed to prevent the next load from being maximised.
     if self.WindowState = wsMaximized then
       self.WindowState := wsNormal;

     //Settings are loaded after the window state change otherwise the window will
     //be set to the previous un-maximised size/position.
     FSettings.SettingsToWindow(self);
     MenItem_ResetToDefault.Enabled := true;
   end
   else
     useDefaults := true;
  end
end;

//-------------------------------------------------------------------------

// Control the minimum size that the form can resize to - works better than constraints
Procedure TfrmControlsTree.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
var
  WorkArea: TRect;
Begin // WMGetMinMaxInfo
  If (FMinSizeX > 0) Then
  Begin
    Message.MinMaxInfo^.ptMinTrackSize.X := FMinSizeX;
    Message.MinMaxInfo^.ptMinTrackSize.Y := FMinSizeY;
    SystemParametersInfo(SPI_GETWORKAREA, 0, @WorkArea, 0);
    Message.MinMaxInfo^.ptMaxTrackSize.Y := WorkArea.Bottom;
    Message.Result:=0;
  End; // If (FMinSizeX > 0)

  Inherited;
End; // WMGetMinMaxInfo

//------------------------------

procedure TfrmControlsTree.FormResize(Sender: TObject);
begin
  pnlButtons.Left := ClientWidth - pnlButtons.Width - 5;
  pnlButtons.Height := ClientHeight - 8;

  vtvRegionControls.Height := pnlButtons.Height - pnlControl.Height - 3;
  vtvRegionControls.Width := pnlButtons.Left - vtvRegionControls.Left - 5;

  pnlStatusField.Left := (vtvRegionControls.Width - pnlStatusField.Width) +
                         vtvRegionControls.Left ;
  pnlIF.Left := pnlStatusField.Left - (pnlIF.Width + 3);
  pnlSEL.Left := pnlIF.Left - (pnlSEL.Width + 3);
  pnlRF.Left := pnlSEL.Left - (pnlRF.Width + 3);

  pnlDBField.Width := (pnlRF.Left - pnlDBField.Left) - 3;

  vtvRegionControls.Header.Columns[2].Width := pnlDBField.Width;
end;

//-------------------------------------------------------------------------

// Called everytime a node is created - usually when it becomes visible within the tree
procedure TfrmControlsTree.vtvRegionControlsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
                                                     var InitialStates: TVirtualNodeInitStates);
Var
  ParentData, ThisData : pControlsTreeNode;
begin
  // Get untyped pointer to node data
  ThisData := Sender.GetNodeData(Node);
  If (ParentNode = Nil) Then
  begin
    // Root Report Item
    ThisData^ := TControlsTreeNode.Create(FRegionManager, NIL, NIL);
    Include(InitialStates, ivsHasChildren);
    Include(InitialStates, ivsExpanded);
  End // If (ParentNode = Nil)
  Else
  Begin
    // Region or Control - get parent data to determine
    ParentData := Sender.GetNodeData(ParentNode);
    Case ParentData.ctnNodeType Of
      tntReport : Begin
                    // Parent is report - therefore we are adding a Region
                    ThisData^ := TControlsTreeNode.Create(ParentData.ctnRegionManager, FRegionsList[Node.Index], NIL);
                    Include(InitialStates, ivsHasChildren);
//                    Include(InitialStates, ivsExpanded);
                  End; // tntReport

      tntRegion : Begin
                    // Parent is Region - therefore we are adding a Control
                    ThisData^ := TControlsTreeNode.Create(ParentData.ctnRegionManager, ParentData.ctnRegion, ParentData.ctnRegion.reRegionControls[Node.Index]);
                  End; // tntRegion
    End; // Case ThisData.ctnNodeType
  End; // Else
end;

//------------------------------

// Called for the items added by InitNode that have children
procedure TfrmControlsTree.vtvRegionControlsInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
Var
  Data : pControlsTreeNode;
begin
  Data := Sender.GetNodeData(Node);
  Case Data.ctnNodeType Of
    tntReport   : ChildCount := FRegionsList.Count;

    tntRegion   : ChildCount := Data.ctnRegion.reRegionControls.Count;

    tntControl  : ChildCount := 0;
  End; // Case ThisData.ctnNodeType
end;

//------------------------------

procedure TfrmControlsTree.vtvRegionControlsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
Var
  Data : pControlsTreeNode;
begin
  Data := Sender.GetNodeData(Node);
  FreeAndNIL(Data^);
end;

//------------------------------

// Called to return the text for each cell
procedure TfrmControlsTree.vtvRegionControlsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
                                                    TextType: TVSTTextType; var CellText: WideString);
Var
  ThisData : pControlsTreeNode;
  VRWControl: IVRWControl;
  SortOrder: ShortString;
begin
  // Blank text otherwise it defaults to 'Node'!
  CellText := '';

  ThisData := Sender.GetNodeData(Node);
  Case ThisData.ctnNodeType Of
    tntReport:
      begin
        case Column Of
          COL_CONTROL:
            CellText := 'Report';
          COL_NAME:
            CellText := ThisData.FRegionManager.rmReport.vrName;
          COL_FIELD:
            CellText := ExtractFileName(ThisData.FRegionManager.rmReport.vrFilename);
        end; // Case Column
      end; // tntReport
    tntRegion:
      begin
        case Column Of
          COL_CONTROL:
            CellText := ThisData.ctnRegion.reDescription;
          COL_NAME:
            CellText := '';
          COL_FIELD:
            CellText := '';
          COL_STATUS:
            if not ThisData.FRegion.Visible then
              CellText := '[HIDE]'
            else
              CellText := '';
        end; // Case Column
      end; // tntRegion
    tntControl  :
      begin
        VRWControl := ThisData.ctnControl.ControlDets;
        case Column Of
          COL_CONTROL:
            if Supports(VRWControl, IVRWTextControl) then
              CellText := VRWControl.vcCaption
            else
              CellText := VRWControl.vcName;
          COL_NAME:
            if Supports(VRWControl, IVRWFormulaControl) then
              CellText := (VRWControl as IVRWFormulaControl).vcFormulaName
            else
              CellText := '';
          COL_FIELD:
            if Supports(VRWControl, IVRWFieldControl) then
              CellText := (VRWControl as IVRWFieldControl).vcFieldName
            else if Supports(VRWControl, IVRWFormulaControl) then
              CellText := (VRWControl as IVRWFormulaControl).vcFormulaDefinition
            else
              CellText := '';
          COL_RF:
            if Supports(VRWControl, IVRWFieldControl) then
              CellText := IfThen(ThisData.ctnControl.RangeFilter, 'RF', '');
          COL_SEL:
            if Supports(VRWControl, IVRWFieldControl) then
              CellText := IfThen(ThisData.ctnControl.SelectionCriteria, 'SEL', '');
          COL_IF:
            if Supports(VRWControl, IVRWFieldControl) then
              CellText := IfThen(ThisData.ctnControl.PrintIf, 'IF', '');
          COL_STATUS:
            if (not ThisData.ctnControl.Visible) then
              CellText := '[DELETED]'
            else if (ThisData.ctnControl is TVRWDBFieldControl) then
            begin
              if not TVRWDBFieldControl(ThisData.ctnControl).dbfPrintOnReport then
                CellText := '[HIDE]';
              SortOrder := (TVRWDBFieldControl(ThisData.ctnControl).ControlDets as IVRWFieldControl).vcSortOrder;
              if (SortOrder <> '') then
                CellText := CellText + '[SORT ' + SortOrder[Length(SortOrder)] + ']' ;
            end;
        end; // Case Column
      end; // tntControl
  End; // Case ThisData.ctnNodeType
end;

//------------------------------

procedure TfrmControlsTree.vtvRegionControlsFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
Var
  ThisData : pControlsTreeNode;
begin
  if Node <> nil then
  begin
    ThisData := Sender.GetNodeData(Node);
    Case ThisData.ctnNodeType Of
      tntReport   :
        begin
          HideButtons;
        end;

      tntRegion   :
        begin
          ShowRegionButtons;
          UpdateRegionButtons;
        end;

      tntControl  :
        begin
          if ThisData.ctnControl.Visible and
             ThisData.ctnControl.CanFocus then
          begin
            ThisData.ctnRegionManager.SelectControl (ThisData.ctnControl, False, True);
          end; // If ThisData.ctnControl.Visible And ThisData.ctnControl.CanFocus
          ShowControlButtons;
          UpdateControlButtons;
        end;
    end; // Case ThisData.ctnNodeType
  end; // if Node <> nil...
end;

//-------------------------------------------------------------------------

Procedure TfrmControlsTree.SetRegionManager (Value : IRegionManager);
Begin // SetRegionManager
  FRegionManager := Value;

  // Initialise the TreeView containing the items
  vtvRegionControls.NodeDataSize := SizeOf(Pointer);
  vtvRegionControls.RootNodeCount := 1;

  // MH 17/10/2016 2017-R1 ABSEXCH-17754: New colour scheme for VRW
  pnlButtons.Color      := FRegionManager.rmBannerColor;

  pnlControl.Color      := FRegionManager.rmBannerColor;
  pnlControl.Font.Color := FRegionManager.rmBannerFont.Color;

  pnlName.Color         := FRegionManager.rmBannerColor;
  pnlName.Font.Color    := FRegionManager.rmBannerFont.Color;

  pnlDBField.Color      := FRegionManager.rmBannerColor;
  pnlDBField.Font.Color := FRegionManager.rmBannerFont.Color;

  pnlRF.Color           := FRegionManager.rmBannerColor;
  pnlRF.Font.Color      := FRegionManager.rmBannerFont.Color;

  pnlSEL.Color          := FRegionManager.rmBannerColor;
  pnlSEL.Font.Color     := FRegionManager.rmBannerFont.Color;

  pnlIF.Color           := FRegionManager.rmBannerColor;
  pnlIF.Font.Color      := FRegionManager.rmBannerFont.Color;

  pnlStatusField.Color      := FRegionManager.rmBannerColor;
  pnlStatusField.Font.Color := FRegionManager.rmBannerFont.Color;
End; // SetRegionManager

//------------------------------

Procedure TfrmControlsTree.SetDesignerWindow (Value : TForm);
Begin // SetDesignerWindow
  //TW 09/08/2011: If window has no saved state then center the window to parent window.
  if useDefaults then
  begin
   FDesignerWindow := Value;

   // Centre over designer window
   Left := FDesignerWindow.Left + ((FDesignerWindow.Width - Self.Width) Div 2);
   Top := FDesignerWindow.Top + ((FDesignerWindow.Height - Self.Height) Div 2);
  end;
End; // SetDesignerWindow

//-------------------------------------------------------------------------

procedure TfrmControlsTree.HideButtons;
begin
  btnBringToFront.Visible      := False;
  btnSendToBack.Visible        := False;
  btnRangeFilter.Visible       := False;
  btnSelectionCriteria.Visible := False;
  btnPrintIf.Visible           := False;
  btnShowHideControl.Visible   := False;
  btnProperties.Visible        := False;
  btnFont.Visible              := False;
  btnDeleteRestore.Visible     := False;
  btnShowHide.Visible          := False;
  btnDeleteRegion.Visible      := False;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.ShowControlButtons;
begin
  HideButtons;
  btnBringToFront.Visible      := True;
  btnSendToBack.Visible        := True;
  btnRangeFilter.Visible       := True;
  btnSelectionCriteria.Visible := True;
  btnPrintIf.Visible           := True;
  btnShowHideControl.Visible   := True;
  btnProperties.Visible        := True;
  btnFont.Visible              := True;
  btnDeleteRestore.Visible     := True;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.ShowRegionButtons;
begin
  HideButtons;
  btnShowHide.Visible          := True;
  btnDeleteRegion.Visible      := True;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnSaveClick(Sender: TObject);
begin
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnSendToBackClick(Sender: TObject);
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  ThisData := vtvRegionControls.GetNodeData(Node);
  if (ThisData <> nil) then
    ThisData.ctnControl.SendToBack;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnBringToFrontClick(Sender: TObject);
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  ThisData := vtvRegionControls.GetNodeData(Node);
  if (ThisData <> nil) then
    ThisData.ctnControl.BringToFront;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnRangeFilterClick(Sender: TObject);
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  ThisData := vtvRegionControls.GetNodeData(Node);
  if DisplayRangeFilter(IVRWFieldControl(ThisData.ctnControl.ControlDets)) then
  begin
    RegionManager.ChangeMade;
    vtvRegionControls.InvalidateNode(Node);
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnSelectionCriteriaClick(Sender: TObject);
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  ThisData := vtvRegionControls.GetNodeData(Node);
  if DisplaySelectionCriterion(TVRWDBFieldControl(ThisData.ctnControl)) then
  begin
    RegionManager.ChangeMade;
    vtvRegionControls.InvalidateNode(Node);
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnPrintIfClick(Sender: TObject);
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  ThisData := vtvRegionControls.GetNodeData(Node);
  if DisplayPrintIfOptions(ThisData.ctnControl) then
  begin
    RegionManager.ChangeMade;
    vtvRegionControls.InvalidateNode(Node);
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnPropertiesClick(Sender: TObject);
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  if (Node <> nil) then
  begin
    ThisData := vtvRegionControls.GetNodeData(Node);
    RegionManager.DisplayControlOptions(ThisData.ctnControl, self);
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnFontClick(Sender: TObject);
Var
  FontDialog : TFontDialog;
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  ThisData := vtvRegionControls.GetNodeData(Node);

  FontDialog := TFontDialog.Create(nil);
  With FontDialog Do
  begin
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -11;
    Font.Name := 'MS Sans Serif';
    Font.Style := [];
    MinFontSize := 0;
    MaxFontSize := 0;
    Options := [fdEffects, fdForceFontExist];
  End; // With FontDialog

  CopyIFontToFont(ThisData.ctnControl.ControlDets.vcFont, FontDialog.Font);

  If FontDialog.Execute Then
  Begin
    ThisData.ctnControl.UpdateFont(FontDialog.Font);
    RegionManager.ChangeMade;
  End; // If FontDialog.Execute
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnDeleteRestoreClick(Sender: TObject);
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  ThisData := vtvRegionControls.GetNodeData(Node);
  if ThisData.ctnControl.Visible then
    ThisData.ctnControl.Delete
  else
    ThisData.ctnControl.Restore;
  RegionManager.ChangeMade;
  vtvRegionControls.InvalidateNode(Node);
  UpdateControlButtons;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.UpdateControlButtons;
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
  MenuItemSet : TControlContextItemsSet;
  Control: TBaseDragControl;
begin
  Node := vtvRegionControls.FocusedNode;
  if (Node <> nil) then
  begin
    ThisData := vtvRegionControls.GetNodeData(Node);
    Control := ThisData.FControl;
    if (Control <> nil) then
    begin
      // Load the set of default menu items for the control
      if Control.ControlDets.vcDeleted then
        MenuItemSet := [cciDelete]
      else
        MenuItemSet := [cciDelete, cciSendToBack, cciBringToFront,
                        cciRangeFilter, cciSelectionCriteria, cciPrintIf,
                        cciPrintOnReport, cciFont, cciProperties];

      Control.DisableContextItems(MenuItemSet);

      if ThisData.ctnControl.Visible then
        btnDeleteRestore.Caption := '&Delete'
      else
        btnDeleteRestore.Caption := 'Res&tore';

      btnBringToFront.Enabled      := (cciBringToFront in MenuItemSet);
      btnSendToBack.Enabled        := (cciSendToBack in MenuItemSet);
      btnRangeFilter.Enabled       := (cciRangeFilter in MenuItemSet);
      btnSelectionCriteria.Enabled := (cciSelectionCriteria in MenuItemSet);
      btnPrintIf.Enabled           := (cciPrintIf in MenuItemSet);
      btnShowHideControl.Enabled   := (cciPrintOnReport in MenuItemSet);
      btnFont.Enabled              := (cciFont in MenuItemSet);
      btnProperties.Enabled        := (cciProperties in MenuItemSet);

      FControlsPopupItems[cciRangeFilter].Enabled       := btnRangeFilter.Enabled;
      FControlsPopupItems[cciSelectionCriteria].Enabled := btnSelectionCriteria.Enabled;
      FControlsPopupItems[cciPrintIf].Enabled           := btnPrintIf.Enabled;

      if Supports(ThisData.ctnControl.ControlDets, IVRWFieldControl) then
      begin
        if TVRWDBFieldControl(ThisData.ctnControl).dbfPrintOnReport then
        begin
          btnShowHideControl.Caption := '&Hide';
          btnShowHideControl.Hint := 'Hide|Hide this control';
        end
        else
        begin
          btnShowHideControl.Caption := 'S&how';
          btnShowHideControl.Hint := 'Show|Show this control';
        end;
      end;

    end; // if (Control <> nil)...
  end; // if (Node <> nil)...
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnShowHideClick(Sender: TObject);
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  ThisData := vtvRegionControls.GetNodeData(Node);
  ThisData.FRegion.Visible := not ThisData.FRegion.Visible;
  FRegionManager.ChangeMade;
  FRegionManager.RealignRegions;
  vtvRegionControls.Invalidate;
  UpdateRegionButtons;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.UpdateRegionButtons;
var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.FocusedNode;
  ThisData := vtvRegionControls.GetNodeData(Node);
  if ThisData.FRegion.Visible then
    btnShowHide.Caption := '&Hide'
  else
    btnShowHide.Caption := 'S&how';
  Hide1.Caption := btnShowHide.Caption;
  if ThisData.FRegion.reRegionDets.rgType in [rtSectionHdr, rtSectionFtr] then
    btnDeleteRegion.Enabled := True
  else
    btnDeleteRegion.Enabled := False;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.vtvRegionControlsPaintText(
  Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  ThisData : pControlsTreeNode;
begin
  ThisData := vtvRegionControls.GetNodeData(Node);
  if ThisData.ctnRegion <> nil then
    if (not ThisData.ctnRegion.Visible) then
      TargetCanvas.Font.Color := clGrayText;
  if ThisData.ctnControl <> nil then
    if not ThisData.ctnControl.Visible then
      TargetCanvas.Font.Color := clRed
    else if (ThisData.ctnControl is TVRWDBFieldControl) then
    begin
      if not TVRWDBFieldControl(ThisData.ctnControl).dbfPrintOnReport then
        TargetCanvas.Font.Color := clGrayText;
    end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.vtvRegionControlsBeforeItemErase(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var ItemColor: TColor;
  var EraseAction: TItemEraseAction);
var
  ThisData : pControlsTreeNode;
begin
  ThisData := vtvRegionControls.GetNodeData(Node);
  if ThisData.ctnRegion <> nil then
    if not ThisData.ctnRegion.Visible then
    begin
//      ItemColor := clSilver;
//      EraseAction := eaColor;
    end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.vtvRegionControlsGetPopupMenu(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  const P: TPoint; var AskParent: Boolean; var PopupMenu: TPopupMenu);
Var
  ThisData : pControlsTreeNode;
begin
  ThisData := Sender.GetNodeData(Node);
  if (ThisData <> nil) then
  begin
    case ThisData.ctnNodeType of
      tntReport: ;
      tntRegion:
        begin
          PreparePopupRegionMenu;
          PopupMenu := RegionMenu;
        end;
      tntControl:
        begin
          if PreparePopupControlsMenu then
            PopupMenu := FControlsPopup
          else
            PopupMenu := nil;
        end;
       else
       begin
         PopupMenu := PMenu_Main;
       end
    end;
  end
  else
    PopupMenu := PMenu_Main;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.vtvRegionControlsGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  ThisData : pControlsTreeNode;
  ItemIndex: SmallInt;
  RegionType: TRegionType;
const
  RegionImageXRef: array[TRegionType] of SmallInt = (-1, 0, 1, 2, 3, 4, 5, 6);
begin
  if (Column = 0) then
  begin
    ThisData := Sender.GetNodeData(Node);
    if (ThisData.ctnNodeType = tntRegion) then
    begin
      RegionType := ThisData.ctnRegion.reRegionDets.rgType;
      ItemIndex := RegionImageXRef[RegionType];
      if ItemIndex <> -1 then
        ImageIndex := ItemIndex;
    end;
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.SetRegion(const Value: TRegion);
var
  Node: PVirtualNode;
  ThisData : pControlsTreeNode;
begin
  FRegion := Value;
  Node := vtvRegionControls.GetFirst;
  while (Node <> nil) do
  begin
    ThisData := vtvRegionControls.GetNodeData(Node);
    if (ThisData.ctnRegion = Value) then
    begin
      vtvRegionControls.Expanded[Node] := True;
      vtvRegionControls.Selected[Node] := True;
      vtvRegionControls.FocusedNode := Node;
      ShowRegionButtons;
      UpdateRegionButtons;
      Break;
    end;
    Node := vtvRegionControls.GetNext(Node);
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.SetControl(const Value: TBaseDragControl);
var
  Node: PVirtualNode;
  ThisData : pControlsTreeNode;
begin
  FControl := Value;
  Node := vtvRegionControls.GetFirst;
  while (Node <> nil) do
  begin
    ThisData := vtvRegionControls.GetNodeData(Node);
    if (ThisData.ctnControl = Value) then
    begin
      vtvRegionControls.Expanded[Node.Parent] := True;
      vtvRegionControls.Selected[Node] := True;
      vtvRegionControls.FocusedNode := Node;
      if ThisData.ctnControl.Visible and
         ThisData.ctnControl.CanFocus then
      begin
        ThisData.ctnRegionManager.SelectControl (ThisData.ctnControl, False, True);
      end; // If ThisData.ctnControl.Visible And ThisData.ctnControl.CanFocus
      ShowControlButtons;
      UpdateControlButtons;
      Break;
    end;
    Node := vtvRegionControls.GetNext(Node);
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.vtvRegionControlsDblClick(Sender: TObject);
begin
  if (btnProperties.Visible) and (btnProperties.Enabled) then
    btnPropertiesClick(Sender);
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnShowHideControlClick(Sender: TObject);
var
  Node: PVirtualNode;
  ThisData : pControlsTreeNode;
begin
  Node := vtvRegionControls.FocusedNode;
  if (Node <> nil) then
  begin
    ThisData := vtvRegionControls.GetNodeData(Node);
    if (ThisData.ctnControl is TVRWDBFieldControl) then
    begin
      TVRWDBFieldControl(ThisData.ctnControl).dbfPrintOnReport :=
       not TVRWDBFieldControl(ThisData.ctnControl).dbfPrintOnReport;
//      PrintonReport1.Checked := TVRWDBFieldControl(ThisData.ctnControl).dbfPrintOnReport;
      RegionManager.ChangeMade;
      vtvRegionControls.InvalidateNode(Node);
      UpdateControlButtons;
    end;
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmControlsTree.btnDeleteRegionClick(Sender: TObject);

  procedure DeleteSectionNode(SectionName: string);
  { Finds and deletes the node and the attached report region matching the
    specified section name. }
  var
    SearchNode, FoundNode: PVirtualNode;
    SearchData, FoundData: PControlsTreeNode;
  begin
    { Locate the node }
    FoundNode := nil;
    FoundData := nil;
    SearchNode := vtvRegionControls.GetFirst;
    SearchNode := vtvRegionControls.GetFirstChild(SearchNode);
    while (SearchNode <> nil) do
    begin
      SearchData := vtvRegionControls.GetNodeData(SearchNode);
      if (SearchData.ctnRegion <> nil) and
         (SearchData.ctnRegion.reRegionDets.rgName = SectionName) then
      begin
        FoundNode := SearchNode;
        FoundData := SearchData;
        Break;
      end;
      { Get the next section node }
      SearchNode := vtvRegionControls.GetNextSibling(SearchNode);
    end;
    { Delete the region and node }
    if (FoundNode <> nil) then
    begin
      FRegionManager.DeleteRegion(FoundData.ctnRegion);
      vtvRegionControls.DeleteChildren(FoundNode);
      vtvRegionControls.DeleteNode(FoundNode);
    end;
  end;

var
  Node: PVirtualNode;
  HeaderName, FooterName: string;
  ThisData : pControlsTreeNode;
  Response: Word;
begin
  Response :=
    MessageDlg('Deleting a section will delete both the section header ' +
               'and the section footer, and cannot be undone. Are you ' +
               'sure you want to do this?',
               mtWarning,
               mbOkCancel,
               0);
  if Response = mrOk then
  begin
    Node := vtvRegionControls.FocusedNode;
    if (Node <> nil) then
    begin
      ThisData := vtvRegionControls.GetNodeData(Node);
      { Determine the names of the header and footer sections }
      HeaderName := SECTION_HEADER_NAME + IntToStr(ThisData.ctnRegion.reRegionDets.rgSectionNumber);
      FooterName := SECTION_FOOTER_NAME + IntToStr(ThisData.ctnRegion.reRegionDets.rgSectionNumber);
      { Locate the nodes for the header and footer,  and delete them }
      DeleteSectionNode(HeaderName);
      DeleteSectionNode(FooterName);
      { Renumber the remaining sections }
      FRegionManager.rmReport.vrRegions.Renumber;
    end;
  end;
end;

procedure TfrmControlsTree.BuildPopupControlsMenu;
begin
  { TODO: BuildPopupControlsMenu }
  with FControlsPopup do
  begin
    Items.Clear;
    Name := 'popControls';

    FControlsPopupItems[cciSendToBack] := TVRWMenuItem.Create(FControlsPopup, Name + '_SendToBack', 'Send To Back', btnSendToBackClick);
    Items.Add(FControlsPopupItems[cciSendToBack]);

    FControlsPopupItems[cciBringToFront] := TVRWMenuItem.Create(FControlsPopup, Name + '_BringToFront', 'Bring To Front', btnBringToFrontClick);
    Items.Add(FControlsPopupItems[cciBringToFront]);

    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep1', '-'));

    FControlsPopupItems[cciRangeFilter] := TVRWMenuItem.Create(FControlsPopup, Name + '_RangeFilter', 'Range Filter', btnRangeFilterClick);
    Items.Add(FControlsPopupItems[cciRangeFilter]);

    FControlsPopupItems[cciSelectionCriteria] := TVRWMenuItem.Create(FControlsPopup, Name + '_SelectionCriteria', 'Selection Criteria', btnSelectionCriteriaClick);
    Items.Add(FControlsPopupItems[cciSelectionCriteria]);

    FControlsPopupItems[cciPrintIf] := TVRWMenuItem.Create(FControlsPopup, Name + '_PrintIf', 'Print If', btnPrintIfClick);
    Items.Add(FControlsPopupItems[cciPrintIf]);

    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep2', '-'));

    FControlsPopupItems[cciPrintOnReport] := TVRWMenuItem.Create(FControlsPopup, Name + '_PrintOnReport', 'Print On Report', btnShowHideControlClick);
    Items.Add(FControlsPopupItems[cciPrintOnReport]);

    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep3', '-'));

    FControlsPopupItems[cciProperties] := TVRWMenuItem.Create(FControlsPopup, Name + '_Properties', 'Properties', btnPropertiesClick);
    Items.Add(FControlsPopupItems[cciProperties]);

    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep4', '-'));

    FControlsPopupItems[cciFont] := TVRWMenuItem.Create(FControlsPopup, Name + '_Font', 'Font', btnFontClick);
    Items.Add(FControlsPopupItems[cciFont]);

    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep5', '-'));

    FControlsPopupItems[cciDelete] := TVRWMenuItem.Create(FControlsPopup, Name + '_Delete', 'Delete', btnDeleteRestoreClick);
    Items.Add(FControlsPopupItems[cciDelete]);

  end;
end;

function TfrmControlsTree.PreparePopupControlsMenu: Boolean;
var
  MenuItemSet : TControlContextItemsSet;
  Node: PVirtualNode;
  ThisData : pControlsTreeNode;
  Control: TBaseDragControl;
begin
  Result := True;
  Node := vtvRegionControls.FocusedNode;
  if (Node <> nil) then
  begin
    ThisData := vtvRegionControls.GetNodeData(Node);
    Control := ThisData.FControl;
    if (Control <> nil) then
    Begin
      // Load the set of default menu items for a single control
      MenuItemSet := [cciDelete, cciSendToBack, cciBringToFront,
                      cciRangeFilter, cciSelectionCriteria, cciPrintIf,
                      cciPrintOnReport, cciFont, cciProperties];

      Control.DisableContextItems(MenuItemSet);

      FControlsPopupItems[cciDelete].Caption := btnDeleteRestore.Caption;

      // Print On Report
      If (cciPrintOnReport In MenuItemSet) Then
      Begin
        If (Control Is TVRWDBFieldControl) Then
        Begin
          FControlsPopupItems[cciPrintOnReport].Checked := TVRWDBFieldControl(Control).dbfPrintOnReport;
        End // If (TControl(FSelectedControls[I]) Is TVRWDBFieldControl)
        Else If (Control Is TVRWFormulaControl) Then
        Begin
          FControlsPopupItems[cciPrintOnReport].Checked := TVRWFormulaControl(Control).fmlPrintOnReport;
        End; // If (TControl(FSelectedControls[I]) Is TVRWFormulaControl))
      End; // If (cciPrintOnReport In MenuItemSet) And ((...

      // Sorting
      If (cciSortingSubMenu In MenuItemSet) And (Control Is TVRWDBFieldControl) Then
      Begin
        With TVRWDBFieldControl(Control).DBFieldDets Do
        Begin
          If (Length(vcSortOrder) >= 2) And (vcSortOrder[1] In ['0'..'9']) And (vcSortOrder[2] In ['A', 'D']) Then
          Begin
            FControlsPopupItems[cciSortAsc].Checked := (vcSortOrder[2] = 'A');
            FControlsPopupItems[cciSortDesc].Checked := (vcSortOrder[2] = 'D');
          End // If (Length(vcSortOrder) >= 2) And (vcSortOrder[1] In ['0'..'9']) And (vcSortOrder[2] In ['A', 'D'])
          Else
          Begin
            FControlsPopupItems[cciSortAsc].Checked := False;
            FControlsPopupItems[cciSortDesc].Checked := False;
          End; // Else

          FControlsPopupItems[cciNoSorting].Checked := (Not FControlsPopupItems[cciSortAsc].Checked) And (Not FControlsPopupItems[cciSortDesc].Checked);
          FControlsPopupItems[cciPageBreak].Enabled := FControlsPopupItems[cciSortAsc].Checked Or FControlsPopupItems[cciSortDesc].Checked;

          If FControlsPopupItems[cciPageBreak].Enabled Then
          Begin
            FControlsPopupItems[cciPageBreak].Checked := vcPageBreak;
          End // If FControlsPopupItems[cciPageBreak].Enabled
          Else
            FControlsPopupItems[cciPageBreak].Checked := False;
        End; // With TVRWDBFieldControl(FSelectedControls[I]).DBFieldDets
      End; // If (cciSortingSubMenu In MenuItemSet) And (TControl(FSelectedControls[I]) Is TVRWDBFieldControl)

      // Enable the menu items based on what remains in the set
      FControlsPopupItems[cciDelete].Visible := (cciDelete In MenuItemSet);
      FControlsPopupItems[cciSendToBack].Visible := (cciSendToBack In MenuItemSet);
      FControlsPopupItems[cciBringToFront].Visible := (cciBringToFront In MenuItemSet);
      FControlsPopupItems[cciRangeFilter].Visible := (cciRangeFilter In MenuItemSet);
      FControlsPopupItems[cciSelectionCriteria].Visible := (cciSelectionCriteria In MenuItemSet);
      FControlsPopupItems[cciPrintIf].Visible := (cciPrintIf In MenuItemSet);
      FControlsPopupItems[cciPrintOnReport].Visible := (cciPrintOnReport In MenuItemSet);
      FControlsPopupItems[cciFont].Visible := (cciFont In MenuItemSet);
      FControlsPopupItems[cciProperties].Visible := (cciProperties In MenuItemSet);
    end // If (FSelectedControls.Count > 0)
    else
      Result := False;
  end;
end;

procedure TfrmControlsTree.PreparePopupRegionMenu;
Var
  ThisData : pControlsTreeNode;
  Node: PVirtualNode;
begin
  Node := vtvRegionControls.HotNode;
  if (Node = nil) then
    Node := vtvRegionControls.FocusedNode;
  if (Node <> nil) then
  begin
    ThisData := vtvRegionControls.GetNodeData(Node);
    Delete2.Enabled := (ThisData.FRegion.reRegionDets.rgSectionNumber <> 0);
  end;
end;

procedure TfrmControlsTree.MenItem_SaveCoordinatesClick(Sender: TObject);
begin
 FSaveCoords := not FSaveCoords;

 MenItem_SaveCoordinates2.Checked := FSaveCoords;
 MenItem_SaveCoordinates.Checked := FSaveCoords;
end;


procedure TfrmControlsTree.MenItem_ResetToDefaultClick(Sender: TObject);
begin
 FSettings.DeleteWindowSettings;

 MenItem_SaveCoordinates.Checked := false;
 MenItem_SaveCoordinates2.Checked := false;
 MenItem_SaveCoordinates.Enabled := false;
 MenItem_SaveCoordinates2.Enabled := false;
 
 MenItem_ResetToDefault.Enabled := false;
 MenItem_ResetToDefault2.Enabled := false;
 FSaveCoords := false;

 MessageBox(0, PChar('Default settings will be applied next time you open this window.'),
  'Information', +mb_OK + MB_ICONASTERISK);
end;
end.


