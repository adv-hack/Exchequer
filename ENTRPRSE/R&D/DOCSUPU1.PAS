Unit DocSupU1;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 09/08/90                      }
{                                                              }
{                     General List Controller                  }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses

  GlobVar,
  VARRec2U,
  VarConst,
  BtrvU2;




{$IFDEF STK}


  Function  CreateStkHed(GetHed  :  Boolean;
                         StkCode :  Str20;
                         MaxLen  :  Byte)  :  Str255;

{$ENDIF}




Function  CreateNomHed(GetHed  :  Boolean;
                       NomNum  :  Longint;
                       MaxLen  :  Byte)  :  Str255;


Function Get_StaChkDate(InvR  :  InvRec) :  LongDate;

Procedure MasterAged(Var AgedAry  :  AgedTyp;
                           AgedDate,
                           AsAtDate :  LongDate;
                           Amount   :  Real;
                           DrvMode  :  Byte;
                           Interval :  Integer);

Function  CustBal_OS(CustCode  :  Str10;
                     CSupp     :  Char;
                     CustBal   :  Real;
                     CompDate  :  LongDate)  :  Boolean;


Function Match_WildChar(WStr,
                        FStr     :   Str255;
                        AsIs,
                        MatchBlnk:   Boolean)  :  Boolean;


Function Pr_Interval(AutoIncx  :  Char;
                     AutoInc   :  Integer)  :  Str10;

Function Pr_Autodue(InvR    :  InvRec)  :  Str10;




