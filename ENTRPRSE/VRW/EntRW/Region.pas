unit Region;

interface

Uses Windows, Messages, SysUtils, Classes, Controls, Dialogs, Forms, ExtCtrls, Graphics, Menus, Math,
     StrUtils,
     DesignerTypes,    // Common designer types and interfaces
     VRWReportIF
     ;

Const
  BannerHeight = 23;
  FooterHeight = 4;
  LeftBorderWidth = 18;  // Two vertical lines + icon width
  RightBorderWidth = 1;  // One vertical line

Type
  // Enumeration for the array of control resizing handles
  THandles = (TopLeft, TopCentre, TopRight, CentreLeft, CentreRight, BottomLeft, BottomCentre, BottomRight);

  TRegionMouseMode = (mmNone, mmResizeRegion, mmGroupSelect);

  //------------------------------

  TRegion = Class(TCustomPanel)
  Private
    // Reference to the RegionManager which performs common operations across
    // regions and provides a central store for common information
    FRegionManager : IRegionManager;

    // Reference to Region object inside Report Objects regions list
    FRegionIntf : IVRWRegion;

    // A copy of the bitmap icon for the region banner
    FBannerIcon : TBitmap;

    // A list of the drag controls within the region
    FRegionControls : TList;

    // Tracks what we are currently using the mouse Down/Move/Up events for
    FMouseMode : TRegionMouseMode;
    // The initial MouseDown co-ordinates for the rubber-band selection mode
    FSelectOrigin : TPoint;
    // The position of the mouse on the last click event. Used when pasting
    // controls into the region, to know where to paste.
    FClickPos: TPoint;
    // Stores the limits of the mouse movement whilst performing a particular resize/move operation
    FMaxMouseMove : TRect;
    // Stores the co-ords of the last rubber-band rectangle drawn
    FBoxRect : TRect;

    // offset painting area for bitmap to speed up the painting & reduce flickering
    FHeaderBmp, FClientBmp, FFooterBmp : TBitmap;

    // Contains the list of sorted fields for the region as determined by UpdateSortDetails
    // in the format "ACACC(A) + ACCOMP(D) + ..."
    FSortFields : ShortString;

    // References to some of the pop-up menu items, so that they can easily
    // be enabled and disabled as required.
    FPasteMenu: TVRWMenuItem;

    // Calculates the rubber-band box co-ords when resizing the region for the specifed
    // mouse position
    Function BuildResizeRect(Const MousePos : TPoint) : TRect;

    // Calculates the rubber-band box co-ords when selecting controls across regions for
    // the specifed mouse position
    Function BuildSelectRect(Const MousePos : TPoint) : TRect;

    // Draws a rubber-band move/resize/selection box on the screen canvas
    Procedure DrawRubberBandBox (Const StartRect, EndRect : TRect);

    // Get the current mouse position - needed so we can ensure the mouse stays
    // within the client area we are working with
    Function LimitMouseMovement : TPoint;

    // Region Popup Menu handlers
    Procedure OnAddText(Sender: TObject);
    Procedure OnAddImage(Sender: TObject);
    Procedure OnAddBox(Sender: TObject);
    Procedure OnAddDBField(Sender: TObject);
    Procedure OnAddFormula(Sender: TObject);
    Procedure OnAddReportProps(Sender: TObject);
    Procedure OnPopupMenu(Sender: TObject);
    Procedure OnPopupPaste(Sender: TObject);
    Procedure OnHideRegion(Sender: TObject);
    Procedure OnControlsTree(Sender: TObject);

    // Region paint methods
    Procedure PaintHeader;
    Procedure PaintClient;
    Procedure PaintFooter;

    // Property GetSet Methods
    Function GetRegionDesc : ShortString;
    function GetLeftMargin: Integer;
  Protected
    // Overriden VCL methods
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;

    // Intercepted windows messages
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
  Public
    Property reDescription : ShortString Read GetRegionDesc;
    Property reManager : IRegionManager Read FRegionManager;
    Property reRegionControls : TList Read FRegionControls;
    Property reRegionDets : IVRWRegion Read FRegionIntf;
    property reLeftMargin: Integer read GetLeftMargin;

    //Constructor Create (Const RegionManager: IRegionManager; RegionType : TRegionType; SectionNo : SmallInt); Reintroduce; OverLoad;
    Constructor Create (Const RegionManager: IRegionManager; Region : IVRWRegion); Reintroduce;
    Destructor Destroy; Override;

    // Moves the control to the top of the z-order (topmost)
    Procedure BringToFront (Const TheControl : TWinControl);

    // Called to cause the grid to be repainted
    Procedure GridSettingsChanged;

    // Snaps the control rectangle (in screen co-ords) to the grid for the region when moving a control
    Procedure MoveSnapToGrid (Var ControlRect : TRect; Const AllowRoundToNearest : Boolean = True);

    // Repaints the specified area and any controls over it
    Procedure PaintRegionArea (TheControlRect : TRect);

    // Paint any overlapping controls
    Procedure PaintTopControls (Const TheControl : TWinControl);

    // Returns the co-ordinates of the region as screen co-ordinates
    Function RegionCoords : TRect;

    // Returns the co-ordinates of the region client-area as screen co-ordinates
    Function RegionClientScrCoords : TRect;

    // Routines called by the drag controls ParentRegion property for adding and
    // removing the control from the Region's list of controls
    Procedure RegisterControl (Const TheControl : TWinControl);
    Procedure RevokeControl (Const TheControl : TWinControl);

    // Selects any controls intersecting the specified Screen area
    Procedure SelectByScreenArea (Const ScreenArea : TRect; Var FocusControls : Boolean);

    // Moves the control to the bottom of the z-order (bottommost)
    Procedure SendToBack (Const TheControl : TWinControl);

    // Snaps the resizing portion of the sizing rectangle to the grid
    Procedure SizeSnapToGrid (Var ControlRect : TRect; Const SizeOp : THandles);

    // Updates the Regions Sorting/Breaking info shown in the region caption
    Procedure UpdateBreakInfo (Const BreakInfo : ShortString);

    // Takes the offset within the region and converts it to a MM position within the
    // region which is passed through the RegionManager to be displayed on screen
    Procedure UpdateCursorPos (X, Y : LongInt; Const FromRegion : Boolean = True);

    // Updates the sorting information on controls within the region using NextSortNo
    // as the first sorting index and updates the region caption
    Procedure UpdateSortDetails(Var NextSortNo : SmallInt);
  End; // TRegion


implementation

Uses DesignerUtil,
     ctrlDrag,
     ctrlText,        // TVRWTextControl
     ctrlImage,       // TVRWImageControl
     ctrlBox,         // TVRWBoxControl
     ctrlDBField,     // TVRWDBFieldControl
     ctrlFormula;     // TVRWFormulaControl

Var
  ShowSortDebug : Boolean;

//=========================================================================

//Constructor TRegion.Create (Const RegionManager: IRegionManager; RegionType : TRegionType; SectionNo : SmallInt);
Constructor TRegion.Create (Const RegionManager: IRegionManager; Region : IVRWRegion);
Var
  iControl : SmallInt;
