Unit JobSup1U;


Interface

Uses GlobVar,
     VarRec2U,
     VarConst,
     Classes;


{ IFNDEF OLE}

Type
  JInvHedRec  =  Record
                   InCurr,
                   DetLev :  Byte;
                   ICCDep :  CCDepType;
                   IJACode,
                   WJACode:  Str10;
                   PrintBS,
                   UseWIP,
                   FinalInv,
                   WIPOnly,
                   WantHed,
                   ChkComm,
                   PostJD,
                   ChkExpRet,
                   UseOrigCCDep
                          :  Boolean;

                   RetInv :  InvRec;

                   TagCost,
                   TagCharge,
                   TotCost
                          :  Double;
                   WIPSDate,
                   WIPEDate
                          :  LongDate;
                   WIPPTarget
                          :  Double;
                   WIPEmpFilt,
                   WIPAccFilt
                          :  Str10;
                   WIPReset
                          :  Boolean;
                end;

Function FullJBKey (RC,ST        :  Char;
                    Login        :  Str30)  :  Str50;

Function FullJBDDKey(JC  :  Str10;
                       MH  :  LongInt)  :  Str20;

Function FullJADDKey(JC  :  Str30;
                       AC,AY,AP
                           :  Byte)  :  Str40;

Function FullJDAnalKey(JC   :   Str10;
                       JA   :   Str10)  :  Str20;

Function FullJDStkKey(JC   :   Str10;
                      JSC  :   Str20)  :  Str30;

Function FullJDHedKey(JC      :   Str10;
                      RN      :   Longint)  :  Str20;

Function FullJRHedKey(JC      :   Str10;
                      IvF     :   Char;
                      RC      :   Byte;
                      DD      :   Str8) :  Str20;

Function FullJRDryKey(JC      :   Str10;
                      IvF     :   Char;
                      DD      :   Str8) :  Str20;

Function FullEmpKey(JA  :  Str10)  :  Str20;

Function FullJobTree(JC,JCat  :  Str10)  :  Str20;

Function Calc_DDKey(JC     :  Str10;
                    JA     :  Str20;
                    JH     :  Byte;
                    Mode,
                    CCur,
                    CYr,
                    CPr    :  Byte)  :  Str255;

Function Ok2DelJob(Mode  :  Integer;
                   JRec  :  JobRecType)  :  Boolean;
{ENDIF}

Function JCCats_TxLate(ANo    :  LongInt;
                       ToCat  :  Boolean)  :  LongInt;

Function HFolio_Txlate(Ano  :  LongInt)  :  LongInt;

{IFNDEF OLE}
Function Major_Hed(n  :  LongInt)  :  Str255;

Function Get_StdPR(ThisCode  :  Str20;
                     Fnum,
                     Keypath,
                     GMode     :  Integer)  :  Boolean;

Function Get_StdPRDesc(ThisCode  :  Str20;
                         Fnum,
                         Keypath,
                         GMode     :  Integer)  :  Str255;

Function Get_BudPayRate(AOWner    :  TComponent;
                    Var ThisCode  :  Str20;
                        Mode,
                        BS,
                        GMode     :  Integer)  :  Boolean;

Function Get_StdPayRate(AOWner    :  TComponent;
                    Var ThisCode  :  Str20;
                        Mode,
                        BS,
                        GMode     :  Integer)  :  Boolean;

Procedure Gen_JMajorHed(JobR     :  JobRecType);


Function Delete_JobDetails(JCode  :  Str10;
                           JType  :  Char;
                           JFolio :  LongInt;
                           DelHist:  Boolean)  :  Boolean;

Function This_YTDHist(NType        :  Char;
                      NCode        :  Str20;
                      PCr,PYr      :  Byte;
                  Var Purch,PSales,
                      PCleared,
                      PBudget,
                      PRBudget     :  Double)  :  Double;

Function Ok2DelJB(Mode  :  Integer;
                  JCR   :  JobCtrlRec)  :  Boolean;

Procedure ReCode_JobBudget(OldJCode,NewJCode  :  Str10);

Function TxLate_CISTypeStr(CIST     :  Byte)  :  Str20;

Function TxLate_CISType(CIST     :  Byte;
                        FromRec  :  Boolean)  :  Byte;

Function XXBeen_Used(Const Mode  :  Byte;
                   Const KeyAC :  Str255)  :  Boolean;

Procedure Update_TaggedWIPBal(Var JICtrl  :  JInvHedRec;
                                  JD      :  JobDetlRec;
                                  Mode    :  Byte;
                                  Deduct  :  Boolean);

Function CIS340  :  Boolean;

