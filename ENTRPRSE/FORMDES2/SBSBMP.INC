constructor TSBSPaperBmp.Create(AControl: TSBSPage);
begin
  Inherited Create;

  { Take copy of pointer to parent page control }
  FParentPage := AControl;
end;

procedure TSBSPaperBmp.UpdateBitmap;
begin
  { Reset size of bitmap }
  If FParentPage.ControllerHandleSet Then Begin
    With FParentPage, FController, Paper Do Begin
      FBitmap.Height := (psBorderWidth * 2) + 2 + InPixels(psPageHeight);
      FBitmap.Width  := (psBorderWidth * 2) + 2 + InPixels(psPageWidth);
    End; { With }

    { Redraw Bitmap }
    FParentPage.FController.Paper.Paint (Canvas);
    FParentPage.FController.Grid.Paint (Canvas);
    FParentPage.Invalidate;
  End; { If }
end;

