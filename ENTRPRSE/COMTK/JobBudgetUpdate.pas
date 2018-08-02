unit JobBudgetUpdate;

interface

{$I DEFOVR.Inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls,
  GlobVar,VarConst,VarRec2U,BtrvU2,BTSupU1,ExWrap1U, BTSupU3, BorBtns, ExBtth1U;


Type

{PR: 30/08/2012 ABSEXCH-13202 Class to update job budgets after deleting a job. This is a cut-down version of
TPostJobBudget in JobBudPU.pas which has been converted from a ThreadQueue/EntPost descendant to a normal class.}


  TJobBudgetUpdater = Class
  private
    FJobCode : Str255;
    FExLocal : TdPostExLocalPtr;
    FMode : Byte;
    ItemCount : Integer;
    FResult : Boolean;
    Procedure HandleError(Fnum,ErrNo  :  SmallInt);
    Procedure Reset_BHeadings(HCode  :  Str255);
    Procedure Update_ParentBudget(Const Fnum,
                                        Keypath    :  Integer;
                                        LowKey,
                                        HiKey      :  Str255;
                                        Add2Total  :  Boolean);

    Procedure Reset_OwnBudget(Const BudgetType,
                                    JobType     :  Char;
                              Const Fnum,
                                    KeyPath     :  Integer;
                              Const JCode       :  Str10;
                              Const SelBReset   :  Boolean);

    Procedure Update_JobBudget(Const  BudgetType,
                                      TargetType,
                                      HistCode,
                                      THistCode    :  Char;
                               Const  JCode,
                                      TJCode       :  Str10;
                               Const  Fnum,
                                      Keypath      :  Integer;
                                      ResetHist    :  Boolean);

    Procedure Update_AllJobLevels(Const  JCode,
                                         TJCode     :  Str10;
                                  Const  HistCode,
                                         THistCode  :  Char;
                                  Const  Fnum,
                                         Keypath    :  Integer;
                                         GlobMode   :  Boolean);

    Procedure Update_GlobalBud;
    Procedure ScanBranchJobs(JLevelCode, BaseJCode : Str10; Const ThisContractOnly : Boolean = False);
    Procedure Scan_BranchContracts(StartJCode  :  Str10; Const ThisContractOnly : Boolean = False);
    function GetJobCode: string;
    procedure SetJobCode(const Value: string);


  public
    function Execute : Boolean;

    property JobCode : string read GetJobCode write SetJobCode;
    property ExLocal : TdPostExLocalPtr read FExLocal write FExLocal;
    property UpdateMode : Byte read FMode write FMode;
  end; {Class..}


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTKeys1U,
  VarJCstU,
{  ComnUnit,
  ComnU2,}
  CurrncyU,

  SysU1,
{  SysU2,}
  JobSup1U;

  {$IFDEF Inv}
//    MiscU,

  {$ENDIF}


{  ReValU2U,

  ExThrd2U;}







  { ========== Procedure to reset all Headings prior to an update ======= }

Procedure TJobBudgetUpdater.Reset_BHeadings(HCode  :  Str255);

Const
  Fnum      =  NHistF;
  Keypath   =  NHK;


Var
  KeyS,
  KeyChk    :  Str255;

  LOk,
  Locked    :  Boolean;

  LastStatus
            :  Integer;


Begin
  With FExLocal^ do
  Begin

    LastStatus:=0;


    KeyChk:=HCode;

    KeyS:=HCode;

    Locked:=BOff;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff))  do
    With LNHist do
    Begin

      If (Yr=GetLocalPr(0).CYr) then
      Begin
        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);


          Budget:=0.0;
          RevisedBudget1:=0.0;
          Value1:=0.0;
          Value2:=0.0;

          LStatus:=LPut_Rec(Fnum,Keypath);

          If (LastStatus=0) then
            LastStatus:=LStatus;

          LStatus:=LUnLockMLock(Fnum);

        end;
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);


    end; {While..}

    HandleError(Fnum,LastStatus);
  end;
end; {Proc..}


{ ============ Procedure to Update all Parent with lower budget records  ============ }

Procedure TJobBudgetUpdater.Update_ParentBudget(Const Fnum,
                                                   Keypath    :  Integer;
                                                   LowKey,
                                                   HiKey      :  Str255;
                                                   Add2Total  :  Boolean);

Var
  Cn,n,
  Ce    :  Byte;




  PerPr,
  PerPr2 :  Real;

  Dnum1,
  Dnum2  :  Double;


  KeyS   :  Str255;

  ChkFill,
  LOk,
  Locked :  Boolean;

  LowHist,
  HiHist :  HistoryRec;

  LastStatus
         :  Integer;

  Mode   :  Byte;


