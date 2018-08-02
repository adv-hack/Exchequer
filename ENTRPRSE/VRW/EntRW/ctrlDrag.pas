unit ctrlDrag;

interface

Uses Classes, Controls, Dialogs, Forms, Graphics, Messages, Math, SysUtils, Windows,
     VRWReportIF,
     DesignerTypes,   // Common designer types and interfaces
     Region           // TRegion
     ;

Type
  TControlMouseMode = (cmmNone, cmmCanResize, cmmResize, cmmMove);

  //------------------------------

  TBaseDragControl = class(TCustomControl)
  protected
    // Reference to the RegionManager which performs common operations across
    // regions and provides a central store for common information
    FRegionManager : IRegionManager;

    // Reference to a control object
    FControlDets : IVRWControl;

    // Array of co-ordinates for the controls sizing handles
    FHandles : Array [TopLeft..BottomRight] Of TRect;

    // Tracks the current sizing type
    FSizeType : THandles;

    // Stores the limits of the mouse movement whilst performing a particular resize/move operation
    FMaxMouseMove : TRect;
    // Stores the co-ords of the last rubber-band rectangle drawn
    FBoxRect : TRect;
    // The original click screen co-ords when moving a control
    FMoveOrigin : TPoint;
    // Used by the Mouse Down/Move/Up events to store the control size in screen co-ords when
    // moving and resizing
    FScrSizeRect : TRect;

    // Used internally by the SelectMove method for recording movement operations
    FSelMove1, FSelMove2 : TRect;

    // Used by the Mouse Down/Move/Up events to store the initial click co-ords
    // for moving and resizing
    FXOffset : LongInt;
    FYOffset : LongInt;

    // The last point that the cursor touched on this control
    FHitTest : TPoint;

    // Keeps track of what we are doing with the mouse
    FMouseMode : TControlMouseMode;

    // Indicates whether the control is transparent or not
    FIsTransparent : Boolean;
    // Suspends the Paint
    FSuspendPaint : Boolean;

    // Overridden VCL functions -----------
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    // Intercepted Windows Messages -------
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetDLGCode(var Message: TMessage); message WM_GETDLGCODE;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;

    // Internal ---------------------------
    Function GetControlDets : IVRWControl;
    Function GetControlSummary : ShortString; Virtual;
    Function GetFieldAlignment : TAlignment;
    Function GetPositionDesc : ShortString;
    Function GetPrintIf : Boolean; Virtual;
    Function GetRangeFilter : Boolean; Virtual;
    Function GetRegion : TRegion;
    Procedure SetRegion (Value : TRegion); Virtual;
    Function GetSelectionCriteria : Boolean; Virtual;

    // Calculates the rubber-band box co-ords when resizing the control for the specifed
    // mouse position
    Function BuildResizeRect(Const MousePos : TPoint) : TRect;
    // Calculates the rectangles that the resize cursors will be shown in
    procedure CalcHandleRects;
    // Draws a rubber-band move/resize/selection box on the screen canvas
    Procedure DrawRubberBandBox (Const StartRect, EndRect : TRect);
    // Called to identify internally whether the field is sorted
    Function IsSorted : Boolean; Virtual;
    // Get the current mouse position - needed so we can ensure the mouse stays
     // within the client area we are working with
    Function LimitMouseMovement : TPoint;
    Procedure PaintBackGround;
    // Paints the controls detail - overriden in descendants
    procedure PaintControl; virtual;
    // Paints the control Border taking into account the selected status
    procedure PaintHandles; virtual;
    // Returns TRUE if the control is visible and should be painted
    Function WantPaint : Boolean;
  Public
    Property ControlDets : IVRWControl Read GetControlDets;
    // Returns the summary of the controls type & settings to be shown on the designer window
    Property ControlSummary : ShortString Read GetControlSummary;
    Property FieldAlignment : TAlignment Read GetFieldAlignment;
    Property ParentRegion : TRegion Read GetRegion Write SetRegion;
    // Returns the summary of the controls position / size to be shown on the designer window
    Property PositionDesc : ShortString Read GetPositionDesc;
    Property PrintIf : Boolean Read GetPrintIf;
    Property RangeFilter : Boolean Read GetRangeFilter;
    Property SelectionCriteria : Boolean Read GetSelectionCriteria;

    Constructor Create (RegionManager: IRegionManager; ControlDets : IVRWControl); Reintroduce;
    Destructor Destroy; Override;

    // Calculates the rubber-band box co-ords when moving a control for the specifed
    // mouse position
    Function BuildMoveRect(Const MousePos, MoveOrigin : TPoint) : TRect;

    // Override Paint and make it public
    procedure Paint; override;

    // Moves the control to the top of the z-order (topmost)
    Procedure BringToFront;
    // Calculates a size for the control based on the passed text - obviously
    // won't work for bitmaps, boxes and lines!
    Procedure CalcInitialSize (Const SizeText : ShortString);
    // 'Deletes' the control by hiding it - can't actually destroy it as we need the control
    // and info to stay around for undeletes.
    Procedure Delete;
    // Called when building a popup menu for the control, the set contains all
    // possible menu items and the control should remove those that don't apply
    Procedure DisableContextItems(Var MenuItemSet : TControlContextItemsSet); virtual; abstract;
    // Called by the IRegionManager.BroadcastKeyboardOp method to perform the
    // KeyDown processing for this control
    Procedure KeyboardOp(var Key: Word; Shift: TShiftState);
    Procedure PaintForeGround; virtual;
    // Restores a previously-deleted control (see Delete above).
    procedure Restore;
    // Called when a group of controls is being operated on
    Procedure SelectMove (Const XOff, YOff : SmallInt; Const Mode : TSelectMoveMode);
    // Moves the control to the bottom of the z-order (bottommost)
    Procedure SendToBack;
    // Snaps the control to the Parent Region's Grid
    Procedure SnapToGrid;
    // Updates the ControlDets object with changes to position/size/etc...
    Procedure UpdateControlDets;
    // Updates the controls font to that passed
    Procedure UpdateFont(Const NewFont : TFont);
  End; // TBaseDragControl

