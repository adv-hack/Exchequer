
{ Copyright (c) 1985, 88 by Borland International, Inc. }

unit MCPARSER;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  GlobVar,
  VarConst,
  VarFPosU,
  MCVars,
  MCUtil,
  ETMiscU,
  DicLnk2U,
  RepObj2U,
  RepObjIU;



{ Parses the string s - returns the Value of the evaluated string, and puts
   the attribute in Att: TXT = 0, CONSTANT = 1, FORMULA = 2, +4 = ERROR.
}

Const
  On  = True;
  Off = False;

Type

  RepLinePtr   =  ^RepLineRObj;


  RepLineRObj  =  Object(List)

                    CurrNode  :  NodePtr;
                    RepField  :  RepFieldPtr ;
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

                    SortList  :  Array[0..MaxNoSort] of LongInt;
                    BreakList :  Array[0..MaxNoSort] of LongInt;


                    Constructor Init(RunName  :  Str10);

                    Destructor Done;

                    Procedure InitRepFObj(Fnum,
                                          Keypath  :  Integer);

                    Function FindObj(VarNo  :  LongInt)  :  Boolean;

                    Function GetOperand(Opo  :  Str5)  :  Byte;

                    Function SelectTxlate(FStr     :  Str80;
                                      Var IsValue,
                                          HasErr   :  Boolean)  :  Str80;

                    Function EvalVar(EvalEx  :  Str80;
                                 Var IsValue,
                                     HasErr  :  Boolean)  :  Str80;

                    Function EvalCond(StaM  :  Str100;
                                  Var WPos  :  Byte;
                                      HasErr:  Byte)  :  Boolean;

                    Function GetLogic(Opo  :  Str5)  :  Byte;

                    Function CountBracket(BStr  :  Str20)  :  Integer;

                    Function Process_BODMAS(BrackStr  :  Str100;
                                        Var WPos,
                                            Error     :  Byte)  :  Str100;

                    Function Evaluate_Expression(Expression  :  Str100;
                                                 Var Error       :  Byte)  :  Boolean;

                    Function ConcatCalc(FStr   :  Str100;
                                    Var IVType :  Byte;
                                    Var HasErr :  Boolean)  :  Str100;

                    Function FormulaTxlate(FStr   :  Str80;
                                       Var HasErr :  Boolean)  :  Double;

                    procedure Reduce(Reduction : Word);

                    function Parse(S : String; var Att : Word) : Real;

                    Function SetFormula(Formula  :  Str100;
                                        NoDecs   :  Byte;
                                    Var IVType   :  Byte)  :  Str80;

                    Function LinkObj(VarNo  :  LongInt;
                                 Var DLinkR :  DictLinkType)  :  Str255;


                    Procedure FillObject(Var SelectOk  :  Boolean);

                    Function FillHeader  :  Str255;

                    Function FillLine  :  Str255;

                    Function FillTULine(FinLine  :  Boolean)  :  Str255;

                    Procedure ReCalcBreaks(BTNo      :  Byte;
                                       Var RepFRec   :  RepFieldType);

                    Function FillTotal(BTNo     :  Byte;
                                       ShowBrk  :  Boolean)  :  Str255;

                    Function FillSummary(BTNo  :  Byte;
                                         RepLF :  Boolean)  :  Str255;

                    Function FullSortKey  :  Str255;

                    Procedure LineTotals(Mode,
                                         BTNo  :  Byte);

                    Function IncInSumm(BTNo  :  Byte)  :  Boolean;

                    Procedure ReduceBreak(BTNo  :  Byte);

                    Function FillCDFLine :  Str255;

                    Function FillNomTotLine(SubsBlnk  :  Boolean) :  Str255;


                  end; {Object}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
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
   RpCommon,
   ComnUnit,
   ComnU2,
   SysU1,
   DicLinkU;




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
  MAXFUNCNAMELEN = 5;

type
  TokenRec = record
    State : Byte;
    case Byte of
      0 : (Value : Real);
      1 : (Row, Col : Word);
      2 : (FuncName : String[MAXFUNCNAMELEN]);
  end;

var
  Stack : array [1..PARSERSTACKSIZE] of TokenRec;
  CurToken : TokenRec;
  StackTop, TokenType : Word;
  MathError, TokenError, IsFormula : Boolean;
  Input : IString;

