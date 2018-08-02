unit PostSp2U;

{$I DEFOVR.Inc}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Forms,Grids,GlobVar,VarConst,VarRec2U,BtrvU2,
  PostingU,BTSupU3,

  //PR: 14/02/2014 ABSEXCH-15038
  ContactsManager,

  //PR: 08/04/2014 ABSEXCH-13873
  SQLCallerU;


type

  TNHistMove  =  Object(TEntPost)

                     private

                       Procedure Hed_YTDType(MoveCode  :  LongInt;
                                             NTyp      :  Char;
                                             Fnum,
                                             Keypath   :  Integer;
                                         Var YTDOk,
                                             YTDNCFOk  :  Boolean);

                       Procedure Nom_MoveCCHist(NomCat         :  LongInt;
                                                NomType        :  Char;
                                                NomFolio       :  LongInt;
                                                PostYTD,
                                                PostYTDNCF     :  Boolean;
                                                MRates         :  CurrTypes;
                                                DCnst,
                                                Fnum,Keypath,
                                                ThisStage      :  Integer);

                       Procedure Change_NHistType(OldTyp,NewTyp  :  Char;
                                                  SFolio,
                                                  ThisStage      :  LongInt);

                       Procedure Change_NomType(OldTyp,NewTyp  :  Char;
                                                CanChange      :  Boolean;
                                            Var NomR           :  NominalRec);

                       Function LOk2DelNom(Mode  :  Integer;
                                           NomR  :  NominalRec)  :  Boolean;

                       Procedure Nom_Move(MoveCode,
                                          NewCat     :  LongInt;
                                          NewType    :  Char;
                                          Fnum,
                                          Keypath    :  Integer);

                       Function Delete_MoveRecord(Fnum,
                                                  Keypath  :  Integer;
                                                  RecAddr  :  LongInt)  :  Boolean;


                       Procedure Process_MoveList;

                       Function PartHistViewMKey(NVRec  :  NomViewRec)  :  Str50;

                       Procedure Hed_ViewYTDType(NVRec     :  NomViewRec;
                                                 Fnum,
                                                 Keypath   :  Integer;
                                             Var YTDOk,
                                                 YTDNCFOk  :  Boolean);

                       Procedure PostViewMove(NVRec     :  NomViewRec;
                                              GetHist   :  HistoryRec;
                                              CatCode   :  LongInt;
                                              YTDOk,
                                              YTDNCFOk,
                                              AutoPBF   :  Boolean;
                                              DedCnst,
                                              Fnum,
                                              Keypath   :  Integer;
                                              Level     :  LongInt);

                       Procedure NomView_Move(NVRec     :  NomViewRec;
                                              NewCat     :  LongInt;
                                              Fnum,
                                              Keypath    :  Integer);

                       {$IFDEF STK}

                         {$IFDEF SOP}  {* For each location restore history *}
                             Procedure Stk_MoveLocHist(StkCat         :  Str20;
                                                       StkType        :  Char;
                                                       StkFolio       :  LongInt;
                                                       PostYTD,
                                                       PostYTDNCF     :  Boolean;
                                                       MRates         :  CurrTypes;
                                                       DCnst,
                                                       Fnum,Keypath,
                                                       ThisStage      :  Integer);

                         {$ENDIF}

                         Procedure Stk_Move(MoveCode,
                                            NewCat,
                                            NewCode    :  Str20;
                                            CodeChange :  Boolean;
                                            Fnum,
                                            Keypath    :  Integer);


                         Procedure Renumber_Stock(OldCode,
                                                  NewCode  :  Str20);

                         Procedure CtrlRen_Stk(OldCode,
                                               NewCode  :  Str20);

                       {$ENDIF}

                       Procedure Renumber_Account(OldCode,
                                                  NewCode  :  Str20;
                                                  CMode    :  Boolean);

                       Procedure CtrlRen_Acc(OldCode,
                                             NewCode  :  Str20;
                                             RecMode  :  Boolean);

                       protected
                         MAutoRecover,
                         TTEnabled :  Boolean;
                         SendRecCtrl,
                         MoveRepCtrl
                                   :  MoveRepPtr;

                         LastStage :  Byte;
                         ItemTotal,
                         ItemCount,

                         PMListAddr,
                         PMSLAddr  :  LongInt;

                         PMSCtrl   :  ^MoveCtrlType;


                         Function PartHistMKey(HType  :  Char;
                                               NCode  :  LongInt)  :  Str10;

                         Function MoveTitle  :  Str255;


                         Function RightStage(Stage  :  Byte)  :  Boolean;

                         Function ChkTypeStages(NS  :  CurrChangeSet)  :  Boolean;

                         Function FindPMS  :  Boolean;

                         Function FinishPMS  :  Boolean;

                         Function StartNewPMS  :  Boolean;

                         Function UpdatePMS(Stage  :  Byte;
                                            MKey1,
                                            MKey2  :  Str255;
                                            FS     :  Boolean)  :    Boolean;

                         Function ThisLastStage(Stage  :  Byte)  :  Boolean;

                         Function Check4AbortPMS  :  Boolean;

                       {$IFDEF JC}
                         Procedure Move_Post(HType  :  Char;
                                             HKey   :  Str255;
                                             Purch,
                                             Sales,
                                             Cleared:  Double;
                                             HCurr,
                                             HYr,
                                             HPr    :  Byte;
                                             MRates :  CurrTypes);  Virtual;

                         Procedure Move_PostCtrl(JCode  :  Str10;
                                                 HKey   :  Str255;
                                                 Purch,
                                                 Sales,
                                                 Cleared:  Double;
                                                 HCurr,
                                                 HYr,
                                                 HPr    :  Byte;
                                                 MRates :  CurrTypes;
                                                 PCommit:  Boolean;
                                                 Level  :  LongInt); Virtual;

                         Function Make_MoveAnalBudg(JCtrl  :  JobCtrlRec;
                                                    JCode  :  Str10;
                                                    Fnum,
                                                    Keypath:  Integer)  :  Boolean;

                         Function Match_BudgetFolio(BudHistFolio  :  LongInt;
                                                    JC,
                                                    NewCat        :  Str10;
                                                Var FAnalCode     :  Str20;
                                                Var SPayFlg       :  Boolean;
                                                Var OrigBR        :  JobCtrlRec;
                                                Var KeySearch     :  Str255)  :  Boolean;

                         Procedure Move_PostAnalCtrl(BudHistFolio
                                                                :  LongInt;
                                                     OrigJC,
                                                     NewCat,
                                                     FAnalCode  :  Str20;
                                                     Purch,
                                                     Sales,
                                                     Cleared:  Double;
                                                     HCurr,
                                                     HYr,
                                                     HPr    :  Byte;
                                                     MRates :  CurrTypes;
                                                     PCommit,
                                                     SPayFlg,
                                                     Loop   :  Boolean);

                         Procedure Job_Move(MoveCode,
                                            NewCat     :  Str20;
                                            Fnum,
                                            Keypath    :  Integer);

                       {$ENDIF}

                     public
                       MyOHandle  :  THandle;
                       fWhoAmI    :  Byte;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function ThreadTitle  :  Str255;

                       Function StartMove(MoveRec  :  MoveRepPtr)  :  Boolean;

                       Function Start(MoveRec  :  MoveRepPtr)  :  Boolean;

                   end; {Class..}

  TCheckNom      =  Object(TEntPost)

                     private
                       tViewNo,
                       UCode  :  LongInt;
                       TICount:  Integer;
                       InCheckAll
                              :  Boolean;
                       DelJobR:  JobRecType;
                       {$IFDEF EXSQL}
                       FNomRec : NominalRec;
                       {$ENDIF}
                     public
                       FolioList : TList; //PR: 07/04/2014 ABSEXCH-13873  Cache
                       JobAnalList : TList; //PR: 08/04/2014 ABSEXCH-13873  Secondary cache
                       FSQLCaller : TSQLCaller; //PR: 08/04/2014 ABSEXCH-13873 In SQL, go straight to the database
                       FCompanyCode : string;
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;


                       Procedure Reset_Actual;
                       Procedure Set_ActualStatus;

                       Function Set_ActNHist( NRec  :  NominalRec;
                                              SRec  :  StockRec;
                                              Mode  :  Boolean)  :  Str255;

                       Procedure Reset_AHeadings(HCode  :  Char);

                       Procedure Update_ParentActual(LowKey,
                                                     HiKey      :  Str255;
                                                     ProMode,
                                                     AutoPBF    :  Boolean);

                       Procedure Update_GlobalActuals(ProMode    :  Boolean);

                       Function Set_NVHist( NRec  :  NomViewRec;
                                            Mode,
                                            AutoPBF
                                                  :  Boolean)  :  Str255;

                       Procedure Reset_NomViewActual;

                       Procedure Reset_ViewHistory; Virtual;

                       Procedure Update_NomViewActual(LowKey,
                                                      HiKey      :  Str255;
                                                      PostView   :  NomViewRec;
                                                      ProMode,
                                                      AutoPBF    :  Boolean);


                       Procedure Update_NomViewUnposted(PostView   :  NomViewRec;
                                                        Level      :  LongInt);

                       Function LGet_GLViewCtrlRec(VN  :  LongInt)  :  ViewCtrlType;

                       Procedure Update_NomViewActuals(ProMode    :  Boolean);

                       {$IFDEF JC}

                         Procedure Reset_JActual;

                         Function Set_ActJNHist(JRec  :  JobRecType)  :  Str255;

                         Procedure Reset_JAHeadings(HCode  :  Char);

                         Procedure Update_JobParentActual(LowKey,
                                                          HiKey      :  Str255);

                         Procedure Update_JobGlobalActuals;

                         //PR 07/04/2014 ABSEXCH-13783 Function to get correct HistFolio for a given analysis code/parent job code
                         function GetHistFolioForParent(const JobCode : string;
                                                        const ParentCode : string;
                                                              JobHistFolio : longint) : longint;

                       {$ENDIF}

                       Procedure Set_AllActualsStatus;


                       Procedure Set_PayInClearedStatus;

                       Procedure Reset_Cleared;
                       Procedure Set_ClearedStatus;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start(NNom     :   NominalRec;
                                      LCAMode  :   Byte)  :  Boolean;

                       //AP: 28/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
                       Procedure CalcNomYTD;
                       //AP: 29/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
                       Procedure CalcAllNomYTD;
                       //AP: 28/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
                       Procedure ResetGLCleared;

                   end; {Class..}

var
 FPr, FYr: Byte; //AP: 28/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc

Function NomGood_Type(OTyp  :  Char;
                      Change:  Boolean)  :  Boolean;

Function AddMove2Thread(AOwner   :  TObject;
                        AMRec    :  MoveRepPtr)  :  Boolean;

Procedure AddCheckNom2Thread(AOwner   :  TObject;
                             ANom     :  NominalRec;
                             AJob     :  JobRecType;
                             LCAM     :  Byte);

//AP: 29/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
procedure AddCheckAllNom2Thread(AOwner: TObject);

Function GlobMoveLockCtrl  :  Boolean;

Function StockCodeChange(LStock    :  StockRec;
                         NS        :  Str255;
                         AOwner    :  TForm)  :  Boolean;

Function AccountCodeChange(LCust    :  CustRec;
                           NS       :  Str255;
                           AOwner   :  TForm;
                           const oContactsManager
                                    : TContactsManager)  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  RPDefine,
  ETDateU,
  ETStrU,
  ETMiscU,
  BTSFrmU1,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  ExWrap1U,
  GenWarnU,
  MovWarnU,
  {$IFDEF PF_On}
    CuStkA4U,
  {$ENDIF}

  PayF2U,
  SalTxl1U,
  {$IFDEF Rp}
    ReportU,
  {$ENDIF}

  {$IFDEF SOP}
    AltCRe2U,
  {$ENDIF}

  {$IFDEF JC}
    VarJCStU,
    JobPostU,
    JobSup1U,
  {$ENDIF}

  NomVRecU,

  MoveTR1U,

  LettrDlg,
  AllocS1U,
  NoteSupU,
  CISSup1U,

  {$IFDEF EXSQL}
  SQLUtils, ADOConnect,
  {$ENDIF}
  {$IFDEF PERIODFIX}
    PeriodObj,
  {$ENDIF}

  Excep2U,
  ExBtTh1U,
  ExThrd2U,

  WM_Const,

  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1
  oProcessLock,
  //SSK 15/02/2018 2018-R1 ABSEXCH-19745: Anonymisation units are added
  oAnonymisationDiaryObjDetail,
  oAnonymisationDiaryBtrieveFile;


{ ======= Function to Determine if a nominal code type change is acceptable ===== }

Function NomGood_Type(OTyp  :  Char;
                      Change:  Boolean)  :  Boolean;


Begin

  NomGood_Type:=((Change) or (Not (OTyp In [NomHedCode,CarryFlg])));

end;


Function GlobMoveTitle(MM  :  SmallInt)  :  Str255;

Begin

  Case MM of
    1  :  Result:='G/L Move';
    2  :  Result:='G/L Type Change';
    3  :  Result:='Stock Move';
    4  :  Result:='Stock Code Change';
   30  :  Result:='Job Move';

   40  :  Result:='Account Code Change';

   50  :  Result:='G/L View Move';
   51  :  Result:='G/L Move List';
   52,54
       :  Result:='Stock Move List';

    else  Result:='Error! (Move)';
  end; {Case..}
end;


Function GlobThreadTitle(MoveRepCtrl  :  MoveCtrlType)  :  Str255;

Begin

  With MoveRepCtrl do
  Begin
    Result:=GlobMoveTitle(WasMode)+'. ';

    Case WasMode of
      1,2  :  Result:=Result+Form_Int(OldNCode,0);

      3,4,30,40

           :  Result:=Result+SCodeOld;
    end; {Case..}
  end;
end;

{ ========== TCheckNom methods =========== }

Constructor TNHistMove.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  fTQNo:=1;
  fCanAbort:=BOff;

  fPriority:=tpNormal;

  MTExLocal:=nil;

  PMSLAddr:=0;

  PMListAddr:=0;

  fWhoAmI:=0;

  IsParentTo:=BOn;

  ItemCount:=0; ItemTotal:=0;

  New(MoveRepCtrl);
  New(SendRecCtrl);

  New(PMSCtrl);

  MyOHandle:=0;
  LastStage:=0;

  TTEnabled:=BOff;
  MAutoRecover:=BOff;

  try
    FillChar(MoveRepCtrl^,Sizeof(MoveRepCtrl^),0);

  except
    Dispose(MoveRepCtrl);
    MoveRepCtrl:=nil;
  end;

  try
    FillChar(PMSCtrl^,Sizeof(PMSCtrl^),0);

  except
    Dispose(PMSCtrl);
    PMSCtrl:=nil;
  end;

end;

Destructor TNHistMove.Destroy;

Begin
  If (Assigned(MoveRepCtrl)) then
  Begin
    Dispose(MoveRepCtrl);
  end;

  If (Assigned(PMSCtrl)) then
  Begin
    Dispose(PMSCtrl);
  end;

  Inherited Destroy;
end;


{ ======== Part History Key ======== }
{ ** Reproduced in NHist1u.Pas as on threading for budget fill ** }

Function TNHistMove.PartHistMKey(HType  :  Char;
                                 NCode  :  LongInt)  :  Str10;

Begin

  PartHistMKey:=HType+FullNomKey(NCode);

end; {Func..}



{ ======== Proc to determine what type of YTD (if any) a heading type contains ===== }
{ ** Reproduced in NHist1u.Pas as on threading for budget fill ** }

Procedure TNHistMove.Hed_YTDType(MoveCode  :  LongInt;
                                 NTyp      :  Char;
                                 Fnum,
                                 Keypath   :  Integer;
                             Var YTDOk,
                                 YTDNCFOk  :  Boolean);



Var
  FoundOk  :  Boolean;
  KeyS,
  KeyChk   :  Str255;



Begin

  YTDOk:=BOff;
  YTDNCFOk:=BOff;

  FoundOk:=BOff;

  KeyChk:=PartHistMKey(NTyp,MoveCode);

  KeyS:=KeyChk;

  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With LNHist do
    Begin

      FoundOk:=(Pr In [YTD,YTDNCF]);

      If (Not FoundOk) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

    end; {While..}

    If (FoundOk) then
    With LNHist do
    Begin

      YTDOk:=(Pr=YTD);
      YTDNCFOk:=(Pr=YTDNCF);

    end;
  end;
end; {Proc..}




{* For each CC restore history *}
  Procedure TNHistMove.Nom_MoveCCHist(NomCat         :  LongInt;
                                      NomType        :  Char;
                                      NomFolio       :  LongInt;
                                      PostYTD,
                                      PostYTDNCF     :  Boolean;
                                      MRates         :  CurrTypes;
                                      DCnst,
                                      Fnum,Keypath,
                                      ThisStage      :  Integer);


  Const
    Fnum2     =  PWrdF;
    Keypath2  =  PWK;

  Var
    KeyChk,KeyS,
    KeyS2,KeyChk2,
    CCDepKey       :  Str255;

    TmpKPath,
    TmpStat        :  Integer;


    RecAddr2,
    RecAddr        :  LongInt;

    IsCombo,
    Loop           :  Boolean;

    BCCDep         :  CCDepType;

    TmpPWrd        :  PassWordRec;

  Begin
    Loop:=BOff;  IsCombo:=BOff;

    TmpKPath:=GetPosKey;

    With MTExLocal^ do
    Begin
      TmpPWrd:=LPassWord;

      TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,LocalF^[Fnum2],RecAddr2,BOff,BOff);

      Repeat

        KeyChk2:=PartCCKey(CostCCode,CSubCode[Loop]);

        If (Not ThisLastStage(ThisStage+Ord(Loop))) then
          KeyS2:=KeyChk2
        else
          KeyS2:=PMSCtrl^.MoveKey1;

        LStatus:=LFind_Rec(B_GetGEq,Fnum2,Keypath2,KeyS2);

        While (LStatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOff)) and (Not AbortTran) and (RightStage(ThisStage+Ord(Loop))) do
        With LPassWord,CostCtrRec do
        Begin
          KeyChk:=NomType+CalcCCKeyHistPOn(NomFolio,Loop,PCostC);

          If (Not ThisLastStage(ThisStage+Ord(Loop))) then
          Begin
            KeyS:=KeyChk;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

          end
          else
          Begin
            KeyS:=PMSCtrl^.MoveKey2;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
            LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
          end;


          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
          With LNHist do
          Begin

            IsCombo:=(Code[9]=Chr(1+Ord(Loop)));



            If (Not (Pr In [YTD,YTDNCF])) then
            Begin

              LStatus:=LGetPos(Fnum,RecAddr);  {* Preserve Posn of History Line *}

              If (LStatusOk) then
              Begin

                If (TranOk2Run) then
                Begin
                  LStatus:=LCtrl_BTrans(1);

                  TTEnabled:=LStatusOk;

                  TRanOk2Run:=TTEnabled;

                  {* Wait until All clear b4 continuing *}
                  If (TTEnabled) then
                    WaitForHistLock;

                  UpdatePMS(ThisStage+Ord(Loop),KeyS2,KeyS,BOff);
                end
                else
                  TTEnabled:=BOff;

                  If (IsCombo) then
                  Begin
                    Blank(BCCDep,Sizeof(BCCDep));

                    BCCDep[Loop]:=Copy(Code,6,cckeyLen);
                    BCCDep[Not Loop]:=Copy(Code,10,cckeyLen);

                    CCDepKey:=CalcCCDepKey(Loop,BCCDep);
                  end
                  else
                    CCDepKey:=PCostC;

                  LPost_To_CCNominal(FullNomKey(NomCat),
                                   (Purchases*DCnst),
                                   (Sales*DCnst),
                                   (Cleared*DCnst),
                                   Cr,Yr,Pr,
                                   2,PostYTD,BOff,PostYTDNCF,MRates,
                                   PostCCKey(Loop,CCDepKey),0);

                  If (TTEnabled) then
                  Begin
                    UnLockHistLock;

                    LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                    LReport_BError(InvF,LStatus);

                  end;


                LSetDataRecOfs(Fnum,RecAddr);  {* Re-establish position *}

                LStatus:=LGetDirect(Fnum,Keypath,0);

              end; {If Pos got ok..}
            end; {If YTD..}

            LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

          end; {While..}

          If (TTEnabled) and (Not AbortTran) then
            UpdatePMS(ThisStage+Ord(Loop),KeyS2,KeyS,BOff);


          LStatus:=LFind_Rec(B_GetNext,Fnum2,Keypath2,KeyS2);
        end;

        If (TTEnabled) and (Not AbortTran) then
          UpdatePMS(ThisStage+Ord(Loop),KeyS2,KeyS,BOn);

        Loop:=Not Loop;

      Until (Not Loop);

      TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,LocalF^[Fnum2],RecAddr2,BOn,BOff);

      LPassWord:=TmpPWrd;
    end; {With..}
  end;


{ =========== Procedures to Nominal Type Changes =========== }


Procedure TNHistMove.Change_NHistType(OldTyp,NewTyp  :  Char;
                                      SFolio,
                                      ThisStage      :  LongInt);


Const
  Fnum    =  NHistF;

  Keypath =  NHk;


Var

  KeyChk,
  KeyS    :  Str255;

  UOk,
  Locked,
  HasData,
  OldSet,
  NewSet  :  Boolean;

  Loop,
  KeyLen,
  LastCr,
  LastYr  :  Byte;

  TPurch,
  TSales,
  TCleared
          :  Real;



Begin

  UOk:=BOff; Locked:=BOff;

  HasData:=BOff;

  TPurch:=0; TSales:=0; TCleared:=0;

  LastCr:=0; LastYr:=0;

  OldSet:=(OldTyp In YTDSet);
  NewSet:=(NewTyp In YTDSet);

  Loop:=0;

  With MTExLocal^ do
  Begin

    Repeat
      If (Loop>0) then
        KeyChk:=OldTyp+CSubCode[Loop=2]+FullNomKey(SFolio)
      else
      Begin
        KeyChk:=PartNHistKey(OldTyp,FullNomKey(SFolio),0);
        KeyChk:=Copy(KeyChk,1,Pred(Length(KeyChk)));  {* Search for all matches ignoring currency *}
      end;

      If (Not ThisLastStage(ThisStage+Loop)) then
      Begin
        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;


      KeyLen:=Length(KeyChk);

      
      With LNHist do
      Begin

        LastCr:=Cr;
        LastYr:=Yr;

      end;

      While (LStatusOk) and CheckKey(KeyChk,KeyS,KeyLen,BOn) and (RightStage(ThisStage+Loop)) and (Not AbortTran) do
      With LNHist do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        UOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOn,Locked);

        If (UOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          If ((OldTyp In YTDSet) and (Pr=YTD) and (NewTyp In YTDNCFSet)) then
            Pr:=YTDNCF
          else
            If ((OldTyp In YTDNCFSet) and (Pr=YTDNCF) and (NewTyp In YTDSet)) then
              Pr:=YTD;


          LNHist.ExClass:=NewTyp;


          If (LastCr<>Cr) or ((LastYr<>Yr) and (NewTyp In YTDNCFSet)) then
          Begin

            TPurch:=0; TSales:=0; TCleared:=0;

            LastCr:=Cr;

            LastYr:=Yr;

          end;

          {* Only Recalc YTD totals if YTD type different *}

          If (Not (Pr In [YTD,YTDNCF])) and (OldSet<>NewSet) then
          Begin
            TPurch:=TPurch+Purchases;
            TSales:=TSales+Sales;

            TCleared:=TCleared+Cleared;

            HasData:=BOn;
          end
          else
            If (HasData) then
            Begin

              Purchases:=TPurch;

              Sales:=TSales;

              Cleared:=TCleared;

            end;

          If (TranOk2Run) then
          Begin
            LStatus:=LCtrl_BTrans(1);

            TTEnabled:=LStatusOk;

            TRanOk2Run:=TTEnabled;

            {* Wait until All clear b4 continuing *}
            If (TTEnabled) then
              WaitForHistLock;

            UpdatePMS(ThisStage+Loop,KeyS,'',BOff);
          end
          else
            TTEnabled:=BOff;


          LStatus:=LPut_Rec(Fnum,Keypath);

          LReport_BError(Fnum,LStatus);

          If (Not AbortTran) and (TTEnabled) then
            AbortTran:=(Not LStatusOk);

          If (TTEnabled) then
          Begin
            UnLockHistLock;

            LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

            LReport_BError(InvF,LStatus);

          end;


          LStatus:=LUnLockMLock(Fnum);

          If (Pr=YTDNCF) then
          Begin

            TPurch:=0; TSales:=0; TCleared:=0;

          end;

        end; {If Locked Ok..}

        If (LStatusOk) then
          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage+Loop,KeyS,'',BOn);

      Inc(Loop);

    Until (Loop>2);
  end; {With..}
end; {Proc..}





{ =========== Change Actual Code ========= }


Procedure TNHistMove.Change_NomType(OldTyp,NewTyp  :  Char;
                                    CanChange      :  Boolean;
                                Var NomR           :  NominalRec);



Const
  Fnum    =  NHistF;
  Keypath =  NHk;


Var

  Abort      :  Boolean;

Begin

  Abort:=BOff;


  If (OldTyp<>NewTyp) then
  With NomR do
  Begin

    Abort:=((Not NomGood_Type(OldTyp,CanChange)) or (Not NomGood_Type(NewTyp,CanChange)));


    {* Change Normal History *}

    If (Not Abort) then
    Begin
      If (ChkTypeStages([4..6])) then
        Change_NHistType(OldTyp,NewTyp,NomCode,4);

      {* Change Budget / Posted History *}
      If (ChkTypeStages([7..9])) then
        Change_NHistType(Calc_AltStkHCode(OldTyp),Calc_AltStkHCode(NewTyp),NomCode,7);
    end {If Abort..}
    else
      NomType:=OldTyp;

  end; {If anything to change..}
end; {Proc..}



Function TNHistMove.LOk2DelNom(Mode  :  Integer;
                               NomR  :  NominalRec)  :  Boolean;

Var
  Purch,
  Sales,
  Cleared  :  Double;

