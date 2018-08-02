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
  AFTER_STORE_LINE = 14;
  BEFORE_STORE_TX = 1;
  BEFORE_STORE_STOCK = 2;
//  CONVERT_SDN_TO_SIN = 109;

var
  iStockBtnTextId : byte = 0;
  iStockBtnHookId : byte = 0;
//  iSuppBtnId : byte = 0;

Type
  TTransLineInfo = Class
    TL : ITransactionLine;
  end;



{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem04); Export;


implementation

Uses
  Dialogs, SysUtils, ChainU, {Company, ConAdmin,} StrUtil, APIUtil, WEEEProc
  ,Classes, PISecure, PIMisc, MiscUtil;

var
  bHookEnabled : boolean;
  slTXs : TStringList;
//  iCustHookId : byte = 0;
//  iSuppHookId : byte = 0;

Const
  sPlugInName = 'Exchequer WEEE Plug-In';
  {$IFDEF EX600}
    sVersionNo = 'v6.00.002';
  {$ELSE}
    sVersionNo = 'v5.70.002';
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
  , sVersionNo + ' (DLL)', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    { Enable Hooks and Set About Message here }
    with TAbsCustomHandlers01(CustomHandlers) do
    begin

      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, sVersionNo + ' (DLL)', slAboutText);
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

      // open close company hooks
      SetHandlerStatus(EnterpriseBase + MiscBase + 2, OPEN_INITIAL_COMPANY, EventEnabled);
      SetHandlerStatus(EnterpriseBase + MiscBase + 2, OPEN_NEW_COMPANY, EventEnabled);
//      SetHandlerStatus(EnterpriseBase + MiscBase + 2, CLOSE_COMPANY, EventEnabled);

      // Exit Stock Code on Tx Line
      SetHandlerStatus (wiTransLine, EXIT_STOCK_CODE, EventEnabled);

      // before store Tx Line
      SetHandlerStatus(wiTransLine, BEFORE_STORE_LINE, EventEnabled);

      // before store Tx Line
      SetHandlerStatus(wiTransLine, AFTER_STORE_LINE, EventEnabled);

      // After store Tx
      SetHandlerStatus(wiTransaction, AFTER_STORE_TX, EventEnabled);

      // Before store Stock Record
      SetHandlerStatus(wiStock, BEFORE_STORE_STOCK, EventEnabled);

      // Before store Transaction
      SetHandlerStatus(wiTransaction, BEFORE_STORE_TX, EventEnabled);

      // on SDN to SIN
//      SetHandlerStatus(wiTransaction, CONVERT_SDN_TO_SIN, EventEnabled);

    end;

    slTXs := TStringList.create;

  end;{if}


  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

Procedure TermCustomHandler;
{ Called by Enterprise to End the Customisation }
Begin

  ClearList(slTXs);
  slTXs.free;

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

  Function GetWEEEValue(sCode : string; var rValue : real) : boolean;
  var
    WEEEProductDetails : TWEEEProdRec;
    BTRec : TBTRec;
  begin
    rValue := 0;
    BTRec.KeyS := PadString(psRight, sCode, ' ', 16);
    BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEProdF], WEEEProductDetails
    , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);
    if BTRec.Status = 0 then rValue := WEEEProductDetails.wpValue;
    Result := BTRec.Status = 0;
  end;

