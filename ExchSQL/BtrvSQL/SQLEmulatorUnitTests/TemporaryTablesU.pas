unit TemporaryTablesU;

interface

uses BtrvU2;

const
  ReportF     =     17;
  RpNofKeys   =     1;
  RpK         =     0;
  RpNofSegs   =     1;

type
  RepScrPtr   =  ^RepScrRec;
  RepScrRec   =   Record
    AccessK   :  String[100];
    RepFolio  :  LongInt;
    FileNo    :  SmallInt;
    KeyPath   :  SmallInt;
    RecAddr   :  LongInt;
    KeyStr    :  String[100];
    UseRad    :  Boolean;
    Spare     :  Array[1..41] of Byte;
  end;

  Rep_FilePtr = ^Rep_FileDef;

  Rep_FileDef = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..RpNofSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

var
   RepScr        :   RepScrPtr;
   RepFile       :   Rep_FilePtr;

implementation

procedure DefineRepScr;
const
  Idx = ReportF;
begin
  with RepFile^ do
  begin
    FileSpecLen[Idx]:=Sizeof(RepFile^);
    Fillchar(RepFile^,FileSpecLen[Idx],0);
    RecLen:=Sizeof(RepScr^);
    PageSize:=DefPageSize;
    NumIndex:=RpNofKeys;

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    { 00 - (AccessK) (RpK)  }

    KeyBuff[1].KeyPos:=2;
    KeyBuff[1].KeyLen:=100;
    KeyBuff[1].KeyFlags:=DupMod;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}

  FileRecLen[Idx]:=Sizeof(RepScr^);

  Fillchar(RepScr^,FileRecLen[Idx],0);

  RecPtr[Idx]:=@RepScr^;

  FileSpecOfs[Idx]:=@RepFile^;

  FileNames[Idx]:='';

end; {..}

initialization

  New(RepFile);
  New(RepScr);

  DefineRepScr;

finalization

  Dispose(RepScr);
  Dispose(RepFile);

end.