Begin
  Purch:=0; Sales:=0;  Cleared:=0;

  {$B-}

  With MTExLocal^, NomR do

    If (Mode=99) then {* Only Check for Profit *}
      LOk2DelNom:=(LProfit_To_Date(NomType,FullNomKey(NomCode),0,GetLocalPr(0).CYr,YTD,Purch,Sales,Cleared,BOn)=0)
    else
      LOk2DelNom:=((LProfit_To_Date(NomType,FullNomKey(NomCode),0,GetLocalPr(0).CYr,YTD,Purch,Sales,Cleared,BOn)=0) and
                 (Not LCheckExsists(FullNomKey(NomCode),NomF,NomCatK)) and
                 (Not LCheckExsists(FullNomKey(NomCode),IDetailF,IdNomK)) and
                 (Not LCheckExsists(Strip('R',[#0],FullRunNoKey(0,NomCode)),IDetailF,IdRunK)));

  {$B+}
end;


{ =========== Procedure to Move Nominal Code ========= }


Procedure TNHistMove.Nom_Move(MoveCode,
                              NewCat     :  LongInt;
                              NewType    :  Char;
                              Fnum,
                              Keypath    :  Integer);


Const
  Fnum2      =  NomF;
  Keypath2   =  NomCodeK;



Var
  MoveNom  :  NominalRec;
  RecAddr  :  LongInt;

  BotStage,
  ThisStage:  Byte;

  KeyChk,
  KeyS     :  Str255;


  Loop,
  PostYTD,
  PostYTDNCF,
  TypeChange,
  HedYTD,
  HedYTDNCF
           :  Boolean;

  DCnst    :  Integer;

  PrevBal  :  Double;

  OldType  :  Char;

  ActNom   :  LongInt;

  MRates   :  CurrTypes;

  LOk,
  Locked   :  Boolean;




Begin

  PrevBal:=0;

  ActNom:=0; BotStage:=0;

  MRates[BOff]:=1; MRates[BOn]:=1;

  KeyS:=FullNomKey(MoveCode);

  Locked:=BOff;

  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyS);

    If (LStatusOk) then
    With MoveNom do
    Begin
      MoveNom:=LNom;

      Loop:=BOff;

      OldType:=NomType;

      TypeChange:=(OldType<>NewType);

      If (OldType=NomHedCode) then {* Check if heading has any YTD *}
        Hed_YTDType(MoveCode,OldType,Fnum,Keypath,HedYTD,HedYTDNCF)
      else
      Begin

        HedYTD:=BOff;

        HedYTDNCF:=BOff;

      end;

      Repeat
        PostYTD:=((NomType In YTDSet) or (HedYTD));

        PostYTDNCF:=(((NomType In YTDNCFSet) or (HedYTDNCF)) and (Not PostYTD));

        If (MoveNom.Cat<>0) then {* Do not process if on level 0 *}
        Begin
          ThisStage:=(1*Ord(Not Loop)) + (11*Ord(Loop));

          If (Not Loop) then
            DCnst:=-1
          else
            DCnst:=1;

          If (RightStage(ThisStage)) then
          Begin

            KeyChk:=PartHistMKey(NomType,MoveCode);

            If (Not ThisLastStage(ThisStage)) then
            Begin
              KeyS:=KeyChk;
              LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
            end
            else
            Begin
              KeyS:=PMSCtrl^.MoveKey1;
              LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
              LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
            end;


            While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (not AbortTran) do
            With LNHist do
            Begin

              Inc(ItemCount);

              UpdateProgress(ItemCount);

              If (Not (Pr In [YTD,YTDNCF])) or (MoveCode=Syss.NomCtrlCodes[ProfitBF]) then
              Begin

                LStatus:=LGetPos(Fnum,RecAddr);  {* Preserve Posn of History Line *}

                If (LStatusOk) then
                Begin

                  If (TranOk2Run) then
                  Begin
                    LStatus:=LCtrl_BTrans(1);

                    TTEnabled:=LStatusOk;

                    TRanOk2Run:=TTEnabled;

                    {* Wait until All clear b4 continuing *}
                    If (TTEnabled) then
                      WaitForHistLock;

                    UpdatePMS(ThisStage,KeyS,'',BOff);
                  end
                  else
                    TTEnabled:=BOff;


                    LPost_To_Nominal(FullNomKey(MoveNom.Cat),
                                    (Purchases*DCnst),
                                    (Sales*DCnst),
                                    (Cleared*DCnst),
                                    Cr,Yr,Pr,
                                    2,PostYTD,BOff,PostYTDNCF,MRates,
                                    PrevBal,
                                    ActNom,0);


                    LSetDataRecOfs(Fnum,RecAddr);  {* Re-establish position *}

                    LStatus:=LGetDirect(Fnum,Keypath,0);


                    If (TypeChange) and (NomType In ProfitBFSet) then {* Adjust P&L YTD *}
                      LPost_To_Nominal(FullNomKey(Syss.NomCtrlCodes[ProfitBF]),
                                    (Purchases*DCnst),
                                    (Sales*DCnst),
                                    0,
                                    Cr,Yr,YTD,
                                    1,PostYTD,BOff,BOff,MRates,
                                    PrevBal,
                                    ActNom,0);

                  If (TTEnabled) then
                  Begin
                    UnLockHistLock;

                    LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                    LReport_BError(InvF,LStatus);

                  end;

                  LSetDataRecOfs(Fnum,RecAddr);  {* Re-establish position *}

                  LStatus:=LGetDirect(Fnum,Keypath,0);

                end; {If Pos got ok..}
              end; {If YTD..}

              LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

            end; {While..}

            If (TTEnabled) and (Not AbortTran) then {* Only update cpmpleted stage here *}
              UpdatePMS(ThisStage,KeyS,'',BOn);

          end;

          {* For each CC restore history *}

          BotStage:=(2*Ord(Not Loop)) + (12*Ord(Loop));

          ThisStage:=(3*Ord(Not Loop)) + (13*Ord(Loop));

          If (ChkTypeStages([BotStage..ThisStage])) then
             Nom_MoveCCHist(MoveNom.Cat,
                            MoveNom.NomType,
                            MoveNom.NomCode,
                            PostYTD,
                            PostYTDNCF,
                            MRates,
                            DCnst,
                            Fnum,
                            Keypath,
                            Pred(ThisStage));

        end; {If Group is level 0}

        If (Not Loop) then
        Begin


          If (ChkTypeStages([4..9])) or (RightStage(10)) then
          Begin
            KeyS:=FullNomKey(MoveCode);

            LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);

            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum2);

              LNom.Cat:=NewCat;

              LNom.NomType:=NewType;

              If (NomType<>CarryFlg) then
                CarryF:=0;

              If (TypeChange) and (ChkTypeStages([4..9])) then
                Change_NomType(OldType,NewType,LOk2DelNom(0,LNom),LNom);

              If (RightStage(10)) then {* Check incase Change nom type has failed... *}
              Begin

                If (TranOk2Run) then
                Begin
                  LStatus:=LCtrl_BTrans(1);

                  TTEnabled:=LStatusOk;

                  TRanOk2Run:=TTEnabled;

                  {* Wait until All clear b4 continuing *}
                  If (TTEnabled) then
                    WaitForHistLock;

                  UpdatePMS(10,KeyS,'',BOff);
                end
                else
                  TTEnabled:=BOff;

                LStatus:=LPut_Rec(Fnum2,Keypath2);

                LReport_BError(Fnum2,LStatus);

                If (Not AbortTran) and (TTEnabled) then
                  AbortTran:=(Not LStatusOk);

                If (TTEnabled) then
                Begin
                  UnLockHistLock;

                  UpdatePMS(10,KeyS,'',BOn);

                  LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                  LReport_BError(InvF,LStatus);

                end;
              end;
            end;

            LStatus:=LUnLockMLock(Fnum2);

            MoveNom:=LNom;


          end;
        end; {* If in second part of loop *}

        Loop:=Not Loop;

      Until (Not Loop);


    end; {If Can't find nominal}
  end; {with..}
end; {Proc..}




Function TNHistMove.Delete_MoveRecord(Fnum,
                                      Keypath  :  Integer;
                                      RecAddr  :  LongInt)  :  Boolean;

Begin
  Result:=BOff;

  If (RecAddr<>0) then
  With MTExLocal^ do
  Begin
    LastRecAddr[Fnum]:=RecAddr;

    LStatus:=LGetDirectRec(Fnum,KeyPath);

    If (LStatusOk) then
    Begin

      LStatus:=LDelete_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);

      Result:=LStatusOk;
    end;

  end;
end;

Procedure TNHistMove.Process_MoveList;

Const
  Fnum    = PWrdF;
  Keypath = PWK;

Var
  UOk,
  Ok2Del,
  Locked,
  Ok2Cont  :  Boolean;

  B_Func   :  Integer;

  KeyS,
  KeyChk   :  Str255;



Procedure Finish_Trans;

Begin
  If (TranOk2Run) and (TTEnabled) then {* Delete Ctrl File *}
  With MTExLocal^ do
  Begin
    LStatus:=LCtrl_BTrans(1);

    TTEnabled:=LStatusOk;

    FinishPMS;

    LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

    LReport_BError(InvF,LStatus);

    If (Not HaveAborted) then
      HaveAborted:=AbortTran;

    AbortTran:=BOff;

  end;

end;

Begin
  fCanAbort:=BOn;

  Ok2Cont:=BOff;
  KeyChk:=PartCCKey(MoveNomTCode,MNSubCode(MoveRepCtrl^.MoveMode-50));

  KeyS:=KeyChk;


  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) and (Not ThreadRec^.THAbort) and (Not HaveAborted) do
    With LPassword do
    Begin
      B_Func:=B_GetNext;  Ok2Del:=BOff;


      UOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,Locked);


      Case MoveRepCtrl^.MoveMode of
        51  :  With MoveNomRec do
               Begin
                 If (UOk) and (Locked) then
                 Begin
                   LGetRecAddr(Fnum);

                   PMListAddr:=LastRecAddr[Fnum];

                   If LGetMainRecPos(NomF,FullNomKey(MoveCode)) and (LNom.Cat=MoveFrom) then
                   Begin
                     If (Not (MoveType In YTDSet+YTDNCFSET+[NomHedCode])) then
                       MoveType:=LNom.NomType;

                     {$B-}
                     If ((MoveTo=0) or (LGetMainRecPos(NomF,FullNomKey(MoveTo)) and (LNom.NomType=NomHedCode) )) then
                     {$B+}
                     Begin
                       With MoveRepCtrl^ do
                       Begin
                         MoveNCode:=MoveCode;
                         NewNCat:=MoveTo;
                         WasNCat:=MoveFrom;
                         NewNType:=MoveType;

                         {$B-}
                         If (Not MAutoRecover) and (Not Check4AbortPMS) then {* Check for a previous abortion *}
                         {$B+}
                             Ok2Cont:=StartNewPMS;

                         If (Ok2Cont) then
                         Begin
                           Nom_Move(MoveNCode,NewNCat,NewNType,NHistF,NHK);

                           Finish_Trans;
                         end;
                       end;
                     end
                     else
                       Ok2Del:=BOn;
                   end
                   else
                     Ok2Del:=BOn;

                 end
                 else
                   Write_PostLogDD('Move instruction for'+Form_Int(MoveCode,0)+' Was not prcessed as the record was locked.'+#13+
                    ' This Move instruction has been ignored, but shall remain on the list.',BOn,'',0);

                 If (Ok2Del) or (Ok2Cont) then
                 Begin
                   If Delete_MoveRecord(Fnum,Keypath,PMListAddr) then
                   Begin
                     B_Func:=B_GetGEq;

                     If (Ok2Del) then
                       Write_PostLogDD('Move instruction for'+Form_Int(MoveCode,0)+' Was not prcessed as the instruction is no longer valid.'+#13+
                        ' This Move instruction has been ignored, and removed the list.',BOn,'',0);
                   end;
                 end;
               end;
      {$IFDEF STK}
        52  :  With MoveStkRec do
               Begin
                 If (UOk) and (Locked) then
                 Begin
                   LGetRecAddr(Fnum);

                   PMListAddr:=LastRecAddr[Fnum];

                   If LGetMainRecPos(StockF,FullStockCode(MoveCode)) then
                   Begin

                     //PR: 23/08/2012 ABSEXCH-11113 Set stock record on MoveRepCtrl otherwise, if this is a component in any BOM lists,
                     //it won't get renamed in those lists 
                      MoveRepCtrl^.MoveStk := MtExLocal.LStock;

                     {$B-}
                     //PR: 02/10/2017 ABSEXCH-18746 Need to check MTExLocal^.LStock rather than Stock
                     If (((EmptyKey(MToCode,StkKeyLen)) or (LGetMainRecPos(StockF,FullStockCode(MToCode)) and (LStock.StockType=StkGrpCode)) and (MToCode<>MFromCode)) or (Not EmptyKey(Trim(NewStkCode),StkKeyLen)))  then
                     {$B+}
                     Begin
                       With MoveRepCtrl^ do
                       Begin
                         MoveSCode:=MoveCode;
                         NewSCode:=NewStkCode;
                         WasSGrp:=MFromCode;
                         NewSGrp:=MToCode;

                         {$B-}
                         If (Not MAutoRecover) and (Not Check4AbortPMS) then {* Check for a previous abortion *}
                         {$B+}
                             Ok2Cont:=StartNewPMS;

                         If (Ok2Cont) then
                         Begin
                           LastRecAddr[Fnum]:=PMListAddr;

                           LStatus:=LGetDirectRec(Fnum,KeyPath);

                           {$B-}
                           If ((EmptyKey(MToCode,StkKeyLen)) or (LGetMainRecPos(StockF,FullStockCode(MToCode)) and (LStock.StockType=StkGrpCode)) and (MToCode<>MFromCode)) then
                           Begin
                           {$B+}
                             Stk_Move(MoveSCode,NewSGrp,NewSCode,BOff,NHistF,NHK);


                           end;

                           {$B-}
                             If (Not EmptyKey(Trim(NewSCode),StkKeyLen)) and (Not LGetMainRecPos(StockF,FullStockCode(NewSCode))) and (Not ThreadRec^.THAbort)  then
                           {$B+}
                             Begin
                               Finish_Trans;

                               MoveMode:=54;

                               Try
                                 StartNewPMS;

                                 CtrlRen_Stk(MoveSCode,NewSCode);
                               
                               finally
                                 MoveMode:=52;
                               end;


                             end;

                           Finish_Trans;

                         end;
                       end;
                     end
                     else
                       Ok2Del:=BOn;
                   end
                   else
                     Ok2Del:=BOn;

                 end
                 else
                   Write_PostLogDD('The Move instruction for'+Trim(MoveCode)+' was not prcessed as the record was locked.'+#13+
                    ' This Move instruction has been ignored, but shall remain on the list.',BOn,'',0);

                 If (Ok2Del) or (Ok2Cont) then
                 Begin


                   If Delete_MoveRecord(Fnum,Keypath,PMListAddr) then
                   Begin
                     B_Func:=B_GetGEq;

                     If (Ok2Del) then
                       Write_PostLogDD('The Move instruction for'+Trim(MoveCode)+' was not prcessed as the instruction is no longer valid.'+#13+
                        ' This Move instruction has been ignored, and removed the list.',BOn,'',0);
                   end;
                 end;
               end;
      {$ENDIF}

      end; {Case..}

      LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

    end; {While..}

    {$IFDEF Rp}
      {$IFDEF FRM}
        If (Assigned(PostLog)) then
          PostLog.PrintLog(PostRepCtrl,'Move List log.');

      {$ENDIF}
          {$ENDIF}

  end;
end; {Proc..}



{ ======== Part G/L View History Key ======== }

Function TNHistMove.PartHistViewMKey(NVRec  :  NomViewRec)  :  Str50;

Begin

  With NVRec.NomViewLine do
  Begin
    Result:=ViewType+PostNVIdx(NomViewNo,ABSViewIdx);
  end;

end; {Func..}



{ ======== Proc to determine what type of YTD (if any) a heading type contains ===== }

Procedure TNHistMove.Hed_ViewYTDType(NVRec     :  NomViewRec;
                                     Fnum,
                                     Keypath   :  Integer;
                                 Var YTDOk,
                                     YTDNCFOk  :  Boolean);



Var
  FoundOk  :  Boolean;
  KeyS,
  KeyChk   :  Str255;

  HedHist :  HistoryRec;


Begin

  YTDOk:=BOff;
  YTDNCFOk:=BOff;

  FoundOk:=BOff;

  KeyChk:=PartHistViewMKey(NVRec);

  KeyS:=KeyChk;

  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With LNHist do
    Begin
      HedHist:=LNHist;

      FoundOk:=(Pr In [YTD,YTDNCF]);

      If (Not FoundOk) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      If (HedHist.Pr=YTDNCF) then;
    end; {While..}

    If (FoundOk) then
    With LNHist do
    Begin

      YTDOk:=(Pr=YTD);
      YTDNCFOk:=(Pr=YTDNCF);

    end;
  end;
end; {Proc..}


Procedure TNHistMove.PostViewMove(NVRec     :  NomViewRec;
                                  GetHist   :  HistoryRec;
                                  CatCode   :  LongInt;
                                  YTDOk,
                                  YTDNCFOk,
                                  AutoPBF   :  Boolean;
                                  DedCnst,
                                  Fnum,
                                  Keypath   :  Integer;
                                  Level     :  LongInt);


Var
  YTDType,
  n       :  Byte;

  FoundOk,FLoop,
  LOk,
  Locked  :  Boolean;

  TmpKPath,
  TmpStat
          :  Integer;

  TmpRecAddr
          :  LongInt;

  PBalBF  :  Double;

  KeyHS,
  KeyHChk,
  KeyS,
  KeyChk  :  Str255;

  LUP     :  tPassDefType;
  {$IFDEF PERIODFIX}
    oUPCache : TUserPeriodCache;
  {$ENDIF}

  HedHist :  HistoryRec;


Begin
  LUP:=UserProfile^;
  {$IFDEF PERIODFIX}
    oUPCache := oUserPeriod.GetCache;
  {$ENDIF}

  n:=0; PBalBF:=0;  YTDType:=0;

  With MTExLocal^ do
  Begin
    // MH 07/07/08: Set TmpKPath as previous random value was causing SQL emulator to crash on restore call
    TmpKpath := GetPosKey;
    TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    With NVRec.NomViewLine do
      KeyS:=FullNVIdx(NVRCode,NVVSCode,NomViewNo,CatCode,BOn);

    LStatus:=LFind_Rec(B_GetEq,NomViewF,NVViewIDxK,KeyS);

    If (LStatusOk) then
    Begin

      If ((GetHist.Pr<>YTD) or (AutoPBF))  then {Only process non carry forward codes, as YTD will be updated automatically. Purge year not destroyed}
      Repeat {Attempt to find immediate parent equivalent, if not create via fill}
        With LNomView^.NomViewLine do
          KeyHChk:=FullNHistKey(ViewType,PostNVIdx(NomViewNo,ABSViewIdx),GetHist.Cr,GetHist.Yr,GetHist.Pr);

        KeyHS:=KeyHChk;

        LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyHS);

        If (Not LStatusOk) or (Not CheckKey(KeyHChk,KeyHS,Length(KeyHChk),BOn)) then
        Begin
          {$IFDEF PERIODFIX}
          oUserPeriod.SetPeriodYear(GetHist.Pr, GetHist.Yr);
          {$ELSE}
          With UserProfile^ do
          Begin
            UCYr:=GetHist.Yr;
            UCPr:=GetHist.Pr;
          end;
          {$ENDIF}

          LFillBudget(FNum,KeyPath,n,KeyHChk);

        end
        else
          FoundOk:=BOn;

        fLoop:=Not fLoop;

      Until (Not fLoop) or (FoundOk);


      If (FoundOk) then
      Begin
        HedHist:=LNHist;


        LPost_To_Hist2(HedHist.ExClass,HedHist.Code,
                                     GetHist.Purchases*DedCnst,
                                     GetHist.Sales*DedCnst,
                                     GetHist.Cleared*DedCnst,
                                     GetHist.Value1*DedCnst,
                                     GetHist.Value2*DedCnst,
                                     HedHist.Cr,HedHist.Yr,HedHist.Pr,
                                     PBalBF);


        If (YTDOk or YTDNCFOK) and (Not AutoPBF) then {Process carry forward codes YTD, and future YTD}
        Begin
          If (YTDOK) then
            YTDType:=YTD
          else
            YTDType:=YTDNCF;

          LPost_To_CYTDHist2(HedHist.ExClass,HedHist.Code,
                             GetHist.Purchases*DedCnst,
                             GetHist.Sales*DedCnst,
                             GetHist.Cleared*DedCnst,
                             GetHist.Value1*DedCnst,
                             GetHist.Value2*DedCnst,
                             HedHist.Cr,HedHist.Yr,YTDType);
        end;
      end; {If Found Ok..}

      TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
    end; {If Found parent}
  end; {With..}

  UserProfile^:=LUP;
  {$IFDEF PERIODFIX}
    oUserPeriod.RestoreCache(oUPCache);
  {$ENDIF}

  With MTExLocal^,LNomView^.NomViewLine do
  Begin
    If (ViewCat<>0) then
    Begin
      KeyS:=FullNVIdx(NVRCode,NVVSCode,NomViewNo,ViewCat,BOn);

      LStatus:=LFind_Rec(B_GetEq,NomViewF,NVViewIDxK,KeyS);

      If (LStatusOk) then {Post up the hireachy}
      Begin

        PostViewMove(LNomView^,GetHist,ViewCat,YTDOk,YTDNCFOk,AutoPBF,DedCnst,Fnum,Keypath,Succ(Level));

      end;

    end;
  end;
