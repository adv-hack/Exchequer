Attribute VB_Name = "MTOOLDLL"
Option Explicit

Global Const DllFalse% = 0
Global Const DllTrue% = 1

Global Const B_Insert% = 2     ' Add new Record
Global Const B_Update% = 3     ' Update existing Record
Global Const B_GetEq% = 5
Global Const B_GetNext% = 6
Global Const B_GetPrev% = 7
Global Const B_GetGretr% = 8
Global Const B_GetGEq% = 9
Global Const B_GetLess% = 10
Global Const B_GetLessEq% = 11
Global Const B_GetFirst% = 12
Global Const B_GetLast% = 13
Global Const B_StepFirst% = 33
Global Const B_StepLast% = 34
Global Const B_StepNext% = 24
Global Const B_StepPrev% = 35

Global Const AcType_Any% = 0
Global Const AcType_Cust% = 1
Global Const AcType_Supp% = 2

'---------------------------------------------------------------------------------------

' Misc subrecords
Type AddrType
    AddrLen       As String * 1
    Address       As String * 30
End Type

Type DateType
    DateLen       As String * 1
    Date          As String * 8
End Type

Type Str15Type
    StringLen     As String * 1
    String        As String * 15
End Type

'---------------------------------------------------------------------------------------

Type TermsType
    TermLen       As String * 1
    Term          As String * 60
End Type

Type TBatchCURec
    CustCodeLen   As String * 1
    CustCode      As String * 6
    CustSupp      As String * 1     ' Char C/S
    CompanyLen    As String * 1
    Company       As String * 45    ' *** v4.31:- Extended from 30
    AreaCodeLen   As String * 1
    AreaCode      As String * 4
    RepCodeLen    As String * 1
    RepCode       As String * 4
    RemitCodeLen  As String * 1
    RemitCode     As String * 10
    VATRegNoLen   As String * 1
    VATRegNo      As String * 30
    Addr(4)       As AddrType       ' 5 elements: 0-4
    PadChar5      As String * 1     ' *** v4.31:- Padding Character for Word Alignment
    DespAddr      As Integer        ' 0 = False, 1 = True
    DAddr(4)      As AddrType       ' 5 elements: 0-4
    ContactLen    As String * 1
    Contact       As String * 25
    PhoneLen      As String * 1
    Phone         As String * 30    ' *** v4.31:- Extended from 20
    FaxLen        As String * 1
    Fax           As String * 30    ' *** v4.31:- Extended from 20
    RefNoLen      As String * 1
    RefNo         As String * 10
    TradTerm      As Integer       ' 0 = False, 1 = True
    STerms(1)     As TermsType
    Currency      As Integer       ' SC=0, Euro=1-2 MC=1-89
    VATCode       As String * 1    ' Char
    PadChar1      As String * 1             ' Padding Character for Word Alignment
    PayTerms      As Integer
    CreditLimit   As Double
    Discount      As Double
    CreditStatus  As Integer
    CustCCLen     As String * 1
    CustCC        As String * 3
    CDiscCh       As String * 1    ' Char
    CustDepLen    As String * 1
    CustDep       As String * 3
    PadChar2      As String * 1         ' Padding Character for Word Alignment
    EECMember     As Integer       ' 0 = False, 1 = True
    IncStat       As Integer       ' 0 = False, 1 = True
    DefNomCode    As Long
    DefMLocStkLen As String * 1
    DefMLocStk    As String * 3
    AccStatus     As Integer
    PayType       As String * 1    ' Char
    BankSortLen   As String * 1
    BankSort      As String * 15    ' *** v4.31:- Extended from 6
    BankAccLen    As String * 1
    BankAcc       As String * 20    ' *** v4.31:- Extended from 8
    BankRefLen    As String * 1
    BankRef       As String * 28    ' *** v4.31:- Extended from 18
    LastUsed      As DateType

    ' Added for v4.02 07/01/97
    Phone2Len       As String * 1
    Phone2          As String * 30    ' *** v4.31:- Extended from 20
    UserDef1Len     As String * 1
    UserDef1        As String * 20
    UserDef2Len     As String * 1
    UserDef2        As String * 20
    SOPInvCodeLen   As String * 1
    SOPInvCode      As String * 6
    PadChar3        As String * 2    ' *** v4.31:- Extended from 1
    SOPAutoWOff     As Integer       ' 0 = False, 1 = True
    PadChar6        As String * 2    ' *** v4.31
    BOrdVal         As Double
                      
    ' Added on 23/07/97
    DefCOSNom       As Long          ' Cost of Sales Nominal Code
    DefCtrlNom      As Long          ' Sales Nominal Code
    
    ' Added on 20/01/98
    DirDeb          As Integer       ' Current Direct Debit Mode
    CCDSDateLen     As String * 1
    CCDSDate        As String * 8    ' *** v4.31:- Extended from 6 - Credit Card Start Date
    CCDEDateLen     As String * 1
    CCDEDate        As String * 8    ' *** v4.31:- Extended from 6 - Credit Card End Date
    CCDNameLen      As String * 1
    CCDName         As String * 50   ' *** v4.31:- Extended from 30 - Name on Credit Card
    CCDCardNoLen    As String * 1
    CCDCardNo       As String * 30   ' *** v4.31:- Extended from 19 - Credit Card No
    CCDSARefLen     As String * 1
    CCDSARef        As String * 4    ' Credit Card Switch Ref

    ' Added on 17/11/98
    PadChar7        As String * 1
    DefSetDDays     As Integer       ' Default Sett.Discount Days
    PadChar4        As String * 2    ' Padding Char for Word Alignment
    DefSetDisc      As Double        ' Default Sett.Discount%
    DefFormNo       As Integer       ' Default Form Set No., 0-99, default 0
                
    ' *** v4.31
    StatDMode       As Integer      ' Statement/Remittance delivery mode:-
                                     '        0 = Printed. 1 = Fax  2 = email
    EmailAddrLen    As String * 1
    EmailAddr       As String * 100    ' Email address for Statment/ Remittance
    PadChar         As String * 1
    EmlSndRdr       As Integer       ' On next email transmnision, send reader & reset
    ebusPwrdLen     As String * 1
    ebusPwrd        As String * 20    ' ebusiness module web password
    PostCodeLen     As String * 1
    PostCode        As String * 20    ' Seperate postcode
    CustCode2Len    As String * 1
    CustCode2       As String * 20    ' Alternative look up code, can be blank
    PadChar8        As String * 1     ' Padding Char for Word Alignment
    AllowWeb        As Integer        ' Allow upload to Web
    EmlZipAtc       As Integer       ' Default Zip attachement
    UserDef3Len     As String * 1
    UserDef3        As String * 30    ' User Defined 3
    UserDef4Len     As String * 1
    UserDef4        As String * 30    ' User Defined 4
    TimeChangeLen   As String * 1
    TimeChange      As String * 6     ' ReadOnly - Time stamp for record Change
    SSDDelTermsLen  As String * 1
    SSDDelTerms     As String * 5     ' *     "     Delivery Terms
    CVATIncFlg      As String * 1
    SSDModeTr       As Integer
    LastOpoLen      As String * 1
    LastOpo         As String * 10
    PadChar9        As String * 1     ' Padding Char for Word Alignment
    InvDMode        As Integer       ' Invoice delivery mode
    EmlSndHTML      As Integer       ' When sending XML, send HTML
    WebLiveCatLen   As String * 1
    WebLiveCat      As String * 20
    WebPrevCatLen   As String * 1
    WebPrevCat      As String * 20
    
    ' 27.09.2000
    SOPConsHO       As Integer      ' Consolidate Committed Balance. 0 or 1 only

    ' 03/04/01: Extended for Enterprise v4.32
    EmlUseEDZ       As Integer      ' When Zipping attachments send as .EDZ instead of .ZIP - 0 = False, 1 = True

    ' 25/03/02 - v5.00 : Default Tag Number
    DefTagNo        As Integer
        
    OrderConsMode   As Integer
    
    ' 21/10/2011 - v6.9 User Defined Fields 5-10
    UserDef5Len     As String * 1
    UserDef5        As String * 30    ' User Defined 5
    UserDef6Len     As String * 1
    UserDef6        As String * 30    ' User Defined 6
    UserDef7Len     As String * 1
    UserDef7        As String * 30    ' User Defined 7
    UserDef8Len     As String * 1
    UserDef8        As String * 30    ' User Defined 8
    UserDef9Len     As String * 1
    UserDef9        As String * 30    ' User Defined 9
    UserDef10Len    As String * 1
    UserDef10       As String * 30    ' User Defined 10

    '16/10/2013 v7.0.7
    acDeliveryPostCodeLen As String * 1
    acDeliveryPostCode    As String * 20

    '28/11/2013 v7.0.8
    acSubType             As String * 1
    acLongAcCodeLen       As String * 1
    acLongAcCode          As String * 30

    ' 03/06/2015 v7.0.14
    PadChar10      As String * 1
    acPPDMode      As Integer

    acCountryLen   As String * 1
    acCountry      As String * 2
    
    acDeliveryCountryLen   As String * 1
    acDeliveryCountry      As String * 2
        
    Spare           As String * 7
    LastChar        As String * 1
End Type

'---------------------------------------------------------------------------------------