Function CISValid_UTR(ChkUTR  :  Str20)  :  Boolean;

Function CISValid_AccOff(ChkUTR  :  Str20)  :  Boolean;

Function CISValid_CoReg(ChkUTR  :  Str20)  :  Boolean;

Function CISValid_NINO(ChkUTR  :  Str20)  :  Boolean;

Function CISValid_VerNo(ChkUTR  :  Str20)  :  Boolean;


{ENDIF}



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   ETStrU,
   ETMiscU,
   VarJCstU,
   BTKeys1U,
   ComnUnit,
   BTSupU1,
   InvListU,
   CurrncyU,

   SysUtils,
   BtrvU2;

{ IFNDEF OLE}
  Function FullJBKey (RC,ST        :  Char;
                      Login        :  Str30)  :  Str50;

  Begin
    FullJBKey:=PartCCKey(Rc,St)+Login;
  end;


  // CJS - 11/02/2010 - Duplicated in SQLRedirectorU.pas
  Function FullJBDDKey(JC  :  Str10;
                       MH  :  LongInt)  :  Str20;


  Begin
    FullJBDDKey:=FullJobCode(JC)+FullNomKey(MH)+HelpKStop;
  end;



  Function FullJADDKey(JC  :  Str30;
                       AC,AY,AP
                           :  Byte)  :  Str40;


  Begin
    FullJADDKey:=JC+Chr(AC)+Chr(AY)+Chr(AP);
  end;



Function FullJDAnalKey(JC   :   Str10;
                       JA   :   Str10)  :  Str20;


Begin

  FullJDAnalKey:=FullJobCode(JC)+FullJACode(JA);

end;


Function FullJDStkKey(JC   :   Str10;
                      JSC  :   Str20)  :  Str30;


Begin

  FullJDStkKey:=FullJobCode(JC)+FullStockCode(JSC);

end;





Function FullJDHedKey(JC      :   Str10;
                      RN      :   Longint)  :  Str20;


Begin

  FullJDHedKey:=FullJobCode(JC)+FullNomKey(RN);

end;


Function FullJRHedKey(JC      :   Str10;
                      IvF     :   Char;
                      RC      :   Byte;
                      DD      :   Str8) :  Str20;


Begin

  FullJRHedKey:=FullJobCode(JC)+IvF+Chr(RC)+DD;

end;


Function FullJRDryKey(JC      :   Str10;
                      IvF     :   Char;
                      DD      :   Str8) :  Str20;


Begin

  FullJRDryKey:=IvF+DD+FullJobCode(JC);

end;


    { ========= Function to Manage Job Anal Code ========== }

  Function FullEmpKey(JA  :  Str10)  :  Str20;

  Begin

    FullEmpKey:=LJVar(JA,EmplKeyLen);

  end;



 { ========= Function to Manage Job Anal Code ========== }

  Function FullJobTree(JC,JCat  :  Str10)  :  Str20;

  Begin

    Result:=FullJobCode(JC)+FullJobCode(JCat);

  end;



{ ===== Function to calculate DD Key for Anal/Stock ===== }

Function Calc_SDDKey(JC     :  Str10;
                     JA     :  Str20;
                     JH     :  Byte;
                     Mode   :  Byte)  :  Str255;


Var
  TmpKey  :  Str255;

Begin

  TmpKey:='';

  Case Mode of


    1,6,13
       :  Begin

            TmpKey:=FullJDAnalKey(JC,JA);

          end;

    2,7,14
       :  Begin

            TmpKey:=FullJDStkKey(JC,JA);

          end;


    5,15
       :  Begin

            TmpKey:=FullJDHedKey(JC,JH);

          end;

  end; {Case..}

  Calc_SDDKey:=TmpKey;

end;



{ ===== Function to calculate DD Key for Anal/Stock ===== }

Function Calc_DDKey(JC     :  Str10;
                    JA     :  Str20;
                    JH     :  Byte;
                    Mode,
                    CCur,
                    CYr,
                    CPr    :  Byte)  :  Str255;


Var
  TmpKey  :  Str255;

Begin

  TmpKey:=Calc_SDDKey(JC,JA,JH,Mode);


  {$IFDEF MC_On}

    If (CCur<>0) and (Mode<13) then
      TmpKey:=TmpKey+Chr(CCur);

  {$ENDIF}


  IF (Mode>=13) then
    TmpKey:=FullJADDKey(TmpKey,CCur,CYr,CPr);

  Calc_DDKey:=TmpKey;

end;



{ ======== Function to Return AnalHeading =========== }


Function Major_Hed(n  :  LongInt)  :  Str255;


