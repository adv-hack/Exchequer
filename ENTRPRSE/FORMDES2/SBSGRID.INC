constructor TSBSPaperGrid.Create(AController: TSBSController);
begin
  Inherited Create;

  { Take copy of pointer to parent page control }
  FController := AController;

  { Set defaults }
  FDisplayGrid := True;
  FSnapToGrid  := False;
  FXSpacing    := 4;       { mm }
  FYSpacing    := 4;       { mm }
end;

procedure TSBSPaperGrid.Assign(Source: TPersistent);
begin
  if Source is TSBSPaperGrid then begin
    grDisplayGrid := TSBSPaperGrid(Source).grDisplayGrid;
    grSnapToGrid  := TSBSPaperGrid(Source).grSnapToGrid;
    grXSpacing    := TSBSPaperGrid(Source).grXSpacing;
    grYSpacing    := TSBSPaperGrid(Source).grYSpacing;

    Exit;
  end; { If }

  inherited Assign(Source);
end;

{ Returns a TRECT that contains the edges of the grid }
Procedure TSBSPaperGrid.GetGridSizes (Var   GridRect     : TRect;
                                      Var   GridX, GridY : Integer;
                                      Const Drawing      : Boolean);
Begin
  With FController, Paper Do Begin
    GridRect.Left := psBorderWidth + 1;
    GridRect.Right := GridRect.Left + InPixels(psPageWidth) - 1;
    GridRect.Top := psBorderWidth + 1;
    GridRect.Bottom := GridRect.Left + InPixels(psPageHeight);

    If Drawing Or grSnapToGrid Then Begin
      GridX := InPixels(grXSpacing);
      GridY := InPixels(grYSpacing);
    End { If }
    Else Begin
      GridX := InPixels(1);
      GridY := InPixels(1);
    End; { Else }
  End; { With }
End;

procedure TSBSPaperGrid.Paint(TheCanvas: TCanvas);
Var
  GridRect         : TRect;
  I, J, IncX, IncY : Integer;
begin
  If grDisplayGrid Then
    With TheCanvas Do Begin
      GetGridSizes (GridRect, IncX, IncY, True);

      I := GridRect.Top;
      While (I <= GridRect.Bottom) Do Begin
        J := GridRect.Left;
        While (J <= GridRect.Right) Do Begin
          Pixels [J, I] := clGray;
          Inc (J, (IncX));
        End; { While }

        Inc (I, (IncY));
      End; { While }
    End; { With }
end;

Procedure TSBSPaperGrid.SetDisplayGrid(Value : Boolean);
begin
  If (Value <> FDisplayGrid) Then Begin
    FDisplayGrid := Value;
    FController.FPage.FBitmap.UpdateBitmap;
  End;
end;

Procedure TSBSPaperGrid.SetSnapToGrid(Value : Boolean);
begin
  If (Value <> FSnapToGrid) Then
    FSnapToGrid := Value;
end;

Procedure TSBSPaperGrid.SetXSpace(Value : LongInt);
begin
  If (Value <> FXSpacing) Then Begin
    FXSpacing := Value;
    FController.FPage.FBitmap.UpdateBitmap;
  End;
end;

Procedure TSBSPaperGrid.SetYSpace(Value : LongInt);
begin
  If (Value <> FYSpacing) Then Begin
    FYSpacing := Value;
    FController.FPage.FBitmap.UpdateBitmap;
  End;
end;

Procedure TSBSPaperGrid.SetXYSpace(X, Y : LongInt);
begin
  If (X <> FXSpacing) Or (Y <> FYSpacing) Then Begin
    FXSpacing := X;
    FYSpacing := Y;

    FController.FPage.FBitmap.UpdateBitmap;
  End; { If }
end;

{ Snaps to grid for screen co-ordinates }
procedure TSBSPaperGrid.ScreenSnapToGrid (Var   Rect : TRect;
                                          Const Mode : Byte);
Var
  cTop, cLeft, cHeight, cWidth : Integer;
begin
  { Convert screen to client coords}
  cTop    := FController.FPage.ScreenToClient (Point(Rect.Left, Rect.Top)).Y;
  cLeft   := FController.FPage.ScreenToClient (Point(Rect.Left, Rect.Top)).X;
  cHeight := FController.FPage.ScreenToClient (Point(Rect.Right, Rect.Bottom)).Y - cTop;
  cWidth  := FController.FPage.ScreenToClient (Point(Rect.Right, Rect.Bottom)).X - cLeft;

  { Snap to grid }
  SnapToGrid (cTop, cLeft, cHeight, cWidth, False, Mode);

  { Convert back to screen coords }
  Rect.Top    := FController.FPage.ClientToScreen (Point(cLeft, cTop)).Y;
  Rect.Left   := FController.FPage.ClientToScreen (Point(cLeft, cTop)).X;
  Rect.Bottom := Rect.Top + cHeight;
  Rect.Right  := Rect.Left + cWidth;
end;

procedure TSBSPaperGrid.SnapControlToGrid (      aControl : TControl;
                                           Const Force    : Boolean;
                                           Const Mode     : Byte);
Var
  cTop, cLeft, cHeight, cWidth : Integer;
begin
  cTop    := aControl.Top;
  cLeft   := aControl.Left;
  cHeight := aControl.Height;
  cWidth  := aControl.Width;

  { Snap to grid }
  SnapToGrid (cTop, cLeft, cHeight, cWidth, Force, Mode);

  aControl.Top    := cTop;
  aControl.Left   := cLeft;
  aControl.Height := cHeight;
  aControl.Width  := cWidth;
