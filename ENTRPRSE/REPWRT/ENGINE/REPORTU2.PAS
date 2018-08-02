{ ============== TMAMList Methods =============== }

{ Set key for current record }
Function TMAMList.SetCheckKey : Str255;
Var
  DumStr    :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With MiscRecs^, btLetterRec Do Begin
    Case DisplayMode of
      0  : DumStr := RecMFix + SubType + AccCode;
    end; { Case }
  End; { With }

  SetCheckKey:=DumStr;
end;


{ Set filter for list }
Function TMAMList.SetFilter  :  Str255;
Begin
  Result := '';

  Case DisplayMode of
    0  : { No filter required } ;
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

  With MiscRecs^, btLetterRec Do Begin
    Case Col of
      0  : Result := POutDate(LtrDate);
      1  : Result := LtrDescr;
      2  : Result := UserCode;
      3  : Result := CurrTimeStr(LtrTime);
    End; { Case  }
  End; { With }
end;

