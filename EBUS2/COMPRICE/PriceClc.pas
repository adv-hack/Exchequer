unit PriceClc;

{ prutherford440 09:49 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ActiveX, MtsObj, Mtx, ComObj, Enterprise02_TLB, StdVcl;

type
  TCOMPricing = class(TMtsAutoObject, IEnterprisePriceCalc, IEnterprisePriceCalc2, IEnterprisePriceCalc3)
  private
    fTestMode : boolean;
    FUseLoc : WordBool;
    FDefLoc : AnsiString;
    FUseMultiBuys : WordBool;
  protected
    function CalcPrice(const Directory, AccountCode, StockCode: WideString;
      CurrencyNum: Smallint; Quantity: Double;
      out Price: OleVariant): Smallint; safecall;
    function Get_TestMode: WordBool; safecall;
    procedure Set_TestMode(Value: WordBool); safecall;
    function GetCurrency(const Directory: WideString; CurrencyNum: Smallint;
      out CurrencyName, CurrencySymbol: OleVariant): Smallint; safecall;
    function GetCurrencyArray(const Directory: WideString;
      out CurrencyArray: OleVariant): Smallint; safecall;
    function UpdatePriceData(const UploadDir, InstallDir: WideString;
      out ErrorMsg: WideString): Smallint; safecall;

    function Get_UseMultiBuys: WordBool; safecall;
    procedure Set_UseMultiBuys(Value: WordBool); safecall;
    function GetValueBasedDiscount(const Directory: WideString; const AccountCode: WideString;
                                   Currency: Smallint; TransactionValue: Double;
                                   out DiscountValue: OleVariant; out DiscountFlag: OleVariant): Smallint; safecall;

    function Get_UseLocation: WordBool; safecall;
    procedure Set_UseLocation(Value: WordBool); safecall;
    function Get_DefaultLocation: WideString; safecall;
    procedure Set_DefaultLocation(const Value: WideString); safecall;

  public
    procedure Initialize; override;
  end;

implementation

uses
  ComServ, Dialogs, SysUtils, Variants;

type
  {$I COMPrice.inc}

// External DLL declarations
function CalculatePrice(RootDir, AccCode, StockCode : pchar;
                        CurrencyCode : smallint; Quantity : double;
                        var Price : double) : smallint;
                        stdcall external 'CalcPrce.dll';

function CalculatePriceByLocation(RootDir, AccCode, StockCode, DefLoc : pchar;
                        CurrencyCode : smallint; Quantity : double;
                        var Price : double) : smallint;
                        stdcall external 'CalcPrce.dll';

function CurrencyInfo(RootDir : pchar;
                      CurrNum : smallint;
                      CurrName, CurrSymbol : PChar) : smallint;
                      stdcall external 'Calcprce.dll';

function ProcessPriceUpdate(var COMPriceUpdateRec : TCOMPriceUpdateRec) : smallint;
                            stdcall external 'Calcprce.dll';

function ProcessPriceUpdateWithLocation(var COMPriceUpdateRec : TCOMPriceUpdateRec) : smallint;
                            stdcall external 'Calcprce.dll';

procedure SetLocation(LocCode : PChar; SetOn : Boolean);
                            stdcall external 'Calcprce.dll';

procedure SetUseMultiBuys(Value : Boolean);
                            stdcall external 'Calcprce.dll';

function ExGetValueBasedDiscount(RootDir,
                               AccCode     : PChar;
                               CurrencyCode : smallint;
                               TransactionValue : double;
                               var DiscountValue : double;
                               var DiscountChar : Char) : smallint;
                                 stdcall external 'Calcprce.dll';


//-----------------------------------------------------------------------

function TCOMPricing.CalcPrice(const Directory, AccountCode,
  StockCode: WideString; CurrencyNum: Smallint; Quantity: Double;
  out Price: OleVariant): Smallint;
var
  DLLPrice : double;
begin
  if fTestMode then
    ShowMessage('CalcPrice' + #13#10 +
                'Directory = "' + Directory + '"' + #13#10 +
                'Acc Code = "' + AccountCode + '"' + #13#10 +
                'Stock Code = "' + StockCode + '"' + #13#10 +
                'Curr Code = "' + IntToStr(CurrencyNum) + '"' + #13#10 +
                'Quantity = "' + FloatToStr(Quantity) + '"');


  if not FUseLoc then
  begin
    SetLocation('   ', False);
    Result := CalculatePrice(PChar(AnsiString(Directory)), PChar(AnsiString(AccountCode)),
                             PChar(AnsiString(StockCode)), CurrencyNum, Quantity, DLLPrice);
  end
  else
    Result := CalculatePriceByLocation(PChar(AnsiString(Directory)), PChar(AnsiString(AccountCode)),
                                       PChar(AnsiString(StockCode)), PChar(FDefLoc),
                                       CurrencyNum, Quantity, DLLPrice);

  Price := DLLPrice;
  SetComplete; // Tell MTS that this COM object is stateless
end;

//-----------------------------------------------------------------------

procedure TCOMPricing.Initialize;
begin
  fTestMode := false;
  FUseLoc := False;
  FDefLoc := '';
  FUseMultiBuys := True;
  inherited;
end;

//-----------------------------------------------------------------------

function TCOMPricing.Get_TestMode: WordBool;
begin
  Result := fTestMode;
end;

//-----------------------------------------------------------------------

procedure TCOMPricing.Set_TestMode(Value: WordBool);
begin
  fTestMode := Value;
end;

//-----------------------------------------------------------------------

function TCOMPricing.GetCurrency(const Directory: WideString;
  CurrencyNum: Smallint; out CurrencyName,
  CurrencySymbol: OleVariant): Smallint;
var
  CurrName : PChar;
  CurrSymb : PChar;
begin
  if fTestMode then
    ShowMessage('GetCurrency' + #13#10 +
                'Directory = "' + Directory + '"' + #13#10 +
                'CurrencyNum = "' + IntToStr(CurrencyNum) + '"');

  CurrName := StrAlloc(12);
  CurrSymb := StrAlloc(4);

  Result := CurrencyInfo(PChar(AnsiString(Directory)), CurrencyNum, CurrName, CurrSymb);

  CurrencyName := AnsiString(CurrName);
  CurrencySymbol := AnsiString(CurrSymb);

  StrDispose(CurrName);
  StrDispose(CurrSymb);

  SetComplete; // Tell MTS that this COM object is stateless
end; // TEnterprisePriceCalc.GetCurrency

//-----------------------------------------------------------------------

function TCOMPricing.GetCurrencyArray(const Directory: WideString;
  out CurrencyArray: OleVariant): Smallint;
const
  MAX_CURR = 89;
type
  TCurrItems = record
    CurrID   : smallint;
    CurrName : string;
    CurrSymb : string;
  end;
var
  CurrencyName,
  CurrencySymb : PChar;
  CurrNum,
  CurrCount : integer;
  CurrArray : array of TCurrItems;
begin
  CurrencyName := StrAlloc(12);
  CurrencySymb := StrAlloc(4);

  Result := 0;
  CurrNum := 0;
  CurrCount := 0;
  while (CurrNum <= MAX_CURR) and (Result = 0) do
  begin
    Result := CurrencyInfo(PChar(AnsiString(Directory)), CurrNum, CurrencyName, CurrencySymb);
    if (Result = 0) and (strlen(CurrencyName) > 0) then
    begin
      inc(CurrCount);
      SetLength(CurrArray, CurrCount);
      CurrArray[CurrCount-1].CurrID := CurrNum;
      CurrArray[CurrCount-1].CurrName := CurrencyName;
      CurrArray[CurrCount-1].CurrSymb := CurrencySymb;
    end;
    inc(CurrNum);
  end;

  StrDispose(CurrencyName);
  StrDispose(CurrencySymb);
  CurrencyArray := Unassigned;

  if Result = 0 then
  begin // Move contents of dynamic array to OleVariant
    CurrencyArray := VarArrayCreate([0,CurrCount-1, 0,2], varVariant);
    for CurrCount := Low(CurrArray) to High(CurrArray) do
    begin
      CurrencyArray[CurrCount, 0] := CurrArray[CurrCount].CurrID;
      CurrencyArray[CurrCount, 1] := CurrArray[CurrCount].CurrName;
      CurrencyArray[CurrCount, 2] := CurrArray[CurrCount].CurrSymb;
    end;
  end;

  SetComplete; // Tell MTS that this COM object is stateless
end;

//-----------------------------------------------------------------------

function TCOMPricing.UpdatePriceData(const UploadDir,
  InstallDir: WideString; out ErrorMsg: WideString): Smallint;
var
  COMPriceUpdateRec : TCOMPriceUpdateRec;
begin
  COMPriceUpdateRec.UploadDir := StrAlloc(length(UploadDir) + 1);
  StrPCopy(COMPriceUpdateRec.UploadDir, UploadDir);
  COMPriceUpdateRec.InstallDir := StrAlloc(length(InstallDir) + 1);
  StrPCopy(COMPriceUpdateRec.InstallDir, InstallDir);
  COMPriceUpdateRec.ErrorMsg := StrAlloc(1024);

  if fUseLoc then
    Result := ProcessPriceUpdateWithLocation(COMPriceUpdateRec)
  else
  begin
    SetLocation('   ', False);
    Result := ProcessPriceUpdate(COMPriceUpdateRec);
  end;

  ErrorMsg := COMPriceUpdateRec.ErrorMsg;

  StrDispose(COMPriceUpdateRec.ErrorMsg);
  StrDispose(COMPriceUpdateRec.UploadDir);
  StrDispose(COMPriceUpdateRec.InstallDir);

  SetComplete;
end;

function TCOMPricing.Get_UseLocation: WordBool;
begin
  Result := FUseLoc;
end;

procedure TCOMPricing.Set_UseLocation(Value: WordBool);
begin
  FUseLoc := Value;
end;

function TCOMPricing.Get_DefaultLocation: WideString;
begin
  Result := FDefLoc;
end;

procedure TCOMPricing.Set_DefaultLocation(const Value: WideString);
begin
  FDefLoc := Value;
end;

function TCOMPricing.Get_UseMultiBuys: WordBool;
begin
  Result := FUseMultiBuys;
end;

procedure TCOMPricing.Set_UseMultiBuys(Value: WordBool);
begin
  FUseMultiBuys := Value;
  SetUseMultiBuys(FUseMultiBuys);
end;

function TCOMPricing.GetValueBasedDiscount(const Directory: WideString; const AccountCode: WideString;
                               Currency: Smallint; TransactionValue: Double;
                               out DiscountValue: OleVariant; out DiscountFlag: OleVariant): Smallint;
var
  DiscValue : Double;
  DiscChar : Char;
begin
  DiscValue := 0;
  DiscChar := ' ';

  Result := ExGetValueBasedDiscount(PChar(AnsiString(Directory)), PChar(AnsiString(AccountCode)), Currency, TransactionValue,
                                    DiscValue, DiscChar);

  if Result = 0 then
  begin
    DiscountValue := DiscValue;
    DiscountFlag := DiscChar;
  end;
  SetComplete;
end;





initialization
  TAutoObjectFactory.Create(ComServer, TCOMPricing, Class_COMPricing,
    ciMultiInstance, tmApartment);
end.
