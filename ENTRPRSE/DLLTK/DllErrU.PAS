unit DllErrU;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{* ToolKit DLL Error Code Description *}

interface

Uses SysUtils;

{$IFNDEF WIN32}
Type
  ShortString = String;
{$ENDIF}

Var
  TmpStr  :  String[255];

  DlgMessageString : ShortString;


FUNCTION EX_GETLASTERRORDESC  :  SHORTSTRING;
                                 {$IFDEF WIN32} STDCALL {$ENDIF}
                                 EXPORT;

FUNCTION EX_ERRORDESCRIPTION(INDEXNO   :  SMALLINT;
                             ERRORCODE :  SMALLINT) : SHORTSTRING;
                             {$IFDEF WIN32} STDCALL {$ENDIF}
                             EXPORT;
{* ========================================================================== *}

implementation

{* ========================================================================== *}

Uses GlobVar, SpDllErr;

{* ---------- Ex_InitDLL Error Description ---------- *}
Function Get_InitDLL(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0     :  TmpStr := 'All files opened successfully';
    20    :  TmpStr := 'Unable to locate Btrieve Library';
    12    :  TmpStr := 'Unable to locate data file, Invalid Exchequer Path';
    14    :  TmpStr := 'Damaged Pre-Image file, repair data';
    15    :  TmpStr := 'Attempting to import multi currency data into single currency system';
    16    :  TmpStr := 'Attempting to import single currency data into multi currency system';
    18    :  TmpStr := 'ExchDLL.INI file could not be found or read';

    30001..30999  //Errors opening btrieve file - DlgMessageString will hold file name.
          :  TmpStr :=  DlgMessageString;

    32759 :  TmpStr := 'Timeout in User Security Sub-System';
    32760 :  TmpStr := 'Unable to load the Security Sub-System';
    32761 :  TmpStr := 'This Company Data Set is not part of the active Exchequer Installation';
    32762 :  TmpStr := 'This instance of the Toolkit is already in use';
    32763 :  TmpStr := 'Error locking ModR in Company Data Set';
    32764 :  TmpStr := 'Licenced User Count Exceeded';
    32765 :  TmpStr := 'User Count corruption';
    32766 :  TmpStr := 'Failed to load User Count Security Functions';
    32767 :  TmpStr := 'Invalid DLL Release Code';
  end; {case..}
  Get_InitDLL:=TmpStr;
end; {func..}

{* ---------- Ex_CloseDLL Error Description ---------- *}
Function Get_CloseDLL(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0     :  TmpStr:='All files closed successfully';
    32766 :  TmpStr := 'Failed to load User Count Security Functions';
  end; {case..}
  Get_CloseDLL:=TmpStr;
end; {func..}

{* ---------- Ex_GetAccount Error Description ---------- *}
Function Get_GetAccount(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
       0  : TmpStr:='Record found, no errors';
       4  : TmpStr:='No record found for SearchKey';
       9  : TmpStr:='End Of File reached';
    84,85 : TmpStr:='Record currently locked by another station';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetAccount:=TmpStr;
end; {func..}

{* ---------- Ex_GetAccount Error Description ---------- *}
Function Get_StoreAccount(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record successfully stored';
    2	   : TmpStr:='Database corrupt, unable to store record';
    4	   : TmpStr:='Update not possible as original version of record not found';
    5	   : TmpStr:='Duplicate Account code exists, record not stored';
    30000  : TmpStr:='Invalid storage code, ie must be B_Insert, or B_Update';
    30001  : TmpStr:='Invalid Account Type, must be C=Customer or S=Supplier';
    30002  : TmpStr:='Account type changed during edit not allowed';
    30003  : TmpStr:='Attempting to store a blank Account Code';
    30004  : TmpStr:='Invalid payment type must be C=Cash or B=Bank';
    30005  : TmpStr:='VAT code not valid, must be S,Z,E,1,2,3,4,5,6,7,8,9,A,D,T,X';
    30006  : TmpStr:='Invalid Default Nominal Code';
    30007  : TmpStr:='Invalid default currency, must be 1 to 30';
    30008  : TmpStr:='Invalid Cost of Sales Nominal Code';
    30009  : TmpStr:='Invalid Sales Nominal Code';
    30010  : TmpStr:='Invalid Location Code';
    30011  : TmpStr:='Invoice To code should not be the same as Account Code';
    30012  : TmpStr:='Statement To code should not be the same as Account Code';
    30013  : TmpStr:='Invalid SSD Delivery Terms';
    30014  : TmpStr:='Invalid CVATIncFlg, must not be M or I';
    30015  : TmpStr:='Invalid invoice delivery mode, must be 0..8';
    30016  : TmpStr:='Invalid Default Tag Number, must be 0..99';
    30017  : TmpStr:='Invalid Default PPD Days, must be 0..999 inclusive';
    30018  : TmpStr:='Invalid Cost Centre/Department Code';
    30019  : TmpStr:='Invalid Mandate Date';
    30020  : TmpStr:='Invalide SubType. Must be ''C'',''S'' or ''U''.';
    30021  : TmpStr:='SubType cannot be changed during edit.';
    30022  : TmpStr:='For Consumer records, Long Account Code cannot be blank.';
    // CJS 2014-08-06 - v7.x Order Payments - T097 - new fields
    30023  : TmpStr:='Invalid Order Payments Nominal Code';

    //PR: 27/11/2014 Order Payments
    30024  : TmpStr:='Invalid Country';
    30025  : TmpStr:='Invalid Delivery Country';

    30026  : TmpStr:='For Customers and Consumers PPD Mode must be 0, 1, or 2; for Suppliers must be 0, 1, or 3';
    30027  : TmpStr:='Invalid Default PPD Percentage, must be 0 to 99.99 inclusive';
    30028  : TmpStr:='DefaultToQR only valid for EC customers and when Intrastat is used';
    30029  : TmpStr:='Customer/Supplier must be EC Member to use Intrastat fields';
    30030  : TmpStr:='Invalid Intrastat Mode of Transport';

    {SS 15/06/2016 2016-R3 ABSEXCH-12948:Core Financials - Possible to import Transactions with Inactive CC/Depts using Importer Module.}
    30031  : TmpStr:='Inactive Cost Centre/Department Code';



    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
    {AP 27/11/2017 2018-R1 ABSEXCH-19387 Added to restrict Anonymised Account from edit}
    30032  : TmpStr:='Anonymised account can not be edited.';
  end; {case..}
  Get_StoreAccount:=TmpStr;
end; {func..}

{* ---------- Ex_UnLockAccount Error Description ---------- *}
Function Get_UnLockAccount(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0    : TmpStr:='Unlock Account Record successfully';
  end; {case..}
  Get_UnlockAccount:=TmpStr;
end; {func..}

{* ---------- Ex_GetAccountBalance Error Description ---------- *}
Function Get_GetAccountBalance(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	  : TmpStr:='Record found, no errors';
    4	  : TmpStr:='No record found for SearchKey';
    30001 : TmpStr:='Invalid Period';
    30002 : TmpStr:='Invalid Year';
    30008 : TmpStr:='Invalid Search Mode must be 0-7 or 9';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetAccountBalance:=TmpStr;
end; {func..}

{ EX_STOREDISCMATRIX }
Function Get_StoreDiscMatrix(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record successfully stored';
    2	   : TmpStr:='Database corrupt, unable to store record';
    4	   : TmpStr:='Update not possible as original version of record not found';
    5	   : TmpStr:='Duplicate code exists, record not stored';
    30001  : TmpStr:='Invalid Account Code';
    30002  : TmpStr:='Invalid Stock Code';
    30003  : TmpStr:='FROM Quantity should not be more than TO Quantity';
    30004  : TmpStr:='Invalid Discount Type';
    30005  : TmpStr:='Discount Type is Special Price and Unit Price should not be Zero';
    30006  : TmpStr:='Invalid Currency Code';
    30007  : TmpStr:='Invalid Sales Band';
    30008  : TmpStr:='Margin or MarkUp % should not be Zero';
    30009  : TmpStr:='Invalid DateEffectiveFrom';
    30010  : TmpStr:='Invalid DateEffectiveTo';
    30011  : TmpStr:='Effective Date Range conflicts with existing date range';
    30012  : TmpStr:='End Date should not be earlier than Start Date';

    {SS 21/06/2016 2016-R3 -ABSEXCH-15169:Importer-displays misleading error when importing conflicting qty break ranges.}
    30013  : TmpStr:='Cannot import qty break discounts for same qty range';

    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreDiscMatrix:=TmpStr;
end; {func..}

{ EX_GETDISCMATRIX }
Function Get_GetDiscMatrix(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	  : TmpStr:='Record found, no errors';
    4	  : TmpStr:='No record found for SearchKey';
    9	  : TmpStr:='End Of File reached';
    84,85 : TmpStr:='Record currently locked by another station';
    30001 : TmpStr:='Both customer and stock code should not be blank';
    30002 : TmpStr:='Invalid stock code';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
end; {case..}
  Get_GetDiscMatrix:=TmpStr;
end; {func..}


{* ---------- Ex_GetTrans Error Description ---------- *}
Function Get_GetTrans(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	  : TmpStr:='Record found, no errors';
    4	  : TmpStr:='No record found for SearchKey';
    9	  : TmpStr:='End Of File reached';
    84,85 : TmpStr:='Record currently locked by another station';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetTrans:=TmpStr;
end; {func..}

{* ---------- Ex_StoreTrans Error Description ---------- *}
Function Get_StoreTrans(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	  : TmpStr:='Record successfully stored';
    2	  : TmpStr:='Database corrupt, unable to store record';
    3	  : TmpStr:='Invalid Transaction Type (must be SIN,PIN,etc..)';
    4	  : TmpStr:='Update not possible as original version of record not found';
    5	  : TmpStr:='Duplicate Transaction number/Folio number exists, record not stored';
    30100 : TmpStr:='Invalid Line currency, must be 1-30 or 0 for single currency use';
    30101 : TmpStr:='Invalid Line Daily currency rate. Must be greater than 0';
    30102 : TmpStr:='Invalid Line Company rate. Must be greater than 0';
    30103 : TmpStr:='Invalid Line Number. Must be greater than 0';
    30104 : TmpStr:='Invalid Line/Default Nominal Code';
    30105 : TmpStr:='Invalid Line Cost Center/Department Code';
    30106 : TmpStr:='Invalid Line Stock Code';
    30107 : TmpStr:='Invalid Line VAT Code.';
    30108 : TmpStr:='Invalid Line discount character.  Must be %,A-H';
    30109 : TmpStr:='Line Totals do not balance with Transaction totals';
    30110 : TmpStr:='Line payment does not balance';
    30111 : TmpStr:='Invalid Transaction Line Job Code';
    30112 : TmpStr:='Invalid Transaction Line Job Analysis Code';
    30113 : TmpStr:='Invalid Pay Rate Code';
    30114 : TmpStr:='Invalid Charge Currency Code of Job Costing Time Sheet';
    30115 : TmpStr:='Invalid Stock Location Code';
    30116 : TmpStr:='Invalid Intrastat Uplift %, must be 0..100';
    30117 : TmpStr:='Invalid SSD Commodity/TARIC Code, must be 8 digits, 10 digits or blank';
    30118 : TmpStr:='Invalid General Ledger default currency code';
    30119 : TmpStr:='Invalid VAT include flag';
    30120 : TmpStr:='The last 6 digits of OurRef must be numeric';
    30121 : TmpStr:='Lines total and Header total must be zero for NOM transaction';
    30122 : TmpStr:='Reconcile field must be in range 0 to 4';

    30123 : TmpStr:='Line 1 of a WOP transaction must be a BOM';
    30124 : TmpStr:='Line 1 of a WOP transaction: Qty must be > 0';
    30125 : TmpStr:='Nominal code is not correct for stock/location';

    30126 : TmpStr:='Transaction Line Job is closed';
    30127 : TmpStr:='Applied amount must not be more than budget';
    30128 : TmpStr:='Certified amount must not be more than budget';
    30129 : TmpStr:='Specified terms line not found';
    30130 : TmpStr:='Qty Repaired + Qty Written Off cannot exceed Qty Returned';
    30131 : TmpStr:='Duplicate line numbers.';
    30132 : TmpStr:='Invalid Line Multi-Buy Discount character.  Must be %';
    30133 : TmpStr:='Invalid Line Transaction Value discount character.  Must be %';

    //PR: 10/09/2009 Added EC Service validation messages
    30134 : TmpStr:='EC Service Line: Invalid Service Start Date';
    30135 : TmpStr:='EC Service Line: Invalid Service End Date';
    30136 : TmpStr:='EC Service Line: Service Start Date cannot be later than Service End Date';

    30137 : TmpStr:='EC Service Line: Customer/Supplier must be EC Member';
    30138 : TmpStr:='EC Service Line: Transaction SSD Process must be ''Normal''';
    30139 : TmpStr:='EC Service Line: Invalid Transaction Type';
    30140 : TmpStr:='EC Service Line: Stock Code must be blank or for Description-Only Stock Item';
    30141 : TmpStr:='EC Service Line: Payment Line cannot be Service';
    30142 : TmpStr:='EC Service Line: Invalid VAT Code - Sales must be ''D'', Purchases cannot be ''A'' or ''D''';

    30143 : TmpStr:='Line Location must be the same as Header Override Location';
    30144 : TmpStr:='Items cannot be picked on a SOR if the customer is on hold';

    //PR: 16/09/2014  v7.x Order Payments
    30145 : TmpStr:='Some fields cannot be changed once payments have been made. See documentation.';

    //PR: 20/01/2016 ABSEXCH-17112 v2016 R1
    30146 : TmpStr:='Invalid Nature of Transaction Code';
    30147 : TmpStr:='Invalid SSD Country';

    {SS 15/06/2016 2016-R3
    ABSEXCH-12948:Core Financials - Possible to import Transactions with Inactive CC/Depts using Importer Module.}
    30148 : TmpStr:='Inactive Cost Centre/Department Code';

    // SSK 19/05/2017 2017-R1 ABSEXCH-18421: new error code n message added for blank JobCode and AnalysisCode
    30149 : TmpStr:='A valid Job Code must be present for that G/L Code';
    30150 : TmpStr:='A valid Job Analysis code must be present for that G/L Code';


    {Transaction Header Errors}
    31000..31199
          : TmpStr:='Btrieve error in obtaining next transaction number';
    31300..31399
          : TmpStr:='Btrieve error in updating account balance';
    30200 : TmpStr:='Duplicate Your Ref field. Only applicable if prevent duplicate your ref set';
    30201 : TmpStr:='Invalid Transaction type. Must be SIN/SRC/SCR etc';
    30202 : TmpStr:='Invalid Account Code';
    30203 : TmpStr:='Invalid Transaction Date';
    30204 : TmpStr:='Invalid Transaction Period';
    30205 : TmpStr:='Invalid Transaction Year';
    30206 : TmpStr:='VAT Split incorrectly. The individual VAT rates do not add up to the Total VAT Amount';
    30207 : TmpStr:='Invalid currency. Must be 1-30, or 0 for single currency use';
    30208 : TmpStr:='Invalid Daily currency rate. Must be greater than 0';
    30209 : TmpStr:='Invalid Company rate. Must be greater than 0';
    30210 : TmpStr:='Invalid Employee Code (for Job Costing)';
    30211 : TmpStr:='Invalid Job Code';
    30212 : TmpStr:='Invalid Job Analysis Code';
    30213 : TmpStr:='Invalid Debtor/Creditor Control Nominal Code';
    30214 : TmpStr:='Invalid Debtor/Creditor Control Nominal Code of Account Record';
    30215 : TmpStr:='Invalid Document Type. Check TransDocHed field.';
    30216 : TmpStr:='Invalid SSD Process Code, must be T or P or leave blank';
    30217 : TmpStr:='Invalid Document Type for E-Business Transaction. Check TransDocHed and E-BusTran fields.';
    30218 : TmpStr:='Invalid Tag - must be in range 0..99';
    30219 : TmpStr:='Invalid Stock Location';

    {$IFDEF COMTK}
    30220 : TmpStr:='Auto transaction: End date is invalid';
    30221 : TmpStr:='Auto transaction: End period is invalid';
    30222 : TmpStr:='Auto transaction: End year is invalid';
    30223 : TmpStr:='Invalid Bank GL for Batch Header';
    30224 : TmpStr:='Unable to save Batch Header';
    {$ENDIF}

    30225 : TmpStr:='If VAT on NOM Lines then NOMVatIO must be ''I'' or ''O''';
    30226 : TmpStr:='On Application, Employee must be Sub-contractor';
    30227 : TmpStr:='Employee must match Employee on parent terms';
    30228 : TmpStr:='Application cannot be for a stage earlier than the terms';
    30229 : TmpStr:='Order total exceeds customer credit limit';
    30230 : TmpStr:='Invalid In Location';
    30231 : TmpStr:='Week/Month must be between -999 and 9999';
    30232 : TmpStr:='Invalid Header Override Location';
    30233 : TmpStr:='Header Override Location cannot be changed';
    30234 : TmpStr:='Transaction Header Job is closed';
    30235 : TmpStr:='Invalid hold flag. Must be 0-6 (+ 32 for notes, + 128 for suspend posting.)';
    30236 : TmpStr:='Invalid Transaction Originator';

    //PR: 24/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015
    30237 : TmpStr:='Settlement Discount fields cannot be set on transactions dated from 01/04/2015';

    //AP : 24/03/2017 2017-R1 ABSEXCH-18045 : Toolkit Allows Transactions To Be Added With Invalid Due Dates
    30238 : TmpStr:='Invalid Transaction Due Date';

    //PR: 16/09/2014  v7.x Order Payments
    30239 : TmpStr:='The transaction value must not be less than the payments made against it';
    30240 : TmpStr:='Some fields cannot be changed once payments have been made. See documentation.';
    30241 : TmpStr:='Invalid Delivery Country.';

    //PR: 28/10/2010 ABSEXCH-14705
    30242 : TmpStr:='Prompt Payment Discount fields cannot be set on transactions dated before 01/04/2015';
    // MH 30/06/2015 v7.0.14 ABSEXCH-16600: Modified validation to comply to Exchequer
    30243 : TmpStr:='thPPDPercentage must be >= 0 and < 1';
    // MH 30/06/2015 v7.0.14 ABSEXCH-16600: Modified validation to comply to Exchequer
    30244 : TmpStr:='thPPDDays must be between 0 and 999';

    30245 : TmpStr:='Invalid Intrastat Delivery Terms';
    30246 : TmpStr:='Invalid Intrastat Nature of Transaction Code';
    30247 : TmpStr:='Invalid Intrastat Transport Mode';
    30248 : TmpStr:='Intrastat Fields are only available for EC Members';
    30249 : TmpStr:='Intrastat Fields are not available unless Intrastat is enabled';

    // SSK 09/09/2016 2016-R3 ABSEXCH-17216:Error code added for Closed Traders
    30250  : TmpStr:='Trader is Closed';

    //AP 09/01/2018 GDPR - Toolkit DLL Support - Ex_StoreTrans : validation on TSH for Open Employee
    30251  : TmpStr:='Employee is Closed';

    //PR: 20/10/2014 Order Payments - Importer only
    {$IFDEF ImpV6}
    30400 : TmpStr:='Order Payments is not enabled in System Setup';
    30401 : TmpStr:='This Customer does not use Order Payments';
    30402 : TmpStr:='Order Payments can only be made against SORs';
    30403 : Tmpstr:='Order Payment value must be more than zero and cannot exceed the outstanding value on the order';
    30404 : TmpStr:='Invalid Order Payment Cost Centre';
    30405 : TmpStr:='Invalid Order Payment Department';
    30406 : TmpStr:='Invalid Order Payment Bank GL';

    {$ENDIF}

    30500 : TmpStr:='Record not found to update';
    30501 : TmpStr:='This transaction type is not allowed to update.';
    30502 : TmpStr:='The record is View Only Status. Cannot be updated.';
    30503 : TmpStr:='Account Code must be the same for updating trans.';
    30504 : TmpStr:='The transaction line has a delivered quantity: the stock code cannot be changed.';
    30505 : TmpStr:='Line quantity must be greater than or equal to delivered quantity';
    30506 : TmpStr:='The transaction header has an Override Location: the line location cannot be changed.';
{
    30219 : TmpStr:='The transaction has SOP Link. Cannot be updated.';
    30220 : TmpStr:='The transaction has partial/full delivered status. Cannot be updated.';
}
    30702 : TmpStr:='The System CIS GL Codes have not been set correctly; CIS calculation cannot be completed.';

    32765 : TmpStr:='Size of Total Transaction Lines incorrect';
    32766 : TmpStr:='Transaction Header record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreTrans:=TmpStr;
end; {func..}


{* ---------- Ex_GetNextTransNo Error Description ---------- *}
Function Get_GetNextTransNo(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
        0  : TmpStr:='Next Transaction Number successfully returned';
    31000..31199
    	   : TmpStr:='Btrieve Error '+IntToStr(TErCode-30000);
    30201  : TmpStr:='Invalid transaction type in DocStr';
  end; {case..}
  Get_GetNextTransNo:=TmpStr;
end; {func..}

{* ---------- Ex_GetTotalTransLines Error Description ---------- *}
Function Get_GetTotalTransLines(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0 : TmpStr:='Record not found or there is no transaction line for passing reference number';
  else
    TmpStr:='Number of transaction lines';
  end; {case..}
  Get_GetTotalTransLines:=TmpStr;
end; {func..}

{* ---------- Ex_GetTransHed Error Description ---------- *}
Function Get_GetTransHed(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetTransHed:=TmpStr;
end; {func..}

{* ---------- Ex_GetTransLines Error Description ---------- *}
Function Get_GetTransLine(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetTransLine:=TmpStr;
end; {func..}

{* ---------- Ex_GetStock Error Description ---------- *}
Function Get_GetStock(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetStock:=TmpStr;
end; {func..}

{* ---------- Ex_StoreStock Error Description ---------- *}
Function Get_StoreStock(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record successfully stored';
    2	   : TmpStr:='Database corrupt, unable to store record';
    4	   : TmpStr:='Update not possible as original version of record not found';
    5	   : TmpStr:='Duplicate Stock Code/folio number exists, record not stored';
    30270  : TmpStr:='Stock Group changed';
    30271  : TmpStr:='Invalid Stock Type or Stock Type changed';
    30272  : TmpStr:='Blank Stock Code';
    30273  : TmpStr:='Stock Group not Valid';
    30274  : TmpStr:='Invalid VAT Code. Must be S,Z,E,1,2,3,4,5,6,7,8,9,A,D,T,X';
    30275  : TmpStr:='Invalid Preferred supplier';
    30276  : TmpStr:='Invalid Cost Price currency';
    30277  : TmpStr:='Invalid Reorder currency. Must be 1-30, or 0 for single currency use';
    30278  : TmpStr:='Invalid Sales Price Currency';
    30279  : TmpStr:='Invalid Valuation Type. Must be F,L,S,A,R,C';
    30280  : TmpStr:='Invalid Stock Nominal Code';
    30281  : TmpStr:='Invalid Selling Unit, Must be greater than 0';
    30282  : TmpStr:='Invalid Buying Unit, Must be greater than 0';
    30283  : TmpStr:='Invalid SSD Unit. Must be greater than 0';
    30284  : TmpStr:='Invalid cover period, must be greater than 0';
    30285  : TmpStr:='Invalid cover min reorder level. Must be greater than 0';
    30286  : TmpStr:='Invalid cover max reorder level. Must be greater than 0';
    30287  : TmpStr:='Invalid Cost Centre Code';
    30288  : TmpStr:='Invalid Department Code';
    30289  : TmpStr:='Invalid ReOrder Cost Centre Code';
    30290  : TmpStr:='Invalid ReOrder Department Code';
    30291  : TmpStr:='Invalid Location Code';
    30292  : TmpStr:='Invalid Serial No. Average, must be either 0 or 1';
    30293  : TmpStr:='SSD Despatch Uplift % should be in 0..100';
    30294  : TmpStr:='Invalid SVATIncFlg, must not be M or I';
    30295  : TmpStr:='Invalid Job Analysis Code.';
    30296  : TmpStr:='Should not set True in both Price by Split Pack and by Stock Unit';
    30297  : TmpStr:='Invalid WOP Issued WIP Nominal Code';
    30298  : TmpStr:='Invalid Sales Return Nominal Code';
    30299  : TmpStr:='Invalid Purchase Return Nominal Code';
    30300  : TmpStr:='IsService can only be set for Description Only type stock';
    30301  : TmpStr:='Commodity/TARIC Code must be 8 digits, 10 digits or blank';
    
	  {SS 15/06/2016 2016-R2 ABSEXCH-13693:Importer doesn't validate Global Time Rate record import where the same Stock Code already exists and vice versa.}
    30302  : TmpStr:='That Stock Code already exists as a Time Rate Code';

    {SS 15/06/2016 2016-R3 ABSEXCH-12948:Core Financials - Possible to import Transactions with Inactive CC/Depts using Importer Module.}
    30303  : TmpStr:='Inactive Cost Centre Code';
    30304  : TmpStr:='Inactive Department Code';
                                                                              

    NoStockErr : TmpStr := NoStockStr;
    NoFullStock : TmpStr := NoFullStockStr;
  end; {case..}
  Get_StoreStock:=TmpStr;
end; {func..}

{* ---------- Ex_UnlockStock Error Description ---------- *}
Function Get_UnlockStock(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0  :  TmpStr:='Unlock record successfully';
  end; {case..}
  Get_UnlockStock:=TmpStr;
end; {func..}

{* ---------- Ex_GetGLAccount Error Description ---------- *}
Function Get_GetGLAccount(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetGLAccount:=TmpStr;
end; {func..}

{* ---------- Ex_StoreGLAccount Error Description ---------- *}
Function Get_StoreGLAccount(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record successfully stored';
    2	   : TmpStr:='Database corrupt, unable to store record';
    4	   : TmpStr:='Update not possible as original version of record not found';
    5	   : TmpStr:='Duplicate Nominal code exists, record not stored';
    30000  : TmpStr:='Invalid storage code, ie must be B_Insert or B_Update';
    30001  : TmpStr:='Parent Code is changed during editing which is not allowed';
    30002  : TmpStr:='Nominal Type is changed during editing which is not allowed';
    30003  : TmpStr:='Nominal Code must be greater than 0';
    30004  : TmpStr:='Invalid Nominal Type, must be H,C,F,A,B';
    30005  : TmpStr:='Invalid Parent Code';
    30006  : TmpStr:='Invalid Carry Forward Code';
    30007  : TmpStr:='Invalid Currency Code';
    30008  : TmpStr:='This Nominal Type cannot be used in this section of the GL';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreGLAccount:=TmpStr;
end; {func..}

{* ---------- Ex_GetStockBOM Error Description ---------- *}
Function Get_GetStockBOM(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
        0  : TmpStr:='Record found, no errors';
    30001  : TmpStr:='Invalid Stock Code';
    30002  : TmpStr:='Invalid Stock Type ("M" for SearchMode 0, must not be "G" for SearchMode 1)';
    30003  : TmpStr:='There is no stock component for defined BOM Stock Code';
    30004  : TmpStr:='Defined Stock Code is not used as a component';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetStockBOM:=TmpStr;
end; {func..}

{* ---------- Ex_GetLineSerialNos Error Description ---------- *}
Function Get_GetLineSerialNos(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
      0	   : TmpStr:='Record found, no errors';
    30001  : TmpStr:='Invalid Transaction Number';
    30002  : TmpStr:='Invalid Line Number';
    30003  : TmpStr:='There is no Stock Code for defined Transaction number and Line number';
    30004  : TmpStr:='Invalid Stock Valuation Type, must be "R" ';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetLineSerialNos:=TmpStr;
end; {func..}

{* ---------- Ex_GetAccountFileSize Error Description ---------- *}
Function Get_GetAccountFileSize(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0  : TmpStr:='No record in Account file';
  end; {case..}
  Get_GetAccountFileSize:=TmpStr;
end; {func..}

{* ---------- Ex_StoreStockBOM Error Description ---------- *}
Function Get_StoreStockBOM(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
        0  : TmpStr:='Successfully saved, no errors';
    30001  : TmpStr:='Invalid Parent Stock Code (passed as SearchKey)';
    30002  : TmpStr:='Invalid Parent Stock Type (must be "M" for Bill of Material)';
    30101  : TmpStr:='Component Stock Code must not be the same as current parent Stock Code';
    30102  : TmpStr:='Invalid Component Stock Code';
    30103  : TmpStr:='Invalid Component Stock Type (must not be "G" - Group Type)';
    30104  : TmpStr:='Unable to lock records to be updated';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
    NoStockErr : TmpStr := NoStockStr;
  end; {case..}
  Get_StoreStockBOM:=TmpStr;
end; {func..}

{* ---------- Ex_GetJob Error Description ---------- *}
Function Get_GetJob(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetJob:=TmpStr;
end; {func..}

{* ---------- Ex_StoreJob Error Description ---------- *}
Function Get_StoreJob(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0     : TmpStr:='Record successfully stored';
    2	  : TmpStr:='Database corrupt, unable to store record';
    4	  : TmpStr:='Update not possible as original version of record not found';
    5	  : TmpStr:='Duplicate Nominal code exists, record not stored';
    30000 : TmpStr:='Invalid storage code, ie must be B_Insert or B_Update';
    30001 : TmpStr:='Job Type is changed during editing which is not allowed';
    30002 : TmpStr:='Parent Job Category is changed during editing which is not allowed';
    30003 : TmpStr:='Empty Job Code';
    30004 : TmpStr:='Invalid Job Type, must be K,J';
    30005 : TmpStr:='Invalid Currency Code';
    30006 : TmpStr:='Invalid Job Parent Category Code';
    30007 : TmpStr:='Invalid VAT Code';
    30008 : TmpStr:='Invalid Customer Code';
    30009 : TmpStr:='Invalid Start Date';
    30010 : TmpStr:='Invalid End Date';
    30011 : TmpStr:='Invalid Revised Date';
    30012 : TmpStr:='Invalid JobAnal Code - must be a valid Exchequer Job Type';
    30013 : TmpStr:='Invalid Cost Centre/Department Code';
    NoJobErr : TmpStr := NoJobStr;
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreJob:=TmpStr;
end; {func..}

{* ---------- Ex_StoreJobEmployee Error Description ---------- *}
Function Get_StoreJobEmployee(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0     : TmpStr:='Record successfully stored';
    2	  : TmpStr:='Database corrupt, unable to store record';
    4	  : TmpStr:='Update not possible as original version of record not found';
    5	  : TmpStr:='Employee Code already exists';
    30000 : TmpStr:='Invalid storage code, ie must be B_Insert or B_Update';
    30001 : TmpStr:='Invalid Cost Centre or Department';
    30002 : TmpStr:='Invalid Supplier Code';
    30003 : TmpStr:='Invalid Certificate Expiry Date';
    30004 : TmpStr:='Error finding Group Certificate details';
    30005 : TmpStr:='Error setting Group Certificate details';

    {SS 25/05/2016 2016-R2
	   ABSEXCH-16608:importer issues - Employee Records the field EMSUBTYP
   	 - Added error message for invalid Contractor Type.}
    30006 : TmpStr:='Invalid Contractor Type';

    {SS 17/06/2016 2016-R3
    ABSEXCH-12948:Core Financials - Possible to import Transactions with Inactive CC/Depts using Importer Module.}
    30007 : TmpStr:='Inactive Cost Centre/Department Code';

    {AP:10/01/2018 2018R1:ABSEXCH-19588:Added to restrict Employee Open/Close Behaviour}
    30008 : TmpStr:='Anonymised Employee can not be edited.';

    {AP 22/06/2018 ABSEXCH-20851:Validation check for the Employee associated with the Trader account}
    30009 : TmpStr:='You cannot "Open" Employee as associated Supplier is "Closed!"';

    NoJobErr : TmpStr := NoJobStr;
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreJobEmployee:=TmpStr;
end; {func..}

{* ---------- Ex_StoreAnalysis Error Description ---------- *}
Function Get_StoreJobAnalysis(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0     : TmpStr:='Record successfully stored';
    2	  : TmpStr:='Database corrupt, unable to store record';
    4	  : TmpStr:='Update not possible as original version of record not found';
    5	  : TmpStr:='Analysis Code already exists';
    30000 : TmpStr:='Invalid storage code, ie must be B_Insert or B_Update';
    30001 : TmpStr:='Analysis Code must not be blank';
    30002 : TmpStr:='Invalid Analysis Type. Must be R, O, M or L';
    30003 : TmpStr:='Invalid Analysis Category. Must be A,D,I,R,S,T,N,O,W or P';
    30004 : TmpStr:='Invalid Line Type. Must be N, F, L, M or D';
    30005 : TmpStr:='Invalid WIP Nominal Code';
    30006 : TmpStr:='Invalid PL Nominal Code';
    30007 : TmpStr:='Invalid Uplift Nominal Code';
    30008 : TmpStr:='Invalid CIS Tax Type';
    30009 : TmpStr:='Invalid combination of Category and Type';
    NoJobErr : TmpStr := NoJobStr;
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreJobAnalysis:=TmpStr;
end; {func..}

{* ---------- Ex_StoreJobType Error Description ---------- *}
Function Get_StoreJobType(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0     : TmpStr:='Record successfully stored';
    2	  : TmpStr:='Database corrupt, unable to store record';
    4	  : TmpStr:='Update not possible as original version of record not found';
    5	  : TmpStr:='Type Code already exists';
    30000 : TmpStr:='Invalid storage code, ie must be B_Insert or B_Update';
    30001 : TmpStr:='Type Code must not be blank';
    NoJobErr : TmpStr := NoJobStr;
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreJobType:=TmpStr;
end; {func..}

{* ---------- Ex_StoreJobTimeRate Error Description ---------- *}
Function Get_StoreJobTimeRate(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0     : TmpStr:='Record successfully stored';
    2	  : TmpStr:='Database corrupt, unable to store record';
    4	  : TmpStr:='Update not possible as original version of record not found';
    5	  : TmpStr:='Rate Code already exists';
    30000 : TmpStr:='Invalid storage code, ie must be B_Insert or B_Update';
    30001 : TmpStr:='Rate Code must not be blank';
    30002 : TmpStr:='Invalid Analysis Code';
    30003 : TmpStr:='Invalid Employee Code';
    30004 : TmpStr:='Invalid Cost Currency';
    30005 : TmpStr:='Invalid Charge Currency';
    30006 : TmpStr:='Employee or Job time rate must be based on Global Rate';
    30007 : TmpStr:='Invalid Analysis Type';
    30008 : TmpStr:='Pay Factor must be in range 0-99';
    30009 : TmpStr:='Payroll Code must be in range 0-99';
	{SS 15/06/2016 2016-R3 ABSEXCH-13693:Importer doesn't validate Global Time Rate record import where the same Stock Code already exists and vice versa.}
    30010 : TmpStr:='Time Rate Code already exists as a Stock Code'; 
                                                                     
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreJobTimeRate:=TmpStr;
end; {func..}

Function Get_GetStkAlt(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetStkAlt:=TmpStr;
end; {func..}


{* ---------- Ex_StoreStockLoc Error Description ---------- *}
Function Get_StoreStkAlt(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	  : TmpStr:='Record successfully stored';
    2	  : TmpStr:='Database corrupt, unable to store record';
    4	  : TmpStr:='Update not possible as original version of record not found';
    5	  : TmpStr:='Duplicate Location Code/folio number exists, record not stored';
    30001 : TmpStr:='Invalid Stock Code';
    30002 : TmpStr:='Invalid Supplier or Customer Code';
    30003 : TmpStr:='Invalid Currency Code';
    30004 : TmpStr:='Record not found to be updated';
    30005 : TmpStr:='Record exists to be added';
    30006 : TmpStr:='Unable to update/add record';
    30007 : TmpStr:='Equivalent, Superseded By or Opportunity code must be valid stock code';
    NoStockErr : TmpStr := NoStockStr;
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpSTr:='Record not initialised correctly';
  end; {case..}
  Get_StoreStkAlt:=TmpStr;
end; {func..}

{* ---------- Ex_GetStockLoc Error Description ---------- *}
Function Get_GetStockLoc(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetStockLoc:=TmpStr;
end; {func..}

{* ---------- Ex_StoreStockLoc Error Description ---------- *}
Function Get_StoreStockLoc(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	  : TmpStr:='Record successfully stored';
    2	  : TmpStr:='Database corrupt, unable to store record';
    4	  : TmpStr:='Update not possible as original version of record not found';
    5	  : TmpStr:='Duplicate Location Code/folio number exists, record not stored';
    30270 : TmpStr:='Invalid Stock Code';
    30271 : TmpStr:='Stock Group not valid';
    30272 : TmpStr:='Invalid Location Code';
    30273 : TmpStr:='Temp. Supplier not valid';
    30274 : TmpStr:='Main Supplier not valid';
    30275 : TmpStr:='Invalid Cost Price Currency';
    30276 : TmpStr:='Invalid Re-Order Price Currency';
    30277 : TmpStr:='Invalid Sales Price Currency';
    30278 : TmpStr:='Invalid Nominal Code';
    30279 : TmpStr:='Invalid Cost Centre';
    30280 : TmpStr:='Invalid Department';
    30281 : TmpStr:='Invalid Re-Order Cost Centre';
    30282 : TmpStr:='Invalid Re-Order Department';
    30283 : TmpStr:='Invalid Sales Return GL Code';
    30284 : TmpStr:='Invalid Purchase Return GL Code';

    NoStockErr : TmpStr := NoStockStr;
  end; {case..}
  Get_StoreStockLoc:=TmpStr;
end; {func..}

{* ---------- Ex_GetLocation Error Description ---------- *}
Function Get_GetLocation(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0     : TmpStr:='Record found, no errors';
    4	  : TmpStr:='No record found for SearchKey';
    9	  : TmpStr:='End Of File reached';
    84,85 : TmpStr:='Record currently locked by another station';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetLocation:=TmpStr;
end; {func..}

{* ---------- Ex_StoreLocation Error Description ---------- *}
Function Get_StoreLocation(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record successfully stored';
    2	   : TmpStr:='Database corrupt, unable to store record';
    4	   : TmpStr:='Update not possible as original version of record not found';
    5	   : TmpStr:='Duplicate Stock Code/folio number exists, record not stored';
    30271  : TmpStr:='Blank Location Code';
    30272  : TmpStr:='Invalid Currency Code';
    30273  : TmpStr:='Cost Centre Code not valid';
    30274  : TmpStr:='Department Code not valid';
    30275  : TmpStr:='Invalid Nominal Code';
    30276  : TmpStr:='Invalid Sales Return Nominal Code';
    30277  : TmpStr:='Invalid Purchase Return Nominal Code';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';

    NoStockErr : TmpStr := NoStockStr;
  end; {case..}
  Get_StoreLocation:=TmpStr;
end; {func..}

{* ---------- Ex_GetMatch Error Description ---------- *}
Function Get_GetMatch(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetMatch:=TmpStr;
end; {func..}

{* ---------- Ex_GetMatch Error Description ---------- *}
Function Get_DeleteMatch(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record deleted, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    30000  : TmpStr:='Matching must be User Type';
    30001  : TmpStr:='Can''t find record to delete';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_DeleteMatch:=TmpStr;
end; {func..}


{* ---------- Ex_StoreMatch Error Description ---------- *}
Function Get_StoreMatch(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	  : TmpStr:='Record successfully stored';
    2	  : TmpStr:='Database corrupt, unable to store record';
    4	  : TmpStr:='Update not possible as original version of record not found';
    5	  : TmpStr:='Duplicate Nominal code exists, record not stored';
    30001 : TmpStr:='Invalid Debit Document Number';
    30002 : TmpStr:='Debit Document was allocated incorrectly';
    30003 : TmpStr:='Allocated Currency does not match with Debit Document Currency';
    30004 : TmpStr:='Over settled amount (Debit Document)';
    30005 : TmpStr:='Invalid Credit Document Number';
    30006 : TmpStr:='Account Code does not match';
    30007 : TmpStr:='Incompatible Document Type';
    30008 : TmpStr:='Credit Document was allocated incorrectly';
    30009 : TmpStr:='Allocated Currency does not match with Credit Document Currency';
    30010 : TmpStr:='Over settled amount (Credit Document)';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreMatch:=TmpStr;
end; {func..}

{* ---------- Ex_GetNotes Error Description ---------- *}
Function Get_GetNotes(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    30001  : TmpStr:='Unable to locate parent record';
    30002  : TmpStr:='No notes line';
    //PR: 07/11/2011 v6.9 Don't allow audit notes to be searched for - add check for note type.
    30003  : TmpStr:='Invalid Note Type (must be 1=General / 2=Dated Note)';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetNotes:=TmpStr;
end; {func..}

{* ---------- Ex_StoreNotes Error Description ---------- *}
Function Get_StoreNotes(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record successfully stored';
    2	   : TmpStr:='Database corrupt, unable to store record';
    30001  : TmpStr:='Invalid Note Sort (must be ACC/STK/DOC)';
    30002  : TmpStr:='Invalid Note Type (must be 1=General / 2=Dated Note)';
    30003  : TmpStr:='Unable to locate parent record of this note line';
    30004  : TmpStr:='Invalid Note line number (must be > 0)';
    30005  : TmpStr:='Invalid Note Date';
    30006  : TmpStr:='Invalid Alarm Date';
    30007  : TmpStr:='Invalid user name in the Exchequer for NoteFor field';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreNotes:=TmpStr;
end; {func..}

{* ---------- Ex_GetCCDep Error Description ---------- *}
Function Get_GetCCDep(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetCCDep:=TmpStr;
end; {func..}

{* ---------- Ex_CalcStockPrice Error Description ---------- *}
Function Get_CalcStockPrice(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for SearchKey';
    9	   : TmpStr:='End Of File reached';
    30101  : TmpStr:='Invalid Stock Code';
    30102  : TmpStr:='Invalid Stock Type';
    30103  : TmpStr:='Invalid Customer Code';
    30104  : TmpStr:='Invalid Currency Code';
    30105  : TmpStr:='Invalid Location Code';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_CalcStockPrice:=TmpStr;
end; {func..}

{* ---------- Ex_GetVATRate Error Description ---------- *}
Function Get_GetVATRate(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	    : TmpStr:='Record found, no errors';
    4	    : TmpStr:='No record found for SearchKey';
    9	    : TmpStr:='End Of File reached';
    84,85   : TmpStr:='Record currently locked by another station';
    32766   : TmpStr:='Record size incorrect';
    32767   : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetVATRate:=TmpStr;
end; {func..}

{* ---------- Ex_InitDLLPath Error Description ---------- *}
Function Get_InitDLLPath(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0   : TmpStr:='Exchequer Path and Multi Currency flag will override in ExchDLL.INI file';
    12	: TmpStr:='Invalid Exchequer Path';
    13	: TmpStr:='Not Multi Currency Version (apply only if MCsystem is set as True)';
  end; {case..}
  Get_InitDLLPath:=TmpStr;
end; {func..}

{* ---------- Ex_GetTLLine Error Description ---------- *}
Function Get_GetTLLine(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found for specified Folio Number & Line Number';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetTLLine:=TmpStr;
end; {func..}

{* ---------- Ex_GetDataPath Error Description ---------- *}
Function Get_GetDataPath(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	  : TmpStr:='Exchequer Path is returned';
    30001 : TmpStr:='Exchequer Path is Empty i.e Exchequer path is the same directory as DLL';
  end; {case..}
  Get_GetDataPath:=TmpStr;
end; {func..}

{* ---------- Ex_GetDataPath Error Description ---------- *}
Function Get_InitPrintForm(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
       0  : TmpStr:='Print Form initialization is successful';
    1000  : TmpStr:='SBSForm.DLL file not found';
    1001  : TmpStr:='Unable to load DLL';
    1002  : TmpStr:='Unable to load Procedure Handle';
    1003  : TmpStr:='Exception Error while loading DLL';
    1004  : TmpStr:='DLL is not loaded';
    1005  : TmpStr:='Initialization failed';
    1006  : TmpStr:='Invalid Data Path';
  end; {case..}
  Get_InitPrintForm:=TmpStr;
end; {func..}

{* ---------- Ex_AddTransForm Error Description ---------- *}
Function Get_AddTransForm(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
       0  : TmpStr:='Reference No and Form Name have been added into batch to be printed';
    1001  : TmpStr:='Unable to find Specified Reference Number in Transaction file';
    1002  : TmpStr:='Specified form name does not exist';
    1003  : TmpStr:='DLL has not been loaded';
    1004  : TmpStr:='Unable to add specified reference number and form name into batch printing';
  end; {case..}
  Get_AddTransForm:=TmpStr;
end; {func..}

{* ---------- Ex_PrintForm Error Description ---------- *}
Function Get_PrintForm(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
       0  : TmpStr:='Showed preview or printed successfully';
    1001  : TmpStr:='DLL has not been loaded';
  end; {case..}
  Get_PrintForm:=TmpStr;
end; {func..}

{* ---------- Ex_GetCurrency Error Description ---------- *}
Function Get_GetCurrency(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
       0  : TmpStr:='Currency information retrieved successfully';
       3  : TmpStr:='Database not open';
    30001 : TmpStr:='Invalid currency number';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetCurrency:=TmpStr;
end; {func..}

{* ---------- Ex_StoreCurrency Error Description ---------- *}
Function Get_StoreCurrency(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
       0  : TmpStr:='Currency information retrieved successfully';
       3  : TmpStr:='Database not open';
      84  : TmpStr:='Record currently locked by another workstation';
    30001 : TmpStr:='Invalid currency number';
    30002 : TmpStr:='Daily Rate must be more than zero';
    30003 : TmpStr:='Unable to load currency record for update';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreCurrency:=TmpStr;
end; {func..}


{* ---------- Ex_StoreAutoBank Error Description ---------- *}
Function Get_StoreAutoBank(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
       0  : TmpStr:='Automatic Bank Reconciliation has been stored successfully';
    30001 : TmpStr:='Invalid Default Nominal Code';
    30002 : TmpStr:='Invalid Default Currency Code';
    30003 : TmpStr:='Invalid Bank Account Code';
    30004 : TmpStr:='Invalid Bank Sort Code';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreAutoBank:=TmpStr;
end; {func..}

{* ---------- Ex_UpdateUplift Error Description ---------- *}
Function Get_UpdateUplift(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0     : TmpStr:='Record found, no errors';
    4     : TmpStr:='Transaction Not Found';
    84,85 : TmpStr:='Transaction record currently locked by another station';
    104   : TmpStr:='Transaction Line Not Found';
    184,
    185   : TmpStr:='Transaction Line currently locked by another station';
    204   : TmpStr:='Stock Item Not found';
    384,
    385   : TmpStr:='FIFO/LIFO record currently locked by another station';
    1000  : TmpStr:='Invalid Transaction Type';
    1001  : TmpStr:='Invalid Stock Valuation Type (Serial Numbers)';
    1002  : TmpStr:='Transaction already posted or allocated';
    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_UpdateUpLift:=TmpStr;
end; {func..}

{* ---------- Ex_StoreEachBOMLine Error Description ---------- *}
Function Get_StoreEachBOMLine(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='Invalid Parent Stock Code';
    30002 : TmpStr:='Invalid Parent Stock Type, must be M for Bill of Material';
    30003 : TmpStr:='Invalid Material Stock Code';
    30004 : TmpStr:='Invalid Material Stock Type, must not be Group Code';
    30005 : TmpStr:='Parent and Material Stock Code must not be the same';
    30100..30199
          : TmpStr:='Adding Component Record Btrieve Error = '+IntToStr(TErCode-31000);
    30200..30299
          : TmpStr:='Updating Parent Stock Record Btrieve Error = '+IntToStr(TErCode-32000);

    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_StoreEachBOMLine:=TmpStr;
end; {func..}

{* ---------- Ex_GetSerialBatch Error Description ---------- *}
Function Get_GetSerialBatch(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='Serial/Batch Record Not Found !';
    30002 : TmpStr:='Serial or Batch or Stock Code field should be assigned in the record';
    30003 : TmpStr:='Invalid stock code';

    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_GetSerialBatch:=TmpStr;
end; {func..}

{* ---------- Ex_StoreSerialBatch Error Description ---------- *}
Function Get_StoreSerialBatch(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='Invalid Stock Code';
    30002 : TmpStr:='Invalid Stock Type, must be P/M/X (Product/BOM/Discontinued)';
    30003 : TmpStr:='Duplicate Serial No';
    30004 : TmpStr:='Buy Quantity should be > 0 for Batch ';
    30005 : TmpStr:='InDoc should not be POR and must be Purchase Transactions';
    30006 : TmpStr:='Invalid InDoc number';
    30007 : TmpStr:='BuyABSLine should be > 0 and must be 1 for WOR';
    30008 : TmpStr:='Invalid Transaction Line';
    30009 : TmpStr:='Invalid IN Location Code';
    30010 : TmpStr:='Invalid IN Date';
    30011 : TmpStr:='Invalid Cost Currency';
    30012 : TmpStr:='Company Rate should not be Zero';
    30013 : TmpStr:='Daily Rate sould not be Zero';
    30014 : TmpStr:='IN Order Document must be POR ';
    30015 : TmpStr:='Invalid IN Order Document';
    30016 : TmpStr:='IN Order Document Line must be > 0';
    30017 : TmpStr:='Invalid IN Order Transaction Line';

    30020 : TmpStr:='Unable to update Serial Qty in Transaction Line';
    30021 : TmpStr:='Unable to update cost on Stock Record';
    //PL 16/11/2016 : 2017 R1 :	ABSEXCH-17797 edit batch no
    30022 : TmpStr:='BatchNo cannot be changed as items have been sold from the batch';

    30100..30199
          : TmpStr:='Adding Btrieve error = '+IntToStr(TErCode-30100);

    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';

    NoStockErr : TmpStr := NoStockStr;
  end; {case..}
  Get_StoreSerialBatch:=TmpStr;
end; {func..}

{* ---------- Ex_UseSerialBatch Error Description ---------- *}
Function Get_UseSerialBatch(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='Invalid Stock Code';
    30002 : TmpStr:='Invalid Stock Type, must be P/M/X (Product/BOM/Discontinued)';
    30003 : TmpStr:='Record not found';
    30004 : TmpStr:='Specified Serial/Batch has been sold';
    30005 : TmpStr:='OUT Document should not be SOR and must be Sales Transactions';
    30006 : TmpStr:='Invalid OUT Document number';
    30007 : TmpStr:='SoldABSLine should be > 0';
    30008 : TmpStr:='Invalid OUT Document Transaction Line';
    30009 : TmpStr:='Invalid OUT Location Code';
    30010 : TmpStr:='Invalid OUT Date';
    30011 : TmpStr:='Invalid Selling Currency';
    30012 : TmpStr:='Company Rate should not be Zero';
    30013 : TmpStr:='Daily Rate sould not be Zero';
    30014 : TmpStr:='OUT Order Document must be SOR ';
    30015 : TmpStr:='Invalid OUT Order Document';
    30016 : TmpStr:='OUT Order Document Line must be > 0';
    30017 : TmpStr:='Invalid OUT Order Transaction Line';
    30018 : TmpStr:='Invalid Date';
    30019 : TmpStr:='Invalid Used Qty should not be zero';
    30020 : TmpStr:='Unable to update Used Qty in Transaction Line';
    30021 : TmpStr:='Unable to update cost on Transaction Header';

    30100..30199
          : TmpStr:='Updating Btrieve error = '+IntToStr(TErCode-30100);
    30200..30299
          : TmpStr:='Adding Used Batch Line Btrieve error = '+IntToStr(TErCode-30200);

    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_UseSerialBatch:=TmpStr;
end; {func..}

{* ---------- Ex_UnuseSerialBatch Error Description ---------- *}
Function Get_UnUseSerialBatch(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='Invalid Stock Code';
    30002 : TmpStr:='Invalid Stock Type, must be P/M/X (Product/BOM/Discontinued)';
    30003 : TmpStr:='Serial or Batch Record not found';
    30004 : TmpStr:='Specified Serial/Batch has not been sold';
    30005 : TmpStr:='Quantity to unuse should not be more than quantity used';
    30006 : TmpStr:='Quantity to unuse should not be zero';

    30100..30199
          : TmpStr:='Updating Btrieve error = '+IntToStr(TErCode-30100);
    30200..30299
          : TmpStr:='Deleting Used Batch Line Btrieve error = '+IntToStr(TErCode-30200);

    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';
  end; {case..}
  Get_UnuseSerialBatch:=TmpStr;
end; {func..}

{* ---------- Ex_CheckPassword Error Description ---------- *}
Function Get_CheckPassword(TErCode  :  SmallInt)  :  ShortString;
begin
  //PR: 31/08/2017 ABSEXCH-18857 Change error strings
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='Invalid User Name or Password';
    30002 : TmpStr:='Invalid Password'; //no longer used
    30003 : TmpStr:='User Suspended';
  else
    TmpStr:=IntToStr(TErCode);
  end; {case..}
  Get_CheckPassword:=TmpStr;
end; {func..}

{* ---------- Ex_GetRecordAddress Error Description ---------- *}
Function Get_RecordAddress(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='Invalid File Number.';
    30002 : TmpStr:='Unable to get the record address.';
  else
    TmpStr:=IntToStr(TErCode);
  end; {case..}
  Get_RecordAddress:=TmpStr;
end; {func..}


{* ---------- Ex_GetRecWithAddress Error Description ---------- *}
Function Get_RecWithAddress(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='Invalid File Number.';
    30002 : TmpStr:='Unable to get the record with specified address.';
  else
    TmpStr:=IntToStr(TErCode);
  end; {case..}
  Get_RecWithAddress:=TmpStr;
end; {func..}


{ EX_INITSTRUCTURE  Index 206 }
Function Get_InitStructure(TErCode  :  SmallInt)  :  ShortString;
begin { Get_InitStructure }
  Result := '';
  Case TErCode of
    1 : Result:='Miscellaneous Exception';
  else
    Result := IntToStr(TErCode);
  end; {case..}
end; { Get_InitStructure }


{ EX_CREATETLARRAY    Index 207 }
Function Get_CreateTLArray(TErCode  :  SmallInt)  :  ShortString;
begin { Get_CreateTLArray }
  Result := '';
  Case TErCode of
    1000  : Result:='Too many lines requested';
    1001  : Result:='Miscellaneous Exception';
    1002  : Result:='Out of Memory';
  else
    Result := IntToStr(TErCode);
  end; {case..}
end; { Get_CreateTLArray }


{ EX_ADDTLARRAYLINE   Index 208 }
Function Get_AddTLArrayLine(TErCode  :  SmallInt)  :  ShortString;
begin { Get_AddTLArrayLine }
  Result := '';
  Case TErCode of
    1000  : Result:='Array is full';
    1001  : Result:='Array not setup';
    1002  : Result:='Miscellaneous Exception';
  else
    Result := IntToStr(TErCode);
  end; {case..}
end; { Get_AddTLArrayLine }

{ Index 130 }
Function Get_TranCanBeUpdated(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='No record with defined Document Reference Number.';
    30002 : TmpStr:='Transaction cannot be updated.';
  else
    TmpStr:=IntToStr(TErCode);
  end; {case..}
  Get_TranCanBeUpdated:=TmpStr;
end; {func..}

function Get_OverrideINI(TErCode  :  SmallInt)  :  ShortString;
begin
  Case TErCode of
    0     : Result := 'Key value update successfully';
    30001 : Result := 'Key value unknown';
    30002 : Result := 'Key value cannot be overridden';
    30003 : Result := 'Value specified for the key invalid';
  else
    TmpStr := IntToStr(TErCode);
  end; {case..}
end;

Function Get_ReadIniValue(TErCode  :  SmallInt)  :  ShortString;
begin
  Case TErCode of
    0     : Result := 'Key value read OK';
    30001 : Result := 'Key value unknown';
    30002 : Result := 'Key value cannot be read';
  else
    TmpStr := IntToStr(TErCode);
  end; {case..}
end;

Function Get_UnlockRecord(TErCode  :  SmallInt)  :  ShortString;
begin
  Case TErCode of
    0     : Result := 'Record unlocked OK';
    81    : Result := 'Btrieve lock error';
  else
    TmpStr := IntToStr(TErCode);
  end; {case..}
end;

Function Get_StoreTransHedOrDetl(TErCode  :  SmallInt)  :  ShortString;
begin
  Case TErCode of
    0     : Result := 'Record updated OK';
    4     : Result := 'Could not find record to update';
    84,85 : Result := 'Record currently locked by another station';
    30235 : Result := 'Invalid hold flag. Must be 0-6 (+ 32 for notes, + 128 for suspend posting.)';
    32766 : Result := 'Record size incorrect';
    32767 : Result := 'Record not initialised correctly';
  else
    TmpStr := IntToStr(TErCode);
  end; {case..}
end;

{ Index 134 }
Function Get_CheckSecurity(TErCode  :  SmallInt)  :  ShortString;
begin
  Case TErCode of
    0     : Result := 'Security check OK';
    1000  : Result := 'User''s security settings not found';
    1001  : Result := 'Area code out of range';
  else
    TmpStr := IntToStr(TErCode);
  end; {case..}
end;

{ Index 135 }
Function Get_GetEcommsData(TErCode  :  SmallInt)  :  ShortString;
begin
  Case TErCode of
    32766 : Result := 'Record size incorrect';
    32767 : Result := 'Record not initialised correctly';

  else
    TmpStr := IntToStr(TErCode);
  end; {case..}
end;

{ Index 138 }

Function Get_DateToEntPeriod(TErCode  :  SmallInt)  :  ShortString;
begin
  Case TErCode of
    30000  :  Result:='TransDate - PChar has not been allocated';
    30001  :  Result:='Invalid value in Year';
    30002  :  Result:='Invalid value in Month, should be (1-12)';
    30003  :  Result:='Invalid Day for the month';
  else
    TmpStr := IntToStr(TErCode);
  end; {case..}
end;


Function Get_GetJobType(TErCode  :  SmallInt)  :  ShortString;
begin
  case TErCode of
    0  :    Result := 'Record found OK';
    4  :    Result := 'No record found for SearchKey';
    9  :    Result := 'End Of file reached';
    84,85 : Result := 'Record currently locked by another station';
    32766 : Result := 'Record size incorrect';
    32767 : Result := 'Record not initialised correctly';
  else
    Result := IntToStr(TErCode);
  end; {case..}
end; {func..}


{ EX_GETTLARRAY       Index 210 }
Function Get_GetTLArray(TErCode  :  SmallInt)  :  ShortString;
begin { Get_GetTLArray }
  Result := '';
  Case TErCode of
    1000  : Result:='Miscellaneous Exception';
    1001  : Result:='Array not setup';
  else
    Result := Get_GetTrans(TErCode);
  end; {case..}
end; { Get_GetTLArray }

{ EX_GETTLARRAYLINE   Index 210 }
Function Get_GetTLArrayLine(TErCode  :  SmallInt)  :  ShortString;
begin { Get_GetTLArrayLine }
  Result := '';
  Case TErCode of
    1000  : Result:='Error: Unknown Exception';
    1001  : Result:='Error: Array not setup';
    1002  : Result:='Invalid Line Number';
    1003  : Result:='Invalid PTL/PTLSize parameter';
  else
    Result := IntToStr(TErCode);
  end; {case..}
end; { Get_GetTLArrayLine }

{ Ex_CalculateTransTotal   Index 142 }
Function Get_CAlculateTransTotal(TErCode  :  SmallInt)  :  ShortString;
begin
  Result := '';
  Case TErCode of

    30001 : Result:='The specified transaction reference could not be found';
  else
    Result := IntToStr(TErCode);
  end; {case..}
end; { Get_CalculateTransTotal }


{ Index 144 }
Function Get_CalcLineTax(TErCode  :  SmallInt)  :  ShortString;
begin

  Result := '';
  Case TErCode of
    32767  : Result:='Record not initialised correctly.';
    32766  : Result:='Incorrect record size';
  else
    Result := IntToStr(TErCode);
  end; {case..}

end; {Get_CalcLineTax..}

{ Index 145 }
Function Get_CorrectVATcode(TErCode  :  SmallInt)  :  ShortString;
begin

  Result := '';
  Case TErCode of
    32767  : Result:='Record not initialised correctly.';
    32766  : Result:='Incorrect record size';
  else
    Result := IntToStr(TErCode);
  end; {case..}

end; {Get_CorrectVATCode..}


Function Get_GETENTDATA (TErCode  :  SmallInt)  :  ShortString;
begin
  Result := '';
  Case TErCode of
    32765  : Result:='Exchequer Data not available';
    32767  : Result:='Record not initialised correctly.';
    32766  : Result:='Incorrect record size';
  else
    Result := IntToStr(TErCode);
  end; {case..}
end;

{ Index 149 }
Function Get_UpdateDueDate(TErCode  :  SmallInt)  :  ShortString;
begin
  Result := '';
  Case TErCode of
    84     :  Result:='Unable to lock the record to be updated';
    30001  :  Result:='That transaction type is not allowed to update';
    30002  :  Result:='New due date is not a valid date to be updated';
  else
    Result := IntToStr(TErCode);
  end; {case..}

end; {Get_CorrectVATCode..}

// 154 - EX_DELETEQUOTE
Function Get_DeleteQuote(TErCode  :  SmallInt)  :  ShortString;
begin
  Result := '';
  Case TErCode of
    0      : Result := 'Quote Deleted OK';

    100..9999 : Result := 'Btrieve Error ' + IntToStr(TErCode-100) + ' deleting the Quote';

    32765  : Result:='Error locking Quote for deletion';
    32766  : Result:='The specified Quote Reference is not a Sales or Purchase Quote';
    32767  : Result:='Invalid Quote Reference';
  else
    Result := IntToStr(TErCode);
  end; {case..}

end; {Get_CorrectVATCode..}

// 500 - EX_GETUSERPROFILE
Function GetUserProfile(TErCode  :  SmallInt)  :  ShortString;
begin
  Result := '';
  Case TErCode of
    0      : Result := 'Record found OK';
    4      : Result := 'No record found for SearchKey';
    9      : Result := 'End Of file reached';

    32765  : Result:='Invalid Btrieve Operation';
    32767  : Result:='Record not initialised correctly';
    32766  : Result:='Incorrect record size';
  else
    Result := IntToStr(TErCode);
  end; {case..}
end;

Function Get_DeleteDiscMatrix(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0            : Result := 'Record found OK';

    20001        : Result := 'The record specified is not a discount record';
    20002        : Result := 'The record identified for deletion has different details to the discount record passsed in';
    20003        : Result := 'Error locking discount record';
    21000..21999 : Result := Format('Btrieve Error %d loading specified Discount Record at RecPos', [TErCode - 21000]);
    22000..22999 : Result := Format('Btrieve Error %d deleting specified Discount Record', [TErCode - 21000]);
    32767        : Result:='Record not initialised correctly';
    32766        : Result:='Incorrect record size';
  else
    Result := IntToStr(TErCode);
  end; {case..}
end;

Function Get_UpdatePayInRef(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0            : Result := 'Pay-In Reference updated OK';
    84           : Result := 'Unable to lock transaction';
    30001        : Result := 'Transaction must be SRC or SRI';
    30002        : Result := 'Transaction has been posted';
    30004        : Result := 'Transaction Line not found';
    30005        : Result := 'Specified line is not a payment line';
    else
      Result := IntToStr(TErCode);
  end;
end;

Function Get_UpdateLineDate(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0            : Result := 'LineDate updated OK';
    84           : Result := 'Unable to lock transaction';
    30000        : Result := 'Invalid date';
    30002        : Result := 'Transaction has been posted';
    30004        : Result := 'Transaction Line not found';
    else
      Result := IntToStr(TErCode);
  end;
end;

Function Get_UpdateReconcileFlag(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0            : Result := 'Record updated OK';
    4            : Result := 'Transaction not found';
    84           : Result := 'Unable to lock transaction';
    30000        : Result := 'New Value must be between 0 and 3';
    32004        : Result := 'Transaction Line not found';
    32500        : Result := 'Unable to load EntDllSp.dll';
    else
      Result := IntToStr(TErCode);
  end;
end;


Function Get_ResetLineSerialCount(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0            : Result := 'LineDate updated OK';
    84           : Result := 'Unable to lock transaction';
//    30001        : Result := 'Transaction must be SRC or SRI';
    30002        : Result := 'Transaction has been posted';
    30004        : Result := 'Transaction Line not found';
    else
      Result := IntToStr(TErCode);
  end;
end;



Function Get_GetLink(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0     : Result := 'Record found OK';
    4     : Result := 'No record found for SearchKey';
    9     : Result := 'End Of file reached';

    84,85 : Result:='Record currently locked by another station';
    32766 : Result:='Record size incorrect';
    32767 : Result:='Record not initialised correctly';
    else
      Result := IntToStr(TErCode);
  end;
end;

Function Get_StoreLink(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0	   : Result:='Record successfully stored';
    2	   : Result:='Database corrupt, unable to store record';
    4	   : Result:='Update not possible as original version of record not found';

    30000  : Result:='Filename not specified';
    30001  : Result:='lkLetterLink must be L or K';
    30002  : Result:='Letters cannot be added or deleted';
    30003  : Result:='lkAttachTo must be C, E, J, K, S, T';
    30004  : Result:='Object to link to cannot be found';
    30005  : Result:='Invalid Date';
    30006  : Result:='Invalid Time';
    30007  : Result:='Invalid link type';
    30008  : Result:='Letter filename does not match';
    else
      Result := IntToStr(TErCode);
  end; //Case
end;

Function Get_DeleteLink(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0	   : Result:='Record successfully deleted';
    30000  : Result:='Record position has changed - cannot delete';
    else
      Result := IntToStr(TErCode);
  end;//case
end;


function Get_SaveJobBudget(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0     : Result := 'Record successfully stored';
    4     : Result := 'No record found for SearchKey';
    84,85 : Result := 'Record currently locked by another station';
    30001 : Result := 'Invalid Analysis Code';
    30002 : Result := 'Invalid Stock Code';
    30003 : Result := 'Invalid Time Rate';
    30004 : Result := 'Invalid Period';
    30005 : Result := 'Invalid Year';
  end; //case
end;

function Get_SaveJobRetention(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0     : Result := 'Record successfully stored';
    4     : Result := 'No record found for SearchKey';
    84,85 : Result := 'Record currently locked by another station';
    30000 : Result := 'Invalid Job Code';
    30001 : Result := 'Invalid Analysis Code';
    30002 : Result := 'Invalid Account Code';
    30003 : Result := 'Invalid VAT Code';
    30004 : Result := 'Invalid Transaction';
    30005 : Result := 'Invalid Transaction Type';
    30006 : Result := 'Invalid Entry Date';
    30007 : Result := 'Invalid Expiry Date';
    30008 : Result := 'Entry Date must not be after Expiry Date';
    30009 : Result := 'Invalid Period';
    30010 : Result := 'Invalid Year';
    30011 : Result := 'Invalid Currency';
    30012 : Result := 'Invalid Department';
    30013 : Result := 'Invalid Cost Centre';
    30014 : Result := 'Retention value and percentage don''t agree';
    30015 : Result := 'Retention Account Code must be the same as Transaction Account Code';
  end; //case
end;

function Get_JobInvoiceExecute(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    30000 : Result := 'Invalid Revenue Analysis Code';
    30001 : Result := 'Invalid WIP Analysis Code';
    30002 : Result := 'Invalid Department';
    30003 : Result := 'Invalid Cost Centre';
    30004 : Result := 'Error in transfer of WIP';
    30005 : Result := 'Error in invoice procedure';
  end; //case
end;

Function Get_GetMultiBin(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    0	   : TmpStr:='Record found, no errors';
    4	   : TmpStr:='No record found';
    9	   : TmpStr:='End Of File reached';
    84,85  : TmpStr:='Record currently locked by another station';
    32766  : TmpStr:='Record size incorrect';
    32767  : TmpStr:='Record not initialised correctly';
  end; {case..}
  Result := TmpStr;
end; {func..}


Function Get_StoreMultiBin(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    4     : TmpStr := 'Unable to find record to update';
    5     : TmpStr := 'Bin Code already exists for this Stock Item';
    30000 : TmpStr := 'Invalid Bin Code';
    30001 : TmpStr := 'Invalid Stock Folio';
    30002 : TmpStr := 'Invalid InDoc Ref';
    30003 : TmpStr := 'Invalid DocType for InDoc';
    30004 : TmpStr := 'Invalid InDoc Line';
    30005 : TmpStr := 'Invalid CostPrice Currency';
    30006 : TmpStr := 'Invalid In Location';
    30007 : TmpStr := 'Invalid OutDoc Ref';
    30008 : TmpStr := 'Invalid DocType for OutDoc';
    30009 : TmpStr := 'Invalid OutDoc Line';
    30010 : TmpStr := 'Invalid SalesPrice Currency';
    30011 : TmpStr := 'Invalid Out Location';
    30012 : TmpStr := 'Invalid InDate - should be blank or a valid date';
    30013 : TmpStr := 'Invalid OutDate - should be blank or a valid date';
    30014 : TmpStr := 'Invalid UseByDate - should be blank or a valid date';
    30015 : TmpStr := 'Invalid In Order Document';
    30016 : TmpStr := 'Invalid In Order Line';
    30017 : TmpStr := 'Invalid Out Order Document';
    30018 : TmpStr := 'Invalid Out Order Line';
    30019 : TmpStr := 'In Doc Line: Stock item is different to bin stock item';
    30020 : TmpStr := 'Out Doc Line: Stock item is different to bin stock item';
    30021 : TmpStr := 'In Order Line: Stock item is different to bin stock item';
    30022 : TmpStr := 'Out Order Line: Stock item is different to bin stock item';
    30023 : TmpStr := 'Usage records cannot be added or updated. Use Ex_UseMultiBin';
    30024 : TmpStr := 'Invalid brAutoPickMode. Must be 0 - 2';
    30025 : TmpStr := 'Unable to update Bin Quantity on Transaction Line';
    30026 : TmpStr := 'Usage records cannot be added. Use Ex_UseMultiBin';
    30027 : TmpStr := 'Company Rate should not be Zero';
    30028 : TmpStr := 'Daily Rate should not be Zero';


    30100..30199
          : TmpStr := 'Adding Btrieve error = '+IntToStr(TErCode-30100);

    32766 : TmpStr := 'Record size incorrect';
    32767 : TmpStr := 'Record not initialised correctly';
  end; {case..}
  Result := TmpStr;
end; {func..}

Function Get_UseMultiBin(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    4     : TmpStr := 'Unable to find record';
    30000 : TmpStr := 'Invalid Bin Code';
    30001 : TmpStr := 'Invalid Stock Folio';
    30002 : TmpStr := 'Invalid InDoc Ref';
    30003 : TmpStr := 'Invalid DocType for InDoc';
    30004 : TmpStr := 'Invalid InDoc Line';
    30005 : TmpStr := 'Invalid CostPrice Currency';
    30006 : TmpStr := 'Invalid In Location';
    30007 : TmpStr := 'Invalid OutDoc Ref';
    30008 : TmpStr := 'Invalid DocType for OutDoc';
    30009 : TmpStr := 'Invalid OutDoc Line';
    30010 : TmpStr := 'Invalid SalesPrice Currency';
    30011 : TmpStr := 'Invalid Out Location';
    30012 : TmpStr := 'Invalid InDate - should be blank or a valid date';
    30013 : TmpStr := 'Invalid OutDate - should be blank or a valid date';
    30014 : TmpStr := 'Invalid UseByDate - should be blank or a valid date';
    30015 : TmpStr := 'Invalid In Order Document';
    30016 : TmpStr := 'Invalid In Order Line';
    30017 : TmpStr := 'Invalid Out Order Document';
    30018 : TmpStr := 'Invalid Out Order Line';
    30019 : TmpStr := 'In Doc Line: Stock item is different to bin stock item';
    30020 : TmpStr := 'Out Doc Line: Stock item is different to bin stock item';
    30021 : TmpStr := 'In Order Line: Stock item is different to bin stock item';
    30022 : TmpStr := 'Out Order Line: Stock item is different to bin stock item';
    30024 : TmpStr := 'Insufficient stock in this bin';
    30025 : TmpStr := 'Unable to update Bin Quantity on Transaction Line';

    30027 : TmpStr := 'Company Rate should not be Zero';
    30028 : TmpStr := 'Daily Rate should not be Zero';

    30100..30199
          : TmpStr := 'Adding Btrieve error = '+IntToStr(TErCode-30100);

    32766 : TmpStr := 'Record size incorrect';
    32767 : TmpStr := 'Record not initialised correctly';
  end; {case..}
  Result := TmpStr;
end; {func..}

Function Get_UnUseMultiBin(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    4     : TmpStr := 'Unable to find record';
    30000 : TmpStr := 'Invalid Bin Code';
    30001 : TmpStr := 'Invalid Stock Folio';
    30002 : TmpStr := 'Invalid InDoc Ref';
    30003 : TmpStr := 'Invalid DocType for InDoc';
    30004 : TmpStr := 'Invalid InDoc Line';
    30005 : TmpStr := 'Invalid CostPrice Currency';
    30006 : TmpStr := 'Invalid In Location';
    30007 : TmpStr := 'Invalid OutDoc Ref';
    30008 : TmpStr := 'Invalid DocType for OutDoc';
    30009 : TmpStr := 'Invalid OutDoc Line';
    30010 : TmpStr := 'Invalid SalesPrice Currency';
    30011 : TmpStr := 'Invalid Out Location';
    30012 : TmpStr := 'Invalid InDate - should be blank or a valid date';
    30013 : TmpStr := 'Invalid OutDate - should be blank or a valid date';
    30014 : TmpStr := 'Invalid UseByDate - should be blank or a valid date';
    30015 : TmpStr := 'Invalid In Order Document';
    30016 : TmpStr := 'Invalid In Order Line';
    30017 : TmpStr := 'Invalid Out Order Document';
    30018 : TmpStr := 'Invalid Out Order Line';
    30019 : TmpStr := 'In Doc Line: Stock item is different to bin stock item';
    30020 : TmpStr := 'Out Doc Line: Stock item is different to bin stock item';
    30021 : TmpStr := 'In Order Line: Stock item is different to bin stock item';
    30022 : TmpStr := 'Out Order Line: Stock item is different to bin stock item';
    30025 : TmpStr := 'Unable to update Bin Quantity on Transaction Line';
    30026 : TmpStr := 'Record position not set - can''t identify record to unuse';

    30027 : TmpStr := 'Company Rate should not be Zero';
    30028 : TmpStr := 'Daily Rate should not be Zero';

    30100..30199
          : TmpStr := 'Updating record Btrieve error = '+IntToStr(TErCode-30100);
    30200..30299
          : TmpStr := 'Deleting record Btrieve error = '+IntToStr(TErCode-30200);

    30300..30399
          : TmpStr := 'Updating header record. Btrieve error = '+IntToStr(TErCode-30300);

    32766 : TmpStr := 'Record size incorrect';
    32767 : TmpStr := 'Record not initialised correctly';
  end; {case..}
  Result := TmpStr;
end; {func..}

function Get_SetJAInvoicedFlag(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0     : Result := 'Record successfully stored';
    84,85 : Result := 'Record currently locked by another station';
    30001 : Result := 'Unable to find original transaction';
    30002 : Result := 'Unable to find Job Actual for this transaction and line number';
  end; //case
end;

function Get_UpdateCISDate(TErrCode : Longint) : ShortString;
begin
  Result := '';
  Case TErrCode of
    0      :  Result := 'Record updated successfully';
    84, 85 :  Result :='Unable to lock the record to be updated';
    30001  :  Result :='That transaction type is not allowed to update';
    30002  :  Result :='New date is not a valid date';
    30003  :  Result := 'CIS Tax is zero';
    30004  :  Result := 'CIS Declared Value is non-zero';
    30005  :  Result := 'Employee Certificate Type is not CIS 6';
    30006  :  Result := 'Existing CIS Date is blank';
  end;
end;

Function Get_UpdateSerialBatch(TErCode  :  SmallInt)  :  ShortString;
begin
  TmpStr:='';
  Case TErCode of
    30001 : TmpStr:='Serial/Batch Record Not Found !';
    30002 : TmpStr:='Serial or Batch field should be assigned in the record';
    30003 : TmpStr:='Invalid stock code';
    30004 : TmpStr:='Invalid Cost Currency';
    30005 : TmpStr:='Company Rate should not be Zero';
    30006 : TmpStr:='Daily Rate sould not be Zero';

    32766 : TmpStr:='Record size incorrect';
    32767 : TmpStr:='Record not initialised correctly';

  end; {case..}
  Get_UpdateSerialBatch:=TmpStr;
end; {func..}

function Get_ReturnAction(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0     : Result := 'Record successfully stored';
    4     : Result := 'No record found for SearchKey';
    84,85 : Result := 'Record currently locked by another station';
    SP_FINALIZE_CALLED
          : Result := 'Finalize has been called on this object. It can no longer be used.';
    30001 : Result := 'No repaired quantities on lines';
    30002 : Result := 'No written-off quantities on lines';
    30003 : Result := '';
    30004 : Result := '';
    30005 : Result := '';
    31001  : Result := 'BackToBack - Unknown error';
    31002  : Result := 'BackToBack - Invalid default supplier';
    31004  : Result := 'BackToBack - Transaction record not found';
  end; //case
end;

function Get_ReturnCreate(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0     : Result := 'Record successfully stored';
    4     : Result := 'No record found for SearchKey';
    84,85 : Result := 'Record currently locked by another station';
    SP_FINALIZE_CALLED
          : Result := 'Finalize has been called on this object. It can no longer be used.';
    30001 : Result := 'Return Line not found';
    30002 : Result := 'Existing Return not found';
    30003 : Result := '';
    30004 : Result := '';
    30005 : Result := '';
  end; //case
end;

Function Get_GetMultiBuy(TErCode  :  SmallInt)  :  ShortString;
begin
  Case TErCode of
    0	  : Result:='Record found, no errors';
    4	  : Result:='No record found for SearchKey';
    9	  : Result:='End Of File reached';
    84,85 : Result:='Record currently locked by another station';
    32766 : Result:='Record size incorrect';
    32767 : Result:='Record not initialised correctly';
  end; {case..}
end; {func..}


function Get_StoreMultiBuy(TErCode  :  LongInt) : ShortString;
begin
  Result := '';
  Case TErCode of
    0     : Result :=   'Record successfully stored';
    4     : Result :=   'No record found for SearchKey';
    84,85 : Result :=   'Record currently locked by another station';
    30001  : Result :=  'Invalid Discount Type';
    30002  : Result :=  'Invalid Currency';
    30003  : Result :=  'Invalid Start Date';
    30004  : Result :=  'Invalid End Date';
    30005  : Result :=  'Buy Qty must be positive';
    30006  : Result :=  'Reward Value must be positive';
    30007  : Result :=  'Invalid Account Code';
    30008  : Result :=  'Invalid Stock Code';
    30009  : Result :=  'Invalid Owner Type';
    30010  : Result :=  'Date range clash';
    30011  : Result :=  'BuyQty clashes with another discount';
  end; //case
end;

Function Get_DeleteMultiBuy(TErCode  :  SmallInt)  :  ShortString;
begin
  Case TErCode of
    0	   : Result:='Record deleted, no errors';
    4	   : Result:='No record found for SearchKey';
    9	   : Result:='End Of File reached';
    84,85  : Result:='Record currently locked by another station';
    32766  : Result:='Record size incorrect';
    32767  : Result:='Record not initialised correctly';
  end; {case..}
end; {func..}

//PR: 30/01/2014 ABSEXCH-14974
function Get_StoreAccountContact(TErCode : SmallInt) : ShortString;
begin
  Case TErCode of
    0      : Result :=  'Record successfully stored';
    80     : Result :=  'Record in the database has been changed since it was read. Re-read before updating.';
    30001  : Result :=  'Contact Name cannot be blank';
    30002  : Result :=  'Contact Name must be unique for this account';
    30003  : Result :=  'Invalid Email Address';
    30004  : Result :=  'Unknown Error';
    30005  : Result :=  'Invalid Account Type';
    30006  : Result :=  'Invalid Role For Account Type';
    30007  : Result :=  'Invalid Account Code';
    30008  : Result :=  'Invalid Contact Name';
    30009  : Result :=  'Invalid Role';
    30010  : Result :=  'Invalid Country Code';
  end;
end;

//PR: 31/10/2014 Order payments
function Get_TakeCreditCardPayment(TErCode : SmallInt) : ShortString;
begin
  Case TErCode of
    0      : Result :=  'Payment taken successfully';
    30001  : Result :=  'Order Payments not enabled for this Account';
    30002  : Result :=  'Invalid GL Code';
    30003  : Result :=  'Invalid Cost Centre';
    30004  : Result :=  'Invalid Department';
    30005  : Result :=  'Invalid Contact';
    30006  : Result :=  'Credit Card system not installed';
    30007  : Result :=  'Invalid Credit Card Action - must be ccaPayment or ccaAuthorisationOnly';
    30008  : Result :=  'Window Handle not assigned';
    30009  : Result :=  'Order is already fully paid';
    30010  : Result :=  'Payment must not be more than payments allowed for order';
    30011  : Result :=  'Payment must be more than 0.';

    30202  : Result :=  'Payment not authorised';
    30203  : Result :=  'Payment cancelled or timed out';
    30204  : Result :=  'Payment rejected';
    30205  : Result :=  'Unknown error from payment provider';
  end;
end;

function Get_GiveCreditCardRefund(TErCode : SmallInt) : ShortString;
begin
  Case TErCode of
    0      : Result :=  'Payment taken successfully';
    30001  : Result :=  'Order Payments not enabled for this Account';
    30006  : Result :=  'Credit Card system not installed';
    30007  : Result :=  'Invalid Credit Card Action - must be ccaRefund';
    30008  : Result :=  'Window Handle not assigned';
    30009  : Result :=  'Transaction is already fully refunded';

    30202  : Result :=  'Payment not authorised';
    30203  : Result :=  'Payment cancelled or timed out';
    30204  : Result :=  'Payment rejected';
    30205  : Result :=  'Unknown error from payment provider';
  end;
end;


{* ========== Main Function for all error description ========== *}

FUNCTION EX_ERRORDESCRIPTION(INDEXNO   :  SMALLINT;
                             ERRORCODE :  SMALLINT) : SHORTSTRING;
var
  GenStr  :  String[255];
begin
  GenStr:='';
  Case IndexNo of
    1  : GenStr:=Get_InitDLL(ErrorCode);         { Ex_InitDLL Index 1 }
    2  : GenStr:=Get_CloseDLL(ErrorCode);        { Ex_CloseDLL Index 2 }
    3  : GenStr:=Get_GetAccount(ErrorCode);      { Ex_GetAccount Index 3 }
    4  : GenStr:=Get_StoreAccount(ErrorCode);    { Ex_StoreAccount Index 4 }
    5  : GenStr:=Get_UnLockAccount(ErrorCode);   { Ex_UnLockAccount Index 5 }
    6  : GenStr:=Get_GetAccountBalance(ErrorCode);   { Ex_UnLockAccount Index 6 }
    7  : GenStr:=Get_StoreDiscMatrix(ErrorCode);   { EX_STOREDISCMATRIX }
    8  : GenStr:=Get_GetDiscMatrix(ErrorCode);   { EX_GETDISCMATRIX }

   20  : GenStr:=Get_GetTrans(ErrorCode);        { Ex_GetTrans Index 20 }
   21  : GenStr:=Get_StoreTrans(ErrorCode);      { Ex_StoreTrans Index 21 }
   22  : GenStr:=Get_GetNextTransNo(ErrorCode);  { Ex_GetNextTransNo Index 22 }
   23  : GenStr:=Get_GetTotalTransLines(ErrorCode);  { Ex_GetTotalTransLines Index 23 }
   24  : GenStr:=Get_GetTransHed(ErrorCode);     { Ex_GetTransHed Index 24 }
   25  : GenStr:=Get_GetTransLine(ErrorCode);    { Ex_GetTransLine Index 25 }
  {26  : Ex_ConvertFolio Index 26  - No error code to be returned }

   30  : GenStr:=Get_GetStock(ErrorCode);        { Ex_GetStock Index 30 }
   31  : GenStr:=Get_StoreStock(ErrorCode);      { Ex_StoreStock Index 31 }
   32  : GenStr:=Get_UnlockStock(ErrorCode);     { Ex_UnlockStock Index 32 }
  {33  : Ex_Version returning Version No - Index 33 }

   44  : GenStr:=Get_GetGLAccount(ErrorCode);    { Ex_GetGLAccount Index 44 }
   45  : GenStr:=Get_StoreGLAccount(ErrorCode);  { Ex_StoreGLAccount Index 45 }
   46  : GenStr:=Get_GetStockBOM(ErrorCode);     { Ex_GetStockBOM Index 46 }
   47  : GenStr:=Get_GetLineSerialNos(ErrorCode);{ Ex_GetLineSerialNos Index 47 }
   48  : GenStr:=Get_GetAccountFileSize(ErrorCode); { Ex_GetAccountFileSize Index 48 }
  {49  : Ex_HasOutStanding Index 49 - returning True or False }
   50  : GenStr:=Get_StoreStockBOM(ErrorCode);   { Ex_StoreStockBOM Index 50 }

   51  : GenStr:=Get_GetStkAlt(ErrorCode);   { Ex_StoreStockAlt Index 52 }
   52  : GenStr:=Get_StoreStkAlt(ErrorCode);   { Ex_StoreStockAlt Index 52 }
   60  : GenStr:=Get_GetJob(ErrorCode);          { Ex_GetJob Index 60 }
   61  : GenStr:=Get_StoreJob(ErrorCode);        { Ex_StoreJob Index 61 }
   62..64
       : GenStr:=Get_GetJob(ErrorCode);          { Ex_GetJobAnalysis Index 62 }
                                                 { Ex_GetJobEmployee Index 63 }
                                                 { Ex_GetJobTimeRate Index 64 }

   70  : GenStr:=Get_GetStockLoc(ErrorCode);     { Ex_GetStockLoc Index 70 }
   71  : GenStr:=Get_StoreStockLoc(ErrorCode);   { Ex_StoreStockLoc Index 71 }
   72  : GenStr:=Get_GetLocation(ErrorCode);     { Ex_GetLocation Index 72 }
   73  : GenStr:=Get_StoreLocation(ErrorCode);   { Ex_StoreLocation Index 73 }
  {74  : Ex_RoundUp returning Double Value }

   75  : GenStr:=Get_GetMatch(ErrorCode);        { Ex_GetMatch Index 75 }
   76  : GenStr:=Get_StoreMatch(ErrorCode);      { Ex_StoreMatch Index 76 }
   77  : GenStr:=Get_GetNotes(ErrorCode);        { Ex_GetNotes Index 77 }
   78  : GenStr:=Get_StoreNotes(ErrorCode);      { Ex_StoreNotes Index 78 }
   79  : GenStr:=Get_GetCCDep(ErrorCode);        { Ex_GetCCDep Index 79 }
   80  : GenStr:=Get_CalcStockPrice(ErrorCode);  { Ex_CalcStockPrice Index 80 }
   81  : GenStr:=Get_GetVATRate(ErrorCode);      { Ex_GetVATRate Index 81 }

  {82  : Ex_SilentLock Index 82 passing True / False  }
  {83  : Ex_SetReleaseCode Index 83 passing DLL Release Code   }

   84  : GenStr:=Get_InitDLLPath(ErrorCode);     { Ex_InitDLLPath Index 84 }
   85  : GenStr:=Get_GetTLLine(ErrorCode);       { Ex_GetTLLine Index 85 }
   86  : GenStr:=Get_GetDataPath(ErrorCode);     { Ex_GetDataPath Index 86 }

   90  : GenStr:=Get_GetCurrency(ErrorCode);     { Ex_GetCurrency Index 90 }
   92  : GenStr:=Get_StoreAutoBank(ErrorCode);   { Ex_GetCurrency Index 92 }
   93  : GenStr:=Get_UpdateUpLift(ErrorCode);    { Ex_UpdateUpLift Index 93 }

   94  : GenStr:=Get_StoreEachBOMLine(ErrorCode);{EX_StoreEachBOMLine Index 94 }
   95  : GenStr:=Get_GetSerialBatch(ErrorCode);  {EX_GetSerialBatch Index 95 }
   96  : GenStr:=Get_StoreSerialBatch(ErrorCode);{EX_StoreSerialBatch Index 96 }
   97  : GenStr:=Get_UseSerialBatch(ErrorCode);  {EX_UseSerialBatch Index 97 }


   120 : GenStr:=Get_CheckPassword(ErrorCode);   { Ex_CheckPassword Index 120 }
   122 : GenStr:=Get_RecordAddress(ErrorCode);   { Ex_GetRecordAddress Index 121 }
   123 : GenStr:=Get_RecWithAddress(ErrorCode);  { Ex_GetRecWithAddress Index 122 }
   125 : GenStr:=Get_StoreTransHedOrDetl(ErrorCode); { Ex_StoreTransHed Index 125 }
   126 : GenStr:=Get_GetJobType(ErrorCode);      { Ex_GetJobType Index 126 }
   129 : GenStr:=Get_OverrideINI(ErrorCode);     { Ex_OverrideIni Index 128 }

   130 : GenStr:=Get_TranCanBeUpdated(ErrorCode);{ Ex_TranCanBeUpdated }
   131 : GenStr:=Get_ReadIniValue(ErrorCode);
   132 : GenStr:=Get_UnlockRecord(ErrorCode);
   133 : GenStr:=Get_StoreTransHedOrDetl(ErrorCode); { Ex_StoreTransDetl Index 133 }
   134 : GenStr:=Get_CheckSecurity(ErrorCode);       { EX_CHECKSECURITY Index 134 }
   135 : GenStr:=Get_GetECommsData(ErrorCode);       { EX_GetEcommsData Index 135 }

   138 : GenStr:=Get_DateToEntPeriod(ErrorCode);     { Ex_DateToEntPeriod Index 138}

   142 : GenStr:=Get_CalculateTransTotal(ErrorCode);
   144 : GenStr:=Get_CalcLineTax(ErrorCode);
   145 : GenStr:=Get_CorrectVATCode(ErrorCode);
   146 : GenStr:=Get_GetStock(ErrorCode);         { EX_GETSTOCKBYFOLIO INDEX 146 }
   147 : GenStr:=Get_GetTrans(ErrorCode);        { EX_GETEBUSTRANS INDEX 147 }

   148 : GenStr := Get_GETENTDATA(ErrorCode);    { EX_GETENTDATA Index 148 }
   149 : GenStr:=Get_UpdateDueDate(ErrorCode);   { Ex_UpdateDueDate Index 149 }

   154 : GenStr:=Get_DeleteQuote(ErrorCode);     { Ex_DeleteQuote Index 154 }

   155 : GenStr:=Get_DeleteDiscMatrix(ErrorCode);

   157 : GenStr:=Get_StoreCurrency(ErrorCode); {EX_STORECURRENCY Index 157}

   158 : GenStr:=Get_UpdatePayInRef(ErrorCode); {EX_UPDATEPAYINREF Index 158}

   159 : GenStr:=Get_GetLink(ErrorCode);             {EX_GETLINK Index 159}
   160 : GenStr:=Get_StoreLink(ErrorCode);           {EX_STORELINK Index 160}
   161 : GenStr:=Get_DeleteLink(ErrorCode);          {EX_DELETELINK Index 161}
   162 : GenStr:=Get_UpdateLineDate(ErrorCode);      {EX_UPDATELINEDATE Index 162}
   163 : GenStr:=Get_UnuseSerialBatch(ErrorCode);    {EX_UNUSESERIALBATCH Index 163}
   167 : GenStr:=Get_StoreJobEmployee(ErrorCode);    {EX_STOREJOBEMPLOYEE Index 167}
   168 : GenStr:=Get_StoreJobAnalysis(ErrorCode);    {EX_STOREJOBANALYSIS Index 168}
   169 : GenStr:=Get_StoreJobType(ErrorCode);        {EX_STOREJOBTYPE Index 169}
   170 : GenStr:=Get_StoreJobTimeRate(ErrorCode);    {EX_StoreJobTimeRate Index 170}
   171 : GenStr:=Get_DeleteMatch(ErrorCode);         {EX_DELETEMATCH Index 171}
   172 : GenStr:=Get_GetMultiBin(ErrorCode);         {EX_GETMULTIBIN 172}
   173 : GenStr:=Get_StoreMultiBin(ErrorCode);       {EX_STOREMULTIBIN 173}
   174 : GenStr:=Get_UseMultiBin(ErrorCode);         {EX_USEMULTIBIN 174}
   175 : GenStr:=Get_UnUseMultiBin(ErrorCode);       {EX_UNUSEMULTIBIN 175}
   176 : GenStr:=Get_SetJAInvoicedFlag(ErrorCode);
   177 : GenStr:=Get_UpdateCISDate(ErrorCode);

   179,
   180 : GenStr:=Get_UpdateSerialBatch(ErrorCode);

   184 : GenStr := Get_UpdateReconcileFlag(ErrorCode); {Ex_UpdateReconcileFlag 184}

   195 : GenStr:=Get_GetMultiBuy(ErrorCode);
   196 : GenStr:=Get_StoreMultiBuy(ErrorCode);
   197 : GenStr:=Get_DeleteMultiBuy(ErrorCode);

   200 : GenStr:=Get_InitPrintForm(ErrorCode);   { Ex_InitPrintForm Index 200 }
   201 : GenStr:=Get_AddTransForm(ErrorCode);    { Ex_AddTransForm Index 201 }
   202 : GenStr:=Get_PrintForm(ErrorCode);       { Ex_PrintForm Index 202 }

  {203 : procedure Ex_EndPrintForm - nothing to return  - Index 203 }

   206 : GenStr:=Get_InitStructure(ErrorCode);      { EX_INITSTRUCTURE   Index 206 }
   207 : GenStr:=Get_CreateTLArray(ErrorCode);      { EX_CREATETLARRAY   Index 207 }
   208 : GenStr:=Get_AddTLArrayLine(ErrorCode);     { EX_ADDTLARRAYLINE  Index 208 }
   {//209 : GenStr:=Get_DestroyTLArray(ErrorCode);  { EX_DESTROYTLARRAY  Index 209 }
   210 : GenStr:=Get_GETTLARRAY(ErrorCode);         { EX_GETTLARRAY      Index 210 }
   211 : GenStr:=Get_GETTLARRAYLine(ErrorCode);     { EX_GETTLARRAYLINE  Index 211 }
   212 : GenStr:=Get_UpdateLineDate(ErrorCode);
   213 : GenStr:=Get_ResetLineSerialCount(ErrorCode);


   500 : GenStr:=GetUserProfile(ErrorCode);         { EX_GetUserProfile  Index 500 }

   600 : GenStr:=Get_SaveJobBudget(ErrorCode); //IJobBudget.Save - Com Tk Only
   601 : GenStr:=Get_SaveJobRetention(ErrorCode); //IJobRetention.Save - Com Tk Only
   602 : GenStr:=Get_JobInvoiceExecute(ErrorCode); //IJobInvoice.Execute - Com Tk Only

   610 : GenStr:=Get_ReturnAction(ErrorCode); //IReturnAction.Execute - Com Tk Only
   611 : GenStr:=Get_ReturnCreate(ErrorCode); //ITransactionReturnCreate.Execute - Com Tk Only

   //PR: 30/01/2014 ABSEXCH-14974
   620 : GenStr:=Get_StoreAccountContact(ErrorCode); //IAccountContact.Save - Com Tk Only

   //PR: 31/10/2014 Order payments
   630 : GenStr:=Get_TakeCreditCardPayment(ErrorCode); //IOrderPaymentTakePayment.Execute - Com Tk Only
   631 : GenStr:=Get_GiveCreditCardRefund(ErrorCode); //IOrderPaymentTakePayment.Execute - Com Tk Only

  end; {case..}

  Ex_ErrorDescription:=GenStr;

end; {func..}



FUNCTION EX_GETLASTERRORDESC  :  SHORTSTRING;
begin

  Ex_GetLastErrorDesc:=LastErDesc;

end; {func..}

Initialization
  DlgMessageString := '';

end.