Type TBatchTHRec
    RunNo           As Long
    CustCodeLen     As String * 1
    CustCode        As String * 6
    OurRefLen       As String * 1
    OurRef          As String * 9
    PadChar1        As String * 3     ' Padding Characters for Word Alignment
    FolioNum        As Long
    Currency        As Integer
    AcYr            As Integer
    AcPr            As Integer
    DueDateLen      As String * 1
    DueDate         As String * 8
    TransDateLen    As String * 1
    TransDate       As String * 8
    CoRate          As Double        ' Company Currency Rate
    DailyRate       As Double        ' *** v4.31 formerly VatRate - Daily Currency Rate
    OldYourRefLen   As String * 1
    OldYourRef      As String * 10   ' Account Ref - free text. No longer used
    LongYrRefLen    As String * 1
    LongYrRef       As String * 20   ' Additional reference field
    LineCount       As Long          ' Transaction line count
    TransDocHedLen  As String * 1
    TransDocHed     As String * 3    ' Transaction Type, ie 'SIN'
    InvVatAnal(20)  As Double        ' *** v4.31 Extended from 16 - VAT Analysis 0-20: S,Z,E,1 TO 9,A,D,T,X
    InvNetVal       As Double        ' Total Posting Value of Transaction
    InvVat          As Double        ' Total Tax Content
    DiscSetl        As Double        ' Discount Avail/Take
    DiscSetAm       As Double        ' Actual Value of Settle Discount
    DiscAmount      As Double        ' Discount Amount
    DiscDays        As Integer       ' No Days Disc Avail
    DiscTaken       As Integer       ' Discount Taken
    Settled         As Double        ' R/O Amount Paid Off
    TransNat        As Integer       ' VAT Nature of Transaction
    TransMode       As Integer       ' VAT Mode of Transport
    HoldFlg         As Integer       ' Hold Status
    PadChar2        As String * 2    ' Padding Characters for Word Alignment
    TotalWeight     As Double        ' Order Weight Details
    DAddr(4)        As AddrType      ' Delivery Address - 5 elements: 0-4
    PadChar3        As String * 1    ' Padding Character for Word Alignment
    TotalCost       As Double        ' Total value of cost prices for profitablity
    PrintedDoc      As Integer       ' R/O This Document has been printed
    ManVAT          As Integer       ' If Set, prevents re-calclation of VAT
    DelTermsLen     As String * 1
    DelTerms        As String * 3    ' VAT Delivery Terms
    OpNameLen       As String * 1
    OpName          As String * 10   ' Operators User Name
    DJobCodeLen     As String * 1
    DJobCode        As String * 10   ' Default Document Job Code
    DJobAnalLen     As String * 1
    DJobAnal        As String * 10   ' Default Document Anal Code
    PadChar4        As String * 3    ' Padding Character for Word Alignment
    TotOrdOS        As Double        ' Value of Order Outstanding
    DocUser1Len     As String * 1
    DocUser1        As String * 20   ' User def fields
    DocUser2Len     As String * 1
    DocUser2        As String * 20   ' User def fields
    EmpCodeLen      As String * 1
    EmpCode         As String * 6    ' Employee Code for TSH
    PadChar5        As String * 1    ' Padding Character for Word Alignment
    Tagged          As Integer       ' Doc Mark- Read Only
    thNoLabels      As Integer
    PadChar6        As String * 2    ' Padding Character for Word Alignment
                
    ' Added 19/03/1998
    CtrlNom         As Long          ' Debtor/Creditor Control Nominal

    ' *** 4.31
    DocUser3Len     As String * 1
    DocUser3        As String * 30   ' User def field 3
    DocUser4Len     As String * 1
    DocUser4        As String * 30   ' User def field 4
    SSDProcess      As String * 1    ' SSD process flag
    PadChar7        As String * 1
    ExtSource       As Integer       ' If transaction created externaly where from
    PostDateLen     As String * 1
    PostDate        As String * 8    ' Date posted, used for EC + SSD
    PadChar8        As String * 1
    PORPickSOR      As Integer       ' Back to Back SOR/POR auto picks SOR
    PadChar9        As String * 2
    BDiscount       As Double        ' Amount of discount applied via batch
    PrePostFlg      As Integer       ' Used to indicate on Noms if posting should generate any associated
                                     ' transactions, for example, if an auto reversing NOM should generate
                                     ' its auto reversal

    AllocStat       As String * 1    ' Outstanding Flag,
                                     '   "C"=Outstanding Sales Transaction
                                     '   "S"=Outstanding Purchase Transaction
    PadChar10       As String * 1
    SOPKeepRate     As Integer       ' Whether to keep a fixed exchange rate

    ' Added for v5.50
    TimeCreateLen   As String * 1
    TimeCreate      As String * 6
    TimeChangeLen   As String * 1
    TimeChange      As String * 6
    CISTax          As Double        ' Total amount of CIS tax to be deducted
    CISDeclared     As Double        ' Total amount of CIS declared on vouchers, correlates to Currsettled at time of voucher production
    CISManualTax    As Byte          ' Tax was overridden by manual adjustment, do not auto calculate, 0=False, 1=True
    CISDateLen      As String * 1
    CISDate         As String * 8    ' Date of next voucher run
    PadChar11       As String * 2    ' Padding Character for Word Alignment
    TotalCost2      As Double        ' Cost appotrionment from outside costs, included in GP
    CISEmplLen      As String * 1
    CISEmpl         As String * 10   ' Employe code used for this CIS Entry
    PadChar12       As String * 1    ' Padding Character for Word Alignment
    CISGross        As Double        ' Basis of CIS Tax
    CISHolder       As Byte          ' >0 Document is a CIS carrier generated from another process like
                                     ' self billing (2) or retentions (1).
                                     ' Has no lines of its own which would generate CIS, but is required
                                     ' to place in CIS returns *}
    ' Added for v5.51
    NOMVatIO        As String * 1    ' 0 = N/A, I = Input, O = Output
    
    ' Added for v5.60
    AutoInc         As Integer
    AutoIncBy       As String * 1
    AutoEndDateLen  As String * 1
    AutoEndDate     As String * 8
    AutoEndPr       As Integer
    AutoEndYr       As Integer
    AutoPost        As Integer
    
    thAutoTransaction       As Integer
    PadChar13               As String * 3
    thDeliveryRunNoLen      As String * 1
    thDeliveryRunNo         As String * 12
    thExternal              As Integer
    thSettledVAT            As Double
    thVATClaimed            As Double
    thPickingRunNo          As Long
    PadChar15               As String * 5
    thDeliveryNoteRefLen    As String * 1
    thDeliveryNoteRef       As String * 10
    
    thVATCompanyRate        As Double
    thVATDailyRate          As Double
    thPostCompanyRate       As Double
    thPostDailyRate         As Double
    thPostDiscAmount        As Double
    PadChar16               As String * 2
    thPostDiscTaken         As Integer
    thLastDebtChaseLetter   As Long
    thRevaluationAdjustment As Double
    
    YourRefLen              As String * 1
    YourRef                 As String * 20   ' Account Ref - free text
    
    'v6.3
    PadChar17               As String * 1
    thWeekMonth             As Integer
    thWorkflowState         As Long
    
    'v6.5
    thOverrideLocationLen   As String * 1
    thOverrideLocation      As String * 3
        
    
    ' 21/10/2011 - v6.9 User Defined Fields 5-10
    DocUser5Len     As String * 1
    DocUser5        As String * 30   ' User def field 5
    DocUser6Len     As String * 1
    DocUser6        As String * 30   ' User def field 6
    DocUser7Len     As String * 1
    DocUser7        As String * 30   ' User def field 7
    DocUser8Len     As String * 1
    DocUser8        As String * 30   ' User def field 8
    DocUser9Len     As String * 1
    DocUser9        As String * 30   ' User def field 9
    DocUser10Len    As String * 1
    DocUser10       As String * 30   ' User def field 10

    ' 16/10/2013 - v7.0.7
    thDeliveryPostcodeLen As String * 1
    thDeliveryPostcode    As String * 20
    PadChar18             As String * 1
    thOriginatorLen       As String * 1
    thOriginator          As String * 36
    thCreationTimeLen     As String * 1
    thCreationTime        As String * 6
    thCreationDateLen     As String * 1
    thCreationDate        As String * 8

    ' 03/06/2015 v7.0.14 New fields for Prompt Payment Discount
    PadChar19             As String * 1   ' Padding character for Word Alignment
    thPPDPercentage       As Double       ' Discount Percentage - Note: 0.1 = 10% 
    thPPDDays             As Integer      ' Number of days discount offer is valid for
    thPPDGoodsValue       As Double       ' Goods Value of Discount in Transaction Currency
    thPPDVATValue         As Double       ' VAT Value of Discount in Transaction Currency
    thPPDTaken            As Integer      ' 0=Not Taken, 1 = Taken, 2 = Taken outside terms

    thDeliveryCountryLen   As String * 1
    thDeliveryCountry      As String * 2

    PadChar20              As String * 1
    thIntrastatOutOfPeriod As Integer     ' Intrastat Out of Period Flag (Read-only)

    Spare           As String * 477
    LastChar        As String * 1    ' Padding Character for Word AlignmentEnd Type
End Type

'---------------------------------------------------------------------------------------

