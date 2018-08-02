Unit RepObjIU;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 12/09/94                      }
{                                                              }
{                Rep Input Object Control Unit                 }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     ETMiscU,
     RepObj2U,
     DicLinkU;


Type

  RepLInpPtr   =  ^RepLInpRObj;


  RepLInpRObj  =  Object(List)

                    CurrNode  :  NodePtr;
                    InpField  :  RepFieldPtr;

                    InpHName  :  Str10;


                    Constructor Init(RunName  :  Str10);

                    Destructor Done;

                    Procedure InitInpFObj(Fnum,
                                          Keypath  :  Integer);

                    Function FindInpObj(VarNo  :  LongInt)  :  Boolean;

                    Function GetInpField(VRef   :  Str30;
                                     Var Vtype  :  Byte;
                                     Var HasErr :  Boolean)  :  Str30;

                  end; {Object}


  Function Sub_SplitFmula(VRef  :  Str30;
                      Var SubNo,
                          SubSubNo
                                :  Byte;
                      Var ErrExpr
                                :  Boolean)  :  LongInt;


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
   {InvListU,}
   RpCommon,
   ComnUnit,
   ComnU2,
   SysU1{,
   RepObj1U};



 { ======== Function to SubSplit Variable Expression ====== }

 Function Sub_SplitFmula(VRef  :  Str30;
                     Var SubNo,
                         SubSubNo
                               :  Byte;
                     Var ErrExpr
                               :  Boolean)  :  LongInt;


 Var
   TStr  :  Str20;

   HasSubNo,
   HasHasSubNo
         :  Boolean;

   Lnum  :  LongInt;

   n,m   :  Byte;


 Begin

   TStr:='';

   HasHasSubNo:=False; HasSubNo:=False;

   SubNo:=0;  SubSubNo:=0;

   n:=Pos('[',VRef);

   HasSubNo:=(n<>0);

   If (HasSubNo) then
   Begin

     TStr:=Copy(VRef,2,n-2);

     m:=Pos(',',VRef);

     HasHasSubNo:=(m<>0);

     If (HasHasSubNo) then
     Begin

       Inc(n);

       SubNo:=IntStr(Copy(VRef,n,m-n));

       n:=Pos(']',VRef);

       If (n=0) then
         n:=Length(VRef);

       Inc(m);

       SubSubNo:=IntStr(Copy(Vref,m,n-m));
     end
     else
     Begin
       m:=Pos(']',VRef);

       If (m=0) then
         m:=Length(VRef);

       Inc(n);

       SubNo:=IntStr(Copy(Vref,n,m-n));
     end;
   end
   else
     TStr:=Copy(VRef,2,Pred(Length(VRef)));

   Lnum:=IntStr(TStr);

   ErrExpr:=((Lnum=0) or ((HasSubNo) and (SubNo=0)) or ((HasHasSubNo) and (SubSubNo=0)));

   Sub_SplitFmula:=Lnum;

 end; {Func..}








  { ---------------------------------------------------------------- }

  {  RepLInp Methods }

  { ---------------------------------------------------------------- }


  Constructor RepLInpRObj.Init(RunName  :  Str10);

  Begin

    List.Init;

    CurrNode:=GetFirst;

    InpHName:=RunName;

  end; {Constructor..}


  {* ------------------------ *}


  Destructor RepLInpRObj.Done;

  Begin

    CurrNode:=GetFirst;

    While (CurrNode<>NIL) do
    Begin
      InpField:=CurrNode^.LItem;

      Dispose(InpField,Done);

      CurrNode:=GetNext(CurrNode);
    end; {Loop..}

    List.Done;

  end; {Destructor..}


  {* ------------------------ *}


  Procedure RepLInpRObj.InitInpFObj(Fnum,
                                    Keypath  :  Integer);


  Var
    KeyS,
    KeyChk  :  Str255;


  Begin
    (*
    KeyChk:=FullRepKey(ReportGenCode,RepLineTyp,InpHName);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);

    CurrNode:=GetFirst;

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),Off)) do
    With RepGenRecs^ do
    Begin

      Add(New(RepFieldPtr,Init));

      CurrNode:=GetLast;

      InpField:=CurrNode^.LItem;

      With InpField^ do
      With RepFieldRec^ do
      Begin

        RepDet:=ReportDet;

      end; {With..}

      Status:=Find_Rec(B_GetNext,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);

    end; {While..}
    *)
  end;{Proc..}


  {* ------------------------ *}


  Function RepLInpRObj.FindInpObj(VarNo  :  LongInt)  :  Boolean;

  Var
    FoundOk  :  Boolean;


  Begin

    CurrNode:=GetFirst;

    FoundOk:=False;

    While (CurrNode<>NIL) and (Not FoundOk) and (VarNo<>0) do
    Begin

      InpField:=CurrNode^.LItem;

      FoundOk:=(VarNo=InpField^.RepFieldRec^.RepDet.RepVarNo);

      If (Not FoundOk) then
        CurrNode:=GetNext(CurrNode);

    end; {While..}


    FindInpObj:=FoundOk;

  end; {Func..}


  {* ------------------------ *}

  Function RepLInpRObj.GetInpField(VRef   :  Str30;
                               Var Vtype  :  Byte;
                               Var HasErr :  Boolean)  :  Str30;

  {Var
    VarMatch  :  LongInt;

    TStr      :  Str80;

    SubNo,
    SubSubNo  :  Byte;

    InpObjPtr :  Hand_ValIPtr;}


  Begin
    (*
    TStr:='';

    VarMatch:=0;

    If (VRef[1]=RepInpCode) then
    Begin

      VarMatch:=Sub_SplitFmula(VRef,SubNo,SubSubNo,HasErr);

      If (SubNo=0) and (Not HasErr) then {* Brackets missing, assume its item 1 *}
        SubNo:=1;

      If (FindInpObj(VarMatch)) and (Not HasErr) then
      With InpField^ do
      With RepFieldRec^ do
      Begin
        New(InpObjPtr,Init(3,3,RepDet.RepLIType));

        TStr:=InpObjPtr^.GetInpValue(RepDet,SubNo,SubSubNo,VType);

        Dispose(InpObjPtr,Done);
      end;

    end
    else
      HasErr:=On;

    GetInpField:=TStr;
    *)
  end; {Func..}


  {* ------------------------ *}




end.
