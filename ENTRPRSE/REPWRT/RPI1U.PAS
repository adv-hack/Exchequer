{ Include file for RepDetU.Pas }

{ Set key for current record }
Function TSLMList.SetCheckKey  :  Str255;
Var
  DumStr    :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With RepGenRecs^ Do
    DumStr := FullRepKey_RGK (RecPFix, SubType, ReportHed.ReportKey);

  SetCheckKey:=DumStr;
end;


Function TSLMList.SetFilter  :  Str255;
Begin
  Result := '';
  (*
  If (LNHCtrl.NHCr<>0) then
    Result:=Chr(Id.Currency)+Id.CustCode
  else
    Result:=Id.CustCode;
  *)
end;


Function TSLMList.Ok2Del :  Boolean;
Begin
  Result:=BOff;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }
Function TSLMList.OutLine(Col  :  Byte)  :  Str255;
Const
  Fnum     =  InvF;
  KeyPath2 =  InvFolioK;
Var
  TxCr   :  Integer;
  KeyS   :  Str255;
  StockPos
         :  StockPosType;
  TmpQtyMul,
  TmpQty,
  Rnum   :  Real;
  GenStr :  Str255;
  TCr    :  Byte;
  ExLocal: ^TdExLocal;
Begin
  Result := IntToStr(Col);
end;


{ =================================================================================== }

