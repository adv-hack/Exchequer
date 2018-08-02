{ ============== TMAMList Methods =============== }

{ Set key for current record }
Function TMAMList.SetCheckKey : Str255;
Var
  DumStr    :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With RepGenRecs^ Do
    DumStr := FullRepKey_RGK(RecPFix, SubType, ReportHed.ReportKey);

  SetCheckKey:=DumStr;
end;


{ Set filter for list }
Function TMAMList.SetFilter  :  Str255;
Begin
  Result := '';

  Case DisplayMode of
    1  : { Report Lines - No filter required } ;
    2  : { Nominal Lines - No filter required } ;
    3  : { Input Lines } ;
    4  : { Notes } ;
  end; { Case }
end;


Function TMAMList.Ok2Del :  Boolean;
Begin
  Result:=BOn;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }
Function TMAMList.OutLine(Col  :  Byte)  :  Str255;
Begin
  Result := '';

  Case DisplayMode Of
    RepPage  : With RepGenRecs^, ReportDet Do Begin { Report Lines }
                 Case Col of
                   0  : Result := VarType + RepPadNo;           { Rep Ref }
                   1  : Result := RepLDesc;                     { Description }
                   {2  : Result := Form_Int(MMWidth,0);          { Length }
                   2  : If CDrCr Then Begin
                          With Owner As TReportRec Do 
                            Result := Form_Int((MMWidth * 2) + Round (RpColSpc.Value),0)          { Length }
                        End { If }
                        Else
                          Result := Form_Int(MMWidth,0);          { Length }
                   3  : Result := YesNoBo(PrintVar);            { Print }
                   4  : Result := YesNoBo(SubTot);              { Sub Total }
                   5  : Result := BreakTypL^[Break];                     { Break }
                   6  : Result := SortOrd;                      { Sort }
                   7  : Result := RecSelect;                    { Select }
                   8  : Result := YesNoBo(Summary);             { Summary }
                 End; { Case  }
               End;
    NomPage  : With RepGenRecs^, ReportNom Do Begin { Nominal Lines }
                 Case Col of
                   0  : Result := VarType + RepPadNo;           { Rep Ref }
                   1  : Result := RepLDesc;                     { Description }
                   2  : Result := YesNoBo(PrintVar);            { Print }
                   3  : Result := BreakTypL^[Break];            { Break }
                   4  : Result := VarSubSplit;                  { Calculation }
                 End; { Case  }
               End;
    InpPage  : With RepGenRecs^, ReportDet Do Begin { Input Lines }
                 Case Col of
                   0  : Result := VarType + RepPadNo;           { Rep Ref }
                   1  : Result := RepLDesc;                     { Description }
                   2  : Result := RepInpTypesL^[RepLIType];     { Input Type }
                   3  : Result := GetDefaultStr(ReportDet);     { Default }
                 End; { Case  }
               End;
    NotePage : With RepGenRecs^, RNotesRec Do Begin { Notes }
                 Case Col of
                   0  : Result := NoteLine;                     { General Notes }
                 End; { Case  }
               End;
  End; { Case }
End;


Function GetDefaultStr (RepDet  :  ReportDetailType) : String;
Var
  n              : Byte;
  TmpStr, OutStr : Str80;
Begin
  TmpStr:='';

  OutStr:='';

  For n:=1 to 2 do
    With RepDet do Begin
      If (Trim(TmpStr) <> '') then
        TmpStr := TmpStr + ' - ';

      Case RepLIType of
        1  : Begin { Date }
               OutStr := POutDate (DRange[n]);
             End;
        2  : Begin { Period }
               OutStr := PPR_OutPr(PrRange[n,1], PrRange[n,2]);
             End;
        3  : Begin { Value }
               OutStr := Form_Real (VRange[n], 0, NoDecs);
             End;
        5  : Begin { Currency }
               OutStr := SSymb (CrRange[n]);
             End;
        4,         { ASCII }
        6,         { Document No }
        7,         { Customer Code }
        8,         { Supplier Code }
        9,         { Nominal Code }
        10,        { Stock Code }
        11,        { Cost Centre Code }
        12,        { Department Code }
        13,        { Multi-Loc Code }
        14,        { Serial No }
        15,        { Batch No }
        16,        { Fixed Asset No }
        17,        { Job No }
        18 : Begin { Bin Code }
               OutStr := Trim (ASCStr[n]);
             End;
      End; { Case }

      OutStr:=Strip('B',[#32],OutStr);

      TmpStr:=TmpStr+OutStr;
    End; { With }

  Result := TmpStr;
end; {Func..}