Type
  ExtDocRecPtr    =   ^ExtDocRec;

  ExtDocRec       =   Record

                        FDocType    :  Str10;

                        FRunNo      :  LongInt;

                      end;


  FilterType1        =  Record    {* Nominal Code & CC or Dep *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    String[3];
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterType2        =  Record    {* Nominal Code & CC & Dep *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    CCDepType;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterType3        =  Record    {* RunNo & Nominal Code & CC or Dep *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    LongInt;
    Term3            :    FilterRepeatType;
    Compare3         :    String[3];
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterType4        =  Record    {* RunNo & Nominal Code & CC & Dep *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    LongInt;
    Term3            :    FilterRepeatType;
    Compare3         :    CCDepType;
    ExtendTail       :    ExtendRepeatType;

  end;

  FilterType5        =  Record    {* CC or Dep *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    String[3];
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterType6        =  Record    {* Doc Run No & Our Ref *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;

  FilterType         =  Record

    Case Integer of

      1  :  (Filter1 :  FilterType1);
      2  :  (Filter2 :  FilterType2);
      3  :  (Filter3 :  FilterType3);
      4  :  (Filter4 :  FilterType4);
      5  :  (Filter5 :  FilterType5);
      6  :  (Filter6 :  FilterType6);

  end;


  SearchPtr          =  ^SearchRecType;

  SearchRecType      =  Record

    Case Integer of

      1  :  (Filter  :  FilterType);
      2  :  (ExtRec  :  ResultRecType);

  end; {Rec..}




  GetExObj  =  ^ExtSObj;

  ExtSObj   =  Object

                 SearchRec  :  SearchPtr;

                 Constructor  Init;

                 Destructor   Done;

                 Procedure Prime_InitRec(Var  ExtendHead  :  ExtendGetDescType;
                                         Var  ExtendTail  :  ExtendRepeatType;
                                              FileNum     :  Integer;
                                              FiltSize    :  Integer);


                 Function  GetSearchRec(B_Func,
                                        Fnum,
                                        Keypath    :  Integer;
                                        DataLen    :  Integer;
                                    Var GSearchRec :  SearchPtr;
                                    Var KeyS       :  Str255) :  Integer;

               end; {Object..}


  { --------------------------------------- }


  GetExtDocHist=  ^Doc1ExtSObj;

  Doc1ExtSObj  =  Object(ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetDocObj1(Var SetSearchRec  :  SearchPtr;
                                             Fnum          :  Integer;
                                             FDocTyp       :  Char);





                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FDocTyp   :  Char) :  Integer;

               end; {Object..}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   ETMiscU,
   ETStrU,
   ETDateU,
   ComnUnit,
   ComnU2,
   CurrncyU,
   BTKeys1U,
   BTSupU1,
   InvListU;


   Const
  NoExtTries  =  10; {* Number of times a get extended reject count status is retried *}
                     {* Number will be x 65535 records for each try *}
                     {* This value also needs changing in JHISTDDU *}
                     {* This value also needs changing in Recon3U *}




{ ========= Function to create printable Nominal Heading ========= }

Function  CreateNomHed(GetHed  :  Boolean;
                       NomNum  :  Longint;
                       MaxLen  :  Byte)  :  Str255;

Const
  ErrMsg  =  '***** ERROR! Unknown Heading... *****';

Var
  LOk  :  Boolean;

Begin

  If (GetHed) then
    LOk:=GetNom(Application.MainForm,Form_Int(NomNum,0),NomNum,-1)
  else
    LOk:=BOn;


  With Nom do
  Begin
    If (Not LOk) then
      Desc:=ErrMsg;

    CreateNomHed:=Copy('('+Form_Int(NomCode,0)+') '+Strip('B',[#32],Desc),1,MaxLen);
  end; {With..}
end; {Func..}



{$IFDEF STK}

  { ========= Function to create printable Stock Heading ========= }

  Function  CreateStkHed(GetHed  :  Boolean;
                         StkCode :  Str20;
                         MaxLen  :  Byte)  :  Str255;

  Const
    //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Reduced length of msg to avoid warning (This function doesn't seem to
    //                                      be called from anywhere)
    ErrMsg  =  '**** ERROR! Unknown Heading... ****';

  Var
    LOk  :  Boolean;

  Begin

    If (GetHed) then
      LOk:=GetStock(Application.MainForm,StkCode,StkCode,-1)
    else
      LOk:=BOn;


    With Stock do
    Begin
      If (Not LOk) then
        Desc[1]:=ErrMsg;

      CreateStkHed:=Copy('('+Strip('B',[#32],StockCode)+') '+Strip('B',[#32],Desc[1]),1,MaxLen);
    end; {With..}
  end; {Func..}


{$ENDIF}




  { ====== Func to Return Inv Date or Due Date depending on Sys Setup ====== }


  Function Get_StaChkDate(InvR  :  InvRec) :  LongDate;

  Begin

    With InvR do
      If ((Syss.StaUIDate) and (InvDocHed In SalesSplit)) or ((Syss.PurchUIDate) and (InvDocHed In PurchSplit)) then
        Get_StaChkDate:=TransDate
      else
        Get_StaChkDate:=DueDate;
  end;


      { ======= Function to Return Variable Aged ======= }


  Function Compare_Dates(ToDate,DlDate  :  Str8;
                         DrvMode        :  Byte)  :  LongInt;


  Var
    Res  :  LongInt;


  Begin
    Res:=0;

    Case DrvMode of

      1  :  Res:=NoDays(Todate,DlDate);

      2  :  Res:=Round(DivwChk(NoDays(ToDate,DlDate),7));

      else
            Res:=MonthDiff(ToDate,DlDate);

    end;


    Compare_Dates:=Res;

  end; {Func..}



  { ===== Procedure to Return Ageing Based upon Inteval ===== }


  Procedure MasterAged(Var AgedAry  :  AgedTyp;
                           AgedDate,
                           AsAtDate :  LongDate;
                           Amount   :  Real;
                           DrvMode  :  Byte;
                           Interval :  Integer);



  Var
    Diff  :  Integer;

    RDiff :  Real;


  Begin

    If (Interval=0) then
      Interval:=1;

    RDiff:=DivWChk(Compare_Dates(AgedDate,AsAtDate,DrvMode),Interval);

    If (RDiff<0) then {* modded as otherwise slightly not due items treated as this month *}
      Diff:=-1
    else
      Diff:=Trunc(RDiff);

    Case Diff of

       0..3    :  AgedAry[Diff+1]:=AgedAry[Diff+1]+Amount;

       else       If (Diff>=0) then
                    AgedAry[5]:=AgedAry[5]+Amount
                  else
                    AgedAry[0]:=AgedAry[0]+Amount;

    end;

    If (Diff>=0) then
      AgedAry[6]:=AgedAry[6]+Amount;

    AgedAry[7]:=AgedAry[6]+AgedAry[0];

  end; {Procedure..}


{ ======== Procedure to Scan Customer Ledger in Reverse Order, & Return True if O/S Items found ======== }
{ == Replicated in ReportU, TStaReport, for thread safety == }

Function  CustBal_OS(CustCode  :  Str10;
                     CSupp     :  Char;
                     CustBal   :  Real;
                     CompDate  :  LongDate)  :  Boolean;


Const
  Fnum    =  InvF;
  Keypath =  InvCDueK;


Var
  FoundOk :  Boolean;

  KeyS,
  KeyChk
          :  Str255;


Begin
  KeyChk:=CSupp+FullCustCode(CustCode);

  KeyS:=KeyChk+NdxWeight;

  FoundOk:=((Syss.UpBalOnPost) and (CustBal<>0));

  If (Not FoundOk) then
  Begin

    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not FoundOk) do
    Begin
      {$IFDEF Mc_On}

        FoundOk:=((CurrencyOS(Inv,BOn,BOff,BOff)<>0) and (Not(Inv.InvDocHed In QuotesSet))
                 and ((Get_StaChkDate(Inv)<=CompDate) or (Syss.IncNotDue)));

      {$ELSE}

        FoundOk:=((BaseTotalOS(Inv)<>0) and (Not(Inv.InvDocHed In QuotesSet))
                 and ((Get_StaChkDate(Inv)<=CompDate) or (Syss.IncNotDue)));

      {$ENDIF}

      If (Not FoundOk) then
        Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    end; {While..}
  end; {If Found..}

  CustBal_OS:=FoundOk;

end; {Func..}



{ ======= Function to return a match based on wild chars ===== }


Function Match_WildChar(WStr,
                        FStr     :   Str255;
                        AsIs,
                        MatchBlnk:   Boolean)  :  Boolean;



Var
  Sl,n,
  WSl   :  Byte;

  FOk   :  Boolean;



Begin

  Sl:=Length(FStr);

  WSl:=Length(WStr);

  If (Sl>WSl) then   {* Set to shortest length *}
    Sl:=WSl;

  If (Not AsIs) then
  Begin
    WStr:=UpCaseStr(WStr);
    FStr:=UpCaseStr(FStr);
  end;


  FOk:=((WSL<>0) or ((MatchBlnk) and (Strip('B',[#32],FStr)='')));

  n:=1;

  While (n<=Sl) and (Fok) do
  Begin

    FOk:=((WStr[n]=FStr[n]) or (FStr[n] In WildChars));

    Inc(n);

  end; {While..}


  Match_WildChar:=FOk;

end; {Func..}




{ ================================================= }

{  Automatic Daybook Entry Control                  }

{ ================================================= }



{ ================ Display Next Due Date =============== }

Function Pr_Autodue(InvR    :  InvRec)  :  Str10;

Var
  DumStr   :  Str10;



Begin
  DumStr:='';


  With InvR do
  Begin
    Case AutoIncBy of
      PeriodInc   :  DumStr:=PPr_PR(ACPr)+'/'+Form_Int(TxLateYrVal(ACYr,BOff),4);

      DayInc      :  DumStr:=PoutDate(TransDate);

    end; {Case..}

    Pr_AutoDue:=DumStr;
  end; {With..}
end; {Func..}


{ ================= Function to Show Interval =============== }

Function Pr_Interval(AutoIncx  :  Char;
                     AutoInc   :  Integer)  :  Str10;

Var
  DumStr  :  Str10;

Begin
  DumStr:=Form_Int(AutoInc,3);

  Case AutoIncx  of
    PeriodInc  :  DumStr:=DumStr+'per';
    DayInc     :  DumStr:=DumStr+'day';
  end; {Case..}

  Pr_Interval:=DumStr;


end; {Func..}


{$IFDEF Pf_On}


  { =============== Procedure to Set/ReSet the AutoDates ============ }

  Procedure Set_AutoUntil(Var  AutoDate  :  Date;
                          Var  AuYr,AuPr :  Byte;
                          Var  InvR      :  InvRec;
                               SetOn,
                               UntilOn   :  Boolean);



  Begin

    With InvR do
    Case SetOn of

      BOff  :  Begin


                Case UntilOn of

                  BOff  :  Begin

                            AutoDate:=TransDate;

                            AuYr:=AcYr;

                            AuPr:=AcPr;
                          end;

                  BOn   :  Begin

                            AutoDate:=UntilDate;

                            AuYr:=UnYr;

                            AuPr:=UnPr;
                          end;

                end; {Case..}
              end; {BOff..}

      BOn   :  Begin


                Case UntilOn of

                  BOff  :  Begin

                            TransDate:=AutoDate;

                            AcYr:=AuYr;

                            AcPr:=AuPr;
                          end;

                  BOn   :  Begin

                            UntilDate:=AutoDate;

                            UnYr:=AuYr;

                            UnPr:=AuPr;
                          end;

                end; {Case..}
              end; {BOff..}

    end; {Case..}
  end; {Proc..}


{$ENDIF}


  { ExtSObj Methods }



  Constructor ExtSObj.Init;

  Begin

    New(SearchRec);

  end;

  Destructor  ExtSObj.Done;
  Begin

    Dispose(SearchRec);

  end;

  Procedure ExtSObj.Prime_InitRec(Var  ExtendHead  :  ExtendGetDescType;
                                  Var  ExtendTail  :  ExtendRepeatType;
                                       FileNum     :  Integer;
                                       FiltSize    :  Integer);

  Begin

    Prime_Filter(ExtendHead,ExtendTail,FileNum,FiltSize);

  end;



  Function  ExtsObj.GetSearchRec(B_Func,
                                 Fnum,
                                 Keypath    :  Integer;
                                 DataLen    :  Integer;
                             Var GSearchRec :  SearchPtr;
                             Var KeyS       :  Str255) :  Integer;
  Var
    FStatus  :  Integer;
    Tries    :  Byte;
    KeepTrying
             :  Boolean;

    TmpSRec  :  SearchPtr;

  Begin

    Tries:=0;

    KeepTrying:=BOn;

    New(TmpSRec);

    TmpSRec^:=GSearchRec^;  {* Keep local copy of search record structure, as this gets modifed
                               by Btrieve, and if it fails will no longer be valid *}

    Repeat
      FStatus:=Find_VarRec(B_Func,F[Fnum],Fnum,DataLen,GSearchRec^,Keypath,KeyS,nil);

      If (FStatus=0) then
        Move(SearchRec^.ExtRec.ExtendRec,RecPtr[Fnum]^,FileRecLen[Fnum]);

      Inc(Tries);

      KeepTrying:= (FStatus=60) and (Tries<=NoExtTries);

      If KeepTrying then
        GSearchRec^:=TmpSRec^;

    Until (Not KeepTrying);


    Dispose(TmpSRec);


    GetSearchRec:=FStatus;

  end;


{ =========== Doc1ExtSObj  Methods =========== }

  Constructor Doc1ExtSObj.Init;

  Begin

    Inherited Init;

  end;



  Destructor  Doc1ExtSObj.Done;
  Begin

    Inherited Done;

  end;


  Procedure Doc1ExtSObj.SetDocObj1(Var SetSearchRec  :  SearchPtr;
                                       Fnum          :  Integer;
                                       FDocTyp       :  Char);


  Begin
    With SetSearchRec^.Filter.Filter6 do
    Begin
      Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.Filter6));


      With ExtendHead do
      Begin
        NumTerms:=2;
        RejectCount:=65535;
      end;

      With Term1 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare1);

        FieldOffset:=GEIRN;

        CompareCode:=2; {* Compare> *}
        LogicExpres:=1;

        Compare1:=0;

      end;


      With Term2 do
      Begin

        FieldType:=BString;

        FieldLen:=1;

        FieldOffset:=GEIOR;
        CompareCode:=1;  {* Compare= (Ignore case) *}
        LogicExpres:=0;

        Compare2:=FDocTyp;

      end;


    end; {With..}

  end;


  Function  Doc1ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FDocTyp   :  Char) :  Integer;

  Begin

    SetDocObj1(SearchRec,Fnum,FDocTyp);

    GetSearchRec2:=GetSearchRec(B_Func,Fnum,Keypath,(Sizeof(SearchRec^)),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }




end. 