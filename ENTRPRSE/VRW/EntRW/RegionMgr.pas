unit RegionMgr;

interface

Uses Classes, Controls, Dialogs, Forms, StdCtrls, SysUtils, Windows, Graphics, ExtCtrls, Menus,
     DesignerTypes,   // Common designer types and interfaces
     VRWReportIF, frmVRWRangeFilterDetailsU, VRWPaperSizesIF
     ;

Function NewRegionManager (ParentForm : TForm; ScrollBox : TScrollBox; RegionImages : TImageList) : IRegionManager;

implementation

Uses IniFiles, StrUtils,
     RpDefine,
     RptEngDll,             // RepEngine.Dll declarations
     Region,                // TRegion
     DesignerUtil,
     ctrlDrag,              // TBaseDragControl
     ctrlText,              // TVRWTextControl
     ctrlImage,             // TVRWImageControl
     ctrlBox,               // TVRWBoxControl
     ctrlDBField,           // TVRWDBFieldControl
     ctrlFormula,           // TVRWFormulaControl
     ctrlTextPropertiesF,   // Text Properties dailog
     ctrlImagePropertiesF,  // Image Properties dialog
     ctrlBoxPropertiesF,    // Box Properties dialog
     ctrlDBFieldProperties, // DB Field Properties dialog
     ctrlFormulaProperties, // Formula Properties / Print If dialog
     ControlTreeF,          // Control Tree window
     GlobalTypes,           // VRW Constants / Types
     GlobVar, VarConst,
     frmVRWAlignU,
     frmVRWSizeU
     ;

Type
  TRegionManager = Class(TInterfacedObject, IRegionManager, IRegionManager2)
  Private
    // Private variable to store the type of control to be created
    FAddControl : TDesignerControlTypes;

    // Font to use on the Region Banners
    FBannerFont : TFont;

    // Color to use for banner background
    FBannerColor : TColor;

    // Records whether any changes have been made to the report
    FChangeMade : Boolean;

    // Popup menu used by the draggable controls at runtime
    FControlsPopup : TPopupMenu;
    FControlsPopupItems : Array [TControlContextItems] Of TMenuItem;

    // Default font for new reports
    FReportFont : TFont;

    // Flag to indicate whether the user wants to see the grid
    FShowGrid : Boolean;
    // Dimensions of the grid
    FGridSizeXmm : Byte;
    FGridSizeYmm : Byte;

    FOnUpdateControlInfo : TDisplayControlInfo;
    FOnUpdateCursorPosition : TRegionDisplayPosition;

    // Paper code identifies the currently selected paper size
    FPaperCode: ShortString;

    // Paper Size holds the height and width (in mm) of the currently selected
    // paper
    FPaperSize: IVRWPaperSize;

    // A reference to the image list of section icons on the designer form
    FRegionImages : TImageList;

    // Stores the List of Regions
    FRegionList : TList;

    // Interface reference to report object containing the report being designed
    FReport : IVRWReport;

    // Use background paintbox to size the scrollbox correctly and paint in the shadow
    FPaintBox : TPaintBox;

    FScrollArea : TScrollBox;
    FParentForm : TForm;

    // List of selected controls (across regions)
    FSelectedControls : TList;

    // List of controls that have been pasted from the clipboard (only valid
    // immediately after a Paste).
    FPastedControls: TInterfaceList;

    FOnPrintRecord: TOnCheckRecordProc;

    FOnFirstPass: TOnCheckRecordProc;

    FOnSecondPass: TOnCheckRecordProc;

    FOnControlAdded: TOnControlAddedProc;

    FUserID: ShortString;

    // IRegionManager -------------------------------
    Function GetBannerColor : TColor;
    Procedure SetBannerColor (Value : TColor);
    Function GetBannerFont : TFont;
    Function GetChanged : Boolean;
    Function GetControlsPopupMenu : TPopupMenu;
    Function GetDesignerForm : TForm;
    Function GetGridSizeXmm : Byte;
    Procedure SetGridSizeXmm (Value : Byte);
    Function GetGridSizeXPixels : SmallInt;
    Function GetGridSizeYmm : Byte;
    Procedure SetGridSizeYmm (Value : Byte);
    Function GetGridSizeYPixels : SmallInt;
    Function GetMinControlWidth : SmallInt;
    Function GetMinControlHeight : SmallInt;
    Function GetPaperOrientation : TOrientation;
    Procedure SetPaperOrientation (Value : TOrientation);
    Function GetPaperSizeHeight : SmallInt;
    Function GetPaperSizeWidth : SmallInt;
    Function GetPaperWidth : SmallInt;
    function GetPaperCode: ShortString;
    procedure SetPaperCode(const Value: ShortString);
    function GetPaperSize: IVRWPaperSize;
    Function GetRegionImage (Index : TRegionType) : TBitmap;
    Function GetRegions : TList;
    Function GetReport : IVRWReport;
    Procedure SetReport(Report: IVRWReport);
    Function GetReportFont : TFont;
    Function GetScrollArea : TScrollBox;
    Procedure SetScrollArea (Value : TScrollBox);
    Function GetScrollAreaScreenCoords : TRect;
    Function GetSelectedControls : TList;
    Function GetShowGrid : Boolean;
    Procedure SetShowGrid (Value : Boolean);

    Function GetOnUpdateControlInfo : TDisplayControlInfo;
    Procedure SetOnUpdateControlInfo (Value : TDisplayControlInfo);
    Function GetOnUpdateCursorPosition : TRegionDisplayPosition;
    Procedure SetOnUpdateCursorPosition (Value : TRegionDisplayPosition);

    function GetOnPrintRecord: TOnCheckRecordProc;
    procedure SetOnPrintRecord(Value: TOnCheckRecordProc);
    function GetOnFirstPass: TOnCheckRecordProc;
    procedure SetOnFirstPass(Value: TOnCheckRecordProc);
    function GetOnSecondPass: TOnCheckRecordProc;
    procedure SetOnSecondPass(Value: TOnCheckRecordProc);

    function GetOnControlAdded: TOnControlAddedProc;
    procedure SetOnControlAdded(Value: TOnControlAddedProc);

    function GetUserID: ShortString;
    procedure SetUserID(const Value: ShortString);

    // Called from the Designer Window to trigger the creation of a control when the
    // user clicks on the region client area
    Procedure AddControl(Const ControlType : TDesignerControlTypes);
    // Called from the MouseDown event on the regions to check whether a control is being
    // added, returns TRUE if one is being added
    Function AddingControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;
    // Inserts a new Section Header/Footer into the report with the specified number
    Procedure AddNewSection(Const SectionNo : SmallInt);
    // Called by the KeyDown method of the controls to rebroadcast the
    // commands to all selected controls using their KeyboardOp method
    Procedure BroadcastKeyboardOp(var Key: Word; Shift: TShiftState);
    // Called by the MouseDown event on the drag controls to generate a TRect
    // containing the limits that the mouse cursor can be moved to during a
    // move operation
    Function CalcMaxMouseMove : TRect;
    // Called to Copy the selected controls into the clipboard
    Procedure CopyControls;
    // Called to Cut the selected controls into the clipboard
    Procedure CutControls;
    // Called to delete the specified region
    procedure DeleteRegion(Region: TWinControl);
    // Called to Delete the selected controls
    Procedure DeleteControls;
    // Removes the passed control from the list of selected controls
    Procedure DeSelectControl (Const TheControl : TControl);
    // Displays the appropriate options/properties dialog for the passed control
    Procedure DisplayControlOptions (Const TheControl : TControl;
      TheForm: TForm = nil);
    // Returns TRUE if there is a the Region at the specified mouse co-ordinates
    Function InRegion (Const MousePos : TPoint) : Boolean;
    // Called from the Designer Window to load the Report
    Procedure LoadReport(Const ReportName : ShortString; Const AutoSize : Boolean);
    // Pastes controls from the clipboard. If IntoRegion is not nil, the controls
    // will be pasted into that region, otherwise they will be pasted into the
    // regions that they were originally copied from.
    procedure Paste(IntoRegion: IVRWRegion; ClickPos: TPoint);
    // Called for each pasted control
    procedure OnPaste(Control: IVRWControl);
    // Prints the current report
    function PrintReport: Boolean;
    // Routines called by the Region controls for adding and removing the
    // control from the RegionManager's list of Regions
    Procedure RegisterRegion (Const TheControl : TWinControl);
    Procedure RevokeRegion (Const TheControl : TWinControl);
    // Forces all the controls to be on the page (called if the paper size is
    // changed to a smaller size, to make sure controls are not 'lost' off the
    // side or bottom of the page).
    procedure RealignControls;
    // Called from the Designer Window to save the Report
    Procedure SaveReport;
    // Adds the passed control into the list of selected controls, clearing down the
    // list beforehand if Append is FALSE
    Procedure SelectControl (Const TheControl : TControl; Const Append : Boolean; Const WantPaint : Boolean = True);
    // Called by the Region control when the user performs a rubber-band selection
    // of all controls in an area to run through the region and select the controls
    Procedure SelectControlsInArea(Const ScreenArea : TRect);
    // Called when a group of controls is being operated on
    Procedure SelectMove (Const TheControl : TControl;
                          Const XOff, YOff : SmallInt;
                          Const Mode       : TSelectMoveMode;
                          Const LockWindow : Boolean = False);
    // Called by the controls when they are right-clicked to cause the selected controls
    // list to be updated appropriately.  If the passed control is already selected then
    // nothing will be done, but if it isn't then all controls intersecting the right-clicked
    // point will be selected and the popup menu applied to them
    Procedure SelectPopupControl(Const TheControl : TWinControl; Const ClickPoint : TPoint);
    // Sets up the designer based on the loaded report details
    Procedure SetupDesigner(Const AutoSize : Boolean);
    // Called from the Region and Controls to get the Controls Tree window displayed
    Procedure ShowControlsTree(Selection: TObject = nil);
    // Identifies the Region at the specified mouse co-ordinates and snaps the
    // moving rectangle to its grid
    Procedure SnapToRegionGrid (Const MousePos : TPoint; Var ControlRect : TRect);
    // Sets the Designer Window caption
    Procedure UpdateDesignerCaption;
    // Runs through the regions rebuilding the sorting information
    Procedure UpdateRegionSorts;

    // Internal -------------------------------------
    // Aligns the currently selected controls.
    procedure AlignControls(Horizontal, Vertical: TControlAlignment);
    // Sizes the currently selected controls.
    procedure SizeControls(WidthSetting, HeightSetting: TControlSizing;
      ToWidth, ToHeight: SmallInt);
    // Changes the sorting on selected DB Fields to the specified value
    Procedure ChangeSorting(SortTo : ShortString; Const ResetPageBrk : Boolean = False);
    // deletes any entries in the group selection list
    Procedure ClearSelectList;
    // OnPaint handler for the background TPaintBox
    Procedure OnPaintDropShadow(Sender: TObject);
    // Event handler for the OnPopup event of the Control's popup menu
    Procedure OnPopupControlsMenu(Sender: TObject);
    // Event handler for the various menu items on the Control's popup menu
    Procedure OnCut(Sender: TObject);
    Procedure OnCopy(Sender: TObject);
    Procedure OnDelete(Sender: TObject);
    Procedure OnAlign(Sender: TObject);
    Procedure OnSize(Sender: TObject);
    Procedure OnSendToBack(Sender: TObject);
    Procedure OnBringToFront(Sender: TObject);
    Procedure OnControlsTree(Sender: TObject);
    Procedure OnRangeFilter(Sender: TObject);
    Procedure OnInputField(Sender: TObject);
    Procedure OnSelectionCriteria(Sender: TObject);
    Procedure OnPrintIf(Sender: TObject);
    Procedure OnPrintOnReport(Sender: TObject);
    Procedure OnFont(Sender: TObject);
    Procedure OnNoSort(Sender: TObject);
    Procedure OnSortAsc(Sender: TObject);
    Procedure OnSortDesc(Sender: TObject);
    Procedure OnPageBreak(Sender: TObject);
    Procedure OnProperties(Sender: TObject);
    // Causes the regions to dump their grids and repaint
    Procedure UpdateRegionsGrids;

    { Returns True if any controls would be off the side or the bottom of the
      page given the supplied paper size. Controls would be partially off the
      page (but still visible) will be ignored.}
    function ControlsOffPage(W, H: Integer): Boolean;

    { Forces all controls to be inside the current page dimensions. Controls
      which are partially off the page (but still visible) will be ignored. }
    procedure ForceOnPage(W, H: Integer);

    { Adds controls to the report, displaying report property details }
    function AddReportProperties(const Region : TWinControl;
      const X, Y : Integer) : Boolean;

  Public
    Constructor Create (ParentForm : TForm; ScrollBox : TScrollBox; RegionImages : TImageList); Reintroduce;
    Destructor Destroy; Override;

    // Called by the Regions and Controls whenever a change is made to them
    // so that the user can be intelligently queried about whether they want
    // to save the report
    Procedure ChangeMade;

    // Called when moving controls to drop the control in the region under the mouse
    Procedure DropControl (Const MousePos : TPoint; Const MoveRect : TRect; Const TheControl : TControl);

    // Called by controls to determine whether they are selected or not
    Function IsSelected(Const TheControl : TWinControl) : Boolean;

    // returns true if the passed control is the only one selected
    Function JustMe (Const TheControl : TWinControl) : Boolean;

    // Called by the Region controls after they have been resized so that
    // their tops can be reset
    Procedure RealignRegions;

    // Pass the control to the RegionManager so that it can update whatever info
    // we show on-screen
    Procedure UpdateFooterStatus(Const CurrentControl : TWinControl);
  End; // TRegionManager