Type TBatchTLRec
    TransRefNoLen   As String * 1
    TransRefNo      As String * 9    ' Parent Transaction number
    PadChar1        As String * 2    ' Padding Character for Word Alignment
    LineNo          As Long          ' Array / Line No
    NomCode         As Long          ' Nominal Code
    Currency        As Integer       ' Transaction Currency [0-30]
    PadChar2        As String * 2    ' Padding Character for Word Alignment
    CoRate          As Double        ' Line Currency Rate
    DailyRate       As Double        ' *** v4.31 formerly VatRate - Daily Currency Rate
    CCLen           As String * 1
    CC              As String * 3    ' Cost Centre Code
    DepLen          As String * 1
    Dep             As String * 3    ' Department Code
    StockCodeLen    As String * 1
    StockCode       As String * 16   ' Stock Code
    PadChar3        As String * 3    ' Padding Character for Word Alignment
    Qty             As Double        ' Qty!
    QtyMul          As Double        ' Qty Multiplier Factor
    NetValue        As Double        ' Line Total excluding Tax
    Discount        As Double        ' Amount/%
    VATCode         As String * 1    ' VATCode
    PadChar4        As String * 3    ' Padding Character for Word Alignment
    VAT             As Double        ' Tax Line Content
    Payment         As Integer       ' Line Type
    DiscountChr     As String * 1    ' Flag to indicate if disc is amount or %
    PadChar5        As String * 1    ' Padding Character for Word Alignment
    QtyWOFF         As Double        ' Total Qty Written OFF
    QtyDel          As Double        ' Total Qty Physicaly delivered +WOFF - Qty = OS
    CostPrice       As Double
    CustCodeLen     As String * 1
    CustCode        As String * 6    ' Account Code
    LineDateLen     As String * 1
    LineDate        As String * 8    ' Line Transaction date. SPOP= Delivery Date
    ItemLen         As String * 1
    item            As String * 3
    DescLen         As String * 1
    Desc            As String * 55   ' Line Desc
    LWeight         As Double        ' Weight of Sales Unit in Kg
    MLocStkLen      As String * 1
    MLocStk         As String * 3    ' Multi stock location code
    JobCodeLen      As String * 1
    JobCode         As String * 10   ' Job Code
    AnalCodeLen     As String * 1
    AnalCode        As String * 10   ' Job Analysis Code
    TSHCCurr        As Integer       ' Charge Currency for Job Costing Time Sheet
    DocLTLink       As Integer       ' Doc Line Type Link
    Spare3          As String * 2    ' Padding Character for Word Alignment
    KitLink         As Long          ' Folio No. of parent Stock code for kit line
    FolioNum        As Long          ' Folio No. Of Transaction header
    
    ' Added 03/12/97
    LineType        As String * 1    ' Transaction Line Type
    
    ' Added 27/01/98
    Reconcile       As String * 1    ' Status of item for reconciling ie cleared etc

    ' Added 14/08/98
    PadChar6        As String * 2
    SOPLink         As Long          ' Folio No. of Parent Order Line
    SOPLineNo       As Long          ' Folio No. of Prarent ABSLineNo

    ' Added on 10.09.98
    AbsLineNo       As Long          ' Absolute, non moveable line no.

    ' *** v4.31
    LineUser1Len    As String * 1
    LineUser1       As String * 30   ' Line user def 1
    LineUser2Len    As String * 1
    LineUser2       As String * 30   ' Line user def 2
    LineUser3Len    As String * 1
    LineUser3       As String * 30   ' Line user def 3
    LineUser4Len    As String * 1
    LineUser4       As String * 30   ' Line user def 4
    SSDUplift       As Double        ' Intrastat uplift %
    SSDCommodLen    As String * 1
    SSDCommod       As String * 10    ' SSD Commodity code - Numbers Only
    PadChar7        As String * 1
    SSDSPUnit       As Double        ' SSD unit into sales unit
    SSDUseLine      As Integer      ' Take the ssd values from the line
    PadChar8        As String * 2
    PriceMulx       As Double        ' Price rate multiplier to get price per

    ' *** v4.31 21/12/99
    QtyPick         As Double
    VATIncFlag      As String * 1

    ' *** v4.31 12/01/00
    PadChar9        As String * 3
    QtyPWOff        As Double
    PadChar10       As String * 2
    RtnErrCode      As Integer      ' Return Error Code
    
    SSDCountryLen   As String * 1
    SSDCountry      As String * 5
    
    ' Added 9/9/02 original value for Vat inclusive
    PadChar11       As String * 2
    IncNetValue     As Double
                
    ' v5.50
    AutoLineType    As Byte         ' Line has been auto manufactured.
                                    '   0 = Not auto line.
                                    '   1 = via customisation
                                    '   2 = via CIS routine }
    CISRateCode     As String * 1   ' Valid CIS Tax rate code
    PadChar12       As String * 2
    CISRate         As Double       ' CIS % rate aplied
    CostApport      As Double       ' Cost apportionment value
    
    ' v5.51
    NOMVatType      As Byte         ' 0 = N/A, 1 = Auto, 2 = Manual
    '5.52 27/08/03
    PadChar13       As String * 3
    BinQty          As Double       'Bin Quantity for Multi-Bin support
    
    ' Added for v5.60
    tlAltStockFolio          As Long
    tlRunNo                  As Long
    tlStockDeductQty         As Double
    PadChar16                As String * 2
    tlUseQtyMul              As Integer
    tlSerialQty              As Double
    PadChar17                As String * 2
    tlPriceByPack            As Integer
    tlPadChar18              As String * 3
    tlReconciliationDateLen  As String * 1
    tlReconciliationDate     As String * 8
    tlB2BLinkFolio           As Long
    tlB2BLineNo              As Long
    tlCOSDailyRate           As Double
    tlQtyPack                As Double
    
    ' Added for v6.01 Advanced Discounts
    tlMultiBuyDiscount       As Double
    tlMultiBuyDiscountChr    As String * 1
    PadChar19                As String * 3
    tlTransValueDiscount     As Double
    tlTransValueDiscountChr  As String * 1
    PadChar20                As String * 1
    tlTransValueDiscountType As Integer
    
    'Added for v6.2 EC Service Fields
    tlECService              As Integer
    tlECServiceStartDateLen  As String * 1
    tlECServiceStartDate     As String * 8
    tlECServiceEndDateLen    As String * 1
    tlECServiceEndDate       As String * 8
    tlECSalesTaxReported     As Double
    tlECPurchaseServiceTax   As Double
    
    'v6.3
    tlReferenceLen           As String * 1
    tlReference              As String * 20
    tlReceiptNoLen           As String * 1
    tlReceiptNo              As String * 20
    tlFromPostCodeLen        As String * 1
    tlFromPostCode           As String * 15
    tlToPostCodeLen          As String * 1
    tlToPostCode             As String * 15
    
    tlIntrastatNoTCLen       As String * 1
    tlIntrastatNoTC          As String * 2    'Intrastat Nature of Transaction


    Spare           As String * 39
    Spare2          As String * 3
    LastChar        As String * 1    ' Padding Character for Word Alignment
End Type

' Detail Lines structure - setup for 10 lines to reduce memory usage
Type TBatchLinesRec
    Lines(0 To 1)       As TBatchTLRec
End Type

'---------------------------------------------------------------------------------------

' Sales Band structure
Type TSaleBandsRec
    Currency        As Integer      ' Currency of Band
    PadChar1        As String * 2   ' Padding Characters for Word Alignment
    SalesPrice      As Double       ' Price of Band
    PadChar2        As String * 3   ' Padding Characters for Word Alignment
    Spare           As String * 20
    LastChar        As String * 1   ' Padding Character for Word Alignment
End Type

' Sales Band Array used by TBatchSKRec structure
Type TSaleBandAry
    Band(7)       As TSaleBandsRec
End Type

'---------------------------------------------------------------------------------------

' Description Line used by TBatchSKRec
Type TBatchSKRecDesc
    DescLen           As String * 1
    Desc              As String * 35
End Type

