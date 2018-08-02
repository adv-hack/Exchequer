unit DPView_Document;

interface

Uses SysUtils, StdCtrls;

Procedure ProcessDocument(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);

implementation

Uses VarConst, DpViewFuncs;

//=========================================================================

Procedure ProcessDocument(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);
Begin // ProcessDocument
  If (DataBlockLen = SizeOf(InvRec)) Then
  Begin
    Move (DataBlock^, Inv, SizeOf(Inv));

    OutputMemo.Lines.Add ('Document');
    OutputMemo.Lines.Add ('--------');

    OutputInteger (OutputMemo, 'RunNo', Inv.RunNo);
    OutputString  (OutputMemo, 'CustCode', Inv.CustCode, SizeOf(Inv.CustCode) - 1);
//     NomAuto   :  Boolean;     { Auto Day book flag }
    OutputString  (OutputMemo, 'OurRef', Inv.OurRef, SizeOf(Inv.OurRef) - 1);
    OutputInteger (OutputMemo, 'FolioNum', Inv.FolioNum);
    OutputInteger (OutputMemo, 'Currency', Inv.Currency);
    OutputInteger (OutputMemo, 'AcYr', Inv.AcYr);
    OutputInteger (OutputMemo, 'AcPr', Inv.AcPr);
    OutputString  (OutputMemo, 'DueDate', Inv.DueDate, SizeOf(Inv.DueDate) - 1);
    OutputString  (OutputMemo, 'VATPostDate', Inv.VATPostDate, SizeOf(Inv.VATPostDate) - 1);
    OutputString  (OutputMemo, 'TransDate', Inv.TransDate, SizeOf(Inv.TransDate) - 1);
    OutputChar    (OutputMemo, 'CustSupp', Inv.CustSupp);
//      {063}     CXrate    :  CurrTypes;   { Co/VAT Rates }
    OutputString  (OutputMemo, 'OldYourRef', Inv.OldYourRef, SizeOf(Inv.OldYourRef) - 1);
    OutputString  (OutputMemo, 'BatchLink', Inv.BatchLink, SizeOf(Inv.BatchLink) - 1);
    OutputChar    (OutputMemo, 'AllocStat', Inv.AllocStat);
//      {100}     ILineCount:  LongInt;     { SOP Mode Invoice line count }
//      {104}     NLineCount:  LongInt;     { Notes Line count }
//      {108}     InvDocHed :  DocTypes;    { Document Type }
//      {109}     InvVatAnal:  Array[VATType] of Real;        { Analysis of VAT Anal }
//      {211}     InvNetVal :  Real;        { Total Posting Value of Doc }
//      {247}     InvVat    :  Real;        { Total VAT Content }
//      {253}     DiscSetl  :  Real;        { Discount Avail/Take }
//      {259}     DiscSetAm :  Real;        { Actual Value of Setle Discount }
//      {265}     DiscAmount:  Real;        { Discount Amount     }
//      {271}     DiscDays  :  SmallInt;     { No Days Disc Avail }
//      {273}     DiscTaken :  Boolean;     { Discount Taken }
//      {274}     Settled   :  Real;        { Amount Paid Off }
//      {280}     AutoInc   :  SmallInt;     { Automatic Document Increment }
//      {281}     UnYr,UnPr :  Byte;        { Auto Until Period }
//      {282}     TransNat  :  Byte;        { VAT Nature of Transaction }
//      {283}     TransMode :  Byte;        { VAT Mode of Transport     }
    OutputString  (OutputMemo, 'RemitNo', Inv.RemitNo, SizeOf(Inv.RemitNo) - 1);
    OutputChar    (OutputMemo, 'AutoIncBy', Inv.AutoIncBy);
//      {296}     HoldFlg   :  Byte;        { Hold Status }
//      {297}     AuditFlg  :  Boolean;     { Is Doc Purgable }
//      {298}     TotalWeight  :  Real;        { Order Weight Details }
    OutputString  (OutputMemo, 'DAddr[1]', Inv.DAddr[1], SizeOf(Inv.DAddr[1]) - 1);
    OutputString  (OutputMemo, 'DAddr[2]', Inv.DAddr[2], SizeOf(Inv.DAddr[2]) - 1);
    OutputString  (OutputMemo, 'DAddr[3]', Inv.DAddr[3], SizeOf(Inv.DAddr[3]) - 1);
    OutputString  (OutputMemo, 'DAddr[4]', Inv.DAddr[4], SizeOf(Inv.DAddr[4]) - 1);
    OutputString  (OutputMemo, 'DAddr[5]', Inv.DAddr[5], SizeOf(Inv.DAddr[5]) - 1);
