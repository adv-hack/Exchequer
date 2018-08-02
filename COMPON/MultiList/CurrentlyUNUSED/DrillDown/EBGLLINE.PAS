unit EBGLLine;

interface

Uses
  Classes, Dialogs, Forms, SysUtils, Windows,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Enterprise global const/type/var
  BtrvU2,        // Btrieve Interface Routines & Constants
  Recon3U;       // Extended Btrieve Ops classes for reading data

Type
  TExtBtrCompareMode = (cmpEqual=1,
                        cmpGreaterthan=2,
                        cmpLessThan=3,
                        cmpNotEqual=4,
                        cmpGreaterThanOrEqual=5,
                        cmpLessThanOrEqual=6);

  TExtBtrLogicExpression = (lexLastTerm=0,
                            lexAND=1,
                            lexOR=2);

  TFilter4ConditionsType = Record
    CcyCompareMode     : TExtBtrCompareMode;
    CcyCompareVal      : Byte;

    YearCompareMode    : TExtBtrCompareMode;
    YearCompareVal     : Byte;

    PeriodCompareMode  : TExtBtrCompareMode;
    PeriodCompareVal   : Byte;

    CCCompareMode      : TExtBtrCompareMode;
    CCCompareVal       : String[3];
    CCCompareOffset    : SmallInt;

    DeptCompareMode    : TExtBtrCompareMode;
    DeptCompareVal     : String[3];
  End; { TFilter4ConditionsType }



  TExtBtrieveGLLines = Object(ExtSNObj)
    fBDSearchRec: SearchNPtr;   {!Nick!}

    Constructor  Init;
    Destructor   Done;

    Procedure SetNomFilter (Var   Term    : FilterRepeatType;
                            Var   Compare : LongInt;
                            Const NomCode : LongInt);

    Procedure SetNomModeFilter (Var   Term    : FilterRepeatType;
                                Var   Compare : Char);

    Procedure SetYearFilter (Var   Term     : FilterRepeatType;
                             Var   Compare  : Char;
                             Const Year     : Byte;
                             Const CompCode : TExtBtrCompareMode = cmpEqual;
                             Const LogicEx  : TExtBtrLogicExpression = lexAND);

    Procedure SetPeriodFilter (Var   Term     : FilterRepeatType;
                               Var   Compare  : Char;
                               Const Period   : Byte;
                               Const CompCode : TExtBtrCompareMode = cmpEqual;
                               Const LogicEx  : TExtBtrLogicExpression = lexAND);

    Procedure SetCcyFilter (Var   Term     : FilterRepeatType;
                            Var   Compare  : Char;
                            Const Currency : Byte;
                            Const CompCode : TExtBtrCompareMode = cmpEqual;
                            Const LogicEx  : TExtBtrLogicExpression = lexAND);

    // ExBtr: NomCode + NomMode + Year + Period / Period <= X
    Function GLFilter1 (Const B_Func    : Integer;
                        Const Fnum      : Integer;
                        Const Keypath   : Integer;
                        Var   KeyS      : Str255;
                        Const FNomcode  : LongInt;
                        Const FYear     : Byte;
                        Const FPeriod   : Byte;
                        Const PeriodEq  : Boolean) : Integer;

    // ExBtr: NomCode + NomMode + Ccy + Year + Period / Period <= X
    Function GLFilter2 (Const B_Func    : Integer;
                        Const Fnum      : Integer;
                        Const Keypath   : Integer;
                        Var   KeyS      : Str255;
                        Const FNomcode  : LongInt;
                        Const FCurrency : Byte;
                        Const FYear     : Byte;
                        Const FPeriod   : Byte;
                        Const PeriodEq  : Boolean) : Integer;

    // ExBtr: NomCode + NomMode + [Ccy] + (Year<=X | Year=X)
    Function GLFilter3 (Const B_Func     : Integer;
                        Const Fnum       : Integer;
                        Const Keypath    : Integer;
                        Var   KeyS       : Str255;
                        Const FNomcode   : LongInt;
                        Const FCurrency  : Byte;
                        Const FilterCcy  : Boolean;
                        Const FYear      : Byte;
                        Const YearEquals : Boolean) : Integer;

    Function GLFilter4 (Const B_Func    : Integer;
                        Const Fnum      : Integer;
                        Const Keypath   : Integer;
                        Var   KeyS      : Str255;
                        Const FNomcode  : LongInt;
                        Const FiltConds : TFilter4ConditionsType) : Integer;

     function BDFilter1(const FNomcode: Integer;
                        const FNum: integer;
                        const FYear: byte;
                        FPeriod: byte;
                        const PeriodEq: boolean): pointer;

     function BDFilter4(const FNomCode: LongInt;
                        const FiltConds: TFilter4ConditionsType;
                        var BufferSize: longint): Pointer;

   End; { TExtBtrieveGLLines}