' Stock Record
Type TBatchSKRec
    StockCodeLen      As String * 1
    StockCode         As String * 16       ' Stock Code
    Desc(1 To 6)      As TBatchSKRecDesc
    AltCodeLen        As String * 1
    AltCode           As String * 16       ' Secondary Lookup Key
    SuppTempLen       As String * 1
    SuppTemp          As String * 6        ' Preferred Supplier
    PadChar1          As String * 3        ' Padding Characters for Word Alignment
    NomCodeS(1 To 5)  As Long              ' Sales, COS, P&L, ??, WIP
    MinFlg            As Integer           ' Min ROL Flag (0 = False, 1 = True)
    PadChar2          As String * 2        ' Padding Characters for Word Alignment
    StockFolio        As Long              ' Numerical Equivalent Code
    StockCatLen       As String * 1
    StockCat          As String * 16       ' Code of Parent on Tree
    StockType         As String * 1        ' History & Tree Type, H/P/D/M/X
    UnitKLen          As String * 1
    UnitK             As String * 10       ' Descriptive Stocking Unit Qty
    UnitSLen          As String * 1
    UnitS             As String * 10       '      "      Selling    "   "
    UnitPLen          As String * 1
    UnitP             As String * 10       '      "      Purchase   "   "
    PadChar13         As String * 3        ' Padding Characters for Word Alignment
    PCurrency         As Integer           ' Cost Price Currency
    CostPrice         As Double            ' Last Cost Price / Stock Valuation Price
    SaleBands         As TSaleBandAry      ' Multiple Selling Bands A-H
    SellUnit          As Double            ' Selling Qty Multiple
    BuyUnit           As Double            ' Purchase Qty   "
    VATCode           As String * 1        ' Default VAT Lookup
    CCLen             As String * 1
    CC                As String * 3        ' Cost Centre Anal
    DepLen            As String * 1
    Dep               As String * 3        ' Dept Anal
    PadChar3          As String * 3        ' Padding Characters for Word Alignment
    QtyInStock        As Double            ' Physical Stock
    QtyPosted         As Double            ' Physical Posted Stock
    QtyAllocated      As Double            ' Backorder Qty
    QtyOnOrder        As Double            ' OnOrder Qty
    QtyMin            As Double            ' Min Stock Level Qty
    QtyMax            As Double            ' Max   "     "    "
    ROQty             As Double            ' Qty Orded this order
    CommodCodeLen     As String * 1
    CommodCode        As String * 10       ' VAT Commodity Code
    PadChar4          As String * 1        ' Padding Character for Word Alignment
    SWeight           As Double            ' Sales  Unit Weight
    PWeight           As Double            ' Purchase "    "
    UnitSuppLen       As String * 1
    UnitSupp          As String * 10       ' Supplimentry unit
    PadChar5          As String * 1        ' Padding Character for Word Alignment
    SuppSUnit         As Double            ' No Units in Sales unit
    BinLocLen         As String * 1
    BinLoc            As String * 8        ' Physical location in stores
    PadChar6          As String * 1        ' Padding Character for Word Alignment
    CovPr             As Integer           ' Amount of periods to scan back to calc cover
    CovPrUnit         As String * 1        ' Period calc unit of measure, D/W/M
    PadChar7          As String * 1        ' Padding Character for Word Alignment
    CovMinPr          As Integer           ' Amount of Cover required in periods
    CovMinUnit        As String * 1        ' Cover amount unit D/W/M
    SupplierLen       As String * 1
    Supplier          As String * 6        ' Master Supplier Reference
    CovSold           As Double            ' Qty sold over cover period
    UseCover          As Integer           ' Use Cover on this record
    CovMaxPr          As Integer           ' Amount of Max Cover required
    CovMaxUnit        As String * 1        ' Unit of Max Cover
    PadChar8          As String * 1        ' Padding Character for Word Alignment
    ROCurrency        As Integer           ' Purchase Order Currency
    ROCPrice          As Double            ' Purchase Order Cost Price
    RODateLen         As String * 1
    RODate            As String * 8        '     "      "   Delivery Date
    StkValType        As String * 1        ' Stk Valuation Type C,L,F,S,A
    PadChar9          As String * 2        '
    QtyPicked         As Double            ' Count of Qty Picked so Far
    LastUsedLen       As String * 1
    LastUsed          As String * 8        ' Date Last updated
    StBarCodeLen      As String * 1
    StBarCode         As String * 20       ' Bar Code
    StRoCostCentreLen As String * 1
    StRoCostCentre    As String * 3        ' RO Cost Centre
    StRoDepartmentLen As String * 1
    StRoDepartment    As String * 3        ' RO Department
    StLocationLen     As String * 1
    StLocation        As String * 3        ' Location
    StPricePack       As Integer           ' Price per Pack
    StDPackQty        As Integer           ' Show Qty as Cases
    StKitPrice        As Integer           ' Use BOM price, ignore component price
    StKitOnPurch      As Integer           ' Explode kit on Purch transactions
    StStkUser1Len     As String * 1
    StStkUser1        As String * 20       ' User Defined Field 1
    StStkUser2Len     As String * 1
    StStkUser2        As String * 20       ' User Defined Field 2
    JAnalCodeLen      As String * 1
    JAnalCode         As String * 10       ' Default Job Analysis Code

    ' *** v4.31
    PadChar11         As String * 1
    WebInclude        As Integer           ' Include on Web export
    WebLiveCatLen     As String * 1        ' Read Only - Web current catalogue entry
    WebLiveCat        As String * 20       ' Read Only - Web current catalogue entry
    StkUser3Len       As String * 1
    StkUser3          As String * 30       ' Stk User Def 3
    StkUser4Len       As String * 1
    StkUser4          As String * 30       ' Stk User Def 4
    PadChar12         As String * 1
    SerNoWAvg         As Integer           ' Determins if average is to be used with snos
    SSDDUplift        As Double            ' Intrastat Uplift Dispatch default %
    TimeChangeLen     As String * 1
    TimeChange        As String * 6        ' Time stamp for record Change
    SVATIncFlg        As String * 1        ' Inc VAT Default
    LastOpoLen        As String * 1        ' Last operator
    LastOpo           As String * 10       ' Last operator
    ImageFileLen      As String * 1       ' Associated bitmap image
    ImageFile         As String * 30       ' Associated bitmap image
    WebPrevCatLen     As String * 1
    WebPrevCat        As String * 20

    SSDCountryLen     As String * 1
    SSDCountry        As String * 5
    
    PadChar14         As String * 1
    StkLinkLT         As Integer           'Default stock item line type normal, freight etc }

    ' 09.10.2000
    PriceByStkUnit    As Integer           ' Price by Stock Unit, 0=False, 1=True

    ' 31/07/2002
    ShowAsKit         As Integer           ' BOM exploded on Sales transactions

    ' 9/8/2002
    QtyPickWOR        As Double            ' Qty issued now, but not processed
    
    UsesBins          As Integer
    
    PadChar15         As String * 2
    SSDAUplift        As Double
    BOMProdTime       As Long
    WOPProdTimeDays   As Long
    WOPProdTimeHours  As Long
    WOPProdTimeMins   As Long
    WOPLeadTime       As Long
    PadChar16         As String * 2
    WOPCalcProdTime   As Integer
    WOPMinEcQty       As Double
    WOPIssuedWIPGL    As Long
    QtyAllocWOR       As Double
    QtyIssueWOR       As Double
    QtyStockTake      As Double
    PadChar17         As String * 2
    QtyStockTakeChanged As Integer
    QtyFreeze         As Double
    
    BinLoc10Len       As String * 1
    BinLoc10          As String * 10
    
    ' 21/10/2011 - v6.9 User Defined Fields 5-10
    StkUser5Len       As String * 1
    StkUser5          As String * 30       ' Stk User Def 5
    StkUser6Len       As String * 1
    StkUser6          As String * 30       ' Stk User Def 6
    StkUser7Len       As String * 1
    StkUser7          As String * 30       ' Stk User Def 7
    StkUser8Len       As String * 1
    StkUser8          As String * 30       ' Stk User Def 8
    StkUser9Len       As String * 1
    StkUser9          As String * 30       ' Stk User Def 9
    StkUser10Len      As String * 1
    StkUser10         As String * 30       ' Stk User Def 10
    
    
    Spare             As String * 234
    LastChar          As String * 1        ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

Type THistoryBalRec
    PeriodLen     As String * 1
    Period        As String * 5     ' Period; [+/-]N or YTD
    YearLen       As String * 1
    Year          As String * 5     ' Year; [+/-]N
    Currency      As Integer        ' SC=0, MC=1-30
    PadChar1      As String * 2     ' Padding Characters for Word Alignment
    Value         As Double         ' Returned value
    PadChar2      As String * 3     ' Padding Characters for Word Alignment
    
    ' 12.09.00 - Added Committed Value, PadChar3 & 4 fields
    PadChar3      As String * 1     ' Padding Characters for Word Alignment
    CommitVal     As Double         ' Committed Value
    PadChar4      As String * 3     ' Padding Characters for Word Alignment
    
    Spare         As String * 256
    LastChar      As String * 1     ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

' Nominal Record
Type TBatchNomRec
    NomCode       As Long
    DescLen       As String * 1
    Desc          As String * 30
    PadChar1      As String * 1     ' Padding Characters for Word Alignment
    Cat           As Long           ' Parent Code
    NomType       As String * 1     ' Heading / A,B,C
    PadChar2      As String * 1     ' Padding Characters for Word Alignment
    NomPage       As Integer        ' Page At end of this
    SubType       As Integer        ' Sub Total at end
    Total         As Integer        ' Show Balance only or Cr/Dr
    CarryF        As Long           ' Nom Code to Carry Forward to
    ReValue       As Integer        ' Code is to be revalued
    
    ' *** v4.31
    AltCodeLen    As String * 1
    AltCode       As String * 50    ' Readonly - Alternative look up code
    PadChar4      As String * 1
    DefCurr       As Integer        ' Validation currency associated with this G/L. 0= All
                     
    ' v5.51
    Inactive      As Integer        ' Boolean 0 - False, 1 - True
    LongDescLen   As String * 1     ' Length of LongDesc field
    LongDesc      As String * 40    ' 40 character description
    Spare         As String * 216
    LastChar      As String * 1     ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

Type TBatchBOMRec
    StockCodeLen  As String * 1
    StockCode     As String * 16    ' Stock Code
    PadChar1      As String * 3     ' Padding Characters for Word Alignment
    QtyUsed       As Double         ' Qty used in BOM
    QtyCost       As Double         ' Cost
    PadChar2      As String * 3     ' Padding Characters for Word Alignment
    LastChar      As String * 1     ' Last Character in record - used for VB alignment
End Type

Type TBatchBOMLinesRec
    Items(1 To 500) As TBatchBOMRec
End Type

'---------------------------------------------------------------------------------------

Type TBatchSRRec
    SerialNoLen   As String * 1
    SerialNo      As String * 20    ' Actual Serial No.
    BatchNoLen    As String * 1
    BatchNo       As String * 10    ' Seperate Batch No
    DateOutLen    As String * 1
    DateOut       As String * 8     ' Date Out
    PadChar1      As String * 3     ' Padding Characters for Word Alignment
    SerCost       As Double         ' CostPrice
    SerSell       As Double         ' Selling Price
    CurCost       As Integer        ' Currency of Cost Price
    CurSell       As Integer        ' Currency of Selling Price
    InMLocLen     As String * 1
    InMLoc        As String * 10    '  Location Filter
    OutMLocLen    As String * 1
    OutMLoc       As String * 10    '  Location Filter
    PadChar2      As String * 2     ' Padding Characters for Word Alignment
    BuyQty        As Double
    QtyUsed       As Double
    Sold          As Integer
    PadChar3      As String * 1     ' Padding Characters for Word Alignment
    LastChar      As String * 1     ' Last Character in record - used for VB alignment