end;


  { =========== Procedure to Move Nominal View Code ========= }


  Procedure TNHistMove.NomView_Move(NVRec     :  NomViewRec;
                                    NewCat     :  LongInt;
                                    Fnum,
                                    Keypath    :  Integer);


  Const
    Fnum2      =  NomViewF;
    Keypath2   =  NVCodeK;


  Var
    MoveNom  :  NomViewRec;
    RecAddr  :  LongInt;

    KeyChk,
    KeyS     :  Str255;


    Loop,
    PostYTD,
    PostYTDNCF,
    HedYTD,
    HedYTDNCF
             :  Boolean;

    DCnst    :  Integer;

    PrevBal  :  Double;

    ActNom   :  LongInt;

    MRates   :  CurrTypes;

    LOk,
    Locked   :  Boolean;




  Begin

    PrevBal:=0;

    ActNom:=0;

    MRates[BOff]:=1; MRates[BOn]:=1;

    With NVRec.NomViewLine do
      KeyS:=FullNVCode(NVRCode,NVVSCode,NomViewNo,ViewCode,BOn);

    Locked:=BOff;

    With MTExLocal^ do
    Begin
      LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyS);

      If (LStatusOk) then
      With MoveNom.NomViewLine do
      Begin
        MoveNom:=LNomView^;

        Loop:=BOff;

        {$B-}
        If (LinkGL=0) or (Not LGetMainRecPos(NomF,FullNomKey(LinkGL))) then
        {$B+}
          LResetRec(NomF);

        Hed_ViewYTDType(MoveNom,Fnum,Keypath,HedYTD,HedYTDNCF);


        Repeat
          PostYTD:=((LNom.NomType In YTDSet) or (HedYTD));

          PostYTDNCF:=(((LNom.NomType In YTDNCFSet) or (HedYTDNCF)) and (Not PostYTD));

          If (MoveNom.NomVieWLine.ViewCat<>0) then {* Do not process if on level 0 *}
          Begin

            If (Not Loop) then
              DCnst:=-1
            else
              DCnst:=1;

            Begin

              KeyChk:=PartHistViewMKey(MoveNom);

              KeyS:=KeyChk;
              LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);


              While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (not AbortTran) do
              With LNHist do
              Begin

                Inc(ItemCount);

                {$IFDEF DBD} 
                  If ((LNHist.Sales+LNHist.Purchases)<>0.0) then
                    MessageBeep(0);
                {$ENDIF}

                UpdateProgress(ItemCount);

                

                If (Not (Pr In [YTD,YTDNCF])) or (LNom.NomCode=Syss.NomCtrlCodes[ProfitBF]) then
                Begin
                  LStatus:=LGetPos(Fnum,RecAddr);  {* Preserve Posn of History Line *}


                  If (LStatusOk) then
                  Begin

                    PostViewMove(MoveNom,LNHist,ViewCat,PostYTD,PostYTDNCF,(LNom.NomCode=Syss.NomCtrlCodes[ProfitBF]),DCnst,Fnum,Keypath,0);

                    LSetDataRecOfs(Fnum,RecAddr);  {* Re-establish position *}

                    LStatus:=LGetDirect(Fnum,Keypath,0);

                  end; {If Pos got ok..}
                end; {If YTD..}

                
                LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

              end; {While..}


            end;


          end; {If Group is level 0}

          If (Not Loop) then
          Begin


            Begin
              With NVRec.NomViewLine do
                KeyS:=FullNVCode(NVRCode,NVVSCode,NomViewNo,ViewCode,BOn);


              LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);

              If (LOk) and (Locked) then
              Begin
                LGetRecAddr(Fnum2);

                LNomView^.NomViewLine.ViewCat:=NewCat;

                Begin

                  BuildView_Ndx(MTExLocal^);
                  
                  LStatus:=LPut_Rec(Fnum2,Keypath2);

                  LReport_BError(Fnum2,LStatus);

                  If (Not AbortTran) and (TTEnabled) then
                    AbortTran:=(Not LStatusOk);


                end;
              end;

              LStatus:=LUnLockMLock(Fnum2);

              MoveNom:=LNomView^;


            end;
          end; {* If in second part of loop *}

          Loop:=Not Loop;

        Until (Not Loop);


      end; {If Can't find View Code}
    end; {with..}
  end; {Proc..}



{$IFDEF STK}

  {$IFDEF SOP}  {* For each location restore history *}
    Procedure TNHistMove.Stk_MoveLocHist(StkCat         :  Str20;
                                         StkType        :  Char;
                                         StkFolio       :  LongInt;
                                         PostYTD,
                                         PostYTDNCF     :  Boolean;
                                         MRates         :  CurrTypes;
                                         DCnst,
                                         Fnum,Keypath,
                                         ThisStage      :  Integer);

    Const
      Fnum2     =  MLocF;
      Keypath2  =  MLK;

    Var
      KeyChk,KeyS,
      KeyS2,KeyChk2  :  Str255;


      RecAddr        :  LongInt;

    Begin


      KeyChk2:=PartCCKey(CostCCode,CSubCode[BOn]);

      If (Not ThisLastStage(ThisStage)) then
        KeyS2:=KeyChk2
      else
        KeyS2:=PMSCtrl^.MoveKey1;


      With MTExLocal^ do
      Begin

        LStatus:=LFind_Rec(B_GetGEq,Fnum2,Keypath2,KeyS2);

        While (LStatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOff)) and (Not AbortTran) and (RightStage(ThisStage)) do
        With LMLocCtrl^,MLocLoc do
        Begin
          KeyChk:=StkType+CalcKeyHistPOn(StkFolio,loCode);

          If (Not ThisLastStage(ThisStage)) then
          Begin
            KeyS:=KeyChk;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
          end
          else
          Begin
            KeyS:=PMSCtrl^.MoveKey2;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
            LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
          end;


          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
          With LNHist do
          Begin
            Inc(ItemCount);

            UpdateProgress(ItemCount);


            If (Not (Pr In [YTD,YTDNCF])) then
            Begin

              LStatus:=LGetPos(Fnum,RecAddr);  {* Preserve Posn of History Line *}

              If (LStatusOk) then
              Begin
                If (TranOk2Run) then
                Begin
                  LStatus:=LCtrl_BTrans(1);

                  TTEnabled:=LStatusOk;

                  TRanOk2Run:=TTEnabled;

                  {* Wait until All clear b4 continuing *}
                  If (TTEnabled) then
                    WaitForHistLock;

                  UpdatePMS(ThisStage,KeyS2,KeyS,BOff);
                end
                else
                  TTEnabled:=BOff;


                  Post_To_Stock(StkCat,
                               (Purchases*DCnst),
                               (Sales*DCnst),
                               (Cleared*DCnst),
                               (Value1*DCnst),
                               Cr,Yr,Pr,
                               2,PostYTD,BOff,PostYTDNCF,BOff,BOn,MRates,0.0,loCode,0);


                If (TTEnabled) then
                Begin
                  UnLockHistLock;

                  LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                  LReport_BError(InvF,LStatus);

                end;


                LSetDataRecOfs(Fnum,RecAddr);  {* Re-establish position *}

                LStatus:=LGetDirect(Fnum,Keypath,0);

              end; {If Pos got ok..}
            end; {If YTD..}

            LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

          end; {While..}

          LStatus:=LFind_Rec(B_GetNext,Fnum2,Keypath2,KeyS2);
        end;

        If (TTEnabled) and (Not AbortTran) then
          UpdatePMS(ThisStage,KeyS2,KeyS,BOn);
      end; {With..}
    end;



  {$ENDIF}


  { =========== Procedure to Move Stock Code ========= }


  Procedure TNHistMove.Stk_Move(MoveCode,
                                NewCat,
                                NewCode    :  Str20;
                                CodeChange :  Boolean;
                                Fnum,
                                Keypath    :  Integer);


  Const
    Fnum2      =  StockF;
    Keypath2   =  StkCodeK;



  Var
    MoveStk  :  StockRec;
    RecAddr  :  LongInt;

    KeyChk,
    KeyS     :  Str255;

    ThisStage:  Byte;

    Loop,
    PostYTD,
    PostYTDNCF,
    HedYTD,
    HedYTDNCF
             :  Boolean;

    DCnst    :  Integer;

    MRates   :  CurrTypes;

    LOk,
    Locked   :  Boolean;




  Begin

    MRates[BOff]:=1; MRates[BOn]:=1;

    KeyS:=FullStockCode(MoveCode);

    Locked:=BOff; LOk:=BOff;

    With MTExLocal^ do
    Begin

      LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyS);

      If (LStatusOk) then
      With MoveStk do
      Begin

        MoveStk:=LStock;

        Loop:=BOff;

        If (StockType=StkGrpCode) then {* Check if heading has any YTD *}
          Hed_YTDType(StockFolio,StockType,Fnum,Keypath,HedYTD,HedYTDNCF)
        else
        Begin

          HedYTD:=BOff;

          HedYTDNCF:=BOff;

        end;


        Repeat


          PostYTD:=((StockType In YTDSet) or (HedYTD));

          PostYTDNCF:=(((StockType In YTDNCFSet) or (HedYTDNCF)) and (Not PostYTD));

          If (Not EmptyKey(MoveStk.StockCat,StkKeyLen)) then {* Do not process if on level 0 *}
          Begin
            ThisStage:=(1*Ord(Not Loop)) + (4*Ord(Loop));

            If (Not Loop) then
              DCnst:=-1
            else
              DCnst:=1;

            If (RightStage(ThisStage)) then
            Begin

              KeyChk:=PartHistMKey(StockType,MoveStk.StockFolio);

              If (Not ThisLastStage(ThisStage)) then
              Begin
                KeyS:=KeyChk;
                LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
              end
              else
              Begin
                KeyS:=PMSCtrl^.MoveKey1;
                LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
                LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
              end;

              While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (not AbortTran) do
              With LNHist do
              Begin
                Inc(ItemCount);

                UpdateProgress(ItemCount);


                If (Not (Pr In [YTD,YTDNCF])) then
                Begin

                  LStatus:=LGetPos(Fnum,RecAddr);  {* Preserve Posn of History Line *}

                  If (LStatusOk) then
                  Begin
                    If (TranOk2Run) then
                    Begin
                      LStatus:=LCtrl_BTrans(1);

                      TTEnabled:=LStatusOk;

                      TRanOk2Run:=TTEnabled;

                      {* Wait until All clear b4 continuing *}
                      If (TTEnabled) then
                        WaitForHistLock;

                      UpdatePMS(ThisStage,KeyS,'',BOff);
                    end
                    else
                      TTEnabled:=BOff;


                      Post_To_Stock(MoveStk.StockCat,
                                    (Purchases*DCnst),
                                    (Sales*DCnst),
                                    (Cleared*DCnst),
                                    (Value1*DCnst),
                                    Cr,Yr,Pr,
                                    2,PostYTD,BOff,PostYTDNCF,BOff,BOn,MRates,0.0,'',0);



                    If (TTEnabled) then
                    Begin
                      UnLockHistLock;

                      LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                      LReport_BError(InvF,LStatus);

                    end;

                    LSetDataRecOfs(Fnum,RecAddr);  {* Re-establish position *}

                    LStatus:=LGetDirect(Fnum,Keypath,0);

                  end; {If Pos got ok..}
                end; {If YTD..}

                LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

              end; {While..}


              If (TTEnabled) and (Not AbortTran) then {* Only update cpmpleted stage here *}
                UpdatePMS(ThisStage,KeyS,'',BOn);

            end;


            {$IFDEF SOP}  {* For each location restore history *}
              ThisStage:=(2*Ord(Not Loop)) + (5*Ord(Loop));

              If (RightStage(ThisStage)) then
                Stk_MoveLocHist(MoveStk.StockCat,
                                MoveStk.StockType,
                                MoveStk.StockFolio,
                                PostYTD,
                                PostYTDNCF,
                                MRates,
                                DCnst,
                                Fnum,
                                Keypath,
                                ThisStage);
            {$ENDIF}


          end; {If Group is level 0}

          If (Not Loop) and (RightStage(3)) then
          Begin

            KeyS:=FullStockCode(MoveCode);

            LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);


            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum2);

              LStock.StockCat:=FullStockCode(NewCat);

              {If (CodeChange) then
                LStock.StockCode:=NewCode;}

              If (TranOk2Run) then
              Begin
                LStatus:=LCtrl_BTrans(1);

                TTEnabled:=LStatusOk;

                TRanOk2Run:=TTEnabled;

                {* Wait until All clear b4 continuing *}
                If (TTEnabled) then
                  WaitForHistLock;

                UpdatePMS(3,KeyS,'',BOff);
              end
              else
                TTEnabled:=BOff;

              LStatus:=LPut_Rec(Fnum2,Keypath2);

              LReport_BError(Fnum2,LStatus);

              If (Not AbortTran) and (TTEnabled) then
                AbortTran:=(Not LStatusOk);

              If (TTEnabled) then
              Begin
                UnLockHistLock;

                UpdatePMS(3,KeyS,'',BOn);

                LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                LReport_BError(InvF,LStatus);

              end;


              LStatus:=LUnLockMLock(Fnum2);

              MoveStk:=LStock;


            end;
          end; {* If in second part of loop *}

          Loop:=Not Loop;

        Until (Not Loop);


      end; {If Can't find nominal}
    end; {With..}

  end; {Proc..}


    { ===== Procedure to Renumber Stock & Related Files ===== }

  Procedure TNHistMove.Renumber_Stock(OldCode,
                                      NewCode  :  Str20);



  Var
    Fnum,
    Keypath,
    B_Func,
    ThisStage
              :  Integer;

    KeyS,
    KeyChk    :  Str255;

    LOk,
    Locked,
    Loop      :  Boolean;

    nl        :  Byte;


  Begin

    B_Func:=B_GetNext;

    Loop:=BOff; LOk:=BOff;

    Fnum:=StockF;
    Keypath:=StkCatK;

    Locked:=BOff;

    ThisStage:=1;

    With MTExLocal^ do
    Begin
      If (RightStage(ThisStage)) then
      Begin

        KeyChk:=FullStockCode(OldCode);


        If (Not ThisLastStage(ThisStage)) then
        Begin
          KeyS:=KeyChk;
          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        end
        else
        Begin
          KeyS:=PMSCtrl^.MoveKey1;
          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
        end;

        Inc(ItemCount);

        UpdateProgress(ItemCount);


        ShowStatus(2,'Updating Stock sub groups.');

        {* Other Stock Codes within the Group *}

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
        With LStock do
        Begin

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            StockCat:=FullStockCode(NewCode);

            If (TranOk2Run) then
            Begin
              LStatus:=LCtrl_BTrans(1);

              TTEnabled:=LStatusOk;

              TRanOk2Run:=TTEnabled;

              {* Wait until All clear b4 continuing *}
              If (TTEnabled) then
                WaitForHistLock;

              UpdatePMS(ThisStage,KeyS,'',BOff);
            end
            else
              TTEnabled:=BOff;

            LStatus:=LPut_Rec(Fnum,Keypath);

            LReport_BError(Fnum,LStatus);

            If (Not AbortTran) and (TTEnabled) then
              AbortTran:=(Not LStatusOk);

            
            If (TTEnabled) then
            Begin
              UnLockHistLock;


              LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

              LReport_BError(InvF,LStatus);

            end;

            LStatus:=LUnLockMLock(Fnum);

            If (LStatusOk) then
              B_Func:=B_GetGEq
            else
              B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;

          LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

        end; {While..}

        If (TTEnabled) and (Not AbortTran) then
          UpdatePMS(ThisStage,KeyS,'',BOn);

      end;

      ThisStage:=2;

      If (RightStage(ThisStage)) then
      Begin

        ShowStatus(2,'Updating transaction lines');

        Fnum:=IdetailF;
        Keypath:=IdStkK;

        Locked:=BOff;

        {KeyChk:=FullStockCode(OldCode); Altered so it will repair lowercase stock codes}

        KeyChk:=LJVar(OldCode,StkKeyLen);

        If (Not ThisLastStage(ThisStage)) then
        Begin
          KeyS:=KeyChk;
          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        end
        else
        Begin
          KeyS:=PMSCtrl^.MoveKey1;
          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
        end;

        {* All Detail Lines *}


        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
        With LId do
        Begin

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            StockCode:=FullStockCode(NewCode);

            If (TranOk2Run) then
            Begin
              LStatus:=LCtrl_BTrans(1);

              TTEnabled:=LStatusOk;

              TRanOk2Run:=TTEnabled;

              {* Wait until All clear b4 continuing *}
              If (TTEnabled) then
                WaitForHistLock;

              UpdatePMS(ThisStage,KeyS,'',BOff);
            end
            else
              TTEnabled:=BOff;

            LStatus:=LPut_Rec(Fnum,Keypath);

            LReport_BError(Fnum,LStatus);

            If (Not AbortTran) and (TTEnabled) then
              AbortTran:=(Not LStatusOk);

            If (TTEnabled) then
            Begin
              UnLockHistLock;


              LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

              LReport_BError(InvF,LStatus);

            end;

            LStatus:=LUnLockMLock(Fnum);

            If (LStatusOk) then
              B_Func:=B_GetGEq
            else
              B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;

          LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

        end; {While..}

        If (TTEnabled) and (Not AbortTran) then
          UpdatePMS(ThisStage,KeyS,'',BOn);

      end;

      ThisStage:=3;

      If (RightStage(ThisStage)) then
      Begin

        ShowStatus(2,'Updating Bill of Material components.');

        Fnum:=PWrdF;
        Keypath:=HelpNdxK;

        Locked:=BOff;

        FillChar(KeyChk,Sizeof(KeyChk),#0);

        KeyChk:=FullStockCode(NewCode);


        {GetStock(KeyChk,KeyChk,-1);}

        {If (LGetMainRecPos(StockF,KeyChk)) then //v4.32 For some reason the upaded version of the stock record was never found at this stage,
                                                   it could only find the old copy which is very dodgey. As we only need the folio for this section
                                                   we can use the local copy to get that.}
        Begin

          KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(MoveRepCtrl^.MoveStk.StockFolio)));

          If (Not ThisLastStage(ThisStage)) then
          Begin
            KeyS:=KeyChk;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
          end
          else
          Begin
            KeyS:=PMSCtrl^.MoveKey1;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
            LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
          end;


          {* All BOM Lines *}


          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
          With LPassword.BillMatRec do
          Begin
            Inc(ItemCount);

            UpdateProgress(ItemCount);


            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              FullStkCode:=FullStockCode(NewCode);

              If (TranOk2Run) then
              Begin
                LStatus:=LCtrl_BTrans(1);

                TTEnabled:=LStatusOk;

                TRanOk2Run:=TTEnabled;

                {* Wait until All clear b4 continuing *}
                If (TTEnabled) then
                  WaitForHistLock;

                UpdatePMS(ThisStage,KeyS,'',BOff);
              end
              else
                TTEnabled:=BOff;

              LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

              If (Not AbortTran) and (TTEnabled) then
                AbortTran:=(Not LStatusOk);

              If (TTEnabled) then
              Begin
                UnLockHistLock;


                LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                LReport_BError(InvF,LStatus);

              end;

              LStatus:=LUnLockMLock(Fnum);

              B_Func:=B_GetNext;

            end
            else
              B_Func:=B_GetNext;

            LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

          end; {While..}

          If (TTEnabled) and (Not AbortTran) then
            UpdatePMS(ThisStage,KeyS,'',BOn);
        end;


      end; {If..}

      Fnum:=MiscF;
      Keypath:=MiscNdxK;

      ThisStage:=4;


      Repeat
        If (RightStage(ThisStage+Ord(Loop))) then
        Begin

          ShowStatus(2,'Updating discount matrices.');

          Locked:=BOff;

          KeyChk:=FullQDKey(CDDiscCode,TradeCode[Loop],OldCode);

          If (Not ThisLastStage(ThisStage+Ord(Loop))) then
          Begin
            KeyS:=KeyChk;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
          end
          else
          Begin
            KeyS:=PMSCtrl^.MoveKey1;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
            LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
          end;


          {* Account Discounts *}

          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
          With LMiscRecs^.CustDiscRec do
          Begin
            Inc(ItemCount);

            UpdateProgress(ItemCount);

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              QStkCode:=FullStockCode(NewCode);

              DiscCode:=MakeCDKey(DCCode,QStkCode,QBCurr)+HelpKStop;

              If (TranOk2Run) then
              Begin
                LStatus:=LCtrl_BTrans(1);

                TTEnabled:=LStatusOk;

                TRanOk2Run:=TTEnabled;

                {* Wait until All clear b4 continuing *}
                If (TTEnabled) then
                  WaitForHistLock;

                UpdatePMS(ThisStage+Ord(Loop),KeyS,'',BOff);
              end
              else
                TTEnabled:=BOff;

              LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

              If (Not AbortTran) and (TTEnabled) then
                AbortTran:=(Not LStatusOk);

              If (TTEnabled) then
              Begin
                UnLockHistLock;


                LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                LReport_BError(InvF,LStatus);

              end;

              LStatus:=LUnLockMLock(Fnum);

              If (LStatusOk) then
                B_Func:=B_GetGEq
              else
                B_Func:=B_GetNext;

            end
            else
              B_Func:=B_GetNext;

            LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

          end; {While..}

          If (TTEnabled) and (Not AbortTran) then
            UpdatePMS(ThisStage+Ord(Loop),KeyS,'',BOn);
        end; {If..}

        Loop:=Not Loop;

      Until (Not Loop);


      {$IFDEF SOP}
         {* Location stock records *}
        Fnum:=MLocF;
        Keypath:=MLK;

        Locked:=BOff;

        ThisStage:=6;

        If (RightStage(ThisStage)) then
        Begin

          ShowStatus(2,'Updating location records.');

          KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+OldCode;

          If (Not ThisLastStage(ThisStage)) then
          Begin
            KeyS:=KeyChk;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
          end
          else
          Begin
            KeyS:=PMSCtrl^.MoveKey1;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

            LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
          end;


          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
          With LMLocCtrl^,MStkLoc do
          Begin
            Inc(ItemCount);

            UpdateProgress(ItemCount);

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              lsStkCode:=FullStockCode(NewCode);

              lsCode1:=Full_MLocSKey(lsLocCode,lsStkCode);
              lsCode2:=Full_MLocLKey(lsLocCode,lsStkCode);

              If (TranOk2Run) then
              Begin
                LStatus:=LCtrl_BTrans(1);

                TTEnabled:=LStatusOk;

                TRanOk2Run:=TTEnabled;

                {* Wait until All clear b4 continuing *}
                If (TTEnabled) then
                  WaitForHistLock;

                UpdatePMS(ThisStage,KeyS,'',BOff);
              end
              else
                TTEnabled:=BOff;


              LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

              If (Not AbortTran) and (TTEnabled) then
                AbortTran:=(Not LStatusOk);

              If (TTEnabled) then
              Begin
                UnLockHistLock;


                LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                LReport_BError(InvF,LStatus);

              end;


              LStatus:=LUnLockMLock(Fnum);

              B_Func:=B_GetGEq;

            end
            else
              B_Func:=B_GetNext;

            LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

          end; {While..}

          For nl:=Succ(Low(AltSPFix)) to Pred(High(AltSPFix)) do
          Begin
            ShowStatus(2,'Updating Alternative records.');

            KeyChk:=PartCCKey(NoteTCode,AltSPfix[nl])+OldCode;

            KeyS:=KeyChk;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);


            While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
            With LMLocCtrl^,sdbStkRec do
            Begin
              Inc(ItemCount);

              UpdateProgress(ItemCount);

              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

              If (LOk) and (Locked) then
              Begin
                LGetRecAddr(Fnum);

                sdCode1:=FullStockCode(NewCode);

                sdCode2:=Full_SupStkKey(sdStkFolio,sdCode1);
                sdCode3:=FullRunNoKey(sdStkFolio,sdLineNo)+sdCode1;

                If (TranOk2Run) then
                Begin
                  LStatus:=LCtrl_BTrans(1);

                  TTEnabled:=LStatusOk;

                  TRanOk2Run:=TTEnabled;

                  {* Wait until All clear b4 continuing *}
                  If (TTEnabled) then
                    WaitForHistLock;

                  UpdatePMS(ThisStage,KeyS,'',BOff);
                end
                else
                  TTEnabled:=BOff;


                LStatus:=LPut_Rec(Fnum,Keypath);

                LReport_BError(Fnum,LStatus);

                If (Not AbortTran) and (TTEnabled) then
                  AbortTran:=(Not LStatusOk);

                If (TTEnabled) then
                Begin
                  UnLockHistLock;


                  LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                  LReport_BError(InvF,LStatus);

                end;


                LStatus:=LUnLockMLock(Fnum);

                B_Func:=B_GetGEq;

              end
              else
                B_Func:=B_GetNext;

              LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

            end; {While..}
          end; {loop..}



          If (TTEnabled) and (Not AbortTran) then
            UpdatePMS(ThisStage,KeyS,'',BOn);
        end;

      {$ENDIF}



       {* Account analysis *}
        Fnum:=MLocF;
        Keypath:=MLSuppK;


        Locked:=BOff;

        ThisStage:=7;

        If (RightStage(ThisStage)) then
        Begin

          ShowStatus(2,'Updating Account Stock Analysis records.');

          KeyChk:=PartCCKey(MatchTCode,MatchSCode)+OldCode;

          If (Not ThisLastStage(ThisStage)) then
          Begin
            KeyS:=KeyChk;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
          end
          else
          Begin
            KeyS:=PMSCtrl^.MoveKey1;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

            LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
          end;


          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
          With LMLocCtrl^,cuStkRec do
          Begin
            Inc(ItemCount);

            UpdateProgress(ItemCount);

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              csStockCode:=FullStockCode(NewCode);

              csCode1:=Full_CuStkLKey(csCustCode,csLineNo);
              csCode2:=Full_CuStkKey(csCustCode,csStockCode);
              csCode3:=Full_CuStkKey2(csCustCode,csStockCode);

              If (TranOk2Run) then
              Begin
                LStatus:=LCtrl_BTrans(1);

                TTEnabled:=LStatusOk;

                TRanOk2Run:=TTEnabled;

                {* Wait until All clear b4 continuing *}
                If (TTEnabled) then
                  WaitForHistLock;

                UpdatePMS(ThisStage,KeyS,'',BOff);
              end
              else
                TTEnabled:=BOff;


              LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

              If (Not AbortTran) and (TTEnabled) then
                AbortTran:=(Not LStatusOk);

              If (TTEnabled) then
              Begin
                UnLockHistLock;


                LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                LReport_BError(InvF,LStatus);

              end;


              LStatus:=LUnLockMLock(Fnum);

              B_Func:=B_GetGEq;

            end
            else
              B_Func:=B_GetNext;

            LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

          end; {While..}

          If (TTEnabled) and (Not AbortTran) then
            UpdatePMS(ThisStage,KeyS,'',BOn);
        end;
    end; {With..}

  end; {Proc..}

  Procedure TNHistMove.CtrlRen_Stk(OldCode,
                                   NewCode  :  Str20);

  Var
    KeyS  :  Str255;

    LOk,Locked
          :  Boolean;

    Fnum2,
    Keypath2
          :  SmallInt;

  Begin
    With MTExLocal^ do
    Begin
      Fnum2:=StockF; Keypath2:=StkCodeK;

      ItemTotal:=Used_RecsCId(LocalF^[IdetailF],IDetailF,ExCLientId)+Used_RecsCId(LocalF^[StockF],StockF,ExCLientId);

      InitProgress(ItemTotal);

      Renumber_Stock(OldCode,NewCode);

      If (RightStage(8)) then {* Check incase Change nom type has failed... *}
      Begin
        KeyS:=FullStockCode(OldCode);

        LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);


        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum2);

          LStock.StockCode:=NewCode;

          If (TranOk2Run) then
          Begin
            LStatus:=LCtrl_BTrans(1);

            TTEnabled:=LStatusOk;

            TRanOk2Run:=TTEnabled;

            {* Wait until All clear b4 continuing *}
            If (TTEnabled) then
              WaitForHistLock;

            UpdatePMS(8,KeyS,'',BOff);
          end
          else
            TTEnabled:=BOff;

          LStatus:=LPut_Rec(Fnum2,Keypath2);

          LReport_BError(Fnum2,LStatus);

          If (Not AbortTran) and (TTEnabled) then
            AbortTran:=(Not LStatusOk);

          If (TTEnabled) then
          Begin
            UnLockHistLock;

            UpdatePMS(8,KeyS,'',BOn);

            LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

            LReport_BError(InvF,LStatus);

          end;


          LStatus:=LUnLockMLock(Fnum2);


        end;
      end;
    end; {With..}
  end;


{$ENDIF}


  { ===== Procedure to Renumber Stock & Related Files ===== }

Procedure TNHistMove.Renumber_Account(OldCode,
                                      NewCode  :  Str20;
                                      CMode    :  Boolean);

Const
  HistLoopChr  :  Array[0..5] of Char = (CustHistGPCde,CustHistCde,CustHistPCde,CustkHistCode,CustkHistCode,CustkHistCode);

Var
  ncL,
  hLoop     :  Byte;
  Fnum,
  Keypath,
  B_Func,
  ThisStage
            :  Integer;

  NC2       :  Str20;

  KeyS,
  KeyChk    :  Str255;

  LOk,
  OkUpdateRec,
  Locked,
  Loop      :  Boolean;



  Procedure  UpdateChanges(StageNo  :  Integer);


  Begin
    With MTExLocal^ do
    Begin
      If (TranOk2Run) then
      Begin
        LStatus:=LCtrl_BTrans(1);

        TTEnabled:=LStatusOk;

        TRanOk2Run:=TTEnabled;

        {* Wait until All clear b4 continuing *}
        If (TTEnabled) then
          WaitForHistLock;

        UpdatePMS(StageNo,KeyS,'',BOff);
      end
      else
        TTEnabled:=BOff;

      LStatus:=LPut_Rec(Fnum,Keypath);

      LReport_BError(Fnum,LStatus);

      If (Not AbortTran) and (TTEnabled) then
        AbortTran:=(Not LStatusOk);


      If (TTEnabled) then
      Begin
        UnLockHistLock;


        LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

        LReport_BError(InvF,LStatus);

      end;

    end; {Wth..}

  end;

  { == Proc to re code account code details on lines and job actuals == }
  Procedure ReNumber_TransDetails;

  Const
    Fnum2     = IDetailF;
    Keypath2  = IdFolioK;
    Fnum3     = JDetlF;
    Keypath3  = JDLookK;

  Var
    KeyChk3,
    KeyS2,
    KeyChk2   :  Str255;


  Begin
    With MTExLocal^ do
    Begin
      KeyChk2:=FullNomKey(LInv.FolioNum);
      KeyS2:=KeyChk2;

      LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyS2);

      While (LStatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) and (Not AbortTran) do
      With LId do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        CustCode:=FullCustCode(NewCode);


        LStatus:=LPut_Rec(Fnum2,Keypath2);

        LReport_BError(Fnum2,LStatus);

        {Update Equivalent Job Actual}

        KeyChk3:=PArtCCKey(JBRCode,JBECode)+FullJDLookKey(FolioRef,ABSLineNo);

        LStatus:=LFind_Rec(B_GetEq,Fnum3,KeyPath3,KeyChk3);

        If (LStatusOk) then
        With LJobDetl^.JobActual do
        Begin
          ActCCode:=CustCode;

          LStatus:=LPut_Rec(Fnum3,Keypath3);

          LReport_BError(Fnum3,LStatus);
        end;


        LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeyS2);

      end; {While..}

    end; {With..}
  end; {Proc..}

  //SSK 15/02/2018 2018 R1 ABSEXCH-19745: this will update the Trader Code
  {Anon. Diary Update}
  Procedure Renumber_AnonDiary;
  var
    lAnonEntityType: TAnonymisationDiaryEntity;
  begin
    if IsACust(TradeCode[CMode]) then
      lAnonEntityType := adeCustomer
    else
      lAnonEntityType := adeSupplier;

    ReNameEntityCode(lAnonEntityType, OldCode, NewCode);
  end;