implementation

//=========================================================================

Constructor TExtBtrieveGLLines.Init;
Begin { Init }
  //NomExtSObj.Init;
  ExtSNObj.Init;
  New(fBDSearchRec);   {!Nick!}
End; { Init }

//----------------------------

Destructor TExtBtrieveGLLines.Done;
Begin { Done }

  Dispose(fBDSearchRec);   {!Nick!}
  ExtSNObj.Done;
  //NomExtSObj.Done;
End; { Done }

//-------------------------------------------------------------------------

Procedure TExtBtrieveGLLines.SetNomFilter (Var   Term    : FilterRepeatType;
                                           Var   Compare : LongInt;
                                           Const NomCode : LongInt);
Begin { SetNomFilter }
  // GL Code = xx
  With Term Do Begin
    FieldType   := BInteger;
    FieldLen    := Sizeof(NomCode);  {* Allow for *}
    FieldOffset := GENomCode;
    CompareCode := 1;    // =
    LogicExpres := 1;    // AND

    Move(NomCode, Compare, Sizeof(NomCode));
  End; { With Term }
End; { SetNomFilter }

//-------------------------------------------------------------------------

Procedure TExtBtrieveGLLines.SetNomModeFilter (Var   Term    : FilterRepeatType;
                                               Var   Compare : Char);
Begin { SetNomModeFilter }
  // NomMode = 0
  With Term Do Begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := GEPNm;
    CompareCode := 1;   // =
    LogicExpres := 1;   // AND

    Compare    := #0;  // NomMode always 0
  End; { With Term }
End; { SetNomModeFilter }

//-------------------------------------------------------------------------

Procedure TExtBtrieveGLLines.SetYearFilter (Var   Term     : FilterRepeatType;
                                            Var   Compare  : Char;
                                            Const Year     : Byte;
                                            Const CompCode : TExtBtrCompareMode = cmpEqual;
                                            Const LogicEx  : TExtBtrLogicExpression = lexAND);
Begin { SetYearFilter }
  // Year = XX
  With Term Do Begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := GEPYr;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);

    Compare    := Chr(Year);
  End; { With Term }
End; { SetYearFilter }

//-------------------------------------------------------------------------

Procedure TExtBtrieveGLLines.SetPeriodFilter (Var   Term     : FilterRepeatType;
                                              Var   Compare  : Char;
                                              Const Period   : Byte;
                                              Const CompCode : TExtBtrCompareMode = cmpEqual;
                                              Const LogicEx  : TExtBtrLogicExpression = lexAND);
Begin { SetPeriodFilter }
  // Period = XX
  With Term Do Begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := GEPPr;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);

    Compare    := Chr(Period);
  End; { With Term }
End; { SetPeriodFilter }

//-------------------------------------------------------------------------

Procedure TExtBtrieveGLLines.SetCcyFilter (Var   Term     : FilterRepeatType;
                                           Var   Compare  : Char;
                                           Const Currency : Byte;
                                           Const CompCode : TExtBtrCompareMode = cmpEqual;
                                           Const LogicEx  : TExtBtrLogicExpression = lexAND);
Begin { SetCcyFilter }
  // Ccy = XX
  With Term Do Begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := GEPCr;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);

    Compare    := Chr(Currency);
  End; { With Term }
End; { SetCcyFilter }

//-------------------------------------------------------------------------

{!Nick!}
function TExtBtrieveGLLines.BDFilter1(const FNomcode: Integer; const FNum: integer; const FYear: byte; FPeriod: byte; const PeriodEq: boolean): pointer;
begin
  with fBDSearchRec^.Filter.FilterN1 do
  begin
    FillChar(ExtendHead, SizeOf(ExtendHead), 0);
    with ExtendHead do
    begin
      DescLen:= SizeOf(fBDSearchRec^.Filter.FilterN1);
      ExtConst[1]:= 'E';
      ExtConst[2]:= 'G';
      RejectCount:= 65535;
      NumTerms:= 4;
    end;

    FillChar(ExtendTail, SizeOf(ExtendTail), 0);
    with ExtendTail do
    begin
      NumRecords:= 1;
      NumFields:= 1;
      FieldLen:= FileRecLen[FNum];
      FieldOffset:= 0;
    end;

    SetNomFilter(Term1, Compare1, FNomcode);
    SetNomModeFilter(Term2, Compare2);
    SetYearFilter(Term3, Compare3, FYear);

    if PeriodEq then SetPeriodFilter(Term4, Compare4, FPeriod, cmpEqual, lexLastTerm)
    else SetPeriodFilter(Term4, Compare4, FPeriod, cmpLessThanOrEqual, lexLastTerm);
  end;

  Result:= fBDSearchRec;
