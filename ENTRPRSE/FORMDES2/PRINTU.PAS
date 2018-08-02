unit printU;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, GlobVar, GlobType, SBSList, RpDevice,
     ETStrU;

{ DEFINE LOGF}
{ DEFINE MHPRT}

{Procedure PrintPageBorders (Const HedRec    : fdHeaderRecType); Export;}
{Procedure PrintPageBorders (Const HedRec : fdHeaderRecType;
                                  RpDvc  : TRpDevice); Export;}
Procedure PrintPageBorders (Const HedRec   : fdHeaderRecType;
                            Const PrnSetup : TSBSPrintSetupInfo); Export;

Procedure PrintLabelBorders (Const HedRec   : fdHeaderRecType;
                             Const PrnSetup : TSBSPrintSetupInfo); Export;

Function PrintFormDef (Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList;
                       Const Preview    : Boolean;
                       Const PrnSetup   : TSBSPrintSetupInfo) : Boolean; Export;

Function PrintBatch_ClearBatch : Boolean; Export;
Function PrintBatch_AddJob (Const PrBatch : PrintBatchRecType) : Boolean; Export;
Function PrintBatch_Print (Const WinTitle : ShortString;
                           Const PrnInfo  : TSBSPrintSetupInfo) : Boolean; Export;


Procedure TestLabels (FormName : String8); Export;

//PR: 06/06/2011 Made function public so it can be called from oPJEmailTEFPrintJobEmailInfo.UpdatePrnSetup in the Forms Toolkit
Function DefaultDocName(Const DefMode : Smallint; UseMAPI : Boolean) : ShortString;

Var
  PrintBatchList : TSBSList;
  {$IFDEF LOGF}
  LogF           : TextFile;
  {$ENDIF}

implementation

Uses FormFile, Register, PrntForm, LabelDlg, VarConst, BtrvU2,
     // MH 16/02/2017 2017-R1 ABSEXCH-14925: Added MadExcept Logging
     MadExcept,
     BtKeys1U, PrintPCC, PrnXML, VarRec2U, SysU2;

{$IFDEF MHPRT}
Var
  ShowMsgs : Boolean;
{$ENDIF}

{ Prints the borders of a page }
{Procedure PrintPageBorders (Const HedRec    : fdHeaderRecType);}
Procedure PrintPageBorders (Const HedRec   : fdHeaderRecType;
                            Const PrnSetup : TSBSPrintSetupInfo); Export;
Var
  TempList  : TSBSList;
begin
  Form_PrintTest := TForm_PrintTest.Create (Application);
  Try
    TempList := TSBSList.CreateList ('PageBorders');
    Try
      RpDev.SetPrnSetup(PrnSetup);

      Form_PrintTest.InitPrintType (rtTestForm, RpDev.DeviceIndex, False, 1, False, False, PrnSetup);
      Form_PrintTest.SetHedRec (HedRec);
      Form_PrintTest.SetOrientation (HedRec.fhOrientation);
      Form_PrintTest.SetControlList (TempList);
      Form_PrintTest.PrintReport ('Page Borders', PrnSetup);
    Finally
      TempList.Free;
    End;
  Finally
    Form_PrintTest.Release;
  End;
end;

{ Prints the borders of all labels on a page }
Procedure PrintLabelBorders (Const HedRec   : fdHeaderRecType;
                             Const PrnSetup : TSBSPrintSetupInfo); Export;
Var
  TempList  : TSBSList;
begin
  Form_PrintTest := TForm_PrintTest.Create (Application);
  Try
    TempList := TSBSList.CreateList ('LabelBorders');
    Try
      RpDev.SetPrnSetup(PrnSetup);

      Form_PrintTest.InitPrintType (rtTestLabel, RpDev.DeviceIndex, False, 1, False, False, PrnSetup);
      Form_PrintTest.SetHedRec (HedRec);
      Form_PrintTest.SetOrientation (HedRec.fhOrientation);
      Form_PrintTest.SetControlList (TempList);
      Form_PrintTest.PrintReport ('Label Borders', PrnSetup);
    Finally
      TempList.Free;
    End;
  Finally
    Form_PrintTest.Free;
  End;
