unit Parser;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses SysUtils, GlobVar, VarConst, McVars, GlobType, TEditVal;

Const
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
  MAXFUNCNAMELEN = 25;{5;}
  ErrStr =  'ERROR';

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

  // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  LoadRoleFunc     = 'LOADROLE';


Type
  ParseErrType = (fOK, fUnknown, fBlank, fNoSquare, fUnknCmd, fUnknOp,
                  fMathErr, fNoBracket, fNoParam, fInvStruct, fInvParam);

  TokenRec = record
    State : Byte;
    case Byte of
      0 : (Value : Real);
      1 : (Row, Col : Word);
      2 : (FuncName : String[MAXFUNCNAMELEN]);
  end;

  ParamsType = Record
    DateCode : String;
    Units    : SmallInt;
    OffUnits : Char;
    Format   : SmallInt;
  End; { ParamsType }

  // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  ParamsType_LoadRole = Record
    AccountCodeField : ShortString;
    RoleDescription  : ShortString;
  End; // ParamsType_LoadRole

  StackArrayType = array [1..PARSERSTACKSIZE] of TokenRec;

  TGetDBFEvent = Function (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType Of Object;
  TDocSignEvent = Function : SmallInt Of Object;
  TNoParamsEvent = Function : ResultValueType Of Object;
  TGetNoteEvent = Function (Const NoteNo   : String;
                            Const NoteType : Char) : String Of Object;
  TFmtDateEvent = Function (Const DateCode : String10;
                            Const Units    : SmallInt;
                            Const OffUnits : Char;
                            Const Format   : SmallInt) : ResultValueType Of Object;
  // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  TLoadRoleEvent = Function (Const AcCode : ShortString;
                             Const RoleDesc : ShortString) : ResultValueType Of Object;

  TParserObj = Class (TObject)
  Private
    FormulaStr                       : String;
    FormulaDecs                      : Byte;
    IsEvaluation                     : Boolean;
    Stack                            : ^StackArrayType;
    CurToken                         : TokenRec;
    StackTop, TokenType              : Word;
    MathError, TokenError, IsFormula : Boolean;
    Input                            : String200{IString};

    function  IsFunc(S : String) : Boolean;
    Function  Is_RepVar(    RepStr   :  String;
                        Var FormLen  :  Word;
                        Var FormName :  ShortString)  :  Boolean;
    function  NextToken : Word;
    procedure Push(Token : TokenRec);
    procedure Pop(var Token : TokenRec);
    function  GotoState(Production : Word) : Word;
    function  CellValue(Col, Row : Word) : Real;
    procedure Shift(State : Word);
    procedure Reduce(Reduction : Word);
    Function Parse(S : String; var Att : Word) : Real;
    Function ConcatCalc(    FStr   : String200;
                        Var IVType : Byte;
                        Var HasErr : Boolean) : String200;
    Function GetFieldVal(Const Field   : String) : ResultValueType;
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

    // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
    Function ProcessLoadRole(    RepStr   : String;
                             Var FormLen  : Word;
                             Var FormName : ShortString;
                             Var ParInfo  : ParamsType_LoadRole)  :  Boolean;
  Public
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
    // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
    GetLoadRoleEvent  : TLoadRoleEvent;

    Constructor Create;
    Destructor Destroy; Override;

    Function SetFormula(      Formula   : String200;
                              NoDecs    : Byte;
                        Var   IVType    : Byte;
                        Const Evaluate  : Boolean) : String200;
    Function FormulaErrStr : String;
    Function FormulaErr : Boolean;
    Function Evaluate_Expression (     Expression  : String200;
                                  Const Evaluate   : Boolean)  :  boolean;
  End; { TParserObj }


implementation

Uses Dialogs, BTSupU1, ETMiscU, EtStrU, SBSFuncs, VarRec2U;


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


Constructor TParserObj.Create;
Begin
  Inherited Create;

  GetMem (Stack, SizeOf (Stack^));

  GetDBFEvent       := Nil;
  GetFMLEvent       := Nil;
  GetTBCEvent       := Nil;
  GetTBPEvent       := Nil;
  GetTBTEvent       := Nil;
  GetTRWEvent       := Nil;
  GetDocSignEvent   := Nil;
  GetCustNoteEvent  := Nil;
  GetSuppNoteEvent  := Nil;
  GetInvNoteEvent   := Nil;
  GetStockNoteEvent := Nil;
  GetSNoNoteEvent   := Nil;
  GetJobNoteEvent   := Nil;
  GetPageNoEvent    := Nil;
  GetIdQtyEvent     := Nil;
  GetFmtDateEvent   := Nil;
  GetCcyEvent       := Nil;
End;

Destructor TParserObj.Destroy;
Begin
  FreeMem (Stack, SizeOf (Stack^));

  Inherited Destroy;
