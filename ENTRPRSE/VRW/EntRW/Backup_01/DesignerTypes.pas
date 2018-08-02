unit DesignerTypes;

interface

Uses Classes, Controls, Dialogs, Forms, Graphics, Menus, StdCtrls, Types, Printers,
     VRWReportIF, RpDefine, VRWPaperSizesIF;

Const
  // Scaling ratio for designer
  PixelsPerMM = 3;
  PixelsPerInch = PixelsPerMM * 25.4;  // 25.4mm = 1 Inch

Type
  TOnCheckRecordProc = procedure(Count, Total : integer; Var Abort : Boolean) of Object;
  // Enumeration used for controlling the items on the controls popup menus
  TControlContextItems = (cciCut, cciCopy, cciDelete,
                          cciSendToBack, cciBringToFront,
                          cciControlsTree, cciAlign, cciSize,
                          cciRangeFilter, cciSelectionCriteria, cciPrintIf,
                          cciPrintOnReport, cciFont, cciProperties,
                          cciSortingSubMenu, cciNoSorting, cciSortAsc, cciSortDesc, cciPageBreak);

  TControlContextItemsSet = Set Of TControlContextItems;
                                                        
  TDesignerControlTypes = (dctNone, dctText, dctImage, dctBox, dctDBField, dctFormula);

  // Moved to Common\VRWReportIF.Pas
  //TRegionType = (rtUnknown, rtRepHdr, rtPageHdr, rtSectionHdr, rtRepLines, rtSectionFtr, rtPageFtr, rtRepFtr);

  // Enumeration to identify the operation when working on controls as a group
  TSelectMoveMode = (smmMouseDown=1, smmMouseMove=2, smmMouseUp=3, {4?} {5?} smmCtrlClick=6);

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IRegion = Interface
    ['{28CCE865-D77F-4924-929F-4A163DB74D05}']
    // --- Internal Methods to implement Public Properties ---

    // ------------------ Public Properties ------------------
    // Property reRegionType : TRegionType;
    // Property reSectionNo : SmallInt;

    // ------------------- Public Methods --------------------
  End; // IRegion

  //------------------------------

  TDisplayControlInfo = Procedure (Const ControlPos, ControlRF, ControlSC, ControlIF, ControlDesc : ShortString) Of Object;
  TRegionDisplayPosition = Procedure (Const X, Y : LongInt) Of Object;

  //------------------------------

  // Interface for object which manages the separate region controls and the
  // controls within those regions at design time.
  IRegionManager = Interface
    ['{F6687F74-3961-4C6F-96AA-D6618DC609C8}']
    // --- Internal Methods to implement Public Properties ---
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
    Procedure SetPaperSizeHeight (Value : SmallInt);
    Function GetPaperSizeWidth : SmallInt;
    Procedure SetPaperSizeWidth (Value : SmallInt);
    Function GetPaperWidth : SmallInt;
    Procedure SetPaperWidth (Value : SmallInt);
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

    // ------------------ Public Properties ------------------
    Property rmBannerColor : TColor Read GetBannerColor Write SetBannerColor;
    Property rmBannerFont : TFont Read GetBannerFont;
    Property rmChanged : Boolean Read GetChanged;
    Property rmControlsPopupMenu : TPopupMenu Read GetControlsPopupMenu;
    Property rmDesignerForm : TForm Read GetDesignerForm;
    Property rmGridSizeXmm : Byte Read GetGridSizeXmm Write SetGridSizeXmm;
    Property rmGridSizeXPixels : SmallInt Read GetGridSizeXPixels;
    Property rmGridSizeYmm : Byte Read GetGridSizeYmm Write SetGridSizeYmm;
    Property rmGridSizeYPixels : SmallInt Read GetGridSizeYPixels;
    Property rmMinControlHeight : SmallInt Read GetMinControlHeight;
    Property rmMinControlWidth : SmallInt Read GetMinControlWidth;
    Property rmPaperOrientation : TOrientation Read GetPaperOrientation Write SetPaperOrientation;
    // rmPaperSizeHeight is the height of the paper, e.g. 297mm for A4
    Property rmPaperSizeHeight : SmallInt Read GetPaperSizeHeight Write SetPaperSizeHeight;
    // rmPaperSizeWidth is the width of the paper, e.g. 210mm for A4
    Property rmPaperSizeWidth : SmallInt Read GetPaperSizeWidth Write SetPaperSizeWidth;
    // rmPaperWidth is the current width of paper in use, this will be either
    // rmPaperSizeHeight or rmPaperSizewidth depending on the orientation
    Property rmPaperWidth : SmallInt Read GetPaperWidth Write SetPaperWidth;
    // rmPaperCode holds the identifying code for the current paper size
    property rmPaperCode: ShortString read GetPaperCode write SetPaperCode;
    // rmPaper size contains the height and width of the currently selected
    // paper
    property rmPaperSize: IVRWPaperSize read GetPaperSize;
    Property rmRegionImages [Index : TRegionType] : TBitmap Read GetRegionImage;
    Property rmRegions : TList Read GetRegions;
    Property rmReport : IVRWReport Read GetReport write SetReport;
    Property rmReportFont : TFont Read GetReportFont;
    Property rmScrollArea : TScrollBox Read GetScrollArea Write SetScrollArea;
    // The screen co-ordinates of the scroll-box client area
    Property rmScrollAreaScreenCoords : TRect Read GetScrollAreaScreenCoords;
    // Provides access to the list of selected controls
    Property rmSelectedControls : TList Read GetSelectedControls;
    Property rmShowGrid : Boolean Read GetShowGrid Write SetShowGrid;

    // Optional Event for feeding back control information to the designer
    Property OnUpdateControlInfo : TDisplayControlInfo Read GetOnUpdateControlInfo Write SetOnUpdateControlInfo;
    // Optional Event for feeding back mouse position info to the designer
    Property OnUpdateCursorPosition : TRegionDisplayPosition Read GetOnUpdateCursorPosition Write SetOnUpdateCursorPosition;

    property OnPrintRecord: TOnCheckRecordProc read GetOnPrintRecord write SetOnPrintRecord;
    property OnFirstPass: TOnCheckRecordProc read GetOnFirstPass write SetOnFirstPass;
    property OnSecondPass: TOnCheckRecordProc read GetOnSecondPass write SetOnSecondPass;

    // ------------------- Public Methods --------------------

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

    // Called by the Regions and Controls whenever a change is made to them
    // so that the user can be intelligently queried about whether they want
    // to save the report
    Procedure ChangeMade;

    // Called to Copy the selected controls into the clipboard
    Procedure CopyControls;

    // Called to Cut the selected controls into the clipboard
    Procedure CutControls;

    // Called to Delete the selected controls
    Procedure DeleteControls;

    // Removes the passed control from the list of selected controls
    Procedure DeSelectControl (Const TheControl : TControl);

    // Displays the appropriate options/properties dialog for the passed control
    Procedure DisplayControlOptions (Const TheControl : TControl);

    // Called when moving controls to drop the control in the region under the mouse
    Procedure DropControl (Const MousePos : TPoint; Const MoveRect : TRect; Const TheControl : TControl);

    // Returns TRUE if there is a the Region at the specified mouse co-ordinates
    Function InRegion (Const MousePos : TPoint) : Boolean;

    // Called by controls to determine whether they are selected or not
    Function IsSelected(Const TheControl : TWinControl) : Boolean;

    // returns true if the passed control is the only one selected
    Function JustMe (Const TheControl : TWinControl) : Boolean;

    // Called from the Designer Window to load the Report
    Procedure LoadReport(Const ReportName : ShortString; Const AutoSize : Boolean);

    // Pastes controls from the clipboard. If IntoRegion is not nil, the controls
    // will be pasted into that region, otherwise they will be pasted into the
    // regions that they were originally copied from.
    procedure Paste(IntoRegion: IVRWRegion; ClickPos: TPoint);

    // Prints the current report
    Procedure PrintReport;

    // Called by the Region controls after they have been resized so that
    // their tops can be reset
    Procedure RealignRegions;

    // Routines called by the Region controls for adding and removing the
    // control from the RegionManager's list of Regions
    Procedure RegisterRegion (Const TheControl : TWinControl);
    Procedure RevokeRegion (Const TheControl : TWinControl);

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

    // Sets up the designer based on the loaded report details - only used when manually
    // building up a report instead of loading one from file
    Procedure SetupDesigner(Const AutoSize : Boolean);

    // Called from the Region and Controls to get the Controls Tree window displayed
    Procedure ShowControlsTree;

    // Identifies the Region at the specified mouse co-ordinates and snaps the
    // moving rectangle to its grid
    Procedure SnapToRegionGrid (Const MousePos : TPoint; Var ControlRect : TRect);

    // Sets the Designer Window caption
    Procedure UpdateDesignerCaption;

    // Pass the control to the RegionManager so that it can update whatever info
    // we show on-screen
    Procedure UpdateFooterStatus(Const CurrentControl : TWinControl);

    // Runs through the regions rebuilding the sorting information
    Procedure UpdateRegionSorts;
  End; // IRegionManager

  //------------------------------

  TVRWMenuItem = Class(TMenuItem)
  Public
    Constructor Create(AOwner: TComponent; AName, ACaption : ShortString; AOnClick : TNotifyEvent = NIL); Reintroduce;
  End; // TVRWMenuItem


Var
  DebugMemo : TMemo;

Procedure AddDebug (Const sDebug : String);

implementation

//=========================================================================

Constructor TVRWMenuItem.Create(AOwner: TComponent; AName, ACaption : ShortString; AOnClick : TNotifyEvent = NIL);
Begin // Create
  Inherited Create(AOwner);

  Name := AName;
  Caption := ACaption;
  OnClick := AOnClick;
End; // Create

//=========================================================================


Procedure AddDebug (Const sDebug : String);
Begin // AddDebug
  If Assigned(DebugMemo) Then
  Begin
    DebugMemo.Lines.Add(sDebug);
    DebugMemo.SelStart := Length(DebugMemo.Text) - 1;
  End // If Assigned(DebugMemo)
  Else
    ShowMessage(sDebug);
End; // AddDebug

end.
