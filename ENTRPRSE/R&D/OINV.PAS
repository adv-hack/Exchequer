unit oInv;

{$I DEFOVR.INC}

interface

Uses Classes, Dialogs, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     ExWrap1U, oIDetail, CustTypU;

Type
  TInvoice = Class;

  { Abstract Transaction Lines Interface - used by TAbsInvoice }
  TInvoiceLines = Class(TAbsInvoiceLines)
  Private
    FuncAccess : Array [1..1] Of TFunctionAccess;
    ParentInv : TInvoice;
    EntSys    : TEnterpriseSystem;
  Protected
    LineAccess : TRecAccessStatus;
    InvLines : TList;
    CurrentLine : TInvLine;
    DelLine : TInvLine;
    Function GetLineCount : SmallInt; Override;
    Function GetInvLine(Index : SmallInt) : TAbsInvLine; Override;
    Function GetCurrentLine : TAbsInvLine; Override;

    Procedure ClearLines;
  Public
    Constructor Create(      hEntSys : TEnterpriseSystem;
                       Const Parent  : TInvoice);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId  : LongInt;
                        Const InvLine           : IDetail;
                        Const CheckForPayments  : Boolean = True);
    Procedure   Replicate(Const ReplItem : SmallInt);

    Procedure   DeleteLine(Const TheLine : TAbsInvLine);

    Procedure   AddNewLine; OverRide;

    // HM 20/02/03: Added for EL - see notes with function before using
    Function ChangeCurrentLine (Const InvLine : IDetail) : Boolean;


  End; { TAbsInvoiceLines }


  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TInvoice = Class(TAbsInvoice14)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..126] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem; { Master object }

    DataRec, OrigRec : InvRec;
    InvLines         : TInvoiceLines;

    //PR: 23/11/2017 ABSEXCH-19451
    FRestrictedEdit : Boolean;
  Protected
    { Abstract Property Access methods from TAbsCustomer }
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetRunNo : Longint; Override;
    Procedure SetRunNo(Value : Longint); Override;
    Function  GetCustCode : cuStr10; Override;
    Procedure SetCustCode(Value : cuStr10); Override;
    Function  GetNomAuto : Boolean; Override;
    Procedure SetNomAuto(Value : Boolean); Override;
    Function  GetOurRef : cuStr10; Override;
    Procedure SetOurRef(Value : cuStr10); Override;
    Function  GetFolioNum : Longint; Override;
    Procedure SetFolioNum(Value : Longint); Override;
    Function  GetCurrency : Byte; Override;
    Procedure SetCurrency(Value : Byte); Override;
    Function  GetAcYr : Byte; Override;
    Procedure SetAcYr(Value : Byte); Override;
    Function  GetAcPr : Byte; Override;
    Procedure SetAcPr(Value : Byte); Override;
    Function  GetDueDate : cuLongDate; Override;
    Procedure SetDueDate(Value : cuLongDate); Override;
    Function  GetVATPostDate : cuLongDate; Override;
    Procedure SetVATPostDate(Value : cuLongDate); Override;
    Function  GetTransDate : cuLongDate; Override;
    Procedure SetTransDate(Value : cuLongDate); Override;
    Function  GetCustSupp : Char; Override;
    Function  GetCXrate1 : Real; Override;
    Procedure SetCXrate1(Value : Real); Override;
    Function  GetCXrate2 : Real; Override;
    Procedure SetCXrate2(Value : Real); Override;
    Function  GetYourRef : cuStr10; Override;
    Procedure SetYourRef(Value : cuStr10); Override;
    Function  GetBatchLink : cuStr12; Override;
    Procedure SetBatchLink(Value : cuStr12); Override;
    Function  GetAllocStat : Char; Override;
    Procedure SetAllocStat(Value : Char); Override;
    Function  GetInvDocHed : cuDocTypes; Override;
    Procedure SetInvDocHed(Value : cuDocTypes); Override;
    Function  GetInvVatAnal (Index : cuVATIndex) : Real; Override;
    Procedure SetInvVatAnal(Index : cuVATIndex; Value : Real); Override;
    Function  GetInvNetVal : Real; Override;
    Function  GetInvVat : Real; Override;
    Function  GetDiscSetl : Real; Override;
    Procedure SetDiscSetl(Value : Real); Override;
    Function  GetDiscSetAm : Real; Override;
    Procedure SetDiscSetAm(Value : Real); Override;
    Function  GetDiscAmount : Real; Override;
    Procedure SetDiscAmount(Value : Real); Override;
    Function  GetDiscDays : SmallInt; Override;
    Procedure SetDiscDays(Value : SmallInt); Override;
    Function  GetDiscTaken : Boolean; Override;
    Procedure SetDiscTaken(Value : Boolean); Override;
    Function  GetSettled : Real; Override;
    Procedure SetSettled(Value : Real); Override;
    Function  GetAutoInc : SmallInt; Override;
    Procedure SetAutoInc(Value : SmallInt); Override;
    Function  GetUnYr : Byte; Override;
    Procedure SetUnYr(Value : Byte); Override;
    Function  GetUnPr : Byte; Override;
    Procedure SetUnPr(Value : Byte); Override;
    Function  GetTransNat : Byte; Override;
    Procedure SetTransNat(Value : Byte); Override;
    Function  GetTransMode : Byte; Override;
    Procedure SetTransMode(Value : Byte); Override;
    Function  GetRemitNo : cuStr10; Override;
    Procedure SetRemitNo(Value : cuStr10); Override;
    Function  GetAutoIncBy : Char; Override;
    Procedure SetAutoIncBy(Value : Char); Override;
    Function  GetHoldFlg : Byte; Override;
    Procedure SetHoldFlg(Value : Byte); Override;
    Function  GetAuditFlg : Boolean; Override;
    Procedure SetAuditFlg(Value : Boolean); Override;
    Function  GetTotalWeight : Real; Override;
    Procedure SetTotalWeight(Value : Real); Override;
    Function  GetDAddr (Index : cuAddrIndex) : cuStr30; Override;
    Procedure SetDAddr(Index : cuAddrIndex; Value : cuStr30); Override;
    Function  GetVariance : Real; Override;
    Procedure SetVariance(Value : Real); Override;
    Function  GetTotalOrdered : Real; Override;
    Procedure SetTotalOrdered(Value : Real); Override;
    Function  GetTotalReserved : Real; Override;
    Procedure SetTotalReserved(Value : Real); Override;
    Function  GetTotalCost : Real; Override;
    Procedure SetTotalCost(Value : Real); Override;
    Function  GetTotalInvoiced : Real; Override;
    Procedure SetTotalInvoiced(Value : Real); Override;
    Function  GetTransDesc : cuStr20; Override;
    Procedure SetTransDesc(Value : cuStr20); Override;
    Function  GetUntilDate : cuLongDate; Override;
    Procedure SetUntilDate(Value : cuLongDate); Override;
    Function  GetExternalDoc : Boolean; Override;
    Procedure SetExternalDoc(Value : Boolean); Override;
    Function  GetPrintedDoc : Boolean; Override;
    Procedure SetPrintedDoc(Value : Boolean); Override;
    Function  GetReValueAdj : Real; Override;
    Procedure SetReValueAdj(Value : Real); Override;
    Function  GetCurrSettled : Real; Override;
    Procedure SetCurrSettled(Value : Real); Override;
    Function  GetSettledVAT : Real; Override;
    Procedure SetSettledVAT(Value : Real); Override;
    Function  GetVATClaimed : Real; Override;
    Procedure SetVATClaimed(Value : Real); Override;
    Function  GetBatchNom : LongInt; Override;
    Procedure SetBatchNom(Value : LongInt); Override;
    Function  GetAutoPost : Boolean; Override;
    Procedure SetAutoPost(Value : Boolean); Override;
    Function  GetManVAT : Boolean; Override;
    Procedure SetManVAT(Value : Boolean); Override;
    Function  GetDelTerms : cuStr3; Override;
    Procedure SetDelTerms(Value : cuStr3); Override;
    Function  GetOpName : cuStr10; Override;
    Procedure SetOpName(Value : cuStr10); Override;
    Function  GetNoLabels : SmallInt; Override;
    Procedure SetNoLabels(Value : SmallInt); Override;
    Function  GetTagged : Boolean; Override;
    Procedure SetTagged(Value : Boolean); Override;
    Function  GetPickRunNo : LongInt; Override;
    Procedure SetPickRunNo(Value : LongInt); Override;
    Function  GetOrdMatch : Boolean; Override;
    Procedure SetOrdMatch(Value : Boolean); Override;
    Function  GetDeliverRef : cuStr10; Override;
    Procedure SetDeliverRef(Value : cuStr10); Override;
    Function  GetVATCRate1 : Real; Override;
    Procedure SetVATCRate1(Value : Real); Override;
    Function  GetVATCRate2 : Real; Override;
    Procedure SetVATCRate2(Value : Real); Override;
    Function  GetOrigRates1 : Real; Override;
    Procedure SetOrigRates1(Value : Real); Override;
    Function  GetOrigRates2 : Real; Override;
    Procedure SetOrigRates2(Value : Real); Override;
    Function  GetPostDiscAm : Double; Override;
    Procedure SetPostDiscAm(Value : Double); Override;
    Function  GetPDiscTaken : Boolean; Override;
    Procedure SetPDiscTaken(Value : Boolean); Override;
    Function  GetCtrlNom : Longint; Override;
    Procedure SetCtrlNom(Value : Longint); Override;
    Function  GetDJobCode : cuStr10; Override;
    Procedure SetDJobCode(Value : cuStr10); Override;
    Function  GetDJobAnal : cuStr10; Override;
    Procedure SetDJobAnal(Value : cuStr10); Override;
    Function  GetTotOrdOS : Real; Override;
    Procedure SetTotOrdOS(Value : Real); Override;
    Function  GetDocUser1 : cuStr30; Override;
    Procedure SetDocUser1(Value : cuStr30); Override;
    Function  GetDocUser2 : cuStr30; Override;
    Procedure SetDocUser2(Value : cuStr30); Override;
    Function  GetDocLSplit (Index : cuLineIndex) : Double; Override;
    Procedure SetDocLSplit(Index : cuLineIndex; Value : Double); Override;
    Function  GetLastLetter : Byte; Override;
    Procedure SetLastLetter(Value : Byte); Override;
    Function  GetUnTagged : Boolean; Override;
    Procedure SetUnTagged(Value : Boolean); Override;
    Function  GetInvLines : TAbsInvoiceLines; Override;

    Function  GetDocUser3 : cuStr30; Override;
    Procedure SetDocUser3(Value : cuStr30); Override;
    Function  GetDocUser4 : cuStr30; Override;
    Procedure SetDocUser4(Value : cuStr30); Override;

    Function  GetTagNo : Byte; Override;
    Procedure SetTagNo(Value : Byte); Override;

    // v5.50 20/02/03 - TAbsInvoice2 descendant of Abstract Transaction Object for new v5.50 Transaction Fields
    Function  GetCISTaxDue : Double; Override;
    Procedure SetCISTaxDue(Value : Double); Override;
    Function  GetCISTaxDeclared : Double; Override;
    Procedure SetCISTaxDeclared(Value : Double); Override;
    Function  GetCISManualTax : Boolean; Override;
    Procedure SetCISManualTax(Value : Boolean); Override;
    Function  GetCISDate : cuLongDate; Override;
    Procedure SetCISDate(Value : cuLongDate); Override;
    Function  GetCISEmployee : cuStr10; Override;
    Procedure SetCISEmployee(Value : cuStr10); Override;
    Function  GetCISTotalGross : Double; Override;
    Procedure SetCISTotalGross(Value : Double); Override;
    Function  GetCISSource : Byte; Override;
    Procedure SetCISSource(Value : Byte); Override;
    Function  GetTotalCostApport : Double; Override;
    Procedure SetTotalCostApport(Value : Double); Override;

    // v5.51 04/06/03 - TAbsInvoice3 descendant of Abstract Transaction Object for new v5.51 Transaction Fields
    Function  GetNOMVATIO : cuNOMVatIOType; Override;
    Procedure SetNOMVATIO(Value : cuNOMVatIOType); Override;

    // v5.51 04/06/03 - TAbsInvoice4 descendant of Abstract Transaction Object for new v5.60 Transaction Fields
    Function  GetTSHExported : Boolean; Override;
    Procedure SetTSHExported(Value : Boolean); Override;

    // v6.00 22/05/07 - Descendant of Abstract Transaction Object for new v6.00 20 character YourRef
    Function  GetYourRef20 : cuStr20; Override;
    Procedure SetYourRef20(Value : cuStr20); Override;

    // v6.3 02/02/10 - Descendant of Abstract Transaction Object for new v6.3 Web Extensions fields
    Function  GetWeekMonth : SmallInt; Override;
    Procedure SetWeekMonth(Value : SmallInt); Override;
    Function  GetWorkflowState : LongInt; Override;
    Procedure SetWorkflowState(Value : LongInt); Override;

    // v6.5 12/10/10 - Descendant of Abstract Transaction Object for new v6.5 Override Location fields
    Function  GetOverrideLocation : cuStr3; Override;
    Procedure SetOverrideLocation(Value : cuStr3); Override;

    // v6.9 30/09/2011 ABSEXCH-11712/ABSEXCH-11719 - TAbsInvoice8
    Function GetUser5 : cuStr30; Override;
    Procedure SetUser5 (Value : cuStr30); Override;
    Function GetUser6 : cuStr30; Override;
    Procedure SetUser6 (Value : cuStr30); Override;
    Function GetUser7 : cuStr30; Override;
    Procedure SetUser7 (Value : cuStr30); Override;
    Function GetUser8 : cuStr30; Override;
    Procedure SetUser8 (Value : cuStr30); Override;
    Function GetUser9 : cuStr30; Override;
    Procedure SetUser9 (Value : cuStr30); Override;
    Function GetUser10 : cuStr30; Override;
    Procedure SetUser10 (Value : cuStr30); Override;

    // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode and Transaction Originator
    Function GetDeliveryPostCode : cuStr20; Override;
    Procedure SetDeliveryPostCode (value : cuStr20); Override;
    Function GetOriginator : cuStr36; Override;
    Procedure SetOriginator (value : cuStr36); Override;
    Function GetCreationTime : cuStr6; Override;
    Procedure SetCreationTime (value : cuStr6); Override;
    Function GetCreationDate : cuStr8; Override;
    Procedure SetCreationDate (value : cuStr8); Override;

    // MH 11/05/2015 Exch205R1 ABSEXCH-16419: Merged customisation changed from v7.0.14
    Function AllowPPD : Boolean;
    Function GetPPDPercentage : Double; Override;
    Procedure SetPPDPercentage (Value : Double); Override;
    Function GetPPDDays : SmallInt; Override;
    Procedure SetPPDDays (Value : SmallInt); Override;
    Function GetPPDGoodsValue : Double; Override;
    Procedure SetPPDGoodsValue (Value : Double); Override;
    Function GetPPDVATValue : Double; Override;
    Procedure SetPPDVATValue (Value : Double); Override;
    Function GetPPDTakenStatus : TInvoicePPDTakenStatus; Override;
    Procedure SetPPDTakenStatus (Value : TInvoicePPDTakenStatus); Override;
    Function GetPPDCreditNote : Boolean; Override;
    Procedure SetPPDCreditNote(Value : Boolean); Override;
    Function GetBatchPayPPDStatus : Byte; Override;
    Procedure SetBatchPayPPDStatus(Value : Byte); Override;

    // TAbsInvoice10 MH 22/09/2014 Order Payments
    Function GetOrderPaymentOrderRef : cuStr10; Override;
    Function GetOrderPaymentElement : cuTransactionOrderPaymentElement; Override;
    Function GetOrderPaymentFlags : Byte; Override;
    Function GetCreditCardType : cuStr4; Override;
    Procedure SetCreditCardType (Value : cuStr4); Override;
    Function GetCreditCardNumber : cuStr4; Override;
    Procedure SetCreditCardNumber (Value : cuStr4); Override;
    Function GetCreditCardExpiry : cuStr4; Override;
    Procedure SetCreditCardExpiry (Value : cuStr4); Override;
    Function GetCreditCardAuthorisationNo : cuStr20; Override;
    Procedure SetCreditCardAuthorisationNo (Value : cuStr20); Override;
    Function GetCreditCardReferenceNo : cuStr70; Override;
    Procedure SetCreditCardReferenceNo (Value : cuStr70); Override;
    Function GetCustomData1 : cuStr30; Override;
    Procedure SetCustomData1 (Value : cuStr30); Override;
    // MH 26/11/2014 ABSEXCH-15836: Added Country Codes
    Function GetDeliveryCountry : cuStr2; Override;
    Procedure SetDeliveryCountry (Value : cuStr2); Override;

    // MH 20/01/2016 Exch2016-R1: Intrastat enhancements - TAbsInvoice12
    Function GetIntrastatOutOfPeriod : Boolean; Override;
    Procedure SetIntrastatOutOfPeriod (Value : Boolean); Override;

    // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
    Function GetUser11 : cuStr30; Override;
    Procedure SetUser11 (Value : cuStr30); Override;
    Function GetUser12 : cuStr30; Override;
    Procedure SetUser12 (Value : cuStr30); Override;

    //RB 22/11/2017 2018-R1 ABSEXCH-19400: GDPR (POST 19347) - 8.3.1.1.1 - DLL + COM Customisation Support
    function GetAnonymised: Boolean; override;
    procedure SetAnonymised(aValue: Boolean); override;
    function GetAnonymisedDate: cuStr8; override;
    procedure SetAnonymisedDate(aValue: cuStr8); override;
    function GetAnonymisedTime: cuStr6; override;
    procedure SetAnonymisedTime(aValue: cuStr6); override;

  Public
    {$IFDEF SOP}
      TransCommitPtr :  Pointer;        {Temp pointer to the commitment update object}
    {$ENDIF}

    Constructor Create(hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const Invoice          : InvRec;
                        Const InvLine          : IDetail);

    Function LinkToCust : Boolean;  Override;

    Property Invoice : InvRec Read DataRec Write DataRec;

    //
    // MH 23/09/2014: IMPORTANT NOTE: This should only be used for hook points which do not change the transaction value
    //
    Procedure ResetTrans (Const Invoice : InvRec);

    //
    // MH 23/09/2014: IMPORTANT NOTE: This should only be used for hook points which do not change the transaction value
    //
    Procedure ResetTransandLines (Const WinId, HandlerId : LongInt;
                                  Const Invoice          : InvRec);
    Procedure SetRecChanged(fRecChanged  :  Boolean);

    {$IFDEF SOP}
      Procedure Create_CommitObject(Remove  :  Boolean);

      procedure Update_LiveCommit(IdR     :  IDetail;
                                  DedMode :  SmallInt);
    {$ENDIF}

    // HM 20/02/03: Added for EL - see notes with function before using
    Function ChangeCurrentLine (Const InvLine : IDetail) : Boolean;

    //PR: 23/11/2017 ABSEXCH-19451 True if we can only edit GDPR fields
    property RestrictedEdit : Boolean read FRestrictedEdit;
  End; { TInvoice }


