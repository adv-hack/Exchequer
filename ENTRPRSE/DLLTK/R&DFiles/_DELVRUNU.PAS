unit DelvRunU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges,  BTSupU1, GlobVar, VarConst,
  BTSupU3,

  {$IFDEF CU}
    CustIntU,
  {$ENDIF}

  SBSComp2;

type

  TSOPRunFrm = class(TForm)
    SBSPanel3: TSBSPanel;
    Label1: Label8;
    CanCP1Btn: TButton;
    Label2: TLabel;
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

    private
      CopyTagNo,
      Running,
      KeepRun    :  Boolean;

      {$IFDEF Cu}

        PACustomEvent,
        DelCustomEvent   :  TCustomEvent;

        {*EN501DELHK*}
      {$ENDIF}




      KeyV       :  TModalResult;

      Procedure Send_UpdateList(Mode   :  Integer);

      Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;


      Procedure Auto_PickKit(KitLine  :  IDetail;
                             Fnum2,
                             KeyPath2 :  Integer;
                             KeyS     :  Str255;
                             UpdateMode
                                      :  Byte);

      Procedure TxFrSNos(OrdR,InvR  :  InvRec;
                         OId,IdR    :  IDetail;
                         InvMode    :  Boolean);


      Procedure B2BSNos(OrdR,InvR  :  InvRec;
                        OId,IdR    :  IDetail;
                        GetSer     :  Double);


      
{$IFDEF SOPDLL}
     public
{$ENDIF}
      Procedure SOP_ProcessDel(ConsA,
                               SingDoc:  Boolean;
                           Var B_Func :  Integer;
                               SOPRNo :  LongInt;
                               SOPMLoc:  Str10;
                               Fnum,
                               Keypath,
                               KeyResP:  Integer;
                               Mode   :  Byte);

    {$IFDEF WOP}
       Procedure WOP_ProcessWOR(ConsA,
                                SingDoc:  Boolean;
                            Var B_Func :  Integer;
                                SOPRNo :  LongInt;
                                SOPMLoc,
                                AdjNo  :  Str10;
                                Fnum,
                                Keypath,
                                KeyResP:  Integer;
                                Mode   :  Byte);

       Procedure WOP_BuildWOR(SingDoc:  Boolean;
                              SOPRNo :  LongInt;
                              SOPMLoc:  Str10;
                          Var B_Func :  Integer;
                              Fnum,
                              Keypath,
                              KeyResP:  Integer;
                              Mode   :  Byte);


       Procedure WOP_RevealRun(MatchK  :  Str255;
                               MLen,
                               Mode    :  Byte;
                               Fnum,
                               Keypath :  Integer);

       Procedure WOP_RunIssue(MatchK    :  Str255;
                              MatchLen  :  Byte;
                          Var SOPRunNo  :  LongInt;
                              FindTag   :  Byte;
                              Fnum,
                              Keypath   :  Integer;
                          Var GotOrd    :  Boolean;
                              SOPLoc    :  Str5;
                              Mode      :  Byte);

       Procedure WOP_CtrlRun(NextRNo  :  LongInt;
                             Mode     :  Byte);

       Procedure WOP_GenAdj(SingDoc  :  Boolean;
                            DocHed   :  DocTypes;
                            NextRNo  :  LongInt;
                            Mode     :  Byte);

       Procedure WOP_BuildAdj(SingDoc  :  Boolean;
                              DocHed   :  DocTypes;
                              NextRNo  :  LongInt;
                              Mode     :  Byte);

    {$ENDIF}

      Procedure SOP_ConvertDel(ConsA,
                               SingDoc:  Boolean;
                           Var B_Func :  Integer;
                               SOPRNo :  LongInt;
                               Fnum,
                               Keypath,
                               KeyResP:  Integer;
                               Mode   :  Byte);

      Procedure SOP_RevealRun(MatchK  :  Str255;
                              MLen,
                              Mode    :  Byte;
                              Fnum,
                              Keypath :  Integer);

      Function OverrideCons(ConsA  :  Boolean;
                            CCode  :  Str10;
                            DelMode:  Byte)  :  Boolean;

      Procedure SOP_RunDel(MatchK    :  Str255;
                           MatchLen  :  Byte;
                       Var SOPRunNo  :  LongInt;
                           FindTag   :  Byte;
                           ConsA     :  Boolean;
                           Fnum,
                           Keypath   :  Integer;
                       Var GotOrd    :  Boolean;
                           SOPLoc    :  Str5;
                           Mode      :  Byte);

      Procedure Test_Pattern(DMode  :  Byte;
                             DocHed :  DocTypes);

      Procedure Warn_PrnChange(DMode  :  Byte;
                               PName,
                               RMsg   :  Str255;
                               DocHed :  DocTypes);

      Function SOP_Check4Pick(Fnum,
                              Keypath  :  Integer;
                              InvR     :  InvRec;
                              SOPLoc   :  Str10)  :  Boolean;

      Procedure SOP_GenDel(SingDoc  :  Boolean;
                           DocHed   :  DocTypes;
                           NextRNo  :  LongInt;
                           Mode     :  Byte);
                           


      Procedure SOP_GenInv(SingDoc  :  Boolean;
                           DocHed   :  DocTypes;
                           NextRNo  :  LongInt;
                           Mode     :  Byte);

    public
      { Public declarations }
      PCRepParam :  PPickRepPtr;
      PDocHed    :  DocTypes;
      ThisMode   :  Byte;
      ThisRun    :  LongInt;
      SingleDoc  :  Boolean;
    {$IFDEF SOPDLL}
      ErrCode : Integer;
      ToDoc   : string;
    {$ENDIF}

      procedure ShutDown;

      Procedure PickSORvPOR(POR      :  InvRec;
                            PORLine  :  IDetail;
                            Fnum,
                            Keypath,
                            Fnum2,
                            KeyPath2 :  Integer;
                            UpdateMode
                                     :  Byte);

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  RPDevice,
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  EXWrap1U,
  SysU1,
  SysU2,
  BTSupU2,
  BTSFrmu1,
  SCRTCH1U,
  InvListU,
  InvLst2U,
  InvCTSuU,
  InvCT2SU,
{$IFNDEF SOPDLL}
  InvFSu2U,
{$ELSE}
  SpDllSup,
{$ENDIF}

  {$IFDEF CL_On}
    LedgSupU,
    NoteSupU,
  {$ENDIF}

  {$IFDEF DPr_On}
    DEFProcU,
  {$ENDIF}

  {$IFDEF CU}
    CustWinU,
    OInv,
  {$ENDIF}

  {$IFNDEF SOPDLL}
  FIFOL2U,
  {$ELSE}
  FIFOLU,
  {$ENDIF}
  DelvPMsU,
  MiscU,
  Event1U,
  {$IFNDEF SOPDLL}
  SOPCt1U,
  SOPCt2U,
  {$ENDIF}
  SOPCt3U,
  StkSerNU,
  Warn1U,
  {$IFNDEF SOPDLL}
  PrintFrm,
  {$ENDIF}

  GlobType,
  {$IFNDEF WOP}
  LabelDlg;

  DllInt,
  {$ELSE}
    WOPCT1U;

  {$ENDIF}

{  Exthrd2U;}





{$R *.DFM}





procedure TSOPRunFrm.CanCP1BtnClick(Sender: TObject);
begin
  KeyV:=mrAbort;

  Loop_CheckKey(KeepRun,KeyV);

  If (Not KeepRun) then
    CanCp1Btn.Enabled:=BOff;
end;


Procedure TSOPRunFrm.WMCustGetRec(Var Message  :  TMessage);

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



Procedure TSOPRunFrm.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
{$IFNDEF SOPDLL}
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);
{$ENDIF}
end; {Proc..}

procedure TSOPRunFrm.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;



Procedure TSOPRunFrm.Auto_PickKit(KitLine  :  IDetail;
                                  Fnum2,
                                  KeyPath2 :  Integer;
                                  KeyS     :  Str255;
                                  UpdateMode
                                           :  Byte);


Var
  TmpStat      :   Integer;

  LOK,
  Locked,
  FoundBOM,
  AbortBOM     :   Boolean;

  RecAddr      :   LongInt;

  CouldPick,
  PickNow      :   Double;

  KeyChk       :   Str255;

  TmpInv       :   InvRec;
  BomLine,
  TmpId        :   IDetail;

  KitStk       :   StockRec;


Begin
  TmpInv:=Inv;
  TmpId:=Id;

  CouldPick:=-1; PickNow:=0.0;  FoundBOM:=BOff; AbortBOM:=BOff;


  KeyChk:=FullNomKey(KitLine.FolioRef);

  {* Parent must be further up so search back to find it *}

  TmpStat:=Find_Rec(B_GetPrev,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS);

  While (TmpStat=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not FoundBOM) and (Not AbortBOM) do
  With Id do
  Begin
    If (StockCode<>Stock.StockCode) and (KitLink=0) then
      Global_GetMainRec(StockF,StockCode);

    FoundBOM:=(KitLink=0) and (Stock.StockFolio=KitLine.KitLink) and (Not Is_SerNo(Stock.StkValType)) and (Stock.StockType=StkBillCode) and  (Stock.ShowasKit);

    AbortBOM:=(Not FoundBOM) and (KitLink=0);

    If (Not FoundBOM) and (Not AbortBOM) then
      TmpStat:=Find_Rec(B_GetPrev,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

  end; {While.}

  If (FoundBOM) then
  Begin
    BOMLine:=Id;
    KitStk:=Stock;

    TmpStat:=GetPos(F[Fnum2],Fnum2,RecAddr);  {* Preserve Line Posn *}

    KeyS:=FullRunNoKey(BOMLine.FolioRef,BOMLine.LineNo);

    TmpStat:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    While (TmpStat=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Id.KitLink=KitStk.StockFolio) do
    With Id do
    Begin
      If (Is_FullStkCode(StockCode)) then
      Begin
        PickNow:=Trunc(DivWChk(QtyPick,DivWChk(Qty,BOMLine.Qty)));

        If (PickNow<CouldPick) or (CouldPick=-1) then
          CouldPick:=PickNow;
      end;

      TmpStat:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    end; {While..}

    If (CouldPick>0) and (CouldPick>BOMLine.QtyPick) then {Update BOM parent line with total possible to pick}
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
            Stock_Deduct(Id,Inv,BOff,BOn,3); {* Reverse picked qty *}

          QtyPick:=CouldPick;

          Stock_Deduct(Id,Inv,BOn,BOn,3); {* Adjust picked qty *}

          TmpStat:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

          Report_BError(Fnum2,TmpStat);

          TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,RecAddr);

          SOP_SeekDescLines(0,Id,Keypath2);

        end;

      end;

    end;
  end;


  Id:=TmpId;
  Inv:=TmpInv;
end; {PRoc..}



{ ===== Proc to Transfer all Serial nos from one document to another ===== }

Procedure TSOPRunFrm.TxFrSNos(OrdR,InvR  :  InvRec;
                              OId,IdR    :  IDetail;
                              InvMode    :  Boolean);


Const
  Fnum      = MiscF;
  Keypath   = MIK;

Var
  KeyS,KeyChk  :  Str255;

  DiscP,
  SerCount,
  SerGot       :  Double;
  SalesDoc,
  FoundOk,
  FoundAll,
  LOk,
  Locked       :  Boolean;

  LAddr        :  LongInt;


Begin

  FoundAll:=(IdR.SerialQty=0.0);  SerCount:=0.0;

  SerGot:=IdR.SerialQty;

  SalesDoc:=(OrdR.InvDocHed In SalesSplit) or ((OrdR.InvDocHed In WOPSplit) and (OId.LineNo<>1));

  If (OrdR.InvDocHed In WOPSPlit) and (SerGot<0) and (OId.LineNo<>1) then
    SerGot:=SerGot*DocNotCnst;

  If (OId.StockCode<>Stock.StockCode) then
  Begin
    Global_GetMainRec(StockF,OId.StockCode);
  end;

  If (Is_SerNo(Stock.StkValType)) and (Not FoundAll) then
  Begin

    If (SalesDoc) then
      KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio)+#1)
    else
      KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio));


    KeyS:=KeyChk+NdxWeight;


    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) do
    With MiscRecs^.SerialRec do
    Begin
      With OrdR,OId do
        If (SalesDoc) then
          FoundOk:=((CheckKey(OurRef,OutDoc,Length(OurRef),BOff)) and (SoldLine=ABSLineNo))
        else
          FoundOk:=((CheckKey(OurRef,InDoc,Length(OurRef),BOff)) and (BuyLine=ABSLineNo));

      If (FoundOk) then
      With InvR,IdR do
      Begin
        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (LOk) and (Locked) then
        Begin


          If (SalesDoc) then
          Begin
            If (Not InvMode) then
            Begin
              OutOrdDoc:=OutDoc;
              OutOrdLine:=SoldLine;
            end;

            OutDoc:=OurRef;

            SoldLine:=ABSLineNo;
          end
          else
          Begin
            If (Not InvMode) then
            Begin
              InOrdDoc:=InDoc;
              InOrdLine:=BuyLine;
            end;

            Begin

              DiscP:=Calc_PAmount(Round_Up(NetValue,Syss.NoCosDec),Discount,DiscountChr);

              SerCost:=Round_Up(Calc_StkCP((NetValue-DiscP+CostPrice),QtyMul,UsePack),Syss.NoCosDec);

              CurCost:=InvR.Currency;

              SerCRates:=CXRate;
              SerTriR:=CurrTriR;

              If (SerCRates[BOff]=0.0) then
              Begin
                SerCRates[BOff]:=SyssCurr^.Currencies[CurCost].CRates[BOff];
                SetTriRec(CurCost,SUseORate,SerTriR);
              end;
            end;

            InDoc:=OurRef;

            BuyLine:=ABSLineNo;
          end;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          Report_BError(Fnum,Status);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          {* Don't include a batch child in a purch conversion, as it might have already
             been sold in which case there would be twice as many entries to change, only
             change the main one *}

          If (Not BatchChild) or (SalesDoc) then
          Begin
            If (BatchRec) then
            Begin
              If (SalesDoc) then
                SerCount:=SerCount+QtyUsed
              else
                SerCount:=SerCount+BuyQty;
            end
            else
              SerCount:=SerCount+1.0;
          end;
        end; {If Locked..}
      end;

      FoundAll:=(SerCount>=SerGot);

      If (Not FoundAll) then
        Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}
  end; {If SNo..}


