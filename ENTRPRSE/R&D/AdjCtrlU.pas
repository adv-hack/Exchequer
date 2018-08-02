unit Adjctrlu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,
  GlobVar,VarConst;

{$IF DEFINED(SOP) OR DEFINED(STK)}

  {$IFNDEF LTE}
    {$DEFINE USECOMPON}
  {$ENDIF}  

{$IFEND}

type
  TSAdjCForm = class(TForm)
    SetPanel: TSBSPanel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Running,
    PrevHState
            :  Boolean;

    fFolio  :  LongInt;
    fMode   :  Byte;
    fInv    :  InvRec;


    procedure Calc_AdjStockDeduct(InvFolio       :  LongInt;
                                  Mode           :  Byte);

    {$IFDEF USECOMPON}
      Procedure Control_CompSNos(OMode  :  Byte);


    {$ENDIF}

  public
    { Public declarations }
    Procedure Prime_AdjStk(InvR      :  InvRec;
                           Mode      :  Byte);


  end;

{$IFDEF STK}
  Procedure AdjAdjSNos(InvR       :  InvRec;
                       IdR        :  IDetail;
                       OutMode    :  Boolean;
                   Var SQty,SCost :  Double);

  Procedure RetroSNBOM(InvR      :  InvRec;
                       Fnum,
                       Keypath,
                       Fnum2,
                       Keypath2  :  Integer;
                       OMode     :  Byte);

{$ENDIF}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  BtrvU2,
  BTSupU1,
  BTKeys1U,
  CurrncyU,
  {$IFDEF USECOMPON}
    BOMCmpU,
  {$ENDIF}

  ExThrd2U,
  SysU2,
  StkSerNU,
  InvCTSUU;


{$R *.DFM}



