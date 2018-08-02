unit oClient;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  EnterpriseTrade_TLB, ComObj, ActiveX, EnterpriseTradePlugIn_TLB, StdVcl;

type
  TWEEE = class(TAutoObject, IWEEE, ITradeClient)
  protected
    procedure OnConfigure(const Config: ITradeConfiguration); safecall;
    procedure OnStartup(const BaseData: ITradeConnectionPoint); safecall;
    procedure OnCustomEvent(const EventData: ITradeEventData); safecall;
    procedure OnCustomText(const CustomText: ITradeCustomText); safecall;
    procedure OnShutdown; safecall;
  private
    lBaseData: ITradeConnectionPoint;
  end;

implementation

uses
  BTUtil, BTConst, BTFiles, WEEEProc, StrUtil, Forms, PISecure, ComServ, SysUtils, ExchequerRelease;

{ TWEEE }

procedure TWEEE.OnConfigure(const Config: ITradeConfiguration);
begin

end;

procedure TWEEE.OnCustomEvent(const EventData: ITradeEventData);
var
  iPos{, iLine} : integer;
//  bLastLineIsEOT : boolean;
  WEEEProductDetails : TWEEEProdRec;
  BTRec : TBTRec;

  procedure AddWEEEChargeLineFor(OriginalLine : ITradeEventTransLine; iLink : integer);

    Procedure SetWEEEChargeLine(TL : ITradeEventTransLine);
    begin{SetWEEEChargeLine}
      Case SystemSetupRec.TXLineUDF of
        1 : TL.tlUserField1 := WEEE_Charge_Line;
        2 : TL.tlUserField2 := WEEE_Charge_Line;
        3 : TL.tlUserField3 := WEEE_Charge_Line;
        4 : TL.tlUserField4 := WEEE_Charge_Line;
      end;{case}
    end;{SetWEEEChargeLine}

  begin{AddWEEEChargeLine}
    EventData.Transaction.thLines.Add;

    EventData.Transaction.thLines.thCurrentLine.tlQty := OriginalLine.tlQty;
//    EventData.Transaction.thLines.thCurrentLine.tlQtyWOFF := OriginalLine.tlQtyWOFF;
//    EventData.Transaction.thLines.thCurrentLine.tlQtyDel := OriginalLine.tlQtyDel;
    EventData.Transaction.thLines.thCurrentLine.tlQtyPicked := OriginalLine.tlQtyPicked;
//    EventData.Transaction.thLines.thCurrentLine.tlQtyPickedWO := OriginalLine.tlQtyPickedWO;
    EventData.Transaction.thLines.thCurrentLine.tlNetValue := WEEEProductDetails.wpValue;
    EventData.Transaction.thLines.thCurrentLine.tlCostCentre := OriginalLine.tlCostCentre;
    EventData.Transaction.thLines.thCurrentLine.tlDepartment := OriginalLine.tlDepartment;
//      EventData.Transaction.thLines.thCurrentLine.tlLocation := OriginalLine.tlLocation;
    EventData.Transaction.thLines.thCurrentLine.tlGLCode := OriginalLine.tlGLCode;
    EventData.Transaction.thLines.thCurrentLine.tlVATCode := 'E';
