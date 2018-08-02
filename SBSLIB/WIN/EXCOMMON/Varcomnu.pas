Const
  NoBACSTot       =  4;



  Currency1Page   =  30;

  NoUsrPrompts    =  15;



Type

  { ========= System Types ========== }

  {* Any changes here must be reflected in the rebuild module *}

  {VATType        =  (Standard,Exempt,Zero,Rate1,Rate2,Rate3,Rate4,IAdj,OAdj,
                     Spare1,Spare2,Spare3,Spare4,Spare5,Spare6,Spare7,Spare8);}

  {VATType        =  (Standard,Exempt,Zero,Rate1,Rate2,Rate3,Rate4,Rate5,Rate6,
                     Rate7,Rate8,Rate9,Rate10,Rate11,IAdj,OAdj,Spare8);}

  VATType        =  (Standard,Exempt,Zero,Rate1,Rate2,Rate3,Rate4,Rate5,Rate6,
                     Rate7,Rate8,Rate9,Rate10,Rate11,Rate12,Rate13,Rate14,Rate15,Rate16,
                     Rate17,Rate18,IAdj,OAdj,Spare8);


  NomCtrlType    =  (InVAT,OutVAT,Debtors,Creditors,DiscountGiven,DiscountTaken,
                     LDiscGiven,LDiscTaken,ProfitBF,CurrVar,UnRCurrVar,PLStart,PLEnd,
                     FreightNC,SalesComm,PurchComm,RetSurcharge,NSpare8,NSpare9,NSpare10,NSpare11,
                     NSpare12,NSpare13,NSpare14);

  INetAnalType   =  Array[VATType] of Real;

  IVATAnalType   =  Array[VATType] of Boolean;   {* Used as a trigger for allowing VAT Only Invoices *}


  DocTypes       =  (SIN,SRC,SCR,SJI,SJC,SRF,SRI,SQU,SOR,SDN,SBT,SDG,NDG,OVT,DEB,
                     PIN,PPY,PCR,PJI,PJC,PRF,PPI,PQU,POR,PDN,PBT,SDT,NDT,IVT,CRE,
                     NMT,RUN,FOL,AFL,ADC,ADJ,ACQ,API,SKF,JBF,WOR,TSH,JRN,WIN,SRN,PRN,JCT,JST,JPT,JSA,JPA);


  DocSetType     =  Set of DocTypes;

  TradeTermType  =  Array[1..2] of Str80;

  SysRecTypes    =  (SysR,VATR,DefR,CurR,CuR2,CuR3,ModRR,GCUR,GCU2,GCU3,JobSR,CstmFR,CstmFR2,FormR,EDI1R,EDI2R,EDI3R,CISR,CIS340R);



  DrCrType       =  Array[False..True] of Real;   { Debit(+) Credit(-) }

  DrCrDType      =  Array[False..True] of Double;   { Debit(+) Credit(-) }

  DrCrVarType    =  Array[1..CurrencyType,False..True] of Real;  {* Currancy Adjust Variable *}

  CurrChangeSet  =  Set of Byte; {  Set of Currencies whose rate has changed  }

  NomPrAry       =  Array[1..2,1..4] of Byte; {From / To Yr/Pr Section 1,
                             ^ same as NRanges.}

  StockPosType   =  Array[1..10] of Real;  {* Stock Deduct positions In,Out,Alloc, OnOrd *}


  AgedTitType    =  Array[1..4] of String[10]; {* Used for User Definable Ageing purposes *}


  BACSAnalType   =  Array[0..NoBACSTot] of Double;

  DocStatusType  =  Array[0..9] of Str15;

  {$IFDEF ExWin}

    CISTaxType        =  (Construct,Technical,CISRate1,CISRate2,CISRate3,CISRate4,CISRate5,CISRate6,
                          CISRate7,CISRate8,CISRate9);
  {$ENDIF}


