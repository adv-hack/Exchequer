unit BudgetHistoryVar;
{PR: 18/06/2012 Record and file declaration for new v7.0 table of changes to GL Budgets. ABSEXCH-12957}

{$ALIGN 1}

interface


uses
  BtrvU2, GlobVar, Dialogs, SysUtils, BtKeys1U;

Const

  BudgetHistoryF   =  28;

  bhNofKeys        =  1;
  bhNofSegs        =  6;

  bhGLCodeK        =  0; //GLCode + Year + Period + Date + Time

  BudgetHistoryPath   = 'Trans\GLBudgetHistory.dat';

type
  TBudgetHistoryRec = record
    bhGLCode       : longint;
    bhYear         : Byte;
    bhPeriod       : Byte;
    bhCurrency     : Byte;
    bhDateChanged  : string[8];
    bhTimeChanged  : string[6];
    bhValue        : Double;
    bhChange       : Double;
    bhUser         : string[10];
    Spare          : Array[1..150] of Byte;
  end;

  BudgetHistoryFile_Def = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..bhNofSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

var
  BudgetHistoryFile : BudgetHistoryFile_Def;
  BudgetHistory     : TBudgetHistoryRec;


implementation

procedure DefineBudgetHistory;
Const
  Idx = BudgetHistoryF;

Begin
  With BudgetHistoryFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(BudgetHistoryFile);
    Fillchar(BudgetHistoryFile,FileSpecLen[Idx],0);
    RecLen:=Sizeof(BudgetHistory);
    PageSize:=DefPageSize;  // 1k
    NumIndex:=bhNofKeys;
    Variable:=B_Variable+B_Compress+B_BTrunc;

    //Index 0 - GLCode + Year + Period + Date + Time

    //GLCode
    KeyBuff[1].KeyPos:=BtKeyPos(@BudgetHistory.bhGLCode,@BudgetHistory);
    KeyBuff[1].KeyLen:=SizeOf(BudgetHistory.bhGLCode);
    KeyBuff[1].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[1].ExtTypeVal:=BInteger;

    //Currency
    KeyBuff[2].KeyPos:=BtKeyPos(@BudgetHistory.bhCurrency,@BudgetHistory);
    KeyBuff[2].KeyLen:=SizeOf(BudgetHistory.bhCurrency);
    KeyBuff[2].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[2].ExtTypeVal:=BInteger;

    //Year
    KeyBuff[3].KeyPos:=BtKeyPos(@BudgetHistory.bhYear,@BudgetHistory);
    KeyBuff[3].KeyLen:=SizeOf(BudgetHistory.bhYear);
    KeyBuff[3].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[3].ExtTypeVal:=BInteger;

    //Period
    KeyBuff[4].KeyPos:=BtKeyPos(@BudgetHistory.bhPeriod,@BudgetHistory);
    KeyBuff[4].KeyLen:=SizeOf(BudgetHistory.bhPeriod);
    KeyBuff[4].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[4].ExtTypeVal:=BInteger;

    //Date  - YYYYMMDD
    KeyBuff[5].KeyPos:=BtKeyPos(@BudgetHistory.bhDateChanged[1],@BudgetHistory);
    KeyBuff[5].KeyLen:=SizeOf(BudgetHistory.bhDateChanged) - 1;
    KeyBuff[5].KeyFlags:=DupModSeg;

    //Time  - HHNNSS
    KeyBuff[6].KeyPos:=BtKeyPos(@BudgetHistory.bhTimeChanged[1],@BudgetHistory);
    KeyBuff[6].KeyLen:=SizeOf(BudgetHistory.bhTimeChanged) - 1;
    KeyBuff[6].KeyFlags:=DupMod;

  end; {With..}

  FileRecLen[Idx]:=Sizeof(BudgetHistory);

  Fillchar(BudgetHistory,FileRecLen[Idx],0);

  RecPtr[Idx]:=@BudgetHistory;

  FileSpecOfs[Idx]:=@BudgetHistoryFile;


  FileNames[Idx]:=BudgetHistoryPath;


  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('BudgetHistory: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}

end; {..}

initialization
  DefineBudgetHistory;

end.