{$IFDEF STK}



  { ===== Proc to Transfer all Serial nos from one document to another ===== }

  Procedure AdjAdjSNos(InvR       :  InvRec;
                       IdR        :  IDetail;
                       OutMode    :  Boolean;
                   Var SQty,SCost :  Double);


  Const
    Fnum      = MiscF;
    Keypath   = MIK;

  Var
    KeyS,KeyChk  :  Str255;

    DiscP,
    SerCount,
    SQtyU        :  Double;

    FoundOk,
    FoundAll,
    LOk,
    Locked       :  Boolean;

    LAddr        :  LongInt;


  Begin
    LOK := False;
    FoundAll:=(IdR.SerialQty=0.0);  SerCount:=0.0;

    SQty:=0.0; SCost:=0.0;  LAddr:=0; SQtyU:=0.0;

    If (IdR.StockCode<>Stock.StockCode) then
    Begin
      Global_GetMainRec(StockF,IdR.StockCode);
    end;

    If (Is_SerNo(Stock.StkValType)) and (Not FoundAll) then
    Begin

      If (OutMode) then
        KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio)+#1)
      else
        KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio));


      KeyS:=KeyChk+NdxWeight;


      Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) do
      With MiscRecs^.SerialRec do
      Begin
        Application.ProcessMessages;

        With InvR,IdR do
          If (OutMode) then
            FoundOk:=((CheckKey(OurRef,OutDoc,Length(OurRef),BOff))
                                       and (((SoldLine=SOPLineNo) and (IdDocHed=ADJ))
                                        or ((SoldLine=ABSLineNo) and (IdDocHed<>ADJ)))
                                   and ((Not BatchRec) or (BatchChild)))
          else
            FoundOk:=((CheckKey(OurRef,InDoc,Length(OurRef),BOff)) and (BuyLine=ABSLineNo));

        If (FoundOk) then
        With InvR,IdR do
        Begin
          If (Not OutMode) then
            LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

          If ((LOk) and (Locked)) or (OutMode) then
          Begin


            If (OutMode) then
            Begin
              If (BatchChild) then
              Begin
                SQty:=SQty+QtyUsed;
                SQtyU:=QtyUsed;
              end
              else
              Begin
                SQty:=SQty+1.0;
                SQtyU:=1.0;
              end;

              SCost:=SCost+Round_Up(Ser_CalcCrCost(IdR.Currency,MiscRecs^)*SQtyU,Syss.NoCosDec);

            end
            else
            Begin
              SerCost:=CostPrice;

              CurCost:=InvR.Currency;

              SerCRates:=CXRate;

              SerTriR:=CurrTriR;

              If (SerCRates[BOff]=0.0) then
              Begin
                SerCRates[BOff]:=SyssCurr^.Currencies[CurCost].CRates[BOff];
                SetTriRec(CurCost,SUseORate,SerTriR);
              end;

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

              Report_BError(Fnum,Status);

              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

            end;


            If (Not BatchChild) or (OutMode) then
            Begin
              If (BatchRec) then
              Begin
                If (OutMode) then
                  SerCount:=SerCount+QtyUsed
                else
                  SerCount:=SerCount+BuyQty;
              end
              else
                SerCount:=SerCount+1.0;
            end;
          end; {If Locked..}
        end;

        FoundAll:=(SerCount>=IdR.SerialQty);

        If (Not FoundAll) then
          Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}
    end; {If SNo..}

    If (SQty=0.0) and (Not FoundAll) and (IdR.IdDocHed=ADJ) then {v4.32 We have not found any so avoid it forcing a zero cost
                                                                        in by setting the current line cost}
    Begin
      SQty:=IdR.SerialQty;
      SCost:=SQty*Idr.CostPrice;
    end;

  end; {Proc..}


  { == Proc to Scan all stk deduct lines and adjust cost for serial numbers == }

  Procedure RetroSNBOM(InvR      :  InvRec;
                       Fnum,
                       Keypath,
                       Fnum2,
                       Keypath2  :  Integer;
                       OMode     :  Byte);


  Var
    LOk, Locked  :  Boolean;

    KeyChk,KeyS,
    KeyI         :  Str255;
    LocId,
    AvgId        :  IDetail;
    SQty,SCost,
    AdjX,
    TotAdjX      :  Double;

    TmpStat      :  Integer;

    TmpRecAddr,
    LAddr        :  LongInt;

  Procedure Update_LineCost;

  Begin
    LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

    If ((LOk) and (Locked)) then
    Begin

      If (Id.IdDocHed In [SOR,SDN]) then
        Id.CostPrice:=Round_Up(DivWChk(SCost,SQty),Syss.NoCosDec)
      else
        Id.CostPrice:=Round_Up(DivWChk(SCost,Id.Qty*Id.QtyMul*DocNotCnst*StkAdjCnst[Id.IdDocHed]),Syss.NoCosDec);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      Report_BError(Fnum,Status);

      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

    end;
  end;

  Begin
    If (OMode<>19) then
      KeyChk:=FullIdKey(InvR.FolioNum,StkLineNo)
    else
      KeyChk:=FullNomKey(InvR.FolioNum);

    KeyS:=FullIdKey(InvR.FolioNum,StkLineNo);;

    KeyI:='';

    TotAdjX:=0.0; LAddr:=0;

    LocId:=Id; AvgId:=Id;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With LocId do
    Begin
      Application.ProcessMessages;

      SQty:=0.0; SCost:=0.0;  AdjX:=0.0;

      LocId:=Id;

      If (StockCode<>Stock.StockCode) then
      Begin
        Global_GetMainRec(StockF,StockCode);
      end;

      If (Is_SERNo(SetStkVal(Stock.StkValType,Stock.SerNoWAvg,BOn)))  then
      Begin
        If (Not (IdDocHed In [SOR,SDN])) then
          SerialQty:=(Qty*QtyMul)*DocNotCnst*StkAdjCnst[IdDocHed]
        else
          SerialQty:=(Qty*QtyMul)*StkAdjCnst[IdDocHed];

        AdjAdjSNos(InvR,LocId,BOn,SQty,SCost);

        If (IdDocHed=ADJ) and (Round_Up(Qty*QtyMul*SSDUpLift*DocNotCnst*StkAdjCnst[IdDocHed],Syss.NoCosDec)<>SCost) then
        Begin
          If (Round_Up(Qty*QtyMul*CostPrice*DocNotCnst*StkAdjCnst[IdDocHed],2)<>SCost) then
            Update_LineCost;

          TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOff,BOff);

          KeyI:=FullIdKey(InvR.FolioNum,SOPLineNo);

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,IdLinkK,KeyI);

          If (StatusOk) then
          Begin
            AdjX:=Round_Up(DivWChk(SCost,Id.Qty*Id.QtyMul),Syss.NoCosDec)+
                 (Round_Up(DivWChk(Round_Up(Qty*QtyMul*SSDUpLift*StkAdjCnst[IdDocHed],Syss.NoCosDec),Id.Qty*Id.QtyMul),Syss.NoCosDec));

            AvgId:=Id;

            Id.CostPrice:=Id.CostPrice+AdjX;

            TotAdjX:=TotAdjX+AdjX;

            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,IdLinkK);

            Report_BError(Fnum,Status);

            If (Id.SerialQty<>0.0) then
              AdjAdjSNos(InvR,Id,BOff,SQty,SCost)
            else
            Begin
              If (Id.StockCode<>Stock.StockCode) then
              Begin
                Global_GetMainRec(StockF,Id.StockCode);
              end;

              If Is_FIFO(Stock.StkValType)  or (FIFO_Mode(Stock.StkValType)=4) then
              Begin
                If (Is_FIFO(Stock.StkValType)) then
                  AvgId:=Id;

                Stock_Deduct(AvgId,InvR,BOff,BOn,99); {Reverse Stock Temporarily}

                Stock_Deduct(Id,InvR,BOn,BOn,99); {Credit Stock }

              end;

            end;

          end;

          TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOn,BOff);
        end
        else
        If (IdDocHed In SalesSplit) then
        Begin
          Update_LineCost;
        end;


      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}


    If (TotAdjX<>0.0) and (InvR.InvdocHed = ADJ) then
    Begin
      KeyS:=FullNomKey(InvR.FolioNum);

      Locked:=BOff;

      LOk:=GetMultiRecAddr(B_GetEq,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,LAddr);

      If (LOk) and (Locked) then
      Begin
        Inv.TotalCost:=Inv.TotalCost+TotAdjX;

        Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

        Report_BError(Fnum2,Status);

        Status:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);

      end;

    end;
  end; {Proc..}

           