Const



  PcntChr        =  '%';


  PQCode         =  'Q';  {* Constant Code for Print Queue Weightings *}

  OneScrn        =  8;             {*  No Lines on the Screen    *}

  {$IFDEF PF_On}

    NofItems     =  10;            {*  No of Invoice Items /Line Pro/MC *}

  {$ELSE}

    NofItems     =  8;             {*  No of Invoice Items /Line *}

  {$ENDIF}




  NomCtrlStart   :  NomCtrlType  =  InVat;

  {$IFNDEF PF_On}
    NomCtrlEnd     :  NomCtrlType  =  UnRCurrVar;
    NomCtrlInpEnd     :  NomCtrlType  =  PLEnd;
  {$ELSE}

    NomCtrlEnd     :  NomCtrlType  =  PurchComm;


    NomCtrlInpEnd  :  NomCtrlType  =  PurchComm;

  {$ENDIF}


             { ==================== Document Types ==================== }

  DocCodes       :  Array[DocTypes] of String[3]  =
                                    ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT','SDG','NDG','OVT','DEB',
                                     'PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT','SDT','NDT','IVT','CRE',
                                     'NOM','RUN','FOL','AFL','ADC','ADJ','ACQ','API','SKF','JBF','WOR','TSH','JRN','WIN','SRN',
                                     'PRN','JCT','JST','JPT','JSA','JPA');

  {- This additional set needed as Direct Range should follow single doc numbers -}

  DocNosXlate    :  Array[DocTypes] of String[3]  =
                                    ('SIN','SRC','SCR','SJI','SJC','SCR','SIN','SQU','SOR','SDN','SBT','SDG','NDG','OVT','DEB',
                                     'PIN','PPY','PCR','PJI','PJC','PCR','PIN','PQU','POR','PDN','PBT','SDT','NDT','IVT','CRE',
                                     'NOM','RUN','FOL','AFL','ADC','ADJ','ACQ','API','SKF','JBF','WOR','TSH','JRN','WIN','SRN',
                                     'PRN','JCT','JST','JPT','JSA','JPA');

  { - This Set Used to determine next count increment NOTE SDG&SDT used as a negative FolioCount for picking list and SOP - }

  IncxDocHed     :  Array[DocTypes] of Integer    =
                                   (  1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
                                      1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,   -1,    1,    1,    1,
                                      1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
                                      1,1,1,1,1,1);

  SalesSplit     =  [SIN..SBT];

  SalesStart     =  SIN;
  SalesEnd       =  SBT;

  SalesCreditSet =  [SCR,SJC,SRF]; {v5.5 General correction?}

  SINExternSet   =  [SIN,SCR];

  ChkCreditSet   =  [SIN,SCR,SOR,PIN,PCR,POR];      { Documents where a credit check is required }

  PurchSplit     =  [PIN..PBT];
  PurchSet       =  [PPY,PRF,PPI];

  PurchCreditSet =  [PCR,PJC,PRF];

  PurchStart     =  PIN;
  PurchEnd       =  PBT;

  DocAllocSet    =  [PIN,PCR,PJI,PJC,PPY,SIN,SCR,SJI,SJC,SRC] ; {* Documents which will be included in bacs run *}

  RecieptSet     =  [SRC,PPY];      { Deferentiate betwix Reciept & Payment }

  RecieptCode    =  LastAddrD;      { Weight Folio Ref With This }
  FreightCode    =  LastAddrD-1;    { Weight folio for freight }


  MatchSet       =  RecieptSet+[SCR,PCR,SJC,PJC]; {* Matched payment part of Allocation Set *}

  CreditSet      =  [SRF,PRF,SCR,PCR,SJC,PJC];    {* Credit note Sets *}

  DirectSet      =  [SRF,SRI,PRF,PPI]; { Direct Invoice with Reciept Types }

  BatchSet       =  [SBT,PBT];  { Batch Document Set }


  NomSplit       =  [NMT]; { Nominal Transfer types }

  StkAdjSplit    =  [ADJ]; { Stock Adjustment Types }

  TSTSplit       =  [TSH]; { Time Sheet Types }

  JAPSplit     =  [JCT,JST,JPT,JSA,JPA]; {Job Application set}
  JAPOrdSplit  =  [JCT,JST]; {Types affecting committed}
  JAPJAPSplit  =  [JSA,JPA]; {Application split}
  JAPSalesSplit=  [JST,JSA];
  JAPPurchSplit=  [JCT,JPA,JPT];

  WOPSplit       =  [WOR,WIN];

  {$IFDEF EXWIN}
     StkRetSplit       =  [SRN,PRN];
     StkRetSalesSplit  =  [SRN];
     StkRetPurchSplit  =  [PRN];
     StkRetGenSplit    =  [PIN,PPI,PDN,POR,SDN,SIN,SRI,SRN,SOR];  {* Docs a return can be generated for/from *}

  {$ENDIF}

  AutoPrnSet     =  [SIN,SCR,SRI,SRF,SQU,SOR,SDN,PPY,PQU,POR];

  QuotesSet      =  [SQU,PQU];

  OrderSet       =  [SOR,POR];

  PSOPSet        =  [SOR,POR,SDN,PDN];

  DeliverSet     =  [PDN,SDN];

  ChequeSet      =  [PPY,PPI,SRF];  {* Documents which can have auto CQ Nos *}

  StkOutSet      =  [SIN,SCR,SRF,SRI,SJI,SJC,SDN];  {* Documents which affect Stock Tree *}

  StkInSet       =  [PIN,PDN,PCR,PRF,PPI,PJI,PJC];


  StkOpoSet =  [SCR,SRF,SJC,PCR,PRF,PJC];  {* Docs which are oposite sign *}

  StkPUpSet =  [PIN,PDN,PPI,PJI,WOR];   {* Docs which update the Last cost price *}

  StkDedSet =  [SIN,SDN,SRI,SJI,PCR,PJC];   {* Docs where stock is checked *}

  {$IFDEF ExWin}
    {$IFDEF SOP}
      CommitLSet  =  PurchSplit-[PQU,PPY,PBT];  { Transaction types which maintain the live commited balance }

    {$ENDIF}
  {$ENDIF}



  DocSplit       :  Array[False..True,1..9] of DocTypes = ((PIN,PPY,PCR,PJI,PJC,PRF,PPI,PQU,PBT),
							   (SIN,SRC,SCR,SJI,SJC,SRF,SRI,SQU,SBT)
                                                          );

  DocNames       :  Array[DocTypes] of String[30] = ('Sales Invoice','Sales Receipt','Sales Credit Note',
                                                     'Sales Journal Invoice','Sales Journal Credit','Sales Refund',
                                                     'Sales Receipt + Invoice','Sales Quotation','Sales Order',
                                                     'Sales Delivery Note','Sales Batch Entry',
                                                     'Settlement Discounts Given','Standard Discounts Given','Output VAT',
                                                     'Debtors Control A/C',
                                                     'Purchase Invoice','Purchase Payment','Purchase Credit Note',
                                                     'Purchase Journal Invoice','Purchase Journal Credit',
                                                     'Purchase Refund','Purchase Payment + Invoice','Purchase Quotation',
                                                     'Purchase Order','Purchase Delivery Note','Purchase Batch Entry',
                                                     'Settlement Discounts Taken','Standard Discounts Taken','Input VAT',
                                                     'Creditors Control A/C',
                                                     'Nominal Transfer','Posting Run','Folio Number','Automatic Folio No.',
                                                     'Automatic Document','Stock Adjustment',
                                                     'Automatic Cheque Number','Automatic Pay-in Ref','Stock Folio Number',
                                                     'Job Folio Number','Works Order','Time Sheet','Job Posting Run',
                                                     'Works Issue Note','Sales Return','Purchase Return',
                                                     'Job Contract Terms','Job Sales Terms','Job Purchase Terms',
                                                     'Job Sales Application','Job Purchase Application');

    DocCnst        :  Array[DocTypes] of Integer    =
                                     ( -1,    1,    1,   -1,    1,    1,   -1,   -1,   -1,   -1,    -1,    1,    1,   -1,    1,
                                        1,   -1,   -1,    1,   -1,   -1,    1,    1,    1,    1,    -1,    1,    1,    1,   -1,
                                        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    -1,    1,    1,   -1,   -1,
                                        1,    1,   -1,    1,   -1,    1);

    DocNotCnst     =  -1;


    DocPayType     :  Array[DocTypes] of Char       = ('N','Y','Y','N','Y','Y','N','N','N','N','N','N','N','Y','N',
                                                       'Y','N','N','Y','N','N','Y','Y','Y','Y','Y','N','N','N','Y',
                                                       'T','C','C','C','C','S','C','C','C','C','C','C','C','C','C','C',
                                                       'C','C','C','C','C');

                      { == Doc Definition File name equivalence == }

    DEFPrnMode     :  Array[DocTypes] of Byte       = ( 1,  11, 5,  33, 34, 30, 29,  4,  19,  21,  18,  0,  0,  0,  0,
                                                        13, 2,  14, 35, 36, 38, 37, 12, 28,  13,  18,  0,  0,  0,  0,
                                                        15, 0,  0,  0,  0,  23, 0,  0,  22,  0,   0,  39,  0, 0, 0, 0,
                                                        0,  0, 0, 0, 0);

    EntDEFPrnMode  :  Array[DocTypes] of Byte       = ( 6,  14,  8, 15, 16,  9,  7, 10, 11,  13,  34,  0,  0,  0,  0,
                                                       22,  41, 23, 26, 27, 29, 28, 24, 25,  42,  34,  0,  0,  0,  0,
                                                       33, 0,  0,  0,  0,  32, 0,  0,  30,  0,   49,  35,  0, 0, 62, 64,
                                                       57, 56, 55, 59, 58);

    DEFDEFMode     :  Array[DocTypes] of Byte       = ( 1,  2,  1,  1,  1,  1,  1,  1,   1,   1,   6,  0,  0,  0,  0,
                                                        1,  2,  1,  1,  1,  1,  1,  1,   1,   1,   6,  0,  0,  0,  0,
                                                        7,  0,  0,  0,  0,  12, 0,  0,   11,  0,   1,  1,  0,  0,  1,  1,
                                                        1,  1, 1, 1, 1);


  {$IFDEF STK}

                                                        {* v5.70. Note, Line type for SRN & PRN also use +1 i.e. F+H *}

      StkLineType    :  Array[DocTypes] of Char       = ('I','X','I','I','I','I','I','Q','O','I','I','S','X','X','X',
                                                         'N','X','N','N','N','N','N','U','R','N','N','P','X','X','X',
                                                         'X','X','X','X','X','A','X','X','X','X','W','T','X','X','E','G',
                                                         '1','2','3','4','5');

                        { == Document affect on Stock levels == }


      StkAdjCnst     :  Array[DocTypes] of Integer    = (-1,  0,  1, -1,  1,  1, -1,  1,   1,  -1,   0,  0,  0,  0,  0,
                                                          1,  0, -1,  1, -1, -1,  1,  1,   1,   1,   0,  0,  0,  0,  0,
                                                          0,  0,  0,  0,  0,  1,  0,  0,   0,   0,   1,  0,  0,  1,  1, -1,
                                                          0,  0,  0,  0,  0);

  {$ENDIF}



  {$IFDEF EXWIN}
    DocGroup       :  Array[1..16] of String[20] = ('Purchase','Sales','Nominal','Stock','Works Order','Time Sheet','','','','','','','','','Sales Return','Purchase Return');
  {$ELSE}
    DocGroup       :  Array[1..6] of String[20] = ('Purchase','Sales','Nominal','Stock','Works Order','Time Sheet');
  {$ENDIF}

  // CJS - 18/04/2011: ABSEXCH-11252 - Posting Run performance enhancements
  { Max no. of Posting Summary Analysis Types }
  MaxPostingAnalysisTypes = 9;

  { Posting Analysis Split }
  PostingAnalysisDocTypes: Array[False..True, 1..MaxPostingAnalysisTypes] of DocTypes =
    (
      (PIN, PPY, PCR, PJI, PJC, SDT, NDT, IVT, CRE),
      (SIN, SRC, SCR, SJI, SJC, SDG, NDG, OVT, DEB)
    );

  PayF2Tit       :  Array[False..True] of String[4] = ('From','To');

  PayF2Set       =  [SRC,SRI,PRF];  {-- Docs which require Pay To --}


  {CurrencyType   =  30;}  {* Moved to VARVOMNU.PAS *}

  CurStart       =  0;   {* Screen List of Currencies Start *}
  CurEnd         =  9;   {* Screen List of Currencies End   *}

  XDayCode       =  'V';
  CRateCode      =  'C';


  TradeType      :  Array[False..True] of String[09] = ('Supplier','Customer');
  TradeCode      :  Array[False..True] of Char       = ('S','C');

  TradeConst     :  Array[False..True] of Integer    = (-1,1);

  TradTermLen    =  60;  { Length of trading term lines }

  AccClose       =  2;   { Hold Status of Closed Account }





  AgedHed        :  Array[0..3] of String[5] = ('','Day','Week','Month');

  ExternMsg      =  'Misc Counter';  {** Msg to be displayed if Doc Type cannot be found on Doc Names **}


  
  VStart         :  VATType      =  Standard;

  VEnd           :  VATType      =  Rate18;  {* Used to be Rate11}
  {VEnd           :  VATType      =  Rate11;  {* Used to be Rate11}
  {VEnd           :  VATType      =  Rate4;  {* Used to be Rate4}

  VEnd2          :  VATType      =  OAdj;


  VATMCode       =  'M';
  VATICode       =  'I';

  VATEqStd       :  CharSet      =  [VATMCode,VATICode];

  VATSTDCode     =  'S';

  VATEECCode     =  'A';

  VATECDCode     =  'D';

  VATZCode       =  'Z';

  {$IFDEF EX603}

    VATWCode       =  'W';

  {$ENDIF}

  VATEqRt3       :  CharSet      =  [VATEECCode];

  VATEqRt4       :  CharSet      =  [VATECDCode];

  VATEECSet      :  Charset      =  [VATEECCode,VATECDCode];

  VATSet         :  Charset      =  [VATEECCode,VATECDCode,'S','E','Z','M','I','1'..'9','T','X','B','C','F','G','R','W','Y'];

  SysNames       :  Array[SysRecTypes] of String[3]  =  { Key Names }

                                                     ('SYS','VAT','DEF','Cur','CU2','CU3','MOD','GCR','GC2','GC3','JOB',
                                                      'CTM','CT2','FRM','ED1','ED2','ED3','CIS','CI2');
  SysAddr        :  Array[SysRectypes] of LongInt    =  { Sys Adresses }

                                                     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);


  
  RWRunMode      =  '_RWRM';                           {* Rep Gen Run Mode Switch *}


  BatchRunNo      =   -10;          {* Batch member Doc Run No. *}

  BatchPostRunNo  =   -11;          {* Batch Header Posted Run No *}

  StkValRRunNo    =   -20;          {* Reverse Stock Valuation Line *}
  StkValVRunNo    =   -21;          {* Valuation Line *}
  StkValARunNo    =   -22;          {* Temp RunNo for auto generated Ctrl lines when
                                       auto stock valuation enabled *}

  {DelAcrualRunNo =   -23;          {* Set in VarFPosU for Delivery acruals *}

  {RETAcrualRunNo  =  -25;          {* Set in VarFPosU for Return acruals *}

  StkAdjRunNo     =   -30;          {* Posted Run No for Adjustment type docs *}
  TSTPostRunNo    =   -35;          {* Posted    "   "   "   "      "   *}

  OrdUSRunNo      =   -40;          {* Unposted Sales Orders Run No. *}
  OrdPSRunNo      =   -42;          {* Posted Sales Orders Run No. *}

  {$IFDEF SOP}
    OrdTSRunNo      =   -43;          {* Temp Run no for generating TeleSales Transaction *}
  {$ENDIF}

  OrdUPRunNo      =   -50;          {* Unposted Purchase Orders Run No. *}
  OrdPPRunNo      =   -52;          {* Posted Purchase Orders Run No. *}
  CommitOrdRunNo  =   -53;          {* Run time lines generated by commitment module *}

  WORUPRunNo      =   -60;          {* Unposted WOR *}
  WORPPRunNo      =   -62;          {* Posted WOR *}

  WINUPRunNo      =   -70;          {* Unposted WIN *}
  WINPPRunNo      =   -72;          {* Posted WIN *}


  MDCCARunNo      =  -100;          {* Multiple Dr/Cr Control Numbers *}

  {$IFDEF JC}
    JCUpliftARunNo  =  -102;       {* Temp RunNo for auto generated Uplift Ctrl lines when
                                       JC Uplift present *}

    JCTUPRunNo    =  -110;       {JCT Always unposted. Treated as deftault for sub contractor/job combinations}
    JSTUPRunNo    =  -111;       {JST Always unposted. Treated as deftault for each job}
    JPTUPRunNo    =  -112;       {JPT Always unposted. Treated as deftault for each job}

    JSAUPRunNo    =  -115;       {JSA Unposted. }
    JSAPRunNo     =  -116;       {JSA Posted. }

    JPAUPRunNo    =  -118;       {JPA Unposted. }
    JPAPRunNo     =  -119;       {JPA Posted. }

    JAHidePRunNo  =  -120;       {Job actual hide Purchase run no}
    JAHideSRunNo  =  -121;       {Job actual hide Sales run no}

  {$ENDIF}

    SRNUPRunNo    =  -125;       {SRN Unposted. }
    SRNPRunNo     =  -126;       {SRN Posted. }

    PRNUPRunNo    =  -128;       {PRN Unposted. }
    PRNPRunNo     =  -129;       {PRN Posted. }

    {-130 to -134 also used as temp runnos for processing ADJ from ?RN}

    RETAcrualRunNo    =  -137;       {Used during temporary creation of Returns movement G/L}


  { ============= Automatic Daybook Settings =========== }


  PeriodInc      =  'P';
  DayInc         =  'D';

  MaxUntilDate   =  '20491231';
  MinUntilDate   =  '19800101';

  MaxUnYr        =  149;

  AutoRunNo      =  -2;                           

  AutoPrefix     =  'A';


  { =================================================== }


  { =========== CIS Tax Settings ======================= }

  {$IFDEF EXWIn}
    CISTaxSet         :  Charset      =  ['C','1'..'9','T'];

    CISStart          :  CISTaxType   =  Construct;

    CISEnd            :  CISTaxType   =  Technical; {CISRate9;}

    CISDocSet         =  [PIN,PCR,PJI,PJC,PPI,PRF];

  {$ENDIF}

  { =================================================== }

