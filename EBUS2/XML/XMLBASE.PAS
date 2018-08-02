unit XMLBase;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, XMLOutpt;

{$I Exdllbt.inc}
{$I Exchdll.inc}

const
  MAX_CURRENCIES = 89;

type
  PBatchSysRec = ^TBatchSysRec;
  PBatchCURec = ^TBatchCURec;
  
  TCurrItems = record
    CurrID        : smallint;
    CurrName      : string;
    CurrSymb      : string;
    CurrDailyRate : double;
    CurrCompRate  : double;
  end;

  TVATItems = record
    VATCode  :  char;
    VATRate  :  Double;
    VATDesc  :  string;
  end;

  TCurrArray = array of TCurrItems;
  TVATArray = array of TVATItems;

  TReadWriteXMLBase = class
    private
      fSysInfo  : PBatchSysRec;

    protected
      fCurrArray : TCurrArray;
      fVATArray  : TVATArray;
      fCurrentLine : integer;
      procedure ReadVATInfo;
      procedure ReadSystemInfo;
      function  GetVATInfo(VATCode : char; var VATInfo : TVATItems) : boolean;
      procedure ReadCurrencyInfo;
      function  GetCurrencyInfo(CurrNum : integer; var CurrInfo : TCurrItems) : boolean;

    public
      //PR: 26/05/2009
      function  GetVATRate(VATCode : char) : double; virtual;
      property SysInfo : PBatchSysRec read fSysInfo;
      constructor Create;
      destructor  Destroy; override;
  end; // TReadWriteXMLBase

  //-----------------------------------------------------------------------------------

  TWriteXMLBase = class(TReadWriteXMLBase)
    private
      fDocument : TXmlDDocument;
      procedure SetDocument(Value : TXmlDDocument);

    protected
      function CostToStr(Cost : double) : string;
      function QuantToStr(Quantity : double) : string;
      function PriceToStr(Price : double) : string;
      function FloatValToStr(Value : double; DP : integer) : string;
    public
      procedure SaveToFile(const FileName: String; FormattedForPrint: Boolean = False);
      procedure SaveToStream(Stream: TStream; FormattedForPrint: Boolean = False);
      property Document : TXmlDDocument read fDocument write SetDocument;

      constructor Create;
      destructor  Destroy; override;
    end; // TWriteXMLBase

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  SysUtils, {$IFDEF StandAlone} EtMiscU {$ELSE} UseDLLU {$ENDIF not Standalone};

{$IFDEF StandAlone}
FUNCTION EX_ROUNDUP(INPUTVALUE     :  DOUBLE;
                    DECIMALPLACES  :  SMALLINT)  :  DOUBLE;
Var
  TmpValue  :  Double;

begin
 //LastErDesc:='';
  TmpValue:=0;
  TmpValue:=Round_Up(InputValue,DecimalPlaces);
  EX_ROUNDUP:=TmpValue;
end;
{$ENDIF}
//-----------------------------------------------------------------------------------

constructor TReadWriteXMLBase.Create;
begin
  inherited Create;
  new(fSysInfo);
end;

//-----------------------------------------------------------------------------------

destructor TReadWriteXMLBase.Destroy;
begin
  dispose(fSysInfo);
  inherited Destroy;
end;

//-----------------------------------------------------------------------------------

procedure TReadWriteXMLBase.ReadSystemInfo;
begin
{$IFNDEF Standalone}
  FillChar(fSysInfo^, SizeOf(fSysInfo^), 0);
  if Ex_GetSysData(fSysInfo, SizeOf(fSysInfo^)) <> 0 then
    with fSysInfo^ do
    begin
      PriceDP := 2;
      CostDP := 2;
      QuantityDP := 4;
    end;
{$ENDIF not Standalone}
end; // TReadWriteXMLBase.SetSystemInfo

//-----------------------------------------------------------------------------------

procedure TReadWriteXMLBase.ReadVATInfo;
var
  VATInfo : ^TBatchVATRec;
  Count : integer;
  ch : char;
begin
{$IFNDEF Standalone}
  new(VATInfo);
  FillChar(VATInfo^, SizeOf(VatInfo^), 0);
  Count := 0;
  for ch := Low(ch) to High(ch) do
  begin
    VATInfo^.VATCode := ch;
    if Ex_GetVATRate(VATInfo, SizeOf(VATInfo^)) = 0 then
    begin
      inc(Count);
      SetLength(fVATArray, Count);
      fVATArray[Count-1].VATCode := VATInfo^.VATCode;
      fVATArray[Count-1].VATRate := VATInfo^.VATRate;
      fVATArray[Count-1].VATDesc := VATInfo^.VATDesc;
    end;
  end;
  dispose(VATInfo);
{$ENDIF not StandAlone}
end; // TReadWriteXMLBase.ReadVATInfo

//-----------------------------------------------------------------------------------

