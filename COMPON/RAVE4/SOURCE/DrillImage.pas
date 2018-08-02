unit DrillImage;

interface

uses
  Windows, Graphics, Messages, SysUtils, Classes, Controls, ExtCtrls, Dialogs,
  StdCtrls, Forms;

type
  // Event handler used to determine whether Drill-Down is supported at the
  // specified co-ordinates.  Used by TDrillControl.
  TDrillAvailableEvent = Function (      Sender                       : TObject;
                                   Const X, Y                         : Integer;
                                   Var   dLeft, dTop, dWidth, dHeight : Integer) : Boolean of object;


  // Event handler for double-clicking on the TDrillImage
  TDrillImageClickEvent = procedure (      Sender : TObject;
                                     Const X, Y   : Integer) of object;

  //------------------------------

  TDrillHighlightImage = class(TGraphicControl)
  Private
    FBitmap : TBitmap;
    FOnDrillClick : TDrillImageClickEvent;
  Protected
    { Protected declarations }
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  Public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; Override;
  published
    { Published declarations }
    Property Bitmap : TBitmap Read FBitmap Write FBitmap;
    Property OnDrillClick : TDrillImageClickEvent read FOnDrillClick write FOnDrillClick;
  End; { TDrillHighlightImage }

  //------------------------------

  TDrillImage = class(TImage)
  Private
    FOnDrillClick : TDrillImageClickEvent;
  protected
    { Protected declarations }
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    { Public declarations }
  published
    { Published declarations }
    Property OnDrillClick : TDrillImageClickEvent read FOnDrillClick write FOnDrillClick;
  end;

  //------------------------------

  TDrillControl = class(TCustomControl)
  private
    { Private declarations }
    // Image component used for rendering and displaying the preview image
    FImage            : TDrillImage;
    // Last tested co-ords of mouse pointer
    FHitTest          : TPoint;
    // Event handler for testing whether drill-down is available
    FOnDrillAvailable : TDrillAvailableEvent;
    // Image component used to emphasize the drill-down area
    FDrillHighlight   : TDrillHighlightImage;
    // Controls whether the emphais/highlight control is used
    FHighlight        : Boolean;

    // WM_NCHITTEST used to identify the mouse position for WM_SETCURSOR events
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    // WM_SETCURSOR used to control the mouse pointer (cursor) shape
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
  protected
    { Protected declarations }
    function GetCanvas: TCanvas;
    function GetPicture: TPicture;

    function GetOnDrillClick: TDrillImageClickEvent;
    procedure SetOnDrillClick(const Value: TDrillImageClickEvent);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; Override;

    Procedure Reset;
  published
    { Published declarations }
    Property Canvas : TCanvas Read GetCanvas;
    Property Highlight : Boolean Read FHighlight Write FHighlight Default False;
    Property Picture : TPicture Read GetPicture;
    Property OnDrillAvailable : TDrillAvailableEvent Read FOnDrillAvailable Write FOnDrillAvailable;
    Property OnDrillClick : TDrillImageClickEvent read GetOnDrillClick write SetOnDrillClick;
  end;


procedure Register;

implementation

Uses DrillOSInfo;

{$R Drill.Res}

//=========================================================================

procedure Register;
begin
  RegisterComponents('sbs', [TDrillControl, TDrillImage]);
end;

//=========================================================================

constructor TDrillHighlightImage.Create(AOwner: TComponent);
begin
  inherited;

  FBitmap := TBitmap.Create;
end;

//------------------------------

destructor TDrillHighlightImage.Destroy;
begin
  FreeAndNIL (FBitmap);
  
  inherited;
end;

//-------------------------------------------------------------------------

procedure TDrillHighlightImage.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin { MouseUp }
  If (Button = mbLeft) And Assigned (FOnDrillClick) Then
    FOnDrillClick(Self, X + Left, Y + Top);
End; { MouseUp }

//-------------------------------------------------------------------------

procedure TDrillHighlightImage.Paint;
begin
  If Visible Then
    With Canvas do Begin
      (*
      // Display an outline around the drill-down rectangle
      Pen.Color := clBlack;
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Brush.Color := clSkyBlue;
      Brush.Style := bsClear;//bsSolid;
      Rectangle (0, 0, Width, Height);
      *)

      // Display the contents of the drill-down rectangle as is
      //CopyRect (Rect(0, 0, Width, Height), FBitmap.Canvas, Rect(0, 0, Width, Height));

      // change all Black (e.g. Text!) to another colour
      Brush.Color := clBlue;//clMaroon;
      BrushCopy(Rect(0, 0, Width, Height), FBitmap, Rect(0, 0, Width, Height), clBlack);
    End; { With }
end;

//=========================================================================

procedure TDrillImage.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin { MouseUp }
  If (Button = mbLeft) And Assigned (FOnDrillClick) Then
    FOnDrillClick(Self, X, Y);
End; { MouseUp }

//=========================================================================