{$ENDIF}





procedure TSAdjCForm.FormCreate(Sender: TObject);
begin
  Running:=BOff;
end;

Procedure TSAdjCForm.Prime_AdjStk(InvR      :  InvRec;
                                  Mode      :  Byte);



Begin
  fInv:=InvR;

  fFolio:=InvR.FolioNum;
  fMode:=Mode;

  SetPanel.Caption:='Please Wait... Adjusting Stock.';

  SetAllowHotKey(BOff,PrevHState);
  Set_BackThreadMVisible(BOn);


  ShowModal;

  SetAllowHotKey(BOn,PrevHState);
  Set_BackThreadMVisible(BOff);


end;


{ ======== Procedure to Control Stock Deduct Lines ====== }

{$IFDEF USECOMPON}
  { ============ Procedure to Control Serial Nos =========== }


  Procedure TSAdjCForm.Control_CompSNos(OMode  :  Byte);

  Var

    StkRec
         :  TCMPSerCtrl;


  Begin
    With fInv do
      If (CheckExsists(FullIdKey(FolioNum,StkLineNo),IdetailF,IdFolioK)) then
      Begin
        Hide;

        StkRec:=TCMPSerCtrl.Create(Self);

        try

          With StkRec do
          Begin

            EditAccount(fInv,OMode);

            ShowModal;

            {Repeat

              Application.ProcessMessages;

            Until (Not StkActive);}

          end; {With..}

        finally

          StkRec.Free;

        end; {try..}

        Show;
      end; {If no lines..}
  end; {Proc..}