implementation

Uses DesignerUtil;

//=========================================================================

Constructor TBaseDragControl.Create (RegionManager: IRegionManager; ControlDets : IVRWControl);
Begin // Create
  Inherited Create(RegionManager.rmScrollArea);

  FControlDets := ControlDets;

  FRegionManager := RegionManager;
  PopupMenu := FRegionManager.rmControlsPopupMenu;

  // Size the control
  SetBounds (LeftBorderWidth + FControlDets.vcLeft * PixelsPerMM,
             BannerHeight + FControlDets.vcTop * PixelsPerMM,
             FControlDets.vcWidth * PixelsPerMM,
             FControlDets.vcHeight * PixelsPerMM); // LTWH

  FIsTransparent := True;
  FMouseMode := cmmNone;
  Visible := Not ControlDets.vcDeleted;

  TabStop := True;
End; // Create

//------------------------------

procedure TBaseDragControl.CreateParams(var Params: TCreateParams);
Begin // CreateParams
  inherited CreateParams(Params);

  With Params Do
    ExStyle := ExStyle Or WS_EX_TRANSPARENT;
End; // CreateParams

//------------------------------

Destructor TBaseDragControl.Destroy;
Begin // Destroy
  If FRegionManager.IsSelected(Self) Then FRegionManager.DeSelectControl(Self);
  If Assigned(Parent) Then TRegion(Parent).RevokeControl (Self);

  FRegionManager := NIL;
  FControlDets := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Richt-click - display popup menu
procedure TBaseDragControl.WMContextMenu(var Message: TWMContextMenu);
Begin // WMContextMenu
  FRegionManager.SelectPopupControl(Self, Point(Message.Pos.X, Message.Pos.Y));
  Inherited;
End; // WMContextMenu

//------------------------------

Procedure TBaseDragControl.WMEraseBkgnd(var Message: TWmEraseBkgnd);
Begin // WMEraseBkgnd
  // This message must be intercepted otherwise the background area
  // of the control is cleared to the background colour
End; // WMEraseBkgnd

//------------------------------

// Tell windows we want the cursor keys sent to the control
procedure TBaseDragControl.WMGetDLGCode(var Message: TMessage);
begin
  Message.Result := DLGC_WANTARROWS;
end;

//------------------------------

// Double-Click
procedure TBaseDragControl.WMLButtonDblClk(var Message: TWMLButtonDblClk);
Begin // WMLButtonDblClk
  FRegionManager.DisplayControlOptions(Self);
End; // WMLButtonDblClk

//------------------------------

procedure TBaseDragControl.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  FHitTest := SmallPointToPoint(Msg.Pos);
end;

//------------------------------

procedure TBaseDragControl.WMSetCursor(var Msg: TWMSetCursor);
var
  Cur: HCURSOR;
  I : THandles;
begin
  Cur := 0;

  FHitTest := ScreenToClient(FHitTest);

  // Can't resize multiple controls
  If FRegionManager.JustMe(Self) Then
    For I := TopLeft To BottomRight Do
      If (Cur = 0) Then
        If ((FHitTest.X >= FHandles[I].Left) And (FHitTest.X <= FHandles[I].Right)) And
           ((FHitTest.Y >= FHandles[I].Top) And (FHitTest.Y <= FHandles[I].Bottom)) Then
        Begin
          Case I Of
            TopLeft      : Cur := LoadCursor(0, IDC_SIZENWSE);
            TopCentre    : Cur := LoadCursor(0, IDC_SIZENS);
            TopRight     : Cur := LoadCursor(0, IDC_SIZENESW);
            CentreLeft   : Cur := LoadCursor(0, IDC_SIZEWE);
            CentreRight  : Cur := LoadCursor(0, IDC_SIZEWE);
            BottomLeft   : Cur := LoadCursor(0, IDC_SIZENESW);
            BottomCentre : Cur := LoadCursor(0, IDC_SIZENS);
            BottomRight  : Cur := LoadCursor(0, IDC_SIZENWSE);
          End; { Case }

          If (Cur <> 0) Then
            FSizeType := I;
        End; // If ((FHitTest.X >= ...

  If (Cur <> 0) Then
  Begin
    SetCursor(Cur);
    FMouseMode := cmmCanResize;
  End // If (Cur <> 0)
  Else
  Begin
    FMouseMode := cmmNone;
    Inherited;
  End; // Else

  // Pass the control to the RegionManager so that it can update whatever info
  // we show on-screen
  FRegionManager.UpdateFooterStatus(Self);
end;

//-------------------------------------------------------------------------

procedure TBaseDragControl.DoEnter;
Begin // DoEnter
  If (Not FRegionManager.IsSelected(Self)) Then
  Begin
    // MH 18/07/05: This should only occur when keyboard tabbing to change focus
    FRegionManager.SelectControl (Self, False, True);
  End; // If (Not FRegionManager.IsSelected(Self))

  Inherited;
End; // DoEnter

procedure TBaseDragControl.DoExit;
Begin // DoExit
// MH 18/07/05: Removed as was causing problems with multi-select
//
//  If FRegionManager.IsSelected(Self) Then
//  Begin
//    FRegionManager.DeSelectControl (Self);
//  End; // If FRegionManager.IsSelected(Self)

  Inherited;
