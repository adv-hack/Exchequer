unit HandlerU;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  {ETStrU, BtrvU2,} BTFiles, {GlobVar,} CustWinU, CustAbsU, Forms, Controls
  {, uSettings}, StockOptions, FileUtil, BTUtil, BTConst, Enterprise01_TLB;

Const
  OPEN_INITIAL_COMPANY = 10;
  OPEN_NEW_COMPANY = 9;
  EXIT_STOCK_CODE = 11;
  BEFORE_STORE_LINE = 10;
  AFTER_STORE_TX = 170;
//  AFTER_STORE_LINE = 14;
  BEFORE_STORE_TX = 1;
  BEFORE_STORE_STOCK = 2;
//  CONVERT_SDN_TO_SIN = 109;

var
  iStockBtnTextId : byte = 0;
  iStockBtnHookId : byte = 0;
//  iSuppBtnId : byte = 0;

Type
  TTransLineInfoCTK = Class
    TL : ITransactionLine;
  end;

  TTransLineInfo = Class
    TL : TABSInvLine;
  end;



{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem04); Export;


implementation

Uses
  Dialogs, SysUtils, ChainU, {Company, ConAdmin,} StrUtil, APIUtil, WEEEProc
  ,Classes, PISecure, PIMisc, MiscUtil, ExchequerRelease;

var
  bHookEnabled : boolean;
  slTXsToSkip : TStringList;
  slTXsAsked : TStringList;
//  iCustHookId : byte = 0;
//  iSuppHookId : byte = 0;

Const
  sPlugInName = 'Exchequer WEEE Plug-In';
  {$IFDEF EX600}
    sVersionNo = '010';
//    sVersionNo = 'v6.00.008';
  {$ELSE}
    sVersionNo = 'v5.70.008';
  {$ENDIF}
  EventDisabled = 0;
  EventEnabled  = 1;
//  ValidAccountTypes = [CUSIN, CUSOR, CUSDN, CUSRI, CUSQU];
//  ValidSalesAccTypes = [CUSIN, CUSCR, CUSRF, CUSOR, CUSDN, CUSRI, CUSQU];
//  ValidPurchAccTypes = [CUPIN, CUPCR, CUPRF, CUPOR, CUPDN, CUPPI, CUPQU];
//  SM_ADD_EMAIL = 2;


Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
{ Called by Enterprise to initialise the Customisation }
var
  slAboutText : TStringList;
  iPos : integer;
Begin

  CustomOn := True;