end;

Function GetOpType (Const Preview  : Boolean;
                    Const FormType : fdFormTypeType) : RepTypeType;
begin
  Case FormType Of
    ftForm   : Result := rtDevForm;
    ftLabel  : Result := rtDevLabel;
    ftReport : Result := rtDevReport;
  End; { Case }
end;

Function PrintFormDef (Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList;
                       Const Preview    : Boolean;
                       Const PrnSetup   : TSBSPrintSetupInfo) : Boolean; Export;
Var
  NoLabels, PrnLabel : SmallInt;
  Cont               : Boolean;
begin
  // MH 16/02/2017 2017-R1 ABSEXCH-14925: Added MadExcept Logging
  Try
    Result := True;

    If (HedRec.fhFormType = ftLabel) Then Begin
      { Display label dialog }
      Cont := ShowLabelDlg(HedRec, PrnLabel, NoLabels);

      {If Cont Then
        ShowMessage ('Print ' + IntToStr(NoLabels) + ' labels from label ' + IntToStr(PrnLabel));}
    End { If }
    Else Begin
      { Form }
      Cont := True;

      { Get data into records for printing }
      FF_GetData;
    End; { Else }

    If Cont Then Begin
      Form_PrintTest := TForm_PrintTest.Create (Application);
      Try
        RpDev.SetPrnSetup(PrnSetup);

        Form_PrintTest.InitPrintType (GetOpType (Preview, HedRec.fhFormType), PrnSetup.DevIdx, Preview, 1, False, False, PrnSetup);
        Form_PrintTest.SetHedRec (HedRec);
        Form_PrintTest.SetOrientation (HedRec.fhOrientation);
        Form_PrintTest.SetStrRec (StrRec);
        Form_PrintTest.SetControlList (ListHandle);
        Form_PrintTest.SetLabelInfo (PrnLabel, NoLabels);
        Form_PrintTest.PrintReport ('', PrnSetup);
      Finally
        Form_PrintTest.Release;
      End;
    End; { If }
  Except
    // MH 16/02/2017 2017-R1 ABSEXCH-14925: Added MadExcept Logging
    On E : Exception Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
    Begin
      // Log the exception to file so we have a record of the fault
      AutoSaveBugReport(CreateBugReport(etNormal));

      DoMessageDlg (E.Message, mtError, [mbOk], 0);
    End; // On E : Exception
  End;
end;


{ Clears the Batch List of all job entries }
Function PrintBatch_ClearBatch : Boolean;
Var
  PBObj : TPrintBatchObjType;
begin
{$IFDEF LOGF}
  Writeln (LogF, 'PrintBatch_ClearBatch');
{$ENDIF}

{$IFDEF MHPRT}
  If ShowMsgs Then ShowMessage ('PrintBatch_ClearBatch');
{$ENDIF}

  Result := True;
  Try
    While (PrintBatchList.Count > 0) Do Begin
      { Take copy of object, remove from list, and deallocate }
      PBObj := TPrintBatchObjType(PrintBatchList.Items[0]);
      PrintBatchList.Delete (0);
      PBObj.Free;
    End; { While }
  Except
    Result := False;
  End;

{$IFDEF MHPRT}
  If ShowMsgs Then ShowMessage ('PrintBatch_ClearBatch - Cleared');
{$ENDIF}
{$IFDEF LOGF}
  Writeln (LogF, 'PrintBatch_ClearBatch - Cleared');
{$ENDIF}
end;

