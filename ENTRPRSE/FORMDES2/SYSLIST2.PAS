{ ============== TMAMList Methods =============== }

{ Set key for current record }
Function TMAMList.SetCheckKey : Str255;
Var
  DumStr    :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Syss Do
    DumStr := IDCode;

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

  With Syss Do
    If (IdCode = SysNames[FormR]) Then Begin
      Case Col Of
        0 : Result := '0';
        1 : Result := GlobDef;
      End; { Case }
    End { If }
    Else
      Case Col Of
        0 : Result := IntToStr(Ord(IDCode[3]) - 100);
        1 : Result := FormDefs.Descr;
      End; { Case }
End;


