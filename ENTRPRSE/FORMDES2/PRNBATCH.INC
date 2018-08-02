{************************************************************************}
{* Batch Printing Routines                                              *}
{************************************************************************}

{ Initialise report vars before printing starts }
procedure TForm_PrintTest.Batch_BeforePrint(Sender: TObject);
begin
  JobIdx := 0;
  CurrJob := Nil;

  TotItems := PrintBatchList.Count;

  { Set events for table printing }
  GotDataRow     := Batch_GotDataRow;
  GetNextDataRow := Batch_NextDataRow;
  GetDataColumn  := Batch_DataCol;
  StartDataRow   := Batch_StartDataRow;

  OrigJob := TPrintBatchObjType.Create;
end;

procedure TForm_PrintTest.Batch_AfterPrint(Sender: TObject);
Begin
  { make sure serial number obj gets de-allocated }
  Batch_KillScratchObj;

  OrigJob.Destroy;
End;

procedure TForm_PrintTest.Batch_PrintHeader(Sender: TObject);
begin
  If Assigned (CurrJob) Then
    With ReportFiler1 Do Begin
      { Print Page Header }
      PrintControlList (HeaderList);

      { Print Body Header }
      PrintControlList (BodyHeadList);
    End;{ With }
end;

procedure TForm_PrintTest.Batch_PrintFooter(Sender: TObject);
begin
  If Assigned (CurrJob) Then
    With ReportFiler1 Do Begin
      { Print Page Footer }
      PrintControlList (FooterList);
    End; { With }
end;

Procedure TForm_PrintTest.Batch_KillScratchObj;
Begin
  If (ScratchO <> Nil) Then Begin
    Dispose (ScratchO,Done);
    ScratchO := Nil;
  End; { If }

  If Assigned (ScratchFile) Then
    FreeAndNIL(ScratchFile);
End;

