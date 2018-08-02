unit PickRunU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges,  BTSupU1, GlobVar, VarConst,
  BTSupU3,SBSComp2;

type

  TPickRunFrm = class(TForm)
    SBSPanel3: TSBSPanel;
    Label1: Label8;
    CanCP1Btn: TButton;
    Label2: TLabel;
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

    private

      Running,
      KeepRun    :  Boolean;



      KeyV       :  TModalResult;

      Procedure Send_UpdateList(Mode   :  Integer);

      Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

      procedure ShutDown;

      Function Adjust_PickBOM(KitLine  :  IDetail;
                              Fnum2,
                              KeyPath2 :  Integer;
                              UpdateMode
                                       :  Byte)  :  Double;

      Procedure Set_PickRun(MatchK      :  Str255;
                        Var PickRNo     :  LongInt;
                            PickDate    :  LongDate;
                            SetPickNo   :  Boolean;
                            FindTag     :  Byte;
                            ExcPick,
                            EXPBOM,
                            IncPickOnly
                                  :  Boolean;
                        Var GotOrd      :  Boolean;
                        Var OrdFolio    :  LongInt;
                            SOPLOC      :  Str5;
                        Var SCRTPtr     :  Pointer);


      Procedure Run_PickList(CRepParam  :  PPickRepPtr;
                             DocHed     :  DocTypes);


    public
      { Public declarations }
      PCRepParam :  PPickRepPtr;
      PDocHed    :  DocTypes;
      PickFDForm :  Str255;


  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  BtrvU2,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  SysU2,
  BTSupU2,
  SCRTCH1U,
  InvListU,
  {$IFDEF SOP}
     InvLst3U,

   {$ENDIF}

  InvCTSuU,
  InvFSu2U,
  FIFOL2U,
  SOPCt1U,
  SOPCt2U,
  SOPCt3U,
  SysU1,
  Warn1U,

  {$IFDEF CU}
    CustIntU,
    ExWrap1U,
    CustWinU,
  {$ENDIF}

  StkBinU,
  GlobType,
  DLLInt,
  FrmThrdU,
  BTSFrmU1,
  PrintFrm;




{$R *.DFM}



procedure TPickRunFrm.CanCP1BtnClick(Sender: TObject);
begin
  KeyV:=mrAbort;

  Loop_CheckKey(KeepRun,KeyV);

  If (Not KeepRun) then
    CanCp1Btn.Enabled:=BOff;
end;


Procedure TPickRunFrm.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      8
         :  Begin

            end;


    end; {Case..}

  end; {With..}

  Inherited;

end;



Procedure TPickRunFrm.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

procedure TPickRunFrm.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;


Function TPickRunFrm.Adjust_PickBOM(KitLine  :  IDetail;
                                    Fnum2,
                                    KeyPath2 :  Integer;
                                    UpdateMode
                                             :  Byte)  :  Double;


Var
  TmpStat      :   Integer;

  LOK,
  Locked,
  FoundBOM     :   Boolean;

  TmpRecAddr
               :  LongInt;

  RecAddr      :   LongInt;

  QtyPer,
  PickNow      :   Double;

  KeyS,
  KeyChk       :   Str255;

  TmpInv       :   InvRec;
  BomLine,
  TmpId        :   IDetail;

  OldStock,
  KitStk       :   StockRec;