//  frmPickAccount := nil;

  bHookEnabled := PICheckSecurity('EXCHWEEEPI000034', 'sss!2""24-ds,,e4', sPlugInName
  , '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    { Enable Hooks and Set About Message here }
    with TAbsCustomHandlers01(CustomHandlers) do
    begin

      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
      slAboutText.Free;

      // Popup "Select contact" on store transaction
//      SetHandlerStatus(wiTransaction, 9, EventEnabled); // Set Deliver Address Hook on TX Header
//      SetHandlerStatus(wiAccount, 109, EventEnabled); // Telesales Hook

      // Allow users to select contacts for email addresses
//      if ClassVersion > '5.70' then SetHandlerStatus(wiPrint, 1, EventEnabled); // Telesales Hook

      // Detect if Custom button1 is already in use.
      if (not HookPointEnabled(wiStock, 80)) then
        begin
          iStockBtnHookId := 80;
          iStockBtnTextId := 1;
        end
      else begin
        if (not HookPointEnabled(wiAccount, 90)) then begin
          iStockBtnHookId := 90;
          iStockBtnTextId := 11;
        end;{if}
      end;{if}

      // Enable Stock Button Hook
      SetHandlerStatus(wiStock, iStockBtnHookId, EventEnabled);

      // Enable Change Account Code Hook
//      if Copy(classversion,1,4) >= '5.52'
//      then SetHandlerStatus(wiAccount, 111, EventEnabled);

      // Enable Delete Account Hook
//      SetHandlerStatus(wiAccount, 4, EventEnabled);

      // open company hooks
      SetHandlerStatus(EnterpriseBase + MiscBase + 2, OPEN_INITIAL_COMPANY, EventEnabled);
      SetHandlerStatus(EnterpriseBase + MiscBase + 2, OPEN_NEW_COMPANY, EventEnabled);
//      SetHandlerStatus(EnterpriseBase + MiscBase + 2, CLOSE_COMPANY, EventEnabled);

      // Exit Stock Code on Tx Line
      SetHandlerStatus (wiTransLine, EXIT_STOCK_CODE, EventEnabled);

      // before store Tx Line
      SetHandlerStatus(wiTransLine, BEFORE_STORE_LINE, EventEnabled);

      // before store Tx Line
//      SetHandlerStatus(wiTransLine, AFTER_STORE_LINE, EventEnabled);

      // After store Tx
      SetHandlerStatus(wiTransaction, AFTER_STORE_TX, EventEnabled);

      // Before store Stock Record
      SetHandlerStatus(wiStock, BEFORE_STORE_STOCK, EventEnabled);

      // Before store Transaction
      SetHandlerStatus(wiTransaction, BEFORE_STORE_TX, EventEnabled);

      // on SDN to SIN
//      SetHandlerStatus(wiTransaction, CONVERT_SDN_TO_SIN, EventEnabled);

    end;

    slTXsToSkip := TStringList.create;
    slTXsAsked := TStringList.create;

  end;{if}


  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

Procedure TermCustomHandler;
{ Called by Enterprise to End the Customisation }
Begin

  ClearList(slTXsToSkip);
  slTXsToSkip.free;
  slTXsAsked.free;


  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem04);
{ Called by Enterprise whenever a Customised Event happens }
var
  sDataPath, CompanyCode : string;
  iResult : integer;
  bWEEE : boolean;
