unit CustAbsU;

{ Abstract Type definitions for Customisation }

{ WARNING: DO NOT CHANGE THE FOLLOWING DEFINITIONS, IF YOU CHANGE }
{          THE FOLLOWING DEFINITIONS, SYSTEM CRASHES AND DATA     }
{          CORRUPTION ARE LIKELY TO OCCUR.                        }

interface

Uses Classes, Graphics, SysUtils, Windows;

{$H-}   { Huge Strings Off }



Type
  cuStr2     = String[2];
  cuStr3     = String[3];
  cuStr4     = String[4];
  cuStr5     = String[5];
  cuStr6     = String[6];
  cuStr8     = String[8];
  cuStr10    = String[10];
  cuStr11    = String[11];
  cuStr12    = String[12];
  cuStr13    = String[13];
  cuStr14    = String[14];
  cuStr15    = String[15];
  cuStr16    = String[16];
  cuStr18    = String[18];
  cuStr20    = String[20];
  cuStr25    = String[25];
  cuStr26    = String[26];
  cuStr28    = String[28];
  cuStr30    = String[30];
  cuStr35    = String[35];
  cuStr36    = String[36];
  cuStr40    = String[40];
  cuStr45    = String[45];
  cuStr50    = String[50];
  cuStr60    = String[60];
  cuStr70    = String[70];
  cuStr80    = String[80];
  cuStr100   = String[100];
  cuStr255   = String[255];
  cuLongDate = String[8];

  cuTermsIndex = 1..2;
  cuDebtChaseIndex = 1..3;
  cuCustFieldIndex = 1..4;
  cuAddrIndex = 1..5;
  cuCurrencyType = 0..89;
  cuAccStatusType = 0..3;
  cuLineIndex = 1..6;
  cuLineTIndex= 0..6;
  cuDescIndex = 1..6;
  cuSalesBandIndex = 'A'..'H';
  cuVATIndex = (CUStandard,CUExempt,CUZero,CURate1,CURate2,CURate3,CURate4,CURate5,CURate6,
                CURate7,CURate8,CURate9,CURate10,CURate11,CURate12,CURate13,CURate14,CURate15,
                CURate16,CURate17,CURate18,CUIAdj,CUOAdj,CUSpare8);

  // HM 24/01/05: Added missing DocTypes CUWIN-CUJPA
  cuDocTypes = (CUSIN,CUSRC,CUSCR,CUSJI,CUSJC,CUSRF,CUSRI,CUSQU,CUSOR,CUSDN,CUSBT,CUSDG,CUNDG,CUOVT,CUDEB,
                CUPIN,CUPPY,CUPCR,CUPJI,CUPJC,CUPRF,CUPPI,CUPQU,CUPOR,CUPDN,CUPBT,CUSDT,CUNDT,CUIVT,CUCRE,
                CUNMT,CURUN,CUFOL,CUAFL,CUADC,CUADJ,CUACQ,CUAPI,CUSKF,CUJBF,CUWOR,CUTSH,CUJRN,CUWIN,CUSRN,
                CUPRN,CUJCT,CUJST,CUJPT,CUJSA,CUJPA);

  cuNomCtrlType = (CUInVAT,CUOutVAT,CUDebtors,CUCreditors,CUDiscountGiven,CUDiscountTaken,
                   CULDiscGiven,CULDiscTaken,CUProfitBF,CUCurrVar,CUUnRCurrVar,CUPLStart,CUPLEnd,
                   CUFreightNC,CUNSpare5,CUNSpare6,CUNSpare7,CUNSpare8,CUNSpare9,CUNSpare10,CUNSpare11,
                   CUNSpare12,CUNSpare13,CUNSpare14);

  cuCISTaxType = (cisttConstruction, cisttTechnical);
  cuCISVoucherType = (cvt23=5, cvt24=6, cvt25=4);
  cuJobCategoryType = (jcRevenue, jcLabour, jcDirectExpense1, jcDirectExpense2, jcStockIssues,
                       jcOverheads, jcReceipts, jcWorkInProgress, jcRetentionsSL, jcRetentionsPL,
                       // 23/03/04: Extended for Apps & Vals Categories
                       jcSubContractLabour, jcMaterials2, jcOverheads2, jcSalesDeductions,
                       jcSalesApplications, jcPurchaseApplications, jcPurchaseDeductions);

  cuSystemSetupJobGLCtrlType = (ssjGLOverhead, ssjGLProdution, ssjGLSubContract);

  cuNOMVatIOType = (nvioNA, nvioInput, nvioOutput);
  cuNOMLineVatType = (nlvNA, nlvAuto, nlvManual);


  TRecAccessStatus = (NotAvailable, ReadOnly, ReadWrite);
  TPropertyAccess = (paReadOnly, paReadWrite);
  TFunctionAccess = (pfDisabled, pfEnabled);

  { Exceptions }
  ERightsError = Class(Exception);
  EValidationError = Class(Exception);
  EVersionError = Class(Exception);
  EFunctionError = Class(Exception);
  ENotImplemented = Class(Exception);

{-----------------------------------------------------------------------------}

  { Window Handler Object - used to specify which handlers are }
  { coded in the Customisation DLL                             }
  TAbsCustomHandlers = Class(TObject)
  Protected
    Function GetClassVersion : cuStr8; Virtual; Abstract;
  Public
    Property ClassVersion : cuStr8 Read GetClassVersion;

    Procedure AddAboutString(Const AbStr : ShortString); Virtual; Abstract;
    Procedure SetHandlerStatus(Const WinId, HandlerId : LongInt;
                               Const Status           : Byte); Virtual; Abstract;
  End; { Type }

  { v5.00.023 Descendant class added to provide new v5.00 functionality }
  TAbsCustomHandlers01 = Class(TAbsCustomHandlers)
  Public
    Function HookPointEnabled (Const WindowId, HandlerId : LongInt) : WordBool; Virtual; Abstract;
  End; { TAbsCustomHandlers01 }

{-----------------------------------------------------------------------------}

  { Abstract System Setup VAT Interface - used by TAbsSetup }
  TAbsVATInfo = Class(TObject)
  Protected
    Function GetVatCode : Char; Virtual; Abstract;
    Function GetVatDesc : cuStr10; Virtual; Abstract;
    Function GetVatRate : Real; Virtual; Abstract;
    Function GetVatInclude : Boolean; Virtual; Abstract;
  Public
    Property svCode : Char Read GetVatCode;
    Property svDesc : cuStr10 Read GetVatDesc;
    Property svRate : Real Read GetVatRate;
    Property svInclude : Boolean Read GetVatInclude;
  End; { TAbsVATInfo }

{-----------------------------------------------------------------------------}

  { Abstract System Setup Currency Table Interface - used by TAbsSetup }
  TAbsCcyInfo = Class(TObject)
  Protected
    Function GetSymbol : cuStr3; Virtual; Abstract;
    Function GetDesc : cuStr11; Virtual; Abstract;
    Function GetCompanyRate : Real; Virtual; Abstract;
    Function GetDailyRate : Real; Virtual; Abstract;
    Function GetPrintSymbol : cuStr3; Virtual; Abstract;

    Function GetTriRate : Double; Virtual; Abstract;
    Function GetTriEuroCcy : Byte; Virtual; Abstract;
    Function GetTriInvert : Boolean; Virtual; Abstract;
    Function GetTriFloating : Boolean; Virtual; Abstract;
  Public
    Property scSymbol : cuStr3 Read GetSymbol;
    Property scDesc : cuStr11 Read GetDesc;
    Property scCompanyRate : Real Read GetCompanyRate;
    Property scDailyRate : Real Read GetDailyRate;
    Property scPrintSymb : cuStr3 Read GetPrintSymbol;

    Property scTriRate : Double Read GetTriRate;
    Property scTriEuroCcy : Byte Read GetTriEuroCcy;
    Property scTriInvert : Boolean Read GetTriInvert;
    Property scTriFloating : Boolean Read GetTriFloating;
  End; { TAbsCcyInfo }

{-----------------------------------------------------------------------------}

  { Abstract System Setup - Used TAbsSetup }
  TAbsUserFields = Class(TObject)
  Protected
    Function GetUserFieldName(Index : Integer) : cuStr15; Virtual; Abstract;
    Function GetUserFieldEnabled(Index : Integer) : Boolean; Virtual; Abstract;

    function GetFieldDesc (FieldNo: cuCustFieldIndex; Index: Integer): cuStr15; Virtual; Abstract;
    function GetFieldEnabled (FieldNo: cuCustFieldIndex; Index: Integer): Boolean; Virtual; Abstract;
  Public
{01} Property ufAccount1 : cuStr15 Index 1 Read GetUserFieldName;   // v5.00 = Customer
{02} Property ufAccount2 : cuStr15 Index 2 Read GetUserFieldName;   // v5.00 = Customer
{03} Property ufAccount3 : cuStr15 Index 11 Read GetUserFieldName;  // v5.00 = Customer
{04} Property ufAccount4 : cuStr15 Index 12 Read GetUserFieldName;  // v5.00 = Customer
{05} Property ufTrans1 : cuStr15 Index 3 Read GetUserFieldName;     // v5.00 = SIN
{06} Property ufTrans2 : cuStr15 Index 4 Read GetUserFieldName;     // v5.00 = SIN
{07} Property ufTrans3 : cuStr15 Index 13 Read GetUserFieldName;    // v5.00 = SIN
{08} Property ufTrans4 : cuStr15 Index 14 Read GetUserFieldName;    // v5.00 = SIN
{09} Property ufStock1 : cuStr15 Index 5 Read GetUserFieldName;
{10} Property ufStock2 : cuStr15 Index 6 Read GetUserFieldName;
{11} Property ufStock3 : cuStr15 Index 15 Read GetUserFieldName;
{12} Property ufStock4 : cuStr15 Index 16 Read GetUserFieldName;
{13} Property ufLine1 : cuStr15 Index 17 Read GetUserFieldName;     // v5.00 = SIN Line
{14} Property ufLine2 : cuStr15 Index 18 Read GetUserFieldName;     // v5.00 = SIN Line
{15} Property ufLine3 : cuStr15 Index 19 Read GetUserFieldName;     // v5.00 = SIN Line
{16} Property ufLine4 : cuStr15 Index 20 Read GetUserFieldName;     // v5.00 = SIN Line
{17} Property ufJob1 : cuStr15 Index 21 Read GetUserFieldName;
{18} Property ufJob2 : cuStr15 Index 22 Read GetUserFieldName;

{19} Property ufTrans1Enabled : Boolean Index 1 Read GetUserFieldEnabled;  // v5.00 = SIN
{20} Property ufTrans2Enabled : Boolean Index 2 Read GetUserFieldEnabled;  // v5.00 = SIN
{21} Property ufTrans3Enabled : Boolean Index 3 Read GetUserFieldEnabled;  // v5.00 = SIN
{22} Property ufTrans4Enabled : Boolean Index 4 Read GetUserFieldEnabled;  // v5.00 = SIN
{23} Property ufLine1Enabled : Boolean Index 5 Read GetUserFieldEnabled;   // v5.00 = SIN Line
{34} Property ufLine2Enabled : Boolean Index 6 Read GetUserFieldEnabled;   // v5.00 = SIN Line
{25} Property ufLine3Enabled : Boolean Index 7 Read GetUserFieldEnabled;   // v5.00 = SIN Line
{26} Property ufLine4Enabled : Boolean Index 8 Read GetUserFieldEnabled;   // v5.00 = SIN Line

    // New v5.00 properties - old properties above are obselete and are
    //                        supported for backward compatibility
    Property ufCustDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 1 Read GetFieldDesc;
    Property ufSuppDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 2 Read GetFieldDesc;
    Property ufLineTypeDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 3 Read GetFieldDesc;
    Property ufSINDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 4 Read GetFieldDesc;
    Property ufSINEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 1 Read GetFieldEnabled;
    Property ufSINLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 5 Read GetFieldDesc;
    Property ufSINLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 2 Read GetFieldEnabled;
    Property ufSRCDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 6 Read GetFieldDesc;
    Property ufSRCEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 3 Read GetFieldEnabled;
    Property ufSRCLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 7 Read GetFieldDesc;
    Property ufSRCLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 4 Read GetFieldEnabled;
    Property ufSQUDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 8 Read GetFieldDesc;
    Property ufSQUEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 5 Read GetFieldEnabled;
    Property ufSQULineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 9 Read GetFieldDesc;
    Property ufSQULineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 6 Read GetFieldEnabled;
    Property ufSORDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 10 Read GetFieldDesc;
    Property ufSOREnabled [FieldNo : cuCustFieldIndex] : Boolean Index 7 Read GetFieldEnabled;
    Property ufSORLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 11 Read GetFieldDesc;
    Property ufSORLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 8 Read GetFieldEnabled;
    Property ufPINDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 12 Read GetFieldDesc;
    Property ufPINEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 9 Read GetFieldEnabled;
    Property ufPINLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 13 Read GetFieldDesc;
    Property ufPINLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 10 Read GetFieldEnabled;
    Property ufPPYDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 14 Read GetFieldDesc;
    Property ufPPYEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 11 Read GetFieldEnabled;
    Property ufPPYLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 15 Read GetFieldDesc;
    Property ufPPYLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 12 Read GetFieldEnabled;
    Property ufPQUDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 16 Read GetFieldDesc;
    Property ufPQUEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 13 Read GetFieldEnabled;
    Property ufPQULineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 17 Read GetFieldDesc;
    Property ufPQULineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 14 Read GetFieldEnabled;
    Property ufPORDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 18 Read GetFieldDesc;
    Property ufPOREnabled [FieldNo : cuCustFieldIndex] : Boolean Index 15 Read GetFieldEnabled;
    Property ufPORLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 19 Read GetFieldDesc;
    Property ufPORLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 16 Read GetFieldEnabled;
    Property ufNOMDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 20 Read GetFieldDesc;
    Property ufNOMEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 17 Read GetFieldEnabled;
    Property ufNOMLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 21 Read GetFieldDesc;
    Property ufNOMLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 18 Read GetFieldEnabled;
    Property ufStockDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 22 Read GetFieldDesc;
    Property ufADJDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 23 Read GetFieldDesc;
    Property ufADJEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 19 Read GetFieldEnabled;
    Property ufADJLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 24 Read GetFieldDesc;
    Property ufADJLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 20 Read GetFieldEnabled;
    Property ufWORDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 25 Read GetFieldDesc;
    Property ufWOREnabled [FieldNo : cuCustFieldIndex] : Boolean Index 21 Read GetFieldEnabled;
    Property ufWORLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 26 Read GetFieldDesc;
    Property ufWORLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 22 Read GetFieldEnabled;
    Property ufJobDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 27 Read GetFieldDesc;
    Property ufEmployeeDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 28 Read GetFieldDesc;
    Property ufTSHDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 29 Read GetFieldDesc;
    Property ufTSHEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 23 Read GetFieldEnabled;
    Property ufTSHLineDesc [FieldNo : cuCustFieldIndex] : cuStr15 Index 30 Read GetFieldDesc;
    Property ufTSHLineEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 24 Read GetFieldEnabled;
  End; { TAbsUserFields }

  //------------------------------

  // MH 26/10/2011 v6.9: Added descendant class to provide access to extended User Defined Fields info
  TAbsUserFields2 = Class(TAbsUserFields)
  Protected
    function GetFieldDesc10 (FieldNo: Integer; Index: Integer): ShortString; Virtual; Abstract;
    function GetFieldEnabled10 (FieldNo: Integer; Index: Integer): Boolean; Virtual; Abstract;
  Public
    Property ufCustDesc10 [FieldNo : Integer] : ShortString Index 1 Read GetFieldDesc10;
    Property ufSuppDesc10 [FieldNo : Integer] : ShortString Index 2 Read GetFieldDesc10;
    Property ufLineTypeEnabled [FieldNo : cuCustFieldIndex] : Boolean Index 25 Read GetFieldEnabled;
    Property ufSINDesc10 [FieldNo : Integer] : ShortString Index 4 Read GetFieldDesc10;
    Property ufSINEnabled10 [FieldNo : Integer] : Boolean Index 1 Read GetFieldEnabled10;
    Property ufSINLineDesc10 [FieldNo : Integer] : ShortString Index 5 Read GetFieldDesc10;
    Property ufSINLineEnabled10 [FieldNo : Integer] : Boolean Index 2 Read GetFieldEnabled10;
    Property ufSRCDesc10 [FieldNo : Integer] : ShortString Index 6 Read GetFieldDesc10;
    Property ufSRCEnabled10 [FieldNo : Integer] : Boolean Index 3 Read GetFieldEnabled10;
    Property ufSRCLineDesc10 [FieldNo : Integer] : ShortString Index 7 Read GetFieldDesc10;
    Property ufSRCLineEnabled10 [FieldNo : Integer] : Boolean Index 4 Read GetFieldEnabled10;
    Property ufSQUDesc10 [FieldNo : Integer] : ShortString Index 8 Read GetFieldDesc10;
    Property ufSQUEnabled10 [FieldNo : Integer] : Boolean Index 5 Read GetFieldEnabled10;
    Property ufSQULineDesc10 [FieldNo : Integer] : ShortString Index 9 Read GetFieldDesc10;
    Property ufSQULineEnabled10 [FieldNo : Integer] : Boolean Index 6 Read GetFieldEnabled10;
    Property ufSORDesc10 [FieldNo : Integer] : ShortString Index 10 Read GetFieldDesc10;
    Property ufSOREnabled10 [FieldNo : Integer] : Boolean Index 7 Read GetFieldEnabled10;
    Property ufSORLineDesc10 [FieldNo : Integer] : ShortString Index 11 Read GetFieldDesc10;
    Property ufSORLineEnabled10 [FieldNo : Integer] : Boolean Index 8 Read GetFieldEnabled10;
    Property ufPINDesc10 [FieldNo : Integer] : ShortString Index 12 Read GetFieldDesc10;
    Property ufPINEnabled10 [FieldNo : Integer] : Boolean Index 9 Read GetFieldEnabled10;
    Property ufPINLineDesc10 [FieldNo : Integer] : ShortString Index 13 Read GetFieldDesc10;
    Property ufPINLineEnabled10 [FieldNo : Integer] : Boolean Index 10 Read GetFieldEnabled10;
    Property ufPPYDesc10 [FieldNo : Integer] : ShortString Index 14 Read GetFieldDesc10;
    Property ufPPYEnabled10 [FieldNo : Integer] : Boolean Index 11 Read GetFieldEnabled10;
    Property ufPPYLineDesc10 [FieldNo : Integer] : ShortString Index 15 Read GetFieldDesc10;
    Property ufPPYLineEnabled10 [FieldNo : Integer] : Boolean Index 12 Read GetFieldEnabled10;
    Property ufPQUDesc10 [FieldNo : Integer] : ShortString Index 16 Read GetFieldDesc10;
    Property ufPQUEnabled10 [FieldNo : Integer] : Boolean Index 13 Read GetFieldEnabled10;
    Property ufPQULineDesc10 [FieldNo : Integer] : ShortString Index 17 Read GetFieldDesc10;
    Property ufPQULineEnabled10 [FieldNo : Integer] : Boolean Index 14 Read GetFieldEnabled10;
    Property ufPORDesc10 [FieldNo : Integer] : ShortString Index 18 Read GetFieldDesc10;
    Property ufPOREnabled10 [FieldNo : Integer] : Boolean Index 15 Read GetFieldEnabled10;
    Property ufPORLineDesc10 [FieldNo : Integer] : ShortString Index 19 Read GetFieldDesc10;
    Property ufPORLineEnabled10 [FieldNo : Integer] : Boolean Index 16 Read GetFieldEnabled10;
    Property ufNOMDesc10 [FieldNo : Integer] : ShortString Index 20 Read GetFieldDesc10;
    Property ufNOMEnabled10 [FieldNo : Integer] : Boolean Index 17 Read GetFieldEnabled10;
    Property ufNOMLineDesc10 [FieldNo : Integer] : ShortString Index 21 Read GetFieldDesc10;
    Property ufNOMLineEnabled10 [FieldNo : Integer] : Boolean Index 18 Read GetFieldEnabled10;
    Property ufStockDesc10 [FieldNo : Integer] : ShortString Index 22 Read GetFieldDesc10;
    Property ufADJDesc10 [FieldNo : Integer] : ShortString Index 23 Read GetFieldDesc10;
    Property ufADJEnabled10 [FieldNo : Integer] : Boolean Index 19 Read GetFieldEnabled10;
    Property ufADJLineDesc10 [FieldNo : Integer] : ShortString Index 24 Read GetFieldDesc10;
    Property ufADJLineEnabled10 [FieldNo : Integer] : Boolean Index 20 Read GetFieldEnabled10;
    Property ufWORDesc10 [FieldNo : Integer] : ShortString Index 25 Read GetFieldDesc10;
    Property ufWOREnabled10 [FieldNo : Integer] : Boolean Index 21 Read GetFieldEnabled10;
    Property ufWORLineDesc10 [FieldNo : Integer] : ShortString Index 26 Read GetFieldDesc10;
    Property ufWORLineEnabled10 [FieldNo : Integer] : Boolean Index 22 Read GetFieldEnabled10;
    Property ufJobDesc10 [FieldNo : Integer] : ShortString Index 27 Read GetFieldDesc10;
    Property ufTSHDesc10 [FieldNo : Integer] : ShortString Index 29 Read GetFieldDesc10;
    Property ufTSHEnabled10 [FieldNo : Integer] : Boolean Index 23 Read GetFieldEnabled10;
    Property ufTSHLineDesc10 [FieldNo : Integer] : ShortString Index 30 Read GetFieldDesc10;
    Property ufTSHLineEnabled10 [FieldNo : Integer] : Boolean Index 24 Read GetFieldEnabled10;
    Property ufSRNDesc10 [FieldNo : Integer] : ShortString Index 31 Read GetFieldDesc10;
    Property ufSRNEnabled10 [FieldNo : Integer] : Boolean Index 26 Read GetFieldEnabled10;
    Property ufSRNLineDesc10 [FieldNo : Integer] : ShortString Index 32 Read GetFieldDesc10;
    Property ufSRNLineEnabled10 [FieldNo : Integer] : Boolean Index 27 Read GetFieldEnabled10;
    Property ufPRNDesc10 [FieldNo : Integer] : ShortString Index 33 Read GetFieldDesc10;
    Property ufPRNEnabled10 [FieldNo : Integer] : Boolean Index 28 Read GetFieldEnabled10;
    Property ufPRNLineDesc10 [FieldNo : Integer] : ShortString Index 34 Read GetFieldDesc10;
    Property ufPRNLineEnabled10 [FieldNo : Integer] : Boolean Index 29 Read GetFieldEnabled10;
  End; // TAbsUserFields2

  //------------------------------

  // MH 09/03/2012 v6.10 ABSEXCH-12128: Added descendant class to provide access to extended User Defined Fields info for Apps n Vals
  TAbsUserFields3 = Class(TAbsUserFields2)
  Public
    Property ufJCTDesc10 [FieldNo : Integer] : ShortString Index 35 Read GetFieldDesc10;
    Property ufJCTEnabled10 [FieldNo : Integer] : Boolean Index 30 Read GetFieldEnabled10;
    Property ufJCTLineDesc10 [FieldNo : Integer] : ShortString Index 36 Read GetFieldDesc10;
    Property ufJCTLineEnabled10 [FieldNo : Integer] : Boolean Index 31 Read GetFieldEnabled10;
    Property ufJPTDesc10 [FieldNo : Integer] : ShortString Index 37 Read GetFieldDesc10;
    Property ufJPTEnabled10 [FieldNo : Integer] : Boolean Index 32 Read GetFieldEnabled10;
    Property ufJPTLineDesc10 [FieldNo : Integer] : ShortString Index 38 Read GetFieldDesc10;
    Property ufJPTLineEnabled10 [FieldNo : Integer] : Boolean Index 33 Read GetFieldEnabled10;
    Property ufJSTDesc10 [FieldNo : Integer] : ShortString Index 39 Read GetFieldDesc10;
    Property ufJSTEnabled10 [FieldNo : Integer] : Boolean Index 34 Read GetFieldEnabled10;
    Property ufJSTLineDesc10 [FieldNo : Integer] : ShortString Index 40 Read GetFieldDesc10;
    Property ufJSTLineEnabled10 [FieldNo : Integer] : Boolean Index 35 Read GetFieldEnabled10;
    Property ufJPADesc10 [FieldNo : Integer] : ShortString Index 41 Read GetFieldDesc10;
    Property ufJPAEnabled10 [FieldNo : Integer] : Boolean Index 36 Read GetFieldEnabled10;
    Property ufJPALineDesc10 [FieldNo : Integer] : ShortString Index 42 Read GetFieldDesc10;
    Property ufJPALineEnabled10 [FieldNo : Integer] : Boolean Index 37 Read GetFieldEnabled10;
    Property ufJSADesc10 [FieldNo : Integer] : ShortString Index 43 Read GetFieldDesc10;
    Property ufJSAEnabled10 [FieldNo : Integer] : Boolean Index 38 Read GetFieldEnabled10;
    Property ufJSALineDesc10 [FieldNo : Integer] : ShortString Index 44 Read GetFieldDesc10;
    Property ufJSALineEnabled10 [FieldNo : Integer] : Boolean Index 39 Read GetFieldEnabled10;
  End; // TAbsUserFields3

//-------------------------------------------------------------------------

  TAbsUserFields4 = Class(TAbsUserFields3)
  Public
    // MH 02/01/2015 v7.1 ABSEXCH-15855: Added Address Description Fields
    Property ufAddressDesc [FieldNo : Integer] : ShortString Index 45 Read GetFieldDesc10;

    // MH 02/01/2015 v7.1 ABSEXCH-15949: Extended to support Customer/Supplier Credit Card Fields (11-15)
    // Use existing ufCustDesc10 property (11-15) for descriptions
    Property ufCustDescEnabled [FieldNo : Integer] : Boolean Index 40 Read GetFieldEnabled10;
    // Use existing ufSuppDesc10 property (11-15) for descriptions
    Property ufSuppDescEnabled [FieldNo : Integer] : Boolean Index 41 Read GetFieldEnabled10;
  End; // TAbsUserFields4

//-------------------------------------------------------------------------

  { Abstract System Setup wrapping the Paperless Module settings - Used by TAbsSetup }
  TAbsPaperlessSetup = Class(TObject)
  Protected
    Function GetYourEmailName : cuStr255; Virtual; Abstract;
    Function GetYourEmailAddress : cuStr255; Virtual; Abstract;
    Function GetSMTPServer : cuStr255; Virtual; Abstract;
    Function GetDefaultEmailPriority : Byte; Virtual; Abstract;
    Function GetEmailUseMAPI : Boolean; Virtual; Abstract;
    Function GetAttachMethod : Byte; Virtual; Abstract;
    Function GetAttachPrinter : cuStr20; Virtual; Abstract;
    Function GetFaxFromName : cuStr40; Virtual; Abstract;
    Function GetFaxFromTelNo : cuStr25; Virtual; Abstract;
    Function GetFaxPrinter : cuStr20; Virtual; Abstract;
    Function GetFaxInterfacePath : cuStr60; Virtual; Abstract;
    Function GetFaxUsing : Byte; Virtual; Abstract;
  Public
    Property ssYourEmailName : cuStr255 Read GetYourEmailName;
    Property ssYourEmailAddress : cuStr255 Read GetYourEmailAddress;
    Property ssSMTPServer : cuStr255 Read GetSMTPServer;
    Property ssDefaultEmailPriority : Byte Read GetDefaultEmailPriority;
    Property ssEmailUseMAPI : Boolean Read GetEmailUseMAPI;
    Property ssAttachMethod : Byte Read GetAttachMethod;
    Property ssAttachPrinter : cuStr20 Read GetAttachPrinter;
    Property ssFaxFromName : cuStr40 Read GetFaxFromName;
    Property ssFaxFromTelNo : cuStr25 Read GetFaxFromTelNo;
    Property ssFaxPrinter : cuStr20 Read GetFaxPrinter;
    Property ssFaxInterfacePath : cuStr60 Read GetFaxInterfacePath;
    Property ssFaxUsing : Byte Read GetFaxUsing;
  End; { TAbsPaperlessSetup }

  { Abstract System Setup wrapping the Paperless Module settings - Used by TAbsSetup }
  TAbsPaperlessSetup2 = Class(TAbsPaperlessSetup)
  Protected
    Function GetAttachPrinter50 : cuStr50; Virtual; Abstract;
    Function GetFaxPrinter50 : cuStr50; Virtual; Abstract;
  Public
    Property ssAttachPrinter50 : cuStr50 Read GetAttachPrinter50;
    Property ssFaxPrinter50 : cuStr50 Read GetFaxPrinter50;
  End; { TAbsPaperlessSetup }

{-----------------------------------------------------------------------------}

  { Abstract System Setup Interface - used by TAbsEnterpriseSystem }
  TAbsSetup = Class(TObject)
  Protected
    Function  GetPrinYr : Byte; Virtual; Abstract;
    Function  GetUserName : cuStr45; Virtual; Abstract;
    Function  GetAuditYr : Byte; Virtual; Abstract;
    Function  GetManROCP : Boolean; Virtual; Abstract;
    Function  GetVATCurr : Byte; Virtual; Abstract;
    Function  GetNoCosDec : Byte; Virtual; Abstract;
    Function  GetCurrBase : Byte; Virtual; Abstract;
    Function  GetShowStkGP : Boolean; Virtual; Abstract;
    Function  GetAutoValStk : Boolean; Virtual; Abstract;
    Function  GetDelPickOnly : Boolean; Virtual; Abstract;
    Function  GetUseMLoc : Boolean; Virtual; Abstract;
    Function  GetEditSinSer : Boolean; Virtual; Abstract;
    Function  GetWarnYRef : Boolean; Virtual; Abstract;
    Function  GetUseLocDel : Boolean; Virtual; Abstract;
    Function  GetPostCCGL : Boolean; Virtual; Abstract;
    Function  GetAlTolVal : Double; Virtual; Abstract;
    Function  GetAlTolMode : Byte; Virtual; Abstract;
    Function  GetDebtLMode : Byte; Virtual; Abstract;
    Function  GetAutoGenVar : Boolean; Virtual; Abstract;
    Function  GetAutoGenDisc : Boolean; Virtual; Abstract;
    Function  GetUSRCntryCode : cuStr3; Virtual; Abstract;
    Function  GetNoNetDec : Byte; Virtual; Abstract;
    Function  GetDebTrig (Index : cuDebtChaseIndex) : Byte; Virtual; Abstract;
    Function  GetNoInvLines : Byte; Virtual; Abstract;
    Function  GetWksODue : Byte; Virtual; Abstract;
    Function  GetCPr : Byte; Virtual; Abstract;
    Function  GetCYr : Byte; Virtual; Abstract;
    Function  GetTradeTerm : Boolean; Virtual; Abstract;
    Function  GetStaSepCr : Boolean; Virtual; Abstract;
    Function  GetStaAgeMthd : Byte; Virtual; Abstract;
    Function  GetStaUIDate : Boolean; Virtual; Abstract;
    Function  GetQUAllocFlg : Boolean; Virtual; Abstract;
    Function  GetDeadBOM : Boolean; Virtual; Abstract;
    Function  GetAuthMode : Char; Virtual; Abstract;
    Function  GetIntraStat : Boolean; Virtual; Abstract;
    Function  GetAnalStkDesc : Boolean; Virtual; Abstract;
    Function  GetAutoStkVal : Char; Virtual; Abstract;
    Function  GetAutoBillUp : Boolean; Virtual; Abstract;
    Function  GetAutoCQNo : Boolean; Virtual; Abstract;
    Function  GetIncNotDue : Boolean; Virtual; Abstract;
    Function  GetUseBatchTot : Boolean; Virtual; Abstract;
    Function  GetUseStock : Boolean; Virtual; Abstract;
    Function  GetAutoNotes : Boolean; Virtual; Abstract;
    Function  GetHideMenuOpt : Boolean; Virtual; Abstract;
    Function  GetUseCCDep : Boolean; Virtual; Abstract;
    Function  GetNoHoldDisc : Boolean; Virtual; Abstract;
    Function  GetAutoPrCalc : Boolean; Virtual; Abstract;
    Function  GetStopBadDr : Boolean; Virtual; Abstract;
    Function  GetUsePayIn : Boolean; Virtual; Abstract;
    Function  GetUsePasswords : Boolean; Virtual; Abstract;
    Function  GetPrintReciept : Boolean; Virtual; Abstract;
    Function  GetExternCust : Boolean; Virtual; Abstract;
    Function  GetNoQtyDec : Byte; Virtual; Abstract;
    Function  GetExternSIN : Boolean; Virtual; Abstract;
    Function  GetPrevPrOff : Boolean; Virtual; Abstract;
    Function  GetDefPcDisc : Boolean; Virtual; Abstract;
    Function  GetTradCodeNum : Boolean; Virtual; Abstract;
    Function  GetUpBalOnPost : Boolean; Virtual; Abstract;
    Function  GetShowInvDisc : Boolean; Virtual; Abstract;
    Function  GetSepDiscounts : Boolean; Virtual; Abstract;
    Function  GetUseCreditChk : Boolean; Virtual; Abstract;
    Function  GetUseCRLimitChk : Boolean; Virtual; Abstract;
    Function  GetAutoClearPay : Boolean; Virtual; Abstract;
    Function  GetTotalConv : Char; Virtual; Abstract;
    Function  GetDispPrAsMonths : Boolean; Virtual; Abstract;
    Function  GetNomCtrlCodes (Index : cuNomCtrlType) : LongInt; Virtual; Abstract;
    Function  GetDetailAddr (Index : cuAddrIndex) : cuStr30; Virtual; Abstract;
    Function  GetDirectCust : cuStr10; Virtual; Abstract;
    Function  GetDirectSupp : cuStr10; Virtual; Abstract;
    Function  GetTermsofTrade (Index : cuTermsIndex) : cuStr80; Virtual; Abstract;
    Function  GetNomPayFrom : LongInt; Virtual; Abstract;
    Function  GetNomPayToo : LongInt; Virtual; Abstract;
    Function  GetSettleDisc : Real; Virtual; Abstract;
    Function  GetSettleDays : SmallInt; Virtual; Abstract;
    Function  GetNeedBMUp : Boolean; Virtual; Abstract;
    Function  GetInpPack : Boolean; Virtual; Abstract;
    Function  GetVATCode : Char; Virtual; Abstract;
    Function  GetPayTerms : SmallInt; Virtual; Abstract;
    Function  GetStaAgeInt : SmallInt; Virtual; Abstract;
    Function  GetQuoOwnDate : Boolean; Virtual; Abstract;
    Function  GetFreeExAll : Boolean; Virtual; Abstract;
    Function  GetDirOwnCount : Boolean; Virtual; Abstract;
    Function  GetStaShowOS : Boolean; Virtual; Abstract;
    Function  GetLiveCredS : Boolean; Virtual; Abstract;
    Function  GetBatchPPY : Boolean; Virtual; Abstract;
    Function  GetWarnJC : Boolean; Virtual; Abstract;
    Function  GetDefBanknom : LongInt; Virtual; Abstract;
    Function  GetUseDefBank : Boolean; Virtual; Abstract;
    Function  GetMonWk1 : cuLongDate; Virtual; Abstract;
    Function  GetAuditDate : cuLongDate; Virtual; Abstract;
    Function  GetUserSort : cuStr6; Virtual; Abstract;
    Function  GetUserAcc : cuStr8; Virtual; Abstract;
    Function  GetUserRef : cuStr18; Virtual; Abstract;
    Function  GetUserBank : cuStr25; Virtual; Abstract;
    Function  GetLastExpFolio : LongInt; Virtual; Abstract;
    Function  GetDetailTel : cuStr15; Virtual; Abstract;
    Function  GetDetailFax : cuStr15; Virtual; Abstract;
    Function  GetUserVATReg : cuStr30; Virtual; Abstract;
    Function  GetDataPath : ShortString; Virtual; Abstract;

    Function  GetCurrencyObj(Index : cuCurrencyType) : TAbsCcyInfo; Virtual; Abstract;
    Function  GetVatRateObj(Index : cuVATIndex) : TAbsVATInfo; Virtual; Abstract;

    Function  GetUserFields : TAbsUserFields; Virtual; Abstract;

    Function  GetWORAllocStockOnPick : Boolean; Virtual; Abstract;
    Function  GetWOPDisableWIP : Boolean; Virtual; Abstract;
    Function  GetWORCopyStkNotes : Byte; Virtual; Abstract;
    Function  GetPaperless : TAbsPaperlessSetup; Virtual; Abstract;
  Public
{01} Property ssPrinYr : Byte Read GetPrinYr;
{02} Property ssUserName : cuStr45 Read GetUserName;
{03} Property ssAuditYr : Byte Read GetAuditYr;
{04} Property ssManROCP : Boolean Read GetManROCP;
{05} Property ssVATCurr : Byte Read GetVATCurr;
{06} Property ssNoCosDec : Byte Read GetNoCosDec;
{07} Property ssCurrBase : Byte Read GetCurrBase;
{08} Property ssShowStkGP : Boolean Read GetShowStkGP;
{09} Property ssAutoValStk : Boolean Read GetAutoValStk;
{10} Property ssDelPickOnly : Boolean Read GetDelPickOnly;
{11} Property ssUseMLoc : Boolean Read GetUseMLoc;
{12} Property ssEditSinSer : Boolean Read GetEditSinSer;
{13} Property ssWarnYRef : Boolean Read GetWarnYRef;
{14} Property ssUseLocDel : Boolean Read GetUseLocDel;
{15} Property ssPostCCGL : Boolean Read GetPostCCGL;
{16} Property ssAlTolVal : Double Read GetAlTolVal;
{17} Property ssAlTolMode : Byte Read GetAlTolMode;
{18} Property ssDebtLMode : Byte Read GetDebtLMode;
{19} Property ssAutoGenVar : Boolean Read GetAutoGenVar;
{20} Property ssAutoGenDisc : Boolean Read GetAutoGenDisc;
{21} Property ssUSRCntryCode : cuStr3 Read GetUSRCntryCode;
{22} Property ssNoNetDec : Byte Read GetNoNetDec;
{23} Property ssDebtChaseDays[Index : cuDebtChaseIndex] : Byte Read GetDebTrig;
{24} Property ssNoInvLines : Byte Read GetNoInvLines;
{25} Property ssWksODue : Byte Read GetWksODue;
{26} Property ssCPr : Byte Read GetCPr;
{27} Property ssCYr : Byte Read GetCYr;
{28} Property ssTradeTerm : Boolean Read GetTradeTerm;
{29} Property ssStaSepCr : Boolean Read GetStaSepCr;
{30} Property ssStaAgeMthd : Byte Read GetStaAgeMthd;
{31} Property ssStaUIDate : Boolean Read GetStaUIDate;
{32} Property ssQUAllocFlg : Boolean Read GetQUAllocFlg;
{33} Property ssDeadBOM : Boolean Read GetDeadBOM;
{34} Property ssAuthMode : Char Read GetAuthMode;
{35} Property ssIntraStat : Boolean Read GetIntraStat;
{36} Property ssAnalStkDesc : Boolean Read GetAnalStkDesc;
{37} Property ssAutoStkVal : Char Read GetAutoStkVal;
{38} Property ssAutoBillUp : Boolean Read GetAutoBillUp;
{39} Property ssAutoCQNo : Boolean Read GetAutoCQNo;
{40} Property ssIncNotDue : Boolean Read GetIncNotDue;
{41} Property ssUseBatchTot : Boolean Read GetUseBatchTot;
{42} Property ssUseStock : Boolean Read GetUseStock;
{43} Property ssAutoNotes : Boolean Read GetAutoNotes;
{44} Property ssHideMenuOpt : Boolean Read GetHideMenuOpt;
{45} Property ssUseCCDep : Boolean Read GetUseCCDep;
{46} Property ssNoHoldDisc : Boolean Read GetNoHoldDisc;
{47} Property ssAutoPrCalc : Boolean Read GetAutoPrCalc;
{48} Property ssStopBadDr : Boolean Read GetStopBadDr;
{49} Property ssUsePayIn : Boolean Read GetUsePayIn;
{50} Property ssUsePasswords : Boolean Read GetUsePasswords;
{51} Property ssPrintReciept : Boolean Read GetPrintReciept;
{52} Property ssExternCust : Boolean Read GetExternCust;
{53} Property ssNoQtyDec : Byte Read GetNoQtyDec;
{54} Property ssExternSIN : Boolean Read GetExternSIN;
{55} Property ssPrevPrOff : Boolean Read GetPrevPrOff;
{56} Property ssDefPcDisc : Boolean Read GetDefPcDisc;
{57} Property ssTradCodeNum : Boolean Read GetTradCodeNum;
{58} Property ssUpBalOnPost : Boolean Read GetUpBalOnPost;
{59} Property ssShowInvDisc : Boolean Read GetShowInvDisc;
{60} Property ssSepDiscounts : Boolean Read GetSepDiscounts;
{61} Property ssUseCreditChk : Boolean Read GetUseCreditChk;
{62} Property ssUseCRLimitChk : Boolean Read GetUseCRLimitChk;
{63} Property ssAutoClearPay : Boolean Read GetAutoClearPay;
{64} Property ssTotalConv : Char Read GetTotalConv;
{65} Property ssDispPrAsMonths : Boolean Read GetDispPrAsMonths;
{66} Property ssGLCtrlCodes[Index : cuNomCtrlType] : LongInt Read GetNomCtrlCodes;
{67} Property ssDetailAddr[Index : cuAddrIndex] : cuStr30 Read GetDetailAddr;
{68} Property ssDirectCust : cuStr10 Read GetDirectCust;
{69} Property ssDirectSupp : cuStr10 Read GetDirectSupp;
{70} Property ssTermsofTrade[Index : cuTermsIndex] : cuStr80 Read GetTermsofTrade;
{71} Property ssGLPayFrom : LongInt Read GetNomPayFrom;
{72} Property ssGLPayToo : LongInt Read GetNomPayToo;
{73} Property ssSettleDisc : Real Read GetSettleDisc;
{74} Property ssSettleDays : SmallInt Read GetSettleDays;
{75} Property ssNeedBMUp : Boolean Read GetNeedBMUp;
{77} Property ssInpPack : Boolean Read GetInpPack;
{78} Property ssVATCode : Char Read GetVATCode;
{79} Property ssPayTerms : SmallInt Read GetPayTerms;
{80} Property ssStaAgeInt : SmallInt Read GetStaAgeInt;
{81} Property ssQuoOwnDate : Boolean Read GetQuoOwnDate;
{82} Property ssFreeExAll : Boolean Read GetFreeExAll;
{83} Property ssDirOwnCount : Boolean Read GetDirOwnCount;
{84} Property ssStaShowOS : Boolean Read GetStaShowOS;
{85} Property ssLiveCredS : Boolean Read GetLiveCredS;
{86} Property ssBatchPPY : Boolean Read GetBatchPPY;
{87} Property ssWarnJC : Boolean Read GetWarnJC;
{88} Property ssDefBankGL : LongInt Read GetDefBanknom;
{89} Property ssUseDefBank : Boolean Read GetUseDefBank;
{90} Property ssMonWk1 : cuLongDate Read GetMonWk1;
{91} Property ssAuditDate : cuLongDate Read GetAuditDate;
{92} Property ssUserSort : cuStr6 Read GetUserSort;
{93} Property ssUserAcc : cuStr8 Read GetUserAcc;
{94} Property ssUserRef : cuStr18 Read GetUserRef;
{95} Property ssUserBank : cuStr25 Read GetUserBank;
{96} Property ssLastExpFolio : LongInt Read GetLastExpFolio;
{97} Property ssDetailTel : cuStr15 Read GetDetailTel;
{98} Property ssDetailFax : cuStr15 Read GetDetailFax;
{99} Property ssUserVATReg : cuStr30 Read GetUserVATReg;
{100}Property ssDataPath : ShortString Read GetDataPath;

     Property ssCurrency[Index : cuCurrencyType] : TAbsCcyInfo Read GetCurrencyObj;
     Property ssVATRates[Index : cuVATIndex] : TAbsVATInfo Read GetVatRateObj;

     Property ssUserFields : TAbsUserFields Read GetUserFields;

     // New v5.00 properties
     Property ssWORAllocStockOnPick : Boolean Read GetWORAllocStockOnPick;
     Property ssWOPDisableWIP : Boolean Read GetWOPDisableWIP;
     Property ssWORCopyStkNotes : Byte Read GetWORCopyStkNotes;
     Property ssPaperless : TAbsPaperlessSetup Read GetPaperless;
  End; { TAbsSetup }

