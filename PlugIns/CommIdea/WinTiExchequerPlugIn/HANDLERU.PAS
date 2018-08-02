unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  Math, ComObj, APIUtil, CustWinU, CustAbsU, Classes, Controls, PISecure
  , MathUtil, Types, Enterprise01_TLB, MiscUtil;

const
  SOR_CUSTOM_BUTTON_1 = 14;
  SOR_CUSTOM_BUTTON_2 = 24;
  CUST_LEDGER_BUT_1 = 120;
  CUST_LEDGER_BUT_2 = 121;
  HOOK_BEFORE_STORE_TX = 1;

  {$IFDEF EX600}
    sVersionNo = 'v6.00.005';
  {$ELSE}
    sVersionNo = 'v5.71.005';
  {$ENDIF}
  sPlugInName = 'SOR Authorisation Plug-In';

var
  iCustomerLedgerBtnId : integer;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Inifiles, AuthSORProc, Windows, TKUtil, StrUtil, Dialogs, SysUtils, ChainU
  , PIMisc, Forms, ETMiscU, CardDetails;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

var
  bHookEnabled : boolean;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
type
  THookPointRec = record
    WindowID : integer;
    HandlerID : integer;
  end;
const
  NO_OF_HOOK_POINTS = 3;
var
  iEID : byte;
  iHook, iPos : integer;
  slAboutText : TStringList;
  aHookPoints : array [1..NO_OF_HOOK_POINTS] of THookPointRec;
begin
  CustomOn := True;

  //Check Plug-In Security
  bHookEnabled := PICheckSecurity('EXCHSORAUT000057', 'VSWtgGC56hghETrf', sPlugInName
  , sVersionNo + ' (DLL)', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    with TAbsCustomHandlers01(CustomHandlers) do begin
      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, sVersionNo + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);

      // Detect if SOR Daybook Custom button 1 is already in use.
(*      if (not HookPointEnabled(wiTransaction, 14)) then
        begin
          iSORDaybookBtnId := 14;
        end
      else begin
        // Detect if SOR Daybook Custom button 2 is already in use.
        if (not HookPointEnabled(wiTransaction, 24)) then begin
          iSORDaybookBtnId := 24;
        end;{if}
      end;{if}*)

      // Detect if SOR Daybook Custom button 1 is already in use.
      iCustomerLedgerBtnId := -1;
      if (not HookPointEnabled(wiAccount, CUST_LEDGER_BUT_1)) then
        begin
          iCustomerLedgerBtnId := CUST_LEDGER_BUT_1;
        end
      else begin
        // Detect if SOR Daybook Custom button 2 is already in use.
        if (not HookPointEnabled(wiAccount, CUST_LEDGER_BUT_2)) then begin
          iCustomerLedgerBtnId := CUST_LEDGER_BUT_2;
        end;{if}
      end;{if}

      // Custom Button 1 on SOR Daybook (Authorisation)
      aHookPoints[1].WindowID := wiTransaction;
      aHookPoints[1].HandlerID := SOR_CUSTOM_BUTTON_1;

      // Custom Button 2 on SOR Daybook (Upfront)
      aHookPoints[2].WindowID := wiTransaction;
      aHookPoints[2].HandlerID := SOR_CUSTOM_BUTTON_2;

      // Custom Button on Customer Ledger
      aHookPoints[3].WindowID := wiAccount;
      aHookPoints[3].HandlerID := iCustomerLedgerBtnId;

      // Enable Hooks
      For iHook := 1 to NO_OF_HOOK_POINTS do
      begin
        if aHookPoints[iHook].HandlerID > 0
        then SetHandlerStatus(aHookPoints[iHook].WindowID, aHookPoints[iHook].HandlerID
        , EventEnabled);
      end;{for}

      slAboutText.Free;
    end; { With }
  end;{if}

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit)

  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  iStatus, iPos{, iLine} : integer;
  rOS, rAuthAmount : real;
  bContinue : boolean;
  sUDF : string;
  oTXUpdate : ITransaction2;

  procedure GetSetupRec;
  var
    AuthSORINI : TInifile;
  begin{GetSetupRec}
    AuthSORINI := TInifile.Create(EventData.Setup.ssDataPath + INIFileName);

    SetupRec.SalesLineGLCode := AuthSORINI.ReadInteger('Refunds', 'GLCode', 0);
    SetupRec.SalesLineCC := AuthSORINI.ReadString('Refunds', 'CC', '');
    SetupRec.SalesLineDept := AuthSORINI.ReadString('Refunds', 'Dept', '');
    SetupRec.SterlingCcy := AuthSORINI.ReadInteger('Settings', 'Sterling', 1);

    AuthSORINI.Free;
  end;{GetSetupRec}

  function GetVATMultiplier(cVATCode : char) : real;
  var
    iRate : integer;
  begin{GetVATMultiplier}
    Result := 0;
    For iRate := Ord(low(cuVATIndex)) to Ord(High(cuVATIndex)) do
    begin
      if cVATCode = EventData.Setup.ssVATRates[cuVATIndex(iRate)].svCode
      then Result := 1 + EventData.Setup.ssVATRates[cuVATIndex(iRate)].svRate;
    end;{for}
  end;{GetVATMultiplier}

  function GetDateString(sDate : string) : string;
  var
    sString : string;
  begin{GetDateString}
    sString := RemoveAllChars(Trim(sDate), '/');
    if Length(sString) = 4 then
    begin
      Result := Copy(sString, 1, 2) + '/' + Copy(sString, 3, 2);
    end else
    begin
      Result := '00/00';
    end;{if}
  end;{GetDateString}

  function CashCustomer : Boolean;
  begin{CashCustomer}
    Result := EventData.Customer.acCode = 'CASH01';
  end;{CashCustomer}

  function GetNewHoldFlag(iCurrentFlag : smallint) : smallint;
  begin{GetNewHoldFlag}
    Result := 6;
    Case iCurrentFlag of
