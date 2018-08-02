{************************************************************************}
{* Test Form Size Print Routines                                        *}
{************************************************************************}
procedure TForm_PrintTest.TestSize_BeforePrint(Sender: TObject);
begin
  With Sender as TBaseReport, HeaderRec Do
    If (fhOrientation = fdoPortrait) Then
      Orientation := {RpBase}RpDefine.poPortrait
    Else
      { Landscape }
      Orientation := {RpBase}RpDefine.poLandscape;
end;

procedure TForm_PrintTest.TestSize_Print(Sender: TObject);
Var
  pTop, pLeft, pRight, pBottom : LongInt;
begin
  With Sender as TBaseReport, HeaderRec Do Begin
    If (fhOrientation = fdoPortrait) Then Begin
      pTop    := fhTopWaste;
      pLeft   := fhLeftWaste;
      pBottom := fhPaperHeight - fhBottomWaste;
      pRight  := fhPaperWidth - fhRightWaste;
    End { If }
    Else Begin
      { Landscape }
      pTop    := fhLeftWaste;
      pLeft   := fhPaperHeight - fhBottomWaste;
      pBottom := fhPaperWidth - fhRightWaste;
      pRight  := fhTopWaste;
    End; { If }

    SetPen (clBlack, psSolid, -1, pmCopy);

    MoveTo (pLeft,  pTop);
    LineTo (pRight, pTop);
    LineTo (pRight, pBottom);
    LineTo (pLeft,  pBottom);
    LineTo (pLeft,  pTop);

    SetFont ('Arial', 12);
    YPos := PageHeight * 0.4;
    PrintCenter ('Test Page Size', PageWidth / 2);

    SetFont ('Arial', 12);
    YPos := PageHeight * 0.5;
    PrintCenter ('A complete border should be', PageWidth / 2);
    YPos := PageHeight * 0.55;
    PrintCenter ('visible on this page', PageWidth / 2);
  End; { With }
end;