Begin // Create
  Inherited Create(RegionManager.rmScrollArea);
  Parent := RegionManager.rmScrollArea;

  // Set inherited properties
  BevelInner := bvNone;
  BevelOuter := bvNone;
  Color := clWhite;

  // Create a local TList to store a list of controls within the region
  FRegionControls := TList.Create;

  // Setup local references to Region Manager and Region Object
  FRegionManager := RegionManager;
  FRegionIntf := Region;

  // Setup the Region Size
  Height := BannerHeight + (FRegionIntf.rgHeight * PixelsPerMM) + FooterHeight;

  // Check whether the region is actually visible
  Visible := FRegionIntf.rgVisible;

  // Cache the region bitmap locally for speed
  FBannerIcon := FRegionManager.rmRegionImages[FRegionIntf.rgType];

  // Register this region with the Region Manager
  FRegionManager.RegisterRegion(Self);

  // Create popup menu for region
  PopupMenu := TPopupMenu.Create(Self);
  With PopupMenu Do
  Begin
    Name := 'pop' + StringReplace(FRegionIntf.rgDescription, ' ', '', [rfReplaceAll, rfIgnoreCase]);

    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_AddText', 'Add Text', OnAddText));
    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_AddImage', 'Add Image', OnAddImage));
    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_AddBox', 'Add Box', OnAddBox));
    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_AddDBField', 'Add DB Field', OnAddDBField));
    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_AddFormula', 'Add Formula', OnAddFormula));
    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_Sep1', '-'));
    If (FRegionIntf.rgType = rtRepHdr) Then
    Begin
      Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_AddReportProps', 'Add Report Properties', OnAddReportProps));
      Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_Sep2', '-'));
    End; // If (FRegionIntf.rgType = rtRepHdr)
    FPasteMenu := TVRWMenuItem.Create(Self, PopupMenu.Name + '_Paste', 'Paste', OnPopupPaste);
    Items.Add(FPasteMenu);
    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_Sep3', '-'));
    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_ControlsTree', 'Controls Tree', OnControlsTree));
    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_Sep4', '-'));
    Items.Add(TVRWMenuItem.Create(Self, PopupMenu.Name + '_HideRegion', 'Hide Region', OnHideRegion));
    OnPopup := OnPopUpMenu;
  End; // With PopupMenu

  // Initialise the sorted fields info for the region caption
  FSortFields := '';

  // Import Controls
  If (FRegionIntf.rgControls.clCount > 0) Then
  Begin
    For iControl := 0 To (FRegionIntf.rgControls.clCount - 1) Do
    Begin
      Case FRegionIntf.rgControls.clItems[iControl].vcType Of
        ctText    : Begin
                      With TVRWTextControl.Create(FRegionManager, FRegionIntf.rgControls.clItems[iControl] As IVRWTextControl) Do
                        ParentRegion := Self;
                    End; // ctText
        ctImage   : Begin
                      With TVRWImageControl.Create(FRegionManager, FRegionIntf.rgControls.clItems[iControl] As IVRWImageControl) Do
                        ParentRegion := Self;
                    End; // ctImage
        ctBox     : Begin
                      With TVRWBoxControl.Create(FRegionManager, FRegionIntf.rgControls.clItems[iControl] As IVRWBoxControl) Do
                        ParentRegion := Self;
                    End; // ctBox
        ctField   : Begin
                      With TVRWDBFieldControl.Create(FRegionManager, FRegionIntf.rgControls.clItems[iControl] As IVRWFieldControl) Do
                        ParentRegion := Self;
                    End; // ctField
        ctFormula : Begin
                      With TVRWFormulaControl.Create(FRegionManager, FRegionIntf.rgControls.clItems[iControl] As IVRWFormulaControl) Do
                        ParentRegion := Self;
                    End; // ctFormula
      Else
        Raise Exception.Create ('TRegion.Create: Unknown Control Type (' + IntToStr(Ord(FRegionIntf.rgControls.clItems[iControl].vcType)) + ')');
      End; // Case FRegionIntf.rgControls.clItems[iControl].vcType
    End; // For iControl
  End; // If (FRegionIntf.rgControlCount > 0)
End; // Create

//------------------------------

Destructor TRegion.Destroy;
Begin // Destroy
  FRegionManager.RevokeRegion(Self);

  // Remove all references to the drag controls and destroy the list, the controls
  // themselves are owned and destroyed by the ScrollBox
  FRegionControls.Clear;
  FreeAndNIL(FRegionControls);

  FreeAndNIL(FHeaderBmp);
  FreeAndNIL(FClientBmp);
  FreeAndNIL(FFooterBmp);
  FreeAndNIL(FBannerIcon);

  FRegionManager := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TRegion.PaintHeader;
Var
  Counter, I : SmallInt;
  SortInfo   : ShortString;
Begin // PaintHeader
  If Assigned(FHeaderBmp) Then
  Begin
    // Check the size is correct
    If (FHeaderBmp.Height <> BannerHeight) Or (FHeaderBmp.Width <> Self.Width) Then
    Begin
      // Size changed - destroy and recreate the cached image
      FreeAndNIL(FHeaderBmp);
    End; // If (FHeaderBmp.Height <> BannerHeight) Or (FHeaderBmp.Width <> Self.Width)
  End; // If Assigned(FHeaderBmp)

  If (Not Assigned(FHeaderBmp)) Then
  Begin
    // Create the cached image of the header bitmap
    FHeaderBmp := TBitmap.Create;
    FHeaderBmp.Height := BannerHeight;
    FHeaderBmp.Width := Self.Width;

    With FHeaderBmp.Canvas Do
    Begin
      // Paint Background
      Brush.Style := bsSolid;
      Brush.Color := FRegionManager.rmBannerColor;
      FillRect(Rect(0, 0, Self.Width, BannerHeight));  // LTRB

      // Draw Border
      Pen.Color := FRegionManager.rmBannerFont.Color;
      MoveTo(0, 0);
      LineTo(FHeaderBmp.Width - 1, 0);
      LineTo(FHeaderBmp.Width - 1, BannerHeight);
      LineTo(0, BannerHeight);
      LineTo(0, 0);

      // Paint Icon
      Draw(1, 1, FBannerIcon);

      // Paint vertical down side of icon
      Pen.Color := FRegionManager.rmBannerFont.Color;
      MoveTo(FBannerIcon.Width + 1, 1);
      LineTo(FBannerIcon.Width + 1, BannerHeight);

      // Paint Horizontal across full width
      MoveTo(1, BannerHeight-1);
      LineTo(FHeaderBmp.Width, BannerHeight-1);

      // Paint horizontal ruler
      I := FBannerIcon.Width + 2;
      Counter := 10;
      While (I < FHeaderBmp.Width) Do
      Begin
        If (Counter = 5) Then
        Begin
          FHeaderBmp.Canvas.Pixels[I, BannerHeight-4] := FRegionManager.rmBannerFont.Color;
        End // If (Counter = 5)
        Else If (Counter = 10) Then
        Begin
          FHeaderBmp.Canvas.Pixels[I, BannerHeight-5] := FRegionManager.rmBannerFont.Color;
          FHeaderBmp.Canvas.Pixels[I, BannerHeight-4] := FRegionManager.rmBannerFont.Color;
          Counter := 0;
        End; // If (Counter = 10)
        FHeaderBmp.Canvas.Pixels[I, BannerHeight-3] := FRegionManager.rmBannerFont.Color;
        FHeaderBmp.Canvas.Pixels[I, BannerHeight-2] := FRegionManager.rmBannerFont.Color;

        I := I + PixelsPerMM;
        Inc(Counter);
      End; // While (I < FHeaderBmp.Width)

      If (FRegionIntf.rgType = rtSectionHdr) Then
      Begin
        If (FSortFields <> '') Then
          SortInfo := ' - Sorting/Breaking on ' + FSortFields
        Else
          SortInfo := ' - WARNING: No Sorting/Breaking Defined'
      End // If (FRegionIntf.rgType = rtSectionHdr)
      Else If (FRegionIntf.rgType = rtSectionFtr) Then
      Begin
        If (FSortFields <> '') Then
          SortInfo := ' - Breaking on ' + FSortFields
        Else
          SortInfo := ' - WARNING: No Breaking Defined in Section Header ' + IntToStr(FRegionIntf.rgSectionNumber)
      End // If (FRegionIntf.rgType = rtSectionFtr)
      Else
        SortInfo := '';

      // Paint Description
      Font.Assign(FRegionManager.rmBannerFont);
      TextRect(Rect(20, 2, FHeaderBmp.Width-1, BannerHeight-5), 20, 3, FRegionIntf.rgDescription + SortInfo);
    End; // With FHeaderBmp.Canvas
  End; // If (Not Assigned(FHeaderBmp))

  // Paint out the cached bitmap onto the region
  Canvas.Draw (0, 0, FHeaderBmp);
End; // PaintHeader

//------------------------------

Procedure TRegion.PaintClient;
Var
  NeededHeight, iControl : SmallInt;
  Counter, I, iCols, iRows : SmallInt;
