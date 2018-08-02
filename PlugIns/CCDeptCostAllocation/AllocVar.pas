unit AllocVar;

interface

uses
  GlobVar, BtrvU2;

const
  alNumOfKeys = 2;
  alNumSegments = 8;

  alGLIdx   = 0;
  alNameIdx = 2;

  AllocF = 1;

  AllocFileName = 'Alloc.dat';

  {$IFDEF EX600}
    sVersionNo = '019';
//    sVersionNo = 'v6.30.018';
  {$ELSE}
    sVersionNo = 'v5.71.018';
  {$ENDIF}


Type
  TAllocRec = Record
    CoCode     : string[6];
    GLCode     : longint;
    LinePos    : longint;
    AllocType  : Byte;    // 0 - CC, 1 - Dep, 2 - CC/Dep
    AllocName  : string[20];
    AllocDesc  : string[45];
    CC,
    Dep        : string[3];
    Percentage : Double;
    StopKey    : Char;
    RecType    : Byte; //0 - Line, 1 - Head
    Spare      : Array[1..128] of Byte;
  end;

  AllocFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..AlNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;


var
  AllocRec  : TAllocRec;
  AllocFile : AllocFileDef;
  EntDir    : string;



implementation

uses
  FileUtil, SysUtils;

procedure DefineAlloc;
const
  Idx = AllocF;
begin
  FileSpecLen[Idx] := SizeOf(AllocFile);
  FillChar(AllocFile, FileSpecLen[Idx],0);

  with AllocFile do
  begin
    RecLen := Sizeof(AllocRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := alNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - CompanyCode + GL Code + AllocType + LinePos + '!'
    // CompanyCode = string[6]
    KeyBuff[1].KeyPos := 2;
    KeyBuff[1].KeyLen := 6;
    KeyBuff[1].KeyFlags := DupModSeg;

    //GL Code - longint
    KeyBuff[2].KeyPos := BtKeyPos(@AllocRec.GLCode, @AllocRec);
    KeyBuff[2].KeyLen := 4;
    KeyBuff[2].KeyFlags := DupModSeg + ExtType;
    KeyBuff[2].ExtTypeVal:=BInteger;

    // AllocName = string[20]
    KeyBuff[3].KeyPos := BtKeyPos(@AllocRec.AllocName, @AllocRec) + 1;
    KeyBuff[3].KeyLen := 20;
    KeyBuff[3].KeyFlags := DupModSeg;

    //Line Pos = longint
    KeyBuff[4].KeyPos := BtKeyPos(@AllocRec.LinePos, @AllocRec);
    KeyBuff[4].KeyLen := 4;
    KeyBuff[4].KeyFlags := DupModSeg + ExtType;
    KeyBuff[4].ExtTypeVal:=BInteger;

    // Stop key - '!'
    KeyBuff[5].KeyPos := BtKeyPos(@AllocRec.StopKey, @AllocRec);
    KeyBuff[5].KeyLen := 1;
    KeyBuff[5].KeyFlags := DupMod;


    //Key 1 - CompanyCode + GL Code + AllocName
    // CompanyCode = string[6]
    KeyBuff[6].KeyPos := 2;
    KeyBuff[6].KeyLen := 6;
    KeyBuff[6].KeyFlags := DupModSeg;

    //GL Code - longint
    KeyBuff[7].KeyPos := BtKeyPos(@AllocRec.GLCode, @AllocRec);
    KeyBuff[7].KeyLen := 4;
    KeyBuff[7].KeyFlags := DupModSeg + ExtType;
    KeyBuff[7].ExtTypeVal:=BInteger;

    // AllocName = string[20]
    KeyBuff[8].KeyPos := BtKeyPos(@AllocRec.AllocName, @AllocRec) + 1;
    KeyBuff[8].KeyLen := 20;
    KeyBuff[8].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(AllocRec);
  FillChar(AllocRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @AllocRec;
  FileSpecOfS[Idx] := @AllocFile;
  FileNames[Idx] := EntDir + AllocFilename;
end;

Initialization
  EntDir := IncludeTrailingPathDelimiter(GetEnterpriseDirectory);
  DefineAlloc;

end.
