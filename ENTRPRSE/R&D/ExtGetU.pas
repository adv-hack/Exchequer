unit ExtGetU;


{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  GlobVar,VarConst,SBSComp,SupListU,

  {$IFDEF POST}
    ExBtTh1U,
    PostingU,
  {$ENDIF}

  Recon3U,

  //PR: 18/04/2012 ABSEXCH-12830
  QtyBreakVar;


Const
  ClearedNdx    :  Array[BOff..BOn]  of Char = (#1,#2);

type


  TDDMList  =  Class(TGenList)

   Public

    NomExtRecPtr       :  ExtNomRecPtr;

    NomExtObjPtr       :  GetNomMode;

    ReconFilter
             :  Boolean;

    LNHCtrl  :  TNHCtrlRec;

    MStkLocFilt
             :  ^Str10;

    LastValue:  Str20;

    {$IFDEF POST}
      ReExLocal:  tdPostExLocalPtr;
      MTPost   :  ^TEntPost;
    {$ENDIF}


    Procedure ExtObjCreate; Override;

    Procedure ExtObjDestroy; Override;

    Function ExtFilter  :  Boolean; Override;

    Function GetExtList(B_End      :  Integer;
                    Var KeyS       :  Str255)  :  Integer; Override;


    Function SetCheckKey  :  Str255; Override;

    Function GlobLocFiltSet  :  Boolean;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function Check_PayInStatus(Var IdR  :  IDetail)  :  Byte;

    Function Has_PayinMode(NomCode  :  LongInt)  :  Boolean;

    Function CheckRowEmph :  Byte; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Procedure InitMTExLocal;

    Procedure SetReconStatus;

    Procedure Set_PayInStatus;

    Function  Link2FindList(Opt       :   Byte)  :  Boolean; Virtual;

    procedure Find_OnLedger(Opt: Byte; Value: Str30);

    Procedure Find_OnList(Opt       :   Byte;
                          Value     :   Str30);  Virtual;

    Function InputValue(Mode    :    Byte;
                    Var Value   :    Str20)  :  Boolean;

    Procedure Find_ReconItem(Opt  :  Byte);


  end;


  { --------------------------- }

{$IFDEF STK}
  Function Batch_Aqty(Bgt,Usd  :  Double;
                      Sibling  :  Boolean)  :  Str80;

  { ====== Func to give alt display ======= }

  Function Bin_Aqty(Bgt,Usd,Cap  :  Double;
                    Sibling      :  Boolean)  :  Str80;

  Function Str_BinHoldStatus(brStat,
                             brTag  :  Byte)  :  Str20;

Type


  TSNoList  =  Class(TDDMList)
  private
    // CJS 2016-01-27 - ABSEXCH-16900 - Cannot jump to end of discount list on Traders
    FUseAlternativeEndKey: Boolean;

  protected
    //PR: 07/10/2011 ABSEXCH-11736
    procedure SetEndKey(var KeyS : Str255); override;
  Public

    SLRetMode  :  Boolean;

    SERDocFilt   :  Str10;

    StkCallBack,
    DispDocPtr,
    DispStkPtr   :  Pointer;

    // CJS 2016-01-27 - ABSEXCH-16900 - Cannot jump to end of discount list on Traders
    constructor Create(AOwner: TComponent); override;

    Function SetCheckKey  :  Str255; Override;

    Function SetLocFilt  :  Str10;

    Function Chk_LocFilt  :  Boolean;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;


    Function OutSNoLine(Col  :  Byte)  :  Str255;

    Function OutBinLine(Col  :  Byte)  :  Str255;

    Function OutValLine(Col  :  Byte)  :  Str255;
    Function OutQBLine(Col  :  Byte)  :  Str255;
    Function OutCDLine(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Procedure Intercept_ListClick(Mode      : SmallInt;
                                  MX,MY     :  LongInt); Override;

    Procedure GetMiniSERN(OMode     :   Byte);

    procedure Display_StkDoc(Mode  :  Byte);

    procedure Display_StkRec(Mode  :  Byte);

    Procedure QB_CopyMatrix(TmpStock,
                            StockR    :  StockRec;
                            CCode     :  Str10;
                            CSupCode  :  Char;
                            DelQBMat  :  Boolean;
                            ParentFolio: longint = 0);

    Procedure Update_QBTree(TmpStk     :  StockRec;
                            Level      :  LongInt;
                            LevelKey   :  Str255;
                        Var NoStop     :  Boolean;
                        Var MsgForm    :  TForm);


    Procedure QB_TreeUpdate;

    Procedure Copy_QBStock(CCode      :  Str10;
                           CSupCode   :  Char;
                           ParentFolio : longint);

    Procedure CD_CopyMatrix(TmpCust   :  CustRec;
                            CCode     :  Str10;
                            CSupCode  :  Char;
                            DelCDMat  :  Boolean);

    Procedure Update_CDAcc(CSupCode   :  Char;
                       Var NoStop     :  Boolean;
                       Var MsgForm    :  TForm);

    Procedure CD_AccUpdate(CSupCode   :  Char);

    Procedure Copy_CDStock(CCode      :  Str10;
                           CSupCode   :  Char);

    Function FindxDiscCode(KeyChk  :  Str255;
                           SM      :  SmallInt)  :  Boolean;

    // CJS 2016-01-27 - ABSEXCH-16900 - Cannot jump to end of discount list on Traders
    property UseAlternativeEndKey: Boolean read FUseAlternativeEndKey write FUseAlternativeEndKey;
  end;

  { --------------------------- }

{$ENDIF}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU1,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  {CmpCtrlU,
  ColCtrlU,}
  VarRec2U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  SysU1,
  SysU2,
  {IntMU,
  MiscU,
  PayF2U,}
  Warn1U,
  ExWrap1U,

  {$IFDEF STK}
    Tranl1U,
    StockU,
    SalTxl2U,
  {$ENDIF}
  PWarnU,
  SQLUtils,
  SalTxl1U,

  //PR: 18/04/2012 ABSEXCH-12830
  Contnrs;





{ ============== TDDMList Methods =============== }


procedure TDDMList.ExtObjCreate;

Begin
  Inherited;

  NomExtRecPtr:=nil;
  NomExtObjPtr:=nil;

  MStkLocFilt:=nil;

  LastValue:='';

  {$IFDEF POST}
    ReExLocal:=nil;
    MTPost:=nil;
  {$ENDIF}

  If (LNHCtrl.NHMode=15) then
  Begin
    New(NomExtRecPtr);

    FillChar(NomExtRecPtr^,Sizeof(NomExtRecPtr^),0);

    New(NomExtObjPtr,Init);

    ExtRecPtr:=NomExtRecPtr;
    ExtObjPtr:=NomExtObjPtr;
  end;


end;



procedure TDDMList.ExtObjDestroy;

Begin
  If (NomExtRecPtr<>nil) then
    Dispose(NomExtRecPtr);

  If (NomExtObjPtr<>nil) then
    Dispose(NomExtObjPtr,Done);

  {$IFDEF POST}
    If (Assigned(ReExLocal)) then
      Dispose(ReExLocal,Destroy);

    If (Assigned(MTPost)) then
      Dispose(MTPost,Destroy);
  {$ENDIF}

  Inherited;

  NomExtRecPtr:=nil;
  NomExtObjPtr:=nil;

end;


Function TDDMList.ExtFilter  :  Boolean;

Var
  TmpBo      :  Boolean;
  IsCC       :  Boolean;

Begin
  With NomExtRecPtr^ do
  Begin
    TmpBo:=(((FYr=Id.PYr) or (FYr=YTD)) and ((FPr=Id.PPr) or (FPr In [YTD,YTDNCF])) or (FMode In [31..49,131..149]))
               and (Id.NomMode=FNomMode);

    If (FMode In [2,102]) then
      TmpBo:=((TmpBo) and (FCr=Id.Currency));

    If (FMode In [11,12,22,23,31..49,111,112,122,123,131..149]) and (TmpBo) then
    Begin
      IsCC:=(Fmode In [12,23,32,43,112,123,132,143]); {* EN440CCDEP *}
      TmpBo:=(CheckKey(FCCode,Id.CCDep[IsCC],ccKeyLen,BOff));

      If (Length(FCCode)>ccKeyLen) and (TmpBo) then {*Its combined}  {* EN440CCDEP *}
      Begin
        TmpBo:=(CheckKey(Copy(FCCode,5,ccKeyLen),Id.CCDep[Not IsCC],ccKeyLen,BOff));

      end;
    end;

    If (FMode In [100..149]) and (TmpBo) then
      TmpBo:=(Id.ReconDate>=FRDate);


    {$IFDEF SOP}
      If (TmpBo) and (CommitAct) and (LNHCtrl.NHCommitView=0) and (Id.PostedRun=CommitOrdRunNo) and (Id.IdDocHed=RUN) then
        TmpBo:=BOff;

    {$ENDIF}

  end;

  Result:=TmpBo;

end;

Function  TDDMList.GetExtList(B_End      :  Integer;
                             Var KeyS       :  Str255)  :  Integer;

Var
  TmpStat   :  Integer;


Begin

  TmpStat:=0;

  Begin

    With NomExtRecPtr^ do
    Begin

      If (B_End In [B_GetPrev,B_GetNext]) and (NomExtObjPtr<>nil) then
      Begin

        DispExtMsg(BOn);

        TmpStat:=NomExtObjPtr^.GetSearchRec(B_End+30,ScanFileNum,KeyPath,KeyS,FNomCode,FCr,FYr,FPr,FNomMode,FMode,FCCode,FRDate);

        DispExtMsg(BOff);

      end
      else

        TmpStat:=Find_Rec(B_End,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,KeyS);

    end;{With..}

  end; {With..}

  Result:=TmpStat;

end; {Func..}


  { =========== Function to Check if Filter Set =========== }

  Function TDDMList.GlobLocFiltSet  :  Boolean;

  Begin
    If (Assigned(MStkLocFilt)) then
      Result:=(Syss.UseMLoc and (Not EmptyKey(MStkLocFilt^,LocKeyLen)))
    else
      Result:=BOff;

  end;



Function TDDMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Word;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  With Id,LNHCtrl do
  Begin
     Case NHMode of

       3,5,15
            :  Begin

                 TmpPr:=Id.PPr;

                 If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                 Begin

                   Case NHMode of
                     3,5  :  Begin
                               TmpYr:=YTD;


                               If (NHCr=0) then
                                 Currency:=CurrencyType;
                             end;

                     15   :  Begin
                               TmpYr:=PYr;

                               If (Not NHYTDMode) then
                                 AdjMnth(TmpPr,TmpYr,1)
                               else
                                 TmpYr:=AdjYr(TmpYr,BOn);

                               If (NHDDRecon<>0) and (Not NHYTDMode) and (Not NHSDDFilt) then 
                                 Currency:=Currency+1;
                                 
                               {$IFDEF MC_On}

                                 If (NHCr=0) then
                                   Currency:=CurrencyType;

                               {$ENDIF}


                             end;

                   end; {Case..}

                 end
                 else
                   TmpYr:=PYr;

                 If (NHUnPostMode) then
                   DumStr:=FullIdKey(PostedRun,NomCode)
                 else
                   DumStr:=FullIDPostKey(NomCode,PostedRun,NomMode,Currency,TmpYr,TmpPr);

                 
               end;

       6    :  Begin

                 DumStr:=StockCode;

               end;

     end;{Case..}

  end;

  SetCheckKey:=DumStr;
end;




Function TDDMList.SetFilter  :  Str255;

Var
  ChkRecon  :  Integer;

Begin

  If (ReconFilter) then
  With Id do
  Begin
    ChkRecon:=ReconC;

    If (PostedRun=PayInRunNo) then  {* Set Reconcile Status *}
    Begin
      Reconcile:=Check_PayInStatus(Id);

      ChkRecon:=ReconA;
    end;


    If (Length(Filter[1,0])>1) then {* CustFilter must be active as well *}

      Result:=FullCustCode(CustCode)+ClearedNDX[(Reconcile=ChkRecon)]
    else
      Result:=ClearedNDX[(Reconcile=ChkRecon)];

  end
  else
  Begin
    Result:=FullNomKey(Id.PostedRun);

    If (Result[1]=NdxWeight) then {* Avoid genuine run nos which emulate Ndxweight *}
      Result:=#99;
  end;


  {$IFDEF SOP}
    If (CommitAct) and (LNHCtrl.NHCommitView=0) and (Id.PostedRun=CommitOrdRunNo) and (Id.IdDocHed=RUN) then
      Result:=NdxWeight;

  {$ENDIF}

  If (Result<>NdxWeight) and (LNHCtrl.NHUnPostMode) and (Not (Id.IdDocHed in DocAllocSet+DirectSet+NomSplit)) then
    Result:=NdxWeight;

end;


Function TDDMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;

{ ============ Payin In Status Check =========== }
{ Reproduced threaded in PostingU }

Function TDDMList.Check_PayInStatus(Var IdR  :  IDetail)  :  Byte;

Const
  Fnum       =  IDetailF;
  Keypath2   =  IDStkK;


Var

  TmpKPath,
  TmpStat :  Integer;

  TmpRecAddr
          :  LongInt;

  KeyS,
  KeyChk  :  Str255;
  PayId   :  Idetail;

  AllClear,
  SomeClear
          :  Boolean;


Begin

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  PayId:=IdR;

  With PayId do
    KeyChk:=Full_PostPayInKey(PayInCode,NomCode,Currency,Extract_PayRef2(StockCode));

  AllClear:=BOn;

  SomeClear:=BOff;

  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With Id do
  Begin

    If (AllClear) then
      AllClear:=(Reconcile=ReconC);

    If (Not SomeClear) then
      SomeClear:=(Reconcile=ReconC);

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);

  end; {While..}

  Check_PayInStatus:=(Ord(SomeClear)+Ord(AllClear));

  IdR:=PayId;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);


end; {Func..}

 { ===== Function to determine if a Nominal has a Paying in mode setup ====== }


 Function TDDMList.Has_PayinMode(NomCode  :  LongInt)  :  Boolean;


 Const
   Fnum     =   IDetailF;
   Keypath  =   IDNomK;




 Var

   TmpKPath,
   TmpStat  :   Integer;

   TmpRecAddr
            :  LongInt;

   TmpId    :  IDetail;

   KeyS,
   KeyChk   :   Str255;



 Begin

   TmpId:=Id;

   TmpKPath:=GetPosKey;

   TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

   KeyChk:=FullIdKey(NomCode*DocNotCnst,PayInNomMode);

   KeyS:=KeyChk;

   Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


   Has_PayInMode:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)));

   TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

   Id:=TmpId;

 end; {Func..}




