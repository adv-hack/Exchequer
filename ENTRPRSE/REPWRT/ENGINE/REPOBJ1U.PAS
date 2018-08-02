Unit RepObj1U;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 29/08/94                      }
{                                                              }
{                 Rep Gen Object Control Unit I                }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     RwOpenF;


Type

  Hand_ValIPtr     =  ^HandValObj;

  InpDiskDesc      =  Record
                    ITyp    :    Char;
                    Len     :    Byte;
                    X,Y     :    Byte;
                    Just    :    String[2];
                    NoDecs  :    Byte;
                    Fx      :    Byte;
                    FHelpNo :    Integer;
                    DiskL   :    Integer;
  End; { InpDiskDesc }

  HandValObj       =  Object


                        HX,Hy,
                        Lno,
                        LType  :  Byte;
                        {HFpos  :  Array[1..4] of InpDiskDesc;}

                        {SetMax :  Boolean;}


                        Constructor Init(IX,IY,LT  :  Byte);

                        Destructor   Done;

                        {Procedure  BuildFpos(LT  :  Byte);}

                        {Function RetFposStr(RepDet  :  ReportDetailType;
                                            Ary     :  Byte)  :  Str30;}

                        {Procedure FposStr2Det(Var  RepDet  :  ReportDetailType;
                                                   Ary     :  Byte;
                                                   FStr    :  Str30);}

                        {Function OutPutFpos(RepDet  :  ReportDetailType;
                                            ShowStp :  Boolean)  :  Str80;}


                        {Procedure InputFpos(Var  RepDet   :  ReportDetailType;
                                                 CurrLine :  Integer);}

                        {Procedure SetDefault(Var RepDet  :  ReportDetailType);}

                        Function GetInpValue(RepDet  :  ReportDetailType;
                                             SubNo,
                                             SubSubNo:  Byte;
                                         Var VType   :  Byte)  :  Str80;


                      end; {Object..}



  Function Is_Val(IT  :  Byte)  :  Boolean;


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   {Crt,
   Dos,
   EWinSBS,}
   ETStrU,
   {ETools2,}
   ETMiscU,
   {ETPrintU,
   ETPrompt,}
   ETDateU,
   {ExAsvarU,}
   VarFPosU,
   ComnUnit,
   ComnU2,
   InvListU,
   BtKeys1U;



Const
  InpXLType  :  Array[0..NoInpTypes] of Char = ('S','D','S','R','S','B','S','S','S',
                                                'S','S','S','S','S','S','S','S','S','S');

  InpXLen    :  Array[0..NoInpTypes] of Byte = (0,8,PrLen,14,20,2,DocLen,AccLen,AccLen,
                                                AccLen,StkLen,CCDpLen,CCDpLen,MLocLen,20,20,20,20,BinKeyLen);




{ ======= Proc to adjust Input window ====== }
(*
Procedure Calc_InpWind(Var ScanW      :  Windx;
                           CurrLine   :  Integer;
                           LType,
                           LNo        :  Byte);


Var
  CalcW  :  Byte;


Begin

  ScanW:=InpPopW;

  ScanW[2]:=ScanW[2]+CurrLine;

  If (ScanW[2]>Pred(DisplayLines)) then
    ScanW[2]:=Pred(DisplayLines);

  CalcW:=(InpXLen[Ltype]*Lno)+7;

  ScanW[3]:=CalcW;

  ScanW[1]:=Round((ScreenMin-CalcW)/2);



end; {Proc..}
*)

   { ---------------------------------------------------------------- }

   {  HandVal Methods }

   { ---------------------------------------------------------------- }




  Constructor HandValObj.Init(IX,IY,LT  :  Byte);

  Begin

    HX:=IX;
    HY:=IY;

    LType:=LT;

    {SetMax:=BOff;}

    {BuildFpos(LT);}
  end;


  Destructor HandValObj.Done;

  Var
    n  :  Byte;

    {CtrlInp
       :  Inp_ChkType;}



  Begin

    LType:=0;

    (*
    If (SetMax) then
      For n:=1 to 2 do  {* Reset Max /Mins*}
      Begin
        Get_InpCheck(n,CtrlInp);

        With CtrlInp do
        Begin

          ChkRange:=Off;

          Disp:=Off;

        end;

        Put_InpCheck(n,CtrlInp);
      end;
    *)

  end;