function IsFunc(S : String) : Boolean;
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



Function Is_RepVar(RepStr   :  String;
               Var FormLen  :  Word;
               Var FormName :  ShortString)  :  Boolean;
Var
  TmpBo,
  FoundOk :  Boolean;
  CPos,
  Rl      :  Byte;
Begin
  FoundOk:=FALSE;

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

  Is_RepVar:=TmpBo;


end; {Func..}

function NextToken : Word;
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
         IsFunc('TRUNC') then
      begin
        NextToken := FUNC;
        Exit;
      end;

      {* Check for report variable here *}
      if Is_RepVar(Input, FormLen, CurToken.FuncName) then begin

        Delete(Input, 1, FormLen);
        IsFormula := True;
        NextToken := CELLT;
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
        NextToken := BAD;
      End; { Case }

      Delete(Input, 1, 1);
      Exit;
    End; { Else }
end; { NextToken }

procedure Push(Token : TokenRec);
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

procedure Shift(State : Word);
{ Shifts a Token onto the stack }
begin
  CurToken.State := State;
  Push(CurToken);
  TokenType := NextToken;
end; { Shift }






  { ---------------------------------------------------------------- }

  {  RepLine Methods }

  { ---------------------------------------------------------------- }


  Constructor RepLineRObj.Init(RunName  :  Str10);

  Begin

    List.Init;

    CurrNode:=GetFirst;

    RepLName:=RunName;

    NoTBreaks:=0;

    FirstGo:=On;

    TBreakFound:=0;

    FmulaBreak:=0;

    SummOn:=Off;

    BreakMode:=0;

    CalcBreak:=Off;

    FmulaErr:=Off;

    SelErr:=On;

    RunNomCtrl:=Off;

    Blank(SortList,Sizeof(SortList));

    Blank(BreakList,Sizeof(BreakList));

    New(InpObj,Init(RunName));

    InpObj^.InitInpFObj(RepGenF,RGK);

  end; {Constructor..}


  {* ------------------------ *}


  Destructor RepLineRObj.Done;

  Begin

    CurrNode:=GetFirst;

    While (CurrNode<>NIL) do
    Begin
      RepField:=CurrNode^.LItem;

      Dispose(RepField,Done);

      CurrNode:=GetNext(CurrNode);
    end; {Loop..}

    List.Done;

    Dispose(InpObj,Done);

  end; {Destructor..}


  {* ------------------------ *}


  Procedure RepLineRObj.InitRepFObj(Fnum,
                                    Keypath  :  Integer);


  Var
    KeyS,
    KeyChk,
    KeyV    :  Str255;

    SortVal :  Byte;


  Begin

    KeyV:='';

    SortVal:=0;

    KeyChk:=FullRepKey(ReportGenCode,RepRepCode,RepLName)+RepRepCode;

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);

    CurrNode:=GetFirst;

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),Off)) do
    With RepGenRecs^ do
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
          GetDictVar(KeyV,KeyV,-1);

          If (Ok) then
            RepDict:=DictRec^.DataVarRec;

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
          If (PrSel) then {* Calculate correct period *}
          Begin
            With DLink do
              Calc_PrYr(RepLPr[Off],RepLPr[On],DPr,DYr);

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

      Status:=Find_Rec(B_GetNext,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);

    end; {While..}

  end;{Proc..}


  {* ------------------------ *}


  Function RepLineRObj.FindObj(VarNo  :  LongInt)  :  Boolean;

  Var
    FoundOk  :  Boolean;


  Begin

    CurrNode:=GetFirst;

    FoundOk:=Off;

    While (CurrNode<>NIL) and (Not FoundOk) and (VarNo<>0) do
    Begin

      RepField:=CurrNode^.LItem;

      FoundOk:=(VarNo=RepField^.RepFieldRec^.RepDet.RepVarNo);

      If (Not FoundOk) then
        CurrNode:=GetNext(CurrNode);

    end; {While..}


    FindObj:=FoundOk;

  end; {Func..}


  { ================ Report Generator Selection Logic Analysis ============ }




  Function RepLineRObj.GetOperand(Opo  :  Str5)  :  Byte;

  Const
    NoC  =  6;

    Compare  :  Array[1..NoC] of String[2] = ('<','>','<=','>=','<>','=');



  Var
    n        :  Byte;

    FoundOk  :  Boolean;



  Begin

    n:=1;

    FoundOk:=Off;

    While (n<=NoC) and (Not FoundOk) do
    Begin

      FoundOk:=CheckKey(Opo,Compare[n],Length(Opo),Off);

      If (Not FoundOk) then
        Inc(n);

    end;

    If (FoundOk) then
      GetOperand:=n
    else
      GetOperand:=0;

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


  Begin

    TStr:='';

    Dnum:=0;

    VarMAtch:=0;

    IsValue:=Off;

    IVType:=0;

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
            Dnum:=RepField^.GetValue(On);

          TStr:=Form_Real(Dnum,1,10);

          IsValue:=On;
        end
        else
        Begin
          TStr:=GetStr(Off);

          If (SubSubNo<>0) then
            TStr:=Copy(TStr,SubNo,SubSubNo);
        end;

    end
    else
    Begin

      TStr:=InpObj^.GetInpField(FStr,IVType,HasErr);

      IsValue:=(IVType In ITypValSet);

    end;

    SelectTxlate:=TStr;

  end; {Func..}


  {* ------------------------ *}



  Function RepLineRObj.EvalVar(EvalEx  :  Str80;
                           Var IsValue,
                               HasErr  :  Boolean)  :  Str80;

  Var
    TmpS  :  Str80;
    El    :  Byte;


  Begin

    TmpS:='';

    IsValue:=Off;

    El:=Length(EvalEx);

    IsValue:=Off;

    If (El>0) then
    Begin

      Case EvalEx[1] of

        '"'  :  TmpS:=Strip('B',['"'],EvalEx);

        '0'..'9','-'
             :  Begin
                  TmpS:=Form_Real(RealStr(EvalEx),0,10);
                  IsValue:=On;
                end;

        RepRepCode,RepInpCode
             :  TmpS:=SelectTxlate(EvalEx,IsValue,HasErr); {* Get variable *}

        else    HasErr:=On;

      end; {Case..}

    end;

    EvalVar:=UpCaseStr(TmpS);

  end;


  {* ------------------------ *}


  Function RepLineRObj.EvalCond(StaM  :  Str100;
                            Var WPos  :  Byte;
                                HasErr:  Byte)  :  Boolean;


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

    IsValue1:=Off;
    IsValue2:=Off;

    HasErr1:=Off;
    HasErr2:=Off;

    Cond1:=EvalVar(ExtractWords(1,1,StaM),IsValue1,HasErr1);
    Cond2:=EvalVar(ExtractWords(3,1,StaM),IsValue2,HasErr2);

    DCond1:=RealStr(Cond1);
    DCond2:=RealStr(Cond2);


    Operand:=GetOperand(ExtractWords(2,1,StaM));

    If (IsValue1) or (IsValue2) then
      TmpBo:=CompareNum(DCond1,DCond2,Operand)
    else
      TmpBo:=CompareStr(Cond1,Cond2,Operand);


    Wpos:=WPos+3;

    EvalCond:=TmpBo;

    HasErr:=(Ord(HasErr1) + Ord(HasErr2));

  end; {Func..}


  {* ------------------------ *}

  Function RepLineRObj.GetLogic(Opo  :  Str5)  :  Byte;

  Const
    NoC  =  2;

    Compare  :  Array[1..NoC] of String[3] = ('AND','OR');



  Var
    n        :  Byte;

    FoundOk  :  Boolean;



  Begin

    n:=1;

    FoundOk:=Off;

    While (n<=NoC) and (Not FoundOk) do
    Begin

      FoundOk:=CheckKey(Opo,Compare[n],Length(Opo),Off);

      If (Not FoundOk) then
        Inc(n);

    end;

    If (FoundOk) then
      GetLogic:=n
    else
      GetLogic:=0;

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

  Function RepLineRObj.Process_BODMAS(BrackStr  :  Str100;
                                  Var WPos,
                                      Error     :  Byte)  :  Str100;



  Var
    TotPos,
    NoPos,
    BrackCount
             :  Byte;

    Abort    :  Boolean;

    NextWord :  Str20;

    TmpStr   :  Str100;



  Begin

    NoPos:=1;  Abort:=Off;

    BrackCount:=1;

    Error:=0;

    NextWord:=''; TmpStr:='';

    TotPos:=WordCnt(BrackStr);

    While (NoPos<TotPos) and (Not Abort) do
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

  Function RepLineRObj.Evaluate_Expression(Expression  :  Str100;
                                       Var Error       :  Byte)  :  Boolean;



  Var
    TotWords,
    WordPos,
    Operand   :  Byte;

    TmpBo,
    Abort     :  Boolean;

    NextWord  :  Str20;


  Begin

    Error:=0;

    WordPos:=1;


    Abort:=Off;

    NextWord:='';

    Expression:=Strip('B',[#32],Expression);

    TmpBo:=(Expression='');

    TotWords:=WordCnt(Expression);

    Error:=Ord((TotWords Mod 2)=0);

    If (Error=0) and (Not TmpBo) then
    Begin

      If (Expression[1]='(') then
        TmpBo:=Evaluate_Expression(Process_BODMAS(Expression,WordPos,Error),Error)
      else
        TmpBo:=EvalCond(ExtractWords(WordPos,3,Expression),WordPos,Error);

      While (Error=0) and (WordPos<TotWords) and (Not Abort) do
      Begin

        {* Next element should be a logic condition *}

        Operand:=GetLogic(ExtractWords(WordPos,1,Expression));

        Inc(WordPos);

        Abort:=((Operand=0) or ((Not TmpBo) and (Operand=1))
              or ((TmpBo) and (Operand=2)) or (WordPos>TotWords));

        If (Not Abort) then
        Begin

          NextWord:=ExtractWords(WordPos,1,Expression);

          If (NextWord[1]='(') then
            TmpBo:=Evaluate_Expression(Process_BODMAS(ExtractWords(WordPos,Succ(TotWords-WordPos),Expression),
                                       WordPos,Error),Error)
          else
            TmpBo:=EvalCond(ExtractWords(WordPos,3,Expression),WordPos,Error);

        end;

      end; {While..}

    end; {If Error fail..}

    Evaluate_Expression:=TmpBo;

    SelErr:=((Error<>0) and (Not TmpBo));

  end; {Func..}



  {* ------------------------ *}


  Function RepLineRObj.ConcatCalc(FStr   :  Str100;
                              Var IVType :  Byte;
                              Var HasErr :  Boolean)  :  Str100;

  Var
    TStr,
    ChkStr  :  Str100;

    n,m     :  Byte;

    IsValue :  Boolean;

    OStr    :  Str30;



  Begin

    IVType:=0;

    IsValue:=Off;

    TStr:='';

    OStr:='';

    ChkStr:=Copy(FStr,2,Pred(Length(FStr)));

    n:=Pos('+',ChkStr);

    While (n<>0) do
    Begin

      ChkStr[n]:=#32;

      n:=Pos('+',ChkStr);

    end; {While..}

    m:=WordCnt(ChkStr);

    n:=1;

    While (n<=m) and (Not HasErr) do
    Begin

      OStr:=ExtractWords(n,1,ChkStr);

      Case OStr[1] of

        RepRepCode,
        RepInpCode  :  TStr:=TStr+SelectTxlate(OStr,IsValue,HasErr);

        '"'         :  TStr:=TStr+Strip('B',['"'],OStr);

        else           HasErr:=On;

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

    Gd,Gm,Gy  :  Integer;

    TStr      :  Str255;

    SubNo,
    SubSubNo,
    IVType    :  Byte;


  Begin

    Dnum:=0;

    IVType:=0;

    VarMAtch:=0;

    TStr:='';

    Gd:=0; Gm:=0; Gy:=0;

    If (FStr[1]=RepRepCode) then
    Begin

      VarMatch:=Sub_SplitFmula(FStr,SubNo,SubSubNo,HasErr);

      If (FindObj(VarMatch)) and (Not HasErr) then
      With RepField^ do
        If (RepFieldRec^.RepDict.VarType In ITypValSet+[4]) then  {* Include numeric variables & Dates *}
        Begin

          If (CalcBreak) then
            Dnum:=RepField^.GetFieldTotal(FmulaBreak)
          else
            Dnum:=RepField^.GetValue(On);

        end
        else
          HasErr:=On;

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

    FormulaTxlate:=Dnum;

  end; {Func..}




  procedure RepLineRObj.Reduce(Reduction : Word);

  { Completes a reduction }
  var
    Token1, Token2 : TokenRec;
    Counter : Word;
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
        else
          CurToken.Value := Token2.Value / Token1.Value;
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

             CurToken.Value := FormulaTxlate(CurToken.FuncName,TokenError); {* Get Variable link up *}


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
    CurToken.State := GotoState(Reduction);
    Push(CurToken);
  end; { Reduce }




  function RepLineRObj.Parse(S : String; var Att : Word) : Real;

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
            TokenError := True;
        end;
        1 : begin
          if TokenType = EOL then
            Accepted := True
          else if TokenType = PLUS then
            Shift(12)
          else if TokenType = MINUS then
            Shift(13)
          else
            TokenError := True;
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
            TokenError := True;
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
            TokenError := True;
        end;
        17 : Reduce(9);
        18 : begin
          if TokenType = CELLT then
            Shift(26)
          else
            TokenError := True;
        end;
        19 : begin
          if TokenType = PLUS then
            Shift(12)
          else if TokenType = MINUS then
            Shift(13)
          else if TokenType = CPAREN then
            Shift(27)
          else
            TokenError := True;
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
            TokenError := True;
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
  end; { Parse }


  {* ------------------------ *}


  Function RepLineRObj.SetFormula(Formula  :  Str100;
                                  NoDecs   :  Byte;
                              Var IVType   :  Byte)  :  Str80;

  Var
    Dnum  :  Double;
    FErr  :  Word;

    TStr  :  Str80;


  Begin

    FErr:=0;

    Case Formula[1] of

      '"'   :  TStr:=ConcatCalc(Formula,IVType,FmulaErr);
      '~'   :  Begin
                 TStr:=Copy(Formula,2,Pred(Length(Formula)));
                 IVType:=1;
               end;
      else     Begin
                 Dnum:=Parse(Formula,Ferr);

                 If (Ferr In [1,2,6]) then
                   TStr:=Form_Real(Dnum,0,NoDecs)
                 else
                   TStr:=ErrStr;

                 FmulaErr:=(Not (FErr In [1,2,6]));

               end;
    end; {Case..}

    SetFormula:=TStr;

  end; {Func..}




  {* ------------------------ *}


  Function RepLineRObj.LinkObj(VarNo  :  LongInt;
                           Var DLinkR :  DictLinkType)  :  Str255;

  Begin

    LinkObj:=Link_Dict(VarNo,DLinkR);

  end; {Func..}


  {* ------------------------ *}


  Procedure RepLineRObj.FillObject(Var SelectOk  :  Boolean);

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    CheckSelect,
    Abort,
    PrSelChk   :  Boolean;

    TStr       :  Str255;

    FErr,
    LastBrk,n  :  Byte;

  Begin
    CheckSelect:=SelectOk;

    FErr:=0;

    LastBrk:=0;

    n:=0;

    TStr:='';

    PrSelChk:=Off;

    Abort:=Off;

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) and (Not Abort) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      Begin

        With RepFieldRec^ do
        Begin

          If (RepDet.CalcField) then
            With RepDet do       {* Note 10 dec places set here
                                    as otherwise calculated fields
                                    could contain rounding errors *}
              TStr:=SetFormula(VarSubSplit,10,RepDict.VarType)
          else
            With RepDict do  {* Check for formula *}
              TStr:=LinkObj(VarNo,DLink);

         end; {With..}

         SetValue(TStr,(Not CheckSelect));

        With RepFieldRec^ do
          If (CheckSelect) then
          Begin
            {Place record test here}

            SelectOk:=Evaluate_Expression(RepDet.RecSelect,FErr);

            Abort:=Not SelectOk;

            If (FmulaErr) then
            Begin

              Warn_ValErr(RepDet.RepPadNo,RepDet.VarSubSplit);

              Abort:=On;

            end
            else
              If (SelErr) then
              Begin

                Warn_ValErr(RepDet.RepPadNo,RepDet.RecSelect);

                Abort:=On;

              end
              else
              Begin

                PrSelChk:=Evaluate_Expression(RepDet.PrintSelect,FErr);

                If (SelErr) then
                Begin

                  Warn_ValErr(RepDet.RepPadNo,RepDet.PrintSelect);

                  Abort:=On;

                end;

              end;

          end
          else
          Begin

            SelectOk:=(Evaluate_Expression(RepDet.PrintSelect,FErr) or (RepDet.ApplyPSumm));

            If (Not SelectOk) then {* Reset Print Value *}
              SetValue('',Off);

            If (BreakFound) and (SelectOk) then
            Begin

              Inc(TBreakFound);

              With RepDet do
              Begin
                LastBrk:=IntStr(SortOrd[1]);

                BreakList[LastBrk]:=RepVarNo;

                With GroupRepRec.ReportHed do {* Master flag to indicate break has ocurred *}
                  If (LastBrk<CurrBreak) or (CurrBreak=0) then
                    CurrBreak:=LastBrk;

                {* Force higher levels to break as well, in case their data has not changed *}

                For n:=Succ(LastBrk) to NoTBreaks do
                  If (SortList[n]<>0) and (BreakList[n]=0) then
                    BreakList[n]:=RepVarNo;


              end;

            end;

          end;

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
    OffStr     :  Str80;


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

        SetEffect(OnStr,OffStr,RepFieldRec^.RepDet.PrintEff);

        HStr:=HStr+OnStr+SpStr+FillHead+OffStr;
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
    OffStr     :  Str80;


  Begin

    HStr:=''; TStr:='';  SpStr:='';

    OnStr:=''; OffStr:='';  AutoBlnk:=Off;

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

        With RepFieldRec^ do
          AutoBlnk:=(((RepDet.Break In [3,4]) or (RepDet.Format='K')) and (LastValue=ThisValue));

          {* Note if using Breakmode which is a global you need to check for one less than
             the normal break mode *}




        TStr:=OnStr+SpStr+FillField(AutoBlnk)+OffStr;

        HStr:=HStr+TStr;
      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillLine:=HStr;

  end; {Func..}


{* ------------------------ *}


  Function RepLineRObj.FillTULine(FinLine  :  Boolean)  :  Str255;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr,TStr
               :  Str255;

    OnStr,
    OffStr     :  Str80;



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

  Begin

    FErr:=0;

    With RepFRec do
      If (RepDet.CalcField) and (RepDet.ReCalcBTot) then {* Reapply formula to Total values *}
      Begin
        CalcBreak:=On;

        FmulaBreak:=BTNo;

        FieldTot[BTNo]:=Parse(RepDet.VarSubSplit,FErr);

        CalcBreak:=Off;
      end;

  end;


{* ------------------------ *}


  Function RepLineRObj.FillTotal(BTNo     :  Byte;
                                 ShowBrk  :  Boolean)  :  Str255;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr       :  Str255;

    OnStr,
    OffStr     :  Str80;



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

          If (HStr<>'') then
            SpStr:=' ';

          SetEffect(OnStr,OffStr,RepFieldRec^.RepDet.PrintEff);

          HStr:=HStr+OnStr+SpStr+GetTotal(BTNo,Off,ShowBrk)+OffStr;

        end; {If Print var..}

      end; {With..}
      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillTotal:=HStr;

  end; {Func..}



  {* ------------------------ *}


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
              TStr:=GetTotal(BTNo,Off,On)
            else
              TStr:=FillLastField;


            HStr:=HStr+OnStr+SpStr+TStr+OffStr;

          end; {If Print var..}

      end; {With..}
      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillSummary:=HStr;

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

    SubTOn:=Off;

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

            2  :  SetValue('',Off);

          end; {Case..}

        end; {With..}

      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    CalcBreak:=Off;

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

    CalcBreak:=On;

    FmulaBreak:=BTNo;

    TmpBo:=On;


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


  Function RepLineRObj.FillCDFLine :  Str255;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr       :  Str255;



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



  Function RepLineRObj.FillNomTotLine(SubsBlnk  :  Boolean) :  Str255;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    SpStr      :  Str5;

    HStr       :  Str255;

    OnStr,
    OffStr,
    NomStr     :  Str80;



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
              NomStr:=FillField(On)
            else
              NomStr:=GetTotal(MaxNoSort,On,Off);
          end
          else
            NomStr:=FillField(Off);

          HStr:=HStr+OnStr+SpStr+NomStr+OffStr;

        end; {If Print var..}

      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillNomTotLine:=HStr;

  end; {Func..}



{* ------------------------ *}





end.