End; // DoExit

//-------------------------------------------------------------------------

// Called to identify internally whether the field is sorted
Function TBaseDragControl.IsSorted : Boolean;
Begin // IsSorted
  Result := False;
End; // IsSorted

//-------------------------------------------------------------------------

// Get the current mouse position - needed so we can ensure the mouse stays
 // within the client area we are working with
Function TBaseDragControl.LimitMouseMovement : TPoint;
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
    SetCursorPos (Result.X, Result.Y);
  End; // If (Coords.X <> Result.X) Or (Coords.Y <> Result.Y)
End; // LimitMouseMovement

//------------------------------

// Draws a rubber-band move/resize/selection box on the screen canvas
Procedure TBaseDragControl.DrawRubberBandBox (Const StartRect, EndRect : TRect);
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

// Calculates the rubber-band box co-ords when moving a control for the specifed
// mouse position
Function TBaseDragControl.BuildMoveRect(Const MousePos, MoveOrigin : TPoint) : TRect;
Begin // BuildMoveRect
  Result.Top    := MousePos.Y - MoveOrigin.Y;
  Result.Left   := MousePos.X - MoveOrigin.X;
  Result.Bottom := Result.Top + Self.Height;
  Result.Right  := Result.Left + Self.Width;

  // Snap size to grid - as this could be a different region entirely this
  // is done through the RegionManager which identifies the appropriate
  // region using the mouse position
  FRegionManager.SnapToRegionGrid (MousePos, Result);
End; // BuildMoveRect

//------------------------------

// Calculates the rubber-band box co-ords when resizing the control for the specifed
// mouse position
Function TBaseDragControl.BuildResizeRect(Const MousePos : TPoint) : TRect;
Begin // BuildResizeRect
  Result := FScrSizeRect;
  Case FSizeType Of
    TopLeft      : Result.TopLeft := MousePos;
    TopCentre    : Result.Top := MousePos.Y;
    TopRight     : Begin
                     Result.Top := MousePos.Y;
                     Result.Right := MousePos.X;
                   End;
    CentreLeft   : Result.Left := MousePos.X;
    CentreRight  : Result.Right := MousePos.X;
    BottomLeft   : Begin
                     Result.Left := MousePos.X;
                     Result.Bottom := MousePos.Y;
                   End;
    BottomCentre : Result.Bottom := MousePos.Y;
    BottomRight  : Result.BottomRight := MousePos;
  End; // Case FSizeType

  // Snap size to grid
  ParentRegion.SizeSnapToGrid(Result, FSizeType);
End; // BuildResizeRect

//------------------------------

procedure TBaseDragControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  MousePos  : TPoint;
  ProcessMD : Boolean;
begin
  Inherited MouseDown (Button, Shift, X, Y);

  If (Not (csDesigning In ComponentState)) Then
  Begin
    ProcessMD := True;

    If (Button = mbLeft) And CanFocus Then
    Begin
      // MH 18/07/05: Heavily revised this section to work around problems with
      // multi-selecting and deselecting of controls
      If (Not FRegionManager.IsSelected(Self)) Then
      Begin
        // Not selected - autoselect - add into existing group for Ctrl/Shift + Click
        FRegionManager.SelectControl (Self, (ssCtrl In Shift) Or (ssShift In Shift), True)
      End // If (Not FRegionManager.IsSelected(Self))
      Else If (ssCtrl In Shift) Or (ssShift In Shift) Then
      Begin
        // Control is selected but Ctrl/Shift+Click deselects the control, we then want
        // to skip the rest of the code as otherwise we get unpleasant side effects
        FRegionManager.DeSelectControl (Self);
        ProcessMD := False;
      End; // If (ssCtrl In Shift) Or (ssShift In Shift)

      If Not ((ssCtrl In Shift) Or (ssShift In Shift)) Then
        SetFocus;
    End; // If (Button = mbLeft) And CanFocus

    If (Button = mbLeft) And ProcessMD Then
    Begin
      If (FMouseMode = cmmCanResize) Then
        FMouseMode := cmmResize
      Else
        FMouseMode := cmmMove;

      Case FMouseMode Of
        cmmMove       : Begin
                          // Capture all mouse messages
                          SetCapture(Self.Handle);

                          // Record the original click location
                          FMoveOrigin := Point(X, Y);

                          // Generate the maximum mouse movement dimensions for resizing
                          FMaxMouseMove := FRegionManager.CalcMaxMouseMove;

                          // Check the cursor is within the limiting rectangle
                          MousePos := LimitMouseMovement;

                          // Draw move/size box on the screen
                          FBoxRect := BuildMoveRect(MousePos, FMoveOrigin);
                          DrawRubberBandBox (Rect(0,0,0,0), FBoxRect);

                          If FRegionManager.IsSelected(Self) Then
                          Begin
                            // pass any movement stuff to controller
                            FRegionManager.SelectMove (Self, 0, 0, smmMouseDown);
                          End; // If FRegionManager.IsSelected(Self)
                        End; // cmmNone

        cmmResize     : Begin
                          // Capture all mouse messages
                          SetCapture(Self.Handle);

                          // Get controls position & size in screen coords
                          FScrSizeRect := BoundsRect;
                          FScrSizeRect.TopLeft := Parent.ClientToScreen(FScrSizeRect.TopLeft);
                          FScrSizeRect.BottomRight := Parent.ClientToScreen(FScrSizeRect.BottomRight);

                          // Generate a Rect limiting the mouse movement for this operation to the
                          // applicable part of the regions client area
                          FMaxMouseMove := ParentRegion.RegionClientScrCoords;
                          Case FSizeType Of
                            TopLeft      : Begin
                                             FMaxMouseMove.Right := FScrSizeRect.Right - FRegionManager.rmMinControlWidth;
                                             FMaxMouseMove.Bottom := FScrSizeRect.Bottom - FRegionManager.rmMinControlHeight;
                                           End;
                            TopCentre    : Begin
                                             FMaxMouseMove.Left := FScrSizeRect.Left;
                                             FMaxMouseMove.Bottom := FScrSizeRect.Bottom - FRegionManager.rmMinControlHeight;
                                             FMaxMouseMove.Right := FScrSizeRect.Right;
                                           End;
                            TopRight     : Begin
                                             FMaxMouseMove.Bottom := FScrSizeRect.Bottom - FRegionManager.rmMinControlHeight;
                                             FMaxMouseMove.Left := FScrSizeRect.Left + FRegionManager.rmMinControlWidth;
                                           End;
                            CentreLeft   : Begin
                                             FMaxMouseMove.Top := FScrSizeRect.Top;
                                             FMaxMouseMove.Right := FScrSizeRect.Right - FRegionManager.rmMinControlWidth;
                                             FMaxMouseMove.Bottom := FScrSizeRect.Bottom;
                                           End;
                            CentreRight  : Begin
                                             FMaxMouseMove.Top := FScrSizeRect.Top;
                                             FMaxMouseMove.Left := FScrSizeRect.Left + FRegionManager.rmMinControlWidth;
                                             FMaxMouseMove.Bottom := FScrSizeRect.Bottom;
                                           End;
                            BottomLeft   : Begin
                                             FMaxMouseMove.Top := FScrSizeRect.Top + FRegionManager.rmMinControlHeight;
                                             FMaxMouseMove.Right := FScrSizeRect.Right - FRegionManager.rmMinControlWidth;
                                           End;
                            BottomCentre : Begin
                                             FMaxMouseMove.Left := FScrSizeRect.Left;
                                             FMaxMouseMove.Top := FScrSizeRect.Top + FRegionManager.rmMinControlHeight;
                                             FMaxMouseMove.Right := FScrSizeRect.Right;
                                           End;
                            BottomRight  : Begin
                                             FMaxMouseMove.Top := FScrSizeRect.Top + FRegionManager.rmMinControlHeight;
                                             FMaxMouseMove.Left := FScrSizeRect.Left + FRegionManager.rmMinControlWidth;
                                           End;
                          End; // Case FSizeType

                          // Check the cursor is within the limiting rectangle
                          MousePos := LimitMouseMovement;

                          // Calculate and draw the resizing rubber-band box
                          FBoxRect := BuildResizeRect(MousePos);
                          DrawRubberBandBox(Rect(0,0,0,0), FBoxRect);
                        End; // cmmNone
      End; // Case FMouseMode
    End; // If (Button = mbLeft) And ProcessMD
  End; // If (Not (csDesigning In ComponentState))