//      0,1,2,3,4,5,6 : Result := 6;
      32,33,34,35,36,37,38 : Result := 38;
      128,129,130,131,132,133,134 : Result := 134;
      160,161,162,163,164,165,166 : Result := 166;
    end;{case}
  end;{GetNewHoldFlag}

  Procedure Authorise(iMode : byte);

    function GetTotalPicked : real;
    var
      iLine : integer;
    begin{GetTotalPicked}
      Result := 0;
      For iLine := 1 to EventData.Transaction.thLines.thLineCount do
      begin
        Result := Result + EventData.Transaction.thLines.thLine[iLine].tlQtyPicked;
      end;{for}
    end;{GetTotalPicked}

  begin{Authorise}

    bContinue := FALSE;
    if (iMode = AM_PAYMENT) and (EventData.Transaction.thInvDocHed = cuSOR) then bContinue := TRUE;
    if (iMode = AM_UPFRONT) and (EventData.Transaction.thInvDocHed = cuSOR)
    and (GetTotalPicked = 0) then bContinue := TRUE;
    if (iMode = AM_REFUND) and (EventData.Transaction.thInvDocHed = cuSIN) then bContinue := TRUE;

    if bContinue then
    begin
      // Check for Picked Lines
{                rAuthAmount := 0;
      For iLine := 1 to EventData.Transaction.thLines.thLineCount do
      begin
        rAuthAmount := rAuthAmount + (EventData.Transaction.thLines.thLine[iLine].tlQtyPicked
        * EventData.Transaction.thLines.thLine[iLine].tlNetValue
        * GetVATMultiplier(EventData.Transaction.thLines.thLine[iLine].tlVATCode))
      end;{for}

{                rAuthAmount := EventData.entRound(rAuthAmount, 2);

      if (rAuthAmount > 0) and (not ZeroFloat(rAuthAmount)) then
      begin}

      // Open COM Toolkit
      StartToolkit(EventData);

      // Error in Authorisation
      iStatus := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(EventData.Transaction.thOurRef));
      if iStatus = 0 then
      begin
        // Check to see if transaction is locked
        oTXUpdate := (oToolkit.Transaction as ITransaction4).Update as ITransaction2;
        if oTXUpdate <> nil then
        begin
          oTXUpdate := nil;

          GetSetupRec;

          if (iMode in [AM_PAYMENT{, AM_UPFRONT}]) then
          begin
            // work out outstanding amount
            rOS := oToolkit.Functions.entConvertAmount(EventData.Transaction.thInvNetVal
            + EventData.Transaction.thInvVat, EventData.Transaction.thCurrency, SetupRec.SterlingCcy
            , oToolkit.SystemSetup.ssCurrencyRateType);
            rOS := oToolkit.Functions.entRound(rOS - StrToFloatDef(EventData.Transaction.thUser1, 0), 2);
    {        rOS := (EventData.Transaction.thInvNetVal + EventData.Transaction.thInvVat)
            - StrToFloatDef(EventData.Transaction.thUser1, 0);}
            if ZeroFloat(rOS) or (rOS < 0) then
            begin
              // Already Fully Paid-Off
              bContinue := MsgBox('Payment has already been taken for the full amount of this Sales Order.'
              + #13#13'Are you sure you want to take another payment for this Sales Order ?', mtwarning
              , [mbYes, mbNo], mbNo, 'Fully Paid') = mrYes;
            end;{if}
          end;{if}

          if bContinue then
          begin
    {                  If MsgBox('Do you want to use Credit Card Authorisation on this Transaction ?'
            ,mtConfirmation,[mbYes, mbNo], mbNo, 'Authorise SOR ?') = mrYes then
            begin}

            with TfrmCardDetails.Create(application) do
            begin
              try
    //                        lAmount.Caption := MoneyToStr(rAuthAmount);
                LEventdata := Eventdata;

                // Get Address
                if CashCustomer then
                begin
                  edAddress1.Text := Eventdata.Transaction.thDelAddr[1];
                  edAddress2.Text := Eventdata.Transaction.thDelAddr[2];
                  edAddress3.Text := Eventdata.Transaction.thDelAddr[3];
                  edAddress4.Text := Eventdata.Transaction.thDelAddr[4];
                  edPostcode.Text := Eventdata.Transaction.thDelAddr[5];
                end else
                begin
                  edAddress1.Text := Eventdata.Customer.acAddress[1];
                  edAddress2.Text := Eventdata.Customer.acAddress[2];
                  edAddress3.Text := Eventdata.Customer.acAddress[3];
                  edAddress4.Text := Eventdata.Customer.acAddress[4];
                  edPostcode.Text := Eventdata.Customer.acPostCode;
                end;{if}

                // Get Card Details
                // UDF #2
                sUDF := EventData.Transaction.thUser2;
                iPos := Pos('~',sUDF);
                edCardNo.Text := Copy(sUDF, 1, iPos-1);

                sUDF := Copy(sUDF, iPos+1, 255);
                iPos := Pos('~',sUDF);
                edIssueNo.Text := Copy(sUDF, 1, iPos-1);

                sUDF := Copy(sUDF, iPos+1, 255);
                edSecurityNo.Text := Copy(sUDF, 1, 255);

                // UDF #3
                sUDF := EventData.Transaction.thUser3;
                iPos := Pos('~',sUDF);
                edStartDate.Text := Copy(sUDF, 1, iPos-1);
                if edStartDate.Text = '00/00'
                then edStartDate.Text := '';

                sUDF := Copy(sUDF, iPos+1, 255);
                iPos := Pos('~',sUDF);
                edExpiryDate.Text := Copy(sUDF, 1, iPos-1);
                if edExpiryDate.Text = '00/00'
                then edExpiryDate.Text := '';

                sUDF := Copy(sUDF, iPos+1, 255);
                iCardType := StrToIntDef(Copy(sUDF, 1, 255), 0);

                // Populate other Card Details
                case iMode of
                  AM_PAYMENT : begin
                    lAuthorise.Caption := 'Amount to be Authorised :';
                    lCcy.Visible := TRUE;
                    edAmount.Visible := TRUE;
                    btnOK.Caption := '&Process';
                  end;

                  AM_REFUND : begin
                    if Trim(edCardNo.Text) = '' then bContinue := FALSE;
                    if Trim(edCardNo.Text) = '' then bContinue := FALSE;
                    if Trim(edCardNo.Text) = '' then bContinue := FALSE;
                    lAuthorise.Caption := 'Amount to be Refunded :';
                    lCcy.Visible := TRUE;
                    edAmount.Visible := TRUE;
                    btnOK.Caption := '&Process';

                    edAmount.Value := oToolkit.Functions.entConvertAmount(EventData.Transaction.thInvNetVal
                    + EventData.Transaction.thInvVat, EventData.Transaction.thCurrency, SetupRec.SterlingCcy
                    , oToolkit.SystemSetup.ssCurrencyRateType);

    //                panDetails.enabled := FALSE;
                  end;

                  AM_UPFRONT : begin
                    lAuthorise.Caption := 'Please enter the card details for future use.';
                    lCcy.Visible := FALSE;
                    edAmount.Visible := FALSE;
                    btnOK.Caption := '&Save';
                  end;
                end;{case}

                iTXMode := iMode;

                if Showmodal = mrOK then
                begin
                  iStatus := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(EventData.Transaction.thOurRef));
                  if iStatus = 0 then
                  begin
                    oTXUpdate := (oToolkit.Transaction as ITransaction4).UpdateEx(umDefault);
                    if oTXUpdate <> nil then
                    begin
                      with oTXUpdate do
                      begin
                        // Update UDFs
                        thUserField1 := MoneyToStr(StrToFloatDef(EventData.Transaction.thUser1, 0) + rAmount);

                        thUserField2 := Trim(edCardNo.Text)
                        + '~' + Trim(edIssueNo.Text)
                        + '~' + Trim(edSecurityNo.Text);

                        thUserField3 := GetDateString(edStartDate.Text)
                        + '~' + GetDateString(edExpiryDate.Text)
                        + '~' + IntToStr(cmbCardType.ItemIndex);

                        thUserField4 := Trim(edAddress1.Text)
                        + '~' + Trim(edPostcode.Text);

                        iStatus := Save(FALSE);

                        if iStatus = 0 then
                        begin
                          AddNote(oToolkit.Transaction, EventData.UserName, TimeToScreenTime(Time)
                          + ' ' + sSRC + ' ' + sAuthorisationCode + ' : ' + MoneyToStr(rAmount));
                        end else
                        begin
                          MsgBox('The transaction (' + EventData.Transaction.thOurRef
                          + ') could not be saved.'#13#13 + 'Error : ' + IntToStr(iStatus)
                          , mtError, [mbOK], mbOK, 'oToolkit.Transaction.Update.Save');
                        end;{if}
                      end;{with}
                    end else
                    begin
                      MsgBox('The transaction (' + EventData.Transaction.thOurRef
                      + ') could not be updated.', mtError, [mbOK], mbOK
                      , 'oToolkit.Transaction.UpdateEx');
                    end;{if}
                  end else
                  begin
                    // TX not found
                    MsgBox('The transaction (' + EventData.Transaction.thOurRef
                    + ') could not be found.'#13#13 + 'Error : ' + IntToStr(iStatus)
                    , mtError, [mbOK], mbOK, 'oToolkit.Transaction.GetEqual');
                  end;{if}
                end else
                begin
                  if sNote <> '' then
                  begin
                    // Error in Authorisation
                    iStatus := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(EventData.Transaction.thOurRef));
                    if iStatus = 0 then
                    begin
                      // Ad Note
                      AddNote(oToolkit.Transaction, EventData.UserName, TimeToScreenTime(Time) + ' ' + sNote);

                      // Hold Transaction
                      if iMode = AM_PAYMENT then
                      begin
                        oTXUpdate := (oToolkit.Transaction as ITransaction4).Update as ITransaction2;
                        if oTXUpdate = nil then
                        begin
                          MsgBox('The transaction (' + EventData.Transaction.thOurRef
                          + ') could not be updated.'#13#13 + 'The record may be locked by another process.'
                          , mtError, [mbOK], mbOK, 'oToolkit.Transaction.Update = nil');
                        end else
                        begin
                          oTXUpdate.thHoldFlag := GetNewHoldFlag(oTXUpdate.thHoldFlag);
                          iStatus := oTXUpdate.Save(FALSE);
                          if iStatus <> 0 then
                          begin
                            MsgBox('The transaction (' + EventData.Transaction.thOurRef
                            + ') could not be saved.'#13#13 + 'Error : ' + IntToStr(iStatus)
                            , mtError, [mbOK], mbOK, 'oToolkit.Transaction.Update.Save');
                          end;{if}
                        end;{if}
                      end;{if}
                    end;{if}
                  end;{if}
                end;{if}
              finally
                Release;
              end;{try}
            end;{with}

          end;{if}

          // Close COM Toolkit
          oToolkit.CloseToolkit;
          oToolkit := nil;
        end else
        begin
          // Transaction Locked
          MsgBox('The transaction (' + EventData.Transaction.thOurRef
          + ') could not be locked.'#13#13 + 'Another user or process must be currently updating this transaction.'
          , mtError, [mbOK], mbOK, 'Transaction Locked');
        end;{if}
      end else
      begin
        // Couldn't find transaction
        MsgBox('The transaction (' + EventData.Transaction.thOurRef
        + ') could not be found.'#13#13 + 'Error : ' + IntToStr(iStatus)
        , mtError, [mbOK], mbOK, 'oToolkit.Transaction.GetEqual');
      end;
    end else
    begin
      // Error - Cannot Continue.
      case iMode of
        AM_PAYMENT : begin
          MsgBox('The transaction that you have selected is not a Sales Order.'#13#13
          + 'You can only authorise payments for Sales Orders.', mtwarning, [mbOK]
          , mbOK, 'Transaction Type');
        end;

        AM_UPFRONT : begin
          if EventData.Transaction.thInvDocHed = cuSOR then
          begin
            MsgBox('The transaction that you have selected has picked lines.'#13#13
            + 'You can only input the card details for Sales Orders without picked lines.'
            , mtwarning, [mbOK], mbOK, 'Picked Lines');
          end else
          begin
            MsgBox('The transaction that you have selected is not a Sales Order.'#13#13
            + 'You can only input the card details for Sales Orders.', mtwarning, [mbOK]
            , mbOK, 'Transaction Type');
          end;{if}
        end;

        AM_REFUND : begin
          MsgBox('The transaction that you have selected is not a Sales Invoice.'#13#13
          + 'You can only refund Sales Invoices.', mtwarning, [mbOK]
          , mbOK, 'Transaction Type');
        end;
      end;{case}
    end;{if}
  end;{Authorise}

Begin
  if bHookEnabled then
  begin
    { Handle Hook Events here }
    With EventData Do Begin
      // A 'Hook Event' has occurred
      Case WinId Of
        wiTransaction : begin
          case HandlerId of
            SOR_CUSTOM_BUTTON_1 : begin
              // Authorise
              Authorise(AM_PAYMENT);
            end;

            SOR_CUSTOM_BUTTON_2 : begin
              // Upfront
              Authorise(AM_UPFRONT);
            end;
          end;{case}
        end;

        wiAccount : begin
          if HandlerID = iCustomerLedgerBtnId then
          begin
            // Refund
            Authorise(AM_REFUND);
          end;{if}
        end;
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.