end; {Proc..}




{ ===== Proc to Transfer all Serial nos from one document to another ===== }

Procedure TSOPRunFrm.B2BSNos(OrdR,InvR  :  InvRec;
                             OId,IdR    :  IDetail;
                             GetSer     :  Double);


Const
  Fnum      = MiscF;
  Keypath   = MIK;

Var
  KeyS,KeyChk  :  Str255;

  B_Func       :   Integer;

  SerialR,
  DocPCost,
  DiscP,
  SerCount     :  Double;

  LAddr        :  LongInt;

  FoundOk,
  FoundAll,
  LOk,
  Locked       :  Boolean;


Begin

  {FoundAll:=(OId.SerialQty=0.0);}

  FoundAll:=(GetSer=0.0);

  SerCount:=0.0;

  SerialR:=0.0; DocPCost:=0.0;  LAddr:=0;

  B_Func:=B_GetNext;

  If (OId.StockCode<>Stock.StockCode) then
  Begin
    Global_GetMainRec(StockF,OId.StockCode);
  end;

  If (Is_SerNo(Stock.StkValType)) and (Not FoundAll) then
  Begin

    KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio));


    KeyS:=KeyChk;


    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) do
    With MiscRecs^.SerialRec do
    Begin
      B_Func:=B_GetNext; {After pos preserved}

      With OrdR,OId do
        FoundOk:=(((CheckKey(OurRef,InDoc,Length(OurRef),BOff) and (BuyLine=ABSLineNo))
                  or (CheckKey(OurRef,InOrdDoc,Length(OurRef),BOff) and (InOrdDoc<>'') and (InOrdLine=ABSLineNo)))
                  and (Not Sold));

      If (FoundOk) then
      With InvR,IdR do
      Begin
        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (LOk) and (Locked) then
        Begin
          If (Not BatchRec) then
          Begin
            SERN_SetUse(Fnum,Keypath,SerialR,DocPCost,InvR,IdR);

            SerCount:=SerCount+1.0;

            B_Func:=B_GetGEq;
          end
          else
          Begin
            B_Func:=B_GetGEq; {After pos preserved}

            SerCount:=SerCount+BuyQty;

            If (LOk) and (Locked) then
            Begin
              Make_BatchSetUse(Fnum,KeyPath,InvR,IdR,BuyQty-QtyUsed,LAddr);

            end;

          end;
        end; {If Locked..}
      end;

      FoundAll:=(SerCount>=ABS(GetSer));

      If (Not FoundAll) then
      Begin
        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        FoundAll:=Sold;
      end;

    end; {While..}
  end; {If SNo..}


end; {Proc..}



{ == Auto pick SOR from POR == }
{UpdateMode 0 = qty pick & Cost
            1 = Cost only}

Procedure TSOPRunFrm.PickSORvPOR(POR      :  InvRec;
                                 PORLine  :  IDetail;
                                 Fnum,
                                 Keypath,
                                 Fnum2,
                                 KeyPath2 :  Integer;
                                 UpdateMode
                                          :  Byte);


Var
  KeyResP,
  TmpStat      :   Integer;

  LineRecAddr,
  DocRecAddr,
  TmpRecAddr,
  TmpRecAddr2
               :   LongInt;

  UpdateLCost  :   Boolean;
  PickDiff,
  NewCost,
  PLDisc,
  Rnum         :   Double;
  KeyS,
  KeyChk       :   Str255;

  TmpInv       :   InvRec;
  OldId,
  TmpId        :   IDetail;


procedure Synch_BOMCost(SYMode  :  Byte);


  Var

    LOK,
    Locked   :   Boolean;


  Begin
    LOK:=BOff; Locked:=BOff;

    SetDataRecOfs(Fnum,DocRecAddr);

    If (DocRecAddr<>0) then
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP,0)
    else
      Status:=4;

    If (StatusOk) then
    Begin
      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyResP,Fnum,BOn,Locked,DocRecAddr);

    end;

    If (LOk) and (Locked) then {Update cost of WOR from lower level}
    With Inv do
    Begin
      TotalCost:=TotalCost+NewCost;

      KeyS:=FullIdKey(FolioNum,1);

      TmpStat:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

      If (TmpStat=0) then
      Begin
        Case SYMode of
          0  :  With Id do
                Begin
                  Costprice:=Round_Up(DivWChk(TotalCost,WORReqQty(Id)),Syss.NoCosDec);

                  TmpStat:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPAth2);

                  Report_BError(Fnum2,TmpStat);
                end;


        end; {Case..}
      end;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP);

      Report_BError(Fnum,Status);

      TmpStat:=UnLockMultiSing(F[Fnum],Fnum,DocRecAddr);

    end;

  end;

Begin
  TmpInv:=Inv;
  TmpId:=Id;

  KeyResP:=InvFolioK;

  Rnum:=0.0; NewCost:=0.0;  UpdateLCost:=BOn; PickDiff:=0;

  TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOff,BOff);

  TmpStat:=Presrv_BTPos(Fnum2,KeyPath2,F[Fnum2],TmpRecAddr2,BOff,BOff);

  Blank(KeyS,Sizeof(KeyS));
  Blank(KeyChk,Sizeof(KeyChk));

  PLDisc:=0.0;

  With PORLine do
  If (IdDocHed<>WOR) then
    KeyChk:=FullRunNoKey(B2BLink,B2BLineNo)
  else
    KeyChk:=FullRunNoKey(SOPLink,SOPLineNo);

  KeyS:=KeyChk;

  TmpStat:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,IdLinkK,KeyS);

  {Only auto pick lines with matching stock code and locations}

  If (TmpStat=0) and (CheckKey(PORLine.StockCode,Id.StockCode,Length(PORLine.StockCode),BOff)) and
    (Qty_OS(Id)>0) and ((Not Syss.UseMLoc) or (UPdateMode=1) or (CheckKey(PORLine.MLocStk,Id.MLocStk,Length(PORLine.MLocStk),BOff))) then
  With Id do
  Begin
    Status:=GetPos(F[Fnum2],Fnum2,LineRecAddr);  {* Preserve Line Posn *}

    KeyS:=FullNomKey(FolioRef);

    TmpStat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP,KeyS);

    If (TmpStat=0) then
    Begin
      Status:=GetPos(F[Fnum],Fnum,DocRecAddr);  {* Preserve DocPosn *}

      NewCost:=Round_Up(WORReqQty(Id)*CostPrice,2)*DocNotCnst;

      OldId:=Id;

      If (UpDateMode<>1) then
      Begin
        If (Is_FullStkCode(StockCode)) then
        Begin
          Stock_Deduct(Id,Inv,BOff,BOn,3); {* Reverse picked qty *}

          UpdateLCost:=(FIFO_Mode(Stock.StkValType)<>6); {Only update the line cost with non std valuation type stock records}
        end;


        If (((PORLine.QtyPick*PORLine.QtyMul)+QtyPick)<=Qty_OS(Id)) then
          QtyPick:=(PORLine.QtyPick*PORLine.QtyMul)+QtyPick
        else
          QtyPick:=Qty_OS(Id);

        PickDiff:=(QtyPick-OldId.QtyPick);

        If (Is_FullStkCode(StockCode)) then
        Begin
          Stock_Deduct(Id,Inv,BOn,BOn,3); {* Adjust picked qty *}

          If (IdDocHed=WOR) then
            SerialQty:=SerialQty+(PickDiff*-1)
          else
            SerialQty:=SerialQty+PickDiff;
        end;
      end;

      If (UpdateLCost) then
      Begin
        {* Adjust costprice+uplift from POR *}

        With PORLine do
          PLDisc:=Calc_PAmount(Round_Up(NetValue,Syss.NoCOSDec),Discount,DiscountChr);

        If (ShowCase) and (PORLine.ShowCase) then {*v5, if show case, we need to fivide cost by pack size}
          Rnum:=Currency_ConvFT(Calc_StkCP(PORLine.NetValue+PORLine.CostPrice-PLDisc,PORLine.QtyPack,PORLine.UsePack),
                                   PORLine.Currency,Currency,UseCoDayRate)
        else
          Rnum:=Currency_ConvFT(Calc_StkCP(PORLine.NetValue+PORLine.CostPrice-PLDisc,PORLine.QtyMul,PORLine.UsePack),
                                   PORLine.Currency,Currency,UseCoDayRate);

        {v4.32.001 Split into two operations to account for pack sizes correctly*}


        If (IdDocHed<>WOR) then
          CostPrice:=Round_Up(Calc_IdQty(Rnum,QtyMul,Not UsePack),Syss.NoCosDec)
        else
          CostPrice:=Round_Up(Rnum,Syss.NoCosDec);

        If (CostPrice<>0.0) and (PickDiff>0.0) and (IdDocHed<>WOR) then {v4.32.003 We must refresh COS rate here to pick up cost based on current daily rate}
        Begin
          If (PORLine.Currency<>Currency) then {Current daily rate must have been used in the calculation}
            COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate]
          else {Use same rate as POR so that the match when posted}
            COSConvRate:=XRate(PORLine.CXRate,UseCoDayRate,Currency);
        end;

      end;

      Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

      NewCost:=NewCost+Round_Up(WORReqQty(Id)*CostPrice,2);

      Report_BError(Fnum2,Status);

      If (UpdateMode<>1) then
      Begin
        If (Is_FullStkCode(StockCode)) then
          B2BSNos(POR,Inv,PORLine,Id,Id.QtyPick-OldId.QtyPick);

        If (Not Is_FullStkCode(StockCode)) then
          StockCode:='X'; {Force a stock code through here temporarily so that any additional desc lines will be picked on on stock lines}

        SOP_SeekDescLines(0,Id,Keypath2);
      end;

      If (Inv.InvDocHed=WOR) and (NewCost<>0.0) and (UpdateLCost) then {Update new cost}
        Synch_BOMCost(0);

      
      SetDataRecOfs(Fnum2,LineRecAddr);

      If (LineRecAddr<>0) then {Re-estabish line position prior to checking for a kit}
        Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0)
      else
        Status:=4;

      {*If this part of a kit, attempt to pick header level*}

      {$B-}
      If (StatusOk) and (Inv.InvDocHed<>WOR) and (UpdateMode<>1) and (Id.KitLink<>Inv.FolioNum) and (Id.KitLink<>0) then
      {$B+}
        Auto_PickKit(Id,Fnum2,KeyPath2,FullRunNoKey(Id.FolioRef,Id.LineNo),UpdateMode);


    end;


  end;

  TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOn,BOff);

  TmpStat:=Presrv_BTPos(Fnum2,KeyPath2,F[Fnum2],TmpRecAddr2,BOn,BOff);


  Id:=TmpId;
  Inv:=TmpInv;
end; {PRoc..}



{ ============= SOP Processing Routines, ?OR->?DN & ?DN->?IN ==========

SOP_ProcessDel
Assumes the Global Inv Structure contains the Tranaction to be processed.

  ConsA : True Indicates if we will be consolidating matching account code/currency Orders into conslidated delivery notes.
  Mutually exclusive with SingDoc as instead of creating a one to one Delviery Note for each Order a search will be made
  for any matching ones which could be appended.  At the end of the entire process SOP_RevealRun must be run to reveal
  the transactions which created as part of this process by setting their RunNos correctly.

  SingDoc : True Indicates that we will be generating a single Delivery Note for this order. Mutually exclusive with ConsA.

  B_Func :   If this routine is being used as part of a loop which processes Orders, returns the next appropriate Btrieve
  operation since the order may well have been placed into history as a result of the delivery, and hence a GetNext will
  no longer work.

  SOPRNo  :  Pass in next sequential RunNo which is used to build BatchLink so that we can reprint by runno later on.
             Really only applies when processing a batch or when Consolidating.

  SOPMLoc :  Location filter. Restricts processing of order lines which match this location.  Blank for all.

  Fnum    :  InvF;
  Keypath :  InvRNoK
  KeyRes  :  The InvF Keypath in operation prior to calling SOP_ProcessDel so its position can be restored afterwards.


Generation modes:-


  1  :  Orders to Delivery notes
  3  :  Orders direct to Invoices

}


{ ========== Proc to generate a ?DN from a ?OR ========= }



Procedure TSOPRunFrm.SOP_ProcessDel(ConsA,
                                    SingDoc:  Boolean;
                                Var B_Func :  Integer;
                                    SOPRNo :  LongInt;
                                    SOPMLoc:  Str10;
                                    Fnum,
                                    Keypath,
                                    KeyResP:  Integer;
                                    Mode   :  Byte);




Var
  UOR      :  Byte;
  TmpStat,
  Fnum2,
  Keypath2 :  Integer;

  KeyS,
  KeyChk   :  Str255;

  LAddr,
  DocRecAddr,
  HedAddr,
  IdRecAddr:  LongInt;


  TmpInv   :  ^InvRec;
  TmpId,
  WOId     :  ^Idetail;

  GotHed,
  StillOS,
  Locked,
  AddDesc  :  Boolean;

  EarlyDate:  LongDate;

  MatchVal,
  OldOSVal,
  NewOSVal :  Real;

  OldWOVal,
  NewWOVal :  Double;

  ExLocal  :  TdExLocal;


