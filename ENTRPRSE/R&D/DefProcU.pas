Unit DEFProcU;

{$I DefOVr.Inc}

Interface

Uses Windows,Controls,GlobVar,ExWrap1U;



{ ================ Def Modes ================ }
{
  1 - All Documents
  2 - Remittance Advice
  3 - Statement Layout
  4 - Debt Cahse Letters
  5 - Trading History
  6 - Batch Document
  7 - Nom Txfr
  8 - Account Details
  9 - Labels (Run)
 10 - Label (Single)
 11 - Stock Record
 12 - Stock Adjust
 13 - Picking List Consolidated
 14 - Picking List Single
 15 - Consignment Note
 16 - Delivery Label
 17 - Stock Notes
 18 - Document with Serial Nos.
 19 - Product Labels
 20 - Single Product Label
 21 - Product Labels via Delivery Run
 22 - Statements with As @ Ageing, and including details for month
 23 - Time Sheets
 24 - Job Costing Backing Sheet
 25 - Job Costing Record
 26 - Label Job
 27 - Print ADJ as WIN, forces mode 12.
 30 - Print CIS Voucher

 }
{ =========================================== }


{ ================ Def File Modes ================ }
{
  1 - Account Details inc Notes
  2 - Customer History
  3 - Account Label
  4 - Statement Layout
  5 - Remittance Advice
  6 - Invoice Layout
  7 - SRI
  8 - Sales Credit Note
  9 - SRF
 10 - Quotation
 11 - Sales Order
 12 - Sales ProForma
 13 - Sales Delivery Note
 14 - Sales Reciept
 15 - Sales Journal Invoice
 16 - Sales Journal Credit
 17 - Picking List Consolidated
 18 - Picking List Single
 19 - Consignment Note
 20 - Delivery Label
 21 - Product Labels
 22 - Purchase Invoice
 23 - Purchase Credit Note
 24 - Purchase Quotation
 25 - Purchase Order
 26 - Purchase Journal Invoice
 27 - Purchase Journal Credit
 28 - PPI
 29 - PRF
 30 - Stock Record (Inc Bill Mat)
 31 - Stock Record including notes
 32 - Stock Adjustment Transaction
 33 - Nominal Transfers
 34 - Batch Entry List
 35 - Time Sheet
 36 - Job Costing backing Sheet
 37 - Job Costing Record
 38 - Debt Chase 1
 39 - Debt Chase 2
 40 - Debt Chase 3
 41 - PPY?
 42 - PDN?
 43 - Email Cover sheet
 44 - Fax Cover sheet
 45 - SRC - (Debit Note?)
 46 - PPY - Debit Note?
 47 - Self billing invoice - PJI
 48 - WIN
 49 - WOR
 50 - WOR Picking List
 51 - Cons WOR Picking List
 52 - CIS23
 53 - CIS24
 54 - CIS25
 55 - JPT
 56 - JST
 57 - JCT
 58 - JPA
 59 - JPS
 60 - JPA Certified
 61 - JSA Certified
 62 - Sales Return
 63 - Sales Return as Repair Quotation
 64 - Purchase Return
 }
{ =========================================== }




Procedure Control_DefProcess(Mode          :  Byte;
                             Fnum,KeyPAth  :  Integer;
                             KeyRef        :  Str255;
                             ExLocal       :  TdExLocal;
                             Ask4Prn       :  Boolean);

Function Get_CustPrint(THandle  :  TWinControl;
                       ListPoint:  TPoint;
                       Mode     :  Byte)  :  Byte;

Procedure PrintDocument(ExLocal  :  TdExLocal;
                        Ask4Prn  :  Boolean);

