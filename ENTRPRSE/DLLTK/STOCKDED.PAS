unit StockDed;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

implementation

{ ====== Function to Store Detail Lines ======= }

Function Store_EId  :  Integer;

Const
  Fnum     =  IDetailF;
  Keypath  =  IdFolioK;

Var
  Rnum      :  Double;
  StkFolio  :  LongInt;

Begin
  With Id do
  Begin
    FolioRef:=Inv.FolioNum;
    IDDocHed:=Inv.InvDocHed;

    If (Payment=DocPayType[SRC]) or (IDDoched In NomSplit+StkAdjSplit) then
      LineNo:=RecieptCode;

    If (Inv.InvDocHed In TSTSplit) then
       NomMode := TSTNomMode;     { TSTNomMode = 3 }

    {* Added on 17/02/98 for SRI value is Debit instead of Credit for New Zealand *}
    If (Payment=DocPayType[SRC]) then
      Payment:=SetRPayment(IDDocHed)
    else
      Payment:=DocPayType[IDDocHed];

    If (QtyMul=0) then
      QtyMul:=1;

    If (Not ExSyss.MCMode) or (Not (Inv.InvDocHed In RecieptSet+NomSplit+StkAdjSplit+TSTSplit)) then
    Begin
      CXRate:=Inv.CXRate;
      CurrTriR:=Inv.CurrTriR; { for v4.31 }

      Currency:=Inv.Currency;
    end;

    PYr:=Inv.ACYr;
    PPr:=Inv.AcPr;

    If (Syss.AutoClearPay) then
      Reconcile:=ReconC;

    If (IDDocHed In SalesSplit+PurchSplit) then
      CustCode:=Inv.CustCode;

    {* Stock Deduct Here *}
    If Not (Inv.InvDocHed In TSTSplit) then
    Begin

      If (Not EmptyKey(StockCode,StkLen)) and (StockCode[1]<>PayInCode)
         and (ExSyss.UpStkBal) then
      begin

        Stock_Deduct(Id,Inv,BOn,BOn,0);

        If (ExSyss.DeductBOM) and (Inv.InvDocHed In SalesSplit+StkadjSplit) Then
        begin
          Rnum:=0;
          StkFolio:=Stock.StockFolio;
          Gen_StockDeduct(Id, Inv, 0, 0, Rnum, StkFolio);
        end; {if..}

      end
      else
        If (StockCode[1]=PayInCode) then
          StockCode:=FullPayInKey(StockCode);

    end; {not TSH}
    {=====================}

    LineType:=StkLinetype[IdDocHed];

    If (IdDocHed In StkAdjSplit) then
    Begin
      PostedRun:=StkAdjRunNo;
      NomMode:=StkAdjNomMode;
    end;

    ABSLineNo:=LineNo;

    If (Inv.InvDocHed In TSTSplit) then Begin
       ABSLineNo:=Inv.ILineCount;
       PYr:=Inv.AcYr;
       PPr:=Inv.AcPr;
    end;

    Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

  end; {With..}


{* -------------------------------------------------------------------------- *}

Procedure Gen_StockDeduct(Var Idr     :  IDetail;
                              LInv    :  InvRec;
                              Level   :  LongInt;
                              Mode    :  Byte;
                          Var BOMOCost:  Double;
                              StkFolio:  LongInt);

Const

  Fnum     =  PWrdF;

  Keypath  =  PwK;


  Fnum2    =  StockF;
  Keypath2 =  StkFolioK;

  Fnum3    =  IDetailF;
  Keypath3 =  IdFolioK;

Var

  KeyS,
  KeyChk,
  KeyStk   :  Str255;

  RecAddr  :  LongInt;

  QtyShort,
  QtyGCost :  Real;

  OwnCost,
  KitOCost :  Double;

  TmpStock :  ^StockRec;
  TmpId    :  ^Idetail;

  Locked   :  Boolean;

