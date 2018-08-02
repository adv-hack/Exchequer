unit Ofuncs;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows,
     ComObj, ActiveX, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     ExceptIntf,
     // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added Hash method for SQL Check Application to use
     EnterpriseBeta_TLB, Sha3HashUtil;

type
  TFunctions = class(TAutoIntfObject, IFunctions, IFunctions2, IFunctions3, IHashFunctions)
  private
  protected
    function entFormatDate(const EntDateStr: WideString; const DateFormat: WideString): WideString; safecall;
    function entRound(Value: Double; Decs: Integer): Double; safecall;
    function entFormatPeriodYear(Period: Integer; Year: Integer): WideString; safecall;
    function entConvertAmount(Amount: Double; FromCurrency: Integer; ToCurrency: Integer; RateType: Integer): Double; safecall;
    function entConvertDateToPeriod(const DateString: WideString; var FinancialPeriod: Integer; var FinancialYear: Integer): Integer; safecall;

    function entConvertAmountWithRates(Amount        : Double;
                                       ConvertToBase : WordBool;
                                       RateCurrency  : Integer;
                                       CompanyRate   : Double;
                                       DailyRate     : Double): Double; safecall;

    procedure entBrowseObject(const ObjectToBrowse: IDispatch; ShowModal: WordBool); safecall;
    function entCheckPassword(const UserName, UserPassword : WideString) : integer; safecall;
    function  entCheckSecurity(const UserName: WideString; AreaCode: Integer): Integer; safecall;

    //IFunctions2
    function entDouble(Int2: SmallInt; Int4: Integer): Double; safecall;

    //IFunctions3
    function entConvertAmountWithRatesEx(Amount: Double; ConvertToBase: WordBool;
                                         RateCurrency: Integer; CompanyRate: Double;
                                         DailyRate: Double; DecPlaces: Integer): Double; safecall;

    // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added Hash method for SQL Check Application to use
    // IHashFunctions (EnterpriseBeta_TLB)
    function HashText(const HashSalt: WideString; const HashText: WideString): WideString; safecall;
  public
    Constructor Create;
    {Destructor Destroy; override;}
  End; { TFunctions }

implementation

uses ComServ, etDateU, etMiscU, etStrU, FirstU, ComnU2, MiscFunc, DLLTH_Up,
     GlobVar, VarConst, VarRec2U, DLLMiscU, CurrncyU, ComDLL1, Security;

{-------------------------------------------------------------------------------------------------}

Constructor TFunctions.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, IFunctions3);

End; { Create }

{-----------------------------------------}

// Returns an Enterprise date formatted correctly
function TFunctions.entFormatDate(const EntDateStr: WideString; const DateFormat: WideString): WideString;
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
      lDateFormat := Orig_ShortDateFormat
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

{-----------------------------------------}

// Rounds a specified double to specified decimal places
function TFunctions.entRound(Value: Double; Decs: Integer): Double;
begin { entRound }
  Result := Round_Up(Value, Decs);
end; { entRound }

{-----------------------------------------}

// Returns a correctly formatted Period and Year
Function TFunctions.entFormatPeriodYear(Period: Integer; Year: Integer): WideString;
Begin { entFormatPeriodYear }
  Result := PPR_OutPr (Period, Year);
End; { entFormatPeriodYear }

{-----------------------------------------}

// Converts an Amount from FromCurrency to ToCurrency using the specified ratetype
function TFunctions.entConvertAmount(Amount: Double; FromCurrency: Integer; ToCurrency: Integer; RateType: Integer): Double;
Var
  FromCcy, ToCcy, Res, RType : SmallInt;
  FAmount                    : Double;
begin { entConvertAmount }
  FromCcy := ValidateCurrencyNo(FromCurrency);
  ToCcy   := ValidateCurrencyNo(ToCurrency);
  FAmount := Amount;
  RType   := RateType;

  // Check Rate Type correctly specified
  If (RType >= 0) And (RType <= 2) Then Begin
    // Check currencies are different and there is an amount
    If (FromCcy <> ToCcy) And (FAmount <> 0.0) Then Begin
      Res := Ex_ConvertAmount(FromCcy, ToCcy, FAmount, RType);

      If (Res = 0) Then
        Result := FAmount
      Else
        Raise Exception.Create (LastErDesc);
    End { If (FromCcy <> ToCcy) And (FAmount <> 0.0) }
    Else
      // Same currency or zero amount
        Result := FAmount
        //PR 13/01/03 Change so that same currencies return correct amount rather than 0
        //Result := 0.0;
  End { If (RType >= 0) And (RType <= 2) }
  Else
    // Invalid Rate Type
    Raise Exception.Create ('Invalid Rate Type (' + IntToStr(Ord(RateType)) + ')');