Function TDDMList.CheckRowEmph :  Byte;

Var
  ChkRecon  :  Byte;

Begin
  With Id do
  Begin

    ChkRecon:=ReconC;

    If (PostedRun=PayInRunNo) then  {* Get Reconcile Status *}
    Begin
      Reconcile:=Check_PayInStatus(Id);

      ChkRecon:=ReconA;
    end;



    Result:=Ord(Reconcile<>ChkRecon);

  end;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TDDMList.OutLine(Col  :  Byte)  :  Str255;


Var

  FoundLong
         :  LongInt;

  GenStr :  Str255;

  ViewOnly,
  ShowDet: Boolean;

  CrDr   :  DrCrType;

  DeductD:  Boolean;

  UOR,
  TCr    :  Byte;

  LineBal,
  Dnum   : Double;

  FormatStr
         : Str255;


  ExLocal: ^TdExLocal;

Begin

  ExLocal:=ListLocal; UOR:=0;


   With ExLocal^,LNHCtrl,Id do
   Begin

     DeductD:=(IdDocHed=RUN);

      If (Not DeductD) then
        DeductD:=Not Syss.SepDiscounts;

      LineBal:=DetLTotal(Id,DeductD,BOff,0.0);

      If (NHCr=0) then
      Begin
        UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

        LineBal:=Conv_TCurr(LineBal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
      end;

      LineBal:=Currency_Txlate(LineBal,NHCr,NHTxCr);


      ShowDrCr(LineBal,CrDr);

     Case Col of

       0  :  Begin
               OutLine:=DocCodes[IdDocHed];
             end;


       1  :  Begin

               GenStr:=PPR_OutPr(PPr,PYr);
               
               OutLine:=GenStr;
             end;

       2  :  OutLine:=CustCode;
       3  :  OutLine:=Desc;
       4  :  Begin
               TCr:=0;

               {$IFDEF MC_On}

                 If (NHTxCr<>0) then
                   TCr:=NHTxCr
                 else
                   TCr:=NHCr;

               {$ENDIF}

               OutLine:=FormatCurFloat(GenRealMask,LineBal,BOff,TCr)

             end;

       5  :  Begin
               If (PostedRun=PayInRunNo) then
                 GenStr:=GetPayInStatus(Reconcile)
               else
                 GenStr:=GetReconcileStatus(Reconcile);


               OutLine:=GenStr;
             end;
       6  :  If (IdDocHed<>RUN) or (PostedRun=PayInRunNo) then
               OutLine:=POutDate(PDate)
             else
               OutLine:=PDate;
          //PR: 19/03/2009 Added functionality for Reconciliation Date
       7  :  if ValidDate(ReconDate) and (ReconDate < MaxUntilDate) then
               Outline := POutDate(ReconDate)
             else
               Outline := '';



       else
             OutLine:='';
     end; {Case..}


   end; {With..}
end;


{ ===== various routines to control paying in status ======= }



Procedure TDDMList.InitMTExLocal;

Begin
  {$IFDEF POST}
    If (Not Assigned(ReExLocal)) then
    Begin
      New(ReExLocal,Create(10));

      try
        With ReExLocal^ do
          Open_System(NomF,NHistF);

      except
        Dispose(ReExLocal,Destroy);
        ReExLocal:=nil;

      end; {Except}

      If (Assigned(ReExLocal) and (Not Assigned(MTPost))) then
      Begin
        New(MTPost,Create(Self));

        try
          MTPost.MTExLocal:=ReExLocal;


        except
          Dispose(MTPost,Destroy);
          MTPost:=nil;
        end;
      end;
    end;
  {$ENDIF}

end;


{ =============== Procedure to Set Cleared Status ============= }

Procedure TDDMList.SetReconStatus;


Var
  Cnst    :  Integer;

  LAddr,
  TNCode  :  LongInt;

  
  LVal
          :  Real;
          
  PBal    :  Double;

  Rstatus :  Byte;

  Loop    :  Boolean;

  Locked  :  Boolean;


Begin
  {$IFDEF POST}

    Loop:=BOff;

    With Id do
    Begin
      RStatus:=LNHCtrl.NBMode-ReconN;

      Cnst:=0;  LVal:=0;  PBal:=0;  TNCode:=0;

      Locked:=BOff;

      If (Not Assigned(MTPost)) then
        InitMTExLocal;

      If (RStatus<>Reconcile) then
      Begin
        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,ScanFileNum,BOff,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin
          If (Reconcile=ReconC) then
            Cnst:=-1
          else
            If (Reconcile In NotClearedSet) and (RStatus = ReconC) then
              Cnst:=1;

          If (Cnst<>0) then
          Begin
            LVal:=DetLTotal(Id,Not Syss.SepDiscounts,BOff,0.0)*Cnst;

            {$IFDEF Post}

              If (Assigned(MTPost)) then
              Begin
                MTPost.LPost_To_Nominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,CXrate,PBal,TNCode,UseORate);

                {$IFDEF PF_On}
                  If (Syss.PostCCNom) and (Syss.UseCCDep) then
                  Begin
                    Repeat
                      If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
                      Begin
                        MTPost.LPost_To_CCNominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                          CXRate,PostCCKey(Loop,CCDep[Loop]),UseORate);

                        
                        If (Syss.PostCCDCombo) then {* Post to combination *}
                          MTPost.LPost_To_CCNominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                            CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UseORate);

                      end;
                      Loop:=Not Loop;

                    Until (Not Loop);
                  end;

                {$ENDIF}

              end;

            {$ENDIF}

          end;

          Reconcile:=RStatus;

          If (Reconcile=ReconC) then
            ReconDate:=Today
          else
            ReconDate:=MaxUntilDate;

          Status:=Put_Rec(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,Keypath);

          Report_BError(ScanFileNum,Status);
        end;

        Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,LAddr);
      end; {If locked..}
    end; {With..}

  {$ENDIF}
