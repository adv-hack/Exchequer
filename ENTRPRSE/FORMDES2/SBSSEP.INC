constructor TSBSSepBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csReplicatable];

  Left   := 0;
  Top    := 0;
  Height := 2;
  FMoveTop := -1;

  FPage := TSBSPage (AOwner);

  IF FPage.ControllerHandleSet Then
    With FPage.FController.Paper Do
      Self.Width  := (psBorderWidth * 2) +
                     3 +
                     InPixels(psPageWidth)
  Else
    { Best guess at required width }
    Self.Width  := 2000;

  FDragging := False;
  FSepColour := clRed;
  FEnable := True;
end;

procedure TSBSSepBar.PaintControl;
Var
  aRect : TRect;
begin
  If IntersectRect (aRect, Parent.ClientRect, BoundsRect) Then Begin
    With Canvas Do
      { Paint separator line }
      If Enable Then Begin
        MoveTo (-10, 1);
        Pen.Color := FSepColour;
        Pen.Width := Height;
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Brush.Style := bsClear;
        LineTo (Width + 20, 1);
      End; { If }
  End; { If }
end;

procedure TSBSSepBar.Paint;
Var
  aRect : TRect;
begin
  If IntersectRect (aRect, Parent.ClientRect, BoundsRect) Then Begin
    { Paint the seperator line }
    PaintControl;

    { repaint any controls positioned over this bar }
    If FPage.ControllerHandleSet Then
      If Enable Then
        FPage.FController.PaintControlRects (Self)
      Else
        FPage.FController.PaintControlPage (Self.BoundsRect);
  End; { If }
end;

Procedure TSBSSepBar.SetPosition (Index     : Byte;
                                  NameStr   : String;
                                  Enable    : Boolean;
                                  NewTop    : LongInt;
                                  SepColour : TColor);
Var
  WantInv : Boolean;
begin
  WantInv := False;

  FIndex := Index;
  FName  := NameStr;

  If (Enable <> FEnable) Then Begin
    FEnable := Enable;
    Visible := Enable;
    WantInv := True;
  End; { If }

  If (SepColour <> FSepColour) Then Begin
    FSepColour := SepColour;
    WantInv := True;
  End; { If }

  If (NewTop <> Top) Then
    Top := NewTop;

  If WantInv Then
    Invalidate;
end;

procedure TSBSSepBar.WMSetCursor(var Msg: TWMSetCursor);
var
  Cur: HCURSOR;
begin
  If FEnable Then Begin
    Cur := LoadCursor(0, IDC_SIZENS);

    If (Cur<>0) then begin
      SetCursor(Cur);
      TSbsPage(Parent).DispMsg (msgidx_ControlInfo, 'End of ' + FName);
    end { If }
    else
      Inherited;
  End; { If }
end;

Procedure TSBSSepBar.DrawMoveBox;
Var
  ScreenDC              : HDC;
  TheRect               : TRect;
  Coords                : TPoint;
  TopLimit, BottomLimit, ClientHeight : Integer;
begin
  If (FMoveTop > -1 ) And FPage.PaperHandleSet Then
    With FPage.FController.Paper Do Begin
      { Get handle for screen }
      ScreenDC:=GetDC(0);

      { Calculate screen equivalent of page controls boundary rectangle }
      TheRect.TopLeft := Parent.Parent.ClientToScreen (Parent.BoundsRect.TopLeft);
      TheRect.BottomRight := Parent.Parent.ClientToScreen (Parent.BoundsRect.BottomRight);
      ClientHeight := FPage.ClientRect.Bottom - FPage.ClientRect.Top;

      { Calculate unusable area at top of pages client }
      TopLimit := 0;
      If (FPage.VertScrollBar.Position <= (psBorderWidth + 1)) Then
        TopLimit := psBorderWidth + 1 - FPage.VertScrollBar.Position;

      { Calculate unusable area at top of pages client }
      BottomLimit := 0;
      If ((FPage.VertScrollBar.Range - psBorderWidth - 1) <=
          (FPage.VertScrollBar.Position + ClientHeight)) Then Begin
        BottomLimit := (FPage.VertScrollBar.Position + ClientHeight) -
                       (FPage.VertScrollBar.Range - psBorderWidth - 1);
      End; { If }

      { adjust rect for limits of control size }
      TheRect.Top := TheRect.Top + 1 + TopLimit;
      TheRect.Bottom := TheRect.Bottom - Height - BottomLimit - 1 - GetSystemMetrics (SM_CYHSCROLL);
      TheRect.Left := TheRect.Left + 1;
      TheRect.Right := TheRect.Right - 1 - GetSystemMetrics (SM_CXVSCROLL);

      { Check the cursor is within the page control }
      If (FMoveTop < TheRect.Top) Then FMoveTop := TheRect.Top;
      If (FMoveTop > TheRect.Bottom) Then FMoveTop := TheRect.Bottom;

      { Check the cursor has not passed a sepbar above or below }
      FMoveTop := Parent.ClientToScreen(Point(Left, TopOk(Parent.ScreenToClient(Point(Left, FMoveTop)).Y))).Y;

      { Move cursor to correct point }
      GetCursorPos (Coords);
      SetCursorPos (Coords.X, FMoveTop);

      { update rect position for new Y position }
      TheRect.Top := FMoveTop;
      TheRect.Bottom := FMoveTop + Height;

      { draw new rectangle }
      DrawFocusRect(ScreenDC, TheRect);

      { free screen handle }
      ReleaseDC(0,ScreenDC);
    End; { With }
