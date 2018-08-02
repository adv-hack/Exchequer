unit WEEEProc;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  CustABSU, BTFiles, SysUtils, {GlobVar, BtrvU2,} Forms, Controls, Dialogs
  , BTUtil, BTConst, Enterprise01_TLB;

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
    bCurrentCompany : boolean;
  end;

  TReportCatInfo = Class
    Details : TWEEEReportCatRec;
  end;

  TWEEEProdInfo = Class
    Details : TWEEEProdRec;
  end;

  TReportSubCatInfo = Class
    Details : TWEEEReportSubCatRec;
  end;

  TSystemSetupRec = Record
    ProductGroup : string[16];
    StockFlagUDF : integer;
    StockEMCUDF : integer;
    StockITCUDF : integer;
    CustomerUDF : integer;
    SupplierUDF : integer;
    TXLineUDF : integer;
    ShowWEEEValuePopup : boolean;
  end;

const
  WEEE_Charge_Line = 'WEEE';
  sWEEEiniName = 'WEEE.ini';
  CLEAR_UDF = -1;

var
  oToolkit : IToolkit;
  CompanyRec : TCompanyRec;
  SystemSetupRec : TSystemSetupRec;
//  LockPos : longint;

  function GetNextFolio(iFileNo : integer) : integer;
  procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
  procedure GetSysSetupRec;
  Function GetWEEEValue(sCode : string; var rValue : real) : boolean;
  function GetNextLinkLineNo(TX : TABSInvoice) : integer;
  function IsWEEEStockItem(Stock : TAbsStock3) : boolean;
  function IsWEEEStockItemCTK(Stock : IStock) : boolean;
  function GetLinkNoFromLine(TL : TABSInvLine) : integer;
  function GetLinkNoFromLineCTK(TL : ITransactionLine) : integer;
  function IsWEEELine(TL : TAbsInvLine) : boolean;
  function IsWEEELineCTK(TL : ITransactionLine) : boolean;
  procedure SetTXLineUDF(TL : TABSInvLine; rWEEEValue : real; iLink, iNoDecs : integer);
  procedure SetTXLineUDFCTK(TL : ITransactionLine; rWEEEValue : real; iLink, iNoDecs : integer);
  function IsWEEECustomerCTK(oCust : IAccount) : boolean;

//  function LockRecord : Smallint;
//  function UnlockRecord : Smallint;


implementation
uses
  StrUtil, Inifiles, SecCodes, ComObj;
(*
function LockRecord : Smallint;
begin
  Result := BTGetPos(btFileVar[WEEEF], WEEEF, btBufferSize[WEEEF], LockPos);

  if Result = 0 then
  begin
    Move(LockPos, RecPtr[WEEEF]^, SizeOf(LockPos));

        // Return To Original Record position
        move(iRecPos,VProductRec,sizeof(iRecPos));
        BTShowError(BTGetDirect(FileVar[VProductF], VProductF, VProductRec, BufferSize[VProductF]
        , vpIdxGetProdForContract, 0), 'BTGetDirect', vcFileName[VProductF]);


    Result := GetDirect(btFileVar[WEEEF], WEEEF, RecPtr[WEEEF]^, weStockCodeIdx
    , B_SingLock + B_SingNWLock);
  end;
end;

function UnlockRecord : Smallint;
var
  KeyS : Str255;
begin
   FillChar(KeyS, SizeOf(KeyS), #0);
   Move(LockPos, RecPtr[WEEEF]^, SizeOf(LockPos));
   Result := Find_Rec(B_Unlock, F[WEEEF], WEEEF, RecPtr[WEEEF]^,
                        0, KeyS);
   if Result <> 0 then
     ShowMessage('Error ' + IntToStr(Result) + ' unlocking record');
end;
*)
procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
var
  a, b, c : LongInt;
  FuncRes : integer;
begin{StartToolkit}
  // Create COM Toolkit object
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    With oToolkit Do Begin
      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);

      oToolkit.Configuration.OverwriteTransactionNumbers := TRUE;

//      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;
      oToolkit.Configuration.AutoSetTransCurrencyRates := FALSE;

      // Open Default Company
      oToolkit.Configuration.DataDirectory := LEventData.Setup.ssDataPath;
      FuncRes := OpenToolkit;

      // Check it opened OK
      If (FuncRes = 0) then {DoUpdates}
      else begin
        // Error opening Toolkit - display error
        ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
        + QuotedStr(oToolkit.LastErrorString));
      end;{if}

    End; { With OToolkit }

  End { If Assigned(oToolkit) }
  Else
    // Failed to create COM Object
    ShowMessage ('Cannot create COM Toolkit instance');

end;{StartToolkit}

function GetNextFolio(iFileNo : integer) : integer;
var
  ReportCatRec : TWEEEReportCatRec;
  ReportSubCatRec : TWEEEReportSubCatRec;
  BTRec : TBTRec;
begin
  Result := 1;

  case iFileNo of

    WEEEReportCatF : begin
      BTRec.Status := BTFindRecord(BT_GetLast, btFileVar[iFileNo], ReportCatRec, btBufferSize[iFileNo]
      , wrcIdxFolio, BTRec.KeyS);
      if BTRec.Status = 0 then Result := ReportCatRec.wrcFolioNo + 1;
    end;

    WEEEReportSubCatF : begin
      BTRec.Status := BTFindRecord(BT_GetLast, btFileVar[iFileNo], ReportSubCatRec, btBufferSize[iFileNo]
      , wscIdxFolio, BTRec.KeyS);
      if BTRec.Status = 0 then Result := ReportSubCatRec.wscFolioNo + 1;
    end;

  end;{case}
