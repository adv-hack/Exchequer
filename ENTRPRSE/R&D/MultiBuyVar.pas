unit MultiBuyVar;
{$ALIGN 1}

interface

uses
  BtrvU2, GlobVar, Dialogs, SysUtils, BtKeys1U;


Const

  MultiBuyF         =  25;

  mbdNofKeys     =  3;
  mbdNofSegs     =  7;

  mbdAcCodeK     =  0;
  mbdStartDateK  =  1;
  mbdEndDateK    =  2;

  MultiBuyPath   = 'Misc\MultiBuy.dat';

  mbtGetFree       = '0';
  mbtForAmount     = '1';
  mbtGetPercentOff = '2';

  mboStock = 'T';

  RewardValueName : Array[0..2] of String[13] = ('Free Quantity', 'Price', 'Discount %');

  mbdBuyQtyStringLen = 20;
  mbdAcStockKeyLen = 22; //Length of CustCode + StockCode

  mbdDescLineID = 255;



type

  PMultiBuyDiscount = ^TMultiBuyDiscount;
  TMultiBuyDiscount = Record
    mbdOwnerType         :  Char; //'C' - Customer, 'S' - Supplier, 'T' - Stock
    mbdAcCode            :  String[CustKeyLen];
    mbdStockCode         :  String[StkKeyLen];
    mbdBuyQtyString      :  String[mbdBuyQtyStringLen]; //String representation of buy qty, padded with zeros
    mbdCurrency          :  Byte;
    mbdDiscountType      :  Char;
    mbdStartDate         :  LongDate;
    mbdEndDate           :  LongDate;
    mbdUseDates          :  Boolean;
    mbdBuyQty            :  Double;
    mbdRewardValue       :  Double;
    Spare                :  Array[1..256] of Byte;
   end;

    MultiBuyFile_Def = Record
            RecLen,
            PageSize,
            NumIndex  :  SmallInt;
            NotUsed   :  LongInt;
            Variable  :  SmallInt;
            Reserved  :  array[1..4] of Char;
            KeyBuff   :  array[1..mbdNofSegs] of KeySpec;
            AltColt   :  AltColtSeq;
          end;

{.$IF Defined(SOP) OR Defined(SQLHELPER)}
  Procedure DefineMultiBuyDiscounts;
  function BuyQuantityStringStartValue : Str255;
  function mbdStockCodeKey(const sCustCode : string; sStockCode : string) : Str255;
  function mbdPartStockCodeKey(const sCustCode : string; sStockCode : string) : Str255;
  function mbdGetLastKey(const sCustCode : string; sStockCode : string) : Str255;
  function mbdFullKey(const sCustCode : string; sStockCode : string; BuyQty : Double; Currency : Byte; DiscType : Char) : Str255;
  function FormatBuyQtyString(BuyQty : Double) : string;

{.$IFEND}
var
  MultiBuyFile : MultiBuyFile_Def;
  MultiBuyDiscount
                : TMultiBuyDiscount;







implementation

uses
  IIfFuncs, EtStrU;
{.$IF Defined(SOP) OR Defined(SQLHELPER)}

function mbdFullKey(const sCustCode : string; sStockCode : string; BuyQty : Double; Currency : Byte; DiscType : Char) : Str255;
begin
  Result := mbdPartStockCodeKey(sCustCode, sStockCode) +  FormatBuyQtyString(BuyQty) + Char(Currency) + DiscType;
end;

function BuyQuantityStringStartValue : Str255;
//Because the BuyQtyString segment of the main index is descending, if we want to do a GetGreaterThanOrEqual on AcCode + StockCode,
//we need to add the greatest possible value for this segment onto the end of the field
begin
  Result := StringOfChar('z', mbdBuyQtyStringLen);
end;

function mbdStockCodeKey(const sCustCode : string; sStockCode : string) : Str255;
//Builds a key string to be used for GetGreaterThanOrEqual when Stock Code is involved.
begin
  Result := FullCustCode(sCustCode) + FullStockCode(sStockCode) + BuyQuantityStringStartValue;
end;

