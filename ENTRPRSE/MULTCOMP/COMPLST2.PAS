{ ============== TMAMList Methods =============== }

{ Set key for current record }
Function TMAMList.SetCheckKey : Str255;
Var
  DumStr    :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Company^, CompDet Do
    DumStr := FullCompCodeKey(RecPFix, CompCode);

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
Function TMAMList.OutLine(Col : Byte)  :  Str255;
Begin
  Result := '';

  With Company^.CompDet Do Begin
    {ShowMessage (CompCode + ' - ' + CompName);}

    Case Col Of
      0 : Result := CompCode;
      1 : Result := CompName;
      2 : Begin
            If (Not ShowESNOn) Then Begin
              If (CompAnal = 0) Then
                { Analyse Company Path }
                CheckCompanyDir (Company^.CompDet);

              If (CompAnal = 1) Then Begin
                { OK - Display Company Path if not turned of in the MCM Setup }
                If (Not SyssCompany^.CompOpt.OptHidePath) Or LoggedIn^ Or SysLoggedIn^ Then
                  Result := PathToLong(Trim(CompPath));
              End { If (CompAnal = 1)  }
              Else
                Result := GetCompDirError (CompAnal);
            End { If (Not ShowESNOn) }
            Else
              Result := Format ('%d / %d (%d) / %3.3d-%3.3d-%3.3d-%3.3d-%3.3d-%3.3d',
                                [CompId, CompModId, CompModSynch, CompSysESN[1],
                                 CompSysESN[2], CompSysESN[3], CompSysESN[4],
                                 CompSysESN[5], CompSysESN[6]]);
          End;
    End; { Case }
  End; { With }
End;


{ Specifies the row effects }
Function TMAMList.CheckRowEmph :  Byte;
Begin
  With Company^.CompDet Do Begin
    If (CompAnal = 0) Then
      { Analyse Company Path }
      CheckCompanyDir (Company^.CompDet);

    If (CompAnal = 1) Then
      { AOK }
      Result := 0
    Else
      { Error of some sort }
      Result := 1;
  end;
end;




