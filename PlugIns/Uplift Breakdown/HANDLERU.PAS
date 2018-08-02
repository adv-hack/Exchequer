unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  Math, ComObj, APIUtil, CustWinU, CustAbsU, Classes, Controls, PISecure
  , MathUtil, Types, Enterprise01_TLB, MiscUtil, IniFiles, P2UpliftPROC;

const
  SOR_ADD_BUTTON = 14;
  SOR_EDIT_BUTTON = 24;
//  CUST_ADD_BUTTON = 11;
  TS_VALIDATE_ACC_CODE = 109;
  CONVERT_TO_SDN = 103;
  SAVE_TRANSACTION = 1;
  sPlugInName = 'Uplift Breakdown Plug-In';
  {$IFDEF EX600}
    sVersionNo = '011';
  {$ELSE}
    sVersionNo = 'v5.71.010';
  {$ENDIF}
  sINIFileName = 'P2UlftPI.INI';

type
  TPINInfo = class
    Value : real;
    Currency : byte;
  end;

var
  iPurchaseDaybookBtnId : byte = 0;
  iPORDaybookBtnId : byte = 0;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Progress, FreightCosts, TKUtil, StrUtil, Dialogs, SysUtils, ChainU, PIMisc
  , Forms, ETMiscU, ExchequerRelease;

{FUNCTION EX_UpdatePrintedStatus(DOCREFNO : PCHAR; NEWSTATUS : WordBool) :  SMALLINT
; STDCALL EXTERNAL 'ENTDLL32.DLL' Index 185;}

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
  NO_OF_HOOK_POINTS = 1;
var
  iEID : byte;
  iHook, iPos : integer;
  slAboutText : TStringList;
  aHookPoints : array [1..NO_OF_HOOK_POINTS] of THookPointRec;