end; {Proc..}


{ ============ Payin In Status Controller =========== }

Procedure TDDMList.Set_PayInStatus;

Const
  Fnum       =  IDetailF;
  Keypath2   =  IDStkK;


Var
  RStatus :  Byte;

  LOk,
  Locked  :  Boolean;

  KeyS,
  KeyChk  :  Str255;

  PayId   :  Idetail;

  RecAddr :  LongInt;

  OldKPath:  Integer;


Begin

  PayId:=Id;

  RecAddr:=0;

  RStatus:=LNHCtrl.NBMode-ReconN;

  If (PayId.PostedRun=PayInRunNo) then
  With PayId do
  Begin

    Status:=GetPos(F[ScanFileNum],ScanFileNum,RecAddr);  {* Preserve Posn of Invoice Line *}


    If (StatusOk) then
    Begin

      OldKPath:=Keypath;
      KeyPath:=Keypath2;  {* Set Here, so Putrec will preserve the same keypath *}

      KeyChk:=Full_PostPayInKey(PayInCode,NomCode,Currency,Extract_PayRef2(StockCode));


      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      Begin

        SetReconStatus;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);

      end; {While..}


      KeyPath:=OldKPath;

      {* Re-establish position prior to returning to list *}

      SetDataRecOfs(ScanFileNum,RecAddr);

      Status:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,Keypath,0);

      If (PayId.Reconcile<>RStatus) then
      With Id do
      Begin

        LOk:=GetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,Locked);

        If (LOk) and (Locked) then 
        Begin
          Reconcile:=RStatus;

          If (Reconcile=ReconC) then
            ReconDate:=Today
          else
            ReconDate:=MaxUntilDate;

          Status:=Put_Rec(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath);

          Report_BError(ScanFileNum,Status);

          Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,RecAddr);
        end;

      end;


    end;

    Id:=PayId;

  end
  else
    SetReconStatus;




end; {Proc..}


Function TDDMList.Link2FindList(Opt       :   Byte)  :  Boolean;
Begin
  Result:=BOn;

end;

procedure TDDMList.Find_OnLedger(Opt: Byte; Value: Str30);
var
  KeyS        : Str255;
  DisplayValue: string;
  NoStop      : Boolean;
  FoundOk     : Boolean;
  KeepGo      : Boolean;
  Direction   : Boolean;
  Rnum        : Real;
  TInv        : InvRec;
  TId         : Idetail;
  B_Func      : Integer;
  DirectionStr: Array[False..True] of Str10;
  SearchTitle : Str80;
  MsgForm     : TForm;
  mbRet       : TModalResult;

  function IsMatched(Value1, Value2: string): Boolean;
  begin
    Result := (CheckKey(Value1, UpCaseStr(Value2), Length(Value1), False));
  end;

  function KeepSearching: Boolean;
  begin
    Result := LineOk(KeyS) and (not FoundOk) and (KeepGo) and (NoStop) and
              (not IRQSearch);
  end;

  procedure ListFromCurrentRecord;
  var
    RecAddr: LongInt;
  begin
    Status := GetPos(F[ScanFileNum], ScanFileNum, RecAddr);
    PageKeys^[0] := RecAddr;
    KeyAry^[0]   := SetCheckKey;
    PageUpDn(0, BOn);
    RefreshLine(0, BOn);
  end;

begin
  if Opt = 12 then
    DisplayValue := IntToStr(UnFullNomKey(Value))
  else
    DisplayValue := Value;

  GetSelRec(False);

  Direction := True;

  DirectionStr[False] := 'backwards';
  DirectionStr[True]  := 'forwards';

  KeepGo  := True;
  FoundOk := False;
  NoStop  := True;

  Rnum := 0;

  TInv := Inv;
  TId  := Id;

  B_Func := B_GetNext;

  SearchTitle := 'Searching';

  if (Value <> '') then
    SearchTitle := SearchTitle + ' for ' + DisplayValue;

  MsgForm := CreateMessageDialog('Please Wait - ' + #13 + SearchTitle,
                                 mtInformation, [mbAbort]);
  MsgForm.Show;
  MsgForm.Update;

  InListLoop := True;

  repeat
    begin
      case Direction of
        False: B_Func := B_GetPrev;
        True : B_Func := B_GetNext;
      end;

      KeyS := FullNomKey(SortView.ListID);
      GetMatch(B_Func, B_Func, KeyS);

      while KeepSearching do
      begin

        mbRet := MsgForm.ModalResult;
        Loop_CheckKey(NoStop, mbRet); // Warn1U.pas
        MsgForm.ModalResult := mbRet;

        Application.ProcessMessages;

        SortView.SyncRecord;
        case Opt of
          5 : FoundOk := IsMatched(Value, Inv.OurRef);
          6 : FoundOk := IsMatched(Value, Inv.YourRef);
          11: FoundOk := IsMatched(Value, Inv.TransDesc); // AltRef
          12: FoundOk := IsMatched(Value, FullNomKey(Inv.FolioNum));
          35: FoundOk := IsMatched(Value, Inv.CustCode);
        end;

        if (not FoundOk) then
          GetMatch(B_Func, B_Func, KeyS);

      end;

      Direction := not Direction;

      if (not IRQSearch) then
      begin
        if (FoundOk) then
          ListFromCurrentRecord
        else
        begin
          mbRet := MessageDlg('Unable to find ' + DisplayValue + '.' + #13 +
                              'Search ' + DirectionStr[Direction] + '?',
                              mtConfirmation,[mbYes,mbNo], 0);
          KeepGo := (mbRet = mrYes);
        end;
      end;
    end;

  until (not KeepGo) or (FoundOk) or (IRQSearch);

  InListLoop := False;

  MsgForm.Free;

  Inv := TInv;
  Id  := TId;

end;

{ =========== Function to Search for:- 0: Next Unallocated Inv.
                                       1: Matching Detail Line Value
                                       2: Next Uncleared Item
                                       3: Next Uncleared Value
                                       4: Next Matching Description
                                       5: Next InvNo
                                       6: Next Your Ref No.
                                       7: Next Stock Code on Doc
                                       8: Next Matching Document
                                      11: Next Long Ref
                                      12: Next folio number
                                      15,
                                      16: Next ORef/Your Ref via Job Actual,
                                      20: Bank Recon Value
                                      23: Bank Recon Detail
                                      30: Next Stock Code
                                      31: Next Stock Desc
                                      32: Next Stock Alt Code
                                      33: Next Stock Code via Alt db;
                                      35: Next matching account code
                                      36: YourRef ariRecord - Allocation record
                                      37: OurRef ariRecord - Allocation record
                                      38: Wildcard search on any stock field
                                      45: Account/Employee code from Job Daybook
                                      ============= }


Procedure TDDMList.Find_OnList(Opt       :   Byte;
                               Value     :   Str30);


Var
  KeyI,
  KeyS      :  Str255;

  NoStop,
  FoundOk,
  TBo,
  KeepGo,
  Direc
            :  Boolean;
  Rnum      :  Real;


  TInv      :  InvRec;
  TId       :  Idetail;
  B_Func    :  Integer;
  DirecStr  :  Array[BOff..BOn] of Str10;

  SearchTit :  Str80;

  MsgForm   :  TForm;
  mbRet     :  TModalResult;

  //GS: 12/05/11 ABSEXCH-2792
  //added a string to store the decoded search parameter when performing
  //an Opt = 12 search (a find next by folio number search)
  DisplayValue: String;
