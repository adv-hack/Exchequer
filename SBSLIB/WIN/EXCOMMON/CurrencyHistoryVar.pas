unit CurrencyHistoryVar;
{PR: 18/06/2012 Record and file declaration for new v7.0 table of changes to currencies.}

{$ALIGN 1}

interface


uses
  BtrvU2, GlobVar, Dialogs, SysUtils;

Const

  CurrencyHistoryF =  27;

  chNofKeys        =  2;
  chNofSegs        =  7;

  chDateTimeK      =  0; //Date + Time + Currency Number
  chNumberK        =  1; //Currency Number + Date + Time

  CurrencyHistoryPath   = 'CurrencyHistory.dat';


type

  TCurrencyHistoryRec = record
    chDateChanged  : string[8];
    chTimeChanged  : string[6];
    chCurrNumber   : SmallInt;
    chStopKey      : char;          //'!' - needed to end key 0 where Currency Number is the last segment
    chDailyRate    : Double;
    chCompanyRate  : Double;
    chInvert       : Boolean;
    chFloat        : Boolean;
    chTriangulationNumber
                 : Smallint;
    chTriangulationRate
                 : Double;
    chDescription  : string[11];
    chSymbolScreen : string[3];
    chSymbolPrint  : string[3];
    chUser         : string[10];
    Spare          : Array[1..150] of Byte;
  end;

  CurrencyHistoryFile_Def = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..chNofSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

var
  CurrencyHistoryFile : CurrencyHistoryFile_Def;
  CurrencyHistory     : TCurrencyHistoryRec;

implementation

procedure DefineCurrencyHistory;
Const
  Idx = CurrencyHistoryF;

Begin
  With CurrencyHistoryFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(CurrencyHistoryFile);
    Fillchar(CurrencyHistoryFile,FileSpecLen[Idx],0);
    RecLen:=Sizeof(CurrencyHistory);
    PageSize:=DefPageSize;  // 1k
    NumIndex:=chNofKeys;
    Variable:=B_Variable+B_Compress+B_BTrunc;

    //Index 0 - Date + Time + Currency Number + '!';

    //Date - YYYYMMDD
    KeyBuff[1].KeyPos:=BtKeyPos(@CurrencyHistory.chDateChanged[1],@CurrencyHistory);
    KeyBuff[1].KeyLen:=SizeOf(CurrencyHistory.chDateChanged) - 1;
    KeyBuff[1].KeyFlags:=DupModSeg;

    //Time - HHNNSS
    KeyBuff[2].KeyPos:=BtKeyPos(@CurrencyHistory.chTimeChanged[1],@CurrencyHistory);
    KeyBuff[2].KeyLen:=SizeOf(CurrencyHistory.chTimeChanged) - 1;
    KeyBuff[2].KeyFlags:=DupModSeg;

    //Currency Number
    KeyBuff[3].KeyPos:=BtKeyPos(@CurrencyHistory.chCurrNumber,@CurrencyHistory);
    KeyBuff[3].KeyLen:=SizeOf(CurrencyHistory.chCurrNumber);
    KeyBuff[3].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[3].ExtTypeVal:=BInteger;

    //Stop char ('!')
    KeyBuff[4].KeyPos:=BtKeyPos(@CurrencyHistory.chStopKey,@CurrencyHistory);
    KeyBuff[4].KeyLen:=SizeOf(CurrencyHistory.chStopKey);
    KeyBuff[4].KeyFlags:=DupMod;

    //Index 1 - Currency Number + Date + Time

    //Currency Number
    KeyBuff[5].KeyPos:=BtKeyPos(@CurrencyHistory.chCurrNumber,@CurrencyHistory);
    KeyBuff[5].KeyLen:=SizeOf(CurrencyHistory.chCurrNumber);
    KeyBuff[5].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[5].ExtTypeVal:=BInteger;

    //Date  - YYYYMMDD
    KeyBuff[6].KeyPos:=BtKeyPos(@CurrencyHistory.chDateChanged[1],@CurrencyHistory);
    KeyBuff[6].KeyLen:=SizeOf(CurrencyHistory.chDateChanged) - 1;
    KeyBuff[6].KeyFlags:=DupModSeg;

    //Time  - HHNNSS
    KeyBuff[7].KeyPos:=BtKeyPos(@CurrencyHistory.chTimeChanged[1],@CurrencyHistory);
    KeyBuff[7].KeyLen:=SizeOf(CurrencyHistory.chTimeChanged) - 1;
    KeyBuff[7].KeyFlags:=DupMod;
  end; {With..}

  FileRecLen[Idx]:=Sizeof(CurrencyHistory);

  Fillchar(CurrencyHistory,FileRecLen[Idx],0);

  RecPtr[Idx]:=@CurrencyHistory;

  FileSpecOfs[Idx]:=@CurrencyHistoryFile;


  FileNames[Idx]:=CurrencyHistoryPath;


  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('CurrencyHistory: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}

end; {..}

initialization
  DefineCurrencyHistory;

end.