Begin // PaintClient
  NeededHeight := Self.Height - BannerHeight - FooterHeight;

  If Assigned(FClientBmp) Then
  Begin
    // Check the size is correct
    If (FClientBmp.Height <> NeededHeight) Or (FClientBmp.Width <> Self.Width) Then
    Begin
      // Size changed - destroy and recreate the cached image
      FreeAndNIL(FClientBmp);
    End; // If (FClientBmp.Height <> NeededHeight) Or (FClientBmp.Width <> Self.Width)
  End; // If Assigned(FClientBmp)

  If (Not Assigned(FClientBmp)) Then
  Begin
    // Create the cached image of the header bitmap
    FClientBmp := TBitmap.Create;
    FClientBmp.Height := NeededHeight;
    FClientBmp.Width := Self.Width;

    With FClientBmp.Canvas Do
    Begin
      // Fill Client Area with white to emulate the paper
      Brush.Style := bsSolid;
      Brush.Color := clWhite;
      FillRect(Rect(0, 0, FClientBmp.Width, FClientBmp.Height));  // LTRB

      // Paint Ruler Background against left border
      Brush.Style := bsSolid;
      Brush.Color := FRegionManager.rmBannerColor;
      FillRect(Rect(0, 0, FBannerIcon.Width + 1, FClientBmp.Height));  // LTRB

      // Paint vertical lines around ruler and right border
      Pen.Color := FRegionManager.rmBannerFont.Color;
      MoveTo(0, 0);                      LineTo(0, FClientBmp.Height);
      MoveTo(FBannerIcon.Width + 1, 0);  LineTo(FBannerIcon.Width + 1, FClientBmp.Height);
      MoveTo(FClientBmp.Width - 1, 0);   LineTo(FClientBmp.Width - 1, FClientBmp.Height);

      // Paint Vertical Ruler
      // Paint horizontal ruler
      I := 0;
      Counter := 10;
      While (I < FClientBmp.Width) Do
      Begin
        If (Counter = 5) Then
        Begin
          FClientBmp.Canvas.Pixels[FBannerIcon.Width - 2, I] := FRegionManager.rmBannerFont.Color;
        End // If (Counter = 5)
        Else If (Counter = 10) Then
        Begin
          FClientBmp.Canvas.Pixels[FBannerIcon.Width - 3, I] := FRegionManager.rmBannerFont.Color;
          FClientBmp.Canvas.Pixels[FBannerIcon.Width - 2, I] := FRegionManager.rmBannerFont.Color;
          Counter := 0;
        End; // If (Counter = 10)
        FClientBmp.Canvas.Pixels[FBannerIcon.Width - 1, I] := FRegionManager.rmBannerFont.Color;
        FClientBmp.Canvas.Pixels[FBannerIcon.Width,     I] := FRegionManager.rmBannerFont.Color;

        I := I + PixelsPerMM;
        Inc(Counter);
      End; // While (I < FClientBmp.Width)

      If FRegionManager.rmShowGrid Then
      Begin
        // Paint grid to make testing of snap-to-grid easier
        For iRows := 0 To FClientBmp.Height - 1 Do
        Begin
          If ((iRows Mod PixelsPerMM) = 0) Then
          Begin
            For iCols := (FBannerIcon.Width + 2) To FClientBmp.Width - 2 Do
            Begin
              If ((iRows Mod FRegionManager.rmGridSizeYPixels) = 0) And ((iCols - (FBannerIcon.Width + 2)) Mod FRegionManager.rmGridSizeXPixels = 0) Then
              Begin
                Pixels[iCols, iRows] := clGray;
              End // If ((iRows Mod FRegionManager.rmGridSizeYPixels) = 0) And (iCols Mod FRegionManager.rmGridSizeXPixels = 0)
              Else If (iCols Mod PixelsPerMM = 0) Then
              Begin
                // For debugging show the intermediate mm co-ords as well as the grid
                Pixels[iCols, iRows] := clSilver;
              End; // If (iCols Mod PixelsPerMM = 0)
            End; // For iCols
          End; // If ((iRows Mod PixelsPerMM) = 0)
        End; // For iRows
      End; // If FRegionManager.rmShowGrid
    End; // With NeededHeight.Canvas
  End; // If (Not Assigned(FClientBmp))

  // Paint out the cached bitmap onto the region
  Canvas.Draw (0, BannerHeight, FClientBmp);

  // NOTE: Because the drag controls are transparent we need to force them
  // all to repaint - don't know why, we just have to do it otherwise they
  // just disappear when the region is painted
  If (FRegionControls.Count > 0) Then
  Begin
    For iControl := 0 To (FRegionControls.Count - 1) Do
    Begin
      TBaseDragControl(FRegionControls[iControl]).PaintForeGround;
    End; // For iControl

    // MH 18/07/05: Separated this out from the loop above as the tab order
    // was being reversed incorrectly within the regions.
    For iControl := (FRegionControls.Count - 1) DownTo 0 Do
    Begin
      TBaseDragControl(FRegionControls[iControl]).TabOrder := 0;
    End; // For iControl
  End; // If (FRegionControls.Count > 0)
End; // PaintClient

//------------------------------

Procedure TRegion.PaintFooter;
Begin // PaintFooter
  If Assigned(FFooterBmp) Then
  Begin
    // Check the size is correct
    If (FFooterBmp.Height <> FooterHeight) Or (FFooterBmp.Width <> Self.Width) Then
    Begin
      // Size changed - destroy and recreate the cached image
      FreeAndNIL(FFooterBmp);
    End; // If (FFooterBmp.Height <> FooterHeight) Or (FFooterBmp.Width <> Self.Width)
  End; // If Assigned(FFooterBmp)

  If (Not Assigned(FFooterBmp)) Then
  Begin
    // Create the cached image of the header bitmap
    FFooterBmp := TBitmap.Create;
    FFooterBmp.Height := FooterHeight;
    FFooterBmp.Width := Self.Width;

    With FFooterBmp.Canvas Do
    Begin
      // Paint background
      Brush.Style := bsSolid;
      Brush.Color := FRegionManager.rmBannerColor;
      FillRect(Rect(0, 0, FFooterBmp.Width, FFooterBmp.Height));  // LTRB

      // Paint vertical lines around ruler and right border
      Pen.Color := FRegionManager.rmBannerFont.Color;
      MoveTo(0, 0);                      LineTo(0, FClientBmp.Height);
      MoveTo(FClientBmp.Width - 1, 0);   LineTo(FClientBmp.Width - 1, FClientBmp.Height);

      MoveTo(0, 0);  LineTo(FFooterBmp.Width, 0);
      MoveTo(0, 2);  LineTo(FFooterBmp.Width, 2);
    End; // With FFooterBmp.Canvas
  End; // If (Not Assigned(FFooterBmp))

  // Paint out the cached bitmap onto the region
  Canvas.Draw (0, Self.Height - FooterHeight, FFooterBmp);
End; // PaintFooter

//------------------------------


Procedure TRegion.Paint;
Begin // Paint
  // Perform LockWindowUpdate??
  PaintHeader;
  PaintClient;
  PaintFooter;
End; // Paint

//-------------------------------------------------------------------------

// Returns the co-ordinates of the region as screen co-ordinates
Function TRegion.RegionCoords : TRect;
Begin // RegionCoords
  Result.TopLeft := Parent.ClientToScreen(Point(Self.Left, Self.Top));
  Result.BottomRight := Parent.ClientToScreen(Point(Self.Left + Self.Width, Self.Top + Self.Height));
End; // RegionCoords

//------------------------------

// Returns the co-ordinates of the region client-area as screen co-ordinates
Function TRegion.RegionClientScrCoords : TRect;
Begin // RegionClientScrCoords
  Result := RegionCoords;

  // Take into account Banner for top
  Result.Top := Result.Top + BannerHeight;

  // and the ruler down left border
  Result.Left := Result.Left + LeftBorderWidth;

  // and the resize footer across the bottom
  Result.Bottom := Result.Bottom - FooterHeight - 1;  // -1 to bring it inside

  // and the right hand border
  Result.Right := Result.Right - RightBorderWidth - 1; // -1 to bring it inside