(*
  procedure AddEditDeleteWEEELines;

    procedure DeleteAllWEEELines;
    var
      iLine : integer;
    begin{DeleteAllWEEELines}
      with UpdateTX do
      begin
        iLine := 1;
        while iLine <= thLines.thLineCount do
        begin
          // Depending on system setup define wether this line is a WEEE charge line
          Case SystemSetupRec.TXLineUDF of
            1 : begin
              if thLines.thLine[iLine].tlUserField1 = WEEE_Charge_Line then
              begin
                thLines.Delete(iLine);
                Dec(iLine);
              end;
            end;

            2 : begin
              if thLines.thLine[iLine].tlUserField2 = WEEE_Charge_Line then
              begin
                thLines.Delete(iLine);
                Dec(iLine);
              end;
            end;

            3 : begin
              if thLines.thLine[iLine].tlUserField3 = WEEE_Charge_Line then
              begin
                thLines.Delete(iLine);
                Dec(iLine);
              end;
            end;

            4 : begin
              if thLines.thLine[iLine].tlUserField4 = WEEE_Charge_Line then
              begin
                thLines.Delete(iLine);
                Dec(iLine);
              end;
            end;

          end;{case}
          // next line
          inc(iLine);
        end;{while}
      end;{with}
    end;{DeleteAllWEEELines}

  var
    WEEEProductDetails : TWEEEProdRec;
    BTRec : TBTRec;
    TL : ITransactionLine;
    iIndex, iLine : integer;
    bContinue : boolean;

  begin{AddEditDeleteWEEELines}
//    with oToolkit.Transaction do
//    begin

    // Get Stored Transaction
    oToolkit.Transaction.Index := thIdxOurRef;
    if oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex
    (EventData.Transaction2.thOurRef)) = 0 then
    begin
      // Get WEEW system setup
      GetSysSetupRec;

      // Is the customer a WEEE customer ?
      bContinue := FALSE;
      Case SystemSetupRec.CustomerUDF of
        1 : bContinue := UpperCase(oToolkit.Transaction.thAcCodeI.acUserDef1) = 'YES';
        2 : bContinue := UpperCase(oToolkit.Transaction.thAcCodeI.acUserDef2) = 'YES';
        3 : bContinue := UpperCase(oToolkit.Transaction.thAcCodeI.acUserDef3) = 'YES';
        4 : bContinue := UpperCase(oToolkit.Transaction.thAcCodeI.acUserDef4) = 'YES';
      end;{case}

      if bContinue then
      begin

        // Let's update the TX
        UpdateTX := oToolkit.Transaction.Update;

        if UpdateTX <> nil then
        begin

          // Delete WEEE Charge Lines
          DeleteAllWEEELines;

          OpenFiles;

          // Add WEEE Charge Lines
          bContinue := FALSE;

          // Go through all lines
          For iLine := 1 to UpdateTX.thLines.thLineCount do
          begin
            // Get WEEE Product Details from the database
            BTRec.KeyS := PadString(psRight, UpdateTX.thLines.thLine[iLine].tlStockCode, ' ', 16);
            BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEProdF], WEEEProductDetails
            , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);

            // If WEEE Details found
            if BTRec.Status = 0 then
            begin
              // Populate new line details
              bContinue := TRUE;
              TL := UpdateTX.thLines.Add;
//              TL.tlStockCode := WEEEProductDetails.wpExtraChargeStockCode;

              TL.ImportDefaults;
              TL.tlQty := UpdateTX.thLines.thLine[iLine].tlQty;
              TL.tlQtyWOFF := UpdateTX.thLines.thLine[iLine].tlQtyWOFF;
              TL.tlQtyDel := UpdateTX.thLines.thLine[iLine].tlQtyDel;
              TL.tlQtyPicked := UpdateTX.thLines.thLine[iLine].tlQtyPicked;
              TL.tlQtyPickedWO := UpdateTX.thLines.thLine[iLine].tlQtyPickedWO;
              TL.tlNetValue := WEEEProductDetails.wpValue;
              TL.tlCostCentre := UpdateTX.thLines.thLine[iLine].tlCostCentre;
              TL.tlDepartment := UpdateTX.thLines.thLine[iLine].tlDepartment;
              TL.tlLocation := UpdateTX.thLines.thLine[iLine].tlLocation;

