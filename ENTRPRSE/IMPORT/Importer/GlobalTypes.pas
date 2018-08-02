unit GlobalTypes;

{******************************************************************************}
{                             Global Types                                     }
{******************************************************************************}

interface

uses GlobalConsts, Classes, GlobVar;

{$I ExchCTK.inc}

type

  TBatchAVJobRec = record
    jrCode: 				string[10];
    jrType:					byte;
    jrParent:				string[10];
    jrAltCode:				string[10];
    jrContact:				string[25];
    jrDesc:    			string[30];
    jrStartDate:			string[8];
    jrEndDate:				string[8];
    jrRevisedEndDate:	string[8];
    jrJobType:				string[3];
    jrAcCode: 				string[6];
    jrManager:				string[25];
    jrChargeType:			byte;
    jrQuotePrice:			double;
    jrQuotePriceCurr:	smallint;
    jrSORNumber:			string[10];
    jrStatus:				byte;
    jrCompleted:			WordBool;
    jrUserField1:			string[20];
    jrUserField2:			string[20];
    jrUserField3:			string[20];
    jrUserField4:			string[20];
  end;

  TBatchAVABRec = record // Analysis Budget
    jrCode:              string[10];
    jbAnalysisCode:      string[10];
    jbAnalysisType:      byte;
    jbApplicationBasis:  byte;
    jbApplyPercent:      Double;
    jbCategory:          byte;
    jbCostOverhead:      Double;
    jbOriginalQty:       Double;
    jbOriginalValuation: Double;
    jbOriginalValue:     Double;
    jbPeriod:            SmallInt;
    jbRecharge:          WordBool;
    jbRevisedQty:        Double;
    jbRevisedValuation:  Double;
    jbRevisedValue:      Double;
    jbUnitPrice:         Double;
    jbUplift:            Double;
    jbYear:              SmallInt;
    jbCurrency:          SmallInt;  //PR: 21/09/2010 Changed from Integer
  end;

  TBatchAVHRec = record
    jrCode:             string[10];
    tpAcCode:           string[6];
    tpAppsInterimFlag:  byte;
    tpATR:              WordBool;
    tpCertified:        WordBool;
    tpCertifiedValue:   Double;
    tpCISDate:          string[8];
    tpCISManualTax:     WordBool;
    tpCISSource:        byte;
    tpCISTaxDeclared:   Double;
    tpCISTaxDue:        Double;
    tpCompanyRate:      Double;
    tpCurrency:         SmallInt;
    tpDailyRate:        Double;
    tpDate:             string[8];
    tpDeferVat:         WordBool;
    tpManualVAT:        WordBool;
    tpOurRef:           string[10];
    tpParentTerms:      string[10];
    tpPeriod:           SmallInt;
    tpTermsInterimFlag: byte;
    tpUserField1:       string[30];
    tpUserField2:       string[30];
    tpUserField3:       string[30];
    tpUserField4:       string[30];
    tpYear:             SmallInt;
    tpYourRef:          string[10];
    tpEmployeeCode:     string[6];
    thFixedRate:        WordBool;
  end;

  TBatchAVDDRec = record
    tplAnalysisCode:         string[10];
    tplAppliedYTD:           Double;
    tplCalcBeforeRetention:  WordBool;
    tplCertified:            WordBool;
    tplCertifiedYTD:         Double;
    tplCostCentre:           string[3];
    tplDeductionAppliesTo:   byte;
    tplDeductionType:        byte;
    tplDeductValue:          Double;
    tplDepartment:           string[3];
    tplDescr:                string[20];
    tplJobCode:              string[10];
    tplLineType:             byte;
    tplOverrideValue:        WordBool;
    tplQty:                  Double;
    tplRetention:            Double;
    tplRetentionExpiry:      LongInt;
    tplRetentionExpiryBasis: byte;
    tplRetentionType:        byte;
    tplTermsLineNo:          LongInt;
    tplUserField1:           string[30];
    tplUserField2:           string[30];
    tplUserField3:           string[30];
    tplUserField4:           string[30];
    tlVATCode:               char;
    tplBudgetJCT:            Double;
  end;

  TBatchAVRRRec = record
    tplAnalysisCode:         string[10];
    tplAppliedYTD:           Double;
    tplCalcBeforeRetention:  WordBool;
    tplCertified:            WordBool;
    tplCertifiedYTD:         Double;
    tplCostCentre:           string[3];
    tplDeductionAppliesTo:   byte;
    tplDeductionType:        byte;
    tplDeductValue:          Double;
    tplDepartment:           string[3];
    tplDescr:                string[20];
    tplJobCode:              string[10];
    tplLineType:             byte;
    tplOverrideValue:        WordBool;
    tplQty:                  Double;
    tplRetention:            Double;
    tplRetentionExpiry:      LongInt;
    tplRetentionExpiryBasis: byte;
    tplRetentionType:        byte;
    tplTermsLineNo:          LongInt;
    tplUserField1:           string[30];
    tplUserField2:           string[30];
    tplUserField3:           string[30];
    tplUserField4:           string[30];
    tlVATCode:               char;
    tplBudgetJCT:            Double;
  end;


  //PR: 12/02/2014 Moved from oAccountVar to fix compilation problems in SQLHelper.pas
  PImporterAccountContactRec = ^TImporterAccountContactRec;
  TImporterAccountContactRec = Record
    iacAccountCode    : String[10];
    iacName           : String[45];
    iacJobTitle       : String[30];
    iacPhoneNumber    : String[30];
    iacFaxNumber      : String[30];
    iacEmailAddress   : String[100];
    iacHasOwnAddress  : WordBool;
    iacAddress        : AddrTyp;
    iacPostCode       : String[20];

    //PR: 28/11/2014 Order Payments
    iacCountryCode    : String[2];
  end;

  PImporterAccountContactRoleRec = ^TImporterAccountContactRoleRec;
  TImporterAccountContactRoleRec = Record
    icrAccountCode           : String[10];
    icrContactName           : String[45];
    icrRoleDescription       : String[50];
  end;



  TExchequerRec = record
    case integer of
      01:  (BatchCURec:        TBatchCURec);        // Customer / Supplier
      02:  (BatchTHRec:        TBatchTHRec);        // Transaction Header
      03:  (BatchTLRec:        TBatchTLRec);        // Transaction Line
      04:  (BatchSKRec:        TBatchSKRec);        // Stock Record
      05:  (BatchNomRec:       TBatchNomRec);       // G/L Nominal Record
      06:  (BatchMatchRec:     TBatchMatchRec);     // Matching Record
      07:  (BatchNotesRec:     TBatchNotesRec);     // Notes Record
      08:  (BatchJHRec:        TBatchJHRec);        // Job Header
      09:  (BatchMLocRec:      TBatchMLocRec);      // Master Location Record
      10:  (BatchBOMImportRec: TBatchBOMImportRec); // BOM Import Record
      11:  (BatchSLRec:        TBatchSLRec);        // Multi-Location Stock Record
{
      12:  (BatchCM:           TBatchCMRec);        // Heinz CheckSum Record - can't find reference to it in CVSExch or ExWimp other than its def in EPOSN.INC
}
      13:  (BatchAutoBankRec:  TBatchAutoBankRec);  // Bank Matching Record
      14:  (BatchEmplRec:      TBatchEmplRec);      // Employee Record
      15:  (BatchJobAnalRec:   TBatchJobAnalRec);   // Job Analysis Code Record
      16:  (BatchJobRateRec:   TBatchJobRateRec);   // Job Costing Time Record
      17:  (BatchSKAltRec:     TBatchSKAltRec);     // Alternative Stock Codes Record
      18:  (BatchSerialRec:    TBatchSerialRec);    // Serial Batch Stock Record
      19:  (BatchBinRec:       TBatchBinRec);       // Multi-Bin Stock Record
      20:  (BatchDiscRec:      TBatchDiscRec);      // Discount Matrix Record

      21:  (BatchAVJobRec:     TBatchAVJobRec);     // Job Record
      22:  (BatchAVHRec:       TBatchAVHRec);       // Sales Terms, Purchase Terms, Contract Terms, Sales Application and Purchase Application transaction header
      23:  (BatchAVABRec:      TBatchAVABRec);      // Analysis Budget
      24:  (BatchAVDDRec:      TBatchAVDDRec);      // Deduction Line
      25:  (BatchAVRRRec:      TBatchAVRRRec);      // Retention Line
      26:  (BatchCCDepRec:     TBatchCCDepRec);     // Cost Centre / Department record
      27:  (BatchMultiBuyRec:  TBatchMultiBuyDiscount);  // MultiBuy Discount
      28:  (ContactRec:        TImporterAccountContactRec);
      29:  (ContactRoleRec:    TImporterAccountContactRoleRec);
      99:  (AsRecord:  Array[1..STD_IMPORT_FILE_RECORD_LENGTH] of Char); // will always be longer than the longest record which is currently TBatchSKRec
    end;

  PExchequerRec = ^TExchequerRec;

  TImportFileRec = record
    case integer of
      01:  (
            RecordType:  array[1..2] of char;
            Filler:      array[1..STD_IMPORT_FILE_RECORD_LENGTH - 2] of char;
            );
      02:  (AsArray:     array[0..STD_IMPORT_FILE_RECORD_LENGTH - 1] of char); // 0-based to fit in with TMaps.StdOffset
      99:  (AsRecord:    array[1..STD_IMPORT_FILE_RECORD_LENGTH] of Char);
    end;

  TImportFileType = (ftUserDef, ftStdImport);

  TArrayOfChar = array[0..255] of char;  //PR: 28/05/2010 Changed from dynamic array to static,to help fix memory leaks.

  TArrayOfObjects = array of TObject;