Begin
  With FExLocal^ do
  Begin

    LastStatus:=0;

    Mode:=0;


    Locked:=BOff;

    Extract_NHistfromNKey(Lowkey,LowHist);

    Extract_NHistfromNKey(Hikey,HiHist);


    {$IFDEF MC_On}

      Ce:=CurrencyType;


    {$ELSE}

      Ce:=0;

    {$ENDIF}




   For Cn:=0 to Ce do
   Begin
     ChkFill:=BOn;

     For n:=1 to Syss.PrinYr do
     Begin

        With LowHist do
          KeyS:=FullNHistKey(ExClass,Code,Cn,GetLocalPr(0).CYr,n);

        LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyS);

        If (LStatusOk) and ((LNHist.Budget+LNHist.RevisedBudget1+LNHist.Value1+LNHist.Value2)<>0)  then
        Begin


          PerPr:=LNHist.Budget;
          PerPr2:=LNHist.RevisedBudget1;

          Dnum1:=LNHist.Value1;
          Dnum2:=LNHist.Value2;


          If (ChkFill) then  {* Add any missing budgets *}
          Begin

            With HiHist do
              HiKey:=FullNHistKey(ExClass,Code,Cn,GetLocalPr(0).CYr,n);

            LFillBudget(Fnum,Keypath,Mode,HiKey);

            ChkFill:=BOff;
          end;

          With HiHist do
            KeyS:=FullNHistKey(ExClass,Code,Cn,GetLocalPr(0).CYr,n);

          LOk:=LGetMultiRec(B_GetEQ,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);


            If (Add2Total) then
            Begin
              LNHist.Budget:=LNHist.Budget+PerPr;
              LNHist.RevisedBudget1:=LNHist.RevisedBudget1+PerPr2;
              LNHist.Value1:=LNHist.Value1+Dnum1;
              LNHist.Value2:=LNHist.Value2+Dnum2;
            end
            else
            Begin
              LNHist.Budget:=PerPr;
              LNHist.RevisedBudget1:=PerPr2;
              LNHist.Value1:=Dnum1;
              LNHist.Value2:=Dnum2;
            end;


            LStatus:=LPut_Rec(Fnum,Keypath);

            If (LastStatus=0) then
              LastStatus:=LStatus;

            LStatus:=LUnLockMLock(Fnum);


          end; {If Ok..}
        end; {If Ok..}
      end; {Loop..}
    end; {Loop..}

    HandleError(Fnum,LastStatus);
  end; {With..}

end; {Proc..}



{ ========= Procedure to reset own budget ========= }

Procedure TJobBudgetUpdater.Reset_OwnBudget(Const BudgetType,
                                               JobType     :  Char;
                                         Const Fnum,
                                               KeyPath     :  Integer;
                                         Const JCode       :  Str10;
                                         Const SelBReset   :  Boolean);


Var
  KeyChk,
  KeyCtrl,
  KeyCtrlS,
  KeyS      :   Str255;

  LOk,
  Locked,
  Ok2Cont   :   Boolean;

  TmpKPath,
  TmpStat   :  Integer;

  TmpRecAddr:  LongInt;

  TJCtrl    :    JobCtrlRec;


Begin
  With FExLocal^ do
  Begin
    Ok2Cont:=Not SelBReset;

    TmpKPath:=Keypath;

    KeyChk:=PartCCKey(JBRCode,BudgetType)+JCode;

    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff))  do
    With LJobCtrl^.JobBudg do
    Begin
      If (SelBReset) then {* If a Stock/Payrate budget exsists for this analysis code then, then reset its budget, otherwise leave alone *}
      Begin
        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        TJCtrl:=LJobCtrl^;

        KeyCtrl:=PartCCKey(JBRCode,JBSCode)+FullJDAnalKey(JobCode,AnalCode);
        KeyCtrlS:=KeyCtrl;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,JCSecK,KeyCtrlS);

        Ok2Cont:=(LStatusOk and CheckKey(KeyCtrl,KeyCtrlS,Length(KeyCtrl),BOff));

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        LJobCtrl^:=TJCtrl;
      end
      else
        Ok2Cont:=BOn;

      If (Ok2Cont) then
      Begin
        Locked:=BOff;


        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
           LGetRecAddr(Fnum);

          If (SyssJob^.JobSetUp.PeriodBud) then
          Begin

            Reset_BHeadings(JobType+FullNHCode(FullJDHistKey(JobCode,HistFolio)));

            LStatus:=LUnLockMLock(Fnum);

          end
          else
          Begin
            BoQty:=0.0; BrQty:=0.0;

            BoValue:=0.0; BrValue:=0.0;

            LStatus:=LPut_Rec(Fnum,Keypath);

            LStatus:=LUnLockMLock(Fnum);

          end;

          HandleError(Fnum,LStatus);

        end; {If ok..}
      end; {If we need to reset this one}

      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

    end;
  end; {With..}
