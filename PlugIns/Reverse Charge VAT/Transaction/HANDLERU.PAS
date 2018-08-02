unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  ActiveX, Math, ComObj, APIUtil, CustWinU, CustAbsU, Classes, Controls, PISecure
  , MathUtil, Types, Enterprise01_TLB, MiscUtil, {TransBD} EnterpriseBeta_TLB;

const
  TX_VALIDATION = 82;
  BEFORE_STORE_TX = 1;
  AFTER_STORE_TX = 170;

  sPlugInName = 'Reverse Charge VAT Transaction Plug-In';
  {$IFDEF EX600}
    sVersionNo = '007';
  {$ELSE}
    sVersionNo = 'v5.71.006';
  {$ENDIF}

var
//  iHookId : integer;
  {bIgnoreValidation, }bFirstPIInChain, bHookEnabled : boolean;
//  slTXCache : TStringList;

type
  TTXInfoRec = record
    ContractRef  : string;
    Remove : boolean;
  end;

  TTXInfo = Class
    TXInfoRec : TTXInfoRec;
  end;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  RVProc, SecCodes, StrUtil, Dialogs, SysUtils, ChainU, PIMisc, Forms, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

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
  bHookEnabled := PICheckSecurity(sSystemCode, sSecurityCode, sGlobalBespokeName
  , '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    With TAbsCustomHandlers01(CustomHandlers) Do Begin
      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);

      bFirstPIInChain := not HookPointEnabled(wiTransLine, TX_VALIDATION);

      // Exit Account Code on TX Header
      aHookPoints[1].WindowID := wiTransaction;
      aHookPoints[1].HandlerID := TX_VALIDATION;

      // Before Transaction Save
//      aHookPoints[2].WindowID := wiTransaction;
//      aHookPoints[2].HandlerID := AFTER_STORE_TX;

      // Before Transaction Save
      aHookPoints[2].WindowID := wiTransaction;
      aHookPoints[2].HandlerID := BEFORE_STORE_TX;

      // After Transaction Save
      aHookPoints[3].WindowID := wiTransaction;
      aHookPoints[3].HandlerID := AFTER_STORE_TX;

      // Enable Hooks
      For iHook := 1 to NO_OF_HOOK_POINTS do begin
        SetHandlerStatus(aHookPoints[iHook].WindowID, aHookPoints[iHook].HandlerID, EventEnabled);
      end;{for}

      slAboutText.Free;
    End; { With }
  end;{if}

  oToolkit := nil;