//    EventData.Transaction.thLines.thCurrentLine.tlInclusiveVATCode := 'S';
    EventData.Transaction.thLines.thCurrentLine.tlDescr := 'WEEE Charge for ' + OriginalLine.tlStockCode;
    Case SystemSetupRec.TXLineUDF of
      1 : EventData.Transaction.thLines.thCurrentLine.tlUserField1 := WEEE_Charge_Line + '/' + IntToStr(iLink);
      2 : EventData.Transaction.thLines.thCurrentLine.tlUserField2 := WEEE_Charge_Line + '/' + IntToStr(iLink);
      3 : EventData.Transaction.thLines.thCurrentLine.tlUserField3 := WEEE_Charge_Line + '/' + IntToStr(iLink);
      4 : EventData.Transaction.thLines.thCurrentLine.tlUserField4 := WEEE_Charge_Line + '/' + IntToStr(iLink);
    end;{case}

    EventData.Transaction.thLines.thCurrentLine.Save;
  end;{AddWEEEChargeLine}

  Function IsWEEELineTCM(TL : ITradeEventTransLine) : Boolean;
  begin{IsWEEELineTCM}
    Result := FALSE;
    Case SystemSetupRec.TXLineUDF of
      1 : Result := Copy(TL.tlUserField1,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
      2 : Result := Copy(TL.tlUserField2,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
      3 : Result := Copy(TL.tlUserField3,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
      4 : Result := Copy(TL.tlUserField4,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
    end;{case}
  end;{IsWEEELineTCM}

  function GetLinkNoFromLine(TL : ITradeEventTransLine) : integer;
  // Reads the Link number from the transaction line UDF
  // The Link number is a unique number that links the WEEE Charge Line to the Stock Line that it is for
  var
    sUDF : string;
    iLink, iPos : integer;
  begin{GetLinkNoFromLine}
    Result := -1;
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
        if iPos > 0 then
        begin
          iLink := StrToIntDef(Copy(sUDF,iPos+1,255),0);
          if iLink > 0 then Result := iLink;
        end;{if}
      end;{if}
    end;{with}
  end;{GetLinkNoFromLine}

  function GetNextLinkLineNoTCM(TX : ITradeEventTransaction) : integer;
  // Gets the next available link number
  // The Link number is a unique number that links the WEEE Charge Line to the Stock Line that it is for
  var
    iLine, iLink, iBiggest : integer;
  begin{GetNextLinkLineNoTCM}
    // Go through all lines - to find the biggest Lnk No
    iBiggest := 0;
    with TX do begin
      For iLine := 1 to thLines.thLineCount do
      begin
        iLink := GetLinkNoFromLine(thLines.thLine[iLine]);
        if iLink > iBiggest
        then iBiggest := iLink;
      end;{for}
    end;{with}

    Result := iBiggest + 1;
  end;{GetNextLinkLineNoTCM}

  procedure SetTXLineUDFTCM(TL : ITradeEventTransLine; rWEEEValue : real; iLink, iNoDecs : integer);
  // Populate the Transaction line User Defined Field
  // This is usually called for the Stock Line, and the format is : WEEEValue/LinkNumber
  var
    iPos : integer;
    sUDF : string;
  begin{SetTXLineUDF}
    with TL do
    begin
      // Get Current UDF Value
      Case SystemSetupRec.TXLineUDF of
        1 : sUDF := tlUserField1;
        2 : sUDF := tlUserField2;
        3 : sUDF := tlUserField3;
        4 : sUDF := tlUserField4;
      end;{case}

      // Modify UDF Value
      if (sUDF <> '') and (iLink = 0) then
      begin
        // Get Link from UDF
        iPos := Pos('/', sUDF);
        if iPos > 0 then iLink := StrToIntDef(Copy(sUDF,iPos+1,255),0);
      end;{if}

      if iLink = CLEAR_UDF then
      begin
        //  Clear UDF
        sUDF := '';
      end else
      begin
        // Make new UDF
        sUDF := MoneyToStr(rWEEEValue, iNoDecs) + '/'
        + IntToStr(iLink);
      end;{if}

      // Store New UDF Value
      Case SystemSetupRec.TXLineUDF of
        1 : tlUserField1 := sUDF;
        2 : tlUserField2 := sUDF;
        3 : tlUserField3 := sUDF;
        4 : tlUserField4 := sUDF;
      end;{case}
    end;{with}
  end;{SetTXLineUDF}

var
  iLink : integer;
begin
  if (EventData.edWindowId = twiTransaction) and (EventData.edHandlerId = hpTXBeforeTenderScreen) then
  begin
    // Before Tender Screen

    GetSysSetupRec;
    CompanyRec.Path := lBaseData.SystemSetup.ssTradeCounter.ssTill[lBaseData.SystemSetup.ssTradeCounter.ssCurrentTillNo].ssCompany.coPath;
    OpenFiles;

    // Delete all WEEE Lines
(*    iPos := 0;
    repeat
      inc(iPos);
      if iPos < EventData.Transaction.thLines.thLineCount then
      begin
        if IsWEEELineTCM(EventData.Transaction.thLines.thLine[iPos])
        then begin
          EventData.Transaction.thLines.Delete(iPos);
          iPos := 0; // start again from the beginning
        end;{if}
      end;{if}
    until iPos >= EventData.Transaction.thLines.thLineCount;
    *)

    // Delete all WEEE Lines
    iPos := 1;
    while iPos <= EventData.Transaction.thLines.thLineCount do
    begin
      if IsWEEELineTCM(EventData.Transaction.thLines.thLine[iPos]) then
      begin
        EventData.Transaction.thLines.Delete(iPos);
        iPos := 0; // start again from the beginning
      end;{if}
      inc(iPos);
    end;{while}

    // Add New WEEE Lines
    For iPos := 1 to EventData.Transaction.thLines.thLineCount do
    begin

      // Get WEEE Product Details from the database
      BTRec.KeyS := PadString(psRight, EventData.Transaction.thLines.thLine[iPos].tlStockCode
      , ' ', 16);
      BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEProdF], WEEEProductDetails
      , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);

      // If WEEE Details found
      if BTRec.Status = 0 then
      begin

        iLink := GetNextLinkLineNoTCM(EventData.transaction);

        // Add WEEE Line
        AddWEEEChargeLineFor(EventData.Transaction.thLines.thLine[iPos], iLink);

        // Update Stock Line UDF so we have a link between the 2 lines
        SetTXLineUDFTCM(EventData.Transaction.thLines.thLine[iPos], WEEEProductDetails.wpValue
        , iLink, lBaseData.SystemSetup.ssEnterprise.ssSalesDecimals);
      end;{if}
    end;{for}

    CloseFiles;
  end;{if}
end;

procedure TWEEE.OnCustomText(const CustomText: ITradeCustomText);
begin

end;

procedure TWEEE.OnShutdown;
begin
  lBaseData := nil;
end;

procedure TWEEE.OnStartup(const BaseData: ITradeConnectionPoint);
const
  sPlugInName = 'WEEE Plug-In';
  {$IFDEF EX600}
    sVersionNo = '008';
//    sVersionNo = 'v6.00.006';
  {$ELSE}
    sVersionNo = 'v5.70.006';
  {$ENDIF}
begin
  BaseData.piCustomisationSupport := 'v1.00';
  BaseData.piVersion := ExchequerModuleVersion (emGenericPlugIn, sVersionNo);
  BaseData.piName := sPlugInName;

  if PICheckSecurity('EXCHWEEEPI000034', 'sss!2""24-ds,,e4', sPlugInName
  , '', stSystemOnly, ptTCM, Application.ExeName) then
  begin
    BaseData.piAuthor := 'Advanced Enterprise Software';
    BaseData.piCopyright := GetCopyrightMessage;
    BaseData.piSupport := 'Contact your Exchequer helpline number';

    lBaseData := BaseData;
    lBaseData.piHookPoints[twiTransaction,hpTXBeforeTenderScreen] := thsEnabled;

  end else
  begin
    BaseData.piAuthor := '  ///////////////////////////////////////////////////////';
    BaseData.piSupport := '//// THIS PLUG-IN HAS EXPIRED ////';
    BaseData.piCopyright := '               ///////////////////////////////////////////////////////';
  end;{if}
end;

initialization
  TAutoObjectFactory.Create(ComServer, TWEEE, Class_WEEE,
    ciSingleInstance, tmApartment);
end.