(*
  Procedure HandValObj.BuildFpos(LT  :  Byte);

  Var
    n  :  Byte;

    CtrlInp
       :  Inp_ChkType;


  Begin

    LType:=LT;

    Blank(HFpos,Sizeof(HFpos));

    With HFPos[1] do
    Begin
      ITyp:=InpXLType[LType];
      Len:=InpXLen[LType];

      X:=HX;
      Y:=HY;

      If (Ltype<>3) then
        Just:='L'
      else
        Just:='R';

      NoDecs:=3;

      DiskL:=1;

    end;


    LNo:=2;

    Case LType of

      1,3..NoInpTypes
         :  Begin

              HFpos[2]:=HFpos[1];

              With HFpos[2] do
              Begin

                X:=X+Len+3;

              end;

              If (LType=5) then {* Set Currency Max...}
              Begin
                SetMax:=On;

                Get_InpCheck(1,CtrlInp);

                With CtrlInp do
                Begin

                  Min:=0; Max:=CurrencyType;

                  ChkRange:=On;

                end;

                Put_InpCheck(1,CtrlInp);
              end;

            end;

      2  :  Begin

              SetMax:=On;

              Get_InpCheck(1,CtrlInp);

              With CtrlInp do
              Begin

                Min:=1; Max:=Syss.PrInYr;

                ChkRange:=On;

                Disp:=On;

              end;

              Put_InpCheck(1,CtrlInp);

              Get_InpCheck(2,CtrlInp);

              With CtrlInp do
              Begin

                Min:=1; Max:=99;


                ChkRange:=On;

                Disp:=On;

              end;

              Put_InpCheck(2,CtrlInp);

              LNo:=4;

              HFpos[2]:=HFpos[1];

              With HFpos[2] do
              Begin

                X:=X+Len+1;

                Len:=2;

                DiskL:=2;

                ITyp:='B';

                Just:='P';

              end;

              For n:=3 to 4 do
              Begin

                HFpos[n]:=HFpos[n-2];

                With HFpos[n] do
                Begin

                  X:=X+9;

                end;
              end;

            end;

    end; {Case..}

  end; {Proc..}
  *)

  (*
  Function HandValObj.RetFposStr(RepDet  :  ReportDetailType;
                                 Ary     :  Byte)   :  Str30;

  Var
    TmpStr  :  Str30;

  Begin

    TmpStr:='';

    With RepDet do
    Case LType of

      1  :  TmpStr:=DRange[Ary];
      else  TmpStr:=ASCStr[Ary];

    end; {Case..}

    RetFposStr:=TmpStr;

  end;
  *)

  (*
  Procedure HandValObj.FposStr2Det(Var  RepDet  :  ReportDetailType;
                                        Ary     :  Byte;
                                        FStr    :  Str30);

  Begin

    With RepDet do
    Case LType of

      1  :  DRange[Ary]:=FStr;
      else  ASCStr[Ary]:=FStr;

    end; {Case..}

  end; {Proc..}
  *)


  (*
  Function HandValObj.OutPutFpos(RepDet  :  ReportDetailType;
                                 ShowStp :  Boolean)  :  Str80;


  Var
    n  :  Byte;

    TmpStr,
    OutStr
       :  Str80;



  Begin

    TmpStr:='';

    OutStr:='';

    For n:=1 to 2 do
    With RepDet do
    Begin

      If (TmpStr<>'') then
        TmpStr:=TmpStr+' - ';


      Case LType of
        1,4,6..NoInpTypes
             :  Begin

                  OutStr:=RetFposStr(RepDet,n);

                  OutStr:=PPR(OutStr,HFpos[n]);

                end;

        2    :  Begin

                  OutStr:=PPR_Pr(PrRange[n,1],HFpos[1])+'/'+PPR_Yr(PrRange[n,2],HFpos[2]);

                end;
        3    :  Begin

                  OutStr:=PPR(VRange[n],HFpos[n]);

                  OutStr:=Strip('B',[#0],OutStr);

                end;

        5    :  Begin

                  OutStr:=SSymb(CrRange[n]);

                end;

      end; {Case..}

      If (ShowStp) then
        OutStr:=Strip('B',[#32],OutStr);

      TmpStr:=TmpStr+OutStr;

    end; {Loop..}

    OutPutFpos:=TmpStr;


  end; {Func..}
  *)


  (*
  Procedure HandValObj.InputFpos(Var  RepDet   :  ReportDetailType;
                                      CurrLine :  Integer);



  const
    Term : CharSet  =  StdInputSet;

  var

    n     : Byte;
    L,LStart,
    LEnd
          : Integer;

    Lnum  : LongInt;

    TC    : Char;

    DupliFlg
          :  Boolean;

    GenStr:  Str80;

    ScanW :  Windx;


    TmpInp
          :  Array[1..2] of Str30;



  begin

    LStart := 1;

    L:=LStart;

    Lnum:=0;

    LEnd:=Succ(LNo);

    GenStr:='';

    Calc_InpWind(ScanW,CurrLine,LType,LNo);

    PopShadw(ScanW);

    WriteCtrPop(1,ScanW,Copy(' - '+RepInpTypesL^[LType]+' - ',1,ScanW[3]));

    SetColorAtt(DayBkILCol);

    WriteCtrPop(2,ScanW,Copy(RepDet.RepLDesc,1,ScanW[3]-4));

    SetColorAtt(DayBkICol);

    GotoXy(HX,HY); Write(OutPutFpos(RepDet,Off));

    Case LType of

      1,4,6..NoInpTypes
        :  For n:=1 to 2 do
             TmpInp[n]:=RetFposStr(RepDet,n);

    end; {Case..}


    repeat

      MakeWindow(ScanW);

      SetColorAtt(DayBkICol);

      case L of

        1..4  : If (L<=Lno) then
                Begin

                  Case LType of

                    1,4,6..NoInpTypes
                       :   Begin

                             Repeat
                               ProcessInput(TmpInp[L],HFpos[L],Term,Tc);

                               If (Tc<>Esc) and (LType=6) then
                                 TmpInp[L]:=AutoSetInvKey(TmpInp[L],DocLen);

                               If (Not EmptyKey(TmpInp[L],HFPos[L])) then
                               Begin
                                 Case LType of

                                   7,8  :  GetCust(TmpInp[L],On,Off,TradeCode[(LType=7)]);

                                   9    :  Begin
                                             GetNom(TmpInp[L],Lnum,99);
                                             If (Ok) then
                                               TmpInp[L]:=Form_Int(Lnum,0);
                                           end;

                                   10   :  GetStock(TmpInp[L],TmpInp[L],99);

                                   11,12:  GetCCDep(TmpInp[L],TmpInp[L],(Ltype=11),0);

                                   else    Ok:=On;

                                 end; {Case}
                               end
                               else
                                 Ok:=On;

                             Until (Tc=Esc) or (Ok);

                             ProcessOutput(TmpInp[L],HFpos[L]);

                            end;

                    2  :   With RepDet do
                           Begin


                             If (L In [1,3]) then
                               ProcessInput_Pr(PrIRange[L],HFpos[L],Term,Tc)
                             else
                               ProcessInput_Yr(PrIRange[L],HFpos[L],Term,Tc);

                            end;

                    3  :   With RepDet do
                           Begin

                             ProcessInput(VRange[L],HFpos[L],Term,Tc);

                             ProcessOutput(VRange[L],HFpos[L]);


                            end;

                    5  :   With RepDet do
                           Begin

                             ProcessInput(CrRange[L],HFpos[L],Term,Tc);

                             OutCurr(CrRange[L],HFpos[L]);

                            end;

                  end; {Case..}

                end
                else
                  Tc:=^M;



      end;

      L:=Inp_Loop(L,LStart,LEnd,Tc);


    until (TC In [Esc,F9]) or ((Tc In [^M]) and (L=LStart));


    If (Tc<>Esc) then
    Begin
      Case LType of

        1,4,6..NoInpTypes
          :  For n:=1 to 2 do
               FposStr2Det(RepDet,n,TmpInp[n]);

      end; {Case..}

    end;

    RmWin;

  end;
*)



  (*
  Procedure HandValObj.SetDefault(Var RepDet  :  ReportDetailType);


  Begin

    With RepDet do
    Case LType of

      1  :  Begin

              DRange[1]:=Today;
              DRange[2]:=Today;

            end;

      2  :  Begin
              PrRange[1,1]:=Syss.CPr;
              PrRange[2,1]:=Syss.CPr;
              PrRange[1,2]:=Syss.CYr;
              PrRange[2,2]:=Syss.CYr;
            end;
      else
            Blank(VarSubSplit,Sizeof(VarSubSplit));


    end; {Case..}

  end; {Proc..}
  *)



  Function HandValObj.GetInpValue(RepDet  :  ReportDetailType;
                                  SubNo,
                                  SubSubNo:  Byte;
                              Var VType   :  Byte)  :  Str80;


  Var
    TStr  :  Str80;

  Begin

    TStr:='';

    With RepDet do
    Case LType of

      1  :  Begin

              TStr:=DRange[SubNo];

              VType:=4;

            end;

      4,6..NoInpTypes
         :  Begin

              TStr:=ASCStr[SubNo];

              VType:=1;

            end;
      2  :  Begin

              If (SubSubNo=0) then
              Begin
                { HM 25/01/99: Modified to use 3 digit years as was causing index to fail in y2k }
                {TStr:=Form_Int(PrRange[SubNo,2],0)+Form_Int(PrRange[SubNo,1],0);}
                TStr:=SetPadNo(Form_Int(PrRange[SubNo,2],0),3)+SetPadNo(Form_Int(PrRange[SubNo,1],0),2);

                VType:=1;
              end
              else
              Begin
                TStr:=Form_Int(PrRange[SubNo,SubSubNo],0);

                If (SubSubNo=1) then
                  Vtype:=10
                else
                  Vtype:=8;
              end;

            end;

      3  :  Begin

              TStr:=Form_Real(VRange[SubNo],0,3);

              VType:=3;

            end;

      5  :  Begin

              TStr:=Form_Int(CrRange[SubNo],0);

              VType:=9;

            end;

    end; {Case..}

    GetInpValue:=TStr;

  end; {Func..}


  { ========= Function to Return if Itype is a value ======== }

  Function Is_Val(IT  :  Byte)  :  Boolean;

  Begin

    Is_Val:=(IT In ITypValSet);

  end; {Func..}

end. {Unit..}