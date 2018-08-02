{************************************************************************}
{* Batch Printing Routines                                              *}
{************************************************************************}
procedure TForm_PrintTest.PrintLabel_BeforePrint(Sender: TObject);
begin
  { Build cache of label positions }
  BuildLabelPos;

  { fake the info for db access }
  CurrJob := TPrintBatchObjType.Create;
  FillChar (CurrJob.PrintBatch, SizeOf (CurrJob.PrintBatch), #0);
  With CurrJob.PrintBatch Do Begin
    pbDefMode   := HeaderRec.fhPurpose;

    Case pbDefMode Of
      0,          { Customer Labels }
      1  : Begin  { Supplier Labels }
             pbMainFNum  := CustF;
             pbMainKPath := CustCodeK;
           End;
      2  : Begin  { Stock Labels }
             pbMainFNum  := StockF;
             pbMainKPath := StkCodeK;
           End;
    End; { Case }
    DrivingFile := pbMainFNum;
  End; { PrintBatchRecType }
End;


Procedure TForm_PrintTest.PrintLabel_AfterPrint(Sender: TObject);
Begin
  CurrJob.Free;
End;


{ Prints the labels }
procedure TForm_PrintTest.PrintLabel_Print(Sender: TObject);
Var
  CurrentLabel : LongInt;
  I            : Integer;
begin
  With TheReport, HeaderRec Do Begin
    CurrentLabel := LblStart;

    { Get first db record }
    PrintLabel_GetNextRec (B_GetFirst);

    // HM 06/04/05: Added counters so labels can print '1 of 3', '2 of 3', ...
    DefTotals[1] := LblRepeat;
    For I := 1 To LblRepeat Do Begin
      DefTotals[0] := I;

      OriginX := LabelPos^[CurrentLabel].Left - fhLblLeft;
      OriginY := LabelPos^[CurrentLabel].Top - fhLblTop;

      { Print Body - all controls are in body for a label }
      PrintControlList (BodyList);

      If (I < LblRepeat) Then Begin
        Inc(CurrentLabel);
        If (CurrentLabel > (fhLblRows * fhLblCols)) Then Begin
          CurrentLabel := 1;
          NewPage;
        End; { If }

        { get next db record }
        PrintLabel_GetNextRec (B_GetNext);
      End; { If }
    End; { For }
  End; { With }
end;


{ Gets an actual db record to use in the preview }
Procedure TForm_PrintTest.PrintLabel_GetNextRec (Const BtrMode : SmallInt);
Begin
  With CurrJob.PrintBatch Do Begin
    Status := Find_Rec (BtrMode, F[pbMainFnum], pbMainFnum, RecPtr[pbMainFnum]^, pbMainKPath, pbMainKRef);

    If (Status = 9) And (BtrMode = B_GetNext) Then
      PrintLabel_GetNextRec (B_GetFirst);

    TCust^ := Cust;
  End; { With }
End;


{ Build cache of label positions in printing order }
Procedure TForm_PrintTest.BuildLabelPos;
Var
  I, J, LblNo, TopOfs, LeftOfs : LongInt;
Begin
  With HeaderRec Do Begin
    LblNo := 1;
    TopOfs := fhLblTop;
    For I := 1 To fhLblRows Do Begin
      LeftOfs := fhLblLeft;

      For J := 1 to fhLblCols Do Begin
        If (fhOrientation = fdoLandScape) Then
          LblNo := ((fhLblCols - J) * fhLblRows) + I;

        { Draw Label }
        With LabelPos^[LblNo] Do Begin
          Left   := LeftOfs;
          Top    := TopOfs;
          Right  := LeftOfs + fhLblWidth;    { Won't actually be needed during label printing }
          Bottom := TopOfs + fhLblHeight;    { Won't actually be needed during label printing }
        End; { With }

        { move across to next label }
        LeftOfs := LeftOfs + fhLblWidth + fhLblColGap;

        Inc (LblNo);
      End; { For }

      TopOfs := TopOfs + fhLblHeight + fhLblRowGap;
    End; { For }

    {For I := 1 To (fhLblCols * fhLblRows) Do
      With LabelPos^[I] Do
        DBug.Msg (0, 'LabelPos' + IntToStr(I) + ' = (Top: ' + IntToStr(Top) + ', Left:' + IntToStr(Left) + ')');}
  End; { With }
End;