Begin

  New(TmpInv);
  New(TmpId);
  New(WOId);

  TmpInv^:=Inv;
  TmpId^:=Id;
  WOId^:=Id;

  GotHed:=BOff;
  StillOS:=BOff;
  Locked:=BOff;

  MatchVal:=0;

  NewOSVal:=0;
  OldOSVal:=0;

  NewWOVal:=0;
  OldWOVal:=0;


  AddDesc:=BOff;  HedAddr:=0;

  B_Func:=B_GetNext;

  EarlyDate:=MaxUntilDate;

  Fnum2:=IDetailF; Keypath2:=IdFolioK;

  DocRecAddr:=0; IdRecAddr:=0;

  Status:=GetPos(F[Fnum],Fnum,DocRecAddr);  {* Preserve DocPosn *}

  Begin
    KeyChk:=FullNomKey(Inv.FolioNum);

    KeyS:=FullIdKey(Inv.FolioNum,1);

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Id do
    Begin

      Application.ProcessMessages;

      Status:=GetPos(F[Fnum2],Fnum2,IdRecAddr);  {* Preserve Line Posn *}

      TmpId^:=Id;

      If (Not GotHed) and (SOP_CheckPickQty(TmpId^,Mode)) then
      Begin

        GotHed:=Get_InvHed(TmpInv^,ConsA,SOPRNo,Fnum,Keypath,Mode,HedAddr, CopyTagNo);


        {* If Consolidated, add a descriptive line here before each order *}

        AddDesc:=ConsA;

      end;

      If (GotHed) or (TmpId^.QtyPick=0) then
      Begin

        Label2.Caption:='Generating '+Inv.OurRef;

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin
          Application.ProcessMessages;

          {* Update Order Line *}

          If (Is_FullStkCode(StockCode)) then
            Stock_Deduct(Id,Inv,BOff,BOn,0);

          OldOSVal:=InvLOOS(Id,BOn,0);

          WOId^:=Id;
          WOId^.QtyDel:=0.0;

          OldWOVal:=InvLOOS(WOId^,BOn,0);


          If (SOP_CheckLoc(Id,SOPMLoc,Mode)) then
          Begin
            If ((KitLink=0) or (Is_FullStkCode(StockCode))) then {* Ignore Description only lines *}
            Begin
              QtyDel:=QtyDel+QtyPick;
              QtyWOff:=QtyWOff+QtyPWOff;

              If (Cust.SOPAutoWOff) and (Qty_OS(Id)<>0) then {* Write off remaining value *}
                QtyWOff:=QtyWOff+Qty_OS(Id);

            end;

            QtyPick:=0; QtyPWOff:=0;
          end;

          {* Amount to be taken off order value *}

          NewOSVal:=NewOSVal+(OldOSVal-InvLOOS(Id,BOn,0));

          WOId^:=Id;
          WOId^.QtyDel:=0.0;

          NewWOVal:=NewWOVal+(OldWOVal-InvLOOS(WOId^,BOn,0));


          If (Qty_OS(Id)=0) then  {* ResetLine *}
            LineType:=StkLineType[DocTypes(Ord(IdDocHed)+3)]
          else
          Begin

            StillOS:=BOn;

            If (PDate<EarlyDate) then
              EarlyDate:=PDate;

          end;

          If (Is_FullStkCode(StockCode)) then
            Stock_Deduct(Id,Inv,BOn,BOn,0);


          {$IFDEF PF_On}

            If (JBCostOn) and (KitLink=0) and SOP_CheckLoc(Id,SOPMLoc,Mode) then
            Begin
              Update_JobAct(Id,TmpInv^);

            end;

          {$ENDIF}


          Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

          Report_BError(Fnum2,Status);

          If (StatusOk) then
            TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);


          If (StatusOk) and (SOP_CheckPickQty(TmpId^,Mode)) and
           (SOP_CheckLoc(Id,SOPMLoc,Mode)) then
          Begin

            If (AddDesc) then
              Ok:=Gen_InvLine(TmpId^,TmpInv^,Fnum2,Keypath2,(Mode+10),ConsA,MatchVal);

            Ok:=Gen_InvLine(TmpId^,TmpInv^,Fnum2,Keypath2,Mode,ConsA,MatchVal);

            AddDesc:=BOff;

            If (TmpId^.QtyPick<>0.0) then
            Begin
              If (TmpInv^.InvDocHed=POR) and (TmpInv^.PORPickSOR) and (TmpId^.B2BLink<>0) and
                 (TmpId^.B2BLineNo<>0) then
              Begin  {* Go pick equivalent SOR line number *}
                PickSORvPOR(TmpInv^,TmpId^,Fnum,KeyPath,Fnum2,KeyPath2,0);

              end;

              If (Is_FullStkCode(TmpId^.StockCode)) then
                TxfrSNos(TmpInv^,Inv,TmpId^,Id,BOff);
            end;

          end;

        end; {If Line Locked..}

      end; {If Header generated ok..}

      SetDataRecOfs(Fnum2,IdRecAddr);

      If (IdRecAddr<>0) then
        Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);

      Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    end; {While..}

    If (GotHed) then  {* Store new Header *}
    Begin

      Application.ProcessMessages;

      If (SingDoc) then
      Begin

        Reveal_SOPDoc(Inv,Mode);

        {CIS Generate any tax implications here}

        {$IFDEF JC}
          If (Mode=3) then {Orders to invoices}
            Calc_CISTaxInv(Inv,BOn);
        {$ENDIF}

        ExLocal.Create;

        CalcInvTotals(Inv,ExLocal,BOn,BOn);

        ExLocal.Destroy;

        Calc_StockDeduct(Inv.FolioNum,BOff,0,Inv,BOff); {* Re-calculate BOM situation *}

        Set_DocAlcStat(Inv);  {* Set Allocation Status *}

      end;

      {$IFDEF SOPDLL}
       ToDoc := Inv.OurRef;
      {$ENDIF}

      Inv.NLineCount:=Inv.NLineCount+TmpInv^.NLineCount;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      TmpStat:=UnLockMultiSing(F[Fnum],Fnum,HedAddr);

      {v5.01 - Notify that delivery note has been created}

      {$IFDEF CU}{*EN501DELHK*}
        If (Assigned(DelCustomEvent)) then
        With DelCustomEvent do
        Begin
          TInvoice(EntSysObj.Transaction).ResetTrans(Inv);

          Execute;
        end;
      {$ENDIF}


      If (StatusOk) and (Not (Inv.InvDocHed In QuotesSet+PSOPSet)) and (Not Syss.UpBalOnPost) and (SingDoc)
         and (Mode=3) then
      With Inv do
        UpdateBal(Inv,(ConvCurrITotal(Inv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                 (ConvCurrICost(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                 (ConvCurrINet(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                 BOff,2);

      {* Add matching record here with match val *}

      Application.ProcessMessages;

      {$IFDEF CL_On}

        With Inv do
        Begin

          RemitNo:=TmpInv^.OurRef;

          UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

          Match_Payment(Inv,Round_Up(Conv_TCurr(MatchVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                        ,MatchVal,20);

          CopyNoteFolio(NoteDCode,NoteDCode,FullNCode(FullNomKey(TmpInv^.FolioNum)),FullNCode(FullNomKey(Inv.FolioNum)),0);
        end;

      {$ENDIF}
    {$IFNDEF SOPDLL}
    end;
    {$ELSE}
    end;
{    else
      ErrCode := 30003;}
    {$ENDIF}

    SetDataRecOfs(Fnum,DocRecAddr);

    If (DocRecAddr<>0) then
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP,0);

    With Inv do
    Begin

      Locked:=BOff;

      Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyResP,Fnum,BOn,Locked,LAddr);

      If (Ok) and (Locked) then
      Begin

        If (StillOS) then
        Begin

          DueDate:=EarlyDate;

          BatchLink:=QUO_DelDate(Inv.InvDocHed,Inv.DueDate);

          B_Func:=B_GetGEq;

        end
        else
        Begin {* Remove from current daybook *}

          Blank(BatchLink,Sizeof(BatchLink));

          RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOn);

          B_Func:=B_GetGEq;

          {$IFDEF CU}
            If (Assigned(PACustomEvent)) then
            With PACustomEvent do
            Begin
              TInvoice(EntSysObj.Transaction).ResetTrans(Inv);

              Execute;
            end;
          {$ENDIF}

        end;

        Application.ProcessMessages;

        {* Adjust Order O/s Value *}

        TotOrdOS:=TotOrdOS-Round_Up(NewOSVal,2);

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP);

        Report_BError(Fnum,Status);

        If (StatusOk) then
          TmpStat:=UnLockMultiSing(F[Fnum],Fnum,LAddr);


        Calc_StockDeduct(Inv.FolioNum,BOff,0,Inv,BOff); {* Re-calculate BOM situation *}

        If (Mode=3) then {* Deduct order value from history as its become an invoice *}
        Begin
          UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

          UpdateOrdBal(Inv,(Round_Up(Conv_TCurr(NewOSVal,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                       DocCnst[InvDocHed]*DocNotCnst),
                       0,0,
                       BOn,0);
        end
        else
        Begin {* Take off the value of any writeoffs as these will never be taken into account otherwise *}
          UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

          UpdateOrdBal(Inv,(Round_Up(Conv_TCurr(NewWOVal,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                       DocCnst[InvDocHed]*DocNotCnst),
                       0,0,
                       BOn,0);


        end;


      end; {If Locked..}

    end; {If Repos ok}

  end; {If Pos stored ok}

  Dispose(TmpInv);

  Dispose(TmpId);

  Dispose(WOId);

end; {Proc..}




{ ========== Proc to generate a ?IN from a ?DN =========

SOP_ConvertDel
Assumes the Global Inv Structure contains the Tranaction to be processed.

  ConsA : True Indicates if we will be consolidating matching account code/currency Delivery Notes into conslidated Invoices.
  Mutually exclusive with SingDoc as instead of creating a one to one Invoice for each Delviery Note a search will be made
  for any matching ones which could be appended.  At the end of the entire process SOP_RevealRun must be run to reveal
  the transactions which created as part of this process by setting their RunNos correctly.

  SingDoc : True Indicates that we will be generating a single Invoice for this Delivery Note. Mutually exclusive with ConsA.

  B_Func :   If this routine is being used as part of a loop which processes Delivery Notes, returns the next appropriate Btrieve
  operation since the Delivery Note will have been destrpyed as a result of the Invoice, and hence a GetNext will
  no longer work.

  SOPRNo  :  Pass in next sequential RunNo which is used to build BatchLink so that we can reprint by runno later on.
             Really only applies when processing a batch or when Consolidating.

  Fnum    :  InvF;
  Keypath :  InvRNoK
  KeyRes  :  The InvF Keypath in operation prior to calling SOP_ConvertDel so its position can be restored afterwards.


Generation modes:-


  2  :  Delivery notes to Invoices
  99 :  Special insertion of desc line on consolidated invoices

}



Procedure TSOPRunFrm.SOP_ConvertDel(ConsA,
                                    SingDoc:  Boolean;
                                Var B_Func :  Integer;
                                    SOPRNo :  LongInt;
                                    Fnum,
                                    Keypath,
                                    KeyResP:  Integer;
                                    Mode   :  Byte);




Var
  Fnum2,
  Keypath2,
  TmpStat,
  B_Func2  :  Integer;

  KeyS,
  KeyChk   :  Str255;

  LAddr,
  DocRecAddr,
  LineRecAddr,
  HedAddr,
  LastSOPLink
           :  LongInt;


  TmpInv   :  ^InvRec;
  TmpId    :  ^Idetail;

  GotHed,
  StillOS,
  Locked,
  AddDesc  :  Boolean;

  MatchVal :  Real;

  ExLocal  :  TdExLocal;


Begin

  New(TmpInv);
  New(TmpId);

  TmpInv^:=Inv;
  TmpId^:=Id;

  GotHed:=BOff;
  StillOS:=BOff;
  Locked:=BOff;

  MatchVal:=0;

  HedAddr:=0;

  AddDesc:=BOff;

  LastSOPLink:=0;

  B_Func:=B_GetNext;

  Fnum2:=IDetailF; Keypath2:=IdFolioK;

  DocRecAddr:=0;

  B_Func2:=B_GetNext;

  Status:=GetPos(F[Fnum],Fnum,DocRecAddr);  {* Preserve DocPosn *}

  Begin

    {v5.01, reverse effect of BOM straight away so that stock is correctly positioned }
    KeyS:=FullIdkey(TmpInv^.FolioNum,StkLineNo);  {* Remove any existing lines *}

    Delete_StockLinks(KeyS,IdetailF,Length(KeyS),IdFolioK,BOn,Inv,0);

    KeyChk:=FullNomKey(Inv.FolioNum);

    KeyS:=FullIdKey(Inv.FolioNum,1);

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Id do
    Begin

      Application.ProcessMessages;

      TmpId^:=Id;

      If (Not GotHed) and (SOP_CheckPickQty(TmpId^,Mode)) then
      Begin

        GotHed:=Get_InvHed(TmpInv^,ConsA,SOPRNo,Fnum,Keypath,Mode,HedAddr, CopyTagNo);

        {* If Consoldated, set a flag so a descriptive line is added before each order *}

        AddDesc:=BOn;  {* Used to only add description if a consolidated invoice, instead
                         always show delivery note number on first line *}

      end;

      If (GotHed) or (Not SOP_CheckPickQty(TmpId^,Mode)) then
      Begin

        Label2.Caption:='Generating '+Inv.OurRef;

        Ok:=GetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);

        If (Ok) and (Locked) then
        Begin

          {* Delete Delivery Line *}
          {v5.52? When converting a PDN to a PIN, there is no effecive stock movement, but as this routine was,
                 it deleted the PDN line reversed out the stock effect, and then recreated it all altering
                 the FIFO order and the ledger order. As of v5.52? PDN conversions do not affect stock, and they
                 upate the original line rather then replce it so their pos in the ledger remains the same so
                 that check does not distort it either }

          If (Is_FullStkCode(Id.StockCode))   and (TmpId^.IdDocHed<>PDN) then
            Stock_Deduct(TmpId^,Inv,BOff,BOn,0);


          {$IFDEF PF_On} {* Delete any Job Actuals *}

            If (Not EmptyKey(Id.JobCode,JobCodeLen)) then
              Delete_JobAct(Id);

          {$ENDIF}


          If (Id.IdDocHed<>PDN) or (Id.Qty = 0) then
            Status:=Delete_Rec(F[Fnum2],Fnum2,KeyPath2)
          else
          Begin
            Status:=GetPos(F[Fnum2],Fnum2,LineRecAddr);  {* Preserve DocPosn *}

          end;

          Report_BError(Fnum2,Status);

          If ((StatusOk) and (SOP_CheckPickQty(TmpId^,Mode))) then {* Also check for flag and set line *}
          Begin

            If ((Not AddDesc) and (ConsA)) then {* Check for consolidated Delivery! *}
              AddDesc:=((LastSOPLink<>0) and (TmpId^.SOPLink<>0) and (TmpId^.SOPLink<>LastSOPLink));

            If (AddDesc) then
            Begin

              Ok:=Gen_InvLine(TmpId^,TmpInv^,Fnum2,Keypath2,(Mode+10),ConsA,MatchVal);

              LastSOPLink:=TmpId^.SOPLink;

            end;

            AddDesc:=BOff;

            If (LineRecAddr<>0) then
            Begin
              SetDataRecOfs(Fnum2,LineRecAddr);

              If (LineRecAddr<>0) then
                Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);
            end;

            Ok:=Gen_InvLine(TmpId^,TmpInv^,Fnum2,Keypath2,Mode,ConsA,MatchVal);

            If (LineRecAddr<>0) then
              TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,LineRecAddr);

            If (Is_FullStkCode(TmpId^.StockCode)) then {Renumber FIFO entries with PIN entry}
            Begin
              If (Global_GetMainRec(StockF,TmpId^.StockCode)) then
                FIFO_RenPDN(Stock,TmpId^,Id,MiscF,MiscNdxK);

            end;



            If (Is_FullStkCode(TmpId^.StockCode)) and (TmpId^.QtyPick<>0.0) then
              TxfrSNos(TmpInv^,Inv,TmpId^,Id,BOn);

            {* Attempt to tidy up any possibel negative FIFO *}

            FIFO_Tidy(Id.StockCode,Id.MLocStk);

            Status:=0; {Delete OK, carry on}
          end;

          If (StatusOk) then
            B_Func2:=B_GetGEq
          else
            B_Func2:=B_GetNext;

        end; {If Line Locked..}

      end {If Header generated ok..}
      else
        B_Func2:=B_GetNext;

      Status:=Find_Rec(B_Func2,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    end; {While..}

    If (GotHed) then  {* Store new Header *}
    Begin

      {$IFDEF SOPDLL}
       ToDoc := Inv.OurRef;
      {$ENDIF}

      If (SingDoc) then
      Begin

        Reveal_SOPDoc(Inv,Mode);

        ExLocal.Create;

        CalcInvTotals(Inv,ExLocal,(Not Inv.MANVAT),BOn);

        ExLocal.Destroy;

        Calc_StockDeduct(Inv.FolioNum,BOff,0,Inv,BOff); {* Re-calculate BOM situation *}

        Set_DocAlcStat(Inv);  {* Set Allocation Status *}


      end;


      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      TmpStat:=UnLockMultiSing(F[Fnum],Fnum,HedAddr);

      {* Update Accont Balance *}

      If (StatusOk) and (Not (Inv.InvDocHed In QuotesSet+PSOPSet)) then
      With Inv do
      Begin
        If (Not Syss.UpBalOnPost) and (SingDoc) then
          UpdateBal(Inv,(ConvCurrITotal(Inv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                 (ConvCurrICost(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                 (ConvCurrINet(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                 BOff,2);

        {* Deduct order value *}

        With TmpInv^ do
        If (SingDoc) then
          UpdateOrdBal(TmpInv^,ConvCurrINet(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst,
                       0,0,BOn,0)
        else
           UpdateOrdBal(TmpInv^,ConvCurrINet(TmpInv^,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst,
                       0,0,BOn,1);

        {With TmpInv^ do
          UpdateOrdBal(TmpInv^,(Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,BOff),2)*
                       DocCnst[InvDocHed]*DocNotCnst),
                       0,0,
                       BOn,0);}
      end;

      Application.ProcessMessages;


      {* modify existing matching record here with match val *}

      {$IFDEF CL_On}

        With Inv do
        Begin
          ReNumb_MatchPay(TmpInv^.OurRef,OurRef,DocMatchTyp[BOn]);

          ChangeNoteFolio(NoteDCode,FullNCode(FullNomKey(TmpInv^.FolioNum)),FullNCode(FullNomKey(FolioNum)));
        end;

      {$ENDIF}

    end
    else
    Begin {* We are not generating an invoice, as the delivery is full of blank lines
             so remove the match record *}

      {$IFDEF CL_On}

        With Inv do
          Remove_MatchPay(TmpInv^.OurRef,DocMatchTyp[BOn],MatchSCode, BOff);


      {$ENDIF}

    end;


    SetDataRecOfs(Fnum,DocRecAddr);

    If (DocRecAddr<>0) then
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP,0);

    With Inv do
    Begin

      Locked:=BOff;

      Ok:=GetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyResP,Fnum,BOn,Locked);

      If (Ok) and (Locked) then
      Begin

        Status:=Delete_Rec(F[Fnum],Fnum,KeyResP);

        Report_BError(Fnum,Status);

        If (StatusOk) then
          B_Func:=B_GetGEq;

        {* Delete any notes as well *}

        {$IFDEF CL_On}

          Delete_Notes(NoteDCode,FullNCode(FullNomKey(FolioNum)));

        {$ENDIF}

      end; {If Locked..}

    end; {If Repos ok}

  end; {If Pos stored ok}

  Dispose(TmpInv);

  Dispose(TmpId);

end; {Proc..}


{ ====== Proc to Total & workout BOM for a run of Documents ====== }

Procedure TSOPRunFrm.SOP_RevealRun(MatchK  :  Str255;
                                   MLen,
                                   Mode    :  Byte;
                                   Fnum,
                                   Keypath :  Integer);



Var
  KeyS,
  KeyChk  :  Str255;

  TmpStat,
  B_Func  :  Integer;

  LAddr   :  LongInt;

  Locked  :  Boolean;

  ExLocal  :  TdExLocal;

Begin

  Locked:=BOff;

  KeyChk:=MatchK;

  KeyS:=KeyChk;

  If (MLen=0) then
    MLen:=Length(MatchK);


  If (Mode>9) then
  Begin
    Mode:=Mode-10;

    B_Func:=B_GetGEq;

  end
  else
    B_Func:=B_GetNext;



  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,MLen,BOn)) do
  With Inv do
  Begin
    Locked:=BOff;

    Application.ProcessMessages;

    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOff,Locked,LAddr);

    If (Ok) and (Locked) then
    Begin


      Calc_StockDeduct(Inv.FolioNum,BOff,0,Inv,BOff); {* Re-calculate BOM situation *}

      Reveal_SOPDoc(Inv,Mode);

      ExLocal.Create;

      CalcInvTotals(Inv,ExLocal,((Not Inv.MANVAT) or (Mode=1)),BOn);  {* Force VAT calc on ?OR-?DN as otherwise part deliveries would be wrong *}

      ExLocal.Destroy;

      Set_DocAlcStat(Inv);  {* Set Allocation Status *}

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      If (StatusOk) then
        TmpStat:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

      {* Update Accont Balance *}

      If (StatusOk) and (Not (Inv.InvDocHed In QuotesSet+PSOPSet)) then
        With Inv do
        Begin
          If (Not Syss.UpBalOnPost) then
            UpdateBal(Inv,(ConvCurrITotal(Inv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrICost(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrINet(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   BOff,2);

          {* Take invoice amount off committed amount this is done from inside SOP_ConvertDel on an individual basis*}
          {If (Mode<>3) then
            UpdateOrdBal(Inv,ConvCurrINet(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst,
                         0,0,BOn,1);}
        end;
    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

end; {Proc..}



{ ==== Procedure to Override Consolidated mode based on account ==== }

Function TSOPRunFrm.OverrideCons(ConsA  :  Boolean;
                                 CCode  :  Str10;
                                 DelMode:  Byte)  :  Boolean;

Var
  LOk  :  Boolean;

Begin

  Result:=ConsA;

  If (CCode<>Cust.CustCode) then
    LOk:=Global_GetMainRec(CustF,CCode)
  else
    LOK:=BOn;

  If (LOK) then
  With Cust do
  Begin
    Case DelMode of

      1  :  Begin
              Case OrdConsMode of
                0,2,5  :  Result:=ConsA;
                1,3,7  :  Result:=BOn;
                4,6,8  :  Result:=BOff;
                else      Result:=ConsA;
              end; {Case..}
            end;
      2,3
         :  Begin        
              Case OrdConsMode of
                0,1,4  :  Result:=ConsA;
                2,3,8  :  Result:=BOn;
                5,6,7  :  Result:=BOff;
                else      Result:=ConsA;
              end; {Case..}
            end;
    end; {Case..}
  end; {If Ok..}

end; {Func..}




{ ====== Proc to Auto Generate Delivery / Invoices ====== }


Procedure TSOPRunFrm.SOP_RunDel(MatchK    :  Str255;
                                MatchLen  :  Byte;
                            Var SOPRunNo  :  LongInt;
                                FindTag   :  Byte;
                                ConsA     :  Boolean;
                                Fnum,
                                Keypath   :  Integer;
                            Var GotOrd    :  Boolean;
                                SOPLoc    :  Str5;
                                Mode      :  Byte);




Const
  Fnum2      =  IdetailF;
  Keypath2   =  IdFolioK;



Var
  KeyS,
  KeyChk,
  KeySI,
  KeyChkI :  Str255;


  B_Func  :  Integer;

  LAddr   :  LongInt;

  AddHook,
  RunHook,
  RunCons,
  FoundOk,
  LOK,
  StillOS :  Boolean;

  MatchDocHed
          :  DocTypes;

  ExLocal :  TdExLocal;

  {$IFDEF Cu}

    CustomEvent  :  TCustomEvent;

  {$ENDIF}




Begin
  AddHook:=BOff; RunHook:=BOff;

  {$IFDEF Cu}
    CustomEvent:=TCustomEvent.Create(EnterpriseBase+2000,3);


  {$ENDIF}

  Try

   {$IFDEF Cu}
      ExLocal.Create;

      With CustomEvent do
        If (GotEvent) then
        Begin
          BuildEvent(ExLocal);
          RunHook:=BOn;
        end
        else
          AddHook:=BOn;

   {$ENDIF}


    GotOrd:=BOff; LOk:=BOff;

    StillOS:=BOff;
    KeyChk:=MatchK;
    KeyS:=KeyChk;

    RunCons:=ConsA;

    MatchDocHed:=SDN;

    If (MatchLen=0) then
      MatchLen:=Length(MatchK);

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,MatchLen,BOn)) and (KeepRun) do
    With Inv do
    Begin

      {Label2.Caption:='Checking '+Inv.OurRef;}

      Application.ProcessMessages;

      FoundOk:=((Mode=2) and ((EmptyKey(SOPLoc,LocKeyLen)) or (Not Syss.UseMLoc)));


      StillOS:=BOff;


      B_Func:=B_GetNext;

      LAddr:=0;

      {* Locked here to stop anyone being inside a doc as it is processed *}

      LOK:=(Try_Lock(B_GetDirect,B_SingNWLock+B_MultLock,KeyS,Keypath,Fnum,RecPtr[Fnum])=0);

      If (LOk) then
      Begin
        GetPos(F[Fnum],Fnum,LAddr);

        {$IFDEF CU}
          If (RunHook) then
          With CustomEvent do
          Begin
            TInvoice(EntSysObj.Transaction).ResetTrans(Inv);

            Execute;

            AddHook:=EntSysObj.BoResult;
          end;

       {$ELSE}
         AddHook:=BOn;
       {$ENDIF}


        If (((Tagged=FindTag) or (FindTag=0))
           and ((Not OnHold(HoldFlg)) or (((HoldFlg AND HOLDO)=HoldO) or ((HoldFlg AND HoldS)=HoldS)))
           and ((InvDocHed In DeliverSet) or (Mode<>2))
           and (AddHook)) then

        Begin

          KeyChkI:=FullNomKey(FolioNum);

          KeySI:=FullIdKey(FolioNum,1);

          Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

          While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (Not FoundOk) and (KeepRun) do
          With Id do
          Begin

            Case Mode of

              1,3
                 :  Begin
                      FoundOk:=((Round_Up(QtyPick+QtyPWOff,Syss.NoQtyDec)<>0) and (CheckKey(SOPLoc,MLocStk,Length(SOPLoc),BOff)));

                      StillOS:=(StillOS or (Qty_OS(Id)<>0));
                    end;

              2  :  FoundOk:=CheckKey(SOPLoc,MLocStk,Length(SOPLoc),BOff);

            end; {Case..}

            If (Not FoundOk) then
              Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

          end; {While..}

          If (FoundOk) then
          Begin

            MatchDocHed:=Set_MatchLinkDoc(Inv.InvDocHed,Mode);

            If (Not GotOrd) then
              {SOPRunNo:=GetNextCount(SDG,BOn,BOff,0);}
              SOPRunNo:=SetNextSOPRunNo(MatchDocHed,BOn,0);


            GotOrd:=BOn;



            RunCons:=OverrideCons(ConsA,CustCode,Mode);

            Case Mode of
              1,3
                 :  Begin
                      SOP_ProcessDel(RunCons,
                                     BOff,
                                     B_Func,
                                     SOPRunNo,
                                     SOPLoc,
                                     InvF,
                                     InvRNoK,
                                     Keypath,
                                     Mode);



                    end;




              2  :  Begin
                      SOP_ConvertDel(RunCons,
                                     BOff,
                                     B_Func,
                                     SOPRunNo,
                                     InvF,
                                     InvRNoK,
                                     KeyPath,
                                     Mode);

                    end;

            end; {Case..}

          end
          else
            If (Mode In [1,3]) and (Not StillOS) then {* It shouldn't be here as its fully delivered *}
            Begin {* Remove from current daybook *}

              Blank(BatchLink,Sizeof(BatchLink));

              RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOn);

              B_Func:=B_GetGEq;

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

              Report_BError(Fnum,Status);

              {$IFDEF CU}{*EN440PAHK*}
                If (Assigned(PACustomEvent)) then
                With PACustomEvent do
                Begin
                  TInvoice(EntSysObj.Transaction).Assign(2000,79,Inv,ExLocal.LId);

                  Execute;
                end;
              {$ENDIF}


              Calc_StockDeduct(Inv.FolioNum,BOff,0,Inv,BOff); {* Re-calculate BOM situation *}

            end;

        end; {If Order valid}

        If (LAddr<>0) then
          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

       end; {If doc locked}

      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    If (GotOrd) then
    Begin

      {* Reset them, and recalc them *}

      SOP_RevealRun(SOP_RunNo(SOPRunNo,MatchDocHed),0,Mode,InvF,InvBatchK);

      {* Fix any strays from a previous run *}

      If (Mode In [2,3]) then
      Begin
        If (MatchDocHed In SalesSplit) then
          MatchDocHed:=SOR
        else
          MatchDocHed:=POR;
      end;

      SOP_RevealRun(FullDayBkKey(Pred(Set_OrdRunNo(MatchDocHed,BOff,BOn)),FirstAddrD,DocCodes[MatchDocHed]),
                    Succ(Sizeof(SOpRunNo)),(Mode+10),InvF,InvRNoK);


    end;
  finally
    {$IFDEF CU}
      CustomEvent.Free;
      ExLocal.Destroy;
    {$ENDIF}
  end;


end; {Proc..}


{$IFDEF WOP}

  { ============= WOP Processing Routines, WOR->ADJ (Issue/Final) ==========

  Generation modes:-


    80  : WOR -> Issue ADJ
    81  : WOR -> Final Build ADJ

  }






  Procedure TSOPRunFrm.WOP_ProcessWOR(ConsA,
                                      SingDoc:  Boolean;
                                  Var B_Func :  Integer;
                                      SOPRNo :  LongInt;
                                      SOPMLoc,
                                      AdjNo  :  Str10;
                                      Fnum,
                                      Keypath,
                                      KeyResP:  Integer;
                                      Mode   :  Byte);




  Var
    UOR      :  Byte;
    TmpStat,
    Fnum2,
    Keypath2 :  Integer;

    KeyS,
    KeyChk   :  Str255;

    LAddr,
    DocRecAddr,
    HedAddr,
    IdRecAddr:  LongInt;


    TmpInv   :  ^InvRec;
    TmpId,
    UpdId,
    BOMId    :  ^Idetail;

    LOk,
    GotHed,
    StillOS,
    StillBOMOS,
    Locked   :  Boolean;

    MatchVal :  Real;

    NewAvgCost,
    OldOSVal,
    OldLCost,
    NewLCost,
    ThisBuild,
    QtyIssSoFar,
    CouldBuild,
    ThisWIP,
    NewOSVal :  Double;


  procedure Synch_BOMCost(SYMode  :  Byte);


  Var
    KeyS,
    KeyChk   :   Str255;

    TmpStat  :   Integer;


  Begin
    With Inv do
    Begin
      KeyS:=FullIdKey(FolioNum,1);

      TmpStat:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

      If (TmpStat=0) then
      Begin
        BOMId^:=Id;

        Case SYMode of
          0  :  With Id do
                Begin
                  Costprice:=Round_Up(DivWChk(TotalCost,WORReqQty(Id)),Syss.NoCosDec);

                  If (CouldBuild<>-1.0) then
                  Begin {* We can only build as many as we need, otherwise a rogue line 2 with more quantity will wreck the others}
                    If (CouldBuild<=WORReqQty(Id)) then 
                      SSDUplift:=CouldBuild
                    else
                      SSDUplift:=WORReqQty(Id);
                  end;

                  TmpStat:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPAth2);

                  Report_BError(Fnum2,TmpStat);
                end;

          1  :  With BOMId^ do
                Begin

                  QtyDel:=QtyDel+QtyPick;
                  QtyWOff:=QtyDel;

                  QtyPick:=0.0;

                  StillBOMOS:=(BuildQty_OS(BOMId^)>0.0);

                end;
        end; {Case..}
      end;

    end;

  end;


  Begin

    New(TmpInv);
    New(TmpId);
    New(UpdId);
    New(BOMId);

    TmpInv^:=Inv;
    TmpId^:=Id;
    UpdId^:=Id;
    BOMId^:=Id;

    GotHed:=BOff;

    StillOS:=BOff; {Will always be o/s in issue mode}
    StillBOMOS:=BOn;

    Locked:=BOff;

    MatchVal:=0;

    NewOSVal:=0;
    OldOSVal:=0;
    OldLCost:=0.0; NewLCost:=0.0;  CouldBuild:=-1.0;  ThisBuild:=0.0; QtyIssSoFar:=0.0; ThisWIP:=0.0;

    NewAvgCost:=0;

    B_Func:=B_GetNext;

    Fnum2:=IDetailF; Keypath2:=IdFolioK;

    DocRecAddr:=0; IdRecAddr:=0;

    Status:=GetPos(F[Fnum],Fnum,DocRecAddr);  {* Preserve DocPosn *}

    LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyResP,Fnum,Not SingDoc,Locked,LAddr);

    If (LOk) and (Locked) then
    Begin
      If (IS_StdWOP) then {Find out status of control line}
        Synch_BOMCost(1);

      KeyChk:=FullNomKey(Inv.FolioNum);

      KeyS:=FullIdKey(Inv.FolioNum,2);

      Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With Id do
      Begin

        Application.ProcessMessages;

        Status:=GetPos(F[Fnum2],Fnum2,IdRecAddr);  {* Preserve Line Posn *}

        TmpId^:=Id;

        If (Not GotHed) and (SOP_CheckPickQty(TmpId^,Mode)) then
        Begin

          GotHed:=Get_AdjHed(ConsA,AdjNo,TmpInv^,SOPRNo,Fnum,Keypath,Mode,HedAddr);
        end;

        If (GotHed) and (TmpId^.QtyPick<>0.0) then
        Begin

          Label2.Caption:='Generating '+Inv.OurRef;

          LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,LAddr);

          If (LOk) and (Locked) then
          Begin
            Application.ProcessMessages;

            {* Update Order Line *}

            If (Is_FullStkCode(StockCode)) then
              Stock_Deduct(Id,Inv,BOff,BOn,0);

            OldOSVal:=Round_Up(QtyDel*CostPrice,2);

            OldLCost:=Round_Up(WORReqQty(Id)*CostPrice,2);

            If (SOP_CheckLoc(Id,SOPMLoc,Mode)) then
            Begin
              If ((KitLink=0) or (Is_FullStkCode(StockCode))) then {* Ignore Description only lines *}
              Begin
                QtyDel:=QtyDel+QtyPick;

                If (Is_StdWOP) then {Set built at the same time as issued, since it is one operation here}
                Begin
                  If (Qty_OS(Id)<>0.0) and (Not StillBOMOS) then {Force amount issued equal original amount required inc unders/overs}
                    QtyDel:=QtyDel+(Qty_OS(Id));


                  QtyWOff:=QtyDel;

                end;
              end;

              QtyPick:=0;
            end;


            If (Is_FullStkCode(StockCode)) then
              Stock_Deduct(Id,Inv,BOn,BOn,0);

            If (Is_StdWOP) and (Qty_OS(Id)=0) then  {* ResetLine *}
              Id.LineType:=StkLineType[WIN]
            else
              Id.LineType:=StkLineType[WOR];


            UpdId^:=Id;

            Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

            Report_BError(Fnum2,Status);

            If (StatusOk) then
              TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);


            If (StatusOk) and (SOP_CheckPickQty(TmpId^,Mode)) and
             (SOP_CheckLoc(Id,SOPMLoc,Mode)) then
            Begin

              Ok:=Gen_InvLine(TmpId^,TmpInv^,Fnum2,Keypath2,Mode,BOff,MatchVal);

              With Inv do {Calculate ADJ total cost}
                TotalCost:=TotalCost+InvLCost(Id);

              If (TmpId^.QtyPick<>0.0) then
              Begin
                If (Is_FullStkCode(TmpId^.StockCode)) then
                  TxfrSNos(TmpInv^,Inv,TmpId^,Id,BOff);
              end;

              {= Adjust back actual cost price generated by adj line =}

              If (Id.CostPrice<>TmpId^.Costprice) then
              Begin
                NewAvgCost:=Round_Up(DivWChk((TmpId^.CostPrice*TmpId^.QtyDel)+(Id.CostPrice*TmpId^.QtyPick),TmpId^.QtyPick+TmpId^.QtyDel),Syss.NoCosDec);

                SetDataRecOfs(Fnum2,IdRecAddr);

                Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);

                If (StatusOk) then
                Begin
                  Id.CostPrice:=NewAvgCost;

                  UpdId^:=Id;

                  Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

                  Report_BError(Fnum2,Status);


                end;

              end;

              {* Amount to be put on issued value *}

              With UpdId^ do
              Begin
                NewOSVal:=NewOSVal+(Round_Up(QtyDel*CostPrice,2)-OldOSVal);

                NewLCost:=NewLCost+Round_Up(WORReqQty(UpdId^)*CostPrice,2)-OldLCost;
              end;


            end;

          end; {If Line Locked..}

        end {If Header generated ok..}
        else
          StillOS:=BOn;

        SetDataRecOfs(Fnum2,IdRecAddr);

        If (IdRecAddr<>0) then
          Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);

        With Id do {Work out how many we could build, based on issued so far, less built so far}
        Begin
          QtyIssSoFar:=QtyDel;

          If (QtyPWOff<0) then {If we reduce the amount required then we need to add it back in otherwise we will understate how much has been issued.}
            QtyIssSoFar:=QtyIssSoFar+ABS(QtyPWOff)
          else
            If (QtyPWOff>0) then {If we increase the amount required then we need to remove it otherwise we will overstate how much could be built.}
              QtyIssSoFar:=QtyIssSoFar-QtyPWOff;


          ThisBuild:=Round_Up(DivWChk(QtyIssSoFar,QtyMul),Syss.NoQtyDec);

          If ((ThisBuild<CouldBuild) and (Qty_OS(Id)<>0.0)) or (CouldBuild=-1.0) then
            CouldBuild:=ThisBuild;
        end;

        Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

      end; {While..}

      If (GotHed) then  {* Store new Header *}
      Begin

        Application.ProcessMessages;


        If (Is_StdWOP) then {* We need to add the balancing line building the BOM *}
        Begin
          With TmpInv^ do
            KeyS:=FullIdKey(FolioNum,1);

          Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);


          If (StatusOK) then
          With Id do
          Begin
            UpdId^:=Id;

            Stock_Deduct(Id,TmpInv^,BOff,BOn,0);


            QtyDel:=QtyDel+QtyPick;

            QtyWOff:=QtyDel;

            QtyPick:=0.0;

            StillBOMOS:=(BuildQty_OS(Id)>0.0);

            Stock_Deduct(Id,TmpInv^,BOn,BOn,0);

            {* Work out any differences between value issued and transferred from WIP so far}
              With TmpInv^ do
                UpdId^.CostPrice:=Round_Up(DivWChk((TotalInvoiced+Round_Up(NewOSVal,2))-TotalReserved,UpdId^.QtyPick),Syss.NoCosDec);

            If (Not StillBOMOS) then
            Begin
              Id.LineType:=StkLineType[WIN];


              {* Set final individual cost to equal part of total cost *}
              Id.CostPrice:=Round_Up(DivWChk((TmpInv^.TotalInvoiced+Round_Up(NewOSVal,2)),WORReqQty(Id)),Syss.NoCosDec);

            end
            else
            Begin
              Id.LineType:=StkLineType[WOR];

              Id.CostPrice:=UpdId^.CostPrice;
            end;

            Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

            Report_BError(Fnum2,Status);


            Ok:=Gen_InvLine(UpdId^,TmpInv^,Fnum2,Keypath2,81,BOff,MatchVal);

            If (OK) then {It should balance out}
            Begin
              Inv.TotalCost:=Inv.TotalCost+InvLCost(Id);;

              If (StillBOMOS) then
                ThisWIP:=InvLCost(Id);

              {== Go and pick its parent line if set == }

              With UpdId^ do
              If (SOPLink<>0) and (SOPLineno<>0) then {Only update cost if not auto set}
              Begin
                PickSORvPOR(TmpInv^,UpdId^,Fnum,Keypath,Fnum2,KeyPath2,Ord(Not TmpInv^.PORPickSOR));
              end;

              TxfrSNos(TmpInv^,Inv,UpdId^,Id,BOff);
            end;
          end;


        end;


        If (SingDoc) then
        Begin

          Reveal_SOPDoc(Inv,Mode);


        end;

        {$IFDEF CL_On}
          Add_Notes(NoteDCode,NoteCDCode,FullNomKey(Inv.FolioNum),Today,
                    Inv.OurRef+' was created from '+TmpInv^.OurRef+' / '+TmpInv^.YourRef+' '+TmpInv^.TransDesc,
                    Inv.NLineCount);

          {*Copy notes from each WOR into each ADJ*}

          CopyNoteFolio(NoteDCode,NoteDCode,FullNCode(FullNomKey(TmpInv^.FolioNum)),FullNCode(FullNomKey(Inv.FolioNum)),Inv.NLineCount);

          Inv.NLineCount:=Inv.NLineCount+TmpInv^.NLineCount;

        {$ENDIF}

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        TmpStat:=UnLockMultiSing(F[Fnum],Fnum,HedAddr);

        {* Add matching record here with match val *}

        Application.ProcessMessages;

        {$IFDEF CL_On}

          With Inv do
          Begin
            MatchVal:=TotalCost;

            RemitNo:=TmpInv^.OurRef;

            UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

            Match_Payment(Inv,Round_Up(Conv_TCurr(MatchVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                          ,MatchVal,20);

            
          end;

        {$ENDIF}

      end;

      SetDataRecOfs(Fnum,DocRecAddr);

      With Inv do
      Begin

        If (DocRecAddr<>0) then
          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP,0)
        else
          Status:=4;

        If (StatusOk) then
        Begin

            If (Not StillBOMOS) and (Is_StdWOP) then
            Begin {* Remove from current daybook *}

              Blank(BatchLink,Sizeof(BatchLink));

              RunNo:=Set_WOrdRunNo(InvDocHed,BOff,BOn);

              B_Func:=B_GetGEq;

            end
            else
              B_Func:=B_GetNext;


          Application.ProcessMessages;

          {* Adjust Order O/s Value *}

          TotalInvoiced:=TotalInvoiced+Round_Up(NewOSVal,2);

          TotalCost:=TotalCost+Round_Up(NewLCost,2);

          If (Is_StdWOP) then
          Begin
            TotalReserved:=TotalReserved+ThisWIP;

            If (Not StillBOMOS) then
            Begin
              TotalCost:=TotalInvoiced;
              TotalReserved:=TotalCost;
            end;
          end;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP);

          Report_BError(Fnum,Status);

          {* Adjust line one value *}

          If (Not Is_StdWOP) then
            Synch_BOMCost(0);


        end; {If Locked..}

      end; {If Repos ok}

      TmpStat:=UnLockMultiSing(F[Fnum],Fnum,DocRecAddr);

    end; {If Pos stored ok}

    Dispose(TmpInv);

    Dispose(TmpId);
    Dispose(UpdId);
    Dispose(BOMId);


  end; {Proc..}


  { == Proc to finalise the building of a WOR == }

  Procedure TSOPRunFrm.WOP_BuildWOR(SingDoc:  Boolean;
                                    SOPRNo :  LongInt;
                                    SOPMLoc:  Str10;
                                Var B_Func :  Integer;
                                    Fnum,
                                    Keypath,
                                    KeyResP:  Integer;
                                    Mode   :  Byte);




  Var
    UOR      :  Byte;
    TmpStat,
    Fnum2,
    Keypath2 :  Integer;

    KeyS,
    KeyChk   :  Str255;

    LAddr,
    DocRecAddr,
    HedAddr,
    IdRecAddr:  LongInt;


    TmpInv   :  ^InvRec;
    TmpId,
    PickId,
    UpdId    :  ^Idetail;

    LOk,
    GotHed,
    StillOS,
    Locked   :  Boolean;

    MatchVal :  Real;

    OldLCost,
    NewLCost,
    ThisWIP  :  Double;


  procedure Synch_BOMCost;


  Var
    KeyS,
    KeyChk   :   Str255;

    TmpStat  :   Integer;


  Begin
    With Inv do
    Begin
      KeyS:=FullIdKey(FolioNum,1);

      TmpStat:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

      If (TmpStat=0) then
      With Id do
      Begin
        If (StillOS) then
          Costprice:=Round_Up(DivWChk(TotalCost,WORReqQty(Id)),Syss.NoCosDec)
        else
          Costprice:=Round_Up(DivWChk(TotalReserved,QtyWOff),Syss.NoCosDec); {Final spread}

        TmpStat:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPAth2);

        Report_BError(Fnum2,TmpStat);

      end;

    end;

  end;


  Begin

    New(TmpInv);
    New(TmpId);
    New(UpdId);
    New(PickId);


    TmpInv^:=Inv;
    TmpId^:=Id;
    UpdId^:=Id;
    PickId^:=Id;


    GotHed:=BOff;

    StillOS:=BOff; {Will always be o/s in issue mode}

    Locked:=BOff;

    MatchVal:=0;

    OldLCost:=0.0; NewLCost:=0.0;  ThisWIP:=0.0;

    Fnum2:=IDetailF; Keypath2:=IdFolioK;

    DocRecAddr:=0; IdRecAddr:=0; HedAddr:=0;

    Status:=GetPos(F[Fnum],Fnum,DocRecAddr);  {* Preserve DocPosn *}

    LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyResP,Fnum,Not SingDoc,Locked,LAddr);

    With TmpInv^ do
    If LOK and (Locked) then
    Begin
      KeyS:=FullIdKey(FolioNum,1);

      Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

      If (StatusOk) then
      With TmpId^ do
      Begin
        TmpId^:=Id;


        If (Stock.StockCode<>StockCode) then
          If (Not Global_GetMainRec(StockF,StockCode)) then
            ResetRec(StockF);

        If (Stock.StockType=StkBillCode) and (SOP_CheckPickQty(TmpId^,Mode)) then
        Begin
          GotHed:=Get_AdjHed(BOff,'',TmpInv^,SOPRNo,Fnum,Keypath,Mode,HedAddr);
        end;

      end;

    end;


    If LOK and (Locked) then
    Begin
      If (GotHed) or (BuildQty_OS(TmpId^)=0.0) then
      Begin

        If (GotHed) then
          Label2.Caption:='Generating '+Inv.OurRef;

        Application.ProcessMessages;

        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,LAddr);


        If (LOk) and (Locked) and (GotHed) then
        Begin
          Stock_Deduct(Id,TmpInv^,BOff,BOn,0);

          With Id do {Adjust build Line 1}
          Begin
            QtyWOff:=QtyWOff+QtyPick;

            QtyDel:=QtyWOff; {Set issued qty same as built, so that allocated to wor qty is reduced.}

            QtyPick:=0.0;
          end;

          StillOS:=(BuildQty_OS(Id)>0.0);

          If (Not StillOS) then  {* ResetLine *}
          Begin
            Id.LineType:=StkLineType[WIN];

            {Mop up any final differences between value issued and transferred from WIP so far in final allocation}
            With TmpInv^ do
              TmpId^.CostPrice:=Round_Up(DivWChk(TotalInvoiced-TotalReserved,TmpId^.QtyPick),Syss.NoCosDec);
          end;


          Stock_Deduct(Id,TmpInv^,BOn,BOn,0);

          Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

          Report_BError(Fnum2,Status);

          If (StatusOk) then
            TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);

          UpdId^:=Id;

          Ok:=Gen_InvLine(TmpId^,TmpInv^,Fnum2,Keypath2,Mode,BOff,MatchVal);


          With Inv do {Calculate ADJ total cost}
            TotalCost:=TotalCost+InvLCost(Id);

          ThisWIP:=InvLCost(Id);


          {== Go and pick its parent line if set == }

          With PickId^ do
            If (SOPLink<>0) and (SOPLineno<>0) then {Only update cost if not auto set}
            Begin
              PickSORvPOR(TmpInv^,PickId^,Fnum,Keypath,Fnum2,KeyPath2,Ord(Not TmpInv^.PORPickSOR));
            end;

          TxfrSNos(TmpInv^,Inv,TmpId^,Id,BOff);

          KeyChk:=FullNomKey(TmpInv^.FolioNum);

          KeyS:=FullIdKey(TmpInv^.FolioNum,2);

          Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

          While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
          With Id do
          Begin

            Application.ProcessMessages;

            Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,LAddr);

            If (Ok) and (Locked) then
            Begin
              Stock_Deduct(Id,TmpInv^,BOff,BOn,0);

              OldLCost:=Round_Up(WORReqQty(Id)*CostPrice,2);

              QtyWOff:=QtyWOff+Round_Up((QtyMul*TmpId^.QtyPick),Syss.NoQtyDec);

              If (Not StillOS) then {Back flush everything}
              Begin
                If (Qty_OS(Id)<>0.0) then {Force Overs/Unders to equal amount issued}
                  QtyPWOff:=QtyPWOff-(Qty_OS(Id));

                If (BuildQty_OS(Id)<>0.0) then {Set built to issued}
                  QtyWOff:=QtyDel;

                LineType:=StkLineType[WIN];

              end;

              NewLCost:=NewLCost+Round_Up(WORReqQty(Id)*CostPrice,2)-OldLCost;

              Stock_Deduct(Id,TmpInv^,BOn,BOn,0);

              Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

              Report_BError(Fnum2,Status);

              If (StatusOk) then
                TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);


            end;

            Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

          end; {While..}
        end; {If Locked OK..}


        If (GotHed) then  {* Store new Header *}
        Begin

          Application.ProcessMessages;


          If (SingDoc) then
            Reveal_SOPDoc(Inv,Mode);

          {$IFDEF CL_On}


            Add_Notes(NoteDCode,NoteCDCode,FullNomKey(Inv.FolioNum),Today,
                      Inv.OurRef+' was created from '+TmpInv^.OurRef+' / '+TmpInv^.YourRef+' '+TmpInv^.TransDesc,
                      Inv.NLineCount);

            {*Copy notes from each WOR into each ADJ*}

            CopyNoteFolio(NoteDCode,NoteDCode,FullNCode(FullNomKey(TmpInv^.FolioNum)),FullNCode(FullNomKey(Inv.FolioNum)),Inv.NLineCount);

            Inv.NLineCount:=Inv.NLineCount+TmpInv^.NLineCount;

          {$ENDIF}

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          TmpStat:=UnLockMultiSing(F[Fnum],Fnum,HedAddr);

          {* Add matching record here with match val *}

          Application.ProcessMessages;

          {$IFDEF CL_On}

            With Inv do
            Begin
              MatchVal:=TotalCost;

              RemitNo:=TmpInv^.OurRef;

              UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

              Match_Payment(Inv,Round_Up(Conv_TCurr(MatchVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                            ,MatchVal,20);


            end;

          {$ENDIF}

        end
        else {It is no longer o/s but check the lines are all complete as well}
          If (BuildQty_OS(TmpId^)=0.0) then
          Begin
            KeyChk:=FullNomKey(TmpInv^.FolioNum);

            KeyS:=FullIdKey(TmpInv^.FolioNum,2);

            Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

            While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not StillOS) do
            With Id do
            Begin
              StillOS:=((Qty_OS(Id)<>0.0) or (QtyPick<>0.0));

              Application.ProcessMessages;

              If (Not StillOS) then
                Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

            end; {While..}


          end;

        SetDataRecOfs(Fnum,DocRecAddr);


        With Inv do
        Begin

          If (DocRecAddr<>0) then
            Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP,0)
          else
            Status:=4;

          If (StatusOK) then
          Begin

            If (StillOS) then
            Begin

              B_Func:=B_GetNext;

            end
            else
            Begin {* Remove from current daybook *}

              Blank(BatchLink,Sizeof(BatchLink));

              RunNo:=Set_WOrdRunNo(InvDocHed,BOff,BOn);

              B_Func:=B_GetGEq;



            end;

            Application.ProcessMessages;

            {* Adjust Order O/s Value *}

            If (StillOS) then
            Begin
              TotalCost:=TotalCost+Round_Up(NewLCost,2);
              TotalReserved:=TotalReserved+ThisWIP;

            end
            else
            Begin
              TotalCost:=TotalInvoiced;
              TotalReserved:=TotalCost;
            end;


            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP);

            Report_BError(Fnum,Status);

            {* Adjust line one value *}



            Synch_BOMCost; {Update final cost}

          end; {If Locked..}

        end; {If Repos ok}
      end; {If Gothed}

      TmpStat:=UnLockMultiSing(F[Fnum],Fnum,DocRecAddr);

    end; {If Pos stored ok}

    Dispose(TmpInv);

    Dispose(TmpId);

    Dispose(UpdId);

  end; {Proc..}



  { ====== Proc to Process all the WIN's & WOR Builds ====== }

Procedure TSOPRunFrm.WOP_RevealRun(MatchK  :  Str255;
                                   MLen,
                                   Mode    :  Byte;
                                   Fnum,
                                   Keypath :  Integer);



Var
  KeyS,
  KeyChk  :  Str255;

  TmpStat,
  B_Func  :  Integer;

  LAddr   :  LongInt;

  Locked  :  Boolean;

  ExLocal  :  TdExLocal;

Begin

  Locked:=BOff;

  KeyChk:=MatchK;

  KeyS:=KeyChk;

  If (MLen=0) then
    MLen:=Length(MatchK);


  B_Func:=B_GetNext;



  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,MLen,BOn)) do
  With Inv do
  Begin
    Locked:=BOff;

    Application.ProcessMessages;

    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOff,Locked,LAddr);

    If (Ok) and (Locked) then
    Begin


      Reveal_SOPDoc(Inv,Mode);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      If (StatusOk) then
        TmpStat:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