end;


{ ========== Procedure to update a jobs specific type of budget ======== }

Procedure TJobBudgetUpdater.Update_JobBudget(Const  BudgetType,
                                                 TargetType,
                                                 HistCode,
                                                 THistCode    :  Char;
                                          Const  JCode,
                                                 TJCode       :  Str10;
                                          Const  Fnum,
                                                 Keypath      :  Integer;
                                                 ResetHist    :  Boolean);


Var
  KeyChk,
  KeyS,
  KeyS2       :    Str255;

  TmpStat,
  TmpKPath    :    Integer;

  TmpFolio,
  TmpRecAddr  :    Longint;

  TJCtrl      :    JobCtrlRec;

  WasRH,
  LOk,
  Locked      :    Boolean;



Begin
  With FExLocal^ do
  Begin

    WasRH:=ResetHist;

    TmpFolio:=0;


    TmpKPath:=KeyPath;

    KeyChk:=PartCCKey(JBRCode,BudgetType)+JCode;

    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    With LJobCtrl^.JobBudg do
    Begin


      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      TJCtrl:=LJobCtrl^;

      If (ResetHist) then
      Begin
        Reset_OwnBudget(TargetType,THistCode,Fnum,Keypath,TJCode,((BudgetType=JBSCode) and (TargetType=JBBCode)));

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        ResetHist:=BOff;

        LJobCtrl^:=TJCtrl;

      end;

      If (WasRH) then
        TmpFolio:=HFolio_Txlate(AnalHed)
      else
        TmpFolio:=HistFolio;




      Case TargetType of {* May have to modify this if multi currency involved *}

        JBBCode  :  KeyS2:=FullJBKey(JBRCode,TargetType,FullJBCode(TJCode,0,AnalCode));
        JBSCode  :  KeyS2:=FullJBKey(JBRCode,TargetType,FullJBCode(TJCode,0,StockCode));
        JBMCode  :  KeyS2:=FullJBKey(JBRCode,TargetType,FullJBCode(TJCode,0,FullNomKey(TmpFolio)));

      end; {Case..}


      LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyS2);

      If (LStatusOk) then {* Equivalent code found *}
      Begin

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS2,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          If (SyssJob^.JobSetUp.PeriodBud) then
          Begin

            Update_ParentBudget(NHistF,NHK,HistCode+FullNHCode(FullJDHistKey(JCode,TJCtrl.JobBudg.HistFolio)),
                                           THistCode+FullNHCode(FullJDHistKey(TJCode,HistFolio)),
                                           BOn);

            LStatus:=LUnLockMLock(Fnum);

          end
          else
          Begin
            BoQty:=BoQty+TJCtrl.JobBudg.BoQty;

            BrQty:=BrQty+TJCtrl.JobBudg.BrQty;

            {$IFDEF EX601}
              BoValue:=BoValue+JBBCurrency_Txlate(TJCtrl.JobBudg.BoValue,TJCtrl.JobBudg.JBudgetCurr,JBudgetCurr);

              BrValue:=BrValue+JBBCurrency_Txlate(TJCtrl.JobBudg.BrValue,TJCtrl.JobBudg.JBudgetCurr,JBudgetCurr);

            {$ELSE}
              BoValue:=BoValue+TJCtrl.JobBudg.BoValue;

              BrValue:=BrValue+TJCtrl.JobBudg.BrValue;

            {$ENDIF}


            LStatus:=LPut_Rec(Fnum,Keypath);

            LStatus:=LUnLockMLock(Fnum);

          end;

          HandleError(Fnum,LStatus);

        end; {If Locked...}

      end; {If Matching budget record found}


      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

    end; {While..}

  end; {With..}
end; {Proc..}



{ ========= Proc to update all a local jobs budgets from stock onwards ======= }

Procedure TJobBudgetUpdater.Update_AllJobLevels(Const  JCode,
                                                    TJCode     :  Str10;
                                             Const  HistCode,
                                                    THistCode  :  Char;
                                             Const  Fnum,
                                                    Keypath    :  Integer;
                                                    GlobMode   :  Boolean);

Const
  LoopCtrl  :  Array[1..3] of Char  =  (JBSCode,JBBCode,JBMCode);



Var
  Loop  :  Byte;
  KeyS  :  Str255;

  NextCode
        :  Char;


