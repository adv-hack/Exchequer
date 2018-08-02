unit DesignerUtil;

interface

Uses Classes, Forms, SysUtils, Windows, DesignerTypes, Graphics, ctrlDrag, VRWReportIF;


// Sizes the control intelligently to fit the passed text
Procedure AutoCalcControlSize (Const RegionManager : IRegionManager; Const VRWControl : IVRWControl; Const SizingText : ShortString);

// Draws Transparent Text onto a canvas
Procedure CanvasDrawText (Const TheCanvas : TCanvas;
                          Const DrawStr   : ShortString;
                          Var   DrawRect  : TRect;
                          Const DrawFlags : Word);

// Centre's the passed dialog over the passed control
Procedure CentreOverControl (TheForm : TForm; TheControl : TBaseDragControl);

// Centre's the passed dialog over the passed form
Procedure CentreOverForm (TheDialog, TheForm: TForm);

// Centre the form over the passed screen co-ords
Procedure CentreOverCoords (TheForm : TForm; Const X, Y : SmallInt);

// Routines to copy between a Delphi TFont and the VRW IVRWFont interface used
// to pass fonting details between EntRW.Exe and RepEngine.Dll.  NOTE: If TFont
// is used then you gat an Access Violation when writing to it.
Procedure CopyIFontToFont (FontIntf : IVRWFont; TheFont : TFont);
Procedure CopyFontToIFont (TheFont : TFont; FontIntf : IVRWFont);
Procedure CopyIFontToIFont (FromFont, ToFont : IVRWFont);

// Copies the normal font into the visual font and adjusts the size to
// account for the scaling differential onscreen
Procedure FontToVisFont(NormFont, VisFont : TFont);
// Adjusts the height of the passed font to account for the scaling
// differential onscreen
Procedure SetVisFontHeight (VisFont : TFont; PointSize : Integer);

// Converts a MM measurement to pixels
Function InPixels(Const InMM : LongInt) : LongInt;
// Converts a Pixel measurement to MM
Function InMM(Const InPixels : LongInt) : LongInt;


implementation

//-------------------------------------------------------------------------

// Copies the normal font into the visual font and adjusts the size to
// account for the scaling differential onscreen
Procedure FontToVisFont(NormFont, VisFont : TFont);
begin
  { Copy font across }
  VisFont.Assign (NormFont);

  { reset height }
  SetVisFontHeight (VisFont, NormFont.Size);
end;

//------------------------------

// Adjusts the height of the passed font to account for the scaling
// differential onscreen
Procedure SetVisFontHeight (VisFont : TFont; PointSize : Integer);
Const
  PointsPerMM = 0.352778;   { 25.4mm / 72 points per inch }
begin
  { Calculate pixel height }
  VisFont.Height := -Round (PointsPerMM * PointSize * PixelsPerMM);
end;

//-------------------------------------------------------------------------

// Draws Transparent Text onto a canvas
Procedure CanvasDrawText (Const TheCanvas : TCanvas;
                          Const DrawStr   : ShortString;
                          Var   DrawRect  : TRect;
                          Const DrawFlags : Word);
Var
  TheStr   : PChar;
  TmpStyle : TBrushStyle;
Begin
  TheStr := StrAlloc (Length (DrawStr) + 1);
  StrPCopy (TheStr, DrawStr);

  TmpStyle := TheCanvas.Brush.Style;
  TheCanvas.Brush.Style := bsClear;

  DrawText (TheCanvas.Handle, TheStr, Length (TheStr), DrawRect, DrawFlags);

  TheCanvas.Brush.Style := TmpStyle;

  StrDispose(TheStr);
End;

//-------------------------------------------------------------------------

// Converts a MM measurement to pixels
Function InPixels(Const InMM : LongInt) : LongInt;
Begin // InPixels
  Result := Round(InMM * PixelsPerMM);
End; // InPixels

//------------------------------

