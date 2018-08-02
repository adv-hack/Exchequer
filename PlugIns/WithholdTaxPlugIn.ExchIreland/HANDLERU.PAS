unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  Inifiles, StrUtil, Controls, APIUtil, UseDLLU, CustWinU, CustAbsU, Classes, TKUtil;

{$I EXDLLBT.INC}
{$I EXCHDLL.INC}

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Form, Dialogs, SysUtils, ChainU, PIMisc, Forms;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
var
  iPos : integer;
  slAboutText : TStringList;
const
  sPlugInName = 'Withhold VAT Plug-In';
  {$IFDEF EX600}
    sVersionNo = 'v7.0.10.015';
  {$ELSE}
    sVersionNo = 'v5.70.014';
  {$ENDIF}
begin
  CustomOn := True;

  With CustomHandlers Do Begin
    { Set About Message }
    slAboutText := TStringList.Create;
    PIMakeAboutText(sPlugInName, sVersionNo + ' (DLL)', slAboutText);
    for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
    slAboutText.Free;

    // Enable Hook
    SetHandlerStatus(wiTransaction{EnterpriseBase + 2000}, 170, EventEnabled); // after store customer

  End; { With }


  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);

End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin

  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
type
  TSettingsRec = record
    iGLCode : integer;
    sDefCostCentre : string3;
    sDefDepartment : string3;
    sRevenueAccCode : string;
    iSuppUserDefField : byte;
    sVATCode : string;
    rVatRate : real;
  end;

var
  SettingsRec : TSettingsRec;

  function NextDocNo(DocType : String): String;
  var
    NextNo, Doc : array[0..255] of Char;
    Res : smallint;
  begin{NextDocNo}
    StrPCopy(Doc, DocType);
    Res := EX_GETNEXTTRANSNO(Doc, NextNo, TRUE);
    if Res = 0 then Result := string(NextNo)
    else Result := '';
  end;{NextDocNo}

  function StoreNote(TKTXNotes : TBatchNotesRec; iLineNo : byte; sLine : string; bInsert : Boolean): smallint;
  var
    iRecAddress : integer;
  begin{StoreNote}
//    Result := Ex_GetRecordAddress(8,iRecAddress);
//    ShowTKError('Ex_GetRecordAddress', 122, Result);
//    if Result = 0 then begin
      with TKTXNotes do begin
        LineNo := iLineNo;
        NoteLine := sLine;
        NoteDate := DateToStr8(Date);
        if bInsert then Result := Ex_StoreNotes(@TKTXNotes,SizeOf(TKTXNotes),0,B_Insert)
        else Result := Ex_StoreNotes(@TKTXNotes,SizeOf(TKTXNotes),0,B_Update);
        ShowTKError('Ex_StoreNotes', 78, Result);
      end;{with}
//      Result := Ex_GetRecWithAddress(8,0,iRecAddress);
//      ShowTKError('Ex_GetRecWithAddress', 123, Result);
//    end;{if}
  end;{StoreNote}

  function AddUpAmountByLine : real;
  var
    iPos : integer;
    rLineNetValue : real;
  begin{AddUpAmountByLine}
    Result := 0;
    with EventData, Transaction, thLines do begin
      For iPos := 1 to thLineCount do begin
        if thLine[iPos].tlVATCode = SettingsRec.sVATCode
        then rLineNetValue := (thLine[iPos].tlNetValue * thLine[iPos].tlQty)
        * (1 / (1 + (SettingsRec.rVatRate / 100)))
        else rLineNetValue := (thLine[iPos].tlNetValue * thLine[iPos].tlQty);
        Result := Result + rLineNetValue;
      end;{for}
    end;{with}
  end;{AddUpAmountByLine}

var
  Year, Month, Day : word;
  SearchKey : PChar;
  iResult, iStatus : integer;
  asCompPath : AnsiString;
  SupplierRec : TBatchCURec;
  SettingsINI : TIniFile;
  rTaxAmount, rPercentage : real;
  PINHead, PJIHead, PJCHead : TBatchTHRec;
  PJILines, PJCLines : TBatchLinesRec;
  sPercentage : string;
  TKMatchRec : TBatchMatchRec;
  TKTXNotes : TBatchNotesRec;