Constructor TDrillControl.Create(AOwner: TComponent);
Begin
  Inherited;

  FImage := TDrillImage.Create(Self);
  With FImage Do Begin
    Parent := Self;
    Align := alClient;
  End; { With FImage }

  FDrillHighlight := TDrillHighlightImage.Create(Self);
  With FDrillHighlight Do Begin
    Parent := Self;

    Visible := False;
    SetBounds(50, 50, 100, 40);
    BringToFront;
  End; { With FDrillHighlight }
End;

//------------------------------

Destructor TDrillControl.Destroy;
Begin
  FreeAndNIL(FDrillHighlight);
  FreeAndNIL(FImage);

  Inherited;
End;

//-------------------------------------------------------------------------

procedure TDrillControl.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;

  FHitTest := ScreenToClient(SmallPointToPoint(Msg.Pos));
end;

//-------------------------------------------------------------------------

procedure TDrillControl.WMSetCursor(var Msg: TWMSetCursor);
var
  dLeft, dTop, dWidth, dHeight : Integer;
  Cur                          : HCURSOR;
  DestRect, SrcRect            : TRect;
  DoLock                       : Boolean;
begin
  // Check to see if the event has been enabled
  If Assigned(FOnDrillAvailable) And (Not (csDesigning In ComponentState)) Then Begin
    // Call the Drill-Down Available event to see if the cursor should be changed
    If FOnDrillAvailable(Self, FHitTest.X, FHitTest.Y, dLeft, dTop, dWidth, dHeight) Then Begin
      // Select the correct mouse pointer (cursor) for the operating System
      If (OSInfo.OSVersion In [osv31, osv95, osvNT3, osvNT4, osvUnknown]) Then
        // Load bespoke cursor
        Cur := LoadCursor(HInstance, 'FINGER')
        //Cur := LoadCursor(0, IDC_UPARROW)
      Else
        Cur := LoadCursor(0, IDC_HAND);


        // Apply the selected Cursor
      If (Cur<>0) Then Begin
        If FHighlight Then
          With FDrillHighlight Do Begin
            // Check to see if the highlight needs updating
            If (Not Visible) Or (Left <> dLeft) Or (Top <> dTop) Or (Width <> dWidth) Or (Height <> dHeight) Then Begin
              // Lock the drawing in the preview window to prevent flicker
              //LockWindowUpdate (Screen.ActiveForm.Handle);
              // HM 11/06/03: Switched to check and use the owner instead of the Screen.ActiveForm
              // as Screen.ActiveForm was NIL under certain conditions
              DoLock := Assigned(Self.Owner) And (Self.Owner Is TForm);
              If DoLock Then LockWindowUpdate ((Self.Owner As TForm).Handle);

              // Check to see if the highlight needs moving
              If (Left <> dLeft) Or (Top <> dTop) Or (Width <> dWidth) Or (Height <> dHeight) Then Begin
                // Reposition and Resize the highlight control
                SetBounds(dLeft, dTop, dWidth, dHeight);

                // Update the bitmap image within the highlight control with the
                // relevent section of the background image
                Bitmap.Height := dHeight;
                Bitmap.Width := dWidth;
                DestRect := Rect(0, 0, dWidth, dHeight);
                SrcRect  := Rect (dLeft, dTop, dLeft + dWidth, dTop + dHeight);
                Bitmap.Canvas.CopyRect(DestRect, FImage.Picture.Bitmap.Canvas, SrcRect);
              End; { If }

              // Check to see if the highlight is visible
              If (Not Visible) Then
                Visible := True;

              // Restore drawing functionality
              If DoLock Then LockWindowUpdate(0);
            End; { If }
          End; { With FDrillHighlight }

        SetCursor(Cur);
      End; { If (Cur<>0) }
    End { If FOnDrillAvailable(Self, FHitTest.X, FHitTest.Y) }
    Else Begin
      // No Drill-Down at this point - Perform default actions
      Inherited;
      FDrillHighlight.Visible := False;
    End; { Else }
  End { If Assigned(FOnDrillAvailable) }
  Else Begin
    // No Drill-Down Availability handler - Perform default actions
    Inherited;
    FDrillHighlight.Visible := False;
  End; { Else }
end;

//-------------------------------------------------------------------------

function TDrillControl.GetCanvas: TCanvas;
begin
  Result := FImage.Canvas;
end;

//-------------------------------------------------------------------------

function TDrillControl.GetOnDrillClick: TDrillImageClickEvent;
begin
  Result := FImage.OnDrillClick;
end;

//----------------------

procedure TDrillControl.SetOnDrillClick(const Value: TDrillImageClickEvent);
begin
  FImage.OnDrillClick := Value;
  FDrillHighlight.OnDrillClick := Value;
end;

//-------------------------------------------------------------------------

function TDrillControl.GetPicture: TPicture;
begin
  Result := FImage.Picture;
end;

//-------------------------------------------------------------------------

// Called on Zoom/Page Change to hide the Drill-Down Highlighting Control
Procedure TDrillControl.Reset;
begin
  FDrillHighlight.Visible := False;
end;

//=========================================================================

end.