Begin
  TmpInv:=Inv;
  TmpId:=Id;
  OldStock:=Stock;

  PickNow:=0.0;  FoundBOM:=BOff; QtyPer:=0.0;

  Result:=KitLine.QtyPick;

  TmpStat:=Presrv_BTPos(Fnum2,KeyPath2,F[Fnum2],TmpRecAddr,BOff,BOff);

  KeyChk:=FullIdKey(KitLine.FolioRef,KitLine.ABSLineNo);
  KeyS:=KeyChk;

  {* Parent must be further up so search back to find it *}

  TmpStat:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS);

  While (TmpStat=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not FoundBOM) do
  With Id do
  Begin
    If (StockCode<>Stock.StockCode) and (KitLink=0) then
      Global_GetMainRec(StockF,StockCode);


    FoundBOM:=(KitLink=0) and (Stock.StockFolio=KitLine.KitLink)
             and (Not Is_SerNo(Stock.StkValType)) and (CanAutoPickBin(Id,Stock,0))
             and (Stock.StockType=StkBillCode) and (Not Stock.ShowasKit);

    If (Not FoundBOM) then
      TmpStat:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

  end; {While.}

  If (FoundBOM) then
  Begin
    BOMLine:=Id;
    KitStk:=Stock;

    QtyPer:=DivWChk(KitLine.Qty,BOMLine.Qty-BOMLine.DeductQty);

    PickNow:=Trunc(DivWChk(KitLine.QtyPick,QtyPer))+BOMLine.OldPBal;

    TmpStat:=GetPos(F[Fnum2],Fnum2,RecAddr);  {* Preserve Line Posn *}

    If (PickNow<BOMLine.QtyPick) then {Update BOM parent line with total possible to pick}
    Begin
      SetDataRecOfs(Fnum2,RecAddr);

      If (RecAddr<>0) then
        TmpStat:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0)
      else
        TmpStat:=4;

      If (TmpStat=0) then
      Begin
        LOk:=GetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);

        If (LOK) and (Locked) then
        With Id do
        Begin
          If (QtyPick<>0) then
          Begin
            Stock_Deduct(Id,Inv,BOff,BOn,3); {* Reverse picked qty *}

            {Bring any bins in line}
            Auto_PickBin(Id,Inv,Id.QtyPick,Id.BinQty,1);

          end;

          QtyPick:=PickNow;

          Stock_Deduct(Id,Inv,BOn,BOn,3); {* Adjust picked qty *}

          {Bring any bins in line}
          Auto_PickBin(Id,Inv,Id.QtyPick,Id.BinQty,0);

          TmpStat:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

          BOMLine:=Id; {Refresh BOM Line}

          Report_BError(Fnum2,TmpStat);

          TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,RecAddr);

          SOP_SeekDescLines(0,Id,Keypath2);

        end;

      end;

    end;

    If (Round_Up((BOMLine.QtyPick-BOMLine.OldPBal)*QtyPer,Syss.NoQtyDec)<>Result) then
      Result:=Round_Up((BOMLine.QtyPick-BOMLine.OldPBal)*QtyPer,Syss.NoQtyDec); {Force back hidden line qty picked}

  end;

  TmpStat:=Presrv_BTPos(Fnum2,KeyPath2,F[Fnum2],TmpRecAddr,BOn,BOff);


  Id:=TmpId;
  Inv:=TmpInv;
  Stock:=OldStock;


end; {PRoc..}


{ ======== Procedure to Process Picking List ======= }



Procedure TPickRunFrm.Set_PickRun(MatchK      :  Str255;
                              Var PickRNo     :  LongInt;
                                  PickDate    :  LongDate;
                                  SetPickNo   :  Boolean;
                                  FindTag     :  Byte;
                                  ExcPick,
                                  EXPBOM,
                                  IncPickOnly
                                        :  Boolean;
                              Var GotOrd      :  Boolean;
                              Var OrdFolio    :  LongInt;
                                  SOPLOC      :  Str5;
                              Var SCRTPtr     :  Pointer);


Const
    Fnum2    =  IdetailF;

    Keypath2 =  IdLinkK;

    Fnum     =  InvF;

    Keypath  =  InvBatchK;


Var
  KeyS,
  KeyChk,
  KeySI,
  KeyChkI,
  GenStr  :  Str255;


  FoundOk,
  GotLines,
  CheckAll,
  CheckLine,
  Locked,
  LineOk,
  GotStock,
  GetRun,

  GotPicked,

  TmpOk,
  ApplyKit
           :  Boolean;

  FoundCode:  Str20;

  mbRet    :  TModalResult;

  LAddr,
  LastKit  :  LongInt;

  FreeAll  :  Real;

  ThisScrt :  ScratchPtr;

  RecAddr  :  LongInt;

  CopyId   :  IDetail;

  {$IFDEF CU}

    ExLocal:  TdExlocal;

    NeedCEvent,
    ProcessEvent
           :  Boolean;
    CustomEvent

           :  TCustomEvent;

  {$ELSE}
    CustomEvent
           :  Pointer;

  {$ENDIF}

  lStatus : SmallInt;


