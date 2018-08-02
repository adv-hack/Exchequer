Unit VarRPOSU;




{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 31/07/90                      }
{                                                              }
{               Global variables & Type definitions            }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


{$O+}


Interface


{* Dummy unit to prevent Exchequer's own version picking this up *}

Const
  {$IFNDEF EXWIN}

    {$I FilePath.Inc}

    {$I VarListR.Def}

    DocLen         =  09;

    AccLen         =  6;

    VNoLen         =  6;  {Max Lint length*}

    PrLen          =  3;

    MLocLen        =  3;

    StkLen         =  16;

    LoginLen       =  10;

    NHTypLen       =  1;

    CCDpLen        =  3;

    NoMMPerPage    =  9;             {*  No. MailMerge Groups per screen *}

    MaxNoSort      =  9;             {*  No. of Sort Fields *}

    ITypValSet     :  Set of Byte = [2,3,6..10];   {* Input types which are a value *}

    LnumValSet     :  Set of Byte = [6..8,10];     {* Integer based vales *}


    ErrStr         =  'ERROR';

    RSetLVal       =  #255#255#255#255#255;        {* Reset New LAst Value *}

    RepTypChar     :  Array[1..NoRepHedTyps] of Char = ('H','R','N');

    RWDataDMode    =  '_RWDM';
    RWMenuMode     =  '_RWMM';

    CTDStr         =  'CTD';

  {$ENDIF}

  NoDataF        =  27;

  NoExVers       =  11;

  NoDataTypes    =  12;

  NoDecTypes     =  3;

  NoRepDest      =  2;

  NoInpTypes     =  17;

  NoPEffects     =  11;

  NoBreakTyps    =  4;

  NoRepHedTyps   =  3;

  NofFastNdx     =  18;

  NoMMGrps       =  29;            {*  No. of Mailmerge groups         *}


Type




  DataFileType   =  Array[0..NoDataF] of String[20];

  ExVersType     =  Array[0..NoExVers] of String[20];

  DataTypesType  =  Array[0..NoDataTypes] of String[10];

  DataTCharType  =  Array[0..NoDataTypes] of Char;

  DecTypesType   =  Array[0..NoDecTypes] of String[10];

  BreakTypesTyp  =  Array[0..NoBreakTyps] of String[4];

  RepDestType    =  Array[0..NoRepDest] of String[10];

  RepInpType     =  Array[0..NoInpTypes] of String[20];

  RepPEffType    =  Array[0..NoPEffects] of String[20];

  RepHedType     =  Array[0..NoRepHedTyps] of String[20];

  FastNDXHedType =  Array[0..NoDataF,0..NofFastNDX] of String[20];

  FastNDXOrdType =  Array[0..NoDataF,0..NofFastNDX] of Byte;


  MMGroupTyp  =  Array[1..NoMMGrps] of
                 Record
                   Groupies  :  String[15];        { Mailmerge groupings }
                   Belongs   :  Boolean;
                 end;

Var
  DataFilesL    : ^DataFileType;

  ExVersL       : ^ExVersType;

  DataTypesL    : ^DataTypesType;

  DataTCharL    : ^DataTCharType;

  DecTypesL     : ^DataTypesType;

  BreakTypL     : ^BreakTypesTyp;

  RepInpTypesL  : ^RepInpType;

  RepHedTypesL  : ^RepHedType;

  OutPutL       : ^RepDestType;

  PrintEffectL  : ^RepPEffType;

  FastNDXHedL   : ^FastNDXHedType;

  FastNDXOrdL   : ^FastNDXOrdType;

  MMGRoupies    : ^MMGroupTyp;

  MMrgeBase     : LongInt;




{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$IFDEF EXWIN}
Initialization
  GetMem (DataFilesL, SizeOf (DataFilesL^));
  GetMem (ExVersL, SizeOf (ExVersL^));
  GetMem (DataTypesL, SizeOf (DataTypesL^));
  GetMem (DataTCharL, SizeOf (DataTCharL^));
  GetMem (DecTypesL, SizeOf (DecTypesL^));
  GetMem (BreakTypL, SizeOf (BreakTypL^));
  GetMem (RepInpTypesL, SizeOf (RepInpTypesL^));
  GetMem (RepHedTypesL, SizeOf (RepHedTypesL^));
  GetMem (OutPutL, SizeOf (OutPutL^));
  GetMem (PrintEffectL, SizeOf (PrintEffectL^));
  GetMem (FastNDXHedL, SizeOf (FastNDXHedL^));
  GetMem (FastNDXOrdL, SizeOf (FastNDXOrdL^));
  GetMem (MMGRoupies, SizeOf (MMGRoupies^));
Finalization
  FreeMem (DataFilesL, SizeOf (DataFilesL^));
  FreeMem (ExVersL, SizeOf (ExVersL^));
  FreeMem (DataTypesL, SizeOf (DataTypesL^));
  FreeMem (DataTCharL, SizeOf (DataTCharL^));
  FreeMem (DecTypesL, SizeOf (DecTypesL^));
  FreeMem (BreakTypL, SizeOf (BreakTypL^));
  FreeMem (RepInpTypesL, SizeOf (RepInpTypesL^));
  FreeMem (RepHedTypesL, SizeOf (RepHedTypesL^));
  FreeMem (OutPutL, SizeOf (OutPutL^));
  FreeMem (PrintEffectL, SizeOf (PrintEffectL^));
  FreeMem (FastNDXHedL, SizeOf (FastNDXHedL^));
  FreeMem (FastNDXOrdL, SizeOf (FastNDXOrdL^));
  FreeMem (MMGRoupies, SizeOf (MMGRoupies^));

{$ENDIF}
end.
