
Type

      {* Please note Strings are Pascal type Length strings with position 0 holding
         the length of the String, and does not have a null termination, consequently
         the string will occupy 1 byte more than stated. Most important when
         calculating record sizes! *}

      {* Please note WordBool is a Borland Delphi type which is 2 bytes long and
         contains 0 for false, and 1 for true *}

{* ====================== Customer/Supplier Record ========================== *}

TBatchCURec =  Record
                CustCode   : string[6];     (*  customer code , must not be blank *)
                CustSupp   : Char;          {*  Must be C or S *}
                Company    : string[30];    (*  Company Name *)
                AreaCode   : String[4];     {* Free Type Sort Field *}
                RepCode    : String[4];     {*   "   "    "     "   *}
                RemitCode  : String[10];    {* Account Code of Remit Account *}
                VATRegNo   : String[30];    {* VAT Registration No.  *}
                Addr       : Array[1..5] of
                               String[30];  {* Addr1-5 *}
                DespAddr   : WordBool;      {* Despatch Address *}
                DAddr      : Array[1..5] of
                               String[30];  {* Despatch Addr1-5 *}
                Contact    : String[25];    {* Contact Name *}
                Phone      : string[20];    {* Phone No. *}
                Fax        : string[20];    {* Fax No. *}
                RefNo      : String[10];    {* Our Code with them *}
                TradTerm   : WordBool;      {* Special Terms *}
                STerms     : Array[1..2] of
                               String[60];  {* 2 Lines of Terms *}
                Currency   : SmallInt;
                VATCode    : Char;
                PadChar1   : Char;          {* Padding Char for Word Alignment *}
                PayTerms   : SmallInt;      {* Number of days, 0-30, 999... *}
                CreditLimit: Double;
                Discount   : Double;
                CreditStatus
                           : SmallInt;
                CustCC     : String[3];
                CDiscCh    : Char;
                CustDep    : String[3];
                PadChar2   : Char;          {* Padding Char for Word Alignment *}
                EECMember  : WordBool;      {* VAT Inclusion for EEC *}
                IncStat    : WordBool;      {* Include in Statement  *}
                DefNomCode : LongInt;       {* Default Nominal Code  *}
                DefMLocStk : String[3];     {* Default Multi Loc Stock *}
                AccStatus  : SmallInt;      {* On Hold, Closed, See notes *}
                PayType    : Char;          {* [B]acs,[C]ash *}
                BankSort   : String[6];     {* Bank Sort Code *}
                BankAcc    : String[8];     {* Bank Account No. *}
                BankRef    : String[18];    {* Bank additional ref, ie Build Soc.Acc *}
                LastUsed   : String[8];     {* Date last updated *}
                {Added on 7.1.97}
                Phone2     : String[20];    {* Second Phone No. *}
                UserDef1,
                UserDef2   : String[20];    {* User Definable strings *}
                SOPInvCode : String[6];     {* Ent SOP Invoice Code *}
                PadChar3   : Char;          {* Padding Char for Word Alignment *}
                SOPAutoWOff: WordBool;      {* Auto write off Sales Order *}
                BOrdVal    : Double;        {* Book order value *}
                {* Added on 23/07/97 *}
                DefCOSNom  : LongInt;       {* Cost of Sales Nominal Code *}
                DefCtrlNom : LongInt;       {* Sales Nominal Code *}
                {* Added on 20.1.98 *}
                DirDeb     : SmallInt;      {* Current Direct Debit Mode *}
                CCDSDate   : String[6];     {* Credit Card Start Date *}
                CCDEDate   : String[6];     {* Credit Card End Date *}
                CCDName    : String[30];    {* Name on Credit Card *}
                CCDCardNo  : String[19];    {* Credit Card No *}
                CCDSARef   : String[4];     {* Credit Card Switch Ref *}

                {* Added on 17.11.98 *}
                DefSetDDays: SmallInt;      {* Default Sett.Discount Days *}
                PadChar4   : Array [1..2]   {* Padding Char for Word Alignment *}
                               of Char;
                DefSetDisc : Double;        {* Default Sett.Discount % *}

                DefFormNo  : SmallInt;      {* Default Form Set No., 0-99, default 0 *}

                Spare      : Array[1..165]  { should be 165 }
                               of Char;     {* change 100-256, 256-248, 248-176 *}
                LastChar   : Char;          {* Padding Char for Word Alignment *}
              end;

{* ====================== Transaction Header Record ========================= *}