Begin

  //GS: 12/05/11 ABSEXCH-2792
  //if we are performing a 'find-next by folio number' search, the searchstring ('value') parameter will be encoded,
  //therefore, decode the searchstring so when it's displayed, it doesen't look corrupted!
  if Opt = 12 then
    DisplayValue := IntToStr(UnFullNomKey(Value))
  else
    DisplayValue := Value;

  GetSelRec(BOff);

  Direc:=BOn;

  DirecStr[BOff]:='backwards';
  DirecStr[BOn]:='forwards';

  KeepGo:=BOn;

  FoundOk:=BOff;

  TBo:=BOff;

  NoStop:=BOn;

  Rnum:=0;

  TInv:=Inv;
  TId:=Id;

  B_Func:=B_GetNext;

  SearchTit:='Searching';

  //GS: 12/05/11 ABSEXCH-2792
  //Modified the search title to use the new 'DisplayValue' variable
  //so when 'find-next by folio number' is used, the title no longer shows the encoded search string
  If (Value<>'') then
    SearchTit:=SearchTit+' for '+DisplayValue+' ...'
  else
    SearchTit:='... '+SearchTit+' ...';


  MsgForm:=CreateMessageDialog('Please Wait...'+#13+SearchTit,mtInformation,[mbAbort]);
  MsgForm.Show;
  MsgForm.Update;

  InListLoop:=BOn;

  Repeat
    Begin
      KeyI:='';

      Case Direc of

        BOff  :  B_Func:=B_GetPrev;
        BOn   :  B_Func:=B_GetNext;

      end; {Case..}

      KeyS:=KeyAry[CurrLine];

      GetMatch(B_Func,B_Func,KeyS);

      While (LineOk(KeyS)) and (Not FoundOk) and (KeepGo) and (NoStop) and (Not IRQSearch) do
      Begin

        mbRet:=MsgForm.ModalResult;
        Loop_CheckKey(NoStop,mbRet);
        MsgForm.ModalResult:=mbRet;

        Application.ProcessMessages;

        If (Link2FindList(Opt)) then
        Case Opt of
          0  : FoundOk:=(BaseTotalOS(Inv)<>0);
          1,3
             :  Begin
                  Rnum:=DetLTotal(Id,(Syss.SepDiscounts or (Id.IdDocHed=RUN)),BOff,0.0);


                  If (LNHCtrl.NHCr=0) then
                    Rnum:=Conv_TCurr(Rnum,Id.CXRate[UseCoDayRate],Id.Currency,Id.UseORate,BOff);

                  FoundOk:=((ABS(Round_Up(Rnum,2))=ABS(Round_Up(RealStr(Value),2))) and ((Opt<>3) or (Id.Reconcile<>ReconC)));

                end;
          2  :  With Id do
                  FoundOk:=(Reconcile<>ReconC);

          4  :  With Id do
                  FoundOk:=Match_Glob(Succ(Length(Desc)),Value,Desc,TBo);

          5  :  With Inv do
                  FoundOk:=(CheckKey(Value,UpCaseStr(OurRef),Length(Value),BOff));

          6  :  With Inv do
                  FoundOk:=(CheckKey(Value,UpCaseStr(YourRef),Length(Value),BOff));

          7  :  With Id do
                  FoundOk:=(CheckKey(Value,StockCode,Length(Value),BOff));

          8  :  With MiscRecs^.SerialRec do
                  FoundOk:=((CheckKey(Value,InDoc,Length(Value),BOff))
                         or (CheckKey(Value,OutDoc,Length(Value),BOff)));

          //PR: 20/03/2009 Added option for Reconciliation Date
          9  :  With Id do
                  FoundOk:=(CheckKey(Value,POutDate(ReconDate),Length(Value),BOff));

          11 :  With Inv do
                  FoundOk:=(CheckKey(Value,UpCaseStr(TransDesc),Length(Value),BOff));

          12 :  With Inv do
                  FoundOk:=(CheckKey(Value,FullNomKey(FolioNum),Length(Value),BOff));

          15,16,45
             :  With JobDetl^.JobActual do
                Begin
                  KeyI:=LineORef;

                  Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyI);

                  If (StatusOk) then
                  Case Opt of
                    15  :  With Inv do
                             FoundOk:=(CheckKey(Value,UpCaseStr(OurRef),Length(Value),BOff));

                    16  :  With Inv do
                            FoundOk:=(CheckKey(Value,UpCaseStr(YourRef),Length(Value),BOff));

                    45  :  With Inv do
                           Begin
                             Case InvDocHed of
                               TSH : FoundOk:=(CheckKey(Value,UpCaseStr(EmplCode),Length(Value),BOff));
                               JCT..JPA
                                   : FoundOk:=(CheckKey(Value,UpCaseStr(EmplCode),Length(Value),BOff)) or
                                              (CheckKey(Value,UpCaseStr(ActCCode),Length(Value),BOff));

                               else  FoundOk:=(CheckKey(Value,UpCaseStr(ActCCode),Length(Value),BOff));
                             end; {Case..}
                           end;

                  end; {Case..}
                end;


          20 :  With MiscRecs^.BankMRec do
                Begin
                  FoundOk:=(Round_Up(BankValue,2)=Round_Up(RealStr(Value),2));
                end;

          23 :  With MiscRecs^.BankMRec do
                Begin
                  FoundOk:=CheckKey(Value,BankRef,Length(Value),BOff);
                end;

        {$IFDEF STK}

          30 :  With Stock do
                  FoundOk:=(CheckKey(Value,UpCaseStr(StockCode),Length(Value),BOff));

          31 :  With Stock do
                  FoundOk:=(CheckKey(Value,UpCaseStr(Desc[1]),Length(Value),BOff));

          32 :  With Stock do
                  FoundOk:=(CheckKey(Value,UpCaseStr(AltCode),Length(Value),BOff));

          {$IFDEF SOP}

            34  :  With Stock, MLocCtrl^.sdbStkRec do
                   Begin
                     FoundOk:=BOff;

                     KeyS:=Value;

                     Status:=Find_Rec(B_GetGEq,F[MLocF],MLocF,RecPtr[MLocF]^,MLK,KeyS);

                     If (CheckKey(Value,KeyS,Length(Value),BOff)) then
                     Begin

                       FoundOk:=(sdStkFolio=StockFolio);

                     end;
                   end;
          {$ENDIF}

        {$ENDIF}

          35  :  With Inv do
                   FoundOk:=(CheckKey(Value,UpCaseStr(CustCode),Length(Value),BOff));

          36  :  With MiscRecs^.AllocSRec do
                   FoundOk:=(CheckKey(Value,UpCaseStr(ariYourRef),Length(Value),BOff));

          37  :  With MiscRecs^.AllocSRec do
                   FoundOk:=(CheckKey(Value,UpCaseStr(ariOurRef),Length(Value),BOff));

          38  :  With Stock do
                   FoundOk:=Match_Glob(Sizeof(Stock),Value,Stock,TBo);


        end; {Case..}

        If (Not FoundOk) then
          GetMatch(B_Func,B_Func,KeyS);
      end; {While..}

      Direc:=Not Direc;

      If (Not IRQSearch) then {If this is no longer set, search has been aborted}
      Begin
        If (FoundOk) then
        Begin
          AddNewRow(0,BOn);
        end
        else
        Begin
          //GS: 12/05/11 ABSEXCH-2792
          //Modified the dialog message to use the new 'DisplayValue' variable
          //so when 'find-next by folio number' is used, the dialog no longer shows the encoded search string
          mbRet:=MessageDlg('Unable to find '+DisplayValue+' !'+#13+'Continue searching '+DirecStr[Direc]+'?',
                            mtConfirmation,[mbYes,mbNo],0);

          KeepGo:=(mbRet=mrYes);
        end;
      end;
    end; {With..}

  Until (Not KeepGo) or (FoundOk) or (IRQSearch);

  InListLoop:=BOff;

  MsgForm.Free;

  Inv:=TInv;
  Id:=TId;

end; {Proc..}


{ =============== Procedure to Input Search Value ============ }

Function TDDMList.InputValue(Mode    :    Byte;
                         Var Value   :    Str20)  :  Boolean;


{Const

  Search4Tit  :  Array[1..5] of Str30  = (('Amount'),
                                          (''),
                                          ('UnCleared Amount'),
                                          ('Details'),
                                          ('Account Code'));}
  //PR: 20/03/2009 Changed to function for reconciliation date (as this is Mode 9, this saves making the array disproportionately larger.)
  function Search4Tit(Idx : Byte) : Str30;
  begin
    Case Mode of
      1 : Result := 'Amount';
      3 : Result := 'UnCleared Amount';
      4 : Result := 'Details';
      5 : Result := 'Account Code';
      9 : Result := 'Reconciliation Date';
      else
        Result := '';
    end;
  end;

Var
  LOk,
  InpOk,
  CheckValue,
  CheckDate, //PR: 20/03/2009 for Reconciliation Date
  Flg            :  Boolean;

  VRet           :  Real;
  VCode          :  Integer;

  SCode          :  String;

  TMode          :  Byte;


Begin
  InpOK := False;
  {Value:='';}

  SCode:=Value;

  Flg:=(Mode In [5]);

  CheckValue:=(Mode In [1,3,20]);
  CheckDate := (Mode In [9]);

  Case Mode of
    20  :  TMode:=1;
    23  :  TMode:=4;
    else   TMode:=Mode;
  end; {Case..}


  LOk:=Not Flg;

  If (Mode<>2) then
  Begin

    Repeat

      InpOk:=InputQuery('Find '+Search4Tit(TMode),'Search for which '+Search4Tit(TMode)+'?',SCode);

      If (CheckValue) then
        Val(SCode,VRet,VCode)
      else
        VCode:=0;
                                                                       //PR: 20/03/2009 Added for Reconciliation Date
      LOk:=((EmptyKey(SCode,CustKeyLen)) or ((Not Flg) and (VCode=0))) or (CheckDate and (ValidDate(Date2Store(SCode))));

      If (Flg) and (InpOk) and (Not LOk) then
        LOk:=GetCust(Owner,SCode,Value,BOn,99)
      else
        If (LOk) and (Flg) and (InpOk) then
          Blank(Value,Sizeof(Value));


    Until (LOk) or (Not InpOk);

  end;

  If (Not Flg) then
    Value:=SCode;

  Result:=InpOk;

end;

{ ============== Find Value/Not Cleared Item ============== }

Procedure TDDMList.Find_ReconItem(Opt  :  Byte);

Var
  DispMode,
  FILen  :  Byte;
  Value  :  Str20;

  NeedSet,
  WasCustSet,
  CustSet
         :  Boolean;