{-----------------------------------------------------------------------------}

  { v5.50 06/03/03 - Added new class to provide access to the new v5.50 CIS Setup Fields }
  TAbsCISRateSetup = Class(TObject)
  Protected
    Function GetCode : Char; Virtual; Abstract;
    Function GetDescription : cuStr10; Virtual; Abstract;
    Function GetRate : Double; Virtual; Abstract;
    Function GetGLCode : LongInt; Virtual; Abstract;
    Function GetCostCentre : cuStr3; Virtual; Abstract;
    Function GetDepartment : cuStr3; Virtual; Abstract;
  Public
    property cisrCode: Char read GetCode;
    property cisrDescription: cuStr10 read GetDescription;
    property cisrRate: Double read GetRate;
    property cisrGLCode: LongInt read GetGLCode;
    property cisrCostCentre: cuStr3 read GetCostCentre;
    property cisrDepartment: cuStr3 read GetDepartment;
  End; { TAbsCISSetup }

  //------------------------------

  { v5.50 06/03/03 - Added new class to provide access to the new v5.50 CIS Setup Fields }
  TAbsCISCounterSetup = Class(TObject)
  Protected
    Function GetPrefix : cuStr3; Virtual; Abstract;
    Function GetCounter : Int64; Virtual; Abstract;
  Public
    property cvPrefix: cuStr3 read GetPrefix;
    property cvCounter: Int64 read GetCounter;
  End; { TAbsCISCounterSetup }

  //------------------------------

  { v5.50 06/03/03 - Added new class to provide access to the new v5.50 CIS Setup Fields }
  TAbsCISSetup = Class(TObject)
  Protected
    Function GetInterval : Byte; Virtual; Abstract;
    Function GetAutoSetPeriod : Boolean; Virtual; Abstract;
    Function GetReturnDate : cuLongDate; Virtual; Abstract;
    Function GetTaxRef : cuStr20; Virtual; Abstract;
    Function GetDefaultVatCode : Char; Virtual; Abstract;
    Function GetFolioNumber : LongInt; Virtual; Abstract;
    Function GetRate(RateCode : cuCISTaxType) : TAbsCISRateSetup; Virtual; Abstract;
    Function GetVoucherCounter(VoucherType: cuCISVoucherType) : TAbsCISCounterSetup; Virtual; Abstract;
  Public
    property cisInterval: Byte read GetInterval;
    property cisAutoSetPeriod: Boolean read GetAutoSetPeriod;
    property cisReturnDate: cuLongDate read GetReturnDate;
    property cisTaxRef: cuStr20 read GetTaxRef;
    property cisDefaultVatCode: Char read GetDefaultVatCode;
    property cisFolioNumber: LongInt read GetFolioNumber;
    property cisRate[RateCode: cuCISTaxType]: TAbsCISRateSetup read GetRate;
    property cisVoucherCounter[VoucherType: cuCISVoucherType]: TAbsCISCounterSetup read GetVoucherCounter;
  End; { TAbsCISSetup }

  //------------------------------

  { v5.60 24/03/04 - Added new class to provide access to the new v5.60 CIS Setup Fields }
  TAbsCISSetup2 = Class(TAbsCISSetup)
  Protected
    Function GetContractorCertNo : ShortString; Virtual; Abstract;
    Function ContractorCertExpiry : cuLongDate; Virtual; Abstract;
    Function GetContractorCertType : Byte; Virtual; Abstract;
  Public
    property cisContractorCertNo : ShortString read GetContractorCertNo;
    property cisContractorCertExpiry : cuLongDate read ContractorCertExpiry;
    property cisContractorCertType : Byte read GetContractorCertType;
  End; { TAbsCISSetup2 }

{-----------------------------------------------------------------------------}

  { v5.50 06/03/03 - Added new class to provide access to the Job Costing Setup Fields }
  TAbsJobCostingSetup = Class(TObject)
  Protected
    Function GetUsePPIsForTimeSheets : Boolean; Virtual; Abstract;
    Function GetSplitJobBudgetsByPeriod : Boolean; Virtual; Abstract;
    Function GetPPISupAccount : cuStr6; Virtual; Abstract;
    Function GetJobCategory(Index: cuJobCategoryType) : cuStr20; Virtual; Abstract;
    Function GetCheckJobBudget : Boolean; Virtual; Abstract;
    Function GetJobCostingGLCtrlCodes(Index: cuSystemSetupJobGLCtrlType) : LongInt; Virtual; Abstract;
  Public
    property ssUsePPIsForTimeSheets: Boolean read GetUsePPIsForTimeSheets;
    property ssSplitJobBudgetsByPeriod: Boolean read GetSplitJobBudgetsByPeriod;
    property ssPPISupAccount: cuStr6 read GetPPISupAccount;
    property ssJobCategory[Index: cuJobCategoryType] : cuStr20 read GetJobCategory;
    property ssCheckJobBudget: Boolean read GetCheckJobBudget;
    property ssJobCostingGLCtrlCodes[Index: cuSystemSetupJobGLCtrlType]: LongInt read GetJobCostingGLCtrlCodes;
  End; { TAbsJobCostingSetup }

{-----------------------------------------------------------------------------}

  { v5.50 06/03/03 - Added new class to provide access to the new v5.50 Setup Fields }
  TAbsSetup2 = Class(TAbsSetup)
  Protected
    Function GetCISSetup : TAbsCISSetup; Virtual; Abstract;
    Function GetJobCosting : TAbsJobCostingSetup; Virtual; Abstract;
  Public
    property ssCISSetup : TAbsCISSetup read GetCISSetup;
    property ssJobCosting: TAbsJobCostingSetup read GetJobCosting;
  End; { TAbsSetup2 }

{-----------------------------------------------------------------------------}

  { v5.52 10/09/03: Added descendant class to include new Bin details }
  TAbsSetup3 = Class(TAbsSetup2)
  Protected
    Function GetFilterSNoByBinLoc : Boolean; Virtual; Abstract;
    Function GetKeepBinHistory : Boolean; Virtual; Abstract;
    Function GetBinMask : cuStr10; Virtual; Abstract;
  Public
    property ssFilterSNoByBinLoc : Boolean read GetFilterSNoByBinLoc;
    property ssKeepBinHistory : Boolean read GetKeepBinHistory;
    property ssBinMask: cuStr10 read GetBinMask;
  End; { TAbsSetup3 }