// Converts a Pixel measurement to MM
Function InMM(Const InPixels : LongInt) : LongInt;
Begin // InMM
  Result := Round(InPixels / PixelsPerMM);
End; // InMM

//-------------------------------------------------------------------------

// Centre's the passed dialog over the passed control
Procedure CentreOverControl (TheForm : TForm; TheControl : TBaseDragControl);
Begin // CentreOverControl
  If Assigned(TheControl.Parent) Then
  Begin
    With TheControl.Parent.ClientToScreen(TheControl.BoundsRect.TopLeft) Do
    Begin
      // Centre over control
      TheForm.Left := X + (TheControl.Width Div 2) - (TheForm.Width Div 2);
      TheForm.Top := Y + (TheControl.Height Div 2) - (TheForm.Height Div 2);

      // Ensure it is still entirely on the screen
      If (TheForm.Left < 0) Then TheForm.Left := 0;
      If (TheForm.Top < 0) Then TheForm.Top := 0;
      If ((TheForm.Left + TheForm.Width) > Screen.Width) Then TheForm.Left := Screen.Width - TheForm.Width;
      If ((TheForm.Top + TheForm.Height) > Screen.Height) Then TheForm.Top := Screen.Height - TheForm.Height;
    End; // With TheControl.Parent.ClientToScreen(TheControl.BoundsRect.TopLeft)
  End // If Assigned(TheControl.Parent)
  Else
  Begin

  End; // Else
End; // CentreOverControl

//------------------------------

// Centre's the passed dialog over the passed form
Procedure CentreOverForm (TheDialog, TheForm: TForm);
Begin // CentreOverControl
  If Assigned(TheForm.Parent) Then
  Begin
    With TheForm.Parent.ClientToScreen(TheForm.BoundsRect.TopLeft) Do
    Begin
      // Centre over control
      TheDialog.Left := X + (TheForm.Width Div 2) - (TheDialog.Width Div 2);
      TheDialog.Top := Y + (TheForm.Height Div 2) - (TheDialog.Height Div 2);

      // Ensure it is still entirely on the screen
      If (TheDialog.Left < 0) Then TheDialog.Left := 0;
      If (TheDialog.Top < 0) Then TheDialog.Top := 0;
      If ((TheDialog.Left + TheDialog.Width) > Screen.Width) Then TheDialog.Left := Screen.Width - TheDialog.Width;
      If ((TheDialog.Top + TheDialog.Height) > Screen.Height) Then TheDialog.Top := Screen.Height - TheDialog.Height;
    End; // With TheForm.Parent.ClientToScreen(TheForm.BoundsRect.TopLeft)
  End // If Assigned(TheForm.Parent)
  Else
  Begin

  End; // Else
End; // CentreOverControl

//------------------------------

// Centre the form over the passed screen co-ords
Procedure CentreOverCoords (TheForm : TForm; Const X, Y : SmallInt);
Begin // CentreOverCoords
  // Centre over control
  TheForm.Left := X - (TheForm.Width Div 2);
  TheForm.Top := Y - (TheForm.Height Div 2);

  // Ensure it is still entirely on the screen
  If (TheForm.Left < 0) Then TheForm.Left := 0;
  If (TheForm.Top < 0) Then TheForm.Top := 0;
  If ((TheForm.Left + TheForm.Width) > Screen.Width) Then TheForm.Left := Screen.Width - TheForm.Width;
  If ((TheForm.Top + TheForm.Height) > Screen.Height) Then TheForm.Top := Screen.Height - TheForm.Height;
End; // CentreOverCoords

//-------------------------------------------------------------------------

// Copies the Font details from one instance to another, this is necessary when
// copying from a TFont created in EntRW.Exe to a font created in RepEngine.Dll
//Procedure CopyFont (ToFont, FromFont: TFont);
//Begin // CopyFont
//  ToFont.Name := FromFont.Name;
//  ToFont.Color := FromFont.Color;
//  ToFont.Style := FromFont.Style;
//  ToFont.Pitch := FromFont.Pitch;
//  ToFont.Height := FromFont.Height;
//  ToFont.Size := FromFont.Size;
//End; // CopyFont

