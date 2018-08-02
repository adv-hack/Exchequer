{************************************************************************}
{* Batched Label Printing Routines                                      *}
{************************************************************************}

{ Initialise report vars before printing starts }
procedure TForm_PrintTest.BatchLbl_BeforePrint(Sender: TObject);
begin
  TotItems := PrintBatchList.Count;
end;

{ Prints the labels }
procedure TForm_PrintTest.BatchLbl_Print(Sender: TObject);
Var
  CurrentLabel : LongInt;
  I            : Integer;
  FormName     : ShortString;
  HedRec       : fdHeaderRecType;
  StrRec       : fdFormStringsType;
  ListHandle   : TSBSList;
  SnoLabelData : pBatchRepSNoInfoType;
  LStatus      : SmallInt;
  KeyS         : Str255;


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
      pCurr := False;

      Case PageErr Of
        1 : Begin { Cannot open form def }
              PrintLn (#9'Error: Cannot load ' + FormName);
              pForm := False;
              pCurr := True;
            End;

        2 : Begin { Cannot find primary record }
              PrintLn (#9'Error: Cannot load Primary Record');
            End;

        3 : PrintLn (#9'Error: Labels Required');
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

begin
  If (PrintBatchList.Count > 0) Then Begin
    ListHandle := TSBSList.CreateList('PrnBatch');

    Try
      With TheReport, HeaderRec Do Begin
        JobIdx := 0;

        { Get batch item - 1st item contains form name and 1st label number }
        CurrJob := PrintBatchList.Items[JobIdx];

        { Open label form }
        If Assigned (CurrJob) Then Begin
          { Set starting label number }
          CurrentLabel := CurrJob.PrintBatch.pbLabel1;

          { Load form definition }
          FormName := SetDrive + FormsPath + Trim(CurrJob.PrintBatch.pbEFDName) + DefDotExtension;
          If OpenFormDef (FormName, HedRec, StrRec, ListHandle) Then Begin
            SetHedRec (HedRec);
            SetStrRec (StrRec);
            SetControlList (ListHandle);
            DoFont (HeaderRec.fhFont);
            StringsRec  := @StrRec;
            PageNo := 1;

            { Check its a label }
            If (fhFormType = ftLabel) Then Begin
              { Build cache of label positions for the label form }
              BuildLabelPos;

              { Fake proper info for db access }
              DrivingFile := CurrJob.PrintBatch.pbMainFNum;

              { Process batch }
              Repeat
                If (JobIdx > 0) Then
                  CurrJob := PrintBatchList.Items[JobIdx];

                With CurrJob.PrintBatch Do Begin
                  RepInfo := pbRepInfo;

                  { Load primary record }
                  Status := Find_Rec (B_GetEq, F[pbMainFnum], pbMainFnum, RecPtr[pbMainFnum]^, pbMainKPath, pbMainKRef);
                  If StatusOk Then Begin
                    // HM 14/01/04: Need to add a new section here to fix a bug in the Stock Labels
                    // where the Alternate Stock Codes don't work unless the TH and ST records are
                    // correctly loaded
                    If (CurrJob.PrintBatch.pbMainFnum = IDetailF) Then
                    Begin
                      // Link To Invoice
                      KeyS := FullNomKey (Id.FolioRef);
                      Find_Rec (B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, KeyS);

                      If Is_FullStkCode(Id.StockCode) Then
                      Begin
                        // Load ST using Stock Code index
                        KeyS := FullStockCode(Id.StockCode);
                        Find_Rec (B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, KeyS);
                      End; // If Is_FullStkCode(Id.StockCode)
                    End; // If (CurrJob.PrintBatch.pbMainFnum = IDetailF)

                    If (CurrJob.PrintBatch.pbDefMode = fmSerialLabel) Then Begin
                      // For Serial Labels load Serial Details
                      SnoLabelData := pBatchRepSNoInfoType(CurrJob.PrintBatch.pbRepInfo.RepPtr);
                      Try
//ShowMessage (Format('Serial Labels (Copies = %d, RecSize=%d)',[CurrJob.PrintBatch.pbLbCopies, SnoLabelData.RecSize]));
                        // Copy Record Position into Data Record
                        SetDataRecOfs(MiscF, SnoLabelData.SNoRecAddr);

                        // Read Serial Number Record
                        LStatus:=GetDirect(F[MiscF],MiscF,RecPtr[MiscF]^,0,0);
                      Finally
                        CurrJob.PrintBatch.pbRepInfo.RepPtr := NIL;
                        Dispose(SnoLabelData);
                      End;
                    End; { If (CurrJob.PrintBatch.pbDefMode = fmSerialLabel) }

                    // HM 06/04/05: Added counters so labels can print '1 of 3', '2 of 3', ...
                    DefTotals[1] := pbLbCopies;
                    For I := 1 To pbLbCopies Do Begin
                      DefTotals[0] := I;

                      { Print label }
                      OriginX := LabelPos^[CurrentLabel].Left - fhLblLeft;
                      OriginY := LabelPos^[CurrentLabel].Top - fhLblTop;
                      PrintControlList (BodyList);

                      { move to next label - check there are outstanding labels }
                      If (JobIdx < Pred(PrintBatchList.Count)) Or (I < pbLbCopies) Then Begin
                        Inc(CurrentLabel);
                        If (CurrentLabel > (fhLblRows * fhLblCols)) Then Begin
                          CurrentLabel := 1;
                          NewPage;
                        End; { If }
                      End; { If }
                    End; { For }

                    { move to next job }
                    Inc (JobIdx);
                  End { If }
                  Else Begin
                    { Cannot find main record }
                    PrintErrorPage (2);
                    Inc (JobIdx);
                  End; { Else }
                End; { With }

                { Update Progress }
                SendProgress (JobIdx, 1);
              Until AbortBatch Or (JobIdx > Pred(PrintBatchList.Count));
            End { If }
            Else
              { Not a label form }
              PrintErrorPage (3);
          End { If }
          Else
            { Cannot open form def }
            PrintErrorPage (1);
        End; { If }
      End; { With }
    Finally
      EmptyList (ListHandle, True);
      ListHandle.Free;
    End;
  End; { If }
end;