End;

//------------------------------

procedure TBaseDragControl.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
  MousePos, TmpCo : TPoint;
  LastBox         : TRect;
begin
  If (GetCapture = Handle) And (ssLeft In Shift) Then
  Begin
    Case FMouseMode Of
      cmmNone    : { No action required };

      cmmResize  : Begin
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
                       FMouseMode := cmmNone;
                   End; // cmmResize

      cmmMove    : Begin
                     If (GetCapture = Handle) And (ssLeft In Shift) Then
                     Begin
                       // Check the cursor is within the limiting rectangle
                       MousePos := LimitMouseMovement;

                       // Erase the previos rubb-band rectangle and activate the control - can't
                       // do this whilst a rubber-band is in existence as the painting screws it
                       // all up
                       DrawRubberBandBox (FBoxRect, Rect(0, 0, 0, 0));
                       If (Not FRegionManager.IsSelected(Self)) Then
                       Begin
                         FRegionManager.SelectControl (Self, False, False);
                         Paint;
                       End; // If (Not FRegionManager.IsSelected(Self))

                       // Calculate and draw the resizing rubber-band box
                       FBoxRect := BuildMoveRect(MousePos, FMoveOrigin);
                       DrawRubberBandBox (Rect(0, 0, 0, 0), FBoxRect);

                       // Pass movement details to RegionManager to be passed to any other selected controls
                       TmpCo.X := X - FMoveOrigin.X;
                       TmpCo.Y := Y - FMoveOrigin.Y;
                       FRegionManager.SelectMove (Self, TmpCo.X, TmpCo.Y, smmMouseMove);
                     End; // If (GetCapture = Handle) And (ssLeft In Shift)
                   End; // cmmMove
    End; // Case FMouseMode
  End; // If (GetCapture = Handle) And (ssLeft In Shift)

  // Pass the current position onto the Region for display as the cursor position
  ParentRegion.UpdateCursorPos(Left + X, Top + Y, False);

  Inherited MouseMove (Shift, X, Y);
end;

//------------------------------

procedure TBaseDragControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  MousePos : TPoint;
  TempRect : TRect;
