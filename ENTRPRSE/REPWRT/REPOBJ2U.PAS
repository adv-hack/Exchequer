Unit RepObj2U;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 05/09/94                      }
{                                                              }
{                 Rep Gen Object Control Unit II               }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses Dialogs,
     GlobVar,
     VarConst,
     VarFPosU,
     DicLnk2U,
     RwOpenF;

Const
  MaxRWCols = 100;


Type
  { Not used in this module - but used in 3 modules which use this module }
  ColWidthsRecType = Record
    Width : SmallInt;
    Just  : Char;
  End; { ColWidthsRecType }
  ColWidthsType = Array [0..MaxRWCols] Of ColWidthsRecType;

  { Not used in this module - but used in 3 modules which use this module }
  ColTextArrayType = Record
    ColVal    : ShortString;      { Text to be placed in the column }
    FontStyle : Byte;             { TFontStyles - Bold, Italic, etc }
    FontColor : LongInt;          { TColor - Font Color }
  End; { ColTextArrayType }
  ColTextRecType = Record
    NumCols : Byte;
    Cols    : Array [0..MaxRWCols] Of ColTextArrayType;
  End; { ColTextRecType }
  ColTextPtrType = ^ColTextRecType;

  { Not used in this module - but used in 3 modules which use this module }
  ColUndiesType = Array [0..MaxRWCols] Of Char;

  RepFieldType  =  Record
                     FieldTot  :  Array[0..MaxNoSort] of Double;

                     LastValue,
                     ThisValue :  String[100];

                     BreakFound,
                     RunNom    :  Boolean;

                     RepDet    :  ReportDetailType;
                     RepDict   :  DataVarType;

                     DLink     :  DictLinkType;
                   end;

  { ======================= Report Control Objects ======================= }



  RepFieldPtr   =  ^RepFieldRObj;

  RepFieldRObj  =  Object

                     RepfieldRec  :  ^RepFieldType;


                     Constructor Init;

                     Destructor Done;

                     Function Format_Field(FStr  :  Str80)  :  Str80;

                     Procedure SetEffect(Var OnStr,
                                             OffStr  :  Str255;
                                             PESet   :  LongInt);

                     Function DescendStr(SStr  :  Str80)  :  Str80;

                     Function GetValue(ConvDate  :  Boolean)  :  Double;

                     Function FormatDrCr(DVal  :  Double) :  Str80;

                     Function GetTotal(BTno      :  Byte;
                                       ForceTot,
                                       ShowBrk   :  Boolean)  :  Str80;


                     Function GetFieldTotal(BTno  :  Byte)  :  Double;


                     Procedure UpdateTotals(NoTots  :  Byte);

                     Procedure ReduceTotals(NoTots  :  Byte;
                                            RedBy   :  Double);

                     Function FillTUndy(FinLine  :  Boolean) :  Str80;

                     Procedure ResetTotal(BTNo,
                                          TotBtNo  :  Byte);

                     Procedure SetValue(NewValue  :  Str80;
                                        Update    :  Boolean);


                     Function GetStr(PadOn  :  Boolean)  :  Str80;

                     Function FillField(SubsBlnk  :  Boolean)  :  Str255;

                     Function FillLastField  :  Str255;

                     Function FillHead  :  Str80;

                     Function FillCDF  :  Str80;

                     Function FillCDFTot(Val : Str80)  :  Str80;

                     Function FillDBF  :  Str80;

                     Function GetSortStr  :  Str80;

                     Procedure Calc_PrYr(PStr,YStr  :  Str5;
                                     Var RPr,RYr    :  Byte);

                     function DbfFieldDef : Str80;

                   end; {Object}





  Function PEffTxlate(EFno     :  Byte;
                      SwitchOn :  Boolean)  :  Str10;


  Function CompareStr(Cond1,
                      Cond2   :  Str80;
                      Operand :  Byte)  :  Boolean;

  Function CompareNum(Cond1,
                      Cond2   :  Double;
                      Operand :  Byte)  :  Boolean;



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   {Crt,
   Dos,
   EWinSBS,}
   SysUtils,
   TEditVal,
   ETStrU,
   {ETools2,
   ETPrintU,
   EPrntDef,
   ETPrompt,}
   ETDateU,
   {ExAsvarU,}
   ETMiscU,

   BtrvU2,
   BtSupU1,

   {InvListU,}
   CurrncyU,
   ComnUnit,
{$IFDEF DBF}
   Classes,
   DbfForm,
{$ENDIF}
   ComnU2{,
   SysU1};


