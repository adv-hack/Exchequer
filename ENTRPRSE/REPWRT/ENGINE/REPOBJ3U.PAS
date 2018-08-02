Unit RepObj3U;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 12/09/94                      }
{                                                              }
{                Rep Gen Object Control Unit III               }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses Dialogs,
     GlobVar,
     VarConst,
     ETMiscU,
     RepObj2U,
     ExBtTh1U,
     DicLnk2U;


Type
  RepLHedPtr   =  ^RepLHedRObj;


  RepLHedRObj  =  Object(List)
                    RepDrive  : SmallInt;
                    OrigFile  : SmallInt;

                    ColText   :  ColTextPtrType;

                    CurrNode  :  NodePtr;
                    HedField  :  RepFieldPtr;

                    HedHName  :  Str10;


                    Constructor Init(RunName  :  Str10);

                    Destructor Done;

                    Procedure InitHedFObj(Fnum, Keypath :  Integer;
                                          MTExLocal     :  tdPostExLocalPtr);

                    Function FindHedObj(VarNo  :  LongInt;
                                        BTNo   :  Byte)  :  Boolean;

                    Function HasHed(BtNo  :  Byte)  :  Boolean;

                    Function LinkHedObj(VarNo  :  LongInt;
                                    Var DLinkR :  DictLinkType)  :  Str255;

                    Procedure FillHedObject(BtNo  :  Byte);


                    Function FillHed(BtNo  :  Byte)  :  Str255;

                    Function GetColWidths : ColWidthsType;
                    Procedure FillColText(BtNo  :  Byte);
                  end; {Object}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
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

   VarFposU,
   {InvListU,}
   {ComnUnit,}
   {ComnU2,}
   {SysU1,}
   DicLinkU,

   GlobType,     { from Form Designer - for Link_Dict }

   RwOpenF,
   {RwListU,}
   RpCommon;




  { ---------------------------------------------------------------- }

  {  RepLHed Methods }

  { ---------------------------------------------------------------- }


  Constructor RepLHedRObj.Init(RunName  :  Str10);

  Begin

    List.Init;

    GetMem (ColText, SizeOf (ColText^));
    Blank (ColText^,Sizeof(ColText^));

    CurrNode:=GetFirst;

    HedHName:=RunName;

  end; {Constructor..}


  {* ------------------------ *}


  Destructor RepLHedRObj.Done;

  Begin

    FreeMem (ColText, SizeOf (ColText^));

    CurrNode:=GetFirst;

    While (CurrNode<>NIL) do
    Begin
      HedField:=CurrNode^.LItem;

      Dispose(HedField,Done);
      CurrNode^.LItem:=Nil;

      CurrNode:=GetNext(CurrNode);
    end; {Loop..}

    List.Done;

  end; {Destructor..}


  {* ------------------------ *}


  Procedure RepLHedRObj.InitHedFObj(Fnum, Keypath :  Integer;
                                    MTExLocal     :  tdPostExLocalPtr);


  Var
    KeyD,
    KeyS,
    KeyChk,
    KeyV    :  Str255;
    Want    :  Str20;


  Begin
    With MtExLocal^ Do Begin
      KeyV:='';

      KeyChk:=FullRepKey(ReportGenCode,RepRepCode,HedHName)+RepHedTyp;

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,FNum,KeyPath,KeyS);

      CurrNode:=GetFirst;

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With LRepGen^ do
      Begin

        Add(New(RepFieldPtr,Init));

        CurrNode:=GetLast;

        HedField:=CurrNode^.LItem;

        With HedField^ do
        With RepFieldRec^ do
        Begin

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


            {If (RepDict.VarDec) then    Moved to REPLSP1U so its set at design
                                         time rather than at run time

              Case RepDict.VarDecType of

                1  :  RepDet.NoDecs:=Syss.NoCosDec;

                2  :  RepDet.NoDecs:=Syss.NoNetDec;

                3  :  RepDet.NoDecs:=Syss.NoQtyDec;

              end; Case..}

          end
          else
            RepDict.VarType:=3; {* Set to double type *}

        end; {With..}

        LStatus:=LFind_Rec(B_GetNext,FNum,KeyPath,KeyS);

      end; {While..}
    End; { With }
  end;{Proc..}


  {* ------------------------ *}


  Function RepLHedRObj.FindHedObj(VarNo  :  LongInt;
                                  BTNo   :  Byte)  :  Boolean;

  Var
    FoundOk  :  Boolean;


  Begin

    CurrNode:=GetFirst;

    FoundOk:=BOff;

    While (CurrNode<>NIL) and (Not FoundOk) and (VarNo<>0) do
    Begin

      HedField:=CurrNode^.LItem;

      FoundOk:=((VarNo=HedField^.RepFieldRec^.RepDet.RepVarNo)
              and (BTNo=IntStr(HedField^.RepFieldRec^.RepDet.SortOrd[1])));

      If (Not FoundOk) then
        CurrNode:=GetNext(CurrNode);

    end; {While..}


    FindHedObj:=FoundOk;

  end; {Func..}


  {* ------------------------ *}


  Function RepLHedRObj.HasHed(BtNo  :  Byte)  :  Boolean;

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    FoundOk    :  Boolean;

  Begin
    FoundOk:=BOff;

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) and (Not FoundOk) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^.RepFieldRec^.RepDet do
      Begin

        FoundOk:=(BtNo=IntStr(SortOrd[1]));

      end; {With..}

      If (Not FoundOk) then
        LocalNode:=GetNext(LocalNode);
    end; {While..}

    HasHed:=FoundOk;
  end; {Func..}



  {* ------------------------ *}


  Function RepLHedRObj.LinkHedObj(VarNo  :  LongInt;
                              Var DLinkR :  DictLinkType)  :  Str255;
  Var
    StrRec : fdFormStringsType;
  Begin
    {
    LinkObj:=Link_Dict(VarNo,DLinkR);
    }

    LinkHedObj := Link_Dict(VarNo,
                            DLinkR,
                            StrRec,
                            10,
                            RepDrive,
                            OrigFile,
                            '');

  end; {Func..}


  {* ------------------------ *}


  Procedure RepLHedRObj.FillHedObject(BtNo  :  Byte);

  Var
    LocalNode  :  NodePtr;

    LocalRField:  RepFieldPtr;

    CheckSelect,
    Abort,
    PrSelChk   :  Boolean;

    TStr       :  Str255;

    FErr       :  Byte;

  Begin
    CheckSelect:=BOff;

    FErr:=0;

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

          If (IntStr(RepDet.SortOrd[1])=BtNo) then
          With RepDict do
          Begin
            TStr:=LinkHedObj(VarNo,DLink);

            SetValue(TStr,(Not CheckSelect));
          end;
        end; {With..}

      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

  end; {Proc..}