TBatchTHRec = record
                RunNo     :  Longint;     { Read Only, posting Run No. }

                CustCode  :  String[6];   { Lookup Account Code }
                OurRef    :  String[9];   { Doc Number }
                PadChar1  :  Array[1..3] Of Char; { Padding Char for Word Alignment }
                FolioNum  :  Longint;     { Audit No.}
                Currency  :  SmallInt;    { Currency of Document }
                AcYr,
                AcPr      :  SmallInt;    { Posting Period & Yr }
                DueDate   :  String[8];   { Date Transaction Due }
                TransDate :  String[8];   { Transaction / Tax Point Date }
                CoRate    :  Double;      { Company Currency Rate }
                VATRate   :  Double;      { Daily/Tax Rate }
                YourRef   :  String[10];  { Account Ref - free text}
                LongYrRef :  String[20];  { Additional reference field }
                LineCount :  LongInt;     { Transaction line count }
                TransDocHed
                          :  String[3];   { Transaction Type, ie 'SIN' }
                InvVatAnal:  Array[0..16]of { Change from 9 to 16 on 10.06.97 }
                             Double;      { VAT Analysis S,Z,E,1 TO 9,A,D,T,X }
                InvNetVal :  Double;      { Total Posting Value of Transaction }
                InvVat    :  Double;      { Total Tax Content }
                DiscSetl  :  Double;      { Discount Avail/Take }
                DiscSetAm :  Double;      { Actual Value of Settle Discount }
                DiscAmount:  Double;      { Discount Amount     }
                DiscDays  :  SmallInt;    { No Days Disc Avail }
                DiscTaken :  WordBool;    { Discount Taken }
                Settled   :  Double;      { R/O Amount Paid Off }
                TransNat  :  SmallInt;    { VAT Nature of Transaction }
                TransMode :  SmallInt;    { VAT Mode of Transport     }
                HoldFlg   :  SmallInt;    { Hold Status }
                PadChar2  :  Array[1..2] Of Char; { Padding Character for Word Alignment }
                TotalWeight
                          :  Double;      { Order Weight Details }
                DAddr     :  Array[1..5] of
                               String[30];{ Delivery Address }
                PadChar3  :  Char;         { Padding Character for Word Alignment }
                TotalCost :  Double;      { Total value of cost prices for profitablity }
                PrintedDoc:  WordBool;    {* R/O This Document has been printed *}
                ManVAT    :  WordBool;    {* If Set, prevents re-calclation of VAT *}
                DelTerms  :  String[3];   {* VAT Delivery Terms *}
                OpName    :  String[10];  {* Operators User Name *}
                {Add on 7.1.97}
                DJobCode  :  String[10];  {* Default Document Job Code *}
                DJobAnal  :  String[10];  {* Default Document Anal Code *}
                PadChar4  :  Array[1..3] Of Char; { Padding Character for Word Alignment }
                TotOrdOS  :  Double;      {* Value of Order Outstanding *}
                DocUser1,
                DocUser2  :  String[20];  {* User def fields *}
                {* Add for TSH *}
                EmpCode   :  String[6];   {* Employee Code for TSH *}
                {* Add on 12.01.98 *}
                PadChar5  :  Char;        {* Padding Character for Word Alignment *}
                Tagged    :  WordBool;    {* Doc Mark- Read Only *}
                thNoLabels:  SmallInt;    {* No. of labels to be printed *}
                PadChar6  :  Array[1..2] Of Char;     {* Padding Characters for Word Alignment *}

                {* Add on 19.03.98 *}
                CtrlNom   :  LongInt;    {* Debtor/Creditor Control Nominal *}

                Spare     :  Array[1..189] of Char; {change 100-256-200-197-193 }
                Spare2    :  Array[1..2] Of Char;
                LastChar  :  Char; { Padding Character for Word Alignment }
              end;


{* =============== Transaction Detail Line ================================== *}

TBatchTLRec = Record
                TransRefNo  :  String[9];  {* Parent Transaction number *}
                PadChar1    :  Array[1..2] Of Char; { Padding Character for Word Alignment }
                LineNo      :  LongInt;     { Array / Line No}
                NomCode     :  LongInt;     { Nominal Code }
                Currency    :  SmallInt;    { Transaction Currency [0-30]}
                PadChar2    :  Array[1..2] Of Char; { Padding Character for Word Alignment }
                CoRate      :  Double;      { Line Currency Rate }
                VATRate     :  Double;      { Line VAT Rate }
                CC          :  String[3];   { Cost Centre Code }
                Dep         :  String[3];   { Department Code }
                StockCode   :  String[16];  { Stock Code }
                PadChar3    :  Array[1..3] Of Char; { Padding Character for Word Alignment }
                Qty         :  Double;      { Qty!}
                QtyMul      :  Double;      { Qty Multiplier Factor }
                NetValue    :  Double;      { Line Total excluding Tax }
                Discount    :  Double;      { Amount/% }
                VATCode     :  Char;        { VATCode }
                PadChar4    : Array[1..3] Of Char; { Padding Character for Word Alignment }
                VAT         :  Double;      { Tax Line Content }
                Payment     :  WordBool;    { Line Type  }
                DiscountChr :  Char;        { Flag to indicate if disc is amount or % }
                PadChar5    :  Char; { Padding Character for Word Alignment }
                QtyWOFF,                    { Total Qty Written OFF }
                QtyDel,                     { Total Qty Physicaly delivered +WOFF - Qty = OS }
                CostPrice   :  Double;
                CustCode    :  String[6];   { Account Code }
                LineDate    :  String[8];   { Line Transaction date. SPOP= Delivery Date }
                Item        :  String[3];
                Desc        :  String[55];  { Line Desc }
                LWeight     :  Double;      { Weight of Sales Unit in Kg}
                MLocStk     :  String[3];   { Multi stock location code *}
                {* Add for TSH *}
                JobCode     :  String[10];  { Job Code }
                AnalCode    :  String[10];  { Job Analysis Code }
                TSHCCurr    :  SmallInt;    { Charge Currency for Job Costing Time Sheet }

                DocLTLink   :  SmallInt;    { Doc Line Type Link }
                Spare3      :  Array[1..2] Of Char;
                KitLink     :  LongInt;     { Folio No. of parent Stock code for kit line }
                FolioNum    :  LongInt;     { Folio No. Of Transaction header }

                {* Added on 3.12.97 *}
                LineType    :  Char;        { Transaction Line Type }

                {* Added on 27.01.97 *}
                Reconcile   :  Byte;        { Status of item for reconciling ie cleared etc }

                {* Added on 14.08.98 *}
                PadChar6    :  Array [1..2] Of Byte;
                SOPLink     :  LongInt;     { Folio No. of Parent Order Line *}
                SOPLineNo   :  LongInt;     { Folio No. of Prarent ABSLineNo *}

                {* Added on 10.09.98 *}
                ABSLineNo   :  LongInt;     { Absolute, non moveable line no. *}

                Spare       :  Array[1..48] of Char;  {* change from 100 *}
                Spare2      :  Array[1..3] Of char;
                LastChar    :  Char;        { Padding Character for Word Alignment }
              end;


