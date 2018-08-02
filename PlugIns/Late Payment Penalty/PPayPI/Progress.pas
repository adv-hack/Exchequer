unit Progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, BTConst, BTUtil, BTFile, PPayProc, StrUtil, APIUtil
  , Enterprise01_TLB, MiscUtil, CustABSU, ETDateU;

type
  TTXinfo = Class
    TXOurRef : string;
//    TXOutstanding : real;
    TXInterestCharged : real;
    TXInterestRate : real;
    TXCurrency : integer;
  end;

  TfrmProgress = class(TForm)
    mProgress: TMemo;
    btnClose: TButton;
    btnSave: TButton;
    SaveDialog1: TSaveDialog;
    btnStart: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    LEventData : TAbsEnterpriseSystem;
    procedure AddLine(sString : string);
  end;

{var
  frmProgress: TfrmProgress;}

implementation
uses
  SQLUtils;

{$R *.dfm}

{ TfrmProgress }

procedure TfrmProgress.AddLine(sString: string);
begin
//lbProgress.Items.Add(sString);
//lbProgress.Refresh;
  mProgress.Lines.Add(sString);
  mProgress.Refresh;
  application.processmessages;
end;

procedure TfrmProgress.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProgress.btnSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute
  then mProgress.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmProgress.btnStartClick(Sender: TObject);
