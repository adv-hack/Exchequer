unit DPView_MLocStk;

interface

Uses SysUtils, StdCtrls;

Procedure ProcessMLocStk(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);

implementation

Uses VarRec2U, VarConst, DpViewFuncs;

//=========================================================================

Procedure ProcessMLocStk(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);
begin
  If (DataBlockLen = SizeOf(MLocRec)) Then
  Begin
    Move (DataBlock^, MLocCtrl^, SizeOf(MLocRec));

    OutputMemo.Lines.Add ('MLocStk');
    OutputMemo.Lines.Add ('-------');

    OutputChar    (OutputMemo, 'RecPFix', MLocCtrl.RecPfix);
    OutputChar    (OutputMemo, 'SubType', MLocCtrl.SubType);

    if (MLocCtrl.RecPFix = 'K') and (MLocCtrl.SubType = '2') then
    begin
      OutputString (OutputMemo, 'brBnkDCode1', MLocCtrl.BnkRDRec.brBnkDCode1, SizeOf(MLocCtrl.BnkRDRec.brBnkDCode1) - 1);
      OutputString (OutputMemo, 'brBnkDCode2', MLocCtrl.BnkRDRec.brBnkDCode2, SizeOf(MLocCtrl.BnkRDRec.brBnkDCode2) - 1);
      OutputString (OutputMemo, 'brBnkDCode3', MLocCtrl.BnkRDRec.brBnkDCode3, SizeOf(MLocCtrl.BnkRDRec.brBnkDCode3) - 1);
      OutputString (OutputMemo, 'brPayRef',    MLocCtrl.BnkRDRec.brPayRef,    SizeOf(MLocCtrl.BnkRDRec.brPayRef) - 1);
      OutputString (OutputMemo, 'brLineDate',  MLocCtrl.BnkRDRec.brLineDate,  SizeOf(MLocCtrl.BnkRDRec.brLineDate) - 1);
      OutputString (OutputMemo, 'brMatchRef',  MLocCtrl.BnkRDRec.brMatchRef,  SizeOf(MLocCtrl.BnkRDRec.brMatchRef) - 1);
      OutputDouble (OutputMemo, 'brValue',     MLocCtrl.BnkRDRec.brValue,     2);
      OutputInteger(OutputMemo, 'brLineNo',    MLocCtrl.BnkRDRec.brLineNo);
      OutputString (OutputMemo, 'brStatId',    MLocCtrl.BnkRDRec.brStatId,    SizeOf(MLocCtrl.BnkRDRec.brStatId) - 1);
      OutputInteger(OutputMemo, 'brStatLine',  MLocCtrl.BnkRDRec.brStatLine);
      OutputString (OutputMemo, 'brCustCode',  MLocCtrl.BnkRDRec.brCustCode,    SizeOf(MLocCtrl.BnkRDRec.brCustCode) - 1);

    (*
      {174}   brPeriod     :  Byte;         { Transaction Period }

      {175}   brYear       :  Byte;         { Transaction Year }

      {176}   brCXRate     :  CurrTypes;    { Transaction exchange rate }

      {188}   brLUseORate  :  Byte;         {* Forces the conversion routines to apply non tri rules *}
      {189}   brCurTriR    :  TriCurType;   {* Details of Main Triangulation *}

      {211}   brOldYourRef    :  String[10];   { Old Transaction Your Ref }

      {221}   brTransValue :  Double;       { Transaction value }

      {230}   brCCDep      :  CCDepType;    { Transaction CC/Dep }

      {236}   brNomCode    :  LongInt;      {  Transaction Line G/L Code }

      {240}   brSRINomCode :  LongInt;      {  Transaction Line payment G/L Code on Direct types }

      {244}   brFolioLink  :  LongInt;      {  Transaction Line Folio  link to eventual transaction created from this. 0 = not executed yet}

      {248}   brVATCode    :  Char;         {  Transaction Line VAT Code }

      {249}   brVATAmount  :  Double;       {  Transaction Line VAT Value }

      {258}   brTransDate  :  LongDate;     {  Transaction Date}

      {266}   brIsNewTrans :  Boolean;      {  Flag to indicate a new transaction will be manufactured as a result of this entry }

              brLineStatus :  Byte;

              // MH 03/04/06: Corrected spare from 492 to 493
      {267}   Spare        :  Array[1..493] of Byte;


      {766}
      {767}   brYourRef    :  String[20];   { Transaction Your Ref }
    *)
    end;

  end
  Else
    OutputMemo.Lines.Add ('*** Document - MLocStk Invalid Size - ' + IntToStr(SizeOf(MLocRec)) + ' expected, ' + IntToStr(DataBlockLen) + ' received');
end;

end.