Function PrintBatch_AddJob (Const PrBatch : PrintBatchRecType) : Boolean;
Var
  PBObj : TPrintBatchObjType;
{$IFDEF LOGF}
  I     : SmallInt;
{$ENDIF}
begin
{$IFDEF LOGF}
  Writeln (LogF, 'PrintBatch_AddJob:');
  Writeln (LogF, '  pbDefMode:   ', PrBatch.pbDefMode);
  Writeln (LogF, '  pbEFDName:   ', PrBatch.pbEFDName);
  Writeln (LogF, '  pbMainFNum:  ', PrBatch.pbMainFNum);
  Writeln (LogF, '  pbMainKPath: ', PrBatch.pbMainKPath);
  Writeln (LogF, '  pbMainKRef:  ', PrBatch.pbMainKRef);
  Write   (LogF, '               ');
  For I := 1 To Length(PrBatch.pbMainKRef) Do
    Write (LogF, IntToStr(Ord(PrBatch.pbMainKRef[I])), ' ');
  Writeln (LogF);
  Writeln (LogF, '  pbTablFNum:  ', PrBatch.pbTablFNum);
  Writeln (LogF, '  pbTablKPath: ', PrBatch.pbTablKPath);
  Writeln (LogF, '  pbTablKRef:  ', PrBatch.pbTablKRef);
  Write   (LogF, '               ');
  For I := 1 To Length(PrBatch.pbTablKRef) Do
    Write (LogF, IntToStr(Ord(PrBatch.pbTablKRef[I])), ' ');
  Writeln (LogF);
  Writeln (LogF, '  pbLabel1:    ', PrBatch.pbLabel1);
  Writeln (LogF, '  pbLbCopies:  ', PrBatch.pbLbCopies);
  Writeln (LogF, '  pbTestMode:  ', PrBatch.pbTestMode);
{$ENDIF}

{$IFDEF MHPRT}
  ShowMessage ('PrintBatch_AddJob: ' + IntToStr(PrBatch.pbDefMode) + ' / ' + PrBatch.pbEFDName);
{$ENDIF}

  Result := True;
  Try
    PBObj := TPrintBatchObjType.Create;
    PBObj.PrintBatch := PrBatch;
    PrintBatchList.Add (PBObj);
  Except
    Result := False;
  End;

{$IFDEF MHPRT}
  ShowMessage ('PrintBatch_AddJob - Added');
{$ENDIF}
end;

//PR: 06/06/2011 Made function public so it can be called from oPJEmailTEFPrintJobEmailInfo.UpdatePrnSetup in the Forms Toolkit
Function DefaultDocName(Const DefMode : Smallint; UseMAPI : Boolean) : ShortString;

  Function IIF (Const BoolVal : Boolean; Const TrueVal, FalseVal : ShortString) : ShortString;
  Begin { IIF }
    If BoolVal Then
      Result := TrueVal
    Else
      Result := FalseVal;
  End; { IIF }

Begin { DefaultDocName }
  Case DefMode Of
    fmAllDocs,
    fmNomTxfr,
    fmDocSerialNo,
    fmStockAdj     : Result := Chr(255);    // Use OurRef

    fmRemitAdv     : Result := IIF (UseMAPI, 'Remit', 'Remittance Advice');

    fmStatemLay,
    fmStateAgeMnth : Result := IIF (UseMAPI, 'Statemnt', 'Statement');

    fmDebtChaseL   : Result := IIF (UseMAPI, 'Reminder', 'Payment Reminder');
    fmTradeHist    : Result := IIF (UseMAPI, 'History', 'Trading History');
    fmBatchDoc     : Result := 'Batch';
    fmAccDets      : Result := IIF (UseMAPI, 'Account', 'Account Details');

    fmStockRec,
    fmStockNote    : Result := IIF (UseMAPI, 'Stock', 'Stock Details');

    fmPickLstCons,
    fmPickLstSngl  : Result := IIF (UseMAPI, 'PickList', 'Picking List');

    fmConsignNote  : Result := IIF (UseMAPI, 'ConsNote', 'Consignment Note');
    fmTimeSheet    : Result := IIF (UseMAPI, 'Timesht', 'Timesheet');   { Not Used, but just in case! }
    fmJCBackingSh  : Result := IIF (UseMAPI, 'BackSht', 'Backing Sheet');
    fmJCRec        : Result := IIF (UseMAPI, 'Job', 'Job Record');

    fmLabelRun,
    fmLabelSngl,
    fmDelivLabel,
    fmProductLabel,
    fmSnglProduct,
    fmProdViaDeliv,
    fmSerialLabel,
    fmLabel        : Result := 'Label';
  Else
    // Unknown mode - leave as temporary file name
    Result := '';
  End; { Case }
