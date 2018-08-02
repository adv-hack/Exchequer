Unit DiscU4U;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 16/01/96                      }
{                                                              }
{              Account Discount Link Controller II             }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     MiscU;




  Procedure Re_CalcDocPrice(      Mode  :  Byte;
                            Var   LInv  :  InvRec;
                            Const ResetECServiceFlag : Boolean = False;
                            Const ResetNetValueForInclusiveVAT : Boolean = False);


{$IFDEF STK}
  Procedure SOP_AdjOSOrd(Fnum,
                         Keypath  :  Integer;
                     Var LInv     :  InvRec);


  Procedure CD_RenumbStk(OldCode,
                         NewCode   :  Str20);

  Procedure Check_QBDisc(CSupCode  :  Char;
                         KeyRef    :  Str30;
                         Fnum,
                         Keypath   :  Integer;
                         TStock    :  StockRec;
                     Var NoStop    :  Boolean;
                         Mode      :  Byte);


  Procedure Check_CDDisc(CSupCode  :  Char;
                         KeyRef    :  Str30;
                         Fnum,
                         Keypath   :  Integer;
                         Mode      :  Byte);


//PR: 09/02/2012 I've been unable to discover anywhere that this function is used, so have commented it out rather than
//amending it for the new Qty Break file (ABSEXCH-9795). This will give a compiler error if anything tries to use it, at
//which point we can amend it if necessary.
(*
  Procedure CD_RenumbDisc(CSupCode  :  Char;
                          OldCode,
                          NewCode   :  Str10);
*)
{$ENDIF}

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Controls,
   Forms,
   Dialogs,
   StrUtils,
   SysUtils,
   ETStrU,
   ETMiscU,
   BtrvU2,
   VarFposU,
   BTKeys1U,
   ComnUnit,
   ComnU2,
   CurrncyU,
   SysU2,
   SysU1,
   InvListU,

   {.$IFDEF SOP}



   {.$ENDIF}

   {$IFDEF STK}
     InvFSU3U,
     EXWrap1U,
     InvCT2SU,
   {$ENDIF}

   

   {$IFDEF STK}
     FIFOL2U,
     InvCTSUU,
     DiscU3U,
   {$ENDIF}

   {$IFDEF SOP}
    MultiBuyFuncs,
    Classes,
   {$ENDIF}
   
   BTSupU1,
   Warn1U,

   //PR: 09/02/2012 ABSEXCH-9795
   QtyBreakVar;




  { ======= Procedure to Re-Calculate an Invoices Pricing ======= }


  { ======= Function to determine if Kit Line ===== }

  Function Is_OwnLine(Idr  :  IDetail)  :  Boolean;

  Begin
    Result:=BOff;

    With IdR do
    {If (Is_FullStkCode(StockCode)) then}
    Begin
      Result:=(KitLink=0) or (NetValue<>0.0);

    end;

    Is_OwnLine:=Result;
  end;


  Procedure Re_CalcDocPrice(Mode  :  Byte;
                        Var LInv  :  InvRec;
                        Const ResetECServiceFlag : Boolean = False;
                        Const ResetNetValueForInclusiveVAT : Boolean = False);

  Const

    Fnum    =  IdetailF;

    Keypath =  IDFolioK;


  Var
    KeyS,
    KeyChk,
    KeyStk  :  Str255;

    FoundCode
            :  Str20;
    Flg,
    GotStk  :  Boolean;

    MsgForm :  TForm;

    {$IFDEF STK}
      ExLocal
            :  TdExlocal;

    {$ENDIF}

    {$IFDEF SOP}
     MBDFuncs : TMultiBuyFunctions;
     iDeletedLines : Integer;
     AList : TStringList;
     dMBDValue : Double;
     TmpId : IDetail;
    {$ENDIF}

    ECServicesReset : LongInt;
    UpdateID : Boolean;

  Begin
    MsgForm := nil;

    KeyStk:='';

    Flg:=BOff;  GotStk:=BOff;

    KeyChk:=FullNomKey(LInv.FolioNum);
    KeyS:=FullIdKey(LInv.FolioNum,1);

    If (Mode In [0,10,11]) then
    Begin
      MsgForm:=CreateMessageDialog('Please Wait...'+#13+#13+'Recalculating Discounts.',mtInformation,[]);
      MsgForm.Show;
      MsgForm.Update;
    end;


    {$IFDEF STK}
      ExLocal.Create;

      ExLocal.LInv:=LInv;


    {$ENDIF}

    ECServicesReset := 0;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Id.LineNo<>RecieptCode) do
    With Id do
    Begin
      {$IFDEF STK}
        ExLocal.LastId:=Id;
      {$ENDIF}
      {$B-}

      If (Is_OwnLine(Id)) and ((Is_FullStkCode(StockCode)) or (Mode<>0)) then

      {$B+}

      Begin
        UpdateID := False;

        KeyStk:=StockCode;

        {$IFDEF STK}
        If (Is_FullStkCode(StockCode)) then
          GotStk:=GetStock(Application,KeyStk,FoundCode,-1)
        else
        {$ENDIF}
        Begin
          GotStk:=BOn;
          Blank(Stock,Sizeof(Stock));
          Stock.VATCode:=VATSTdCode;
        end;


        If (GotStk) then
        Begin

          {$IFDEF STK}
            UpdateRecBal(Id,LInv,BOn,BOff,1);
          {$ENDIF}

          Flg:=(Mode=10);

          // MH 15/06/2010 v6.4 ABSEXCH-2614: When called from the Transaction Header after changing
          // the transaction date lines with Inclusive VAT need their net value reset so that VAT
          // isn't deducted from the existing net value which has already had VAT taken from it -
          // this causes the line value to drop each time the routine is run
          If ResetNetValueForInclusiveVAT Then
          Begin
            If (VatCode = VATMCode) Then
              NetValue := IncNetValue;
          End; // If ResetNetValueForInclusiveVAT

          If (Flg) and (Cust.VATCode<>VATCode)  and (VATCode<>VATMCode) then
            VATCode:=Correct_PVAT(Stock.VATCode,Cust.VATCode);

          {$IFDEF STK}
            If (Is_FullStkCode(StockCode)) then
              Calc_StockPrice(Stock,Cust,LInv.Currency,Qty,LInv.TransDate, NetValue,Discount,DiscountChr,MLocStk,Flg,Mode);
          {$ENDIF}

          {$IFDEF SOP}
           //PR: 03/08/2009 Need also to recalculate MultiBuyDiscounts when AcCode changes
           if (Mode in [10, 11]) and Is_FullStkCode(StockCode) then
           begin
             MBDFuncs := TMultiBuyFunctions.Create;
             Try
               //If we've already got an MBD on the line then delete any additional description lines.
               if Id.Discount2 <> 0 then
                 iDeletedLines := MBDFuncs.DeleteDescLines(Id)
               else
                 iDeletedLines := 0;

               AList := MBDFuncs.GetMultiBuyList(Cust.CustCode, ID.StockCode, ExLocal.LInv.TransDate,
                                                         nil, ExLocal.LInv.Currency, False, ExLocal.LInv.InvDocHed in SalesSplit, Id.Qty);

               Try
                 if AList.Count > 0 then
                 begin
                   MBDFuncs.GetUnitDiscountValue(AList, ID, dMBDValue, ID.Discount2Chr);
                   ID.Discount2 := dMBDValue;
                   if ID.Discount2 <> 0 then
                   begin //PR: 03/08/2009 - Need to move even if no deleted lines
                     if {(iDeletedLines > 0) and} (iDeletedLines < AList.Count) then
                     begin
                       TmpId:=ID;

                       MoveEmUp(FullNomKey(ID.FolioRef),
                              FullIdKey(ID.FolioRef,LastAddrD),
                              FullIdKey(ID.FolioRef,ID.LineNo),
                              2 * (AList.Count - iDeletedLines),
                              IDetailF,IdFolioK);

                       ID:=TmpId;
                     end;
                     MBDFuncs.AddMultiBuyDescLines(ExLocal.LInv, ID, Stock.StockFolio, AList);
                   end;
                 end
                 else
                 begin
                   ID.Discount2 := 0;
                   ID.Discount2Chr := #0;
                 end;
               Finally
                 AList.Free;
               End;
             Finally
               MBDFuncs.Free;
             End;

           end;
          {$ENDIF}

          {$IFDEF STK} {*v5.70 also update cost prices *}
            If (Id.IdDocHed In StkInSet-[PCR,PRF,PJC]) then
            Begin
              Stock_Deduct(ExLocal.LastId,LInv,BOff,BOn,99);

              Stock_Deduct(Id,LInv,BOn,BOn,99);
            end;
          {$ENDIF}


          {$IFDEF SOP}
            With ExLocal do
            Begin
              AssignFromGlobal(StockF);
              AssignFromGlobal(CustF);
              AssignFromGlobal(IdetailF);

              If (Flg) and (VATCode=VATMCode) then
              Begin
                QBLineVAT_Update(ExLocal);

                AssignToGlobal(IdetailF);
              end
              else
                CalcVat(Id,LInv.DiscSetl);
            end;

          {$ELSE}

            CalcVat(Id,LInv.DiscSetl);

          {$ENDIF}

          {$IFDEF STK}
            UpdateRecBal(Id,LInv,BOff,BOff,1);
          {$ENDIF}

          UpdateID := True;
        End; // If (GotStk)

        // MH 11/09/2009: Added reset of EC Service Flag if account code changes to non-EC
        If ResetECServiceFlag And Id.ECService Then
        Begin
          ECServicesReset := ECServicesReset + 1;
          Id.ECService := False;
          UpdateID := True;
        End; // If ResetECServiceFlag And Id.ECService

        If UpdateId Then
        Begin
          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          Report_BError(Fnum,Status);

        end;

      end; {If Got Stock..}

      If (StatusOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    If (ECServicesReset > 0) Then
    Begin
      MessageDlg ('The Account Code has been changed to a non EC Member. ' +
                  IntToStr(ECServicesReset) + ' EC Service flag' + IfThen(ECServicesReset>1,'s have',' has') +
                  ' been disabled on the transaction line' + IfThen(ECServicesReset > 1, 's', '') + ' for services',
                  mtWarning, [mbOK], 0);


      //MessageDlg (IntToStr(ECServicesReset) + ' EC Service flag' + IfThen(ECServicesReset>1,'s have',' has') + ' been removed from the Transaction Lines', mtWarning, [mbOK], 0);
    End; // If (ECServicesReset > 0)

    {$IFDEF STK}
      ExLocal.Destroy;

    {$ENDIF}


    If (Mode In [0,10,11]) then
      MsgForm.Free;

  end; {Proc..}


{$IFDEF STK}

    { ======= Procedure to Update all OS SOR's ======= }

    Procedure SOP_AdjOSOrd(Fnum,
                           Keypath  :  Integer;
                       Var LInv     :  InvRec);


    Var
      KeyS,
      KeyChk  :  Str255;

      Locked  :  Boolean;

      LAddr   :  LongInt;

    Begin

      KeyChk:=FullNomKey(Set_OrdRunNo(SOR,BOff,BOff));

      KeyS:=FullDayBkKey(Set_OrdRunNo(SOR,BOff,BOff),FirstAddrD,DocCodes[SOR]);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LInv do
      Begin

        Locked:=BOff;

        Ok:=((Not OnHold(HoldFlg)) and (InvDocHed In OrderSet));

        If (Ok) then
          Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin

          Re_CalcDocPrice(1,LInv);

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          Report_BError(Fnum,Status);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

        end;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

    end; {Proc..}






  { ========== Procedure to Rename from one code to another ======== }

  Procedure CD_RenumbStk(OldCode,
                         NewCode   :  Str20);


  Const
    Fnum      =  MiscF;
    Keypath   =  MiscNdxK;


  Var
    KeyS,KeyChk  :  Str255;

    Loop         :  Boolean;


  Begin


    Loop:=BOff;

    Repeat

      KeyChk:=FullQDKey(CDDiscCode,TradeCode[Loop],FullStockCode(Oldcode));


      KeyS:=KeyChk;


      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With MiscRecs^ do
      With CustDiscRec do
      Begin

        QStkCode:=NewCode;

        DiscCode:=MakeCDKey(DCCode,QStkCode,QBCurr)+HelpKStop;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);

        If (StatusOk) then
          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

      Loop:=Not Loop;

    Until (Not Loop);

  end; {Proc..}




  { ======== Routines to Run checks on Discount levels Set ========== }


  { ====== Check Qty Breaks ====== }

  { =================== Message to Warn Reciept Part to be entered manually ============== }

  Procedure Warn_DiscLow(CostP,
                         SellP  :  Real;
                         ProdR  :  StockRec;
                         Msg    :  Str80;
                     Var Tc     :  Char);


  Var
    mbRet  :  Word;

  Begin
    With ProdR do
    Begin

      mbRet:=MessageDlg(' - WARNING! Selling Price too Low! - '+#13+#13+
                        Strip('B',[#32],StockCode)+Msg+#13+#13+
                        'Cost Price : '+Form_Real(CostP,0,2)+' Sell Price : '+Form_Real(SellP,0,2)
                        ,mtWarning,[mbOk,mbAbort],0);

      If (mbRet=mrAbort) then
        Tc:=Esc
      else
        Tc:=#0;


    end; {With..}

  end;




  Procedure Check_QBDisc(CSupCode  :  Char;
                         KeyRef    :  Str30;
                         Fnum,
                         Keypath   :  Integer;
                         TStock    :  StockRec;
                     Var NoStop    :  Boolean;
                         Mode      :  Byte);



  Var
    KeyS,
    KeyChk,
    KeyStk  :  Str255;

    IdR     :  IDetail;

    SellP,
    CostP,
    DiscP   :  Real;

    UseNDec :  Byte;

    Tch     :  Char;

    MsgForm :  TForm;

    mbRet   :  TModalResult;


  Begin

    MsgForm:=CreateMessageDialog('Please Wait...'+#13+#13+'Checking Qty Breaks.',mtInformation,[mbAbort]);
    MsgForm.Show;
    MsgForm.Update;

    Blank(KeyStk,Sizeof(KeyStk));

    KeyStk:=TStock.StockCode;

    SellP:=0;
    DiscP:=0;
    CostP:=0;

    //PR: 09/02/2012 ABSEXCH-9795
    KeyChk := KeyRef;

    KeyS:=KeyChk;


    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    //PR: 09/02/2012 ABSEXCH-9795
    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoStop) do
    With QtyBreakRec do
    Begin

      Application.ProcessMessages;

      mbRet:=MsgForm.ModalResult;

      Loop_CheckKey(NoStop,mbRet);

      MsgForm.ModalResult:=mbRet;

      Blank(Idr,Sizeof(Idr));

      Idr.Qty:=1;

      With Idr do
      Begin
        Calc_UPriceDisc(TStock,MiscRecs^,TStock.PCurrency,1,NetValue,Discount,DiscountChr,MLocStk,1, QtyBreakRec);

        If (IdDocHed In SalesSplit) then
          UseNDec:=Syss.NoNetDec
        else
          UseNDec:=Syss.NoCosDec;

        DiscP:=Calc_PAmount(Round_Up(NetValue,UseNDec),Discount,DiscountChr);
      end;

      SellP:=Round_Up(Calc_StkCP((Idr.NetValue-DiscP),Stock.SellUnit,Idr.UsePack),Syss.NoNetDec);

      CostP:=Round_Up(FIFO_GetCost(TStock,TStock.PCurrency,1,1,''),Syss.NoCosDec);

      If (SellP<CostP) then
        Warn_DiscLow(CostP,SellP,TStock,
                     ', Qty Break : '+Form_Real(qbQtyFrom,0,Syss.NoQtyDec)+'-'+Form_Real(qbQtyTo,0,Syss.NoQtyDec)
                     ,Tch);

      NoStop:=(Tch<>Esc);

      Status:=Find_Rec(B_Getnext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    MsgForm.Free;

  end; {Proc..}



  { ========= Procedure to scan tree and set discounts ======== }


  Procedure Check_GrpDisc(CSupCode  :   Char;
                          CCode     :   Str10;
                          DiscRec   :   MiscRec;
                          TStock    :   StockRec;
                          LevelKey  :   Str255;
                          MsgForm   :   TForm;
                      Var NoStop    :   Boolean);

  Const
    Fnum     =  StockF;
    Keypath  =  StkCatK;

  Var
    TmpKPath,
    TmpStat
          :  Integer;

    TmpRecAddr
          :  LongInt;

    UseNDec
          :  Byte;

    LFV   :  FileVar;

    LStk  :  StockRec;

    LKey  :  Str255;

    Idr   :  IDetail;

    SellP,
    CostP,
    DiscP :  Real;

    Tch   :  Char;

    mbRet :  TModalResult;


  Begin

    LStk:=Stock;

    Begin

      LKey:=LevelKey;

      LFV:=F[Fnum];

      Status:=Find_Rec(B_GetGEq,LFV,Fnum,RecPtr[Fnum]^,KeyPath,LKey);



      While (StatusOk) and (NoStop) and (CheckKey(LevelKey,LKey,Length(LevelKey),BOn)) do

      With Stock do
      Begin

        TmpKPath:=Keypath;

        TmpStat:=Presrv_BTPos(Fnum,TmpKPath,LFV,TmpRecAddr,BOff,BOff);

        Application.ProcessMessages;

        mbRet:=MsgForm.ModalResult;

        Loop_CheckKey(NoStop,mbRet);

        MsgForm.ModalResult:=mbRet;

        If (StockType=StkGrpCode) then
          Check_GrpDisc(CSupCode,CCode,DiscRec,TStock,Stock.StockCode,MsgForm,NoStop)
        else
        With DiscRec.CustDiscRec do
        Begin

          If (QBType=QBQtyBCode) then //PR: 09/02/2012 Change to use new qty break file ABSEXCH-9795
            Check_QBDisc(CSupCode, FullNomKey(QtyBreakFolio), QtyBreakF, qbFolioIdx, Stock, NoStop, 2)
          else
          Begin

            Blank(Idr,Sizeof(Idr));

            Idr.Qty:=1;

            With Idr do
            Begin
              If (IdDocHed In SalesSplit) then
                UseNDec:=Syss.NoNetDec
              else
                UseNDec:=Syss.NoCosDec;

              Calc_UPriceDisc(Stock,DiscRec,Stock.PCurrency,1,NetValue,Discount,DiscountChr,MLocStk,2, QtyBreakRec); //PR: 09/02/2012 ABSEXCH-9795
              DiscP:=Calc_PAmount(Round_Up(NetValue,UseNDec),Discount,DiscountChr);
            end;

            SellP:=Round_Up(Calc_StkCP((Idr.NetValue-DiscP),Stock.SellUnit,Idr.UsePack),Syss.NoNetDec);


            CostP:=Round_Up(FIFO_GetCost(Stock,Stock.PCurrency,1,1,''),Syss.NoCosDec);

            If (SellP<CostP) then

            If (SellP<CostP) then
              Warn_DiscLow(CostP,SellP,Stock,
                           '',Tch);

            NoAbort:=(TCh<>Esc);

          end;
        end;

        TmpStat:=Presrv_BTPos(Fnum,TmpKPath,LFV,TmpRecAddr,BOn,BOff);

        Status:=Find_Rec(B_GetNext,LFV,Fnum,RecPtr[Fnum]^,KeyPath,LKey);

      end; {While..}
    end; {With..}

    Stock:=LStk;

  end; {Proc..}







  Procedure Check_CDDisc(CSupCode  :  Char;
                         KeyRef    :  Str30;
                         Fnum,
                         Keypath   :  Integer;
                         Mode      :  Byte);



  Var
    TmpKPath,
    TmpStat :  Integer;
    TmpRecAddr
            :  LongInt;

    FoundCode
            :  Str20;
    KeyS,
    KeyChk,
    KeyStk  :  Str255;

    IdR     :  IDetail;

    UseNDec
            :  Byte;

    SellP,
    CostP,
    DiscP   :  Real;

    Tch     :  Char;

    LFV     :  FileVar;

    LOk,
    NoStop  :  Boolean;

    MsgForm :  TForm;

    mbRet   :  TModalResult;


  Begin

    MsgForm:=CreateMessageDialog('Please Wait...'+#13+#13+'Checking Qty Breaks.',mtInformation,[mbAbort]);
    MsgForm.Show;
    MsgForm.Update;


    LFV:=F[Fnum];

    Blank(KeyStk,Sizeof(KeyStk));

    NoStop:=BOn;

    SellP:=0;
    CostP:=0;
    DiscP:=0;

    KeyChk:=FullQDKey(CDDiscCode,CSupCode,KeyRef);


    KeyS:=KeyChk;

    LOk:=BOff;

    Status:=Find_Rec(B_GetGEq,LFV,Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoStop) do
    With MiscRecs^.CustDiscRec do
    Begin

      Application.ProcessMessages;

      mbRet:=MsgForm.ModalResult;

      Loop_CheckKey(NoStop,mbRet);

      MsgForm.ModalResult:=mbRet;

      TmpKPath:=KeyPath;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,LFV,TmpRecAddr,BOff,BOff);

      If (KeyStk<>QStkCode) then
      Begin

        KeyStk:=QStkCode;

        LOk:=GetStock(Application,KeyStk,FoundCode,-1);

      end
      else
        LOk:=BOn;

      If (LOk) then
      Begin
        If (Stock.StockType=StkGrpCode) then
          Check_GrpDisc(CSupCode,Cust.CustCode,MiscRecs^,Stock,KeyStk,MsgForm,NoStop)
        else
          If (QBtype=QBQtyBCode) then //PR: 09/02/2012 Change to use new qty break file ABSEXCH-9795
            Check_QBDisc(CSupCode, FullNomKey(QtyBreakFolio), QtyBreakF, qbFolioIdx, Stock, NoStop, Mode)
          else
          Begin
            Blank(Idr,Sizeof(Idr));

            Idr.Qty:=1;

            With Idr do
            Begin
              If (IdDocHed In SalesSplit) then
                UseNDec:=Syss.NoNetDec
              else
                UseNDec:=Syss.NoCosDec;


              Calc_UPriceDisc(Stock,MiscRecs^,Stock.PCurrency,1,NetValue,Discount,DiscountChr,MLocStk,Mode, QtyBreakRec);
              DiscP:=Calc_PAmount(Round_Up(NetValue,UseNDec),Discount,DiscountChr);
            end;

            SellP:=Round_Up(Calc_StkCP((Idr.NetValue-DiscP),Stock.SellUnit,IdR.UsePack),Syss.NoNetDec);

            CostP:=Round_Up(FIFO_GetCost(Stock,Stock.PCurrency,1,1,''),Syss.NoCosDec);

            If (SellP<CostP) then
              Warn_DiscLow(CostP,SellP,Stock,
                     '',Tch);

            NoStop:=(Tch<>Esc);

          end;

      end; {If Ok..}

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,LFV,TmpRecAddr,BOn,BOff);

      Status:=Find_Rec(B_Getnext,LFV,Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    MsgForm.Free;

  end; {Proc..}



  { ========== Procedure to Rename from one folio to another ======== }
  //PR: 09/02/2012 I've been unable to discover anywhere that this function is used, so have commented it out rather than
  //amending it for the new Qty Break file (ABSEXCH-9795). This will give a compiler error if anything tries to use it, at
  //which point we can amend it if necessary.
(*  Procedure CD_RenumbDisc(CSupCode  :  Char;
                          OldCode,
                          NewCode   :  Str10);


  Const
    Fnum      =  MiscF;
    Keypath   =  MIK;


  Var
    KeyS,KeyChk  :  Str255;

    Loop         :  Boolean;


  Begin

    Loop:=BOff;

    Repeat

      If (Not Loop) then
        KeyChk:=FullQDKey(QBDiscCode,CSupCode,FullCustCode(OldCode))
      else
        KeyChk:=FullQDKey(CDDiscCode,CSupCode,FullCustCode(OldCode));


      KeyS:=KeyChk;


      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With MiscRecs^ do
      Begin


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

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);

        If (StatusOk) then
          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

      Loop:=Not Loop;

    Until (Not Loop);

  end; {Proc..}
*)
{$ENDIF}











end.