function mbdPartStockCodeKey(const sCustCode : string; sStockCode : string) : Str255;
begin
  Result := FullCustCode(sCustCode) + FullStockCode(sStockCode);
end;

function mbdGetLastKey(const sCustCode : string; sStockCode : string) : Str255;
begin
  Result := FullCustCode(sCustCode) + FullStockCode(sStockCode) + StringOfChar(' ', mbdBuyQtyStringLen);
end;

function FormatBuyQtyString(BuyQty : Double) : string;
//format BuyQty to 000000000000.000000
var
  i, j : Integer;
begin
  Result := FloatToStr(BuyQty);
  i := Pos(',', Result);
  while i > 0 do
  begin
    Delete(Result, i, 1);

    i := Pos(',', Result);
  end;

  i := Pos('.', Result);
  if i = 0 then
    Result := Result + '.000000'
  else
  begin
    j := Length(Result);
    if j - i < 6 then
      Result := Result + StringOfChar('0', 6 - (j - i));
  end;

  Result := StringOfChar('0', mbdBuyQtyStringLen - Length(Result)) + Result;
end;




Procedure DefineMultiBuyDiscounts;

Const
  Idx = MultiBuyF;

Begin
  With MultiBuyFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(MultiBuyFile);                      { <<<<<<<<******** Change }
    Fillchar(MultiBuyFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(MultiBuyDiscount);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;  // 1k
    NumIndex:=mbdNofKeys;                                      { <<<<<<<<******** Change }
    Variable:=B_Variable+B_Compress+B_BTrunc;

    //Index 0 - Account Code + StockCode + BuyQtyString + Currency + Discount Type;
    KeyBuff[1].KeyPos:=BtKeyPos(@MultiBuyDiscount.mbdAcCode[1],@MultiBuyDiscount);
    KeyBuff[1].KeyLen:=SizeOf(MultiBuyDiscount.mbdAcCode) - 1;
    KeyBuff[1].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[2].KeyPos:=BtKeyPos(@MultiBuyDiscount.mbdStockCode[1],@MultiBuyDiscount);
    KeyBuff[2].KeyLen:=SizeOf(MultiBuyDiscount.mbdStockCode) - 1;
    KeyBuff[2].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[3].KeyPos:=BtKeyPos(@MultiBuyDiscount.mbdBuyQtyString[1],@MultiBuyDiscount);
    KeyBuff[3].KeyLen:=SizeOf(MultiBuyDiscount.mbdBuyQtyString) - 1;
    KeyBuff[3].KeyFlags:=DupModSeg;

    KeyBuff[4].KeyPos:=BtKeyPos(@MultiBuyDiscount.mbdCurrency,@MultiBuyDiscount);
    KeyBuff[4].KeyLen:=SizeOf(MultiBuyDiscount.mbdCurrency);
    KeyBuff[4].KeyFlags:=DupModSeg;

    KeyBuff[5].KeyPos:=BtKeyPos(@MultiBuyDiscount.mbdDiscountType,@MultiBuyDiscount);
    KeyBuff[5].KeyLen:=1;
    KeyBuff[5].KeyFlags:=DupMod;

    //Index 2 - Start Date
    KeyBuff[6].KeyPos:=BtKeyPos(@MultiBuyDiscount.mbdStartDate[1],@MultiBuyDiscount);
    KeyBuff[6].KeyLen:=SizeOf(MultiBuyDiscount.mbdStartDate) - 1;
    KeyBuff[6].KeyFlags:=DupMod;

    //Index 3 - End Date
    KeyBuff[7].KeyPos:=BtKeyPos(@MultiBuyDiscount.mbdEndDate[1],@MultiBuyDiscount);
    KeyBuff[7].KeyLen:=SizeOf(MultiBuyDiscount.mbdEndDate) - 1;
    KeyBuff[7].KeyFlags:=DupMod;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(MultiBuyDiscount);                             { <<<<<<<<******** Change }

  Fillchar(MultiBuyDiscount,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@MultiBuyDiscount;

  FileSpecOfs[Idx]:=@MultiBuyFile;


  FileNames[Idx]:=MultiBuyPath;


  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('MultiBuy: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}

end; {..}


{.$IFEND}

end.
