{ Copyright (c) 1985, 88 by Borland International, Inc. }

unit MCPARSER;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils,
  GlobVar,
  VarConst,
  RwRecurse,
  VarFPosU,
  MCVars,
  MCUtil,
  ETMiscU,
  DicLnk2U,
  RepObj2U,
  RepObjIU,
  ExBtTh1U,
{$IFDEF GUI}
  GuiVar,
{$ENDIF}
  McFuncs,
  GlobType;


{ DEFINE FMLDBG}


{ Parses the string s - returns the Value of the evaluated string, and puts
   the attribute in Att: TXT = 0, CONSTANT = 1, FORMULA = 2, +4 = ERROR.
}

const
  MAXFUNCNAMELEN = 255;         { xxxxxxx[12345678] }

type
    TFuncRec = Record
      FName : string[12];
      FParams : Byte;
      FType : Byte;
    end;

type
{  TokenRec = record
    State : Byte;
    case Byte of
      0 : (Value : Real);
      1 : (Row, Col : Word);
      2 : (FuncName : String[MAXFUNCNAMELEN]);
  end;}

  TokenRec = record
    State : Byte;
    Value : Real;
    Row, Col : Word;
    FuncName : String[MAXFUNCNAMELEN];
   end;

  ParserStackType = array[1..PARSERSTACKSIZE] of TokenRec;

  TParserStateRec = Record
    tmpStack : ParserStackType;
    tmpCurToken : TokenRec;
    tmpStackTop, tmpTokenType : Word;
    tmpMathError, tmpTokenError, tmpIsFormula : Boolean;
    tmpFieldNo : Integer;
    tmpInput : String[255];
  end;