Begin{ExecCustomHandler}
  { Handle Hook Events here }
  With EventData, SettingsRec Do Begin
    if (WinId = wiTransaction {EnterpriseBase + 2000}) and (HandlerId = 170)
//    and (EventData.Transaction.thCurrency = 1)
    and (EventData.Transaction.thInvDocHed = CUPIN) then begin
//    and (Copy(EventData.Transaction.thUser1,1,3) <> 'PJI') then begin

      {OpenDLL}
      iStatus := 0;
      asCompPath := includeTrailingBackslash(EventData.Setup.ssDataPath); //oEntCustom.Intf.SystemSetup.ssDataPath;
      iStatus := SetToolkitPath(PChar(asCompPath));
      if iStatus = 0 then
        begin
          ToolkitOK; // Backdoor the Toolkit DLL to avoid release code requirement
          iStatus := Ex_InitDLL;
          if iStatus = 0 then
            begin
              // Toolkit opened OK

              // Get Supplier Details
              SearchKey := StrAlloc(255);
              StrPCopy(SearchKey, EventData.Transaction.thAcCode);
              iResult := EX_GETACCOUNT(@SupplierRec, SizeOf(SupplierRec), SearchKey, 0, B_GetEq, 2, FALSE);
              if iResult = 0 then
                begin
                  // Got supplier details OK

                  // get the settings from the ini file
                  SettingsINI := TIniFile.Create(asCompPath + 'WHTAXPI.ini');
                  with SettingsINI do begin
                    UpdateFile;
                    iGLCode := StrToIntDef(ReadString('Settings','GLCode',''),0);
                    sDefCostCentre := ReadString('Settings','DefCostCentre','');
                    sDefDepartment := ReadString('Settings','DefDepartment','');
                    sRevenueAccCode := ReadString('Settings','RevenueAccCode','');
                    iSuppUserDefField := StrToIntDef(ReadString('Settings','SuppUserDefField',''),0);
                    sVATCode := ReadString('Settings','VATCode',' ');
                    rVatRate := StrToFloatDef(ReadString('Settings','VatRate',''),0);
                    Free;
                  end;{with}

                  // Get Percentage from the supplier record
                  case iSuppUserDefField of
                    1 : sPercentage := SupplierRec.UserDef1;
                    2 : sPercentage := SupplierRec.UserDef2;
                    3 : sPercentage := SupplierRec.UserDef3;
                    4 : sPercentage := SupplierRec.UserDef4;
                  end;{case}
                  rPercentage := StrToFloatDef(sPercentage,0);

                  if rPercentage <> 0 then begin
                    if MsgBox('Do you wish to apply the withholding tax'
                      + #13'calculation on this transaction ?'
                    ,mtConfirmation,[mbYes,mbNo],mbYes,'Withhold Tax ?') = mrYes then begin

                      // Apply Withholding Tax Calculation

                      // calculate tax amount
                      rTaxAmount := AddUpAmountByLine * (rPercentage / 100);
//                      rTaxAmount := AddUpAmountByLine * (rPercentage / 100);
                      //rTaxAmount :=  EventData.Transaction.thInvNetVal * (rPercentage / 100);

                      //NF: 12/01/2012 Added rounding to the value
                      rTaxAmount := EventData.entRound(rTaxAmount, EventData.Setup.ssNoCosDec);