implementation

Uses
  VarRec2U,
  BtrvU2,
  CustWinU,
  EtStrU,
  BtSupU1,

  {$IFDEF PF_On}
    InvLst2U,
  {$ENDIF}
  OCust,

  {$IFDEF SOP}
    {$IFDEF POST}
      PostingU,
    {$ENDIF}

    // MH 23/09/2014 Order Payments: Lock down edit ability for transactions with non-zero net payments
    OrdPayCustomisation,
  {$ENDIF}

  // MH 27/03/2015 v7.0.14 ABSEXCH-16284: Added new Prompt Payment Discount fields
  PromptPaymentDiscountFuncs,
  // MH 26/11/2014 ABSEXCH-15836: Added Country Codes
  CountryCodes, CountryCodeUtils,

  BtKeys1U,
  ComnU2,
  SysU2,
  MiscU;

Const
  InvErrStr = 'Transaction ';
  InvLineErrStr = 'Transaction Line ';

  idxUserDef5  = 94;
  idxUserDef6  = 95;
  idxUserDef7  = 96;
  idxUserDef8  = 97;
  idxUserDef9  = 98;
  idxUserDef10 = 99;

  idxDeliveryPostCode = 100;
  idxOriginator = 101;
  idxCreationTime = 102;
  idxCreationDate = 103;

  // MH 27/03/2015 v7.0.14: Added new fields for Prompt Payment Discounts
  IdxPPDPercentage  = 104;
  IdxPPDDays        = 105;
  IdxPPDGoodsValue  = 106;
  IdxPPDVATValue    = 107;
  IdxPPDTakenStatus = 108;

  idxOrderPaymentOrderRef = 111;
  idxOrderPaymentElement = 112;
  idxOrderPaymentFlags = 113;
  idxCreditCardType = 114;
  idxCreditCardNumber = 115;
  idxCreditCardExpiry = 116;
  idxCreditCardAuthorisationNo = 117;
  idxCreditCardReferenceNo = 118;
  idxCustomData1 = 119;

  idxDeliveryCountry = 120;

  // MH 20/01/2016 Exch2016-R1: Intrastat enhancements - TAbsInvoice12
  idxIntrastatOutOfPeriod = 121;

  // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
  idxUserDef11 = 122;
  idxUserDef12 = 123;

  //RB 22/11/2017 2018-R1 ABSEXCH-19400: GDPR (POST 19347) - 8.3.1.1.1 - DLL + COM Customisation Support
  idxTransAnonymised = 124;
  idxAnonymisedDate = 125;
  idxAnonymisedTime = 126;
//=========================================================================

Constructor TInvoiceLines.Create(      hEntSys : TEnterpriseSystem;
                                 Const Parent  : TInvoice);
Begin
  Inherited Create;

  EntSys := HEntSys;

  DelLine := Nil;
  ParentInv := Parent;
  CurrentLine := Nil;
  InvLines := TList.Create;
End;

Destructor TInvoiceLines.Destroy;
Begin
  If Assigned (DelLine) Then
    DelLine.Free;

  // HM 21/11/02: Moved removal of lines to separate procedure
  ClearLines;
  InvLines.Free;

  Inherited Destroy;
End;

// HM 21/11/02: Moved removal of lines to separate procedure so Assign could call it
Procedure TInvoiceLines.ClearLines;
Var
  InvLine : TInvLine;
Begin { ClearLines }
  While (InvLines.Count > 0) Do Begin
    { Get Detail Line object }
    InvLine := TInvLine(InvLines.Items[0]);

    { Free Object }
    If (CurrentLine = InvLine) Then CurrentLine := Nil;
    InvLine.Free;

    { Free Line }
    InvLines.Delete (0);
  End; { While }

  // Destroy CurrentLine if still set as it is a standalone line object that was not in the list
  //PR 15/04/2008 Change so that CurrentLine is set to nil to solve problem of crashing in posting run when using VatPeriod plugin.
  If Assigned (CurrentLine) Then
    FreeAndNil(CurrentLine);
//    CurrentLine.Free;
End; { ClearLines }

// MH 23/09/2014 Order Payments: Added limited edit mode for order payment transactions
// MH 16/06/2015 Exch-R1 ABSEXCH-16534: Implemented modified SOR editing rules within Customisation
Procedure TInvoiceLines.Assign (Const WinId, HandlerId  : LongInt;
                                Const InvLine           : IDetail;
                                Const CheckForPayments  : Boolean = True);
Const
  FNum    = IDetailF;
  KeyPath = IDFolioK;
Var
  NewLine, TmpLine     : TInvLine;
  TmpKPath             : Integer;
  I, TmpStat           : SmallInt;
  TmpRecIdAddr         : LongInt;
  KeyR, KeyS           : Str255;
  // MH 16/06/2015 Exch-R1 ABSEXCH-16534: Implemented modified SOR editing rules within Customisation
  OrdPayLimitedEdit    : Boolean;
Begin
  { Set Security Access to Record }
  LineAccess := ParentInv.AccessRights;

  If (LineAccess <> NotAvailable) Then Begin
    // HM 21/11/02: Remove any pre-existing lines
    ClearLines;

    { Load lines in for Invoice from IDetailF }
    TmpLine := Nil;
    With EntSys.LocalBtr^ Do Begin
      { Save position }
      LastId := LId;
      TmpKPath:=GetPosKey;
      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecIdAddr,BOff,BOff);

      KeyS := FullNomKey(ParentInv.thFolioNum);
      KeyR := KeyS;

      TmpStat := LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);
      While (TmpStat = 0) And CheckKey(KeyR, KeyS, Length(KeyR), BOn) Do Begin
        (* HM 04/09/98: Modified to fix editing lines }
        { Got a line - add to lines object }
        LGetRecAddr(FNum);
        NewLine := TInvLine.Create(EntSys, WinId, HandlerId, ParentInv, LId, 0, LastRecAddr[FNum]);
        InvLines.Add(NewLine);

        { Check to see if it is the current line }
        If (InvLine.FolioRef = LId.FolioRef) And (LId.ABSLineNo = InvLine.ABSLineNo) Then Begin
          { Loading current line }
          TmpLine := NewLine;
        End; { If }
        *)

        // MH 16/06/2015 Exch-R1 ABSEXCH-16534: Implemented modified SOR editing rules within Customisation
        {$IFDEF SOP}
        If CheckForPayments Then
          // Check for payments against the line to determine whether we can edit it
          OrdPayLimitedEdit := OrderPaymentsCustomisationTransactionTracker(ParentInv.Invoice).cttLineHasPayments[LId.AbsLineNo]
        Else
          // Called from tight loops, e.g. Batch Payments Filters, set limited edit as the hook point should be read-only anyway
          OrdPayLimitedEdit := True;
        {$ELSE}
          OrdPayLimitedEdit := False;
        {$ENDIF SOP}

        { Got a line - add to lines object }
        LGetRecAddr(FNum);

        { Check to see if it is the current line }
        If (InvLine.FolioRef = LId.FolioRef) And (LId.ABSLineNo = InvLine.ABSLineNo) Then Begin
          { It is the currently editing line - add current line instead of stored line }
          NewLine := TInvLine.Create(EntSys, WinId, HandlerId, ParentInv, InvLine, 0, LastRecAddr[FNum], OrdPayLimitedEdit);
          TmpLine := NewLine;
        End { If }
        Else Begin
          { Not the current line - add the stored db line }
          NewLine := TInvLine.Create(EntSys, WinId, HandlerId, ParentInv, LId, 0, LastRecAddr[FNum], OrdPayLimitedEdit);
        End; { Else }
        InvLines.Add(NewLine);

        TmpStat := LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
      End; { While }

      {* Restore Line position *}
      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecIdAddr,BOn,BOff);
      LId := LastId;
    End; { With }

    { Look for InvLine in InvLines for Current Line }
    If Assigned(TmpLine) Then Begin
      { Already in lines }
      CurrentLine := TmpLine;
    End { If }
    Else
      { Not in lines - create new }
      If (InvLine.FolioRef = ParentInv.thFolioNum) Then
        // MH 16/06/2015 Exch-R1 ABSEXCH-16534: Implemented modified SOR editing rules within Customisation
        CurrentLine := TInvLine.Create(EntSys, WinId, HandlerId, ParentInv, InvLine, 1, 0, False {New Line - allow edit});

    { Disable additional functions }
    For I := Low(FuncAccess) To High(FuncAccess) Do
      FuncAccess[I] := pfDisabled;

    { Modify default for specific cases }
    Case ((WinId * 1000) + HandlerId) Of
      102000001   { Transaction - Before Save }
           :   Begin
                 FuncAccess[1] := pfEnabled; { Add }
               End;
    End; { Case }
  End; { If }
End;

//-------------------------------------------------------------------------

// HM 20/02/03: Added to allow EL to change the current line without calling
// Assign which reloads the thLines array.  This is for performance and can
// only be used when the pressent current line is also in the thLines array
// (i.e. its not being added at the time).  Returns TRUE if the line was
// changed, FALSE if the line didn't exist, or was for the wrong trans, or
// if the system is currently adding a line (see notes above).
Function TInvoiceLines.ChangeCurrentLine (Const InvLine : IDetail) : Boolean;
Var
  ArrLine, NewCurrentLine : TInvLine;
  GotCurrentLine          : Boolean;
  I                       : SmallInt;
Begin { ChangeCurrentLine }
  Result := False;

  // Check we can access the lines and that there are lines to access
  If (LineAccess <> NotAvailable) And (InvLines.Count > 0) Then Begin
    // Used to store the requested line once found in the array
    NewCurrentLine := NIL;
    // used to record whether we have found the existing current line in the array
    GotCurrentLine := False;

    // Run through the lines to find the line we want to change and to check
    // that the thCurrentLine can be replaced without causing a memory leak
    For I := 0 To Pred(InvLines.Count) Do Begin
      // Extract a line object from the list
      ArrLine := TInvLine(InvLines[I]);

      If (Not GotCurrentLine) Then
        // Check whether the extracted line is the thCurrentLine
        GotCurrentLine := (ArrLine = CurrentLine);

      If (Not Assigned(NewcurrentLine)) Then
        // Check whether the extracted line is the line we want to change the
        // thCurrentLine to
        If (ArrLine.tlFolio = InvLine.FolioRef) And (ArrLine.tlLineNo = InvLine.ABSLineNo) Then
          NewCurrentLine := ArrLine;

      // If we have found the current thCurrentLine in the array and we have
      // found the line we want to change it to then we can do the switch and
      // exit the loop.
      If Assigned(NewcurrentLine) And GotCurrentLine Then Begin
        CurrentLine := NewCurrentLine;
        Result := True;
        Break;
      End; { If Assigned(NewcurrentLine) And Assigned(CurrentCurrentLine) }
    End; { For I }
  End; { If (LineAccess <> NotAvailable) And (InvLines.Count > 0) }