Begin

  Loop:=1;

  With FExLocal^ do
  Begin
    If (Not (FMode In [32,35,37,38])) then
    Begin
      // InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId)*3);

      ItemCount:=0;
    end;

    Repeat

      KeyS:=PartCCKey(JBRCode,LoopCtrl[Loop])+JCode;

      If (LCheckExsists(KeyS,Fnum,Keypath)) then
      Begin

        If (GlobMode) then
          NextCode:=LoopCtrl[Loop]
        else
          NextCode:=LoopCtrl[Succ(Loop)];

        Update_JobBudget(LoopCtrl[Loop],NextCode,HistCode,THistCode,
                         JCode,TJCode,Fnum,KeyPath,Not GlobMode);

      end;

      Inc(Loop);

    Until (Loop>2+Ord(GlobMode));
  end; {With..}

end; {PRoc..}


{ ======= Proc to update all job budgets ======= }

{ ==EN560.001 These routines are a variation of the ScanContractBudget, but act on a branch only. Any changes to the supporting
procedures must be considered with regqrd to these routines as well == }


Procedure TJobBudgetUpdater.Update_GlobalBud;



Const
  Fnum      =  JobF;
  Keypath   =  JobCodeK;

  Fnum2     =  JCtrlF;
  Keypath2  =  JCK;

  LoopCtrl  :  Array[1..3] of Char  =  (JBSCode,JBBCode,JBMCode);


Var
  KeyChk,
  KeyS      :  Str255;

  Loop,
  Loop2     :  Byte;

  LoopEnd   :  Boolean;

  TmpKPath,
  TmpStat   :  Integer;

  TmpRecAddr:  LongInt;

  TJRec     :  JobRecType;



Begin

  KeyS:='';
  KeyChk:='';

  TmpKPath:=Keypath;

  Loop:=1;

  ItemCount:=0;



  With FExLocal^ do
  Begin

    // // InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId)*2);

    Repeat

      LStatus:=LFind_Rec(B_StepFirst,Fnum,keypath,KeyS);

      While (LStatusOk)  do
      With LJobRec^ do
      Begin

        // ShowStatus(1,'Updating budgets for '+Trim(LJobRec^.JobCode));

        Inc(ItemCount);

        // UpdateProgress(ItemCount);

        Case Loop of



          1  :  Begin

                  If (JobType=JobGrpCode) then {* Auto reset all heading budgets *}
                  Begin
                    Loop2:=1;

                    Repeat


                      Reset_OwnBudget(LoopCtrl[Loop2],JobType,Fnum2,Keypath2,JobCode,BOff);


                      Inc(Loop2);

                    Until (Loop2>3);
                  end;
                end;


          2  :  Begin


                  If (JobType<>JobGrpCode) then
                  Begin

                    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

                    KeyChk:=FullJobCode(JobCat);

                    TJRec:=LJobRec^;

                    Repeat

                      LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyChk);

                      LoopEnd:=Not LStatusOk;

                      If (Not LoopEnd) then
                      Begin

                        Update_AllJobLevels(TJRec.JobCode,JobCode,TJRec.JobType,JobType,Fnum2,Keypath2,BOn);

                        KeyChk:=FullJobCode(JobCat);

                      end;

                    Until (LoopEnd);

                    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

                  end;
                end;

        end; {Case..}

        LStatus:=LFind_Rec(B_StepNext,Fnum,keypath,KeyS);


      end; {While..}

      Inc(Loop);


    Until (Loop>2);
  end; {With..}


end; {Proc..}

  { ======= Proc to update all contract level job budgets ======= }


{ == These routines are a variation of the UpdateGolbalBud, but act on a branch only. Any changes to the global rountines supporting
procedures must be considered with regqrd to these routines as well == }

Procedure TJobBudgetUpdater.ScanBranchJobs(JLevelCode, BaseJCode : Str10; Const ThisContractOnly : Boolean = False);



Const
  Fnum      =  JobF;
  Keypath   =  JobCatK;

  Fnum2     =  JCtrlF;
  Keypath2  =  JCK;


Var
  KeyChk,
  KeyChk2,
  KeyS      :  Str255;

  LoopEnd   :  Boolean;

  TmpKPath,
  TmpStat   :  Integer;

  TmpRecAddr:  LongInt;

  TJRec     :  JobRecType;