//  UpdateTX : ITransaction;


  procedure UpdateWEEELineQuantities;
  // This procedure is called after transaction store to
  // populate the Quantity fields on the WEEE Lines.
  // We have to do it this way, as the customisation does not allow us to edit these fields
  var
    WEEEProductDetails : TWEEEProdRec;
    BTRec : TBTRec;
    TL : ITransactionLine;
    iPos, iLink, iIndex, iLine : integer;
    bContinue : boolean;
    slNonWEEELines : TStringList;
    UpdateTX : ITransaction;
    TransLineInfoCTK : TTransLineInfoCTK;
  begin{UpdateWEEELineQuantities}

    // Get the Transaction
    oToolkit.Transaction.Index := thIdxOurRef;
    if oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex
    (EventData.Transaction2.thOurRef)) = 0 then
    begin
      // Get the WEEE system setup
      GetSysSetupRec;

      // Let's update the TX
      UpdateTX := oToolkit.Transaction.Update;

      if UpdateTX <> nil then
      begin

        OpenFiles;
        slNonWEEELines := TStringList.Create;

        // Go through all lines - to find the non-WEEE Lines
        // We need to get these so that we can then find the matching WEEE Lines to resync them
        For iLine := 1 to UpdateTX.thLines.thLineCount do
        begin
          if not IsWEEELineCTK(UpdateTX.thLines.thLine[iLine]) then
          begin
            // Not a WEEE Charge Line
            iLink := GetLinkNoFromLineCTK(UpdateTX.thLines.thLine[iLine]);
            if iLink > 0 then
            begin
              // Found a line that should have a matching WEEE Charge Line
              TransLineInfoCTK := TTransLineInfoCTK.Create;
              TransLineInfoCTK.TL := UpdateTX.thLines.thLine[iLine];
              slNonWEEELines.AddObject(IntToStr(iLink), TransLineInfoCTK);
            end;{if}
          end;{if}
        end;{for}

        // Go through all lines - to find the WEEE Lines
        // We can then update them with the correct Quantities
        For iLine := 1 to UpdateTX.thLines.thLineCount do
        begin
          if IsWEEELineCTK(UpdateTX.thLines.thLine[iLine]) then
          begin
            // Found a WEEE Line
            iLink := GetLinkNoFromLineCTK(UpdateTX.thLines.thLine[iLine]);
            iPos := slNonWEEELines.indexOf(IntToStr(iLink));
            if iPos >= 0 then
            begin
              // Found a WEEE Charge Line line that has a matching Stock Line
              TransLineInfoCTK := TTransLineInfoCTK(slNonWEEELines.Objects[iPos]);

              if TransLineInfoCTK <> nil then
              begin
                // Update Quantity Fields on the WEEE Line
                // from the values on the linked stock line
                UpdateTX.thLines.thLine[iLine].tlQty := TransLineInfoCTK.TL.tlQty;
                UpdateTX.thLines.thLine[iLine].tlQtyMul := TransLineInfoCTK.TL.tlQtyMul;
                UpdateTX.thLines.thLine[iLine].tlQtyWOFF := TransLineInfoCTK.TL.tlQtyWOFF;
                UpdateTX.thLines.thLine[iLine].tlQtyDel := TransLineInfoCTK.TL.tlQtyDel;
                UpdateTX.thLines.thLine[iLine].tlQtyPicked := TransLineInfoCTK.TL.tlQtyPicked;
                UpdateTX.thLines.thLine[iLine].tlQtyPickedWO := TransLineInfoCTK.TL.tlQtyPickedWO;
              end;{if}
            end else
            begin
              // No matching Stock Line, so it must have been deleted.
              // We Thererfore need to Zero the Quantity Fields om the WEEE Line
              // Note : We cannot delete lines due to potential SPOP issues -
              // i.e. the Toolkit will not allow us to delete the lines
              UpdateTX.thLines.thLine[iLine].tlQty := 0;
              UpdateTX.thLines.thLine[iLine].tlQtyMul := 0;
              UpdateTX.thLines.thLine[iLine].tlQtyWOFF := 0;
              UpdateTX.thLines.thLine[iLine].tlQtyDel := 0;
              UpdateTX.thLines.thLine[iLine].tlQtyPicked := 0;
              UpdateTX.thLines.thLine[iLine].tlQtyPickedWO := 0;
              SetTXLineUDFCTK(UpdateTX.thLines.thLine[iLine], 0, CLEAR_UDF
              , EventData.Setup3.ssNoNetDec);
            end;{if}
          end;{if}
        end;{for}

        CloseFiles;

        // Update Transaction
        iResult := UpdateTX.Save(TRUE);
        if iResult <> 0 then
        begin
          MsgBox('An error (' + IntToStr(iResult) + ') occurred whilst updating the transaction'
          + #13#13 + oToolkit.LastErrorString, mtError, [mbOK], mbOK, 'Save Transaction Error');
        end;{if}

        // Clear up
        UpdateTX := nil;
        ClearList(slNonWEEELines);
        slNonWEEELines.Free;
      end;{if}
    end;{if}
  end;{UpdateWEEELineQuantities}

  procedure AddEditWEEELines;
  // This is called in Before Transaction Store where we are allowed to Add and Edit the Lines
  // Here we Add WEEE Lines, Edit WEEE Lines (so they match the stock lines)
  // and Zero WEEE Lines that have no matching Stock Line
  var
    WEEEProductDetails : TWEEEProdRec;

    Function FindWEEELine(iFindLink : integer) : integer;
    // Finds a WEEE Line with the given Link number
    // Returns -1 if no match is found
    var
      iLine : integer;
    begin{FindWEEELine}

      Result := -1;
      if iFindLink = -1 then exit;  // no links exist for -1

      with EventData.Transaction.thLines do
      begin
        // Go through all lines
        For iLine := 1 to thLineCount do
        begin
          if IsWEEELine(thLine[iLine]) and (getLinkNoFromLine(thLine[iLine]) = iFindLink) then
          begin
            // Found the WEEE Line that matches
            Result := iLine;
            Exit;
          end;{if}
        end;{for}
      end;{with}
    end;{FindWEEELine}

    procedure PopulateWEEELine(NewLine : TABSInvLine; iLine, iLink :integer);
    // Poulates certain fields on a line from another line
    // Also populates the Line User Defined Field - Making it a WEEE Line.
    begin{PopulateWEEELine}
      with EventData.Transaction.thlines do begin
        NewLine.tlQty := thLine[iLine].tlQty;
        NewLine.tlNetValue := WEEEProductDetails.wpValue;
        NewLine.tlVATCode := 'E';
        NewLine.tlCostCentre := thLine[iLine].tlCostCentre;
        NewLine.tlDepartment := thLine[iLine].tlDepartment;
        NewLine.tlLocation := thLine[iLine].tlLocation;
        NewLine.tlGLCode := thLine[iLine].tlGLCode;
        NewLine.tlDescr := 'WEEE Charge for ' + thLine[iLine].tlStockCode;
        Case SystemSetupRec.TXLineUDF of
          1 : NewLine.tlUserDef1 := WEEE_Charge_Line + '/' + IntToStr(iLink);
          2 : NewLine.tlUserDef2 := WEEE_Charge_Line + '/' + IntToStr(iLink);
          3 : NewLine.tlUserDef3 := WEEE_Charge_Line + '/' + IntToStr(iLink);
          4 : NewLine.tlUserDef4 := WEEE_Charge_Line + '/' + IntToStr(iLink);
        end;{case}
      end;{with}
    end;{PopulateWEEELine}

  var
    BTRec : TBTRec;
    iLink, iWEEELine, iLine, iIndex : integer;
    bContinue : boolean;
    sUDF : string;
    slWEEELinesDone, slWEEELines : TStringList;
    TransLineInfo : TTransLineInfo;

  begin{AddEditWEEELines}

    // Is the customer a WEEE customer ?
    bContinue := FALSE;
    Case SystemSetupRec.CustomerUDF of
      1 : bContinue := Trim(UpperCase(EventData.Customer2.acUserDef1)) = 'YES';
      2 : bContinue := Trim(UpperCase(EventData.Customer2.acUserDef2)) = 'YES';
      3 : bContinue := Trim(UpperCase(EventData.Customer2.acUserDef3)) = 'YES';
      4 : bContinue := Trim(UpperCase(EventData.Customer2.acUserDef4)) = 'YES';
    end;{case}

    if bContinue then
    begin
      // Transaction is for a WEEE customer

      // initialise
      slWEEELines := TStringList.create;
      slWEEELinesDone := TStringList.create;
      OpenFiles;

      with EventData.Transaction2, thLines do
      begin

        // Go through all lines
        For iLine := 1 to thLineCount do
        begin
          if IsWEEELine(thLine[iLine]) then
          begin
            // WEE Line found - Add to WEEE Line List
            // we'll need this for later, when determining whether we need to zero any of the lines
            TransLineInfo := TTransLineInfo.Create;
            TransLineInfo.TL := thLine[iLine];
            slWEEELines.AddObject(IntToStr(iLine), TransLineInfo);
          end else
          begin
            // Stock Line found

            // Get WEEE Product Details from the database
            BTRec.KeyS := PadString(psRight, thLine[iLine].tlStockCode, ' ', 16);
            BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEProdF], WEEEProductDetails
            , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);

            // If WEEE Details found
            if BTRec.Status = 0 then
            begin
              // Line is for a WEEE Product

              // Find the linked WEEE Line
              iWEEELine := FindWEEELine(GetLinkNoFromLine(thLine[iLine]));
              if iWEEELine = -1 then
              begin
                // No Linked WEEE Line found, so Add a new WEEE Line
                AddNewLine;
                iLink := GetNextLinkLineNo(EventData.transaction);
                PopulateWEEELine(thCurrentLine, iLine, iLink);

                // Save new WEEE line
                thCurrentline.Save;

                // Update Stock Line UDF so we have a link between the 2 lines
                SetTXLineUDF(thLine[iLine], WEEEProductDetails.wpValue, iLink
                , EventData.Setup3.ssNoNetDec);
                thLine[iLine].Save;

                // Add to list of lines that we have done
                slWEEELinesDone.Add(IntToStr(thLineCount));
              end else
              begin
                // Linked WEEE Line Found, so edit the existing line (Resync)
                iLink := GetLinkNoFromLine(thLine[iLine]);
                PopulateWEEELine(thLine[iWEEELine], iLine, iLink);
                thLine[iWEEELine].Save;

                // Add to list of lines that we have done
                slWEEELinesDone.Add(IntToStr(iWEEELine));
              end;{if}
            end else
            begin
              // This line is not for a WEE product, so clear the line UDF
              SetTXLineUDF(thLine[iLine], 0, CLEAR_UDF, EventData.Setup3.ssNoNetDec);
              thLine[iLine].Save;
            end;{if}
          end;{if}
        end;{for}

        // Work out which WEEE Lines have not been touched.
        // The Stock lines linked to these must have been deleted
        // so we must zero these line's Quantities
        For iLine := 0 to slWEEELines.Count-1 do
        begin
          // Has the line already been modified ?
          if slWEEELinesDone.IndexOf(slWEEELines[iLine]) = -1 then
          begin
            // Not already modified so it must die !
            TTransLineInfo(slWEEELines.Objects[iLine]).TL.tlQty := 0;
            TTransLineInfo(slWEEELines.Objects[iLine]).TL.Save;
          end;{if}
        end;{for}
      end;{with}

      // Clear up
      CloseFiles;
      ClearList(slWEEELines);
      slWEEELines.Free;
      slWEEELinesDone.Free;

    end;{if}
  end;{AddEditWEEELines}

  procedure DisplayWEEEOptions;
  // Displays the WEEE options dialog for the stock item
  begin{DisplayWEEEOptions}
    with TfrmStockOptions.create(application) do begin
      oStock := EventData.Stock3;
      StartToolkit(EventData);
      showmodal;
      release;
      oToolkit.CloseToolkit;
      oToolkit := nil;
    end;{with}
  end;{DisplayWEEEOptions}

  procedure ZeroAllWEEELines;
  // Zeroes all the WEEE Line Quantities
  // Note : We cannot delete lines due to potential SPOP issues -
  // i.e. the customisation will not allow us to delete the lines
  var
    iLine : integer;
  begin{ZeroAllWEEELines}
    with EventData.transaction do begin
      For iLine := 1 to thLines.thLineCount do
      begin
        if IsWEEELine(thLines.thLine[iLine]) then
        begin
          thLines.thLine[iLine].tlQty := 0;
          thLines.thLine[iLine].Save;
        end;{if}
      end;{for}
    end;{with}
  end;{ZeroAllWEEELines}