Begin
  Result:='';

  If (n=SysAnlsProfit) then
    Result:=SyssJob^.JobSetUp.SummDesc[0]
  else
    If (n In [1..NofSysAnals]) then
      Result:=SyssJob^.JobSetUp.SummDesc[n]
    else
      Result:='Unknown Heading!';


end; {Func..}


  { ====== Wrapper procedure to get details of std payrates ======= }
  {  Reproduced in ReportU for thread safe reports }

  Function Get_StdPR(ThisCode  :  Str20;
                     Fnum,
                     Keypath,
                     GMode     :  Integer)  :  Boolean;


  Var
    LOk         :  Boolean;

    KeyChk,
    KeyS        :  Str255;

  Begin

    KeyChk:=PartCCKey(JBRCode,JBSubAry[3])+FullJBCode(FullNomKey(PRateCode),0,ThisCode);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,JCK,KeyS);

    LOk:=((StatusOk) and (CheckKey(KeyChk,KeyS,Pred(Length(KeyChk)),BOn)));

    Result:=LOk;

  end; {Proc..}


  { ====== Wrapper procedure to get details of std payrates ======= }

  Function Get_StdPRDesc(ThisCode  :  Str20;
                         Fnum,
                         Keypath,
                         GMode     :  Integer)  :  Str255;


  Var
    LOk         :  Boolean;
    TCtrlRec    :  JobCtrlRec;

    TmpStatus   :  Integer;
    TmpRecAddr  :  Longint;

    KeyChk,
    KeyS,
    GenStr      :  Str255;

  Begin

    GenStR:='';

    TmpRecAddr:=0;

    TCtrlRec:=JobCtrl^;

    TmpStatus:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOff,BOff);

    If (Get_StdPR(ThisCode,Fnum,Keypath,GMode)) then
      GenStr:=JobCtrl^.EmplPay.PayRDesc;

    TmpStatus:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOn,BOff);

    JobCtrl^:=TCtrlRec;

    Get_StdPRDesc:=GenStr;

  end; {Proc..}


  { ====== Wrapper procedure to get details of std payrates ======= }

Function Get_BudPayRate(AOWner    :  TComponent;
                    Var ThisCode  :  Str20;
                        Mode,
                        BS,
                        GMode     :  Integer)  :  Boolean;


Var

  TCtrlRec  :  JobCtrlRec;
  LOk       :  Boolean;

Begin


  TCtrlRec:=JobCtrl^;

  LOk:=GetEmpRate(AOWner,FullJACode(FullNomKey(PRateCode))+ThisCode,TCtrlRec.JobBudg.StockCode,GMode,Mode);


  If (LOk) then
  Begin
    TCtrlRec.JobBudg.AnalCode:=JobCtrl^.EmplPay.EAnalCode;

    TCtrlRec.JobBudg.StockCode:=FullStockCode(JobCtrl^.EmplPay.EStockCode);

    With JobCtrl^.EmplPay do
      TCtrlRec.JobBudg.UnitPrice:=Currency_ConvFT(Cost,CostCurr,TCtrlRec.JobBudg.CurrBudg,UseCoDayRate);


    {$IFDEF MC_On}

      TCtrlRec.JobBudg.CurrPType:=JobCtrl^.EmplPay.CostCurr; {* Not used, as budget must be level 0 *}

    {$ENDIF}

  end;

  Result:=LOK;
  ThisCode:=TCtrlRec.JobBudg.StockCode;

  JobCtrl^:=TCtrlRec;

end; {Proc..}


  { ====== Wrapper procedure to get details of std payrates ======= }

Function Get_StdPayRate(AOWner    :  TComponent;
                    Var ThisCode  :  Str20;
                        Mode,
                        BS,
                        GMode     :  Integer)  :  Boolean;


Var

  TCtrlRec  :  JobCtrlRec;
  LOk       :  Boolean;

Begin


  TCtrlRec:=JobCtrl^;

  LOk:=GetEmpRate(AOWner,FullJACode(FullNomKey(PRateCode))+ThisCode,TCtrlRec.EmplPay.EStockCode,GMode,Mode);


  If (LOk) then
  Begin
    TCtrlRec.EmplPay.EAnalCode:=JobCtrl^.EmplPay.EAnalCode;

    TCtrlRec.EmplPay.Cost:=JobCtrl^.EmplPay.Cost;

    TCtrlRec.EmplPay.ChargeOut:=JobCtrl^.EmplPay.ChargeOut;

    TCtrlRec.EmplPay.PayRDesc:=JobCtrl^.EmplPay.PayRDesc;

    {$IFDEF MC_On}

      TCtrlRec.EmplPay.CostCurr:=JobCtrl^.EmplPay.CostCurr;
      TCtrlRec.EmplPay.ChargeCurr:=JobCtrl^.EmplPay.ChargeCurr;


    {$ENDIF}

  end;

  Result:=LOK;

  JobCtrl^:=TCtrlRec;

