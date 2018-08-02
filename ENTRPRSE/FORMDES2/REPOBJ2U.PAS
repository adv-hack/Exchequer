Unit RepObj2U;

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

Uses GlobVar,
     VarConst,
     VarFPosU,
     DicLnk2U,
     BtrvU2;

{$ALIGN 1}

{$I VarRecRP.Pas}

Const
  MaxNoSort      =  9;             {*  No. of Sort Fields *}

Type
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

                     Function GetSortStr  :  Str80;

                     Procedure Calc_PrYr(PStr,YStr  :  Str5;
                                     Var RPr,RYr    :  Byte);

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
   ETStrU,
   {ETools2,
   ETPrintU,
   EPrntDef,
   ETPrompt,}
   ETDateU,
   {ExAsvarU,}
   ETMiscU,
   {InvListU,}
   {ComnUnit,}
   ComnU2{,
   SysU1};




{ ===== Function to translate Printing effect commands to Driver strings ====== }


Function PEffTxlate(EFno     :  Byte;
                    SwitchOn :  Boolean)  :  Str10;



Var
  TefStr  :  Str10;


Begin
  (***
  TefStr:='';


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

    PEffTxlate:=TefStr;
    ***)
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
    (****
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
    *****)
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
    (****
    Sl:=Length(FStr);

    WSl:=Length(WStr);


    If (Pos(WildChA,Fstr)<>0) then {* Contains a wild card *}
      FStr:=PadWCard(FStr,Sl,WSl);

    Sl:=Length(FStr);

    If (Sl>WSl) then   {* Set to shortest length *}
      Sl:=WSl;

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
    ****)
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
            ((Not Match_WildChar(Cond1,Cond2,False)) and (Operand=5)) or
            ((Match_WildChar(Cond1,Cond2,False)) and (Operand=6)));

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