end;

procedure GetSysSetupRec;
var
  WEEEini : Tinifile;
begin
  WEEEini := Tinifile.Create(CompanyRec.Path + sWEEEiniName);
  with SystemSetupRec do
  begin
    StockFlagUDF := WEEEini.ReadInteger('Setup','StockFlagUDF',1);
    StockEMCUDF := WEEEini.ReadInteger('Setup','StockEMCUDF',1);
    StockITCUDF := WEEEini.ReadInteger('Setup','StockITCUDF',1);
    CustomerUDF := WEEEini.ReadInteger('Setup','CustomerUDF',1);
    SupplierUDF := WEEEini.ReadInteger('Setup','SupplierUDF',1);
    TXLineUDF := WEEEini.ReadInteger('Setup','TXLineUDF',1);
    ProductGroup := Trim(WEEEini.ReadString('Setup','ProductGroup',''));
    ShowWEEEValuePopup := UpperCase(Trim(WEEEini.ReadString('Setup','ShowWEEEValuePopup','NO'))) = 'YES';
  end;{with}
  WEEEini.Free;
end;

Function GetWEEEValue(sCode : string; var rValue : real) : boolean;
// Gets the WEEE Extra Charge value from the WEEE Database
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

function GetLinkNoFromLine(TL : TABSInvLine) : integer;
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
      1 : sUDF := tlUserDef1;
      2 : sUDF := tlUserDef2;
      3 : sUDF := tlUserDef3;
      4 : sUDF := tlUserDef4;
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

function GetNextLinkLineNo(TX : TABSInvoice) : integer;
// Gets the next available link number
// The Link number is a unique number that links the WEEE Charge Line to the Stock Line that it is for
var
  iLine, iLink, iBiggest : integer;
begin{GetNextLinkLineNo}
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
end;{GetNextLinkLineNo}

function IsWEEEStockItem(Stock : TAbsStock3) : boolean;
// Does the Stock Item incurr a WEEE charge ?
begin{IsWEEEStockItem}
  Result := FALSE;
  Case SystemSetupRec.StockFlagUDF of
    1 : Result := UpperCase(Stock.stStkUser1) = 'YES';
    2 : Result := UpperCase(Stock.stStkUser2) = 'YES';
    3 : Result := UpperCase(Stock.stStkUser3) = 'YES';
    4 : Result := UpperCase(Stock.stStkUser4) = 'YES';
  end;{case}
end;{IsWEEEStockItem}

function IsWEEEStockItemCTK(Stock : IStock) : boolean;
// Does the Stock Item incurr a WEEE charge ?
begin{IsWEEEStockItem}
  Result := FALSE;
  Case SystemSetupRec.StockFlagUDF of
    1 : Result := UpperCase(Stock.stUserField1) = 'YES';
    2 : Result := UpperCase(Stock.stUserField2) = 'YES';
    3 : Result := UpperCase(Stock.stUserField3) = 'YES';
    4 : Result := UpperCase(Stock.stUserField4) = 'YES';
  end;{case}
end;{IsWEEEStockItem}

function IsWEEELine(TL : TAbsInvLine) : boolean;
// Is this line a WEEE Charge Line ?
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
// Is this line a WEEE Charge Line ?
begin{IsWEEELine}
  Result := FALSE;
  Case SystemSetupRec.TXLineUDF of
    1 : Result := Copy(TL.tlUserField1,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
    2 : Result := Copy(TL.tlUserField2,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
    3 : Result := Copy(TL.tlUserField3,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
    4 : Result := Copy(TL.tlUserField4,1,Length(WEEE_Charge_Line)) = WEEE_Charge_Line;
  end;{case}
end;{IsWEEELine}

function GetLinkNoFromLineCTK(TL : ITransactionLine) : integer;
// Reads the Link number from the transaction line UDF
// The Link number is a unique number that links the WEEE Charge Line to the Stock Line that it is for
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

procedure SetTXLineUDF(TL : TABSInvLine; rWEEEValue : real; iLink, iNoDecs : integer);
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
      1 : tlUserDef1 := sUDF;
      2 : tlUserDef2 := sUDF;
      3 : tlUserDef3 := sUDF;
      4 : tlUserDef4 := sUDF;
    end;{case}
  end;{with}
end;{SetTXLineUDF}

procedure SetTXLineUDFCTK(TL : ITransactionLine; rWEEEValue : real; iLink, iNoDecs : integer);
// Populate the Transaction line User Defined Field
// This is usually called for the Stock Line, and the format is : WEEEValue/LinkNumber
var
  iPos : integer;
  sUDF : string;
begin{SetTXLineUDFCTK}
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
end;{SetTXLineUDFCTK}

function IsWEEECustomerCTK(oCust : IAccount) : boolean;
begin
  Result := FALSE;
  if Assigned(oCust) then
  begin
    Case SystemSetupRec.CustomerUDF of
      1 : Result := Trim(UpperCase(oCust.acUserDef1)) = 'YES';
      2 : Result := Trim(UpperCase(oCust.acUserDef2)) = 'YES';
      3 : Result := Trim(UpperCase(oCust.acUserDef3)) = 'YES';
      4 : Result := Trim(UpperCase(oCust.acUserDef4)) = 'YES';
    end;{case}
  end;{if}
end;



end.