end; {Proc..}
{ENDIF}

{ == Function to translate the catagory codes == }

Function JCCats_TxLate(ANo    :  LongInt;
                       ToCat  :  Boolean)  :  LongInt;

Const
  ToCatMap  :  Array[SysAnlsRev..NofSysAnals] of LongInt =
               (15,1,14,2,11,3,4,5,12,6,13,7,8,9,10,16,17);

Var
  n  :  Byte;


Begin
  Result:=ANo;

    Case ToCat of
      BOff  :  Begin
                 For n:=Low(ToCatMap) to High(ToCatMap) do
                 Begin
                   If (Ano=ToCatMap[n]) then
                   Begin
                     Result:=n;
                     Break;
                   end;
                 end;
               end;

      BOn   :  Begin
                 If (Ano In [SysAnlsRev..NofSysAnals]) then
                   Result:=ToCatMap[Ano];
               end;
    end; {Case..}


end; {Func..}

{ ====== Function to Translate The major heading folio numbers ==== }

Function HFolio_Txlate(Ano  :  LongInt)  :  LongInt;


Begin


    Case Ano of

      0  :  Result:=SysAnlsProfit;

      1..SysAnlsEnd

         :  Result:=Ano*10;

      SysSubLab
         :  Result:=23;
      SysMat2
         :  Result:=53;
      SysOH2
         :  Result:=63;

      SysDeductSales
         :  Result:=14;

      SysAppSal
         :  Result:=05;
      SysAppPur
         :  Result:=173;

      SysAnlsBal..OrigSysAnals

         :  Result:=(150+((Ano-SysAnlsEnd)*10));  {* ie 160,170,180: 230, 240, 250 *}

      SysDeductPurch
         :  Result:=67;

      else {99 for SysAnlsProfit leave as }

            Result:=Ano;

    end; {Case..}


  HFolio_TxLate:=Result;

end; {Func..}

{IFNDEF OLE}

{ Reproduced in JobPostU for thread safe operation }
{ Reproduced in OLEBtrO for thread safe operation in the OLE Server }

Procedure Set_JMajorHed(JobR     :  JobRecType;
                        n        :  LongInt;
                        Fnum     :  Integer);



Begin
  With JobCtrl^,JobBudg do
  Begin

    ResetRec(Fnum);

    RecPFix:=JBRCode;
    SubType:=JBMCode;

    JobCode:=JobR.JobCode;

    HistFolio:=HFolio_Txlate(n);

    If (n<>0) then
      AnalHed:=n
    else
      AnalHed:=SysAnlsProfit;

    BudgetCode:=FullJBCode(JobCode,CurrBudg,FullNomKey(HistFolio));

    {$IFDEF EX601}
      JBudgetCurr:=JobR.CurrPrice;

    {$ENDIF}

  end; {If Ok..}
end; {Proc..}






{ ====== Proc to Generate a jobs major Heading Lines ======= }

Procedure Gen_JMajorHed(JobR     :  JobRecType);


Const
  Fnum      =  JCtrlF;
  Keypath   =  JCK;



Var
  KeyChk,
  KeyS      :  Str255;

  n         :  LongInt;



Begin


  Status:=0;

  For n:=0 to NofSysAnals do
  Begin

    If (StatusOk) then
    With JobCtrl^,JobBudg do
    Begin

      Set_JMajorHed(JobR,n,Fnum);

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

    end; {If Ok..}

  end; {Loop..}

end; {Proc..}


{ ====== Proc to Generate a jobs major Heading Lines ======= }
{ Reproduced in JobPostU for thread safe operation }
{ Reproduced in OLEBtrO for thread safe operation in the OLE Server }

Procedure Check_JMajorHed(JobR     :  JobRecType);


Const
  Fnum      =  JCtrlF;
  Keypath   =  JCK;



Var
  KeyChk,
  KeyS      :  Str255;

  n         :  LongInt;



Begin


  Status:=0;

  For n:=0 to NofSysAnals do
  Begin

    If (StatusOk) then
    With JobCtrl^,JobBudg do
    Begin

      Set_JMajorHed(JobR,n,Fnum);

      KeyChk:=PartCCKey(JBRCode,JBMCode)+BudgetCode;

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

      If (Not StatusOk) then
      Begin
        Set_JMajorHed(JobR,n,Fnum);

        Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);
      end;

    end; {If Ok..}

  end; {Loop..}