end; {Proc..}






{ ====== Proc to Auto Generate WIN/WOR's ====== }


Procedure TSOPRunFrm.WOP_RunIssue(MatchK    :  Str255;
                                  MatchLen  :  Byte;
                              Var SOPRunNo  :  LongInt;
                                  FindTag   :  Byte;
                                  Fnum,
                                  Keypath   :  Integer;
                              Var GotOrd    :  Boolean;
                                  SOPLoc    :  Str5;
                                  Mode      :  Byte);




  Const
    Fnum2      =  IdetailF;
    Keypath2   =  IdFolioK;



  Var
    KeyS,
    KeyChk,
    KeySI,
    KeyChkI :  Str255;


    B_Func  :  Integer;

    AddHook,
    RunHook,
    FoundOk,
    StillOS :  Boolean;

    MatchDocHed
            :  DocTypes;

    ExLocal :  TdExLocal;

    {$IFDEF Cu}

      CustomEvent  :  TCustomEvent;

    {$ENDIF}




  Begin
    AddHook:=BOff; RunHook:=BOff;

    {$IFDEF Cu}
      CustomEvent:=TCustomEvent.Create(EnterpriseBase+2000,69);


    {$ENDIF}

    Try

     {$IFDEF Cu}
        ExLocal.Create;

        With CustomEvent do
          If (GotEvent) then
          Begin
            BuildEvent(ExLocal);
            RunHook:=BOn;
          end
          else
            AddHook:=BOn;

     {$ENDIF}


      GotOrd:=BOff;

      StillOS:=BOff;
      KeyChk:=MatchK;
      KeyS:=KeyChk;

      MatchDocHed:=ADJ;

      If (MatchLen=0) then
        MatchLen:=Length(MatchK);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,MatchLen,BOn)) and (KeepRun) do
      With Inv do
      Begin

        {Label2.Caption:='Checking '+Inv.OurRef;}

        Application.ProcessMessages;

        StillOS:=BOff;

        FoundOk:=BOff;

        B_Func:=B_GetNext;


        {$IFDEF CU}
           If (RunHook) then
           With CustomEvent do
           Begin
             TInvoice(EntSysObj.Transaction).ResetTrans(Inv);

             Execute;

             AddHook:=EntSysObj.BoResult;
           end;

        {$ELSE}
          AddHook:=BOn;
        {$ENDIF}


        If (((Tagged=FindTag) or (FindTag=0))
           and ((Not OnHold(HoldFlg)) or (((HoldFlg AND HOLDO)=HoldO) or ((HoldFlg AND HoldS)=HoldS)))
           and (AddHook)) then

        Begin
          Case Mode of
            80  :   If (Is_StdWOP) then
                      {$B-}
                      FoundOk:=((BuildQty_OS(Id)=0.0) or CanBuildStd(Inv,0,BOff))
                      {$B+}
                    else
                      FoundOk:=SOP_Check4Pick(IdetailF,IdFolioK,Inv,SOPLoc);

            81  :   Begin
                      KeySI:=FullIdKey(FolioNum,1);

                      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

                      {$B-}
                        FoundOk:=(StatusOk) and (Not Check_PossBuild(Id,BOn)) and ((Id.QtyPick<>0.0) or (BuildQty_OS(Id)=0.0))
                        and CheckKey(SOPLoc,Id.MLocStk,Length(SOPLoc),BOff);
                      {$B+}
                    end;
          end; {Case..}


          If (FoundOk) then
          Begin

            MatchDocHed:=Set_MatchLinkDoc(Inv.InvDocHed,Mode);

            If (Not GotOrd) then
              SOPRunNo:=SetNextWOPRunNo(MatchDocHed,BOn,0);


            GotOrd:=BOn;

            Case Mode of
              80
                 :  Begin
                      WOP_ProcessWOR(BOff,
                                     BOff,
                                     B_Func,
                                     SOPRunNo,
                                     SOPLoc,'',
                                     InvF,
                                     InvRNoK,
                                     Keypath,
                                     Mode);

                    end;




              81
                 :  Begin

                      WOP_BuildWOR(BOff,SOPRunNo,SOPLoc,B_Func,InvF,InvRNoK,Keypath,Mode);

                    end;

            end; {Case..}

          end;


        end; {If Order valid}

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

      If (GotOrd) then
      Begin

        {* Reset them, and recalc them *}

        WOP_RevealRun(SOP_RunNo(SOPRunNo,MatchDocHed),0,Mode,InvF,InvBatchK);


      end;
    finally
      {$IFDEF CU}
        CustomEvent.Free;
        ExLocal.Destroy;
      {$ENDIF}
    end;


  end; {Proc..}






  Procedure TSOPRunFrm.WOP_CtrlRun(NextRNo  :  LongInt;
                                   Mode     :  Byte);

  Const
    NoRuns      =  1;

    ProcStatus  :  Array[80..81] of String[25] = ('Issuing','Building');

    RunDefMode  :  Array[1..NoRuns] of Byte = (12);

    DocType     :  Array[80..81] of String[30] = ('Works Issue Notes','Works Orders');

  Var
    PrmptOn,
    KeepRun,
    GotOrd  :  Boolean;
    n,
    DefPNdx,
    DMode,
    TagNo   :  Byte;


  Begin
    GotOrd:=(Mode In [90,91]);  KeepRun:=BOn;  PrmptOn:=BOff;

    If (GotOrd) then
      DMode:=Mode-10
    else
      DMode:=Mode;

    With PCRepParam^,PSOPInp do
    Begin
      Visible:=BOn;

      If (Mode = 80) then
      Begin
        If Not Is_StdWOP then
          TagNo:=DelTag
        else
          TagNo:=InvTag;
      end
      else
        TagNo:=InvTag;

      Label1.Caption:=#13+'Please Wait...'+#13+ProcStatus[DMode]+' Works Orders';


      If (Mode In [80,81]) then
        WOP_RunIssue(FullNomKey(WORUPRunNo),0,NextRNo,TagNo,InvF,InvRNoK,GotOrd,SOPMLoc,Mode);

      Label2.Caption:='';

      Send_UpdateList(182);

      {$IFNDEF SOPDLL}
      If (GotOrd) then {Print documents}
      Begin

        Label1.Caption:=#13+'Printing '+DocType[DMode];

        For n:=1 to NoRuns do
          If (DelPrn[n]) and (KeepRun) then
          Begin
            {*EX32 Check if being previed...}

            Application.ProcessMessages;

            DefPNdx:=pfFind_DefaultPrinter(WPrnName[n]);

            Repeat
              PParam.PDevRec.TestMode:=BOff;

              If (KeepRun) then
              Begin
                PickRNo:=NextRNo;
                MatchK:=SOP_RunNo(NextRNo,Set_MatchLinkDoc(WOR,DMode));
                Fnum2:=IdetailF;
                Keypath2:=IdFolioK;

                If (DMode=80) then
                  PRMode:=n+6
                else
                  PRMode:=9;

                DefMode:=RunDefMode[n];

                PParam.PDevRec.DevIdx:=DefPNdx;
                PParam.PDevRec.Preview:=PrnScrn;


                If (KeepRun) then
                  AddPick2Thread(Application.MainForm,PCRepParam);


              end;

            Until (Not PParam.PDevRec.TestMode) or (Not KeepRun);
          end; {Loop..}


      end;
      {$ENDIF}

    end; {With..}




  end;


