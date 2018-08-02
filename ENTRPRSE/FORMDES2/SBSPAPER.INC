{ Include file containing the methods for TSbsPaperSize}
constructor TSBSPaperSize.Create(AController : TSBSController);
begin
  Inherited Create;

  { Take copy of pointer to parent page control }
  FController := AController;

  { Create bitmap control }
  FShade := TBitmap.Create;

  { Set defaults }
  FBorderWidth := 16;    { pixels }
  FPageHeight  := 420;   { mm }
  FPageWidth   := 420;   { mm }

  FPaperHeight := 297;
  FPaperWidth  := 210;
  {FTop         := 20;}        { mm }
  {FLeft        := 10;}        { mm }
  {FRight       := 10;}
  {FBottom      := 20;}

  {psWidth  := FPaperHeight - FLeft - FRight;}
  {psHeight := FPaperHeight - FTop - FBottom;}

  FScaling := 3;         { pixels to the mm }
  FDeskColour := clBtnShadow;
  If FController.PageHandleSet Then
    FController.FPage.Color := FDeskColour;
end;

destructor TSBSPaperSize.Destroy;
begin
  { Release bitmap control }
  FShade.Free;

  Inherited Destroy;
end;

procedure TSBSPaperSize.Assign(Source: TPersistent);
begin
  if Source is TSBSPaperSize then begin
    {sTop         := TSBSPaperSize(Source).psTop;
    psLeft        := TSBSPaperSize(Source).psLeft;
    psRight       := TSBSPaperSize(Source).psRight;
    psBottom      := TSBSPaperSize(Source).psBottom;
    {psWidth       := TSBSPaperSize(Source).psWidth;}
    {psHeight      := TSBSPaperSize(Source).psHeight;}
    psBorderWidth := TSBSPaperSize(Source).psBorderWidth;
    psPageHeight  := TSBSPaperSize(Source).psPageHeight;
    psPageWidth   := TSBSPaperSize(Source).psPageWidth;
    psScaling     := TSBSPaperSize(Source).psScaling;
    psShade       := TSBSPaperSize(Source).psShade;
    psDeskColour  := TSBSPaperSize(Source).psDeskColour;
    {psPaperHeight := TSBSPaperSize(Source).psPaperHeight;
    psPaperWidth  := TSBSPaperSize(Source).psPaperWidth;}

    Exit;
  end; { If }

  inherited Assign(Source);
end;

procedure TSBSPaperSize.Paint(TheCanvas: TCanvas);
Var
  TopOfs, LeftOfs, PHeight, PWidth : LongInt;
begin
  With FController, FormDetails, TheCanvas Do Begin
    { Draw Page background }
    TopOfs  := 0;
    LeftOfs := 0;
    PHeight := (Paper.psBorderWidth * 2) + 3 + Paper.InPixels(Paper.psPageHeight);
    PWidth  := (Paper.psBorderWidth * 2) + 3 + Paper.InPixels(Paper.psPageWidth);
    Pen.Color := Paper.psDeskColour;
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;
    Pen.Width := 1;
    Brush.Color := Paper.psDeskColour;
    Rectangle (LeftOfs, TopOfs, (LeftOfs + PWidth), (TopOfs + PHeight));

    { Draw Paper (shaded) }
    TopOfs  := TopOfs + psBorderWidth;
    LeftOfs := LeftOfs + psBorderWidth;
    PHeight := InPixels(psPageHeight) + 2;
    PWidth  := InPixels(psPageWidth) + 2;
    Pen.Color := clBlack;
    Brush.Color := clSilver;
    If Not psShade.Empty Then
      Brush.Bitmap := psShade;
    Rectangle (LeftOfs, TopOfs, (LeftOfs + PWidth), (TopOfs + PHeight));

    { Draw Paper - working area }
    If (ftOrientation = fdoPortrait) Then Begin
      TopOfs  := TopOfs + 1 + InPixels(ftTopMargin);
      LeftOfs := LeftOfs + 1 + InPixels(ftLeftMargin);
    End { If }
    Else Begin
      TopOfs  := TopOfs + 1 + InPixels(ftLeftMargin);
      LeftOfs := LeftOfs + 1 + InPixels(ftBottomMargin);
    End; { Else }
    PHeight := InPixels(GetWorkingHeight);
    PWidth  := InPixels(GetWorkingWidth);
    Pen.Color := clWhite;
    Brush.Color := clWhite;
    Rectangle (LeftOfs, TopOfs, (LeftOfs + PWidth), (TopOfs + PHeight));
  End; { With }
end;

(*procedure TSBSPaperSize.SetTop(Value: LongInt);
begin
  If (Value <> FTop) Then Begin
    FTop := Value;
    psHeight := FPaperHeight - FTop - FBottom;

    SetScrollBars;
    FParentPage.FBitmap.UpdateBitmap;
  End; { If }
end;

procedure TSBSPaperSize.SetLeft(Value: LongInt);
begin
  If (Value <> FLeft) Then Begin
    FLeft := Value;
    psWidth := FPaperWidth - FLeft - FRight;

    SetScrollBars;
    FParentPage.FBitmap.UpdateBitmap;
  End; { If }
end;

procedure TSBSPaperSize.SetRight(Value: LongInt);
begin
  If (Value <> FRight) Then Begin
    FRight := Value;
    psWidth := FPaperWidth - FLeft - FRight;

    SetScrollBars;
    FParentPage.FBitmap.UpdateBitmap;
  End; { If }
end;

procedure TSBSPaperSize.SetBottom(Value: LongInt);
begin
  If (Value <> FBottom) Then Begin
    FBottom := Value;
    psHeight := FPaperHeight - FTop - FBottom;

    SetScrollBars;
    FParentPage.FBitmap.UpdateBitmap;
  End; { If }
end;*)

(*
procedure TSBSPaperSize.SetWidth(Value: LongInt);
begin
  If (Value <> FWidth) Then Begin
    FWidth := Value;
    FPaperWidth := FLeft + FWidth;

    SetScrollBars;
    FParentPage.FBitmap.UpdateBitmap;
  End; { If }
end;

procedure TSBSPaperSize.SetHeight(Value: LongInt);
begin
  If (Value <> FHeight) Then Begin
    FHeight := Value;
    FPaperHeight := FTop + FHeight;

    SetScrollBars;
    FParentPage.FBitmap.UpdateBitmap;
  End; { If }
end;
*)

procedure TSBSPaperSize.SetPageWidth(Value: LongInt);
begin
  If (Value <> FPageWidth) Then Begin
    FPageWidth := Value;

    SetScrollBars;
    FController.UpdateBitmap;
  End;
end;

procedure TSBSPaperSize.SetPageHeight(Value: LongInt);
begin
  If (Value <> FPageHeight) Then Begin
    FPageHeight := Value;

    SetScrollBars;
    FController.UpdateBitmap;
  End;
end;

(*procedure TSBSPaperSize.SetPaperWidth(Value: LongInt);
begin
  If (Value <> FPaperWidth) Then Begin
    FPaperWidth := Value;
    psWidth := FPaperWidth - FLeft - FRight;
  End;
end;

procedure TSBSPaperSize.SetPaperHeight(Value: LongInt);
begin
  If (Value <> FPaperHeight) Then Begin
    FPaperHeight := Value;
    psHeight := FPaperHeight - FTop - FBottom;
  End;
end;*)

procedure TSBSPaperSize.SetBorderWidth(Value: LongInt);
begin
  If (Value <> FBorderWidth) Then Begin
    FBorderWidth := Value;

    SetScrollBars;
    FController.UpdateBitmap;
  End;
end;

procedure TSBSPaperSize.SetScaling(Value: Single);
begin
  If (Value <> FScaling) Then Begin
    FScaling := Trunc (Value * 100) / 100;

    SetScrollBars;
    FController.UpdateBitmap;
  End;
end;

procedure TSBSPaperSize.SetShade(Value: TBitmap);
begin
  FShade.Assign(Value);

  FController.UpdateBitmap;
end;

procedure TSBSPaperSize.SetDeskColour(Value: TColor);
begin
  If (Value <> FDeskColour) Then Begin
    FDeskColour := Value;

    If FController.PageHandleSet Then
      FController.FPage.Color := Value;

    FController.UpdateBitmap;
  End;
end;

function TSBSPaperSize.InPixels(Const InMM : LongInt) : LongInt;
Var
  Tmp : Double;
begin
  If (FScaling > 0) Then Begin
    Tmp := InMM * FScaling;
    Result := Round(Tmp);
  End { If }
  Else
    Result := InMM;
end;

function TSBSPaperSize.InMM(Const InPixels : LongInt) : LongInt;
Var
  Tmp : Double;
begin
  If (FScaling > 0) Then Begin
    Tmp := InPixels / FScaling;
    Result := Round(Tmp);
  End { If }
  Else
    Result := InPixels;
end;

procedure TSBSPaperSize.SetScrollBars;
begin
  { Reset the scrollbar range }
  If FController.PageHandleSet Then
    With FController.FPage Do Begin
       VertScrollBar.DoSetRange ((FBorderWidth * 2) + 2 + InPixels(FPageHeight));
       HorzScrollBar.DoSetRange ((FBorderWidth * 2) + 2 + InPixels(FPageWidth));
    End; { With }
end;

