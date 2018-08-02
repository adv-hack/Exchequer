unit ExchTypes;

interface

uses Enterprise01_TLB;

type
  TVATType = (Standard,Exempt,Zero,Rate1,Rate2,Rate3,Rate4,Rate5,Rate6,
             Rate7,Rate8,Rate9,Rate10,Rate11,Rate12,Rate13,Rate14,Rate15,Rate16,
             Rate17,Rate18,IAdj,OAdj,Spare8);

  TVATAnalysisType = array[TVATType] of Boolean;

const
  PurchSplit  = [dtPIN,dtPPY,dtPCR,dtPJI,dtPJC,dtPRF,dtPPI,dtPQU,dtPOR,dtPDN,dtPBT];
  SalesSplit  = [dtSIN,dtSRC,dtSCR,dtSJI,dtSJC,dtSRF,dtSRI,dtSQU,dtSOR,dtSDN,dtSBT];
  PSOPSet     = [dtSOR,dtPOR,dtSDN,dtPDN];
  OrderSet    = [dtSOR,dtPOR];
  DeliverSet  = [dtPDN,dtSDN];
  ReceiptCode = 2147483647;

  VATEECCode  = 'A';
  VATECDCode  = 'D';
  VATICode    = 'I';
  VATMCode    = 'M';


  VATCodeList: array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
  VATSet: set of char = [VATEECCode,VATECDCode,'S','E','Z','M','I','1'..'9','T','X','B','C','F','G','R','W','Y'];
  VATEqStd: set of char = [VATMCode, VATICode];
  VATEqRt3: set of char = [VATEECCode];
  VATEqRt4: set of char = [VATECDCode];
  VStart: TVATType = Standard;
  VEnd  : TVATType = Rate18;

  { Price Band ranges }
  StkBandSet  = ['A'..'H'];

  GenPcntMask   = ' #0.0%;-#0.0%';
  GenRealMask   = '###,###,##0.00 ;###,###,##0.00-';
  GenPcnt2dMask = ' #0.00%;-#0.00%';

function ExtractChar(const Value: WideString; const ReturnChar: Char): Char;
function DivWChk(Divide, Divisor: Real): Real;
function CaseQty(oToolkit: IToolkit; BaseQty: Double): Double;
function Calc_IdQty(Qty, QtyMul: Double; UsePack: Boolean): Double;
function PPR_PAmountStr(Discount: Real; DiscCh: Char): String;
function CurrencySymbol(Toolkit: IToolkit; Currency: Integer): string;

implementation

uses SysUtils, ETStrU;

function ExtractChar(const Value: WideString; const ReturnChar: Char): Char;
var
  S: string[1];
begin
  S := Copy (Value, 1, 1) + ReturnChar;
  Result := S[1];
end;

function DivWChk(Divide, Divisor: Real): Real;
begin
  if (Divisor <> 0) then
    Result := Divide / Divisor
  else
    Result := 0;
end;

function CaseQty(oToolkit: IToolkit; BaseQty: Double): Double;
var
  DecStr,
  TmpStr: string[20];
  CQty,EQty,
  RatQty: Double;
  MDec  : Byte;
  oStock: IStock;
begin
  Result := BaseQty;
  MDec:=0;
  oStock := oToolkit.Stock;
  if (oStock <> nil) and (oStock.stShowQtyAsPacks) then
  begin
    RatQty := DivWChk(BaseQty, oStock.stSalesUnits);

    MDec := oToolkit.SystemSetup.ssQtyDecimals; // Syss.NoQtyDec;
    If (MDec < 4) then
      MDec := MDec + 4;

    CQty := Trunc(oToolkit.Functions.entRound(RatQty, MDec));
    EQty := oToolkit.Functions.entRound((BaseQty - (Cqty * oStock.stSalesUnits)),0);

    If (oToolkit.SystemSetup.ssQtyDecimals > 1) or
       (oStock.stSalesUnits > 10) then
      DecStr := SetPadNo(Form_Int(Round(ABS(EQty)), 0), oToolkit.SystemSetup.ssQtyDecimals)
    else
      DecStr := Form_Real(ABS(EQty), 0, 0);

    TmpStr := Form_Real(CQty, 0, 0) + '.' + DecStr;

    If (CQty = 0.0) and (EQty < 0) then
      TmpStr := '-' + TmpStr;

    Result := oToolkit.Functions.entRound(StrToFloat(TmpStr), oToolkit.SystemSetup.ssQtyDecimals);
  end;
end; {Func..}

function Calc_IdQty(Qty, QtyMul: Double; UsePack: Boolean): Double;
begin
  If (UsePack) then
    Result := Qty * QtyMul
  else
    Result := Qty;
end;

function PPR_PAmountStr(Discount: Real; DiscCh: Char): String;
var
  GenStr: String;
  PDecs : LongInt;
begin
  GenStr := '';
  PDecs  := 2;
  if (Discount = 0) and (not (DiscCh in StkBandSet)) then
    GenStr := ''
  else
  begin
    if (DiscCh = '%') then
      GenStr := FormatFloat(GenPcnt2dMask, Discount * 100)
    else
      if (DiscCh in StkBandSet) then
        GenStr := DiscCh
      else
        GenStr := FormatFloat(GenRealMask,Discount);
  end;
  Result := GenStr;
end;

function CurrencySymbol(Toolkit: IToolkit; Currency: Integer): string;
begin
  if Trim(Toolkit.SystemSetup.ssCurrency[Currency].scSymbol) = #156 then
    Result := '£'
  else
    Result := Toolkit.SystemSetup.ssCurrency[Currency].scSymbol;
end;

end.