End; { ChangeCurrentLine }

//-------------------------------------------------------------------------

Function TInvoiceLines.GetLineCount : SmallInt;
Begin
  If (LineAccess <> NotAvailable) Then
    Result := InvLines.Count
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'LineCount');
  End; { Else }
End;

Function TInvoiceLines.GetInvLine(Index : SmallInt) : TAbsInvLine;
Begin
  Result := Nil;

  If (Index > 0) And (Index <= InvLines.Count) And (LineAccess <> NotAvailable) Then
    Result := TAbsInvLine(InvLines[Pred(Index)])
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'InvLine(' + IntToStr(Index) + ')');
End;

Function TInvoiceLines.GetCurrentLine : TAbsInvLine;
Begin
  If (LineAccess <> NotAvailable) Then
    Result := CurrentLine
  Else Begin
    Result := Nil;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Current Line');
  End; { If }
End;

Procedure TInvoiceLines.Replicate(Const ReplItem : SmallInt);
Var
  InvLine : TInvLine;
  I       : Byte;
Begin
  If Assigned (CurrentLine) Then CurrentLine.Replicate(ReplItem);

  If (InvLines.Count > 0) Then
    For I := 0 To Pred(InvLines.Count) Do
      { Get Detail Line object }
      TInvLine(InvLines.Items[I]).Replicate(ReplItem);
End;


{ Called by line objects to destroy themselves }
Procedure TInvoiceLines.DeleteLine(Const TheLine : TAbsInvLine);
Var
  I, Idx : Integer;
Begin
  If (InvLines.Count > 0) Then Begin
    Idx := -1;

    { Find line in list }
    For I := 0 To Pred(InvLines.Count) Do Begin
      If (InvLines[I] = TheLine) Then Begin
        Idx := I;
        Break;
      End; { If }
    End; { For }

    { Destroy if found }
    If (Idx > -1) Then Begin
      If Assigned(DelLine) Then
        DelLine.Destroy;

      { Store in temporary local var - destroy later }
      DelLine := InvLines[Idx];

      { Got Line object - delete it}
      InvLines.Delete(Idx);
    End; { If }
  End; { If }
End;


{ Called by line objects to destroy themselves }
Procedure TInvoiceLines.AddNewLine;
Var
  InvLine : IDetail;
  KeyS : Str255;
  Res : SmallInt;
Begin
// HM 05/03/02: Prevent use of AddNewLine for ADJ, NOM, TSH until code is
// (500CHK)     reviewed for accuracy
{If (DocTypes(ParentInv.thInvDocHed) In [ADJ, NMT, PPY, SRC, TSH, WOR]) Then
  Raise Exception.Create ('AddNewLine Method not available for this transaction type');}

  If (FuncAccess[1] = pfEnabled) Then Begin
    // HM 13/11/00: Check that OurRef/Folio have been allocated
    EntSys.CheckTransRef;

    Blank (InvLine, SizeOf(InvLine));
    With InvLine Do Begin
      FolioRef  := ParentInv.thFolioNum;
      DocPRef   := ParentInv.thOurRef;
      IDDocHed  := DocTypes(ParentInv.thInvDocHed);
      ABSLineNo := TInvoice(ParentInv).Invoice.ILineCount;

      //PR 24/10/02 LineNos  for adj, nom and payment lines are set to RecieptCode constant
      if not (IDDocHed in [ADJ, NMT, PPY, SRC]) then
        LineNo := ABSLineNo
      else
        LineNo := RecieptCode;


      {$IFDEF STK}
        //PR 24/10/02 Noms, timesheets & payments lines linetype isn't set
        if Not (IDDocHed in [NMT, TSH, PPY, SRC]) then
          LineType := StkLineType[IdDocHed];
      {$ENDIF}

      //PR 24/10/02 WOR lines treated the same as adj lines here
      If (Not (IdDocHed In StkAdjSplit + [WOR])) then
      Begin
        Qty:=1;

        {$IFNDEF STK}
          QtyMul:=1;
        {$ENDIF}
      End { If }
      Else Begin
        PostedRun:=StkAdjRunNo;
        NomMode:=StkAdjNomMode;
        QtyMul:=1;
        QtyPack:=QtyMul;
      End; { Else }

      Currency := ParentInv.thCurrency;
      CXRate[False] := ParentInv.thCompanyRate;
      CXrate[True]  := ParentInv.thDailyRate;
      PYr      := ParentInv.thYear;
      PPr      := ParentInv.thPeriod;

      //PR 25/10/02
      If not (DocTypes(ParentInv.thInvDocHed) In [ADJ, NMT, PPY, SRC, WOR]) then
        Payment  := DocPayType[IdDocHed]
      else
        Payment  := SetRPayment(ParentInv.DataRec.InvDocHed);

      If (Syss.AutoClearPay) then
        Reconcile := ReconC;

      //PR 24/10/02 - Not all transactions have customers
      if not (IDDocHed in [ADJ, NMT, WOR, TSH]) then
      begin
        CustCode := ParentInv.thAcCode;

        if IDDocHed in [SRC, PPY] then
          VATCode := ' '
        else
        If (EntSys.Customer.AccessRights <> NotAvailable) Then Begin
            VATCode := EntSys.Customer.acVATCode;
            NomCode := EntSys.Customer.acSalesGL;
            MLocStk := EntSys.Customer.acLocation;
        End; { If }
      end
      else //PR 24/10/02 Mlocstk for WOR
      begin
        if IDDocHed in [WOR] then
          MLocStk := ParentInv.GetDelTerms;

        VATCode := ' ';
      end;

      //PR: 24/10/02 WOR PDate should also be set to DueDate
      If (IdDocHed In OrderSet+[WOR]) or ((Syss.QUAllocFlg) and (IdDocHed In QuotesSet)) then
        PDate:=ParentInv.thDueDate
      else
        PDate:=ParentInv.thTransDate;

      {$IFDEF PF_On}
      //PR 24/10/02 - Not all transactions have accounts
      if not (IDDocHed in [ADJ, NMT, WOR]) then
      begin
        If (EntSys.Customer.AccessRights <> NotAvailable) Then Begin
          CCDep[BOn]  := EntSys.Customer.acCostCentre;
          CCDep[BOff] := EntSys.Customer.acDepartment;
        End; { If }
      end;

        If (JBCostOn) Then Begin
          JobCode  := ParentInv.thJobCode;
          AnalCode := ParentInv.thJobAnal;

          {.$IFNDEF JC}
            If (IdDocHed In PurchSplit-[PPY]) then {* Set Nominal Code *}
              NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);
          {.$ENDIF}
        End; { If }
      {$ENDIF}

      // MH 13/10/2010: Added support for Override Location
      If Syss.EnableOverrideLocations And (IdDocHed In PurchSplit) And (Trim(ParentInv.thOverrideLocation) <> '') Then
        MLocStk := ParentInv.thOverrideLocation;

      If (IDDocHed In ChequeSet) and (Syss.AutoCQNo) then
        Desc:=Get_NextChequeNo(BOff);

      if IDDocHed in [TSH] then
      begin
        KeyS := JBRCode+JBECode + Strip('R',[#0],FullEmpCode(ParentInv.DataRec.BatchLink));
        Res :=  EntSys.LocalBtr^.LFind_Rec(B_GetEq, JMiscF,0, KeyS);
        if Res = 0 then
          CCDep := EntSys.LocalBtr^.LJobMisc.EmplRec.CCDep;
      end;

    End; { With }

    CurrentLine := TInvLine.Create(EntSys,
                                   EntSys.WinId,
                                   EntSys.HandlerId,
                                   ParentInv,
                                   InvLine,
                                   2,
                                   0,
                                   False);   // Adding lines is suppressed when edits are limited
  End; { If }
End;


{-----------------------------------------------------------------------------}

Constructor TInvoice.Create(hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  { Take local copy of handle to TEnterpriseSystem object }
  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  OrigRec := DataRec;

  {$IFDEF SOP}
    TransCommitPtr:=nil;
  {$ENDIF}


  RecAccess  := NotAvailable;
  RecChanged := False;
  InvLines := TInvoiceLines.Create(EntSys, Self);

  FRestrictedEdit := False;
End;

Destructor TInvoice.Destroy;
Begin
  InvLines.Free;

  {$IFDEF SOP}
     Create_CommitObject(BOn);
  {$ENDIF}

  Inherited Destroy;
End;

Procedure TInvoice.Assign (Const WinId, HandlerId : LongInt;
                           Const Invoice          : InvRec;
                           Const InvLine          : IDetail);
Const
  ReadOnlySet = [1, 3..5, 10,16..18,23,24,26,27,33,36,39..43,46,48..51,59..67,71,74,76,82..86];
Var
  I : SmallInt;

Begin
  { Set Security Access to Record }

  Case WinId of
    EnterpriseBase+1000,
    EnterpriseBase+2000,
    EnterpriseBase+2050,
    EnterpriseBase+3000,
    EnterpriseBase+3100,               { Stock Record - Stock Batch Entry }
    EnterpriseBase+4000,
    EnterpriseBase+5000,                { Job Record }
    EnterpriseBase+MiscBase+1
         :  RecAccess:=ReadOnly;

    else    RecAccess:=NotAvailable;

  End; { If }

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  RecChanged := False;

  If (RecAccess <> NotAvailable) Then Begin
    DataRec := Invoice;
    { Load lines into InvLines }
    InvLines.Assign(WinId, HandlerId, InvLine);
  End; { If }
  OrigRec := DataRec;

  //PR: 27/11/2017 ABSEXCH-19451
  FRestrictedEdit := RestrictedEditOnly(Invoice);


  { Adjust Security Access for field by Window and Event }
  If (RecAccess <> NotAvailable) Then Begin
    { Set Default Security options }
    For I := Low(PropAccess) To High(PropAccess) Do
      If (RecAccess = ReadOnly) Or (I In ReadOnlySet) Then
        PropAccess[I] := paReadOnly
      Else
        PropAccess[I] := paReadWrite;

    { Disable additional functions }
      For I := Low(FuncAccess) To High(FuncAccess) Do
        FuncAccess[I] := pfDisabled;

      { Modify default for specific cases }
    Case ((WinId * 1000) + HandlerId) Of

      102000003  { Transaction - LinkToCust}
           :   Begin
                 FuncAccess[1] := pfEnabled; { Link To Cust }
               End;

      102000001
           :   Begin { Before Save Transaction }
                 PropAccess[07] := paReadWrite; { Period}
                 PropAccess[08] := paReadWrite; { Year }
                 PropAccess[09] := paReadWrite; { DueDate }
                 PropAccess[35] := paReadWrite; { Hold Flg }
                 PropAccess[15] := paReadWrite; { YourRef }
                 PropAccess[44] := paReadWrite; { LYourRef }
                 PropAccess[57] := paReadWrite; { No Labels }
                 PropAccess[72] := paReadWrite; { User Def 1 }
                 PropAccess[73] := paReadWrite; { User Def 2 }
                 PropAccess[78] := paReadWrite; { User Def 3 }
                 PropAccess[79] := paReadWrite; { User Def 4 }
                 PropAccess[80] := paReadWrite; { Tag No}

                 //New fields for 6.9
                 PropAccess[idxUserDef5] := paReadWrite;
                 PropAccess[idxUserDef6] := paReadWrite;
                 PropAccess[idxUserDef7] := paReadWrite;
                 PropAccess[idxUserDef8] := paReadWrite;
                 PropAccess[idxUserDef9] := paReadWrite;
                 PropAccess[idxUserDef10] := paReadWrite;
                 // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
                 PropAccess[idxUserDef11] := paReadWrite;
                 PropAccess[idxUserDef12] := paReadWrite;
//PropAccess[93] := paReadWrite; { Override Location }

                 // MH 27/03/2015 v7.0.14 ABSEXCH-16284: Added new Prompt Payment Discount fields
                 PropAccess[IdxPPDPercentage] := paReadWrite; // thPPDPercentage - Discount Percentage - Note: 0.1 = 10%
                 PropAccess[IdxPPDDays] := paReadWrite; // thPPDDays - Number of days discount offer is valid for
                 PropAccess[IdxPPDTakenStatus] := paReadWrite; // thPPDTaken - TRUE if the Prompt Payment Discount was given

                 // MH 22/09/2014 v7.1 Order Payments fields
                 PropAccess[idxCreditCardType] := paReadWrite;
                 PropAccess[idxCreditCardNumber] := paReadWrite;
                 PropAccess[idxCreditCardExpiry] := paReadWrite;
                 PropAccess[idxCreditCardAuthorisationNo] := paReadWrite;
                 PropAccess[idxCreditCardReferenceNo] := paReadWrite;
                 PropAccess[idxCustomData1] := paReadWrite;
               End;

      102000006   { Transaction - After account code entered}
           :   Begin
                 PropAccess[02] := paReadWrite; {Header account code}

                 {PropAccess[69] := paReadWrite; {Job Code}{v5.61 Not coded as this hook called from text exit so not easy to tag on other data}
                 {PropAccess[70] := paReadWrite; {Anal Code}

                 FuncAccess[1] := pfEnabled; { Link To Cust }
               End;
      102000007   { Transaction - Before Exchage Rate entered}
           :   Begin
                 PropAccess[14] := paReadWrite; {Header Daily Rate}

                 FuncAccess[1] := pfEnabled; { Link To Cust }
               End;

      102000009   { Transaction - After account code entered + Validated}
           :   Begin
                 PropAccess[38] := paReadWrite; {Header Delivery Address}

                 // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode and Transaction Originator
                 PropAccess[idxDeliveryPostCode] := paReadWrite; // Header Delivery Address PostCode

                 // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
                 PropAccess[idxDeliveryCountry] := paReadWrite; // Header Delivery Address Country

                 PropAccess[69] := paReadWrite; {Job Code}
               End;

      //PR: 03/06/2013 ABSEXCH-14318 Added cust buttons 3-6 for Sales, Purch, Adj, Wor.
      102000031, 102000032, 102000441..102000444,  { Edit Sales Transaction - Custom buttons 1 - 6 }
      102000038, 102000039, 102000451..102000454,  { Edit Stk Adjust transactions - Custom buttons 1 - 6}
      102000041, 102000042, 102000445..102000448,  { Edit Purch Transaction - Custom buttons 1 - 6 }
      102000043, 102000044, 102000455..102000458,  { Edit WOR Transaction - Custom buttons 1 & 2 }
      102000182                                    {Back to back creation}
           :   Begin
                 PropAccess[38] := paReadWrite; {Header Delivery Address}
                 PropAccess[72] := paReadWrite; { User Def 1 }
                 PropAccess[73] := paReadWrite; { User Def 2 }
                 PropAccess[78] := paReadWrite; { User Def 3 }
                 PropAccess[79] := paReadWrite; { User Def 4 }

                 //New UDFs for v6.9
                 PropAccess[idxUserDef5] := paReadWrite;
                 PropAccess[idxUserDef6] := paReadWrite;
                 PropAccess[idxUserDef7] := paReadWrite;
                 PropAccess[idxUserDef8] := paReadWrite;
                 PropAccess[idxUserDef9] := paReadWrite;
                 PropAccess[idxUserDef10] := paReadWrite;
                 // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
                 PropAccess[idxUserDef11] := paReadWrite;
                 PropAccess[idxUserDef12] := paReadWrite;

                 // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode and Transaction Originator
                 PropAccess[idxDeliveryPostCode] := paReadWrite; // Header Delivery Address PostCode

                 // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
                 PropAccess[idxDeliveryCountry] := paReadWrite; // Header Delivery Address Country
               end;


      {102000007  See below...}


      102000050   { After Due Date entered }
           :   Begin
                 PropAccess[09]:=paReadWrite;
               end;

      102000061   { UD1 Validation}
           :   Begin
                 PropAccess[72]:=paReadWrite;
               end;

      102000062   { UD2 Validation}
           :   Begin
                 PropAccess[73]:=paReadWrite;
               end;

      102000063   { UD3 Validation}
           :   Begin
                 PropAccess[78]:=paReadWrite;
               end;

      102000064   { UD4 Validation}
           :   Begin
                 PropAccess[79]:=paReadWrite;
               end;
      //GS 14/10/2011 ABSEXCH-11706: set the access rights of the 6 new UDFs
      102000211   { UD5 Validation}
           :   Begin
                 PropAccess[idxUserDef5]:=paReadWrite;
               end;

      102000212   { UD6 Validation}
           :   Begin
                 PropAccess[idxUserDef6]:=paReadWrite;
               end;

      102000213   { UD7 Validation}
           :   Begin
                 PropAccess[idxUserDef7]:=paReadWrite;
               end;

      102000214   { UD8 Validation}
           :   Begin
                 PropAccess[idxUserDef8]:=paReadWrite;
               end;
      102000215   { UD9 Validation}
           :   Begin
                 PropAccess[idxUserDef9]:=paReadWrite;
               end;

      102000216   { UD10 Validation}
           :   Begin
                 PropAccess[idxUserDef10]:=paReadWrite;
               end;

      // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
      102000217   { UD11 Validation}
           :   Begin
                 PropAccess[idxUserDef11] := paReadWrite;
               end;
      102000218   { UD12 Validation}
           :   Begin
                 PropAccess[idxUserDef12] := paReadWrite;
               end;

      102000065   { Before Your Ref is entered }
           :   Begin
                 PropAccess[15]:=paReadWrite;
               end;


      102000066   { Before Alt Ref is entered }
           :   Begin
                 PropAccess[44]:=paReadWrite;
               end;

      102000008,
      102000080   { Override auto period calcualtion }
           :   Begin
                 PropAccess[7]:=paReadWrite;
                 PropAccess[8]:=paReadWrite;
               end;

      102000081   { Override auto date from period calcualtion }
           :   Begin
                 PropAccess[11]:=paReadWrite;
               end;

      102000109
           :   Begin { During conversion of ?DN to ?IN. Allows due date to be set }
                 PropAccess[09] := paReadWrite; { DueDate }

               End;
      102000180   { Before Your Ref is entered }
           :   Begin
                 PropAccess[15]:=paReadWrite;
               end;

      102000181   { Before Long Your Ref is entered }
           :   Begin
                 PropAccess[44]:=paReadWrite;
               end;

      102000190   { Transaction - After account code entered + Validated}
           :   Begin
                 PropAccess[70] := paReadWrite; {Anal Code}
               End;
      102000191   { Transaction - During conversion of ?OR to ?DN, allow VAT to be overridden}
           :   Begin
                 PropAccess[19] := paReadWrite; {VAT Ary}
                 PropAccess[54] := paReadWrite; {Manual VAT Flg}

               End;

      190001001
           : ;

    End; { Case }
  End; { If }
End;

Function TInvoice.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

Function TInvoice.GetRecChanged : Boolean;
Begin
  { MH 02:03/98: Was GPF'ing saving an order because current line wasn't set }
  If Assigned(thLines.thCurrentLine) Then
    Result := RecChanged or thLines.thCurrentLine.DataChanged
  Else
    Result := RecChanged;
End;

Function TInvoice.GetRunNo : Longint;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RunNo
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'RunNo');
  End; { Else }
End;

Procedure TInvoice.SetRunNo(Value : Longint);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
    If (DataRec.RunNo <> Value) Then Begin
      If (Value = 0) Then Begin
        DataRec.RunNo := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'RunNo');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'RunNo');
End;

Function TInvoice.GetCustCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CustCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'Account Code');
  End; { Else }
End;

Procedure TInvoice.SetCustCode(Value : cuStr10);
Var
  TmpStr   : ShortString;
  AllowSet : cuCharSet;
  Valid    : Boolean;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CustKeyLen);
    If (DataRec.CustCode <> TmpStr) Then Begin
      { Validate - must be set, unless NMT, ADJ, TSH or SBT }
      Valid := ((Trim(TmpStr) <> '') And (Not (DataRec.InvDocHed In [ADJ,NMT,SBT,TSH]))) Or
               ((Trim(TmpStr) = '')  And (DataRec.InvDocHed In [ADJ,NMT,SBT,TSH]));

      If Valid And (Trim(TmpStr) <> '') Then
        { Check code is valid }
        // CJS 2014-07-21 - ABSEXCH-15281 - added Works Orders to list of valid transactions
        AllowSet := [TradeCode[(DataRec.InvDocHed In SalesSplit+StkRetSalesSplit+WOPSplit)]];
        Valid := EntSys.CustExists2(TmpStr, AllowSet);

      If Valid Then Begin
        DataRec.CustCode := TmpStr;
        If (TradeCode[False] In AllowSet) Then DataRec.CustSupp := TradeCode[False];
        If (TradeCode[True] In AllowSet) Then DataRec.CustSupp := TradeCode[True];
        RecChanged := True;

        { Also set into all invoice line objects }
        InvLines.Replicate(1);
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'Account Code');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'Account Code');
End;