End;

function TParserObj.IsFunc(S : String) : Boolean;
{ Checks to see if the start of the Input string is a legal function.
  Returns TRUE if it is, FALSE otherwise.
}
var
  Len : Word;
begin
  Len := Length(S);
  if Pos(S, Input) = 1 then
  begin
    CurToken.FuncName := Copy(Input, 1, Len);
    Delete(Input, 1, Len);
    IsFunc := True;
  end
  else
    IsFunc := False;
end; { IsFunc }


{ Checks to see if a valid FMTDATE function is in the string }
{ Valid formats:                                             }
{   FMTDATE[THDATE,0,D,1]                                    }
{   FMTDATE[THDATE,30,D,1]                                   }
{   FMTDATE[SYSTODAY,1,M,3]                                  }
{   FMTDATE[THDATEDU,7,D,1]                                  }
{   FMTDATE[THDATE,30,D,1]{1,4}
Function TParserObj.ProcessFMTDate(    RepStr   : String;
                                   Var FormLen  : Word;
                                   Var FormName : ShortString;
                                   Var ParInfo  : ParamsType)  :  Boolean;
Var
  BrackPos1, BrackPos2, CommaPos, I : SmallInt;
  ParamStr                          : ShortString;
  Params                            : Array [1..4] Of ShortString;
  IntVal                            : LongInt;
  ErrCode                           : Integer;
Begin
  { Return not found as default }
  Result := False;

  { Check it is a Date format function }
  If (Pos(FormatDateFunc, RepStr) = 1) Then Begin
    { Check for opening bracket }
    BrackPos1 := Pos('[', RepStr);
    If (BrackPos1 In [8..10]) Then Begin
      { Check for closing bracket }
      BrackPos2 := Pos(']', RepStr);
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
                        ParInfo.DateCode := LJ (Params[1],8);

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
Function TParserObj.ProcessRateFunc(    RepStr   : String;
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
Function TParserObj.ProcessCcyAging(    RepStr   : String;
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

//-------------------------------------------------------------------------

//
// Parses the LoadRole command string
//
//  LOADROLE[ACACC,Send Statement]
//
// [IN]  RepStr - The string being parsed
// [OUT] FormLen - The length of the function name and paramters, so the parser can skip past it
// [OUT] FormName - The text of the function name and parameters - no idea why this is needed
// [OUT] ParInfo - the parsed parameters
//
Function TParserObj.ProcessLoadRole(    RepStr   : String;
                                    Var FormLen  : Word;
                                    Var FormName : ShortString;
                                    Var ParInfo  : ParamsType_LoadRole)  :  Boolean;
Var
  BrackPos1, BrackPos2, CommaPos : SmallInt;
  ParamStr                       : ShortString;
Begin // ProcessLoadRole
  { Return not found as default }
  Result := False;

  { Check it is the Load Role function }
  If (Pos(LoadRoleFunc, RepStr) = 1) Then
  Begin
    // Check for opening bracket
    BrackPos1 := Pos('[', RepStr);
    If (BrackPos1 = 9) Then
    Begin
      // Check for closing bracket
      BrackPos2 := Pos(']', RepStr);
      If (BrackPos2 > (BrackPos1 + 3)) Then
      Begin
        // Got some parameters - split into A/C Code dd field and Role Desccription
        ParamStr := Trim(Copy (RepStr, BrackPos1 + 1, (BrackPos2 - BrackPos1 - 1)));

        // Look for comma splitting the two parameters
        CommaPos := Pos(',', ParamStr);
        If (CommaPos > 1) Then
        Begin
          // split into A/C Code dd field and Role Desccription
          ParInfo.AccountCodeField := UpperCase(Trim(Copy (ParamStr, 1, CommaPos - 1)));
          ParInfo.RoleDescription := UpperCase(Trim(Copy (ParamStr, CommaPos + 1, 255)));

          // Replace any embedded underscores in the Role Description with spaces
          CommaPos := Pos ('_', ParInfo.RoleDescription);
          While (CommaPos > 0) Do
          Begin
            ParInfo.RoleDescription[CommaPos] := ' ';
            CommaPos := Pos ('_', ParInfo.RoleDescription);
          End; // While (CommaPos > 0)

          //ShowMessage (ParamStr + #13 + 'AccountCodeField: ' + ParInfo.AccountCodeField + #13 + 'RoleDescription: ' + ParInfo.RoleDescription);
          Result := True;

          FormLen := BrackPos2;
          FormName := Copy(RepStr, 1, FormLen);
        End // If (CommaPos > 1)
        Else
        Begin
          { Invalid Parameters set }
          FormulaErrType := fNoParam;
          { Calc position of error }
          FormulaErrPos := BrackPos1;
        End; // Else
      End // If (BrackPos2 > (BrackPos1 + 3))
      Else
      Begin
        { No closing bracket }
        FormulaErrType := fNoBracket;
        { Calc position of error }
        FormulaErrPos := Pos(RepStr, FormulaStr) + BrackPos1 - 1;
      End; { Else }
    End // If (BrackPos1 = 9)
    Else
    Begin
      { No parameters }
      FormulaErrType := fNoParam;
      { Calc position of error }
      FormulaErrPos := Pos(RepStr, FormulaStr);
    End; { Else }
  End { If }
  Else
  Begin
    { No parameters }
    FormulaErrType := fUnknCmd;
    { Calc position of error }
    FormulaErrPos := Pos(RepStr, FormulaStr);
  End; { Else }
End; // ProcessLoadRole

//-------------------------------------------------------------------------

Function TParserObj.Is_RepVar(    RepStr   :  String;
                              Var FormLen  :  Word;
                              Var FormName :  ShortString)  :  Boolean;
Var
  ParInfo                        : ParamsType;
  ParInfo_LoadRole               : ParamsType_LoadRole;
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
              End { If }
              Else If (Pos(LoadRoleFunc, RepStr) = 1) Then
              Begin
                FillChar(ParInfo_LoadRole, SizeOf(ParInfo_LoadRole), #0);
                Result := ProcessLoadRole(RepStr, FormLen, FormName, ParInfo_LoadRole);
              End; // If (Pos(LoadRoleFunc, RepStr) = 1)
            End; { Else }
          End; { Else }
        End; { Else }
      End; { Else }
    End; { Else }
  End; { Else }
End; {Func..}

function TParserObj.NextToken : Word;
{ Gets the next Token from the Input stream }
var
  NumString : String[80];
  FormLen : Word;
  Place, Len, NumLen, Check : Integer;
  FirstChar : Char;
  Decimal : Boolean;
begin
  if (Input = '') then begin
    NextToken := EOL;
    Exit;
  end;

  while (Input <> '') and (Input[1] = ' ') do
    Delete(Input, 1, 1);

  if Input[1] in ['0'..'9', '.'] then begin
    NumString := '';
    Len := 1;
    Decimal := False;
    while (Len <= Length(Input)) and
          ((Input[Len] in ['0'..'9']) or
          ((Input[Len] = '.') and (not Decimal))) do begin
      NumString := NumString + Input[Len];
      if Input[1] = '.' then
        Decimal := True;
      Inc(Len);
    end;

    if (Len = 2) and (Input[1] = '.') then begin
      NextToken := BAD;
      Exit;
    end;

    if (Len <= Length(Input)) and (Input[Len] = 'E') then begin
      NumString := NumString + 'E';
      Inc(Len);
      if Input[Len] in ['+', '-'] then begin
        NumString := NumString + Input[Len];
        Inc(Len);
      end;
      NumLen := 1;
      while (Len <= Length(Input)) and (Input[Len] in ['0'..'9']) and
            (NumLen <= MAXEXPLEN) do begin
        NumString := NumString + Input[Len];
        Inc(NumLen);
        Inc(Len);
      end;
    end;

    if NumString[1] = '.' then NumString := '0' + NumString;
    Val(NumString, CurToken.Value, Check);
    if Check <> 0 then MathError := True;
    NextToken := NUM;
    Delete(Input, 1, Length(NumString));
    Exit;
  End { If }
  Else
    if (Input[1] in LETTERS) then begin
      if IsFunc('ABS') or
         IsFunc('ATAN') or
         IsFunc('COS') or
         IsFunc('EXP') or
         IsFunc('LN') or
         IsFunc('ROUND') or
         IsFunc('SIN') or
         IsFunc('SQRT') or
         IsFunc('SQR') or
         IsFunc(DocSignFunc) or
         IsFunc('TRUNC') then
      begin
        NextToken := FUNC;
        Exit;
      end;

      { Check for report variable here }
      If Is_RepVar(Input, FormLen, CurToken.FuncName) then begin
        Delete(Input, 1, FormLen);
        IsFormula := True;
        NextToken := CELLT;
        Exit;
      End { If }
      Else Begin
        NextToken := BAD;
        If (FormulaErrType = fOk) Then Begin
          FormulaErrType := fUnknCmd;
          FormulaErrPos := Pos(Input, FormulaStr); { Calc position of error }
        End; { If }
        Exit;
      End; { Else }
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
        NextToken := BAD;
        FormulaErrType := fUnknOp;
        FormulaErrPos := Pos(Input, FormulaStr); { Calc position of error }
      End; { Case }

      Delete(Input, 1, 1);
      Exit;
    End; { Else }
end; { NextToken }


procedure TParserObj.Push(Token : TokenRec);
{ Pushes a new Token onto the stack }
begin
  if StackTop = PARSERSTACKSIZE then
  begin
    {ErrorMsg(MSGSTACKERROR);}
    TokenError := True;
  end
  else begin
    Inc(StackTop);
    Stack[StackTop] := Token;
  end;
end; { Push }


procedure TParserObj.Pop(var Token : TokenRec);
{ Pops the top Token off of the stack }
begin
  Token := Stack[StackTop];
  Dec(StackTop);
end; { Pop }


function TParserObj.GotoState(Production : Word) : Word;
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


function TParserObj.CellValue(Col, Row : Word) : Real;
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


procedure TParserObj.Shift(State : Word);
{ Shifts a Token onto the stack }
begin
  CurToken.State := State;
  Push(CurToken);
  TokenType := NextToken;
end; { Shift }


procedure TParserObj.Reduce(Reduction : Word);
  { Completes a reduction }
  var
    Token1, Token2 : TokenRec;
    Counter : Word;
  begin
    case Reduction of
      1  : begin
             Pop(Token1);
             Pop(Token2);
             Pop(Token2);
             CurToken.Value := Token1.Value + Token2.Value;
           end;
      2  : begin
             Pop(Token1);
             Pop(Token2);
             Pop(Token2);
             CurToken.Value := Token2.Value - Token1.Value;
           end;
      4  : begin
             Pop(Token1);
             Pop(Token2);
             Pop(Token2);
             CurToken.Value := Token1.Value * Token2.Value;
           end;
      5  : begin
             Pop(Token1);
             Pop(Token2);
             Pop(Token2);
             if Token1.Value = 0 then
               MathError := True
             else
               CurToken.Value := Token2.Value / Token1.Value;
           end;
      7  : begin
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
      9  : begin
             Pop(Token1);
             Pop(Token2);
             CurToken.Value := -Token1.Value;
           end;
      11 : Begin
             Pop(Token1);
             Pop(Token2);
             Pop(Token2);
             CurToken.Value := 0;
             if (Token1.Row = Token2.Row) then begin
               if (Token1.Col < Token2.Col) then
                 TokenError := True
               else begin
                 for Counter := Token2.Col to Token1.Col do
                   CurToken.Value := CurToken.Value + CellValue(Counter, Token1.Row);
               end;
             End { If }
             Else
               If (Token1.Col = Token2.Col) Then Begin
                 If (Token1.Row < Token2.Row) Then
                   TokenError := True
                 Else Begin
                   For Counter := Token2.Row to Token1.Row do
                     CurToken.Value := CurToken.Value + CellValue(Token1.Col, Counter);
                 End; { Else }
               End { If }
               Else
                 TokenError := True;
           End;
      13 : begin
             Pop(CurToken);

             {CurToken.Value := FormulaTxlate(CurToken.FuncName,TokenError); {* Get Variable link up *}
             CurToken.Value := GetFieldVal(CurToken.FuncName).DblResult;
             TokenError := FormulaErr;
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
             end
             Else If (Token1.FuncName = DocSignFunc) Then Begin
               { Sign amount by invoice detail }
               If Assigned (GetDocSignEvent) Then
                 CurToken.Value := CurToken.Value * GetDocSignEvent;
             End; { If }
           end;
      3,
      6,
      8,
      10,
      12,
      15 : Pop(CurToken);
    end; { case }
    CurToken.State := GotoState(Reduction);
    Push(CurToken);
  end; { Reduce }


Function TParserObj.Parse(S : String; var Att : Word) : Real;
  var
    FirstToken : TokenRec;
    Accepted : Boolean;
    Counter : Word;
  begin
    Accepted := False;
    TokenError := False;
    MathError := False;
    IsFormula := False;
    Input := UpperCase(S);
    StackTop := 0;
    FirstToken.State := 0;
    FirstToken.Value := 0;
    Push(FirstToken);
    TokenType := NextToken;

    repeat
      case Stack[StackTop].State of
        0, 9,
        12..16,
        20      : begin
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
                      TokenError := True;
                  end;
        1       : begin
                    if TokenType = EOL then
                      Accepted := True
                    else if TokenType = PLUS then
                      Shift(12)
                    else if TokenType = MINUS then
                      Shift(13)
                    else
                      TokenError := True;
                  end;
        2       : begin
                    if TokenType = TIMES then
                      Shift(14)
                    else if TokenType = DIVIDE then
                      Shift(15)
                    else
                      Reduce(3);
                  end;
        3       : Reduce(6);
        4       : begin
                  if TokenType = EXPO then
                    Shift(16)
                  else
                    Reduce(8);
                 end;
        5      : begin
                   if TokenType = NUM then
                     Shift(10)
                   else if TokenType = CELLT then
                     Shift(7)
                   else if TokenType = FUNC then
                     Shift(11)
                   else if TokenType = OPAREN then
                     Shift(9)
                   else
                     TokenError := True;
                 end;
        6      : Reduce(10);
        7      : begin
                   if TokenType = COLON then
                     Shift(18)
                   else
                     Reduce(13);
                 end;
        8      : Reduce(12);
        10     : Reduce(15);
        11     : begin
                   if TokenType = OPAREN then
                     Shift(20)
                   else
                     TokenError := True;
                 end;
        17     : Reduce(9);
        18     : begin
                   if TokenType = CELLT then
                     Shift(26)
                   else
                     TokenError := True;
                 end;
        19     : begin
                   if TokenType = PLUS then
                     Shift(12)
                   else if TokenType = MINUS then
                     Shift(13)
                   else if TokenType = CPAREN then
                     Shift(27)
                   else
                     TokenError := True;
                 end;
        21     : begin
                   if TokenType = TIMES then
                     Shift(14)
                   else if TokenType = DIVIDE then
                     Shift(15)
                   else
                     Reduce(1);
                 end;
        22     : begin
                   if TokenType = TIMES then
                     Shift(14)
                   else if TokenType = DIVIDE then
                     Shift(15)
                   else
                     Reduce(2);
                 end;
        23     : Reduce(4);
        24     : Reduce(5);
        25     : Reduce(7);
        26     : Reduce(11);
        27     : Reduce(14);
        28     : begin
                   if TokenType = PLUS then
                     Shift(12)
                   else if TokenType = MINUS then
                     Shift(13)
                   else if TokenType = CPAREN then
                     Shift(29)
                   else
                     TokenError := True;
                 end;
        29     : Reduce(16);
      end; { case }
    until Accepted or TokenError;

    if TokenError then begin
      Att := TXT;
      Parse := 0;
      Exit;
    end;

    if IsFormula then
      Att := FORMULA
    else
      Att := VALUE;

    if MathError then begin
      Inc(Att, 4);
      Parse := 0;
      FormulaErrType := fMathErr;
      Exit;
    end;

    Parse := Stack[StackTop].Value;
  end; { Parse }


Function TParserObj.ConcatCalc(    FStr   : String200;
                               Var IVType : Byte;
                               Var HasErr : Boolean) : String200;
  Var
    TStr, ChkStr  : String200;
    n, m          : Byte;
    IsValue       : Boolean;
    OStr          : String200;
    FormLen, _Pos : Word;
    FormName      : ShortString;
  Begin
    IVType:=0;
    IsValue:=False;
    HasErr := False;
    TStr:='';
    OStr:='';

    ChkStr:=Copy(FStr,2,Pred(Length(FStr)));

    n:=Pos('+',ChkStr);
    While (n<>0) do Begin
      ChkStr[n]:=#32;
      n:=Pos('+',ChkStr);
    end; {While..}

    m:=WordCnt(ChkStr);

    n:=1;

    While (n<=m) and (Not HasErr) do Begin
      OStr:=ExtractWords(n,1,ChkStr);

      Case OStr[1] of
        '"'  :  TStr:=TStr+Strip('B',['"'],OStr);
      Else
        { Check to see if its a database/table/formula field }
        If Is_RepVar(OStr, FormLen, FormName) Then Begin
          { Get field value as string }
          TStr := TStr + GetFieldVal(OStr).StrResult;
        End { If }
        Else Begin
          { Unknown Something }
          HasErr := True;
          FormulaErrType := fUnknown;
          FormulaErrPos := Pos(OStr, FormulaStr); { Calc position of error }
        End; { Else }
      end; {Case..}

      Inc(n);
    end; {While..}

    If (Not HasErr) Then Begin
      _Pos := Pos ('_', TStr);
      While (_Pos > 0) Do Begin
        TStr[_Pos] := ' ';
        _Pos := Pos ('_', TStr);
      End; { While }
    End; { If }

    IVType:=1;

    ConcatCalc:=TStr;
  end; {Func..}


{ Returns the value of the field as the specified type }
Function TParserObj.GetFieldVal(Const Field   : String) : ResultValueType;
Var
  CopyFrom, CopyLen : Word;

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
          Result := GetFmtDateEvent(DateCode, Units, OffUnits, Format);
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

  //------------------------------

  // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  Function CallLoadRole : ResultValueType;
  Var
    ParamInfo : ParamsType_LoadRole;
    FormLen   : Word;
    FormName  : ShortString;
  Begin // CallLoadRole
    Result.DblResult := 0.00;
    Result.StrResult := '';

    If Assigned (GetLoadRoleEvent) Then
      If ProcessLoadRole(Field, FormLen, FormName, ParamInfo) Then
        Result := GetLoadRoleEvent(ParamInfo.AccountCodeField, ParamInfo.RoleDescription);
  End; // CallLoadRole

  //------------------------------

begin
  Result.DblResult := 0.00;
  Result.StrResult := '';

  If (Not IsEvaluation) Then Begin
    { Work out what sort of field it is }
    If (Pos(DBFieldFunc, Field) = 1) Then Begin
      { Its a Database Field }
      If Assigned (GetDBFEvent) Then
        Result := GetDBFEvent (FieldParam, FormulaDecs);
    End { If }
    Else If (Pos(FormulaFunc, Field) = 1) Then Begin
      { Its a Formula field }
      If Assigned (GetFMLEvent) Then
        Result := GetFMLEvent (FieldParam, FormulaDecs);
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
    End { Else .. If }
    // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
    Else If (Pos(LoadRoleFunc, Field) = 1) Then
    Begin
      // Load Account Contact Role details
      If Assigned (GetLoadRoleEvent) Then
        Result := CallLoadRole;
    End; { Else .. If }
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

Function TParserObj.SetFormula(       Formula   : String200;
                                      NoDecs    : Byte;
                                Var   IVType    : Byte;
                                Const Evaluate  : Boolean) : String200;

  Var
    Dnum : Double;
    FErr : Word;
    TStr : String200;
    Err  : Boolean;
  Begin
    { Get rid of any spaces - as they cause problems }
    Formula := Trim(Formula);

    FormulaErrPos  := 0;
    FormulaErrType := fOK;
    FErr           := 0;
    IsEvaluation   := Evaluate;
    FormulaDecs    := NoDecs;

    If (Formula <> '') Then Begin
      Case Formula[1] of
        '"'   :  Begin
                   FormulaStr := Formula;
                   TStr:=ConcatCalc(Formula, IVType, Err);
                   If Err Then
                     FormulaErrType := fUnknown;
                 End;
        '~'   :  Begin
                   FormulaStr := Formula;
                   TStr:=Copy(Formula, 2, Pred(Length(Formula)));
                   IVType:=1;
                 end;
        else     Begin
                   FormulaStr := UpperCase(Formula);
                   Dnum:=Parse(Formula,Ferr);

                   If (Ferr In [1,2,6]) then Begin
                     { reformat field into what it should look like }
                     {TStr:=Form_Real(Dnum,0,NoDecs);}
                     TStr := Trim(FormatFloat (FormatDecStrSD (NoDecs, GenRealMask, BOff), DNum));
                   End { If }
                   Else Begin
                     TStr:=ErrStr;

                     { Check were not overwriting a specific error }
                     If (FormulaErrType = fOK) Then
                       FormulaErrType := fUnknown;
                   End; { Else }
                 End;
      end; {Case..}
    End { If }
    Else Begin
      { Formula cannot be blank }
      TStr:=ErrStr;
      FormulaErrType := fBlank;
    End; { If }

    SetFormula:=TStr;
  end; {Func..}

{ Returns True if an error has occured }
Function TParserObj.FormulaErr : Boolean;
  Begin
    Result := (FormulaErrType <> fOk);
  End;

{ Returns a string explaining the error }
Function TParserObj.FormulaErrStr : String;
  Begin
    Result := '';

    If FormulaErr Then Begin
      Case FormulaErrType Of
        fBlank     : Result := 'The formula cannot be left blank';
        fNoParam   : Result := 'No parameters could be found';
        fNoBracket : Result := 'No matching bracket '']'' could be found';
        fNoSquare  : Result := 'The substring specification is incorrect';
        fUnknCmd   : Result := 'An invalid function was found';
        fUnknOp    : Result := 'An invalid symbol was found';
        fMathErr   : Result := 'A maths error was found';
        fInvStruct : Result := 'The expression has an invalid structure';
        fInvParam  : Result := 'The function has an invalid parameter';
      Else
        Result := 'The formula is not valid';
      End; { Case }
    End; { If }
  End;


{*********************************************************************************}
{** functions from this point on are for boolean evaluations                    **}
{*********************************************************************************}
function tparserobj.evaluate_expression (      Expression : String200;
                                         Const Evaluate   : Boolean)  :  boolean;
var
  totwords, wordpos, operand : byte;
  tmpbo, abort               : boolean;
  nextword                   : str20;

  function getoperand(opo : str5)  :  byte;
  const
    noc  =  6;
    compare  :  array[1..noc] of string[2] = ('<','>','<=','>=','<>','=');
  var
    n        :  byte;
    foundok  :  boolean;
  begin
    n:=1;

    foundok:=false;

    while (n<=noc) and (not foundok) do begin
      foundok:=checkkey(opo,compare[n],length(opo),false);

      if (not foundok) then
        inc(n);
    end; { while }

    if (foundok) then
      getoperand:=n
    else
      getoperand:=0;
  end; {func..}

  function process_bodmas(    brackstr : str100;
                          var wpos     : byte)  :  str100;
  var
    totpos, nopos, brackcount  : byte;
    abort    :  boolean;
    nextword :  str20;
    tmpstr   :  str100;

    function countbracket(bstr  :  str20)  :  integer;
    var
      n,bp  :  integer;
    begin
      n:=0;

      bp:=pos('(',bstr);

      if (bp=0) then
        bp:=pos(')',bstr);

      while (bp<>0) do begin
        n:=n+(ord(bstr[bp]='(')-ord(bstr[bp]=')'));

        delete(bstr,bp,1);

        bp:=pos('(',bstr);

        if (bp=0) then
         bp:=pos(')',bstr);
      end; { while }

      countbracket:=n;
    end; { countbracket }

  begin
    nopos:=1;
    abort:=false;
    brackcount:=1;
    nextword:='';
    tmpstr:='';

    totpos:=wordcnt(brackstr);

    while (nopos<totpos) and (not abort) do begin
      nextword:=extractwords(nopos,1,brackstr);

      brackcount:=brackcount+countbracket(nextword);

      abort:=(brackcount=1);

      if (not abort) then
        inc(nopos);
    end; { while }

    If Not Abort Then
      FormulaErrType := fUnknown;

    if (abort) then begin
      tmpstr:=extractwords(1,nopos,brackstr);

      process_bodmas:=copy(tmpstr,2,length(tmpstr)-2);

      wpos:=wpos+nopos;
    end { if }
    else
      process_bodmas:=copy(brackstr,2,length(brackstr)-2);
  end; {func..}

  function evalvar(    evalex  : str80;
                   var isvalue : boolean) : str80;
  var
    tmps        : str80;
    el          : byte;
    formlen     : word;
    formname    : shortstring;
    weirdresult : resultvaluetype;
  begin
    tmps:='';
    isvalue:=false;
    el:=length(evalex);
    isvalue:=false;

    if (el>0) then begin
      case evalex[1] of
        '"'           :  TmpS:=strip('b',['"'],evalex);
        '0'..'9', '-' : begin
                          TmpS:=form_real(realstr(evalex),0,10);
                          isvalue:=true;
                        end;
      Else
        If Is_RepVar(EvalEx, FormLen, FormName) then begin
          WeirdResult := GetFieldVal(FormName);

          if (WeirdResult.DblResult = 0.0) then
            TmpS := WeirdResult.StrResult
          else
            TmpS := FloatToStr(WeirdResult.DblResult);
        End { if }
        Else
          { Unknown operation }
          FormulaErrType := fUnknOp;
      end; { case }
    end; { if }

    Result := upcasestr(tmps);
  end;

  (*
  function padwcard(fstr  :  str20;
                    fl,sl :  byte)  :  str20;
  var
    tmpstr, reststr  :  str20;
  begin
    tmpstr:=fstr;

    if (fstr[1]=wildcha) then begin
      reststr:=copy(fstr,2,pred(fl));

      tmpstr:=ljvar(conststr(wildchq,sl-length(reststr))+reststr,sl);
    end { if }
    else begin
      if (fstr[fl]=wildcha) then begin
        reststr:=copy(fstr,1,pred(fl));

        tmpstr:=ljvar(reststr+conststr(wildchq,sl-length(reststr)),sl);
      end; { if }
    end; { Else }

    padwcard:=fstr;
  end; {func..}

  function match_wildchar(wstr, fstr : str255;
                          asis       : boolean) : boolean;
  var
    sl, n, wsl : byte;
    fok        : boolean;
  begin
    sl:=length(fstr);
    wsl:=length(wstr);

    if (pos(wildcha,fstr)<>0) then {* contains a wild card *}
      fstr:=padwcard(fstr,sl,wsl);

    sl:=length(fstr);

    if (sl>wsl) then   {* set to shortest length *}
      sl:=wsl;

    if (not asis) then begin
      wstr:=upcasestr(wstr);
      fstr:=upcasestr(fstr);
    end;

    fok:=(((wsl<>0) and (fstr<>'')) or ((wstr='') and (fstr='')));

    n:=1;

    while (n<=sl) and fok do begin
      fok:=((wstr[n]=fstr[n]) or (fstr[n] in wildchars));

      inc(n);
    end; { while }

    match_wildchar:=fok;
  end; { match_wildchar }
  *)

  { function to return conditional comparison }
  function comparestr(cond1,
                      cond2   :  str80;
                      operand :  byte)  :  boolean;
  var
    tmpbo  :  boolean;
  begin
    {$b-}

    (* MH 19/06/97 : Removed the Wild Card Checking as it was causing a range check
                     error for Heinz, and because it is not required in the card system
                     and may screw up some of the Print If checks.
    tmpbo:=(((cond1<cond2) and (operand=1)) or
            ((cond1>cond2) and (operand=2)) or
            ((cond1<=cond2) and (operand=3)) or
            ((cond1>=cond2) and (operand=4)) or
            ((not match_wildchar(cond1,cond2,false)) and (operand=5)) or
            ((match_wildchar(cond1,cond2,false)) and (operand=6)));
    *)

    tmpbo:=(((cond1<cond2) and (operand=1)) or
            ((cond1>cond2) and (operand=2)) or
            ((cond1<=cond2) and (operand=3)) or
            ((cond1>=cond2) and (operand=4)) or
            ((cond1<>cond2) and (operand=5)) or
            ((cond1=cond2) and (operand=6)));

    comparestr:=tmpbo;
    {$b+}
  end; {func..}


  { function to return conditional comparison }
  function comparenum(cond1,
                      cond2   :  double;
                      operand :  byte)  :  boolean;
  var
    tmpbo  :  boolean;
  begin
    {$b-}
    tmpbo:=(((cond1<cond2) and (operand=1)) or
            ((cond1>cond2) and (operand=2)) or
            ((cond1<=cond2) and (operand=3)) or
            ((cond1>=cond2) and (operand=4)) or
            ((cond1<>cond2) and (operand=5)) or
            ((cond1=cond2) and (operand=6)));

    comparenum:=tmpbo;
    {$b+}
  end; {func..}

  function evalcond(    stam   : str100;
                    var wpos   : byte) : boolean;
  var
    cond1, cond2                                 :  str80;
    dcond1, dcond2                               :  double;
    operand                                      :  byte;
    tmpbo, isvalue1, isvalue2, haserr1, haserr2  : boolean;
  begin
    isvalue1:=false;
    isvalue2:=false;

    cond1:=evalvar(extractwords(1,1,stam),isvalue1);
    cond2:=evalvar(extractwords(3,1,stam),isvalue2);

    Try
      If ValidNum(Cond1) Then DCond1:=RealStr(Cond1) Else DCond1 := 0;
      If ValidNum(Cond2) Then DCond2:=RealStr(Cond2) Else DCond2 := 0;

      operand:=getoperand(extractwords(2,1,stam));

      if (isvalue1) or (isvalue2) then
        tmpbo:=comparenum(dcond1,dcond2,operand)
      else
        tmpbo:=comparestr(cond1,cond2,operand);

      wpos:=wpos+3;
    Except
      TmpBo := False;
    End;

    evalcond:=tmpbo;
  end; { evalcond }

  function getlogic(opo : str5) : byte;
  const
    noc  =  2;
    compare  :  array[1..noc] of string[3] = ('and','or');
  var
    n        :  byte;
    foundok  :  boolean;
  begin
    n:=1;
    foundok:=false;

    while (n<=noc) and (not foundok) do begin
      foundok:=checkkey(opo,compare[n],length(opo),false);

      if (not foundok) then
        inc(n);
    end;

    if (foundok) then
      getlogic:=n
    else
      getlogic:=0;
  end; { getlogic }

begin { evaluate_expression }
  nextword:='';

  expression:=strip('b',[#32],UpperCase(Expression));
  FormulaStr := Expression;
  FormulaErrPos  := 0;
  FormulaErrType := fOK;
  IsEvaluation   := Evaluate;
  FormulaDecs    := 12;

  { Check for blank - blank = true }
  If (Trim(Expression) <> '') Then Begin
    TotWords := WordCnt(Expression);

    If ((TotWords Mod 2) <> 0) Then Begin
      { Got odd number of words }
      WordPos:=1;
      if (expression[1]='(') then
        tmpbo:=evaluate_expression(process_bodmas(Expression,WordPos), Evaluate)
      else
        tmpbo:=evalcond(extractwords(wordpos,3,expression),wordpos);

      Abort := false;
      While (FormulaErrType = fOK) And (WordPos < totwords) And (Not abort) Do Begin
        {* next element should be a logic condition *}
        operand:=getlogic(extractwords(wordpos,1,expression));

        inc(wordpos);

        abort:=((operand=0) or ((not tmpbo) and (operand=1))
              or ((tmpbo) and (operand=2)) or (wordpos>totwords));

        if (not abort) then begin
          nextword:=extractwords(wordpos,1,expression);

          if (nextword[1]='(') then
            tmpbo:=evaluate_expression(process_bodmas(extractwords(wordpos,succ(totwords-wordpos),expression),
                                       wordpos), Evaluate)
          else
            tmpbo:=evalcond(extractwords(wordpos,3,expression),wordpos);
        end;
      end; { while }
    End { if }
    Else Begin
      { Wrong number of words }
      FormulaErrType := fInvStruct;
    End; { If }

    Result := TmpBo And (FormulaErrType = fOk);
  End { If }
  Else
    { Blank is AOK }
    Result := True;
end; { evaluate_expression }


Initialization
Finalization
end.