begin
  CustomOn := True;

  //Check Plug-In Security
  bHookEnabled := PICheckSecurity('EXCHP2ULPI000036', '=6-_£%^2^f^%AA2D', sPlugInName
  , '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    With TAbsCustomHandlers01(CustomHandlers) Do Begin
      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);

      // Custom Button  POR DayBook - Freight
      aHookPoints[1].WindowID := wiTransaction;
      aHookPoints[1].HandlerID := CONVERT_TO_SDN;

      // Enable Hooks
      For iHook := 1 to NO_OF_HOOK_POINTS do
      begin
        if aHookPoints[iHook].HandlerID > 0
        then SetHandlerStatus(aHookPoints[iHook].WindowID, aHookPoints[iHook].HandlerID
        , EventEnabled);
      end;{for}

      slAboutText.Free;
    End; { With }
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
  End; { If Assigned(oToolkit) }

  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  iStatus, iPos : integer;
  sError, sContRef : string;
  slPINs : TStringList;

  Procedure ProcessPINs;
  var
    Totals : array [GL_COMMISSION..GL_ROUNDING] of Real;

    function PINApportioned : boolean;
    begin{PINApportioned}
      Result := TRUE;
      oToolkit.Transaction.thNotes.ntType := ntTypeGeneral;
      if oToolkit.Transaction.thNotes.GetEqual(oToolkit.Transaction.thNotes.BuildIndex(1)) = 0
      then begin
        if Pos(aNotes[1], oToolkit.Transaction.thNotes.ntText) = 1 then
        begin
          // PIN is apportionable (if that's a word !)
          // Has it already been apportioned ?
          if oToolkit.Transaction.thNotes.GetEqual(oToolkit.Transaction.thNotes.BuildIndex(6)) = 0
          then Result := Pos(sApportioned, oToolkit.Transaction.thNotes.ntText) = 1
          else Result := FALSE;
        end;{if}
      end;{if}
    end;{PINApportioned}

    procedure EditNote;
    var
      iLine, iStatus : integer;
      oUpdateNote : INotes;
    begin {EditNote}
      oUpdateNote := oToolkit.Transaction.thNotes.Update;
      with oUpdateNote do begin
        ntOperator := EventData.UserName;
        ntLineNo := 6;
        ntText := sApportioned;
        iStatus := Save;
        if iStatus <> 0
        then ShowMessage('Could not Update note.'#13#13'Error No : ' + IntToStr(iStatus));
      end;{with}
    end;{EditNote}

    procedure AddNote;
    var
      iLine, iStatus : integer;
    begin {AddNote}
      with oToolkit.Transaction do
      begin
        thNotes.ntType := ntTypeGeneral;
        with thNotes.add do begin
          ntOperator := EventData.UserName;
          ntLineNo := 6;
          ntText := sApportioned;
          iStatus := Save;
          if iStatus <> 0
          then ShowMessage('Could not Add note.'#13#13'Error No : ' + IntToStr(iStatus));
        end;{with}
      end;{with}
    end;{AddNote}

    function GetValueFromNote(iNoteLine : integer) : real;
    var
      iPos : integer;
    begin{GetValueFromNote}
      Result := 0;
      with oToolkit.Transaction do
      begin
        if thNotes.GetEqual(thNotes.BuildIndex(iNoteLine)) = 0
        then begin
          iPos := Pos(aNotes[iNoteLine], oToolkit.Transaction.thNotes.ntText);
          if iPos = 1 then
          begin
            iPos := Length(aNotes[iNoteLine]) + 1;
            Result := StrToFloatDef(Copy(oToolkit.Transaction.thNotes.ntText, iPos, 255),0);
          end;{if}
        end;{if}
      end;{with}
    end;{GetValueFromNote}

    function CreateNOM : boolean;
    var
      oNOM : ITransaction;
      oNOMLine : ITransactionLine;

      Procedure MatchNOM2PINs;
      var
        iPos : integer;
      begin{MatchNOM2PINs}
        for iPos := 0 to slPINs.Count -1 do
        begin
          with (oToolkit.Transaction.thMatching as IMatching2).AddCustom(maTypeUser1) do begin

            maPayRef := slPINs[iPos];
            maDocRef := oNOM.thOurRef;

            // matching value
            maBaseValue := TPINInfo(slPINs.Objects[iPos]).Value;  // base currency
            maPayCurrency := TPINInfo(slPINs.Objects[iPos]).Currency; // TX Ccy
            maPayValue := oToolkit.Functions.entConvertAmount(TPINInfo(slPINs.Objects[iPos]).Value
            , 1, TPINInfo(slPINs.Objects[iPos]).Currency, oToolkit.SystemSetup.ssCurrencyRateType); // Value in TX Ccy
            maDocCurrency := 1; // NOM Ccy (Base)
            maDocValue := TPINInfo(slPINs.Objects[iPos]).Value;  // NOM Value in NOM CCy (Base)

            iStatus := Save;
            if iStatus <> 0 then MsgBox('Matching Error : ' + IntToStr(iStatus)
            + #13#13 + oToolkit.LastErrorString , mtError, [mbOK], mbOK, 'Matching Error');
          end;{with}
        end;{for}
      end;{MatchNOM2PINs}

      procedure PopulateLine(oLine : ITransactionLine);
      begin{PopulateLine}
        oLine.ImportDefaults;
        oLine.tlCostCentre := SetupRec.sCostCentre;
        oLine.tlDepartment := SetupRec.sDepartment;
        oLine.tlDailyRate := 1;
        oLine.tlCompanyRate := 1;
      end;{PopulateLine}

    var
      iStatus, iPos : integer;
      rRoundingAdjustment : real;
    begin{CreateNOM}

      // Initialise
      rRoundingAdjustment := 0;
      oNOM := oToolkit.Transaction.Add(dtNMT);
      oNOM.ImportDefaults;
      oNOM.thCurrency := 1;  // base currency
      oNOM.thLongYourRef := 'Uplift Breakdown';

      // Add Credit Lines
      For iPos := GL_COMMISSION to GL_PROCESSING do
      begin
        oNOMLine := oNOM.thLines.Add;
        PopulateLine(oNOMLine);
        oNOMLine.tlDescr := 'Uplift Adjustment for ' + aDescs[iPos];
        oNOMLine.tlGLCode := SetupRec.GLCodes[iPos];
        oNOMLine.tlNetValue := - (Round_Up(Totals[iPos],2)); // NF: 01/02/06 for .006
        oNOMLine.Save;
        rRoundingAdjustment := rRoundingAdjustment + oNOMLine.tlNetValue; // NF: 01/02/06 for .006
        oNOMLine := nil;
      end;{for}

      // Add Debit Line for Uplift Control Account
      oNOMLine := oNOM.thLines.Add;
      PopulateLine(oNOMLine);
      oNOMLine.tlDescr := 'Freight Uplift Control Adjustment';
      oNOMLine.tlGLCode := oToolkit.SystemSetup.ssGLCtrlCodes[ssGLFreightUplift];
      oNOMLine.tlNetValue := Round_Up(Totals[GL_ROUNDING],2);  // NF: 01/02/06 for .006
      oNOMLine.Save;
      oNOMLine := nil;

      // Add Rounding Adjustment Line
      rRoundingAdjustment := rRoundingAdjustment + Totals[GL_ROUNDING]; // NF: 01/02/06 for .006

      if (not ZeroFloat(rRoundingAdjustment)) then
      begin
        oNOMLine := oNOM.thLines.Add;
        PopulateLine(oNOMLine);
        oNOMLine.tlDescr := 'Rounding Adjustment';
        oNOMLine.tlGLCode := SetupRec.GLCodes[GL_ROUNDING];
        oNOMLine.tlNetValue := - Round_Up(rRoundingAdjustment, 2);  // NF: 01/02/06 for .006
        oNOMLine.Save;
        oNOMLine := nil;
      end;

      // Save NOM
      iStatus := oNOM.Save(TRUE);
      if iStatus = 0 then
      begin
        // Create Matching
        MatchNOM2PINs;
      end else
      begin
        MsgBox('Error occurred when saving NOM : Error ' + IntToStr(iStatus)
        , mtError, [mbOK], mbOK, 'oNOM.Save');
      end;{if}

      oNOM := nil;

    end;{CreateNOM}

  var
    rTXUplift : real;
    iNoOfPINsProcessed, iLine, iPos, iStatus : integer;
    sInvoicesDir : string;
    bCreateNOM : boolean;
    PINInfo : TPINInfo;
  begin{ProcessPINs}

    // initialise
    iNoOfPINsProcessed := 0;
    CompanyRec.Path := EventData.Setup.ssDataPath;
    For iPos := GL_COMMISSION to GL_ROUNDING do Totals[iPos] := 0;
    slPINs := TStringList.Create;

    FrmProgress := TFrmProgress.Create(application);
    FrmProgress.Show;

    with oToolkit, Transaction do
    begin
      // Go through all unposted Purchase transactions
      Index := thIdxRunNo;
      iStatus := GetGreaterThan(BuildRunNoIndex(0,'P'));
      While (iStatus = 0) and (thRunNo = 0) and (thOurRef[1] = 'P') do
      begin

        FrmProgress.UpdateStatus(thOurRef);

        if (thDocType = dtPIN) and (not PINApportioned) then
        begin
          // Get Totals
          For iPos := GL_COMMISSION to GL_PROCESSING do
          begin
            Totals[iPos] := Totals[iPos] + Functions.entConvertAmount(GetValueFromNote(iPos)
            ,thCurrency, 1, oToolkit.SystemSetup.ssCurrencyRateType);
          end;

          // Add up real total - so we can work out any rounding errors
          rTXUplift := 0;
          For iLine := 1 to thLines.thLineCount do
          begin
            rTXUplift := rTXUplift + Functions.entConvertAmount((thLines[iLine].tlCost
            * thLines[iLine].tlQty), thCurrency, 1, oToolkit.SystemSetup.ssCurrencyRateType);
          end;{for}
          Totals[GL_ROUNDING] := Totals[GL_ROUNDING] + rTXUplift;

          // Add Note
          if thNotes.GetEqual(thNotes.BuildIndex(6)) = 0
          then EditNote
          else AddNote;

          PINInfo := TPINInfo.Create;
          PINInfo.Value := rTXUplift;
          PINInfo.Currency := thCurrency;
          slPINs.AddObject(thOurRef, PINInfo);

          inc(iNoOfPINsProcessed);
        end;{if}
        iStatus := GetNext;
      end;{while}
    end;{with}

    // Do we need to create NOM ?
    FrmProgress.UpdateStatus('Creating NOM');
    bCreateNOM := FALSE;
    For iPos := GL_COMMISSION to GL_PROCESSING do
    begin
      if Totals[iPos] > 0 then
      begin
        bCreateNOM := TRUE;
        break;
      end;
    end;{for}

    if bCreateNOM then CreateNOM;

    ClearList(slPINs);
    slPINs.Free;

    FrmProgress.Hide;
    FrmProgress.Release;

    MsgBox('Uplift apportionment of PINs completed.'#13#13'Number of PINs Processed : '
    + IntToStr(iNoOfPINsProcessed), mtInformation, [mbOK], mbOK, 'Process Complete');
  end;{ProcessPINs}

  function GetIniSettings : boolean;
  var
    TheInifile : TInifile;
    iPos : integer;
  begin{GetIniSettings}
    Result := TRUE;
//    TheInifile := TInifile.Create(ExtractFilePath(Application.Exename) + sInifileName);
    TheInifile := TInifile.Create(IncludeTrailingPathDelimiter(EventData.Setup.ssDataPath)
    + sInifileName);
    with SetupRec do begin
      GLCodes[GL_COMMISSION] := TheInifile.ReadInteger('Settings','CommissionGL',0);
      GLCodes[GL_IMPORTDUTY] := TheInifile.ReadInteger('Settings','ImportDutyGL',0);
      GLCodes[GL_FREIGHT] := TheInifile.ReadInteger('Settings','FreightGL',0);
      GLCodes[GL_TICKETING] := TheInifile.ReadInteger('Settings','TicketingGL',0);
      GLCodes[GL_PROCESSING] := TheInifile.ReadInteger('Settings','ProcessingGL',0);
      GLCodes[GL_ROUNDING] := TheInifile.ReadInteger('Settings','RoundingGL',0);
      sCostCentre  := TheInifile.ReadString('Settings','CostCentre','');
      sDepartment := TheInifile.ReadString('Settings','Department','');

      with oToolkit do
      begin

        // Check GL Codes
        oToolkit.GeneralLedger.Index := glIdxCode;
        For iPos := GL_FIRSTCODE to GL_LASTCODE do
        begin
          if GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(GLCodes[iPos])) <> 0
          then begin
            Result := FALSE;
            break;
          end;
        end;{for}

        // Check CostCentre
        oToolkit.CostCentre.Index := cdIdxCode;
        if oToolkit.CostCentre.GetEqual(oToolkit.CostCentre.BuildCodeIndex(sCostCentre)) <> 0
        then Result := FALSE;

        // Check Department
        oToolkit.Department.Index := cdIdxCode;
        if oToolkit.Department.GetEqual(oToolkit.Department.BuildCodeIndex(sDepartment)) <> 0
        then Result := FALSE;
      end;{with}
      TheInifile.Free;
    end;{with}
  end;{GetIniSettings}

  function TXHasBeenReceived : boolean;
  var
    iPos : integer;
  begin{TXHasBeenReceived}
    Result := FALSE;
    For iPos := 1 to EventData.Transaction.thLines.thLineCount do
    begin
      if EventData.Transaction.thLines.thLine[iPos].tlQtyPicked > 0 then
      begin
        Result := TRUE;
        break;
      end;{if}
    end;{for}
  end;{TXHasBeenReceived}


Begin
  if bHookEnabled then begin

    { Handle Hook Events here }
    With EventData Do Begin
      // A 'Hook Event' has occurred
      Case WinId Of
        wiTransaction : begin
          // Custom Button Sales Order DayBook
          if HandlerId = iPurchaseDaybookBtnId then
          begin
            // Uplift button pressed
              StartToolkit(EventData);

              // Check if the IniFile has sensible settings in it
              if GetIniSettings then
              begin
                ProcessPins;
              end else
              begin
                MsgBox('The settings in ' + sINIFileName + ' have not been setup correctly.'#13#13
                + 'You must configure this correctly before you can continue.', mtError
                , [mbOK], mbOK, 'INI file setup');
              end;{if}

              oToolkit.CloseToolkit;
              oToolkit := nil;
          end else
          begin
            if HandlerId = iPORDaybookBtnId then
            begin
              // Freight button pressed

              // Check TX Type
              if EventData.Transaction.thInvDocHed = cuPOR then
              begin

                StartToolkit(EventData);

                // Check if the IniFile has sensible settings in it
                if GetIniSettings then
                begin

                  if TXHasBeenReceived then
                  begin
                    with TfrmFreightCosts.Create(application) do
                    begin
                      iDefaultCcy := EventData.Transaction.thCurrency;
//                      oTransaction := EventData.Transaction;
                      oEventData := EventData;
                      GetTotalReceivedTotals(rTotReceived, rTotReceivedValue);
                      Caption := 'Freight Costs for ' + EventData.Transaction.thOurRef;
                      ShowModal;
                      Release;
                    end;{with}
                  end else
                  begin
                    MsgBox('This transaction does not have any lines with a received quanity.'#13#13
                    + 'You must receive this order before you can continue.', mtError
                    , [mbOK], mbOK, 'Received Quantity');
                  end;{if}
                end else
                begin
                  MsgBox('The settings in ' + sINIFileName + ' have not been setup correctly.'#13#13
                  + 'You must configure this correctly before you can continue.', mtError
                  , [mbOK], mbOK, 'INI file setup');
                end;{if}

                oToolkit.CloseToolkit;
                oToolkit := nil;
              end else
              begin
                MsgBox('This Transaction is not a Purchase Order.'#13#13
                + 'You can only breakdown the freight costs on PORs.', mtInformation
                , [mbOK], mbOK, 'Transaction Type');
              end;{if}
            end;{if}
          end;{if}
        end;

{        wiAccount : begin
          case HandlerId of
          end;{case}
//        end;
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.



