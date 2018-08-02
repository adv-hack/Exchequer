Unit CuStkT3U;

{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 17/06/98                      }
{                                                              }
{                Account/Stock Analysis Document Generator     }
{                                                              }
{               Copyright (C) 1998 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     VarRec2U
     {$IFDEF SOP}
       , TTD
     {$ENDIF}
     ;

Type
  enumTelesalesOptions = (
                            // Display the Order Payments Take Payment dialog when saving the SOR
                            tsoOrderPaymentsOfferPayment = 1
                         );
  TelesalesOptionsSet  =  Set Of enumTelesalesOptions;


  // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added Generate Order with Payment option
  Procedure Gen_TeleSalesDoc(      TSDocType        : DocTypes;
                             Var   TeleSHed         : MLocPtr;
                             {$IFDEF SOP}
                             Const AdvDiscHelper    : TTTDTelesaleHelper;
                             {$ENDIF}
                                   KeyChk           : Str255;
                                   KeyPath3         : Integer;
                             Const TelesalesOptions : TelesalesOptionsSet);


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   Dialogs,
   Controls,
   ETStrU,
   ETDateU,
   ETMiscU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   CurrncyU,
   ExWrap1U,
   MiscU,
   SysU1,
   SysU2,

   {$IFDEF SOP}
     SysU3,
   {$ENDIF}


   InvCt2Su,
   InvCTSuU,
   Saltxl2U,
   StkROCtl,
   CuStkA3U,
   CuStkA4U,
   CuStkA5U,
   Tranl1U,
   BTSupU1,
   ExThrd2U,
   InvListU,
   InvLst2U,
   Warn1U,
   InvFSU2U,
   {$IFDEF SOP}
    MBDTeleSales, //PR: 30/04/2009
    SysUtils,
   {$ENDIF}
   BTKeys1U,

   // MH 20/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
   TransactionHelperU;
   {InvListU;}





  { ==== Procedure to Add any additional description lines to Doc ==== }

  Procedure ckAuto_AddDesc(Fnum,
                           Keypath  :  Integer;
                           CS       :  CuStkType;
                           TeleSHed :  MLocPtr);

  Var
    CalcLines,
    n           :  Byte;

    FoundOk     :  Boolean;



  Begin

    CalcLines:=MaxStkDescs;

    FoundOk:=BOff;

    With CS do
    Begin
      Repeat

        FoundOk:=(Not EmptyKey(csDesc[CalcLines],StkDesKLen));

        If (Not FoundOk) then
          Dec(CalcLines);

      Until (FoundOk) or (CalcLines=1);


      If (FoundOk) then
        For n:=2 to CalcLines do
        With Id do
        Begin
          ResetRec(Fnum);

          FolioRef:=Inv.FolioNum;

          IdDocHed:=Inv.InvDocHed;

          PDate:=TeleSHed^.TeleSRec.tcTDate;

          CustCode:=Inv.CustCode;

          Desc:=CS.csDesc[n];

          LineNo:=Inv.ILineCount;

          ABSLineNo:=LineNo;

          LineType:=StkLineType[IdDocHed];

          Currency:=Inv.Currency;

          CXRate:=Inv.CXRate;

          CurrTriR:=Inv.CurrTriR;

          PYr:=Inv.ACYr;
          PPr:=Inv.AcPr;

          Payment:=DocPayType[IdDocHed];

          KitLink:=csStkFolio;

          Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          Inc(Inv.ILineCount);

        end; {Loop..}
      end; {With..}

  end; {Proc..}


// MH 03/06/2015 2015-R1 ABSEXCH-16482: Added Generate Order with Payment option
procedure Display_TSTrans(      Mode             : Byte;
                                DispTransPtr     : Pointer;
                          Const TelesalesOptions : TelesalesOptionsSet);

Var
  DispTrans  :  TFInvDisplay;
  DisplayOptions : TransactionDisplayOptionsSet;
Begin

  If (DispTransPtr=nil) then
  Begin
    DispTrans:=TFInvDisplay.Create(Application.MainForm);
    DispTransPtr:=DispTrans;
  end
  else
    DispTrans:=DispTransPtr;

    try


      With DispTrans do
      Begin
        LastDocHed:=Inv.InvDocHed;

        ForcePrint:=BOn;

        // MH 03/06/2015 2015-R1 ABSEXCH-16482: Pass flag through to Edit SOR window to add
        // offer of taking a payment
        DisplayOptions := [];
        If (Inv.thOrderPaymentElement = opeOrder) And (tsoOrderPaymentsOfferPayment In TelesalesOptions) Then
          DisplayOptions := DisplayOptions + [OrderPayments_OfferPayment];

        Display_Trans(Mode,Inv.FolioNum,BOff,(Mode<>100), DisplayOptions);

      end; {with..}

    except

      DispTrans.Free;

    end;

end;


  { =========== Procedure to Generate automatic Purchase Orders ========= }



  // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added Generate Order with Payment option
  Procedure Gen_TeleSalesDoc(      TSDocType        : DocTypes;
                             Var   TeleSHed         : MLocPtr;
                             {$IFDEF SOP}
                             Const AdvDiscHelper    : TTTDTelesaleHelper;
                             {$ENDIF}
                                   KeyChk           : Str255;
                                   KeyPath3         : Integer;
                             Const TelesalesOptions : TelesalesOptionsSet);
  Const
    Fnum       =  InvF;
    Keypath    =  InvRNoK;


    Fnum2      =  IdetailF;

    Keypath2   =  IdFolioK;


    Fnum3      =  MLocF;


  Var
    KeyS       :  Str255;

    LOk,
    Locked,
    Ok2Go,
    AddDLines,
    Ignore     :  Boolean;

    B_Func     :  Integer;


    TmpStat    :  Integer;

    LAddr,
    TmpRecAddr
               :  LongInt;

    FoundCode  :  Str20;


    ExLocal    :  TdExLocal;


    CS         :  CuStkType;

    OInv,
    TmpInv,
    TInv       :  InvRec;

    MsgForm    :  TForm;

    mbRet      :  TModalResult;


    DispTransPtr
               :  Pointer;

    {$IFDEF SOP}
    bApplyMultiBuyDiscounts : Boolean;
    mbIDR : IDetail;
    {$ENDIF}
  { == Proc to process each unfinished TS transaction == }

  Procedure ProcessOneTSInv;
  Begin
    With TeleSHed^,TeleSRec,Inv do
    Begin
      Set_BackThreadMVisible(BOn);

      MsgForm:=CreateMessageDialog('Please wait... creating '+OurRef,mtInformation,[mbAbort]);
      MsgForm.Show;
      MsgForm.Update;

      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);


      If (LOk) and (Locked) then
      Begin
        If (OurRef=TInv.OurRef) and (tcLineCount>0) then
        Begin
          Inv:=TInv; {* Replace with updated copy *}
        end;

        If (InvDocHed In OrderSet) then
          RunNo:=OrdUSRunNo
        else
          RunNo:=0;

        B_Func:=B_GetGEq;

        CalcInvTotals(Inv,ExLocal,BOn,BOn); {* Calculate Invoice Total *}

        {$IFDEF SOP}
          // Advanced Discounts - Apply TTD/VBD
          If Assigned(AdvDiscHelper) Then
          Begin
            // Perform transaction type checks
            AdvDiscHelper.ScanTransaction(Inv);

            If AdvDiscHelper.Enabled Then
              AdvDiscHelper.OfferTTD (Inv);
          End; // If Assigned(AdvDiscHelper)
        {$ENDIF}

        If (InvDocHed=SIN) then
          Set_DocAlcStat(Inv);  {* Set Allocation Status *}

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);


        {* Display transaction here *}


        If (StatusOk) then {* Update committed balance *}
        Begin
          If (Not (Inv.InvDocHed In QuotesSet+PSOPSet)) and (Not Syss.UpBalOnPost) and (Inv.NomAuto) then
            UpdateCustBal(OInv,Inv)
          else
            UpdateCustOrdBal(OInv,Inv);
        end;


         {*Leave as nil, so new window is created each time *}

         MsgForm.Free;

         Set_BackThreadMVisible(BOff);

         // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added Generate Order with Payment option
         Display_TSTrans(2, DispTransPtr, TelesalesOptions);
      end;
    end; {If not your own}


  end; {Proc..}

  // CJS 2016-01-26 - ABSEXCH-17201 - Pick up "Default QR Code" flag from Trader Record
  // See also TTxLine.SetDefaultIntrastatDetails in TxLineU.pas, as these two
  // routines should be kept in sync (although they are not similar enough to
  // move into a common routine).
  procedure SetDefaultIntrastatDetails;
  var
    FoundCode: Str20;
  begin
    // Retrieve the Trader record
    If (Cust.CustCode <> Id.CustCode) then
      GetCust(nil, Id.CustCode, FoundCode, IsACust(Cust.CustSupp), -1);

    if Cust.EECMember and Cust.acDefaultToQR and (Inv.InvDocHed in SalesSplit) then
    begin
      Id.SSDUseLine := True;
      Id.SSDCountry := 'QR';
      Id.tlIntrastatNoTc := Format('%2d', [Inv.TransNat]);
    end;
  end;

  Begin

    ExLocal.Create;

    //PR: 30/04/2009 Create Multi-Buy Discount form
    {$IFDEF SOP}
     frmTeleSalesMultiBuy := TfrmTeleSalesMultiBuy.Create(nil);
     frmTeleSalesMultiBuy.SearchString := KeyChk;
     frmTeleSalesMultiBuy.CustomerCode := TeleSHed^.TeleSRec.tcCustCode;
     frmTeleSalesMultiBuy.Currency := TeleSHed^.TeleSRec.tcCurr;
     frmTeleSalesMultiBuy.DocType := DocTypes(TeleSHed^.TeleSRec.tcDoctype);
     frmTeleSalesMultiBuy.TransDate := TeleSHed^.TeleSRec.tcTDate;
     frmTeleSalesMultiBuy.ExLocal := @ExLocal;
     bApplyMultiBuyDiscounts := frmTeleSalesMultiBuy.Execute;
    {$ENDIF}

    Ignore:=BOff;

    AddDLines:=BOff;

    KeyS:=KeyChk;

    Blank(TInv,Sizeof(TInv));

    Ok2Go:=BOn;

    OInv:=TInv;

    TmpInv:=TInv;

    DispTransPtr:=nil;

    With TeleSHed^,TeleSRec do
    Begin


      If (tcLineCount>0) then
      Begin
        Set_BackThreadMVisible(BOn);

        MsgForm:=CreateMessageDialog('Please wait... Generating '+DocNames[TSDocType],mtInformation,[mbAbort]);
        MsgForm.Show;
        MsgForm.Update;

        Gen_InvHed(tcCustCode,OrdTSRunNo,tcTDate,tcCurr,Ignore,4);

        If (Not Ignore) then
        Begin
          If (Cust.CustCode<>tcCustCode) then
            Global_GetMainRec(CustF,tcCustCode);

          With Inv do
          Begin

            TH2Inv(Inv,TeleSRec,BOff);

            InvDocHed:=TSDocType;

            CustSupp:=TradeCode[BOn];

            // MH 20/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
            If TransactionHelper(@Inv).SettlementDiscountSupported Then
              DiscDays:=Cust.DefSetDDays
            // MH 17/06/2015 v7.0.14 ABSEXCH-16561: Added PPD Support
            Else If (Cust.acPPDMode <> pmPPDDisabled) Then
            Begin
              thPPDPercentage := Pcnt(Cust.DefSetDisc);
              thPPDDays       := Cust.DefSetDDays;
            End; // If (Cust.acPPDMode <> pmPPDDisabled)

            // MH 03/06/3015 2015-R1 ABSEXCH-16482: Enable Order Payments on Orders created through Telesales
            If (Inv.InvDocHed = SOR) And Cust.acAllowOrderPayments Then
              Inv.thOrderPaymentElement := opeOrder;

            If (InvDocHed In OrderSet) then {* Set a separator in ledger *}
            Begin
              CustSupp:=Chr(Succ(Ord(CustSupp)));
              BatchLink:=QUO_DelDate(InvDocHed,DueDate);
            end
            else
              If (InvDocHed=SIN) then
              Begin
                DueDate:=CalcDueDate(TransDate,Cust.PayTerms);

              end;

          end; {With..}

          SetNextDocNos(Inv,BOn);

          Store_InvHed(4);


          Status:=Find_Rec(B_GetGEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,KeyPath3,KeyS);

          While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
          With CS do
          Begin
            mbRet:=MsgForm.ModalResult;

            Loop_CheckKey(Ok2Go,mbRet);

            MsgForm.ModalResult:=mbRet;

            Application.ProcessMessages;


            CS:=MLocCtrl^.CuStkRec;

            If (csEntered) then {Process this one}
            Begin

              TmpStat:=Presrv_BTPos(Fnum3,KeyPath3,F[Fnum3],TmpRecAddr,BOff,BOff);

              LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath3,Fnum3,BOn,Locked,LAddr);

              If (LOk) and (Locked) then
              Begin

                With Id do
                Begin

                  If (Stock.StockCode<>csStockCode) then
                    GetStock(Application.MainForm,csStockCode,FoundCode,-1);

                  TL2Id(Id,CS);
                  {$IFDEF SOP}
                  if bApplyMultiBuyDiscounts then
                    frmTeleSalesMultiBuy.SetLineMultiBuyDiscount(Id);
                  {$ENDIF}

                  FolioRef:=Inv.FolioNum;

                  IdDocHed:=Inv.InvDocHed;

                  If (IdDocHed In OrderSet) then
                    PDate:=tcDelDate
                  else
                    PDate:=tcTDate;

                  LineNo:=Inv.ILineCount;

                  ABSLineNo:=LineNo;

                  LineType:=StkLineType[IdDocHed];

                  Currency:=Inv.Currency;

                  CXRate:=Inv.CXRate;

                  CurrTriR:=Inv.CurrTriR;

                  PYr:=Inv.ACYr;
                  PPr:=Inv.AcPr;

                  Payment:=DocPayType[IdDocHed];

                  If (Syss.AutoClearPay) then
                    Reconcile:=ReconC;

                  LWeight:=Stock.SWeight;


                  {$IFDEF SOP}
                    Set_StkCommod(Id,Stock);
                  {$ENDIF}

                  // CJS 2016-01-26 - ABSEXCH-17201 - Pick up "Default QR Code" flag from Trader Record
                  if Syss.Intrastat then
                    SetDefaultIntrastatDetails;

                  {* Reset ck record *}

                  csQty:=0.0;

                  csEntered:=BOff;

                  MLocCtrl^.CuStkRec:=CS;

                  Status:=Put_Rec(F[Fnum3],Fnum3,RecPtr[Fnum3]^,KeyPath3);

                  Report_BError(Fnum3,Status);

                  Status:=UnLockMultiSing(F[Fnum3],Fnum3,LAddr);


                  Deduct_AdjStk(Id,Inv,BOn);

                  If (IdDocHed=SIN) then
                    Control_SNos(Id,Inv,Stock,1,Application.MainForm);


                  If ((Stock.StockType=StkBillCode) and (Stock.ShowAsKit)) then
                  Begin
                    {Link_StockCtrl(Id,Inv,Cust,LineNo,0,0,Qty*QtyMul,98,BOff,nil);}
                    TmpInv:=Inv;

                    Link_StockCtrl(Id,TmpInv,Cust,LineNo,0,0,Qty*QtyMul,98,BOff,nil);

                    Inv:=TmpInv;

                    AddDLines:=BOff;
                  end
                  else
                  Begin

                    AddDLines:=BOn;

                  end;


                  Status:=Add_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

                  {$IFDEF SOP}
                  if bApplyMultiBuyDiscounts then
                    mbIDR := Id; //Keep copy of stock line for multiBuy in case there are any desc lines
                  {$ENDIF}

                  Report_BError(Fnum2,Status);

                  Inv.ILineCount:=Inv.ILineCount+2;

                  If (JbCostOn) and (DetLTotal(Id,BOn,BOff,0.0)<>0) and (KitLink=0)
                    and ((Id.LineNo<>RecieptCode) or (Not (Id.IdDocHed In PurchSet))) then
                    Update_JobAct(Id,Inv);


                  Stock_AddCustAnal(Id,BOn,0);

                  {* Auto add any extra desc lines *}

                  If (AddDLines) then
                    ckAuto_AddDesc(Fnum2,Keypath2,CS,TeleSHed);

                  {$IFDEF SOP}
                  if bApplyMultiBuyDiscounts then
                    frmTeleSalesMultiBuy.AddMultiBuyDiscountLines(Inv, mbIdr, Stock);
                  {$ENDIF}

                end;

              end; {If Locked..}

              TmpStat:=Presrv_BTPos(Fnum3,KeyPath3,F[Fnum3],TmpRecAddr,BOn,BOff);

            end; {If Not Tagged..}

            Status:=Find_Rec(B_GetNext,F[Fnum3],Fnum3,RecPtr[Fnum3]^,KeyPath3,KeyS);

          end; {While..}

          TInv:=Inv;
        end; {If header no good}

        MsgForm.Free;

        Set_BackThreadMVisible(BOff);

        {* Lets find this one first, then mop op! V4.31.005 *}
        {V5, was using check rec, but ProcessOneTSInv uses get direct, hence failing occasionaly}
        If (Global_GetMainRecPos(InvF,InvOurRefK,TInv.OurRef)) then
          ProcessOneTSInv;

      end; {If Any to process}

      
      KeyChk:=FullNomKey(OrdTSRunNo); {* Pick up any strays!*}

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With Inv do
      Begin
        B_Func:=B_GetNext;

        Application.ProcessMessages;

        {* Only recover if your own, or login not used, and it only has one line set *}

        If (OpName=TcLastOpo) or ((TcLastOpo='') and (OpName='') and (ILineCount=1)) then
          ProcessOneTSInv;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end;

      {== reset header ==}

      tcLineCount:=0;

      tcNetTotal:=0.0;
      tcVATTotal:=0.0;
      tcDiscTotal:=0.0;
      tcInProg:=BOff;


    end; {With..}


    ExLocal.Destroy;

    {$IFDEF SOP}
    if Assigned(frmTeleSalesMultiBuy) then
      FreeAndNil(frmTeleSalesMultiBuy);
    {$ENDIF}
  end; {Proc..}






end.