{$ENDIF}


{ ======= Procedure to Print a Test Pattern ======= }

Procedure TSOPRunFrm.Test_Pattern(DMode  :  Byte;
                                  DocHed :  DocTypes);


Var
  n  :  Byte;

Begin

  n:=0;

  ResetRec(InvF);
  ResetRec(CustF);

  With Inv do
  Begin

    InvDocHed:=DocHed;

    TransDate:=Today;
    DueDate:=Today;

    InvNetVal:=999999.99;
    InvVAT:=99999.99;

    {*Ex32 needs finishing OurRef:=DocCodes[DocHed]+ConstStr('X',DocKeyLen-3);

    CustCode:=ConstStr('X',Fpos[AccINo].Len);
    YourRef:=ConstStr('X',Fpos[YRefNo].Len);

    TransDesc:=ConstStr('X',Fpos[FTypNo].Len);

    For n:=1 to 5 do
      DAddr[n]:=ConstStr('X',Fpos[Ad1INo].Len);}

  end; {With..}


  {With Cust do
  Begin

    Company:=ConstStr('X',Fpos[CompNo].Len);

    For n:=1 to 5 do
      Addr[n]:=ConstStr('X',Fpos[Ad1INo].Len);

  end;

  Blank(NHist,Sizeof(NHist));

  SOP_DefProcess(DMode,
                 IdetailF,IdFolioK,
                 FullNomKey(Inv.FolioNum),Off,NIL);}