//-------------------------------------------------------------------------

// Routines to copy between a Delphi TFont and the VRW IVRWFont interface used
// to pass fonting details between EntRW.Exe and RepEngine.Dll.  NOTE: If TFont
// is used then you gat an Access Violation when writing to it.
Procedure CopyIFontToFont (FontIntf : IVRWFont; TheFont : TFont);
Begin // CopyIFontToFont
  TheFont.Name := FontIntf.Name;
  TheFont.Color := FontIntf.Color;
  TheFont.Style := FontIntf.Style;
  TheFont.Size := FontIntf.Size;
End; // CopyIFontToFont

//------------------------------

Procedure CopyFontToIFont (TheFont : TFont; FontIntf : IVRWFont);
Begin // CopyFontToIFont
  FontIntf.Name := TheFont.Name;
  FontIntf.Color := TheFont.Color;
  FontIntf.Style := TheFont.Style;
  FontIntf.Size := TheFont.Size;
End; // CopyFontToIFont

//------------------------------

Procedure CopyIFontToIFont (FromFont, ToFont : IVRWFont);
Begin // CopyIFontToIFont
  ToFont.Name := FromFont.Name;
  ToFont.Size := FromFont.Size;
  ToFont.Style := FromFont.Style;
  ToFont.Color := FromFont.Color;
End; // CopyIFontToIFont

//-------------------------------------------------------------------------

// Sizes the control intelligently to fit the passed text
Procedure AutoCalcControlSize (Const RegionManager : IRegionManager; Const VRWControl : IVRWControl; Const SizingText : ShortString);
Var
  SizingPanel : TBitmap;
  TheRect    : TRect;
  TheText    : ANSIString;
  PaintFlags : Word;

  Function Snap (Const Pixels, GridSize : LongInt) : LongInt;
  Begin // Snap
    Result := (Pixels Div GridSize) * GridSize;
    If ((Pixels Mod GridSize) <> 0) Then
      Result := Result + GridSize;
  End; // Snap

Begin // AutoCalcControlSize
  // Sizes the control intelligently
  SizingPanel := TBitmap.Create;
  Try
    // Copy the font from the control into the Panel and scale
    CopyIFontToFont (VRWControl.vcFont, SizingPanel.Canvas.Font);
    SetVisFontHeight (SizingPanel.Canvas.Font, SizingPanel.Canvas.Font.Size);

    // calculate the rectange required for the specified text
    TheRect := Rect (1, 1, 2, 2);
    TheText := SizingText;
    PaintFlags := DT_CALCRECT Or DT_SINGLELINE;
    CanvasDrawText (SizingPanel.Canvas, TheText, TheRect, PaintFlags);

    // Set control size - round sizes up to the nearest grid node
    VRWControl.vcWidth := Snap(TheRect.Right - TheRect.Left, RegionManager.rmGridSizeXPixels);
    If (VRWControl.vcWidth < RegionManager.rmMinControlWidth) Then VRWControl.vcWidth := RegionManager.rmMinControlWidth;

    VRWControl.vcHeight := Snap(TheRect.Bottom - TheRect.Top, RegionManager.rmGridSizeYPixels);
    If (VRWControl.vcHeight < RegionManager.rmMinControlHeight) Then VRWControl.vcHeight := RegionManager.rmMinControlHeight;

    // Convert calculated dimensions back to mm
    VRWControl.vcWidth := VRWControl.vcWidth Div PixelsPerMM;
    VRWControl.vcHeight := VRWControl.vcHeight Div PixelsPerMM;
  Finally
    FreeAndNIL(SizingPanel);
  End; // Try..Finally
End; // AutoCalcControlSize

//-------------------------------------------------------------------------

end.