var
  rWEEEValue : real;
  iIndex : integer;
  bContinue : boolean;

Begin{ExecCustomHandler}
  { Handle Hook Events here }

  if bHookEnabled then begin
    with EventData do begin

      sDataPath := Setup.ssDataPath;
//      sMiscDirLocation := sDataPath;

//      oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));

      case WinID of
        wiStock : begin {1000}
          case HandlerID of
            BEFORE_STORE_STOCK : begin

              // Read in WEEE System Setup
              GetSysSetupRec;

              // See if WEEE Record is setup in the database
              if IsWEEEStockItem(EventData.Stock3) then
              begin
                OpenFiles;
                if not GetWEEEValue(EventData.Stock3.stCode, rWEEEValue) then
                begin
                  // Show Warning
                  if MsgBox('You have set this stock record to be a WEEE item, but have not setup the WEEE parameters.'
                  + #13#13 + 'Do you wish to setup these parameters now ?' , mtWarning
                  , [mbNo, mbYes], mbYes, 'Add WEEE Options') = mrYes then
                  begin
                    // Shows WEEE Options Dialog
                    DisplayWEEEOptions;
                  end;{if}
                end;{if}
                CloseFiles;
              end;{if}
            end;

            // Other Stock Hook Points
            else begin
              // WEEE Options Button Clicked
              if HandlerID = iStockBtnHookId then
              begin
                // Read in WEEE System Setup
                GetSysSetupRec;

                // Is Stock Item a WEEE Stock Item ?
                Case SystemSetupRec.StockFlagUDF of
                  1 : bWEEE := UpperCase(EventData.Stock3.stStkUser1) = 'YES';
                  2 : bWEEE := UpperCase(EventData.Stock3.stStkUser2) = 'YES';
                  3 : bWEEE := UpperCase(EventData.Stock3.stStkUser3) = 'YES';
                  4 : bWEEE := UpperCase(EventData.Stock3.stStkUser4) = 'YES';
                end;{case}

                if bWEEE then
                begin
                   // Shows WEEE Options Dialog
                  DisplayWEEEOptions;
                end else
                begin
                   // Not a WEEE Stock Item
                  MsgBox('The WEEE Stock Options are not available for this product.'
                  ,mtInformation,[mbOK], mbOK, 'WEEE Options');
                end;{if}
              end;{if}
            end;
          end;{case}
        end;

        wiTransaction : begin {2000}
          case HandlerID of
            BEFORE_STORE_TX : begin

              // Read in WEEE System Setup
              GetSysSetupRec;

              // Only ask for SCRs and SJCs
              if (EventData.Transaction2.thInvDocHed in [CUSCR,CUSJC{,CUSRF}]) then // Note : SRFs are not supported. This is because the Toolkit does not support the updating of this transaction type
              begin
                if slTXsAsked.IndexOf(EventData.Transaction2.thOurRef) = -1 then
                begin

                  // Is the customer a WEEE customer ?
                  bContinue := FALSE;
                  Case SystemSetupRec.CustomerUDF of
                    1 : bContinue := Trim(UpperCase(EventData.Customer2.acUserDef1)) = 'YES';
                    2 : bContinue := Trim(UpperCase(EventData.Customer2.acUserDef2)) = 'YES';
                    3 : bContinue := Trim(UpperCase(EventData.Customer2.acUserDef3)) = 'YES';
                    4 : bContinue := Trim(UpperCase(EventData.Customer2.acUserDef4)) = 'YES';
                  end;{case}

                  if bContinue then
                  begin

                    // Check to see if there any  WEEE products in the transaction
                    StartToolkit(EventData);

                    // Go through the lines until we find a WEEE Product
                    bContinue := FALSE;
                    For iIndex := 1 to EventData.Transaction2.thLines.thLineCount do
                    begin
                      // Get Stock Item in Toolkit
                      oToolkit.Stock.Index := stIdxCode;
                      iResult := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(EventData.Transaction2.thLines.thLine[iIndex].tlStockCode));
                      if iResult = 0 then
                      begin
                        if IsWEEEStockItemCTK(oToolkit.Stock) then
                        begin
                          // WEE Line found
                          bContinue := TRUE;
                          break;
                        end;{if}
                      end;{if}
                    end;{for}

                    if bContinue then
                    begin
                      // WEEE products are in this transaction

                      if MsgBox('WEEE products exist on this transaction.'#13#13
                      + 'Do you want WEEE Credit Lines to exist for this transaction ?',mtConfirmation,[mbYes, mbNo], mbYes
                      , 'WEEE Lines') = mrNo then
                      begin
                        // Add to list of transactions to ignore
                        slTXsToSkip.Add(EventData.Transaction2.thOurRef);

                        // Zero WEE Lines
                        ZeroAllWEEELines;
                      end else
                      begin
                        // Remove from List of Transactions to Skip
                        iIndex := slTXsToSkip.IndexOf(EventData.Transaction2.thOurRef);
                        if iIndex >= 0 then slTXsToSkip.Delete(iIndex);
                      end;{if}

                      // Keeps track of which TXs we have asked this question, so it does not ask again
                      slTXsAsked.Add(EventData.Transaction2.thOurRef);
                    end;{if}

                    // close toolkit
                    oToolkit.CloseToolkit;
                    oToolkit := nil;
                  end;{if}
                end;{if}
              end;{if}

              // Check TX Type
              if EventData.Transaction2.thInvDocHed
              in [CUSIN,{CUSRC,}CUSCR,CUSJI,CUSJC,{CUSRF,CUSRI,}CUSQU,CUSOR] then // Note : SRCs, SRFs and SRIs are not supported. This is because the Toolkit does not support the updating of these transaction types
              begin
                // Resync WEEE Lines (add edit)
                if slTXsToSkip.IndexOf(EventData.Transaction2.thOurRef) = -1
                then AddEditWEEELines;
              end;{if}
            end;

            AFTER_STORE_TX {, CONVERT_SDN_TO_SIN, } : begin
              if EventData.Transaction2.thInvDocHed