End; // RegionClientScrCoords

//-------------------------------------------------------------------------

Procedure TRegion.WMLButtonDblClk(var Message: TWMLButtonDblClk);
Begin // WMLButtonDblClk
  FRegionManager.ShowControlsTree(self);
End; // WMLButtonDblClk

//------------------------------

Procedure TRegion.WMSetCursor(var Msg: TWMSetCursor);
var
  MousePos : TPoint;
  Cur: HCURSOR;
Begin // WMSetCursor
  With RegionCoords Do
  Begin
    GetCursorPos(MousePos);
//FRegionManager.AddDebug(Format('MousePos (X=%d, Y=%d)', [MousePos.X, MousePos.Y]));
    If (MousePos.X >= TopLeft.X) And (MousePos.X <= BottomRight.X) And
       (MousePos.Y >= (BottomRight.Y - 3)) And (MousePos.Y <= BottomRight.Y) Then
    Begin
      Cur := LoadCursor(0, IDC_SIZENS);
      If (Cur<>0) then SetCursor(Cur);
    End // If (MousePos.X >=
    Else
      Inherited;
  End; // With RegionCoords
End; // WMSetCursor

//-------------------------------------------------------------------------

// Get the current mouse position - needed so we can ensure the mouse stays
 // within the client area we are working with
Function TRegion.LimitMouseMovement : TPoint;
Var
  Coords : TPoint;
Begin // LimitMouseMovement
  GetCursorPos (Coords);
  Result := Coords;

  // Check the cursor is within the specified rectangle
  If (Result.X < FMaxMouseMove.Left) Then Result.X := FMaxMouseMove.Left;
  If (Result.Y < FMaxMouseMove.Top) Then Result.Y := FMaxMouseMove.Top;
  If (Result.X > FMaxMouseMove.Right) Then Result.X := FMaxMouseMove.Right;
  If (Result.Y > FMaxMouseMove.Bottom) Then Result.Y := FMaxMouseMove.Bottom;

  If (Coords.X <> Result.X) Or (Coords.Y <> Result.Y) Then
  Begin
    // Move cursor to correct point
//AddDebug (Format('CorrectMouse From (%d,%d) To (%d,%d)', [Coords.X, Coords.Y, Result.X, Result.Y]));
    SetCursorPos (Result.X, Result.Y);
  End; // If (Coords.X <> Result.X) Or (Coords.Y <> Result.Y)
End; // LimitMouseMovement

//------------------------------

// Draws a rubber-band move/resize/selection box on the screen canvas
Procedure TRegion.DrawRubberBandBox (Const StartRect, EndRect : TRect);
Var
  ScreenDC : HDC;
Begin // DrawRubberBandBox
  { Check we need to redraw the rectangle }
  If Not EqualRect (StartRect, EndRect) Then
  Begin
    // Get handle for screen
    ScreenDC:=GetDC(0);
    Try
      // Erase existing rubber-band rectangle
      If Not EqualRect (Rect(0,0,0,0), StartRect) Then
      Begin
        DrawFocusRect(ScreenDC, StartRect);
      End; // If Not EqualRect (Rect(0,0,0,0), StartRect)

      { draw new rectangle }
      If Not EqualRect (Rect(0,0,0,0), EndRect) Then
      Begin
        DrawFocusRect(ScreenDC, EndRect);
      End; // If Not EqualRect (Rect(0,0,0,0), EndRect)
    Finally
      { free screen handle }
      ReleaseDC(0,ScreenDC);
    End; // Try..Finally
  End; // If Not EqualRect (StartRect, EndRect)
End; // DrawRubberBandBox

//------------------------------

// Calculates the rubber-band box co-ords when resizing the region for the specifed
// mouse position
Function TRegion.BuildResizeRect(Const MousePos : TPoint) : TRect;
Begin // BuildResizeRect
  Result := FMaxMouseMove;
  Result.Top := MousePos.Y;
  Result.Bottom := Result.Top + 2;

  // Limit it to the area covered by the scroll-box
  If (Result.Left < FRegionManager.rmScrollAreaScreenCoords.Left) Then Result.Left := FRegionManager.rmScrollAreaScreenCoords.Left;
  If (Result.Right > FRegionManager.rmScrollAreaScreenCoords.Right) Then Result.Right := FRegionManager.rmScrollAreaScreenCoords.Right;

  // Ensure that the height is a multiple of the mm/pixel
//AddDebug(Format('(%d - %d) Mod %d = %d', [Result.Top, RegionClientScrCoords.Top, PixelsPerMM, (Result.Top - RegionClientScrCoords.Top) Mod PixelsPerMM]));
  If (((Result.Top - RegionClientScrCoords.Top) Mod PixelsPerMM) <> 0) Then
  Begin
    // Trim off the spare pixels
    Result.Top := RegionClientScrCoords.Top + (((Result.Top - RegionClientScrCoords.Top) Div PixelsPerMM) * PixelsPerMM);
    Result.Bottom := Result.Top + 2;
  End; // If ((Result.Top - RegionClientScrCoords.Top) Mod PixelsPerMM) <> 0)


//With RegionClientScrCoords Do AddDebug(Format('Region Scr (L=%d, T=%d, R=%d, B=%d)', [Left, Top, Right, Bottom]));
//With Result Do AddDebug(Format('BuildResizeRect (L=%d, T=%d, R=%d, B=%d)', [Left, Top, Right, Bottom]));
End; // BuildResizeRect

//------------------------------

// Calculates the rubber-band box co-ords when selecting controls across regions for
// the specifed mouse position
Function TRegion.BuildSelectRect(Const MousePos : TPoint) : TRect;
Begin // BuildSelectRect
  With Result Do
  Begin
    Left   := IfThen (FSelectOrigin.X < MousePos.X, FSelectOrigin.X, MousePos.X);
    Top    := IfThen (FSelectOrigin.Y < MousePos.Y, FSelectOrigin.Y, MousePos.Y);
    Right  := IfThen (FSelectOrigin.X > MousePos.X, FSelectOrigin.X, MousePos.X);
    Bottom := IfThen (FSelectOrigin.Y > MousePos.Y, FSelectOrigin.Y, MousePos.Y);
  End; // With FDragRect
End; // BuildSelectRect

//------------------------------

procedure TRegion.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  MousePos : TPoint;
Begin // MouseDown
  Inherited MouseDown (Button, Shift, X, Y);
  FClickPos.X := X;
  FClickPos.Y := Y;
  FClickPos := ClientToScreen(FClickPos);
  Case FMouseMode Of
    mmNone         : Begin
                       If (Button = mbLeft) And (Y >= (Height - 3)) Then
                       Begin
                         FMouseMode := mmResizeRegion;

                         // Capture all mouse movements
                         SetCapture (Handle);

                         // Generate a Rect limiting the mouse movement for this operation
                         FMaxMouseMove := RegionCoords;
                         FMaxMouseMove.Top := FMaxMouseMove.Top + ((Round(BannerHeight*1.5) Div PixelsPerMM) * PixelsPerMM);
                         FMaxMouseMove.Bottom := Screen.Height;

                         // Check the cursor is within the limiting rectangle
                         MousePos := LimitMouseMovement;

                         // Calculate and draw the resizing rubber-band box
                         FBoxRect := BuildResizeRect(MousePos);
                         DrawRubberBandBox(Rect(0,0,0,0), FBoxRect);
                       End { If }
                       Else If (Button = mbLeft) And (Not FRegionManager.AddingControl(Self, X, Y)) Then
                       Begin
                         FMouseMode := mmGroupSelect;

                         // Capture all mouse movements
                         SetCapture (Handle);

                         // Generate a Rect limiting the mouse movement for this operation
                         FMaxMouseMove := RegionCoords;
                         FMaxMouseMove.Top := 0;
                         FMaxMouseMove.Bottom := Screen.Height;

                         // Record the original click point that all rubber-band boxes need
                         // to start from
                         FSelectOrigin := ClientToScreen(Point(X, Y));

                         // Check the cursor is within the limiting rectangle
                         MousePos := LimitMouseMovement;

                         // Calculate and draw the resizing rubber-band box
                         FBoxRect := BuildSelectRect(MousePos);
                         DrawRubberBandBox(Rect(0,0,0,0), FBoxRect);
                       End; // If (Button = mbLeft) And (Not FRegionManager.AddingControl(X, Y)) 
                     End; // mmNone

    mmResizeRegion : Raise Exception.Create ('TRegion.MouseDown: MouseDown received whilst in mmResizeRegion mode');
  End; // Case FMouseMode