Begin
  Value:=LastValue;

  DispMode:=1;

  NeedSet:=BOff;

  FILen:=0;

  {$B-}

  If (Opt=2) or (InputValue(Opt,Value)) then
  Begin
    LastValue:=Value;

  {$B+}

    FiLen:=Length(Filter[1,0]);

    CustSet:=(FiLen=CustKeyLen);

    WasCustSet:=(Length(LastValue)=CustKeyLen);

    NeedSet:=((CustSet) or (Filter[1,0]=''));

    Case Opt of
      1,3,4,9,20,23
        :  Find_OnList(Opt,Value);

      2 :  Begin

             If (Not NeedSet) then
             Begin
               If (Length(Filter[1,0])>1) then
                 Filter[1,0]:=Copy(Filter[1,0],1,Pred(FiLen))
               else
               Begin
                 Filter[1,0]:='';

                 ReconFilter:=BOff;
               end;

               DispMode:=4;
             end
             else
             Begin
               Filter[1,0]:=Filter[1,0]+ClearedNDX[BOff];

               ReconFilter:=BOn;

               ResetRec(ScanFileNum);

               DispMode:=0;
             end;

           end;

      5 :  Begin
             If (EmptyKey(Value,CustKeyLen)) then
             Begin
               If (CustSet) then
               Begin
                 Filter[1,0]:='';
                 ReconFilter:=BOff;
               end
               else
                 Filter[1,0]:=ClearedNDX[BOff];

               DispMode:=4;
             end
             else
             Begin
               If (Not WasCustSet) then
                 Filter[1,0]:=FullCustCode(Value)+Filter[1,0]
               else
                 Filter[1,0]:=FullCustCode(Value);
                 
               ReconFilter:=BOn;

               ResetRec(ScanFileNum);

               DispMode:=0;
             end;

           end;

      else DispMode:=11;
    end; {Case..}
  end
  else
    DispMode:=11;


  Case DispMode of

    0  :  InitPage;
    4  :  PageUpDn(0,BOn);

  end; {Case..}

end;



{ =================================================================================== }


  { ====== Func to give alt display ======= }

  Function Batch_Aqty(Bgt,Usd  :  Double;
                      Sibling  :  Boolean)  :  Str80;

  Var
    Dnum  :  Double;

  Begin

    If (Sibling) then
      Batch_Aqty:=Spc(4)+FormatFloat(GenQtyMask,Usd)+' Used.'
    else
    Begin
      Dnum:=Bgt-Usd;

      Batch_Aqty:='Avl :'+FormatFloat(GenQtyMask,Dnum)+'/'+FormatFloat(GenQtyMask,Bgt);

    end;

  end; {Func..}


  { ====== Func to give alt display ======= }

  Function Bin_Aqty(Bgt,Usd,Cap  :  Double;
                    Sibling      :  Boolean)  :  Str80;

  Var
    Dnum  :  Double;

  Begin

    If (Sibling) then
      Result:=Spc(4)+FormatFloat(GenQtyMask,Usd)+' Used.'
    else
    Begin
      Dnum:=Bgt-Usd;

      If (Cap<>0) then
        Result:='Avl :'+FormatFloat(GenQtyMask,Dnum)+'/'+FormatFloat(GenQtyMask,Cap)
      else
        Result:='Avl :'+FormatFloat(GenQtyMask,Dnum);

    end;

  end; {Func..}


{ ============== TSNoList Methods =============== }

{$IFDEF STK}