//      {459}     Variance  :  Real;        { Currency Exchabge Loss/ Gain }
//      {465}     TotalOrdered,             { Receipt / NTxfr, Unrounded Base Equivalent of line totals , used to suggest value }
//      {471}     TotalReserved,            {    "    Total amount of Variance }
//      {477}     TotalCost,                { Total value of cost prices for profitablity *}
//      {483}     TotalInvoiced             { Receipt Total rounded Base Equivalent of line totals, used to calculate Required }
//                          :  Real;
    OutputString  (OutputMemo, 'TransDesc', Inv.TransDesc, SizeOf(Inv.TransDesc) - 1);
    OutputString  (OutputMemo, 'UntilDate', Inv.UntilDate, SizeOf(Inv.UntilDate) - 1);
    OutputChar    (OutputMemo, 'NOMVATIO', Inv.NOMVATIO);
//        {520}     ExternalDoc :  Boolean;     {* This is an externaly created Document, no edit allowed *}
//        {521}     PrintedDoc
//                            :  Boolean;     {* This Document has been printed *}
//        {522}     ReValueAdj:  Real;        {* Adjustment needed to make
//        {528}     CurrSettled
//                            :  Real;        {* Docs Own Setttled rate *}
//        {534}     SettledVAT
//                            :  Real;        {* Amount recorded as settled during last VAT Return (Cash Accounting) *}
//        {540}     VATClaimed
//                            :  Real;        {* Total VAT presented as at last VAT Return (Cash Accounting) *}
//
//        {546}     BatchNom  :  LongInt;     {* Batch Payment Nominal *}
//
//        {550}     AutoPost  :  Boolean;     {* Pickup Auto item on Daybook post  *}
//                                            {* Also used to indicate Nom Generated automaticly by system *}
//
//        {551}     ManVAT    :  Boolean;     {* If Set, prevents re-calclation of VAT *}
    OutputString  (OutputMemo, 'DelTerms', Inv.DelTerms, SizeOf(Inv.DelTerms) - 1);
//      {558}     OnPickRun :  Boolean;     {* Included in picking run
    OutputString  (OutputMemo, 'OpName', Inv.OpName, SizeOf(Inv.OpName) - 1);
//      {570}     NoLabels  :  SmallInt;     {* No. of labels to print *}
//
//      {571}     {$IFDEF WIN32}
//                  Tagged    :  Byte;         {* Doc Marked for something *}
//                {$ELSE}
//                  Tagged    :  Boolean;
//                {$ENDIF}
//
//      {572}     PickRunNo :  LongInt;     {* Flag to indicate inclusion on picking list *}
//
//      {576}     OrdMatch  :  Boolean;     {* Flag to indicate we have a match on order set up *}
    OutputString  (OutputMemo, 'DeliverRef', Inv.DeliverRef, SizeOf(Inv.DeliverRef) - 1);
//      {588}     VATCRate  :  CurrTypes;   {* Exchange Rate for Calculating VAT if VAT return is in any
//      {600}     OrigRates :  CurrTypes;
//      {612}     PostDiscAm:  Double;      {* Posted Discount taken/given *}
//      {620}     FRNomCode :  LongInt;     {* Spare *}
//      {624}     PDiscTaken:  Boolean;     {* Posted Settlement Discount Taken *}
//      {625}     CtrlNom   :  Longint;     {* Debtor/Creditor Control Nominal *}
    OutputString  (OutputMemo, 'DJobCode', Inv.DJobCode, SizeOf(Inv.DJobCode) - 1);
    OutputString  (OutputMemo, 'DJobAnal', Inv.DJobAnal, SizeOf(Inv.DJobAnal) - 1);
//      {648}     TotOrdOS  :  Real;        {* Value of Order Outstanding/ Temp Aged Debt Value *}
    OutputString  (OutputMemo, 'FRCCDep[False]', Inv.FRCCDep[False], SizeOf(Inv.FRCCDep[False]) - 1);
    OutputString  (OutputMemo, 'FRCCDep[True]', Inv.FRCCDep[True], SizeOf(Inv.FRCCDep[True]) - 1);
    OutputString  (OutputMemo, 'DocUser1', Inv.DocUser1, SizeOf(Inv.DocUser1) - 1);
    OutputString  (OutputMemo, 'DocUser2', Inv.DocUser2, SizeOf(Inv.DocUser2) - 1);
