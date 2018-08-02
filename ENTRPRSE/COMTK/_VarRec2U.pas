Unit VarRec2U;




{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 31/07/90                      }
{                                                              }
{               Global variables & Type definitions            }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}



Interface

{$O+}

{$IFDEF EXWIN}

  {$REALCOMPATIBILITY ON}
  {$ALIGN 1}
{$ENDIF}


Uses GlobVar,BtrvU2;


Const
  {CurrencyType    =  30;}

  CurrencyType    =  90; { HM: Also update CrFlags array in FormDes2\GlobType.Pas }

  CurrencyPages   =  3;  {* If this alteres you need to change Get/OutMultiSysCur in Ex SysU4, &
                            Ent BtSupU1 *}


  NofSBands  =   10;
  NofSUBnds  =   08;
  NofSDesc   =   06;
  NofSNoms   =   05;

Type

  CurrTypes      =  Array[False..True] of Real;       {  CoRate/VATRate }

  ISNArrayType   = Array[1..8] of Byte;


  CCDepType      =  Array[False..True] of String[3];  {  CC/Dep Type }

    SaleBandsRec =  Record
                       Currency   :  Byte;    { Currency of Band }
                       SalesPrice :  Real;    { Price of Band    }
                     end;

     StkDescType  =  Array[1..NofSDesc] of      { Multiple Descriptions }
                       String[35];



     SaleBandAry  =  Array[1..NofSBands] of
                       SaleBandsRec;


     TriCurType   =  Record
                       TriRates   :   Double;
                       TriEuro    :   Byte;
                       TriInvert  :   Boolean;
                       TriFloat   :   Boolean;
                       Spare      :   Array[1..10] of Byte;
                     end; {Rec..}



      { ================ Multi Location File ============= }

  Const
    MLocF     =     14;

    MLNofKeys =     3;

    MLK       =     0;
    MLSecK    =     1;
    MLSuppK   =     2;


    MLNofSegs =     6;



  Type
   DefMLNomType  =  Array[1..10] of LongInt;
      { ================ Master Location Record ================ }

      {RecPFix = NoteTCode} {'N'}

      MLocLocType    = Record
                 {002}  loCode       :  String[10];   { Master Location Code }
                 {012}  Spare        :  Array[1..20] of Byte;
                 {033}  loName       :  String[45];   {    "       "    Name }
                 {079}  Spare1       :  String[31];
                 {111}  loAddr       :  AddrTyp;      { Address }
                 {266}  loTel        :  String[25];   { Tel     }
                 {292}  loFax        :  String[25];   { Fax     }
                 {318}  loemail      :  String[100];  { email   }
                 {419}  loModem      :  String[25];   {modem number }
                 {445}  loContact    :  String[30];   { Contact   }
                 {475}  loCurrency   :  Byte;         { Def Currency }
                 {477}  loArea       :  String[5];    { Report Area }
                 {483}  loRep        :  String[5];    { Report Rep  }
                 {488}  loTag        :  Boolean;      { Tagged }
                 {489}  loNominal    :  DefMLNomType; { Def Nom }
                 {530}  loCCDep      :  CCDepType;    { Def CC Dep }
                 {536}  loUsePrice   :  Boolean;      { Override Price }
                 {537}  loUseNom     :  Boolean;      { Override Noms }
                 {538}  loUseCCDep   :  Boolean;      { Override CCDep}
                 {539}  loUseSupp    :  Boolean;      { Override Supplier}
                 {540}  loUseBinLoc  :  Boolean;      { Override Bin Loc }
                 {541}  loNLineCount :  LongInt;      { Notes Line Count }
                 {545}  loUseCPrice  :  Boolean;      { Use Locations own cost price}
                 {546}  loUseRPrice  :  Boolean;      { Use Locations own re-order price}
                 {547}  loWOPWIPGL   :  LongInt;      { Override WIP GL}

                 {$IFDEF EXWin}
                   {551}     loReturnGL  :    LongInt;  {Location Return GL}
                   {555}     loPReturnGL :    LongInt;  {Location Purchase Return}
                   {559}     Spare2       :    Array[1..207] of Byte; {!!}
                 {$ELSE}
                   {551}  Spare2       :  Array[1..215] of Byte;

                 {$ENDIF}

                 {766}
                      end;

      { ================ Stock Location Record ================ }

      {RecPFix = NoteTCode} {'N'}

      MStkLocType    = Record
                 {002}  lsCode1      :  String[30];   { Stock Code + Loc Code }
                 {033}  lsCode2      :  String[45];   { Loc Code + Stock Code }
                 {079}  lsCode3      :  String[31];   { Supplier + PCurrency + Stock Code }
                 {111}  lsStkCode    :  String[20];   { Stock Code }
                 {131}  lsStkFolio   :  LongInt;      {    "  Folio }
                 {136}  lsLocCode    :  String[10];   { Loc Code }
                 {146}  lsQtyInStock :  Double;       { Actual Stock }
                 {154}  lsQtyOnOrder :  Double;       { OnOrder }
                 {162}  lsQtyAlloc   :  Double;       { Allocated }
                 {170}  lsQtyPicked  :  Double;       { Picked }
                 {178}  lsQtyMin     :  Double;       { Min    }
                 {186}  lsQtyMax     :  Double;       { Max    }
                 {194}  lsQtyFreeze  :  Double;       { Freeze Qty }
                 {202}  lsRoQty      :  Double;       { Re-Order Qty }
                 {211}  lsRoDate     :  LongDate;     { Re-Order Date }
                 {220}  lsRoCCDep    :  CCDepType;    { Re-Order CC/Dep}
                 {229}  lsCCDep      :  CCDepType;    { Default CC/Dep}
                 {238}  lsBinLoc     :  String[10];   { Bin Location }
                 {248}  lsSaleBands  :  SaleBandAry;  { Pricing }
                 {318}  lsRoPrice    :  Double;       { Re-Order Price}
                 {326}  lsRoCurrency :  Byte;         {     "    Currency}
                 {327}  lsCostPrice  :  Double;       { Last Cost Price }
                 {335}  lsPCurrency  :  Byte;         {     "     Currency}
                 {336}  lsDefNom     :  DefMLNomType;
                 {406}  lsStkFlg     :  Boolean;      { In Stk Take }
                 {407}  lsMinFlg     :  Boolean;      { Below min Flg}
                 {409}  lsTempSupp   :  String[10];   { Temp Supplier }
                 {420}  lsSupplier   :  String[10];   { Main Suppplier}
                 {431}  lsLastUsed   :  LongDate;     { Last used rec }
                 {439}  lsQtyPosted  :  Double;       { Posted loc qty }
                 {447}  lsQtyTake    :  Double;       { Stock Take Qty }
                 {455}  lsROFlg      :  Boolean;      { RO Flg }
                 {457}  lsLastTime   :  String[6];    { Time last used }
               {$IFDEF EXWin}
                 {463}  lsQtyAllocWOR:  Double;       { Allocated to WOR}
                 {471}  lsQtyIssueWOR:  Double;       { Issued to WOR}
                 {479}  lsQtyPickWOR :  Double;       { Picked on WOR}
                 {487}  lsWOPWIPGL   :  LongInt;      { WIPGLCode}

                 {491}     lsSWarranty  :    Byte;                 {Standard warranty count in months or years}
                 {492}     lsSWarrantyType
                                      :    Byte;                 {Standard warranty Type 0 months or 1 years}
                 {493}     lsMWarranty  :    Byte;                 {Manufacturers warranty count in months or years}
                 {494}     lsMWarrantyType
                                      :    Byte;                 {Manufacturers warranty Type 0 months or 1 years}
                 {495}     lsQtyPReturn :    Double;               {Qty Returned on PRN}
                 {503}     lsReturnGL   :    LongInt;              {G/L code used for Return G/L movement}
                 {507}     lsReStockPcnt:    Double;               {ReStock pcnt auto applied as an additional cost}
                 {515}     lsReStockGL  :    LongInt;              {ReStock G/L code on auto line}
                 {519}     lsBOMDedComp :    Boolean;              {Override behaviour of deduct comp if no stock}
                 {520}     lsQtyReturn  :    Double;               {Sales Return Qty}
                 {528}     lsPReturnGL  :    LongInt;              {G/L code used for Purchase Return G/L movement}
                 {532}     Spare2       :    Array[1..239] of Byte; {!!}

               {$ELSE}
                 {463}  Spare2       :  Array[1..308] of Byte;
               {$ENDIF}

                 {766}
                      end;


      {RecPFix = NoteTCode}  {'N'}

      {* AltSPFix   declared in AltCRe2U.pas    :  Array[0..3] of Char = (NoteCCode,'1','2','3');
         allows for the equivalent, superseded and opportunity databases to reside within same database
         This is achieved *}

      SdbStkType    = Record
                 {002}  sdCode1      :  String[30];   { Supplier Stk Code }
                 {033}  sdCode2      :  String[45];   { Stk Folio + sdCode1}
                 {079}  sdCode3      :  String[31];   { sdFolio + Stock Folio}
                 {110}  sdStkFolio   :  LongInt;      { Stock Link Folio }
                 {114}  sdFolio      :  LongInt;      { Own Folio Link }
                 {119}  sdSuppCode   :  String[10];   { Supplier Code}
                 {130}  sdAltCode    :  String[20];   { Supplier Own Stock Code}
                 {150}  sdROCurrency :  Byte;         { Re Order Curency }
                 {151}  sdRoPrice    :  Double;       { Re-Order Price}
                 {159}  sdNLineCount :  LongInt;      { Note Count }
                 {164}  sdLastUsed   :  LongDate;     { Last used }
                 {172}  sdOverRO     :  Boolean;      { Overrride RO Price }
                 {174}  sdDesc       :  String[35];   { General Description }
                 {210}  sdLastTime   :  String[6];    { Updated Time }

               {$IFDEF EXWin}
                 {216}  sdOverMinEcc  :  Boolean;     {Override min ecc. qty}
                 {217}  sdMinEccQty   :  Double;      {Min Ecc. Qty}
                 {225}  sdOverLineQty :  Boolean;     {Override line Qty}
                 {226}  sdLineQty     :  Double;      {Line Qty}
                 {234}  sdLineNo      :  LongInt;     {Line order for object popup display}

                 {238}  Spare2       :  Array[1..528] of Byte;
               {$ELSE}
                 {216}  Spare2       :  Array[1..550] of Byte;
               {$ENDIF}

                 {766}
                      end;

      {RecPFix = MatchTCode} {'T'}

      CuStkType    = Record
                 {002}  csCode1      :  String[30];   { CustCode + Line No }
                 {033}  csCode2      :  String[45];   { CustCode + Stock Code}
                 {079}  csCode3      :  String[31];   { StockCode + CustCode }
                 {111}  csCustCode   :  String[10];   { CustCode }
                 {122}  csStockCode  :  String[20];   { Stock Code}
                 {142}  csStkFolio   :  LongInt;      { Stock Folio}
                 {146}  csSOQty      :  Double;       { Repeat Order }
                 {155}  csLastDate   :  LongDate;     { Last date accessed }
                 {163}  csLineNo     :  LongInt;      { Display Order }
                 {167}  csLastPrice  :  Double;       { Last unit price paid}
                 {175}  csLPCurr     :  Byte;         { Last price currency }
                 {177}  csJobCode    :  String[10];   { Line Job Code }
                 {188}  csJACode     :  String[10];   {  "    "  Anal }
                 {199}  csLocCode    :  String[5];    {  "   Loc Code }
                 {204}  csNomCode    :  LongInt;      {  }
                 {209}  csCCDep      :  CCDepType;
                 {213}
                 {216}  csQty        :  Double;
                 {224}  csNetValue   :  Double;
                 {232}  csDiscount   :  Double;
                 {240}  csVATCode    :  Char;
                 {241}  csCost       :  Double;
                 {250}  csDesc       :  Array[1..NofSDesc] of      { Multiple Descriptions }
                                          String[35];
                 {465}  csVAT        :  Double;
                 {473}  csPrxPack    :  Boolean;
                 {474}  csQtyPack    :  Double;
                 {482}  csQtyMul     :  Double;
                 {490}  csDiscCh     :  Char;
                 {491}  csEntered    :  Boolean;
                 {492}  csUsePack    :  Boolean;
                 {493}  csShowCase   :  Boolean;
                 {494}  csLineType   :  Byte;
                 {495}  csPriceMulX  :  Double;
                 {503}  csVATIncFlg  :  Char;        {* Rate on line is inclusive of this rate *}
                 {504}  Spare2       :  Array[1..262] of Byte;
                 {766}
                      end;

      {RecPFix = MatchTCode} {'T'}

      TeleCustType    = Record
                 {002}  tcCode1      :  String[30];   { CustCode + Opo }
                 {033}  tcCode2      :  String[45];   { NU }
                 {079}  tcCode3      :  String[31];   { NU }
                 {111}  tcCustCode   :  String[10];   { CustCode }
                 {121}  tcDocType    :  Byte;         { Document Types }
                 {122}  tcCurr       :  Byte;         { TeleSales Currency }
                 {123}  tcCXrate     :  Array[BOff..Bon] of Real;
                                                      { Co/VAT Rates }
                 {136}  tcYourRef    :  String[10];   { YourRef }
                 {147}  tcLYRef      :  String[20];   { Long YourRef }
                 {168}  tcCCDep      :  CCDepType;    { CC/Dep Defaults }
                 {172}
                 {176}  tcLocCode    :  String[5];    { Loc Code }
                 {182}  tcJobCode    :  String[10];   { Job Code }
                 {193}  tcJACode     :  String[10];   { Job Anal Code }
                 {204}  tcDAddr      :  AddrTyp;      { Delivery Address }
                 {359}  tcTDate      :  LongDate;     { Trans Date }
                 {368}  tcDelDate    :  LongDate;     { Delivery Date }
                 {376}  tcNetTotal   :  Double;
                 {384}  tcVATTotal   :  Double;
                 {392}  tcDiscTotal  :  Double;
                 {401}  tcLastOpo    :  String[10];
                 {411}  tcInProg     :  Boolean;      { Internal still being processed flag }
                 {412}  tcTransNat   :  Byte;        { VAT Nature of Transaction }
                 {413}  tcTransMode  :  Byte;        { VAT Mode of Transport     }
                 {415}  tcDelTerms   :  String[3];   {* VAT Delivery Terms *}
                 {418}  tcCtrlCode   :  LongInt;     {* Dr Ctrl Code *}
                 {422}  tcVATCode    :  Char;        {* Cust Default VAt Code *}
                 {423}  tcOrdMode    :  Byte;        {* Default anal mode *}
                 {424}  tcScaleMode  :  Byte;        {* Default Scale Mode *}
                 {425}  tcLineCount  :  LongInt;     {* Total number of lines to be processed (}
                 {429}  tcWasNew     :  Boolean;     {* Was new *}
                 {430}  tcUseORate   :  Byte;        {* Forces the conversion routines to apply non tri rules *}
                 {431}  tcDefNomCode :  LongInt;     {* Default G/L Nom Code *}
                 {435}  tcVATIncFlg  :  Char;
                 {436}  tcSetDisc    :  Double;      {* Default Settlement Discount *}
                 {444}  tcGenMode    :  Byte;        {* 0 = Order, 1=Inv, 2=Quo *}
                 {445}  tcTagNo      :  Byte;        {* Tag no. *}
                 {446}  tcLockAddr   :  LongInt;     {* Address of last lock for unlock *}
                 {450}  Spare2       :  Array[1..316] of Byte;
                 {766}
                      end;

      {RecPFix = 'E' }


      EMUCnvType    = Record
                 {002}  emCode1      :  String[30];   { FullNomKey / Account code }
                 {033}  emCode2      :  String[45];   { Spare              }
                 {079}  emCode3      :  String[31];   { Spare                }
                 {110}  emWasCurr    :  LongInt;      { Original Currency }
                 {114}  emWasCXRate  :  Array[BOff..BOn] of Real;      {    Orig  "    Rate }
                 {126}  emNowRate    :  Array[BOff..BOn] of Real;      {    New   "    Rate }
                 {139}  emDocRef     :  String[10];   { Doc Ref / Account Code}
                 {149}  emNomCode    :  LongInt;      {G/L Reference }
                 {153}  emOrigValue  :  Double;       { Its original base value }
                 {161}  Spare        :  Array[1..605] of Byte;  {// Added missing of char (byte ?)}
                 {766}
                      end;



      {RecPFix = PassUCode }  {'U'}

    { == User default page  Use PassUCode +'D' to store == }

      tPassDefType  =  Record
                        {002}   Login  :  String[30];

                        {033}   Spare1    :  String[45];

                        {079}   Ndx2      :  String[31];

                        {110}   PWExpMode :  Byte;  { PW Expiry mode. 0= never, 1 = every x days, 2= expired}

                        {111}   PWExPDays :  SmallInt; {No Days expiry interval}

                        {114}   PWExpDate :  LongDate; {Date PW due to expire next}

                        {123}   DirCust   :  String[10]; {Default Direct Cust}

                        {134}   DirSupp   :  String[10]; {Default Direct Supplier}

                        {144}   MaxSalesA :  Double;     {Max Authorised Sales value}

                        {152}   MaxPurchA :  Double;     {Max Authorised Purch value}

                        {161}   CCDep     :  CCDepType;  {Def Cc/Dep}

                        {168}   Loc       :  String[10];

                        {178}   SalesBank :  LongInt;    {Default SRC Bank}

                        {182}   PurchBank :  LongInt;    {Default PPY Bank}

                        {187}   ReportPrn :  String[50]; {Default Report Printer}

                        {238}   FormPrn   :  String[50]; {Default Form Prn}

                        {288}   OrPrns    :  Array[1..2] of Boolean;  {Force override of PRN's}

                        {290}   CCDepRule :  Byte;  {CC/Dep override rules}

                        {291}   LocRule   :  Byte;  {Loc Override Rules}

                        {293}   emailAddr :  String[100]; {For paperless, send from email address}

                        {393}   PWTimeOut :  SmallInt;  {Time out login after x mins, 0 = disabled}

                        {395}   Loaded    :  Boolean;   {Record was found}

                        {397}   UserName  :  String[50];

                        {447}   UCPr      :  Byte;      {Users local period}

                        {448}   UCYr      :  Byte;      {Users Local Year}

                        {449}   UDispPrMnth
                                          :  Boolean;   {Local display as months}
                        {450}   Spare2    :  Array[1..316] of Byte;
                              end;


 { ================ Allocation Ctrl Record =============== }

{$IFDEF ExWin}
    AllocCType= Record
          {RecPFix = MBACSCode   } {'X'}
          {SubType = MBACSCtl}


              {002}   arcCode1     :  String[30];   { CustSupp + Custcode}
              {033}   arcCode2     :  String[45];   { Not used}
              {079}   arcCode3     :  String[31];   { Not used}

              {110}   arcBankNom   :  LongInt;      {  Bank Nominal }
              {114}   arcCtrlNom   :  LongInt;      {  MDC Control G/L}

              {118}   arcPayCurr   :  Byte;         {  Pay In Currency }

              {119}   arcInvCurr   :  Byte;         {  Filter Ledger Currency }

              {120}   Spare1       :  Array[1..4] of Byte;      {  CQ Number Start }

              {125}   arcCCDep     :  CCDepType;    {  Default CC/DEP }
              {129}   {Dep pos}
              {132}   arcSortBy    :  Byte;         {Sort ledger by. 0 = Transdate.
                                                                     1 = DueDate
                                                                     2 = Value A
                                                                     3 = YourRef
                                                                     4 = Currency
                                                                     5 = OurRef}


              {133}   arcAutoTotal :  Boolean;      { Indicates that list will be
                                                      caluclating total automatically based on allocations }

              {134}   arcSDDaysOver:  SmallInt;     {  Days we will go over settlemnt discount }

              {136}   arcFromTrans :  Boolean;      {  Are we allocating against an existing transaction }

              {138}   arcYourRef   :  String[10];

              {149}   arcChequeNo2 :  String[10];

              {159}   Spare3       :  Array[1..10] of Byte;
              {169}   arcForceNew  :  Boolean;      {Used to reset allocation databse when an incomplete
                                                     allocation is restored}

              {170}   arcSort2By   :  Byte;         {Sort ledger by. 0 = Transdate.
                                                                     1 = DueDate
                                                                     2 = Value A
                                                                     3 = Value D
                                                                     4 = YourRef
                                                                     5 = Currency
                                                                     6 = OurRef}

              {171}   arcTotalOwn  :  Double;       {  Total allocated in own currency }

              {179}   arcTransValue:  Double;       {  Total value of amount to be allocated }

              {187}   arcTagCount  :  LongInt;      {  Total No. of Items in List }

              {192}   arcTagRunDate:  LongDate;     {  Date of Payment }
              {200}   arcTagRunYr  :  Byte;         {  Year of Payment }
              {201}   arcTagRunPr  :  Byte;         {  Period of Payment }
              {203}   arcSRCPIRef  :  String[10];   {  Paying In Ref }
              {213}   arcIncSDisc  :  Boolean;      {  Include settlement discount in calcualtion }
              {214}   arcTotal     :  Double;       { Total allocated}
              {222}   arcVariance  :  Double;       { Total Variance available}
              {230}   arcSettleD   :  Double;       { Amount of settlement discount}
              {239}   arcTransDate :  LongDate;     { Transaction date}
              {248}   arcUD1       :  String[30];   { User defined fields 1-4 }
              {279}   arcUD2       :  String[30];
              {310}   arcUD3       :  String[30];
              {341}   arcUD4       :  String[30];
              {372}   arcJobCode   :  String[10];   {Link to project code}
              {383}   arcAnalCode  :  String[10];   {Link to anal code}
              {394}   arcDelAddr   :  AddrTyp;      {Addional payment details}
              {549}   arcIncVar    :  Boolean;      {Allow over allocation for variance}
              {551}   arcOurRef    :  String[10];   {Link to ourref if called from ledger}
              {561}   arcCxRate    :  CurrTypes;    {Exchange rate of transaction}
              {574}   arcOpoName   :  String[10];   {Login current owner name}

              {585}   arcStartDate :  LongDate;     {Date allocation commenced }

              {594}   arcStartTime :  String[6];    {Time allocation commenced }

              {601}   arcWinLogIn  :  String[50];   {Windows login}
              {651}   arcLocked    :  Byte;         {Flag to indicate allocation in progress by another user (2),
                                                     or stored incomplete (1)}
              {652}   arcSalesMode :  Boolean;      {Cust or Supp}
              {654}   arcCustCode  :  String[10];   {Account Code}
              {664}   arcUseOSNdx  :  Boolean;      {Use new index}
              {665}   arcOwnTransValue
                                   :  Double;       {Total of transaction in own currency}
              {673}   arcOwnSettleD
                                   :  Double;       {Total of settlement discount in own currency}

              {681}   arcFinVar    :  Boolean;      {Take any surplus as variance}
              {682}   arcFinSetD   :  Boolean;      {Take any surplus as settlement Discount}
              {683}   arcSortD     :  Boolean;      {Sort Descending}
              {684}   Spare2
                                   :  Array[1..5] of Byte;       {When dealing in form mode, amount originally settled
                                                                  for sanity check}


              {689}   arcAllocFull :  Boolean;      {Indicates we are allocating all of the receipt to avoid anu rounding}

              {690}   arcCheckFail :  Boolean;      {Set when check has discovered altered tagged entries}

              {691}   arcCharge1GL :  LongInt;      {Additional charges split}
              {695}   arcCharge2GL :  LongInt;      {Additional charges split}
              {699}   arcCharge1Amt:  Double;       {Additional charges split}
              {707}   arcCharge2Amt:  Double;       {Additional charges split}

              {715}   Spare        :  Array[1..51] of Byte;
              {766}


                   end;


   brBinRecType= Record
          {RecPFix = BRRecCode} {'I'}
          {SubType = MSernSub}


              {002}   brBinCode1   :  String[30];   { BinCode }
              {033}   brCode2      :  String[45];   { StkFolio + Sold + Loc + Priority + Date In + BinCode}
              {079}   brCode3      :  String[31];   { Loc + StkFolio + BinCode}

              {111}   brInDoc      :  String[10];   {  Original In doc}
              {122}   brOutDoc     :  String[10];   {  Orginal Out Doc}

              {132}   brSold       :  Boolean;      {  Sold }

              {134}   brDateIn     :  LongDate;     {  Date bought }

              {142}   brBinCost    :  Double;       {  Orig Cost }

              {150}   brBinCap     :  Double;       {  Bin Capacity }
              {158}   Spare1       :  Byte;
              {159}   brStkFolio   :  LongInt;      {  Link to stk record }


              {164}   brDateOut    :  LongDate;     { Date sold for child record}

              {172}   brSoldLine   :  LongInt;      {  Link back to sold line }

              {176}   brBuyLine    :  LongInt;      {  Linkback to Buy Line}

              {180}   brBatchRec   :  Boolean;      { Produce and maintain child records }

              {181}   brBuyQty     :  Double;       {Original Qty bought}

              {189}   brQtyUsed    :  Double;       {Qty used from original}

              {197}   brBatchChild :  Boolean;      {Batch child}

              {199}   brInMLoc     :  String[10];   {Location in}

              {210}   brOutMLoc    :  String[10];   {Location sold from}

              {221}   brOutOrdDoc  :  String[10];   {Out Order document}

              {232}   brInOrdDoc   :  String[10];   {In Order docuemnt}

              {242}   brInOrdLine  :  LongInt;      {In Order line ref}

              {246}   brOutOrdLine :  LongInt;      {Out Order LineRef}
              {250}   brCurCost    :  Byte;         {Currency of cost}
              {252}   brPriority   :  String[10];   {  Auto pick order }
              {262}   brBinSell    :  Double;       {  Selling price }
              {270}   brSerCRates  :  CurrTypes;    {  Cost Rate }
              {282}   brSUseORate  :  Byte;         {* Forces the conversion routines to apply non tri rules *}
              {283}   brSerTriR    :  TriCurType;   {* Details of Main Triangulation *}
              {305}   brDateUseX   :  LongDate;     {* Optional use by date *}
              {313}   brCurSell    :  Byte;         {* Selling currency *}
              {315}   brUOM        :  String[10];   {* Unit of measurement. Take from stock record *}
              {325}   brHoldFlg    :  Byte;         {* Hold Flag. 0 = Normal. 1/2 = On Hold 3= Use Tag *}
              {326}   brTagNo      :  Byte;         {* Match with SOP Tag No. *}

              {$IFDEF ExWin}
                {327}   brReturnBin  :  Boolean; {* Flagged as came back via returns module *}
                {328}   Spare        :  Array[1..438] of Byte;

              {$ELSE}
                {327}   Spare        :  Array[1..439] of Byte;
              {$ENDIF}
              {766}


                   end;


        {$IFDEF LTE01}
          {* Lite Bank Rec and eBank Structures *}

          BnkRHRecType= Record
          {RecPFix = LteBankRCode  =  'K'}
          {SubType = '1'}


              {002}   brBnkCode1   :  String[30];   { Rec Code }
              {033}   brBnkCode2   :  String[45];   { }
              {079}   brBnkCode3   :  String[31];   { }

              {111}   brStatDate   :  LongDate;     {  Statement Date }

              {120}   brStatRef    :  String[20];   {  Statement Ref}

              {141}   brBankAcc    :  String[15];   {  Bank Account }

              {156}   brCurrency   :  Byte;         {  Statement Currency }

              {158}   brUserId     :  String[10];   {  User Id }

              {169}   brCreateDate :  LongDate;     {  Creation Date }

              {178}   brCreateTime :  String[6];    {  Creation Time, HHMMSS}

              {184}   brStatBal    :  Double;       {  Statement Balance }


              {192}   brOpenBal    :  Double;       { G/L Opening Balance}

              {200}   brCloseBal   :  Double;       { G/L Closing Balance }

              {208}   brStatus     :  Byte;         { Statement Status}

              {210}   brIntRef     :  LongInt;      { Internal Reference (Relational link to lines }

                      brGLCode     :  longint;

              {213}   Spare        :  Array[1..549] of Byte;

              {766}


                   end;


          BnkRDRecType= Record
          {RecPFix = LteBankRCode  =  'K'}
          {SubType = '2'}


              {002}   brBnkDCode1  :  String[30];   { Rec Code }
              {033}   brBnkDCode2  :  String[45];   { }
              {079}   brBnkDCode3  :  String[31];   { }

              {111}   brPayRef     :  String[10];   {  Payment Reference for grouping }

              {122}   brLineDate   :  LongDate;     {  Line Date}

              {131}   brMatchRef   :  String[10];   {  OurRef of linked doc }

              {141}   brValue      :  Double;       {  Value on statement }

              {149}   brLineNo     :  LongInt;      {  Line No of linked line}

              {154}   brStatId     :  String[4];    {  Matched Statement Id }

              {159}   brStatLine   :  LongInt;      {  Matched Statement Line No }

              {164}   brCustCode   :  String[10];   {  Account Code }


              {174}   brPeriod     :  Byte;         { Transaction Period }

              {175}   brYear       :  Byte;         { Transaction Year }

              {176}   brCXRate     :  CurrTypes;    { Transaction exchange rate }

              {188}   brLUseORate  :  Byte;         {* Forces the conversion routines to apply non tri rules *}
              {189}   brCurTriR    :  TriCurType;   {* Details of Main Triangulation *}

              {211}   brYourRef    :  String[10];   { Transaction Your Ref }

              {221}   brTransValue :  Double;       { Transaction value }

              {230}   brCCDep      :  CCDepType;    { Transaction CC/Dep }

              {236}   brNomCode    :  LongInt;      {  Transaction Line G/L Code }

              {240}   brSRINomCode :  LongInt;      {  Transaction Line payment G/L Code on Direct types }

              {244}   brFolioLink  :  LongInt;      {  Transaction Line Folio  link to eventual transaction created from this. 0 = not executed yet}

              {248}   brVATCode    :  Char;         {  Transaction Line VAT Code }

              {249}   brVATAmount  :  Double;       {  Transaction Line VAT Value }

              {258}   brTransDate  :  LongDate;     {  Transaction Date}

              {266}   brIsNewTrans :  Boolean;      {  Flag to indicate a new transaction will be manufactured as a result of this entry }

                      brLineStatus :  Byte;

              {267}   Spare        :  Array[1..498] of Byte;

              {766}


                   end;


          BACSDbRecType= Record
          {RecPFix = LteBankRCode  =  'K'}
          {SubType = '3'}

              //PR Change brBankProd from String[10] to Word
              //PR Added brLastUseDate
              //PR Added brUserID
              {002}   brBACSCode1  :  String[30];   { Rec Code }
              {033}   brBACSCode2  :  String[45];   { }
              {079}   brBACSCode3  :  String[31];   { }

              {110}   brAccNOM     :  LongInt;      {  Bank Account G/L}

              {115}   brBankProd   :  Word;         {  Bank Product Selected }

              {126}   brPayPath    :  String[60];   {  Payments output path }

              {187}   brPayFileName:  String[60];   {  Payments filename }

              {248}   brRecFileName:  String[60];   {  Receipts filename}

              {309}   brStatPath   :  String[60];   {  Statement Path }

              {370}   brSwiftRef1  :  String[60];   {  Ref 1}


              {431}   brSwiftRef2  :  String[60];   {  Ref 2}

              {492}   brSwiftRef3  :  String[60];   {  Ref 2}

              {553}   brSwiftBIC   :  String[11];   {  SWIFT BIC Cide }

              {565}   brRouteCode  :  String[35];   { SWIFT Routing code }

              {601}   brChargeInst :  String[5];    { Charging instructions}

              {606}   brRouteMethod:  Char;         { Routine method}

                      brLastUseDate : LongDate;

                      brSortCode   : string[6];

                      brAccountCode : string[12];

                      brBankRef     : string[18];

                      brUserID     :  string[10];
              {607}   Spare        :  Array[1..109] of Byte;

              {766}


                   end;

          eBankHRecType= Record
          {RecPFix = LteBankRCode  =  'K'}
          {SubType = '4'}

               //PR Change ebStatInd from String[10] to Word
              {002}   ebHCode1     :  String[30];   { Rec Code }
              {033}   ebHCode2     :  String[45];   { }
              {079}   ebHCode3     :  String[31];   { }

              {110}   ebAccNOM     :  LongInt;      {  Bank Account G/L }

              {115}   ebStatRef    :  String[10];   {  Bank Statement ref }

              {126}   ebStatInd    :  Word;         {  Status Indicator }

              {137}   ebSourceFile :  String[100];  {  Source filename }

              {238}   ebIntRef     :  Longint;      {  Internal Folio Reference for relational link to eb Lines }

              {243}   ebStatDate   :  LongDate;     {  Statement Date }


              {251}   Spare        :  Array[1..524] of Byte;

              {766}


                   end;


          eBankLRecType= Record
          {RecPFix = LteBankRCode  =  'K'}
          {SubType = '5'}

              //PR Added ebGLCode;
              {002}   ebLCode1     :  String[30];   { Rec Code }
              {033}   ebLCode2     :  String[45];   { }
              {079}   ebLCode3     :  String[31];   { }

              {110}   ebLineNo     :  LongInt;      {  eBank statement line no }

              {115}   ebLineDate   :  LongDate;     {  Bank Statement Line Date }

              {123}   ebLineRef    :  String[40];   {  Statement line Ref }

              {163}   ebLineValue  :  Double;       {  Statement line value }

              {171}   ebLineIntRef :  Longint;      {  Internal Folio Reference for relational link to eb Lines }

              {176}   ebMatchStr   :  String[30];   {  Statement matching info }

                      ebGLCode     :  longint;

                      ebLineRef2   :  String[40];


              {206}   Spare        :  Array[1..513] of Byte;

              {766}


                   end;
    {$ENDIF}
  {$ENDIF}





      MLocPtr   =  ^MLocRec;


      MLocRec   =  Record
                        RecPfix   :  Char;         {  Record Prefix }
                        SubType   :  Char;         {  Subsplit Record Type }



                        Case SmallInt of

                          1  :  (MLocLoc       :  MLocLocType);
                          2  :  (MStkLoc       :  MStkLocType);
                          3  :  (SdbStkRec     :  sdbStkType);
                          4  :  (CuStkRec      :  CuStkType);
                          5  :  (TeleSRec      :  TeleCustType);
                          6  :  (EMUCnvRec     :  EMUCnvType);

                          7  :  (PassDefRec    :  tPassDefType);

                          {$IFDEF ExWin}
                            8  :  (AllocCRec   :  AllocCType);

                            9  :  (brBinRec    :  brBinRecType);

                            {$IFDEF LTE01}
                             10  :  (BnkRHRec    :  BnkRHRecType);

                             11  :  (BnkRDRec    :  BnkRDRecType);

                             12  :  (BACSDbRec   :  BACSDbRecType);

                             13  :  (eBankHRec   :  eBankHRecType);

                             14  :  (eBankLRec   :  eBankLRecType);
                            {$ENDIF}
                          {$ENDIF}

                      end;



      MLoc_FilePtr   =   ^MLoc_FileDef;

      MLoc_FileDef   =   Record
                               RecLen,
                               PageSize,
                               NumIndex  :  SmallInt;
                               NotUsed   :  LongInt;
                               Variable  :  SmallInt;
                               Reserved  :  array[1..4] of Char;
                               KeyBuff   :  array[1..MLNofSegs] of KeySpec;
                               AltColt   :  AltColtSeq;
                             end;


   { ==== Some Password types moved here to get round DOS compiler symbol limits == }

   { ================ Login Check Record ================ }


    PassEntryType = Record
               {002}  Login     :  String[12];   {  Login Name }
               {015}  Pword     :  String[9];    {  PassWord }
               {024}  Access    :  Array[0..255] of Byte;
                                                 {  Menu / User Access }
               {280}  LastPno   :  Byte;         {  Last Printer Used  }
                    end;



    { ================ Password Check List =============== }

    PassListType  = Record
              {002}   PassList  :  String[12];   { Group+No }
              {015}   PassGrp   :  Byte;         { Group - for ordering }
              {016}   PassNo    :  Byte;         { No Within Group }

              {017}   Spare1    :  Array[1..8] of
                                     Byte;
              {026}   PassDesc  :  String[80];   { Access Description }
              {106}   PassPage  :  Byte;         { (Passwrod page x 256) + PassNo gives entry }
              {107}   PassLNo   :  LongInt;      { Extended number }
              {111}   Spare2    :  Array[1..171] of
                                     Byte;


                    end;

    { ================ Help Record =============== }

    HelpType     =  Record
              {001}   Spare1    :  Byte;         { Ndx Ofset Marker }
              {002}   HelpNo    :  Longint;      { Help Lookup No. }
              {006}   HelpOrd   :  LongInt;      { Line No. Within Help }
              {010}   HelpStop  :  Char;         { End Key Marker to stop incomplete ndx being returned }

              {011}   Spare2    :  Array[1..3] of { If this changes change fullhelpKey! }
                                     Byte;

              {014}   Spare3    :  Array[1..10] of
                                     Byte;

              {025}   HelpMsg   :  String[255];

              {280}   Spare4    :  Byte;
                    end;


    { ================ Notes Record db List =============== }

    NotesType    =  Record
              {002}   NoteNo    :  String[12];   { Folio/CustCode + NType + LineNo}

              {015}   NoteDate  :  LongDate;

              {021}   Spare3    :  Byte;

              {025}   NoteAlarm :  LongDate;

              {031}   Spare4    :  Array[1..3] of Byte;

              {037}   NoteFolio :  String[10];

              {047}   NType     :  Char;

              {048}   Spare1    :  Array[1..2] of
                                     Byte;

              {050}   LineNo    :  LongInt;

              {055}   NoteLine  :  String[100]; { Note Line }

              {156}   NoteUser  :  String[10];  { Note owner }

              {167}   TmpImpCode:  String[16];  { TmpHolding code for import }

              {182}   ShowDate  :  Boolean;
              {183}   RepeatNo  :  SmallInt;    { Repeat every X days}
              {186}   NoteFor   :  String[10];  { Note For Filter }
              {196}   Spare2    :  Array[1..83] of Byte;
                    end;


    { ================ Matched payments Record db List =============== }

    MatchPayType =  Record
                      {002}   DocCode   :  String[12];

                      {014}   Spare1    :  Array[1..10] of
                                             Byte;

                      {025}   PayRef    :  String[10];

                      {035}   SettledVal:  Real;           {* Level 0 settled *}

                      {041}   OwnCVal   :  Real;           {* Own currency settled *}

                      {047}   MCurrency :  Byte;
                      {048}   MatchType :  Char;           {* A for Accounting based, O for ,orders *}

                      {049}   AltRef    :  String[10];     {* Alt YourRef *}

                      {059}   RCurrency :  Byte;           {* Currency of Receipt Import mode *}

                      {060}   RecOwnCVal:  Double;         {* Own Currency Value of Receipt Import mode *}

                      {068}   Spare2    :  Array[1..212] of Byte;
                            end;



    { ================ Bill of Materials List =============== }

    BillMatType  =  Record
              {002}   StockLink :  String[12];

              {014}   Spare1    :  Array[1..10] of
                                     Byte;

              {025}   BillLink  :  String[10];

              {035}   QtyUsed   :  Real;           {* Batch Qty Used *}

              {041}   QtyCost   :  Real;           {* Unit Cost of Item *}

              {047}   QCurrency :  Byte;           {* Unit Cost Currency *}

              {049}   FullStkCode                  {* Actual Stock Code  *}
                                :  String[20];

              {069}   FreeIssue :  Boolean;

              {070}   QtyTime   :  LongInt;

              {074}   Spare2    :  Array[1..207] of Byte;
                    end;

   { ================ Move Nominal Code db List =============== }

    MoveNomType =  Record
              {002}   MNomCode  :  String[12];

              {014}   Spare1    :  Array[1..10] of
                                     Byte;

              {025}   SecondKey :  String[10];

              {035}   MoveCode  :  LongInt;        {* Nominal Code to be moved *}

              {039}   MoveFrom  :  LongInt;        {* Nominal Group Moving From *}

              {043}   MoveTo    :  LongInt;        {* Nominal Group Moving Too *}

              {047}   MoveType  :  Char;           {* Nominal Type Change *}

              {048}   Spare2    :  Array[1..233] of Byte;
                    end;



    { ================ Move Nominal Code db List =============== }

    MoveStkType =  Record
              {002}   MStkCode  :  String[16];

              {014}   Spare1    :  Array[1..6] of
                                     Byte;

              {025}   SecondKey :  String[10];

              {036}   MoveCode  :  String[16];

              {053}   MFromCode :  String[16];

              {070}   MToCode   :  String[16];

              {087}   NewStkCode:  String[16];     {* New Stock Code *}

              {103}   Spare2    :  Array[1..178] of Byte;
                    end;


  {$IFDEF ExWin}

    { ================ Move Windows Record =============== }

    MoveCtrlType= Record
              {002}   MlocC     :  String[10];      {  Move Id Code }

              {012}   Spare1    :  Array[1..16] of Byte;

              {029}   SCodeOld  :  String[20];      {  Original Stock Code }

              {050}   SCodeNew  :  String[20];      {  New Stock Code  }

              {070}   MoveStage :  Byte;

              {071}   OldNCode,
              {075}   NewNCode  :  LongInt;         {  Old/New Nom Code }

              {079}   NTypOld,                      {  Old / New Types }
              {080}   NTypNew   :  Char;

              {082}   MoveKey1  :  String[50];     {  Position key for stage }
              {133}   MoveKey2  :  String[50];     {  Position key for stage }

              {183}   WasMode   :  Byte;            {  Mode we were in }
              {185}   SGrpNew   :  String[20];      {  New Stk Grp }
              {206}   SUser     :  String[10];      {  User Name }
              {216}   FinStage  :  Boolean;         {  End of Stage Marker }
              {217}   ProgCounter
                                :  LongInt;         {Record of how far we got}
              {221}   MIsCust   :  Boolean;         {During account renumber, what gender was it}
              {222}   Spare2    :  Array[1..57] of Byte;


                   end;

        { ================ Bacs Multi User Ctrl Record =============== }

    BacsUType= Record
              {002}   UsrCode   :  String[12];      {  '!'+RunNo }

              {014}   Spare1    :  Array[1..10] of Byte;

              {025}   Spare3K   :  String[10];      {  Spare K }

              {036}   OpoName   :  String[10];      {Login name}

              {047}   StartDate :  LongDate;        {LogIn date}

              {056}   StartTime :  String[6];       {Login time}

              {063}   WinLogName:  String[50];      {Windows logged in user name}

              {114}   WinCPUName:  String[50];      {Windows Computer name}

              {164}   LIUCount  :  LongInt;         {Logged in recorded user}

              {170}   Spare2    :  Array[1..113] of Byte;


                   end;

  {$ENDIF}

   { ================ Security Validation Record =============== }

    VSecureType= Record
              {002}   SecCode   :  String[12];      {  Lookup Code }

              {014}   Spare1    :  Array[1..10] of Byte;

              {025}   ExUsrRel  :  String[10];

              {035}   UsrRelDate:  Real;

              {042}   ExRelease :  String[10];

              {052}   RelDate   :  Real;

              {058}   ISN       :  ISNArrayType;

              {064}   DemoFlg   :  Boolean;

              {066}   Modules   :  Array[1..10] of String[10];

              {176}   ModRelDate:  Array[1..10] of Real;

              {236}   LastDaily :  LongInt;

              {240}   Spare2    :  Array[1..41] of Byte;


                    end;

  { ================ Additional Irish VAT info Record =============== }


    IRVInpType  =  Record
                     {001}   T11Codes  :  String[35];
                     {037}   T21Codes  :  String[35];
                     {073}   T22Codes  :  String[35];
                     {109}   Signtry   :  String[35];   {ESL Signitory name}
                     {145}   VIESType  :  String[2];
                     {148}

                   end;


    IrishVATType= Record
              {002}   IRVInpCode
                                :  String[10];      {  AccessKey, Mode+StopK }

              {012}   Spare1    :  Array[1..16] of Byte;

              {029}   SecondKey :  String[20];      {  Not Used}

              {050}   ThirdK    :  String[10];

              {060}   Spare     :  Byte;

              {061}   IRVInpRec :  IRVInpType;

              {148}   Spare2    :  Array[1..121] of Byte;


                   end;



  CurrType  =  Array[0..CurrencyType] of
               Record
                 SSymb  :  String[3];
                 Desc   :  String[11];
                 CRates :  CurrTypes;
                 PSymb  :  String[3];
               end;


  CurrRec   =  Record
                 IDCode     :   String[3];
                 Currencies :   CurrType;
               end; {Rec..}

  GCurType   =  Record
                 TriRates   :   Array[0..CurrencyType] of Double;
                 TriEuro    :   Array[0..CurrencyType] of Byte;
                 TriInvert  :   Array[0..CurrencyType] of Boolean;
                 TriFloat   :   Array[0..CurrencyType] of Boolean;

                 Spare      :   Array[1..651] of Byte;
               end; {Rec..}

  GCurRec   =  Record
                 IDCode     :   String[3];
                 GhostRates :   GCurType;
               end; {Rec..}





{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}




Begin


end.