//              in [CUSIN,CUSRC,CUSCR,CUSJI,CUSJC,CUSRF,CUSRI,CUSQU,CUSOR] then
              // changed cos toolkit does not allow updating of SRFs, SRIs or SRCs
              in [CUSIN,{CUSRC,}CUSCR,CUSJI,CUSJC,{CUSRF,CUSRI,}CUSQU,CUSOR] then
              begin
                // Make sure it is not a TX to skip
                if slTXsToSkip.IndexOf(EventData.Transaction2.thOurRef) = -1 then
                begin
                  // Resync Quantities WEEE Lines
                  StartToolkit(EventData);
                  UpdateWEEELineQuantities;
                  oToolkit.CloseToolkit;
                  oToolkit := nil;
                end;{if}
              end;{if}
            end;
          end;{case}
        end;

        wiTransLine : begin {4000}
          case HandlerID of
            EXIT_STOCK_CODE, BEFORE_STORE_LINE : begin
              if EventData.Transaction2.thInvDocHed
              in [CUSIN,{CUSRC,}CUSCR,CUSJI,CUSJC,{CUSRF, CUSRI,}CUSQU,CUSOR] then // Note : SRCs, SRFs and SRIs are not supported. This is because the Toolkit does not support the updating of these transaction types
              begin
                // Read in WEEE System Setup
                GetSysSetupRec;

                OpenFiles;

                case HandlerID of
                  EXIT_STOCK_CODE : begin
                    // only show message if flag set in setup
                    if SystemSetupRec.ShowWEEEValuePopup then
                    begin
                      // Is this product a WEEE Product, if so get the value
                      if GetWEEEValue(EventData.Transaction2.thLines.thCurrentLine.tlStockCode
                      , rWEEEValue) then
                      begin
                        // Show Message for WEEE Charge
                        MsgBox('WEEE Charge : '#13#13 + MoneyToStr(rWEEEValue
                        , EventData.Setup3.ssNoNetDec), mtInformation, [mbOK], mbOK, 'WEEE Charge');
                      end;{if}
                    end;{if}
                  end;

                  BEFORE_STORE_LINE : begin
                    if not IsWEEELine(EventData.Transaction2.thLines.thCurrentLine) then
                    begin
                      // Stock Line

                      // Get the WEEE value
                      GetWEEEValue(EventData.Transaction2.thLines.thCurrentLine.tlStockCode, rWEEEValue);

                      // store it in the defined UD Field
                      SetTXLineUDF(EventData.Transaction2.thLines.thCurrentLine, rWEEEValue, 0
                      , EventData.Setup3.ssNoNetDec);
                    end;{if}
                  end;

{                  AFTER_STORE_LINE : begin
                    // Read in WEEE System Setup
                    GetSysSetupRec;

                    // Is Stock Item a WEEE Stock Item ?
                    Case SystemSetupRec.StockUDF of
                      1 : bWEEE := UpperCase(EventData.Stock3.stStkUser1) = 'YES';
                      2 : bWEEE := UpperCase(EventData.Stock3.stStkUser2) = 'YES';
                      3 : bWEEE := UpperCase(EventData.Stock3.stStkUser3) = 'YES';
                      4 : bWEEE := UpperCase(EventData.Stock3.stStkUser4) = 'YES';
                    end;{case}

{                    if bWEEE then
                    begin

                    end;{if}
{                  end;}
                end;{case}

                CloseFiles;
              end;{if}
            end;
          end;{case}
        end;

        EnterpriseBase + MiscBase + 2 : begin
          case EventData.HandlerId of
            OPEN_INITIAL_COMPANY, OPEN_NEW_COMPANY : CompanyRec.Path := EventData.Setup3.ssDataPath;
//            CLOSE_COMPANY : oSettings.Free;
          end;{case}
        end;
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
end;

end.