Function TInvoice.GetNomAuto : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NomAuto
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'NomAuto');
  End; { Else }
End;

Procedure TInvoice.SetNomAuto(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin
    If (DataRec.NomAuto <> Value) Then Begin
      DataRec.NomAuto := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'NomAuto');
End;

Function TInvoice.GetOurRef : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OurRef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'OurRef');
  End; { Else }
End;

Procedure TInvoice.SetOurRef(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[4] = paReadWrite) Then Begin
    If (DataRec.OurRef <> Value) Then Begin
      DataRec.OurRef := Value;
      RecChanged := True;

      InvLines.Replicate(6);
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'OurRef');
End;

Function TInvoice.GetFolioNum : Longint;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.FolioNum
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'FolioNum');
  End; { Else }
End;

Procedure TInvoice.SetFolioNum(Value : Longint);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[5] = paReadWrite) Then Begin
    If (DataRec.FolioNum <> Value) Then Begin
      DataRec.FolioNum := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'FolioNum');
End;

Function TInvoice.GetCurrency : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Currency
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'Currency');
  End; { Else }
End;

Procedure TInvoice.SetCurrency(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[6] = paReadWrite) Then Begin
    If (DataRec.Currency <> Value) Then Begin
      If EntSys.ValidCcy (Value) Or ((Value = 0) And (DataRec.InvDocHed In [ADJ,NMT,SBT,TSH])) Then Begin
        DataRec.Currency := Value;
        RecChanged := True;

        If Not (DataRec.InvDocHed In [ADJ, NMT]) Then
          InvLines.Replicate(2);
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'Currency');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'Currency');
End;

Function TInvoice.GetAcYr : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AcYr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'AcYr');
  End; { Else }
End;

Procedure TInvoice.SetAcYr(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[7] = paReadWrite) Then Begin
    If (DataRec.AcYr <> Value) Then Begin
      If EntSys.ValidYear(Value) Then Begin
        DataRec.AcYr := Value;
        RecChanged := True;

        InvLines.Replicate(3);
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'AcYr');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'AcYr');
End;

Function TInvoice.GetAcPr : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AcPr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'AcPr');
  End; { Else }
End;

Procedure TInvoice.SetAcPr(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[8] = paReadWrite) Then Begin
    If (DataRec.AcPr <> Value) Then Begin
      If EntSys.ValidPeriod(Value) Then Begin
        DataRec.AcPr := Value;
        RecChanged := True;

        InvLines.Replicate(4);
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'AcPr');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'AcPr');
End;

Function TInvoice.GetDueDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DueDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DueDate');
  End; { Else }
End;

Procedure TInvoice.SetDueDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[9] = paReadWrite) Then Begin
    If (DataRec.DueDate <> Value) Then Begin
      If EntSys.ValidDate(Value) Then Begin
        DataRec.DueDate := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'DueDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DueDate');
End;

Function TInvoice.GetVATPostDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VATPostDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'VATPostDate');
  End; { Else }
End;

Procedure TInvoice.SetVATPostDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then Begin
    If (DataRec.VATPostDate <> Value) Then Begin
      If EntSys.ValidDate(Value) Then Begin
        DataRec.VATPostDate := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'VATPostDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'VATPostDate');
End;

Function TInvoice.GetTransDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TransDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TransDate');
  End; { Else }
End;

Procedure TInvoice.SetTransDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite) Then Begin
    If (DataRec.TransDate <> Value) Then Begin
      If EntSys.ValidDate(Value) Then Begin
        DataRec.TransDate := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'TransDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TransDate');
End;

Function TInvoice.GetCustSupp : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CustSupp
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CustSupp');
  End; { Else }
End;

Function TInvoice.GetCXrate1 : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CXrate[False]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CompanyRate');
  End; { Else }
End;

Procedure TInvoice.SetCXrate1(Value : Real);
Var
  Valid : Boolean;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[13] = paReadWrite) Then Begin
    If (DataRec.CXrate[False] <> Value) Then Begin
      Valid := True;

      If (Not (Syss.TotalConv<>XDayCode)) or (DataRec.InvDocHed In NomSplit) Then
        Valid := (Value <> 0.0);

      If Not (DataRec.InvDocHed In NomSplit) Then
        Value := 0.0;

      If Valid Then Begin
        DataRec.CXrate[False] := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'CompanyRate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'CompanyRate');
End;

Function TInvoice.GetCXrate2 : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CXrate[True]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DailyRate');
  End; { Else }
End;

Procedure TInvoice.SetCXrate2(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[14] = paReadWrite) Then Begin
    If (DataRec.CXrate[True] <> Value) Then Begin
      If (Value <> 0.0) Then Begin
        DataRec.CXrate[True] := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'DailyRate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DailyRate');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetYourRef : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.YourRef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'YourRef');
  End; { Else }
End;
Procedure TInvoice.SetYourRef(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then Begin
    If (DataRec.YourRef <> Value) Then Begin
      // MH 24/05/07: Modified padding on EL's instruction
      If (DataRec.InvDocHed In [SIN,SCR,SJI,SJC,SRF,SRI,SQU,SOR,SDN,SBT,SRN,PIN,PCR,PJI,PJC,PRF,PPI,PQU,POR,PDN,PBT,PRN]) Then
        // Pad to 20 chars
        DataRec.YourRef := LJVar(Value, SizeOf(DataRec.YourRef) - 1)
      Else
        DataRec.YourRef := Value;

      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'YourRef');
End;

//------------------------------

Function  TInvoice.GetYourRef20 : cuStr20;
Begin // GetYourRef20
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.YourRef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'YourRef20');
  End; { Else }
End; // GetYourRef20
Procedure TInvoice.SetYourRef20(Value : cuStr20);
Begin // SetYourRef20
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then Begin
    If (DataRec.YourRef <> Value) Then Begin
      // MH 24/05/07: Modified padding on EL's instruction
      If (DataRec.InvDocHed In [SIN,SCR,SJI,SJC,SRF,SRI,SQU,SOR,SDN,SBT,SRN,PIN,PCR,PJI,PJC,PRF,PPI,PQU,POR,PDN,PBT,PRN]) Then
        // Pad to 20 chars
        DataRec.YourRef := LJVar(Value, SizeOf(DataRec.YourRef) - 1)
      Else
        DataRec.YourRef := Value;

      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'YourRef20');
End; // SetYourRef20

//-------------------------------------------------------------------------

Function TInvoice.GetBatchLink : cuStr12;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BatchLink
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'BatchLink');
  End; { Else }
End;

Procedure TInvoice.SetBatchLink(Value : cuStr12);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite) Then Begin
    If (DataRec.BatchLink <> Value) Then Begin
      DataRec.BatchLink := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'BatchLink');
End;

Function TInvoice.GetAllocStat : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AllocStat
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'AllocStat');
  End; { Else }
End;

Procedure TInvoice.SetAllocStat(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite) Then Begin
    If (DataRec.AllocStat <> Value) Then Begin
      DataRec.AllocStat := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'AllocStat');
End;

Function TInvoice.GetInvDocHed : cuDocTypes;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := cuDocTypes(DataRec.InvDocHed)
  Else Begin
    Result := cuDocTypes(0);
    EntSys.DataAccessErrDlg(True, InvErrStr + 'InvDocHed');
  End; { Else }
End;

Procedure TInvoice.SetInvDocHed(Value : cuDocTypes);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite) Then Begin
    If (DataRec.InvDocHed <> DocTypes(Value)) Then Begin
      DataRec.InvDocHed := DocTypes(Value);
      RecChanged := True;

      InvLines.Replicate(5);
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'InvDocHed');
End;

Function TInvoice.GetInvVatAnal (Index : cuVATIndex) : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InvVatAnal[VATType(Index)]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'InvVatAnal');
  End; { Else }
End;

Procedure TInvoice.SetInvVatAnal(Index : cuVATIndex; Value : Real);
Var
  VAT_I : VATType;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite) Then Begin
    If (DataRec.InvVatAnal[VATType(Index)] <> Value) Then Begin
      DataRec.InvVatAnal[VATType(Index)] := Value;
      RecChanged := True;

      { Update Total VAT }
      DataRec.InvVat := 0.0;
      For VAT_I := Standard to Rate11 Do
        DataRec.InvVat := DataRec.InvVat + DataRec.InvVatAnal[Vat_I];
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'InvVatAnal');
End;

