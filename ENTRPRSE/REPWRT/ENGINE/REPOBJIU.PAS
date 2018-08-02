Unit RepObjIU;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
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
     ExBtTh1U,
     {$IFDEF GUI}
     GuiVar,
     {$ENDIF}
     DicLinkU;


Type

  RepLInpPtr   =  ^RepLInpRObj;


  RepLInpRObj  =  Object(List)

                    CurrNode  :  NodePtr;
                    InpField  :  RepFieldPtr;

                    InpHName  :  Str10;

                    {$IFDEF GUI}
                    GetInput     : TGetInputEvent;
                    function GetInp(MTExLocal : tdPostExLocalPtr) : Integer;
                    {$ENDIF}
                    Constructor Init(RunName  :  Str10);

                    Destructor Done;

                    Procedure InitInpFObj(Fnum, Keypath :  Integer;
                                          MTExLocal     :  tdPostExLocalPtr);

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
   {ETDateU,}
   {ExAsvarU,}
   BtrvU2,
   BtSupU1,

   {VarFposU,}
   {InvListU,}
   {ComnUnit,}
   {ComnU2,}
   {SysU1,}

   RepObj1U,

   RwOpenF,
   RpCommon;



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

   HasHasSubNo:=BOff; HasSubNo:=BOff;

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
      CurrNode^.LItem := Nil;

      CurrNode:=GetNext(CurrNode);
    end; {Loop..}

    List.Done;

  end; {Destructor..}


  {* ------------------------ *}


  Procedure RepLInpRObj.InitInpFObj(Fnum, Keypath : Integer;
                                    MTExLocal     : tdPostExLocalPtr);

  Var
    KeyS,
    KeyChk  :  Str255;


  Begin
    With MtExLocal^ Do Begin
      KeyChk:=FullRepKey(ReportGenCode,RepLineTyp,InpHName);

      KeyS:=KeyChk;

      {$IFNDEF GUI}
      LStatus:=LFind_Rec(B_GetGEq,FNum,KeyPath,KeyS);
      {$ELSE}
      LStatus := GetInp(MTExLocal);
      {$ENDIF}

      CurrNode:=GetFirst;

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With LRepGen^ do
      Begin

        Add(New(RepFieldPtr,Init));

        CurrNode:=GetLast;

        InpField:=CurrNode^.LItem;

        With InpField^, RepFieldRec^ do
          RepDet:=ReportDet;

      {$IFNDEF GUI}
        LStatus:=LFind_Rec(B_GetNext,FNum,KeyPath,KeyS);
      {$ELSE}
       LStatus := GetInp(MTExLocal);
      {$ENDIF}

      end; {While..}
    End; { With }
  end;{Proc..}


  {* ------------------------ *}


  Function RepLInpRObj.FindInpObj(VarNo  :  LongInt)  :  Boolean;

  Var
    FoundOk  :  Boolean;


  Begin

    CurrNode:=GetFirst;

    FoundOk:=BOff;

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

  Var
    VarMatch  :  LongInt;

    TStr      :  Str80;

    SubNo,
    SubSubNo  :  Byte;

    InpObjPtr :  Hand_ValIPtr;
  Begin

    TStr:='';

    VarMatch:=0;

    If (VRef[1]=RepInpCode) Then Begin
      VarMatch:=Sub_SplitFmula(VRef,SubNo,SubSubNo,HasErr);

      If (SubNo=0) and (Not HasErr) then {* Brackets missing, assume its item 1 *}
        SubNo:=1;

      If (FindInpObj(VarMatch)) and (Not HasErr) then
        With InpField^, RepFieldRec^ Do Begin
          New(InpObjPtr,Init(3,3,RepDet.RepLIType));

          TStr:=Strip ('R', [#0, #32], InpObjPtr^.GetInpValue(RepDet,SubNo,SubSubNo,VType));

          Dispose(InpObjPtr,Done);
        End; { With }
    End
    Else
      HasErr:=BOn;

    GetInpField:=TStr;

  end; {Func..}


  {* ------------------------ *}
{$IFDEF GUI}
function RepLInpRObj.GetInp(MTExLocal : tdPostExLocalPtr) : Integer;
var
  InpFieldRec : TGUIInputRec;
begin
  Result := 9;
  if Assigned(GetInput) then
     Result := GetInput(InpFieldRec);

  if Result = 0 then
  begin
    with MTExLocal^.LRepGen^ do
    begin
      ReportDet.RepLIType := InpFieldRec.InputType;
      ReportDet.RepVarNo := InpFieldRec.InputNo;
      Move(InpFieldRec.VarSubSplit[0], ReportDet.VarSubSplit[0], 101);
    end;
  end;

end;
{$ENDIF}




end.