{$ENDIF}

 {* Scan IDetail Line Present and re_Calc stock deduct from them *}

 procedure TSAdjCForm.Calc_AdjStockDeduct(InvFolio       :  LongInt;
                                          Mode           :  Byte);


 Const
   Fnum      =  IDetailF;
   Keypath   =  IDFolioK;
   Fnum2     =  InvF;
   Keypath2  =  InvFolioK;

 Var
   KeyS,
   KeyChk    :  Str255;

   StkFolio,
   LRecAddr,
   RecAddr   :  LongInt;

   TmpId     :  IDetail;

   DocCost   :  Real;

   Locked    :  Boolean;
   DNum,
   SQty,
   SCost     :  Double;


 Begin

   DNum := 0.0;
   DocCost:=0;

   SQty:=0.0; SCost:=0.0;

   StkFolio:=0;

   Blank(TmpId,Sizeof(TmpId));

   KeyS:=FullIdkey(InvFolio,StkLineNo);  {* Remove any existing lines *}

   {$IFDEF USECOMPON}
     Control_CompSNos(17);
   {$ENDIF}

   Delete_StockLinks(KeyS,IdetailF,Length(KeyS),IdFolioK,BOff,Inv,0);

   KeyChk:=FullNomKey(InvFolio);

   KeyS:=FullIdkey(InvFolio,0);

   Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


   While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
   With Id do
   Begin

     Application.ProcessMessages;

     If (KitLink=1) then   {* Deduct Lower Levels *}
     Begin

       Status:=GetPos(F[Fnum],Fnum,RecAddr);

       {$IFDEF USECOMPON}
          If (Stock.StockCode<>StockCode) then
            Global_GetMainRec(StockF,StockCode);

          StkFolio:=Stock.StockFolio;

       {$ENDIF}

       Gen_StockDeduct(Id,fInv,0,0, DNum,StkFolio,Id.ABSLineNo);

       TmpId:=Id;  {* Collect total cost *}

       SetDataRecOfs(Fnum,RecAddr);

       Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

       Locked:=BOff;

       Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LRecAddr);

       If (Ok) and (Locked) then
       Begin

         Stock_Deduct(Id,fInv,BOff,BOn,99); {Reverse Stock Temporarily}

         Id:=TmpId;

         {If (Syss.AutoValStk) then {* Cost is worked out at the time of generating BOM lines *}
         {EN552. We still need this calculation so BOM serial numbers continue to be updated}
         Begin
           Id.CostPrice:=ABS(Round_up(DivWChk(Id.CostPrice,(Id.Qty*Id.QtyMul)),Syss.NoCosDec));
           Id.B2BLineNo:=0;
         end;

         Stock_Deduct(Id,fInv,BOn,BOn,99); {Credit Stock }

         Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

         Report_BError(Fnum,Status);

         Status:=UnLockMultiSing(F[Fnum],Fnum,LRecAddr);

         If (StatusOk) and (Is_SERNo(Stock.StkValType)) then
         Begin
           {$IFDEF SOP}

             AdjAdjSNos(fInv,Id,BOff,SQty,SCost);

           {$ENDIF}

         end;

       end;

     end;

     {* Calculate total cost of Adjustment *}

     With Id do
       DocCost:=DocCost+Round_Up((Qty*QtyMul)*Round_Up(CostPrice,Syss.NoCosDec),2);


     Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

   end; {While..}

   If (DocCost<>0) then {* Store cost of ADJ *}
   Begin
     KeyS:=FullNomKey(InvFolio);

     Locked:=BOff;

     Ok:=GetMultiRecAddr(B_GetEq,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,LRecAddr);

     If (Ok) and (Locked) then
     Begin
       Inv.TotalCost:=DocCost;

       Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

       Report_BError(Fnum2,Status);

       Status:=UnLockMultiSing(F[Fnum2],Fnum2,LRecAddr);

     end;
   end; {Recording of Adj Cost}

   {$IFDEF USECOMPON}
     Control_CompSNos(18);
   {$ENDIF}


   {$IFDEF SOP}
     RetroSNBOM(Inv,Fnum,Keypath,Fnum2,Keypath2,18);
   {$ENDIF}

 end; {Proc..}


procedure TSAdjCForm.FormActivate(Sender: TObject);
begin
  If (Not Running) then
  Begin
    Running:=BOn;

    UpDate;


    Calc_AdjStockDeduct(fFolio,fMode);

    PostMEssage(Self.Handle,WM_Close,0,0);
  end;
end;


end.
