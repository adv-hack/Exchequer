unit HandlerU;

{ Hook Customisation Unit -  standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  Math, ComObj, APIUtil, CustWinU, CustAbsU, Classes, Controls, PISecure
  , StdCtrls, MathUtil, Types, Enterprise01_TLB, MiscUtil, IniFiles
  , PSUpliftPROC, Forms, Menus, Windows;

var
  oToolkit : IToolkit;
  CompanyRec : TCompanyRec;

const
  SOR_ADD_BUTTON = 14;
  SOR_EDIT_BUTTON = 24;
  TS_VALIDATE_ACC_CODE = 109;
  CONVERT_TO_SDN = 103;
  SAVE_TRANSACTION = 1;
  sPlugInName = 'Advanced Purchase Freight Uplift Plug-In';
  {$IFDEF EX600}
    sVersionNo = '210';
  {$ELSE}
    sVersionNo = 'v5.71.209';
  {$ENDIF}

type
  TPINInfo = class
    Value : real;
    Currency : byte;
  end;

  TFormTrap = class(TObject)
  private
    FOriginalActivateEvent: TNotifyEvent;
    FPPost2, FPPost1, FSPost2, FSPost1 : TMenuItem;
    FPPopupMenu1, FSPopupMenu1 : TPopupMenu;
    OriginalPDBFormDestroy, OriginalPPopupMenu1Popup, OriginalPPost1Click, OriginalPPost2Click : TNotifyEvent;
    OriginalSDBFormDestroy, OriginalSPopupMenu1Popup, OriginalSPost1Click, OriginalSPost2Click : TNotifyEvent;
    PDaybookForm, SDaybookForm : TForm;
    bDoStuff : boolean;
    iPurchaseMessageTickCount, iSalesMessageTickCount : cardinal;
    procedure ShowPostingWarning(bPurchase : boolean);
    Function FindMenuItemWithCaption(MenuItems : TMenuItem; sCaption : string) : TMenuItem;
  public
    constructor Create(sDataPath : string);
    destructor Destroy; override;
    procedure Clear(bPurchase : boolean);
    procedure OnActivateForm(Sender: TObject);
    procedure OnPPost1Click(Sender: TObject);
    procedure OnPPost2Click(Sender: TObject);
    procedure OnPPopupMenu1Popup(Sender: TObject);
    procedure PDBFormDestroy(Sender: TObject);
    procedure OnSPost1Click(Sender: TObject);
    procedure OnSPost2Click(Sender: TObject);
    procedure OnSPopupMenu1Popup(Sender: TObject);
    procedure SDBFormDestroy(Sender: TObject);
//    property OPost1: TMenuItem read FPost1;
  end;


var
  FormTrap: TFormTrap;
  iPurchaseDaybookBtnId : byte = 0;
  iPORDaybookBtnId : byte = 0;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Progress, FreightCosts, TKUtil, StrUtil, Dialogs, SysUtils, ChainU, PIMisc
  , FileUtil, ETMiscU, ExchequerRelease;

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
  NO_OF_HOOK_POINTS = 2;
var
  iEID : byte;
  iHook, iPos : integer;
  slAboutText : TStringList;
  aHookPoints : array [1..NO_OF_HOOK_POINTS] of THookPointRec;
begin
  CustomOn := True;
  FormTrap := nil;

  //Check Plug-In Security
  bHookEnabled := PICheckSecurity('EXCHPURFRE000094', 'wdf9uhdh3hrnnr£A', sPlugInName
  , '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    With TAbsCustomHandlers01(CustomHandlers) Do Begin
      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);

      // Detect if POR Daybook Custom button 1 is already in use.
      if (not HookPointEnabled(wiTransaction, 114)) then
        begin
          iPORDaybookBtnId := 114;
        end
      else begin
        // Detect if POR Daybook Custom button 2 is already in use.
        if (not HookPointEnabled(wiTransaction, 124)) then begin
          iPORDaybookBtnId := 124;
        end;{if}
      end;{if}

      // Detect if Purchase Daybook (main tab) Custom button 1 is already in use.
      if (not HookPointEnabled(wiTransaction, 110)) then
        begin
          iPurchaseDaybookBtnId := 110;
        end
      else begin
        // Detect if Sales Daybook (main tab) Custom button 2 is already in use.
        if (not HookPointEnabled(wiTransaction, 120)) then begin
          iPurchaseDaybookBtnId := 120;
        end;{if}
      end;{if}

      // Custom Button  POR DayBook - Freight
      aHookPoints[1].WindowID := wiTransaction;
      aHookPoints[1].HandlerID := iPORDaybookBtnId;

      // Custom Button  Purchase DayBook - Uplift
      aHookPoints[2].WindowID := wiTransaction;
      aHookPoints[2].HandlerID := iPurchaseDaybookBtnId;

      // Enable Hooks
      For iHook := 1 to NO_OF_HOOK_POINTS do
      begin
        if aHookPoints[iHook].HandlerID > 0
        then SetHandlerStatus(aHookPoints[iHook].WindowID, aHookPoints[iHook].HandlerID
        , EventEnabled);
      end;{for}

      slAboutText.Free;
    End; { With }

    FormTrap := TFormTrap.Create(GetEnterpriseDirectory);
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

  if Assigned(FormTrap) then FreeAndNil(FormTrap);
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
    Totals : array [GL_FIRSTCODE..GL_LASTCODE] of Real;

    function PINApportioned : boolean;
    begin{PINApportioned}
      Result := FALSE;
      oToolkit.Transaction.thNotes.ntType := ntTypeGeneral;
{      if oToolkit.Transaction.thNotes.GetEqual(oToolkit.Transaction.thNotes.BuildIndex(1)) = 0
      then begin
        if Pos(aNoteDescs[1], oToolkit.Transaction.thNotes.ntText) = 1 then
        begin}
          // PIN is apportionable (if that's a word !)
          // Has it already been apportioned ?
      iStatus := oToolkit.Transaction.thNotes.GetFirst;
      while iStatus = 0 do
      begin
        if Pos(sApportioned, oToolkit.Transaction.thNotes.ntText) = 1 then
        begin
          // Found "Apportioned" Text
          Result := TRUE;
          iStatus := -1; // exit loop
        end else
        begin
          // keep looking...
          iStatus := oToolkit.Transaction.thNotes.GetNext;
        end;{if}
      end;{while}
{        end;{if}
{      end;{if}
    end;{PINApportioned}

{    procedure EditNote;
    var
      iLine, iStatus : integer;
      oUpdateNote : INotes;
    begin {EditNote}
{      oUpdateNote := oToolkit.Transaction.thNotes.Update;
      with oUpdateNote do begin
        ntOperator := EventData.UserName;
        ntLineNo := iApportionedNoteLineNo;
        ntText := sApportioned;
        iStatus := Save;
        if iStatus <> 0
        then ShowMessage('Could not Update note.'#13#13'Error No : ' + IntToStr(iStatus));
      end;{with}
//    end;{EditNote}

    procedure AddNote;
    var
      iLine, iStatus : integer;
    begin {AddNote}
      with oToolkit.Transaction do
      begin
        thNotes.ntType := ntTypeGeneral;
        with thNotes.add do begin
          ntOperator := EventData.UserName;
          ntLineNo := iApportionedNoteLineNo;
          ntText := sApportioned;
          iStatus := Save;
          if iStatus <> 0
          then ShowMessage('Could not Add note.'#13#13'Error No : ' + IntToStr(iStatus));
        end;{with}
      end;{with}
    end;{AddNote}

    function GetTotalValueFromNote(sNoteText : string) : real;
    var
      iPos : integer;
    begin{GetTotalValueFromNote}
      Result := 0;
      with oToolkit.Transaction do
      begin

        oToolkit.Transaction.thNotes.ntType := ntTypeGeneral;
        iStatus := oToolkit.Transaction.thNotes.GetFirst;
        while iStatus = 0 do
        begin
          if Pos(sNoteText, oToolkit.Transaction.thNotes.ntText) = 1 then
          begin
            // Found Matching Note
            iPos := Length(sNoteText) + 1;
            Result := Result + StrToFloatDef(Copy(oToolkit.Transaction.thNotes.ntText, iPos, 255),0);
          end;{if}

          iStatus := oToolkit.Transaction.thNotes.GetNext;
        end;{while}


{        if thNotes.GetEqual(thNotes.BuildIndex(iNoteLine)) = 0 then
        begin
          iPos := Pos(aNoteDescs[iNoteLine], oToolkit.Transaction.thNotes.ntText);
          if iPos = 1 then
          begin
            iPos := Length(aNoteDescs[iNoteLine]) + 1;
            Result := StrToFloatDef(Copy(oToolkit.Transaction.thNotes.ntText, iPos, 255),0);
          end;{if}
//        end;{if}
      end;{with}
    end;{GetTotalValueFromNote}

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

//            maPayCurrency := TPINInfo(slPINs.Objects[iPos]).Currency; // TX Ccy
//            maPayValue := TPINInfo(slPINs.Objects[iPos]).Value; // Value in TX Ccy
//            maDocCurrency := TPINInfo(slPINs.Objects[iPos]).Currency; // NOM Ccy (Base)
//            maDocValue := TPINInfo(slPINs.Objects[iPos]).Value;  // NOM Value in NOM CCy (Base)

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
      iMultiplier, iStatus, iPos : integer;
      rRoundingAdjustment : real;
    begin{CreateNOM}

      // Initialise
      rRoundingAdjustment := 0;
      oNOM := oToolkit.Transaction.Add(dtNMT);
      oNOM.ImportDefaults;
      oNOM.thCurrency := 1;  // base currency
      oNOM.thLongYourRef := 'Uplift Breakdown';
      oNOM.thTransDate := DateToStr8(Date);

      {.206}
//      if SetupRec.bLiveStock then iMultiplier := -1
//      else iMultiplier := 1;
      iMultiplier := -1;

//    oNOM.thTransDate := ;

      // Add Credit Lines
      For iPos := GL_FIRSTCODE to GL_LASTCODEBUTONE do
      begin
        if SetupRec.CategoryUsed[iPos] then
        begin
          oNOMLine := oNOM.thLines.Add;
          PopulateLine(oNOMLine);
          oNOMLine.tlDescr := 'Uplift Adjustment for ' + SetupRec.Descriptions[iPos];
          oNOMLine.tlGLCode := SetupRec.GLCodes[iPos];
          oNOMLine.tlCurrency := 1;  // base currency

  //        oNOMLine.tlNetValue := Totals[iPos];  // NF: 01/02/06 for .006
  //        oNOMLine.tlNetValue := - (Round_Up(Totals[iPos],2)); // NF: 01/02/06 for .006
//          oNOMLine.tlNetValue := (Round_Up(Totals[iPos],2)); // NF: 02/05/07 Changed back again as requested by MR
          oNOMLine.tlNetValue := (Round_Up(Totals[iPos],2) * iMultiplier); // NF: 18/02/09 Changed to work on an ini file setting

          oNOMLine.Save;
  //        rRoundingAdjustment := rRoundingAdjustment + Totals[iPos];
          rRoundingAdjustment := rRoundingAdjustment + oNOMLine.tlNetValue; // NF: 01/02/06 for .006
          oNOMLine := nil;
        end;{if}
      end;{for}

      // Add Debit Line for Uplift Control Account
      oNOMLine := oNOM.thLines.Add;
      PopulateLine(oNOMLine);
      oNOMLine.tlDescr := 'Freight Uplift Control Adjustment';
//      oNOMLine.tlGLCode := oToolkit.SystemSetup.ssGLCtrlCodes[ssGLFreightUplift];
      oNOMLine.tlGLCode := SetupRec.iFreightUpliftGLCode;
      oNOMLine.tlCurrency := 1;  // base currency

//      oNOMLine.tlNetValue := - Totals[GL_ROUNDING];  // NF: 01/02/06 for .006
//      oNOMLine.tlNetValue := Round_Up(Totals[GL_ROUNDING],2);  // NF: 01/02/06 for .006
//      oNOMLine.tlNetValue := - Round_Up(Totals[GL_ROUNDING],2;  // NF: 02/05/07 Changed back again as requested by MR
      oNOMLine.tlNetValue := (- Round_Up(Totals[GL_ROUNDING],2)) * iMultiplier;  // NF: 18/02/09 Changed to work on an ini file setting


      // Add Rounding Adjustment Line
//      rRoundingAdjustment := rRoundingAdjustment - Totals[GL_ROUNDING]; // NF: 01/02/06 for .006
//      rRoundingAdjustment := rRoundingAdjustment + Totals[GL_ROUNDING]; // NF: 01/02/06 for .006
//      rRoundingAdjustment := rRoundingAdjustment - Totals[GL_ROUNDING]; // NF: 02/05/07 Changed back again as requested by MR
      rRoundingAdjustment := rRoundingAdjustment + oNOMLine.tlNetValue; // NF: 02/05/07 Changed back again as requested by MR

      oNOMLine.Save;
      oNOMLine := nil;

//      if (rRoundingAdjustment > 0) and (not ZeroFloat(rRoundingAdjustment)) then // NF: 01/02/06 for .006
      if (not ZeroFloat(rRoundingAdjustment)) then
      begin
        oNOMLine := oNOM.thLines.Add;
        PopulateLine(oNOMLine);
        oNOMLine.tlDescr := 'Rounding Adjustment';
        oNOMLine.tlGLCode := SetupRec.GLCodes[GL_ROUNDING];
        oNOMLine.tlCurrency := 1;  // base currency
//        oNOMLine.tlNetValue := -rRoundingAdjustment;  // NF: 01/02/06 for .006
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
    FrmProgress : TFrmProgress;
  begin{ProcessPINs}

    // initialise
    iNoOfPINsProcessed := 0;
    CompanyRec.Path := EventData.Setup.ssDataPath;
    For iPos := GL_FIRSTCODE to GL_LASTCODE do Totals[iPos] := 0;
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

        FrmProgress.UpdateLine(1, 'Processing Transactions....');
        FrmProgress.UpdateLine(2, thOurRef);

        if (thDocType = dtPIN) and (not PINApportioned) then
        begin
          // Get Totals
          For iPos := GL_FIRSTCODE to GL_LASTCODEBUTONE do
          begin
            Totals[iPos] := Totals[iPos] + Functions.entConvertAmount(GetTotalValueFromNote(SetupRec.Descriptions[iPos]+'=')
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
          AddNote;

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
    FrmProgress.UpdateLine(1, 'Processing Transactions....');
    FrmProgress.UpdateLine(2, 'Creating NOM');
    bCreateNOM := FALSE;
    For iPos := GL_FIRSTCODE to GL_LASTCODEBUTONE do
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
              if GetAPFPIINISettings(EventData.Setup.ssDataPath) then
              begin
                ProcessPins;
              end else
              begin
                MsgBox('The settings in ' + sAPFPIINIFileName + ' have not been setup correctly.'#13#13
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
                if GetAPFPIINISettings(EventData.Setup.ssDataPath) then
                begin

                  if TXHasBeenReceived then
                  begin
                    with TfrmFreightCosts.Create(application) do
                    begin
                      iDefaultCcy := EventData.Transaction.thCurrency;
//                      oTransaction := EventData.Transaction;
                      oEventData := EventData;
                      GetReceivedTotals(rTotReceived, rTotReceivedValue, rTotReceivedWeight);
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
                  MsgBox('The settings in ' + sAPFPIINIFileName + ' have not been setup correctly.'#13#13
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
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;


// =============================================================================
// TFormTrap
// =============================================================================

procedure TFormTrap.Clear(bPurchase : boolean);
begin
  if bPurchase then
  begin
    PDaybookForm := nil;
    OriginalPPost1Click := nil;
    OriginalPPost2Click := nil;
    OriginalPPopupMenu1Popup := nil;
    FPPost1 := nil;
    FPPost2 := nil;
    FPPopupMenu1 := nil;
  end else
  begin
    SDaybookForm := nil;
    OriginalSPost1Click := nil;
    OriginalSPost2Click := nil;
    OriginalSPopupMenu1Popup := nil;
    FSPost1 := nil;
    FSPost2 := nil;
    FSPopupMenu1 := nil;
  end;{if}
end;

// -----------------------------------------------------------------------------

constructor TFormTrap.Create(sDataPath : string);
begin
  inherited Create;
  iPurchaseMessageTickCount := 0;
  iSalesMessageTickCount := 0;
  FOriginalActivateEvent := Screen.OnActiveFormChange;
  Screen.OnActiveFormChange := OnActivateForm;
  Clear(TRUE);
  Clear(FALSE);

  bDoStuff := GetAPFPIINISettings(sDataPath, FALSE);

{  OriginalPost1Click := nil;
  OriginalPost2Click := nil;
  OriginalPDBFormDestroy := nil;
  OriginalPopupMenu1Popup := nil;
  PDaybookForm := nil;
  FPost1 := nil;
  FPost2 := nil;}
end;

// -----------------------------------------------------------------------------

destructor TFormTrap.Destroy;
begin
  Screen.OnActiveFormChange := FOriginalActivateEvent;

  if Assigned(PDaybookForm)
  then PDaybookForm.OnDestroy := OriginalPDBFormDestroy;

  OriginalPDBFormDestroy := nil;

//  Clear;

  inherited;
end;

// -----------------------------------------------------------------------------

procedure TFormTrap.OnActivateForm(Sender: TObject);
{var
  edInLocation : TExt8pt;}
var
  DaybookForm : TForm;
begin
  if bDoStuff then
  begin
    if (Screen.ActiveForm <> nil) then
    begin

      // PURCHASE DAYBOOK
      if SetupRec.bPurchasePostingWarning then
      begin
        if (Screen.ActiveForm.ClassName = 'TDaybk1')
        and (PDaybookForm = nil) then
        begin
          // Stock Adjustment Line Form

          DaybookForm := Screen.ActiveForm;

          if (Copy(UpperCase(DaybookForm.Caption), 1, 21) = 'PURCHASE TRANSACTIONS') then
          begin
            PDaybookForm := DaybookForm;

    //ShowMessage('POR Daybook');

            if not Assigned(OriginalPDBFormDestroy) then
            begin
              OriginalPDBFormDestroy := PDaybookForm.OnDestroy;
              PDaybookForm.OnDestroy := PDBFormDestroy;
            end;{if}

            if not Assigned(OriginalPPost1Click) then
            begin
    //        find popupmenu5.PD1
              if (FPPost1 = nil) then
              begin
                FPPost1 := TMenuItem(PDaybookForm.FindComponent('PD1'));
                if (FPPost1 <> nil) then
                begin
                  // Replace On Click event
                  OriginalPPost1Click := FPPost1.OnClick;
                  FPPost1.OnClick := OnPPost1Click;
                end;{if}
              end;{if}
            end;{if}

            if not Assigned(OriginalPPopupMenu1Popup) then
            begin
    //        find popupmenu1
              if (FPPopupMenu1 = nil) then
              begin
                FPPopupMenu1 := TPopupMenu(PDaybookForm.FindComponent('PopupMenu1'));
                if (FPPopupMenu1 <> nil) then
                begin
                  // Replace On Popup event
                  OriginalPPopupMenu1Popup := FPPopupMenu1.OnPopup;
                  FPPopupMenu1.OnPopup := OnPPopupMenu1Popup;
                end;{if}
              end;{if}
            end;{if}
          end;{if}

    //      GetSettings(FsMainLocation, FiLineUDF);
    //      GetIniSettings(FsMainLocation);

        end;{if}
      end;{if}

      // SALES DAYBOOK
      if SetupRec.bSalesPostingWarning then
      begin
        if (Screen.ActiveForm.ClassName = 'TDaybk1')
        and (SDaybookForm = nil) then
        begin
          // Stock Adjustment Line Form

          DaybookForm := Screen.ActiveForm;

          if (Copy(UpperCase(DaybookForm.Caption), 1, 18) = 'SALES TRANSACTIONS') then
          begin
            SDaybookForm := DaybookForm;

    //ShowMessage('POR Daybook');

            if not Assigned(OriginalSDBFormDestroy) then
            begin
              OriginalSDBFormDestroy := SDaybookForm.OnDestroy;
              SDaybookForm.OnDestroy := SDBFormDestroy;
            end;{if}

            if not Assigned(OriginalSPost1Click) then
            begin
    //        find popupmenu5.PD1
              if (FSPost1 = nil) then
              begin
                FSPost1 := TMenuItem(SDaybookForm.FindComponent('PD1'));
                if (FSPost1 <> nil) then
                begin
                  // Replace On Click event
                  OriginalSPost1Click := FSPost1.OnClick;
                  FSPost1.OnClick := OnSPost1Click;
                end;{if}
              end;{if}
            end;{if}

            if not Assigned(OriginalSPopupMenu1Popup) then
            begin
    //        find popupmenu1
              if (FSPopupMenu1 = nil) then
              begin
                FSPopupMenu1 := TPopupMenu(SDaybookForm.FindComponent('PopupMenu1'));
                if (FSPopupMenu1 <> nil) then
                begin
                  // Replace On Popup event
                  OriginalSPopupMenu1Popup := FSPopupMenu1.OnPopup;
                  FSPopupMenu1.OnPopup := OnSPopupMenu1Popup;
                end;{if}
              end;{if}
            end;{if}
          end;{if}

    //      GetSettings(FsMainLocation, FiLineUDF);
    //      GetIniSettings(FsMainLocation);

        end;{if}
      end;{if}
    end;{if}
  end;{if}

  { Call the original OnActiveFormChange handler, if any. }
  if Assigned(FOriginalActivateEvent) then
    FOriginalActivateEvent(Sender);
end;

// -----------------------------------------------------------------------------
{
procedure TFormTrap.OnInLocChange(Sender: TObject);
begin
//  FsInLocation := UpperCase(Trim(Text8pt(Sender).Text));

  if Assigned(OriginalInLocOnChange) then OriginalInLocOnChange(Sender);
end;
}
// -----------------------------------------------------------------------------


Function TFormTrap.FindMenuItemWithCaption(MenuItems : TMenuItem; sCaption : string) : TMenuItem;
var
  iPos : integer;
begin{FindMenuItemWithCaption}
  Result := nil;
  For iPos := 0 to MenuItems.Count-1 do
  begin
    if  (MenuItems[iPos] is TMenuItem)
    and (TMenuItem(MenuItems[iPos]).caption = sCaption) then
    begin
      // Found it
      Result := TMenuItem(MenuItems[iPos]);
      break;
    end else
    begin
      Result := FindMenuItemWithCaption(TMenuItem(MenuItems[iPos]), sCaption);
      if Assigned(Result) then break;
    end;{if}
  end;{for}
end;{FindMenuItemWithCaption}

// -----------------------------------------------------------------------------

procedure TFormTrap.OnPPopupMenu1Popup(Sender: TObject);
begin
  if Assigned(OriginalPPopupMenu1Popup) then OriginalPPopupMenu1Popup(Sender);

  // find "Post this daybook" option in the menu
  if (FPPost2 = nil) then
  begin
    FPPost2 := FindMenuItemWithCaption(FPPopupMenu1.items, '&Post this Daybook');
    if (FPPost2 <> nil) then
    begin
      // Replace On Click event
      OriginalPPost2Click := FPPost2.OnClick;
      FPPost2.OnClick := OnPPost2Click;
    end;{if}
  end;{if}
end;

// -----------------------------------------------------------------------------

procedure TFormTrap.OnSPopupMenu1Popup(Sender: TObject);
begin
  if Assigned(OriginalSPopupMenu1Popup) then OriginalSPopupMenu1Popup(Sender);

  // find "Post this daybook" option
  if (FSPost2 = nil) then
  begin
    FSPost2 := FindMenuItemWithCaption(FSPopupMenu1.items, '&Post this Daybook');
    if (FSPost2 <> nil) then
    begin
      // Replace On Click event
      OriginalSPost2Click := FSPost2.OnClick;
      FSPost2.OnClick := OnSPost2Click;
    end;{if}
  end;{if}
end;

// -----------------------------------------------------------------------------

procedure TFormTrap.ShowPostingWarning(bPurchase : boolean);
begin
  if bPurchase then
  begin
    if (GetTickCount - iPurchaseMessageTickCount) > 60000 then // Has it been shown recently
    begin
      iPurchaseMessageTickCount := GetTickCount;
      MsgBox('Warning - Please ensure the Uplift routine has been run before posting this daybook.'
      ,mtWarning, [mbOK], mbOK, 'Posting Warning');
    end;{if}
  end else
  begin
    if (GetTickCount - iSalesMessageTickCount) > 60000 then // Has it been shown recently
    begin
      iSalesMessageTickCount := GetTickCount;
      MsgBox('Warning - Please ensure the Validate routine has been run before posting this daybook.'
      ,mtWarning, [mbOK], mbOK, 'Posting Warning');
    end;{if}
  end;{if}
end;

// -----------------------------------------------------------------------------

procedure TFormTrap.OnPPost1Click(Sender: TObject);
begin
//  if (UpperCase(Copy(TForm(Tpopupmenu(TmenuItem(TmenuItem(Sender).parent).owner).owner).caption, 1, 8)) = 'PURCHASE')
//  or ((TPopupMenu(TmenuItem(Sender).parent).owner is TForm) and (TForm(TPopupMenu(TmenuItem(Sender).parent).owner).caption  = 'PURCHASE'))
//  then ShowPostingWarning(TRUE)
//  else ShowPostingWarning(FALSE);
  ShowPostingWarning(TRUE);

  if Assigned(OriginalPPost1Click) then OriginalPPost1Click(Sender);
//  OriginalPost1Click := nil;
end;

// -----------------------------------------------------------------------------

procedure TFormTrap.OnSPost1Click(Sender: TObject);
begin
//  if (UpperCase(Copy(TForm(Tpopupmenu(TmenuItem(TmenuItem(Sender).parent).owner).owner).caption, 1, 8)) = 'PURCHASE')
//  or ((TPopupMenu(TmenuItem(Sender).parent).owner is TForm) and (TForm(TPopupMenu(TmenuItem(Sender).parent).owner).caption  = 'PURCHASE'))
//  then ShowPostingWarning(TRUE)
//  else ShowPostingWarning(FALSE);
  ShowPostingWarning(FALSE);

  if Assigned(OriginalSPost1Click) then OriginalSPost1Click(Sender);
//  OriginalPost1Click := nil;
end;

// -----------------------------------------------------------------------------

procedure TFormTrap.OnPPost2Click(Sender: TObject);
begin
//  if UpperCase(Copy(TForm(TPopupMenu(TmenuItem(Sender).parent).owner).caption, 1, 8)) = 'PURCHASE'
//  then ShowPostingWarning(TRUE)
//  else ShowPostingWarning(FALSE);
  ShowPostingWarning(TRUE);

  if Assigned(OriginalPPost2Click) then OriginalPPost2Click(Sender);
//  OriginalPost1Click := nil;
end;

// -----------------------------------------------------------------------------

procedure TFormTrap.OnSPost2Click(Sender: TObject);
begin
//  if UpperCase(Copy(TForm(TPopupMenu(TmenuItem(Sender).parent).owner).caption, 1, 8)) = 'PURCHASE'
//  then ShowPostingWarning(TRUE)
//  else ShowPostingWarning(FALSE);
  ShowPostingWarning(FALSE);

  if Assigned(OriginalSPost2Click) then OriginalSPost2Click(Sender);
//  OriginalPost1Click := nil;
end;

// -----------------------------------------------------------------------------

procedure TFormTrap.PDBFormDestroy(Sender: TObject);
begin
  if Assigned(OriginalPDBFormDestroy) then OriginalPDBFormDestroy(Sender);
  OriginalPDBFormDestroy := nil;
  Clear(TRUE);
end;

// -----------------------------------------------------------------------------

procedure TFormTrap.SDBFormDestroy(Sender: TObject);
begin
  if Assigned(OriginalSDBFormDestroy) then OriginalSDBFormDestroy(Sender);
  OriginalSDBFormDestroy := nil;
  Clear(FALSE);
end;


end.