begin
  Case FMouseMode Of
    cmmResize       : Begin
                        If (Button = mbLeft) Then
                        Begin
                          // Return mouse to normal usage
                          ReleaseCapture;

                          // Erase the resizing rubber-band box
                          DrawRubberBandBox(FBoxRect, Rect(0,0,0,0));

                          // Check the cursor is within the limiting rectangle
                          MousePos := LimitMouseMovement;

                          // Convert the mouse position to a sizing rectange and then convert from
                          // screen rect coords to client
                          TempRect := BuildResizeRect(MousePos);
                          TempRect.TopLeft := ParentRegion.ScreenToClient(TempRect.TopLeft);
                          TempRect.BottomRight := ParentRegion.ScreenToClient(TempRect.BottomRight);
                          SetBounds (TempRect.Left, TempRect.Top, TempRect.Right - TempRect.Left, TempRect.Bottom - TempRect.Top);

                          UpdateControlDets;

                          If IsSorted Then
                          Begin
                            // Refresh the sorting as resizing the control could have changed the sort order
                            FRegionManager.UpdateRegionSorts;
                          End; // If IsSorted

                          FRegionManager.ChangeMade;
                        End; // If (Button = mbLeft)
                      End; // mmResizeRegion
    cmmMove         : Begin
                        If (Button = mbLeft) Then
                        Begin
                          // Return mouse to normal usage
                          ReleaseCapture;
                          FMouseMode := cmmNone;

                          // Erase the resizing rubber-band box
                          DrawRubberBandBox(FBoxRect, Rect(0,0,0,0));

                          // Check the cursor is still within the limiting rectangle and
                          // select the controls
                          MousePos := LimitMouseMovement;

                          // Convert the mouse position to a sizing rectangle and then convert from
                          // screen rect coords to client
                          TempRect := BuildMoveRect(MousePos, FMoveOrigin);
                          FRegionManager.DropControl (MousePos, TempRect, Self);

                          UpdateControlDets;

                          // Pass movement details to RegionManager to be passed to any other selected controls
                          FRegionManager.SelectMove (Self, 0, 0, smmMouseUp);

                          // Refresh the sorting as moving controls could have changed the sort order
                          FRegionManager.UpdateRegionSorts;

                          // Ctrl-Click & Shift-Click selection
// MH 18/07/05: Removed as this is now done at the start of MouseDown to avoid
// problems with multi-select/deselect and focus changing                          
//                          If (ssShift In Shift) Or (ssCtrl In Shift) Then
//                          Begin
//                            If (Not FRegionManager.IsSelected(Self)) Then
//                              { add to selection group }
//                              FRegionManager.SelectControl (Self, True)
//                            Else Begin
//                              { remove from selection group }
//                              FRegionManager.DeSelectControl (Self);
//                              FRegionManager.SelectMove (Self, 0, 0, smmCtrlClick);
//                            End; { Else }
//                          End { If }
//                          Else
//                            If (Not FRegionManager.IsSelected(Self)) Then
//                              { start new selection group based on this control }
//                              FRegionManager.SelectControl (Self, False);
                        End; // If (Button = mbLeft)
                      End; // cmmMove
  End; // Case FMouseMode

  FMouseMode := cmmNone;

  inherited MouseUp(Button, Shift, X, Y);
end;

//-------------------------------------------------------------------------

// Updates the ControlDets object with changes to position/size/etc...
Procedure TBaseDragControl.UpdateControlDets;
Begin // UpdateControlDets
  FControlDets.vcTop := (Top - BannerHeight) Div PixelsPerMM;
  FControlDets.vcLeft := (Left - LeftBorderWidth) Div PixelsPerMM;
  FControlDets.vcWidth := Width Div PixelsPerMM;
  FControlDets.vcHeight := Height Div PixelsPerMM;
End; // UpdateControlDets

//-------------------------------------------------------------------------

Procedure TBaseDragControl.KeyDown(var Key: Word; Shift: TShiftState);
Begin // KeyDown
  // Check we aren't in the middle of a mouse move operation
  If (GetCapture <> Handle) Then
  Begin
    // Pass the keyboard commands to the RegionManager to be rebroadcast to all
    // selected controls, including this one
    FRegionManager.BroadcastKeyboardOp(Key, Shift);
  End; // If (GetCapture <> Handle)
End; // KeyDown

//------------------------------

// Called by the IRegionManager.BroadcastKeyboardOp method to perform the
// KeyDown processing for this control
Procedure TBaseDragControl.KeyboardOp(var Key: Word; Shift: TShiftState);
Var
  XPix, YPix : LongInt;
  MousePoint : TPoint;
  CtrlRect   : TRect;