TL.tlGLCode := UpdateTX.thLines.thLine[iLine].tlGLCode;
TL.tlDescr := 'WEEE Charge';

              Case SystemSetupRec.TXLineUDF of
                1 : TL.tlUserField1 := WEEE_Charge_Line;
                2 : TL.tlUserField2 := WEEE_Charge_Line;
                3 : TL.tlUserField3 := WEEE_Charge_Line;
                4 : TL.tlUserField4 := WEEE_Charge_Line;
              end;{case}

              TL.CalcVATAmount;

              // Save new line
              TL.Save;
            end;{if}
          end;{for}

          if bContinue and (EventData.Transaction2.thInvDocHed in [CUSCR,CUSJC,CUSRF]) then
          begin
            iIndex := slTXs.IndexOf(EventData.Transaction2.thOurRef);
            if iIndex >= 0 then
            begin
              slTXs.delete(iIndex);
              DeleteAllWEEELines;
            end;

{            if MsgBox('WEEE products exist on this transaction.'#13#13
            + 'Do you want WEE Credit Lines to exist for this transction ?',mtConfirmation,[mbYes, mbNo], mbYes
            , 'WEEE Lines') = mrNo then
            begin
              DeleteAllWEEELines;
            end;}
          end;{if}

          CloseFiles;

          // Update Transaction
          iResult := UpdateTX.Save(TRUE);
          if iResult <> 0 then
          begin
            MsgBox('An error (' + IntToStr(iResult) + ') occurred whilst updating the transaction'
            + #13#13 + oToolkit.LastErrorString, mtError, [mbOK], mbOK, 'Save Transaction Error');
          end;{if}

          UpdateTX := nil;
        end;{if}
      end;{if}
    end;{if}
  end;{AddEditDeleteWEEELines}
*)


  function IsWEEELine(TL : TAbsInvLine) : boolean;
  begin{IsWEEELine}
    Result := FALSE;
    Case SystemSetupRec.TXLineUDF of
      1 : Result := Copy(TL.tlUserDef1,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
      2 : Result := Copy(TL.tlUserDef2,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
      3 : Result := Copy(TL.tlUserDef3,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
      4 : Result := Copy(TL.tlUserDef4,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
    end;{case}
  end;{IsWEEELine}

  function IsWEEELineCTK(TL : ITransactionLine) : boolean;
  begin{IsWEEELine}
    Result := FALSE;
    Case SystemSetupRec.TXLineUDF of
      1 : Result := Copy(TL.tlUserField1,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
      2 : Result := Copy(TL.tlUserField2,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
      3 : Result := Copy(TL.tlUserField3,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
      4 : Result := Copy(TL.tlUserField4,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
    end;{case}
  end;{IsWEEELine}

(*  function GetLinkNoFromLine(TL : TABSInvLine) : integer;
  var
    sUDF : string;
    iPos : integer;
  begin{GetLinkNoFromLine}
    Result := 0;
    with TL do
    begin
      // Get Current UDF Value
      Case SystemSetupRec.TXLineUDF of
        1 : sUDF := tlUserField1;
        2 : sUDF := tlUserField2;
        3 : sUDF := tlUserField3;
        4 : sUDF := tlUserField4;
      end;{case}

      // Get Link Value
      if (sUDF <> '') then
      begin
        // Get Link from UDF
        iPos := Pos('/', sUDF);
        if iPos > 0 then Result := StrToIntDef(Copy(sUDF,iPos+1,255),0);
      end;{if}
    end;{with}
  end;{GetLinkNoFromLine}
  *)
  function GetLinkNoFromLineCTK(TL : ITransactionLine) : integer;
  var
    sUDF : string;
    iPos : integer;
  begin{GetLinkNoFromLine}
    Result := 0;
    with TL do
    begin
      // Get Current UDF Value
      Case SystemSetupRec.TXLineUDF of
        1 : sUDF := tlUserField1;
        2 : sUDF := tlUserField2;
        3 : sUDF := tlUserField3;
        4 : sUDF := tlUserField4;
      end;{case}

      // Get Link Value
      if (sUDF <> '') then
      begin
        // Get Link from UDF
        iPos := Pos('/', sUDF);
        if iPos > 0 then Result := StrToIntDef(Copy(sUDF,iPos+1,255),0);
      end;{if}
    end;{with}
  end;{GetLinkNoFromLine}

  procedure UpdateWEEELineQuantities;
  var
    WEEEProductDetails : TWEEEProdRec;
    BTRec : TBTRec;
    TL : ITransactionLine;
    iPos, iLink, iIndex, iLine : integer;
    bContinue : boolean;
    slNonWEEELines : TStringList;
    UpdateTX : ITransaction;
    TransLineInfo : TTransLineInfo;
  begin{UpdateWEEELineQuantities}

    // Get Stored Transaction
    oToolkit.Transaction.Index := thIdxOurRef;
    if oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex
    (EventData.Transaction2.thOurRef)) = 0 then
    begin
      // Get WEEW system setup
      GetSysSetupRec;

      // Let's update the TX
      UpdateTX := oToolkit.Transaction.Update;

      if UpdateTX <> nil then
      begin

        OpenFiles;

        slNonWEEELines := TStringList.Create;

        // Go through all lines - to find the non-WEEE Lines
        For iLine := 1 to UpdateTX.thLines.thLineCount do
        begin
          if not IsWEEELineCTK(UpdateTX.thLines.thLine[iLine]) then
          begin
            iLink := GetLinkNoFromLineCTK(UpdateTX.thLines.thLine[iLine]);
            if iLink > 0 then
            begin
              // Found a line that should have a matching WEEE Charge Line
              TransLineInfo := TTransLineInfo.Create;
              TransLineInfo.TL := UpdateTX.thLines.thLine[iLine];
              slNonWEEELines.AddObject(IntToStr(iLink), TransLineInfo);
            end;{if}
          end;{if}
        end;{for}

        // Go through all lines - to find the WEEELines
        For iLine := 1 to UpdateTX.thLines.thLineCount do
        begin
          if IsWEEELineCTK(UpdateTX.thLines.thLine[iLine]) then
          begin
            iLink := GetLinkNoFromLineCTK(UpdateTX.thLines.thLine[iLine]);
            iPos := slNonWEEELines.indexOf(IntToStr(iLink));
            if iPos >= 0 then
            begin
              // Found a line that should have a matching WEEE Charge Line
              TransLineInfo := TTransLineInfo(slNonWEEELines.Objects[iPos]);

              if TransLineInfo <> nil then
              begin
                // Update Quantity Fields
                UpdateTX.thLines.thLine[iLine].tlQty := TransLineInfo.TL.tlQty;
                UpdateTX.thLines.thLine[iLine].tlQtyMul := TransLineInfo.TL.tlQtyMul;
                UpdateTX.thLines.thLine[iLine].tlQtyWOFF := TransLineInfo.TL.tlQtyWOFF;
                UpdateTX.thLines.thLine[iLine].tlQtyDel := TransLineInfo.TL.tlQtyDel;
                UpdateTX.thLines.thLine[iLine].tlQtyPicked := TransLineInfo.TL.tlQtyPicked;
                UpdateTX.thLines.thLine[iLine].tlQtyPickedWO := TransLineInfo.TL.tlQtyPickedWO;
              end;{if}
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

  procedure SetStockLineUDF(TL : TABSInvLine; rWEEEValue : real; iLink : integer);
  var
    iPos : integer;
    sUDF : string;
  begin{SetStockLineUDF}
    with TL do
    begin
      // Get Current UDF Value
      Case SystemSetupRec.TXLineUDF of
        1 : sUDF := tlUserDef1;
        2 : sUDF := tlUserDef2;
        3 : sUDF := tlUserDef3;
        4 : sUDF := tlUserDef4;
      end;{case}

      // Modify UDF Value
      if (sUDF <> '') and (iLink = 0) then
      begin
        // Get Link from UDF
        iPos := Pos('/', sUDF);
        if iPos > 0 then iLink := StrToIntDef(Copy(sUDF,iPos+1,255),0);
      end;{if}

      // Make new UDF
      sUDF := MoneyToStr(rWEEEValue, EventData.Setup3.ssNoNetDec) + '/'
      + IntToStr(iLink);

      // Store UDF Value
      Case SystemSetupRec.TXLineUDF of
        1 : tlUserDef1 := sUDF;
        2 : tlUserDef2 := sUDF;
        3 : tlUserDef3 := sUDF;
        4 : tlUserDef4 := sUDF;
      end;{case}
    end;{with}
  end;{SetStockLineUDF}

  procedure AddEditDeleteWEEELines;

    procedure DeleteAllWEEELines;
    var
      iPrevLineCount, iLine : integer;
    begin{DeleteAllWEEELines}
      with EventData.Transaction2 do
      begin
        iLine := 1;
        while iLine <= thLines.thLineCount do
        begin
          // Depending on system setup define whether this line is a WEEE charge line
          if IsWEEELine(thLines.thLine[iLine]) then
          begin
            // Delete Line
            iPrevLineCount := thLines.thLineCount;
            thLines.thLine[iLine].Delete;
            if iPrevLineCount = thLines.thLineCount then
            begin
              MsgBox('Error : Transaction Line ' + IntToStr(iLine) + ' Could Not be deleted.'
              , mtError, [mbOK], mbOK, 'Delete Line');
            end else
            begin
              Dec(iLine);
            end;
          end;{if}

(*
          Case SystemSetupRec.TXLineUDF of
            1 : begin
              if Copy(thLines.thLine[iLine].tlUserDef1,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line then
              begin
                thLines.thLine[iLine].Delete;
                Dec(iLine);
              end;
            end;

            2 : begin
              if Copy(thLines.thLine[iLine].tlUserDef2,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line then
              begin
                thLines.thLine[iLine].Delete;
                Dec(iLine);
              end;
            end;

            3 : begin
              if Copy(thLines.thLine[iLine].tlUserDef3,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line then
              begin
                thLines.thLine[iLine].Delete;
                Dec(iLine);
              end;
            end;

            4 : begin
              if Copy(thLines.thLine[iLine].tlUserDef4,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line then
              begin
                thLines.thLine[iLine].Delete;
                Dec(iLine);
              end;
            end;

          end;{case}*)
          // next line
          inc(iLine);
        end;{while}
      end;{with}
    end;{DeleteAllWEEELines}

  var
    WEEEProductDetails : TWEEEProdRec;
    BTRec : TBTRec;
    iIndex, iLine : integer;
    bContinue : boolean;
    sUDF : string;

  begin{AddEditDeleteWEEELines}
    // Get WEEW system setup
    GetSysSetupRec;

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

      // Delete WEEE Charge Lines
      DeleteAllWEEELines;

      OpenFiles;

      // Add WEEE Charge Lines
      bContinue := FALSE;

      with EventData.Transaction2, thLines do
      begin

        // Go through all lines
        For iLine := 1 to thLineCount do
        begin
          // Get WEEE Product Details from the database
          BTRec.KeyS := PadString(psRight, thLine[iLine].tlStockCode, ' ', 16);
          BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEProdF], WEEEProductDetails
          , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);

          // If WEEE Details found
          if BTRec.Status = 0 then
          begin
            // Populate new line details
            bContinue := TRUE;
            AddNewLine;
  //              TL.tlStockCode := WEEEProductDetails.wpExtraChargeStockCode;

            thCurrentline.tlQty := thLine[iLine].tlQty;
//            thCurrentline.tlQtyWOFF := thLine[iLine].tlQtyWOFF;
//            thCurrentline.tlQtyDel := thLine[iLine].tlQtyDel;
//            thCurrentline.tlQtyPicked := thLine[iLine].tlQtyPicked;
//            thCurrentline.tlQtyPickedWO := thLine[iLine].tlQtyPickedWO;
            thCurrentline.tlNetValue := WEEEProductDetails.wpValue;
            thCurrentline.tlCostCentre := thLine[iLine].tlCostCentre;
            thCurrentline.tlDepartment := thLine[iLine].tlDepartment;
            thCurrentline.tlLocation := thLine[iLine].tlLocation;

  thCurrentline.tlGLCode := thLine[iLine].tlGLCode;
  thCurrentline.tlDescr := 'WEEE Charge for ' + thLine[iLine].tlStockCode;

            Case SystemSetupRec.TXLineUDF of
              1 : thCurrentline.tlUserDef1 := WEEE_Charge_Line + '/' + IntToStr(iLine);
              2 : thCurrentline.tlUserDef2 := WEEE_Charge_Line + '/' + IntToStr(iLine);
              3 : thCurrentline.tlUserDef3 := WEEE_Charge_Line + '/' + IntToStr(iLine);
              4 : thCurrentline.tlUserDef4 := WEEE_Charge_Line + '/' + IntToStr(iLine);
            end;{case}

            // Save new line
            thCurrentline.Save;

            // Update Stock Line so we have a link between the 2 lines
            SetStockLineUDF(thLine[iLine], WEEEProductDetails.wpValue, iLine);

{            sUDF := MoneyToStr(WEEEProductDetails.wpValue, EventData.Setup3.ssNoNetDec)
            + '/' + IntToStr(iLine);
            Case SystemSetupRec.TXLineUDF of
              1 : thLine[iLine].tlUserDef1 := sUDF;
              2 : thLine[iLine].tlUserDef2 := sUDF;
              3 : thLine[iLine].tlUserDef3 := sUDF;
              4 : thLine[iLine].tlUserDef4 := sUDF;
            end;{case}
            thLine[iLine].Save;
          end;{if}
        end;{for}

        if bContinue and (thInvDocHed in [CUSCR,CUSJC,CUSRF]) then
        begin
          iIndex := slTXs.IndexOf(thOurRef);
          if iIndex >= 0 then
          begin
            slTXs.delete(iIndex);
            DeleteAllWEEELines;
          end;

  {            if MsgBox('WEEE products exist on this transaction.'#13#13
          + 'Do you want WEE Credit Lines to exist for this transction ?',mtConfirmation,[mbYes, mbNo], mbYes
          , 'WEEE Lines') = mrNo then
          begin
            DeleteAllWEEELines;
          end;}
        end;{if}

        CloseFiles;

      end;{with}
    end;{if}
  end;{AddEditDeleteWEEELines}

  procedure DisplayWEEEOptions;
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

var
  rWEEEValue : real;
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

              // Is Stock Item a WEEE Stock Item ?
              Case SystemSetupRec.StockUDF of
                1 : bWEEE := UpperCase(EventData.Stock3.stStkUser1) = 'YES';
                2 : bWEEE := UpperCase(EventData.Stock3.stStkUser2) = 'YES';
                3 : bWEEE := UpperCase(EventData.Stock3.stStkUser3) = 'YES';
                4 : bWEEE := UpperCase(EventData.Stock3.stStkUser4) = 'YES';
              end;{case}

              // See if WEEE Record is setup in the database
              if bWEEE then
              begin
                OpenFiles;
                if not GetWEEEValue(EventData.Stock3.stCode, rWEEEValue) then
                begin
                  if MsgBox('You have set this stock record to be a WEEE item, but have not setup the WEEE parameters.'
                  + #13#13 + 'Do you wish to setup these parameters now ?' , mtConfirmation
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
              // WEEE Options Button
              if HandlerID = iStockBtnHookId then
              begin
                // Read in WEEE System Setup
                GetSysSetupRec;

                // Is Stock Item a WEEE Stock Item ?
                Case SystemSetupRec.StockUDF of
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
              // Only do stuff for SCRs SJCs ans SRFs
              if (EventData.Transaction2.thInvDocHed in [CUSCR,CUSJC,CUSRF]) then
              begin
                if MsgBox('WEEE products exist on this transaction.'#13#13
                + 'Do you want WEE Credit Lines to exist for this transction ?',mtConfirmation,[mbYes, mbNo], mbYes
                , 'WEEE Lines') = mrNo then
                begin
                  // Cache up transaction OurRef for later (after store TX)
                  slTXs.Add(EventData.Transaction2.thOurRef);
                end;
              end;{if}


              // Check TX Type
              if EventData.Transaction2.thInvDocHed
              in [CUSIN,{CUSRC,}CUSCR,CUSJI,CUSJC,{CUSRF,CUSRI,}CUSQU,CUSOR] then
              begin
                // Resync WEEE Lines (add edit or delete)
                AddEditDeleteWEEELines;
              end;{if}
            end;

            AFTER_STORE_TX {, CONVERT_SDN_TO_SIN, } : begin
              // Only do stuff for SINs,SRCs,SCRs,SJIs,SJCs,SRFs,SRIs,SQUs & SORs
              if EventData.Transaction2.thInvDocHed
//              in [CUSIN,CUSRC,CUSCR,CUSJI,CUSJC,CUSRF,CUSRI,CUSQU,CUSOR] then
              // changed cos toolkit does not allow updating of SRFs, SRIs or SRCs
              in [CUSIN,{CUSRC,}CUSCR,CUSJI,CUSJC,{CUSRF,CUSRI,}CUSQU,CUSOR] then
              begin
                // Resync Quantities WEEE Lines (add edit or delete)
                StartToolkit(EventData);
                UpdateWEEELineQuantities;
                oToolkit.CloseToolkit;
                oToolkit := nil;
              end;
            end;
          end;{case}
        end;

        wiTransLine : begin {4000}
          case HandlerID of
            EXIT_STOCK_CODE, BEFORE_STORE_LINE : begin
              if EventData.Transaction2.thInvDocHed
              in [CUSIN,CUSRC,CUSCR,CUSJI,CUSJC,CUSRF,{CUSRI,}CUSQU,CUSOR] then
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
                      // Get the WEEE value
                      GetWEEEValue(EventData.Transaction2.thLines.thCurrentLine.tlStockCode, rWEEEValue);

                      // store it in the defined UD Field
                      SetStockLineUDF(EventData.Transaction2.thLines.thCurrentLine, rWEEEValue
                      , 0 {GetLinkNoFromLine(UpdateTX.thLines.thLine[iLine])});

{                      Case SystemSetupRec.TXLineUDF of
                        1 : tlUserDef1 := GetStockLineUDF(tlUserDef1, rWEEEValue);
                        2 : tlUserDef2 := GetStockLineUDF(tlUserDef2, rWEEEValue);
                        3 : tlUserDef3 := GetStockLineUDF(tlUserDef3, rWEEEValue);
                        4 : tlUserDef4 := GetStockLineUDF(tlUserDef4, rWEEEValue);
                      end;{case}
                    end;{if}
                  end;

                  AFTER_STORE_LINE : begin
                    // Read in WEEE System Setup
                    GetSysSetupRec;

                    // Is Stock Item a WEEE Stock Item ?
                    Case SystemSetupRec.StockUDF of
                      1 : bWEEE := UpperCase(EventData.Stock3.stStkUser1) = 'YES';
                      2 : bWEEE := UpperCase(EventData.Stock3.stStkUser2) = 'YES';
                      3 : bWEEE := UpperCase(EventData.Stock3.stStkUser3) = 'YES';
                      4 : bWEEE := UpperCase(EventData.Stock3.stStkUser4) = 'YES';
                    end;{case}

                    if bWEEE then
                    begin

                    end;{if}
                  end;
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