{  Var
    HFPos  :  InpDiskDesc;

    Dnum   :  Double;
    Bnum   :  Byte;
    TmpBo  :  Boolean;

    TStr   :  Str80;
 }
  Begin
    (****
    Blank(HFpos,Sizeof(HFpos));

    TStr:='';

    Dnum:=0;

    Bnum:=0;  TmpBo:=Off;

    With RepFieldRec^ do
    With HFpos do
    Begin

      Case RepDict.VarType of  {* Translate var type to field type *}

        2,3,6..8
          :  If ((RepDet.CalcField) and (Fstr=ErrStr)) then {* Show as error *}
               ITyp:=DataTCharL^[1]
             else
               ITyp:=DataTCharL^[3];

        10
          :  ITyp:=DataTCharL^[8];

        9,5
          :  ITyp:=DataTCharL^[1];

        else ITyp:=DataTCharL^[RepDict.VarType];

      end; {Case..}

      If (RepDet.Format<>'') then
        Just:=RepDet.Format
      else
        Case ITyp of

          'D'  :  Just:='R';
          'S'  :  Just:='L';
          else    Just:='N';

        end; {Case..}

      NoDecs:=RepDet.NoDecs;

      DiskL:=1;

      If (RepDet.Format[2]='%') then
        Len:=Pred(RepDet.VarLen)
      else
        Len:=RepDet.VarLen;


      Case RepDict.VarType of

        2,3,6..8
          :  Begin

               Dnum:=RealStr(FStr);

               TStr:=PPR(Dnum,HFpos);

             end;

        9 :  Begin
               TStr:=PSymb(IntStr(FStr));

               TStr:=PPR(TStr,HFpos);
             end;

        10 : Begin

               Bnum:=IntStr(FStr);

               TStr:=PPr_Pr(Bnum,HFpos);

             end;

        11 : Begin

               TmpBo:=(Strip('B',[#32],UpCaseStr(FStr))='YES');

               TStr:=PPr(TmpBo,HFpos);

             end;

        else Begin

               TStr:=PPr(FStr,HFPos);

             end;

      end; {Case..}




      Format_Field:=LJVar(TStr,RepDet.VarLen);

    end; {With..}
    ****)
  end; {Func..}


  {* ------------------------ *}


  Procedure RepFieldRObj.SetEffect(Var OnStr,
                                       OffStr  :  Str255;
                                       PESet   :  LongInt);

  Var
    n       :  Byte;

  Begin
    (*
    OnStr:=''; OffStr:='';

    If (PESet<>0) then
    Begin
      SetMSelect(RepFieldRec^.RepDet.PrintEff);

      For n:=1 to NoPEffects do
      Begin

        If (MMGroupies^[n].Belongs) then
        Begin
          OnStr:=OnStr+PEffTxlate(n,On);
          OffStr:=OffStr+PEffTxlate(n,Off);
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
        ETDateU.DateStr(ThisValue,Gd,Gm,Gy);

        Dnum:=Caljul(Gd,Gm,Gy);
      end
      else
        Dnum:=RealStr(ThisValue);
    end;

    GetValue:=Dnum;

  end; {Func..}


  {* ------------------------ *}

  Function RepFieldRObj.FormatDrCr(DVal  :  Double) :  Str80;


  Var
    CrDrStr  :  Array[False..True] of Str30;
    DrCrDir  :  Boolean;
    Dnum     :  Double;



  Begin

    With RepFieldRec^ do
    With RepDet do
    Begin
      Dnum:=ABS(DVal);

      DrCrDir:=(DVal<0);

      CrDrStr[DrCrDir]:=Format_Field(Form_Real(Dnum,0,NoDecs));

      CrDrStr[Not DrCrDir]:=Spc(VarLen);

    end; {With..}

    FormatDrCr:=CrDrStr[False]+' '+CrDrStr[True];

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
            GetTotal:=Spc(DrCrVLen(VarLen,CDrCr));
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
      FieldTot[n]:=FieldTot[n]+GetValue(True);

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
    ULineType  :  Array[False..True] of Char = ('-','=');

  Var
    TStr  :  Str80;


  Begin
    (*
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
    *)
  end; {Func..}




  {* ------------------------ *}

  Procedure RepFieldRObj.ResetTotal(BTNo,
                                    TotBtNo  :  Byte);

  Var
    n,m  :  Byte;

  Begin
    (*
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
    *)
  end; {Proc..}



  {* ------------------------ *}


  Procedure RepFieldRObj.SetValue(NewValue  :  Str80;
                                  Update    :  Boolean);


  Begin
    (*
    With RepFieldRec^ do
    Begin
      If (Update) then
        LastValue:=ThisValue;

      ThisValue:=NewValue;

      BreakFound:=((RepDet.Break>1) and (ThisValue<>LastValue) and (LastValue<>RSetLVal));

    end;
    *)
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

      If (PrintVar) then
      Begin
        If (SubsBlnk) then
          FillField:=Spc(DrCrVLen(VarLen,CDrCr))
        else
        Begin
          If (CDrCr) then
            FillField:=FormatDrCr(GetValue(True))
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
    (*
    With RepFieldRec^ do
    With Printer_Def do
    Begin

      With RepDet do
        If (CDrCr) then
          FillHead:=DSon+DrCrHed(RepLDesc,VarLen)+DSof
        else
          If (RepDict.VarType In ITypValSet) then
            FillHead:=DSon+RJVar(RepLDesc,VarLen)+DSof
          else
            FillHead:=DSon+LJVar(RepLDesc,VarLen)+DSof;

    end; {With..}
    *)
  end; {Func..}


  {* ------------------------ *}


  Function RepFieldRObj.FillCDF  :  Str80;

  Begin
    (*
    With RepFieldRec^ do
    Begin

      If (RepDict.VarType In ITypValSet) then
        FillCDF:=CDL(GetValue(Off),RepDet.NoDecs)
      else
        FillCDF:=Txt(GetStr(Off));

    end; {With..}
    *)
  end; {Func..}


  {* ------------------------ *}


  Function RepFieldRObj.GetSortStr  :  Str80;

  Var
    Dnum  :  Double;
    TStr  :  Str80;


  Begin
    (*
    Dnum:=0;

    TStr:='';

    With RepFieldRec^ do
    Begin


      If (RepDict.VarType In ITypValSet) then {* Its a value *}
        TStr:=SortNumber(GetValue(On),(RepDet.SortOrd[2]='D'),RepDet.NoDecs)
      else
      Begin
        If (RepDet.SortOrd[2]='D') then
          TStr:=DescendStr(GetStr(On))
        else
          TStr:=GetStr(On);
      end; {If A String}

    end; {With..}

    GetSortStr:=TStr;
    *)
  end; {Func..}



  {* ------------------------ *}


  Procedure RepFieldRObj.Calc_PrYr(PStr,YStr  :  Str5;
                               Var RPr,RYr    :  Byte);

  Var
    OffSet,
    DCnst  :  Boolean;
    n,m    :  Byte;



  Begin
    (*
    RPr:=0; RYr:=255;

    DCnst:=False;

    OffSet:=((Pos('+',PStr)<>0) or (Pos('-',PStr)<>0) or (Pstr=YTDStr) or (PStr=CTDStr) or (IntStr(PStr)=0));

    If (OffSet) then
    Begin

      If (PStr=CTDStr) then
        RPr:=YTD
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

        If (IntStr(YStr)=0) then  {* If its an ofset and year=now then set year *}
          RYr:=Syss.CYr;

        For m:=1 to n do
          AdjPr(RYr,RPr,DCnst);


      end;
    end
    else
      RPr:=IntStr(PStr);

    OffSet:=((Pos('+',YStr)<>0) or (Pos('-',YStr)<>0) or (IntStr(YStr)=0));

    If (OffSet) then
    Begin

      DCnst:=(Pos('-',YStr)=0);

      n:=IntStr(Strip('B',[#32,'-','+'],YStr));

      For m:=1 to n do
        RYr:=AdjYr(RYr,DCnst);

    end
    else
      RYr:=IntStr(YStr);
    *)
  end; {Proc..}


end. {Unit..}