Begin // KeyboardOp
  If (Key = VK_DELETE) Then
  Begin
    // Delete - Delete Control
    Delete;
  End // If (Key = VK_DELETE)
  Else If (Key In [VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN]) Then
  Begin
    // Cursor Keys - move in indicated direction by GridSizeX/Y
    // Ctrl + Cursor Keys - move in indicated direction by 3 x GridSizeX/Y

    // Shift + Cursor Keys - Resize Bottom/Left in indicated direction by GridSizeX/Y
    // Ctrl + Shift + Cursor Keys - Resize Bottom/Left in indicated direction by GridSizeX/Y

    // Calculate the number of pixels to change by
    XPix := FRegionManager.rmGridSizeXPixels * IfThen(ssCtrl In Shift, 3, 1);
    YPix := FRegionManager.rmGridSizeYPixels * IfThen(ssCtrl In Shift, 3, 1);

    If (Not (ssShift In Shift)) Then
    Begin
      // Moving - get the TopLeft in screen co-ords and use as the mouse position
      // with the standard mouse moving functions
      MousePoint := Parent.ClientToScreen(BoundsRect.TopLeft);
      Case Key Of
        VK_LEFT   : MousePoint.X := MousePoint.X - XPix;
        VK_UP     : MousePoint.Y := MousePoint.Y - YPix;
        VK_RIGHT  : MousePoint.X := MousePoint.X + XPix;
        VK_DOWN   : MousePoint.Y := MousePoint.Y + YPix;
      End; // Case Key
      CtrlRect := BuildMoveRect(MousePoint, Point(0,0));
      FRegionManager.DropControl (MousePoint, CtrlRect, Self);
      UpdateControlDets;

      If IsSorted Then
      Begin
        FRegionManager.UpdateRegionSorts;
      End; // If IsSorted
    End // If (Not (ssShift In Shift))
    Else
    Begin
      // Resizing - Get the BottomRight in screen co-ords as the mouse position
      // and adjust it to to represent the required change

      // Get controls position & size in screen coords
      FScrSizeRect := BoundsRect;
      FScrSizeRect.TopLeft := Parent.ClientToScreen(FScrSizeRect.TopLeft);
      FScrSizeRect.BottomRight := Parent.ClientToScreen(FScrSizeRect.BottomRight);

      MousePoint := FScrSizeRect.BottomRight;
      Case Key Of
        VK_LEFT   : Begin // Move in right hand border to make the control smaller
                      FSizeType := CentreRight;
                      MousePoint.X := MousePoint.X - XPix;
                      If ((MousePoint.X - FScrSizeRect.Left) < FRegionManager.rmMinControlWidth) Then
                        MousePoint.X := FScrSizeRect.Left + FRegionManager.rmMinControlWidth;
                    End; // VK_LEFT
        VK_UP     : Begin // Move up the bottom border to make the control smaller
                      FSizeType := BottomCentre;
                      MousePoint.Y := MousePoint.Y - YPix;
                      If ((MousePoint.Y - FScrSizeRect.Top) < FRegionManager.rmMinControlHeight) Then
                        MousePoint.Y := FScrSizeRect.Top + FRegionManager.rmMinControlHeight;
                    End; // VK_UP
        VK_RIGHT  : Begin // Move out right hand border to make the control bigger
                      FSizeType := CentreRight;
                      MousePoint.X := MousePoint.X + XPix;

                      If (MousePoint.X > ParentRegion.RegionClientScrCoords.Right) Then
                        MousePoint.X := ParentRegion.RegionClientScrCoords.Right;
                    End; // VK_RIGHT
        VK_DOWN   : Begin // Move down the bottom border to make the control bigger
                      FSizeType := BottomCentre;
                      MousePoint.Y := MousePoint.Y + YPix;

                      If (MousePoint.Y > ParentRegion.RegionClientScrCoords.Bottom) Then
                        MousePoint.Y := ParentRegion.RegionClientScrCoords.Bottom;
                    End; // VK_DOWN
      End; // Case Key
      CtrlRect := BuildResizeRect(MousePoint);
      CtrlRect.TopLeft := ParentRegion.ScreenToClient(CtrlRect.TopLeft);
      CtrlRect.BottomRight := ParentRegion.ScreenToClient(CtrlRect.BottomRight);
      SetBounds (CtrlRect.Left, CtrlRect.Top, CtrlRect.Right - CtrlRect.Left, CtrlRect.Bottom - CtrlRect.Top);
      UpdateControlDets;

      FRegionManager.ChangeMade;

      FScrSizeRect := Rect(0,0,0,0);
    End; // Else
  End; // If (Key In [VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN])

  Inherited KeyDown (Key, Shift);
End; // KeyDown

//------------------------------

// Called when a group of controls is being operated on
Procedure TBaseDragControl.SelectMove (Const XOff, YOff : SmallInt; Const Mode : TSelectMoveMode);
Var
  TempRect  : TRect;
  InvalidPoint, TempPoint : TPoint;
Begin
  Case Mode Of
    smmMouseDown  : Begin
                      // Generate a valid movement rect that is snapped to the grid
                      TempPoint := Parent.ClientToScreen(BoundsRect.TopLeft);
                      TempPoint.Y := TempPoint.Y + YOff;
                      TempPoint.X := TempPoint.X + XOff;
                      FSelMove2 := BuildMoveRect(TempPoint, Point(0, 0));

                      { draw the movement rect }
                      FSelMove1 := FSelMove2;
                      DrawRubberBandBox (Rect(0,0,0,0), FSelMove1);
                    End; // smmMouseDown
    smmMouseMove  : Begin
                      // Generate a valid movement rect that is snapped to the grid
                      TempPoint := Parent.ClientToScreen(BoundsRect.TopLeft);
                      TempPoint.Y := TempPoint.Y + YOff;
                      TempPoint.X := TempPoint.X + XOff;

                      // Check that the calculated point is within a region, if not try
                      // to revert to the last validX/Y co-ordinate that works so the control
                      // doesn't stick against the border like a fly on a windscreen!
                      If FRegionManager.InRegion (TempPoint) Then
                      Begin
                        FSelMove2 := BuildMoveRect(TempPoint, Point(0, 0));
                      End // If FRegionManager.InRegion (TempPoint)
                      Else
                      Begin
                        InvalidPoint := TempPoint;
                        TempPoint.X := FSelMove2.Left;
                        If FRegionManager.InRegion (TempPoint) Then
                        Begin
                          FSelMove2 := BuildMoveRect(TempPoint, Point(0, 0));
                        End // If FRegionManager.InRegion (TempPoint)
                        Else
                        Begin
                          TempPoint.X := InvalidPoint.X;
                          TempPoint.Y := FSelMove2.Top;
                          If FRegionManager.InRegion (TempPoint) Then
                          Begin
                            FSelMove2 := BuildMoveRect(TempPoint, Point(0, 0));
                          End // If FRegionManager.InRegion (TempPoint)
                        End; // Else
                      End; // Else

                      // Erase the old rect and draw the new movement rect
                      DrawRubberBandBox (FSelMove1, FSelMove2);
                      FSelMove1 := FSelMove2;
                    End; // smmMouseMove
    smmMouseUp    : Begin
                      DrawRubberBandBox (Rect(0,0,0,0), FSelMove1);       { undraw the movement box }
                      FSelMove1 := Rect(0,0,0,0);

                      // Generate a valid movement rect that is snapped to the grid
                      TempPoint := FSelMove2.TopLeft;
                      TempRect := BuildMoveRect(TempPoint, Point(0, 0));

                      // Convert the mouse position to a sizing rectangle and then convert from
                      // screen rect coords to client
                      FRegionManager.DropControl (TempPoint, TempRect, Self);

                      UpdateControlDets;
                    End; // smmMouseUp
