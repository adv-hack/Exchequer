Unit SOPCt4U;

{$I DEFOVR.INC}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 17/01/2000                    }
{                 SOP Process Control Unit IV                  }
{                                                              }
{                                                              }
{               Copyright (C) 2000 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses
  GlobVar,
  VarConst,
  BTSupU3,
  PostingU,
  ExBtTh1U;



{$IFDEF SOP}

Type

    TAcruDel  =  Object(TEntPost)

                     private
                       RPParam  :  TPrintParamPtr;
                       RYr,RPr  :  Byte;
                     public
                       SalesMode  :  Boolean;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Reset_NomAcrualLines(InvR      :  InvRec);

                       Procedure Add_AcrualLine(BSNCode,
                                                PLNCode :  LongInt;
                                                STKValue:  Double;
                                                ORStr   :  Str10;
                                                MultiLine
                                                        :  Boolean;
                                                IdR     :  IDetail;
                                           Var  Abort   :  Boolean;
                                                BInv    :  InvRec);

                       Procedure Gen_DelAcrual(Var GotHed        :  Boolean);

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start(SMode  :  Boolean)  :  Boolean;


                   end; {Class..}


      Procedure AddAcruDel2Thread(AOwner   :  TObject;
                                  SMode    :  Boolean);


    Type
      TRemoveCommit  =  Object(TEntPost)

                     private

                     public

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start  :  Boolean;


                   end; {Class..}

       Procedure AddRemCommit2Thread(AOwner   :  TObject;
                                     SMode    :  Boolean);


       Function Conv_Create_CommitObject(Remove  :  Boolean;
                                         OldPtr  :  Pointer )  :  Pointer;

       procedure Conv_Update_LiveCommit(IdR     :  IDetail;
                                        DedMode :  SmallInt;
                                    Var OldPtr  :  Pointer);

  {$ENDIF}





 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Dialogs,
   Controls,
   Forms,

   {$IFDEF Rp}
     RpDefine,
   {$ENDIF}

   Graphics,
   ETMiscU,
   ETDateU,
   BtrvU2,
   VarFPosU,
   ComnUnit,
   ComnU2,
   ETStrU,
   CurrncyU,
   Excep2U,
   {$IFDEF FRM}
     PrintFrm,
   {$ENDIF}

   GenWarnU,
   ReValU2U,
   MiscU,
   SysU1,

   SysU2,
   
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

   BTSupU1,
   BTKeys1U,
   ExThrd2U, ExWrap1U;




{$IFDEF SOP}
    { ========== TAcrueDel methods =========== }

    Constructor TAcruDel.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOff;

    IsParentTo:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

    New(RPParam);

    Try
      With RPParam^ do
      Begin
        FillChar(RPParam^,Sizeof(RPParam^),0);

        UFont:=TFont.Create;

        try
          UFont.Assign(Application.MainForm.Font);
        except
          UFont.Free;
          UFont:=nil;
        end;

        {$IFDEF Rp}
          Orient:=RPDefine.PoLandscape;
        {$ENDIF}


        With PDevRec do
        Begin
          DevIdx:=-1;
          Preview:=BOn;
          NoCopies:=1;
        end;
      end;

    except
      RPParam:=nil;
    end;


  end;

  Destructor TAcruDel.Destroy;

  Begin
    If (Assigned(RPParam)) then
    Begin

      RPParam.UFont.Free;

      Dispose(RPParam);
    end;

    Inherited Destroy;
  end;


    { ========= Procedure to reset Nom Txfr Lines Run No, in line with header ========= }

  Procedure TAcruDel.Reset_NomAcrualLines(InvR      :  InvRec);

  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;


  Var
    KeyS,
    KeyChk   :  Str255;



  Begin

    With MTExLocal^ do
    Begin

      KeyChk:=FullNomKey(InvR.FolioNum);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      Begin
        With LId do
        Begin

          PostedRun:=0;

          LStatus:=LPut_Rec(Fnum,KeyPath);

          LReport_BError(Fnum,LStatus);

        end; {If Ok to Use..}

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}

      {* Mop up any stray lines from other runs *}

      KeyS:=FullNomKey(DelAcrualRunNo);

      LDeleteLinks(KeyS,IDetailF,Length(KeyS),IdRunK,BOff);


    end; {With..}
  end; {Proc..}

  { ========================= Store Valuation Lines  ===================== }

  Procedure TAcruDel.Add_AcrualLine(BSNCode,
                                    PLNCode :  LongInt;
                                    STKValue:  Double;
                                    ORStr   :  Str10;
                                    MultiLine
                                            :  Boolean;
                                    IdR     :  IDetail;
                               Var  Abort   :  Boolean;
                                    BInv    :  InvRec);

  Const
    Fnum    =  IDetailF;
    Keypath =  IdRunK;


  Var
    Done,
    FoundOk
           :  Boolean;

    KeyS,
    KeyChk :  Str255;

    TNCode :  LongInt;


  Begin

    With MTExLocal^,IdR do
    Begin
      Done:=BOn;

      TNCode:=BSNCode;

      Repeat

        If (Not MultiLine) then {*EN422}
        Begin
          KeyChk:=Strip('R',[#0],FullRunNoKey(DelAcrualRunNo,TNCode));
          KeyS:=FullRunNoKey(DelAcrualRunNo,TNCode);

          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

          FoundOk:=BOff;

          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) and (Not ThreadRec^.THAbort) do
          With LId do
          Begin
            FoundOk := CCDepMatch(BOn,IdR.CCDep) and
                       (Currency = IdR.Currency) and
                       (CXRate[True]  = IdR.CXRate[True]) and
                       (CXRate[False] = IdR.CXRate[False]);

            If (Not FoundOk) then
              LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

          end;
          If (Not FoundOk) then
            LStatus:=4;
        end
        else
          LStatus:=4;  {* Force a not found for each line *}

        If (LStatusOk) then
        Begin

          LId.NetValue:=LId.NetValue+StkValue;


          LStatus:=LPut_Rec(Fnum,KeyPath);

        end
        else
        Begin

          Create_NomTxfrLines(LId,MTExLocal);

          With LId do
          Begin

            NomCode:=TNCode;

            If (MultiLine) then
            Begin
              If (Is_FullStkCode(IdR.StockCode)) then
              Begin
                If (LStock.StockCode<>IdR.StockCode) then
                  LGetMainRecPos(StockF,IdR.StockCode);

                Desc:=Copy(ORStr+': '+Strip('R',[#32],LStock.StockCode)+'. '+LInv.TransDesc+'. Accrual as at '+PoutDate(Today),1,50);
              end
              else
                Desc:=ORStr+': '+LInv.TransDesc+'. Line '+Form_Int(IdR.LineNo,0)+'. Accrual as at '+PoutDate(Today);
            end
            else
              Desc:=DocGroup[Ord(SalesMode)+1]+' Accrual as at '+PoutDate(Today);

            PostedRun:=DelAcrualRunNo;

            NetValue:=StkValue;

            CCDep:=IdR.CCDep;

            Currency:=IdR.Currency;

//            CXRate:=SyssCurr.Currencies[Currency].CRates;
            CXRate := BInv.CXrate;

            SetTriRec(Currency,UseORate,CurrTriR);

            LStatus:=LAdd_Rec(Fnum,KeyPath);
          end; {With..}

        end; {If Add needed}


        LReport_BError(Fnum,LStatus);

        Abort:=Not LStatusOk;

        Done:=Not Done;

        TNCode:=PLNCode;

        StkValue:=StkValue*DocNotCnst;

      Until (Done) or (Abort);
    end; {With..}
  end; {Proc..}


  { =========== Procedure to Scan Adjustment Documents and Adjust posted stock ========= }

 Procedure TAcruDel.Gen_DelAcrual(Var GotHed        :  Boolean);


 Const
    Fnum     =  IDetailF;
    KeyPath  =  IdFolioK;
    SFnum    =  InvF;
    SKeyPath =  InvRNoK;

    SPRunNo    :  Array[BOff..BOn] of LongInt = (OrdUPRunNo,OrdUSRunNo);
    SPDocType  :  Array[BOff..BOn] of NomCtrlType = (PurchComm,SalesComm);



  Var
    KeyS,
    KeyI,
    KeyChkI,
    KeyChk   :  Str255;

    SRecAddr,
    RecAddr  :  LongInt;

    LOk,
    WarnAbort,
    Locked,
    TTEnabled,
    Abort    :  Boolean;

    Count,
    SBSNom,
    WOFFNom  :  LongInt;

    LineCost :  Double;
    BInv,
    NInv     :  InvRec;


  Begin

    RecAddr:=0;

    Abort:=BOff;

    TTEnabled:=BOff;  LOk:=BOff;  Locked:=BOff;

    WOFFNom:=0;
    SBSNom:=0;  KeyI:='';

    LineCost:=0.0;  WarnAbort:=BOff;  Count:=0;

    With MTExLocal^ do
    Begin
      KeyChkI:=FullNomKey(SPRunNo[SalesMode]);
      KeyI:=KeyChkI;

      LStatus:=LFind_Rec(B_GetGEq,SFnum,SKeyPath,KeyI);

      While (LStatusOk) and (CheckKey(KeyChkI,KeyI,Length(KeyChkI),BOn)) and (Not ThreadRec^.THAbort) do
      With LInv do
      Begin
        Inc(Count);

        UpdateProgress(Count);


        If (InvDocHed In DeliverSet) and (Pr2Fig(ACYr,ACPr)<=Pr2Fig(RYr,RPr)) then
        Begin
          KeyChk:=FullNomKey(FolioNum);
          KeyS:=FullIdKey(FolioNum,1);

          LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

          BInv:=LInv;

          ShowStatus(2,'Checking '+OurRef);

          LStatus:=LGetPos(SFnum,SRecAddr);

          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
          With LId do
          Begin
            If (SalesMode) then
            Begin
              LineCost:=InvLCost(LId)*DocCnst[IdDocHed];

              If (LStock.StockCode<>StockCode) and (Is_FullStkCode(StockCode)) then {* Go get Stock Record*}
                LGetMainRecPos(StockF,StockCode);
            end
            else
              LineCost:=DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0);

            If (Not WarnAbort) and (ThreadRec^.THAbort) then
            Begin
              ShowStatus(3,'Please wait, finishing current transaction.');
              WarnAbort:=BOn;
            end;

            If (LineCost<>0.0) and ((Is_FullStkCode(StockCode)) or (Not SalesMode)) then
            Begin
              ShowStatus(2,'Processing '+BInv.OurRef+' Line '+Form_Int(LineNo,0));

              If (Not GotHed) then  {* Generate Nom Txfr Header *}
              Begin
                {Modes... 7 = One Nom for all posted Delivery notes's
                }


                If (TranOk2Run) then
                Begin
                  LStatus:=LCtrl_BTrans(1);

                  TTEnabled:=LStatusOk;

                  {* Wait until All clear b4 continuing *}
                  If (TTEnabled) then
                    WaitForHistLock;

                end;

                Create_NTHedInv(Abort,GotHed,'',7,BInv,MTExLocal,False,True);

                If (GotHed) then
                  NInv:=LInv;

                If (TTEnabled) and (Syss.ProtectPost) then
                With MTExLocal^ do
                Begin
                  UnLockHistLock;

                  LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                  LReport_BError(InvF,LStatus);
                end;
              end
              else
                LInv:=NInv;

              If (GotHed) then
              Begin
                If (TranOk2Run) then
                Begin
                  LStatus:=LCtrl_BTrans(1);

                  TTEnabled:=LStatusOk;

                  {* Wait until All clear b4 continuing *}
                  If (TTEnabled) then
                    WaitForHistLock;

                end;

                LStatus:=LGetPos(Fnum,RecAddr);

                If (SalesMode) then
                Begin
                  If (LStock.StockType=StkBillCode) then
                    SBSNom:=LStock.NomCodeS[5]
                  else
                    SBSNom:=LStock.NomCodeS[4];
                end
                else
                  SBSNom:=NomCode;

                WOFFNom:=Syss.NomCtrlCodes[SPDocType[SalesMode]];

                Add_AcrualLine(SBSNom,WOFFNom,LineCost,BInv.OurRef,Syss.SepRunPost,LId,Abort, BInv);

                LSetDataRecOfs(Fnum,RecAddr);

                LStatus:=LGetDirect(Fnum,KeyPath,0);

                If (TTEnabled) and (Syss.ProtectPost) then
                With MTExLocal^ do
                Begin
                  UnLockHistLock;

                  LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                  LReport_BError(InvF,LStatus);
                end;
              end; {If gotHed}
            end; {If Line OK}

            LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
          end; {Lines..}

          LSetDataRecOfs(SFnum,SRecAddr);

          LStatus:=LGetDirect(SFnum,SKeyPath,0);

        end; {If wrong trans type..}

        LStatus:=LFind_Rec(B_GetNext,SFnum,SKeyPath,KeyI);

      end; {Headers..}
    end; {With..}


    If (GotHed) then
    Begin

      Reset_NomAcrualLines(NInv);
    end;
  end; {Proc..}


  { == Proc to generate the acrual lines == }


  Procedure TAcruDel.Process;

  Var
    InvCount  : LongInt;
    StartedOk,
    GotHed    : Boolean;



  Begin
    InMainThread:=BOn;  GotHed:=BOff;  StartedOk:=BOff;

    Inherited Process;

    ShowStatus(0,'Generate Delivery Accruals');

    With MTExLocal^ do
    Begin

      InvCount:=Used_RecsCId(LocalF^[InvF],InvF,ExCLientId);

      InitProgress(InvCount);

      UpdateProgress(0);

      Gen_DelAcrual(GotHed);

      UpdateProgress(InvCount);

      If (GotHed) and (Not ThreadRec^.THAbort) then
        AddPost2Thread(3,fMyOwner,fMyOwner,BOff,RPParam,nil,StartedOk);
    end;


  end;


  Procedure TAcruDel.Finish;
  Begin
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;



  Function TAcruDel.Start(SMode  :  Boolean)  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Set_BackThreadMVisible(BOn);

    RYr:=GetLocalPr(0).CYr;
    RPr:=GetLocalPr(0).CPr;

    mbRet:=CustomDlg(Application.MainForm,'Generate Accrual','Generate the '+DocGroup[Succ(Ord(SMode))]+' accrual.',
                             'This process will generate accruals for '+DocGroup[Succ(Ord(SMode))]+' delivery notes '+
                             'upto and including the current period '+PPR_OutPr(RPr,RYr)+#13+#13+
                             'Please confirm you wish to generate the '+DocGroup[Succ(Ord(SMode))]+' accrual.',
                             mtConfirmation,
                             [mbYes,mbNo],BOn);

    Result:=(mbRet=mrOk);

    If (Result) then
    With RPParam^ do
    Begin

      {$IFDEF Frm}
        Result:=pfSelectPrinter(PDevRec,UFont,Orient);
      {$ENDIF}

    end;

    Set_BackThreadMVisible(BOff);


    If (Result) then {* Check for valid NCC *}
    Begin
      Result:=CheckValidNCC(BOn);

      If (Not Result) then
      Begin
        AddErrorLog('Generate Accruals. One or more of the General Ledger Control Codes is not valid, or missing.','',4);

        CustomDlg(Application.MainForm,'WARNING!','Invalid G/L Control Codes',
                       'One or more of the General Ledger Control Codes is not valid, or missing.'+#13+
                       'The auto accrual cannot continue until this problem has been rectified.'+#13+#13+
                       'Correct the Control Codes via Utilities/System Setup/Control Codes, then try again.',
                       mtError,
                       [mbOk]);


      end;

    end;


    If (Result) then
    Begin
      If (Not Assigned(MTExLocal)) then { Open up files here }
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
            New(MTExLocal,Create(41));

            try
              With MTExLocal^ do
                Open_System(CustF,MiscF);

            except
              Dispose(MTExLocal,Destroy);
              MTExLocal:=nil;

            end; {Except}

            Result:=Assigned(MTExLocal);
        end;
      end;
      If (Result) then
      Begin
        SalesMode:=SMode;
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


  Procedure AddAcruDel2Thread(AOwner   :  TObject;
                              SMode    :  Boolean);


  Var
    LAcruDel :  ^TAcruDel;
    CIDMode    :  Integer;

  Begin

    If (Create_BackThread) then
    Begin
      New(LAcruDel,Create(AOwner));

      try
        With LAcruDel^ do
        Begin

          If (Start(SMode)) and (Create_BackThread) then
          Begin

            With BackThread do
              AddTask(LAcruDel,'Generate Accruals');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LAcruDel,Destroy);
          end;
        end; {with..}

      except
        Dispose(LAcruDel,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


  { ========== TRemoveCommit methods =========== }

    Constructor TRemoveCommit.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOff;

    IsParentTo:=BOn;

    fOwnMT:=BOff; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;


  end;

  Destructor TRemoveCommit.Destroy;

  Begin

    Inherited Destroy;
  end;


  { == Proc to remove commitment lines == }


  Procedure TRemoveCommit.Process;


  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Remove Committed Balances');

    Remove_LastCommit;

  end;


  Procedure TRemoveCommit.Finish;
  Begin
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;


  Function TRemoveCommit.Start  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('Please Confirm you wish to remove all the commitment balances.',mtConfirmation,[mbYes,mbNo],0);

    Result:=(mbRet=mrYes);


    Set_BackThreadMVisible(BOff);

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
    end;
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}

  end;



  Procedure AddRemCommit2Thread(AOwner   :  TObject;
                                SMode    :  Boolean);


  Var
    LAcruDel :  ^TRemoveCommit;
    CIDMode    :  Integer;

  Begin

    If (Create_BackThread) then
    Begin
      New(LAcruDel,Create(AOwner));

      try
        With LAcruDel^ do
        Begin

          If (Start) and (Create_BackThread) then
          Begin

            With BackThread do
              AddTask(LAcruDel,'Remove Committed Bals');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LAcruDel,Destroy);
          end;
        end; {with..}

      except
        Dispose(LAcruDel,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;

  {Functions/Procedures to allow the live committed balance to be updated from quote-> orders and copy/reverse transactions}

  Function Conv_Create_CommitObject(Remove  :  Boolean;
                                    OldPtr  :  Pointer )  :  Pointer;

  Var
    PostObj  :  ^TEntPost;
  Begin
    If (Not Assigned(OldPtr)) and (Not Remove) then
    Begin
      New(PostObj,Create(Application.MainForm));

      Try
        If (Not PostObj^.Start(50,nil,nil,BOff)) then
        Begin
          Dispose(PostObj,Destroy);
          PostObj:=nil;
        end;

      except
        Dispose(PostObj,Destroy);
        PostObj:=nil;
      end; {Try..}

      Result:=@PostObj^;

    end
    else
      If (Remove) and (Assigned(OldPtr)) then
      Begin
        PostObj:=OldPtr;

        Dispose(PostObj,Destroy);
        OldPtr:=nil;

      end;
  end;

  procedure Conv_Update_LiveCommit(IdR     :  IDetail;
                                   DedMode :  SmallInt;
                               Var OldPtr  :  Pointer);

  Var
    PostObj  :  ^TEntPost;

  Begin
    If (Assigned(OldPtr)) and (CommitAct) and (IdR.IdDocHed In CommitLSet) then
    Begin
        PostObj:=OldPtr;
        try
          PostObj^.Update_LiveCommit(IdR,DedMode);
        except
          Dispose(PostObj,Destroy);
          OldPtr:=nil;
        end;
    end;
  end;


{$ENDIF}


end. {Unit..}