End; // MouseDown

//------------------------------

Procedure TRegion.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
  MousePos : TPoint;
  LastBox  : TRect;
Begin // MouseMove
  Case FMouseMode Of
    mmResizeRegion : Begin
                       If (GetCapture = Self.Handle) And (ssLeft In Shift)  Then
                       Begin
                         // Check the cursor is within the limiting rectangle
                         MousePos := LimitMouseMovement;

                         // Calculate and draw the resizing rubber-band box
                         LastBox := FBoxRect;
                         FBoxRect := BuildResizeRect(MousePos);
                         DrawRubberBandBox (LastBox, FBoxRect);
                       End { If }
                       Else
                         // Shouldn't happen - but just in case...
                         FMouseMode := mmNone;
                     End; // mmResizeRegion
    mmGroupSelect  : Begin
                       If (GetCapture = Handle) And (ssLeft In Shift) Then
                       Begin
                         // Check the cursor is within the limiting rectangle
                         MousePos := LimitMouseMovement;

                         // Calculate and draw the resizing rubber-band box
                         LastBox := FBoxRect;
                         FBoxRect := BuildSelectRect(MousePos);
                         DrawRubberBandBox (LastBox, FBoxRect);
                       End; // If (GetCapture = Handle) And (ssLeft In Shift)
                     End; // mmGroupSelect
  End; // Case FMouseMode

//AddDebug('Region.MouseMove (' + IntToStr(X) + ', ' + IntToStr(Y) + ')');
  // Pass the current position on for display as the cursor position
  UpdateCursorPos(X, Y);

  Inherited MouseMove (Shift, X, Y);
End; // MouseMove

//------------------------------

Procedure TRegion.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  MousePos : TPoint;
Begin // MouseUp
  Case FMouseMode Of
    mmResizeRegion : Begin
                       // Return mouse to normal usage
                       ReleaseCapture;
                       FMouseMode := mmNone;

                       // Erase the resizing rubber-band box
                       DrawRubberBandBox(FBoxRect, Rect(0,0,0,0));

                       // Check the cursor is within the limiting rectangle
                       MousePos := LimitMouseMovement;

                       // Get the resize rectangle and set the region height
                       Self.Height := ScreenToClient(BuildResizeRect(MousePos).TopLeft).Y + FooterHeight;

                       // Update the Region Interface
                       FRegionIntf.rgHeight := Round((Self.Height - BannerHeight - FooterHeight) / PixelsPerMM);

                       FRegionManager.RealignRegions;
                       FRegionManager.ChangeMade;
                     End; // mmResizeRegion
    mmGroupSelect  : Begin
                       // Return mouse to normal usage
                       ReleaseCapture;
                       FMouseMode := mmNone;

                       // Erase the resizing rubber-band box
                       DrawRubberBandBox(FBoxRect, Rect(0,0,0,0));

                       // Check the cursor is still within the limiting rectangle and
                       // select the controls
                       MousePos := LimitMouseMovement;
                       FRegionManager.SelectControlsInArea(BuildSelectRect(MousePos));
                     End; // mmGroupSelect
  End; // Case FMouseMode

  Inherited MouseUp(Button, Shift, X, Y);
End; // MouseUp

//-------------------------------------------------------------------------

// Called to cause the grid to be repainted
Procedure TRegion.GridSettingsChanged;
Begin // GridSettingsChanged
  FreeAndNIL(FClientBmp);
  Invalidate;
End; // GridSettingsChanged

//-------------------------------------------------------------------------

// Moves the control to the top of the z-order (topmost)
Procedure TRegion.BringToFront (Const TheControl : TWinControl);
Var
  Idx : SmallInt;
Begin // BringToFront
  Idx := FRegionControls.IndexOf(TheControl);

  If (Idx > -1) Then
  Begin
    // Move to end of control list
    FRegionControls.Move (Idx, FRegionControls.Count - 1);

    // Tell windows to move it to the front
    TheControl.BringToFront;

    // need to redraw to cover any controls formerly on top
    TBaseDragControl(TheControl).Paint;

    FRegionIntf.rgControls.BringToFront(TBaseDragControl(TheControl).ControlDets);

    FRegionManager.ChangeMade;
  End; // If (Idx > -1)
End; // BringToFront

//------------------------------

// Moves the control to the bottom of the z-order (bottommost)
Procedure TRegion.SendToBack (Const TheControl : TWinControl);
Var
  Idx : SmallInt;
Begin // SendToBack
  Idx := FRegionControls.IndexOf(TheControl);

  If (Idx > -1) Then
  Begin
    // Move to end of control list
    FRegionControls.Move (Idx, 0);

    // Tell windows to move it to the front
    TheControl.SendToBack;

    // need to redraw to cover any controls formerly on top
    TBaseDragControl(TheControl).Paint;

    FRegionIntf.rgControls.SendToBack(TBaseDragControl(TheControl).ControlDets);

    FRegionManager.ChangeMade;
  End; // If (Idx > -1)
End; // SendToBack

//-------------------------------------------------------------------------

// Repaints the specified area (client coords) and any controls over it
Procedure TRegion.PaintRegionArea (TheControlRect : TRect);
Var
  SourceRect, aRect : TRect;
  I                 : SmallInt;
Begin // PaintRegionArea
  // Paint the client area background
  If Assigned(FClientBmp) Then
  Begin
    // Calculate where to copy the background from
    SourceRect.Top    := TheControlRect.Top - BannerHeight;
    SourceRect.Left   := TheControlRect.Left;
    SourceRect.Bottom := SourceRect.Top + (TheControlRect.Bottom - TheControlRect.Top);
    SourceRect.Right  := SourceRect.Left + (TheControlRect.Right - TheControlRect.Left);

    Canvas.CopyMode := cmSrcCopy;
    Canvas.CopyRect (TheControlRect, FClientBmp.Canvas, SourceRect);

    // Paint any controls intersecting the area
    If (FRegionControls.Count > 0) Then
    Begin
      For I := 0 To (FRegionControls.Count - 1) Do
      Begin
        If IntersectRect (aRect, TheControlRect, TBaseDragControl(FRegionControls.Items[I]).BoundsRect) Then
        Begin
          TBaseDragControl(FRegionControls.Items[I]).Paint;
        End; // If IntersectRect (aRect, TheControlRect, TBaseDragControl(FRegionControls.Items[I]).BoundsRect)
      End; // For I
    End; // If (FRegionControls.Count > 0)
  End // If Assigned(FClientBmp)
  Else
    PaintClient;
End; // PaintRegionArea

//------------------------------

// Paint any overlapping controls
Procedure TRegion.PaintTopControls (Const TheControl : TWinControl);
Var
  Idx, I : SmallInt;
  aRect  : TRect;
Begin // PaintTopControls
  // Find the Control in the z-ordered list of controls and paint all
  // controls after it
  Idx := FRegionControls.IndexOf(TheControl);

  If (Idx > -1) And (Idx < (FRegionControls.Count - 1)) Then
  Begin
    For I := (Idx + 1) To (FRegionControls.Count - 1) Do
    Begin
      If IntersectRect (aRect, TheControl.BoundsRect, TBaseDragControl(FRegionControls.Items[I]).BoundsRect) Then
      Begin
        TBaseDragControl(FRegionControls.Items[I]).Paint;
      End; // If IntersectRect (aRect, TheControl.BoundsRect, TBaseDragControl(FRegionControls.Items[I]).BoundsRect)
    End; // For I
  End; // If (Idx > -1) And (Idx < (FRegionControls.Count - 1))
End; // PaintTopControls

//-------------------------------------------------------------------------