//  bIgnoreValidation := FALSE;

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
var
  bCallNextPlugin : boolean;
  Parameters : TParameters;

  procedure StartToolkit(sDataPath : string);
  var
    a, b, c : LongInt;
    FuncRes : integer;

  begin{StartToolkit}
    if oToolkit = nil then
    begin
      // Create COM Toolkit object
      CoInitialize(nil);
      oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

      // Check it created OK
      If Assigned(oToolkit) Then Begin
        With oToolkit Do Begin
          EncodeOpCode(97, a, b, c);
          oToolkit.Configuration.SetDebugMode(a, b, c);

  //        oToolkit.Configuration.OverwriteTransactionNumbers := TRUE;
  //        oToolkit.Configuration.AutoSetTransCurrencyRates := FALSE;

          // Open Default Company
          oToolkit.Configuration.DataDirectory := sDataPath;
          FuncRes := OpenToolkit;

          // Check it opened OK
          If (FuncRes = 0) then {DoUpdates}
          else begin
            // Error opening Toolkit - display error
            ShowMessage('The following error occurred opening the Toolkit:-'#13#13
            + QuotedStr(oToolkit.LastErrorString));
          end;{if}

        End; { With OToolkit }

      End { If Assigned(oToolkit) }
      Else
        // Failed to create COM Object
        ShowMessage ('Cannot create COM Toolkit instance');
    end;{if}
  end;{StartToolkit}

  function GetReverseTotal(Transaction : TAbsInvoice) : real;
  var
    iLine : integer;
    rTotal : real;
  begin{GetReverseTotal}
    rTotal := 0;
    with Transaction do begin
      for iLine := 1 to thLines.thLineCount do
      begin
        if ProductIsReverseVAT(Trim(thLines.thLine[iLine].tlStockCode), Parameters) then
        begin
{          rTotal := rTotal +  oToolkit.Functions.entConvertAmount(thLines.thLine[iLine].entInvLTotal(TRUE
          , thDiscSetl), thCurrency, 1, oToolkit.SystemSetup.ssCurrencyRateType);}

          // Add up new total
          if ((Transaction.thInvDocHed = cuSRI) and (thLines.thLine[iLine].tlPayStatus = 'Y'))
          or ((Transaction.thInvDocHed = cuPPI) and (thLines.thLine[iLine].tlPayStatus = 'N')) then
          begin
            // payment line - so ignore
          end else
          begin
            // increment total
            rTotal := rTotal +  oToolkit.Functions.entConvertAmountWithRates(thLines.thLine[iLine].entInvLTotal(TRUE
            , thDiscSetl), TRUE, thCurrency, transaction.thCompanyRate, transaction.thDailyRate);
          end;
        end;
      end;{for}
    end;{with}

    Result := rTotal;

  end;{GetReverseTotal}

  function UpdateAllReverseLines(Transaction : TAbsInvoice) : real;
  var
    iLine : integer;
    rTotal : real;
  begin{UpdateAllReverseLines}
    rTotal := 0;
    with Transaction do begin
      for iLine := 1 to thLines.thLineCount do
      begin
        if ProductIsReverseVAT(Trim(thLines.thLine[iLine].tlStockCode), Parameters) then
        begin
          Transaction.thLines.thLine[iLine].tlVATCode := Parameters.sVATReturn[1];
          Transaction.thLines.thLine[iLine].Save;
        end;{if}

        // Add up new total
        if ((Transaction.thInvDocHed = cuSRI) and (thLines.thLine[iLine].tlPayStatus = 'N'))
        or ((Transaction.thInvDocHed = cuPPI) and (thLines.thLine[iLine].tlPayStatus = 'Y')) then
        begin
          rTotal := rTotal +  oToolkit.Functions.entConvertAmountWithRates(thLines.thLine[iLine].entInvLTotal(TRUE
          , thDiscSetl) + thLines.thLine[iLine].tlVATAmount, TRUE, thCurrency, transaction.thCompanyRate, transaction.thDailyRate);
        end;
      end;{for}
    end;{with}
    Result := rTotal;
  end;{UpdateAllReverseLines}

  function RetailCustomer(Customer : TAbsCustomer) : boolean;
  begin{RetailCustomer}
    Result := FALSE;
    case Parameters.CustomerMode of
      cmAccType : begin
        Result := Trim(UpperCase(Customer.acAccType)) = Trim(UpperCase(Parameters.sAccType));
      end;

      cmUDF : begin
        case Parameters.iCustUDF of
          1 : Result := Trim(UpperCase(Customer.acUserDef1)) = Trim(UpperCase(Parameters.sCustUDFValue));
          2 : Result := Trim(UpperCase(Customer.acUserDef2)) = Trim(UpperCase(Parameters.sCustUDFValue));
          3 : Result := Trim(UpperCase(Customer.acUserDef3)) = Trim(UpperCase(Parameters.sCustUDFValue));
          4 : Result := Trim(UpperCase(Customer.acUserDef4)) = Trim(UpperCase(Parameters.sCustUDFValue));
        end;{case}
      end;
    end;{case}
  end;{RetailCustomer}

type
  TValidationMode = (vmNone, vmSales, vmPurchase);
const
  SalesTXs = [CUSIN,CUSCR,CUSJI,CUSJC,CUSRF,CUSRI];
  PurchaseTXs = [CUPIN,CUPCR,CUPJI,CUPJC,CUPRF,CUPPI];
  NoteText = 'UK Customer to pay Output Tax to HMRC of £';
  NoteLength = 42;
var
  ValidationMode : TValidationMode;
  sMessage, sVATReg : string;
  rNewTotal, rOrigTotal, rReverseTotal : real;