// CJS 2016-01-27 - ABSEXCH-16900 - Cannot jump to end of discount list on Traders
constructor TSNoList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUseAlternativeEndKey := False;
end;

  Function TSNoList.SetCheckKey  :  Str255;


  Var
    TmpYr,
    TmpPr   :  Word;

    DumStr    :  Str255;


  Begin
    FillChar(DumStr,Sizeof(DumStr),0);


    With LNHCtrl do
    Begin
      Case ScanFileNum of
        MiscF :  With MiscRecs^ do
                 Begin
                   Case Keypath of

                     MIK       :  DumStr:=FullQDKey(RecMfix,SubType,FIFORec.FIFOCode);
                     MiscNDXK  :  DumStr:=FullQDKey(RecMfix,SubType,SERialRec.SerialNo);
                     MiscBtcK  :  DumStr:=FullQDKey(RecMfix,SubType,SERialRec.BatchNo);

                   end; {Case..}

                 end;
          MLocF :  With MLocCtrl^ do
                 Begin
                   Case Keypath of

                     MLK       :  DumStr:=FullQDKey(RecPfix,SubType,brBinRec.brBinCode1);

                     MLSecK    :  With brBinRec do
                                    DumStr:=FullQDKey(RecPfix,SubType,brCode2);

                     MiscBtcK  :  With brBinRec do
                                    DumStr:=FullQDKey(RecPfix,SubType,brCode3);

                   end; {Case..}

                 end;

        //PR: 09/02/2012 Use new qty break record ABSEXCH-9795                 
        QtyBreakF
               : with QtyBreakRec do
                 begin
                   case KeyPath of
                     qbAcCodeIdx : DumStr := QtyBreakStartKey(qbAcCode, qbStockFolio);
                     qbFolioIdx  : DumStr := FullNomKey(qbFolio);
                   end; //case
                 end;


       end;{Case..}

    end;

    SetCheckKey:=DumStr;
  end;


  Function TSNoList.SetLocFilt  :  Str10;

  Begin

    If (GlobLocFiltSet) then
      SetLocFilt:=MStkLocFilt^
    else
      SetLocFilt:='';

  end;


    { === Func to check if serial number matches loc filter === }

  Function TSNoList.Chk_LocFilt  :  Boolean;

  Begin
    Result:=Not Syss.UseMLoc;

    If (Not Result) then
    With MiscRecs^.SerialRec do
    Begin
      Result:=(CheckKey(MStkLocFilt^,OutMLoc,Length(MStkLocFilt^),BOff) or
              CheckKey(MStkLocFilt^,InMLoc,Length(MStkLocFilt^),BOff));


    end;

    Chk_LocFilt:=Result;

  end; {Func..}


  Function TSNoList.SetFilter  :  Str255;

  Begin
    Case ScanFilenum of

      MiscF  :  Case Displaymode of
                  1,2  :  Result:=MiscRecs^.FIFORec.FIFOMLoc;
                  3,9
                       :  Result:=MiscRecs^.RecMFix;

                  4,5  :  With MiscRecs^.SerialRec do
                          Begin

                            If ((Filter[1,0]<>'')
                              and ((CheckKey(SerDocFilt,InDoc,Length(SerDocFilt),BOff))
                              or (CheckKey(SerDocFilt,OutDoc,Length(SerDocFilt),BOff))
                              or (CheckKey(SerDocFilt,OutOrdDoc,Length(SerDocFilt),BOff))
                              or (CheckKey(SerDocFilt,InOrdDoc,Length(SerDocFilt),BOff)))
                              and (Chk_LocFilt)) then

                              Result:='1'
                            else
                            begin
                              If ((Filter[2,0]<>'')
                              and (CheckKey(SerDocFilt,BatchNo,Length(SerDocFilt),BOff))
                              and (Chk_LocFilt)) then
                                Result:='1'
                              else
                                If ((Filter[3,0]<>'') and (Chk_LocFilt)) then
                                  Result:=Filter[3,0]
                                else
                                  Result:=NdxWeight;
                            end;
                          end;
                end; {Case..}

        MLocF  :  Begin
                    Case Displaymode of
                      6  :  Result:=MLocCtrl^.brBinRec.brInMLoc;

                    end; {Case..}
                  end;
        //PR: 08/02/2012 Added check for correct folio. ABSEXCH-9795
        QtyBreakF
               :  begin
                    Result := FullNomKey(QtyBreakRec.qbFolio);
                  end;

    end; {Case..}

  end;


  Function TSNoList.Ok2Del :  Boolean;

  Begin
    Result:=BOn;
  end;


  Function TSNoList.CheckRowEmph :  Byte;


  Begin
    Case DisplayMode of
      4,5  :
                Result:=Ord(Not MiscRecs^.SerialRec.Sold) or Ord(SLRetMode and MiscRecs^.SerialRec.ReturnSNo);

              
      6    :  With MLocCtrl^.brBinRec do
              Begin
                Result:=Ord((Not brSold) and (Not brBatchChild));

                {$B-}
                If (Not brBatchChild) and (CheckKey(Stock.BinLoc,brBinCode1,Length(Stock.BinLoc),BOff)) then
                {$B+}
                Begin
                  If (Not brSold) then
                    Result:=2
                  else
                    Result:=3;
                end;
              end;
      else    Result:=0;
    end; {Case..}
  end;




  { ========== Generic Function to Return Formatted Display for List ======= }


  Function TSNoList.OutSNoLine(Col  :  Byte)  :  Str255;


  Var
    Idx    :  Integer;

    GenStr :  Str255;

    ExLocal: ^TdExLocal;

  Begin

    ExLocal:=ListLocal;

    With MiscRecs^,SerialRec do
    Begin




      Case Col of

         0  :  Begin
                 {$IFDEF SOP}

                   If (BatchRec) then
                     Result:=Batch_AQty(BuyQty,QtyUsed,BatchChild)
                   else
                     Result:=SerialNo;
                 {$ENDIF}

               end;


         1  :  Result:=BatchNo;

         2  :  Result:=InDoc;
         3  :  Result:=OutDoc;
         4  :  If (EmptyKey(DateOut,LDateKeyLen)) then
                 Result:=POutDate(DateUseX)
               else
                 Result:=POutDate(DateOut);

         5  :  Result:=InMLoc;
         6  :  Result:=OutMLoc;
         7  :  Begin
                 If (Stock.StockFolio<>StkFolio) then
                    CheckRecExsists(FullNomKey(StkFolio),StockF,StkFolioK);

                 Result:=Stock.StockCode;

               end;



         else
               Result:='';
       end; {Case..}


     end; {With..}
  end;


  { ========== Generic Function to Return Formatted Display for List ======= }

  { == Function to show hold status == }
  {$WARNINGS OFF}
  Function Str_BinHoldStatus(brStat,
                             brTag  :  Byte)  :  Str20;

  Const
    brStatMsg : Array[0..3] of Str20 = ('','Hold/Locked','Quarantined','Match Tag');

  Begin
    If (brStat>=Low(brStatMsg)) and (brStat<=High(brStatMsg)) then
    Begin
      Result:=brStatMsg[brStat];

      If (brStat=3) then
        Result:=Result+' '+SetN(brTag);
    end
    else
      Result:='';

  end;
  {$WARNINGS ON}

  Function TSNoList.OutBinLine(Col  :  Byte)  :  Str255;


  Var
    Idx    :  Integer;

    GenStr :  Str255;

    ExLocal: ^TdExLocal;

  

  Begin

    ExLocal:=ListLocal;

    With MLocCtrl^,brBinRec do
    Begin




      Case Col of

         0  :  Begin
                 Result:=brBinCode1;

               end;


         1  :  Result:=Bin_AQty(brBuyQty,brQtyUsed,brBinCap,brBatchChild);

         2  :  Result:=POutDate(brDateIn);

         3  :  Result:=brInDoc;
         4  :  Result:=brOutDoc;
         5  :  Result:=brInMLoc;

         6  :  If (Not brBatchChild) then
                 Result:=Str_BinHoldStatus(brHoldFlg,brTagNo)
               else
                 Result:='';  

         7  :  Begin
                 If (Stock.StockFolio<>brStkFolio) then
                    CheckRecExsists(FullNomKey(brStkFolio),StockF,StkFolioK);

                 Result:=Stock.StockCode;

               end;



         else
               Result:='';
       end; {Case..}


     end; {With..}
  end;


    { ========== Generic Function to Return Formatted Display for List ======= }


  Function TSNoList.OutValLine(Col  :  Byte)  :  Str255;


  Var
    Idx    :  Integer;

    GenStr :  Str255;

    ExLocal: ^TdExLocal;

  Begin

    ExLocal:=ListLocal;

    With MiscRecs^,FIFORec do
    Begin




      Case Col of

         0  :  Result:=DocRef;

         1  :  Result:=PoutDate(FIFODate);
         2  :  Result:=FIFOCust;
         3  :  Result:=FormatFloat(GenQtyMask,FIFOQty);
         4  :  Result:=FormatFloat(GenQtyMask,QtyLeft);

         5  :  If (PChkAllowed_In(143)) then
                 Result:=FormatCurFloat(GenUnitMask[BOff],FIFOCost,BOff,FIFOCurr)
               else
                 Result:='';

         6  :  Result:=FIFOMLoc;

         else
               Result:='';
       end; {Case..}


     end; {With..}
  end;


  Function TSNoList.OutQBLine(Col  :  Byte)  :  Str255;


  Var
    Idx    :  Integer;

    GenStr :  Str255;

    ExLocal: ^TdExLocal;

  Begin

    ExLocal:=ListLocal;

    //PR: 07/02/2012 Amended to use new QtyBreak File. ABSEXCH-9795
    With QtyBreakRec do
    Begin

      Case Col of

         0  :  Result:=FormatFloat(GenQtyMask,qbQtyFrom);
         1  :  Result:=FormatFloat(GenQtyMask,qbQtyTo);
         2  :  Result:=FormatBChar(DiscountCharFromBreakType(qbBreakType),BOff);
         3  :  Result:=FormatCurFloat(GenUnitMask[BOn],qbSpecialPrice,BOn,qbCurrency);
         4  :  Result:=FormatBChar(qbPriceBand,BOff);
         5  :  Result:=FormatBFloat(GenPcntMask,qbDiscountPercent,BOn);
         6  :  Result:=FormatBFloat(GenUnitMask[BOn],qbDiscountAmount,BOn);
         7  :  Result:=FormatBFloat(GenPcntMask,qbMarginOrMarkup,BOn);

        8 :  If (qbUseDates) then
               Result:=POutDateB(qbStartDate)+' - '+POutDateB(qbEndDate)
             else
               Result:='';

         else
               Result:='';
       end; {Case..}


     end; {With..}
  end;


  Function TSNoList.OutCDLine(Col  :  Byte)  :  Str255;


  Var
    Idx    :  Integer;

    GenStr :  Str255;

    ExLocal: ^TdExLocal;

  Begin

    ExLocal:=ListLocal;

    With MiscRecs^,CustDiscRec do
    Begin

      Case Col of
                                  
         0  :  Begin
                 If (QBType <> QBValueCode) Then
                 Begin
                   If (Stock.StockCode<>QStkCode) then
                     Global_GetMainRec(StockF,QStkCode);

                   Result:=dbFormatName(QStkCode,Stock.Desc[1]);
                 End // If (QBType <> QBValueCode)
                 Else
                   // Value Based Discount - no Stock Code
                   Result := '';
               end;
         1  :  Result:=FormatBChar(QBType,BOff);
         2  :  Result:=FormatCurFloat(GenUnitMask[BOn],QSPrice,BOn,QBCurr);
         3  :  Result:=FormatBChar(QBand,BOff);
         // MH 03/11/2011 v6.9 ABSEXCH-11563: Modified to display discount percentage to 2dp
         4  :  Result:=FormatBFloat(GenPcnt2dMask,QDiscP,BOn);
         5  :  Result:=FormatBFloat(GenUnitMask[BOn],QDiscA,BOn);
         //TW 22/11/2011 v6.9 ABSEXCH-11563: Modded to show to decimal places for margin/markup
         6  :  Result:=FormatBFloat(GenPcnt2dMask,QMUMG,BOn);
         7 :  If (CUseDates) then
                Result:=POutDateB(CStartD)+' - '+POutDateB(CEndD)
              else
                Result:='';

         else
               Result:='';
       end; {Case..}


     end; {With..}
  end;

    { ========== Generic Function to Return Formatted Display for List ======= }


  Function TSNoList.OutLine(Col  :  Byte)  :  Str255;



  Begin
    Case DisplayMode of
      1    :  Result:=OutValLine(Col);
      2,3  :  Result:=OutQBLine(Col);
      4,5  :  Result:=OutSNoLine(Col);

      6    :  Result:=OutBinLine(Col);

      9    :  Result:=OutCDLine(Col);
      else    Result:='';
    end; {Case..}
  end;


  Procedure TSNoList.Intercept_ListClick(Mode      : SmallInt;
                                         MX,MY     :  LongInt);

  Var
    Message  :  TMessage;

  Begin
    If Assigned(StkCallBack) then
    Begin
      Blank(Message,Sizeof(MEssage));


      Message.LParamLo:=MX;
      Message.LParamHi:=MY;

      Message.Wparam:=Mode;


      TStockRec(StkCallBack).WMCustGetRec(Message);

    end;

  end;


  { =============== Procedure Sub Find on MultiPart Key ============ }

  Procedure TSNoList.GetMiniSERN(OMode     :   Byte);


  Const
    ModeMess  :  Array[1..4] of String[20] = ('Serial No.','Batch No.','Document No.','Bin Code');
    ModeNdx   :  Array[1..4] of Integer   = (MiscNdxK,MiscBtcK,MIK,MLK);

  Var
    InpOk       :  Boolean;

    KeyS,
    KeyChk      :  Str255;
    GMMode      :  Byte;

    SCode       :  String;



  Begin

    KeyChk:='';

    GMMode:=0;

    Begin
      KeyS:='';

      InpOk:=InputQuery('Find '+ModeMess[OMode],'Search for which '+ModeMess[OMode]+'?',SCode);


      {*EX32 if a copy last is required, set here *}


      If (InpOk) then
      Begin
        KeyS:=UpCaseStr(SCode);

        Case ScanFileNum of


          MiscF  :   Begin

                       Case OMode of

                         1    :  Begin

                                    KeyChk:=FullQDKey(MFIFOCode,MSERNSub,KeyS);

                                    KeyS:=KeyChk;

                                    Status:=Find_Rec(B_GetGEq,F[ScanFileNum],
                                                     ScanFileNum,RecPtr[ScanFileNum]^,ModeNdx[OMode],KeyS);

                                    If (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) then
                                    Begin
                                      AddNewRow(0,BOn);
                                    end;

                                  end;

                         2    :   Begin

                                    If (KeyS<>'') then
                                    Begin

                                      SerDocFilt:=KeyS;

                                      Filter[2,0]:='1';

                                      Filter[1,0]:='';
                                      //GS 11/10/2011 ABSEXCH-2901: clear the third
                                      //filter (location filter), it is not needed;
                                      //Chk_LocFilt will handle location filter
                                      Filter[3,0]:='';

                                    end
                                    else
                                      Filter[2,0]:='';

                                  end;

                         3    :   Begin

                                    If (KeyS<>'') then
                                    Begin

                                      SerDocFilt:=AutoSetInvKey(KeyS,0);

                                      Filter[1,0]:='1';

                                      Filter[2,0]:='';
                                      //GS 11/10/2011 ABSEXCH-2901: clear the third
                                      //filter (location filter), it is not needed;
                                      //Chk_LocFilt will handle location filter
                                      Filter[3,0]:='';
                                    end
                                    else
                                      Filter[1,0]:='';


                                  end;

                       end; {Case..}

                     end;
          MLocF  :   Begin

                       Case OMode of

                         4    :  Begin

                                    KeyChk:=FullQDKey(BRRecCode,MSERNSub,FullBinCode(KeyS));

                                    KeyS:=KeyChk;

                                    Status:=Find_Rec(B_GetGEq,F[ScanFileNum],
                                                     ScanFileNum,RecPtr[ScanFileNum]^,ModeNdx[OMode],KeyS);

                                    {* Keep searching until the one for this record is there *}
                                    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not LineOk(SetCheckKey)) do
                                    Begin
                                      Status:=Find_Rec(B_GetNext,F[ScanFileNum],
                                                     ScanFileNum,RecPtr[ScanFileNum]^,ModeNdx[OMode],KeyS);


                                    end;




                                    If (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) then
                                    Begin
                                      AddNewRow(0,BOn);
                                    end;

                                  end;
                       end; {Case..}
                     end; {Routine..}


        end; {Case..}

        If (Not (OMode In [1,4])) then
          InitPage;

      end;
    end;
  end;



