unit ReBuld1U;

{**************************************************************}
{                                                              }
{        ====----> E X C H E Q U E R Translate <----===        }
{                                                              }
{                      Created : 18/05/2000                    }
{                                                              }
{                                                              }
{                     Common Overlaid Unit                     }
{                                                              }
{               Copyright (C) 2000 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses
  GlobVar,
  VarConst,
  SFHeaderU,
  ProgU;

Function FullNomKey(ncode  :  Longint)  :  Str20;

Function FullNCode(CCode  :  Str10) :  AnyStr;

Function FullIdKey(Ino,Lno  :  Longint)  :  Str20;

Function FullRunNoKey(Rno,Fno  :  Longint)  :  Str20;

Function FullCustCode(CCode  :  Str10) :  AnyStr;

Function IS_PayInLine(PayRef  :  Str20)  :  Boolean;

Function Full_PostPayInKey(SepCh    :  Char;
                           NomCode  :  LongInt;
                           Currency :  Byte;
                           PayRef   :  Str80)  :  Str30;

Function Extract_PayRef2(PayRef  :  Str20)  :  Str10;

Function  PartCCKey (RC,ST        :  Char)  :  Str20;

Function PartNoteKey(RC,ST  :  Char;
                     CCode  :  Str20)  :  Str30;

Function FullJACode(JA  :  Str10)  :  Str10;


Function FullQDKey (RC,ST        :  Char;
                    Login        :  Str30)  :  Str30;

Function Full_SupStkKey(SFol  :  LongInt;
                              SCode :  Str20 )  :  Str30;

Function FullStockCode(CCode  :  Str20)  :  Str20;

Function Full_MLocKey(MLKey  :  Str5)  :  Str5;

Function FullCCDpKey(Code  :  Str20)  :  Str20;

Function FullJDLedgerKey(JC   :   Str10;
                           P,I  :   Boolean;
                           Cu   :   Byte;
                           JD   :   Str8)  :  Str30;

Function FullJBCode(JC    :  Str10;
                      Curr  :  Byte;
                      SCode :  Str20)  :  Str30;

Function FullJRHedKey(JC      :   Str10;
                      IvF     :   Char;
                      RC      :   Byte;
                      DD      :   Str8) :  Str20;

Function PartBankMKey(BNom  :  LongInt;
                      BCr   :  Byte)  :  Str10;


  Function MakeSNKey (SFOL         :  LongInt;
                      Sold         :  Boolean;
                      SNo          :  Str20)  :  Str30;

  Function FullBinCode2(SFOL  :  LongInt;
                        Sold  :  Boolean;
                        Loc   :  Str10;
                        Prity :  Str10;
                        IDate :  LongDate;
                        BC    :  Str10)  :  Str50;

Function Calc_AltStkHCode(NType  :  Char)  :  Char;

Function AutoSetInvKey(InpKey   :  Str255;
                       IKNo     :  Integer)  :  Str255;

  Procedure ResetRec(FNum  :  Integer);

  Procedure SetDataRecOfs(FileNum  :  Integer;
                          Ofset    :  LongInt);

  Function GetPageSize(FileNum  :  Integer)  :  Integer;

Procedure Set_DocAlcStat(Var  InvR  :  InvRec);


Function CheckKey(KeyRef,Key2Chk  :  AnyStr;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;


Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  AnyStr;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;



{ ================= ------------------- =================== }

Function GetNextCount(DocHed     :  DocTypes;
                      Increment,
                      UpLast     :  Boolean;
                      NewValue   :  Real)  :  LongInt;

Function FullDocNum(DocHed    :  DocTypes;
                    Increment :  Boolean)  :  Str20;

Function  SetNextDocORef(DocTyp   :  DocTypes;
                         SetOn    :  Boolean)   :  Str10;

Function SetNextFolioNos(DocTyp   :  DocTypes;
                          SetOn    :  Boolean)  :  LongInt;

Function  SetNextDocFolio(DocTyp   :  DocTypes;
                          SetOn    :  Boolean)   :  LongInt;

Function Set_OrdRunNo(DocHed   :  DocTypes;
                      AutoOn,
                      Posted   :  Boolean)  :  LongInt;

Function FullMatchKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;

  Procedure Open_RepairFiles(Start,Fin  :  Integer;
                             AccelOn,
                             ROMode     :  Boolean;
                             ProgBar
                                      :  TSFProgressBar);

  //PR: 28/11/2017 ABSEXCH-19503 Added EncryptFile parameter
  Procedure Temp_Make(EncryptFile : Boolean = False);

  Function Conv_LSBLnum(Lnum  :  LongInt)  :  LongInt;


  Function  CheckExsists(KeyR  :  AnyStr;
                       FileNum,KeyPath
                             :  Integer)  :  Boolean;


Function  CheckRecExsists(KeyR  :  AnyStr;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;


Function VAT_CashAcc(SCH  :  Char)  :  Boolean;


Function AfterPurge(PYr,
                    Mode   :  SmallInt)  :  Boolean;

Function  UseCoDayRate  :  Boolean;

Function  Conv_Curr(Amount  :  Double;
                    Rate    :  Double;
                    Too     :  Boolean)  :  Double;

Function  Conv_TCurr(Amount  :  Double;
                     Rate    :  Double;
                     RCr     :  Byte;
                     CMode   :  Byte;
                     Too     :  Boolean)  :  Double;

Function  Currency_ConvFT(Amount  :  Double;
                          Fc,Ft   :  Byte;
                          UseRate :  Boolean)  :  Double;

Function ITotal(IRec  :  InvRec)  :  Real;

Function BaseTotalOs(InvR  :  InvRec)  :  Real;

Function CurrencyOS(IRec         :  InvRec;
                    UseRound,
                    SterEquiv,
                    UseCODay     :  Boolean) :  Real;

Procedure DeleteLinksPlus (Code  :  AnyStr;
                           Fnum  :  Integer;
                           KLen  :  Integer;
                           KeyPth:  Integer;
                           NC    :  Char;
                           NK    :  Byte);

Procedure DeleteLinks (Code  :  AnyStr;
                       Fnum  :  Integer;
                       KLen  :  Integer;
                       KeyPth:  Integer);

Procedure Delete_Notes(NoteType  :  Char;
                       NoteFolio :  Str10);

Function Pr2Mnth(Pr  :  Byte)  :  Byte;

Function Pr2Date(PPr,PYr  :  Byte)  :  LongDate;

Function Profit_To_Date(NType        :  Char;
                        NCode        :  Str20;
                        PCr,PYr,PPr  :  Byte;
                    Var Purch,PSales,
                        PCleared     :  Real;
                        Range        :  Boolean)  :  Real;


Const
  StkKeyLen  =  16;
  MLKeyLen   =  03;
  CCDpKeyLen =  03;
  CurPageEnd  =  CUR3;
  GCurPageEnd =  GCU3;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  SysUtils,
  Dialogs,
  Forms,
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  VarFPosU,
  VarRec2U,
  Untils;


Const
  DocKeyLen   =  9;
  CustKeyLen  =  6;
  PIKeyLen    = 10;
  NHCodeLen   = 20;
  BinKeyLen   =  10;

  

{ ========= Function to Return Full Nominal Key ========== }

Function FullNomKey(ncode  :  Longint)  :  Str20;


Var
  TmpStr  :  Str20;

Begin
  Blank(TmpStr,Sizeof(TmpStr));

  Move(ncode,TmpStr[1],Sizeof(ncode));

  TmpStr[0]:=Chr(Sizeof(ncode));

  FullNomKey:=TmpStr;
end;


{ ========= Function to return full uncapitalised STR Longint Equivalent code ======== }

Function FullNCode(CCode  :  Str10) :  AnyStr;

Begin
  FullNCode:=LJVar(Ccode,CustKeyLen);
end;



{ ========= Function to return full uncapitalised STR Longint Equivalent code ======== }

Function FullCustCode(CCode  :  Str10) :  AnyStr;

Begin
  FullCustCode:=LJ(Ccode,CustKeyLen);
end;

{ ========= Function to Return Detail Key Link ========== }

Function FullIdKey(Ino,Lno  :  Longint)  :  Str20;

Begin
  FullIdKey:=Strip('R',[#0],FullNomKey(Ino)+FullNomKey(Lno));
end;

{ ============ Function to determine if line is a paymode line ========== }

Function IS_PayInLine(PayRef  :  Str20)  :  Boolean;

Begin

  IS_PayInLine:=((Length(PayRef)>0) and (PayRef[1] In [PayInCode,PayOutCode]));

end; {Func..}

{ =========== Padded PayInKey =========== }


Function FullPayInKey(RefNo  :  Str20)  :  Str20;

Begin

  FullPayInKey:=LJVar(RefNo,PIKeyLen);

end; {Func..}


{ ========= Function to Return Detail Key/Run No. Link ========== }

Function FullRunNoKey(Rno,Fno  :  Longint)  :  Str20;


Begin
  FullRunNoKey:=FullNomKey(Rno)+FullNomKey(Fno);
end;






Function Pre_PostPayInKey(SepCh  :  Char;
                          RefNo  :  Str80)  :  Str30;

Begin

  Pre_PostPayInKey:=SepCh+FullPayInKey(RefNo);

end; {Func..}


Function Part_PostPayInKey(SepCh    :  Char;
                           NomCode  :  LongInt)  :  Str10;


Begin

  Part_PostPayInKey:=SepCh+FullNomKey(NomCode);

end;



Function Full_PostPayInKey(SepCh    :  Char;
                           NomCode  :  LongInt;
                           Currency :  Byte;
                           PayRef   :  Str80)  :  Str30;



Begin

  Full_PostPayInKey:=Part_PostPayInKey(SepCh,ABS(NomCode))+Pre_PostPayInKey(Chr(Currency),PayRef);

end; {Func..}




{ ============== Function to Extract the PayRef from a completed Key ============== }

Function Extract_PayRef2(PayRef  :  Str20)  :  Str10;

Var
  SepCh     :  Char;
  NomCode   :  LongInt;
  Currency  :  Byte;
  RefNo     :  Str10;


  Count     :  Byte;



  Begin

    Count:=1;

    If (Length(PayRef)=Length(Full_PostPayInKey(#0,0,0,''))) then
    Begin

      SepCh:=PayRef[Count];

      Count:=Count+Sizeof(SepCh);

      Move(PayRef[Count],NomCode,Sizeof(NomCode));

      Count:=Count+Sizeof(NomCode);

      Currency:=Ord(Payref[Count]);

      Count:=Count+Sizeof(Currency);

      RefNo:=Copy(PayRef,Count,Pred(Sizeof(RefNo)));

    end
    else
      RefNo:='';

    Extract_PayRef2:=RefNo;

  end; {Func..}


  Function  PartCCKey (RC,ST        :  Char)  :  Str20;

  Begin
    PartCCKey:=Rc+St;
  end;


   { ========= Function to Return Qty Disc Code ========== }


    Function FullQDKey (RC,ST        :  Char;
                        Login        :  Str30)  :  Str30;

    Begin
      FullQDKey:=PartCCKey(Rc,St)+Login;
    end;


    { ======= Return Full SupStk  ======== }


      Function Full_SupStkKey(SFol  :  LongInt;
                              SCode :  Str20 )  :  Str30;


      Begin

        Full_SupStkKey:=FullNomKey(SFOL)+LJVar(SCode,stkKeyLen);

      end;


      { ==== Return full Stock Code ==== !!!!!!!!!!!!!1 See note above }

  Function FullStockCode(CCode  :  Str20)  :  Str20;

  Begin
    FullStockCode:=LJVar(CCode,StkKeyLen);

  end;


  Function Full_MLocKey(MLKey  :  Str5)  :  Str5;

  Begin

    Full_MLocKey:=LJVar(MLKey,MLKeyLen);

  end; {Func..}


   { ========= Function to Manage Job Anal Code ========== }

  Function FullJACode(JA  :  Str10)  :  Str10;

  Begin

    FullJACode:=LJVar(JA,JobCodeLen);

  end;


  Function FullJAKey (RC,ST        :  Char;
                      Login        :  Str20)  :  Str20;




  Begin
    FullJAKey:=PartCCKey(Rc,St)+FullJACode(Login);
  end;



  Function FullJobCode(JCode  :  Str20)  :  Str20;

  Begin

    FullJobCode:=LJVar(JCode,JobCodeLen);

  end;

  Function FullCCDpKey(Code  :  Str20)  :  Str20;

  Begin

    Result:=LJVar(Code,CCDpKeyLen);

  end;


  { ========= Function to Manage Job Budg Code ========== }

  Function FullJBCode(JC    :  Str10;
                      Curr  :  Byte;
                      SCode :  Str20)  :  Str30;

  Begin

    FullJBCode:=FullJACode(JC)+FullStockCode(SCode)+Chr(Curr);

  end;



  { ======= Job Actual Functions ======== }

   { ======= Job Actual Functions ======== }

  Function FullJDLedgerKey(JC   :   Str10;
                           P,I  :   Boolean;
                           Cu   :   Byte;
                           JD   :   Str8)  :  Str30;


  Begin

    FullJDLedgerKey:=FullJobCode(JC)+Chr(Ord(P))+Chr(Cu)+Chr(Ord(I))+JD;

  end;


Function FullJRHedKey(JC      :   Str10;
                      IvF     :   Char;
                      RC      :   Byte;
                      DD      :   Str8) :  Str20;


Begin

  FullJRHedKey:=FullJobCode(JC)+IvF+Chr(RC)+DD;

end;


Function PartBankMKey(BNom  :  LongInt;
                      BCr   :  Byte)  :  Str10;


Begin

  PartBankMKey:=FullNomKey(BNom)+Chr(BCr)+HelpKStop;

end;


    { ========= Function to MAke SERN Code ========== }


  Function MakeSNKey (SFOL         :  LongInt;
                      Sold         :  Boolean;
                      SNo          :  Str20)  :  Str30;




  Begin

    MakeSNKey:=FullNomKey(SFOL)+Chr(Ord(Sold))+SNo;

  end;

    { == Functions to make Bin Codes == }

  Function FullBinCode(BC  :  Str10)  :  Str10;

  Begin
    Result:=LJVar(UpCaseStr(BC),BinKeyLen);

  end;


    Function FullBinCode2(SFOL  :  LongInt;
                        Sold  :  Boolean;
                        Loc   :  Str10;
                        Prity :  Str10;
                        IDate :  LongDate;
                        BC    :  Str10)  :  Str50;

  Begin
    Result:=FullNomKey(SFOL)+Full_MLocKey(Loc)+Chr(Ord(Sold))+FullBinCode(Prity)+IDate+FullBinCode(BC);

  end;

{ ==============  Function to Return an intelligent guess on finding a document =========== }

Function AutoSetInvKey(InpKey   :  Str255;
                       IKNo     :  Integer)  :  Str255;


Var
  TmpK,TmpNo  :  Str255;
  TmpPrefix   :  Str5;
  LenPrefix   :  Byte;


Begin
  TmpPrefix:='';
  TmpNo:='';

  TmpK:=UpcaseStr(Strip('B',[#32],InpKey));

  LenPrefix:=Length(DocCodes[SIN]);

  TmpPrefix:=Copy(TmpK,1,LenPreFix);

  TmpNo:=Strip('L',['0'],Copy(TmpK,Succ(LenPrefix),(Length(TmpK)-LenPrefix)));

  TmpK:=TmpPrefix+SetPadNo(TmpNo,(9-LenPreFix));

  AutoSetInvKey:=LJVar(TmpK,9);

end; {Function..}



{ =============== Procedure to GetNext Available Number ============== }

Function GetNextCount(DocHed     :  DocTypes;
                      Increment,
                      UpLast     :  Boolean;
                      NewValue   :  Real)  :  LongInt;


Var
  Key2F  :  Str255;
  TmpOk  :  Boolean;
  Lock   :  Boolean;
  TmpStatus
         :  Integer;
  Cnt,NewCnt
         :  LongInt;



Begin
  Lock:=BOff;  Cnt:=0;  NewCnt:=0;

  Blank(Key2F,Sizeof(Key2F));

  Key2F:=DocNosXlate[DocHed];

  TmpStatus:=Find_Rec(B_GetEq,F[IncF],IncF,RecPtr[IncF]^,IncK,Key2F);

  TmpOk:=(TmpStatus=0);

  If (TmpOk) then
  With Count do
  Begin
    Move(NextCount[1],Cnt,Sizeof(Cnt));

    If (Increment)then
    Begin
      NewCnt:=Cnt+IncxDocHed[DocHed];
      Move(NewCnt,NextCount[1],Sizeof(NewCnt));
    end;

    If (UpLast) then
      LastValue:=NewValue;

    If (Increment) or (UpLast) then
      TmpStatus:=Put_Rec(F[IncF],IncF,RecPtr[IncF]^,IncK);

    Report_BError(IncF,TmpStatus);
  end;

  GetNextCount:=Cnt;
end;



{ ========== Return Full DocNum ============= }
{$IFNDEF PREV561001}


  Function FullDocNum(DocHed    :  DocTypes;
                      Increment :  Boolean)  :  Str20;


  Const
    ExtendSuffix  :  Array[0..22] of Char = ('A','B','C','D','E','F','G','H','J','K','L','M','N','P','Q','R','T','U','V','W','X','Y','Z');

  Var
    SIdx
          :  Byte;

    VR    :  Integer;
    Lcnt,
    SVal  :  LongInt;

    SSufix:  Str5;
    StrLnt:  Str255;


  Begin
    LCnt:=0; StrLnt:=''; SSufix:='';

    Lcnt:=GetNextCount(DocHed,Increment,BOff,0);

    Str(Lcnt:0,StrLnt);

    If (Length(StrLnt)>6) then
    Begin
      Val(Copy(StrLnt,1,2),SVal,Vr);

      If (Vr=0) and (SVal<33) and (SVal>=10) then
      Begin
        SSufix:=ExtendSuffix[SVal-10];

        StrLnt:=Copy(StrLnt,3,5);

        Val(StrLnt,SVal,Vr);

        If (Vr=0) then
        Begin
          Str(SVal:0,StrLnt);
        end;

      end;

    end;

    FullDocNum:=DocCodes[DocHed]+SSufix+SetPadNo(StrLnt,(DocKeyLen-Length(DocCodes[DocHed])-Length(SSufix)));
  end;
{$ELSE}

  Function FullDocNum(DocHed    :  DocTypes;
                      Increment :  Boolean)  :  Str20;


  Var
    Lcnt  :  LongInt;
    StrLnt:  Str255;


  Begin
    LCnt:=0; StrLnt:='';

    Lcnt:=GetNextCount(DocHed,Increment,BOff,0);

    Str(Lcnt:0,StrLnt);

    FullDocNum:=DocCodes[DocHed]+SetPadNo(StrLnt,(DocKeyLen-Length(DocCodes[DocHed])));
  end;
{$ENDIF}


Function SetNextFolioNos(DocTyp   :  DocTypes;
                         SetOn    :  Boolean)  :  LongInt;

Var
  FolioTyp  :  DocTypes;


Begin

  If (DocTyp In BatchSet+QuotesSet+StkAdjSplit+PSOPSet+TSTSplit) then
    FolioTyp:=AFL
  else
    FolioTyp:=FOL;

  SetNextFolioNos:=GetNextCount(FolioTyp,SetOn,BOff,0);
end;



{ ======== Procedure to set next doc & Folio Nos ======= }

Function  SetNextDocORef(DocTyp   :  DocTypes;
                         SetOn    :  Boolean)   :  Str10;

Var
  FolioTyp  :  DocTypes;

  NotDupli  :  Boolean;
  UsedInv   :  InvRec;
  NORef     :  Str20;
  NFolio    :  LongInt;


Begin
  NotDupli:=BOn;

  UsedInv:=Inv;
  NORef:='ERROR!';
  NFolio:=0;

  Begin
    Repeat
      NORef:=FullDocNum(DocTyp,SetOn);

      If (SetOn) then
        NotDupli:=(Not CheckExsists(NORef,InvF,InvOurRefK));

    Until (Not SetOn) or (NotDupli);

  end;

  Inv:=UsedInv;

  SetNextDocORef:=NORef;


end;


{ ======== Procedure to set next doc & Folio Nos ======= }

Function  SetNextDocFolio(DocTyp   :  DocTypes;
                          SetOn    :  Boolean)   :  LongInt;

Var
  FolioTyp  :  DocTypes;

  NotDupli  :  Boolean;
  UsedInv   :  InvRec;
  NORef     :  Str20;
  NFolio    :  LongInt;


Begin
  NotDupli:=BOn;

  UsedInv:=Inv;
  NORef:='ERROR!';
  NFolio:=0;

  Begin
    Repeat
      NFolio:=GetNextCount(DocTyp,SetOn,BOff,0);

      If (SetOn) then
        NotDupli:=(Not CheckExsists(Strip('R',[#0],FullNomKey(NFolio)),InvF,InvFolioK));

    Until (Not SetOn) or (NotDupli);

  end;

  Inv:=UsedInv;

  SetNextDocFolio:=NFolio;


end;


{ ======== Function to Return Alternate History Code ======= }

Function Calc_AltStkHCode(NType  :  Char)  :  Char;

Begin

  Calc_AltStkHCode:=Char(Ord(Ntype)+StkHTypWeight);

end;



  { ======= Function to Return Special Order based Run No. ========= }


  Function Set_OrdRunNo(DocHed   :  DocTypes;
                        AutoOn,
                        Posted   :  Boolean)  :  LongInt;


  Var
    Lnum  :  LongInt;


  Begin

    Lnum:=0;


    If (DocHed In PSOPSet) then
    Begin

      If (DocHed In SalesSplit) then
        LNum:=OrdUSRunNo-Ord(AutoOn)-(2*Ord(Posted))
      else
        LNum:=OrdUPRunNo-Ord(AutoOn)-(2*Ord(Posted));

    end;

    Set_OrdRunNo:=Lnum;

  end; {Func..}



Function FullMatchKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;




Begin
  FullMatchKey:=Rc+St+LJVar(Login,DocKeyLen);
end;


Function PartNoteKey(RC,ST  :  Char;
                     CCode  :  Str20)  :  Str30;

Begin

  PartNoteKey:=RC+ST+CCode;

end; {Func..}


{ ====== Set Doc Alloc Status ====== }

Procedure Set_DocAlcStat(Var  InvR  :  InvRec);


Var
  Mode  :  Byte;
  TmpBo :  Boolean;

Begin


  With InvR do
  Begin

    If (InvDocHed In DocAllocSet) then
    Begin
      TmpBo:=(InvDocHed In SalesSplit);

      AllocStat:=TradeCode[TmpBo];

    end
    else
    Begin

      AllocStat:=#0;

    end;

  end; {With..}

end;




{ ================ Procedure to Compare Search Keys ============= }

Function CheckKey(KeyRef,Key2Chk  :  AnyStr;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;

Begin
  If (Length(Key2Chk)>=KeyLen) then
    CheckKey:=(UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs))
  else
    CheckKey:=False;
end;




{ =============== Function to Compare Search Keys by Range ================== }


Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  AnyStr;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;

Begin
  If (KeyRef2='') then
    KeyRef2:=KeyRef;     { Set To Main Compatibility }


  If (Length(Key2Chk)>=KeyLen) then
    CheckKeyRange:=((UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)>=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs)) and
                    (UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)<=UpcaseStrList(Copy(KeyRef2,1,KeyLen),AsIs)))
  else
    CheckKeyRange:=False;
end;






{ ================ Procedure to Reset Current Record ============== }

Procedure ResetRec(FNum  :  Integer);

Begin
  Case Fnum of

   CustF    :  FillChar(Cust,FileRecLen[FNum],0);
   InvF     :  FillChar(Inv,FileRecLen[FNum],0);
   IdetailF :  FillChar(Id,FileRecLen[FNum],0);
   NomF     :  FillChar(Nom,FileRecLen[FNum],0);
   StockF   :  FillChar(Stock,FileRecLen[FNum],0);
   NHistF   :  FillChar(NHist,FileRecLen[FNum],0);
   IncF     :  FillChar(Count,FileRecLen[FNum],0);
   PWrdF    :  FillChar(PassWord,FileRecLen[FNum],0);
   MiscF    :  FillChar(MiscRecs^,FileRecLen[FNum],0);
   JMiscF   :  FillChar(JobMisc^,FileRecLen[FNum],0);
   JobF     :  FillChar(JobRec^,FileRecLen[FNum],0);
   JCtrlF   :  FillChar(JobCtrl^,FileRecLen[FNum],0);
   JDetlF   :  FillChar(JobDetl^,FileRecLen[FNum],0);
   MLocF    :  FillChar(MLocCtrl^,FileRecLen[FNum],0);
   SysF     :  FillChar(Syss,FileRecLen[FNum],0);
   ReportF  :  FillChar(RepScr^,FileRecLen[FNum],0);

  end; {Case..}
end;





{ ============ Low Level Proc to Set Data Record for 4-byte offset ========== }

Procedure SetDataRecOfs(FileNum  :  Integer;
                        Ofset    :  LongInt);

Begin
  Case FileNum  of
   CustF     :  Move(Ofset,Cust,Sizeof(Ofset));
   InvF      :  Move(Ofset,Inv,Sizeof(Ofset));
   IdetailF  :  Move(Ofset,Id,Sizeof(Ofset));
   NomF      :  Move(Ofset,Nom,Sizeof(Ofset));
   StockF    :  Move(Ofset,Stock,Sizeof(Ofset));
   NHistF    :  Move(Ofset,NHist,Sizeof(Ofset));
   IncF      :  Move(Ofset,Count,Sizeof(Ofset));
   PWrdF     :  Move(Ofset,PassWord,Sizeof(Ofset));
   MiscF     :  Move(Ofset,MiscRecs^,Sizeof(Ofset));

   JMiscF    :  Move(Ofset,JobMisc^,Sizeof(Ofset));
   JobF      :  Move(Ofset,JobRec^,Sizeof(Ofset));
   JCtrlF    :  Move(Ofset,JobCtrl^,Sizeof(Ofset));

   JDetlF    :  Move(Ofset,JobDetl^,Sizeof(Ofset));
   MLocF     :  Move(Ofset,MLocCtrl^,Sizeof(Ofset));
   SysF      :  Move(Ofset,Syss,Sizeof(Ofset));
   ReportF   :  Move(Ofset,RepScr^,Sizeof(OfSet));
  end; {Case..}
end;




{ ============ Low Level Proc to Return Pagesize ========== }

Function GetPageSize(FileNum  :  Integer)  :  Integer;

Var
  Inum  :  Integer;

Begin

  Inum:=0;

  Case FileNum  of
   CustF     :  Inum:=CustFile.PageSize;
   InvF      :  Inum:=InvFile.PageSize;
   IdetailF  :  Inum:=IdFile.PageSize;
   NomF      :  Inum:=NomFile.PageSize;
   StockF    :  Inum:=StockFile.PageSize;
   NHistF    :  Inum:=NHFile.PageSize;
   IncF      :  Inum:=CountFile.PageSize;
   PWrdF     :  Inum:=Passfile.PageSize;
   MiscF     :  Inum:=MiscFile^.PageSize;

   JMiscF    :  Inum:=JobMiscFile^.PageSize;

   JobF      :  Inum:=JobRecFile^.PageSize;

   JCtrlF    :  Inum:=JobCtrlFile^.PageSize;

   JDetlF    :  Inum:=JobDetlFile^.PageSize;

   MLocF     :  Inum:=MLocFile^.PageSize;

   SysF      :  With SysFile do
                  Inum:=PageSize;

   ReportF   :  Inum:=RepFile^.PageSize;
  end; {Case..}

  GetPageSize:=Inum;
end;


Procedure Open_RepairFiles(Start,Fin  :  Integer;
                           AccelOn,
                           ROMode     :  Boolean;
                           ProgBar
                                      :  TSFProgressBar);



Const
  NoAttempts     =  100;   {* No of retries before giving up *}
Var
  Choice,NoTrys,
  SetAccel       :  Integer;


  MasterOR       :  Boolean;



Begin
  { =========== Set Accelrated mode ============ }

  SetAccel:=-1*Ord(AccelMode and AccelOn);

  { ====== * ====== }

  If (ROMode) then {* Set Access to RO as this will allow recovery without using preimaging *}
    SetAccel:=-2;

   { =========== Check for SBS Key ========== }

   MasterOR:=SBSIN;


   { =========== Open Files ========== }
{$I-}

    Choice:=Start; Ch:=ResetKey;

    NoTrys:=0;



    If (Check4BtrvOK) then
    While (Choice<=Fin) and (Ch<>#27) do
    Begin

      NoTrys:=0;

      If (Assigned(ProgBar)) then
      Begin
        Application.ProcessMessages;
        ProgBar.ProgLab.Caption:='Checking : '+FileNames[Choice];

      end;

      If (FixFile[Choice].ReBuild) then
      Begin

        FixFile[Choice].FixHed:=BOff;

        Repeat
          Elded:=BOff;

          Status:=Open_File(F[Choice],SetDrive+FileNames[Choice],SetAccel);

          {Show_Bar(Round(DivWChk(NoTrys,NoAttempts)*100),PBarW);}

          If (Status <>0) and (NoTrys>NoAttempts) then
          Begin
            If (Debug) then Status_Means(Status);


            Elded:=BOff;


            Write_FixLog(Choice,'Unable to open file: Report error '+Form_Int(Status,0));

            If (ROMode) then
            Begin
              FixFile[Choice].FixHed:=(Status In [2,14,30,42]);


            end;

            If (Not FixFile[Choice].FixHed) then
            Begin

              FixFile[Choice].ReBuild:=BOff; {* Switch off, as Faulty *}

              If (Not ROMode) then
                Halt
              else
                Elded:=BOn;
            end;
          end
          else
            If (Status=0) then
            begin
              Elded:=BOn;
              //PR: 29/11/2017 ABSEXCH-19503 Check if file is encrypted
              FixFile[Choice].Encrypted := IsFileEncrypted(F[Choice], nil);
            end
            else
              Inc(NoTrys);

        Until (Elded) or (FixFile[Choice].FixHed);
      end; {* If File Chosen *}

      Inc(Choice);

    end {while..}
    else
    Begin
      ShowMessage('Cannot Load Btrieve');

      Halt;
    end;
    Elded:=BOff;
end;



{ ======== Procedure to Make & Open purge files ======== }
//PR: 28/11/2017 ABSEXCH-19503 Added EncryptFile parameter
Procedure Temp_Make(EncryptFile : Boolean = False);

Var
  n           :  Byte;

  SetAccel    :  Integer;

  SFnum       :  Integer;

  EncryptMode : Integer;
Begin

  SFnum:=0;

  SetAccel:=-1*Ord(AccelMode);

  SFnum:=BuildF;

  Status:=Make_File(F[SFnum],SetDrive+FileNames[SFnum],FileSpecOfs[SFnum]^,FileSpecLen[SFnum]);

  If (StatusOk) then
  Begin
    Status:=Open_File(F[SFnum],SetDrive+FileNames[SFnum],SetAccel);

    //PR: 28/11/2017 ABSEXCH-19503 Encrypt file if required
    if EncryptFile then
      EncryptMode := 3
    else
      EncryptMode := 1;

    If (StatusOk) then
      Status:=CtrlBOWnerName(F[SFNUM], BOff, EncryptMode);

  end;

  FixFile[SFnum].ReBuild:=StatusOk;

end;



  { ======= Function to Convert Longint Format to LSB? ======= }

  Function Conv_LSBLnum(Lnum  :  LongInt)  :  LongInt;


  Var
    LB     :  Array[1..4] of LongInt;
    Lnum2  :  LongInt;
    TmpS   :  Str5;


  Begin

    Lnum2:=0;

    Blank(LB,Sizeof(LB));

    Blank(TmpS,Sizeof(TmpS));

    LB[1]:=(Lnum And $FF000000);

    LB[1]:=Round(LB[1]/$1000000);

    LB[2]:=(Lnum And $00FF0000);

    LB[2]:=Round(LB[2]/$10000);

    LB[3]:=(Lnum And $0000FF00);

    LB[3]:=Round(LB[3]/$100);

    LB[4]:=(Lnum And $000000FF);

    TmpS:=Chr(LB[2])+Chr(LB[1])+Chr(LB[4])+Chr(LB[3]);

    Move(TmpS[1],Lnum2,Sizeof(Lnum2));

    Conv_LSBLnum:=Lnum2;
  end;


  { =========== Function to Check Exsistance of Given Code and return record if found ========= }


Function  CheckRecExsists(KeyR  :  AnyStr;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;

Var
  KeyS     :  AnyStr;
  TmpFn    :  FileVar;

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;



Begin
  KeyS:=KeyR;

  TmpFn:=F[FileNum];

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);


  CEStatus:=Find_Rec(B_GetGEq,TmpFn,FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

  If (CEStatus<>0) then
    ResetRec(FileNum);

  CheckRecExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

end;



{ =========== Function to Check Exsistance of Given Code without disturbing record ========= }


Function  CheckExsists(KeyR  :  AnyStr;
                       FileNum,KeyPath
                             :  Integer)  :  Boolean;

Var
  KeyS     :  AnyStr;
  TmpFn    :  FileVar;

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;


Begin
  KeyS:=KeyR;

  TmpFn:=F[FileNum];

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);


  CEStatus:=Find_Rec(B_GetGEq+B_KeyOnly,TmpFn,FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

  CheckExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

end;


{ ================== Procedure to Determine VAT Scheme ================== }

Function VAT_CashAcc(SCH  :  Char)  :  Boolean;

Begin

  VAT_CashAcc:=(SCH=VATSchC);

end;


{ Use Company/Day Rate  - Set to True if Use Xchange rate has been chosen, False if Use Co Rate }

Function  UseCoDayRate  :  Boolean;

Begin
  UseCoDayRate:=(Syss.TotalConv=XDayCode);
end;

{ ========= Function to check after purge year ====== }

Function AfterPurge(PYr,
                    Mode   :  SmallInt)  :  Boolean;


Begin
  Result:=(PYr>Syss.AuditYr) or (Syss.AuditYr=0);
end;

Function XRate(CXRate  :  CurrTypes;
               CurDRte :  Boolean;
               Currency:  Byte)  :  Real;



Var
  Trate  :  Real;


Begin
  Trate:=0;

  With SyssCurr.Currencies[Currency] do
  Begin

    If (CurDRte) then
      Trate:=CRates[BOn]
    else
      If (CXRate[UseCoDayRate]<>0) then
        Trate:=CXRate[UseCoDayRate]
      else
        Trate:=CRates[BOff];
  end; {With..}

  XRate:=Trate;
end; {Func..}




{== Function to return the UseORate flag depending on certain factors ==}


Function fxUseORate(Ignore,
                    ChkXRate:  Boolean;
                    CXRate  :  CurrTypes;
                    UOR,
                    Currency,
                    Mode    :  Byte)  :  Byte;



Begin
  Result:=0;

  If (Not Ignore) then
  Begin
    If (ChkXRate) then {* If rate used not 0, then set flag *}
    Begin
      If (CXRate[UseCoDayRate]<>0.0) then
        Result:=UOR;

    end
    else
      Result:=UOR;
  end;


end;


(*  Convert from one currency to another *)
{ Replicated in EXREBULD\COMNUNIT }



  Function  Conv_Curr(Amount  :  Double;
                      Rate    :  Double;
                      Too     :  Boolean)  :  Double;

  Var
    NewAmnt  :  Double;

  Begin
    NewAmnt:=0.0;

    If (Too) then
      NewAmnt:=Amount*Rate
    else
      If (Rate<>0) then
        NewAmnt:=DivWChk(Amount,Rate);


    Conv_Curr:=NewAmnt;
  end;



Function  Conv_TCurr(Amount  :  Double;
                     Rate    :  Double;
                     RCr     :  Byte;
                     CMode   :  Byte;
                     Too     :  Boolean)  :  Double;

Var
  NewAmnt  :  Double;



Begin
  NewAmnt:=0;

    If (RCr In [0,1]) or ((SyssGCuR^.GhostRates.TriEuro[RCr]=0) and (Not SyssGCuR^.GhostRates.TriFloat[RCr]))
      or (CMode=1) then
    Begin

      If (SyssGCuR^.GhostRates.TriInvert[RCr]) and (CMode<>1) then
        Too:=Not Too;

      NewAmnt:=Conv_Curr(Amount,Rate,Too);


    end
    else
    Begin
      If (SyssGCuR^.GhostRates.TriFloat[RCr]) then
      {* Base is participating so any floating rates must also be done via triangulation *}
      Begin

        If (Too) then
        Begin
          NewAmnt:=Conv_Curr(DivWChk(Amount,SyssGCuR^.GhostRates.TriRates[RCr]),Rate,Not SyssGCuR^.GhostRates.TriInvert[RCr]);

        end
        else
        Begin
          NewAmnt:=Conv_Curr(Amount,Rate,SyssGCuR^.GhostRates.TriInvert[RCr])*SyssGCuR^.GhostRates.TriRates[RCr];

        end;
      end
      else
      Begin
        If (Too) then
        Begin
          NewAmnt:=Conv_Curr(Amount,Rate,Not SyssGCuR^.GhostRates.TriInvert[RCr])*SyssGCuR^.GhostRates.TriRates[RCr];
        end
        else
        Begin
          {* The not part was changed v4.23p as otherwise base equivalent of triangulated currencies was not right *}

          NewAmnt:=Conv_Curr(DivWChk(Amount,SyssGCuR^.GhostRates.TriRates[RCr]),Rate,
                             {Not} SyssGCuR^.GhostRates.TriInvert[RCr]);

        end;
      end;

    end;


  Conv_TCurr:=NewAmnt;
end;


Function  Currency_ConvFT(Amount  :  Double;
                          Fc,Ft   :  Byte;
                          UseRate :  Boolean)  :  Double;

Var
  NewAmnt  :  Double;



Begin
  With SyssCurr.Currencies[Fc] do
    NewAmnt:=Conv_TCurr(Amount,CRates[UseRate],Fc,0,BOff);

  With SyssCurr.Currencies[Ft] do
    Currency_ConvFT:=Conv_TCurr(NewAmnt,CRates[UseRate],Ft,0,BOn);

end;


Function ConvCurrITotal(IRec         :  InvRec;
                        UseDayRate,
                        UseVariance,
                        UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  DP    :  Byte;

Begin
  Rate:=0;  Result:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    Rate:=XRate(CXRate,UseDayRate,Currency);

    Result:=Round_Up(Conv_TCurr(InvNetVal,Rate,Currency,0,BOff),Dp)+
                    Round_Up(Conv_TCurr(InvVat,CXRate[BOn],Currency,0,BOff),Dp)-
                    Round_Up(Conv_TCurr(DiscAmount,Rate,Currency,0,BOff),Dp)+
                    Round_Up((Variance*Ord(UseVariance)),Dp)+
                    Round_Up(ReValueAdj,Dp)-Round_Up((Conv_TCurr(DiscSetAm,Rate,Currency,0,BOff)*Ord(DiscTaken)),Dp)
                    +Round_up(PostDiscAm*Ord(UseVariance),Dp);
  end;

  ConvCurrItotal:=Result;
end;


Function BaseTotalOs(InvR  :  InvRec)  :  Real;


Begin
  With InvR do
  Begin
    If (Not (InvDocHed In QuotesSet)) then
      BaseTotalOs:=Round_Up(((ConvCurrITotal(InvR,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst)-Settled),2)
    else
      BaseTotalOs:=0.0;
  end;
end;


{ =============== Return Invoice Total ============== }

Function ITotal(IRec  :  InvRec)  :  Real;

Begin

  With IRec do
    ITotal:=(InvNetVal+InvVat)-DiscAmount-(DiscSetAm*Ord(DiscTaken));
end;



{ =============== Return Own Currency O/S Total ============== }

Function CurrencyOS(IRec         :  InvRec;
                    UseRound,
                    SterEquiv,
                    UseCODay     :  Boolean) :  Real;

Var
  Rate  :  Real;
  DP,UOR
        :  Byte;

Begin
  Rate:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    If (SterEquiv) then
    Begin
      Rate:=XRate(CXRate,UseCODay,Currency);

      UOR:=fxUseORate(UseCODay,BOn,CXRate,UseORate,Currency,0);
    end
    else
    Begin
      Rate:=1;
      UOR:=0;
    end;

    If (Not (InvDocHed In QuotesSet)) then
    Begin
      If (Not SterEquiv) then
        CurrencyOs:=Round_Up((ITotal(IRec)*DocCnst[InvDocHed]*DocNotCnst)-CurrSettled,Dp)
      else
        CurrencyOs:=Round_Up(Conv_TCurr(((ITotal(IRec)*DocCnst[InvDocHed]*DocNotCnst)-CurrSettled),Rate,Currency,UOR,BOff),Dp);
    end
    else
      CurrencyOs:=0.0;

  end;
end;


Procedure DeleteLinksPlus (Code  :  AnyStr;
                           Fnum  :  Integer;
                           KLen  :  Integer;
                           KeyPth:  Integer;
                           NC    :  Char;
                           NK    :  Byte);

Var
  KeyS,
  KeyN  :  AnyStr;
  Locked:  Boolean;

Begin
  KeyS:=Code;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

                                            {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

  While (Status=0) and (CheckKey(Code,KeyS,KLen,BOn)) do
  Begin

    {Ok:=GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPth,Fnum,On,Locked);

    If (Ok) and (Locked) then}
    Begin
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);

      If (Status=0) and (NC<>#0) and (NK<>0) then
      Begin
        Case NK of
          1  :  KeyN:=FullNomKey(MiscRecs^.SerialRec.NoteFolio);
          else  KeyN:=NDXWeight;
        end; {Case..}

        Delete_Notes(Nc,KeyN);

      end;
    end;


    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


  end;
end;


Procedure DeleteLinks (Code  :  AnyStr;
                       Fnum  :  Integer;
                       KLen  :  Integer;
                       KeyPth:  Integer);


Begin
  DeleteLinksPlus(Code,Fnum,KLen,KeyPth,#0,0);
end;

{ ============= Procedure to Delete Cust / Docs Notes =========== }

Procedure Delete_Notes(NoteType  :  Char;
                       NoteFolio :  Str10);

Const
  Fnum      =  PWrdF;

  Keypath   =  PWk;

Var
  GenStr    :  Str255;


Begin

  GenStr:=PartNoteKey(NoteTCode,NoteType,FullNCode(NoteFolio));

  DeleteLinks(GenStr,Fnum,Length(GenStr),Keypath);

end;


{ =========== Calculate Mnth from Period No. ============ }

Function Pr2Mnth(Pr  :  Byte)  :  Byte;

Var
  TPr  :  Integer;

Begin
  If (Pr>0) then
    Tpr:=Pred(Pr)+Part_Date('M',Syss.MonWk1)
  else
    TPr:=0;

  If (TPr>12) then
    TPr:=(Tpr-12);

  If (TPr>12) then {** Not Monthly Periods! **}
    TPr:=0;

  Pr2Mnth:=TPr;
end;


{ =========== Function to Calculate the Date from the period ========= }

Function Pr2Date(PPr,PYr  :  Byte)  :  LongDate;


Var
  Cm,Cyr,Sm  :  Integer;
  d1,m1,y1,
  d2,m2,y2,

  NoFDays    :  Word;

  n,
  NoPeriods  :  LongInt;


Begin

  n:=0;

  D2:=0;

  If (Syss.PrInYr=12)  then
  Begin
    Sm:=Part_Date('M',Syss.MonWk1);

    Cm:=Pr2Mnth(PPr);

    If (Cm<Sm) then
      PYr:=AdjYr(PYr,BOn);

    Pr2Date:=StrDate(PYr+1900,Cm,01);
  end
  else
  Begin

    NofDays:=Round(DivWChk(365.5,Syss.PrInYr));

    Sm:=Part_Date('Y',Syss.MonWk1)-1900;

    NoPeriods:=Pred(PPr)+((PYr-Sm)*Syss.PrInYr);

    DateStr(Syss.MonWk1,d1,m1,y1);

    If (Syss.PrInYr<52) then {* Still treat monthly *}
    Begin

      Y2:=Y1; M2:=M1; D2:=D1;

      For N:=1 to NoPeriods do
      Begin
        Inc(M2);

        If (M2>12) then
        Begin
          Inc(Y2);
          M2:=1;
        end;
      end;

    end
    else
    Begin

      JulCal(CalJul(d1,m1,y1)+(NoPeriods*NofDays),D2,M2,Y2);

    end;

    Pr2Date:=StrDate(Y2,M2,D2);
  end;
end; {Func..}


{ ========= Function to return full uncapitalised STR Longint Equivalent code ======== }

Function FullNHCode(CCode  :  Str20) :  AnyStr;

Begin
  FullNHCode:=LJVar(Ccode,NHCodeLen);
end;


{ ========= Function to Return Part Nominal History Key ========== }

Function PartNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr   :  Byte)  :  Str30;


Begin
  PartNHistKey:=Typ+FullNHCode(Code)+Chr(Cr);
end;



{ ========= Function to Return Full Nominal History Key ========== }

Function FullNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr,Yr,
                      Pr   :  Byte)  :  Str30;


Begin
  FullNHistKey:=PartNHistKey(Typ,Code,Cr)+Chr(Yr)+Chr(Pr);
end;



{ ============== Get Profit To Current Period ============== }

Function Total_Profit_To_Date(NType        :  Char;
                              NCode        :  Str20;
                              PCr,PYr,PPr  :  Byte;
                          Var Purch,PSales,
                              PCleared,
                              PBudget,
                              PRBudget     :  Real;
                              Range        :  Boolean)  :  Real;


Const
  Fnum  =  NHistF;
  NPath =  NHK;



Var
  NHKey,NHChk,
  NHKey2       :  Str255;
  NYr          :  Integer;
  Bal          :  Real;



Begin
  Purch:=0; PSales:=0; PCleared:=0;  PBudget:=0; Bal:=0; PRBudget:=0;

  NHChK:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

  If (Range) then
  Begin
    NYr:=AdjYr(PYr,BOff);

    If (Nyr<0) then
      NYr:=0;

    NHKey:=FullNHistKey(NType,NCode,PCr,NYr,YTD);
  end
  else
    NHKey:=NHChk;

  If (NType In YTDSet+[NomHedCode,CustHistCde,CustHistPCde]) and (Range) then  {** Get Last Valid YTD **}
  Begin
    NHKey2:=NHKey;
    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey2);

    If (StatusOk) and (CheckKey(NHChk,NHKey2,Length(NHChk)-2,BOn)) and (NHist.Pr=YTD) then
      NHKey:=NHKey2;
  end;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey);


  While (StatusOK) and (NHKey<=NHChk) do
  With NHist do
  Begin

    If ((NType<>CustHistCde) or (Not (Pr In [YTD,YTDNCF]))) then
    Begin
      Purch:=Purch+Purchases;
      PSales:=PSales+Sales;
    end;

    Bal:=Bal+(Purchases-Sales);

    PCleared:=PCleared+Cleared;

    If (Not (Pr In [YTD,YTDNCF])) then
    Begin
      PBudget:=PBudget+Budget;

      PRBudget:=PRBudget+RevisedBudget1;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey);
  end;


  Total_Profit_To_Date:=Bal;

end; {Func..}



{ ============== Get Profit To Current Period ============== }

Function Profit_To_Date(NType        :  Char;
                        NCode        :  Str20;
                        PCr,PYr,PPr  :  Byte;
                    Var Purch,PSales,
                        PCleared     :  Real;
                        Range        :  Boolean)  :  Real;


Var
  PBudget,
  PBudget2  :  Real;


Begin

  PBudget:=0;
  PBudget2:=0;

  Profit_To_Date:=Total_Profit_to_Date(NType,NCode,PCr,PYr,PPr,Purch,PSales,PCleared,PBudget,PBudget2,Range);


end; {Func..}



end.