end;
{!Nick!}

{!Nick!}
function TExtBtrieveGLLines.BDFilter4(const FNomCode: LongInt; const FiltConds: TFilter4ConditionsType; var BufferSize: longint): Pointer;
begin
  with fBDSearchRec^.Filter.FilterN2CC do
  begin
    FillChar(ExtendHead, SizeOf(ExtendHead), 0);
    with ExtendHead do
    begin
      DescLen:= SizeOf(fBDSearchRec^.Filter.FilterN2CC);
      ExtConst[1]:= 'E';
      ExtConst[2]:= 'G';
      RejectCount:= 65535;
      NumTerms:= 7;
    end;

    FillChar(ExtendTail, SizeOf(ExtendTail), 0);
    with ExtendTail do
    begin
      NumRecords:= 1;
      NumFields:= 1;
      FieldLen:= SizeOf(IDetail);
      FieldOffset:= 0;
    end;

    SetNomFilter(Term1, Compare1, FNomcode);
    SetNomModeFilter(Term2, Compare2);
    SetCcyFilter(Term3, Compare3, FiltConds.CcyCompareVal, FiltConds.CcyCompareMode);
    SetYearFilter(Term4, Compare4, FiltConds.YearCompareVal, FiltConds.YearCompareMode);
    SetPeriodFilter (Term5, Compare5, FiltConds.PeriodCompareVal, FiltConds.PeriodCompareMode);

    with Term6 do
    begin
      FieldType:= BString;
      FieldLen:= SizeOf(Compare6);
      FieldOffset:= FiltConds.CCCompareOffset;
      CompareCode:= Ord(FiltConds.CCCompareMode);
      LogicExpres:= Ord(lexAND);

      FillChar (Compare6, SizeOf(Compare6), 0);
      Move(FiltConds.CCCompareVal[1], Compare6, FieldLen);
    end;

    with Term7 do
    begin
      FieldType:= BString;
      FieldLen:= SizeOf(Compare7);
      FieldOffset:= Succ(GEDep);
      CompareCode:= Ord(FiltConds.DeptCompareMode);
      LogicExpres:= Ord(lexLastTerm);

      FillChar(Compare7, SizeOf(Compare7), 0);
      Move(FiltConds.DeptCompareVal[1], Compare7, FieldLen);
    end;
  end;

  BufferSize:= SizeOf(fBDSearchRec^);
  Result:= fBDSearchRec;
end;
{!Nick!}

// ExBtr: NomCode + NomMode + Year + Period / Period <= X
Function TExtBtrieveGLLines.GLFilter1 (Const B_Func    : Integer;
                                       Const Fnum      : Integer;
                                       Const Keypath   : Integer;
                                       Var   KeyS      : Str255;
                                       Const FNomcode  : LongInt;
                                       Const FYear     : Byte;
                                       Const FPeriod   : Byte;
                                       Const PeriodEq  : Boolean) : Integer;
Begin
  // Build the Extended Btrieve structures
  With SearchRec^.Filter.FilterN1 Do
  Begin
    ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SearchRec^.Filter.FilterN1));

    ExtendHead.NumTerms := 4;

    // GL Code = xx
    SetNomFilter (Term1, Compare1, FNomcode);

    // NomMode = 0
    SetNomModeFilter (Term2, Compare2);

    // Year = XX
    SetYearFilter (Term3, Compare3, FYear);

    // Period = XX / Period <= XX
    If PeriodEq Then
      SetPeriodFilter (Term4, Compare4, FPeriod, cmpEqual, lexLastTerm)
    Else
      SetPeriodFilter (Term4, Compare4, FPeriod, cmpLessThanOrEqual, lexLastTerm);
  End; { With SetSearchRec^.Filter.FilterN1 }

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end; {Func..}

//-------------------------------------------------------------------------

// ExBtr: NomCode + NomMode + Ccy + Year + Period / Period <= X
Function TExtBtrieveGLLines.GLFilter2 (Const B_Func    : Integer;
                                       Const Fnum      : Integer;
                                       Const Keypath   : Integer;
                                       Var   KeyS      : Str255;
                                       Const FNomcode  : LongInt;
                                       Const FCurrency : Byte;
                                       Const FYear     : Byte;
                                       Const FPeriod   : Byte;
                                       Const PeriodEq  : Boolean) : Integer;
