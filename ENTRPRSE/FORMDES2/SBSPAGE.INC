constructor TSBSPage.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  { set default values }
  Align := alClient;
  AutoScroll := True;
  BorderStyle := bsSingle;

  { Create child objects }
  FBitmap := TSBSPaperBmp.Create (Self);
  FDefaultFont := TFont.Create;
  FInCapture := False;
end;

destructor TSBSPage.Destroy;
Var
  I : Integer;
begin
  FDefaultFont.Free;
  For I := Low (FSections) To High (FSections) Do
    FSections[I].Free;
  FBitmap.Free;

  Inherited Destroy;
end;

procedure TSBSPage.Loaded;
Var
  I : Integer;
begin
  If (Not (csDesigning In ComponentState)) Then
    If (FController = Nil) Then
      Application.MessageBox ('ERROR: Controller not set',
                              'TSBSPage',
                              (MB_ICONSTOP Or MB_OK));
  { Draw page background }
  FBitmap.UpdateBitmap;

  { Create Child Components }
  For I := Low (FSections) To High (FSections) Do Begin
    FSections[I] := TSBSSepBar.Create (Self);
    FSections[I].Parent := Self;
  End; { For }

  If PaperHandleSet Then
    With FController, Paper, FormDetails do Begin
      Controller.Paper.SetScrollBars;

      FSections[1].SetPosition (1, 'Page Header', (stPageHead In ftSections), ftHeaderSep, clRed);
      FSections[2].SetPosition (2, 'Body Header', (stBodyHead In ftSections), ftBodyHeadSep, clRed);
      FSections[3].SetPosition (3, 'Main Body',   (stBody In ftSections), ftBodySep, clRed);
      FSections[4].SetPosition (4, 'Body Footer', (stBodyFoot In ftSections), ftBodyFootSep, clRed);

      ResetSections;
    End; { With }
end;

procedure TSBSPage.DispMsg (Idx : Integer; MsgStr : String);
begin
  If Assigned (FOnMessage) Then
    OnMessage (Self, Idx, MsgStr);
end;

procedure TSBSPage.Paint;
Var
  SourceRect, DestRect : TRect;
  I                    : Integer;