var
  KeyS : TStr255;
  PPDefaultRec, PPCustRec : TPPCustRec;
  PPSetupRec : TPPSetupRec;
  iDaysOverdue : integer;
  rDebtChargeTotal, rTXTotal, rInterestTotal : real;
  TXinfo : TTXinfo;
  TransactionList : TList;
  bAddSJI : boolean;

  procedure WaitAWhile;
  var
    iPos : integer;
  begin
    For iPos := 1 to 1000 do
    begin
      Sleep(1);
      Application.ProcessMessages;
    end;{for}
  end;

  function GetSystemSetupRecord : boolean;
  var
    iStatus : integer;
  begin{GetSystemSetupRecord}
    // Find Setup Record
    KeyS := BTFullNomKey(1) + IDX_DUMMY_CHAR;
    iStatus := BTFindRecord(BT_GetEqual, ppFileVar[ppSetupF], PPSetupRec, ppBufferSize[ppSetupF]
    , ppsFolioNoIdx, KeyS);

    if iStatus in [4,9] then
    begin
      // no system setup records, so use defaults
      PPSetupRec.ppsDaysField := 1;
      PPSetupRec.ppsHoldFlagField := 2;
      iStatus := 0;
    end else
    begin
      BTShowError(iStatus, 'BTFindRecord', CompanyRec.Path + ppFileName[ppSetupF]);
    end;{if}

    Result := iStatus = 0;
  end;{GetSystemSetupRecord}

  function GetDefaultDetails : boolean;
  var
    iStatus : integer;
  begin{GetDefaultDetails}
    // not found - get default record
    FillChar(KeyS,SizeOf(KeyS),#0);
    KeyS := PPC_DEFAULT_RECORD;
    iStatus := BTFindRecord(B_GetEq, ppFileVar[ppCustF], PPDefaultRec, ppBufferSize[ppCustF], ppcCustIdx, KeyS);
    PPDefaultRec.ppcActive := TRUE;
    BTShowError(iStatus, 'BTFindRecord', CompanyRec.Path + ppFileName[ppCustF]);
    Result := iStatus = 0;
  end;{GetChargingDetails}

  procedure GetChargingDetails(sCustCode : string);
  var
    iStatus : integer;
  begin{GetChargingDetails}

    //get account record
    FillChar(KeyS,SizeOf(KeyS),#0);
    KeyS := PadString(psRight, sCustCode, ' ', 6);
    iStatus := BTFindRecord(B_GetEq, ppFileVar[ppCustF], PPCustRec, ppBufferSize[ppCustF], ppcCustIdx, KeyS);

    case iStatus of
      0 : ; // found

      4,9 : begin // not found - get default record
        PPCustRec := PPDefaultRec;
        PPCustRec.ppcInterestVariance := 0;
      end;

      else begin
        // error
        BTShowError(iStatus, 'BTFindRecord', CompanyRec.Path + ppFileName[ppCustF]);
      end;
    end;{case}
  end;{GetChargingDetails}

  function GetInterestCharge(rAmount : real) : real;
  var
    rAmountPerDay : real;
  begin {GetInterestCharge}
    rAmountPerDay := rAmount * ((PPDefaultRec.ppcDefaultRate + PPCustRec.ppcInterestVariance) / 36500);
    Result := iDaysOverdue * rAmountPerDay;
  end;{GetInterestCharge}

  function GetDebtCharge(sCustCode : string; rAmount : real) : real;
  var
    iStatus : integer;
    LastPPDebtRec, PPDebtRec : TPPDebtRec;
    bRecordsFound, bCharged : boolean;
  begin{GetDebtCharge}

    // initialise
    Result := 0;
    FillChar(LastPPDebtRec,SizeOf(LastPPDebtRec),#0);
    bCharged := FALSE;
    bRecordsFound := FALSE;

    if UsingSQL then
    begin
      // SQL Only

      // get first record
      KeyS := PadString(psRight, sCustCode, ' ', 6);
      iStatus := BTFindRecord(BT_GetGreater, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
      , ppdValueFrom4SQLIdx, KeyS);

      // find correct debt charge record
      while (iStatus = 0) and (PPDebtRec.ppdCustCode = sCustCode) and (not bCharged) do
      begin
        bRecordsFound := TRUE;
        if PPDebtRec.ppdValueFrom > rAmount then begin
          // value is larger that the value from field, so charge it at the rate of the previous record
          Result := LastPPDebtRec.ppdCharge;
          bCharged := TRUE;
        end;{if}

        // Next Record
        LastPPDebtRec := PPDebtRec;
        iStatus := BTFindRecord(BT_GetNext, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
        , ppdValueFrom4SQLIdx, KeyS);
      end;{while}
    end
    else
    begin
      // Btrieve Only

      // get first record
      KeyS := PadString(psRight, sCustCode, ' ', 6) + BT_MinDoubleKey;
      iStatus := BTFindRecord(BT_GetGreater, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
      , ppdValueFromIdx, KeyS);

      // find correct debt charge record
      while (iStatus = 0) and (PPDebtRec.ppdCustCode = sCustCode) and (not bCharged) do
      begin
        bRecordsFound := TRUE;
        if PPDebtRec.ppdValueFrom > rAmount then begin
          // value is larger that the value from field, so charge it at the rate of the previous record
          Result := LastPPDebtRec.ppdCharge;
          bCharged := TRUE;
        end;{if}

        // Next Record
        LastPPDebtRec := PPDebtRec;
        iStatus := BTFindRecord(BT_GetNext, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
        , ppdValueFromIdx, KeyS);
      end;{while}
    end;{if}

    // amount is larger than the last ValueFrom, so charge it at the last rate
    if (not bCharged) and bRecordsFound then Result := LastPPDebtRec.ppdCharge;

  end;{GetDebtCharge}

  function GetDaysAlreadyPaid : integer;
  begin{GetDaysAlreadyPaid}
    case PPSetupRec.ppsDaysField of
      1 : Result := StrToIntDef(oToolkit.Transaction.thUserField1,0);
      2 : Result := StrToIntDef(oToolkit.Transaction.thUserField2,0);
      3 : Result := StrToIntDef(oToolkit.Transaction.thUserField3,0);
      4 : Result := StrToIntDef(oToolkit.Transaction.thUserField4,0);
    end;{case}
  end;{GetDaysAlreadyPaid}

  procedure UpdateDaysPaid(UpdatedTransaction : ITransaction2);
  begin{UpdateDaysPaid}
    with UpdatedTransaction do begin
      case PPSetupRec.ppsDaysField of
        1 : thUserField1 := IntToStr(StrToIntDef(thUserField1,0) + iDaysOverdue);
        2 : thUserField2 := IntToStr(StrToIntDef(thUserField2,0) + iDaysOverdue);
        3 : thUserField3 := IntToStr(StrToIntDef(thUserField3,0) + iDaysOverdue);
        4 : thUserField4 := IntToStr(StrToIntDef(thUserField4,0) + iDaysOverdue);
      end;{case}
    end;{with}
  end;{UpdateDaysPaid}

//  procedure CreateSJI(sAccCode : string; iCurrency : integer);
  procedure CreateSJI(ICustomer : IAccount);

    procedure InitialiseLine(TheNewLine : ITransactionLine);
    begin{InitialiseLine}
      TheNewLine.ImportDefaults;
//      TheNewLine.tlVATCode := 'S';
      TheNewLine.tlCostCentre := PPCustRec.ppcCostCentre;
      TheNewLine.tlDepartment := PPCustRec.ppcDepartment;
    end;{InitialiseLine}

    function AddNotes(sDocNo : string) : SmallInt;
    var
      iSaveResult : integer;

      procedure AddNote(iLineNo : integer; sText : string);
      begin{AddNote}
        with oToolkit.Transaction.thNotes.Add do begin
          ntLineNo := iLineNo;
          ntText := sText;
          iSaveResult := Save;
          if iSaveResult <> 0 then showmessage('PPayPI.dll - Cannot Add Note to transaction : ' + sDocNo
          + #13#13 + sText + #13#13 + 'Error : ' + IntToStr(iSaveResult));
        end;
      end;{AddNote}

    var
      iPos, iStatus : integer;
      sCurrChar : string;
      oUpdate : ITransaction;

    begin{AddNotes}

      AddLine(sDocNo + ' - Adding Notes');

      with oToolkit do begin
        Transaction.Index := thIdxOurRef;

//        Transaction.GetEqual(Transaction.BuildOurRefIndex(sDocNo));
        iStatus := Transaction.GetEqual(Transaction.BuildOurRefIndex(Trim(sDocNo)));
        if iStatus = 0 then
        begin

          Transaction.thNotes.ntType := ntTypeGeneral;

          For iPos := 0 to TransactionList.Count - 1 do
          begin
            with TTXInfo(TransactionList[iPos]) do
            begin

              // get correct currency char
              sCurrChar := oToolkit.SystemSetup.ssCurrency[Icustomer.acCurrency].scSymbol;
              if sCurrChar = #156 then sCurrChar := '£';

              // add note for this tx
              AddNote(iPos + 1, TXOurRef + ' - '
              + 'Rate : ' + MoneyToStr(TXInterestRate)
              + ' / Interest : ' + MoneyToStr(TXInterestCharged, SystemSetup.ssSalesDecimals)
              + ' (' + sCurrChar + MoneyToStr(oToolkit.Functions.entConvertAmount(TXInterestCharged
              , 1, Icustomer.acCurrency, oToolkit.SystemSetup.ssCurrencyRateType)
              , SystemSetup.ssSalesDecimals) + ')'
              );
            end;{with}
          end;{for}

          oUpdate := Transaction.Update;
          if oUpdate = nil then
          begin
            ShowMessage('oUpdate = nil');
          end
          else
          begin
            with oUpdate do
            begin
              if oUpdate.thOurRef = 'SJI000036' then
              begin
                oToolkit.Functions.entBrowseObject(oUpdate, TRUE);
              end;{if}

              thHoldFlag := 32;
              iSaveResult := Save(FALSE);
              if iSaveResult <> 0 then showmessage('PPayPI.dll - Cannot Update Transaction : '
              + sDocNo + #13#13 + 'Error : ' + IntToStr(iSaveResult));
            end;{with}
          end;{if}
        end else
        begin
          if iStatus <> 0 then showmessage('PPayPI.dll - Cannot find Transaction : '
          + sDocNo + #13#13 + 'Error : ' + IntToStr(iStatus));
        end;{if}
      end;{with}
    end;{AddNotes}

    function AddMatching(sDocNo : string) : SmallInt;
    var
      iStatus, iPos : integer;
      rValue : real;
      TheTXInfo : TTXInfo;
    begin{AddMatching}
      AddLine(sDocNo + ' - Adding Matching');

      with oToolkit do begin
        Transaction.Index := thIdxOurRef;
        Transaction.GetEqual(Transaction.BuildOurRefIndex(sDocNo));

        For iPos := 0 to TransactionList.Count - 1 do
        begin
          TheTXInfo := TTXInfo(TransactionList[iPos]);
          with TheTXInfo do begin
            with (Transaction.thMatching as IMatching2).AddCustom(maTypeUser1) do begin
  //          with (Transaction.thMatching as IMatching2).Add do begin

              rValue := TheTXInfo.TXInterestCharged;
              maPayRef := sDocNo;
              maDocRef := TXOurRef;

              // matching value
              maBaseValue := rValue;
              maPayCurrency := Transaction.thCurrency;
              maPayValue := oToolkit.Functions.entConvertAmount(rValue
              , 1, Transaction.thCurrency, oToolkit.SystemSetup.ssCurrencyRateType);

              maDocCurrency := TXCurrency;
              maDocValue := oToolkit.Functions.entConvertAmount(rValue
              , 1, TXCurrency, oToolkit.SystemSetup.ssCurrencyRateType);

              iStatus := Save;
              if iStatus <> 0 then MsgBox('Matching Error : ' + IntToStr(iStatus), mtError, [mbOK], mbOK, 'Matching Error');
  //            if iStatus <> 0 then MsgBox(oToolkit.LastErrorString + IntToStr(iStatus), mtError, [mbOK], mbOK, 'Matching Error');
            end;{with}
          end;{with}
        end;{for}
      end;{with}
    end;{AddMatching}

  var
    NewTX : ITransaction2;
    NewLine : ITransactionLine;
    iSaveStatus : integer;

  begin{CreateSJI}

    AddLine('Creating SJI for ' + ICustomer.acCode);

    oToolkit.Transaction.SavePosition;

    NewTX := oToolkit.Transaction.Add(dtSJI) as ITransaction2;
    with NewTX do begin
      ImportDefaults;
      thCurrency := ICustomer.acCurrency;
      thAcCode := ICustomer.acCode;
      SetSecondHoldFlag(NewTX, PPSetupRec);

      // add Interest Line
      NewLine := NewTX.thLines.Add;
      with NewLine do begin
        InitialiseLine(NewLine);
        NewLine.tlDescr := 'Interest Charge for Overdue Invoice';
        tlNetValue := oToolkit.Functions.entConvertAmount(rInterestTotal, 1
        ,Icustomer.acCurrency, oToolkit.SystemSetup.ssCurrencyRateType);
        NewLine.tlGLCode := PPCustRec.ppcInterestGLCode;
        NewLine.tlVATCode := 'E';
        CalcVatAmount;
        Save;
      end;{with}
      NewLine := nil;

      // add debit collection charge Line
      NewLine := NewTX.thLines.Add;
      with NewLine do begin
        InitialiseLine(NewLine);
        NewLine.tlDescr := 'Debt Collection Charge for Overdue Invoice';
        tlNetValue := oToolkit.Functions.entConvertAmount(rDebtChargeTotal, 1
        ,Icustomer.acCurrency, oToolkit.SystemSetup.ssCurrencyRateType);
        NewLine.tlGLCode := PPCustRec.ppcDebtChargeGLCode;
        CalcVatAmount;
        Save;
      end;{with}
      NewLine := nil;

      iSaveStatus := save(TRUE);
      ReportTXSaveError(iSaveStatus);

//WaitAWhile;

      if iSaveStatus = 0 then begin
        AddNotes(thOurRef);
        AddMatching(thOurRef);
      end;{if}

    end;{with}
    NewTX := nil;

    oToolkit.Transaction.Index := thIdxOutstanding;
    oToolkit.Transaction.RestorePosition;
  end;{CreateSJI}

  procedure CustomerChange;
  begin{CustomerChange}
    // initialise stuff for new customer
    rDebtChargeTotal := 0;
    rInterestTotal := 0;
    rTXTotal := 0;
    ClearList(TransactionList);
    GetChargingDetails(oToolkit.Transaction.thAcCode);
    bAddSJI := FALSE;
  end;{CustomerChange}

var
  iStatus : integer;
//  sPrevCust : string;
  IPrevCust : IAccount;
  ITransUpdate : ITransaction2;
  iPosition : integer;
  rOutstanding : real;

begin

//  if MsgBox('Are you sure you want to run this process ?', mtConfirmation
//  , [mbYes, mbNo], mbNo, 'Create Prompt Payment SJIs') = mrNo then Exit;

  // initialise
  btnStart.enabled := FALSE;
  btnSave.enabled := FALSE;
  btnClose.enabled := FALSE;
  Screen.Cursor := crHourglass;
//  frmProgress := TfrmProgress.Create(self);
//  frmProgress.Show;
  AddLine('Initialising...');
//  bAddSJI := FALSE;
  OpenFiles;
  TransactionList := TList.Create;

  // get standard records
  if GetSystemSetupRecord and GetDefaultDetails then begin

    StartToolkit(LEventData);

    try
      with oToolkit, Transaction as ITransaction2 do begin

        // get first outstanding Sales TX
        Index := thIdxOutstanding;
        iStatus := GetGreaterThanOrEqual(BuildOutstandingIndex('C'));
        IPrevCust := thAcCodeI;
//        sPrevCust := thAcCode;
        CustomerChange;

        // go through all oustanding sales transactions
        while (iStatus = 0) and (thOutstanding = 'C') do begin

//          showmessage(thourref);
//          AddLine('Processing ' + thOurRef);

          // Add SJI
          if (thAcCode <> IPrevCust.acCode) and bAddSJI then begin
            CreateSJI(IPrevCust);
            CustomerChange;
//            bAddSJI := FALSE;
          end;

          AddLine('Processing ' + thOurRef);

//          rOutstanding := thTotals[TransTotOutstandingInBase];

          // correct tx type AND not on Hold ?
          if (thDocType in [dtSIN, dtSJI])
          and (thHoldFlag in [0         // No Hold Status
                             ,32        // Notes
                             ,128       // Suspend Posting
                             ,160       // Notes + Suspend Posting
                             ,3         // Authorise
                             ,35        // Notes + Authorise
                             ,131       // Suspend Posting + Authorise
                             ,163])     // Notes + Suspend Posting + Authorise
          and (GetSecondHoldFlag(Transaction as ITransaction2, PPSetupRec) <> SHF_HELD)
//          and (rOutstanding <> 0)
          then begin

//            if (thAcCode <> IPrevCust.acCode) then CustomerChange;
            GetChargingDetails(oToolkit.Transaction.thAcCode);

            //get total outstanding
            rOutstanding := thTotals[TransTotOutstandingInBase];

            // Create Update TX
            ITransUpdate := UpdateEx(umDefault);

            // apply the calculations ?
            if (PPCustRec.ppcActive = TRUE) and (rOutstanding >= PPCustRec.ppcMinInvoiceValue)
            and (ITransUpdate <> nil) then
            begin

              // work out days overdue
//              iDaysOverdue := Trunc(Date) - (Trunc(Str8ToDate(thTransDate)) + thAcCodeI.acPayTerms
//              + GetDaysAlreadyPaid + PPCustRec.ppcCreditDaysOffset);

              if PPSetupRec.ppsBaseInterestOnDueDate then
              begin
                // NF: 13/04/06 New Formula for Farmway - Use Due Date
                iDaysOverdue := Trunc(Date) - (Trunc(Str8ToDate(thDueDate))
                + GetDaysAlreadyPaid + PPCustRec.ppcCreditDaysOffset);
              end else
              begin
                // Original Formula Calculate Due Date using payment terms
                iDaysOverdue := Trunc(Date) - (Trunc(Str8ToDate(CalcDueDate(thTransDate, thAcCodeI.acPayTerms)))
                + GetDaysAlreadyPaid + PPCustRec.ppcCreditDaysOffset);
              end;

              if iDaysOverdue > 0 then begin

                // TX is Overdue

                // Add Transaction to list
                TXinfo := TTXinfo.create;
                TXinfo.TXOurRef := thOurRef;
//                TXinfo.TXOutstanding := rOutstanding;
                TXinfo.TXInterestCharged := GetInterestCharge(rOutstanding);
                TXinfo.TXInterestRate := PPDefaultRec.ppcDefaultRate + PPCustRec.ppcInterestVariance;
                TXinfo.TXCurrency := thCurrency;
                TransactionList.Add(TXinfo);


                // Add up total interest
                rInterestTotal := rInterestTotal + TXinfo.TXInterestCharged;

                // Get debt charge
                case PPCustRec.ppcDebitChargeBasis of
                  DCB_NA  : ;

                  DCB_PER_TRANSACTION : begin
                    rDebtChargeTotal := rDebtChargeTotal + GetDebtCharge(PPCustRec.ppcCustCode, rOutstanding);
                  end;

                  DCB_PER_PROCESS : begin
                    rTXTotal := rTXTotal + rOutstanding;
                    rDebtChargeTotal := GetDebtCharge(PPCustRec.ppcCustCode, rTXTotal);
                  end;
                end;{case}

                UpdateDaysPaid(ITransUpdate);
                ReportTXSaveError(ITransUpdate.Save(FALSE));
                ITransUpdate := nil;

                bAddSJI := TRUE;

              end;{if}
            end;{if}
          end;{if}

          // Set Prev Cust for comparison
          IPrevCust := nil;
          IPrevCust := thAcCodeI;

          // get next outstanding TX
          iStatus := GetNext;
        end;{while}

        // Add Last SJI
        if bAddSJI then CreateSJI(IPrevCust);

        AddLine('Processing Complete...');

      end;{with}
    finally
      AddLine('Finalising...');
      oToolkit.CloseToolkit;
      oToolkit := NIL;
      CloseFiles;
//      Close;

//frmProgress.mProgress.Lines.SaveToFile('c:\progress.txt');

      Screen.Cursor := crDefault;
      ClearList(TransactionList);
      TransactionList.Free;
      AddLine('Finished.');
      btnSave.enabled := TRUE;
      btnClose.enabled := TRUE;
    end;{try}
  end;{if}
end;

end.