Function DrCrVLen(Const VarLen : SmallInt; Const CDrCr : Boolean) : ShortString;
begin
  If CdrCr Then
    Result := #9
  Else
    Result := '';
end;

{ ===== Function to translate Printing effect commands to Driver strings ====== }


Function PEffTxlate(EFno     :  Byte;
                    SwitchOn :  Boolean)  :  Str10;



Var
  TefStr  :  Str10;


Begin

  TefStr:='';

  (*
  With Printer_Def do
    Case EFno of

      1  :  TefStr:=Pica;

      2  :  If (SwitchOn) then
              TefStr:=Elite
            else
              TefStr:=Pica;

      3  :  If (SwitchOn) then
              TefStr:=CondOn
            else
              TefStr:=CondOf;

      4  :  If (SwitchOn) then
              TefStr:=EnlrgOn
            else
              TefStr:=EnlrgOf;

      5  :  If (SwitchOn) then
              TefStr:=VEnlrgOn
            else
              TefStr:=VEnlrgOf;

      6  :  If (SwitchOn) then
              TefStr:=EmphOn
            else
              TefStr:=EmphOf;

      7  :  If (SwitchOn) then
              TefStr:=DSOn
            else
              TefStr:=DsOf;

      8  :  If (SwitchOn) then
              TefStr:=UndyOn
            else
              TefStr:=UndyOf;

      9  :  If (SwitchOn) then
              TefStr:=ItalOn
            else
              TefStr:=ItalOff;

      11 :  If (SwitchOn) then
              TefStr:=QOn
            else
              TefStr:=QOf;

    end; {Case..}
    *)

    PEffTxlate:=TefStr;

  end; {Func..}



  { ===== Function to Generate sorted Value Field ===== }

  Function SortNumber(DValue  :  Double;
                      Decend  :  Boolean;
                      NoDecs  :  Byte)  :  Str80;

  Const
    ForceD  :  Array[0..1] of Char = (#255,#254);

  Var
    TStr  :  Str80;


  Begin

    If (Decend) then
    Begin

      If (DValue<0) then
        TStr:=Form_Real((DValue*DocNotCnst),0,10)
      else
        If (DValue>1) then
          TStr:=Form_Real(DivWChk(1,DValue),0,10)
        else
          TStr:=ConstStr(ForceD[Round(DValue)],30);

    end
    else
    Begin

      If (DValue<0) then
        TStr:=Form_Real(DivWChk(1,DValue*DocNotCnst),0,10)
      else
        TStr:=Form_Real(DValue,0,10);

    end;

    SortNumber:=SetPadNo(TStr,30);

  end; {Func..}
      


  Function PadWCard(Fstr  :  Str20;
                    Fl,Sl :  Byte)  :  Str20;

  Var
    TmpStr,
    RestStr  :  Str20;



  Begin

    TmpStr:=FStr;

    If (FStr[1]=WildChA) then
    Begin

      RestStr:=Copy(Fstr,2,Pred(Fl));

      TmpStr:=LJVar(ConstStr(WildChQ,Sl-Length(RestStr))+RestStr,Sl);

    end
    else
      If (Fstr[Fl]=WildChA) then
      Begin

        RestStr:=Copy(Fstr,1,Pred(Fl));

        TmpStr:=LJVar(RestStr+ConstStr(WildChQ,Sl-Length(RestStr)),Sl);

      end;


    PadWCard:=FStr;

  end; {Func..}



  { ======= Function to return a match based on wild chars ===== }


  Function Match_WildChar(WStr,
                          FStr     :   Str255;
                          AsIs     :   Boolean)  :  Boolean;



  Var
    Sl,n,
    WSl   :  Byte;

    FOk   :  Boolean;



  Begin

    Sl:=Length(FStr);

    WSl:=Length(WStr);


    If (Pos(WildChA,Fstr)<>0) then {* Contains a wild card *}
      FStr:=PadWCard(FStr,Sl,WSl);

    Sl:=Length(FStr);

    (*If (Sl>WSl) then   {* Set to shortest length *}
      Sl:=WSl;*)

    { HM 13/10/97: Check all characters of FStr against WStr }
    If (SL > WSL) Then Begin
      { Pad out WStr with spaces and check all chars }
      For n := WSL To SL Do
        WStr := WStr + ' ';
    End; { If }

    If (Not AsIs) then
    Begin
      WStr:=UpCaseStr(WStr);
      FStr:=UpCaseStr(FStr);
    end;


    FOk:=(((WSL<>0) and (FStr<>'')) or ((WStr='') and (FStr='')));

    n:=1;

    While (n<=Sl) and (Fok) do
    Begin

      FOk:=((WStr[n]=FStr[n]) or (FStr[n] In WildChars));

      Inc(n);

    end; {While..}


    Match_WildChar:=FOk;

  end; {Func..}



  { ====== Function to Return Conditional comparison ====== }

  Function CompareStr(Cond1,
                      Cond2   :  Str80;
                      Operand :  Byte)  :  Boolean;


  Var
    TmpBo  :  Boolean;

  Begin

    {$B-}

    TmpBo:=(((Cond1<Cond2) and (Operand=1)) or
            ((Cond1>Cond2) and (Operand=2)) or
            ((Cond1<=Cond2) and (Operand=3)) or
            ((Cond1>=Cond2) and (Operand=4)) or
            ((Not Match_WildChar(Cond1,Cond2,BOff)) and (Operand=5)) or
            ((Match_WildChar(Cond1,Cond2,BOff)) and (Operand=6)));

    CompareStr:=TmpBo;

    {$B+}

  end; {Func..}


  { ====== Function to Return Conditional comparison ====== }

  Function CompareNum(Cond1,
                      Cond2   :  Double;
                      Operand :  Byte)  :  Boolean;


  Var
    TmpBo  :  Boolean;

  Begin

    {$B-}

    TmpBo:=(((Cond1<Cond2) and (Operand=1)) or
            ((Cond1>Cond2) and (Operand=2)) or
            ((Cond1<=Cond2) and (Operand=3)) or
            ((Cond1>=Cond2) and (Operand=4)) or
            ((Cond1<>Cond2) and (Operand=5)) or
            ((Cond1=Cond2) and (Operand=6)));

    CompareNum:=TmpBo;

    {$B+}

  end; {Func..}


  { ====== Function to Return DrCrHeding ====== }

  Function DrCrHed(HTit  :  Str80;
                   FLen  :  Byte)  :  Str80;


  Var
    TL,gap,g1,g2  :  Byte;

  Begin
    TL:=Succ(Flen*2);

    gap:=TL-(Length(HTit)+8);

    g1:=Round(DivWChk(Gap,2));

    g2:=gap-g1;

    DrCrHed:='Dr'+Spc(g1)+'<-'+HTit+'->'+Spc(g2)+'Cr';

  end; {Func..}


  { ===== Function to enclose an item in quotes ===== }


  Function Txt(T  :  Str255)  :  Str255;

  Var

    n  :  Byte;

  Begin

    n:=0;

    Repeat

      n:=Pos('"',T);

      If (n>0) then
        T[N]:=#39;

    Until (n=0);

    Txt:='"'+T+'"';

  end;



  { ===== Function to Convert a Real to a std Str ===== }

  Function CDL(R  :  Real;
               Dp :  Byte)  :  Str80;


  Begin

    CDL:=Form_Real(R,0,Dp)

  end;



   { ---------------------------------------------------------------- }

   {  RepField Methods }

   { ---------------------------------------------------------------- }




  Constructor RepFieldRObj.Init;

  Begin

    New(RepFieldRec);

    Blank(RepFieldRec^,Sizeof(RepFieldRec^));


  end; {Constructor..}


  {* ------------------------ *}


  Destructor RepFieldRObj.Done;

  Begin

    Dispose(RepFieldRec);

  end; {Destructor..}


  {* ------------------------ *}


  Function RepFieldRObj.Format_Field(FStr  :  Str80)  :  Str80;


  Var
    FieldMask : Str255;
    TStr      :  Str80;
    Dnum      :  Double;
    CtrCh     : Char;
    INum      : LongInt;
    BlankMe   : Boolean;
  Begin
    TStr:='';
    Dnum:=0;

    With RepFieldRec^ Do Begin
      Case RepDict.VarType of
        { Real, Double }
        2,3
          :  Begin
               { Get value of field }
               Dnum:=Round_Up(RealStr(FStr),RepDet.NoDecs);

               If (Length(RepDet.Format) > 0) Then
                 BlankMe := (RepDet.Format[1] = 'B')
               Else
                 BlankMe := False;

               If BlankMe And (DNum = 0.0) Then
                 { Blank If Zero }
                 TStr := ''
               Else Begin
                 { Generate a new mask with the correct decimals }
                 FieldMask := FormatDecStrSD(RepDet.NoDecs, GenRealMask, BOff);

                 { reformat field into what it should look like }
                 TStr := FormatFloat (FieldMask, Dnum);
               End; { Else }
             end;
        { Date }
        4 :  Begin
               TStr := POutDateB(FStr);
             End;
        { Longint, Integer, Byte }
        6..8
          :  Begin
               INum := IntStr(FStr);

               If (Length(RepDet.Format) > 0) Then
                 BlankMe := (RepDet.Format[1] = 'B')
               Else
                 BlankMe := False;

               If BlankMe And (INum = 0) Then
                 { Blank If Zero }
                 TStr := ''
               Else
                 TStr := Form_Int(INum, 0);
             end;
        { Currency }
        9 :  Begin
               TStr := SSymb(IntStr(FStr));
             end;
        { String, Date, Char, Time, Period, Yes/No }
        else Begin
               TStr := FStr;
             end;

      end; {Case..}

      If (Length(RepDet.Format) > 1) Then Begin
        { HM 14/10/97: Added to support C- fields }
        If (RepDet.Format[1] = 'C') And (RepDet.Format[2] <> ' ') Then Begin
          { Pad out with 2nd char to centre value in field }
          CtrCh := RepDet.Format[2];
          TStr := PadCenter(Strip('B', [#0, #32], TStr),
                                  RepDet.VarLen,
                                  CtrCh);
        End { If }
        Else
          { HM 15/12/99 v4.31 - Added support for % operation }
          If (RepDet.Format[2] = '%') Then Begin
            TStr := Tstr + '%';
          End { If }
      End; { If (Length(RepDet.Format) > 1) }

      { HM 15/10/97: Eliminated Trimming because it was making +ve/-ve numbers unaligned }
      {Result := Trim (TStr);}
      Result := TStr;
    end; {With..}
  end; {Func..}


  {* ------------------------ *}


  Procedure RepFieldRObj.SetEffect(Var OnStr,
                                       OffStr  :  Str255;
                                       PESet   :  LongInt);

  Var
    n       :  Byte;

  Begin

    OnStr:=''; OffStr:='';

    (* RW32
    If (PESet<>0) then
    Begin
      SetMSelect(RepFieldRec^.RepDet.PrintEff);

      For n:=1 to NoPEffects do
      Begin

        If (MMGroupies^[n].Belongs) then
        Begin
          OnStr:=OnStr+PEffTxlate(n,BOn);
          OffStr:=OffStr+PEffTxlate(n,BOff);
        end;

      end; {Loop..}
    end; {If Effects set}
    *)
  end; {Proc..}




  {* ------------------------ *}


  Function RepFieldRObj.DescendStr(SStr  :  Str80)  :  Str80;

  Var
    n     :  Byte;

    TStr  :  Str80;



  Begin

    TStr:='';

    For n:=1 to Length(SStr) do
      TStr:=TStr+Chr(255-Ord(SStr[n]));

    DescendStr:=TStr;

  end; {Func..}


  {* ------------------------ *}


  Function RepFieldRObj.GetValue(ConvDate  :  Boolean)  :  Double;

  Var
    Gd,Gm,Gy  :  Word;

    Dnum      :  Double;

  Begin

    Dnum:=0;

    With RepFieldRec^ do
    Begin
      If (RepDict.VarType=4) and (ConvDate) then {* Convert a date to julian *}
      Begin
        DateStr(ThisValue,Gd,Gm,Gy);

        Dnum:=Caljul(Gd,Gm,Gy);
      end
      else
        Dnum:=Round_Up(RealStr(ThisValue),RepDet.NoDecs);
    end;

    GetValue:=Dnum;

  end; {Func..}


  {* ------------------------ *}

  Function RepFieldRObj.FormatDrCr(DVal  :  Double) :  Str80;


  Var
    CrDrStr  :  Array[BOff..BOn] of Str30;
    DrCrDir  :  Boolean;
    Dnum     :  Double;



  Begin

    With RepFieldRec^ do
    With RepDet do
    Begin
      Dnum:=ABS(DVal);

      DrCrDir:=(DVal<0);

      CrDrStr[DrCrDir]:=Format_Field(Form_Real(Dnum,0,NoDecs));

      CrDrStr[Not DrCrDir]:=''; {Spc(VarLen);}

    end; {With..}

    FormatDrCr:=CrDrStr[BOff]+#9+CrDrStr[BOn];

  end; {Func..}


  {* ------------------------ *}


  Function RepFieldRObj.GetTotal(BTno      :  Byte;
                                 ForceTot,
                                 ShowBrk   :  Boolean)  :  Str80;


  Begin

    With RepFieldRec^ do
      If (RepDet.SubTot) or (ForceTot) then
      Begin
        If (RepDet.CDrCr) then
          GetTotal:=FormatDrCr(FieldTot[BTNo])
        else
          GetTotal:=Format_Field(Form_Real(FieldTot[BTNo],0,RepDet.NoDecs));
      end
      else
        With RepDet do
        Begin
          If (ShowBrk) and (BTNo=IntStr(SortOrd[1])) then
            GetTotal:=FillLastField
          else
            GetTotal:=DrCrVLen(VarLen,CDrCr);
        end;

  end; {Func..}


  {* ------------------------ *}


  Function RepFieldRObj.GetFieldTotal(BTno  :  Byte)  :  Double;

  Begin

    With RepFieldRec^ do
      GetFieldTotal:=FieldTot[BTNo];

  end; {Func..}


  {* ------------------------ *}


  Procedure RepFieldRObj.UpdateTotals(NoTots  :  Byte);

  Var
    n  :  Byte;

  Begin

    For n:=0 to NoTots do
    With RepFieldRec^ do
      FieldTot[n]:=FieldTot[n]+GetValue(BOn);

  end; {Proc..}



  {* ------------------------ *}


  Procedure RepFieldRObj.ReduceTotals(NoTots  :  Byte;
                                      RedBy   :  Double);

  Var
    n  :  Byte;

  Begin

    For n:=NoTots Downto 0 do
    With RepFieldRec^ do
      FieldTot[n]:=FieldTot[n]-RedBy;

  end; {Proc..}


  {* ------------------------ *}

  Function RepFieldRObj.FillTUndy(FinLine  :  Boolean) :  Str80;

  Const
    ULineType  :  Array[BOff..BOn] of Char = ('-','=');

  Var
    TStr  :  Str80;


  Begin

    With RepFieldRec^ do
    Begin
      If (RepDet.SubTot) or ((RepDict.VarType In ITypValSet-LnumValSet) and (RunNom)) then
        TStr:=ConstStr(ULineType[FinLine],RepDet.VarLen)
      else
        TStr:=LJVar('',RepDet.VarLen);

      If (RepDet.CDrCr) then
        FillTUndy:=TStr+' '+TStr
      else
        FillTUndy:=TStr;

    end; {With..}

  end; {Func..}




  {* ------------------------ *}

  Procedure RepFieldRObj.ResetTotal(BTNo,
                                    TotBtNo  :  Byte);

  Var
    n,m  :  Byte;

  Begin

    If (BTNo=255) then
      m:=0
    else
      m:=BTNo;

    For n:=m to TotBtNo do
      RepFieldRec^.FieldTot[n]:=0;

    If (m=BTNo) then
      RepFieldRec^.LastValue:=RSetLVal
    else
      RepFieldRec^.LastValue:='';        {* Reset as part of re-run *}

  end; {Proc..}



  {* ------------------------ *}


  Procedure RepFieldRObj.SetValue(NewValue  :  Str80;
                                  Update    :  Boolean);


  Begin

    With RepFieldRec^ do
    Begin
      If (Update) then
        LastValue:=ThisValue;

      ThisValue:=NewValue;

      BreakFound:=((RepDet.Break>1) and (ThisValue<>LastValue) and (LastValue<>RSetLVal));

    end;

  end; {Proc..}



  {* ------------------------ *}


  Function RepFieldRObj.GetStr(PadOn  :  Boolean)  :  Str80;

  Var
    TStr  :  Str80;

  Begin

    With RepFieldRec^ do
    Begin

      TStr:=ThisValue;

      If (PadOn) then
        GetStr:=LJVar(TStr,RepDet.VarLen)
      else
        GetStr:=TStr;

    end; {With..}

  end; {Func..}



  {* ------------------------ *}


  Function RepFieldRObj.FillField(SubsBlnk  :  Boolean)  :  Str255;

  Var
    TStr    :  Str255;

  Begin

    TStr:='';

    With RepFieldRec^ do
    With RepDet do
    Begin
      {$IFDEF GUI}
      PrintVar := True;
      {$ENDIF}
      If (PrintVar) then
      Begin
        If (SubsBlnk) then
          FillField:=DrCrVLen(VarLen,CDrCr)
        else
        Begin
          If (CDrCr) then
            FillField:=FormatDrCr(GetValue(BOn))
          else
            FillField:=Format_Field(ThisValue);
        end;
      end
      else
        FillField:=TStr;
    end; {With..}

  end; {Func..}


    {* ------------------------ *}


  Function RepFieldRObj.FillLastField  :  Str255;

  Var
    TStr    :  Str255;

  Begin

    TStr:='';

    With RepFieldRec^ do
    With RepDet do
    Begin

      If (PrintVar) then
      Begin
        If (CDrCr) then
          FillLastField:=FormatDrCr(RealStr(LastValue))
        else
          FillLastField:=Format_Field(LastValue);
      end
      else
        FillLastField:=TStr;

    end; {With..}

  end; {Func..}


  {* ------------------------ *}


  Function RepFieldRObj.FillHead  :  Str80;
  Begin
                           {RW32}
    With RepFieldRec^, {Printer_Def, }RepDet Do Begin
      If (CDrCr) then
        {FillHead:=DrCrHed(RepLDesc,VarLen)}
        FillHead:=Trim(RepLDesc) + ' (Dr)' + #9 + Trim(RepLDesc) + ' (Cr)'
      else
        If (RepDict.VarType In ITypValSet) then
          FillHead:={DSon+}RJVar(RepLDesc,VarLen){+DSof}
        else
          FillHead:={DSon+}LJVar(RepLDesc,VarLen){+DSof};
    End; { With }

  end; {Func..}


  {* ------------------------ *}


  Function RepFieldRObj.FillCDF  :  Str80;

  Begin

    With RepFieldRec^ do
    Begin

      If (RepDict.VarType In ITypValSet) then
        FillCDF:=CDL(GetValue(BOff),RepDet.NoDecs)
      else
        FillCDF:=Txt(GetStr(BOff));

    end; {With..}

  end; {Func..}

  Function RepFieldRObj.FillCDFTot(Val : Str80)  :  Str80;

    function RemoveCommas(s : Str80) : Str80;
    var
      i : integer;
    begin
      i := 1;
      while i < Length(s) do
      begin
        if s[i] = ',' then
          Delete(s, i, 1)
        else
          inc(i);
      end;

      if Length(s) > 0 then
      begin
        if s[Length(s)] = '-' then
        begin
          Delete(s, Length(s), 1);
          s := '-' + s;
        end;
      end;
      Result := s;
    end;

  Begin

    With RepFieldRec^ do
    Begin

      If (RepDict.VarType In ITypValSet) then
        FillCDFTot:=Trim(RemoveCommas(Val))
      else
        FillCDFTot:=Txt(Val);

    end; {With..}

  end; {Func..}


  Function RepFieldRObj.FillDBF  :  Str80;

  Begin

    With RepFieldRec^ do
    Begin

      If (RepDict.VarType In ITypValSet) then
        Result := CDL(GetValue(BOff),RepDet.NoDecs)
      else
        Result := GetStr(BOff);

    end; {With..}

  end; {Func..}

function RepFieldRObj.DbfFieldDef : Str80;
begin

  with RepFieldRec^ do
  begin
    Result := Trim(RepDict.VarName) + ';';

    Case RepDict.VarType of
      1,5,10 :  Result := Result + 'C;'; //String
      2,3,9  :  Result := Result + 'F;'; //Float
      4,12   :  Result := Result + 'D;'; //Date
      6,7,8  :  Result := Result + 'N;'; //Number
      11     :  Result := Result + 'L;'; //Logical
    end;

    Result := Result + IntToStr(RepDict.VarLen) + ';' +
             IntToStr(RepDict.VarNoDec);
  end;
end;


  {* ------------------------ *}


  Function RepFieldRObj.GetSortStr  :  Str80;

  Var
    Dnum  :  Double;
    TStr  :  Str80;


  Begin
    Dnum:=0;

    TStr:='';

    With RepFieldRec^ do
    Begin

      
      If (RepDict.VarType In ITypValSet) then {* Its a value *}
        TStr:=SortNumber(GetValue(BOn),(RepDet.SortOrd[2]='D'),RepDet.NoDecs)
      else
      Begin
        If (RepDet.SortOrd[2]='D') then
          TStr:=DescendStr(GetStr(BOn))
        else
          TStr:=GetStr(BOn);
      end; {If A String}

    end; {With..}

    GetSortStr:=TStr;

  end; {Func..}



  {* ------------------------ *}


  Procedure RepFieldRObj.Calc_PrYr(PStr,YStr  :  Str5;
                               Var RPr,RYr    :  Byte);

  Var
    OffSet,
    DCnst  :  Boolean;
    n,m    :  Byte;
    YtdCtd :  Boolean;


  Begin
    RPr:=0; RYr:=255;

    DCnst:=BOff;
    YtdCtd := False;

    OffSet:=((Pos('+',PStr)<>0) or (Pos('-',PStr)<>0) or (Pstr=YTDStr) or (PStr=CTDStr) or (IntStr(PStr)=0));

    If (OffSet) then
    Begin

      If (PStr=CTDStr) then Begin
        RPr:=YTD;
        YtdCtd := True;
      End
      else
        If (PStr=YTDStr) then
        Begin
          RYr:=Syss.CYr;

          RPr:=YTDNCF;
        end
        else
        Begin
          DCnst:=(Pos('-',PStr)=0);

          n:=IntStr(Strip('B',[#32,'-','+'],PStr));

          RPr:=Syss.CPr;

          (*
          If (Strip('B',[#32],YStr)='') then {* If its an ofset and year=now then set year *}
            RYr:=Syss.CYr;*)

          { HM 17/06/97: Added because Year wasn't being set correctly - caused Range Check Error }
          If (Pos('+',YStr)<>0) Or (Pos('-',YStr)<>0) Or (Strip('B',[#32],YStr)='') Then
            RYr:=Syss.CYr;

          For m:=1 to n do
            AdjPr(RYr,RPr,DCnst);


        end;
    end
    else
      RPr:=IntStr(PStr);

    If (Not YtdCtd) Then Begin
      { Is not CTD }

      OffSet:=((Pos('+',YStr)<>0) or (Pos('-',YStr)<>0) or (Strip('B',[#32],YStr)=''));

      If (OffSet) then
      Begin
        { HM 17/06/97: Added because Year wasn't being set correctly }
        If (RYr = 255) Then RYr := Syss.CYr;

        DCnst:=(Pos('-',YStr)=0);

        n:=IntStr(Strip('B',[#32,'-','+'],YStr));

        For m:=1 to n do
          RYr:=AdjYr(RYr,DCnst);

      end
      else
        RYr:=TxLatePYr(IntStr(YStr),BOff);
    End; { If }
  end; {Proc..}



end. {Unit..}