//    4 : Begin { KeyPress }
//          SetBounds (Left + XOff, Top + YOff, Width, Height);
//        End;
  End; { Case }
End;

//-------------------------------------------------------------------------

// Calculates the rectangles that the resize cursors will be shown in
procedure TBaseDragControl.CalcHandleRects;
Var
  I : THandles;
  cRight, cBottom : LongInt;
begin
  { Calculate central position for top, sides and bottom }
  cRight := Width - 1;
  cBottom := Height - 1;

  For I := TopLeft To BottomRight Do
  Begin
    Case I Of                             { left, top, right, bottom }
      TopLeft      : FHandles [I] := Rect (0, 0, 3, 3);
      TopCentre    : FHandles [I] := Rect (3, 0, (cRight - 3), 3);
      TopRight     : FHandles [I] := Rect ((cRight - 3), 0, cRight, 3);
      CentreLeft   : FHandles [I] := Rect (0, 4, 3, (cBottom - 3));
      CentreRight  : FHandles [I] := Rect ((cRight - 3), 4, cRight, (cBottom - 4));
      BottomLeft   : FHandles [I] := Rect (0, (cBottom - 3), 3, cBottom);
      BottomCentre : FHandles [I] := Rect (3, (cBottom - 3), (cRight - 3), cBottom);
      BottomRight  : FHandles [I] := Rect ((cRight - 3), (cBottom - 4), cRight, cBottom);
    Else
      FHandles [I] := Rect (0, 0, 0, 0);
    End; // Case I
  End; // For I
end;

//------------------------------

// Returns TRUE if the control is visible and should be painted
Function TBaseDragControl.WantPaint : Boolean;
Begin // WantPaint
  If Assigned (Parent) Then
  Begin
    // Return TRUE if the control is visible and should be painted
    // HM 16/05/05: Removed Intersect rect as I couldn't calulate the rectangles correctly
    Result := (Not FSuspendPaint) And
               Visible{ And
               IntersectRect (aRect, ScrollRect, CtrlRect)};

//    If Result And Assigned (Controller) Then
//      { Check to see if covered by a bitmap }
//      Result := Not Controller.BmpCovered (Self);
  End { If }
  Else
    Result := False;
End; // WantPaint

//------------------------------

// Main paint method called by the VCL
procedure TBaseDragControl.Paint;
begin
  { Check this controls drawing is turned on and its visible in the client area }
  If WantPaint Then
  Begin
    PaintBackGround;
    PaintForeGround;

    // Paint any overlapping controls
    ParentRegion.PaintTopControls (Self);
  End; // If WantPaint
end;

//------------------------------

Procedure TBaseDragControl.PaintBackGround;
Begin // PaintBackGround
  If WantPaint Then Begin
    With Canvas do Begin
      Brush.Style := bsClear;
      FillRect (ClientRect);
    End; { With }
  End; { If }
End; // PaintBackGround

//------------------------------

Procedure TBaseDragControl.PaintForeGround;
begin
  If WantPaint Then
  Begin
    PaintControl;
    PaintHandles;
  End; { If }
end;

//------------------------------

// Paints the control Border taking into account the selected status
procedure TBaseDragControl.PaintHandles;
begin
  With Canvas Do
  Begin
    Pen.Width := 1;
    Pen.Style := psSolid;
    If FRegionManager.IsSelected(Self) Then
      Pen.Color := clRed
    Else
      Pen.Color := clGray;

    MoveTo (0,         0);
    LineTo (Width - 1, 0);
    LineTo (Width - 1, Height - 1);
    LineTo (0,         Height - 1);
    LineTo (0,         0);

    CalcHandleRects;
  End; // With Canvas
end;

//------------------------------

// Paints the controls detail - overriden in descendants
procedure TBaseDragControl.PaintControl;
begin
  If WantPaint Then
  Begin
    With Canvas do Begin
      Pen.Color := clBlack;
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;

      Brush.Color := clWhite;
      Brush.Style := bsSolid;

      Rectangle (0, 0, Width, Height);
    End; { With }
  End; { If }
end;

//-------------------------------------------------------------------------

Function TBaseDragControl.GetControlDets : IVRWControl;
Begin // GetControlDets
  Result := FControlDets;
End; // GetControlDets

//------------------------------

Function TBaseDragControl.GetControlSummary : ShortString;
Begin // GetControlSummary
  Result := Name;
End; // GetControlSummary

//------------------------------

Function TBaseDragControl.GetFieldAlignment : TAlignment;
Begin // GetFieldAlignment
  If (Pos('R', FControlDets.vcFieldFormat) > 0) Then
    Result := taRightJustify
  Else If (Pos('C', FControlDets.vcFieldFormat) > 0) Then
    Result := taCenter
  Else
    Result := taLeftJustify;
End; // GetFieldAlignment

//------------------------------

Function TBaseDragControl.GetPositionDesc : ShortString;
Begin // GetPositionDesc
  With FControlDets Do
    Result := Format ('T:%d, L:%d, H:%d, W:%d', [vcTop, vcLeft, vcHeight, vcWidth]);
End; // GetPositionDesc

//------------------------------

