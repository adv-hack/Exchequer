unit CompilableVarRec;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses Graphics, Types, GlobVar, VarRec2U;

const
  FirstAddrD = -2147483647;
  FirstAddrH = $80000001;
  LastAddrD  = 2147483647;

{$I VarComnU.pas}
{$I VarCmn3U.pas}

type
  AltColtSeq  = Record
    SigByte     :  Char;
    Header      :  array[1..8] of Char;
    AltColtChars:  array[0..255] of Char;
  end;
  KeySpec  =  Record
     KeyPos,
     KeyLen,
     KeyFlags                :  SmallInt;
     NotUsed                 :  LongInt;
     ExtTypeVal              :  Byte;
     NullValue               :  Byte;
     Reserved                :  Array[1..4] of Char;
  end;

const
  {$I Varrec.pas}

var
   Syss          :   Sysrec;
   SyssVAT       :   ^VATRecT;
   SyssCurr      :   ^CurrRec;
   SyssGCur      :   ^GCurRec;
   SyssCurr1P    :   ^Curr1PRec;
   SyssGCur1P    :   ^GCur1PRec;

   SyssDEF       :   ^DefRecT;
   SyssForms     :   ^FormDefsRecType;
   SyssJob       :   ^JobSRecT;

   SyssMod       :   ^ModRelRecType;
   SyssEDI1      :   ^EDI1Rec;
   SyssEDI2      :   ^EDI2Rec;
   SyssEDI3      :   ^EDI3Rec;

   SyssCstm,
   SyssCstm2     :   ^CustomFRec;

   SyssCIS       :   ^CISRecT;

   SyssCIS340  :   ^CIS340RecT;

implementation

end.
