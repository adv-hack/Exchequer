{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVLEDef;

interface

uses
  Classes, Controls, SysUtils, Graphics;

const
  MAXIDLENGTH = 64;
  UseWideChar: boolean = false; { Use 2-byte wide characters? }

{ RAVE Command constants }

{ Stack - done }
  RAVE_STACK = 0;
  RAVEPUSHADDR = RAVE_STACK + 1;
  RAVEPUSHMETHODADDR = RAVE_STACK + 2;
  RAVEPUSHVAR = RAVE_STACK + 3;
  RAVEPUSHDATA = RAVE_STACK + 4;
  RAVEPUSHCONST = RAVE_STACK + 5;
  RAVEPUSHSTR = RAVE_STACK + 6;
  RAVEPUSHMETHODSTR = RAVE_STACK + 7;
  RAVEPUSHDEFAULT = RAVE_STACK + 8;
  RAVEPOP = RAVE_STACK + 9;

{ Call - done }
  RAVE_CALL = RAVEPOP;
  RAVEENTER = RAVE_CALL + 1;
  RAVECOPYPARAMDATA = RAVE_CALL + 2;
  RAVECOPYPARAMSTR = RAVE_CALL + 3;
  RAVECOPYPARAMDATADEF = RAVE_CALL + 4;
  RAVECOPYPARAMSTRDEF = RAVE_CALL + 5;
  RAVEFREESTR = RAVE_CALL + 6;
  RAVEFREEREC = RAVE_CALL + 7;
  RAVELOADVAR = RAVE_CALL + 8;
  RAVELOADDATA = RAVE_CALL + 9;
  RAVERETURN = RAVE_CALL + 10;
  RAVERETURNRES = RAVE_CALL + 11;
  RAVECALL = RAVE_CALL + 12;
  RAVECALLEXTERNALFUNC = RAVE_CALL + 13;
  RAVECALLEXTERNALPROC = RAVE_CALL + 14;
  RAVELONGCALL = RAVE_CALL + 15;

{ Jump - done }
  RAVE_JUMP = RAVELONGCALL;
  RAVEJUMPEQ = RAVE_JUMP + 1;
  RAVEJUMPNE = RAVE_JUMP + 2;
  RAVEJUMPLT = RAVE_JUMP + 3;
  RAVEJUMPLE = RAVE_JUMP + 4;
  RAVEJUMPGT = RAVE_JUMP + 5;
  RAVEJUMPGE = RAVE_JUMP + 6;
  RAVEJUMP = RAVE_JUMP + 7;
  RAVELONGJUMP = RAVE_JUMP + 8;

{ Compare }
  RAVE_COMPARE = RAVELONGJUMP;
  RAVEEQBOL = RAVE_COMPARE + 1;
  RAVENEBOL = RAVE_COMPARE + 2;
  RAVELTBOL = RAVE_COMPARE + 3;
  RAVEGTBOL = RAVE_COMPARE + 4;
  RAVELEBOL = RAVE_COMPARE + 5;
  RAVEGEBOL = RAVE_COMPARE + 6;
  RAVEEQINT = RAVE_COMPARE + 7;
  RAVENEINT = RAVE_COMPARE + 8;
  RAVELTINT = RAVE_COMPARE + 9;
  RAVEGTINT = RAVE_COMPARE + 10;
  RAVELEINT = RAVE_COMPARE + 11;
  RAVEGEINT = RAVE_COMPARE + 12;
  RAVEEQEXT = RAVE_COMPARE + 13;
  RAVENEEXT = RAVE_COMPARE + 14;
  RAVELTEXT = RAVE_COMPARE + 15;
  RAVEGTEXT = RAVE_COMPARE + 16;
  RAVELEEXT = RAVE_COMPARE + 17;
  RAVEGEEXT = RAVE_COMPARE + 18;
  RAVEEQCUR = RAVE_COMPARE + 19;
  RAVENECUR = RAVE_COMPARE + 20;
  RAVELTCUR = RAVE_COMPARE + 21;
  RAVEGTCUR = RAVE_COMPARE + 22;
  RAVELECUR = RAVE_COMPARE + 23;
  RAVEGECUR = RAVE_COMPARE + 24;
  RAVEEQCHR = RAVE_COMPARE + 25;
  RAVENECHR = RAVE_COMPARE + 26;
  RAVELTCHR = RAVE_COMPARE + 27;
  RAVEGTCHR = RAVE_COMPARE + 28;
  RAVELECHR = RAVE_COMPARE + 29;
  RAVEGECHR = RAVE_COMPARE + 30;
  RAVEEQSTR = RAVE_COMPARE + 31;
  RAVENESTR = RAVE_COMPARE + 32;
  RAVELTSTR = RAVE_COMPARE + 33;
  RAVEGTSTR = RAVE_COMPARE + 34;
  RAVELESTR = RAVE_COMPARE + 35;
  RAVEGESTR = RAVE_COMPARE + 36;

{ Binary operators - done }
  RAVE_BINARY  = RAVEGESTR;
  RAVEORBOL  = RAVE_BINARY + 1;
  RAVEXORBOL = RAVE_BINARY + 2;
  RAVEANDBOL = RAVE_BINARY + 3;
  RAVEADDINT = RAVE_BINARY + 4;
  RAVESUBINT = RAVE_BINARY + 5;
  RAVEMULINT = RAVE_BINARY + 6;
  RAVEDIVINT = RAVE_BINARY + 7;
  RAVEMODINT = RAVE_BINARY + 8;
  RAVEORINT  = RAVE_BINARY + 9;
  RAVEXORINT = RAVE_BINARY + 10;
  RAVEANDINT = RAVE_BINARY + 11;
  RAVESHLINT = RAVE_BINARY + 12;
  RAVESHRINT = RAVE_BINARY + 13;
  RAVEADDEXT = RAVE_BINARY + 14;
  RAVESUBEXT = RAVE_BINARY + 15;
  RAVEMULEXT = RAVE_BINARY + 16;
  RAVEDIVEXT = RAVE_BINARY + 17;
  RAVEADDCUR = RAVE_BINARY + 18;
  RAVESUBCUR = RAVE_BINARY + 19;
  RAVEMULCUR = RAVE_BINARY + 20;
  RAVEDIVCUR = RAVE_BINARY + 21;

{ Unary operators - done }
  RAVE_UNARY = RAVEDIVCUR;
  RAVENOTBOL = RAVE_UNARY + 1;
  RAVENOTINT = RAVE_UNARY + 2;
  RAVENEGINT = RAVE_UNARY + 3;
  RAVENEGEXT = RAVE_UNARY + 4;
  RAVENEGCUR = RAVE_UNARY + 5;

{ Conversion }
  RAVE_CONV = RAVENEGCUR;
  RAVESHT2INT = RAVE_CONV + 1;
  RAVEBYT2INT = RAVE_CONV + 2;
  RAVESML2INT = RAVE_CONV + 3;
  RAVEWRD2INT = RAVE_CONV + 4;
  RAVEINT2SHT = RAVE_CONV + 5;
  RAVEINT2BYT = RAVE_CONV + 6;
  RAVEINT2SML = RAVE_CONV + 7;
  RAVEINT2WRD = RAVE_CONV + 8;
  RAVEINT2SNG = RAVE_CONV + 9;
  RAVEINT2DBL = RAVE_CONV + 10;
  RAVEINT2EXT = RAVE_CONV + 11;
  RAVEINT2CUR = RAVE_CONV + 12;
  RAVESHT2EXT = RAVE_CONV + 13;
  RAVEBYT2EXT = RAVE_CONV + 14;
  RAVESML2EXT = RAVE_CONV + 15;
  RAVEWRD2EXT = RAVE_CONV + 16;
  RAVESNG2EXT = RAVE_CONV + 17;
  RAVEDBL2EXT = RAVE_CONV + 18;
  RAVECUR2EXT = RAVE_CONV + 19;
  RAVEEXT2SNG = RAVE_CONV + 20;
  RAVEEXT2DBL = RAVE_CONV + 21;
  RAVEEXT2CUR = RAVE_CONV + 22;
  RAVECHR2STR = RAVE_CONV + 23;
  RAVEDOUBLECONV = RAVE_CONV + 24;

{ Assign }
  RAVE_ASSIGN = RAVEDOUBLECONV;
  RAVEASSIGN = RAVE_ASSIGN + 1;
  RAVELEFTASSIGN = RAVE_ASSIGN + 2;
  RAVERIGHTASSIGN = RAVE_ASSIGN + 3;
  RAVEASSIGNSTR = RAVE_ASSIGN + 4;
  RAVELEFTASSIGNSTR = RAVE_ASSIGN + 5;
  RAVERIGHTASSIGNSTR = RAVE_ASSIGN + 6;
  RAVEADDINTASSIGN = RAVE_ASSIGN + 7;
  RAVESUBINTASSIGN = RAVE_ASSIGN + 8;
  RAVEMULINTASSIGN = RAVE_ASSIGN + 9;
  RAVEADDEXTASSIGN = RAVE_ASSIGN + 10;
  RAVESUBEXTASSIGN = RAVE_ASSIGN + 11;
  RAVEMULEXTASSIGN = RAVE_ASSIGN + 12;
  RAVEDIVEXTASSIGN = RAVE_ASSIGN + 13;
  RAVEADDCURASSIGN = RAVE_ASSIGN + 14;
  RAVESUBCURASSIGN = RAVE_ASSIGN + 15;
  RAVEMULCURASSIGN = RAVE_ASSIGN + 16;
  RAVEDIVCURASSIGN = RAVE_ASSIGN + 17;

{ Loop }
  RAVE_LOOP = RAVEDIVCURASSIGN;
  RAVEBEGINFORTO = RAVE_LOOP + 1;
  RAVEBEGINFORDOWNTO = RAVE_LOOP + 2;
  RAVEENDFOR = RAVE_LOOP + 3;
  RAVELOOPTEST = RAVE_LOOP + 4;
  RAVEIFTEST = RAVE_LOOP + 5;

{ Misc }
  RAVE_MISC = RAVEIFTEST;
  RAVENOP = RAVE_MISC + 1;
  RAVETERMINATE = RAVE_MISC + 2;
  RAVEADDSTR = RAVE_MISC + 3;

{ Debug }
  RAVE_DEBUG = RAVEADDSTR;
  RAVEBREAKPOINT = RAVE_DEBUG + 1;

type
  ERaveCompiler = class(Exception);

  TIdentifier = string;

  PIntList = ^TPointerList;
  TIntList = array[1..16380] of longint;
  PVMT = ^TVMT;
  TVMT = record
    ParentVMT: PVMT;
    Module: pointer;
    MethodList: PIntList;
    ClassName: TIdentifier;
    ClassType: pointer;
  end; { TVMT }

const
  OpChars = {Trans-}'!"#$%&''()*+,-./:;<=>?@[\]^{|}~';

type
  TTokenType = (ttID,ttString,ttInteger,ttFloat,ttCurrency,ttOperator,ttEOF);
  TTokenTypeSet = set of TTokenType;
  TScope = (scPrivate,scProtected,scPublic);
  TScopeSet = set of TScope;

  TIDKind = (idkVar,idkType,idkConst,idkFunc,idkMethod,idkOp);

  TTypeStruc = (
   tsSimple,
   tsEnumerated,
   tsArray,
   tsRecord,
   tsFunction,
   tsClass);

  TTypeKind = (
   tkBoolean, {true or false, 1 byte}
   tkShortint, {-128..127, 1 byte}
   tkByte, {0..255, 1 byte}
   tkSmallint, {-32768..32767, 2 bytes}
   tkWord, {0..65535, 2 bytes}
   tkInteger, {-2147483648..2147483647, 4 bytes}
   tkSingle, {7-8 sigfigs, 4 bytes}
   tkDouble, {15-16 sigfigs, 8 bytes}
   tkExtended, {19-20 sigfigs, 10 bytes}
   tkCurrency, {-922,337,203,685,477.5808..922,337,203,685,477.5807, 8 bytes}
   tkChar, {1 or 2 bytes depending upon WideChar setting}
   tkString, {string type of 1 or 2 byte chars}
   tkPointer,  {32 bit pointer}
   tkComplex); {record,class,function}

  TypeKindSet = set of TTypeKind;

  TMemberType = (mtElement,mtField,mtMethod,mtProperty); { Type of member for record/class }

const
  AllScopes: TScopeSet = [scPrivate,scProtected,scPublic];
  IntegerTypes = [tkShortint,tkByte,tkSmallint,tkWord,tkInteger];
  FloatTypes = [tkSingle,tkDouble,tkExtended,tkCurrency];
  OrdinalTypes = IntegerTypes + [tkBoolean,tkChar];
  StringTypes = [tkChar,tkString];
  MathTypes = IntegerTypes + FloatTypes;
  AllTypes = IntegerTypes + FloatTypes + StringTypes + [tkBoolean,tkPointer];

const
  UpgradeType: array[TTypeKind] of TTypeKind =
   (tkBoolean,tkInteger,tkInteger,tkInteger,tkInteger,tkInteger,tkExtended,
   tkExtended,tkExtended,tkCurrency,tkChar,tkString,tkPointer,tkComplex);

  TypeSize: array[TTypeKind] of byte = (1,1,1,2,2,4,4,8,10,8,1,4,4,0);

{ Type conversion constants }
  RAVEINVALID = 254;
  RAVEDEFAULT = 255;

  TypeConv1: array[tkShortint..tkCurrency,tkShortint..tkCurrency] of byte = (
   (RAVEDEFAULT,RAVEDEFAULT,RAVESHT2INT,RAVESHT2INT,RAVESHT2INT,RAVESHT2EXT,RAVESHT2EXT,RAVESHT2EXT,RAVESHT2INT),
   (RAVEDEFAULT,RAVEDEFAULT,RAVEBYT2INT,RAVEBYT2INT,RAVEBYT2INT,RAVEBYT2EXT,RAVEBYT2EXT,RAVEBYT2EXT,RAVEBYT2INT),
   (RAVESML2INT,RAVESML2INT,RAVEDEFAULT,RAVEDEFAULT,RAVESML2INT,RAVESML2EXT,RAVESML2EXT,RAVESML2EXT,RAVESML2INT),
   (RAVEWRD2INT,RAVEWRD2INT,RAVEDEFAULT,RAVEDEFAULT,RAVEWRD2INT,RAVEWRD2EXT,RAVEWRD2EXT,RAVEWRD2EXT,RAVEWRD2INT),
   (RAVEINT2SHT,RAVEINT2BYT,RAVEINT2SML,RAVEINT2WRD,RAVEDEFAULT,RAVEINT2SNG,RAVEINT2DBL,RAVEINT2EXT,RAVEINT2CUR),
   (RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEDEFAULT,RAVESNG2EXT,RAVESNG2EXT,RAVESNG2EXT),
   (RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEDBL2EXT,RAVEDEFAULT,RAVEDBL2EXT,RAVEDBL2EXT),
   (RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEEXT2SNG,RAVEEXT2DBL,RAVEDEFAULT,RAVEEXT2CUR),
   (RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVECUR2EXT,RAVECUR2EXT,RAVECUR2EXT,RAVEDEFAULT));

  TypeConv2: array[tkShortint..tkCurrency,tkShortint..tkCurrency] of byte = (
   (RAVEDEFAULT,RAVEDEFAULT,RAVEINT2SML,RAVEINT2WRD,RAVEDEFAULT,RAVEEXT2SNG,RAVEEXT2DBL,RAVEDEFAULT,RAVEINT2CUR),
   (RAVEDEFAULT,RAVEDEFAULT,RAVEINT2SML,RAVEINT2WRD,RAVEDEFAULT,RAVEEXT2SNG,RAVEEXT2DBL,RAVEDEFAULT,RAVEINT2CUR),
   (RAVEINT2SHT,RAVEINT2BYT,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT,RAVEEXT2SNG,RAVEEXT2DBL,RAVEDEFAULT,RAVEINT2CUR),
   (RAVEINT2SHT,RAVEINT2BYT,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT,RAVEEXT2SNG,RAVEEXT2DBL,RAVEDEFAULT,RAVEINT2CUR),
   (RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT),
   (RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEDEFAULT,RAVEEXT2DBL,RAVEDEFAULT,RAVEEXT2CUR),
   (RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEEXT2SNG,RAVEDEFAULT,RAVEDEFAULT,RAVEEXT2CUR),
   (RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT,RAVEDEFAULT),
   (RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEINVALID,RAVEEXT2SNG,RAVEEXT2DBL,RAVEDEFAULT,RAVEDEFAULT));

type
  TOpKind = (okTerm, { Order 0: Statement terminators }
   okAssign,okAddAssign,okSubAssign,okMulAssign,okDivAssign, { Order 1: :=,+=,
    -=,*=,/= }
   okEQ,okNE,okLT,okGT,okLE,okGE,okIS, { Order 2: =,<>,<,>,<=,>=,is }
   okAdd,okSub,okOR,okXOR, { Order 3: +,-,or or |,xor or ^ }
   okMul,okDiv,okIDiv,okMod,okAND,okSHL,okSHR,okAs, { Order 4: *,/,div,mod or %,
    and or &,shl or <<,shr or >>,as }
   okPos,okNeg,okNOT, { Order 5: +,-,@,not or ! (unary) }
   okLeftAssign,okRightAssign, { Order 6: <-,-> }
   okFunction,okMethod); { Order 7: function/method }

const
  OpOrder: array[TOpKind] of byte = (0,1,1,1,1,1,
   2,2,2,2,2,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,6,6,7,7);
  OpUnary = [okPos,okNeg,okNOT];
  OpSimpleAssign = [okAssign,okLeftAssign,okRightAssign];
  OpMathAssign = [okAddAssign,okSubAssign,okMulAssign,okDivAssign];
  OpStatementAssign = [okAssign] + OpMathAssign;
  OpAssign = OpSimpleAssign + OpMathAssign;
  OpTypes: array[TOpKind] of TypeKindSet = (
    [], { okTerm }
    AllTypes, { okAssign }
    AllTypes, { okAddAssign }
    AllTypes, { okSubAssign }
    AllTypes, { okMulAssign }
    AllTypes, { okDivAssign }
    AllTypes, { okEQ }
    AllTypes, { okNE }
    AllTypes, { okLT }
    AllTypes, { okGT }
    AllTypes, { okLE }
    AllTypes, { okGE }
    [], { okIS } {!!! tkClass? }
    MathTypes + StringTypes, { okAdd }
    MathTypes, { okSub }
    IntegerTypes + [tkBoolean], { okOR }
    IntegerTypes + [tkBoolean], { okXOR }
    MathTypes, { okMul }
    MathTypes, { okDiv }
    IntegerTypes, { okIDiv }
    IntegerTypes, { okMod }
    IntegerTypes + [tkBoolean], { okAND }
    IntegerTypes, { okSHL }
    IntegerTypes, { okSHR }
    [], { okAs } {!!! tkClass? }
    MathTypes, { okPos }
    MathTypes, { okNeg }
    IntegerTypes + [tkBoolean], { okNOT }
    AllTypes, { okLeftAssign }
    AllTypes, { okRightAssign }
    [], { okFunction } {!!!?}
    [] { okMethod } {!!!?}
  );

  OpBolCommand: array[TOpKind] of byte = (
    RAVEINVALID, { okTerm }
    RAVEINVALID, { okAssign }
    RAVEINVALID, { okAddAssign }
    RAVEINVALID, { okSubAssign }
    RAVEINVALID, { okMulAssign }
    RAVEINVALID, { okDivAssign }
    RAVEEQBOL, { okEQ }
    RAVENEBOL, { okNE }
    RAVELTBOL, { okLT }
    RAVEGTBOL, { okGT }
    RAVELEBOL, { okLE }
    RAVEGEBOL, { okGE }
    RAVEINVALID, { okIS } {!!! tkClass? }
    RAVEINVALID, { okAdd }
    RAVEINVALID, { okSub }
    RAVEORBOL, { okOR }
    RAVEXORBOL, { okXOR }
    RAVEINVALID, { okMul }
    RAVEINVALID, { okDiv }
    RAVEINVALID, { okIDiv }
    RAVEINVALID, { okMod }
    RAVEANDBOL, { okAND }
    RAVEINVALID, { okSHL }
    RAVEINVALID, { okSHR }
    RAVEINVALID, { okAs } {!!! tkClass? }
    RAVEINVALID, { okPos }
    RAVEINVALID, { okNeg }
    RAVENOTBOL, { okNOT }
    RAVEINVALID, { okLeftAssign }
    RAVEINVALID, { okRightAssign }
    RAVEINVALID, { okFunction }
    RAVEINVALID { okMethod }
  );

  OpIntCommand: array[TOpKind] of byte = (
    RAVEINVALID, { okTerm }
    RAVEINVALID, { okAssign }
    RAVEADDINTASSIGN, { okAddAssign }
    RAVESUBINTASSIGN, { okSubAssign }
    RAVEMULINTASSIGN, { okMulAssign }
    RAVEINVALID, { okDivAssign }
    RAVEEQINT, { okEQ }
    RAVENEINT, { okNE }
    RAVELTINT, { okLT }
    RAVEGTINT, { okGT }
    RAVELEINT, { okLE }
    RAVEGEINT, { okGE }
    RAVEINVALID, { okIS } {!!! tkClass? }
    RAVEADDINT, { okAdd }
    RAVESUBINT, { okSub }
    RAVEORINT, { okOR }
    RAVEXORINT, { okXOR }
    RAVEMULINT, { okMul }
    RAVEINVALID, { okDiv }
    RAVEDIVINT, { okIDiv }
    RAVEMODINT, { okMod }
    RAVEANDINT, { okAND }
    RAVESHLINT, { okSHL }
    RAVESHRINT, { okSHR }
    RAVEINVALID, { okAs } {!!! tkClass? }
    RAVEINVALID, { okPos }
    RAVENEGINT, { okNeg }
    RAVENOTINT, { okNOT }
    RAVEINVALID, { okLeftAssign }
    RAVEINVALID, { okRightAssign }
    RAVEINVALID, { okFunction }
    RAVEINVALID { okMethod }
  );

  OpExtCommand: array[TOpKind] of byte = (
    RAVEINVALID, { okTerm }
    RAVEINVALID, { okAssign }
    RAVEADDEXTASSIGN, { okAddAssign }
    RAVESUBEXTASSIGN, { okSubAssign }
    RAVEMULEXTASSIGN, { okMulAssign }
    RAVEDIVEXTASSIGN, { okDivAssign }
    RAVEEQEXT, { okEQ }
    RAVENEEXT, { okNE }
    RAVELTEXT, { okLT }
    RAVEGTEXT, { okGT }
    RAVELEEXT, { okLE }
    RAVEGEEXT, { okGE }
    RAVEINVALID, { okIS } {!!! tkClass? }
    RAVEADDEXT, { okAdd }
    RAVESUBEXT, { okSub }
    RAVEINVALID, { okOR }
    RAVEINVALID, { okXOR }
    RAVEMULEXT, { okMul }
    RAVEDIVEXT, { okDiv }
    RAVEINVALID, { okIDiv }
    RAVEINVALID, { okMod }
    RAVEINVALID, { okAND }
    RAVEINVALID, { okSHL }
    RAVEINVALID, { okSHR }
    RAVEINVALID, { okAs } {!!! tkClass? }
    RAVEINVALID, { okPos }
    RAVENEGEXT, { okNeg }
    RAVEINVALID, { okNOT }
    RAVEINVALID, { okLeftAssign }
    RAVEINVALID, { okRightAssign }
    RAVEINVALID, { okFunction }
    RAVEINVALID { okMethod }
  );

  OpCurCommand: array[TOpKind] of byte = (
    RAVEINVALID, { okTerm }
    RAVEINVALID, { okAssign }
    RAVEADDCURASSIGN, { okAddAssign }
    RAVESUBCURASSIGN, { okSubAssign }
    RAVEMULCURASSIGN, { okMulAssign }
    RAVEDIVCURASSIGN, { okDivAssign }
    RAVEEQCUR, { okEQ }
    RAVENECUR, { okNE }
    RAVELTCUR, { okLT }
    RAVEGTCUR, { okGT }
    RAVELECUR, { okLE }
    RAVEGECUR, { okGE }
    RAVEINVALID, { okIS } {!!! tkClass? }
    RAVEADDCUR, { okAdd }
    RAVESUBCUR, { okSub }
    RAVEINVALID, { okOR }
    RAVEINVALID, { okXOR }
    RAVEMULCUR, { okMul }
    RAVEDIVCUR, { okDiv }
    RAVEINVALID, { okIDiv }
    RAVEINVALID, { okMod }
    RAVEINVALID, { okAND }
    RAVEINVALID, { okSHL }
    RAVEINVALID, { okSHR }
    RAVEINVALID, { okAs } {!!! tkClass? }
    RAVEINVALID, { okPos }
    RAVENEGCUR, { okNeg }
    RAVEINVALID, { okNOT }
    RAVEINVALID, { okLeftAssign }
    RAVEINVALID, { okRightAssign }
    RAVEINVALID, { okFunction }
    RAVEINVALID { okMethod }
  );

  OpChrCommand: array[TOpKind] of byte = (
    RAVEINVALID, { okTerm }
    RAVEINVALID, { okAssign }
    RAVEINVALID, { okAddAssign }
    RAVEINVALID, { okSubAssign }
    RAVEINVALID, { okMulAssign }
    RAVEINVALID, { okDivAssign }
    RAVEEQCHR, { okEQ }
    RAVENECHR, { okNE }
    RAVELTCHR, { okLT }
    RAVEGTCHR, { okGT }
    RAVELECHR, { okLE }
    RAVEGECHR, { okGE }
    RAVEINVALID, { okIS } {!!! tkClass? }
    RAVEINVALID, { okAdd }
    RAVEINVALID, { okSub }
    RAVEINVALID, { okOR }
    RAVEINVALID, { okXOR }
    RAVEINVALID, { okMul }
    RAVEINVALID, { okDiv }
    RAVEINVALID, { okIDiv }
    RAVEINVALID, { okMod }
    RAVEINVALID, { okAND }
    RAVEINVALID, { okSHL }
    RAVEINVALID, { okSHR }
    RAVEINVALID, { okAs } {!!! tkClass? }
    RAVEINVALID, { okPos }
    RAVEINVALID, { okNeg }
    RAVEINVALID, { okNOT }
    RAVEINVALID, { okLeftAssign }
    RAVEINVALID, { okRightAssign }
    RAVEINVALID, { okFunction }
    RAVEINVALID { okMethod }
  );

  OpStrCommand: array[TOpKind] of byte = (
    RAVEINVALID, { okTerm }
    RAVEINVALID, { okAssign }
    RAVEINVALID, { okAddAssign }
    RAVEINVALID, { okSubAssign }
    RAVEINVALID, { okMulAssign }
    RAVEINVALID, { okDivAssign }
    RAVEEQSTR, { okEQ }
    RAVENESTR, { okNE }
    RAVELTSTR, { okLT }
    RAVEGTSTR, { okGT }
    RAVELESTR, { okLE }
    RAVEGESTR, { okGE }
    RAVEINVALID, { okIS } {!!! tkClass? }
    RAVEADDSTR, { okAdd }
    RAVEINVALID, { okSub }
    RAVEINVALID, { okOR }
    RAVEINVALID, { okXOR }
    RAVEINVALID, { okMul }
    RAVEINVALID, { okDiv }
    RAVEINVALID, { okIDiv }
    RAVEINVALID, { okMod }
    RAVEINVALID, { okAND }
    RAVEINVALID, { okSHL }
    RAVEINVALID, { okSHR }
    RAVEINVALID, { okAs } {!!! tkClass? }
    RAVEINVALID, { okPos }
    RAVEINVALID, { okNeg }
    RAVEINVALID, { okNOT }
    RAVEINVALID, { okLeftAssign }
    RAVEINVALID, { okRightAssign }
    RAVEINVALID, { okFunction }
    RAVEINVALID { okMethod }
  );

  OpPostConv: array[TOpKind] of boolean = (
    true, { okTerm }
    true, { okAssign }
    true, { okAddAssign }
    true, { okSubAssign }
    true, { okMulAssign }
    true, { okDivAssign }
    false, { okEQ }
    false, { okNE }
    false, { okLT }
    false, { okGT }
    false, { okLE }
    false, { okGE }
    true, { okIS } {!!! tkClass? }
    true, { okAdd }
    true, { okSub }
    true, { okOR }
    true, { okXOR }
    true, { okMul }
    true, { okDiv }
    true, { okIDiv }
    true, { okMod }
    true, { okAND }
    true, { okSHL }
    true, { okSHR }
    true, { okAs } {!!! tkClass? }
    true, { okPos }
    true, { okNeg }
    true, { okNOT }
    true, { okLeftAssign }
    true, { okRightAssign }
    true, { okFunction }
    true { okMethod }
  );

type
  TAddressLoc = (alBP,alSP,alDS);

  TAddress = record
    Loc: TAddressLoc;
    Module: word; { Only used for Loc = alDS }
    Offset: longint;
  end; { TAddress }

  PCodeLabel = ^TCodeLabel;
  TCodeLabel = record
    Offset: longint;
    AssignList: TList; { List of addresses to assign when finalize }
    Index: word; {!!! Debug only }
  end; { TCodeLabel }

  PExternalFunc = ^TExternalFunc;
  TExternalFunc = record
    Offset: longint; { Where address of external func will be written }
  end; { TExternalFunc }

implementation
end.