(*
                      // Store Notes for PIN
                      FillChar(TKTXNotes, SizeOf(TKTXNotes), #0);
                      with TKTXNotes do begin
                        NoteSort := 'DOC';
                        NoteType := '2';
                        NoteCode := EventData.Transaction.thOurRef;
                        iResult := StoreNote(TKTXNotes, 1,'Withheld Tax : '
//                        + FloatToStr(EventData.entRound(rTaxAmount,EventData.Setup.ssNoNetDec))
                        + MoneyToStr(rTaxAmount, EventData.Setup.ssNoCosDec) // already rounded
                        + ' based on ' + sPercentage + ' %', TRUE);
                      end;{with}
*)
                      // Create New PJC

                      // PJC Header
                      FillChar(PJCHead, SizeOf(PJCHead), #0);
                      DecodeDate(Date, Year, Month, Day);
                      with PJCHead do
                      begin
                        OurRef := NextDocNo('PJC');
                        CustCode := EventData.Transaction.thAcCode;
                        TransDate := EventData.Transaction.thTransDate;
                        DueDate := EventData.Transaction.thDueDate;

                        Currency := EventData.Transaction.thCurrency;
                        CoRate := EventData.Transaction.thCompanyRate;
                        VATRate := EventData.Transaction.thDailyRate;
                        YourRef := 'Tax Withheld';
//                        Currency := 1;
//                        CoRate := 1.0;
//                        VATRate := 1.0;

                        AcYr := Year - 1900;
                        AcPr := Month;

//                        CoRate := 1.0;
//                        VATRate := 1.0;

                        TransDocHed := 'PJC';
                        LineCount := 1;

//                        InvNetVal := rTaxAmount;
                      end;{with}

                      // PJC Line
                      FillChar(PJCLines, SizeOf(PJCLines), #0);
                      with PJCLines[1] do begin
                        TransRefNo := PJCHead.OurRef;
                        FolioNum := PJCHead.FolioNum;
                        LineNo := 1;
                        NomCode := iGLCode;
                        Currency := PJCHead.Currency;
                        CoRate := PJCHead.CoRate;
                        VATRate := PJCHead.VATRate;
                        Qty := 1.0;
                        QtyMul := 1.0;
                        NetValue := rTaxAmount;
                        VATCode := 'Z';
                        CustCode := PJCHead.CustCode;
                        LineDate := PJCHead.TransDate;
                        Desc := 'Withheld Tax based on ' + sPercentage + ' %';
                        CC := sDefCostCentre;
                        Dep := sDefDepartment;
                      end;{with}

                      // Set PJC Header Total from Line
                      Ex_GetLineTotal(@PJCLines[1], SizeOf(PJCLines[1]), true, 0, PJCHead.InvNetVal);

                      // Store PJC
                      iResult := Ex_StoreTrans(@PJCHead, @PJCLines, SizeOf(PJCHead), SizeOf(PJCLines), 0, B_Insert);
                      ShowTKError('Ex_StoreTrans', 21, iResult, 'Ex_StoreTrans : PJC');

                      // Store Notes for PIN
                      FillChar(TKTXNotes, SizeOf(TKTXNotes), #0);
                      with TKTXNotes do begin
                        NoteSort := 'DOC';
                        NoteType := '2';
                        NoteCode := EventData.Transaction.thOurRef;
                        iResult := StoreNote(TKTXNotes, 1,'Withheld Tax : '
                        + MoneyToStr(PJCHead.InvNetVal) // already rounded
                        + ' based on ' + sPercentage + ' %', TRUE);
                      end;{with}

//                      ShowMessage('#1');

                      if iResult = 0 then begin

                        // Populate PJI
                        PJIHead := PJCHead;
                        PJILines := PJCLines;
                        PJIHead.CustCode := sRevenueAccCode;
                        PJIHead.TransDocHed := 'PJI';
                        PJIHead.OurRef := NextDocNo('PJI');
                        PJIHead.YourRef := EventData.Transaction.thOurRef;
                        PJCLines[1].TransRefNo := PJIHead.OurRef;
                        PJCLines[1].CustCode := PJIHead.CustCode;

                        // Store PJI
                        iResult := Ex_StoreTrans(@PJIHead, @PJILines, SizeOf(PJIHead), SizeOf(PJILines), 0, B_Insert);
                        ShowTKError('Ex_StoreTrans', 21, iResult, 'Ex_StoreTrans : PJI');

//                        ShowMessage('#2');

                        if iResult = 0 then begin

                          // Store Notes for PJI
                          FillChar(TKTXNotes, SizeOf(TKTXNotes), #0);
                          with TKTXNotes do begin
                            NoteSort := 'DOC';
                            NoteType := '2';
                            NoteCode := PJIHead.OurRef;
                            iResult := StoreNote(TKTXNotes, 1,'Withheld Tax : '
//                            + FloatToStr(EventData.entRound(rTaxAmount,EventData.Setup.ssNoNetDec))
//                            + MoneyToStr(rTaxAmount, EventData.Setup.ssNoCosDec) // already rounded
                            + MoneyToStr(PJIHead.InvNetVal) // already rounded
                            + ' based on ' + sPercentage + ' %', TRUE);
                          end;{with}

//                      ShowMessage('#3');

                          // Matching

                          // Store Match between PIN and PJC
                          FillChar(TKMatchRec,SizeOf(TKMatchRec),#0);
                          with TKMatchRec do begin
                            DebitRef :=  EventData.Transaction.thOurRef;
                            CreditRef := PJCHead.OurRef;
                            DebitCr := PJCHead.Currency;
                            CreditCr := PJCHead.Currency;

                            //PR: 06/05/2014 ABSEXCH-15027 Remove -ve signs as toolkit handles signage
                            DebitVal := PJCHead.InvNetVal; { Value of Debit Amount in Debit Currency }
                            CreditVal := PJCHead.InvNetVal; { Value of Credit Amount in Credit Currency }

                            BaseVal := PJCHead.InvNetVal;
                            EX_CONVERTAMOUNT(PJCHead.Currency, 1, BaseVal, 0);
                          end;{with}
                          iResult := Ex_StoreMatch(@TKMatchRec, SizeOf(TKMatchRec),0,B_Insert);
                          ShowTKError('Ex_StoreMatch', 76, iResult);

//                      ShowMessage('#4');

                          (*// Store Match between PIN and PJI
                          with TKMatchRec do begin
                            DebitRef :=  EventData.Transaction.thOurRef;
                            CreditRef := PJIHead.OurRef;
                            DebitCr := 1;
                            CreditCr := 1;
                            DebitVal := EventData.Transaction.thInvNetVal; { Value of Debit Amount in Debit Currency }
                            CreditVal := PJIHead.InvNetVal; { Value of Credit Amount in Credit Currency }
                            BaseVal  := PJIHead.InvNetVal; { Value of Amount Settled in Base Currency }
                          end;{with}
                          iResult := Ex_StoreMatch(@TKMatchRec, SizeOf(TKMatchRec),0,B_Insert);
                          ShowTKError('Ex_StoreMatch', 76, iResult);*)

                          // Find and update PIN Header
{                          StrPCopy(SearchKey, EventData.Transaction.thOurRef);
                          iResult := EX_GETTRANSHED(@PINHead, SizeOf(PINHead), SearchKey, 0, B_GetEq, TRUE);
                          ShowTKError('EX_GETTRANSHED', 24, iResult);
                          if iResult = 0 then begin
                            PINHead.DocUser1 := PJIHead.OurRef;
                            iResult := EX_STORETRANSHED(@PINHead, SizeOf(PINHead));
                            ShowTKError('EX_STORETRANSHED', 125, iResult);
                          end;{if}
                        end;{if}
                      end;{if}
                    end;{if}
                  end;{if}
                end
              else begin
                ShowTKError('EX_GETACCOUNT', 3, iResult);
              end;{if}
              strDispose(SearchKey);
            end
          else begin
            MsgBox('The DLL Toolkit failed to open with the error code : ' + IntToStr(iStatus),mtError
            ,[mbOK],mbOK,'Toolkit Open Error');
          end;{if}
        end

      else begin
        MsgBox('Unable to change the path of the DLL Toolkit - error code : ' + IntToStr(iStatus),mtError
        ,[mbOK],mbOK,'Toolkit Path Error');
      end;{if}

      Ex_CloseData;

    end;{if}
  end;{with}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;{ExecCustomHandler}

end.
