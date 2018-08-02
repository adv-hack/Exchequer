unit DPView_History;

interface

Uses SysUtils, StdCtrls;

Procedure ProcessHistory(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);

implementation

Uses VarConst, DpViewFuncs;

//=========================================================================

Procedure ProcessHistory(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);
Begin // ProcessHistory
  If (DataBlockLen = SizeOf(NHist)) Then
  Begin
    Move (DataBlock^, NHist, SizeOf(NHist));

    OutputMemo.Lines.Add ('History');
    OutputMemo.Lines.Add ('--------');

    OutputChar    (OutputMemo, 'ExClass',   NHist.ExClass);
    OutputInteger (OutputMemo, 'Cr',        NHist.Cr);
    OutputInteger (OutputMemo, 'Yr',        NHist.Yr);
    OutputInteger (OutputMemo, 'Pr',        NHist.Pr);
    OutputDouble  (OutputMemo, 'Sales',     NHist.Sales, 2);
    OutputDouble  (OutputMemo, 'Purchases', NHist.Purchases, 2);
    OutputDouble  (OutputMemo, 'Cleared',   NHist.Cleared, 2);
    OutputDouble  (OutputMemo, 'Budget',    NHist.Budget, 2);
    OutputDouble  (OutputMemo, 'Budget2',   NHist.Budget2, 2);
    OutputDouble  (OutputMemo, 'Value1',    NHist.Value1, 2);
    OutputDouble  (OutputMemo, 'Value2',    NHist.Value2, 2);
    OutputDouble  (OutputMemo, 'Value3',    NHist.Value3, 2);
    {
    SpareV   :  Array[1..5] of Double;
    Spare    :  Array[1..30] of Byte;
    }
  End // If (DataBlockLen = SizeOf(NHist))
  Else
    OutputMemo.Lines.Add ('*** Document - NHist Invalid Size - ' + IntToStr(SizeOf(NHist)) + ' expected, ' + IntToStr(DataBlockLen) + ' received');
End; // ProcessHistory

end.