// Always insert new fields directly before FieldDesc and modify Utils.CheckForOldFieldDef to cater for existing Field Maps
  TFieldDef = record
    case integer of
      1: (
            FieldDefType:  char;                         // 001 001
            FieldNo:       array[1..3]   of char;        // 002 003
            equals:        char;                         // 005 001
            RecordType:    array[1..2]   of char;        // 006 002
            dot:           char;                         // 008 001
            FieldName:     array[1..25]  of char;        // 009 025
            blank1:        char;                         // 034 001
            Offset:        array[1..4]   of char;        // 035 004
            blank2:        char;                         // 039 001
            Occurs:        array[1..2]   of char;        // 040 002
            blank3:        char;                         // 042 001
            FieldType:     char;                         // 043 001
            blank4:        char;                         // 044 001
            FieldWidth:    array[1..4]   of char;        // 045 004
            blank5:        char;                         // 049 001
            FieldUsage:    char;                         // 050 001
            blank6:        char;                         // 051 001
            FieldSys:      char;                         // 052 001
            blank7:        char;                         // 053 001
            FieldDesc:     array[1..50]  of char;        // 054 050 // insert new fields directly before FieldDesc
            blank8:        char;                         // 104 001
            DefaultEquals: array[1..8]   of char;        // 105 008
            FieldDefault:  array[1..100] of char;        // 113 100
            blank9:        char;                         // 213 001
            CommentEquals: array[1..8]   of char;        // 214 008
            FieldComment:  array[1..100] of char;        // 222 100
          );
      2: (AsArray: array[1..319] of char);
    end;

  TArrayOfFieldDefs = array of TFieldDef;

  TManagedRec = record
    RecordType:   array[1..2] of char;
    OrigRecType:  array[1..2] of char; // v.061
    KeyFields:    array[0..19] of char; // RT + LinkRef = 12, plus a bit extra for future expansion - NOT null-terminated
    JobNo:        integer;  // Used to identify the original source
    FileNo:       integer;  // record of an input file even when records have
    RecNo:        integer;  // been written to the sort file and read back in.
    ExchequerRec: TExchequerRec;
  end;

  PManagedRec = ^TManagedRec;

  TArrayOfManagedRec = array of TManagedRec;
  PArrayOfManagedRec = ^TArrayOfManagedRec;

  TSaveLoad      = (slSave, slLoad);
  TSettingType   = (stUnknown, stFreeText, stFixedList, stFolder, stFile, stDataPath, stTime, stFileorPathWithMask,
                    stDouble, stSmallInt, stChar, stWordBool, stLongInt, stByte, stBoolean);

implementation

end.