begin
  SourceRect.Top    := VertScrollBar.Position;
  SourceRect.Left   := HorzScrollBar.Position;
  SourceRect.Bottom := SourceRect.Top + Height + 10;
  SourceRect.Right  := SourceRect.Left + Width + 10;
  DestRect.Top    := 0;
  DestRect.Left   := 0;
  DestRect.Bottom := Height + 10;
  DestRect.Right  := Width + 10;
  Canvas.CopyMode := cmSrcCopy;
  Canvas.CopyRect (DestRect, FBitmap.Canvas, SourceRect);

  { Paint separator lines if necessary }
  {For I := Low (FSections) To High (FSections) Do Begin
    FSections[I].PaintControl;
  End; { For }

  { Paint Control ForeGrounds }
  If Assigned (FController) Then
    FController.PaintControlFores (ClientRect);
end;

{ Paints the specified Rectangle }
Procedure TSBSPage.PaintRect (PRect : TRect);
Var
  SourceRect, DestRect : TRect;
  I                    : Integer;
begin
  SourceRect.Top    := VertScrollBar.Position + PRect.Top;
  SourceRect.Left   := HorzScrollBar.Position + PRect.Left;
  SourceRect.Bottom := SourceRect.Top + (PRect.Bottom - PRect.Top);
  SourceRect.Right  := SourceRect.Left + (PRect.Right - PRect.Left);
  DestRect.Top    := PRect.Top;
  DestRect.Left   := PRect.Left;
  DestRect.Bottom := PRect.Bottom;
  DestRect.Right  := PRect.Right;

  Canvas.CopyMode := cmSrcCopy;
  Canvas.CopyRect (DestRect, FBitmap.Canvas, SourceRect);

  { Paint separator lines if necessary }
  For I := Low (FSections) To High (FSections) Do Begin
    If IntersectRect (SourceRect, DestRect, FSections[I].BoundsRect) Then
      FSections[I].PaintControl;
  End; { For }
end;

{ moves the seporator bars to the back of the drawing order }
procedure TSBSPage.SetSeparatorsToBack;
Var
  I  : Integer;
begin
  For I := Low (FSections) To High (FSections) Do Begin
    FSections[I].SendToBack;
  End; { For }
end;

procedure TSBSPage.WMSetCursor(var Msg: TWMSetCursor);
begin
  DispMsg (msgidx_ControlInfo, '');
  DispCursorPos;

  Inherited;
end;

procedure TSBSPage.DispCursorPos;
Var
  CoOrds : TPoint;
begin
  { Get cursor position }
  GetCursorPos (CoOrds);

  { Convert to page client co-ordinates }
  CoOrds := ScreenToClient(CoOrds);

  If ControllerHandleSet Then
    With FController, Paper Do Begin
      { adjust for border area }
      CoOrds.X := CoOrds.X - psBorderWidth - 1 + HorzScrollBar.Position;
      CoOrds.Y := CoOrds.Y - psBorderWidth - 1 + VertScrollBar.Position;

      { convert to mm }
      CoOrds.X := InMM(CoOrds.X);
      CoOrds.Y := InMM(CoOrds.Y);

      { Check > 0 }
      If (CoOrds.X < 0) Then CoOrds.X := 0;
      If (CoOrds.Y < 0) Then CoOrds.Y := 0;

      { display }
      DispMsg (msgidx_Position, 'X: ' + IntToStr(CoOrds.X) + 'mm   Y: ' + IntToStr(CoOrds.Y) + 'mm');
    End; { With }
end;

procedure TSBSPage.WMSize(var Message: TWMSize);
begin
  { need to reset scrollbars }
  If PaperHandleSet Then
    FController.Paper.SetScrollBars;
end;

Function TSBSPage.ControllerHandleSet : Boolean;
begin
  Result := (FController <> Nil);
End;

Function TSBSPage.PaperHandleSet : Boolean;
begin
  Result := ControllerHandleSet;
  If Result Then Result := FController.PaperHandleSet;
End;

Function TSBSPage.GridHandleSet : Boolean;
begin
  Result := ControllerHandleSet;
  If Result Then Result := FController.GridHandleSet;
End;

{ Ensures the mouse is in a valid area of the screen in relation to }
{ the page currently displayed when moving a control }
Procedure TSBSPage.CheckMousePos (      DragControl : TControl;
                                  Const XOff, YOff  : Integer);
Var
  MouseLimits, Control : TRect;
  MousePos, LimitPos   : TPoint;
  Tmp, XOff2, YOff2    : Integer;   { Control offest from bottom right }
begin
  If Assigned (FController) Then
    If FController.PaperHandleSet Then
      With FController.Paper Do Begin
        { Calculate offsets from bottom right corner of control }
        XOff2 := ABS(DragControl.Width - XOff);
        YOff2 := ABS(DragControl.Height - YOff);

        { Get page client area in screen coords }
        MouseLimits.TopLeft := Parent.ClientToScreen (BoundsRect.TopLeft);
        MouseLimits.BottomRight := Parent.ClientToScreen (BoundsRect.BottomRight);

        { Remove area covered by Scroll bars }
        MouseLimits.Right := MouseLimits.Right - 1 - GetSystemMetrics (SM_CXVSCROLL);
        MouseLimits.Bottom := MouseLimits.Bottom - 1 - GetSystemMetrics (SM_CYHSCROLL);

        { Calculate Top Limit of Mouse Movement in screen coords }
        If (VertScrollBar.Position <= (psBorderWidth + 1 + YOff)) Then
          MouseLimits.Top := MouseLimits.Top + (psBorderWidth + 2 + YOff - VertScrollBar.Position);

        { Calculate Left Limit of Mouse Movement in screen coords }
        If (HorzScrollBar.Position <= (psBorderWidth + 1 + XOff)) Then
          MouseLimits.Left := MouseLimits.Left + (psBorderWidth + 2 + XOff - HorzScrollBar.Position);

        { Calculate Right Limit of Mouse Movement in screen coords }
        Tmp := (HorzScrollBar.Position + ClientWidth);
        If (Tmp > (HorzScrollBar.Range - (psBorderWidth + 1 + XOff2))) Then
          MouseLimits.Right := MouseLimits.Right - (Tmp - (HorzScrollBar.Range - (psBorderWidth + 1 + XOff2)));

        { Calculate Bottom Limit of Mouse Movement in screen coords }
        Tmp := (VertScrollBar.Position + ClientHeight);
        If (Tmp > (VertScrollBar.Range - (psBorderWidth + 1 + YOff2))) Then
          MouseLimits.Bottom := MouseLimits.Bottom - (Tmp - (VertScrollBar.Range - (psBorderWidth + 1 + YOff2)));

        { Get mouse position }
        GetCursorPos (MousePos);
        LimitPos := MousePos;

        { Check mouse is in a valid position }
        If (LimitPos.X < MouseLimits.Left) Then LimitPos.X := MouseLimits.Left;
        If (LimitPos.X > MouseLimits.Right) Then LimitPos.X := MouseLimits.Right;
        If (LimitPos.Y < MouseLimits.Top) Then LimitPos.Y := MouseLimits.Top;
        If (LimitPos.Y > MouseLimits.Bottom) Then LimitPos.Y := MouseLimits.Bottom;

        { Move cursor to correct point (if necessary) }
        If (MousePos.X <> LimitPos.X) Or (MousePos.Y <> LimitPos.Y) Then Begin
          SetCursorPos (LimitPos.X, LimitPos.Y);
        End; { If }
      End; { With }
end;

{ Checks the passed rectangle is within the page client area }
Procedure TSBSPage.CheckMoveRect (Var EndRect : TRect);
Var
  Coords : TPoint;
begin
  { Check Top-Left }
  Coords := Parent.ClientToScreen (BoundsRect.TopLeft);
  If (EndRect.Top < Coords.Y) Then EndRect.Top := Coords.Y;
  If (EndRect.Left < Coords.X) Then EndRect.Left := Coords.X;

  { Check Bottom-Right }
  Coords := Parent.ClientToScreen (BoundsRect.BottomRight);
  Coords.X := Coords.X - GetSystemMetrics (SM_CXVSCROLL) - 1;
  Coords.Y := Coords.Y - GetSystemMetrics (SM_CYHSCROLL) - 1;
  If (EndRect.Bottom > Coords.Y) Then EndRect.Bottom := Coords.Y;
  If (EndRect.Right > Coords.X) Then EndRect.Right := Coords.X;
end;


{ Ensures the mouse is in a valid area of the screen in relation to }
{ the page currently displayed when resizing a control }
Procedure TSBSPage.CheckMouseSizePos (DragControl : TControl);
Var
  SizeControl          : TSBSDragControl;
  MouseLimits, Control : TRect;
  MousePos, LimitPos   : TPoint;
  Tmp                  : Integer;   { Control offest from bottom right }
begin
  If Assigned (FController) And Assigned (DragControl) Then
    If FController.PaperHandleSet Then
      With FController.Paper Do Begin
        { Get a proper handle on control }
        SizeControl := TSBSDragControl(DragControl);

        { Get page client area in screen coords }
        MouseLimits.TopLeft := Parent.ClientToScreen (BoundsRect.TopLeft);
        MouseLimits.BottomRight := Parent.ClientToScreen (BoundsRect.BottomRight);

        { Remove area covered by Scroll bars }
        MouseLimits.Right := MouseLimits.Right - 1 - GetSystemMetrics (SM_CXVSCROLL);
        MouseLimits.Bottom := MouseLimits.Bottom - 1 - GetSystemMetrics (SM_CYHSCROLL);

        { Calculate Top Limit of Mouse Movement in screen coords }
        If (VertScrollBar.Position <= (psBorderWidth + 1)) Then
          MouseLimits.Top := MouseLimits.Top + (psBorderWidth + 2 - VertScrollBar.Position);

        { Calculate Left Limit of Mouse Movement in screen coords }
        If (HorzScrollBar.Position <= (psBorderWidth + 1)) Then
          MouseLimits.Left := MouseLimits.Left + (psBorderWidth + 2 - HorzScrollBar.Position);

        { Calculate Right Limit of Mouse Movement in screen coords }
        Tmp := (HorzScrollBar.Position + ClientWidth);
        If (Tmp > (HorzScrollBar.Range - (psBorderWidth + 1))) Then
          MouseLimits.Right := MouseLimits.Right - (Tmp - (HorzScrollBar.Range - (psBorderWidth + 1)));

        { Calculate Bottom Limit of Mouse Movement in screen coords }
        Tmp := (VertScrollBar.Position + ClientHeight);
        If (Tmp > (VertScrollBar.Range - (psBorderWidth + 1))) Then
          MouseLimits.Bottom := MouseLimits.Bottom - (Tmp - (VertScrollBar.Range - (psBorderWidth + 1)));

        { Make sure the resize is limited by the controls other sides }
        With SizeControl Do Begin
          Case FSizeType Of
            TopLeft      : Begin
                             MouseLimits.Right := SizeRect.Right - MinControlWidth;
                             MouseLimits.Bottom := SizeRect.Bottom - MinControlHeight;
                           End;
            TopCentre    : Begin
                             MouseLimits.Left := SizeRect.Left + 3;
                             MouseLimits.Bottom := SizeRect.Bottom - MinControlHeight;
                             MouseLimits.Right := SizeRect.Right - 3;
                           End;
            TopRight     : Begin
                             MouseLimits.Bottom := SizeRect.Bottom - MinControlHeight;
                             MouseLimits.Left := SizeRect.Left + MinControlWidth;
                           End;
            CentreLeft   : Begin
                             MouseLimits.Top := SizeRect.Top + 3;
                             MouseLimits.Right := SizeRect.Right - MinControlWidth;
                             MouseLimits.Bottom := SizeRect.Bottom - 3;
                           End;
            CentreRight  : Begin
                             MouseLimits.Top := SizeRect.Top + 3;
                             MouseLimits.Left := SizeRect.Left + MinControlWidth;
                             MouseLimits.Bottom := SizeRect.Bottom - 3;
                           End;
            BottomLeft   : Begin
                             MouseLimits.Top := SizeRect.Top + MinControlHeight;
                             MouseLimits.Right := SizeRect.Right - MinControlWidth;
                           End;
            BottomCentre : Begin
                             MouseLimits.Left := SizeRect.Left + 3;
                             MouseLimits.Top := SizeRect.Top + MinControlHeight;
                             MouseLimits.Right := SizeRect.Right - 3;
                           End;
            BottomRight  : Begin
                             MouseLimits.Top := SizeRect.Top + MinControlHeight;
                             MouseLimits.Left := SizeRect.Left + MinControlWidth;
                           End;
          End; { If }
        End; { With }

        { Get mouse position }
        GetCursorPos (MousePos);
        LimitPos := MousePos;

        { Check mouse is in a valid position }
        If (LimitPos.X < MouseLimits.Left) Then LimitPos.X := MouseLimits.Left;
        If (LimitPos.X > MouseLimits.Right) Then LimitPos.X := MouseLimits.Right;
        If (LimitPos.Y < MouseLimits.Top) Then LimitPos.Y := MouseLimits.Top;
        If (LimitPos.Y > MouseLimits.Bottom) Then LimitPos.Y := MouseLimits.Bottom;

        { Move cursor to correct point (if necessary) }
        If (MousePos.X <> LimitPos.X) Or (MousePos.Y <> LimitPos.Y) Then Begin
          SetCursorPos (LimitPos.X, LimitPos.Y);
        End; { If }
      End; { With }
end;


{ Draws a move/resize box on the screen canvas checking for the client area }
Procedure TSBSPage.DrawBox (Var StartRect, EndRect : TRect);
Var
  ScreenDC : HDC;
begin
  { Check we need to redraw the rectangle }
  If Not EqualRect (StartRect, EndRect) Then Begin
    { Get handle for screen }
    ScreenDC:=GetDC(0);

    { Erase existing rubber-band rectangle }
    If Not EqualRect (EmptyRect, StartRect) Then Begin
      {StRect.TopLeft := ClientToScreen (StartRect.TopLeft);
      StRect.BottomRight := ClientToScreen (StartRect.BottomRight);}
      DrawFocusRect(ScreenDC, StartRect);
    End; { If }

    { draw new rectangle }
    If Not EqualRect (EmptyRect, StartRect) Then Begin
      EndRect.TopLeft := ClientToScreen (EndRect.TopLeft);
      EndRect.BottomRight := ClientToScreen (EndRect.BottomRight);

      CheckMoveRect (EndRect);
      DrawFocusRect(ScreenDC, EndRect);
    End; { If }

    { free screen handle }
    ReleaseDC(0,ScreenDC);
  End; { If }
end;

procedure TSBSPage.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  Inherited MouseDown (Button, Shift, X, Y);

  If Assigned (FController) And
     (Not (csDesigning In ComponentState)) And
     (Button = mbLeft) Then Begin
    FInCapture := True;

    If CanFocus Then SetFocus;

    FStartX := X;
    FStartY := Y;

    With FDragRect Do Begin
      Left   := Iif (FStartX < X, FStartX, X);
      Top    := Iif (FStartY < Y, FStartY, Y);
      Right  := Iif (FStartX > X, FStartX, X);
      Bottom := Iif (FStartY > Y, FStartY, Y);
    End; { With }

    DrawBox (EmptyRect, FDragRect);
  End; { If }
End;

procedure TSBSPage.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
  Coords   : TPoint;
  TempRect : TRect;
Begin
  If (GetCapture = Handle) And (ssLeft In Shift) Then Begin
    { Take copy of current rectangle coords }
    TempRect := FDragRect;

    { Get mouse position }
    GetCursorPos (Coords);
    Coords := ScreenToClient (Coords);

    { Calculate size rectangle }
    With FDragRect Do Begin
      Left   := Iif (FStartX < Coords.X, FStartX, Coords.X);
      Top    := Iif (FStartY < Coords.Y, FStartY, Coords.Y);
      Right  := Iif (FStartX > Coords.X, FStartX, Coords.X);
      Bottom := Iif (FStartY > Coords.Y, FStartY, Coords.Y);
    End; { With }

    { Draw the drag box }
    DrawBox (TempRect, FDragRect);
  End; { If }

  Inherited MouseMove(Shift, X, Y);
End;

procedure TSBSPage.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  { code to finish the drag box here }
  If FInCapture Then Begin
    FInCapture := False;

    DrawBox (FDragRect, EmptyRect);

    If Assigned (FController) Then Begin
      { convert FDragRect to Client coordinates and pass to controller }
      FDragRect.TopLeft := ScreenToClient (FDragRect.TopLeft);
      FDragRect.BottomRight := ScreenToClient (FDragRect.BottomRight);
      FController.SelectArea (FDragRect);
    End; { If }
  End; { If }

  Inherited MouseUp(Button, Shift, X, Y);
End;