end;

procedure TSBSSepBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ScreenDC, ParentDC : HDC;
  AvailRect          : TRect;
  ClipIdx            : Integer;
begin
  If FEnable Then Begin
    Inherited MouseDown (Button, Shift, X, Y);

    If (Button = mbLeft) Then Begin
      FDragging := True;
      FMoveTop := Parent.ClientToScreen (Point(Left, Top + Y)).Y;
      OrigMoveTop := FMoveTop;
      DrawMoveBox;
      SetCapture (Handle);
    End; { If }
  End; { If }
end;

procedure TSBSSepBar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  If FEnable Then Begin
    If FDragging And (GetCapture = Handle) And (ssLeft In Shift) And (FMoveTop > -1) Then Begin
      { Check that its moved and its within limits }
      If (FMoveTop <> Parent.ClientToScreen (Point (Left,Top + Y)).Y) Then Begin
        DrawMoveBox;
        FMoveTop := Parent.ClientToScreen (Point (Left,Top + Y)).Y;
        DrawMoveBox;
      End; { If }
    End; { If }

    FPage.DispCursorPos;

    Inherited MouseMove (Shift, X, Y);
  End; { If }
end;

procedure TSBSSepBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IF FEnable Then Begin
    If FDragging Then Begin
      FDragging := False;
      ReleaseCapture;
      Top := Parent.ScreenToClient(Point(Left,FMoveTop)).Y;
      FMoveTop := -1;
      Paint;
      If FPage.ControllerHandleSet Then
        FPage.FController.ChangeMade;

      With FPage.FController.FormDetails Do
        Case FIndex Of
          1 : ftHeaderSep   := FPage.VertScrollBar.Position + Top;
          2 : ftBodyHeadSep := FPage.VertScrollBar.Position + Top;
          3 : ftBodySep     := FPage.VertScrollBar.Position + Top;
          4 : ftBodyFootSep := FPage.VertScrollBar.Position + Top;
        End; { Case }
    End; { If }

    inherited MouseUp(Button, Shift, X, Y);
  End; { If }
end;

Function TSBSSepBar.TopOk (Y : Integer) : Integer;
Var
  Min, Max : Integer;
begin
  With TSBSPage (Parent), FController Do Begin
    Case FIndex Of
      1 : Begin
            Min := Paper.psBorderWidth;
            Max := FSections[2].Top - FSections[1].Height - 1;
          End;
      2 : Begin
            Min := FSections[1].Top + FSections[1].Height + 1;
            Max := FSections[3].Top - FSections[2].Height - 1;
          End;
      3 : Begin
            Min := FSections[2].Top + FSections[2].Height + 1;
            Max := FSections[4].Top - FSections[3].Height - 1;
          End;
      4 : Begin
            Min := FSections[3].Top + FSections[3].Height + 1;
            Max := Paper.psBorderWidth + 1 + Paper.InPixels(Paper.psPageHeight);
          End;
    End; { Case }

    If (Y < Min) Then
      Result := Min
    Else
      If (Y > Max) Then
        Result := Max
      Else
        Result := Y;
  End; { With }
end;

procedure TSBSSepBar.SetEnable(Value : Boolean);
begin
  If (FEnable <> Value) Then Begin
    FEnable := Value;
    Invalidate;
  End; { If }
end;