Begin

  B_Func:=B_GetNext;

  Loop:=BOff; LOk:=BOff; hLoop:=0;

  Fnum:=CustF;
  Keypath:=ATCodeK;

  Locked:=BOff; OkUpdateRec:=BOff;

  ThisStage:=1;

  With MTExLocal^ do
  Begin
    If (RightStage(ThisStage)) then
    Begin

      KeyChk:=TradeCode[CMode];


      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      Inc(ItemCount);

      UpdateProgress(ItemCount);


      ShowStatus(2,'Updating Account References.');

      {* Other References to Code within the other accounts *}

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LCust do
      Begin
        OkUpdateRec:=CheckKey(OldCode,RemitCode,Length(OldCode),BOff) or CheckKey(OldCode,SOPInvCode,Length(OldCode),BOff);

        If (OkUpdateRec) then
        Begin

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            If CheckKey(OldCode,RemitCode,Length(OldCode),BOff) then
              Remitcode:=NewCode;

            If CheckKey(OldCode,SOPInvCode,Length(OldCode),BOff) then
              SOPInvCode:=NewCode;

            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            If (LStatusOk) then
              B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;

    ThisStage:=2;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating transaction headers');

      Fnum:=InvF;
      Keypath:=InvCustK;

      Locked:=BOff;

      KeyChk:=FullCustCode(OldCode);

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All Transactions + Detail Lines *}


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LInv do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          ReNumber_TransDetails;

          CustCode:=FullCustCode(NewCode);

          UpdateChanges(ThisStage); {Envoke transaction based update}

          LStatus:=LUnLockMLock(Fnum);

          If (LStatusOk) then
            B_Func:=B_GetGEq
          else
            B_Func:=B_GetNext;

        end
        else
          B_Func:=B_GetNext;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;

    ThisStage:=3;

    If (RightStage(ThisStage)) and (Not CMode) then
    Begin

      ShowStatus(2,'Updating Stock Supplier References');

      Fnum:=StockF;
      Keypath:=StkCodeK;

      Locked:=BOff;

      {KeyChk:=FullStockCode(OldCode); Altered so it will repair lowercase stock codes}

      Blank(KeyChk,Sizeof(KeyChk));

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All Stock supplier references *}


      While (LStatusOk) and (Not AbortTran) do
      With LStock do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);


        OkUpdateRec:=CheckKey(OldCode,Supplier,Length(OldCode),BOff) or CheckKey(OldCode,SuppTemp,Length(OldCode),BOff);

        If (OkUpdateRec) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            If CheckKey(OldCode,Supplier,Length(OldCode),BOff) then
              Supplier:=FullCustCode(NewCode);

            If CheckKey(OldCode,SuppTemp,Length(OldCode),BOff) then
              SuppTemp:=FullCustCode(NewCode);

            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;

    {$IFDEF STK}

      Fnum:=MiscF;
      Keypath:=MIK;

      ThisStage:=4;

      Loop:=BOff;

      Repeat
        If (RightStage(ThisStage+Ord(Loop))) then
        Begin

          ShowStatus(2,'Updating discount matrices.');

          Locked:=BOff;

          If (Not Loop) then
            KeyChk:=FullQDKey(QBDiscCode,TradeCode[CMode],FullCustCode(OldCode))
          else
            KeyChk:=FullQDKey(CDDiscCode,TradeCode[CMode],FullCustCode(OldCode));

          If (Not ThisLastStage(ThisStage+Ord(Loop))) then
          Begin
            KeyS:=KeyChk;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
          end
          else
          Begin
            KeyS:=PMSCtrl^.MoveKey1;
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

            {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
          //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
          end;


          {* Account Discounts *}

          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
          With LMiscRecs^ do
          Begin
            Inc(ItemCount);

            UpdateProgress(ItemCount);

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              If (Not Loop) then
              With QtyDiscRec do
              Begin

                QCCode:=NewCode;

                DiscQtyCode:=MakeQDKey(FullCDKey(QCCode,QStkFolio),QBCurr,TQB);

              end
              else
              With CustDiscRec do
              Begin

                DCCode:=NewCode;

                DiscCode:=MakeCDKey(DCCode,QStkCode,QBCurr)+HelpKStop;

              end;

              UpdateChanges(ThisStage+Ord(Loop)); {Envoke transaction based update}

              LStatus:=LUnLockMLock(Fnum);

              If (LStatusOk) then
                B_Func:=B_GetGEq
              else
                B_Func:=B_GetNext;

            end
            else
              B_Func:=B_GetNext;

            LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

          end; {While..}

          If (TTEnabled) and (Not AbortTran) then
            UpdatePMS(ThisStage+Ord(Loop),KeyS,'',BOn);
        end; {If..}

        Loop:=Not Loop;

      Until (Not Loop);
    {$ENDIF}

    ThisStage:=6;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating Stock FIFO References');

      Fnum:=MiscF;
      Keypath:=MIK;

      Locked:=BOff;


      KeyChk:=MFIFOCode+MFIFOSub;

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All FIFO supplier references *}


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LMiscRecs^.FIFORec do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        OkUpdateRec:=CheckKey(OldCode,FIFOCust,Length(OldCode),BOff);

        If (OkUpdateRec) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            FIFOCust:=NewCode;

            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;


    ThisStage:=7;

    If (RightStage(ThisStage)) and (Not CMode) then
    Begin

      ShowStatus(2,'Updating Back to Back Defaults');

      Fnum:=MiscF;
      Keypath:=MIK;

      Locked:=BOff;


      KeyChk:=AllocTCode+AllocB2BICode;

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All B2B supplier references *}


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LMiscRecs^.B2BInpDefRec,B2BInpVal do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        OkUpdateRec:=CheckKey(OldCode,SuppCode,Length(OldCode),BOff);

        If (OkUpdateRec) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            SuppCode:=FullCustCode(NewCode);

            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;


    ThisStage:=8;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating Allocation Transactions');

      Fnum:=MiscF;
      Keypath:=MIK;

      Locked:=BOff;


      KeyChk:=PartCCKey(MBACSCode,MBACSALSub)+Tradecode[CMode]+FullCustCode(OldCode);

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All Offline allocations *}


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LMiscRecs^.AllocSRec do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        OkUpdateRec:=BOn;

        If (OkUpdateRec) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            ariCustCode:=FullCustCode(NewCode);

            nCL:=Length(ariKey);

            ariKey:=ariCustSupp+FullCustCode(ariCustCode)+Copy(ariKey,8,nCL-8);

            Spare2K:=ariCustSupp+FullCustCode(ariCustCode)+ariOurRef;


            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            If (LStatusOk) then
              B_Func:=B_GetGEq
            else
              B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;


    ThisStage:=9;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating BACS records');

      Fnum:=MiscF;
      Keypath:=MIK;

      Locked:=BOff;


      KeyChk:=MBACSCode+MBACSSub;

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All BACS account references *}


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LMiscRecs^.BACSSRec do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        OkUpdateRec:=CheckKey(OldCode,TagCustCode,Length(OldCode),BOff);

        If (OkUpdateRec) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            TagCustCode:=FullCustCode(NewCode);

            TagSuppK:=FullBACSKey(TagCustCode,TagRunNo);

            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;

  {$IFDEF SOP}

    ThisStage:=10;

    If (RightStage(ThisStage)) and (Not CMode) then
    Begin

      ShowStatus(2,'Updating Locaction Stock Supplier References');

      Fnum:=MLocF;
      Keypath:=MLK;

      Locked:=BOff;

      KeyChk:=CostCCode+CSubCode[BOff];

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All Loc Stock supplier references *}


      While (LStatusOk) and (Not AbortTran) do
      With LMLocCtrl^.MStkLoc do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);


        OkUpdateRec:=CheckKey(OldCode,lsSupplier,Length(OldCode),BOff) or CheckKey(OldCode,lsTempSupp,Length(OldCode),BOff);

        If (OkUpdateRec) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            If CheckKey(OldCode,lsSupplier,Length(OldCode),BOff) then
              lsSupplier:=FullCustCode(NewCode);

            If CheckKey(OldCode,lsTempSupp,Length(OldCode),BOff) then
              lsTempSupp:=FullCustCode(NewCode);


            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;

  {$ENDIF}

    ThisStage:=11;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating Alternative Stock References');

      Fnum:=MLocF;
      Keypath:=MLK;

      Locked:=BOff;

      KeyChk:=NoteTCode+NoteCCode;

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All Alt Stock db references *}


      While (LStatusOk) and (Not AbortTran) do
      With LMLocCtrl^.sdbStkRec do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);


        OkUpdateRec:=CheckKey(OldCode,sdSuppCode,Length(OldCode),BOff);

        If (OkUpdateRec) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            sdSuppCode:=FullCustCode(NewCode);


            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;



   {* Account analysis *}
    Fnum:=MLocF;
    Keypath:=MLSecK;


    Locked:=BOff;

    ThisStage:=12;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating Account Stock Analysis records.');

      KeyChk:=PartCCKey(MatchTCode,MatchSCode)+OldCode;

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LMLocCtrl^,cuStkRec do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          csCustCode:=FullCustCode(NewCode);

          csCode1:=Full_CuStkLKey(csCustCode,csLineNo);
          csCode2:=Full_CuStkKey(csCustCode,csStockCode);
          csCode3:=Full_CuStkKey2(csCustCode,csStockCode);

          UpdateChanges(ThisStage); {Envoke transaction based update}


          LStatus:=LUnLockMLock(Fnum);

          B_Func:=B_GetGEq;

        end
        else
          B_Func:=B_GetNext;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);
    end;


   {* TS Header *}
    Fnum:=MLocF;
    Keypath:=MLK;


    Locked:=BOff;

    ThisStage:=13;

    If (RightStage(ThisStage)) and (CMode) then
    Begin

      ShowStatus(2,'Updating TeleSales Control record.');

      KeyChk:=PartCCKey(MatchTCode,PostLCode)+OldCode;

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LMLocCtrl^,TeleSRec do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          tcCustcode:=FullCustCode(NewCode);

          tcCode1:=tcCustCode+tcLastOpo;

          UpdateChanges(ThisStage); {Envoke transaction based update}


          LStatus:=LUnLockMLock(Fnum);

          B_Func:=B_GetGEq;

        end
        else
          B_Func:=B_GetNext;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);
    end;

    ThisStage:=14;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating Enhanced User Profiles');

      Fnum:=MLocF;
      Keypath:=MLK;

      Locked:=BOff;

      KeyChk:=PassUCode+'D';


      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All Enhanced User Profiles Cust & Supp references *}


      While (LStatusOk) and (Not AbortTran) do
      With LMLocCtrl^.PassDefRec do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);


        OkUpdateRec:=CheckKey(OldCode,DirCust,Length(OldCode),BOff) or CheckKey(OldCode,DirSupp,Length(OldCode),BOff);

        If (OkUpdateRec) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            If CheckKey(OldCode,DirCust,Length(OldCode),BOff) then
              DirCust:=FullCustCode(NewCode);

            If CheckKey(OldCode,DirSupp,Length(OldCode),BOff) then
              DirSupp:=FullCustCode(NewCode);


            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;


    {* Allocation Header *}
    Fnum:=MLocF;
    Keypath:=MLK;


    Locked:=BOff;

    ThisStage:=15;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating Allocation Control record.');

      KeyChk:=PartCCKey(MBACSCode,MBACSCTL)+AllocCtrlKey1(CMode,OldCode);

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LMLocCtrl^.AllocCRec do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          arcCustCode:=FullCustCode(NewCode);

          arcCode1:=AllocCtrlKey1(CMode,NewCode);

          UpdateChanges(ThisStage); {Envoke transaction based update}


          LStatus:=LUnLockMLock(Fnum);

          B_Func:=B_GetGEq;

        end
        else
          B_Func:=B_GetNext;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);
    end;


    {* Notes *}
    Fnum:=PWrdF;
    Keypath:=PWK;


    Locked:=BOff;

    ThisStage:=16;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating Notes.');

      KeyChk:=PartNoteKey(NoteTCode,NoteCCode,OldCode);

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LPassWord.NotesRec do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          NoteFolio:=NewCode;

          NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo);

          UpdateChanges(ThisStage); {Envoke transaction based update}


          LStatus:=LUnLockMLock(Fnum);

          B_Func:=B_GetGEq;

        end
        else
          B_Func:=B_GetNext;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);
    end;


    {* Employee *}
    Fnum:=JMiscF;
    Keypath:=JMTrdK;


    Locked:=BOff;

    ThisStage:=17;

    If (RightStage(ThisStage)) and (Not CMode) then
    Begin

      ShowStatus(2,'Updating Employee.');

      KeyChk:=PartCCKey(JARCode,JASubAry[3])+FullCustCode(OldCode);

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LJobMisc^.EmplRec do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          Supplier:=FullCustCode(NewCode);

          UpdateChanges(ThisStage); {Envoke transaction based update}


          LStatus:=LUnLockMLock(Fnum);

          B_Func:=B_GetGEq;

        end
        else
          B_Func:=B_GetNext;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);
    end;

    {* Main Job Rec *}
    Fnum:=JobF;
    Keypath:=JobCustK;


    Locked:=BOff;

    ThisStage:=18;

    If (RightStage(ThisStage)) and (CMode) then
    Begin

      ShowStatus(2,'Updating Job Records.');

      KeyChk:=FullCustCode(OldCode);

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LJobRec^ do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          CustCode:=FullCustCode(NewCode);

          UpdateChanges(ThisStage); {Envoke transaction based update}


          LStatus:=LUnLockMLock(Fnum);

          B_Func:=B_GetGEq;

        end
        else
          B_Func:=B_GetNext;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);
    end;


    ThisStage:=19;

    If (RightStage(ThisStage)) and (CMode) then
    Begin

      ShowStatus(2,'Updating Job Retentions');

      Fnum:=JDetlF;
      Keypath:=JDLedgerK;

      Locked:=BOff;

      KeyChk:=JARCode+JBPCode;

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;

      {* All Job Retentions *}


      While (LStatusOk) and (Not AbortTran) do
      With LJobDetl^.JobReten do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);


        OkUpdateRec:=CheckKey(OldCode,RetCustCode,Length(OldCode),BOff);

        If (OkUpdateRec) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            RetCustCode:=FullCustCode(NewCode);

            UpdateChanges(ThisStage); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;
        end
        else
          B_Func:=B_GetNext;


        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);

    end;


    {* Job CIS Vouchers *}
    Fnum:=JDetlF;
    Keypath:=JDLookK;


    Locked:=BOff;

    ThisStage:=20;

    If (RightStage(ThisStage)) and (Not CMode) then
    Begin

      ShowStatus(2,'Updating Job CIS/RCT Vouchers.');

      KeyChk:=JATCode+JBSCode+FullCustCode(OldCode);

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LJobDetl^.JobCISV do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          nCL:=Length(CISVSDate);

          CISVDateS:=Copy(CISVDateS,1,8)+FullCustCode(NewCode)+ECISType2Key(CISCType);
          CISVSDate:=FullCustCode(NewCode)+Copy(CISVSDate,7,nCL-6);

          UpdateChanges(ThisStage); {Envoke transaction based update}


          LStatus:=LUnLockMLock(Fnum);

          B_Func:=B_GetGEq;

        end
        else
          B_Func:=B_GetNext;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);
    end;



    {* Links  *}
    Fnum:=MiscF;
    Keypath:=MLK;


    Locked:=BOff;

    ThisStage:=21;

    If (RightStage(ThisStage)) then
    Begin

      ShowStatus(2,'Updating Links.');

      KeyChk:=LetterTcode+TradeCode[CMode]+OldCode;

      If (Not ThisLastStage(ThisStage)) then
      Begin
        KeyS:=KeyChk;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      end
      else
      Begin
        KeyS:=PMSCtrl^.MoveKey1;
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      end;


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LMiscRecs^.btLetterRec do
      Begin
        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          AccCode:=NewCode;

          CustomKey := FullCustCode(AccCode) + LDateKey (LtrDate) + TimeKey (LtrTime);

          UpdateChanges(ThisStage); {Envoke transaction based update}


          LStatus:=LUnLockMLock(Fnum);

          B_Func:=B_GetGEq;

        end
        else
          B_Func:=B_GetNext;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (TTEnabled) and (Not AbortTran) then
        UpdatePMS(ThisStage,KeyS,'',BOn);
    end;

    Fnum:=NHistF;
    Keypath:=NHK;

    ThisStage:=22; {*Note, this stage ends on 27 owing to the loop. End Stage currently set to 28}

    Loop:=BOff;

    Repeat
      If (RightStage(ThisStage+hLoop)) then
      Begin

        ShowStatus(2,'Updating all History records.');

        Locked:=BOff;

        Case hLoop of
          4,5  :  KeyChk:=HistLoopChr[hLoop]+Chr(HLoop-3)+FullCustCode(OldCode);
          else    KeyChk:=HistLoopChr[hLoop]+FullCustCode(OldCode);
        end; {Case..}


        If (Not ThisLastStage(ThisStage+Ord(Loop))) then
        Begin
          KeyS:=KeyChk;
          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
        end
        else
        Begin
          KeyS:=PMSCtrl^.MoveKey1;
          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

          {* Should not need as progressive search via key, otherwise very next valid record will get missed *}
        //LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
        end;


        {* Account Discounts *}

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
        With LNHist do
        Begin
          Inc(ItemCount);

          UpdateProgress(ItemCount);

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            Blank(NC2,Sizeof(NC2));

            If (hLoop>3) then
              NC2:=Code[1];

            NCl:=Ord(hLoop>3);

            NC2:=NC2+FullCustCode(NewCode)+Copy(Code,7+NCL,NHCodeLen-(6+NCL));

            Code:=NC2;

            UpdateChanges(ThisStage+hLoop); {Envoke transaction based update}

            LStatus:=LUnLockMLock(Fnum);

            If (LStatusOk) then
              B_Func:=B_GetGEq
            else
              B_Func:=B_GetNext;

          end
          else
            B_Func:=B_GetNext;

          LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

        end; {While..}

        If (TTEnabled) and (Not AbortTran) then
          UpdatePMS(ThisStage+hLoop,KeyS,'',BOn);
      end; {If..}

      Inc(hLoop)

    Until (hLoop>High(HistLoopChr));

    { Anon. Diary Update}  //SSK 15/02/2018 2018-R1 ABSEXCH-19745:
    if GDPROn then
      Renumber_AnonDiary;

    Locked:=BOff;

    If (GetMultiSys(BOn,Locked,SYSR)) then
    Begin
      With Syss do
      Begin
        If CheckKey(OldCode,DirectCust,Length(OldCode),BOff) and (CMode) then
          DirectCust:=FullCustCode(NewCode);

        If CheckKey(OldCode,DirectSupp,Length(OldCode),BOff) and (Not CMode) then
          DirectSupp:=FullCustCode(NewCode);

      end; {With..}

      PutMultiSys(SysR,BOn);
    end;



  end; {With..}

end; {Proc..}

Procedure TNHistMove.CtrlRen_Acc(OldCode,
                                 NewCode  :  Str20;
                                 RecMode  :  Boolean);

Var
  KeyS  :  Str255;

  LOk,Locked
        :  Boolean;

  Fnum2,
  Keypath2
        :  SmallInt;

  EndStage
        :  Integer;

Begin
  With MTExLocal^ do
  Begin
    Fnum2:=CustF; Keypath2:=CustCodeK;

    ItemTotal:=Used_RecsCId(LocalF^[IdetailF],IDetailF,ExCLientId)+Used_RecsCId(LocalF^[StockF],StockF,ExCLientId)+
               Used_RecsCId(LocalF^[InvF],InvF,ExCLientId)+Used_RecsCId(LocalF^[MiscF],MiscF,ExCLientId)+
               Used_RecsCId(LocalF^[MLocF],MLocF,ExCLientId)+Used_RecsCId(LocalF^[CustF],CustF,ExCLientId)+
               Used_RecsCId(LocalF^[NHistF],NHistF,ExCLientId);

    InitProgress(ItemTotal);

    Renumber_Account(OldCode,NewCode,RecMode);

    EndStage:=28;

    If (RightStage(EndStage)) then {* Check incase Change account code has failed... Keep this last stage number how to allow for additions*}
    Begin
      KeyS:=FullCustCode(OldCode);

      LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);


      If (LOk) and (Locked) then
      Begin
        LGetRecAddr(Fnum2);

        LCust.CustCode:=FullCustCode(NewCode);

        If (TranOk2Run) then
        Begin
          LStatus:=LCtrl_BTrans(1);

          TTEnabled:=LStatusOk;

          TRanOk2Run:=TTEnabled;

          {* Wait until All clear b4 continuing *}
          If (TTEnabled) then
            WaitForHistLock;

          UpdatePMS(EndStage,KeyS,'',BOff);
        end
        else
          TTEnabled:=BOff;

        LStatus:=LPut_Rec(Fnum2,Keypath2);

        LReport_BError(Fnum2,LStatus);

        If (Not AbortTran) and (TTEnabled) then
          AbortTran:=(Not LStatusOk);

        If (TTEnabled) then
        Begin
          UnLockHistLock;

          UpdatePMS(EndStage,KeyS,'',BOn);

          LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

          LReport_BError(InvF,LStatus);

        end;


        LStatus:=LUnLockMLock(Fnum2);


      end;
    end;
  end; {With..}
end;




{$IFDEF JC}
  { ========= Suporting routines for moving jobs around the tree ======== }

Procedure TNHistMove.Move_Post(HType  :  Char;
                               HKey   :  Str255;
                               Purch,
                               Sales,
                               Cleared:  Double;
                               HCurr,
                               HYr,
                               HPr    :  Byte;
                               MRates :  CurrTypes);


Var

  TreeLoop,
  FoundOk    :  Boolean;

  n,LZCurr,
  CnvCr      :  Byte;

  Rate,
  PrevBal    :  Double;


Begin
  TreeLoop:=BOff;

  LZCurr:=HCurr;
  Rate:=1; CnvCr:=0;

  With MTExLocal^ do
  Begin

    LPost_To_Hist(HType,HKey,
                 Conv_TCurr(Sales,Rate,CnvCr,0,BOff),
                 Conv_TCurr(Purch,Rate,CnvCr,0,BOff),
                 Cleared,LZCurr,HYr,HPr,PrevBal);

    LPost_To_CYTDHist(HType,HKey,
                     Conv_TCurr(Sales,Rate,CnvCr,0,BOff),
                     Conv_TCurr(Purch,Rate,CnvCr,0,BOff),
                     Cleared,LZCurr,HYr,YTD);

 end;

  {TreeLoop:=Not TreeLoop; Level 0 not required...

  LZCurr:=0;  CnvCr:=HCurr;


  Rate:=XRate(MRates,BOff,HCurr);}




end;



Procedure TNHistMove.Move_PostCtrl(JCode  :  Str10;
                                   HKey   :  Str255;
                                   Purch,
                                   Sales,
                                   Cleared:  Double;
                                   HCurr,
                                   HYr,
                                   HPr    :  Byte;
                                   MRates :  CurrTypes;
                                   PCommit:  Boolean;
                                   Level  :  LongInt);


Var

  KeyS    :  Str255;
  HPCode  :  Char;
  JCLen   :  Byte;



Begin
  KeyS:='';

  With MTExLocal^ do
  Begin

    If (LGetMainRecPos(JobF,JCode)) then
    Begin
      If (PCommit) then
        HPCode:=CommitHCode
      else
        HPCode:=LJobRec^.JobType;


      Move_Post(HPCode,HKey,Purch,Sales,Cleared,HCurr,HYr,HPr,MRates);

      With LJobRec^ do
      If (Not EmptyKey(JobCat,JobKeyLen)) and (JobCat<>JobCode) then {* Post to parent level, if not blank, and not same as itself *}
      Begin
        JCLen:=JobKeyLen;

        KeyS:=FullJobCode(JobCat)+Copy(HKey,Succ(JCLen),Length(HKey)-JCLen);

        Move_PostCtrl(JobCat,KeyS,Purch,Sales,Cleared,HCurr,HYr,HPr,MRates,PCommit,Succ(Level));
      end;

    end;
  end; {With..}
