Unit StkROCtl;


{$I DEFOVR.INC}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/01/94                      }
{                                                              }
{            Stock Re-Order & Take List Support Unit           }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}





Interface

Uses SysUtils,  
     GlobVar,
     VarSortV,
     VarRec2U,
     VarConst,
     Forms,
     StkLstU;


Procedure Gen_InvHed(CCode  :  Str30;
                       RNo    :  LongInt;
                       TDate  :  LongDate;
                       RCr    :  Byte;
                   Var Ignore :  Boolean;
                       Mode   :  Byte);

Procedure Store_InvHed(Mode  :  Byte);


{$IFDEF SOP}
// PKR. 11/12/2015. ABSEXCH-15333.  Added reorder mode.
Procedure Generate_POR(KeyChk  :  Str255;
                         StkGrp  :  Str20;
                         StkFilt :  Str10;
                         UseGLoc :  Boolean;
                         MsgForm :  TForm;
                         aReorderMode : TReorderModes;
                         aSortViewEnabled : Boolean);

{$ENDIF}


Procedure Generate_Adj(StkFilt :  Str10);


{$IFDEF SOP}
  Procedure Generate_LocTxfrAdj(LocFilt  :  Str10);
{$ENDIF}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETDateU,
   ETMiscU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   SysU1,
   SysU2,
   SysU3,
   InvCt2Su,
   InvCTSuU,

   CurrncyU,

   {$IFDEF Frm}
     PrintFrm,
     FrmThrdU,
   {$ENDIF}

   MiscU,

   {StockLBU,
   StkSup3U,}
   BTSupU1,
   BTSupU3,
   BTKeys1U,
   ExThrd2U,
   ExWrap1U,
   Warn1U,
   SCRTCH2U,
   InvListU,

   {$IFDEF SOP}
     InvLst3U,
     MLocMRIU,

   {$ENDIF}

   InvFSU2U,
   FIFOl2U,
   WinTypes,
   Messages,
   Classes,
   Controls,
   StdCtrls,
   Dialogs,
   ExBtTh1U,
   PayF2U,
   Saltxl2U,

   {$IFDEF Pf_On}
     CuStkA3U,

   {$ENDIF}
   PassWR2U,

   ReValueU,
   ReValU2U,
   Event1U,
   AuditNotes,

   RPDevice,

   { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
   TransactionOriginator

   {$IFDEF SOPDLL}
   ,AuditNoteIntf //PR: 02/11/2011 v6.9 Audit Note handling for conversion dll
   {$ENDIF}
   ;



  { =================== Message to Warn Reciept Part to be entered manually ============== }

  Procedure Warn_SupNotFound(SupRef  :  Str10);



  Begin

    ShowMessage('- WARNING! - '+#13+#13+
                'Supplier: '+SupRef+' cannot be found!'+#13+
                'Orders for this Supplier will be ignored');
  end;



  { ========= Procedure to Generate a Document Header ======= }

  Procedure Gen_InvHed(CCode  :  Str30;
                       RNo    :  LongInt;
                       TDate  :  LongDate;
                       RCr    :  Byte;
                   Var Ignore :  Boolean;
                       Mode   :  Byte);




  Const
    Fnum     =  InvF;
    Keypath  =  InvOurRefK;




  Var
    FoundOk    :  Boolean;
    FoundCode  :  Str20;

    KeyC       :  Str255;




  Begin

    Ignore:=BOff;

    If (Mode=0) then
    Begin
      FoundOk:=GetCust(Application.MainForm,CCode,FoundCode,BOff,-1);
    end;

    If (Mode<>0) or (FoundOk) then
    With Inv do
    Begin

      ResetRec(Fnum);

      NomAuto:=BOn;

      TransDate:=TDate; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,nil);

      DueDate:=TransDate;

      ILineCount:=1;

      NLineCount:=1;

      RunNo:=RNo;



    {$IFDEF MC_On}

      Currency:=RCr;

      CXrate[BOn]:=SyssCurr.Currencies[Currency].CRates[BOn];

    {$ELSE}

      Currency:=0;

      CXrate:=SyssCurr.Currencies[Currency].CRates;


    {$ENDIF}


      VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

      OrigRates:=SyssCurr.Currencies[Currency].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);
      SetTriRec(Syss.VATCurr,UseORate,VATTriR);
      SetTriRec(Currency,UseORate,OrigTriR);


      OpName:=EntryRec^.LogIn;

      { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
      TransactionOriginator.SetOriginator(Inv);

      Case Mode of
        0  :  Begin
                InvDocHed:=POR;

                CustCode:=Cust.CustCode;

                CustSupp:=Cust.CustSupp;

                If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
                  CustSupp:=Chr(Succ(Ord(CustSupp)));


                DAddr:=Cust.DAddr;

                // MH 10/06/2015 2015-R1 ABSEXCH-16533: Added support for Delivery Postcode/Country
                thDeliveryPostCode := Cust.acDeliveryPostCode;
                thDeliveryCountry := Cust.acDeliveryCountry;

                {If (DAddr[1]='') and (DAddr[2]='') then * Removed 05/07/94
                Begin

                  DAddr:=Syss.DetailAddr;

                end;}

                DelTerms:=Cust.SSDDelTerms;
                TransMode:=Cust.SSDModeTr;

                TransNat:=SetTransNat(InvDocHed);

                If (Cust.DefTagNo>0) then
                  Tagged:=Cust.DefTagNo;

                If (TransMode=0) then
                  TransMode:=1;

                {*v5.52 Set ctrl nom from supplier record *}
                CtrlNom:=Cust.DefCtrlNom;

                // MH 10/06/2015 v7.0.14 ABSEXCH-16523: PPD Percentage/Days not set
                thPPDPercentage := Pcnt(Cust.DefSetDisc);
                thPPDDays       := Cust.DefSetDDays;
              end;

        1,2
           :  Begin

                InvDocHed:=ADJ;

                TransDesc:=CCode;

              end;

        4  :  ;  {* Reserved for TeleSales *}

      end; {Case..}

      If (Mode<>4) then
        SetNextDocNos(Inv,BOn);

    end
    else
    Begin

      Ignore:=BOn;

      Warn_SupNotFound(CCode);

    end;

  end; {Proc..}



  { ============ Store Header ============ }

  Procedure Store_InvHed(Mode  :  Byte);

  Const

    Fnum     =  InvF;

    Keypath  =  InvOurRefK;

    Fnum2    =  StockF;

    Keypath2 =  StkMinK;


  Var
    UOR      :  Byte;
    RecAddr  :  LongInt;
    ExLocal  :  TdExLocal;
  Begin
    UOR:=0;

    If (Mode=0) then
    Begin
      Status:=GetPos(F[Fnum2],Fnum2,RecAddr);   {* Preserve Prod Position *}

      If (StatusOk) then
      Begin

        ExLocal.Create;

        CalcInvTotals(Inv,ExLocal,BOn,BOn); {* Calculate Invoice Total *}

        ExLocal.Destroy;

        SetDataRecOfs(Fnum2,RecAddr);

        Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);

      end;

      Inv.BatchLink:=QUO_DelDate(Inv.InvDocHed,Inv.DueDate);

    end;


    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

    {$IFNDEF SOPDLL}
    //PR: 12/01/2012 ABSEXCH-12385 Changed to use GS's class procedure, removing need to create and free audit note object here.
    if(status = 0) then
      TAuditNote.WriteAuditNote(anTransaction, anCreate);
    {$ELSE}
     //PR: 02/11/2011 v6.9 Add audit note when creating transaction - separate handling in Conversion DLL
    if status = 0 then
      AuditNoteIntf.AuditNote.AddNote(anTransaction, Inv.FolioNum, anCreate);
    {$ENDIF}

    Report_BError(Fnum,Status);

    With Inv do
      If (StatusOk) and (InvDocHed In PSOPSet) then {* Update O/S Order balance *}
      Begin
        UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

        UpdateOrdBal(Inv,(Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                          DocCnst[InvDocHed]*DocNotCnst),
                     0,0,
                     BOff,0);
      end;

  end;


  { ==== Procedure to Add any additional description lines to Order ==== }

  Procedure Auto_AddDesc(Fnum,
                         Keypath  :  Integer;
                         SFilt    :  Str10);

  Var
    CalcLines,
    n           :  Byte;

    FoundOk     :  Boolean;



  Begin

    CalcLines:=MaxStkDescs;

    FoundOk:=BOff;

    With Stock do
      Repeat

        FoundOk:=(Not EmptyKey(Desc[CalcLines],StkDeskLen));

        If (Not FoundOk) then
          Dec(CalcLines);

      Until (FoundOk) or (CalcLines=1);

                         
    If (FoundOk) then
      For n:=2 to CalcLines do
      With Id do
      Begin
        ResetRec(Fnum);

        FolioRef:=Inv.FolioNum;

        DocPRef:=Inv.OurRef;

        IdDocHed:=Inv.InvDocHed;

        PDate:=Stock.RODate;

        If (PDate='') or (Length(PDate)<>8) then
          PDate:=Inv.DueDate;

        CustCode:=Inv.CustCode;

        Desc:=Stock.Desc[n];

        LineNo:=Inv.ILineCount;

        ABSLineNo:=LineNo;

        LineType:=StkLineType[IdDocHed];

        Currency:=Inv.Currency;

        CXRate:=Inv.CXRate;

        CurrTriR:=Inv.CurrTriR;

        PYr:=Inv.ACYr;
        PPr:=Inv.AcPr;

        Payment:=DocPayType[IdDocHed];

        KitLink:=Stock.StockFolio;

        MLocStk:=SFilt;

        Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        Inc(Inv.ILineCount);

      end; {Loop..}

  end; {Proc..}


