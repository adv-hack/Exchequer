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


{$IFDEF SOPDLL}
  {$DEFINE SOP}
{$ENDIF}

Procedure Re_CalcDocPrice(Mode  :  Byte;
                      Var LInv  :  InvRec;
                            Const ResetECServiceFlag : Boolean = False;
                            Const ResetNetValueForInclusiveVAT : Boolean = False);

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



Procedure CD_RenumbDisc(CSupCode  :  Char;
                        OldCode,
                        NewCode   :  Str10);


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Controls,
   Forms,
   Dialogs,
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

     InvFSU3U,

   {.$ENDIF}

   {$IFDEF SOP}
     EXWrap1U,
   {$ENDIF}

   InvCT2SU,

   {$IFDEF STK}
     FIFOL2U,
     InvCTSUU,
   {$ENDIF}

   DiscU3U,
   BTSupU1,
   Warn1U;




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

    {$IFDEF SOP}
      ExLocal
            :  TdExlocal;

    {$ENDIF}


  Begin

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

    {$IFDEF SOP}
      ExLocal.Create;

      ExLocal.LInv:=LInv;


    {$ENDIF}

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Id.LineNo<>RecieptCode) do
    With Id do
    Begin
      ExLocal.LastId:=Id;
      {$B-}

      If (Is_OwnLine(Id)) and ((Is_FullStkCode(StockCode)) or (Mode<>0)) then

      {$B+}

      Begin

        KeyStk:=StockCode;

        If (Is_FullStkCode(StockCode)) then
          GotStk:=GetStock(Application,KeyStk,FoundCode,-1)
        else
        Begin
          GotStk:=BOn;
          Blank(Stock,Sizeof(Stock));
          Stock.VATCode:=VATSTdCode;
        end;


        If (GotStk) then
        Begin

          UpdateRecBal(Id,LInv,BOn,BOff,1);

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

          If (Is_FullStkCode(StockCode)) then
            Calc_StockPrice(Stock,Cust,LInv.Currency,Qty,LInv.TransDate, NetValue,Discount,DiscountChr,MLocStk,Flg,Mode);


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


          UpdateRecBal(Id,LInv,BOff,BOff,1);

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          Report_BError(Fnum,Status);

        end;

      end; {If Got Stock..}

      If (StatusOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    {$IFDEF SOP}
      ExLocal.Destroy;

    {$ENDIF}


    If (Mode In [0,10,11]) then
      MsgForm.Free;

  end; {Proc..}



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

  Case Mode of

    1  :  KeyChk:=FullQDKey(QBDiscCode,QBDiscSub,KeyRef);
    2  :  KeyChk:=FullQDKey(QBDiscCode,CSupCode,KeyRef);

  end;


  KeyS:=KeyChk;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoStop) do
  With MiscRecs^.QtyDiscRec do
  Begin

    Application.ProcessMessages;

    mbRet:=MsgForm.ModalResult;

    Loop_CheckKey(NoStop,mbRet);

    MsgForm.ModalResult:=mbRet;

    Blank(Idr,Sizeof(Idr));

    Idr.Qty:=1;

    With Idr do
    Begin
      Calc_UPriceDisc(TStock,MiscRecs^,TStock.PCurrency,1,NetValue,Discount,DiscountChr,MLocStk,1);

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
                   ', Qty Break : '+Form_Real(FQB,0,Syss.NoQtyDec)+'-'+Form_Real(TQB,0,Syss.NoQtyDec)
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

        If (QBType=QBQtyBCode) then
          Check_QBDisc(CSupCode,FullCDKey(CCode,TStock.StockFolio),MiscF,MIK,Stock,NoStop,2)
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

            Calc_UPriceDisc(Stock,DiscRec,Stock.PCurrency,1,NetValue,Discount,DiscountChr,MLocStk,2);
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
        If (QBtype=QBQtyBCode) then
          Check_QBDisc(CSupCode,FullCDKey(KeyRef,Stock.StockFolio),MiscF,MIK,Stock,NoStop,Mode)
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


            Calc_UPriceDisc(Stock,MiscRecs^,Stock.PCurrency,1,NetValue,Discount,DiscountChr,MLocStk,Mode);
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

Procedure CD_RenumbDisc(CSupCode  :  Char;
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



{$IFDEF SOPDLL}
  {$UNDEF SOP}
{$ENDIF}










end. {Unit..}