end; {Proc..}



{ ======= Prompt for paper change and ======= }


Procedure TSOPRunFrm.Warn_PrnChange(DMode  :  Byte;
                                    PName,
                                    RMsg   :  Str255;
                                    DocHed :  DocTypes);


Var
  mbRet    :  Word;
  TestMsg  :  TTestPrnMsg;

  PrevHState
           :  Boolean;


Begin
  PrevHState:=BOff;

  TestMsg:=TTestPrnMsg.Create(Self);

  try
    With TestMsg, PCRepParam^,PParam do
    Begin
      Label1.Caption:='Ready to print '+RMsg+' on Printer:-'+#13+PName+#13+'Please ensure it is ready.';

      Label2.Caption:='(Choose Test to print a test pattern)';

      SetAllowHotKey(BOff,PrevHState);

      Set_BackThreadMVisible(BOn);

      ShowModal;

      Set_BackThreadMVisible(BOff);

      SetAllowHotKey(BOn,PrevHState);

      mbRet:=ModalResult;

      PDevRec.TestMode:=(mbRet=mrYes);
    end;


  Finally
    TestMsg.Free;
  end; {Try..}


  KeepRun:=(mbRet<>mrCancel);


end; {Proc..}



{ ======= Function to Check for Picked Lines on order ====== }

