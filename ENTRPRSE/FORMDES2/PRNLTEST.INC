{************************************************************************}
{* Test Form Size Print Routines                                        *}
{************************************************************************}
procedure TForm_PrintTest.TestLbl_BeforePrint(Sender: TObject);
begin
  With Sender as TBaseReport, HeaderRec Do
    If (fhOrientation = fdoPortrait) Then
      Orientation := RpDefine.poPortrait
    Else
      { Landscape }
      Orientation := RpDefine.poLandscape;

  { Build a list of label positions in ascending number order }
  BuildLabelPos;
end;

procedure TForm_PrintTest.TestLbl_Print(Sender: TObject);
Var
  I    : Byte;
  Rect : TRect;
begin
  With Sender as TBaseReport, HeaderRec Do Begin
    SetPen (clBlack, psSolid, -1, pmCopy);

    DoFont (fhFont);

    { Draw Labels }
    For I := 1 To (fhLblRows * fhLblCols) Do
      With LabelPos^[I] Do Begin
        { Draw Label }
        MoveTo (Left,  Top);
        LineTo (Right, Top);
        LineTo (Right, Bottom);
        LineTo (Left,  Bottom);
        LineTo (Left,  Top);

        { Print Label Number in label }
        Rect := CreateRect (Left + 1, Top + 1, Right - 1, Bottom - 1);
        ExtTextRect (Rect, DT_CENTER, IntToStr(I))
      End; { With }
  End; { With }
end;




