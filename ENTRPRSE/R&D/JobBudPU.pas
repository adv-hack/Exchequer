unit JobBudPU;

interface

{$I DEFOVR.Inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VarConst,VarRec2U,BtrvU2,BTSupU1,ExWrap1U, BTSupU3, BorBtns,SupListU,
  JobPostU, oProcessLock;


Type



TPostJobBudget  =   Object(TPostJob)

                     private

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

                       // MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation for SQL
                       Procedure SQL_UpdateCategoryLevel (Const JobCode : ShortString);

                     public

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;

                       Procedure Finish;  Virtual;


                   end; {Class..}


Procedure AddJobPostBud2Thread(AOwner   :  TObject;
                               SMode    :  Byte;
                               JCode    :  Str10;
                               JCRPtr   :  Pointer;
                               MyHandle :  THandle;
                               ProcessLock
                                        :  TProcessLockType = plUPdateJobBudgets);


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
  ComnUnit,
  ComnU2,
  CurrncyU,

  SysU1,
  SysU2,
  JobSup1U,

  {$IFDEF Inv}
    MiscU,

  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
    SQLRep_Config,
    SQLCallerU,
    EntLoggerClass,
  {$ENDIF}

  ReValU2U,

  ExThrd2U;







  { ========== TPostJob methods =========== }

  Constructor TPostJobBudget.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);


  end;

  Destructor TPostJobBudget.Destroy;

  Begin

    Inherited Destroy;
  end;



  { ========== Procedure to reset all Headings prior to an update ======= }

  Procedure TPostJobBudget.Reset_BHeadings(HCode  :  Str255);

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
    With MTExLocal^ do
    Begin

      LastStatus:=0;


      KeyChk:=HCode;

      KeyS:=HCode;

      Locked:=BOff;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
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

      LReport_BError(Fnum,LastStatus);
    end;
  end; {Proc..}


  { ============ Procedure to Update all Parent with lower budget records  ============ }

  Procedure TPostJobBudget.Update_ParentBudget(Const Fnum,
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
    With MTExLocal^ do
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

          If (LStatusOk) and ((LNHist.Budget+LNHist.RevisedBudget1+LNHist.Value1+LNHist.Value2)<>0) and (Not ThreadRec^.THAbort) then
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

      LReport_BError(Fnum,LastStatus);
    end; {With..}

  end; {Proc..}



  { ========= Procedure to reset own budget ========= }

  Procedure TPostJobBudget.Reset_OwnBudget(Const BudgetType,
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
    With MTExLocal^ do
    Begin
      Ok2Cont:=Not SelBReset;

      TmpKPath:=Keypath;

      KeyChk:=PartCCKey(JBRCode,BudgetType)+JCode;

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
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

            LReport_BError(Fnum,LStatus);

          end; {If ok..}
        end; {If we need to reset this one}

        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

      end;
    end; {With..}
  end;


  { ========== Procedure to update a jobs specific type of budget ======== }

  Procedure TPostJobBudget.Update_JobBudget(Const  BudgetType,
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
    With MTExLocal^ do
    Begin

      WasRH:=ResetHist;

      TmpFolio:=0;

      If (ResetHist) then
      Begin
        ShowStatus(1,'Please Wait Updating Budgets');
      end;

      TmpKPath:=KeyPath;

      KeyChk:=PartCCKey(JBRCode,BudgetType)+JCode;

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
      With LJobCtrl^.JobBudg do
      Begin

        If (Not (SPMode In [32,35,37,38])) then
        Begin
          Inc(ItemCount);

          UpdateProgress(ItemCount);
        end;

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

            LReport_BError(Fnum,LStatus);

          end; {If Locked...}

        end; {If Matching budget record found}


        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

      end; {While..}

    end; {With..}
  end; {Proc..}



  { ========= Proc to update all a local jobs budgets from stock onwards ======= }

  Procedure TPostJobBudget.Update_AllJobLevels(Const  JCode,
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

    With MTExLocal^ do
    Begin
      If (Not (SPMode In [32,35,37,38])) then
      Begin
        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId)*3);

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

      Until (Loop>2+Ord(GlobMode)) or (ThreadRec^.THAbort);
    end; {With..}

  end; {PRoc..}


  { ======= Proc to update all job budgets ======= }

  { ==EN560.001 These routines are a variation of the ScanContractBudget, but act on a branch only. Any changes to the supporting
procedures must be considered with regqrd to these routines as well == }


  Procedure TPostJobBudget.Update_GlobalBud;



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


    ShowStatus(0,'Contract Budget Update');

    With MTExLocal^ do
    Begin

      InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId)*2);

      Repeat

        LStatus:=LFind_Rec(B_StepFirst,Fnum,keypath,KeyS);

        While (LStatusOk) and (Not ThreadRec^.THAbort)  do
        With LJobRec^ do
        Begin

          ShowStatus(1,'Updating budgets for '+Trim(LJobRec^.JobCode));

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          Case Loop of



            1  :  Begin

                    If (JobType=JobGrpCode) then {* Auto reset all heading budgets *}
                    Begin
                      Loop2:=1;

                      Repeat


                        Reset_OwnBudget(LoopCtrl[Loop2],JobType,Fnum2,Keypath2,JobCode,BOff);


                        Inc(Loop2);

                      Until (ThreadRec^.THAbort) or (Loop2>3);
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

                      Until (LoopEnd) or (ThreadRec^.THAbort);

                      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

                    end;
                  end;

          end; {Case..}

          LStatus:=LFind_Rec(B_StepNext,Fnum,keypath,KeyS);


        end; {While..}

        Inc(Loop);


      Until (Loop>2) or (ThreadRec^.THAbort);
    end; {With..}


  end; {Proc..}

    { ======= Proc to update all contract level job budgets ======= }