Begin

  KeyS:='';

  KeyChk:='';

  KeyStk:='';

  RecAddr:=0;

  New(TmpStock);
  New(TmpId);

  QtyShort:=0;

  QtyGCost:=0;

  If (Level=0) then
    BOMOCost:=0;

  KitOCost:=0;
  OwnCost:=0;



  If (Idr.IdDocHed In StkAdjSplit) and (Idr.KitLink=1) and (Level=0) then
  Begin

    QtyShort:=((Idr.Qty*Idr.QtyMul*StkAdjCnst[Idr.IdDocHed]*DocNotCnst));

    Locked:=BOff;
    KeyS:=Idr.StockCode;

    {$IFDEF WIN32}
    If (GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked)) then
      Status:=0;
    {$ELSE}
    Status:=(GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked));
    {$ENDIF}

  end
  else
  Begin
    {* This will be different from Ex, as Ex non SPOP deletes the lines first hence why
       a deduct needs to take place here as well *}

    If (Level=0) then {* Assume stock already deducted from line entry *}
    begin

      Locked:=BOff;
      KeyS:=Idr.StockCode;

      {$IFDEF WIN32}
      If (GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked)) then
        Status:=0;
      {$ELSE}
      Status:=(GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked));
      {$ENDIF}

    end
    else
      Stock_Deduct(Idr,LInv,BOn,BOn,0);


    QtyShort:=((Qty_OS(Idr)*Idr.QtyMul)-Idr.DeductQty);

    {* If own stock exsits, the record cost contribution of that *}
    If (Idr.IdDocHed In StkAdjSplit) and (Stock.StockType=StkBillCode) and (Round_Up(Idr.DeductQty,Syss.NoQtyDec)<>0.0) then
    Begin
      OwnCost:=(Idr.CostPrice*(ABS(Idr.DeductQty)-1)); {* One less as idr.costprice will account for one of them *}
    end;

    {* EN422. At this point if none are from stock we need to zero the cost of this line,
       as it is already being taken into account by
       Own cost, and hence will be taken in to account twice? *}

    {* EX423. An additional check made so that description only items do not have cost reset at this point. *}

    If (IdR.DeductQty=0) and (Stock.StockType<>StkDescCode) then
      IdR.CostPrice:=0.0;


  end;

  TmpStock^:=Stock;

  TmpId^:=Idr;

  {Need to confirm 13.07.99.......}

  { This is o.k for Kit Disabled -  No BOM stock, and deduct from Components ...}
  If (Stock.StockType=StkBillCode) and ((Not Stock.ShowasKit) or (Level>0))
    and (LInv.InvDocHed In SalesSplit+StkAdjSplit-StkExcSet) and (QtyShort<>0) then
  With TmpStock^ do
  Begin


    If ((LInv.InvDocHed In StkAdjSplit) and (Syss.AutoValStk)) and (Level=0) then
      TmpId^.CostPrice:=0;

    KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Password.BillMatRec do
    Begin

      {Application.ProcessMessages;}

      Status:=GetPos(F[Fnum],Fnum,RecAddr);

      KeySTk:=BillLink;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

      If (StatusOk) then
      Begin
        With Idr do
        Begin

          StockCode:=Stock.StockCode;

          LineNo:=StkLineNo;

          If (EmptyKey(Desc,SizeOf(Desc))) then
            Desc:=Stock.Desc[1];

          NetValue:=0;

          CostPrice:=0;

          VAT:=0;

          Discount:=0;

          DiscountChr:=C0;

          NomCode:=0;

          Blank(CCDep,Sizeof(CCDep));

          Qty:=(QtyShort*QtyUsed);

          QtyMul:=1;
          QtyPack:=QtyMul;

          QtyDel:=0;
          QtyWOff:=0;
          QtyPick:=0;
          QtyPWOff:=0;
          SerialQty:=0;

          If (Mode=0) then  {* Switch off ABS LineNo Control *}
          Begin

            ABSLineNo:=0;

            {$IFDEF SOP}
              KitLink:=StkFolio;
            {$ELSE}
              KitLink:=0;
            {$ENDIF}


            SOPLink:=0;   {* Reset any link *}
            SOPLineNo:=0;
          end
          else
            If (Level=0) then  {* Set Kit folio so it is treated as part of a batch *}
              KitLink:=TmpStock^.StockFolio;


        end;


        If (Stock.StockType=StkBillCode) then
        Begin

          Gen_StockDeduct(Idr,LInv,Succ(Level),Mode,KitOCost,StkFolio);

          SetDataRecOfs(Fnum,RecAddr);

          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

          QtyGCost:=1;  {* Set Cost to 1 here, as BOM will return total cost for Qty *}

        end
        else
        Begin
          Stock_Deduct(Idr,LInv,BOn,BOn,0);

          QtyGCost:=ABS(Idr.Qty);

        end;

        {* Calculate and adjustment BOM cost price by recalculating the BOM
           contents *}

        If ((LInv.InvDocHed In StkAdjSplit) and (Syss.AutoValStk)) then
        Begin
          If (Level=0) then
            TmpId^.CostPrice:=TmpId^.CostPrice+(Idr.CostPrice*QtyGCost)+KitOCost+OwnCost
          else
            OwnCost:=OwnCost+(Idr.CostPrice*QtyGCost)+KitOCost;
        end
        else
          Idr.CostPrice:=0;  {* Reset Cost price again, incase it has been set by
                          an adjustment valuation *}

        KitOCost:=0;

        Status:=Add_Rec(F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3);


      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    Stock:=TmpStock^;

    Idr:=TmpId^;

  end; {If Kit or Normal Product ..}

  BOMOCost:=BOMOCost+OwnCost;

  Dispose(TmpStock);

  Dispose(TmpId);


end; {Proc..}


end;

{* -------------------------------------------------------------------------- *}


end.