procedure TForm_PrintTest.Batch_Print(Sender: TObject);
Var
  FormName   : String;
  HedRec     : fdHeaderRecType;
  StrRec     : fdFormStringsType;
  ListHandle : TSBSList;
  DoneCont   : Boolean;
  TmpPtr     : Pointer;
  I          : SmallInt;

  Procedure PrintErrorPage (Const PageErr : Integer);
  Var
    PCurr, pForm, pDesc, pMode, pMFN, pMKP, pTFN, pTKP, pStat : Boolean;
  Begin
    With TheReport, CurrJob.PrintBatch Do Begin
      TheReport.MarginLeft := TheReport.LeftWaste + 1;
      TheReport.SetFont ('Courier New', 10);
      TheReport.Bold:= True;
      LineNum := 5;

      pForm := True;
      pDesc := True;
      pMode := True;
      pMFN := True;
      pMKP := True;
      pTFN := True;
      pTKP := True;
      pStat := True;
      PCurr := False;

      Case PageErr Of
        1 : Begin { Cannot open form def }
              PrintLn (#9'Error: Cannot load ' + FormName);
              pForm := False;
              pCurr := True;
            End;

        2 : Begin { Cannot find primary record }
              PrintLn (#9'Error: Cannot load Primary Record');
            End;
      End; { Case }

      LineNum := 7;
      TheReport.Bold:= False;
      If pCurr Then PrintLn (#9'CurrDir:        ' + GetCurrentDir);
      If pForm Then PrintLn (#9'Form:           ' + FormName);
      If pDesc Then PrintLn (#9'Description:    ' + pbDescr);
      If pMode Then PrintLn (#9'DefMode:        ' + IntToStr (pbDefMode));
      If pMFN Then  PrintLn (#9'MainFNum:       ' + IntToStr (pbMainFNum));
      If pMKP Then  PrintLn (#9'MainKPath:      ' + IntToStr (pbMainKPath));
      If pTFN Then  PrintLn (#9'TablFNum:       ' + IntToStr (pbTablFNum));
      If pTKP Then  PrintLn (#9'TablKPath:      ' + IntToStr (pbTablKPath));
      If pStat Then PrintLn (#9'Btrieve Status: ' + IntToStr (Status));

      AbortForm := True;
    End; { With }
  End;

  { Adjusts main file info depending on mode }
  Procedure AdjustMain;
  Begin
    With CurrJob.PrintBatch Do Begin
      { Adjust the main file pointers }
      //Case pbDefMode Of
        (* Going to be done normally now }
        fmProdViaDeliv : If (JobIdx = 0) Then Begin
                           FileNames[ReportF] := Repinfo.SFName;
                           FF_OpenFile2 (ReportF);

                           Batch_KillScratchObj;

                           New(ScratchO,Init(-1));
                           ScratchO.Process := 8;

                           RepInfo.RepPtr := ScratchO;
                         End;
        *)
        (*
        fmLabelRun,
        fmLabelSngl,
        fmProductLabel,
        fmSnglProduct,
        fmProdViaDeliv : Begin
                           { Labels not implemented in this version
                           LabEnd^:=KeyRef;
                           LabFnum:=Fnum;
                           LabKeypath:=KeyPath;
                           LabMode:=Mode;
                           LabIsCust:=(IsACust(Cust.CustSupp) and (Mode In [fmLabelRun,fmLabelSngl]));

                           If (Mode=fmLabelSngl) then  {* Need to initialise as its not comming from Report6U *}
                             For FMode:=1 to MaxLabelAX do
                               New(LabelCust[Fmode]);
                           }
                         end;
        *)
      //End; { Case }

      { Get the main file record }
      Status := Find_Rec (B_GetEq, F[pbMainFnum], pbMainFnum, RecPtr[pbMainFnum]^, pbMainKPath, pbMainKRef);

      { Display error if failed to get record }
      If (Status <> 0) Then PrintErrorPage (2);
    End; { If }
  End;

  { Adjusts Table file info depending on mode }
  Procedure AdjustTable;
  Var
    FNum, KPath : Integer;
    TmpMode     : Byte;
  Begin
    With CurrJob.PrintBatch Do Begin
      TmpMode := pbDefMode;

      { HM 17/02/00: Added origmode to allow Printed status to be set when printing Serial Nos }
      OrigMode := pbDefMode;

      // MH 08/11/06: Rewrote section below as it was extremely confusing

      // Single Picking Lists --------------------------------------
      If (TmpMode = fmPickLstSngl) Then
      Begin
        // HM 02/09/03: Added support for printing Bins on Picking Lists
        If HeaderRec.fhShowBins Then
          // Bins turned on - need to change modes and build a scratch file
          TmpMode := fmPickListBins
        Else If (HeaderRec.fhSerialNo > 0) And (Not HeaderRec.fhExplodeBoMs) Then
          // Serial/Batch Numbers
          TmpMode := fmDocSerialNo
        Else If (HeaderRec.fhDocSortMode > 0) Or ((HeaderRec.fhSerialNo > 0) And HeaderRec.fhExplodeBoMs) Then
        Begin
          // Sorting
          // MH 18/03/09: Extended to allow re-use for Picking Lists
          If (HeaderRec.fhDocSortMode = 0) Then
            HeaderRec.fhDocSortMode := 1; // Stock Code
          TmpMode := fmSortedPickingList;
        End // If (HeaderRec.fhDocSortMode > 0) Or ((HeaderRec.fhSerialNo > 0) And HeaderRec.fhExplodeBoMs)
        Else If HeaderRec.fhExplodeBoMs Then
          // MH 16/03/2009: Added support for showing the Hidden BoM Lines to standard Single Picking List
          sStartSearchKey := pbTablKRef + FullNomKey(-1);
      End // If (TmpMode = fmPickLstSngl)

      // Consolidated Picking Lists --------------------------------
      Else If (TmpMode = fmPickLstCons) Then
      Begin
        // HM 02/09/03: Added support for printing Bins on Picking Lists
        If HeaderRec.fhShowBins Then
          // Bins turned on - need to change modes and build a scratch file
          TmpMode := fmPickListConsBins
        Else If (HeaderRec.fhDocSortMode > 0) Then
          // HM 07/11/06: Added support for sorting a consolidated picking list
          TmpMode := fmSortedConsPickingList;

        // NOTE: Serial/Batch flag is ignored because it doesn't seem to be useful and may
        // not be possible to implement due to the consolidated nature of the detail passed in
      End // If (TmpMode = fmPickLstCons)

      // Serial/Batch/Bins ------------------------------------------
      Else If ((HeaderRec.fhSerialNo > 0) Or HeaderRec.fhShowBins) And (TmpMode <> fmStateAgeMnth) Then
      Begin
        // Serial Numbers turned on
        TmpMode := fmDocSerialNo
      End

      // Sorting ---------------------------------------------------
      Else If (TmpMode = fmAllDocs) And (HeaderRec.fhDocSortMode > 0) Then
      Begin
        // HM 15/02/01: Added support for sorting Transaction Lines
        TmpMode := fmTransSort;
      End; // Else

(****
      // HM 02/09/03: Added support for printing Bins on Picking Lists
      If (TmpMode = fmPickLstSngl) And HeaderRec.fhShowBins Then
        // Bins turned on - need to change modes and build a scratch file
        TmpMode := fmPickListBins
      Else
        If (TmpMode = fmPickLstCons) And HeaderRec.fhShowBins Then
          // Bins turned on - need to change modes and build a scratch file
          TmpMode := fmPickListConsBins
        Else
        Begin
          { Check for serial numbers }
          If ((HeaderRec.fhSerialNo > 0) Or HeaderRec.fhShowBins) And (TmpMode <> fmStateAgeMnth) Then
            TmpMode := fmDocSerialNo;

          // HM 15/02/01: Added support for sorting Transaction Lines
          If (TmpMode = fmAllDocs) And (HeaderRec.fhDocSortMode > 0) Then
            TmpMode := fmTransSort;
        End; // Else****)


      { Adjust the main file pointers }
      Case TmpMode Of
        // MH 08/06/2010 v6.4 ABSEXCH-7916: Modified statements to use ledger index to define order
        fmStatemLay    : Begin
                           // Customer/Supplier record already loaded so swe can use that to build the key
                           pbTablFnum  := InvF;
                           pbTablKPath := InvCustLedgK;  // CustCode + CustSupp + NormFlg + Date + Folio (InvCustLedgK) }
                           pbTablKRef  := FullCustCode (Cust.CustCode) + Cust.CustSupp;
                         End; // fmStatemLay

        fmRemitAdv     : Begin { Shouldn't do this as it should be passed in }
                           RemitDoc    := Inv.OurRef;
                           pbTablFnum  := PWrdF;
                           pbTablKRef  := FullMatchKey(MatchTCode,MatchSCode,RemitDoc);

                           // MH 09/05/07: Modified to handle -ve SRC's matched against SCR's
                           //pbTablKPath := HelpNdxK;
                           pbTablKPath := IfThen((Trim(Inv.RemitNo) <> ''), PWK, HelpNdxK);
                         end;
        fmBatchDoc     : Begin { Shouldn't do this as it should be passed in }
                           pbTablFnum  := InvF;
                           pbTablKRef  := Inv.OurRef;
                           pbTablKPath := InvBatchK;
                         end;
        fmStockAdj     : Begin // Stock Adjustment
                           // Check flag in form to see if we want to print the
                           // hidden Bill Of Materials Lines
                           If (HeaderRec.fhPrintAdjBom > 0) Then Begin
                             // Build scratch file of lines

                             { make sure the scratch file object isn't allocated }
                             Batch_KillScratchObj;

                             New(ScratchO,Init(1008));

                             RepInfo.RepPtr := ScratchO;

                             BuildADJLines (HeaderRec.fhPrintAdjBom, ScratchO);

                             // Change form mode to use scratch file
                             TmpMode := fmADJSort;

                             { Change table details to run from scratch file }
                             pbTablFnum  := ReportF;
                             pbTablKPath := RPK;
                             pbTablKRef  := FullNomKey(1008);
                           End; { If HeaderRec.fhPrintAdjBom }
                         End;
        // HM 16/01/04: Added workaround to Exchequer bug where the single picking list is printed
        // using different indexes from the Sales Daybook and the Picking List Run.  Means the additional
        // description lines appear backwards on the latter.
        fmPickLstSngl  : Begin
                           pbTablKPath := IdFolioK;
                         End;
        fmPickLstCons  : Begin
                           FileNames[ReportF] := Repinfo.SFName;
                           FF_OpenFile2 (ReportF);

                           Batch_KillScratchObj;

                           New(ScratchO,Init(-1));
                           ScratchO.Process := 1;

                           RepInfo.RepPtr := ScratchO;
                         End;
        fmDocSerialNo  : Begin
                           { Build serial number list }
                           TmpMode := pbDefMode;

                           {$IFDEF STK}
                             {$IFDEF SOP}
                               { make sure it isn't allocated }
                               Batch_KillScratchObj;

                               New(ScratchO,Init(7));

                               RepInfo.RepPtr := ScratchO;

                               Def_BuildSNo(HeaderRec.fhSerialNo,TmpMode,FNum,KPath,ScratchO);

                               If (TmpMode = fmDocSerialNo) Then Begin
                                 { Change table details to do serial numbers }
                                 pbTablFnum  := FNum;
                                 pbTablKPath := KPath;
                                 pbTablKRef  := FullNomKey(7) + pbTablKRef;
                               End { If }
                               Else If (TmpMode = fmPickLstSngl) Then
                               Begin
                                 If HeaderRec.fhExplodeBoMs Then
                                   // MH 16/03/2009: Added support for showing the Hidden BoM Lines to standard Single Picking List
                                   sStartSearchKey := pbTablKRef + FullNomKey(-1);
                               End; // If (TmpMode = fmPickLstSngl)
                             {$ENDIF}
                           {$ENDIF}
                         End;
        fmStateAgeMnth : If (JobIdx = 0) And RepInfo.ShowMonthDoc And (Not IsContinuation) Then Begin
                           FileNames[ReportF] := Repinfo.SFName;
                           FF_OpenFile2 (ReportF);

                           Batch_KillScratchObj;

                           New(ScratchO,Init(-1));
                           ScratchO.Process := 7;
                           ScratchO.KeepFile := True;

                           RepInfo.RepPtr := ScratchO;
                         End
                         Else If (Not RepInfo.ShowMonthDoc) Then
                         Begin
                           // MH 08/06/2010 v6.4 ABSEXCH-7916: Modified statements to use ledger index to define order

                           // Customer/Supplier record already loaded so swe can use that to build the key
                           pbTablFnum  := InvF;
                           pbTablKPath := InvCustLedgK;  // CustCode + CustSupp + NormFlg + Date + Folio (InvCustLedgK) }
                           pbTablKRef  := FullCustCode (Cust.CustCode) + Cust.CustSupp;
                         End; // Else

        // HM 15/02/01: Added support for sorting Transaction Lines
        fmSortedPickingList,
        fmTransSort    : Begin
                           // Build scratch file of lines

                           { make sure the scratch file object isn't allocated }
                           Batch_KillScratchObj;

                           New(ScratchO,Init(1009));

                           RepInfo.RepPtr := ScratchO;

                           BuildTransLines (HeaderRec.fhDocSortMode, ScratchO, HeaderRec, (TmpMode = fmSortedPickingList));

                           { Change table details to run from scratch file }
                           pbTablFnum  := ReportF;
                           pbTablKPath := RPK;
                           pbTablKRef  := FullNomKey(1009);
                         End;

        // HM 07/11/06: Added support for sorting a consolidated picking list
        fmSortedConsPickingList : Begin
                                     // Convert the scratch file supplied by Exchequer into a sorted list

                                     { make sure the scratch file object isn't allocated }
                                     Batch_KillScratchObj;

                                     // Open the scratch file supplied from Exchequer - have to manually open
                                     // otherwise a new random name is generated and a new file created
                                     FileNames[ReportF] := Repinfo.SFName;
                                     FF_OpenFile2 (ReportF);
                                     New(ScratchO,Init(-1));
                                     ScratchO.Process := 1;

                                     RepInfo.RepPtr := ScratchO;

                                     // Create a scratch file object for storing the Consolidated Bin records - must
                                     // be created before the temp file is built otherwise the reference counting
                                     // mechanism will delete the data
                                     ScratchFile := TScratchFile.Create(1013);

                                     // Takes the input file for a non-Serial/Batch/Bin Consolidated Picking List and sorts it
                                     // into a user selected order
                                     BuildSortedConsolidatedPickingList (HeaderRec.fhDocSortMode, ScratchO);

                                     { Change table details to run from scratch file }
                                     pbTablFnum  := ScratchFileF;
                                     pbTablKPath := 0;
                                     pbTablKRef  := FullNomKey(1013);
                                  End; // fmSortedConsPickingList

        // HM 02/09/03: Added support for printing Bins on Picking Lists
        // Single Picking List with Bins
        fmPickListBins     : Begin
                               // Build scratch file of lines

                               // HM 04/11/03: Keep the file intact when doing a Picking List Run so that the
                               // running list of bin allocations is kept across Single Picking Lists
                               If CurrJob.PrintBatch.pbRepInfo.crFlags[89] Then
                               Begin
                                 // Picking List Run
                                 If (Not Assigned(ScratchFile)) Then
                                 Begin
                                   // Create scratch file object
                                   ScratchFile := TScratchFile.Create(1010);
                                 End; // If (Not Assigned(ScratchFile))
                               End // If CurrJob.PrintBatch.pbRepInfo.crFlags[89]
                               Else
                               Begin
                                 // Printing SOR as Picking List

                                 { make sure the scratch file object isn't allocated }
                                 Batch_KillScratchObj;

                                 // Create scratch file object
                                 ScratchFile := TScratchFile.Create(1010);
                               End; // Else

                               BuildSinglePickListWithBins(CurrJob.PrintBatch.pbRepInfo.crFlags[90], HeaderRec.fhShowAddDesc, HeaderRec.fhExplodeBoMs);

                               { Change table details to run from scratch file }
                               pbTablFnum  := ScratchFileF;
                               pbTablKPath := IIF (HeaderRec.fhStockOrder, 1, 0);
                               pbTablKRef  := FullNomKey(1010);
                             End;

        // Consolidated Picking List with Bins
        fmPickListConsBins : Begin
                               // Build scratch file of lines

                               { make sure the scratch file object isn't allocated }
                               Batch_KillScratchObj;

                               // Open the scratch file supplied from Exchequer - have to manually open
                               // otherwise a new random name is generated and a new file created
                               FileNames[ReportF] := Repinfo.SFName;
                               FF_OpenFile2 (ReportF);
                               New(ScratchO,Init(-1));
                               ScratchO.Process := 1;

                               // Create a scratch file object for storing the Consolidated Bin records
                               ScratchFile := TScratchFile.Create(1011);

                               BuildConsolPickListWithBins (SCratchO, CurrJob.PrintBatch.pbRepInfo.crFlags[90]);

                               { Change table details to run from scratch file }
                               pbTablFnum  := ScratchFileF;
                               pbTablKPath := IIF (HeaderRec.fhStockOrder, 1, 0);
                               pbTablKRef  := FullNomKey(1011);
                             End;

        // HM 24/02/04: Added Custom Trading History for COM Toolkit
        fmCustomTradingHistory : Begin
                                   FileNames[ReportF] := Repinfo.SFName;
                                   FF_OpenFile2 (ReportF);

                                   Batch_KillScratchObj;

                                   New(ScratchO,Init(-1));
                                   ScratchO.Process := 2001;

                                   RepInfo.RepPtr := ScratchO;
                                 End; // fmCustomTradingHistory
      End; { Case }

      { Keep any mode changes }
      pbDefMode := TmpMode;
    End; { If }
  End;

  { Link Customer to Def including any Remit/ Statement links }
  Procedure LinkCust;
  Const
    Fnum    =  CustF;
    KeyPath =  CustCodeK;
  Var
    Loop              : Boolean;
    TmpKPath, TmpStat : Integer;
    lStatus           : SmallInt;
    TmpRecAddr        : LongInt;
    CKey              : Str255;
    FoundKey          : Str20;
    LoopCount         : Byte;
  Begin
    If (Not (CurrJob.PrintBatch.pbDefMode In [6..9,13,19..21,fmPickListConsBins])) then Begin
      { == Preserve Positioning == }
      TmpKPath:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      Case CurrJob.PrintBatch.pbDefMode of
        1..2,14..16,fmDocSerialNo,fmTransSort,fmPickListBins,fmSortedPickingList,fmSortedConsPickingList
        // MH 23/01/2015 v7.1 ABSEXCH-16062: Customer details not being loaded for VAT Receipts
        , fmOrdPayVATReceipt
              :  CKey:=Inv.CustCode;

        3..5,
        22    :  CKey:=Cust.CustCode;  {* Needed as CKey now (v2.20) includes CustSupp *}


      {$IFDEF PF_On}

        23    :  Begin {* Link to Employee & sub con Rec *}
                   GetJobMisc(Application.MainForm,FullEmpCode(Inv.BatchLink),FoundKey,3,-1);

                   If (Ok) then
                     CKey:=JobMisc^.EmplRec.Supplier;

                 end;

        24    :  Begin
                   GetJob(Application.MainForm,Inv.DJobCode,FoundKey,-1);
                   CKey:=Inv.CustCode;
                 end;

        25    :  CKey:=JobRec^.CustCode;

      {$ENDIF}
      End; { Case }

      (* HM 14/03/03 v5.50: Changed so that TCust contains the original supplier when using the
                            Remit To feature.
      *) // HM 30/04/03: Restored as breaks Statement To
      // HM 26/07/04: Extended to use lStatus instead of status and to set OrigPrnCust for use
      //              on Remittance ADvices
      Loop:=BOn;
      Repeat
        lStatus := Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,CKey);

        If (lStatus = 0) Then
        Begin
          {$If Defined(EDLL)}
            If Loop Then
            Begin
              // Record the original customer the first time around the loop
              OrigPrnCust^ := Cust;
            End; // If Loop
          {$IfEnd}

          If (CurrJob.PrintBatch.pbDefMode In [2..4,22]) and (Loop) and (Cust.RemitCode<>'') then
          Begin
            TCust^:=Cust;

            CKey:=FullCustCode(Cust.RemitCode);
          End; // If (CurrJob.PrintBatch.pbDefMode In [2..4,22]) and (Loop) and (Cust.RemitCode<>'')
        End; // If (lStatus = 0)

        Loop:=Not Loop;
      Until (lStatus <> 0) Or (Loop);

      (* HM 30/04/03: Removed as breaks Statement To
      For LoopCount := 1 To 2 Do Begin
        // Load customer record
        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,CKey);

        If StatusOk Then Begin
          // Copy the original customer record into the copy record for access using the CU data
          // dictionary fields, but only do it the first time around the loop
          If (LoopCount = 1) Then
            TCust^:=Cust;

          If (CurrJob.PrintBatch.pbDefMode In [2..4,22]) and (Cust.RemitCode<>'') then
            // Run around loop again and load the Remit To account
            CKey:=FullCustCode(Cust.RemitCode)
          Else
            Break;
        End { If StatusOk }
        Else
          Break;
      End; { For LoopCount}
      *)

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
    End; { If }
  end; { LinkCust }


  { Adjusts Page Settings for the next form where required }
  Procedure AdjustSettings (Const NextForm : ShortString);
  Var
    FormInfo : FormInfoType;
    TmpStr   : ShortString;
  Begin { AdjustSettings }
    FormInfo := GetFormInfo (NextForm);

    With FormInfo Do Begin
      { Set paper orientation }
      If RpDev.SupportOrientation Then Begin
        SetOrientation (Orient);
      End; { If }

      { Printer Bin }
      If RpDev.SupportBin(BinNo) Then Begin
        TmpStr := RpDev.WalkList (RpDev.Bins, BinNo);
        If (Trim(TmpStr) <> '') Then Begin
          RpDev.SelectBin (TmpStr, True);
        End; { If }
      End; { If }

      (*
      HM 26/10/98: Commented out as cannot change paper size whilst printing, even
                   if you have just changed the bin!
      { Paper Size }
      If RpDev.SupportPaper(PaperNo) Then Begin
        TmpStr := RpDev.WalkList (RpDev.Papers, PaperNo);
        If (Trim(TmpStr) <> '') Then Begin
          RpDev.SelectPaper (TmpStr, True);
        End; { If }
      End; { If }
      *)
    End; { With FormInfo }
  End; { AdjustSettings }


begin
  { Check we have jobs to print }
  If (PrintBatchList.Count > 0) Then Begin
    ListHandle := TSBSList.CreateList('PrnBatch');

    { Lets make sure it starts correctly }
    HedRec.fhContinue := '';

    Try
      With TheReport Do
        Repeat
          { Get current print job from batch }
          If (JobIdx = 0) And (Trim(HedRec.fhContinue) = '') Then Begin
            { Get first Print Job }
            CurrJob := PrintBatchList.Items[JobIdx];

            // HM 11/07/03: Added tracking of whether form is a continuation for the Statements
            Iscontinuation := False;
          End { If }
          Else Begin
            { Print footer for last print job }
            If (Not AbortForm) Then Batch_PrintFooter(Sender);

            { Get rid of controls from section lists }
            EmptyLists;

            If (Trim(HedRec.fhContinue) <> '') Then Begin
              { HM 27/11/97: Have a continuation - restore original details }
              CurrJob.PrintBatch := OrigJob.PrintBatch;

              { reset job info for cont form }
              CurrJob.PrintBatch.pbEFDName := Trim(HedRec.fhContinue);

              { Start new page for next print job }
              AdjustSettings (CurrJob.PrintBatch.pbEFDName);
              NewPage;

              // HM 11/07/03: Added tracking of whether form is a continuation for the Statements
              Iscontinuation := True;
            End { If }
            Else Begin
              { No continuation - Get rid of current job }
              CurrJob := Nil;

              { Start new page for next print job }
              AdjustSettings (TPrintBatchObjType(PrintBatchList.Items[JobIdx]).PrintBatch.pbEFDName);
              NewPage;

              { Get next print job }
              CurrJob := PrintBatchList.Items[JobIdx];

              // HM 11/07/03: Added tracking of whether form is a continuation for the Statements
              Iscontinuation := False;
            End; { Else }
          End; { Else }
          AbortForm := False;
          DoneCont := False;

          { Get form info for currjob }
          If Assigned (CurrJob) Then Begin
            { HM 27/11/97: Take copy of original path info, etc - gets reset for serial no's }
            OrigJob.PrintBatch := CurrJob.PrintBatch;

            FormName := SetDrive + FormsPath + Trim(CurrJob.PrintBatch.pbEFDName) + DefDotExtension;

            EmptyList (ListHandle, True);
            If OpenFormDef (FormName, HedRec, StrRec, ListHandle) Then Begin
              { Have got the form stuff }
              SetHedRec (HedRec);
              SetStrRec (StrRec);
              SetControlList (ListHandle);
              SNDOSMode := False;
              SNoFieldWidth := (HeaderRec.fhSNoWidth - 2) * DefaultPixPerMM;
              SNFieldIncInp := HeaderRec.fhInpSNo;
              SNoShowBins := HeaderRec.fhShowBins;
              SNoShowUseBy := HeaderRec.fhShowUseBy;

              DoFont (HeaderRec.fhFont);
              StringsRec  := @StrRec;
              PageNo := 1;

              { Reset records so we don't pick up dud info from previous forms }
              For I := 1 To TotFiles Do
                { Except for Form Details and System Setup }
                If Not (I In [SysF, FormDetsF]) Then Begin
                  ResetRec (I);
                  ExLocal.AssignFromGlobal(I);
                End; { If }
              TCust^ := Cust;
              TInv^ := Inv;

              (* MH 25/10/2011 v6.9: Should be handled in CustomFields object from v6.9
              // MH 10/07/06: Added bodge for LITE which doesn't support these flags but may have them set to TRUE in the DB
              If EnterpriseLicence.IsLITE Then
              Begin
                SyssVAT.VATRates.HideLType[1] := False;
                SyssVAT.VATRates.HideLType[2] := False;
                SyssVAT.VATRates.HideLType[3] := False;
                SyssVAT.VATRates.HideLType[4] := False;
              End; // If EnterpriseLicence.IsLITE
              *)

              { copy report info into global var - remember pointer for aged statements }
              TmpPtr := Nil;
              If (JobIdx > 0) And (CurrJob.PrintBatch.pbDefMode = fmStateAgeMnth) Then TmpPtr := RepInfo.RepPtr;
              RepInfo := CurrJob.PrintBatch.pbRepInfo;
              If Assigned (TmpPtr) Then RepInfo.RepPtr := TmpPtr;

              { Reset any running totals }
              DicNewForm;

              { Adjust Main File by Mode and then get it }
              AdjustMain;

              If (Not AbortForm) Then Begin
                OrigMode := -1;
                sStartSearchKey := '';
                If (CurrJob.PrintBatch.pbTablKPath <> -1) Then AdjustTable;
                DrivingFile := CurrJob.PrintBatch.pbTablFNum;
                FormPurpose := CurrJob.PrintBatch.pbDefMode;

                { Take local copy of global recs }
                TInv^ := Inv;
                LinkCust;
                // HM 14/03/03 v5.50: Removed as was overwriting the original supplier when Remit To is used
                // HM 30/04/03: Restored as breaks Statement To
                TCust^ := Cust;

                With PrintJobInfo^ Do
                begin
                  If (feEmailFName = Chr(255)) Then
                  Begin
                    // PS 15/09/2016 : ABSEXCH-2581 : Removed line which makes addtachment file name to 8.3 char feEmailFName := Copy(Inv.OurRef, 1, 3) + Copy(Inv.OurRef, 5, 5)
                    feEmailFName := Inv.OurRef;
                  End; { If (PrintJobInfo^.feEmailFName = Chr(255)) }
                end;

                { Restart the report }
                RowCount := 0;
                sLastSearchKey := '';
                If (CurrJob.PrintBatch.pbTablKPath <> -1) Then Begin
                  { Get first table row }
                  Batch_NextDataRow;

                  If RowError Then Begin
                    { No rows to print for this form - that really screws up the dictionary links }
                    Case DrivingFile Of
                      IDetailF : Begin
                                   { Set the IDetail record so it doesn't try to load dud records }
                                   Id.FolioRef := 0;
                                 End;
                    End; { Case }
                  End; { If }
                End; { If }
              End; { If }
            End { If }
            Else
              { Cannot open form def }
              PrintErrorPage (1);
          End; { If }

          If (Not AbortForm) Then Begin
            { Print header for print job }
            Batch_PrintHeader(Sender);

            { Print Body calling NewPage as necesary }
            PrintControlList (BodyList);

            { Print Body Footer }
            PrintControlList (BodyFootList);
          End; { If }

          { Update job index for next Print Job, if no continuation }
          If (Trim(HedRec.fhContinue) = '') Then Begin
            Inc(JobIdx);

            // HM 04/11/04: Added 'Set Printed Status' flag so that Authoris-e can stop
            // FDes from setting the Printed Status on transactions, default to setting it
            If bSetPrintedStatus And
              ((CurrJob.PrintBatch.pbDefMode = fmAllDocs) Or
               (CurrJob.PrintBatch.pbDefMode = fmPickLstCons) Or
               (CurrJob.PrintBatch.pbDefMode = fmPickLstSngl) Or
               (CurrJob.PrintBatch.pbDefMode = fmTimeSheet) Or
               (CurrJob.PrintBatch.pbDefMode = fmTransSort) Or
               // MH 07/11/06: Added Sorting to picking lists
               (CurrJob.PrintBatch.pbDefMode = fmSortedPickingList) Or
               (CurrJob.PrintBatch.pbDefMode = fmSortedConsPickingList) Or
               // HM 26/07/04@ Added Remittance Advices
               (CurrJob.PrintBatch.pbDefMode = fmRemitAdv) Or
               // HM 03/09/03: Added Picking List with Bins support
               (CurrJob.PrintBatch.pbDefMode = fmPickListBins) Or
               (CurrJob.PrintBatch.pbDefMode = fmPickListConsBins) Or
               { HM 17/02/00: Added for Doc with Serial No }
               ((CurrJob.PrintBatch.pbDefMode = fmDocSerialNo) And
                ((OrigMode = fmAllDocs) Or (OrigMode = fmPickLstCons) Or
                 (OrigMode = fmPickLstSngl) Or (OrigMode = fmTimeSheet)))) Or
               // MH 16/09/2014: Added support for printing Order Payment VAT Receipts
               (CurrJob.PrintBatch.pbDefMode = fmOrdPayVATReceipt) Then
            Begin
              { Mark document as Printed }
              SetPrintedStatus;
            End; { If }
          End; { If }

          { Update Progress }
          SendProgress (JobIdx, 1);
        Until AbortBatch Or (JobIdx > (PrintBatchList.Count - 1));
    Finally
      EmptyList (ListHandle, True);
      ListHandle.Free;
    End;
  End; { If }
end;

{ Returns the key for the driving file defined by the mode }
function TForm_PrintTest.Batch_GetModeKey : Str255;
Var
  DumStr  :  Str255;
Begin
  DumStr:='';

  If Assigned (CurrJob) Then Begin
    Case CurrJob.PrintBatch.pbDefMode of
(* Note: The Following modes are not processed
  fmLabelRun     = 9;  { Labels (Run) }
  fmLabelSngl    = 10; { Label (Single) }
  fmConsignNote  = 15; { Consignment Note }
  fmDelivLabel   = 16; { Delivery Label }
  fmProductLabel = 19; { Product Labels }
  fmSnglProduct  = 20; { Single Product Label }
  fmProdViaDeliv = 21; { Product Labels via Delivery Run }
*)
      fmAllDocs,
      fmNomTxfr,
      fmStockAdj,
      fmTimeSheet : With Id do
                      DumStr:=FullIdKey(FolioRef,LineNo);
      fmRemitAdv  : With Password.MatchPayRec do
                      If (CurrJob.PrintBatch.pbTablKPath = HelpNdxK) Then
                        DumStr:=FullMatchKey(MatchTCode,MatchSCode,PayRef)
                      Else
                        DumStr:=FullMatchKey(MatchTCode,MatchSCode,DocCode);
      fmStatemLay,
      fmDebtChaseL,
      fmTradeHist{,
      fmStateAgeMnth} : With Inv do
                         DumStr:=FullCustType(CustCode,CustSupp);

      fmStateAgeMnth : If (RepInfo.ShowMonthDoc) Then
                         With RepScr^ do
                             DumStr:=AccessK
                       Else
                         With Inv Do
                           DumStr:=FullCustType(CustCode,CustSupp);

      fmBatchDoc     : With Inv do
                         DumStr:=BatchLink;
      fmAccDets,
      fmStockNote,
      fmTransNotes,
      fmJCRec        : With Password do
                         With NotesRec do
                           DumStr:=RecPFix + SubType + NoteNo;

      {$IFDEF STK}
        {$IFDEF PF_On}
          fmStockRec    : With Password do
                            With BillMatRec do
                              DumStr:=Strip('R',[#32],FullMatchKey(RecPFix,SubType,StockLink));
          fmADJSort,
          fmPickLstCons,
          fmTransSort,
          fmCustomTradingHistory,   // HM 24/02/04: Added Custom Trading History for COM Toolkit
          fmSortedPickingList,      // MH 07/11/06: Added Sorting to basic picking lists
          fmDocSerialNo  : With RepScr^ do Begin
                             DumStr:=AccessK;
                           end;

          fmPickListBins,
          fmSortedConsPickingList,
          fmPickListConsBins : With ScratchFileRec^ Do
                                 If (CurrJob.PrintBatch.pbTablKPath = 0) Then
                                   DumStr := FullNomKey(scProcessId) + scSortKey1
                                 Else
                                   DumStr := FullNomKey(scProcessId) + scSortKey2;

          fmPickLstSngl  : With Id do
                             DumStr:=FullIdKey(FolioRef,ABSLineNo);
        {$ENDIF}
      {$ENDIF}

      {$IFDEF PF_On}
        fmJCBackingSh  : With JobDetl^,JobActual do
                           DumStr:=PartCCKey(RecPFix,SubType)+JobCode+Chr(Ord(Posted));
      {$ENDIF}

      fmCISVoucher     : With Password, MatchPayRec Do
                           DumStr := RecPFix + SubType + PayRef;
    end; {Case..}
  End; { If }

  Result := DumStr;
End;

{ Filter to see if line should be included }
Function TForm_PrintTest.Include(Mode  :  Byte; Msgs : Boolean)  :  Boolean;
Const
  Fnum     = InvF;
  KeyPath2 = InvOurRefK;
Var
  TBO               : Boolean;
  KeyS              : Str255;
  FoundCode         : Str20;
  OldStat           : Integer;
  RepSCRO           : ScratchPtr;


  Procedure Show_SNoId(Var IdR  :  IDetail;
                           SNOD :  Str80);
  Var
    TmpId  :  Idetail;
  Begin
    With IdR do Begin
      TmpId:=IdR;

      ResetRec(IdetailF);

      StockCode:=TmpId.StockCode;

      Desc:=StringsRec.fsSVStrs[4]+SNoD;
    end;
  end;

Begin
  TBO:=BOff;
  KeyS:='';

  { Status preserved here, as otherwise direct docs do    }
  { not abort properly since a stk/other Bt function will }
  { reset Status                                          }
  OldStat:=Status;

  RepScrO:=RepInfo.RepPtr; {RepScrLink;}

  {$IFDEF STK}
    {$IFDEF SOP}
      If (Mode=fmDocSerialNo) then Begin
        { Get Id Link unless Serial only line }
        If (RepScrO<>NIL) and (RepScr^.RecAddr<>0) then
          RepScrO^.Get_Scratch(RepScr^)
        else
          Show_SNoId(Id,RepScr^.KeyStr);
      End; { If }
    {$ENDIF}

    // HM 24/02/04: Added Custom Trading History for COM Toolkit
    If (Mode = fmCustomTradingHistory) Then
    Begin
      // Get Transaction
      If Assigned (RepScrO) and (RepScr^.RecAddr <> 0) then
        RepScrO^.Get_Scratch (RepScr^);
    End; // If (Mode = fmCustomTradingHistory)

    // HM 07/02/01: Added support for printing hidden ADJ lines
    // HM 15/02/01: Added support for sorting Transaction Lines
    // MH 07/11/06: Added Sorting to basic picking lists
    If (Mode = fmADJSort) Or (Mode = fmTransSort) Or (Mode = fmSortedPickingList) then
    Begin
      { Get Id Line }
      If Assigned (RepScrO) Then
      Begin
        If (RepScr^.RecAddr <> 0) then
          RepScrO^.Get_Scratch (RepScr^)
        Else
        Begin
          {Id.Desc := RepScr^.KeyStr;}  // Copies sort key into line desc for debugging
          ResetRec(IdetailF);
          Id.Desc:=RepScr^.KeyStr;
        End; // Else
      End;
    End; { If }

    // MH 08/11/06: Added sorting into Consolidated Picking Lists
    If (Mode = fmSortedConsPickingList) Then
    Begin
      // Extract the Bin/Stock/Id info from the scratch file
      If Assigned (ScratchFile) Then
      Begin
        // Link to Bin
        If (ScratchFile.sfSavePositions[1].LinkToRecordPosition(True) <> 0) Then
        Begin
          // Either error or position not saved in first place
          ResetRec (IDetailF);
        End; // If (ScratchFile.sfSavePositions[1].LinkToRecordPosition(True) <> 0)
      End; // If Assigned (ScratchFile)
    End; // If (Mode = fmSortedConsPickingList)

    // HM 03/09/03: Added support for Picking List with Bins
    If (Mode = fmPickListBins) Or (Mode = fmPickListConsBins) Then
    Begin
      // Extract the Bin/Stock/Id info from the scratch file
      If Assigned (ScratchFile) Then
      Begin
        // Setup a fake Transaction Line
        ResetRec(IdetailF);
        With Id Do
        Begin
          // HM 15/01/04: Extended to support Additional Description Lines
          Desc := ScratchFile.sfLongString;

          // Check to see if it is an additional description line
          If (ScratchFile.sfIntegers[2] = 0) Then
          Begin
            StockCode := ScratchFile.sfStrings[1];
            Qty       := ScratchFile.sfDoubles[2];
            QtyMul    := 1;
            QtyPick   := ScratchFile.sfDoubles[1];
            MLocStk   := ScratchFile.sfStrings[4];
          End; // If (sfIntegers[2] > 0)

          // MH 02/04/2009: Extended to set KitLink so that the TLBOMSTK field works
          KitLink   := ScratchFile.sfIntegers[3];
        End; // With Id

        // Link to Bin
        If (ScratchFile.sfSavePositions[1].LinkToRecordPosition(True) <> 0) Then
        Begin
          // Either error or position not saved in first place (i.e. Non-Bin Stock Item)
          ResetRec (MLocF);
          With MLocCtrl^, brBinRec Do
          Begin
            RecPfix := BRRecCode;
            SubType := MSernSub;

            brBinCode1 := ScratchFile.sfStrings[2];
          End; // With MLocCtrl^, brBinRec
        End; // If (ScratchFile.sfSavePositions[1].LinkToRecordPosition(True) <> 0)

        // Link to Stock
        If (ScratchFile.sfSavePositions[2].LinkToRecordPosition(True) <> 0) Then
        Begin
          // Error retrieving Stock Record - fake it
          ResetRec (StockF);
          Stock.StockCode := ScratchFile.sfStrings[1];
        End; // If (sfSavePositions[2].LinkToRecordPosition(True) <> 0)
      End; // If Assigned (ScratchFile)
    End; // If (Mode = fmPickListBins) Or (Mode = fmPickListConsBins)

    With RepInfo do
      If (Mode=fmStateAgeMnth) And (ShowMonthDoc) Then Begin
        If (RepScrO<>NIL) And (RepScr^.RecAddr<>0) Then
          RepScrO^.Get_Scratch(RepScr^);
      End; { If }

    { Establish link to stock record }
    // MH 07/11/06: Added Sorting to basic picking lists
    If (Mode In [fmAllDocs, fmNomTxfr, fmStockAdj, fmPickLstCons,
                 fmPickLstSngl, fmDocSerialNo, fmTimeSheet, fmADJSort, fmTransSort,
                 fmSortedPickingList, fmSortedConsPickingList, fmPickListBins, fmPickListConsBins]) Then
      With Id do Begin
        If Is_FullStkCode(StockCode) And
           (StockCode<>Stock.StockCode) And
           (Mode<>fmTimeSheet) Then
          GetStock(Application.MainForm, StockCode, FoundCode, -1);

        { Blank Last Stock Rec }
        If (Not Is_FullStkCode(StockCode)) then
          ResetRec(StockF);

        {$IFDEF PF_On}
          If (JBCostOn) then Begin
            If (Not EmptyKey(JobCode,JobKeyLen)) Then
              GetJob(Application.MainForm, JobCode,FoundCode,-1);

            If (Not EmptyKey(AnalCode,AnalKeyLen)) Then
              GetJobMisc(Application.MainForm, AnalCode,FoundCode,2,-1);

//            {$IFDEF JC}
//              If (Mode=fmTimeSheet) then {* Get Payrate *}
//                GetEmpRate(Application.MainForm, StockCode,FoundCode,-1);
//            {$ENDIF}
          End;
        {$ENDIF}
      End; { With }
  {$ENDIF}

  {$IFDEF PF_On}
    If (Mode = fmJCBackingSh) then
      With JobDetl^.JobActual Do Begin
        If (CheckRecExsists(LineORef,InvF,InvOurRefK)) Then Begin
          If (CheckRecExsists(FullIdKey(LineFolio,LineNo),IdetailF,IdLinkK)) Then Begin
            {$IFDEF STK}
              If (Is_FullStkCode(StockCode)) then
                GetStock(Application.MainForm, StockCode,FoundCode,-1);
            {$ENDIF}

            GetJobMisc(Application.MainForm, AnalCode,FoundCode,2,-1);
          End; { If }
        End; { If }
      End; { With }
  {$ENDIF}

  Case Mode of
    fmAllDocs,
    fmTimeSheet : TBO:=(Id.LineNo<>RecieptCode) And
                  // MH 25/10/2011 v6.9: Added Custom Fields info object
                  //((Not (Id.DocLTLink In [1..4])) Or ((Id.DocLTLink In [1..4]) And (Not SyssVAT.VATRates.HideLType[Id.DocLTLink])));
                  ((Not (Id.DocLTLink In [1..4])) Or ((Id.DocLTLink In [1..4]) And CustomFields[cfLinetypes,Id.DocLTLink].cfEnabled));




    fmRemitAdv  : With Password.MatchPayRec Do Begin
                    TBO := (IfThen(CurrJob.PrintBatch.pbTablKPath = HelpNdxK,PayRef,DocCode)=RemitDoc);

                    {* Link up to Invoice Record *}
                    If TBO then Begin
                      KeyS:=IfThen(CurrJob.PrintBatch.pbTablKPath = HelpNdxK,DocCode,PayRef);

                      ResetRec(Fnum);

                      If (KeyS<>'') then
                        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);
                    End; { If }
                  End; { With }

    { Debt Chase letters split out. HM: 29/01/97 }
    fmDebtChaseL: Begin
                    { Check there is an outstanding amount for this invoice }
                    TBO:=(CurrencyOS(Inv,BOn,BOff,BOff)>0);

                    If TBO Then
                    Begin
                      { Check its the correct type, and its not an automatically generated invoice }
                      TBO := (Not (Inv.InvDocHed In QuotesSet+PSOPSet)) and Inv.NomAuto;

                      If (TBO) then
                        Case Syss.DebtLMode of
                          0,1  :  TBo:=((TrigEquiv(CalcWksODue(Inv.DueDate))=TrigEquiv(Cust.CreditStatus)) or (Syss.IncNotDue));
                          2,3  :  TBo:=((Inv.LastLetter<TrigEquiv(CalcWksODue(Inv.DueDate))) and (Succ(Inv.LastLetter)=RepInfo.DebtLetter));
                          4,5  :  TBo:=(TrigEquiv(CalcWksODue(Inv.DueDate))=RepInfo.DebtLetter);
                        end; {Case..}
                    End; { If }

                      {$IFDEF X32}
                        { Skip date checks if including anything thats due }
                        If (Not ((Syss.DebtLMode In [0, 1]) And Syss.IncNotDue)) Then Begin
                          { get range limits for letter }
                          If (RepInfo.DebtLetter = 1) Then Begin
                            RngS := Syss.WksODue;
                            RngE := Syss.DebTrig[1];
                          End { If }
                          Else Begin
                            RngS := Syss.DebTrig[Pred(RepInfo.DebtLetter)];
                            RngE := Syss.DebTrig[RepInfo.DebtLetter];
                          End; { Else }

                          { Check the invoice is within the range }
                          {Units := CalcDaysWksODue(Inv.DueDate);}
                          Units := CalcWksODue(Inv.DueDate);
                          TBO := (Units >= RngS) And (Units < RngE);

                          { Check it hasn't already been printed, if applicable }
                          If TBO And (Syss.DebtLMode In [2, 3]) Then
                            TBO := (Inv.LastLetter < RepInfo.DebtLetter);
                        End; { If }
                       sdfsdf
                    {$ENDIF}
                  End;

    fmStateAgeMnth,
    fmStatemLay : Begin
                    {$IFDEF MC_On}
                      TBO:=(CurrencyOS(Inv,BOn,BOff,BOff)<>0);
                    {$ELSE}
                      TBO:=(BaseTotalOS(Inv)<>0);
                    {$ENDIF}

                    With RepInfo do
                      If (Mode = fmStateAgeMnth) Then Begin
                        TBO:=(((TBO) or (ShowMonthDoc)) and ((Inv.Currency=ThisCr) or (Not SepCr)));

                        {$IFNDEF JC}
                          TBO:=(TBO and ((Get_StaChkDate(Inv)<=StaAgedDate) or (Syss.IncNotDue)));
                        {$ENDIF}
                      End; { If }

                    TBO:=(TBO and (Not(Inv.InvDocHed In QuotesSet+PSOPSet)) and (Inv.NomAuto));

                    {$IFNDEF JC}
                      If (Mode In [fmStatemLay,fmDebtChaseL]) and (Not Syss.IncNotDue) then
                        TBO:=(TBO and (Get_StaChkDate(Inv)<=Today));
                    {$ENDIF}

                    { On Debt chase letters, only include those relevent to the letter }
                    {If (TBo) and (Mode=fmDebtChaseL) and (Not Syss.IncNotDue) then
                      TBo:=(CalcWksODue(Inv.DueDate)>=Cust.CreditStatus);}
                  end;

    fmTradeHist : TBO:=((Inv.NomAuto) and (Not (Inv.InvDocHed In PSOPSet)));

    // MH 04/11/2011 v6.9: Modified to exclude Audit Notes from Trader Account Details form
    fmTransNotes,    // HM 19/11/02: Added support for printing TH + Notes
    fmStockNote,
    fmJCRec,
    fmAccDets   : TBO := (Password.NotesRec.NType In ['1', '2']);  // '1' = General, '2' = Dated, '3' = Audit

    fmBatchDoc,
    fmNomTxfr,
    fmLabelRun,
    fmLabelSngl,
    fmStockRec,
    fmStockAdj,
    fmADJSort,       // HM 07/02/01: Added support for printing hidden ADJ lines
    fmTransSort,     // HM 15/02/01: Added support for sorting Transaction Lines
    fmPickListBins,     // HM 03/09/03: Added support for Picking List with Bins
    fmPickListConsBins, // HM 04/09/03: Added support for Constolidated Picking List with Bins
    fmPickLstCons,
    fmCustomTradingHistory,   // HM 24/02/04: Added Custom Trading History for COM Toolkit
    fmDocSerialNo,
    fmCISVoucher,
    fmSortedPickingList,     // MH 07/11/06: Added Sorting to basic picking lists
    fmSortedConsPickingList  // MH 08/11/06: Added Sorting to Consolidated picking lists
                   : TBo:=BOn;

  {$IFDEF STK}
    (*** HM 14/01/04: Rewrote to optionally include additional description lines within the picking list
    fmPickLstSngl  : With Id do  {* Matching picking Run, and Product type, ignore blank or desc only lines *}
                       TBo:=((SOPLineNo=Inv.PickRunNo) And
                            (Stock.StockType In StkProdSet + [StkDescCode]) And
                            ((Is_FullStkCode(StockCode)) or
                            ((Mode=fmPickLstSngl) and (KitLink=0)))) And
                            // HM 04/09/02: Modified to hide Free Issue Stock on Works Orders
                            ((IdDocHed <> WOR) Or (Not SSDUseLine));
    ***)

    fmPickLstSngl  : TBo := FilterSinglePickingListLine (HeaderRec.fhInclNewLines, HeaderRec.fhShowDescOnly, HeaderRec.fhShowAddDesc, HeaderRec.fhExplodeBoMs);

    (***** MH 07/11/06: Moved out to a separate function in PickListUtil.Pas
    fmPickLstSngl  : With Id Do
                     Begin
                       // MH 04/09/06: Rewrote as the code was garbage - botches on top of bodges

                       // Check the line is for the correct Picking List Run or is a new line (if that option is enabled)
                       TBo := (SOPLineNo=Inv.PickRunNo) Or (HeaderRec.fhInclNewLines And (Id.SOPLineNo=0));

                       If TBo Then
                       Begin
                         // Hide Free Issue Stock on Works Orders
                         TBo := (IdDocHed <> WOR) Or (Not SSDUseLine);
                       End; //  If TBo

                       If TBo Then
                       Begin
                         // Print it if there is a valid stock code
                         TBo := Is_FullStkCode(StockCode);

                         // For non-stock line check whether to include description type stock
                         If (Not TBO) And HeaderRec.fhShowDescOnly Then
                         Begin
                           TBo := (KitLink = 0);
                         End; // If (Not TBO) And HeaderRec.fhShowDescOnly

                         // Check whether Additional Description Lines should be shown
                         If (Not TBO) And HeaderRec.fhShowAddDesc Then
                         Begin
                           If (Not HeaderRec.fhShowDescOnly) Then
                             TBo := (KitLink <> 0) And (KitLink <> Id.FolioRef)
                           Else
                             TBo := (KitLink <> 0);
                         End; // If (Not TBO) And HeaderRec.fhShowAddDesc
                       End; //  If TBo
                     End; // With Id
    *****)
(**** Pre 04/09/06 version
                       // Check to see whether additional description lines should be included or not
                       If HeaderRec.fhShowAddDesc Then
                       Begin
                                // Check the line is for the correct Picking List Run
                                // MH 04/09/06: Modified to include new lines if flag turned on
                         TBo := ((SOPLineNo=Inv.PickRunNo) Or (HeaderRec.fhInclNewLines And (Id.SOPLineNo=0)))
                                And
                                (
                                  // Check the Stock Code is set
                                  (Is_FullStkCode(StockCode))
                                  Or
                                  // Check the the KitLink is non-zero indicating an additional description line
                                  (KitLink <> 0)
                                )
                                And
                                // Hide Free Issue Stock on Works Orders
                                (
                                  (IdDocHed <> WOR)
                                  Or
                                  (Not SSDUseLine)
                                );
                       End // If HeaderRec.fhShowAddDesc
                       Else
                       Begin
                         // Use the old way - Matching picking Run, and Product type, ignore blank or desc only lines *}
                         // MH 04/09/06: Modified to include new lines if flag turned on
                         TBo:= (
                                 (
                                   // Check Delivery Run No is latest for transaction or not-set
                                   (SOPLineNo=Inv.PickRunNo) Or (HeaderRec.fhInclNewLines And (Id.SOPLineNo=0))
                                 )
                                 And
                                 // Include stock types of Product, Bill of Materials, Discontinued, Description Only
                                 (Stock.StockType In StkProdSet + [StkDescCode])
                                 And
                                 (
                                   // Stock Code must be set or
                                   Is_FullStkCode(StockCode)
                                   Or
                                   (
                                     (Mode=fmPickLstSngl) and (KitLink=0)
                                   )
                                 )
                               )
                               // HM 04/09/02: Modified to hide Free Issue Stock on Works Orders
                               And
                               (
                                 (IdDocHed <> WOR) Or (Not SSDUseLine)
                               );
                       End; // Else
                     End; // With Id
****)
  {$ENDIF}

  {$IFDEF PF_On}
    fmJCBackingSh  : With JobDetl^.JobActual do
                       TBo := Posted and (InvRef = TInv^.OurRef);
  {$ENDIF}

    // MH 16/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
    fmOrdPayVATReceipt : TBO := True;  // Checks already performed when data read in Batch_NextDataRow
  end; {Case..}

  Status:=OldStat;

  Result := TBO;
End; {Func..}


{ Returns true if there are still more rows to print }
function TForm_PrintTest.Batch_GotDataRow : Boolean;
Var
  CurrKey : Str255;
begin
  Result := False;
  MatchKey := False;

  { Check a record was retrieved ok }
  If (Not RowError) Then
  Begin
    // MH 16/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts - these
    //                               filtering checks are not required
    If (CurrJob.PrintBatch.pbDefMode <> fmOrdPayVATReceipt) Then
    Begin
      { Get key for retrieved record }
      CurrKey := Batch_GetModeKey;

      { Compare against required Key }
      With CurrJob.PrintBatch Do Begin
        If (Length (CurrKey) >= Length (pbTablKRef)) Then Begin
          { set to same length as match key }
          SetLength (CurrKey, Length (pbTablKRef));

          { Have a new row if the keys match }
          Result := (UpperCase (CurrKey) = UpperCase (pbTablKRef));
        End; { If }

        MatchKey := Result;

        If Result Then
          Result := Include (pbDefMode, True);
      End; { With }
    End // If (CurrJob.PrintBatch.pbDefMode <> fmOrdPayVATReceipt)
    Else
      Result := True;
  End; { If }
end;

{ Returns a string representing the specified column contents }
Function TForm_PrintTest.Batch_DataCol (ColNo : Byte) : String;
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
                              If (ffBarCode <> bcNone) Then Begin
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
Procedure TForm_PrintTest.Batch_NextDataRow;
Var
  I : Integer;

  //------------------------------

  Procedure LoadVATReceiptData;
  Var
    PrevRec : OrderPaymentsVATPayDetailsRecType;
  Begin // LoadVATReceiptData
    If (RowCount = 0) Then
    Begin
      // Clear down the backup record so that if no rows exist we have safe values in the record
      FillChar(PrevRec, SizeOf(PrevRec), #0);

      // Find first row for receipt
      OPVATPayFile.Index := vpIdxReceiptRef;
      Status := OPVATPayFile.GetGreaterThanOrEqual(OPVATPayFile.BuildReceiptRefKey(Inv.thOrderPaymentOrderRef, Inv.OurRef));
    End // If (RowCount = 0)
    Else
    Begin
      // Backup current record to restore in the event of an error
      PrevRec := OPVATPayFile.VATPayDetails;

      // Find next row for receipt
      Status := OPVATPayFile.GetNext;
    End; // Else

    // Check keys match
    MatchKey := (Status = 0) And (Trim(OPVATPayFile.VATPayDetails.vpReceiptRef) = Trim(Inv.OurRef));

    //PR: 05/02/2015 ABSEXCH-16022 If this is a match record then move on to next record until we find a non-match one
    while MatchKey and (OPVATPayFile.VATPayDetails.vpType = vptMatching) do
    begin
      Status := OPVATPayFile.GetNext;

      MatchKey := (Status = 0) And (Trim(OPVATPayFile.VATPayDetails.vpReceiptRef) = Trim(Inv.OurRef));
    end;

    RowError := (Status <> 0) Or (Not MatchKey);
    If RowError Then
      // Restore original record so we have safe values
      OPVATPayFile.VATPayDetails := PrevRec;
  End; // LoadVATReceiptData

  //------------------------------

  Procedure LoadLegacyData;
  Var
    FNum, KPath, TmpStat : Integer;
    KRef                 : Str255;
  Begin // LoadLegacyData
    With CurrJob.PrintBatch Do Begin
      FNum  := pbTablFnum;
      KRef  := pbTablKRef;
      KPath := pbTablKPath;
    End; { With }

    { Get record from file }
    If (RowCount = 0) Then Begin
      RowError := False;

      If (sStartSearchKey <> '') Then
        KRef := sStartSearchKey;

      { Get First }
      Status := Find_Rec (B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KPath, KRef);
    End { If }
    Else Begin
      { Restore position - just in case the data dict has sabotaged it }
      TmpStat := Presrv_BTPos(Fnum, KPath, F[Fnum],TmpRecAddr, BOn, BOff);

      // MH 16/03/2009: Restore search key as req'd by Btrieve
      If (sLastSearchKey <> '') Then
        KRef := sLastSearchKey;

      { Get Next }
      Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KPath, KRef);
    End; { Else }

    { Get Next until we've got a valid record }
    While (Not Batch_GotDataRow) And MatchKey And (Status = 0) Do Begin
      Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KPath, KRef);
    End; { While }

    RowError := (Status <> 0) Or (Not MatchKey);

    If (Not RowError) Then
    Begin
      // MH 16/03/2009: Save/Restore search key as req'd by Btrieve
      sLastSearchKey := KRef;

      // MH 21/07/2010 v6.4 ABSEXCH-10050: Extended to consolidate sorted picking lists
      If (CurrJob.PrintBatch.pbDefMode = fmPickLstCons) Or
         (CurrJob.PrintBatch.pbDefMode = fmSortedConsPickingList) Then
        { Consolidate the stock items sold for the picking list }
        Batch_ConsolPick (CurrJob.PrintBatch.pbDefMode, FNum, KPath, KRef);

      { Save record details }
      ExLocal.AssignFromGlobal(FNum);

      { Save table file position }
      TmpStat:=Presrv_BTPos(Fnum, KPath, F[Fnum], TmpRecAddr, BOff, BOff);

      { Add into running totals }
      DicRunTots (CurrJob.PrintBatch.pbDefMode);
    End { If }
    Else
      { Restore record - so the data dict doesn't load duff data }
      ExLocal.AssignToGlobal(FNum);
  End; // LoadLegacyData

  //------------------------------

begin
  { Calculate any columns that haven't already been done (i.e. Hidden }
  If (Columns.Count > 0) And (RowCount > 0) Then
    For I := 0 To (Columns.Count - 1) Do
      With TFormDefListObjType(Columns.Items[I]), FormDef Do
        If (Not ValueSet) Then
          PrintForm_DataCol (I);

  If Assigned (CurrJob) Then
  Begin
    // MH 16/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
    If (CurrJob.PrintBatch.pbDefMode = fmOrdPayVATReceipt) Then
      LoadVATReceiptData
    Else
      LoadLegacyData;

    { Move to next row }
    Inc (RowCount);
  End; { If }
end;

Procedure TForm_PrintTest.Batch_ConsolPick(    Mode, Fnum, Keypath : Integer;
                                           Var KeyS                : Str255);
Var
  KeyRef  : Str255;
  RepSCRO : ScratchPtr;
  bDisableConsolidation : Boolean;
Begin { Consol_Pick }
  RepScrO:=RepInfo.RepPtr;

  bDisableConsolidation := False;

  DefTotals[0]:=0;
  DefTotals[1]:=0;
  DefTotals[2]:=0;
  DefTotals[3]:=0;

  KeyRef:=KeyS;

  While (StatusOk) and (CheckKey(KeyRef,KeyS,Length(KeyRef),BOn)) And (Not bDisableConsolidation) Do
    With Id Do
    Begin
      // MH 21/07/2010 v6.4 ABSEXCH-10050: Extended to allow consolidation of sorted picking lists
      If (Mode = fmPickLstCons) And (RepScrO<>NIL) then {* Get Id Link *}
        RepScrO^.Get_Scratch(RepScr^);

      If (Include(Mode, False)) then Begin
        DefTotals[1]:=DefTotals[1]+Qty_OS(Id);

        DefTotals[2]:=DefTotals[2]+QtyPick;

        DefTotals[3]:=DefTotals[3]+(QtyPick*LWeight);

        DefTotals[0]:=DefTotals[0]+DivWChk(QtyPick,RealStr(Strip('B',[#32],Stock.BinLoc)));

        // MH 21/07/2010 v6.4 ABSEXCH-10050: Don't consolidate non-stock items
        bDisableConsolidation := (Trim(Id.StockCode) = '');
      End; { If }

      If (Not bDisableConsolidation) then
        Status:=Find_Rec(B_GetNext,F[FNum]{DefFVar},Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    End; // With Id

  If (StatusOk) And (Not bDisableConsolidation) then
    Status:=Find_Rec(B_GetPrev,F[FNum]{DefFVar},Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
End;  { Consol_Pick }


{ This Event is executed before the table prints a row }
Procedure TForm_PrintTest.Batch_StartDataRow;

  { Adds note lines }
  Procedure Add_AutoNotes(    NoteType,
                              NoteSType  :  Char;
                              FolioCode  :  Str10;
                              NDate      :  LongDate;
                              NDesc      :  Str80;
                          Var DLineCount :  LongInt);
  Const
    Fnum      =  PWrdF;
    Keypath   =  PWk;
  Begin
    ResetRec(Fnum);
    With Password,NotesRec Do Begin
      LineNo:=DLineCount;

      NType:=NoteSType;

      RecPfix:=NoteTCode;
      SubType:=NoteType;

      NoteDate:=NDate;

      NoteLine:=NDesc;

      NoteFolio:=FullNCode(FolioCode);

      NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo);

      ShowDate:=(NoteDate<>'');

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
      Report_BError(Fnum,Status);

      If (StatusOk) then
        Inc(DLineCount);
    End; {With..}
  end; {Proc..}

  Procedure UpdInvLetter (NewLetter,LtrType : SmallInt);
  Const
    FNum     = InvF;
    NoteDesc : Array[1..2] Of ShortString = ('Statement', 'Debt Chase Letter ');
    DebtSet  = [1..3];
  Var
    TmpKPath         : Integer;

    LockPos, SavePos : LongInt;
    Key2F, NDesc     : Str255;
    Locked           : Boolean;
    HMode            : Byte;
  Begin

    If (Assigned(CurrJob)) then
      TmpKPath:=CurrJob.PrintBatch.pbTablKPath
    else
      TmpKPath:=GetPosKey;

    { Save Position }
    Status:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],SavePos,BOff,BOff);

    { Get and lock invoice }
    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,Key2F,TmpKPath,FNum,True, Locked,LockPos);

    If OK And Locked Then Begin
      { Update last letter count }
      If (NewLetter In DebtSet) Then
        Inv.LastLetter := NewLetter;

      If Syss.AutoNotes And (LtrType In [Low(NoteDesc)..High(NoteDesc)]) Then Begin
        { Add note line }
        NDesc := 'On ' + NoteDesc[LtrType];
        If (NewLetter In DebtSet) Then NDesc := NDesc + IntToStr(NewLetter);
        NDesc := NDesc + '.';

        Add_AutoNotes (NoteDCode, NoteCDCode, FullNomKey (Inv.FolioNum), Today, NDesc, Inv.NLineCount);

        { set notes flag on invoice }
        HMode := 232;
        SetHold(HMode, FNum, TmpKPath, BOff, Inv);
      End; { If }

      { Update and unlock invoice }
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,TmpKPath);
      Status:=UnlockMultiSing(F[Fnum],Fnum,LockPos);

      { Restore position }
      Status:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],SavePos,BOn,BOff);
    End; { If }
  End;

Begin
  Case CurrJob.PrintBatch.pbDefMode Of
    // MH 18/04/06: Added new option to suppress the setting of the Debt Chase Letter Last Letter information
    fmDebtChaseL    : If (Not HeaderRec.fhSuppressDL) And (RepDest <> rdPreview) Then
                      Begin
                        { Add note line and Update invoice with new letter number }
                        UpdInvLetter (RepInfo.DebtLetter, 2);
                      End; // If (Not HeaderRec.fhSuppressDL) And (RepDest <> rdPreview)

    fmStateAgeMnth,
    fmStatemLay     : If Syss.AutoNotes And (RepDest <> rdPreview) Then
                        { Add note line }
                        UpdInvLetter (0, 1);

  End; { Case }
End;


{ Sets the printed status field on transactions }
Procedure TForm_PrintTest.SetPrintedStatus;
Const
  // HM 22/10/02: Extended Document Types that set the Printed status on
  //PrintDocSet  :  Set of DocTypes  = [POR,SOR,SDN,SIN,SCR,SRI,SRF];
  // HM 26/07/04: Moved to PrntForm as PrintedDocSet to be shared with PrintPCC
  //PrintDocSet  :  Set of DocTypes  = [POR,PDN,PIN,PCR,PPI,PRF,SOR,SDN,SIN,SCR,SRI,SRF];

  Fnum         =  InvF;
  Keypath      =  InvOurRefK;
Var
  OInv                    : InvRec;
  TmpStat, TmpKey1        : Integer;
  TmpRecAddr, LAddr       : LongInt;
  KeyS                    : Str255;
  AlsoPicked, LOk, Locked : Boolean;
  TimeOutAt, NextTryAt    : TDateTime;
Begin { SetPrintedStatus }
  With CurrJob.PrintBatch Do Begin
    { Check its printing to printer and we are processing a transaction }
    If (pbMainFnum = InvF) And (RepDest <> rdPreview) Then Begin
      { save position and reload correct invoice - some docs will change Inv to another transaction }
      OInv:=Inv;
      TmpKey1:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOff,BOff);

      { Link to correct transaction }
      KeyS:=pbMainKRef;
      TmpStat := Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,pbMainKPath,KeyS);

      If (TmpStat = 0) Then Begin
        AlsoPicked := (pbDefMode = 13) Or (pbDefMode = 14);

        { Check its not printed already, or its not picked already, and its the correct document type }
        If ((Not Inv.PrintedDoc) Or ((Not Inv.OnPickRun) And AlsoPicked)) And (Inv.InvDocHed In PrintedDocSet) Then Begin
          { Get and Lock transaction }
          KeyS := Inv.OurRef;
          //LOk := GetMultiRecAddr(B_GetEQ,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,LAddr);

          // MH 10/09/2015 2015-R1 ABSEXCH-16837: Rewrote locking mechanism as it was clashing
          // with the Order Payments Take Payment window - the call to GetMultiRecAddr was trying
          // to get a lock which failed as the Take Payment window had already locked the SOR -
          // GetMultiRecAddr then displayed a MODAL dialog which prevented the user from completing
          // the payment operation and freeing the lock.

          // Try to get a nowait lock - if it fails then go into a loop retrying the lock every
          // second until it succeeds or time out if we reach 10 minutes of failures.  We have
          // to call Application.Process messages in the loop to keep the UI alive
          TmpStat := Find_Rec(B_GetEq + B_MultNWLock, F[InvF], InvF, RecPtr[InvF]^, pbMainKPath, KeyS);
          If (TmpStat <> 0) Then
          Begin
            // Timeout after 10 minutes
            TimeoutAt := IncMinute(Now, 10);
            // Next try the lock in two seconds time - don't want to hammer the database as that
            // could slow down the main thread and reduce Exchequer performance
            NextTryAt := IncSecond(Now, 2);

            // Repeat until the lock suceeds or the timeout time is reached
            Repeat
              // Form printing runs in the main thread in Exchequer so we need to call Application.
              // ProcessMessages to keep the UI responding - so the user can complete the payment
              // process
              Application.ProcessMessages;

              // Check to see if we want to try the lock yet
              If (Now >= NextTryAt) Then
              Begin
                // Retry the NoWait lock
                TmpStat := Find_Rec(B_GetEq + B_MultNWLock, F[InvF], InvF, RecPtr[InvF]^, pbMainKPath, KeyS);
                // Reset the time of the next attempt to two seconds in the future
                NextTryAt := IncSecond(Now, 2);
              End; // If (Now >= NextTryAt)
            Until (TmpStat = 0) Or (Now >= TimeoutAt);
          End; // If (TmpStat <> 0)

          //If LOk And Locked Then
          If (TmpStat = 0) Then
          Begin
            // MH 10/09/2015 2015-R1 ABSEXCH-16837: Get position for Unlock call
            GetPos(F[InvF], InvF, LAddr);

            With Inv Do
            Begin
              PrintedDoc:=BOn;

              If (InvDocHed In OrderSet) then
                OnPickRun:=AlsoPicked;

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

              Report_BError(Fnum,Status);

              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
            End; // With Inv
          End; // If (TmpStat = 0)
        End; { If }
      End; { If }

      { Restore Position }
      TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOn,BOff);
      Inv:=OInv;
    End; { If }
  End; { With }
End;  { SetPrintedStatus }

