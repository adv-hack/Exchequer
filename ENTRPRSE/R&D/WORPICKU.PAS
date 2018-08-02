unit WORPickU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges,  BTSupU1, GlobVar, VarConst,
  BTSupU3,SBSComp2;

type

  TWOPPickFrm = class(TForm)
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

      Procedure Set_PickRun(MatchK      :  Str255;
                        Var PickRNo     :  LongInt;
                            SetPickNo   :  Boolean;
                            FindTag     :  Byte;
                            ExcPick     :  Boolean;
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
  
  FrmThrdU,
  PrintFrm;




{$R *.DFM}



procedure TWOPPickFrm.CanCP1BtnClick(Sender: TObject);
begin
  KeyV:=mrAbort;

  Loop_CheckKey(KeepRun,KeyV);

  If (Not KeepRun) then
    CanCp1Btn.Enabled:=BOff;
end;


Procedure TWOPPickFrm.WMCustGetRec(Var Message  :  TMessage);

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



Procedure TWOPPickFrm.Send_UpdateList(Mode   :  Integer);

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

procedure TWOPPickFrm.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;


{ ======== Procedure to Process Picking List ======= }



Procedure TWOPPickFrm.Set_PickRun(MatchK      :  Str255;
                              Var PickRNo     :  LongInt;
                                  SetPickNo   :  Boolean;
                                  FindTag     :  Byte;
                                  ExcPick     :  Boolean;
                              Var GotOrd      :  Boolean;
                              Var OrdFolio    :  LongInt;
                                  SOPLOC      :  Str5;
                              Var SCRTPtr     :  Pointer);


Const
    Fnum2    =  IdetailF;

    Keypath2 =  IdLinkK;

    Fnum     =  InvF;

    Keypath  =  InvRNoK;


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
  TmpOk
           :  Boolean;

  FoundCode:  Str20;

  mbRet    :  TModalResult;

  LAddr,
  LastKit  :  LongInt;

  OldLCost,
  NewLCost :  Double;

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


{$IFDEF CU}
  Procedure CreateCustomEvent;


  Begin
    If (NeedCEvent) then
    Begin
      CustomEvent:=TCustomEvent.Create(EnterpriseBase+2000,68);


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

  GetRun:=BOff;

  TmpOk:=BOff;

  GenStr:='';

  KeyChk:=MatchK;

  KeyS:=KeyChk;

  ThisScrt:=SCRtPtr;

  OldLCost:=0.0; NewLCost:=0.0;

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

    FoundOk:=BOff;


    If (((Tagged=FindTag) or (FindTag=0))
       and ((Not OnPickRun) or (Not ExcPick))
       and ((Not OnHold(HoldFlg)) or ((((HoldFlg AND HOLDO)=HoldO) or ((HoldFlg AND HoldS)=HoldS))))) then

    Begin
      {$IFDEF CU}
        CreateCustomEvent;

      {$ENDIF}


      Begin


        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin


          If (Not GetRun) then
          Begin

            PickRNo:=GetNextCount(SDT,BOn,BOff,0);

            GetRun:=BOn;

          end;

          Label2.Caption:='Processing '+OurRef;

          CheckAll:=((HoldFlg AND HoldO)=HoldO);

          CheckLine:=(((HoldFlg AND HoldS)=HoldS) or (CheckAll));

          GotLines:=BOff;

          LastKit:=0;


          KeyChkI:=FullNomKey(FolioNum);

          KeySI:=FullIdKey(FolioNum,2);

          Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

          While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (Not FoundOk) and (KeepRun) do
          With Id do
          Begin

            Application.ProcessMessages;

            {* v4.30c, This check added otherwise a wait all stock order would still have desc lines picked
                       and without a matching run no, the clear down would not clear desc items *}

            If (SOPLineNo<>PickRNo) or (Is_FullStkCode(StockCode)) or (KitLink=0) then
              SOPLineNo:=0;

            If (Qty_OS(Id)<>0) and (CheckKey(SOPLoc,MLocStk,Length(SOPLoc),BOff)) then
            Begin
              CopyId:=Id; {*Store previous Qty pick}

              GotStock:=GetStock(Application.MainForm,StockCode,FoundCode,-1);

              {$IFDEF SOP}
                Stock_LocSubst(Stock,MLocStk);

              {$ENDIF}

              {* Altered v4.23 to take into accou picked already *}
              If (Stock.StockType=StkDescCode) then
                FreeAll:=Qty_OS(Id)
              else
                FreeAll:=(Stock.QtyInStock-Stock.QtyPicked-Stock.QtyPickWOR+CopyId.QtyPick);


              LineOk:=((Not CheckLine)
                    or ((Qty_OS(Id)<=FreeAll)
                    and GotStock));


              FoundOk:=((Not LineOk) and (CheckAll)); {* Abort if one line no good, and all order needs to be complete *}


              If (LineOk) then
              Begin

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

                If (SetPickNo) then
                Begin

                  If (Not Is_SerNo(Stock.StkValType)) then  {* Do not auto pick for Serial Nos *}
                    QtyPick:=Qty_OS(Id)
                  else
                    QtyPick:=0;

                  If (GotStock) and (Stock.StockType In StkProdSet) then
                  Begin


                    If (FreeAll<QtyPick) then
                    Begin

                      If (FreeAll>0) then
                        QtyPick:=FreeAll
                      else
                        QtyPick:=0;

                    end;

                  end;



                  If (Is_FullStkCode(StockCode)) then {* Update Picked Qty Status *}
                  Begin
                    Stock_Deduct(CopyId,Inv,BOff,BOn,3); {* Deduct previous amount picked }


                    Stock_Deduct(Id,Inv,BOn,BOn,3);

                    If (QtyPick<>0) and (Not (FIFO_Mode(Stock.StkValType) In [2,3,5])) then
                    Begin
                      OldLCost:=OldLCost+Round_Up(WORReqQty(Id)*CostPrice,2);


                      CostPrice:=FIFO_GetCost(Stock,Inv.Currency,WORReqQty(Id),1.0,MLocStk);

                      NewLCost:=NewLCost+Round_Up(WORReqQty(Id)*CostPrice,2);

                    end;
                  end;


                end;
                {else
                  QtyPick:=0;}


                SOPLineNo:=PickRNo;

                If (ThisScrt<>NIL) then
                Begin

                  Status:=GetPos(F[Fnum2],Fnum2,RecAddr);  {* Get Preserve IdPosn *}

                  ThisScrt^.Add_Scratch(Fnum2,Keypath2,RecAddr,Stock.BinLoc+Stock.StockCode,'');

                end;

              end; {If LineOk..}

            end; {If Line Due}

            Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

            Report_BError(Fnum2,Status);


            If (Not FoundOk) then
              Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

          end; {While..}

          If (GotLines) and (Not FoundOk) then
          Begin

            PickRunNo:=PickRNo;

            If (Not GotOrd) then {* Preserve this header for a link *}
              OrdFolio:=FolioNum;

            GotOrd:=BOn;

            {* Adjust theoretical cost *}
            TotalCost:=TotalCost+NewLCost-OldLCost;
          end
          else
            PickRunNo:=0;


          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          If (StatusOk) then
            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          Report_BError(Fnum,Status);

          If (FoundOk) and (GotLines) and (SetPickNo) then {* Reverse out auto pick *}
            Abort_AutoPick(PickRNo,Fnum2,Keypath2,KeyChkI);

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

Procedure TWOPPickFrm.Run_PickList(CRepParam  :  PPickRepPtr;
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
        Set_PickRun(FullNomKey(WORUPRunNo),
                    NextRNo,
                    PickAuto,
                    PickTag,
                    PickExc,
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

            {* Close temp thread file, as DLL needs access to it *}

            Status:=Close_File(F[ReportF]);


            {Ok2Print:=pfInitNewBatch(BOn,BOff); V5 use thread model only
            BatchStart:=Ok2Print;}


            PDevRec.feJobTitle:='Consolidated Picking List';

            {* V5, this part added into thread as printing direct was causing a problem}
            {There was originally a mechanism here to allow the consolidated part to be added
            in at the top of the individual picking lists. This technique caused InPrint to be set, and so
            the second print job was always waiting for the first print job. In v5 the consolidated part
            was moved into its own thread}

            AddSta2PrintQueue(PDevRec,13,SyssForms.FormDefs.PrimaryForm[51],
                              InvF,InvOurRefK,ReportF,RPK,
                              Inv.OurRef,
                              FullNomKey(ThisSCrt^.Process),
                              StaCtrl^);


            {$IFDEF NOTV5}
              If (Ok2Print) then
                Ok2Print:=pfAddBatchForm(PDevRec,13,SyssForms.FormDefs.PrimaryForm[51],
                                         InvF,InvOurRefK,Inv.OurRef,ReportF,RPK,
                                         FullNomKey(ThisSCrt^.Process),
                                         'Consolidated Picking List',
                                         StaCtrl,
                                         BOn);

              If (Ok2Print) and (Not PSOPInp.PickSing) then {* Print batch now, as thread will not be run.. *}
                Ok2Print:=pfPrintBatch('Consolidated Picking List',PDevRec.NoCopies,BOn,PDevRec.feJobtitle);
            {$ENDIF}
          end;

          If (PSOPInp.PickSing) and (Ok2Print) then  {* Print single Run *}
          Begin
            PickRNo:=NextRNo;
            MatchK:=FullNomKey(WORUPRunNo);
            Fnum2:=IdetailF;
            Keypath2:=IdLinkK;
            PRMode:=10;
            DefMode:=14; 

            AddPick2Thread(Application.MainForm,CRepParam);
          end;

        end;

      end;

      Put_LastSOPVal(AllocSCode,PSOPInp,80);

      If (Not PSOPInp.PickSing) then {* Dispose of it, as thread will not *}
        Dispose(ThisSCrt,Done);

    end; {If abort print }

    PutMultiSys(DefR,BOn);

    Dispose(StaCtrl);

  end; {If Locked..}


end; {Proc..}




procedure TWOPPickFrm.FormCreate(Sender: TObject);
begin
  ClientHeight:=129;
  ClientWidth:=299;

  Left:=Round((Screen.Width/2)-(Width/2));
  Top:=Round((Screen.Height/2)-(Height/2));

  KeepRun:=BOn;

  Running:=BOff;
end;





procedure TWOPPickFrm.FormActivate(Sender: TObject);
begin
  If (Not Running) then
  Begin
    Running:=BOn;

    Run_PickList(PCRepParam,PDocHed);

    ShutDown;
  end;


end;

end.