Function TSOPRunFrm.SOP_Check4Pick(Fnum,
                                   Keypath  :  Integer;
                                   InvR     :  InvRec;
                                   SOPLoc   :  Str10)  :  Boolean;


Var
  KeyS,
  KeyChk  :  Str255;

  FoundOk :  Boolean;



Begin

  FoundOk:=BOff;

  KeyChk:=FullNomKey(InvR.FolioNum);

  If (InvR.InvDocHed In WOPSplit) then
    KeyS:=FullIdKey(InvR.FolioNum,2)
  else
    KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
  With Id do
  Begin
    Application.ProcessMessages;

    If (InvR.InvDocHed In WOPSplit) then
      FoundOk:=(Round_Up(QtyPick,Syss.NoQtyDec)<>0)
    else
      FoundOk:=(Round_Up(QtyPick+QtyPWOff,Syss.NoQtyDec)<>0);

    FoundOk:=(FoundOk and CheckKey(SOPLoc,Id.MLocStk,Length(SOPLoc),BOff));


    If (Not FoundOk) then
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}


  SOP_Check4Pick:=FoundOk;

end; {Func..}




{ ======= Proc to Control Single Delivery Conversion ====== }

Procedure TSOPRunFrm.SOP_GenDel(SingDoc  :  Boolean;
                                DocHed   :  DocTypes;
                                NextRNo  :  LongInt;
                                Mode     :  Byte);


Const
  NoRuns     =  4;

  RunMsg     :  Array[1..NoRuns] of Str20 = ('DELIVERY NOTES','CONSIGNMENT NOTES','PACKAGING LABELS','PRODUCT LABELS');

  RunDefMode :  Array[1..NoRuns] of Byte  = (1,15,16,26);

  RunFrmMode :  Array[1..NoRuns] of Byte  = (1,15,20,21);

  PickType   :  Array[BOff..BOn] of Str10   = ('Received','Picked');

  DocType    :  Array[1..2,BOff..BOn] of Str20   = (('Delivery Note','Invoice'),
                                                  ('Deliver','Invoice'));


Var

  B_Func   :  Integer;

  FoundCode:  Str20;

  WTrig,
  GotOrd,
  GotPick,
  PrmptOn,
  DirInv   :  Boolean;

  mbRet    :  Word;

  n        :  Byte;
  DefPNdx  :  Integer;

  PAExLocal,
  DelExLocal,
  ExLocal  :  TdExLocal;

  fmInfo   :  FormInfoType;

Begin

  DefPNdx:=0;

  B_Func:=B_GetNext;


  GotPick:=BOff;

  GotOrd:=(Mode In [11,13]);

  DirInv:=(Mode In [3,13]);

  WTrig:=BOff;

  n:=0;

  PrmptOn:=BOff;



  {$IFDEF Cu}
    PACustomEvent:=TCustomEvent.Create(EnterpriseBase+2000,79);

    {*EN501DELHK*}
    DelCustomEvent:=TCustomEvent.Create(EnterpriseBase+2000,103);
  {$ENDIF}

  Try

   {$IFDEF Cu}
     PAExLocal.Create;

      With PACustomEvent do
        If (GotEvent) then
        Begin
          BuildEvent(PAExLocal);

        end
        else
          FreeAndNil(PACustomEvent);


      DelExLocal.Create;

      With DelCustomEvent do
        If (GotEvent) then
        Begin
          BuildEvent(DelExLocal);

        end
        else
          FreeAndNil(DelCustomEvent);

   {$ENDIF}


    If (SingDoc) then
    Begin
{$IFNDEF SOPDLL}
      If (MessageDlg('Please confirm you wish to '+DocType[2,DirInv]+' this Order'
                       ,mtConfirmation,[mbNo,mbYes],0)=mrYes) then
{$ENDIF}
      Begin

        GotPick:=GetCust(Self,Inv.CustCode,FoundCode,BOff,-1);

        {Cust.Balance:=Get_CurCustBal(Cust);

        Warn_ODCredit(Cust.Balance,Cust,BOn,BOn,Self);}

        Check_AccForCredit(Cust,0,0,BOn,BOn,WTrig,Self);

        {$IFNDEF SOPDLL}
        Visible:=BOn;
        Update;
        {$ENDIF}

        If (GotPick) then
        Begin
          GotPick:=SOP_Check4Pick(IdetailF,IdFolioK,Inv,'');


          If (GotPick) then
          Begin

            Label1.Caption:=#13+'Please Wait...'+#13+'Generating '+DocType[1,DirInv];

            SOP_ProcessDel(BOff,
                           SingDoc,
                           B_Func,
                           NextRNo,
                           '',
                           InvF,
                           InvRNoK,
                           InvRNoK,
                           Mode);

            Send_UpdateList(182);

            {$IFNDEF SOPDLL}
            SendToObjectCC(Cust.CustCode,1);
            {$ENDIF}

            Label2.Caption:='';

            If (DocHed In SalesSplit) then
            Begin
            {$IFNDEF SOPDLL}
              {$IFDEF DPr_On}
                If (CheckRecExsists(SOP_RunNo(NextRNo,Set_MatchLinkDoc(DocHed,Mode)),InvF,InvBatchK)) then
                Begin
                  Label1.Caption:=#13+'Print '+DocType[1,DirInv]+#13+Inv.OurRef;

                  ExLocal.Create;
                  EXlocal.LInv:=Inv;
                  Control_DefProcess(1,IdetailF,IdFolioK,FullNomKey(Inv.FolioNum),ExLocal,BOn);
                  ExLocal.Destroy;
                end;

              {$ENDIF}
            {$ENDIF SOPDLL}
            end {IF to be printed}
            else
              Label1.Caption:='';

          end {IF Picking lines exist}
          else
          {$IFNDEF SOPDLL}
            MessageDlg('There are no '+PickType[(DocHed In SalesSplit)]+' lines on this Document'
                       ,mtInformation,[mbOk],0);
          {$ELSE}
            ErrCode := 30003;
          {$ENDIF}

        end;
      end;
    end
    else
    With PCRepParam^ do
    Begin
      Visible:=BOn;

      If (DocHed In SalesSplit) then
      Begin

          If (PSOPInp.SOR2Inv) then
            Mode:=Mode+2;

          DirInv:=(Mode In [3,13]);

          {Print_Controller;}
      end;

      If (KeepRun) then
      Begin

        If (Mode In [1,3]) then
        Begin
          Label1.Caption:=#13+'Please Wait...'+#13+'Generating '+DocType[1,DirInv]+'s';



          With PSOPInp do
            SOP_RunDel(DocCodes[DocHed],
                       0,
                       NextRNo,
                       DelTag,
                       DelCons,
                       InvF,
                       InvBatchK,
                       GotOrd,
                       SOPMLoc,
                       Mode);

          Label2.Caption:='';

          Send_UpdateList(182);

        end;

        {$IFNDEF SOPDLL}
        If (GotOrd) and (DocHed In SalesSplit) then {* Begin Print *}
        With PSOPInp do
        Begin

          Label1.Caption:=#13+'Printing '+DocType[1,DirInv]+'s';

          For n:=1 to NoRuns do
            If (DelPrn[n]) and (KeepRun) then
            Begin
              {*EX32 Check if being previed...}

              Application.ProcessMessages;

              DefPNdx:=pfFind_DefaultPrinter(WPrnName[n]);

              Repeat
                PParam.PDevRec.TestMode:=BOff;

                If ((Not PrnScrn) or (Debug)) and (DefPNdx>=0) and (PapChange) then
                Begin

                  Warn_PrnChange(RunDefMode[n],RPDev.Printers[DefPNdx],RunMsg[n],Set_MatchLinkDoc(DocHed,1));
                  PrmptOn:=BOn;
                end;

                If (Mode>10) then
                  Mode:=Mode-10;

                If (KeepRun) then
                Begin
                  PickRNo:=NextRNo;
                  MatchK:=SOP_RunNo(NextRNo,Set_MatchLinkDoc(DocHed,Mode));
                  Fnum2:=IdetailF;
                  Keypath2:=IdFolioK;

                  If (n=1)  and (PSOPInp.SOR2Inv) then {* Print as invoice *}
                  Begin
                    PRMode:=6;
                    DefMode:=1;
                  end
                  else
                  Begin
                    PRMode:=Succ(n);
                    DefMode:=RunDefMode[n];
                  end;

                  PParam.PDevRec.DevIdx:=DefPNdx;
                  PParam.PDevRec.Preview:=PrnScrn;

                  If (DefMode In [16,26]) then
                  Begin
                    If (PrmptOn) then
                    Begin
                      fmInfo:=GetFormInfo(pfGetMultiFrmDefs(0).FormDefs.PrimaryForm[RunFrmMode[n]]);

                      If (fmInfo.FormHeader.fhFormType = ftLabel) Then
                        KeepRun:= ShowLabelDlg(fmInfo.FormHeader, PParam.PDevRec.pbLabel1);
                    end
                    else
                      PParam.PDevRec.pbLabel1:=1;
                  end;

                  If (KeepRun) then
                    AddPick2Thread(Application.MainForm,PCRepParam);

                end;

              Until (Not PParam.PDevRec.TestMode) or (Not KeepRun);
            end; {Loop..}


        end;
        {$ENDIF}


      end;

    end;
  Finally
    {$IFDEF CU}
      If (Assigned(PACustomEvent)) then
        PACustomEvent.Free;

      PAExLocal.Destroy;

      If (Assigned(DelCustomEvent)) then
        DelCustomEvent.Free;

      DelExLocal.Destroy;
    {$ENDIF}


  end; {try..}