// Called by the drag controls ParentRegion property to add the control
// into the Region's list of controls
Procedure TRegion.RegisterControl (Const TheControl : TWinControl);
Begin // RegisterControl
  // If the control isn't already present in the list then add it
  If (FRegionControls.IndexOf(TheControl) = -1) Then
  Begin
    FRegionControls.Add (TheControl);
  End; // If (FRegionControls.IndexOf(TheControl) = -1)
End; // RegisterControl

//------------------------------

// Called by the drag controls ParentRegion property to remove the control
// from the Region's list of controls
Procedure TRegion.RevokeControl (Const TheControl : TWinControl);
Var
  Idx : SmallInt;
Begin // RevokeControl
  // If the control is present in the list then remove it
  Idx := FRegionControls.IndexOf(TheControl);
  If (Idx <> -1) Then
  Begin
    FRegionControls.Delete (Idx);
  End; // If (Idx <> -1)
End; // RevokeControl

//-------------------------------------------------------------------------

// Snaps the control rectangle (in screen co-ords) to the grid for the region when moving a control
Procedure TRegion.MoveSnapToGrid (Var ControlRect : TRect; Const AllowRoundToNearest : Boolean = True);
Var
  LocalRegionRect  : TRect;
  LocalControlRect : TRect;
  CtrlHeight, CtrlWidth : SmallInt;

  //------------------------------

  Function ToGridNode(CurrPos : LongInt; Const RoundToNearest : Boolean; Const GridPixels, FirstLimit, LastLimit : LongInt) : LongInt;
  Var
    Rem : SmallInt;
  Begin // ToGridNode
    CurrPos := CurrPos - FirstLimit;

    // Calculate previous grid-node
    Result := FirstLimit + ((CurrPos Div GridPixels) * GridPixels);
    If RoundToNearest Then
    Begin
      // Check remainder to identify nearest node
      Rem := CurrPos Mod GridPixels;
      If (Rem >= (GridPixels / 2)) And (Result + GridPixels < LastLimit) Then
      Begin
        // Over half way - move to next grid-node
        Result := Result + GridPixels
      End; // If (Rem >= (GridPixels / 2)) And (Result + GridPixels < LastLimit)
    End; // If RoundToNearest
  End; // ToGridNode

  //------------------------------

  Function ToYGridNode(CurrYPos : LongInt; Const RoundToNearest : Boolean) : LongInt;
  Begin // ToYGridNode
    Result := ToGridNode(CurrYPos, RoundToNearest, FRegionManager.rmGridSizeYPixels, LocalRegionRect.Top, LocalRegionRect.Bottom);
  End; // ToYGridNode

  //------------------------------

  Function ToXGridNode(CurrXPos : LongInt; Const RoundToNearest : Boolean) : LongInt;
  Begin // ToXGridNode
    Result := ToGridNode(CurrXPos, RoundToNearest, FRegionManager.rmGridSizeXPixels, LocalRegionRect.Left, LocalRegionRect.Right);
  End; // ToXGridNode

  //------------------------------

Begin // MoveSnapToGrid
  CtrlHeight := ControlRect.Bottom - ControlRect.Top;
  CtrlWidth  := ControlRect.Right - ControlRect.Left;

  // Need to do all this locally so convert the Regions client co-ords and the control
  // rectangle to local (region) co-ordinates
  With RegionClientScrCoords Do
  Begin
    LocalRegionRect.TopLeft := ScreenToClient(TopLeft);
    LocalRegionRect.BottomRight := ScreenToClient(BottomRight);
  End; // With RegionClientScrCoords

  LocalControlRect.TopLeft := ScreenToClient(ControlRect.TopLeft);
  LocalControlRect.BottomRight := ScreenToClient(ControlRect.BottomRight);
//With LocalRegionRect Do AddDebug(Format('Region (L=%d, T=%d, R=%d, B=%d)', [Left, Top, Right, Bottom]));
//With LocalControlRect Do AddDebug(Format('Control (L=%d, T=%d, R=%d, B=%d)', [Left, Top, Right, Bottom]));

  // Check Top is within boundaries and then snap to grid
  If (LocalControlRect.Top < LocalRegionRect.Top) Then
    // Off top - move to top
    LocalControlRect.Top := LocalRegionRect.Top
  Else If (LocalControlRect.Bottom > LocalRegionRect.Bottom) Then
  Begin
    // Off bottom - check heights of region and control
    If (CtrlHeight < (LocalRegionRect.Bottom - LocalRegionRect.Top)) Then
      // Fits within region
      LocalControlRect.Top := ToYGridNode(LocalRegionRect.Bottom - CtrlHeight + 1, False)
    Else
      // Control is bigger than region - move to top
      LocalControlRect.Top := LocalRegionRect.Top;
  End // If (LocalControlRect.Bottom > LocalRegionRect.Bottom)
  Else
  Begin
    // OK - snap to grid
    LocalControlRect.Top := ToYGridNode(LocalControlRect.Top, AllowRoundToNearest);
    LocalControlRect.Bottom := LocalControlRect.Top + CtrlHeight;

    If (LocalControlRect.Bottom > LocalRegionRect.Bottom) Then
    Begin
      LocalControlRect.Top := ToYGridNode(LocalRegionRect.Bottom - CtrlHeight, False);
    End; // If (LocalControlRect.Bottom > LocalRegionRect.Bottom)
  End; // Else

  // Check Left is within boundaries and then snap to grid
  If (LocalControlRect.Left < LocalRegionRect.Left) Then
    // Off Left - move to Left
    LocalControlRect.Left := LocalRegionRect.Left
  Else If (LocalControlRect.Right > LocalRegionRect.Right) Then
  Begin
    // Off right - check widths of region and control
    If (CtrlWidth < (LocalRegionRect.Right - LocalRegionRect.Left)) Then
      // Fits within region
      LocalControlRect.Left := ToXGridNode(LocalRegionRect.Right - CtrlWidth + 1, False)
    Else
      // Control is wider than region - move to Left
      LocalControlRect.Left := LocalRegionRect.Left;
  End // If (LocalControlRect.Right > LocalRegionRect.Right)
  Else
  Begin
    // OK - snap to grid
    LocalControlRect.Left := ToXGridNode(LocalControlRect.Left, AllowRoundToNearest);
    LocalControlRect.Right := LocalControlRect.Left + CtrlWidth;

    If (LocalControlRect.Right > LocalRegionRect.Right) Then
    Begin
      LocalControlRect.Left := ToXGridNode(LocalRegionRect.Right - CtrlWidth, False);
    End; // If (LocalControlRect.Right > LocalRegionRect.Right)
  End; // Else


  // Update Right/Bottom to reflect changes
  LocalControlRect.Right := LocalControlRect.Left + CtrlWidth;
  LocalControlRect.Bottom := LocalControlRect.Top + CtrlHeight;
//With LocalControlRect Do AddDebug(Format('Control (L=%d, T=%d, R=%d, B=%d)', [Left, Top, Right, Bottom]));

  // Update the Control rectangle parameter
  ControlRect.TopLeft := ClientToScreen(LocalControlRect.TopLeft);
  ControlRect.BottomRight := ClientToScreen(LocalControlRect.BottomRight);
//AddDebug('');
End; // MoveSnapToGrid

//-------------------------------------------------------------------------

// Selects any controls intersecting the specified Screen area
Procedure TRegion.SelectByScreenArea (Const ScreenArea : TRect; Var FocusControls : Boolean);
Var
  LocalCoords, TempRect : TRect;
  oControl              : TBaseDragControl;
  I                     : SmallInt;
Begin // SelectByScreenArea
  If (FRegionControls.Count > 0) Then
  Begin
    // convert to region client-area co-ordinates
    LocalCoords.TopLeft := ScreenToClient(ScreenArea.TopLeft);
    LocalCoords.BottomRight := ScreenToClient(ScreenArea.BottomRight);

    For I := 0 To (FRegionControls.Count - 1) Do
    Begin
      oControl := TBaseDragControl(FRegionControls[I]);
      If oControl.Visible And IntersectRect (TempRect, LocalCoords, oControl.BoundsRect) Then
      Begin
        // This mechanism is used to focus the first selected control - it must be done in
        // this way to avoid breaking the list of selected controls
        If FocusControls Then
        Begin
          oControl.SetFocus;
          FocusControls := False;
        End; // If FocusControls

        FRegionManager.SelectControl (oControl, True);
      End; // If oControl.Visible And IntersectRect (TempRect, LocalCoords, oControl.BoundsRect)
    End; // For I
  End; // If (FRegionControls.Count > 0)