Function TBaseDragControl.GetPrintIf : Boolean;
Begin // GetPrintIf
  Result := False;
End; // GetPrintIf

//------------------------------

Function TBaseDragControl.GetRangeFilter : Boolean;
Begin // GetRangeFilter
  Result := False;
End; // GetRangeFilter

//------------------------------

Function TBaseDragControl.GetRegion : TRegion;
Begin // GetRegion
  Result := TRegion(Parent);
End; // GetRegion
Procedure TBaseDragControl.SetRegion (Value : TRegion);
Begin // SetRegion
  If (Parent <> Value) Then
  Begin
    If Assigned(Parent) Then
    Begin
      // Remove control from current region
      ParentRegion.RevokeControl(Self);

      // Move control between regions in the parent objects
      ParentRegion.reRegionDets.rgControls.Transfer(FControlDets.vcName, Value.reRegionDets.rgControls);
      FControlDets.vcRegionName := Value.reRegionDets.rgName;
    End; // If Assigned(Parent)

    // Move control into new region
    Parent := Value;
    Value.RegisterControl(Self);
  End; // If (Parent <> Value)
End; // SetRegion

//------------------------------

Function TBaseDragControl.GetSelectionCriteria : Boolean;
Begin // GetSelectionCriteria
  Result := False;
End; // GetSelectionCriteria

//-------------------------------------------------------------------------

// Moves the control to the top of the z-order (topmost)
Procedure TBaseDragControl.BringToFront;
Begin // BringToFront
  ParentRegion.BringToFront(Self);
End; // BringToFront

//------------------------------

// Moves the control to the bottom of the z-order (bottommost)
Procedure TBaseDragControl.SendToBack;
Begin // SendToBack
  ParentRegion.SendToBack(Self);
End; // SendToBack

//-------------------------------------------------------------------------

// Calculates a size for the control based on the passed text - obviously
// won't work for bitmaps, boxes and lines!
Procedure TBaseDragControl.CalcInitialSize (Const SizeText : ShortString);
Var
  TheRect    : TRect;
  TheText    : ANSIString;
  PaintFlags : Word;

  Function Snap (Const Pixels, GridSize : LongInt) : LongInt;
  Begin // Snap
    Result := (Pixels Div GridSize) * GridSize;
    If ((Pixels Mod GridSize) <> 0) Then
      Result := Result + GridSize;
  End; // Snap

Begin // CalcInitialSize
  // Copy the font details in from the details and then scale the font
  CopyIFontToFont (FControlDets.vcFont, Canvas.Font);
  SetVisFontHeight (Canvas.Font, Canvas.Font.Size);

  // Get size of font
  TheRect := Rect (1, 1, 2, 2);
  TheText := SizeText;
  PaintFlags := DT_CALCRECT Or DT_SINGLELINE;
  CanvasDrawText (Canvas, TheText, TheRect, PaintFlags);

  // Set control size - round sizes up to the nearest grid node
  Width := Snap(TheRect.Right - TheRect.Left, FRegionManager.rmGridSizeXPixels);
  If (Width < FRegionManager.rmMinControlWidth) Then Width := FRegionManager.rmMinControlWidth;

  Height := Snap(TheRect.Bottom - TheRect.Top, FRegionManager.rmGridSizeYPixels);
  If (Height < FRegionManager.rmMinControlHeight) Then Height := FRegionManager.rmMinControlHeight;
End; // CalcInitialSize

//-------------------------------------------------------------------------

// 'Deletes' the control by hiding it - can't actually destroy it as we need the control
// and info to stay around for undeletes.
Procedure TBaseDragControl.Delete;
Begin // Delete
  Visible := False;

  // Mark as deleted on the parent object
  FControlDets.vcDeleted := True;

  // Remove from the list of selected controls if present
  FRegionManager.DeSelectControl (Self);

  // If a sorted control is deleted then we need to rebuild the sorts
  // across all regions
  If IsSorted Then
  Begin
    FRegionManager.UpdateRegionSorts;
  End; // If IsSorted

  // Invalidate the region as any overlapping controls will need to be repainted
  ParentRegion.Invalidate;
End; // Delete

//-------------------------------------------------------------------------

// Snaps the control to the Parent Region's Grid
Procedure TBaseDragControl.SnapToGrid;
Var
  NewPosRec : TRect;
Begin // SnapToGrid
  // Snap the Top-Left to the grid
  NewPosRec.TopLeft := Parent.ClientToScreen(BoundsRect.TopLeft);
  NewPosRec.BottomRight := Parent.ClientToScreen(BoundsRect.BottomRight);
  ParentRegion.MoveSnapToGrid (NewPosRec, False);
  With Parent.ScreenToClient(NewPosRec.TopLeft) Do SetBounds(X, Y, Width, Height);

  Invalidate;

  UpdateControlDets;
  FRegionManager.ChangeMade;
End; // SnapToGrid

//-------------------------------------------------------------------------

// Updates the controls font to that passed
Procedure TBaseDragControl.UpdateFont(Const NewFont : TFont);
Begin // UpdateFont
  CopyFontToIFont(NewFont, FControlDets.vcFont);
  ParentRegion.PaintRegionArea (BoundsRect);
  FRegionManager.ChangeMade;
End; // UpdateFont

//-------------------------------------------------------------------------


procedure TBaseDragControl.Restore;
begin
  Visible := True;

  // Mark as undeleted on the parent object
  FControlDets.vcDeleted := False;

  // If a sorted control is restored then we need to rebuild the sorts
  // across all regions
  If IsSorted Then
    FRegionManager.UpdateRegionSorts;

  // Invalidate the region as any overlapping controls will need to be repainted
  ParentRegion.Invalidate;
end;

end.