end;




{ ======= Proc to Control Single Delivery Conversion ====== }

Procedure TSOPRunFrm.SOP_GenInv(SingDoc  :  Boolean;
                                DocHed   :  DocTypes;
                                NextRNo  :  LongInt;
                                Mode     :  Byte);

Const
  NoRuns   =  3;

Var


  B_Func   :  Integer;

  GotOrd   :  Boolean;

  ExLocal  :  TdExLocal;

Begin

  B_Func:=B_GetNext;


  GotOrd:=(Mode=12);

  
  If (SingDoc) then
  Begin
{$IFNDEF SOPDLL}
    If (MessageDlg('Please confirm you wish to Invoice this Delivery'
                     ,mtConfirmation,[mbNo,mbYes],0)=mrYes) then
    Begin

      Label1.Caption:=#13+'Please Wait...'+#13+'Generating Invoice';

      Visible:=BOn;
{$ENDIF}     

      SOP_ConvertDel(BOff,
                     SingDoc,
                     B_Func,
                     NextRNo,
                     InvF,
                     InvRNoK,
                     InvRNoK,
                     Mode);

      Label2.Caption:='';

      Send_UpdateList(182);

      {$IFNDEF SOPDLL}
      SendToObjectCC(Cust.CustCode,1);
      {$ENDIF}

      If (DocHed In SalesSplit) then
      Begin

        {$IFDEF DPr_On}
          If (CheckRecExsists(SOP_RunNo(NextRNo,Set_MatchLinkDoc(DocHed,Mode)),InvF,InvBatchK)) then
          Begin
            Label1.Caption:=#13+'Print Invoice'+#13+Inv.OurRef;

            ExLocal.Create;
            ExLocal.LInv:=Inv;
            Control_DefProcess(1,IdetailF,IdFolioK,FullNomKey(Inv.FolioNum),ExLocal,BOn);
            ExLocal.Destroy;
          end;

        {$ENDIF}
      end;
{$IFNDEF SOPDLL}
    end; {If Confirmed..}
{$ENDIF}

  end
  else
  Begin
{$IFNDEF SOPDLL}
    Visible:=BOn;
{$ENDIF}

    If (DocHed In SalesSplit) then
    Begin
      {* Input Options *}


    end;



    If (KeepRun) then
    With PCRepParam^ do
    Begin

      If (Mode=2) then
      Begin
        Label1.Caption:=#13+'Please Wait...'+#13+'Generating Invoices';


        With PSOPInp do
          SOP_RunDel(FullDayBkKey(Set_OrdRunNo(DocHed,BOff,BOff),FirstAddrD,DocCodes[DocHed]),
                     Succ(Sizeof(NextRNo)),
                     NextRNo,
                     InvTag,
                     InvCons,
                     InvF,
                     InvRNoK,
                     GotOrd,
                     SOPMLoc,
                     Mode);

        Label2.Caption:='';

        Send_UpdateList(182);

      end;


      If (DocHed In SalesSplit) then
      With PSOPInp do
      Begin
{$IFNDEF SOPDLL}
        If (GotOrd) and (KeepRun) and (DelPrn[1]) then {* Begin Print *}
        Begin
          PickRNo:=NextRNo;
          MatchK:=SOP_RunNo(NextRNo,Set_MatchLinkDoc(DocHed,2));
          Fnum2:=IdetailF;
          Keypath2:=IdFolioK;
          PRMode:=6;
          DefMode:=1;
          PParam.PDevRec.DevIdx:=pfFind_DefaultPrinter(WPrnName[1]);
          PParam.PDevRec.Preview:=PrnScrn;


          AddPick2Thread(Application.MainForm,PCRepParam);
        end;
{$ENDIF}
      end;


    end; {If Abort..}

  end;



end;


{$IFDEF WOP}

  { ======= Proc to Control Single Delivery Conversion ====== }

  Procedure TSOPRunFrm.WOP_GenAdj(SingDoc  :  Boolean;
                                  DocHed   :  DocTypes;
                                  NextRNo  :  LongInt;
                                  Mode     :  Byte);

  Const
    NoRuns   =  3;

  Var


    B_Func   :  Integer;

    GotPick,
    GotOrd   :  Boolean;

    ExLocal  :  TdExLocal;

  Begin

    B_Func:=B_GetNext;


    GotOrd:=BOff;


    If (SingDoc) then
    Begin
      If (MessageDlg('Please confirm the issue of stock for Works Order '+Inv.OurRef
                       ,mtConfirmation,[mbNo,mbYes],0)=mrYes) then
      Begin
        If (Is_StdWOP) then
          GotPick:=CanBuildStd(Inv,0,SingDoc)
        else
          GotPick:=SOP_Check4Pick(IdetailF,IdFolioK,Inv,'');

        If (GotPick) then
        Begin
          Label1.Caption:=#13+'Please Wait...'+#13+'Generating Issue Note';

          Visible:=BOn;


          WOP_ProcessWOR(BOff,
                         SingDoc,
                         B_Func,
                         NextRNo,
                         '','',
                         InvF,
                         InvRNoK,
                         InvRNoK,
                         Mode);

          Label2.Caption:='';

          Send_UpdateList(182);

          Begin

            {$IFDEF DPr_On}
              If (CheckRecExsists(SOP_RunNo(NextRNo,Set_MatchLinkDoc(DocHed,Mode)),InvF,InvBatchK)) then
              Begin
                Label1.Caption:=#13+'Print Issue Note'+#13+Inv.OurRef;

                ExLocal.Create;
                ExLocal.LInv:=Inv;
                Control_DefProcess(27,IdetailF,IdFolioK,FullNomKey(Inv.FolioNum),ExLocal,BOn);
                ExLocal.Destroy;
              end;

            {$ENDIF}
          end;
        end
        else
        {$IFNDEF SOPDLL}
          If (Not Is_StdWOP) then
            MessageDlg('There are no picked lines on this Document'
                       ,mtInformation,[mbOk],0);
        {$ELSE}
          ErrCode := 30009;
        {$ENDIF}


      end; {If Confirmed..}


    end
    else
    Begin
      Visible:=BOn;

      If (DocHed In SalesSplit) then
      Begin
        {* Input Options *}


      end;



      If (KeepRun) then
      With PCRepParam^ do
      Begin



      end; {If Abort..}

    end;



  end;


  Procedure TSOPRunFrm.WOP_BuildAdj(SingDoc  :  Boolean;
                                    DocHed   :  DocTypes;
                                    NextRNo  :  LongInt;
                                    Mode     :  Byte);

  Const
    NoRuns   =  3;

  Var


    B_Func   :  Integer;

    GotPick,
    GotOrd   :  Boolean;

    ExLocal  :  TdExLocal;


  Function Link2BOMLine  :  Boolean;

  Const
    Fnum2    =  IdetailF;
    Keypath2 =  IdFolioK;

  Var
    KeyS    :  Str255;
    TmpStat :  Integer;

  Begin
    Result:=BOff;

    With Inv do
      KeyS:=FullIdKey(FolioNum,1);

    TmpStat:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    If (TmpStat=0) then
      Result:=(Not Check_PossBuild(Id,BOn)) and (Id.QtyPick<>0.0);
  end;

  Begin

    B_Func:=B_GetNext;


    GotOrd:=BOff;


    If (SingDoc) then
    Begin
      If (MessageDlg('Please confirm the building of Works Order '+Inv.OurRef
                       ,mtConfirmation,[mbNo,mbYes],0)=mrYes) then
      Begin
        GotPick:=Link2BOMLine;

        If (GotPick) then
        Begin
          Label1.Caption:=#13+'Please Wait...'+#13+'Generating Build Issue Note';

          Visible:=BOn;


          WOP_BuildWOR(SingDoc,NextRNo,'',B_Func,InvF,InvRNoK,InvRNoK,Mode);

          Label2.Caption:='';

          Send_UpdateList(182);

          Begin

            {$IFDEF DPr_On}
              If (CheckRecExsists(SOP_RunNo(NextRNo,Set_MatchLinkDoc(DocHed,Mode)),InvF,InvBatchK)) then
              Begin
                Label1.Caption:=#13+'Print Build Note'+#13+Inv.OurRef;

                ExLocal.Create;
                ExLocal.LInv:=Inv;
                Control_DefProcess(27,IdetailF,IdFolioK,FullNomKey(Inv.FolioNum),ExLocal,BOn);
                ExLocal.Destroy;
              end;

            {$ENDIF}
          end;
        end
        else
          If (Id.QtyPick=0.0) then
            MessageDlg('The BOM to be built has not been picked on this document.'
                     ,mtInformation,[mbOk],0);

      end; {If Confirmed..}


    end
    else
    Begin
      Visible:=BOn;

      If (DocHed In SalesSplit) then
      Begin
        {* Input Options *}


      end;



      If (KeepRun) then
      With PCRepParam^ do
      Begin



      end; {If Abort..}

    end;



  end;


{$ENDIF}


procedure TSOPRunFrm.FormCreate(Sender: TObject);
begin
  ClientHeight:=129;
  ClientWidth:=299;

  Left:=Round((Screen.Width/2)-(Width/2));
  Top:=Round((Screen.Height/2)-(Height/2));

  KeepRun:=BOn;

  Running:=BOff;

  {$IFDEF CU}
    PACustomEvent  :=Nil;
    DelCustomEvent  :=Nil;
  {$ENDIF}


end;





procedure TSOPRunFrm.FormActivate(Sender: TObject);
begin
  If (Not Running) then
  Begin
    Running:=BOn;

    If (SingleDoc) then
      Visible:=BOff;

    Case ThisMode of
      1,3,11,13  :  SOP_GenDel(SingleDoc,PDocHed,ThisRun,ThisMode);
      2,12       :  SOP_GenInv(SingleDoc,PDocHed,ThisRun,ThisMode);

      {$IFDEF WOP}
         80       :  If (SingleDoc) then
                       WOP_GenAdj(SingleDoc,PDocHed,ThisRun,ThisMode)
                     else
                       WOP_CtrlRun(ThisRun,ThisMode);


         81       :  If (SingleDoc) then
                       WOP_BuildAdj(SingleDoc,PDocHed,ThisRun,ThisMode)
                     else
                       WOP_CtrlRun(ThisRun,ThisMode);

         90,91    :  WOP_CtrlRun(ThisRun,ThisMode);

         97       :  ; {Do nothing as we need to get to the PORvSOR routine}

      {$ENDIF}
    end; {Case..}

    If (ThisMode<>97) then
      ShutDown;
  end;


end;

end.