End Type

'Type TBatchSRLinesRec
'     Lines(1 To 500)    As TBatchSRRec
'End Type

'---------------------------------------------------------------------------------------

' Stock/Location cross-reference details
Type TBatchSLRec
    lsStkCodeLen      As String * 1
    lsStkCode         As String * 16    ' Stock Code
    lsLocCodeLen      As String * 1
    lsLocCode         As String * 3     ' Loc Code
    PadChar1          As String * 3     ' Padding Characters for Word Alignment
    lsQtyInStock      As Double         ' Actual Stock
    lsQtyOnOrder      As Double         ' OnOrder
    lsQtyAlloc        As Double         ' Allocated
    lsQtyPicked       As Double         ' Picked
    lsQtyMin          As Double         ' Min
    lsQtyMax          As Double         ' Max
    lsQtyFreeze       As Double         ' Freeze Qty
    lsRoQty           As Double         ' Re-Order Qty
    lsRoDateLen       As String * 1
    lsRoDate          As String * 8     ' Re-Order Date
    lsRoCCLen         As String * 1
    lsRoCC            As String * 3     ' Re-Order CC
    lsRoDepLen        As String * 1
    lsRoDep           As String * 3     ' Re-Order Dep
    lsCCLen           As String * 1
    lsCC              As String * 3     ' Default CC
    lsDepLen          As String * 1
    lsDep             As String * 3     ' Default Dep
    lsBinLocLen       As String * 1
    lsBinLoc          As String * 10    ' Bin Location
    lsSaleBands       As TSaleBandAry   ' Pricing
    lsRoPrice         As Double         ' Re-Order Price
    lsRoCurrency      As Integer        '    "     Currency
    PadChar2          As String * 2     ' Padding Characters for Word Alignment
    lsCostPrice       As Double         ' Last Cost Price
    lsPCurrency       As Integer        '     "     Currency
    PadChar3          As String * 2     ' Padding Characters for Word Alignment
    lsDefNom(1 To 5)  As Long           ' 1-Sales,2-COS,3-P&L,4-BalSh,5-WIP
    lsMinFlg          As Integer        ' Below min Flg (0=False,1=True)
    lsTempSuppLen     As String * 1
    lsTempSupp        As String * 10    ' Temp Supplier
    lsSupplierLen     As String * 1
    lsSupplier        As String * 10    ' Main Suppplier
    lsLastUsedLen     As String * 1
    lsLastUsed        As String * 8     ' Last used rec
    PadChar4          As String * 3     ' Padding Characters for Word Alignment
    lsQtyPosted       As Double         ' Posted loc qty
    lsQtyTake         As Double         ' Stock Take Qty
    lsLastTimeLen     As String * 1
    lsLastTime        As String * 6     ' Last Edit time: HHMMSS
    
    ' Added 16/10/02
    PadChar6          As String * 1
    lsQtyAllocWOR     As Double         ' Allocated to WOR
    lsQtyIssueWOR     As Double         ' Issued to WOR
    lsQtyPickWOR      As Double         ' Picked on WOR
    lsWOPWIPGL        As Long           ' WIPGLCode
    
    Spare2            As String * 282
    PadChar5          As String * 1     ' Padding Character for Word Alignment
    LastChar          As String * 1     ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

' Location details
Type TBatchMLocRec
    loCodeLen          As String * 1
    loCode             As String * 3    ' Master Location Code
    loNameLen          As String * 1
    loName             As String * 45   '    "       "    Name
    loAddr(1 To 5)     As AddrType
    loTelLen           As String * 1
    loTel              As String * 25   ' Tel
    loFaxLen           As String * 1
    loFax              As String * 25   ' Fax
    loEmailLen         As String * 1
    loEmail            As String * 100  ' Email
    loModemLen         As String * 1
    loModem            As String * 25   ' Modem Number
    loContactLen       As String * 1
    loContact          As String * 30   ' Contact
    PadChar1           As String * 1    ' Padding Character for Word Alignment
    loCurrency         As Integer       ' Def Currency
    loAreaLen          As String * 1
    loArea             As String * 5    ' Report Area
    loRepLen           As String * 1
    loRep              As String * 5    ' Report Rep
    loTag              As Integer       ' Tagged (0=False,1=True)
    loNominal(1 To 5)  As Long
    loCCLen            As String * 1
    loCC               As String * 3    ' Def CC Dep
    loDepLen           As String * 1
    loDep              As String * 3    ' Def CC Dep
    loUsePrice         As Integer       ' Override Price (0=False,1=True)
    loUseNom           As Integer       ' Override Noms (0=False,1=True)
    loUseCCDep         As Integer       ' Override CCDep (0=False,1=True)
    loUseSupp          As Integer       ' Override Supplier (0=False,1=True)
    loUseBinLoc        As Integer       ' Override Bin Loc (0=False,1=True)
    
    ' Added 10/10/02 TKDLL500.124
    PadChar2           As String * 2
    loNLineCount       As Long          ' Notes Line Count
    loUseCPrice        As Integer       ' Use Locations own cost price
    loUseRPrice        As Integer       ' Use Locations own re-order price
    loWOPWIPGL         As Long          ' Override WIP GL
    
    Spare2             As String * 211
    LastChar           As String * 1    ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

' Matching Information
Type TBatchMatchRec
    DebitRefLen      As String * 1       ' Ex.OurRef (SIN/PIN)
    DebitRef         As String * 9       ' Ex.OurRef (SIN/PIN)
    CreditRefLen     As String * 1       ' Ex.OurRef (SRC/PPY)
    CreditRef        As String * 9       ' Ex.OurRef (SRC/PPY)
    DebitCr          As Integer          ' Currency of Debit Amount
    CreditCr         As Integer          ' Currency of Credit Amount
    DebitVal         As Double           ' Value of Debit Amount in Debit Currency
    CreditVal        As Double           ' Value of Credit Amount in Credit Currency
    BaseVal          As Double           ' Value of Amount Settled in Base Currency
    
    ' v5.50
    MatchType        As String * 1
    CustomRefLen     As String * 1
    CustomRef        As String * 10
    
    Spare            As String * 247
    LastChar         As String * 1       ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

' Notes Record
Type TBatchNotesRec
    NoteSortLen    As String * 1
    NoteSort       As String * 3       ' ACC/STK/DOC
    NoteType       As String * 1       ' 1=General 2=Dated Notes
    NoteCodeLen    As String * 1
    NoteCode       As String * 16      ' Account Code/Stock Code/Doc. No.
    NoteDateLen    As String * 1
    NoteDate       As String * 8       ' Optional Date for Note line (YYYYMMDD)
    AlarmDateLen   As String * 1
    AlarmDate      As String * 8       ' Optional Date for Alarm (YYYYMMDD)
    AlarmSet       As String * 1       ' Set Alarm Y/N - Optional
    PadChar1       As String * 1       ' Padding Character for Word Alignment
    LineNo         As Integer          ' Notes Line No.
    UserLen        As String * 1
    User           As String * 8       ' User/Login Code
    NoteLineLen    As String * 1
    NoteLine       As String * 65      ' Note Line Content
    
    ' 13.10.2000
    PadChar2       As String * 1       ' Padding Character for Word Alignment
    RepeatDays     As Integer          ' Repeat every xx Days
    NoteForLen     As String * 1
    NoteFor        As String * 10      ' Notes For valid user name in Enterprise
    
    Spare          As String * 242
    LastChar       As String * 1       ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

' Cost Centre / Department record
Type TBatchCCDepRec
    CCDepCodeLen   As String * 1
    CCDepCode      As String * 3   ' Cost Centre/Department Code
    CCDepDescLen   As String * 1
    CCDepDesc      As String * 30  ' Description
    Spare          As String * 256
    LastChar       As String * 1   ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

Type TBatchStkPriceRec
    StockCodeLen   As String * 1
    StockCode      As String * 16     ' Stock Code
    CustCodeLen    As String * 1
    CustCode       As String * 6      ' Customer/Supplier Code
    Currency       As Integer         ' Currency 0-29
    PadChar1       As String * 2      ' Padding Character for Word Alignment
    Qty            As Double          ' Quantity
    Price          As Double          ' Price before Discount
    DiscVal        As Double          ' Discount Amount or % Value
    DiscChar       As String * 1      ' Blank = Disc.Amount , % = Discount %
    
    ' 16/05/01: Ex_CalcStockPrice extended to support Locations
    LocCodeLen     As String * 1
    LocCode        As String * 3      ' Stock Location Code
    PriceDateLen   As String * 1
    PriceDate      As String * 8      ' Date of price wanted in format YYYYMMDD
    Spare          As String * 249
    LastChar       As String * 1      ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

' VAT Rates
Type TBatchVATRec
    VATCode      As String * 1       ' VAT Code
    PadChar1     As String * 3       ' Padding Character for Word Alignment
    VATRate      As Double           ' VAT Rate
    
    ' *** v4.31
    VATDescLen   As String * 1
    VATDesc      As String * 10
        
    VATSpare     As String * 17
    Spare        As String * 256
    PadChar2     As String * 3       ' Padding Character for Word Alignment
    LastChar     As String * 1       ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

' System Currency Information
Type TBatchCurrRec
    NameLen        As String * 1
    Name           As String * 11        ' Currency name
    ScreenSymbLen  As String * 1
    ScreenSymb     As String * 3         ' Screen Symbol
    PrinterSymbLen As String * 1
    PrinterSymb    As String * 3         ' Printer Symbol
    DailyRate      As Double             ' Daily Rate
    CompanyRate    As Double             ' Company Rate
    
    ' *** v4.31
    TriEuro        As Integer
    PadChar2       As String * 2
    TriRates       As Double
    TriInvert      As Integer
    TriFloat       As Integer
   
    Spare          As String * 256
    PadChar1       As String * 3         ' Padding Character for Word Alignment
    LastChar       As String * 1         ' Last Character in record - used for VB Alignment
