Unit VarFPOSU;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }





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

Uses
  GlobVar,BtrvU2;

{* Dummy unit to prevent Exchequer's own version picking this up *}

Const
  // Needed by DataDict.Pas
  {$I FilePath.Inc}


  { I VarListR.Def}


  { I VARCOMNU.PAS}

  //PR: 10/02/2012 Incremented to 37 for QtyBreaks file ABSEXCH-9795
  //PR: 30/01/2014 ABSEXCH-14974 Incremented to 38 for Account Contacts
  //PR: 14/10/2014 39 for Order Payments (OPVATPay.Dat)
  NoDataF        =  {28;} 39;

  NoExVers       =  29;

  NoDataTypes    =  12;

  NoDecTypes     =  3;

  NoRepDest      =  2;

  NoInpTypes     =  18;

  NoPEffects     =  11;

  NoBreakTyps    =  4;

  NoRepHedTyps   =  3;

  DocLen         =  09;

  AccLen         =  6;

  VNoLen         =  6;  {Max Lint length*}

  PrLen          =  3;

  MLocLen        =  3;

  StkLen         =  16;

  LoginLen       =  10;

  NHTypLen       =  1;

  CCDpLen        =  3;

  NoMMGrps       =  29;            {*  No. of Mailmerge groups         *}

  NoMMPerPage    =  9;             {*  No. MailMerge Groups per screen *}

  MaxNoSort      =  9;             {*  No. of Sort Fields *}

  ITypValSet     :  Set of Byte = [2,3,6..10];   {* Input types which are a value *}

  LnumValSet     :  Set of Byte = [6..8,10];     {* Integer based vales *}


  NofFastNdx     =  20;

  ErrStr         =  'ERROR';

  RSetLVal       =  #255#255#255#255#255;        {* Reset New LAst Value *}

  RepTypChar     :  Array[1..NoRepHedTyps] of Char = ('H','R','N');

  RWDataDMode    =  '_RWDM';
  RWMenuMode     =  '_RWMM';

  CTDStr         =  'CTD';


  { ============= General Data Dictionary Settings ============= }

  DataDicCode    =  'D';
  DataDicVar     =  'V';
  DataDicXRef    =  'X';
  DataDicNdx     =  'N';

  ReportGenCode  =  'R';
  RepHedTyp      =  'H';
  RepLineTyp     =  'L';

  RepGroupCode   =  'H';
  RepInpCode     =  'I';
  RepRepCode     =  'R';
  RepNomCode     =  'N';

  ExVerSwitch    =  '/EXV:';






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


  { Added from x:\entrprse\r&d\varfposu.pas }
  ULFirstIn,
  GotUserLic  :  Boolean;

  { HM 25/04/99: Added to allow compilation of other modules }
  ExMainCoPath{, TmpCoPath}  :  ^ShortString;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Begin

  New(DataFilesL);
  New(ExVersL);
  New(DataTypesL);
  New(DataTCharL);
  New(MMGroupies);
  New(DecTypesL);
  New(BreakTypL);
  New(OutPutL);
  New(RepInpTypesL);
  New(RepHedTypesL);
  New(PrintEffectL);
  New(FastNDXHedL);
  New(FastNDXOrdL);


  FillChar(DataFilesL^,Sizeof(DataFilesL^),0);

  FillChar(ExVersL^,Sizeof(ExVersL^),0);

  FillChar(DataTypesL^,Sizeof(DataTypesL^),0);

  FillChar(DataTCharL^,Sizeof(DataTCharL^),0);

  FillChar(MMGroupies^,Sizeof(MMGroupies^),0);

  FillChar(DecTypesL^,Sizeof(DecTypesL^),0);

  FillChar(BreakTypL^,Sizeof(BreakTypL^),0);

  FillChar(OutputL^,Sizeof(OutPutL^),0);

  FillChar(RepInpTypesL^,Sizeof(RepInpTypesL^),0);

  FillChar(RepHedTypesL^,Sizeof(RepHedTypesL^),0);

  FillChar(PrintEffectL^,Sizeof(PrintEffectL^),0);

  FillChar(FastNDXHedL^,Sizeof(FastNDXHedL^),0);

  FillChar(FastNDXOrdL^,Sizeof(FastNDXOrdL^),0);

  New(ExMainCoPath);
  FillChar(ExMainCoPath^,Sizeof(ExMainCoPath^),0);

  ULFirstIn  := False;
  GotUserLic := False;

end.