{* ------------------------ *}


  Function RepLHedRObj.FillHed(BtNo  :  Byte)  :  Str255;

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

    FillHedObject(BtNo);

    LocalNode:=GetFirst;

    While (LocalNode<>NIL) do
    Begin

      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
      If (RepFieldRec^.RepDet.PrintVar) and (IntStr(RepFieldRec^.RepDet.SortOrd[1])=BtNo) then
      Begin

        {If (HStr<>'') then
          SpStr:=' ';

        SetEffect(OnStr,OffStr,RepFieldRec^.RepDet.PrintEff);

        TStr:=OnStr+SpStr+FillField(BOff)+OffStr;}

        TStr:=#9+FillField(BOff);

        HStr:=HStr+TStr;
      end; {With..}

      LocalNode:=GetNext(LocalNode);
    end; {While..}

    FillHed:=HStr;

  end; {Func..}


{* ------------------------ *}


  Function RepLHedRObj.GetColWidths : ColWidthsType;
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
        If PrintVar Then
          With Result[Idx] Do Begin
            Width := MMWidth;
            Just := Format[1];


            Inc (Idx);
          End; { With }

      LocalNode:=GetNext(LocalNode);
    End; {While..}

    Result [0].Width := Idx - 1;
  end; {Proc..}


  { Fills the ColText array with the values to be placed in the columns }
  Procedure RepLHedRObj.FillColText(BtNo  :  Byte);
  Var
    LocalNode  :  NodePtr;
    LocalRField:  RepFieldPtr;
    AutoBlnk   :  Boolean;
  Begin
    AutoBlnk:=BOff;

    LocalNode:=GetFirst;

    Blank (ColText^, SizeOf (ColText^));
    ColText^.NumCols := 0;

    FillHedObject(BtNo);

    While (LocalNode <> NIL) Do Begin
      LocalRField:=LocalNode^.LITem;

      With LocalRField^ do
        If (RepFieldRec^.RepDet.PrintVar) and (IntStr(RepFieldRec^.RepDet.SortOrd[1])=BtNo) then Begin
          Inc (ColText^.NumCols);

          With RepFieldRec^ do
            AutoBlnk:=(((RepDet.Break In [3,4]) or (RepDet.Format='K')) and (LastValue=ThisValue));

            {* Note if using Breakmode which is a global you need to check for one less than
               the normal break mode *}

          With ColText^.Cols[ColText^.NumCols], RepFieldRec^.RepDet Do Begin
            ColVal    := #9+FillField(BOff);
            FontStyle := WinFont.fStyle;
            FontColor := WinFont.fColor;
          End; { With }
        End; { If }

      LocalNode:=GetNext(LocalNode);
    End; { While }
  end; {Func..}



end.