End Type ' TBatchCurrRec

'---------------------------------------------------------------------------------------

' Pascal String Type used in VB5 for functions which return strings
Type PascalString
    StrLen  As Byte                      ' Was String * 1 pre v5.00 - Can be changed back if required
    Str     As String * 255
End Type

'---------------------------------------------------------------------------------------

Type TBatchSysRec
    UserNameLen      As String * 1
    UserName         As String * 45     ' Company Name
    UserAddr(0 To 4) As AddrType        ' Company Address (5 elements: 0-4)
    UserSortLen      As String * 1
    UserSort         As String * 6      ' Company Bank Sort Code
    UserAccLen       As String * 1
    UserAcc          As String * 8      ' Company Bank Account No.
    UserRefLen       As String * 1
    UserRef          As String * 18     ' Company Bank Reference
    UserBankLen      As String * 1
    UserBank         As String * 25     ' Company Bank Name
    ExPr             As Integer         ' Current Exchequer/Enterprise period - 1..99
    ExYr             As Integer         ' Current Exchequer/Enterprise Year - 90..115
    
    DirectCustLen    As String * 1
    DirectCust       As String * 10     ' Direct SRI
    DirectSuppLen    As String * 1
    DirectSupp       As String * 10     ' Direct PPI
    PriceDP          As Integer         ' Sales Price Decimal Places
    CostDP           As Integer         ' Cost Price Decimal Places }
    QuantityDP       As Integer         ' Quantity Decimal Places }
    MultiLocn        As Integer         ' Multi-Location Status:- 0=Disabled,
                                        '    1=Del.Address only, 2=Enabled
    UserVatRegLen    As String * 1
    UserVatReg       As String * 30
    PadChar          As String * 1
    PeriodsPerYr     As Integer         ' Number of periods in a year
    CCDepts          As Integer         ' Cost centres and departments in use?
    IntraStat        As Integer         ' Use Intrastat fields?
    ExchangeRate     As String * 1      ' Company or daily rate ???
    
    FinYearStartLen  As String * 1
    FinYearStart     As String * 8      ' Start of financial year yyyymmdd
    TraderUDFLabel(1 To 4) As Str15Type ' Trader User Defined Labels
    StockUDFLabel(1 To 4) As Str15Type       ' Stock User Defined Labels
    TransHeadUDFLabel(1 To 4) As Str15Type   ' Trans. Header User Defined Labels
    TransHeadUDFHide(1 To 4) As Integer      ' Hide status of Trans.Header User Defined Labels
    TransLineUDFLabel(1 To 4) As Str15Type   ' Trans. Line User Defined Labels
    TransLineUDFHide(1 To 4) As Integer      ' Hide status of Trans. Line User Defined Labels
    TransLineTypeLabel(1 To 4) As Str15Type  ' Trans. Line Type User Defined Labels
    TransLineTypeHide(1 To 4) As Integer     ' Hide status of Trans. Line Type User Defined Labels
    JobCostUDFLabel(1 To 2) As Str15Type     ' Job costing User Defined Labels
    CurrentCountryLen   As String * 1
    CurrentCountry      As String * 3    ' Country code for install
    OrderAllocStock     As Integer       ' Orders to allocate stock when picked

    ' 03.11.2000
    CalPrFromDate       As Integer       ' Calculate Period from Date }

    ' NF: 15/03/2001
    UseCrLimitChk       As Integer       ' Warn if Over Credit }
    UseCreditChk        As Integer       ' Warn if Wks odue }
    StopBadDr           As Integer       ' Stop Invoice Entry of Bad Debtor }
    UsePick4All         As Integer
    FreeExAll           As Integer       ' Free Stock to exclude allocated figure }
    WksODue             As Integer       ' No Wks before considered odue }
    DeductBOMComponents As Integer
    
    FilterSNoByBinLoc   As Integer
    KeepBinHistory      As Integer
    BinMaskLen          As String * 1
    BinMask             As String * 10
    PadChar2            As String * 1
    InputPackQtyOnLine  As Integer
    DiscountPercentages As Integer
    
    TTDEnabled          As Integer
    VBDEnabled          As Integer
    
    ECServicesEnabled   As Integer
    ECSalesThreshold    As Double
    
    EnableOverrideLocations As Integer

    '28/11/2013
    ConsumersEnabled    As Integer
    
        
    Spare               As String * 475
    LastChar            As String * 1      ' Last Character in record - used for VB alignment
End Type ' TBatchSysRec

'---------------------------------------------------------------------------------------

'Type TBatchAutoBankRec
'    BankRefLen      As String * 1
'    BankRef         As String * 40     ' Bank Matching Reference
'    PadChar1        as String * 3
'    BankValue       As Double          ' Statement value
'    BankNom         As Long            ' Nominal Code
'    BankCr          As Integer         ' Currency
'    EntryOpoLen     As String * 1
'    EntryOpo        As String * 10     ' Entered by
'    EntryDateLen    As String * 1
'    EntryDate       As String * 8      ' Entry Date
'
'    ' Added 25/08/99
'    AccountCodeLen  As String * 1
'    AccountCode     As String * 8
'    SortCodeLen     As String * 1
'    SortCode        As String * 6
'
'    Spare           As String * 181
'    LastChar        As String * 1      ' Last Character in record - used for VB alignment
'End Type ' TBatchAutoBankRec

'---------------------------------------------------------------------------------------

'Type TBatchBOMImportRec
'    PStockCodeLen  As String * 1
'    PStockCode     As String * 16      ' Parent Stock Code
'    MStockCodeLen  As String * 1
'    MStockCode     As String * 16      ' BOM Stock Code
'    PadChar1       As String * 2
'    QtyUsed        As Double           ' Quantity Used
'    DeleteStat     As Integer          ' Delete current BOM Lines Status
'
'    Spare          As String * 201
'    LastChar       As String * 1       ' Last Character in record - used for VB alignment
'End Type ' TBatchBOMImportRec

'---------------------------------------------------------------------------------------

Type TBatchSerialRec
    SerialNoLen    As String * 1
    SerialNo       As String * 20    ' Actual Serial No.
    BatchNoLen     As String * 1
    BatchNo        As String * 10    ' Separate Batch No.
    StockCodeLen   As String * 1
    StockCode      As String * 16    ' Stock Code

    InDocLen       As String * 1
    InDoc          As String * 10    ' Input Doc No.
    DateIn         As DateType       ' Date In
    PadChar1       As String * 3     ' Padding Character for Word Alignment
    SerCost        As Double         ' CostPrice
    CurCost        As Integer        ' Currency Cost Price
    PadChar2       As String * 2     ' Padding Character for Word Alignment
    BuyABSLine     As Long           ' Purchase Line
    BuyQty         As Double         ' Original Batch Qty
    InMLocLen      As String * 1
    InMLoc         As String * 3     ' Location Filter
    OutDocLen      As String * 1
    OutDoc         As String * 10    ' Output Doc No.
    DateOutLen     As String * 1
    DateOut        As String * 8     ' Date Sold
    SerSell        As Double         ' Selling Price
    CurSell        As Integer        ' Selling Price Currency
    PadChar3       As String * 2     ' Padding Character for Word Alignment
    SoldABSLine    As Long           ' ABS Line No of Doc Sold
    QtyUsed        As Double         ' Amount Used from  Batch
    OutMLocLen     As String * 1
    OutMLoc        As String * 3     ' Location Filter
    Sold           As Integer        ' Sold Status
    BatchRec       As Integer        ' Indicates this is soley a batch record
    BatchChild     As Integer        ' Read Only - Auto generated item to record sale doc for batch
    PadChar4       As String * 2
    CoRate         As Double         ' Company Rate
    DailyRate      As Double         ' Daily Rate
    InOrdDocLen    As String * 1
    InOrdDoc       As String * 10    ' Original In Order
    PadChar5       As String * 1     ' Padding Character for Word Alignment
    InOrdLine      As Long           ' Line Number of original order
    OutOrdDocLen   As String * 1     ' Original Out Order
    OutOrdDoc      As String * 10    ' Original Out Order
    PadChar6       As String * 1     ' Padding Character for Word Alignment
    OutOrdLine     As Long           ' Line Number of original order
    DateUseXLen    As String * 1
    DateUseX       As String * 8     ' Use by Date

    ' 03.11.2000
    PadChar7       As String * 3
    DoNotUpdateTL  As Integer        ' Do not update Serial Qty value in Trans. line.
                                     ' Default=False=update Ser.Qty in TL }
    PadChar8       As String * 2
    RecPos         As Long
    InBinCodeLen   As String * 1
    InBinCode      As String * 10

    Spare          As String * 172
    LastChar       As String * 1    ' Last Character in record - used for VB alignment
End Type ' TBatchSerialRec

'---------------------------------------------------------------------------------------