end;

{ Takes Client co-ords and checks whether they are positioned correctly }
procedure TSBSPaperGrid.SnapToGrid (Var   cTop,cLeft,cHeight,cWidth : Integer;
                                    Const Force                     : Boolean;
                                    Const Mode                      : Byte);
Const
  ModeCreate = 0; { Creating a Drag Control }
  MoveMove   = 1; { Moving a drag control }
  ModeSize   = 2; { Resizing a Drag Control }
Var
  GridRect            : TRect;
  GridX, GridY, Tries : Integer;
  OK                  : Boolean;

  { Checks that the control is small enough to fit on the page }
  Function CheckFit : Boolean;
  Var
    oHeight, oWidth : Integer;
  Begin
    With FController, Paper, Page Do Begin
      oHeight := cHeight;
      oWidth  := cWidth;

      { Check height is less than total page height }
      If (cHeight > VertScrollBar.Range) Then
        cHeight := VertScrollBar.Range - (2 * GridY);

      { Check width is less than total page width }
      If (cWidth > HorzScrollBar.Range) Then
        cWidth := HorzScrollBar.Range - (2 * GridX);

      { Return TRUE if height and width are ok }
      Result := (oHeight = cHeight) Or (oWidth = cWidth);
    End; { With }
  End;

  { Check top coord is a point on the grid }
  Function CheckTop : Boolean;
  Var
    oTop, pTop : Integer;
  begin
    With FController, Paper, Page Do Begin
      pTop := VertScrollBar.Position + cTop - GridRect.Top;
      oTop := pTop;

      If (pTop < 0) Then
        { Gone off top - set to first grid point }
        pTop := 0;

      While ((pTop Mod GridY) <> 0) Do
        Dec (pTop);

      If (pTop < 0) Then
        { Gone off top - set to first grid point }
        pTop := 0;

      cTop := GridRect.Top + pTop - VertScrollBar.Position;
      Result := (oTop = pTop);
    End; { With }
  end;

  { Check Bottom coord is a point on the grid }
  Function CheckBottom : Boolean;
  Var
    oTop, pBot : Integer;
  begin
    With FController, Paper, Page Do Begin
      pBot := VertScrollBar.Position + cTop + cHeight;
      oTop := cTop;

      If (pBot > GridRect.Bottom) Then Begin
        { Gone off top - set to Last grid point }
        cTop := GridRect.Bottom - VertScrollBar.Position - cHeight;
      End; { If }

      Result := (oTop = cTop);
    End; { With }
  end;

  Function CheckLeft : Boolean;
  Var
    oLeft, pLeft : Integer;
  begin
    With FController, Paper, Page Do Begin
      pLeft := HorzScrollBar.Position + cLeft - GridRect.Left;
      oLeft := pLeft;

      If (pLeft < 0) Then
        { Gone off side - set to first grid point }
        pLeft := 0;

      While ((pLeft Mod GridX) <> 0) Do
        Dec (pLeft);

      If (pLeft < 0) Then
        { Gone off side - set to first grid point }
        pLeft := 0;

      {cLeft := cLeft + (pLeft - oLeft);}
      cLeft := GridRect.Left + pLeft - HorzScrollBar.Position;
      Result := (oLeft = pLeft);
    End; { With }
  end;

  { Check Right coord is a point on the grid }
  Function CheckRight : Boolean;
  Var
    oLeft, pRight : Integer;
  begin
    With FController, Paper, Page Do Begin
      pRight := HorzScrollBar.Position + cLeft + cWidth;
      oLeft := cLeft;

      If (pRight > GridRect.Right) Then Begin
        { Gone off Right - set to last grid point }
        cLeft := GridRect.Right - HorzScrollBar.Position - cWidth;
      End; { If }

      Result := (oLeft = cLeft);
    End; { With }
  end;

  Function CheckHeight : Boolean;
  Var
    oHeight : Integer;
  begin
    oHeight := cHeight;

    { Check min height is exceeded }
    If (cHeight < MinControlHeight) Then cHeight := MinControlHeight;

    { Check height is valid for grid }
    While ((cHeight Mod GridY) <> 0) Do
      Inc (CHeight);

    Result := (oHeight = cHeight);
  end;

  Function CheckWidth : Boolean;
  Var
    oWidth : Integer;
  begin
    oWidth := cWidth;

    { Check min Width is exceeded }
    If (cWidth < MinControlWidth) Then cWidth := MinControlWidth;

    { Check width is valid for grid }
    While ((cWidth Mod GridX) <> 0) Do
      Inc (cWidth);

    Result := (oWidth = cWidth);
  end;

begin { TSBSPaperGrid.SnapToGrid }
  GetGridSizes (GridRect, GridX, GridY, Force);

  Tries := 0;
  Repeat
    Ok := CheckFit;                { Check the control fits on the page }
    Ok := CheckTop And Ok;
    Ok := CheckBottom And Ok;
    Ok := CheckLeft And Ok;
    Ok := CheckRight And Ok;
    Ok := CheckHeight And Ok;
    Ok := CheckWidth And Ok;

    Inc (Tries); { Just in case it gets a bit stuck }
  Until Ok or (Tries >= 60);
end;  { TSBSPaperGrid.SnapToGrid }

