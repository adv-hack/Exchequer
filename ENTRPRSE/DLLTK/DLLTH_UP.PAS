UNIT Dllth_Up;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/07/93                      }
{                                                              }
{                     Internal Export Modeule                  }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

Interface

Uses
  Classes,
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3,
  Dialogs,
  ExWrap1U;

const
  B_CopyOnly = -27;
  DESC_LINE_NUMBER = -1999999999;

FUNCTION EX_GETTRANS(P              :  POINTER;
                     PLINES         :  POINTER;
                     PSIZE          :  LONGINT;
                     PLSIZE         :  LONGINT;
                     SEARCHKEY      :  PCHAR;
                     SEARCHPATH     :  SMALLINT;
                     SEARCHMODE     :  SMALLINT;
                     LOCK           :  WORDBOOL) : SMALLINT;
                     {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETEBUSTRANS(P              :  POINTER;
                         PLINES         :  POINTER;
                         PSIZE          :  LONGINT;
                         PLSIZE         :  LONGINT;
                         SEARCHKEY      :  PCHAR;
                         SEARCHPATH     :  SMALLINT;
                         SEARCHMODE     :  SMALLINT;
                         LOCK           :  WORDBOOL) : SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETTRANSHED(P              :  POINTER;
                        PSIZE          :  LONGINT;
                        SEARCHKEY      :  PCHAR;
                        SEARCHPATH     :  SMALLINT;
                        SEARCHMODE     :  SMALLINT;
                        LOCK           :  WORDBOOL) : SMALLINT;
                        {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETTRANSLINE(PLINE          :  POINTER;
                         PLSIZE         :  LONGINT;
                         SEARCHKEY      :  PCHAR;
                         SEARCHPATH     :  SMALLINT;
                         SEARCHMODE     :  SMALLINT;
                         LOCK           :  WORDBOOL) : SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_STORETRANS(P,
                       PL         :  POINTER;
                       PSIZE,
                       PLSIZE     :  LONGINT;
                       SEARCHPATH :  SMALLINT;
                       SEARCHMODE :  SMALLINT) : SMALLINT;
                       {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_STOREEBUSTRANS(P,
                           PL         :  POINTER;
                           PSIZE,
                           PLSIZE     :  LONGINT;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT) : SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETNEXTTRANSNO(DOCSTR :  PCHAR;
                           NEXTNO :  PCHAR;
                           UPDATE :  WORDBOOL) : SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETTOTALTRANSLINES(DOCREF : PCHAR) : LONGINT;
                               {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_TESTSTK(SEARCHKEY      :  PCHAR;
                    SEARCHPATH     :  SMALLINT;
                    SEARCHMODE     :  SMALLINT;
                    LOCK           :  WORDBOOL) : SMALLINT;
                    {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_ROUNDUP(INPUTVALUE     :  DOUBLE;
                    DECIMALPLACES  :  SMALLINT)  :  DOUBLE;
                    {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETTLLINE(FOLIONUMBER,
                      LINENUMBER  :  LONGINT;
                      PLINE       :  POINTER;
                      PLSIZE      :  LONGINT)  :  SMALLINT;
                      {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETTHBYFOLIO(FOLIONUMBER :  LONGINT;
                         P           :  POINTER;
                         PSIZE       :  LONGINT)  :  SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETTHBYRUNNO(P          :  POINTER;
                         PSIZE      :  LONGINT;
                         RUNNO      :  LONGINT;
                         SEARCHMODE :  SMALLINT;
                         LOCK       :  WORDBOOL) : SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION STORETH(P          :  POINTER;
                 PSIZE      :  SMALLINT;
                 SEARCHPATH :  SMALLINT;
                 UPDATEMODE :  SMALLINT;
                 AUTHCODE   :  LONGINT)  :  SMALLINT;
                 {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETLINETOTAL(P      : POINTER;
                         PSize  : SMALLINT;
                         UseDiscount : WORDBOOL;
                         SettleDisc : double;
                         var LineTotal : double): smallint;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_CALCLINETAX(P          : POINTER;
                        PSIZE      : SMALLINT;
                        SETTLEDISC : DOUBLE): SMALLINT;
                        {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETCORRECTVATCODE(P : POINTER; PSize : SMALLINT): smallint;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_TRANCANBEUPDATED(DOCREF   :  PCHAR)  :  SMALLINT;
                             {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
{$IFDEF COMTK}
FUNCTION EX_STOREJAPTRANS(P,
                          PL         :  POINTER;
                          PSIZE,
                          PLSIZE     :  LONGINT;
                          SEARCHPATH :  SMALLINT;
                          SEARCHMODE :  SMALLINT;
                      var ExLocal    :  TdExLocal) : SMALLINT;
{$ENDIF}

Type
  {$IFNDEF WIN32}
    SHORTSTRING = STRING;
  {$ENDIF}

  STR4        = STRING[4];


FUNCTION EX_CONVERTFOLIO(FOLIONUMBER  :  LONGINT)  :  SHORTSTRING;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_CONVERTAMOUNT(FROMCURR   :  SMALLINT;
                          TOCURR     :  SMALLINT;
                      VAR AMOUNT     :  DOUBLE;
                          RATETYPE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;


FUNCTION EX_STORETRANSHED(P      : POINTER;
                          PSIZE  : SMALLINT) :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

Function GetActualLineCount(InvFolioNum  :  LongInt)  :  LongInt;

Procedure EX_SETCALCLINECOUNT(WantCount : WordBool);
                          {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_STORETRANSDETL(P      : POINTER;
                           PSIZE  : SMALLINT) :  SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{ 14.06.2000 - For Internal Use Only }
FUNCTION EX_CONV_TCURR(P      : POINTER;
                       PSIZE  : SMALLINT) :  SMALLINT;
                       {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_CALCULATETRANSTOTAL(THOURREF     :  PCHAR;
                                USEVARIANCE  :  WORDBOOL;
                                USEROUNDUP   :  WORDBOOL;
                            VAR TOTALVALUE   :  DOUBLE)  :  SMALLINT;
                                {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{$IFDEF COMTK}
  Function ExInvToInv(ExInvRec     :  TBatchTHRec;
                      AddMode      :  SmallInt;
                  Var OrgInv       :  InvRec;
                  Var EditNo       :  Byte)  :  Integer;

  Function ExInvLineToId(ExIdRec   :  TBatchTLRec;
                         SMode     :  SmallInt)  :  Integer;


  Procedure CopyEntIdToTKId(Const EntId   : IDetail;
                            Var   ExIdRec : TBatchTLRec);

  // Converts an String containing a VAT Code into an Toolkit VAT array index
  Function VatCharToIdx(Index : ShortString) : SmallInt;

  Procedure CopyExInvToTKInv(Const InvR : InvRec; Var ExInvRec  :  TBatchTHRec);
{$ENDIF}

// Added 20/6/00 for Windows Card System
Procedure CS_CHANGEDOCTXLATE (PREDOC, POSTDOC : PCHAR); STDCALL;  EXPORT;

FUNCTION EX_UPDATEDUEDATE(DOCREFNO    :  PCHAR;
                          NEWDUEDATE  :  PCHAR) :  SMALLINT; STDCALL;  EXPORT;

FUNCTION EX_REMOVEDISCOUNTS(P      : POINTER;
                         PSize  : SMALLINT;
                         UseDiscount : WORDBOOL;
                         SettleDisc : double;
                         var LineTotal : double): smallint;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_UPDATEPAYINREF(Const TransRef   : PChar;
                           Const TransLine  : LongInt;
                           Const NewRef     : PChar) : SmallInt;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_UPDATELINEDATE(Const TransRef   : PChar;
                           Const AbsLineNo  : LongInt;
                           Const NewDate    : PChar) : SmallInt;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_RESETLINESERIALCOUNT(Const TransRef   : PChar;
                                 Const AbsLineNo  : LongInt) : SmallInt;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;




Function Calc_IdQty(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;

FUNCTION EX_UPDATECISDATE(DOCREFNO    :  PCHAR;
                          NEWDATE     :  PCHAR) :  SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_RESETADJNOMFLAGS(DOCREFNO    :  PCHAR) :  SMALLINT; STDCALL;  EXPORT;

FUNCTION EX_SETLINEGLCODE(Const iTXFolioNo : LongInt; Const iABSLineNo : LongInt; Const iNewGLCode : LongInt) : SMALLINT; STDCALL; EXPORT;

{$IFDEF GMGSPECIAL}
FUNCTION EX_GMGRESETSTOCKGLS(const DOCREFNO    :  PCHAR) :  SMALLINT; STDCALL;  EXPORT;
{$ENDIF}

function EX_UPDATERECONCILEFLAG(const RecordAddress : longint;
                                const NewValue : SmallInt) : SmallInt;
                                STDCALL  EXPORT;

FUNCTION EX_UPDATEPRINTEDSTATUS(DOCREFNO    :  PCHAR;
                                NEWSTATUS   :  WORDBOOL) :  SMALLINT; STDCALL;  EXPORT;


function CanAddTransType(InvDocHed : DocTypes) : Boolean;

FUNCTION EX_UPDATETXFIELD(Const pTransRef   : PChar;
                          Const iAbsLineNo  : LongInt;
                          Const iFieldNo  : LongInt;
                          Const pNewFieldValue    : PChar) : SmallInt;
                          STDCALL; EXPORT;

PROCEDURE EX_INCLUDEHIDDENLINES(const bInclude : WordBool); STDCALL; EXPORT;

FUNCTION EX_GETLINEVALUE(Const TransRef   : PChar;
                         Const AbsLineNo  : LongInt;
                           var Value      : Double) : SmallInt;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_UPPERCASESTOCKLOCATIONS(Const pTransRef : PChar) : SmallInt; STDCALL; EXPORT;

FUNCTION EX_SETSTOCKLOCATIONS(Const pTransRef : PChar; Const pLocation : PChar) : SmallInt; STDCALL; EXPORT;

function EX_GETVBDVALUE(P,
                        PL         :  POINTER;
                        PSIZE,
                        PLSIZE     :  LONGINT;
                        var VBDValue : Double;
                        var VBDVAT : Double) : Integer;

//PR: 15/10/2009 Undocumented function to update Account Stock Analysis
function EX_UPDATEACSTOCKANAL(iFolioNo : longint; iAbsLineNo : longint) : Integer; STDCALL; EXPORT;

//PR: 18/10/2010 Function to check whether we should be using the thOverrideLocation field
function AllowOverrideLocation(InvDocHed : DocTypes; LineNo : Integer = 0) : Boolean;

procedure SetIgnoreCreditLimit(Value : Boolean);
function GetIgnoreCreditLimit : Boolean;

//PR: 20/05/2011 Added function to return correct VAT exchange rate
//Parameters are: CXRate - the Exchange rates from a transaction line
//                ACurrency - the currency required
Function GetVATExchangeRate(CXRate  :  CurrTypes;
                            ACurrency :  Byte) :  Double;

//PR: 24/05/2011 Added function to return line xrates if available, otherwise system rates
function GetExchangeRate(CXRate  :  CurrTypes;
                            ACurrency :  Byte) :  Double;


//PR: 16/02/2016 v2016 R1 ABSEXCH-17309 Function to default notc flag on trans header
function DefaultNatureOfTransaction(DocType : DocTypes) : Byte;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  SysUtils,
  WinProcs,
  ETStrU,
  ETDateU,
  ETMiscU,
  MiscU,
{$IFDEF WIN32}
  BtrvU2,
  BTSupU1,
  SysU2,
  SysU3,  {* added in v4.31 *}
  ComnU2,
  ComnUnit,
  CurrncyU,
  BtKeys1U,
  InvCtSuU,
  InvLst2U,   {added in v4.31}
  CuStkA3U,   { 06.04.2000 - For Customer Stock Analysis }
  DiscU3U,    { 14.02.2001 - For Calc_StockPrice }
{$ELSE}
  BtrvU16,
  BtSup1,
  BtSup2,
{$ENDIF}
{$IFDEF COMTK}
  MiscFunc,
{$ENDIF}
  FIFOLU,
  BTS1,
  DLLErrU,
  EBusTKit,
  MLocFunc,
{$IFDEF EN551}
  DllMiscU,
{$ENDIF}
  CISFuncs,
  FifoL2U,
  DllSk01U,
  SpDlIntf,
  Dll_Abstl,
  Profile,
  SQLUtils,

  // CJS 2011-08-12 ABSEXCH-11265 - Cached data problem
  {$IFDEF EXDLL}
  CRECache,
  {$ENDIF}
  //PR: 28/10/2011 v6.9
  AuditNotes, AuditNoteIntf,

  Math,
  MathUtil,

  //PR: 28/10/2013 ABSEXCH-14705
  RecordHelperClass,
  TransactionHelperU, //PR: 24/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015

  //PR 23/03/2015 v7.0.14 ABSEXCH-16284
  PromptPaymentDiscountFuncs

  {$IFDEF COMTK},
  JobSup2U,
  JChkUseU,
  TTD,
  TKTTDCalc,
  TTDCalc,
  VBD,
  MultiBuyFuncs,

  //PR: 16/09/2014  v7.x Order Payments - T101
  OrderPaymentsInterfaces,
  oOrderPaymentsTransactionPaymentInfo,
  oOrderPaymentsBaseTransactionInfo,
  oOrderPaymentsTransactionInfo,
  oOPPayment,
  BtSupu2
  {$ENDIF}

  ,CountryCodeUtils, CountryCodes, IntrastatXML, oSystemSetup;


Const

  THVATCode :  Array[0..20] of Char =
  ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');

{  Moved into VarConst.pas
  KeyInvFXlate  :  Array[0..11] of Integer =
                   (InvOurRefK,InvFolioK,InvCustK,InvYrRefK,InvLYRefK,
                   InvRNoK,InvCDueK,InvVATK,InvBatchK,InvDateK,InvYrPrK,InvOSK);

  KeyIDXlate : Array[0..4] of Integer =
                (IdFolioK, IdRunK, IdNomK, IdStkK, IdAnalK);

}
{   InvRNoK    =  0;*
    InvCustK   =  1;   *
    InvOurRefK =  2;   *
    InvFolioK  =  3;   *
    InvCDueK   =  4;*
    InvVATK    =  5;*
    InvYrRefK  =  6;   *
    InvBatchK  =  7;*
    InvLYRefK  =  8;   *
    InvDateK   =  9;*
    InvYrPrK   = 10;*
}
  //PR: Added set of doc types for which Company exchange rate on header and line should NOT be set to 0.
  //PR: 11/11/2015 ABSEXCH-16026 SRC & PPY need to have co rate set to 0
  SetCompanyRateSet = [NMT,TSH,{SRC,PPY,}SRI,PPI];

Var
  CalcTHCost,
  WantCalcLineCount : Boolean;

  TLLineNo          : LongInt;

  HeaderCost,                   { 27.09.2000 - Added to calculate Header Total Cost }
  HeaderWeight      : Double;

  Line1MLoc     : string; //used for WOP to store line 1 stock location

  VatNeededOnNom  : Boolean; //indicates if vat on any of the lines of a nom

  JAPParentFolio    : longint;
  JAPParentType     : DocTypes;
  JAPParentEmployee,
  JAPParentJobCode : string;
  JAPParentStage   : Byte;

  HighLineNo : longint;

  AllowZeroLineNos : Boolean;
  AllowCtrlGLs : Boolean;

  HiddenLinesDeleted : Boolean; //PR 10/03/06 Added to stop hidden lines being deleted more than once

  IncludeHiddenLines : Boolean; //PR 21/04/06 Include hidden bom lines in Get_TransLines

  AddInLocationAdjLines : Boolean; //PR: 18/03/2009 System Switch for Volac to allow in location lines to be automatically added

  {$IFDEF COMTK}
   LineMultiBuyDiscountsList : TStringList; //Used to store list of MBDs passed through from ITransaction.Save
   TTDHelper : TTTDTransactionHelper; //Used to add TTD/VBD discounts
   TTDValue : Double;
   TTDFlag : Char;

   VBDLines : Pointer;
   VBDInvRec : InvRec;
   GlobVBDValue : Double;
   GlobVBDVAT : Double;

  {$ENDIF}
   bHasPurchaseServiceLine : Boolean;

   //PR: 18/11/2010 New flag added at NF's request - run-time only
   IgnoreCreditLimit  : Boolean;

   //PR: 26/01/2011 Store the employee record for a timesheet header, to allow correct checking of time rates on the lines.
   TSHEmployeeRec : EmplType;

//PR: 29/01/2015 ABSEXCH-16096 Keeps a record of payments made for this transaction
  PaymentsMade : Double;

{$IFDEF COMTK}

//PR: 16/09/2014  v7.x Order Payments - T101 Returns the total value of payments maded against the current transaction
function GetPaymentsMade : Double;
var
  iOPPaymentInfo : IOrderPaymentsTransactionPaymentInfo;
  Payment : IOrderPaymentsTransactionPaymentInfoPaymentHeader;
  i : Integer;
begin
  Result := 0;

  iOPPaymentInfo := OPTransactionPaymentInfo(Inv);

  Try
    with iOPPaymentInfo do
    begin
      for i := 0 to oppiPaymentCount - 1 do
      begin
        Payment := oppiPayments[i];
        Result := Result + Payment.opphNetValue;
      end;
    end;
    Result := Round_Up(Result, 2);
  Finally
    iOPPaymentInfo := nil;
  End;
end;

//PR: 16/09/2014  v7.x Order Payments - T101 Checks trans total against payments made - returns true
//                                           if payment total > trans total
function TransactionNeedsRefund : Boolean;
var
  InvTotal : Double;
begin
  //PR: 18/09/2017 v2017 R2 ABSEXCH-19197 Need to round up result from
  //ConvCurrITotal to prevent roundng errors
  InvTotal := Round_Up(ConvCurrITotal(Inv, BOff, True, True), 2);

  //PR: 29/01/2015 ABSEXCH-16096 Change to populate new PaymentsMade variable
  PaymentsMade := GetPaymentsMade;

  Result := InvTotal < PaymentsMade;
end;

{$ENDIF COMTK}


//PR: 03/08/2012 ABSEXCH-12746
function AccountOnHold(CustR : CustRec) : Boolean;
begin
  Result := CustR.AccStatus = 2;
end;

procedure SetIgnoreCreditLimit(Value : Boolean);
begin
  IgnoreCreditLimit := Value;
end;

function GetIgnoreCreditLimit : Boolean;
begin
  Result := IgnoreCreditLimit;
end;

//PR: 10/11/2011 v6.9 Function to test if transaction header hold flag is valid.
//Hold flag can be 0..6 (+ 32 for notes, + 128 for suspend posting.
function IsValidHoldFlag(HoldFlag : SmallInt) : Boolean;
begin
  Result := (HoldFlag and not (32 + 128)) in [0..6];
end;

//PR: 30/10/2013 ABSEXCH-14592 Added function to specify whether transaction has been authorised.
function TransactionIsAuthorised(HoldFlag : Byte) : Boolean;
begin
  Result := (HoldFlag and 3) = 3;
end;

//PR: 10/09/2009 Function to check that a line may validly be an EC Service Line
//It is assumed that this function is only called if EC Services is enabled in SystemSetup and ECService is True on the line.
function ValidServiceLine(ExInv : InvRec;
                          ExId  : IDetail;
                          ExCust : CustRec;
                          var ErrCode : longint) : Boolean;
begin
  ErrCode := 0;
  if not ExCust.EECMember then
    ErrCode := 30137
  else //PR: 01/07/2016 v2016 R2 ABSEXCH-17637 add check for intrastat
  if (ExInv.SSDProcess <> #32) and IntrastatEnabled then
    ErrCode := 30138
  else
  if not (ExInv.InvDocHed in PurchSplit + SalesSplit - [PPY, PBT, SRC, SBT]) then
    ErrCode := 30139
  else
  if ((Trim(ExId.StockCode) <> '') and (Stock.StockType <>  'D')) then
    ErrCode := 30140
  else
  if (ExId.LineNo = RecieptCode) then
    ErrCode := 30141
  else
  if (
      ((ExInv.InvDocHed in SalesSplit - [SRC]) and not (ExId.VatCode in ['D','4'])) or //PS : 22/06/2016 : ABSEXCH-10983 : Validate only '4' / 'D' VAT code for Sales Transaction- Rollback previous changes
      ((ExInv.InvDocHed in PurchSplit - [PPY, PBT]) and (ExId.VatCode in ['A','D']))
     ) then
    ErrCode := 30142;

  Result := ErrCode = 0;
end;

function AllowOverrideLocation(InvDocHed : DocTypes; LineNo : Integer = 0) : Boolean;
begin
  Result := Syss.UseMLoc and Syss.EnableOverrideLocations and
   (
     (InvDocHed in PurchSplit-[PBT, PPY, PPI, PRF]) or
     ((InvDocHed in [PPI, PRF]) and ( LineNo <> RecieptCode))
   );
end;



{PR 11/04/2008 - When updating a transaction, the function wasn't taking account of the fact that some of the customer's committed value
 belonged to the transaction. Changed so that we subtract the original value of the transaction from the committed value, before checking.}
function WithinCreditLimit(sCustCode : ShortString; TransValue, OriginalTransValue : Double; IsUpdate : Boolean) : Boolean;
var
  Commit, Balance : Double;
  CrDr            :   DrCrDType;
  KeyS  :  Str255;
begin
  Result := True;
  if not IgnoreCreditLimit then //PR: 18/11/2010 New flag added for NF.
  begin  //PL : 15/12/2016 2017R1 ABSEXCH-16264 added this condition to use InvoiceTo
    If (Not EmptyKey(Cust.SOPInvCode,CustKeyLen)) then
    begin
      KeyS :=FullCustCode(Cust.SOPInvCode);
      if CheckRecExsists(KeyS, CustF, CustCodeK) then
      begin
        Balance:=Profit_to_Date(CustHistCde,sCustCode,0,
        Syss.CYr,Syss.CPr,CrDr[BOff],CrDr[BOn],Commit,BOn);
        if IsUpdate then
          Commit := Commit - OriginalTransValue;
          Result := (Cust.CreditLimit = 0) or (TransValue <= (Cust.CreditLimit - Balance - Commit));
      end;
    end
    else
    begin
      if CheckRecExsists(sCustCode, CustF, CustCodeK) then
      begin
        Balance:=Profit_to_Date(CustHistCde,sCustCode,0,
           Syss.CYr,Syss.CPr,CrDr[BOff],CrDr[BOn],Commit,BOn);
        if IsUpdate then
          Commit := Commit - OriginalTransValue;
        Result := (Cust.CreditLimit = 0) or (TransValue <= (Cust.CreditLimit - Balance - Commit));
      end;
    end;
  end;
end;

function CanAddTransType(InvDocHed : DocTypes) : Boolean;
begin
  Result :=(InvDocHed In SalesSplit+PurchSplit+NomSplit-PSOPSet) or
           ((InvDocHed in PSOPSet - DeliverSet) and SPOPOn) or
           ((InvDocHed in StkAdjSplit) and StockOn) or
           ((InvDocHed in TSTSplit) and JBCostOn) or
           ((InvDocHed in WOPSplit) and WOPOn) or
           ((InvDocHed in JAPSplit) and JAPOn) or
           ((InvDocHed in StkRetSplit) and RetMOn);
end;

{ ------------ Functions for Job Actual Record (19.02.97) ---------------- }


{ ============== Function to Return Line Cnst Based on Payment Type =========== }

Function LineCnst(P  :  Char)  :  Integer;
Begin
  If (P=DocPayType[SIN]) then
    LineCnst:=-1
  else
    LineCnst:=1;
end;

{ =========== Function to Return Qty, or Qty Mul ======== }

Function Calc_IdQty(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;
Begin
  If (UP) then
    Calc_IdQty:=Q*QM
  else
    Calc_IdQty:=Q;

end; {Func..}

Function Calc_StkCP(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;


Begin

  If (Not UP) then
    Calc_StkCP:=DivWChk(Q,QM)
  else
    Calc_StkCP:=Q;

end; {Func..}


//PR 31/05/02
//Added to calculate split pack prices
function CalcLineCost(ExID : IDetail) : Double;
begin
  Result := (ExID.CostPrice) * ExID.Qty;


  if (ExID.UsePack or ((ExID.PrxPack and ExID.ShowCase) and not
                       (Stock.StkValType In ['S', 'C', 'R'])
                      ))
     and (ExID.QtyPack > 0.0) then
      Result := Result * ExID.QtyMul;

end;


{ ==================== Calculate One Line of Invoice ================= }

(*

Function DetLTotal(IDr        :  IDetail;
                   UseDisc,
                   UseSetl    :  Boolean)  :  Real;
Var
  Rnum,
  WithDisc   :  Real;
  Cnst       :  Integer;
  UseDecs    :  Byte;

Begin
  With Idr do
  Begin
    Cnst:=LineCnst(Payment);
    RNum:=0; WithDisc:=0;

    If (IdDocHed In SalesSplit) then  {* No Dec places determines rounding effect on Purch/Sales *}
      UseDecs:=Syss.NoNetDec
    else
      UseDecs:=Syss.NoCosDec;

    Rnum:=Calc_PAmount(Round_Up(NetValue,UseDecs),Discount,DiscountChr);

    WithDisc:=Round_Up(Calc_IdQty(Qty,QtyMul,UsePack)*(Round_Up(NetValue,UseDecs)-Rnum),2);

    WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,(Inv.DiscSetl*Ord(UseSetl)),PcntChr),2);

    If (UseDisc) then
      DetLTotal:=(WithDisc*Cnst)
    else
      DetLTotal:=Round_Up((Calc_IdQty(Qty,QtyMul,UsePack)*Round_Up(NetValue,UseDecs)*Cnst),2);
  end;{With..}
end;
*)

Function DetLTotalND(IDr        :  IDetail;
                     UseDisc,
                     UseSetl,
                     ShowDec    :  Boolean)  :  Double;

Var
  Rnum,
  WithDisc
        :  Double;

  Cnst  :  Integer;

  LineQty,
  PriceEach
        :  Double;

  FinDecs,
  UseDecs,
  UseQDecs
        :  Byte;


Begin
  With Idr do
  Begin
    Cnst:=LineCnst(Payment);

    RNum:=0; WithDisc:=0;

    UseQDecs:=Syss.NoQtyDec;

    If (IdDocHed In SalesSplit) then  {* No Dec places determines rounding effect on Purch/Sales *}
      UseDecs:=Syss.NoNetDec
    else
      UseDecs:=Syss.NoCosDec;

    If (ShowDec) then
      FinDecs:=UseDecs
    else
      FinDecs:=2;

    LineQty:=Calc_IdQty(Qty,QtyMul,UsePack);

    If (PrxPack) and (QtyPack<>0) and (QtyMul<>0) then
    Begin
      If (ShowCase) then
      Begin
        PriceEach:=NetValue;
        LineQty:=DivWChk(Qty,QtyPack);

        UseQDecs:=12;  {* If we are using split pack with cases, we cannot round up as it is a factor.. *}
      end
      else
        PriceEach:=(DivWChk(QtyMul,QtyPack)*NetValue);

    end
    else
      PriceEach:=NetValue;


      // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts //PR: 26/03/2009 Copied from R&D\MiscU
      //Rnum:=Calc_PAmount(Round_Up(PriceEach,UseDecs),Discount,DiscountChr);
      Rnum:=Calc_PAmountAD(Round_Up(PriceEach,UseDecs),
                           Discount, DiscountChr,
                           Discount2, Discount2Chr,
                           Discount3, Discount3Chr);

    WithDisc:=Round_Up(Round_Up(LineQty,UseQDecs)*(Round_Up(PriceEach,UseDecs)-Rnum),FinDecs);

    WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,(Inv.DiscSetl*Ord(UseSetl)),PcntChr),FinDecs);

    If (UseDisc) then
      DetLTotalND:=(WithDisc*Cnst)
    else
      DetLTotalND:=Round_Up((Round_Up(LineQty,UseQDecs)*Round_Up(PriceEach,UseDecs)*Cnst),FinDecs);
  end;{With..}
end;


Function DetLTotal(IDr        :  IDetail;
                   UseDisc,
                   UseSetl    :  Boolean)  :  Double;


Begin
  DetLTotal:=DetLTotalND(IdR,UseDisc,UseSetl,BOff);
end;

  procedure UnMakeUnits(var Val : Double; QtyPack : Double);
  var
   i : integer;
   v1, v2 : double;
  begin

    Val := DivWChk(Val,QtyPack);
    v1 := TRunc(Val);
    v2 := Val - Trunc(Val);

    v2 := v2 * QtyPack;

    for i := 1 to Syss.NoQtyDec do
      v2 := v2 / 10;

    Val := v1 + v2;
    Val := Round_Up(Val, Syss.NoQtyDec);
  end;


//PR: 09/04/2002
//Make sure split pack fields are set from stock record
procedure SetSplitPackStockDetails(MakeChanges : Boolean = True);
var
  Res : SmallInt;
  StockCode : String;
  ValidCheck : Boolean;
  TmpQtyUnit,
  TmpQtyPack : Double;
  SplitMode : Byte;

  procedure MakeUnits(var Val : Double);
  var
   i : integer;
  begin
    {while (Val - Trunc(Val)) > 0.0000000001 do}
    for i := 1 to Syss.NoQtyDec do
      Val := Val * 10;

    Val := Round_Up(Val, Syss.NoQtyDec);
  end;

  function DoUnits(Which : Integer) : Double;
  var
    Val : Double;
  begin
   Val := 0;
   Case Which of
     1 : Val := ID.Qty;
     2 : Val := ID.QtyWOFF;
     3 : Val := ID.QtyDel;
     4 : Val := ID.QtyPick;
     5 : Val := ID.QtyPWOff;
   end;
   //Units are the decimal part of qty - eg 0.12 is 12 units
   TmpQtyUnit := Val - Trunc(Val);
   //Packs are the intger part of qty
   TmpQtyPack := Val - TmpQtyUnit;
   MakeUnits(TmpQtyUnit);
   Val := (TmpQtyPack * ID.QtyPack) + TmpQtyUnit;
   Result := Val;
  end;

begin
  SplitMode := 0;
  if MakeChanges then
  Try
    StockCode := ID.StockCode;
    StockCode:=FullStockCode(StockCode);

    ValidCheck:=(CheckRecExsists(StockCode,StockF,StkCodeK));

    if ValidCheck then
    begin
      ID.UsePack := Stock.CalcPack;
      ID.PrxPack := Stock.PricePack;
      if ID.IdDocHed in SalesSplit then
        ID.QtyPack := Stock.SellUnit
      else
        ID.QtyPack := Stock.BuyUnit;


      ID.ShowCase := Stock.DPackQty;

      if Stock.DPackQty and Stock.PricePack and not Stock.CalcPack then
        SplitMode := 1
      else
      if not Stock.DPackQty and not Stock.PricePack and Stock.CalcPack then
        SplitMode := 2
      else
      if not Stock.DPackQty and not Stock.PricePack and not Stock.CalcPack then
        SplitMode := 3;

      Case SplitMode of
        1  : begin
{               ID.Qty := DoUnits(1);
               ID.QtyWOFF  := DoUnits(2);
               ID.QtyDel := DoUnits(3);
               ID.QtyPick := DoUnits(4);
               ID.QtyPWoff := DoUnits(5);
               ID.QtyMul := 1;}
             end;
        2  : begin
               ID.QtyMul := ID.QtyPack;
             end;
        end; //Case

    end;
  Except
  End;
end;

procedure SetSplitPackQty;
begin
{  SetSplitPackStockDetails;
  if (ID.QtyPack > 0.0) and (ID.ShowCase and ID.PrxPack and not ID.UsePack) then
  begin
    ID.Qty := ID.Qty * ID.QtyPack;
    ID.DeductQty := ID.Qty;
    if (Stock.StkValType In ['S', 'C', 'R']) then
      ID.CostPrice := ID.CostPrice / ID.QtyPack;
  end;}
end;





 { =========== Function to Return Qty OS on Document =========== }

Function Qty_OS(IdR  :  IDetail)  :  Real;

Begin
  With IdR do Begin
    Qty_OS:=Round_Up((Qty-(QtyDel+QtyWOff)),Syss.NoQtyDec);
  end;
end; {Func..}

 { =========== Function to Return Delivered + WriteOff Qty on each Line =========== }

Function Qty_Delivered(IdR  :  IDetail)  :  Real;

Begin
  With IdR do Begin
    Qty_Delivered:=Round_Up((QtyDel+QtyWOff),Syss.NoQtyDec);
  end;
end; {Func..}

  { ====== Function to Return Full JobCode ====== }

Function FullJobCode(JCode  :  Str20)  :  Str20;

Begin
  FullJobCode:=LJVar(JCode,JobCodeLen); {Changed JobCodeLen as ExLenJob}
end;


Function FullJDLedgerKey(JC   :   Str10;
                         P,I  :   Boolean;
                         Cu   :   Byte;
                         JD   :   Str8)  :  Str30;
Begin
  FullJDLedgerKey:=FullJobCode(JC)+Chr(Ord(P))+Chr(Cu)+Chr(Ord(I))+JD;
end;


Function FullJDRunKey(JC      :   Str10;
                      RN      :   Longint;
                      JD      :   Str8)  :  Str30;
Begin
  FullJDRunKey:=FullNomKey(RN)+FullJobCode(JC)+JD;
end;


Function FullJDLookKey(RN,FN   :   Longint)  :  Str20;

Begin
  FullJDLookKey:=FullNomKey(RN)+FullNomKey(FN)+HelpKStop;
end;


Function FullJDEmplKey(JC,EC   :   Str10;
                       Matched :   Boolean)  :  Str30;
Begin
  FullJDEmplKey:=FullJobCode(EC)+Chr(Ord(Matched))+FullJobCode(JC);
end;


{ ====== Func to Get on cost markup information ====== }

Function Get_BudgMUp(JCode,
                       ACode    :  Str10;
                       SCode    :  Str20;
                       Curr     :  Byte;
                   Var Charge,
                       CostUp   :  Double;
                       Mode     :  Byte)  :  Boolean;
Const
    Fnum     =  JCtrlF;
    Keypath  =  JCK;

Var
    KeyS,
    KeyChk   :  Str255;

    FoundOk,
    AllowChrge,
    Loop     :  Boolean;

    HistPFix :  Char;

    NomBal,
    Purch,
    Sales,
    Cleared,
    Bud1,
    Bud2,
    Rnum     :  Real;

    Dnum,
    Dnum2    :  Double;

Begin

    If (Mode=1) then Charge:=0;
    AllowChrge:=BOn;    Loop:=BOff;

    KeyChk:=JBRCode+JBSCode+FullJBCode(JCode,0,SCode);

    Repeat

      KeyS:=KeyChk;
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      FoundOk:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk)-1,BOn)));

      If (FoundOk) then
      Begin
        Case Mode of
          1  :  Begin
                  AllowChrge:=JobCtrl^.JobBudg.ReCharge or (ID.IdDocHed in JAPSplit);
                  With JobCtrl^.JobBudg do
                    If ((FoundOk) and (AllowChrge)) then Charge:=OverCost;

                  If (FoundOk) then
                    CostUp:=JobCtrl^.JobBudg.JBUpliftP;

                end;

          {Mode is passed as 1}
          {2,3
             :  With JobCtrl^.JobBudg do
                Begin
                  If (Mode=3) then
                    HistPFix:=CommitHCode
                  else
                    HistPFix:=JobRec^.JobType;
                  NomBal:=Profit_To_Date(HistPFix,FullJDHistKey(JCode,HistFolio),0,
                                         Syss.CYr,Syss.CPr,Purch,Sales,Cleared,On);
                 AllowChrge:=(((NomBal+Charge)<BrValue) or (BrValue=0) or (Not Syss.WarnJC));
                end;}
        end; {Case..}
      end; {If match found..}

      KeyChk:=JBRCode+JBBCode+FullJBCode(JCode,0,ACode);
      Loop:=Not Loop;

    Until (Not Loop) or ((FoundOk) and (AllowChrge)) or ((FoundOk) and (Mode<>1));

    Get_BudgMUp:=AllowChrge;

end; {Func..}

{* --------------- Up to here (12.11.96) ------------- *}

function Extract_PayRef2(PayRef : Str20) : Str10;
{ Function to extract the PayRef from a completed Key }
var
  SepCh     :  Char;
  NomCode   :  LongInt;
  Currency  :  Byte;
  RefNo     :  Str10;
  Count     :  Byte;
begin
  Count:=1;

  if (Length(PayRef)=Length(Full_PostPayInKey(#0,0,0,''))) then
  begin
    SepCh:=PayRef[Count];
    Count:=Count+Sizeof(SepCh);
    Move(PayRef[Count],NomCode,Sizeof(NomCode));
    Count:=Count+Sizeof(NomCode);
    Currency:=Ord(Payref[Count]);
    Count:=Count+Sizeof(Currency);
    RefNo:=Copy(PayRef,Count,Pred(Sizeof(RefNo)));
  end
  else
    RefNo:='';

  Result := RefNo;
end; { Extract_PayRef2 }

function Extract_PayRef1(PayRef  :  Str20)  :  Str10;
{ Function to Extract the PayRef from a completed Key }
var
  SepCh     :  Char;
  RefNo     :  Str10;
  Count     :  Byte;
begin
  Count:=1;

  if (Length(PayRef)=Length(Pre_PostPayInKey(#0,''))) then
  begin
    SepCh:=PayRef[Count];
    Count:=Count+Sizeof(SepCh);
    RefNo:=Copy(PayRef,Count,Pred(Sizeof(RefNo)));
  end
  else
    RefNo:='';

  Result := RefNo;
end; { Extract_PayRef1 }

Procedure CopyEntIdToTKId(Const EntId   : IDetail;
                          Var   ExIdRec : TBatchTLRec);

Var
  n  :  Byte;
  GotStock : Boolean;

Begin
  GotStock := False;
  With ExIdRec do
  Begin
    TransRefNo:=EntId.DocPRef;   { was Inv.OurRef 12/05/2000 - Jim }
    FolioNum:=EntId.FolioRef;    {* Added on 27.11.97 *}
    LineNo:=EntId.LineNo;
    NomCode:=EntId.NomCode;
    Currency:=EntId.Currency;

    {* From Ent. record to External record, hence SetTriRec will not be used *}
    If (ExSyss.MCMode) then
      CoRate:=XRate(EntId.CXRate,UseCoDayRate,EntId.Currency)
    else
      CoRate:=EntId.CXRate[BOff];
    VATRate:=EntId.CXRate[BOn];


    CC:=EntId.CCDep[BOn];
    Dep:=EntId.CCDep[BOff];

    PayMent:=BoolToWordBool (EntId.LineNo=RecieptCode);

    { 14.07.99 - Above Payment line has been moved to check the following condition
     and changed the Payment as advised by EL }

    { JRF 09/06/1999 Commented out code below didn't work with posted transactions }
    {if Id.Payment = 'Y' then { SRC / SRI and others ? }
    //PR 27/03/06 Allow PayRef on Noms
    If WordBoolToBool (Payment) or (EntId.IdDocHed = NMT) then
      if EntId.PostedRun > 0 then
        StockCode := Extract_PayRef2(EntId.StockCode)
      else
        StockCode := Extract_PayRef1(EntId.StockCode)
    else
      StockCode:=EntId.Stockcode;


    {* 22.09.99 - not returning Stock code for ADJ record *}
    If WordBoolToBool (Payment) and (EntId.IdDocHed In StkAdjSplit) then
      StockCode:=EntId.StockCode;

    if Trim(StockCode) <> '' then
      GotStock := CheckRecExsists(StockCode, StockF, StkCodeK);

  (*  If (Id.StockCode[1]=PayInCode) then
      StockCode:=Strip('L',[#1, #2],Id.StockCode)
    else
      StockCode:=Id.StockCode; *)

    if GotStock then
    begin
	    //SS:23/04/2018:2018-R1.1:ABSEXCH-20291:tlQty is being automatically updated incorrectly when only tlQtyPicked is updated via ITransaction.Update causing incorrect values to be returned for packs
      if EntId.QtyMul > 1 then
        Qty := Case2Ea(EntId, Stock, EntId.Qty)
      else
        Qty := CaseQty( Stock, EntId.Qty);

      QtyWOff:=CaseQty(Stock, EntId.QtyWOff);
      QtyDel:=CaseQty(Stock, EntId.QtyDel);
      QtyPick:=CaseQty(Stock, EntId.QtyPick);
    //PR 5/12/01 - this was missing so added it
      QtyPWoff := CaseQty(Stock, EntId.QtyPWOff);
    end
    else
    begin
      Qty:=EntId.Qty;
      QtyWOff:=EntId.QtyWOff;
      QtyDel:=EntId.QtyDel;
      QtyPick:=EntId.QtyPick;
    //PR 5/12/01 - this was missing so added it
      QtyPWoff := EntId.QtyPWOff;
    end;


    tlQtyPack := EntID.QtyPack;
{    if EntId.PrxPack and EntID.ShowCase then
    begin
      UnMakeUnits(Qty, EntId.QtyPack);
      UnMakeUnits(QtyWOff, EntId.QtyPack);
      UnMakeUnits(QtyDel, EntId.QtyPack);
      UnMakeUnits(QtyPick, EntId.QtyPack);
      UnMakeUnits(QtyPWoff, EntId.QtyPack);
    end;}
    QtyMul:=EntId.QtyMul;
    NetValue:=EntId.NetValue;
    IncNetValue := EntId.IncNetValue;
    Discount:=EntId.Discount;
    VATCode:=EntId.VATCode;
    VAT:=EntId.VAT;

    DiscountChr:=EntId.DiscountChr;
    CostPrice:=EntId.CostPrice;
    CustCode:=EntId.CustCode;
    LineDate:=EntId.PDate;
    Item:=EntId.Item;
    Desc:=EntId.Desc;
    LWeight:=EntId.LWeight;
    MLocStk:=EntId.MLocStk;
    JobCode:=EntId.JobCode;
    AnalCode:=EntId.AnalCode;
    //PR 30/7/04 - Make sure the reconcile/tshccurr field that isn't being used is set to zero.
    If (EntId.IdDocHed In TSTSplit) then
    begin
      TSHCCurr:=EntId.Reconcile;
      Reconcile := 0;
    end
    else
    begin
      {* Added on 27.01.97 *}
      Reconcile :=EntId.Reconcile;
      TSHCCurr := 0;
    end;
    tlReconciliationDate := EntId.ReconDate;

    {* Added on 19.11.97 *}
    DocLTLink:=EntId.DocLTLink;
    KitLink:=EntId.KitLink;

    {* Added on 3.12.97 *}
    LineType:=EntId.LineType;

    SOPLink:=EntId.SOPLink;
    SOPLineNo:=EntId.SOPLineNo;

    ABSLineNo:=EntId.ABSLineNo;

    {*** Ver 4.31 ***}
    LineUser1:=EntId.LineUser1;
    LineUser2:=EntId.LineUser2;
    LineUser3:=EntId.LineUser3;
    LineUser4:=EntId.LineUser4;

    SSDUplift:=EntId.SSDUplift;
    SSDCommod:=EntId.SSDCommod;
    SSDSPUnit:=EntId.SSDSPUnit;
    SSDCountry:=EntId.SSDcountry;
    SSDUseLine:=BoolToWordBool(EntId.SSDUseLine);
    PriceMulx:=EntId.PriceMulx;
    VATIncFlg:=EntId.VATIncFlg;
    {$IFDEF EN552}
    BinQty := EntId.BinQty;
    {$ENDIF}


    {*** -------------- ***}

    {$IFDEF COMTK}
    Year := EntID.PYr;
    Period := EntID.PPr;
    NomMode := EntId.NomMode;
    DocHed := DocCodes[EntID.IDDocHed];
    tlCOSNomCode := EntID.COSNomCode;
    tlUseCase    := EntId.ShowCase;
    tlDeductType := EntId.JAPDedType;
    tlOldSerialQty := EntId.OldSerQty;
    tlLiveUplift := EntId.LiveUplift;
    PaymentCode := EntId.Payment;
    SerialRetQty := EntId.SerialRetQty;
    BinRetQty := EntId.BinRetQty;
    {$ENDIF}

    {$IFDEF EN550CIS}
    AutoLineType := EntID.AutoLineType;
    CISRateCode  := EntID.CISRateCode;
    CISRate      := EntID.CISRate;
    CostApport   := EntID.CostApport;
    {$ENDIF}

    {$IFDEF EN551}
    NomVatType := EntID.NOMIOFlg;
    {$ENDIF}

    tlRunNo := EntID.PostedRun;
    tlStockDeductQty := EntID.DeductQty;
    tlUseQtyMul := BoolToWordBool(EntID.UsePack);
    tlSerialQty := EntID.SerialQty;
    tlPriceByPack := BoolToWordBool(EntID.PrxPack);
    tlB2BLinkFolio := EntID.B2BLink;
    tlB2BLineNo := EntID.B2BLineNo;
    tlCOSDailyRate := EntID.COSConvRate;
    tlAltStockFolio := EntID.sdbFolio;

    {$IFDEF COMTK}
    InvalidJobCode := False;
    InvalidTSHRates := False;
    {$ENDIF}

    //PR: 25/03/2009 Advanced Discount fields
    tlMultiBuyDiscount := EntID.Discount2;
    tlMultiBuyDiscountChr := EntID.Discount2Chr;
    tlTransValueDiscount := EntID.Discount3;
    tlTransValueDiscountChr := EntID.Discount3Chr;
    tlTransValueDiscountType := EntID.Discount3Type;

    //PR: 09/09/2009 EC Service fields
    tlECService            := BoolToWordBool(EntID.ECService);
    tlECServiceStartDate   := EntID.ServiceStartDate;
    tlECServiceEndDate     := EntID.ServiceEndDate;
    tlECSalesTaxReported   := EntID.ECSalesTaxReported;
    tlECPurchaseServiceTax := EntID.PurchaseServiceTax;

    //PR: 04/02/2010 New fields for web extensions (6.3)
    tlReference := EntID.tlReference;
    tlReceiptNo := EntID.tlReceiptNo;
    tlFromPostCode := EntID.tlFromPostCode;
    tlToPostCode := EntID.tlToPostCode;

    //PR: 27/10/2011 v6.9 User Fields 5 - 10
   {$IFDEF COMTK}
    LineUser5:=EntId.LineUser5;
    LineUser6:=EntId.LineUser6;
    LineUser7:=EntId.LineUser7;
    LineUser8:=EntId.LineUser8;
    LineUser9:=EntId.LineUser9;
    LineUser10:=EntId.LineUser10;

    // MH 01/03/2012 v6.10 ABSEXCH-12596: Added Threshold Code for LIVE
    tlThresholdCode := EntId.tlThresholdCode;
    {$ENDIF}

    //PR: 20/01/2016 ABSEXCH-17112 v2016 R1 Added Nature of Transaction Code
    tlIntrastatNoTC := EntId.tlIntrastatNoTC;



  end;
end; {Proc..}

Procedure IdToExId(Var ExIdRec  :  TBatchTLRec);
begin
  CopyEntIdToTKId(Id, ExIdRec);
end;

{ =======  Routine to collect all invoice lines ===== }

Procedure Get_TransLines(FolioN  :  Longint;
                         Fnum,
                         Keypath :  Integer;
                     Var P       :  Pointer;  {* Pointer of TLs *}
                     Var ILC     :  LongInt;  {* ILC = Exinv^.LineCount *}
                     Var PSize   :  LongInt); {* Total Size of TLs *}
                     {* Add PSize para. *}
Var
  KeyS,
  KeyChk  :  Str255;
  {ExIdRec :  ^TBatchLinesRec;}
  {* Add for Changes *}
  TmpExIdRec          :  TBatchTLRec;

  MaxIdLines,
  RecSeg,RecOfs,
  RecPos              :  LongInt;

Begin
  If (P<>Nil) then
  Begin
    KeyS:=FullNomKey(FolioN);
    {ExIdRec:=P;
    FillChar(ExIdRec^,Sizeof(ExIdRec^),0);}

    MaxIdLines:=ILC;            {* ILC = ExInv^.LineCount *}
    FillChar(P^,PSize,#0);      {* P=TLsPointer PSize=TotalPassingTLsSize *}
    KeyChk:=FullNomKey(FolioN);
    ILC:=0;

    //PR 21/04/06 Allow hidden lines to be included if required
    if IncludeHiddenLines then
    begin
      KeyS := KeyS + FullNomKey(-1);
      MaxIdLines := MaxInt;
    end;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    {While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (ILC<=MaxInvLines) do}
    {* Change MaxInvLines as MaxIdLine *}
    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (ILC<=MaxIdLines) do
    Begin
      Inc(ILC);
      {IdToExId(ExIdRec^[ILC]);}
      //PR 18/12/01 - Blank out temp record before each new line
      FillChar(TmpExIdRec, SizeOf(TmpExIdRec), #0);
      IdToExId(TmpExIdRec);      {* convert into Tmp. Record *}

      {$IFDEF WIN32}
        RecPos:=LongInt(P)+( Pred(ILC)*SizeOf(TmpExIdRec));    {* get Ptr position *}
        Move(TmpExIdRec,Pointer(RecPos)^,SizeOf(TmpExIdRec));  {* move Tmp.Rec into Ptr *}
      {$ELSE}
        RecSeg:=Seg(P^);
        RecOfs:=Ofs(P^);
        RecOfs:=RecOfs + ( Pred(ILC)*SizeOf(TmpExIdRec) );
        Move(TmpExIdRec,Ptr(RecSeg,RecOfs)^,SizeOf(TmpExIdRec) );
      {$ENDIF}

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {while..}
  end; {if..}

end; {proc..}


Procedure CopyExInvToTKInv(Const InvR : InvRec; Var ExInvRec  :  TBatchTHRec);
Var
  n  :  Byte;

Begin
  With ExInvRec do
  Begin
    RunNo:=InvR.RunNo;
    CustCode:=InvR.CustCode;
    OurRef:=InvR.OurRef;
    FolioNum:=InvR.FolioNum;
    Currency:=InvR.Currency;
    AcYr:=InvR.AcYr;
    AcPr:=InvR.AcPr;
    DueDate:=InvR.DueDate;
    TransDate:=InvR.TransDate;

    {$IFDEF COMTK}
    for n := 1 to 6 do
      DocLSplit[n] := InvR.DocLSplit[n];
    {$ENDIF}

    {* From Ent. record to External record, hence SetTriRec will not be used *}

    If (ExSyss.MCMode) then
      CoRate:=XRate(InvR.CXRate,UseCoDayRate,InvR.Currency)
    else
      CoRate:=InvR.CXRate[BOff];
    VATRate:=InvR.CXRate[BOn];

    {------------------------}

    YourRef:=InvR.YourRef;
    LongYrRef:=InvR.TransDesc;

    {$IFNDEF COMTK}
      {LineCount:=InvR.ILineCount;}
      {* 21.09.99 - Inv.LineCount is not actual total line count, hence calculate manually *}
      LineCount:=GetActualLineCount(InvR.FolioNum);
    {$ENDIF}

    TransDocHed:=DocCodes[InvR.InvDocHed];

    {For n:=0 to 9 do}                    {* changed from 9 to 16 on 10.06.97 *}
    For n:=0 to 20 do {16 to 23 in v4.31 }
      InvVATAnal[n]:=InvR.InvVATAnal[GetVATNo(THVATCode[n],#0)];

      {InvVATAnal[n]:=InvR.InvVATAnal[VATType(n)];}

    InvNetVal:=InvR.InvNetVal;
    InvVAT:=InvR.InvVAT;

    DiscSetl:=InvR.DiscSetl;
    DiscSetAm:=InvR.DiscSetAm;
    DiscAmount:=InvR.DiscAmount;
    DiscDays:=InvR.DiscDays;
    DiscTaken:=BoolToWordBool(InvR.DiscTaken);

    If (ExSyss.MCMode) then
      Settled:=InvR.CurrSettled
    else
      Settled:=InvR.Settled;

    TransNat:=InvR.TransNat;
    TransMode:=InvR.TransMode;
    HoldFlg:=InvR.HoldFlg;
    TotalWeight:=InvR.TotalWeight;

    For n:=1 to 5 do
      DAddr[n]:=InvR.DAddr[n];

    TotalCost:=InvR.TotalCost;
    PrintedDoc:=BoolToWordBool(InvR.PrintedDoc);
    ManVAT:=BoolToWordBool(InvR.ManVAT);
    DelTerms:=InvR.DelTerms;
    OpName:=InvR.OpName;
    DJobCode:=FullJobCode(InvR.DJobCode);
    DJobAnal:=InvR.DJobAnal;
    TotOrdOS:=InvR.TotOrdOs;
    DocUser1:=InvR.DocUser1;
    DocUser2:=InvR.DocUser2;


    If (InvR.InvDocHed In TSTSplit) then
    begin
      EmpCode:=InvR.BatchLink;
    end;

    Tagged:=InvR.Tagged;
    thNoLabels:=InvR.NoLabels;
    CtrlNom:=InvR.CtrlNom;

    {***  ver 4.31 New Fields ***}

    SOPKeepRate:=BoolToWordBool(InvR.SOPKeepRate);
    DocUser3:=InvR.DocUser3;
    DocUser4:=InvR.DocUser4;
    SSDProcess:=InvR.SSDProcess;
    ExtSource:=InvR.ExtSource;
    PostDate:=InvR.PostDate;
    PORPickSOR:=BoolToWordBool(InvR.PORPickSOR);
    BDiscount:=InvR.BDiscount;
    PrePostFlg:=InvR.PrePostFlg; { Read only }
    AllocStat:=InvR.AllocStat;

    AutoInc   := InvR.AutoInc;
    AutoIncBy := InvR.AutoIncBy;
    AutoEndDate := InvR.UntilDate;
    AutoEndPr := InvR.UnPr;
    AutoEndYr := InvR.UnYr;
    AutoPost  := BoolToWordBool(InvR.AutoPost);

    {$IFDEF COMTK}
    NomAutoReverse := InvR.Untagged;
    TotalInvoiced := InvR.TotalInvoiced;
    thVariance := InvR.Variance;
    BatchNom := InvR.BatchNom;
    BatchLink := InvR.BatchLink;
    RemitNo := InvR.RemitNo;
    NomAuto := BoolToWordBool(InvR.NomAuto);

    thOnPickRun := BoolToWordBool(InvR.OnPickRun);
    thTotalReserved := InvR.TotalReserved;
    thTotalOrdered  := InvR.TotalOrdered;
    thRevalueAdj := InvR.RevalueAdj;
    thVatPostDate := InvR.VATPostDate;
    {$ENDIF}

    //PR: 24/07/02 Added TimeCreate & TimeChange fields - these are read only in the tk and
    //are set automatically when saving the transaction
    TimeCreate := InvR.TimeCreate;
    TimeChange := InvR.TimeChange;

    CISTax := InvR.CISTax;
    CISDeclared := InvR.CISDeclared;
    CISManualTax := InvR.CISManualTax;
    CISDate := InvR.CISDate;
    CISEmpl := InvR.CISEmpl;
    CISGross := InvR.CISGross;
    CISHolder := InvR.CISHolder;
    TotalCost2 := InvR.TotalCost2;
    NOMVatIO := InvR.NOMVATIO;

    thAutoTransaction := BoolToWordBool(not InvR.NomAuto);
    thDeliveryRunNo   := InvR.BatchLink;
    thExternal        := BoolToWordBool(InvR.ExternalDoc);
    thSettledVAT      := InvR.SettledVAT;
    thVATClaimed      := InvR.VATClaimed;
    thPickingRunNo    := InvR.PickRunNo;
    thDeliveryNoteRef := InvR.DeliverRef;
    thVATCompanyRate  := InvR.VATCRate[Boff];
    thVATDailyRate    := InvR.VATCRate[BOn];
    thPostCompanyRate := InvR.OrigRates[Boff];
    thPostDailyRate   := InvR.OrigRates[BOn];
    thPostDiscAmount  := InvR.PostDiscAm;
    thPostDiscTaken   := BoolToWordBool(InvR.PDiscTaken);
    thLastDebtChaseLetter := InvR.LastLetter;
    {$IFDEF COMTK}
    thExported        := InvR.THExportedFlag;
    thOrdMatch        := InvR.OrdMatch;
    thAutoPost        := InvR.AutoPost;
    thUseORate        := InvR.UseORate;
    {$ENDIF}
    {$IFNDEF COMTK}
    thRevaluationAdjustment := InvR.ReValueAdj;
    {$ENDIF}

    //PR: 04/02/2010 New fields for web extensions
    thWeekMonth := InvR.thWeekMonth;
    thWorkflowState := InvR.thWorkflowState;

    if InvR.InvDocHed = TSH then
    begin
      if thWeekMonth = 0 then
        thWeekMonth := InvR.DiscDays;
    end;

    //PR: 15/10/2010 New field for LIVE
    thOverrideLocation := InvR.thOverrideLocation;

    //PR: 21/10/2011 v6.9
    DocUser5 := InvR.DocUser5;
    DocUser6 := InvR.DocUser6;
    DocUser7 := InvR.DocUser7;
    DocUser8 := InvR.DocUser8;
    DocUser9 := InvR.DocUser9;
    DocUser10 := InvR.DocUser10;

    //PR: 06/06/2016 v2016 R2 ABSEXCH-17383
    DocUser11 := InvR.thUserField11;
    DocUser12 := InvR.thUserField12;

    //PR: 14/10/2013 MRD 2.5.17
    thDeliveryPostCode := InvR.thDeliveryPostCode;
    thDeliveryCountry := InvR.thDeliveryCountry;

    //PR: 28/10/2013 ABSEXCH-14705
    thOriginator := InvR.thOriginator;
    thCreationTime := InvR.thCreationTime;
    thCreationDate := InvR.thCreationDate;

    {$IFDEF COMTK}
    thOrderPaymentOrderRef := InvR.thOrderPaymentOrderRef;
    thOrderPaymentElement := Ord(InvR.thOrderPaymentElement);
    thOrderPaymentFlags := InvR.thOrderPaymentFlags;
    thCreditCardType := InvR.thCreditCardType;
    thCreditCardNumber := InvR.thCreditCardNumber;
    thCreditCardExpiry := InvR.thCreditCardExpiry;
    thCreditCardAuthorisationNo := InvR.thCreditCardAuthorisationNo;
    thCreditCardReferenceNo := InvR.thCreditCardReferenceNo;
    thCustomData1 := InvR.thCustomData1;
    {$ENDIF}

    //PR 23/03/2015 v7.0.14 ABSEXCH-16284: Added new fields for Prompt Payment Discount
    thPPDPercentage := InvR.thPPDPercentage;
    thPPDDays       := InvR.thPPDDays;
    thPPDGoodsValue := InvR.thPPDGoodsValue;
    thPPDVATValue   := InvR.thPPDVATValue;
    thPPDTaken      := Ord(InvR.thPPDTaken);

    //PR: 20/01/2016 ABSEXCH-17112 v2016 R1 Added Intrastat Out of Period flag (Read/Only)
    thIntrastatOutOfPeriod
                    := BoolToWordBool(InvR.thIntrastatOutOfPeriod);

    //AP: 21/11/2017 v2018 R1 ABSEXCH-19399
    {$IFDEF COMTK}
      thAnonymised := InvR.thAnonymised;
      thAnonymisedDate := InvR.thAnonymisedDate;
      thAnonymisedTime := InvR.thAnonymisedTime;
    {$ENDIF}
  end;
end; {proc..}

Procedure InvToExInv(Var ExInvRec  :  TBatchTHRec);
Begin
  CopyExInvToTKInv(Inv, ExInvRec);
End;


{* Get Actual Line Count *}
Function GetActualLineCount(InvFolioNum  :  LongInt)  :  LongInt;
Var
  TotCount     :  LongInt;
  KeyChk, KeyS :  Str255;
  KeyNum       : Integer;
  SavedPosOK   : Boolean;
  RecPos       : LongInt;
begin
  { HM 11/10/99: Added cutout facility as performance hit too bad in certain circumstances }
  If WantCalcLineCount Then Begin
    { HM 07/10/99: Save the current position in the transaction line file }
    KeyNum := GetPosKey;
    SavedPosOK := Presrv_BTPos(IDetailF, KeyNum, F[IDetailF], RecPos, false, false) = 0;

    KeyS:=FullNomKey(InvFolioNum);
    KeyChk:=KeyS;

    TotCount:=0;

    Status:=Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    Begin
      Inc(TotCount);
      Status:=Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);
    end;

    GetActualLineCount:=TotCount;

    { HM 07/10/99: Return to the original position in the transaction header file }
    if SavedPosOK then
      Presrv_BTPos(IDetailF, KeyNum, F[IDetailF], RecPos, true, false);
  End { If WantCalcLineCount }
  Else
    GetActualLineCount:=Inv.ILineCount;
end; {func..}



FUNCTION EX_GETTRANS(P              :  POINTER;
                     PLINES         :  POINTER;
                     PSIZE          :  LONGINT;
                     PLSIZE         :  LONGINT;
                     SEARCHKEY      :  PCHAR;
                     SEARCHPATH     :  SMALLINT;
                     SEARCHMODE     :  SMALLINT;
                     LOCK           :  WORDBOOL)  :  SMALLINT;


Var
  ExInvRec  :  ^TBatchTHRec;
  KeyS       :  Str255;

  ValidCheck,
  Locked     :  Boolean;
  LockStr    :  String[255];

  TmpVal     :  LongInt;

  //PR: 28/10/2013 ABSEXCH-14705
  oHeaderRecordHelper : IToolkitRecordHelper;
Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExInvRec:=P;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetTrans:' + #10#13 +
                 'P^.OurRef: ' + ExInvRec^.OurRef + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'PLSize: ' + IntToStr(PLSize) + #10#13 +
                 'SearchKey: ' + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: ' + LockStr);
  End; { If }

  Locked:=BOff;

  //PR: 28/10/2013 ABSEXCH-14705 Create and initialize record helper
  oHeaderRecordHelper := GetRecordHelper(rhTransHead);
  oHeaderRecordHelper.RecordSize := PSize;
  oHeaderRecordHelper.RecordPointer := P;

  Result := oHeaderRecordHelper.ErrorCode;

  If Result = 0 then
  Begin
    ExInvRec := oHeaderRecordHelper.RecordPointer;

    If (Not (SearchPath In [0..11])) then
      SearchPath:=0;

    KeyS:=StrPas(SearchKey);
    Blank(ExInvRec^,Sizeof(ExInvRec^));

    KeyS := SetKeyString(SearchMode, InvF, KeyS);

    Result:=Find_Rec(SearchMode,F[InvF],InvF,RecPtr[InvF]^,KeyInvFXLate[SearchPath],KeyS);

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyInvFXLate[SearchPath],InvF,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyInvFXLate[SearchPath],InvF,SilentLock,Locked));
    {$ENDIF}

    StrPCopy(SearchKey,KeyS);
    KeyStrings[InvF] := KeyS;
    If (Result=0) then
    Begin
      InvToExInv(ExInvRec^);
      {* LineCount has been calculated to get actual total lines *}
      {* check PLSize >= Size of Total TLs *}
      ValidCheck:=( ExInvRec^.LineCount <= (PLSize div SizeOf(TBatchTLRec)) );

      {If (PLines<>Nil) then {* Get Invoice Lines *}

      If (ValidCheck) then
        {* add PLSize para. *}
        Get_TransLines(Inv.FolioNum,IdetailF,IdFolioK,PLines,ExInvRec^.LineCount,PLSize)
      else
        Result:=32765;

    end; {if Result=0 ..}

  end {If .. Not assigned}
  else
    If ((P<>Nil) or (PLines<>Nil)) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(20,Result);

end; {Func..}

{* ---------------------------------------------------------------------------- }

FUNCTION EX_GETEBUSTRANS(P              :  POINTER;
                         PLINES         :  POINTER;
                         PSIZE          :  LONGINT;
                         PLSIZE         :  LONGINT;
                         SEARCHKEY      :  PCHAR;
                         SEARCHPATH     :  SMALLINT;
                         SEARCHMODE     :  SMALLINT;
                         LOCK           :  WORDBOOL) : SMALLINT;
begin
  LastErDesc := '';

  Result := SwitchToEBusinessFiles(true);
  if Result = 0 then
  begin
    IsEbusTran := true;
    Result := Ex_GetTrans(P, PLines, PSize, PLSize, SearchKey, SearchPath, SearchMode, Lock);
    SwitchToEBusinessFiles(false);
    IsEbusTran := false;
  end;

  { Ex_GetTrans index used }
  if Result <> 0 then
    LastErDesc := Ex_ErrorDescription(20, Result);
end;


{* ----------------------------------------------------------------------------
   To check whether the Transaction can be updated *}

Function CanBeUpdated(    DLLInv    :  TBatchTHRec;     { Header passed by DLL }
                      Var OInv      :  InvRec;          { Original Header (Inv) to be returned  }
                      Var EditNo    :  Byte )  :  Integer;  { No. of times tran. has been edited }

Var
  ChkKey,
  KeyS      :  Str255;
  ExStat    :  Integer;

  ViewCode  :  Byte;

  ViewOnlyRec,
  ValidHed,
  ValidCheck:  Boolean;

begin
  Result:=0;
  ExStat:=0;
  ValidHed:=BOff;
  EditNo:=1;

  FillChar(OInv, SizeOf(OInv), #0);

  {* Check Record Exists in Document.DAT *}
  KeyS:=LJVar(DLLInv.OurRef,DocLen);
  Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS);
  ValidCheck:=(Status=0);

  GenSetError(ValidCheck,30500,Result,ValidHed);

  {* To retrun Original INV *}
  If (ValidCheck) then
    OInv:=Inv;

  {* Check Valid Trans. Type to be updated *}  //PR 5/12/07 Added TSH
  ValidCheck:=(ValidCheck) and (Inv.InvDocHed In [SOR,SDN,SIN,POR,PDN,PIN,ADJ,PCR,PQU,
                                   SQU,SCR,PJI,PJC,SJI,SJC,WOR,WIN{$IFDEF COMTK},TSH, SBT, PBT,
                                   JPA,JSA,JCT,JST,JPT, SRN, PRN{$ENDIF}]);

  GenSetError(ValidCheck,30501,Result,ValidHed);

  {* Check whether the trans. is "View-Only" record *}
  If (ValidCheck) then
  begin
    ViewOnlyRec:=View_Status(Inv,False,ViewCode);
    If (Debug) then
      ShowMessage('Return View Code = '+IntToStr(ViewCode));
    {30.11.2000 - ViewCode=4 has been allowed - Printed }
    ValidCheck:=((Not ViewOnlyRec) or (ViewCode=9) or (ViewCode=3) or (ViewCode=4));
    {$IFDEF COMTK}
    ValidCheck := ValidCheck or ((ViewCode = 5) and (DllInv.UpdateExMode = 1));
    {$ENDIF}
    GenSetError(ValidCheck,30502,Result,ValidHed);
  end; {if..}


  {* If Header can be updated, check Lines *}
  If (ValidCheck) then
  begin

    KeyS:=FullNomKey(Inv.FolioNum);
    ChkKey:=KeyS;

    Status:=Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

    {* Get the EditNio from Id record *}
    If (CheckKey(ChkKey,KeyS,Length(ChkKey),BOn)) then
    begin
      If (Id.DLLUpdate>0) then
        EditNo:=Id.DLLUpdate+1;
    end; {if..}

    (* 11.08.2000 - This loop has been closed since no need to validate each line
       and added above line to get the Edit No only....

    While (ValidCheck) and (Status=0) and (CheckKey(ChkKey,KeyS,Length(ChkKey),BOn)) do
    With Id do
    Begin
      { These checkings have been added as 30700 and 30701 in the validation

      If (TInv.InvDocHed In [SIN,PIN,SDN,PDN]) then
        ValidCheck:=(SOPLink=0) and (SOPLineNo=0);
      If (TInv.InvDocHed In [SOR,POR]) then
        ValidCheck:=(QtyWOFF=0) and (QtyDel=0);
      }

      {* No. of times edited for this line *}
      If (Id.DLLUpdate>0) then
        EditNo:=DLLUpdate+1;

      Status:=Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

    end; {while..}

    *)

    {DLLUpdate field is Byte, hence change to 1 again if > 250 }
    If (EditNo>250) then
      EditNo:=1;

  end; {if..}

end; {CanbeUpdated..}

//PR: 19/03/2009 Added function to allow Importer to create Auto Transactions
{$IF Defined(COMTK) and Defined(IMPV6)}
procedure SetNextAutoDocNo(var FTH : TBatchTHRec);
var
  AnInv : InvRec;
  AcPr, AcYr : Byte;
begin
  FillChar(AnInv, SizeOf(AnInv), #0);
  AnInv.InvDocHed := TKDocTypeToEntDocType(FTH.TransDocHed);

  SetNextAutoDocNos(AnInv, True);

  FTH.OurRef := AnInv.OurRef;
  FTH.FolioNum := AnInv.FolioNum;
  FTH.RunNo := -2;

  //Set default dates & periods if blank
  if FTH.TransDate = '' then
    FTH.TransDate := Today;
  if FTH.AutoEndDate = '' then
    FTH.AutoEndDate := '21491231';
  SimpleDate2Pr(Today, AcPr, AcYr);
  if FTH.AcYr = 0 then
    FTH.AcYr := AcYr;
  if FTH.AcPr = 0 then
    FTH.AcPr := AcPr;
  SimpleDate2Pr('21491231', AcPr, AcYr);
  if FTH.AutoEndYr = 0 then
    FTH.AutoEndYr := AcYr;
  if FTH.AutoEndPr = 0 then
    FTH.AutoEndPr := AcPr;

end;
{$IFEND}


{* ----------------------------------------------------------------------------
   Convert from Toolkit record structure (TBatchTHRec)
   to Enterprise record structure (Inv) *}
Function ExInvToInv(ExInvRec     :  TBatchTHRec;
                    AddMode      :  SmallInt;
                Var OrgInv       :  InvRec;
                Var EditNo       :  Byte)  :  Integer;

{* OrgInv has been added for updating Account Balance if B_Update is used *}
Var
  i         :  integer;
  n         :  Byte;

  OInv      :  InvRec;

  FindRec,
  ValidCheck,
  ValidHed,
  EBusDocTypeOK
            : Boolean;
  KeyS1,
  KeyS      : Str255;

  UpdateOK  :  SmallInt;

  IntRefNo  :  Integer;

Begin
  FindRec := False;
  Result:=0;
  ValidCheck:=BOff;
  ValidHed:=BOn;

  //PR: 19/03/2009 Allow Importer to create Auto Transactions
  {$IF Defined(COMTK) and Defined(IMPV6)}
  if ExInvRec.thAutoTransaction then
    SetNextAutoDocNo(ExInvRec);
  {$IFEND}

  Fillchar(OrgInv,SizeOf(OrgInv),#0);

  With Inv do
  Begin
    {* If Insert Mode *}
    If (Abs(AddMode)=B_Insert) then
    Begin

      {* If the transaction has its own Reference No.,
         validate the reference number in the file. *}
      If (Not ExSyss.OverWORef) then
      begin
        KeyS:=FullOurRefKey(UpperCase(ExInvRec.OurRef));
      {  Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS);
        FindRec:=StatusOk;}

        //Change from Find_Rec to CheckRecExsists to preserve position in InvFile
        FindRec := CheckRecExsists(KeyS, InvF, InvOurRefK);


        {* If the reference no. exists, return as an Error *}
        If (FindRec) then
          GenSetError(Not FindRec,5,Result,ValidHed)
        else
        begin
          {* If the Ref. No. does not exist, the first 3 characters must be
             the valid Transaction Type (SIN, SCR, etc..) *}
          KeyS:=Copy(ExInvRec.OurRef,1,3);
          if InEBusinessMode then
            for i := 1 to EBUSINESS_COUNTERS do
               FindRec := FindRec or (KeyS = EBUSINESS_DOCS[i])
          else
            FindRec:=( DocCodes[DocTypeFCode(EXInvRec.TransDocHed)] = KeyS );

          If (Not FindRec) then
            GenSetError(FindRec,3,Result,ValidHed);

          {* 07.04.2000 - last 6 digits must be numeric *}
          //PR 11/04/03 - Change to allow 4th digit to be alpha
          KeyS:=Copy(ExInvRec.OurRef,4,6);
         {$IFNDEF PREV561001}
           GenSetError(CheckDocNo(KeyS), 30120, Result, ValidHed);
         {$ELSE}
          IntRefNo:=StrToIntDef(Keys,0);
          GenSetError((IntRefNo>0),30120,Result,ValidHed);
         {$ENDIF}
        end; {if (FindRec) ..}

      end;  {if Not Exsyss.OverWORef then }

    end
    else  {if Abs(AddMode)=Edit..}
    Begin
      { Don't display msg if -ve as it's allowed }
      If (AddMode > 0) and (AddMode<>B_Update) Then
        GenSetError(FindRec,4,Result,ValidHed);

      OInv:=Inv;

      { 4.31-Edit }
      If (AddMode=B_Update) then
      begin
        {* Validate whether the tran. can be updated *}
        Result:=CanbeUpdated(ExInvRec,OrgInv,EditNo); {* OrgInv = Original INV record *}


      end; {if AddMode=B_Update..}

    end; {if Abs(AddMode)=Edit...}


    {* ---- Inv Conversion starts here ------- *}
    If (Result=0) then
    begin
      { HM 11/07/00: Fix for STORETH problem.
        StoreTH is only for internal usage, hence should not reset the record. }
      If (AddMode <> -B_Update) then Begin
        {$IFDEF COMTK}
        if ExInvRec.UpdateExMode = 0 then
        {$ENDIF}
          ResetRec(InvF);

        {* If UPDATE mode, the following fields should not be changed *}
        If (AddMode=B_Update) then
        begin
          FolioNum:=OrgInv.FolioNum;
          NLineCount:=OrgInv.NLineCount;
          ILineCount:=OrgInv.ILineCount;
          AuthAmnt := OrgInv.AuthAmnt;
          CISTax := OrgInv.CISTax;
          CISDeclared := OrgInv.CISDeclared;
          CISManualTax := OrgInv.CISManualTax;
          CISDate := OrgInv.CISDate;
          CISEmpl := OrgInv.CISEmpl;
          CISGross := OrgInv.CISGross;
          CISHolder := OrgInv.CISHolder;

          //PR: 05/04/2012 ABSEXCH-12769 (12764)
          PickRunNo := OrgInv.PickRunNo;

          //PR: 28/10/2010 ABSEXCH-14705 Restore PPD Totals from original transaction - these are r/o
          thPPDGoodsValue := OrgInv.thPPDGoodsValue;
          thPPDVATValue := OrgInv.thPPDVATValue;

        end
        else
        begin
          {* If INSERT mode, set Notes line count and Total Transaction Line Count *}
          NLineCount:=1;
          ILineCount:=EXInvRec.LineCount;
        end; {if..}


      End; { If (AddMode <> -B_Update) }

      CustCode:=FullCustCode(EXInvRec.CustCode);        { Account Code }
      OurRef:=FullOurRefKey(UpperCase(EXInvRec.OurRef));{ Our Ref. No. SIN000001, etc..}
      Currency:=EXInvRec.Currency;                      { Header Currency Code }

      {* Acounting Year and Period are Byte fields, hence need to check not to get
         the Range Check error *}
      If (ExInvRec.AcYr>1900) then
        AcYr:=(ExInvRec.AcYr - 1900)
      else
        If (EXInvRec.AcYr In [0..255]) then
          AcYr:=EXInvRec.AcYr;

      If (EXInvRec.AcPr In [0..255]) then
        AcPr:=EXInvRec.AcPr;

      {* 13.10.98 - added to get the current periods if -1 is assigned.
         If Auto_Set_Period is OFF and both period fields are set to -1,
         then the current Enterprise Periods should be used in transaction.  *}
      If (Not ExSyss.AutoSetPr) and ((ExInvRec.AcPr=-1) or (ExInvRec.AcYr=-1)) then
      begin
        AcYr:=Syss.CYr;
        AcPr:=Syss.CPr;
      end; {if..}

      DueDate:=EXInvRec.DueDate;                { Due Date }
      TransDate:=EXInvRec.TransDate;            { Transaction Date }
      if Trim(EXInvRec.YourRef) <> '' then
        YourRef:=LJVar(EXInvRec.YourRef, DocYRef1Len)
      else
        FillChar(YourRef[0], Length(YourRef) + 1, 0); { Your Ref. } //PR 2/4/04 - pad out to correct len
      TransDesc:=LJVar(EXInvRec.LongYrRef, DocYRef2Len);            { Alternative Ref. }  //PR 2/4/04 - pad out to correct len

      {* From External to Ent. record *}
      CXRate[BOff]:=EXInvRec.CoRate;            { Transaction Exchange Rate }
      CXRate[BOn]:=EXInvRec.VATRate;            { VAT Exchange Rate }
      SetTriRec(Currency,UseORate,CurrTriR);    { for v4.31 }


      InvDocHed:=DocTypeFCode(EXInvRec.TransDocHed);  { Transaction Type SIN,SCR, etc..}


      {* 05.01.99 - Added for not to return Range Check Error
                    DocTypeFCode function in BTS1 has been modified as well. *}
      if InEBusinessMode then
      begin
        InvDocHed := EBusOurRefCodeToEnum(ExInvRec.TransDocHed, EBusDocTypeOK);
        if not EBusDocTypeOK then
          Result:=30217;    { SM - Used the new error code - JF ooOOOoo !!! }
      end
      else
        if (DocCodes[InvDocHed]<>ExInvRec.TransDocHed) then
          Result:=30215;


      {* VAT Analysis Values *}
      {* 11.01.2000 - changed to Total 21 *}
      if InvDocHed <> NMT then
      begin
        ManVAT:=WordBoolToBool(ExInvRec.ManVAT);             { Manual VAT Calculation allowed Yes/No }
      {$IFDEF EN551}
      end;
      {$ENDIF}
        InvVAT:=ExInvRec.InvVAT;                  { Header Total VAT Value }
        For n:=0 to 20 do  {* changed from 9 to 16 on 10.06.97 *}
          InvVATAnal[GetVATNo(THVATCode[n],#0)]:=ExInvRec.InvVATAnal[n];
      {$IFNDEF EN551}
      end;
      {$ENDIF}

       {InvVATAnal[VATType(n)]:=ExInvRec.InvVATAnal[n];}

      InvNetVal:=ExInvRec.InvNetVal;            { Header Net Value }
      DiscSetl:=ExInvRec.DiscSetl;              { Settlement Discount %}
      DiscSetAm:=ExInvRec.DiscSetAm;            { Settlement Discount Amount }
      DiscAmount:=ExInvRec.DiscAmount;          { Header Total Discount Amount }
      DiscDays:=ExInvRec.DiscDays;              { Settlement Discount Days }
      DiscTaken:=WordBoolToBool(ExInvRec.DiscTaken);       { Discount Taken Yes/No }
      TransNat:=ExInvRec.TransNat;              { VAT Nature of Transaction }
      TransMode:=ExInvRec.TransMode;            { VAT Mode of Transport }
      HoldFlg:=ExInvRec.HoldFlg;                { Hold Status }
      TotalWeight:=ExInvRec.TotalWeight;        { Header Total Weight }

      For n:=1 to 5 do
        DAddr[n]:=ExInvRec.DAddr[n];            { Delivery Address 5 Lines }

      TotalCost:=ExInvRec.TotalCost;            { Header Total Cost }
      PrintedDoc:=WordBoolToBool(ExInvRec.PrintedDoc);     { Printed Status }
      DelTerms:=ExInvRec.DelTerms;              { Delivery Terms }
      OpName:=ExInvRec.OpName;                  { Operator Name }
      DJobCode:=FullJobCode(UpperCase(ExInvRec.DJobCode)); { Header Job Code }

      //PR: 01/11/2011 v6.9 We allow any text in Analysis Code if Job Code is blank, so don't upper case or pad it
      if EmptyKey(DJobCode,JobCodeLen) then
        DJobAnal := ExInvRec.DJobAnal
      else
        DJobAnal:=FullJACode(UpperCase(ExInvRec.DJobAnal));  { Header Job Analysis Code }

      {* 02.09.99 - If SOR/POR this needs to display on Ledger Screen *}
      If (InvDocHed In PSOPSet) then
//        TotOrdOS:=(ExInvRec.InvNetVal - ExInvRec.DiscAmount);
          TotOrdOS := 0;

      {* If TimeSheet transaction, Employee Code is assigned in BatchLink field *}
      If (InvDocHed In TSTSplit) then
      begin
        BatchLink:=FullCustCode(ExInvRec.EmpCode);
      end;

      DocUser1:=ExInvRec.DocUser1;              { User Defined Field 1 }
      DocUser2:=ExInvRec.DocUser2;              { User Defined Field 2 }
      NoLabels:=ExInvRec.thNoLabels;            { No. of Labels }
      CtrlNom:=ExInvRec.CtrlNom;                { Control Nominal Code }

      Tagged:=ExInvRec.Tagged;             { Tagged Status Yes/No }

      {*** Ver 4.31 ***}
      { To allow SOPKeepRate to be set needs to be POR/SOR and daily rate }
      //PR 07/01/2009 SORKeepRate (thFixed) can be set on SOR/POR and SRN/PRN trans. For any other type it should be set to false on add, but existing
      //value retained on update.
      if (Syss.TotalConv = 'C') then  //Company rate - thFixed n/a
        SOPKeepRate := false
      else
      begin
        if (InvDocHed in OrderSet + StkRetSplit) then
          SOPKeepRate := WordBoolToBool(ExInvRec.SOPKeepRate)
        else
        if AddMode = B_Insert then
          SOPKeepRate := False
        else
          SOPKeepRate := OrgInv.SOPKeepRate;
      end;

      DocUser3:=ExInvRec.DocUser3;              { User Defined Field 3 }
      DocUser4:=ExInvRec.DocUser4;              { User Defined Field 4 }
      SSDProcess:=UpCase(ExInvRec.SSDProcess);  { has validation }
      ExtSource:=ExInvRec.ExtSource;
      PostDate:=ExInvRec.PostDate;
      PORPickSOR:=WordBoolToBool(ExInvRec.PORPickSOR);
      BDiscount:=ExInvRec.BDiscount;
      PrePostFlg:=ExInvRec.PrePostFlg;

      TotalCost2 := ExInvRec.TotalCost2;
      NOMVatIO := ExInvRec.NOMVATIO;
      {$IFDEF COMTK}
      if AllowCtrlGLs then
      begin
        TotalReserved := ExInvRec.thTotalReserved;
        PostDiscAm := ExInvRec.thPostDiscAmount;
        Variance := ExInvRec.thVariance;
        TotalOrdered  := ExInvRec.thTotalOrdered;
        RevalueAdj := ExInvRec.thRevalueAdj;
      end;
      DeliverRef := ExInvRec.thDeliveryNoteRef;
      AutoInc := ExInvRec.AutoInc;
      AutoIncBy := ExInvRec.AutoIncBy;
      UntilDate := ExInvRec.AutoEndDate;

      //PR: 23/03/2009 Change to deal with 4 digit year
      If (ExInvRec.AutoEndYr>1900) then
        UnYr:=(ExInvRec.AutoEndYr - 1900)
      else
        If (EXInvRec.AutoEndYr In [0..255]) then
          UnYr:=EXInvRec.AutoEndYr;

      If (EXInvRec.AutoEndPr In [0..255]) then
        UnPr:=EXInvRec.AutoEndPr;

{      UnPr := ExInvRec.AutoEndPr;
      UnYr := ExInvRec.AutoEndYr;}
      AutoPost := ExInvRec.AutoPost;

      //PR: 16/08/2017 ABSEXCH-18934 Prevent TotalInvoiced being set by Importer -
      //                             it can still be set by Entlib back door
      {$IFNDEF IMPv6}
      TotalInvoiced := ExInvRec.TotalInvoiced;
      {$ENDIF IMPv6}
      BatchNom := ExInvRec.BatchNom;
      OnPickRun := WordBoolToBool(ExInvRec.thOnPickRun);
      if not (InvDocHed In TSTSplit) then
        BatchLink := ExInvRec.BatchLink;
      RemitNo := ExInvRec.RemitNo;
      NomAuto := WordBoolToBool(ExInvRec.NomAuto);
      thExportedFlag := WordBoolToBool(ExInvRec.thExported);

      Untagged := ExInvRec.NomAutoReverse;
      if (AddMode = B_Insert) or (ExInvRec.RunNo = -10) then
      begin
        RunNo := ExInvRec.RunNo;
        FolioNum := ExInvRec.FolioNum;
      end;

      if InvDocHed in JAPSplit then
      begin
        CISEmpl := LJVar(UpperCase(ExInvRec.CISEmpl), 6);
        CISHolder := ExInvRec.CISHolder;
        PDiscTaken := ExInvRec.thPostDiscTaken;
      end;

      if ExInvRec.BDMode = 1 then
      begin
        AllocStat := ExInvRec.AllocStat;
        BatchLink := ExInvRec.thDeliveryRunNo;
        ExtSource := ExInvRec.ExtSource;
        OrdMatch := ExInvRec.thOrdMatch;
      end;
      {$ENDIF}
      TotalCost2 := ExInvRec.TotalCost2;
    {$IFDEF EN551}
      NOMVatIO := ExInvRec.NOMVatIO;
    {$ENDIF}

     //PR: 04/02/2010 Added fields for web extensions
     thWeekMonth := ExInvRec.thWeekMonth;
     thWorkflowState := ExInvRec.thWorkflowState;

     //To keep backward compatibility, we only set DiscDays to WeekMonth if DiscDays in the tk record hasn't been set.
     if (InvDocHed = TSH) and (ExInvRec.DiscDays = 0) then
       DiscDays := ExInvRec.thWeekMonth;

     //PR: 15/10/2010 New field for LIVE
     //PR: 16/11/2011 Ensure field is padded correctly ABSEXCH-12133/12151
     if AllowOverrideLocation(InvDocHed) then
       thOverrideLocation := Full_MLocKey(UpperCase(ExInvRec.thOverrideLocation));

     //PR: 21/10/2011 v6.9
      DocUser5 := ExInvRec.DocUser5;
      DocUser6 := ExInvRec.DocUser6;
      DocUser7 := ExInvRec.DocUser7;
      DocUser8 := ExInvRec.DocUser8;
      DocUser9 := ExInvRec.DocUser9;
      DocUser10 := ExInvRec.DocUser10;

      //PR: 06/06/2016 v2016 R2 ABSEXCH-17383
      thUserField11 := ExInvRec.DocUser11;
      thUserField12 := ExInvRec.DocUser12;


      //PR: 14/10/2013 MRD 2.5.17
      thDeliveryPostCode := ExInvRec.thDeliveryPostCode;
      thDeliveryCountry := ExInvRec.thDeliveryCountry;

      //PR: 28/10/2013 ABSEXCH-14705 Only set originator on new transactions
      //PR: 17/05/2016 ABSEXCH-17259 Allow originator to be set on updated transactions
      if Trim(ExInvRec.thOriginator) <> '' then
        thOriginator := Trim(ExInvRec.thOriginator)
      else  //Set from default
        thOriginator := UpperCase(Trim(ExSyss.DefaultUser));

      if AddMode = B_Insert then
      begin
        thCreationDate := FormatDateTime('yyyymmdd', Now);
        thCreationTime := FormatDateTime('hhnnss', Now);
      end
      else
      begin
        thCreationTime := OrgInv.thCreationTime;
        thCreationDate := OrgInv.thCreationDate;
      end;



    //PR: 04/02/2010 Moved this section into Result = 0 section
    {$IFDEF COMTK}
      //Store TTD Value & Flag if any
     TTDValue := ExInvRec.thTTDValue;
     TTDFlag := ExInvRec.thTTDFlag;
     GlobVBDValue := ExInvRec.thVBDValue;
     GlobVBDVAT := ExInvRec.thVBDVAT;
     thOrderPaymentOrderRef := ExInvRec.thOrderPaymentOrderRef;
     thOrderPaymentElement := enumOrderPaymentElement(ExInvRec.thOrderPaymentElement);
     thOrderPaymentFlags := ExInvRec.thOrderPaymentFlags;
     thCreditCardType := ExInvRec.thCreditCardType;
     thCreditCardNumber := ExInvRec.thCreditCardNumber;
     thCreditCardExpiry := ExInvRec.thCreditCardExpiry;
     thCreditCardAuthorisationNo := ExInvRec.thCreditCardAuthorisationNo;
     thCreditCardReferenceNo := ExInvRec.thCreditCardReferenceNo;
     thCustomData1 := ExInvRec.thCustomData1;

     //PR: 26/11/2014 Order Payments
     thDeliveryCountry := ExInvRec.thDeliveryCountry;
    {$ENDIF}

     // MH 30/06/2015 v7.0.14 ABSEXCH-16618: Need to read the Trader before checking the PPD Mode
     If (Cust.CustCode <> Inv.CustCode) Then
       CheckRecExsists(CustCode, CustF, CustCodeK);

     //PR: 27/08/2015 ABSEXCH-16790 Replace a/c rec with Head Office if applicable
     if (InvDocHed in [PQU, POR, SQU, SOR]) and (Trim(Cust.SOPInvCode) <> '') then
       CheckRecExsists(Cust.SOPInvCode,CustF,CustCodeK);


     //PR 23/03/2015 v7.0.14 ABSEXCH-16284: Added new fields for Prompt Payment Discount
     //PR: 19/06/2015 ABSEXCH-16548; ABSEXCH-16548 Don't set ppd fields unless valid a/c and trans type
     if (Cust.acPPDMode <> pmPPDDisabled) and (Inv.InvDocHed in PPDTransactions) then
     begin
       thPPDPercentage := ExInvRec.thPPDPercentage;
       thPPDDays       := ExInvRec.thPPDDays;
       thPPDTaken      := TTransactionPPDTakenStatus(ExInvRec.thPPDTaken);
       UpdatePPDTotals(Inv);
     end;

    end; {if Result=0..}
  end; {With..}



end; {Func..}

{* ---------------------------------------------------------------------------
   Convert each transaction line from DLL record (TBatchTLRec) into
   Enterprise Line record (Id) *}

Function ExInvLineToId(ExIdRec   :  TBatchTLRec;
                       SMode     :  SmallInt)  :  Integer;
  var
    ValidCheck : Boolean;
    VATIdx : VATType;

  //PR 27/08/03 Take doctype from line rather than header, as in some cases header may be undefined
  function GetDocHed : DocTypes;
  var
    DocCode : string;
  begin
    {$IFDEF COMTK}
    DocCode := ExIdRec.DocHed;
    {$ELSE}
    DocCode := '';
    {$ENDIF}
    if Trim(DocCode) = '' then
      DocCode := Copy(ExIdRec.TransRefNo, 1, 3);

    //Paul 5.60
    //Previously, an empty doctype was getting set to PRN. with the addition of apps & vals types
    //it's getting set to JPA which has bad effects on calculations. Restore to original setting.
    if Trim(DocCode) = '' then
      DocCode := 'PRN';

    Result := DocTypeFCode(DocCode);
  end;

Begin
  Result:=0;
  ResetRec(IDetailF);

  With Id do
  Begin
    {* The following fields are updated from Header (Inv) record *}
    FolioRef:=Inv.FolioNum;             { Folio Reference No.}
    if SMode <> 0 then
      IDDocHed:=Inv.InvDocHed       { Transaction Type }
    else
      IDDocHed:=GetDocHed;          { Transaction Type }
    DocPRef:=Inv.OurRef;                { In v4.31 - Our Reference }
    PYr:=Inv.ACYr;                      { Accounting Year }
    PPr:=Inv.AcPr;                      { Accounting Period }

    //  Original...
{    If (ExIdRec.Payment) then
      Payment:=SetRPayment(IDDocHed)
    else
      Payment:=DocPayType[IdDocHed];}


    LineNo:=ExIdRec.LineNo;

    if LineNo > HighLineNo then
      HighLineNo := LineNo;
    {20.03.2000 - if GetTrans has been used and LineNo has not been changed,
    this is very important to prevent incorrect ABSLineNo }

    If (LineNo=RecieptCode) then
      LineNo:=TLLineNo;

    {* 16.03.2000 - This has to be before ReceiptCode assignment,
    otherwise, ABS Line No would not be correct. *}
    {$IFNDEF COMTK}
    ABSLineNo:=LineNo;
    {$ELSE}
    if (IDDocHed in JAPSplit) or (ExIdRec.BDMode = 1) then
      ABSLineNo := ExIdRec.AbsLineNo
    else
      AbsLineNo := LineNo;
    {$ENDIF}

    //PR 25/06/03 Added specific setting for noms. After 551 release
    //check this area to see why original above was taken out.
    //BUGFIX - PR: 11/06/04 - moved this to above LineNo := RecieptCode line as needs to be set first.
    if IDDocHed = NMT then
      Payment := DocPayType[NMT]
    else
    {$IFDEF COMTK}
    if (IDDocHed in JAPSplit) then
    begin
     if (SMode = B_Update) then
       Payment := ExIdRec.PaymentCode
     else
     begin
       if LineNo > 0 then
         Payment := 'Y'
       else
         Payment := 'N';

     end;
    end
    else
    {$ENDIF}
    If WordBoolToBool(ExIdRec.Payment) then
      Payment:=DocPayType[SRC]
    else
      Payment:=DocPayType[SIN];


    If ((Payment=DocPayType[SRC]) or (IdDocHed In NomSplit+StkAdjSplit)) and not (IdDocHed in JAPSplit) then
      LineNo:=RecieptCode;


    NomCode:=ExIdRec.NomCode;

    {* Currency & EXRate *}
    Currency:=ExIdRec.Currency;
    CXRate[BOff]:=ExIdRec.CoRate;
    CXRate[BOn]:=ExIdRec.VATRate;
    SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }

    If (SMode <> 0) and ((Not ExSyss.MCMode) or (Not (IdDocHed In RecieptSet+NomSplit+StkAdjSplit+TSTSplit))) then
    Begin
      Currency:=Inv.Currency;
      CXRate:=Inv.CXRate;
      CurrTriR:=Inv.CurrTriR; { for v4.31 }
    end; {if..}


    CCDep[BOn]:=FullCCDepKey(UpperCase(ExIdRec.CC));      { Cost Centre }
    CCDep[BOff]:=FullCCDepKey(UpperCase(ExIdRec.Dep));    { Department }

    {StockCode:=FullStockCode(Strip('B',[#1,#32],ExIdRec.StockCode));}

    { 07.07.2000 }
    //PR: 5/9/02 - Don't allow stockcode on NOM
    //PR: 27/03/06 - Allow StockCode (PayRef) on Noms
    //PR: 30/5/06 - Don't UpperCase and pad payref
    if not (IDDocHed in [NMT]) then
      StockCode:=FullStockCode(Strip('B',[#1,#32],ExIdRec.StockCode))
    else
      StockCode := ExIdRec.StockCode;

    {$IFDEF COMTK}
    //if PayRate on TSH didn't meet rules then set it to blank to cause a 30113 error.
    if (IDDocHed = TSH) and (ExIDRec.InvalidTSHRates) then
      FillChar(StockCode[0], Length(StockCode) + 1, 0);
    {$ENDIF}

    Qty:=ExIdRec.Qty;
//    if (IDDocHed in JAPSplit) or (ExIdRec.KitLink <> 0) then
      QtyMul:=ExIdRec.QtyMul;
{    else
      QtyMul := 0;}

    //PR: 25/05/02 Changed so that qtypick & qtypwoff could be set on add as well as update
//PR: 10/12/02 Bugfix - added SDN & PDN so that qtypick is saved for them, otherwise non-stock items don't get
//             invoiced
      //PR: 20/05/2010 Took delivery notes out as we shouldn't allow QtyPick to be updated. Reset below from existing record
      If (IDDocHed In [SOR,POR{,SDN,PDN}] + StkRetSplit) then      { If SOR or POR }
      begin
        //PR: 5/9/02 changed so that can't pick lines on transaction on credit hold
        if Inv.HoldFlg and 7 <> 6 then
          QtyPick:=ExIdRec.QtyPick;               { Pick Qty }

        //PR: 17/11/03 - Set QtyPick to qty for delivery notes to avoid 30505 errors
{        if (IDDocHed in [PDN, SDN]) and (Qty > 0) then
          QtyPick := Qty;}

        QtyPWOff:=ExIdRec.QtyPWOff;             { WriteOff Qty }
      end; {If SOR,POR...}

      {$IFDEF COMTK}
      if IDDocHed in JAPSplit then
      begin
        QtyPWoff := ExIdRec.QtyPWOff;
        QtyPick := ExIdRec.QtyPick;
        AutoLineType := ExIdRec.AutoLineType;
      end;
      {$ENDIF}

    If (IDDocHed In WOPSplit) then
    begin
      if Inv.HoldFlg and 7 <> 6 then
        QtyPick:=ExIdRec.QtyPick;               { Pick Qty }
      QtyPWOff:=ExIdRec.QtyPWOff;             { WriteOff Qty }
    end; {If SOR,POR...}

    If (QtyMul=0) then
      QtyMul:=1;
    If (Trim(StockCode) <> '') then
    begin

      ValidCheck:=(CheckRecExsists(StockCode,StockF,StkCodeK));

      if ValidCheck then
      begin
        ID.UsePack := Stock.CalcPack;
        ID.PrxPack := Stock.PricePack;


        ID.ShowCase := Stock.DPackQty;

      // HM 09/07/01: Mod for ADJ Pack Qty support
      // HM 10/07/01: Removed limitation to ADJ only after consultation with EL
      //              as same problem was hapening with any trans type using stock
      //If (Inv.InvDocHed = ADJ) Then
        ShowCase := Stock.DPackQty;

      //PR 14/11/06: We need to set QtyPack even if Stock.DPackQty is false
//        If (Stock.DPackQty) then
        begin
        //PR 6/7/05 - QtyPack was always being set to buyunit which didn't work if buyunits & sellunits were different.
          if ID.IdDocHed in SalesSplit then
            ID.QtyPack := Stock.SellUnit
          else
            ID.QtyPack := Stock.BuyUnit;
        end;


        Qty := Case2Ea(ID, Stock, Qty);
        QtyPick := Case2Ea(ID, Stock, QtyPick);
        QtyPWoff := Case2Ea(ID, Stock, QtyPWoff);
        QtyDel := Case2Ea(ID, Stock, QtyDel);
        QtyWoff := Case2Ea(ID, Stock, QtyWoff);

        //PR 09/07/04 - Set SerialQty in the same way as Enterprise
{        if (SMode <> B_Update) and (Stock.StkValType = 'R') and not (Inv.InvDocHed in [SOR, POR]) then
          SerialQty := Qty * QtyMul;}
      end;
    end;



    //PR: 29/04/02 Added this as heinz use it - needs special ini file switch
    if ExSyss.AllowQtyDel or (SMode = B_Update) or (IdDocHed in JAPSplit) then
      QtyDel := ExIdRec.QtyDel;


    NetValue:=ExIdRec.NetValue;         { Unit Value }

    //PR 12/11/02 Round discount to 2 dec places to sort problem in trade counter
    //Discount:= Round_Up(ExIdRec.Discount, 2);         { Unit Discount Value }
    // HM 13/11/02: Modified Discount rounding as amounta and percentages need to be rounded differently
(*    If (ExIdRec.DiscountChr = '%') Then
      // Percentage Discount where 1.25% = 0.0125 therefore need to round to 4dp
      Discount:= Round_Up(ExIdRec.Discount, 4)         { Unit Discount Value }
    Else
      // Amount Discount where £1.25 = 1.25 so round to 2dp
      Discount:= Round_Up(ExIdRec.Discount, 2);         { Unit Discount Value } *)

    If (ExIdRec.DiscountChr = '%') Then
      // Percentage Discount where 1.25% = 0.0125 therefore need to round to 4dp
      Discount:= Round_Up(ExIdRec.Discount, ExSyss.DiscountDec + 2)         { Unit Discount Value }
    Else
      // Amount Discount where £1.25 = 1.25 so round to 2dp
      Discount:= Round_Up(ExIdRec.Discount, ExSyss.DiscountDec);         { Unit Discount Value }

    //PR 9/9/02 - Add vat inclusive value
    IncNetValue := ExIdRec.IncNetValue;

    {$IFDEF EN551}
    NOMIOFlg := ExIdRec.NomVatType;
    if (IDDocHed = NMT) and (NOMIOFlg <> 0) then
      VatNeededOnNom := True;
    {$ENDIF}

    //PR: 5/9/02 - Don't allow Vat on NOM + ADJ, WOR & Payment lines 30/10/02
    //PR 06/05/03 In v551 Vat is allowed on noms
    if not (IDDocHed in [{$IFNDEF EN551} NMT, {$ENDIF} ADJ, WOR]) and
           ((not WordBoolToBool(ExIdRec.Payment)) or (IDDocHed = NMT)) then
    begin
      VATCode:=ExIdRec.VATCode;           { Line VAT Code }
      {$IFDEF EN551}
(*      if (Inv.InvDocHed = NMT) and (ExIdRec.NomVatType = 1) {auto vat} then
      begin
        CalcVat(ID, 0.0);
        Inv.InvVat := Inv.InvVat + ID.VAT;
        Inv.InvVATAnal[GetVATNo(ID.VATCode,#0)]:= Inv.InvVATAnal[GetVATNo(ID.VATCode,#0)] + ID.Vat;
      end
      else *)
      {$ENDIF}
        VAT:=ExIdRec.VAT;                   { Line VAT Amount }
    end;

    if not (IDDocHed in JAPSplit) then
      DiscountChr:=ExIdRec.DiscountChr   { Discount Type }
    else
      DiscountChr := '%';
    CostPrice:=ExIdRec.CostPrice;       { Unit Cost Price }

    If (IDDocHed In SalesSplit+PurchSplit+JAPSplit) then  { Account Code }
      CustCode:=Inv.CustCode;

    {* Changed on 21.11.97 for TL Delivery Date *}
    //PR: 25/11/2011 Added PDN & SDN to check so that line date is reset to header date ABSEXCH-12106
    If (Not EmptyKey(ExIdRec.LineDate,SizeOf(PDate))) and
       (Not (IDDocHed In [NMT,ADJ,SBT,PBT, PDN, SDN])) then
          PDate:=ExIdRec.LineDate
    else
      PDate:=Inv.TransDate;

    Item:=ExIdRec.Item;                 { Line Item No. }
    Desc:=ExIdRec.Desc;                 { Line Description }
    LWeight:=ExIdRec.LWeight;           { Line Weight }

    //PR: 5/9/02 - Don't allow location on NOM
    //AP : 28/03/2017 2017-R1 ABSEXCH-18534 : MultiLocation Disable/do not exist in application,
    //Utilities>SystemSetup gives error message when click on OK once any transactions are imported via Importer
    if not (IDDocHed in [NMT]) and (Syss.UseMLoc) then
      MLocStk:=Full_MLocKey(UpperCase(ExIdRec.MLocStk));           { Multi-location code }

    //AP : 28/03/2017 2017-R1 ABSEXCH-18534 : Checks for the System set up for Multi Location to be ON.
    DeductMLoc:=(ExSyss.UseMLoc) and (Syss.UseMLoc);       { Deduct from Location Stock Y/N }

    // HM 13/08/01: Added FullxxxCode calls as was preventing posting from
    //              Job Daybook if Job Code is < 10 chars
    JobCode:=FullJobCode(UpperCase(ExIdRec.JobCode));   { Line Job Code }
    {$IFDEF COMTK}
    if (IDDocHed in JAPSplit) and (ExIDRec.InvalidJobCode) then
      FillChar(JobCode[0], Length(JobCode) + 1, 0);
    {$ENDIF}


    //PR: 01/11/2011 v6.9 We allow any text in Analysis Code if Job Code is blank, so don't upper case or pad it
    if EmptyKey(JobCode,JobCodeLen) then
      AnalCode := ExIdRec.AnalCode
    else
      AnalCode:=FullJACode(UpperCase(ExIdRec.AnalCode));  { Line Job Analysis Code }

    If (Syss.AutoClearPay) then         { Auto Clear Payment }
      Reconcile:=ReconC
    else
      Reconcile:=ExIdRec.Reconcile;

    {$IFDEF COMTK}
     if (IDDocHed in JAPSplit) and (LineNo < 0) then
       Reconcile := Abs(LineNo) - 1;
    {$ENDIF}

    If (IdDocHed In TSTSplit) then      { If Tran= TSH (Time Sheet)}
    begin
      NomMode := TSTNomMode;            { TSTNomMode = 3 }
      Reconcile:=ExIdRec.TSHCCurr;      { Time Sheet Currency }

      JobCode:=FullJobCode(UpperCase(ExIdRec.JobCode));    { Line Job Code - importtant to use FullJobCode }
      AnalCode:=FullJobCode(UpperCase(ExIdRec.AnalCode));  { Line Job Analysis Code }
    end; {if..}

    If (IdDocHed In StkAdjSplit) then   { If Tran=ADJ (Stock Adjustment)}
    Begin
      PostedRun:=StkAdjRunNo;           { ADJ Run No }
      NomMode:=StkAdjNomMode;           { Nominal Mode }
    end;

    if IdDocHed in JapSplit then
      NomMode := TSTNomMode;

    If (ExIdRec.DocLTLink In [1..4]) or
       ((IDDocHed in JAPSplit) and (ExIdRec.DocLTLink In [1..18])) or
       (IDDocHed in StkRetSplit) then       { Document Link }
      DocLTLink:=ExIdRec.DocLTLink;

    if not (IDDocHed in JAPSplit) then
    begin
      LineType:=StkLinetype[IdDocHed];             { Line Type }
      SOPLink := ExIDRec.SOPLink;
    end
    else
    begin
      LineType := ' ';
      if Inv.TransMode > 0 then
        SOPLink := JAPParentFolio;  //to link jap transactions to parent terms
    end;

    KitLink:=ExIdRec.KitLink;                   { Kit Link if Stock is BOM }

    SOPLineNo:=ExIdRec.SOPLineNo;               { SOP Line No }

    { HM 22/12/98: This is needed otherwise the ADJ has no effect on stock levels }
    { will need to be intelligently set as in adjlineu based on the stock item    }
    {QtyPack := 1;} { Temporarily commented out }

    {*** Ver 4.31 ***}
    LineUser1:=ExIdRec.LineUser1;       { Line User 1 to 4}
    LineUser2:=ExIdRec.LineUser2;
    LineUser3:=ExIdRec.LineUser3;
    LineUser4:=ExIdRec.LineUser4;

    SSDUplift:=ExIdRec.SSDUplift;       { SSD Information }
    SSDCommod:=ExIdRec.SSDCommod;
    SSDSPUnit:=ExIdRec.SSDSPUnit;
    SSDCountry:=ExIdRec.SSDCountry;
    SSDUseLine:=WordBoolToBool(ExIdRec.SSDUseLine);
    If (PriceMulx=0) then
      PriceMulx:=1;                     { according to spec. }

    if IDDocHed in JAPSplit then
      PriceMulx := 0;

    VATIncFlg:=ExIdRec.VATIncFlg;       { VAT Include Flag }
    //5.52 27/08/03
    {$IFDEF EN552}
    BinQty := ExIdRec.BinQty;
    {$ENDIF}

    If (SMode=B_Update) then            { If UPDATE }
    begin
      ABSLineNo:=ExIdRec.ABSLineNo;     { Use Old ABS Line No }
      QtyMul := ExIdRec.QtyMul;
      AutoLineType := ExIdRec.AutoLineType;
      {FolioRef:=ExIdRec.FolioNum;}
(*      If (Inv.InvDocHed In [SOR,POR]) then      { If SOR or POR }
      begin
        QtyPick:=ExIdRec.QtyPick;               { Pick Qty }
        QtyPWOff:=ExIdRec.QtyPWOff;             { WriteOff Qty }
      end; {If SOR,POR...} *)

    end; {If SMode=B_Update ..}
    {*** -------------- ***}


    {$IFDEF COMTK}
    //PR: 08/05/2014 ABSEXCH-14447 Only copy line period & year if we're updating or
    //                             user is setting period/year themselves
    if Not ExSyss.AutoSetPr or (SMode = B_Update) then
    begin
      if ExIDRec.Year <> 0 then
        PYr := ExIDRec.Year;
      if ExIDRec.Period <> 0 then
        PPr := ExIDRec.Period;
    end;

    JAPDedType := ExIDRec.tlDeductType;
    OldSerQty := ExIDRec.tlOldSerialQty;
    LiveUplift := ExIDRec.tlLiveUplift;
    COSNomCode := ExIdRec.tlCOSNomCode;
    if IdDocHed in JAPSplit then
      ShowCase  := ExIdRec.tlUseCase;

    SerialRetQty := ExIdRec.SerialRetQty;
    BinRetQty := ExIdRec.BinRetQty;
    {$ENDIF}

    {$IFDEF EN550CIS}
    CostApport   := ExIdRec.CostApport;
    {$ENDIF}

    {$IFDEF COMTK}
    if ExIdRec.BDMode = 1 then
    begin
     DeductQty := ExIdRec.tlStockDeductQty;
     UsePack := ExIdRec.tlUseQtyMul;
     SerialQty := ExIdRec.tlSerialQty;
     PrxPack := ExIdRec.tlPriceByPack;
     B2BLink := ExIdRec.tlB2BLinkFolio;
     B2BLineNo := ExIdRec.tlB2BLineNo;
     COSConvRate := ExIdRec.tlCOSDailyRate;
     sdbFolio := ExIdRec.tlAltStockFolio;
    end;
    {$ENDIF}

    //PR: 25/03/2009 Advanced Discount fields
    Discount2     := ExIdRec.tlMultiBuyDiscount;
    Discount2Chr  := ExIdRec.tlMultiBuyDiscountChr;
    Discount3     := ExIdRec.tlTransValueDiscount;
    Discount3Chr  := ExIdRec.tlTransValueDiscountChr;
    Discount3Type := ExIdRec.tlTransValueDiscountType;

    {$IFDEF COMTK}
    LineMultiBuyDiscountsList := ExIdRec.tlMBDList;
    {$ENDIF}

    //PR: 09/09/2009 EC Service fields
    if SyssVAT^.VATRates.EnableECServices then
    begin
      //Pass service flag through - if True then allow Start/End dates, otherwise blank them
      ECService := WordBoolToBool(ExIdRec.tlECService);
      if ECService then
      begin
        ServiceStartDate   := ExIdRec.tlECServiceStartDate;
        ServiceEndDate   := ExIdRec.tlECServiceEndDate;

        //If we're in a Purchase Transaction then we need to process the VAT
        if (Result = 0) and (Inv.InvDocHed in PurchSplit - [PPY, PBT]) then
        begin
          CalcVAT(Id, Inv.DiscSetl);
          PurchaseServiceTax := VAT;
          VAT := 0;
          Inv.ManVAT := True;
        end;
      end //If service line
      else
      begin
        FillChar(ServiceStartDate, SizeOf(ServiceStartDate), 0);
        FillChar(ServiceEndDate, SizeOf(ServiceEndDate), 0);
      end;

      //PR: 09/09/2009 If we have any purchase service lines then we've zeroed header vat and
      //need to re-add VAT for all lines
      if bHasPurchaseServiceLine then
      begin
        VATIdx := GetVATNo(VATCode, #0);
        Inv.InvVAT := Inv.InvVAT + VAT;
        Inv.InvVATAnal[VATIdx] := Inv.InvVATAnal[VATIdx] + VAT;
      end;
    end;

    //PR: 04/02/2010 New fields for web extensions (6.3)
    tlReference    :=  ExIdRec.tlReference;
    tlReceiptNo    :=  ExIdRec.tlReceiptNo;
    tlFromPostCode :=  ExIdRec.tlFromPostCode;
    tlToPostCode   :=  ExIdRec.tlToPostCode;

    //PR: 27/10/2011 v6.9 User Fields 5-10
    {$IFDEF COMTK}
    LineUser5:=ExIdRec.LineUser5;
    LineUser6:=ExIdRec.LineUser6;
    LineUser7:=ExIdRec.LineUser7;
    LineUser8:=ExIdRec.LineUser8;
    LineUser9:=ExIdRec.LineUser9;
    LineUser10:=ExIdRec.LineUser10;

    // MH 01/03/2012 v6.10 ABSEXCH-12596: Added Threshold Code for LIVE
    tlThresholdCode := ExIdRec.tlThresholdCode;
    {$ENDIF}

    //PR: 20/01/2016 ABSEXCH-17112 v2016 R1 Added Nature of Transaction Code
    tlIntrastatNoTC := ExIdRec.tlIntrastatNoTC;



  end; {With..}
end;

{ ================= Procedure to Set Reciept Payment Types ================ }

Function SetRPayment(DocHed  :  DocTypes)  :  Char;

Var
  TCh  :  Char;

Begin
  TCh:=DocPayType[DocHed];

  If (DocHed In DirectSet) then
    If (TCh=DocPayType[SIN]) then
      TCh:=DocPayType[SRC]
    else
      TCh:=DocPayType[SIN];

  SetRPayment:=TCh;
end; {func..}

(*
{ ==== Procedure to deduct stock and generate any hidden batch lines invoice ==== }

{ == Any changes here must be reflected in the main module == }

Procedure Gen_StockDeduct(Var Idr     :  IDetail;
                              Level   :  LongInt;
                              Mode    :  Byte);
Const
  Fnum     =  PWrdF;
  Keypath  =  PwK;

  Fnum2    =  StockF;
  Keypath2 =  StkFolioK;

  Fnum3    =  IDetailF;
  Keypath3 =  IdFolioK;

  StkAdjCnst : Array[BOff..BOn] of Integer    = (-1, 1);

  BillMatTCode     =  'B';
  BillMatSCode     =  'M';

Var
  KeyS,
  KeyChk,
  KeyStk   :  Str255;

  RecAddr  :  LongInt;

  QtyShort,
  QtyGCost :  Real;

  TmpStock :  ^StockRec;
  TmpId    :  ^Idetail;

  Function FullMatchKey (RC,ST        :  Char;
                         Login        :  Str20)  :  Str20;
  Begin
    FullMatchKey:=Rc+St+LJVar(Login,9);
  end;

Begin

  KeyS:='';
  KeyChk:='';
  KeyStk:='';
  RecAddr:=0;
  QtyShort:=0;
  QtyGCost:=0;

  New(TmpStock);
  New(TmpId);

  If (Idr.IdDocHed In StkAdjSplit) and (Idr.KitLink=1) and (Level=0) then
  Begin

    QtyShort:=((Idr.Qty*Idr.QtyMul*StkAdjCnst[(Idr.IdDocHed In StkOpoSet+StkAdjSplit)]*DocNotCnst));

    Ok:=CheckRecExsists(Idr.StockCode,Fnum2,StkCodeK);

  end
  else
  Begin

    If (Level=0) then {* Assume stock already deducted from line entry *}
      Ok:=CheckRecExsists(Idr.StockCode,Fnum2,StkCodeK)
    else
      Stock_Deduct(Idr,BOn,BOn,0);

    With IdR do
      QtyShort:=(((Qty-(QtyWOff+QtyDel))*QtyMul)-DeductQty);
  end;

  TmpStock^:=Stock;
  TmpId^:=Idr;

  If (Stock.StockType=StkBillCode) and ((Not Stock.ShowasKit) or (Level>0))
    and (Inv.InvDocHed In SalesSplit+StkAdjSplit-StkExcSet) and (QtyShort<>0)
    and (Ok) then
  With TmpStock^ do
  Begin

    If ((Inv.InvDocHed In StkAdjSplit) and (Syss.AutoValStk)) then
      TmpId^.CostPrice:=0;

    KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Password.BillMatRec do
    Begin
      Status:=GetPos(F[Fnum],Fnum,RecAddr);
      KeySTk:=BillLink;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

      If (StatusOk) then
      Begin
        With Idr do
        Begin
          StockCode:=LJVar(Stock.StockCode,StkLen);
          LineNo:=StkLineNo;
          Desc:=Stock.Desc[1];
          NetValue:=0;
          CostPrice:=0;
          VAT:=0;
          Discount:=0;
          DiscountChr:=C0;
          NomCode:=0;
          Blank(CCDep,Sizeof(CCDep));
          Qty:=(QtyShort*QtyUsed);
          QtyMul:=1;
          QtyDel:=0;
          QtyWOff:=0;
          QtyPick:=0;
          QtyPWOff:=0;

          If (Mode=0) then  {* Switch off ABS LineNo Control *}
          Begin
            ABSLineNo:=0;
            KitLink:=0;
            SOPLink:=0;   {* Reset any link *}
            SOPLineNo:=0;
          end
          else
            If (Level=0) then  {* Set Kit folio so it is treated as part of a batch *}
              KitLink:=TmpStock^.StockFolio;
        end;

        If (Stock.StockType=StkBillCode) then
        Begin
          Gen_StockDeduct(Idr,Succ(Level),Mode);
          SetDataRecOfs(Fnum,RecAddr);
          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);
          QtyGCost:=1;  {* Set Cost to 1 here, as BOM will return total cost for Qty *}
        end
        else
        Begin
          Stock_Deduct(Idr,BOn,BOn,0);
          QtyGCost:=ABS(Idr.Qty);
        end;

        {* Calculate and adjustment BOM cost price by recalculating the BOM
           contents *}

        If ((Inv.InvDocHed In StkAdjSplit) and (Syss.AutoValStk)) then
          TmpId^.CostPrice:=TmpId^.CostPrice+(Idr.CostPrice*QtyGCost)
        else
          CostPrice:=0;  {* Reset Cost price again, incase it has been set by
                          an adjustment valuation *}

        Status:=Add_Rec(F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3);

      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    Stock:=TmpStock^;
    Idr:=TmpId^;

  end; {If Kit or Normal Product ..}

  Dispose(TmpStock);
  Dispose(TmpId);
end; {Proc..}

*)


{* For Ex_StoreTran New record BOM update *}

Procedure Gen_StockDeduct(Var Idr     :  IDetail;
                              LInv    :  InvRec;
                              Level   :  LongInt;
                              Mode    :  Byte;
                          Var BOMOCost:  Double;
                              StkFolio:  LongInt;
                              ABLineNo : longint);

Const

  Fnum     =  PWrdF;

  Keypath  =  PwK;


  Fnum2    =  StockF;
  Keypath2 =  StkFolioK;

  Fnum3    =  IDetailF;
  Keypath3 =  IdFolioK;

Var

  KeyS,
  KeyChk,
  KeyStk   :  Str255;

  RecAddr  :  LongInt;

  QtyShort,
  QtyGCost :  Real;

  OwnCost,
  KitOCost :  Double;

  TmpStock :  ^StockRec;
  TmpId    :  ^Idetail;

  Locked   :  Boolean;

  TmpIdCost : Double;
  AveIdCost : Double;

Begin

  KeyS:='';

  KeyChk:='';

  KeyStk:='';

  RecAddr:=0;

  New(TmpStock);
  New(TmpId);

  QtyShort:=0;

  QtyGCost:=0;

  If (Level=0) then
    BOMOCost:=0;

  KitOCost:=0;
  OwnCost:=0;

  //PR: 29/04/2009
  TmpIdCost := 0.0;

  //PR: 29/06/2010 For Average valuation we need to preserve the current line cost price
  AveIdCost := Idr.CostPrice;

  //PR: 29/04/2009 Removed SalesSplit to accord with procedure in InvCtSuu.pas
  If (Idr.IdDocHed In StkAdjSplit{+SalesSplit}) and (Idr.KitLink=1) and (Level=0) then
  Begin

    QtyShort:=((Idr.Qty*Idr.QtyMul*StkAdjCnst[Idr.IdDocHed]*DocNotCnst));
{ Old .. QtyShort:=((Idr.Qty*Idr.QtyMul*StkAdjCnst[(Idr.IdDocHed In StkOpoSet+StkAdjSplit)]*DocNotCnst));}
    {GetStock(Application.MainForm,Idr.StockCode,Idr.StockCode,-1);}

    Locked:=BOff;
    KeyS:=Idr.StockCode;

    {$IFDEF WIN32}
    If (GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked)) then
    begin
      Status := 0;
      if not Locked then
        Status := 84;
    end;
    {$ELSE}
    Status:=(GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked));
    {$ENDIF}

  end
  else
  Begin
    {* This will be different from Ex, as Ex non SPOP deletes the lines first hence why
       a deduct needs to take place here as well *}

    If (Level=0) then {* Assume stock already deducted from line entry *}
    begin
      {GetStock(Application.MainForm,Idr.StockCode,Idr.StockCode,-1)}
      Locked:=BOff;
      KeyS:=Idr.StockCode;

      {$IFDEF WIN32}
      If (GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked)) then
      begin
        Status:=0;
        if not Locked then
          Status := 84;
      end;
      {$ELSE}
      Status:=(GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked));
      {$ENDIF}

      //PR: 29/04/2009 We need to store the original cost price for the line
      if (Stock.StockType=StkBillCode) and (Idr.IdDocHed In SalesSplit) then
        TmpIdCost := Idr.CostPrice;

    end
    else
      Stock_Deduct(Idr,LInv,BOn,BOn,0);


    QtyShort:=((Qty_OS(Idr)*Idr.QtyMul)-Idr.DeductQty);

    {* If own stock exsits, the record cost contribution of that *}
    //PR: 29/04/2009 Removed SalesSplit to accord with procedure in InvCtSuu.pas
    If (Idr.IdDocHed In StkAdjSplit{+SalesSplit}) and (Stock.StockType=StkBillCode) and (Round_Up(Idr.DeductQty,Syss.NoQtyDec)<>0.0) then
    Begin
      //PR 30/01/03 child BOMs were multiply cost by qty rather than qty used in build
      //PR: 29/06/2010 Removed this as it wasn't working correctly.
{      if Level > 0 then
        OwnCost := 0
      else}
        OwnCost:=(Idr.CostPrice*(ABS(Idr.DeductQty)-1)); {* One less as idr.costprice will account for one of them *}
    end;

    {* EN422. At this point if none are from stock we need to zero the cost of this line,
       as it is already being taken into account by
       Own cost, and hence will be taken in to account twice? *}

    {* EX423. An additional check made so that description only items do not have cost reset at this point. *}
    //PR 18/01/07 - Added StkBillCode to exclusion
    //PR 27/03/08 - Removed as it was causing a problem with subboms when deducting bom stock.
    If (IdR.DeductQty=0) and (Stock.StockType<>StkDescCode)  then
      IdR.CostPrice:=0.0;


  end;

  TmpStock^:=Stock;

  TmpId^:=Idr;

  {Need to confirm 13.07.99.......}

  { This is o.k for Kit Disabled -  No BOM stock, and deduct from Components ...}
  If (Stock.StockType=StkBillCode) and ((Not Stock.ShowasKit) or (Level>0))
    and (LInv.InvDocHed In SalesSplit+StkAdjSplit-StkExcSet) and (QtyShort<>0) then
  With TmpStock^ do
  Begin

    //PR: 29/04/2009 Removed SalesSplit to accord with procedure in InvCtSuu.pas
    If ((LInv.InvDocHed In StkAdjSplit{+SalesSplit) and (Syss.AutoValStk})) and (Level=0) then
      TmpId^.CostPrice:=0;                                              

    KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Password.BillMatRec do
    Begin

      {Application.ProcessMessages;}

      Status:=GetPos(F[Fnum],Fnum,RecAddr);

      KeySTk:=BillLink;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

      If (StatusOk) then
      Begin
        With Idr do
        Begin

          StockCode:=Stock.StockCode;

          LineNo:=StkLineNo;

//PR: 16/7/2002: Took out check for empty description as at this point description is of 1st line +
// added copy glcode from stock to line
//          If (EmptyKey(Desc,SizeOf(Desc))) then
            Desc:=Stock.Desc[1];

//PR: 23/02/2005 - if Component is a Bom then needs to use BOM/Finished Goods GL code

            if Stock.StockType = 'M' then
              NomCode := Stock.nomCodes[5]
            else
              NomCode := Stock.nomCodes[4];

          NetValue:=0;

          CostPrice:=0;

          VAT:=0;

          Discount:=0;

          DiscountChr:=C0;

          //PR: 16/07/2010 Copied in from InvCtsuU.pas
            // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
            Discount2:=0;
            Discount2Chr:=C0;
            Discount3:=0;
            Discount3Chr:=C0;

            NomMode:=StkAdjNomMode;

         // NomCode:=0;

          Blank(CCDep,Sizeof(CCDep));

          Qty:=(QtyShort*QtyUsed);

          QtyMul:=1;
          QtyPack:=QtyMul;

          QtyDel:=0;
          QtyWOff:=0;
          QtyPick:=0;
          QtyPWOff:=0;
          SerialQty:=0;

          If (Mode=0) then  {* Switch off ABS LineNo Control *}
          Begin

            ABSLineNo:=0;

 //PR 23/02/05 - Changed so that Kitlink is set to StkFolio
(*            {$IFDEF SOP}
              KitLink:=StkFolio;
            {$ELSE}
              KitLink:=0;
            {$ENDIF} *)

            KitLink:=StkFolio;

            SOPLink:=0;   {* Reset any link *}
            //For adjs we need to set soplineno so that nom lines are created when
            //the adj is posted
//            if Inv.InvDocHed = ADJ then
//              SOPLineNo := TmpID^.ABSLineNo
              SOPLineNo := ABLineNo
{            else
              SOPLineNo:=0;}
          end
          else
            If (Level=0) then  {* Set Kit folio so it is treated as part of a batch *}
              KitLink:=TmpStock^.StockFolio;


        end;


        If (Stock.StockType=StkBillCode) then
        Begin
          //PR 8/04/2008 SubBom will have an abslineno of 0, so need to pass parent abslineno through in soplineno
(*          If ((LInv.InvDocHed In StkAdjSplit{+SalesSplit) and (Syss.AutoValStk})) then
            Idr.SOPLineNo := TmpId.ABSLineNo; *)
         //PR: 4/08/2010 Changed to pass AbsLineNo through as new parameter to accord with InvCtSuu.pas

          Gen_StockDeduct(Idr,LInv,Succ(Level),Mode,KitOCost,StkFolio, {TmpId.AbsLineNo} ABLineNo);

          SetDataRecOfs(Fnum,RecAddr);

          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

          QtyGCost:=1;  {* Set Cost to 1 here, as BOM will return total cost for Qty *}

        end
        else
        Begin
          Stock_Deduct(Idr,LInv,BOn,BOn,0);

//          QtyGCost:=ABS(Idr.Qty);

            If ((LInv.InvDocHed In StkAdjSplit) {and (Syss.AutoValStk) EN552}) then
            Begin
              QtyGCost:=Idr.Qty*DocNotCnst; {v5.50.001. Negatte stock effect sign to take into account any negative lines}

            end
            else
              QtyGCost:=ABS(Idr.Qty);
        end;

        {* Calculate and adjustment BOM cost price by recalculating the BOM
           contents *}
        //PR: 29/04/2009 Removed SalesSplit to accord with procedure in InvCtSuu.pas
        If ((LInv.InvDocHed In StkAdjSplit{+SalesSplit}) and (Syss.AutoValStk)) then
        Begin
          If (Level=0) then
            TmpId^.CostPrice:=TmpId^.CostPrice+(Idr.CostPrice*QtyGCost)+KitOCost+OwnCost
          else
            OwnCost:=OwnCost+(Idr.CostPrice*QtyGCost)+KitOCost;
         //PR: 29/04/2009 This caused other problems - revert to original
         //PR: Try to fix problem with cost on BOMs by replacing QtyGCost which is
         //the line qty, by qtyused which is the qty used in the BOM
{          If (Level=0) then
            TmpId^.CostPrice:=TmpId^.CostPrice+(Idr.CostPrice*QtyUsed)+KitOCost+OwnCost
          else
            OwnCost:=OwnCost+(Idr.CostPrice*QtyUsed)+KitOCost;}

          //PR 13/03/2008 Without these, cost for bom lines wasn't being posted correctly
//          Idr.NomMode := StkAdjNomMode;
          //PR 8/04/2008 If we've come in here as a subbom then abslineno will be 0, but we'll have stored parent abslineno in soplineno before call.
          //PR: 04/08/2010 Removed to accord with InvCtSuu.pas
{          if TmpId.ABSLineNo <> 0 then
            Idr.SOPLineNo := TmpId.ABSLineNo
          else
            Idr.SOPLineNo := TmpId.SOPLineNo;}

        end
        else
        begin
//          Idr.CostPrice:=0;  {* Reset Cost price again, incase it has been set by
//                          an adjustment valuation *}
         //PR: 16/7/2002 Addec calculation of cost for BOM components
{          CostPrice:=Currency_ConvFT(DivWChk(Stock.CostPrice,Stock.BuyUnit)*Idr.QtyMul,Stock.PCurrency,
                                     LInv.Currency,UseCoDayRate);
          TmpId^.CostPrice := TmpId^.CostPrice + (Idr.CostPrice*QtyGCost)+KitOCost+OwnCost;}

          //PR: 04/08/2010 Changed to accord with InvCtSuu.pas
            If (Not (LInv.InvDocHed In SalesSplit)) or (Not Syss.autoValStk) then
              Idr.CostPrice:=0;  {* Reset Cost price again, incase it has been set by
                            an adjustment valuation *}
        end;


        KitOCost:=0;

        Status:=Add_Rec(F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3);


      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    Stock:=TmpStock^;

    Idr:=TmpId^;

  end; {If Kit or Normal Product ..}


  //PR: 03/06/2009 If we're building then we need to recalculate the cost price at this point, otherwise it ends up as CostPrice * Qty
   if Idr.KitLink = 1 then
   begin
     {If (Syss.AutoValStk) then {* Cost is worked out at the time of generating BOM lines *}
     {EN552. We still need this calculation so BOM serial numbers continue to be updated}
     Begin
       //PR: 17/05/2010 This line divides the CostPrice by the Qty to make it the unit cost price - previously this
       //wasn't being called until after the reversing call to Stock_Deduct below, causing the costs to be wrong.
       Idr.CostPrice:=ABS(Round_up(DivWChk(Idr.CostPrice,(Idr.Qty*Idr.QtyMul)),Syss.NoCosDec));
       Idr.B2BLineNo:=0;
     end;

     TmpId^:=Idr;  {* Collect total cost *}

     //PR: 29/06/2010 Restore old line cost for deducting from stock
     Idr.CostPrice := AveIdCost;

     Stock_Deduct(Idr,Inv,BOff,BOn,99); {Reverse Stock Temporarily}

     Idr:=TmpId^;


     Stock_Deduct(Idr,Inv,BOn,BOn,99); {Credit Stock }
   end;

  BOMOCost:=BOMOCost+OwnCost;

  //PR: 29/04/2009 Restore CostPrice if necessary
  if TmpIdCost <> 0.00 then
    Idr.CostPrice :=  TmpIdCost;

  Dispose(TmpStock);

  Dispose(TmpId);


end; {Proc..}

Procedure ReverseStockBalance(Var TId  :  IDetail;
                              Var TInv :  InvRec);
Var
  BOMKey  :  Str255;
  KeyNum : Integer;
  SavedPosOK : Boolean;
  RecPos : longint;
begin

  With TId do
  begin

   Stock_Deduct(TId,TInv,BOff,BOn,0);  { Id,Inv,BOff=Reverse,BOn=GetStockRec,0 }

    If (Stock.StockType=StkBillCode) and (ExSyss.DeductBOM) and (IdDocHed In SalesSplit+StkadjSplit) and
        not HiddenLinesDeleted Then //PR 10/03/06 Stop hidden lines being deleted more than once
    begin
      HiddenLinesDeleted := True;
      //BUGFIX PR 08/07/03. Delete_StockLinks changes position in the detail file. Add code to save & restore position.
      KeyNum := GetPosKey;
      SavedPosOK := Presrv_BTPos(IDetailF, KeyNum, F[IDetailF], RecPos, false, false) = 0;

      BOMKey:=FullIdKey(TInv.FolioNum,StkLineNo);
      {* Do reverse-stock-update and delete hidden TLs *}
      If (IdDocHed In StkAdjSplit) then
        {* Need to confirm for parameter 1 or 0 ? *}
        Delete_StockLinks(BOMKey,IDetailF,Length(BOMKey),IdFolioK,BOff,TInv,1)
      else ;
        Delete_StockLinks(BOMKey,IDetailF,Length(BOMKey),IdFolioK,BOn,TInv,1);

      if SavedPosOK then //PR: 10/02/2011 Was restoring position in detail file but not reloading record. (ABSEXCH-9838)
        Presrv_BTPos(IDetailF, KeyNum, F[IDetailF], RecPos, true, {false}true);
    end; {if BOM ..}

    If (Not EmptyKey(JobCode,JobKeyLen)) then
        Delete_JobAct(TId);

  end; {with..}

end; {ReverseStockBalance...}



{* ---------------------------------------------------------------------------
   To Update the ID Record *}

Function Update_EId  :  Integer;

Var
  TestVal,
  Rnum      :  Double;
  LAddr,
  StkFolio  :  LongInt;
  UpdatedId :  IDetail;

  VarianceRec,
  Locked,
  ValidCheck,
  ValidHed  :  Boolean;

  BOMKey,
  KeyChk,
  KeyF      :  Str255;

  RecAddr   :  longint;

  TempID    :  IDetail;

  function AdjLineMatched : Boolean;
  {PR 29/06/07 Used if we have auto generated Adj lines. Returns True if the Updated line is the auto line and
   the record found is the auto line, or if neither is the auto line. (ie if the Updated line matches the Record.}
  begin
    Result := ( //Auto line
               (Trim(UpdatedId.MLocStk) = Trim(Inv.DelTerms)) and
               (Trim(UpdatedId.MLocStk) = Trim(Id.MLocStk))
               )
              or
              (//Manual line
               (Trim(UpdatedId.MLocStk) <> Trim(Inv.DelTerms)) and
               (Trim(Id.MLocStk) <> Trim(Inv.DelTerms))
              );
  end;

  function SameLineNo : Boolean;
  //Checks if the updated line belongs to the same transaction and has the same AbsLineNo as the record in the file
  begin
    Result := (UpdatedId.FolioRef=Id.FolioRef) and (UpdatedId.ABSLineNo=Id.ABSLineNo);
  end;

Begin
  With Id do
  Begin

{    If (Payment=DocPayType[SRC]) then
      Payment:=SetRPayment(IDDocHed)
    else
      Payment:=DocPayType[IDDocHed];}

    Result:=0;
    ValidHed:=BOff;

    UpdatedId:=Id; {* Current Id info. into Temp. Id *}

    KeyF:=FullIdKey(UpdatedId.FolioRef,UpdatedId.ABSLineNo);
    KeyChk:=KeyF;

    { Get Id record by Folio No. + ABS Line No }
    Status:=Find_Rec(B_GetEq,F[IdetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,KeyF);
    ValidCheck:=(StatusOk) and (UpdatedId.FolioRef=Id.FolioRef) and (UpdatedId.ABSLineNo=Id.ABSLineNo);

    {PR 29/06/2007: If there is a header In Location then we will have an auto generated line for each
     manually entered line with the same AbsLineNo, so we'll need to check and find the correct line
     if necessary}
    if ValidCheck and Syss.UseMLoc
                  and (Inv.InvDocHed = ADJ) and (Trim(Inv.DelTerms) <> '') then
    begin
      ValidCheck := AdjLineMatched;
      if not ValidCheck then
      begin
        Status:=Find_Rec(B_GetGEq,F[IdetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,KeyF);
        ValidCheck:=(StatusOk) and SameLineNo and  AdjLineMatched;

        while not ValidCheck and SameLineNo do
        begin
          Status:=Find_Rec(B_GetNext,F[IdetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,KeyF);
          ValidCheck:=(StatusOk) and SameLineNo and AdjLineMatched;
        end;
      end; //not valid check
    end;

    GenSetError(ValidCheck,30500,Result,ValidHed); {30500 will have 2 places }

    If (Result=0) then  { If Id record found }
    begin

      //PR: 16/09/2014  v7.x Order Payments - T102 Can't change the following fields
      //PR: 29/01/2014 ABSEXCH-16087 Add check for payments made 
      if (IdDocHed = SOR) and Syss.ssEnableOrderPayments and Cust.acAllowOrderPayments and
         (PaymentsMade > 0) then
      begin
        ValidCheck := (UpdatedId.StockCode = StockCode) and
                      (UpdatedId.Qty = Qty) and
                      (UpdatedId.QtyMul = QtyMul) and
                      (UpdatedId.NetValue = NetValue) and
                      (UpdatedId.Discount = Discount) and
                      (UpdatedId.DiscountChr = DiscountChr) and
                      (UpdatedId.Discount2 = Discount2) and
                      (UpdatedId.Discount2Chr = Discount2Chr) and
                      (UpdatedId.Discount3 = Discount3) and
                      (UpdatedId.Discount3Chr = Discount3Chr) and
                      (UpdatedId.Discount3Type = Discount3Type) and
                      (UpdatedId.VATCode = VATCode);


        GenSetError(ValidCheck,30145,Result,ValidHed);
      end; // if (InvDocHed = SOR) and Syss.ssEnableOrderPayments and Cust.acAllowOrderPayments
    end;


    If (Result=0) then
    begin
      { Get record address and lock it }
      Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,IdFolioK,IDetailF,BOn,Locked,LAddr);

      If (Ok) and (Locked) then
      Begin
         //Preserve fields from original line
         UpdatedId.Payment := Payment;
         UpdatedId.IdDocHed := IdDocHed;
         UpdatedId.sdbFolio := sdbFolio;

         //PR: 24/03/2011 ABSEXCH-11133 Need to reset Qty Pick for delivery notes.
         if Id.IdDocHed in [SDN, PDN] then
            UpdatedId.QtyPick := Id.QtyPick;

        { If Id line has Stock Code }
        If (Not EmptyKey(StockCode,StkLen)) and (StockCode[1]<>PayInCode) then
        begin
          { If Customer Stock Analysis is used in the Enterprise }
          If (AnalCuStk) and (UpdatedID.StockCode<>Id.StockCode) then
          begin
            Stock_AddCustAnal(Id,BOn,1);        { Update for Old Record }
            Stock_AddCustAnal(UpdatedId,BOn,0); { Update for New Record }
          end;

          {* Have it as Reverse Stock Balance function for it has to be used twice..*}
          ReverseStockBalance(Id, Inv);

          {* If Id has SOP Link... *}
          If (UpdatedId.Qty<>Id.Qty) then
          begin

            {* Reverse Update Stock Balance for Original Id *}
            Update_SOPLink(Id,BON,BOff,BOff,IDetailF,IdLinkK,IdFolioK);

            {* Update Stock Balance for Updated Id *}
            Update_SOPLink(UpdatedId,BOFF,BOff,BOff,IDetailF,IdLinkK,IdFolioK);

            {* This is to update RunNo if SOR/POR has been posted and
               Qty of Delivery/Invoice has been over-delivered
               3rd para = BOn  *}

            Update_SOPLink(Id,BOff,BON,BOn,IDetailF,IdLinkK,IdFolioK);

          end; {if..}

        end {if Not Empty StockCode..}
        else
          //If description only then we still need to update the qtys and RunNo if necessary
          {* If Id has SOP Link... *}
          If (StockCode[1]<>PayInCode) and (UpdatedId.Qty<>Id.Qty) then
          begin

            {* Reverse Update Stock Balance for Original Id *}
            Update_SOPLink(Id,BON,BOff,BOff,IDetailF,IdLinkK,IdFolioK);

            {* Update Stock Balance for Updated Id *}
            Update_SOPLink(UpdatedId,BOFF,BOff,BOff,IDetailF,IdLinkK,IdFolioK);

            {* This is to update RunNo if SOR/POR has been posted and
               Qty of Delivery/Invoice has been over-delivered
               3rd para = BOn  *}

            Update_SOPLink(Id,BOff,BON,BOn,IDetailF,IdLinkK,IdFolioK);

          end; {if..}

        {* To Deduct Stock for New Updated Stock Qty *}

        Id:=UpdatedId;

        { Line stock code is not blank, not a Payment line and
          Update Stock Switch in .INI file is ON }
        If (Not EmptyKey(StockCode,StkLen)) and (StockCode[1]<>PayInCode)
           and (ExSyss.UpStkBal) then
        begin

          Stock_Deduct(Id,Inv,BOn,BOn,0);       { Deduct Stock }

          { If Deduct BOM is ON in .INI file and Trans=Sales or ADJ }
          If (ExSyss.DeductBOM) and (IdDocHed In SalesSplit+StkadjSplit) Then
          begin
            Rnum:=0;
            StkFolio:=Stock.StockFolio;
            { Deduct Component Stock }
            {PR 10/2/2006
            Gen_StockDeduct can position idetailf on a hidden line,
            so store position and restore}
            Status:=GetPos(F[IDetailF],IDetailF,RecAddr);
            TempID := ID;
            Gen_StockDeduct(Id, Inv, 0, 0, Rnum, StkFolio, Id.AbsLineNo);

            SetDataRecOfs(IDetailF,RecAddr);
            Status:=GetDirect(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,0);
            ID := TempID;

          end; {if..}

        end
        else
          If (StockCode[1]=PayInCode) then  { If Payment line e.g.. SRC }
            StockCode:=FullPayInKey(StockCode);

        { 25.09.2000 - Added to calculate Header Total Cost }
        { do not need to calculate Total Cost If Variance Record }
        VarianceRec:=((Inv.InvDocHed In RecieptSet) and (NomCode=Syss.NomCtrlCodes[CurrVar]) and (ExSyss.MCMode));

        If (Not VarianceRec) then
        begin
          If ((Payment<>DocPayType[SRC]) or (Not (Inv.InvDocHed In DirectSet))) then
          begin
            //PR 12/12/01 - If WOP then we don't want to add line 1 to HeaderCost
            if (LineNo > 1) or not (Inv.InvDocHed in WOPSplit) then
              HeaderCost := HeaderCost + Round_Up(CalcLineCost(ID),Syss.NoCosDec);
          end; {if..}
        end; {if..}

        { Save Id record with updated information }
        Result:=Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);

        { HM: Record lock left hanging as Update does not release multiple record locks }
        UnLockMultiSing(F[IDetailF],IDetailF,LAddr);
      end; {if OK and Locked ..}

    end; {if Result=0 ..}

  end; {With..}

end; {Update_EId..}

{$IFDEF COMTK}
//Adds the extra description lines if required and returns the number of lines added to allow following line nos to be adjusted
function AddMultiBuyDescriptionLines : Integer;
begin
  Result := 0;
  if Assigned(LineMultiBuyDiscountsList) then
  with TMultiBuyFunctions.Create do
  Try
    Result := AddMultiBuyDescLines(Inv, ID, Stock.StockFolio, LineMultiBuyDiscountsList);
  Finally
    Free;
    {$IFDEF IMPV6}
    FreeAndNil(LineMultiBuyDiscountsList);
    {$ENDIF}
  End;
end;
{$ENDIF}
{* ----------------------------------------------------------------------------
   To store NEW Id Line *}

Function Store_EId  :  Integer;

Var
  Rnum        : Double;
  StkFolio    : LongInt;
  RestCost    : Boolean;
  VarianceRec : Boolean;
  TempCost    : Double;
  TmpId       : IDetail;
Begin
  TempCost := 0;
  Profiler.StartFunc('Store_EId');
  With Id do
  Begin
    { Payment }
    if not (IdDocHed in JAPSplit) then
    begin
      If (Payment=DocPayType[SRC]) then
        Payment:=SetRPayment(IDDocHed)
      else
        Payment:=DocPayType[IDDocHed];
    end;


    {* 23.06.2000 - New field only for the new Id record *}
    COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];
    if (IdDocHed in SalesSplit+PurchSplit-RecieptSet) and (Trim(StockCode) = '') and (KitLink = DESC_LINE_NUMBER) then
      KitLink := Inv.FolioNum;

    {* Stock Deduct Here *}

    { If Not Time Sheet trans. and 18.10.2000 - added Not IsEBusTran }
    If (Not (Inv.InvDocHed In TSTSplit)) and
       (Not IsEBusTran) then
    Begin
      { If Stock code is not blank, not a Payment line and
        Update stock balance switch is ON in .INI file }
      If (Not EmptyKey(StockCode,StkLen)) and (StockCode[1]<>PayInCode)
         and (ExSyss.UpStkBal) then
      begin

        { 06.04.2000 - Added for Customer Stock Analysis updating }
        If (AnalCuStk) then
        begin
          Profiler.StartFunc('Stock_AddCustAnal');
          Stock_AddCustAnal(Id,BOn,0);
          Profiler.EndFunc('Stock_AddCustAnal');
        end;

        { HM 31/07/01: Added code to save/restore the cost when Auto-Set-Stock-Cost is OFF }
        //PR 29/01/03: Cost was being set on Purchase Transactions
        RestCost := False;
        If ((Not ExSyss.AutoSetStkCost) And (IdDocHed In SalesSplit + StkAdjSplit)) or (IdDocHed in PurchSplit) Then
          { Check the Stock Valuation Method - Standard, Last Cost and Serial OK }
          If (Stock.StkValType In ['S', 'C', 'R']) or (IdDocHed in PurchSplit) or
             ((IdDocHed in StkAdjSplit) and (Id.Qty > 0)) Then Begin
            RestCost := True;
            TempCost := Id.CostPrice;
          End; { If (Stock.StkValType In ... }

        { Deduct Stock }
        Profiler.StartFunc('Stock_Deduct');
        Stock_Deduct(Id,Inv,BOn,BOn,0);
        Profiler.EndFunc('Stock_Deduct');

        If RestCost Then Begin
          RestCost := False;
          Id.CostPrice := TempCost;
        End; { If RestCost }


        { If Deduct BOM is ON in .INI and Trans=Sales or ADJ }
        If (ExSyss.DeductBOM) and (IdDocHed In SalesSplit+StkadjSplit) Then
        begin
          Rnum:=0;
          StkFolio:=Stock.StockFolio;
          { Deduct Component Stock }
        Profiler.StartFunc('Gen_StockDeduct');
          Gen_StockDeduct(Id, Inv, 0, 0, Rnum, StkFolio, Id.AbsLineNo);
        Profiler.EndFunc('Gen_StockDeduct');

        end; {if..}

{        if (Stock.StockType = 'M') then
          Id.CostPrice := 0;}

      end
      else
        If (StockCode[1]=PayInCode) then  { If Payment Line }
          StockCode:=FullPayInKey(StockCode);

    end; {If not TSH}

    { 25.09.2000 - Added to calculate Header Total Cost }
    { do not need to calculate Total Cost If Variance Record }
    VarianceRec:=((Inv.InvDocHed In RecieptSet) and (NomCode=Syss.NomCtrlCodes[CurrVar]) and (ExSyss.MCMode));

    If (Not VarianceRec) then
    begin
      If ((Payment<>DocPayType[SRC]) or (Not (Inv.InvDocHed In DirectSet))) then
      begin
            //PR 12/12/01 - If WOP then we don't want to add line 1 to HeaderCost
            //PR: 18/03/2009 Addec check for InLocations
        if ((Inv.InvDocHed <> WOR) or (Stock.StockType <> StkBillCode)) and not AddInLocationAdjLines then
          HeaderCost := HeaderCost + Round_Up(CalcLineCost(ID),Syss.NoCosDec);
      end; {if..}
    end; {if..}

    { Add new Id record }
//    SetSplitPackQty;
    Profiler.StartFunc('Add_Rec');
    Result:=Add_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
    Profiler.EndFunc('Add_Rec');

  end; {With..}

  Profiler.EndFunc('Store_EId');
end; {Store_EId..}

//PR: 18/03/2009 Function to store In Location lines for ADJs. Added for Volac  NB: Will not work for Serial/Batch numbers or Multi-Bins

function AddInLocLine : Integer;
//On entry, ID holds the adj line which needs to be reversed
Const
  Fnum     =  IDetailF;
  Keypath  =  IdFolioK;
var
  TmpId : IDetail;
  Res : Integer;
  SetNom, SetCCDep : Boolean;
  MLOR         :  MLocLocType;
  MSLR         :  MStkLocType;
  n : Integer;
begin
  SetCCDep := False;
  Result := 0;
  TmpId := ID;

  ID.MLocStk:=Full_MLocKey(Inv.DelTerms);

  ID.Qty := ID.Qty * -1;

  If Syss.UseCCDep then
    SetCCDep:=LocOVerride(Id.MLocStk,2);

  SetNom:=LocOVerride(Id.MLocStk,1);
  Stock_LocLinkSubst(Stock,Id.MLocStk);

  If ((SetCCDep) or (SetNOM)) and (Not LinkMLoc_Stock(Id.MLocStk,FullStockcode(Stock.StockCode),MSLR)) then
  Begin
    If (LinkMLoc_Loc(Id.MLocStk,MLOR)) then
    Begin
      If (SetCCDep) then
        Stock.CCDep:=MLOR.LoCCDep;

      If (SetNOM) then
      Begin
        For n:=1 to NofSNoms do
          Stock.NomCodeS[n]:=MLOR.loNominal[n];
      end;
    end;
  end;

  If (Stock.StockType=StkBillCode) then
    Id.NomCode:=Stock.NomCodes[5]  {* Asjust WIP *}
  else
    Id.NomCode:=Stock.NomCodes[3];

  {* Override with WIP Nominal code *}

  Id.NomCode:=Job_WIPNom(Id.NomCode,Id.JobCode,Id.AnalCode,Id.StockCode,Id.MLocStk,Inv.CustCode);

  Deduct_AdjStk(Id,Inv,BOn);

  Id.SerialQty:=Id.SerialQty*DocNotCnst;
  Id.BinQty:=Id.BinQty*DocNotCnst;

  Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

  Report_BError(Fnum,Status);

  If (StatusOk) then
    Update_JobAct(Id,Inv);

  {* We need to alter the In location code for any serial nos *}
//  TxFrSnos(LInv,TmpId,Id);


end;


{ * --------------------------------------------------------------------------
    To store Job Actual Record if the transaction is Time Sheet (TSH) *}

Function Store_JobActual(TJAType,
                         TCurrCharge : Byte;
                         TChargeType : SmallInt) : SMALLINT;

{* Store Job Actual Record if Job Code is not empty. *}

Const
  Fnum     =  JDetlF;
  Keypath  =  JDAnalK;

Var
  TmpQ,
  TmpQM,
  UpLift,
  CostUp         : Double;

  FoundRec,
  FoundOK,
  LOK        : Boolean;

  { Added for Charge Amount calculation - 14.02.2001 }

  TUPrice,
  TDiscR       :  Real;
  TDiscCh      :  Char;
  TLCode       :  Str10;
    ConvChargeCurr
            :  Byte;

Begin

  Uplift := 0.0;
  CostUp := 0.0;

  With JobDetl^.JobActual do
  Begin
    ResetRec(Fnum);

    JobDetl^.RecPFix  := JBRCode;  {J}
    JobDetl^.SubType  := JBECode;  {E}

    JobCode        := Id.JobCode;
    ActCurr        := Id.Currency;
    ActYr          := Id.PYr;
    ActPr          := Id.PPr;
    LineFolio      := Id.FolioRef;
    LineNo         := Id.ABSLineNo;
    LineORef       := Inv.OurRef;
    StockCode      := Id.StockCode;
    JDate          := Inv.TransDate;
    OrigNCode      := Id.NomCode;
    JDDT           := Inv.InvDocHed;
    ActCCode       := Id.CustCode;
    AnalCode       := Id.AnalCode;
    JAType         := TJAType; {assigned in Valid_Lines}

    If (JDDT=TSH) then Begin
      EmplCode     := FullCustCode(Inv.BatchLink);
      EmplKey      := FullJDEmplKey(JobCode,EmplCode,ReconTS);
    end;

    {* --------------- for Qty & Cost ---------------- *}
    //Removed 25/11/04 - PR. Tk now has JC defined so this was calculating cost & qty wrongly.
    {.$IFDEF JC}              {* If Job Costing Module only *}
{      Qty          := Id.Qty;
      Cost         := Id.NetValue;}
    {.$ELSE}
      {$IFDEF SOP}
        Qty:= Qty_OS(Id);
      {$ELSE}
        Qty:= Id.Qty;
      {$ENDIF}

      If (JDDT In StkAdjSplit) then
        Qty:= Qty*DocNotCnst;  {* DocNotCnst = -1 *}

      With Id do
      Begin
        TmpQ:=Qty;
        TmpQM:=QtyMul;
        Qty:=1;
        QtyMul:=1;
        If (IdDocHed<>ADJ) then
        //PR 06/12/04 Change to use correct no of decimal places
//          Cost:=DetLTotal(Id,BOn,BOff)*LineCnst(Payment)
          Cost:=DetLTotalND(Id,BOn,BOff,BOn)*LineCnst(Payment)
        else
          Cost:=CostPrice;
        Qty:=TmpQ;
        QtyMul:=TmpQM;
      End; { with EId do }

    {.$ENDIF}

    {* ------------- For Charge ---------------------------------- *}
    {$B-}

    UpLift:=0;

    If (Not (JDDT In SalesSplit+QuotesSet+PSOPSet) ) and
       (Get_BudgMUp(JobCode,AnalCode,StockCode,ActCurr, UpLift, CostUp, 1)) then {* Recharge set *}
    Begin
    {$B+}
         ConvChargeCurr:=ActCurr;

         Case TChargeType of
           CPChargeType  :  Charge:=Round_Up(Round_Up(Cost+(Cost*Pcnt(UpLift)),2)*Qty,2);
                                                                 {in ETMiscU.Pas}
           TMChargeType  :  Begin
                            If (JDDT=TSH) then
                              Charge:=Id.CostPrice*Qty
                              {...$IFNDEF JC}  { 14.02.2001 - closed }
                            else
                            if JDDT in JAPSplit then
                            begin
                              Cost := Id.CostPrice;
                            end
                            else
                            Begin

                                {$IFDEF STK}
                                   {$IFDEF PF_On}

                                     If (Is_FullStkCode(StockCode)) then
                                     Begin
                                       {* 14.02.2001 - open for NZ, advised by EL *}
                                       If (StockCode<>Stock.StockCode) then
                                         FoundRec:=(CheckRecExsists(StockCode,StockF,StkCodeK));

                                         {GetStock(StockCode,KeyF,-1);}

                                       If (JobRec^.CustCode<>Cust.CustCode) then
                                         FoundRec:=(CheckRecExsists(JobRec^.CustCode,CustF,CustCodeK));
                                         {GetCust(JobRec^.CustCode,Off,Off,'');}


                                       FoundOk:=BOn;

                                       {Calc_StockPrice(Stock,Cust,ActCurr,Qty,QPrice,QDisc,CHDisc,FoundOk);}

                                       TUPrice:=Id.NetValue;
                                       TDiscR:=Id.Discount;
                                       TDiscCh:=Id.DiscountChr;
                                       FoundOk:=True;
                                       TLCode:=Id.MLocStk;

                                       {Calc_StockPrice(Stock,Cust,ActCurr,Qty,TUPrice,TDiscR,TDiscCh,TLCode,FoundOk);}

                                       Calc_StockPrice(Stock,Cust,ActCurr,Qty,JDate,TUPrice,TDiscR,TDiscCh,TLCode,FoundOk, 0);

                                       Charge:=Round_Up((TUPrice-Calc_PAmount(TUPrice,TDiscR,TDiscCh))*Qty,2);

                                       {Charge:=0; closed on 14.02.2001 }

                                     end;

                                   {$ENDIF}
                                {$ENDIF}


                            end;       {* JDDT=TSH *}

                              {..$ELSE}
                                  ;
                              {..$ENDIF}  { 14.02.2001 - Closed }

                            end;       {* TMChargeType *}



         end; {Case.}

         If (JDDT=TSH) then
           CurrCharge:=Id.Reconcile
         else
           CurrCharge:=TCurrCharge; {JobRec^.CurrPrice}

         Charge:=Currency_ConvFT(Charge,ConvChargeCurr,CurrCharge,UseCoDayRate);
    end; {If Not JDDT and Get_BudgMUp ..}

    If (CostUp=0.0) and (Not (JDDT in JAPSplit))  then {* If budget uplift not set, use analysis records *}
    Begin
      If (JobMisc^.JobAnalRec.JAnalCode<>Id.AnalCode) then
        LOk:=CheckRecExsists(FullJAKey(JARCode,JAACode,Id.AnalCode), JMiscF, JMK)
      else
        LOk:=BOn;

      If (LOk) then
        CostUp:=JobMisc^.JobAnalRec.UpliftP;

    end;

    If (CostUp<>0.0) and (Cost<>0.0) then {* Inflate Cost by uplift amount *}
    Begin
      UpliftTotal:=Round_Up(Cost*CostUp,Syss.NoCosDec);

      Cost:=Round_Up(Cost+UpliftTotal,Syss.NoCosDec);

      UpliftGL:=JobMisc^.JobAnalRec.UpliftGL;
    end;



    {* ------ End for Charge & Start for Index Keys ------------- *}

    LedgerCode:=FullJDLedgerKey(JobCode,Posted,Invoiced,ActCurr,JDate);

    RunKey:=FullJDRunKey(JobCode,PostedRun,JDate);

    LookKey:=FullJDLookKey(LineFolio,LineNo);

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

  End; {with EJobDetl.JobActual }

  Store_JobActual:=Status;

End;

{* ----------------------------------------------------------------- *}


//PR 8/04/03 Added LineDisc parameter to pass total line discount back to caller
Function ValidateEachTL(    Mode         :  Byte;
                           SMode         :  Byte;
                        Var ImpVariance  :  Double;
                        Var LineDir      :  Double;
                        Var LineNet      :  Double;
                        Var TmpJAType,
                            TmpCurrCharge:  Byte;
                        Var TmpChargeType:  SmallInt;
                        Var VJActual     :  Boolean;
                        Var LineDisc     :  Double;
                        Var LineVat      :  Double)  :  Integer;

Const
  YN : Array[BOff..BOn] of String[3] = ('No','Yes');

Var

  TBo,
  RepBO,
  ValidCheck,
  ValidHed    :  Boolean;

{  LineCost,
  LineWeight,}
{  LineVAT,}
  LineTot,
  TmpQty,
  TmpNetValue,
  TmpXRate
               :  Double;

  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Changed to Int64 to avoid overflows with 10 digit TARIC codes > MaxLongInt
  TmpSSD        :  Int64;
  ErrSSDCode    :  LongInt;

  TmpBudg       :  String[27]; { to check for Emp.Pay Rate }

  UOR           :  Byte;

  KeyF          :  Str255;

  WopNomCode    :  longint; //for Works Order processing
  WOPTempStock  :  StockRec;
  TmpDisc,
  TotNoDisc     :  Double;
  TmpLineDisc   :  Double;
  TmpLineVat    :  Double;
//  i : integer;
  TmpQtyM : Double;
  HaveMLocRec : Boolean;
  iChargeCurrency : Integer;

  function ValidServiceDate(const sDate : string) : Boolean;
  begin
    if Inv.InvDocHed in SalesSplit + PurchSplit then  //AP 12/09/2016 - R3 ABSEXCH-16514 : Importer issues with EC Services fields
      Result := ValidDate(sDate)
    else
      Result := (Trim(sDate) = '') or ValidDate(sDate);
  end;

//PR: 26/01/2011 Added functions for checking correct time rate (ABSEXCH-9367)
//----------------------------------------------------------------------------------------
    function GetRate(const ACode : string; SubType : Char = JBECode) : Boolean;
    var
      KeyS, KeyChk : Str255;
      Res : Integer;
    begin
      KeyS := PartCCKey(JBRCode, SubType) + FullJACode(ACode) + LJVar(Id.StockCode,StkKeyLen - 1);
      KeyChk := KeyS;
      Res := Find_Rec(B_GetGEq, F[JCtrlF], JCtrlF, RecPtr[JCtrlF]^, 0, KeyS);

      //PR: 20/11/2009 Changed to stop it reading through all records
      //PR: 28/01/2010 Changed to not check the currency byte
      Result := (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk) - 1, True);
    end;


    function GetJobRate : Boolean;
    begin
      Result := GetRate(Id.JobCode);
    end;

    function GetEmpRate : Boolean;
    begin
      //PR: 17/05/2010 Need to pass in correct subtype to GetRate function
      Result := GetRate(TSHEmployeeRec.EmpCode, 'R');
    end;

    function GetGlobalRate : Boolean;
    begin
      Result := GetRate(FullNomKey(-1));
    end;

    function GetChargeCurrency : Integer;
    var
      bRes         : Boolean;
      KeyNum       : Integer;
      SavedPosOK   : Boolean;
      RecPos       : LongInt;
    begin
      Result := 0;

      //Store position in Job Ctrl file
      KeyNum := GetPosKey;
      SavedPosOK := Presrv_BTPos(JCtrlF, KeyNum, F[JCtrlF], RecPos, false, false) = 0;

      Try
        //Find correct TimeRate according to rules on Employee record
        Case TSHEmployeeRec.UseORate of
          0  :  begin
                  bRes := GetEmpRate;
                  if not bRes then
                    bRes := GetJobRate;
                  if not bRes then
                    bRes := GetGlobalRate;
                end;
          1  :  bRes := GetEmpRate;
          2  :  begin
                  bRes := GetJobRate;
                  if not bRes then
                    bRes := GetEmpRate;
                  if not bRes then
                    bRes := GetGlobalRate;
                end;
          3  :  bRes := GetJobRate;
          else
            bRes := False;
        end; //case
        if bRes then
          Result := JobCtrl^.EmplPay.ChargeCurr;
      Finally
        //Restore position
        if SavedPosOK then
          Presrv_BTPos(IDetailF, KeyNum, F[IDetailF], RecPos, true, false);
      End;

    end;

    //PR: 06/05/2014 ABSEXCH-14677 Identifies a payment\receipt line to the suspense a/c
    function SuspenseLine : Boolean;
    begin
      with Id do
        Result := (NomCode = Syss.NomCtrlCodes[UnRCurrVar]) and
                  (Inv.InvDocHed in [SRC, SRI, PPY, PPI]) and (Id.LineNo = RecieptCode);
    end;

//----------------------------------------------------------------------------------------
begin
  Profiler.StartFunc('ValidateEachTL');
  Result:=0;
  HaveMLocRec := False;
  ValidCheck:=BOn;  ValidHed:=BOff;
  WOPNomCode := 0;

  TBo:=BOff;        RepBo:=BOff;

//  LineVAT:=0;  LineTot:=0;
  {LineCost:=0; LineWeight:=0;}
  UOR:=0;

  With Id do
  begin

    {* Check Currency *}

    If (ExSyss.MCMode) and (Inv.InvDocHed In NomSplit+RecieptSet) then
    begin
      ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));

      //PR: 06/05/2014 ABSEXCH-14677 Allow lines to Suspense Account to be in consolidated
      if SuspenseLine then
        ValidCheck := Currency = 0;

      {$IFDEF COMTK}
       ValidCheck := ValidCheck or (AllowCtrlGls and (Currency = 0));
      {$ENDIF}
      {* 18.08.99 - Added to use Default Currency *}
      If (Not ValidCheck) then
      begin
        Currency:=ExSyss.DefCur;
        ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
      end;
    end; {if..}
    GenSetError(ValidCheck,30100,Result,ValidHed);
    {* Check Currency Rates *}
    If (ExSyss.MCMode) then
    Begin
      //=======RECORD CHANGING==========//
      {* 06.01.99 - Added this condition when Euro conversion was tested with EL's advice *}
      If (ExSyss.UseExCrRate) or not UseCoDayRate then {* OverWrite Currency Rates *}
      begin
        CXrate:=SyssCurr^.Currencies[Currency].CRates;
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end; {if..}
      //===============================//

      (*
      {* 01.04.99 - Ent. v4.30a validates these fields *}
      VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;
      OrigRates:=SyssCurr^.Currencies[Currency].CRates;
      *)

      ValidCheck:=((CXRate[BOn]<>0) or (Inv.InvDocHed In StkAdjSplit));

      GenSetError(ValidCheck,30101,Result,ValidHed);

      {05.09.2000 - closed and added the following condition according to EL's advice.
      If (Not UseCoDayRate) or (Inv.InvDocHed In NomSplit) then}
      If ((Not UseCoDayRate) and (ExSyss.UseExCrRate)) or (Inv.InvDocHed In NomSplit) then
      Begin
        ValidCheck:=((CXRate[BOff]<>0) or (Inv.InvDocHed In StkAdjSplit));
        GenSetError(ValidCheck,30102,Result,ValidHed);
      end;

      {* 06.01.99 - Added with EL's Advice *}
      // HM 06/03/01: Added eBusiness Mode check - as 0 rate was causing problem posting from eBus into Ent
      //=======RECORD CHANGING==========//
//      If (Not (Inv.InvDocHed In NomSplit)) And (Not InEbusinessMode) then {* Set to floating *}
      //PR: 13/08/2010 Added extra transaction types for which company rate should not be set to zero
      If (Not (Inv.InvDocHed In SetCompanyRateSet)) And (Not InEbusinessMode) then {* Set to floating *}
      begin
        CXRate[BOff]:=0;
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end;
      //===============================//

    end
    else
    Begin
      //=======RECORD CHANGING==========//
      Currency:=0;
      CXrate:=SyssCurr^.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      //===============================//
    end; {Check Currency Rate..}

    {* LineNo *}

    ValidCheck:=(LineNo>0);
    GenSetError(ValidCheck,30103,Result,ValidHed);

    {* Discount Code Check *}

    ValidCheck:=(DiscountChr In StkBandSet+[#0,#32,PcntChr]);

    GenSetError(ValidCheck,30108,Result,ValidHed);

    ValidCheck:=(Discount2Chr In [#0,#32,PcntChr]);

    GenSetError(ValidCheck,30132,Result,ValidHed);

    ValidCheck:=(Discount3Chr In [#0,#32,PcntChr]);

    GenSetError(ValidCheck,30133,Result,ValidHed);
    {* Stock Code Check *}

    {If ((Payment=DocPayType[SRC]) and (Not (IDDoched In NomSplit)) and
        (StockCode[1]<>PayInCode)) then
         StockCode:=PayInCode+StockCode;    }

    {* Changed on 16/03/99 for PayInRef and ADJ not showing in the ledger
       because IDDocHed has not been assigned at this stage *}
    { Closed on 04.02.2000 ....
    If ((Payment=DocPayType[SRC]) and (Not (Inv.InvDocHed In NomSplit+StkAdjSplit)) and
        (StockCode[1]<>PayInCode)) then
         StockCode:=PayInCode+StockCode;   }

      //=======RECORD CHANGING==========//
    If (Inv.InvDocHed in [SRC, NMT])  then
      StockCode:=PayInCode+StockCode;
                                                        //PR 27/03/06 - Allow PayRef on Noms
    If ((Payment=DocPayType[SRC]) and (Not (IDDoched In {NomSplit+}StkADJSplit)) and
        (StockCode[1]<>PayInCode)) then
         StockCode:=PayInCode+StockCode;
      //===============================//

    ValidCheck:=((EmptyKey(StockCode,StkLen)) or (StockCode[1]=PayInCode) or (Inv.InvDocHed In TSTSplit));

    If (Not ValidCheck) then
    Begin

      {* 07.07.2000 *}
      StockCode:=FullStockCode(StockCode);

      ValidCheck:=(CheckRecExsists(StockCode,StockF,StkCodeK));

      ValidCheck:=((ValidCheck) and (Stock.StockType In StkProdSet+[StkDescCode]));

      GenSetError(ValidCheck,30106,Result,ValidHed);

      {* 05.01.99 - Reported by Hayden Lab, ADJ Trans Stock Deduction *}
      //PR 8/3/04 - Moved above to ExInvLineToId
(*      If (ValidCheck) then
      begin

        StockCode := ID.StockCode;
        StockCode:=FullStockCode(StockCode);

        ValidCheck:=(CheckRecExsists(StockCode,StockF,StkCodeK));

        if ValidCheck then
        begin
          ID.UsePack := Stock.CalcPack;
          ID.PrxPack := Stock.PricePack;
          if ID.IdDocHed in SalesSplit then
            ID.QtyPack := Stock.SellUnit
          else
            ID.QtyPack := Stock.BuyUnit;


          ID.ShowCase := Stock.DPackQty;

        // HM 09/07/01: Mod for ADJ Pack Qty support
        // HM 10/07/01: Removed limitation to ADJ only after consultation with EL
        //              as same problem was hapening with any trans type using stock
        //If (Inv.InvDocHed = ADJ) Then
          ShowCase := Stock.DPackQty;
       end;

        If (Stock.DPackQty) then
        begin
          QtyPack:=Stock.BuyUnit;
{          if Stock.StkValType = 'A' then}
        end
        else
          QtyPack:=1;

        Qty := Case2Ea(ID, Stock, Qty);
*)

        {$IFDEF COMTK}
        if KitLink > 0 then
        begin
          if ((IDDOCHed in SalesSplit) and (Stock.ShowasKit)) or
             ((IDDOCHed in PurchSplit) and (Stock.KitOnPurch)) or
             ((IDDOCHed in SalesSplit + PurchSplit) and (Stock.ShowasKit or Stock.KitOnPurch)) then
               DeductQty := Qty;
        end;
        {$ENDIF}

//        PrxPack := Stock.PricePack;

        {* 07.07.99 - added otherwise, line description is blank *}
      //=======RECORD CHANGING==========//
        If EmptyKey(Desc,SizeOf(Desc)) then
          Desc:=Stock.Desc[1];
      //===============================//

        {* Need to add for Cost Price Check *}
(*        If {(CostPrice=0) and} (ExSyss.AutoSetStkCost) and (Inv.InvDocHed In SalesSplit+StkAdjSplit) then
        begin
{          CostPrice:=Currency_ConvFT(DivWChk(Stock.CostPrice,Stock.BuyUnit)*QtyPack,Stock.PCurrency,
                                     Inv.Currency,UseCoDayRate);}

          if not UsePack or  Stock.DPackQty then
            TmpQtyM := QtyMul
          else
            TmpQtyM := 1;

          CostPrice:=Currency_ConvFT(Calc_StkCP(Stock.CostPrice,Stock.BuyUnit,
                                     Stock.CalcPack) * TmpQtyM,Stock.PCurrency,
                                     Inv.Currency,UseCoDayRate);




          if {(Not Stock.ShowAsKit)  and} Is_FIFO(Stock.StkValType) then
          begin
{            if Stock.DPackQty and not UsePack then
              TmpQtyM := QtyPack
            else
              TmpQtyM := QtyMul;}

            CostPrice := FIFO_GetCost(Stock,Inv.Currency,Qty*QtyMul{TmpQtyM},QtyMul,MLocStk);
          end;
        end; {if..} *)

//      end; {if..}

    end;

    {* Multi Location Code Check *}

    { Closed on 26.01.99 for EL advised that if Syss.UseMLoc is OFF
      allow Location Code to be entered whatever it is...
      ValidCheck:=(((EmptyKey(MLocStk,LocKeyLen)) and (Not Syss.UseMLoc)) or (EmptyKey(StockCode,StkLen)));}

    {* Added (Not Syss.UseMLoc) for New Zealand and (Empty(StockCode) for S.C.C  *}
    { Multilocation code irrelevant on a timesheet }
    { 28.09.2000 - Added PayInCode check = Not to check Payment line,
                   moved this validation after stock code otherwise, PayInCode has not been assigned yet}

    ValidCheck := (EmptyKey(StockCode,StkLen)) or (Not Syss.UseMLoc) or
                  (Inv.InvDocHed In TSTSplit) or
                  ((Not Emptykey(StockCode,StkLen)) and (StockCode[1]=PayInCode));

    { 28.09.2000 - Added LJVAR again, otherwise returns True if location code is empty for Payment line }
    //PR: 23/09/2011 Added check for description lines with no value as we don't need to validate their location (ABSEXCH-11824)
    //PR: 02/12/2011 If stock code is populated then we must have a location  (ABSEXCH-12256)
    if AllowOverrideLocation(IDDocHed, Id.LineNo) and (Trim(Inv.thOverrideLocation) <> '') and
       (not ZeroFloat(InvLTotal(ID, True, 0)) or not EmptyKey(StockCode,StkLen)) then
    begin
      if Trim(MLocStk) = '' then
        MLocStk := Inv.thOverrideLocation
      else
      begin
        //PR: 09/12/2010 Removed check for Stock Code - if there's an override location, then can't have a different location on
        //the line, regardless of stock code.
        ValidCheck := MLocStk = Inv.thOverrideLocation;
        GenSetError(ValidCheck,30143,Result,ValidHed);
      end;
    end;


    If (Not ValidCheck) then
    begin
    {$IFDEF EXSQL}
      if UsingSQL then
        UseVariantForNextCall(F[MLocF]);
    {$ENDIF}
      ValidCheck:=(CheckRecExsists(MLocFixCode[True]+LJVar(MLocStk,LocKeyLen),MLocF,MLK));
      HaveMLocRec := ValidCheck;
    end;
      {29.08.2000 - ValidCheck:=(CheckRecExsists(MLocFixCode[True]+LJVar(MLocStk,LocKeyLen),MLocF,MLK));}

    //PR 06/12/01 Added check for location in wop
    if (Inv.InvDocHed in WOPSplit) and Syss.UseMLoc then
    begin

      //Line 1 must have valid location - other lines can be defaulted to Line 1's location

      if not ValidCheck then
      begin
        if LineNo = 1 then
          GenSetError(ValidCheck, 30115, Result, ValidHed)
        else
          MLocStk := Line1MLoc;
      end
      else
        if LineNo = 1 then
          Line1MLoc := MLocStk;
    end
    else
      GenSetError(ValidCheck,30115,Result,ValidHed);

      //=======RECORD CHANGING==========//
    if ((Not Emptykey(StockCode,StkLen)) and (StockCode[1] <> PayInCode)) then
    begin
      if Syss.UseMLoc then
      begin
        if HaveMLocRec then
        begin
          if MlocCtrl.MLocLoc.loUseCPrice then
          begin
          {$IFDEF EXSQL}
            if UsingSQL then
              UseVariantForNextCall(F[MLocF]);
          {$ENDIF}
            if CheckRecExsists(CostCCode + CSubCode[False]
                                  + FullStockCode (StockCode) + LJVar(MLocStk, MLocKeyLen),
                                    MLocF,MLK) then
            begin
              Stock.CostPrice := MLocCtrl.MStkLoc.lsCostPrice;
              Stock.PCurrency := MLocCtrl.MStkLoc.lsPCurrency;
            end;
          end;
        end;
      end; //If Syss.UseMLoc
                                                           //PR: 26/05/2011 Added WOR & SIN to accord with oLine.DoImportDefaults
      If (ExSyss.AutoSetStkCost) and (Inv.InvDocHed In SalesSplit+StkAdjSplit+[WOR, SRN]) then
      begin

        if not UsePack or  Stock.DPackQty then
          TmpQtyM := QtyMul
        else
          TmpQtyM := 1;

        //PR: 26/05/2011 Need to check if we're exploding BOM on Sales Trans here -
        //if we are then we don't set cost price (ABSEXCH-11182)
        if (Inv.InvDocHed = ADJ) or not Stock.ShowAsKit then
        begin
          if Is_FIFO(Stock.StkValType) then
            CostPrice := FIFO_GetCost(Stock,Inv.Currency,Qty*QtyMul{TmpQtyM},QtyMul,MLocStk)
          else
            CostPrice:=Currency_ConvFT(Calc_StkCP(Stock.CostPrice,Stock.BuyUnit,
                                      Stock.CalcPack) * TmpQtyM,Stock.PCurrency,
                                       Inv.Currency,UseCoDayRate);
        end
        else
          CostPrice := 0.0;
      end; {if AutoSetStockCost}

    end; //Not empty key
      //===============================//


//  NF: Changed from TrueReal to Round_Up because TrueReal was rounding 18.525 to 18.52, not 18.53
//  P.S. this was done after consulting with HM !

//    TmpQty:=TrueReal(Qty,Syss.NoQtyDec);
//    TmpNetValue:=TrueReal(NetValue,Syss.NoNetDec);}

//    SetSplitPackStockDetails;

    TmpQty:=Round_Up(Qty,Syss.NoQtyDec);
    // HM 27/11/01: Modified to check transaction type before rounding NetValue
    If (IdDocHed In SalesSplit) Then
      // Sales
      TmpNetValue:=Round_Up(NetValue,Syss.NoNetDec)
    Else
      If (IdDocHed = NMT) Then
        // Nominal Transfer
        TmpNetValue:=Round_Up(NetValue,2)
      Else
        // ADJ/Purchase
        TmpNetValue:=Round_Up(NetValue,Syss.NoCOSDec);

//    LineTot:=Round_Up((TmpQty*TmpNetValue),2);
      //PR 08/04/03 Find line discount by subtracting tot with disc from tot w/out disc
      TotNoDisc := InvLTotal(ID, {Inv.DiscTaken}False, {Inv.DiscSetl}0.0);
      LineTot := InvLTotal(ID, {Inv.DiscTaken}True, {Inv.DiscSetl}0.0);

      TmpDisc := TotNoDisc - LineTot;
//      LineTot := InvLTotal(ID, {Inv.DiscTaken}False, Inv.DiscSetl);
//      LineTot := InvLTotalND(ID, {Inv.DiscTaken}False, Inv.DiscSetl, -1);

//PR 23/09/03 Added handling to calculate correct totordos
(*      If (Inv.InvDocHed In PSOPSet) and (Mode = 1) then {* Calculate how much of the order remains O/S *}
        Inv.TotOrdOS:=Inv.TotOrdOS+InvLOOS(Id,BOn,0);


    {* For TSH, total Qty = TotalInvoiced *}
    If (Inv.InvDocHed In TSTSplit) and (Mode=1) then
      Inv.TotalInvoiced:=Inv.TotalInvoiced + TmpQty; *)

    If (ExSyss.MCMode) and
       ( //PR: 21/01/2009 - Added check for Timesheets so that line total gets converted to consolidated
        (Inv.InvDocHed In RecieptSet+NomSplit+TSTSplit) or
        ((Inv.InvDocHed In DirectSet) and (Payment=DocPayType[SRC]))
       ) then {* Convert to Base equiv *}
    begin
      {LineTot:=Round_Up(Conv_Curr(LineTot,CXRate[UseCoDayRate],BOff),2);}
      //PR: 17/5/02 Calling XRate was using system CompanyRate if daily rate set
      // and UseExCurrencyRates was off.  We shouldn't need to call it because
      //if we're using the system rates they've already been set above
      //PR: 16/01/03 Problem when CompanyRate
      if not UseCoDayRate then
        TmpXRate:=XRate(CXRate,UseCoDayRate,Currency)
      else
        TmpXRate := CXRate[UseCoDayRate];
        {* 02.02.99 Added new parameter 0 for new Conv_TCurr function *}
        LineTot:=Round_Up(Conv_TCurr(LineTot,TmpXRate,Currency,0,BOff),2);
    
	end;

    {* Add Doc Line Type Total Here ... 19.11.97 *}
    if not (Inv.InvDocHed in StkRetSplit) then
    begin
      If (DocLTLink>0) then
        Inv.DocLSplit[DocLTLink]:=Inv.DocLSplit[DocLTLink]+LineTot;
    end
    else
    begin
      Inv.DocLSplit[1] := Inv.DocLSplit[1] + Qty;
      Inv.DocLSplit[2] := Inv.DocLSplit[2] + QtyPick;
      Inv.DocLSplit[3] := Inv.DocLSplit[3] + QtyDel;
      Inv.DocLSplit[4] := Inv.DocLSplit[4] + QtyWoff;
      Inv.DocLSplit[5] := Inv.DocLSplit[6] + (QtyDel * NetValue);
    end;

    //PR Change to include variance lines in total if using Chris's switch
    //PR 7/9/06 - Return to ignoring currency variance lines under Chris's switch
    {* do not include in total check, as its a variance line *}
    If {not AllowCtrlGLs and }((Inv.InvDocHed In RecieptSet) and (NomCode=Syss.NomCtrlCodes[CurrVar]) and (ExSyss.MCMode)) then
    Begin
      ImpVariance:=ImpVariance+LineTot; {* Calculate variance contribution *}
    end
    else
      {* Do Not Include Direct Payment Parts *}
      If ((Payment<>DocPayType[SRC]) or (Not (Inv.InvDocHed In DirectSet))) then
      Begin
        //PR: 09/04/2002
        //Make sure split pack fields are set from stock record
{        if ShowCase and PrxPack and (QtyPack <> 0.0) then
        begin
          LineVat := LineVat + (VAT / QtyPack);
          LineNet := LineNet + (LineTot / QtyPack);
        end
        else }
        begin
          if Inv.InvDocHed = NMT then
          begin
          //PR 11/04/06 If Single Currency, then TmpXRate was 0, setting Vat to 0.
            if ExSyss.MCMode then
//              TmpLineVat := Round_Up(Conv_TCurr(VAT,TmpXRate,Currency,0,BOff),2)
              //PR: 19/05/2010 Change to use table rather than line xrate.
              //PR: 19/05/2011 Change to use line rather than table xrate.
              TmpLineVat := Round_Up(Conv_TCurr(VAT, GetVATExchangeRate(CXRate, Currency), Currency, 0, BOff),2)
            else
              TmpLineVat := VAT;
            LineVAT:=LineVAT+TmpLineVat;
          end
          else
            LineVat := LineVAT + Vat;
          LineNet:=LineNet+LineTot;
          LineDisc := LineDisc + TmpDisc;

          {$IFDEF EN551}
            //Need to check that VAT balances
{            if (Inv.InvDocHed = NMT) and (VAT <> 0) then
              LineNet := LineNet + Round_Up(Conv_TCurr(VAT,TmpXRate,Currency,0,BOff),2);}
          {$ENDIF}
        end;
        {* Add LineCost and Line Weight *}
        { Closed on 25.09.2000
        LineCost:=Round_Up(LineCost+Round_Up((CostPrice*Qty),Syss.NoCosDec),2);
        LineWeight:=LineWeight+(LWeight*Qty);}

        HeaderWeight:=HeaderWeight + Round_Up((LWeight*Qty),2);

      end; {if..}

    If (Inv.InvDocHed In DirectSet) and (Payment=DocPayType[SRC]) then
      LineDir:=LineDir+LineTot;

(*  //PR: 02/04/2012 Removed change to keep rounding errors in sync with Exchequer.

    //PR: 28/02/2012 Keep LineDir in currency here and convert below to avoid rounding errors in comparision
      //with inv total ABSEXCH-12050
     If (Inv.InvDocHed In DirectSet) and (Payment=DocPayType[SRC]) then
        LineDir:=LineDir + InvLTotal(ID, {Inv.DiscTaken}True, {Inv.DiscSetl}0.0);
 *)

    {* Nominal Check *}
    {* Add TSTSplit and change repeat loop to check for Default Nom Code *}

    If (Not (Inv.InvDocHed In TSTSplit)) then
    begin
      RepBo:=BOff;
      Repeat
        { Changed for T.Pink & Tomkins ..NOMs
        ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(NomCode)),NomF,NomCodeK)
                     or (LineTot=0) );
        ValidCheck:=((ValidCheck) and ((Nom.NomType In [BankNHCode,PLNHCode])
                                        or (LineTot=0)));
        }

        ValidCheck:=(Not (Inv.InvDocHed In NomSplit+WOPSplit)) and (LineTot=0);
        {$IFDEF EN551}
        if Inv.InvDocHed = NMT then
          ValidCheck := (NOMIOFlg = 2) and (LineTot = 0);
        {$ENDIF}

        If (Not ValidCheck) then
        begin
          //PR 11/12/01 - added check for WOP
          if (Inv.InvDocHed in WOPSplit) then
          begin
            //Get defaults from location
            Move(Stock, WOPTempStock, SizeOf(Stock));
            Stock_LocNSubst(WOPTempStock, MLocStk);
            if Syss.UseCCDep then
              Stock_LocCCDSubst(WOPTempStock, MLocStk); //Get CCDep as well if necessary
            if ExSyss.UseMLoc then
            begin
              //if location defaults not blank then replace stock gls with them
              if WOPTempStock.NomCodeS[4] <> 0 then
                Stock.NomCodeS[4] := WOPTempStock.NomCodeS[4];
              if WOPTempStock.NomCodeS[5] <> 0 then
                Stock.NomCodeS[5] := WOPTempStock.NomCodeS[5];
            end;

            if Stock.StockType = StkBillCode then
              WopNomCode := Stock.NomCodes[5]
            else
              WopNomCode := Stock.NomCodes[4];

            if NomCode = 0 then
                NomCode := WopNomCode;

          end;
          ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(NomCode)),NomF,NomCodeK));

          {$IFDEF COMTK}
          ValidCheck:=((ValidCheck) and ((Nom.NomType In [BankNHCode,PLNHCode]) or
                                          (AllowCtrlGLs and (Nom.NomType = CtrlNHCode))));
          {$ELSE}
          ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));
          {$ENDIF}



        end;

        {GenSetError(ValidCheck,30104,Result,ValidHed);}

        RepBo:=Not RepBo;

        If (Not ValidCheck) and (not (Inv.InvDocHed in WOPSplit)) then
          NomCode:=ExSyss.DefNom;  {* Default Nom Code *}

      Until (Not RepBo) or (ValidCheck);

      if not (Inv.InvDocHed in WOPSplit) then
        GenSetError(ValidCheck,30104,Result,ValidHed)
      else
      begin
        if ValidCheck then
        begin
          ValidCheck := NomCode = WopNomCode;
          GenSetError(ValidCheck,30125,Result,ValidHed);
        end
        else
          GenSetError(ValidCheck,30104,Result,ValidHed);
      end;

      // SSK 03/05/2017 2017-R1 ABSEXCH-18421: check for blank JobCode and Analysis code when ForceJCFlag is true
      if Nom.ForceJC and (Inv.InvDocHed In Salessplit+PurchSplit+NomSplit+StkAdjSplit) then
      begin
        if ValidCheck then
        begin
          ValidCheck := ValidCheck and (trim(JobCode)<>'');
          GenSetError(ValidCheck,30149,Result,ValidHed);
        end;

        if ValidCheck then
        begin
          ValidCheck := ValidCheck and (trim(AnalCode)<>'');
          GenSetError(ValidCheck,30150,Result,ValidHed);
        end;
      end;

    end;

    {* Cost Centre/Dep Check *}
    {* Add validation 19.2.97 *}
    // HM 28/06/02: Extended as current checks are allowing unset CC/Depts through and removing set CC/Depts
    If ValidCheck Then Begin
      // Check whether we need to check the CC/Dept
      If Syss.UseCCDep Then Begin
        If (Not (Inv.InvDocHed In StkAdjSplit+NomSplit)) and (LineTot=0) and
                 ((CostPrice=0) or (Inv.InvDocHed in JAPSplit)) Then Begin
          // Not an ADJ or NOM and the Line Total and Cost Price are zero
          // No Validation - let anything go through
        End { If }
        Else Begin
          // Validate CC/Dept Codes fully
          if not AllowCtrlGLs then
          For Tbo := BOff to BOn Do Begin
            RepBo:=BOff;
            Repeat
              KeyF:=(CostCCode+CSubCode[TBo]+CCDep[TBo]);
              Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyF);

              ValidCheck:=(Status=0);

              If (Not ValidCheck) then
              begin
                if (Inv.InvDocHed in WOPSplit) then
                begin
                  //if wop then try the cc/dep from stock/location first then default from ini file
                  KeyF:=(CostCCode+CSubCode[TBo]+WOPTempStock.CCDep[TBo]);
                  Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyF);
                  if Status = 0 then
                    CCDep[Tbo]:=WOPTempStock.CCDep[Tbo]
                  else
                    CCDep[Tbo]:=ExSyss.DefCCDep[Tbo];
                end
                else
                  CCDep[Tbo]:=ExSyss.DefCCDep[Tbo];
              end;

              RepBo:=Not RepBo;

            Until (Not RepBo) or (ValidCheck);
            GenSetError(ValidCheck,30105,Result,ValidHed);

            {SS 17/06/2016 2016-R3 
             ABSEXCH-12948:Core Financials - Possible to import Transactions with Inactive CC/Depts using Importer Module.
             -Added validation to check Cost Centre/Department is active or not.}
            if ValidCheck then
            begin
              ValidCheck := (PassWord.CostCtrRec.HideAC = 0);
              GenSetError(ValidCheck,30148,Result,ValidHed);
            end;
            
            If (Not ValidCheck) Then Break;
          End; { For Tbo}
        End; { Else }
      End { If Syss.UseCCDep }
      Else Begin
        // CC/Depts turned off - blank out CC/Dept on line
        CCDep[BOn] := '';
        CCDep[Tbo] := '';
      End; { Else }
    End; { If ValidCheck }

    (***
    For Tbo:=BOff to BOn do
    Begin
      {* Changed on 12/03/97 requested by NewZeland to allow CC & Dept if Line Total = 0 *}
      {
      ValidCheck:=((Not Syss.UseCCDep) or
                   ((Not (Inv.InvDocHed In StkAdjSplit)) and (LineTot=0)));
      }

      ValidCheck:=((Not Syss.UseCCDep) or
                   ((Not (Inv.InvDocHed In StkAdjSplit+NomSplit)){ and (LineTot=0) and (CostPrice=0)}));

      If (ValidCheck) then CCDep[Tbo]:='';

      If (Not ValidCheck) then
      Begin
        RepBo:=BOff;
        Repeat

          KeyF:=(CostCCode+CSubCode[TBo]+CCDep[TBo]);
          Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyF);

          //PR: 8/5/2002
          //Allow CCs and Depts to be stored if LineTot and Cost are 0, but must be valid (or blank)
          ValidCheck:=(Status=0) or ((CCDep[TBo] = '') and (LineTot=0) and (CostPrice=0));
          {ValidCheck:=((CheckRecExsists(CostCCode+CSubCode[TBo]+CCDep[TBo],PWrdF,PWK)));}

          If (Not ValidCheck) then
          begin
            if (Inv.InvDocHed in WOPSplit) then
            begin
              //if wop then try the cc/dep from stock/location first then default from ini file
              KeyF:=(CostCCode+CSubCode[TBo]+WOPTempStock.CCDep[TBo]);
              Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyF);
              if Status = 0 then
                CCDep[Tbo]:=WOPTempStock.CCDep[Tbo]
              else
                CCDep[Tbo]:=ExSyss.DefCCDep[Tbo];
            end
            else
              CCDep[Tbo]:=ExSyss.DefCCDep[Tbo];
          end;

          RepBo:=Not RepBo;

        Until (Not RepBo) or (ValidCheck);
        GenSetError(ValidCheck,30105,Result,ValidHed);
      end;

    end;
    ***)


    VJActual:=BOff; {* for Job Actual *}
    {* JobCode checking *}
    {* Stock Code checking for TSH *}
    {* Check AnalCode in AnalRec of JobMiscFile. If valid, *}
    {* check StockCode(EmpPayRate) in EmplPayRec of JobCtrlFile *}

  Profiler.StartFunc('ValidateEachTL - Check Job Costing');


    If (Not ExSyss.JBIgnore) then
    begin

      If (Inv.InvDocHed In TSTSplit) then
      Begin
        //PR 25/04/06 - Added check to disallow contracts
        ValidCheck:=(CheckRecExsists(JobCode,JobF,JobCodeK)) and (JobRec.JobType <> JobGrpCode);

        If (ValidCheck) then TmpChargeType:=JobRec^.ChargeType; {for Job Actual Rec.}

        GenSetError(ValidCheck,30111,Result,ValidHed);

        ValidCheck:=(CheckRecExsists(JARCode+JAACode+AnalCode,JMiscF,JMK));

        GenSetError(ValidCheck,30112,Result,ValidHed);

        //PR 10/3/03 New check for transactions to closed jobs if switch set in ini file
        if ValidCheck and ExSyss.NoTranToClosedJob then
        begin
          ValidCheck := JobRec^.JobStat <> 5;

          GenSetError(ValidCheck,30126,Result,ValidHed);
        end;

        If (ValidCheck) then
        Begin
           VJActual:=BOn;

           TmpJAType:=JobMisc^.JobAnalRec.AnalHed; {for Job Actual Record}

           {TmpBudg := FullJBCode(FullNomKey(-1),Currency,StockCode);}
           {* 02.02.2000 -  this has been changed for Single Currency ...*}
           TmpBudg := Strip('R',[#0],FullJBCode(FullNomKey(-1),0,StockCode));


           ValidCheck:=((CheckRecExsists(JBRCode+JBECode+TmpBudg,JCtrlF,JCK)));

           {* 02.09.99 - Added EmptyKey validation *}
           If (ValidCheck) and (EmptyKey(Desc,SizeOf(Desc))) then
              Desc:=JobCtrl^.EmplPay.PayRDesc;

           GenSetError(ValidCheck,30113,Result,ValidHed);

        end; {If ValidCheck for AnalCode}

        {* For TSH Charge Currecny *}
        If (ExSyss.MCMode) then
        begin
          {If (Not ValidCheck) then
          begin
             Reconcile:=Currency;
             ValidCheck:=BOn;
          end;}
          //PR: 26/01/2011 ABSEXCH-9367 Check against the appropriate TimeRate Charge Currency
          iChargeCurrency := GetChargeCurrency;
          if Reconcile = 0 then
          begin
            Reconcile := iChargeCurrency;
            ValidCheck := True;
          end
          else
            ValidCheck := Reconcile = iChargeCurrency;

          if ValidCheck then
            ValidCheck:=((Reconcile>=1) and (Reconcile<=CurrencyType));

          GenSetError(ValidCheck,30114,Result,ValidHed);

        end
        else
          Reconcile:=0; {not MC}

      end {If TSH}
      else { for other Transaction Code - SIN, PIN etc..}
      begin
        {
          CJS 12/04/2011 - ABSEXCH-9340 - Amended the validation:

            1. If both a Job Code and an Analysis Code are entered, they both
               must be valid.

            2. A Job Code cannot be entered without a valid Analysis Code.

            3. If an Analysis Code is entered without a Job Code, it should not
               be validated -- any content is permitted.
        }
        // Both codes entered, so validate both.
        if not EmptyKey(AnalCode, JobCodeLen) and not EmptyKey(JobCode, JobCodeLen) then
        begin
          // Validate the Job Code
          //PR: 09/11/2011 Added check that job isn't a contract. ABSEXCH-12125
          ValidCheck := (CheckRecExsists((JobCode),JobF,JobCodeK)) and (JobRec.JobType <> JobGrpCode);
          GenSetError(ValidCheck, 30111, Result, ValidHed);

          //PR 09/11/2011 v6.9 Check for no transactions to closed jobs if switch set in ini file - was previously only
          //applied to timesheets. ABSEXCH-11607
          if ValidCheck and ExSyss.NoTranToClosedJob then
          begin
            ValidCheck := JobRec^.JobStat <> 5;

            GenSetError(ValidCheck,30126,Result,ValidHed);
          end;

          If (ValidCheck) then
          begin
            TmpCurrCharge := JobRec^.CurrPrice;  {for Job Actual Rec.}
            TmpChargeType := JobRec^.ChargeType; {for Job Actual Rec.}
            VJActual      := BOn;
            // Validate the Analysis Code
            ValidCheck := (CheckRecExsists(JARCode + JAACode + AnalCode, JMiscF, JMK));
            TmpJAType  := JobMisc^.JobAnalRec.AnalHed; {for Job Actual Rec.}
            GenSetError(ValidCheck, 30112, Result, ValidHed);
          end;
        end
        else if EmptyKey(AnalCode, JobCodeLen) then
        begin
          // Analysis Code is empty, so Job Code must also be empty. Report an
          // error if this is not the case.
          ValidCheck := EmptyKey(JobCode,JobCodeLen);
          if not ValidCheck then
            GenSetError(ValidCheck, 30112, Result, ValidHed);
        end;

        {
          CJS 12/04/2011 - ABSEXCH-9340 - Removed the original validation.
        }
        (*
        {
          CJS 18/01/2011 - Amended validation to force a check of the Job Code
          if an Analysis Code has been entered (to prevent entering an Analysis
          Code without a Job Code).
        }
//        ValidCheck:=(EmptyKey(JobCode,JobCodeLen));
        ValidCheck := EmptyKey(AnalCode,JobCodeLen) And EmptyKey(JobCode,JobCodeLen);

        If (Not ValidCheck) then
        Begin
          ValidCheck:=(CheckRecExsists(JobCode,JobF,JobCodeK));

          If (ValidCheck) then
          begin
            TmpCurrCharge:=JobRec^.CurrPrice;  {for Job Actual Rec.}
            TmpChargeType:=JobRec^.ChargeType; {for Job Actual Rec.}
            VJActual:=BOn;
          end;

          GenSetError(ValidCheck,30111,Result,ValidHed);
        end;

        // MH 26/10/2010 v6.5 ABSEXCH-9913: Force validation of Analysis Code if Job Code is set
        //ValidCheck:=(EmptyKey(AnalCode,JobCodeLen));
        ValidCheck := EmptyKey(AnalCode,JobCodeLen) And EmptyKey(JobCode,JobCodeLen);

        If (Not ValidCheck) then
        Begin
          ValidCheck:=(CheckRecExsists(JARCode+JAACode+AnalCode,JMiscF,JMK));

          TmpJAType:=JobMisc^.JobAnalRec.AnalHed; {for Job Actual Rec.}

          GenSetError(ValidCheck,30112,Result,ValidHed);
        end; {if..}
        *)
      end; {if TSTSplit else..}

      { 28.09.2000 - To use appropriate NomCode depending on Job Status ..}
      If (Not EmptyKey(JobCode,JobCodeLen)) and (Not EmptyKey(AnalCode,JobCodeLen)) then
      begin
        //PR 8/9/03 - Should only change on Purchase transactions & not if updating
        if (Inv.InvDocHed in PurchSplit) and (SMode <> B_Update) then
          NomCode:=Job_WIPNom(NomCode, JobCode, AnalCode, StockCode, MLocStk, Custcode);
      end; {if..}

    end; {if (Not JBIgnore) ..}
    {* --------------------------- *}
  Profiler.EndFunc('ValidateEachTL - Check Job Costing');

    //PR 6/12/01 - Added validation for reconcile field in transaction line
    {Timesheets are handled above, anything posted to GL must be within
     ReconStatus range (currently 0 - 3), anything else must be 0.  If GL then
     validate and give error message, else set field to 0 and let it through}

    If not (Inv.InvDocHed In TSTSplit) then
    begin
      ValidCheck := True;
      if (Inv.InvDocHed in
          ((PurchSplit + SalesSplit + NomSplit) - (PsopSet + QuotesSet + BatchSet))
         ) then
      begin
        if not (Reconcile in [Low(ReconStatus)..High(ReconStatus)]) then
        begin
          ValidCheck := False;
          GenSetError(ValidCheck,30122,Result,ValidHed);
        end;
      end
      else
        Reconcile := 0;
    end;

    {* VAT Code Check *}

    ValidCheck:=(((VATCode<>VATICode) and (VATCode In VATSet))
                 or (LineTot=0) or (Payment=DocPayType[SRC])
                 or ((Id.IdDocHed = NMT) and (Id.VAT = 0)));

    {* 18.08.99 - No Default VAT Code line in the INI file !!! *}
    If (Not ValidCheck) then
    begin
      VATcode:=ExSyss.DefVAT;
      ValidCheck:=(((VATCode<>VATICode) and (VATCode In VATSet))
                 or (LineTot=0) or (Payment=DocPayType[SRC]));

    end; {if..}

    {* 30.11.2000 - If Payment line for Sales and Pur. leave VAT code as #0 *}
    If ((Inv.InvDocHed In [SRI,SRC,PPI,PPY]) and (Payment=DocPayType[SRC])) then
    begin
      VATCode:=#0;
      ValidCheck:=True;
    end;

    //AP : 05/01/2017 : ABSEXCH-17576 Toolkits - Payment Flag on SRC Line can be set to False
    If (Inv.InvDocHed In [SRC,PPY]) then
    begin
      ValidCheck :=  ValidCheck and (Id.Payment=DocPayType[SRC]);
      GenSetError(ValidCheck,30110,Result,ValidHed);
    end;

    //PR: 15/02/2016 v2016 R1 ABSEXCH-17292 Validate A/D vat codes
    if VATCode in ['A','D'] then
    begin
      ValidCheck := (Syss.Intrastat) and (Cust.EECMember);

      if ValidCheck then
      begin
        ValidCheck := (VATCode = 'A') and (Inv.InvDocHed in PurchSplit - [PPY, PBT]) or
                      (VATCode = 'D') and (Inv.InvDocHed in SalesSplit - [SRC, SBT]);
        GenSetError(ValidCheck,30107,Result,ValidHed);
      end;
    end; //VATCode in ['A','D']

    {* Version 4.31 *}
    {* SSDUplift Check *}
    //PR 25/7/05 5.70 SSDUplift is used to store QtyWoff on SRN/PRN so check for doctype.
    //CJS 10/01/2014 - v7.0.8 - ABSEXCH-14775 - added [WOR] to excluded types
    if not (Inv.InvDocHed in [WOR] + StkRetSplit) then
    begin
      ValidCheck:=(SSDUplift>=0) and (SSDUplift<=100);
      GenSetError(ValidCheck,30116,Result,ValidHed);
    end;

    {* SSD Commodity Code Check *}

    //PR 5/3/03 SSD not used on adjs & tshs
    //PR 25/7/05 5.70 SSDUseLine used as BackToBack flag on SRN/PRN
    If (Not (Inv.InvDocHed In [ADJ, TSH] + StkRetSplit)) then
    begin
      //PR: 01/07/2016 v2016 R2 ABSEXCH-17637 Extend check so we only validate if Intrastat and ECMember
      If (SSDCommod <> '') and IntrastatEnabled and Cust.EECMember then
      begin
        // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
        Val(SSDCommod, TmpSSD, ErrSSDCode);
        ValidCheck := (ErrSSDCode=0) and ((Length(SSDCommod) = 8) Or (Length(SSDCommod) = 10));
        GenSetError(ValidCheck,30117,Result,ValidHed);
      end; {if..}
    end;

      {* Check GL default currency *}
      //PR 29/03/2006 On description lines where NomCode = 0, Nom is still pointing at last
      //GL code, so have added check for NomCode = 0 before checking GL currency
      If (Not (Inv.InvDocHed In StkADJSplit)) and (NomCode <> 0) then
      begin
  Profiler.StartFunc('ValidateEachTL - Check GL Currency');
        ValidCheck:=Check_GLCurr(Inv,Id,0);
        GenSetError(ValidCheck,30118,Result,ValidHed);
  Profiler.EndFunc('ValidateEachTL - Check GL Currency');
      end; {if..}


    {* v4.31 Check CVat Inc. Flag *}
    If (VATCode=VATICode) then
    begin
      ValidCheck:=(VATIncFlg In VATSet-VATEqStd);
      GenSetError(ValidCheck,30119,Result,ValidHed);
    end; {if..}

    (* v500 Extra validation for WOP *)
    //PR 6/11/2001
    if (Inv.InvDocHed in WOPSplit) then
    begin
      if LineNo = 1 then
      begin
        //Check that stock item is BOM
        ValidCheck := Stock.StockType = StkBillCode;

        GenSetError(ValidCheck, 30123, Result, ValidHed);

        //Check that Qty Req (QtyMul field) <> 0
        ValidCheck := QtyMul > 0;

        GenSetError(ValidCheck, 30124, Result, ValidHed);

      end;

    end;

    //PR 25/7/05 5.70 Check that qty repaired + qty written off is not more than qty returned
    if Inv.InvDocHed in StkRetSplit then
    begin
      ValidCheck := Qty >= QtyDel + QtyWOff + QtyPWoff + SSDUplift;
      GenSetError(ValidCheck, 30130, Result, ValidHed);
    end;

Profiler.StartFunc('ValidateEachTL - Check LineNo');
    if (Mode = 0) and (SMode = B_Insert) then
    begin
      ValidCheck := (AllowZeroLineNos {and (AbsLineNo = 0)}) or AddExistingLineNo(AbsLineNo);
      GenSetError(ValidCheck, 30131, Result, ValidHed);
    end;
Profiler.EndFunc('ValidateEachTL - Check LineNo');

    //PR: 09/09/2009 EC Service fields
    if (Result = 0) and SyssVAT^.VATRates.EnableECServices then
    begin
      if ECService then
      begin
        //ValidServiceLine checks that Account, Transaction and Line are valid for Service
        if ValidServiceLine(Inv, ID, Cust, Result) then
        begin
          //Validate Service Dates
          if not ValidServiceDate(ServiceStartDate) then
            Result := 30134;
          if not ValidServiceDate(ServiceEndDate) then
            Result := 30135;

          if Result = 0 then
          begin
            if ServiceStartDate > ServiceEndDate then
              Result := 30136;
          end;

        end;
      end; //If service line
    end; //if SyssVAT^.VATRates.EnableECServices

    //PR: 03/08/2012 ABSEXCH-12746 Check that we're not trying to set pick qty if
    //customer on hold (insert only - updates are handled in CheckIdRecordExists
    //where we've got a copy of the existing record for comparison

    //PR: 30/10/2013 ABSEXCH-14592 Allow picking if Transaction is authorised
    if (SMode <> B_Update) and (IdDocHed = SOR) and AccountOnHold(Cust) and not TransactionIsAuthorised(Inv.HoldFlg) then
    begin
      ValidCheck := ZeroFloat(Id.QtyPick);
      GenSetError(ValidCheck, 30144, Result, ValidHed);
    end;

    //PR: 20/01/2016 ABSEXCH-17112 v2016 R1 Validate Nature of Transaction Code

    //PR: 09/02/2016 v2016 R1 ABSEXCH-17264 Allow valid intrastat fields to be set regardless
    //PR: 01/07/2016 v2016 R2 ABSEXCH-17637 Remove validation according to agreed rules
    if IntrastatEnabled and Cust.EECMember then
    begin
        ValidCheck := (Trim(tlIntrastatNoTC) = '') or (IntrastatSettings.IndexOf(stNatureOfTransaction,
                                                   ifCode, tlIntrastatNoTC) >= 0);
        GenSetError(ValidCheck, 30146, Result, ValidHed);

        ValidCheck := (Trim(SSDCountry) = '') or (SSDCountry = 'QR') or
                      ValidCountryCode (ifCountry2, SSDCountry); //PR: 27/09/2016 ABSEXCH-17721 Don't check for intrastat code here
        GenSetError(ValidCheck, 30147, Result, ValidHed);
    end;



  end; {with..}
  Profiler.EndFunc('ValidateEachTL');
end; {VAlidateEachTL..}



Function CheckIdRecordExists(Var IdUpdateStat :  Byte; Mode : Byte)  :  Integer;
Var
  FoundOK,
  ValidCheck,
  ValidHed     :  Boolean;
  KeyChk,
  KeyF         :  Str255;

  DelvQty      :  Double;
  TmpId,
  TmpId2        :  IDetail;

begin

  Result:=0;
  ValidCheck:=BOn;
  ValidHed:=BOff;

  IdUpdateStat:=1; { As a New Record }
  Fillchar(TmpId,SizeOf(TmpId),#0);

  With Id do
  begin

    KeyF:=FullIdKey(FolioRef,ABSLineNo);
    KeyChk:=KeyF;

    TmpId2 := Id;
    SetSplitPackStockDetails;
    TmpId:=Id;  {New Id information }

    Fillchar(Id,SizeOf(Id),#0);

    Status:=Find_Rec(B_GetEq,F[IdetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,KeyF);
    FoundOk:=(StatusOk) and (TmpId.FolioRef=Id.FolioRef) and (TmpId.ABSLineNo=Id.ABSLineNo);

    If (FoundOK) then
    begin
      IdUpdateStat:=2;  {As an exsting record }

      TmpId.QtyDel:=Id.QtyDel;
      TmpId.QtyWOff:=Id.QtyWOff;


      DelvQty := Id.QtyDel;
{      if Id.PrxPack and ID.ShowCase then
        UnmakeUnits(DelvQty, Id.QtyPack);}
      TmpId2.QtyDel := DelvQty;
      DelvQty := Id.QtyWOFF;
{      if Id.PrxPack and ID.ShowCase then
        UnmakeUnits(DelvQty, Id.QtyPack);}
      TmpId2.QtyWOFF := DelvQty;
      (* HM 11/06/01: Removed Account Code check to allow A/C Codes to be changed
      ValidCheck:=(CheckKey(TmpId.CustCode,Id.CustCode,AccLen,BOn));
      GenSetError(ValidCheck,30503,Result,ValidHed);  {30503 checked in 2 places ,Account Code must be the same }
      *)

      DelvQty:=Qty_Delivered(Id);  {* Total Outstanding Qty *}

      If (IdDocHed In [SOR,POR,SDN,PDN]) then
      begin
        //PR 17/12/01 Added LJVar to stockcodea to avoid mismatch
        ValidCheck:=((DelvQty=0) or (CheckKey(LJVar(TmpId.StockCode, StkLen),
                                       LJVar(Id.StockCode, StkLen),StkLen,BOn)));
        GenSetError(ValidCheck,30504,Result,ValidHed);  {StockCode must be the same}

       if IdDocHed in [SDN,PDN] then
        begin
          //PR: 20/05/2010 reset pick/woff quantities from existing records.
          TmpId.QtyPick := Id.QtyPick;
          TmpId.QtyPWoff := Id.QtyPWoff;
          //PR: 20/05/2010 For delivery notes, don't include woff quantities. Also don't check if qty hasn't been
          //changed, as there may be circumstances where editing dn in exchequer may lead to qty , QtyPicked
          ValidCheck:=(TmpId.Qty = 0) or (TmpId.Qty = Id.Qty ) or (Round_Up(TmpId.Qty,Syss.NoQtyDec) >=
                       Round_Up(Id.QtyPick,Syss.NoQtyDec));
          GenSetError(ValidCheck,30505,Result,ValidHed);  {New Qty must be valid }
        end
        else
        begin
          ValidCheck:=(TmpId.Qty = 0) or (Round_Up(TmpId.Qty,Syss.NoQtyDec) >=
                       Round_Up((Id.QtyDel+Id.QtyWOff+TmpId.QtyPick+TmpId.QtyPWOff),Syss.NoQtyDec));
          GenSetError(ValidCheck,30505,Result,ValidHed);  {New Qty must be valid }
        end;

        //PR: 03/08/2012 ABSEXCH-12746 Check that we're not trying to increase pick qty
        //when customer account is on hold.

        //PR: 30/10/2013 ABSEXCH-14592 Allow picking if Transaction is authorised
        if (IdDocHed = SOR) and AccountOnHold(Cust) and not TransactionIsAuthorised(Inv.HoldFlg) then
        begin
          ValidCheck := TmpId.QtyPick <= Id.QtyPick;
          GenSetError(ValidCheck, 30144, Result, ValidHed);
        end;


      end; {if SOR, POR...}

      //PR: 18/10/2010 If we have an override location on the header then we can't change the line location
      //PR: 23/09/2011 Added check for description lines with no value as we don't need to validate their location (ABSEXCH-11824)
      //PR: 19/06/2015 ABSEXCH-16577 Don't validate auto-generated CIS lines (Id.AutoLineType = 2)
      if AllowOverrideLocation(Id.IdDocHed, Id.LineNo) and (Trim(Inv.thOverrideLocation) <> '' ) and
         not ZeroFloat(InvLTotal(ID, True, 0)) and (Id.AutoLineType <> 2) then
      begin
        ValidCheck := Id.MLocStk = TmpId.MLocStk;
        GenSetError(ValidCheck,30506,Result,ValidHed);
      end;

    end; {if FoundOK..}
    If (Result=0) then
    begin
      {Assign ReadOnly fields}
      If (IdUpdateStat=1) then { As a New Record }
      begin
        if Mode = 0 then
          TmpId2.ABSLineNo:=Inv.ILineCount
        else
          TmpId2.ABSLineNo := NewAbsLineNo(Inv.ILineCount);
        //Inc(Inv.ILineCount);
      end {New Record = 1}
      else
      begin
        TmpId2.ABSLineNo:=Id.ABSLineNo;
        TmpId2.SOPLink:=Id.SOPLink;
        TmpId2.SOPLineNo:=Id.SOPLineNo;
        TmpId2.SerialQty:=Id.SerialQty;   { 05.09.2000 - added, otherwise loose the SerialQty }
        if Mode = 0 then
          AddExistingLineNo(Id.ABSLineNo);
      end; {Existing Record = 2}

    end; {if Result=0 ..}

    Id:=TmpId2;

  end; {with Id..}

end; {CheckIdRecordExists..}



{ ====== Process SetUp File ====== }

Function  Validate_Lines(    Mode       :  Byte;
                             LineChk    :  LongInt;
                         Var ImpVariance:  Double;
                             P          :  Pointer;
                             SMode      :  SmallInt;
                             EditNo     :  Byte)  :  Integer;


Var
  NewIdRec,
  ValidHed,
  ValidCheck,
  VJActual       :  Boolean;

  LineDir,
  TmpXRate,
  ImpBase,
  LineNET,
  LineDisc        :  Double;
  LineVat         :  Double;

  RecSeg,RecOfs,
  RecPos,
  FileRecNo      :  LongInt;

  ExIdRec        :  TBatchTLRec;

  IdUpStat,                    { Update Status }
  TmpJAType,
  TmpCurrCharge :  Byte;       { both for Job Actual Rec. JAType }
  TmpChargeType :  SmallInt;   { for Job Rec's ChargeType }

  KeyF          :  Str255;

  TmpLineNet : Double;
  Tempdouble : Double;
  {$IFDEF COMTK}
  MBDLineNoAdjustment : Integer; //If we're adding MultiBuy description lines we need to adjust following line numbers
  {$ENDIF}

Begin
  Profiler.StartFunc('Validate_Lines_' + IntToStr(Mode));
  bHasPurchaseServiceLine := False;
  HiddenLinesDeleted := False;
  VatNeededOnNom := False;
  ValidHed:=BOn;  ValidCheck:=BOff;

  LineNET:=0;
  LineDisc := 0;
  ImpBase:=0;
  ImpVariance:=0;
  TmpXRate:=0;
  LineDir:=0;
  Result:=0;
  LineVat := 0;

  HeaderCost:=0;
  HeaderWeight:=0;

  FileRecNo:=1;     {* Inc() is before end of loop *}
  TLLineNo:=1;

  {$IFDEF COMTK}
  MBDLineNoAdjustment := 0;
  {$ENDIF}

  // HM 13/08/01: Re-Initialised the Line Type Totals as this routine is called
  //              twice which was causing the Line Type Totals to be doubled.
  FillChar (Inv.DocLSplit, SizeOf (Inv.DocLSplit), #0);

  If (P<>Nil) then
  Begin
    //PR: 09/09/2009 EC Service fields - we need to check if we have Purchase Trans with a Service Line on it.
    if (Inv.InvDocHed in PurchSplit - [PPY, PBT]) and Cust.EECMember and SyssVAT^.VATRates.EnableECServices
        and (Inv.SSDProcess = #32) then
    begin
      while (FileRecNo<=LineChk) and not bHasPurchaseServiceLine do
      begin
        FillChar(ExIdRec,SizeOf(ExIdRec),#0);

        RecPos:=LongInt(P)+( Pred(FileRecNo)*SizeOf(ExIdRec));
        Move(Pointer(RecPos)^,ExIdRec,SizeOf(ExIdRec));

        if WordBoolToBool(ExIdRec.tlECService) and not (ExIdRec.VatCode in ['3','4','A','D']) then
          bHasPurchaseServiceLine := True;

        inc(FileRecNo);
      end;
    end;

    //PR: 09/09/2009 - if we have a purchase service line then
    //need to blank out VAT values in header - they'll be re-added in ExInvLineToId
    if bHasPurchaseServiceLine then
    begin
      Inv.InvVat := 0;
      FillChar(Inv.InvVATAnal, SizeOf(Inv.InvVatAnal), 0);
    end;
    //Reset file rec counter to start again
    FileRecNo := 1;

    While (Result=0) and (FileRecNo<=LineChk) do
    Begin

      FillChar(ExIdRec,SizeOf(ExIdRec),#0);

      {* using Ptr Position *}
    {$IFDEF WIN32}
      RecPos:=LongInt(P)+( Pred(FileRecNo)*SizeOf(ExIdRec));
      Move(Pointer(RecPos)^,ExIdRec,SizeOf(ExIdRec));
    {$ELSE}
      RecSeg:=Seg(P^);
      RecOfs:=Ofs(P^);
      RecOfs:=RecOfs + ( Pred(FileRecNo)*SizeOf(ExIdRec) );
      Move(Ptr(RecSeg,RecOfs)^,ExIdRec,SizeOf(ExIdRec) );
    {$ENDIF}

      //PR 20/01/03 BOM Line on WOR must be Line No 1
      if (Inv.InvDocHed = WOR) and (TLLineNo = 1) then
        ExIdRec.LineNo := 1;

      {* From External TLRec to Id Record *}
      Result:=ExInvLineToId(ExIdRec,SMode);

{      if (Mode = 1) and(SMode = B_Update) then
      begin
        if Id.Discount3 <> 0.00 then
        begin
          if Id.Discount3Chr = '%' then
            TTDValue := Id.Discount3
          else
            TTDValue := TTDValue + (Id.Discount3 * Id.Qty * Id.QtyMul);
          TTDFlag := Id.Discount3Chr;
        end;
      end;}


      If (Result=0) then
      With Id do
      Begin

        If (SMode=B_Update) then
        begin
          {* Check Id record exists and other validations *}
          Result:=CheckIdRecordExists(IdUpStat, Mode);

        end; {If SMode=B_Update..}

        {* Validate Each TL line *}
        {PR 26/06/2008 Change to only validate once in order to improve SQL performance.}
        If (Result=0) {and (Mode = 0)} then
          Result:=ValidateEachTL(Mode,SMode, ImpVariance,LineDir,LineNet,
                                 TmpJAType,TmpCurrCharge,
                                 TmpChargeType,VJActual, LineDisc, LineVat);

        {$IFDEF COMTK}
         if AllowCtrlGLs then
           Result := 0;
        {$ENDIF}

        If (Result=0) and (Mode=1) then
        begin

          If (Inv.InvDocHed In PSOPSet) and (Mode = 1) then {* Calculate how much of the order remains O/S *}
            Inv.TotOrdOS:=Inv.TotOrdOS+InvLOOS(Id,BOn,0);


          {* For TSH, total Qty = TotalInvoiced *}
          If (Inv.InvDocHed In TSTSplit) and (Mode=1) then
            Inv.TotalInvoiced:=Inv.TotalInvoiced + {TmpQty}Round_Up(ID.Qty,Syss.NoQtyDec);

          Id.DLLUpdate:=EditNo;

          If ((SMode=B_Insert) or ((SMode=B_Update) and (IdUpStat=1))) then
          begin

            {$IFDEF COMTK}
            if LineNo <> RecieptCode then //PR: 09/07/2009 this was also incrementing LineNos on SRI Payment Lines - D'Oh!
               LineNo := LineNo + MBDLineNoAdjustment;
            Inv.ILineCount := Inv.ILineCount + MBDLineNoAdjustment;
            {$ENDIF}
            Result:=Store_EId;  { Update Stock and Store Id line }

            {$IFDEF COMTK}
            if (Result = 0) and (ID.Discount2 > 0) then
              MBDLineNoAdjustment := MBDLineNoAdjustment + (2 * AddMultiBuyDescriptionLines);
            {$ENDIF}


            //PR: 18/03/2009 Added check for In Location ADJ Lines
            if (Result = 0) and AddInLocationAdjLines then
              Result := AddInLocLine;

            If ((Result=0) and (VJActual)) then
              Result:=Store_JobActual(TmpJAType,TmpCurrCharge,TmpChargeType);
          end {if B_Insert..}
          else
            {Existing Record }
            If ((SMode=B_Update) and (IdUpStat=2)) then
            begin
              //PR 8/01/03 - if line already exists then we need to delete any existing job actual for it
              Delete_JobAct(Id);
              Result:=Update_EId;
              If ((Result=0) and (VJActual)) then
                Result:=Store_JobActual(TmpJAType,TmpCurrCharge,TmpChargeType);
            end; {if an Existing Record ..}

        end; {if Result=0 and Mode=1 ..}

      end; {if..}

      If (Result<>0) then
      begin
        ExIdRec.RtnErrCode:=Result;
        {$IFDEF WIN32}
          RecPos:=LongInt(P)+( Pred(FileRecNo)*SizeOf(ExIdRec));
          Move(ExIdRec,Pointer(RecPos)^,SizeOf(ExIdRec));
        {$ENDIF}
      end; {if..}


      Inc(FileRecNo);
      Inc(TLLineNo);

    end; {While..}

    {* Validate Total Fields *}
    //PR: 02/07/2009 Remove check for Mode = 0 in line with 600.003 - it was losing transaction cost
//    If (Mode=0) then
    begin
      //PR 08/04/03 Set header discount amount from total of line discounts
      Inv.DiscAmount := LineDisc;
      {$IFDEF EN551}
{       if (Inv.InvDocHed = NMT) and (VatNeededOnNOM) then
       begin
         Inv.InvNetVal := LineNet;
         Inv.InvVat := LineVat;
       end;}
      {$ENDIF}
      If (ExSyss.MCMode) and (Inv.InvDocHed In RecieptSet{+NomSplit}) then {* Convert to base equiv *}
      begin
        //PR 3/2/03 Wasn't taking xrate from inv header when use ex currency set to off
        if not ExSyss.UseExCrRate then
        begin
          if not UseCoDayRate then
            TmpXRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency)
          else
            TmpXRate := Inv.CXRate[UseCoDayRate];
        end
        else //use currency from enterprise
          TmpXRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency);

        {ImpBase:=Round_Up(Conv_Curr(Inv.InvNetVal,Inv.CXRate[UseCoDayRate],BOff),2)}
//        TmpXRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency);
        {* 02.02.99 Added new parameter 0 for new Conv_TCurr function *}
//        ImpBase:=Round_Up(Conv_TCurr(Inv.InvNetVal,TmpXRate,Inv.Currency,0,BOff),2);
        ImpBase:=Round_Up(Conv_TCurr(Inv.InvNetVal - Inv.DiscAmount,TmpXRate,Inv.Currency,0,BOff),2);
      end
      else
      begin
//          ImpBase:=Round_Up(Inv.InvNetVal,2);
//Showmessage(FloatToStr(Inv.InvNetVal));
//Showmessage(FloatToStr(Inv.DiscAmount));
        ImpBase:=Round_Up(Inv.InvNetVal - Inv.DiscAmount,2);
      end;

      {$IFDEF COMTK}
      if not (Inv.InvDocHed in BatchSet) then
      begin
      {$ENDIF}
{        TmpLineNet := LineNet;              }
        if (Inv.InvDocHed in NomSplit) and VatNeededOnNOM then
        begin
{          TmpLineNet := TmpLineNet + LineVat;}
          ValidCheck := (Round_Up(LineNet - ImpBase, 2) = 0) and
                        (Round_Up(ImpBase + LineVat, 2) = 0);
        end
        else
          ValidCheck:=(Round_Up(LineNet,2)=Round_Up(ImpBase,2));

        //PR 04/09/2006 - Remove validation for ICE
        {$IFDEF COMTK}
        if AllowCtrlGls then
          ValidCheck := True;
        {$ENDIF}

        GenSetError(ValidCheck,30109,Result,ValidHed);
      {$IFDEF COMTK}
      end
      else
        ValidCheck := True;
      {$ENDIF}

      {* For NOM - 13.04.2000 *}

      If (Inv.InvDocHed In NomSplit) {$IFDEF EN551} and not VatNeededOnNOM {$ENDIF}then
        ValidCheck:=(Round_Up(LineNet,2)=0.00) and (Round_Up(ImpBase,2)=0);

      GenSetError(ValidCheck,30121,Result,ValidHed);

     If (ExSyss.MCMode) then
      begin
        if not ExSyss.UseExCrRate then
        begin
          if not UseCoDayRate then
            TmpXRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency)
          else
            TmpXRate := Inv.CXRate[UseCoDayRate];
        end
        else //use currency from enterprise
          TmpXRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency);
      end
      else
        TmpXRate := 1; //PR 17/01/2008 TmpXRate was being left as 0 for SC systems.

      TempDouble := Round_Up(Conv_TCurr(ITotal(Inv){$IFDEF COMTK} - GlobVBDValue - GlobVBDVAT  -
                                     Calc_PAmount(ITotal(Inv), TTDValue, TTDFlag){$ENDIF},
                                              TmpXRate,Inv.Currency,0,BOff),2);
                                              
      //PR: 02/04/2012 Removed change to keep rounding errors in sync with Exchequer.
      //PR: 28/02/2012 Change to convert LineDir at this point to avoid rounding errors in comparision
      //with inv total ABSEXCH-12050
//      LineDir := Round_Up(Conv_TCurr(LineDir, TmpXRate,Inv.Currency,0,BOff),2);
      ValidCheck:=((Not (Inv.InvDocHed In DirectSet)) or (Round_Up(LineDir,2)=TempDouble));

      GenSetError(ValidCheck,30110,Result,ValidHed);

      { 25.09.2000 - Added to calculate Header Total Cost }

      if Result = 0 then
      begin
        {$IFDEF EN551}
          if (Inv.InvDocHed = NMT) and VatNeededOnNOM then
          begin
            ValidCheck := Inv.NOMVATIO in ['I','O'];

            GenSetError(ValidCheck,30225,Result,ValidHed);
          end;
        {$ENDIF}

        //PR: 30.4.02 - allow fields to go through ok for heinz import
        if not ExSyss.AllowTotCost and not (Inv.InvDocHed in JAPSplit) then
          Inv.TotalCost := HeaderCost;
        if not ExSyss.AllowTotWeight then
          Inv.TotalWeight := HeaderWeight;
      end;

    end; {If Mode=0 , Total Check ....}

   end
   else
     Result:=32766;
  Profiler.EndFunc('Validate_Lines_' + IntToStr(Mode));

end; {Proc..}


{ ====== Function to Store Doc Headers ======= }

Function Store_ExDoc(SMode  :  SmallInt)  :  Integer;

Const
  Fnum     =  InvF;
  Keypath  =  InvFolioK;
var
  Vt           :  VATType;
  {$IFDEF COMTK}
  ValidCheck, ValidHed   : Boolean;
  ExLocal      :  ^TdExLocal;
  {$ENDIF}
Begin
  Result := 0;
  {$IFDEF COMTK}
  //Check that TTD|VBD enabled
  if ((SMode = B_Insert) or (TTDValue > 0)) and (Syss.EnableTTDDiscounts or Syss.EnableVBDDiscounts)
  {$IFDEF IMPV6}
   and ExSyss.ImpUseVBD //PR: 23/06/2009 Added new field/check for Importer & Advanced Discounts
  {$ENDIF}
  then
  begin
    //Need to increment LineCount as this will be used for line number of Description line
    Inc(Inv.ILineCount);
    TTDHelper := TTTDTransactionHelper.Create;
    Try
      if (SMode=B_Insert) then
        TTDHelper.TransactionMode := tmAdd
      else
        TTDHelper.TransactionMode := tmEdit;

      if TTDValue > 0 then //TTD has been applied
      begin
        TTDHelper.ApplyTTD := True;
        TTDHelper.DiscountAmount := TTDValue;
        if TTDFlag = '%' then
        begin
          TTDHelper.DiscountChar := TTDFlag;
          TTDHelper.DiscountAmount := TTDHelper.DiscountAmount * 100;
        end
        else
          TTDHelper.DiscountChar := #0;
      end;

      //If no TTD Value then we still want to call ApplyDiscounts to pick up any VBDs.
      if (TTDValue > 0) or Syss.EnableVBDDiscounts then
      begin
        ValidCheck := TTDHelper.ApplyDiscounts(nil, nil, Inv);

        //PR: 18/06/2013 Removed setting result, as it is not valid here (and was ignored anyway.)
        //GenSetError(ValidCheck,30231,Result,ValidHed);

        //If we've added TTD or VBD then we need to recalculate the header totals
        if ValidCheck then
        begin
          New(ExLocal, Create);
          Try
            CalcInvTotals(Inv, ExLocal^, not Inv.ManVAT, True);
          Finally
            Dispose(ExLocal);
          End;
        end;
      end;
    Finally
      FreeAndNil(TTDHelper);
    End;
  end;
  {$ENDIF}
  With Inv do
  Begin
    Set_DocAlcStat(Inv);

    //PR 21/7/06 - VatPostDate wasn't being set where needed
    if (InvDocHed = NMT) and VAT_CashAcc(SyssVAT.VATRates.VATScheme) and VatNeededOnNom then
    begin
      VATPostDate:=SyssVAT.VATRates.CurrPeriod;

      CalcInvVatTotals(Inv, not Inv.ManVAT);

      Settled:=0.0; CurrSettled:=0.0;
      For VT:=VStart to VEnd do
        CurrSettled:=CurrSettled+Round_Up(InvNetAnal[Vt],2);

      CurrSettled:=Round_Up(CurrSettled+InvVAT,2)*DocNotCnst;
      Settled:=CurrSettled; {* Its all at base currency anyway *}
    end;

//    ILineCount:=ILineCount+2; {30.09.99 - not to get duplicate ABSLineNo }
//PR: 24/07/02 Set TimeCreate and TimeChange fields when saving transaction
    If (SMode=B_Insert) then
    begin
      Inv.TimeCreate := TimeNowStr;
      //PR: 26/07/2013 ABSEXCH-14486 Moved below so it takes effect before calling Calc_CISTax
      //PR: 10/03/2014 ABSEXCH-15089 The fix above for ABSEXCH-14486 meant that ILineCount was only
      //                             set correctly on Purchase Transactions - re-instate this one as well
      //                             to cover all transactions.
      if HighLineNo > ILineCount then
        ILineCount := HighLineNo + 2
      else
        ILineCount := ILineCount + 2;

      Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

      //PR: 28/10/2011 v6.9
      if Result = 0 then
        AuditNote.AddNote(anTransaction, Inv.FolioNum, anCreate);
    end
    else
    If (SMode=B_Update) then
    begin
      ILineCount:=ILineCount+2; {30.09.99 - not to get duplicate ABSLineNo }
      Inv.TimeChange := TimeNowStr;
      Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

      //PR: 28/10/2011 v6.9
      if Result = 0 then
        AuditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);
    end;

  end; {With..}


end; {Store_ExDoc..}

{ ======= Function to Return Special Order based Run No. ========= }

Function Set_OrdRunNo(DocHed   :  DocTypes;
                      AutoOn,
                      Posted   :  Boolean)  :  LongInt;

Var
  Lnum  :  LongInt;

Begin

  Lnum:=0;

  If (DocHed In PSOPSet) then
  Begin
    If (DocHed In SalesSplit) then
      LNum:=OrdUSRunNo-Ord(AutoOn)-(2*Ord(Posted))
    else
      LNum:=OrdUPRunNo-Ord(AutoOn)-(2*Ord(Posted));
  end
  else //PR 11/12/01 - addition for WOP
  if (DocHed in WOPSplit) then
  begin
    if DocHed = WOR then
      LNum := WORUPRunNo - (2*Ord(Posted))
    else
      LNum := WINUPRunNo - (2*Ord(Posted));
  end
  else
  if DocHed in JAPSplit then
  begin
    Case DocHed of
      JCT : LNum := JCTUPRunNo;
      JST : LNum := JSTUPRunNo;
      JPT : LNum := JPTUPRunNo;
      JPA : LNum := JPAUPRunNo;
      JSA : LNum := JSAUPRunNo;
    end;

  end;


  Set_OrdRunNo:=Lnum;

end; {Func..}

{ ====== Procedure to Setup New Doc with Folio Etc ======= }

Function Set_ExDoc(ImpVariance  :  Real)  :  Integer;
Var
  TmpS  :  Str20;

Begin
  TmpS:='';
  Result:=0;

  With Inv do
  Begin
    {* Closed on 16.11.98 to use the new SetNextDocNos fumction ...*}
    (*
    If (ExSyss.OverWORef) then
    Begin
      Result:=FullDocNum(InvDocHed,BOn,DocLen,TmpS);
      If (Result=0) then
        OurRef:=TmpS;
    end; {if..}

    If (Result=0) then
    Begin
      If (Not (InvDocHed In QuotesSet+PSOPSet+StkAdjSplit)) then
        Result:=GetNextCount(FOL,BOn,BOff,0,FolioNum)
      else
        Result:=GetNextCount(AFL,BOn,BOff,0,FolioNum);
    end; {if..}
    *)

    {* Get next OurRef and FolioNum, If ExSyss.OverWORef is OFF, just get the Folio No only *}
    {$IFDEF COMTK}
    if RunNo <> -2 then
    {$ENDIF}
    SetNextDocNos(Inv,BOn,ExSyss.OverWORef);

    If (InvDocHed In SalesSplit+PurchSplit) then
      CustSupp:=TradeCode[(InvdocHed In SalesSplit)];

    If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
      CustSupp:=Chr(Succ(Ord(CustSupp)));

    //AP : 05/01/2017 : ABSEXCH-14961 Imported JCT – Retention not updating JCT
    If (InvDocHed In JAPJAPSplit) then 
      CustSupp:='J'
    else
    if (InvDocHed in JAPSplit-JAPJAPSplit) then
      CustSupp := 'K';  //find constant for this

    //PR: 15/07/2010 CustSupp flag wasn't getting set on returns, meaning they didn't show up in customer/supplier returns ledger
    if InvDocHed in StkRetSplit then
      CustSupp := Ret_CustSupp(InvDocHed);

    if InEBusinessMode then
      RunNo := 0
    else
    {$IFDEF COMTK}
    if (RunNo <> -2) and (RunNo <> -10) then
    {$ENDIF}
      RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);

    if InvDocHed = PRN then
      RunNo := PRNUPRunNo
    else
    if InvDocHed = SRN then
      RunNo := SRNUPRunNo;


    NLineCount:=1;
    ExternalDoc:=Not ExSyss.AllowEdit;
    {$IFDEF COMTK}
    if (RunNo = -2) or (RunNo = -10) then
      NomAuto := BOff
    else
    {$ENDIF}
    NomAuto:=BOn; {* Non Autodaybook item *}

    If (InvDocHed In DirectSet) then
    Begin
      TotalInvoiced:=ConvCurrITotal(Inv,BOff,BOn,BOn){$IFDEF COMTK} - GlobVBDValue - GlobVBDVAT{$ENDIF};

      Settled:=TotalInvoiced*DocCnst[InvDocHed]*DocNotCnst;

      CurrSettled:=ITotal(Inv)*DocCnst[InvDocHed]*DocNotCnst;  {**** Full Currency Value Settled ****}

      CXRate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];
      SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }

    end
    else
      If (InvDocHed In RecieptSet) then
      Begin

        if not AllowCtrlGLs then
          TotalInvoiced:=ConvCurrITotal(Inv,BOff,BOn,BOn);

        //PR 04/09/2006 Allow TotalReserved through from tk rec for ICE
        {$IFDEF COMTK}
        if not AllowCtrlGLs or (Round_Up(TotalReserved, 2) = 0) then
        {$ENDIF}
        begin
          if not AllowCtrlGLs then
            TotalOrdered:=ConvCurrITotal(Inv,BOff,BOn,BOff);

          If (ExSyss.MCMode) then
          Begin
            TotalReserved:=ImpVariance;
            Variance:=ImpVariance;
          end;
        end;
      end;

  end; {With..}

end; {Proc..}


{ ====== Update/Edit - Procedure to Setup Doc with Folio Etc ======= }

Function Set_ExDocForUpdate(ImpVariance  :  Real;
                            OrgInv       :  InvRec )  :  Integer;
Var
  TmpS  :  Str20;

Begin
  TmpS:='';
  Result:=0;

  With Inv do
  Begin

    If (InvDocHed In SalesSplit+PurchSplit) then
      CustSupp:=TradeCode[(InvdocHed In SalesSplit)];

    If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
      CustSupp:=Chr(Succ(Ord(CustSupp)));

    //AP : 05/01/2017 : ABSEXCH-14961 Imported JCT – Retention not updating JCT
    If (InvDocHed In JAPJAPSplit) then
      CustSupp:='J'
    else
    if (InvDocHed in JAPSplit-JAPJAPSplit) then
      CustSupp := 'K';

    {RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);
    NLineCount:=1;}

    {* 4.31-Update *}
    RunNo:=OrgInv.RunNo;
    NLineCount:=OrgInv.NLineCount;
    FolioNum:=OrgInv.FolioNum;

    ExternalDoc:=OrgInv.ExternalDoc; {Not ExSyss.AllowEdit;}
    {$IFDEF COMTK}
    if (RunNo = -2) or (RunNo = -10) then
      NomAuto := BOff
    else
    {$ENDIF}
    NomAuto:=BOn; {* Non Autodaybook item *}

    If (InvDocHed In DirectSet) then
    Begin
      TotalInvoiced:=ConvCurrITotal(Inv,BOff,BOn,BOn){$IFDEF COMTK} - GlobVBDValue - GlobVBDVAT{$ENDIF};

      Settled:=TotalInvoiced*DocCnst[InvDocHed]*DocNotCnst;

      CurrSettled:=ITotal(Inv)*DocCnst[InvDocHed]*DocNotCnst;  {**** Full Currency Value Settled ****}

      CXRate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];
      SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }

    end
    else
      If (InvDocHed In RecieptSet) then
      Begin
        TotalInvoiced:=ConvCurrITotal(Inv,BOff,BOn,BOn);

        TotalOrdered:=ConvCurrITotal(Inv,BOff,BOn,BOff);

        If (ExSyss.MCMode) then
        Begin
          TotalReserved:=ImpVariance;
          Variance:=ImpVariance;
        end;
      end;
    {$IFDEF EN551}
    if InvDocHed = NMT then
      DllMiscU.CalcInvVatTotals(Inv, True);
    {$ENDIF}
  end; {With..}

end; {Proc..}

(*
{ =======  Routine to collect all invoice lines ===== }

Function Update_Stock(FolioN  :  Longint;
                      Fnum,
                      Keypath :  Integer)  :  Integer;
Var
  KeyS,
  KeyChk  :  Str255;
Begin
  KeyS:=FullNomKey(FolioN);
  KeyChk:=KeyS;
  Result:=0;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Result=0) do
  With Id do
  Begin
    If (Not EmptyKey(StockCode,StkLen)) and (StockCode[1]<>PayInCode) then
    Begin

      {07.07.99 - Stock_Deduct(Id,BOn,BOn,0);}
      Stock_Deduct(Id,Inv,BOn,BOn,0);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Result:=Status;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}
end;
*)

{ ======= Function to Return Psuedo Delivery Date on Orders ====== }

Function QUO_DelDate(DocHed :  DocTypes;
                     DDate  :  LongDate)  :  Str15;


Begin

  QUO_DelDate:=DocCodes[DocHed]+DDate;

end; {Func..}


{ For 4.31 - Update }

{* Update Stock before deleting the old TLs *}
procedure Stock_DeductB4Delete(TFolioNum  :  LongInt);
Var
  BOMKey,
  ChkKey,
  KeyS  :  AnyStr;
  Locked:  Boolean;
  StkFolio,
  LAddr :  LongInt;
  Rnum  :  Double;

Begin

  KeyS:=FullNomKey(TFolioNum);
  ChkKey:=KeyS;

  Status:=Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

  While (Status=0) and (CheckKey(ChkKey,KeyS,Length(ChkKey),BOn)) do
  Begin


    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,IdFolioK,IDetailF,BOn,Locked,LAddr);

    If (Ok) and (Locked) then
    Begin

      Stock_Deduct(Id,Inv,BOff,BOn,0);  { BOff = Reverse }

      If (Stock.StockType=StkBillCode) and (ExSyss.DeductBOM) and (Inv.InvDocHed In SalesSplit+StkadjSplit) Then
      begin
        Rnum:=0;
        StkFolio:=Stock.StockFolio;
        BOMKey:=FullIdKey(Inv.FolioNum,StkLineNo);
        {* Do reverse-stock-update and delete hidden TLs *}
        If (Id.IdDocHed In StkAdjSplit) then
          {* Need to confirm for parameter 1 or 0 ? *}
          Delete_StockLinks(BOMKey,IDetailF,Length(BOMKey),IdFolioK,BOff,Inv,1)
        else
          Delete_StockLinks(BOMKey,IDetailF,Length(BOMKey),IdFolioK,BOn,Inv,1);

      end; {if..}


    end; {if..}

    Status:=Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

  end; {while..}

end; {func..}

{* Validate Header Record *}
Function ValidateHeader(SMode  :  Integer;
                        OldInv :  InvRec)  :  Integer;

Var
  ECRec,
  ValidCheck,
  ValidHed     :  Boolean;

  td,tm,ty     :  Word{Integer};
  VT	       :  VATType;

  HedVAT       :  Double;

begin
  //PR: 29/01/2015 ABSEXCH-16096 Initialise PaymentsMade
  PaymentsMade := 0;

  Profiler.StartFunc('ValidateHeader');
  Result:=0;
  ECRec:=BOff;      { EC Account }
  HedVAT:=0;

  With Inv do
  begin

    ValidCheck:=((Not ExSyss.CheckDupli)
                 or (Not (CheckExsists(LJVar(YourRef,LogInLen),InvF,InvYrRefK))));

    GenSetError(ValidCheck,30200,Result,ValidHed);

    {* Add StkAdjSplit+TSTSplit *} //add wopsplit - see below
{    ValidCheck:=(InvDocHed In SalesSplit+PurchSplit+NomSplit+StkAdjSplit+TSTSplit+JAPSplit) or
                ((InvDocHed in WOPSplit) and WOPOn); //Leave WOP off until all implemented}

{    ValidCheck:=(InvDocHed In SalesSplit+PurchSplit+NomSplit-PSOPSet) or
                ((InvDocHed in PSOPSet - DeliverSet) and SPOPOn) or
                ((InvDocHed in StkAdjSplit) and StockOn) or
                ((InvDocHed in TSTSplit) and JBCostOn) or
                ((InvDocHed in WOPSplit) and WOPOn) or
                ((InvDocHed in JAPSplit) and JAPOn) or
                ((InvDocHed in StkRetSplit) and RetMOn);
 }
    if SMode = B_Insert then
      ValidCheck := CanAddTransType(InvDocHed)
    else
      ValidCheck := Inv.InvDocHed In [SOR,SDN,SIN,POR,PDN,PIN,ADJ,PCR,PQU,SQU,SCR,PJI,PJC,SJI,SJC,TSH,WOR,WIN
                               {$IFDEF COMTK},JPT, JCT, JST, JPA, JSA, PRN, SRN{$ENDIF}];


    GenSetError(ValidCheck,30201,Result,ValidHed);

    // CJS 2011-08-09 ABSEXCH-11265 - Cached data problem
    //PR: 01/09/2011 Added check that we're using SQL - otherwise it was giving an access violation on Pervasive systems.
    {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      SQLUtils.DiscardCachedData('CUSTSUPP.DAT');
    {$ENDIF}

    //PR: 17/09/2014  v7.x Order Payments - T102 if we've changed the customer code on an o/p order then
    // we need to use the original customer code for the Cust.acAllowOrderPayments check below
    if (SMode = B_Update) and (InvDocHed = SOR) and Syss.ssEnableOrderPayments and
       (CustCode <> OldInv.CustCode) then
          ValidCheck:=(CheckRecExsists(OldInv.CustCode,CustF,CustCodeK))
    else  //carry on as normal


    //PR 6/12/01 Extended for Works Order Processing. CustCode is optional
    //but if there is a custcode it must be valid customer.
    If ((ValidCheck) and (Not (InvDocHed In NomSplit+StkAdjSplit+TSTSplit+WOPSplit+BatchSet+[JPT]) or
                              ((InvDocHed in WOPSplit) and (Trim(CustCode) <> '')))) then
    Begin
      {* Account Code Check *}

      (* HM 11/06/01: Extended to allow Account Codes to be changed
      If (SMode=B_Update) then
      begin   { do not allow to change Account Code if line has SOPLink }
        ValidCheck:=CheckKey(OldInv.Custcode,Custcode,Length(OldInv.Custcode),BOn);
        GenSetError(ValidCheck,30503,Result,ValidHed);
      end; {if..}
      *)

      ValidCheck:=(CheckRecExsists(CustCode,CustF,CustCodeK));

      ValidCheck:=((ValidCheck) and (Cust.CustSupp=TradeCode[(InvDocHed In SalesSplit + WOPSplit + JAPSalesSplit + StkRetSalesSplit)]));

      GenSetError(ValidCheck,30202,Result,ValidHed);

      ECRec:=(ValidCheck) and (Cust.EECMember); { For SSDProcess Flag }

      // Account Status Check for trader
      // SSK 09/09/2016 2016-R3 ABSEXCH-17216: validity check for closed traders
      if ValidCheck then
      begin
        ValidCheck:= (Cust.AccStatus<>3);
        GenSetError(ValidCheck,30250,Result,ValidHed);
      end;
    end
    else
      CustCode:=LJVar('',AccLen);


    {$IFDEF COMTK}
    // CJS 2014-08-05 - v7.x Order Payments - T098 - new fields
    if (InvDocHed = SOR) and Syss.ssEnableOrderPayments and Cust.acAllowOrderPayments then
    begin
      thOrderPaymentElement := opeOrder;

      //PR: 28/01/2015 ABSEXCH-????? Allow OrderPaymentFlags to be set on edit as well as insert

      if SMode = B_Update then
      begin
        //PR: 16/09/2014  v7.x Order Payments - T101 Check that order value >= payments against order
        ValidCheck := not TransactionNeedsRefund;
        GenSetError(ValidCheck,30239,Result,ValidHed);

        //PR: 17/09/2014  v7.x Order Payments - T102
        //PR: 29/01/2015 ABSEXCH-16096 Check PaymentsMade variable
        if ValidCheck and (PaymentsMade > 0) then
          ValidCheck := (CustCode = OldInv.CustCode) and
                        (Currency = OldInv.Currency) and
                        (ManVAT = OldInv.ManVAT) and
                        (InvVAT = OldInv.InvVAT) and
                        CompareMem(@InvVATAnal, @OldInv.InvVATAnal, SizeOf(InvVATAnal));

        GenSetError(ValidCheck,30240,Result,ValidHed);
      end;
    end;
    {$ENDIF}
    { ----------------------------------- }

    {* Check Employeee Code - for TSH trans. *}
    If  (InvDocHed In TSTSplit) then
    Begin
      ValidCheck:=CheckRecExsists(JARCode+JAECode+LJVar(BatchLink,AccLen),JMiscF,JMK);
      GenSetError(ValidCheck,30210,Result,ValidHed);
      //PR: 26/01/2011 Store the employee record for a timesheet header, to allow correct checking of time rates on the lines.
      if ValidCheck then
        TSHEmployeeRec := JobMisc.EmplRec;
    end;
    { ---------------------------------- }
    { JobCode and AnalCode check for other Transaction Code - SIN, PIN etc..}

    If  ((Not (InvDocHed In TSTSplit)) and (Not ExSyss.JBIgnore)) then
    Begin
       ValidCheck:=(EmptyKey(DJobCode,JobCodeLen));

       If Not (ValidCheck) then
       Begin
         DJobCode:=FullJobCode(DJobCode);
         //PR: 10/11/2011 Added check that job isn't a contract. ABSEXCH-12125
         ValidCheck:=(CheckRecExsists(DJobCode,JobF,JobCodeK)) and (JobRec.JobType <> JobGrpCode);
         GenSetError(ValidCheck,30211,Result,ValidHed);
       end;

        //PR 10/11/2011 v6.9 Check for no transactions to closed jobs if switch set in ini file - was previously only
        //applied to timesheets. ABSEXCH-11607
        if ValidCheck and ExSyss.NoTranToClosedJob then
        begin
          ValidCheck := JobRec^.JobStat <> 5;

          GenSetError(ValidCheck,30234,Result,ValidHed);
        end;


       //PR: 01/11/2011 v6.9 Only validate Analysis Code if Job Code is populated ABSEXCH-12031
       if ValidCheck and not EmptyKey(DJobCode,JobCodeLen) then
       begin
         ValidCheck:=(EmptyKey(DJobAnal,JobCodeLen));

         If Not (ValidCheck) then
         Begin
           DJobAnal:=FullJobCode(DJobAnal);
           ValidCheck:=(CheckRecExsists(JARCode+JAACode+DJobAnal,JMiscF,JMK));
           GenSetError(ValidCheck,30212,Result,ValidHed);
         end;
       end; //if ValidCheck and not EmptyKey(DJobCode,JobCodeLen)
    end;

    { ---------------------------------- }

    {* Check Date *}

    {Old}DateStr(TransDate,Td,Tm,Ty);

    ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

    GenSetError(ValidCheck,30203,Result,ValidHed);

    //PR: 24/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015. Return new error code
    if ValidCheck then
    begin
      //EL uses settlement discount fields for other purposes on some non-Sales/Purchase trans,
      //so allow those through - DocTypeCanHaveSettlementDiscount function deals with identifying these.
      if DocTypeCanHaveSettlementDiscount(Inv.InvDocHed) then
      begin
        //Are any of the settlement discount fields populated? If so check whether they're allowed
        ValidCheck := (ZeroFloat(DiscSetl, 4) and (DiscDays = 0) and ZeroFloat(DiscSetAm) and not DiscTaken)
                       or
                       TransactionHelper(@Inv).SettlementDiscountSupported;
        GenSetError(ValidCheck, 30237, Result, ValidHed);
      end;
    end;

    //PR: 25/03/2015 v7.0.14 ABSEXCH-14705 Don't allow prompt payments on transactions dated < 01/04/2015
    ValidCheck := not (TransactionHelper(@Inv).SettlementDiscountSupported and PPDFieldsPopulated(Inv));
    GenSetError(ValidCheck, 30242, Result, ValidHed);

    //PR: 25/03/2015 v7.0.14 ABSEXCH-14705 validate ppd fields
    if ValidCheck and PPDFieldsPopulated(Inv) then
    begin
      //Percentage
      ValidCheck := (thPPDPercentage >= 0.0) and (thPPDPercentage < 1.0);
      GenSetError(ValidCheck, 30243, Result, ValidHed);

      // MH 30/06/2015 v7.0.14 ABSEXCH-16600: Modified validation to comply to Exchequer
      ValidCheck := (thPPDDays >= 0) and (thPPDDays <= 999);
      GenSetError(ValidCheck, 30244, Result, ValidHed);
    end; // if ValidCheck and PPDFieldsPopulated(Inv)

    {* Check Period/Yr *}
    //PR 14/7/04 - added check so that period on trans being updated is not changed
    If (ValidCheck) and (ExSyss.AutoSetPr) and (SMode <> B_UPdate) then
    Begin
      (* HM Updated Period Calculation to do same as Enterprise
      AcPr:=Fin_Pr(TransDate);
      AcYr:=TxlateYrVal(Fin_Yr(TransDate), BOn);
      *)
      SimpleDate2Pr(TransDate, AcPr, AcYr);
    end;

    ValidCheck:=((AcPr>=1) and (AcPr<=Syss.PrInYr));
    GenSetError(ValidCheck,30204,Result,ValidHed);

    ValidCheck:=((AcYr<>0));
    GenSetError(ValidCheck,30205,Result,ValidHed);


    {* Add Stk&TSTSplit, deleted [SRC,PPY] 18/04/2000 *}


    If (ValidCheck) and (Not (InvDocHed In NomSplit+StkAdjSplit+TSTSplit+JAPSplit)) then
    Begin
      {* Check Due Date *}
      //PR: 07/06/2017 v2017 R1 ABSEXCH-18720 Change to populate blank DueDate on all transactions
      if {(InvDocHed in OrderSet + RecieptSet) and }(Trim(DueDate) = '') then
        DueDate := TransDate;

      //PR 6/12/01 Check due date for wor/win transactions
      if not (InvDocHed in WOPSplit) then
      begin
        //PR: 03/05/2017 v2017 R1 ABSEXCH-18663 On Orders set blank DueDate
        //PR: 04/05/2017 v2017 R1 ABSEXCH-18667 Same for SRC/PPY
        if (InvDocHed in OrderSet + RecieptSet) and (Trim(DueDate) = '') then
          DueDate := TransDate;

      { 01.07.99 - To calculate DueDate with Payment Terms }
        If (UpperCase(DueDate)=DueDateSwitch) then
          DueDate:=CalcDueDate(TransDate,Cust.PayTerms)
        else
        begin
          {Old }DateStr(DueDate,Td,Tm,Ty);

          //AP : 24/03/2017 2017-R1 ABSEXCH-18045 : Toolkit Allows Transactions To Be Added With Invalid Due Dates
          ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and ((Ty>= 1900) and (Ty<=2050)) and ValidDate(DueDate));

        end; {if..}
      end
      else
      begin
        //WOP trans
        {Old }DateStr(DueDate,Td,Tm,Ty);

        //AP : 24/03/2017 2017-R1 ABSEXCH-18045 : Toolkit Allows Transactions To Be Added With Invalid Due Dates
        ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and ((Ty>= 1900) and (Ty<=2050)) and ValidDate(DueDate));

      end;
    end; {if..}

    //AP : 22/03/2017 2017-R1 ABSEXCH-18045 : Toolkit Allows Transactions To Be Added With Invalid Due Dates
    GenSetError(ValidCheck,30238,Result,ValidHed);

    {* Added on 06/05/98 *}

    If (InvDocHed In OrderSet) then
      BatchLink:=QUO_DelDate(InvDocHed,DueDate);

    {* changed from 4 to 11 on 10.06.97 *}
    {* Rate11 to Rate 18 in v4.31 *}
    For VT:=Standard to Rate18 do
      HedVAT:=HedVAT+InvVATAnal[VT];

    {* Check VAT Split *}

    {$IFDEF COMTK}
    if not (InvDocHed in BatchSet) then
    {$ENDIF}
    begin
      ValidCheck:=(Round_Up(HedVAT,2)=Round_Up(InvVAT,2));
      GenSetError(ValidCheck,30206,Result,ValidHed);
    end;

    {* Check Currency *}

    If (ExSyss.MCMode) then
    begin
      ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
      {$IFDEF COMTK}
       ValidCheck := ValidCheck or (AllowCtrlGls and (Currency = 0));
      {$ENDIF}
      {* 18.08.99 - Added to use Default Currency *}
      If (Not ValidCheck) then
      begin
        Currency:=ExSyss.DefCur;
        ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
      end;
    end
    else
      ValidCheck:=BOn;

    GenSetError(ValidCheck,30207,Result,ValidHed);

    If (ExSyss.MCMode) then {* Check Currency Rates *}
    Begin

     {* 06.01.99 - Added this condition when Euro conversion was tested
                    with EL's advice *}
      If (ExSyss.UseExCrRate) or not UseCoDayRate then {* OverWrite Currency Rates *}
      begin   //PR: 08/08/2011 ABSEXCH- 11705 - Don't overwrite Daily Rate for Company Rate system unless UseExCrRate is true.
        if ExSyss.UseExCrRate then
          CXrate[True]:=SyssCurr^.Currencies[Currency].CRates[True]; //Only overwrite Daily (VAT) Rate if overwrite is true
        CXrate[False]:=SyssCurr^.Currencies[Currency].CRates[False]; //Always overwrite Company rate if it's a Company Rate System
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end;

      {* 01.04.99 - Ent. v4.30a validates these fields *}
      VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;
      SetTriRec(Syss.VATCurr,UseORate,CurrTriR); { for 4.31 }

      OrigRates:=SyssCurr^.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,OrigTriR); { for 4.31 }

      ValidCheck:=(CXRate[BOn]<>0);
      GenSetError(ValidCheck,30208,Result,ValidHed);

      If (Not UseCoDayRate) then
      Begin
	ValidCheck:=(CXRate[BOff]<>0);
        GenSetError(ValidCheck,30209,Result,ValidHed);
      end;

      // HM 06/03/01: Added eBusiness Mode check - as 0 rate was causing problem posting from eBus into Ent
//      If (Not (Inv.InvDocHed In NomSplit)) And (Not InEbusinessMode) then
      //PR: 13/08/2010 Added extra transaction types for which company rate should not be set to zero
      If (Not (Inv.InvDocHed In SetCompanyRateSet)) And (Not InEbusinessMode) then
      begin
        CXRate[BOff]:=0;  {* Set to 0 eventualy regardless of stored value, as always left floating *}
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end;

    end
    else
    Begin
      Currency:=0;
      CXrate:=SyssCurr^.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
    end;

    {* Debtor/Creditor Control Nominal Code  *}
    If (CtrlNom<>0) then
    begin
      ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(CtrlNom)),NomF,NomCodeK));

      ValidCheck:=((ValidCheck) and (Nom.NomType In [CtrlNHCode])
                    and (CtrlNom<>Syss.NomCtrlCodes[Debtors])
                    and (CtrlNom<>Syss.NomCtrlCodes[Creditors]));

      GenSetError(ValidCheck,30213,Result,ValidHed);
    end
    else
    begin
      ValidCheck:=(CheckRecExsists(CustCode,CustF,CustCodeK));
      If (ValidCheck) and (Cust.DefCtrlNom<>0) then
      begin
        CtrlNom:=Cust.DefCtrlNom;
        ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(CtrlNom)),NomF,NomCodeK));

        ValidCheck:=((ValidCheck) and (Nom.NomType In [CtrlNHCode])
                      and (CtrlNom<>Syss.NomCtrlCodes[Debtors])
                      and (CtrlNom<>Syss.NomCtrlCodes[Creditors]));
        GenSetError(ValidCheck,30214,Result,ValidHed);

        {* 05.01.99 - 30215 is for TransDocHed Validation *}
      end;

    end; {if ..}

    {* Ver 4.31 validation *}
    {* Check SSDProcess *}
    ValidCheck:=BOn;
    
    //PR: 01/07/2016 v2016 R2 ABSEXCH-17637 Check intrastat as well
    If (ECRec) and IntrastatEnabled then
      ValidCheck:=(SSDProcess In [#0,#32,'T','P'])
    else
    begin  //PR: 01/08/2011 Follow Exchequer in setting SSDProcess according to whether Intrastat
           // is enabled in system setup. ABSEXCH-10503.
      if Syss.Intrastat then
        SSDProcess:=#32
      else
        SSDProcess := #0;
    end;
    GenSetError(ValidCheck,30216,Result,ValidHed);

    // HM 07/09/01 (v4.40/v5.00?): Added validation of new fields
    ValidCheck := (Tagged <= 99);
    GenSetError(ValidCheck,30218,Result,ValidHed);

    //PR 06/12/01 Added check for location in wop
    if (InvDocHed in WOPSplit) and ExSyss.UseMLoc then
    begin
      ValidCheck := CheckRecExsists(CostCCode+CSubCode[BOn] + LJVar(DelTerms, MLocLen), MLocF, MLK);

      GenSetError(ValidCheck, 30219, Result, ValidHed);
    end;

    {$IFDEF COMTK}
    if RunNo = -2 then
    begin
      //what checks do we need here?
      if AutoIncBy = 'D' then
      begin
        DateStr(UntilDate,Td,Tm,Ty);

        ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

        GenSetError(ValidCheck,30220,Result,ValidHed);
      end
      else
      begin
      {* Check Period/Yr *}


        ValidCheck:=((UnPr>=1) and (UnPr<=Syss.PrInYr));
        GenSetError(ValidCheck,30221,Result,ValidHed);

        ValidCheck:=((UnYr<>0));
        GenSetError(ValidCheck,30222,Result,ValidHed);
      end;
    end;

    if (InvDocHed in BatchSet) and (BatchNom <> 0) then
    begin
      ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(BatchNom)),NomF,NomCodeK));

      GenSetError(ValidCheck,30223,Result,ValidHed);
    end;
    {$ENDIF}

    //PR 23/01/2007 Added check that trans total doesn't go over customer's available credit
    if (InvDocHed = SOR) and (Syss.UseCreditChk and Syss.UseCRLimitChk) then
    begin                                                         //PR 18/06/07 - Allow authorised trans to go through
                                                                   //PR 11/04/08 - Change to WithinCreditLimit - see function
      ValidCheck := WithinCreditLimit(CustCode, Consolitotal(Inv), Consolitotal(OldInv), SMode = B_Update) or ((Inv.HoldFlg and 3) = 3);

      if Syss.StopBadDr then
        GenSetError(ValidCheck,30229,Result,ValidHed)
      else
      if not ValidCheck then
        HoldFlg := (HoldFlg and 168) or 6;
    end;

    //PR: 18/03/2009 Check added for valid InLocation if necessary
    if AddInLocationAdjLines then
    begin
      ValidCheck := CheckRecExsists(CostCCode+CSubCode[BOn] + LJVar(DelTerms, MLocLen), MLocF, MLK);

      GenSetError(ValidCheck,30230,Result,ValidHed);
    end;

    //PR: 04/02/2010 WeekMonth is only allowed to be 4 digits i.e. -999 to 9999
    ValidCheck := (thWeekMonth >= -999) and (thWeekMonth <= 9999);
    if ValidCheck then
      ValidCheck := (InvDocHed <> TSH) or ( (DiscDays >= -999) and (DiscDays <= 9999));

    GenSetError(ValidCheck,30231,Result,ValidHed);

    if AllowOverrideLocation(InvDocHed) then
    begin
      //Validate header override location
      ValidCheck:= (Trim(thOverrideLocation) = '') or (CheckRecExsists(MLocFixCode[True]+LJVar(thOverrideLocation,LocKeyLen),MLocF,MLK));
      GenSetError(ValidCheck,30232,Result,ValidHed);

      if SMode <> B_Insert then
      begin
        ValidCheck := thOverrideLocation = OldInv.thOverrideLocation;
        GenSetError(ValidCheck,30233,Result,ValidHed);
      end;
    end
    else
    begin
      if SMode = B_Insert then
        thOverrideLocation := StringOfChar(' ', LocKeyLen)
      else
        thOverrideLocation := OldInv.thOverrideLocation;
    end;

    ValidCheck := IsValidHoldFlag(HoldFlg);
    GenSetError(ValidCheck,30235,Result,ValidHed);

    //PR: 29/10/2013 ABSEXCH-14705  Validate thOriginator - either blank or valid Exchequer user
    //PR: 17/05/2016 ABSEXCH-17259 No longer validate thOriginator at Ian Randall's request
(*    if SMode = B_Insert then
    begin
      ValidCheck := (Trim(thOriginator) = '') or
                    CheckRecExsists(PassUCode + #0 + LJVar(UpperCase(thOriginator), 10), PwrdF, 0);
      GenSetError(ValidCheck,30236,Result,ValidHed);
    end; *)

    {$IFDEF COMTK}
     //PR: 27/11/2014 Order Payments
     // Validate Delivery Country if any part of the delivery address is set
     If (Trim(DAddr[1]) <> '') Or (Trim(DAddr[2]) <> '') Or (Trim(DAddr[3]) <> '') Or
        (Trim(DAddr[4]) <> '') Or (Trim(DAddr[5]) <> '') Or (Trim(thDeliveryPostCode) <> '') Then
       ValidCheck := (Trim(thDeliveryCountry) <> '') And ValidCountryCode (ifCountry2, thDeliveryCountry)
     Else
       ValidCheck := True;
     GenSetError(ValidCheck,30241,Result,ValidHed);
    {$ENDIF}

    //PR: 15/02/2016 ABSEXCH-17294/ABSEXCH-17295 v2016 R1 Validate Header Intrastat fields
    //  - only sales and purchase trans as fields are used for other things on ADJs, Returns, etc.
    //PR: 16/02/2016 v2016 R1 ABSEXCH-17309 Amend to allow default notc for non-ec member
    //PR: 01/07/2016 v2016 R2 ABSEXCH-17637 Remove validation according to agreed rules
    if (InvDocHed in PurchSplit + SalesSplit - [PPY, PBT, SRC, SBT]) then
    begin
      if IntrastatEnabled then
      begin
        if (Cust.EECMember) then
        begin
          if SystemSetup.Intrastat.isShowDeliveryTerms then
          begin
            ValidCheck := IntrastatSettings.IndexOf(stDeliveryTerms, ifCode, Trim(DelTerms)) >= 0;
            GenSetError(ValidCheck,30245,Result,ValidHed);
          end;

          //Nature of Transaction
          ValidCheck := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, IntToStr(TransNat)) >= 0;
          GenSetError(ValidCheck,30246,Result,ValidHed);

          //Transport Mode
          if SystemSetup.Intrastat.isShowModeOfTransport then
          begin
            ValidCheck := IntrastatSettings.IndexOf(stModeOfTransport, ifCode, IntToStr(TransMode)) >= 0;
            GenSetError(ValidCheck,30247,Result,ValidHed);
          end;
        end; //EEC member
      end;  //Intrastat
    end; //if (Syss.Intrastat) and (InvDocHed in PurchSplit + SalesSplit - [PPY, PBT, SRC, SBT])

    //AP 09/01/2018 GDPR - Toolkit DLL Support - Ex_StoreTrans : validation on TSH for Open Employee
      if ValidCheck then
      begin
        if (InvDocHed In TSTSplit) then
          ValidCheck := JobMisc.EmplRec.emStatus = emsOpen;
        GenSetError(ValidCheck,30251,Result,ValidHed);
      end;
  end; {with..}
  Profiler.EndFunc('ValidateHeader');
end; {ValidateHeader..}


{* ----------------------------------------------------------------------------
Check all Lines belong to the Header if the records were not updated, check & delete them *}

Function CheckIdLinesAgain(Var TInv      : InvRec;
                               TFolioNum : LongInt;
                               EditNo    : Byte;
                           Var LineFail  :  Integer) :  Integer;
Var
  KeyS,
  KeyChk    :  Str255;
  i         :  VatType;

  DeleId    :  IDetail;

  ValidCheck,
  ValidHed,
  CalcTotals,
  HasNoUpdateRec  :  Boolean;

  TmpLine   :  Array[1..3] of Double;

  TmpHead   :  Array[1..4] of Double;

  TmpVAnal  :  Array[VATType] of Double;        { Analysis of VAT Anal }

  TmpXRate  :  Double;


begin
  Result:=0; LineFail:=0;
  HasNoUpdateRec:=BOff;
  ValidCheck:=BOn;
  ValidHed:=BOff;
  CalcTotals:=BOn;

  { For Total Values }
  FillChar(TmpLine,SizeOf(TmpLine),#0);
  FillChar(TmpHead,SizeOf(TmpHead),#0);
  FillChar(TmpVAnal,SizeOf(TmpVAnal),#0);

  { Get the Id Lines by Folio Number. }
  KeyS:=FullNomKey(TFolioNum);

  KeyChk:=KeyS;

  //PR 8/11/2006 On Applications, retention lines have -3 lineno & deduction lines have -2 so we need to check for those
  if Id.IdDocHed in JAPSplit then
    KeyS := FullIdKey(TFolioNum, -3);

  Status:=Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With Id do
  Begin
    CalcTotals:=BOn;
//    CalcTotals:=BOff;
    { If Id.DLLUpdate No <> the current EditNo, this transaction has the line
      which has been }         //PR 8/11/2006 Added check for JSA, JPA which can have -ve linenos we want to delete.
    If (DLLUpdate<>EditNo) and ((LineNo > 0) or (Id.IdDocHed in JAPSplit)) then
    begin

      If (Not HasNoUpdateRec) then
        HasNoUpdateRec:=BOn;

      //PR 06/03/03: Added SDN &PDN to this check
      //PR 8/11/2006 Added JSA & JPA
      //PR 5/7/2007 Added TSH
      If (IdDocHed In [SOR,POR,SIN,PIN,PCR,PQU,SQU,SCR,PJI,PJC,SJI,SJC,SDN,TSH,PDN,JSA,JPA]) then begin

        {ValidCheck:=((QtyDel+QtyWOff)=0) and (SOPLink=0);}

        { 20.04.2000 - Added these 2 checkings which should be considered as
          Warning }
        {* If the line is linked to SOR or SDN, cannot be deleted *}
        If (TInv.InvDocHed In [SIN,PIN,SDN,PDN,PCR,PQU,SQU,SCR,PJI,PJC,SJI,SJC]) Then
          ValidCheck:=((SOPLink=0) and (SOPLineNo=0)) or
                      (Qty = 0)                       //PR 21/8/06 - Allow description lines to be deleted
                                                      //PR 11/07/05 - if InvDocHed not in set then valid check wasn't
                                                     // gettting reset
        else
          ValidCheck := BOn;

        GenSetError(ValidCheck,30700,LineFail,ValidHed);

        {* If the line has Delivered Qty, cannot be deleted *}
        If (TInv.InvDocHed In [SOR,POR]) and (ValidCheck) then
        Begin
          ValidCheck:=(QtyWOFF=0) and (QtyDel=0);
          GenSetError(ValidCheck,30701,LineFail,ValidHed);
        end;

        {GenSetError(ValidCheck,30599,Result,ValidHed); }
        If (ValidCheck) then
        begin
          CalcTotals:=BOff;

          DeleId:=Id;
          Status:=Delete_Rec(F[IdetailF],IdetailF,IdFolioK);
          If (Status=0) then
          begin
            if (TInv.InvDocHed <> TSH) then
              ReverseStockBalance(DeleId,TInv) {* Reverse Stock Balance for deleted record *}
            else
              Delete_JobAct(Id);
          end
          else
            CalcTotals:=BOn;

        end; {}
      end; {If SOR,POR..}
    end; {if..}

    If (CalcTotals) then
    begin
      //PR: 03/05/2011 This section recalculates the header totals for remaining lines, so if
      //any lines have been deleted, the totals are adjusted. However, Timesheets can have lines
      //in currency different to the header (which is always in base currency),
      //so need to treat them as a special case. ABSEXCH-11453/5
      if (Inv.InvDocHed = TSH) then
      begin
        if ExSyss.MCMode then
        begin
          if not UseCoDayRate then
            TmpXRate:=XRate(CXRate,UseCoDayRate,Currency)
          else
            TmpXRate := CXRate[UseCoDayRate];

          TmpLine[1] := Round_Up(Conv_TCurr(Qty*NetValue,TmpXRate,Currency,0,BOff),2);
        end
        else
          TmpLine[1] := Round_Up((Qty*NetValue),Syss.NoNetDec);

        TmpLine[2] := 0; {Line Cost}
        TmpLine[3] := 0; {Line Weight}
      end
      else
      begin
        TmpLine[1]:=Round_Up((Qty*NetValue),Syss.NoNetDec);  {Line Net}
        TmpLine[2]:=Round_Up((Qty*CostPrice),Syss.NoCosDec); {Line Cost}
        TmpLine[3]:=Round_Up((Qty*LWeight),2);               {Line Weight}
      end;

      TmpHead[1]:=TmpHead[1]+TmpLine[1];  { TH NetValue}
      TmpHead[2]:=TmpHead[2]+TmpLine[2];  { TH Cost}
      TmpHead[3]:=TmpHead[3]+TmpLine[3];  { TH Weight}
      {TmpHead[4]:=TmpHead[4]+VAT;         { TH VAT}
      { TH VAT Analysis}
      // this had been changed on 17/04/2000 was
      // TmpVAnal[GetVATNo(VATCode,#0)] := VAT;
      if (Inv.InvDocHed <> TSH) then
        TmpVAnal[GetVATNo(VATCode,#0)] := TmpVAnal[GetVATNo(VATCode,#0)] + Round_Up(VAT,2);
    end; {if..}

    Status:=Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);
  end; {while..}

  If (HasNoUpdateRec) then
  With TInv do
  begin
    InvNetVal:=TmpHead[1];
    TotalCost:=TmpHead[2];
    TotalWeight:=TmpHead[3];

    //PR: 03/06/2009 Change to check that not Manual Vat
    if not TInv.ManVat then
    begin
      InvVAT:=0; {TmpHead[4];}

      For i:=Low(VATType) to High(VATType) do
      begin
        InvVATAnal[i]:=Round_Up(TmpVAnal[i],2);
        InvVAt:=InvVAT+InvVATAnal[i];
      end; {for..}
    end;

  end; {if HasNoUpdateRec..}

end; {CheckIdLinesAgain..}

function IsAutoTrans(const InvR : InvRec) : Boolean;
begin
  Result := (InvR.RunNo = -2) or (InvR.RunNo = -1);
end;

{$IFDEF ImpV6}
//PR: Validation function for Order Payments in importer
function ValidateOrderPayment(ExInvRec : TBatchThRec): Integer;
var
  KeyS : Str255;
begin
  Result := 0;

  If not Syss.ssEnableOrderPayments then
    Result := 30400
  else
  if not Cust.acAllowOrderPayments then
    Result := 30401
  else
  if ExInvRec.TransDocHed <> 'SOR' then
    Result := 30402;

  ExInvRec.thOrderPaymentValue := Round_Up(ExInvRec.thOrderPaymentValue, 2);

  if (Result = 0) then
  begin //At this point we've already copied ExInvRec into Inv, so we can use ITotal function
    //PR: 06/11/2014 ABSEXCH-16801 Round up result from ITotal call
    if (ExInvRec.thOrderPaymentValue <= 0) or (ExInvRec.thOrderPaymentValue > Round_Up(ITotal(Inv), 2)) then
      Result := 30403;
  end;

  if (Result = 0) and Syss.UseCCDep then
  begin
    //PR: 30/10/2014 ABSEXCH-15774 Wasn't padding CC/Dept codes
    //CostCentre
    KeyS:=CostCCode + CSubCode[True] + FullCCDepKey(UpperCase(ExInvRec.thOrderPaymentCostCentre));
    Result:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);
    if Result <> 0 then
      Result := 30404;

    //Department
    if Result = 0 then
    begin
      KeyS:=CostCCode + CSubCode[False] + FullCCDepKey(UpperCase(ExInvRec.thOrderPaymentDepartment));
      Result:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);
      if Result <> 0 then
        Result := 30405;
    end;
  end;

  if Result = 0 then
  begin
    if CheckRecExsists(Strip('R',[#0], FullNomKey(ExInvRec.thOrderPaymentBankGL)), NomF, NomCodeK) then
    begin   //Must be balance sheet - if using classes then must be bank a/c
      if (Nom.NomType <> 'B') or (Syss.UseGLClass and (Nom.NomClass <> 10 {Bank A/C})) then
        Result := 30406;
    end
    else
      Result := 30406;
  end;


end;

function CreateOrderPayment(ExInvRec : TBatchThRec) : Integer;
var
  iPayment : IOrderPaymentsPayment;
  OrderPaymentsTransaction : IOrderPaymentsTransactionInfo;
begin
  Result := 0;
  OrderPaymentsTransaction := OPTransactionInfo (Inv, Cust);
  If OrderPaymentsTransaction.CanTakePayment Then
  Begin
    // Get a record lock - shouldn't be a problem as we've just added the SOR
    If OrderPaymentsTransaction.LockTransaction Then
    begin
      //Get payment object
      iPayment := NewOrderPayment;
      Try
        //Initialise currency list - avoids an av
        Init_STDCurrList;
        //set properties
        iPayment.oppOrderPaymentTransInfo := OrderPaymentsTransaction;
        iPayment.oppPaymentValue := ExInvRec.thOrderPaymentValue;
        iPayment.oppPaymentGLCode := ExInvRec.thOrderPaymentBankGL;
        iPayment.oppPaymentCostCentre := ExInvRec.thOrderPaymentCostCentre;
        iPayment.oppPaymentDepartment := ExInvRec.thOrderPaymentDepartment;
        iPayment.oppPaymentReference := ExInvRec.thOrderPaymentReference;

        //Create the payment
        Result := iPayment.CreatePayment;
      Finally
        iPayment := nil;
        if Assigned(STDCurrList) then
          STDCurrList.Free;
      End;
    end
    else
      Result := 84;
  end;
end;
{$ENDIF}


{* ---------------------------------------------------------------------------
   This is the main function to validate transaction Header and Lines *}

Function ValidTrans(ExInvRec :  TBatchThRec;    { Header Record }
                    PL       :  POINTER;        { Pointer for Lines }
                    SMode    :  SmallInt;       { Insert/Update/Import Check Mode }
		    Mode     :  Byte)  :  Integer;  { Original parameter, not used for validation }

Const
    DocMatchTyp   :  Array[BOff..BOn] of Char = ('A','O');
    
Var

  ValidHed,
  ValidCheck   :  Boolean;
  HedVariance  :  Double;
  TmpMode      :  SmallInt;
  OldInv       :  InvRec;  {* 01.09.99 - to use for POR/SOR update *}

  EditNo       :  Byte;    {* Get no. of times edited for each trans. line *}
  LineFail     :  Integer;
  ExLocal      :  ^TdExLocal;
  bCISLocked   :  Boolean;

  //PR: ABSEXCH-11528 Store original o/s amount for orders
  PreviousOS   :  Double;

  //PR: 16/06/2015 Result from CIS function when System CIS GL Codes aren't set
  CISResult : Integer;

  //PR 23/03/2015 v7.0.14 ABSEXCH-16284 Proc to call UpdatePPDTotals. Sets taken to false so that
  //                                    fields are updated, then resets it.
  procedure UpdatePPDValues;
  var
    Temptaken : TTransactionPPDTakenStatus;
  begin
    TempTaken := Inv.thPPDTaken;
    Inv.thPPDTaken := ptPPDNotTaken;
    UpdatePPDTotals (Inv);
    Inv.thPPDTaken := TempTaken;
  end;

Begin
  TmpMode := 0;
  CISResult := 0;
  PreviousOS   := 0;
  ValidHed:=BOn;
  ValidCheck:=BOff;
  HedVariance:=0;
  EditNo:=0;
  Result:=0;
  LineFail:=0;
  CreateExistingLineNos; //Create TBits to check for duplicate linenos

  {$IFDEF COMTK}
    AllowZeroLineNos := ExInvRec.thZeroLineNos;
    AllowCtrlGLs := ExInvRec.thAllowCtrlCodes;
  {$ELSE}
    AllowZeroLineNos := False;
    AllowCtrlGLs := False;
  {$ENDIF}

  {* Windows Import has CHECK and IMPORT processes. If CHECK mode, just validate and
     only if IMPORT, the trans. would be added into Enterprise. No updating
     is allowed via Import Module *}

  If (SMode=ImportMode) or (SMode=CheckMode) then
  begin
    TmpMode:=SMode;    {* To Check for CheckMode *}
    SMode:=B_Insert;   {* From Import Module = B_Insert *}
  end
  else
  begin
    {* if not from Import Module and not Update, others would be considered as B_Insert *}
    If (SMode<>B_Update) then
      SMode:=B_Insert;
  end; {if..}

  //PR: 02/02/2010 If we're updating then we can improve MS-SQL performance in FifoL2U.FIFO_Control, so set this flag
  IsUpdate := (SMode = B_Update);
  {* OldInv has been added to update Acc.Balance if B_Update is used.
     Convert Header data from Toolkit record structure (ExInv)
     into Enterprise record structure (Inv) *}

  Result:=ExInvToInv(ExInvRec,SMode,OldInv,EditNo);
  {$IFDEF COMTK}
    //PR: 18/03/2009 Added functionality for automatically adding InLocation ADJ lines.
    AddInLocationAdjLines := ExInvRec.thAddInLocationLines and Syss.UseMLoc  and (Inv.InvDocHed = ADJ) and (Trim(Inv.DelTerms) <> '');
    if AddInLocationAdjLines then
      Inv.TotalCost := 0.00;
  {$ELSE}
    AddInLocationAdjLines := False;
  {$ENDIF}

  {* Validate Header Fields *}
  If (Result=0) then
    Result:=ValidateHeader(SMode,OldInv);

  {$IFDEF COMTK}
  if AllowCtrlGLs then
    Result := 0;
  {$ENDIF}

  If (Result=0) then  {* If Header validation is o.k *}
  With Inv do
  Begin

{    TTDValue := 0;
    TTDFlag := #0;}
    If (SMode=B_Insert) then {* If the transaction is to be ADDED *}
    Begin

      {* Validate Transaction Lines
         First parameter=0 = Validate only, do not add *}
      {Result:=Validate_Lines(0,ILineCount,HedVariance,PL,SMode,EditNo);}
      Result:=Validate_Lines(0,ExInvRec.LineCount,HedVariance,PL,SMode,EditNo);

      {$IFDEF ImpV6}
      if (Result = 0) and (Mode = 1) and ExInvRec.thCreateOrderPayment then
        Result := ValidateOrderPayment(ExInvRec);
      {$ENDIF}

      {* To add the transation if validation is o.k *}
      If ((Result=0) and (Mode=1) and (TmpMode<>CheckMode)) then
      Begin

        {* Set mandatory fields of Header record *}
        Result:=Set_ExDoc(HedVariance);

        {* Validate lines again and add lines into Details.DAT file *}
        If (Result=0) then
          Result:=Validate_Lines(1,ExInvRec.LineCount,HedVariance,PL,SMode,EditNo);

        //PR 24/02/03

        if CISOn and (InvDocHed in PurchSplit - [PPY, PQU, POR, PDN, PBT]) then
        begin
          //PR: 23/05/2011 Get CIS Setup record without locking (ABSEXCH-11396)
          bCISLocked := False;
//          GetMultiSys(BOff,GlobLocked,CISR);
          GetMultiSys(BOff,bCISLocked,CISR);
          //PR: ABSEXCH-10300
          //Calc_CISTaxInv creates an auto CIS line which takes its line number from ILineCount. At this
          //point ILinceCount is set to the number of the last line added which will lead to a duplicate
          //line number and cause problems. Fix by incrementing ILineCount before the function call;
          //TKCOM-66.454
          //TKDLL-66-251
          //Importer v6.6.122

          //PR: ABSEXCH-14486
          //For some reason ILineCount wasn't being set correctly until Store_ExDoc.
          if HighLineNo > Inv.ILineCount then
           Inv.ILineCount := HighLineNo + 2
          else
           Inv.ILineCount := Inv.ILineCount + 2;

          if Calc_CISTaxInv(Inv, True, CISResult) <> 0.00 then
          begin
            New(ExLocal, Create);
            Try
              CalcInvTotals(Inv, ExLocal^, not Inv.ManVAT, True);
            Finally
              Dispose(ExLocal);
            End;
          end;
        end;



        {* If lines adding o.k, add Header into Document.Dat *}
        If (Result=0) then
        begin
          //PR: 25/03/2015 ABSEXCH-14705 Inserting so update PPDValues
          UpdatePPDValues;

	  Result:=Store_ExDoc(SMode);  {* Need SMode here for Update or Insert *}

         {$IFDEF ImpV6}
         if (Result = 0) and ExInvRec.thCreateOrderPayment then
           CreateOrderPayment(ExInvRec);
         {$ENDIF}
        end;

        {* If storing Header is Not o.k, delete Lines in Details.Dat *}
        If (Result<>0) then
	  DeleteLinks(FullNomKey(FolioNum),IdetailF,Length(FullNomKey(FolioNum)),IdFolioK,BOff)
        else
        begin
          {* OldInv is not used for B_Insert, Just to pass the parameter *}
          FillChar(OldInv,SizeOf(OldInv),#0);
        end; {If Result<>0..}


      end; {if Result=0 and Mode=1..}
    end; {if SMode=B_Insert..}

    {*** All these have to be modified ***}


    {* If Transaction is to be Updated (B_Update parameter) *}
    If (SMode=B_Update) then
    begin

      {* Validate Lines - first parameter = 0 = Do validate Only. *}
      Result:=Validate_Lines(0,ExInvRec.LineCount,HedVariance,PL,SMode,EditNo);

      {* If Lines validate o.k and not CHECK mode of Import Module *}
      If ((Result=0) and (Mode=1) and (TmpMode<>CheckMode)) then
      Begin
         //PR: 16/09/2013 ABSEXCH-14596 - Was taking PreviousOS from Inv rather than OldInv.
         If (InvDocHed In PSOPSet) then
           PreviousOS := TransOSValue(OldInv);
        {* Validate and Add Lines into Details.DAT *}
        Result:=Validate_Lines(1,ExInvRec.LineCount,HedVariance,PL,SMode,EditNo);

        {* Check all Lines belong to the Header
           if the records were not updated, check & delete them *}
        If (Result=0) then
          Result:=CheckIdLinesAgain(Inv, OldInv.FolioNum, EditNo, LineFail);

        {* Update mandatory fields in Header *}
        If (Result=0) then
          Result:=Set_ExDocForUpdate(HedVariance,OldInv);

        //PR: 25/01/2011 ABSEXCH-10704 On update CIS Line wasn't being updated, so need to call Calc_CISTaxInv.
        //TKCOM-66.454
        //TKDLL-66-251
        //Importer v6.6.122
        if CISOn and (InvDocHed in PurchSplit - [PPY, PQU, POR, PDN, PBT]) then
        begin
          //PR: 23/05/2011 Get CIS Setup record without locking (ABSEXCH-11396)
          bCISLocked := False;
          GetMultiSys(BOff,bCISLocked,CISR);
          if Calc_CISTaxInv(Inv, True, CISResult) <> 0.00 then
          begin
            New(ExLocal, Create);
            Try
              CalcInvTotals(Inv, ExLocal^, not Inv.ManVAT, True);
            Finally
              Dispose(ExLocal);
            End;
          end;
        end;

        {* Update Header record in Document.DAT *}
        If (Result=0) then
        begin
          //PR: 28/10/2010 ABSEXCH-14705
          //If we're updating a transaction then recalculate PPD values if we've changed the taken flag or if it is false;
          //don't change if taken was true and is still true
          if not ((thPPDTaken > ptPPDNotTaken) and (OldInv.thPPDTaken > ptPPDNotTaken)) then
            UpdatePPDValues;

	  Result:=Store_ExDoc(SMode);  {Need SMode here for Update & Insert }
        end;

        {* Reverse Account Balance for OLD Header Value,
           OldInv is used here *}
        If (Result=0) and (ExSyss.UpAccBal) and not IsAutoTrans(Inv) and
           (Not (InvDocHed In NomSplit+StkAdjSplit+TSTSplit+OrderSet+QuotesSet+DeliverSet+WOPSplit+BatchSet)) then
          Result:=UpdateExBal(OldInv,(ConvCurrITotal(OldInv,BOff,BOn,BOn)*DocCnst[OldInv.InvDocHed]*DocNotCnst),
                                     (ConvCurrICost(OldInv,BOff,BOn)*DocCnst[OldInv.InvDocHed]*DocNotCnst),
                                     (ConvCurrINet(OldInv,BOff,BOn)*DocCnst[OldInv.InvDocHed]*DocNotCnst),
                                      BOn,2);

      end; {if Result=0..}

    end; {if SMode=B_Update...}


    {If (Result=0) then - 21.06.2000 }
    If ((Result=0) and (Mode=1) and (TmpMode<>CheckMode)) then
    begin
      If (Not IsEBusTran) and not IsAutoTrans(Inv) then  { 18.10.2000 - Added this as seperate checking}
      begin

        {* Update Account Balance *}
        If (ExSyss.UpAccBal) and
           (RunNo <> -10) and
           (Not (InvDocHed In NomSplit+StkAdjSplit+TSTSplit+OrderSet+QuotesSet+DeliverSet+WOPSplit+BatchSet+JAPSplit)) then
            Result:=UpdateExBal(Inv,(ConvCurrITotal(Inv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                    (ConvCurrICost(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                    (ConvCurrINet(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                     BOff,2);

          {* Update Total Order Outstanding for [SOR,POR,SDN,PDN] *}
          If (InvDocHed In PSOPSet) then
            UpdateCustOrdBal(OldInv,Inv, PreviousOS);

          //AP: 17/08/2017 ABSEXCH-18408:COM Toolkit Not Updating POR B2B Matching Value on Edit - Added to interface
          If (InvDocHed In PSOPSet) and (TotOrdOS<>PreviousOS) and (Copy(YourRef,1,3)=DocCodes[SOR]) then
          Begin
            Update_MatchPay(OurRef,Trim(YourRef), OldInv.TotOrdOS,OldInv.TotOrdOS,BOn,DocMatchTyp[BOn]);

            Update_MatchPay(OurRef,Trim(YourRef), TotOrdOS,TotOrdOS,BOff,DocMatchTyp[BOn]);
          end;

      end; {If not IsEBusTran...}

    end; {if Result=0 from Lines }
  end; {If Result=0 from Header ..}

  { LineFail has been added for Warning Messages }
  If (LineFail<>0) then
    Result:=LineFail;

  FreeExistingLineNos;

  //PR: 16/06/2015 ABSEXCH-16560 Set result if we were'nt able to add CIS Line when required
  if CISResult <> 0 then
    Result := CISResult;

end; {ValidTrans..}



{* ========== Store Transaction ============ *}

FUNCTION EX_STORETRANS(P,
                       PL         :  POINTER;
                       PSIZE,                     {* Size of TH *}
                       PLSIZE     :  LONGINT;     {* Size of TLs *}
                       SEARCHPATH :  SMALLINT;
                       SEARCHMODE :  SMALLINT)  :  SMALLINT;

Var
  ExInvRec   :  ^TBatchTHRec;
  KeyS       :  Str255;
  ValidCheck :  Boolean;
  TestResult :  SmallInt;

  //PR: 28/10/2013 ABSEXCH-14705
  oHeaderRecordHelper : IToolkitRecordHelper;

Begin

  LastErDesc:='';

  If TestMode Then Begin
    ExInvRec:=P;
    ShowMessage ('Ex_StoreTrans: ' + #10#13 +
                 'P^.OurRef: ' + ExInvRec^.OurRef + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'PLSize: ' + IntToStr(PLSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  //PR: 28/10/2013 ABSEXCH-14705 Create and initialize record helper
  oHeaderRecordHelper := GetRecordHelper(rhTransHead);
  oHeaderRecordHelper.RecordSize := PSize;
  oHeaderRecordHelper.RecordPointer := P;

  TestResult := oHeaderRecordHelper.ErrorCode;

  If TestResult = 0 then
  Begin
    ExInvRec := oHeaderRecordHelper.RecordPointer;

    ValidCheck:=True;  {* check No. of TLs *}

//    ValidCheck:=(ExInvRec^.LineCount<=(PLSize div SizeOf(TBatchTLRec)));
    ValidCheck:=((PLSize div SizeOf(TBatchTLRec)) * SizeOf(TBatchTLRec)) = PLSize;

    If (ValidCheck) then
    begin

      HighLineNo := 0;
      {TestResult:=ValidTrans(ExInvRec^,PL,B_Insert,1)}
      TestResult:=ValidTrans(ExInvRec^,PL,SearchMode,1);

      {* 07.07.99 - added this to return OurRef, Folio number etc..
         20.04.2000 - Added 30700 and 30701 checking *}

      If (TestResult=0) or (TestResult=30700) or (TestResult=30701) then
        InvToExInv(ExInvRec^);

    end
    else
      TestResult:=32765; {* TLs record size incorrect *}

  end;

  // HM 17/10/00: Modified to use TestResult
  If (TestResult<>0) then
    LastErDesc:=Ex_ErrorDescription(21,TestResult);

  // CJS 2011-08-12 ABSEXCH-11265 - Cached data problem
  oCRECache.Clear;

  Ex_StoreTrans:=TestResult;

end; {Ex_StoreTrans ..}


FUNCTION EX_STOREEBUSTRANS(P,
                           PL         :  POINTER;
                           PSIZE,
                           PLSIZE     :  LONGINT;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT) : SMALLINT;
begin
  LastErDesc:='';

  {12.10.2000 - Just allow as a New record at the moment... }
  SearchMode:=B_Insert;

  Result := SwitchToEBusinessFiles(true);
  if Result = 0 then
  begin
    IsEbusTran:=True;   { Not to update Account/Stock }

    Result := Ex_StoreTrans(P, PL, PSize, PLSize, SearchPath, SearchMode);

    SwitchToEBusinessFiles(false);

    IsEbusTran:=False;
  end;

  if Result <> 0 then
    LastErDesc:=Ex_ErrorDescription(21,Result); { Ex_StoreTrans Index has been used }

end; { Ex_StoreEBusTrans..}

{ ============ Function to Return Next Transaction Number =========== }

FUNCTION EX_GETNEXTTRANSNO(DOCSTR   :  PCHAR;
                           NEXTNO   :  PCHAR;
                           UPDATE   :  WORDBOOL)  :  SMALLINT;
Var
  KeyS     :  Str20;
  DT       :  DocTypes;
  LockStr  :  Str255;
  i : integer;
  Found : boolean;
Begin
  LastErDesc:='';

  If TestMode Then
  begin
    If WordBoolToBool(Update) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetNextTransNo:' + #10#13 +
                 'DocStr: ' + StrPas(DocStr) + #10#13 +
                 'NextNo: ' + StrPas(NextNo) + #10#13 +
                 'Update: ' + LockStr);

  end;

  KeyS:=StrPas(DocStr);
  Found := false;
  for i := 1 to EBUSINESS_COUNTERS do
    Found := Found or (DocStr = EBUSINESS_DOCS[i]);

  if not Found then
    Result:=GetDocType(KeyS,DT)
  else
    Result := 0;

  If (Result=0) then
  Begin
    if Found then
      Result := FullEBisDocNum(string(DOCSTR),WordBoolToBool(Update),DocLen,KeyS)
    else
      Result := FullDocNum(DT,WordBoolToBool(Update),DocLen,KeyS);
    StrPCopy(NextNo,KeyS);
  end;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(22,Result);

end; { Ex_GetNextTransNo.. }


FUNCTION EX_TESTSTK(SEARCHKEY      :  PCHAR;
                    SEARCHPATH     :  SMALLINT;
                    SEARCHMODE     :  SMALLINT;
                    LOCK           :  WORDBOOL)  :  SMALLINT;

Const
  Fnum     =  StockF;
  Keypath  =  StkCodeK;

Var
  KeyS       :  Str255;
  Locked     :  Boolean;
Begin
  Locked:=BOff;
  Begin
    KeyS:=StrPas(SearchKey);
    Result:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
     {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked));
    {$ENDIF}
    StrPCopy(SearchKey,KeyS);

    If (Result=0) then
    Begin
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
      Result:=Status;
    end;

  end; {If .. Not assigned}

end; {Func..}


{* ========== Get Total Trans. Lines ========== *}

FUNCTION EX_GETTOTALTRANSLINES(DOCREF : PCHAR) : LONGINT;
const
  Fnum    = InvF;
  KeyPath = InvOurRefK;
var
  KeyS      : Str255;
  CheckOK   : WordBool;
  TmpRecAddr,
  NoRecs    : LongInt;

  TmpStat,
  TmpKPath
            :  Integer;
  TmpFn     :  FileVar;



begin
  LastErDesc:='';
  If TestMode Then
    ShowMessage ('Ex_GetTotalTransLines:' + #10#13 +
                 'DocStr: ' + StrPas(DocRef));

  TmpFn:=F[Fnum];

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);

  NoRecs:=0;

  KeyS:=StrPas(DocRef);
  KeyS:=LJVar(KeyS,DocLen);

  Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  If (Result=0) then
  begin
    {NoRecs:=Inv.ILineCount;}
    NoRecs:=GetActualLineCount(Inv.FolioNum);
  end; {if..}

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(23,Result);

  Ex_GetTotalTransLines:=NoRecs;

end; {Ex_GetTotalTransLines..}


{* ========= Round Up ========== *}

FUNCTION EX_ROUNDUP(INPUTVALUE     :  DOUBLE;
                    DECIMALPLACES  :  SMALLINT)  :  DOUBLE;
Var
  TmpValue  :  Double;

begin
  LastErDesc:='';
  TmpValue:=0;
  TmpValue:=Round_Up(InputValue,DecimalPlaces);
  EX_ROUNDUP:=TmpValue;
end;

{* ========= Get Transaction Header Only =========== *}

FUNCTION EX_GETTRANSHED(P              :  POINTER;
                        PSIZE          :  LONGINT;
                        SEARCHKEY      :  PCHAR;
                        SEARCHPATH     :  SMALLINT;
                        SEARCHMODE     :  SMALLINT;
                        LOCK           :  WORDBOOL) : SMALLINT;

Var
  ExInvRec  :  ^TBatchTHRec;
  KeyS       :  Str255;

  ValidCheck,
  Locked     :  Boolean;
  LockStr    :  String[255];

  TmpVal     :  LongInt;

  //PR: 28/10/2013 ABSEXCH-14705
  oHeaderRecordHelper : IToolkitRecordHelper;
Begin
  LastErDesc:='';

  If TestMode Then
  Begin
    ExInvRec:=P;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetTransHed:' + #10#13 +
                 'P^.OurRef: ' + ExInvRec^.OurRef + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'SearchKey: ' + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: ' + LockStr);
  End; { If }

  Locked:=BOff;

  //PR: 28/10/2013 ABSEXCH-14705 Create and initialize record helper
  oHeaderRecordHelper := GetRecordHelper(rhTransHead);
  oHeaderRecordHelper.RecordSize := PSize;
  oHeaderRecordHelper.RecordPointer := P;

  Result := oHeaderRecordHelper.ErrorCode;

  If Result = 0 then
  Begin
    ExInvRec := oHeaderRecordHelper.RecordPointer;

    If (Not (SearchPath In [0..11])) then
      SearchPath:=0;

    KeyS:=StrPas(SearchKey);
    Blank(ExInvRec^,Sizeof(ExInvRec^));

    KeyS := SetKeyString(SearchMode, InvF, KeyS);

    Result:=Find_Rec(SearchMode,F[InvF],InvF,RecPtr[InvF]^,KeyInvFXLate[SearchPath],KeyS);

    If WordBoolToBool(Lock) and (Result=0) then
    Begin {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyInvFXLate[SearchPath],InvF,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyInvFXLate[SearchPath],InvF,SilentLock,Locked));
    {$ENDIF}
    End;
    StrPCopy(SearchKey,KeyS);

    KeyStrings[InvF] := KeyS;

    If (Result=0) then
    Begin

      InvToExInv(ExInvRec^);

    end; {if Result=0 ..}

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;


end; {Ex_GetTransHed..}

{* ========= Get A Transaction Line =========== *}

FUNCTION EX_GETTRANSLINE(PLINE          :  POINTER;
                         PLSIZE         :  LONGINT;
                         SEARCHKEY      :  PCHAR;
                         SEARCHPATH     :  SMALLINT;
                         SEARCHMODE     :  SMALLINT;
                         LOCK           :  WORDBOOL) : SMALLINT;
Var
  ExIdRec    :  ^TBatchTLRec;
  KeyS       :  Str255;

  ValidCheck,
  Locked     :  Boolean;
  LockStr    :  String[255];

  TmpVal     :  LongInt;

Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExIdRec:=PLine;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetTransLine:' + #10#13 +
                 'PLSize: ' + IntToStr(PLSize) + #10#13 +
                 'SearchKey: ' + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: ' + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;

  If (PLine<>Nil) and (PLSize=Sizeof(TBatchTLRec)) then
  Begin
    If (Not (SearchPath In [0..4, 6])) then
      SearchPath:=0;

    KeyS:=StrPas(SearchKey);

    // HM 12/10/01: Added this section to workaround the PChar problem with the 4 x #0 required in the index
    If (SearchPath = 6) And (Length(KeyS) >= 11) Then Begin
      If (KeyS[8] = #255) Then KeyS[8] := #0;
      If (KeyS[9] = #255) Then KeyS[9] := #0;
      If (KeyS[10] = #255) Then KeyS[10] := #0;
      If (KeyS[11] = #255) Then KeyS[11] := #0;
    End; { If (SearchPath = 6) ... }

    ExIdRec:=PLine;
    Blank(ExIdRec^,Sizeof(ExIdRec^));

    KeyS := SetKeyString(SearchMode, IDetailF, KeyS);

    Result:=Find_Rec(SearchMode,F[IdetailF],IdetailF,RecPtr[IdetailF]^,KeyIDXLate[SearchPath],KeyS);

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyIDXLate[SearchPath],IdetailF,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
       Result := 84;
    end;
    {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyIDXLate[SearchPath],IdetailF,SilentLock,Locked));
    {$ENDIF}
    StrPCopy(SearchKey,KeyS);

    KeyStrings[IDetailF] := KeyS;

    If (Result=0) then
    Begin
      IdToExId(ExIdRec^);
      // Not sure why TransRefNo blanked - commented out 12/05/2000 Jim
      // ExIdRec^.TransRefNo:='';  {* 02.09.99 - not to return OurRef *}
    end; {if Result=0 ..}

  end {If .. Not assigned}
  else
    If (PLine<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(25,Result);

end; {Ex_GetTransLine..}


{* ============ Convert Folio No from LongInt to String =========== *}

FUNCTION EX_CONVERTFOLIO(FOLIONUMBER  :  LONGINT)  :  SHORTSTRING;
var
  GenStr  :  Str255;
begin

  LastErDesc:='';

  GenStr:=FullNomKey(FolioNumber);

  EX_CONVERTFOLIO:=GenStr;

end; {Func..}


FUNCTION EX_GETTLLINE(FOLIONUMBER,
                      LINENUMBER  :  LONGINT;
                      PLINE       :  POINTER;
                      PLSIZE      :  LONGINT)  :  SMALLINT;
Const
  Fnum     =  IDetailF;
  KeyPath  =  IdFolioK;

Var
  TmpTL   :  ^TBatchTLRec;
  KeyF    :  Str255;

begin
  LastErDesc:='';
  Result:=32767;
  TmpTL:=PLine;

  If (PLine<>Nil) and (PLSize=Sizeof(TBatchTLRec)) then
  Begin

    KeyF:=FullidKey(FolioNumber,LineNumber);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyF);

    KeyStrings[IDetailF] := KeyF;

    Result:=Status;

    If (Status=0) then
    begin
      IdToExId(TmpTL^);
      TmpTL^.TransRefNo:='';  {* 20.10.99 - not to return OurRef *}
    end;

  end {if..}
  else
    If (PLine<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(85,Result);

end; {Ex_GetTLLine..}


FUNCTION EX_GETTHBYFOLIO(FOLIONUMBER :  LONGINT;
                         P           :  POINTER;
                         PSIZE       :  LONGINT)  :  SMALLINT;
Const
  Fnum   =  InvF;
  KPath  =  InvFolioK;

Var
  ExInvRec  :  ^TBatchTHRec;
  KeyS       :  Str255;

  ValidCheck,
  Locked     :  Boolean;
  LockStr    :  String[255];

  //PR: 28/10/2013 ABSEXCH-14705
  oHeaderRecordHelper : IToolkitRecordHelper;

Begin
  LastErDesc:='';
  If TestMode Then
  Begin
    ExInvRec:=P;
    ShowMessage ('Ex_GetTHByFolio : ' + #10#13 +
                 'Folio No. : '+ IntToStr(FolioNumber)+ #10#13+
                 'PSize : ' + IntToStr(PSize));
  End; { If }

  //PR: 28/10/2013 ABSEXCH-14705 Create and initialize record helper
  oHeaderRecordHelper := GetRecordHelper(rhTransHead);
  oHeaderRecordHelper.RecordSize := PSize;
  oHeaderRecordHelper.RecordPointer := P;

  Result := oHeaderRecordHelper.ErrorCode;

  If Result = 0 then
  Begin
    ExInvRec := oHeaderRecordHelper.RecordPointer;

    KeyS:=FullNomKey(FolioNumber);
    Blank(ExInvRec^,Sizeof(ExInvRec^));

    Result:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,KPath,KeyS);

    KeyStrings[InvF] := KeyS;

    If (Result=0) then
    Begin
      InvToExInv(ExInvRec^);
    end; {if Result=0 ..}

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(87,Result);

end; {Ex_GetTHByFolio..}



{ HM 23/12/97: Function added for EL }
FUNCTION EX_GETTHBYRUNNO(P          :  POINTER;
                         PSIZE      :  LONGINT;
                         RUNNO      :  LONGINT;
                         SEARCHMODE :  SMALLINT;
                         LOCK       :  WORDBOOL) : SMALLINT;
Var
  ExInvRec   :  ^TBatchTHRec;
  KeyS       :  Str255;
  Locked     :  Boolean;
  LockStr    :  String[255];

  TmpVal     :  LongInt;
  SearchPath : Integer;

  //PR: 28/10/2013 ABSEXCH-14705
  oHeaderRecordHelper : IToolkitRecordHelper;
Begin
  LastErDesc:='';

  If TestMode Then
  Begin
    ExInvRec:=P;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('EX_GETTHBYRUNNO:' + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'RunNo: ' + IntToStr(RunNo) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: ' + LockStr);
  End; { If }

  Locked:=BOff;

  { Check record size is correct }
  //PR: 28/10/2013 ABSEXCH-14705 Create and initialize record helper
  oHeaderRecordHelper := GetRecordHelper(rhTransHead);
  oHeaderRecordHelper.RecordSize := PSize;
  oHeaderRecordHelper.RecordPointer := P;

  Result := oHeaderRecordHelper.ErrorCode;

  If Result = 0 then
  Begin
    ExInvRec := oHeaderRecordHelper.RecordPointer;
    { Always use Run Number key }
    SearchPath:=InvRNoK;


    If (SearchMode = B_GetEq) Then
      { Build full key for passed in record }
      KeyS:=FullNomKey(ExInvRec^.RunNo) + ExInvRec^.OurRef[1] + FullnomKey(ExInvRec^.FolioNum)
    Else
      { build key from specified run number }
      KeyS:=FullnomKey(RunNo);

    KeyS := SetKeyString(SearchMode, InvF, KeyS);

    Blank(ExInvRec^,Sizeof(ExInvRec^));

    Result:=Find_Rec(SearchMode,F[InvF],InvF,RecPtr[InvF]^,SearchPath,KeyS);

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,InvF,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
       Result := 84;
    end;
    {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,InvF,SilentLock,Locked));
    {$ENDIF}

    KeyStrings[InvF] := KeyS;

    If (Result=0) then Begin
      InvToExInv(ExInvRec^)
    end; {if Result=0 ..}
  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(88,Result);

end; {Func..}


{ HM 24/12/97: Added for EL }
{ Stores a Transaction Header - use with caution as no validation or update of totals, stock, balances, etc }
{}
{ HM 12/11/99: Removed EX_ from function name and changed password from }
{              61298341 because developers were using the function      }
FUNCTION STORETH(P          :  POINTER;
                 PSIZE      :  SMALLINT;             {* Size of TH *}
                 SEARCHPATH :  SMALLINT;
                 UPDATEMODE :  SMALLINT;
                 AUTHCODE   :  LONGINT)  :  SMALLINT;
Const
  FNum = InvF;
Var
  ExInvRec   :  ^TBatchTHRec;
  KeyS       :  Str255;
  ValidCheck :  WordBool;
  TestResult :  SmallInt;
  KeyPath    :  Integer;
  OldInv     :  InvRec;  {* Will not be used in this function *}
  EditNo     :  Byte;    {* Will not be used in this function *}

Begin
  LastErDesc:='';
  If TestMode Then Begin
    ExInvRec:=P;
    ShowMessage ('Ex_StoreTH: ' + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'UpdateMode: ' + IntToStr(UpdateMode));
  End; { If }

  TestResult:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchTHRec)) And (AuthCode = 90812966) Then Begin
    { Convert pointer to TH handle }
    ExInvRec:=P;

    If (UpdateMode = B_Insert) Or (UpdateMode = B_Update) Then Begin
      {* SM : OldInv has been added, but for this function it will not be used. *}

      { Copy invoice into Inv }
      TestResult := ExInvToInv(ExInvRec^,-UpdateMode,OldInv,EditNo); {* Convert Inv Data *}

      If (TestResult = 0) Then Begin
        KeyPath := SearchPath;
        If (UpdateMode = B_Insert) Then
          { Insert new transaction }
          TestResult := Add_Rec (F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath)
        Else
          { Update current transaction }
          TestResult := Put_Rec (F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath);
      End; { If }
    End { If }
    Else
      TestResult := 32765;
  End
  Else
    If (P<>Nil) then
      TestResult:=32766;

  If (TestResult<>0) then
    LastErDesc:=Ex_ErrorDescription(89,TestResult);

  Result := TestResult;
end; {Func..}


{* ----- Convert Amount from one Currency to another ----- *}

FUNCTION EX_CONVERTAMOUNT(FROMCURR   :  SMALLINT;
                          TOCURR     :  SMALLINT;
                      VAR AMOUNT     :  DOUBLE;
                          RATETYPE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}

var
  ValidHed,
  ValidCheck,
  CoDayRate  :  Boolean;

  TResult    :  Integer;

begin
  LastErDesc:='';
  ValidHed:=BOn;
  ValidCheck:=BOff;
  TResult:=0;
  CoDayRate := False;

  { Check for different currency and Amount <>0 }
  ValidCheck:=((FromCurr<>ToCurr) and (Amount<>0));
  GenSetError(ValidCheck,30100,TResult,ValidHed);

  { Check From Currency }
  ValidCheck:=(FromCurr>=0) and (FromCurr<=CurrencyType);
  GenSetError(ValidCheck,30101,TResult,ValidHed);

  { Check To Currency }
  ValidCheck:=(ToCurr>=0) and (ToCurr<=CurrencyType);
  GenSetError(ValidCheck,30102,TResult,ValidHed);

  ValidCheck:=(RateType In [0..2]);
  GenSetError(ValidCheck,30103,TResult,ValidHed);

  If (ValidCheck) then
  begin
    Case RateType of
      0 :  CoDayRate:=(Syss.TotalConv=XDayCode);  {System Rate}
      1 :  CoDayRate:=BOn;   {Daily Rate}
      2 :  CoDayRate:=BOff;  {Company Rate}
    end; {Case..}
  end; {if..}

  If (TResult=0) then
    Amount:=Round_Up(Currency_ConvFT(Amount,FromCurr,ToCurr,CoDayRate),2);

  If (TResult<>0) then
    LastErDesc:=Ex_ErrorDescription(99,TResult);

  Ex_ConvertAmount:=TResult;

end; {func..}

{//------------------------------------------------------------------------------}

FUNCTION EX_STORETRANSHED(P      : POINTER;
                          PSIZE  : SMALLINT) :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
{ Pre    : P = Pointer to record of type TBatchTHRec
          PSize = Size of passed record structure
 Action : Searches for the transaction record that matches P
          If found updates the user defined fields only
}
const
  FNum = InvF;
var
  KeyNum : integer;
  RecPos : longint;
  SavedPosOK,
  Locked : boolean;
  HeaderRec : ^TBatchTHRec;
  KeyS : str255;
  THoldFlag  :  SmallInt;

  //PR: 28/10/2013 ABSEXCH-14705
  oHeaderRecordHelper : IToolkitRecordHelper;
begin
  HeaderRec := nil;
  LastErDesc:='';
  Result:=0;

  if TestMode then
    ShowMessage ('Ex_StoreTransHed:' + #10#13 +
                 'P^.OurRef: ' + HeaderRec^.OurRef + #10#13 +
                 'PSize: ' + IntToStr(PSize));

  //PR: 28/10/2013 ABSEXCH-14705 Create and initialize record helper
  oHeaderRecordHelper := GetRecordHelper(rhTransHead);
  oHeaderRecordHelper.RecordSize := PSize;
  oHeaderRecordHelper.RecordPointer := P;

  Result := oHeaderRecordHelper.ErrorCode;

  If Result = 0 then
  Begin
    HeaderRec := oHeaderRecordHelper.RecordPointer;

    { Save the current position in the transaction header file }
    KeyNum := GetPosKey;
    SavedPosOK := Presrv_BTPos(FNum, KeyNum, F[FNum], RecPos, false, false) = 0;

    { Find and update the transaction header record }
    KeyS := FullNomKey(HeaderRec^.RunNo) + HeaderRec^.OurRef[1] + FullNomKey(HeaderRec^.FolioNum);
    Result := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);

    If Result=0 then { Attempt to lock record }
    {$IFDEF WIN32}
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked));
    {$ENDIF}

    if Result = 0 then
      with Inv do
      begin
        DocUser1 := HeaderRec^.DocUser1;
        DocUser2 := HeaderRec^.DocUser2;
        DocUser3 := HeaderRec^.DocUser3;
        DocUser4 := HeaderRec^.DocUser4;

        //PR: 24/10/2011 v6.9 user fields
        DocUser5 := HeaderRec^.DocUser5;
        DocUser6 := HeaderRec^.DocUser6;
        DocUser7 := HeaderRec^.DocUser7;
        DocUser8 := HeaderRec^.DocUser8;
        DocUser9 := HeaderRec^.DocUser9;
        DocUser10 := HeaderRec^.DocUser10;

        //PR: 06/06/2016 v2016 R2 ABSEXCH-17383
        thUserField11 := HeaderRec^.DocUser11;
        thUserField12 := HeaderRec^.DocUser12;


        {
        1	hold for query
        2	hold until allocated
        3	Hold Authorised
        4	Hold order lines until all line stock available
        5	Hold order until all stock available for all lines
        6	Hold until credit cleared
        +32	Doc has notes
        +128	Suspend posting.
        }

        THoldFlag:=HeaderRec^.HoldFlg;
        { Copy from customisation help }
        { New Hold Mode +(HoldFlg AND 128) + (HoldFlg AND 32) }

        //PR: 10/11/2011 v6.9 Return error if HoldFlag isn't valid. ABSEXCH-11421
        //PR: 02/03/2012 Switch from using + to using 'or' as it was doubling up 32 (notes)
        if IsValidHoldFlag(THoldFlag) then
          HoldFlg  := THoldFlag or (HoldFlg and 128) or (HoldFlg and 32)
        else
          Result := 30235;

        if Result = 0 then
        begin
          If (HeaderRec^.Tagged >= 0) And (HeaderRec^.Tagged <= 99) Then
            Tagged:=HeaderRec^.Tagged;  {20.10.99 - request by NZ }

          //PR 11/04/03 Add TotalCost2 field
          TotalCost2 := HeaderRec^.TotalCost2;

          {$IFDEF COMTK}
          thExportedFlag := HeaderRec^.thExported;

          //PR: 24/04/2015 ABSEXCH-16379 Set printed flag
          PrintedDoc := WordBoolToBool(HeaderRec^.PrintedDoc);
          {$ENDIF}

          //PR 18/04/06 Added no of labels for ANC plugin
          NoLabels := HeaderRec^.thNoLabels;

          //PR 5/07/06 Added AltRef for Sage Conversion.
          TransDesc := HeaderRec^.LongYrRef;

          //PR: 15/01/2015 ABSEXCH-16034 Added thWorkflowState
          {$IFDEF COMTK}
          thWorkflowState := HeaderRec^.thWorkflowState;
          {$ENDIF}

          //PR: 25/05/2016 ABSEXCH-17259 Added Originator at IR's request
          {$IFDEF COMTK}
          thOriginator := HeaderRec^.thOriginator;
          {$ENDIF}

          Result := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);

          {$IFNDEF COMTK}
          //PR: 28/10/2011 v6.9
          if Result = 0 then
            AuditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);
        {$ENDIF}
        end; //if Result = 0
      end;

    { Return to the original position in the transaction header file }
    if SavedPosOK then
      Presrv_BTPos(InvF, KeyNum, F[FNum], RecPos, true, false);

  end; {If Result=0..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(125,Result);

end; { Ex_StoreTransHed }

{------------------------------------------------------------------------------}

FUNCTION EX_STORETRANSDETL(P      : POINTER;
                          PSIZE  : SMALLINT) :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
{ Pre    : P = Pointer to record of type TBatchTLRec
           PSize = Size of passed record structure
 Action : Searches for the transaction line that matches P
          If found updates the user defined fields only
}
const
  FNum = IDetailF;
var
  KeyNum : integer;
  RecPos : longint;
  SavedPosOK,
  Locked : boolean;
  LineRec : ^TBatchTLRec;
  KeyS : str255;
  OriginalDocRef : string;
begin
  LastErDesc:='';
  Result:=0;
  LineRec := P;

  if TestMode then
    ShowMessage ('Ex_StoreTransDtl:' + #13#10 +
                 'P^.TransRefNo: ' + LineRec^.TransRefNo + #13#10 +
                 'PSize: ' + IntToStr(PSize));

  if not Assigned(P) then
    Result := 32767;

  if PSize <> SizeOf(TBatchTLRec) then
    Result := 32766;

  If (Result=0) then
  begin

    OriginalDocRef := LineRec^.TransRefNo;
    { Save the current position in the transaction line file }
    KeyNum := GetPosKey;
    SavedPosOK := Presrv_BTPos(FNum, KeyNum, F[FNum], RecPos, false, false) = 0;

    //PR: 22/02/2012 (COM only) Change to use the record address from the TL record to find the correct line record. ABSEXCH-12017
    {$IFDEF COMTK}
    Result := Presrv_BTPos(FNum, KeyNum, F[FNum], LineRec^.RecordAddress, True, True);
    {$ELSE}
    { Find the transaction line record Key 0 = FolioNo + LineNo }
    //PR 22/12/04 - changed to use AbsLineNo rather than LineNo
    KeyS := FullNomKey(LineRec^.FolioNum) + FullNomKey(LineRec^.AbsLineNo);
    Result := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, 5, KeyS);

    { By chance could bring back a record using FolioNo = 0, LineNo = 0 etc so
      check that the OurRef on the original line matches that brought back }
    if Id.DocPRef <> OriginalDocRef then
      Result := 4;

    {$ENDIF}

    if Result = 0 then { Attempt to lock record }
    {$IFDEF WIN32}
    begin
      if (GetMultiRec(B_GetDirect, B_SingLock, KeyS, 0, FNum, SilentLock, Locked)) then
        Result := 0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result := (GetMultiRec(B_GetDirect, B_SingLock, KeyS, 0, FNum, SilentLock, Locked));
    {$ENDIF}

    if Result = 0 then
      with Id do
      begin
        LineUser1 := LineRec^.LineUser1;
        LineUser2 := LineRec^.LineUser2;
        LineUser3 := LineRec^.LineUser3;
        LineUser4 := LineRec^.LineUser4;


        //PR: 03/01/2012 ABSEXCH-12359
        {$IFDEF COMTK}
        LineUser5 := LineRec^.LineUser5;
        LineUser6 := LineRec^.LineUser6;
        LineUser7 := LineRec^.LineUser7;
        LineUser8 := LineRec^.LineUser8;
        LineUser9 := LineRec^.LineUser9;
       LineUser10 := LineRec^.LineUser10;

        // MH 01/03/2012 v6.10 ABSEXCH-12596: Added Threshold Code for LIVE
        tlThresholdCode := LineRec^.tlThresholdCode;
       {$ENDIF}


        //PR 11/04/03 Added cost apportionment field
        CostApport := LineRec^.CostApport;

        //PR 3/05/07 Added line description
        Desc := LineRec^.Desc;

        {$IFDEF COMTK}
        //PR: 23/02/2012 Added update line date, since the Ex_UpdateLineDate function takes the AbsLineNo as
        //a parameter, so we have no way of reliably finding it if AbsLineNo is 0. ABSEXCH-12017

        //PR: 07/02/2012 Missed out date validation - D'Oh!
        if ValidDate(LineRec^.LineDate) then
          PDate := LineRec^.LineDate
        else
          Result := 30000;
        {$ENDIF}

        if Result = 0 then
          Result := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);

        {$IFNDEF COMTK}
        //PR: 28/10/2011 v6.9
        if Result = 0 then
          AuditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);
        {$ENDIF}
      end;

    { Return to the original position in the transaction header file }
    if SavedPosOK then
      Presrv_BTPos(FNum, KeyNum, F[FNum], RecPos, true, false);
  end; {If Result=0..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(133,Result);

end; { Ex_StoreTransDetl }



{------------------------------------------------------------------------------}

function EX_GETLINETOTAL(P      : POINTER;
                         PSIZE  : SMALLINT;
                         USEDISCOUNT : WORDBOOL;
                         SETTLEDISC : DOUBLE;
                         VAR LINETOTAL : DOUBLE): SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
var
  LineRec : ^TBatchTLRec;
  UseDiscStr : string;
  Res : Integer;
  StockCode : Str255;
  TmpQty : Double;

 function IsApplication(const s : string) : Boolean;
 begin
  Result := (s = 'JPA') or (s = 'JSA') or (s = 'JPT') or (s = 'JST') or (s = 'JCT');
 end;

begin
  LastErDesc:='';
  Result:=0;

  LineRec := P;
  if WordBoolToBool(UseDiscount) then UseDiscStr := 'true' else UseDiscStr := 'false';

  if TestMode then
    ShowMessage ('Ex_GetLineTotal:' + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'UseDiscount: ' + UseDiscStr + #10#13 +
                 'SettleDisc: ' + FloatToStr(SettleDisc));

  if not Assigned(P) then
    Result := 32767;

  if PSize <> SizeOf(TBatchTLRec) then
    Result := 32766;

  If (Result=0) then
  begin

    Result := ExInvLineToId(LineRec^,0);
    if Result = 0 then
      try
        LineTotal := InvLTotal(ID, WordBoolToBool(UseDiscount), SettleDisc);
      except
        on EOverFlow do
        begin
          LineTotal := 0.0;
          Result := 32000; // Error code for overflow which has been trapped
        end;
      end;

  end; {if result=0..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(127,Result);

end; { EX_GETLINETOTAL }

{------------------------------------------------------------------------------}

FUNCTION EX_CALCLINETAX(P          : POINTER;
                        PSIZE      : SMALLINT;
                        SETTLEDISC : DOUBLE): SMALLINT;

var
  LineRec    : ^TBatchTLRec;
  UseDiscStr : string;
  InclusiveTax : Boolean;
  DecPlaces : Byte;
  OurRefType : string;
begin

  LastErDesc:='';
  LineRec := P;
  Result:=0;

  if TestMode then
    ShowMessage ('EX_CALCLINETAX:' + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'SettleDisc: ' + FloatToStr(SettleDisc));

  if not Assigned(P) then
    Result := 32767;

  if PSize <> SizeOf(TBatchTLRec) then
    Result := 32766;

  If (Result=0) then
  begin
    Result := ExInvLineToId(LineRec^,0);
    //PR: 09/04/2002
    //Make sure split pack fields are set from stock record
    SetSplitPackStockDetails;
    if Result = 0 then
    begin
      OurRefType := Copy(LineRec^.TransRefNo, 1, 3);
      if Length(OurRefType) = 3 then
      begin
        if OurRefType[1] = 'S' then
          DecPlaces := Syss.NoNetDec
        else
          DecPlaces := Syss.NoCosDec;
      end
      else
        DecPlaces := Max(Syss.NoNetDec, Syss.NoCosDec);

      InclusiveTax := LineRec^.VATCode = 'I';

      CalcVAT(ID, SettleDisc);

      // HM 06/10/00: Modified to return specific fields, otherwise unexpected changes
      // are made to the lines:- ABSLineNo is set, etc...
      //IdToExId(LineRec^);
      With LineRec^ Do Begin
        // Return VAT Code if valid - may have changed if Inclusive VAT, etc...
        If (VATCode In VATSet) then VATCode := ID.VATCode;

        //Call calcvat again if necessary
        if InclusiveTax and (SettleDisc <> 0.0) then
          CalcVAT(ID, SettleDisc);
        // Return Calculated VAT
        VAT := ID.VAT;

        // Return Unit Price - will have changed if inclusive VAT (+ IncNetValue 9/9/02)

        NetValue := Round_Up(ID.NetValue, DecPlaces);
        IncNetValue := ID.IncNetValue;

      End; { With LineRec^ }
    end;{if}
  end; {If Result=0..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(144,Result);

end; { Ex_CalcLineTax..}

{------------------------------------------------------------------------------}

{ To return the VAT code should both customer record and stock record
  have the default VAT Code }

FUNCTION EX_GETCORRECTVATCODE(P : POINTER; PSize : SMALLINT): smallint;

var
  VATRec : ^TVATCodeDefaultType;

begin

  Result:=0;
  VATRec := P;

  if TestMode then
    ShowMessage ('EX_GETCORRECTVATCODE:' + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13);

  if not Assigned(P) then
    Result := 32767;

  if PSize <> SizeOf(TVATCodeDefaultType) then
    Result := 32766;

  If (Result=0) then
  With VATRec^ do
    DefaultVATCode := Correct_PVAT(StockVATCode, AccountVATCode);

end; {EX_GETCORRECTVATCODE..}

{------------------------------------------------------------------------------}

Procedure EX_SETCALCLINECOUNT(WantCount : WordBool);
Begin
  LastErDesc:='';
  WantCalcLineCount := WordBoolToBool(WantCount);
End; { EX_SETCALCLINECOUNT }

{------------------------------------------------------------------------------}
{ Check the status of Trans. to be updated.
  Ex_GetRecordAddress and Ex_GetRecWithAddress should be used
  before and after using this function. }

FUNCTION EX_TRANCANBEUPDATED(DOCREF   :  PCHAR)  :  SMALLINT;
Const
  Fnum    = InvF;
  KeyPath = InvOurRefK;

Var
  VAlidCheck,
  ValidHed,
  ViewOnlyRec  :  Boolean;

  KeyS         :  Str255;
  ViewCode     :  Byte;
  RtnStat,
  ExStat       :  Integer;

Begin

  LastErDesc:='';
  ExStat:=0;
  RtnStat:=0;
  ViewCode:=0;
  ValidCheck:=BOn;
  ValidHed:=BOff;

  KeyS:=StrPas(DocRef);
  KeyS:=LJVar(KeyS,DocLen);

  ExStat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  ValidCheck:=(ExStat=0);

  GenSetError(ValidCheck,30001,RtnStat,ValidHed);

  if ValidCheck then
  begin
    //PR: 5/9/02 Copied this check from ExInvToInv as we weren't checking doc type
    //PR 5/12/07 Added TSH
    ValidCheck:=(ValidCheck) and (Inv.InvDocHed In [SOR,SDN,SIN,POR,PDN,PIN,ADJ,PCR,PQU,SQU,SCR,PJI,PJC,SJI,SJC,WOR,WIN
                               {$IFDEF COMTK},TSH,JPT, JCT, JST, JPA, JSA, PRN, SRN{$ENDIF}]);
    GenSetError(ValidCheck,30002,RtnStat,ValidHed);
  end;


  If (ValidCheck) then
  begin
    { If this has to be changed,
      View_Status used in Ex_StoreTrans should also be changed !}
    ViewOnlyRec:=(View_Status(Inv,False,ViewCode));
    {30.11.2000 - ViewCode=4 has been allowed - Printed }
    ValidCheck:=((Not ViewOnlyRec) or (ViewCode=9) or (ViewCode=3) or (ViewCode=4));

    GenSetError(ValidCheck,30002,RtnStat,ValidHed);
  end; {if..}

  If (RtnStat<>0) then
    LastErDesc:=Ex_ErrorDescription(130,RtnStat);

  EX_TRANCANBEUPDATED:=RtnStat;

end; {Ex_TranCanBeUpdated..}

{* 13.06.2000 - A copy of Conv_TCurr for internal use *}

FUNCTION EX_CONV_TCURR(P      : POINTER;
                       PSIZE  : SMALLINT) :  SMALLINT;
Var
  ConvTRec  :  ^TBatchConvTCurr;
  TRtnVal   :  Double;
  TConvTo   :  Boolean;

begin

  LastErDesc:='';

  ConvTRec := P;
  TRtnVal:=0;
  Result:=0;

  If TestMode then
    ShowMessage ('Ex_Conv_TCurr:' + #10#13 +
                 'PSize: ' + IntToStr(PSize));

  If (Assigned(P)) then
  With ConvTRec^ do
  begin

    TConvTo:=WordBoolToBool(ConvTo);
    TRtnVal:=Conv_TCurr(Amount,Rate,AmtCurr,ConvMode,TConvTo);

    RtnValue:=TRtnVal;

  end
  else
    Result := 32767;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(136,Result);

end; {Ex_Conv_Tcurr..}

{ 12.09.2000 - Added to return the TH total with variance }

FUNCTION EX_CALCULATETRANSTOTAL(THOurRef     :  PChar;
                                UseVariance  :  WordBool;
                                UseRoundUp   :  WordBool;
                            VAR TotalValue   :  Double)  :  SmallInt;
Var
  TmpStr   :  Str255;
  RtnStat,
  KeyNum   :  Integer;
  RecPos   :  LongInt;

  Validcheck,
  ValidHed,
  SavedPosOk  :  Boolean;

begin
  Result := 0;
  LastErDesc:='';

  RtnStat:=0;
  TmpStr:=StrPas(THOurRef);

  {Save the record position }
  KeyNum := GetPosKey;
  SavedPosOK := Presrv_BTPos(InvF, KeyNum, F[InvF], RecPos, False, False) = 0;

  {Find the TH record }
  Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,TmpStr);
  ValidCheck:=(Status=0);
  GenSetError(Validcheck,30001,RtnStat,ValidHed);

  If (ValidCheck) then
  begin
    TotalValue:=ConvCurrITotal(Inv,BOff,WordBoolToBool(UseVariance),WordBoolToBool(UseRoundUp));
  end; {if..}

  {Return to the Header record before using this function }
  If (SavedPosOK) then
    Presrv_BTPos(InvF, KeyNum, F[InvF], RecPos, True, False);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(142,Result);

  Ex_CalculateTransTotal:=RtnStat;
end; {Ex_CalculateTransTotal..}

{------------------------------------------------------------------------------}

{$IFDEF COMTK}
  // Converts an String containing a VAT Code into an Toolkit VAT array index
  Function VatCharToIdx(Index : ShortString) : SmallInt;
  Var
    VATChar : Char;
//    I       : Integer;
  Begin { VatCharToIdx }
    Result := -1;

    // Extract first character of string
    VATChar := ExtractChar(Index, #255);

    //PR 26/10/05 Change to allow A & D to be used
    Result := SmallInt(GetVATNo(VatChar,#0));

    // Run through list of valid VAT Codes to identify index
    {For I := Low(THVatCode) To High(THVatCode) Do
      If (THVatCode[I] = VATChar) Then Begin
        Result := I;
        Break;
      End; { If (THVatCode[I] = VATChar) }

    // Raise exception if invalid
    If (Result = -1) Then
      Raise EUnknownValue.Create ('Invalid VAT Code ' + QuotedStr(Index));
  End; { VatCharToIdx }
{$ENDIF}

{------------------------------------------------------------------------------}

// Added 20/6/00 for Windows Card System
// Changes the DocNosXlate array for compatibility with DOS based EXLINKU systems
PROCEDURE CS_CHANGEDOCTXLATE (PREDOC, POSTDOC : PCHAR);
Var
  sPre, sPost : ShortString;
  I           : DocTypes;
Begin { CS_ChangeDocTxLate }
  sPre := StrPas(PreDoc);
  sPost := StrPas(PostDoc);

  For I := Low(DocCodes) To High(DocCodes) Do Begin
    If (DocCodes[I] = sPre) Then Begin
      DocNosXlate[I] := sPost;
      Break;
    End; { If (DocCodes[I] = sPre) }
  End; { For I }
End; { CS_ChangeDocTxLate }

{------------------------------------------------------------------------------}

{ 16.11.2000 - To update the Due Date filed for the following transactions only :-
  SIN, SCR, SJI, SJC, SRI, SRF, PIN, PCR, PJI, PJC, PPI, PRF }

FUNCTION EX_UPDATEDUEDATE(DOCREFNO    :  PCHAR;
                          NEWDUEDATE  :  PCHAR) :  SMALLINT;
Const
  FNum  =  InvF;

Var
  ValidHed,
  ValidCheck  :  Boolean;

  td,tm,ty     :  Word{Integer};

  TResult,
  KeyNum       : Integer;

  Locked,
  SavedPosOK   : Boolean;
  RecPos       : LongInt;

  KeyS         : Str255;

begin

  LastErDesc:='';
  TResult:=0;
  ValidHed:=BOff;
  ValidCheck:=BOn;

  If TestMode then
    ShowMessage ('Ex_UpdateDueDate:' + #10#13 +
                 'DocRefNo     : ' + DocRefNo + #10#13 +
                 'New Due Date : ' + NewDueDate);


  { Save the current position in the transaction header file }
  KeyNum := GetPosKey;
  SavedPosOK := Presrv_BTPos(FNum, KeyNum, F[FNum], RecPos, false, false) = 0;

  { Find and update the transaction header record }
  KeyS:=LJVar(DocRefNo,DocLen);
  TResult := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, InvOurRefK, KeyS);

  If (TResult=0) then { Attempt to lock record }
  {$IFDEF WIN32}
  begin
    If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked)) then
      TResult:=0;
    // If not locked and user hits cancel return code 84
    if (TResult = 0) and (Not Locked) then
      TResult := 84;
  end;
  {$ELSE}
  TResult:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked));
  {$ENDIF}


  If (TResult=0) then
  begin
    ValidCheck:=(Inv.InvDocHed In [SIN,SCR,SJI,SJC,SRI,SRF,PIN,PCR,PJI,PJC,PPI,PRF]);

    GenSetError(ValidCheck,30001,TResult,ValidHed);

    DateStr(NewDueDate,Td,Tm,Ty);

    ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty>1900));

    GenSetError(ValidCheck,30002,TResult,ValidHed);

    If (TResult=0) then
    begin
      Inv.DueDate:=NewDueDate;
      TResult := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, InvOurRefK);

      {$IFNDEF COMTK}
      //PR: 28/10/2011 v6.9
      if TResult = 0 then
        AuditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);
      {$ENDIF}
    end; {if..}

  end; {Result=0..}

  { Return to the original position in the transaction header file }
  If (SavedPosOK) then
    Presrv_BTPos(InvF, KeyNum, F[FNum], RecPos, True, False);

  If (TResult<>0) then
    LastErDesc:=Ex_ErrorDescription(149,TResult);

  Ex_UpdateDueDate:=TResult;

end; { Ex_UpdateDueDate..}

function EX_REMOVEDISCOUNTS(P      : POINTER;
                         PSIZE  : SMALLINT;
                         USEDISCOUNT : WORDBOOL;
                         SETTLEDISC : DOUBLE;
                         VAR LINETOTAL : DOUBLE): SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
var
  LineRec : ^TBatchTLRec;
  UseDiscStr : string;
begin
  LastErDesc:='';
  Result:=0;

  LineRec := P;
  if WordBoolToBool(UseDiscount) then UseDiscStr := 'true' else UseDiscStr := 'false';

  if TestMode then
    ShowMessage ('Ex_RemoveDiscounts:' + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'UseDiscount: ' + UseDiscStr + #10#13 +
                 'SettleDisc: ' + FloatToStr(SettleDisc));

  if not Assigned(P) then
    Result := 32767;

  if PSize <> SizeOf(TBatchTLRec) then
    Result := 32766;

  If (Result=0) then
  begin

    Result := ExInvLineToId(LineRec^,0);

    if Result = 0 then
      try
        //PR: 19/07/2002
        //Make sure split pack fields are set from stock record before calculating total to add to header
        SetSplitPackStockDetails;
//        LineTotal := InvLTotalND(ID, WordBoolToBool(UseDiscount), SettleDisc, 1);
        LineTotal := InvLTotalND(ID, WordBoolToBool(UseDiscount), SettleDisc, -1);
      except
        on EOverFlow do
        begin
          LineTotal := 0.0;
          Result := 32000; // Error code for overflow which has been trapped
        end;
      end;

  end; {if result=0..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(152,Result);

end; { EX_REMOVEDISCOUNTS }

FUNCTION EX_UPDATEPAYINREF(Const TransRef   : PChar;
                           Const TransLine  : LongInt;
                           Const NewRef  : PChar) : SmallInt;

Var
  Key1, Key2 : Str255;
  InvLocked, IdLocked, FILocked : Boolean;
  LockResult : boolean;
  RNum, TmpQty, TmpUplift, DiscValue               : Double;

  SerNos                         : ^TBatchSRLinesRec;
  SerialRec                      : ^TBatchSerialRec;
  SKey                           : PChar;
  Res, LNo                       : LongInt;
//  I                              : SmallInt;
begin

  LastErDesc:='';

  If TestMode Then Begin
    { Display passed parameters }
    ShowMessage ('EX_UPDATEPAYINREF:' + #10#13 +
                 'TransRef: ' + StrPas(TransRef) + #10#13 +
                 'TransLine: ' + IntToStr(TransLine) + #10#13 +
                 'NewRef: ' + StrPas(NewRef));
  End; { If }

  Result:=32767;

  { Get specified Transaction }
  Key1 := StrPas(TransRef);
  Result := Find_Rec(B_GetEQ, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key1);
  If (Result=0) Then
  Begin
    //PR: 11/11/2010 Extended to include Nominal Transfers
    if (Inv.InvDocHed in [SRC, SRI, NMT] ) then
    begin
      If (Inv.RunNo <= 0) Then
      Begin
        { Lock Transaction }
        InvLocked := False;

        {$IFDEF WIN32}
        LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked);
        // Second condition when user presses 'Cancel'
        if (Not LockResult) or (LockResult and not InvLocked) then
          Result := 84;
        {$ELSE}
          Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked));
        {$ENDIF}

        If (Result=0) And InvLocked Then
        Begin
        { Get specified Transaction Line }
          Key2 := FullNomKey(Inv.FolioNum) + FullNomKey(TransLine);
          Result:=Find_Rec(B_GetEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, Key2);
          If (Result=0) Then
          Begin
            if Id.PostedRun <= 0 then
            begin
              { Lock Transaction Line }
              IdLocked := False;
              {$IFDEF WIN32}
                LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked);
                // Second condition when user presses 'Cancel'
                if (Not LockResult) or (LockResult and (not IdLocked)) then
                  Result := 84;
              {$ELSE}
                Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked));
              {$ENDIF}
              If (Result=0) And IdLocked then
              Begin
                { Take copy of original line } //PR: 11/11/2010 Add Nom check
                if (Id.Payment = 'Y') or (Inv.InvDocHed = NMT) then
                begin
{                  if Id.PostedRun <= 0 then}
                    Id.StockCode := Pre_PostPayInKey(PayInCode,NewRef);
{                  else
                    Id.StockCode := Full_PostPayInKey(PayInCode, Id.NomCode, Id.Currency, NewRef);}

                  Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
                  //Unlock line
                  Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
                end
                else
                begin
                  Result := 30005;
                  Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
                end;
              end;
            end
            else
              Result := 30002; //Transaction has been posted
          end
          else
            Result := 30004; //Can't find line
          If InvLocked Then Begin
            { Unlock Transaction header }
            Status:=Find_Rec(B_Unlock,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,Key1);
          end;
        end;
      end
      else
        Result := 30002;//Transaction has been posted}
    end
    else
      Result := 30001; //Transaction not SRC or SRI

  end;

  //PR: 28/10/2011 v6.9
  if Result = 0 then
    AuditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(158,Result);

end; {EX_UPDATEPAYINREF}

FUNCTION EX_RESETLINESERIALCOUNT(Const TransRef   : PChar;
                                 Const AbsLineNo  : LongInt) : SmallInt;
                         {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
Var
  Key1, Key2, ADate          : Str255;
  StkLocked,
  InvLocked, IdLocked, FILocked : Boolean;
  LockResult : boolean;
//  I                              : SmallInt;
begin

  LastErDesc:='';


  Result:=32767;

  //Check date
  begin
    { Get specified Transaction }
    Key1 := StrPas(TransRef);
    Result := Find_Rec(B_GetEQ, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key1);
    If (Result=0) Then
    Begin

      { Lock Transaction }
      InvLocked := False;

      {$IFDEF WIN32}
      LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked);
      // Second condition when user presses 'Cancel'
      if (Not LockResult) or (LockResult and not InvLocked) then
        Result := 84;
      {$ELSE}
        Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked));
      {$ENDIF}

      If (Result=0) And InvLocked Then
      Begin
      { Get specified Transaction Line }
        Key2 := FullNomKey(Inv.FolioNum) + FullNomKey(AbsLineNo);
        Result:=Find_Rec(B_GetEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, Key2);
        If (Result=0) Then
        Begin
            { Lock Transaction Line }
            IdLocked := False;
            {$IFDEF WIN32}
              LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked);
              // Second condition when user presses 'Cancel'
              if (Not LockResult) or (LockResult and (not IdLocked)) then
                Result := 84;
            {$ELSE}
              Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked));
            {$ENDIF}
            If (Result=0) And IdLocked then
            Begin
              Id.SerialQty := 0;
              Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
              //Unlock line
              Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
            end;
        end
        else
          Result := 30004; //Can't find line
        If InvLocked Then Begin
          { Unlock Transaction header }
          Status:=Find_Rec(B_Unlock,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,Key1);
        end;
      end;

    end;
  end;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(213,Result);

end; {EX_UPDATELINEDATE}


FUNCTION EX_UPDATELINEDATE(Const TransRef   : PChar;
                           Const AbsLineNo  : LongInt;
                           Const NewDate    : PChar) : SmallInt;

Var
  Key1, Key2, ADate          : Str255;
  StkLocked,
  InvLocked, IdLocked, FILocked : Boolean;
  LockResult : boolean;
//  I                              : SmallInt;
begin

  LastErDesc:='';

  If TestMode Then Begin
    { Display passed parameters }
    ShowMessage ('EX_UPDATELINEDATE:' + #10#13 +
                 'TransRef: ' + StrPas(TransRef) + #10#13 +
                 'AbsLineNo: ' + IntToStr(AbsLineNo) + #10#13 +
                 'NewDate: ' + StrPas(NewDate));
  End; { If }

  Result:=32767;

  //Check date
  ADate := StrPas(NewDate);
  if ValidDate(ADate) then
  begin
    { Get specified Transaction }
    Key1 := StrPas(TransRef);
    Result := Find_Rec(B_GetEQ, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key1);
    If (Result=0) Then
    Begin

      { Lock Transaction }
      InvLocked := False;

      {$IFDEF WIN32}
      LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked);
      // Second condition when user presses 'Cancel'
      if (Not LockResult) or (LockResult and not InvLocked) then
        Result := 84;
      {$ELSE}
        Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked));
      {$ENDIF}

      If (Result=0) And InvLocked Then
      Begin
      { Get specified Transaction Line }
        Key2 := FullNomKey(Inv.FolioNum) + FullNomKey(AbsLineNo);
        Result:=Find_Rec(B_GetEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, Key2);
        If (Result=0) Then
        Begin
            { Lock Transaction Line }
            IdLocked := False;
            {$IFDEF WIN32}
              LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked);
              // Second condition when user presses 'Cancel'
              if (Not LockResult) or (LockResult and (not IdLocked)) then
                Result := 84;
            {$ELSE}
              Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked));
            {$ENDIF}
            If (Result=0) And IdLocked then
            Begin
              Id.PDate := ADate;
              Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
              //Unlock line
              Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);

            {$IFNDEF COMTK}
            //PR: 28/10/2011 v6.9
            if Result = 0 then
              AuditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);
            {$ENDIF}
            end;
        end
        else
          Result := 30004; //Can't find line
        If InvLocked Then Begin
          { Unlock Transaction header }
          Status:=Find_Rec(B_Unlock,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,Key1);
        end;
      end;

    end;
  end
  else
    Result := 30000;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(212,Result);

end; {EX_UPDATELINEDATE}

//================================================================================================================
//======================  JAP Tranasactions   ====================================================================
//================================================================================================================
Function ValidateJAPHeader(SMode  :  Integer;
                           OldInv :  InvRec)  :  Integer;

Var
  ECRec,
  ValidCheck,
  ValidHed     :  Boolean;

  td,tm,ty     :  Word{Integer};
  VT	       :  VATType;

  HedVAT       :  Double;

begin
  Result:=0;
  ECRec:=BOff;      { EC Account }
  HedVAT:=0;

  With Inv do
  begin

(*    ValidCheck:=((Not ExSyss.CheckDupli)
                 or (Not (CheckExsists(LJVar(YourRef,LogInLen),InvF,InvYrRefK))));

    GenSetError(ValidCheck,30200,Result,ValidHed); *)

    //Check that it's an apps & vals transaction
    ValidCheck:=(InvDocHed In JAPSplit);

    GenSetError(ValidCheck,30201,Result,ValidHed);


    { ----------------------------------- }

    {* Check Employeee Code - for TSH trans. *}
    If  (InvDocHed In [JCT, JPA]) then
    Begin
      ValidCheck:=CheckRecExsists(JARCode+JAECode+LJVar(CISEmpl,AccLen),JMiscF,JMK);
      GenSetError(ValidCheck,30210,Result,ValidHed);

      if ValidCheck then
      begin
        ValidCheck := JobMisc^.EmplRec.EType = 2; //Sub-Contractor
        GenSetError(ValidCheck,30226,Result,ValidHed); (* JAPERR *)

        if ValidCheck then
          CustCode := JobMisc^.EmplRec.Supplier;

      end;

      if ValidCheck and (JAPParentType = JCT) and (Inv.TransMode > 0) then
      //check that employee is the same as for contract terms
      begin
        ValidCheck := Trim(CISEmpl) = Trim(JAPParentEmployee);
        GenSetError(ValidCheck,30227,Result,ValidHed); (* JAPERR *)
      end;

    end;

    If ((ValidCheck) and (Not (InvDocHed In [JPT]) or
                              ((InvDocHed in [JST]) and (Trim(CustCode) <> '')))) then
    Begin

      ValidCheck:=(CheckRecExsists(CustCode,CustF,CustCodeK));

      ValidCheck:=((ValidCheck) and (Cust.CustSupp=TradeCode[(InvDocHed In SalesSplit + WOPSplit + JAPSalesSplit)]));

      GenSetError(ValidCheck,30202,Result,ValidHed);

      ECRec:=(ValidCheck) and (Cust.EECMember); { For SSDProcess Flag }

    end
    else
      CustCode:=LJVar('',AccLen);

    if ValidCheck and (InvDocHed in [JPA, JSA]) then
    begin
      ValidCheck := TransMode >= JAPParentStage;

      GenSetError(ValidCheck, 30228, Result, ValidHed); (* JAPERR *)
    end;

    { ---------------------------------- }
    { JobCode and AnalCode check for other Transaction Code - SIN, PIN etc..}

    If  ValidCheck then
    Begin
       ValidCheck:=(EmptyKey(DJobAnal,JobCodeLen));

       If Not (ValidCheck) then
       Begin
         DJobAnal:=FullJobCode(DJobAnal);
         ValidCheck:=(CheckRecExsists(JARCode+JAACode+DJobAnal,JMiscF,JMK));
         GenSetError(ValidCheck,30212,Result,ValidHed);
       end;
    end;

    if ValidCheck then
    begin
       ValidCheck:=(CheckRecExsists(DJobCode,JobF,JobCodeK)) and not EmptyKey(DJobCode,JobCodeLen);

       GenSetError(ValidCheck, 30111, Result, ValidHed);
    end;

    if ValidCheck then
    begin
      ValidCheck := JobRec^.JobStat <> 4;

      GenSetError(ValidCheck,30126,Result,ValidHed);
    end;

    { ---------------------------------- }

    {* Check Date *}

    {Old}DateStr(TransDate,Td,Tm,Ty);

    ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

    GenSetError(ValidCheck,30203,Result,ValidHed);

    {* Check Period/Yr *}

    //PR 14/7/04 - added check so that period on trans being updated is not changed
    If (ValidCheck) and (ExSyss.AutoSetPr) and (SMode <> B_UPdate) then
    Begin
      (* HM Updated Period Calculation to do same as Enterprise
      AcPr:=Fin_Pr(TransDate);
      AcYr:=TxlateYrVal(Fin_Yr(TransDate), BOn);
      *)
      SimpleDate2Pr(TransDate, AcPr, AcYr);
    end;

    ValidCheck:=((AcPr>=1) and (AcPr<=Syss.PrInYr));
    GenSetError(ValidCheck,30204,Result,ValidHed);

    ValidCheck:=((AcYr<>0));
    GenSetError(ValidCheck,30205,Result,ValidHed);


    {* Add Stk&TSTSplit, deleted [SRC,PPY] 18/04/2000 *}


    If (ValidCheck) and (Not (InvDocHed In NomSplit+StkAdjSplit+TSTSplit)) then
    Begin
      {* Check Due Date *}

      //PR 6/12/01 Check due date for wor/win transactions
      if not (InvDocHed in WOPSplit) then
      begin
      { 01.07.99 - To calculate DueDate with Payment Terms }
        If (UpperCase(DueDate)=DueDateSwitch) then
          DueDate:=CalcDueDate(TransDate,Cust.PayTerms)
        else
        begin
          {Old }DateStr(DueDate,Td,Tm,Ty);

          ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

          If (Not ValidCheck) then
          begin
            DueDate:=TransDate;
            ValidCheck:=BOn;
          end;

        end; {if..}
      end
      else
      begin
        //WOP trans
        {Old }DateStr(DueDate,Td,Tm,Ty);

        ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

        If (Not ValidCheck) then
        begin
          DueDate:=TransDate;
          ValidCheck:=BOn;
        end;

      end;
    end; {if..}

    {* Added on 06/05/98 *}

    If (InvDocHed In OrderSet) then
      BatchLink:=QUO_DelDate(InvDocHed,DueDate);

    {* changed from 4 to 11 on 10.06.97 *}
    {* Rate11 to Rate 18 in v4.31 *}
    For VT:=Standard to Rate18 do
      HedVAT:=HedVAT+InvVATAnal[VT];

    {* Check VAT Split *}

    {$IFDEF COMTK}
    if not (InvDocHed in BatchSet) then
    {$ENDIF}
    begin
      ValidCheck:=(Round_Up(HedVAT,2)=Round_Up(InvVAT,2));
      GenSetError(ValidCheck,30206,Result,ValidHed);
    end;

    {* Check Currency *}

    If (ExSyss.MCMode) then
    begin
      ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
      {* 18.08.99 - Added to use Default Currency *}
      If (Not ValidCheck) then
      begin
        Currency:=ExSyss.DefCur;
        ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
      end;
    end
    else
      ValidCheck:=BOn;

    GenSetError(ValidCheck,30207,Result,ValidHed);

    If (ExSyss.MCMode) then {* Check Currency Rates *}
    Begin

     {* 06.01.99 - Added this condition when Euro conversion was tested
                    with EL's advice *}
//      If (ExSyss.UseExCrRate) or not UseCoDayRate then {* OverWrite Currency Rates *}
      begin
        CXrate:=SyssCurr^.Currencies[Currency].CRates;
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end;

      {* 01.04.99 - Ent. v4.30a validates these fields *}
      VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;
      SetTriRec(Syss.VATCurr,UseORate,CurrTriR); { for 4.31 }

      OrigRates:=SyssCurr^.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,OrigTriR); { for 4.31 }

      ValidCheck:=(CXRate[BOn]<>0);
      GenSetError(ValidCheck,30208,Result,ValidHed);

      If (Not UseCoDayRate) then
      Begin
	ValidCheck:=(CXRate[BOff]<>0);
        GenSetError(ValidCheck,30209,Result,ValidHed);
      end;

      // HM 06/03/01: Added eBusiness Mode check - as 0 rate was causing problem posting from eBus into Ent
//      If (Not (Inv.InvDocHed In NomSplit)) And (Not InEbusinessMode) then
      //PR: 13/08/2010 Added extra transaction types for which company rate should not be set to zero
      If (Not (Inv.InvDocHed In SetCompanyRateSet)) And (Not InEbusinessMode) then
      begin
        CXRate[BOff]:=0;  {* Set to 0 eventualy regardless of stored value, as always left floating *}
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end;

    end
    else
    Begin
      Currency:=0;
      CXrate:=SyssCurr^.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
    end;

    {* Debtor/Creditor Control Nominal Code  *}
    If (CtrlNom<>0) then
    begin
      ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(CtrlNom)),NomF,NomCodeK));

      ValidCheck:=((ValidCheck) and (Nom.NomType In [CtrlNHCode])
                    and (CtrlNom<>Syss.NomCtrlCodes[Debtors])
                    and (CtrlNom<>Syss.NomCtrlCodes[Creditors]));

      GenSetError(ValidCheck,30213,Result,ValidHed);
    end
    else
    begin
      ValidCheck:=(CheckRecExsists(CustCode,CustF,CustCodeK));
      If (ValidCheck) and (Cust.DefCtrlNom<>0) then
      begin
        CtrlNom:=Cust.DefCtrlNom;
        ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(CtrlNom)),NomF,NomCodeK));

        ValidCheck:=((ValidCheck) and (Nom.NomType In [CtrlNHCode])
                      and (CtrlNom<>Syss.NomCtrlCodes[Debtors])
                      and (CtrlNom<>Syss.NomCtrlCodes[Creditors]));
        GenSetError(ValidCheck,30214,Result,ValidHed);

        {* 05.01.99 - 30215 is for TransDocHed Validation *}
      end;

    end; {if ..}

    {* Ver 4.31 validation *}
    {* Check SSDProcess *}
    ValidCheck:=BOn;
    If (ECRec) then
      ValidCheck:=(SSDProcess In [#0,#32,'T','P'])
    else
      SSDProcess:=#32;
    GenSetError(ValidCheck,30216,Result,ValidHed);

    // HM 07/09/01 (v4.40/v5.00?): Added validation of new fields
    ValidCheck := (Tagged <= 99);
    GenSetError(ValidCheck,30218,Result,ValidHed);

    //PR 06/12/01 Added check for location in wop
    if (InvDocHed in WOPSplit) and ExSyss.UseMLoc then
    begin
      ValidCheck := CheckRecExsists(CostCCode+CSubCode[BOn] + LJVar(DelTerms, MLocLen), MLocF, MLK);

      GenSetError(ValidCheck, 30219, Result, ValidHed);
    end;

    {$IFDEF COMTK}
    if RunNo = -2 then
    begin
      //what checks do we need here?
      if AutoIncBy = 'D' then
      begin
        DateStr(UntilDate,Td,Tm,Ty);

        ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

        GenSetError(ValidCheck,30220,Result,ValidHed);
      end
      else
      begin
      {* Check Period/Yr *}


        ValidCheck:=((UnPr>=1) and (UnPr<=Syss.PrInYr));
        GenSetError(ValidCheck,30221,Result,ValidHed);

        ValidCheck:=((UnYr<>0));
        GenSetError(ValidCheck,30222,Result,ValidHed);
      end;
    end;

    if (InvDocHed in BatchSet) and (BatchNom <> 0) then
    begin
      ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(BatchNom)),NomF,NomCodeK));

      GenSetError(ValidCheck,30223,Result,ValidHed);
    end;
    {$ENDIF}

  end; {with..}
end; {ValidateHeader..}

//PR 8/04/03 Added LineDisc parameter to pass total line discount back to caller
Function ValidateEachJAPTL(    Mode         :  Byte;
                           Var ImpVariance  :  Double;
                           Var LineDir      :  Double;
                           Var LineNet      :  Double;
                           Var TmpJAType,
                               TmpCurrCharge:  Byte;
                           Var TmpChargeType:  SmallInt;
                           Var VJActual     :  Boolean;
                           Var LineDisc     :  Double;
                           Var LineVat      :  Double)  :  Integer;

Const
  YN : Array[BOff..BOn] of String[3] = ('No','Yes');

Var

  TBo,
  RepBO,
  ValidCheck,
  ValidHed    :  Boolean;

{  LineCost,
  LineWeight,}
{  LineVAT,}
  LineTot,
  TmpQty,
  TmpNetValue,
  TmpXRate
               :  Double;

  TmpSSD,
  ErrSSDCode    :  LongInt;

  TmpBudg       :  String[27]; { to check for Emp.Pay Rate }

  UOR           :  Byte;

  KeyF          :  Str255;

  WopNomCode    :  longint; //for Works Order processing
  WOPTempStock  :  StockRec;
  TmpDisc,
  TotNoDisc     :  Double;
  TmpLineDisc   :  Double;
  TmpLineVat    :  Double;
  i, j : integer;
  TmpQtyM : Double;
  TmpID : IDetail;
  Budget : Double;
  KeyS : Str255;
begin
  Result:=0;
  ValidCheck:=BOn;  ValidHed:=BOff;
  Budget := 0;
  TmpXRate := 0;
  TBo:=BOff;        RepBo:=BOff;

//  LineVAT:=0;  LineTot:=0;
  {LineCost:=0; LineWeight:=0;}
  UOR:=0;

  With Id do
  begin

    {* Check Currency *}

    If (ExSyss.MCMode) and (Inv.InvDocHed In NomSplit+RecieptSet) then
    begin
      ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
      {* 18.08.99 - Added to use Default Currency *}
      If (Not ValidCheck) then
      begin
        Currency:=ExSyss.DefCur;
        ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
      end;
    end; {if..}
    GenSetError(ValidCheck,30100,Result,ValidHed);

    {* Check Currency Rates *}
    If (ExSyss.MCMode) then
    Begin
      {* 06.01.99 - Added this condition when Euro conversion was tested with EL's advice *}
      If (ExSyss.UseExCrRate) or not UseCoDayRate then {* OverWrite Currency Rates *}
      begin
        CXrate:=SyssCurr^.Currencies[Currency].CRates;
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end; {if..}

      (*
      {* 01.04.99 - Ent. v4.30a validates these fields *}
      VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;
      OrigRates:=SyssCurr^.Currencies[Currency].CRates;
      *)

      ValidCheck:=((CXRate[BOn]<>0) or (Inv.InvDocHed In StkAdjSplit));

      GenSetError(ValidCheck,30101,Result,ValidHed);

      {05.09.2000 - closed and added the following condition according to EL's advice.
      If (Not UseCoDayRate) or (Inv.InvDocHed In NomSplit) then}
      If ((Not UseCoDayRate) and (ExSyss.UseExCrRate)) or (Inv.InvDocHed In NomSplit) then
      Begin
        ValidCheck:=((CXRate[BOff]<>0) or (Inv.InvDocHed In StkAdjSplit));
        GenSetError(ValidCheck,30102,Result,ValidHed);
      end;

      {* 06.01.99 - Added with EL's Advice *}
      // HM 06/03/01: Added eBusiness Mode check - as 0 rate was causing problem posting from eBus into Ent
//      If (Not (Inv.InvDocHed In NomSplit)) And (Not InEbusinessMode) then {* Set to floating *}
      //PR: 13/08/2010 Added extra transaction types for which company rate should not be set to zero
      If (Not (Inv.InvDocHed In SetCompanyRateSet)) And (Not InEbusinessMode) then {* Set to floating *}
      begin
        CXRate[BOff]:=0;
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end;

    end
    else
    Begin
      Currency:=0;
      CXrate:=SyssCurr^.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
    end; {Check Currency Rate..}

    {* LineNo *}
    ValidCheck:=(LineNo>0) or (Inv.InvDocHed in JAPSplit);
    GenSetError(ValidCheck,30103,Result,ValidHed);

    {* Discount Code Check *}

    ValidCheck:=(DiscountChr In StkBandSet+[#0,#32,PcntChr]); (* JAPCHK *)

    GenSetError(ValidCheck,30108,Result,ValidHed);





    TmpQty:=Round_Up(Qty,Syss.NoQtyDec);
    // HM 27/11/01: Modified to check transaction type before rounding NetValue
    If (IdDocHed In SalesSplit) Then
      // Sales
      TmpNetValue:=Round_Up(NetValue,Syss.NoNetDec)
    Else
      If (IdDocHed = NMT) Then
        // Nominal Transfer
        TmpNetValue:=Round_Up(NetValue,2)
      Else
        // ADJ/Purchase
        TmpNetValue:=Round_Up(NetValue,Syss.NoCOSDec);

//    LineTot:=Round_Up((TmpQty*TmpNetValue),2);
      //PR 08/04/03 Find line discount by subtracting tot with disc from tot w/out disc
      TotNoDisc := InvLTotal(ID, {Inv.DiscTaken}False, {Inv.DiscSetl}0.0);
      LineTot := InvLTotal(ID, {Inv.DiscTaken}True, {Inv.DiscSetl}0.0);

      TmpDisc := TotNoDisc - LineTot;
//      LineTot := InvLTotal(ID, {Inv.DiscTaken}False, Inv.DiscSetl);
//      LineTot := InvLTotalND(ID, {Inv.DiscTaken}False, Inv.DiscSetl, -1);



    {* Add Doc Line Type Total Here ... 19.11.97 *}
{    If (DocLTLink>0) then     //Check this out later
    begin
      Case DocLTLink of
        7  :  j := 1;
        9  :  j := 2;
       10  :  j := 3;
       11  :  j := 4;
       13  :  j := 5;
       15  :  j := 6;
       else
         j := 0;
      end;

      if j > 0 then
        Inv.DocLSplit[j]:=Inv.DocLSplit[j]+CostPrice;
    end;
 }
    {* do not include in total check, as its a variance line *}
    If ((Inv.InvDocHed In RecieptSet) and (NomCode=Syss.NomCtrlCodes[CurrVar]) and (ExSyss.MCMode)) then
    Begin
      ImpVariance:=ImpVariance+LineTot; {* Calculate variance contribution *}
    end
    else
      {* Do Not Include Direct Payment Parts *}
      If ((Payment<>DocPayType[SRC]) or (Not (Inv.InvDocHed In DirectSet))) then
      Begin
        begin
          if Inv.InvDocHed = NMT then
          begin
            TmpLineVat := Round_Up(Conv_TCurr(VAT,TmpXRate,Currency,0,BOff),2);
            LineVAT:=LineVAT+TmpLineVat;
          end
          else
            LineVat := LineVAT + Vat;
          LineNet:=LineNet+LineTot;
          LineDisc := LineDisc + TmpDisc;

        end;

        HeaderWeight:=HeaderWeight + Round_Up((LWeight*Qty),2);

      end; {if..}



    {* Cost Centre/Dep Check *}
    {* Add validation 19.2.97 *}
    // HM 28/06/02: Extended as current checks are allowing unset CC/Depts through and removing set CC/Depts
    If ValidCheck Then Begin
      // Check whether we need to check the CC/Dept
      If Syss.UseCCDep Then Begin
        If (Not (Inv.InvDocHed In StkAdjSplit+NomSplit)) and (LineTot=0) and
                 (CostPrice=0) and not ((LineNo = -2) or (LineNo = -3)) Then Begin
          // Not an ADJ or NOM and the Line Total and Cost Price are zero
          // No Validation - let anything go through
        End { If }
        Else Begin
          // Validate CC/Dept Codes fully
          For Tbo := BOff to BOn Do Begin
            RepBo:=BOff;
            Repeat
              KeyF:=(CostCCode+CSubCode[TBo]+CCDep[TBo]);
              Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyF);

              ValidCheck:=(Status=0);

              If (Not ValidCheck) then //Take from ini file
                CCDep[Tbo]:=ExSyss.DefCCDep[Tbo];

              RepBo:=Not RepBo;

            Until (Not RepBo) or (ValidCheck);
            GenSetError(ValidCheck,30105,Result,ValidHed);

            If (Not ValidCheck) Then Break;
          End; { For Tbo}
        End; { Else }
      End { If Syss.UseCCDep }
      Else Begin
        // CC/Depts turned off - blank out CC/Dept on line
        CCDep[BOn] := '';
        CCDep[Tbo] := '';
      End; { Else }
    End; { If ValidCheck }



    VJActual:=BOff; {* for Job Actual *}
    {* JobCode checking *}
    {* Stock Code checking for TSH *}
    {* Check AnalCode in AnalRec of JobMiscFile. If valid, *}
    {* check StockCode(EmpPayRate) in EmplPayRec of JobCtrlFile *}

//    If (Not ExSyss.JBIgnore) then
    begin

      begin

        Begin
          ValidCheck:=(CheckRecExsists(JobCode,JobF,JobCodeK) and not (Trim(JobCode) = '')) or
                                                                    ((LineNo = -2) and (Discount = 0));

          If (ValidCheck) then
          begin
            TmpCurrCharge:=JobRec^.CurrPrice;  {for Job Actual Rec.}
            TmpChargeType:=JobRec^.ChargeType; {for Job Actual Rec.}
            VJActual:=BOn;
          end;

          GenSetError(ValidCheck,30111,Result,ValidHed);
        end;

        ValidCheck:=(EmptyKey(AnalCode,JobCodeLen)) and ((LineNo = -2) and (Discount = 0));

        If (Not ValidCheck) then
        Begin
          ValidCheck:=(CheckRecExsists(JARCode+JAACode+AnalCode,JMiscF,JMK));

          TmpJAType:=JobMisc^.JobAnalRec.AnalHed; {for Job Actual Rec.}

          GenSetError(ValidCheck,30112,Result,ValidHed);
        end; {if..}

      end;

      { 28.09.2000 - To use appropriate NomCode depending on Job Status ..}
(*      If (Not EmptyKey(JobCode,JobCodeLen)) and (Not EmptyKey(AnalCode,JobCodeLen)) then
      begin
        //PR 8/9/03 - Should only change on Purchase transactions & not if updating
        if not (Inv.InvDocHed in SalesSplit) and (Mode <> B_Update) then
          NomCode:=Job_WIPNom(NomCode, JobCode, AnalCode, StockCode, MLocStk, Custcode);
      end; {if..}
*)
    end; {if (Not JBIgnore) ..}
    {* --------------------------- *}


    {* VAT Code Check *}

    ValidCheck:=((VATCode<>VATICode) and (VATCode In VATSet));

    {* 18.08.99 - No Default VAT Code line in the INI file !!! *}
    If (Not ValidCheck) then
    begin
      VATcode:=ExSyss.DefVAT;
      ValidCheck:=(((VATCode<>VATICode) and (VATCode In VATSet))
                 or (LineTot=0) or (Payment=DocPayType[SRC]));

    end; {if..}


    GenSetError(ValidCheck,30107,Result,ValidHed);



    {* v4.31 Check CVat Inc. Flag *}
    If (VATCode=VATICode) then
    begin
      ValidCheck:=(VATIncFlg In VATSet-VATEqStd);
      GenSetError(ValidCheck,30119,Result,ValidHed);
    end; {if..}

    if (IdDocHed in [JPA, JSA]) and (LineNo > 0) and (Inv.TransMode > 0) then  //check for over budget
    begin
      KeyS:=FullidKey(SOPLink,SOPLineNo);

      TmpId := ID;
      if CheckRecExsists(KeyS, IDetailF, IdLinkK) then
        Budget := ID.CostPrice
      else
      begin
        ValidCheck := False;
        GenSetError(ValidCheck,30129,Result,ValidHed);
      end;
      ID := TmpId;

                  //Applied + AppliedYTD
      ValidCheck := CostPrice + QtyDel <= Budget;
      GenSetError(ValidCheck,30127,Result,ValidHed);
                 //Certified + CertYTD
      ValidCheck := NetValue + QtyPWoff <= Budget;
      GenSetError(ValidCheck,30128,Result,ValidHed);
    end;

  end; {with..}
end; {VAlidateEachTL..}

Function CheckJAPIdRecordExists(Var IdUpdateStat :  Byte;
                                Var LastID       : IDetail )  :  Integer;
Var
  FoundOK,
  ValidCheck,
  ValidHed     :  Boolean;
  KeyChk,
  KeyF         :  Str255;

  DelvQty      :  Double;
  TmpId,
  TmpId2        :  IDetail;

begin

  Result:=0;
  ValidCheck:=BOn;
  ValidHed:=BOff;

  IdUpdateStat:=1; { As a New Record }
  Fillchar(TmpId,SizeOf(TmpId),#0);

  With Id do
  begin

    KeyF:=FullIdKey(FolioRef,ABSLineNo);
    KeyChk:=KeyF;

    TmpId2 := Id;
    TmpId:=Id;  {New Id information }

    Fillchar(Id,SizeOf(Id),#0);

    Status:=Find_Rec(B_GetEq,F[IdetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,KeyF);
    FoundOk:=(StatusOk) and (TmpId.FolioRef=Id.FolioRef) and (TmpId.ABSLineNo=Id.ABSLineNo);

    If (FoundOK) then
    begin
      IdUpdateStat:=2;  {As an exsting record }
      LastID := ID;


    end; {if FoundOK..}
    If (Result=0) then
    begin
      {Assign ReadOnly fields}
      If (IdUpdateStat=1) then { As a New Record }
      begin
        TmpId2.ABSLineNo:=Inv.ILineCount;
        Inc(Inv.ILineCount);
      end {New Record = 1}
      else
      begin
        TmpId2.ABSLineNo:=Id.ABSLineNo;
        TmpId2.SOPLink:=Id.SOPLink;
        TmpId2.SOPLineNo:=Id.SOPLineNo;
        TmpId2.SerialQty:=Id.SerialQty;   { 05.09.2000 - added, otherwise loose the SerialQty }
      end; {Existing Record = 2}

    end; {if Result=0 ..}

    Id:=TmpId2;

  end; {with Id..}

end; {CheckIdRecordExists..}



Function Validate_JAPLines(    Mode       :  Byte;
                               LineChk    :  LongInt;
                           Var ImpVariance:  Double;
                               P          :  Pointer;
                               SMode      :  SmallInt;
                               EditNo     :  Byte;
                               Var ExLocal   :  TdExLocal)  :  Integer;


Var
  NewIdRec,
  ValidHed,
  ValidCheck,
  VJActual       :  Boolean;

  LineDir,
  TmpXRate,
  ImpBase,
  LineNET,
  LineDisc        :  Double;
  LineVat         :  Double;

  RecSeg,RecOfs,
  RecPos,
  FileRecNo      :  LongInt;

  ExIdRec        :  TBatchTLRec;

  IdUpStat,                    { Update Status }
  TmpJAType,
  TmpCurrCharge :  Byte;       { both for Job Actual Rec. JAType }
  TmpChargeType :  SmallInt;   { for Job Rec's ChargeType }

  KeyF          :  Str255;

  TmpLineNet : Double;
  LastID, TmpId : IDetail;
  TmpInv : InvRec;

Begin
  VatNeededOnNom := False;
  ValidHed:=BOn;  ValidCheck:=BOff;

  LineNET:=0;
  LineDisc := 0;
  ImpBase:=0;
  ImpVariance:=0;
  TmpXRate:=0;
  LineDir:=0;
  Result:=0;
  LineVat := 0;

  HeaderCost:=0;
  HeaderWeight:=0;

  FileRecNo:=1;     {* Inc() is before end of loop *}
  TLLineNo:=1;

  // HM 13/08/01: Re-Initialised the Line Type Totals as this routine is called
  //              twice which was causing the Line Type Totals to be doubled.
  FillChar (Inv.DocLSplit, SizeOf (Inv.DocLSplit), #0);

  If (P<>Nil) then
  Begin
    While (Result=0) and (FileRecNo<=LineChk) do
    Begin

      FillChar(ExIdRec,SizeOf(ExIdRec),#0);

      {* using Ptr Position *}
    {$IFDEF WIN32}
      RecPos:=LongInt(P)+( Pred(FileRecNo)*SizeOf(ExIdRec));
      Move(Pointer(RecPos)^,ExIdRec,SizeOf(ExIdRec));
    {$ELSE}
      RecSeg:=Seg(P^);
      RecOfs:=Ofs(P^);
      RecOfs:=RecOfs + ( Pred(FileRecNo)*SizeOf(ExIdRec) );
      Move(Ptr(RecSeg,RecOfs)^,ExIdRec,SizeOf(ExIdRec) );
    {$ENDIF}


      {* From External TLRec to Id Record *}
      Result:=ExInvLineToId(ExIdRec,SMode);

      If (Result=0) then
      With Id do
      Begin

        If (SMode=B_Update) then
        begin
          {* Check Id record exists and other validations *}

          Result:=CheckJAPIdRecordExists(IdUpStat, LastID);

        end; {If SMode=B_Update..}

        {* Validate Each TL line *}
        If (Result=0) then
          Result:=ValidateEachJAPTL(Mode,ImpVariance,LineDir,LineNet,
                                    TmpJAType,TmpCurrCharge,
                                    TmpChargeType,VJActual, LineDisc, LineVat);

        If (Result=0) and (Mode=1) then
        begin

          Id.DLLUpdate:=EditNo;

          //if deduction or retention then we need to calculate the value if required.
          {$IFDEF COMTK}
          if ((Id.LineNo = -2) or (Id.LineNo = -3)) and {not (Id.LiveUplift)} (Id.DiscountChr = '%') then
          with Id do
          begin
            //Expire retention if necessary

            If (Id.LineNo = -3) and ((Reconcile=2) and (Inv.TransMode=SSDSPUnit) and (Inv.TransMode<>COSNomCode)) and (Inv.InvDocHed In JAPJAPSplit) then {*Expire previous retentions *}
            Begin

              NetValue:=QtyDel;
              CostPrice:=QtyDel*DocNotCnst;
              SSDUpLift:=QtyPWOff*DocNotCnst;

//              IntReverse:=BOn;

              PrxPack:=(Inv.TransNat In [0..2]);   {* Indicates this is a retention expiry so CIS rules based on YTD totals only *}

              Desc:='Expire '+Desc;
              LiveUplift:=BOn;
              NetValue:=NetValue*DocNotCnst;
              CalcVat(Id, 0);
            end
            else
            begin
            //CalcJapRetTotals changes the global id rec so take a temp copy
              TmpId := Id;
              TmpInv := Inv;
              if not Id.LiveUplift then
                TmpId.NetValue := CalcJAPRetTotals(Inv, ID, ExLocal, Abs(Id.LineNo) - 1, JaiMode(Inv))
              else
                TmpId.DiscountChr := #0; //Deduction value has been overridden
              Id := TmpId;
              CalcVat(Id, 0);
              Inv := TmpInv;
              if Inv.PDiscTaken then
                Id.SSDUplift := Id.NetValue
              else
                Id.CostPrice := Id.NetValue;
            end;
          end;
          {$ENDIF}
          If ((SMode=B_Insert) or ((SMode=B_Update) and (IdUpStat=1))) then
          begin

            Result:=Store_EId;  { Update Stock and Store Id line }
            If Result=0 then
            begin
              if VJActual {and not (ID.IdDocHed in [JPT, JPA])} and (ID.LineNo >=0) then
//                Result:=Store_JobActual(TmpJAType,TmpCurrCharge,TmpChargeType);
              Update_JobAct(Id,Inv);
              {$IFDEF COMTK}
              Update_JTLink(Id,Inv, BOff,BOn,3,IdLinkK,0,0);
              {$ENDIF}
            end;
          end {if B_Insert..}
          else
            {Existing Record }
            If ((SMode=B_Update) and (IdUpStat=2)) then
            begin
              //Remove previous values from terms
              {$IFDEF COMTK}
              Update_JTLink(LastId, Inv, BOn,BOn,3,IdLinkK,0,0);
              {$ENDIF}
              //PR 8/01/03 - if line already exists then we need to delete any existing job actual for it
//              Delete_JobAct(Id);
              //Update_JTLink(LastId,BOn,BOn,3,IdLinkK,0,0);

              Result:=Update_EId;
              If Result=0 then
              begin
                if (VJActual) {and not (ID.IdDocHed in [JPT, JPA])} and (ID.LineNo >=0) then
//                  Result:=Store_JobActual(TmpJAType,TmpCurrCharge,TmpChargeType);
                  Update_JobAct(Id,Inv);
                {$IFDEF COMTK}
                Update_JTLink(Id, Inv, BOff,BOn,3,IdLinkK,0,0);
                {$ENDIF}
              end;
            end; {if an Existing Record ..}

        end; {if Result=0 and Mode=1 ..}

      end; {if..}

      If (Result<>0) then
      begin
        ExIdRec.RtnErrCode:=Result;
        {$IFDEF WIN32}
          RecPos:=LongInt(P)+( Pred(FileRecNo)*SizeOf(ExIdRec));
          Move(ExIdRec,Pointer(RecPos)^,SizeOf(ExIdRec));
        {$ENDIF}
      end; {if..}


      Inc(FileRecNo);
      Inc(TLLineNo);

    end; {While..}

    {* Validate Total Fields *}
    {If (Mode=0) then}
    begin
      //PR 08/04/03 Set header discount amount from total of line discounts
      Inv.DiscAmount := LineDisc;

      If (ExSyss.MCMode) and (Inv.InvDocHed In RecieptSet{+NomSplit}) then {* Convert to base equiv *}
      begin
        //PR 3/2/03 Wasn't taking xrate from inv header when use ex currency set to off
        if not ExSyss.UseExCrRate then
        begin
          if not UseCoDayRate then
            TmpXRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency)
          else
            TmpXRate := Inv.CXRate[UseCoDayRate];
        end
        else //use currency from enterprise
          TmpXRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency);

        {ImpBase:=Round_Up(Conv_Curr(Inv.InvNetVal,Inv.CXRate[UseCoDayRate],BOff),2)}
//        TmpXRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency);
        {* 02.02.99 Added new parameter 0 for new Conv_TCurr function *}
//        ImpBase:=Round_Up(Conv_TCurr(Inv.InvNetVal,TmpXRate,Inv.Currency,0,BOff),2);
        ImpBase:=Round_Up(Conv_TCurr(Inv.InvNetVal - Inv.DiscAmount,TmpXRate,Inv.Currency,0,BOff),2);
      end
      else
      begin
//          ImpBase:=Round_Up(Inv.InvNetVal,2);
          ImpBase:=Round_Up(Inv.InvNetVal - Inv.DiscAmount,2);
     end;
      {$IFDEF COMTK}
      if not (Inv.InvDocHed in BatchSet) then
      begin
      {$ENDIF}
{        TmpLineNet := LineNet;              }
        if (Inv.InvDocHed in NomSplit) and VatNeededOnNOM then
        begin
{          TmpLineNet := TmpLineNet + LineVat;}
          ValidCheck := (Round_Up(LineNet - ImpBase, 2) = 0) and
                        (Round_Up(ImpBase + LineVat, 2) = 0) and
                        (Round_Up(LineNet + LineVat, 2) = 0); //overkill?
        end
        else
          ValidCheck:=(Round_Up(LineNet,2)=Round_Up(ImpBase,2));

        GenSetError(ValidCheck,30109,Result,ValidHed);
      {$IFDEF COMTK}
      end
      else
        ValidCheck := True;
      {$ENDIF}

      {* For NOM - 13.04.2000 *}

      GenSetError(ValidCheck,30121,Result,ValidHed);

      ValidCheck:=((Not (Inv.InvDocHed In DirectSet)) or (Round_Up(LineDir,2)=Round_Up(ITotal(Inv),2)));

      GenSetError(ValidCheck,30110,Result,ValidHed);

      { 25.09.2000 - Added to calculate Header Total Cost }

      if Result = 0 then
      begin
        //PR: 30.4.02 - allow fields to go through ok for heinz import
        if not ExSyss.AllowTotCost and not (Inv.InvDocHed in JAPSplit) then
          Inv.TotalCost := HeaderCost;
        if not ExSyss.AllowTotWeight then
          Inv.TotalWeight := HeaderWeight;
      end;

    end; {If Mode=0 , Total Check ....}

   end
   else
     Result:=32766;

end; {Proc..}


Function ValidJAPTrans(ExInvRec :  TBatchThRec;    { Header Record }
                       PL       :  POINTER;        { Pointer for Lines }
                       SMode    :  SmallInt;       { Insert/Update/Import Check Mode }
                       Mode     :  Byte;
                   var ExLocal  :  TdExLocal)  :  Integer;  { Original parameter, not used for validation }
Var

  ValidHed,
  ValidCheck   :  Boolean;
  HedVariance  :  Double;
  TmpMode      :  SmallInt;
  OldInv       :  InvRec;  {* 01.09.99 - to use for POR/SOR update *}

  EditNo       :  Byte;    {* Get no. of times edited for each trans. line *}
  LineFail     :  Integer;
  OSParam      :  Boolean;
  CISResult    :  Integer;
Begin
  Result :=0;
{$IFDEF COMTK}
  CISResult := 0;
  ValidHed:=BOn;
  ValidCheck:=BOff;
  HedVariance:=0;
  EditNo:=0;
  Result:=0;
  LineFail:=0;
  TmpMode := 0;

  {* Windows Import has CHECK and IMPORT processes. If CHECK mode, just validate and
     only if IMPORT, the trans. would be added into Enterprise. No updating
     is allowed via Import Module *}

  If (SMode=ImportMode) or (SMode=CheckMode) then
  begin
    TmpMode:=SMode;    {* To Check for CheckMode *}
    SMode:=B_Insert;   {* From Import Module = B_Insert *}
  end
  else
  begin
    {* if not from Import Module and not Update, others would be considered as B_Insert *}
    If (SMode<>B_Update) then
      SMode:=B_Insert;
  end; {if..}

  {* OldInv has been added to update Acc.Balance if B_Update is used.
     Convert Header data from Toolkit record structure (ExInv)
     into Enterprise record structure (Inv) *}

  Result:=ExInvToInv(ExInvRec,SMode,OldInv,EditNo);

  with Inv do
  if (InvDocHed <> JPT) {$IFDEF COMTK}and not ExInvRec.MSTerms {$ENDIF}then
  begin
    BatchLink := FullJAPEmplKey(InvDocHed = JPA, CISEmpl, InvDocHed in [JST, JCT]);
    TransDesc := FullJAPJobKey((InvDocHed in [JPA, JSA]), DJobCode, InvDocHed in [JST, JCT], InvDocHed in JAPSalesSplit);
  end
  else
  begin
    FillChar(TransDesc[0], SizeOf(TransDesc), 0);
    FillChar(BatchLink[0], SizeOf(BatchLink), 0);
  end;


  {* Validate Header Fields *}
  If (Result=0) then
    Result:=ValidateJAPHeader(SMode,OldInv);

  If (Result=0) then  {* If Header validation is o.k *}
  With Inv do
  Begin
    If (SMode=B_Insert) then {* If the transaction is to be ADDED *}
    Begin

      {* Validate Transaction Lines
         First parameter=0 = Validate only, do not add *}
      {Result:=Validate_Lines(0,ILineCount,HedVariance,PL,SMode,EditNo);}
      Result:=Validate_JAPLines(0,ExInvRec.LineCount,HedVariance,PL,SMode,EditNo, ExLocal);

      {* To add the transation if validation is o.k *}
      If ((Result=0) and (Mode=1) and (TmpMode<>CheckMode)) then
      Begin

        {* Set mandatory fields of Header record *}
        Result:=Set_ExDoc(HedVariance);

        {* Validate lines again and add lines into Details.DAT file *}
        If (Result=0) then
          Result:=Validate_JAPLines(1,ExInvRec.LineCount,HedVariance,PL,SMode,EditNo, ExLocal);

        //PR 24/02/03

(*        if CISOn and (InvDocHed in PurchSplit - [PPY, PQU, POR, PDN, PBT]) then
        begin
          GetMultiSys(BOff,GlobLocked,CISR);
          Calc_CISTaxInv(Inv, True);
        end;
  *)
        {* If lines adding o.k, add Header into Document.Dat *}
        If (Result=0) then
        begin
          ExLocal.LInv := Inv;
          CalcJAPVatTotals(Inv, ExLocal, not Inv.ManVAT, 3);
          //Add Cis line
          if Inv.InvDocHed in [JPA, JSA] then
          begin
            GetMultiSys(BOff,GlobLocked,CISR);

            Calc_CISTaxInv(Inv, True, CISResult);
          end;
	  Result:=Store_ExDoc(SMode);  {* Need SMode here for Update or Insert *}
        end;

        {* If storing Header is Not o.k, delete Lines in Details.Dat *}
        If (Result<>0) then
	  DeleteLinks(FullNomKey(FolioNum),IdetailF,Length(FullNomKey(FolioNum)),IdFolioK,BOff)
        else
        begin
          {* OldInv is not used for B_Insert, Just to pass the parameter *}
          FillChar(OldInv,SizeOf(OldInv),#0);
        end; {If Result<>0..}

      end; {if Result=0 and Mode=1..}
    end; {if SMode=B_Insert..}

    {*** All these have to be modified ***}


    {* If Transaction is to be Updated (B_Update parameter) *}
    If (SMode=B_Update) then
    begin

      {* Validate Lines - first parameter = 0 = Do validate Only. *}
      Result:=Validate_JAPLines(0,ExInvRec.LineCount,HedVariance,PL,SMode,EditNo, ExLocal);

      {* If Lines validate o.k and not CHECK mode of Import Module *}
      If ((Result=0) and (Mode=1) and (TmpMode<>CheckMode)) then
      Begin
        {* Validate and Add Lines into Details.DAT *}
        Result:=Validate_JAPLines(1,ExInvRec.LineCount,HedVariance,PL,SMode,EditNo, ExLocal);

        {* Check all Lines belong to the Header
           if the records were not updated, check & delete them *}
        If (Result=0) then
          Result:=CheckIdLinesAgain(Inv, OldInv.FolioNum, EditNo, LineFail);

        {* Update mandatory fields in Header *}
        If (Result=0) then
          Result:=Set_ExDocForUpdate(HedVariance,OldInv);

        {* Update Header record in Document.DAT *}
        If (Result=0) then
        begin
          ExLocal.LInv := Inv;
          CalcJAPVatTotals(Inv, ExLocal, not Inv.ManVAT, 3);

          //Add Cis line
          if Inv.InvDocHed in [JPA, JSA] then
          begin
            GetMultiSys(BOff,GlobLocked,CISR);

            Calc_CISTaxInv(Inv, True, CISResult);
          end;

	  Result:=Store_ExDoc(SMode);  {Need SMode here for Update & Insert }

        end;

      end; {if Result=0..}

    end; {if SMode=B_Update...}


  end; {If Result=0 from Header ..}

  { LineFail has been added for Warning Messages }
  If (LineFail<>0) then
    Result:=LineFail;

  if CISREsult <> 0 then
    Result := CISResult;
{$ENDIF}
end; {ValidTrans..}


FUNCTION EX_STOREJAPTRANS(P,
                          PL         :  POINTER;
                          PSIZE,                     {* Size of TH *}
                          PLSIZE     :  LONGINT;     {* Size of TLs *}
                          SEARCHPATH :  SMALLINT;
                          SEARCHMODE :  SMALLINT;
                      var ExLocal    :  TdExlocal)  :  SMALLINT;

Var
  ExInvRec   :  ^TBatchTHRec;
  KeyS       :  Str255;
  ValidCheck :  Boolean;
  TestResult :  SmallInt;
  MatchRec,
  MatchRec2  :  TBatchMatchRec;
  Res2,Res1  :  SmallInt;
  OldInv     :  InvRec;
  ParentTrans: Str255;
  Locked     : Boolean;
Begin
  Result := 0;
{$IFDEF COMTK}

  if CheckOnly then
    SearchMode := CheckMode;
    
  LastErDesc:='';

  If TestMode Then Begin
    ExInvRec:=P;
    ShowMessage ('Ex_StoreTrans: ' + #10#13 +
                 'P^.OurRef: ' + ExInvRec^.OurRef + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'PLSize: ' + IntToStr(PLSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  TestResult:=0;
  TestResult:=32767;

  If (P<>Nil) and (PL<>Nil) and (PSize=Sizeof(TBatchTHRec)) then
  Begin
    ExInvRec:=P;

    ValidCheck:=True;  {* check No. of TLs *}

    ValidCheck:=(ExInvRec^.LineCount<=(PLSize div SizeOf(TBatchTLRec)));

    If (ValidCheck) then
    begin
{      JAPParentFolio    := 0;
      JAPParentType     := SIN;
      JapParentEmployee := '';
      JAPParentJobCode  := '';
      JAPParentStage    := 0;

      //Find the terms record and store some details.
      if CheckRecExsists(ExInvRec^.thDeliveryNoteRef, InvF, InvOurRefK) then
      begin
        if (Trim(ExInvRec^.thDeliveryNoteRef) <> '') then
        begin
          JAPParentFolio    := Inv.FolioNum;
          JAPParentType     := Inv.InvDocHed;
          JapParentEmployee := Inv.CISEmpl;
          JAPParentJobCode  := Inv.DJobCode;
          JAPParentStage    := Inv.TransNat;
        end;
      end;
 }
      //Find the terms record and store some details.
      if CheckRecExsists(FullOurRefKey(ExInvRec^.thDeliveryNoteRef), InvF, InvOurRefK) and
         (Trim(ExInvRec^.thDeliveryNoteRef) <> '') then
      begin
        JAPParentFolio    := Inv.FolioNum;
        JAPParentType     := Inv.InvDocHed;
        JapParentEmployee := Inv.CISEmpl;
        JAPParentJobCode  := Inv.DJobCode;
        JAPParentStage    := Inv.TransNat;
      end
      else
      begin
        JAPParentFolio    := 0;
        JAPParentType     := SIN;
        JapParentEmployee := '';
        JAPParentJobCode  := '';
        JAPParentStage    := 0;
      end;


      FillChar(Inv, SizeOf(Inv), 0); //Just to be on the safe side

      {TestResult:=ValidTrans(ExInvRec^,PL,B_Insert,1)}
      TestResult:=ValidJAPTrans(ExInvRec^,PL,SearchMode,1, ExLocal);

      {* 07.07.99 - added this to return OurRef, Folio number etc..
         20.04.2000 - Added 30700 and 30701 checking *}

      If (TestResult=0) or (TestResult=30700) or (TestResult=30701) then
      begin
        InvToExInv(ExInvRec^);

        //Add Cis line
{        if Inv.InvDocHed = JPA then
        begin
          GetMultiSys(BOff,GlobLocked,CISR);

          Calc_CISTaxInv(Inv, True);
        end;
 }
        //Add matching

        if (SearchMode = B_Insert) and
        ((Inv.InvDocHed in [JCT, JPA, JSA]) or ((Inv.InvDocHed = JST) and (Trim(Inv.DeliverRef) <> '')))  then
        begin
          FillChar(MatchRec, SizeOf(MatchRec), 0);
          FillChar(MatchRec2, SizeOf(MatchRec2), 0);

          OldInv := Inv;
          ParentTrans := Inv.DeliverRef;

          MatchRec.DebitRef  := Inv.DeliverRef;
          MatchRec.CreditRef := Inv.OurRef;
          MatchRec.CreditCr := Inv.Currency;

          MatchRec2.DebitRef  := Inv.OurRef;
          MatchRec2.CreditRef := Inv.DeliverRef;
          MatchRec2.CreditCr := Inv.Currency; //Change this to pick up parent currency

          Res2 := Ex_StoreJAPMatch(@MatchRec, SizeOf(MatchRec), 0, B_Insert);

          Res2 := Ex_StoreJAPMatch(@MatchRec2, SizeOf(MatchRec2), 0, B_Insert);

        end;
      end;
    end
    else
      TestResult:=32765; {* TLs record size incorrect *}

  end
  else
    If ((P<>Nil) or (PL<>Nil)) then
      TestResult:=32766;

  // HM 17/10/00: Modified to use TestResult
  If (TestResult<>0) then
    LastErDesc:=Ex_ErrorDescription(21,TestResult);

  Result:=TestResult;
{$ENDIF}
end; {Ex_StoreTrans ..}

FUNCTION EX_UPDATECISDATE(DOCREFNO    :  PCHAR;
                          NEWDATE     :  PCHAR) :  SMALLINT;
Const
  FNum  =  InvF;

Var
  ValidHed,
  ValidCheck  :  Boolean;

  td,tm,ty     :  Word{Integer};

  TResult,
  KeyNum       : Integer;

  Locked,
  SavedPosOK   : Boolean;
  RecPos       : LongInt;

  KeyS         : Str255;

  Res : Integer;

begin

  LastErDesc:='';
  TResult:=0;
  ValidHed:=BOff;
  ValidCheck:=BOn;

  If TestMode then
    ShowMessage ('Ex_UpdateDueDate:' + #10#13 +
                 'DocRefNo     : ' + DocRefNo + #10#13 +
                 'New Date : ' + NewDate);


  { Save the current position in the transaction header file }
  KeyNum := GetPosKey;
  SavedPosOK := Presrv_BTPos(FNum, KeyNum, F[FNum], RecPos, false, false) = 0;

  { Find and update the transaction header record }
  KeyS:=LJVar(DocRefNo,DocLen);
  TResult := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, InvOurRefK, KeyS);

  If (TResult=0) then { Attempt to lock record }
  {$IFDEF WIN32}
  begin
    If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked)) then
      TResult:=0;
    // If not locked and user hits cancel return code 84
    if (TResult = 0) and (Not Locked) then
      TResult := 84;
  end;
  {$ELSE}
  TResult:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked));
  {$ENDIF}


  If (TResult=0) then
  begin
//    ValidCheck:=(Inv.InvDocHed In [SIN,SCR,SJI,SJC,SRI,SRF,PIN,PCR,PJI,PJC,PPI,PRF]);
    ValidCheck:=(Inv.InvDocHed In [PIN,PJI,PCR,PJC]);
    GenSetError(ValidCheck,30001,TResult,ValidHed);

    DateStr(NewDate,Td,Tm,Ty);
    ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty>1900));
    GenSetError(ValidCheck,30002,TResult,ValidHed);

{    ValidCheck := Inv.CISTax <> 0;
    GenSetError(ValidCheck,30003,TResult,ValidHed);}

    ValidCheck := Inv.CISDeclared = 0;
    GenSetError(ValidCheck,30004,TResult,ValidHed);

    ValidCheck:=CheckRecExsists(JARCode+JAECode+LJVar(Inv.CISEmpl,AccLen),JMiscF,JMK);
    if ValidCheck then
      ValidCheck := JobMisc^.EmplRec.CISType = 3;
    GenSetError(ValidCheck,30005,TResult,ValidHed);

    //PR 09/12/04 Removed at KH's request
{    ValidCheck := Trim(Inv.CISDate) <> '';
    GenSetError(ValidCheck,30006,TResult,ValidHed);}

    If (TResult=0) then
    begin
      Inv.CISDate := NewDate;
      TResult := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, InvOurRefK);
    end; {if..}

  end; {Result=0..}

  { Return to the original position in the transaction header file }
  If (SavedPosOK) then
    Presrv_BTPos(InvF, KeyNum, F[FNum], RecPos, True, False);

  If (TResult<>0) then
    LastErDesc:=Ex_ErrorDescription(177,TResult);

  Ex_UpdateCISDate := TResult;

end; { Ex_UpdateDueDate..}

FUNCTION EX_RESETADJNOMFLAGS(DOCREFNO    :  PCHAR) :  SMALLINT;
Const
  FNum  =  InvF;
Var
  ValidHed, ValidCheck  :  Boolean;
  TResult, TLKeyNum, THKeyNum  : Integer;
  Locked, THSavedPosOK, TLSavedPosOK   : Boolean;
  THRecPos, TLRecPos : LongInt;
  KeyS{, KeyChk} : Str255;
begin
  LastErDesc:='';
  TResult:=0;
  ValidHed:=BOff;
  ValidCheck:=BOn;
  Locked := False;

  If TestMode then
    ShowMessage ('Ex_UpdateDueDate:' + #10#13 +
                 'DocRefNo     : ' + DocRefNo);


  { Save the current position in the transaction header file }
  THKeyNum := GetPosKey;
  THSavedPosOK := Presrv_BTPos(FNum, THKeyNum, F[FNum], THRecPos, false, false) = 0;

  { Find and update the transaction header record }
  KeyS:=LJVar(DocRefNo,DocLen);
  TResult := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, InvOurRefK, KeyS);

  If (TResult=0) then { Attempt to lock record }
  begin

//    If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked)) then
//    begin
      TResult := 0;

      ValidCheck:=(Inv.InvDocHed In [ADJ]);
      GenSetError(ValidCheck,30001,TResult,ValidHed);

  //    DateStr(NewDueDate,Td,Tm,Ty);

  //    ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty>1900));
//      GenSetError(ValidCheck,30002,TResult,ValidHed);

      If (TResult=0) then
      begin
        // go through lines

        { HM 07/10/99: Save the current position in the transaction line file }
        TLKeyNum := GetPosKey;
        TLSavedPosOK := Presrv_BTPos(IDetailF, TLKeyNum, F[IDetailF], TLRecPos, false, false) = 0;

        // get the first line of the tx
        KeyS:=FullNomKey(Inv.FolioNum) + FullNomKey(-2147483647);
        Status:=Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

        While (StatusOk) and (ID.FolioRef = Inv.FolioNum) do
        Begin

        // get the first line of the tx
{        KeyS:=FullNomKey(Inv.FolioNum);
        KeyChk:=KeyS;
        Status:=Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        Begin}

//          ID.B2BLink := ID.FolioRef;
          ID.B2BLink := 0;

          Status:=Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK);

          // get next tx line
          Status:=Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);
        end;


        { HM 07/10/99: Return to the original position in the transaction detail file }
        if TLSavedPosOK then
          Presrv_BTPos(IDetailF, TLKeyNum, F[IDetailF], TLRecPos, true, false);

  //      Inv.DueDate:=NewDueDate;
  //      TResult := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, InvOurRefK);
      end; {if..}

//    end;

    // If not locked and user hits cancel return code 84
    if (TResult = 0) and (Not Locked) then
      TResult := 84;
  end;

  { Return to the original position in the transaction header file }
  If (THSavedPosOK) then
    Presrv_BTPos(InvF, THKeyNum, F[FNum], THRecPos, True, False);

  If (TResult<>0) then
    LastErDesc:=Ex_ErrorDescription(181,TResult);

  Result := TResult;

end;


FUNCTION EX_SETLINEGLCODE(Const iTXFolioNo : LongInt; Const iABSLineNo : LongInt; Const iNewGLCode : LongInt) : SMALLINT;
var
  Key2 : Str255;
  LockResult, IdLocked : boolean;
begin
  Key2 := FullNomKey(iTXFolioNo) + FullNomKey(iAbsLineNo);
  Result:=Find_Rec(B_GetEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, Key2);
  If (Result=0) Then
  Begin
    { Lock Transaction Line }
    IdLocked := False;
    {$IFDEF WIN32}
      LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked);
      // Second condition when user presses 'Cancel'
      if (Not LockResult) or (LockResult and (not IdLocked)) then
        Result := 84;
    {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked));
    {$ENDIF}
    If (Result=0) And IdLocked then
    Begin
      Id.NomCode := iNewGLCode;
      Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
      //Unlock line
      Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
    end;
  end else
  begin
    Result := 30004; //Can't find line
  end;
end;

function EX_UPDATERECONCILEFLAG(const RecordAddress : longint;
                                const NewValue      : SmallInt) : SmallInt;
                                STDCALL;
var
  pPath : PChar;
  THSavedPosOK, TLSavedPosOK   : Boolean;
  THRecPos, TLRecPos : LongInt;
  TLKeyNum, THKeyNum  : Integer;
begin
  Result := 0;
  if DataIsOpen then
  begin
    { Save the current position in the transaction header file }
    THKeyNum := GetPosKey;
    THSavedPosOK := Presrv_BTPos(InvF, THKeyNum, F[InvF], THRecPos, false, false) = 0;
    {Save position in detail file}
    TLKeyNum := GetPosKey;
    TLSavedPosOK := Presrv_BTPos(IDetailF, TLKeyNum, F[IDetailF], TLRecPos, false, false) = 0;

    pPath := strAlloc(255);
    Try
      StrPCopy(pPath, ExSyss.ExPath);
      Result := SP_INITDLLPATH(pPath, ExSyss.MCMode);
      if Result = 0 then
      begin
        Result := SP_INITDLL;
        Try
          if Result = 0 then
            Result := SP_UPDATERECONCILEFLAG(RecordAddress, NewValue);

          //PR: 28/10/2011 v6.9
          if Result = 0 then
            AuditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);

        Finally
          SP_CLOSEDLL;
        End;
      end;

    Finally
      if Result = -1 then
        Result := 32500;
      StrDispose(pPath);
      {Return to position in detail file}
      if TLSavedPosOK then
        Presrv_BTPos(IDetailF, TLKeyNum, F[IDetailF], TLRecPos, true, false);
      {Return to position in trans header file}
      If THSavedPosOK then
        Presrv_BTPos(InvF, THKeyNum, F[InvF], THRecPos, True, False);
    End;
  end
  else
    Result := 3;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(184,Result);


end;

FUNCTION EX_UPDATEPRINTEDSTATUS(DOCREFNO    :  PCHAR;
                                NEWSTATUS   :  WordBool) :  SMALLINT;
Const
  FNum  =  InvF;

Var
  ValidHed,
  ValidCheck  :  Boolean;

  td,tm,ty     :  Word{Integer};

  TResult,
  KeyNum       : Integer;

  Locked,
  SavedPosOK   : Boolean;
  RecPos       : LongInt;

  KeyS         : Str255;

begin

  LastErDesc:='';
  TResult:=0;
  ValidHed:=BOff;
  ValidCheck:=BOn;


  { Save the current position in the transaction header file }
  KeyNum := GetPosKey;
  SavedPosOK := Presrv_BTPos(FNum, KeyNum, F[FNum], RecPos, false, false) = 0;

  { Find and update the transaction header record }
  KeyS:=LJVar(DocRefNo,DocLen);
  TResult := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, InvOurRefK, KeyS);

  If (TResult=0) then { Attempt to lock record }
  {$IFDEF WIN32}
  begin
    If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked)) then
      TResult:=0;
    // If not locked and user hits cancel return code 84
    if (TResult = 0) and (Not Locked) then
      TResult := 84;
  end;
  {$ELSE}
  TResult:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked));
  {$ENDIF}


  If (TResult=0) then
  begin
    Inv.PrintedDoc := WordBoolToBool(NewStatus);
    TResult := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, InvOurRefK);
  end; {Result=0..}

  { Return to the original position in the transaction header file }
  If (SavedPosOK) then
    Presrv_BTPos(InvF, KeyNum, F[FNum], RecPos, True, False);

  If (TResult<>0) then
    LastErDesc:=Ex_ErrorDescription(149,TResult);

  Result := TResult;

end; { Ex_UpdatePrintedStatus..}


{$IFDEF GMGSPECIAL}

FUNCTION EX_GMGRESETSTOCKGLS(const DOCREFNO : PCHAR) :  SMALLINT;
Const
  FNum  =  InvF;
Var
  ValidHed, ValidCheck  :  Boolean;
  TResult, TLKeyNum, THKeyNum  : Integer;
  Locked, THSavedPosOK, TLSavedPosOK   : Boolean;
  THRecPos, TLRecPos : LongInt;
  KeyS, KeyChk : Str255;

  Function GetGLCodeForLine(var IDLine : Idetail) : boolean;
  var
    TKStockRec : TBatchSKRec;
    pStockCode : PChar;
    iStatus : smallint;
    wbLock : wordbool;
  begin
    Result := FALSE;
    pStockCode := StrAlloc(255);
    StrPCopy(pStockCode, IdLine.StockCode);
    wbLock := WordBool(FALSE);
    iStatus := Ex_GetStock(@TKStockRec, SizeOf(TKStockRec), pStockCode, 0, B_GetEq, wbLock);
    if iStatus = 0 then
    begin
      Result := TRUE;
      case TKStockRec.StockType of
        'G' : Result := FALSE; // groups
        'M' : begin // BOM
          if Inv.InvDocHed = ADJ then
          begin
            // ADJs
            if IdLine.LineNo = -1 then IdLine.NomCode := TKStockRec.nomcodes[4] // stock value
//            else TKTLine.NomCode := TKStockRec.nomcodes[3]; // write offs
            else IdLine.NomCode := TKStockRec.nomcodes[5]; // BOM Finished Goods
          end else
          begin
            if Copy(Inv.OurRef,1,1) = 'S' then
            begin
              // Sales Transactions
              if IdLine.LineNo = -1 then IdLine.NomCode := TKStockRec.nomcodes[5] // BOM Finished Goods
              else Result := FALSE;
            end else
            begin
              // Purchase Transactions
              IdLine.NomCode := TKStockRec.nomcodes[5] // BOM Finished Goods
            end;
          end;
        end;

        'P', 'D', 'X' : begin // Product / desc only / expired
          if Inv.InvDocHed = ADJ then
          begin
            // ADJs
            if IdLine.LineNo = -1 then IdLine.NomCode := TKStockRec.nomcodes[4] // stock value
            else IdLine.NomCode := TKStockRec.nomcodes[3]; // write offs
          end else
          begin
            if Copy(Inv.OurRef,1,1) = 'S' then
            begin
              // Sales Transactions
              if IdLine.LineNo = -1 then IdLine.NomCode := TKStockRec.nomcodes[4] // stock value
              else Result := FALSE;
            end else
            begin
              // Purchase Transactions
              IdLine.NomCode := TKStockRec.nomcodes[4] // stock value
            end;
          end;
        end;
      end;{case}
    end;{if}

    StrDispose(pStockCode);
  end;{GetGLCodeForLine}

begin
  LastErDesc:='';
  TResult:=0;
  ValidHed:=BOff;
  ValidCheck:=BOn;

  If TestMode then
    ShowMessage ('Ex_UpdateDueDate:' + #10#13 +
                 'DocRefNo     : ' + DocRefNo);


  { Save the current position in the transaction header file }
  THKeyNum := GetPosKey;
  THSavedPosOK := Presrv_BTPos(FNum, THKeyNum, F[FNum], THRecPos, false, false) = 0;

  { Find and update the transaction header record }
  KeyS:=LJVar(DocRefNo,DocLen);
  TResult := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, InvOurRefK, KeyS);

  If (TResult=0) then { Attempt to lock record }
  {$IFDEF WIN32}
  begin

    If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked)) then
    begin
{      TResult := 0;

      ValidCheck:=(Inv.InvDocHed In [ADJ]);
      GenSetError(ValidCheck,30001,TResult,ValidHed);

      If (TResult=0) then
      begin}
        // go through lines

        { HM 07/10/99: Save the current position in the transaction line file }
        TLKeyNum := GetPosKey;
        TLSavedPosOK := Presrv_BTPos(IDetailF, TLKeyNum, F[IDetailF], TLRecPos, false, false) = 0;

        // get the first line of the tx
        KeyS:=FullNomKey(Inv.FolioNum) + FullNomKey(-2147483647);
//        KeyChk:=KeyS;
        Status:=Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

        While (StatusOk) and (ID.FolioRef = Inv.FolioNum)
        {and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))} do
        Begin

//          ID.NomCode := GetGLCodeForLine(var TKTLine : TBatchTLRec) : boolean;
          if GetGLCodeForLine(ID)
          then Status:=Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK);

          // get next tx line
          Status:=Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);
        end;


        { HM 07/10/99: Return to the original position in the transaction detail file }
        if TLSavedPosOK then
          Presrv_BTPos(IDetailF, TLKeyNum, F[IDetailF], TLRecPos, true, false);

  //      Inv.DueDate:=NewDueDate;
  //      TResult := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, InvOurRefK);
{      end; {if..}

    end;

    // If not locked and user hits cancel return code 84
    if (TResult = 0) and (Not Locked) then
      TResult := 84;
  end;
  {$ELSE}
  TResult:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,Fnum,SilentLock,Locked));
  {$ENDIF}


  { Return to the original position in the transaction header file }
  If (THSavedPosOK) then
    Presrv_BTPos(InvF, THKeyNum, F[FNum], THRecPos, True, False);

  If (TResult<>0) then
    LastErDesc:=Ex_ErrorDescription(181,TResult);

  Result := TResult;

end;
{$ENDIF}

FUNCTION EX_UPDATETXFIELD(Const pTransRef   : PChar;
                          Const iAbsLineNo  : LongInt;
                          Const iFieldNo  : LongInt;
                          Const pNewFieldValue    : PChar) : SmallInt;
// Undocumented function to update fields on transactions, without enforcing the business rules
Var
  Key1, Key2, KeyChk : Str255;
  sNewFieldValue : string;
  LockResult, InvLocked, IdLocked : Boolean;
begin

  If TestMode Then Begin
    { Display passed parameters }
    ShowMessage ('EX_UPDATETXFIELD:' + #10#13 +
                 'pTransRef: ' + StrPas(pTransRef) + #10#13 +
                 'iAbsLineNo: ' + IntToStr(iAbsLineNo) + #10#13 +
                 'iFieldNo: ' + IntToStr(iFieldNo) + #10#13 +
                 'pNewFieldValue: ' + StrPas(pNewFieldValue));
  End; { If }

  // Standard error by default
  Result:=32767;
  LastErDesc:='';

  // Convert to a string
  sNewFieldValue := StrPas(pNewFieldValue);

  { Get specified Transaction }
  Key1 := StrPas(pTransRef);
  Result := Find_Rec(B_GetEQ, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key1);
  If (Result=0) Then
  Begin

    { Lock Transaction }
    InvLocked := False;

    LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked);
    // Second condition when user presses 'Cancel'
    if (Not LockResult) or (LockResult and not InvLocked) then
      Result := 84;

    If (Result=0) And InvLocked Then
    Begin

      case iAbsLineNo of
       -1 : begin
              //Set all lines on transaction
              Key2 := FullNomKey(Inv.FolioNum) + FullNomKey(-1);
              KeyChk := FullNomKey(Inv.FolioNum);

              Result:=Find_Rec(B_GetGEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, Key2);

              while (Result=0) and (CheckKey(KeyChk,Key2,Length(KeyChk),BOn)) do
              Begin
                { Lock Transaction Line }
                IdLocked := False;
                LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked);
                // Second condition when user presses 'Cancel'
                if (Not LockResult) or (LockResult and (not IdLocked)) then
                  Result := 84;
                If (Result=0) And IdLocked then
                Begin
                 // Which Field are we updating ?
                  case iFieldNo of
                    1 : begin
                          // Stock Location Field

                          // Validate Value Passed in
                          if Length(sNewFieldValue) > 3 then
                          begin
                            // Validation Error
                            Result := 30000;
                            //Need to unlock record
                            Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
                          end else
                          begin
                          // Update Field
                            Id.MLocStk := sNewFieldValue;
                            Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
                          end;{if}
                        end;
                  end;{case}
                  if Result = 0 then
                    Result := Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
                end; //if
              end;{while}
              if Result = 9 then //EOF is a legitimate result
                Result := 0;
            end;  //-1
        0 : begin
          // Update Transaction Header Field
          case iFieldNo of
            1 : ; // Placeholder

            2 : begin // Run Number
              // Validate Value Passed in
              if Trim(sNewFieldValue) = IntToStr(StrToIntDef(Trim(sNewFieldValue),0)) then
              begin
                Inv.RunNo := StrToIntDef(Trim(sNewFieldValue),0);
                Result := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, InvOurRefK);
              end;{if}
            end;

          end;{case}
        end;

        else begin
          // Update Transaction Line Field

          { Get specified Transaction Line }
          Key2 := FullNomKey(Inv.FolioNum) + FullNomKey(iAbsLineNo);
          Result:=Find_Rec(B_GetEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, Key2);
          If (Result=0) Then
          Begin
            { Lock Transaction Line }
            IdLocked := False;
            LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked);
            // Second condition when user presses 'Cancel'
            if (Not LockResult) or (LockResult and (not IdLocked)) then
              Result := 84;
            If (Result=0) And IdLocked then
            Begin
              // Which Field are we updating ?
              case iFieldNo of
                1 : begin
                  // Stock Location Field

                  // Validate Value Passed in
                  if Length(sNewFieldValue) > 3 then
                  begin
                    // Validation Error
                    Result := 30000;
                  end else
                  begin
                    // Update Field
                    Id.MLocStk := sNewFieldValue;
                    Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
                  end;{if}
                end;

                2 : begin
                  // Run Number

                  // Validate Value Passed in
                  if Trim(sNewFieldValue) = IntToStr(StrToIntDef(Trim(sNewFieldValue),0)) then
                  begin
                    // Update Field
                    Id.PostedRun := StrToIntDef(Trim(sNewFieldValue),0);
                    Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
                  end else
                  begin
                    // Validation Error
                    Result := 30000;
                  end;{if}
                end;
              end;{case}

              // Unlock line
              Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);

            end;{if}
          end else
          begin
            Result := 30004; //Can't find line
          end;{if}

          If InvLocked Then
          Begin
            { Unlock Transaction header }
            Status:=Find_Rec(B_Unlock,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,Key1);
          end;{if}
        end;

      end;{case}
    end;{if}
  end;{if}

{  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(212,Result);}

end; {EX_UPDATELINEDATE}

PROCEDURE EX_INCLUDEHIDDENLINES(const bInclude : WordBool);
begin
  IncludeHiddenLines := WordBoolToBool(bInclude);
end;

FUNCTION EX_GETLINEVALUE(Const TransRef   : PChar;
                         Const AbsLineNo  : LongInt;
                           var Value      : Double) : SmallInt;
Var
  Key1, Key2 : Str255;
begin

  LastErDesc:='';

  If TestMode Then Begin
    { Display passed parameters }
    ShowMessage ('EX_GETLINEVALUE:' + #10#13 +
                 'TransRef: ' + StrPas(TransRef) + #10#13 +
                 'AbsLineNo: ' + IntToStr(AbsLineNo));
  End; { If }

  Result:=32767;

  { Get specified Transaction }
  Key1 := StrPas(TransRef);
  Result := Find_Rec(B_GetEQ, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key1);
  If (Result=0) Then
  Begin
    { Get specified Transaction Line }
     Key2 := FullNomKey(Inv.FolioNum) + FullNomKey(AbsLineNo);
     Result:=Find_Rec(B_GetEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, Key2);
     If (Result=0) Then
     begin
       Value := InvLTotal(Id,False,0.0);
     end
     else
       Result := 30000 + Result;
  end;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(158,Result);
end;

function StockLocationOK(asCode : ANSIstring) : boolean;
var
  iStatus : integer;
  TKStockLocation : TBatchMLocRec;
begin{StockLocationOK}
  iStatus := EX_GETLOCATION(@TKStockLocation, SizeOf(TKStockLocation), Pchar(asCode), 0, B_GetEq, BoolToWordBool(FALSE));
  Result := iStatus = 0;
end;{StockLocationOK}

function IsPaymentLine(TXLine : Idetail; TXType :  DocTypes) : boolean;
begin
  Result := FALSE;
  if TXType in [PPI, PRF, SRI, SRF] then
  begin
    Result := TXLine.LineNo = 2147483647;
  end;{if}
end;

FUNCTION EX_UPPERCASESTOCKLOCATIONS(Const pTransRef : PChar) : SmallInt;
// Undocumented function to uppercase the stock locations on all lines
// NF: Written for Armour/Veda 09/06/06

  function GetNewStockLocation(var asCode : ANSIstring) : boolean;
  var
    pCode : PChar;
    iStatus : integer;
  begin{GetNewStockLocation}
    if UpperCase(asCode) = asCode then
    begin
      // already uppercased
      if StockLocationOK(asCode) then
      begin
        Result := FALSE;
      end else
      begin
        if Trim(asCode) = '' then
        begin
          // Don;t bother updating blank codes with blank codes.
          Result := FALSE;
        end else
        begin
          // updating bad locations with blank codes.
          Result := TRUE;
          asCode := '';
        end;{if}
      end;{if}
    end else
    begin
      // not uppercased
      Result := TRUE;
      if StockLocationOK(UpperCase(asCode)) then
      begin
        // Uppercase the location
        asCode := UpperCase(asCode);
      end else
      begin
        // even the Uppercase location is invalid, so blank it
        asCode := '';
      end;{if}
    end;{if}
  end;{GetNewStockLocation}

Var
  Key1, Key2, KeyChk : Str255;
  LockResult, InvLocked, IdLocked : Boolean;
  asStockLocation : ANSIString;
begin{}

  If TestMode Then Begin
    { Display passed parameters }
    ShowMessage ('EX_UPPERCASESTOCKLOCATIONS:' + #10#13 +
                 'pTransRef: ' + StrPas(pTransRef));
  End; { If }

  // Standard error by default
  Result:=32767;
  LastErDesc:='';

  { Get specified Transaction }
  Key1 := StrPas(pTransRef);
  Result := Find_Rec(B_GetEQ, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key1);
  If (Result=0) Then
  Begin

    { Lock Transaction }
    InvLocked := False;

    LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked);
    // Second condition when user presses 'Cancel'
    if (Not LockResult) or (LockResult and not InvLocked) then
      Result := 84;

    If (Result=0) And InvLocked Then
    Begin
      //Set all lines on transaction
      Key2 := FullNomKey(Inv.FolioNum) + FullNomKey(-1);
      KeyChk := FullNomKey(Inv.FolioNum);

      Result:=Find_Rec(B_GetGEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, Key2);

      while (Result=0) and (CheckKey(KeyChk,Key2,Length(KeyChk),BOn)) do
      Begin
        { Lock Transaction Line }
        IdLocked := False;
        LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked);
        // Second condition when user presses 'Cancel'
        if (Not LockResult) or (LockResult and (not IdLocked)) then
          Result := 84;
        If (Result=0) And IdLocked then
        Begin
          // Stock Location Field
          asStockLocation := Id.MLocStk;

          // Check Stock Location on Line
          if (Trim(Id.StockCode) <> '') // Ignore non-stock lines
//          and ((not (Id.Payment = 'Y')) or (Inv.InvDocHed = ADJ)) // Ignore Payment Lines (apparently all ADJ Lines are Payment lines......????)
          and (not IsPaymentLine(Id, Inv.InvDocHed))
          and GetNewStockLocation(asStockLocation) then
          begin
            // Update Stock Location on this line
            Id.MLocStk := asStockLocation;
            Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
          end else
          begin
            //Need to unlock record
            Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
          end;{if}

          // Get Next Line
          if Result = 0
          then Result := Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
        end; //if
      end;{while}
      if Result = 9 then //EOF is a legitimate result
        Result := 0;
    end;{if}
  end;{if}
{  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(212,Result);}
end; {EX_UPDATELINEDATE}


FUNCTION EX_SETSTOCKLOCATIONS(Const pTransRef : PChar; Const pLocation : PChar) : SmallInt;
// Undocumented function to set Invalid stock locations on all lines to the value passed in.
// NF: Written for Armour/Veda 09/06/06
Var
  Key1, Key2, KeyChk : Str255;
  LockResult, InvLocked, IdLocked : Boolean;
  asStockLocation : ANSIString;
begin{EX_SETSTOCKLOCATIONS}

  If TestMode Then Begin
    { Display passed parameters }
    ShowMessage ('EX_SETSTOCKLOCATIONS:' + #10#13 +
                 'pTransRef: ' + StrPas(pTransRef) + #10#13 +
                 'pLocation: ' + StrPas(pLocation));
  End; { If }

  // Standard error by default
  Result:=32767;
  LastErDesc:='';

  { Get specified Transaction }
  Key1 := StrPas(pTransRef);
  Result := Find_Rec(B_GetEQ, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key1);
  If (Result=0) Then
  Begin

    { Lock Transaction }
    InvLocked := False;

    LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked);
    // Second condition when user presses 'Cancel'
    if (Not LockResult) or (LockResult and not InvLocked) then
      Result := 84;

    If (Result=0) And InvLocked Then
    Begin
      //Set all lines on transaction
      Key2 := FullNomKey(Inv.FolioNum) + FullNomKey(-1);
      KeyChk := FullNomKey(Inv.FolioNum);

      Result:=Find_Rec(B_GetGEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, Key2);

      while (Result=0) and (CheckKey(KeyChk,Key2,Length(KeyChk),BOn)) do
      Begin
        { Lock Transaction Line }
        IdLocked := False;
        LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked);
        // Second condition when user presses 'Cancel'
        if (Not LockResult) or (LockResult and (not IdLocked)) then
          Result := 84;
        If (Result=0) And IdLocked then
        Begin
          // Stock Location Field

          // Check Stock Location on Line
          if (Trim(Id.StockCode) <> '') // Ignore non-stock lines
//          and ((not (Id.Payment = 'Y')) or (Inv.InvDocHed = ADJ)) // Ignore Payment Lines (apparently all ADJ Lines are Payment lines......????)
          and (not IsPaymentLine(Id, Inv.InvDocHed))
          and (not StockLocationOK(Id.MLocStk)) then
          begin
            // Update Stock Location on this line
            asStockLocation := pLocation;
            Id.MLocStk := asStockLocation;
            Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
          end else
          begin
            //Need to unlock record
            Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
          end;{if}

          // Get Next Line
          if Result = 0
          then Result := Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
        end; //if
      end;{while}
      if Result = 9 then //EOF is a legitimate result
        Result := 0;
    end;{if}
  end;{if}
{  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(212,Result);}
end;{EX_SETSTOCKLOCATIONS}


function GetVBDLine(WhichLine : Integer; Var LID : IDetail) : Boolean;
var
  TLLineRec : TBatchTLRec;
  RecPos : longint;
begin
  Result := False;
{$IFDEF COMTK}
  RecPos:=LongInt(VBDLines)+( Pred(WhichLine)*SizeOf(TLLineRec));
  Move(Pointer(RecPos)^,TLLineRec,SizeOf(TLLineRec));
  ExInvLineToId(TLLineRec, B_Insert);
  if (ID.Qty <> 0) and (ID.LineNo <> RecieptCode) then
  begin
    LID := ID;
    Result := True;
  end
  else
    Result := False;
{$ENDIF}
end;


function EX_GETVBDVALUE(P,
                        PL         :  POINTER;
                        PSIZE,
                        PLSIZE     :  LONGINT;
                        var VBDValue : Double;
                        var VBDVAT : Double) : Integer;
Var
  ExInvRec   :  ^TBatchTHRec;
  KeyS       :  Str255;
  ValidCheck :  Boolean;
  TestResult :  SmallInt;
  TempID : IDetail;
  TempInv : InvRec;
  {$IFDEF COMTK}
  VBDiscount : TVBDListItem;
  {$ENDIF}
  VBDiscVal : Double;
  VBDiscChar : Char;

Begin
  Result := 0;
 {$IFDEF COMTK}
  VBDValue := 0;
  VBDVAT := 0;
  VBDiscChar := #0;

  LastErDesc:='';


  TestResult:=0;
  TestResult:=32767;

  If (P<>Nil) and (PL<>Nil) and (PSize=Sizeof(TBatchTHRec)) then
  Begin
    ExInvRec:=P;

    ValidCheck:=True;  {* check No. of TLs *}

    ValidCheck:=(ExInvRec^.LineCount<=(PLSize div SizeOf(TBatchTLRec)));

    If (ValidCheck) then
    begin
      TestResult := 0;
      FillChar(TempInv, SizeOf(TempInv), 0);
      TempInv.InvDocHed := TKDocTypeToEntDocType(ExInvRec.TransDocHed);
      TempInv.InvNetVal := ExInvRec.InvNetVal;
      TempInv.TotalCost := ExInvRec.TotalCost;
      TempInv.CustCode := ExInvRec.CustCode;

      with TVBDList.Create(@TempInv) do
      Try
        VBDiscount := GetOffer(TempInv.InvNetVal);
        if Assigned(VBDiscount) then
        begin
          VBDiscVal := VBDiscount.DiscountVal;
          VBDiscChar := VBDiscount.DiscountType;
        end
        else
          VBDiscVal := 0;
      Finally
        Free;
      End;

      if VBDiscVal <> 0 then
      begin
        TempID := ID;
        VBDLines := PL;

        with TToolkitTTDCalculator.Create(True, @TempInv) do
        Try
          Count := ExInvRec.LineCount;
          GetLine := GetVBDLine;
          if CalculateAD(VBDiscVal, VBDiscChar) then
          begin  //PR: 13/07/2009 Need to handle % discounts differently
            if VBDiscChar <> '%' then
              VBDValue := AmountDiscountApplied
            else
              VBDVAlue := TransTotals[ttBeforeNetTotal] - TransTotals[ttAfterNetTotal];

            VBDVAT := TransTotals[ttBeforeVATTotal] - TransTotals[ttAfterVATTotal];
          end;
        Finally
          Free;
          ID := TempID;
        End;
      end;
    end
    else
      TestResult:=32765; {* TLs record size incorrect *}

  end
  else
    If ((P<>Nil) or (PL<>Nil)) then
      TestResult:=32766;

  // HM 17/10/00: Modified to use TestResult
  If (TestResult<>0) then
    LastErDesc:=Ex_ErrorDescription(21,TestResult);

  Result:=TestResult;
{$ENDIF}
end; {Ex_StoreTrans ..}

//PR: 15/10/2009 Undocumented function to update Account Stock Analysis
function EX_UPDATEACSTOCKANAL(iFolioNo : longint; iAbsLineNo : longint) : Integer;
var
  KeyS : Str255;
begin
  KeyS := FullNomKey(iFolioNo) + FullNomKey(iAbsLineNo);
  Result:=Find_Rec(B_GetEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, KeyS);

  if Result = 0 then
    Stock_AddCustAnal(Id,BOn,0);
end;

//PR: 20/05/2011 Added function to return correct VAT exchange rate
//Parameters are: CXRate - the Exchange rates from a transaction line
//                ACurrency - the currency required
//If Daily rate on passed in rates is 0, then use daily rate from system.
//Written after consultation with Mark Roke
Function GetVATExchangeRate(CXRate  :  CurrTypes;
                            ACurrency :  Byte) :  Double;
Begin

  With SyssCurr^.Currencies[ACurrency] do
  Begin
    if not IsZero(CXRate[True]) then
      Result := CXRate[True]
    else
      Result := CRates[True];
  end; {With..}
end; {Func..}
//PR: 24/05/2011 Added function to return line xrates if available, otherwise system rates
function GetExchangeRate(CXRate  :  CurrTypes;
                            ACurrency :  Byte) :  Double;
begin
  With SyssCurr^.Currencies[ACurrency] do
  Begin
    if not IsZero(CXRate[UseCoDayRate]) then
      Result := CXRate[UseCoDayRate]
    else
      Result := CRates[UseCoDayRate];
  end; {With..}
end;

//PR: 16/02/2016 v2016 R1 ABSEXCH-17309 Function to default notc flag on trans header
//                                      Adapted from TSalesTBody.DefaultNoTCIndex in SaleTx2U.pas
function DefaultNatureOfTransaction(DocType : DocTypes) : Byte;
begin
  if (DocType in PurchSplit + SalesSplit - [PPY, PBT, SRC, SBT]) then
  begin
    if CurrentCountry = IECCode then
    begin
      // Irish codes
      if DocType in SalesCreditSet + PurchCreditSet then
        Result := 2
      else
        Result := 1;
    end
    else
    begin
      if DocType in SalesCreditSet + PurchCreditSet then
        Result := 16
      else
        Result := 10;
    end;
  end
  else
    Result := 0;
end;


begin
  WantCalcLineCount := True;
  IncludeHiddenLines := False;
  AllowCtrlGLs := False;
  AddInLocationAdjLines := False; //PR: 18/03/2009
  {$IFDEF COMTK}
  LineMultiBuyDiscountsList := nil;
  IgnoreCreditLimit := False;
  {$ENDIF}
  IsUpdate := False;
end. 
