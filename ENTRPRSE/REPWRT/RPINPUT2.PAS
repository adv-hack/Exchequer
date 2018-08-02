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
end;


Function TMAMList.Ok2Del :  Boolean;
Begin
  Result:=BOn;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }
Function TMAMList.OutLine(Col  :  Byte)  :  Str255;
Begin
  Result := '';

  With RepGenRecs^, ReportDet Do Begin { Input Lines }
    Case Col of
      0  : Result := VarType + RepPadNo;           { Rep Ref }
      1  : Result := RepLDesc;                     { Description }
      2  : Result := RepInpTypesL^[RepLIType];     { Input Type }
      3  : Result := GetDefaultStr(ReportDet);     { Default }
    End; { Case  }
  End; { With }
End;


