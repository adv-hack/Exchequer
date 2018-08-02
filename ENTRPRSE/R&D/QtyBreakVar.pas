unit QtyBreakVar;
{$ALIGN 1}
interface

uses
  VarConst, BtrvU2, GlobVar;

const
  QtyBreakF     =  26;

  qbNofKeys     =  2;
  qbNofSegs     =  8;

  qbAcCodeIdx   =  0;
  qbFolioIdx    =  1;

  QTY_TO_LENGTH =  16;

  QtyBreakPath  =  'Misc\QtyBreak.dat';

  S_QTY_BREAK_FOLIO_KEY = 'QBF';


type
  TBreakType = (dtPriceBand, dtSpecialPrice, dtMargin, dtMarkup);

  TQtyBreakRec = Record
    qbFolio           : longint;         //Link to parent discount record
    qbAcCode          : String[6];
    qbStockFolio      : longint;
    qbCurrency        : Byte;
    qbStartDate       : LongDate;
    qbEndDate         : LongDate;
    qbQtyToString     : string[16];      //QtyTo as string with leading zeros, as emulator can't index on floating point.
    qbQtyTo           : Double;
    qbQtyFrom         : Double;
    qbBreakType       : TBreakType;
    qbPriceBand       : Char;            //'A'..'H'
    qbSpecialPrice    : Double;
    qbDiscountPercent : Double;
    qbDiscountAmount  : Double;
    qbMarginOrMarkup  : Double;
    qbUseDates        : Boolean;
    Spare             : Array[1..256] of Byte;
  end;

  TQtyBreakFile_Def = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..qbNofSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  //Function to format the Qtyto value as a string with leading zeros in 9.6 format (16 chars)
  function FormatBreakQtyTo(Value : Double) : string;

  //Function to return the first part of the keystring for index 0 - AcCode + StockFolio
  function QtyBreakStartKey(const AcCode : string; StkFolio : longint; bRemoveZeros : Boolean = True) : string;

  //Function to return a discount type character from TBreakType enumeraiont
  function DiscountCharFromBreakType(ABreakType : TBreakType) : Char;

  //Function to return a discount type character from TBreakType enumeraiont
  function BreakTypeFromDiscountChar(DiscountChar : Char) : TBreakType;

  //Procedure to set discount fields, other than the specified one, to zero.
  procedure ResetOtherDiscountFields(var AQtyBreakRec : TQtyBreakRec; ABreakType : TBreakType);

  //function to remove any #0s at the end of a full nom key
  function RemoveZeros(const s : string) : string;

var

  QtyBreakFile : TQtyBreakFile_Def;
  QtyBreakRec  : TQtyBreakRec;


implementation

uses
  SysUtils{$IFNDEF GUP}, BtKeys1U{$ENDIF};  //PR: 21/02/2012 IfDeffed out BtKeys1U as it isn't required for GEUpgrade
                                            //(and causes compile errors.)

//Function to format the Qtyto value as a string with leading zeros in 9.6 format (16 chars)
function FormatBreakQtyTo(Value : Double) : string;
begin
  Result := Format('%.6f', [Value]);

  //Add zeros at the front.
  Result := StringOfChar('0', QTY_TO_LENGTH - Length(Result)) + Trim(Result);
end;

//Function to return the first part of the keystring for index 0 - AcCode + StockFolio
//PR: 27/06/2012 Added parameter so that this can be called without removing zeros - this was
//causing ABSEXCH-13085
function QtyBreakStartKey(const AcCode : string; StkFolio : longint; bRemoveZeros : Boolean = True) : string;
begin
{$IFNDEF GUP} //PR: 21/02/2012
  //PR: 23/02/2012 Remove zeros from end of fullnomkey to ensure that it
  //can be compared against a string returned from a Btrv call
  if bRemoveZeros then
    Result := FullCustCode(AcCode) + RemoveZeros(FullNomKey(StkFolio))
  else
    Result := FullCustCode(AcCode) + FullNomKey(StkFolio);
{$ENDIF}
end;

//Function to return a discount type character from TBreakType enumeraiont
function DiscountCharFromBreakType(ABreakType : TBreakType) : Char;
begin
  Result := 'B';
  Case ABreakType of
    dtPriceBand    : Result := 'B';
    dtSpecialPrice : Result := 'P';
    dtMargin       : Result := 'M';
    dtMarkup       : Result := 'U';
  end;
end;

//Function to return a discount type character from TBreakType enumeraiont
function BreakTypeFromDiscountChar(DiscountChar : Char) : TBreakType;
begin
  Result := dtPriceBand;
  Case DiscountChar of
    'B'  : Result := dtPriceBand;
    'P'  : Result := dtSpecialPrice;
    'M'  : Result := dtMargin;
    'U'  : Result := dtMarkup;
  end;
end;


