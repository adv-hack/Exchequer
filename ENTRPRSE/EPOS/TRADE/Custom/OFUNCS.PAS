unit oFuncs;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, UseDLLU, SysUtils, VarRec2U
  , CurrncyU;

type
  TTradeFunctions = class(TAutoIntfObject, ITradeFunctions)
  private
    FTradehWnd : THandle;
  protected
    // ITradeFunctions
    function Get_fnTradehWnd: Integer; safecall;
    procedure entActivateClient(ClientHandle: Integer); safecall;
    function entFormatDate(const EntDateStr: WideString; const DateFormat: WideString): WideString; safecall;
    function entRound(Value: Double; Decs: Integer): Double; safecall;
    function entFormatPeriodYear(Period: Integer; Year: Integer): WideString; safecall;
    function entConvertAmount(Amount: Double; FromCurrency: Integer; ToCurrency: Integer;
                              RateType: Integer): Double; safecall;
    function entConvertDateToPeriod(const DateString: WideString; var FinancialPeriod: Integer;
                                    var FinancialYear: Integer): Integer; safecall;
    function entConvertAmountWithRates(Amount: Double; ConvertToBase: WordBool;
                                       RateCurrency: Integer; CompanyRate: Double; DailyRate: Double): Double; safecall;
    procedure entOpenCashDrawer(COMPort: Integer; BaudRate: TTradeBaudRate;
                                const KickOutCodes: WideString); safecall;
  public
    Property TradehWnd : THandle Read FTradehWnd Write FTradehWnd;

    Constructor Create;
  End; { TTradeFunctions }

implementation

//uses ComServ, etDateU, etMiscU, etStrU, FirstU, ComnU2, MiscFunc, DLLTH_Up,
//     GlobVar, VarConst, VarRec2U, DLLMiscU, CurrncyU, ComDLL1, Security;

uses
  ComServ, Windows, oVersion, EPOSProc, etDateU, ComnU2, etMiscU;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeFunctions.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeFunctions);

End; { Create }

{-------------------------------------------------------------------------------------------------}

procedure TTradeFunctions.entActivateClient(ClientHandle: Integer);
begin
  SetForeGroundWindow (ClientHandle);
end;

{-------------------------------------------------------------------------------------------------}

function TTradeFunctions.entConvertAmount(Amount: Double; FromCurrency,
  ToCurrency, RateType: Integer): Double;
Var
  FromCcy, ToCcy, Res, RType : SmallInt;
  FAmount                    : Double;
  FVersionO     : TTradeVersion;
begin { entConvertAmount }

  FVersionO := TTradeVersion.Create;

  FromCcy := FVersionO.ValidateCurrencyNo(FromCurrency);
  ToCcy   := FVersionO.ValidateCurrencyNo(ToCurrency);
  FAmount := Amount;
  RType   := RateType;

  FVersionO := nil;

  // Check Rate Type correctly specified
  If (RType >= 0) And (RType <= 2) Then Begin
    // Check currencies are different and there is an amount
    If (FromCcy <> ToCcy) And (FAmount <> 0.0) Then Begin
      Res := Ex_ConvertAmount(FromCcy, ToCcy, FAmount, RType);

      If (Res = 0) Then
        Result := FAmount
      Else
        Raise Exception.Create ('Ex_ConvertAmount : ' + IntToStr(Res));
    End { If (FromCcy <> ToCcy) And (FAmount <> 0.0) }
    Else
      // Same currency or zero amount
      Result := 0.0;
  End { If (RType >= 0) And (RType <= 2) }
  Else
    // Invalid Rate Type
    Raise Exception.Create ('Invalid Rate Type (' + IntToStr(Ord(RateType)) + ')');
end; { entConvertAmount }

function TTradeFunctions.entConvertAmountWithRates(Amount: Double;
  ConvertToBase: WordBool; RateCurrency: Integer; CompanyRate,
  DailyRate: Double): Double;
Var
  CRates   : CurrTypes;
  OtherCcy : SmallInt;
  FVersionO : TTradeVersion;
const
  XDayCode       =  'V';
  CRateCode      =  'C';
begin { entConvertAmountWithRates }
  FVersionO := TTradeVersion.Create;
  OtherCcy := FVersionO.ValidateCurrencyNo(RateCurrency);
  FVersionO := nil;

  If (OtherCcy > 0) Then Begin
    CRates[False] := CompanyRate;
    CRates[True] := DailyRate;
    Result := Conv_TCurr(Amount, CRates[(TKSysRec.ExchangeRate = XDayCode)], RateCurrency, 0, Not ConvertToBase);
  End { If (OtherCcy > 0) }
  Else
    Result := 0.0;
end; { entConvertAmountWithRates }

function TTradeFunctions.entConvertDateToPeriod(
  const DateString: WideString; var FinancialPeriod,
  FinancialYear: Integer): Integer;
Var
  pDate              : PChar;
  FinPr, FinYr, Res  : SmallInt;
Begin { entConvertDateToPeriod }
  pDate := StrAlloc(255);
  StrPCopy (pDate, DateString);

  FinPr := 0;
  FinYr := 0;

  Res := Ex_DateToEntPeriod(pDate, FinPr, FinYr);
  If (Res = 0) Then Begin
    FinancialPeriod := FinPr;
    FinancialYear := FinYr;
    Result := 0;
  End { If }
  Else Begin
    FinancialPeriod := 0;
    FinancialYear := 0;
    Result := Res;
  End; { Else }

  StrDispose(pDate);
End; { entConvertDateToPeriod }

function TTradeFunctions.entFormatDate(const EntDateStr,
  DateFormat: WideString): WideString;
var
  tDD, tMM, tYY  : Word;
  DelphiDate     : TDateTime;
  lDateFormat    : ShortString;
begin
  If (Trim(EntDateStr) <> '') Then Begin
    // Convert Enterprise date into Day, Month, Year values
    DateStr(EntDateStr, tDD, tMM, tYY);

    // Convert Day, Month, Year values to a Delphi format date
    DelphiDate := EncodeDate(tYY, tMM, tDD);

    // Check for short date formats
    lDateFormat := DateFormat;
    If (lDateFormat = '') or (UpperCase(lDateFormat) = 'C') or (UpperCase(lDateFormat) = 'S') Then
      lDateFormat := ShortDateFormat
    Else
      // check for long date format
      If (UpperCase(lDateFormat) = 'L') Then
        lDateFormat := LongDateFormat;

    // Format Delphi Date as required
    Result := FormatDateTime(lDateFormat, DelphiDate);
  End { If (Trim(EntDateStr) <> '') }
  Else
    Result := '';
end;

function TTradeFunctions.entFormatPeriodYear(Period,
  Year: Integer): WideString;
begin
  Result := PPR_OutPr(Period, Year);
end;

procedure TTradeFunctions.entOpenCashDrawer(COMPort: Integer; BaudRate: TTradeBaudRate; const KickOutCodes: WideString);
var
  iBaudRate : integer;
begin
  Case BaudRate of
    br9600 : iBaudRate := 9600;
    br19200 : iBaudRate := 19200;
    br38400 : iBaudRate := 38400;
    br57600 : iBaudRate := 57600;
    br115200 : iBaudRate := 115200;
  end;{case}

  OpenCashDrawer(COMPort, iBaudRate, KickOutCodes);
end;

function TTradeFunctions.entRound(Value: Double; Decs: Integer): Double;
begin
  Result := Round_Up(Value, Decs);
end;

function TTradeFunctions.Get_fnTradehWnd: Integer;
begin
  Result := FTradehWnd;
end;

{-------------------------------------------------------------------------------------------------}

end.
