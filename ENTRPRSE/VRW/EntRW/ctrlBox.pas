unit ctrlBox;

interface

Uses Classes, Forms, Graphics, SysUtils, Windows,
     VRWReportIF,
     DesignerTypes,    // Common designer types and interfaces
     ctrlDrag          // TBaseDragControl
     ;

Type
  // Used by the dialog for internal storage of properties
  TTempBoxLine = Record
    vcLineStyle : TPenStyle;
    vcLineColor : TColor;
    vcLineWidth : Byte;
  End; // TTempBoxLine

  // Used by the dialog for internal storage of properties
  TTempBoxDets = Record
    vcFilled    : Boolean;
    vcFillColor : TColor;
    vcBoxLines  : Array [TVRWBoxLineIndex] Of TTempBoxLine;
  End; // TTempBoxDets

  TVRWBoxControl = class(TBaseDragControl)
  Private
    FBoxDets : IVRWBoxControl;
  Protected
    Function GetControlSummary : ShortString; override;
    procedure PaintControl; override;
  Public
    //Property BoxDets : IVRWBoxControl Read FBoxDets;
    Property BoxDets : IVRWBoxControl Read FBoxDets;

    Constructor Create (RegionManager: IRegionManager; BoxDets : IVRWBoxControl); Reintroduce;
    Destructor Destroy; Override;

    // Called when building a popup menu for the control, the set contains all
    // possible menu items and the control should remove those that don't apply
    Procedure DisableContextItems(Var MenuItemSet : TControlContextItemsSet); Override;
  End; // TVRWBoxControl

// Returns the Line width in pixels for drawing at design time
Function LineWidthInPixels (Const LineWidth : SmallInt) : SmallInt;

implementation

Uses DesignerUtil;

Var
  CtrlCounter : TBits;

//=========================================================================

// Returns the Line width in pixels for drawing at design time. NOTE:
// Linewidth is stored in 1/100ths of an inch because that is how RAVE
// draws lines
Function LineWidthInPixels (Const LineWidth : SmallInt) : SmallInt;
Begin // LineWidthInPixels
  // NOTE: When testing this formula in Excel I noticed that TRUNC
  // gave slightly smoother results than ROUND
  Result := Trunc((LineWidth * 100) / PixelsPerInch);
  If (Result < 1) Then Result := 1;
End; // LineWidthInPixels

//=========================================================================

Constructor TVRWBoxControl.Create (RegionManager: IRegionManager; BoxDets : IVRWBoxControl);
Var
  iCtrl : SmallInt;
//  I     : TVRWBoxLineIndex;
Begin // Create
  Inherited Create(RegionManager, BoxDets);

  FBoxDets := BoxDets;

  iCtrl := CtrlCounter.OpenBit;
  CtrlCounter.Bits[iCtrl] := True;
  Name := 'TVRWBoxControl' + IntToStr(iCtrl+1);
End; // Create

//------------------------------

Destructor TVRWBoxControl.Destroy;
Begin // Destroy
  FBoxDets := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TVRWBoxControl.GetControlSummary : ShortString;
Begin // GetControlSummary
  Result := 'Box';
End; // GetControlSummary

//-------------------------------------------------------------------------

// Called when building a popup menu for the control, the set contains all
// possible menu items and the control should remove those that don't apply
Procedure TVRWBoxControl.DisableContextItems(Var MenuItemSet : TControlContextItemsSet);
Begin // DisableContextItems
  MenuItemSet := MenuItemSet - [cciRangeFilter, cciSelectionCriteria, cciPrintIf, cciPrintOnReport, cciFont, cciSortingSubMenu];
End; // DisableContextItems

//-------------------------------------------------------------------------

procedure TVRWBoxControl.PaintControl;
Var
  BoxRect : TRect;

  Procedure PaintLine (Const Start, Finish : TPoint; Const LineDets : IVRWBoxLine; Const OffsetModifier : SmallInt);
  Var
    I : SmallInt;
  Begin // PaintLine
    If (LineDets.vcLineStyle <> psClear) Then
    Begin
      With Canvas Do
      Begin
        Pen.Color := LineDets.vcLineColor;
        Pen.Style := LineDets.vcLineStyle;
        Pen.Width := 1;

        For I := 0 To (LineWidthInPixels (LineDets.vcLineWidth) - 1) Do
        Begin
          If (Start.X = Finish.X) Then
          Begin
            // Vertical
            MoveTo(Start.X + (I * OffsetModifier), Start.Y);
            LineTo(Finish.X + (I * OffsetModifier), Finish.Y);
            Pixels[Finish.X + (I * OffsetModifier), Finish.Y] := LineDets.vcLineColor;
          End // If (Start.X = Finish.X)
          Else
          Begin
            // Horizontal
            MoveTo(Start.X, Start.Y + (I * OffsetModifier));
            LineTo(Finish.X, Finish.Y + (I * OffsetModifier));
            Pixels[Finish.X, Finish.Y + (I * OffsetModifier)] := LineDets.vcLineColor;
          End; // Else
        End; // For I
      End; // With PaintBox1.Canvas
    End; // If (vcLineStyle <> psClear)
  End; // PaintLine

Begin // PaintControl
  With Canvas Do
  Begin
    // Draw box 2mm inside the control to avoid problems with borders overlapping the rectangle
    //BoxRect := Rect(2 * PixelsPerMM, 2 * PixelsPerMM, Width-(2 * PixelsPerMM), Height-(2 * PixelsPerMM));

    // MH 29/06/05: Modified to draw the box just inside the border as this is the closest we can
    // get to how it prints and it works a lot better this way when trying to line things up.
    BoxRect := Rect(1, 1, Width-1, Height-1);

    If FBoxDets.vcFilled Then
    Begin
      Brush.Color := FBoxDets.vcFillColor;
      FillRect (BoxRect);
    End; // If FBoxDets.vcFilled

    // NOTE: Drawing co-ords take into account that the last pixel of a line isn't painted

    // Draw Left
    PaintLine (BoxRect.TopLeft, Point(BoxRect.Left, BoxRect.Bottom - 1), FBoxDets.vcBoxLines[biLeft], 1);

    // Draw Right
    PaintLine (Point(BoxRect.Right-1, BoxRect.Top), Point(BoxRect.Right-1, BoxRect.Bottom - 1), FBoxDets.vcBoxLines[biRight], -1);

    // Draw Top
    PaintLine (BoxRect.TopLeft, Point(BoxRect.Right - 1, BoxRect.Top), FBoxDets.vcBoxLines[biTop], 1);

    // Draw Bottom
    PaintLine (Point(BoxRect.Left, BoxRect.Bottom - 1), Point(BoxRect.Right - 1, BoxRect.Bottom - 1), FBoxDets.vcBoxLines[biBottom], -1);
  End; // With Canvas
End; // PaintControl

//=========================================================================

Initialization
  CtrlCounter := TBits.Create;
Finalization
  FreeAndNIL(CtrlCounter);
end.