Function TInvoice.GetInvNetVal : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InvNetVal
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'InvNetVal');
  End; { Else }
End;

Function TInvoice.GetInvVat : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InvVat
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'InvVat');
  End; { Else }
End;

Function TInvoice.GetDiscSetl : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DiscSetl
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DiscSetl');
  End; { Else }
End;

{ NOTE: Stored as 0.05 = 5%, Settlement Amount is not recalculated }
Procedure TInvoice.SetDiscSetl(Value : Real);
Begin
  (* MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite) Then Begin
    If (DataRec.DiscSetl <> Value) Then Begin
      DataRec.DiscSetl := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DiscSetl');
  *) EntSys.NotImplException ('TAbsInvoice.thDiscSetl');
End;

Function TInvoice.GetDiscSetAm : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DiscSetAm
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DiscSetAm');
  End; { Else }
End;

Procedure TInvoice.SetDiscSetAm(Value : Real);
Begin
  (* MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite) Then Begin
    If (DataRec.DiscSetAm <> Value) Then Begin
      DataRec.DiscSetAm := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DiscSetAm');
  *) EntSys.NotImplException ('TAbsInvoice.thDiscSetAm');
End;

Function TInvoice.GetDiscAmount : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DiscAmount
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DiscAmount');
  End; { Else }
End;

Procedure TInvoice.SetDiscAmount(Value : Real);
Begin
  (* MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite) Then Begin
    If (DataRec.DiscAmount <> Value) Then Begin
      DataRec.DiscAmount := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DiscAmount');
  *) EntSys.NotImplException ('TAbsInvoice.thDiscAmount');
End;

Function TInvoice.GetDiscDays : SmallInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DiscDays
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DiscDays');
  End; { Else }
End;

Procedure TInvoice.SetDiscDays(Value : SmallInt);
Begin
  (* MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  If (RecAccess <> NotAvailable) And (PropAccess[25] = paReadWrite) Then Begin
    If (DataRec.DiscDays <> Value) Then Begin
      DataRec.DiscDays := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DiscDays');
  *) EntSys.NotImplException ('TAbsInvoice.thDiscDays');
End;

Function TInvoice.GetDiscTaken : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DiscTaken
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DiscTaken');
  End; { Else }
End;

Procedure TInvoice.SetDiscTaken(Value : Boolean);
Begin
  (* MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  If (RecAccess <> NotAvailable) And (PropAccess[26] = paReadWrite) Then Begin
    If (DataRec.DiscTaken <> Value) Then Begin
      DataRec.DiscTaken := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DiscTaken');
  *) EntSys.NotImplException ('TAbsInvoice.thDiscTaken');
End;

Function TInvoice.GetSettled : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Settled
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'Settled');
  End; { Else }
End;

Procedure TInvoice.SetSettled(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[27] = paReadWrite) Then Begin
    If (DataRec.Settled <> Value) Then Begin
      DataRec.Settled := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'Settled');
End;

Function TInvoice.GetAutoInc : SmallInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AutoInc
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'AutoInc');
  End; { Else }
End;

Procedure TInvoice.SetAutoInc(Value : SmallInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[28] = paReadWrite) Then Begin
    If (DataRec.AutoInc <> Value) Then Begin
      If (DataRec.NomAuto And (Value <> 0)) Then Begin
        DataRec.AutoInc := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'AutoInc');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'AutoInc');
End;

Function TInvoice.GetUnYr : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UnYr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'NextAutoYr');
  End; { Else }
End;

Procedure TInvoice.SetUnYr(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[29] = paReadWrite) Then Begin
    If (DataRec.UnYr <> Value) Then Begin
      If EntSys.ValidYear(Value) And (DataRec.AutoIncBy = 'P') Then Begin
        DataRec.UnYr := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'NextAutoYr');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'NextAutoYr');
End;

Function TInvoice.GetUnPr : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UnPr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'NextAutoPr');
  End; { Else }
End;

Procedure TInvoice.SetUnPr(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[30] = paReadWrite) Then Begin
    If (DataRec.UnPr <> Value) Then Begin
      If EntSys.ValidPeriod (Value) And (DataRec.AutoIncBy = 'P') Then Begin
        DataRec.UnPr := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'NextAutoPr');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'NextAutoPr');
End;

Function TInvoice.GetTransNat : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TransNat
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TransNat');
  End; { Else }
End;

Procedure TInvoice.SetTransNat(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[31] = paReadWrite) Then Begin
    If (DataRec.TransNat <> Value) Then Begin
      DataRec.TransNat := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TransNat');
End;

Function TInvoice.GetTransMode : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TransMode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TransMode');
  End; { Else }
End;

Procedure TInvoice.SetTransMode(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[32] = paReadWrite) Then Begin
    If (DataRec.TransMode <> Value) Then Begin
      DataRec.TransMode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TransMode');
End;

Function TInvoice.GetRemitNo : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RemitNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'RemitNo');
  End; { Else }
End;

Procedure TInvoice.SetRemitNo(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[33] = paReadWrite) Then Begin
    If (DataRec.RemitNo <> Value) Then Begin
      DataRec.RemitNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'RemitNo');
End;

Function TInvoice.GetAutoIncBy : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AutoIncBy
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'AutoIncBy');
  End; { Else }
End;

Procedure TInvoice.SetAutoIncBy(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[34] = paReadWrite) Then Begin
    If (DataRec.AutoIncBy <> Value) Then Begin
      If (Value In ['D', 'P']) Then Begin
        DataRec.AutoIncBy := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'AutoIncBy');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'AutoIncBy');
End;

Function TInvoice.GetHoldFlg : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.HoldFlg
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'HoldFlg');
  End; { Else }
End;

Procedure TInvoice.SetHoldFlg(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[35] = paReadWrite) Then Begin
    If (DataRec.HoldFlg <> Value) Then Begin
      If (Value In [0..6]) Or ((Value - 32) In [0..6]) Or ((Value - 128) In [0..6]) Then Begin
        DataRec.HoldFlg := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'HoldFlg');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'HoldFlg');
End;

Function TInvoice.GetAuditFlg : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AuditFlg
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'AuditFlg');
  End; { Else }
End;

Procedure TInvoice.SetAuditFlg(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[36] = paReadWrite) Then Begin
    If (DataRec.AuditFlg <> Value) Then Begin
      DataRec.AuditFlg := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'AuditFlg');
End;

Function TInvoice.GetTotalWeight : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TotalWeight
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TotalWeight');
  End; { Else }
End;

Procedure TInvoice.SetTotalWeight(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[37] = paReadWrite) Then Begin
    If (DataRec.TotalWeight <> Value) Then Begin
      DataRec.TotalWeight := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TotalWeight');
End;

Function TInvoice.GetDAddr (Index : cuAddrIndex) : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DAddr[Index]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DelAddr');
  End; { Else }
End;

Procedure TInvoice.SetDAddr(Index : cuAddrIndex; Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[38] = paReadWrite) Then Begin
    If (DataRec.DAddr[Index] <> Value) Then Begin
      DataRec.DAddr[Index] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DelAddr');
End;

Function TInvoice.GetVariance : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Variance
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'Variance');
  End; { Else }
End;

Procedure TInvoice.SetVariance(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[39] = paReadWrite) Then Begin
    If (DataRec.Variance <> Value) Then Begin
      DataRec.Variance := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'Variance');
End;

Function TInvoice.GetTotalOrdered : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TotalOrdered
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TotalOrdered');
  End; { Else }
End;

Procedure TInvoice.SetTotalOrdered(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[40] = paReadWrite) Then Begin
    If (DataRec.TotalOrdered <> Value) Then Begin
      DataRec.TotalOrdered := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TotalOrdered');
End;

Function TInvoice.GetTotalReserved : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TotalReserved
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TotalReserved');
  End; { Else }
End;

Procedure TInvoice.SetTotalReserved(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[41] = paReadWrite) Then Begin
    If (DataRec.TotalReserved <> Value) Then Begin
      DataRec.TotalReserved := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TotalReserved');
End;

Function TInvoice.GetTotalCost : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TotalCost
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TotalCost');
  End; { Else }
End;

Procedure TInvoice.SetTotalCost(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[42] = paReadWrite) Then Begin
    If (DataRec.TotalCost <> Value) Then Begin
      DataRec.TotalCost := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TotalCost');
End;

Function TInvoice.GetTotalInvoiced : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TotalInvoiced
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TotalInvoiced');
  End; { Else }
End;

Procedure TInvoice.SetTotalInvoiced(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[43] = paReadWrite) Then Begin
    If (DataRec.TotalInvoiced <> Value) Then Begin
      DataRec.TotalInvoiced := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TotalInvoiced');
End;

Function TInvoice.GetTransDesc : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TransDesc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TransDesc');
  End; { Else }
End;

Procedure TInvoice.SetTransDesc(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[44] = paReadWrite) Then Begin
    If (DataRec.TransDesc <> Value) Then Begin
      DataRec.TransDesc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TransDesc');
End;

Function TInvoice.GetUntilDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UntilDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'AutoUntilDate');
  End; { Else }
End;

Procedure TInvoice.SetUntilDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[45] = paReadWrite) Then Begin
    If (DataRec.UntilDate <> Value) Then Begin
      If EntSys.ValidDate(Value) Or (Value = NdxWeight) Then Begin
        DataRec.UntilDate := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'AutoUntilDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'AutoUntilDate');
End;

Function TInvoice.GetExternalDoc : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ExternalDoc
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'External');
  End; { Else }
End;

Procedure TInvoice.SetExternalDoc(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[46] = paReadWrite) Then Begin
    If (DataRec.ExternalDoc <> Value) Then Begin
      DataRec.ExternalDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'External');
End;

Function TInvoice.GetPrintedDoc : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PrintedDoc
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'Printed');
  End; { Else }
End;

Procedure TInvoice.SetPrintedDoc(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[47] = paReadWrite) Then Begin
    If (DataRec.PrintedDoc <> Value) Then Begin
      DataRec.PrintedDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'Printed');
End;

Function TInvoice.GetReValueAdj : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ReValueAdj
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CurrVariance');
  End; { Else }
End;

Procedure TInvoice.SetReValueAdj(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[48] = paReadWrite) Then Begin
    If (DataRec.ReValueAdj <> Value) Then Begin
      DataRec.ReValueAdj := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'CurrVariance');
End;

Function TInvoice.GetCurrSettled : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CurrSettled
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CurrSettled');
  End; { Else }
End;

Procedure TInvoice.SetCurrSettled(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[49] = paReadWrite) Then Begin
    If (DataRec.CurrSettled <> Value) Then Begin
      DataRec.CurrSettled := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'CurrSettled');
End;

Function TInvoice.GetSettledVAT : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SettledVAT
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'SettledVAT');
  End; { Else }
End;

Procedure TInvoice.SetSettledVAT(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[50] = paReadWrite) Then Begin
    If (DataRec.SettledVAT <> Value) Then Begin
      DataRec.SettledVAT := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'SettledVAT');
End;

Function TInvoice.GetVATClaimed : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VATClaimed
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'VATClaimed');
  End; { Else }
End;

Procedure TInvoice.SetVATClaimed(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[51] = paReadWrite) Then Begin
    If (DataRec.VATClaimed <> Value) Then Begin
      DataRec.VATClaimed := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'VATClaimed');
End;

Function TInvoice.GetBatchNom : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BatchNom
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'BatchPayGL');
  End; { Else }
End;

Procedure TInvoice.SetBatchNom(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[52] = paReadWrite) Then Begin
    If (DataRec.BatchNom <> Value) Then Begin
      If EntSys.ValidNomCode (Value, 0) Then Begin
        DataRec.BatchNom := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'BatchPayGL');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'BatchPayGL');
End;

Function TInvoice.GetAutoPost : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AutoPost
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'AutoPost');
  End; { Else }
End;

Procedure TInvoice.SetAutoPost(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[53] = paReadWrite) Then Begin
    If (DataRec.AutoPost <> Value) Then Begin
      DataRec.AutoPost := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'AutoPost');
End;

Function TInvoice.GetManVAT : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ManVAT
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'ManualVAT');
  End; { Else }
End;

Procedure TInvoice.SetManVAT(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[54] = paReadWrite) Then Begin
    If (DataRec.ManVAT <> Value) Then Begin
      DataRec.ManVAT := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'ManualVAT');
End;

Function TInvoice.GetDelTerms : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DelTerms
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'SSDDelTerms');
  End; { Else }
End;

Procedure TInvoice.SetDelTerms(Value : cuStr3);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[55] = paReadWrite) Then Begin
    If (DataRec.DelTerms <> Value) Then Begin
      DataRec.DelTerms := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'SSDDelTerms');
End;

Function TInvoice.GetOpName : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OpName
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User');
  End; { Else }
End;

Procedure TInvoice.SetOpName(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[56] = paReadWrite) Then Begin
    If (DataRec.OpName <> Value) Then Begin
      DataRec.OpName := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User');
End;

Function TInvoice.GetNoLabels : SmallInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NoLabels
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'NoLabels');
  End; { Else }
End;

Procedure TInvoice.SetNoLabels(Value : SmallInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[57] = paReadWrite) Then Begin
    If (DataRec.NoLabels <> Value) Then Begin
      If (DataRec.InvDocHed In OrderSet) Then Begin
        DataRec.NoLabels := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'NoLabels');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'NoLabels');
End;

Function TInvoice.GetTagged : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := (DataRec.Tagged<>0)
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'Tagged');
  End; { Else }
End;

Procedure TInvoice.SetTagged(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[58] = paReadWrite) Then Begin
    If (DataRec.Tagged <> Byte(Ord(Value))) Then Begin
      DataRec.Tagged := Byte(Ord(Value));
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'Tagged');
End;

Function TInvoice.GetPickRunNo : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PickRunNo
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'PickRunNo');
  End; { Else }
End;

Procedure TInvoice.SetPickRunNo(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[59] = paReadWrite) Then Begin
    If (DataRec.PickRunNo <> Value) Then Begin
      DataRec.PickRunNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'PickRunNo');
End;

Function TInvoice.GetOrdMatch : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OrdMatch
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'OrdMatch');
  End; { Else }
End;

Procedure TInvoice.SetOrdMatch(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[60] = paReadWrite) Then Begin
    If (DataRec.OrdMatch <> Value) Then Begin
      DataRec.OrdMatch := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'OrdMatch');
End;

Function TInvoice.GetDeliverRef : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DeliverRef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DeliveryNote');
  End; { Else }
End;