//      {687}     DocLSplit : Array[1..6] of{* Store makeup of line totals *}
//                            Double;
//
//      {735}     LastLetter: Byte;
//      {736}     BatchNow,
//                BatchThen
//                          : Double;       {* Part allocation value in Batch payments *}
//      {752}     UnTagged  : Boolean;      {* Exclude from BACS Indicator, also used on NOMs to indicate
//                                             auto reversing from v4.31+ *}
//
//      {753}     OBaseEquiv: Double;       {* Pre EMU conversion base value }
//      {761}     UseORate  : Byte;         {* Forces the conversion routines to apply non tri rules *}
//      {762}     OldORates : CurrTypes;    {* After euro conversion, very original rates are shown *}
//      {774}     SOPKeepRate
//                          : Boolean;      {* When converting through SOP process, use original order rate *}
    OutputString  (OutputMemo, 'DocUser3', Inv.DocUser3, SizeOf(Inv.DocUser3) - 1);
    OutputString  (OutputMemo, 'DocUser4', Inv.DocUser4, SizeOf(Inv.DocUser4) - 1);
    OutputChar    (OutputMemo, 'SSDProcess', Inv.SSDProcess);
//      {819}     ExtSource : Byte;         {* If transaction created externaly where from *}
//      {820}     CurrTriR  : TriCurType;   {* Details of Main Triangulation *}
//      {841}     VATTriR   : TriCurType;   {* Details of VAT Triangulation *}
//      {862}     OrigTriR  : TriCurType;   {* Details of Orig Triangulation *}
//      {883}     OldORTriR : TriCurType;   {* Details of Old pre euro base Triangulation *}
    OutputString  (OutputMemo, 'PostDate', Inv.PostDate, SizeOf(Inv.PostDate) - 1);
//      {913}     PORPickSOR: Boolean;      {* Back to Back SOR/POR auto picks SOR *}
//      {914}     BDiscount : Double;       {* Amount of discount applied via batch *}
//      {922}     PrePostFlg: Byte;         {* Used to indicate on Noms if posting should generate any associated
//      {923}     AuthAmnt  : Double;       {* Amount authorised when last stored *}
    OutputString  (OutputMemo, 'TimeChange', Inv.TimeChange, SizeOf(Inv.TimeChange) - 1);
    OutputString  (OutputMemo, 'TimeCreate', Inv.TimeCreate, SizeOf(Inv.TimeCreate) - 1);
//        {945}    CISTax   : Double;       {*Total amount of CIS tax to be deducted *}
//        {953}    CISDeclared
//                          : Double;       {* Total amount of CIS declared on vouchers, correlates to
//        {961}    CISManualTax
//                          : Boolean;      {* Tax was overridden by manual adjustment, do not auto calculate *}
    OutputString  (OutputMemo, 'CISDate', Inv.CISDate, SizeOf(Inv.CISDate) - 1);
//        {971}    TotalCost2
//                          : Double;       {* Cost appotrionment from outside costs, included in GP *}
    OutputString  (OutputMemo, 'CISEmpl', Inv.CISEmpl, SizeOf(Inv.CISEmpl) - 1);
//        {990}    CISGross : Double;       {* Basis of CIS Tax *}
//        {998}    CISHolder: Byte;         {* >0 Document is a CIS carrier generated from another process like
//         {999}   THExportedFlag
//                        : Boolean;      {* Flag to indicate timesheet exported *}
//         {1000}   CISGExclude         {* Amount to be exluded from gross calucaltion *}
//                        : Double;
////         {1008}   Spare5   : Array[1..64] of Byte;        {* !! *}
//
//                  // MH 01/02/2010 (v6.3) Added new fields for Web Extensions
//                  thWeekMonth : SmallInt;
//                  thWorkflowState : LongInt;
    OutputString  (OutputMemo, 'thOverrideLocation', Inv.thOverrideLocation, SizeOf(Inv.thOverrideLocation) - 1);
//                  Spare5   : Array[1..54] of Byte;
    OutputString  (OutputMemo, 'YourRef', Inv.YourRef, SizeOf(Inv.YourRef) - 1);
    OutputString  (OutputMemo, 'DocUser5', Inv.DocUser5, SizeOf(Inv.DocUser5) - 1);
    OutputString  (OutputMemo, 'DocUser6', Inv.DocUser6, SizeOf(Inv.DocUser6) - 1);
    OutputString  (OutputMemo, 'DocUser7', Inv.DocUser7, SizeOf(Inv.DocUser7) - 1);
    OutputString  (OutputMemo, 'DocUser8', Inv.DocUser8, SizeOf(Inv.DocUser8) - 1);
    OutputString  (OutputMemo, 'DocUser9', Inv.DocUser9, SizeOf(Inv.DocUser9) - 1);
    OutputString  (OutputMemo, 'DocUser10', Inv.DocUser10, SizeOf(Inv.DocUser10) - 1);
//                  Spare600  : Array[1..614] of Byte;        {* !! *}
  End // If (DataBlockLen = SizeOf(InvRec))
  Else
    OutputMemo.Lines.Add ('*** Document - Invalid Size - ' + IntToStr(SizeOf(InvRec)) + ' expected, ' + IntToStr(DataBlockLen) + ' received');
End; // ProcessDocument

end.