end; {Proc..}



Function Ok2DelJob(Mode  :  Integer;
                   JRec  :  JobRecType)  :  Boolean;

Var
  Purch,
  Sales,
  Cleared  :  Real;

Begin
  Purch:=0; Sales:=0;  Cleared:=0;

  {$B-}

  With JRec do
    Case Mode of

      0,99  :  Ok2DelJob:=((Not CheckExsists(JobCode,JobF,JobCatK))
                        and (Not CheckExsists(PartCCKey(JBRCode,JBECode)+JobCode,JDetlF,JDLedgerK)));

      else   Ok2DelJob:=((JobStat=5) or (Not CheckExsists(PartCCKey(JBRCode,JBECode)+JobCode,JDetlF,JDLedgerK))
                         and (Not CheckExsists(JobCode,JobF,JobCatK)));

    end; {Case..}

  {$B+}
end;


{ ========= Routines to Delete a job and all asociated files ======= }

Function Delete_JobDetails(JCode  :  Str10;
                           JType  :  Char;
                           JFolio :  LongInt;
                           DelHist:  Boolean)  :  Boolean;


Const
  Fnum2      =  JCtrlF;
  Keypath2   =  JCK;
  Fnum3      =  JDetlF;
  Keypath3   =  JDLedgerK;

  LoopCtrl  :  Array[1..5] of Char  =  (JBSCode,JBBCode,JBMCode,JBECode,JBPCode);

Var
  Loop  :  Byte;

  KeyChk,
  KeyS  :  Str255;

  Fnum,
  Keypath
        :  Integer;


Begin

  Result:=BOn;

  Fnum:=Fnum2;

  Keypath:=Keypath2;

  Loop:=1;

  Repeat

    KeyChk:=PartCCKey(JBRCode,LoopCtrl[Loop])+JCode;

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    Begin

      Application.ProcessMessages;

      Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

      Report_BError(Fnum,Status);

      Result:=(Result and StatusOk);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);


    end; {While..}


    Inc(Loop);

    If (Loop=4) then
    Begin

      Fnum:=Fnum3;

      Keypath:=KeyPath3;

    end;


  Until (Loop>5);

  If (Result) and (DelHist) then
  Begin

    KeyChk:=JType+JCode;

    DeleteLinks(KeyChk,NHistF,Length(KeyChk),NHK,BOff);

  end;

  Delete_JobDetails:=Result;


end; {Proc..}


{ ========= Routines to Change a job code and all asociated files ======= }

Procedure ReCode_JobBudget(OldJCode,NewJCode  :  Str10);


Const
  Fnum      =  JCtrlF;
  Keypath   =  JCK;

  LoopCtrl  :  Array[0..2] of Char  =  (JBMCode,JBBCode,JBSCode);

Var
  Loop  :  Byte;

  KeyChk,
  KeyS  :  Str255;


Begin

  Loop:=0;

  Repeat

    KeyChk:=PartCCKey(JBRCode,LoopCtrl[Loop])+FullJobCode(OldJCode);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With JobCtrl^.JobBudg do
    Begin
      Application.ProcessMessages;

      JobCode:=NewJCode;

      Case Loop of
        0  :  BudgetCode:=FullJBCode(JobCode,CurrBudg,FullNomKey(HistFolio));

        1  :  Begin
                BudgetCode:=FullJBCode(JobCode,CurrBudg,AnalCode);

                Code2NDX:=FullJBDDKey(JobCode,AnalHed); {* To enable Drill down to analysis level *}
              end;

        2  :  Begin
                BudgetCode:=FullJBCode(JobCode,CurrBudg,StockCode);

                Code2NDX:=FullJDAnalKey(JobCode,AnalCode); {* To enable Drill down to analysis level *}

              end;
      end; {Case...}


      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);


    end; {While..}


    Inc(Loop);


  Until (Loop>High(LoopCtrl));


end; {Proc..}




Function This_YTDHist(NType        :  Char;
                      NCode        :  Str20;
                      PCr,PYr      :  Byte;
                  Var Purch,PSales,
                      PCleared,
                      PBudget,
                      PRBudget     :  Double)  :  Double;

Var
  LPurch,TPurch,
  LSales,TSales,
  LCleared,TCleared,
  TBudget,LBudget,
  TBudget2,LBudget2,

  LBal,TBal,

  Dnum1,
  Dnum2      :   Double;


  LYr        :   Byte;