end; { entConvertAmount }

{-----------------------------------------}

// Converts an Enterprise format date string into the equivalent Period and Year
function TFunctions.entConvertDateToPeriod(const DateString: WideString; var FinancialPeriod: Integer; var FinancialYear: Integer): Integer;
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

{-----------------------------------------}

// Converts an amount to or from Base Ccy to another specified Ccy using supplied rates
function TFunctions.entConvertAmountWithRates(Amount        : Double;
                                              ConvertToBase : WordBool;
                                              RateCurrency  : Integer;
                                              CompanyRate   : Double;
                                              DailyRate     : Double): Double;
Var
  CRates   : CurrTypes;
  OtherCcy : SmallInt;
begin { entConvertAmountWithRates }
  OtherCcy := ValidateCurrencyNo(RateCurrency);

  If (OtherCcy > 0) Then Begin
    CRates[False] := CompanyRate;
    CRates[True] := DailyRate;

    Result := Conv_TCurr(Amount, CRates[(Syss.TotalConv=XDayCode)], RateCurrency, 0, Not ConvertToBase);
  End { If (OtherCcy > 0) }
  Else
    Result := 0.0;
end; { entConvertAmountWithRates }

{-----------------------------------------}

// Passes a COM Toolkit object to Paul's Object Browser in ComDLL1.Pas
//HM 28/02/01: Extended to allow non-modal browser windows
procedure TFunctions.entBrowseObject(const ObjectToBrowse: IDispatch; ShowModal: WordBool);
begin
  If ShowModal Then
    ShowModalBrowser (Application.Handle, ObjectToBrowse)
  Else
    ShowBrowser (Application.Handle, ObjectToBrowse);
end;

{-----------------------------------------}

//Checks user name and password
function TFunctions.entCheckPassword(const UserName, UserPassword : WideString) : integer;
var
  UName, UPass : PChar;
begin
  UName := StrAlloc(Length(UserName) + 1);
  UPass := StrAlloc(Length(UserPassword) + 1);

  Try
    FillChar(UName^, Length(UserName) + 1, #0);
    FillChar(UPass^, Length(UserPassword) + 1, #0);
    StrPCopy(UName, UserName);
    StrPCopy(UPass, UserPassword);

    Result := EX_CHECKPASSWORD(UName, UPass);

  Finally
    StrDispose(UPass);
    StrDispose(UName);
  End;
end;

{-----------------------------------------}

function  TFunctions.entCheckSecurity(const UserName: WideString; AreaCode: Integer): Integer; safecall;var
  UName : PChar;
  SecurityResult : SmallInt;
begin
  UName := StrAlloc(Length(UserName) + 1);

  Try
    FillChar(UName^, Length(UserName) + 1, #0);
    StrPCopy(UName, UserName);

    Result := EX_CHECKSECURITY(UName, AreaCode, SecurityResult);

    //Make security result 0 for access, 1 for no access
    SecurityResult := 1 - SecurityResult;

    if Result = 0 then
      Result := SecurityResult;
  Finally
    StrDispose(UName);
  End;
end;

function TFunctions.entDouble(Int2: SmallInt; Int4: Integer): Double;
Var
  TheRealArray : Array [1..6] Of Char;
  TheReal      : Real;
Begin
  Move (Int2, TheRealArray[1], 2);
  Move (Int4, TheRealArray[3], 4);
  Move (TheRealArray[1], TheReal, 6);

  Result := TheReal;
End;



//PR 03/07/07 Added new function to allow converted amount to be rounded to a set no of dec places. (Bug 200415113743)
function TFunctions.entConvertAmountWithRatesEx(Amount: Double;
  ConvertToBase: WordBool; RateCurrency: Integer; CompanyRate,
  DailyRate: Double; DecPlaces: Integer): Double;
begin
  Result := Round_Up(entConvertAmountWithRates(Amount, ConvertToBase,
                                               RateCurrency,
                                               CompanyRate, DailyRate ), DecPlaces);
end;

//-------------------------------------------------------------------------

// MH 04/01/2018 2017-R1 ABSEXCH-19316: Added Hash method for SQL Check Application to use
// IHashFunctions (EnterpriseBeta_TLB)
function TFunctions.HashText(const HashSalt: WideString; const HashText: WideString): WideString;
Begin // HashText
  Result := StrToSHA3Hase(HashSalt + HashText);
End; // HashText

//-------------------------------------------------------------------------

end.