end;


  { =========== Procedure to Replicate Job Actual Budget records as part of Move Job Code ========= }


    { ======== Make JobBudg record ====== }

  Function TNHistMove.Make_MoveAnalBudg(JCtrl  :  JobCtrlRec;
                                        JCode  :  Str10;
                                        Fnum,
                                        Keypath:  Integer)  :  Boolean;


  Var
    KeyS         :  Str255;
    LCheck_Batch :  ^TPostJob;


  Begin
    Result:=BOff;

    If (JCtrl.SubType<>JBSCode) then {* Don't auto manufacture stock/pay rate records up the tree *}
    With MTExLocal^, LJobCtrl^,JobBudg do
    Begin

      LJobCtrl^:=JCtrl;

      JobCode:=JCode;

      New(LCheck_Batch,Create(Self.fMyOwner));

      try
        With LCheck_Batch^ do
        Begin
          If (Assigned(LCheck_Batch)) then
          Begin
            LCheck_Batch^.MTExLocal:=Self.MTExLocal;

            HistFolio:=LGet_NextJAFolio(JobCode,BOn);

            Finish;
          end;
        end;
      finally
        Dispose(LCheck_Batch,Destroy);
      end; {try..}

      
      BudgetCode:=FullJBCode(JobCode,CurrBudg,AnalCode);

      Code2NDX:=FullJBDDKey(JobCode,AnalHed); {* To enable Drill down to analysis level *}

      LStatus:=LAdd_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);

      Result:=LStatusOk;
    end; {With..}

  end;


  Function TNHistMove.Match_BudgetFolio(BudHistFolio  :  LongInt;
                                        JC,
                                        NewCat        :  Str10;
                                    Var FAnalCode     :  Str20;
                                    Var SPayFlg       :  Boolean;
                                    Var OrigBR        :  JobCtrlRec;
                                    Var KeySearch     :  Str255)  :  Boolean;



  Const
    Fnum    = JCtrlF;
    Keypath = JCK;

  Var
    KeyChk,
    KeyS     :  Str255;


    Loop     :  Boolean;




  Begin
    With MTExLocal^ do
    Begin
      Result:=BOff;

      Loop:=BOff; KeyS:=''; FillChar(OrigBR,Sizeof(OrigBR),#0);

      If (FAnalCode<>'') then {* Attempt to find prev record quickly *}
      Begin
        If (Not SPayFlg) then
          KeyChk:=PartCCKey(JBRCode,JBBCode)+FullJDAnalKey(JC,FAnalCode)
        else
          KeyChk:=PartCCKey(JBRCode,JBSCode)+FullJDStkKey(JC,fAnalCode);

        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        Result:=(LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (LJobCtrl^.JobBudg.HistFolio=BudHistFolio);

        If (Result) then
        With LJobCtrl^,JobBudg do
        Begin
          OrigBR:=LJobCtrl^;

          If (Not SPayFlg) then
            KeySearch:=PartCCKey(RecPFix,SubType)+FullJDAnalKey(NewCat,AnalCode)
          else
            KeySearch:=PartCCKey(RecPFix,SubType)+FullJDStkKey(NewCat,StockCode);
        end;
      end; {If we have this result already}

      If (Not Result) then
      Repeat
        If (Not Loop) then
          KeyS:=PartCCKey(JBRCode,JBBCode)+FullJobCode(JC)
        else
          KeyS:=PartCCKey(JBRCode,JBSCode)+FullJobCode(JC);

        KeyChk:=KeyS;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (not AbortTran) and (Not Result) do
        With LJobCtrl^,JobBudg do
        Begin

           Result:=(HistFolio=BudHistFolio);

           If (Result) then
           Begin
             OrigBR:=LJobCtrl^;

             If (Not Loop) then
             Begin
               KeySearch:=PartCCKey(RecPFix,SubType)+FullJDAnalKey(NewCat,AnalCode);
               FAnalCode:=AnalCode;
             end
             else
             Begin
               KeySearch:=PartCCKey(RecPFix,SubType)+FullJDStkKey(NewCat,StockCode);
               FAnalCode:=StockCode;
             end;

             SPayFlg:=Loop;
           end {If Pos got ok..}
           else
             LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        end; {While..}

        Loop:=Not Loop;

      Until (Not Loop) or (Result) or (AbortTran);
    end; {With..}

  end; {Proc..}


  Procedure TNHistMove.Move_PostAnalCtrl(BudHistFolio
                                                    :  LongInt;
                                         OrigJC,
                                         NewCat,
                                         FAnalCode  :  Str20;
                                         Purch,
                                         Sales,
                                         Cleared:  Double;
                                         HCurr,
                                         HYr,
                                         HPr    :  Byte;
                                         MRates :  CurrTypes;
                                         PCommit,
                                         SPayFlg,
                                         Loop   :  Boolean);



  Const
    Fnum    = JCtrlF;
    Keypath = JCK;

  Var

    HPCode        :  Char;

    HKey,
    KeyChk,
    KeyS          :  Str255;

    OrigBR        :  JobCtrlRec;



  Begin
    FillChar(OrigBR,Sizeof(OrigBR),#0);

    With MTExLocal^ do
    Begin
      {$B-}
        If (Not EmptyKey(NewCat,JobCodeLen)) and (LGetMainRecPos(JobF,NewCat)) and (Match_BudgetFolio(BudHistFolio,OrigJC,NewCat,FAnalCode,SPayFlg,OrigBR,KeyChk)) then
        Begin
          KeyS:=KeyChk;

          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

          If ((LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))) or ((Loop) and (Make_MoveAnalBudg(OrigBR,NewCat,Fnum,Keypath))) then
          Begin
            If (PCommit) then
             HPCode:=CommitHCode
           else
             HPCode:=LJobRec^.JobType;

           HKey:=FullJDHistKey(NewCat,LJobCtrl^.JobBudg.HistFolio);

           Move_Post(HPCode,HKey,Purch,Sales,Cleared,HCurr,HYr,HPr,MRates);

           If (Not EmptyKey(LJobRec^.JobCat,JobCodeLen)) then
             Move_PostAnalCtrl(BudHistFolio,OrigJC,LJobRec^.JobCat,FAnalCode,Purch,Sales,Cleared,HCurr,HYr,HPr,MRates,PCommit,SPayFlg,Loop);

          end;
        end;
      {$B+}
    end; {With..}

  end; {Proc..}


{
  Moves the Job specified by MoveCode from its current location to the parent
  Job/Contract indicated by NewCat
}
Procedure TNHistMove.Job_Move(MoveCode,
                              NewCat     :  Str20;
                              Fnum,
                              Keypath    :  Integer);
Const
  Fnum2      =  JobF;
  Keypath2   =  JobCodeK;
Var
  MoveJob  :  JobRecType;
  BudHistFolio,
  RecAddr  :  LongInt;
  ThisStage:  Byte;
  RawHCode,
  KeyChk,
  HPCode,
  KeyS     :  Str255;
  FAnalCode:  Str20;
  SPayFlg,
  ComMode,
  Loop     :  Boolean;
  DCnst    :  Integer;
  JCLen    :  Byte;
  MRates   :  CurrTypes;
  LOk,
  Locked   :  Boolean;

  { ======= Function to check histfolio inside category range ======= }
  Function IsCatHistFolio(HF: LongInt): Boolean;
  Var
    n  :  Byte;
  Begin
    Result:=BOff;
    For n:=0 to NofSysAnals do
    Begin
      Result := (HF = HFolio_Txlate(n));

      If (Result) then
        Break;
    end;
  end;

Begin
  With MTExLocal^ do
  Begin
    MRates[BOff] := 1;
    MRates[BOn]  := 1;
    Locked       := BOff;
    HPCode       := '';
    JCLen        := 0;
    BudHistFolio := 0;
    SPayFlg      := BOff;
    FAnalCode    := '';

    // Locate the Job Record
    KeyS    := FullJobCode(MoveCode);
    LStatus := LFind_Rec(B_GetEq, Fnum2, KeyPath2, KeyS);
    If (LStatusOk) then
    With MoveJob do
    Begin
      MoveJob := LJobRec^;

      Loop := BOff;
      Repeat
        If (Not EmptyKey(MoveJob.JobCat, JobCodeLen)) then {* Do not process if on level 0 *}
        Begin
          { CJS 2014-04-11 - ABSEXCH-13784 - Job Move actual and budget figures }
          // On the first loop (Loop = False) we subtract the figures from the
          // Job/Contract that the Job is being moved from, and on the second
          // loop (Loop = True) we add the figures to the Job/Contract that it is
          // being moved to.
          If (Not Loop) then
            DCnst := -1
          else
            DCnst := 1;

          ComMode := BOff;

          Repeat
            ThisStage:=(1*Ord(Not Loop and Not ComMode)) + (2*Ord(Not Loop and ComMode)) +
                       (4*Ord(Loop and Not ComMode))     + (5*Ord(Loop and ComMode));

            If (RightStage(ThisStage)) then
            Begin

              If (ComMode) then
                // Find the summary Job Costing History records
                KeyChk := CommitHCode + FullJobCode(JobCode)
              else
                // Find the full Job Costing History records
                KeyChk := JobType + FullJobCode(JobCode);

              If (Not ThisLastStage(ThisStage)) then
              Begin
                KeyS:=KeyChk;
                LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
              end
              else
              Begin
                KeyS:=PMSCtrl^.MoveKey1;
                LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
                LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
              end;

              While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (not AbortTran) do
              With LNHist do
              Begin
                Inc(ItemCount);

                UpdateProgress(ItemCount);

                If (Not (Pr In [YTD,YTDNCF])) then
                Begin

                  LStatus := LGetPos(Fnum,RecAddr);  {* Preserve Posn of History Line *}

                  If (LStatusOk) then
                  Begin
                    If (TranOk2Run) then
                    Begin
                      LStatus := LCtrl_BTrans(1);

                      TTEnabled:=LStatusOk;

                      TRanOk2Run:=TTEnabled;

                      {* Wait until All clear b4 continuing *}
                      If (TTEnabled) then
                        WaitForHistLock;

                      UpdatePMS(ThisStage,KeyS,'',BOff);
                    end
                    else
                      TTEnabled:=BOff;

                    JCLen:=JobCodeLen;

                    HPCode:=FullJobCode(JobCat)+Copy(Code,Succ(JCLen),Length(Code)-JCLen);

                    RawHCode:=Copy(Code,Succ(JCLen),Length(Code)-JCLen);

                    Move(RawHCode[1],BudHistFolio,Sizeof(BudHistFolio));

                    If (BudHistFolio<>0) then
                    Begin

                      If (IsCatHistFolio(BudHistFolio)) then {* Allow history posting all the way through the tree as they
                                                                all share the same folio for Catagories *}
                        { CJS 2014-04-11 - ABSEXCH-13784 - Job Move actual and budget figures }
                        Move_PostCtrl(MoveJob.JobCat,HPCode,
                                      (Sales*DCnst),
                                      (Purchases*DCnst),
                                      (Cleared*DCnst),
                                      Cr,Yr,Pr,
                                      MRates,ComMode,0)
                      else
                        { CJS 2014-04-11 - ABSEXCH-13784 - Job Move actual and budget figures }
                        Move_PostAnalCtrl(BudHistFolio,
                                          MoveJob.JobCode,
                                          MoveJob.JobCat,
                                          FAnalCode,
                                          (Sales*DCnst),
                                          (Purchases*DCnst),
                                          (Cleared*DCnst),
                                          Cr,Yr,Pr,
                                          MRates,ComMode,
                                          SPayFlg,
                                          Loop);
                    end;

                    If (TTEnabled) then
                    Begin
                      UnLockHistLock;

                      LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                      LReport_BError(InvF,LStatus);

                    end;


                    LSetDataRecOfs(Fnum,RecAddr);  {* Re-establish position *}

                    LStatus:=LGetDirect(Fnum,Keypath,0);

                  end; {If Pos got ok..}
                end; {If YTD..}

                LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

              end; {While..}

              If (TTEnabled) and (Not AbortTran) then {* Only update cpmpleted stage here *}
                UpdatePMS(ThisStage,KeyS,'',BOn);

            end; {If RightStage..}

            ComMode:=Not ComMode;

          Until (Not ComMode);


        end; {If Group is level 0}

        ThisStage:=3;

        If (RightStage(ThisStage)) and (Not Loop) then
        Begin

          KeyS:=FullJobCode(MoveCode);

          LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum2);


            LJobRec^.JobCat:=NewCat;

            If (TranOk2Run) then
            Begin
              LStatus:=LCtrl_BTrans(1);

              TTEnabled:=LStatusOk;

              TRanOk2Run:=TTEnabled;

              {* Wait until All clear b4 continuing *}
              If (TTEnabled) then
                WaitForHistLock;

              UpdatePMS(3,KeyS,'',BOff);
            end
            else
              TTEnabled:=BOff;


            LStatus:=LPut_Rec(Fnum2,Keypath2);

            LReport_BError(Fnum2,LStatus);


            If (Not AbortTran) and (TTEnabled) then
              AbortTran:=(Not LStatusOk);

            If (TTEnabled) then
            Begin
              UnLockHistLock;

              UpdatePMS(3,KeyS,'',BOn);

              LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

              LReport_BError(InvF,LStatus);

            end;


            LStatus:=LUnLockMLock(Fnum2);

            MoveJob:=LJobRec^;


          end;
        end; {* If in second part of loop *}

        Loop := Not Loop;

      Until (Not Loop);


    end; {If Can't find nominal}
  end; {With..}

end; {Proc..}



{$ENDIF}


Function TNHistMove.FindPMS  :  Boolean;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  KeyS  :  Str255;
  NewRec:  Boolean;


Begin
  KeyS:=FullPLockKey(PostUCode,PostMCode,1);

  Result:=BOff;

  With MTExLocal^,LPassWord,MoveCtrlRec, MoveRepCtrl^ do
  Begin

    LStatus:=LFind_Rec(B_GetEq+B_MultNWLock,Fnum,KeyPath,KeyS);

    Result:=LStatusOk;

    If (Result) then
    Begin
      PMSCtrl^:=MoveCtrlRec;

      LStatus:=LGetPos(Fnum,PMSLAddr);
    end;

  end;


end; {Func..}


Function TNHistMove.Check4AbortPMS  :  Boolean;

Begin
  If (FindPMS) then
    MAutoRecover:=((PMSCtrl^.MoveStage>0) and Syss.ProtectPost);

  If (MAutoRecover) then
  With MoveRepCtrl^, PMSCtrl^ do
  Begin
    MoveMode:=WasMode;

    MoveNCode:=OldNCode;
    NewNCat:=NewNCode;
    NewNType:=NTypNew;

    NewSCode:=SCodeNew;
    MoveSCode:=SCodeOld;
    NewSGrp:=SGrpNew;
    LastStage:=MoveStage;
    ItemCount:=ProgCounter;

    CustMode:=MIsCust;

    With MTExLocal^ do
    If (WasMode=4) then {v5.51 We rely on the MoveStk record for the bom uupdate so we need to re-establish it during a recover}
    Begin
      If LGetMainRecPos(StockF,SCodeOld) then
        MoveStk:=LStock;
    end
    else
      If (WasMode=40) then
      Begin
        If LGetMainRecPos(CustF,SCodeOld) then
          MoveCust:=LCust;

      end;
  end;

  Result:=MAutoRecover;
end;

Function TNHistMove.StartNewPMS  :  Boolean;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;


Var
  NewRec:  Boolean;
  ThisAddr
        :  LongInt;
  TmpMisc
        :  PassWordRec;

Begin
  Result:=Not TranOk2Run;

  If (Not Result) then
  With MTExLocal^,LPassWord,MoveCtrlRec, MoveRepCtrl^ do
  Begin

    NewRec:=Not FindPMS;

    If (NewRec) then
    Begin
      LResetRec(Fnum);
      RecPFix:=PostUCode;
      SubType:=PostMCode;
      MLocC:=PartPLockKey(1);
    end
    else
      LStatus:=LGetPos(Fnum,ThisAddr);


    WasMode:=MoveMode;

    OldNCode:=MoveNCode;
    NewNCode:=NewNCat;
    NTypOld:=LNom.NomType;
    NTypNew:=NewNType;

    SCodeNew:=NewSCode;
    SCodeOld:=MoveSCode;
    SGrpNew:=NewSGrp;
    SUser:=EntryRec^.Login;
    FinStage:=BOn;

    MIsCust:=CustMode;

    If (MoveMode In [51..54]) and (Not MAutoRecover) then
      MListRecAddr:=PMListAddr;

    If (NewRec) then
    Begin
      LStatus:=LAdd_Rec(Fnum,Keypath);

      FindPMS;
    end
    else
    Begin
      TmpMisc:=LPassWord;

      LSetDataRecOfS(Fnum,ThisAddr);

      LStatus:=LGetDirect(Fnum,Keypath,0); {* Re-Establish Position *}

      LPassWord:=TmpMisc;

      LStatus:=LPut_Rec(Fnum,Keypath);
    end;

    LReport_BError(Fnum,LStatus);

    Result:=LStatusOk;

    PMSCtrl^:=MoveCtrlRec;

  end;
end;


Function TNHistMove.UpdatePMS(Stage  :  Byte;
                              MKey1,
                              MKey2  :  Str255;
                              FS     :  Boolean)  :    Boolean;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;


Var
  TmpKPath,
  TmpStat
        :   Integer;

  TmpRecAddr
        :  LongInt;

  ThisAddr
        :  LongInt;
  LastPW,
  TmpMisc
        :  PassWordRec;



Begin
  Result:=BOff;

  With MTExLocal^,LPassWord,MoveCtrlRec, MoveRepCtrl^ do
  Begin
    LastPW:=LPassWord;
    TmpKPath:=GetPosKey;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);


    If (FindPMS) and (TranOk2Run) then
    Begin
      LStatus:=LGetPos(Fnum,ThisAddr);

      MoveStage:=Stage;
      MoveKey1:=MKey1;
      MoveKey2:=MKey2;
      FinStage:=FS;
      ProgCounter:=ItemCount;

      If (MoveMode In [51..54]) and (Not MAutoRecover) then
        MListRecAddr:=PMListAddr;


      TmpMisc:=LPassWord;

      LSetDataRecOfS(Fnum,ThisAddr);

      LStatus:=LGetDirect(Fnum,Keypath,0); {* Re-Establish Position *}

      LPassWord:=TmpMisc;

      LStatus:=LPut_Rec(Fnum,Keypath);

      LReport_BError(Fnum,LStatus);

      Result:=LStatusOk;

      PMSCtrl^:=MoveCtrlRec;
    end;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
    LPassWord:=LastPW;

  end;
end;


Function TNHistMove.FinishPMS  :  Boolean;


Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;



Begin
  Result:=BOff;

  With MTExLocal^,LPassWord,MoveCtrlRec do
  Begin

    If (FindPMS) then
    Begin
      If (Not AbortTran) then
      Begin
        MoveStage:=0;
        FinStage:=BOn;
        MoveKey1:='';
        MoveKey2:='';

        MListRecAddr:=0;

        LStatus:=LPut_Rec(Fnum,Keypath);

        LReport_BError(Fnum,LStatus);

        Result:=LStatusOk;
      end;
      
      LStatus:=UnLockMLock(Fnum,PMSLAddr);

    end;
  end;
end;


Function TNHistMove.RightStage(Stage  :  Byte)  :  Boolean;
Begin
  With PMSCtrl^ do
  Begin
    Result:=((((MoveStage<Stage) and (FinStage)) or ((MoveStage=Stage) and (Not FinStage))) or (Not TranOk2Run)) and (Not AbortTran);
  end;
end;

Function TNHistMove.ChkTypeStages(NS  :  CurrChangeSet)  :  Boolean;

Var
  n  :  Byte;

Begin
  Result:=BOff;

  For n:=1 to 13 do
  If (n In NS) then
  Begin
    Result:=RightStage(n);

    If (Result) then
      Break;
  end;


end;

Function TNHistMove.ThisLastStage(Stage  :  Byte)  :  Boolean;
Begin
  With PMSCtrl^ do
  Begin
    Result:=(LastStage=Stage) and (Not FinStage) and (TranOk2Run) and (MAutoRecover);
  end;
end;


Function TNHistMove.MoveTitle  :  Str255;

Begin

  With MoveRepCtrl^ do
    Result:=GlobMoveTitle(MoveMode);

end;


Function TNHistMove.ThreadTitle  :  Str255;

Var
  TmpCtrl  :  MoveCtrlType;

Begin
  Blank(TmpCtrl,Sizeof(TmpCtrl));

  With TmpCtrl, MoveRepCtrl^ do
  Begin
    WasMode:=MoveMode;
    OldNCode:=MoveNCode;
    SCodeOld:=MoveSCode;
  end;

  Result:=GlobThreadTitle(TmpCtrl);
end;


Procedure TNHistMove.Process;

Var
  TTMsg      :  Str20;

  ForceFinish,
  Ok2Cont    :  Boolean;

Begin
  InMainThread:=BOn;  Ok2Cont:=BOff;

  TTEnabled:=BOff;  TTMsg:=''; ForceFinish:=BOff;

  Inherited Process;

  If (fWhoAmI In [0]) then
  Begin
    ShowStatus(0,MoveTitle);

    SendRecCtrl^:=MoveRepCtrl^;

    If (MyOHandle>0) then {* Added to Q ok *}
      SendMessage(MyOHandle, WM_FormCloseMsg, WP_START_TREE_MOVE + Ord(MAutoRecover), LongInt(@SendRecCtrl^));

    If (Not MAutoRecover) and (Not (MoveRepCtrl^.MoveMode In [50..54])) then
    Begin
      If (Not Check4AbortPMS) then {* Check for a previous abortion *}
        Ok2Cont:=StartNewPMS;
    end
    else
      Ok2Cont:=BOn;

    If Ok2Cont then
    With MTExLocal^ do
    Begin
      ItemTotal:=Used_RecsCId(LocalF^[NHistF],NHistF,ExCLientId);

      InitProgress(ItemTotal);

      // CJS: 07/04/2011 ABSEXCH-10439
      ItemCount := 0;

      If (TranOk2Run) then
      Begin
        TTMsg:='. Protected Mode.';
      end
      else
        TTEnabled:=BOff;


      With MoveRepCtrl^ do
      Case MoveMode of
        1,2
           :  Begin
                ShowStatus(1,MoveTitle+' '+Form_Int(MoveNCode,0)+TTMsg);

                Nom_Move(MoveNCode,NewNCat,NewNType,NHistF,NHK);

              end;

      {$IFDEF STK}
        3  :  Begin
                ShowStatus(1,'Moving Stock Code '+MoveSCode+TTMsg);

                Stk_Move(MoveSCode,NewSGrp,NewSCode,BOff,NHistF,NHK);
              end;

        4,54
           :  Begin
                ShowStatus(1,'Changing Stock Code '+Trim(MoveSCode)+TTMsg);

                CtrlRen_Stk(MoveSCode,NewSCode);

                ForceFinish:=(MoveMode=54);

              end;

      {$ENDIF}

      {$IFDEF JC}
        30  :  Begin
                ShowStatus(1,'Moving Job Code '+MoveSCode+TTMsg);

                Job_Move(MoveSCode,NewSGrp,NHistF,NHK);
              end;
      {$ENDIF}

      40 :  Begin
              ShowStatus(1,'Changing Account Code '+Trim(MoveSCode)+TTMsg);

              CtrlRen_Acc(MoveSCode,NewSCode,CustMode);
            end;

        50  :  Begin

                 NomView_Move(MoveRepCtrl^.MoveNomView,NewNCat,NHistF,NHK);
               end;

        51
            :  Begin
                 ShowStatus(1,' Processing G/L Move List '+TTMsg);

                 ForceFinish:=Check4AbortPMS;

                 If (ForceFinish) then {* Recover previous run *}
                   Nom_Move(MoveNCode,NewNCat,NewNType,NHistF,NHK)
                 else
                   Process_MoveList;
               end;
      {$IFDEF STK}
        52
            :  Begin
                 ShowStatus(1,' Processing Stock Move List '+TTMsg);

                 ForceFinish:=Check4AbortPMS;

                 If (ForceFinish) then {* Recover previous run *}
                   Stk_Move(MoveSCode,NewSGrp,NewSCode,BOff,NHistF,NHK)
                 else
                   Process_MoveList;

               end;
        {54  :  ; {* Auto recovery of stock renumber from list *}
      {$ENDIF}

      end; {Case..}

      UpdateProgress(ItemTotal);

      If ((TranOk2Run) and (TTEnabled)) or (ForceFinish) then {* Delete Ctrl File *}
      Begin
        LStatus:=LCtrl_BTrans(1);

        TTEnabled:=LStatusOk;

        If (Not (MoveRepCtrl^.MoveMode In [50..54])) or (ForceFinish) then
        Begin
          If (ForceFinish) then {* Also delete last move record as well *}
            Delete_MoveRecord(PWrdF,PWK,PMSCtrl^.MListRecAddr);

          FinishPMS;
        end;

        LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

        LReport_BError(InvF,LStatus);

        If (Not HaveAborted) then
          HaveAborted:=AbortTran;

        AbortTran:=BOff;

      end;


    end; {With..}
  end; {If being run from descendant class}

end;


Procedure TNHistMove.Finish;
Begin
  Inherited Finish;

  {Overridable method}

  If (Not HaveAborted) and (MyOHandle>0) and (fWhoAmI In [0]) then
    SendMessage(MyOHandle, WM_FormCloseMsg, WP_END_TREE_MOVE, LongInt(@SendRecCtrl^));
  If (Not HaveAborted) then
    SendMessage(Application.MainForm.Handle, WM_FormCloseMsg, 103, 0);

  InMainThread:=BOff;

end;



Function TNHistMove.StartMove(MoveRec  :  MoveRepPtr)  :  Boolean;

Var
  mbRet  :  Word;

Begin
  Result:=BOn;

  If (Assigned(MoveRec)) then
    MoveRepCtrl^:=MoveRec^
  else
    Result:=BOff;

  If (Result) then
  Begin
    {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
    begin
      // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
      if (not Assigned(LPostLocal)) then
        Result := Create_LocalThreadFiles;

      If (Result) then
        MTExLocal := LPostLocal;

    end
    else
    {$ENDIF}
    begin
      If (Not Assigned(PostExLocal)) then { Open up files here }
        Result:=Create_ThreadFiles;

      If (Result) then
        MTExLocal:=PostExLocal;
    end;

    If (Result) then {* Check if we can lock it *}
    With MTExLocal^, MoveRepCtrl^ do

    If (MoveMode <> 50) then
    Begin

      Result:=PostLockCtrl(0);

      If (Result) then
        LastRunNo:=CheckAbortedRun;

      If (LastRunNo<>0) and (Syss.ProtectPost) and (Result) then
      With LMiscRecs^,MultiLocRec do
      Begin
        ShowMessage('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                    'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC+#13+#13+
                    ThreadTitle+' cannot continue until the last posting is re run.');

        AddErrorLog('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                    'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC+#13+
                    ThreadTitle+' Aborted.','',4);

        Result:=BOff;
      end;


      If  (Result) then
      Begin

      {$B-}
        If (Not AlreadyInPost) and (Check4AbortPMS) then

      {$B+}

        Begin

          AddErrorLog(ThreadTitle+'. started by user '+Trim(PMSCtrl^.SUser)+' did not finish correctly.','',4);

          Result:=(CustomDlg(Application.MainForm,'WARNING!',MoveTitle,
                             'A previous '+MoveTitle+' started by user '+Trim(PMSCtrl^.SUser)+' did not complete correctly.'+
                             'Attempting to correct this problem now.'+#13+
                             'Do you wish to finish '+ThreadTitle+' now?',
                             mtWarning,
                             [mbYes,mbNo]
                             )=mrOk);


        end;

        If (Syss.ProtectPost) and (BTFileVer>=6) and (Result) then
        Begin
          If (Not AlreadyInPost) then
            LStatus:=LCtrl_BTrans(1)
          else
            LStatus:=0;

          TranOk2Run:=LStatusOk or (LStatus=37) {* Is already running *};

          If (Not TranOk2Run) then
          Begin
             AddErrorLog(MoveTitle+'. Protected Mode could not be started. (Error '+Form_Int(LStatus,0)+')','',4);

             LReport_BError(InvF,LStatus);

             Result:=(CustomDlg(Application.MainForm,'WARNING!',MoveTitle,
                             'It was not possible to start Protected Mode '+MoveTitle+' due to an error. '+
                             Form_Int(LStatus,0)+'.'#13+
                             'Do you wish to continue '+MoveTitle+' without Protected Mode?',
                             mtWarning,
                             [mbYes,mbNo]
                             )=mrOk);


          end;

          If (LStatusOk) and (Not AlreadyInPost) then
            LStatus:=LCtrl_BTrans(0);

        end;

        With MoveRepCtrl^ do
        If (Result) and ((MoveNCode<>Syss.NomCtrlCodes[ProfitBF]) and (NewNType<>CtrlNHCode) and (MoveMode<>2)) then {* Check for valid NCC *}
        Begin
          Result:=CheckValidNCC(CommitAct);

          If (Not Result) then
          Begin
            AddErrorLog(MoveTitle+'. One or more of the General Ledger Control Codes is not valid, or missing.','',4);

            CustomDlg(Application.MainForm,'WARNING!','Invalid G/L Control Codes',
                           'One or more of the General Ledger Control Codes is not valid, or missing.'+#13+
                           'Moving cannot continue until this problem has been rectified.'+#13+#13+
                           'Correct the Control Codes via Utilities/System Setup/Control Codes, then try again.',
                           mtError,
                           [mbOk]);


          end;

        end;

        If (Not Result) then {* Remove lock... *}
        Begin
          PostUnLock(0);

          If (Not Syss.ProtectPost) then
            FinishPMS;
        end;

      end
      else
        TranOk2Run:=BOff;

      fCanAbort:=(MoveMode=51) or (MoveMode=52);

    end; {With..}
  end;
  {$IFDEF EXSQL}
  if Result and SQLUtils.UsingSQL then
  begin
    MTExLocal^.Close_Files;
    CloseClientIdSession(MTExLocal^.ExClientID, False);
  end;
  {$ENDIF}
end;


Function TNHistMove.Start(MoveRec  :  MoveRepPtr)  :  Boolean;


Begin
  Case MoveRec.MoveMode of
    1, 51 : ProcessLockType := plMoveGLCode;
    2, 52 : ProcessLockType := plMoveStock;
    4     : ProcessLockType := plRenameStock;
    40    : ProcessLockType := plRenameAccount;
    else ProcessLockType := plNone;
  end;
  Result:=StartMove(MoveRec);
end;


{ ============== }


Function GlobMoveLockCtrl  :  Boolean;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  KeyS  :  Str255;
  LAddr :  LongInt;

Begin
  KeyS:=FullPLockKey(PostUCode,PostMCode,1);

  LAddr:=0;

  Result:=BOn;

  With PassWord,MoveCtrlRec do
  Begin

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    If (StatusOk) then {* record found, or not found *}
    Begin
      If (MoveStage>0) then {* Is it still being run ? *}
      Begin
        Status:=GetPos(F[Fnum],Fnum,LAddr);

        Status:=Find_Rec(B_GetEq+B_MultNWLock,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        If (StatusOk) then
        Begin
          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          CustomDlg(Application.MainForm,'WARNING!',GlobMoveTitle(WasMode),
                             GlobThreadTitle(MoveCtrlRec)+' did not finish properly.'+#13+
                             'Please inform user '+Trim(SUser)+' and re run the '+GlobMoveTitle(WasMode)+' immediately so that '+
                             'Attempting to correct the data.'+#13+#13+
                             'Please also make sure Protected Mode is switched ON.',
                             mtError,
                             [mbOk]);

          AddErrorLog(GlobThreadTitle(MoveCtrlRec)+' did not finish correctly.'+#13+
                      'The '+GlobMoveTitle(WasMode)+' was started by user '+Trim(SUser),'',4);
          Result:=BOff;
        end;
      end;
    end;
  end;
end;


Function AddMove2Thread(AOwner   :  TObject;
                        AMRec    :  MoveRepPtr)  :  Boolean;




Var
  LCheck_Nom :  ^TNHistMove;
  ThisResult :  Boolean;

Begin
  ThisResult:=BOff;

  If (Create_BackThread) then
  Begin
    New(LCheck_Nom,Create(AOwner));

    try
      With LCheck_Nom^ do
      Begin
        If (Start(AMRec)) and (Create_BackThread) then
        Begin
          If (AOwner is TForm) then
            MyOHandle:=TForm(AOwner).Handle;

          With BackThread do
            AddTask(LCheck_Nom,ThreadTitle);

          ThisResult:=BOn;
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LCheck_Nom,Destroy);
        end;
      end; {with..}

    except
      Dispose(LCheck_Nom,Destroy);

      Result:=BOff;
    end; {try..}
  end; {If process got ok..}

  Result:=ThisResult;
end;

{ ======== }

{ ========== TCheckNom methods =========== }

Constructor TCheckNom.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  fTQNo:=1;
  fCanAbort:=BOn;

  IsParentTo:=BOn;

  InCheckAll:=BOff;

  Blank(DelJobR,Sizeof(DelJobR));
end;

Destructor TCheckNom.Destroy;

Begin
  Inherited Destroy;
end;





{ ============ Cleared Balance Checker =========== }

Procedure TCheckNom.Set_PayInClearedStatus;

Const
  Fnum       =  IDetailF;
  Keypath2   =  IDNomK;


Var
  LOk,
  Locked,
  Loop    :  Boolean;

  DCnst   :  SmallInt;


  KeyS,
  KeyChk  :  Str255;


  RStatus,
  B_Func,
  KLen    :  Integer;


Begin

  KLen:=0;

  RStatus:=0;


  With MTExLocal^,LId do
  Begin
    DCnst:=-1;

    Loop:=BOff;



    Repeat


      KeyChk:=FullIdPostKey(UCode*DCnst,0,PayInNomMode,0,0,0);


      KeyS:=KeyChk;

      KLen:=Succ(Sizeof(NomCode));


      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath2,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,KLen,BOn)) do
      Begin
        B_Func:=B_GetNext;

        If (LCheck_PayInStatus(LId)=2) then
          RStatus:=ReconC
        else
          RStatus:=0;

        If (Reconcile<>RStatus) or (ReconDate='') or (Length(PDate)=6) or (NomCode>=0) and (PostedRun<>0) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum,BOn,Locked);

          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            Reconcile:=RStatus;

            If (Reconcile<>ReconC) then
              ReconDate:=MaxUntilDate;

            If (NomCode>=0) then
            Begin
              NomCode:=NomCode*DocNotCnst;
              B_Func:=B_GetGEq;

            end;

            If (Length(PDate)=6) then
            Begin

              PDate:='19'+PDate;
            end;


            LStatus:=LPut_Rec(Fnum,KeyPath2);

            Report_BError(Fnum,Status);

            LStatus:=LUnLockMLock(Fnum);
          end;
        end; {If ..}

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath2,KeyS);

      end; {While..}

      Loop:=Not Loop;

      If (Loop) then
        DCnst:=1;


    Until (Not Loop);

  end; {With..}

end; {Proc..}


{ ========== Zero Nominal Cleared Balance ========== }

Procedure TCheckNom.Reset_Cleared;



Const
  Fnum     =  NHistF;

  Keypath  =  NHK;



Var
  KeyS,
  KeyChk   :  Str255;

  Loop     :  Byte;
  BalCF    :  Double;


Begin
  Loop:=0; BalCF:=0.0;

  Repeat

    With MTExLocal^,LNom do
    Begin
      If (Loop>0) then
        KeyChk:=NomType+CSubCode[Loop=2]+FullNomKey(NomCode)
      else
        KeyChk:=PartNHistKey(NomType,FullNomKey(NomCode),0);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Pred(Length(KeyChk)),BOn)) do
      With LNHist do
      Begin

        {*EN420}
        If (AfterPurge(Yr,0)) then
        Begin
          If (Pr=YTD) then {* We need to carry total balance forward from purge year *}
            Cleared:=BalCF
          else
            Cleared:=0;


          LStatus:=LPut_Rec(Fnum,Keypath);

          LReport_BError(Fnum,LStatus);
        end
        else
          If (Yr=Syss.AuditYr) and (Pr=YTD) then
            BalCF:=Cleared;


        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {With..}

    end; {With..}

    Inc(Loop);

  Until (Loop>2);
end; {Proc..}



{ ========== Zero Nominal Actual Balance ========== }

Procedure TCheckNom.Reset_Actual;



Const
  Fnum     =  NHistF;

  Keypath  =  NHK;



Var
  KeyS,
  KeyChk   :  Str255;

  Loop     :  Byte;

  BalCFS,
  BalCFP,
  BalCFC,
  BalCV1,
  BalCV2,
  BalCV3
           :  Array[0..CurrencyType] of Double;


Begin
  Loop:=0;

  Blank(BalCFS,Sizeof(BalCFS));
  Blank(BalCFP,Sizeof(BalCFP));
  Blank(BalCFC,Sizeof(BalCFC));
  Blank(BalCV1,Sizeof(BalCV1));
  Blank(BalCV2,Sizeof(BalCV2));
  Blank(BalCV3,Sizeof(BalCV3));

  Repeat

    With MTExLocal^,LNom do
    Begin
      If (Loop>0) then
        KeyChk:=NomType+CSubCode[Loop=2]+FullNomKey(NomCode)
      else
        KeyChk:=NomType+FullNomKey(NomCode);

      KeyS:=KeyChk;

      DelCCDepHist:=(Loop>0);

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Pred(Length(KeyChk)),BOn)) do
      With LNHist do
      Begin

        If (IsCCDepHist) then
        Begin
          If (AfterPurge(Yr,0)) or (CheckActMode=20) then
          Begin
            If (Pr=YTD) then {* We need to carry total balance forward from purge year *}
            Begin
              Sales:=BalCFS[Cr];
              Purchases:=BalCFP[Cr];

              If (CheckActMode=2) then
              Begin
                Cleared:=BalCFC[Cr];
                Value1:=BalCV1[Cr];
                Value2:=BalCV2[Cr];
                Value3:=BalCV3[Cr];
              end;
            end
            else
            Begin
              Sales:=0.0;
              Purchases:=0.0;

              If (CheckActMode=2) then
              Begin
                Cleared:=0.0;
                Value1:=0.0;
                Value2:=0.0;
                Value3:=0.0;
              end;
            end;


            LStatus:=LPut_Rec(Fnum,Keypath);

            LReport_BError(Fnum,LStatus);
          end
          else
            If (Yr=Syss.AuditYr) and (Pr=YTD) then
            Begin
              BalCFS[Cr]:=Sales;
              BalCFP[Cr]:=Purchases;

              If (CheckActMode=2) then
              Begin
                BalCFC[Cr]:=Cleared;
                BalCV1[Cr]:=Value1;
                BalCV2[Cr]:=Value2;
                BalCV3[Cr]:=Value3;
              end;
            end;
        end; {If..}

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {With..}

    end; {With..}

    Inc(Loop);

  Until (Loop>2);

  MTExLocal^.DelCCDepHist:=BOff;

end; {Proc..}


{ ============ Actual Balance Checker =========== }

Procedure TCheckNom.Set_ActualStatus;

Const
  Fnum       =  IDetailF;
  Keypath2   =  IDNomK;


Var

  KeyS,
  KeyChk  :  Str255;

  LAddr,
  TNCode  :  LongInt;

  LOk,
  Locked,
  Loop    :  Boolean;

  KLen    :  Integer;

  PCount,
  LineCount,
  HistCount:  LongInt;

  LVal,
  LCleared,
  PBal    :  Double;

  CrDr,
  DiscCrDr:  DrCrDType;




Begin

  KLen:=0;


  TNCode:=0;

  PBal:=0; LCleared:=0.0;


  LVal:=0;

  LAddr:=0;

  Try
    If (Not InCheckAll) then
      Send_UpdateList(70);


    With MTExLocal^ do
    Begin


      If (Not InCheckAll) then
      Begin
        With LNom do
          ShowStatus(1,dbFormatName(Form_Int(NomCode,0),Desc));

        LineCount:=Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId);
        HistCount:=Used_RecsCId(LocalF^[NHistF],NHistF,ExCLientId);

        InitProgress(LineCount+HistCount);


      end
      else
      Begin
        LineCount:=0; HistCount:=0;
      end;



      KeyS:=FullNomKey(LNom.NomCode);

      LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,NomCodeK,NomF,BOn,Locked);

      If (LOk) and (Locked) then
      Begin
        LGetRecAddr(NomF);


        If (Not InCheckAll) then
          ShowStatus(2,'Clearing actual balance.');

        Reset_Actual;

        PCount:=HistCount;

        If (Not InCheckAll) then
          UpdateProgress(PCount);

        KeyChk:=FullIdPostKey(UCode,0,0,0,0,0);


        KeyS:=KeyChk;

        KLen:=Succ(Sizeof(UCode));


        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath2,KeyS);


        If (Not InCheckAll) then
          ShowStatus(2,'Calculating new balance.');

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,KLen,BOn)) and (Not ThreadRec^.THAbort) do
        With LId do
        Begin
          Inc(PCount);

          If (Not InCheckAll) then
            UpdateProgress(PCount);

          If (PostedRun>0) and (AfterPurge(LId.PYr,0)) then
          Begin

            LVal:=DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0);


            If (Syss.SepDiscounts) and (LVal=0.0) and (IdDocHed=RUN) then {*Value in discount}
              LVal:=Round_Up((LVal-DetLTotal(LId,Syss.SepDiscounts,BOff,0.0))*DocNotCnst,2);

            ShowDrCrD(LVal,CrDr);

            LPost_To_Nominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],LCleared,Currency,PYr,PPr,1,BOff,(IdDocHed<>RUN),BOff,CXrate,PBal,TNCode,UseORate);

            {$IFDEF PF_On}
             If (Syss.PostCCNom) and (Syss.UseCCDep) then
             Begin
               Loop:=BOff;

               Repeat
                 If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
                 Begin
                   LPost_To_CCNominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],LCleared,Currency,PYr,PPr,1,BOff,(IdDocHed<>RUN),BOff,
                                     CXRate,PostCCKey(Loop,CCDep[Loop]),UseORate);

                   {* Post to combination *}

                   If (Syss.PostCCDCombo) then
                     LPost_To_CCNominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],LCleared,Currency,PYr,PPr,1,BOff,(IdDocHed<>RUN),BOff,
                                     CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UseORate);

                 end;

                 Loop:=Not Loop;

               Until (Not Loop);
             end;

           {$ENDIF}


          end;


          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath2,KeyS);

        end; {While..}


        LStatus:=LUnLockMLock(NomF);
      end;

      If (Not InCheckAll) then
      Begin
        UpdateProgress(LineCount+HistCount);


      end;
    end; {With..}
  Finally

    If (Not InCheckAll) then
      Send_UpdateList(72);
  end; {Try..}