End; { DefaultDocName }


Function PrintBatch_Print (Const WinTitle : ShortString;
                           Const PrnInfo  : TSBSPrintSetupInfo) : Boolean;
Var
  lPrnInfo           : TSBSPrintSetupInfo;
  CurrJob, CoverJob  : TPrintBatchObjType;
  Form_PrintPCC      : TForm_PrintPCC;


  Procedure GetUserProfile (PLogin : Str10);
  Var
    KeyS     : Str255;
    LStatus  : SmallInt;
  Begin { GetUserProfile }
    // Check for change in Login Id
    If (Trim(PLogin) <> Trim(UserProfile^.Login)) Then
    Begin
      FillChar (UserProfile^, SizeOf(UserProfile^), #0);

      If (Trim(PLogin) <> '') Then
      Begin
        // MH 01/04/2011 v6.7 ABSEXCH-10689: Modified to load User Permissions
        If GetLogInRec(PLogin) Then
        Begin
          KeyS := FullPWordKey(PassUCode,'D',PLogin);
          LStatus := Find_Rec(B_GetEq,F[MLocF],MLocF,RecPtr[MLocF]^,MLK,KeyS);
          If (LStatus = 0) then
            UserProfile^ := MLocCtrl^.PassDefRec
          Else
            UserProfile^.Login := LJVar(PLogin,LoginKeyLen);
        End; // If GetLogInRec(PLogin)
      End; { If (Trim(PLogin) <> '') }
    End; { If }
  End; { GetUserProfile }

begin
  // HM 31/01/01: Have to use local copy to allow feEmailFName to be changed
  lPrnInfo := PrnInfo;

{$IFDEF LOGF}
  Writeln (LogF, 'PrintBatch_Print: ', WinTitle);
  With lPrnInfo Do Begin
    Writeln (LogF, '  DevIdx:    ', DevIdx);
    Writeln (LogF, '  Preview:   ', Ord(Preview));
    Writeln (LogF, '  NoCopies:  ', NoCopies);
    Writeln (LogF, '  pbLabel1:  ', pbLabel1);
    Writeln (LogF, '  LabelMode: ', Ord(LabelMode));
  End; { With lPrnInfo }
{$ENDIF}

  Result := True;

{$IFDEF MHPRT}
With lPrnInfo Do
  ShowMessage ('PrintBatch_Print: ' + WinTitle + #10#13 +
               'Printer: ' + IntToStr(DevIdx) + #10#13 +
               'Form: ' + IntToStr(FormNo) + '/' + FormName + #10#13 +
               'Bin: ' + IntToStr(BinNo) + '/' + BinName);
{$ENDIF}

{Repeat
  Application.ProcessMessages;
Until Not FileExists ('c:\1.txt');}

  If (PrintBatchList.Count > 0) Then Begin
    CurrJob := PrintBatchList.Items[0];
    CoverJob := Nil;

    If (lPrnInfo.fePrintMethod <> 3) Then Begin
      If (lPrnInfo.fePrintMethod In [2, 4]) Then
        // Sending via email - determine friendly attachment name
        lPrnInfo.feEmailFname := DefaultDocName(CurrJob.PrintBatch.pbDefMode, PrnInfo.feEmailMAPI);

      // HM 20/11/01: Added support for user profiles
      GetUserProfile (Trim(lPrnInfo.feUserId));

      { Check to see if it is a DEF form or a EFD form }
      If FileExists (SetDrive + FormsPath + Trim(CurrJob.PrintBatch.pbEFDName) + DefDotExtension) Then Begin
        { Standard Form Designer EFD File }
        Form_PrintTest := TForm_PrintTest.Create (Application);
        Try
          Try
            RpDev.SetPrnSetup(lPrnInfo);

            With lPrnInfo Do Begin
              { Insert cover page if required }
              If (fePrintMethod In [1, 2, 4]) And (Trim(feCoverSheet) <> '') Then Begin
                { Check form exists and its the correct form type }
                If FileExists (SetDrive + FormsPath + Trim(feCoverSheet) + DefDotExtension) Then Begin
                  Try
                    CoverJob := TPrintBatchObjType.Create;
                    CoverJob.PrintBatch := CurrJob.PrintBatch;

                    CoverJob.PrintBatch.pbEFDName := feCoverSheet;
                    PrintBatchList.Insert (0, CoverJob);
                  Except
                    Result := False;
                  End;
                End; { If }
              End; { If }

              // HM 25/10/02: Modified to use LabelSet
              If (CurrJob.PrintBatch.pbDefMode In fmLabelSet) {= fmLabel)} Then
                { Label - any sort }
                //Form_PrintTest.InitPrintType (rtBatchLabel, DevIdx, Preview, NoCopies, CurrJob.PrintBatch.pbTestMode, ChequeMode, lPrnInfo)
                { HM 23/06/99: Modified as printing square of required no of labels }
                Form_PrintTest.InitPrintType (rtBatchLabel, DevIdx, Preview, 1, CurrJob.PrintBatch.pbTestMode, ChequeMode, lPrnInfo)
              Else
                { form }
                Form_PrintTest.InitPrintType (rtBatch, DevIdx, Preview, NoCopies, CurrJob.PrintBatch.pbTestMode, ChequeMode, lPrnInfo);
            End; { If }

            // HM 09/06/00: Modified to correctly pickup the Cover Sheet orientation
            If Assigned(CoverJob) Then
              { open first form and set orientation }
              Form_PrintTest.SetOrientation (GetFormOrient (CoverJob.PrintBatch.pbEFDName))
            Else
              { open first form and set orientation }
              Form_PrintTest.SetOrientation (GetFormOrient (CurrJob.PrintBatch.pbEFDName));

            { Print batch }
            Form_PrintTest.PrintReport (WinTitle, lPrnInfo);
          Except
            On Ex : Exception Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
              DoMessageDlg ('The following error has occurred trying to print - ''' + Ex.Message + '''', mtError, [mbOk], 0);
          End;
        Finally
          Form_PrintTest.Release;
        End;
      End { If }
      Else
        { PCC Form - modified DOS style DEF/LST Form for Exchequer }
        If FileExists (SetDrive + FormsPath + Trim(CurrJob.PrintBatch.pbEFDName) + '.' +DefPCCExtension) Then Begin
          { Printer Control Code form }
          Form_PrintPCC := TForm_PrintPCC.Create(SystemInfo.MainForm);
          Try
            Try
              RpDev.SetPrnSetup(lPrnInfo);

              With lPrnInfo Do Begin
                { Insert cover page if required }
                If (fePrintMethod In [1, 2]) And (Trim(feCoverSheet) <> '') Then Begin
                  { Check form exists and its the correct form type }
                  If FileExists (SetDrive + FormsPath + Trim(feCoverSheet) + '.' + DefPCCExtension) Then Begin
                    Try
                      CoverJob := TPrintBatchObjType.Create;
                      CoverJob.PrintBatch := CurrJob.PrintBatch;

                      CoverJob.PrintBatch.pbEFDName := feCoverSheet;
                      PrintBatchList.Insert (0, CoverJob);
                    Except
                      Result := False;
                    End;
                  End; { If }
                End; { If }

                // HM 25/10/02: Modified to use LabelSet
                If (CurrJob.PrintBatch.pbDefMode In fmLabelSet) {= fmLabel)} Then Begin
                  { Label - any sort - treat as mini forms }
                  Form_PrintPCC.InitPrintType (rtBatch,
                                               DevIdx,
                                               Preview,
                                               NoCopies,
                                               CurrJob.PrintBatch.pbTestMode,
                                               ChequeMode,
                                               lPrnInfo)
                End { If }
                Else
                  { form }
                  Form_PrintPCC.InitPrintType (rtBatch,
                                               DevIdx,
                                               Preview,
                                               NoCopies,
                                               CurrJob.PrintBatch.pbTestMode,
                                               ChequeMode,
                                               lPrnInfo);

                { Print batch }
                Form_PrintPCC.PrintReport (WinTitle, lPrnInfo);
              End; { With lPrnInfo }
            Except
              On Ex : Exception Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
                DoMessageDlg ('The following error has occurred trying to print a PCC Form - ''' + Ex.Message + '''', mtError, [mbOk], 0);
            End;
          Finally
            Form_PrintPCC.Release;
          End;
        End { If }
        Else
          { We're in trubble boyo } //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
          DoMessageDlg ('The following error has occurred trying to print - ''Unknown Form - ' +
                      CurrJob.PrintBatch.pbEFDName + '''', mtError, [mbOk], 0);
    End { If (fePrintMethod = 3) }
    Else Begin
      { XML Batch }
      xmlPrintBatch (WinTitle, lPrnInfo);
    End; { Else }
  End; { If }

{$IFDEF MHPRT}
  ShowMessage ('PrintBatch_Print - Finished');
{$ENDIF}

{$IFDEF LOGF}
  Writeln (LogF, 'PrintBatch_Print - Finished');
{$ENDIF}
End;


Procedure TestLabels (FormName : String8);
Var
  FNum, PrnLabel, NoLabels, I : SmallInt;
  KeyPath                     : LongInt;
  KeyS                        : Str255;
  PrnInfo                     : TSBSPrintSetupInfo;
  PrBatch                     : PrintBatchRecType;
Begin
  With GetFormInfo (FormName) Do
    If RpDev.PrinterSetupDialog Then Begin
      PrnInfo := RpDev.SBSSetupInfo;

      If ShowLabelDlg(FormHeader, PrnLabel, NoLabels) Then Begin
        Case FormHeader.fhPurpose Of
          0,           { Customer }
          1   : Begin  { Supplier }
                  FNum := CustF;
                  KeyPath := CustCodeK;
                End;
          2   : Begin  { Stock }
                  FNum := StockF;
                  KeyPath := StkCodeK;
                End;
        End; { Case }

        If PrintBatch_ClearBatch Then Begin
          Status := Find_Rec (B_GetFirst, F[FNum], FNum, RecPtr[FNum]^, KeyPath, KeyS);
          If StatusOk And (NoLabels >= 1) Then
            For I := 1 To NoLabels do Begin
              FillChar (PrBatch, SizeOf(PrBatch), #0);
              With PrBatch Do Begin
                pbDefMode   := fmLabel;
                pbEFDName   := FormName;
                pbMainFNum  := FNum;
                pbMainKPath := KeyPath;
                Case FNum Of
                  CustF  : pbMainKRef  := FullCustCode (Cust.CustCode);
                  StockF : pbMainKRef  := FullStockCode(Stock.StockCode);
                End; { Case }

                pbLabel1    := PrnLabel;
                pbLbCopies  := 1;
                If (I = 3) Then pbLbCopies := 2;
                If (I = 5) Then pbLbCopies := 3;
              End; { With }

              PrintBatch_AddJob (PrBatch);

              Status := Find_Rec (B_GetNext, F[FNum], FNum, RecPtr[FNum]^, KeyPath, KeyS);
              If (Status = 9) Then
                Status := Find_Rec (B_GetFirst, F[FNum], FNum, RecPtr[FNum]^, KeyPath, KeyS);
            End; { For }

          PrintBatch_Print ('Label Test Batch', PrnInfo);
        End; { If }
      End; { If }
    End; { If }
End;


Initialization
  PrintBatchList := TSBSList.CreateList('PrnBtch');

  {$IFDEF MHPRT}
    ShowMsgs := True;
  {$ENDIF}

  {$IFDEF LOGF}
    AssignFile (LogF, 'c:\log.txt');
    Rewrite    (LogF);
  {$ENDIF}
Finalization

  {$IFDEF MHPRT}
    ShowMsgs := False;
  {$ENDIF}

  PrintBatch_ClearBatch;
  PrintBatchList.Free;

  {$IFDEF LOGF}
    Close (LogF);
  {$ENDIF}
end.