Var
  SaveCompressed : Boolean;

//=========================================================================

Function NewRegionManager (ParentForm : TForm; ScrollBox : TScrollBox; RegionImages : TImageList) : IRegionManager;
Begin // NewRegionManager
  Result := TRegionManager.Create(ParentForm, ScrollBox, RegionImages);
End; // NewRegionManager

//=========================================================================

Constructor TRegionManager.Create (ParentForm : TForm; ScrollBox : TScrollBox; RegionImages : TImageList);
Begin // Create
  Inherited Create;

  // Create a report object to store the report
  FReport := GetVRWReport;

  FRegionList := TList.Create;
  FSelectedControls := TList.Create;

  FParentForm := ParentForm;
  SetScrollArea(ScrollBox);
  FRegionImages := RegionImages;

  FPaintBox := TPaintBox.Create(FScrollArea);
  With FPaintBox Do
  Begin
    Parent := FScrollArea;
    SetBounds(0, 0, 700, 400);
    OnPaint := OnPaintDropShadow;
  End; // With FPaintBox

  FAddControl := dctNone;
  FBannerFont := TFont.Create;
  FBannerFont.Assign(FScrollArea.Font);

  FReportFont := TFont.Create;
  FReportFont.Assign(FScrollArea.Font);

  FChangeMade := False;

  // Open up the .INI and load the current users settings
  With TIniFile.Create(SetDrive + 'REPORTS\' + ChangeFileExt(ExtractFileName(Application.ExeName), '.DAT')) Do
  Begin
    Try
      // Colours
      // MH 17/10/2016 2017-R1 ABSEXCH-17754: New colour scheme for VRW
      FBannerColor := ReadInteger(EntryRec^.Login, 'BannerColour', DefaultBackgroundColour);
      FBannerFont.Color := ReadInteger(EntryRec^.Login, 'BannerFontColour', DefaultFontColour);

      // Grid
      FShowGrid := ReadBool (EntryRec^.Login, 'ShowGrid', True);
      FGridSizeXmm := ReadInteger (EntryRec^.Login, 'GridXMM', 2);
      FGridSizeYmm := ReadInteger (EntryRec^.Login, 'GridYMM', 2);

      // Default Report Font
      FReportFont.Name := ReadString (EntryRec^.Login, 'FontName', FReportFont.Name);
      FReportFont.Size := ReadInteger(EntryRec^.Login, 'FontSize', FReportFont.Size);
      If ReadBool (EntryRec^.Login, 'FontStyleBold', (fsBold In FReportFont.Style)) Then
      Begin
        FReportFont.Style := FReportFont.Style + [fsBold];
      End; // If ReadBool (...
      If ReadBool (EntryRec^.Login, 'FontStyleItalic', (fsItalic In FReportFont.Style)) Then
      Begin
        FReportFont.Style := FReportFont.Style + [fsItalic];
      End; // If ReadBool (...
      If ReadBool (EntryRec^.Login, 'FontStyleUnderline', (fsUnderline In FReportFont.Style)) Then
      Begin
        FReportFont.Style := FReportFont.Style + [fsUnderline];
      End; // If ReadBool (...
      If ReadBool (EntryRec^.Login, 'FontStyleStrikeout', (fsStrikeOut In FReportFont.Style)) Then
      Begin
        FReportFont.Style := FReportFont.Style + [fsStrikeOut];
      End; // If ReadBool (...
      FReportFont.Color := ReadInteger(EntryRec^.Login, 'FontColor', Ord(FReportFont.Color));
    Finally
      Free;
    End; // Try..Finally
  End; // With TIniFile.Create(...

  // Default designer to A4 Portrait = 210 wide x 297 high
  FReport.vrPaperOrientation := Ord(poPortrait);
  SetPaperCode('A4');

  FOnUpdateCursorPosition := NIL;

  FControlsPopup := TPopupMenu.Create(ParentForm);
  With FControlsPopup Do
  Begin
    Name := 'popControls';
    OnPopup := OnPopupControlsMenu;

    FControlsPopupItems[cciCut] := TVRWMenuItem.Create(FControlsPopup, Name + '_Cut', 'Cut', OnCut);  Items.Add(FControlsPopupItems[cciCut]);
    FControlsPopupItems[cciCopy] := TVRWMenuItem.Create(FControlsPopup, Name + '_Copy', 'Copy', OnCopy);  Items.Add(FControlsPopupItems[cciCopy]);
    FControlsPopupItems[cciDelete] := TVRWMenuItem.Create(FControlsPopup, Name + '_Delete', 'Delete', OnDelete);  Items.Add(FControlsPopupItems[cciDelete]);
    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep1', '-'));
    FControlsPopupItems[cciSendToBack] := TVRWMenuItem.Create(FControlsPopup, Name + '_SendToBack', 'Send To Back', OnSendToBack);  Items.Add(FControlsPopupItems[cciSendToBack]);
    FControlsPopupItems[cciBringToFront] := TVRWMenuItem.Create(FControlsPopup, Name + '_BringToFront', 'Bring To Front', OnBringToFront);  Items.Add(FControlsPopupItems[cciBringToFront]);
    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep2', '-'));
    FControlsPopupItems[cciAlign] := TVRWMenuItem.Create(FControlsPopup, Name + '_Align', 'Align', OnAlign);  Items.Add(FControlsPopupItems[cciAlign]);
    FControlsPopupItems[cciSize] := TVRWMenuItem.Create(FControlsPopup, Name + '_Size', 'Size', OnSize);  Items.Add(FControlsPopupItems[cciSize]);
    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep3', '-'));
    FControlsPopupItems[cciControlsTree] := TVRWMenuItem.Create(FControlsPopup, Name + '_ControlsTree', 'Controls Tree', OnControlsTree);  Items.Add(FControlsPopupItems[cciControlsTree]);
    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep4', '-'));
    FControlsPopupItems[cciRangeFilter] := TVRWMenuItem.Create(FControlsPopup, Name + '_RangeFilter', 'Range Filter', OnRangeFilter);  Items.Add(FControlsPopupItems[cciRangeFilter]);
    FControlsPopupItems[cciSelectionCriteria] := TVRWMenuItem.Create(FControlsPopup, Name + '_SelectionCriteria', 'Selection Criteria', OnSelectionCriteria);  Items.Add(FControlsPopupItems[cciSelectionCriteria]);
    FControlsPopupItems[cciPrintIf] := TVRWMenuItem.Create(FControlsPopup, Name + '_PrintIf', 'Print If', OnPrintIf);  Items.Add(FControlsPopupItems[cciPrintIf]);
    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep5', '-'));
    FControlsPopupItems[cciPrintOnReport] := TVRWMenuItem.Create(FControlsPopup, Name + '_PrintOnReport', 'Print On Report', OnPrintOnReport);  Items.Add(FControlsPopupItems[cciPrintOnReport]);
    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep6', '-'));
    FControlsPopupItems[cciFont] := TVRWMenuItem.Create(FControlsPopup, Name + '_Font', 'Font', OnFont);  Items.Add(FControlsPopupItems[cciFont]);
    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep7', '-'));

    FControlsPopupItems[cciSortingSubMenu] := TVRWMenuItem.Create(FControlsPopup, Name + '_Sorting', 'Sorting');  Items.Add(FControlsPopupItems[cciSortingSubMenu]);
    FControlsPopupItems[cciNoSorting] := TVRWMenuItem.Create(FControlsPopup, Name + '_NoSorting', 'No Sorting', OnNoSort);  FControlsPopupItems[cciSortingSubMenu].Add(FControlsPopupItems[cciNoSorting]);
    FControlsPopupItems[cciSortAsc] := TVRWMenuItem.Create(FControlsPopup, Name + '_SortAsc', 'Sort Ascending', OnSortAsc);  FControlsPopupItems[cciSortingSubMenu].Add(FControlsPopupItems[cciSortAsc]);
    FControlsPopupItems[cciSortDesc] := TVRWMenuItem.Create(FControlsPopup, Name + '_SortDesc', 'Sort Descending', OnSortDesc);  FControlsPopupItems[cciSortingSubMenu].Add(FControlsPopupItems[cciSortDesc]);
    FControlsPopupItems[cciSortingSubMenu].Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep8', '-'));
    FControlsPopupItems[cciPageBreak] := TVRWMenuItem.Create(FControlsPopup, Name + '_PageBreak', 'New Page on Break', OnPageBreak);  FControlsPopupItems[cciSortingSubMenu].Add(FControlsPopupItems[cciPageBreak]);

    Items.Add(TVRWMenuItem.Create(FControlsPopup, Name + '_Sep9', '-'));
    FControlsPopupItems[cciProperties] := TVRWMenuItem.Create(FControlsPopup, Name + '_Properties', 'Properties', OnProperties);  Items.Add(FControlsPopupItems[cciProperties]);

    FControlsPopupItems[cciPrintOnReport].AutoCheck := True;
  End; // With FControlsPopup
  FPastedControls := TInterfaceList.Create;
End; // Create

//------------------------------

Destructor TRegionManager.Destroy;
Begin // Destroy
  FreeAndNIL(FReportFont);
  FreeAndNIL(FBannerFont);
  FRegionImages := NIL;
  FParentForm := NIL;
  FScrollArea := NIL;
  FreeAndNIL(FRegionList);
  FreeAndNIL(FSelectedControls);
  FreeAndNil(FPastedControls);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Event handler for the OnPopup event of the Control's popup menu
Procedure TRegionManager.OnPopupControlsMenu(Sender: TObject);
Var
  MenuItemSet : TControlContextItemsSet;
  sSortOrder  : ShortString;
  bPageBrk    : Boolean;
  I           : SmallInt;
begin
  If (FSelectedControls.Count > 0) Then
  Begin
    If (FSelectedControls.Count = 1) Then
      // Load the set of default menu items for a single control
      MenuItemSet := [cciCut, cciCopy, cciDelete, cciSendToBack, cciBringToFront, cciControlsTree,
                      cciRangeFilter, cciSelectionCriteria, cciPrintIf, cciPrintOnReport,
                      cciFont, cciProperties, cciSortingSubMenu]
    Else
      // Load the set of default menu items for multiple controls
      MenuItemSet := [cciCut, cciCopy, cciDelete, cciSendToBack, cciBringToFront, cciControlsTree,
                      cciAlign, cciSize, cciRangeFilter, cciSelectionCriteria, cciPrintIf, cciPrintOnReport,
                      cciFont{, cciProperties}];

    // run through the selected controls calling the DisableContextItems which removes
    // any items it doesn't like and extracting
    For I := 0 To (FSelectedControls.Count - 1) Do
    Begin
      TBaseDragControl(FSelectedControls[I]).DisableContextItems(MenuItemSet);

      // Print On Report
      If (cciPrintOnReport In MenuItemSet) Then
      Begin
        If (TControl(FSelectedControls[I]) Is TVRWDBFieldControl) Then
        Begin
          FControlsPopupItems[cciPrintOnReport].Checked := TVRWDBFieldControl(FSelectedControls[I]).dbfPrintOnReport;
        End // If (TControl(FSelectedControls[I]) Is TVRWDBFieldControl)
        Else If (TControl(FSelectedControls[I]) Is TVRWFormulaControl) Then
        Begin
          FControlsPopupItems[cciPrintOnReport].Checked := TVRWFormulaControl(FSelectedControls[I]).fmlPrintOnReport;
        End; // If (TControl(FSelectedControls[I]) Is TVRWFormulaControl))
      End; // If (cciPrintOnReport In MenuItemSet) And ((...

      // Sorting
      If (cciSortingSubMenu In MenuItemSet) And ((TControl(FSelectedControls[I]) Is TVRWDBFieldControl) Or (TControl(FSelectedControls[I]) Is TVRWFormulaControl)) Then
      Begin
        If (TControl(FSelectedControls[I]) Is TVRWDBFieldControl) Then
        Begin
          sSortOrder := TVRWDBFieldControl(FSelectedControls[I]).DBFieldDets.vcSortOrder;
          bPageBrk :=  TVRWDBFieldControl(FSelectedControls[I]).DBFieldDets.vcPageBreak;
        End // If (TControl(FSelectedControls[I]) Is TVRWDBFieldControl)
        Else
        Begin
          sSortOrder := TVRWFormulaControl(FSelectedControls[I]).FormulaDets.vcSortOrder;
          bPageBrk := TVRWFormulaControl(FSelectedControls[I]).FormulaDets.vcPageBreak;
        End; // Else

        If (Length(sSortOrder) >= 2) And (sSortOrder[1] In ['0'..'9']) And (sSortOrder[2] In ['A', 'D']) Then
        Begin
          FControlsPopupItems[cciSortAsc].Checked := (sSortOrder[2] = 'A');
          FControlsPopupItems[cciSortDesc].Checked := (sSortOrder[2] = 'D');
        End // If (Length(sSortOrder) >= 2) And (sSortOrder[1] In ['0'..'9']) And (sSortOrder[2] In ['A', 'D'])
        Else
        Begin
          FControlsPopupItems[cciSortAsc].Checked := False;
          FControlsPopupItems[cciSortDesc].Checked := False;
        End; // Else

        FControlsPopupItems[cciNoSorting].Checked := (Not FControlsPopupItems[cciSortAsc].Checked) And (Not FControlsPopupItems[cciSortDesc].Checked);
        FControlsPopupItems[cciPageBreak].Enabled := FControlsPopupItems[cciSortAsc].Checked Or FControlsPopupItems[cciSortDesc].Checked;

        If FControlsPopupItems[cciPageBreak].Enabled Then
        Begin
          FControlsPopupItems[cciPageBreak].Checked := bPageBrk;
        End // If FControlsPopupItems[cciPageBreak].Enabled
        Else
          FControlsPopupItems[cciPageBreak].Checked := False;
      End; // If (cciSortingSubMenu In MenuItemSet) And (TControl(FSelectedControls[I]) Is TVRWDBFieldControl)
    End; // For I

    // Enable the menu items based on what remains in the set
    FControlsPopupItems[cciCut].Visible := (cciCut In MenuItemSet);
    FControlsPopupItems[cciCopy].Visible := (cciCopy In MenuItemSet);
    FControlsPopupItems[cciDelete].Visible := (cciDelete In MenuItemSet);
    FControlsPopupItems[cciAlign].Visible := (cciAlign In MenuItemSet);
    FControlsPopupItems[cciSize].Visible := (cciSize In MenuItemSet);
    FControlsPopupItems[cciSendToBack].Visible := (cciSendToBack In MenuItemSet);
    FControlsPopupItems[cciBringToFront].Visible := (cciBringToFront In MenuItemSet);
    FControlsPopupItems[cciControlsTree].Visible := (cciControlsTree In MenuItemSet);
    FControlsPopupItems[cciRangeFilter].Visible := (cciRangeFilter In MenuItemSet) And (FSelectedControls.Count = 1);
    FControlsPopupItems[cciSelectionCriteria].Visible := (cciSelectionCriteria In MenuItemSet);
    FControlsPopupItems[cciPrintIf].Visible := (cciPrintIf In MenuItemSet);
    FControlsPopupItems[cciPrintOnReport].Visible := (cciPrintOnReport In MenuItemSet) And (FSelectedControls.Count = 1);
    FControlsPopupItems[cciFont].Visible := (cciFont In MenuItemSet);
    FControlsPopupItems[cciSortingSubMenu].Visible := (cciSortingSubMenu In MenuItemSet) And (FSelectedControls.Count = 1);
    FControlsPopupItems[cciProperties].Visible := (cciProperties In MenuItemSet);
  End // If (FSelectedControls.Count > 0)
  Else
    Raise Exception.Create ('TRegionManager.OnPopupControlsMenu called with no selected controls');
end;

//------------------------------

Procedure TRegionManager.OnCut(Sender: TObject);
Begin // OnCut
  CutControls;
End; // OnCut

//------------------------------

Procedure TRegionManager.OnCopy(Sender: TObject);
Begin // OnCopy
  CopyControls;
End; // OnCopy

//------------------------------

Procedure TRegionManager.OnDelete(Sender: TObject);
Begin // OnDelete
  DeleteControls;
End; // OnDelete

//------------------------------

Procedure TRegionManager.OnAlign(Sender: TObject);

  function IsMultiRegion: Boolean;
  { Returns True if the currently selected controls are from more than one
    report region }
  var
    i: Integer;
    FirstRegion: TRegion;
  begin
    Result := False;
    if FSelectedControls.Count > 0 then
    begin
      FirstRegion := TBaseDragControl(FSelectedControls[0]).ParentRegion;
      for i := 1 to FSelectedControls.Count - 1 do
      begin
        if TBaseDragControl(FSelectedControls[i]).ParentRegion <> FirstRegion then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;

var
  Dlg: TfrmVRWAlign;
Begin // OnAlign
  Dlg := TfrmVRWAlign.Create(nil);
  try
    Dlg.IsMultiRegion := IsMultiRegion;
    Dlg.CanSpaceEqually := (FSelectedControls.Count > 2);
    Dlg.ShowModal;
    if (Dlg.ModalResult = mrOk) then
      AlignControls(Dlg.Horizontal, Dlg.Vertical);
  finally
    Dlg.Free;
  end;
End; // OnAlign

//------------------------------

Procedure TRegionManager.OnSize(Sender: TObject);
var
  Dlg: TfrmVRWSize;
Begin // OnSize
  Dlg := TfrmVRWSize.Create(nil);
  try
    Dlg.RegionManager := self;
    Dlg.ShowModal;
    if (Dlg.ModalResult = mrOk) then
      SizeControls(
        Dlg.WidthSizing,
        Dlg.HeightSizing,
        Dlg.spinWidth.Position * PixelsPerMM,
        Dlg.spinHeight.Position * PixelsPerMM
      );
  finally
    Dlg.Free;
  end;
End; // OnSize

//------------------------------

Procedure TRegionManager.OnSendToBack(Sender: TObject);
Var
  I : SmallInt;
Begin // OnSendToBack
  If (FSelectedControls.Count > 0) Then
  Begin
    // run through the selected controls calling their own SendToBack methods
    For I := 0 To (FSelectedControls.Count - 1) Do
    Begin
      TBaseDragControl(FSelectedControls[I]).SendToBack;
    End; // For I

    ChangeMade;
  End; // If (FSelectedControls.Count > 0)
End; // OnSendToBack

//------------------------------

Procedure TRegionManager.OnBringToFront(Sender: TObject);
Var
  I : SmallInt;
Begin // OnBringToFront
  If (FSelectedControls.Count > 0) Then
  Begin
    // run through the selected controls calling their own BringToFront methods
    For I := 0 To (FSelectedControls.Count - 1) Do
    Begin
      TBaseDragControl(FSelectedControls[I]).BringToFront;
    End; // For I

    ChangeMade;
  End; // If (FSelectedControls.Count > 0)
End; // OnBringToFront

//------------------------------

Procedure TRegionManager.OnControlsTree(Sender: TObject);
Begin // OnControlsTree
  ShowControlsTree(FSelectedControls[0]);
End; // OnControlsTree

//------------------------------

Procedure TRegionManager.OnRangeFilter(Sender: TObject);
Begin // OnRangeFilter
  // Can only be used for one selected control
  If (FSelectedControls.Count = 1) Then
  Begin
    If DisplayRangeFilter(TVRWDBFieldControl(FSelectedControls[0]).DBFieldDets) Then // IVRWFieldControl
    Begin
      ChangeMade;
    End; // If DisplayRangeFilter(...
  End; // If (FSelectedControls.Count = 1)
End; // OnRangeFilter

//------------------------------

procedure TRegionManager.OnInputField(Sender: TObject);
begin
  // Can only be used for one selected control
  If (FSelectedControls.Count = 1) Then
  Begin
    If DisplayRangeFilter(TVRWDBFieldControl(FSelectedControls[0]).DBFieldDets) Then // IVRWFieldControl
    Begin
      ChangeMade;
    End; // If DisplayRangeFilter(...
  End; // If (FSelectedControls.Count = 1)
end;

//------------------------------

Procedure TRegionManager.OnSelectionCriteria(Sender: TObject);
Var
  I : SmallInt;
Begin // OnSelectionCriteria
  If (FSelectedControls.Count > 0) Then
  Begin
    // Copy changes to any other selected controls
    If DisplaySelectionCriterion (TVRWDBFieldControl(FSelectedControls[0])) Then
    Begin
      If (FSelectedControls.Count > 1) Then
      Begin
        For I := 1 To (FSelectedControls.Count - 1) Do
        Begin
          TBaseDragControl(FSelectedControls[I]).ControlDets.vcPrintIf := TBaseDragControl(FSelectedControls[0]).ControlDets.vcPrintIf;
        End; // For I
      End; // If (FSelectedControls.Count > 1)

      ChangeMade;
    End; // If DisplaySelectionCriterion (TVRWDBFieldControl(FSelectedControls[0]))
  End; // If (FSelectedControls.Count > 0)
End; // OnSelectionCriteria

//------------------------------

Procedure TRegionManager.OnPrintIf(Sender: TObject);
Var
  I : SmallInt;
Begin // OnPrintIf
  If (FSelectedControls.Count > 0) Then
  Begin
    If DisplayPrintIfOptions (TBaseDragControl(FSelectedControls[0])) Then
    Begin
      // Copy changes to any other selected controls
      If (FSelectedControls.Count > 1) Then
      Begin
        For I := 1 To (FSelectedControls.Count - 1) Do
        Begin
          TBaseDragControl(FSelectedControls[I]).ControlDets.vcPrintIf := TBaseDragControl(FSelectedControls[0]).ControlDets.vcPrintIf;
        End; // For I
      End; // If (FSelectedControls.Count > 1)

      ChangeMade;
    End; // If DisplayPrintIfOptions (TBaseDragControl(FSelectedControls[0]))
  End; // If (FSelectedControls.Count > 0)
End; // OnPrintIf

//------------------------------

Procedure TRegionManager.OnPrintOnReport(Sender: TObject);
Var
  I : SmallInt;
Begin // OnPrintOnReport
  If (FSelectedControls.Count > 0) Then
  Begin
    // run through the selected controls calling their own BringToFront methods
    For I := 0 To (FSelectedControls.Count - 1) Do
    Begin
      If (TControl(FSelectedControls[I]) Is TVRWDBFieldControl) Then
      Begin
        TVRWDBFieldControl(FSelectedControls[I]).dbfPrintOnReport := FControlsPopupItems[cciPrintOnReport].Checked;
      End // If (TControl(FSelectedControls[I]) Is TVRWDBFieldControl)
      Else If (TControl(FSelectedControls[I]) Is TVRWFormulaControl) Then
      Begin
        TVRWFormulaControl(FSelectedControls[I]).fmlPrintOnReport := FControlsPopupItems[cciPrintOnReport].Checked;
      End; // If (TControl(FSelectedControls[I]) Is TVRWFormulaControl))
    End; // For I

    ChangeMade;
  End; // If (FSelectedControls.Count > 0)
End; // OnPrintOnReport

//------------------------------

Procedure TRegionManager.OnFont(Sender: TObject);
Var
  FontDialog : TFontDialog;
  I          : SmallInt;
Begin // OnFont
  If (FSelectedControls.Count > 0) Then
  Begin
    FontDialog := TFontDialog.Create(FParentForm);
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

    CopyIFontToFont(TBaseDragControl(FSelectedControls[0]).ControlDets.vcFont, FontDialog.Font);

    If FontDialog.Execute Then
    Begin
      // Update The Controls
      TBaseDragControl(FSelectedControls[0]).UpdateFont(FontDialog.Font);

      If (FSelectedControls.Count > 1) Then
      Begin
        For I := 1 To (FSelectedControls.Count - 1) Do
        Begin
          TBaseDragControl(FSelectedControls[I]).UpdateFont(FontDialog.Font);
        End; // For I
      End; // If (FSelectedControls.Count > 1)

      ChangeMade;
    End; // If FontDialog.Execute
  End; // If (FSelectedControls.Count > 0)
End; // OnFont

//------------------------------

// Changes the sorting on selected DB Fields to the specified value
Procedure TRegionManager.ChangeSorting(SortTo : ShortString; Const ResetPageBrk : Boolean = False);
Var
  oControl    : TBaseDragControl;
  I           : SmallInt;
  Changed     : Boolean;
Begin // ChangeSorting
  If (FSelectedControls.Count > 0) Then
  Begin
    Changed := False;

    For I := 0 To (FSelectedControls.Count - 1) Do
    Begin
      oControl := TBaseDragControl(FSelectedControls[I]);
      If (oControl Is TVRWDBFieldControl) Then
      Begin
        TVRWDBFieldControl(oControl).DBFieldDets.vcSortOrder := SortTo;
        If ResetPageBrk Then TVRWDBFieldControl(oControl).DBFieldDets.vcPageBreak := False;
        Changed := True;
      End // If (oControl Is TVRWDBFieldControl)
      Else If (oControl Is TVRWFormulaControl) Then
      Begin
        TVRWFormulaControl(oControl).FormulaDets.vcSortOrder := SortTo;
        If ResetPageBrk Then TVRWFormulaControl(oControl).FormulaDets.vcPageBreak := False;
        Changed := True;
      End; // If (oControl Is TVRWFormulaControl)
    End; // For I

    If Changed Then
    Begin
      UpdateRegionSorts;
    End; // If Changed
  End; // If (FSelectedControls.Count > 0)
End; // ChangeSorting

//------------------------------

Procedure TRegionManager.OnNoSort(Sender: TObject);
Begin // OnNoSort
  ChangeSorting('', True);
End; // OnNoSort

//------------------------------

Procedure TRegionManager.OnSortAsc(Sender: TObject);
Begin // OnSortAsc
  ChangeSorting('1A');
End; // OnSortAsc

//------------------------------

Procedure TRegionManager.OnSortDesc(Sender: TObject);
Begin // OnNoOnSortDescSort
  ChangeSorting('1D');
End; // OnSortDesc

//------------------------------

Procedure TRegionManager.OnPageBreak(Sender: TObject);
Var
  oControl    : TBaseDragControl;
  I           : SmallInt;
  Changed     : Boolean;
Begin // OnPageBreak
  If (FSelectedControls.Count > 0) Then
  Begin
    Changed := False;

    For I := 0 To (FSelectedControls.Count - 1) Do
    Begin
      oControl := TBaseDragControl(FSelectedControls[I]);
      If (oControl Is TVRWDBFieldControl) Then
      Begin
        TVRWDBFieldControl(oControl).DBFieldDets.vcPageBreak := Not FControlsPopupItems[cciPageBreak].Checked;
        Changed := True;
      End // If (oControl Is TVRWDBFieldControl)
      Else If (oControl Is TVRWFormulaControl) Then
      Begin
        TVRWFormulaControl(oControl).FormulaDets.vcPageBreak := Not FControlsPopupItems[cciPageBreak].Checked;
        Changed := True;
      End; // If (oControl Is TVRWFormulaControl)
    End; // For I

    If Changed Then
    Begin
      UpdateRegionSorts;
    End; // If Changed
  End; // If (FSelectedControls.Count > 0)
End; // OnPageBreak

//------------------------------

Procedure TRegionManager.OnProperties(Sender: TObject);
Begin // OnProperties
  If (FSelectedControls.Count = 1) Then
  Begin
    DisplayControlOptions (TControl(FSelectedControls[0]));
  End // If (FSelectedControls.Count = 1)
  Else
    Raise Exception.Create('TRegionManager.OnProperties called with no controls or multiple controls');
End; // OnProperties

//-------------------------------------------------------------------------

// Called from the Designer Window to trigger the creation of a control when the
// user clicks on the region client area
Procedure TRegionManager.AddControl(Const ControlType : TDesignerControlTypes);
Begin // AddControl
  FAddControl := ControlType;
End; // AddControl

//------------------------------

// Called from the MouseDown event on the controls to check whether a control is being
// added, returns TRUE if one is being added and adds it at the specified screen co-ordinates
Function TRegionManager.AddingControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;
Begin // AddingControl
  If (FAddControl <> dctNone) Then
  Begin
    Try
      Result := True;

      Case FAddControl Of
        dctText     : AddTextControl(Region, X, Y);
        dctImage    : AddImageControl(Region, X, Y);
        dctBox      : AddBoxControl(Region, X, Y);
        dctDBField  : AddDBFieldControl(Region, X, Y);
        dctFormula  : AddFormulaControl(Region, X, Y);
        dctReportProperties: AddReportProperties(Region, X, Y);
      Else
        Raise Exception.Create('TRegionManager.AddingControl: Unhandled Control Type (' + IntToStr(Ord(FAddControl)) + ')');
      End; // Case FAddControl
    Finally
      FAddControl := dctNone;
    End; // Try..Finally
  End // If (FAddControl <> dctNone)
  Else
    Result := False;
  if Assigned(FOnControlAdded) then
    FOnControlAdded(Result);
End; // AddingControl

//-------------------------------------------------------------------------

// Called by the Regions and Controls whenever a change is made to them
// so that the user can be intelligently queried about whether they want
// to save the report
Procedure TRegionManager.ChangeMade;
Begin // ChangeMade
  FChangeMade := True;
End; // ChangeMade

//-------------------------------------------------------------------------

// deletes any entries in the group selection list
Procedure TRegionManager.ClearSelectList;
Begin
  While (FSelectedControls.Count > 0) Do Begin
    TWinControl(FSelectedControls.Items[0]).Invalidate;
    FSelectedControls.Delete (0);
  End; // While (FSelectedControls.Count > 0)
End;

//------------------------------

// Called by controls to determine whether they are selected or not
Function TRegionManager.IsSelected(Const TheControl : TWinControl) : Boolean;
Begin // IsSelected
  Result := (FSelectedControls.IndexOf(TheControl) > -1);
End; // IsSelected

//------------------------------

// returns true if the passed control is the only one selected
Function TRegionManager.JustMe (Const TheControl : TWinControl) : Boolean;
Begin // JustMe
  Result := (FSelectedControls.Count = 1) And (FSelectedControls.IndexOf(TheControl) > -1);
End; // JustMe

//------------------------------

// Adds the passed control into the list of selected controls, clearing down the
// list beforehand if Append is FALSE
Procedure TRegionManager.SelectControl (Const TheControl : TControl; Const Append : Boolean; Const WantPaint : Boolean = True);
Begin
  If (Not Append) Then
  Begin
    ClearSelectList;
  End; // If (Not Append)

  If (FSelectedControls.IndexOf(TheControl) = -1) Then
  Begin
    FSelectedControls.Add (TheControl);
    If WantPaint Then TheControl.Invalidate;
  End; // If (FSelectedControls.IndexOf(TheControl) > -1)
End;

//------------------------------

// Removes the passed control from the list of selected controls
Procedure TRegionManager.DeSelectControl (Const TheControl : TControl);
Begin
  If (FSelectedControls.IndexOf(TheControl) > -1) Then
  Begin
    FSelectedControls.Delete (FSelectedControls.IndexOf(TheControl));
    TheControl.Invalidate;
  End; { If }
End;

//------------------------------

// Called by the Region control when the user performs a rubber-band selection
// of all controls in an area to run through the region and select the controls
Procedure TRegionManager.SelectControlsInArea(Const ScreenArea : TRect);
Var
  RegionCtrl    : TRegion;
  TempRect      : TRect;
  I             : SmallInt;
  FocusControls : Boolean;
Begin // SelectControlsInArea
  ClearSelectList;

  If (FRegionList.Count > 0) Then
  Begin
    FocusControls := True;
    For I := 0 To (FRegionList.Count - 1) Do
    Begin
      RegionCtrl := TRegion(FRegionList[I]);
      If RegionCtrl.Visible And IntersectRect(TempRect, ScreenArea, RegionCtrl.RegionClientScrCoords) Then
      Begin
        RegionCtrl.SelectByScreenArea(TempRect, FocusControls);
      End; // If RegionCtrl.Visible And IntersectRect(TempRect, ScreenArea, RegionCtrl.RegionClientScrCoords)
    End; // For I
  End; // If (FRegionList.Count > 0)
End; // SelectControlsInArea

//------------------------------

// Called when a group of controls is being operated on
Procedure TRegionManager.SelectMove (Const TheControl : TControl;
                                     Const XOff, YOff : SmallInt;
                                     Const Mode       : TSelectMoveMode;
                                     Const LockWindow : Boolean = False);
Var
  I : SmallInt;
Begin // SelectMove
  If (FSelectedControls.Count > 0) Then
  Begin
    If LockWindow Then
    Begin
      LockWindowUpdate (Application.MainForm.Handle);
    End; // If LockWindow

    Try
      // move the controls
      //If (Mode In [1..4, 6]) Then
      If (Mode In [smmMouseDown, smmMouseMove, smmMouseUp, {4,} smmCtrlClick]) Then
      Begin
        For I := 0 To (FSelectedControls.Count - 1) Do
          If (TControl(FSelectedControls.Items[I]) <> TheControl) Then
            TBaseDragControl(FSelectedControls.Items[I]).SelectMove(XOff, YOff, Mode);
      End; // If (Mode In [smmMouseDown, smmMouseMove, smmMouseDown, smmCtrlClick])

      // repaint them
      If (Mode In [smmMouseDown {, 4}]) Then
        For I := 0 To (FSelectedControls.Count - 1) Do
          If (TControl(FSelectedControls.Items[I]) <> TheControl) Then
            TBaseDragControl(FSelectedControls.Items[I]).Invalidate;

      // delete them
      //If (Mode = 5) Then
      //  DeleteSelected;
    Finally
      If LockWindow Then
      Begin
        LockWindowUpdate (0);
      End; // If LockWindow
    End;
  End; // If (FSelectedControls.Count > 0)
End;

//------------------------------

// Called by the controls when they are right-clicked to cause the selected controls
// list to be updated appropriately.  If the passed control is already selected then
// nothing will be done, but if it isn't then all controls intersecting the right-clicked
// point will be selected and the popup menu applied to them
Procedure TRegionManager.SelectPopupControl(Const TheControl : TWinControl; Const ClickPoint : TPoint);
Begin // SelectPopupControl
  If (Not IsSelected(TheControl)) Then
  Begin
    // MH 18/05/05: Temporarily disabled the SelectControlsInArea as not sure how context menu
    // should work with overlapping controls - when in place it all seemed very strange
    //SelectControlsInArea(Rect(ClickPoint.X, ClickPoint.Y, ClickPoint.X+1, ClickPoint.Y+1));
    SelectControl (TheControl, False, True);
  End; // If (Not IsSelected(TheControl))
End; // SelectPopupControl

//-------------------------------------------------------------------------

// Called by the KeyDown method of the controls to rebroadcast the
// commands to all selected controls using their KeyboardOp method
Procedure TRegionManager.BroadcastKeyboardOp(var Key: Word; Shift: TShiftState);
Var
  TempList : TList;
  I        : SmallInt;
Begin // BroadcastKeyboardOp
  If (FSelectedControls.Count > 0) Then
  Begin
    // NOTE: Can't work directly off the SelectedControls list as operations
    // like Delete cause the contents of the list to change, so first we need
    // to make a copy of the selected controls list and then work from that
    TempList := TList.Create;
    Try
      TempList.Assign(FSelectedControls);
      For I := 0 To (TempList.Count - 1) Do
      Begin
        TBaseDragControl(TempList[I]).KeyboardOp(Key, Shift);
      End; // For I
    Finally
      FreeAndNIL(TempList);
    End; // Try..Finally
  End; // If (FSelectedControls.Count > 0)
End; // BroadcastKeyboardOp

//-------------------------------------------------------------------------

// Called by the MouseDown event on the drag controls to generate a TRect
// containing the limits that the mouse cursor can be moved to during a
// move operation
Function TRegionManager.CalcMaxMouseMove : TRect;
Var
  I : SmallInt;
Begin // CalcMaxMouseMove
  If (FRegionList.Count > 0) Then
  Begin
    // Extract first visible region and get the Top, Left and Right Co-ords
    For I := 0 To (FRegionList.Count - 1) Do
    Begin
      If TRegion(FRegionList[I]).Visible Then
      Begin
        Result := TRegion(FRegionList[I]).RegionClientScrCoords;
        Break;
      End; // If TRegion(FRegionList[I]).Visible
    End; // For I

    // Extract last visible region and get the Bottom Co-ords
    For I := (FRegionList.Count - 1) DownTo 0 Do
    Begin
      If TRegion(FRegionList[I]).Visible Then
      Begin
        Result.Bottom := TRegion(FRegionList[I]).RegionClientScrCoords.Bottom;
        Break;
      End; // If TRegion(FRegionList[I]).Visible
    End; // For I
  End // If (FRegionList.Count > 0)
  Else
    Raise Exception.Create('TRegionManager.CalcMaxMouseMove: No regions defined');
End; // CalcMaxMouseMove

//-------------------------------------------------------------------------

// Displays the appropriate options/properties dialog for the passed control
Procedure TRegionManager.DisplayControlOptions (Const TheControl : TControl;
  TheForm: TForm);
var
  OldName, NewName: ShortString;
Begin // DisplayControlOptions
  If (TheControl Is TVRWTextControl) Then
  Begin
    DisplayTextOptions (TVRWTextControl(TheControl), TheForm);
  End // If (TheControl Is TVRWTextControl)
  Else If (TheControl Is TVRWImageControl) Then
  Begin
    DisplayImageOptions (TVRWImageControl(TheControl));
  End // If (TheControl Is TVRWImageControl)
  Else If (TheControl Is TVRWBoxControl) Then
  Begin
    DisplayBoxOptions(TVRWBoxControl(TheControl), TheForm);
  End // If (TheControl Is TVRWBoxControl)
  Else If (TheControl Is TVRWDBFieldControl) Then
  Begin
    DisplayDBFieldOptions(TVRWDBFieldControl(TheControl), TheForm);
  End // If (TheControl Is TVRWDBFieldControl)
  Else If (TheControl Is TVRWFormulaControl) Then
  Begin
    OldName := TVRWFormulaControl(TheControl).FormulaDets.vcFormulaName;
    if DisplayFormulaOptions(TVRWFormulaControl(TheControl), TheForm) then
    begin
      NewName := TVRWFormulaControl(TheControl).FormulaDets.vcFormulaName;
      if (Uppercase(Trim(OldName)) <> Uppercase(Trim(NewName))) then
        FReport.UpdateFormulaReferences(OldName, NewName);
    end;
  End // If (TheControl Is TVRWFormulaControl)
  Else
    //Raise Exception.Create ('TRegionManager.DisplayControlOptions: Unknown Control');
    AddDebug ('TRegionManager.DisplayControlOptions: Unknown Control');
End; // DisplayControlOptions

//-------------------------------------------------------------------------

// Called when moving controls to drop the control in the region under the mouse
Procedure TRegionManager.DropControl (Const MousePos : TPoint; Const MoveRect : TRect; Const TheControl : TControl);
Var
  OrigRegion, NewRegion : TRegion;
  TempRect  : TRect;
  I         : SmallInt;
Begin // DropControl
  If (FRegionList.Count > 0) Then
  Begin
    For I := 0 To (FRegionList.Count - 1) Do
    Begin
      With TRegion(FRegionList[I]) Do
      Begin
        If Visible And (MousePos.X >= RegionCoords.Left) And (MousePos.X <= RegionCoords.Right) And (MousePos.Y >= RegionCoords.Top) And (MousePos.Y <= RegionCoords.Bottom) Then
        Begin
          NewRegion := TRegion(FRegionList[I]);

          // Record the original region so we can repaint it
          OrigRegion := TBaseDragControl(TheControl).ParentRegion;

          // Use the ParentRegion property to reparent it as this causes all the internal
          // links between regions to be updated
          TBaseDragControl(TheControl).ParentRegion := NewRegion;

          // Convert the screen move rectangle into region client-co-ordinates for positioning and sizing
          TempRect.TopLeft := NewRegion.ScreenToClient(MoveRect.TopLeft);
          TempRect.BottomRight := NewRegion.ScreenToClient(MoveRect.BottomRight);
          TheControl.SetBounds(TempRect.Left, TempRect.Top, (TempRect.Right - TempRect.Left), (TempRect.Bottom - TempRect.Top));

          // Repaint original & new regions
          OrigRegion.Invalidate;
          NewRegion.Invalidate;

          ChangeMade;
        End; // If Visible And (MousePos.X >= ...
      End; // With TRegion(FRegionList[I]).RegionClientScrCoords
    End; // For I
  End; // If (FRegionList.Count > 0)
End; // DropControl

//------------------------------

// Returns TRUE if there is a Region at the specified mouse co-ordinates
Function TRegionManager.InRegion (Const MousePos : TPoint) : Boolean;
Var
  I : SmallInt;
Begin // InRegion
  Result := False;
  If (FRegionList.Count > 0) Then
  Begin
    For I := 0 To (FRegionList.Count - 1) Do
    Begin
      With TRegion(FRegionList[I]) Do
      Begin
        If Visible And (MousePos.X >= RegionCoords.Left) And (MousePos.X <= RegionCoords.Right) And (MousePos.Y >= RegionCoords.Top) And (MousePos.Y <= RegionCoords.Bottom) Then
        Begin
          Result := True;
          Break;
        End; // If Visible And (MousePos.X >= ...
      End; // With TRegion(FRegionList[I]).RegionClientScrCoords
    End; // For I
  End; // If (FRegionList.Count > 0)
End; // InRegion

//------------------------------

// Identifies the Region at the specified mouse co-ordinates and snaps the
// moving rectangle to its grid
Procedure TRegionManager.SnapToRegionGrid (Const MousePos : TPoint; Var ControlRect : TRect);
Var
  I : SmallInt;
Begin // SnapToRegionGrid
  If (FRegionList.Count > 0) Then
  Begin
    For I := 0 To (FRegionList.Count - 1) Do
    Begin
      With TRegion(FRegionList[I]) Do
      Begin
        If Visible And (MousePos.X >= RegionCoords.Left) And (MousePos.X <= RegionCoords.Right) And (MousePos.Y >= RegionCoords.Top) And (MousePos.Y <= RegionCoords.Bottom) Then
        Begin
          TRegion(FRegionList[I]).MoveSnapToGrid(ControlRect);
          Break;
        End; // End; // If Visible And (MousePos.X >= ...
      End; // With TRegion(FRegionList[I]).RegionClientScrCoords
    End; // For I
  End; // If (FRegionList.Count > 0)
End; // SnapToRegionGrid

//-------------------------------------------------------------------------

// Called by the Region controls after they have been resized so that
// their tops can be reset
Procedure TRegionManager.RealignRegions;
Var
  RegionCtrl : TRegion;
  I, NextTop : SmallInt;
Begin // RealignRegions
  If (FRegionList.Count > 0) Then
  Begin
    RegionCtrl := NIL;  // Suppresses compiler warning

    NextTop := -FScrollArea.VertScrollBar.Position + 5;

    For I := 0 To (FRegionList.Count - 1) Do
    Begin
      RegionCtrl := TRegion(FRegionList[I]);
      RegionCtrl.Left := 5 - FScrollArea.HorzScrollBar.Position;
      RegionCtrl.Width := GetPaperWidth * PixelsPerMM + LeftBorderWidth + RightBorderWidth;

      If RegionCtrl.Visible Then
      Begin
        RegionCtrl.Top := NextTop;
        NextTop := RegionCtrl.Top + RegionCtrl.Height;
        RegionCtrl.reRegionDets.rgVisible := True;
      End // If RegionCtrl.Visible
      else
        RegionCtrl.reRegionDets.rgVisible := False;
    End; // For I

    // Resize background shadow - take into account 5 pixels border + 5 pixel drop-shadow
    FPaintBox.Height := NextTop + FScrollArea.VertScrollBar.Position + 10;
    FPaintBox.Width := RegionCtrl.Left + RegionCtrl.Width + FScrollArea.HorzScrollBar.Position + 10;
  End; // If (FRegionList.Count > 0)
End; // RealignRegions

//------------------------------

// Called by the Region controls on creation to add themselves into
// the RegionManager's list of Regions
Procedure TRegionManager.RegisterRegion (Const TheControl : TWinControl);
Begin // RegisterRegion
  // If the control isn't already present in the list then add it
  If (FRegionList.IndexOf(TheControl) = -1) Then
  Begin
    FRegionList.Add (TheControl);
    RealignRegions;
  End; // If (FRegionList.IndexOf(TheControl) = -1)
End; // RegisterRegion

//------------------------------

// Called by the Region controls on destruction to remove themselves
// from the RegionManager's list of Regions
Procedure TRegionManager.RevokeRegion (Const TheControl : TWinControl);
Var
  Idx : SmallInt;
Begin // RevokeRegion
  // If the control is present in the list then remove it
  Idx := FRegionList.IndexOf(TheControl);
  If (Idx <> -1) Then
  Begin
    FRegionList.Delete (Idx);
  End; // If (Idx <> -1)
End; // RevokeRegion

//-------------------------------------------------------------------------

// Called from the Region and Controls to get the Controls Tree window displayed
Procedure TRegionManager.ShowControlsTree(Selection: TObject);
Var
  frmControlsTree: TfrmControlsTree;
Begin // ShowControlsTree
  frmControlsTree := TfrmControlsTree.Create(FParentForm);
  Try
    frmControlsTree.DesignerWindow := FParentForm;
    frmControlsTree.RegionManager := Self;
    frmControlsTree.RegionsList := FRegionList;
    if (Selection is TRegion) then
      frmControlsTree.Region := TRegion(Selection)
    else if (Selection is TBaseDragControl) then
      frmControlsTree.Control := TBaseDragControl(Selection);
    frmControlsTree.ShowModal;

    UpdateRegionSorts;

  Finally
    FreeAndNIL(frmControlsTree);
  End; // Try..Finally
End; // ShowControlsTree

//-------------------------------------------------------------------------

// Pass the control to the RegionManager so that it can update whatever info
// we show on-screen
Procedure TRegionManager.UpdateFooterStatus(Const CurrentControl : TWinControl);
Var
  sControlPos, sControlRF, sControlSC, sControlIF, sControlDesc : ShortString;
Begin // UpdateFooterStatus
  If Assigned(FOnUpdateControlInfo) Then
  Begin
    With CurrentControl As TBaseDragControl Do
    Begin
      sControlPos := PositionDesc;
      sControlRF := IfThen(RangeFilter, 'RF', '');
      sControlSC := IfThen(SelectionCriteria, 'SEL', '');
      sControlIF := IfThen(PrintIf, 'IF', '');
      sControlDesc := ControlSummary;
    End; // With CurrentControl As TBaseDragControl

    FOnUpdateControlInfo(sControlPos, sControlRF, sControlSC, sControlIF, sControlDesc);
  End; // If Assigned(FOnUpdateControlInfo)
End; // UpdateFooterStatus

//-------------------------------------------------------------------------

Function TRegionManager.GetBannerColor : TColor;
Begin // GetBannerColor
  Result := FBannerColor;
End; // GetBannerColor
Procedure TRegionManager.SetBannerColor (Value : TColor);
Begin // SetBannerColor
  FBannerColor := Value;

  // Update any regions in existence
End; // SetBannerColor

//------------------------------

Function TRegionManager.GetBannerFont : TFont;
Begin // GetBannerFont
  Result := FBannerFont;
End; // GetBannerFont

//------------------------------

Function TRegionManager.GetControlsPopupMenu : TPopupMenu;
Begin // GetControlsPopupMenu
  Result := FControlsPopup;
End; // GetControlsPopupMenu

//------------------------------

Function TRegionManager.GetChanged : Boolean;
Begin // GetChanged
  Result := FChangeMade;
End; // GetChanged

//------------------------------

Function TRegionManager.GetDesignerForm : TForm;
Begin // GetDesignerForm
  Result := FParentForm;
End; // GetDesignerForm

//------------------------------

Function TRegionManager.GetGridSizeXmm : Byte;
Begin // GetGridSizeXmm
  Result := FGridSizeXmm;
End; // GetGridSizeXmm
Procedure TRegionManager.SetGridSizeXmm (Value : Byte);
Begin // SetGridSizeXmm
  If (Value <> FGridSizeXmm) Then
  Begin
    FGridSizeXmm := Value;
    UpdateRegionsGrids;
  End; // If (Value <> FGridSizeXmm)
End; // SetGridSizeXmm
Function TRegionManager.GetGridSizeXPixels : SmallInt;
Begin // GetGridSizeXPixels
  // If turned on then Align to the grid else align to the mm
  If FShowGrid Then
    Result := FGridSizeXmm * PixelsPerMM
  Else
    Result := PixelsPerMM;
End; // GetGridSizeXPixels

//------------------------------

Function TRegionManager.GetGridSizeYmm : Byte;
Begin // GetGridSizeYmm
  Result := FGridSizeYmm;
End; // GetGridSizeYmm
Procedure TRegionManager.SetGridSizeYmm (Value : Byte);
Begin // SetGridSizeYmm
  If (Value <> FGridSizeYmm) Then
  Begin
    FGridSizeYmm := Value;
    UpdateRegionsGrids;
  End; // If (Value <> FGridSizeYmm)
End; // SetGridSizeYmm
Function TRegionManager.GetGridSizeYPixels : SmallInt;
Begin // GetGridSizeYPixels
  // If turned on then Align to the grid else align to the mm
  If FShowGrid Then
    Result := FGridSizeYmm * PixelsPerMM
  Else
    Result := PixelsPerMM;
End; // GetGridSizeYPixels

//------------------------------

Function TRegionManager.GetOnUpdateControlInfo : TDisplayControlInfo;
Begin // GetOnUpdateControlInfo
  Result := FOnUpdateControlInfo;
End; // GetOnUpdateControlInfo
Procedure TRegionManager.SetOnUpdateControlInfo (Value : TDisplayControlInfo);
Begin // SetOnUpdateControlInfo
  FOnUpdateControlInfo := Value;
End; // SetOnUpdateControlInfo

//------------------------------

Function TRegionManager.GetOnUpdateCursorPosition : TRegionDisplayPosition;
Begin // GetOnUpdateCursorPosition
  Result := FOnUpdateCursorPosition;
End; // GetOnUpdateCursorPosition
Procedure TRegionManager.SetOnUpdateCursorPosition (Value : TRegionDisplayPosition);
Begin // SetOnUpdateCursorPosition
  FOnUpdateCursorPosition := Value;
End; // SetOnUpdateCursorPosition

//------------------------------

Function TRegionManager.GetMinControlWidth : SmallInt;
Begin // GetMinControlWidth
  If FShowGrid Then
    Result := FGridSizeXmm * PixelsPerMM
  Else
    Result := 3 * PixelsPerMM;
End; // GetMinControlWidth

//------------------------------

Function TRegionManager.GetMinControlHeight : SmallInt;
Begin // GetMinControlHeight
  If FShowGrid Then
    Result := FGridSizeYmm * PixelsPerMM
  Else
    Result := 3 * PixelsPerMM;
End; // GetMinControlHeight

//------------------------------

Function TRegionManager.GetPaperOrientation : TOrientation;
Begin // GetPaperOrientation
  Result := TOrientation(FReport.vrPaperOrientation);
End; // GetPaperOrientation
Procedure TRegionManager.SetPaperOrientation (Value : TOrientation);
Begin // SetPaperOrientation
  FReport.vrPaperOrientation:= Ord(Value);
End; // SetPaperOrientation

//------------------------------

Function TRegionManager.GetPaperSizeHeight : SmallInt;
Begin // GetPaperSizeHeight
  Result := FPaperSize.prMMHeight;
End; // GetPaperSizeHeight

//------------------------------

Function TRegionManager.GetPaperSizeWidth : SmallInt;
Begin // GetPaperSizeWidth
  Result := FPaperSize.prMMWidth;
End; // GetPaperSizeWidth

//------------------------------

Function TRegionManager.GetPaperWidth : SmallInt;
Begin // GetPaperWidth
  if TOrientation(FReport.vrPaperOrientation) = poLandscape then
    Result := FPaperSize.prMMHeight
  else
    Result := FPaperSize.prMMWidth;
End; // GetPaperWidth

//------------------------------

Function TRegionManager.GetRegionImage (Index : TRegionType) : TBitmap;
Const
  RegionImageXRef : Array [TRegionType] of SmallInt = (-1, 0, 1, 2, 3, 4, 5, 6);
Begin // GetRegionImage
  If (RegionImageXRef[Index] <> -1) Then
  Begin
    Result := TBitmap.Create;
    FRegionImages.GetBitmap(RegionImageXRef[Index], Result);
  End // If (RegionImageXRef[Index] <> -1)
  Else
    Raise Exception.Create ('TRegionManager.GetRegionImage: Unexpected Region Index (' + IntToStr(Ord(Index)) + ')');
End; // GetRegionImage

//------------------------------

Function TRegionManager.GetRegions : TList;
Begin // GetRegions
  Result := FRegionList;
End; // GetRegions

//------------------------------

Function TRegionManager.GetReport : IVRWReport;
Begin // GetReport
  Result := FReport;
End; // GetReport

//------------------------------

Function TRegionManager.GetReportFont : TFont;
Begin // GetReportFont
  Result := FReportFont;
End; // GetReportFont

//------------------------------

Function TRegionManager.GetScrollArea : TScrollBox;
Begin // GetScrollArea
  Result := FScrollArea;
End; // GetScrollArea
Procedure TRegionManager.SetScrollArea (Value : TScrollBox);
Begin // SetScrollArea
  FScrollArea := Value;
End; // SetScrollArea

//------------------------------

Function TRegionManager.GetSelectedControls : TList;
Begin // GetSelectedControls
  Result := FSelectedControls;
End; // GetSelectedControls

//------------------------------

Function TRegionManager.GetScrollAreaScreenCoords : TRect;
Begin // GetScrollAreaScreenCoords
  Result := FScrollArea.BoundsRect;
  Result.TopLeft := FScrollArea.Parent.ClientToScreen(Result.TopLeft);
  Result.BottomRight := FScrollArea.Parent.ClientToScreen(Result.BottomRight);

  If FScrollArea.VertScrollBar.IsScrollBarVisible Then
    Result.Right := Result.Right - GetSystemMetrics(SM_CYVSCROLL)
End; // GetScrollAreaScreenCoords

//------------------------------

Function TRegionManager.GetShowGrid : Boolean;
Begin // GetShowGrid
  Result := FShowGrid;
End; // GetShowGrid
Procedure TRegionManager.SetShowGrid (Value : Boolean);
Begin // SetShowGrid
  If (Value <> FShowGrid) Then
  Begin
    FShowGrid := Value;
    UpdateRegionsGrids;
  End; // If (Value <> FShowGrid)
End; // SetShowGrid

//-------------------------------------------------------------------------

// Causes the regions to dump their grids and repaint
Procedure TRegionManager.UpdateRegionsGrids;
Var
  I : SmallInt;
Begin // SetShowGrid
  If (FRegionList.Count > 0) Then
  Begin
    For I := 0 To (FRegionList.Count - 1) Do
    Begin
      TRegion(FRegionList[I]).GridSettingsChanged;
    End; // For I
  End; // If (FRegionList.Count > 0)
End; // SetShowGrid

//-------------------------------------------------------------------------

// OnPaint handler for the background TPaintBox
Procedure TRegionManager.OnPaintDropShadow(Sender: TObject);
Begin // OnPaintDropShadow
  With FPaintBox.Canvas Do
  Begin
    Brush.Color := clBtnFace;
    Brush.Style := bsSolid;
    FillRect(FPaintBox.BoundsRect);

    Brush.Color := clBtnShadow;
    Brush.Style := bsSolid;
    FillRect(Rect(10, 10, FPaintBox.Width - 5, FPaintBox.Height - 5));
  End; // With FPaintBox.Canvas
End; // OnPaintDropShadow

//-------------------------------------------------------------------------

// Called from the Designer Window to load the Report
Procedure TRegionManager.LoadReport(Const ReportName : ShortString; Const AutoSize : Boolean);
Begin // LoadReport
  FReport.Read(ReportName);
  // Make sure we are using the correct paper size...
  SetPaperCode(FReport.vrPaperCode);
  // ...and create the report display.
  SetupDesigner(AutoSize);
End; // LoadReport

//------------------------------

// Sets the Designer Window caption
Procedure TRegionManager.UpdateDesignerCaption;
Begin // UpdateDesignerCaption
  FParentForm.Caption := 'Report Designer - ' + Trim(FReport.VrName) + ' - ' + Trim(FReport.VrDescription);
End; // UpdateDesignerCaption

//------------------------------

// Sets up the designer based on the loaded report details
Procedure TRegionManager.SetupDesigner(Const AutoSize : Boolean);
Var
  iRegion : SmallInt;
Begin // SetupDesigner
  UpdateDesignerCaption;

  SetPaperOrientation (TOrientation(FReport.vrPaperOrientation));

  // Create the Regions
  If (FReport.vrRegions.rlCount > 0) Then
  Begin
    For iRegion := 0 To (FReport.vrRegions.rlCount - 1) Do
    Begin
      // Just create the region and then it registers itself within the regions list
      TRegion.Create(Self, FReport.vrRegions.rlItems[iRegion]);
    End; // For iRegion

    // Run through the regions updating the sorting details on the controls
    // and for display on the region headers
    UpdateRegionSorts;
  End; // If (FReport.vrRegions.rlCount > 0)

  If AutoSize Then
  Begin
    If FScrollArea.HorzScrollBar.IsScrollBarVisible Then
    Begin
      FParentForm.Width := FParentForm.Width + (FScrollArea.HorzScrollBar.Range - FScrollArea.ClientWidth);
      If (FParentForm.Width > Screen.Width) Then FParentForm.Width := Screen.Width;
      If ((FParentForm.Left + FParentForm.Width) > Screen.Width) Then FParentForm.Left := Screen.Width - FParentForm.Width;
    End; // If FScrollArea.HorzScrollBar.IsScrollBarVisible

    If FScrollArea.VertScrollBar.IsScrollBarVisible Then
    Begin
      FParentForm.Height := FParentForm.Height + (FScrollArea.VertScrollBar.Range - FScrollArea.ClientHeight);
      If (FParentForm.Height > Screen.Height) Then FParentForm.Height := Screen.Height;
      If ((FParentForm.Top + FParentForm.Height) > Screen.Height) Then FParentForm.Top := Screen.Height - FParentForm.Height;
    End; // If FScrollArea.VertScrollBar.IsScrollBarVisible
  End; // If AutoSize
  // Make sure all the controls are within the print area.
  RealignControls;
End; // LoadReport

//------------------------------

// Prints the current report
function TRegionManager.PrintReport: Boolean;
Begin // PrintReport

//    TOnCheckRecordProc = procedure(Count, Total : integer; Var Abort : Boolean) of Object;
//
//    { The vrOnPrintRecord procedure (if assigned) will be called on each
//      record while the report is being printed. It is passed the current
//      record count, the total number of records, and an 'abort' flag which
//      can be set to True to cancel the print run. Note that the report uses a
//      two-pass routine, so this procedure will actually be called twice for
//      every record, once on each pass. }
//    property vrOnPrintRecord: TOnCheckRecordProc
//      read GetVrOnPrintRecord
//      write SetVrOnPrintRecord;
//
//    { Called when the report generator begins the first pass. The record count
//      and record total values will both be zero }
//    property vrOnFirstPass: TOnCheckRecordProc
//      read GetVrOnFirstPass
//      write SetVrOnFirstPass;
//
//    { Called when the report generator begins the second pass. The record count
//      will be zero, and the record total will hold the number of records that
//      will be included in the report. }
//    property vrOnSecondPass: TOnCheckRecordProc

  FReport.vrOnPrintRecord := FOnPrintRecord;
  FReport.vrOnFirstPass   := FOnFirstPass;
  FReport.vrOnSecondPass  := FOnSecondPass;
  (FReport as IVRWReport2).vrUserID := FUserID;
  Result := FReport.Print('');
End; // PrintReport

//------------------------------

// Called from the Designer Window to save the Report
Procedure TRegionManager.SaveReport;
Begin // SaveReport
  FReport.Write(SaveCompressed);
  FChangeMade := False;
End; // SaveReport

//-------------------------------------------------------------------------

// Runs through the regions rebuilding the sorting information
Procedure TRegionManager.UpdateRegionSorts;
Var
  iRegion, NextSortNo : SmallInt;
Begin // UpdateRegionSorts
  NextSortNo := 1;
  For iRegion := 0 To (FRegionList.Count - 1) Do
  Begin
    TRegion(FRegionList[iRegion]).UpdateSortDetails(NextSortNo);
  End; // For I
End; // UpdateRegionSorts

//-------------------------------------------------------------------------

// Inserts a new Section Header/Footer into the report with the specified number
Procedure TRegionManager.AddNewSection(Const SectionNo : SmallInt);
Var
  oRegion : TRegion;
Begin // AddNewSection
  LockWindowUpdate(FScrollArea.Handle);
  Try
    // Create the new regions
    FReport.vrRegions.Add(FReport, rtSectionHdr, SectionNo);
    FReport.vrRegions.Add(FReport, rtSectionFtr, SectionNo);
    FReport.vrRegions.Sort;
    ChangeMade;

    // Teardown and rebuild the designer
    While (FRegionList.Count > 0) Do
    Begin
      oRegion := TRegion(FRegionList[0]);
      oRegion.Destroy;
    End; // While (FRegionList.Count > 0)

    SetupDesigner(True);
  Finally
    LockWindowUpdate(0);
  End; // Try..Finally
End; // AddNewSection


//-------------------------------------------------------------------------

procedure TRegionManager.SetReport(Report: IVRWReport);
begin
  self.FReport := nil;
  self.FReport := Report;
end;

//-------------------------------------------------------------------------

// Called to Copy the selected controls into the clipboard
Procedure TRegionManager.CopyControls;
Var
  I : SmallInt;
Begin // CopyControls
  FReport.ClearClipboard;
  If (FSelectedControls.Count > 0) Then
  Begin
    For I := 0 To (FSelectedControls.Count - 1) Do
    Begin
      FReport.CopyToClipboard(TBaseDragControl(FSelectedControls.Items[I]).ControlDets);
    End; // For I
    FReport.CommitClipboard;
  End; // If (FSelectedControls.Count > 0)
End; // CopyControls

//------------------------------

// Called to Cut the selected controls into the clipboard
Procedure TRegionManager.CutControls;
Begin // CutControls
  CopyControls;
  DeleteControls;
End; // CutControls

//------------------------------

// Called to Delete the selected controls
Procedure TRegionManager.DeleteControls;
Begin // DeleteControls
  // Run through the selected controls calling their own Delete methods,
  // this removes them from the list at the same time
  While (FSelectedControls.Count > 0) Do
  Begin
    TBaseDragControl(FSelectedControls[0]).Delete;
  End; // While (FSelectedControls.Count > 0)
  ChangeMade;
End; // DeleteControls

//-------------------------------------------------------------------------

// Pastes controls from the clipboard. If IntoRegion is not nil, the controls
// will be pasted into that region, otherwise they will be pasted into the
// regions that they were originally copied from.
procedure TRegionManager.Paste(IntoRegion: IVRWRegion; ClickPos: TPoint);
var
  oRegion : TRegion;
  i, j, k: Integer;
  Control: IVRWControl;
  DesignerControl: TBaseDragControl;
  TempRect: TRect;
begin
  LockWindowUpdate(FScrollArea.Handle);
  try
    FPastedControls.Clear;
    ClearSelectList;

    FReport.PasteFromClipboard(FReport, IntoRegion, OnPaste);
    ChangeMade;

    // Teardown and rebuild the designer
    While (FRegionList.Count > 0) Do
    Begin
      oRegion := TRegion(FRegionList[0]);
      oRegion.Destroy;
    End; // While (FRegionList.Count > 0)

    SetupDesigner(True);

    { Select the pasted controls }
    for i := 0 to FPastedControls.Count - 1 do
    begin
      Control := FPastedControls[i] as IVRWControl;
      for j := 0 to FRegionList.Count - 1 do
      begin
        oRegion := TRegion(FRegionList[j]);
        for k := 0 to oRegion.reRegionControls.Count - 1 do
        begin
          DesignerControl := TBaseDragControl(oRegion.reRegionControls[k]);
          if (DesignerControl.ControlDets.vcName = Control.vcName) then
          begin
            SelectControl(DesignerControl, True, True);

            { If only one control was pasted, move it to the mouse position }
            if (IntoRegion <> nil) and (FPastedControls.Count = 1) then
            begin
              TempRect := DesignerControl.BuildMoveRect(ClickPos, Point(0, 0));
              DropControl (ClickPos, TempRect, DesignerControl);
              DesignerControl.UpdateControlDets;
            end;

          end;
        end;
      end;
      Control := nil;
    end;

  Finally
    LockWindowUpdate(0);
  End; // Try..Finally
end;

// Callback procedure, when pasting controls from the clipboard this function
// is called for each pasted control.
procedure TRegionManager.OnPaste(Control: IVRWControl);
begin
  FPastedControls.Add(Control);
end;

function TRegionManager.GetOnFirstPass: TOnCheckRecordProc;
begin
  Result := FOnFirstPass;
end;

function TRegionManager.GetOnPrintRecord: TOnCheckRecordProc;
begin
  Result := FOnPrintRecord;
end;

function TRegionManager.GetOnSecondPass: TOnCheckRecordProc;
begin
  Result := FOnSecondPass;
end;

procedure TRegionManager.SetOnFirstPass(Value: TOnCheckRecordProc);
begin
  FOnFirstPass := Value;
end;

procedure TRegionManager.SetOnPrintRecord(Value: TOnCheckRecordProc);
begin
  FOnPrintRecord := Value;
end;

procedure TRegionManager.SetOnSecondPass(Value: TOnCheckRecordProc);
begin
  FOnSecondPass := Value;
end;

procedure TRegionManager.AlignControls(Horizontal,
  Vertical: TControlAlignment);

  function LeftMostControl(Controls: TList): TBaseDragControl;
  var
    i: Integer;
    MinX: Integer;
  begin
    Result := nil;
    if (GetPaperOrientation = poLandscape) then
      MinX := FPaperSize.prMMHeight * PixelsPerMM
    else
      MinX := FPaperSize.prMMWidth * PixelsPerMM;
    for i := 0 to (Controls.Count - 1) do
    begin
      if (TBaseDragControl(Controls[i]).Left < MinX) then
      begin
        Result := TBaseDragControl(Controls[i]);
        MinX := Result.Left;
      end;
    end;
  end;

  function RightMostControl(Controls: TList): TBaseDragControl;
  var
    i: Integer;
    MaxX: Integer;
  begin
    Result := nil;
    MaxX := 0;
    for i := 0 to (Controls.Count - 1) do
    begin
      if ((TBaseDragControl(Controls[i]).Left +
          TBaseDragControl(Controls[i]).Width) > MaxX) then
      begin
        Result := TBaseDragControl(Controls[i]);
        MaxX := Result.Left + Result.Width;
      end;
    end;
  end;

  function BottomMostControl(Controls: TList): TBaseDragControl;
  var
    i: Integer;
    MaxY: Integer;
  begin
    Result := nil;
    MaxY := 0;
    for i := 0 to (Controls.Count - 1) do
    begin
      if ((TBaseDragControl(Controls[i]).Top +
          TBaseDragControl(Controls[i]).Height) > MaxY) then
      begin
        Result := TBaseDragControl(Controls[i]);
        MaxY := Result.Top + Result.Height;
      end;
    end;
  end;

  function TopMostControl(Controls: TList): TBaseDragControl;
  var
    i: Integer;
    MinY: Integer;
  begin
    Result := nil;
    if (GetPaperOrientation = poLandscape) then
      MinY := FPaperSize.prMMWidth * PixelsPerMM
    else
      MinY := FPaperSize.prMMHeight * PixelsPerMM;
    for i := 0 to (Controls.Count - 1) do
    begin
      if (TBaseDragControl(Controls[i]).Top < MinY) then
      begin
        Result := TBaseDragControl(Controls[i]);
        MinY := Result.Top;
      end;
    end;
  end;

  procedure SortSelection(Controls: TList; Vertically: Boolean);
  { Sorts the list of controls into on-screen order }
  var
    i, j: Integer;
  begin
    for i := Controls.Count - 1 downto 0 do
    begin
      for j := 0 to Controls.Count - 2 do
      begin
        if Vertically then
        begin
          if (TBaseDragControl(Controls[j]).Top  >
              TBaseDragControl(Controls[j + 1]).Top) then
            Controls.Exchange(j, j + 1);
        end
        else
        begin
          if (TBaseDragControl(Controls[j]).Left  >
              TBaseDragControl(Controls[j + 1]).Left) then
            Controls.Exchange(j, j + 1);
        end;
      end;
    end;
  end;

var
  i: SmallInt;
  BaseControl: TBaseDragControl;
  RightControl, LeftControl: TBaseDragControl;
  TopControl, BottomControl: TBaseDragControl;
  DesignerControl: TBaseDragControl;
  X, Y, H, MinX, MaxX, MinY, MaxY, TotalWidth, TotalHeight: Integer;
  Spacing, VerticalSpacing: Integer;
  HorzControls, VertControls: TList;
  RegionRect: TRect;
begin
  if (FSelectedControls.Count > 1) then
  begin
    LockWindowUpdate(FScrollArea.Handle);
    HorzControls := TList.Create;
    HorzControls.Assign(FSelectedControls);
    VertControls := TList.Create;
    VertControls.Assign(FSelectedControls);
    try
      // By default, align the controls to the first selected control.
      BaseControl := TBaseDragControl(FSelectedControls[0]);
      if (Horizontal = caHorzEqual) then
      begin
        SortSelection(HorzControls, False);
        { Find the left-most and right-most controls from the selected
          controls }
        LeftControl := LeftMostControl(HorzControls);
        RightControl := RightMostControl(HorzControls);
        { Calculate the distance between them }
        MinX := LeftControl.Left + LeftControl.Width;
        MaxX := RightControl.Left;

        TotalWidth := (MaxX - MinX);
        for i := 1 to HorzControls.Count - 2 do
          TotalWidth := TotalWidth - TBaseDragControl(HorzControls[1]).Width;

        { Divide by the total number of selected controls, to give the spacing
          required between the controls }
        Spacing := TotalWidth div (HorzControls.Count - 1);

        X := LeftControl.Left;
      end;
      if (Vertical = caVertEqual) then
      begin
        SortSelection(VertControls, True);
        { Find the top-most and bottomt-most controls from the selected
          controls }
        TopControl := TopMostControl(VertControls);
        BottomControl := BottomMostControl(VertControls);
        { Calculate the distance between them }
        MinY := TopControl.Top + TopControl.Height;
        MaxY := BottomControl.Top;

        TotalHeight := (MaxY - MinY);
        for i := 1 to VertControls.Count - 2 do
          TotalHeight := TotalHeight - TBaseDragControl(VertControls[1]).Height;

        { Divide by the total number of selected controls, to give the spacing
          required between the controls }
        VerticalSpacing := TotalHeight div (VertControls.Count - 1);

        Y := TopControl.Top;
      end;
      case Horizontal of
        caHorzLeft:  X := BaseControl.Left;
        caHorzRight: X := BaseControl.Left + BaseControl.Width - 1;
        caHorzEqual: ;
        caHorzRegionCentre:
          begin
            if (GetPaperOrientation = poLandscape) then
              X := FPaperSize.prMMHeight div 2
            else
              X := FPaperSize.prMMWidth div 2;
            X := X * PixelsPerMM;
          end;
      end;
      case Vertical of
        caVertTop:  Y := BaseControl.Top;
        caVertBottom: Y := BaseControl.Top + BaseControl.Height - 1;
        caVertEqual: ;
        caVertRegionCentre:
          begin
            RegionRect := BaseControl.ParentRegion.RegionClientScrCoords;
            RegionRect.TopLeft := BaseControl.ParentRegion.ScreenToClient(RegionRect.TopLeft);
            RegionRect.BottomRight := BaseControl.ParentRegion.ScreenToClient(RegionRect.BottomRight);
            H := (BaseControl.ParentRegion.RegionClientScrCoords.Bottom -
                  BaseControl.ParentRegion.RegionClientScrCoords.Top) + 1;
            Y := (H div 2) + RegionRect.Top;
          end;
      end;
      if (Horizontal = caHorzEqual) then
      begin
        for i := 0 to (HorzControls.Count - 1) do
        begin
          DesignerControl := TBaseDragControl(HorzControls[i]);
          DesignerControl.Left := X;
          DesignerControl.SnapToGrid;
          X := X + DesignerControl.Width + Spacing;
        end;
      end;
      if (Vertical = caVertEqual) then
      begin
        for i := 0 to (VertControls.Count - 1) do
        begin
          DesignerControl := TBaseDragControl(VertControls[i]);
          DesignerControl.Top := Y;
          DesignerControl.SnapToGrid;
          Y := Y + DesignerControl.Height + VerticalSpacing;
        end;
      end;
      for i := 0 to (FSelectedControls.Count - 1) do
      begin
        DesignerControl := TBaseDragControl(FSelectedControls[i]);
        case Horizontal of
          caHorzLeft: DesignerControl.Left := X;
          caHorzRight: DesignerControl.Left := X - DesignerControl.Width + 1;
          caHorzRegionCentre:
            begin
              DesignerControl.Left := X - (DesignerControl.Width div 2);
              DesignerControl.SnapToGrid;
            end;
        end;
        case Vertical of
          caVertTop: DesignerControl.Top := Y;
          caVertBottom: DesignerControl.Top := Y - DesignerControl.Height;
          caVertRegionCentre:
            begin
              DesignerControl.Top := Y - (DesignerControl.Height div 2);
              DesignerControl.SnapToGrid;
            end;
        end;
        DesignerControl.UpdateControlDets;
      end;
    finally
      ChangeMade;
      LockWindowUpdate(0);
      HorzControls.Free;
      VertControls.Free;
    end;
  end;
end;

procedure TRegionManager.SizeControls(WidthSetting,
  HeightSetting: TControlSizing; ToWidth, ToHeight: SmallInt);

  function FindMinWidth: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to (FSelectedControls.Count - 1) do
    begin
      if (Result = 0) or (TBaseDragControl(FSelectedControls[i]).Width < Result) then
        Result := TBaseDragControl(FSelectedControls[i]).Width;
    end;
  end;

  function FindMaxWidth: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to (FSelectedControls.Count - 1) do
    begin
      if (TBaseDragControl(FSelectedControls[i]).Width > Result) then
        Result := TBaseDragControl(FSelectedControls[i]).Width;
    end;
  end;

  function FindMinHeight: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to (FSelectedControls.Count - 1) do
    begin
      if (Result = 0) or (TBaseDragControl(FSelectedControls[i]).Height < Result) then
        Result := TBaseDragControl(FSelectedControls[i]).Height;
    end;
  end;

  function FindMaxHeight: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to (FSelectedControls.Count - 1) do
    begin
      if (TBaseDragControl(FSelectedControls[i]).Height > Result) then
        Result := TBaseDragControl(FSelectedControls[i]).Height;
    end;
  end;

var
  i: Integer;
  Control: TBaseDragControl;
  W, H: Integer;
  ChangeWidth, ChangeHeight: Boolean;
begin
  if (FSelectedControls.Count > 1) then
  begin
    LockWindowUpdate(FScrollArea.Handle);
    try
      { Determine the new width and height }
      case WidthSetting of
        csWidthShrink: W := FindMinWidth;
        csWidthGrow: W := FindMaxWidth;
        csWidth: W := ToWidth;
      end;
      case HeightSetting of
        csHeightShrink: H := FindMinHeight;
        csHeightGrow: H := FindMaxHeight;
        csHeight: H := ToHeight;
      end;
      { Update the width and height for each of the selected controls }
      ChangeWidth := (WidthSetting in [csWidthShrink, csWidthGrow, csWidth]);
      ChangeHeight := (HeightSetting in [csHeightShrink, csHeightGrow, csHeight]);
      for i := 0 to (FSelectedControls.Count - 1) do
      begin
        Control := TBaseDragControl(FSelectedControls[i]);
        if ChangeWidth then
          Control.Width := W;
        if ChangeHeight then
          Control.Height := H;
        if ChangeWidth or ChangeHeight then
          Control.UpdateControlDets;
      end;
    finally
      ChangeMade;
      LockWindowUpdate(0);
    end;
  end;
end;

function TRegionManager.GetPaperCode: ShortString;
begin
  Result := FPaperCode;
end;

function TRegionManager.GetPaperSize: IVRWPaperSize;
begin
  Result := FPaperSize;
end;

procedure TRegionManager.SetPaperCode(const Value: ShortString);
begin
  FPaperCode := Value;
  FReport.vrPaperCode := Value;
  FPaperSize := FReport.vrPaperSizes[FPaperCode];
  // Update Regions
  RealignRegions;
end;

function TRegionManager.ControlsOffPage(W, H: Integer): Boolean;
var
  i, j: Integer;
  Control: TBaseDragControl;
  Top, Right: Integer;
  oRegion: TRegion;
begin
  Result := False;
  for i := 0 to FRegionList.Count - 1 do
  begin
    oRegion := TRegion(FRegionList[i]);
    { For each control, compare the (mm) left and top with the width and
      height of the page. Return True immediately if any controls are found
      with a right position greater than the width or a top position greater
      than the height }
    for j := 0 to oRegion.reRegionControls.Count - 1 do
    begin
      Control := TBaseDragControl(oRegion.reRegionControls[j]);
      { Convert to mm }
      Top  := Control.Top div PixelsPerMM;
      Right := (Control.Left + Control.Width) div PixelsPerMM;
      if (Top > H) or
         (Right > W) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure TRegionManager.ForceOnPage(W, H: Integer);
var
  i, j: Integer;
  Control: TBaseDragControl;
  Top, Right: Integer;
  oRegion: TRegion;
  ControlChanged: Boolean;
begin
  for i := 0 to FRegionList.Count - 1 do
  begin
    oRegion := TRegion(FRegionList[i]);
    { For each control, compare the (mm) left and top with the width and
      height of the page. If the left is greater than the width of the page,
      adjust it. Similarly adjust the top if it is greater than the height
      of the page. }
    for j := 0 to oRegion.reRegionControls.Count - 1 do
    begin
      Control := TBaseDragControl(oRegion.reRegionControls[j]);
      ControlChanged := False;
      { Convert to mm }
      Top  := Control.Top div PixelsPerMM;
      Right := (Control.Left + Control.Width) div PixelsPerMM;
      if (Right > W) then
      begin
        Control.Left := (W * PixelsPerMM) -
                        (Control.Width +
                         Control.ParentRegion.reManager.rmGridSizeXPixels);
        if (Control.Left < Control.ParentRegion.reLeftMargin) then
        begin
          Control.Width := (W * PixelsPerMM) -
                           (Control.ParentRegion.reLeftMargin +
                            Control.ParentRegion.reManager.rmGridSizeXPixels);
          Control.Left  := Control.ParentRegion.reLeftMargin;
        end;
        ControlChanged := True;
      end;
      if (Top > H) then
      begin
        Control.Top := (H * PixelsPerMM) - Control.Height;
        ControlChanged := True;
      end;
      if ControlChanged then
        Control.SnapToGrid;
    end;
  end;
  ChangeMade;
end;

procedure TRegionManager.RealignControls;
var
  OffPage: Boolean;
begin
  if GetPaperOrientation = poLandscape then
    OffPage := ControlsOffPage(FPaperSize.prMMHeight, FPaperSize.prMMWidth)
  else
    OffPage := ControlsOffPage(FPaperSize.prMMWidth, FPaperSize.prMMHeight);
  if OffPage then
    if GetPaperOrientation = poLandscape then
      ForceOnPage(FPaperSize.prMMHeight, FPaperSize.prMMWidth)
    else
      ForceOnPage(FPaperSize.prMMWidth, FPaperSize.prMMHeight);
end;

function TRegionManager.AddReportProperties(const Region: TWinControl;
  const X, Y: Integer): Boolean;
var
  VRWControl: IVRWTextControl;
  FmlControl: IVRWFormulaControl;
  DesignerControl: TBaseDragControl;
  YPos, W, H: Integer;
  Entry: Integer;
  FieldControl: IVRWFieldControl;
begin // AddTextControl
  YPos := Y;

  { Main file name }
  // Create new text object in RepEngine.Dll
  VRWControl := TRegion(Region).reRegionDets.rgControls.Add(TRegion(Region).reRegionDets.RgReport, ctText) As IVRWTextControl;
  VRWControl.vcCaption := 'Main file : ' + FReport.vrMainFile;

  // Create a new hidden wrapper control for the designer - setup minimum basic info
  DesignerControl := TVRWTextControl.Create(TRegion(Region).reManager, VRWControl);
  try
    DesignerControl.Visible := True;
    DesignerControl.ParentRegion := TRegion(Region);
    DesignerControl.SetBounds (X, YPos, 90, 21); // LTWH

    // Need to size intelligently and position according to the grid
    DesignerControl.CalcInitialSize (VRWControl.vcCaption);
    DesignerControl.SnapToGrid;
    H := DesignerControl.Height;
  finally
    VRWControl := nil;
  end; // Try..Finally

  { Force the width to most of the page }
  W := Trunc(((GetPaperWidth * 0.9) * PixelsPerMM) - X);

  { Report range filter description }
  // Create new formula object in RepEngine.Dll
  if (Trim(FReport.vrRangeFilter.rfFromValue) +
      Trim(FReport.vrRangeFilter.rfToValue)) <> '' then
  begin
    FmlControl := TRegion(Region).reRegionDets.rgControls.Add(TRegion(Region).reRegionDets.RgReport, ctFormula) As IVRWFormulaControl;
    FmlControl.vcFormulaDefinition := '"RF[INDEX]';
    FmlControl.vcFormulaName       := 'ReportIndexRF';
    FmlControl.vcFieldFormat       := 'L';

    // Create a new hidden wrapper control for the designer - setup minimum basic info
    DesignerControl := TVRWFormulaControl.Create(TRegion(Region).reManager, FmlControl);
    try
      YPos := YPos + H;
      DesignerControl.Visible := True;
      DesignerControl.ParentRegion := TRegion(Region);
      DesignerControl.SetBounds (X, YPos, W, 21); // LTWH

      // Need to size intelligently and position according to the grid
      DesignerControl.CalcInitialSize (FmlControl.vcFormulaName);
      DesignerControl.Width := W;
      DesignerControl.SnapToGrid;
    finally
      FmlControl := nil;
    end; // Try..Finally
  end;

  { Control range filters }
  for Entry := 0 to FReport.vrControls.clCount - 1 do
  begin
    if Supports(FReport.vrControls.clItems[Entry], IVRWFieldControl) then
    begin
      FieldControl := FReport.vrControls.clItems[Entry] as IVRWFieldControl;
      if (FieldControl.vcRangeFilter.rfDescription <> '') then
      begin

        // Create new text object in RepEngine.Dll
        FmlControl := TRegion(Region).reRegionDets.rgControls.Add(TRegion(Region).reRegionDets.RgReport, ctFormula) As IVRWFormulaControl;
        FmlControl.vcFormulaDefinition := '"RF[' + FieldControl.vcRangeFilter.rfDescription + ']';
        FmlControl.vcFormulaName       := FieldControl.vcRangeFilter.rfDescription + 'RF';
        FmlControl.vcFieldFormat       := 'L';

        // Create a new hidden wrapper control for the designer - setup minimum basic info
        DesignerControl := TVRWFormulaControl.Create(TRegion(Region).reManager, FmlControl);
        try
          YPos := YPos + H;
          DesignerControl.Visible := True;
          DesignerControl.ParentRegion := TRegion(Region);
          DesignerControl.SetBounds (X, YPos, W, 21); // LTWH

          // Need to size intelligently and position according to the grid
          DesignerControl.CalcInitialSize (FmlControl.vcFormulaName);
          DesignerControl.Width := W;
          DesignerControl.SnapToGrid;
        finally
          FmlControl := nil;
        end; // Try..Finally
      end;
    end;
  end;
  ChangeMade;
end;

procedure TRegionManager.DeleteRegion(Region: TWinControl);
var
  RegionName: string;
begin
  RegionName := TRegion(Region).reRegionDets.rgName;
  { Delete the report region }
  FReport.vrRegions.Delete(RegionName);
  { Delete the designer region }
  Region.Free;
  { Rebuild the designer display }
  RealignRegions;
  ChangeMade;
end;

function TRegionManager.GetOnControlAdded: TOnControlAddedProc;
begin
  Result := FOnControlAdded;
end;

procedure TRegionManager.SetOnControlAdded(Value: TOnControlAddedProc);
begin
  FOnControlAdded := Value;
end;

function TRegionManager.GetUserID: ShortString;
begin
  Result := FUserID;
end;

procedure TRegionManager.SetUserID(const Value: ShortString);
begin
  FUserID := Value;
end;

Initialization
  SaveCompressed := Not FindCmdLineSwitch('SaveXML', ['-','/'], True);
end.