Procedure TInvoice.SetDeliverRef(Value : cuStr10);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[61] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), DocKeyLen);
    If (DataRec.DeliverRef <> TmpStr) Then Begin
      If EntSys.CheckForRec(TmpStr,InvF,InvOurRefK) Then Begin
        DataRec.DeliverRef := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'DeliveryNote');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DeliveryNote');
End;

Function TInvoice.GetVATCRate1 : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VATCRate[False]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'VATCompanyRate');
  End; { Else }
End;

Procedure TInvoice.SetVATCRate1(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[62] = paReadWrite) Then Begin
    If (DataRec.VATCRate[False] <> Value) Then Begin
      If (Value <> 0) Then Begin
        DataRec.VATCRate[False] := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'VATCompanyRate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'VATCompanyRate');
End;

Function TInvoice.GetVATCRate2 : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VATCRate[True]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'VATDailyRate');
  End; { Else }
End;

Procedure TInvoice.SetVATCRate2(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[63] = paReadWrite) Then Begin
    If (DataRec.VATCRate[True] <> Value) Then Begin
      If (Value <> 0) Then Begin
        DataRec.VATCRate[True] := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'VATDailyRate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'VATDailyRate');
End;

Function TInvoice.GetOrigRates1 : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OrigRates[False]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'PostCompanyRate');
  End; { Else }
End;

Procedure TInvoice.SetOrigRates1(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[64] = paReadWrite) Then Begin
    If (DataRec.OrigRates[False] <> Value) Then Begin
      If (Value <> 0) Then Begin
        DataRec.OrigRates[False] := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'PostCompanyRate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'PostCompanyRate');
End;

Function TInvoice.GetOrigRates2 : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OrigRates[True]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'PostDailyRate');
  End; { Else }
End;

Procedure TInvoice.SetOrigRates2(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[65] = paReadWrite) Then Begin
    If (DataRec.OrigRates[True] <> Value) Then Begin
      If (Value <> 0) Then Begin
        DataRec.OrigRates[True] := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'PostDailyRate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'PostDailyRate');
End;

Function TInvoice.GetPostDiscAm : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PostDiscAm
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'PostDiscAm');
  End; { Else }
End;

Procedure TInvoice.SetPostDiscAm(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[66] = paReadWrite) Then Begin
    If (DataRec.PostDiscAm <> Value) Then Begin
      DataRec.PostDiscAm := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'PostDiscAm');
End;

Function TInvoice.GetPDiscTaken : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PDiscTaken
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'PostedDiscTaken');
  End; { Else }
End;

Procedure TInvoice.SetPDiscTaken(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[67] = paReadWrite) Then Begin
    If (DataRec.PDiscTaken <> Value) Then Begin
      DataRec.PDiscTaken := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'PostedDiscTaken');
End;

Function TInvoice.GetCtrlNom : Longint;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CtrlNom
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DrCrGL');
  End; { Else }
End;

Procedure TInvoice.SetCtrlNom(Value : Longint);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[68] = paReadWrite) Then Begin
    If (DataRec.CtrlNom <> Value) Then Begin
      If EntSys.ValidNomCode(Value, 3) Then Begin
        DataRec.CtrlNom := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'DrCrGL');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DrCrGL');
End;

Function TInvoice.GetDJobCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DJobCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'JobCode');
  End; { Else }
End;

Procedure TInvoice.SetDJobCode(Value : cuStr10);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[69] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), JobKeyLen);
    If (DataRec.DJobCode <> TmpStr) Then Begin
      If JBCostOn Then Begin
        { Job Costing is in use }
        If (Trim(TmpStr) = '') Or EntSys.CheckForRec(TmpStr,JobF,JobCodeK) Then Begin
          DataRec.DJobCode := TmpStr;
          RecChanged := True;
        End { If }
        Else
          EntSys.CustomException (InvErrStr + 'JobCode');
      End { If }
      Else Begin
        { Not Job Costing - use as a free format text field }
        DataRec.DJobCode := TmpStr;
        RecChanged := True;
      End; { Else }
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'JobCode');
End;

Function TInvoice.GetDJobAnal : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DJobAnal
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'JobAnal');
  End; { Else }
End;

Procedure TInvoice.SetDJobAnal(Value : cuStr10);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[70] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), AnalKeyLen);
    If (DataRec.DJobAnal <> TmpStr) Then Begin
      If JBCostOn Then Begin
        { Job Costing is in use - Can be blank if JobCode is blank, else must be set }
        If ((Trim(DataRec.DJobCode) = '') And (Trim(TmpStr) = '')) Or
           EntSys.CheckForRec(JARCode+JAACode+TmpStr,JMiscF,JMK) Then Begin
          DataRec.DJobAnal := TmpStr;
          RecChanged := True;
        End { If }
        Else
          EntSys.CustomException (InvErrStr + 'JobAnal');
      End { If }
      Else Begin
        { Not Job Costing - use as a free format text field }
        DataRec.DJobAnal := TmpStr;
        RecChanged := True;
      End; { Else }
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'JobAnal');
End;

Function TInvoice.GetTotOrdOS : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TotOrdOS
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TotOrderOS');
  End; { Else }
End;

Procedure TInvoice.SetTotOrdOS(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[71] = paReadWrite) Then Begin
    If (DataRec.TotOrdOS <> Value) Then Begin
      DataRec.TotOrdOS := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TotOrderOS');
End;

Function TInvoice.GetDocUser1 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser1
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User1');
  End; { Else }
End;

Procedure TInvoice.SetDocUser1(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[72] = paReadWrite) Then Begin
    If (DataRec.DocUser1 <> Value) Then Begin
      DataRec.DocUser1 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User1');
End;

Function TInvoice.GetDocUser2 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser2
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User2');
  End; { Else }
End;

Procedure TInvoice.SetDocUser2(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[73] = paReadWrite) Then Begin
    If (DataRec.DocUser2 <> Value) Then Begin
      DataRec.DocUser2 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User2');
End;

Function TInvoice.GetDocLSplit (Index : cuLineIndex) : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocLSplit[Index]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'DocLSplit');
  End; { Else }
End;

Procedure TInvoice.SetDocLSplit(Index : cuLineIndex; Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[74] = paReadWrite) Then Begin
    If (DataRec.DocLSplit[Index] <> Value) Then Begin
      DataRec.DocLSplit[Index] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'DocLSplit');
End;

Function TInvoice.GetLastLetter : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LastLetter
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'LastLetter');
  End; { Else }
End;

Procedure TInvoice.SetLastLetter(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[75] = paReadWrite) Then Begin
    If (DataRec.LastLetter <> Value) Then Begin
      If (Value In [0..3]) Then Begin
        DataRec.LastLetter := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (InvErrStr + 'LastLetter');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'LastLetter');
End;

Function TInvoice.GetUnTagged : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UnTagged
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'UnTagged');
  End; { Else }
End;

Procedure TInvoice.SetUnTagged(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[76] = paReadWrite) Then Begin
    If (DataRec.UnTagged <> Value) Then Begin
      DataRec.UnTagged := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'UnTagged');
End;

Function TInvoice.GetInvLines : TAbsInvoiceLines;
Begin
  Result := InvLines;
End;

{ loads the Cust object with the Cust for this header line }
Function TInvoice.LinkToCust : Boolean;

Var
  ThisAccount  :  TABSCustomer;

Begin
  Result := False;

  If (RecAccess <> NotAvailable) And (FuncAccess[1] = pfEnabled) Then
    With EntSys Do
      If (thAcCode<>'') and (thInvDocHed In [CUSIN..CUSDN]+[CUPIN..CUPDN]) then
      Begin

        If (thInvDocHed In [CUSIN..CUSDN]) then
          ThisAccount:=Customer
        else
          ThisAccount:=Supplier;

        Result := TCustomer(ThisAccount).LinkToCust(thAcCode);
      end;
End;

{$IFDEF SOP}

  {== Procedure to initialize or remove the commitment update object ==}

  procedure TInvoice.Create_CommitObject(Remove  :  Boolean);

  {$IFDEF POST}
    Var
      PostObj  :  ^TEntPost;
    Begin
      If (Not Assigned(TransCommitPtr)) and (Invoice.InvDocHed=POR) and (Not Remove) then
      Begin
        New(PostObj,Create(Self));

        Try
          If (Not PostObj^.Start(50,nil,nil,BOff)) then
          Begin
            Dispose(PostObj,Destroy);
            PostObj:=nil;
          end;

        except
          Dispose(PostObj,Destroy);
          PostObj:=nil;
        end; {Try..}

        TransCommitPtr:=@PostObj^;

      end
      else
        If (Remove) and (Assigned(TransCommitPtr)) then
        Begin
          PostObj:=TransCommitPtr;

          Dispose(PostObj,Destroy);
          TransCommitPtr:=nil;

        end;
    end;
  {$ELSE}
    Begin

    end;
  {$ENDIF}

  procedure TInvoice.Update_LiveCommit(IdR     :  IDetail;
                                       DedMode :  SmallInt);

  {$IFDEF POST}
    Var
      PostObj  :  ^TEntPost;

    Begin
      If (CommitAct) then
        Create_CommitObject(BOff);

      If (Assigned(TransCommitPtr)) and (CommitAct) and (IdR.IdDocHed=POR) then
      Begin
          PostObj:=TransCommitPtr;
          try
            PostObj^.Update_LiveCommit(IdR,DedMode);
          except
            Dispose(PostObj,Destroy);
            TransCommitPtr:=nil;
          end;
      end;
    end;

  {$ELSE}
    Begin


    end;
  {$ENDIF}


{$ENDIF}


//
// MH 23/09/2014: IMPORTANT NOTE: This should only be used for hook points which do not change the transaction value
//
{ Resets the OrigRec and DataRec to the invoice passed in - used in tight loops }
{ where only the header is relevent                                             }
Procedure TInvoice.ResetTrans (Const Invoice : InvRec);
Begin { ResetTrans }
  DataRec := Invoice;
  OrigRec := Invoice;
End;  { ResetTrans }

//
// MH 23/09/2014: IMPORTANT NOTE: This should only be used for hook points which do not change the transaction value
//
{ 01/12/2004. v5.61 Resets the OrigRec and DataRec to the invoice passed in + reloads the lines - used in tight loops }
{ CurrentLine set as blank so no current line is loaded as procedure designed to be used with the BACS filter hook 2050,174/5 }
Procedure TInvoice.ResetTransandLines (Const WinId, HandlerId : LongInt;
                                       Const Invoice          : InvRec);
Var
  TmpLine  :  IDetail;

Begin
  Blank(TmpLine,Sizeof(TmpLine));

  ResetTrans (Invoice);

  // MH 16/06/2015 Exch-R1 ABSEXCH-16534: Implemented modified SOR editing rules within Customisation
  InvLines.Assign(WinId,HandlerId, TmpLine, False {CheckForPayments});

end;


Function  TInvoice.GetDocUser3 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser3
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User3');
  End; { Else }
End;

Procedure TInvoice.SetDocUser3(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[78] = paReadWrite) Then Begin
    If (DataRec.DocUser3 <> Value) Then Begin
      DataRec.DocUser3 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User3');
End;

Function  TInvoice.GetDocUser4 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser4
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User4');
  End; { Else }
End;

Procedure TInvoice.SetDocUser4(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[79] = paReadWrite) Then Begin
    If (DataRec.DocUser4 <> Value) Then Begin
      DataRec.DocUser4 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User4');
End;

Procedure TInvoice.SetRecChanged(fRecChanged  :  Boolean);

Begin
  If (fRecChanged<>RecChanged) then
    RecChanged:=fRecChanged;

end;

//---------------------------------------------

Function TInvoice.GetTagNo : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Tagged
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TagNo');
  End; { Else }
End;

Procedure TInvoice.SetTagNo(Value : Byte);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[80] = paReadWrite) Then Begin
    If (DataRec.Tagged <> Value) Then Begin
      DataRec.Tagged := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TagNo');
end;

//-------------------------------------------------------------------------

// HM 20/02/03: Added to allow EL to change the current line without calling
// Assign which reloads the thLines array.  This is for performance and can
// only be used when the pressent current line is also in the thLines array
// changed, FALSE if the line didn't exist, or was for the wrong trans, or
// if the system is currently adding a line (see notes above).
Function TInvoice.ChangeCurrentLine (Const InvLine : IDetail) : Boolean;
Begin { ChangeCurrentLine }
  Result := InvLines.ChangeCurrentLine (InvLine);
End; { ChangeCurrentLine }

//-------------------------------------------------------------------------

Function TInvoice.GetCISTaxDue : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISTax
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CISTaxDue');
  End; { Else }
End;

Procedure TInvoice.SetCISTaxDue(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[81] = paReadWrite) Then Begin
    If (DataRec.CISTax <> Value) Then Begin
      DataRec.CISTax := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'CISTaxDue');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetCISTaxDeclared : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISDeclared
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CISTaxDeclared');
  End; { Else }
End;

Procedure TInvoice.SetCISTaxDeclared(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[82] = paReadWrite) Then Begin
    If (DataRec.CISDeclared <> Value) Then Begin
      DataRec.CISDeclared := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'CISTaxDeclared');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetCISManualTax : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISManualTax
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CISManualTax');
  End; { Else }
End;

Procedure TInvoice.SetCISManualTax(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[83] = paReadWrite) Then Begin
    If (DataRec.CISManualTax <> Value) Then Begin
      DataRec.CISManualTax := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'CISManualTax');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetCISDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CISDate');
  End; { Else }
End;

Procedure TInvoice.SetCISDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[84] = paReadWrite) Then Begin
    If (DataRec.CISDate <> Value) Then Begin
      DataRec.CISDate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'CISDate');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetCISEmployee : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISEmpl
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'GetCISEmployee');
  End; { Else }
End;

Procedure TInvoice.SetCISEmployee(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[85] = paReadWrite) Then Begin
    If (DataRec.CISEmpl <> Value) Then Begin
      DataRec.CISEmpl := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'GetCISEmployee');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetCISTotalGross : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISGross
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CISTotalGross');
  End; { Else }
End;

Procedure TInvoice.SetCISTotalGross(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[86] = paReadWrite) Then Begin
    If (DataRec.CISGross <> Value) Then Begin
      DataRec.CISGross := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'CISTotalGross');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetCISSource : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISHolder
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'CISSource');
  End; { Else }
End;

Procedure TInvoice.SetCISSource(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[87] = paReadWrite) Then Begin
    If (DataRec.CISHolder <> Value) Then Begin
      DataRec.CISHolder := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'CISSource');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetTotalCostApport : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TotalCost2
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TotalCostApport');
  End; { Else }
End;