Begin

  LPurch:=0; LSales:=0; LCleared:=0; LBudget:=0; LBudget2:=0;

  LBal:=0; Dnum1:=0; Dnum2:=0;

  If (NType In YTDSET) then
  Begin

    LYr:=AdjYr(PYr,BOff);

    LBal:=Total_Profit_To_Date(Ntype,NCode,PCr,LYr,YTD,LPurch,LSales,LCleared,LBudget,LBudget2,Dnum1,Dnum2,BOff);


  end;


  TBal:=Total_Profit_To_Date(Ntype,NCode,PCr,PYr,YTD,TPurch,TSales,TCleared,TBudget,TBudget2,Dnum1,Dnum2,BOff);


  If (TBal<>0) then
    Result:=TBal-LBal
  else
    Result:=LBal;

  If (TPurch<>0) then
    Purch:=TPurch-LPurch
  else
    Purch:=LPurch;

  If (TSales<>0) then
    PSales:=TSales-LSales
  else
    PSales:=LSales;

  If (TCleared<>0) then
    PCleared:=TCleared-LCleared
  else
    PCleared:=LCleared;

  If (TBudget<>0) then
    PBudget:=TBudget-LBudget
  else
    PBudget:=LBudget;

  If (TBudget2<>0) then
    PRBudget:=TBudget2-LBudget2
  else
    PRBudget:=LBudget2;


  This_YTDHist:=Result;

end; {Func..}



{ == Function to determine if any actuals exist with this Anal/Stock Code == }

Function BudBeen_Used(Const  Mode  :  Byte;
                      Const  JCode :  Str10;
                             KeyAC :  Str30)  :  Boolean;


Const
  Fnum  =  JDetlF;


Var
  KeyChk  :  Str255;
  KeyPath :  Integer;


Begin

  
  Case Mode of

    1,6
       :  Begin
            KeyPath:=JDAnalK;
            KeyChk:=PartCCKey(JBRCode,JBECode)+FullJDAnalKey(JCode,KeyAC);
          end;

    2,7
       :  Begin
            KeyPath:=JDStkK;
            KeyChk:=PartCCKey(JBRCode,JBECode)+FullJDStkKey(JCode,KeyAC);
          end;
    else
      raise Exception.Create('Unknown Mode in JobSup1U.BudBeen_Used: ' + IntToStr(Mode));
  end; {Case..}


  BudBeen_Used:=CheckExsists(KeyChk,Fnum,Keypath);

end; {Func..}


{ ================ Delete Help Item ============ }

Function Ok2DelJB(Mode  :  Integer;
                  JCR   :  JobCtrlRec)  :  Boolean;


Begin

  Case Mode of


    1,6
          :  With JCR.JobBudg do
               Ok2DelJB:=(Not BudBeen_Used(Mode,JobCode,AnalCode));  {Check if they have any actual postings}

    2,7
          :  With JCR.JobBudg do
               Ok2DelJB:=(Not BudBeen_Used(Mode,JobCode,StockCode));  {Check if they have any actual postings}

    {3     :  Ok2DelJB:=(Not Been_Used(Mode,JCR.EmplPay.EStockCode));}

    4     :  Ok2DelJB:=BOn;

    else     Ok2DelJB:=BOff;

  end; {Case..}


end;


{ == Function to Return CIS Type String == }

Function TxLate_CISTypeStr(CIST     :  Byte)  :  Str20;

Begin
  Result:='N/A';

  If (CurrentCountry=IECCode) then
  Begin
    Case CIST of

      1  :  Result:='No C2/RCT47';
      2  :  Result:='C2 & RCT47';
    end; {Case..}
  end
  else
  Begin
    Case CIST of
      1  :  Result:='High (T)';
      2  :  Result:='Zero';
      3  :  Result:='CIS 6';
      4  :  Result:='Low (C)';
      5  :  Result:='CIS 5 Partner';

    end; {Case..}
  end;
end;

{ == Function to txlate CIS Types == }

Function TxLate_CISType(CIST     :  Byte;
                        FromRec  :  Boolean)  :  Byte;

Begin
  Result:=0;

  Case FromRec of
     BOff  :  Begin
                If (CurrentCountry=IECCode) then
                Begin
                  Result:=CIST;
                end
                else
                Begin
                  Case CIST of
                    2  :  Result:=4;
                    3  :  Result:=2;
                    4  :  Result:=5;
                    5  :  Result:=3;
                    else  Result:=CIST;
                  end; {Case..}
                end;
              end;

     BOn   :  Begin
                If (CurrentCountry=IECCode) then
                Begin
                  Result:=CIST;
                end
                else
                Begin
                  Case CIST of
                    2  :  Result:=3;
                    3  :  Result:=5;
                    4  :  Result:=2;
                    5  :  Result:=4;
                    else  Result:=CIST;
                  end; {Case..}
                end;

              end;
  end; {Case..}