{$IFDEF CU}
  Procedure CreateCustomEvent;


  Begin
    If (NeedCEvent) then
    Begin
      CustomEvent:=TCustomEvent.Create(EnterpriseBase+2000,67);


      Try
        With CustomEvent do
        Begin
          ProcessEvent:=GotEvent;
        end;

        If (Not ProcessEvent) then {We don't need this object at all}
        Begin
          CustomEvent.Free;
          CustomEvent:=nil;

        end
        else
        Begin
          
          ExLocal.AssignFromGlobal(InvF);
          ExLocal.AssignFromGlobal(CustF);

          CustomEvent.BuildEvent(ExLocal); {Prime the event}


        end;
      except
        CustomEvent.Free;
        CustomEvent:=nil;
      end;

      NeedCEvent:=BOff;

    end;

  end;

{$ENDIF}


Begin

  FoundOk:=BOff;

  CheckAll:=BOff;
  CheckLine:=BOff;
  GotLines:=BOff;

  Locked:=BOff;

  LineOk:=BOff;

  LastKit:=0;

  FreeAll:=0;

  Foundcode:='';

  GotStock:=BOff;     CopyId:=Id;

  GetRun:=BOff;  ApplyKit:=BOff;

  TmpOk:=BOff;

  GenStr:='';

  KeyChk:=MatchK;

  KeyS:=KeyChk;

  ThisScrt:=SCRtPtr;

  RecAddr:=0;
  LAddr:=0;

  {$IFDEF CU}
    NeedCEvent:=BOn;
    ProcessEvent:=BOff;
    ExLocal.Create;
  {$ENDIF}

  CustomEvent:=nil;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (KeepRun) do
  With Inv do
  Begin

    Application.ProcessMessages;

    Label2.Caption:='Checking '+OurRef;

    FoundOk:=BOff; ApplyKit:=BOff;


    If ((DueDate<=PickDate) and ((Tagged=FindTag) or (FindTag=0))
       and ((Not OnPickRun) or (Not ExcPick))
       and ((Not OnHold(HoldFlg)) or ((((HoldFlg AND HOLDO)=HoldO) or ((HoldFlg AND HoldS)=HoldS))))) then

    Begin
      {$IFDEF CU}
        CreateCustomEvent;

        Apply_CreditHold(BOn,Fnum,Keypath,CustomEvent);

      {$ENDIF}



      If ((HoldFlg AND HoldC)<>HoldC) then
      Begin

        // MH 04/03/2010: Modified so that a SOR being editing doesn't stall the delivery run process (ABSEXCH-7975)
        //Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);
        lStatus := Try_Lock(B_GetDirect, B_SingNWLock+B_MultLock, KeyS, KeyPath, Fnum, RecPtr[Fnum]);
        If (lStatus = 0) then
          lStatus := GetPos(F[Fnum], Fnum, LAddr);
        OK := (lStatus = 0);
        Locked := OK;
        Addch:=#0; {* Reset Lock Key *}     // MH - No idea what this is for

        If (Ok) and (Locked) then
        Begin


          If (Not GetRun) then
          Begin

            PickRNo:=GetNextCount(SDT,BOn,BOff,0);

            GetRun:=BOn;

          end;

          Label2.Caption:='Processing '+OurRef;

          Calc_StockDeduct(FolioNum,BOff,Ord(EXPBOM),Inv,BOff); {* Re-calculate BOM situation *}

          CheckAll:=((HoldFlg AND HoldO)=HoldO);

          CheckLine:=(((HoldFlg AND HoldS)=HoldS) or (CheckAll));

          GotLines:=BOff;

          LastKit:=0;

          GotPicked:=Not IncPickOnly;

          KeyChkI:=FullNomKey(FolioNum);

          KeySI:=FullIdKey(FolioNum,1);

          Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

          While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (Not FoundOk) and (KeepRun) do
          With Id do
          Begin

            Application.ProcessMessages;

            {* v4.30c, This check added otherwise a wait all stock order would still have desc lines picked
                       and without a matching run no, the clear down would not clear desc items *}

            If (SOPLineNo<>PickRNo) or (Is_FullStkCode(StockCode)) or (KitLink=0) then
              SOPLineNo:=0;

            If (Qty_OS(Id)<>0) and (PDate<=PickDate) and (CheckKey(SOPLoc,MLocStk,Length(SOPLoc),BOff))  then
            Begin
              CopyId:=Id; {*Store previous Qty pick}

              GotStock:=GetStock(Application.MainForm,StockCode,FoundCode,-1);

              {$IFDEF SOP}
                Stock_LocSubst(Stock,MLocStk);

              {$ENDIF}

              {* Altered v4.23 to take into accou picked already *}
              FreeAll:=StkApplyMul(Stock.QtyInStock-Stock.QtyPicked,QtyMul,(IdDocHed In SalesSplit))+CopyId.QtyPick;


              {FreeAll:=(Stock.QtyInStock-
                            Get_LastAlloc(FullAllocFile(AllocTCode,AllocPCode,Stock.StockFolio),TmpOk,BOn));}

              LineOk:=((Not GotStock) or (Not CheckLine) or (Stock.StockType=StkDescCode)
                    or (((Qty_OS(Id)<=FreeAll)
                    or (Stock.ShowAsKit)
                    or ((EXPBOM) and (Stock.StockType=StkBillCode)))
                    and GotStock));


              FoundOk:=((Not LineOk) and (CheckAll)); {* Abort if one line no good, and all order needs to be complete *}


              If (LineOk) then
              Begin
                ApplyKit:=(ApplyKit or ((Stock.ShowAsKit) and (Qty_OS(Id)<>0)));

                If (Not GotLines) then
                Begin

                  GotLines:=BOn;

                  {If (SetPickNo) and (Not GotOrd) then
                      Reset_Alloc(AllocPCode,BOff); * Altered v4.23 as stock qtypicked will take this into account}

                end;


                If (KitLink=0) and (GotStock) then {* Not Used, as lines not processed in a kitlink order! *}
                Begin

                  LastKit:=Stock.StockFolio;

                end;

                If (SetPickNo) and (Not Is_SerNo(Stock.StkValType)) and ((CanAutoPickBin(Id,Stock,0) or (Not GotStock))) then
                Begin

                  If (Not Is_SerNo(Stock.StkValType)) then  {* Do not auto pick for Serial Nos *}
                    QtyPick:=Qty_OS(Id)
                  else
                    QtyPick:=0;

                  If (GotStock) and (Stock.StockType In StkProdSet) then
                  Begin

                    {* v4.23 altered to take into account already picked *}
                    FreeAll:=StkApplyMul((Stock.QtyInStock-Stock.QtyPicked),QtyMul,(IdDocHed In SalesSplit))+CopyId.QtyPick;


                    {FreeAll:=(Stock.QtyInStock-
                              Get_LastAlloc(FullAllocFile(AllocTCode,AllocPCode,Stock.StockFolio),TmpOk,BOn));}

                    If (FreeAll<QtyPick) then
                    Begin

                      If (FreeAll>0) then
                        QtyPick:=FreeAll
                      else
                        QtyPick:=0;

                    end;


                    {Put_LastAlloc(BOff,QtyPick,AllocPCode,Stock.StockFolio);}

                  end;

                  If (QtyPick=0) then
                  Begin        {* Mod for description part *}
                    If ((KitLink<>0) and (Not GotStock)) then
                      QtyPick:=1
                    else       {* Force BOM Amount thru *}
                      If ((EXPBOM) and (Stock.StockType=StkBillCode)) and (Not Is_SerNo(Stock.StkValType)) then
                        QtyPick:=Qty_OS(Id);

                    OldPBal:=0.0;
                  end
                  else
                    OldPBal:=QtyPick;

                  QtyPWOff:=0;


                  If (KitLink<>0) and (LineNo<1) then {V5, It is a hidden line, so adjust the parent BOM and it
                                                       accordingly}
                  Begin
                    QtyPick:=Adjust_PickBOM(Id,Fnum2,Keypath2,0);

                  end
                  else {V5 If this is a BOM item, and we do have some stock for it, then
                        assume we have all stock so it gets adjusted back down by how
                        much freestock of its own it has, embedded in OldPBal, + the
                        availability of the components}
                  If (EXPBOM) and (Stock.StockType=StkBillCode) and (KitLink=0) and (LineNo>0) and
                     (DeductQty>0) and (DeductQty<(Qty*QtyMul)) and (Syss.DeadBOM) and
                     (Not Is_SerNo(Stock.StkValType)) and (QtyPick<>Qty_OS(Id)) and
                     (Is_FullStkCode(StockCode)) then
                  Begin
                    QtyPick:=Qty_OS(Id);

                  end;


                  If (Is_FullStkCode(StockCode)) then {* Update Picked Qty Status *}
                  Begin
                    Stock_Deduct(CopyId,Inv,BOff,BOn,3); {* Deduct previous amount picked }

                    {Bring any bins in line}
                    Auto_PickBin(CopyId,Inv,CopyId.QtyPick,Id.BinQty,1);

                    Stock_Deduct(Id,Inv,BOn,BOn,3);

                    {Bring any bins in line}
                    Auto_PickBin(Id,Inv,Id.QtyPick,Id.BinQty,0);

                    If (IdDocHed In SalesSplit) and (QtyPick<>0) and (Not (FIFO_Mode(Stock.StkValType) In [2,3,5])) then
                      CostPrice:=FIFO_GetCost(Stock,Inv.Currency,Qty*QtyMul,QtyMul,MLocStk);
                  end;


                end;
                {else
                  QtyPick:=0;}

                GotPicked:=(GotPicked or (QtyPick<>0.0));

                If (Not Stock.ShowAsKit) or (KitLink<>0) or (Stock.StockType<>StkBillCode) then
                  SOPLineNo:=PickRNo;

                If (ThisScrt<>NIL) and GotPicked then
                Begin

                  Status:=GetPos(F[Fnum2],Fnum2,RecAddr);  {* Get Preserve IdPosn *}

                  ThisScrt^.Add_Scratch(Fnum2,Keypath2,RecAddr,Stock.BinLoc+Stock.StockCode,'');

                end;

              end; {If LineOk..}

            end; {If Line Due}

            Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

            Report_BError(Fnum2,Status);

            If (StatusOk) and (Not FoundOk) then  {* Find any connecting desc lines *}
              SOP_SeekDescLines(PickRNo,Id,Keypath2);

            {* If Got a Stock code, check for any desc lines immediately following *}


            If (Not FoundOk) then
              Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

          end; {While..}

          If (GotLines) and (Not FoundOk) and GotPicked then
          Begin

            PickRunNo:=PickRNo;

            If (Not GotOrd) then {* Preserve this header for a link *}
              OrdFolio:=FolioNum;

            GotOrd:=BOn;
          end
          else
            PickRunNo:=0;


          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          If (StatusOk) then
            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          Report_BError(Fnum,Status);

          If (FoundOk) and (GotLines) and (SetPickNo) then {* Reverse out auto pick *}
            Abort_AutoPick(PickRNo,Fnum2,Keypath2,KeyChkI)
          else
            If (ApplyKit) then
              ReApply_KitPick(Fnum2,IdFolioK,KeyChkI,CheckLine,PickRNo,Inv);


        end; {If Locked..}
      end; {If On Credit Hold}
    end; {If Order Due..}

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}


  {$IFDEF CU}
    If (Assigned(CustomEvent)) then
    Begin
      CustomEvent.Free;
      CustomEvent:=nil;
      NeedCEvent:=BOn;
    end;

    ExLocal.Destroy;
  {$ENDIF}