{ ======= Link to Trans display ======== }

procedure TSNoList.Display_StkDoc(Mode  :  Byte);

Const
  Fnum     =  InvF;
  Keypath  =  InvOurRefK;

Var
  DispTrans  :  TFInvDisplay;
  KeyS       :  Str255;

Begin

  If (DispDocPtr=nil) then
  Begin
    DispTrans:=TFInvDisplay.Create(Self);
    DispDocPtr:=DispTrans;
  end
  else
    DispTrans:=DispDocPtr;

    try

      With DispTrans do
      Begin

        Case DisplayMode of
          1  :  With MiscRecs^.FIFORec do
                  KeyS:=DocRef;

          4  :  With MiscRecs^.SerialRec do
                Begin
                  Case Mode of
                    1  :  KeyS:=InDoc;
                    2  :  KeyS:=OutDoc;
                    3  :  KeyS:=OutOrdDoc;
                    4  :  KeyS:=InOrdDoc;
                  end;
                end;

          6  :  With MLocCtrl^.brBinRec do
                Begin
                  Case Mode of
                    1  :  KeyS:=brInDoc;
                    2  :  KeyS:=brOutDoc;
                    3  :  KeyS:=brOutOrdDoc;
                    4  :  KeyS:=brInOrdDoc;
                  end;
                end;
        end; {Case..}

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        If (StatusOk) then
        Begin
          LastDocHed:=Inv.InvDocHed;
          Display_Trans(0,0,BOff,BOn);
        end;

      end; {with..}

    except

      DispTrans.Free;

    end;

end;


procedure TSNoList.Display_StkRec(Mode  :  Byte);

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  DispStk    :  TFStkDisplay;
  KeyS       :  Str255;

Begin

  If (DispStkPtr=nil) then
  Begin
    DispStk:=TFStkDisplay.Create(Self);
    DispStkPtr:=DispStk;
  end
  else
    DispStk:=DispStkPtr;

    try

      With DispStk do
      Begin
        Case DisplayMode of
          6  :  With MLocCtrl^.brBinRec do
                  KeyS:=FullNomKey(brStkFolio);

          else  With MiscRecs^.SerialRec do
                  KeyS:=FullNomKey(StkFolio);
        end; {Case..}


        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        If (StatusOk) then
        Begin
          Display_Account(1);
        end;

      end; {with..}

    except

      DispStk.Free;

    end;

end;


{ ========== Procedure to Copy from one matrix into another ========= }


Procedure TSNoList.QB_CopyMatrix(TmpStock,
                                 StockR    :  StockRec;
                                 CCode     :  Str10;
                                 CSupCode  :  Char;
                                 DelQBMat  :  Boolean;
                                 ParentFolio: longint = 0);


Var
  KeyS,
  KeyChk   :   Str255;

  RecAddr  :   LongInt;

Begin

  Begin

    If (DelQBMat) then  {* Delete exisiting list *}
    Begin

      Case Displaymode of

        //PR: 18/04/2012 Was still using the old searchkey ABSEXCH-12830
        2  :  KeyChk := QtyBreakStartKey('', TmpStock.StockFolio);
        3  :  KeyChk := QtyBreakStartKey(CCode, TmpStock.StockFolio);

      end;

      DeleteLinks(KeyChk,ScanFileNum,Length(KeyChk),Keypath,BOff);

    end;


    //PR: 18/04/2012 Was still using the old searchkey ABSEXCH-12830
    KeyChk := QtyBreakStartKey('', StockR.StockFolio);

    KeyS:=KeyChk;


    Status:=Find_Rec(B_GetGEq,F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With QtyBreakRec do
    Begin

        Application.ProcessMessages;

        Status:=GetPos(F[ScanFilenum],ScanFilenum,RecAddr);  {* Preserve DocPosn *}

        If (StatusOk) then
        Begin

          qbStockFolio:=TmpStock.StockFolio;
          qbAcCode := LJVar(CCode, 6);
          qbFolio := ParentFolio;


          Status:=Add_Rec(F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,Keypath);

          Report_BError(ScanFilenum,Status);
        end;

        SetDataRecOfs(ScanFilenum,RecAddr);  {* Establish new Path *}

        Status:=GetDirect(F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,KeyPath,0);

        Status:=Find_Rec(B_GetNext,F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,KeyPath,KeyS);

      end; {While..}

  end; {With..}

end; {Proc..}




{ ========= Procedure to scan tree and set discounts ======== }


Procedure TSNoList.Update_QBTree(TmpStk     :  StockRec;
                                 Level      :  LongInt;
                                 LevelKey   :  Str255;
                             Var NoStop     :  Boolean;
                             Var MsgForm    :  TForm);

Const
  Fnum     =  StockF;

Var
  TmpKPath,
  TmpStat,
  Keypath
        :  Integer;

  TmpRecAddr
        :  LongInt;

  LFV   :  FileVar;

  LStk,
  TStk  :  StockRec;

  LKey  :  Str255;

  mbRet :  TModalResult;



Begin

  LStk:=Stock;

  KeyPath:=StkCatK;

  Begin

    LKey:=LevelKey;

    LFV:=F[Fnum];

    Inc(Level);

    Status:=Find_Rec(B_GetGEq,LFV,Fnum,RecPtr[Fnum]^,KeyPath,LKey);



    While (StatusOk) and (NoStop) and (CheckKey(LevelKey,LKey,Length(LevelKey),BOn)) do
    With Stock do
    Begin
      mbRet:=MsgForm.ModalResult;
      Loop_CheckKey(NoStop,mbRet);
      MsgForm.ModalResult:=mbRet;

      Application.ProcessMessages;

      TmpKPath:=KeyPath;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,LFV,TmpRecAddr,BOff,BOff);

      If (StockType=StkGrpCode) then
        Update_QBTree(TmpStk,Level,Stock.StockCode,NoStop,MsgForm)
      else
      Begin

        TStk:=Stock;

        Stock:=TmpStk;

        QB_CopyMatrix(TStk,Stock,'',QBDiscSub,BOn);

      end;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,LFV,TmpRecAddr,BOn,BOff);  {* Restore Bt Posn *}

      Status:=Find_Rec(B_GetNext,LFV,Fnum,RecPtr[Fnum]^,KeyPath,LKey);

    end; {While..}
  end; {With..}

  Stock:=LStk;

end; {Proc..}



{ =============== Procedure to Control Tree Update ============= }

Procedure TSNOList.QB_TreeUpdate;

Var
  NoStop  :  Boolean;
  mbRet   :  Word;
  MsgForm :  TForm;
  ExLocal : ^TdExLocal;

Begin

  ExLocal:=ListLocal;

  mbRet:=MessageDlg('Please confirm you wish to copy this Qty matrix into all lower levels',mtConfirmation,[mbYes,mbNo],0);

  NoStop:=(mbRet=mrYes);

  If (NoStop) then
  Begin
    MsgForm:=CreateMessageDialog('Please Wait.... Updating discounts.',mtInformation,[mbAbort]);
    MsgForm.Show;
    MsgForm.Update;

    Update_QBTree(ExLocal.LStock,0,ExLocal.LStock.StockCode,NoStop,MsgForm);

    MsgForm.Free;

    PageUpDn(0,BOn);
  end

end; {Proc..}




{ =============== Procedure Sub Find on MultiPart Key ============ }

Procedure TSNoList.Copy_QBStock(CCode      :  Str10;
                                CSupCode   :  Char;
                               ParentFolio : longint);


Var
  NomNum   :  Longint;
  KeyS     :  Str255;
  FoundCode:  Str20;
  GMMode   :  Byte;
  LOk,
  InpOk    :  Boolean;
  SCode    :  String;
  MsgForm  :  TForm;

  ExLocal  : ^TdExLocal;

  Begin

    ExLocal:=ListLocal;

    KeyS:='';

    InpOk:=InputQuery('Copy Discounts','Copy from which stock record?',SCode);


    If (InpOk) then
    Begin
      KeyS:=UpCaseStr(SCode);

      Case Displaymode of

         2..3   :  Begin

                     LOk:=GetStock(Owner,KeyS,FoundCode,0);

                     LOk:=((LOk) and ((Stock.StockCode<>ExLocal.LStock.StockCode) or (Displaymode=3)));

                     If (Not LOk) then
                       InpOk:=BOff;
                   end;

      end; {Case..}

      If (InpOk) then
      Begin

        MsgForm:=CreateMessageDialog('Please Wait.... Copying discounts.',mtInformation,[]);
        MsgForm.Show;
        MsgForm.Update;

        QB_CopyMatrix(ExLocal.LStock,Stock,CCode,CSupCode,BOn, ParentFolio);

        MsgForm.Free;

        InitPage;

      end
    end;

  end; {Proc..}

//PR: 18/04/2012 Class to store links between QtyBreak and CustDisc records:
//ValueFrom is the QtyBreakFolio of the existing records; ValueTo is the folio of the new records.
//ABSEXCH-12830
type
  TFolio = Class
    ValueFrom : longint;
    ValueTo   : longint;
  end;



{ ========== Procedure to Copy from one matrix into another ========= }

//PR: 18/04/2012 Amended function to copy qty breaks in the new file. ABSEXCH-12830
Procedure TSNoList.CD_CopyMatrix(TmpCust   :  CustRec;
                                 CCode     :  Str10;
                                 CSupCode  :  Char;
                                 DelCDMat  :  Boolean);


