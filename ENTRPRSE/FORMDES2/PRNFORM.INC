{************************************************************************}
{* Batch Printing Routines                                              *}
{************************************************************************}
procedure TForm_PrintTest.PrintForm_BeforePrint(Sender: TObject);
begin
  { Set events for table printing }
  GotDataRow     := PrintForm_GotDataRow;
  GetNextDataRow := PrintForm_NextDataRow;
  GetDataColumn  := PrintForm_DataCol;

  TCust^ := Cust;
  TInv^  := Inv;
end;

{ Prints page header controls }
procedure TForm_PrintTest.PrintForm_PrintHeader(Sender: TObject);
begin
  {DebugMsg ('PrintForm_PrintHeader (Hdr): ' + IntToStr(HeaderList.Count));}
  PrintControlList (HeaderList);
  {TheReport.Print (IntToStr(PageNo));}

  { Print Body Header }
  {DebugMsg ('PrintForm_PrintHeader (BHdr): ' + IntToStr(BodyHeadList.Count));}
  PrintControlList (BodyHeadList);
end;

{ Prints the body header, main body and footer }
procedure TForm_PrintTest.PrintForm_Print(Sender: TObject);
begin
  {DebugMsg ('PrintForm_Print (Body): ' + IntToStr(BodyList.Count));}
  { Print Body }
  PrintControlList (BodyList);

  { Print Body Footer }
  {DebugMsg ('PrintForm_Print (BFoot): ' + IntToStr(BodyFootList.Count));}
  PrintControlList (BodyFootList);

  { New Page }
  {TheReport.NewPage;}
end;

{ Prints page footer controls }
procedure TForm_PrintTest.PrintForm_PrintFooter(Sender: TObject);
begin
  {DebugMsg ('PrintForm_PrintFooter: ' + IntToStr(FooterList.Count));}
  PrintControlList (FooterList);
end;

{ Returns true if there are still more rows to print }
function TForm_PrintTest.PrintForm_GotDataRow : Boolean;
begin
  Result := (RowCount <= 9);
end;

{ Returns a string representing the specified column contents }
Function TForm_PrintTest.PrintForm_DataCol (ColNo : Byte) : String;
Var
  ColObj : TFormDefListObjType;
  pStr   : PChar;
begin
  Result := '';

  ColObj := TFormDefListObjType(Columns.Items[ColNo]);
  With ColObj, FormDef Do Begin
    If (Not ValueSet) Then
      If WantPrint (ColObj.FormDef) Then Begin
        Case fdFieldClass Of
          fdcFieldCol   : With GetFieldText (FieldCol.fdShortCode, FieldCol.fdDecs, (FieldCol.fdWidth * DefaultPixPerMM), FieldCol.fdBlankIfZero) Do Begin
                            CurrString := StrResult;
                            CurrValue  := DblResult;
                            TotalValue := TotalValue + DblResult;
                            ValueSet   := True;
                          End; { With }
          fdcFormulaCol : With GetFormulaText (FormulaCol.ffFormula, FormulaCol.ffDecs, (FormulaCol.ffWidth * DefaultPixPerMM), formulaCol.ffBlankIfZero) Do Begin
                            CurrString := StrResult;
                            CurrValue  := DblResult;
                            TotalValue := TotalValue + DblResult;
                            ValueSet   := True;

                            { Check for BarCode conversion }
                            With FormulaCol Do
                              If (ffBarCode <> bcNone) Then
                              Begin
                                pStr := StrAlloc (255);
                                StrPCopy (pStr, CurrString);

                                // MH 18/04/06: Added Code128/Codabar and HIBC support
                                Case ffBarCode Of
                                  bcCode39  : CurrString := BC_OCode39(pStr,FormulaCol.ffBCFlag1,FormulaCol.ffBCFlag2);
                                  bcCode128 : CurrString := BC_Code128(pStr);{,ffBCFlag1,ffBCFlag2,ffBCFlag3);}
                                  bcInter25 : CurrString := BC_OInter25(pStr,FormulaCol.ffBCFlag1);
                                  bcCodabar : CurrString := BC_Codabar(pStr);{,ffBCFlag2,ffBCFlag3,ffBCFlag1);}
                                  bcPostnet : CurrString := BC_PostNet(pStr);
                                  bcUPCA    : CurrString := BC_UPCA(pStr);
                                  bcUPCE    : CurrString := BC_UPCE(pStr);
                                  bcEAN8    : CurrString := BC_EAN8(pStr);
                                  bcEAN13   : CurrString := BC_EAN13(pStr);
                                  bcHIBC    : CurrString := CalcHIBCCheckChar(CurrString);
                                End; { Case }

                                StrDispose (pStr);
                              End; { If }
                          End;
        End; { Case }
      End { If }
      Else Begin
        CurrString := '';
        CurrValue  := 0.0;
        ValueSet   := True;
      End; { Else }

    Result := CurrString;
  End; { With }
end;

{ Gets the next data row }
Procedure TForm_PrintTest.PrintForm_NextDataRow;
Var
  I : Integer;
begin
  { Calculate any columns that haven't already been done (i.e. Hidden }
  If (Columns.Count > 0) And (RowCount > 0) Then
    For I := 0 To (Columns.Count - 1) Do
      With TFormDefListObjType(Columns.Items[I]), FormDef Do
        If (Not ValueSet) Then
          PrintForm_DataCol (I);

  { Move to next row }
  Inc (RowCount);
end;