Procedure TInvoice.SetTotalCostApport(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[88] = paReadWrite) Then Begin
    If (DataRec.TotalCost2 <> Value) Then Begin
      DataRec.TotalCost2 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TotalCostApport');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetNOMVATIO : cuNOMVatIOType;
Begin
  Result := nvioNA;
  If (RecAccess <> NotAvailable) Then
    Case DataRec.NOMVATIO Of
      #0  : Result := nvioNA;
      'I' : Result := nvioInput;
      'O' : Result := nvioOutput;
    Else
      Raise Exception.Create ('TInvoice.GetNOMVATIO: Unhandled value ' + IntToStr(Ord(DataRec.NOMVATIO)));
    End { Case }
  Else
    EntSys.DataAccessErrDlg(True, InvErrStr + 'NOMVATIO');
End;

Procedure TInvoice.SetNOMVATIO(Value : cuNOMVatIOType);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[89] = paReadWrite) Then Begin
    Case Value Of
      nvioNA     : DataRec.NOMVATIO := #0;
      nvioInput  : DataRec.NOMVATIO := 'I';
      nvioOutput : DataRec.NOMVATIO := 'O';
    Else
      Raise Exception.Create ('TInvLine.SetNOMVATIO: Unhandled value ' + IntToStr(Ord(Value)));
    End; { Case }
    RecChanged := True;
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'NOMVATIO');
End;

//-------------------------------------------------------------------------

Function TInvoice.GetTSHExported : Boolean;
Begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.THExportedFlag
  Else
    EntSys.DataAccessErrDlg(True, InvErrStr + 'TSHExported');
End;

Procedure TInvoice.SetTSHExported(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[90] = paReadWrite) Then Begin
    If (DataRec.THExportedFlag <> Value) Then Begin
      DataRec.THExportedFlag := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'TSHExported');
End;

//------------------------------

Function TInvoice.GetWeekMonth : SmallInt;
Begin // GetWeekMonth
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thWeekMonth
  Else
    EntSys.DataAccessErrDlg(True, InvErrStr + 'WeekMonth');
End; // GetWeekMonth
Procedure TInvoice.SetWeekMonth(Value : SmallInt);
Begin // SetWeekMonth
  If (RecAccess <> NotAvailable) And (PropAccess[91] = paReadWrite) Then
  Begin
    If (DataRec.thWeekMonth <> Value) Then Begin
      DataRec.thWeekMonth := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'WeekMonth');
End; // SetWeekMonth

//------------------------------

Function TInvoice.GetWorkflowState : LongInt;
Begin // GetWorkflowState
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thWorkflowState
  Else
    EntSys.DataAccessErrDlg(True, InvErrStr + 'WorkflowState');
End; // GetWorkflowState
Procedure TInvoice.SetWorkflowState(Value : LongInt);
Begin // SetWorkflowState
  If (RecAccess <> NotAvailable) And (PropAccess[92] = paReadWrite) Then
  Begin
    If (DataRec.thWorkflowState <> Value) Then Begin
      DataRec.thWorkflowState := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'WorkflowState');
End; // SetWorkflowState

//-------------------------------------------------------------------------

// v6.5 12/10/10 - Descendant of Abstract Transaction Object for new v6.5 Override Location fields
Function  TInvoice.GetOverrideLocation : cuStr3;
Begin // GetOverrideLocation
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thOverrideLocation
  Else
    EntSys.DataAccessErrDlg(True, InvErrStr + 'OverrideLocation');
End; // GetOverrideLocation
Procedure TInvoice.SetOverrideLocation(Value : cuStr3);
Var
  TmpStr : ShortString;
Begin // SetOverrideLocation
  If (RecAccess <> NotAvailable) And (PropAccess[93] = paReadWrite) Then
  Begin
    // Check if Override Location field is applicable
    If Syss.EnableOverrideLocations And (DataRec.InvDocHed In PurchSplit) Then
    Begin
      // The override location cannot be changed once lines have been added
      If (InvLines.thLineCount = 0) Then
      Begin
        TmpStr := LJVar(UpperCase(Value), MLocKeyLen);
        If (DataRec.thOverrideLocation <> TmpStr) Then
        Begin
          // Can be blank or a valid location
          If (Trim(TmpStr) = '') Or EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],TmpStr),MLocF,MLK) Then
          Begin
            DataRec.thOverrideLocation := TmpStr;
            RecChanged := True;
          End // If (Trim(TmpStr) = '') Or EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],TmpStr),MLocF,MLK)
          Else
            Entsys.CustomException (InvErrStr + 'OverrideLocation');
        End; { If }
      End // If (InvLines.Count = 0)
      Else
        Raise Exception.Create('The ' + InvErrStr + 'OverrideLocation field cannot be changed once lines have been added');
    End // If Syss.EnableOverrideLocations And (DataRec.InvDocHed In PurchSplit)
    Else
      Raise Exception.Create('The ' + InvErrStr + 'OverrideLocation field is not in use');
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'OverrideLocation');
End; // SetOverrideLocation

//------------------------------

Function TInvoice.GetUser5 : cuStr30;
Begin // GetUser5
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser5
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User5');
  End; { Else }
End; // GetUser5

Procedure TInvoice.SetUser5 (Value : cuStr30);
Begin // SetUser5
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef5] = paReadWrite) Then
  Begin
    If (DataRec.DocUser5 <> Value) Then
    Begin
      DataRec.DocUser5 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User5');
End; // SetUser5

//------------------------------

Function TInvoice.GetUser6 : cuStr30;
Begin // GetUser6
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser6
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User6');
  End; { Else }
End; // GetUser6

Procedure TInvoice.SetUser6 (Value : cuStr30);
Begin // SetUser6
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef6] = paReadWrite) Then
  Begin
    If (DataRec.DocUser6 <> Value) Then
    Begin
      DataRec.DocUser6 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User6');
End; // SetUser6

//------------------------------

Function TInvoice.GetUser7 : cuStr30;
Begin // GetUser7
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser7
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User7');
  End; { Else }
End; // GetUser7

Procedure TInvoice.SetUser7 (Value : cuStr30);
Begin // SetUser7
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef7] = paReadWrite) Then
  Begin
    If (DataRec.DocUser7 <> Value) Then
    Begin
      DataRec.DocUser7 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User7');
End; // SetUser7

//------------------------------

Function TInvoice.GetUser8 : cuStr30;
Begin // GetUser8
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser8
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User8');
  End; { Else }
End; // GetUser8

Procedure TInvoice.SetUser8 (Value : cuStr30);
Begin // SetUser8
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef8] = paReadWrite) Then
  Begin
    If (DataRec.DocUser8 <> Value) Then
    Begin
      DataRec.DocUser8 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User8');
End; // SetUser8

//------------------------------

Function TInvoice.GetUser9 : cuStr30;
Begin // GetUser9
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser9
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User9');
  End; { Else }
End; // GetUser9

Procedure TInvoice.SetUser9 (Value : cuStr30);
Begin // SetUser9
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef9] = paReadWrite) Then
  Begin
    If (DataRec.DocUser9 <> Value) Then
    Begin
      DataRec.DocUser9 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User9');
End; // SetUser9

//------------------------------

Function TInvoice.GetUser10 : cuStr30;
Begin // GetUser10
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocUser10
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User10');
  End; { Else }
End; // GetUser10

Procedure TInvoice.SetUser10 (Value : cuStr30);
Begin // SetUser10
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef10] = paReadWrite) Then
  Begin
    If (DataRec.DocUser10 <> Value) Then
    Begin
      DataRec.DocUser10 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User10');
End; // SetUser10

//-------------------------------------------------------------------------

// MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode and Transaction Originator
Function TInvoice.GetDeliveryPostCode : cuStr20;
Begin // GetDeliveryPostCode
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thDeliveryPostCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thDeliveryPostCode');
  End; { Else }
End; // GetDeliveryPostCode

Procedure TInvoice.SetDeliveryPostCode (value : cuStr20);
Begin // SetDeliveryPostCode
  If (RecAccess <> NotAvailable) And (PropAccess[idxDeliveryPostCode] = paReadWrite) Then
  Begin
    If (DataRec.thDeliveryPostCode <> Value) Then
    Begin
      DataRec.thDeliveryPostCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thDeliveryPostCode');
End; // SetDeliveryPostCode

//------------------------------

Function TInvoice.GetOriginator : cuStr36;
Begin // GetOriginator
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thOriginator
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thOriginator');
  End; { Else }
End; // GetOriginator

Procedure TInvoice.SetOriginator (value : cuStr36);
Begin // SetOriginator
  (* This shouldn't ever be overwritten by a plug-in
  If (RecAccess <> NotAvailable) And (PropAccess[idxOriginator] = paReadWrite) Then
  Begin
    If (DataRec.thOriginator <> Value) Then
    Begin
      DataRec.thOriginator := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thOriginator');
  *)   EntSys.NotImplException ('TAbsInvoice9.thOriginator');
End; // SetOriginator

//------------------------------

Function TInvoice.GetCreationTime : cuStr6;
Begin // GetCreationTime
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thCreationTime
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thCreationTime');
  End; { Else }
End; // GetCreationTime

Procedure TInvoice.SetCreationTime (value : cuStr6);
Begin // SetCreationTime
  (* This shouldn't ever be overwritten by a plug-in
  If (RecAccess <> NotAvailable) And (PropAccess[idxCreationTime] = paReadWrite) Then
  Begin
    If (DataRec.thCreationTime <> Value) Then
    Begin
      DataRec.thCreationTime := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thCreationTime');
  *)   EntSys.NotImplException ('TAbsInvoice9.thCreationTime');
End; // SetCreationTime

//------------------------------

Function TInvoice.GetCreationDate : cuStr8;
Begin // GetCreationDate
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thCreationDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thCreationDate');
  End; { Else }
End; // GetCreationDate

Procedure TInvoice.SetCreationDate (value : cuStr8);
Begin // SetCreationDate
  (* This shouldn't ever be overwritten by a plug-in
  If (RecAccess <> NotAvailable) And (PropAccess[idxCreationDate] = paReadWrite) Then
  Begin
    If (DataRec.thCreationDate <> Value) Then
    Begin
      DataRec.thCreationDate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thCreationDate');
  *)   EntSys.NotImplException ('TAbsInvoice9.thCreationDate');
End; // SetCreationDate

//-------------------------------------------------------------------------

// MH 27/03/2015 v7.0.14 ABSEXCH-16284: Added new Prompt Payment Discount fields
Function TInvoice.AllowPPD : Boolean;
Begin // AllowPPD
  If (DataRec.InvDocHed In SalesSplit) Then
    Result := (TAbsCustomer7(EntSys.Customer).acPPDMode <> CustABSU.pmPPDDisabled)
  Else If (DataRec.InvDocHed In PurchSplit) Then
    Result := (TAbsCustomer7(EntSys.Supplier).acPPDMode <> CustABSU.pmPPDDisabled)
  Else
    Result := False;
End; // AllowPPD

Function TInvoice.GetPPDPercentage : Double;
Begin // GetPPDPercentage
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thPPDPercentage
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thPPDPercentage');
  End; { Else }
End; // GetPPDPercentage

Procedure TInvoice.SetPPDPercentage (Value : Double);
Begin // SetPPDPercentage
  If (RecAccess <> NotAvailable) And (PropAccess[idxPPDPercentage] = paReadWrite) Then
  Begin
    If (DataRec.thPPDPercentage <> Value) Then
    Begin
      // Check whether PPD is set on the account
      If AllowPPD Then
      Begin
        If (DataRec.thPPDTaken = ptPPDNotTaken) Then
        Begin
          If (Value >= 0) And (Value < 1) Then
          Begin
            DataRec.thPPDPercentage := Value;
            RecChanged := True;

            // Recalculate PPD discount values
            UpdatePPDTotals (DataRec);
          End // If (Value >= 0) And (Value < 1)
          Else
            EntSys.CustomException (InvErrStr + 'thPPDPercentage - the percentage must be >= 0.0 and < 1.0');
        End // If (DataRec.thPPDTaken = ptPPDNotTaken)
        Else
          EntSys.CustomException (InvErrStr + 'thPPDPercentage cannot be changed after the discount has been taken');
      End // If AllowPPD
      Else
        EntSys.CustomException (InvErrStr + 'thPPDPercentage cannot be set when PPD is Disabled on the Account');
    End; { If }
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxPPDPercentage] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thPPDPercentage');
End; // SetPPDPercentage

//------------------------------

Function TInvoice.GetPPDDays : SmallInt;
Begin // GetPPDDays
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thPPDDays
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thPPDDays');
  End; { Else }
End; // GetPPDDays

Procedure TInvoice.SetPPDDays (Value : SmallInt);
Begin // SetPPDDays
  If (RecAccess <> NotAvailable) And (PropAccess[idxPPDDays] = paReadWrite) Then
  Begin
    If (DataRec.thPPDDays <> Value) Then
    Begin
      // Check whether PPD is set on the account
      If AllowPPD Then
      Begin
        If (DataRec.thPPDTaken = ptPPDNotTaken) Then
        Begin
          If (Value >= 0) And (Value <= 999) Then
          Begin
            DataRec.thPPDDays := Value;
            RecChanged := True;
          End // If (Value >= 0) And (Value <= 9999)
          Else
            EntSys.CustomException (InvErrStr + 'thPPDDays - the days must be from 0 to 999');
        End // If (DataRec.thPPDTaken = ptPPDNotTaken)
        Else
          EntSys.CustomException (InvErrStr + 'thPPDDays cannot be changed after the discount has been taken');
      End // If AllowPPD
      Else
        EntSys.CustomException (InvErrStr + 'thPPDDays cannot be set when PPD is Disabled on the Account');
    End; // If (DataRec.thPPDDays <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxPPDDays] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thPPDDays');
End; // SetPPDDays

//------------------------------

Function TInvoice.GetPPDGoodsValue : Double;
Begin // GetPPDGoodsValue
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thPPDGoodsValue
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thPPDGoodsValue');
  End; { Else }
End; // GetPPDGoodsValue

Procedure TInvoice.SetPPDGoodsValue (Value : Double);
Begin // SetPPDGoodsValue
  EntSys.NotImplException ('TAbsInvoice.thPPDGoodsValue'); //   Should be automatically maintained by the system
End; // SetPPDGoodsValue

//------------------------------

Function TInvoice.GetPPDVATValue : Double;
Begin // GetPPDVATValue
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thPPDVATValue
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thPPDVATValue');
  End; { Else }
End; // GetPPDVATValue

Procedure TInvoice.SetPPDVATValue (Value : Double);
Begin // SetPPDVATValue
  EntSys.NotImplException ('TAbsInvoice.thPPDVATValue'); //   Should be automatically maintained by the system
End; // SetPPDVATValue

//------------------------------