Var
  KeyS,
  KeyChk   :   Str255;

  RecAddr  :   LongInt;

  Loop     :   Boolean;

  ExLocal  : ^TdExLocal;

  //PR: 18/04/2012 ABSEXCH-12830
  FolioList : TObjectList;
  AFolio : TFolio;
  i : integer;
Begin

    ExLocal:=ListLocal;


    If (DelCDMat) then  {* Delete exisiting list & any Qty Breaks *}
    Begin

      KeyChk:=FullQDKey(CDDiscCode,CSupCode,FullCustCode(CCode));

      DeleteLinks(KeyChk,ScanFileNum,Length(KeyChk),Keypath,BOff);

      //PR: 18/04/2012 Change to delete QtyBreak records from new file ABSEXCH-12830
      KeyChk := CCode;
      DeleteLinks(KeyChk,QtyBreakF, Length(KeyChk), qbAcCodeIdx, BOff);

    end;

    FolioList := TObjectList.Create;
    Try

      With Cust do
      Begin

        KeyChk:=FullQDKey(CDDiscCode,CSupCode,FullCustCode(CustCode));

        KeyS:=KeyChk;


        Status:=Find_Rec(B_GetGEq,F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,KeyPath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With MiscRecs^ do
        Begin

          Status:=GetPos(F[ScanFilenum],ScanFilenum,RecAddr);  {* Preserve DocPosn *}

          If (StatusOk) then
          Begin

            With CustDiscRec do
            Begin

              DCCode:=CCode;

              DiscCode:=MakeCDKey(DCCode,QStkCode,QBCurr)+HelpKStop;

              //Need to store folio links for QtyBreak records.
              if QBType = QBQtyBCode then
              begin
                AFolio := TFolio.Create;
                AFolio.ValueFrom := QtyBreakFolio;
                AFolio.ValueTo := GetNextQtyBreakFolio;
                QtyBreakFolio := AFolio.ValueTo;
                FolioList.Add(AFolio);
              end;

            end;


            Status:=Add_Rec(F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,Keypath);

            Report_BError(ScanFileNum,Status);

          end;

          SetDataRecOfs(ScanFilenum,RecAddr);  {* Establish new Path *}

          Status:=GetDirect(F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,KeyPath,0);

          Status:=Find_Rec(B_GetNext,F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,KeyPath,KeyS);

        end; {While..}

      end; //with Cust

      //All MiscF discounts have been copied and we have QtyBreak folios in FolioList. Now run through list
      //copying records
      for i := 0 to FolioList.Count - 1 do
      begin
        AFolio := (FolioList[i] as TFolio);
        KeyS := FullNomKey(AFolio.ValueFrom);

        Status := Find_Rec(B_GetGEq, F[QtyBreakF], QtyBreakF, QtyBreakRec, qbFolioIdx, KeyS);

        while (Status = 0) and (QtyBreakRec.qbFolio = AFolio.ValueFrom) do
        begin
          Status:=GetPos(F[QtyBreakF], QtyBreakF, RecAddr);  //Save position

          //Set changed fields
          QtyBreakRec.qbFolio := AFolio.ValueTo;
          QtyBreakRec.qbAcCode := CCode;

          //Store record
          Status:=Add_Rec(F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, qbFolioIdx);
          Report_BError(QtyBreakF,Status);

          //Restore position
          SetDataRecOfs(QtyBreakF,RecAddr);
          Status:=GetDirect(F[QtyBreakF],QtyBreakF,RecPtr[QtyBreakF]^,qbFolioIdx,0);

          //Next record
          Status:=Find_Rec(B_GetNext, F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, qbFolioIdx,KeyS);

        end; //while
      end;
    Finally
      FolioList.Free;
    End;

end; {Proc..}


{ ========= Procedure to scan tree and set discounts ======== }


Procedure TSNoList.Update_CDAcc(CSupCode   :  Char;
                            Var NoStop     :  Boolean;
                            Var MsgForm    :  TForm);

Const

  Fnum     =  CustF;
  Keypath  =  CustCodeK;


Var
  TmpKPath,
  TmpStat
        :  Integer;

  TmpRecAddr
        :  LongInt;

  LFV   :  FileVar;


  LCust,
  TCust :  CustRec;

  LKey  :  Str255;

  ExLocal
        : ^TdExLocal;

  LRepFilt,
  RepFilt
        :  Str10;


  mbRet : TModalResult;


Begin

  ExLocal:=ListLocal;


  LCust:=ExLocal.LCust;

  LRepFilt:=LJVar(LCust.RepCode,CustACTLen);

  Begin

    Blank(LKey,Sizeof(LKey));

    LFV:=F[Fnum];

    Status:=Find_Rec(B_GetGEq,LFV,Fnum,RecPtr[Fnum]^,KeyPath,LKey);



    While (StatusOk) and (NoStop) do
    With Cust do
    Begin

      mbRet:=MsgForm.ModalResult;
      Loop_CheckKey(NoStop,mbRet);
      MsgForm.ModalResult:=mbRet;

      Application.ProcessMessages;


      TmpKPath:=Keypath;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,LFV,TmpRecAddr,BOff,BOff);

      RepFilt:=LJVar(Cust.RepCode,CustACTLen);

      If (CustSupp=CSupCode) and (CustCode<>LCust.CustCode)
         and (CheckKey(LRepFilt,RepFilt,Length(LRepFilt),BOff)) then

      Begin
        TCust:=Cust;

        Cust:=LCust;

        CD_CopyMatrix(TCust,TCust.CustCode,TCust.CustSupp,BOn);

      end;


      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,LFV,TmpRecAddr,BOn,BOff);

      Status:=Find_Rec(B_GetNext,LFV,Fnum,RecPtr[Fnum]^,KeyPath,LKey);

    end; {While..}
  end; {With..}

  Cust:=LCust;

end; {Proc..}



{ =============== Procedure to Control Tree Update ============= }

Procedure TSNoList.CD_AccUpdate(CSupCode   :  Char);

Var
  NoStop   :  Boolean;
  MsgForm  :  TForm;

  ExLocal  : ^TdExLocal;

  mbRet    : Word;

Begin

  ExLocal:=ListLocal;

  mbRet:=MessageDlg('Please confirm you wish to copy discount to the same type accounts.',mtConfirmation,[mbYes,mbNo],0);

  NoStop:=(mbRet=mrYes);

  If (NoStop) then
  Begin
    MsgForm:=CreateMessageDialog('Please Wait.... Updating discounts.',mtInformation,[mbAbort]);
    MsgForm.Show;
    MsgForm.Update;

    Update_CDAcc(CSupCode,NoStop,MsgForm);

    MsgForm.Free;

    PageUpDn(0,BOn);
  end;

end; {Proc..}



{ =============== Procedure Sub Find on MultiPart Key ============ }

Procedure TSNoList.Copy_CDStock(CCode      :  Str10;
                                CSupCode   :  Char);


Var
  NomNum   :  Longint;
  KeyS     :  Str255;
  FoundCode:  Str20;
  GMMode   :  Byte;
  TmpCust  :  ^CustRec;
  LOk,
  InpOk    :  Boolean;
  SCode    :  String;
  MsgForm  :  TForm;

  ExLocal  : ^TdExLocal;

Begin

  ExLocal:=ListLocal;

  New(TmpCust);

  TmpCust^:=ExLocal^.LCust;

  SCode:='';

  Begin
    KeyS:='';

    InpOk:=InputQuery('Copy Discounts','Copy from which account record?',SCode);


    If (InpOk) then
    Begin
      KeyS:=UpCaseStr(SCode);


      Case Displaymode of

         9      :  Begin

                     LOk:=GetCust(Self.Parent,KeyS,FoundCode,IsACust(CSupCode),0);

                     LOk:=((LOk) and (Cust.CustCode<>TmpCust^.CustCode));

                     If (Not LOk) then
                       InpOk:=BOff;
                   end;

      end; {Case..}


      If (InpOk) then
      Begin
        MsgForm:=CreateMessageDialog('Please Wait.... Copying discounts.',mtInformation,[]);
        MsgForm.Show;
        MsgForm.Update;

        CD_CopyMatrix(TmpCust^,CCode,CSupCode,BOn);

        MsgForm.Free;

        InitPage;

      end
    end;

  end; {With..}

  Cust:=TmpCust^;

  Dispose(TmpCust);

end;

  Function TSNoList.FindxDiscCode(KeyChk  :  Str255;
                                  SM      :  SmallInt)  :  Boolean;


  Var
    OKeyS     :  Str255;

  Begin

    OKeyS:=KeyChk;


    Status:=Find_Rec(B_GetGEq,F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,KeyPath,OKeyS);

    If (Status=0) and (CheckKey(KeyChk,OKeyS,Length(KeyChk),BOff)) and (LineOk(SetCheckKey)) then
    Begin
      Result:=BOn;
      Status:=GetPos(F[ScanFilenum],ScanFilenum,PageKeys^[0]);

      MUListBoxes[0].Row:=0;
      PageUpDn(0,BOn);
    end
    else
      Result:=BOff;

  end;


{$ENDIF}

{ =================================================================================== }




//PR: 07/10/2011 ABSEXCH-11736 Under MS-SQL, EL's standard way of checking for the last serial/batch record for a stock item doesn't work
//correctly, so override the SetEndKey method and correct the key if we're using MS-SQL
//PR: 10/10/2011 Forgot to include IFDEF STK - D'oh!
{$IFDEF STK}
procedure TSNoList.SetEndKey(var KeyS: Str255);
var
  i : longint;
begin
  // CJS 2016-01-27 - ABSEXCH-16900 - Cannot jump to end of discount list on Traders
  if SQLUtils.UsingSQL and UseAlternativeEndKey then
  begin
    Move(KeyS[3], i, SizeOf(i));
    inc(i);
    Move(i, KeyS[3], SizeOf(i));
  end
  else
    inherited;
end;
{$ENDIF}
end.