end; {Proc..}


{ ====== Function to set full NHist Key ====== }


Function TCheckNom.Set_ActNHist( NRec  :  NominalRec;
                                 SRec  :  StockRec;
                                 Mode  :  Boolean)  :  Str255;

Var
  NCode  :  Char;

Begin

  Case Mode of
    {$IFDEF STK}
      BOff  :  With SRec do
               Begin
                 NCode:=StockType;

                 Result:=FullNHistKey(NCode,FullNomKey(StockFolio),0,GetLocalPr(0).CYr,1);
               end;
    {$ENDIF}

    BOn  :  With NRec do
            Begin
              NCode:=NomType;

              Result:=FullNHistKey(Ncode,FullNomKey(NomCode),0,GetLocalPr(0).CYr,1);
            end;
  end; {case..}


end; {Func..}

 { ========== Procedure to reset all Headings prior to an update ======= }

 Procedure TCheckNom.Reset_AHeadings(HCode  :  Char);

 Const
   Fnum      =  NomF;
   Keypath   =  NomCodeK;


 Var
   KeyS      :  Str255;

   LOk,
   Locked    :  Boolean;

   ItemCount :  LongInt;


 Begin
   KeyS:='';

   ItemCount:=0;

   Locked:=BOff;

   With MTEXLocal^ do
   Begin
     LStatus:=LFind_Rec(B_StepFirst,Fnum,keypath,KeyS);

     While (LStatusOk) and (Not ThreadRec^.THAbort) do
     With LNom do
     Begin
       Inc(ItemCount);

      UpdateProgress(ItemCount);


       If (NomType=HCode) then
         Reset_Actual;

       LStatus:=LFind_Rec(B_StepNext,Fnum,Keypath,KeyS);
     end; {While..}
   end; {With.}

 end; {Proc..}


 { ============ Procedure to Update all Parent with lower budget records  ============ }

 Procedure TCheckNom.Update_ParentActual(LowKey,
                                         HiKey      :  Str255;
                                         ProMode,
                                         AutoPBF    :  Boolean);

 Const
   Fnum     =  NHistF;
   Keypath  =  NHK;

 Var
   n,
   Loop   :  Byte;

   CDpCode:  Str20;

   KeyChk,
   KeyHChk,
   KeyS,
   KeyHS  :  Str255;

   FoundOk,FLoop,
   BeenWarned,
   LOk,
   Locked :  Boolean;

   LowHist,
   GetHist,
   HedHist,
   HiHist :  HistoryRec;

   LastStatus
          :  Integer;

   TmpKPath,
   TmpStat
          :  Integer;

   TmpRecAddr
          :  LongInt;

   PBalBF :  Double;

   LUP    :  tPassDefType;
  {$IFDEF PERIODFIX}
    oUPCache : TUserPeriodCache;
  {$ENDIF}

Begin

  LastStatus:=0; Loop:=0; n:=0; PBalBF:=0;


  Locked:=BOff;

  Extract_NHistfromNKey(Lowkey,LowHist);

  Extract_NHistfromNKey(Hikey,HiHist);

  LUP:=UserProfile^;
  {$IFDEF PERIODFIX}
    oUPCache := oUserPeriod.GetCache;
  {$ENDIF}

  With MTEXLocal^ do
  Begin
    Repeat
      With LowHist do
      If (Loop>0) then
      Begin
        Case ProMode of
          BOn  :  KeyChk:=ExClass+CSubCode[Loop=2]+Copy(Code,1,4);

        end; {Case..}

      end
      else
      Begin
        Case ProMode of
          BOn  :  KeyChk:=ExClass+Code;
        end; {Case..}
      end;

      DelCCDepHist:=(Loop>0);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not THreadRec^.THAbort) do
      Begin
        If (IsCCDepHist) then
        Begin

          If (THreadRec^.THAbort) and (Not BeenWarned) then
          Begin
            ShowStatus(3,'Please Wait, finishing current actual.');

            BeenWarned:=BOn;

          end;

          GetHist:=LNHist;

          FLoop:=BOff; FoundOk:=BOff;

          TmpKPath:=KeyPath;

          TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

          If ((GetHist.Pr<>YTD) or (AutoPBF)) and ((AfterPurge(GetHist.Yr,0)) or (CheckActMode=20)) then {Only process non carry forward codes, as YTD will be updated automatically. Purge year not destroyed}
          Repeat {Attempt to find immediate parent equivalent, if not create via fill}
            With HiHist do
            If (Loop>0) then
            Begin
              Case ProMode of
                BOn  :  Begin {Manufacture Cc/Dep code from host}
                          CDpCode:=Copy(GetHist.Code,1,1)+Copy(Code,1,4)+Copy(GetHist.Code,6,NHCodeLen-6);
                          KeyHChk:=FullNHistKey(ExClass,CDpCode,GetHist.Cr,GetHist.Yr,GetHist.Pr);

                        end;
              end; {Case..}

            end
            else
            Begin
              Case ProMode of
                BOn  :  KeyHChk:=FullNHistKey(ExClass,Code,GetHist.Cr,GetHist.Yr,GetHist.Pr);

              end; {Case..}
            end;


            KeyHS:=KeyHChk;

            LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyHS);

            If (Not LStatusOk) or (Not CheckKey(KeyHChk,KeyHS,Length(KeyHChk),BOn)) then
            Begin
              {$IFDEF PERIODFIX}
              oUserPeriod.SetPeriodYear(GetHist.Pr, GetHist.Yr);
              {$ELSE}
              With UserProfile^ do
              Begin
                UCYr:=GetHist.Yr;
                UCPr:=GetHist.Pr;
              end;
              {$ENDIF}

              LFillBudget(FNum,KeyPath,n,KeyHChk);

            end
            else
              FoundOk:=BOn;

            fLoop:=Not fLoop;

          Until (Not fLoop) or (FoundOk);

          If (FoundOk) then
          Begin
            HedHist:=LNHist;

            LPost_To_Hist2(HedHist.ExClass,HedHist.Code,
                                   GetHist.Purchases,
                                   GetHist.Sales,
                                   GetHist.Cleared,
                                   GetHist.Value1,
                                   GetHist.Value2,
                                   HedHist.Cr,HedHist.Yr,HedHist.Pr,
                                   PBalBF);


            If (GetHist.ExClass In YTDSet) and (Not AutoPBF) then {Process carry forward codes YTD, and future YTD}
              LPost_To_CYTDHist2(HedHist.ExClass,HedHist.Code,
                                 GetHist.Purchases,
                                 GetHist.Sales,
                                 GetHist.Cleared,
                                 GetHist.Value1,
                                 GetHist.Value2,
                                 HedHist.Cr,HedHist.Yr,YTD);
          end; {If FoundOk..}

          TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
        end; {If wrong type}

        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

      end; {While..}

      Inc(Loop);


    Until (Loop>2) or (THreadRec^.THAbort);

    DelCCDepHist:=BOff;
    LReport_BError(Fnum,LastStatus);

  end; {With..}

  UserProfile^:=LUP;
  {$IFDEF PERIODFIX}
    oUserPeriod.RestoreCache(oUPCache);
  {$ENDIF}
end; {Proc..}

{ === Procedure to Scan all low level nom/stock types and update upper levels with actual totals === }

Procedure TCheckNom.Update_GlobalActuals(ProMode    :  Boolean);


Const
  Fnum1    =  NomF;
  Keypath1 =  NomCodeK;

  Fnum2    =  StockF;
  Keypath2 =  StkCodeK;

  ModeCode :  Array[BOff..BOn] of Char = (StkGrpCode,NomHedCode);




Var
  KeyS,
  KeyChk,
  KeyCat,
  LowKey,
  HiKey    :  Str255;

  RecAddr  :  LongInt;

  AutoPBF,
  Mode,
  LoopEnd,
  NoAbort  :  Boolean;

  mbRet    :  Word;

  Fnum,
  Keypath,
  TmpKPath,
  TmpStat
           :  Integer;

  ItemCount,
  TmpRecAddr
           :  LongInt;

  {$IFDEF Rp}
    TbBalance :  Double;
    ChkTbBal  :  ^TGenReport;

  {$ENDIF}


Begin
  Send_UpdateList(70);



  {$B-}

  With MTExLocal^ do
  Begin

  {$B+}

    ItemCount:=0;

    KeyS:='';

    LowKey:='';

    HiKey:='';

    LoopEnd:=BOff;  AutoPBF:=BOff;


    Case ProMode of

      BOff :  Begin

                Fnum:=Fnum2;

                Keypath:=Keypath2;

              end;

      BOn  :  Begin

                Fnum:=Fnum1;

                Keypath:=Keypath1;

              end;

    end; {Case..}



    TICount:=Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId);

    InitProgress(TICount*2);

    ShowStatus(2,'Resetting existing totals.');

    Reset_AHeadings(ModeCode[ProMode]);

    ItemCount:=TICount;

    ShowStatus(1,'Processing:-');

    LStatus:=LFind_Rec(B_StepFirst,Fnum,keypath,KeyS);


    While (LStatusOk) and (Not ThreadRec^.THAbort) do
    Begin

      Inc(ItemCount);

      UpdateProgress(ItemCount);

      If (Not (HeadCode(LNom,LStock,ProMode) In ModeSet)) and ((LNom.NomType<>CarryFlg) or (Not ProMode)) then
      Begin

        If (ProMode) then
          With LNom do
            ShowStatus(2,dbFormatName(Form_Int(NomCode,0),Desc))
        else
          With LStock do
            ShowStatus(2,dbFormatName(StockCode,Desc[1]));

        TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        AutoPBF:=(LNom.NomCode=Syss.NomCtrlCodes[ProfitBF]) and (ProMode);

        LowKey:=Set_ActNHist(LNom,LStock,ProMode);

        Case ProMode of

        {$IFDEF STK}

          BOff  :  With LStock do
                    KeyChk:=FullStockCode(StockCat);

        {$ENDIF}

          BOn   :  With LNom do
                    KeyChk:=FullNomKey(Cat);
        end; {case..}

        LoopEnd:=BOff;

        Repeat

          LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyChk);

          LoopEnd:=Not LStatusOk;

          If (LStatusOk) then
          Begin

            HiKey:=Set_ActNHist(LNom,LStock,ProMode);


            Update_ParentActual(LowKey,HiKey,ProMode,AutoPBF);

          end;

          If (Not LoopEnd) then
            Case ProMode of
              BOff :  With LStock do
                      Begin

                        {$IFDEF STK}

                          LoopEnd:=EmptyKey(StockCat,StkKeyLen);

                          KeyChk:=FullStockCode(StockCat);

                        {$ENDIF}

                      end;

              BOn  :  With LNom do
                      Begin
                        LoopEnd:=(Cat=0);

                        KeyChk:=FullNomKey(Cat);
                      end;
            end; {case..}

        Until (LoopEnd) or (ThreadRec^.THAbort);


        TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


      end; {If a non heading variable}

      LStatus:=LFind_Rec(B_StepNext,Fnum,keypath,KeyS);

    end; {while..}

    UpdateProgress(TICount*2);

    If (ThreadRec^.THAbort) then
    Begin
      Write_PostLog('Check G/L Headings interrupted by user. Run again, or restore backup.',BOn);

      AddErrorLog('Check G/L Headings interrupted by user. Run again, or restore backup.','',4);
    end
    else
      If (ProMode) then
      Begin
        TbBalance:=0.0;

        {$IFDEF Rp}
          Try
            New(ChkTbBal,Create(Self.fmyOwner));

            ChkTbBal^.MTExLocal:=Self.MTExLocal;

            TbBalance:=ChkTbBal^.TB_Difference;

          Finally
            Dispose(ChkTbBal,Destroy);

          end; {Try..}

          If (ABS(TbBalance)>0.10) then
            Write_PostLog('After running Check G/L Headings, there is an imbalance of '+FormatBFloat(GenRealMask,TbBalance,BOff)+' within the G/L.',BOn)
          else
            Write_PostLog('After running Check G/L Headings, the G/L Balances.',BOn);
        {$ENDIF}

      end;

  end; {If In Nom/Stock}

  Send_UpdateList(72);



end; {Proc..}


{$IFDEF JC}

  { ========== Zero Job Actual Balance ========== }

  Procedure TCheckNom.Reset_JActual;



  Const
    Fnum     =  NHistF;

    Keypath  =  NHK;



  Var
    KeyS,
    KeyChk   :  Str255;

    Loop     :  Byte;

    BalCFS,
    BalCFP,
    BalCFC,
    BalCV1,
    BalCV2,
    BalCV3
             :  Array[0..CurrencyType] of Double;


  Begin
    Loop:=0;

    Blank(BalCFS,Sizeof(BalCFS));
    Blank(BalCFP,Sizeof(BalCFP));
    Blank(BalCFC,Sizeof(BalCFC));
    Blank(BalCV1,Sizeof(BalCV1));
    Blank(BalCV2,Sizeof(BalCV2));
    Blank(BalCV3,Sizeof(BalCV3));


    With MTExLocal^,LJobRec^ do
    Begin
      KeyChk:=JobType+FullJobCode(JobCode);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LNHist do
      Begin

        If (AfterPurge(Yr,0))  or (CheckActMode=23) then
        Begin
          If (Pr=YTD) then {* We need to carry total balance forward from purge year *}
          Begin
            Sales:=BalCFS[Cr];
            Purchases:=BalCFP[Cr];

            {If (CheckActMode=2) then}
            Begin
              Cleared:=BalCFC[Cr];
              Value1:=BalCV1[Cr];
              Value2:=BalCV2[Cr];
              Value3:=BalCV3[Cr];
            end;
          end
          else
          Begin
            Sales:=0.0;
            Purchases:=0.0;

            {If (CheckActMode=2) then}
            Begin
              Cleared:=0.0;
              Value1:=0.0;
              Value2:=0.0;
              Value3:=0.0;
            end;
          end;


          LStatus:=LPut_Rec(Fnum,Keypath);

          LReport_BError(Fnum,LStatus);
        end
        else
          If (Yr=Syss.AuditYr) and (Pr=YTD) then
          Begin
            BalCFS[Cr]:=Sales;
            BalCFP[Cr]:=Purchases;

            If (CheckActMode=2) then
            Begin
              BalCFC[Cr]:=Cleared;
              BalCV1[Cr]:=Value1;
              BalCV2[Cr]:=Value2;
              BalCV3[Cr]:=Value3;
            end;
          end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {With..}

    end; {With..}


  end; {Proc..}


  { ====== Function to set full NHist Key ====== }


  Function TCheckNom.Set_ActJNHist(JRec  :  JobRecType)  :  Str255;

  Var
    NCode  :  Char;

  Begin
    With JRec do
    Begin
      NCode:=JobType;

      Result:=FullNHistKey(Ncode,FullJobCode(JobCode),0,GetLocalPr(0).CYr,1);
    end; {With..}


  end; {Func..}

   { ========== Procedure to reset all Headings prior to an update ======= }

   Procedure TCheckNom.Reset_JAHeadings(HCode  :  Char);

   Const
     Fnum      =  JobF;
     Keypath   =  JobCodeK;


   Var
     KeyS      :  Str255;

     LOk,
     Locked    :  Boolean;

     ItemCount :  LongInt;


   Begin
     KeyS:='';

     ItemCount:=0;

     Locked:=BOff;

     With MTEXLocal^ do
     Begin
       LStatus:=LFind_Rec(B_StepFirst,Fnum,keypath,KeyS);

       While (LStatusOk) and (Not ThreadRec^.THAbort) do
       With LJobRec^ do
       Begin
         Inc(ItemCount);

        UpdateProgress(ItemCount);


         If (JobType=HCode) then
           Reset_JActual;

         LStatus:=LFind_Rec(B_StepNext,Fnum,Keypath,KeyS);
       end; {While..}
     end; {With.}

   end; {Proc..}


   { ============ Procedure to Update all Parent with lower budget records  ============ }

   Procedure TCheckNom.Update_JobParentActual(LowKey,
                                              HiKey      :  Str255);

   Const
     Fnum     =  NHistF;
     Keypath  =  NHK;

   Var
     n,
     Loop   :  Byte;

     CDpCode:  Str20;

     KeyChk,
     KeyHChk,
     KeyS,
     KeyHS  :  Str255;

     FoundOk,FLoop,
     BeenWarned,
     LOk,
     Locked :  Boolean;

     LowHist,
     GetHist,
     HedHist,
     HiHist :  HistoryRec;

     LastStatus
            :  Integer;

     TmpKPath,
     TmpStat
            :  Integer;

     TmpRecAddr
            :  LongInt;

     PBalBF :  Double;

     LUP    :  tPassDefType;
     {$IFDEF PERIODFIX}
       oUPCache : TUserPeriodCache;
     {$ENDIF}

     //PR: 07/04/2014 ABSEXCH-13873
     iFolio : longint;
     sFolio : ShortString;

  Begin

    LastStatus:=0; Loop:=0; n:=0; PBalBF:=0;


    Locked:=BOff;

    Extract_NHistfromNKey(Lowkey,LowHist);

    Extract_NHistfromNKey(Hikey,HiHist);

    LUP:=UserProfile^;
    {$IFDEF PERIODFIX}
      oUPCache := oUserPeriod.GetCache;
    {$ENDIF}

    With MTEXLocal^ do
    Begin
      With LowHist do
        KeyChk:=ExClass+Copy(Code,1,JobCodeLen);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not THreadRec^.THAbort) do
      Begin

        If (THreadRec^.THAbort) and (Not BeenWarned) then
        Begin
          ShowStatus(3,'Please Wait, finishing current actual.');

          BeenWarned:=BOn;

        end;

        GetHist:=LNHist;

        If (CheckActMode=7) then {* Negate the value so it comes off *}
        With GetHist do
        Begin
          Purchases:=Purchases*DocNotCnst;
          Sales:=Sales*DocNotCnst;
          Cleared:=Cleared*DocNotCnst;
          Value1:=Value1*DocNotCnst;
          Value2:=Value2*DocNotCnst;
        end;

        FLoop:=BOff; FoundOk:=BOff;

        TmpKPath:=KeyPath;

        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        If (GetHist.Pr<>YTD) and ((AfterPurge(GetHist.Yr,0)) or (CheckActMode=23)) then {Only process non carry forward codes, as YTD will be updated automatically. Purge year not destroyed}
        Repeat {Attempt to find immediate parent equivalent, if not create via fill}
          With HiHist do
          Begin
            //PR: 07/04/2014 ABSEXCH-13873 Amend to use new function to find correct folio number for this budget for parent

            //Move HistFolio from History Code field into iFolio integer
            sFolio := Copy(GetHist.Code,Succ(JobCodeLen),NomKeyLen);
            iFolio := UnFullNomKey(sFolio);

            // Find appropriate parent HistFolio and put it into iFolio
            // HistFolio numbers start at 1000 to avoid analysis header codes, so don't bother with anything lower.
            if iFolio >= 1000 then
              iFolio :=  GetHistFolioForParent(Copy(LowHist.Code,1,JobCodeLen), //JobCode
                                               Copy(Code,1,JobCodeLen), //ParentCode
                                               iFolio);

            //Build Code string
            Code:=Copy(Code,1,JobCodeLen) + FullNomKey(iFolio); //JobHistFolio

              {* Have to append the matching folio number to the code *}
//old code            Code:=Copy(Code,1,JobCodeLen)+Copy(GetHist.Code,Succ(JobCodeLen),NomKeyLen);

            KeyHChk:=FullNHistKey(ExClass,Code,GetHist.Cr,GetHist.Yr,GetHist.Pr);
          end;

          KeyHS:=KeyHChk;

          LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyHS);

          If (Not LStatusOk) or (Not CheckKey(KeyHChk,KeyHS,Length(KeyHChk),BOn)) then
          Begin
            {$IFDEF PERIODFIX}
            oUserPeriod.SetPeriodYear(GetHist.Pr, GetHist.Yr);
            {$ELSE}
            With UserProfile^ do
            Begin
              UCYr:=GetHist.Yr;
              UCPr:=GetHist.Pr;
            end;
            {$ENDIF}

            LFillBudget(FNum,KeyPath,n,KeyHChk);

          end
          else
            FoundOk:=BOn;

          fLoop:=Not fLoop;

        Until (Not fLoop) or (FoundOk);

        If (FoundOk) then
        Begin
          HedHist:=LNHist;

          LPost_To_Hist2(HedHist.ExClass,HedHist.Code,
                                 GetHist.Purchases,
                                 GetHist.Sales,
                                 GetHist.Cleared,
                                 GetHist.Value1,
                                 GetHist.Value2,
                                 HedHist.Cr,HedHist.Yr,HedHist.Pr,
                                 PBalBF);


          If (GetHist.ExClass In YTDSet) then {Process carry forward codes YTD, and future YTD}
            LPost_To_CYTDHist2(HedHist.ExClass,HedHist.Code,
                               GetHist.Purchases,
                               GetHist.Sales,
                               GetHist.Cleared,
                               GetHist.Value1,
                               GetHist.Value2,
                               HedHist.Cr,HedHist.Yr,YTD);
        end; {If FoundOk..}

        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

      end; {While..}

      LReport_BError(Fnum,LastStatus);

    end; {With..}

    UserProfile^:=LUP;
    {$IFDEF PERIODFIX}
      oUserPeriod.RestoreCache(oUPCache);
    {$ENDIF}
  end; {Proc..}

  { === Procedure to Scan all low level Job records and update upper levels with actual totals === }

  Procedure TCheckNom.Update_JobGlobalActuals;


  Const
    Fnum1    =  JobF;
    Keypath1 =  JobCodeK;


    ModeCode = JobGrpCode;




  Var
    KeyS,
    KeyChk,
    KeyCat,
    LowKey,
    HiKey    :  Str255;

    RecAddr  :  LongInt;

    Mode,
    LoopEnd,
    NoAbort  :  Boolean;

    mbRet    :  Word;

    Fnum,
    Keypath,
    TmpKPath,
    TmpStat
             :  Integer;

    ItemCount,
    TmpRecAddr
             :  LongInt;

    {$IFDEF Rp}
      TbBalance :  Double;
      ChkTbBal  :  ^TGenReport;

    {$ENDIF}

     i : integer;
  Begin
    //PR: 07/04/2014 ABSEXCH-13873 Create cache lists
    FolioList := TList.Create;
    JobAnalList := TList.Create;

    if SQLUtils.UsingSQL then // //PR: 08/04/2014 ABSEXCH-13873 Create SQLCaller
    begin
      FSQLCaller := TSQLCaller.Create(GlobalADOConnection);
      FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

      //Set query
      FSQLCaller.Records.CommandText :=
        'Select HistFolio from [' + FCompanyCode + '].[AnalysisCodeBudget] as ContractBudget ' +
        'where ContractBudget.JobCode = :ParentJobCode and ' +
        'ContractBudget.AnalCode = (Select AnalCode from [' + FCompanyCode + '].[AnalysisCodeBudget] as JobBudget ' +
                                   'where JobBudget.JobCode = :JobCode ' +
                                    'and JobBudget.HistFolio = :JobHistFolio)';
      FSQLCaller.Records.Prepared := True;
      if not FSQLCaller.Connection.Connected then
        FSQLCaller.Connection.Open;
    end;

    Send_UpdateList(70);



    {$B-}

    With MTExLocal^ do
    Begin

    {$B+}

      ItemCount:=0;

      KeyS:='';

      LowKey:='';

      HiKey:='';

      LoopEnd:=BOff;


      Fnum:=Fnum1;

      Keypath:=Keypath1;

      TICount:=Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId);

      InitProgress(TICount*2);

      ShowStatus(2,'Resetting existing totals.');

      If (CheckActMode<>7) then {* We are deducting following a delete so no reset necessary *}
        Reset_JAHeadings(ModeCode);

      ItemCount:=TICount;

      ShowStatus(1,'Processing:-');

      If (CheckActMode<>7) then {* We are deducting following a delete so no reset necessary *}
        LStatus:=LFind_Rec(B_StepFirst,Fnum,keypath,KeyS)
      else
      Begin
        LJobRec^:=DelJobR;
        LStatus:=0;
      end;


      While (LStatusOk) and (Not ThreadRec^.THAbort) do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        If (Not (LJobRec^.JobType In [JobGrpCode]))  then
        Begin
          With LJobRec^ do
            ShowStatus(2,dbFormatName(JobCode,JobDesc));

          TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

          LowKey:=Set_ActJNHist(LJobRec^);

          With LJobRec^ do
            KeyChk:=FullJobCode(JobCat);

          LoopEnd:=BOff;

          Repeat

            LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyChk);

            LoopEnd:=Not LStatusOk;

            If (LStatusOk) then
            Begin

              HiKey:=Set_ActJNHist(LJobRec^);


              Update_JobParentActual(LowKey,HiKey);

            end;

            If (Not LoopEnd) then
              With LJobRec^ do
              Begin
                LoopEnd:=(EmptyKey(JobCat,JobCodeLen));

                KeyChk:=FullJobCode(JobCat);
              end; {With..}

          Until (LoopEnd) or (ThreadRec^.THAbort);


          TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


        end; {If a non heading variable}

        If (CheckActMode<>7) then {* We are deducting following a delete so no reset necessary *}
          LStatus:=LFind_Rec(B_StepNext,Fnum,keypath,KeyS)
        else
        Begin
          LStatus:=9; {* Force end as only dealing with one *}

        end;

      end; {while..}

      If (CheckActMode=7) then
      With DelJobR do {* Remove job history here *}
      Begin
        KeyChk:=JobType+JobCode;

        LDeleteLinks(KeyChk,NHistF,Length(KeyChk),NHK,BOff);

      end;

      UpdateProgress(TICount*2);

      If (ThreadRec^.THAbort) then
      Begin
        Write_PostLog('Check Job Headings interrupted by user. Run again, or restore backup.',BOn);

        AddErrorLog('Check Job Headings interrupted by user. Run again, or restore backup.','',4);
      end;

    end; {If In Nom/Stock}

    Send_UpdateList(72);

    //PR: 07/04/2014 ABSEXCH-13873 Free cache list
    if Assigned(FolioList) then
    begin
      for i := 0 to FolioList.Count - 1 do
        Dispose(FolioList[i]);

      FolioList.Free;
    end;

    //PR: 08/04/2014 ABSEXCH-13873 Free secondary cache list
    if Assigned(JobAnalList) then
    begin
      for i := 0 to JobAnalList.Count - 1 do
        Dispose(JobAnalList[i]);

      JobAnalList.Free;
    end;

    //PR: 08/04/2014 ABSEXCH-13873 Free SQL Caller
    if Assigned(FSQLCaller) then
      FSQLCaller.Free;


  end; {Proc..}
{$ENDIF}



{ === Procedure to Scan all low level nom types and update all actual totals === }

Procedure TCheckNom.Set_AllActualsStatus;


Const
  Fnum1    =  NomF;
  Keypath1 =  NomCodeK;

  ModeCode :  Charset = [PLNHCode,BankNHCode,CtrlNHCode];




Var
  KeyS     :  Str255;

  RecAddr  :  LongInt;

  NoAbort  :  Boolean;

  mbRet    :  Word;

  Fnum,
  Keypath,
  TmpKPath,
  TmpStat
           :  Integer;

  ItemCount,
  TmpRecAddr
           :  LongInt;

  TbBalance,
  Purch,Sales,Cleared
         :  Double;