Function TInvoice.GetPPDTakenStatus : TInvoicePPDTakenStatus;
Begin // GetPPDTakenStatus
  Result := CustABSU.ptPPDNotTaken;
  If (RecAccess <> NotAvailable) Then
    Case DataRec.thPPDTaken Of
      ptPPDNotTaken          : Result := CustABSU.ptPPDNotTaken;
      ptPPDTaken             : Result := CustABSU.ptPPDTaken;
      ptPPDTakenOutsideTerms : Result := CustABSU.ptPPDTakenOutsideTerms;
    End // Case DataRec.thPPDTaken
  Else
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thPPDTakenStatus');
End; // GetPPDTakenStatus

Procedure TInvoice.SetPPDTakenStatus (Value : TInvoicePPDTakenStatus);
Var
  NewVal : TTransactionPPDTakenStatus;
Begin // SetPPDTakenStatus
  NewVal := ptPPDNotTaken;
  If (RecAccess <> NotAvailable) And (PropAccess[IdxPPDTakenStatus] = paReadWrite) Then
  Begin
    Case Value Of
      CustABSU.ptPPDNotTaken          : NewVal := ptPPDNotTaken;
      CustABSU.ptPPDTaken             : NewVal := ptPPDTaken;
      CustABSU.ptPPDTakenOutsideTerms : NewVal := ptPPDTakenOutsideTerms;
    End; // Case DataRec.thPPDTaken

    If (DataRec.thPPDTaken <> NewVal) Then
    Begin
      // Check whether PPD is set on the account
      If AllowPPD Then
      Begin
        DataRec.thPPDTaken := NewVal;
        RecChanged := True;
      End // If AllowPPD
      Else
        EntSys.CustomException (InvErrStr + 'thPPDTaken cannot be set when PPD is Disabled on the Account');
    End; // If (DataRec.thPPDTaken <> NewVal)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxPPDTaken] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thPPDTaken');
End; // SetPPDTakenStatus

//------------------------------

Function TInvoice.GetPPDCreditNote : Boolean;
Begin // GetPPDCreditNote
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thPPDCreditNote
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thPPDCreditNote');
  End; { Else }
End; // GetPPDCreditNote

Procedure TInvoice.SetPPDCreditNote(Value : Boolean);
Begin // SetPPDCreditNote
  EntSys.NotImplException ('TAbsInvoice.thPPDCreditNote'); //   Should be automatically maintained by the system
End; // SetPPDCreditNote

//------------------------------

Function TInvoice.GetBatchPayPPDStatus : Byte;
Begin // GetBatchPayPPDStatus
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thBatchPayPPDStatus
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thBatchPayPPDStatus');
  End; { Else }
End; // GetBatchPayPPDStatus

Procedure TInvoice.SetBatchPayPPDStatus(Value : Byte);
Begin // SetBatchPayPPDStatus
  EntSys.NotImplException ('TAbsInvoice.thBatchPayPPDStatus'); //   Should be automatically maintained by the system
End; // SetBatchPayPPDStatus

//-------------------------------------------------------------------------

// TAbsInvoice10 MH 22/09/2014 Order Payments
Function TInvoice.GetOrderPaymentOrderRef : cuStr10;
Begin // GetOrderPaymentOrderRef
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thOrderPaymentOrderRef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thOrderPaymentOrderRef');
  End; { Else }
End; // GetOrderPaymentOrderRef

//------------------------------

Function TInvoice.GetOrderPaymentElement : cuTransactionOrderPaymentElement;
Begin // GetOrderPaymentElement
  //
  // Note: InvRec.thOrderPaymentElement currently maps directly onto cuTransactionOrderPaymentElement
  //
  If (RecAccess <> NotAvailable) Then
    Result := cuTransactionOrderPaymentElement(DataRec.thOrderPaymentElement)
  Else Begin
    Result := topeNA;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thOrderPaymentElement');
  End; { Else }
End; // GetOrderPaymentElement

//------------------------------

Function TInvoice.GetOrderPaymentFlags : Byte;
Begin // GetOrderPaymentFlags
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thOrderPaymentFlags
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thOrderPaymentFlags');
  End; { Else }
End; // GetOrderPaymentFlags

//------------------------------

Function TInvoice.GetCreditCardType : cuStr4;
Begin // GetCreditCardType
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thCreditCardType
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thCreditCardType');
  End; { Else }
End; // GetCreditCardType

Procedure TInvoice.SetCreditCardType (Value : cuStr4);
Begin // SetCreditCardType
  If (RecAccess <> NotAvailable) And (PropAccess[idxCreditCardType] = paReadWrite) Then
  Begin
    If (DataRec.thCreditCardType <> Value) Then
    Begin
      // Read-Only on Payment and Refund SRCs
      If Not (DataRec.thOrderPaymentElement In [opeOrderPayment, opeDeliveryPayment, opeInvoicePayment, opeOrderRefund, opeInvoiceRefund]) Then
      Begin
        DataRec.thCreditCardType := Value;
        RecChanged := True;
      End // If Not (DataRec.thOrderPaymentElement In [...
      Else
        Raise Exception.Create('The ' + InvErrStr + 'CreditCardType field cannot be changed on Payment and Refund transactions created by Order Payments');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thCreditCardType');
End; // SetCreditCardType

//------------------------------

Function TInvoice.GetCreditCardNumber : cuStr4;
Begin // GetCreditCardNumber
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thCreditCardNumber
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thCreditCardNumber');
  End; { Else }
End; // GetCreditCardNumber

Procedure TInvoice.SetCreditCardNumber (Value : cuStr4);
Begin // Value
  If (RecAccess <> NotAvailable) And (PropAccess[idxCreditCardNumber] = paReadWrite) Then
  Begin
    If (DataRec.thCreditCardNumber <> Value) Then
    Begin
      // Read-Only on Payment and Refund SRCs
      If Not (DataRec.thOrderPaymentElement In [opeOrderPayment, opeDeliveryPayment, opeInvoicePayment, opeOrderRefund, opeInvoiceRefund]) Then
      Begin
        DataRec.thCreditCardNumber := Value;
        RecChanged := True;
      End // If Not (DataRec.thOrderPaymentElement In [...
      Else
        Raise Exception.Create('The ' + InvErrStr + 'CreditCardNumber field cannot be changed on Payment and Refund transactions created by Order Payments');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thCreditCardNumber');
End; // Value

//------------------------------

Function TInvoice.GetCreditCardExpiry : cuStr4;
Begin // GetCreditCardExpiry
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thCreditCardExpiry
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thCreditCardExpiry');
  End; { Else }
End; // GetCreditCardExpiry

Procedure TInvoice.SetCreditCardExpiry (Value : cuStr4);
Begin // Value
  If (RecAccess <> NotAvailable) And (PropAccess[idxCreditCardExpiry] = paReadWrite) Then
  Begin
    If (DataRec.thCreditCardExpiry <> Value) Then
    Begin
      // Read-Only on Payment and Refund SRCs
      If Not (DataRec.thOrderPaymentElement In [opeOrderPayment, opeDeliveryPayment, opeInvoicePayment, opeOrderRefund, opeInvoiceRefund]) Then
      Begin
        DataRec.thCreditCardExpiry := Value;
        RecChanged := True;
      End // If Not (DataRec.thOrderPaymentElement In [...
      Else
        Raise Exception.Create('The ' + InvErrStr + 'CreditCardExpiry field cannot be changed on Payment and Refund transactions created by Order Payments');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thCreditCardExpiry');
End; // Value

//------------------------------

Function TInvoice.GetCreditCardAuthorisationNo : cuStr20;
Begin // GetCreditCardAuthorisationNo
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thCreditCardAuthorisationNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thCreditCardAuthorisationNo');
  End; { Else }
End; // GetCreditCardAuthorisationNo

Procedure TInvoice.SetCreditCardAuthorisationNo (Value : cuStr20);
Begin // Value
  If (RecAccess <> NotAvailable) And (PropAccess[idxCreditCardAuthorisationNo] = paReadWrite) Then
  Begin
    If (DataRec.thCreditCardAuthorisationNo <> Value) Then
    Begin
      // Read-Only on Payment and Refund SRCs
      If Not (DataRec.thOrderPaymentElement In [opeOrderPayment, opeDeliveryPayment, opeInvoicePayment, opeOrderRefund, opeInvoiceRefund]) Then
      Begin
        DataRec.thCreditCardAuthorisationNo := Value;
        RecChanged := True;
      End // If Not (DataRec.thOrderPaymentElement In [...
      Else
        Raise Exception.Create('The ' + InvErrStr + 'CreditCardAuthorisationNo field cannot be changed on Payment and Refund transactions created by Order Payments');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thCreditCardAuthorisationNo');
End; // Value

//------------------------------

Function TInvoice.GetCreditCardReferenceNo : cuStr70;
Begin // GetCreditCardReferenceNo
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thCreditCardReferenceNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thCreditCardReferenceNo');
  End; { Else }
End; // GetCreditCardReferenceNo

Procedure TInvoice.SetCreditCardReferenceNo (Value : cuStr70);
Begin // Value
  If (RecAccess <> NotAvailable) And (PropAccess[idxCreditCardReferenceNo] = paReadWrite) Then
  Begin
    If (DataRec.thCreditCardReferenceNo <> Value) Then
    Begin
      // Read-Only on Payment and Refund SRCs
      If Not (DataRec.thOrderPaymentElement In [opeOrderPayment, opeDeliveryPayment, opeInvoicePayment, opeOrderRefund, opeInvoiceRefund]) Then
      Begin
        DataRec.thCreditCardReferenceNo := Value;
        RecChanged := True;
      End // If Not (DataRec.thOrderPaymentElement In [...
      Else
        Raise Exception.Create('The ' + InvErrStr + 'CreditCardReferenceNo field cannot be changed on Payment and Refund transactions created by Order Payments');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thCreditCardReferenceNo');
End; // Value

//------------------------------

Function TInvoice.GetCustomData1 : cuStr30;
Begin // GetCustomData1
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thCustomData1
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thCustomData1');
  End; { Else }
End; // GetCustomData1

Procedure TInvoice.SetCustomData1 (Value : cuStr30);
Begin // Value
  If (RecAccess <> NotAvailable) And (PropAccess[idxCustomData1] = paReadWrite) Then
  Begin
    If (DataRec.thCustomData1 <> Value) Then
    Begin
      DataRec.thCustomData1 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thCustomData1');
End; // Value

//-------------------------------------------------------------------------

// MH 26/11/2014 ABSEXCH-15836: Added Country Codes
Function TInvoice.GetDeliveryCountry : cuStr2;
Begin // GetDeliveryCountry
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thDeliveryCountry
  Else Begin
    Result := '  ';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thDeliveryCountry');
  End; { Else }
End; // GetDeliveryCountry
Procedure TInvoice.SetDeliveryCountry (Value : cuStr2);
Begin // SetDeliveryCountry
  If (RecAccess <> NotAvailable) And (PropAccess[idxDeliveryCountry] = paReadWrite) Then
  Begin
    If (DataRec.thDeliveryCountry <> Value) Then
    Begin
      // Must be a valid country code if any other part of the delivery address is set
      // Can be blank if the Delivery Address is not set
      If ValidCountryCode (ifCountry2, Value)
         Or
         (
           (Trim(Value) = '')
           And
           (Trim(DataRec.DAddr[1]) = '') And (Trim(DataRec.DAddr[2]) = '') And
           (Trim(DataRec.DAddr[3]) = '') And (Trim(DataRec.DAddr[4]) = '') And
           (Trim(DataRec.DAddr[5]) = '') And (Trim(DataRec.thDeliveryPostCode) = '')
         ) Then
      Begin
        DataRec.thDeliveryCountry := Value;
        RecChanged := True;
      End // If ValidCountryCode (ifCountry2, Value) Or ...
      Else
        Entsys.CustomException (InvErrStr + 'DeliveryCountry');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'thDeliveryCountry');
End; // SetDeliveryCountry

//-------------------------------------------------------------------------

// MH 20/01/2016 Exch2016-R1: Intrastat enhancements - TAbsInvoice12
Function TInvoice.GetIntrastatOutOfPeriod : Boolean;
Begin // GetIntrastatOutOfPeriod
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thIntrastatOutOfPeriod
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thIntrastatOutOfPeriod');
  End; { Else }
End; // GetIntrastatOutOfPeriod
Procedure TInvoice.SetIntrastatOutOfPeriod (Value : Boolean);
Begin // SetIntrastatOutOfPeriod
  // Currently read-only - Set method added just in case...
  EntSys.DataAccessErrDlg(False, InvErrStr + 'thIntrastatOutOfPeriod');
End; // SetIntrastatOutOfPeriod

//-------------------------------------------------------------------------

// MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
Function TInvoice.GetUser11 : cuStr30;
Begin // GetUser11
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thUserField11
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User11');
  End; { Else }
End; // GetUser11
Procedure TInvoice.SetUser11 (Value : cuStr30);
Begin // SetUser11
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef11] = paReadWrite) Then
  Begin
    If (DataRec.thUserField11 <> Value) Then
    Begin
      DataRec.thUserField11 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User11');
End; // SetUser11

//-----------------------------------

Function TInvoice.GetUser12 : cuStr30;
Begin // GetUser12
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thUserField12
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'User12');
  End; { Else }
End; // GetUser12
Procedure TInvoice.SetUser12 (Value : cuStr30);
Begin // SetUser12
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef12] = paReadWrite) Then
  Begin
    If (DataRec.thUserField12 <> Value) Then
    Begin
      DataRec.thUserField12 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvErrStr + 'User12');
End; // SetUser12

//-----------------------------------

//RB 22/11/2017 2018-R1 ABSEXCH-19400: GDPR (POST 19347) - 8.3.1.1.1 - DLL + COM Customisation Support
function TInvoice.GetAnonymised: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thAnonymised
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thAnonymised');
  End; { Else }
end;
procedure TInvoice.SetAnonymised(aValue: Boolean);
begin
  //Currently Read-Only
  EntSys.DataAccessErrDlg(False, InvErrStr + 'thAnonymised');
end;

//-----------------------------------

function TInvoice.GetAnonymisedDate: cuStr8;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thAnonymisedDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thAnonymisedDate');
  End; { Else }
end;
procedure TInvoice.SetAnonymisedDate(aValue: cuStr8);
begin
  EntSys.DataAccessErrDlg(False, InvErrStr + 'thAnonymisedDate');
end;

//-----------------------------------

function TInvoice.GetAnonymisedTime: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.thAnonymisedTime
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvErrStr + 'thAnonymisedTime');
  End; { Else }
end;
procedure TInvoice.SetAnonymisedTime(aValue: cuStr6);
begin
  EntSys.DataAccessErrDlg(False, InvErrStr + 'thAnonymisedTime');
end;

//=========================================================================

End.
