Unit CreateCreditNote;

Interface

Uses Forms, SysUtils, StrUtils, Messages, Windows, Enterprise04_TLB, oIni;

Procedure AddCreditNote (Const Toolkit : IToolkit; Const PPDSettings : TPPDSettingIni; Const PPDRate, PPDTotal : Double; Const TransactionDate : String; Const Operator : String);

Implementation

Uses HandlerU, ETMiscU, Dialogs, GlobType;

//=========================================================================

Procedure AddCreditNote (Const Toolkit : IToolkit; Const PPDSettings : TPPDSettingIni; Const PPDRate, PPDTotal : Double; Const TransactionDate : String; Const Operator : String);
Const
  // Copied from FillVATCombo in Funcs\CTKUtilImplementation.inc
  VATCodeList : Array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
Var
  oOriginalInvoice, oUpdateInvoice : ITransaction;
  oCreditNote : ITransaction11;
  oPPDLine : ITransactionLine;
  sMsg : ANSIString;
  sGivenTaken : String;
  sCurrencySymbol : String;
  I, LastVATCode, Res : Integer;
  PPDAllocated, PPDThisVATCode, TotalThisVATCode, GoodsTotal, VATTotal : Double;
  InclusiveVATValue, InclusiveGoodsValue : Double;

  //------------------------------

  Procedure AddInvoiceNote (Const CurrencySymbol : String; Const GoodsTotal, VATTotal : Double);
  Var
    NextNoteLineNo : Integer;
    Res : Integer;
  Begin // AddInvoiceNote
    // Transaction object should already be on the Invoice

    With Toolkit.Transaction.thNotes Do
    Begin
      // Calculate the next note line number - this sucks - why doesn't it do it automatically?
      NextNoteLineNo := 0;

      // Get the number of the last General note line
      ntType := ntTypeGeneral;
      Res := GetLast;
      If (Res = 0) Then
        NextNoteLineNo := ntLineNo;

      // Get the number of the last General note line
      ntType := ntTypeDated;
      Res := GetLast;
      If (Res = 0) And (ntLineNo > NextNoteLineNo) Then
        NextNoteLineNo := ntLineNo;

      With Add Do
      Begin
        ntLineNo := NextNoteLineNo + 1;
        ntDate := FormatDateTime('yyyymmdd', Now);
        ntText := Format ('PPD %s by %s - %0.2f%s / %s%0.2f Goods / %s%0.2f VAT',
                          [sGivenTaken,
                           Trim(oCreditNote.thOurRef),
                           PPDRate,
                           '%',
                           CurrencySymbol,
                           GoodsTotal,
                           CurrencySymbol,
                           VATTotal]);
        ntOperator := Operator;

        Res := Save;
        If (Res <> 0) Then
        Begin
          sMsg := 'Error ' + IntToStr(Res) + ' - ' + Toolkit.LastErrorString + ' - adding the dated note against the Invoice';
          Application.MessageBox (PCHAR(sMsg), sPlugInTitle);
        End; // Else
      End; // With Add
    End; // With Toolkit.Transaction.thNotes
  End; // AddInvoiceNote

  //------------------------------

  Procedure MarkInvoiceAsTaken(Const UDefFieldNo : Integer);
  Var
    oUpdateInvoice : ITransaction2;
    sText : String;
    Res : Integer;
  Begin // MarkInvoiceAsTaken
    // Should be positioned on the Invoice
    oUpdateInvoice := (Toolkit.Transaction As ITransaction2).UpdateEx(umDEfault);
    If Assigned(oUpdateInvoice) Then
    Begin
      Try
        sText := 'PPD ' + sGivenTaken + ' ' + FormatDateTime('dd/mm/yyyy', Now) + ' by ' + Trim(Operator);

        // Typecast to ITransaction9 to access udef 5-10
        With oUpdateInvoice As ITransaction9 Do
        Begin
          Case UDefFieldNo Of
            1  : thUserField1 := sText;
            2  : thUserField2 := sText;
            3  : thUserField3 := sText;
            4  : thUserField4 := sText;
            5  : thUserField5 := sText;
            6  : thUserField6 := sText;
            7  : thUserField7 := sText;
            8  : thUserField8 := sText;
            9  : thUserField9 := sText;
            10 : thUserField10 := sText;
          End; // Case UDefFieldNo
        End; // With oUpdateInvoice As ITransaction9

        Res := oUpdateInvoice.Save(False);
        If (Res <> 0) Then
        Begin
          sMsg := 'Error ' + IntToStr(Res) + ' - ' + Toolkit.LastErrorString + ' - marking the Invoice as ' + sGivenTaken;
          Application.MessageBox (PCHAR(sMsg), sPlugInTitle);
        End; // Else
      Finally
        oUpdateInvoice := NIL;
      End; // Try..Finally
    End // If Assigned(oUpdateInvoice)
    Else
    Begin
      sMsg := 'Warning: Unable to mark ' + Trim(Toolkit.Transaction.thOurRef) + ' as PPD ' +
               sGivenTaken + ', someone else may be editing it';
      Application.MessageBox (PCHAR(sMsg), sPlugInTitle);
    End; // Else
  End; // MarkInvoiceAsTaken

  //------------------------------

  Procedure MatchInvoiceToCreditNote;
  Var
    Res : Integer;
  Begin // MatchInvoiceToCreditNote
    // Should be positioned on the Invoice
    With (Toolkit.Transaction.thMatching As IMatching2) Do
    Begin
      maSearchType := maTypeFinancial;

      With Add Do
      Begin
        maPayRef := oCreditNote.thOurRef;
        maPayCurrency := oCreditNote.thCurrency;
        maPayValue := oCreditNote.thTotals[TransTotInCcy];

        maDocRef := Toolkit.Transaction.thOurRef;
        maDocCurrency := maPayCurrency;
        maDocValue := maPayValue;

        maBaseValue := Toolkit.Functions.entConvertAmount(maDocValue, maDocCurrency, 0, 0);

        Res := Save;
        If (Res <> 0) Then
        Begin
          sMsg := 'Error ' + IntToStr(Res) + ' - ' + Toolkit.LastErrorString + ' - matching the Credit Note to the Invoice';
          Application.MessageBox (PCHAR(sMsg), sPlugInTitle);
        End; // Else
      End; // With Add
    End; // With (Toolkit.Transaction.thMatching As IMatching2)
  End; // MatchInvoiceToCreditNote

  //------------------------------

  Procedure AddCreditNoteNote (Const CurrencySymbol : String; Const GoodsTotal, VATTotal : Double);
  Var
    Res : Integer;
  Begin // AddCreditNoteNote
    With Toolkit.Transaction Do
    Begin
      // Need to find the Credit Note
      Index := thIdxOurRef;
      Res := GetEqual(BuildOurRefIndex(oCreditNote.thOurRef));
      If (Res = 0) Then
      Begin
        // Just added the Credit Note, so the next available line number should be 1
        With thNotes.Add Do
        Begin
          ntLineNo := 1;
          ntDate := FormatDateTime('yyyymmdd', Now);
          ntText := Format ('PPD %s against %s - %0.2f%s / %s%0.2f Goods / %s%0.2f VAT',
                            [sGivenTaken,
                             Trim(oOriginalInvoice.thOurRef),
                             PPDRate,
                             '%',
                             CurrencySymbol,
                             GoodsTotal,
                             CurrencySymbol,
                             VATTotal]);
          ntOperator := Operator;

          Res := Save;
          If (Res <> 0) Then
          Begin
            sMsg := 'Error ' + IntToStr(Res) + ' - ' + Toolkit.LastErrorString + ' - adding the dated note against the Credit Note';
            Application.MessageBox (PCHAR(sMsg), sPlugInTitle);
          End; // Else
        End; // With thNotes.Add
      End // If (Res = 0)
      Else
      Begin
        sMsg := 'Error ' + IntToStr(Res) + ' - ' + Toolkit.LastErrorString + ' - trying to load the Credit Note';
        Application.MessageBox (PCHAR(sMsg), sPlugInTitle);
      End; // Else
    End; // With Toolkit.Transaction
  End; // AddCreditNoteNote

  //------------------------------

  Procedure OpenCreditNoteInExchequer;
  Var
    DrillRec : EntCopyDataRecType;
    CopyData : TCopyDataStruct;
  Begin // OpenCreditNoteInExchequer
    // Setup the Drill-Down structure
    FillChar (DrillRec, SizeOf(DrillRec), #0);
    With DrillRec Do Begin
      DataId      := 1;
      //ddLevelNo   := LevelNo;  // Not Used

      ddKeyString := oCreditNote.thOurRef;
      ddFileNo    := 2;  // InvF
      ddIndexNo   := 2; // InvOurRefK
      //ddMode      := DDB1;  // Not User
    End; { With DrillRec }

    // Setup the CopyData structure
    With CopyData Do Begin
      lpData := @DrillRec;
      cbData := SizeOf(DrillRec);
    End; { With CopyData }

    SendMessage(Application.MainForm.Handle, WM_CopyData, 0, Integer(@CopyData));
  End; // OpenCreditNoteInExchequer

  //------------------------------

Begin // AddCreditNote
  // Toolkit.Transaction contains the originating invoice - SIN or PIN
  oOriginalInvoice := Toolkit.Transaction.Clone;

  // Use transaction type of invoice to determine type of xJC to add
  If (oOriginalInvoice.thDocType = dtSIN) Then
  Begin
    sGivenTaken := 'Given';
    oCreditNote := Toolkit.Transaction.Add(dtSJC) As ITransaction11;
  End // If (oOriginalInvoice.thDocType = dtSIN)
  Else
  Begin
    sGivenTaken := 'Taken';
    oCreditNote := Toolkit.Transaction.Add(dtPJC) As ITransaction11;
  End; // Else

  oCreditNote.thOperator := Operator;
  oCreditNote.thOriginator := oCreditNote.thOperator;

  oCreditNote.thAcCode := oOriginalInvoice.thAcCode;
  oCreditNote.thTransDate := TransactionDate;
  oCreditNote.ImportDefaults;

  oCreditNote.thYourRef := oOriginalInvoice.thOurRef;
  oCreditNote.thDueDate := oCreditNote.thTransDate;
  oCreditNote.thControlGL := oOriginalInvoice.thControlGL;
  oCreditNote.thCurrency := oOriginalInvoice.thCurrency;

  // Remove any default settlement discount
  oCreditNote.thSettleDiscPerc := 0.0;
  oCreditNote.thSettleDiscDays := 0;

  // Pro-rata the payment across the VAT Codes

  // Find the last VAT Code with non-zero Goods/VAT figures - this will then receive the remainder
  // of the PPD Value when pro-rata'ing the PPD across the VAT Codes
  LastVATCode := -1;
  For I := Low(VATCodeList) To High(VATCodeList) Do
  Begin
    // Check to see if there is any Goods or VAT for this VAT Code
    If (oOriginalInvoice.thGoodsAnalysis[VATCodeList[I]] <> 0.0) Or (oOriginalInvoice.thVATAnalysis[VATCodeList[I]] <> 0.0) Then
      LastVATCode := I;
  End; // For I

  If (LastVatCode > -1) Then
  Begin
    // Pro-rata the PPDTotal across the VAT Codes and create the SJC lines
    PPDAllocated := 0.0;
    For I := Low(VATCodeList) To High(VATCodeList) Do
    Begin
      // Check to see if there is any Goods or VAT for this VAT Code
      If (oOriginalInvoice.thGoodsAnalysis[VATCodeList[I]] <> 0.0) Or (oOriginalInvoice.thVATAnalysis[VATCodeList[I]] <> 0.0) Then
      Begin
        // Calculate the amount of PPD being allocated to this VAT Code
        If (I = LastVATCode) Then
          // Last VAT Code with Goods/VAT - Allocate remainder of PPD Value to it
          PPDThisVATCode := Round_Up(PPDTotal - PPDAllocated, 2)
        Else
        Begin
          // Pro-rata the PPD Value to this VAT Code as a proportion of the invoice value
          TotalThisVATCode := Round_Up(oOriginalInvoice.thGoodsAnalysis[VATCodeList[I]] + oOriginalInvoice.thVATAnalysis[VATCodeList[I]], 2);
          PPDThisVATCode := Round_Up((TotalThisVATCode / oOriginalInvoice.thTotals[TransTotInCcy]) * PPDTotal, 2);
        End; // Else

        // MH 02/04/2015 v7.0.13.003 ABSEXCH-16323: Calculate the Goods/VAT proportions of the PPD Value for this VAT Code
        InclusiveVATValue := Round_Up((PPDThisVATCode / (1 + Toolkit.SystemSetup.ssVATRates[VATCodeList[I]].svRate)) * Toolkit.SystemSetup.ssVATRates[VATCodeList[I]].svRate, 2);
        InclusiveGoodsValue := Round_Up(PPDThisVATCode - InclusiveVATValue, 2);

        // Update the running total of PPD allocated to VAT Codes
        PPDAllocated := Round_Up(PPDAllocated + InclusiveVATValue + InclusiveGoodsValue, 2);

        // Add a line into the Credit Note
        oPPDLine := oCreditNote.thLines.Add;
        Try
          oPPDLine.tlDescr := Format ('Prompt Payment Discount: %0.2f%s', [PPDRate, '%']);

          If (oCreditNote.thDocType = dtSJC) Then
            oPPDLine.tlGLCode := Toolkit.SystemSetup.ssGLCtrlCodes[ssGLSettleDiscountGiven]
          Else
            oPPDLine.tlGLCode := Toolkit.SystemSetup.ssGLCtrlCodes[ssGLSettleDiscountTaken];

          // MH 02/04/2015 v7.0.13.003 ABSEXCH-16323: Don't use Inclusive VAT due to a bug in the
          // COM Toolkit / the CalcVAT routine
          oPPDLine.tlNetValue := InclusiveGoodsValue;
          oPPDLine.tlVATCode := VATCodeList[I];
          oPPDLine.tlVATAmount := InclusiveVATValue;

          // MH 02/04/2015 v7.0.13.003 ABSEXCH-16323: Update the Transaction Header totals manually
          // so we can call Save(False) so it doesn't recalculate the VAT
          oCreditNote.thTotalVAT := Round_Up(oCreditNote.thTotalVAT + oPPDLine.tlVATAmount, 2);
          oCreditNote.thVATAnalysis[oPPDLine.tlVATCode] := Round_Up(oCreditNote.thVATAnalysis[oPPDLine.tlVATCode] + oPPDLine.tlVATAmount, 2);
          oCreditNote.thNetValue := Round_Up(oCreditNote.thNetValue + oPPDLine.tlNetValue, 2);

          // Check if Locations are enabled
          If Toolkit.SystemSetup.ssUseLocations Then
            oPPDLine.tlLocation := PPDSettings.LocationCode;

          // Check if CC/Dept are enabled
          If Toolkit.SystemSetup.ssUseCCDept Then
          Begin
            oPPDLine.tlCostCentre := PPDSettings.CostCentre;
            oPPDLine.tlDepartment := PPDSettings.Department;
          End; // If Toolkit.SystemSetup.ssUseCCDept

          oPPDLine.Save;
        Finally
          oPPDLine := NIL;
        End; // Try..Finally

        If (I = LastVATCode) Then
          Break;
      End; // If (oOriginalInvoice.thGoodsAnalysis[VATCodeList[I]] <> 0.0) Or (oOriginalInvoice.thVATAnalysis[VATCodeList[I]] <> 0.0)
    End; // For I

    // MH 02/04/2015 v7.0.13.003 ABSEXCH-16323: Save the Credit Note - Do NOT update the Totals
    // as that would recalculate all the VAT which we explicitely set above
    Res := oCreditNote.Save(False);
    If (Res = 0) Then
    Begin
      // Transaction Object should be positioned on the Invoice at this point

      // Extract the currency symbol for the messages and fixup the '£' bug
      sCurrencySymbol := Toolkit.SystemSetup.ssCurrency[oCreditNote.thCurrency].scPrintSymb;
      If (sCurrencySymbol = #156) Then
        sCurrencySymbol := '£';

      // Add up the Goods/VAT totals
      GoodsTotal := 0.0;
      VATTotal := 0.0;
      For I := Low(VATCodeList) To High(VATCodeList) Do
      Begin
        GoodsTotal := Round_Up(GoodsTotal + oCreditNote.thGoodsAnalysis[VATCodeList[I]], 2);
        VATTotal := Round_Up(VATTotal + oCreditNote.thVATAnalysis[VATCodeList[I]], 2);
      End; // For I

      // Add Note against the original Invoice
      AddInvoiceNote (sCurrencySymbol, GoodsTotal, VATTotal);

      // Update the User Defined Field on the Invoice
      If (PPDSettings.UserDefinedFieldNo > 0) Then
        MarkInvoiceAsTaken(PPDSettings.UserDefinedFieldNo);

      // Match the Credit Note to the Invoice
      MatchInvoiceToCreditNote;

      // Add a Note against the Credit Note
      AddCreditNoteNote (sCurrencySymbol, GoodsTotal, VATTotal);

      // Send a refresh message to the Active Window - assumed to be Customer/Supplier Record
      // on the Ledger Tab - to get the list to refresh
      If Assigned(Screen.ActiveForm) Then
        SendMessage(Screen.ActiveForm.Handle, {WM_CustGetRec} WM_User+$1, 18, 1);

      // Use the Print Preview drill-down to open the new Credit Note in Exchequer
      OpenCreditNoteInExchequer;
    End // If (Res = 0)
    Else
    Begin
      sMsg := 'Error ' + IntToStr(Res) + ' - ' + Toolkit.LastErrorString + ' - adding the Credit Note';
      Application.MessageBox (PCHAR(sMsg), sPlugInTitle);
    End; // Else
  End; // If (LastVatCode > -1)
End; // AddCreditNote

//=========================================================================

End.