Begin
  CheckActMode:=1;  InCheckAll:=BOn;

  {$B-}

  With MTExLocal^ do
  Begin

  {$B+}

    ItemCount:=0;  TbBalance:=0.0;

    KeyS:='';

    Fnum:=Fnum1;

    Keypath:=Keypath1;

    TICount:=Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId);

    InitProgress(TICount);

    ItemCount:=0;

    ShowStatus(1,'Processing:-');

    LStatus:=LFind_Rec(B_StepFirst,Fnum,keypath,KeyS);


    While (LStatusOk) and (Not ThreadRec^.THAbort) do
    Begin

      Inc(ItemCount);

      UpdateProgress(ItemCount);

      If (LNom.NomType In ModeCode)  then
      Begin

        With LNom do
        Begin
          ShowStatus(2,dbFormatName(Form_Int(NomCode,0),Desc));
        end;

        If (LNom.NomCode<>Syss.NomCtrlCodes[ProfitBF]) then
        Begin
          TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);
          
          UCode:=LNom.NomCode;

          Set_ActualStatus;

          TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
        end;

        With LNom do
        Begin
          TbBalance:=TbBalance+Round_Up(LProfit_To_Date(NomType,FullNomKey(NomCode),0,150,99,Purch,Sales,Cleared,BOn),2);
        end;

      end; {If a non posting code}

      LStatus:=LFind_Rec(B_StepNext,Fnum,keypath,KeyS);

    end; {while..}

    UpdateProgress(TICount);

    If (ThreadRec^.THAbort) then
    Begin
      Write_PostLog('Check All G/L Actuals interrupted by user. Run again, or restore backup.',BOn);

      AddErrorLog('Check G/L Actuals interrupted by user. Run again, or restore backup.','',4);
    end
    else
    Begin
      If (ABS(TbBalance)>0.10) then
        Write_PostLog('After running Check All G/L Actuals, there is an imbalance of '+FormatBFloat(GenRealMask,TbBalance,BOff)+' within the G/L.',BOn)
      else
        Write_PostLog('After running Check All G/L Actuals, the G/L Balances.',BOff);
    end;

  end; {If In Nom}

end; {Proc..}



{ ============ Cleared Balance Checker =========== }

Procedure TCheckNom.Set_ClearedStatus;

Const
  Fnum       =  IDetailF;
  Keypath2   =  IDNomK;


Var

  KeyS,
  KeyChk  :  Str255;

  LAddr,
  TNCode  :  LongInt;

  LOk,
  Locked,
  Loop    :  Boolean;

  KLen    :  Integer;

  LVal    :  Real;
  PBal    :  Double;



Begin

  KLen:=0;


  TNCode:=0;

  PBal:=0;

  LVal:=0;

  LAddr:=0;

  With MTExLocal^ do
  Begin
    With LNom do
      ShowStatus(1,dbFormatName(Form_Int(NomCode,0),Desc));

    InitProgress(2);

    KeyS:=FullNomKey(LNom.NomCode);

    LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,NomCodeK,NomF,BOn,Locked);

    If (LOk) and (Locked) then
    Begin
      LGetRecAddr(NomF);

      ShowStatus(2,'Clearing current balance.');

      Reset_Cleared;


      UpdateProgress(1);


      KeyChk:=FullIdPostKey(UCode,0,0,0,0,0);


      KeyS:=KeyChk;

      KLen:=Succ(Sizeof(UCode));


      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath2,KeyS);


      ShowStatus(2,'Calculating new balance.');

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,KLen,BOn)) and (Not ThreadRec^.THAbort) do
      With LId do
      Begin

        If (Reconcile=ReconC) and (PostedRun>0) and (AfterPurge(LId.PYr,0)) then
        Begin

          LVal:=DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0);

          LPost_To_Nominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,CXrate,PBal,TNCode,UseORate);

          {$IFDEF PF_On}
           If (Syss.PostCCNom) and (Syss.UseCCDep) then
           Begin
             Loop:=BOff;

             Repeat
               If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
               Begin
                 LPost_To_CCNominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                   CXRate,PostCCKey(Loop,CCDep[Loop]),UseORate);

                 {* Post to combination *}

                 If (Syss.PostCCDCombo) then
                   LPost_To_CCNominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                   CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UseORate);

               end;

               Loop:=Not Loop;

             Until (Not Loop);
           end;

         {$ENDIF}


        end;

        If (ReconDate='') and (Reconcile<>ReconC) and (PostedRun>0) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum,BOn,Locked);

          If (LOk) and (Locked) then
          Begin

            LGetRecAddr(Fnum);

            ReconDate:=MaxUntilDate;

            LStatus:=LPut_Rec(Fnum,KeyPath2);

            Report_BError(Fnum,LStatus);

            LStatus:=LUnLockMLock(Fnum);
          end;

        end; {With..}

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath2,KeyS);

      end; {While..}

      Set_PayInClearedStatus;

      LStatus:=LUnLockMLock(NomF);
    end;

    UpdateProgress(2);

  end; {With..}

end; {Proc..}




{ ====== Function to set full NHist Key for Nom View ====== }


Function TCheckNom.Set_NVHist( NRec  :  NomViewRec;
                               Mode,
                               AutoPBF
                                     :  Boolean)  :  Str255;

Var
  IsCC   :  Boolean;
  NCode  :  Char;
  HYr    :  Byte;
  ComKey,
  CCKey  :  Str255;

Begin
  IsCC:=BOff;  HYr:=0;

  HYr:=GetLocalPr(0).CYr;

  {If (AutoPBF) then
    HYr:=AdjYr(HYr,BOff);}

  Case Mode of
    BOff  :  With NRec.NomViewLine do
             Begin
               NCode:=ViewType;


               Result:=FullNHistKey(NCode,PostNVIdx(NomViewNo,ABSViewIdx),0,HYr,1);
             end;

    BOn  :  With MTEXLocal^,NRec.NomViewLine do

            Begin
              If (LinkGL<>0) and LGetMainRecPos(NomF,FullNomKey(LinkGL)) then
              Begin
                If ((Trim(LinkCCDep[BOn])<>'') and (Trim(LinkCCDep[BOff])<>'')) or (Trim(LinkCCDep[BOn])<>'') then
                Begin
                  CCKey:=CalcCCDepKey(BOn,LinkCCDep);
                  IsCC:=BOn;
                end
                else
                  CCKey:=LinkCCDep[BOff];

                NCode:=LNom.NomType;

                {$IFDEF SOP}
                  If (IncCommit) then
                    ComKey:=CommitKey
                  else
                {$ENDIF}
                  ComKey:='';

                
                Result:=FullNHistKey(Ncode,ComKey+CalcCCKeyHistP(LNom.NomCode,IsCC,CCKey),0,HYr,1);
              end;


            end;
  end; {case..}


end; {Func..}

{ ========== Zero NomView Balance ========== }

Procedure TCheckNom.Reset_NomViewActual;



Const
  Fnum     =  NHistF;

  Keypath  =  NHK;



Var
  KeyS,
  KeyChk   :  Str255;

//  BalCFS,
//  BalCFP,
//  BalCFC,
//  BalCV1,
//  BalCV2,
//  BalCV3
//           :  Array[0..CurrencyType] of Double;


Begin
// MH 07/07/08: Removed as wasting 4k Stack
//  Blank(BalCFS,Sizeof(BalCFS));
//  Blank(BalCFP,Sizeof(BalCFP));
//  Blank(BalCFC,Sizeof(BalCFC));
//  Blank(BalCV1,Sizeof(BalCV1));
//  Blank(BalCV2,Sizeof(BalCV2));
//  Blank(BalCV3,Sizeof(BalCV3));

  With MTExLocal^,LNomView^.NomViewLine do
  Begin
    KeyChk:=ViewType+PostNVIdx(NomViewNo,ABSViewIdx);

    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Pred(Length(KeyChk)),BOn)) do
    With LNHist do
    Begin

      Sales:=0.0;
      Purchases:=0.0;

      Cleared:=0.0;
      Value1:=0.0;
      Value2:=0.0;
      Value3:=0.0;

      If (IncBudget) then
      Begin
        Budget:=0.0;
        RevisedBudget1:=0.0;
      end;

      LStatus:=LPut_Rec(Fnum,Keypath);

      LReport_BError(Fnum,LStatus);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

    end; {With..}

  end; {With..}


end; {Proc..}



 { ========== Procedure to reset all Headings prior to an update ======= }

 Procedure TCheckNom.Reset_ViewHistory;

 Const
   Fnum      =  NomViewF;
   Keypath   =  NVCodeK;


 Var
   KeyChk,
   KeyS      :  Str255;

   LOk,
   Locked    :  Boolean;

   Res,
   ItemCount :  LongInt;


 Begin
   {$IFDEF EXSQL}
     If SQLUtils.UsingSQLAlternateFuncs Then
     Begin
       If (tViewNo <> 0) then
         // Zero down specific Nominal View
         Res := ResetViewHistory(SetDrive, tViewNo, MTEXLocal^.ExClientID)
       Else
         // Zero down all Nominal Views
         Res := ResetViewHistory(SetDrive, 0, MTEXLocal^.ExClientID);
       If (Res < 0) Then
          MessageDlg ('TCheckNom.Reset_ViewHistory: ResetViewHistory failed for ' + IntToStr(tViewNo) + ' with an error ' + SQLUtils.LastSQLError,
                      mtError, [mbOK], 0);
     End // If SQLUtils.UsingSQLAlternateFuncs
     Else
   {$ENDIF}
     Begin
       KeyChk:=PartCCKey(NVRCode,NVVSCode);

       If (tViewNo<>0) then {* One view only *}
         KeyChk:=KeyChk+FullNomKey(tViewNo);

       KeyS:=KeyChk;

       ItemCount:=0;

       Locked:=BOff;

       With MTEXLocal^ do
       Begin
         LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

         While (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
         With LNomView^.NomViewLine do
         Begin
           Inc(ItemCount);

           UpdateProgress(ItemCount);


           Reset_NomViewActual;

           LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);
         end; {While..}
       end; {With.}
     End;
 end; {Proc..}


 {**$IFDEF NOTELCCODE}
 { ============ Procedure to Update all Parent with lower budget records  ============ }
 Procedure TCheckNom.Update_NomViewActual(LowKey,
                                          HiKey      :  Str255;
                                          PostView   :  NomViewRec;
                                          ProMode,
                                          AutoPBF    :  Boolean);

 Const
   Fnum     =  NHistF;
   Keypath  =  NHK;

 Var
   n,
   YTDType,
   Loop   :  Byte;

   CDpCode:  Str20;

   KeyChk,
   KeyHChk,
   KeyS,
   KeyHS  :  Str255;

   FoundOk,FLoop,
   BeenWarned,
   LOk,
   Locked :  Boolean;

   LowHist,
   GetHist,
   HedHist,
   HiHist :  HistoryRec;

   LastStatus
          :  Integer;

   TmpKPath,
   TmpStat
          :  Integer;

   TmpRecAddr
          :  LongInt;

   PBalBF :  Double;

   LUP    :  tPassDefType;
   {$IFDEF PERIODFIX}
     oUPCache : TUserPeriodCache;
   {$ENDIF}

   TreeNode : ^NomViewRec;
   TreeNodes : TList;
   iViewLine : SmallInt;

   Res : Integer;
Begin

  LastStatus:=0; Loop:=0; n:=0; PBalBF:=0;


  Locked:=BOff;

  Extract_NHistfromNKey(Lowkey,LowHist);

  //Extract_NHistfromNKey(Hikey,HiHist);

  LUP:=UserProfile^;
  {$IFDEF PERIODFIX}
    oUPCache := oUserPeriod.GetCache;
  {$ENDIF}

  With MTEXLocal^ do
  Begin
    TreeNodes := TList.Create;
    Try
      // Load the NomViewLine records into a list so that we can apply each history record to the
      // entire branch of the tree from leaf to root in one go instead of having to read each history
      // record for every node in the branch.
      GetMem(TreeNode, SizeOf(TreeNode^));
      TreeNode^ := PostView;
      TreeNodes.Add(TreeNode);

      LStatus := 0;
      LNomView^ := PostView;
      While (LStatus = 0) And (LNomView^.NomViewLine.ViewCat <> 0)  and (Not THreadRec^.THAbort) Do
      Begin
        KeyS := FullNVIdx(NVRCode, NVVSCode, LNomView^.NomViewLine.NomViewNo, LNomView^.NomViewLine.ViewCat, BOn);
        LStatus := LFind_Rec(B_GetEq, NomViewF, NVViewIDxK, KeyS);
        If (LStatus = 0) Then
        Begin
          GetMem(TreeNode, SizeOf(TreeNode^));
          TreeNode^ := LNomView^;
          TreeNodes.Add(TreeNode);
        End; // If (LStatus = 0)
      End; // While (LStatus = 0) And (LNomView^.NomViewLine.ViewCat <> 0)


      // Run through the History records
      KeyChk := LowHist.ExClass + LowHist.Code;
      KeyS := KeyChk;

      ForceYTNCF:=(LowHist.ExClass In YTDNCFSet); {* EL: Force YTD NCF from base hist record, not GL /Views rec as all set to 8 type *}

      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);
      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not THreadRec^.THAbort) do
      Begin
        If (THreadRec^.THAbort) And (Not BeenWarned) Then
        Begin
          ShowStatus(3,'Please Wait, finishing current actual.');
          BeenWarned:=BOn;
        End; // If (THreadRec^.THAbort) and (Not BeenWarned)

        // Make local copy of history record so the calls below don't overwrite it
        GetHist:=LNHist;

        {$IFDEF DBD}
          If ((GetHist.Purchases+GetHist.Sales)<>0.0) and (AutoPBF) then
            MessageBeep(0);
        {$ENDIF}

        // Save current position in HistF
        TmpKPath:=KeyPath;
        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        // Run through the NomViewLine records applying the History at each stage
        For iViewLine := 0 To (TreeNodes.Count - 1) Do
        Begin
          // Extract NomViewLine details from list and update loop variables accordingly
          TreeNode := TreeNodes[iViewLine];
          PostView := TreeNode^;

          FillChar(HiHist, SizeOf(HiHist), #0);
          Extract_NHistfromNKey(Set_NVHist(PostView,BOff,AutoPBF),HiHist);

          FLoop:=BOff;
          FoundOk:=BOff;
          If ((GetHist.Pr<>YTD) and (GetHist.Pr<>YTDNCF))  then {Only process non carry forward codes, as YTD will be updated automatically. Purge year not destroyed}
          Begin
            Repeat {Attempt to find immediate parent equivalent, if not create via fill}
              With HiHist do
                KeyHChk:=FullNHistKey(ExClass,Code,GetHist.Cr,GetHist.Yr,GetHist.Pr);

              KeyHS:=KeyHChk;

              LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyHS);

              If (Not LStatusOk) or (Not CheckKey(KeyHChk,KeyHS,Length(KeyHChk),BOn)) then
              Begin
                {$IFDEF PERIODFIX}
                oUserPeriod.SetPeriodYear(GetHist.Pr, GetHist.Yr);
                {$ELSE}
                With UserProfile^ do
                Begin
                  UCYr:=GetHist.Yr;
                  UCPr:=GetHist.Pr;
                end;
                {$ENDIF}

                {$IFDEF EXSQL}
                If SQLUtils.UsingSQLAlternateFuncs Then
                Begin
                  Res := FillBudget(SetDrive,             // CompanyPath: AnsiString;
                                    Ord(HiHist.ExClass),  // NType: Integer;
                                    HiHist.Code,          // Code: AnsiString;
                                    GetHist.Cr,           // Currency,
                                    GetLocalPr(0).Cyr,    // Year,
                                    GetHist.Pr,           // Period,
                                    Syss.PrinYr,          // PeriodInYear: Integer;
                                    True,                 // CalcPurgeOB,
                                    BOn,                  // Range: Boolean;
                                    0,                    // PPr2: Integer
                                    MTExLocal^.ExClientId);
                End // If SQLUtils.UsingSQLAltFuncs
                Else
                {$ENDIF}
                  LFillBudget(FNum,KeyPath,n,KeyHChk);
              end
              else
                FoundOk:=BOn;

              fLoop:=Not fLoop;

            Until (Not fLoop) or (FoundOk);
          end
          else
          Begin
            FoundOk:=AutoPBF;

            LNHist:=HiHist;
            LNHist.Yr:=GetHist.Yr;
            LNHist.Pr:=GetHist.Pr;
            LNHist.Cr:=GetHist.Cr;
          end;

          If (FoundOk) then
          Begin
            HedHist:=LNHist;

              LPost_To_Hist2(HedHist.ExClass,HedHist.Code,
                                     GetHist.Purchases,
                                     GetHist.Sales,
                                     GetHist.Cleared,
                                     GetHist.Value1,
                                     GetHist.Value2,
                                     HedHist.Cr,HedHist.Yr,HedHist.Pr,
                                     PBalBF);


            If (GetHist.ExClass In YTDSet+YTDNCFSet) and (Not AutoPBF) then {Process carry forward codes YTD, and future YTD}
            Begin
              If (GetHist.ExClass In YTDSet) and (Not ForceYTNCF) then
                YTDType:=YTD
              else
                YTDType:=YTDNCF;

              If (YTDType=YTD) then
                LPost_To_CYTDHist2(HedHist.ExClass,HedHist.Code,
                                   GetHist.Purchases,
                                   GetHist.Sales,
                                   GetHist.Cleared,
                                   GetHist.Value1,
                                   GetHist.Value2,
                                   HedHist.Cr,HedHist.Yr,YTDType)
              else
                LPost_To_Hist2(HedHist.ExClass,HedHist.Code,
                               GetHist.Purchases,
                               GetHist.Sales,
                               GetHist.Cleared,
                               GetHist.Value1,
                               GetHist.Value2,
                               HedHist.Cr,HedHist.Yr,YTDType,
                               PBalBF);
            end;

            If (PostView.NomVieWLine.IncBudget) then
            Begin
              With HedHist do
                KeyHChk:=FullNHistKey(ExClass,Code,Cr,Yr,Pr);

              KeyHS:=KeyHChk;

              LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyHS);

              If (StatusOk) then
              With LNHist do
              Begin
                Budget:=Budget+GetHist.Budget;
                RevisedBudget1:=RevisedBudget1+GetHist.RevisedBudget1;

                LStatus:=LPut_Rec(Fnum,Keypath);

                LReport_BError(Fnum,LStatus);

              end;

            end;
          end; {If FoundOk..}
        End; // For iViewLine

        // Restore the original position in the HistF table and move to the next history record to copy
        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);
      End; // While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not THreadRec^.THAbort)

      LReport_BError(Fnum,LastStatus);
    Finally
      While (TreeNodes.Count > 0) Do
      Begin
        TreeNode := TreeNodes[0];
        FreeMem (TreeNode, SizeOf(TreeNode^));
        TreeNodes.Delete(0);
      End; // While (TreeNodes.Count > 0)
      TreeNodes.Free;
      ForceYTNCF:=BOff;
    End; // Try..Finally
  end; {With..}

  UserProfile^:=LUP;
  {$IFDEF PERIODFIX}
    oUserPeriod.RestoreCache(oUPCache);
  {$ENDIF}

  (*
  With PostView.NomViewLine do
  Begin
    If (ViewCat<>0) then
    With MTExLocal^ do
    Begin
      KeyS:=FullNVIdx(NVRCode,NVVSCode,NomViewNo,ViewCat,BOn);

      LStatus:=LFind_Rec(B_GetEq,NomViewF,NVViewIDxK,KeyS);

      If (LStatusOk) then
      Begin
        KeyS:=Set_NVHist(LNomView^,BOff,AutoPBF);

        Update_NomViewActual(LowKey,KeyS,LNomView^,ProMode,AutoPBF);
      end;

    end;
  end;
  *)
end; {Proc..}

{**..$ENDIF}

(***** MH 07/07/08: Modified to cache the NomViewLine records instead of calling itself recursively *}
 Procedure TCheckNom.Update_NomViewActual(LowKey,
                                          HiKey      :  Str255;
                                          PostView   :  NomViewRec;
                                          ProMode,
                                          AutoPBF    :  Boolean);

 Const
   Fnum     =  NHistF;
   Keypath  =  NHK;

 Var
   n,
   YTDType,
   Loop   :  Byte;

   CDpCode:  Str20;

   KeyChk,
   KeyHChk,
   KeyS,
   KeyHS  :  Str255;

   FoundOk,FLoop,
   BeenWarned,
   LOk,
   Locked :  Boolean;

   LowHist,
   GetHist,
   HedHist,
   HiHist :  HistoryRec;

   LastStatus
          :  Integer;

   TmpKPath,
   TmpStat
          :  Integer;

   TmpRecAddr
          :  LongInt;

   PBalBF :  Double;

   LUP    :  tPassDefType;




Begin

  LastStatus:=0; Loop:=0; n:=0; PBalBF:=0;


  Locked:=BOff;

  Extract_NHistfromNKey(Lowkey,LowHist);

  Extract_NHistfromNKey(Hikey,HiHist);

  LUP:=UserProfile^;

  With MTEXLocal^ do
  Begin
    With LowHist do
      KeyChk:=ExClass+Code;

    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not THreadRec^.THAbort) do
    Begin
      Begin

        If (THreadRec^.THAbort) and (Not BeenWarned) then
        Begin
          ShowStatus(3,'Please Wait, finishing current actual.');

          BeenWarned:=BOn;

        end;

        GetHist:=LNHist;


        {$IFDEF DBD}
          If ((GetHist.Purchases+GetHist.Sales)<>0.0) and (AutoPBF) then
            MessageBeep(0);
        {$ENDIF}


        FLoop:=BOff; FoundOk:=BOff;

        TmpKPath:=KeyPath;

        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        ForceYTNCF:=(LowHist.ExClass In YTDNCFSet); {* EL: Force YTD NCF from base hist record, not GL /Views rec as all set to 8 type *}

        If ((GetHist.Pr<>YTD) and (GetHist.Pr<>YTDNCF))  then {Only process non carry forward codes, as YTD will be updated automatically. Purge year not destroyed}
        Begin
          Repeat {Attempt to find immediate parent equivalent, if not create via fill}
            With HiHist do
              KeyHChk:=FullNHistKey(ExClass,Code,GetHist.Cr,GetHist.Yr,GetHist.Pr);

            KeyHS:=KeyHChk;

            LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyHS);

            If (Not LStatusOk) or (Not CheckKey(KeyHChk,KeyHS,Length(KeyHChk),BOn)) then
            Begin
              With UserProfile^ do
              Begin
                UCYr:=GetHist.Yr;
                UCPr:=GetHist.Pr;
              end;

              LFillBudget(FNum,KeyPath,n,KeyHChk);

            end
            else
              FoundOk:=BOn;

            fLoop:=Not fLoop;

          Until (Not fLoop) or (FoundOk);
        end
        else
        Begin
          FoundOk:=AutoPBF;

          LNHist:=HiHist;
          LNHist.Yr:=GetHist.Yr;
          LNHist.Pr:=GetHist.Pr;
          LNHist.Cr:=GetHist.Cr;
        end;

        If (FoundOk) then
        Begin
          HedHist:=LNHist;

            LPost_To_Hist2(HedHist.ExClass,HedHist.Code,
                                   GetHist.Purchases,
                                   GetHist.Sales,
                                   GetHist.Cleared,
                                   GetHist.Value1,
                                   GetHist.Value2,
                                   HedHist.Cr,HedHist.Yr,HedHist.Pr,
                                   PBalBF);


          If (GetHist.ExClass In YTDSet+YTDNCFSet) and (Not AutoPBF) then {Process carry forward codes YTD, and future YTD}
          Begin
            If (GetHist.ExClass In YTDSet) and (Not ForceYTNCF) then
              YTDType:=YTD
            else
              YTDType:=YTDNCF;

            LPost_To_CYTDHist2(HedHist.ExClass,HedHist.Code,
                               GetHist.Purchases,
                               GetHist.Sales,
                               GetHist.Cleared,
                               GetHist.Value1,
                               GetHist.Value2,
                               HedHist.Cr,HedHist.Yr,YTDType);
          end;

          If (PostView.NomVieWLine.IncBudget) then
          Begin
            With HedHist do
              KeyHChk:=FullNHistKey(ExClass,Code,Cr,Yr,Pr);

            KeyHS:=KeyHChk;

            LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyHS);

            If (StatusOk) then
            With LNHist do
            Begin
              Budget:=Budget+GetHist.Budget;
              Budget2:=Budget2+GetHist.Budget2;

              LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

            end;

          end;
        end; {If FoundOk..}

        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
      end; {If wrong type}

      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

    end; {While..}


    LReport_BError(Fnum,LastStatus);

  end; {With..}

  UserProfile^:=LUP;

  With PostView.NomViewLine do
  Begin
    If (ViewCat<>0) then
    With MTExLocal^ do
    Begin
      KeyS:=FullNVIdx(NVRCode,NVVSCode,NomViewNo,ViewCat,BOn);

      LStatus:=LFind_Rec(B_GetEq,NomViewF,NVViewIDxK,KeyS);

      If (LStatusOk) then
      Begin
        KeyS:=Set_NVHist(LNomView^,BOff,AutoPBF);

        Update_NomViewActual(LowKey,KeyS,LNomView^,ProMode,AutoPBF);
      end;

    end;
  end;
end; {Proc..}
*****)

 { ============ Procedure to Update all Levels with unposted records  ============ }

 Procedure TCheckNom.Update_NomViewUnposted(PostView   :  NomViewRec;
                                            Level      :  LongInt);

 Const
   Fnum2     =  NHistF;
   Keypath2  =  NHK;
   Fnum      =  IdetailF;
   Keypath   =  IdRunK;

 Var
   n,
   HistCr,
   YTDType,
   UOR,
   Loop   :  Byte;

   KeyChk,
   KeyHChk,
   KeyS,
   KeyHS  :  Str255;

   FoundOk,FLoop,
   AutoLZ,
   FiltOk,
   BeenWarned,
   LOk,
   Locked :  Boolean;

   HedHist:  HistoryRec;

   LastStatus
          :  Integer;

   TmpKPath,
   TmpStat
          :  Integer;

   CrDr      :  DrCrType;

   TmpRecAddr
          :  LongInt;

   CTot,
   PBalBF :  Double;

   LUP    :  tPassDefType;
   {$IFDEF PERIODFIX}
     oUPCache : TUserPeriodCache;
   {$ENDIF}

Begin

  LastStatus:=0; Loop:=0; n:=0; PBalBF:=0.0;


  Locked:=BOff;  CTot:=0.0; UOR:=0; FiltOk:=BOff;

  {$IFDEF MC_On}
    AutoLZ:=BOff;
  {$ELSE}
    AutoLZ:=BOn;

  {$ENDIF}

  LUP:=UserProfile^;
  {$IFDEF PERIODFIX}
    oUPCache := oUserPeriod.GetCache;
  {$ENDIF}

  With MTEXLocal^ do
  Begin
    KeyChk:=FullIdKey(0,PostView.NomViewLine.LinkGL);

    KeyS:=KeyChk;

    If (Level=0) then
      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS)
    else
      LStatus:=0;

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not THreadRec^.THAbort) do
    Begin
      With LId do
      Begin

        If (THreadRec^.THAbort) and (Not BeenWarned) then
        Begin
          ShowStatus(3,'Please Wait, finishing current Line.');

          BeenWarned:=BOn;

        end;

        CTot:=DetLTotal(LId,BOn,BOff,0.0);

        With PostView.NomViewLine do
          If (Level=0) then
            FiltOk:=(CheckKey(LinkCCDep[BOn],CCDep[BOn],Length(LinkCCDep[BOn]),BOff) and CheckKey(LinkCCDep[BOn],CCDep[BOn],Length(LinkCCDep[BOn]),BOff)) and (IdDocHed in DocAllocSet+DirectSet+NomSplit)
          else
            FiltOk:=BOn;

        {$IFDEF DBD} 
        {$ENDIF}


        FLoop:=BOff; 

        TmpKPath:=KeyPath;

        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        HistCR:=Currency;

        ForceYTNCF:=(PostView.NomViewLine.LinkType In YTDNCFSet);

        Repeat
          FoundOk:=BOff;

          If (CTot<>0.0)  and (FiltOk) then {Only process Value lines}
          Begin
            Repeat {Attempt to find immediate parent equivalent, if not create via fill}
              With PostView.NomViewLine do
                KeyHChk:=FullNHistKey(ViewType,PostNVIdx(NomViewNo,ABSViewIdx),HistCr,PYr,PPr);

              KeyHS:=KeyHChk;

              LStatus:=LFind_Rec(B_GetEq,Fnum2,Keypath2,KeyHS);

              If (Not LStatusOk) or (Not CheckKey(KeyHChk,KeyHS,Length(KeyHChk),BOn)) then
              Begin
                {$IFDEF PERIODFIX}
                oUserPeriod.SetPeriodYear(PPr, PYr);
                {$ELSE}
                With UserProfile^ do
                Begin
                  UCYr:=PYr;
                  UCPr:=PPr;
                end;
                {$ENDIF}

                LFillBudget(FNum2,KeyPath2,n,KeyHChk);

              end
              else
                FoundOk:=BOn;

              fLoop:=Not fLoop;

            Until (Not fLoop) or (FoundOk);
          end
          else
          Begin
            FoundOk:=BOff;

          end;

          If (FoundOk) then
          Begin
            HedHist:=LNHist;

            ShowDrCr(Ctot,CrDr);

            LPost_To_Hist2(HedHist.ExClass,HedHist.Code,
                           CrDr[BOff],
                           CrDr[BOn],
                           0,
                           0,
                           0,
                           HedHist.Cr,HedHist.Yr,HedHist.Pr,
                                     PBalBF);


            If (HedHist.ExClass In YTDSet+YTDNCFSet) {and (Not AutoPBF)} then {Process carry forward codes YTD, and future YTD}
            Begin
              If (HedHist.ExClass In YTDSet) and (Not ForceYTNCF) then
                YTDType:=YTD
              else
                YTDType:=YTDNCF;

              LPost_To_CYTDHist2(HedHist.ExClass,HedHist.Code,
                                      CrDr[BOff],
                                      CrDr[BOn],
                                      0,
                                      0,
                                      0,
                                      HedHist.Cr,HedHist.Yr,YTDType);
            end;



          end; {If FoundOk..}

          HistCR:=0;

          AutoLZ:=Not AutoLZ;

          {$IFDEF MC_On}

            If (AutoLZ) then
            Begin
              UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

              CTot:=Conv_TCurr(CTot,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

            end;
        {$ENDIF}


        Until (Not AutoLZ) or (THreadRec^.THAbort);

        With PostView.NomViewLine do
        Begin
          If (ViewCat<>0) and (FoundOk) then
          With MTExLocal^ do
          Begin
            KeyS:=FullNVIdx(NVRCode,NVVSCode,NomViewNo,ViewCat,BOn);

            LStatus:=LFind_Rec(B_GetEq,NomViewF,NVViewIDxK,KeyS);

            If (LStatusOk) then
            Begin

              Update_NomViewUnposted(LNomView^,Succ(Level));
            end;

          end;
        end;


        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
      end; {If wrong type}

      If (Level=0) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS)
      else
        LStatus:=9;

    end; {While..}


    LReport_BError(Fnum,LastStatus);

    ForceYTNCF:=BOff;

  end; {With..}

  UserProfile^:=LUP;
  {$IFDEF PERIODFIX}
    oUserPeriod.RestoreCache(oUPCache);
  {$ENDIF}

  
