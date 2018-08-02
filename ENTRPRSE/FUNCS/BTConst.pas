unit BTConst;

{$ALIGN 1}

interface

type
  TClientIdRec =  Record
    Reserved  :  Array[1..12] of Byte;
    AppId     :  Array[1..2] of Char;
    TaskId    :  SmallInt;
  end;

  TStr255  =  String[255];

  TFileVar  =  array[1..128] of char;

  TKeySpec  =  Record
     KeyPos,
     KeyLen,
     KeyFlags                :  SmallInt;
     NotUsed                 :  LongInt;
     ExtTypeVal              :  Byte;
     NullValue               :  Byte;
     Reserved                :  Array[1..4] of Char;
  end;

  TAltColtSeq  = Record
                 SigByte     :  Char;
                 Header      :  array[1..8] of Char;
                 AltColtChars:  array[0..255] of Char;
               end;

  TBTRec = record
    KeyS : TStr255;
    Status : integer;
  end;

const
  B_Open     =  0;
  B_Close    =  1;
  B_Insert   =  2;
  B_Update   =  3;
  B_EOF      =  9;
  B_Create   =  14;
  B_Stop     =  25;
  B_Unlock   =  27;
  B_Reset    =  28;

  B_BeginTrans= 1019;
  B_EndTrans =  20;
  B_AbortTrans= 21;
  B_GetEq    =  5;
  B_GetNext  =  6;
  B_GetNextEx=  36;
  B_GetPrev  =  7;
  B_GetPrevEx=  37;
  B_GetGretr =  8;
  B_GetGEq   =  9;
  B_GetLess  =  10;
  B_GetLessEq=  11;
  B_GetFirst =  12;
  B_GetLast  =  13;
  B_KeyOnly  =  50;
  B_SingWLock = 100;
  B_SingNWLock= 200;
  B_StepFirst = 33;
  B_StepDirect= 24;
  B_GetDirect = 23;
  B_StepLast  = 34;
  B_StepNext  = 24;
  B_StepNextEx= 38;
  B_StepPrevEx= 39;
  B_StepPrev  = 35;
  B_MultWLock = 300;
  B_MultNWLock= 400;
  B_SingLock  = 0;    { Add to Sing Locks }
  B_MultLock  = 200;  {  "  "   "     "   to Make Equivalent MultiLocks }
  B_Owner    =  29;

  BT_GetFirst = B_GetFirst;
  BT_GetNext = B_GetNext;
  BT_GetGreater = B_GetGretr;
  BT_GetPrevious = B_GetPrev;
  BT_GetGreaterOrEqual = B_GetGEq;
  BT_GetLessOrEqual = B_GetLessEq;
  BT_GetEqual = B_GetEq;
  BT_GetLast = B_GetLast;
  BT_GetLess = B_GetLess;
  BT_Lock_S = B_SingNWLock;
  BT_Lock_M = B_MultNWLock;
  BT_Unlock =  B_Unlock;
  BT_StepFirst = B_StepFirst;
  BT_StepNext = B_StepNext;

  BT_MaxDoubleKey = #124#59#119#48#209#66#238#127;
  BT_MinDoubleKey = #0#200#78#103#109#193#171#195;


{ Storage Type }
  AltColSeq  =  32;
  Descending =  64;
  ExtType    =  256;
  ManK       =  512;

{ Key Storage Types }
  BInteger   =  1;
  BString    : Byte =  0;
  BLString   : Byte =  10;
  BZString   =  11;
//  BBfloat    =  09;
  BUnsigned  =  14;
  BBoolean   =  07;
  BFloat     =  02;  { Equivalent to Turbo Double }
  BTime      =  04;  {     "      "    "   Word   }

  DefPageSize = 1024;
  DefPageSize2= 1536;
  DefPageSize3= 2048;
  DefPageSize4= 2560;
  DefPageSize5= 3072;
  DefPageSize6= 3584;
  DefPageSize7= 4096;

  {* File Attributes *}
  B_Variable =  1;   {* Allow Variable Length Records *}
  B_BTrunc   =  2;   {* Truncate Trailing Blanks in Variable Records *}
  B_PreAlloc =  4;   {* Preallocate disk space to reserve contiguous area *}
  B_Compress =  8;   {* Compress Repeated Data *}
  B_KeyOnlyF =  16;  {* Key Only File *}
  B_Rerv10   =  64;  {* Reserve 10% free space on pages *}
  B_Rerv20   =  128; {* Reserve 20% free space on pages *}
  B_Rerv30   =  192; {* Reserve 30% free space on pages *}
  B_SExComp1 =  32;  {* Add to Comparison code on a filter if Upper Alt trans is to be used *}
  B_SExComp2 =  64;  {* Add to Comparison code on a filter if Match constant is another field *}
  B_SExComp3 =  128; {* Add to Comparison code on a filter if String match is not case sensitive *}

  Modfy      = 2;
  Dup        = 1;
  AllowNull  = 8;
  ModSeg     = 18;
  DupSeg     = 17;
  DupMod     = 3;
  DupModSeg  = 19;

  IDX_DUMMY_CHAR = '!';

var
  UpperAlt : TAltColtSeq;

implementation

Procedure SetUpperAlt;
{ ================= Procedure to Define The Alternate Collating Sequence UpperAlt ================== }
Var
  Loop  :  Integer;
Begin
  With UpperALT do
  Begin
    SigByte:=Chr($AC);
    Header:='UPPERALT';

    For Loop:=0 to 255 do AltColtChars[Loop]:=Upcase(Chr(Loop));
  end; {With..}
end;

initialization
  SetUpperALT;

end.