End; // SelectByScreenArea

//-------------------------------------------------------------------------

// Snaps the resizing portion of the sizing rectangle to the grid
Procedure TRegion.SizeSnapToGrid (Var ControlRect : TRect; Const SizeOp : THandles);
Var
  LocalControlRect : TRect;
  Rem              : SmallInt;
Begin // SizeSnapToGrid
  // Convert coords to Region Client-Area co-ords from screen co-ords
  LocalControlRect.TopLeft := ScreenToClient(ControlRect.TopLeft);
  LocalControlRect.BottomRight := ScreenToClient(ControlRect.BottomRight);

  // Adjust to account for header
  LocalControlRect.Top := LocalControlRect.Top - BannerHeight;
  LocalControlRect.Bottom := LocalControlRect.Bottom - BannerHeight;
  LocalControlRect.Left := LocalControlRect.Left - LeftBorderWidth;
  LocalControlRect.Right := LocalControlRect.Right - LeftBorderWidth;

  If (SizeOp In [TopLeft, TopCentre, TopRight]) Then
  Begin
    // Top
    Rem := (LocalControlRect.Top Mod FregionManager.rmGridSizeYPixels);
    If (Rem <> 0) Then
    Begin
      LocalControlRect.Top := (LocalControlRect.Top Div FregionManager.rmGridSizeYPixels) * FregionManager.rmGridSizeYPixels;
      If (Rem >= (FregionManager.rmGridSizeYPixels / 2)) Then
        LocalControlRect.Top := LocalControlRect.Top + FregionManager.rmGridSizeYPixels
    End; // If (Rem <> 0)
  End; // If (SizeOp In [TopLeft, TopCentre, TopRight])

  If (SizeOp In [TopLeft, CentreLeft, BottomLeft]) Then
  Begin
    // Left
    Rem := (LocalControlRect.Left Mod FregionManager.rmGridSizeXPixels);
    If (Rem <> 0) Then
    Begin
      LocalControlRect.Left := (LocalControlRect.Left Div FregionManager.rmGridSizeXPixels) * FregionManager.rmGridSizeXPixels;
      If (Rem >= (FregionManager.rmGridSizeXPixels / 2)) Then
        LocalControlRect.Left := LocalControlRect.Left + FregionManager.rmGridSizeXPixels
    End; // If (Rem <> 0)
  End; // If (SizeOp In [TopLeft, CentreLeft, BottomLeft])

  If (SizeOp In [TopRight, CentreRight, BottomRight]) Then
  Begin
    // Right
    Rem := (LocalControlRect.Right Mod FregionManager.rmGridSizeXPixels);
    If (Rem <> 0) Then
    Begin
      LocalControlRect.Right := (LocalControlRect.Right Div FregionManager.rmGridSizeXPixels) * FregionManager.rmGridSizeXPixels;
      If (Rem >= (FregionManager.rmGridSizeXPixels / 2)) Then
        LocalControlRect.Right := LocalControlRect.Right + FregionManager.rmGridSizeXPixels
    End; // If (Rem <> 0)
  End; // If (SizeOp In [TopRight, CentreRight, BottomRight])

  If (SizeOp In [BottomLeft, BottomCentre, BottomRight]) Then
  Begin
    // Bottom
    Rem := (LocalControlRect.Bottom Mod FregionManager.rmGridSizeYPixels);
    If (Rem <> 0) Then
    Begin
      LocalControlRect.Bottom := (LocalControlRect.Bottom Div FregionManager.rmGridSizeYPixels) * FregionManager.rmGridSizeYPixels;
      If (Rem >= (FregionManager.rmGridSizeYPixels / 2)) Then
        LocalControlRect.Bottom := LocalControlRect.Bottom + FregionManager.rmGridSizeYPixels
    End; // If (Rem <> 0)
  End; // If (SizeOp In [BottomLeft, BottomCentre, BottomRight])

  // Adjust to account for headers
  LocalControlRect.Top := LocalControlRect.Top + BannerHeight;
  LocalControlRect.Bottom := LocalControlRect.Bottom + BannerHeight;
  LocalControlRect.Left := LocalControlRect.Left + LeftBorderWidth;
  LocalControlRect.Right := LocalControlRect.Right + LeftBorderWidth;

  // Convert Local coords back to Screen co-ords
  ControlRect.TopLeft := ClientToScreen(LocalControlRect.TopLeft);
  ControlRect.BottomRight := ClientToScreen(LocalControlRect.BottomRight);
End; // SizeSnapToGrid

//-------------------------------------------------------------------------

// Takes the offset within the region and converts it to a MM position within the
// region which is passed through the RegionManager to be displayed on screen
Procedure TRegion.UpdateCursorPos (X, Y : LongInt; Const FromRegion : Boolean = True);
Begin // UpdateCursorPos
  If Assigned(FRegionManager.OnUpdateCursorPosition) Then
  Begin
    // Check the mouse is within the Region's client area
    If (Y > BannerHeight) Then
    Begin
//AddDebug('TRegion.UpdateCursorPos (X=' + IntToStr(X) + ', Y=' + IntToStr(Y) + ')');
      FRegionManager.OnUpdateCursorPosition (InMM(X - LeftBorderWidth), InMM(Y - BannerHeight));
    End // If (Y > BannerHeight)
    Else
      FRegionManager.OnUpdateCursorPosition (-1, -1);
  End; // If Assigned(FRegionManager.OnUpdateCursorPosition)

  If FromRegion And Assigned(FRegionManager.OnUpdateControlInfo) Then
  Begin
    // blank out the control info for the region
    FRegionManager.OnUpdateControlInfo('', '', '', '', '');
  End; // If FromRegion And Assigned(FRegionManager.OnUpdateControlInfo)
End; // UpdateCursorPos

//-------------------------------------------------------------------------

// Updates the sorting information on controls within the region using NextSortNo
// as the first sorting index and updates the region caption
Procedure TRegion.UpdateSortDetails(Var NextSortNo : SmallInt);
Var
  oControl               : TBaseDragControl;
  oDBFControl            : TVRWDBFieldControl;
  oFMLControl            : TVRWFormulaControl;
  oRegion                : TRegion;
  OrderedSortControls    : TStringList;
  I                      : SmallInt;
  NewSortFields          : ShortString;
  SortChar               : String[1];
  sFieldDesc, sSortOrder : ShortString;
  bPageBrk               : Boolean;