end;

{ ====== Function to determine if a payrate/Analcode/JobType can be deleted ===== }

{ Check modes  1  =  Job Type
               2  =  AnalCode
               3  =  PayRate }

{$WARNINGS OFF} //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 This function isn't used
Function XXBeen_Used(Const Mode  :  Byte;
                   Const KeyAC :  Str255)  :  Boolean;

Const
  Fnum      =  JobF;
  Keypath   =  JobCodeK;



Var
  KeyChk,
  KeyChk2,
  KeyChk3,
  KeyS      :  Str255;

  Fnum2,
  Keypath2,
  Fnum3,
  Keypath3  :  Integer;

  FoundOk   :  Boolean;



Begin

  KeyChk:='';



  FoundOk:=BOff;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

  While (StatusOk) and (Not FoundOk) do
  With JobRec^ do
  Begin
    Application.ProcessMessages;

    Case Mode of

      2  :  Begin

              {Budget}

              KeyChk:=PartCCKey(JBRCode,JBBCode)+FullJDStkKey(JobCode,KeyAC);

              {Actual}

              KeyChk2:=PartCCKey(JBRCode,JBECode)+FullJDAnalKey(JobCode,KeyAC);

              Fnum2:=JCtrlF;
              Keypath2:=JCK;

              Fnum3:=JDetlF;
              Keypath3:=JDAnalK;
            end;

      3  :  Begin {Pay Rates }

              {Budget}

              KeyChk:=PartCCKey(JBRCode,JBSCode)+FullJDStkKey(JobCode,KeyAC);

              {Actual}

              KeyChk2:=PartCCKey(JBRCode,JBECode)+FullJDStkKey(JobCode,KeyAC);

              {Employee PayRate}

              KeyChk3:=PartCCKey(JBRCode,JBSubAry[4])+FullJDStkKey(JobCode,KeyAC);

              Fnum2:=JCtrlF;
              Keypath2:=JCK;

              Fnum3:=JDetlF;
              Keypath3:=JDStkK;

            end;
    end; {Case..}
    Case Mode of

      1    : Begin {* Check for matching jobtype *}

               FoundOk:=CheckKey(JobAnal,KeyAC,Length(JobAnal),BOff);

             end;

      2,3  :  Begin

                FoundOk:=CheckExsists(KeyChk,Fnum2,Keypath2);

                If (Not FoundOk) then
                  FoundOk:=CheckExsists(KeyChk2,Fnum3,Keypath3);

                If (Not FoundOk) and (Mode=3) then
                  FoundOk:=CheckExsists(KeyChk3,Fnum2,Keypath2);

              end;


    end; {Case..}


    If (Not FoundOk) then
      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);



  end; {While..}

  XXBeen_Used:=FoundOk;



end; {Func..}
{$WARNINGS ON} //PR: 22/03/2016 v2016 R2 ABSEXCH-17390

{ == Update tagged balances == }

Procedure Update_TaggedWIPBal(Var JICtrl  :  JInvHedRec;
                                  JD      :  JobDetlRec;
                                  Mode    :  Byte;
                                  Deduct  :  Boolean);

Var
  DedCnst  :  SmallInt;

Begin
  With JICtrl,JD.JobActual do
  Begin
    If (Tagged) then
    Begin
      If (Deduct) then
        DedCnst:=-1
      else
        DedCnst:=1;


      TagCost:=TagCost+(Currency_ConvFT(Round_Up(Qty*Cost,2)*DocCnst[JDDT],ActCurr,InCurr,UseCoDayRate)*DedCnst);

      TagCharge:=TagCharge+(Currency_ConvFT(Charge*DocCnst[JDDT],CurrCharge,InCurr,UseCoDayRate)*DedCnst);

    end;

    If (Mode=22) then {* Keep running total *}
      TotCost:=TotCost+(Currency_ConvFT(Round_Up(Qty*Cost,2),ActCurr,InCurr,UseCoDayRate));
  end; {With..}

end;


Function CIS340  :  Boolean;

Begin
  Result:=(SyssCIS.CISRates.CurrPeriod>='20070501') and (CurrentCountry=DefaultCountry); {* Date of CIS 340 start *}

end;

{ ==  Various validation routines to confirm CIS submissions == }

Function CISValid_UTR(ChkUTR  :  Str20)  :  Boolean;

Var
  V1,V2,
  V,
  p  :  Integer;