{$IFDEF STK}
  Procedure Print_StockDef(ExLocal  :  TdExLocal;
                           Ask4It   :  Boolean;
                           PMode    :  Byte;
                           ThisForm :  Str10);


  Procedure PrintStockRecord(ExLocal  :  TdExLocal;
                             Ask4Prn  :  Boolean);
{$ENDIF}

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   VarConst,
   Graphics,
   Dialogs,
   Forms,
   RPDevice,
   RPDefine,
   ETStrU,
   BTSupU1,
   ComnUnit,
   ComnU2,
   BtrvU2,
   BTkeys1U,
   SysU2,
   PrintFrm,
   SalTxl2U,
   PrntDlg2,
   RepInpTU,

   {$IFDEF JC}
      CISSup1U,
      IntMU,
      JChkUseU,
   {$ENDIF}

   {$IFDEF Rp}
     {$IFDEF STK}
      RepInp9U,
     {$ENDIF} 
   {$ENDIF}

   {$IFDEF SOP}
     // MH 15/09/2014: Extended for Order Payment Payment/Refund transactions
     oOPVATPayBtrieveFile,
   {$ENDIF SOP}

   // MH 11/10/2013 v7.X MRD2.4.19: Added support for identifying a contact role for a transaction print job
   GlobType, // Form Designer Constants/Types
   AccountContactRoleUtil,  // Contact Role Constants / Utility Functions

   FrmThrdU;







{ ================= Control Def Process ================ }

Function Process_DefProcess(Mode          :  Byte;
                            Fnum,KeyPAth  :  Integer;
                            KeyRef        :  Str255;
                        Var ExLocal       :  TdExLocal;
                            Ask4Prn,
                            BatchMode,
                            FullPrint     :  Boolean;
                        Var ThisForm      :  Str10)  :  Boolean;



Var
  Fmode      :   SmallInt;
  {PrinterNo,}
  DKeyLen    :   Integer;

  PKeyRef    :   Str255;
  PFnum,
  TStatus,
  PKeyPath   :   Integer;

  UseAcDetl,
  FormLock,
  Ok2Print   :   Boolean;

  ListPoint  :   TPoint;

  KeyC,
  WinDesc    :   Str255;

  ThisFont   :   TFont;

  ThisOrient :   TOrientation;

  LCPtr      :   Pointer;

  DevRec     :   TSBSPrintSetupInfo;

  {ThisCopies :   Integer;}