{SS 11/04/2016 2016-R2
 ABSEXCH-17374:Auto-set before sort view and after sort view. Only sorted stock listed should generate POR.
 - Prepare a Stringlist of the Sorted srock list.}

Procedure MakeSortedStockList(aStockList : TStringList);
 Var
    KeyS  :  Str255;
    lStatus : Integer;
    KeyPath : Integer;
begin
  KeyPath := 1;
  KeyS  := EmptyStr;
  aStockList.Clear;
  lStatus := Find_Rec(B_GetGEq,F[SortTempF],SortTempF,RecPtr[SortTempF]^,KeyPath,KeyS);
  while lStatus = 0 do
  begin
    aStockList.Add(Trim(SortTempRec.svtSourceDataStr));

    lStatus:=Find_Rec(B_GetNext,F[SortTempF],SortTempF,RecPtr[SortTempF]^,KeyPath,KeyS);
  end;                                           
end;


{$IFDEF SOP}

  { =========== Procedure to Generate automatic Purchase Orders ========= }

{SS 11/04/2016 2016-R2
 ABSEXCH-17374:Auto-set before sort view and after sort view. Only sorted stock listed should generate POR.
 - Added a paramater to check the operation is applied on sorted stock list or not.}

// PKR. 11/12/2015. ABSEXCH-15333.  Added reorder mode.
  Procedure Generate_POR(KeyChk  :  Str255;
                         StkGrp  :  Str20;
                         StkFilt :  Str10;
                         UseGLoc :  Boolean;
                         MsgForm :  TForm;
                         aReorderMode : TReorderModes;
                         aSortViewEnabled : Boolean);



  Const
    Fnum      =  IdetailF;

    Keypath   =  IdFolioK;


    Fnum2     =  StockF;

    Keypath2  =  StkMinK;



  Var
    KeyS       :  Str255;

    LastSupp   :  Str10;

    LastCurr   :  Byte;

    LFiltSet,
    Ok2Print,
    GotSome,
    Ok2Go,
    LOk,
    Locked,
    AddDLines,
    HeaderReq,
    Ignore     :  Boolean;

    TmpFVar    :  FileVar;

    LAddr,
    RecAddr    :  LongInt;

    B_Func     :  Integer;

    {MsgForm    :  TForm;}

    mbRet      :  TModalResult;

    MTExLocal  :  tdPostExLocalPtr;

    ThisScrt   :  Scratch2Ptr;

    FormRepPtr :  PFormRepPtr;
    lStockList : TStringList;
    lValidlineItem : Boolean;

  Begin

    LastSupp:='';

    Ignore:=BOff;

    HeaderReq:=BOff;

    LastCurr:=0;

    LFiltSet:=Not EmptyKey(StkFilt,LocKeyLen);

    KeyS:=KeyChk;

    GotSome:=BOff;

    Ok2Go:=BOn;

    ThisScrt:=nil;

    New(FormRepPtr);

    FillChar(FormRepPtr^,Sizeof(FormRepPtr^),0);

    lStockList := TStringList.Create;
    try
      // PKR. 11/12/2015. ABSEXCH-15333. Added reorder mode.
      // If create only, don't display the Print Setup dialog.
      if (aReorderMode <> rmCreateOnly) then
      begin
        With FormRepPtr^,PParam do
        Begin
          PBatch:=BOn;
          RForm:=SyssForms.FormDefs.PrimaryForm[25];

          {$IFDEF Frm}
            // PKR. 11/12/2015. ABSEXCH-15333.
            // We now have the option to print or use supplier defaults.
            // If it's print only, we need to disable the email, fax and xml tabs.
            // This can be done using TSBSPrintSetupInfo.feTypes flags.
            // feTypes : LongInt; { Flag: 2=Allow Fax, 4=AllowEmail, 8=AllowXML, 16=AllowExcel, 32=HTML }
            //   feType_Printer = 1; feType_Fax = 2; feType_Email = 4;
            //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            // NB: It appears that "he who shall not be named" got the bit values the wrong way round.
            // He used true to mean hide the tab.
            //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            PDevRec.feTypes := 63; // Hide all tabs except Printer.

            // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
            // Added UseEmailList parameter - default=true - set to false in this case.
            // It will always be false.  It's only ever used when emailing, and we now
            //  get email addresses from the Trader record or their Contacts/Roles records.

            // PKR. 11/02/2016. ABSEXCH-17279. Re-introduce print-to-screen option for Re-order list when sending to printer only.
            // Added AllowPrintPreview parameter, which defaults to true.  In this instance, only set to true
            //  when "Create PORs and print to printer" is selected.
            Ok2Print:=pfSelectFormPrinter(PDevRec,BOn,RForm,UFont,Orient, false, aReorderMode = rmCreateAndPrint);
          {$ENDIF}

          // PKR. 11/12/2015. ABSEXCH-15333.
          // Override the print method
          if aReorderMode = rmCreateAndPrint then
          begin
            PParam.PDevRec.fePrintMethod := 0; // Print
          end
          else
          begin
            PDevRec.fePrintMethod := 2; // Set to email to indicate UsePaperless.
          end;
        end; // with
      end;

      If (Ok2Print) then
      Begin
        New(MTExLocal,Create(27));

        try
          With MTExLocal^ do
            Open_System(CustF,PWrdF);

        except
          Dispose(MTExLocal,Destroy);
          MTExLocal:=nil;

        end; {Except}


        If (Assigned(MTExLocal)) then
        Begin
          if aSortViewEnabled then MakeSortedStockList(lStockList);

          {Set_BackThreadMVisible(BOn);

          MsgForm:=CreateMessageDialog('Please wait... Generating Purchase Orders',mtInformation,[mbAbort]);
          MsgForm.Show;
          MsgForm.Update;}

          // Loop through all the stock records
          Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

          While (StatusOk) and (Ok2Go) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
          Begin

            B_Func:=B_GetNext;

            // Check that we're not aborting
            mbRet:=MsgForm.ModalResult;
            Loop_CheckKey(Ok2Go,mbRet);
            MsgForm.ModalResult:=mbRet;

            // Let Windows get a look-in
            Application.ProcessMessages;

            {$IFDEF SOP}
              If (Not UseGLoc) then
                Stock_LocROSubst(Stock,StkFilt);
            {$ENDIF}

            {SS 11/04/2016 2016-R2
             ABSEXCH-17374:Auto-set before sort view and after sort view. Only sorted stock listed should generate POR.
             - If sort view is applied on the stocklist then system will generate POR only for those stock which are in the sorted list.}
            lValidLineItem := (not aSortViewEnabled) or (lStockList.IndexOf(Trim(Stock.StockCode)) <> -1);

            If (Stock.ROFlg) and (Not EmptyKey(Stock.SuppTemp,CustKeyLen)) and (Stk_InGroup(StkGrp,Stock)) and (lValidLineItem) then {* Marked for Processing *}
            Begin

              LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,LAddr);

              If (LOk) and (GlobLocked) then
              Begin

                // Has supplier or currency changed?
                If ((LastSupp<>Stock.SuppTemp) or (LastCurr<>Stock.ROCurrency)) then
                Begin

                  If (HeaderReq) then
                  Begin
                    // Save the header
                    Store_InvHed(0);

                    Status:=GetPos(F[InvF],InvF,RecAddr);

                    // If we don't have a scratch file, create one.
                    If (Not Assigned(ThisScrt)) then
                      { CJS 2012-09-06 - ABSEXCH-13364 - Generating PORs from Reorder }
                      New(ThisScrt,Init(11,MTExLocal,True));

                    // Add this record to the scratch file
                    ThisScrt^.Add_Scratch(InvF,InvOurRefK,RecAddr,Inv.OurRef,Inv.OurRef);

                    // Set a flag to indicate that we have something to process.
                    GotSome:=BOn;


                  end;

                  LastSupp:=Stock.SuppTemp;

                  LastCurr:=Stock.ROCurrency;


                  // Create a new record header
                  If (StatusOk) then
                    Gen_InvHed(LastSupp,Set_OrdRunNo(POR,BOff,BOff),Today,LastCurr,Ignore,0);

                  HeaderReq:=Not Ignore;

                end;

                If (Not Ignore) then
                // Prepare the order line
                With Id do
                Begin

                  {Status:=GetPos(F[Fnum2],Fnum2,RecAddr);}

                  ResetRec(Fnum);

                  MLocStk:=StkFilt;

                  {$IFDEF SOP}
                    Stock_LocLinkSubst(Stock,MLocStk);
                  {$ENDIF}

                  FolioRef:=Inv.FolioNum;

                  DocPRef:=Inv.OurRef;

                  IdDocHed:=Inv.InvDocHed;

                  PDate:=Stock.RODate;

                  If (PDate='') or (Length(PDate)<>8) then
                    PDate:=Inv.DueDate;

                  CustCode:=Inv.CustCode;

                  Qty:=Stock.ROQty;

                  QtyPack:=Stock.BuyUnit;

                  If (Not Stock.DPackQty) then
                    QtyMul:=Stock.BuyUnit
                  else
                    QtyMul:=1;

                  PriceMulX:=1.0;

                  ShowCase:=Stock.DPackQty;
                  PrxPack:=Stock.PricePack;
                  UsePack:=Stock.CalcPack;

                  StockCode:=Stock.StockCode;

                  Desc:=Stock.Desc[1];

                  NetValue:=Stock.ROCPrice;

                  VATCode:=Correct_PVAT(Stock.VATCode,Cust.VATCode);

                  LineNo:=Inv.ILineCount;

                  ABSLineNo:=LineNo;

                  LineType:=StkLineType[IdDocHed];

                  CalcVat(Id,Inv.DiscSetl);

                  Currency:=Inv.Currency;

                  CXRate:=Inv.CXRate;

                  CurrTriR:=Inv.CurrTriR;

                  {NomCode:=Stock.NomCodeS[1+Ord((Inv.InvDocHed In PurchSplit))
                                +(2*Ord((Inv.InvDocHed In PurchSplit) and (Syss.AutoValStk)))];

                  CCDep:=Stock.ROCCDep;


                  If (EmptyKey(CCDep[BOff],ccKeyLen)) then
                      CCDep[BOff]:=Cust.CustDep;

                  If (EmptyKey(CCDep[BOn],ccKeyLen)) then
                      CCDep[BOn]:=Cust.CustCC;}

                  PYr:=Inv.ACYr;
                  PPr:=Inv.AcPr;

                  Payment:=DocPayType[IdDocHed];

                  If (Syss.AutoClearPay) then
                    Reconcile:=ReconC;

                  LWeight:=Stock.PWeight;

                  DocLTLink:=Stock.StkLinkLT;


                  {$IFDEF SOP}
                    Set_StkCommod(Id,Stock);
                  {$ENDIF}


                  Deduct_AdjStk(Id,Inv,BOn);

                  {$IFDEF SOP}{v5 re-establish location override}
                    Stock_LocLinkSubst(Stock,MLocStk);
                  {$ENDIF}

                  If ((Stock.StockType=StkBillCode) and (Stock.KitOnPurch)) then
                  Begin
                    Link_StockCtrl(Id,Inv,Cust,LineNo,0,0,Qty*QtyMul,98,BOff,nil);
                    AddDLines:=BOff;
                  end
                  else
                  Begin
                    NomCode:=Stock.NomCodeS[1+Ord((Inv.InvDocHed In PurchSplit))
                             +(2*Ord((Inv.InvDocHed In PurchSplit) and (Syss.AutoValStk)))];

                    // PS 03-12-2015 - ABSEXCH - 14366 Fix - if Reorder Cost Centre and Department id blank update it with stock Cost Centre and Department
                    if Trim(Stock.ROCCDep[False]) = '' then
                      Stock.ROCCDep[False] := Stock.CCDep[False];

                    if Trim(Stock.ROCCDep[True]) = '' then
                      Stock.ROCCDep[True] := Stock.CCDep[True];

                    With Cust do
                      CCDep:=GetProfileCCDep(CustCC,CustDep,Stock.ROCCDep,CCDep,0);

                    {CCDep:=Stock.ROCCDep; v4.32 method


                    If (EmptyKey(CCDep[BOff],ccKeyLen)) then
                        CCDep[BOff]:=Cust.CustDep;

                    If (EmptyKey(CCDep[BOn],ccKeyLen)) then
                        CCDep[BOn]:=Cust.CustCC;}

                    AddDLines:=BOn;
                  end;

                  // Add the line
                  Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                  Report_BError(Fnum,Status);

                  Inv.ILineCount:=Inv.ILineCount+2;

                  {* Auto add any extra desc lines *}

                  If (AddDLines) then
                    Auto_AddDesc(Fnum,Keypath,StkFilt);


                  SetDataRecOfs(Fnum2,LAddr);

                  Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);


                  // Update the stock record to reflect the quantity to re-order
                  With Stock do
                  Begin
                      //PR: 18/08/2015 ABSEXCH-15445 Don't replace SuppTemp here as it's the index, so screws up the order
                      //Now replaced when stock list is closed
                      //SuppTemp:=Supplier;

                    ROQty:=0;

                    ROFlg:=BOff;

                    Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

                    Report_BError(Fnum2,Status);

                    Status:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);

                    B_Func:=B_GetNext;

                    {$IFDEF SOP}
                      If (StatusOk) and (LFiltSet) then
                        Update_LocROTake(Stock,StkFilt,0);
                    {$ENDIF}

                    {$IFDEF PF_On}
                      Stock_AddCustAnal(Id,BOn,0);
                    {$ENDIF}

                  end;

                end
                else
                  B_Func:=B_GetNext;

              end; {If Locked..}

            end; {If Not Tagged..}

            // Get the next record to process
            Status:=Find_Rec(B_Func,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

          end; {While..}

          // Out of the loop - Save the final header
          If (HeaderReq) then
          Begin

            Store_InvHed(0);

            Status:=GetPos(F[InvF],InvF,RecAddr);

            //PR: 24/08/2012 ABSEXCH-12650 Set KeepFile param to true, so that scratch file doesn't get deleted when ThisScrt is destroyed
            //the file needs to be used by the print thread, which will then delete it.
            If (Not Assigned(ThisScrt)) then
              New(ThisScrt,Init(11, MTExLocal, True));

            ThisScrt^.Add_Scratch(InvF,InvOurRefK,RecAddr,Inv.OurRef,Inv.OurRef);

            GotSome:=BOn;

          end;


          If (GotSome) then {* Call Thread *}
          Begin
            {$IFDEF Frm}
              Start_PORThread(Application.MainForm,MTExLocal,ThisScrt,FormRepPtr);

            {$ELSE}
              If (Assigned(ThisScrt)) then
                Dispose(ThisScrt,Done);

              Dispose(MTExLocal,Destroy);
            {$ENDIF}

          end
          else
          Begin {* Tidy up..}
            If (Assigned(ThisScrt)) then
              Dispose(ThisScrt,Done);

            Dispose(MTExLocal,Destroy);
          end;

          {MsgForm.Free;

          Set_BackThreadMVisible(BOff);}

        end; {If MT ExLocal OK..}
      end; {If Print Abort..}

      If (Assigned(FormRepPtr)) then
        Dispose(FormRepPtr);

    finally
      lStockList.Free;
    end;

  end; {Proc..}

{$ENDIF}





  { ===== Procedure to Automaticly Generate Adj Line ====== }

  {
    CJS 2011-02-28 ABSEXCH-10527 - Extended version of Gen_AutoAdjLine, to
    support the Cost Centre/Department warning.
  }
  Procedure Gen_AutoAdjLineEx(AQty    :  Real;
                              Lock    :  Boolean;
                              Fnum,
                              Keypath :  Integer;
                              Mode    :  Byte;
                              UCP     :  Double;
                              StkFilt :  Str10;
                          var HasCCDept: Boolean);
  var
    Loop  :  Boolean;
    Rnum  :  Real;

    TmpStk:  StockRec;

    TmpId :  Idetail;
    InvR  :  InvRec;

  Begin

    Rnum:=0;

    HasCCDept := True;
    With Id do
    Begin

      ResetRec(Fnum);

      MLocStk:=StkFilt;

      TmpStk:=Stock;

      {$IFDEF SOP}
        Stock_LocLinkSubst(Stock,MLocStk);
      {$ENDIF}

      FolioRef:=Inv.FolioNum;

      DocPRef:=Inv.OurRef;

      IdDocHed:=Inv.InvDocHed;

      PDate:=Inv.TransDate;

      PYr:=Inv.ACYr;
      PPr:=Inv.ACPr;

      QtyMul:=1;

      QtyPack:=QtyMul;

      PriceMulX:=1.0;

      ShowCase:=Stock.DPackQty;

      If (ShowCase) then
        QtyPack:=Stock.BuyUnit;


      Qty:=AQty;

      StockCode:=Stock.StockCode;

      LineNo:=RecieptCode;

      PostedRun:=StkAdjRunNo;

      NomMode:=StkAdjNomMode;

      LineType:=StkLineType[IdDocHed];


      If (Mode<>3) then
      Begin
        Rnum:=Currency_ConvFT(Calc_StkCP(Stock.CostPrice,Stock.BuyUnit,Stock.CalcPack),
                              Stock.PCurrency,Inv.Currency,UseCoDayRate);

      {* To be replaced by FIFO Calc *}

        CostPrice:=Round_Up(Rnum,Syss.NoCosDec);
      end
      else
        CostPrice:=UCP;

      NomCode:=Stock.NomCodes[3];

      CCDep:=Stock.CCDep;

      For Loop:=BOff to BOn do {* Either accept a pair or none at all as if one blank, posting to double accounts doubles up. b560.057 *}
      Begin
        If (EmptyKey(CCDep[Loop],ccKeyLen)) then
        Begin
          If (Not EmptyKey(Stock.Supplier,CustKeyLen)) then {* Attempt to get from supplier *}
            If Global_GetMainRec(CustF,Stock.Supplier) then
            Begin
              If (Loop) then
                CCDep[Loop]:=Cust.CustCC
              else
                CCDep[Loop]:=Cust.CustDep;
            end;

          If (EmptyKey(CCDep[Loop],ccKeyLen)) then {* Or opo *}
            CCDep[Loop]:=UserProfile^.CCDep[Loop];

          If (EmptyKey(CCDep[Loop],ccKeyLen)) then
          Begin
            Blank(CCDep[Not Loop],Sizeof(CCDep[Not Loop]));
            HasCCDept := False;
            Break;
          end;

        end;

      end;

      Stock:=TmpStk;

      //PR: 26/04/2012 Set Currency and Rates from header ABSEXCH-10450
      Id.Currency := Inv.Currency;
      Id.CXRate := Inv.CXRate;


      Deduct_AdjStk(Id,Inv,BOn);

      If (Mode<>3) then
      Begin
        TmpId:=Id;
        InvR:=Inv;

        Control_SNos(TmpId,Inv,Stock,1,Application.MainForm);

        Inv:=InvR;

        Id:=TmpId;
      end;

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);


    end; {With..}

  end; {Proc..}

  {
    CJS 2011-02-28 ABSEXCH-10527 - Original version of Gen_AutoAdjLine
    rewritten to simply call the new version, supplying the additional
    parameter (this parameter is not used if this old version is called.)
  }
  Procedure Gen_AutoAdjLine(AQty    :  Real;
                            Lock    :  Boolean;
                            Fnum,
                            Keypath :  Integer;
                            Mode    :  Byte;
                            UCP     :  Double;
                            StkFilt :  Str10);
  var
    HasCCDept: Boolean;
  begin
    Gen_AutoAdjLineEx(AQty, Lock, Fnum, Keypath, Mode, UCP, StkFilt, HasCCDept);
  end;

  { ========= Procedure to Auto Generate Adj Deposut Lines ======== }


  Procedure Gen_AutoAdjDep(DepCode  :  Str10;
                           DQty     :  Real;

                           Fnum,
                           Keypath  :  Integer;
                           StkFilt  :  Str10);

  Var
    FoundOk   :  Boolean;
    FoundCode :  Str20;
  Begin

    FoundOk:=GetStock(Application.MainForm,DepCode,FoundCode,-1);

    If (FoundOk) then
    Begin

      Gen_AutoAdjLine(DQty,BOn,Fnum,Keypath,0,0.0,StkFilt);


    end; {Ok..}

  end; {Proc..}


    { =========== Procedure to Generate automatic Stock Adjust ========= }



  Procedure Generate_Adj(StkFilt  :  Str10);


  Const
    Fnum      =  IdetailF;

    Keypath   =  IdFolioK;


    Fnum2     =  StockF;

    Keypath2  =  StkCodeK;



  Var
    KeyS       :  Str255;

    LastSupp   :  Str10;

    HedDesc    :  Str80;

    Ok2Go,
    LOk,
    Locked,
    HeaderReq,
    Ignore     :  Boolean;

    B_Func     :  Integer;

    AQty       :  Real;

    LAddr      :  LongInt;

    MsgForm    :  TForm;

    mbRet      :  TModalResult;

    TmpStk     :  ^StockRec;

    {
      CJS 2011-02-28 ABSEXCH-10527 - Cost Centre/Department warning.
    }
    HasCCDept: Boolean;
  Begin

    LastSupp:='';

    Ignore:=BOff;

    HeaderReq:=BOn;

    AQty:=0;

    KeyS:='';

    New(TmpStk);

    TmpStk^:=Stock;

    Ok2Go:=BOn;

    Set_BackThreadMVisible(BOn);

    MsgForm:=CreateMessageDialog('Please Wait... Generating Stock Take Adjustments',mtInformation,[mbAbort]);
    MsgForm.Show;
    MsgForm.Update;

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    While (StatusOk) and (Ok2Go) do
    Begin

      B_Func:=B_GetNext;

      mbRet:=MsgForm.ModalResult;

      Loop_CheckKey(Ok2Go,mbRet);

      MsgForm.ModalResult:=mbRet;


      TmpStk^:=Stock;

      {$IFDEF SOP}
        Stock_LocTkSubst(TmpStk^,StkFilt);
      {$ENDIF}



      If (TmpStk^.StkFlg) then
      Begin

        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,LAddr);

        If (LOk) and (Locked) then
        Begin

          If (HeaderReq) then
          Begin

            If (StkFilt<>'') then
              HedDesc:=' -'+StkFilt
            else
              HedDesc:='';

            Gen_InvHed('Stock Take'+HedDesc,0,Today,1,Ignore,1);

            HeaderReq:=BOff;

          end;

          If (Not Ignore) then
          Begin
            With Stock do
            Begin

              With TmpStk^ do
                AQty:=(QtyTake-QtyFreeze);

              {
                CJS 2011-02-28 ABSEXCH-10527 - added additional parameter for
                Cost Centre/Department warning.
              }
              Gen_AutoAdjLineEx(AQty,BOff,Fnum,Keypath,0,0.0,StkFilt,HasCCDept);


              {QtyTake:=0;} {25/01/95 - Don't remove as then rep gen can pick up last actuals *}

              StkFlg:=BOff;

              TmpStk^.StkFlg:=BOff;

              Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

              Report_BError(Fnum2,Status);

              {$IFDEF SOP}
                If (StatusOk) and (Not EmptyKey(StkFilt,LocKeyLen)) then
                  Update_LocROTake(TmpStk^,StkFilt,1);
              {$ENDIF}

            end;

          end
          else
            B_Func:=B_GetNext;

          Status:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);

        end; {If Locked..}

      end; {If Not Set..}

      Status:=Find_Rec(B_Func,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    end; {While..}

    Dispose(TmpStk);

    If (Not HeaderReq) then
      Store_InvHed(1);

    MsgForm.Free;

    Set_BackThreadMVisible(BOff);

    {
      CJS 2011-02-28 ABSEXCH-10527 - Cost Centre/Department warning.
    }
    if not HasCCDept then
    begin
      MessageDlg(
         'There are no default Cost Centres or Departments set against one ' +
         'or more stock items that appear on the generated adjustment. There ' +
         'are also no default Cost Centre or Department fields set against ' +
         'your user profile defaults, nor against the default supplier for ' +
         'the item(s). ' +
         #13#10#13#10 +
         'This Stock Take Adjustment will post with blank Cost Centre and ' +
         'Department fields unless manually populated. Please click the Help ' +
         'button for more information.',
         mtWarning,
         [mbOk, mbHelp],
         517);
    end;

  end; {Proc..}



  {$IFDEF SOP}
    { =========== Procedure to Generate automatic Stock Adjust ========= }


    Procedure Generate_LocTxfrAdj(LocFilt  :  Str10);


    Const
      Fnum      =  IdetailF;

      Keypath   =  IdFolioK;


      Fnum2     =  StockF;

      Keypath2  =  StkCodeK;



    Var
      KeyS       :  Str255;

      HeaderReq,
      Ignore     :  Boolean;

      B_Func     :  Integer;

      AvgVal     :  Double;

      AQty       :  Real;

      MsgForm    :  TForm;

      MTExLocal  :  tdPostExLocalPtr;

      mbRet      :  Word;

    Begin

      Ignore:=BOff;

      HeaderReq:=BOn;

      AQty:=0;

      KeyS:='';

      Set_BackThreadMVisible(BOn);

      New(MTExLocal,Create(28));

      try
        With MTExLocal^ do
          Open_System(CustF,Pred(SysF));

        MsgForm:=CreateMessageDialog('Please Wait... Generating Location Transfer Adjustment',mtInformation,[]);
        MsgForm.Show;
        MsgForm.Update;

        Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

        While (StatusOk) do
        Begin

          Application.ProcessMessages;

          B_Func:=B_GetNext;


          If (Stock.QtyInStock<>0) then
          Begin

            Begin

              If (HeaderReq) then
              Begin

                Gen_InvHed('Loc Transfer to '+LocFilt,0,Today,1,Ignore,1);

                HeaderReq:=BOff;

              end;

              If (Not Ignore) then
              Begin
                With Stock do
                Begin
                  {* Get Again, as Get direct will overwrite *}

                  AQty:=QtyInStock;

                  AvgVal:=StkCalc_AVCost(Stock,'',MTExLocal);

                  Gen_AutoAdjLine(AQty*-1,BOff,Fnum,Keypath,3,AvgVal,'');

                  Gen_AutoAdjLine(AQty,BOff,Fnum,Keypath,3,AvgVal,LocFilt);

                  Change_StkLocFIFO('',LocFilt,BOn);

                end;

              end
              else
                B_Func:=B_GetNext;

            end; {If Locked..}

          end; {If Not Set..}

          Status:=Find_Rec(B_Func,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

        end; {While..}

        If (Not HeaderReq) then
          Store_InvHed(1);

        AddStkBinFill2Thread(Application.MainForm,Stock,Stock,LocFilt,30);


      finally

        MsgForm.Free;

        Dispose(MTExLocal,Destroy);
      end; {try}

    end; {Proc..}

  {$ENDIF}


end. {Unit..}