//Procedure to set discount fields, other than the specified one, to zero.
procedure ResetOtherDiscountFields(var AQtyBreakRec : TQtyBreakRec; ABreakType : TBreakType);
begin
  with AQtyBreakRec do
  begin
    Case ABreakType of

      dtPriceBand  : begin
                       qbSpecialPrice := 0.0;
                       qbMarginOrMarkup := 0.0;
                     end;

      dtSpecialPrice
                   : begin
                       qbDiscountAmount := 0.0;
                       qbDiscountPercent := 0.0;
                       qbMarginOrMarkup := 0.0;
                     end;

      dtMargin,
      dtMarkup     : begin
                       qbSpecialPrice := 0.0;
                       qbDiscountAmount := 0.0;
                       qbDiscountPercent := 0.0;
                     end;
    end; //Case
  end; //with
end;

//function to remove any #0s at the end of a full nom key
function RemoveZeros(const s : string) : string;
var
  i : Integer;
begin
  i := Length(s);
  while (i > 0) and (s[i] = #0) do
    dec(i);
  if i > 0 then
    Result := Copy(s, 1, i)
  else
    Result := s;
end;



//Standard function to define Pervasive file.
procedure DefineQtyBreak;
Const
  Idx = QtyBreakF;

Begin
  With QtyBreakFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(QtyBreakFile);
    Fillchar(QtyBreakFile,FileSpecLen[Idx],0);
    RecLen:=Sizeof(QtyBreakRec);
    PageSize:=DefPageSize;  // 1k
    NumIndex:=qbNofKeys;
    Variable:=B_Variable+B_Compress+B_BTrunc;

    //Index 0 - Account Code + StockCode + Currency + StartDate + EndDate + QtyToString;

    //Account code
    KeyBuff[1].KeyPos:=BtKeyPos(@QtyBreakRec.qbAcCode[1],@QtyBreakRec);
    KeyBuff[1].KeyLen:=SizeOf(QtyBreakRec.qbAcCode) - 1;
    KeyBuff[1].KeyFlags:=DupModSeg+AltColSeq;

    //Stock folio
    KeyBuff[2].KeyPos:=BtKeyPos(@QtyBreakRec.qbStockFolio,@QtyBreakRec);
    KeyBuff[2].KeyLen:=SizeOf(QtyBreakRec.qbStockFolio);
    KeyBuff[2].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[2].ExtTypeVal:=BInteger;

    //Currency
    KeyBuff[3].KeyPos:=BtKeyPos(@QtyBreakRec.qbCurrency,@QtyBreakRec);
    KeyBuff[3].KeyLen:=SizeOf(QtyBreakRec.qbCurrency);
    KeyBuff[3].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[3].ExtTypeVal:=BInteger;

    //Start Date
    KeyBuff[4].KeyPos:=BtKeyPos(@QtyBreakRec.qbStartDate[1],@QtyBreakRec);
    KeyBuff[4].KeyLen:=SizeOf(QtyBreakRec.qbStartDate) - 1;
    KeyBuff[4].KeyFlags:=DupModSeg;

    //End Date
    KeyBuff[5].KeyPos:=BtKeyPos(@QtyBreakRec.qbEndDate[1],@QtyBreakRec);
    KeyBuff[5].KeyLen:=SizeOf(QtyBreakRec.qbEndDate) - 1;
    KeyBuff[5].KeyFlags:=DupModSeg;

    //Qty To string
    KeyBuff[6].KeyPos:=BtKeyPos(@QtyBreakRec.qbQtyToString[1],@QtyBreakRec);
    KeyBuff[6].KeyLen:=SizeOf(QtyBreakRec.qbQtyToString) - 1;
    KeyBuff[6].KeyFlags:=DupMod;


    //Index 1 - Folio + QtyToString

    //Folio
    KeyBuff[7].KeyPos:=BtKeyPos(@QtyBreakRec.qbFolio,@QtyBreakRec);
    KeyBuff[7].KeyLen:=SizeOf(QtyBreakRec.qbFolio);
    KeyBuff[7].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[7].ExtTypeVal:=BInteger;

    //QtyToString
    KeyBuff[8].KeyPos:=BtKeyPos(@QtyBreakRec.qbQtyToString[1],@QtyBreakRec);
    KeyBuff[8].KeyLen:=SizeOf(QtyBreakRec.qbQtyToString) - 1;
    KeyBuff[8].KeyFlags:=DupMod;

    AltColt:=UpperALT;

  end; {With..}
  FileRecLen[Idx]:=Sizeof(QtyBreakRec);

  Fillchar(QtyBreakRec,FileRecLen[Idx],0);

  RecPtr[Idx]:=@QtyBreakRec;

  FileSpecOfs[Idx]:=@QtyBreakFile;


  FileNames[Idx]:=QtyBreakPath;


  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('QtyBreakRec: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}
end;



Initialization
  DefineQtyBreak;

end.