const
  { SBS Formula functions }
  DBFieldFunc      = 'DBF';
  FormulaFunc      = 'FML';
  TableColFunc     = 'TBC';
  TablePrevColFunc = 'TBP';
  TableTotalFunc   = 'TBT';
  TableRowNoFunc   = 'TRW';
  PageNoFunc       = 'PAGENO';
  DocSignFunc      = 'DOCSIGN';
  IdQtyFunc        = 'IDQTY';
  CustNoteGFunc    = 'GCUSTNOT';
  SuppNoteGFunc    = 'GSUPPNOT';
  InvNoteGFunc     = 'GINVNOT';
  StockNoteGFunc   = 'GSTKNOT';
  CustNoteDFunc    = 'DCUSTNOT';
  SuppNoteDFunc    = 'DSUPPNOT';
  InvNoteDFunc     = 'DINVNOT';
  StockNoteDFunc   = 'DSTKNOT';
  FormatDateFunc   = 'FMTDATE';
  SNoNoteGFunc     = 'GSERNOT';
  SNoNoteDFunc     = 'DSERNOT';
  JobNoteGFunc     = 'GJOBNOT';
  JobNoteDFunc     = 'DJOBNOT';

  { Currency & Rate functions }
  RateCompFunc     = 'RTCOMP';     { Company Rate }
  RateDayFunc      = 'RTDAILY';    { Daily Rate }
  RateFloatFunc    = 'RTFLOAT';    { Floater Rate }
  CcyNameFunc      = 'CCYNAME';    { Currency Name }
  CcySymbFunc      = 'CCYSYMB';    { Currency Print Symbol }

  { HM 28/09/99: Additional functions to support v4.31 extended currency table }
  CcyAgeFunc       = 'CCYAGE';     { Currency Ageing }
  RateInvFunc      = 'RTINVRT';    { Invert Rate }

  CurrencyType     = 90;

  MaxNewFuncs      = 11;

  RoundF           = 1;
  MinF             = 2;
  MaxF             = 3;
  IfF              = 4;
  SubStrF          = 5;
  Text2NoF         = 6;
  No2TextF         = 7;
  Date2TextF       = 8;
  Date2NoF         = 9;
  TrimF            = 10;
  TruncF           = 11;

  RoundFunc        = 'ROUND';
  MinFunc          = 'MIN';
  MaxFunc          = 'MAX';
  IfFunc           = 'IF';
  SubStringFunc    = 'SUBSTRING';
  Text2NoFunc      = 'TEXTTONUMBER';
  No2TextFunc      = 'NUMBERTOTEXT';
  Date2TextFunc    = 'DATETOTEXT';
  Date2NoFunc      = 'DATETONUMBER';
  TrimFunc         = 'TRIM';
  TruncFunc        = 'TRUNC';

  SysRepIgnore     = 'SYSREPC';

  NoOfConditions = 9;

  Conditions : Array[1..NoOfConditions] of String[2] = ('>', '>=', '=', '<=', '<>','=', #1,#2,#3);


  NewFuncs : Array[1..MaxNewFuncs] of TFuncRec = ((FName: RoundFunc;       FParams : 2; FType : 3),
                                                  (FName: MinFunc;         FParams : 2; FType : 3),
                                                  (FName: MaxFunc;         FParams : 2; FType : 3),
                                                  (FName: IfFunc;          FParams : 3; FType : 5),
                                                  (FName: SubStringFunc;   FParams : 3; FType : 5),
                                                  (FName: Text2NoFunc;     FParams : 1; FType : 3),
                                                  (FName: No2TextFunc;     FParams : 2; FType : 5),
                                                  (FName: Date2TextFunc;   FParams : 2; FType : 5),
                                                  (FName: Date2NoFunc;     FParams : 1; FType : 2),
                                                  (FName: TrimFunc;        FParams : 1; FType : 5),
                                                  (FName: TruncFunc;       FParams : 1; FType : 6));

Type
  ParseErrType = (fOK, fUnknown, fBlank, fNoSquare, fUnknCmd, fUnknOp,
                  fMathErr, fNoBracket, fNoParam, fInvStruct, fInvParam);


Type
  TGetDBFEvent = Function (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType Of Object;
  TDocSignEvent = Function : SmallInt Of Object;
  TNoParamsEvent = Function : ResultValueType Of Object;
  TGetNoteEvent = Function (Const NoteNo   : String;
                            Const NoteType : Char) : String Of Object;
  TFmtDateEvent = Function (Const DateCode : String;
                            Const Units    : SmallInt;
                            Const OffUnits : Char;
                            Const Format   : SmallInt) : ResultValueType Of Object;

  rwValErrorEvent = Procedure (RVNo : Str10; ValLine :  ShortString) Of Object;

  TSetPeriodProc = procedure (DicLink : DictLinkType; WantPeriod : Boolean) of Object;


  RepLinePtr   =  ^RepLineRObj;

  RepLineRObj  =  Object(List)
                    RepDrive  : SmallInt;
                    OrigFile  : SmallInt;

                    ColText   :  ColTextPtrType;

                    CurrNode  :  NodePtr;
                    RepField  :  RepFieldPtr;
                    InpObj    :  RepLInpPtr;

                    NoTBreaks,
                    TBreakFound,
                    FmulaBreak,
                    BreakMode
                              :  Byte;

                    FirstGo,
                    SubTOn,
                    CalcBreak,
                    SummOn,
                    FmulaErr,
                    SelErr,
                    RunNomCtrl
                              :  Boolean;

                    RepLName  :  Str10;

                    SortList    :  Array[0..MaxNoSort] of LongInt;
                    BreakList   :  Array[0..MaxNoSort] of LongInt;
                    PrntBrkList :  Array[0..MaxNoSort] of Boolean;

                    OnValErr  :  rwValErrorEvent;
                    FormulaStr                       : AnsiString;
                    FormulaDecs                      : Byte;
                    IsEvaluation                     : Boolean;

                    VErrCode : Integer;
                    VErrMsg,
                    VErrWord  : string;
                    VErrLine : longint;

    FormulaErrType    : ParseErrType;
    FormulaErrPos     : Word;
    GetDBFEvent       : TGetDBFEvent;
    GetFMLEvent       : TGetDBFEvent;
    GetTBCEvent       : TGetDBFEvent;
    GetTBPEvent       : TGetDBFEvent;
    GetTBTEvent       : TGetDBFEvent;
    GetTRWEvent       : TGetDBFEvent;
    GetDocSignEvent   : TDocSignEvent;
    GetCustNoteEvent  : TGetNoteEvent;
    GetSuppNoteEvent  : TGetNoteEvent;
    GetInvNoteEvent   : TGetNoteEvent;
    GetStockNoteEvent : TGetNoteEvent;
    GetSNoNoteEvent   : TGetNoteEvent;
    GetJobNoteEvent   : TGetNoteEvent;
    GetPageNoEvent    : TDocSignEvent;
    GetIdQtyEvent     : TNoParamsEvent;
    GetFmtDateEvent   : TFmtDateEvent;
    GetCcyEvent       : TFmtDateEvent;
    GetCcyAgeEvent    : TFmtDateEvent;

                    {$IFDEF GUI}
                    GetLineField : TGetFieldEvent;
                    GetInput     : TGetInputEvent;
                    SetPeriodDetails : TSetPeriodProc;
                    GetFieldFromName : TFieldFromNameProc;
                    GetCustomValue : TGetCustomValueFunc;
                    NotifyFieldValue : TFieldValueByNumberProc;
                    NotifyField : TFieldProc;
                    CustomIDs : Array of String;
                    FirstPass    : Boolean;
                    ErrLine      : longint;
                    ErrField     : longint;
                    Recurse        : TRecurseCheck;

                    function GetCustomVal(const ID : string) : ResultValueType;
                    function GetField(WhichType : Integer;
                                      MTExLocal : tdPostExLocalPtr) : Integer;
    Function GetFieldVal(Const Field   : String) : ResultValueType;
    function GetFormulaValue(Const Field   : String) : ResultValueType;
    Function ProcessFMTDate(    RepStr   : String;
                            Var FormLen  : Word;
                            Var FormName : ShortString;
                            Var ParInfo  : ParamsType)  :  Boolean;
    Function ProcessRateFunc(    RepStr   : String;
                             Var FormLen  : Word;
                             Var FormName : ShortString;
                             Var ParInfo  : ParamsType)  :  Boolean;
    Function ProcessCcyAging(    RepStr   : String;
                             Var FormLen  : Word;
                             Var FormName : ShortString;
                             Var ParInfo  : ParamsType)  :  Boolean;
    function RemoveSqBr(const s : String) : String;

                    {$ENDIF}

                    Constructor Init(RunName   : Str10;
                                     MTExLocal : tdPostExLocalPtr);


                    Destructor Done;

                    Procedure InitRepFObj(Fnum, Keypath :  Integer;
                                          MTExLocal     :  tdPostExLocalPtr);

                    Function FindObj(VarNo  :  LongInt)  :  Boolean;

                    Function GetOperand(Opo  :  String)  :  Byte;

                    Function SelectTxlate(FStr     :  Str80;
                                      Var IsValue,
                                          HasErr   :  Boolean)  :  Str80;

                    Function EvalVar(EvalEx  :  Str80;
                                 Var IsValue,
                                     HasErr  :  Boolean)  :  Str80;

                    Function EvalCond(StaM  :  ShortString;
                                  Var WPos,
                                      HasErr:  Byte;
                                      Validate : Boolean = False)  :  Boolean;
                    function ExtractCond(s : string; FirstOrSecond : Byte) : string;

                    Function GetLogic(Opo  :  Str5)  :  Byte;

                    Function CountBracket(BStr  :  Str20)  :  Integer;

                    Function Process_BODMAS(BrackStr  :  ShortString;
                                        Var WPos,
                                            Error     :  Byte)  :  ShortString;

                    Function Evaluate_Expression(Expression  :  ShortString;
                                                 Var Error       :  Byte;
                                           Validate    :  Boolean = False)  :  Boolean;

                    Function ConcatCalc(FStr   :  String;
                                    Var IVType :  Byte;
                                    Var HasErr :  Boolean)  :  String;

                    Function FormulaTxlate(FStr   :  Str80;
                                       Var HasErr :  Boolean)  :  Double;

                    procedure Reduce(Reduction : Word);

                    function Parse(S : String; var Att : Word; var StrRes : string) : Real;

                    Function SetFormula(Formula  :  ShortString;
                                        NoDecs   :  Byte;
                                    Var IVType   :  Byte)  :  Str80;

                    Function LinkObj(    VarNo  :  LongInt;
                                     Var DLinkR :  DictLinkType;
                                         InpStr :  Str255)  :  Str255;


                    Procedure FillObject(Var SelectOk  :  Boolean);

                    Function FillHeader  :  Str255;

                    Function FillLine  :  Str255;

                    Function FillTULine(FinLine  :  Boolean)  :  Str255;

                    Procedure ReCalcBreaks(BTNo      :  Byte;
                                       Var RepFRec   :  RepFieldType);

                    Function FillTotal(BTNo     :  Byte;
                                       ShowBrk  :  Boolean)  :  AnsiString;

                    {Function FillSummary(BTNo  :  Byte;
                                         RepLF :  Boolean)  :  Str255;}
                    Procedure FillSummary(BTNo : Byte; RepLF, IsCSV : Boolean);

                    Function FullSortKey  :  Str255;

                    Procedure LineTotals(Mode,
                                         BTNo  :  Byte);

                    Function IncInSumm(BTNo  :  Byte)  :  Boolean;

                    Procedure ReduceBreak(BTNo  :  Byte);

                    Function FillCDFLine :  AnsiString;

                    Function FillCDFTotals(BTNo     :  Byte;
                                           ShowBrk  :  Boolean) :  AnsiString;

                    Function FillNomTotLine(SubsBlnk  :  Boolean) :  Str255;

                    Function  GetColWidths : ColWidthsType;
                    Procedure FillColText;
                    Procedure FillNomColText (SubsBlnk : Boolean);
                    Function  FillUndies(FinLine  :  Boolean) : ColUndiesType;
                    procedure WriteDbfRecord;
                    Function Is_RepVar(RepStr   :  String;
                                   Var FormLen  :  Word;
                                   Var FormName :  ShortString)  :  Boolean;
                    Function Is_CustomID(RepStr   :  String;
                                     Var FormLen  :  Word;
                                     Var FormName :  ShortString)  :  Boolean;
                    function ProcessNewFunc(RepStr : string; FuncNo : Byte) : string;
                    function DoIfFunc(const Cond     : string;
                                      const ValTrue  : string;
                                      const ValFalse : string) : String;
                    function DoMinMaxFunc(const d1, d2 : Double;
                                           WantMax : Boolean) : string;
                    function DoRoundFunc(const d1, d2 : Double) : string;
                    function DoSubStringFunc(const v1 : string;
                                             d1, d2 : Double) : string;
                    function DoNo2TextFunc(d1 : Double; const v1 : string) : string;
                    function DoDate2TextFunc(const v1, v2 : string) : string;
                    function DoDate2NoFunc(const v1 : string) : string;
                    function DoTruncFunc(const d1 : double) : string;
                    function GetNewFuncLength(const s : string) : integer;
                    function IsInput(const s : string) : Boolean;

                    function NextToken : Word;
                    procedure Shift(State : Word);
                    procedure Push(Token : TokenRec);

                  end; {Object}

  function IsNewFunc(RepStr   :  string;
                 var FuncNo   :  Byte) : Boolean;

  function ContainsNewFunc(RepStr   :  string;
                       var FuncNo   :  Byte;
                       var StartPos :  Integer;
                       var EndPos   :  Integer) : Boolean;

  procedure SaveParser(var R : TParserStateRec);
  procedure RestoreParser(const R : TParserStateRec);

var
  FieldNumber : Integer;




 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Dialogs,
   Forms,
   {Crt,
   Dos,
   EWinSBS,}
   ETStrU,
   {ETools2,
   ETPrintU,
   EPrntDef,
   ETPrompt,}
   ETDateU,
   {ExAsvarU,}

   BtrvU2,
   BtSupU1,

   {InvListU,}
   {ComnUnit,}
   {ComnU2,}
   SysU1,
   DicLinkU,

//   GlobType,      { from Form Designer for Dictionary Link }

   {$IFDEF FMLDBG}
   Classes,
   {$ENDIF}

{$IFDEF DBF}
   DbfInt,
   Classes,
{$ENDIF}

   RwOpenF,
   {RwListU,}
   RwFuncs,
   RpCommon, Math, StrUtils;




const
  PLUS = 0;
  MINUS = 1;
  TIMES = 2;
  DIVIDE = 3;
  EXPO = 4;
  COLON = 5;
  OPAREN = 6;
  CPAREN = 7;
  NUM = 8;
  CELLT = 9;
  FUNC = 10;
  EOL = 11;
  BAD = 12;
//  MAXFUNCNAMELEN = 17;         { xxxxxxx[12345678] }



var
  Stack : ParserStackType;
  CurToken : TokenRec;
  StackTop, TokenType : Word;
  MathError, TokenError, IsFormula : Boolean;
  Input : String;



  {$IFDEF FMLDBG}
  StrList : TStringList;
  {$ENDIF}

function TidyUp(const s : string) : string;
begin
  Result := AnsiReplaceStr(Trim(s),',', '');
end;

Function LocWord(StartAT,Wordno:byte;Str:String; DelimChar : Char = #32):Integer;
{local proc used by PosWord and Extract word}
var
  W,L: integer;
  Spacebefore: boolean;
begin
    If (Length(Str)=0) or (wordno < 1) or (StartAT > length(Str)) then
    begin
        LocWord := 0;
        exit;
    end;
    SpaceBefore := true;
    W := 0;
    L := length(Str);
    StartAT := pred(StartAT);
    While (W < Wordno) and (StartAT < length(Str)) do
    begin
        StartAT := succ(StartAT);
        If SpaceBefore and (Str[StartAT] <> DELIMChar) then
        begin
            W := succ(W);
            SpaceBefore := false;
        end
        else
            If (SpaceBefore = false) and (Str[StartAT] = DELIMChar) then
                SpaceBefore := true;
    end;
    If W = Wordno then
       LocWord := StartAT
    else
       LocWord := 0;
end;



Function WordCntDef(const Str:String; DelimChar : Char = #32): Integer;
var
  W,I: integer;
  SpaceBefore: boolean;
begin
    If Length(Str)=0 then
    begin
        Result := 0;
        exit;
    end;
    SpaceBefore := true;
    W := 0;
    For  I :=  1 to length(Str) do
    begin
        If SpaceBefore and (Str[I] <> DELIMChar) then
        begin
            W := succ(W);
            SpaceBefore := false;
        end
        else
            If (SpaceBefore = false) and (Str[I] = DELIMChar) then
                SpaceBefore := true;
    end;
    Result := W;
end;


Function ExtractWordsDef(StartWord,NoWords:byte;Str:String; DelimChar : Char = #32):String;
var Start, finish : integer;
begin
    If Length(Str)=0 then
    begin
        Result := '';
        exit;
    end;
    Start := LocWord(1,StartWord,Str,DelimChar);
    If Start <> 0 then
       finish := LocWord(Start,succ(NoWords),Str,DelimChar)
    else
    begin
        Result := '';
        exit;
    end;
    If finish <> 0 then
       Repeat
           finish := pred(finish);
       Until Str[finish] <> DELIMChar
    else
       finish := length(Str);
    Result := copy(Str,Start,succ(finish-Start));
end;  {Func ExtractWords}

function AdjustMinusSign(const s : string) : string;
begin
  Result := s;
  if Length(s) > 0 then
  begin
    if s[Length(s)] = '-' then
      Result := '-' + Copy(s, 1, Length(s) - 1);
  end;
end;


procedure SaveParser(var R : TParserStateRec);
begin
  with R do
  begin
    tmpStack := Stack;
    tmpCurToken := CurToken;
    tmpStackTop := StackTop;
    tmpTokenType := TokenType;
    tmpMathError := MathError;
    tmpTokenError := TokenError;
    tmpIsFormula := IsFormula;
    tmpInput := Input;
    tmpFieldNo := FieldNumber;
  end;
end;

procedure RestoreParser(const R : TParserStateRec);
begin
  with R do
  begin
   Stack := tmpStack;
   CurToken := tmpCurToken;
   StackTop := tmpStackTop;
   TokenType := tmpTokenType;
   MathError := tmpMathError;
   TokenError := tmpTokenError;
   IsFormula := tmpIsFormula;
   Input := tmpInput;
   FieldNumber := tmpFieldNo;
  end;
end;

{ Returns True if it is a valid number format }
Function ValidNum(Const S : ShortString) : Boolean;
Var
  I : Byte;
Begin { ValidNum }
  Result := True;

  If (Length(S) > 0) Then
    For I := 1 To Length(S) Do
      If (Not (S[I] In ['0'..'9', '.', '-'])) Then Begin
        Result := False;
        Break;
      End; { If }
End; { ValidNum }

function IsAFunc : Boolean;
const
  MaxFuncs = 19;
  Funcs : Array[1..MaxFuncs] of String[12] =
    ('ABS',
     'ATAN',
     'COS',
     'EXP',
     'LN',
     'ROUND',
     'SIN',
     'SQRT',
     'SQR',
     'TRUNC',
     'MIN',
     'MAX',
     'SUBSTRING',
     'TEXTTONUMBER',
     'NUMBERTOTEXT',
     'DATETOTEXT',
     'DATETONUMBER',
     'TRIM',
     'IF');
var
  Len : Word;
  i : integer;
  s : string;
begin
  for i := 1 to MaxFuncs do
  begin
    s := Funcs[i];
    Len := Length(S);
    if Pos(S, Input) = 1 then
    begin
      CurToken.FuncName := Copy(Input, 1, Len);
      Delete(Input, 1, Len);
      Result := True;
    end
    else
      Result := False;
  end;
end; { IsFunc }


function IsFunc(S : String) : Boolean;
{ Checks to see if the start of the Input string is a legal function.
  Returns TRUE if it is, FALSE otherwise.
}
var
  Len : Word;
begin
  Len := Length(S);
  if (Pos(S, Input) = 1) and (Input[Len + 1] <> '[') then
  begin
    CurToken.FuncName := Copy(Input, 1, Len);
    Delete(Input, 1, Len);
    IsFunc := True;
  end
  else
    IsFunc := False;
end; { IsFunc }

(*
Function RepLineRObj.Is_RepVar(RepStr   :  String;
                           Var FormLen  :  Word;
                           Var FormName :  ShortString)  :  Boolean;
Var
  ParInfo         : ParamsType;
  TmpBo, FoundOk  : Boolean;
  CPos, Rl        : Byte;
Begin
  FoundOk:=FALSE;

  { Check for Currency Rate Functions }
  If IsCurrFunc (RepStr) Then Begin
    TmpBo := ProcessRateFunc(RepStr, FormLen, FormName, ParInfo);
  End { If }
  Else Begin
    RL:=Length(RepStr);

    TmpBo:=(RepStr[1] In [RepInpCode,RepRepCode]);

    If (TmpBo) then
    Begin

      CPos:=2;

      While (Cpos<=Rl) and (Not FoundOk) do
      Begin

        FoundOk:=(Not (RepStr[Cpos] In ['0'..'9','[',']',',']));

        If (Not FoundOk) then
          Inc(Cpos);

      end;

      FormLen:=Pred(Cpos);

      FormName:=Copy(RepStr,1,FormLen);

    end
    else
    Begin

      FormLen:=0;

      FormName:='';

    end;
  End; { Else }

  Is_RepVar:=TmpBo;
end; {Func..}

*)
function RepLineRObj.NextToken : Word;
{ Gets the next Token from the Input stream }
var
  NumString : String[80];
  FormLen, Place, Len, NumLen : Word;
  Check : Integer;
  FirstChar : Char;
  Decimal : Boolean;
  FuncNo : Byte;
  FuncStr : string;
  VType : Byte;
  HasErr : Boolean;
begin
  if Input = '' then
  begin
    NextToken := EOL;
    Exit;
  end;
  while (Input <> '') and (Input[1] = ' ') do
    Delete(Input, 1, 1);
  if Input[1] in ['0'..'9', '.'] then
  begin
    NumString := '';
    Len := 1;
    Decimal := False;
    while (Len <= Length(Input)) and
          ((Input[Len] in ['0'..'9']) or
           ((Input[Len] = '.') and (not Decimal))) do
    begin
      NumString := NumString + Input[Len];
      if Input[1] = '.' then
        Decimal := True;
      Inc(Len);
    end;
    if (Len = 2) and (Input[1] = '.') then
    begin
      NextToken := BAD;
      Exit;
    end;
    if (Len <= Length(Input)) and (Input[Len] = 'E') then
    begin
      NumString := NumString + 'E';
      Inc(Len);
      if Input[Len] in ['+', '-'] then
      begin
        NumString := NumString + Input[Len];
        Inc(Len);
      end;
      NumLen := 1;
      while (Len <= Length(Input)) and (Input[Len] in ['0'..'9']) and
            (NumLen <= MAXEXPLEN) do
      begin
        NumString := NumString + Input[Len];
        Inc(NumLen);
        Inc(Len);
      end;
    end;
    if NumString[1] = '.' then
      NumString := '0' + NumString;
    Val(NumString, CurToken.Value, Check);
    if Check <> 0 then
      MathError := True;
    NextToken := NUM;
    Delete(Input, 1, Length(NumString));
    Exit;
  end
  else if Input[1] in LETTERS then
  begin
    if IsInput(Input) then
    begin
      NumString := InpObj^.GetInpField(Input,VType,HasErr);
      if VType = 3 then
      begin
        Val(NumString, CurToken.Value, Check);
        if Check <> 0 then
          MathError := True;
         NextToken := NUM;
        Delete(Input, 1, Length(NumString));
        Exit;
      end
      else
      begin
        NextToken := BAD;
        Exit;
      end;
    end
    else
    if Is_CustomID(Input,FormLen,CurToken.FuncName) then
    begin
      Delete(Input, 1, FormLen);
      IsFormula := True;
      NextToken := CELLT;
      Exit;
    end
    else
    if IsFunc('ABS') or
       IsFunc('ATAN') or
       IsFunc('COS') or
       IsFunc('EXP') or
       IsFunc('LN') or
       IsFunc('ROUND')  or
       IsFunc('SIN') or
       IsFunc('SQRT') or
       IsFunc('SQR') or
       IsFunc('TRUNC')
    then
    begin
      NextToken := FUNC;
      Exit;
    end;
    if (Is_RepVar(Input,FormLen,CurToken.FuncName)) then  {* Check for report variable here *}
    begin
      Delete(Input, 1, FormLen);
      IsFormula := True;
      NextToken := CELLT;
      Exit;
    end
    else
    if IsNewFunc(Input, FuncNo) then
    begin
      FormLen := GetNewFuncLength(Input);
      FuncStr := Copy(Input, 1, FormLen);
      Delete(Input, 1, FormLen);
      IsFormula := True;
      NextToken := CELLT;
      CurToken.FuncName := FuncStr;
      Exit;
    end
    else begin
      NextToken := BAD;
      Exit;
    end;
  end
  else begin
    case Input[1] of
      '+' : NextToken := PLUS;
      '-' : NextToken := MINUS;
      '*' : NextToken := TIMES;
      '/' : NextToken := DIVIDE;
      '^' : NextToken := EXPO;
      ':' : NextToken := COLON;
      '(' : NextToken := OPAREN;
      ')' : NextToken := CPAREN;
      else
      begin
        NextToken := BAD;
        Exit;
      end;
    end;
    Delete(Input, 1, 1);
    Exit;
  end; { case }
end; { NextToken }

procedure RepLineRObj.Push(Token : TokenRec);
{ Pushes a new Token onto the stack }
begin
  if StackTop = PARSERSTACKSIZE then
  begin
    {ErrorMsg(MSGSTACKERROR);}
    TokenError := True;
    VErrWord := '';
    VErrMsg := 'Parser Stack Size has been exceeded';
    VErrCode := veStackSize;
  end
  else begin
    Inc(StackTop);
    Stack[StackTop] := Token;
  end;
end; { Push }

procedure Pop(var Token : TokenRec);
{ Pops the top Token off of the stack }
begin
  Token := Stack[StackTop];
  Dec(StackTop);
end; { Pop }

function GotoState(Production : Word) : Word;
{ Finds the new state based on the just-completed production and the
   top state.
}
var
  State : Word;
begin
  State := Stack[StackTop].State;
  if (Production <= 3) then
  begin
    case State of
      0 : GotoState := 1;
      9 : GotoState := 19;
      20 : GotoState := 28;
    end; { case }
  end
  else if Production <= 6 then
  begin
    case State of
      0, 9, 20 : GotoState := 2;
      12 : GotoState := 21;
      13 : GotoState := 22;
    end; { case }
  end
  else if Production <= 8 then
  begin
    case State of
      0, 9, 12, 13, 20 : GotoState := 3;
      14 : GotoState := 23;
      15 : GotoState := 24;
      16 : GotoState := 25;
    end; { case }
  end
  else if Production <= 10 then
  begin
    case State of
      0, 9, 12..16, 20 : GotoState := 4;
    end; { case }
  end
  else if Production <= 12 then
  begin
    case State of
      0, 9, 12..16, 20 : GotoState := 6;
      5 : GotoState := 17;
    end; { case }
  end
  else begin
    case State of
      0, 5, 9, 12..16, 20 : GotoState := 8;
    end; { case }
  end;
end; { GotoState }


function CellValue(Col, Row : Word) : Real;
var
  CPtr : CellPtr;
begin
  CPtr := Cell[Col, Row];
  if (CPtr = nil) then
    CellValue := 0
  else begin
    if (CPtr^.Error) or (CPtr^.Attrib = TXT) then
      MathError := True;
    if CPtr^.Attrib = FORMULA then
      CellValue := CPtr^.FValue
    else
      CellValue := CPtr^.Value;
  end;
end; { CellValue }

procedure RepLineRObj.Shift(State : Word);
{ Shifts a Token onto the stack }
begin
  CurToken.State := State;
  Push(CurToken);
  TokenType := NextToken;
end; { Shift }






  { ---------------------------------------------------------------- }

  {  RepLine Methods }

  { ---------------------------------------------------------------- }


  Constructor RepLineRObj.Init(RunName   : Str10;
                               MTExLocal : tdPostExLocalPtr);

  Begin

    List.Init;

    GetMem (ColText, SizeOf (ColText^));
    Blank (ColText^,Sizeof(ColText^));

    CurrNode:=GetFirst;

    RepLName:=RunName;

    NoTBreaks:=0;

    FirstGo:=BOn;

    TBreakFound:=0;

    FmulaBreak:=0;

    SummOn:=BOff;

    BreakMode:=0;

    CalcBreak:=BOff;

    FmulaErr:=BOff;

    SelErr:=BOn;

    RunNomCtrl:=BOff;

    Blank(SortList,Sizeof(SortList));

    Blank(BreakList,Sizeof(BreakList));

    Blank(PrntBrkList,Sizeof(PrntBrkList));

    New(InpObj,Init(RunName));

    Recurse := TRecurseCheck.Create;

    {$IFNDEF GUI}
    InpObj^.InitInpFObj(RepGenF,RGK,MtExLocal);
    {$ENDIF}

  end; {Constructor..}


  {* ------------------------ *}


  Destructor RepLineRObj.Done;

  Begin
    if Assigned(ColText) then
      FreeMem (ColText, SizeOf (ColText^));

    CurrNode:=GetFirst;

    While (CurrNode<>NIL) do
    Begin
      RepField:=CurrNode^.LItem;

      Dispose(RepField,Done);
      CurrNode^.LItem:=Nil;

      CurrNode:=GetNext(CurrNode);
    end; {Loop..}

    List.Done;

    if Assigned(InpObj) then
      Dispose(InpObj,Done);

    Recurse.Free;

  end; {Destructor..}


  {* ------------------------ *}


  Procedure RepLineRObj.InitRepFObj(Fnum, Keypath :  Integer;
                                    MTExLocal     :  tdPostExLocalPtr);


  Var
    KeyD,
    KeyS,
    KeyChk,
    KeyV    :  Str255;
    Want    :  Str20;
    SortVal :  Byte;


  Begin
    With MtExLocal^ Do Begin
    {$IFDEF GUI}
      InpObj^.GetInput := GetInput;
    {$ENDIF}
      InpObj^.InitInpFObj(RepGenF,RGK,MtExLocal);
      KeyV:='';

      SortVal:=0;

      KeyChk:=FullRepKey(ReportGenCode,RepRepCode,RepLName)+RepRepCode;

      KeyS:=KeyChk;

      {$IFNDEF GUI}
      LStatus:=LFind_Rec(B_GetGEq,FNum,KeyPath,KeyS);
      {$ELSE}
      LStatus := GetField(0, MTExLocal);
      {$ENDIF}

      CurrNode:=GetFirst;

      While (LStatusOk) {$IFNDEF GUI} and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) {$ENDIF} do
      With LRepGen^ do
      Begin

        Add(New(RepFieldPtr,Init));

        CurrNode:=GetLast;

        RepField:=CurrNode^.LItem;

        With RepField^ do
        With RepFieldRec^ do
        Begin

          RunNom:=RunNomCtrl;

          RepDet:=ReportDet;

          KeyV:=RepDet.VarRef;

          If (Not RepDet.CalcField) then
          Begin
            {GetDictVar(KeyV,KeyV,-1);}
            {Want := KeyV;
            If GetDict(Application.MainForm, Want, Want, -2, 0, 0) Then
              RepDict:=DictRec^.DataVarRec;}

            { Get dictionary field }
            KeyD := PartCCKey(DataDicCode,DataDicVar) + KeyV;
            If LCheckRecExsists(KeyD, DictF, DIK) Then
              RepDict:=LDict^.DataVarRec;

            {If (RepDict.VarDec) then    {* Disabled here as of v1.23 so that
                                            it is overwritten at designtime,
                                            relies on unit RepLSp1U to set at
                                            design time ...
              Case RepDict.VarDecType of

                1  :  RepDet.NoDecs:=Syss.NoCosDec;

                2  :  RepDet.NoDecs:=Syss.NoNetDec;

                3  :  RepDet.NoDecs:=Syss.NoQtyDec;

              end; Case..}

          end
          else
            RepDict.VarType:=3; {* Set to double type *}

          With RepDet do
//            If (PrSel) then {* Calculate correct period *}
            Begin
              With DLink do
                Calc_PrYr(RepLPr[BOff],RepLPr[BOn],DPr,DYr);

              DLink.DCr:=RepDet.RepLCr;
            end;

          SortVal:=IntStr(RepDet.SortOrd[1]);

          If (RepDet.Break>1) then
          Begin

            If (NoTBreaks<SortVal) then
              NoTBreaks:=SortVal;

            BreakMode:=Pred(RepDet.Break);

          end;

          If (RepDet.SortOrd<>'') then
            SortList[SortVal]:=RepDet.RepVarNo;

          SummOn:=(SummOn or RepDet.Summary);

        end; {With..}
      {$IFNDEF GUI}
        LStatus:=LFind_Rec(B_GetNext,FNum,KeyPath,KeyS);
      {$ELSE}
      LStatus := GetField(0, MTExLocal);
      {$ENDIF}

      end; {While..}
    End; { With }
  end;{Proc..}


  {* ------------------------ *}


  Function RepLineRObj.FindObj(VarNo  :  LongInt)  :  Boolean;

  Var
    FoundOk  :  Boolean;


  Begin
    {$IFDEF FMLDBG}
      StrList.Add ('  Begin FindObj');
    {$ENDIF}

    CurrNode:=GetFirst;

    FoundOk:=BOff;

    While (CurrNode<>NIL) and (Not FoundOk) and (VarNo<>0) do
    Begin

      RepField:=CurrNode^.LItem;

      FoundOk:=(VarNo=RepField^.RepFieldRec^.RepDet.RepVarNo);

      If (Not FoundOk) then
        CurrNode:=GetNext(CurrNode);

    end; {While..}


    FindObj:=FoundOk;

    {$IFDEF FMLDBG}
      StrList.Add ('  End FindObj: ' + IntToStr(Ord(Result)));
    {$ENDIF}
  end; {Func..}


  { ================ Report Generator Selection Logic Analysis ============ }




  Function RepLineRObj.GetOperand(Opo  :  String)  :  Byte;

  Const
    NoC  =  9;

    Compare  :  Array[1..NoC] of String[2] = ('<','>','<=','>=','<>','=', #1,#2,#3);



  Var
    n        :  Byte;

    FoundOk  :  Boolean;



  Begin

    n:=1;

    FoundOk:=BOff;

    While (n<=NoC) and (Not FoundOk) do
    Begin

      FoundOk:=CheckKey(Opo,Compare[n],Length(Opo),BOff);

      If (Not FoundOk) then
        Inc(n);

    end;

    If (FoundOk) then
      GetOperand:=n
    else
    begin
      GetOperand:=0;
      VErrCode := veBadOperator;
      VErrMsg  := 'Invalid operator ' + QuotedStr(Trim(Opo));
      VErrWord := Trim(Opo);
    end;

  end; {Func..}


  {* ------------------------ *}

  Function RepLineRObj.SelectTxlate(FStr     :  Str80;
                                Var IsValue,
                                    HasErr   :  Boolean)  :  Str80;

  Var
    VarMatch  :  LongInt;

    Dnum      :  Double;

    TStr      :  Str80;

    SubNo,
    SubSubNo  :  Byte;

    IVType    :  Byte;

    FormLen  : Word;
    FormName : ShortString;
    ParInfo  : ParamsType;
    CurrNo   : LongInt;

  Begin

    TStr:='';

    Dnum:=0;

    VarMAtch:=0;

    IsValue:=BOff;

    IVType:=0;

    { Check for Currency Rate Functions }
    If IsCurrFunc (FStr) Then Begin
      { Enterprise Currency/Rate function }
      If ProcessRateFunc(FStr, FormLen, FormName, ParInfo) Then Begin
        TStr := GetCurrVal (ParInfo, RepDrive, OrigFile).StrResult;
        HasErr := False;
      End; { If }
    End { If }
    Else Begin
      If (FStr[1]=RepRepCode) then
      Begin

        VarMatch:=Sub_SplitFmula(FStr,SubNo,SubSubNo,HasErr);

        If (FindObj(VarMatch)) and (Not HasErr) then
        With RepField^ do
          If (RepFieldRec^.RepDict.VarType In ITypValSet) then
          Begin
            If (CalcBreak) then
              Dnum:=RepField^.GetFieldTotal(FmulaBreak)
            else
              Dnum:=RepField^.GetValue(BOn);

            TStr:=Form_Real(Dnum,1,10);

            IsValue:=BOn;
          end
          else
          Begin
            TStr:=GetStr(BOff);

            If (SubSubNo<>0) then
              TStr:=Copy(TStr,SubNo,SubSubNo);
          end;

      end
      else
      if Pos('DBF', FStr) = 1 then
      begin
        TStr := GetFieldVal(FStr).StrResult;
      end
      else
      Begin

        TStr:=InpObj^.GetInpField(FStr,IVType,HasErr);

        IsValue:=(IVType In ITypValSet);

      end;
    End; { Else }

    SelectTxlate:=TStr;

  end; {Func..}


  {* ------------------------ *}



  Function RepLineRObj.EvalVar(EvalEx  :  Str80;
                           Var IsValue,
                               HasErr  :  Boolean)  :  Str80;

  Var
    TmpS  :  Str80;
    El    :  Byte;
    formlen     : word;
    formname    : shortstring;
    weirdresult : resultvaluetype;
    NewFuncNo : Byte;
    IVType : Byte;
    c : Integer;
    TmpDble : Double;
  Begin

    TmpS:='';

    IsValue:=BOff;

    El:=Length(EvalEx);

    IsValue:=BOff;

    If (El>0) then
    Begin

      Case EvalEx[1] of

        '"'  :  TmpS:=Strip('B',['"'],EvalEx);

        '0'..'9','-'
             :  Begin
                  TmpS:=Form_Real(RealStr(EvalEx),0,10);
                  IsValue:=BOn;
                end;

      Else
        { Check for Enterprise functions }
        If Is_RepVar(EvalEx, FormLen, FormName) or
           Is_CustomID(EvalEx, FormLen, FormName) Then Begin

          if FirstPass and (Pos('SYSREPC', FormName) > 0) then
          begin
            WeirdResult.StrResult := SysRepIgnore;
            WeirdResult.DblResult := 0.0;
          end
          else
          begin
            WeirdResult := GetFieldVal(FormName);

            if (WeirdResult.DblResult = 0.0) then
              TmpS := WeirdResult.StrResult
            else
            begin
              TmpS := FloatToStr(WeirdResult.DblResult);
              IsValue := True;
            end;
          end;

        End { If }
        else
        if IsNewFunc(EvalEx, NewFuncNo) then
        begin
          //Do what?
          TmpS := ProcessNewFunc(EvalEx, NewFuncNo);
          Val(TmpS, TmpDble, c);
          IsValue := c = 0;
        end
        else
        if IsInput(EvalEx) then
        begin
          TmpS := InpObj^.GetInpField(EvalEx,IVType,HasErr);
          IsValue := (IVType In ITypValSet);
        end
        Else //Calculated field
        if EvalEx[1] = #10 then
        begin
          TmpS:=SelectTxlate('R' + Copy(EvalEx, 1, Length(EvalEx)),IsValue,HasErr);
        end
        else
        begin
          TmpS := EvalEx;
{          HasErr := BOn;
          VErrCode := veBadElement;
          VErrMsg  := 'Invalid Element ' + QuotedStr(Trim(EvalEx));
          VErrWord := Trim(EvalEx);}

        end;
      End; {Case..}
    end;

    EvalVar:=UpCaseStr(TmpS);

  end;


  {* ------------------------ *}

  function RepLineRObj.ExtractCond(s : string; FirstOrSecond : Byte) : string;
  var
    i, j : Integer;
  begin
    if not (FirstOrSecond in [1, 2]) then
      FirstOrSecond := 1;
    for i := 1 to NoOfConditions do
    begin
      j := Pos(Conditions[i], s);
      if j > 0 then
      begin
         if FirstOrSecond = 1 then
           Result := Trim(Copy(s, 1, j - 1))
         else
           Result := Trim(Copy(s, j + 1, Length(s)));
         Break;
      end;
    end;
  end;


  Function RepLineRObj.EvalCond(StaM  :  ShortString;
                            Var WPos,
                                HasErr:  Byte;
                                Validate : Boolean = False)  :  Boolean;


  Var
    Cond1,
    Cond2  :  Str80;

    DCond1,
    DCond2 :  Double;

    Operand:  Byte;

    TmpBo,
    IsValue1,
    IsValue2,
    HasErr1,
    HasErr2
           :  Boolean;


  Begin

    IsValue1:=BOff;
    IsValue2:=BOff;

    HasErr1:=BOff;
    HasErr2:=BOff;

    Cond1:=EvalVar(ExtractWords(1,1,StaM),IsValue1,HasErr1);
    Cond2:=EvalVar(ExtractWords(3,1,StaM),IsValue2,HasErr2);

//    Cond1:=EvalVar(ExtractCond(StaM, 1), IsValue1,HasErr1);
//    Cond2:=EvalVar(ExtractCond(StaM, 2), IsValue2,HasErr2);

    if (Cond1 = SysRepIgnore) or (Cond2 = SysRepIgnore) then
      TmpBo := True
    else
    Try
      If ValidNum(Cond1) Then DCond1:=RealStr(Cond1) Else DCond1 := 0;
      If ValidNum(Cond2) Then DCond2:=RealStr(Cond2) Else DCond2 := 0;

      Operand:=GetOperand(ExtractWords(2,1,StaM));

      If (IsValue1) or (IsValue2) then
        TmpBo:=CompareNum(DCond1,DCond2,Operand)
      else
        TmpBo:=CompareStr(Cond1,Cond2,Operand);

      Wpos:=WPos+3;
    Except
      TmpBo := False;
    End;

    EvalCond:=TmpBo;

    HasErr:=(Ord(HasErr1) + Ord(HasErr2));

  end; {Func..}


  {* ------------------------ *}

  Function RepLineRObj.GetLogic(Opo  :  Str5)  :  Byte;

  Const
    NoC  =  3;

    Compare  :  Array[1..NoC] of String[3] = ('AND','OR','XOR');



  Var
    n        :  Byte;

    FoundOk  :  Boolean;



  Begin

    n:=1;

    FoundOk:=BOff;

    While (n<=NoC) and (Not FoundOk) do
    Begin

      FoundOk:=CheckKey(Opo,Compare[n],Length(Opo),BOff);

      If (Not FoundOk) then
        Inc(n);

    end;

    If (FoundOk) then
      GetLogic:=n
    else
    begin
      GetLogic:=0;
      VErrCode := veBadLogic;
      VErrMsg := 'Invalid logical operator ' + QuotedStr(Opo);
      VErrWord := Opo;
    end;

  end; {Func..}

  {* ------------------------ *}

  Function RepLineRObj.CountBracket(BStr  :  Str20)  :  Integer;

  Var
    N,Bp  :  Integer;


  Begin

    N:=0;

    Bp:=Pos('(',BStr);

    If (Bp=0) then
      Bp:=Pos(')',BStr);

    While (Bp<>0) do
    Begin
      N:=N+(Ord(BStr[Bp]='(')-Ord(BStr[Bp]=')'));

      Delete(BStr,Bp,1);

      Bp:=Pos('(',BStr);

      If (Bp=0) then
       Bp:=Pos(')',BStr);
    end; {While..}

    CountBracket:=N;

  end; {Func..}


  {* ------------------------ *}

  Function RepLineRObj.Process_BODMAS(BrackStr  :  ShortString;
                                  Var WPos,
                                      Error     :  Byte)  :  ShortString;



  Var
    TotPos,
    NoPos,
    BrackCount
             :  Byte;

    Abort    :  Boolean;

    NextWord :  Str20;

    TmpStr   :  ShortString;



  Begin

    NoPos:=1;  Abort:=BOff;

    BrackCount:=1;

    Error:=0;

    NextWord:=''; TmpStr:='';

    TotPos:=WordCnt(BrackStr);

    While (NoPos<=TotPos) and (Not Abort) do
    Begin

      NextWord:=ExtractWords(NoPos,1,BrackStr);

      BrackCount:=BrackCount+CountBracket(NextWord);

      Abort:=(BrackCount=1);

      If (Not Abort) then
        Inc(NoPos);

    end; {While..}

    Error:=Ord(Not ABort);

    If (Abort) then
    Begin

      TmpStr:=ExtractWords(1,NoPos,BrackStr);

      Process_BODMAS:=Copy(TmpStr,2,Length(TmpStr)-2);

      WPos:=WPos+NoPos;
    end
    else
      Process_BODMAS:=Copy(BrackStr,2,Length(BrackStr)-2);

  end; {Func..}


  {* ------------------------ *}

  Function RepLineRObj.Evaluate_Expression(Expression  :  ShortString;
                                       Var Error       :  Byte;
                                           Validate    :  Boolean = False)  :  Boolean;



  Var
    TotWords,
    WordPos,
    Operand   :  Byte;

    TmpBo,
    TmpBo1,
    Abort     :  Boolean;

    NextWord  :  Str20;


  Begin

    Error:=0;

    WordPos:=1;


    Abort:=BOff;

    NextWord:='';

    Expression:=Strip('B',[#32],Expression);

    TmpBo:=(Expression='');

    TotWords:=WordCnt(Expression);

    Error:=Ord(((TotWords Mod 2)=0) or (TotWords = 1)) ;

    if (Error <> 0) and not TmpBo then
    begin
      VErrCode := veBadSyntax;
      VErrMsg := 'Invalid Syntax';
      VErrWord := Expression;
    end;

    If (Error=0) and (Not TmpBo) then
    Begin

      If (Expression[1]='(') then
        TmpBo:=Evaluate_Expression(Process_BODMAS(Expression,WordPos,Error),Error)
      else
        TmpBo:=EvalCond(ExtractWords(WordPos,3,Expression),WordPos,Error, Validate);
//        TmpBo:=EvalCond(Expression,WordPos,Error, Validate);

      While (Error=0) and (WordPos<TotWords) and (Not Abort) do
      Begin

        {* Next element should be a logic condition *}

        Operand:=GetLogic(ExtractWords(WordPos,1,Expression));

        Inc(WordPos);

        Abort:=((Operand=0) or ((Not TmpBo) and (Operand=1))
              or ((TmpBo) and (Operand=2)) or (WordPos>TotWords));

        If (Not Abort) or Validate then
        Begin
          TmpBo1 := TmpBo;
          NextWord:=ExtractWords(WordPos,1,Expression);

          If (NextWord[1]='(') then
            TmpBo:=Evaluate_Expression(Process_BODMAS(ExtractWords(WordPos,Succ(TotWords-WordPos),Expression),
                                       WordPos,Error),Error)
          else
            TmpBo:=EvalCond(ExtractWords(WordPos,3,Expression),WordPos,Error, Validate);

          if Operand = 3 then
            TmpBo := TmpBo xor TmpBo1;
        end;

      end; {While..}

    end; {If Error fail..}

    Evaluate_Expression:=TmpBo;

    SelErr:=((Error<>0) and (Not TmpBo));

  end; {Func..}



  {* ------------------------ *}


  Function RepLineRObj.ConcatCalc(FStr   :  String;
                              Var IVType :  Byte;
                              Var HasErr :  Boolean)  :  String;

  Var
    TStr,
    ChkStr  :  String;

    n,m     :  Byte;

    IsValue :  Boolean;

    OStr    :  String;


    FormLen   : Word;
    FormName  : ShortString;
    ParInfo   : ParamsType;
    FuncNo : Byte;
    i : integer;
    TmpNumber : Word;
    TmpName : ShortString;
  Begin

    IVType:=0;

    IsValue:=BOff;

    TStr:='';

    OStr:='';

    ChkStr:=Copy(FStr,2,Pred(Length(FStr)));

    i := 1;

    {This was removing spaces in order to replace '+' signs with spaces. Added ExtractWordsDef
     and WordCnt def functions to enable delimiter to be passed into funcs}
  {  while i < Length(ChkStr) do
    begin
      if ChkStr[i] = ' ' then
        Delete(ChkStr, i, 1)
      else
        inc(i);
    end;

    n:=Pos('+',ChkStr);

    While (n<>0) do
    Begin

      ChkStr[n]:=#32;

      n:=Pos('+',ChkStr);

    end; {While..}

    m:=WordCntDef(ChkStr, '+');

    n:=1;

    While (n<=m) and (Not HasErr) do
    Begin

      OStr:=Trim(ExtractWordsDef(n,1,ChkStr, '+'));

      Case OStr[1] of

        {RepRepCode,
        RepInpCode  :  TStr:=TStr+SelectTxlate(OStr,IsValue,HasErr);}

        '"'         :  TStr:=TStr+Strip('B',['"'],OStr);
        '<'         :  TStr := TStr + ' ';

      else
        HasErr:=BOn;
        if IsInput(OStr) then
        begin
          TStr := TStr + InpObj^.GetInpField(Ostr,IVType,HasErr);
        end
        else
        if Is_CustomID(OStr, TmpNumber, TmpName) then
        begin
          TStr  := TStr + GetCustomVal(OStr).StrResult;
          HasErr := False;
        end
        else
        if IsNewFunc(OStr, FuncNo) then
        begin
          TStr := TStr + ProcessNewFunc(OStr, FuncNo);
          HasErr := False;
        end
        else
        If Is_RepVar(Trim(OStr), FormLen, FormName) Then Begin
          If IsCurrFunc (OStr) Then Begin
            { Enterprise Currency/Rate function }
            If ProcessRateFunc(OStr, FormLen, FormName, ParInfo) Then Begin
              TStr := TStr + GetCurrVal (ParInfo, RepDrive, OrigFile).StrResult;
              HasErr := False;
            End; { If }
          End { If }
          Else Begin
            { RepRepCode, RepInpCode }
            TStr := TStr+SelectTxlate(OStr,IsValue,HasErr);
            HasErr := BOff;
          End; { Else }
        End; { If }
      end; {Case..}

      Inc(n);

    end; {While..}

    IVType:=1;

    ConcatCalc:=TStr;

  end; {Func..}



  {* ------------------------ *}


  Function RepLineRObj.FormulaTxlate(FStr   :  Str80;
                                 Var HasErr :  Boolean)  :  Double;

  Var
    VarMatch  :  LongInt;
    Dnum      :  Double;

    Gd,Gm,Gy  :  Word;

    TStr      :  Str255;

    SubNo,
    SubSubNo,
    IVType    :  Byte;

    ErrCode   : Integer;

    FormLen  :  Word;
    FormName :  ShortString;
    ParInfo  : ParamsType;
  Begin
    {$IFDEF FMLDBG}
      StrList.Add ('  Begin FormulaTxlate: ' + FStr);
    {$ENDIF}

    Dnum:=0;

    IVType:=0;

    VarMAtch:=0;

    TStr:='';

    Gd:=0; Gm:=0; Gy:=0;

    { Check for Currency Rate Functions }
    If IsCurrFunc (FStr) Then Begin
      { Enterprise Currency/Rate function }
      If ProcessRateFunc(FStr, FormLen, FormName, ParInfo) Then Begin
        DNum := GetCurrVal (ParInfo, RepDrive, OrigFile).DblResult;
        HasErr := False;
      End; { If }
    End { If }
    Else Begin
      If (FStr[1]=RepRepCode) then
      Begin
        {$IFDEF FMLDBG}
          StrList.Add ('  RepCode');
        {$ENDIF}

        VarMatch:=Sub_SplitFmula(FStr,SubNo,SubSubNo,HasErr);

        If (FindObj(VarMatch)) and (Not HasErr) then
        With RepField^ do
          { [2,3,6..10] + 4=Date}
          If (RepFieldRec^.RepDict.VarType In ITypValSet+[4]) then  {* Include numeric variables & Dates *}
          Begin

            If (CalcBreak) then
              Dnum:=RepField^.GetFieldTotal(FmulaBreak)
            else
              Dnum:=RepField^.GetValue(BOn);

          end
          else
            { String + char - see if it can be converted to a value }
            If (RepFieldRec^.RepDict.VarType In [1, 5]) Then Begin
              { HM 14/04/99: Modified to treat empty fields as 0 }
              { Try to convert string to value }
              TStr:=Trim(GetStr(BOff));

              If (TStr <> '') Then Begin
                If ValidNum(TStr) Then Begin
                  Val(TStr, DNum, ErrCode);
                End { If }
                Else
                  HasErr := BOn;
              End { If }
              Else Begin
                DNum := 0.00;
                ErrCode := 0;
              End; { Else }

              HasErr := (ErrCode <> 0);
            End { If }
            Else
              { Something else }
              HasErr:=BOn;
      end
      else
      Begin

        TStr:=InpObj^.GetInpField(FStr,IVType,HasErr);

        If (IVType=4) then {* its a date, convert to Julian *}
        Begin

          DateStr(TStr,Gd,Gm,Gy);

          Dnum:=Caljul(Gd,Gm,Gy);

        end
        else
          Dnum:=RealStr(TStr);

      end;
    End; { If }

    FormulaTxlate:=Dnum;

    {$IFDEF FMLDBG}
      StrList.Add (SysUtils.Format('  End FormulaTxlate: %12.4f', [Dnum]));
    {$ENDIF}
  end; {Func..}




  procedure RepLineRObj.Reduce(Reduction : Word);

  { Completes a reduction }
  var
    Token1, Token2 : TokenRec;
    Counter : Word;
    FuncNo : Byte;
    c : integer;
    TmpS : String;
    TmpNo : Word;
    TmpName : ShortString;
    TmpResult : ResultValueType;
    TempVal : Double;
  begin
    case Reduction of
      1 : begin
        Pop(Token1);
        Pop(Token2);
        Pop(Token2);
        CurToken.Value := Token1.Value + Token2.Value;
      end;
      2 : begin
        Pop(Token1);
        Pop(Token2);
        Pop(Token2);
        CurToken.Value := Token2.Value - Token1.Value;
      end;
      4 : begin
        Pop(Token1);
        Pop(Token2);
        Pop(Token2);
        CurToken.Value := Token1.Value * Token2.Value;
      end;
      5 : begin
        Pop(Token1);
        Pop(Token2);
        Pop(Token2);
        if Token1.Value = 0 then
          MathError := True
        else Begin
          CurToken.Value := Token2.Value / Token1.Value;
//ShowMessage (SysUtils.Format ('Divide %12.4f / %12.4f = %12.4f', [Token2.Value, Token1.Value, CurToken.Value]));
        End; { Else }
      end;
      7 : begin
        Pop(Token1);
        Pop(Token2);
        Pop(Token2);
        if Token2.Value <= 0 then
          MathError := True
        else if (Token1.Value * Ln(Token2.Value) < -EXPLIMIT) or
                (Token1.Value * Ln(Token2.Value) > EXPLIMIT) then
          MathError := True
        else
          CurToken.Value := Exp(Token1.Value * Ln(Token2.Value));
      end;
      9 : begin
        Pop(Token1);
        Pop(Token2);
        CurToken.Value := -Token1.Value;
      end;
      11 : begin
        Pop(Token1);
        Pop(Token2);
        Pop(Token2);
        CurToken.Value := 0;
        if Token1.Row = Token2.Row then
        begin
          if Token1.Col < Token2.Col then
            TokenError := True
          else begin
            for Counter := Token2.Col to Token1.Col do
              CurToken.Value := CurToken.Value + CellValue(Counter, Token1.Row);
          end;
        end
        else if Token1.Col = Token2.Col then
        begin
          if Token1.Row < Token2.Row then
            TokenError := True
          else begin
            for Counter := Token2.Row to Token1.Row do
              CurToken.Value := CurToken.Value + CellValue(Token1.Col, Counter);
          end;
        end
        else
          TokenError := True;
      end;
      13 : begin

             Pop(CurToken);
             if Is_CustomID(CurToken.FuncName, TmpNo, TmpName) then
             begin
                TmpResult := GetCustomVal(CurToken.FuncName);
                CurToken.Value := TmpResult.DblResult;
                Val(TmpResult.StrResult, TempVal, c);
                if c > 0 then
                  CurToken.FuncName := TmpResult.StrResult
                else
                  CurToken.FuncName := FloatToStrF(CurToken.Value, ffNumber, 15, 12);
             end
             else
             if IsNewFunc(CurToken.FuncName, FuncNo) then
             begin
               CurToken.FuncName := GetFieldVal(CurToken.FuncName).StrResult;
               TmpS := CurToken.FuncName;
               CurToken.FuncName := TidyUp(AdjustMinusSign(CurToken.FuncName));
               Val(CurToken.FuncName, CurToken.Value, c);
               CurToken.FuncName := TmpS;
             end
             else
             //CurToken.Value := FormulaTxlate(CurToken.FuncName,TokenError); {* Get Variable link up *}
               CurToken.Value := GetFieldVal(CurToken.FuncName).DblResult;

           end;

      14 : begin
        Pop(Token1);
        Pop(CurToken);
        Pop(Token1);
      end;
      16 : begin
        Pop(Token1);
        Pop(CurToken);
        Pop(Token1);
        Pop(Token1);
        if Token1.FuncName = 'ABS' then
          CurToken.Value := Abs(CurToken.Value)
        else if Token1.FuncName = 'ATAN' then
          CurToken.Value := ArcTan(CurToken.Value)
        else if Token1.FuncName = 'COS' then
          CurToken.Value := Cos(CurToken.Value)
        else if Token1.FuncName = 'EXP' then
        begin
          if (CurToken.Value < -EXPLIMIT) or (CurToken.Value > EXPLIMIT) then
            MathError := True
          else
            CurToken.Value := Exp(CurToken.Value);
        end
        else if Token1.FuncName = 'LN' then
        begin
          if CurToken.Value <= 0 then
            MathError := True
          else
            CurToken.Value := Ln(CurToken.Value);
        end
        else if Token1.FuncName = 'ROUND' then
        begin
          if (CurToken.Value < -1E9) or (CurToken.Value > 1E9) then
            MathError := True
          else
            CurToken.Value := Round(CurToken.Value);
        end
        {else if Token1.FuncName = 'SIN' then     {* Sin func disabled as it conflicts with SIN doc type!
          CurToken.Value := Sin(CurToken.Value)}
        else if Token1.FuncName = 'SQRT' then
        begin
          if CurToken.Value < 0 then
            MathError := True
          else
            CurToken.Value := Sqrt(CurToken.Value);
        end
        else if Token1.FuncName = 'SQR' then
        begin
          if (CurToken.Value < -SQRLIMIT) or (CurToken.Value > SQRLIMIT) then
            MathError := True
          else
            CurToken.Value := Sqr(CurToken.Value);
        end
        else if Token1.FuncName = 'TRUNC' then
        begin
          if (CurToken.Value < -1E9) or (CurToken.Value > 1E9) then
            MathError := True
          else
            CurToken.Value := Trunc(CurToken.Value);
        end;
      end;
      3, 6, 8, 10, 12, 15 : Pop(CurToken);
    end; { case }
    if not (Reduction in [3, 6, 8, 10, 12..15]) then
      CurToken.FuncName := FloatToStrF(CurToken.Value, ffNumber, 15, 12);
    CurToken.State := GotoState(Reduction);
    Push(CurToken);
  end; { Reduce }




  function RepLineRObj.Parse(S : String; var Att : Word; var StrRes : string) : Real;

  var
    FirstToken : TokenRec;
    Accepted : Boolean;
    Counter : Word;

    function FirstWord(const s : string) : string;
    var
      i : integer;
    begin
      i := Pos(' ', s);
      if i > 0 then
        Result := Copy(s, 1, i - 1)
      else
        Result := s;
    end;

    function ReplaceOperatorTokens(const s : string) : string;
    begin
      Result := s;
      Result := AnsiReplaceStr(Result, #1, 'BeginsWith');
      Result := AnsiReplaceStr(Result, #2, 'Contains');
      Result := AnsiReplaceStr(Result, #3, 'EndsWith');
    end;

    procedure SetTokenError;
    begin
      TokenError := True;
      VErrCode := veBadElement;
      VErrWord := ReplaceOperatorTokens(FirstWord(Input));
      VErrMsg := 'Invalid element in calculation ' + QuotedStr(VErrWord);
    end;

  begin
    VErrCode := 0;
    VErrMsg := '';
    VErrWord := '';
    Accepted := False;
    TokenError := False;
    MathError := False;
    IsFormula := False;
    Input := UpperCase(Trim(S));
    //PR 9/8/05 Deal with empty formula
    if Input = '' then
      Input := '0';
    //PR 20/4/07 If this is a string formula then remove initial dbl quote
    if Input[1] = '"' then
      Delete(Input, 1, 1);
    StackTop := 0;
    FirstToken.State := 0;
    FirstToken.Value := 0;
    Push(FirstToken);
    TokenType := NextToken;
    repeat
      case Stack[StackTop].State of
        0, 9, 12..16, 20 : begin
          if TokenType = NUM then
            Shift(10)
          else if TokenType = CELLT then
            Shift(7)
          else if TokenType = FUNC then
            Shift(11)
          else if TokenType = MINUS then
            Shift(5)
          else if TokenType = OPAREN then
            Shift(9)
          else
            SetTokenError;
        end;
        1 : begin
          if TokenType = EOL then
            Accepted := True
          else if TokenType = PLUS then
            Shift(12)
          else if TokenType = MINUS then
            Shift(13)
          else
            SetTokenError;
        end;
        2 : begin
          if TokenType = TIMES then
            Shift(14)
          else if TokenType = DIVIDE then
            Shift(15)
          else
            Reduce(3);
        end;
        3 : Reduce(6);
        4 : begin
         if TokenType = EXPO then
           Shift(16)
         else
           Reduce(8);
        end;
        5 : begin
          if TokenType = NUM then
            Shift(10)
          else if TokenType = CELLT then
            Shift(7)
          else if TokenType = FUNC then
            Shift(11)
          else if TokenType = OPAREN then
            Shift(9)
          else
            SetTokenError;
        end;
        6 : Reduce(10);
        7 : begin
          if TokenType = COLON then
            Shift(18)
          else
            Reduce(13);
        end;
        8 : Reduce(12);
        10 : Reduce(15);
        11 : begin
          if TokenType = OPAREN then
            Shift(20)
          else
            SetTokenError;
        end;
        17 : Reduce(9);
        18 : begin
          if TokenType = CELLT then
            Shift(26)
          else
            SetTokenError;
        end;
        19 : begin
          if TokenType = PLUS then
            Shift(12)
          else if TokenType = MINUS then
            Shift(13)
          else if TokenType = CPAREN then
            Shift(27)
          else
            SetTokenError;
        end;
        21 : begin
          if TokenType = TIMES then
            Shift(14)
          else if TokenType = DIVIDE then
            Shift(15)
          else
            Reduce(1);
        end;
        22 : begin
          if TokenType = TIMES then
            Shift(14)
          else if TokenType = DIVIDE then
            Shift(15)
          else
            Reduce(2);
        end;
        23 : Reduce(4);
        24 : Reduce(5);
        25 : Reduce(7);
        26 : Reduce(11);
        27 : Reduce(14);
        28 : begin
          if TokenType = PLUS then
            Shift(12)
          else if TokenType = MINUS then
            Shift(13)
          else if TokenType = CPAREN then
            Shift(29)
          else
            SetTokenError;
        end;
        29 : Reduce(16);
      end; { case }
    until Accepted or TokenError;
    if TokenError then
    begin
      Att := TXT;
      Parse := 0;
      Exit;
    end;
    if IsFormula then
      Att := FORMULA
    else
      Att := VALUE;
    if MathError then
    begin
      Inc(Att, 4);
      Parse := 0;
      Exit;
    end;
    Parse := Stack[StackTop].Value;
    StrRes := Stack[StackTop].FuncName;
  end; { Parse }


  {* ------------------------ *}


  Function RepLineRObj.SetFormula(Formula  :  ShortString;
                                  NoDecs   :  Byte;
                              Var IVType   :  Byte)  :  Str80;

  Var
    Dnum  :  Double;
    FErr  :  Word;

//    TStr  :  Str80;
    TStr  :  string;
    Isfunc : Boolean;
    FuncNo : Byte;
    TmpInt : Word;
    TmpS : ShortString;

  Begin
    {$IFDEF FMLDBG}
      StrList.Add ('Begin SetFormula: ' + Formula);
    {$ENDIF}

    FErr:=0;

    Case Formula[1] of

      '"'   :  TStr:=ConcatCalc(Formula,IVType,FmulaErr);
      '~'   :  Begin
                 TStr:=Copy(Formula,2,Pred(Length(Formula)));
                 IVType:=1;
               end;
      else     Begin
                 IsFunc := IsNewFunc(Formula, FuncNo) or Is_CustomID(Formula, TmpInt, TmpS);
                 Dnum:=Parse(Formula,Ferr, TStr);

                 If (Ferr In [1,2,6]) then
                 begin
                   if not IsFunc then
                     TStr:=Form_Real(Dnum,0,NoDecs)
                   else
                     IVType := NewFuncs[FuncNo].FType;
                 end
                 else
                   TStr:=ErrStr;

                 FmulaErr:=(Not (FErr In [1,2,6]));

               end;
    end; {Case..}

    SetFormula:=TStr;

    {$IFDEF FMLDBG}
      StrList.Add ('End SetFormula: ' + Result);
    {$ENDIF}
  end; {Func..}




  {* ------------------------ *}


  Function RepLineRObj.LinkObj(    VarNo  :  LongInt;
                               Var DLinkR :  DictLinkType;
                                   InpStr :  Str255)  :  Str255;
  Var
    StrRec : fdFormStringsType;
  Begin
    {
    LinkObj:=Link_Dict(VarNo,DLinkR);
    }

    LinkObj := Link_Dict(VarNo,
                         DLinkR,
                         StrRec,
                         10,
                         RepDrive,
                         OrigFile,
                         InpStr);

  end; {Func..}


  {* ------------------------ *}


  Procedure RepLineRObj.FillObject(Var SelectOk  :  Boolean);

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    CheckSelect,
    HasErr,
    Abort,
    PrSelChk   :  Boolean;

    FStr,
    IStr, TStr  :  Str255;

    FErr,IVType,
    LastBrk,n  :  Byte;
    DLink1      :  DictLinkType;

  Begin
    CheckSelect:=SelectOk;

    FErr:=0;

    LastBrk:=0;

    n:=0;

    TStr:='';

    PrSelChk:=BOff;

    Abort:=BOff;

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) and (Not Abort) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      Begin

        With RepFieldRec^ do
        Begin
          FormulaDecs := RepDet.NoDecs;

          if Assigned(NotifyField) then
            NotifyField(RepDet.RepVarNo);

          If (RepDet.CalcField) then
            With RepDet do
            begin
              //PR: 8/3/05 Added to allow period/year/currency on Calculated Fields
//              if RepDet.PrSel then
              begin
                With DLink do
                  Calc_PrYr(RepLPr[BOff],RepLPr[BOn],DPr,DYr);

                DLink.DCr:=RepDet.RepLCr;
                SetPeriodDetails(DLink, True);
              end;
{              else
                SetPeriodDetails(DLink, False);}
            {* Note 10 dec places set here
               as otherwise calculated fields
               could contain rounding errors *}
              FieldNumber := RepVarNo;
              TStr:=SetFormula(VarSubSplit,10,RepDict.VarType);
            end
          else Begin
            {If (RepDict.VarName = 'ACCOMP  ') Then
              ShowMessage ('ACCOMP');}

            (*With RepDict do  {* Check for formula *}
              TStr:=LinkObj(VarNo,DLink);*)

            With RepDet, RepDict Do Begin  {* Check for formula *}
              { Check for input requirement }
              IStr := '';
              If (InputType > 0) And (InputLink > 0) Then Begin
                IVType := 0;
                HasErr := False;
                FStr:=RepInpCode+Form_Int(InputLink,0)+'[1]';
                IStr:=Strip('R',[#32],InpObj^.GetInpField(FStr,IVType,HasErr));
                //special handling for Employee continuous employment fields
                if (VarNo >= 11523) and (VarNo <= 11526) then
                begin
                  FStr:=RepInpCode+Form_Int(InputLink,0)+'[2]';
                  IStr:= IStr + Strip('R',[#32],InpObj^.GetInpField(FStr,IVType,HasErr));
                end;
              End; { If }

              { Get data from data dictionary }
              TStr:=LinkObj(VarNo, DLink, IStr);
            End; { With }

            {PR 22/3/05 - change to format date here rather than lower down when we
             still need to use in comparisions}
        {    Case RepDict.VarType of
              4 : TStr := POutDate(TStr);
            end;}
          End;
        end; {With..}

        SetValue(TStr,(Not CheckSelect));

        With RepFieldRec^ do
          If CheckSelect then
          Begin
            // HM 27/07/00: Rewrote Record Selection was being corrupted by seeing values
            //              without the Print Selection being taken into consideration
            PrSelChk:=Evaluate_Expression(RepDet.PrintSelect,FErr);

            If (SelErr) then Begin
              {Warn_ValErr(RepDet.RepPadNo,RepDet.PrintSelect);}
              If Assigned (OnValErr) Then
                OnValErr(RepDet.RepPadNo,RepDet.PrintSelect);

              Abort:=BOn;
              SelectOK := False;
            End
            Else Begin
              { Reset Print Value if Print Selection failed }

              { Now check record selection }
              //PR 7/3/05 Add in range filter check

              SelectOK := Evaluate_Expression(RepDet.RangeFilter,FErr);

              if SelectOK then
                SelectOk:=Evaluate_Expression(RepDet.RecSelect,FErr);

             { If (Not PrSelChk) then
                SetValue('',(Not CheckSelect));}
              RepDet.SpareBool := PrSelChk;

              Abort:=Not SelectOk;

              If (FmulaErr) then
              Begin

                If Assigned (OnValErr) Then
                  OnValErr(RepDet.RepPadNo,RepDet.VarSubSplit);
                {Warn_ValErr(RepDet.RepPadNo,RepDet.VarSubSplit);}

                Abort:=BOn;

              end
              else
                If (SelErr) then
                Begin

                  {Warn_ValErr(RepDet.RepPadNo,RepDet.RecSelect);}
                  If Assigned (OnValErr) Then
                    OnValErr(RepDet.RepPadNo,RepDet.RecSelect);

                  Abort:=BOn;

                end;
            End; { Else }
          End { If CheckSelect }
          Else Begin

            SelectOk:=(Evaluate_Expression(RepDet.PrintSelect,FErr) or (RepDet.ApplyPSumm));

            RepDet.SpareBool := SelectOk;
            If (Not SelectOk) then {* Reset Print Value *}
              SetValue('',BOff);

            If (BreakFound) and (SelectOk) then
            Begin

              Inc(TBreakFound);

              With RepDet do
              Begin
                LastBrk:=IntStr(SortOrd[1]);

                BreakList[LastBrk]:=RepVarNo;

                With GroupRepRec^.ReportHed do {* Master flag to indicate break has ocurred *}
                  If (LastBrk<CurrBreak) or (CurrBreak=0) then
                    CurrBreak:=LastBrk;

                {* Force higher levels to break as well, in case their data has not changed *}

                For n:=Succ(LastBrk) to NoTBreaks do
                  If (SortList[n]<>0) and (BreakList[n]=0) then
                    BreakList[n]:=RepVarNo;


              end;

            end;

          end;
          if (not FirstPass) and Assigned(NotifyFieldValue) and PrSelChk then
            NotifyFieldValue(RepFieldRec^.RepDet.RepVarNo, TStr);

      end; {With..}
      LocalNode:=GetNext(LocalNode);
    end; {While..}

  end; {Proc..}



  {* ------------------------ *}


  Function RepLineRObj.FillHeader  :  Str255;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr       :  Str255;

    OnStr,
    OffStr     :  Str255;


  Begin

    HStr:='';  SpStr:='';

    OnStr:=''; OffStr:='';

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      If (RepFieldRec^.RepDet.PrintVar) then
      Begin

        If (HStr<>'') then
          SpStr:=' ';

        {SetEffect(OnStr,OffStr,RepFieldRec^.RepDet.PrintEff);}

        {HStr:=HStr+OnStr+SpStr+FillHead+OffStr;}
        HStr:=HStr + #9 + FillHead;
      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillHeader:=HStr;

  end; {Func..}


{* ------------------------ *}


  Function RepLineRObj.FillLine  :  Str255;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr,TStr
               :  Str255;

    AutoBlnk   :  Boolean;

    OnStr,
    OffStr     :  Str255;


  Begin

    HStr:=''; TStr:='';  SpStr:='';

    OnStr:=''; OffStr:='';  AutoBlnk:=BOff;

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      If (RepFieldRec^.RepDet.PrintVar) then
      Begin

        {If (HStr<>'') then
          SpStr:=' ';}

        {SetEffect(OnStr,OffStr,RepFieldRec^.RepDet.PrintEff);}

        With RepFieldRec^ do
          AutoBlnk:=(((RepDet.Break In [3,4]) or (RepDet.Format='K')) and (LastValue=ThisValue));

          {* Note if using Breakmode which is a global you need to check for one less than
             the normal break mode *}

        TStr := #9+FillField(AutoBlnk);

        HStr:=HStr+TStr;
      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillLine:=HStr;

  end; {Func..}


{* ------------------------ *}

  { Obsolete: Replaced by FillUndies }
  Function RepLineRObj.FillTULine(FinLine  :  Boolean)  :  Str255;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr,TStr
               :  Str255;

    OnStr,
    OffStr     :  Str255;



  Begin

    HStr:=''; TStr:='';  SpStr:='';

    OnStr:=''; OffStr:='';

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      If (RepFieldRec^.RepDet.PrintVar) then
      Begin

        If (HStr<>'') then
          SpStr:=' ';

        SetEffect(OnStr,OffStr,RepFieldRec^.RepDet.PrintEff);

        TStr:=OnStr+SpStr+FillTUndy(FinLine)+OffStr;

        HStr:=HStr+TStr;
      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillTULine:=HStr;

  end; {Func..}


{* ------------------------ *}

  Procedure RepLineRObj.ReCalcBreaks(BTNo      :  Byte;
                                 Var RepFRec   :  RepFieldType);

  Var
    FErr  :  Word;
    Str : String;

  Begin

    FErr:=0;

    With RepFRec do
      If (RepDet.CalcField) and (RepDet.ReCalcBTot) then {* Reapply formula to Total values *}
      Begin
        CalcBreak:=BOn;

        FmulaBreak:=BTNo;

        FieldTot[BTNo]:=Parse(RepDet.VarSubSplit,FErr, Str);

        CalcBreak:=BOff;
      end;

  end;


{* ------------------------ *}


  Function RepLineRObj.FillTotal(BTNo     :  Byte;
                                 ShowBrk  :  Boolean)  :  AnsiString;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr       :  AnsiString;

    OnStr,
    OffStr     :  Str255;
    i : integer;


  Begin

    HStr:='';  SpStr:='';

    OnStr:=''; OffStr:='';

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      Begin

        ReCalcBreaks(BTNo,RepFieldRec^);

        If (RepFieldRec^.RepDet.PrintVar) then
        Begin

          {If (HStr<>'') then
            SpStr:=' ';

          SetEffect(OnStr,OffStr,RepFieldRec^.RepDet.PrintEff);

          HStr:=HStr+OnStr+SpStr+GetTotal(BTNo,BOff,ShowBrk)+OffStr;}

          HStr:=HStr + #9 + GetTotal(BTNo,BOff,ShowBrk);
        end; {If Print var..}

      end; {With..}
      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillTotal:=HStr;

  end; {Func..}



  {* ------------------------ *}

(*
  Function RepLineRObj.FillSummary(BTNo  :  Byte;
                                   RepLF :  Boolean)  :  Str255;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr,
    TStr       :  Str255;

    OnStr,
    OffStr     :  Str80;



  Begin

    HStr:='';

    TStr:='';

    SpStr:='';

    OnStr:=''; OffStr:='';

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      Begin

        ReCalcBreaks(BTNo,RepFieldRec^);

        With RepFieldRec^.RepDet do
          If (PrintVar) then
          Begin

            If (HStr<>'') then
              SpStr:=' ';

            If (SubTot) or (Not RepLF) then
              TStr:=GetTotal(BTNo,BOff,BOn)
            else
              TStr:=FillLastField;


            HStr:=HStr+OnStr+SpStr+TStr+OffStr;

          end; {If Print var..}

      end; {With..}
      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillSummary:=HStr;

  end; {Func..}
  *)
  Procedure RepLineRObj.FillSummary(BTNo : Byte; RepLF, IsCSV : Boolean);
  Var
    LocalNode  :  NodePtr;
    LocalRField:  RepFieldPtr;
    TStr       :  Str255;
  Begin
    LocalNode:=GetFirst;

    Blank (ColText^, SizeOf(ColText^));
    ColText^.NumCols := 0;

    While (LocalNode<>NIL) do Begin
      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do Begin
        ReCalcBreaks(BTNo,RepFieldRec^);

        With RepFieldRec^.RepDet do
          If (PrintVar) then Begin
            Inc (ColText^.NumCols);

            If (SubTot) or (Not RepLF) then
              TStr:=GetTotal(BTNo,BOff,BOn)
            else
              TStr:=FillLastField;

            With ColText^.Cols[ColText^.NumCols], RepFieldRec^.RepDet Do Begin
              if not IsCSV then
              begin
                ColVal    := #9 + TStr;
                FontStyle := WinFont.fStyle;
                FontColor := WinFont.fColor;
              end
              else
                ColVal := FillCDFTot(TStr);
            End; { With }
          end; {If Print var..}
      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}
  end; {Func..}



  {* ------------------------ *}


  Function RepLineRObj.FullSortKey  :  Str255;

  Var
    HStr       :  Str255;

    n          :  Byte;


  Begin

    HStr:='';


    For n:=1 to MaxNoSort do
      If (SortList[n]<>0) then
      Begin
        If (FindObj(SortList[n])) then
          HStr:=HStr+RepField^.GetSortStr;
      end;

    FullSortKey:=HStr;

  end; {Func..}


  {* ------------------------ *}


  Procedure RepLineRObj.LineTotals(Mode,
                                   BTNo  :  Byte);

  Var
    LocalNode  :  NodePtr;


  Begin
    LocalNode:=GetFirst;

    SubTOn:=BOff;

    While (LocalNode<>NIL) do
    Begin

      RepField:=LocalNode^.LITem;

      With RepField^ do
      Begin

        With RepFieldRec^.RepDet do
        Begin

          Case Mode of

            0  :  Begin
                    If (SubTot) then
                      UpdateTotals(NoTBreaks);

                    SubTOn:=(SubTOn or (SubTot and PrintVar));
                  end;

            1  :  ResetTotal(BtNo,NoTBreaks);

            2  :  SetValue('',BOff);

          end; {Case..}

        end; {With..}

      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    CalcBreak:=BOff;

    FmulaBreak:=0;

  end; {Proc..}



  {* ------------------------ *}


  Function RepLineRObj.IncInSumm(BTNo  :  Byte)  :  Boolean;

  Var
    LocalNode  :  NodePtr;

    FErr       :  Byte;

    TmpBo      :  Boolean;


  Begin
    LocalNode:=GetFirst;

    FErr:=0;

    CalcBreak:=BOn;

    FmulaBreak:=BTNo;

    TmpBo:=BOn;


    While (LocalNode<>NIL) and (TmpBo) do
    Begin

      RepField:=LocalNode^.LITem;

      With RepField^.RepFieldRec^.RepDet do
      Begin

        TmpBo:=((Not ApplyPSumm) or (Evaluate_Expression(PrintSelect,FErr)));

        
      end; {With..}

      If (TmpBo) then
        LocalNode:=GetNext(LocalNode);

    end; {While..}

    IncInSumm:=TmpBo;

  end; {Func..}



{* ------------------------ *}


  Procedure RepLineRObj.ReduceBreak(BTNo  :  Byte);

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;


  Begin

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      Begin

        ReduceTotals(BTNo,GetFieldTotal(BTNo));

      end; {With..}

      LocalNode:=GetNext(LocalNode);

    end; {While..}

  end; {Proc..}


{* ------------------------ *}


  Function RepLineRObj.FillCDFLine :  AnsiString;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr       :  AnsiString;



  Begin

    HStr:='';  SpStr:='';

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      Begin

        If (RepFieldRec^.RepDet.PrintVar) then
        Begin

          If (HStr<>'') then
            SpStr:=',';

          HStr:=HStr+SpStr+FillCDF

        end; {If Print var..}

      end; {With..}
      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillCDFLine:=HStr;

  end; {Func..}


  Function RepLineRObj.FillCDFTotals(BTNo     :  Byte;
                                 ShowBrk  :  Boolean) :  AnsiString;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr       :  AnsiString;



  Begin

    HStr:='';  SpStr:='';

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      Begin

        ReCalcBreaks(BTNo,RepFieldRec^);

        If (RepFieldRec^.RepDet.PrintVar) then
        Begin

          If (HStr<>'') then
            SpStr:=',';

          HStr:=HStr+SpStr+FillCDFTot(GetTotal(BTNo,BOff,ShowBrk));

        end; {If Print var..}

      end; {With..}
      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillCDFTotals:=HStr;

  end; {Func..}


  procedure RepLineRObj.WriteDbfRecord;
  const
    IncrementChars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr       :  Str255;

    i, j, k : integer;

    DefStr : WideString;
    s1, s2 : string;
    NameExists : Boolean;
  Begin
{$IFDEF DBF}
    DbfList.Clear;
    NameList.Clear;
    if WantNewDBF then
      DbfFieldList.Clear;
    HStr:='';  SpStr:='';

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      Begin

        If (RepFieldRec^.RepDet.PrintVar) then
        Begin
          DbfList.Add(FillDBF);
          if WantNewDBF then
          begin
            Case RepFieldRec^.RepDet.SortOrd[2] of
              'A'  :  i := 1;
              'D'  :  i := 2;
              else
                i := 0;
            end;

            {PR 28/10/02: Added check for duplicate field names. If name already exists then
            add underscore + number. Increment number until name is unique.}
            {PR 11/06/03. Change to use 0..9,A..Z rather than number as name can sometimes be truncated. eg
              STPERQSA_10 can become STPERQSA_1}

            s1 := UpperCase(DbfFieldDef);
            k := Pos(';', s1);
            s2 := Copy(s1, 1, k - 1);
            NameExists := NameList.IndexOf(s2) >= 0;
            j := 0;
            while NameExists do
            begin
              inc(j);
              if j < 37 then
                s2 := Copy(s1, 1, k - 1) + '_' + IncrementChars[j]
              else
                raise Exception.Create('Too many instances of report field');
              NameExists := NameList.IndexOf(s2) >= 0;
              if not NameExists then
              begin
                Delete(s1, 1, k-1);
                Insert(s2, s1, 1);
              end;
            end;
            NameList.Add(s2);
            DbfFieldList.AddObject(s1{DbfFieldDef}, TObject(i));
          end;
        end; {If Print var..}

      end; {With..}
      LocalNode:=GetNext(LocalNode);
    end; {While..}
    if WantNewDBF then
    begin
      DefStr := DbfFieldList.CommaText;
      oDBF.CreateFile(DefStr);
      WantNewDBF := False;
    end;
    oDBF.AddRec;
    for i := 0 to DbfList.Count - 1 do
       oDBF.SetFieldValue(i + 1, DbfList[i]);
    oDBF.SaveRec;

{$ENDIF}
  end; {Func..}

  { Replaced by FillNomColText }
  Function RepLineRObj.FillNomTotLine(SubsBlnk  :  Boolean) :  Str255;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr       :  Str255;

    OnStr,
    OffStr,
    NomStr     :  Str255;



  Begin

    HStr:='';  SpStr:='';

    OnStr:=''; OffStr:='';

    NomStr:='';

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      With RepFieldRec^ do
      Begin

        If (RepDet.PrintVar) then
        Begin

          If (HStr<>'') then
            SpStr:=' ';

          SetEffect(OnStr,OffStr,RepDet.PrintEff);

          If (RepDict.VarType In ITypValSet) then
          Begin
            If (SubsBlnk) then
              NomStr:=FillField(BOn)
            else
              NomStr:=GetTotal(MaxNoSort,BOn,BOff);
          end
          else
            NomStr:=FillField(BOff);

          HStr:=HStr+OnStr+SpStr+NomStr+OffStr;

        end; {If Print var..}

      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillNomTotLine:=HStr;

  end; {Func..}



{* ------------------------ *}


  Function RepLineRObj.GetColWidths : ColWidthsType;
  Var
    LocalNode  :  NodePtr;
    LocalRField:  RepFieldPtr;
    Idx        :  SmallInt;
  Begin
    FillChar (Result, SizeOf (Result), #0);

    Idx := 1;
    LocalNode:=GetFirst;

    While (LocalNode <> Nil) Do Begin
      LocalRField:=LocalNode^.LITem;

      With LocalRField^, RepFieldRec^, RepDet Do
        If PrintVar Then Begin
          With Result[Idx] Do Begin
            Width := MMWidth;

            { Do educated guess at justification if not set }
            If (Length(Format) > 0) And (Format[1] <> ' ') Then Begin
              Just := Format[1];

              If (Just = 'B') And (Length(Format) > 1) Then Begin
                { Blank - check for justification character after the B }
                If (Format[2] In ['C', 'L', 'R']) Then
                  Just := Format[2];
              End; { If }
            End { If }
            Else Begin
              If CalcField Then
                { Formula }
                Just := 'R'
              Else
                { Data dictionary field }
                If (RepDict.VarType In [2, 3, 6..8]) Then
                  { Real, Double, Longint, Integer, Byte }
                  Just := 'R'
                Else
                  Just := 'L';
            End; { If }
          End; { With }

          Inc (Idx);

          If (RepFieldRec^.RepDet.CDrCr) then Begin
            { Duplicate as its a debit/credit column }
            Result[Idx].Width := Result[Idx - 1].Width;
            Result[Idx].Just  := Result[Idx - 1].Just;
            Inc(Idx);
          End { If }
        End; { If }

      LocalNode:=GetNext(LocalNode);
    End; {While..}

    Result [0].Width := Idx - 1;
  end; {Proc..}


  { Fills the ColText array with the values to be placed in the columns }
  Procedure RepLineRObj.FillColText;
  Var
    LocalNode  :  NodePtr;
    LocalRField:  RepFieldPtr;
    AutoBlnk   :  Boolean;
  Begin
    AutoBlnk:=BOff;

    LocalNode:=GetFirst;

    Blank (ColText^, SizeOf (ColText^));
    ColText^.NumCols := 0;

    While (LocalNode <> NIL) Do Begin
      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
        If (RepFieldRec^.RepDet.PrintVar) then Begin
          Inc (ColText^.NumCols);

          With RepFieldRec^ do
            AutoBlnk:=(((RepDet.Break In [3,4]) or (RepDet.Format='K')) and (LastValue=ThisValue));

            {* Note if using Breakmode which is a global you need to check for one less than
               the normal break mode *}

          With ColText^.Cols[ColText^.NumCols], RepFieldRec^.RepDet Do Begin
            ColVal    := #9+FillField(AutoBlnk);
            FontStyle := WinFont.fStyle;
            FontColor := WinFont.fColor;
          End; { With }
        End; { If }

      LocalNode:=GetNext(LocalNode);
    End; { While }
  end; {Func..}


  Procedure RepLineRObj.FillNomColText (SubsBlnk : Boolean);
  Var
    LocalNode   : NodePtr;
    LocalRField : RepFieldPtr;
    NomStr      : Str255;
  Begin
    LocalNode:=GetFirst;

    Blank (ColText^, SizeOf (ColText^));
    ColText^.NumCols := 0;

    While (LocalNode<>NIL) Do Begin
      LocalRField:=LocalNode^.LITem;

      With LocalRField^, RepFieldRec^ Do Begin
        If (RepDet.PrintVar) then Begin
          Inc (ColText^.NumCols);

          If (RepDict.VarType In ITypValSet) then Begin
            If (SubsBlnk) then
              NomStr:=FillField(BOn)
            else
              NomStr:=GetTotal(MaxNoSort,BOn,BOff);
          End { If }
          Else
            NomStr:=FillField(BOff);

          With ColText^.Cols[ColText^.NumCols], RepFieldRec^.RepDet Do Begin
            ColVal    := #9 + NomStr;
            FontStyle := WinFont.fStyle;
            FontColor := WinFont.fColor;
          End; { With }
        End; { If }
      End; { With }

      LocalNode:=GetNext(LocalNode);
    end; {While..}
  End; {Func..}


  { Returns an array of underlines required: ' ' = none, '-' = single, '=' = double }
  Function RepLineRObj.FillUndies(FinLine  :  Boolean) : ColUndiesType;
  Var
    LocalNode   : NodePtr;
    LocalRField : RepFieldPtr;
    Undies      : ColUndiesType;
    NUndies     : Byte;
  Begin
    LocalNode:=GetFirst;

    Blank (Undies, SizeOf (Undies));
    NUndies := 0;

    While Assigned(LocalNode) Do Begin
      LocalRField:=LocalNode^.LITem;

      With LocalRField^ Do
        If (RepFieldRec^.RepDet.PrintVar) Then Begin
          Undies[NUndies] := FillTUndy(FinLine)[1];
          Inc (NUndies);

          If (RepFieldRec^.RepDet.CDrCr) then Begin
            Undies[NUndies] := Undies[NUndies - 1];
            Inc (NUndies);
          End; { If }
        end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    Result := Undies;
  end; {Func..}

{$IFDEF GUI}
function RepLineRObj.GetField(WhichType : Integer;
                              MTExLocal : tdPostExLocalPtr) : Integer;
var
  LFieldRec : TGuiFieldRec;
  InpFieldRec : TGUIInputRec;
begin
  Result := 9;
  Case WhichType of
    0  :  if Assigned(GetLineField) then
            Result := GetLineField(LFieldRec);
{    1  :  if Assigned(GetInput) then
            Result := GetInput(InpFieldRec);}
  end;

  if Result = 0 then
  begin
    with MTExLocal^.LRepGen^ do
    begin
      FillChar(ReportDet, SizeOf(ReportDet), 0);
      ReportDet.RepVarNo := LFieldRec.FieldNo;
      ReportDet.RecSelect := LFieldRec.RecSel;
      ReportDet.PrintSelect := LFieldRec.PrintSel;
      ReportDet.CalcField := LFieldRec.CalcField;
      ReportDet.NoDecs := LFieldRec.DecPlaces;
      ReportDet.VarLen := LFieldRec.FieldLen;
      ReportDet.VarRef := LFieldRec.VarRef;
      ReportDet.SortOrd := LFieldRec.SortType;
      ReportDet.VarSubSplit := LFieldRec.Calculation;
      ReportDet.RepLCr := LFieldRec.Currency;
      ReportDet.PrSel := {LFieldRec.PeriodField}False;
      ReportDet.RepLPr[False] := LFieldRec.Period;
      ReportDet.RepLPr[True] := Copy (LFieldRec.Year, Length(LFieldRec.Year) - 1, 2);
      ReportDet.RangeFilter := LFieldRec.RangeFilter;
      ReportDet.InputLink := LFieldRec.FInputLink;

    end;
  end;

end;
{$ENDIF}

Function RepLineRObj.GetFieldVal(Const Field   : String) : ResultValueType;
Var
  CopyFrom, CopyLen : Word;
  FuncNo : Byte;
  c : integer;
  TmpNo : Word;
  TmpName : ShortString;

  Function FieldParam : String;
  Var
    BrackPos1, BrackPos2 : Word;
  Begin
    BrackPos1 := Pos ('[', Field) + 1;
    BrackPos2 := Pos (']', Field);
    Result := Copy (Field, BrackPos1, (BrackPos2 - BrackPos1));
  End;

  Function CheckSubStr : Boolean;
  Var
    BrackPos1, CommaPos, BrackPos2 : Word;
    TmpStr                         : String;
  Begin
    BrackPos1 := Pos ('{', Field);
    CommaPos  := Pos (',', Field);
    BrackPos2 := Pos ('}', Field);

    { Check to see if we've got all the brackets }
    { and the positions are feasible             }
    Result :=  (BrackPos1 > 0) And
              ((BrackPos1 + 1) < CommaPos) And
              ((CommaPos + 1) < BrackPos2);

    If Result Then Begin
      { Work out what the substring start and length are }
      TmpStr := Copy (Field, BrackPos1 + 1, (CommaPos - 1 - BrackPos1));
      CopyFrom := IntStr(TmpStr);

      TmpStr := Copy (Field, CommaPos + 1, (BrackPos2 - 1 - CommaPos));
      CopyLen := IntStr(TmpStr);
    End; { If }
  End;


  { Calls the FMTDATE function in the printing routines }
  Function CallDateFormat : ResultValueType;
  Var
    ParamInfo : ParamsType;
    FormLen   : Word;
    FormName  : ShortString;
  Begin
    Result.DblResult := 0.00;
    Result.StrResult := '';

    If Assigned(GetFmtDateEvent) Then
      If ProcessFMTDate(Field, FormLen, FormName, ParamInfo) Then Begin
        With ParamInfo Do
        begin
          Result := GetFmtDateEvent(DateCode, Units, OffUnits, Format);
        end;
      End; { IF }
  End;


  { Calls the GetCurrRate function in the printing routines }
  Function CallCurrRate : ResultValueType;
  Var
    ParamInfo : ParamsType;
    FormLen   : Word;
    FormName  : ShortString;
  Begin
    Result.DblResult := 0.00;
    Result.StrResult := '';

    If Assigned (GetCcyEvent) Then
      If ProcessRateFunc(Field, FormLen, FormName, ParamInfo) Then Begin
        With ParamInfo Do
          Result := GetCcyEvent(DateCode, Units, OffUnits, Format);
      End; { IF }
  End;


  { Calls the Currency Ageing function in the printing routines }
  Function CallCurrAge : ResultValueType;
  Var
    ParamInfo : ParamsType;
    FormLen   : Word;
    FormName  : ShortString;
  Begin
    Result.DblResult := 0.00;
    Result.StrResult := '';

    If Assigned (GetCcyAgeEvent) Then
      If ProcessCcyAging(Field, FormLen, FormName, ParamInfo) Then Begin
        With ParamInfo Do
          Result := GetCcyAgeEvent(DateCode, Units, OffUnits, Format);
      End; { IF }
  End;



begin
  Result.DblResult := 0.00;
  Result.StrResult := '';

  If (Not IsEvaluation) Then Begin
    { Work out what sort of field it is }
    if Is_CustomID(Field, TmpNo, TmpName) then
    begin
      Result  := GetCustomVal(Field);
    end
    else
    If (Pos(DBFieldFunc, Field) = 1) Then Begin
      { Its a Database Field }
      If Assigned (GetDBFEvent) Then
//        Result := GetDBFEvent (FieldParam, FormulaDecs);
      //PR 20/3/07 - change so that calculation can use full decimals - can then be rounded down in printing
        Result := GetDBFEvent (FieldParam, 12);
    End { If }
    Else If (Pos(FormulaFunc, Field) = 1) Then Begin
      { Its a Formula field }
{      If Assigned (GetFMLEvent) Then
        Result := GetFMLEvent (FieldParam, FormulaDecs);}
        Result := GetFormulaValue(FieldParam);
    End { Else .. If }
    Else If (Pos(TableColFunc, Field) = 1) Then Begin
      { Its a Table Column Value }
      If Assigned (GetTBCEvent) Then
        Result := GetTBCEvent (FieldParam, FormulaDecs);
    End { Else .. If }
    Else If (Pos(TablePrevColFunc, Field) = 1) Then Begin
      { Its a Table Column Value - Previous Row }
      If Assigned (GetTBPEvent) Then
        Result := GetTBPEvent (FieldParam, FormulaDecs);
    End { Else .. If }
    Else If (Pos(TableRowNoFunc, Field) = 1) Then Begin
      { Its a table column total }
      If Assigned (GetTRWEvent) Then
        Result := GetTRWEvent (FieldParam, FormulaDecs);
    End { Else .. If }
    Else If (Pos(TableTotalFunc, Field) = 1) Then Begin
      { Its a table column total }
      If Assigned (GetTBTEvent) Then
        Result := GetTBTEvent (FieldParam, FormulaDecs);
    End { Else .. If }
    Else If (Pos(CustNoteGFunc, Field) = 1) Or (Pos(CustNoteDFunc, Field) = 1) Then Begin
      { Customer Notes }
      If Assigned (GetCustNoteEvent) Then
        Result.StrResult := GetCustNoteEvent (FieldParam, Field[1]);
    End { Else .. If }
    Else If (Pos(SuppNoteGFunc, Field) = 1) Or (Pos(SuppNoteDFunc, Field) = 1) Then Begin
      { Supplier Notes }
      If Assigned (GetSuppNoteEvent) Then
        Result.StrResult := GetSuppNoteEvent (FieldParam, Field[1]);
    End { Else .. If }
    Else If (Pos(InvNoteGFunc, Field) = 1) Or (Pos(InvNoteDFunc, Field) = 1) Then Begin
      { Invoice Notes }
      If Assigned (GetInvNoteEvent) Then
        Result.StrResult := GetInvNoteEvent (FieldParam, Field[1]);
    End { Else .. If }
    Else If (Pos(StockNoteGFunc, Field) = 1) Or (Pos(StockNoteDFunc, Field) = 1) Then Begin
      { Stock Notes }
      If Assigned (GetStockNoteEvent) Then
        Result.StrResult := GetStockNoteEvent (FieldParam, Field[1]);
    End { Else .. If }
    Else If (Pos(SNoNoteGFunc, Field) = 1) Or (Pos(SNoNoteDFunc, Field) = 1) Then Begin
      { Serial/Number Notes }
      If Assigned (GetSNoNoteEvent) Then
        Result.StrResult := GetSNoNoteEvent (FieldParam, Field[1]);
    End { Else .. If }
    Else If (Pos(JobNoteGFunc, Field) = 1) Or (Pos(JobNoteDFunc, Field) = 1) Then Begin
      { Job Notes }
      If Assigned (GetJobNoteEvent) Then
        Result.StrResult := GetJobNoteEvent (FieldParam, Field[1]);
    End { Else .. If }
    Else If (Pos(PageNoFunc, Field) = 1) Then Begin
      { Page Number }
      If Assigned (GetPageNoEvent) Then Begin
        Result.DblResult := GetPageNoEvent;
        Result.StrResult := IntToStr(GetPageNoEvent);
      End; { If }
    End { Else .. If }
    Else If (Pos(IdQtyFunc, Field) = 1) Then Begin
      { Page Number }
      If Assigned (GetIdQtyEvent) Then
        Result := GetIdQtyEvent;
    End { Else }
    Else If (Pos(FormatDateFunc, Field) = 1) Then Begin
      { Date Format }
      If Assigned (GetFmtDateEvent) Then
        Result := CallDateFormat;
    End { Else .. If }
    Else If (Pos(RateCompFunc, Field) = 1) Or
            (Pos(RateDayFunc, Field) = 1) Or
            (Pos(RateFloatFunc, Field) = 1) Or
            (Pos(CcyNameFunc, Field) = 1) Or
            (Pos(CcySymbFunc, Field) = 1) Or
            (Pos(RateInvFunc, Field) = 1) Then Begin
      { Currency Rate function }
      If Assigned (GetCcyEvent) Then
        Result := CallCurrRate;
    End { Else }
    Else If (Pos(CcyAgeFunc, Field) = 1) Then Begin
      { Date Format }
      If Assigned (GetCcyAgeEvent) Then
        Result := CallCurrAge;
    end
    else if IsNewFunc(Field, FuncNo) then
    begin
      Result.StrResult := ProcessNewFunc(Field, FuncNo);
      Result.DblResult := 0.0;
    end
    else
    if (Length(Field) > 0) and (Field[1] in ['0'..'9', '-']) then
    begin
      Result.StrResult := Field;
      Val(Field, Result.DblResult, c);
    End
    else
    if (Length(Field) > 0) and (Field[1] in ['''', '"']) then
    begin
      Result.StrResult := Copy(Field, 2, Length(Field) - 2);
      Result.DblResult := 1.0;
    end
    else
    begin
      Result.StrResult := Field;
      Result.DblResult := 1.0;
    end; { Else .. If }
  End { If }
  Else Begin
    { Evaluation }
    Result.DblResult := 1.0;
    Result.StrResult := '1.0';
  End; { If }

  If CheckSubStr Then Begin
    { Have a substring operation }
    Result.StrResult := Copy (Result.StrResult, CopyFrom, CopyLen);

    { Added MH: 12/02/97 }
    Result.DblResult := DoubleStr(Result.StrResult);
  End; { If }
end;

function RepLineRObj.GetFormulaValue(const Field: String): ResultValueType;
{Given a formula name this returns the value of the formula}
var
  FormulaRec : TGUIFieldRec;
  DLink : DictLinkType;
  ParserRec : TParserStateRec;
  LocalRField:  RepFieldPtr;
  VarType : Byte;
  Code : Integer;

  function StripDouble(const s : string) : string;
  begin
    Result := Trim(AnsiReplaceStr(s, ',', ''));
    if (Length(Result) > 0) and (Result[Length(Result)] = '-') then
      Result := '-' + Copy(Result, 1, Length(Result) - 1);
  end;
begin
  if Recurse.StartCheck(Field) then
  begin
    if Assigned(GetFieldFromName) then
    begin
      //Get full formula record from the engine object
      FormulaRec := GetFieldFromName(Field);
      if FormulaRec.PeriodField then
      begin //Period required - need to set period details in Thing object
        New(LocalRField, Init);
        With DLink do
         LocalRField^.Calc_PrYr(FormulaRec.Period,FormulaRec.Year,DPr,DYr);
        Dispose(LocalRField, Done);
        DLink.DCr:=FormulaRec.Currency;
        SetPeriodDetails(DLink, True);
      end
      else
        SetPeriodDetails(DLink, False);

      //Going to pass the formula into the parser so need to save and restore parser state
      FillChar(ParserRec, SizeOf(ParserRec), 0);
      SaveParser(ParserRec);
      VarType := 3;
      Result.StrResult := SetFormula(FormulaRec.Calculation, FormulaRec.DecPlaces, VarType);
      Result.StrResult := StripDouble(Result.StrResult);
      Val(Result.StrResult, Result.DblResult, Code);
      RestoreParser(ParserRec);
    end;
    Recurse.EndCheck(Field);
  end;
end;

Function RepLineRObj.ProcessFMTDate(    RepStr   : String;
                                   Var FormLen  : Word;
                                   Var FormName : ShortString;
                                   Var ParInfo  : ParamsType)  :  Boolean;
Var
  BrackPos1, BrackPos2, CommaPos, I : SmallInt;
  ParamStr                          : ShortString;
  Params                            : Array [1..4] Of ShortString;
  IntVal                            : LongInt;
  ErrCode                           : Integer;
  BracketCount                   : Byte;
Begin
  { Return not found as default }
  Result := False;

  { Check it is a Date format function }
  If (Pos(FormatDateFunc, RepStr) = 1) Then Begin
    { Check for opening bracket }
    BrackPos1 := Pos('[', RepStr);
    If (BrackPos1 In [8..10]) Then
    Begin
      i := BrackPos1 + 1;
      BracketCount := 1;
      while (i <= Length(RepStr)) and (BracketCount > 0) do
      begin
        if RepStr[i] = '[' then inc(BracketCount);
        if RepStr[i] = ']' then Dec(BracketCount);
        inc(i);
      end;
      { Check for closing bracket }
      BrackPos2 := i - 1;//Pos(']', RepStr);
      If (BrackPos2 > BrackPos1) Then Begin
        { Get parameters string and validate }
        If (BrackPos2 > (BrackPos1 + 10)) Then Begin
          { Got some parameters }
          ParamStr := Trim(Copy (RepStr, BrackPos1 + 1, (BrackPos2 - BrackPos1 - 1)));

          If (Length(ParamStr) > 9) Then Begin
            { Parse into separate parameters }
            For I := Low(Params) To Pred(High(Params)) Do Begin
              Params[I] := '';

              CommaPos := Pos(',', ParamStr);
              If (CommaPos > 1) Then Begin
                { Got Param1 }
                Params[I] := UpperCase(Trim(Copy (ParamStr, 1, CommaPos - 1)));
                Delete (ParamStr, 1, CommaPos);
                Params[Succ(I)] := ParamStr;
              End { If }
              Else Begin
                { Invalid Parameters set }
                FormulaErrType := fNoParam;
                { Calc position of error }
                FormulaErrPos := Pos(ParamStr, FormulaStr) - 1;
                Break;
              End; { If }
            End; { For }

            If (FormulaErrType = fOK) Then Begin
              { Validate parameters }
              For I := Low(Params) To High(Params) Do Begin
                Case I Of
                  { Data dictionary code for Data }
                  1 : If (Length(Params[1]) <= 3) Then Begin
                        { Not long enough }
                        FormulaErrType := fInvParam;
                        FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
                      End { If }
                      Else
                        ParInfo.DateCode := {LJ (Params[1],8)}RemoveSqBr(Params[i]);

                  { Offset: 0-999 }
                  2 : Begin
                        { Convert string to value }
                        Val (Params[2], IntVal, ErrCode);

                        If (ErrCode <> 0) Then Begin
                          FormulaErrType := fInvParam;
                          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
                        End { If }
                        Else
                          ParInfo.Units := IntVal;
                      End;

                  { Units: D, M, Y }
                  3 : If (Length(Params[3]) = 1) Then Begin
                        If (Not (Params[3][1] In ['D', 'F', 'L', 'M', 'Y'])) Then Begin
                          FormulaErrType := fInvParam;
                          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
                        End { If }
                        Else
                          ParInfo.OffUnits := Params[3][1];
                      End
                      Else Begin
                        FormulaErrType := fInvParam;
                        FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
                      End;

                  { Format: 0-99 }
                  4 : Begin
                        { Convert string to value }
                        Val (Params[4], IntVal, ErrCode);

                        If (ErrCode <> 0) Then Begin
                          FormulaErrType := fInvParam;
                          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
                        End { If }
                        Else
                          ParInfo.Format := IntVal;
                      End;
                End; { Case }

                If (FormulaErrType <> fOK) Then
                  Break;
              End; { For }
            End; { If }

            { Set result }
            Result := (FormulaErrType = fOK);

            If Result Then Begin
              { Set length of function + parameters }
              FormLen := BrackPos2;

              { check for substring operation as well }
              If (BrackPos2 < Length(RepStr)) Then
                { not at end of string - check for substring bracket '[' }
                If (RepStr[BrackPos2 + 1] = '{') Then Begin
                  BrackPos1 := Pos ('{', RepStr);
                  CommaPos  := Pos (',', Copy(RepStr,BrackPos1,Length(RepStr)));
                  If (CommaPos > 0) Then CommaPos := CommaPos + BrackPos1 - 1;
                  BrackPos2 := Pos ('}', RepStr);

                  { Check to see if we've got all the brackets }
                  { and the positions are feasible             }
                  If (BrackPos1 > 0) And ((BrackPos1 + 1) < CommaPos) And ((CommaPos + 1) < BrackPos2) Then
                    { Have a bracket in the correct place }
                    FormLen := BrackPos2
                  Else Begin
                    { error: no matching end bracket }
                    FormulaErrType := fNoSquare;
                    { Calc position of error }
                    FormulaErrPos := Pos(RepStr, FormulaStr) + Pos ('{', RepStr) - 1;
                  End; { Else }
                End; { If }

              If (FormLen > 1) Then Begin
                FormName := Copy(RepStr, 1, FormLen);
                Result := (FormName <> '');
              End; { If }
            End; { If }
          End { If }
          Else Begin
            { Invalid Parameters set }
            FormulaErrType := fNoParam;
            { Calc position of error }
            FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
          End; { If }
        End { If }
        Else Begin
          { Invalid Parameters set }
          FormulaErrType := fNoParam;
          { Calc position of error }
          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
        End; { If }
      End { If }
      Else Begin
        { No closing bracket }
        FormulaErrType := fNoBracket;
        { Calc position of error }
        FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
      End; { Else }
    End { If }
    Else Begin
      { No parameters }
      FormulaErrType := fNoParam;
      { Calc position of error }
      FormulaErrPos := Pos(RepStr, FormulaStr);
    End; { Else }
  End { If }
  Else Begin
    { No parameters }
    FormulaErrType := fUnknCmd;
    { Calc position of error }
    FormulaErrPos := Pos(RepStr, FormulaStr);
  End; { Else }
End;

{ Checks to see if a valid RTxxx function is in the string }
{ Valid formats:                                           }
{   RTCOMP[THCURR]                                         }
{   RTCOMP[2]                                              }
Function RepLineRObj.ProcessRateFunc(    RepStr   : String;
                                    Var FormLen  : Word;
                                    Var FormName : ShortString;
                                    Var ParInfo  : ParamsType)  :  Boolean;
Var
  BrackPos1, BrackPos2, I : SmallInt;
  ParamStr                : ShortString;
  IntVal                  : LongInt;
  ErrCode                 : Integer;
Begin
  { Return not found as default }
  Result := False;

  FillChar (ParInfo, SizeOf(ParInfo), #0);

  { Check it is a Currency Rate function }
  If (Pos(RateCompFunc, RepStr) = 1)  Then ParInfo.Format := 1;
  If (Pos(RateDayFunc, RepStr) = 1)   Then ParInfo.Format := 2;
  If (Pos(RateFloatFunc, RepStr) = 1) Then ParInfo.Format := 3;
  If (Pos(CcyNameFunc, RepStr) = 1)   Then ParInfo.Format := 4;
  If (Pos(CcySymbFunc, RepStr) = 1)   Then ParInfo.Format := 5;
  If (Pos(RateInvFunc, RepStr) = 1)   Then ParInfo.Format := 6;

  If (ParInfo.Format >= 1) And (ParInfo.Format <= 6) Then Begin
    { Check for opening bracket }
    BrackPos1 := Pos('[', RepStr);
    If (BrackPos1 In [7, 8]) Then Begin
      { Check for closing bracket }
      BrackPos2 := Pos(']', RepStr);
      If (BrackPos2 > BrackPos1) Then Begin
        { Get parameters string and validate }
        ParamStr := Trim(Copy (RepStr, BrackPos1 + 1, (BrackPos2 - BrackPos1 - 1)));

        If (Length(ParamStr) > 0) Then Begin
          { Identify parameter type:- DD Field or Currency Number }
          If (ParamStr[1] In ['A'..'Z']) Then Begin
            { Data Dictionary Field }
            If (Length(ParamStr) <= 3) Or (Length(ParamStr) > 8) Then Begin
              { Not long enough or too long }
              FormulaErrType := fInvParam;
              FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
            End { If }
            Else Begin
              ParInfo.OffUnits := 'D';
              ParInfo.DateCode := LJ (ParamStr,8);
            End; { If }
          End { If }
          Else Begin
            { Must be a number or a screwup }
            Val (ParamStr, IntVal, ErrCode);

            If (ErrCode <> 0) or ((ErrCode = 0) And ((IntVal < 0) Or (IntVal > CurrencyType))) Then Begin
              { Invalid number }
              FormulaErrType := fInvParam;
              FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
            End { If }
            Else Begin
              ParInfo.OffUnits := '#';
              ParInfo.Units := IntVal;
            End; { Else }
          End; { Else }

          { Set result }
          Result := (FormulaErrType = fOK);

          If Result Then Begin
            { Set length of function + parameters }
            FormLen := BrackPos2;

            { check for substring operation as well }
            If (BrackPos2 < Length(RepStr)) Then Begin
              { not at end of string - check for substring bracket '[' }
              If (RepStr[BrackPos2 + 1] = '{') Then Begin
                { Can't do substring on number }
                FormulaErrType := fNoSquare;
                FormulaErrPos := Pos(RepStr, FormulaStr) + Pos ('{', RepStr) - 1;
                FormLen := 0;
              End; { If }
            End; { If }

            If (FormLen > 1) Then Begin
              FormName := Copy(RepStr, 1, FormLen);
              Result := (FormName <> '');
            End; { If }
          End { If }
          Else Begin
            { Invalid Parameters set }
            FormulaErrType := fNoParam;
            { Calc position of error }
            FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
          End; { If }
        End { If }
        Else Begin
          { Invalid Parameters set }
          FormulaErrType := fNoParam;
          { Calc position of error }
          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
        End; { If }
      End { If }
      Else Begin
        { No closing bracket }
        FormulaErrType := fNoBracket;
        { Calc position of error }
        FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
      End; { Else }
    End { If }
    Else Begin
      { No parameters }
      FormulaErrType := fNoParam;
      { Calc position of error }
      FormulaErrPos := Pos(RepStr, FormulaStr);
    End; { Else }
  End { If }
  Else Begin
    { No parameters }
    FormulaErrType := fUnknCmd;
    { Calc position of error }
    FormulaErrPos := Pos(RepStr, FormulaStr);
  End; { Else }
End;


// Checks to see if it is a valid Currency Aging function call
//
// Valid formats:
//   CCYAGE[THCURR,0..7]
//   CCYAGE[2, 0..7]
//
Function RepLineRObj.ProcessCcyAging(    RepStr   : String;
                                    Var FormLen  : Word;
                                    Var FormName : ShortString;
                                    Var ParInfo  : ParamsType)  :  Boolean;
Var
  BrackPos1, BrackPos2, CommaPos, I : SmallInt;
  ParamStr                          : ShortString;
  Params                            : Array [1..2] Of ShortString;
  IntVal                            : LongInt;
  ErrCode                           : Integer;
Begin
  { Return not found as default }
  Result := False;

  { Check it is a Ageing function }
  If (Pos(CcyAgeFunc, RepStr) = 1) Then Begin
    { Check for opening bracket }
    BrackPos1 := Pos('[', RepStr);
    If (BrackPos1 In [7..8]) Then Begin
      { Check for closing bracket }
      BrackPos2 := Pos(']', RepStr);
      If (BrackPos2 > BrackPos1) Then Begin
        { Get parameters string and validate }
        If (BrackPos2 > (BrackPos1 + 3)) Then Begin
          { Got some parameters }
          ParamStr := Trim(Copy (RepStr, BrackPos1 + 1, (BrackPos2 - BrackPos1 - 1)));

          If (Length(ParamStr) > 2) Then Begin
            { Parse into separate parameters }
            For I := Low(Params) To Pred(High(Params)) Do Begin
              Params[I] := '';

              CommaPos := Pos(',', ParamStr);
              If (CommaPos > 1) Then Begin
                { Got Param1 }
                Params[I] := UpperCase(Trim(Copy (ParamStr, 1, CommaPos - 1)));
                Delete (ParamStr, 1, CommaPos);
                Params[Succ(I)] := ParamStr;
              End { If }
              Else Begin
                { Invalid Parameters set }
                FormulaErrType := fNoParam;
                { Calc position of error }
                FormulaErrPos := Pos(ParamStr, FormulaStr) - 1;
                Break;
              End; { If }
            End; { For }

            If (FormulaErrType = fOK) Then Begin
              { Validate parameters }
              For I := Low(Params) To High(Params) Do Begin
                ParamStr := Params[I];

                Case I Of
                  { Currency Number or Data Dictionary code for Currency }
                  1 : If (ParamStr[1] In ['A'..'Z']) Then Begin
                        { Data Dictionary Field }
                        If (Length(ParamStr) < 1) Or (Length(ParamStr) > 8) Then Begin
                          { Not long enough or too long }
                          FormulaErrType := fInvParam;
                          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
                        End { If }
                        Else Begin
                          ParInfo.OffUnits := 'D';
                          ParInfo.DateCode := LJ (ParamStr,8);
                        End; { If }
                      End { If }
                      Else Begin
                        { Hard-Coded number }
                        Val (ParamStr, IntVal, ErrCode);

                        If (ErrCode <> 0) or ((ErrCode = 0) And ((IntVal < 0) Or (IntVal > CurrencyType))) Then Begin
                          { Invalid number }
                          FormulaErrType := fInvParam;
                          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
                        End { If }
                        Else Begin
                          ParInfo.OffUnits := '#';
                          ParInfo.Units := IntVal;
                        End; { Else }
                      End; { Else }

                  { Ageing Value: 0-6 }
                  2 : Begin
                        { Convert string to value }
                        Val (Params[2], IntVal, ErrCode);

                        If (ErrCode <> 0) Then Begin
                          FormulaErrType := fInvParam;
                          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
                        End { If }
                        Else
                          If (Intval < 0) Or (IntVal > 6) Then Begin
                            FormulaErrType := fInvParam;
                            FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
                          End { If }
                          Else
                            ParInfo.Format := IntVal;
                      End;
                End; { Case }

                If (FormulaErrType <> fOK) Then
                  Break;
              End; { For }
            End; { If }

            { Set result }
            Result := (FormulaErrType = fOK);

            If Result Then Begin
              { Set length of function + parameters }
              FormLen := BrackPos2;

              If (FormLen > 1) Then Begin
                FormName := Copy(RepStr, 1, FormLen);
                Result := (FormName <> '');
              End; { If }
            End; { If }
          End { If }
          Else Begin
            { Invalid Parameters set }
            FormulaErrType := fNoParam;
            { Calc position of error }
            FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
          End; { If }
        End { If }
        Else Begin
          { Invalid Parameters set }
          FormulaErrType := fNoParam;
          { Calc position of error }
          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
        End; { If }
      End { If }
      Else Begin
        { No closing bracket }
        FormulaErrType := fNoBracket;
        { Calc position of error }
        FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
      End; { Else }
    End { If }
    Else Begin
      { No parameters }
      FormulaErrType := fNoParam;
      { Calc position of error }
      FormulaErrPos := Pos(RepStr, FormulaStr);
    End; { Else }
  End { If }
  Else Begin
    { No parameters }
    FormulaErrType := fUnknCmd;
    { Calc position of error }
    FormulaErrPos := Pos(RepStr, FormulaStr);
  End; { Else }
End;

function IsNewFunc(RepStr   :  string;
               var FuncNo   :  Byte) : Boolean;
var
  i : integer;
begin
  Result := False;
  for i := 1 to MaxNewFuncs do
    if Pos(NewFuncs[i].FName, RepStr) = 1 then
    begin
      Result := True;
      FuncNo   := i;
      Break;
    end;
end;

function ContainsNewFunc(RepStr   :  string;
                     var FuncNo   :  Byte;
                     var StartPos :  Integer;
                     var EndPos   :  Integer) : Boolean;
var
  i, j, bcount : integer;
  TempS : string;
begin
  Result := False;
  for i := 1 to MaxNewFuncs do
  begin
    j := Pos(NewFuncs[i].FName + '[', RepStr);
    if j > 1 then
    begin
      Result := True;
      StartPos := j;
      FuncNo   := i;
      //Find end pos
      while RepStr[j] <> '[' do inc(j);
      inc(j);
//      TempS := Copy(RepStr, j, Length(RepStr));
      bcount := 1;
      while (j < Length(RepStr)) and (bcount > 0) do
      begin
        inc(j);
        if RepStr[j] = '[' then
          inc(bcount)
        else
        if RepStr[j] = ']' then
          dec(bcount);
      end;
      EndPos := j;
      Break;
    end;
  end;
end;



function DateToNoOfDays(const d :string) : string;
var
  dt : TDateTime;
begin
  if Trim(d) = '' then
    dt := 0
  else
    dt := StrToDateTime(d);
  Result := IntToStr(Trunc(dt) - 2);
end;

function ContainsAFormula(const s : string) : Boolean;
var
  i : integer;
begin
  Result := False;
  if (Length(s) > 0) and (s[1] <> '"') then
    for i := 1 to Length(s) do
      if s[i] in ['+', '-', '*', '/'] then
      begin
        Result := True;
        Break;
      end;
end;

function RepLineRObj.ProcessNewFunc(RepStr : string; FuncNo : Byte) : string;
var
  BracketCount : Byte;
  i, j, k, c : integer;
  TmpDble : Double;
  FNo : Byte;
  StartPos, EndPos : Integer;
  v1, v2, v3 : string;
  d1, d2, d3 : Double;
  s : string;
  ResVal : ResultValueType;
  VType : Byte;
  HasErr : Boolean;
  sModifier : string;

  function CheckDate(const sDate : string) : string;
  var
    iCode : Integer;
    iCodeTmp : LongInt;
  begin
    if StrToDateDef(sDate, 0) <> 0 then
      Result := sDate
    else
    if (Length(sDate) = 8) then
    begin
      Val(sDate, iCodeTmp, iCode);
      if iCode = 0 then
        Result := POutDate(sDate)
      else
        Result := '';
    end
    else
      Result := '';
  end;

  function FieldValWithCheck(const s : string) : ResultValueType;
  var
    Att : Word;
    TempS : string;
    StateRec : TParserStateRec;
  begin
    if ContainsAFormula(s) then
    begin
      FillChar(StateRec, SizeOf(StateRec), 0);
      SaveParser(StateRec);
      Result.DblResult := Parse(s, Att, TempS);
      Result.StrResult := TempS;
      RestoreParser(StateRec);
    end
    else
      Result := GetFieldVal(s);
  end;


  procedure ProcessFormatString;
  var
    iClosePos : Integer;
  begin
    sModifier := '';
    if FuncNo in [7, 8] then
    begin
      iClosePos := Pos(']', s);
      if iClosePos > 0 then
      begin
        sModifier := Copy(s, iClosePos + 1, Length(s));
        s := Copy(s, 1, iClosePos);
      end;
    end;
  end;

begin
  if ContainsNewFunc(RepStr, FNo, StartPos, EndPos) then
  begin
    s := ProcessNewFunc(Copy(RepStr, StartPos, EndPos - StartPos + 1), FNo);
    Delete(RepStr, StartPos, EndPos - StartPos + 1);
    if s = '' then
      s := '0';
    Insert(s, RepStr, StartPos);
  end;
  v1 := ''; v2 := ''; v3 := '';
  d1 := 0; d2 := 0; d3 := 0;
  s := RepStr;
  BracketCount := 0;
  i := Pos('[', s);
  s := RemoveSqBr(Copy(s, i, Length(s)));
  if IsInput(s) then
  begin
  //PR: 18/08/2009 For functions DateToText & NumberToText where the value is an input field, it will get to
  //this point looking something like I1[1],dddd. This will fail the GetInpField method so we need to
  //split the string in order to get the Input Value then join them again for passing to the actual function
    ProcessFormatString;
    s := InpObj^.GetInpField(s,VType,HasErr);
    s := s + sModifier;
  end;

  Case NewFuncs[FuncNo].FParams of
    1 : v1 := s;
    2, 3 : begin
             i := Pos(',', s);
             v1 := Trim(Copy(s, 1, i-1));
             v2 := Trim(Copy(s, i+1, Length(s)));
             if NewFuncs[FuncNo].FParams = 3 then
             begin
               i := Pos(',',v2);
               v3 := Trim(Copy(v2, i + 1, Length(v2)));
               Delete(v2, i, Length(v2));
             end;
           end;
  end;//case

  if FuncNo <> IfF then
  begin
//    ResVal := GetFieldVal(v1);
    ResVal := FieldValWithCheck(v1);
    v1 := ResVal.StrResult;
    d1 := ResVal.DblResult;
  end;

//  ResVal := GetFieldVal(v2);
  ResVal := FieldValWithCheck(v2);
  v2 := ResVal.StrResult;
  d2 := ResVal.DblResult;

//  ResVal := GetFieldVal(v3);
  ResVal := FieldValWithCheck(v3);
  v3 := ResVal.StrResult;
  d3 := ResVal.DblResult;

  Case FuncNo of
    RoundF     : Result := DoRoundFunc(d1, d2);
    MinF       : Result := DoMinMaxFunc(d1, d2, False);
    MaxF       : Result := DoMinMaxFunc(d1, d2, True);
    IfF        : Result := DoIfFunc(v1, v2, v3);
    SubStrF    : Result := DoSubStringFunc(v1, d2, d3);
    Text2NoF   : begin
                   Val(Trim(v1), TmpDble, c);
                   if c = 0 then
                     Result := Trim(v1)
                   else
                     Result := '0';
                 end;
    No2TextF   : Result := DoNo2TextFunc(d1, v2);
    Date2TextF : Result := DoDate2TextFunc(CheckDate(v1), v2);
    Date2NoF   : Result := DateToNoOfDays(CheckDate(v1));
    TrimF      : Result := Trim(v1);
    TruncF     : Result := DoTruncFunc(d1);
  end;


end;

function RepLineRObj.DoTruncFunc(const d1 : Double) : string;
var
  i : integer;
begin
{  i := Pos('.', v1);
  if i = 0 then
    Result := v1
  else
    Result := Copy(v1, 1, i - 1);}
  i := Trunc(d1);
  Result := IntToStr(i);
end;

function RepLineRObj.GetNewFuncLength(const s : string) : integer;
var
  i, j, q : integer;
  BCount : integer;
begin
  i := Pos('[', s) + 1;
  q := Length(s);
  BCount := 1;
  while (i <= q) and (BCount > 0) do
  begin
    if s[i] = '[' then
      inc(BCount)
    else
    if s[i] = ']' then
      dec(BCount);
    if BCount > 0 then
      inc(i);
  end;

  if i <= q then
    Result := i
  else
    Result := q;
end;

function RepLineRObj.DoRoundFunc(const d1, d2 : Double) : string;
var
  d : Double;
  c, Dec : integer;
begin
  Dec := Trunc(d2);

  d := Round_Up(d1, Dec);

  Result := SysUtils.Format('%11.' + IntToStr(Dec) + 'f', [d]);
end;

function RepLineRObj.DoSubStringFunc(const v1 : string;
                                           d1, d2 : Double) : string;
var
  i1, i2 : integer;
begin
  i1 := Trunc(d1);
  i2 := Trunc(d2);
  Result := Copy(v1, i1, i2);
end;

function RepLineRObj.DoNo2TextFunc(d1 : Double; const v1 : string) : string;
begin
  Result := SysUtils.Format(v1, [d1]);
end;

function RepLineRObj.DoDate2TextFunc(const v1, v2 : string) : string;
var
  d, m, y : Word;
  dt : TDateTime;
begin
  if Trim(v1) = '' then
    dt := 0
  else
  if Pos(DateSeparator, v1) > 0 then
    dt := StrToDateTime(v1)
  else
  begin
    DateStr(v1, d, m, y);
    dt := EncodeDate(y, m, d);
  end;
  if dt = 0 then
    Result := ''
  else
    Result := FormatDateTime(v2, dt);
end;

function RepLineRObj.DoDate2NoFunc(const v1 : string) : string;
//Input: Date in format yyyymmdd
//Output: Date as number of days since 1/1/1900
var
  d, m, y : Word;
  dt : TDateTime;
begin
  if v1 <> '' then
  begin
    DateStr(v1, d, m, y);
    dt := EncodeDate(y, m, d);
    //Integer part of tdatetime is days since 30/12/1899 so subtract 2 days
    Result := IntToStr(Trunc(dt) - 2);
  end
  else
    Result := '0';
end;

function RepLineRObj.DoMinMaxFunc(const d1, d2 : Double;
                                  WantMax : Boolean) : string;
var
  c : integer;
begin
  if WantMax then
    Result := FloatToStr(Max(d1, d2))
  else
    Result := FloatToStr(Min(d1, d2));
end;



function RepLineRObj.DoIfFunc(const Cond     : string;
                              const ValTrue  : string;
                              const ValFalse : string) : String;
var
  WPos, ErrNo : Byte;
  Res : Boolean;
begin
  if Evaluate_Expression(Cond, ErrNo) then
//  if EvalCond(Cond, WPos, ErrNo) then
    Result := ValTrue
  else
    Result := ValFalse;
  if ErrNo > 0 then
    Result  := 'Error in function';
end;





Function RepLineRObj.Is_RepVar(    RepStr   :  String;
                              Var FormLen  :  Word;
                              Var FormName :  ShortString)  :  Boolean;
Var
  ParInfo                        : ParamsType;
  BrackPos1, BrackPos2, CommaPos : Word;
Begin
  { Return not found as default }
  Result := False;

  { Check for: Database Field DBF }
  {            Formula Field FML }
  {            Table Column TBC }
  {            Table Column Total TBT }
  If (Pos(FormulaFunc, RepStr) = 1) Or
     (Pos(DBFieldFunc, RepStr) = 1) Or
     (Pos(TableColFunc, RepStr) = 1) Or
     (Pos(TablePrevColFunc, RepStr) = 1) Or
     (Pos(TableRowNoFunc, RepStr) = 1) Or
     (Pos(TableTotalFunc, RepStr) = 1) Then Begin
    { Check for opening bracket }
    BrackPos1 := Pos('[', RepStr);
    If (BrackPos1 In [4, 5]) Then Begin
      { Check for closing bracket }
      BrackPos2 := Pos(']', RepStr);
      If (BrackPos2 > (BrackPos1 + 1)) Then Begin
        { Got a ')' in the correct place }
        FormLen := BrackPos2;

        If (BrackPos2 < Length(RepStr)) Then
          { not at end of string - check for substring bracket '[' }
          If (RepStr[BrackPos2 + 1] = '{') Then Begin
            BrackPos1 := Pos ('{', RepStr);
            CommaPos  := Pos (',', RepStr);
            BrackPos2 := Pos ('}', RepStr);

            { Check to see if we've got all the brackets }
            { and the positions are feasible             }
            If (BrackPos1 > 0) And ((BrackPos1 + 1) < CommaPos) And ((CommaPos + 1) < BrackPos2) Then
              { Have a bracket in the correct place }
              FormLen := BrackPos2
            Else Begin
              { error: no matching end bracket }
              FormulaErrType := fNoSquare;
              { Calc position of error }
              FormulaErrPos := Pos(RepStr, FormulaStr) + Pos ('{', RepStr) - 1;
            End; { Else }
          End; { If }

        If (FormLen > 1) Then Begin
          FormName := Copy(RepStr, 1, FormLen);
          Result := (FormName <> '');
        End; { If }
      End { If }
      Else Begin
        { No closing bracket }
        FormulaErrType := fNoBracket;
        { Calc position of error }
        FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
      End; { Else }
    End { If }
    Else Begin
      { No parameters }
      FormulaErrType := fNoParam;
      { Calc position of error }
      FormulaErrPos := Pos(RepStr, FormulaStr);
    End; { Else }
  End { If }
  Else Begin
    { Check for note line functions }
    If (Pos(CustNoteGFunc,  RepStr) = 1) Or
       (Pos(SuppNoteGFunc,  RepStr) = 1) Or
       (Pos(InvNoteGFunc,   RepStr) = 1) Or
       (Pos(StockNoteGFunc, RepStr) = 1) Or
       (Pos(CustNoteDFunc,  RepStr) = 1) Or
       (Pos(SuppNoteDFunc,  RepStr) = 1) Or
       (Pos(InvNoteDFunc,   RepStr) = 1) Or
       (Pos(SNoNoteDFunc,   RepStr) = 1) Or
       (Pos(SNoNoteGFunc,   RepStr) = 1) Or
       (Pos(JobNoteDFunc,   RepStr) = 1) Or
       (Pos(JobNoteGFunc,   RepStr) = 1) Or
       (Pos(StockNoteDFunc, RepStr) = 1) Then Begin
      { Check for opening bracket }
      BrackPos1 := Pos('[', RepStr);
      If (BrackPos1 In [8..10]) Then Begin
        { Check for closing bracket }
        BrackPos2 := Pos(']', RepStr);
        If (BrackPos2 > (BrackPos1 + 1)) Then Begin
          { Got a ')' in the correct place }
          FormLen := BrackPos2;

          If (BrackPos2 < Length(RepStr)) Then
            { not at end of string - check for substring bracket '[' }
            If (RepStr[BrackPos2 + 1] = '{') Then Begin
              BrackPos1 := Pos ('{', RepStr);
              CommaPos  := Pos (',', RepStr);
              BrackPos2 := Pos ('}', RepStr);

              { Check to see if we've got all the brackets }
              { and the positions are feasible             }
              If (BrackPos1 > 0) And ((BrackPos1 + 1) < CommaPos) And ((CommaPos + 1) < BrackPos2) Then
                { Have a bracket in the correct place }
                FormLen := BrackPos2
              Else Begin
                { error: no matching end bracket }
                FormulaErrType := fNoSquare;
                { Calc position of error }
                FormulaErrPos := Pos(RepStr, FormulaStr) + Pos ('{', RepStr) - 1;
              End; { Else }
            End; { If }

          If (FormLen > 1) Then Begin
            FormName := Copy(RepStr, 1, FormLen);
            Result := (FormName <> '');
          End; { If }
        End { If }
        Else Begin
          { No closing bracket }
          FormulaErrType := fNoBracket;
          { Calc position of error }
          FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
        End; { Else }
      End { If }
      Else Begin
        { No parameters }
        FormulaErrType := fNoParam;
        { Calc position of error }
        FormulaErrPos := Pos(RepStr, FormulaStr);
      End; { Else }
    End { If }
    Else Begin
      { Check For Page Number }
      If (Pos(PageNoFunc, RepStr) = 1) Then Begin
        FormName := Copy(RepStr, 1, Length(PageNoFunc));
        Result := (FormName <> '');
      End { If }
      Else Begin
        If (Pos(IdQtyFunc, RepStr) = 1) Then Begin
          FormName := Copy(RepStr, 1, Length(IdQtyFunc));
          Result := (FormName <> '');
        End { If }
        Else Begin
          { Check for Date Formatting function }
          If (Pos(FormatDateFunc, RepStr) = 1) Then Begin
            Result := ProcessFMTDate(RepStr, FormLen, FormName, ParInfo);
          End { If }
          Else Begin
            { Check for Currency Rate Functions }
            If (Pos(RateCompFunc, RepStr) = 1) Or
               (Pos(RateDayFunc, RepStr) = 1) Or
               (Pos(RateFloatFunc, RepStr) = 1) Or
               (Pos(CcyNameFunc, RepStr) = 1) Or
               (Pos(CcySymbFunc, RepStr) = 1) Or
               (Pos(RateInvFunc, RepStr) = 1) Then Begin
              Result := ProcessRateFunc(RepStr, FormLen, FormName, ParInfo);
            End { If }
            Else Begin
              If (Pos(CcyAgeFunc, RepStr) = 1) Then Begin
                FillChar(ParInfo, SizeOf(ParInfo), #0);
                Result := ProcessCcyAging(RepStr, FormLen, FormName, ParInfo);
              End; { If }
            End; { Else }
          End; { Else }
        End; { Else }
      End; { Else }
    End; { Else }
  End; { Else }
End; {Func..}

Function RepLineRObj.Is_CustomID(    RepStr   :  String;
                                 Var FormLen  :  Word;
                                 Var FormName :  ShortString)  :  Boolean;
Var
  ParInfo                        : ParamsType;
  BrackPos1, BrackPos2, CommaPos, i : Word;
  BrackCount : Integer;
  Found : Boolean;
Begin
  { Return not found as default }
  Result := False;
  Found := False;
  if Length(CustomIDs) > 0 then
    for i := Low(CustomIDs) to High(CustomIDs) do
      if Pos(CustomIDs[i], RepStr) = 1 then
      begin
        Found := True;
        Break;
      end;

  if Found then
  begin
    BrackCount := 0;
    BrackPos1 := Pos('[', RepStr);
    if BrackPos1 > 0 then
    begin
      inc(BrackCount);
      i := BrackPos1;
      while (i < Length(RepStr)) and (BrackCount > 0) do
      begin
        inc(i);
        if RepStr[i] = '[' then
          inc(BrackCount)
        else
        if RepStr[i] = ']' then
          dec(BrackCount);
      end;
        BrackPos2 := i;

      If (BrackPos2 > (BrackPos1 + 1)) Then Begin
        { Got a ')' in the correct place }
        FormLen := BrackPos2;

      End { If }
      Else Begin
        { No closing bracket }
        FormulaErrType := fNoBracket;
        { Calc position of error }
        FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
      End; { Else }
    End { If }
    Else Begin
      { No parameters }
      FormulaErrType := fNoParam;
      { Calc position of error }
      FormulaErrPos := Pos(RepStr, FormulaStr);
    End; { Else }

    If (FormLen > 1) Then
    begin
      FormName := Copy(RepStr, 1, FormLen);
      Result := (FormName <> '');
    end;
  End; { If }
End; {Func..}

function RepLineRObj.RemoveSqBr(const s : String) : String;
var
  i, j : integer;
begin
  //To remove square brackets at start & end of s. In some circumstances we
  //might not have a closing bracket, so check before removing.
  Result := Copy(s, 2, Length(s));
  if Length(Result) > 0 then
    if Result[Length(Result)] = ']' then
      Delete(Result, Length(Result), 1);
end;

function RepLineRObj.IsInput(const s : string) : Boolean;
begin
  Result := (Length(s) > 1) and (s[1] = 'I') and (s[2] in ['1'..'9']);
end;

function RepLineRObj.GetCustomVal(const ID: string): ResultValueType;
var
  i : Integer;
  BrackPos1, BrackPos2 : integer;
  BrackCount : Integer;
  VarName, VarID : string;
  ErrCode : SmallInt;
  ErrString, ErrWord : ShortString;
begin
  if Assigned(GetCustomValue) then
  begin
    ErrCode := 0;
    ErrString := '';
    ErrWord := '';
    BrackCount := 0;
    BrackPos1 := Pos('[', ID);
    if BrackPos1 > 0 then
    begin
      inc(BrackCount);
      i := BrackPos1;
      while (i < Length(ID)) and (BrackCount > 0) do
      begin
        inc(i);
        if ID[i] = '[' then
          inc(BrackCount)
        else
        if ID[i] = ']' then
          dec(BrackCount);
      end;
      if ID[i] = ']' then
      begin
        BrackPos2 := i;
        VarID := Trim(Copy(ID, 1, BrackPos1 - 1));
        VarName := Trim(Copy(ID, BrackPos1 + 1, BrackPos2 - BrackPos1 - 1));
        Result := GetCustomValue(VarID, VarName, ErrCode, ErrString, ErrWord);
        VErrCode := ErrCode;
        VErrMsg := ErrString;
        VErrWord := ErrWord;
      end
      else
        VErrCode := veMissingBracket;
    end
    else
      VErrCode := veMissingBracket;

  end
  else
    VErrCode := veNoCustomFunc;
end;


{$IFDEF FMLDBG}

Initialization
  StrList := TStringList.Create;
Finalization
  StrList.SaveToFile('c:\fmladbug.txt');
  StrList.Free;
{$ENDIF}
end.