Begin
  PFNum := 0;
  PKeyPath := 0;
  DKeyLen:=0;
  WinDesc:='No Form';

  Result:=BOff;
  FormLock:=BOff;
  UseAcDetl:=BOff;

  If (Not BatchMode) then
    DefPrintLock:=BOn;

  ThisOrient:=poPortrait;


  FillChar(DevRec,Sizeof(DevRec),0);

  With DevRec do
  Begin
    If (Mode In [11,17]) and (Not Ask4Prn) then
      NoCopies:=ExLocal.LCtrlInt
    else
      NoCopies:=1;


    DevIdx:=-1;
  end;




  Ok2Print:=BOn;

  If (Ask4Prn) then
  Begin
    {PrintToQueue:=(Not (Mode In [3..5,8..11,17,19..22,24,25])); Ex32}
  end;

  With ExLocal do
    If (Not PrintToQueue) then
    Begin

      // MH 15/09/2014: Mode appears to be the Print Job Type - see FormDes2\GlobType.pas
      Case Mode of
        // fmRemitAdv = 2;   { Remittance Advice }
        // fmBatchDoc = 6;   { Batch Document }
        2,6
             :  Begin

                  Case Mode of
                    // fmRemitAdv = 2;   { Remittance Advice }
                    2  :  Begin
                            KeyRef:=FullMatchKey(MatchTCode,MatchSCode,LInv.OurRef);

                            Fnum:=PWrdF;

                            KeyPath:=HelpNdxK;

                          end;
                    // fmBatchDoc = 6;   { Batch Document }
                    6  :  Begin

                            KeyRef:=LInv.OurRef;

                            Fnum:=InvF;

                            KeyPath:=InvBatchK;
                          end;

                  end; {Case..}
                end; {If..}

        // fmAccDets = 8;   { Account Details }
        8    :  Begin
                  Fnum:=PWrdF;

                  KeyPath:=PWk;

                  KeyRef:=NoteTCode+NoteCCode+LCust.CustCode;


                end; {If..}

        // fmLabelRun     = 9;   { Labels (Run) }
        // fmLabelSngl    = 10;  { Label (Single) }
        // fmProductLabel = 19;  { Product Labels }
        // fmSnglProduct  = 20;  { Single Product Label }
        // fmProdViaDeliv = 21;  { Product Labels via Delivery Run }
        9,10,19..21
             :  Begin

                  {EX32 connect to Labels? LabEnd^:=KeyRef;

                  LabFnum:=Fnum;

                  LabKeypath:=KeyPath;

                  LabMode:=Mode;

                  LabIsCust:=(IsACust(LCust.CustSupp) and (Mode In [9,10]));

                  If (Mode=10) then  {* Need to initialise as its not comming from Report6U
                    For FMode:=1 to MaxLabelAX do
                      New(LabelCust[Fmode]);}

                end;

      end; {Case..}

      // MH 15/09/2014: Mode appears to be the Print Job Type - see FormDes2\GlobType.pas
      Case Mode of
        // fmAllDocs      = 1;   { All Documents }
        // fmRemitAdv     = 2;   { Remittance Advice }
        // fmBatchDoc     = 6;   { Batch Document }
        // fmNomTxfr      = 7;   { Nom Txfr }
        // fmStockAdj     = 12;  { Stock Adjust }
        // fmPickLstSngl  = 14;  { Picking List Single }
        // fmConsignNote  = 15;  { Consignment Note }
        // fmDelivLabel   = 16;  { Delivery Label }
        // fmDocSerialNo  = 18;  { Document with Serial Nos. }
        // fmTimeSheet    = 23;  { Time Sheets }
        // { Reserved       27   { Used internally by Exchequer for WOP Picking Lists }
        // MH 02/10/2014: Added support for printing Order Payment VAT Receipts directly
        // fmOrdPayVATReceipt = 31; { Order Payments - printing SRC as VAT Receipt }
        1,2,6,7,12,14,15,16,18,23,27,31
           :  Begin
                PKeyRef:=LInv.OurRef;
                PFnum:=InvF;
                PKeypath:=InvOurRefK;

                WinDesc:=DocNames[LInv.InvDocHed]+' '+PKeyRef;

                {* Link to customer to get form page *}
                If (LCust.CustCode<>LInv.CustCode) and (Not EmptyKey(LInv.CustCode,CustKeyLen)) then
                Begin
                  KeyC:=FullCustCode(LInv.CustCode);
                  LCPtr:=@LCust;

                  TStatus:=Find_Rec(B_GetEq,F[CustF],CustF,LCPtr^,0,KeyC);
                end;

                UseAcDetl:=BOn;
              end;

        // fmStatemLay    = 3;   { Statement Layout }
        // fmDebtChaseL   = 4;   { Debt Cahse Letters }
        // fmTradeHist    = 5;   { Trading History }
        // fmAccDets      = 8;   { Account Details }
        // fmStateAgeMnth = 22;  { Statements with As @ Ageing, and including details for month }
        3,4,5,8,22
           :  Begin
                PKeyRef:=FullCustCode(LCust.CustCode);
                PFnum:=CustF;
                PKeypath:=CustCodeK;

                UseAcDetl:=BOn;
                With LCust do
                  WinDesc:='Account '+dbFormatName(CustCode,Company);
              end;

        {$IFDEF STK}

          // fmStockRec     = 11;  { Stock Record }
          // fmStockNote    = 17;  { Stock Notes }
          // fmProductLabel = 19;  { Product Labels }
          // fmSnglProduct  = 20;  { Single Product Label }
          // fmProdViaDeliv = 21;  { Product Labels via Delivery Run }
          11,17,19,20,21
             :  Begin
                  PKeyRef:=FullStockCode(LStock.StockCode);
                  PFnum:=StockF;
                  PKeypath:=StkCodeK;

                  With LStock do
                    WinDesc:='Stock Record '+dbFormatName(StockCode,Desc[1]);


                end;

        {$ENDIF}

          // fmJCBackingSh  = 24;  { Job Costing Backing Sheet }
          // fmJCRec        = 25;  { Job Costing Record }
          24,25
            :  Begin
                 PKeyRef:=FullJobCode(LJobRec^.JobCode);
                 PFnum:=JobF;
                 PKeypath:=JobCodeK;

                 Fnum:=PWrdF;

                 KeyPath:=PWk;

                 KeyRef:=NoteTCode+NoteJCode+FullNCode(FullNomKey(LJobRec^.JobFolio));

                 With LJobRec^do
                    WinDesc:='Job Record '+dbFormatName(JobCode,JobDesc);
               end;

        {$IFDEF JC}
          // fmCISVoucher   = 30;  { CIS Vouchers }
          30   :  With LJobDetl.JobCISV do
                  Begin
                    PKeyRef:=CISCertKey(CISCertNo);
                    PFnum:=JDetlF;
                    PKeypath:=JDStkK;

                    Fnum:=PWrdF;

                    KeyPath:=HelpNdxK;

                    KeyRef:=FullMatchKey(MatchTCode,MatchCCode,CISFolio);

                    WinDesc:=CCCISName^+' '+GetIntMsg(4)+' No. '+CISCertNo;
                  end; {If..}
        {$ENDIF}

      end; {case..}


      DKeyLen:=Length(KeyRef);

      // MH 15/09/2014: FMode is the index of the form to use in the Form Definition Set - see FormDes2\SysFDet.pas for the master list
      Fmode:=Mode;

      // MH 15/09/2014: Customise FMode/Form Definition Set Index by print job type
      Case Mode of

        // fmAllDocs      = 1;   { All Documents }
        // fmRemitAdv     = 2;   { Remittance Advice }
        // fmBatchDoc     = 6;   { Batch Document }
        // fmNomTxfr      = 7;   { Nom Txfr }
        // fmStockAdj     = 12;  { Stock Adjust }
        1,2,6,7,12
           :   With LInv do                               {* All Docs *}
               Begin
                 GetCursorPos(ListPoint);

                 With ListPoint do
                 Begin
                   X:=X-50;
                   Y:=Y-15;
                 end;

                 // MH 15/09/2014: Display popup menu to clarify how the user wants to print the transaction/whatever...
                 Case InvDocHed of
                   SQU  :  Case (Ask4Prn) of
                             BOn  :  Fmode:=Get_CustPrint(Application.MainForm,ListPoint,2);

                             BOff :  FMode:=LNHist.Yr;   {* Set to Que Def Mode *}
                           end; {Case..}

                   SDN  :  Case (Ask4Prn) of
                             BOn  :  FMode:=Get_CustPrint(Application.MainForm,ListPoint,4);
                             BOff :  FMode:=LNHist.Yr;   {* Set to Que Def Mode *}
                           end; {Case..}

                   SOR  :  Case (Ask4Prn) of
                             BOn  :  Begin
                                       Fmode:=Get_CustPrint(Application.MainForm,ListPoint,3);

                                       // 18 = "Print as Picking List" menu option
                                       If (FMode=18) then {If its a Picking list force mode to picking list }
                                         // fmPickLstSngl = 14;  { Picking List Single }
                                         Mode:=14;
                                     end;
                             BOff :  FMode:=LNHist.Yr;   {* Set to Que Def Mode *}
                           end; {Case..}

                   {$IFDEF SOP}
                   // MH 15/09/2014: Extended for Order Payment Payment/Refund transactions - for OP Payment
                   //                and Refund SRC's display a menu to ask whether to print normally or as
                   //                a VAT Receipt
                   SRC  :  If (LInv.thOrderPaymentElement In [opeOrderPayment..opeInvoiceRefund]) Then
                           Begin
                             // Returns the Form Definition Set Index to be printed
                             //   14 = 'Sales Receipt (SRC)'
                             //   65 = 'Order Payments Payment SRC as VAT Receipt'
                             FMode := Get_CustPrint(Application.MainForm, ListPoint, 9);
                             If (FMode = 65) Then
                             Begin
                               // Switch to 'VAT Receipt' printing
                               Mode := 31;  // fmOrdPayVATReceipt = 31; { Order Payments - printing SRC as VAT Receipt }

                               // Check sign of SRC to determine whether it is Payment or Refund
                               If (LInv.InvNetVal < 0) Then
                                 // Refund
                                 FMode := 66;  // 'Order Refund (SRC) as VAT Receipt'
                             End; // If (FMode = 65)
                           End; // If (LInv.thOrderPaymentElement In [opeOrderPayment..opeInvoiceRefund])
                   {$ENDIF SOP}

                   {$IFDEF STK}

                     POR,PDN,PQU
                          :  Begin
                               Case (Ask4Prn) of
                                 BOn  :  Fmode:=Get_CustPrint(Application.MainForm,ListPoint,6);

                                 BOff :  FMode:=LNHist.Yr;   {* Set to Que Def Mode *}
                               end; {Case..}

                             end;


                     {$IFDEF RET}

                       SRN
                            :  Begin
                                 Case (Ask4Prn) of
                                   BOn  :  Fmode:=Get_CustPrint(Application.MainForm,ListPoint,8);

                                   BOff :  FMode:=LNHist.Yr;   {* Set to Que Def Mode *}
                                 end; {Case..}

                               end;

                     {$ENDIF}

                   {$ENDIF}



                   PPY  :  Case (Ask4Prn) of
                             BOn  :  Begin
                                       FMode:=Get_CustPrint(Application.MainForm,ListPoint,7);

                                       // 46 = "Debit Note" menu option
                                       If (FMode=46) then
                                       Begin
                                         // fmNomTxfr = 7;   { Nom Txfr }
                                         Mode:=7;
                                         KeyRef:=FullIdKey(LInv.FolioNum,RecieptCode);
                                         Fnum:=IdetailF;
                                         KeyPath:=IdFolioK;
                                         ThisForm:='';
                                       end;

                                     end;
                             BOff :  FMode:=LNHist.Yr;   {* Set to Que Def Mode *}
                           end; {Case..}

                 end; {Case..}

                 If ((InvDocHed In [POR,PDN,PQU,SQU,SDN,SOR])) and (Fmode=255) then
                 Begin
                   // MH 07/02/2012 v6.10 ABSEXCH-10984: Added Account Code parameter so correct form definition set can be used
                   StkTransLab_Report(Application.MainForm,FolioNum,0,12,(InvDocHed In [POR,SOR]),ExLocal.LCust.CustCode);
                 end;

                 {$IFDEF STK}
                   If ((InvDocHed In [POR,PDN,PQU])) and (Fmode=254) then
                   Begin
                     {$IFDEF Rp}
                       Bin_Report(1,Inv.OurRef,Application.MainForm);
                     {$ENDIF}

                   end;
                 {$ENDIF}

                 If ((InvDocHed In [PPY,POR,PDN,PQU,SQU,SDN,SOR])) and (Fmode In [0,254,255]) then
                   Exit;

                 If ((Not (InvDocHed In [SQU,SDN,SOR,SRN])) or (Fmode=0)) and (FMode<>46) And (Not (FMode In [65, 66])) then
                   Fmode:=EntDefPrnMode[InvDocHed];

                 // 20 = 'Sales Delivery Label' Form Def Set Entry
                 If (Fmode=20) then  {* If it is a delivery label then we need to foce mode...*}
                   // fmLabel = 26;  { Label - any sort }
                   Mode:=26
                 else
                   If (Fmode In [58,59]) and (InvDocHed In JapJapSplit) and (PDiscTaken) then
                     Fmode:=Fmode+2; {Print certified version of form}
               end;

          // fmStatemLay = 3;   { Statement Layout }
          3  :  FMode:=4;      // 'Customer/Supplier Sales Statement' = 4;
        {.$IFNDEF JC}

          // fmDebtChaseL = 4;   { Debt Chase Letters }
          4  :   Fmode:=37+TrigEquiv(LCust.CreditStatus);    {* Debt chase letters *}

        {.$ENDIF}

        // fmTradeHist = 5;   { Trading History }
        5  :   Fmode:=2;                       {* Trading History *}

        // fmAccDets      = 8;   { Account Details }
        8  :   Fmode:=1;  {* Account Details *}         {* Account Details *}

        // fmLabelRun     = 9;   { Labels (Run) }
        // fmLabelSngl    = 10;  { Label (Single) }
        9,10
           :   Fmode:=3;  {* Account Label   *}

        // fmStockRec     = 11;  { Stock Record }
        // fmStockNote    = 17;  { Stock Notes }
        11,17
           :   Case Mode of
                 11  :  Fmode:=EntDEFPrnMode[SKF];
                 17  :  Fmode:=31;
               end;

        // fmPickLstCons  = 13;  { Picking List Consolidated }
        // fmPickLstSngl  = 14;  { Picking List Single }
        // fmConsignNote  = 15;  { Consignment Note }
        // fmDelivLabel   = 16;  { Delivery Label }
        13..16
           :   Begin

                 Fmode:=(Mode+4);

                 {If (Mode=13) then
                   Dec(DKeyLen);  {* Key primed to avoid blank stock codes *}

               end;

     // fmProductLabel = 19;  { Product Labels }
     // fmSnglProduct  = 20;  { Single Product Label }
     // fmProdViaDeliv = 21;  { Product Labels via Delivery Run }
     19..21
           :   Fmode:=21;  {* Product Label *}

        // fmStateAgeMnth = 22;  { Statements with As @ Ageing, and including details for month }
        22 :   Fmode:=4;   {* Force Statment layout *}

        // fmTimeSheet    = 23;  { Time Sheets }
        23 :   Fmode:=EntDEFPrnMode[TSH]; {* Time Sheet *}

        // fmJCBackingSh  = 24;  { Job Costing Backing Sheet }
        24 :   Fmode:=36;  {* JC Backing Sheet *}

        // fmJCRec        = 25;  { Job Costing Record }
        25 :   FMode:=37;  {* Job Record *}

        // { Reserved       27   { Used internally by Exchequer for WOP Picking Lists }
        27 :   Begin {* ADJ as issue note *}
                 FMode:=48;
                 Mode:=12;
               end;
        {$IFDEF JC}
          // fmCISVoucher   = 30;  { CIS Vouchers }
          30   :  With LJobDetl.JobCISV do
                  Begin
                    FMode:=52+CISVTypeOrd(CISCType,BOff);
                  end; {If..}
        {$ENDIF}

        // MH 02/10/2014: Added support for printing Order Payment VAT Receipts directly
        31 : Begin // fmOrdPayVATReceipt = 31; { Order Payments - printing SRC as VAT Receipt }
               // Check sign of SRC to determine whether it is Payment or Refund
               If (LInv.InvNetVal < 0) Then
                 // Refund
                 FMode := 66   // 'Order Refund (SRC) as VAT Receipt'
               Else
                 // Payment
                 FMode := 65;  // 'Order Payment (SRC) as VAT Receipt'
             End; // 31 - fmOrdPayVATReceipt

      end; {Case..}

      If (Fmode In [0..100]) then
      Begin
        If (Fmode>0) then
        Begin
          If (ThisForm='') or (Ask4Prn) then
          Begin
            GetMultiSys(BOff,FormLock,FormR); {* Refresh form names *}
            ThisForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[FMode];

            If (Ask4Prn) then
            With DevRec do
            Begin
              // MH 02/10/2014: Added support for printing Order Payment VAT Receipts (31) directly
              feMiscOptions[10]:=(Mode In [1..5,8,fmOrdPayVATReceipt]); {Get fax and eml cover sheet from account settings}

              If (feMiscOptions[10]) then
                AssignToGlobal(CustF);
            end;

          end;
        end;


        If (Ask4Prn) then
        Begin
          ThisFont:=TFont.Create;

          // MH 11/10/2013 v7.X MRD2.4.19: Added support for identifying a contact role for a transaction print job
          If (UseAcDetl) then
          begin
            // Look for transaction specific print jobs
            If (Mode In [fmAllDocs, fmRemitAdv, fmOrdPayVATReceipt]) Then
              // Look for Account Contact Role that is applicable to the transaction
              SetEcommsFromCust_TransRole(LCust,DevRec,Nil,BOn,LInv)
            Else If (Mode = fmStatemLay) Then
              // Statement
              SetEcommsFromCust_WithRole(LCust,DevRec,Nil,BOn,riSendStatement)
            Else
              SetEcommsfromCust(LCust,DevRec,Nil,BOn);
          End; // If (UseAcDetl)

          DevRec.feEmailSubj:=WinDesc+'. From '+Syss.UserName;

          If (Not (LInv.InvDocHed In [SIN,SCR,SRI,PIN,PCR,PPI,POR,SOR])) or (Mode<>1) then
            DevRec.feTypes:=8;  {* Block XML Tab*}

          // fmAllDocs      = 1;      { All Documents }
          // fmRemitAdv     = 2;      { Remittance Advice }
          // fmStatemLay    = 3;      { Statement Layout }
          // MH 09/06/2015 Exch-R1 ABSEXCH-16373: Print SRC As VAT Receipt not using Statement Delivery Mode
          // fmOrdPayVATReceipt = 31; { Order Payments - printing SRC as VAT Receipt }
          If (Mode In [1..3, fmOrdPayVATReceipt]) and (UseAcDetl) then {* Prompt for correct tab based on send method *}
          With LCust do
          Begin
            Case Mode of
              2,  // fmRemitAdv     = 2;      { Remittance Advice }
              3,  // fmStatemLay    = 3;      { Statement Layout }
              fmOrdPayVATReceipt  :  Begin
                                       Case StatDMode of
                                         1,2  :  DevRec.fePrintMethod:=StatDMode;
                                         3,4  :  DevRec.fePrintMethod:=StatDMode-2;
                                       end;
                                     end;
              else    If (LInv.InvDocHed In [SIN,SCR,SRI,SRF,SQU,SOR,SDN,PIN,PPY,PPI,PRF,PCR,POR]) then
                      Begin
                        Case InvDMode of
                          1,2  :  DevRec.fePrintMethod:=InvDMode;
                          3,4  :  DevRec.fePrintMethod:=InvDMode-2;
                          5    :  DevRec.fePrintMethod:=3; {XML}
                        end;

                      end;
            end; {Case..}

          end;

          Ok2Print:=pfSelectFormPrinter(DevRec,BOn,ThisForm,ThisFont,ThisOrient);

          If (BatchMode) then {* Copy Dev rec during batch mode, as otherwise destination etc lost *}
            Local_PrnInfo^:=DevRec;

          ThisFont.Free;

          If (Mode In [11,17]) then
          Begin
            ExLocal.LCtrlInt:=DevRec.NoCopies;
          end;

        end
        else
          If (BatchMode) then {* Use last Prn Info here as otherwise Devrec is blank!*}
            DevRec:=Local_PrnInfo^;

        If (Ok2Print) and (FullPrint) then
        Begin
          If (BatchMode) then
            Ok2Print:=pfAddBatchForm(DevRec,Mode,ThisForm,
                                     PFnum,PKeypath,PKeyRef,
                                     Fnum,Keypath,KeyRef,
                                     WinDesc,
                                     nil,
                                     BOn)
          else
          Begin
            {$IFDEF MH}
              { need this as ole debug window doesn't work with threads }
              If (Not InPrint) then
                Ok2Print:=pfPrintForm(DevRec,Mode,ThisForm,
                                      PFnum,PKeypath,PKeyRef,
                                      Fnum,Keypath,KeyRef,
                                      WinDesc,
                                      WinDesc,
                                      BOn)
              else
            {$ENDIF}
              Begin
                DevRec.feJobtitle:=WinDesc;

                Add2PrintQueue(DevRec,Mode,ThisForm,PFnum,PKeyPAth,Fnum,KeyPath,
                               PKeyRef,KeyRef);

              end;

          end;

          {If (Mode In [1,13,14,23]) then {* Set DocPrinted on Invoice or Credit Note.
          EL: 30/06/1998. Setting printed status moved into SBSForm.DLL v4.23e

            Set_PrintedStatus(((Not DevRec.Preview) and (Ok2Print)),(Mode In [13,14]) or (FMode=18),LInv);}

        end;





        Result:=Ok2Print;

        If (Not BatchMode) then
          DefPrintLock:=BOff;

      end; {If valid form mode ..}
    end
    else
    Begin

      Case Inv.InvDocHed of

        SQU  :  ;  {EX32..}
        {SQU  :  FMode:=Get_SQUMode;
        SDN  :  FMode:=Get_SDNMode;
        SOR  :  FMode:=Get_SORMode;}
        else    FMode:=0;

      end;

      {Add_2PrintQ(Inv.OurRef,FMode,Curr_Pno);}

    end;


end;



{ ================= Control Def Process ================ }

Procedure Control_DefProcess(Mode          :  Byte;
                             Fnum,KeyPAth  :  Integer;
                             KeyRef        :  Str255;
                             ExLocal       :  TdExLocal;
                             Ask4Prn       :  Boolean);


Var
  ThisForm  :  Str10;

Begin
  ThisForm:='';

  Process_DefProcess(Mode,Fnum,Keypath,KeyRef,ExLocal,Ask4Prn,BOff,BOn,ThisForm);
end;




{ ============ Proc to get customer mode ========= }

Function Get_CustPrint(THandle  :  TWinControl;
                       ListPoint:  TPoint;
                       Mode     :  Byte)  :  Byte;

Var
  PMenu  :  TFStkDisplay;

Begin
  PMenu:=TFStkDisplay.Create(THandle);

  try
    With PMenu do
    Begin
      Height:=0;
      Width:=0;

      PopPoint:=ListPoint;

      MenuMode:=Mode;

      ShowModal;

      If (ModalResult=mrOk) then
        Result:=MenuChoice
      else
        Result:=0;
    end; {With..}

  finally

    PMenu.Free;

  end; {try..}


end;


{ =============== Global procedure to print a given Inv ================ }

Procedure PrintDocument(ExLocal  :  TdExLocal;
                        Ask4Prn  :  Boolean);

Begin
  With ExLocal,LInv do
    Control_DefProcess(DEFDEFMode[InvDocHed],
                       IdetailF,IdFolioK,
                       FullNomKey(FolioNum),ExLocal,Ask4Prn);

end; {Proc..}




{$IFDEF STK}
  { ======== Link to DefProcU ======= }


  Procedure Print_StockDef(ExLocal  :  TdExLocal;
                           Ask4It   :  Boolean;
                           PMode    :  Byte;
                           ThisForm :  Str10);

  Const

    Fnum     =  PWrdF;

    Keypath  =  PwK;


    Fnum2    =  StockF;
    Keypath2 =  StkFolioK;



  Var

    TmpKPath,
    TmpStat  :  Integer;

    TmpRecAddr
             :  LongInt;


    Ok2Print :  Boolean;

    KeyS,
    KeyChk,
    KeyStk   :  Str255;

    TmpStock :  ^StockRec;



  Begin
    Ok2Print:=Not Ask4It;

    DefPrintLock:=BOn;

    With ExLocal do
      Case PMode of

        11 :  KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(LStock.StockFolio)));
        17 :  KeyChk:=NoteTCode+NoteSCode+FullNCode(FullNomKey(LStock.StockFolio));

      end;


      If (Ask4It) and (Not InPrint) then
      Begin
        ThisForm:='';

        Ok2Print:=Process_DefProcess(PMode,Fnum,Keypath,KeyChk,ExLocal,BOn,BOn,BOff,ThisForm);

        If (Ok2Print) then
          Ok2Print:=pfInitNewBatch(BOn,BOff);
      end;

      If (Ok2Print) then
      Begin

        If (PMode<>0) then
          Ok2Print:=Process_DefProcess(PMode,Fnum,Keypath,KeyChk,ExLocal,BOff,BOn,BOn,ThisForm);


        New(TmpStock);

        TmpStock^:=ExLocal.LStock;

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Ok2Print) and (PMode=11) do
        With Password.BillMatRec do
        Begin

          Application.ProcessMessages;

          KeySTk:=BillLink;

          Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

          If (StatusOk) then
          With Exlocal do
          Begin
            AssignFromGlobal(Fnum2);

            If (LStock.StockType=StkBillCode) then
            Begin

              TmpKPath:=GetPosKey;

              TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

              Print_StockDef(ExLocal,BOff,PMode,ThisForm);

              TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

            end;

          end;

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        end; {While..}

        ExLocal.LStock:=TmpStock^;

        Dispose(TmpStock);

        If (Ask4It) and (Ok2Print) then
          With ExLocal.LStock do
            pfPrintBatch('Print '+dbFormatName(StockCode,Desc[1])+' Record',ExLocal.LCtrlInt,BOn,'');

      end;


      DefPrintLock:=BOff;
  end;



  { =============== Global procedure to print a given Inv ================ }

  Procedure PrintStockRecord(ExLocal  :  TdExLocal;
                             Ask4Prn  :  Boolean);

  Var
    PrintMode  :  Byte;
    ListPoint  :  TPoint;
    ThisForm   :  Str10;

  begin
    ThisForm:='';

    GetCursorPos(ListPoint);
    With ListPoint do
    Begin
      X:=X-50;
      Y:=Y-15;
    end;
    PrintMode:=Get_CustPrint(Application.MainForm,ListPoint,5);

    If (PrintMode>0) then
      Print_StockDef(ExLocal,Ask4Prn,PrintMode,ThisForm);
  end; {Proc..}


{$ENDIF}



end.