end; {Proc..}



{ ======= Procedure to run the picking list ====== }

Procedure TPickRunFrm.Run_PickList(CRepParam  :  PPickRepPtr;
                                   DocHed     :  DocTypes);


Const
  Fnum     =  InvF;

  Keypath  =  InvFolioK;


Var
  NextRNo  :  Longint;

  Ok2Print,
  GotOrd,
  Locked
           :  Boolean;

  OrdFolio :  LongInt;

  KeyS     :  Str255;

  SOPInp   :  SOPInpRec;

  ThisScrt :  ScratchPtr;

  ThisPtr  :  Pointer;

  StaCtrl  :   StaCtrlRec;

  fmInfo   :  FormInfoType;

  FormName :  Str10;

Begin


  ThisScrt:=NIL;

  ThisPtr:=NIL;

  Addch:=ResetKey;

  Locked:=BOn;

  GotOrd:=BOff;

  Ok2Print:=BOn;

  OrdFolio:=0;



  If (GetMultiSys(BOff,Locked,DefR)) and (Locked) then
  Begin

    New(StaCtrl);

    FillChar(StaCtrl^,Sizeof(StaCtrl^),0);



    Label1.Caption:=#13+'Please Wait...'+#13+#13+'Generating picking list';


    NextRNo:=GetNextCount(SDT,BOff,BOff,0);

    With CRepParam^ do
    Begin

      New(ThisScrt,Init(1));

      ThisPtr:=ThisScrt;


      With PSOPInp do
        Set_PickRun(DocCodes[DocHed],
                    NextRNo,
                    PickUDate,
                    PickAuto,
                    PickTag,
                    PickExc,
                    PickEBOM,
                    ExcNonPick,

                    GotOrd,
                    OrdFolio,
                    SOPMLoc,
                    ThisPtr);

      If (KeepRun) and (GotOrd) then
      Begin

        KeyS:=FullNomKey(OrdFolio);  {* Get first order header for pickRunNo match *}

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        If (StatusOk) then
        Begin



          If (PSOPInp.PickCon) then  {* Print consolidated lines *}
          With PParam do
          Begin
            StaCtrl^.RepPtr:=ThisPtr;
            StaCtrl^.SFName:=FileNames[ReportF];
            StaCtrl^.CRFlags[90]:=PSOPInp.ShowAllBins;
            StaCtrl^.CRFlags[89]:=BOn;

            {* Close temp thread file, as DLL needs access to it *}

            Status:=Close_File(F[ReportF]);


            {Ok2Print:=pfInitNewBatch(BOn,BOn); V5 use thread model only

            BatchStart:=Ok2Print;}

            PDevRec.feJobTitle:='Consolidated Picking List';

            {* V5, this part added into thread as printing direct was causing a problem}
            {There was originally a mechanism here to allow the consolidated part to be added
            in at the top of the individual picking lists. This technique caused InPrint to be set, and so
            the second print job was always waiting for the first print job. In v5 the consolidated part
            was moved into its own thread}


            FormName:=SyssForms.FormDefs.PrimaryForm[17];

            If (FormName<>'') then {* Set no. Copies *}
            Begin
              fmInfo:=GetFormInfo(FormName);
              PDevRec.NoCopies:=fmInfo.Copies;

              If (PDevRec.NoCopies<1) then
                PDevRec.NoCopies:=1;
            end;

            AddSta2PrintQueue(PDevRec,13,FormName,
                              InvF,InvOurRefK,ReportF,RPK,
                              Inv.OurRef,
                              FullNomKey(ThisSCrt^.Process),
                              StaCtrl^);


            {$IFDEF NOTV5}
              If (Ok2Print) then
                Ok2Print:=pfAddBatchForm(PDevRec,13,SyssForms.FormDefs.PrimaryForm[17],
                                         InvF,InvOurRefK,Inv.OurRef,ReportF,RPK,
                                         FullNomKey(ThisSCrt^.Process),
                                         'Consolidated Picking List',
                                         StaCtrl,
                                         BOn);

                If (Ok2Print) and (Not PSOPInp.PickSing) then {* Print batch now, as thread will not be run.. *}
                  Ok2Print:=pfPrintBatch('Consolidated Picking List',PDevRec.NoCopies,BOn,PDevRec.feJobtitle);
            {$ENDIF}
          end
          else
          Begin


          end;

          If (PSOPInp.PickSing) and (Ok2Print) then  {* Print single Run *}
          Begin
            PickRNo:=NextRNo;
            MatchK:=DocCodes[DocHed];
            Fnum2:=IdetailF;
            Keypath2:=IdFolioK;
            PRMode:=1;
            DefMode:=14;
            LRForm:=PickFDForm;

            PParam.PDevRec.feMiscOptions[9]:=PSOPInp.PickEBOM;

            AddPick2Thread(Application.MainForm,CRepParam);
          end;

        end;

      end;

      Put_LastSOPVal(AllocSCode,PSOPInp,1);

      If (Not PSOPInp.PickCon) then {* Dispose of it, as thread will not *}
        Dispose(ThisSCrt,Done);

    end; {If abort print }

    PutMultiSys(DefR,BOn);

    Dispose(StaCtrl);

  end; {If Locked..}


end; {Proc..}




procedure TPickRunFrm.FormCreate(Sender: TObject);
begin
  ClientHeight:=129;
  ClientWidth:=299;

  Left:=Round((Screen.Width/2)-(Width/2));
  Top:=Round((Screen.Height/2)-(Height/2));

  KeepRun:=BOn;

  Running:=BOff;
end;





procedure TPickRunFrm.FormActivate(Sender: TObject);
begin
  If (Not Running) then
  Begin
    Running:=BOn;

    Run_PickList(PCRepParam,PDocHed);

    ShutDown;
  end;


end;

end.
