unit UFFuncs;

{ prutherford440 08:53 25/03/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Interface
uses
  Windows;
// 'UF5Initialize' is the initialization function for new UFLs.  It lets the
// UFL know which version of CRW or CRPE it is working with.  'UFInitialize'
// will be used if the UFL is missing the newer function.

{$MINENUMSIZE 4}
{$STACKFRAMES ON}
{$ALIGN OFF}

const CurVersionNumber = $100;

//UFError definitions
const
    UFUserError        = -1;
    UFNoError          =  0;
    UFNoMemory         =  1;
    UFStringTooBig     =  2;
    UFDivideByZero     =  3;
    UFArrayIndexTooBig = 4;
    UFStringIndexTooBig =5;
    UFNotEnoughParameters =6;
    UFMemCalcFail         = 7;

type UFError = SmallInt;

type UFTInt16s = SmallInt;
type UFTInt16u = Word;

type UFTInt32s = LongInt;
type UFTInt32u = LongInt;
type CRNumber  = double;

type CRDate   = LongInt;
type CRTime   = LongInt;
type CRDateTime = record
                    date : CRDate ;
                    time : CRTime;
                  end;
type CRBoolean = SmallInt;

type CRVersion = LongInt;


type UFTNumber = CRNumber;
type UFTCurrency = UFTNumber ;

type UFTDate     = CRDate ;
type UFTTime     = CRTime ;
type UFTDateTime = CRDateTime;

type UFTBoolean  = CRBoolean;

type TReturnIntRange = record
                        IntStart : UFTInt32s;
                        IntEnd   : UFTInt32s;
                      end;

type  TReturnDateRange = record
                           DateStart : UFTDate;
                           DateEnd   : UFTDate;
                         end;

type  TReturnTimeRange = record
                           TimeStart : UFTTime;
                           TimeEnd   : UFTTime ;
                         end;
type TReturnDateTimeRange = record
                              DateTimeStart : UFTDateTime ;
                              DateTimeEnd   : UFTDateTime ;
                            end;
type TReturnNumberRange = record
                            NumberStart : UFTNumber ;
                            NumberEnd   : UFTNumber ;
                          end;
type TReturnStringRange = record
                            StringStart : PChar;
                            StringEnd   : PChar;
                          end;

type TReturnCurrencyRange = record
                            CurrencyStart : UFTCurrency;
                            CurrencyEnd   : UFTCurrency;
                          end;

type UFReturnUnion = packed record
 case Integer of

    1 : (ReturnNumber : UFTNumber);
    2 : (ReturnDate   : UFTDate);
    3 : (ReturnTime   : UFTTime);
    4 : (ReturnDateTime : UFTDateTime );
    5 : (ReturnBoolean : UFTBoolean );
    6 : (ReturnCurrency : UFTCurrency );
    7 : (ReturnString : PChar);
    8 : (ReturnIntRange : TReturnIntRange);
    9 : (ReturnDateRange:TReturnDateRange);
    10: (ReturnTimeRange : TReturnTimeRange);
    11: (ReturnDateTimeRange : TReturnDateTimeRange);
    12: (ReturnNumberRange : TReturnNumberRange);
    13: (ReturnStringRange : TReturnStringRange);
    14: (UFReturnUserError  : UFTInt32s );
    15: (ReturnNumberArray : ^UFTNumber);
    16: (ReturnDateArray   : ^UFTDate);
    17: (ReturnTimeArray   : ^UFTTime);
    18: (ReturnDateTimeArray : ^UFTDateTime);
    19: (ReturnBooleanArray  : ^UFTBoolean);
    20: (ReturnCurrencyArray : ^UFTCurrency);
    21: (ReturnStringArray   : ^char);
end;

type UFTypeDefs = (

    UFUndefinedType,
    UFNumber,
    UFCurrency,
    UFNumberToCurrency,
    UFInteger,
    UFBoolean,
    UFDate,
    UFStringArg,
    UFNumberRange,
    UFCurrencyRange,
    UFNumberToCurrencyRange,
    UFIntegerRange,
    UFBooleanRange, // ... for completeness, not likely used
    UFDateRange,
    UFStringRange,
    UFNumberArray,
    UFCurrencyArray,
    UFNumberToCurrencyArray,
    UFIntegerArray,
    UFBooleanArray,
    UFDateArray,
    UFStringArray,
    UFField,
    UFTime,
    UFDateTime,
    UFTimeRange,
    UFDateTimeRange,
    UFTimeArray,
    UFDateTimeArray);

type UFMemCalcParmTypes =
(
    UFLiteral,
    UFArray,
    UFVariable,
    UFExpression
);


type PUFMemCalcParam = ^UFMemCalcParam;
    UFParamUnion = packed record
     case Integer of
     1 : (ParamInteger : UFTInt32s);
     2 : (ParamNumber  : UFTNumber);
     3 : (ParamDate    : UFTDate  );
     4 : (ParamTime    : UFTTime);
     5 : (ParamDateTime: UFTDateTime );
     6 : (ParamBoolean : UFTBoolean) ;
     7 : (ParamCurrency: UFTCurrency) ;
     8 : (ParamString  : PChar);
     9 : (ParamNumberArray : ^UFTNumber);
     10: (ParamIntegerArray: ^UFTInt32s);
     11: (ParamDateArray   : ^UFTDate);
     12: (ParamTimeArray   : ^UFTTime);
     13: (ParamDateTimeArray: ^UFTDateTime);
     14: (ParamBooleanArray : ^UFTBoolean);
     15: (ParamCurrencyArray:  ^UFTCurrency);
     16: (ParamStringArray : ^PChar);
     17: (ParamArrayPointer: Pointer);
     18: (ParamIntRange :TReturnIntRange);
     19: (ParamDateRange: TReturnDateRange);
     20: (ParamTimeRange:TReturnTimeRange);
     21: (ParamDateTimeRange : TReturnDateTimeRange);
     22: (ParamNumberRange   : TReturnNumberRange);
     23: (ParamCurrencyRange : TReturnCurrencyRange);
     24: (ParamStringRange   : TReturnStringRange);
     25: (MemCalcSubParam    : PUFMemCalcParam);
  end;

     UFMemCalcParam = record

                        StructSize : UFTInt16u ;
                        NextMemCalcParam : PUFMemCalcParam;
                        MemCalcParamLength : UFTInt16s ;
                        MemCalcLiteralFlag : UFMemCalcParmTypes ;
                        MemCalcParamType   : UFTypeDefs ;
                        MemCalcParameter   : UFParamUnion ;
                      end;





type PUFParamListElement = ^UFParamListElement;
     UFParamListElement = record
                            StructSize : UFTInt16u;
                            NextParam  : PUFParamListElement;
                            ParamLength : UFTInt16s ;
                            ParamType   : UFTypeDefs;
                            Parameter   : UFParamUnion;
                          end;

const UFParamListElementSize  = sizeof (UFParamListElement);


type TUFErrorHandler = procedure (Err : UFError);stdcall; //void (FAR stdcall *UFErrorHandler) (UFError);
type PUFParamBlock = ^UFParamBlock;
     UFParamBlock = record
       StructSize  : UFTInt16u;
       ReturnValue : UFReturnUnion ;
       ReturnValueLength : UFTInt16s ;
       FunctionNumber    : UFTInt16s ;
       UFErrorHandler    : TUFErrorHandler;

       UFParamList       : PUFParamListElement;
       JobId             : UFTInt32u ;
     end;


type UFMemCalcType =
(
    UFCalcStringLength,
    UFCalcArraySize
);

type PUFMemCalcBlock = ^UFMemCalcBlock;
     UFMemCalcBlock = record
                        StructSize : UFTInt16u  ;
                        MemCalcCommand : UFMemCalcType ;
                        UFMemCalcArrayLength : UFTInt16s ;
                        UFMemCalcStringLength  : UFTInt16s ;
                        UFMemCalcParamList : PUFMemCalcParam; // For calculating string sizes
                        UFParamList        : PUFParamListElement;    // For calculating array sizes.
                      end;

//UFError (FAR stdcall *UFEntry) (UFParamBlock FAR *)
type TUFEntry = function (aUFParamBlock : PUFParamBlock) : UFError;stdcall;

//UFError (FAR stdcall *UFMemCalcFunc) (UFMemCalcBlock FAR *);
type TUFMemCalcFunc = function (aUFMemCalcBlock : PUFMemCalcBlock) : UFError;stdcall;

type UFFunctionDefStrings = record
                              FuncDefString : PChar;
                              UFEntry       : TUFEntry;
                              UFMemCalcFunc : TUFMemCalcFunc;
                            end;
     PUFFunctionDefStrings = ^UFFunctionDefStrings;

type PUFFunctionDefStringList = ^UFFunctionDefStringList;
    UFFunctionDefStringList = record
    StructSize : Word;
    UFFunctionDefStrPtr : PUFFunctionDefStrings;
end;



type PUFFunctionTemplates = ^UFFunctionTemplates;
     UFFunctionTemplates = record
                             FuncTemplate : PChar;
                           end;

type PUFFunctionTemplateList = ^UFFunctionTemplateList;
     UFFunctionTemplateList = record
                                StructSize : UFTInt16u  ;
                                UFFuncTemplatePtr : PUFFunctionTemplates;
                              end;


type   PUFFunctionExamples = ^UFFunctionExamples;
       UFFunctionExamples = record
                            FuncExample : PChar;
                          end;

type PUFFunctionExampleList = ^UFFunctionExampleList;
     UFFunctionExampleList = record
                               StructSize : UFTInt16u;
                               FuncExample : PUFFunctionExamples;
                             end;

type UF5FunctionDefStrings = record
                               FuncDefString : PChar;
                               UFEntry : TUFEntry;
                               UFMemCalcFunc : TUFMemCalcFunc;
                               callOnlyWhilePrintingRecords : UFTBoolean ;
                               hasSideEffects : UFTBoolean ;
                             end;


type PUF5FunctionDefStringList = ^UF5FunctionDefStringList;
     UF5FunctionDefStringList = record
                                  StructSize : UFTInt16u;

                                  UF5FunctionDefStrPtr : ^UF5FunctionDefStrings;
                                end;

type TUFInitialize = function : UFError;stdcall;

type  TUF5Initialize = function (crVersion : LongInt) : UFError;stdcall;

type TUFTerminate  = function : UFError;

type UFGetFunctionPrototypes = function : PUFFunctionDefStringList;

type UFGetFunctionTemplates = function : PUFFunctionTemplateList;

type UFGetFunctionExamples = function : PUFFunctionExampleList;

type UFCallFunction = function (i : UFTInt16s;paramPtr : PUFParamBlock) : UFError;stdcall;


type UFErrorRecovery = function (paramPtr : PUFParamBlock;errN : UFError) : PChar;stdcall;

type UFGetVersion = function :  UFTInt16u; stdcall;


// 'UF5GetFunctionDefStrings' is the preferred function for new UFLs.  It
// tells CRW or CRPE more about the functions defined by the UFL.
// 'UFGetFunctionDefStrings' will be used if the UFL is missing the newer
// function.

type UFGetFunctionDefStrings = function : PUFFunctionDefStringList;stdcall;

type UF5GetFunctionDefStrings = function : PUF5FunctionDefStringList;stdcall;

type UFStartJob = procedure(jobId : UFTInt32u );stdcall;

type UFEndJob   = procedure (jobId : UFTInt32u ); stdcall;

type UF5SaveState = function (jobId : UFTInt32u ) : HGLOBAL; stdcall;

type UF5RestoreState = function (jobId : UFTInt32u ;SavedState : HGLOBAL) : UFError;



function GetParam (Param : PUFParamBlock;ParamNumber : UFTInt16s) : PUFParamListElement;

function GetMemCalcParam (Param : PUFMemCalcBlock;ParamNumber : UFTInt16s) : PUFMemCalcParam;

function GetMemCalcArrayElement (Param : PUFMemCalcParam;ParamNumber : UFTInt16s) : PUFMemCalcParam;

function GetMemCalcRunParam (Param : PUFMemCalcBlock;ParamNumber : UFTInt16s) : PUFParamListElement;

implementation


function GetParam (Param : PUFParamBlock;ParamNumber : UFTInt16s) : PUFParamListElement;
var ParamPtr : PUFParamListElement;
begin
  ParamPtr := Param^.UFParamList;

  while (ParamNumber > 1) and (ParamPtr <> nil) do
  begin
    ParamPtr := ParamPtr^.NextParam;
    dec(ParamNumber);
  end;
  Result := ParamPtr;
end;


function GetMemCalcParam (Param : PUFMemCalcBlock;ParamNumber : UFTInt16s) : PUFMemCalcParam;
var ParamPtr : PUFMemCalcParam;
begin
  ParamPtr := Param^.UFMemCalcParamList;
  while (ParamNumber > 1) and (ParamPtr <> nil) do
  begin
    ParamPtr := ParamPtr^.NextMemCalcParam;
    dec(ParamNumber);
  end;
  Result := ParamPtr;
end;


function GetMemCalcArrayElement (Param : PUFMemCalcParam;ParamNumber : UFTInt16s) : PUFMemCalcParam;
var ParamPtr : PUFMemCalcParam;
begin
  ParamPtr := Param^.MemCalcParameter.MemCalcSubParam;
  while (ParamNumber > 1) and (ParamPtr <> nil) do
  begin
    ParamPtr := ParamPtr^.NextMemCalcParam;
    dec(ParamNumber);
  end;

  Result := ParamPtr;
end;


function GetMemCalcRunParam (Param : PUFMemCalcBlock;ParamNumber : UFTInt16s) : PUFParamListElement;
var ParamPtr : PUFParamListElement;
begin
  ParamPtr := Param^.UFParamList;
  while (ParamNumber > 1) and (ParamPtr <> nil) do
  begin
    ParamPtr := ParamPtr^.NextParam;
    dec(ParamNumber);
  end;
  Result := ParamPtr;
end;

end.


