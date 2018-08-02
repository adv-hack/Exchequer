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

  If (UseSet4End) and (CalcEndKey)  then  {* If A special end key calculation is needed *}
      DumStr:=DumStr+NdxWeight;

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

  With MiscRecs^ Do Begin
    If (btLetterRec.Version = DocWord95) Then
      With btLetterRec Do
        Case Col of
          0  : Result := 'Letter';
          1  : Result := POutDate(LtrDate);
          2  : Result := LtrDescr;
          3  : Result := UserCode;
          4  : Result := CurrTimeStr(LtrTime);
        End { Case  }
    Else
      With btLinkRec Do
        Case Col of
          0  : Result := DocTypeName(Version);
          1  : Result := POutDate(LtrDate);
          2  : Result := LtrDescr;
          3  : Result := UserCode;
          4  : Result := CurrTimeStr(LtrTime);
        End { Case  }
  End; { With }
end;