{-----------------------------------------------------------------------------}

  // v6.00 11/05/07: Added Connection Info for future use
  TAbsSetup4 = Class(TAbsSetup3)
  Protected
    //SS:29/10/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    Function GetConnectInfo : WideString; Virtual; Abstract;
  Public
    property ssConnectInfo : WideString read GetConnectInfo;
  End; { TAbsSetup4 }

  //------------------------------

  // v6.01 07/05/2009: Added Advanced Discounts support
  TAbsSetup5 = Class(TAbsSetup4)
  Protected
    Function GetUseTTD : Boolean; Virtual; Abstract;
    Function GetUseVBD : Boolean; Virtual; Abstract;
  Public
    property ssUseTransactionTotalDiscounts : Boolean read GetUseTTD;  // Use Transaction Total Discounts
    property ssUseValueBasedDiscounts : Boolean read GetUseVBD;  // Use Value Based Discounts
  End; // TAbsSetup5

  //------------------------------

  // v6.2 - 20/08/09 - Added new fields for EC Services support
  TAbsSetup6 = Class(TAbsSetup5)
  Protected
    Function GetEnableECServices : Boolean; Virtual; Abstract;
    Function GetECSalesThreshold : Double; Virtual; Abstract;
  Public
    property ssEnableECServices : Boolean read GetEnableECServices;  // Enable EC Services
    property ssECSalesThreshold : Double read GetECSalesThreshold;  // EC Sales Threshold in VAT Currency
  End; // TAbsSetup6

  //------------------------------

  // v6.3 - 18/01/10 - Added Company Code field
  TAbsSetup7 = Class(TAbsSetup6)
  Protected
    Function GetCompanyCode : ShortString; Virtual; Abstract;
  Public
    property ssCompanyCode : ShortString read GetCompanyCode;  // CompanyCode
  End; // TAbsSetup7

  //------------------------------

  // v6.5 - 12/10/10 - Added Override Locations on Purchases flag
  TAbsSetup8 = Class(TAbsSetup7)
  Protected
    Function GetEnableOverrideLocation : Boolean; Virtual; Abstract;
  Public
    property ssEnableOverrideLocation : Boolean read GetEnableOverrideLocation;
  End; // TAbsSetup7

  //------------------------------

  // v6.9 - 12/10/10 - Added Override Locations on Purchases flag
  TAbsSetup9 = Class(TAbsSetup8)
  Protected
    Function GetUserFields2 : TAbsUserFields2; Virtual; Abstract;
  Public
    Property ssUserFields2 : TAbsUserFields2 Read GetUserFields2;
  End; // TAbsSetup9

  //-------------------------------------------------------------------------
  //PR: 26/07/2013 Added SEPA bank fields
  TAbsSetup10 = Class(TAbsSetup9)
  Protected
    Function GetBankAccountCode : cuStr35; Virtual; Abstract;
    Function GetBankSortCode : cuStr11; Virtual; Abstract;
  Public
    Property ssBankAccountCode : cuStr35 Read GetBankAccountCode;
    Property ssBankSortCode : cuStr11 Read GetBankSortCode;
  End; // TAbsSetup10

  //------------------------------

  // MH 30/09/2013 MRD Branch for v7.0.8: Added new fields for Consumer Ledger and Auto-Receipt
  TAbsSetup11 = Class(TAbsSetup10)
  Protected
    Function GetConsumersEnabled : Boolean; Virtual; Abstract;
  Public
    Property ssConsumersEnabled : Boolean Read GetConsumersEnabled;
  End; // TAbsSetup11

  //-------------------------------------------------------------------------

  // MH 22/09/2014 Order Payments
  TAbsSetup12 = Class(TAbsSetup11)
  Protected
    Function GetOrderPaymentsEnabled : Boolean; Virtual; Abstract;
  Public
    Property ssOrderPaymentsEnabled : Boolean Read GetOrderPaymentsEnabled;
  End; // TAbsSetup12

  //-------------------------------------------------------------------------

  //AP 01/12/2017 2018R1 ABSEXCH-19401: GDPR (POST 19344) - 8.3.1.1.3 - DLL + COM Customisation Support
  TAbsSetupGDPR = Class(TObject)
  Protected
    Function  GetAnonymised: Boolean; Virtual; Abstract;
    Function  GetAnonymisedDate: cuStr8; Virtual; Abstract;
    Function  GetAnonymisedTime: cuStr6; Virtual; Abstract;
    Function  GetGDPRTraderRetentionPeriod: Integer; Virtual; Abstract;
    Function  GetGDPRTraderDisplayPIITree: Boolean; Virtual; Abstract;
    Function  GetGDPRTraderAnonNotesOption: Integer; Virtual; Abstract;
    Function  GetGDPRTraderAnonLettersOption: Integer; Virtual; Abstract;
    Function  GetGDPRTraderAnonLinksOption: Integer; Virtual; Abstract;
    Function  GetGDPREmployeeRetentionPeriod: Integer; Virtual; Abstract;
    Function  GetGDPREmployeeDisplayPIITree: Boolean; Virtual; Abstract;
    Function  GetGDPREmployeeAnonNotesOption: Integer; Virtual; Abstract;
    Function  GetGDPREmployeeAnonLettersOption: Integer; Virtual; Abstract;
    Function  GetGDPREmployeeAnonLinksOption: Integer; Virtual; Abstract;
    Function  GetNotificationWarningColour: Integer; Virtual; Abstract;
    Function  GetNotificationWarningFontColour: Integer; Virtual; Abstract;
    Function  GetGDPRCompanyAnonLocations: Boolean; Virtual; Abstract;
    Function  GetGDPRCompanyAnonCostCentres: Boolean; Virtual; Abstract;
    Function  GetGDPRCompanyAnonDepartment: Boolean; Virtual; Abstract;
    Function  GetGDPRCompanyNotesOption: Integer; Virtual; Abstract;
    Function  GetGDPRCompanyLettersOption: Integer; Virtual; Abstract;
    Function  GetGDPRCompanyLinksOption: Integer; Virtual; Abstract;
  Public
    property Anonymised: Boolean Read GetAnonymised;
    property AnonymisedDate: cuStr8 Read GetAnonymisedDate;
    property AnonymisedTime: cuStr6 Read GetAnonymisedTime;
    property GDPRTraderRetentionPeriod: Integer Read GetGDPRTraderRetentionPeriod;
    property GDPRTraderDisplayPIITree: Boolean Read GetGDPRTraderDisplayPIITree;
    property GDPRTraderAnonNotesOption: Integer Read GetGDPRTraderAnonNotesOption;
    property GDPRTraderAnonLettersOption: Integer Read GetGDPRTraderAnonLettersOption;
    property GDPRTraderAnonLinksOption: Integer Read GetGDPRTraderAnonLinksOption;
    property GDPREmployeeRetentionPeriod: Integer Read GetGDPREmployeeRetentionPeriod;
    property GDPREmployeeDisplayPIITree: Boolean Read GetGDPREmployeeDisplayPIITree;
    property GDPREmployeeAnonNotesOption: Integer Read GetGDPREmployeeAnonNotesOption;
    property GDPREmployeeAnonLettersOption: Integer Read GetGDPREmployeeAnonLettersOption;
    property GDPREmployeeAnonLinksOption: Integer Read GetGDPREmployeeAnonLinksOption;
    property NotificationWarningColour: Integer Read GetNotificationWarningColour;
    property NotificationWarningFontColour: Integer Read GetNotificationWarningFontColour;
    property GDPRCompanyAnonLocations: Boolean Read GetGDPRCompanyAnonLocations;
    property GDPRCompanyAnonCostCentres: Boolean Read GetGDPRCompanyAnonCostCentres;
    property GDPRCompanyAnonDepartment: Boolean Read GetGDPRCompanyAnonDepartment;
    property GDPRCompanyNotesOption: Integer Read GetGDPRCompanyNotesOption;
    property GDPRCompanyLettersOption: Integer Read GetGDPRCompanyLettersOption;
    property GDPRCompanyLinksOption: Integer Read GetGDPRCompanyLinksOption;
  End; // TAbsSetupGDPR

  //-------------------------------------------------------------------------

  //AP 05/12/2017 ABSEXCH-19401 GDPR
  TAbsSetup13 = Class(TAbsSetup12)
  Protected
    Function GetGDPR : TAbsSetupGDPR; Virtual; Abstract;
  Public
    Property ssGDPR : TAbsSetupGDPR read GetGDPR;
  End; // TAbsSetup12

  //-------------------------------------------------------------------------

  //AP 01/02/2018 Currency Import Tolerance support
  TAbsSetup14 = Class(TAbsSetup13)
  Protected
    Function GetCurrencyImportTolerance : Real; Virtual; Abstract;
  Public
    Property CurrencyImportTolerance : Real Read GetCurrencyImportTolerance;
  End; // TAbsSetup14
  
  //-------------------------------------------------------------------------
  //SS:29/10/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  TAbsSetup15 = Class(TAbsSetup14)
  Protected
    Function GetConnectionString: WideString; Virtual; Abstract;
    Function GetConnectionPassword: WideString; Virtual; Abstract;
  Public
    property ssConnectionString: WideString read GetConnectionString;
    property ssConnectionPassword: WideString read GetConnectionPassword;
  End; // TAbsSetup14

  //-------------------------------------------------------------------------

  { Abstract Customer/Supplier Interface - used by TAbsEnterpriseSystem }
  TAbsCustomer = Class(TObject)
  Protected
    Function GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetCustCode : cuStr6; Virtual; Abstract;
    Procedure SetCustCode(Value : cuStr6); Virtual; Abstract;
    Function  GetCompany : cuStr45; Virtual; Abstract;
    Procedure SetCompany(Value : cuStr45); Virtual; Abstract;
    Function  GetAreaCode : cuStr4; Virtual; Abstract;
    Procedure SetAreaCode(Value : cuStr4); Virtual; Abstract;
    Function  GetRepCode : cuStr4; Virtual; Abstract;
    Procedure SetRepCode(Value : cuStr4); Virtual; Abstract;
    Function  GetRemitCode : cuStr6; Virtual; Abstract;
    Procedure SetRemitCode(Value : cuStr6); Virtual; Abstract;
    Function  GetVATRegNo : cuStr30; Virtual; Abstract;
    Procedure SetVATRegNo(Value : cuStr30); Virtual; Abstract;
    Function  GetAddr(Index : cuAddrIndex) : cuStr30; Virtual; Abstract;
    Procedure SetAddr(Index : cuAddrIndex; Value : cuStr30); Virtual; Abstract;
    Function  GetDespAddr : Boolean; Virtual; Abstract;
    Procedure SetDespAddr(Value : Boolean); Virtual; Abstract;
    Function  GetDAddr (Index : cuAddrIndex) : cuStr30; Virtual; Abstract;
    Procedure SetDAddr(Index : cuAddrIndex; Value : cuStr30); Virtual; Abstract;
    Function  GetContact : cuStr25; Virtual; Abstract;
    Procedure SetContact(Value : cuStr25); Virtual; Abstract;
    Function  GetPhone : cuStr30; Virtual; Abstract;
    Procedure SetPhone(Value : cuStr30); Virtual; Abstract;
    Function  GetFax : cuStr30; Virtual; Abstract;
    Procedure SetFax(Value : cuStr30); Virtual; Abstract;
    Function  GetRefNo : cuStr10; Virtual; Abstract;
    Procedure SetRefNo(Value : cuStr10); Virtual; Abstract;
    Function  GetTradTerm : Boolean; Virtual; Abstract;
    Procedure SetTradTerm(Value : Boolean); Virtual; Abstract;
    Function  GetSTerms (Index : cuTermsIndex) : cuStr80; Virtual; Abstract;
    Procedure SetSTerms(Index : cuTermsIndex; Value : cuStr80); Virtual; Abstract;
    Function  GetCurrency : cuCurrencyType; Virtual; Abstract;
    Procedure SetCurrency(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetVATCode : Char; Virtual; Abstract;
    Procedure SetVATCode(Value : Char); Virtual; Abstract;
    Function  GetPayTerms : SmallInt; Virtual; Abstract;
    Procedure SetPayTerms(Value : SmallInt); Virtual; Abstract;
    Function  GetCreditLimit : Real; Virtual; Abstract;
    Procedure SetCreditLimit(Value : Real); Virtual; Abstract;
    Function  GetDiscount : Real; Virtual; Abstract;
    Procedure SetDiscount(Value : Real); Virtual; Abstract;
    Function  GetCreditStatus : SmallInt; Virtual; Abstract;
    Procedure SetCreditStatus(Value : SmallInt); Virtual; Abstract;
    Function  GetCustCC : cuStr3; Virtual; Abstract;
    Procedure SetCustCC(Value : cuStr3); Virtual; Abstract;
    Function  GetCDiscCh : Char; Virtual; Abstract;
    Procedure SetCDiscCh(Value : Char); Virtual; Abstract;
    Function  GetBalance : Real; Virtual; Abstract;
    Procedure SetBalance(Value : Real); Virtual; Abstract;
    Function  GetCustDep : cuStr3; Virtual; Abstract;
    Procedure SetCustDep(Value : cuStr3); Virtual; Abstract;
    Function  GetEECMember : Boolean; Virtual; Abstract;
    Procedure SetEECMember(Value : Boolean); Virtual; Abstract;
    Function  GetIncStat : Boolean; Virtual; Abstract;
    Procedure SetIncStat(Value : Boolean); Virtual; Abstract;
    Function  GetDefNomCode : LongInt; Virtual; Abstract;
    Procedure SetDefNomCode(Value : LongInt); Virtual; Abstract;
    Function  GetDefMLocStk : cuStr3; Virtual; Abstract;
    Procedure SetDefMLocStk(Value : cuStr3); Virtual; Abstract;
    Function  GetAccStatus : cuAccStatusType; Virtual; Abstract;
    Procedure SetAccStatus(Value : cuAccStatusType); Virtual; Abstract;
    Function  GetPayType : Char; Virtual; Abstract;
    Procedure SetPayType(Value : Char); Virtual; Abstract;
    Function  GetBankSort : cuStr20; Virtual; Abstract;
    Procedure SetBankSort(Value : cuStr20); Virtual; Abstract;
    Function  GetBankAcc : cuStr15; Virtual; Abstract;
    Procedure SetBankAcc(Value : cuStr15); Virtual; Abstract;
    Function  GetBankRef : cuStr28; Virtual; Abstract;
    Procedure SetBankRef(Value : cuStr28); Virtual; Abstract;
    Function  GetPhone2 : cuStr30; Virtual; Abstract;
    Procedure SetPhone2(Value : cuStr30); Virtual; Abstract;
    Function  GetDefCOSNom : LongInt; Virtual; Abstract;
    Procedure SetDefCOSNom(Value : LongInt); Virtual; Abstract;
    Function  GetDefCtrlNom : LongInt; Virtual; Abstract;
    Procedure SetDefCtrlNom(Value : LongInt); Virtual; Abstract;
    Function  GetLastUsed : cuLongDate; Virtual; Abstract;
    Procedure SetLastUsed(Value : cuLongDate); Virtual; Abstract;
    Function  GetUserDef1 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef1(Value : cuStr30); Virtual; Abstract;
    Function  GetUserDef2 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef2(Value : cuStr30); Virtual; Abstract;
    Function  GetSOPInvCode : cuStr6; Virtual; Abstract;
    Procedure SetSOPInvCode(Value : cuStr6); Virtual; Abstract;
    Function  GetSOPAutoWOff : Boolean; Virtual; Abstract;
    Procedure SetSOPAutoWOff(Value : Boolean); Virtual; Abstract;
    Function  GetFDefPageNo : Byte; Virtual; Abstract;
    Procedure SetFDefPageNo(Value : Byte); Virtual; Abstract;
    Function  GetBOrdVal : Double; Virtual; Abstract;
    Procedure SetBOrdVal(Value : Double); Virtual; Abstract;
    Function  GetDirDeb : Byte; Virtual; Abstract;
    Procedure SetDirDeb(Value : Byte); Virtual; Abstract;

    Function  GetAltCode : cuStr20; Virtual; Abstract;
    Procedure SetAltCode(Value : cuStr20); Virtual; Abstract;
    Function  GetPostCode : cuStr20; Virtual; Abstract;
    Procedure SetPostCode(Value : cuStr20); Virtual; Abstract;
    Function  GetUserDef3 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef3(Value : cuStr30); Virtual; Abstract;
    Function  GetUserDef4 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef4(Value : cuStr30); Virtual; Abstract;
    Function  GetEmailAddr : cuStr100; Virtual; Abstract;
    Procedure SetEmailAddr(Value : cuStr100); Virtual; Abstract;
    Function  GetCCStart : cuLongDate; Virtual; Abstract;
    Procedure SetCCStart(Value : cuLongDate); Virtual; Abstract;
    Function  GetCCEnd : cuLongDate; Virtual; Abstract;
    Procedure SetCCEnd(Value : cuLongDate); Virtual; Abstract;
    Function  GetCCName : cuStr50; Virtual; Abstract;
    Procedure SetCCName(Value : cuStr50); Virtual; Abstract;
    Function  GetCCNumber : cuStr30; Virtual; Abstract;
    Procedure SetCCNumber(Value : cuStr30); Virtual; Abstract;
    Function  GetCCSwitch : cuStr4; Virtual; Abstract;
    Procedure SetCCSwitch(Value : cuStr4); Virtual; Abstract;

    Function  GetDefTagNo : Byte; Virtual; Abstract;
    Procedure SetDefTagNo(Value : Byte); Virtual; Abstract;
    Function  GetDefSettleDisc : Double; Virtual; Abstract;
    Procedure SetDefSettleDisc(Value : Double); Virtual; Abstract;
    Function  GetDefSettleDays : SmallInt; Virtual; Abstract;
    Procedure SetDefSettleDays(Value : SmallInt); Virtual; Abstract;
    Function  GetDocDeliveryMode : Byte; Virtual; Abstract;
    Procedure SetDocDeliveryMode(Value : Byte); Virtual; Abstract;
    Function  GetEbusPword : cuStr20; Virtual; Abstract;
    Procedure SetEbusPword(Value : cuStr20); Virtual; Abstract;
    Function  GetUseForEbus : Byte; Virtual; Abstract;
    Procedure SetUseForEbus(Value : Byte); Virtual; Abstract;
    Function  GetWebLiveCatalog : cuStr20; Virtual; Abstract;
    Procedure SetWebLiveCatalog(Value : cuStr20); Virtual; Abstract;
    Function  GetWebPrevCatalog : cuStr20; Virtual; Abstract;
    Procedure SetWebPrevCatalog(Value : cuStr20); Virtual; Abstract;
    Function  GetInclusiveVATCode : Char; Virtual; Abstract;
    Procedure SetInclusiveVATCode(Value : Char); Virtual; Abstract;
    Function  GetLastOperator : cuStr10; Virtual; Abstract;
    Procedure SetLastOperator(Value : cuStr10); Virtual; Abstract;
    Function  GetSendHTML : Boolean; Virtual; Abstract;
    Procedure SetSendHTML(Value : Boolean); Virtual; Abstract;
    Function  GetSendReader : Boolean; Virtual; Abstract;
    Procedure SetSendReader(Value : Boolean); Virtual; Abstract;
    Function  GetZIPAttachments : Byte; Virtual; Abstract;
    Procedure SetZIPAttachments(Value : Byte); Virtual; Abstract;
    Function  GetSSDDeliveryTerms : cuStr5; Virtual; Abstract;
    Procedure SetSSDDeliveryTerms(Value : cuStr5); Virtual; Abstract;
    Function  GetSSDModeOfTransport : Byte; Virtual; Abstract;
    Procedure SetSSDModeOfTransport(Value : Byte); Virtual; Abstract;
    Function  GetTimeStamp : cuStr6; Virtual; Abstract;
    Procedure SetTimeStamp(Value : cuStr6); Virtual; Abstract;
  Public
    Function LinkToDrCrGL : Boolean; Virtual; Abstract;

    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property acCode : cuStr6 Read GetCustCode Write SetCustCode;
{02} Property acCompany : cuStr45 Read GetCompany Write SetCompany;
{03} Property acArea : cuStr4 Read GetAreaCode Write SetAreaCode;
{04} Property acAccType : cuStr4 Read GetRepCode Write SetRepCode;
{05} Property acStatementTo : cuStr6 Read GetRemitCode Write SetRemitCode;
{06} Property acVATRegNo : cuStr30 Read GetVATRegNo Write SetVATRegNo;
{07} Property acAddress[Index : cuAddrIndex] : cuStr30 Read GetAddr Write SetAddr;
{08} Property acDelAddr : Boolean Read GetDespAddr Write SetDespAddr;
{09} Property acDelAddress[Index : cuAddrIndex] : cuStr30 Read GetDAddr Write SetDAddr;
{10} Property acContact : cuStr25 Read GetContact Write SetContact;
{11} Property acPhone : cuStr30 Read GetPhone Write SetPhone;
{12} Property acFax : cuStr30 Read GetFax Write SetFax;
{13} Property acTheirAcc : cuStr10 Read GetRefNo Write SetRefNo;
{14} Property acOwnTradTerm : Boolean Read GetTradTerm Write SetTradTerm;
{15} Property acTradeTerms[Index : cuTermsIndex] : cuStr80 Read GetSTerms Write SetSTerms;
{16} Property acCurrency : cuCurrencyType Read GetCurrency Write SetCurrency;
{17} Property acVATCode : Char Read GetVATCode Write SetVATCode;
{18} Property acPayTerms : SmallInt Read GetPayTerms Write SetPayTerms;
{19} Property acCreditLimit : Real Read GetCreditLimit Write SetCreditLimit;
{20} Property acDiscount : Real Read GetDiscount Write SetDiscount;
{21} Property acCreditStatus : SmallInt Read GetCreditStatus Write SetCreditStatus;
{22} Property acCostCentre : cuStr3 Read GetCustCC Write SetCustCC;
{23} Property acDiscountBand : Char Read GetCDiscCh Write SetCDiscCh;
{25} Property acDepartment : cuStr3 Read GetCustDep Write SetCustDep;
{26} Property acECMember : Boolean Read GetEECMember Write SetEECMember;
{27} Property acStatement : Boolean Read GetIncStat Write SetIncStat;
{28} Property acSalesGL : LongInt Read GetDefNomCode Write SetDefNomCode;
{29} Property acLocation : cuStr3 Read GetDefMLocStk Write SetDefMLocStk;
{30} Property acAccStatus : cuAccStatusType Read GetAccStatus Write SetAccStatus;
{31} Property acPayType : Char Read GetPayType Write SetPayType;
{32} Property acBankSort : cuStr20 Read GetBankSort Write SetBankSort;
{33} Property acBankAcc : cuStr15 Read GetBankAcc Write SetBankAcc;
{34} Property acBankRef : cuStr28 Read GetBankRef Write SetBankRef;
{35} Property acPhone2 : cuStr30 Read GetPhone2 Write SetPhone2;
{36} Property acCOSGL : LongInt Read GetDefCOSNom Write SetDefCOSNom;
{37} Property acDrCrGL : LongInt Read GetDefCtrlNom Write SetDefCtrlNom;
{38} Property acLastUsed : cuLongDate Read GetLastUsed Write SetLastUsed;
{39} Property acUserDef1 : cuStr30 Read GetUserDef1 Write SetUserDef1;
{40} Property acUserDef2 : cuStr30 Read GetUserDef2 Write SetUserDef2;
{41} Property acInvoiceTo : cuStr6 Read GetSOPInvCode Write SetSOPInvCode;
{42} Property acSOPAutoWOff : Boolean Read GetSOPAutoWOff Write SetSOPAutoWOff;
{43} Property acFormSet : Byte Read GetFDefPageNo Write SetFDefPageNo;
{44} Property acBookOrdVal : Double Read GetBOrdVal Write SetBOrdVal;
{45} Property acDirDebMode : Byte Read GetDirDeb Write SetDirDeb;

     { v4.31 Fields }
{46} Property acAltCode : cuStr20 Read GetAltCode Write SetAltCode;
{47} Property acPostCode : cuStr20 Read GetPostCode Write SetPostCode;
{48} Property acUserDef3 : cuStr30 Read GetUserDef3 Write SetUserDef3;
{49} Property acUserDef4 : cuStr30 Read GetUserDef4 Write SetUserDef4;
{50} Property acEmailAddr : cuStr100 Read GetEmailAddr Write SetEmailAddr;
{51} Property acCCStart : cuLongDate Read GetCCStart Write SetCCStart;
{52} Property acCCEnd : cuLongDate Read GetCCEnd Write SetCCEnd;
{53} Property acCCName : cuStr50 Read GetCCName Write SetCCName;
{54} Property acCCNumber : cuStr30 Read GetCCNumber Write SetCCNumber;
{55} Property acCCSwitch : cuStr4 Read GetCCSwitch Write SetCCSwitch;

     { v5.00 Fields }
{56} Property acDefTagNo : Byte Read GetDefTagNo Write SetDefTagNo;
{57} Property acDefSettleDisc : Double Read GetDefSettleDisc Write SetDefSettleDisc;
{58} Property acDefSettleDays : SmallInt Read GetDefSettleDays Write SetDefSettleDays;
{59} Property acDocDeliveryMode : Byte Read GetDocDeliveryMode Write SetDocDeliveryMode;
{60} Property acEbusPword : cuStr20 Read GetEbusPword Write SetEbusPword;
{61} Property acUseForEbus : Byte Read GetUseForEbus Write SetUseForEbus;
{62} Property acWebLiveCatalog : cuStr20 Read GetWebLiveCatalog Write SetWebLiveCatalog;
{63} Property acWebPrevCatalog : cuStr20 Read GetWebPrevCatalog Write SetWebPrevCatalog;
{64} Property acInclusiveVATCode : Char Read GetInclusiveVATCode Write SetInclusiveVATCode;
{65} Property acLastOperator : cuStr10 Read GetLastOperator Write SetLastOperator;
{66} Property acSendHTML : Boolean Read GetSendHTML Write SetSendHTML;
{67} Property acSendReader : Boolean Read GetSendReader Write SetSendReader;
{68} Property acZIPAttachments : Byte Read GetZIPAttachments Write SetZIPAttachments;
{69} Property acSSDDeliveryTerms : cuStr5 Read GetSSDDeliveryTerms Write SetSSDDeliveryTerms;
{70} Property acSSDModeOfTransport : Byte Read GetSSDModeOfTransport Write SetSSDModeOfTransport;
{71} Property acTimeStamp : cuStr6 Read GetTimeStamp Write SetTimeStamp;
  End; { TAbsCustomer}

{------------------------------------}

  TAbsCustomer2 = Class(TAbsCustomer)
  Protected
    Function  GetStateDeliveryMode : Byte; Virtual; Abstract;
    Procedure SetStateDeliveryMode(Value : Byte); Virtual; Abstract;
    Function  GetHeadOffice : Byte; Virtual; Abstract;
    Procedure SetHeadOffice(Value : Byte); Virtual; Abstract;
  Public
{72} Property acStateDeliveryMode : Byte Read GetStateDeliveryMode Write SetStateDeliveryMode;
{73} Property acHeadOffice : Byte Read GetHeadOffice Write SetHeadOffice;
  End; { TAbsCustomer2 }

{------------------------------------}

  TAbsCustomer3 = Class(TAbsCustomer2)
  Protected
     Function GetUserDef5 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef5 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef6 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef6 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef7 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef7 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef8 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef8 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef9 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef9 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef10 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef10 (Value : cuStr30); Virtual; Abstract;
  Public
{74} Property acUserDef5 : cuStr30 Read GetUserDef5 Write SetUserDef5;
{75} Property acUserDef6 : cuStr30 Read GetUserDef6 Write SetUserDef6;
{76} Property acUserDef7 : cuStr30 Read GetUserDef7 Write SetUserDef7;
{77} Property acUserDef8 : cuStr30 Read GetUserDef8 Write SetUserDef8;
{79} Property acUserDef9 : cuStr30 Read GetUserDef9 Write SetUserDef9;
{80} Property acUserDef10 : cuStr30 Read GetUserDef10 Write SetUserDef10;
  End; { TAbsCustomer3 }

{-----------------------------------------------------------------------------}
  TAbsCustomer4 = Class(TAbsCustomer3)
  Protected
    function GetBankAccountCode: cuStr35; Virtual; Abstract;
    function GetMandateDate: cuStr8; Virtual; Abstract;
    function GetMandateID: cuStr35; Virtual; Abstract;
    function GetBankSortCode: cuStr11; Virtual; Abstract;
    procedure SetBankAccountCode(const Value: cuStr35); Virtual; Abstract;
    procedure SetMandateDate(const Value: cuStr8); Virtual; Abstract;
    procedure SetMandateID(const Value: cuStr35); Virtual; Abstract;
    procedure SetBankSortCode(const Value: cuStr11); Virtual; Abstract;
  Public
{32} property acBankSortCode : cuStr11 read GetBankSortCode write SetBankSortCode;
{33} property acBankAccountCode : cuStr35 read GetBankAccountCode write SetBankAccountCode;
{81} property acMandateID : cuStr35 read GetMandateID write SetMandateID;
{82} property acMandateDate : cuStr8 read GetMandateDate write SetMandateDate;
  End; { TAbsCustomer4 }

{------------------------------------}

  // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
  TAbsCustomer5 = Class(TAbsCustomer4)
  Protected
    Function GetDeliveryPostCode : cuStr20; Virtual; Abstract;
    Procedure SetDeliveryPostCode (value : cuStr20); Virtual; Abstract;
  Public
{83} property acDeliveryPostCode : cuStr20 read GetDeliveryPostCode write SetDeliveryPostCode;
  End; // TAbsCustomer5

{------------------------------------}

  // MH 30/09/2013 MRD Branch for v7.0.8: Added new fields for Consumer Ledger and Auto-Receipt
  TAbsCustomer6 = Class(TAbsCustomer5)
  Protected
    Function GetSubType : Char; Virtual; Abstract;
    Function GetLongACCode : custr30; Virtual; Abstract;
    Procedure SetLongACCode(Value : custr30); Virtual; Abstract;
  Public
{84} property acSubType : Char read GetSubType;
{85} property acLongACCode : custr30 read GetLongACCode write SetLongACCode;
  End; // TAbsCustomer6

//------------------------------

  TCustomerPPDMode = ( pmPPDDisabled = 0,
                       pmPPDEnabledWithAutoJournalCreditNote = 1,
                       pmPPDEnabledWithAutoCreditNote = 2,
                       pmPPDEnabledWithManualCreditNote = 3 );

  // MH 06/05/2015 v7.0.14: Added new PPD field
  TAbsCustomer7 = Class(TAbsCustomer6)
  Protected
    Function GetPPDMode : TCustomerPPDMode; Virtual; Abstract;
    Procedure SetPPDMode(Value : TCustomerPPDMode); Virtual; Abstract;
  Public
{86} property acPPDMode : TCustomerPPDMode read GetPPDMode Write SetPPDMode;
  End; // TAbsCustomer7

//------------------------------

  // MH 22/09/2014 Order Payments
  // MH 26/11/2014 ISO Country Codes
  TAbsCustomer8 = Class(TAbsCustomer7)
  Protected
    Function GetAllowOrderPayments : Boolean; Virtual; Abstract;
    Procedure SetAllowOrderPayments (Value : Boolean); Virtual; Abstract;
    Function GetOrderPaymentsGLCode : LongInt; Virtual; Abstract;
    Procedure SetOrderPaymentsGLCode (Value : LongInt); Virtual; Abstract;
    Function GetCountry : cuStr2; Virtual; Abstract;
    Procedure SetCountry (Value : cuStr2); Virtual; Abstract;
    Function GetDeliveryCountry : cuStr2; Virtual; Abstract;
    Procedure SetDeliveryCountry (Value : cuStr2); Virtual; Abstract;
  Public
{87} property acAllowOrderPayments : Boolean read GetAllowOrderPayments Write SetAllowOrderPayments;
{88} property acOrderPaymentsGLCode : LongInt read GetOrderPaymentsGLCode Write SetOrderPaymentsGLCode;
{89} property acCountry : cuStr2 read GetCountry Write SetCountry;
{90} property acDeliveryCountry : cuStr2 read GetDeliveryCountry Write SetDeliveryCountry;
  End; // TAbsCustomer8

//------------------------------

  // MH 20/01/2016 Exch2016-R1: Intrastat enhancements
  TAbsCustomer9 = Class(TAbsCustomer8)
  Protected
    Function GetDefaultToQR : Boolean; Virtual; Abstract;
    Procedure SetDefaultToQR (Value : Boolean); Virtual; Abstract;
  Public
{91} property acDefaultToQR : Boolean read GetDefaultToQR Write SetDefaultToQR;
  End; // TAbsCustomer9

//------------------------------

  //RB 21/11/2017 2018-R1 ABSEXCH-19390: GDPR (POST 19346) - 8.3.1.1.1 - DLL + COM Customisation Support
  TCustomerAnonymisationStatus = (asNotRequested = 0,
                                  asPending = 1,
                                  asAnonymised = 2);
  TAbsCustomer10 = Class(TAbsCustomer9)
  Protected
    Function GetAnonymisationStatus : TCustomerAnonymisationStatus; Virtual; Abstract;
    Procedure SetAnonymisationStatus(aValue: TCustomerAnonymisationStatus); Virtual; Abstract;
    Function GetAnonymisedDate : cuStr8; Virtual; Abstract;
    Procedure SetAnonymisedDate(aValue: cuStr8); Virtual; Abstract;
    Function GetAnonymisedTime : cuStr6; Virtual; Abstract;
    Procedure SetAnonymisedTime(aValue: cuStr6); Virtual; Abstract;
  Public
{92} property acAnonymisationStatus : TCustomerAnonymisationStatus read GetAnonymisationStatus write SetAnonymisationStatus;
{93} property acAnonymisedDate : cuStr8 read GetAnonymisedDate write SetAnonymisedDate;
{94} property acAnonymisedTime : cuStr6 read GetAnonymisedTime write SetAnonymisedTime;
  End; // TAbsCustomer10

{------------------------------------}

  { Abstract Transaction Line Interface - used by TAbsInvoiceLines }
  TAbsInvLine = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetFolioRef : LongInt; Virtual; Abstract;
    Procedure SetFolioRef(Value : LongInt); Virtual; Abstract;
    Function  GetLineNo : LongInt; Virtual; Abstract;
    Procedure SetLineNo(Value : LongInt); Virtual; Abstract;
    Function  GetPostedRun : LongInt; Virtual; Abstract;
    Procedure SetPostedRun(Value : LongInt); Virtual; Abstract;
    Function  GetNomCode : LongInt; Virtual; Abstract;
    Procedure SetNomCode(Value : LongInt); Virtual; Abstract;
    Function  GetNomMode : Byte; Virtual; Abstract;
    Procedure SetNomMode(Value : Byte); Virtual; Abstract;
    Function  GetCurrency : Byte; Virtual; Abstract;
    Procedure SetCurrency(Value : Byte); Virtual; Abstract;
    Function  GetPYr : Byte; Virtual; Abstract;
    Function  GetPPr : Byte; Virtual; Abstract;
    Function  GetCCDep1 : cuStr3; Virtual; Abstract;
    Procedure SetCCDep1(Value : cuStr3); Virtual; Abstract;
    Function  GetCCDep2 : cuStr3; Virtual; Abstract;
    Procedure SetCCDep2(Value : cuStr3); Virtual; Abstract;
    Function  GetStockCode : cuStr16; Virtual; Abstract;
    Procedure SetStockCode(Value : cuStr16); Virtual; Abstract;
    Function  GetABSLineNo : LongInt; Virtual; Abstract;
    Procedure SetABSLineNo(Value : LongInt); Virtual; Abstract;
    Function  GetLineType : Char; Virtual; Abstract;
    Function  GetIdDocHed : cuDocTypes; Virtual; Abstract;
    Function  GetQty : Real; Virtual; Abstract;
    Procedure SetQty(Value : Real); Virtual; Abstract;
    Function  GetQtyMul : Real; Virtual; Abstract;
    Procedure SetQtyMul(Value : Real); Virtual; Abstract;
    Function  GetNetValue : Real; Virtual; Abstract;
    Procedure SetNetValue(Value : Real); Virtual; Abstract;
    Function  GetDiscount : Real; Virtual; Abstract;
    Procedure SetDiscount(Value : Real); Virtual; Abstract;
    Function  GetVATCode : Char; Virtual; Abstract;
    Procedure SetVATCode(Value : Char); Virtual; Abstract;
    Function  GetVAT : Real; Virtual; Abstract;
    Procedure SetVAT(Value : Real); Virtual; Abstract;
    Function  GetPayment : Char; Virtual; Abstract;
    Procedure SetPayment(Value : Char); Virtual; Abstract;
    Function  GetPreviousBal : Real; Virtual; Abstract;
    Procedure SetPreviousBal(Value : Real); Virtual; Abstract;
    Function  GetReconcile : Byte; Virtual; Abstract;
    Procedure SetReconcile(Value : Byte); Virtual; Abstract;
    Function  GetDiscountChr : Char; Virtual; Abstract;
    Procedure SetDiscountChr(Value : Char); Virtual; Abstract;
    Function  GetQtyWOFF : Real; Virtual; Abstract;
    Procedure SetQtyWOFF(Value : Real); Virtual; Abstract;
    Function  GetQtyDel : Real; Virtual; Abstract;
    Procedure SetQtyDel(Value : Real); Virtual; Abstract;
    Function  GetCostPrice : Real; Virtual; Abstract;
    Procedure SetCostPrice(Value : Real); Virtual; Abstract;
    Function  GetCustCode : cuStr10; Virtual; Abstract;
    Function  GetPDate : cuLongDate; Virtual; Abstract;
    Procedure SetPDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetItem : cuStr3; Virtual; Abstract;

    Procedure SetItem(Value : cuStr3); Virtual; Abstract;
    Function  GetDesc : cuStr60; Virtual; Abstract;
    Procedure SetDesc(Value : cuStr60); Virtual; Abstract;
    Function  GetJobCode : cuStr10; Virtual; Abstract;
    Procedure SetJobCode(Value : cuStr10); Virtual; Abstract;
    Function  GetAnalCode : cuStr10; Virtual; Abstract;
    Procedure SetAnalCode(Value : cuStr10); Virtual; Abstract;
    Function  GetCXrate1 : Real; Virtual; Abstract;
    Procedure SetCXrate1(Value : Real); Virtual; Abstract;
    Function  GetCXrate2 : Real; Virtual; Abstract;
    Procedure SetCXrate2(Value : Real); Virtual; Abstract;
    Function  GetLWeight : Real; Virtual; Abstract;
    Procedure SetLWeight(Value : Real); Virtual; Abstract;
    Function  GetDeductQty : Real; Virtual; Abstract;
    Procedure SetDeductQty(Value : Real); Virtual; Abstract;
    Function  GetKitLink : LongInt; Virtual; Abstract;
    Procedure SetKitLink(Value : LongInt); Virtual; Abstract;
    Function  GetSOPLink : LongInt; Virtual; Abstract;
    Procedure SetSOPLink(Value : LongInt); Virtual; Abstract;
    Function  GetSOPLineNo : LongInt; Virtual; Abstract;
    Procedure SetSOPLineNo(Value : LongInt); Virtual; Abstract;
    Function  GetMLocStk : cuStr3; Virtual; Abstract;
    Procedure SetMLocStk(Value : cuStr3); Virtual; Abstract;
    Function  GetQtyPick : Real; Virtual; Abstract;
    Procedure SetQtyPick(Value : Real); Virtual; Abstract;
    Function  GetQtyPWOff : Real; Virtual; Abstract;
    Procedure SetQtyPWOff(Value : Real); Virtual; Abstract;
    Function  GetUsePack : Boolean; Virtual; Abstract;
    Procedure SetUsePack(Value : Boolean); Virtual; Abstract;
    Function  GetSerialQty : Real; Virtual; Abstract;
    Procedure SetSerialQty(Value : Real); Virtual; Abstract;
    Function  GetCOSNomCode : LongInt; Virtual; Abstract;
    Procedure SetCOSNomCode(Value : LongInt); Virtual; Abstract;
    Function  GetDocPRef : cuStr10; Virtual; Abstract;
    Function  GetDocLTLink : cuLineTIndex; Virtual; Abstract;
    Procedure SetDocLTLink(Value : cuLineTIndex); Virtual; Abstract;
    Function  GetPrxPack : Boolean; Virtual; Abstract;
    Procedure SetPrxPack(Value : Boolean); Virtual; Abstract;
    Function  GetQtyPack : Double; Virtual; Abstract;
    Procedure SetQtyPack(Value : Double); Virtual; Abstract;
    Function  GetReconDate : cuLongDate; Virtual; Abstract;
    Procedure SetReconDate(Value : cuLongDate); Virtual; Abstract;

    Function  GetUserDef1 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef1(Value : cuStr30); Virtual; Abstract;
    Function  GetUserDef2 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef2(Value : cuStr30); Virtual; Abstract;
    Function  GetUserDef3 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef3(Value : cuStr30); Virtual; Abstract;
    Function  GetUserDef4 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef4(Value : cuStr30); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

    Function entInvLTotal(UseDisc    :  Boolean;
                          SetlDisc   :  Double)  :  Double; Virtual; Abstract;

    Procedure Delete; Virtual; Abstract;
    Procedure Save;   Virtual; Abstract;

    Function  LinkToStock : Boolean; Virtual; Abstract;

{01} Property tlFolio : LongInt Read GetFolioRef Write SetFolioRef;
{02} Property tlLinePos : LongInt Read GetLineNo Write SetLineNo;
{03} Property tlRunNo : LongInt Read GetPostedRun Write SetPostedRun;
{04} Property tlGLCode : LongInt Read GetNomCode Write SetNomCode;
{05} Property tlShowInGL : Byte Read GetNomMode Write SetNomMode;
{06} Property tlCurrency : Byte Read GetCurrency Write SetCurrency;
{07} Property tlYear : Byte Read GetPYr;
{08} Property tlPeriod : Byte Read GetPPr;
{09} Property tlCostCentre : cuStr3 Read GetCCDep1 Write SetCCDep1;
{10} Property tlDepartment : cuStr3 Read GetCCDep2 Write SetCCDep2;
{11} Property tlStockCode : cuStr16 Read GetStockCode Write SetStockCode;
{12} Property tlLineNo : LongInt Read GetABSLineNo Write SetABSLineNo;
{13} Property tlLineClass : Char Read GetLineType;
{14} Property tlDocType : cuDocTypes Read GetIdDocHed;
{16} Property tlQty : Real Read GetQty Write SetQty;
{17} Property tlQtyMul : Real Read GetQtyMul Write SetQtyMul;
{18} Property tlNetValue : Real Read GetNetValue Write SetNetValue;
{19} Property tlDiscount : Real Read GetDiscount Write SetDiscount;
{20} Property tlVATCode : Char Read GetVATCode Write SetVATCode;
{21} Property tlVATAmount : Real Read GetVAT Write SetVAT;
{22} Property tlPayStatus : Char Read GetPayment Write SetPayment;
{23} Property tlPrevGLBal : Real Read GetPreviousBal Write SetPreviousBal;
{24} Property tlRecStatus : Byte Read GetReconcile Write SetReconcile;
{25} Property tlDiscFlag : Char Read GetDiscountChr Write SetDiscountChr;
{26} Property tlQtyWOFF : Real Read GetQtyWOFF Write SetQtyWOFF;
{27} Property tlQtyDel : Real Read GetQtyDel Write SetQtyDel;

{28} Property tlCost : Real Read GetCostPrice Write SetCostPrice;
{29} Property tlAcCode : cuStr10 Read GetCustCode;
{30} Property tlTransDate : cuLongDate Read GetPDate Write SetPDate;
{31} Property tlItemNo : cuStr3 Read GetItem Write SetItem;
{32} Property tlDescr : cuStr60 Read GetDesc Write SetDesc;
{33} Property tlJobCode : cuStr10 Read GetJobCode Write SetJobCode;
{34} Property tlJobAnal : cuStr10 Read GetAnalCode Write SetAnalCode;
{35} Property tlCompanyRate : Real Read GetCXrate1 Write SetCXrate1;
{36} Property tlDailyRate : Real Read GetCXrate2 Write SetCXrate2;
{37} Property tlUnitWeight : Real Read GetLWeight Write SetLWeight;
{38} Property tlStockDeductQty : Real Read GetDeductQty Write SetDeductQty;
{39} Property tlBOMKitLink : LongInt Read GetKitLink Write SetKitLink;
{40} Property tlOrderFolio : LongInt Read GetSOPLink Write SetSOPLink;
{41} Property tlOrderLineNo : LongInt Read GetSOPLineNo Write SetSOPLineNo;
{42} Property tlLocation : cuStr3 Read GetMLocStk Write SetMLocStk;
{43} Property tlQtyPicked : Real Read GetQtyPick Write SetQtyPick;
{44} Property tlQtyPickedWO : Real Read GetQtyPWOff Write SetQtyPWOff;
{45} Property tlUseQtyMul : Boolean Read GetUsePack Write SetUsePack;
{46} Property tlNoSerialNos : Real Read GetSerialQty Write SetSerialQty;
{47} Property tlCOSGL : LongInt Read GetCOSNomCode Write SetCOSNomCode;
{48} Property tlOurRef : cuStr10 Read GetDocPRef;
{49} Property tlLineType : cuLineTIndex Read GetDocLTLink Write SetDocLTLink;
{50} Property tlPriceByPack : Boolean Read GetPrxPack Write SetPrxPack;
{51} Property tlQtyInPack : Double Read GetQtyPack Write SetQtyPack;
{52} Property tlClearDate : cuLongDate Read GetReconDate Write SetReconDate;

     { v4.31 Fields }
{53} Property tlUserDef1 : cuStr30 Read GetUserDef1 Write SetUserDef1;
{54} Property tlUserDef2 : cuStr30 Read GetUserDef2 Write SetUserDef2;
{55} Property tlUserDef3 : cuStr30 Read GetUserDef3 Write SetUserDef3;
{56} Property tlUserDef4 : cuStr30 Read GetUserDef4 Write SetUserDef4;
  End; { TAbsInvLine }

  //------------------------------

  { v5.50 20/02/03 - Descendant of Abstract Transaction Line Object for new v5.50 Fields }
  TAbsInvLine2 = Class(TAbsInvLine)
  Protected
    Function  GetLineSource : Byte; Virtual; Abstract;
    Procedure SetLineSource(Value : Byte); Virtual; Abstract;
    Function  GetCISRateCode : Char; Virtual; Abstract;
    Procedure SetCISRateCode(Value : Char); Virtual; Abstract;
    Function  GetCISRate : Double; Virtual; Abstract;
    Procedure SetCISRate(Value : Double); Virtual; Abstract;
    Function  GetCostApport : Double; Virtual; Abstract;
    Procedure SetCostApport(Value : Double); Virtual; Abstract;
    Function  GetVATInclValue : Double; Virtual; Abstract;
    Procedure SetVATInclValue(Value : Double); Virtual; Abstract;
  Public
{57} Property tlLineSource : Byte Read GetLineSource Write SetLineSource;
{58} Property tlCISRateCode : Char Read GetCISRateCode Write SetCISRateCode;
{59} Property tlCISRate : Double Read GetCISRate Write SetCISRate;
{60} Property tlCostApport : Double Read GetCostApport Write SetCostApport;
{61} Property tlVATInclValue : Double Read GetVATInclValue Write SetVATInclValue;
  End; { TAbsInvLine2 }

  //------------------------------

  { v5.51 04/06/03 - Descendant of Abstract Transaction Line Object for new v5.51 Fields }
  TAbsInvLine3 = Class(TAbsInvLine2)
  Protected
    Function  GetNOMVATType : cuNOMLineVatType; Virtual; Abstract;
    Procedure SetNOMVATType(Value : cuNOMLineVatType); Virtual; Abstract;
  Public
{62} Property tlNOMVATType : cuNOMLineVatType Read GetNOMVATType Write SetNOMVATType;
  End; { TAbsInvLine3 }

  //------------------------------

  { v5.60 23/03/04 - Descendant of Abstract Transaction Line Object for new v5.60 Fields }
  TAbsInvLine4 = Class(TAbsInvLine3)
  Protected
    Function  GetCISAdjustments : Double; Virtual; Abstract;
    Procedure SetCISAdjustments(Value : Double); Virtual; Abstract;
    Function  GetAppsDeductType : Byte; Virtual; Abstract;
    Procedure SetAppsDeductType(Value : Byte); Virtual; Abstract;
  Public
{63} Property tlCISAdjustments : Double Read GetCISAdjustments Write SetCISAdjustments;
{64} Property tlAppsDeductType : Byte Read GetAppsDeductType Write SetAppsDeductType;
  End; { TAbsInvLine4 }

  //------------------------------

  // v5.70 - 22/07/05 - Added Goods Returns fields
  TAbsInvLine5 = Class(TAbsInvLine4)
  Protected
    Function GetSerialReturnQty : Double; Virtual; Abstract;
    Procedure SetSerialReturnQty (Value : Double); Virtual; Abstract;
    Function GetBinReturnQty : Double; Virtual; Abstract;
    Procedure SetBinReturnQty (Value : Double); Virtual; Abstract;
  Public
{65} Property tlSerialReturnQty : Double Read GetSerialReturnQty Write SetSerialReturnQty;
{66} Property tlBinReturnQty : Double Read GetBinReturnQty Write SetBinReturnQty;
  End; // TAbsInvLine5

  //------------------------------

  // v6.01 - 08/05/09 - Added Advanced Discounts fields
  TAbsInvLine6 = Class(TAbsInvLine5)
  Protected
    Function GetMultiBuyDiscount : Double; Virtual; Abstract;
    Procedure SetMultiBuyDiscount (Value : Double); Virtual; Abstract;
    Function GetMultiBuyDiscountFlag : Char; Virtual; Abstract;
    Procedure SetMultiBuyDiscountFlag (Value : Char); Virtual; Abstract;
    Function GetTransValueDiscount : Double; Virtual; Abstract;
    Procedure SetTransValueDiscount (Value : Double); Virtual; Abstract;
    Function GetTransValueDiscountFlag : Char; Virtual; Abstract;
    Procedure SetTransValueDiscountFlag (Value : Char); Virtual; Abstract;
    Function GetTransValueDiscountType : Byte; Virtual; Abstract;
    Procedure SetTransValueDiscountType (Value : Byte); Virtual; Abstract;
  Public
{67} Property tlMultiBuyDiscount : Double Read GetMultiBuyDiscount Write SetMultiBuyDiscount;
{68} Property tlMultiBuyDiscountFlag : Char Read GetMultiBuyDiscountFlag Write SetMultiBuyDiscountFlag;
{69} Property tlTransValueDiscount : Double Read GetTransValueDiscount Write SetTransValueDiscount;
{70} Property tlTransValueDiscountFlag : Char Read GetTransValueDiscountFlag Write SetTransValueDiscountFlag;
{71} Property tlTransValueDiscountType : Byte Read GetTransValueDiscountType Write SetTransValueDiscountType;

     // Calculates the line discount for the line including any Transaction Total, Value Based or Multi-Buy Discounts
     Function entCalcLineDiscount(SettlementDiscount : Double; SettlementDiscountType : Char) : Double; Virtual; Abstract;
  End; // TAbsInvLine6

  //------------------------------

  // v6.2 - 20/08/09 - Added new fields for EC Services support
  TAbsInvLine7 = Class(TAbsInvLine6)
  Protected
    Function GetECService : Boolean; Virtual; Abstract;
    Procedure SetECService (Value : Boolean); Virtual; Abstract;
    Function GetServiceStartDate : cuLongDate; Virtual; Abstract;
    Procedure SetServiceStartDate (Value : cuLongDate); Virtual; Abstract;
    Function GetServiceEndDate : cuLongDate; Virtual; Abstract;
    Procedure SetServiceEndDate (Value : cuLongDate); Virtual; Abstract;
    Function GetECSalesTaxReported : Double; Virtual; Abstract;
    Procedure SetECSalesTaxReported (Value : Double); Virtual; Abstract;
    Function GetPurchaseServiceTax : Double; Virtual; Abstract;
    Procedure SetPurchaseServiceTax (Value : Double); Virtual; Abstract;
  Public
{72} Property tlECService : Boolean Read GetECService Write SetECService;
{73} Property tlServiceStartDate : cuLongDate Read GetServiceStartDate Write SetServiceStartDate;
{74} Property tlServiceEndDate : cuLongDate Read GetServiceEndDate Write SetServiceEndDate;
{75} Property tlECSalesTaxReported : Double Read GetECSalesTaxReported Write SetECSalesTaxReported;
{76} Property tlPurchaseServiceTax : Double Read GetPurchaseServiceTax Write SetPurchaseServiceTax;
  End; // TAbsInvLine7

  //------------------------------

  // v6.3 - 02/02/10 - Added new fields for Web Extensions
  TAbsInvLine8 = Class(TAbsInvLine7)
  Protected
    Function GetReference : cuStr20; Virtual; Abstract;
    Procedure SetReference (Value : cuStr20); Virtual; Abstract;
    Function GetReceiptNo : cuStr20; Virtual; Abstract;
    Procedure SetReceiptNo (Value : cuStr20); Virtual; Abstract;
    Function GetFromPostCode : cuStr15; Virtual; Abstract;
    Procedure SetFromPostCode (Value : cuStr15); Virtual; Abstract;
    Function GetToPostCode : cuStr15; Virtual; Abstract;
    Procedure SetToPostCode (Value : cuStr15); Virtual; Abstract;
  Public
{77} Property tlReference : cuStr20 Read GetReference Write SetReference;
{78} Property tlReceiptNo : cuStr20 Read GetReceiptNo Write SetReceiptNo;
{79} Property tlFromPostCode : cuStr15 Read GetFromPostCode Write SetFromPostCode;
{80} Property tlToPostCode : cuStr15 Read GetToPostCode Write SetToPostCode;
  End; // TAbsInvLine8

  //------------------------------

  // v6.9 30/09/2011
  TAbsInvLine9 = Class(TAbsInvLine8)
  Protected
     Function GetUserDef5 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef5 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef6 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef6 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef7 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef7 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef8 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef8 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef9 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef9 (Value : cuStr30); Virtual; Abstract;
     Function GetUserDef10 : cuStr30; Virtual; Abstract;
     Procedure SetUserDef10 (Value : cuStr30); Virtual; Abstract;
  Public
{81} Property tlUserDef5 : cuStr30 Read GetUserDef5 Write SetUserDef5;
{82} Property tlUserDef6 : cuStr30 Read GetUserDef6 Write SetUserDef6;
{83} Property tlUserDef7 : cuStr30 Read GetUserDef7 Write SetUserDef7;
{84} Property tlUserDef8 : cuStr30 Read GetUserDef8 Write SetUserDef8;
{85} Property tlUserDef9 : cuStr30 Read GetUserDef9 Write SetUserDef9;
{86} Property tlUserDef10 : cuStr30 Read GetUserDef10 Write SetUserDef10;
  End; // TAbsInvLine9

  //------------------------------

  // MH 20/01/2016 Exch2016-R1: Intrastat enhancements
  TAbsInvLine10 = Class(TAbsInvLine9)
  Protected
    Function GetIntrastatOverride : Boolean; Virtual; Abstract;
    Procedure SetIntrastatOverride (Value : Boolean); Virtual; Abstract;
    Function GetIntrastatCommodityCode : cuStr10; Virtual; Abstract;
    Procedure SetIntrastatCommodityCode (Value : cuStr10); Virtual; Abstract;
    Function GetIntrastatStockUnits : Double; Virtual; Abstract;
    Procedure SetIntrastatStockUnits (Value : Double); Virtual; Abstract;
    Function GetIntrastatCountry : cuStr2; Virtual; Abstract;
    Procedure SetIntrastatCountry (Value : cuStr2); Virtual; Abstract;
    Function GetIntrastatNoTC : cuStr2; Virtual; Abstract;
    Procedure SetIntrastatNoTC (Value : cuStr2); Virtual; Abstract;
    Function GetIntrastatUplift : Double; Virtual; Abstract;
    Procedure SetIntrastatUplift (Value : Double); Virtual; Abstract;
  Public
{87} Property tlIntrastatOverride : Boolean Read GetIntrastatOverride Write SetIntrastatOverride;
{88} Property tlIntrastatCommodityCode : cuStr10 Read GetIntrastatCommodityCode Write SetIntrastatCommodityCode;
{89} Property tlIntrastatStockUnits : Double Read GetIntrastatStockUnits Write SetIntrastatStockUnits;
{90} Property tlIntrastatCountry : cuStr2 Read GetIntrastatCountry Write SetIntrastatCountry;
{91} Property tlIntrastatNoTC : cuStr2 Read GetIntrastatNoTC Write SetIntrastatNoTC;
{92} Property tlIntrastatUplift : Double Read GetIntrastatUplift Write SetIntrastatUplift;
  End; // TAbsInvLine9

{-----------------------------------------------------------------------------}

  { Abstract Transaction Lines Interface - used by TAbsInvoice }
  TAbsInvoiceLines = Class(TObject)
  Protected
    Function  GetLineCount : SmallInt; Virtual; Abstract;
    Function  GetInvLine(Index : SmallInt) : TAbsInvLine; Virtual; Abstract;
    Function  GetCurrentLine : TAbsInvLine; Virtual; Abstract;
  Public
    Property thLineCount : SmallInt Read GetLineCount;
    Property thLine[Index : SmallInt] : TAbsInvLine Read GetInvLine;
    Property thCurrentLine : TAbsInvLine Read GetCurrentLine;

    Procedure AddNewLine; Virtual; Abstract;
  End; { TAbsInvoiceLines }

{-----------------------------------------------------------------------------}

  { Abstract Transaction Object Interface - used by TAbsEnterpriseSystem }
  TAbsInvoice = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetRunNo : Longint; Virtual; Abstract;
    Procedure SetRunNo(Value : Longint); Virtual; Abstract;
    Function  GetCustCode : cuStr10; Virtual; Abstract;
    Procedure SetCustCode(Value : cuStr10); Virtual; Abstract;
    Function  GetNomAuto : Boolean; Virtual; Abstract;
    Procedure SetNomAuto(Value : Boolean); Virtual; Abstract;
    Function  GetOurRef : cuStr10; Virtual; Abstract;
    Procedure SetOurRef(Value : cuStr10); Virtual; Abstract;
    Function  GetFolioNum : Longint; Virtual; Abstract;
    Procedure SetFolioNum(Value : Longint); Virtual; Abstract;
    Function  GetCurrency : Byte; Virtual; Abstract;
    Procedure SetCurrency(Value : Byte); Virtual; Abstract;
    Function  GetAcYr : Byte; Virtual; Abstract;
    Procedure SetAcYr(Value : Byte); Virtual; Abstract;
    Function  GetAcPr : Byte; Virtual; Abstract;
    Procedure SetAcPr(Value : Byte); Virtual; Abstract;
    Function  GetDueDate : cuLongDate; Virtual; Abstract;
    Procedure SetDueDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetVATPostDate : cuLongDate; Virtual; Abstract;
    Procedure SetVATPostDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetTransDate : cuLongDate; Virtual; Abstract;
    Procedure SetTransDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetCustSupp : Char; Virtual; Abstract;
    Function  GetCXrate1 : Real; Virtual; Abstract;
    Procedure SetCXrate1(Value : Real); Virtual; Abstract;
    Function  GetCXrate2 : Real; Virtual; Abstract;
    Procedure SetCXrate2(Value : Real); Virtual; Abstract;
    Function  GetYourRef : cuStr10; Virtual; Abstract;
    Procedure SetYourRef(Value : cuStr10); Virtual; Abstract;
    Function  GetBatchLink : cuStr12; Virtual; Abstract;
    Procedure SetBatchLink(Value : cuStr12); Virtual; Abstract;
    Function  GetAllocStat : Char; Virtual; Abstract;
    Procedure SetAllocStat(Value : Char); Virtual; Abstract;
    Function  GetInvDocHed : cuDocTypes; Virtual; Abstract;
    Procedure SetInvDocHed(Value : cuDocTypes); Virtual; Abstract;
    Function  GetInvVatAnal (Index : cuVATIndex) : Real; Virtual; Abstract;
    Procedure SetInvVatAnal(Index : cuVATIndex; Value : Real); Virtual; Abstract;
    Function  GetInvNetVal : Real; Virtual; Abstract;
    Function  GetInvVat : Real; Virtual; Abstract;
    Function  GetDiscSetl : Real; Virtual; Abstract;
    Procedure SetDiscSetl(Value : Real); Virtual; Abstract;
    Function  GetDiscSetAm : Real; Virtual; Abstract;
    Procedure SetDiscSetAm(Value : Real); Virtual; Abstract;
    Function  GetDiscAmount : Real; Virtual; Abstract;
    Procedure SetDiscAmount(Value : Real); Virtual; Abstract;
    Function  GetDiscDays : SmallInt; Virtual; Abstract;
    Procedure SetDiscDays(Value : SmallInt); Virtual; Abstract;
    Function  GetDiscTaken : Boolean; Virtual; Abstract;
    Procedure SetDiscTaken(Value : Boolean); Virtual; Abstract;
    Function  GetSettled : Real; Virtual; Abstract;
    Procedure SetSettled(Value : Real); Virtual; Abstract;
    Function  GetAutoInc : SmallInt; Virtual; Abstract;
    Procedure SetAutoInc(Value : SmallInt); Virtual; Abstract;
    Function  GetUnYr : Byte; Virtual; Abstract;
    Procedure SetUnYr(Value : Byte); Virtual; Abstract;
    Function  GetUnPr : Byte; Virtual; Abstract;
    Procedure SetUnPr(Value : Byte); Virtual; Abstract;
    Function  GetTransNat : Byte; Virtual; Abstract;
    Procedure SetTransNat(Value : Byte); Virtual; Abstract;
    Function  GetTransMode : Byte; Virtual; Abstract;
    Procedure SetTransMode(Value : Byte); Virtual; Abstract;
    Function  GetRemitNo : cuStr10; Virtual; Abstract;
    Procedure SetRemitNo(Value : cuStr10); Virtual; Abstract;
    Function  GetAutoIncBy : Char; Virtual; Abstract;
    Procedure SetAutoIncBy(Value : Char); Virtual; Abstract;
    Function  GetHoldFlg : Byte; Virtual; Abstract;
    Procedure SetHoldFlg(Value : Byte); Virtual; Abstract;
    Function  GetAuditFlg : Boolean; Virtual; Abstract;
    Procedure SetAuditFlg(Value : Boolean); Virtual; Abstract;
    Function  GetTotalWeight : Real; Virtual; Abstract;
    Procedure SetTotalWeight(Value : Real); Virtual; Abstract;
    Function  GetDAddr (Index : cuAddrIndex) : cuStr30; Virtual; Abstract;
    Procedure SetDAddr(Index : cuAddrIndex; Value : cuStr30); Virtual; Abstract;
    Function  GetVariance : Real; Virtual; Abstract;
    Procedure SetVariance(Value : Real); Virtual; Abstract;
    Function  GetTotalOrdered : Real; Virtual; Abstract;
    Procedure SetTotalOrdered(Value : Real); Virtual; Abstract;
    Function  GetTotalReserved : Real; Virtual; Abstract;
    Procedure SetTotalReserved(Value : Real); Virtual; Abstract;
    Function  GetTotalCost : Real; Virtual; Abstract;
    Procedure SetTotalCost(Value : Real); Virtual; Abstract;
    Function  GetTotalInvoiced : Real; Virtual; Abstract;
    Procedure SetTotalInvoiced(Value : Real); Virtual; Abstract;
    Function  GetTransDesc : cuStr20; Virtual; Abstract;
    Procedure SetTransDesc(Value : cuStr20); Virtual; Abstract;
    Function  GetUntilDate : cuLongDate; Virtual; Abstract;
    Procedure SetUntilDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetExternalDoc : Boolean; Virtual; Abstract;
    Procedure SetExternalDoc(Value : Boolean); Virtual; Abstract;
    Function  GetPrintedDoc : Boolean; Virtual; Abstract;
    Procedure SetPrintedDoc(Value : Boolean); Virtual; Abstract;
    Function  GetReValueAdj : Real; Virtual; Abstract;
    Procedure SetReValueAdj(Value : Real); Virtual; Abstract;
    Function  GetCurrSettled : Real; Virtual; Abstract;
    Procedure SetCurrSettled(Value : Real); Virtual; Abstract;
    Function  GetSettledVAT : Real; Virtual; Abstract;
    Procedure SetSettledVAT(Value : Real); Virtual; Abstract;
    Function  GetVATClaimed : Real; Virtual; Abstract;
    Procedure SetVATClaimed(Value : Real); Virtual; Abstract;
    Function  GetBatchNom : LongInt; Virtual; Abstract;
    Procedure SetBatchNom(Value : LongInt); Virtual; Abstract;
    Function  GetAutoPost : Boolean; Virtual; Abstract;
    Procedure SetAutoPost(Value : Boolean); Virtual; Abstract;
    Function  GetManVAT : Boolean; Virtual; Abstract;
    Procedure SetManVAT(Value : Boolean); Virtual; Abstract;
    Function  GetDelTerms : cuStr3; Virtual; Abstract;
    Procedure SetDelTerms(Value : cuStr3); Virtual; Abstract;
    Function  GetOpName : cuStr10; Virtual; Abstract;
    Procedure SetOpName(Value : cuStr10); Virtual; Abstract;
    Function  GetNoLabels : SmallInt; Virtual; Abstract;
    Procedure SetNoLabels(Value : SmallInt); Virtual; Abstract;
    Function  GetTagged : Boolean; Virtual; Abstract;
    Procedure SetTagged(Value : Boolean); Virtual; Abstract;
    Function  GetPickRunNo : LongInt; Virtual; Abstract;
    Procedure SetPickRunNo(Value : LongInt); Virtual; Abstract;
    Function  GetOrdMatch : Boolean; Virtual; Abstract;
    Procedure SetOrdMatch(Value : Boolean); Virtual; Abstract;
    Function  GetDeliverRef : cuStr10; Virtual; Abstract;
    Procedure SetDeliverRef(Value : cuStr10); Virtual; Abstract;
    Function  GetVATCRate1 : Real; Virtual; Abstract;
    Procedure SetVATCRate1(Value : Real); Virtual; Abstract;
    Function  GetVATCRate2 : Real; Virtual; Abstract;
    Procedure SetVATCRate2(Value : Real); Virtual; Abstract;
    Function  GetOrigRates1 : Real; Virtual; Abstract;
    Procedure SetOrigRates1(Value : Real); Virtual; Abstract;
    Function  GetOrigRates2 : Real; Virtual; Abstract;
    Procedure SetOrigRates2(Value : Real); Virtual; Abstract;
    Function  GetPostDiscAm : Double; Virtual; Abstract;
    Procedure SetPostDiscAm(Value : Double); Virtual; Abstract;
    Function  GetPDiscTaken : Boolean; Virtual; Abstract;
    Procedure SetPDiscTaken(Value : Boolean); Virtual; Abstract;
    Function  GetCtrlNom : Longint; Virtual; Abstract;
    Procedure SetCtrlNom(Value : Longint); Virtual; Abstract;
    Function  GetDJobCode : cuStr10; Virtual; Abstract;
    Procedure SetDJobCode(Value : cuStr10); Virtual; Abstract;
    Function  GetDJobAnal : cuStr10; Virtual; Abstract;
    Procedure SetDJobAnal(Value : cuStr10); Virtual; Abstract;
    Function  GetTotOrdOS : Real; Virtual; Abstract;
    Procedure SetTotOrdOS(Value : Real); Virtual; Abstract;
    Function  GetDocUser1 : cuStr30; Virtual; Abstract;
    Procedure SetDocUser1(Value : cuStr30); Virtual; Abstract;
    Function  GetDocUser2 : cuStr30; Virtual; Abstract;
    Procedure SetDocUser2(Value : cuStr30); Virtual; Abstract;
    Function  GetDocLSplit (Index : cuLineIndex) : Double; Virtual; Abstract;
    Procedure SetDocLSplit(Index : cuLineIndex; Value : Double); Virtual; Abstract;
    Function  GetLastLetter : Byte; Virtual; Abstract;
    Procedure SetLastLetter(Value : Byte); Virtual; Abstract;
    Function  GetUnTagged : Boolean; Virtual; Abstract;
    Procedure SetUnTagged(Value : Boolean); Virtual; Abstract;
    Function  GetInvLines : TAbsInvoiceLines; Virtual; Abstract;

    Function  GetDocUser3 : cuStr30; Virtual; Abstract;
    Procedure SetDocUser3(Value : cuStr30); Virtual; Abstract;
    Function  GetDocUser4 : cuStr30; Virtual; Abstract;
    Procedure SetDocUser4(Value : cuStr30); Virtual; Abstract;

    Function  GetTagNo : Byte; Virtual; Abstract;
    Procedure SetTagNo(Value : Byte); Virtual; Abstract;
  Public
    Function  LinkToCust : Boolean; Virtual; Abstract;


    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property thRunNo : Longint Read GetRunNo Write SetRunNo;
{02} Property thAcCode : cuStr10 Read GetCustCode Write SetCustCode;
{03} Property thNomAuto : Boolean Read GetNomAuto Write SetNomAuto;
{04} Property thOurRef : cuStr10 Read GetOurRef Write SetOurRef;
{05} Property thFolioNum : Longint Read GetFolioNum Write SetFolioNum;
{06} Property thCurrency : Byte Read GetCurrency Write SetCurrency;
{07} Property thYear : Byte Read GetAcYr Write SetAcYr;
{08} Property thPeriod : Byte Read GetAcPr Write SetAcPr;
{09} Property thDueDate : cuLongDate Read GetDueDate Write SetDueDate;
{10} Property thVATPostDate : cuLongDate Read GetVATPostDate Write SetVATPostDate;
{11} Property thTransDate : cuLongDate Read GetTransDate Write SetTransDate;
{12} Property thCustSupp : Char Read GetCustSupp;
{13} Property thCompanyRate : Real Read GetCXrate1 Write SetCXrate1;
{14} Property thDailyRate : Real Read GetCXrate2 Write SetCXrate2;
{15} Property thYourRef : cuStr10 Read GetYourRef Write SetYourRef;
{16} Property thBatchLink : cuStr12 Read GetBatchLink Write SetBatchLink;
{17} Property thAllocStat : Char Read GetAllocStat Write SetAllocStat;
{18} Property thInvDocHed : cuDocTypes Read GetInvDocHed Write SetInvDocHed;
{19} Property thInvVatAnal[Index : cuVATIndex] : Real Read GetInvVatAnal Write SetInvVatAnal;
{20} Property thInvNetVal : Real Read GetInvNetVal;
{21} Property thInvVat : Real Read GetInvVat;
{22} Property thDiscSetl : Real Read GetDiscSetl Write SetDiscSetl;
{23} Property thDiscSetAm : Real Read GetDiscSetAm Write SetDiscSetAm;
{24} Property thDiscAmount : Real Read GetDiscAmount Write SetDiscAmount;
{25} Property thDiscDays : SmallInt Read GetDiscDays Write SetDiscDays;
{26} Property thDiscTaken : Boolean Read GetDiscTaken Write SetDiscTaken;
{27} Property thSettled : Real Read GetSettled Write SetSettled;
{28} Property thAutoInc : SmallInt Read GetAutoInc Write SetAutoInc;
{29} Property thNextAutoYr : Byte Read GetUnYr Write SetUnYr;
{30} Property thNextAutoPr : Byte Read GetUnPr Write SetUnPr;
{31} Property thTransNat : Byte Read GetTransNat Write SetTransNat;
{32} Property thTransMode : Byte Read GetTransMode Write SetTransMode;
{33} Property thRemitNo : cuStr10 Read GetRemitNo Write SetRemitNo;
{34} Property thAutoIncBy : Char Read GetAutoIncBy Write SetAutoIncBy;
{35} Property thHoldFlg : Byte Read GetHoldFlg Write SetHoldFlg;
{36} Property thAuditFlg : Boolean Read GetAuditFlg Write SetAuditFlg;
{37} Property thTotalWeight : Real Read GetTotalWeight Write SetTotalWeight;
{38} Property thDelAddr[Index : cuAddrIndex] : cuStr30 Read GetDAddr Write SetDAddr;
{39} Property thVariance : Real Read GetVariance Write SetVariance;
{40} Property thTotalOrdered : Real Read GetTotalOrdered Write SetTotalOrdered;
{41} Property thTotalReserved : Real Read GetTotalReserved Write SetTotalReserved;
{42} Property thTotalCost : Real Read GetTotalCost Write SetTotalCost;
{43} Property thTotalInvoiced : Real Read GetTotalInvoiced Write SetTotalInvoiced;
{44} Property thTransDesc : cuStr20 Read GetTransDesc Write SetTransDesc;
{45} Property thAutoUntilDate : cuLongDate Read GetUntilDate Write SetUntilDate;
{46} Property thExternal : Boolean Read GetExternalDoc Write SetExternalDoc;
{47} Property thPrinted : Boolean Read GetPrintedDoc Write SetPrintedDoc;
{48} Property thCurrVariance : Real Read GetReValueAdj Write SetReValueAdj;
{49} Property thCurrSettled : Real Read GetCurrSettled Write SetCurrSettled;
{50} Property thSettledVAT : Real Read GetSettledVAT Write SetSettledVAT;
{51} Property thVATClaimed : Real Read GetVATClaimed Write SetVATClaimed;
{52} Property thBatchPayGL : LongInt Read GetBatchNom Write SetBatchNom;
{53} Property thAutoPost : Boolean Read GetAutoPost Write SetAutoPost;
{54} Property thManualVAT : Boolean Read GetManVAT Write SetManVAT;
{55} Property thSSDDelTerms : cuStr3 Read GetDelTerms Write SetDelTerms;
{56} Property thUser : cuStr10 Read GetOpName Write SetOpName;
{57} Property thNoLabels : SmallInt Read GetNoLabels Write SetNoLabels;
{58} Property thTagged : Boolean Read GetTagged Write SetTagged;
{59} Property thPickRunNo : LongInt Read GetPickRunNo Write SetPickRunNo;
{60} Property thOrdMatch : Boolean Read GetOrdMatch Write SetOrdMatch;
{61} Property thDeliveryNote : cuStr10 Read GetDeliverRef Write SetDeliverRef;
{62} Property thVATCompanyRate : Real Read GetVATCRate1 Write SetVATCRate1;
{63} Property thVATDailyRate : Real Read GetVATCRate2 Write SetVATCRate2;
{64} Property thPostCompanyRate : Real Read GetOrigRates1 Write SetOrigRates1;
{65} Property thPostDailyRate : Real Read GetOrigRates2 Write SetOrigRates2;
{66} Property thPostDiscAm : Double Read GetPostDiscAm Write SetPostDiscAm;
{67} Property thPostedDiscTaken : Boolean Read GetPDiscTaken Write SetPDiscTaken;
{68} Property thDrCrGL : Longint Read GetCtrlNom Write SetCtrlNom;
{69} Property thJobCode : cuStr10 Read GetDJobCode Write SetDJobCode;
{70} Property thJobAnal : cuStr10 Read GetDJobAnal Write SetDJobAnal;
{71} Property thTotOrderOS : Real Read GetTotOrdOS Write SetTotOrdOS;
{72} Property thUser1 : cuStr30 Read GetDocUser1 Write SetDocUser1;     // v5.00 now 30 chars
{73} Property thUser2 : cuStr30 Read GetDocUser2 Write SetDocUser2;     // v5.00 now 30 chars
{74} Property thDocLSplit[Index : cuLineIndex] : Double Read GetDocLSplit Write SetDocLSplit;
{75} Property thLastLetter : Byte Read GetLastLetter Write SetLastLetter;
{76} Property thUnTagged : Boolean Read GetUnTagged Write SetUnTagged;
{77} Property thLines : TAbsInvoiceLines Read GetInvLines;

     { v4.31 fields }
{78} Property thUser3 : cuStr30 Read GetDocUser3 Write SetDocUser3;
{79} Property thUser4 : cuStr30 Read GetDocUser4 Write SetDocUser4;

     { v5.00 fields }
{80} Property thTagNo : Byte Read GetTagNo Write SetTagNo;
  End; { TAbsInvoice }

{-----------------------------------------------------------------------------}

  { v5.50 20/02/03 - Descendant of Abstract Transaction Object for new v5.50 Transaction Fields }
  TAbsInvoice2 = Class(TAbsInvoice)
  Protected
    Function  GetCISTaxDue : Double; Virtual; Abstract;
    Procedure SetCISTaxDue(Value : Double); Virtual; Abstract;
    Function  GetCISTaxDeclared : Double; Virtual; Abstract;
    Procedure SetCISTaxDeclared(Value : Double); Virtual; Abstract;
    Function  GetCISManualTax : Boolean; Virtual; Abstract;
    Procedure SetCISManualTax(Value : Boolean); Virtual; Abstract;
    Function  GetCISDate : cuLongDate; Virtual; Abstract;
    Procedure SetCISDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetCISEmployee : cuStr10; Virtual; Abstract;
    Procedure SetCISEmployee(Value : cuStr10); Virtual; Abstract;
    Function  GetCISTotalGross : Double; Virtual; Abstract;
    Procedure SetCISTotalGross(Value : Double); Virtual; Abstract;
    Function  GetCISSource : Byte; Virtual; Abstract;
    Procedure SetCISSource(Value : Byte); Virtual; Abstract;
    Function  GetTotalCostApport : Double; Virtual; Abstract;
    Procedure SetTotalCostApport(Value : Double); Virtual; Abstract;
  Public
{81} Property thCISTaxDue : Double Read GetCISTaxDue Write SetCISTaxDue;
{82} Property thCISTaxDeclared : Double Read GetCISTaxDeclared Write SetCISTaxDeclared;
{83} Property thCISManualTax : Boolean Read GetCISManualTax Write SetCISManualTax;
{84} Property thCISDate : cuLongDate Read GetCISDate Write SetCISDate;
{85} Property thCISEmployee : cuStr10 Read GetCISEmployee Write SetCISEmployee;
{86} Property thCISTotalGross : Double Read GetCISTotalGross Write SetCISTotalGross;
{87} Property thCISSource : Byte Read GetCISSource Write SetCISSource;
{88} Property thTotalCostApport : Double Read GetTotalCostApport Write SetTotalCostApport;
  End; { TAbsInvoice2 }

{-----------------------------------------------------------------------------}

  { v5.51 06/04/03 - Descendant of Abstract Transaction Object for new v5.51 Transaction Fields }
  TAbsInvoice3 = Class(TAbsInvoice2)
  Protected
    Function  GetNOMVATIO : cuNOMVatIOType; Virtual; Abstract;
    Procedure SetNOMVATIO(Value : cuNOMVatIOType); Virtual; Abstract;
  Public
{89} Property thNOMVATIO : cuNOMVatIOType Read GetNOMVATIO Write SetNOMVATIO;
  End; { TAbsInvoice3 }

  //------------------------------

  // v5.60 23/03/04 - Descendant of Abstract Transaction Object for new v5.60 Transaction Fields
  TAbsInvoice4 = Class(TAbsInvoice3)
  Protected
    Function  GetTSHExported : Boolean; Virtual; Abstract;
    Procedure SetTSHExported(Value : Boolean); Virtual; Abstract;
  Public
{90} Property thTSHExported : Boolean Read GetTSHExported Write SetTSHExported;
  End; { TAbsInvoice4 }

  //------------------------------

  // v6.00 22/05/07 - Descendant of Abstract Transaction Object for new v6.00 20 character YourRef
  TAbsInvoice5 = Class(TAbsInvoice4)
  Protected
    Function  GetYourRef20 : cuStr20; Virtual; Abstract;
    Procedure SetYourRef20(Value : cuStr20); Virtual; Abstract;
  Public
{15} Property thYourRef20 : cuStr20 Read GetYourRef20 Write SetYourRef20;
  End; { TAbsInvoice5 }

  //------------------------------

  // v6.3 02/02/10 - Descendant of Abstract Transaction Object for new v6.3 fields
  TAbsInvoice6 = Class(TAbsInvoice5)
  Protected
    Function  GetWeekMonth : SmallInt; Virtual; Abstract;
    Procedure SetWeekMonth(Value : SmallInt); Virtual; Abstract;
    Function  GetWorkflowState : LongInt; Virtual; Abstract;
    Procedure SetWorkflowState(Value : LongInt); Virtual; Abstract;
  Public
{91} Property thWeekMonth : SmallInt Read GetWeekMonth Write SetWeekMonth;
{92} Property thWorkflowState : LongInt Read GetWorkflowState Write SetWorkflowState;
  End; { TAbsInvoice6 }

  //------------------------------

  // v6.5 12/10/10 - Descendant of Abstract Transaction Object for new v6.5 Override Location fields
  TAbsInvoice7 = Class(TAbsInvoice6)
  Protected
    Function  GetOverrideLocation : cuStr3; Virtual; Abstract;
    Procedure SetOverrideLocation(Value : cuStr3); Virtual; Abstract;
  Public
{93} Property thOverrideLocation : cuStr3 Read GetOverrideLocation Write SetOverrideLocation;
  End; { TAbsInvoice7 }

  //------------------------------

  // v6.9 30/09/2011
  TAbsInvoice8 = Class(TAbsInvoice7)
  Protected
     Function GetUser5 : cuStr30; Virtual; Abstract;
     Procedure SetUser5 (Value : cuStr30); Virtual; Abstract;
     Function GetUser6 : cuStr30; Virtual; Abstract;
     Procedure SetUser6 (Value : cuStr30); Virtual; Abstract;
     Function GetUser7 : cuStr30; Virtual; Abstract;
     Procedure SetUser7 (Value : cuStr30); Virtual; Abstract;
     Function GetUser8 : cuStr30; Virtual; Abstract;
     Procedure SetUser8 (Value : cuStr30); Virtual; Abstract;
     Function GetUser9 : cuStr30; Virtual; Abstract;
     Procedure SetUser9 (Value : cuStr30); Virtual; Abstract;
     Function GetUser10 : cuStr30; Virtual; Abstract;
     Procedure SetUser10 (Value : cuStr30); Virtual; Abstract;
  Public
{94} Property thUser5 : cuStr30 Read GetUser5 Write SetUser5;
{95} Property thUser6 : cuStr30 Read GetUser6 Write SetUser6;
{96} Property thUser7 : cuStr30 Read GetUser7 Write SetUser7;
{97} Property thUser8 : cuStr30 Read GetUser8 Write SetUser8;
{98} Property thUser9 : cuStr30 Read GetUser9 Write SetUser9;
{99} Property thUser10 : cuStr30 Read GetUser10 Write SetUser10;
  End; // TAbsInvoice8

  //------------------------------

  // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode and Transaction Originator
  TAbsInvoice9 = Class(TAbsInvoice8)
  Protected
    Function GetDeliveryPostCode : cuStr20; Virtual; Abstract;
    Procedure SetDeliveryPostCode (value : cuStr20); Virtual; Abstract;

    Function GetOriginator : cuStr36; Virtual; Abstract;
    Procedure SetOriginator (value : cuStr36); Virtual; Abstract;
    Function GetCreationTime : cuStr6; Virtual; Abstract;
    Procedure SetCreationTime (value : cuStr6); Virtual; Abstract;
    Function GetCreationDate : cuStr8; Virtual; Abstract;
    Procedure SetCreationDate (value : cuStr8); Virtual; Abstract;
  Public
{100} Property thDeliveryPostCode : cuStr20 Read GetDeliveryPostCode Write SetDeliveryPostCode;

{101} Property thOriginator : cuStr36 Read GetOriginator Write SetOriginator;
{102} Property thCreationTime : cuStr6 Read GetCreationTime Write SetCreationTime;
{103} Property thCreationDate : cuStr8 Read GetCreationDate Write SetCreationDate;
  End; // TAbsInvoice9

  //------------------------------

  TInvoicePPDTakenStatus = ( ptPPDNotTaken = 0,
                             ptPPDTaken = 1,
                             ptPPDTakenOutsideTerms = 2 );

  // MH 27/03/2015 v7.0.14: Added new fields for Prompt Payment Discounts
  TAbsInvoice10 = Class(TAbsInvoice9)
  Protected
    Function GetPPDPercentage : Double; Virtual; Abstract;
    Procedure SetPPDPercentage (Value : Double); Virtual; Abstract;
    Function GetPPDDays : SmallInt; Virtual; Abstract;
    Procedure SetPPDDays (Value : SmallInt); Virtual; Abstract;
    Function GetPPDGoodsValue : Double; Virtual; Abstract;
    Procedure SetPPDGoodsValue (Value : Double); Virtual; Abstract;
    Function GetPPDVATValue : Double; Virtual; Abstract;
    Procedure SetPPDVATValue (Value : Double); Virtual; Abstract;
    Function GetPPDTakenStatus : TInvoicePPDTakenStatus; Virtual; Abstract;
    Procedure SetPPDTakenStatus (Value : TInvoicePPDTakenStatus); Virtual; Abstract;
    Function GetPPDCreditNote : Boolean; Virtual; Abstract;
    Procedure SetPPDCreditNote(Value : Boolean); Virtual; Abstract;
    Function GetBatchPayPPDStatus : Byte; Virtual; Abstract;
    Procedure SetBatchPayPPDStatus(Value : Byte); Virtual; Abstract;
  Public
      // Discount Percentage - Note: 0.1 = 10%
{104} Property thPPDPercentage : Double Read GetPPDPercentage Write SetPPDPercentage;
      // Number of days discount offer is valid for
{105} Property thPPDDays : SmallInt Read GetPPDDays Write SetPPDDays;
      // Goods Value of Discount (if taken) in Transaction Currency
{106} Property thPPDGoodsValue : Double Read GetPPDGoodsValue Write SetPPDGoodsValue;
      // VAT Value of Discount (if taken) in Transaction Currency
{107} Property thPPDVATValue : Double Read GetPPDVATValue Write SetPPDVATValue;
      // Indicates if Prompt Payment Discount was given
{108} Property thPPDTakenStatus : TInvoicePPDTakenStatus Read GetPPDTakenStatus Write SetPPDTakenStatus;
      // TRUE if this is a Credit Note created for PPD
{109} Property thPPDCreditNote : Boolean Read GetPPDCreditNote Write SetPPDCreditNote;
      // PPD Status Flag for Batch Payments
{110} Property thBatchPayPPDStatus : Byte Read GetBatchPayPPDStatus Write SetBatchPayPPDStatus;
  End; // TAbsInvoice10

//------------------------------

Const
    // MH 21/07/2014: Order Payments - Constants for thOrderPaymentFlags bit field values
  cuOrdPayFlag_PaymentTaken                 = 1;  // Payment Taken
  cuOrdPayFlag_CreditCardAuthorisationTaken = 2;  // Credit Card Authorisation Taken
  cuOrdPayFlag_CreditCardPaymentTaken       = 4;  // Credit Card Payment Taken

Type
  cuTransactionOrderPaymentElement = (topeNA = 0, topeOrder = 1, topeDeliveryNote = 2,
                                      topeInvoice = 3, topeOrderPayment = 4, topeDeliveryPayment = 5,
                                      topeInvoicePayment = 6, topeOrderRefund = 7, topeInvoiceRefund = 8);

  // MH 22/09/2014 Order Payments
  // MH 26/11/2014 ISO Country Codes
  TAbsInvoice11 = Class(TAbsInvoice10)
  Protected
    Function GetOrderPaymentOrderRef : cuStr10; Virtual; Abstract;
    Function GetOrderPaymentElement : cuTransactionOrderPaymentElement; Virtual; Abstract;
    Function GetOrderPaymentFlags : Byte; Virtual; Abstract;
    Function GetCreditCardType : cuStr4; Virtual; Abstract;
    Procedure SetCreditCardType (Value : cuStr4); Virtual; Abstract;
    Function GetCreditCardNumber : cuStr4; Virtual; Abstract;
    Procedure SetCreditCardNumber (Value : cuStr4); Virtual; Abstract;
    Function GetCreditCardExpiry : cuStr4; Virtual; Abstract;
    Procedure SetCreditCardExpiry (Value : cuStr4); Virtual; Abstract;
    Function GetCreditCardAuthorisationNo : cuStr20; Virtual; Abstract;
    Procedure SetCreditCardAuthorisationNo (Value : cuStr20); Virtual; Abstract;
    Function GetCreditCardReferenceNo : cuStr70; Virtual; Abstract;
    Procedure SetCreditCardReferenceNo (Value : cuStr70); Virtual; Abstract;
    Function GetCustomData1 : cuStr30; Virtual; Abstract;
    Procedure SetCustomData1 (Value : cuStr30); Virtual; Abstract;
    Function GetDeliveryCountry : cuStr2; Virtual; Abstract;
    Procedure SetDeliveryCountry (Value : cuStr2); Virtual; Abstract;
  Public
      // OurRef of parent Order for SDN/SIN/SRC in Order Payments subsystem
{111} Property thOrderPaymentOrderRef : cuStr10 Read GetOrderPaymentOrderRef;
      // The type of transaction in Order Payments subsystem, e.g. SOR Payment
{112} Property thOrderPaymentElement : cuTransactionOrderPaymentElement Read GetOrderPaymentElement;
      // bit field - see cuOrdPayFlag_XXX constants above for values
{113} Property thOrderPaymentFlags : Byte Read GetOrderPaymentFlags;
      // Credit Card Payment Details (on Payment SRC only)
{114} Property thCreditCardType : cuStr4 Read GetCreditCardType Write SetCreditCardType;
      // Credit Card Payment Details (on Payment SRC only) - Last 4 digits only
{115} Property thCreditCardNumber : cuStr4 Read GetCreditCardNumber Write SetCreditCardNumber;
      // Credit Card Payment Details (on Payment SRC only) - MMYY format
{116} Property thCreditCardExpiry : cuStr4 Read GetCreditCardExpiry Write SetCreditCardExpiry;
      // Credit Card Payment Details (on Payment SRC only)
{117} Property thCreditCardAuthorisationNo : cuStr20 Read GetCreditCardAuthorisationNo Write SetCreditCardAuthorisationNo;
      // Credit Card Payment Details (on Payment SRC only)
{118} Property thCreditCardReferenceNo : cuStr70 Read GetCreditCardReferenceNo Write SetCreditCardReferenceNo;
      // for bespoke
{119} Property thCustomData1 : cuStr30 Read GetCustomData1 Write SetCustomData1;
      // Delivery Address Country
{120} property thDeliveryCountry : cuStr2 read GetDeliveryCountry Write SetDeliveryCountry;
  End; // TAbsInvoice11


//------------------------------

  // MH 20/01/2016 Exch2016-R1: Intrastat enhancements
  TAbsInvoice12 = Class(TAbsInvoice11)
  Protected
    Function GetIntrastatOutOfPeriod : Boolean; Virtual; Abstract;
    Procedure SetIntrastatOutOfPeriod (Value : Boolean); Virtual; Abstract;
  Public
{121} property thIntrastatOutOfPeriod : Boolean read GetIntrastatOutOfPeriod Write SetIntrastatOutOfPeriod;
  End; // TAbsInvoice12

//------------------------------

  // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
  TAbsInvoice13 = Class(TAbsInvoice12)
  Protected
    Function GetUser11 : cuStr30; Virtual; Abstract;
    Procedure SetUser11 (Value : cuStr30); Virtual; Abstract;
    Function GetUser12 : cuStr30; Virtual; Abstract;
    Procedure SetUser12 (Value : cuStr30); Virtual; Abstract;
  Public
{122} Property thUser11 : cuStr30 Read GetUser11 Write SetUser11;
{123} Property thUser12 : cuStr30 Read GetUser12 Write SetUser12;
  End; // TAbsInvoice13

//------------------------------

  //RB 22/11/2017 2018-R1 ABSEXCH-19400: GDPR (POST 19347) - 8.3.1.1.1 - DLL + COM Customisation Support
  TAbsInvoice14 = Class(TAbsInvoice13)
  Protected
    Function GetAnonymised: Boolean; Virtual; Abstract;
    Procedure SetAnonymised(aValue: Boolean); Virtual; Abstract;
    Function GetAnonymisedDate: cuStr8; Virtual; Abstract;
    Procedure SetAnonymisedDate(aValue: cuStr8); Virtual; Abstract;
    Function GetAnonymisedTime: cuStr6; Virtual; Abstract;
    Procedure SetAnonymisedTime(aValue : cuStr6); Virtual; Abstract;
  Public
{124} Property thAnonymised : Boolean Read GetAnonymised Write SetAnonymised;
{125} Property thAnonymisedDate : cuStr8 Read GetAnonymisedDate Write SetAnonymisedDate;
{126} Property thAnonymisedTime : cuStr6 Read GetAnonymisedTime Write SetAnonymisedTime;
  End; // TAbsInvoice14

//-------------------------------------------------------------------------

  { Abstract Stock Object Interface - used by TAbsEnterpriseSystem }
  TAbsStock = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetStockCode : cuStr16; Virtual; Abstract;
    Procedure SetStockCode(Value : cuStr16); Virtual; Abstract;
    Function  GetDesc (Index : cuDescIndex) : cuStr35; Virtual; Abstract;
    Procedure SetDesc(Index : cuDescIndex; Value : cuStr35); Virtual; Abstract;
    Function  GetAltCode : cuStr20; Virtual; Abstract;
    Procedure SetAltCode(Value : cuStr20); Virtual; Abstract;
    Function  GetSuppTemp : cuStr6; Virtual; Abstract;
    Procedure SetSuppTemp(Value : cuStr6); Virtual; Abstract;
    Function  GetNomCodeS1 : LongInt; Virtual; Abstract;
    Procedure SetNomCodeS1(Value : LongInt); Virtual; Abstract;
    Function  GetNomCodeS2 : LongInt; Virtual; Abstract;
    Procedure SetNomCodeS2(Value : LongInt); Virtual; Abstract;
    Function  GetNomCodeS3 : LongInt; Virtual; Abstract;
    Procedure SetNomCodeS3(Value : LongInt); Virtual; Abstract;
    Function  GetNomCodeS4 : LongInt; Virtual; Abstract;
    Procedure SetNomCodeS4(Value : LongInt); Virtual; Abstract;
    Function  GetNomCodeS5 : LongInt; Virtual; Abstract;
    Procedure SetNomCodeS5(Value : LongInt); Virtual; Abstract;
    Function  GetROFlg : Boolean; Virtual; Abstract;
    Procedure SetROFlg(Value : Boolean); Virtual; Abstract;
    Function  GetMinFlg : Boolean; Virtual; Abstract;
    Procedure SetMinFlg(Value : Boolean); Virtual; Abstract;
    Function  GetStockFolio : LongInt; Virtual; Abstract;
    Procedure SetStockFolio(Value : LongInt); Virtual; Abstract;
    Function  GetStockCat : cuStr16; Virtual; Abstract;
    Procedure SetStockCat(Value : cuStr16); Virtual; Abstract;
    Function  GetStockType : Char; Virtual; Abstract;
    Procedure SetStockType(Value : Char); Virtual; Abstract;
    Function  GetUnitK : cuStr10; Virtual; Abstract;
    Procedure SetUnitK(Value : cuStr10); Virtual; Abstract;
    Function  GetUnitS : cuStr10; Virtual; Abstract;
    Procedure SetUnitS(Value : cuStr10); Virtual; Abstract;
    Function  GetUnitP : cuStr10; Virtual; Abstract;
    Procedure SetUnitP(Value : cuStr10); Virtual; Abstract;
    Function  GetPCurrency : cuCurrencyType; Virtual; Abstract;
    Procedure SetPCurrency(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetCostPrice : Real; Virtual; Abstract;
    Procedure SetCostPrice(Value : Real); Virtual; Abstract;
    Function  GetSaleBandsCcy (Index : cuSalesBandIndex) : cuCurrencyType; Virtual; Abstract;
    Procedure SetSaleBandsCcy(Index : cuSalesBandIndex; Value : cuCurrencyType); Virtual; Abstract;
    Function  GetSaleBandsPrice (Index : cuSalesBandIndex) : Real; Virtual; Abstract;
    Procedure SetSaleBandsPrice(Index : cuSalesBandIndex; Value : Real); Virtual; Abstract;
    Function  GetSellUnit : Real; Virtual; Abstract;
    Procedure SetSellUnit(Value : Real); Virtual; Abstract;
    Function  GetBuyUnit : Real; Virtual; Abstract;
    Procedure SetBuyUnit(Value : Real); Virtual; Abstract;
    Function  GetVATCode : Char; Virtual; Abstract;
    Procedure SetVATCode(Value : Char); Virtual; Abstract;
    Function  GetCCDep1 : cuStr3; Virtual; Abstract;
    Procedure SetCCDep1(Value : cuStr3); Virtual; Abstract;
    Function  GetCCDep2 : cuStr3; Virtual; Abstract;
    Procedure SetCCDep2(Value : cuStr3); Virtual; Abstract;
    Function  GetQtyInStock : Real; Virtual; Abstract;
    Procedure SetQtyInStock(Value : Real); Virtual; Abstract;
    Function  GetQtyPosted : Real; Virtual; Abstract;
    Procedure SetQtyPosted(Value : Real); Virtual; Abstract;
    Function  GetQtyAllocated : Real; Virtual; Abstract;
    Procedure SetQtyAllocated(Value : Real); Virtual; Abstract;
    Function  GetQtyOnOrder : Real; Virtual; Abstract;
    Procedure SetQtyOnOrder(Value : Real); Virtual; Abstract;
    Function  GetQtyMin : Real; Virtual; Abstract;
    Procedure SetQtyMin(Value : Real); Virtual; Abstract;
    Function  GetQtyMax : Real; Virtual; Abstract;
    Procedure SetQtyMax(Value : Real); Virtual; Abstract;
    Function  GetROQty : Real; Virtual; Abstract;
    Procedure SetROQty(Value : Real); Virtual; Abstract;
    Function  GetShowasKit : Boolean; Virtual; Abstract;
    Procedure SetShowasKit(Value : Boolean); Virtual; Abstract;
    Function  GetCommodCode : cuStr10; Virtual; Abstract;
    Procedure SetCommodCode(Value : cuStr10); Virtual; Abstract;
    Function  GetSWeight : Real; Virtual; Abstract;
    Procedure SetSWeight(Value : Real); Virtual; Abstract;
    Function  GetPWeight : Real; Virtual; Abstract;
    Procedure SetPWeight(Value : Real); Virtual; Abstract;
    Function  GetUnitSupp : cuStr10; Virtual; Abstract;
    Procedure SetUnitSupp(Value : cuStr10); Virtual; Abstract;
    Function  GetSuppSUnit : Real; Virtual; Abstract;
    Procedure SetSuppSUnit(Value : Real); Virtual; Abstract;
    Function  GetBinLoc : cuStr10; Virtual; Abstract;
    Procedure SetBinLoc(Value : cuStr10); Virtual; Abstract;
    Function  GetStkFlg : Boolean; Virtual; Abstract;
    Procedure SetStkFlg(Value : Boolean); Virtual; Abstract;
    Function  GetCovPr : SmallInt; Virtual; Abstract;
    Procedure SetCovPr(Value : SmallInt); Virtual; Abstract;
    Function  GetCovPrUnit : Char; Virtual; Abstract;
    Procedure SetCovPrUnit(Value : Char); Virtual; Abstract;
    Function  GetCovMinPr : SmallInt; Virtual; Abstract;
    Procedure SetCovMinPr(Value : SmallInt); Virtual; Abstract;
    Function  GetCovMinUnit : Char; Virtual; Abstract;
    Procedure SetCovMinUnit(Value : Char); Virtual; Abstract;
    Function  GetSupplier : cuStr6; Virtual; Abstract;
    Procedure SetSupplier(Value : cuStr6); Virtual; Abstract;
    Function  GetQtyFreeze : Double; Virtual; Abstract;
    Procedure SetQtyFreeze(Value : Double); Virtual; Abstract;
    Function  GetCovSold : Double; Virtual; Abstract;
    Procedure SetCovSold(Value : Double); Virtual; Abstract;
    Function  GetUseCover : Boolean; Virtual; Abstract;
    Procedure SetUseCover(Value : Boolean); Virtual; Abstract;
    Function  GetCovMaxPr : SmallInt; Virtual; Abstract;
    Procedure SetCovMaxPr(Value : SmallInt); Virtual; Abstract;
    Function  GetCovMaxUnit : Char; Virtual; Abstract;
    Procedure SetCovMaxUnit(Value : Char); Virtual; Abstract;
    Function  GetROCurrency : cuCurrencyType; Virtual; Abstract;
    Procedure SetROCurrency(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetROCPrice : Double; Virtual; Abstract;
    Procedure SetROCPrice(Value : Double); Virtual; Abstract;
    Function  GetRODate : cuLongDate; Virtual; Abstract;
    Procedure SetRODate(Value : cuLongDate); Virtual; Abstract;
    Function  GetQtyTake : Double; Virtual; Abstract;
    Procedure SetQtyTake(Value : Double); Virtual; Abstract;
    Function  GetStkValType : Char; Virtual; Abstract;
    Procedure SetStkValType(Value : Char); Virtual; Abstract;
    Function  GetQtyPicked : Double; Virtual; Abstract;
    Procedure SetQtyPicked(Value : Double); Virtual; Abstract;
    Function  GetLastUsed : cuLongDate; Virtual; Abstract;
    Procedure SetLastUsed(Value : cuLongDate); Virtual; Abstract;
    Function  GetCalcPack : Boolean; Virtual; Abstract;
    Procedure SetCalcPack(Value : Boolean); Virtual; Abstract;
    Function  GetJAnalCode : cuStr10; Virtual; Abstract;
    Procedure SetJAnalCode(Value : cuStr10); Virtual; Abstract;
    Function  GetStkUser1 : cuStr20; Virtual; Abstract;
    Procedure SetStkUser1(Value : cuStr20); Virtual; Abstract;
    Function  GetStkUser2 : cuStr20; Virtual; Abstract;
    Procedure SetStkUser2(Value : cuStr20); Virtual; Abstract;
    Function  GetBarCode : cuStr20; Virtual; Abstract;
    Procedure SetBarCode(Value : cuStr20); Virtual; Abstract;
    Function  GetROCCDep1 : cuStr3; Virtual; Abstract;
    Procedure SetROCCDep1(Value : cuStr3); Virtual; Abstract;
    Function  GetROCCDep2 : cuStr3; Virtual; Abstract;
    Procedure SetROCCDep2(Value : cuStr3); Virtual; Abstract;
    Function  GetDefMLoc : cuStr3; Virtual; Abstract;
    Procedure SetDefMLoc(Value : cuStr3); Virtual; Abstract;
    Function  GetPricePack : Boolean; Virtual; Abstract;
    Procedure SetPricePack(Value : Boolean); Virtual; Abstract;
    Function  GetDPackQty : Boolean; Virtual; Abstract;
    Procedure SetDPackQty(Value : Boolean); Virtual; Abstract;
    Function  GetKitPrice : Boolean; Virtual; Abstract;
    Procedure SetKitPrice(Value : Boolean); Virtual; Abstract;
    Function  GetKitOnPurch : Boolean; Virtual; Abstract;
    Procedure SetKitOnPurch(Value : Boolean); Virtual; Abstract;

    Function  GetStkUser3 : cuStr30; Virtual; Abstract;
    Procedure SetStkUser3(Value : cuStr30); Virtual; Abstract;
    Function  GetStkUser4 : cuStr30; Virtual; Abstract;
    Procedure SetStkUser4(Value : cuStr30); Virtual; Abstract;
    Function  GetSerNoWAvg : Byte; Virtual; Abstract;
    Procedure SetSerNoWAvg(Value : Byte); Virtual; Abstract;
    Function  GetStkSizeCol : Byte; Virtual; Abstract;
    {Procedure SetStkSizeCol(Value : Byte); Virtual; Abstract;}
    Function  GetSSDDUplift : Double; Virtual; Abstract;
    Procedure SetSSDDUplift(Value : Double); Virtual; Abstract;
    Function  GetSSDCountry : cuStr5; Virtual; Abstract;
    Procedure SetSSDCountry(Value : cuStr5); Virtual; Abstract;
    Function  GetTimeChange : cuStr6; Virtual; Abstract;
    Procedure SetTimeChange(Value : cuStr6); Virtual; Abstract;
    Function  GetSVATIncFlg : Char; Virtual; Abstract;
    Procedure SetSVATIncFlg(Value : Char); Virtual; Abstract;
    Function  GetSSDAUpLift : Double; Virtual; Abstract;
    Procedure SetSSDAUpLift(Value : Double); Virtual; Abstract;
    Function  GetLastOpo : cuStr10; Virtual; Abstract;
    Procedure SetLastOpo(Value : cuStr10); Virtual; Abstract;
    Function  GetImageFile : cuStr30; Virtual; Abstract;
    Procedure SetImageFile(Value : cuStr30); Virtual; Abstract;

    function GetQtyAllocWOR: Double; Virtual; Abstract;
    procedure SetQtyAllocWOR(const Value: Double); Virtual; Abstract;
    function GetQtyIssuedWOR: Double; Virtual; Abstract;
    procedure SetQtyIssuedWOR(const Value: Double); Virtual; Abstract;
    function GetQtyPickedWOR: Double; Virtual; Abstract;
    procedure SetQtyPickedWOR(const Value: Double); Virtual; Abstract;
    function GetUseForEbus: Boolean; Virtual; Abstract;
    procedure SetUseForEbus(const Value: Boolean); Virtual; Abstract;
    function GetWebLiveCatalog: cuStr20; Virtual; Abstract;
    procedure SetWebLiveCatalog(const Value: cuStr20); Virtual; Abstract;
    function GetWebPrevCatalog: cuStr20; Virtual; Abstract;
    procedure SetWebPrevCatalog(const Value: cuStr20); Virtual; Abstract;
    function GetWOPAssemblyDays: LongInt; Virtual; Abstract;
    procedure SetWOPAssemblyDays(const Value: LongInt); Virtual; Abstract;
    function GetWOPAssemblyHours: LongInt; Virtual; Abstract;
    procedure SetWOPAssemblyHours(const Value: LongInt); Virtual; Abstract;
    function GetWOPAssemblyMins: LongInt; Virtual; Abstract;
    procedure SetWOPAssemblyMins(const Value: LongInt); Virtual; Abstract;
    function GetWOPAutoCalcTime: Boolean; Virtual; Abstract;
    procedure SetWOPAutoCalcTime(const Value: Boolean); Virtual; Abstract;
    function GetWOPIssuedWIPGL: LongInt; Virtual; Abstract;
    procedure SetWOPIssuedWIPGL(const Value: LongInt); Virtual; Abstract;
    function GetWOPMinEconBuild: Double; Virtual; Abstract;
    procedure SetWOPMinEconBuild(const Value: Double); Virtual; Abstract;
    function GetWOPROLeadTime: LongInt; Virtual; Abstract;
    procedure SetWOPROLeadTime(const Value: LongInt); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property stCode : cuStr16 Read GetStockCode Write SetStockCode;
{02} Property stDesc[Index : cuDescIndex] : cuStr35 Read GetDesc Write SetDesc;
{03} Property stAltCode : cuStr20 Read GetAltCode Write SetAltCode;
{04} Property stSuppTemp : cuStr6 Read GetSuppTemp Write SetSuppTemp;
{05} Property stSalesGL : LongInt Read GetNomCodeS1 Write SetNomCodeS1;
{06} Property stCOSGL : LongInt Read GetNomCodeS2 Write SetNomCodeS2;
{07} Property stPandLGL : LongInt Read GetNomCodeS3 Write SetNomCodeS3;
{08} Property stBalSheetGL : LongInt Read GetNomCodeS4 Write SetNomCodeS4;
{09} Property stWIPGL : LongInt Read GetNomCodeS5 Write SetNomCodeS5;
{10} Property stReOrderFlag : Boolean Read GetROFlg Write SetROFlg;
{11} Property stMinFlg : Boolean Read GetMinFlg Write SetMinFlg;
{12} Property stStockFolio : LongInt Read GetStockFolio Write SetStockFolio;
{13} Property stStockCat : cuStr16 Read GetStockCat Write SetStockCat;
{14} Property stStockType : Char Read GetStockType Write SetStockType;
{15} Property stUnitOfStock : cuStr10 Read GetUnitK Write SetUnitK;
{16} Property stUnitOfSale : cuStr10 Read GetUnitS Write SetUnitS;
{17} Property stUnitOfPurch : cuStr10 Read GetUnitP Write SetUnitP;
{18} Property stCostPriceCur : cuCurrencyType Read GetPCurrency Write SetPCurrency;
{19} Property stCostPrice : Real Read GetCostPrice Write SetCostPrice;
{20} Property stSaleBandsCur[Index : cuSalesBandIndex] : cuCurrencyType Read GetSaleBandsCcy Write SetSaleBandsCcy;
{21} Property stSaleBandsPrice[Index : cuSalesBandIndex] : Real Read GetSaleBandsPrice Write SetSaleBandsPrice;
{22} Property stSalesUnits : Real Read GetSellUnit Write SetSellUnit;
{23} Property stPurchUnits : Real Read GetBuyUnit Write SetBuyUnit;
{24} Property stVATCode : Char Read GetVATCode Write SetVATCode;
{25} Property stCostCentre : cuStr3 Read GetCCDep1 Write SetCCDep1;
{26} Property stDepartment : cuStr3 Read GetCCDep2 Write SetCCDep2;
{27} Property stQtyInStock : Real Read GetQtyInStock Write SetQtyInStock;
{28} Property stQtyPosted : Real Read GetQtyPosted Write SetQtyPosted;
{29} Property stQtyAllocated : Real Read GetQtyAllocated Write SetQtyAllocated;
{30} Property stQtyOnOrder : Real Read GetQtyOnOrder Write SetQtyOnOrder;
{31} Property stQtyMin : Real Read GetQtyMin Write SetQtyMin;
{32} Property stQtyMax : Real Read GetQtyMax Write SetQtyMax;
{33} Property stReOrderQty : Real Read GetROQty Write SetROQty;
{34} Property stKitOnPurch : Boolean Read GetKitOnPurch Write SetKitOnPurch;
{35} Property stShowAsKit : Boolean Read GetShowasKit Write SetShowasKit;
{36} Property stCommodCode : cuStr10 Read GetCommodCode Write SetCommodCode;
{37} Property stSaleUnWeight : Real Read GetSWeight Write SetSWeight;
{38} Property stPurchUnWeight : Real Read GetPWeight Write SetPWeight;
{39} Property stSSDUnit : cuStr10 Read GetUnitSupp Write SetUnitSupp;
{40} Property stSSDSalesUnit : Real Read GetSuppSUnit Write SetSuppSUnit;
{41} Property stBinLocation : cuStr10 Read GetBinLoc Write SetBinLoc;
{42} Property stStkFlg : Boolean Read GetStkFlg Write SetStkFlg;
{43} Property stCovPr : SmallInt Read GetCovPr Write SetCovPr;
{44} Property stCovPrUnit : Char Read GetCovPrUnit Write SetCovPrUnit;
{45} Property stCovMinPr : SmallInt Read GetCovMinPr Write SetCovMinPr;
{46} Property stCovMinUnit : Char Read GetCovMinUnit Write SetCovMinUnit;
{47} Property stSupplier : cuStr6 Read GetSupplier Write SetSupplier;
{48} Property stQtyFreeze : Double Read GetQtyFreeze Write SetQtyFreeze;
{49} Property stCovSold : Double Read GetCovSold Write SetCovSold;
{50} Property stUseCover : Boolean Read GetUseCover Write SetUseCover;
{51} Property stCovMaxPr : SmallInt Read GetCovMaxPr Write SetCovMaxPr;
{52} Property stCovMaxUnit : Char Read GetCovMaxUnit Write SetCovMaxUnit;
{53} Property stReOrderCur : cuCurrencyType Read GetROCurrency Write SetROCurrency;
{54} Property stReOrderPrice : Double Read GetROCPrice Write SetROCPrice;
{55} Property stReOrderDate : cuLongDate Read GetRODate Write SetRODate;
{56} Property stQtyTake : Double Read GetQtyTake Write SetQtyTake;
{57} Property stStkValType : Char Read GetStkValType Write SetStkValType;
{59} Property stQtyPicked : Double Read GetQtyPicked Write SetQtyPicked;
{60} Property stLastUsed : cuLongDate Read GetLastUsed Write SetLastUsed;
{61} Property stCalcPack : Boolean Read GetCalcPack Write SetCalcPack;
{62} Property stJobAnal : cuStr10 Read GetJAnalCode Write SetJAnalCode;
{63} Property stStkUser1 : cuStr20 Read GetStkUser1 Write SetStkUser1;
{64} Property stStkUser2 : cuStr20 Read GetStkUser2 Write SetStkUser2;
{65} Property stBarCode : cuStr20 Read GetBarCode Write SetBarCode;
{66} Property stROCostCentre : cuStr3 Read GetROCCDep1 Write SetROCCDep1;
{67} Property stRODepartment : cuStr3 Read GetROCCDep2 Write SetROCCDep2;
{68} Property stLocation : cuStr3 Read GetDefMLoc Write SetDefMLoc;
{69} Property stPricePack : Boolean Read GetPricePack Write SetPricePack;
{70} Property stDPackQty : Boolean Read GetDPackQty Write SetDPackQty;
{71} Property stKitPrice : Boolean Read GetKitPrice Write SetKitPrice;

     { v4.31 fields }
{72} Property stStkUser3 : cuStr30 Read GetStkUser3 Write SetStkUser3;
{73} Property stStkUser4 : cuStr30 Read GetStkUser4 Write SetStkUser4;
{74} Property stSerNoWAvg : Byte Read GetSerNoWAvg Write SetSerNoWAvg;
{75} Property stStkSizeCol : Byte Read GetStkSizeCol; // Write SetStkSizeCol;
{76} Property stSSDDUplift : Double Read GetSSDDUplift Write SetSSDDUplift;
{77} Property stSSDCountry : cuStr5 Read GetSSDCountry Write SetSSDCountry;
{78} Property stTimeChange : cuStr6 Read GetTimeChange; { Read-Only }
{79} Property stSVATIncFlg : Char Read GetSVATIncFlg Write SetSVATIncFlg;
{80} Property stSSDAUpLift : Double Read GetSSDAUpLift Write SetSSDAUpLift;
{81} Property stLastOpo : cuStr10 Read GetLastOpo Write SetLastOpo;
{82} Property stImageFile : cuStr30 Read GetImageFile Write SetImageFile;

     { v5.00 fields }
{83} Property stUseForEbus : Boolean Read GetUseForEbus Write SetUseForEbus;
{84} Property stWebLiveCatalog : cuStr20 Read GetWebLiveCatalog Write SetWebLiveCatalog;
{85} Property stWebPrevCatalog : cuStr20 Read GetWebPrevCatalog Write SetWebPrevCatalog;
{86} Property stWOPROLeadTime : LongInt Read GetWOPROLeadTime Write SetWOPROLeadTime;
{87} Property stWOPAssemblyDays : LongInt Read GetWOPAssemblyDays Write SetWOPAssemblyDays;
{88} Property stWOPAssemblyHours : LongInt Read GetWOPAssemblyHours Write SetWOPAssemblyHours;
{89} Property stWOPAssemblyMins : LongInt Read GetWOPAssemblyMins Write SetWOPAssemblyMins;
{90} Property stWOPAutoCalcTime : Boolean Read GetWOPAutoCalcTime Write SetWOPAutoCalcTime;
{91} Property stWOPMinEconBuild : Double Read GetWOPMinEconBuild Write SetWOPMinEconBuild;
{92} Property stWOPIssuedWIPGL : LongInt Read GetWOPIssuedWIPGL Write SetWOPIssuedWIPGL;
{93} Property stQtyAllocWOR : Double Read GetQtyAllocWOR Write SetQtyAllocWOR;
{94} Property stQtyIssuedWOR : Double Read GetQtyIssuedWOR Write SetQtyIssuedWOR;
{95} Property stQtyPickedWOR : Double Read GetQtyPickedWOR Write SetQtyPickedWOR;
  End; { TAbsStock }

  //------------------------------

  { v5.52 06/10/03 - Added descendant of Stock Object for Multi-Bin support }
  TAbsStock2 = Class(TAbsStock)
  Protected
    Function GetUsesBins : Boolean;  Virtual; Abstract;
    Procedure SetUsesBins (const Value: Boolean); Virtual; Abstract;
  Public
{96} Property stUsesBins : Boolean Read GetUsesBins Write SetUsesBins;
  End; { TAbsStock2 }

  //------------------------------

  TStockRestockChargeType = (rcValue=0, rcPercentage = 1);

  TStockWarrantyUnits = (wpDays=0, wpWeeks=1, wpMonths=2, wpYears=3);

  // v5.70 22/07/05 - Added descendant of Stock Object for Goods Returns support
  TAbsStock3 = Class(TAbsStock2)
  Protected
    Function GetSalesWarrantyLength : Byte; Virtual; Abstract;
    Procedure SetSalesWarrantyLength (Value : Byte); Virtual; Abstract;
    Function GetSalesWarrantyUnits : TStockWarrantyUnits; Virtual; Abstract;
    Procedure SetSalesWarrantyUnits (Value : TStockWarrantyUnits); Virtual; Abstract;
    Function GetManufacturerWarrantyLength : Byte; Virtual; Abstract;
    Procedure SetManufacturerWarrantyLength (Value : Byte); Virtual; Abstract;
    Function GetManufacturerWarrantyUnits : TStockWarrantyUnits; Virtual; Abstract;
    Procedure SetManufacturerWarrantyUnits (Value : TStockWarrantyUnits); Virtual; Abstract;
    Function GetSalesReturnGL : LongInt; Virtual; Abstract;
    Procedure SetSalesReturnGL (Value : LongInt); Virtual; Abstract;
    Function GetPurchaseReturnGL : LongInt; Virtual; Abstract;
    Procedure SetPurchaseReturnGL (Value : LongInt); Virtual; Abstract;
    Function GetSalesReturnQty : Double; Virtual; Abstract;
    Procedure SetSalesReturnQty (Value : Double); Virtual; Abstract;
    Function GetPurchaseReturnQty : Double; Virtual; Abstract;
    Procedure SetPurchaseReturnQty (Value : Double); Virtual; Abstract;
    Function GetRestockCharge : Double; Virtual; Abstract;
    Procedure SetRestockCharge (Value : Double); Virtual; Abstract;
    Function GetRestockFlag : TStockRestockChargeType; Virtual; Abstract;
    Procedure SetRestockFlag (Value : TStockRestockChargeType); Virtual; Abstract;
  Public
{97} Property stSalesWarrantyLength : Byte Read GetSalesWarrantyLength Write SetSalesWarrantyLength;
{98} Property stSalesWarrantyUnits : TStockWarrantyUnits Read GetSalesWarrantyUnits Write SetSalesWarrantyUnits;
{99} Property stManufacturerWarrantyLength : Byte Read GetManufacturerWarrantyLength Write SetManufacturerWarrantyLength;
{100}Property stManufacturerWarrantyUnits : TStockWarrantyUnits Read GetManufacturerWarrantyUnits Write SetManufacturerWarrantyUnits;
{101}Property stSalesReturnGL : LongInt Read GetSalesReturnGL Write SetSalesReturnGL;
{102}Property stPurchaseReturnGL : LongInt Read GetPurchaseReturnGL Write SetPurchaseReturnGL;
{103}Property stSalesReturnQty : Double Read GetSalesReturnQty Write SetSalesReturnQty;
{104}Property stPurchaseReturnQty : Double Read GetPurchaseReturnQty Write SetPurchaseReturnQty;
{105}Property stRestockCharge : Double Read GetRestockCharge Write SetRestockCharge;
{106}Property stRestockFlag : TStockRestockChargeType Read GetRestockFlag Write SetRestockFlag;
  End; // TAbsStock3

  //------------------------------

  // v6.9 29/09/2011
  TAbsStock4 = Class(TAbsStock3)
  Protected
     Function GetStkUser5 : cuStr30; Virtual; Abstract;
     Procedure SetStkUser5 (Value : cuStr30); Virtual; Abstract;
     Function GetStkUser6 : cuStr30; Virtual; Abstract;
     Procedure SetStkUser6 (Value : cuStr30); Virtual; Abstract;
     Function GetStkUser7 : cuStr30; Virtual; Abstract;
     Procedure SetStkUser7 (Value : cuStr30); Virtual; Abstract;
     Function GetStkUser8 : cuStr30; Virtual; Abstract;
     Procedure SetStkUser8 (Value : cuStr30); Virtual; Abstract;
     Function GetStkUser9 : cuStr30; Virtual; Abstract;
     Procedure SetStkUser9 (Value : cuStr30); Virtual; Abstract;
     Function GetStkUser10 : cuStr30; Virtual; Abstract;
     Procedure SetStkUser10 (Value : cuStr30); Virtual; Abstract;
  Public
{107}Property stStkUser5 : cuStr30 Read GetStkUser5 Write SetStkUser5;
{108}Property stStkUser6 : cuStr30 Read GetStkUser6 Write SetStkUser6;
{109}Property stStkUser7 : cuStr30 Read GetStkUser7 Write SetStkUser7;
{110}Property stStkUser8 : cuStr30 Read GetStkUser8 Write SetStkUser8;
{111}Property stStkUser9 : cuStr30 Read GetStkUser9 Write SetStkUser9;
{112}Property stStkUser10 : cuStr30 Read GetStkUser10 Write SetStkUser10;
  End; // TAbsStock4

  //------------------------------

  // v7.0.12 08/09/2014
  TAbsStock5 = Class(TAbsStock4)
  Protected
    Function GetIsService : Boolean; Virtual; Abstract;
    Procedure SetIsService (Value : Boolean); Virtual; Abstract;
  Public
{113}Property stIsService : Boolean Read GetIsService Write SetIsService;
  End; // TAbsStock5

{-----------------------------------------------------------------------------}

  { Abstract Cost Centre/Department Object Interface - used by TAbsEnterpriseSystem }
  TAbsCCDept = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetCode : cuStr3;  Virtual; Abstract;
    Procedure SetCode (Value : cuStr3); Virtual; Abstract;
    Function  GetDesc : cuStr20;  Virtual; Abstract;
    Procedure SetDesc (Value : cuStr20); Virtual; Abstract;
    Function  GetTag : Boolean;  Virtual; Abstract;
    Procedure SetTag (Value : Boolean); Virtual; Abstract;
    Function  GetAccess : cuLongDate;  Virtual; Abstract;
    Procedure SetAccess (Value : cuLongDate); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property cdCode : cuStr3 Read GetCode Write SetCode;
{02} Property cdDescription : cuStr20 Read GetDesc Write SetDesc;
{03} Property cdTag : Boolean Read GetTag Write SetTag;
{04} Property cdLastAccessDate : cuLongDate Read GetAccess Write SetAccess;
  End; { TAbsCCDept }

{-----------------------------------------------------------------------------}

  { Abstract Cost Centre/Department Object Interface - used by TAbsEnterpriseSystem }
  TAbsGLCode = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetNomCode : LongInt; Virtual; Abstract;
    Procedure SetNomCode(Value : LongInt); Virtual; Abstract;
    Function  GetDesc : cuStr30; Virtual; Abstract;
    Procedure SetDesc(Value : cuStr30); Virtual; Abstract;
    Function  GetCat : LongInt; Virtual; Abstract;
    Procedure SetCat(Value : LongInt); Virtual; Abstract;
    Function  GetNomType : Char; Virtual; Abstract;
    Procedure SetNomType(Value : Char); Virtual; Abstract;

    Function  GetAltCode : cuStr50; Virtual; Abstract;
    Procedure SetAltCode(Value : cuStr50); Virtual; Abstract;
    Function  GetDefCurr : Byte; Virtual; Abstract;
    Procedure SetDefCurr(Value : Byte); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property glCode : Longint Read GetNomCode Write SetNomCode;
{02} Property glName : cuStr30 Read GetDesc Write SetDesc;
{03} Property glParent : LongInt Read GetCat Write SetCat;
{04} Property glType : Char Read GetNomType Write SetNomType;

     { v4.31 Fields }
{05} Property glAltCode : cuStr50 Read GetAltCode Write SetAltCode;
{06} Property glDefCurr : Byte Read GetDefCurr Write SetDefCurr;
  End; { TAbsGLCode }

{-----------------------------------------------------------------------------}

  { Added in Class Version 4.31.002 }
  TAbsBatchSerial = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetSerialCode : cuStr26; Virtual; Abstract;
    Procedure SetSerialCode(Value : cuStr26); Virtual; Abstract;
    Function  GetSerialNo : cuStr20; Virtual; Abstract;
    Procedure SetSerialNo(Value : cuStr20); Virtual; Abstract;
    Function  GetBatchNo : cuStr10; Virtual; Abstract;
    Procedure SetBatchNo(Value : cuStr10); Virtual; Abstract;
    Function  GetInDoc : cuStr10; Virtual; Abstract;
    Procedure SetInDoc(Value : cuStr10); Virtual; Abstract;
    Function  GetOutDoc : cuStr10; Virtual; Abstract;
    Procedure SetOutDoc(Value : cuStr10); Virtual; Abstract;
    Function  GetSold : Boolean; Virtual; Abstract;
    Procedure SetSold(Value : Boolean); Virtual; Abstract;
    Function  GetDateIn : cuLongDate; Virtual; Abstract;
    Procedure SetDateIn(Value : cuLongDate); Virtual; Abstract;
    Function  GetSerCost : Double; Virtual; Abstract;
    Procedure SetSerCost(Value : Double); Virtual; Abstract;
    Function  GetSerSell : Double; Virtual; Abstract;
    Procedure SetSerSell(Value : Double); Virtual; Abstract;
    Function  GetStkFolio : LongInt; Virtual; Abstract;
    Procedure SetStkFolio(Value : LongInt); Virtual; Abstract;
    Function  GetDateOut : cuLongDate; Virtual; Abstract;
    Procedure SetDateOut(Value : cuLongDate); Virtual; Abstract;
    Function  GetSoldLine : LongInt; Virtual; Abstract;
    Procedure SetSoldLine(Value : LongInt); Virtual; Abstract;
    Function  GetCurCost : cuCurrencyType; Virtual; Abstract;
    Procedure SetCurCost(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetCurSell : cuCurrencyType; Virtual; Abstract;
    Procedure SetCurSell(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetBuyLine : LongInt; Virtual; Abstract;
    Procedure SetBuyLine(Value : LongInt); Virtual; Abstract;
    Function  GetBatchRec : Boolean; Virtual; Abstract;
    Procedure SetBatchRec(Value : Boolean); Virtual; Abstract;
    Function  GetBuyQty : Double; Virtual; Abstract;
    Procedure SetBuyQty(Value : Double); Virtual; Abstract;
    Function  GetQtyUsed : Double; Virtual; Abstract;
    Procedure SetQtyUsed(Value : Double); Virtual; Abstract;
    Function  GetBatchChild : Boolean; Virtual; Abstract;
    Procedure SetBatchChild(Value : Boolean); Virtual; Abstract;
    Function  GetInMLoc : cuStr3; Virtual; Abstract;
    Procedure SetInMLoc(Value : cuStr3); Virtual; Abstract;
    Function  GetOutMLoc : cuStr3; Virtual; Abstract;
    Procedure SetOutMLoc(Value : cuStr3); Virtual; Abstract;
    Function  GetCompanyRate : Real; Virtual; Abstract;
    Procedure SetCompanyRate(Value : Real); Virtual; Abstract;
    Function  GetDailyRate : Real; Virtual; Abstract;
    Procedure SetDailyRate(Value : Real); Virtual; Abstract;
    Function  GetInOrdDoc : cuStr10; Virtual; Abstract;
    Procedure SetInOrdDoc(Value : cuStr10); Virtual; Abstract;
    Function  GetOutOrdDoc : cuStr10; Virtual; Abstract;
    Procedure SetOutOrdDoc(Value : cuStr10); Virtual; Abstract;
    Function  GetInOrdLine : LongInt; Virtual; Abstract;
    Procedure SetInOrdLine(Value : LongInt); Virtual; Abstract;
    Function  GetOutOrdLine : LongInt; Virtual; Abstract;
    Procedure SetOutOrdLine(Value : LongInt); Virtual; Abstract;
    Function  GetNLineCount : LongInt; Virtual; Abstract;
    Procedure SetNLineCount(Value : LongInt); Virtual; Abstract;
    Function  GetNoteFolio : LongInt; Virtual; Abstract;
    Procedure SetNoteFolio(Value : LongInt); Virtual; Abstract;
    Function  GetDateUseX : cuLongDate; Virtual; Abstract;
    Procedure SetDateUseX(Value : cuLongDate); Virtual; Abstract;
    Function  GetSUseORate : Byte; Virtual; Abstract;
    Procedure SetSUseORate(Value : Byte); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property bsSerialCode : cuStr26 Read GetSerialCode Write SetSerialCode;
{02} Property bsSerialNo : cuStr20 Read GetSerialNo Write SetSerialNo;
{03} Property bsBatchNo : cuStr10 Read GetBatchNo Write SetBatchNo;
{04} Property bsInDoc : cuStr10 Read GetInDoc Write SetInDoc;
{05} Property bsOutDoc : cuStr10 Read GetOutDoc Write SetOutDoc;
{06} Property bsSold : Boolean Read GetSold Write SetSold;
{07} Property bsDateIn : cuLongDate Read GetDateIn Write SetDateIn;
{08} Property bsSerCost : Double Read GetSerCost Write SetSerCost;
{09} Property bsSerSell : Double Read GetSerSell Write SetSerSell;
{10} Property bsStkFolio : LongInt Read GetStkFolio Write SetStkFolio;
{11} Property bsDateOut : cuLongDate Read GetDateOut Write SetDateOut;
{12} Property bsSoldLine : LongInt Read GetSoldLine Write SetSoldLine;
{13} Property bsCurCost : cuCurrencyType Read GetCurCost Write SetCurCost;
{14} Property bsCurSell : cuCurrencyType Read GetCurSell Write SetCurSell;
{15} Property bsBuyLine : LongInt Read GetBuyLine Write SetBuyLine;
{16} Property bsBatchRec : Boolean Read GetBatchRec Write SetBatchRec;
{17} Property bsBuyQty : Double Read GetBuyQty Write SetBuyQty;
{18} Property bsQtyUsed : Double Read GetQtyUsed Write SetQtyUsed;
{19} Property bsBatchChild : Boolean Read GetBatchChild Write SetBatchChild;
{20} Property bsInMLoc : cuStr3 Read GetInMLoc Write SetInMLoc;
{21} Property bsOutMLoc : cuStr3 Read GetOutMLoc Write SetOutMLoc;
{22} Property bsCompanyRate : Real Read GetCompanyRate Write SetCompanyRate;
{23} Property bsDailyRate : Real Read GetDailyRate Write SetDailyRate;
{24} Property bsInOrdDoc : cuStr10 Read GetInOrdDoc Write SetInOrdDoc;
{25} Property bsOutOrdDoc : cuStr10 Read GetOutOrdDoc Write SetOutOrdDoc;
{26} Property bsInOrdLine : LongInt Read GetInOrdLine Write SetInOrdLine;
{27} Property bsOutOrdLine : LongInt Read GetOutOrdLine Write SetOutOrdLine;
{28} Property bsNLineCount : LongInt Read GetNLineCount Write SetNLineCount;
{29} Property bsNoteFolio : LongInt Read GetNoteFolio Write SetNoteFolio;
{30} Property bsDateUseX : cuLongDate Read GetDateUseX Write SetDateUseX;
{31} Property bsSUseORate : Byte Read GetSUseORate Write SetSUseORate;
  End; { TAbsBatchSerial }

  //------------------------------

  { v5.52 10/09/03: Added descendant class to include new Bin details }
  TAbsBatchSerial2 = Class(TAbsBatchSerial)
  Protected
    Function  GetBinCode : cuStr10; Virtual; Abstract;
    Procedure SetBinCode(Value : cuStr10); Virtual; Abstract;
  Public
{32} Property bsBinCode : cuStr10 Read GetBinCode Write SetBinCode;
  End; { TAbsBatchSerial2 }

  //------------------------------

  // v5.70 - 22/07/05 - Added descendant to include Goods Returns details
  TAbsBatchSerial3 = Class(TAbsBatchSerial2)
  Protected
    Function GetReturned : Boolean; Virtual; Abstract;
    Procedure SetReturned (Value : Boolean); Virtual; Abstract;
    Function GetReturnOurRef : cuStr10; Virtual; Abstract;
    Procedure SetReturnOurRef (Value : cuStr10); Virtual; Abstract;
    Function GetBatchReturnedQty : Double; Virtual; Abstract;
    Procedure SetBatchReturnedQty (Value : Double); Virtual; Abstract;
    Function GetReturnLineNo : LongInt; Virtual; Abstract;
    Procedure SetReturnLineNo (Value : LongInt); Virtual; Abstract;
  Public
{33} Property bsReturned : Boolean Read GetReturned Write SetReturned;
{34} Property bsReturnOurRef : cuStr10 Read GetReturnOurRef Write SetReturnOurRef;
{35} Property bsBatchReturnedQty : Double Read GetBatchReturnedQty Write SetBatchReturnedQty;
{36} Property bsReturnLineNo : LongInt Read GetReturnLineNo Write SetReturnLineNo;
  End; // TAbsBatchSerial3

{-----------------------------------------------------------------------------}

  { v5.50 20/02/03: Added class to encapsulate currency triangulation details }
  TAbsCurrencyTriangulation = Class(TObject)
  Protected
    Function  GetRate : Double; Virtual; Abstract;
    Procedure SetRate(Value : Double); Virtual; Abstract;
    Function  GetEuro : Byte; Virtual; Abstract;
    Procedure SetEuro(Value : Byte); Virtual; Abstract;
    Function  GetInvert : Boolean; Virtual; Abstract;
    Procedure SetInvert(Value : Boolean); Virtual; Abstract;
    Function  GetFloat : Boolean; Virtual; Abstract;
    Procedure SetFloat(Value : Boolean); Virtual; Abstract;
  Public
    property tcRate: Double read GetRate write SetRate;
    property tcEuro: Byte read GetEuro write SetEuro;
    property tcInvert: Boolean read GetInvert write SetInvert;
    property tcFloat: Boolean read GetFloat write SetFloat;
  End; { TAbsCurrencyTriangulation }

{-----------------------------------------------------------------------------}

  { v5.50 20/02/03: Added class to encapsulate the Job Actuals information }
  TAbsJobActual = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetAnalysisCode : cuStr10; Virtual; Abstract;
    Procedure SetAnalysisCode(Value : cuStr10); Virtual; Abstract;
    Function  GetCurrency : cuCurrencyType; Virtual; Abstract;
    Procedure SetCurrency(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetPeriod : Byte; Virtual; Abstract;
    Procedure SetPeriod(Value : Byte); Virtual; Abstract;
    Function  GetPosted : Boolean; Virtual; Abstract;
    Procedure Setposted(Value : Boolean); Virtual; Abstract;
    Function  GetLineFolio : LongInt; Virtual; Abstract;
    Procedure SetLineFolio(Value : LongInt); Virtual; Abstract;
    Function  GetLineNumber : LongInt; Virtual; Abstract;
    Procedure SetLineNumber(Value : LongInt); Virtual; Abstract;
    Function  GetDocRef : cuStr10; Virtual; Abstract;
    Procedure SetDocRef(Value : cuStr10); Virtual; Abstract;
    Function  GetStockCode : cuStr16; Virtual; Abstract;
    Procedure SetStockCode(Value : cuStr16); Virtual; Abstract;
    Function  GetDate : cuLongDate; Virtual; Abstract;
    Procedure SetDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetQty : Double; Virtual; Abstract;
    Procedure SetQty(Value : Double); Virtual; Abstract;
    Function  GetCost : Double; Virtual; Abstract;
    Procedure SetCost(Value : Double); Virtual; Abstract;
    Function  GetCharge : Double; Virtual; Abstract;
    Procedure SetCharge(Value : Double); Virtual; Abstract;
    Function  GetInvoiced : Boolean; Virtual; Abstract;
    Procedure SetInvoiced(Value : Boolean); Virtual; Abstract;
    Function  GetInvoiceRef : cuStr10; Virtual; Abstract;
    Procedure SetInvoiceRef(Value : cuStr10); Virtual; Abstract;
    Function  GetEmployeeCode : cuStr6; Virtual; Abstract;
    Procedure SetEmployeeCode(Value : cuStr6); Virtual; Abstract;
    Function  GetAnalysisType : Byte; Virtual; Abstract;
    Procedure SetAnalysisType(Value : Byte); Virtual; Abstract;
    Function  GetPostedRun : LongInt; Virtual; Abstract;
    Procedure SetPostedRun(Value : LongInt); Virtual; Abstract;
    Function  GetReverseWIP : Boolean; Virtual; Abstract;
    Procedure SetReverseWIP(Value : Boolean); Virtual; Abstract;
    Function  GetReconciled : Boolean; Virtual; Abstract;
    Procedure SetReconciled(Value : Boolean); Virtual; Abstract;
    Function  GetDocType : cuDocTypes; Virtual; Abstract;
    Procedure SetDocType(Value : cuDocTypes); Virtual; Abstract;
    Function  GetChargeCurrency : cuCurrencyType; Virtual; Abstract;
    Procedure SetChargeCurrency(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetAccountCode : cuStr6; Virtual; Abstract;
    Procedure SetAccountCode(Value : cuStr6); Virtual; Abstract;
    Function  GetHoldFlag : Byte; Virtual; Abstract;
    Procedure SetHoldFlag(Value : Byte); Virtual; Abstract;
    Function  GetPostedToStock : Boolean; Virtual; Abstract;
    Procedure SetPostedToStock(Value : Boolean); Virtual; Abstract;
    Function  GetCompanyRate : Double; Virtual; Abstract;
    Procedure SetCompanyRate(Value : Double); Virtual; Abstract;
    Function  GetDailyRate : Double; Virtual; Abstract;
    Procedure SetDailyRate(Value : Double); Virtual; Abstract;
    Function  GetTagged : Boolean; Virtual; Abstract;
    Procedure SetTagged(Value : Boolean); Virtual; Abstract;
    Function  GetGLCode : LongInt; Virtual; Abstract;
    Procedure SetGLCode(Value : LongInt); Virtual; Abstract;
    Function  GetUseORate : Byte; Virtual; Abstract;
    Procedure SetUseORate(Value : Byte); Virtual; Abstract;
    Function  GetTriangulation : TAbsCurrencyTriangulation; Virtual; Abstract;
    Function  GetPriceMultiplier : Double; Virtual; Abstract;
    Procedure SetPriceMultiplier(Value : Double); Virtual; Abstract;
    Function  GetYear : Byte; Virtual; Abstract;
    Procedure SetYear(Value : Byte); Virtual; Abstract;
    Function  GetUpliftTotal : Double; Virtual; Abstract;
    Procedure SetUpliftTotal(Value : Double); Virtual; Abstract;
    Function  GetUpliftGL : LongInt; Virtual; Abstract;
    Procedure SetUpliftGL(Value : LongInt); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property jaAnalysisCode : cuStr10 Read GetAnalysisCode Write SetAnalysisCode;
{02} property jaCurrency: cuCurrencyType read GetCurrency Write SetCurrency;
{03} property jaPeriod: Byte read GetPeriod Write SetPeriod;
{04} property jaPosted: Boolean read GetPosted Write Setposted;
{05} property jaLineFolio: LongInt read GetLineFolio Write SetLineFolio;
{06} property jaLineNumber: LongInt read GetLineNumber Write SetLineNumber;
{07} property jaDocRef: cuStr10 read GetDocRef Write SetDocRef;
{08} property jaStockCode: cuStr16 read GetStockCode Write SetStockCode;
{09} property jaDate: cuLongDate read GetDate Write SetDate;
{10} property jaQty: Double read GetQty Write SetQty;
{11} property jaCost: Double read GetCost Write SetCost;
{12} property jaCharge: Double read GetCharge Write SetCharge;
{13} property jaInvoiced: Boolean read GetInvoiced Write SetInvoiced;
{14} property jaInvoiceRef: cuStr10 read GetInvoiceRef Write SetInvoiceRef;
{15} property jaEmployeeCode: cuStr6 read GetEmployeeCode Write SetEmployeeCode;
{16} property jaAnalysisType: Byte read GetAnalysisType Write SetAnalysisType;
{17} property jaPostedRun: LongInt read GetPostedRun Write SetPostedRun;
{18} property jaReverseWIP: Boolean read GetReverseWIP Write SetReverseWIP;
{19} property jaReconciled: Boolean read GetReconciled Write SetReconciled;
{20} property jaDocType: cuDocTypes read GetDocType Write SetDocType;
{21} property jaChargeCurrency: cuCurrencyType read GetChargeCurrency Write SetChargeCurrency;
{22} property jaAccountCode: cuStr6 read GetAccountCode Write SetAccountCode;
{23} property jaHoldFlag: Byte read GetHoldFlag Write SetHoldFlag;
{24} property jaPostedToStock: Boolean read GetPostedToStock Write SetPostedToStock;
{25} property jaCompanyRate: Double read GetCompanyRate Write SetCompanyRate;
{26} property jaDailyRate: Double read GetDailyRate Write SetDailyRate;
{27} property jaTagged: Boolean read GetTagged Write SetTagged;
{28} property jaGLCode: LongInt read GetGLCode Write SetGLCode;
{29} property jaUseORate: Byte read GetUseORate Write SetUseORate;
{30} property jaTriangulation: TAbsCurrencyTriangulation read GetTriangulation;
{31} property jaPriceMultiplier: Double read GetPriceMultiplier Write SetPriceMultiplier;
{32} property jaYear: Byte read GetYear Write SetYear;
{33} property jaUpliftTotal: Double read GetUpliftTotal Write SetUpliftTotal;
{34} property jaUpliftGL: LongInt read GetUpliftGL Write SetUpliftGL;
  End; { TAbsJobActual }

{-----------------------------------------------------------------------------}

  { v5.50 20/02/03: Added class to encapsulate the Job Budget information }
  TAbsJobBudget = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetBudgetType : Byte; Virtual; Abstract;
    Procedure SetBudgetType(Value : Byte); Virtual; Abstract;
    Function  GetJobCode : cuStr10; Virtual; Abstract;
    Procedure SetJobCode(Value : cuStr10); Virtual; Abstract;
    Function  GetStockCode : cuStr16; Virtual; Abstract;
    Procedure SetStockCode(Value : cuStr16); Virtual; Abstract;
    Function  GetAnalysisCode : cuStr10; Virtual; Abstract;
    Procedure SetAnalysisCode(Value : cuStr10); Virtual; Abstract;
    Function  GetType : Byte; Virtual; Abstract;
    Procedure SetType(Value : Byte); Virtual; Abstract;
    Function  GetUnitPrice : Double; Virtual; Abstract;
    Procedure SetUnitPrice(Value : Double); Virtual; Abstract;
    Function  GetOriginalQty : Double; Virtual; Abstract;
    Procedure SetOriginalQty(Value : Double); Virtual; Abstract;
    Function  GetRevisedQty : Double; Virtual; Abstract;
    Procedure SetRevisedQty(Value : Double); Virtual; Abstract;
    Function  GetOriginalValue : Double; Virtual; Abstract;
    Procedure SetOriginalValue(Value : Double); Virtual; Abstract;
    Function  GetRevisedValue : Double; Virtual; Abstract;
    Procedure SetRevisedValue(Value : Double); Virtual; Abstract;
    Function  GetOriginalValuation : Double; Virtual; Abstract;
    Procedure SetOriginalValuation(Value : Double); Virtual; Abstract;
    Function  GetRevisedValuation : Double; Virtual; Abstract;
    Procedure SetRevisedValuation(Value : Double); Virtual; Abstract;
    Function  GetUplift : Double; Virtual; Abstract;
    Procedure SetUplift(Value : Double); Virtual; Abstract;
    Function  GetRecharge : Boolean; Virtual; Abstract;
    Procedure SetRecharge(Value : Boolean); Virtual; Abstract;
    Function  GetCostOverhead : Double; Virtual; Abstract;
    Procedure SetCostOverhead(Value : Double); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} property jbBudgetType: Byte read GetBudgetType write SetBudgetType;
{02} property jbJobCode: cuStr10 read GetJobCode write SetJobCode;
{03} property jbStockCode: cuStr16 read GetStockCode write SetStockCode;
{04} property jbAnalysisCode: cuStr10 read GetAnalysisCode write SetAnalysisCode;
{05} property jbType: Byte read GetType write SetType;
{06} property jbUnitPrice: Double read GetUnitPrice write SetUnitPrice;
{07} property jbOriginalQty: Double read GetOriginalQty write SetOriginalQty;
{08} property jbRevisedQty: Double read GetRevisedQty write SetRevisedQty;
{09} property jbOriginalValue: Double read GetOriginalValue write SetOriginalValue;
{10} property jbRevisedValue: Double read GetRevisedValue write SetRevisedValue;
{11} property jbOriginalValuation: Double read GetOriginalValuation write SetOriginalValuation;
{12} property jbRevisedValuation: Double read GetRevisedValuation write SetRevisedValuation;
{13} property jbUplift: Double read GetUplift write SetUplift;
{14} property jbRecharge: Boolean read GetRecharge write SetRecharge;
{15} property jbCostOverhead: Double read GetCostOverhead write SetCostOverhead;
  End; { TAbsJobBudget }

  //------------------------------

  { v5.50 20/02/03: Added class to encapsulate the Job Budget information }
  TAbsJobBudget2 = Class(TAbsJobBudget)
  Protected
    Function  GetOrigValuation : Double; Virtual; Abstract;
    Procedure SetOrigValuation(Value : Double); Virtual; Abstract;
    Function  GetRevValuation : Double; Virtual; Abstract;
    Procedure SetRevValuation(Value : Double); Virtual; Abstract;
    Function  GetValuationPercentage : Double; Virtual; Abstract;
    Procedure SetValuationPercentage(Value : Double); Virtual; Abstract;
    Function  GetValuationBasis : Byte; Virtual; Abstract;
    Procedure SetValuationBasis(Value : Byte); Virtual; Abstract;
  Public
{16} property jbOrigValuation: Double read GetOrigValuation write SetOrigValuation;
{17} property jbRevValuation: Double read GetRevValuation write SetRevValuation;
{18} property jbValuationPercentage: Double read GetValuationPercentage write SetValuationPercentage;
{19} property jbValuationBasis : Byte read GetValuationBasis write SetValuationBasis;
  End; { TAbsJobBudget2 }

  //------------------------------

  // v6.00.003 27/11/08: Added descendant class to support the Job Budget Currency
  TAbsJobBudget3 = Class(TAbsJobBudget2)
  Protected
    Function  GetBudgetCurrency : Byte; Virtual; Abstract;
    Procedure SetBudgetCurrency(Value : Byte); Virtual; Abstract;
  public
{20} property jbBudgetCurrency: Byte read GetBudgetCurrency write SetBudgetCurrency;
  end;

{-----------------------------------------------------------------------------}

  { v5.50 20/02/03: Added class to encapsulate the Job Retention information }
  TAbsJobRetention = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetAnalysisCode : cuStr10; Virtual; Abstract;
    Procedure SetAnalysisCode(Value : cuStr10); Virtual; Abstract;
    Function  GetOriginalCurrency : cuCurrencyType; Virtual; Abstract;
    Procedure SetOriginalCurrency(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetYear : Byte; Virtual; Abstract;
    Procedure SetYear(Value : Byte); Virtual; Abstract;
    Function  GetPeriod : Byte; Virtual; Abstract;
    Procedure SetPeriod(Value : Byte); Virtual; Abstract;
    Function  GetPosted : Boolean; Virtual; Abstract;
    Procedure SetPosted(Value : Boolean); Virtual; Abstract;
    Function  GetPercent : Double; Virtual; Abstract;
    Procedure SetPercent(Value : Double); Virtual; Abstract;
    Function  GetCurrency : cuCurrencyType; Virtual; Abstract;
    Procedure SetCurrency(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetValue : Double; Virtual; Abstract;
    Procedure SetValue(Value : Double); Virtual; Abstract;
    Function  GetJobCode : cuStr10; Virtual; Abstract;
    Procedure SetJobCode(Value : cuStr10); Virtual; Abstract;
    Function  GetCreditDoc : cuStr10; Virtual; Abstract;
    Procedure SetCreditDoc(Value : cuStr10); Virtual; Abstract;
    Function  GetExpiryDate : cuLongDate; Virtual; Abstract;
    Procedure SetExpiryDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetInvoiced : Boolean; Virtual; Abstract;
    Procedure SetInvoiced(Value : Boolean); Virtual; Abstract;
    Function  GetAcCode : cuStr6; Virtual; Abstract;
    Procedure SetAcCode(Value : cuStr6); Virtual; Abstract;
    Function  GetEntryDate : cuLongDate; Virtual; Abstract;
    Procedure SetEntryDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetCostCentre : cuStr3; Virtual; Abstract;
    Procedure SetCostCentre(Value : cuStr3); Virtual; Abstract;
    Function  GetDepartment : cuStr3; Virtual; Abstract;
    Procedure SetDepartment(Value : cuStr3); Virtual; Abstract;
    Function  GetDefVatCode : Char; Virtual; Abstract;
    Procedure SetDefVatCode(Value : Char); Virtual; Abstract;
    Function  GetTransaction : cuStr10; Virtual; Abstract;
    Procedure SetTransaction(Value : cuStr10); Virtual; Abstract;
    Function  GetCISTax : Double; Virtual; Abstract;
    Procedure SetCISTax(Value : Double); Virtual; Abstract;
    Function  GetCISGross : Double; Virtual; Abstract;
    Procedure SetCISGross(Value : Double); Virtual; Abstract;
    Function  GetCISEmployee : cuStr6; Virtual; Abstract;
    Procedure SetCISEmployee(Value : cuStr6); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} property jrtAnalysisCode: cuStr10 read GetAnalysisCode write SetAnalysisCode;
{02} property jrtOriginalCurrency: cuCurrencyType read GetOriginalCurrency Write SetOriginalCurrency;
{03} property jrtYear: Byte read GetYear write SetYear;
{04} property jrtPeriod: Byte read GetPeriod write SetPeriod;
{05} property jrtPosted: Boolean read GetPosted Write SetPosted;
{06} property jrtPercent: Double read GetPercent write SetPercent;
{07} property jrtCurrency: cuCurrencyType read GetCurrency write SetCurrency;
{08} property jrtValue: Double read GetValue write SetValue;
{09} property jrtJobCode: cuStr10 read GetJobCode write SetJobCode;
{10} property jrtCreditDoc: cuStr10 read GetCreditDoc write SetCreditDoc;
{11} property jrtExpiryDate: cuLongDate read GetExpiryDate write SetExpiryDate;
{12} property jrtInvoiced: Boolean read GetInvoiced write SetInvoiced;
{13} property jrtAcCode: cuStr6 read GetAcCode write SetAcCode;
{14} property jrtEntryDate: cuLongDate read GetEntryDate write SetEntryDate;
{15} property jrtCostCentre: cuStr3 read GetCostCentre write SetCostCentre;
{16} property jrtDepartment: cuStr3 read GetDepartment write SetDepartment;
{17} property jrtDefVatCode: Char read GetDefVatCode write SetDefVatCode;
{18} property jrtTransaction: cuStr10 read GetTransaction write SetTransaction;
{19} property jrtCISTax: Double read GetCISTax Write SetCISTax;
{20} property jrtCISGross: Double read GetCISGross Write SetCISGross;
{21} property jrtCISEmployee: cuStr6 read GetCISEmployee Write SetCISEmployee;
  End; { TAbsJobRetention }

  //------------------------------

  { v5.50 20/02/03: Added class to encapsulate the Job Retention information }
  TAbsJobRetention2 = Class(TAbsJobRetention)
  Protected
    Function  GetAppMode : Byte; Virtual; Abstract;
    Procedure SetAppMode(Value : Byte); Virtual; Abstract;
  Public
{22} property jrtAppMode: Byte read GetAppMode Write SetAppMode;
  End; { TAbsJobRetention2 }

{-----------------------------------------------------------------------------}

  { Added in v4.31 }
  TAbsJob = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetJobCode : cuStr10; Virtual; Abstract;
    Procedure SetJobCode(Value : cuStr10); Virtual; Abstract;
    Function  GetJobDesc : cuStr30; Virtual; Abstract;
    Procedure SetJobDesc(Value : cuStr30); Virtual; Abstract;
    Function  GetJobFolio : LongInt; Virtual; Abstract;
    Procedure SetJobFolio(Value : LongInt); Virtual; Abstract;
    Function  GetCustCode : cuStr10; Virtual; Abstract;
    Procedure SetCustCode(Value : cuStr10); Virtual; Abstract;
    Function  GetJobCat : cuStr10; Virtual; Abstract;
    Procedure SetJobCat(Value : cuStr10); Virtual; Abstract;
    Function  GetJobAltCode : cuStr10; Virtual; Abstract;
    Procedure SetJobAltCode(Value : cuStr10); Virtual; Abstract;
    Function  GetCompleted : LongInt; Virtual; Abstract;
    Procedure SetCompleted(Value : LongInt); Virtual; Abstract;
    Function  GetContact : cuStr25; Virtual; Abstract;
    Procedure SetContact(Value : cuStr25); Virtual; Abstract;
    Function  GetJobMan : cuStr25; Virtual; Abstract;
    Procedure SetJobMan(Value : cuStr25); Virtual; Abstract;
    Function  GetChargeType : SmallInt; Virtual; Abstract;
    Procedure SetChargeType(Value : SmallInt); Virtual; Abstract;
    Function  GetQuotePrice : Double; Virtual; Abstract;
    Procedure SetQuotePrice(Value : Double); Virtual; Abstract;
    Function  GetCurrPrice : Byte; Virtual; Abstract;
    Procedure SetCurrPrice(Value : Byte); Virtual; Abstract;
    Function  GetStartDate : cuLongDate; Virtual; Abstract;
    Procedure SetStartDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetEndDate : cuLongDate; Virtual; Abstract;
    Procedure SetEndDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetRevEDate : cuLongDate; Virtual; Abstract;
    Procedure SetRevEDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetSORRef : cuStr10; Virtual; Abstract;
    Procedure SetSORRef(Value : cuStr10); Virtual; Abstract;
    Function  GetVATCode : Char; Virtual; Abstract;
    Procedure SetVATCode(Value : Char); Virtual; Abstract;
    Function  GetDept : cuStr3; Virtual; Abstract;
    Procedure SetDept(Value : cuStr3); Virtual; Abstract;
    Function  GetCostCentre : cuStr3; Virtual; Abstract;
    Procedure SetCostCentre(Value : cuStr3); Virtual; Abstract;
    Function  GetJobAnal : cuStr3; Virtual; Abstract;
    Procedure SetJobAnal(Value : cuStr3); Virtual; Abstract;
    Function  GetJobType : Char; Virtual; Abstract;
    Procedure SetJobType(Value : Char); Virtual; Abstract;
    Function  GetJobStat : LongInt; Virtual; Abstract;
    Procedure SetJobStat(Value : LongInt); Virtual; Abstract;
    Function  GetUserDef1 : cuStr20; Virtual; Abstract;
    Procedure SetUserDef1(Value : cuStr20); Virtual; Abstract;
    Function  GetUserDef2 : cuStr20; Virtual; Abstract;
    Procedure SetUserDef2(Value : cuStr20); Virtual; Abstract;
    Function  GetUserDef3 : cuStr20; Virtual; Abstract;
    Procedure SetUserDef3(Value : cuStr20); Virtual; Abstract;
    Function  GetUserDef4 : cuStr20; Virtual; Abstract;
    Procedure SetUserDef4(Value : cuStr20); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property jrJobCode : cuStr10 Read GetJobCode Write SetJobCode;
{02} Property jrJobDesc : cuStr30 Read GetJobDesc Write SetJobDesc;
{03} Property jrJobFolio : LongInt Read GetJobFolio Write SetJobFolio;
{04} Property jrCustCode : cuStr10 Read GetCustCode Write SetCustCode;
{05} Property jrJobCat : cuStr10 Read GetJobCat Write SetJobCat;
{06} Property jrJobAltCode : cuStr10 Read GetJobAltCode Write SetJobAltCode;
{07} Property jrCompleted : LongInt Read GetCompleted Write SetCompleted;
{08} Property jrContact : cuStr25 Read GetContact Write SetContact;
{09} Property jrJobMan : cuStr25 Read GetJobMan Write SetJobMan;
{10} Property jrChargeType : SmallInt Read GetChargeType Write SetChargeType;
{11} Property jrQuotePrice : Double Read GetQuotePrice Write SetQuotePrice;
{12} Property jrCurrPrice : Byte Read GetCurrPrice Write SetCurrPrice;
{13} Property jrStartDate : cuLongDate Read GetStartDate Write SetStartDate;
{14} Property jrEndDate : cuLongDate Read GetEndDate Write SetEndDate;
{15} Property jrRevEDate : cuLongDate Read GetRevEDate Write SetRevEDate;
{16} Property jrSORRef : cuStr10 Read GetSORRef Write SetSORRef;
{17} Property jrVATCode : Char Read GetVATCode Write SetVATCode;
{18} Property jrDept : cuStr3 Read GetDept Write SetDept;
{19} Property jrCostCentre : cuStr3 Read GetCostCentre Write SetCostCentre;
{20} Property jrJobAnal : cuStr3 Read GetJobAnal Write SetJobAnal;
{21} Property jrJobType : Char Read GetJobType Write SetJobType;
{22} Property jrJobStat : LongInt Read GetJobStat Write SetJobStat;
{23} Property jrUserDef1 : cuStr20 Read GetUserDef1 Write SetUserDef1;
{24} Property jrUserDef2 : cuStr20 Read GetUserDef2 Write SetUserDef2;
{25} Property jrUserDef3 : cuStr20 Read GetUserDef3 Write SetUserDef3;
{26} Property jrUserDef4 : cuStr20 Read GetUserDef4 Write SetUserDef4;
  End; { TAbsJob }

  //------------------------------

  { v5.50 20/02/03: Added descendant to allow new sub-objects to be added }
  TAbsJob2= Class(TAbsJob)
  Protected
    Function GetActual : TAbsJobActual; Virtual; Abstract;
    Function GetJobBudget : TAbsJobBudget; Virtual; Abstract;
    Function GetRetention : TAbsJobRetention; Virtual; Abstract;
  Public
{27} Property jrActual : TAbsJobActual Read GetACtual;
{28} Property jrBudget : TAbsJobBudget Read GetJobBudget;
{29} Property jrRetention : TAbsJobRetention Read GetRetention;
  End; { TAbsJob2}

  //------------------------------

  { v5.60 24/03/04: Added descendant to allow new v5.60 fields to be added }
  TAbsJob3 = Class(TAbsJob2)
  Protected
    Function  GetDefRetentionCcy : cuCurrencyType; Virtual; Abstract;
    Procedure SetDefRetentionCcy(Value : cuCurrencyType); Virtual; Abstract;
    Function  GetJPTRef : cuStr10; Virtual; Abstract;
    Procedure SetJPTRef(Value : cuStr10); Virtual; Abstract;
    Function  GetJSTRef : cuStr10; Virtual; Abstract;
    Procedure SetJSTRef(Value : cuStr10); Virtual; Abstract;
    Function  GetQSCode : cuStr20; Virtual; Abstract;
    Procedure SetQSCode(Value : cuStr20); Virtual; Abstract;
  Public
{30} Property jrDefRetentionCcy : cuCurrencyType Read GetDefRetentionCcy Write SetDefRetentionCcy;
{31} Property jrJPTRef : cuStr10 Read GetJPTRef Write SetJPTRef;
{32} Property jrJSTRef : cuStr10 Read GetJSTRef Write SetJSTRef;
{33} Property jrQSCode : cuStr20 Read GetQSCode Write SetQSCode;
  End; { TAbsJob3 }

  //------------------------------

  // v6.9 29/09/2011
  TAbsJob4 = Class(TAbsJob3)
  Protected
    Function GetUserDef5 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef5 (Value : cuStr30); Virtual; Abstract;
    Function GetUserDef6 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef6 (Value : cuStr30); Virtual; Abstract;
    Function GetUserDef7 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef7 (Value : cuStr30); Virtual; Abstract;
    Function GetUserDef8 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef8 (Value : cuStr30); Virtual; Abstract;
    Function GetUserDef9 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef9 (Value : cuStr30); Virtual; Abstract;
    Function GetUserDef10 : cuStr30; Virtual; Abstract;
    Procedure SetUserDef10 (Value : cuStr30); Virtual; Abstract;
  Public
{34}Property jrUserDef5 : cuStr30 Read GetUserDef5 Write SetUserDef5;
{35}Property jrUserDef6 : cuStr30 Read GetUserDef6 Write SetUserDef6;
{36}Property jrUserDef7 : cuStr30 Read GetUserDef7 Write SetUserDef7;
{37}Property jrUserDef8 : cuStr30 Read GetUserDef8 Write SetUserDef8;
{38}Property jrUserDef9 : cuStr30 Read GetUserDef9 Write SetUserDef9;
{39}Property jrUserDef10 : cuStr30 Read GetUserDef10 Write SetUserDef10;
  End; // TAbsJob4

  //------------------------------

  //AP 15/12/2017 ABSEXCH-19486:DLL + COM Customisation Support
  TAbsJob5 = Class(TAbsJob4)
  Protected
    function GetAnonymised: Boolean; Virtual; Abstract;
    function GetAnonymisedDate: cuStr8; Virtual; Abstract;
    function GetAnonymisedTime: cuStr6; Virtual; Abstract;
  Public
    property jrAnonymised: Boolean Read GetAnonymised;
    property jrAnonymisedDate: cuStr8 Read GetAnonymisedDate;
    property jrAnonymisedTime: cuStr6 Read GetAnonymisedTime;
  End; // TAbsJob5
{-----------------------------------------------------------------------------}

  { v5.50 20/02/03: Added new object to encapsulate a CIS Voucher }
  TAbsCISVoucher = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetNumber : cuStr10; Virtual; Abstract;
    Procedure SetNumber(Value : cuStr10); Virtual; Abstract;
    Function  GetEmployee : cuStr6; Virtual; Abstract;
    Procedure SetEmployee(Value : cuStr6); Virtual; Abstract;
    Function  GetDate : cuLongDate; Virtual; Abstract;
    Procedure SetDate(Value : cuLongDate); Virtual; Abstract;
    Function  GetTransaction : cuStr10; Virtual; Abstract;
    Procedure SetTransaction(Value : cuStr10); Virtual; Abstract;
    Function  GetFolio : LongInt; Virtual; Abstract;
    Function  GetCertificateNo : cuStr14; Virtual; Abstract;
    Procedure SetCertificateNo(Value : cuStr14); Virtual; Abstract;
    Function  GetGrossTotal : Double; Virtual; Abstract;
    Procedure SetGrossTotal(Value : Double); Virtual; Abstract;
    Function  GetType : Byte; Virtual; Abstract;
    Procedure SetType(Value : Byte); Virtual; Abstract;
    Function  GetAutoTotalTax : Double; Virtual; Abstract;
    Procedure SetAutoTotalTax(Value : Double); Virtual; Abstract;
    Function  GetManualTax : Boolean; Virtual; Abstract;
    Procedure SetManualTax(Value : Boolean); Virtual; Abstract;
    Function  GetTaxableTotal : Double; Virtual; Abstract;
    Procedure SetTaxableTotal(Value : Double); Virtual; Abstract;
    Function  GetCurrency : Byte; Virtual; Abstract;
    Procedure SetCurrency(Value : Byte); Virtual; Abstract;
    Function  GetAddress(Index : cuAddrIndex) : cuStr30; Virtual; Abstract;
    Procedure SetAddress(Index : cuAddrIndex; Value : cuStr30); Virtual; Abstract;
    Function  GetBehalf : cuStr80; Virtual; Abstract;
    Procedure SetBehalf(Value : cuStr80); Virtual; Abstract;
    Function  GetCorrection : Boolean; Virtual; Abstract;
    Procedure SetCorrection(Value : Boolean); Virtual; Abstract;
    Function  GetTaxDue : Double; Virtual; Abstract;
    Procedure SetTaxDue(Value : Double); Virtual; Abstract;
    Function  GetSupplier : cuStr6; Virtual; Abstract;
    Procedure SetSupplier(Value : cuStr6); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} property cvNumber: cuStr10 read GetNumber write SetNumber;
{02} property cvEmployee: cuStr6 read GetEmployee write SetEmployee;
{03} property cvDate: cuLongDate read GetDate write SetDate;
{04} property cvTransaction: cuStr10 read GetTransaction write SetTransaction;
{05} property cvFolio: LongInt read GetFolio;
{06} property cvCertificateNo: cuStr14 read GetCertificateNo write SetCertificateNo;
{07} property cvGrossTotal: Double read GetGrossTotal write SetGrossTotal;
{08} property cvType: Byte read GetType write SetType;
{09} property cvAutoTotalTax: Double read GetAutoTotalTax write SetAutoTotalTax;
{10} property cvManualTax: Boolean read GetManualTax write SetManualTax;
{11} property cvTaxableTotal: Double read GetTaxableTotal write SetTaxableTotal;
{12} property cvCurrency: Byte read GetCurrency write SetCurrency;
{13} property cvAddress[Index : cuAddrIndex] : cuStr30 Read GetAddress Write SetAddress;
{14} property cvBehalf: cuStr80 read GetBehalf write SetBehalf;
{15} property cvCorrection: Boolean read GetCorrection write SetCorrection;
{16} property cvTaxDue: Double read GetTaxDue write SetTaxDue;
{17} property cvSupplier: cuStr6 read GetSupplier write SetSupplier;
  End; { TAbsCISVoucher }

{-----------------------------------------------------------------------------}

  { v5.50 20/02/03: Added new object to encapsulate an Employee }
  TAbsEmployee = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetCode : cuStr6; Virtual; Abstract;
    Procedure SetCode(Value : cuStr6); Virtual; Abstract;
    Function  GetSupplier : cuStr6; Virtual; Abstract;
    Procedure SetSupplier(Value : cuStr6); Virtual; Abstract;
    Function  GetName : cuStr30; Virtual; Abstract;
    Procedure SetName(Value : cuStr30); Virtual; Abstract;
    Function  GetAddress(Index : cuAddrIndex) : cuStr30; Virtual; Abstract;
    Procedure SetAddress(Index : cuAddrIndex; Value : cuStr30); Virtual; Abstract;
    Function  GetPhone : cuStr20; Virtual; Abstract;
    Procedure SetPhone(Value : cuStr20); Virtual; Abstract;
    Function  GetFax : cuStr20; Virtual; Abstract;
    Procedure SetFax(Value : cuStr20); Virtual; Abstract;
    Function  GetMobile : cuStr20; Virtual; Abstract;
    Procedure SetMobile(Value : cuStr20); Virtual; Abstract;
    Function  GetType : Byte; Virtual; Abstract;
    Procedure SetType(Value : Byte); Virtual; Abstract;
    Function  GetPayrollNumber : cuStr10; Virtual; Abstract;
    Procedure SetPayrollNumber(Value : cuStr10); Virtual; Abstract;
    Function  GetCertificateNumber : cuStr30; Virtual; Abstract;
    Procedure SetCertificateNumber(Value : cuStr30); Virtual; Abstract;
    Function  GetCertificateExpiry : cuLongDate; Virtual; Abstract;
    Procedure SetCertificateExpiry(Value : cuLongDate); Virtual; Abstract;
    Function  GetUserField (Index: Integer) : cuStr20; Virtual; Abstract;
    Procedure SetUserField(Index: Integer; Value : cuStr20); Virtual; Abstract;
    Function  GetCostCentre : cuStr3; Virtual; Abstract;
    Procedure SetCostCentre(Value : cuStr3); Virtual; Abstract;
    Function  GetDepartment : cuStr3; Virtual; Abstract;
    Procedure SetDepartment(Value : cuStr3); Virtual; Abstract;
    Function  GetOwnTimeRatesOnly : Boolean; Virtual; Abstract;
    Procedure SetOwnTimeRatesOnly(Value : Boolean); Virtual; Abstract;
    Function  GetSelfBilling : Boolean; Virtual; Abstract;
    Procedure SetSelfBilling(Value : Boolean); Virtual; Abstract;
    Function  GetGroupCertificate : Boolean; Virtual; Abstract;
    Procedure SetGroupCertificate(Value : Boolean); Virtual; Abstract;
    Function  GetCertificateType : Byte; Virtual; Abstract;
    Procedure SetCertificateType(Value : Byte); Virtual; Abstract;
    Function  GetNationalInsuranceNo : cuStr10; Virtual; Abstract;
    Procedure SetNationalInsuranceNo(Value : cuStr10); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} property emCode : cuStr6 read GetCode write SetCode;
{02} property emSupplier : cuStr6 read GetSupplier write SetSupplier;
{03} property emName : cuStr30 read GetName write SetName;
{04} property emAddress[Index : cuAddrIndex] : cuStr30 Read GetAddress Write SetAddress;
{05} property emPhone: cuStr20 read GetPhone write SetPhone;
{06} property emFax: cuStr20 read GetFax write SetFax;
{07} property emMobile: cuStr20 read GetMobile write SetMobile;
{08} property emType: Byte read GetType write SetType;
{09} property emPayrollNumber: cuStr10 read GetPayrollNumber write SetPayrollNumber;
{10} property emCertificateNumber: cuStr30 read GetCertificateNumber write SetCertificateNumber;
{11} property emCertificateExpiry: cuLongDate read GetCertificateExpiry write SetCertificateExpiry;
{12} property emUserField1: cuStr20 Index 1 read GetUserField write SetUserField;
{13} property emUserField2: cuStr20 Index 2 read GetUserField write SetUserField;
{14} property emUserField3: cuStr20 Index 3 read GetUserField write SetUserField;
{15} property emUserField4: cuStr20 Index 4 read GetUserField write SetUserField;
{16} property emCostCentre: cuStr3 read GetCostCentre write SetCostCentre;
{17} property emDepartment: cuStr3 read GetDepartment write SetDepartment;
{18} property emOwnTimeRatesOnly: Boolean read GetOwnTimeRatesOnly write SetOwnTimeRatesOnly;
{19} property emSelfBilling: Boolean read GetSelfBilling write SetSelfBilling;
{20} property emGroupCertificate: Boolean read GetGroupCertificate write SetGroupCertificate;
{21} property emCertificateType: Byte read GetCertificateType write SetCertificateType;
{22} property emNationalInsuranceNo: cuStr10 read GetNationalInsuranceNo write SetNationalInsuranceNo;
  End; { TAbsEmployee }

  //------------------------------

  { v5.51 04/06/03: Added descendant to allow new properties to be added }
  TAbsEmployee2= Class(TAbsEmployee)
  Protected
    Function GetLabourViaPL : WordBool; Virtual; Abstract;
    Procedure SetLabourViaPL(Value : WordBool); Virtual; Abstract;
  Public
{23} Property emLabourViaPL : WordBool Read GetLabourViaPL Write SetLabourViaPL;
  End; { TAbsEmployee2}

  //------------------------------

  { v6.3 02/02/10: Added descendant to allow new properties to be added }
  TAbsEmployee3 = Class(TAbsEmployee2)
  Protected
    Function GetEmailAddr : cuStr100; Virtual; Abstract;
    Procedure SetEmailAddr(Value : cuStr100); Virtual; Abstract;
  Public
{24} Property emEmailAddr : cuStr100 Read GetEmailAddr Write SetEmailAddr;
  End; { TAbsEmployee3}

  //------------------------------

  { v7.0.2 20/03/13: Added descendant for missing Employee fields }
  TAbsEmployee4 = Class(TAbsEmployee3)
  Protected
    Function GetContractorType : Byte; Virtual; Abstract;
    Procedure SetContractorType(Value : Byte); Virtual; Abstract;
    Function GetTagged : Byte; Virtual; Abstract;
    Procedure SetTagged(Value : Byte); Virtual; Abstract;
    Function GetTimeRateRules : Byte; Virtual; Abstract;
    Procedure SetTimeRateRules(Value : Byte); Virtual; Abstract;
    Function GetUTRCode : cuStr10; Virtual; Abstract;
    Procedure SetUTRCode(Value : cuStr10); Virtual; Abstract;
    Function GetVerificationNo : cuStr13; Virtual; Abstract;
    Procedure SetVerificationNo(Value : cuStr13); Virtual; Abstract;
  Public
{25} Property emContractorType : Byte Read GetContractorType Write SetContractorType;
{26} Property emTagged : Byte Read GetTagged Write SetTagged;
{27} Property emTimeRateRules : Byte Read GetTimeRateRules Write SetTimeRateRules;
{28} Property emUTRCode : cuStr10 Read GetUTRCode Write SetUTRCode;
{29} Property emVerificationNo : cuStr13 Read GetVerificationNo Write SetVerificationNo;
  End; // TAbsEmployee4

  //RB 22/11/2017 2018-R1 ABSEXCH-19396: GDPR (POST 19352) - 8.3.1.1.1 - DLL + COM Customisation Support
  TEmpStatus = (emsOpen = 0, emsClosed = 1);

  TAbsEmployee5 = Class(TAbsEmployee4)
  Protected
    Function GetStatus: TEmpStatus; Virtual; Abstract;
    Procedure SetStatus(Value: TEmpStatus); Virtual; Abstract;
    Function GetAnonymisationStatus: TCustomerAnonymisationStatus; Virtual; Abstract;
    Procedure SetAnonymisationStatus(Value: TCustomerAnonymisationStatus); Virtual; Abstract;
    Function GetAnonymisedDate: cuStr8; Virtual; Abstract;
    Procedure SetAnonymisedDate(Value: cuStr8); Virtual; Abstract;
    Function GetAnonymisedTime: cuStr6; Virtual; Abstract;
    Procedure SetAnonymisedTime(Value: cuStr6); Virtual; Abstract;
  Public
{30} Property emStatus : TEmpStatus Read GetStatus Write SetStatus;
{31} Property emAnonymisationStatus : TCustomerAnonymisationStatus Read GetAnonymisationStatus Write SetAnonymisationStatus;
{32} Property emAnonymisedDate : cuStr8 Read GetAnonymisedDate Write SetAnonymisedDate;
{33} Property emAnonymisedTime : cuStr6 Read GetAnonymisedTime Write SetAnonymisedTime;
  End; { TAbsEmployee5}

{-----------------------------------------------------------------------------}

  { v5.50 20/02/03: Added new object to encapsulate a Job Analysis Code }
  TAbsJobAnalysis = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetCode : cuStr10; Virtual; Abstract;
    Procedure SetCode(Value : cuStr10); Virtual; Abstract;
    Function  GetDescription : cuStr30; Virtual; Abstract;
    Procedure SetDescription(Value : cuStr30); Virtual; Abstract;
    Function  GetType : Smallint; Virtual; Abstract;
    Procedure SetType(Value : Smallint); Virtual; Abstract;
    Function  GetCategory : Smallint; Virtual; Abstract;
    Procedure SetCategory(Value : Smallint); Virtual; Abstract;
    Function  GetWIPGL : LongInt; Virtual; Abstract;
    Procedure SetWIPGL(Value : LongInt); Virtual; Abstract;
    Function  GetPandLGL : LongInt; Virtual; Abstract;
    Procedure SetPandLGL(Value : LongInt); Virtual; Abstract;
    Function  GetLineType : cuLineTIndex; Virtual; Abstract;
    Procedure SetLineType(Value : cuLineTIndex); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} property anCode: cuStr10 read GetCode write SetCode;
{02} property anDescription: cuStr30 read GetDescription write SetDescription;
{03} property anType: Smallint read GetType write SetType;
{04} property anCategory: Smallint read GetCategory write SetCategory;
{05} property anWIPGL: LongInt read GetWIPGL write SetWIPGL;
{06} property anPandLGL: LongInt read GetPandLGL write SetPandLGL;
{07} property anLineType: cuLineTIndex read GetLineType write SetLineType;
  End; { TAbsJobAnalysis }

  //------------------------------

  { v5.60 24/03/04: Added new descendant object to include the new v5.60 fields }
  TAbsJobAnalysis2 = Class(TAbsJobAnalysis)
  Protected
    Function  GetDeductType : Byte; Virtual; Abstract;
    Procedure SetDeductType(Value : Byte); Virtual; Abstract;
    Function  GetCalcDeductBeforeRetent : Boolean; Virtual; Abstract;
    Procedure SetCalcDeductBeforeRetent(Value : Boolean); Virtual; Abstract;
    Function  GetDeductAnalysisMode : Byte; Virtual; Abstract;
    Procedure SetDeductAnalysisMode(Value : Byte); Virtual; Abstract;
    Function  GetRetentionType : Byte; Virtual; Abstract;
    Procedure SetRetentionType(Value : Byte); Virtual; Abstract;
    Function  GetRetentionPercentage : Double; Virtual; Abstract;
    Procedure SetRetentionPercentage(Value : Double); Virtual; Abstract;
    Function  GetRetentionExpiryMode : Byte; Virtual; Abstract;
    Procedure SetRetentionExpiryMode(Value : Byte); Virtual; Abstract;
    Function  GetRetentionExpiryInterval : Byte; Virtual; Abstract;
    Procedure SetRetentionExpiryInterval(Value : Byte); Virtual; Abstract;
    Function  GetPreserveToRetentention : Boolean; Virtual; Abstract;
    Procedure SetPreserveToRetentention(Value : Boolean); Virtual; Abstract;
    Function  GetDeductCalcMode : Byte; Virtual; Abstract;
    Procedure SetDeductCalcMode(Value : Byte); Virtual; Abstract;
    Function  GetPayrollDeductCode : cuStr5; Virtual; Abstract;
    Procedure SetPayrollDeductCode(Value : cuStr5); Virtual; Abstract;
  Public
{08} Property anDeductType : Byte Read GetDeductType Write SetDeductType;
{09} Property anCalcDeductBeforeRetent : Boolean Read GetCalcDeductBeforeRetent Write SetCalcDeductBeforeRetent;
{10} Property anDeductAnalysisMode : Byte Read GetDeductAnalysisMode Write SetDeductAnalysisMode;
{11} Property anDeductCalcMode : Byte Read GetDeductCalcMode Write SetDeductCalcMode;
{12} Property anPayrollDeductCode : cuStr5 Read GetPayrollDeductCode Write SetPayrollDeductCode;

{13} Property anRetentionType : Byte Read GetRetentionType Write SetRetentionType;
{14} Property anRetentionPercentage : Double Read GetRetentionPercentage Write SetRetentionPercentage;
{15} Property anRetentionExpiryMode : Byte Read GetRetentionExpiryMode Write SetRetentionExpiryMode;
{16} Property anRetentionExpiryInterval : Byte Read GetRetentionExpiryInterval Write SetRetentionExpiryInterval;
{17} Property anPreserveToRetention : Boolean Read GetPreserveToRetentention Write SetPreserveToRetentention;
  End; { TAbsJobAnalysis2 }

{-----------------------------------------------------------------------------}

  { v5.50 20/02/03: Added new object to encapsulate an Employee }
  TAbsTimeRate = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetRateCode : cuStr10; Virtual; Abstract;
    Procedure SetRateCode(Value : cuStr10); Virtual; Abstract;
    Function  GetEmployeeCode : cuStr6; Virtual; Abstract;
    Procedure SetEmployeeCode(Value : cuStr6); Virtual; Abstract;
    Function  GetCostCurrency : Byte; Virtual; Abstract;
    Procedure SetCostCurrency(Value : Byte); Virtual; Abstract;
    Function  GetTimeCost : Double; Virtual; Abstract;
    Procedure SetTimeCost(Value : Double); Virtual; Abstract;
    Function  GetChargeCurrency : Byte; Virtual; Abstract;
    Procedure SetChargeCurrency(Value : Byte); Virtual; Abstract;
    Function  GetTimeCharge : Double; Virtual; Abstract;
    Procedure SetTimeCharge(Value : Double); Virtual; Abstract;
    Function  GetAnalysisCode : cuStr10; Virtual; Abstract;
    Procedure SetAnalysisCode(Value : cuStr10); Virtual; Abstract;
    Function  GetDescription : cuStr30; Virtual; Abstract;
    Procedure SetDescription(Value : cuStr30); Virtual; Abstract;
    Function  GetPayFactor : Smallint; Virtual; Abstract;
    Procedure SetPayFactor(Value : Smallint); Virtual; Abstract;
    Function  GetPayRate : Smallint; Virtual; Abstract;
    Procedure SetPayRate(Value : Smallint); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} property trRateCode: cuStr10 read GetRateCode write SetRateCode;
{02} property trEmployeeCode: cuStr6  read GetEmployeeCode write SetEmployeeCode;
{03} property trCostCurrency: Byte read GetCostCurrency write SetCostCurrency;
{04} property trTimeCost: Double read GetTimeCost write SetTimeCost;
{05} property trChargeCurrency: Byte read GetChargeCurrency write SetChargeCurrency;
{06} property trTimeCharge: Double read GetTimeCharge write SetTimeCharge;
{07} property trAnalysisCode: cuStr10 read GetAnalysisCode write SetAnalysisCode;
{08} property trDescription: cuStr30 read GetDescription write SetDescription;
{09} property trPayFactor: Smallint read GetPayFactor write SetPayFactor;
{10} property trPayRate: Smallint read GetPayRate write SetPayRate;
  End; { TAbsTimeRate }

{-----------------------------------------------------------------------------}

  { v5.50 20/02/03: Added new object to encapsulate the Job Costing elements }
  TAbsJobCosting = Class(TObject)
  Protected
    Function GetCISVoucher : TAbsCISVoucher; Virtual; Abstract;
    Function GetEmployee : TAbsEmployee; Virtual; Abstract;
    Function GetJob2 : TAbsJob2; Virtual; Abstract;
    Function GetJobAnalysis : TAbsJobAnalysis; Virtual; Abstract;
    Function GetTimeRate : TAbsTimeRate; Virtual; Abstract;
  Public
    Property CISVoucher : TAbsCISVoucher Read GetCISVoucher;
    Property Employee : TAbsEmployee Read GetEmployee;
    Property Job2 : TAbsJob2 Read GetJob2;   // NOTE: Maps onto TAbsEnterpriseSystem.Job
    Property JobAnalysis : TAbsJobAnalysis Read GetJobAnalysis;
    //Property JobType :
    Property TimeRate : TAbsTimeRate Read GetTimeRate;
  End; { TAbsJobCosting }

{-----------------------------------------------------------------------------}

  { Added in v4.31 }
  TAbsMiscData = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function  GetBoolean(Index : SmallInt) : Boolean; Virtual; Abstract;
    Procedure SetBoolean(Index : SmallInt; Value : Boolean); Virtual; Abstract;
    Function  GetDouble(Index : SmallInt) : Double; Virtual; Abstract;
    Procedure SetDouble(Index : SmallInt; Value : Double); Virtual; Abstract;
    Function  GetLongInt(Index : SmallInt) : LongInt; Virtual; Abstract;
    Procedure SetLongInt(Index : SmallInt; Value : LongInt); Virtual; Abstract;
    Function  GetShortString(Index : SmallInt) : ShortString; Virtual; Abstract;
    Procedure SetShortString(Index : SmallInt; Value : ShortString); Virtual; Abstract;
    Function  GetVariant(Index : SmallInt) : Variant; Virtual; Abstract;
    Procedure SetVariant(Index : SmallInt; Value : Variant); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

    Property mdBoolean [Index : SmallInt] : Boolean Read GetBoolean Write SetBoolean;
    Property mdDouble [Index : SmallInt] : Double Read GetDouble Write SetDouble;
    Property mdLongInt [Index : SmallInt] : LongInt Read GetLongInt Write SetLongInt;
    Property mdString [Index : SmallInt] : ShortString Read GetShortString Write SetShortString;
    Property mdVariant [Index : SmallInt] : Variant Read GetVariant Write SetVariant;
  End; { TAbsMiscData }

{-----------------------------------------------------------------------------}

  { v5.50 03/03/03: Added new class to encapsulate the line information from Telesales }
  TAbsTelesalesLine = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function GetCustCode : cuStr6; Virtual; Abstract;
    Procedure SetCustCode (Value : cuStr6); Virtual; Abstract;
    Function GetStockCode : cuStr16; Virtual; Abstract;
    Procedure SetStockCode (Value : cuStr16); Virtual; Abstract;
    Function GetRepeatQty : Double; Virtual; Abstract;
    Procedure SetRepeatQty (Value : Double); Virtual; Abstract;
    Function GetLastSaleDate : cuLongDate; Virtual; Abstract;
    Procedure SetLastSaleDate (Value : cuLongDate); Virtual; Abstract;
    Function GetDisplayOrder : LongInt; Virtual; Abstract;
    Procedure SetDisplayOrder (Value : LongInt); Virtual; Abstract;
    Function GetLastPrice : Double; Virtual; Abstract;
    Procedure SetLastPrice (Value : Double); Virtual; Abstract;
    Function GetLastPriceCurr : Byte; Virtual; Abstract;
    Procedure SetLastPriceCurr (Value : Byte); Virtual; Abstract;
    Function GetJobCode : cuStr10; Virtual; Abstract;
    Procedure SetJobCode (Value : cuStr10); Virtual; Abstract;
    Function GetJobAnal : cuStr10; Virtual; Abstract;
    Procedure SetJobAnal (Value : cuStr10); Virtual; Abstract;
    Function GetLocation : cuStr3; Virtual; Abstract;
    Procedure SetLocation (Value : cuStr3); Virtual; Abstract;
    Function GetGLCode : LongInt; Virtual; Abstract;
    Procedure SetGLCode (Value : LongInt); Virtual; Abstract;
    Function GetCostCentre : cuStr3; Virtual; Abstract;
    Procedure SetCostCentre (Value : cuStr3); Virtual; Abstract;
    Function GetDepartment : cuStr3; Virtual; Abstract;
    Procedure SetDepartment (Value : cuStr3); Virtual; Abstract;
    Function GetQty : Double; Virtual; Abstract;
    Procedure SetQty (Value : Double); Virtual; Abstract;
    Function GetNetValue : Double; Virtual; Abstract;
    Procedure SetNetValue (Value : Double); Virtual; Abstract;
    Function GetDiscount : Double; Virtual; Abstract;
    Procedure SetDiscount (Value : Double); Virtual; Abstract;
    Function GetVATCode : Char; Virtual; Abstract;
    Procedure SetVATCode (Value : Char); Virtual; Abstract;
    Function GetCost : Double; Virtual; Abstract;
    Procedure SetCost (Value : Double); Virtual; Abstract;
    Function  GetDescr(Index : cuDescIndex) : cuStr35; Virtual; Abstract;
    Procedure SetDescr(Index : cuDescIndex; Value : cuStr35); Virtual; Abstract;
    Function GetVATAmount : Double; Virtual; Abstract;
    Procedure SetVATAmount (Value : Double); Virtual; Abstract;
    Function GetPriceByPack : Boolean; Virtual; Abstract;
    Procedure SetPriceByPack (Value : Boolean); Virtual; Abstract;
    Function GetQtyInPack : Double; Virtual; Abstract;
    Procedure SetQtyInPack (Value : Double); Virtual; Abstract;
    Function GetQtyMul : Double; Virtual; Abstract;
    Procedure SetQtyMul (Value : Double); Virtual; Abstract;
    Function GetDiscFlag : Char; Virtual; Abstract;
    Procedure SetDiscFlag (Value : Char); Virtual; Abstract;
    Function GetEntered : Boolean; Virtual; Abstract;
    Procedure SetEntered (Value : Boolean); Virtual; Abstract;
    Function GetCalcPack : Boolean; Virtual; Abstract;
    Procedure SetCalcPack (Value : Boolean); Virtual; Abstract;
    Function GetShowAsPacks : Boolean; Virtual; Abstract;
    Procedure SetShowAsPacks (Value : Boolean); Virtual; Abstract;
    Function GetLineType : cuLineTIndex; Virtual; Abstract;
    Procedure SetLineType (Value : cuLineTIndex); Virtual; Abstract;
    Function GetPriceMultiplier : Double; Virtual; Abstract;
    Procedure SetPriceMultiplier (Value : Double); Virtual; Abstract;
    Function GetInclusiveVATCode : Char; Virtual; Abstract;
    Procedure SetInclusiveVATCode (Value : Char); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property telCustCode : cuStr6 Read GetCustCode Write SetCustCode;
{02} Property telStockCode : cuStr16 Read GetStockCode Write SetStockCode;
{03} Property telRepeatQty : Double Read GetRepeatQty Write SetRepeatQty;
{04} Property telLastSaleDate : cuLongDate Read GetLastSaleDate Write SetLastSaleDate;
{05} Property telDisplayOrder :  LongInt Read GetDisplayOrder Write SetDisplayOrder;
{06} Property telLastPrice : Double Read GetLastPrice Write SetLastPrice;
{07} Property telLastPriceCurr : Byte Read GetLastPriceCurr Write SetLastPriceCurr;
{08} Property telJobCode : cuStr10 Read GetJobCode Write SetJobCode;
{09} Property telJobAnal : cuStr10 Read GetJobAnal Write SetJobAnal;
{10} Property telLocation : cuStr3 Read GetLocation Write SetLocation;
{11} Property telGLCode : LongInt Read GetGLCode Write SetGLCode;
{12} Property telCostCentre : cuStr3 Read GetCostCentre Write SetCostCentre;
{13} Property telDepartment : cuStr3 Read GetDepartment Write SetDepartment;
{14} Property telQty : Double Read GetQty Write SetQty;
{15} Property telNetValue : Double Read GetNetValue Write SetNetValue;
{16} Property telDiscount : Double Read GetDiscount Write SetDiscount;
{17} Property telVATCode : Char Read GetVATCode Write SetVATCode;
{18} Property telCost : Double Read GetCost Write SetCost;
{19} Property telDescr [Index : cuDescIndex] : cuStr35 Read GetDescr Write SetDescr;
{20} Property telVATAmount : Double Read GetVATAmount Write SetVATAmount;
{21} Property telPriceByPack : Boolean Read GetPriceByPack Write SetPriceByPack;
{22} Property telQtyInPack : Double Read GetQtyInPack Write SetQtyInPack;
{23} Property telQtyMul : Double Read GetQtyMul Write SetQtyMul;
{24} Property telDiscFlag : Char Read GetDiscFlag Write SetDiscFlag;
{25} Property telEntered : Boolean Read GetEntered Write SetEntered;
{26} Property telCalcPack : Boolean Read GetCalcPack Write SetCalcPack;
{27} Property telShowAsPacks : Boolean Read GetShowAsPacks Write SetShowAsPacks;
{28} Property telLineType : cuLineTIndex Read GetLineType Write SetLineType;
{29} Property telPriceMultiplier : Double Read GetPriceMultiplier Write SetPriceMultiplier;
{30} Property telInclusiveVATCode : Char Read GetInclusiveVATCode Write SetInclusiveVATCode;
  End; { TAbsTelesalesLine }

{-----------------------------------------------------------------------------}

  { v5.50 03/03/03: Added new class to encapsulate the header information from Telesales }
  TAbsTelesales = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function GetCustCode : cuStr6; Virtual; Abstract;
    Procedure SetCustCode (Value : cuStr6); Virtual; Abstract;
    Function GetCurrency : Byte; Virtual; Abstract;
    Procedure SetCurrency (Value : Byte); Virtual; Abstract;
    Function GetCompanyRate : Real; Virtual; Abstract;
    Procedure SetCompanyRate (Value : Real); Virtual; Abstract;
    Function GetDailyRate : Real; Virtual; Abstract;
    Procedure SetDailyRate (Value : Real); Virtual; Abstract;
    Function GetYourRef : cuStr10; Virtual; Abstract;
    Procedure SetYourRef (Value : cuStr10); Virtual; Abstract;
    Function GetAltRef : cuStr20; Virtual; Abstract;
    Procedure SetAltRef (Value : cuStr20); Virtual; Abstract;
    Function GetCostCentre : cuStr3; Virtual; Abstract;
    Procedure SetCostCentre (Value : cuStr3); Virtual; Abstract;
    Function GetDepartment : cuStr3; Virtual; Abstract;
    Procedure SetDepartment (Value : cuStr3); Virtual; Abstract;
    Function GetLocation : cuStr3; Virtual; Abstract;
    Procedure SetLocation (Value : cuStr3); Virtual; Abstract;
    Function GetJobCode : cuStr10; Virtual; Abstract;
    Procedure SetJobCode (Value : cuStr10); Virtual; Abstract;
    Function GetJobAnal : cuStr10; Virtual; Abstract;
    Procedure SetJobAnal (Value : cuStr10); Virtual; Abstract;
    Function  GetDelAddr(Index : cuAddrIndex) : cuStr30; Virtual; Abstract;
    Procedure SetDelAddr(Index : cuAddrIndex; Value : cuStr30); Virtual; Abstract;
    Function GetTransDate : cuLongDate; Virtual; Abstract;
    Procedure SetTransDate (Value : cuLongDate); Virtual; Abstract;
    Function GetDueDate : cuLongDate; Virtual; Abstract;
    Procedure SetDueDate (Value : cuLongDate); Virtual; Abstract;
    Function GetNetTotal : Double; Virtual; Abstract;
    Procedure SetNetTotal (Value : Double); Virtual; Abstract;
    Function GetVATTotal : Double; Virtual; Abstract;
    Procedure SetVATTotal (Value : Double); Virtual; Abstract;
    Function GetTotalDiscount : Double; Virtual; Abstract;
    Procedure SetTotalDiscount (Value : Double); Virtual; Abstract;
    Function GetUser : cuStr10; Virtual; Abstract;
    Procedure SetUser (Value : cuStr10); Virtual; Abstract;
    Function GetInProgress : Boolean; Virtual; Abstract;
    Procedure SetInProgress (Value : Boolean); Virtual; Abstract;
    Function GetTransportNature : Byte; Virtual; Abstract;
    Procedure SetTransportNature (Value : Byte); Virtual; Abstract;
    Function GetTransportMode : Byte; Virtual; Abstract;
    Procedure SetTransportMode (Value : Byte); Virtual; Abstract;
    Function GetDelTerms : cuStr3; Virtual; Abstract;
    Procedure SetDelTerms (Value : cuStr3); Virtual; Abstract;
    Function GetControlGL : LongInt; Virtual; Abstract;
    Procedure SetControlGL (Value : LongInt); Virtual; Abstract;
    Function GetVATCode : Char; Virtual; Abstract;
    Procedure SetVATCode (Value : Char); Virtual; Abstract;
    Function GetHistoryAnalysisMode : Byte; Virtual; Abstract;
    Procedure SetHistoryAnalysisMode (Value : Byte); Virtual; Abstract;
    Function GetListScaleMode : Byte; Virtual; Abstract;
    Procedure SetListScaleMode (Value : Byte); Virtual; Abstract;
    Function GetWasNew : Boolean; Virtual; Abstract;
    Procedure SetWasNew (Value : Boolean); Virtual; Abstract;
    Function GetUseORate : Byte; Virtual; Abstract;
    Procedure SetUseORate (Value : Byte); Virtual; Abstract;
    Function GetDefaultGLCode : LongInt; Virtual; Abstract;
    Procedure SetDefaultGLCode (Value : LongInt); Virtual; Abstract;
    Function GetInclusiveVATCode : Char; Virtual; Abstract;
    Procedure SetInclusiveVATCode (Value : Char); Virtual; Abstract;
    Function GetDefSettleDisc : Double; Virtual; Abstract;
    Procedure SetDefSettleDisc (Value : Double); Virtual; Abstract;
    Function GetTransactionType : Byte; Virtual; Abstract;
    Procedure SetTransactionType (Value : Byte); Virtual; Abstract;
    Function GetSalesLine : TAbsTelesalesLine; Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property teCustCode : cuStr6 Read GetCustCode Write SetCustCode;
{02} Property teCurrency : Byte Read GetCurrency Write SetCurrency;
{03} Property teCompanyRate : Real Read GetCompanyRate Write SetCompanyRate;
{04} Property teDailyRate : Real Read GetDailyRate Write SetDailyRate;
{05} Property teYourRef : cuStr10 Read GetYourRef Write SetYourRef;
{06} Property teAltRef : cuStr20 Read GetAltRef Write SetAltRef;
{07} Property teCostCentre : cuStr3 Read GetCostCentre Write SetCostCentre;
{08} Property teDepartment : cuStr3 Read GetDepartment Write SetDepartment;
{09} Property teLocation : cuStr3 Read GetLocation Write SetLocation;
{10} Property teJobCode : cuStr10 Read GetJobCode Write SetJobCode;
{11} Property teJobAnal : cuStr10 Read GetJobAnal Write SetJobAnal;
{12} Property teDelAddr[Index : cuAddrIndex] : cuStr30 Read GetDelAddr Write SetDelAddr;
{13} Property teTransDate : cuLongDate Read GetTransDate Write SetTransDate;
{14} Property teDueDate : cuLongDate Read GetDueDate Write SetDueDate;
{15} Property teNetTotal : Double Read GetNetTotal Write SetNetTotal;
{16} Property teVATTotal : Double Read GetVATTotal Write SetVATTotal;
{17} Property teTotalDiscount : Double Read GetTotalDiscount Write SetTotalDiscount;
{18} Property teUser : cuStr10 Read GetUser Write SetUser;
{19} Property teInProgress : Boolean Read GetInProgress Write SetInProgress;
{20} Property teTransportNature : Byte Read GetTransportNature Write SetTransportNature;
{21} Property teTransportMode : Byte Read GetTransportMode Write SetTransportMode;
{22} Property teSSDDelTerms : cuStr3 Read GetDelTerms Write SetDelTerms;
{23} Property teControlGL : LongInt Read GetControlGL Write SetControlGL;
{24} Property teVATCode : Char Read GetVATCode Write SetVATCode;
{25} Property teHistoryAnalysisMode : Byte Read GetHistoryAnalysisMode Write SetHistoryAnalysisMode;
{26} Property teListScaleMode : Byte Read GetListScaleMode Write SetListScaleMode;
{28} Property tewasNew : Boolean Read GetWasNew Write SetWasNew;
{29} Property teUseORate : Byte read GetUseORate Write SetUseORate;
{30} Property teDefaultGLCode : LongInt Read GetDefaultGLCode Write SetDefaultGLCode;
{31} Property teInclusiveVATCode : Char Read GetInclusiveVATCode Write SetInclusiveVATCode;
{32} Property teDefSettleDisc : Double Read GetDefSettleDisc Write SetDefSettleDisc;
{33} Property teTransactionType : Byte Read GetTransactionType Write SetTransactionType;
{34} Property teSalesLine: TAbsTelesalesLine Read GetSalesLine;
  End; { TAbsTelesales }

  //------------------------------

  // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
  TAbsTelesales2 = Class(TAbsTelesales)
  Protected
    Function GetDeliveryPostCode : cuStr20; Virtual; Abstract;
    Procedure SetDeliveryPostCode (Value : cuStr20); Virtual; Abstract;
  Public
{35} Property teDeliveryPostCode : cuStr20 Read GetDeliveryPostCode Write SetDeliveryPostCode;
  End; // TAbsTelesales2

  //------------------------------

  // MH 26/11/2014: Added new field for Delivery Country Code
  TAbsTelesales3 = Class(TAbsTelesales2)
  Protected
    Function GetDeliveryCountry : cuStr2; Virtual; Abstract;
    Procedure SetDeliveryCountry (Value : cuStr2); Virtual; Abstract;
  Public
{36} Property teDeliveryCountry : cuStr2 Read GetDeliveryCountry Write SetDeliveryCountry;
  End; // TAbsTelesales3

  //------------------------------

  // MH 20/01/2016 Exch2016-R1: Intrastat enhancements
  TAbsTelesales4 = Class(TAbsTelesales3)
  Protected
    Function GetSSDProcess : Char; Virtual; Abstract;
    Procedure SetSSDProcess (Value : Char); Virtual; Abstract;
  Public
{37} Property teSSDProcess : Char Read GetSSDProcess Write SetSSDProcess;
  End; // TAbsTelesales4

{-----------------------------------------------------------------------------}

  { v5.00 User Profile support added }
  TAbsUserProfile = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function GetUserId : cuStr10; Virtual; Abstract;
    Procedure SetUserId (Value : cuStr10); Virtual; Abstract;
    Function GetName : cuStr50; Virtual; Abstract;
    Procedure SetName (Value : cuStr50); Virtual; Abstract;
    Function GetEmail : cuStr100; Virtual; Abstract;
    Procedure SetEmail (Value : cuStr100); Virtual; Abstract;
    Function GetLockOutMins : SmallInt; Virtual; Abstract;
    Procedure SetLockOutMins (Value : SmallInt); Virtual; Abstract;
    Function GetDefSRICust : cuStr6; Virtual; Abstract;
    Procedure SetDefSRICust (Value : cuStr6); Virtual; Abstract;
    Function GetDefPPISupp : cuStr6; Virtual; Abstract;
    Procedure SetDefPPISupp (Value : cuStr6); Virtual; Abstract;
    Function GetDefCostCentre : cuStr3; Virtual; Abstract;
    Procedure SetDefCostCentre (Value : cuStr3); Virtual; Abstract;
    Function GetDefDepartment : cuStr3; Virtual; Abstract;
    Procedure SetDefDepartment (Value : cuStr3); Virtual; Abstract;
    Function GetDefCCDeptRule : SmallInt; Virtual; Abstract;
    Procedure SetDefCCDeptRule (Value : SmallInt); Virtual; Abstract;
    Function GetDefLocation : cuStr3; Virtual; Abstract;
    Procedure SetDefLocation (Value : cuStr3); Virtual; Abstract;
    Function GetDefLocRule : SmallInt; Virtual; Abstract;
    Procedure SetDefLocRule (Value : SmallInt); Virtual; Abstract;
    Function GetDefSalesBankGL : LongInt; Virtual; Abstract;
    Procedure SetDefSalesBankGL (Value : LongInt); Virtual; Abstract;
    Function GetDefPurchBankGL : LongInt; Virtual; Abstract;
    Procedure SetDefPurchBankGL (Value : LongInt); Virtual; Abstract;
    Function GetMaxSalesAuth : Double; Virtual; Abstract;
    Procedure SetMaxSalesAuth (Value : Double); Virtual; Abstract;
    Function GetMaxPurchAuth : Double; Virtual; Abstract;
    Procedure SetMaxPurchAuth (Value : Double); Virtual; Abstract;
    Function GetReportPrinter : cuStr50; Virtual; Abstract;
    Procedure SetReportPrinter (Value : cuStr50); Virtual; Abstract;
    Function GetFormPrinter : cuStr50; Virtual; Abstract;
    Procedure SetFormPrinter (Value : cuStr50); Virtual; Abstract;
    Function GetPwordExpiryMode : Byte; Virtual; Abstract;
    Procedure SetPwordExpiryMode (Value : Byte); Virtual; Abstract;
    Function GetPwordExpiryDays : SmallInt; Virtual; Abstract;
    Procedure SetPwordExpiryDays (Value : SmallInt); Virtual; Abstract;
    Function GetPwordExpiryDate : cuLongDate; Virtual; Abstract;
    Procedure SetPwordExpiryDate (Value : cuLongDate); Virtual; Abstract;
    Function  GetSecurityFlags(Index : SmallInt) : Byte; Virtual; Abstract;
    Procedure SetSecurityFlags(Index : SmallInt; Value : Byte); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

    Property upUserId : cuStr10 Read GetUserId Write SetUserId;
    Property upName : cuStr50 Read GetName Write SetName;
    Property upEmail : cuStr100 Read GetEmail Write SetEmail;
    Property upLockOutMins : SmallInt Read GetLockOutMins Write SetLockOutMins;
    Property upDefSRICust : cuStr6 Read GetDefSRICust Write SetDefSRICust;
    Property upDefPPISupp : cuStr6 Read GetDefPPISupp Write SetDefPPISupp;
    Property upDefCostCentre : cuStr3 Read GetDefCostCentre Write SetDefCostCentre;
    Property upDefDepartment : cuStr3 Read GetDefDepartment Write SetDefDepartment;
    Property upDefCCDeptRule : SmallInt Read GetDefCCDeptRule Write SetDefCCDeptRule;
    Property upDefLocation : cuStr3 Read GetDefLocation Write SetDefLocation;
    Property upDefLocRule : SmallInt Read GetDefLocRule Write SetDefLocRule;
    Property upDefSalesBankGL : LongInt Read GetDefSalesBankGL Write SetDefSalesBankGL;
    Property upDefPurchBankGL : LongInt Read GetDefPurchBankGL Write SetDefPurchBankGL;
    Property upMaxSalesAuth : Double Read GetMaxSalesAuth Write SetMaxSalesAuth;
    Property upMaxPurchAuth : Double Read GetMaxPurchAuth Write SetMaxPurchAuth;
    Property upReportPrinter : cuStr50 Read GetReportPrinter Write SetReportPrinter;
    Property upFormPrinter : cuStr50 Read GetFormPrinter Write SetFormPrinter;
    Property upPwordExpiryMode : Byte Read GetPwordExpiryMode Write SetPwordExpiryMode;
    Property upPwordExpiryDays : SmallInt Read GetPwordExpiryDays Write SetPwordExpiryDays;
    Property upPwordExpiryDate : cuLongDate Read GetPwordExpiryDate Write SetPwordExpiryDate;
    Property upSecurityFlags [Index : SmallInt] : Byte Read GetSecurityFlags Write SetSecurityFlags;
  End; { TAbsUserProfile }

  TAbsUserProfile2 = Class(TAbsUserProfile)
  Protected
    Function GetShowGLCodesInTree : Boolean; Virtual; Abstract;
    Procedure SetShowGLCodesInTree (Value : Boolean); Virtual; Abstract;
  Public
    Property upShowGLCodesInTree : Boolean Read GetShowGLCodesInTree Write SetShowGLCodesInTree;
  end;

  //PR: 12/07/2012 ABSEXCH-12452
  TAbsUserProfile3 = Class(TAbsUserProfile2)
  Protected
    Function GetShowStockCodesInTree : Boolean; Virtual; Abstract;
    Procedure SetShowStockCodesInTree (Value : Boolean); Virtual; Abstract;
    Function GetShowProductTypesInTree : Boolean; Virtual; Abstract;
    Procedure SetShowProductTypesInTree (Value : Boolean); Virtual; Abstract;
  Public
    Property upShowStockCodesInTree : Boolean Read GetShowStockCodesInTree Write SetShowStockCodesInTree;
    Property upShowProductTypesInTree : Boolean Read GetShowProductTypesInTree Write SetShowProductTypesInTree;
  end;

  //-----------------------------------

  // MH 06/09/2017 2017-R2 ABSEXCH-18855: Added new User Profile fields into Customisation
  TAbsUserProfile4 = Class(TAbsUserProfile3)
  Protected
    Function GetWindowsUserID : cuStr100; Virtual; Abstract;
    Procedure SetWindowsUserID (Value : cuStr100); Virtual; Abstract;
  Public
    Property upWindowsUserID : cuStr100 Read GetWindowsUserID Write SetWindowsUserID;
  End; // TAbsUserProfile4

  //-----------------------------------

  //RB 22/11/2017 2018-R1 ABSEXCH-19403: GDPR (POST User Profile Mods) - 8.3.1.1.2 - DLL + COM Customisation Support
  TAbsUserProfile5 = Class(TAbsUserProfile4)
  Protected
    Function GetHighlightPIIFields : Boolean; Virtual; Abstract;
    Procedure SetHighlightPIIFields(aValue: Boolean); Virtual; Abstract;
    Function GetHighlightPIIColour : Integer; Virtual; Abstract;
    Procedure SetHighlightPIIColour(aValue: Integer); Virtual; Abstract;
  Public
    Property upHighlightPIIFields: Boolean Read GetHighlightPIIFields Write SetHighlightPIIFields;
    Property upHighlightPIIColour: Integer Read GetHighlightPIIColour Write SetHighlightPIIColour;
  End; // TAbsUserProfile5

{-----------------------------------------------------------------------------}

  { v5.52 10/09/03: Added new class to include new Bin details }
  TAbsMultiBin = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function GetBinCode : cuStr10; Virtual; Abstract;
    Procedure SetBinCode (Value : cuStr10); Virtual; Abstract;
    Function  GetStockFolio : longint; Virtual; Abstract;
    Procedure SetStockFolio (Value : longint); Virtual; Abstract;
    Function  GetPickingPriority : cuStr10; Virtual; Abstract;
    Procedure SetPickingPriority (Value : cuStr10); Virtual; Abstract;
    Function  GetUseByDate : cuStr10; Virtual; Abstract;
    Procedure SetUseByDate (Value : cuStr10); Virtual; Abstract;
    Function  GetUnitOfMeasurement : cuStr10; Virtual; Abstract;
    Procedure SetUnitOfMeasurement (Value : cuStr10); Virtual; Abstract;
    Function  GetAutoPickMode : Smallint; Virtual; Abstract;
    Procedure SetAutoPickMode (Value : Smallint); Virtual; Abstract;
    Function  GetTagNo : Smallint; Virtual; Abstract;
    Procedure SetTagNo (Value : Smallint); Virtual; Abstract;
    Function  GetQty : Double; Virtual; Abstract;
    Procedure SetQty (Value : Double); Virtual; Abstract;
    Function  GetQtyUsed : Double; Virtual; Abstract;
    Procedure SetQtyUsed (Value : Double); Virtual; Abstract;
    Function  GetCapacity : Double; Virtual; Abstract;
    Procedure SetCapacity (Value : Double); Virtual; Abstract;
    Function  GetCostPrice : Double; Virtual; Abstract;
    Procedure SetCostPrice (Value : Double); Virtual; Abstract;
    Function  GetCostPriceCurrency : Smallint; Virtual; Abstract;
    Procedure SetCostPriceCurrency (Value : Smallint); Virtual; Abstract;
    Function  GetSalesPrice : Double; Virtual; Abstract;
    Procedure SetSalesPrice (Value : Double); Virtual; Abstract;
    Function  GetSalesPriceCurrency : Smallint; Virtual; Abstract;
    Procedure SetSalesPriceCurrency (Value : Smallint); Virtual; Abstract;
    Function GetInDate : cuStr8; Virtual; Abstract;
    Procedure SetInDate (Value : cuStr8); Virtual; Abstract;
    Function GetInOrderRef : cuStr10; Virtual; Abstract;
    Procedure SetInOrderRef (Value : cuStr10); Virtual; Abstract;
    Function GetInOrderLine : longint; Virtual; Abstract;
    Procedure SetInOrderLine (Value : longint); Virtual; Abstract;
    Function GetInDocRef : cuStr10; Virtual; Abstract;
    Procedure SetInDocRef (Value : cuStr10); Virtual; Abstract;
    Function GetInDocLine : longint; Virtual; Abstract;
    Procedure SetInDocLine (Value : longint); Virtual; Abstract;
    Function GetInLocation : cuStr10; Virtual; Abstract;
    Procedure SetInLocation (Value : cuStr10); Virtual; Abstract;
    Function GetUsedRec : Boolean; Virtual; Abstract;
    Procedure SetUsedRec (Value : Boolean); Virtual; Abstract;
    Function GetSold : Boolean; Virtual; Abstract;
    Procedure SetSold (Value : Boolean); Virtual; Abstract;
    Function GetOutDate : cuStr8; Virtual; Abstract;
    Procedure SetOutDate (Value : cuStr8); Virtual; Abstract;
    Function GetOutOrderRef : cuStr10; Virtual; Abstract;
    Procedure SetOutOrderRef (Value : cuStr10); Virtual; Abstract;
    Function GetOutOrderLine : longint; Virtual; Abstract;
    Procedure SetOutOrderLine (Value : longint); Virtual; Abstract;
    Function GetOutDocRef : cuStr10; Virtual; Abstract;
    Procedure SetOutDocRef (Value : cuStr10); Virtual; Abstract;
    Function GetOutDocLine : longint; Virtual; Abstract;
    Procedure SetOutDocLine (Value : longint); Virtual; Abstract;
    Function GetOutLocation : cuStr10; Virtual; Abstract;
    Procedure SetOutLocation (Value : cuStr10); Virtual; Abstract;
    Function GetCompanyRate : Double; Virtual; Abstract;
    Procedure SetCompanyRate (Value : Double); Virtual; Abstract;
    Function GetDailyRate : Double; Virtual; Abstract;
    Procedure SetDailyRate (Value : Double); Virtual; Abstract;
    Function GetUseORate : Byte; Virtual; Abstract;
    Procedure SetUseORate (Value : Byte); Virtual; Abstract;
    Function GetTriangulation : TAbsCurrencyTriangulation; Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property brBinCode : cuStr10 Read GetBinCode Write SetBinCode;
{02} Property brStockFolio : longint Read GetStockFolio Write SetStockFolio;
{03} Property brPickingPriority : cuStr10 Read GetPickingPriority Write SetPickingPriority;
{04} Property brUseByDate : cuStr10 Read GetUseByDate Write SetUseByDate;
{05} Property brUnitOfMeasurement : cuStr10 Read GetUnitOfMeasurement Write SetUnitOfMeasurement;
{06} Property brAutoPickMode : Smallint Read GetAutoPickMode Write SetAutoPickMode;
{07} Property brTagNo : SmallInt Read GetTagNo Write SetTagNo;

{08} Property brQty : Double Read GetQty Write SetQty;
{09} Property brQtyUsed : Double Read GetQtyUsed Write SetQtyUsed;
{10} Property brCapacity : Double Read GetCapacity Write SetCapacity;

{11} Property brCostPrice : Double Read GetCostPrice Write SetCostPrice;
{12} Property brCostPriceCurrency : Smallint Read GetCostPriceCurrency Write SetCostPriceCurrency;
{13} Property brSalesPrice : Double Read GetSalesPrice Write SetSalesPrice;
{14} Property brSalesPriceCurrency : Smallint Read GetSalesPriceCurrency Write SetSalesPriceCurrency;

{15} Property brInDate : cuStr8 Read GetInDate Write SetInDate;
{16} Property brInOrderRef : cuStr10 Read GetInOrderRef Write SetInOrderRef;
{17} Property brInOrderLine : longint Read GetInOrderLine Write SetInOrderLine;
{18} Property brInDocRef : cuStr10 Read GetInDocRef Write SetInDocRef;
{19} Property brInDocLine : longint Read GetInDocLine Write SetInDocLine;
{20} Property brInLocation : cuStr10 Read GetInLocation Write SetInLocation;

{21} Property brUsedRec : Boolean Read GetUsedRec Write SetUsedRec;
{22} Property brSold : Boolean Read GetSold Write SetSold;
{23} Property brOutDate : cuStr8 Read GetOutDate Write SetOutDate;
{24} Property brOutOrderRef : cuStr10 Read GetOutOrderRef Write SetOutOrderRef;
{25} Property brOutOrderLine : longint Read GetOutOrderLine Write SetOutOrderLine;
{26} Property brOutDocRef : cuStr10 Read GetOutDocRef Write SetOutDocRef;
{27} Property brOutDocLine : longint Read GetOutDocLine Write SetOutDocLine;
{28} Property brOutLocation : cuStr10 Read GetOutLocation Write SetOutLocation;

{29} Property brCompanyRate : Double Read GetCompanyRate Write SetCompanyRate;
{30} Property brDailyRate : Double Read GetDailyRate Write SetDailyRate;
{31} Property brUseORate : Byte Read GetUseORate Write SetUseORate;
{32} Property brTriangulation : TAbsCurrencyTriangulation Read GetTriangulation;
  End; { TAbsMultiBin }

  //------------------------------

  TAbsMultiBin2 = Class(TAbsMultiBin)
  Protected
    Function GetReturned : Boolean; Virtual; Abstract;
    Procedure SetReturned (Value : Boolean); Virtual; Abstract;
  Public
{33} Property brReturned : Boolean Read GetReturned Write SetReturned;
  End; // TAbsMultiBin2

//-------------------------------------------------------------------------

  // v5.70 - Added Location Object
  TAbsLocation = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function GetCode : cuStr3; Virtual; Abstract;
    Procedure SetCode (Value : cuStr3); Virtual; Abstract;
    Function GetName : cuStr45; Virtual; Abstract;
    Procedure SetName (Value : cuStr45); Virtual; Abstract;
    Function  GetAddr(Index : cuAddrIndex) : cuStr30; Virtual; Abstract;
    Procedure SetAddr(Index : cuAddrIndex; Value : cuStr30); Virtual; Abstract;
    Function GetPhone : cuStr25; Virtual; Abstract;
    Procedure SetPhone (Value : cuStr25); Virtual; Abstract;
    Function GetFax : cuStr25; Virtual; Abstract;
    Procedure SetFax (Value : cuStr25); Virtual; Abstract;
    Function GetEmailAddr : cuStr100; Virtual; Abstract;
    Procedure SetEmailAddr (Value : cuStr100); Virtual; Abstract;
    Function GetModem : cuStr25; Virtual; Abstract;
    Procedure SetModem (Value : cuStr25); Virtual; Abstract;
    Function GetContact : cuStr30; Virtual; Abstract;
    Procedure SetContact (Value : cuStr30); Virtual; Abstract;
    Function GetCurrency : cuCurrencyType; Virtual; Abstract;
    Procedure SetCurrency (Value : cuCurrencyType); Virtual; Abstract;
    Function GetArea : cuStr5; Virtual; Abstract;
    Procedure SetArea (Value : cuStr5); Virtual; Abstract;
    Function GetRep : cuStr5; Virtual; Abstract;
    Procedure SetRep (Value : cuStr5); Virtual; Abstract;
    Function GetTagged : Boolean; Virtual; Abstract;
    Procedure SetTagged (Value : Boolean); Virtual; Abstract;
    Function GetCostCentre : cuStr3; Virtual; Abstract;
    Procedure SetCostCentre (Value : cuStr3); Virtual; Abstract;
    Function GetDepartment : cuStr3; Virtual; Abstract;
    Procedure SetDepartment (Value : cuStr3); Virtual; Abstract;
    Function GetOverrideSalesPrice : Boolean; Virtual; Abstract;
    Procedure SetOverrideSalesPrice (Value : Boolean); Virtual; Abstract;
    Function GetOverrideGLCodes : Boolean; Virtual; Abstract;
    Procedure SetOverrideGLCodes (Value : Boolean); Virtual; Abstract;
    Function GetOverrideCCDept : Boolean; Virtual; Abstract;
    Procedure SetOverrideCCDept (Value : Boolean); Virtual; Abstract;
    Function GetOverrideSupplier : Boolean; Virtual; Abstract;
    Procedure SetOverrideSupplier (Value : Boolean); Virtual; Abstract;
    Function GetOverrideBinLocation : Boolean; Virtual; Abstract;
    Procedure SetOverrideBinLocation (Value : Boolean); Virtual; Abstract;
    Function GetSalesGL : LongInt; Virtual; Abstract;
    Procedure SetSalesGL (Value : LongInt); Virtual; Abstract;
    Function GetCostOfSalesGL : LongInt; Virtual; Abstract;
    Procedure SetCostOfSalesGL (Value : LongInt); Virtual; Abstract;
    Function GetPandLGL : LongInt; Virtual; Abstract;
    Procedure SetPandLGL (Value : LongInt); Virtual; Abstract;
    Function GetBalSheetGL : LongInt; Virtual; Abstract;
    Procedure SetBalSheetGL (Value : LongInt); Virtual; Abstract;
    Function GetWIPGL : LongInt; Virtual; Abstract;
    Procedure SetWIPGL (Value : LongInt); Virtual; Abstract;
    Function GetPurchaseReturnGL : LongInt; Virtual; Abstract;
    Procedure SetPurchaseReturnGL (Value : LongInt); Virtual; Abstract;
    Function GetSalesReturnGL : LongInt; Virtual; Abstract;
    Procedure SetSalesReturnGL (Value : LongInt); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property loCode : cuStr3 Read GetCode Write SetCode;
{02} Property loName : cuStr45 Read GetName Write SetName;
{03} Property loAddress[Index : cuAddrIndex] : cuStr30 Read GetAddr Write SetAddr;
{04} Property loPhone : cuStr25 Read GetPhone Write SetPhone;
{05} Property loFax : cuStr25 Read GetFax Write SetFax;
{06} Property loEmailAddr : cuStr100 Read GetEmailAddr Write SetEmailAddr;
{07} Property loModem : cuStr25 Read GetModem Write SetModem;
{08} Property loContact : cuStr30 Read GetContact Write SetContact;
{09} Property loCurrency : cuCurrencyType Read GetCurrency Write SetCurrency;
{10} Property loArea : cuStr5 Read GetArea Write SetArea;
{11} Property loRep : cuStr5 Read GetRep Write SetRep;
{12} Property loTagged : Boolean Read GetTagged Write SetTagged;
{13} Property loCostCentre : cuStr3 Read GetCostCentre Write SetCostCentre;
{14} Property loDepartment : cuStr3 Read GetDepartment Write SetDepartment;
{15} Property loOverrideSalesPrice : Boolean Read GetOverrideSalesPrice Write SetOverrideSalesPrice;
{16} Property loOverrideGLCodes : Boolean Read GetOverrideGLCodes Write SetOverrideGLCodes;
{17} Property loOverrideCCDept : Boolean Read GetOverrideCCDept Write SetOverrideCCDept;
{18} Property loOverrideSupplier : Boolean Read GetOverrideSupplier Write SetOverrideSupplier;
{19} Property loOverrideBinLocation : Boolean Read GetOverrideBinLocation Write SetOverrideBinLocation;
{20} Property loSalesGL : LongInt Read GetSalesGL Write SetSalesGL;
{21} Property loCostOfSalesGL : LongInt Read GetCostOfSalesGL Write SetCostOfSalesGL;
{22} Property loPandLGL : LongInt Read GetPandLGL Write SetPandLGL;
{23} Property loBalSheetGL : LongInt Read GetBalSheetGL Write SetBalSheetGL;
{24} Property loWIPGL : LongInt Read GetWIPGL Write SetWIPGL;
{25} Property loPurchaseReturnGL : LongInt Read GetPurchaseReturnGL Write SetPurchaseReturnGL;
{26} Property loSalesReturnGL : LongInt Read GetSalesReturnGL Write SetSalesReturnGL;
  End; // TAbsLocation

//-------------------------------------------------------------------------

  // v5.70 - Added Stock-Location Object
  TAbsStockLocation = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function GetStockCode : cuStr16; Virtual; Abstract;
    Procedure SetStockCode (Value : cuStr16); Virtual; Abstract;
    Function GetLocationCode : cuStr3; Virtual; Abstract;
    Procedure SetLocationCode (Value : cuStr3); Virtual; Abstract;
    Function GetQtyInStock : Double; Virtual; Abstract;
    Procedure SetQtyInStock (Value : Double); Virtual; Abstract;
    Function GetQtyOnOrder : Double; Virtual; Abstract;
    Procedure SetQtyOnOrder (Value : Double); Virtual; Abstract;
    Function GetQtyAllocated : Double; Virtual; Abstract;
    Procedure SetQtyAllocated (Value : Double); Virtual; Abstract;
    Function GetQtyPicked : Double; Virtual; Abstract;
    Procedure SetQtyPicked (Value : Double); Virtual; Abstract;
    Function GetQtyMin : Double; Virtual; Abstract;
    Procedure SetQtyMin (Value : Double); Virtual; Abstract;
    Function GetQtyMax : Double; Virtual; Abstract;
    Procedure SetQtyMax (Value : Double); Virtual; Abstract;
    Function GetQtyFreeze : Double; Virtual; Abstract;
    Procedure SetQtyFreeze (Value : Double); Virtual; Abstract;
    Function GetReorderQty : Double; Virtual; Abstract;
    Procedure SetReorderQty (Value : Double); Virtual; Abstract;
    Function GetReorderCur : cuCurrencyType; Virtual; Abstract;
    Procedure SetReorderCur (Value : cuCurrencyType); Virtual; Abstract;
    Function GetReorderPrice : Double; Virtual; Abstract;
    Procedure SetReorderPrice (Value : Double); Virtual; Abstract;
    Function GetReorderDate : cuLongDate; Virtual; Abstract;
    Procedure SetReorderDate (Value : cuLongDate); Virtual; Abstract;
    Function GetReorderCostCentre : cuStr3; Virtual; Abstract;
    Procedure SetReorderCostCentre (Value : cuStr3); Virtual; Abstract;
    Function GetReorderDepartment : cuStr3; Virtual; Abstract;
    Procedure SetReorderDepartment (Value : cuStr3); Virtual; Abstract;
    Function GetCostCentre : cuStr3; Virtual; Abstract;
    Procedure SetCostCentre (Value : cuStr3); Virtual; Abstract;
    Function GetDepartment : cuStr3; Virtual; Abstract;
    Procedure SetDepartment (Value : cuStr3); Virtual; Abstract;
    Function GetBinLocation : cuStr10; Virtual; Abstract;
    Procedure SetBinLocation (Value : cuStr10); Virtual; Abstract;
    Function GetCostPriceCur : cuCurrencyType; Virtual; Abstract;
    Procedure SetCostPriceCur (Value : cuCurrencyType); Virtual; Abstract;
    Function GetCostPrice : Double; Virtual; Abstract;
    Procedure SetCostPrice (Value : Double); Virtual; Abstract;
    Function GetBelowMinLevel : Boolean; Virtual; Abstract;
    Procedure SetBelowMinLevel (Value : Boolean); Virtual; Abstract;
    Function GetSuppTemp : cuStr6; Virtual; Abstract;
    Procedure SetSuppTemp (Value : cuStr6); Virtual; Abstract;
    Function GetSupplier : cuStr6; Virtual; Abstract;
    Procedure SetSupplier (Value : cuStr6); Virtual; Abstract;
    Function GetLastUsed : cuLongDate; Virtual; Abstract;
    Procedure SetLastUsed (Value : cuLongDate); Virtual; Abstract;
    Function GetQtyPosted : Double; Virtual; Abstract;
    Procedure SetQtyPosted (Value : Double); Virtual; Abstract;
    Function GetQtyStockTake : Double; Virtual; Abstract;
    Procedure SetQtyStockTake (Value : Double); Virtual; Abstract;
    Function GetTimeChange : cuStr6; Virtual; Abstract;
    Procedure SetTimeChange (Value : cuStr6); Virtual; Abstract;
    Function GetSalesGL : LongInt; Virtual; Abstract;
    Procedure SetSalesGL (Value : LongInt); Virtual; Abstract;
    Function GetCostOfSalesGL : LongInt; Virtual; Abstract;
    Procedure SetCostOfSalesGL (Value : LongInt); Virtual; Abstract;
    Function GetPandLGL : LongInt; Virtual; Abstract;
    Procedure SetPandLGL (Value : LongInt); Virtual; Abstract;
    Function GetBalSheetGL : LongInt; Virtual; Abstract;
    Procedure SetBalSheetGL (Value : LongInt); Virtual; Abstract;
    Function GetWIPGL : LongInt; Virtual; Abstract;
    Procedure SetWIPGL (Value : LongInt); Virtual; Abstract;
    Function  GetSaleBandsCcy (Index : cuSalesBandIndex) : cuCurrencyType; Virtual; Abstract;
    Procedure SetSaleBandsCcy(Index : cuSalesBandIndex; Value : cuCurrencyType); Virtual; Abstract;
    Function  GetSaleBandsPrice (Index : cuSalesBandIndex) : Real; Virtual; Abstract;
    Procedure SetSaleBandsPrice(Index : cuSalesBandIndex; Value : Real); Virtual; Abstract;
    Function GetQtyFree : Double; Virtual; Abstract;
    Function GetPurchaseReturnGL : LongInt; Virtual; Abstract;
    Procedure SetPurchaseReturnGL (Value : LongInt); Virtual; Abstract;
    Function GetPurchaseReturnQty : Double; Virtual; Abstract;
    Procedure SetPurchaseReturnQty (Value : Double); Virtual; Abstract;
    Function GetManufacturerWarrantyLength : Byte; Virtual; Abstract;
    Procedure SetManufacturerWarrantyLength (Value : Byte); Virtual; Abstract;
    Function GetManufacturerWarrantyUnits : TStockWarrantyUnits; Virtual; Abstract;
    Procedure SetManufacturerWarrantyUnits (Value : TStockWarrantyUnits); Virtual; Abstract;
    Function GetRestockCharge : Double; Virtual; Abstract;
    Procedure SetRestockCharge (Value : Double); Virtual; Abstract;
    Function GetSalesReturnGL : LongInt; Virtual; Abstract;
    Procedure SetSalesReturnGL (Value : LongInt); Virtual; Abstract;
    Function GetSalesReturnQty : Double; Virtual; Abstract;
    Procedure SetSalesReturnQty (Value : Double); Virtual; Abstract;
    Function GetSalesWarrantyLength : Byte; Virtual; Abstract;
    Procedure SetSalesWarrantyLength (Value : Byte); Virtual; Abstract;
    Function GetSalesWarrantyUnits : TStockWarrantyUnits; Virtual; Abstract;
    Procedure SetSalesWarrantyUnits (Value : TStockWarrantyUnits); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property slStockCode : cuStr16 Read GetStockCode Write SetStockCode;
{02} Property slLocationCode : cuStr3 Read GetLocationCode Write SetLocationCode;
{03} Property slQtyInStock : Double Read GetQtyInStock Write SetQtyInStock;
{04} Property slQtyOnOrder : Double Read GetQtyOnOrder Write SetQtyOnOrder;
{05} Property slQtyAllocated : Double Read GetQtyAllocated Write SetQtyAllocated;
{06} Property slQtyPicked : Double Read GetQtyPicked Write SetQtyPicked;
{07} Property slQtyMin : Double Read GetQtyMin Write SetQtyMin;
{08} Property slQtyMax : Double Read GetQtyMax Write SetQtyMax;
{09} Property slQtyFreeze : Double Read GetQtyFreeze Write SetQtyFreeze;
{10} Property slReorderQty : Double Read GetReorderQty Write SetReorderQty;
{11} Property slReorderCur : cuCurrencyType Read GetReorderCur Write SetReorderCur;
{12} Property slReorderPrice : Double Read GetReorderPrice Write SetReorderPrice;
{13} Property slReorderDate : cuLongDate Read GetReorderDate Write SetReorderDate;
{14} Property slReorderCostCentre : cuStr3 Read GetReorderCostCentre Write SetReorderCostCentre;
{15} Property slReorderDepartment : cuStr3 Read GetReorderDepartment Write SetReorderDepartment;
{16} Property slCostCentre : cuStr3 Read GetCostCentre Write SetCostCentre;
{17} Property slDepartment : cuStr3 Read GetDepartment Write SetDepartment;
{18} Property slBinLocation : cuStr10 Read GetBinLocation Write SetBinLocation;
{19} Property slCostPriceCur : cuCurrencyType Read GetCostPriceCur Write SetCostPriceCur;
{20} Property slCostPrice : Double Read GetCostPrice Write SetCostPrice;
{21} Property slBelowMinLevel : Boolean Read GetBelowMinLevel Write SetBelowMinLevel;
{22} Property slSuppTemp : cuStr6 Read GetSuppTemp Write SetSuppTemp;
{23} Property slSupplier : cuStr6 Read GetSupplier Write SetSupplier;
{24} Property slLastUsed : cuLongDate Read GetLastUsed Write SetLastUsed;
{25} Property slQtyPosted : Double Read GetQtyPosted Write SetQtyPosted;
{26} Property slQtyStockTake : Double Read GetQtyStockTake Write SetQtyStockTake;
{27} Property slTimeChange : cuStr6 Read GetTimeChange Write SetTimeChange;
{28} Property slSalesGL : LongInt Read GetSalesGL Write SetSalesGL;
{29} Property slCostOfSalesGL : LongInt Read GetCostOfSalesGL Write SetCostOfSalesGL;
{30} Property slPandLGL : LongInt Read GetPandLGL Write SetPandLGL;
{31} Property slBalSheetGL : LongInt Read GetBalSheetGL Write SetBalSheetGL;
{32} Property slWIPGL : LongInt Read GetWIPGL Write SetWIPGL;
{33} Property slSaleBandsCur[Index : cuSalesBandIndex] : cuCurrencyType Read GetSaleBandsCcy Write SetSaleBandsCcy;
{34} Property slSaleBandsPrice[Index : cuSalesBandIndex] : Real Read GetSaleBandsPrice Write SetSaleBandsPrice;
{35} Property slQtyFree : Double Read GetQtyFree;
{36} Property slPurchaseReturnGL : LongInt Read GetPurchaseReturnGL Write SetPurchaseReturnGL;
{37} Property slPurchaseReturnQty : Double Read GetPurchaseReturnQty Write SetPurchaseReturnQty;
{38} Property slManufacturerWarrantyLength : Byte Read GetManufacturerWarrantyLength Write SetManufacturerWarrantyLength;
{39} Property slManufacturerWarrantyUnits : TStockWarrantyUnits Read GetManufacturerWarrantyUnits Write SetManufacturerWarrantyUnits;
{40} Property slRestockCharge : Double Read GetRestockCharge Write SetRestockCharge;
{41} Property slSalesReturnGL : LongInt Read GetSalesReturnGL Write SetSalesReturnGL;
{42} Property slSalesReturnQty : Double Read GetSalesReturnQty Write SetSalesReturnQty;
{43} Property slSalesWarrantyLength : Byte Read GetSalesWarrantyLength Write SetSalesWarrantyLength;
{44} Property slSalesWarrantyUnits : TStockWarrantyUnits Read GetSalesWarrantyUnits Write SetSalesWarrantyUnits;
  End; // TAbsStockLocation

//-------------------------------------------------------------------------

  // v5.70 - Added Paperless Email Object for Print dialog
  TAbsPaperlessEmailAddress = Class(TObject)
  Protected
    Function GetName : cuStr50; Virtual; Abstract;
    Procedure SetName (Value : cuStr50); Virtual; Abstract;
    Function GetAddress : cuStr100; Virtual; Abstract;
    Procedure SetAddress (Value : cuStr100); Virtual; Abstract;
  Public
{01} Property eaName : cuStr50 Read GetName Write SetName;
{02} Property eaAddress : cuStr100 Read GetAddress Write SetAddress;
  End; // TAbsPaperlessEmailAddress

  //------------------------------

  // v5.70 - Added Paperless Email Object for Print dialog
  TAbsPaperlessEmailAddressArray = Class(TObject)
  Protected
    function GetItems(Index: SmallInt): TAbsPaperlessEmailAddress; Virtual; Abstract;
    function GetCount: SmallInt; Virtual; Abstract;
  Public
    property adItems[Index: SmallInt]: TAbsPaperlessEmailAddress read GetItems;
    property adCount: SmallInt read GetCount;

    function AddAddress(const Name: cuStr50; const Address: cuStr100): Integer; Virtual; Abstract;
    procedure Delete(Index: SmallInt); Virtual; Abstract;
    procedure Clear; Virtual; Abstract;
  End; // TAbsPaperlessEmailAddressArray

  //------------------------------

  TAbsPaperlessEmailAttachments = Class(TObject)
  Protected
    function GetItems(Index: SmallInt): cuStr255; Virtual; Abstract;
    Procedure SetItems(Index: SmallInt; Value: cuStr255); Virtual; Abstract;
    function GetCount: SmallInt; Virtual; Abstract;
  Public
    property atItems[Index: SmallInt]: cuStr255 read GetItems write SetItems;
    property atCount: SmallInt read GetCount;

    function Add(const FileName: cuStr255): Integer; Virtual; Abstract;
    procedure Delete(Index: SmallInt); Virtual; Abstract;
    procedure Clear; Virtual; Abstract;
  End; // TAbsPaperlessEmailAttachments

  //------------------------------

  TEmailPriority = (epLow=0, epNormal=1, epHigh=2);

  // v5.70 - Added Paperless Email Object for Print dialog
  TAbsPaperlessEmail = Class(TObject)
  Protected
    Function  GetRecStatus : TRecAccessStatus; Virtual; Abstract;
    Function  GetRecChanged : Boolean; Virtual; Abstract;

    Function GetSenderName : cuStr50; Virtual; Abstract;
    Procedure SetSenderName (Value : cuStr50); Virtual; Abstract;
    Function GetSenderAddress : cuStr50; Virtual; Abstract;
    Procedure SetSenderAddress (Value : cuStr50); Virtual; Abstract;
    Function GetToRecipients : TAbsPaperlessEmailAddressArray; Virtual; Abstract;
    Function GetCCRecipients : TAbsPaperlessEmailAddressArray; Virtual; Abstract;
    Function GetBCCRecipients : TAbsPaperlessEmailAddressArray; Virtual; Abstract;
    Function GetSubject : cuStr255; Virtual; Abstract;
    Procedure SetSubject (Value : cuStr255); Virtual; Abstract;
    Function GetMessageText : ANSIString; Virtual; Abstract;
    Procedure SetMessageText (Value : ANSIString); Virtual; Abstract;
    Function GetAttachments : TAbsPaperlessEmailAttachments; Virtual; Abstract;
    Function GetPriority : TEmailPriority; Virtual; Abstract;
    Procedure SetPriority (Value : TEmailPriority); Virtual; Abstract;
    Function GetCoverSheet : cuStr8; Virtual; Abstract;
    Procedure SetCoverSheet (Value : cuStr8); Virtual; Abstract;
    Function GetSendReader : Boolean; Virtual; Abstract;
    Procedure SetSendReader (Value : Boolean); Virtual; Abstract;
  Public
    Property AccessRights : TRecAccessStatus Read GetRecStatus;
    Property DataChanged  : Boolean Read GetRecChanged;

{01} Property emSenderName : cuStr50 Read GetSenderName Write SetSenderName;
{02} Property emSenderAddress : cuStr50 Read GetSenderAddress Write SetSenderAddress;
{03} Property emToRecipients : TAbsPaperlessEmailAddressArray Read GetToRecipients;
{04} Property emCCRecipients : TAbsPaperlessEmailAddressArray Read GetCCRecipients;
{05} Property emBCCRecipients : TAbsPaperlessEmailAddressArray Read GetBCCRecipients;
{06} Property emSubject : cuStr255 Read GetSubject Write SetSubject;
{07} Property emMessageText : ANSIString Read GetMessageText Write SetMessageText;
{08} Property emAttachments : TAbsPaperlessEmailAttachments Read GetAttachments;
{09} Property emPriority : TEmailPriority Read GetPriority Write SetPriority;
{10} Property emCoverSheet : cuStr8 Read GetCoverSheet Write SetCoverSheet;
{11} Property emSendReader : Boolean Read GetSendReader Write SetSendReader;
  End; // TAbsPaperlessEmail

//------------------------------

  // v5.70 - Added Paperless Object
  TAbsPaperless = Class(TObject)
  Protected
    Function GetRecChanged : Boolean; Virtual; Abstract;

    Function GetEmail : TAbsPaperlessEmail; Virtual; Abstract;
  Public
    Property DataChanged : Boolean Read GetRecChanged;

{01} Property Email : TAbsPaperlessEmail Read GetEmail;
  End; // TAbsPaperless

//-------------------------------------------------------------------------

  { Event Object - passed into DLL whenever an event occurs with }
  { any event specific data, and any global information          }
  TAbsEnterpriseSystem = Class(TObject)
  Protected
    Function GetClassVersion : cuStr8; Virtual; Abstract;
    Function GetCurrencyVer : Byte; Virtual; Abstract;
    Function GetModuleVer : Byte; Virtual; Abstract;
    Function GetAcStkAnalOn : Boolean; Virtual; Abstract;
    Function GetEBusinessOn : Boolean; Virtual; Abstract;
    Function GetJobCostOn : Boolean; Virtual; Abstract;
    Function GetPaperlessOn : Boolean; Virtual; Abstract;
    Function GetRepWrtOn : Boolean; Virtual; Abstract;
    Function GetTelesalesOn : Boolean; Virtual; Abstract;
    Function GetUserName : cuStr8; Virtual; Abstract;

    Function GetCostCentre : TAbsCCDept; Virtual; Abstract;
    Function GetCustomer : TAbsCustomer; Virtual; Abstract;
    Function GetDepartment : TAbsCCDept; Virtual; Abstract;
    Function GetGLCode : TAbsGLCode; Virtual; Abstract;
    Function GetJob : TAbsJob; Virtual; Abstract;
    Function GetSetup : TAbsSetup; Virtual; Abstract;
    Function GetStock : TAbsStock; Virtual; Abstract;
    Function GetSupplier : TAbsCustomer; Virtual; Abstract;
    Function GetTransaction : TAbsInvoice; Virtual; Abstract;
    Function GetMiscData : TAbsMiscData; Virtual; Abstract;
    Function GetUserProfile : TAbsUserProfile; Virtual; Abstract;
  Public
    WinId       : LongInt;           { Window Id }
    HandlerId   : LongInt;           { Handler Id in Window }
    InEditMode  : Boolean;           { Event is during an Add or Edit Flag }
    ValidStatus : Boolean;           { Result of any additional validation }

    { Result Fields }
    BoResult    : Boolean;           { Expose Non Record event result as a boolean }
    DblResult   : Double;            { Expose Non Record event result as a Double }
    IntResult   : LongInt;           { Expose Non Record event result as a LongInt }
    StrResult   : cuStr255;          { Expose Non Record event result as a String }
    VarResult   : Variant;           { Expose Non Record event result as a Variant }
    Property MiscData : TAbsMiscData Read GetMiscData;  { Miscellaneous Data Class }

    { Miscellaneous Properties }
    Property AcStkAnalOn : Boolean Read GetAcStkAnalOn;  { Acc Stock Anal Status: True=Available }
    Property ClassVersion : cuStr8 Read GetClassVersion; { Class Structure Version }
    Property CurrencyVer : Byte Read GetCurrencyVer;     { Currency Version: 0=Prof, 1=Euro, 2=Global }
    Property EBusinessOn : Boolean Read GetEBusinessOn;  { eBusiness Status: True=Available }
    Property JobCostOn : Boolean Read GetJobCostOn;      { Job Costing Status: True=Available }
    Property ModuleVer : Byte Read GetModuleVer;         { Core Modules: 0=Standard, 1=Stock, 2=SPOP }
    Property PaperlessOn : Boolean Read GetPaperlessOn;  { Paperless Status: True=Available }
    Property RepWrtOn : Boolean Read GetRepWrtOn;        { Report Writer Status: True=Available }
    Property TelesalesOn : Boolean Read GetTelesalesOn;  { Telesales Status: True=Available }
    Property UserName : cuStr8 Read GetUserName;         { Logged In User Id }

    { Sub-Classes }
    Property CostCentre : TAbsCCDept Read GetCostCentre;        { Cost Centre Details }
    Property Customer : TAbsCustomer Read GetCustomer;          { Customer Details }
    Property Department : TAbsCCDept Read GetDepartment;        { Department Details }
    Property GLCode : TAbsGLCode Read GetGLCode;                { General Ledger Details }
    Property Job : TAbsJob Read GetJob;                         { Job Details }
    Property Setup : TAbsSetup Read GetSetup;                   { System Setup }
    Property Stock : TAbsStock Read GetStock;                   { Stock Details }
    Property Supplier : TAbsCustomer Read GetSupplier;          { Supplier Details }
    Property Transaction : TAbsInvoice Read GetTransaction;     { Transaction Details }
    Property UserProfile : TAbsUserProfile Read GetUserProfile; { User Profile (v5.00) }

    { Miscellaneous Functions }
    Procedure entActivate; Virtual; Abstract;
    Function entRound(Num : Double; Decs : SmallInt) : Double; Virtual; Abstract;
    Function entGetTaxNo(Vcode   :  Char) : cuVATIndex; Virtual; Abstract;
    Function entCalc_PcntPcnt(PAmount,Pc1,Pc2  :  Real;
                              PCh1,PCh2        :  Char)  :  Real; Virtual; Abstract;
  End; { TAbsEnterpriseSystem }

  //------------------------------

  { Added in Class Version 4.31.002 }
  TAbsEnterpriseSystem01 = Class(TAbsEnterpriseSystem)
    Function GetBatchSerial : TAbsBatchSerial; Virtual; Abstract;
  Public
    Property BatchSerial : TAbsBatchSerial Read GetBatchSerial;
  End; { TAbsEnterpriseSystem01 }

  //------------------------------

  { v5.50 20/02/03 - Added descendant of base Object for new v5.50 sub-objects }
  TAbsEnterpriseSystem02 = Class(TAbsEnterpriseSystem01)
  Protected
    Function GetCustomer2 : TAbsCustomer2; Virtual; Abstract;
    Function GetJobCosting : TAbsJobCosting; Virtual; Abstract;
    Function GetSetup2 : TAbsSetup2; Virtual; Abstract;
    Function GetSupplier2 : TAbsCustomer2; Virtual; Abstract;
    Function GetTelesales : TAbsTelesales; Virtual; Abstract;
    Function GetTransaction2 : TAbsInvoice2; Virtual; Abstract;
  Public
    Property Customer2 : TAbsCustomer2 Read GetCustomer2;
    Property JobCosting : TAbsJobCosting Read GetJobCosting;
    Property Setup2 : TAbsSetup2 Read GetSetup2;
    Property Supplier2 : TAbsCustomer2 Read GetSupplier2;
    Property Telesales : TAbsTelesales Read GetTelesales;
    Property Transaction2 : TAbsInvoice2 Read GetTransaction2;
  End; { TAbsEnterpriseSystem02 }

  //------------------------------

  { v5.52 10/09/03 - Added descendant of base Object for new v5.52 sub-objects }
  TAbsEnterpriseSystem03 = Class(TAbsEnterpriseSystem02)
  Protected
    Function GetBatchSerial2 : TAbsBatchSerial2; Virtual; Abstract;
    Function GetBin : TAbsMultiBin; Virtual; Abstract;
    Function GetSetup3 : TAbsSetup3; Virtual; Abstract;
    Function GetStock2 : TAbsStock2; Virtual; Abstract;
  Public
    Property BatchSerial2 : TAbsBatchSerial2 Read GetBatchSerial2;
    Property Bin : TAbsMultiBin Read GetBin;
    Property Setup3 : TAbsSetup3 Read GetSetup3;
    Property Stock2 : TAbsStock2 Read GetStock2;
  End; { TAbsEnterpriseSystem03 }

  //------------------------------

  // v5.70 - Added Goods Returns support and the Location & Stock-Location objects
  TAbsEnterpriseSystem04 = Class(TAbsEnterpriseSystem03)
  Protected
    Function GetBatchSerial3 : TAbsBatchSerial3; Virtual; Abstract;
    Function GetBin2 : TAbsMultiBin2; Virtual; Abstract;
    Function GetLocation : TAbsLocation; Virtual; Abstract;
    Function GetPaperless : TAbsPaperless; Virtual; Abstract;
    Function GetStock3 : TAbsStock3; Virtual; Abstract;
    Function GetStockLocation : TAbsStockLocation; Virtual; Abstract;
  Public
    Property BatchSerial3 : TAbsBatchSerial3 Read GetBatchSerial3;
    Property Bin2 : TAbsMultiBin2 Read GetBin2;
    Property Location : TAbsLocation Read GetLocation;
    Property Paperless : TAbsPaperless Read GetPaperless;
    Property Stock3 : TAbsStock3 Read GetStock3;
    Property StockLocation : TAbsStockLocation Read GetStockLocation;
  End; // TAbsEnterpriseSystem04

  //------------------------------

  // v6.01 - 08/05/09 - Added new function to support Advanced Discounts fields
  TAbsEnterpriseSystem05 = Class(TAbsEnterpriseSystem04)
  Protected
  Public
    Function entCalc_PcntPcntAD(Amount             : Double;   // Net Value
                                Discount           : Double;   // Line Discount
                                DiscountChr        : Char;     // Line Discount Flag
                                Discount2          : Double;   // Line Discount 2 (Multi-Buy)
                                Discount2Chr       : Char;     // Line Discount 2 Flag
                                Discount3          : Double;   // Line Discount 3 (TTD/VBD)
                                Discount3Chr       : Char;     // Line Discount 3 Flag
                                SettleDiscount     : Double;   // Settlement Discount
                                SettleDiscountFlag : Char      // Settlement Discount Flag
                                ) : Double; Virtual; Abstract;
  End; // TAbsEnterpriseSystem04

  //------------------------------

  // v6.9 30/11/2011 - added new user defined fields
  TAbsEnterpriseSystem06 = Class(TAbsEnterpriseSystem05)
  Protected
    Function GetCustomer3 : TAbsCustomer3; Virtual; Abstract;
    Function GetSetup4 : TAbsSetup9; Virtual; Abstract;
    Function GetStock4 : TAbsStock4; Virtual; Abstract;
    Function GetSupplier3 : TAbsCustomer3; Virtual; Abstract;
    Function GetTransaction3 : TAbsInvoice8; Virtual; Abstract;
    Function GetUserProfile2 : TAbsUserProfile2; Virtual; Abstract;
  Public
    Property Customer3 : TAbsCustomer3 Read GetCustomer3;
    Property Setup4 : TAbsSetup9 Read GetSetup4;
    Property Stock4 : TAbsStock4 Read GetStock4;
    Property Supplier3 : TAbsCustomer3 Read GetSupplier3;
    Property Transaction3 : TAbsInvoice8 Read GetTransaction3;
    Property UserProfile2 : TAbsUserProfile2 Read GetUserProfile2;
  End; // TAbsEnterpriseSystem06

//-------------------------------------------------------------------------

  //v7.0 Added UserProfile3
  TAbsEnterpriseSystem07 = Class(TAbsEnterpriseSystem06)
  protected
    function GetUserProfile3 : TAbsUserProfile3; Virtual; Abstract;
  public
    property UserProfile3 : TAbsUserProfile3 Read GetUserProfile3;
  end;

//-------------------------------------------------------------------------

  //v7.X MRD Added Customer4 & Setup10
  TAbsEnterpriseSystem08 = Class(TAbsEnterpriseSystem07)
  protected
    function GetCustomer4 : TAbsCustomer4; Virtual; Abstract;
    function GetSetup10 : TAbsSetup10; Virtual; Abstract;
    function GetSupplier4 : TAbsCustomer4; Virtual; Abstract;
  public
    property Customer4 : TAbsCustomer4 read GetCustomer4;
    property Setup10 : TAbsSetup10 read GetSetup10;
    property Supplier4 : TAbsCustomer4 read GetSupplier4;
  end;

  //HV 09/02/2018 2017R1 ABSEXCH-19407: Extended UserProfile and GDPR License support in Plug-in.
  TAbsEnterpriseSystem09 = Class(TAbsEnterpriseSystem08)
  protected
    Function GetUserProfile5 : TAbsUserProfile5; Virtual; Abstract;
    Function GetGDPROnLicense : Boolean; Virtual; Abstract;
  public
    Property UserProfile5: TAbsUserProfile5 Read GetUserProfile5;
    Property GDPROnLicense: Boolean Read GetGDPROnLicense;  { GDPROnLicense Status: True=Available }
  end;


implementation


end.