end; {Proc..}


{ == Function to Return View Ctrl Record based on view number == }

Function TCheckNom.LGet_GLViewCtrlRec(VN  :  LongInt)  :  ViewCtrlType;

Const
  Fnum    =  NomViewF;
  Keypath =  NVCodeK;

Var
  KeyS  :  Str255;

Begin  With MTExLocal^ do
  Begin
    KeyS:=FullNVIdx(NVRCode,NVCSCode,0,VN,BOn);

    LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyS);

    If (LStatusOk) then
    Begin
      Result:=LNomView^.ViewCtrl;
      Result.LoadedOk:=BOn;
    end
    else
      Blank(Result,Sizeof(Result));
  end; {With..}
end;


{ === Procedure to Scan all low level nom/stock types and update upper levels with actual totals === }

Procedure TCheckNom.Update_NomViewActuals(ProMode    :  Boolean);


Const
  Fnum1    =  NomViewF;
  Keypath1 =  NVViewIdxK;




Var
  KeyS,
  KeyChk,
  KeyCat,
  LowKey,
  HiKey    :  Str255;

  RecAddr  :  LongInt;

  AutoPBF,
  Mode,
  LoopEnd,
  NoAbort  :  Boolean;

  mbRet    :  Word;

  Fnum,
  Keypath,
  TmpKPath,
  TmpStat
           :  Integer;

  LastViewNo,
  ItemCount,
  TmpRecAddr
           :  LongInt;

  OrigView :  NomViewRec;



Begin
  Send_UpdateList(70);



  {$B-}

  With MTExLocal^ do
  Begin

  {$B+}

    ItemCount:=0;

    LastViewNo:=0;

    KeyS:='';

    LowKey:='';

    HiKey:='';

    LoopEnd:=BOff;  AutoPBF:=BOff;

    Fnum:=Fnum1;

    Keypath:=Keypath1;

    TICount:=Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId);

    InitProgress(TICount*2);

    ShowStatus(2,'Resetting existing totals.');

    Reset_ViewHistory;

    ItemCount:=TICount;

    ShowStatus(1,'Processing:-');

    KeyChk:=PartCCKey(NVRCode,NVVSCode);

    If (tViewNo<>0) then {* One view only *}
    Begin
      KeyChk:=KeyChk+FullNomKey(tViewNo);
    end;

    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);


    While (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With LNomView^.NomViewLine do
    Begin
      OrigView:=LNomView^;

      Inc(ItemCount);

      UpdateProgress(ItemCount);

      If (ViewType<>ViewHedCode) then
      Begin


        ShowStatus(2,dbFormatName(ViewCode,Desc));

        TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        AutoPBF:=(LNomView^.NomViewLine.LinkGL=Syss.NomCtrlCodes[ProfitBF]) and (ProMode);

        {* Link to G/L + then link to nom view *}
        LowKey:=Set_NVHist(LNomView^,BOn,AutoPBF);


        HiKey:=Set_NVHist(LNomView^,BOff,AutoPBF);


        If (OrigView.NomViewLine.IncUnposted In [0,2]) then
          Update_NomViewActual(LowKey,HiKey,LNomView^,ProMode,AutoPBF);

        If (OrigView.NomViewLine.IncUnposted In [1,2]) and (OrigView.NomViewLine.LinkGL<>0) then {Include unposted items as well}
          Update_NomViewUnPosted(OrigView,0);



        If (LastViewNo<>LNomView^.NomViewLine.NomViewNo) then
        Begin
          LastViewNo:=LNomView^.NomViewLine.NomViewNo;

          With LGet_GLViewCtrlRec(LastViewNo) do
          If (LoadedOk) then {Update last setting}
          Begin
            LNomView^.ViewCtrl.LastUpdate:=Today;
            LNomView^.ViewCtrl.LastPeriod:=Syss.CPr;
            LNomView^.ViewCtrl.LastYear:=Syss.CYr;

            LNomView^.ViewCtrl.LastPRunNo:=Pred(LGetNextCount(RUN,BOff,BOff,0));

            If (LNomView^.ViewCtrl.LastPRunNo<0) then
              LNomView^.ViewCtrl.LastPRunNo:=0;

            LNomView^.ViewCtrl.LastOpo:=EntryRec^.Login;

            LStatus:=LPut_Rec(Fnum,Keypath);

            LReport_BError(Fnum,LStatus);


          end;
        end;

        TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


      end; {If a non heading variable}

      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

    end; {while..}

    UpdateProgress(TICount*2);

    If (ThreadRec^.THAbort) then
    Begin
      Write_PostLog('Check G/L View Actuals interrupted by user. Run again, or restore backup.',BOn);

      AddErrorLog('Check G/L View Actuals interrupted by user. Run again, or restore backup.','',4);
    end;

  end; {If In Nom/Stock}

  Send_UpdateList(72);



end; {Proc..}



Procedure TCheckNom.Process;
Begin
  InMainThread:=BOn;


  Inherited Process;

  ShowStatus(0,'Recalculate General Ledger balance.');

  Case CheckActMode of
    1  :  Set_ActualStatus;

    2,20
       :  Update_GlobalActuals(BOn);

    3  :  Set_AllActualsStatus;

    {$IFDEF JC}
      5,7,23
       :  Update_JobGlobalActuals;
    {$ENDIF}

    6  :  Update_NomViewActuals(BOn);

    8 : CalcNomYTD;

    9 : CalcAllNomYTD;

    else  Set_ClearedStatus;

  end; {Case..}
end;


Procedure TCheckNom.Finish;
Begin
  Inherited Finish;

  If (Not (CheckActMode In [0,6])) then
  Begin
    PostUnLock(0);

    {$IFDEF Rp}
      {$IFDEF FRM}
         If (Assigned(PostLog)) then
           PostLog.PrintLog(PostRepCtrl,'Recalculate General Ledger balance log.');

      {$ENDIF}
    {$ENDIF}

  end
  else {Unlock posting ledger}
    Send_UpdateList(8);

  {Overridable method}

  InMainThread:=BOff;

end;



Function TCheckNom.Start(NNom     :   NominalRec;
                         LCAMode  :   Byte)  :  Boolean;

Const
  Clearwhich  :  Array[0..9] of Str20 = ('the Cleared','the Actual','the G/L Heading','every Actual','','the Job Tree Group','the G/L views','','the Cumulative / YTD','the Cumulative / YTD');


Var
  mbRet  :  Word;
  KeyS   :  Str255;

  //PR: 08/04/2014 ABSEXCH-15270
  PurgeMbRet : Word;

  LProcessLockType : TProcessLockType;

Begin
  UCode:=NNom.NomCode;
  CheckActMode:=LCAMode;

  Set_BackThreadMVisible(BOn);

  Result:=BOn;

  mbRet:=mrOK;



  If (Result) then
  Begin
    {$B-}
    If (CheckActMode=1) and (UCode=Syss.NomCtrlCodes[ProfitBF]) then
    Begin
    {$B+}
      CustomDlg(Application.MainForm,'Warning!','Check Actual balance',
                             'You are attempting to run Check on the Actual balance for the Automatic Profit Brought Forward.'+#13+#13+
                             'This is a system generated balance which cannot be recalculated using Check.',
                             mtWarning,
                             [mbOK]);

    end
    else
    Begin

      If (CheckActMode In [2,5]) then
      Begin
        mbRet:=MessageDlg('Please confirm you wish to re-calculate '+Clearwhich[CheckActMode]+' Balance',mtConfirmation,[mbYes,mbNo],0);

        //PR: 08/04/2014 ABSEXCH-15270 Add check that we said yes to dialog
        If (mbRet = mrYes) and (Syss.AuditYr<>0) and (SBSIn) then
        Begin
          PurgeMbRet:=CustomDlg(Application.MainForm,'Warning!','This data has been purged',
                 'This data contains purged year history. Normally, the purged year totals are not recalculated since they are assumed correct, however if '+
                 'the problem you are attempting to correct lies within the purged year, check will not correct the problem.'+#13+
                  'Do you wish to re-calculate the purged year balances as part of this check?',mtConfirmation,[mbYes,mbNo]);

          If (PurgeMbRet = mrOk) then
            CheckActMode:=(CheckActMode+18);

        end;
      end
      else
        If (not(CheckActMode in [7,9])) then
          mbRet:=MessageDlg('Please confirm you wish to re-calculate '+Clearwhich[CheckActMode]+' Balance',mtConfirmation,[mbYes,mbNo],0)
        else if (CheckActMode=9) then
          mbRet:=MessageDlg('Please confirm you wish to re-calculate '+Clearwhich[CheckActMode]+' Balances',mtConfirmation,[mbYes,mbNo],0)
        else
          mbRet:=mrYes;

    end;
  end;


  Result:=(mbRet=mrYes);

  Set_BackThreadMVisible(BOff);

  if Result then
  begin
     //PR: 23/05/2017 ABSEXCH-18683 v2017 R1 Set lock type
    Case LCAMode of
      2,
      3 : LProcessLockType := plCheckGLTotals;
      5 : LProcessLockType := plCheckJobs;
      6 : LProcessLockType := plUpdateGLViews;
      else
        LProcessLockType := plNone;
    end; //case

    Result := GetProcessLock(LProcessLockType);
    if Result then
      ProcessLockType := LProcessLockType;
  end;

  If (Result) then
  Begin
    {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
    begin
      // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
      if (not Assigned(LPostLocal)) then
        Result := Create_LocalThreadFiles;

      If (Result) then
        MTExLocal := LPostLocal;

    end
    else
    {$ENDIF}
    begin
      If (Not Assigned(PostExLocal)) then { Open up files here }
        Result:=Create_ThreadFiles;

      If (Result) then
        MTExLocal:=PostExLocal;

    end;

    If (Result) then
    Begin
//      MTExLocal:=PostExLocal;

      MTExLocal^.LNom:=NNom;
    end;

    If (Not (CheckActMode In [0,6])) then
    Begin
      Result:=PostLockCtrl(0);
    end;
  end;

  {$IFDEF EXSQL}
  if Result and SQLUtils.UsingSQL then
  begin
    MTExLocal^.Close_Files;
    CloseClientIdSession(MTExLocal^.ExClientID, False);
  end;
  {$ENDIF}

end;


Procedure AddCheckNom2Thread(AOwner   :  TObject;
                             ANom     :  NominalRec;
                             AJob     :  JobRecType;
                             LCAM     :  Byte);




Var
  LCheck_Nom :  ^TCheckNom;

Begin

  If (Create_BackThread) then
  Begin
    New(LCheck_Nom,Create(AOwner));

    try
      With LCheck_Nom^ do
      Begin
        If (Start(ANom,LCAM)) and (Create_BackThread) then
        Begin
          If (LCAM=7) then
            DelJobR:=AJob
          else
            If (LCAM=6) then
            begin
              tViewNo:=ANom.CarryF;

            end;

          With BackThread do
            AddTask(LCheck_Nom,'Check G/L '+Form_Int(ANom.NomCode,0));
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LCheck_Nom,Destroy);
        end;
      end; {with..}

    except
      Dispose(LCheck_Nom,Destroy);

    end; {try..}
  end; {If process got ok..}

end;

//AP: 29/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
procedure AddCheckAllNom2Thread(AOwner: TObject);
Var
  LCheck_Nom :  ^TCheckNom;
  BlankRec : NominalRec;
begin
  If (Create_BackThread) then
  Begin
    New(LCheck_Nom,Create(AOwner));
    Blank(BlankRec,Sizeof(BlankRec));

    FPr := Syss.CPr;
    FYr := Syss.CYr;

    try
      With LCheck_Nom^ do
      Begin
        If (Start(BlankRec,9)) and (Create_BackThread) then
        Begin
          With BackThread do
            AddTask(LCheck_Nom,'Check All G/L...');
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LCheck_Nom,Destroy);
        end;
      end;

    except
      Dispose(LCheck_Nom,Destroy);

    end;
  end;
end;

//AP: 28/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
Procedure TCheckNom.CalcNomYTD;
Const
  Fnum     =  NomF;
  Keypath  =  NomCodeK;
var
  FoundOk:  Boolean;
  KeyS:  Str255;
  LOk,
  Locked,
  BeenWarned: Boolean;
begin
  FPr := Syss.CPr;
  FYr := Syss.CYr;

  KeyS := '';

  With MTExLocal^ do
  begin
    With LNom do
      ShowStatus(1,dbFormatName(Form_Int(NomCode,0),Desc));

    InitProgress(2);

    KeyS:=FullNomKey(LNom.NomCode);

    LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked);

    If (LOk) and (Not ThreadRec^.THAbort) then
    begin
      LGetRecAddr(Fnum);

      If (THreadRec^.THAbort) and (Not BeenWarned) then
      Begin
        ShowStatus(2,'Clearing current balance.');
        BeenWarned:=BOn;
      end;

      ResetGLCleared;

      UpdateProgress(2);
    end;
  end;
end;

//AP: 29/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
Procedure TCheckNom.CalcAllNomYTD;
Const
  Fnum     =  NomF;
  Keypath  =  NomCodeK;
var
  FoundOk:  Boolean;
  KeyS,
  KeyChk:  Str255;
  ItemCount: Integer;
  BeenWarned: Boolean;

begin
  KeyS := '';
  ItemCount := 0;

  ShowStatus(2,'Clearing All G/L Cumulative Balance.');

  With MTExLocal^ do
  begin

    InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

    LStatus:=LFind_Rec(B_GetFirst,Fnum,KeyPath,KeyS);

    while (LStatus=0) and (Not ThreadRec^.THAbort) do
    begin
      If (THreadRec^.THAbort) and (Not BeenWarned) then
      Begin
        ShowStatus(3,'Please Wait, finishing current nominal.');
        BeenWarned:=BOn;
      end;

      if (LNom.NomType in ['A','B','C']) then
      begin
        ResetGLCleared;
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      Inc(ItemCount);
      UpdateProgress(ItemCount);
    end;
  end;

end;

//AP: 28/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
Procedure TCheckNom.ResetGLCleared;
Const
  Fnum     =  NHistF;
  Keypath  =  NHK;
Var
  KeyS,
  KeyChk:  Str255;
  BalCF:  Double;
  BackYr,
  Cn:  Byte;

  procedure CheckOnlyYTDCumulative;
  begin
    BackYr:=FYr-2;

    With MTExLocal^,LNom do
    begin
      KeyChk:=FullNHistKey(NomType,FullNomKey(NomCode),Cn,BackYr,255);  
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      if (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
      With LNHist do
      Begin
        Cleared:= (Purchases-Sales);
        BalCF:= Cleared;
        LStatus:=LPut_Rec(Fnum,Keypath); 
        LReport_BError(Fnum,LStatus);
      end;
    end;
  end;

  procedure CheckAllPeriodCleared;
  var
    n: Byte;
  begin
    BackYr:=FYr-1;

    With MTExLocal^,LNom do
    begin
      For n:=1 to Syss.PrInYr do
      begin                                                      
        KeyChk:=FullNHistKey(NomType,FullNomKey(NomCode),Cn,BackYr,n);
        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        if (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
        begin
          With LNHist do
          Begin
            Cleared:= (Purchases-Sales);
            BalCF:= BalCF + Cleared;
            LStatus:=LPut_Rec(Fnum,Keypath);  
            LReport_BError(Fnum,LStatus);
          end;
        end; 
      end;

      KeyChk:=FullNHistKey(NomType,FullNomKey(NomCode),Cn,BackYr,255);
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      if (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
      With LNHist do
      begin
        Cleared:=BalCF;
        LStatus:=LPut_Rec(Fnum,Keypath);
        LReport_BError(Fnum,LStatus);
      end;
    end;
  end;

Begin
  {$IFDEF MC_On}
  For  Cn :=0 to CurrencyType do
  {$ELSE}
  Cn:=0;
  {$ENDIF}
  begin
    if (Trim(SyssCurr.Currencies[Cn].Desc) <> '') then
    begin
      BalCF:=0.0;
      CheckOnlyYTDCumulative;
      CheckAllPeriodCleared;
    end
    {$IFDEF MC_On}
    else
      Break;
    {$ENDIF}
  end;
end; {Proc..}

Function Confirm_ChangeCode(LStock    :  StockRec;
                            NS        :  Str20;
                            AOwner    :  TForm)  :  Boolean;

Var
  MoveRec  :  MoveRepPtr;
  mbRet    :  Word;
  WMsg     :  AnsiString;

Begin
  New(MoveRec);


  Result:=BOff;

  try
    FillChar(MoveRec^,Sizeof(MoveRec^),0);

    With MoveRec^, LStock do
    Begin
      MoveMode:=4;

      MoveSCode:=StockCode;
      NewSCode:=NS;
      MoveStk:=LStock;

      Set_BackThreadMVisible(BOn);                        

      WMsg:=ConCat('You are about to change Stock Code ',dbFormatName(LStock.StockCode,LStock.Desc[1]),
                   ' to Stock Code ',Trim(NS),#13,#13);
      WMsg:=ConCat(WMsg,'This operation should be performed with all other users logged out.',#13,#13,'A backup ',
            'MUST be taken since the integrity of the Stock Tree will be damaged should the change fail.',#13,#13,
            'Do you wish to continue?');

      mbRet:=MovCustomDlg(Application.MainForm,'WARNING','Stock Code Renumber',WMsg,mtWarning,[mbYes,mbNo]);

      Set_BackThreadMVisible(BOff);

      Result:=(mbRet=mrOk);

      if Result then
        Result := GetProcessLock(plRenameStock);

      If (Result) then
        Result:=AddMove2Thread(AOwner,MoveRec);

    end; {With..}
  finally
    Dispose(MoveRec);

   end;
end;


Function StockCodeChange(LStock    :  StockRec;
                       NS        :  Str255;
                       AOwner    :  TForm)  :  Boolean;

Begin
  Result:=Confirm_ChangeCode(LStock,NS,AOwner);
end;


Function Confirm_ChangeAccCode(LCust    :  CustRec;
                               NS        :  Str20;
                               AOwner    :  TForm;
                               const oContactsManager
                                         : TContactsManager)  :  Boolean;


Var
  MoveRec  :  MoveRepPtr;
  mbRet    :  Word;
  WMsg     :  AnsiString;

Begin
  New(MoveRec);


  Result:=BOff;

  try
    FillChar(MoveRec^,Sizeof(MoveRec^),0);

    With MoveRec^, LCust do
    Begin
      MoveMode:=40;

      MoveSCode:=CustCode;
      NewSCode:=NS;
      MoveCust:=LCust;
      CustMode:=IsACust(CustSupp);

      Set_BackThreadMVisible(BOn);

      WMsg:=ConCat('You are about to change Account Code ',dbFormatName(LCust.CustCode,LCust.Company),
                   ' to Account Code ',Trim(NS),#13,#13);
      WMsg:=ConCat(WMsg,'This operation should be performed with all other users logged out.',#13,#13,'A backup ',
            'MUST be taken since the integrity of the Account Ledger will be damaged should the change fail.',#13,#13,
            'Do you wish to continue?');

      mbRet:=MovCustomDlg(Application.MainForm,'Warning','Account Code Renumber',WMsg,mtWarning,[mbYes,mbNo]);

      Set_BackThreadMVisible(BOff);

      Result:=(mbRet=mrOk);

      if Result then
        Result := GetProcessLock(plRenameAccount);

      if Result and Assigned(oContactsManager) then
        Result := oContactsManager.ChangeAccountCode(MoveSCode, NewSCode);

      If (Result) then
        Result:=AddMove2Thread(AOwner,MoveRec);

    end; {With..}
  finally
    Dispose(MoveRec);

   end;
end;


Function AccountCodeChange(LCust    :  CustRec;
                           NS       :  Str255;
                           AOwner   :  TForm;
                           const oContactsManager
                                    : TContactsManager)  :  Boolean;

Begin
  Result:=Confirm_ChangeAccCode(LCust,NS,AOwner, oContactsManager);
end;



Procedure Warn_BadVersion(IsMC  :  Boolean);

Const
  TypeMess  :  Array[BOff..BOn] of Str20 = ('single','multi');

Var
  WMsg     :  AnsiString;
  CRLF     :  Str5;


Begin
  {$IFNDEF RW} { HM 26/01/99: Added to stop incorrect error message during Win RW startup }
  CRLF:=#13+#10;

  WMsg:=ConCat('This is a '+TypeMess[IsMC]+' currency version.',CRLF,
               'The system is attempting to access '+TypeMess[Not IsMc]+' currency data.',CRLF,
               'Data corruption will occur if data is added or amended with this version.',CRLF,
               'Consult your supplier to correct this problem immediately!');

  CustomDlg(Application.MainForm,'WARNING!','Incorrect Program Version',
                             WMsg,
                             mtError,
                             [mbOk]);

  AddErrorLog('Incorrect Program Version',WMsg,4);
  {$ENDIF}
end;

{$IFDEF JC}
//PR 07/04/2014 ABSEXCH-13783 Function to get correct HistFolio for a given analysis code/parent job code
function TCheckNom.GetHistFolioForParent(const JobCode,
  ParentCode: string; JobHistFolio: Integer): longint;
const
  PFix = 'JB'; //prefix & subtype for Job Analysis Budget records

type
  // Record to cache found Parent HistFolio numbers to improve performance
  PHistFolioRec = ^THistFolioRec;
  THistFolioRec = Record
    hfJobCode          : String[JobKeyLen];
    hfParentCode       : String[JobKeyLen];
    hfJobHistFolio     : longint;
    hfParentHistFolio  : longint;
  end;

  PJobAnalCacheRec = ^TJobAnalCacheRec;
  TJobAnalCacheRec = Record
    jacJobCode        : String[JobKeyLen];
    jacJobHistFolio   : longint;
    jacAnalysisCode   : String[AnalKeyLen];
  end;

var
  Res : Integer;
  i   : Integer;
  KeyS, KeyChk : Str255;
  Found : Boolean;
  PCacheRecord : PHistFolioRec;
  PAnalCacheRecord : PJobAnalCacheRec;

  SQLQuery : AnsiString;

  function InSecondaryCache : Integer;
  var
    lFound : Boolean;
    j : Integer;
  begin
    lFound := False;
    Result := -1;
    if Assigned(JobAnalList) then
    begin
      j := 0;
      while not lFound and (j < JobAnalList.Count ) do
      begin
        with PJobAnalCacheRec(JobAnalList[j])^ do
        begin
          lFound := (jacJobCode = JobCode) and (jacJobHistFolio = JobHistFolio);
          if lFound then
            Result := -1
          else
            inc(j);
        end;
      end; //while
    end; //if Assigned
  end;

begin
  Result := 0;

  //Look in cache to see if we have already found the parent hist folio for this parent code/job code + JobHistFolio
  if Assigned(FolioList) then
  begin
    i := 0;
    while (Result = 0) and (i < FolioList.Count ) do
    begin
      with PHistFolioRec(FolioList[i])^ do
        if (hfParentCode = ParentCode) and (hfJobCode = JobCode) and (hfJobHistFolio = JobHistFolio) then
          Result := hfParentHistFolio
        else
          inc(i);
    end; //while
  end; //if Assigned

  if (Result = 0) and SQLUtils.UsingSQL then //Use a query to find the right histfolio
  begin
    Try
      FSQLCaller.Records.Parameters.ParamByName('ParentJobCode').Value := ParentCode;
      FSQLCaller.Records.Parameters.ParamByName('JobCode').Value := JobCode;
      FSQLCaller.Records.Parameters.ParamByName('JobHistFolio').Value := JobHistFolio;
      FSQLCaller.Records.Open;
      Try
        if FSQLCaller.Records.RecordCount > 0 then
        begin
          FSQLCaller.Records.First;
          Result := FSQLCaller.Records.FieldByName('HistFolio').AsInteger;
        end;
      Finally
        FSQLCaller.Close;
      End;
    Except
      //Let process fall through and use pervasive code
      Result := 0;
    End;
  end;


  if Result = 0 then
  begin
    //not found in cache so find budget record for JobCode and JobHistFolio

    //try secondary cache first
    Found := False;
    i := InSecondaryCache;
    if i > -1 then //found
    begin
      with PJobAnalCacheRec(JobAnalList[i])^ do
        KeyS := Pfix + FullJobCode(ParentCode) + LJVar(jacAnalysisCode, 16);

      Found := True;
    end;

    if not Found then  //Go to database
    begin
      KeyS := Pfix + FullJobCode(JobCode);
      KeyChk := KeyS;

      with MTExLocal^ do
      begin
        Res := LFind_Rec(B_GetGEq, JCtrlF, 0, KeyS);
        while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) and not Found do
        begin
          //Add record to secondary cache if it doesn't already exist
          if Assigned(JobAnalList) and (InSecondaryCache = -1) then
          begin
            New(PAnalCacheRecord);
            PAnalCacheRecord.jacJobCode := JobCode;
            PAnalCacheRecord.jacJobHistFolio := LJobCtrl.JobBudg.HistFolio;
            PAnalCacheRecord.jacAnalysisCode := LJobCtrl.JobBudg.AnalCode;
            JobAnalList.Add(PAnalCacheRecord);
          end;

          Found := LJobCtrl.JobBudg.HistFolio = JobHistFolio;

          if not Found then
            Res := LFind_Rec(B_GetNext, JCtrlF, 0, KeyS);
        end; //while

        if Found then
          KeyS := Pfix + FullJobCode(ParentCode) + LJVar(LJobCtrl.JobBudg.AnalCode, 16);
      end; //with
    end; //if not Found

    if Found then
    with MTExLocal^ do
    begin
      //Find budget reoord for ParentCode and AnalysisCode
      Res  := LFind_Rec(B_GetEq, JCtrlF, 0, KeyS);

      //Set result
      if Res = 0 then
        Result := LJobCtrl.JobBudg.HistFolio;

    end; //with MTExLocal
  end; //if Result = 0 (not found in cache

  if (Result <> 0) and Assigned(FolioList) then
  begin
    //Add details to cache

    New(PCacheRecord);
    FillChar(PCacheRecord^, SizeOf(PCacheRecord^), 0);

    PCacheRecord.hfJobCode := JobCode;
    PCacheRecord.hfParentCode := ParentCode;
    PCacheRecord.hfJobHistFolio := JobHistFolio;
    PCacheRecord.hfParentHistFolio := Result;

    FolioList.Add(PCacheRecord);
  end; //If Result <> 0
end; //Procedure
{$ENDIF JC}

Initialization

{$IFDEF SY}
  {$IFDEF MC_On}
    If (FileExists(SetDrive+'DEFPF044.SYS')) or (FileExists(SetDrive+'DEF044.SYS')) then
      Warn_BadVersion(BOn);
  {$ELSE}
    If (FileExists(SetDrive+'DEFMC044.SYS')) then
      Warn_BadVersion(BOff);

  {$ENDIF}
{$ENDIF}

Finalization


end.