Begin
  // Build the Extended Btrieve structures
  With SearchRec^.Filter.FilterN2 Do
  Begin
    ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SearchRec^.Filter.FilterN2));

    ExtendHead.NumTerms := 5;

    // GL Code = xx
    SetNomFilter (Term1, Compare1, FNomcode);

    // NomMode = 0
    SetNomModeFilter (Term2, Compare2);

    // Currency = XX
    SetCcyFilter (Term3, Compare3, FCurrency);

    // Year = XX
    SetYearFilter (Term4, Compare4, FYear);

    // Period = XX / Period <= XX
    If PeriodEq Then
      SetPeriodFilter (Term5, Compare5, FPeriod, cmpEqual, lexLastTerm)
    Else
      SetPeriodFilter (Term5, Compare5, FPeriod, cmpLessThanOrEqual, lexLastTerm);
  End; { With SetSearchRec^.Filter.FilterN1 }

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end; {Func..}

//-------------------------------------------------------------------------

// ExBtr: NomCode + NomMode + [Ccy] + (Year <= X)
Function TExtBtrieveGLLines.GLFilter3 (Const B_Func     : Integer;
                                       Const Fnum       : Integer;
                                       Const Keypath    : Integer;
                                       Var   KeyS       : Str255;
                                       Const FNomcode   : LongInt;
                                       Const FCurrency  : Byte;
                                       Const FilterCcy  : Boolean;
                                       Const FYear      : Byte;
                                       Const YearEquals : Boolean) : Integer;
Begin
  // Build the Extended Btrieve structures
  With SearchRec^.Filter.FilterN1 Do
  Begin
    ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SearchRec^.Filter.FilterN1));

    ExtendHead.NumTerms := 4;

    // GL Code = xx
    SetNomFilter (Term1, Compare1, FNomcode);

    // NomMode = 0
    SetNomModeFilter (Term2, Compare2);

    // Currency = XX / Currency >= X
    If FilterCcy Then
      SetCcyFilter (Term3, Compare3, FCurrency)
    Else
      SetCcyFilter (Term3, Compare3, FCurrency, cmpGreaterThanOrEqual);

    // Year <= XX
    If YearEquals Then
      SetYearFilter (Term4, Compare4, FYear, cmpEqual, lexLastTerm)
    Else
      SetYearFilter (Term4, Compare4, FYear, cmpLessThanOrEqual, lexLastTerm);
  End; { With SetSearchRec^.Filter.FilterN1 }

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end; {Func..}

//-------------------------------------------------------------------------

// ExBtr: NomCode + NomMode + Ccy + Year + Period + CC + Dept
Function TExtBtrieveGLLines.GLFilter4 (Const B_Func    : Integer;
                                       Const Fnum      : Integer;
                                       Const Keypath   : Integer;
                                       Var   KeyS      : Str255;
                                       Const FNomcode  : LongInt;
                                       Const FiltConds : TFilter4ConditionsType) : Integer;
Begin
  // Build the Extended Btrieve structures
  With SearchRec^.Filter.FilterN2CC Do
  Begin
    ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SearchRec^.Filter.FilterN2CC));

    ExtendHead.NumTerms := 7;

    // GL Code = xx
    SetNomFilter (Term1, Compare1, FNomcode);

    // NomMode = 0
    SetNomModeFilter (Term2, Compare2);

    // Currency = XX
    SetCcyFilter (Term3, Compare3, FiltConds.CcyCompareVal, FiltConds.CcyCompareMode);

    // Year = XX
    SetYearFilter (Term4, Compare4, FiltConds.YearCompareVal, FiltConds.YearCompareMode);

    // Period = XX
    SetPeriodFilter (Term5, Compare5, FiltConds.PeriodCompareVal, FiltConds.PeriodCompareMode);

    // CC / Dept
    With Term6 Do Begin
      FieldType   := BString;
      FieldLen    := SizeOf(Compare6);
      FieldOffset := FiltConds.CCCompareOffset;            // Position of CC/Dept Code in Id record structure
      CompareCode := Ord(FiltConds.CCCompareMode);
      LogicExpres := Ord(lexAND);

      FillChar (Compare6, SizeOf(Compare6), #0);
      Move (FiltConds.CCCompareVal[1], Compare6, FieldLen);
    End; { With Term6 }

    // Dept
    With Term7 Do Begin
      FieldType   := BString;
      FieldLen    := SizeOf(Compare7);
      FieldOffset := GEDep + 1;
      CompareCode := Ord(FiltConds.DeptCompareMode);
      LogicExpres := Ord(lexLastTerm);

      FillChar (Compare7, SizeOf(Compare7), #0);
      Move (FiltConds.DeptCompareVal[1], Compare7, FieldLen);
    End; { With Term7 }
  End; { With SetSearchRec^.Filter.FilterN2CC }

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end; {Func..}

//=========================================================================

end.