{  procedure AddNewPaymentLine(Transaction : TAbsInvoice; rPayment : real);
  begin {AddNewPaymentLine}
{    if not ZeroFloat(rPayment) then
    begin
      Transaction.thLines.AddNewLine;
      Transaction.thLines.thCurrentLine.tlp;
    end;{if}
{  end; {AddNewPaymentLine}

  function FindNote : boolean;
  var
    iStatus : integer;
  begin {FindNote}
    Result := FALSE;
    with oToolkit.Transaction do
    begin
      thNotes.ntType := ntTypeGeneral;
      with thNotes do begin
        iStatus := oToolkit.Transaction.thNotes.GetFirst;

        while iStatus = 0 do begin
          if Copy(oToolkit.Transaction.thNotes.ntText,1,NoteLength) = NoteText then
          begin
            Result := TRUE;
            exit;
          end;
          iStatus := oToolkit.Transaction.thNotes.GetNext
        end;{while}

      end;{with}
    end;{with}
  end;{FindNote}

  procedure EditNote(sText : string);
  var
    iLine, iStatus : integer;
    oUpdateNote : INotes;
  begin {EditNote}
    oUpdateNote := oToolkit.Transaction.thNotes.Update;
    if oUpdateNote = nil then
    begin
      ShowMessage('Could not Update note.'#13#13'oUpdateNote = nil');
    end else
    begin
      with oUpdateNote do
      begin
        ntOperator := EventData.UserName;
        ntText := sText;
        iStatus := Save;
        if iStatus <> 0
        then ShowMessage('Could not Update note.'#13#13'Error No : ' + IntToStr(iStatus));
      end;{with}
    end;{if}
  end;{EditNote}

  procedure AddNote(sText : string);
  var
    iNewLineNo, iStatus : integer;
  begin {AddNote}
    with oToolkit.Transaction do
    begin
      thNotes.ntType := ntTypeGeneral;

      if thNotes.GetLast = 0 then iNewLineNo := thNotes.ntlineNo + 1
      else iNewLineNo := 1;

      with thNotes.add do
      begin
        ntOperator := EventData.UserName;
        ntLineNo := iNewLineNo;
        ntText := sText;
        iStatus := Save;
        if iStatus <> 0
        then ShowMessage('Could not Add note.'#13#13'Error No : ' + IntToStr(iStatus));
      end;{with}
    end;{with}
  end;{AddNote}

Begin
  bCallNextPlugin := TRUE;
//  oTransUpdate := nil;

  if bHookEnabled then begin
    { Handle Hook Events here }
    With EventData Do Begin
      // A 'Hook Event' has occurred
      Case WinId Of

        // Transaction hook points
        wiTransaction : begin
          case HandlerId of
{            AFTER_STORE_TX : begin
              bIgnoreValidation := FALSE;
            end;}

            TX_VALIDATION : begin
              // Do this because EL should have defaulted it to true, but didn't
              if bFirstPIInChain then BoResult := True;

              if {(not bIgnoreValidation) and} (BoResult = True) then // as long as no other plug-ins have set this to false then continue
              begin
                CompanyRec.Path := Trim(EventData.Setup.ssDataPath);
                Parameters := GetParameters(CompanyRec.Path);

                // Do we need to validate this transaction ?
                ValidationMode := vmNone;
                if (Transaction.thInvDocHed in SalesTXs) or (Transaction.thInvDocHed = CUSOR)
                then ValidationMode := vmSales;
                if Transaction.thInvDocHed in PurchaseTXs then ValidationMode := vmPurchase;

                if ValidationMode in [vmSales, vmPurchase] then
                begin
                  if ValidationMode = vmSales then sVATReg := EventData.Customer.acVATRegNo
                  else sVATReg := EventData.Supplier.acVATRegNo;

                  StartToolkit(Trim(EventData.Setup.ssDataPath));

                  rReverseTotal := GetReverseTotal(EventData.Transaction);

                  if rReverseTotal >= Parameters.iValue then
                  begin
                    sMessage := '';
                    if ValidationMode = vmSales then
                    begin
                      if (Trim(EventData.Customer.acVATRegNo) = '') and (not RetailCustomer(EventData.Customer))
                      then sMessage := 'Customer VAT Registration Code must exist before storing transaction.'
                    end else
                    begin
                      if (Trim(EventData.Supplier.acVATRegNo) = '')
                      then sMessage := 'Supplier VAT Registration Code must exist before storing transaction.';
                    end;{if}

                    if sMessage <> '' then
                    begin
                      // Warning - cannot continue
                      MsgBox(sMessage, mtWarning, [mbOK], mbOK, sPlugInName);
                      EventData.BoResult := FALSE;
                      bCallNextPlugin := FALSE;
                    end;{if}
                  end;{if}

                  oToolkit.CloseToolkit;
                  oToolkit := nil;
                end;{if}


{                if (ShowModal <> mrOK) then
                begin
                  EventData.BoResult := FALSE;
                  bCallNextPlugin := FALSE;
                end;{if}
              end;{if}
            end;

            AFTER_STORE_TX : begin
              if Transaction.thInvDocHed = cuSIN then
              begin
                StartToolkit(Trim(EventData.Setup.ssDataPath));

                CompanyRec.Path := Trim(EventData.Setup.ssDataPath);
                Parameters := GetParameters(CompanyRec.Path);

                oToolkit.Transaction.Index := thIdxOurRef;
                if oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex
                (EventData.Transaction.thOurRef)) = 0 then
                begin

                  rReverseTotal := GetReverseTotal(EventData.Transaction);

                  if rReverseTotal >= Parameters.iValue then
                  begin
                    rReverseTotal  := rReverseTotal * oToolkit.SystemSetup.ssVATRates['S'].svRate;

                    // Add/Edit Note
                    if FindNote
                    then EditNote(NoteText + MoneyToStr(rReverseTotal))
                    else AddNote(NoteText + MoneyToStr(rReverseTotal));
                  end;{if}

                end else
                begin
                  ShowMessage('Could not find transaction : ' + EventData.Transaction.thOurRef);
                end;{if}

                oToolkit.CloseToolkit;
                oToolkit := nil;
              end;{if}
            end;

            BEFORE_STORE_TX : begin
//              bIgnoreValidation := TRUE;
              // VAT Code Adjustment

              CompanyRec.Path := Trim(EventData.Setup.ssDataPath);
              Parameters := GetParameters(CompanyRec.Path);

              // Do we need to validate this transaction ?
              ValidationMode := vmNone;
              if Transaction.thInvDocHed in SalesTXs then ValidationMode := vmSales;
              if Transaction.thInvDocHed in PurchaseTXs then ValidationMode := vmPurchase;

              if ValidationMode in [vmSales, vmPurchase] then
              begin
                if (ValidationMode = vmSales) and RetailCustomer(EventData.Customer) then
                begin
                  // No Updates Necessary
                end else
                begin
                  StartToolkit(Trim(EventData.Setup.ssDataPath));

                  rOrigTotal := EventData.Transaction.thInvNetVal + EventData.Transaction.thInvVat;
                  rReverseTotal := GetReverseTotal(EventData.Transaction);

                  if rReverseTotal >= Parameters.iValue then
                  begin
                    rNewTotal := UpdateAllReverseLines(EventData.Transaction);

                    if (EventData.Transaction.thInvDocHed in  [cuSRI, cuPPI]) and not ZeroFloat(rNewTotal - rOrigTotal) then
                    begin
                      // Add New Payment Line
  //                    AddNewPaymentLine(EventData.Transaction, rNewTotal - rOrigTotal);
                      MsgBox('The De Minimus value has been exceeded on this transaction'
                      , mtWarning, [mbOK], mbOK, sPlugInName);
                    end;{if}


                  end;{if}

                  oToolkit.CloseToolkit;
                  oToolkit := nil;
                end;{if}
              end;{if}
            end;
          end;{case}
        end;
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  if bCallNextPlugin then DLLChain.ExecCustomHandler(EventData);
End;

end.