Begin // UpdateSortDetails
  If (FRegionIntf.rgType = rtSectionHdr) Then
  Begin
    NewSortFields := '';

    If (FRegionControls.Count > 0) Then
    Begin
      OrderedSortControls := TStringList.Create;
      Try
        // Run through and identify any sorted DB Fields and add them into the
        // stringlist for sorting into left->right, top->bottom order
        For I := 0 To (FRegionControls.Count - 1) Do
        Begin
          oControl := TBaseDragControl(FRegionControls[I]);
          If oControl.Visible Then
          Begin
            If (oControl Is TVRWDBFieldControl) Then
            Begin
              oDBFControl := TVRWDBFieldControl(oControl);
              If (Length(oDBFControl.DBFieldDets.vcSortOrder) >= 2) And
                 (oDBFControl.DBFieldDets.vcSortOrder[1] In ['0'..'9']) And
                 (oDBFControl.DBFieldDets.vcSortOrder[2] In ['A', 'D']) Then
              Begin
                // Sorted DB Field
                OrderedSortControls.AddObject (Format('%10.10d %10.10d %s %s', [oDBFControl.DBFieldDets.vcTop, oDBFControl.DBFieldDets.vcLeft, oDBFControl.DBFieldDets.vcFieldName, oDBFControl.Name]), oDBFControl);
              End; // If (Length(oDBFControl.DBFieldDets.vcSortOrder) >= 2) ...
            End // If (oControl Is TVRWDBFieldControl)
            Else If (oControl Is TVRWFormulaControl) Then
            Begin
              oFMLControl := TVRWFormulaControl(oControl);
              If (Length(oFMLControl.FormulaDets.vcSortOrder) >= 2) And
                 (oFMLControl.FormulaDets.vcSortOrder[1] In ['0'..'9']) And
                 (oFMLControl.FormulaDets.vcSortOrder[2] In ['A', 'D']) Then
              Begin
                // Sorted DB Field
                OrderedSortControls.AddObject (Format('%10.10d %10.10d %s', [oFMLControl.FormulaDets.vcTop, oFMLControl.FormulaDets.vcLeft, oFMLControl.FormulaDets.vcFormulaName]), oFMLControl);
              End; // If (Length(oDBFControl.DBFieldDets.vcSortOrder) >= 2) ...
            End // If (oControl Is TVRWFormulaControl)
          End; // If oControl.Visible
        End; // For I

        If (OrderedSortControls.Count > 0) Then
        Begin
          // Sort into left->right, top->bottom order
          OrderedSortControls.Duplicates := dupAccept;
          OrderedSortControls.Sorted := True;

          // Update the display string for the region's caption bar and reset each
          // controls sort index to ensure correctness
          For I := 0 To (OrderedSortControls.Count - 1) Do
          Begin
            oControl := TBaseDragControl(OrderedSortControls.Objects[I]);
            If (oControl Is TVRWDBFieldControl) Then
            Begin
              sSortOrder := TVRWDBFieldControl(oControl).DBFieldDets.vcSortOrder;
              bPageBrk := TVRWDBFieldControl(oControl).DBFieldDets.vcPageBreak;
              sFieldDesc := TVRWDBFieldControl(oControl).DBFieldDets.vcFieldName;
            End // If (oControl Is TVRWDBFieldControl)
            Else
            Begin
              sSortOrder := TVRWFormulaControl(oControl).FormulaDets.vcSortOrder;
              bPageBrk := TVRWFormulaControl(oControl).FormulaDets.vcPageBreak;
              sFieldDesc := TVRWFormulaControl(oControl).FormulaDets.vcFormulaName;
            End; // Else

            If (I > 0) Then NewSortFields := NewSortFields + ' + ';
            NewSortFields := NewSortFields + UpperCase(Trim(sFieldDesc)) + '(';

            SortChar := IfThen (sSortOrder[Length(sSortOrder)] = 'A', 'A', 'D');

            sSortOrder := IntToStr(NextSortNo) + SortChar;
            If (oControl Is TVRWDBFieldControl) Then
              TVRWDBFieldControl(oControl).DBFieldDets.vcSortOrder := sSortOrder
            Else
              TVRWFormulaControl(oControl).FormulaDets.vcSortOrder := sSortOrder;

            If bPageBrk Then
              NewSortFields := NewSortFields + SortChar + 'P)'
            Else
              NewSortFields := NewSortFields + SortChar + ')';

            If ShowSortDebug Then
            Begin
              // Built in debugging hanging of the /SortDebug command line switch
              NewSortFields := NewSortFields + '(' + sSortOrder + ')';
            End; // If ShowSortDebug

            Inc(NextSortNo);
          End; // For I
        End; // If (OrderedSortControls.Count > 0)
      Finally
        FreeAndNIL(OrderedSortControls);
      End; // Try..Finally
    End; // If (FRegionControls.Count > 0)

//    If (NewSortFields <> FSortFields) Then
    Begin
      UpdateBreakInfo (NewSortFields);

      // Find and update the Section Footer
      For I := 0 To (FRegionManager.rmRegions.Count - 1) Do
      Begin
        oRegion := TRegion(FRegionManager.rmRegions[I]);
        If (oRegion.reRegionDets.rgType = rtSectionFtr) And (oRegion.reRegionDets.rgSectionNumber = FRegionIntf.rgSectionNumber) Then
        Begin
          oRegion.UpdateBreakInfo (NewSortFields);
          Break;
        End; // If (oRegion.reRegionDets.rgType = ...
      End; // For I
    End; // If (NewSortFields <> FSortFields)
  End // If (FRegionIntf.rgType = rtSectionHdr)
  Else
    FSortFields := '';
End; // UpdateSortDetails

//------------------------------

// Updates the Regions Sorting/Breaking info shown in the region caption
Procedure TRegion.UpdateBreakInfo (Const BreakInfo : ShortString);
Begin // UpdateBreakInfo
  FSortFields := BreakInfo;

  // Repaint the region header to update the caption bar, need to destroy
  // the cached image to get it to refresh
  FreeAndNIL(FHeaderBmp);
  PaintHeader;
End; // UpdateBreakInfo

//-------------------------------------------------------------------------

// Handler for 'Add Text' on Region's popup menu
Procedure TRegion.OnAddText(Sender: TObject);
Begin // OnAddText
  FRegionManager.AddControl(dctText);
  With ScreenToClient(PopupMenu.PopupPoint) Do FRegionManager.AddingControl(Self, X, Y);
End; // OnAddText

//------------------------------

Procedure TRegion.OnAddImage(Sender: TObject);
Begin // OnAddImage
  FRegionManager.AddControl(dctImage);
  With ScreenToClient(PopupMenu.PopupPoint) Do FRegionManager.AddingControl(Self, X, Y);
End; // OnAddImage

//------------------------------

Procedure TRegion.OnAddBox(Sender: TObject);
Begin // OnAddBox
  FRegionManager.AddControl(dctBox);
  With ScreenToClient(PopupMenu.PopupPoint) Do FRegionManager.AddingControl(Self, X, Y);
End; // OnAddBox

//------------------------------

Procedure TRegion.OnAddDBField(Sender: TObject);
Begin // OnAddDBField
  FRegionManager.AddControl(dctDBField);
  With ScreenToClient(PopupMenu.PopupPoint) Do FRegionManager.AddingControl(Self, X, Y);
End; // OnAddDBField

//------------------------------

Procedure TRegion.OnAddFormula(Sender: TObject);
Begin // OnAddFormula
  FRegionManager.AddControl(dctFormula);
  With ScreenToClient(PopupMenu.PopupPoint) Do FRegionManager.AddingControl(Self, X, Y);
End; // OnAddFormula

//------------------------------

Procedure TRegion.OnAddReportProps(Sender: TObject);
Begin // OnAddReportProps
//  AddDebug('TRegion.OnAddReportProps - Add Properties controls into Report Header');
  FRegionManager.AddControl(dctReportProperties);
  With ScreenToClient(PopupMenu.PopupPoint) Do FRegionManager.AddingControl(Self, X, Y);
End; // OnAddReportProps

//------------------------------

// Region Popup Menu handlers
Procedure TRegion.OnPopupPaste(Sender: TObject);
Begin // OnPopupPaste
//  AddDebug('TRegion.OnPopupPaste');
  FRegionManager.Paste(FRegionIntf, FClickPos);
End; // OnPopupPaste
//------------------------------

Procedure TRegion.OnHideRegion(Sender: TObject);
Begin // OnHideRegion
  Visible := False;
  FRegionIntf.rgVisible := False;
  FRegionManager.ChangeMade;
  FRegionManager.RealignRegions;
End; // OnHideRegion

//------------------------------

Procedure TRegion.OnControlsTree(Sender: TObject);
Begin // OnControlsTree
  FRegionManager.ShowControlsTree;  // (self)
End; // OnControlsTree

//-------------------------------------------------------------------------

Function TRegion.GetRegionDesc : ShortString;
Begin // GetRegionDesc
  Result := FRegionIntf.rgDescription;
End; // GetRegionDesc

//-------------------------------------------------------------------------

procedure TRegion.OnPopupMenu(Sender: TObject);
begin
  FPasteMenu.Enabled := FRegionManager.rmReport.CanPaste;
end;

function TRegion.GetLeftMargin: Integer;
begin
  Result := FBannerIcon.Width;
end;

Initialization
  ShowSortDebug := FindCmdLineSwitch('SortDebug', ['-','/'], True);
end.
