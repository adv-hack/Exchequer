unit mcfuncs;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  GlobVar,
  VarConst,
  VarFPosU;


Type
  ParamsType = Record
    DateCode : String;
    Units    : SmallInt;
    OffUnits : Char;
    Format   : SmallInt;
  End; { ParamsType }

  ResultValueType = Record
    StrResult     : String;
    DblResult     : Double;
  End; { ResultValueType }



Function IsCurrFunc (Const FStr : String) : Boolean;

Function ProcessRateFunc(    RepStr   : String;
                         Var FormLen  : Word;
                         Var FormName : ShortString;
                         Var ParInfo  : ParamsType)  :  Boolean;

Function GetCurrVal (Const ParInfo : ParamsType; Const RepDrive, OrigFile : SmallInt) : ResultValueType;



implementation


Uses ETDAteU, ETStrU, ETMiscU, RWOpenF, GlobType, BtrvU2, BTSupU1, DicLinkU,
     DicLnk2U, VarRec2U;


Const
  { Currency & Rate functions }
  RateCompFunc     = 'RTCOMP';     { Company Rate }
  RateDayFunc      = 'RTDAILY';    { Daily Rate }
  RateFloatFunc    = 'RTFLOAT';    { Floater Rate }
  CcyNameFunc      = 'CCYNAME';    { Currency Name }
  CcySymbFunc      = 'CCYSYMB';    { Currency Print Symbol }

  { HM 28/09/99: Additional functions to support v4.31 extended currency table }
  CcyAgeFunc       = 'CCYAGE';     { Currency Ageing }
  RateInvFunc      = 'RTINVRT';    { Invert Rate }


{ Returns True if the String represents a Currency/Currency Rate function }
Function IsCurrFunc (Const FStr : String) : Boolean;
Begin { IsCurrFunc }
  Result := (Pos(RateCompFunc, FStr) = 1) Or
            (Pos(RateDayFunc, FStr) = 1) Or
            (Pos(RateFloatFunc, FStr) = 1) Or
            (Pos(RateInvFunc, FStr) = 1) Or
            (Pos(CcyNameFunc, FStr) = 1) Or
            (Pos(CcySymbFunc, FStr) = 1);
End; { IsCurrFunc }


{ Checks to see if a valid RTxxx function is in the string }
{ Valid formats:                                           }
{   RTCOMP[THCURR]                                         }
{   RTCOMP[2]                                              }
{   CCYNAME[0]                                             }
Function ProcessRateFunc(    RepStr   : String;
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
        ParamStr := Strip('B', [#0, #32], Copy (RepStr, BrackPos1 + 1, (BrackPos2 - BrackPos1 - 1)));

        If (Length(ParamStr) > 0) Then Begin
          { Identify parameter type:- DD Field or Currency Number }
          If (ParamStr[1] In ['A'..'Z']) Then Begin
            { Data Dictionary Field }
            If (Length(ParamStr) > 3) And (Length(ParamStr) <= 8) Then Begin
              ParInfo.OffUnits := 'D';
              ParInfo.DateCode := UpcaseStr(LJ (ParamStr,8));
              Result := True;
            End; { If }
          End { If }
          Else Begin
            { Must be a number or a screwup }
            Val (ParamStr, IntVal, ErrCode);

            If (ErrCode = 0) And ((IntVal >= 0) And (IntVal <= CurrencyType)) Then Begin
              ParInfo.OffUnits := '#';
              ParInfo.Units := IntVal;
              Result := True;
            End; { Else }
          End; { Else }

          If Result Then Begin
            { Set length of function + parameters }
            FormLen := BrackPos2;
            FormName := Copy(RepStr, 1, FormLen);
          End; { If }
        End; { If }
      End; { If }
    End; { If }
  End; { If }
End;

{ Returns the value of the Currency Function in both String and Double format }
Function GetCurrVal (Const ParInfo : ParamsType; Const RepDrive, OrigFile : SmallInt) : ResultValueType;
Const
  FNum    = DictF;
  KeyPath = DIK;
Var
  TmpDict  : ^DataDictRec;
  KeyS     : Str255;
  CurrNo   : LongInt;
  DNum     : Double;
  TStr     : ShortString;
  StrRec   : fdFormStringsType;
  DictLink : DictLinkType;
  ErrCode  : Integer;
Begin { GetCurrVal }
  Result.StrResult := '';
  Result.DblResult := 0.00;

  With ParInfo Do Begin
    If (OffUnits = 'D') Then Begin
      { Data Dictionary Currency field has been specified }
      CurrNo := -1;

      New (TmpDict);
      TmpDict^ := DictRec^;

      { Build index for variable record }
      KeyS := 'DV' + ParInfo.DateCode;

      Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
      If (Status = 0) Then Begin
        { Check its a currency field }
        If (DictRec^.DataVarRec.VarType = 9) Then Begin
          With DictLink Do Begin
            DCr  := 0;
            DPr  := 99;
            DYr  := 149;
          End; { With }

          { Get currency through data dictionary }
          TStr := Link_Dict (DictRec^.DataVarRec.VarNo, DictLink, StrRec, 100, RepDrive, OrigFile, '');

          { Convert to currency number }
          Val (TStr, CurrNo, ErrCode);
          If (ErrCode <> 0) Then CurrNo := -1;
        End; { If }

        DictRec^ := TmpDict^;
        Dispose (TmpDict);
      End; { If }
    End { If }
    Else
      { Currency Number Specified }
      CurrNo := ParInfo.Units;

    If (CurrNo >= 0) And (CurrNo <= 29) Then Begin
      Case ParInfo.Format Of
        1 : Begin { Company Rate }
              DNum := SyssCurr^.Currencies[CurrNo].CRates[BOff];

              If SyssGCur^.GhostRates.TriInvert[CurrNo] Then
                DNum := Round_Up(1/DNum, 6);
            End;
        2 : Begin { Daily Rate }
              DNum := SyssCurr^.Currencies[CurrNo].CRates[BOn];

              If SyssGCur^.GhostRates.TriInvert[CurrNo] Then
                DNum := Round_Up(1/DNum, 6);
            End;
        3 : Begin { Floating Rate }
              DNum := SyssGCur^.GhostRates.TriRates[CurrNo];
            End;
        4 : Begin { Currency Name }
              TStr := SyssCurr^.Currencies[CurrNo].Desc;
            End;
        5 : Begin { Currency Name }
              TStr := SyssCurr^.Currencies[CurrNo].PSymb;
            End;
        6 : Begin { Currency 1/x flag }
              TStr := YesNoBo(SyssGCur^.GhostRates.TriInvert[CurrNo]);
            End;
      End; { Case }

      If (ParInfo.Format >= 1) And (ParInfo.Format <= 3) Then Begin
        { Return 1.0 instead of 0.0 }
        If (DNum = 0) Then DNum := 1.00;

        Result.DblResult := DNum;
        Result.StrResult := Form_Real(DNum, 12, 6);
      End { If }
      Else Begin
        { String output }
        Result.StrResult := TStr;
        Result.DblResult := 0.0;
      End; { Else }

    End; { If }
  End; { With }
End; { GetCurrVal }



end.