Begin


  KeyChk:=JLEvelCode;
  KeyS:=KeyChk;

  TmpKPath:=Keypath;

  With FExLocal^ do
  Begin


    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff))  do
    With LJobRec^ do
    Begin

      Inc(ItemCount);

      // UpdateProgress(ItemCount);


      If (JobType<>JobGrpCode) or (JobCat=BaseJCode) then {We need any sub budget headings to make up total}
      Begin

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        KeyChk2:=FullJobCode(JobCat);

        TJRec:=LJobRec^;

        Repeat

          LStatus:=LFind_Rec(B_GetEq,Fnum,JobCodeK,KeyChk2);

          LoopEnd:=Not LStatusOk;

          If (Not LoopEnd) then
          Begin

            Update_AllJobLevels(TJRec.JobCode,JobCode,TJRec.JobType,JobType,Fnum2,Keypath2,BOn);

            // MH 03/07/2009: Modified so that it optionally only updates the current contract
            If (Not ThisContractOnly) Then
              KeyChk2:=FullJobCode(JobCat)
            Else
              LoopEnd := True;
          end;

        Until (LoopEnd);

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


    end; {While..}
  end; {With..}
end; {Proc..}


Procedure TJobBudgetUpdater.Scan_BranchContracts(StartJCode   :  Str10; Const ThisContractOnly : Boolean = False);



Const
  Fnum      =  JobF;
  Keypath   =  JobCodeK;

  Fnum2     =  JCtrlF;
  Keypath2  =  JCK;


  LoopCtrl  :  Array[1..3] of Char  =  (JBSCode,JBBCode,JBMCode);


Var
  BaseJCode :  Str10;

  KeyChk,
  KeyS      :  Str255;

  Loop,
  Loop2     :  Byte;

  TmpKPath,
  TmpStat   :  Integer;

  TmpRecAddr:  LongInt;

  TJRec,
  TLJRec    :  JobRecType;


Begin

  KeyS:='';
  KeyChk:='';

  TmpKPath:=Keypath;

  Loop:=1;

  ItemCount:=0;


  With FExLocal^ do
  Begin
    TJRec:=LJobRec^;


    Repeat
      KeyS:=StartJCode;

      If (TJRec.JobType<>JobGrpCode) then
        KeyS:=FullJobCode(TJRec.JobCat);

      If (Not EmptyKey(KeyS,JobCodeLen)) then
        LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyS)
      else
        LStatus:=9;

      BaseJCode:=LJobRec^.JobCode;

      While (LStatusOk)  do
      With LJobRec^ do
      Begin

        Inc(ItemCount);

        Case Loop of



          1  :  Begin

                  If (JobType=JobGrpCode) then {* Auto reset all heading budgets *}
                  Begin
                    Loop2:=1;

                    Repeat


                      Reset_OwnBudget(LoopCtrl[Loop2],JobType,Fnum2,Keypath2,JobCode,BOff);


                      Inc(Loop2);

                    Until (Loop2>3);
                  end;
                end;


          2  :  Begin


                  If (JobType=JobGrpCode) then
                  Begin
                    TLJRec:=LJobRec^;

                    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

                    // MH 03/07/2009: Modified so that it optionally only updates the current contract
                    ScanBranchJobs(JobCode, BaseJCode, ThisContractOnly);

                    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

                    LJobRec^:=TLJRec;

                  end;
                end;

        end; {Case..}

        // MH 03/07/2009: Modified so that it optionally only updates the current contract
        If (Not ThisContractOnly) And (Not EmptyKey(KeyS,JobCodeLen)) Then
        Begin
          KeyS:=JobCat;

          LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyS)
        End // If (Not ThisContractOnly) And (Not EmptyKey(KeyS,JobCodeLen))
        Else
          LStatus:=9;
      end; {While..}

      Inc(Loop);


    Until (Loop>2);
  end; {With..}


end; {Proc..}



function TJobBudgetUpdater.Execute : Boolean;

Var
  Ok2Cont  :  Boolean;

Begin
  FResult := True;
  Try
    With FExLocal^ do
    Begin
      If (LJobRec^.JobCode<>FJobCode) then
        Ok2Cont:=LGetMainRecPos(JobF,FJobCode)
      else
        Ok2Cont:=BOn;

      If (Ok2Cont) then
      begin
        With LJobRec^ do
          Scan_BranchContracts(FJobCode, False);
      end
      else
        FResult := False;
    end; //with FExLocal

    Result := FResult;
  Except
    Result := False;
  End;
end;

function TJobBudgetUpdater.GetJobCode: string;
begin
  Result := FJobCode;
end;

procedure TJobBudgetUpdater.SetJobCode(const Value: string);
begin
  FJobCode := Value;
end;

procedure TJobBudgetUpdater.HandleError(Fnum, ErrNo: SmallInt);
begin
  if ErrNo <> 0 then
    FResult := False;
end;

end.