TBatchLinesRec  =  Array[1..190] of TBatchTLRec; {* Memory array of entire transaction lines *}

TSaleBandsRec =  Record
                   Currency   :  SmallInt;  { Currency of Band }
                   PadChar1   :  Array [1..2] Of Char; { Padding Char for Word Alignment }
                   SalesPrice :  Double;    { Price of Band    }
                   PadChar2   :  Array [1..3] Of Char;
                   LastChar   :  Char; { Padding Character for Word Alignment }
                 end;


TSaleBandAry  =  Array[1..8] of TSaleBandsRec;

TBatchSKRec   =  Record
                   StockCode    :  String[16];         { Stock Code }
                   Desc         :  Array[1..6] of      { Multiple Descriptions }
                                     String[35];
                   AltCode      :  String[16];         { Secondary Lookup Key }
                   SuppTemp     :  String[6];          { Preferred Supplier }
                   PadChar1     :  Array [1..3] Of Char; { Padding Characters for Word Alignment }
                   NomCodeS     :  Array[1..5]         { 1 Sales Nominal Code }
                                     Of LongInt;       { 3 Profit & Loss Closing Stock }
                                                       { 2 Cost of Sales Nominal }
                                                       { 4 Balance Sheet }
                                                       { 5 WIP Nominal Code }
                   MinFlg       :  WordBool;           { Min ROL Flag }
                   PadChar2     :  Array [1..2] Of Char; { Padding Characters for Word Alignment }
                   StockFolio   :  LongInt;            { Numerical Equivalent Code }
                   StockCat     :  String[16];         { Code of Parent on Tree }
                   StockType    :  Char;               { History & Tree Type, H/P/D/M/X }
                   UnitK        :  String[07];         { Descriptive Stocking Unit Qty }
                   UnitS        :  String[07];         {      "      Selling    "   "  }
                   UnitP        :  String[07];         {      "      Purchase   "   "  }
                   PCurrency    :  SmallInt;           { Cost Price Currency }
                   CostPrice    :  Double;             { Last Cost Price / Stock Valuation Price }
                   SaleBands    :  TSaleBandAry;       { Multiple Selling Bands A-H }
                   SellUnit     :  Double;             { Selling Qty Multiple }
                   BuyUnit      :  Double;             { Purchase Qty   "     }
                   VATCode      :  Char;               { Default VAT Lookup }
                   CC           :  String[3];          { Cost Centre / Dep Anal }
                   Dep          :  String[3];
                   PadChar3     :  Array [1..3] Of Char; { Padding Characters for Word Alignment }
                   QtyInStock,                           { Physical Stock }
                   QtyPosted,                            { Physical Posted Stock }
                   QtyAllocated,                         { Backorder Qty }
                   QtyOnOrder,                           { OnOrder Qty }
                   QtyMin,                               { Min Stock Level Qty }
                   QtyMax,                               { Max   "     "    "  }
                   ROQty        :  Double;             { Qty Orded this order }
                   CommodCode   :  String[10];         { VAT Commodity Code }
                   PadChar4     :  Char;               { Padding Character for Word Alignment }
                   SWeight      :  Double;             { Sales  Unit Weight }
                   PWeight      :  Double;             { Purchase "    "    }
                   UnitSupp     :  String[10];         { Supplimentry unit }
                   PadChar5     :  Char;               { Padding Character for Word Alignment }
                   SuppSUnit    :  Double;             { No Units in Sales unit }
                   BinLoc       :  String[08];         { Physical location in stores }
                   PadChar6     :  Char;               { Padding Character for Word Alignment }
                   CovPr        :  SmallInt;           { Amount of periods to scan back to calc cover }
                   CovPrUnit    :  Char;               { Period calc unit of measure, D/W/M }
                   PadChar7     :  Char;               { Padding Character for Word Alignment }
                   CovMinPr     :  SmallInt;           { Amount of Cover required in periods }
                   CovMinUnit   :  Char;               { Cover amount unit D/W/M }
                   Supplier     :  String[06];         { Master Supplier Reference }
                   CovSold      :  Double;             { Qty sold over cover period }
                   UseCover     :  WordBool;           { Use Cover on this record }
                   CovMaxPr     :  SmallInt;           { Amount of Max Cover required }
                   CovMaxUnit   :  Char;               { Unit of Max Cover }
                   PadChar8     :  Char;               { Padding Character for Word Alignment }
                   ROCurrency   :  SmallInt;           { Purchase Order Currency }
                   ROCPrice     :  Double;             { Purchase Order Cost Price }
                   RODate       :  String[8];          {     "      "   Delivery Date }
                   StkValType   :  Char;               { Stk Valuation Type C,L,F,S,A }
                   PadChar9     :  Array [1..2] Of Char; { Padding Characters for Word Alignment }
                   QtyPicked    :  Double;             { Count of Qty Picked so Far }
                   LastUsed     :  String[8];          { Date Last updated }
                   {* Added on 14.07.97 *}
                   StBarCode    :  String[20];         { Bar Code }
                   StRoCostCentre
                                :  String[3];          { RO Cost Centre }
                   StRoDepartment
                                :  String[3];          { RO Department }
                   StLocation   :  String[3];          { Location }
                   StPricePack  :  WordBool;           { Price per Pack }
                   StDPackQty   :  WordBool;           { Show Qty as Cases }
                   StKitPrice   :  WordBool;           { Use BOM price, ignore component price }
                   StKitOnPurch :  WordBool;           { Explode kit on Purch transactions }

                   {* Added on 28.08.97 *}
                   StStkUser1   :  String[20];         { User Defined Field 1 }
                   StStkUser2   :  String[20];         { User Defined Field 2 }
                   PadChar10    :  Array [1..3] Of Char; { Padding Characters for Word Alignment }
                   LastChar     :  Char; { Last Character in record - used for VB alignment }
                 end;

{= History Balances search =}

{* Both the period and year can be specified in absolute, or relative terms.

   For example:-
                    Period      Year          Comments
                  |~~~~~~~~~|~~~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|

                      01         95       Returns value as @ Period 01/1995.
                      Blank      95       Returns value as @ Current period/1995.
                                          Current period is specified as set currently
                                          within Exchequer using the <F6> Hot key.

                      Blank     Blank     Returns value as @ Current Period/Current Year,
                                          As per Exchequer.

                      -1        Blank     Returns value as @ Last period/Current Year.

                      Blank       -1      Returns value as @ Current Period/Last Year.

                       YTD      Blank     Returns total Year to Date value for the current year.

                       YTD        -3      Returns total Year to Date value for 3 years prior to the
                                          the current year.

   All combinations can be combined within the constraints of +/-99 as a legal value. *}

THistoryBalRec  =  Record
                     Period   :  String[5];  {* Period; [+/-]N or YTD *}
                     Year     :  String[5];  {* Year; [+/-]N *}
                     Currency :  SmallInt;   {* 0-30 *}
                     PadChar1 :  Array [1..2] Of Char; { Padding Characters for Word Alignment }
                     Value    :  Double;     {* Returned value *}
                     PadChar2 :  Array [1..3] Of Char; { Padding Characters for Word Alignment }
                     LastChar :  Char;    { Last Character in record - used for VB alignment }
                   end;

{ ===============   G/L Nominal   16.12.96 ==================== }

TBatchNomRec    =  Record
                     NomCode    :  Longint;   { Nominal Code }
                     Desc       :  String[30];
                     PadChar1   :  Char;      { Padding Characters for Word Alignment }
                     Cat        :  LongInt;   { Parent Code }
                     NomType    :  Char;      { Heading / A,B,C }
                     PadChar2   :  Char;      { Padding Characters for Word Alignment }
                     NomPage    :  WordBool;  { Page At end of this }
                     SubType    :  WordBool;  { Sub Total at end }
                     Total      :  WordBool;  { Show Balance only or Cr/Dr }
                     CarryF     :  LongInt;   { Nom Code to Carry Forward to }
                     ReValue    :  WordBool;  { Code is to be revalued }
                     PadChar3   :  Char;      { Padding Characters for Word Alignment }
                     LastChar   :  Char;      { Last Character in record - used for VB alignment }
                   end;

{ =============== BOM 18.12.96 ====================== }

TBatchBOMRec    =  Record
                     StockCode  :  String[16]; { Stock Code }
                     PadChar1   :  Array[1..3] Of Char; { Padding Characters for Word Alignment }
                     QtyUsed    :  Double;     { Qty used in BOM }
                     QtyCost    :  Double;     { Cost }
                     PadChar2   :  Array [1..3] Of Char; { Padding Characters for Word Alignment }
                     LastChar   :  Char; { Last Character in record - used for VB alignment }
                   end;

TBatchBOMLinesRec  =   Array[1..500] of TBatchBOMRec;

{ ================ Serial No 20.12.96 ================ }
TBatchSRRec     =  Record
                     SerialNo   :  String[20]; {  Actual Serial No. }
                     BatchNo    :  String[10]; {  Seperate Batch No.}
                     DateOut    :  String[8];  {  Date Out }
                     PadChar1   :  Array[1..3] Of Char; { Padding Characters for Word Alignment }
                     SerCost    :  Double;     {  CostPrice }
                     SerSell    :  Double;     {  Selling Price }
                     CurCost    :  SmallInt;   {  Currency of Cost Price }
                     CurSell    :  SmallInt;   {  Currency of Selling Price }
                     InMLoc     :  String[10]; {  Location Filter }
                     OutMLoc    :  String[10]; {  Location Filter }
                     PadChar2   :  Array [1..2] Of Char; { Padding Characters for Word Alignment }
                     BuyQty     :  Double;
                     QtyUsed    :  Double;
                     Sold       :  WordBool;
                     PadChar3   :  Char; { Padding Characters for Word Alignment }
                     LastChar   :  Char; { Last Character in record - used for VB alignment }
                   end;

TBatchSRLinesRec  =   Array[1..500] of TBatchSRRec;

{ ==================== Job Header Record 10.02.97 ======================= }

TBatchJHRec     =   Record
                     JobCode   :  String[10];   { Job Code }
                     JobDesc   :  String[30];   { Job Description }
                     PadChar1  :  Array[1..2] Of Char; { Padding Characters for Word Alignment }
                     JobFolio  :  LongInt;      { Job Folio No }
                     CustCode  :  String[6];    { Customer Code }
                     JobCat    :  String[10];   { Job Category }
                     JobAltCode:  String[10];   { Job Alternative Code }
                     PadChar2  :  Char;         { Padding Characters for Word Alignment }
                     Completed :  WordBool;     { Completed Status }
                     Contact   :  String[25];   { Contact Person }
                     JobMan    :  String[25];   { Manager Name }
                     ChargeType:  Char;         { Type of Charge }
                     PadChar3  :  Array [1..3] Of Char; { Padding Characters for Word Alignment }
                     QuotePrice:  Double;       { Quote Price }
                     CurrPrice :  SmallInt;     { Currency of Price }
                     StartDate :  String[8];    { Job Start Date }
                     EndDate   :  String[8];    { Job End Date }
                     RevEDate  :  String[8];    { Revised Completion Date }
                     SORRef    :  String[10];   { Sales Order No. }
                     VATCode   :  Char;         { VAT Code }
                     JobAnal   :  String[3];    { Job Analysis Code }
                     JobType   :  Char;         { Job Type }
                     JobStat   :  Char;         { Status of Job }
                     LastChar  :  Char;         { Last Character in record - used for VB alignment }
                   end;

{ ====================  Multi Location Stock 29.04.97 ======================= }

TBatchSLRec      = Record
                     lsStkCode    :  String[16];   { Stock Code }
                     lsLocCode    :  String[3];    { Loc Code }
                     PadChar1     :  Array [1..3] Of Char; { Padding Characters for Word Alignment }
                     lsQtyInStock :  Double;       { Actual Stock }
                     lsQtyOnOrder :  Double;       { OnOrder }
                     lsQtyAlloc   :  Double;       { Allocated }
                     lsQtyPicked  :  Double;       { Picked }
                     lsQtyMin     :  Double;       { Min    }
                     lsQtyMax     :  Double;       { Max    }
                     lsQtyFreeze  :  Double;       { Freeze Qty }
                     lsRoQty      :  Double;       { Re-Order Qty }
                     lsRoDate     :  String[8];    { Re-Order Date }
                     lsRoCC       :  String[3];    { Re-Order CC}
                     lsRoDep      :  String[3];    { Re-Order Dep}
                     lsCC         :  String[3];    { Default CC}
                     lsDep        :  String[3];    { Default Dep}
                     lsBinLoc     :  String[10];   { Bin Location }
                     lsSaleBands  :  TSaleBandAry; { Pricing }
                     lsRoPrice    :  Double;       { Re-Order Price}
                     lsRoCurrency :  SmallInt;     {     "    Currency}
                     PadChar2     :  Array [1..2] Of Char; { Padding Characters for Word Alignment }
                     lsCostPrice  :  Double;       { Last Cost Price }
                     lsPCurrency  :  SmallInt;     {     "     Currency}
                     PadChar3     :  Array [1..2] Of Char; { Padding Characters for Word Alignment }
                     lsDefNom     :  Array[1..5]   { 1 Sales Nominal Code }
                                       Of LongInt; { 2 Cost of Sales Nominal }
                                                   { 3 Profit & Loss Closing Stock }
                                                   { 4 Balance Sheet Nominal }
                                                   { 5 WIP Nominal Code }
                     lsMinFlg     :  WordBool;     { Below min Flg}
                     lsTempSupp   :  String[10];   { Temp Supplier }
                     lsSupplier   :  String[10];   { Main Suppplier}
                     lsLastUsed   :  String[8];    { Last used rec }
                     PadChar4     :  Array [1..3] Of Char; { Padding Characters for Word Alignment }
                     lsQtyPosted  :  Double;       { Posted loc qty }
                     lsQtyTake    :  Double;       { Stock Take Qty }
                     Spare2       :  Array[1..310] of Char;
                     PadChar5  :  Char; { Padding Character for Word Alignment }
                     LastChar  :  Char; { Last Character in record - used for VB alignment }
                   end;

TBatchMLocRec  = Record
                  loCode       :  String[3];    { Master Location Code }
                  loName       :  String[45];   {    "       "    Name }
                  loAddr       :  Array[1..5] of
                                    String[30]; { Address 1 to 5 }
                  loTel        :  String[25];   { Tel     }
                  loFax        :  String[25];   { Fax     }
                  loemail      :  String[100];  { email   }
                  loModem      :  String[25];   { modem number }
                  loContact    :  String[30];   { Contact   }
                  PadChar1     :  Char;         { Padding Character for Word Alignment }
                  loCurrency   :  SmallInt;     { Def Currency }
                  loArea       :  String[5];    { Report Area }
                  loRep        :  String[5];    { Report Rep  }
                  loTag        :  WordBool;     { Tagged }
                  loNominal    :  Array[1..5]
                                    of LongInt; { Def Nom }
                  loCC         :  String[3];    { Def CC Dep }
                  loDep        :  String[3];    { Def CC Dep }
                  loUsePrice   :  WordBool;     { Override Price }
                  loUseNom     :  WordBool;     { Override Noms }
                  loUseCCDep   :  WordBool;     { Override CCDep}
                  loUseSupp    :  WordBool;     { Override Supplier}
                  loUseBinLoc  :  WordBool;     { Override Bin Loc }
                  Spare2       :  Array[1..225] of Char;
                  LastChar     :  Char; { Last Character in record - used for VB alignment }
                end;


{ ====================================================================== }

TBatchMatchRec  = Record
                    DebitRef  :  String[9];   { Ex.OurRef (SIN/PIN)}
                    CreditRef :  String[9];   { Ex.OurRef (SRC/PPY)}
                    DebitCr   :  SmallInt;    { Currency of Debit Amount }
                    CreditCr  :  SmallInt;    { Currency of Credit Amount }
                    DebitVal  :  Double;      { Value of Debit Amount in Debit Currency }
                    CreditVal :  Double;      { Value of Credit Amount in Credit Currency }
                    BaseVal   :  Double;      { Value of Amount Settled in Base Currency }
                    Spare     :  Array[1..256] of Char;
                    Spare2    :  Array [1..3] Of Char;
                    LastChar  :  Char;        { Last Character in record - used for VB alignment }
                  end;

{ ====================================================================== }

TBatchNotesRec  = Record
                   NoteSort :  String[3];   { ACC/STK/DOC }
                   NoteType :  Char;        { 1=General 2=Dated Notes }
                   NoteCode :  String[16];  { Account Code/Stock Code/Doc. No. }
                   NoteDate :  String[8];   { Optional Date for Note line (YYYYMMDD) }
                   AlarmDate:  String[8];   { Optional Date for Alarm (YYYYMMDD) }
                   AlarmSet :  Char;        { Set Alarm Y/N - Optional }
                   PadChar1 :  Char;    { Padding Character for Word Alignment }
                   LineNo   :  SmallInt;    { Notes Line No. }
                   User     :  String[8];   { User/Login Code }
                   NoteLine :  String[65];  { Note Line Content }
                   Spare    :  Array[1..256] of Char;
                   LastChar :  Char;         { Last Character in record - used for VB alignment }
                 end;


{ ====================================================================== }

TBatchCCDepRec  = Record
                    CCDepCode  :  String[3];   { Cost Centre/Department Code }
                    CCDepDesc  :  String[30];  { Description }
                    Spare      :  Array[1..256] of Char;
                    LastChar   :  Char;        { Last Character in record - used for VB alignment }
                  end;


{ ====================================================================== }

TBatchStkPriceRec  = Record
                      StockCode  :  String[16];   { Stock Code }
                      CustCode   :  String[6];    { Customer/Supplier Code }
                      Currency   :  SmallInt;         { Currency 0-29 }
                      PadChar1   :  Array [1..2] Of Char; { Padding Character for Word Alignment }
                      Qty        :  Double;       { Quantity }
                      Price      :  Double;       { Price before Discount }
                      DiscVal    :  Double;       { Discount Amount or % Value }
                      DiscChar   :  Char;         { Blank = Disc.Amount , % = Discount % }
                      Spare      :  Array[1..102] of Char;
                      LastChar  :  Char;          { Last Character in record - used for VB alignment }
                    end;


{ ====================================================================== }

TBatchVATRec  = Record
                 VATCode    :  Char;                 { VAT Code }
                 PadChar1   :  Array [1..3] Of Char; { Padding Character for Word Alignment }
                 VATRate    :  Double;               { VAT Rate }
                 PadChar2   :  Array [1..3] Of Char; { Padding Character for Word Alignment }
                 LastChar   :  Char;                 { Last Character in record - used for VB alignment }
               end;

{ ====================================================================== }

TBatchCurrRec = Record
                  Name        : String[11];           { Currency name }
                  ScreenSymb  : String[3];            { Screen Symbol }
                  PrinterSymb : String[3];            { Printer Symbol }
                  DailyRate   : Double;               { Daily Rate }
                  CompanyRate : Double;               { Company Rate }
                  PadChar1    : Array [1..3] Of Char; { Padding Character for Word Alignment }
                  LastChar    : Char;                 { Last Character in record - used for VB alignment }
                End; { TBatchCurrRec }

{ ====================================================================== }

TBatchSysRec  = Record
                  UserName   : String[45];     { Registered Users Name }
                  UserAddr   : Array[1..5] of  {      "       "   Address }
                                 String[30];
                  UserSort   : String[6];      {      "       "   Bank Sort Code }
                  UserAcc    : String[8];      {      "       "   Bank Account No. }
                  UserRef    : String[18];     {      "       "   Bank Reference }
                  UserBank   : String[25];     {      "       "   Bank Name }

                  ExPr,
                  ExYr       : SmallInt;       { Exch. Current Periods }
                  DirectCust : String[10];     { Direct SRI }
                  DirectSupp : String[10];     { Direct PPI }
                  PriceDP    : SmallInt;       { Sales Price Decimal Places }
                  CostDP     : SmallInt;       { Cost Price Decimal Places }
                  QuantityDP : SmallInt;       { Quantity Decimal Places }
                  MultiLocn  : SmallInt;       { Multi-Location Status, 0=Disabled,
                                                 1=Del.Address only, 2=Enabled}
                  UserVatReg : string[30];     { User's VAT registration number }
                  PadChar    : char;
                  PeriodsPerYr : smallint;     { Number of periods in a year }
                  CCDepts    : WordBool;       { Cost centres and departments in use ? }
                  IntraStat  : WordBool;       { Use Intrastat fields ? }
                  ExchangeRate : char;         { Company or daily rate ??? }
                  Spare      : Array[1..702] of Char;
                  LastChar   : Char;           { Last Character in record - used for VB alignment }
                end; { TBatchSysRec }

{ ====================================================================== }

TBatchAutoBankRec = Record
                      BankRef   :  String[40];      {  Bank Matching Reference }
                      PadChar1  :  Array [1..3] Of Char; { Padding Character for Word Alignment }
                      BankValue :  Double;          {  Statement value }
                      BankNom   :  LongInt;         {  Nominal Code }
                      BankCr    :  SmallInt;        {  Currency }
                      EntryOpo  :  String[10];      {  Entered by }
                      EntryDate :  String[8];       {  Entry Date }
                      {Added - 25.08.99}
                      AccountCode :  String[8];       { Bank Account Code }
                      SortCode    :  String[6];       { Sort Code }

                      Spare     :  Array[1..181] of Char;
                      LastChar  :  Char;            { Last Character in record - used for VB alignment }
                   end;

{ ====================================================================== }
{* To Import BOM Lines - Added on 20.08.98 *}

TBatchBOMImportRec  =  Record
                         PStockCode  :  String[16];  { Parent Stock Code }
                         MStockCode  :  String[16];  { BOM  Stock Code }
                         PadChar1    :  Array [1..2] Of Char; { Padding Character for Word Alignment }
                         QtyUsed     :  Double;      { Quantity Used }
                         DeleteStat  :  WordBool;    { Delete current BOM Lines Status }
                         Spare       :  Array[1..201] of Char;
                         LastChar    :  Char;                 { Last Character in record - used for VB alignment }
                       end;

{ ====================================================================== }

TBatchSerialRec   = Record
                      SerialNo  :  String[20];   {  Actual Serial No. }
                      BatchNo   :  String[10];   {  Seperate Batch No.}
                      StockCode :  String[16];   {  Stock Code }

                      InDoc     :  String[10];   {  Input Doc No. }
                      DateIn    :  String[8];    {  Date In }
                      PadChar1  :  Array [1..3] Of Char; { Padding Character for Word Alignment }
                      SerCost   :  Double;       {  CostPrice}
                      CurCost   :  SmallInt;     {  Currency Cost Price }
                      PadChar2  :  Array [1..2] Of Char; { Padding Character for Word Alignment }
                      BuyABSLine:  LongInt;      {  Purchase Line       }
                      BuyQty    :  Double;       {  Original Batch Qty }
                      InMLoc    :  String[3];    {  Location Filter }

                      OutDoc    :  String[10];   {  Output Doc No.}
                      DateOut   :  String[8];    {  Date Sold }
                      SerSell   :  Double;       {  Selling Price }
                      CurSell   :  SmallInt;     {  Selling Price Currency}
                      PadChar3  :  Array [1..2] Of Char; { Padding Character for Word Alignment }
                      SoldABSLine
                                :  LongInt;      {  ABS Line No of Doc Sold }
                      QtyUsed   :  Double;       {  Amount Used from  Batch }
                      OutMLoc   :  String[3];    {  Location Filter }

                      Sold      :  WordBool;     {  Sold Status }

                      BatchRec  :  WordBool;     {  Indicates this is soley a batch record }
                      BatchChild:  WordBool;     {  Read Only - Auto generated item to record sale doc for batch }

                      PadChar4  :  Array [1..2] Of Char; { Padding Character for Word Alignment }
                      CoRate    :  Double;       {  Company Rate }
                      DailyRate :  Double;       {  Daily Rate }

                      InOrdDoc  :  String[10];   {  Original In Order}
                      PadChar5  :  Char;         {  Padding Character for Word Alignment }
                      InOrdLine :  LongInt;      {  Line Number of original order }

                      OutOrdDoc :  String[10];   {  Original Out Order }
                      PadChar6  :  Char;         {  Padding Character for Word Alignment }
                      OutOrdLine:  LongInt;      {  Line Number of original order }

                      DateUseX  :  String[8];    {  Use by Date }
                      Spare     :  Array[1..194] of Char;
                      LastChar  :  Char;         { Last Character in record - used for VB alignment }
                   end;

{ ====================================================================== }

{* For Employee Record *}
TBatchEmplRec    = Record
                     EmpCode    :  String[6];     { Employee Code }
                     Supplier   :  String[6];     { Supplier Code }
                     EmpName    :  String[30];    { Employee Name }
                     Addr       :  Array[1..5] of { Addr1-5 }
                                     String[30];
                     Phone      :  String[20];    { Telephone }
                     Fax        :  String[20];    { Fax }
                     Mobile     :  String[20];    { Mobile }
                     EmpType    :  Char;          { Employee Type P/S/O }

                     PayNo      :  String[10];    { Payroll No }
                     CertNo     :  String[30];    { Certificate No }
                     CertExpiry :  String[8];     {     "      Expiry Date }
                     PadChar1   :  Char;          { Padding Character for Word Alignment }
                     UseORate   :  WordBool;      { Use pay rates setup for employee only }
                     UserDef1   :  String[20];    { User Defined Field 1 }
                     UserDef2   :  String[20];    { User Defined Field 2 }
                     CC         :  string[3];     { Default Cost Centre }
                     Dep        :  string[3];     { Default Dept }
                     Spare      :  Array[1..191] of Char;
                     LastChar   :  Char;         { Last Character in record - used for VB alignment }
                   end;

{ ====================================================================== }

{* For Job Analysis Code Record *}

TBatchJobAnalRec  =  Record
                       JAnalCode  :  String[10];  { Job Analysis Code }
                       JAnalDesc  :  String[30];  {  "     "     Description }
                       JAnalType  :  Char;        {  "     "     Type }
                       JAnalCatry :  Char;        {  "     "     Category }
                       WIPNomCode :  LongInt;     {  "     "     WIP Nominal Code }
                       PLNomCode  :  LongInt;     {  "     "     P&L Nominal Code }
                       LineType   :  Char;        {  "     "     Line Type }

                       Spare      :  Array[1..202] of Char;
                       LastChar   :  Char;         { Last Character in record - used for VB alignment }
                     end;


{ ====================================================================== }
{* Job Costing Time Rate Record *}

TBatchJobRateRec  =  Record
                       JEmpCode   :  String[10];    { Employee Code }
                       JRateCode  :  String[10];    { Job Rate Code }
                       JRateDesc  :  String[30];    { Job Rate Description }
                       JAnalCode  :  String[10];    { Job Analysis Code }
                       CostCurr   :  SmallInt;      { Time Cost Currency }
                       PadChar1   :  Array [1..2] Of Char; { Padding Character for Word Alignment }
                       Cost       :  Double;        { Time Cost }
                       ChargeCurr :  SmallInt;      { Time Charge Currency }
                       PadChar2   :  Array [1..2] Of Char; { Padding Character for Word Alignment }
                       ChargeRate :  Double;        { Time Charge Rate }
                       PayRollCode:  SmallInt;      { Payroll Code }
                       Spare      :  Array[1..201] of Char;
                       LastChar   :  Char;         { Last Character in record - used for VB alignment }
                     end;

{ ====================================================================== }
{* Job Costing For Discount Matrix by Customer and Stock - 20.11.98 *}

TBatchJobTypeRec = record
                     JTypeCode : string[3];  { Job type code }
                     JTypeDesc : string[30]; { Job type description }
                     Spare     : array[1..220] of char;
                     LastChar  : char;       { For VB alignment }
                   end;

{ ====================================================================== }
{* For Discount Matrix by Customer and Stock - 20.11.98 *}

TBatchDiscRec  =  Record
                    CustCode      :  String[6];    { Customer Code }
                    StockCode     :  String[16];   { Stock Code }
                    DiscType      :  Char;         { Discount Type - B,S,M,U,Q }
                    SalesBand     :  Char;         { Sales Price Band - A to H }
                    SPCurrency    :  SmallInt;     { Special Price Currency }
                    SPrice        :  Double;       { Special Price }
                    DiscPer       :  Double;       { Discount % }
                    DiscAmt       :  Double;       { Discount Amount of Unit Price }
                    DiscMar       :  Double;       { Discount MarkUp or Margin % }
                    QtyBreak      :  WordBool;     { Qty Break Status }
                    PadChar1      :  Array [1..2] Of Char;    { Padding Character for Word Alignment }
                    QtyFr         :  Double;       { Qty Discount From Qty }
                    QtyTo         :  Double;       { Qty Discount To Qty }
                    Spare         :  Array[1..199]
                                       of Char;
                    LastChar      :  Char;         { Last Character in record - used for VB alignment }
                  end;

{ ====================================================================== }

{ For Stock Alternative Codes }
TBatchSKAltRec  =  Record
                     StockCode  :  String[16];   { Main Stock Code }
                     AltCode    :  String[16];   { Alternative Stock Code }
                     AltDesc    :  String[35];   { Alt.Code Description }
                     SuppCode   :  String[6];    { Supplier Code }
                     PadChar1   :  Char;         { Padding Character for Word Alignment }
                     ROCurr     :  SmallInt;     { ReOrder Currency }
                     ROPrice    :  Double;       { ReOrder Price }
                     UseROPrice :  WordBool;     { Use ReOrder Price Status }
                     LastUsed   :  String[8];    { Last Used Date }
                     Spare      :  Array [1..100] Of Char;
                     LastChar   :  Char;         { Last Character in record - used for VB alignment }
                   end;

{ ====================================================================== }

{ For Visual Basic users }
TLArrayInfoType = Record
                    TLArray      : Pointer;    { Pointer to variable size array }

                    NumTL        : LongInt;    { Number of lines added into array }
                    UsedSize     : LongInt;    { Total Memory used by added lines}

                    MaxTL        : LongInt;    { Maximum number of lines that can be stored }
                    TLSize       : LongInt;    { Total memory allocated for TLArray }

                    Spare        : Array[1..203] Of Byte;
                    LastChar     : Char;         { Last Character in record - used for VB alignment }

                  End; { TLArrayInfoType }

{ ====================================================================== }