function TReadWriteXMLBase.GetVATInfo(VATCode : char; var VATInfo : TVATItems) : boolean;
var
  CurrPos : integer;
  Found : boolean;
begin
  CurrPos := 0;
  Found := false;
  while (CurrPos <= High(fVATArray)) and not Found do
  begin
    Found := fVATArray[CurrPos].VATCode = VATCode;
    if Found then
      VATInfo := fVATArray[CurrPos];
    inc(CurrPos);
  end;
  Result := Found;
end; // TReadWriteXMLBase.GetVATInfo

//-----------------------------------------------------------------------------------

function TReadWriteXMLBase.GetVATRate(VATCode : char) : double;
// Pre  : Enterprise VAT code
// Post : Equivalent current VAT rate, 0 if code not found
var
  TaxInfo : TVATItems;
begin
  if GetVATInfo(VATCode, TaxInfo) then
    Result := TaxInfo.VATRate * 100
  else
    Result := 0.0;
end; // TReadWriteXMLBase.GetVATRate

//-----------------------------------------------------------------------------------

procedure TReadWriteXMLBase.ReadCurrencyInfo;
var
  CurrencyRec : ^TBatchCurrRec;
  Result,
  CurrCount,
  CurrNum    : integer;
begin
{$IFNDEF StandAlone}
  new(CurrencyRec);
  Result := 0;
  CurrNum := 0;
  CurrCount := 0;
  while (CurrNum <= MAX_CURRENCIES) and (Result = 0) do
  begin
    Result := Ex_GetCurrency(CurrencyRec, SizeOf(CurrencyRec^), CurrNum);
    if Result = 0 then
    begin
      inc(CurrCount);
      SetLength(fCurrArray, CurrCount);
      fCurrArray[CurrCount-1].CurrID := CurrNum;
      fCurrArray[CurrCount-1].CurrName := CurrencyRec^.Name;
      fCurrArray[CurrCount-1].CurrSymb := CurrencyRec^.ScreenSymb;
      fCurrArray[CurrCount-1].CurrDailyRate := CurrencyRec^.DailyRate;
      fCurrArray[CurrCount-1].CurrCompRate := CurrencyRec^.CompanyRate;
    end;
    inc(CurrNum);
  end;
  dispose(CurrencyRec);
{$ENDIF not StandAlone}
end; // TReadWriteXMLBase.ReadCurrencyInfo

//-----------------------------------------------------------------------------------

function TReadWriteXMLBase.GetCurrencyInfo(CurrNum : integer;
  var CurrInfo : TCurrItems) : boolean;
var
  CurrPos : integer;
  Found : boolean;
begin
  CurrPos := 0;
  Found := false;
  while (CurrPos <= High(fCurrArray)) and not Found do
  begin
    Found := fCurrArray[CurrPos].CurrID = CurrNum;
    if Found then
      CurrInfo := fCurrArray[CurrPos];
    inc(CurrPos);
  end;
  Result := Found;
end; // TReadWriteXMLBase.GetCurrencyInfo

//===================================================================================

constructor TWriteXMLBase.Create;
begin
  inherited Create;
  Document := TxmlDDocument.Create;
end;

//-----------------------------------------------------------------------------------

destructor TWriteXMLBase.Destroy;
begin
  Document.Free;
  inherited Destroy;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLBase.SetDocument(Value: TXmlDDocument);
begin
  fDocument := Value;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLBase.SaveToFile(const FileName: String; FormattedForPrint: Boolean = False);
begin
  Document.SaveToFile(FileName, FormattedForPrint);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLBase.SaveToStream(Stream: TStream; FormattedForPrint: Boolean = False);
begin
  Document.SaveToStream(Stream, FormattedForPrint);
end;

//-----------------------------------------------------------------------------------

function TWriteXMLBase.CostToStr(Cost : double) : string;
begin
  Result := FloatToStrF(Ex_RoundUp(Cost, fSysInfo^.CostDP), ffFixed, 18, fSysInfo^.CostDP);
end;

//-----------------------------------------------------------------------------------

function TWriteXMLBase.QuantToStr(Quantity : double) : string;
begin
  Result := FloatToStrF(Ex_RoundUp(Quantity, fSysInfo^.QuantityDP), ffFixed, 18, fSysInfo^.QuantityDP);
end;

//-----------------------------------------------------------------------------------

function TWriteXMLBase.PriceToStr(Price : double) : string;
begin
  Result := FloatToStrF(Ex_RoundUp(Price, fSysInfo^.PriceDP), ffFixed, 18, fSysInfo^.PriceDP);
end;

//-----------------------------------------------------------------------------------

function TWriteXMLBase.FloatValToStr(Value : double; DP : integer) : string;
begin
  Result := FloatToStrF(Ex_RoundUp(Value, DP), ffFixed, 18, DP);
end;

//-----------------------------------------------------------------------------------

end.
