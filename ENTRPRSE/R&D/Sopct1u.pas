Unit SOPCT1U;

{$I DEFOVR.INC}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 22/01/96                      }
{                   SOP Process Control Unit                   }
{                                                              }
{                                                              }
{               Copyright (C) 1996 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses
  GlobVar,
  VarConst,
  BTSupU3,
  FrmThrdU,
  ExBtTh1U;



  {$IFDEF STK}

Type

    TPrintPickRun      =  Object(TPrintBPForm)

                             private

                               Procedure SOP_BuildProdLab(DocFolio  :  LongInt;
                                                      Var FoundOk   :  Boolean;
                                                          Fnum,Keypath
                                                                    :  Integer;
                                                          MatchK    :  Str255);

                                 Procedure SetForm(Var RForm        :  Str255;
                                                       PCustomEvent :  Pointer;
                                                       UseCustom    :  Boolean);

                               Procedure Print_PickRun;


                             public
                               PickRepPtr  :  PPickRepPtr;

                               Constructor Create(AOwner  :  TObject);

                               Destructor  Destroy; Virtual;

                               Procedure Process; Virtual;
                               Procedure Finish;  Virtual;

                               Function Start(CIDMode  :  Integer)  :  Boolean;


                           end; {Class..}

    Procedure AddPick2Thread(AOwner   :  TObject;
                             PickRep  :  PPickRepPtr);

  {$ENDIF}




  Procedure Set_OrderTag(Fnum,
                         KeyPath  :  Integer;
                         LAddr    :  LongInt;
                         TagNo    :  Byte);


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   RpDefine,
   SysUtils,
   Forms,
   Dialogs,
   ETMiscU,
   ETDateU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   ETStrU,
   CurrncyU,

   {$IFDEF STK}


     InvListU,
     MiscU,
     InvCTSUU,
     InvFSU2U,

     SOPCT2U,
     SOPCT3U,

     SCRTCH1U,
     SCRTCH2U,
     PrintFrm,

     {$IFDEF FRM}
       DLLInt,
       PrntDlg2,
       GlobType,
     {$ENDIF}

     {$IFDEF CU}
       {Event1U,}
       CustIntU,
       CustWinU,
       OInv,

     {$ENDIF}
   {$ENDIF}
   SysU1,
   SysU2,
   BTSupU1,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

   BTKeys1U,
   ExThrd2U,
   AccountContactRoleUtil;




{$IFDEF STK}
    { ========== TPrintPickRun methods =========== }

  Constructor TPrintPickRun.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    BaseObj:=BOff;

    ChildProcess:=BOn;

    fTQNo:=2;
    fCanAbort:=BOn;

     fOwnMT:=BOff; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

    New(PickRepPtr);

    FillChar(PickRepPtr^,Sizeof(PickRepPtr^),0);

    With PickRepPtr^ do
    Begin
      With PParam,PDevRec do
      Begin
        PBatch:=BOn;
        Preview:=BOff;
        NoCopies:=1;
        Orient:=poPortrait;
        UFont:=Nil;
      end;
    end; {With..}
  end;


  Destructor TPrintPickRun.Destroy;

  Begin

    Dispose(PickRepPtr);

    Inherited Destroy;


  end;



  { ======= Proc to Build List of Delivered Labels ====== }

  Procedure TPrintPickRun.SOP_BuildProdLab(DocFolio  :  LongInt;
                                       Var FoundOk   :  Boolean;
                                           Fnum,Keypath
                                                     :  Integer;
                                           MatchK    :  Str255);


  Var
    KeyS,KeyChk  :   Str255;

    TestOnly,
    Ok2Print     :   Boolean;

    RecAddr      :   LongInt;

    TmpKPath,
    TmpStat      :   Integer;

    TmpRecAddr
                 :   LongInt;

    TmpId        :   IDetail;

    RForm        :   Str20;


  Begin
    Ok2Print:=BOn;

    TestOnly:=BOff;

    With MTExLocal^ do
    Begin

      RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[21];
    {$IFDEF FRM}
      PickRepPtr^.PParam.PDevRec.NoCopies:=GetFormCopies(RForm);
    {$ENDIF}


      TmpId:=LId;

      TmpKPath:=GetPosKey;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);


      KeyChk:=FullNomKey(DocFolio);

      KeyS:=FullIdKey(DocFolio,1);  {* Bypass BOM lines *}


      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) and (Ok2Print) and (Not TestOnly) do
      With PickRepPtr^.PParam, LId do
      Begin

        If (Is_FullStkCode(StockCode) and (Qty<>0)) then {This line is being delivered}
        Begin

          FoundOk:=BOn;

          {$IFDEF FRM}


            Ok2Print:=pfAddBatchForm(PDevRec,26,RForm,
                                     IDetailF,IdLinkK,FullIdKey(FolioRef,ABSLineNo),IDetailF,-1,'',
                                     '',
                                     NIL,
                                     BOff);

          {$ENDIF}

          TestOnly:=PDevRec.TestMode;

        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        
      end; {While..}

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      Id:=TmpId;
    end; {With..}
  end; {Proc..}





  { ======== Procedure to Print Selected Picking List ======= }

  { Print Modes
               1  Individual picking lists
               2  Individual Delivery Notes
               3  Consignment notes
               4  Labels
               5  Product Labels
               6  Sales Invoices
               7  Issue Notes
               8  Consolidated Issue Note / Not used!
               9  Built Works Order
               10 Works Individual picking lists
               11 Returns - Associated docs generated via action, so form is automatic

  }

  Procedure TPrintPickRun.SetForm(Var RForm        :  Str255;
                                      PCustomEvent :  Pointer;
                                      UseCustom    :  Boolean);
  Const
    FormNDX  :  Array[1..11] of Byte = (17,13,19,20,21,6,48,32,48,50,62);

  Var
    {$IFDEF CU}

      CustomEvent  :  TCustomEvent;

    {$ELSE}
      n  :  Byte;

    {$ENDIF}


  Begin
    With PickRepPtr^,PParam,MTExLocal^ do
    Begin
      If (LCust.CustCode<>LInv.CustCode) then {* Get Cust record for form def switch over *}
        LGetMainRec(CustF,LInv.CustCode);


      If (PRMode In [1]) then
      Begin
        If (LCust.FDefPageNo>0) then
          RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[DefMode+4]
        else
          RForm:=LRForm;
      end
      else
        RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[FormNDX[PRMode]];

      {$IFDEF FRM}
        PDevRec.NoCopies:=GetFormCopies(RForm);

        {$IFDEF CU}

           If (Assigned(PCustomEvent)) and (UseCustom) and (PRMode In [2,6]) then
           Begin
             CustomEvent:=PCustomEvent;

             With CustomEvent do
             Begin
               TInvoice(EntSysObj.Transaction).ResetTrans(LInv);

               Execute;


             end;

             With PDevRec do
               {NoCopies:=IntExitHook(2000,04+Ord(PRMode=6),NoCopies,MTExLocal^);}
               NoCopies:=CustomEvent.EntSysObj.IntResult;
           end;
        {$ENDIF}

      {$ENDIF}
    end; {Proc..}

  end;



  Procedure TPrintPickRun.Print_PickRun;

  Const
    Fnum     =  InvF;

    Keypath1 =  InvBatchK;



  Var
    KeyS,
    KeyChk,
    RForm   :  Str255;

    Keypath :  Integer;

    RecAddr :  LongInt;

    n       :  Byte;

    TestOnly,
    Ok2Print,
    RunHook,
    FoundOk :  Boolean;

    StaCtrl :   StaCtrlRec;

    {$IFDEF Cu}

      CustomEvent  :  TCustomEvent;

    {$ELSE}
      CustomEvent  :  Pointer;

    {$ENDIF}

    {$IFDEF FRM}
      fmInfo   :  FormInfoType;
    {$ENDIF}




  Begin
    TestOnly:=BOff;  RunHook:=BOff;

    CustomEvent:=nil;

    With PickRepPtr^,PParam,MTExLocal^ do
    Begin
      KeyChk:=MatchK;

      KeyS:=KeyChk;

      If (PRMode=10) then
        Keypath:=InvRNoK
      else
        Keypath:=Keypath1;

      If (Not BatchStart) then {* Need to create batch *}
      Begin
        {InPrint:=BOff; {* Force in print off otherwise, batch will not work *}

        {$IFDEF FRM}

          pfInitNewBatch(BOff,BOn);

        {$ENDIF}

        {InPrint:=BOn;}
      end;

      n:=0;

      Ok2Print:=BOn;

      RecAddr:=0;

      FoundOk:=BOff;

      Blank(LNHist,Sizeof(LNHist));

      ShowStatus(1,'Generating Print Run:-');

      If (PRMode=5) then
      Begin
        ShowStatus(2,'Printing Delivery Product Labels');

      end
      else
       If (PrMode In [1,10]) then
       Begin
         New(StaCtrl);

         FillChar(StaCtrl^,Sizeof(StaCtrl^),0);

         StaCtrl^.CRFlags[89]:=BOn;
         StaCtrl^.CRFlags[90]:=PSOPInp.ShowAllBins;
       end
       else
         StaCtrl:=Nil;

      RForm:='';

      {$IFDEF Cu}
        CustomEvent:=TCustomEvent.Create(EnterpriseBase+2000,04+Ord(PRMode=6)+(66*Ord(PrMode=7))+(67*Ord(PrMode=9)));


      {$ENDIF}

      Try

       {$IFDEF Cu}

          With CustomEvent do
            If (GotEvent) then
            Begin
              BuildEvent(MTExLocal^);
              RunHook:=BOn;
            end;

       {$ENDIF}


        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);



        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) and (Ok2Print) and (Not TestOnly) do
        With LInv do
        Begin

          LStatus:=LGetPos(Fnum,RecAddr);  {* Preserve DocPosn *}


          Case PRMode of
            1..3,6,7,9,10,11
               :  Begin

                    If (PickRunNo=PickRNo) or (PRMode In [7,9,11]) then
                    Begin
                      SetForm(RForm,CustomEvent,RunHook);

                      If (PRMode In [1,10]) then
                      Begin
                        ShowStatus(2,'Generating Picking List for '+Trim(OurRef))
                      end
                      else
                        ShowStatus(2,'Printing '+Trim(OurRef));


                      {$IFDEF FRM}


                        If (PRMode In [6,11]) then {We are in invoice run, so engage Paperless}
                        Begin

                          Blank(PDevRec.feEmailMsg,Sizeof(PDevRec.feEmailMsg));
                          Blank(PDevRec.feFaxMsg,Sizeof(PDevRec.feFaxMsg));

                          // CJS 2016-02-09 - ABSEXCH-15606 - Extend roles to cover Invoice all and Deliver All processes
                          if (PrMode = 6) then
                            SetEcommsFromCust_WithRole(LCust, PDevRec, MTExLocal, BOn, riSendInvoices)
                          else
                            SetEcommsFromCust(LCust,PDevRec,MTExLocal,BOn);

                          If (PRMode=11) then
                            RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[EntDefPrnMode[InvDocHed]];

                          PDevRec.feEmailsubj:=DocNames[InvDocHed]+' '+OurRef+' from '+Syss.UserName;

                          PDevRec.feFaxMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feFaxMsg;
                          PDevRec.feEmailMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feEmailMsg;


                          If (RightFEAcc(SFiltX,LCust.InvDMode)) then
                          begin

                            Ok2Print:=Send_FrmPrint(PDevRec,DefMode,RForm,
                                         Fnum,InvOurRefK,OurRef,
                                         Fnum2,Keypath2,FullNomKey(FolioNum),
                                         '',
                                         NIL,
                                         BOff,
                                         LCust.InvDMode);

                          end;
                        end
                        else
                          Ok2Print:=pfAddBatchForm(PDevRec,DefMode,RForm,
                                                   Fnum,InvOurRefK,OurRef,
                                                   Fnum2,Keypath2,FullNomKey(FolioNum),
                                                   '',
                                                   StaCtrl,
                                                   BOff);

                        If (DefMode In [1,13,14,23,50]) then {* Set DocPrinted on Invoice or Credit Note *}
                          LSet_PrintedStatus(((Not PDevRec.Preview) and (Ok2Print)),(DefMode In [13,14,50]),LInv);

                      {$ENDIF}


                    end;
                  end;

            5  :  If (PickRunNo=PickRNo) then
                    SOP_BuildProdLab(FolioNum,FoundOk,Fnum2,Keypath2,MatchK);


            4
               :  Begin
                    SetForm(RForm,CustomEvent,RunHook);

                    ShowStatus(2,'Printing Labels for '+Trim(OurRef));

                    {$IFDEF FRM}

                      For n:=1 to NoLabels do
                        If (Ok2Print) then
                          Ok2Print:=pfAddBatchForm(PDevRec,26,RForm,
                                                 Fnum,InvOurRefK,OurRef,
                                                 Fnum,0,'',
                                                 '',
                                                 NIL,
                                                 BOff);


                    {$ENDIF}
                  end;

          end; {Case..}


          LSetDataRecOfs(Fnum,RecAddr); {* Restore position and path *}

          If (RecAddr<>0) then
            LStatus:=LGetDirect(Fnum,KeyPath,0);

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

          TestOnly:=PDevRec.TestMode;

        end; {While..}

      finally
        {$IFDEF CU}
          CustomEvent.Free;
        {$ENDIF}

        If (PrMode In [1,10]) and (Assigned(StaCtrl)) then
          Dispose(StaCtrl);

      end;

    end; {With..}
  end; {Proc..}




  Procedure TPrintPickRun.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Order Processing Batch Print');

    Print_PickRun;


  end;


  Procedure TPrintPickRun.Finish;

  Var
    TParam  :  ^TPrintParam;

  Begin

    With MTExLocal^ do
    Begin
      If (Assigned(LThPrintJob)) and (Not ThreadRec^.ThAbortPrint) then {* Call back to Synchronise method *}
      Begin
        New(TParam);

        TParam^:=PickRepPtr^.PParam;

        {$IFDEF FRM}  {* Ex431 Connect eComm jobs list here *}
          If (Assigned(eCommFrmList)) then
            TParam^.eCommLink:=eCommFrmList;
        {$ENDIF}


        ShowStatus(1,'');

        ShowStatus(2,'Printing to Printer...');

        ThreadRec^.THAbort:=BOn; {* Force abort, as control now handed over to DLL *}
        LThPrintJob(nil,LongInt(@TParam^),0);
      end
      else
      Begin
        {$IFDEF FRM}
          If (Assigned(eCommFrmList)) then
            eCommFrmList.Destroy;
        {$ENDIF}
      end;
    end;{With..}

    Inherited Finish;

    {Overridable method}

    InPrint:=BOff;

    InMainThread:=BOff;

  end;




  Function TPrintPickRun.Start(CIDMode  :  Integer)  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin

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
          If (Not Assigned(RepExLocal)) then { Open up Global files here, as one batch after another can cause file collision }
            Result:=Create_ReportFiles;

          If (Result) then
            MTExLocal:=RepExLocal;
        end;

        {New(MTExLocal,Create(17+CIDMode));

        try
          With MTExLocal^ do
            Open_System(CustF,PWrdF);

        except
          Dispose(MTExLocal,Destroy);
          MTExLocal:=nil;

        end; {Except}

      end;
    end;
    Result:=Assigned(MTExLocal);
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}
  end;




  Procedure AddPick2Thread(AOwner   :  TObject;
                           PickRep  :  PPickRepPtr);


  Var
    LCheck_Stk :  ^TPrintPickRun;
    CIDMode    :  Integer;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin
          If (Assigned(PickRep)) then
            CIDMode:=Pred(PickRep^.PRMode)
          else
            CIDMode:=0;

          If (Start(CIDMode)) and (Create_BackThread) then
          Begin
            If (Assigned(PickRep)) then
              PickRepPtr^:=PickRep^;

            With BackThread do
              AddTask(LCheck_Stk,'SPOP Print');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;








{$ENDIF}



{ ====== Proc to Set Order Tag Status ===== }


Procedure Set_OrderTag(Fnum,
                       KeyPath  :  Integer;
                       LAddr    :  LongInt;
                       TagNo    :  Byte);


Begin
  Inv.Tagged:=TagNo;

  Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

  Report_BError(Fnum,Status);

  Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);


end;





end. {Unit..}