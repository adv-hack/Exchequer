//PR: 02/05/03 Toolkit record structures take from Exchdll.inc for Com Toolkit only.
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
                Company    : string[45];    (***  Company Name *)
                AreaCode   : String[4];     {* Free Type Sort Field *}
                RepCode    : String[4];     {*   "   "    "     "   *}
                RemitCode  : String[10];    {* Account Code of Remit Account *}
                VATRegNo   : String[30];    {* VAT Registration No.  *}
                Addr       : Array[1..5] of
                               String[30];  {* Addr1-5 *}
                PadChar5   : Char;
                DespAddr   : WordBool;      {* Despatch Address *}
                DAddr      : Array[1..5] of
                               String[30];  {* Despatch Addr1-5 *}
                Contact    : String[25];    {* Contact Name *}
                Phone      : string[30];    {*** Phone No. *}
                Fax        : string[30];    {*** Fax No. *}
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
                DefNomCode : LongInt;       {* Default Sales Nominal Code  *}
                DefMLocStk : String[3];     {* Default Multi Loc Stock *}
                AccStatus  : SmallInt;      {* On Hold, Closed, See notes *}
                PayType    : Char;          {* [B]acs,[C]ash *}
                BankSort   : String[15];    {*** Bank Sort Code *}
                BankAcc    : String[20];    {*** Bank Account No. *}
                BankRef    : String[28];    {*** Bank additional ref, ie Build Soc.Acc *}
                LastUsed   : String[8];     {* ReadOnly - Date last updated *}
                {Added on 7.1.97}
                Phone2     : String[30];    {*** Second Phone No. *}
                //PR 30/06/04: Changed length of UD1 & UD2 from 20 to 30
                UserDef1,
                UserDef2   : String[30];    {* User Definable strings *}
                SOPInvCode : String[6];     {* Ent SOP Invoice Code *}
                PadChar3   : Array[1..2]
                             of Char;       {* Padding Char for Word Alignment *}
                SOPAutoWOff: WordBool;      {* Auto write off Sales Order *}
                PadChar6   : Array[1..2]
                               of Char;
                BOrdVal    : Double;        {* Book order value *}
                {* Added on 23/07/97 *}
                DefCOSNom  : LongInt;       {* Cost of Sales Nominal Code *}
                DefCtrlNom : LongInt;       {* Default Control Nominal Code *}
                {* Added on 20.1.98 *}
                DirDeb     : SmallInt;      {* Current Direct Debit Mode *}
                CCDSDate   : String[8];     {*** Credit Card Start Date *}
                CCDEDate   : String[8];     {*** Credit Card End Date *}
                CCDName    : String[50];    {*** Name on Credit Card *}
                CCDCardNo  : String[30];    {*** Credit Card No *}
                CCDSARef   : String[4];     {* Credit Card Switch Ref *}

                PadChar7   : Char;
                {* Added on 17.11.98 *}
                DefSetDDays: SmallInt;      {* Default Sett.Discount Days *}
                PadChar4   : Array [1..2]   {* Padding Char for Word Alignment *}
                               of Char;
                DefSetDisc : Double;        {* Default Sett.Discount % *}
                DefFormNo  : SmallInt;      {* Default Form Set No., 0-99, default 0 *}

                {*** New fields in ver 4.31 ***}
                StatDMode  : SmallInt;      {* Statement/Remittance delivery mode.
                                             0 = Printed. 1 = Fax  2 = email *}
                EmailAddr  : String[100];    {* Email address for Statment/ Remittance *}
                PadChar   : Char;
                EmlSndRdr  : WordBool;      {* On next email transmnision, send reader & reset *}
                ebusPwrd   : String[20];    {* ebusiness module web password *}
                PostCode   : String[20];    {* Seperate postcode ** Add index *}
                CustCode2  : String[20];    {* Alternative look up code, can be blank *}
                PadChar8   : Char;
                AllowWeb   : SmallInt;      {* Allow upload to Web *}
                EmlZipAtc  : WordBool;      {* Default Zip attachement *}
                UserDef3   : String[30];    {* User Defined 3 *}
                UserDef4   : String[30];    {* User Defined 4 *}
                TimeChange : String[6];     {* ReadOnly - Time stamp for record Change *}
                SSDDelTerms: String[5];     {*     "     Delivery Terms }
                CVATIncFlg : Char;
                SSDModeTr  : SmallInt;
                LastOpo    : String[10];
                PadChar9   : Char;
                InvDMode   : SmallInt;      {* Invoice delivery mode *}
                EmlSndHTML : WordBool;      {* When sending XML, send HTML *}
                WebLiveCat : String[20];    {Read Only - Web current catalogue entry}
                WebPrevCat : String[20];    {Web previous catalogue entry}

                {27.09.2000 }
                SOPConsHO  : SmallInt;    { Consolidate Committed Balance. 0 or 1 only }

                { 03/04/01: Extended for Enterprise v4.32 }
                EmlUseEDZ  : WordBool;      { When Zipping attachments send as .EDZ instead of .ZIP }

                { 25/03/02 - v5.00 : Default Tag Number }
                DefTagNo   : SmallInt;
                OrderConsMode : Byte;
                VatCountryCode : string[5];

                //24/10/2011 v.69 User Defined Fields 5-10
                UserDef5   : string[30];
                UserDef6   : string[30];
                UserDef7   : string[30];
                UserDef8   : string[30];
                UserDef9   : string[30];
                UserDef10  : string[30];

                //PR: 09/09/2013 ABSEXCH-14598 Added SEPA/IBAN fields. (Not encrypted - encryption is handled when
                //                                                      converting between toolkit & Exch structures.)
                acBankSortCode : string[15];
                acBankAccountCode : string[35];
                acMandateID : string[35];
                acMandateDate : string[8];

                //PR: MRD 2.5.18 14/10/2013 v7.0.7 Delivery postcode
                acDeliveryPostCode : string[20];

                //PR: 14/11/2013 MRD 1.1.41
                acSubType : Char; //'C' - customer, 'S' - supplier, 'U' - consumer
                acLongACCode : string[30];

                acAllowOrderPayments: WordBool;
                acOrderPaymentsGLCode: Integer;

                //PR: 26/11/2014 Order Payments
                acCountry : String[2];
                acDeliveryCountry : String[2];

                acPPDMode : SmallInt;

                //PR: 20/01/2016 ABSEXCH-17112 v2016 R1
                acDefaultToQR : WordBool;

                //AP: 15/11/2017 ABSEXCH-19389 v2018 R1
                acAnonymisationStatus: Integer;
                acAnonymisedDate: String[8];
                acAnonymisedTime: String[8];
                Spare      : Array[1..214] of Char;  {131/129}
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
                OldYourRef:  String[10];  { Account Ref - free text}
                LongYrRef :  String[20];  { Additional reference field }
                LineCount :  LongInt;     { Transaction line count }
                TransDocHed
                          :  String[3];   { Transaction Type, ie 'SIN' }
                InvVatAnal:  Array[0..20]of { Change from 16 to 20 in v4.31  }
                             Double;      { VAT Analysis S E Z 1 to 9 T X B C F G R W Y }
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

                  { COM Toolkit }
                  DocUser1,
                  DocUser2  :  String[30];  {* User def fields *}
                {* Add for TSH *}
                EmpCode   :  String[6];   {* Employee Code for TSH *}
                {* Add on 12.01.98 *}
                PadChar5  :  Char;        {* Padding Character for Word Alignment *}
                Tagged    :  SmallInt;    {* Doc Mark- Read Only *}
                thNoLabels:  SmallInt;    {* No. of labels to be printed *}
                PadChar6  :  Array[1..2] Of Char;     {* Padding Characters for Word Alignment *}

                {* Add on 19.03.98 *}
                CtrlNom   :  LongInt;     {* Debtor/Creditor Control Nominal *}

                {*** New fields in ver 4.31 ***}

                DocUser3  :  String[30];  {* User def field 3 *}
                DocUser4  :  String[30];  {* User def field 4 *}
                SSDProcess:  Char;        {* SSD process flag *}
                PadChar7  :  Char;
                ExtSource :  SmallInt;    {* If transaction created externaly where from *}
                PostDate  :  String[8];   {* Date posted, used for EC + SSD *}
                PadChar8  :  Char;
                PORPickSOR:  WordBool;    {* Back to Back SOR/POR auto picks SOR *}
                PadChar9  :  Array[1..2] of Char;
                BDiscount :  Double;      {* Amount of discount applied via batch *}

                PrePostFlg:  SmallInt;    {* Used to indicate on Noms if posting should generate any associated
                                             transactions, for example, if an auto reversing NOM should generate
                                             its auto reversal *}
                AllocStat :  Char;        {* Outstanding Flag,
                                             "C"=Outstanding Sales Transaction
                                             "S"=Outstanding Purchase Transaction *}
                PadChar10 :  Char;
                SOPKeepRate: WordBool;    {* Whether to keep a fixed exchange rate *}

                {*** ---------------------------------------------------- ***}
                 AutoInc   : SmallInt;
                 AutoIncBy : Char;
                 AutoEndDate
                           : String[8];
                 AutoEndPr : SmallInt;
                 AutoEndYr : SmallInt;
                 AutoPost  : WordBool;

                 NomAutoReverse
                           : WordBool;
                TimeCreate : String[6];
                TimeChange : String[6];
                TotalInvoiced : Double;
                BatchNom  : longint;
                RemitNo   : String[10];
                BatchLink : String[12];
                NomAuto   : WordBool;
                CISTax   : Double;       {*Total amount of CIS tax to be deducted *}
                CISDeclared
                            : Double;       {* Total amount of CIS declared on vouchers, correlates to
                                               Currsettled at time of voucher production *}
                CISManualTax
                            : Boolean;      {* Tax was overridden by manual adjustment, do not auto calculate *}
                CISDate  : String[8];     {* Date of next voucher run *}
                PadChar11    : Array[1..2] of Char;
                TotalCost2
                            : Double;       {* Cost appotrionment from outside costs, included in GP *}
                CISEmpl  : String[10];   {* Employe code used for this CIS Entry *}
                PadChar12 : Char;
                CISGross : Double;       {* Basis of CIS Tax *}

                CISHolder: Byte;         {* >0 Document is a CIS carrier generated from another process like
                                               self billing (2) or retentions (1).
                                               Has no lines of its own which would generate CIS, but is required
                                               to place in CIS returns *}
                NOMVatIO  : Char;        {0 = N/A, I = Input, O = Output}
                UpdateExMode : Byte;     //0 - Normal, 1 - UpdateEx2

                //v5.60
                thAutoTransaction : WordBool; //Indicates an auto-daybook transaction. Read-only
                thDeliveryRunNo   : String[12]; //Read-only
                thExternal        : WordBool; //if true, transaction created externally. Read-only
                thSettledVAT      : Double; //Amount of vat settled. Read-only
                thVATClaimed      : Double; //Amount of vat claimed. Read-only
                thPickingRunNo    : longint; //Read-only
                thDeliveryNoteRef : String[10]; //OurRef of deliveryNote. Read-only
                thVATCompanyRate  : Double; //Read-only
                thVATDailyRate    : Double; //Read-only
                thPostCompanyRate : Double; //Read-only
                thPostDailyRate   : Double; //Read-only
                thPostDiscAmount  : Double; //Read-only
                thPostDiscTaken   : WordBool; //Read-only
                thLastDebtChaseLetter : longint; //Read-only
                thExported        : WordBool;
                thOnPickRun       : WordBool;
                thTotalReserved   : Double;
                thTotalOrdered    : Double;

                //Used internally to specify that the transaction is a master sales terms
                MSTerms           : WordBool;
                DocLSplit : Array[1..6] of Double;
                BDMode : Byte; //Internal use only - 1 specifies back door mode to allow ro fields to be written to
                thOrdMatch : WordBool; //Internal use only
                thAutoPost : WordBool; //Internal use only
                thZeroLineNos : WordBool; //Internal use only - allows duplicate AbsLineNo of 0
                thUseORate : Byte; //Internal use only/read only - specifies Pre-triangulation rates
                thAllowCtrlCodes : WordBool; //Internal use only - allows Ctrl GLs on transaction lines
                thVariance : Double;
                thRevalueAdj : Double;
                thVatPostDate : String[8];
                YourRef:  String[20];
                thAddInLocationLines : WordBool;

                //PR: 24/03/2009 New fields for extended discounts
                thTTDValue : Double;
                thTTDFlag  : Char;
                thVBDValue : Double;
                thVBDVAT : Double;

                //PR: 04/02/2010 New fields for web extensions
                thWeekMonth : SmallInt;
                thWorkflowState : Longint;

                //PR: 15/10/2010 New field for LIVE
                thOverrideLocation
                          :  String[3];

                //24/10/2011 v6.9 User Defined Fields 5-10
                DocUser5  :  String[30];
                DocUser6  :  String[30];
                DocUser7  :  String[30];
                DocUser8  :  String[30];
                DocUser9  :  String[30];
                DocUser10 :  String[30];

                //PR: 14/10/2013 MRD 2.5.18 v7.0.7 Delivery postcode
                thDeliveryPostCode : string[20];

                //PR: 28/10/2013 ABSEXCH-14705 v7.0.7 Added new fields and extended spare
                thOriginator   : String[36]; // Exchequer User Id
                thCreationTime : String[6];  // HHMMSS
                thCreationDate : String[8];  // YYYYMMDD

                // CJS 2014-08-05 - v7.x Order Payments - T098 - new fields
                // Copied from Varrec.pas
                thOrderPaymentOrderRef : String[10];              // OurRef of parent Order for SDN/SIN/SRC in Order Payments subsystem
                thOrderPaymentElement : Byte;                     // The type of transaction in Order Payments subsystem, e.g. Order Payment
                thOrderPaymentFlags : Byte;                       // bit field - see thopfXXX constants above for values
                thCreditCardType : String[4];                     // Credit Card Payment Details (on Payment SRC only)
                thCreditCardNumber : String[4];                   // Credit Card Payment Details (on Payment SRC only) - Last 4 digits only
                thCreditCardExpiry : String[4];                   // Credit Card Payment Details (on Payment SRC only) - MMYY format
                thCreditCardAuthorisationNo : String[20];         // Credit Card Payment Details (on Payment SRC only)
                thCreditCardReferenceNo : String[70];             // Credit Card Payment Details (on Payment SRC only)
                thCustomData1 : String[30];                       // for bespoke

                //PR 23/03/2015 v7.0.14 ABSEXCH-16284: Added new fields for Prompt Payment Discount
                thPPDPercentage : Double;   // Discount Percentage - Note: 0.1 = 10%
                thPPDDays       : SmallInt; // Number of days discount offer is valid for
                thPPDGoodsValue : Double;   // Goods Value of Discount (if taken) in Transaction Currency
                thPPDVATValue   : Double;   // VAT Value of Discount (if taken) in Transaction Currency
                thPPDTaken      : SmallInt;  // TRUE if the Prompt Payment Discount was given
                thPPDCreditNote : WordBool;  // True if this is a credit note created from PPD

                {$IFDEF IMPV6}
                //PR: 20/10/2014 Order payments - importer only
                thCreateOrderPayment : WordBool;
                thOrderPaymentValue : Double;
                thOrderPaymentCostCentre : String[3];
                thOrderPaymentDepartment : String[3];
                thOrderPaymentBankGL : longint;
                thOrderPaymentReference : String[10];
                {$ENDIF}

                //PR: 26/11/2014 Order Payments
                thDeliveryCountry : string[2];

                //PR: 20/01/2016 ABSEXCH-17112 v2016 R1
                thIntrastatOutOfPeriod
                                : WordBool;  //Intrastat out of period flag

                //v2016 R2 New User Defined Fields
                DocUser11  :  String[30];
                DocUser12  :  String[30];

                //AP: 21/11/2017 ABSEXCH-19399 v2018 R1 New GDPR Fields
                thAnonymised: Boolean;
                thAnonymisedDate: String[8];
                thAnonymisedTime: String[8];  

                Spare     :  Array[1..178] of Char;
                PadChar13 : Char;
                LastChar  :  Char;        { Padding Character for Word Alignment }
              end;


{* =============== Transaction Detail Line ================================== *}

TBatchTLRec = Record
                TransRefNo  :  String[9];  {* Parent Transaction number *}
                PadChar1    :  Array[1..2] Of Char; { Padding Character for Word Alignment }
                LineNo      :  LongInt;     { Array / Line No}
                NomCode     :  LongInt;     { Nominal Code }
                Currency    :  SmallInt;    { Transaction Currency [0-30]}
                PadChar2    :  Array[1..2] Of Char; { Padding Character for Word Alignment }
                CoRate      :  Double;      { Line Currency Company Exchange Rate }
                VATRate     :  Double;      { Line Currency Daily Exchange Rate }
                CC          :  String[3];   { Cost Centre Code }
                Dep         :  String[3];   { Department Code }
                StockCode   :  String[16];  { Stock Code }
                PadChar3    :  Array[1..3] Of Char; { Padding Character for Word Alignment }
                Qty         :  Double;      { Qty!}
                QtyMul      :  Double;      { Qty Multiplier Factor }
                NetValue    :  Double;      { Line Total excluding Tax }
                Discount    :  Double;      { Amount/% }
                VATCode     :  Char;        { VATCode }
                PadChar4    :  Array[1..3] Of Char; { Padding Character for Word Alignment }
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

                {*** New fields in v4.31 ***}

                LineUser1  :  String[30];  {* Line user def 1 *}
                LineUser2  :  String[30];  {* Line user def 2 *}
                LineUser3  :  String[30];  {* Line user def 3 *}
                LineUser4  :  String[30];  {* Line user def 4 *}
                SSDUplift  :  Double;      {* Intrastat uplift % *}
                SSDCommod  :  String[10];   {* SSD Commodity code - Numbers Only *}
                PadChar7   :  Char;
                SSDSPUnit  :  Double;      {* SSD unit into sales unit *}
                SSDUseLine :  WordBool;    {* Take the ssd values from the line *}
                PadChar8   :  Array[1..2]
                                of Char;
                PriceMulx  :  Double;      {* Price rate multiplier to get price per *}
                {* 21.12.99 *}
                QtyPick    :  Double;      {* Picked Quantity *}
                VATIncFlg  :  Char;        {* VAT Include flag *}
                {* 12.01.2000 *}
                PadChar9   :  Array[1..3]
                                of Char;
                QtyPWOff   :  Double;      {* Pick WriteOff Qty *}

                PadChar10  :  Array[1..2]
                                of Char;
                RtnErrCode :  SmallInt;    {* Return Error Code *}
                SSDCountry :  string[5];
                PadChar11  :  Array[1..2]
                                of Char;
                {Added 9/9/02 original value for Vat inclusive}
                IncNetValue : Double;
                {*** ------------------------------------------------------ ***}
                Period      : Byte;
                Year        : Byte;
                NomMode     : Byte;
                DocHed      : String[3];

                AutoLineType: Byte;         {Line has been auto manufactured. 0 = Not auto line.
                                                                           1 = via customisation
                                                                           2 = via CIS routine }
                CISRateCode : Char;         {Valid CIS Tax rate code}
                PadChar12    : Array[1..2] of Char;
                CISRate     : Double;       {CIS % rate aplied}
                CostApport  : Double;       {Cost apportionment value}
                NOMVatType: Byte;         {0 = N/A, 1 = Auto, 2 = Manual}
                BinQty      : Double;       {Bin Quantity for Multi-Bin support}

                {v5.60}
                tlAltStockFolio    : longint;  //Folio of Alternate Stock Code. Read-only
                tlRunNo            : longint;  //Transaction Run Number. Read-only
                tlStockDeductQty   : Double;   //Qty to deduct from stock. Read-only
                tlUseQtyMul        : WordBool; //Whether to use the Qty Multiplier. Read-only
                tlSerialQty        : Double;   //Number of serial nos required. Read-only
                tlPriceByPack      : WordBool;  //Read-only
                tlReconciliationDate : String[8]; //Date line is reconciled. Read-only
                tlB2BLinkFolio,
                tlB2BLineNo        : longint; //Folio number and line number of back-to-back equiv.Read-only
                tlCOSDailyRate     : Double;  //Daily rate for Cost-of-Sales conversion. Read-only
                tlQtyPack          : Double;
                tlUseCase          : WordBool;
                tlCOSNomCode       : longint;
                tlDeductType       : SmallInt;
                tlOldSerialQty     : SmallInt;
                tlLiveUplift       : WordBool;

                InvalidTSHRates    : WordBool; //Internal only - on time sheets indicates that the rates on
                                               //a line are invalid according to the TimeRateRules for the employee
                InvalidJobCode     : WordBool;  //Internal only - on J** transactions indicatese the the Job Code is
                                               //not valid
                PaymentCode        : Char;
                SerialRetQty       : Double;
                BinRetQty          : Double;
                BDMode : Byte; //Internal use only - 1 specifies back door mode to allow ro fields to be written to
                Spare       : Array[1..244] of Char;
                tlImporterBatchNo : String[10];
                tlImporterSerialNo : String[20];       //Added 29/04/2008 for Windows Importer
                //24/03/2009 v6.01 Fields for Extended Discounts
                tlMultiBuyDiscount : Double;    // Multi-Buy Discount
                PadChar19          : Array[1..1] of Char;
                tlMultiBuyDiscountChr
                                   : Char;      // #0=Amount, %=Percentage
                tlTransValueDiscount
                                   : Double;    // Transaction Based Discount (TTD/VBD)
                PadChar20          : Array[1..1] of Char;
                tlTransValueDiscountChr
                                   : Char;      // #0=Amount, %=Percentage
                tlTransValueDiscountType
                                   : SmallInt;  // 0=Undefined, 1=TTD, 2=VBD
                tlMBDList          : TStringList;

                //PR: 09/09/2009 EC Service Fields
                tlECService          : WordBool;
                tlECServiceStartDate   : String[8];
                tlECServiceEndDate     : String[8];
                tlECSalesTaxReported : Double;
                tlECPurchaseServiceTax : Double;

                //;PR: 04/02/2010 Web extension fields
                tlReference    : String[20];
                tlReceiptNo    : String[20];
                tlFromPostCode : String[15];
                tlToPostCode   : String[15];

                //PR: 26/10/2011 v6.9 User Fields 5-10
                LineUser5  :  String[30];
                LineUser6  :  String[30];
                LineUser7  :  String[30];
                LineUser8  :  String[30];
                LineUser9  :  String[30];
                LineUser10  :  String[30];

                RecordAddress : longint;  //PR: 22/02/2012 ABSEXCH-12017

                // MH 01/03/2012 v6.10 ABSEXCH-12596: Added Threshold Code for LIVE
                tlThresholdCode : String[12];  // LIVE Threshold Code

                //PR: 20/01/2016 ABSEXCH-17112 v2016 R1
                tlIntrastatNoTC : String[2];  //Intrastat Nature of Transaction

                Spare2      : Array[1..3] Of char;
                LastChar    : Char;        { Padding Character for Word Alignment }
              end;

{$IFNDEF EBUS}
TBatchLinesRec  =  Array[1..190] of TBatchTLRec; {* Memory array of entire transaction lines *}
{$ENDIF}

TSaleBandsRec =  Record
                   Currency   :  SmallInt;  { Currency of Band }
                   PadChar1   :  Array [1..2] Of Char; { Padding Char for Word Alignment }
                   SalesPrice :  Double;    { Price of Band    }
                   PadChar2   :  Array [1..3] Of Char;
                   Spare      :  Array[1..20] of Char;
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
                    UnitK        :  String[10];         { Descriptive Stocking Unit Qty }
                    UnitS        :  String[10];         {      "      Selling    "   "  }
                    UnitP        :  String[10];         {      "      Purchase   "   "  }
                    PadChar13    :  array[1..3] of char;{ Padding for word alignment }
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
                    BinLoc       :  String[10];         { Physical location in stores }
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
                    LastUsed     :  String[8];          { ReadOnly - Date Last updated }
                    {* Added on 14.07.97 *}
                    StBarCode    :  String[20];         { Bar Code }
                    StRoCostCentre
                                :  String[3];          { RO Cost Centre }
                    StRoDepartment
                                :  String[3];          { RO Department }
                    StLocation   :  String[3];          { Location }
                    StPricePack  :  WordBool;           { Price per Pack - Price by (Split Pack) on Ent. screen }
                    StDPackQty   :  WordBool;           { Show Qty as Cases }
                    StKitPrice   :  WordBool;           { Use BOM price, ignore component price }
                    StKitOnPurch :  WordBool;           { Explode kit on Purch transactions }

                    {* Added on 28.08.97 *}
                    StStkUser1   :  String[20];         { User Defined Field 1 }
                    StStkUser2   :  String[20];         { User Defined Field 2 }

                    JAnalCode    :  String[10];         { Default Job Analysis Code }

                    {*** New fields for ver 4.31 ***}
                    PadChar11    :  Char;
                    WebInclude   :  SmallInt;           {Include on Web export}
                    WebLiveCat   :  String[20];         {Read Only - Web current catalogue entry}
                    StkUser3     :  String[30];         {Stk User Def 3}
                    StkUser4     :  String[30];         {Stk User Def 4}
                    PadChar12    :  Char;
                    SerNoWAvg    :  SmallInt;           {Determins if average is to be used with snos}
                    SSDDUplift   :  Double;             {Intrastat Uplift Dispatch default %}
                    TimeChange   :  String[6];          {* Time stamp for record Change *}
                    SVATIncFlg   :  Char;               {* Inc VAT Default *}
                    LastOpo      :  String[10];         {Last operator}
                    ImageFile    :  String[30];         {Associated bitmap image}
                    WebPrevCat   :  String[20];         {Web previous catalogue entry}
                    SSDCountry   :  String[5];
                    PadChar14    :  Char;
                    StkLinkLT    :  SmallInt;           { Default stock item line type normal, freight etc }

                    { 09.10.2000 }
                    PriceByStkUnit: WordBool;           { Price by Stock Unit  }
                    {*** --------------------------------------------------- ***}

                    {31/07/2002}
                    ShowAsKit    :  WordBool;           {BOM exploded on Sales transactions}
                    {*** --------------------------------------------------- ***}

                    {9/8/2002}
                    QtyPickWOR   :  Double;             {Qty issued now, but not processed}
                    {V5.60 9/12/2003}
                    SSDAUplift   :  Double;
                    BOMProdTime  :  longint;
                    WOPProdTimeDays,
                    WOPProdTimeHours,
                    WOPProdTimeMins
                                 :  longint;
                    WOPLeadTime  :  longint;
                    WOPCalcProdTime :  WordBool;
                    WOPMinEcQty  :  Double;
                    WOPIssuedWIPGL  : longint;
                    QtyAllocWOR  :  Double;
                    QtyIssueWOR  :  Double;
                    QtyStockTake :  Double;
                    QtyStockTakeChanged : WordBool;
                    QtyFreeze    :  Double;
                    UsesBins     :  WordBool;
                    SalesWarranty : Smallint;
                    SalesWarrantyType : SmallInt;
                    PurchWarranty : Smallint;
                    PurchWarrantyType : SmallInt;
                    SalesRetGL : longint;
                    PurchRetGL : longint;
                    RestockCharge : Double;
                    SalesRetQty : Double;
                    PurchRetQty : Double;
                    RestockFlag : Char;

                    //24/10/2011 v6.9
                    StkUser5     :  String[30];
                    StkUser6     :  String[30];
                    StkUser7     :  String[30];
                    StkUser8     :  String[30];
                    StkUser9     :  String[30];
                    StkUser10     :  String[30];

                    // MH 09/09/2014 v7.1 ABSEXCH-15052
                    StkIsService : Boolean;

                    Spare        :  Array [1..472] of Char;
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
                     PadChar1 :  Array [1..2]
                                   Of Char;  { Padding Characters for Word Alignment }
                     Value    :  Double;     {* Returned value *}
                     PadChar2 :  Array [1..3]
                                   Of Char;  { Padding Characters for Word Alignment }

                     { 12.09.00 - Added Committed Value, PadChar3 & 4 fields }
                     PadChar3 :  Char;
                     CommitVal:  Double;
                     PadChar4 :  Array [1..3]
                                   Of Char;  { Padding Characters for Word Alignment }
                     Spare    :  Array [1..256] of Char;
                     LastChar :  Char;    { Last Character in record - used for VB alignment }
                   end;

{ ===============   G/L Nominal   16.12.96 ==================== }

TBatchNomRec    =  Record
                     NomCode    :  Longint;   { Nominal Code }
                     Desc       :  String[40];
                     PadChar1   :  Char;      { Padding Characters for Word Alignment }
                     Cat        :  LongInt;   { Parent Code }
                     NomType    :  Char;      { Heading / A,B,C }
                     PadChar2   :  Char;      { Padding Characters for Word Alignment }
                     NomPage    :  WordBool;  { Page At end of this }
                     SubType    :  WordBool;  { Sub Total at end }
                     Total      :  WordBool;  { Show Balance only or Cr/Dr }
                     CarryF     :  LongInt;   { Nom Code to Carry Forward to }
                     ReValue    :  WordBool;  { Code is to be revalued }

                     {***  New Fields for Ver 4.31 ***}
                     AltCode    :  String[50];{ Alternative look up code}
                     PadChar4   :  Char;
                     DefCurr    :  SmallInt;  { Validation currency associated with this G/L. 0= All}
                     NomClass   :  Byte;
                     Inactive   :  WordBool;
                     ForceJC    :  WordBool;
                     {*** ----------------------- ***}
                     PadChar3   :  Array[1..3]
                                     of Char; { Padding Characters for Word Alignment }
                     Spare      :  Array[1..255] of Char;
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
                     JobAnal   :  String[3];    { Job Type Code - Job Type on Job Record form Main tab }
                     JobType   :  Char;         { Job Type }
                     JobStat   :  Char;         { Status of Job }
                     {* 10.12.99 *}
                     UserDef1  :  String[20];   { User Defined Field 1 }
                     UserDef2  :  String[20];   { User Defined Field 2 }

                     DefRetCurr : SmallInt;
                     JPTOurRef  : string[10];
                     JSTOurRef  : string[10];
                     JQSCode    : string[20];
                     UserDef3  :  String[20];   { User Defined Field 3 }
                     UserDef4  :  String[20];   { User Defined Field 4 }

                     //21/20/2011 v6.9  User Defined Fields 3-10
                     UserDef5  :  String[30];
                     UserDef6  :  String[30];
                     UserDef7  :  String[30];
                     UserDef8  :  String[30];
                     UserDef9  :  String[30];
                     UserDef10 :  String[30];

                     jrCostCentre : string[3];
                     jrDepartment : string[3];

                     //AP 08/12/2017 2018R1 ABSEXCH-19485:GDPR - JobHead Changes
                     jrAnonymised : Boolean;
                     jrAnonymisedDate : String[8];    // YYYYMMDD
                     jrAnonymisedTime : String[6];    // HHMMSS

                     Spare      :  Array[1..233] of Char;
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
                     lsLastUsed   :  String[8];    { Read only - Last used date }
                     PadChar4     :  Array [1..3] Of Char; { Padding Characters for Word Alignment }
                     lsQtyPosted  :  Double;       { Posted loc qty }
                     lsQtyTake    :  Double;       { Stock Take Qty }
                     lsLastTime   :  String[6];    { Read only - Last used time }
                     //Added 16/10/02
                     PadChar6     :  Char;         { Padding Character for Word Alignment }
                     lsQtyAllocWOR:  Double;       { Allocated to WOR}
                     lsQtyIssueWOR:  Double;       { Issued to WOR}
                     lsQtyPickWOR :  Double;       { Picked on WOR}
                     lsWOPWIPGL   :  LongInt;      { WIPGLCode}
                     //22/7/05 - 5.70
                    lsSalesWarranty : Smallint;
                    lsSalesWarrantyType : SmallInt;
                    lsPurchWarranty : Smallint;
                    lsPurchWarrantyType : SmallInt;
                    lsSalesRetGL : longint;
                    lsPurchRetGL : longint;
                    lsRestockCharge : Double;
                    lsSalesRetQty : Double;
                    lsPurchRetQty : Double;

                     Spare2       :  Array[1..282] of Char;
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
                  {* Added 10/10/02 TKDLL500.124}
                  PadChar2     :  Array[1..2] of Char;
                  loNLineCount :  LongInt;      { Notes Line Count }
                  loUseCPrice  :  WordBool;     { Use Locations own cost price}
                  loUseRPrice  :  WordBool;     { Use Locations own re-order price}
                  loWOPWIPGL   :  LongInt;      { Override WIP GL}
                  loSalesRetGL :  longint;      {Sales Return GL}
                  loPurchRetGL :  longint;      {Purchase Return GL}
                  Spare2       :  Array[1..211] of Char;
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
                    MatchType :  Char;
					//PL 03/01/2017 : 2017 R1 :	ABSEXCH-16605 Custom Transaction Matching chops maCustomRef off at 10 characters instead of 20
                    CustomRef :  String[20];	
                    AllowOverSettling
                              :  WordBool;
                    Spare     :  Array[1..234] of Char;
                    Spare2    :  Array [1..3] Of Char;
                    LastChar  :  Char;        { Last Character in record - used for VB alignment }
                  end;

{ ====================================================================== }

TBatchNotesRec  = Record
                   NoteSort   :  String[3];   { ACC/STK/DOC }
                   NoteType   :  Char;        { 1=General 2=Dated Notes }
                   NoteCode   :  String[16];  { Account Code/Stock Code/Doc. No. }
                   NoteDate   :  String[8];   { Optional Date for Note line (YYYYMMDD) }
                   AlarmDate  :  String[8];   { Optional Date for Alarm (YYYYMMDD) }
                   AlarmSet   :  Char;        { Set Alarm Y/N - Optional }
                   PadChar1   :  Char;        { Padding Character for Word Alignment }
                   LineNo     :  longInt;    { Notes Line No. }
                   {$IFDEF IMPv6}
                   User       :  String[8];   { User/Login Code }
                   {$ELSE}
                   User       :  String[10];   { User/Login Code }
                   {$ENDIF IMPv6}
                   NoteLine   :  String[65];  { Note Line Content }
                   { 13.10.2000 }
                   PadChar2   :  Char;        { Padding Character for Word Alignment }
                   RepeatDays :  SmallInt;    { Repeat every xx Days }
                   NoteFor    :  String[10];  { Notes For valid user name in Enterprise }

                   KeyStr     :  String[26];
                   SnoType    :  Byte;
                   NFolio     :  longint;
                   

                   Spare      :  Array[1..242] of Char; { 256 to 242 }

                   LastChar   :  Char;         { Last Character in record - used for VB alignment }
                 end;


{ ====================================================================== }

TBatchCCDepRec  = Record
                    CCDepCode  :  String[3];   { Cost Centre/Department Code }
                    CCDepDesc  :  String[30];  { Description }
                    CCDepInactive : Byte;
                    ImporterCCDepInd : Char;     //Added for Importer
                    Spare      :  Array[1..254] of Char;
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
                      LocCode    :  String[3];    { 30.11.2000 - Multi-Location Code }
                      PriceDate  :  String[8];    {Date of price wanted in format YYYYMMDD}
                      MultiBuyDiscValue
                                 :  Double;
                      MultiBuyDiscChar
                                 :  Char;
                      Spare      :  Array[1..249] of Char;
                      LastChar  :  Char;          { Last Character in record - used for VB alignment }
                    end;


{ ====================================================================== }

TBatchVATRec  = Record
                 VATCode    :  Char;                 { VAT Code }
                 PadChar1   :  Array [1..3] Of Char; { Padding Character for Word Alignment }
                 VATRate    :  Double;               { VAT Rate }
                 VATDesc    :  string[10];           { Description of VAT rate }
                 VATSpare   :  Array[1..17] Of Char; { Spare }
                 Spare      :  Array[1..256] of Char;
                 PadChar2   :  Array[1..3] Of Char;  { Padding Character for Word Alignment }
                 LastChar   :  Char;                 { Last Character in record - used for VB alignment }
               end;

{ ====================================================================== }

TBatchCurrRec = Record
                  Name        : String[11];           { Currency name }
                  ScreenSymb  : String[3];            { Screen Symbol }
                  PrinterSymb : String[3];            { Printer Symbol }
                  DailyRate   : Double;               { Daily Rate }
                  CompanyRate : Double;               { Company Rate }
                  TriEuro     : SmallInt;
                  PadChar2    : Array [1..2] Of Char; { Padding Character for Word Alignment }
                  TriRates    : Double;
                  TriInvert   : WordBool;
                  TriFloat    : WordBool;
                  Spare      :  Array[1..256] of Char;
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
                  PeriodsPerYr : smallint;       { Number of periods in a year }
                  CCDepts      : WordBool;       { Cost centres and departments in use ? }
                  IntraStat    : WordBool;       { Use Intrastat fields ? }
                  ExchangeRate : Char;           { Company or daily rate ??? }
                  FinYearStart : String[8];      { Start of financial year yyyymmdd }
                  TraderUDFLabel     : Array[1..4] of
                                         string[15];   {Trader User Defined Labels }
                  StockUDFLabel      : Array[1..4] of
                                         String[15];   {Stock User Defined Labels }
                  TransHeadUDFLabel  : Array[1..4] of
                                         String[15];   {Trans. Header User Defined Labels }
                  TransHeadUDFHide   : Array[1..4] of
                                         WordBool;     {Hide status of Trans.Header User Defined Labels}
                  TransLineUDFLabel  : Array[1..4] of
                                         String[15];   {Trans. Line User Defined Labels }
                  TransLineUDFHide   : Array[1..4] of
                                         WordBool;     {Hide status of Trans. Line User Defined Labels }
                  TransLineTypeLabel : Array[1..4] of
                                         String[15];   {Trans. Line Type User Defined Labels }
                  TransLineTypeHide  : Array[1..4] of
                                         WordBool;     {Hide status of Trans. Line Type User Defined Labels }
                  JobCostUDFLabel    : Array[1..2] of
                                         String[15];   {Job costing User Defined Labels }
                  CurrentCountry     : String[3];      {Country code for install }
                  OrderAllocStock    : Wordbool;       {Orders to allocate stock when picked }

                  { 03.11.2000 }
                  CalPrFromDate      : WordBool;       {Calculate Period from Date }

                  {NF: 15/03/2001}
                  UseCrLimitChk      : WordBool;       { Warn if Over Credit }
                  UseCreditChk       : WordBool;       { Warn if Wks odue }
                  StopBadDr          : WordBool;       { Stop Invoice Entry of Bad Debtor }
                  UsePick4All        : WordBool;
                  FreeExAll          : WordBool;       { Free Stock to exclude allocated figure }
                  WksODue            : smallint;       { No Wks before considered odue }
                  DeductBOMComponents: WordBool;
                  //5.56 MultiBins
                  FilterSNoByBinLoc  : WordBool;       {Auto filter serial and bin lists when picking by location}
                  KeepBinHistory     : WordBool;       {Retain multi bin history}
                  BinMask            : String[10];     {Input mask for bin codes}
                  InputPackQtyOnLine : WordBool;       {Use 'Pack Qty' multiplier on transactions}
                  {$IFDEF SOPDLL}
                  PercentageDiscounts : WordBool;
                  {$ENDIF}
                  TTDEnabled         : WordBool;
                  VBDEnabled         : WordBool;

                  //6.2 - 10/09/2009
                  ECServicesEnabled  : WordBool;
                  ECSalesThreshold   : Double;

                  //6.5 - 15/10/2010
                  EnableOverrideLocations
                                     : WordBool;
                  
                  ConsumersEnabled   : WordBool;
                  Spare              : Array[1..513] of Char;
                  LastChar           : Char;           { Last Character in record - used for VB alignment }
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
                      { 03.11.2000 }
                      PadChar7  :  Array [1..3] Of Char; {  Padding Character for Word Alignment }

                      DoNotUpdateTL
                                :  WordBool;     {  Do not update Serial Qty value in Trans. line.
                                                    Default=False=update Ser.Qty in TL }

                      PadChar8  :  Array [1..2] Of Char; {  Padding Character for Word Alignment }
                      RecPos    :  LongInt;
                      InBinCode : String[10];
                      Returned : WordBool;
                      BatchRetQty : Double;
                      ReturnDoc : String[10];
                      ReturnDocLine : Longint;

                      //PR: 25/11/2011 Fields added for Com tk only to allow updating a bom to update tlSerialQty
                      LatestInDoc : string[10];
                      LatestBuyLine : longint;
                      Spare     :  Array[1..183] of Char;  {194 to 189 }
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
                     UseORate   :  SmallInt;      { Use pay rates setup for employee only }
                     UserDef1   :  String[20];    { User Defined Field 1 }
                     UserDef2   :  String[20];    { User Defined Field 2 }
                     CC         :  string[3];     { Default Cost Centre }
                     Dep        :  string[3];     { Default Dept }
                     {* 28/11/2002 *}
                     SelfBill   :  WordBool;
                     GroupCert  :  WordBool;      {Company Group CIS 6 Certificate}
                     CertType   :  Char;          {Certificate type N, 4, 5, 6}
                     UserDef3   :  String[20];    { User Defined Field 1 }
                     UserDef4   :  String[20];    { User Defined Field 2 }
                     ENINo      :  String[10];    {National Ins No UK/ Serial No IRL?}
                     LabourPLOnly : WordBool;
                     UTRCode    :  string[10];    {Unique Tax Ref}
                     VerificationNo : string[13]; {HMRC Verification No.}
                     Tagged     : WordBool;       {Tag for process}
                     ContractorType
                                : Byte; {CIS340 Subcontractor Type. 0 = N/A. 1 = Soletrader. 2 = Partnership.
                                           3 = Trust. 4 = Company}

                     //PR: 04/02/2010 New field for web extensions
                     emEmailAddress
                                : String[100];

                     //AP: 17/11/2017 ABSEXCH-19395 New field for GDPR
                     emStatus: Integer;
                     emAnonymisationStatus: Integer;
                     emAnonymisedDate: String[8];
                     emAnonymisedTime: String[8];
                     Spare      :  Array[1..229] of Char;
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
                       CISTaxRate  :  Char;     {Taxable activity CIS Rate}
                       PadChar     : Array[1..2] of Char;
                       UpliftP     :  Double;   {Uplift on cost %}
                       UpliftGL    :  LongInt;  {Uplift GL Code + reversal}
                       RevenueType :  Byte;     {Link to Revenue activity for valuation}
                       jaPayCode   : string[5];
                       jaDetType   : SmallInt;
                       jaCalcB4Ret : WordBool;
                       jaDeduct    : Double;
                       jaDeductApply  : SmallInt;
                       jaRetType      : SmallInt;
                       jaRetValue     : Double;
                       jaRetExpiry    : SmallInt;
                       jaRetExpInterval : SmallInt;
                       jaPreserveRet  : WordBool;
                       jaDeductCalc   : SmallInt;
                       Spare      :  Array[1..258] of Byte;
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
                       { Added 19.02.2001 }
                       PayFactor  :  SmallInt;      { Payroll Factor Code }
                       PayRate    :  SmallInt;      { Payroll Rate Code }
                       RecType    :  Char;          { 'E' = Job, 'R' = Employee}
                       OriginalCostCurr
                                  :  SmallInt;     //PR: 20/11/2009 Added to allow update to find original record if costcurr changed.
                       Spare      :  Array[1..196] of Char;  { 201 to 197}
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
                    RecordPos     :  longint;
                    UseDates      :  WordBool;
                    StartDate,
                    EndDate       :  String[8];
                    VBThreshold   :  Double;
                    VBCurrency    :  SmallInt;

                    //PR: 14/02/2012 ABSEXCH-9795
                    QBFolio       :  longint;      {Link between ac discount and qb records}
                    Spare         :  Array[1..191]
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
                     LastUsed   :  String[8];    { Read Only - Last Used Date }
                     LastTime   :  String[6];    { Read Only - Last Used Time }
                     PadChar2   :  Char;         { Padding Character for Word Alignment }
                     FolioNum   :  longint;
                     UseROQty  :  Boolean;     {Override min ecc. qty}
                     ROQty   :  Double;      {Min Ecc. Qty}
                     UseLineQty :  Boolean;     {Override line Qty}
                     LineQty     :  Double;      {Line Qty}
                     LineNo      :  LongInt;     {Line order for object popup display}
                     RecType    : Char; //Required for extended altstkrec
                     OrigAltCode : String[16]; //store on read for finding record if AltCode changed on update
                     OrigLineNo : longint;     //                                    LineNo
                     StockFolio : longint;
                     Spare      :  Array [1..239] Of Char;
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

TBatchConvTCurr = Record
                    Amount       :  Double;   { Amount }
                    Rate         :  Double;   { Exchange Rate }
                    AmtCurr      :  SmallInt; { Currency code of Amount }
                    ConvMode     :  SmallInt; { Conversion Mode }
                    ConvTo       :  WordBool; { Convert To }
                    PadChar1     :  Array[1..2] of Char;
                    RtnValue     :  Double;   { Converted Amount }

                    Spare        : Array[1..203] of Char;
                    LastChar     : Char;      { Last Character in record - used for VB alignment }

                  End; { TBatchConvTCurr }

{ ====================================================================== }

TSysECommsRec = record
                    YourEmailName  : string[255];
                    YourEmailAddr  : string[255];
                    SMTPServerName : string[255];
                    Priority       : SmallInt;
                    UseMAPI        : WordBool;
                    Spare          : array[1..223] of char;
                    LastChar       : char;
                  end; { Total size = 996 bytes }

{ ====================================================================== }

// Structure for retrieving default FormName for a Customer/Supplier Account
TDefaultFormRecType = Record
  dfAccount        : String[6];     { Account Code }
  dfPadChar1       : Char;          { Padding Character for Word Alignment }
  dfFormNo         : SmallInt;      { Default Form No. }
  dfCheckGlobal    : WordBool;      { Check global if no formset form defined }
  dfFormName       : String[8];     { Default Form Name }
  dfSpare          : Array [1..100] Of Char;
  dfLastChar       : char;          { Last Character in record - used for VB alignment }
End; { TDefaultFormRecType }

{ ====================================================================== }

// Structure containing 'Print To Email' details
TEmailPrintInfoType = Record
  emPreview         : WordBool;       { True=Preview Window, False=Send email }
  emCoverSheet      : String[8];      { Enterprise Form Name for cover sheet }
  emSenderName      : String[50];     { Sender's Name }
  emSenderAddr      : String[50];     { Sender's Email Address }
  emSubject         : String[255];    { Subject }
  emPadChar1        : Char;           { Padding Character for Word Alignment }
  emPriority        : SmallInt;       { 0=Ignore, 1=Normal, 2=Urgent }
  emSendReader      : SmallInt;       { 0=Don't Send Reader, 1=Send Reader, 2=Send Read + Insert Text Help }
  emCompress        : WordBool;       { True = Compress attached forms in PK-ZIP file }
  emSpare           : Array [1..201] Of Char;
  emLastChar        : Char;           { Last Character in record - used for VB alignment }
End; { TEmailPrintInfoType }

{ ====================================================================== }

{ To return the appropriate VAT code should both the customer record and
  stock record have the default VAT code }

TVATCodeDefaultType = Record
  StockVATCode   : Char;    { The default VAT code from stock record }
  AccountVATCode : Char;    { The default VAT code from customer record }
  DefaultVATCode : Char;    { The returned VAT code }
  Spare          : Array[1..64] of Char;
  LastChar       : Char;    { Last Character in record - used for VB alignment }
end; { TVATcodeDefaultType }

{ ====================================================================== }

TEnterpriseInfoType = Record
  eiDefined        : WordBool;               // Enterprise is running and data is set
  eiEntVersion     : String[30];            // Enterprise Version
  eiEntPath        : String[255];           // Path of Enterprise program files
  eiDataPath       : String[255];           // Path of Active Company
  eiUserName       : String[8];             // Current Logged-In User ID
  eiCurrencyVer    : Char;                  // Enterprise Currency Version - P-Prof, E-Euro, G-Global

  eiSpare          : Array [1..1024] Of Byte;
  LastChar         : Char;
End; { TEnterpriseInfoType }

{ ====================================================================== }

TUserProfileType = Record
  upUserId         : String[10];        // User Id
  upName           : String[50];        // User Name
  upEmail          : String[100];       // Email Address

  { Misc }
  upPadChar1       : Char;              // Padding Character for Word Alignment
  upLockOutMins    : SmallInt;          // Minutes for Auto Lock Out

  { Defaults }
  upDefSRICust     : String[6];         // Default Cust for SRI
  upDefPPISupp     : String[6];         // Default Supp for PPI

  upDefCostCentre  : String[3];         // Default Cost Centre
  upDefDepartment  : String[3];         // Default Department
  upDefCCDeptRule  : SmallInt;          // Rule for applying Default CC/Dept

  upDefLocation    : String[3];         // Default Location code
  upDefLocRule     : SmallInt;          // Rule for applying Default Location

  upDefSalesBankGL : LongInt;           // Default Sales Bank GL Code
  upDefPurchBankGL : LongInt;           // Default Purchase Bank GL Code

  upHighlightPIIFields: Boolean;          // Default field for GDPR
  upHighlightPIIColour: Integer;          // Default colour indication for GDPR

  { Authorisation }
  upMaxSalesAuth   : Double;            // Max Sales Authorisation Amount
  upMaxPurchAuth   : Double;            // Max Purchase Authorisation Amount

  upSpare          : Array [1..254] Of Byte;
  LastChar         : Char;
End; { TUserProfileType }


{ ====================================================================== }

TBatchLinkRec = Record
  lkCode               :   String[6];   //Code of record which link is attached to if Cust, Supp or Emp
  lkPadChar1           :   Char;              // Padding Character for Word Alignment
  lkFolioKey           :   longint;     //folio number of record which link is attached to if Job, Stock or Transaction
  lkAttachTo           :   Char;         //C - Customer, S - Supplier, E - employee, J - Job, S - Stock, T - Transaction
  lkLetterLink         :   Char;         //L - letter, K - link
  lkLinkType           :   Byte;         //0 - document to 9 - Internet file
  lkDate               :   String[8];    //Date of entry YYYYMMDD
  lkTime               :   String[8];    //Time of entry hh:mm:ss
  lkUserCode           :   String[10];   //UserID

  lkLetterDescription  :   String[100];  //Description if letter
  lkLetterFileName     :   String[12];   //Filename if letter (excluding path)

  lkLinkDescription    :   String[60];   //Description if link
  lkLinkFileName       :   String[84];   //Filename if link - includes full path
  lkSpare              :   Array[1..211] of Byte;
  LastChar             :   Char;
end; {TBatchLinkRec}

{ ====================================================================== }

TBatchConvRec = Record
  cvDocFrom    :  String[10];  //OurRef of Doc to be converted
  cvDocTo      :  String[10];  //Returns OurRef of new Doc
  cvDocToType  :  String[3];   //Type of Doc to convert to
  cvStatus     :  SmallInt;    //Result of Conversion
  cvDate       :  String[8];
  Spare      :  Array[1..190] of Byte;
  LastChar   :  Char;
end;

{ ====================================================================== }

TBatchB2BRec = Record
  bbMultipleSuppliers    :  WordBool;  //take suppliers from stock record
  bbIncludeNormalLines   :  WordBool;  //line types to include
  bbIncludeLabourLines   :  WordBool;
  bbIncludeMaterialLines :  WordBool;
  bbIncludeFreightLines  :  WordBool;
  bbIncludeDiscountLines :  WordBool;
  bbQtyMode              :  SmallInt; //0 - original order qty, 1 - qty delivered, 2 - max stock level, 3 - stock picked
  bbSuppCode             :  String[10]; //used if not suppliers from stock or if a stock code has no supplier
  bbAutoPick             :  WordBool; //Auto pick order when POR received
  Spare      :  Array[1..199] of Byte;
  LastChar   :  Char;
end;

TBatchBinRec = Record
  brBinCode              : string[10];
  brInDocRef             : string[10];
  brOutDocRef            : string[10];
  PadChar1               : Char;
  brSold                 : WordBool;
  brInDate               : string[8];     //Date bought yyyymmdd
  PadChar2               : array[1..3] of char;
  brCostPrice            : Double;        //Original cost
  brCapacity             : Double;        //capacity of bin
  brStockFolio           : longint;       //folio number of stock
  brOutDate              : string[8];
  PadChar3               : array[1..3] of char;
  brOutDocLine           : longint;
  brInDocLine            : longint;
  brQty                  : Double;
  brQtyUsed              : Double;
  brUsedRec              : WordBool;
  brInLocation           : string[10];
  brOutLocation          : string[10];
  PadChar4               : array[1..2] of char;
  brOutOrderRef          : string[10];
  brInOrderRef           : string[10];
  brInOrderLine          : longint;
  brOutOrderLine         : longint;
  brCostPriceCurrency    : Smallint;
  brPickingPriority      : string[10];
  PadChar5               : array[1..3] of char;
  brSalesPrice           : Double;
  brCompanyRate          : Double;
  brDailyRate            : Double;
  brUseORate             : WordBool;
  PadChar6               : array[1..2] of char;
  brTriRates             : Double;
  brTriEuro              : SmallInt;
  brTriInvert            : WordBool;
  brTriFloat             : WordBool;
  brUseByDate            : string[10];
  PadChar7               : char;
  brSalesPriceCurrency   : Smallint;
  brUnitOfMeasurement    : string[10];
  PadChar8               : char;
  brAutoPickMode         : Smallint;  //Auto pick settings - 0 Normal, 1 Lock bin, 2 Match bin by tagno
  brTagNo                : SmallInt;
  brRecPos               : longint;
  brReturned             : WordBool;
  brStockCode            :  String[16];         { Stock Code }
  //PR: 11/04/2014 ABSEXCH-14755 Fields to allow transaction line to be updated
  brLatestInDoc          : string[10];
  brLatestInLine         : longint;
  //AP : 15/12/2016 : ABSEXCH-17327 When adding stock items to an existing bin (using AddToBin), the line bin quantity is not being updated
  brAddQty               : Double;
  Spare                  : Array[1..498] of Byte;
  LastChar               : Char;
end;

TBatchReturnCreateRec = Record
  UnderWarranty : Boolean;
  CreateDate : String[8];
  Period,
  Year : Byte;
  YourRef : String[20];
  Reason : Byte;
  SetReturnedQty,
  AddToExistingReturn : Boolean;
  ReturnOurRef : String[10];
  Qty : Double;
  Location : String[10];
  AcCode : string[10];
  BackToBack : Boolean;
  ParentOurRef : String[10];
  ParentLineNo : longint;
  rcStatus : longint;
  rcAbsLineNo : longint;
  Supplier : String[6];
  DirectCustomerRepair : WordBool;
end;

TBatchReturnActionRec = Record
  Action : SmallInt;
  ReturnDocType : SmallInt;
  CreditOriginal : WordBool;
  ApplyRestockingCharge : WordBool;
  ReturnedItems : Smallint;
  ApplyCurrentPrice : WordBool;
  B2BSORRef : string[10];
  B2BSorLineCount : longint;
end;

TBatchMultiBuyDiscount = Record
  mbdOwnerType         :  Char; //'C' - Customer, 'S' - Supplier, 'T' - Stock
  mbdDiscountType      :  Char; //'0' - Buy x get y free, '1' - Buy x for special price, '2' - Buy x get y% discount
  mbdAcCode            :  String[6];
  mbdStockCode         :  String[16];
  mbdCurrency          :  SmallInt;
  mbdStartDate         :  String[8];
  mbdEndDate           :  String[8];
  mbdUseDates          :  WordBool;
  mbdBuyQty            :  Double;
  mbdRewardValue       :  Double;
  mbdApplyQty          :  Integer; //COM Toolkit only
  RecordPosition       :  longint;

  Spare                :  Array[1..255] of Byte;
  LastChar             :  Char;
end;