Begin
  (*
  V1:=1; V2:=10;

  for p:=V1 to V2 do
  Begin
    Result:=ChkUTR[p] In ['0'..'9'];

    If (Not Result) then
      Break;
  end;
  *)

  // MH 03/06/2009: Modified validation to check length
  Result := (Length(ChkUTR) = 10);
  If Result Then
  Begin
    for p := 1 to 10 do
    Begin
      Result:=ChkUTR[p] In ['0'..'9'];

      If (Not Result) then
        Break;
    end;
  End; // If Result
end;


Function CISValid_AccOff(ChkUTR  :  Str20)  :  Boolean;

Var
  V1,V2,p  :  Integer;
  Loop     :  Boolean;

Begin
  Result:=(Length(ChkUTR)=13);

  If (Result) then
  Begin
    Loop:=BOff;
    V1:=1; V2:=3;

    Repeat
      for p:=V1 to V2 do
      Begin
        // MH 26/03/2013 v7.0.1 ABSEXCH-13998: Corrected validation for chars 6-13 to be AlphaNumeric
        Result := (ChkUTR[p] In ['0'..'9']) Or ((V1 >=6) And (ChkUTR[p] In ['A'..'Z','a'..'z']));
        //Result:=ChkUTR[p] In ['0'..'9'];

        If (Not Result) then
          Break;
      end;

      Loop:=Not Loop;

      V1:=6; V2:=13;

    Until (Not Loop) or (Not Result);

    If (Result) then
    Begin
      Result:=(ChkUTR[4]='P');

      If (Result) then
        Result:=(ChkUTR[5] In ['A'..'Z','a'..'z']);
    end;

  end; {check}
end;


Function CISValid_CoReg(ChkUTR  :  Str20)  :  Boolean;

Var
  V1,V2,p  :  Integer;
  Loop     :  Boolean;

Begin
  Loop:=BOff;

  V1:=1; V2:=Length(ChkUTR);

  Result:=BOff;

  for p:=V1 to V2 do
  Begin
    Result:=(ChkUTR[p] In ['0'..'9']) or ((ChkUTR[p] In ['A'..'Z','a'..'z']) and (p In [1,2]));

    If (Not Result) then
      Break;
  end;

end;


Function CISValid_NINO(ChkUTR  :  Str20)  :  Boolean;
Const
  NumSet = ['0'..'9'];
//Var
  //V1,V2,p  :  Integer;
  //Loop     :  Boolean;

Begin
  //Loop:=BOff;

  //V1:=3; V2:=8;

  Result:=(Length(ChkUTR) In [8,9]);

  If (Result) then
  Begin
    (*
    Repeat
      for p:=V1 to V2 do
      Begin
        Case V1 of
          3  :  Result:=(ChkUTR[p] In ['0'..'9']);
          else  If (p In [1,2,9]) then
                Begin
                  Result:=((Not (ChkUTR[p] In ['D','F','I','Q','U','V'])) and (p<>9)) or ((ChkUTR[p] In ['A'..'D',#32]) and (p=9));
                end;
        end; {Case..}

        If (Not Result) then
          Break;
      end;

      Loop:=Not Loop;

      V1:=1; V2:=Length(ChkUTR);

    Until (Not Loop) or (Not Result);
    *)
    Result := (ChkUTR[1] In (['A'..'Z'] - ['D','F','I','Q','U','V'])) And
              (ChkUTR[2] In (['A'..'Z'] - ['D','F','I','O','Q','U','V'])) And
              (ChkUTR[3] In NumSet) And
              (ChkUTR[4] In NumSet) And
              (ChkUTR[5] In NumSet) And
              (ChkUTR[6] In NumSet) And
              (ChkUTR[7] In NumSet) And
              (ChkUTR[8] In NumSet);

    If Result And (Length(ChkUTR) = 9) Then
      // MH 02/10/2009 FRv6.2.058 - corrected validation to allow B and C
      //Result := (ChkUTR[9] In ['A', 'D', ' ']);
      Result := (ChkUTR[9] In ['A'..'D', ' ']);
  end;
end;


Function CISValid_VerNo(ChkUTR  :  Str20)  :  Boolean;
Var
  V1,V2,p  :  Integer;
  Loop     :  Boolean;

Begin
  Loop:=BOff;

  V1:=2; V2:=Length(ChkUTR);

  {$B-}
    Result:=(V2 In [11..13]) and (ChkUTR[1]='V');
  {$B+}

  If (Result) then
  Begin
    for p:=V1 to V2 do
    Begin
      Case p of
        2..11  :  Result:=(ChkUTR[p] In ['0'..'9']);
        else  Begin
                Result:=((Not (ChkUTR[p] In ['I','O'])) and (ChkUTR[p] In ['A'..'Z']));
              end;
      end; {Case..}

      If (Not Result) then
        Break;
    end;
  end;
end;


Begin

end.