{ == These routines are a variation of the UpdateGolbalBud, but act on a branch only. Any changes to the global rountines supporting
procedures must be considered with regqrd to these routines as well == }

  Procedure TPostJobBudget.ScanBranchJobs(JLevelCode, BaseJCode : Str10; Const ThisContractOnly : Boolean = False);



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

    With MTExLocal^ do
    Begin


      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort)  do
      With LJobRec^ do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);


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

          Until (LoopEnd) or (ThreadRec^.THAbort);

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


      end; {While..}
    end; {With..}
  end; {Proc..}


  Procedure TPostJobBudget.Scan_BranchContracts(StartJCode   :  Str10; Const ThisContractOnly : Boolean = False);



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


    ShowStatus(0,'Contract Budget Update');

    With MTExLocal^ do
    Begin
      TJRec:=LJobRec^;

      InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId)*2);

      Repeat
        // Default to the Job Code that was supplied
        KeyS := StartJCode;

        // If the current Job record is not a Job group...
        If (TJRec.JobType <> JobGrpCode) then
          // ...use the parent of this record instead of the supplied Job Code
          KeyS := FullJobCode(TJRec.JobCat);

        If (Not EmptyKey(KeyS,JobCodeLen)) then
          LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyS)
        else
          LStatus:=9;

        BaseJCode:=LJobRec^.JobCode;

        While (LStatusOk) and (Not ThreadRec^.THAbort)  do
        With LJobRec^ do
        Begin

          ShowStatus(1,'Updating budgets for '+Trim(LJobRec^.JobCode));

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          Case Loop of



            1  :  Begin

                    If (JobType=JobGrpCode) then {* Auto reset all heading budgets *}
                    Begin
                      Loop2:=1;

                      Repeat


                        Reset_OwnBudget(LoopCtrl[Loop2],JobType,Fnum2,Keypath2,JobCode,BOff);


                        Inc(Loop2);

                      Until (ThreadRec^.THAbort) or (Loop2>3);
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


      Until (Loop>2) or (ThreadRec^.THAbort);
    end; {With..}


  end; {Proc..}

  //-------------------------------------------------------------------------

  // MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation for SQL
  Procedure TPostJobBudget.SQL_UpdateCategoryLevel (Const JobCode : ShortString);
  Var
    oProcessLogger : TEntSQLReportLogger;
    SQLCaller: TSQLCaller;
    ConnectionString,
    lPassword: WideString;    //VA:27/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    CompanyCode: string;
    sQuery : String;
    Res : Integer;
  Begin // SQL_UpdateCategoryLevel
     oProcessLogger := TEntSQLReportLogger.Create('JCUpdateCategoryLevel');
     SQLCaller := TSQLCaller.Create;
     Try
       CompanyCode := SQLUtils.GetCompanyCode(SetDrive);

       // Get an admin connection string (not read-only)
       //SQLUtils.GetConnectionString(CompanyCode, False, ConnectionString);  

       //VA:27/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
       SQLUtils.GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword);
       SQLCaller.ConnectionString := ConnectionString;
       SQLCaller.Connection.Password := lPassword;
       SQLCaller.Connection.CommandTimeout := SQLReportsConfiguration.UpdateCategoryLevelsTimeoutInSeconds;  // Default 15 min timeout

       oProcessLogger.StartReport;
       sQuery := '[COMPANY].isp_UpdateCategoryLevel_PeriodBudgets ''' + Trim(JobCode) + ''', ' + IntToStr(GetLocalPr(0).CYr);
       oProcessLogger.StartQuery(sQuery);
       Res := SQLCaller.ExecSQL(sQuery, CompanyCode);
       oProcessLogger.FinishQuery;

       If (Res = -1) Then
         oProcessLogger.LogError('ExecSP', sqlCaller.ErrorMsg);

       oProcessLogger.FinishReport;
     Finally
       SQLCaller.Free;
       FreeAndNIL(oProcessLogger);
     End;
  End; // SQL_UpdateCategoryLevel

  //-------------------------------------------------------------------------

  Procedure TPostJobBudget.Process;

  Var
    Ok2Cont  :  Boolean;

    // CJS 2014-04-17 - v7.0.10 - ABSEXCH-13784 - Job Move actual and budget figures
    Key: Str255;
    RecAddr: LongInt;
    KeyPath: Integer;
    Done: Boolean;
  Begin
    Inherited Process;

    If (SPMode In [30,31,37,38]) then
    With MTExLocal^ do
    Begin
      {*Update heading*}
      ShowStatus(0,'Update Budgets');

      If (LJobRec^.JobCode<>ThisJobCode) then
        Ok2Cont:=LGetMainRecPos(JobF,ThisJobCode)
      else
        Ok2Cont:=BOn;

      If (Ok2Cont) then
      With LJobRec^ do
      Case SPMode of

        30  :  Begin

                 ItemCount:=0;

                 // MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation for SQL
                 If SyssJob^.JobSetUp.PeriodBud And       // Job Total and Analysis Code Budgets in history
                    SQLUtils.UsingSQLAlternateFuncs And
                    SQLReportsConfiguration.UseSQLUpdateCategoryLevels Then
                 Begin
                   // Execute SQL stored procedure version - live progress is impossible so set it
                   // to 10% so it looks like it has started - it should only take a few secs anyway
                   InitProgress(10);
                   UpdateProgress(1);
                   SQL_UpdateCategoryLevel (JobCode)
                 End // If SyssJob^.JobSetUp.PeriodBud
                 Else
                 Begin
                   // Legacy functionality for Pervasive or if SQL Optimisation is disabled
                   InitProgress(Used_RecsCId(LocalF^[JCtrlF],JCtrlF,ExCLientId)*3);
                   Update_JobBudget(JBBCode,JBMCode,JobType,JobType,JobCode,JobCode,JCtrlF,JCK,BOn);
                 End; // Else
               end;


        31  :  Update_AllJobLevels(JobCode,JobCode,JobType,JobType,JCtrlF,JCK,BOff);

        {* Only update budgets for this contract level upwards *}
        37  :  Scan_BranchContracts(ThisJobCode, (SPMode=37));

        // CJS 2014-04-17 - v7.0.10 - ABSEXCH-13784 - Job Move actual and budget figures
        38:
          // Work our way up through the tree, updating each Job/Contract
          // in this branch.
          begin
            // Save the record position and the data
            KeyPath := GetPosKey;
            LStatus := LPresrv_BTPos(JobF, KeyPath, LocalF^[JobF], RecAddr, BOff, BOn);
            LReport_BError(JobF, LStatus);

            // Start with the supplied Job Code
            LGetMainRecPos(JobF, ThisJobCode);

            // Find any parent Job Codes
            Done := False;
            while LStatusOk and not Done do
            begin
              // Recalculate the figures
              Scan_BranchContracts(LJobRec^.JobCode, True);

              // Restore our position in the database (Scan_BranchContracts
              // will have changed it)
              LStatus := LPresrv_BTPos(JobF, KeyPath, LocalF^[JobF], RecAddr, BOn, BOn);
              LReport_BError(JobF, LStatus);

              // Find the next parent
              if (Trim(LJobRec^.JobCat) <> '') then
              begin
                Key := FullJobCode(LJobRec^.JobCat);
                LStatus := LFind_Rec(B_GetEq, JobF, JobCodeK, Key);
              end
              else
                Done := True;
            end;
          end;

      end; {Case..}

      UpdateProgress(ThreadRec^.PTotal);

    end;


    If (SPMode In [32,35]) then
    Begin
      {*Update all contracts *}

      Update_GlobalBud;
    end;

  end;


  Procedure TPostJobBudget.Finish;

  Begin
    SendMessage(CallBackH,WM_FormCloseMsg,75,0);


    Inherited Finish;


  end;




{ ============== }

Procedure AddJobPostBud2Thread(AOwner   :  TObject;
                               SMode    :  Byte;
                               JCode    :  Str10;
                               JCRPtr   :  Pointer;
                               MyHandle :  THandle;

                               ProcessLock
                                        :  TProcessLockType = plUPdateJobBudgets);

  Var
    LCheck_Batch :  ^TPostJobBudget;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          If (Start(SMode,MyHandle)) and (Create_BackThread) then
          Begin

            ThisJobCode:=JCode;

            //Need to specify lock type as this could be kicked off from
            //JobMove
            ProcessLockType := ProcessLock;

            If (Assigned(JCRPtr)) then
              JCloseCtrlRec^:=JInvHedRec(JCRPtr^);

            With BackThread do
              AddTask(LCheck_Batch,'Job Budgets');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Batch,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Batch,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;





end.