Type TBatchDiscRec
    CustCodeLen     As String * 1
    CustCode        As String * 6    ' Customer Code
    StockCodeLen    As String * 1
    StockCode       As String * 16   ' Stock Code
    DiscType        As String * 1    ' Discount Type - B,S,M,U,Q
    SalesBand       As String * 1    ' Sales Price Band - A to H
    SPCurrency      As Integer       ' Special Price Currency
    SPrice          As Double        ' Special Price
    DiscPer         As Double        ' Discount %
    DiscAmt         As Double        ' Discount Amount of Unit Price
    DiscMar         As Double        ' Discount MarkUp or Margin %
    QtyBreak        As Integer       ' Qty Break Status
    PadChar1        As String * 2    ' Padding Character f'or Word Alignment
    QtyFr           As Double        ' Qty Discount From Qty
    QtyTo           As Double        ' Qty Discount To Qty
    
    VBThreshold     As Double        ' Value based discount threshole
    VBCurrency      As Integer       ' Value based discount currency
    
    UseDates        As Integer       ' Use effective dates
    StartDateLen    As String * 1
    StartDate       As String * 8    ' Effective date from as yyyymmdd
    EndDateLen      As String * 1
    EndDate         As String * 8    ' Effective date from as yyyymmdd
    
    Spare           As String * 169
    LastChar        As String * 1    ' Last Character in record - used for VB alignment }
End Type ' TBatchDiscRec

'---------------------------------------------------------------------------------------

'Type TBatchSKAltRec
'    StockCodeLen    As String * 1
'    StockCode       As String * 16   ' Main Stock Code
'    AltCodeLen      As String * 1
'    AltCode         As String * 16   ' Alternative Stock Code
'    AltDescLen      As String * 1
'    AltDesc         As String * 35   ' Alt.Code Description
'    SuppCodeLen     As String * 1
'    SuppCode        As String * 6    ' Supplier Code
'    PadChar1        As String * 1
'    ROCurr          As Integer       ' ReOrder Currency
'    ROPrice         As Double        ' ReOrder Price
'    UseROPrice      As Integer       ' Use ReOrder Price Status
'    LastUsedLen     As String * 1
'    LastUsed        As String * 8    ' Last Used Date
'    LastTimeLen     As String * 1
'    LastTime        As String * 6    ' Last Used Time: HHMMSS
'
'    PadChar         as String * 1
'    Spare           As String * 256
'    LastChar        As String * 1    ' Last Character in record - used for VB alignment
'End Type ' TBatchSKAltRec

'---------------------------------------------------------------------------------------

Type TUserProfileType
  upUserIdLen        As Byte               ' Used length of upUserId string
  upUserId           As String * 10        ' User Id
  upNameLen          As Byte               ' Used length of upName string
  upName             As String * 50        ' User Name
  upEmailLen         As Byte               ' Used length of upEmail string
  upEmail            As String * 100       ' Email Address

  ' Misc
  upPadChar1         As String * 1         ' Padding Character for Word Alignment
  upLockOutMins      As Integer            ' Minutes for Auto Lock Out

  ' Defaults
  upDefSRICustLen    As Byte               ' Used length of upDefSRICust string
  upDefSRICust       As String * 6         ' Default Cust for SRI
  upDefPPISuppLen    As Byte               ' Used length of upDefPPISupp string
  upDefPPISupp       As String * 6         ' Default Supp for PPI

  upDefCostCentreLen As Byte               ' Used length of upDefCostCentre string
  upDefCostCentre    As String * 3         ' Default Cost Centre
  upDefDepartmentLen As Byte               ' Used length of upDefDepartment string
  upDefDepartment    As String * 3         ' Default Department
  upDefCCDeptRule    As Integer            ' Rule for applying Default CC/Dept

  upDefLocationLen   As Byte               ' Used length of upDefLocation string
  upDefLocation      As String * 3         ' Default Location code
  upDefLocRule       As Integer            ' Rule for applying Default Location

  upDefSalesBankGL   As Long               ' Default Sales Bank GL Code
  upDefPurchBankGL   As Long               ' Default Purchase Bank GL Code

  ' Authorisation
  upMaxSalesAuth     As Double             ' Max Sales Authorisation Amount
  upMaxPurchAuth     As Double             ' Max Purchase Authorisation Amount
  
  ' v6.8 12/08/2011
  upShowGLCodesInTree As Integer           ' Show the GL Codes in the General Ledger Tree

  ' v7.0 13/07/2012
  upShowProductTypesInTree As Integer      ' Show the Product Types in the Stock Tree
  upShowStockCodesInTree As Integer        ' Show the Stock Codes in the Stock Tree

  upSpare            As String * 253
  LastChar           As String * 1         ' Last Character in record - used for VB alignment
End Type ' TUserProfileType

'---------------------------------------------------------------------------------------

Type TBatchMultiBuyDiscount
  mbdOwnerType         As String * 1
  mbdDiscountType      As String * 1
  mbdAcCodeLen         As Byte
  mbdAcCode            As String * 6
  mbdStockCodeLen      As Byte
  mbdStockCode         As String * 16
  mbdCurrency          As Integer
  mbdStartDateLen      As Byte
  mbdStartDate         As String * 8
  mbdEndDateLen        As Byte
  mbdEndDate           As String * 8
  mbdUseDates          As Integer
  mbdBuyQty            As Double
  mbdRewardValue       As Double
  RecordPosition       As Long
  Spare                As String * 255
  LastChar             As String * 1
End Type

'* Exchequer Enterprise Toolkit DLL - Function Declarations
' System functions
Declare Function EX_INITBTRIEVE Lib "ENTDLL32.DLL" () As Integer
Declare Function EX_INITDLL Lib "ENTDLL32.DLL" () As Integer
Declare Function EX_INITDLLPATH Lib "ENTDLL32.DLL" (ByVal ExPath As String, ByVal MCSystem%) As Integer
Declare Function EX_CLOSEDLL Lib "ENTDLL32.DLL" () As Integer
Declare Function EX_CLOSEDATA Lib "ENTDLL32.DLL" () As Integer
Declare Sub EX_TESTMODE Lib "ENTDLL32.DLL" (ByVal TheMode%)
Declare Function EX_VERSION Lib "ENTDLL32.DLL" () As PascalString

' Miscellaneous functions
Declare Function EX_GETCCDEP Lib "ENTDLL32.DLL" (P As TBatchCCDepRec, ByVal PSIZE As Long, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal CCDepType As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_GETVATRATE Lib "ENTDLL32.DLL" (P As TBatchVATRec, ByVal PSIZE As Long) As Integer
Declare Function EX_GETCURRENCY Lib "ENTDLL32.DLL" (P As TBatchCurrRec, ByVal PSIZE As Long, ByVal Curr As Integer) As Integer
Declare Function EX_ERRORDESCRIPTION Lib "ENTDLL32.DLL" (ByVal INDEXNO As Integer, ByVal ERRORCODE As Integer) As PascalString
Declare Function EX_GETDATAPATH Lib "ENTDLL32.DLL" (EXDATAPATH As String) As Integer
Declare Function EX_ROUNDUP Lib "ENTDLL32.DLL" (ByVal INPUTVALUE As Double, ByVal DECIMALPLACES As Integer) As Double
Declare Function EX_GETLASTERRORDESC Lib "ENTDLL32.DLL" () As PascalString

' Customer/Supplier Account Functions
Declare Function EX_GETACCOUNT Lib "ENTDLL32.DLL" (P As TBatchCURec, ByVal PSIZE As Long, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal AccType As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_STOREACCOUNT Lib "ENTDLL32.DLL" (P As TBatchCURec, ByVal PSIZE As Long, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer) As Integer
Declare Function EX_GETACCOUNTBALANCE Lib "ENTDLL32.DLL" (P As THistoryBalRec, ByVal PSIZE As Long, ByVal AcCode As String, ByVal SEARCHMODE As Integer) As Integer
Declare Function EX_HASOUTSTANDING Lib "ENTDLL32.DLL" (ByVal CustCode As String) As Integer
Declare Function EX_ACCOUNTFILESIZE Lib "ENTDLL32.DLL" () As Long

' Transaction Functions
Declare Function EX_GETNEXTTRANSNO Lib "ENTDLL32.DLL" (ByVal DocStr As String, ByVal NextNo As String, ByVal Updt As Integer) As Integer
Declare Function EX_GETTRANS Lib "ENTDLL32.DLL" (P As TBatchTHRec, PLines As TBatchLinesRec, ByVal PSIZE As Long, ByVal PLSize As Long, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_STORETRANS Lib "ENTDLL32.DLL" (P As TBatchTHRec, PL As TBatchLinesRec, ByVal PSIZE As Long, ByVal PLSize As Long, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer) As Integer
'Declare Function EX_GETLINESERIALNOS Lib "ENTDLL32.DLL" (P As TBatchSRLinesRec, ByVal PSize As Long, ByVal SEARCHKEY As String, ByVal SearchLineNo As Long, ByVal SEARCHMODE As Integer) As Integer
Declare Function EX_GETTOTALTRANSLINES Lib "ENTDLL32.DLL" (ByVal DocRef As String) As Long
Declare Function EX_GETTRANSHED Lib "ENTDLL32.DLL" (P As TBatchTHRec, ByVal PSIZE As Long, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_STORETRANSHED Lib "ENTDLL32.DLL" (P As TBatchTHRec, ByVal PSIZE As Long) As Integer
Declare Function EX_GETTRANSLINE Lib "ENTDLL32.DLL" (PLine As TBatchTLRec, ByVal PLSize As Long, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_GETMATCH Lib "ENTDLL32.DLL" (P As TBatchMatchRec, ByVal PSIZE As Long, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_STOREMATCH Lib "ENTDLL32.DLL" (P As TBatchMatchRec, ByVal PSIZE As Long, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer) As Integer
Declare Function EX_GETTLLINE Lib "ENTDLL32.DLL" (ByVal Folio As Long, ByVal LineNo As Long, PLine As TBatchTLRec, ByVal PLSize As Long) As Integer

Declare Function EX_CALCULATETRANSTOTAL Lib "ENTDLL32.DLL" (ByVal thOurRef As String, _
                                                            ByVal UseVariance As Integer, _
                                                            ByVal UseRoundUp As Integer, _
                                                                  TotalValue As Double) As Integer

Declare Function EX_GETLINETOTAL Lib "ENTDLL32.DLL" (PLine As TBatchTLRec, _
                                                     ByVal PLSize As Long, _
                                                     ByVal UseDiscount As Integer, _
                                                     ByVal SettleDisc As Double, _
                                                           LineTotal As Double) As Integer

Declare Function EX_CALCLINETAX Lib "ENTDLL32.DLL" (PLine As TBatchTLRec, _
                                                    ByVal PLSize As Long, _
                                                    ByVal SettleDisc As Double) As Integer

Declare Function EX_TRANCANBEUPDATED Lib "ENTDLL32.DLL" (ByVal DocRef As String) As Integer

Declare Function EX_UPDATEDUEDATE Lib "ENTDLL32.DLL" (ByVal DocStr As String, ByVal NewDate As String) As Integer

Declare Function EX_UPDATEPAYINREF Lib "ENTDLL32.DLL" (ByVal thOurRef As String, _
                                                       ByVal LineNo As Long, _
                                                       ByVal NewRef As String) As Integer

Declare Function EX_DATETOENTPERIOD Lib "ENTDLL32.DLL" (ByVal TransDate As String, _
                                                              FinPeriod As Integer, _
                                                              FinYear As Integer) As Integer


' General Ledger Functions
Declare Function EX_GETGLACCOUNT Lib "ENTDLL32.DLL" (P As TBatchNomRec, ByVal PSIZE As Long, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal LockRec As Integer) As Integer
Declare Function Ex_STOREGLACCOUNT Lib "ENTDLL32.DLL" (P As TBatchNomRec, ByVal PSIZE As Long, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer) As Integer

' Stock Functions
Declare Function EX_GETSTOCK Lib "ENTDLL32.DLL" (P As TBatchSKRec, ByVal PSIZE As Long, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_STORESTOCK Lib "ENTDLL32.DLL" (P As TBatchSKRec, ByVal PSIZE As Long, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer) As Integer
'Declare Function EX_GETSTOCKBOM Lib "ENTDLL32.DLL" (P As TBatchBOMLinesRec, ByVal PSIZE As Long, ByVal SearchKey As String, ByVal SearchMode As Integer) As Integer

Declare Function EX_GETSERIALBATCH Lib "ENTDLL32.DLL" (P As TBatchSerialRec, ByVal PSIZE As Long, ByVal SEARCHMODE As Integer) As Integer
Declare Function EX_USESERIALBATCH Lib "ENTDLL32.DLL" (P As TBatchSerialRec, ByVal PSIZE As Long, ByVal SEARCHMODE As Integer) As Integer

Declare Function EX_GETDISCMATRIX Lib "ENTDLL32.DLL" (P As TBatchDiscRec, _
                                                      ByVal PSIZE As Long, _
                                                      ByVal SEARCHPATH As Integer, _
                                                      ByVal SEARCHMODE As Integer, _
                                                      ByVal LockRec As Integer) As Integer
                                                      
Declare Function EX_STOREDISCMATRIX Lib "ENTDLL32.DLL" (P As TBatchDiscRec, _
                                                        ByVal PSIZE As Long, _
                                                        ByVal SEARCHPATH As Integer) As Integer
                            
Declare Function EX_DELETEDISCMATRIX Lib "ENTDLL32.DLL" (P As TBatchDiscRec, _
                                                         ByVal PSIZE As Long, _
                                                         ByVal SEARCHPATH As Integer, _
                                                         ByVal RecPos As Long) As Integer
                            
                            
' Location functions
Declare Function EX_GETLOCATION Lib "ENTDLL32.DLL" (P As TBatchMLocRec, _
                                                    ByVal PSIZE As Long, _
                                                    ByVal SEARCHKEY As String, _
                                                    ByVal SEARCHPATH As Integer, _
                                                    ByVal SEARCHMODE As Integer, _
                                                    ByVal LockRec As Integer) As Integer

' Stock Price functions
Declare Function EX_CALCSTOCKPRICE Lib "ENTDLL32.DLL" (P As TBatchStkPriceRec, ByVal PSIZE As Long) As Integer
Declare Function EX_INITSTKPRICE Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (P As TBatchStkPriceRec, ByVal PSIZE As Long) As Integer

' Uplift Function
Declare Function EX_UPDATEUPLIFT Lib "ENTDLL32.DLL" (ByVal TransRef As String, ByVal TransLine As Long, ByVal StCode As String, ByVal UPLIFTAMY As Double) As Integer

' Currency Conversion
Declare Function EX_CONVERTAMOUNT Lib "ENTDLL32.DLL" (ByVal FROMCURR As Integer, ByVal TOCURR As Integer, AMOUNT As Double, ByVal RATETYPE As Integer) As Integer

' Notes Functions
Declare Function EX_GETNOTES Lib "ENTDLL32.DLL" (P As TBatchNotesRec, ByVal PSIZE As Long, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_STORENOTES Lib "ENTDLL32.DLL" (P As TBatchNotesRec, ByVal PSIZE As Long, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer) As Integer
                                                    
' Password checking
Declare Function EX_CHECKPASSWORD Lib "ENTDLL32.DLL" (ByVal UserName As String, ByVal Password As String) As Integer

' Record initialisation functions
Declare Function EX_INITCUST Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef CU As TBatchCURec, ByVal StructSize As Long) As Integer
Declare Function EX_INITTH Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef TH As TBatchTHRec, ByVal StructSize As Long) As Integer
Declare Function EX_INITTL Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef TL As TBatchTLRec, ByVal StructSize As Long) As Integer
Declare Function EX_INITNOTE Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef NOTE As TBatchNotesRec, ByVal StructSize As Long) As Integer
Declare Function EX_INITSERIAL Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef NOTE As TBatchSerialRec, ByVal StructSize As Long) As Integer
Declare Function EX_INITDISCOUNT Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef DISC As TBatchDiscRec, ByVal StructSize As Long) As Integer

' Btrieve Functions
Declare Function EX_GETRECORDADDRESS Lib "ENTDLL32.DLL" (ByVal FILENUM As Integer, ByRef RECADDRESS As Long) As Integer
Declare Function EX_GETRECWITHADDRESS Lib "ENTDLL32.DLL" (ByVal FILENUM As Integer, ByVal KeyPath As Integer, ByVal TRECADDR As Long) As Integer

' Ent5.00: User Profile Functions
' Gets or searches for a specified User Profile
Declare Function EX_GETUSERPROFILE Lib "ENTDLL32.DLL" (P As TUserProfileType, _
                                                       ByVal PSIZE As Long, _
                                                       ByVal SEARCHKEY As String, _
                                                       ByVal SEARCHMODE As Integer) As Integer


' Ent5.00: Delete Quote Function
Declare Function EX_DELETEQUOTE Lib "ENTDLL32.DLL" (ByVal QuoteOurRef As String) As Integer

Declare Function EX_GETSTOCKLOC Lib "ENTDLL32.DLL" (P As TBatchSLRec, _
                                                    ByVal PSIZE As Long, _
                                                    ByVal SEARCHKEY As String, _
                                                    ByVal SEARCHLOC As String, _
                                                    ByVal LockRec As Integer) As Integer


Declare Function EX_STORESTOCKLOC Lib "ENTDLL32.DLL" (P As TBatchSLRec, _
                                                    ByVal PSIZE As Long, _
                                                    ByVal SEARCHMODE As Integer) As Integer
                                                    
'Declare Function EX_STORESTKALT Lib "ENTDLL32.DLL" (P As TBatchSKAltRec, ByVal PSIZE As Long, ByVal SearchPath As Integer, ByVal SearchMode As Integer) As Integer

Declare Function EX_UNUSESERIALBATCH Lib "ENTDLL32.DLL" (P As TBatchSerialRec, ByVal PSIZE As Long, ByVal SEARCHMODE As Integer) As Integer

Declare Function EX_UPDATELINEDATE Lib "ENTDLL32.DLL" (ByVal TransRef As String, ByVal LineNo As Long, ByVal NewDate As String) As Integer

Declare Function EX_GETTHBYRUNNO Lib "ENTDLL32.DLL" (P As TBatchTHRec, _
                                                            ByVal PSIZE As Long, _
                                                            ByVal RunNo As Long, _
                                                            ByVal SEARCHMODE As Integer, _
                                                            ByVal LockRec As Integer) As Integer

Declare Function EX_UPDATERECONCILEFLAG Lib "ENTDLL32.DLL" (ByVal RecordPos As Long, ByVal NewValue As Integer) As Integer

Declare Function EX_GETMULTIBUY Lib "ENTDLL32.DLL" (P As TBatchMultiBuyDiscount, _
                                                      ByVal PSIZE As Long, _
                                                      ByVal SEARCHPATH As Integer, _
                                                      ByVal SEARCHMODE As Integer, _
                                                      ByVal LockRec As Integer) As Integer
                                                      
Declare Function EX_STOREMULTIBUY Lib "ENTDLL32.DLL" (P As TBatchMultiBuyDiscount, _
                                                        ByVal PSIZE As Long, _
                                                        ByVal SEARCHPATH As Integer, _
                                                        ByVal SEARCHMODE As Integer) As Integer
                            
Declare Function EX_DELETEMULTIBUY Lib "ENTDLL32.DLL" (P As TBatchMultiBuyDiscount, _
                                                         ByVal PSIZE As Long, _
                                                         ByVal SEARCHPATH As Integer) As Integer

