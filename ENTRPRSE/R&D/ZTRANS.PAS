unit ZTrans;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU, ZLines;

type
  TCOMTransaction = class(TAutoIntfObject, ICOMTransaction, ICOMTransaction2, ICOMTransaction3,
                          ICOMTransaction4, ICOMTransaction5, ICOMTransaction6, ICOMTransaction7,
                          ICOMTransaction8, ICOMTransaction9, ICOMTransaction10, ICOMTransaction11,
                          ICOMTransaction12, ICOMTransaction13, ICOMTransaction14)
  private
    FEntSysObj : TEnterpriseSystem;

    FTransLinesO : TCOMTransactionLines;
    FTransLinesI : ICOMTransactionLines;
  protected
    function  LinkToCust: WordBool; safecall;
    function  Get_AccessRights: TRecordAccessStatus; safecall;
    function  Get_DataChanged: WordBool; safecall;
    function  Get_thRunNo: Integer; safecall;
    procedure Set_thRunNo(Value: Integer); safecall;
    function  Get_thAcCode: WideString; safecall;
    procedure Set_thAcCode(const Value: WideString); safecall;
    function  Get_thNomAuto: WordBool; safecall;
    procedure Set_thNomAuto(Value: WordBool); safecall;
    function  Get_thOurRef: WideString; safecall;
    procedure Set_thOurRef(const Value: WideString); safecall;
    function  Get_thFolioNum: Integer; safecall;
    procedure Set_thFolioNum(Value: Integer); safecall;
    function  Get_thCurrency: Smallint; safecall;
    procedure Set_thCurrency(Value: Smallint); safecall;
    function  Get_thYear: Smallint; safecall;
    procedure Set_thYear(Value: Smallint); safecall;
    function  Get_thPeriod: Smallint; safecall;
    procedure Set_thPeriod(Value: Smallint); safecall;
    function  Get_thDueDate: WideString; safecall;
    procedure Set_thDueDate(const Value: WideString); safecall;
    function  Get_thVATPostDate: WideString; safecall;
    procedure Set_thVATPostDate(const Value: WideString); safecall;
    function  Get_thTransDate: WideString; safecall;
    procedure Set_thTransDate(const Value: WideString); safecall;
    function  Get_thCustSupp: WideString; safecall;
    function  Get_thCompanyRate: Double; safecall;
    procedure Set_thCompanyRate(Value: Double); safecall;
    function  Get_thDailyRate: Double; safecall;
    procedure Set_thDailyRate(Value: Double); safecall;
    function  Get_thYourRef: WideString; safecall;
    procedure Set_thYourRef(const Value: WideString); safecall;
    function  Get_thBatchLink: WideString; safecall;
    procedure Set_thBatchLink(const Value: WideString); safecall;
    function  Get_thAllocStat: WideString; safecall;
    procedure Set_thAllocStat(const Value: WideString); safecall;
    function  Get_thInvNetVal: Double; safecall;
    function  Get_thInvVat: Double; safecall;
    function  Get_thDiscSetl: Double; safecall;
    procedure Set_thDiscSetl(Value: Double); safecall;
    function  Get_thDiscSetAm: Double; safecall;
    procedure Set_thDiscSetAm(Value: Double); safecall;
    function  Get_thDiscAmount: Double; safecall;
    procedure Set_thDiscAmount(Value: Double); safecall;
    function  Get_thDiscDays: Smallint; safecall;
    procedure Set_thDiscDays(Value: Smallint); safecall;
    function  Get_thDiscTaken: WordBool; safecall;
    procedure Set_thDiscTaken(Value: WordBool); safecall;
    function  Get_thSettled: Double; safecall;
    procedure Set_thSettled(Value: Double); safecall;
    function  Get_thAutoInc: Smallint; safecall;
    procedure Set_thAutoInc(Value: Smallint); safecall;
    function  Get_thNextAutoYr: Smallint; safecall;
    procedure Set_thNextAutoYr(Value: Smallint); safecall;
    function  Get_thNextAutoPr: Smallint; safecall;
    procedure Set_thNextAutoPr(Value: Smallint); safecall;
    function  Get_thTransNat: Smallint; safecall;
    procedure Set_thTransNat(Value: Smallint); safecall;
    function  Get_thTransMode: Smallint; safecall;
    procedure Set_thTransMode(Value: Smallint); safecall;
    function  Get_thRemitNo: WideString; safecall;
    procedure Set_thRemitNo(const Value: WideString); safecall;
    function  Get_thAutoIncBy: WideString; safecall;
    procedure Set_thAutoIncBy(const Value: WideString); safecall;
    function  Get_thHoldFlg: Smallint; safecall;
    procedure Set_thHoldFlg(Value: Smallint); safecall;
    function  Get_thAuditFlg: WordBool; safecall;
    procedure Set_thAuditFlg(Value: WordBool); safecall;
    function  Get_thTotalWeight: Double; safecall;
    procedure Set_thTotalWeight(Value: Double); safecall;
    function  Get_thVariance: Double; safecall;
    procedure Set_thVariance(Value: Double); safecall;
    function  Get_thTotalOrdered: Double; safecall;
    procedure Set_thTotalOrdered(Value: Double); safecall;
    function  Get_thTotalReserved: Double; safecall;
    procedure Set_thTotalReserved(Value: Double); safecall;
    function  Get_thTotalCost: Double; safecall;
    procedure Set_thTotalCost(Value: Double); safecall;
    function  Get_thTotalInvoiced: Double; safecall;
    procedure Set_thTotalInvoiced(Value: Double); safecall;
    function  Get_thTransDesc: WideString; safecall;
    procedure Set_thTransDesc(const Value: WideString); safecall;
    function  Get_thAutoUntilDate: WideString; safecall;
    procedure Set_thAutoUntilDate(const Value: WideString); safecall;
    function  Get_thExternal: WordBool; safecall;
    procedure Set_thExternal(Value: WordBool); safecall;
    function  Get_thPrinted: WordBool; safecall;
    procedure Set_thPrinted(Value: WordBool); safecall;
    function  Get_thCurrVariance: Double; safecall;
    procedure Set_thCurrVariance(Value: Double); safecall;
    function  Get_thCurrSettled: Double; safecall;
    procedure Set_thCurrSettled(Value: Double); safecall;
    function  Get_thSettledVAT: Double; safecall;
    procedure Set_thSettledVAT(Value: Double); safecall;
    function  Get_thVATClaimed: Double; safecall;
    procedure Set_thVATClaimed(Value: Double); safecall;
    function  Get_thBatchPayGL: Integer; safecall;
    procedure Set_thBatchPayGL(Value: Integer); safecall;
    function  Get_thAutoPost: WordBool; safecall;
    procedure Set_thAutoPost(Value: WordBool); safecall;
    function  Get_thManualVAT: WordBool; safecall;
    procedure Set_thManualVAT(Value: WordBool); safecall;
    function  Get_thSSDDelTerms: WideString; safecall;
    procedure Set_thSSDDelTerms(const Value: WideString); safecall;
    function  Get_thUser: WideString; safecall;
    procedure Set_thUser(const Value: WideString); safecall;
    function  Get_thNoLabels: Smallint; safecall;
    procedure Set_thNoLabels(Value: Smallint); safecall;
    function  Get_thTagged: WordBool; safecall;
    procedure Set_thTagged(Value: WordBool); safecall;
    function  Get_thPickRunNo: Integer; safecall;
    procedure Set_thPickRunNo(Value: Integer); safecall;
    function  Get_thOrdMatch: WordBool; safecall;
    procedure Set_thOrdMatch(Value: WordBool); safecall;
    function  Get_thDeliveryNote: WideString; safecall;
    procedure Set_thDeliveryNote(const Value: WideString); safecall;
    function  Get_thVATCompanyRate: Double; safecall;
    procedure Set_thVATCompanyRate(Value: Double); safecall;
    function  Get_thVATDailyRate: Double; safecall;
    procedure Set_thVATDailyRate(Value: Double); safecall;
    function  Get_thPostCompanyRate: Double; safecall;
    procedure Set_thPostCompanyRate(Value: Double); safecall;
    function  Get_thPostDailyRate: Double; safecall;
    procedure Set_thPostDailyRate(Value: Double); safecall;
    function  Get_thPostDiscAm: Double; safecall;
    procedure Set_thPostDiscAm(Value: Double); safecall;
    function  Get_thPostedDiscTaken: WordBool; safecall;
    procedure Set_thPostedDiscTaken(Value: WordBool); safecall;
    function  Get_thDrCrGL: Integer; safecall;
    procedure Set_thDrCrGL(Value: Integer); safecall;
    function  Get_thJobCode: WideString; safecall;
    procedure Set_thJobCode(const Value: WideString); safecall;
    function  Get_thJobAnal: WideString; safecall;
    procedure Set_thJobAnal(const Value: WideString); safecall;
    function  Get_thTotOrderOS: Double; safecall;
    procedure Set_thTotOrderOS(Value: Double); safecall;
    function  Get_thUser1: WideString; safecall;
    procedure Set_thUser1(const Value: WideString); safecall;
    function  Get_thUser2: WideString; safecall;
    procedure Set_thUser2(const Value: WideString); safecall;
    function  Get_thLastLetter: Smallint; safecall;
    procedure Set_thLastLetter(Value: Smallint); safecall;
    function  Get_thUnTagged: WordBool; safecall;
    procedure Set_thUnTagged(Value: WordBool); safecall;
    function  Get_thUser3: WideString; safecall;
    procedure Set_thUser3(const Value: WideString); safecall;
    function  Get_thUser4: WideString; safecall;
    procedure Set_thUser4(const Value: WideString); safecall;
    function  Get_thInvVATAnal(Index: TVATIndex): Double; safecall;
    procedure Set_thInvVATAnal(Index: TVATIndex; Value: Double); safecall;
    function  Get_thDelAddr(Index: Integer): WideString; safecall;
    procedure Set_thDelAddr(Index: Integer; const Value: WideString); safecall;
    function  Get_thDocLSplit(Index: Integer): Double; safecall;
    procedure Set_thDocLSplit(Index: Integer; Value: Double); safecall;
    function  Get_thInvDocHed: TDocTypes; safecall;
    procedure Set_thInvDocHed(Value: TDocTypes); safecall;
    function  Get_thLines: ICOMTransactionLines; safecall;

    // ICOMTransaction2 properties
    function Get_thTagNo: Integer; safecall;
    procedure Set_thTagNo(Value: Integer); safecall;

    // ICOMTransaction3
    function Get_thCISTaxDue: Double; safecall;
    procedure Set_thCISTaxDue(Value: Double); safecall;
    function Get_thCISTaxDeclared: Double; safecall;
    procedure Set_thCISTaxDeclared(Value: Double); safecall;
    function Get_thCISManualTax: WordBool; safecall;
    procedure Set_thCISManualTax(Value: WordBool); safecall;
    function Get_thCISDate: WideString; safecall;
    procedure Set_thCISDate(const Value: WideString); safecall;
    function Get_thCISEmployee: WideString; safecall;
    procedure Set_thCISEmployee(const Value: WideString); safecall;
    function Get_thCISTotalGross: Double; safecall;
    procedure Set_thCISTotalGross(Value: Double); safecall;
    function Get_thCISSource: Integer; safecall;
    procedure Set_thCISSource(Value: Integer); safecall;
    function Get_thTotalCostApport: Double; safecall;
    procedure Set_thTotalCostApport(Value: Double); safecall;

    // HM 04/06/03: ICOMTransaction4
    function Get_thNOMVATIO: TNOMVATIOType; safecall;
    procedure Set_thNOMVATIO(Value: TNOMVATIOType); safecall;

    // HM 23/03/04: ICOMTransaction5
    function Get_thTSHExported: WordBool; safecall;
    procedure Set_thTSHExported(Value: WordBool); safecall;

    // HM 02/02/10 (v6.3): Added ICOMTransaction6 for Web Extensions fields
    function Get_thWeekMonth: Integer; safecall;
    procedure Set_thWeekMonth(Value: Integer); safecall;
    function Get_thWorkflowState: Integer; safecall;
    procedure Set_thWorkflowState(Value: Integer); safecall;

    // MH 12/10/2010 (v6.5): Aded ICOMTransaction7 for Override Location field
    function Get_thOverrideLocation: WideString; safecall;
    procedure Set_thOverrideLocation(const Value: WideString); safecall;

    // ICOMTransaction8 v6.9
    function Get_thUser5: WideString; safecall;
    procedure Set_thUser5(const Value: WideString); safecall;
    function Get_thUser6: WideString; safecall;
    procedure Set_thUser6(const Value: WideString); safecall;
    function Get_thUser7: WideString; safecall;
    procedure Set_thUser7(const Value: WideString); safecall;
    function Get_thUser8: WideString; safecall;
    procedure Set_thUser8(const Value: WideString); safecall;
    function Get_thUser9: WideString; safecall;
    procedure Set_thUser9(const Value: WideString); safecall;
    function Get_thUser10: WideString; safecall;
    procedure Set_thUser10(const Value: WideString); safecall;

    // ICOMTransaction9  MH 15/10/2013 v7.0.7
    function Get_thDeliveryPostCode: WideString; safecall;
    procedure Set_thDeliveryPostCode(const Value: WideString); safecall;
    function Get_thOriginator: WideString; safecall;
    procedure Set_thOriginator(const Value: WideString); safecall;
    function Get_thCreationTime: WideString; safecall;
    procedure Set_thCreationTime(const Value: WideString); safecall;
    function Get_thCreationDate: WideString; safecall;
    procedure Set_thCreationDate(const Value: WideString); safecall;

    // ICOMTransaction10  MH 11/05/2015 ABSEXCH-16419: Merged customisation changes from v7.0.14
    function Get_thPPDPercentage: Double; safecall;
    procedure Set_thPPDPercentage(Value: Double); safecall;
    function Get_thPPDDays: Smallint; safecall;
    procedure Set_thPPDDays(Value: Smallint); safecall;
    function Get_thPPDGoodsValue: Double; safecall;
    procedure Set_thPPDGoodsValue(Value: Double); safecall;
    function Get_thPPDVATValue: Double; safecall;
    procedure Set_thPPDVATValue(Value: Double); safecall;
    function Get_thPPDTakenStatus: TTransactionPPDTakenStatus; safecall;
    procedure Set_thPPDTakenStatus(Value: TTransactionPPDTakenStatus); safecall;
    function Get_thPPDCreditNote: WordBool; safecall;
    procedure Set_thPPDCreditNote(Value: WordBool); safecall;
    function Get_thBatchPayPPDStatus: Integer; safecall;
    procedure Set_thBatchPayPPDStatus(Value: Integer); safecall;

    // ICOMTransaction11  MH 22/09/2014 Order Payments
    function Get_thOrderPaymentOrderRef: WideString; safecall;
    function Get_thOrderPaymentElement: TTransactionOrderPaymentElement; safecall;
    function Get_thOrderPaymentFlags: Integer; safecall;
    function Get_thCreditCardType: WideString; safecall;
    procedure Set_thCreditCardType(const Value: WideString); safecall;
    function Get_thCreditCardNumber: WideString; safecall;
    procedure Set_thCreditCardNumber(const Value: WideString); safecall;
    function Get_thCreditCardExpiry: WideString; safecall;
    procedure Set_thCreditCardExpiry(const Value: WideString); safecall;
    function Get_thCreditCardAuthorisationNo: WideString; safecall;
    procedure Set_thCreditCardAuthorisationNo(const Value: WideString); safecall;
    function Get_thCreditCardReferenceNo: WideString; safecall;
    procedure Set_thCreditCardReferenceNo(const Value: WideString); safecall;
    function Get_thCustomData1: WideString; safecall;
    procedure Set_thCustomData1(const Value: WideString); safecall;

    // ICOMTransaction11 MH 26/11/2014 ABSEXCH-15836: Added Country Codes
    function Get_thDeliveryCountry: WideString; safecall;
    procedure Set_thDeliveryCountry(const Value: WideString); safecall;

    // MH 20/01/2016 Exch2016-R1: Intrastat enhancements - ICOMTransaction12
    function Get_thIntrastatOutOfPeriod: WordBool; safecall;
    procedure Set_thIntrastatOutOfPeriod(Value: WordBool); safecall;

    // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
    function Get_thUser11: WideString; safecall;
    procedure Set_thUser11(const Value: WideString); safecall;
    function Get_thUser12: WideString; safecall;
    procedure Set_thUser12(const Value: WideString); safecall;

    //RB 22/11/2017 2018-R1 ABSEXCH-19400: GDPR (POST 19347) - 8.3.1.1.1 - DLL + COM Customisation Support
    function Get_thAnonymised: WordBool; safecall;
    procedure Set_thAnonymised(Value: WordBool); safecall;
    function Get_thAnonymisedDate: WideString; safecall;
    procedure Set_thAnonymisedDate(const Value: WideString); safecall;
    function Get_thAnonymisedTime: WideString; safecall;
    procedure Set_thAnonymisedTime(const Value: WideString); safecall;

  public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure InitTrans(EntSysObj : TEnterpriseSystem);
  End; { TCOMTransaction }

implementation

uses ComServ, CustIntU, ZUtils;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMTransaction.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMTransaction14);

End; { Create }

{-----------------------------------------}

Destructor TCOMTransaction.Destroy;
Begin { Destroy }
  FTransLinesO := Nil;
  FTransLinesI := Nil; { Setting Interface to Nil will cause Destroy }

  Inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TCOMTransaction.InitTrans(EntSysObj : TEnterpriseSystem);
Begin { InitTrans }
  FEntSysObj := EntSysObj;

  If Assigned(FTransLinesO) Then
    FTransLinesO.InitLines(EntSysObj);
End; { InitTrans }

{-----------------------------------------}

function TCOMTransaction.LinkToCust: WordBool;
Begin { LinkToCust }
  Result := FEntSysObj.Transaction.LinkToCust;
End; { LinkToCust }

{-----------------------------------------}

function TCOMTransaction.Get_AccessRights: TRecordAccessStatus;
Begin { Get_AccessRights }
  Result := Ord(FEntSysObj.Transaction.AccessRights);
End; { Get_AccessRights }

{-----------------------------------------}

function TCOMTransaction.Get_DataChanged: WordBool;
Begin { Get_DataChanged }
  Result := FEntSysObj.Transaction.DataChanged;
End; { Get_DataChanged }

{-----------------------------------------}

function TCOMTransaction.Get_thRunNo: Integer;
Begin { Get_thRunNo }
  Result := FEntSysObj.Transaction.thRunNo;
End; { Get_thRunNo }

procedure TCOMTransaction.Set_thRunNo(Value: Integer);
Begin { Set_thRunNo }
  FEntSysObj.Transaction.thRunNo := Value;
End; { Set_thRunNo }

{-----------------------------------------}

function TCOMTransaction.Get_thAcCode: WideString;
Begin { Get_thAcCode }
  Result := FEntSysObj.Transaction.thAcCode;
End; { Get_thAcCode }

procedure TCOMTransaction.Set_thAcCode(const Value: WideString);
Begin { Set_thAcCode }
  FEntSysObj.Transaction.thAcCode := Value;
End; { Set_thAcCode }

{-----------------------------------------}

function TCOMTransaction.Get_thNomAuto: WordBool;
Begin { Get_thNomAuto }
  Result := FEntSysObj.Transaction.thNomAuto;
End; { Get_thNomAuto }

procedure TCOMTransaction.Set_thNomAuto(Value: WordBool);
Begin { Set_thNomAuto }
  FEntSysObj.Transaction.thNomAuto := Value;
End; { Set_thNomAuto }

{-----------------------------------------}

function TCOMTransaction.Get_thOurRef: WideString;
Begin { Get_thOurRef }
  Result := FEntSysObj.Transaction.thOurRef;
End; { Get_thOurRef }

procedure TCOMTransaction.Set_thOurRef(const Value: WideString);
Begin { Set_thOurRef }
  FEntSysObj.Transaction.thOurRef := Value;
End; { Set_thOurRef }

{-----------------------------------------}

function TCOMTransaction.Get_thFolioNum: Integer;
Begin { Get_thFolioNum }
  Result := FEntSysObj.Transaction.thFolioNum;
End; { Get_thFolioNum }

procedure TCOMTransaction.Set_thFolioNum(Value: Integer);
Begin { Set_thFolioNum }
  FEntSysObj.Transaction.thFolioNum := Value;
End; { Set_thFolioNum }

{-----------------------------------------}

function TCOMTransaction.Get_thCurrency: SmallInt;
Begin { Get_thCurrency }
  Result := FEntSysObj.Transaction.thCurrency;
End; { Get_thCurrency }

procedure TCOMTransaction.Set_thCurrency(Value: SmallInt);
Begin { Set_thCurrency }
  FEntSysObj.Transaction.thCurrency := Value;
End; { Set_thCurrency }

{-----------------------------------------}

function TCOMTransaction.Get_thYear: SmallInt;
Begin { Get_thYear }
  Result := FEntSysObj.Transaction.thYear;
End; { Get_thYear }

procedure TCOMTransaction.Set_thYear(Value: SmallInt);
Begin { Set_thYear }
  FEntSysObj.Transaction.thYear := Value;
End; { Set_thYear }

{-----------------------------------------}

function TCOMTransaction.Get_thPeriod: SmallInt;
Begin { Get_thPeriod }
  Result := FEntSysObj.Transaction.thPeriod;
End; { Get_thPeriod }

procedure TCOMTransaction.Set_thPeriod(Value: SmallInt);
Begin { Set_thPeriod }
  FEntSysObj.Transaction.thPeriod := Value;
End; { Set_thPeriod }

{-----------------------------------------}

function TCOMTransaction.Get_thDueDate: WideString;
Begin { Get_thDueDate }
  Result := FEntSysObj.Transaction.thDueDate;
End; { Get_thDueDate }

procedure TCOMTransaction.Set_thDueDate(const Value: WideString);
Begin { Set_thDueDate }
  FEntSysObj.Transaction.thDueDate := Value;
End; { Set_thDueDate }

{-----------------------------------------}

function TCOMTransaction.Get_thVATPostDate: WideString;
Begin { Get_thVATPostDate }
  Result := FEntSysObj.Transaction.thVATPostDate;
End; { Get_thVATPostDate }

procedure TCOMTransaction.Set_thVATPostDate(const Value: WideString);
Begin { Set_thVATPostDate }
  FEntSysObj.Transaction.thVATPostDate := Value;
End; { Set_thVATPostDate }

{-----------------------------------------}

function TCOMTransaction.Get_thTransDate: WideString;
Begin { Get_thTransDate }
  Result := FEntSysObj.Transaction.thTransDate;
End; { Get_thTransDate }

procedure TCOMTransaction.Set_thTransDate(const Value: WideString);
Begin { Set_thTransDate }
  FEntSysObj.Transaction.thTransDate := Value;
End; { Set_thTransDate }

{-----------------------------------------}

function TCOMTransaction.Get_thCustSupp: WideString;
Begin { Get_thCustSupp }
  Result := FEntSysObj.Transaction.thCustSupp;
End; { Get_thCustSupp }

{-----------------------------------------}

function TCOMTransaction.Get_thCompanyRate: Double;
Begin { Get_thCompanyRate }
  Result := FEntSysObj.Transaction.thCompanyRate;
End; { Get_thCompanyRate }

procedure TCOMTransaction.Set_thCompanyRate(Value: Double);
Begin { Set_thCompanyRate }
  FEntSysObj.Transaction.thCompanyRate := Value;
End; { Set_thCompanyRate }

{-----------------------------------------}

function TCOMTransaction.Get_thDailyRate: Double;
Begin { Get_thDailyRate }
  Result := FEntSysObj.Transaction.thDailyRate;
End; { Get_thDailyRate }

procedure TCOMTransaction.Set_thDailyRate(Value: Double);
Begin { Set_thDailyRate }
  FEntSysObj.Transaction.thDailyRate := Value;
End; { Set_thDailyRate }

{-----------------------------------------}

function TCOMTransaction.Get_thYourRef: WideString;
Begin { Get_thYourRef }
  // MH 05/03/2014 v7.0.9 ABSEXCH-10398: Redirected to the correct 20 character YourRef field
  Result := TAbsInvoice5(FEntSysObj.Transaction).thYourRef20;
End; { Get_thYourRef }

procedure TCOMTransaction.Set_thYourRef(const Value: WideString);
Begin { Set_thYourRef }
  // MH 05/03/2014 v7.0.9 ABSEXCH-10398: Redirected to the correct 20 character YourRef field
  TAbsInvoice5(FEntSysObj.Transaction).thYourRef20 := Value;
End; { Set_thYourRef }

{-----------------------------------------}

function TCOMTransaction.Get_thBatchLink: WideString;
Begin { Get_thBatchLink }
  Result := FEntSysObj.Transaction.thBatchLink;
End; { Get_thBatchLink }

procedure TCOMTransaction.Set_thBatchLink(const Value: WideString);
Begin { Set_thBatchLink }
  FEntSysObj.Transaction.thBatchLink := Value;
End; { Set_thBatchLink }

{-----------------------------------------}

function TCOMTransaction.Get_thAllocStat: WideString;
Begin { Get_thAllocStat }
  Result := FEntSysObj.Transaction.thAllocStat;
End; { Get_thAllocStat }

procedure TCOMTransaction.Set_thAllocStat(const Value: WideString);
Begin { Set_thAllocStat }
  FEntSysObj.Transaction.thAllocStat := WideStrToChar (Value, ' ');
End; { Set_thAllocStat }

{-----------------------------------------}

function TCOMTransaction.Get_thInvDocHed: TDocTypes;
Begin { Get_thInvDocHed }
  Result := Ord(FEntSysObj.Transaction.thInvDocHed);
End; { Get_thInvDocHed }

procedure TCOMTransaction.Set_thInvDocHed(Value: TDocTypes);
Var
  Doc : cuDocTypes;
Begin { Set_thInvDocHed }
  Doc := cuDocTypes(Ord(Value));
  FEntSysObj.Transaction.thInvDocHed := Doc;
End; { Set_thInvDocHed }

{-----------------------------------------}

function TCOMTransaction.Get_thInvNetVal: Double;
Begin { Get_thInvNetVal }
  Result := FEntSysObj.Transaction.thInvNetVal;
End; { Get_thInvNetVal }

{-----------------------------------------}

function TCOMTransaction.Get_thInvVat: Double;
Begin { Get_thInvVat }
  Result := FEntSysObj.Transaction.thInvVat;
End; { Get_thInvVat }

{-----------------------------------------}

function TCOMTransaction.Get_thDiscSetl: Double;
Begin { Get_thDiscSetl }
  Result := FEntSysObj.Transaction.thDiscSetl;
End; { Get_thDiscSetl }

procedure TCOMTransaction.Set_thDiscSetl(Value: Double);
Begin { Set_thDiscSetl }
  FEntSysObj.Transaction.thDiscSetl := Value;
End; { Set_thDiscSetl }

{-----------------------------------------}

function TCOMTransaction.Get_thDiscSetAm: Double;
Begin { Get_thDiscSetAm }
  Result := FEntSysObj.Transaction.thDiscSetAm;
End; { Get_thDiscSetAm }

procedure TCOMTransaction.Set_thDiscSetAm(Value: Double);
Begin { Set_thDiscSetAm }
  FEntSysObj.Transaction.thDiscSetAm := Value;
End; { Set_thDiscSetAm }

{-----------------------------------------}

function TCOMTransaction.Get_thDiscAmount: Double;
Begin { Get_thDiscAmount }
  Result := FEntSysObj.Transaction.thDiscAmount;
End; { Get_thDiscAmount }

procedure TCOMTransaction.Set_thDiscAmount(Value: Double);
Begin { Set_thDiscAmount }
  FEntSysObj.Transaction.thDiscAmount := Value;
End; { Set_thDiscAmount }

{-----------------------------------------}

function TCOMTransaction.Get_thDiscDays: SmallInt;
Begin { Get_thDiscDays }
  Result := FEntSysObj.Transaction.thDiscDays;
End; { Get_thDiscDays }

procedure TCOMTransaction.Set_thDiscDays(Value: SmallInt);
Begin { Set_thDiscDays }
  FEntSysObj.Transaction.thDiscDays := Value;
End; { Set_thDiscDays }

{-----------------------------------------}

function TCOMTransaction.Get_thDiscTaken: WordBool;
Begin { Get_thDiscTaken }
  Result := FEntSysObj.Transaction.thDiscTaken;
End; { Get_thDiscTaken }

procedure TCOMTransaction.Set_thDiscTaken(Value: WordBool);
Begin { Set_thDiscTaken }
  FEntSysObj.Transaction.thDiscTaken := Value;
End; { Set_thDiscTaken }

{-----------------------------------------}

function TCOMTransaction.Get_thSettled: Double;
Begin { Get_thSettled }
  Result := FEntSysObj.Transaction.thSettled;
End; { Get_thSettled }

procedure TCOMTransaction.Set_thSettled(Value: Double);
Begin { Set_thSettled }
  FEntSysObj.Transaction.thSettled := Value;
End; { Set_thSettled }

{-----------------------------------------}

function TCOMTransaction.Get_thAutoInc: SmallInt;
Begin { Get_thAutoInc }
  Result := FEntSysObj.Transaction.thAutoInc;
End; { Get_thAutoInc }

procedure TCOMTransaction.Set_thAutoInc(Value: SmallInt);
Begin { Set_thAutoInc }
  FEntSysObj.Transaction.thAutoInc := Value;
End; { Set_thAutoInc }

{-----------------------------------------}

function TCOMTransaction.Get_thNextAutoYr: SmallInt;
Begin { Get_thNextAutoYr }
  Result := FEntSysObj.Transaction.thNextAutoYr;
End; { Get_thNextAutoYr }

procedure TCOMTransaction.Set_thNextAutoYr(Value: SmallInt);
Begin { Set_thNextAutoYr }
  FEntSysObj.Transaction.thNextAutoYr := Value;
End; { Set_thNextAutoYr }

{-----------------------------------------}

function TCOMTransaction.Get_thNextAutoPr: SmallInt;
Begin { Get_thNextAutoPr }
  Result := FEntSysObj.Transaction.thNextAutoPr;
End; { Get_thNextAutoPr }

procedure TCOMTransaction.Set_thNextAutoPr(Value: SmallInt);
Begin { Set_thNextAutoPr }
  FEntSysObj.Transaction.thNextAutoPr := Value;
End; { Set_thNextAutoPr }

{-----------------------------------------}

function TCOMTransaction.Get_thTransNat: SmallInt;
Begin { Get_thTransNat }
  Result := FEntSysObj.Transaction.thTransNat;
End; { Get_thTransNat }

procedure TCOMTransaction.Set_thTransNat(Value: SmallInt);
Begin { Set_thTransNat }
  FEntSysObj.Transaction.thTransNat := Value;
End; { Set_thTransNat }

{-----------------------------------------}

function TCOMTransaction.Get_thTransMode: SmallInt;
Begin { Get_thTransMode }
  Result := FEntSysObj.Transaction.thTransMode;
End; { Get_thTransMode }

procedure TCOMTransaction.Set_thTransMode(Value: SmallInt);
Begin { Set_thTransMode }
  FEntSysObj.Transaction.thTransMode := Value;
End; { Set_thTransMode }

{-----------------------------------------}

function TCOMTransaction.Get_thRemitNo: WideString;
Begin { Get_thRemitNo }
  Result := FEntSysObj.Transaction.thRemitNo;
End; { Get_thRemitNo }

procedure TCOMTransaction.Set_thRemitNo(Const Value: WideString);
Begin { Set_thRemitNo }
  FEntSysObj.Transaction.thRemitNo := Value;
End; { Set_thRemitNo }

{-----------------------------------------}

function TCOMTransaction.Get_thAutoIncBy: WideString;
Begin { Get_thAutoIncBy }
  Result := FEntSysObj.Transaction.thAutoIncBy;
End; { Get_thAutoIncBy }

procedure TCOMTransaction.Set_thAutoIncBy(const Value: WideString);
Begin { Set_thAutoIncBy }
  FEntSysObj.Transaction.thAutoIncBy := WideStrToChar (Value, ' ');
End; { Set_thAutoIncBy }

{-----------------------------------------}

function TCOMTransaction.Get_thHoldFlg: SmallInt;
Begin { Get_thHoldFlg }
  Result := FEntSysObj.Transaction.thHoldFlg;
End; { Get_thHoldFlg }

procedure TCOMTransaction.Set_thHoldFlg(Value: SmallInt);
Begin { Set_thHoldFlg }
  FEntSysObj.Transaction.thHoldFlg := Value;
End; { Set_thHoldFlg }

{-----------------------------------------}

function TCOMTransaction.Get_thAuditFlg: WordBool;
Begin { Get_thAuditFlg }
  Result := FEntSysObj.Transaction.thAuditFlg;
End; { Get_thAuditFlg }

procedure TCOMTransaction.Set_thAuditFlg(Value: WordBool);
Begin { Set_thAuditFlg }
  FEntSysObj.Transaction.thAuditFlg := Value;
End; { Set_thAuditFlg }

{-----------------------------------------}

function TCOMTransaction.Get_thTotalWeight: Double;
Begin { Get_thTotalWeight }
  Result := FEntSysObj.Transaction.thTotalWeight;
End; { Get_thTotalWeight }

procedure TCOMTransaction.Set_thTotalWeight(Value: Double);
Begin { Set_thTotalWeight }
  FEntSysObj.Transaction.thTotalWeight := Value;
End; { Set_thTotalWeight }

{-----------------------------------------}

function TCOMTransaction.Get_thVariance: Double;
Begin { Get_thVariance }
  Result := FEntSysObj.Transaction.thVariance;
End; { Get_thVariance }

procedure TCOMTransaction.Set_thVariance(Value: Double);
Begin { Set_thVariance }
  FEntSysObj.Transaction.thVariance := Value;
End; { Set_thVariance }

{-----------------------------------------}

function TCOMTransaction.Get_thTotalOrdered: Double;
Begin { Get_thTotalOrdered }
  Result := FEntSysObj.Transaction.thTotalOrdered;
End; { Get_thTotalOrdered }

procedure TCOMTransaction.Set_thTotalOrdered(Value: Double);
Begin { Set_thTotalOrdered }
  FEntSysObj.Transaction.thTotalOrdered := Value;
End; { Set_thTotalOrdered }

{-----------------------------------------}

function TCOMTransaction.Get_thTotalReserved: Double;
Begin { Get_thTotalReserved }
  Result := FEntSysObj.Transaction.thTotalReserved;
End; { Get_thTotalReserved }

procedure TCOMTransaction.Set_thTotalReserved(Value: Double);
Begin { Set_thTotalReserved }
  FEntSysObj.Transaction.thTotalReserved := Value;
End; { Set_thTotalReserved }

{-----------------------------------------}

function TCOMTransaction.Get_thTotalCost: Double;
Begin { Get_thTotalCost }
  Result := FEntSysObj.Transaction.thTotalCost;
End; { Get_thTotalCost }

procedure TCOMTransaction.Set_thTotalCost(Value: Double);
Begin { Set_thTotalCost }
  FEntSysObj.Transaction.thTotalCost := Value;
End; { Set_thTotalCost }

{-----------------------------------------}

function TCOMTransaction.Get_thTotalInvoiced: Double;
Begin { Get_thTotalInvoiced }
  Result := FEntSysObj.Transaction.thTotalInvoiced;
End; { Get_thTotalInvoiced }

procedure TCOMTransaction.Set_thTotalInvoiced(Value: Double);
Begin { Set_thTotalInvoiced }
  FEntSysObj.Transaction.thTotalInvoiced := Value;
End; { Set_thTotalInvoiced }

{-----------------------------------------}

function TCOMTransaction.Get_thTransDesc: WideString;
Begin { Get_thTransDesc }
  Result := FEntSysObj.Transaction.thTransDesc;
End; { Get_thTransDesc }

procedure TCOMTransaction.Set_thTransDesc(const Value: WideString);
Begin { Set_thTransDesc }
  FEntSysObj.Transaction.thTransDesc := Value;
End; { Set_thTransDesc }

{-----------------------------------------}

function TCOMTransaction.Get_thAutoUntilDate: WideString;
Begin { Get_thAutoUntilDate }
  Result := FEntSysObj.Transaction.thAutoUntilDate;
End; { Get_thAutoUntilDate }

procedure TCOMTransaction.Set_thAutoUntilDate(const Value: WideString);
Begin { Set_thAutoUntilDate }
  FEntSysObj.Transaction.thAutoUntilDate := Value;
End; { Set_thAutoUntilDate }

{-----------------------------------------}

function TCOMTransaction.Get_thExternal: WordBool;
Begin { Get_thExternal }
  Result := FEntSysObj.Transaction.thExternal;
End; { Get_thExternal }

procedure TCOMTransaction.Set_thExternal(Value: WordBool);
Begin { Set_thExternal }
  FEntSysObj.Transaction.thExternal := Value;
End; { Set_thExternal }

{-----------------------------------------}

function TCOMTransaction.Get_thPrinted: WordBool;
Begin { Get_thPrinted }
  Result := FEntSysObj.Transaction.thPrinted;
End; { Get_thPrinted }

procedure TCOMTransaction.Set_thPrinted(Value: WordBool);
Begin { Set_thPrinted }
  FEntSysObj.Transaction.thPrinted := Value;
End; { Set_thPrinted }

{-----------------------------------------}

function TCOMTransaction.Get_thCurrVariance: Double;
Begin { Get_thCurrVariance }
  Result := FEntSysObj.Transaction.thCurrVariance;
End; { Get_thCurrVariance }

procedure TCOMTransaction.Set_thCurrVariance(Value: Double);
Begin { Set_thCurrVariance }
  FEntSysObj.Transaction.thCurrVariance := Value;
End; { Set_thCurrVariance }

{-----------------------------------------}

function TCOMTransaction.Get_thCurrSettled: Double;
Begin { Get_thCurrSettled }
  Result := FEntSysObj.Transaction.thCurrSettled;
End; { Get_thCurrSettled }

procedure TCOMTransaction.Set_thCurrSettled(Value: Double);
Begin { Set_thCurrSettled }
  FEntSysObj.Transaction.thCurrSettled := Value;
End; { Set_thCurrSettled }

{-----------------------------------------}

function TCOMTransaction.Get_thSettledVAT: Double;
Begin { Get_thSettledVAT }
  Result := FEntSysObj.Transaction.thSettledVAT;
End; { Get_thSettledVAT }

procedure TCOMTransaction.Set_thSettledVAT(Value: Double);
Begin { Set_thSettledVAT }
  FEntSysObj.Transaction.thSettledVAT := Value;
End; { Set_thSettledVAT }

{-----------------------------------------}

function TCOMTransaction.Get_thVATClaimed: Double;
Begin { Get_thVATClaimed }
  Result := FEntSysObj.Transaction.thVATClaimed;
End; { Get_thVATClaimed }

procedure TCOMTransaction.Set_thVATClaimed(Value: Double);
Begin { Set_thVATClaimed }
  FEntSysObj.Transaction.thVATClaimed := Value;
End; { Set_thVATClaimed }

{-----------------------------------------}

function TCOMTransaction.Get_thBatchPayGL: Integer;
Begin { Get_thBatchPayGL }
  Result := FEntSysObj.Transaction.thBatchPayGL;
End; { Get_thBatchPayGL }

procedure TCOMTransaction.Set_thBatchPayGL(Value: Integer);
Begin { Set_thBatchPayGL }
  FEntSysObj.Transaction.thBatchPayGL := Value;
End; { Set_thBatchPayGL }

{-----------------------------------------}

function TCOMTransaction.Get_thAutoPost: WordBool;
Begin { Get_thAutoPost }
  Result := FEntSysObj.Transaction.thAutoPost;
End; { Get_thAutoPost }

procedure TCOMTransaction.Set_thAutoPost(Value: WordBool);
Begin { Set_thAutoPost }
  FEntSysObj.Transaction.thAutoPost := Value;
End; { Set_thAutoPost }

{-----------------------------------------}

function TCOMTransaction.Get_thManualVAT: WordBool;
Begin { Get_thManualVAT }
  Result := FEntSysObj.Transaction.thManualVAT;
End; { Get_thManualVAT }

procedure TCOMTransaction.Set_thManualVAT(Value: WordBool);
Begin { Set_thManualVAT }
  FEntSysObj.Transaction.thManualVAT := Value;
End; { Set_thManualVAT }

{-----------------------------------------}

function TCOMTransaction.Get_thSSDDelTerms: WideString;
Begin { Get_thSSDDelTerms }
  Result := FEntSysObj.Transaction.thSSDDelTerms;
End; { Get_thSSDDelTerms }

procedure TCOMTransaction.Set_thSSDDelTerms(const Value: WideString);
Begin { Set_thSSDDelTerms }
  FEntSysObj.Transaction.thSSDDelTerms := Value;
End; { Set_thSSDDelTerms }

{-----------------------------------------}

function TCOMTransaction.Get_thUser: WideString;
Begin { Get_thUser }
  Result := FEntSysObj.Transaction.thUser;
End; { Get_thUser }

procedure TCOMTransaction.Set_thUser(const Value: WideString);
Begin { Set_thUser }
  FEntSysObj.Transaction.thUser := Value;
End; { Set_thUser }

{-----------------------------------------}

function TCOMTransaction.Get_thNoLabels: SmallInt;
Begin { Get_thNoLabels }
  Result := FEntSysObj.Transaction.thNoLabels;
End; { Get_thNoLabels }

procedure TCOMTransaction.Set_thNoLabels(Value: SmallInt);
Begin { Set_thNoLabels }
  FEntSysObj.Transaction.thNoLabels := Value;
End; { Set_thNoLabels }

{-----------------------------------------}

function TCOMTransaction.Get_thTagged: WordBool;
Begin { Get_thTagged }
  Result := FEntSysObj.Transaction.thTagged;
End; { Get_thTagged }

procedure TCOMTransaction.Set_thTagged(Value: WordBool);
Begin { Set_thTagged }
  FEntSysObj.Transaction.thTagged := Value;
End; { Set_thTagged }

{-----------------------------------------}

function TCOMTransaction.Get_thPickRunNo: Integer;
Begin { Get_thPickRunNo }
  Result := FEntSysObj.Transaction.thPickRunNo;
End; { Get_thPickRunNo }

procedure TCOMTransaction.Set_thPickRunNo(Value: Integer);
Begin { Set_thPickRunNo }
  FEntSysObj.Transaction.thPickRunNo := Value;
End; { Set_thPickRunNo }

{-----------------------------------------}

function TCOMTransaction.Get_thOrdMatch: WordBool;
Begin { Get_thOrdMatch }
  Result := FEntSysObj.Transaction.thOrdMatch;
End; { Get_thOrdMatch }

procedure TCOMTransaction.Set_thOrdMatch(Value: WordBool);
Begin { Set_thOrdMatch }
  FEntSysObj.Transaction.thOrdMatch := Value;
End; { Set_thOrdMatch }

{-----------------------------------------}

function TCOMTransaction.Get_thDeliveryNote: WideString;
Begin { Get_thDeliveryNote }
  Result := FEntSysObj.Transaction.thDeliveryNote;
End; { Get_thDeliveryNote }

procedure TCOMTransaction.Set_thDeliveryNote(const Value: WideString);
Begin { Set_thDeliveryNote }
  FEntSysObj.Transaction.thDeliveryNote := Value;
End; { Set_thDeliveryNote }

{-----------------------------------------}

function TCOMTransaction.Get_thVATCompanyRate: Double;
Begin { Get_thVATCompanyRate }
  Result := FEntSysObj.Transaction.thVATCompanyRate;
End; { Get_thVATCompanyRate }

procedure TCOMTransaction.Set_thVATCompanyRate(Value: Double);
Begin { Set_thVATCompanyRate }
  FEntSysObj.Transaction.thVATCompanyRate := Value;
End; { Set_thVATCompanyRate }

{-----------------------------------------}

function TCOMTransaction.Get_thVATDailyRate: Double;
Begin { Get_thVATDailyRate }
  Result := FEntSysObj.Transaction.thVATDailyRate;
End; { Get_thVATDailyRate }

procedure TCOMTransaction.Set_thVATDailyRate(Value: Double);
Begin { Set_thVATDailyRate }
  FEntSysObj.Transaction.thVATDailyRate := Value;
End; { Set_thVATDailyRate }

{-----------------------------------------}

function TCOMTransaction.Get_thPostCompanyRate: Double;
Begin { Get_thPostCompanyRate }
  Result := FEntSysObj.Transaction.thPostCompanyRate;
End; { Get_thPostCompanyRate }

procedure TCOMTransaction.Set_thPostCompanyRate(Value: Double);
Begin { Set_thPostCompanyRate }
  FEntSysObj.Transaction.thPostCompanyRate := Value;
End; { Set_thPostCompanyRate }

{-----------------------------------------}

function TCOMTransaction.Get_thPostDailyRate: Double;
Begin { Get_thPostDailyRate }
  Result := FEntSysObj.Transaction.thPostDailyRate;
End; { Get_thPostDailyRate }

procedure TCOMTransaction.Set_thPostDailyRate(Value: Double);
Begin { Set_thPostDailyRate }
  FEntSysObj.Transaction.thPostDailyRate := Value;
End; { Set_thPostDailyRate }

{-----------------------------------------}

function TCOMTransaction.Get_thPostDiscAm: Double;
Begin { Get_thPostDiscAm }
  Result := FEntSysObj.Transaction.thPostDiscAm;
End; { Get_thPostDiscAm }

procedure TCOMTransaction.Set_thPostDiscAm(Value: Double);
Begin { Set_thPostDiscAm }
  FEntSysObj.Transaction.thPostDiscAm := Value;
End; { Set_thPostDiscAm }

{-----------------------------------------}

function TCOMTransaction.Get_thPostedDiscTaken: WordBool;
Begin { Get_thPostedDiscTaken }
  Result := FEntSysObj.Transaction.thPostedDiscTaken;
End; { Get_thPostedDiscTaken }

procedure TCOMTransaction.Set_thPostedDiscTaken(Value: WordBool);
Begin { Set_thPostedDiscTaken }
  FEntSysObj.Transaction.thPostedDiscTaken := Value;
End; { Set_thPostedDiscTaken }

{-----------------------------------------}

function TCOMTransaction.Get_thDrCrGL: Integer;
Begin { Get_thDrCrGL }
  Result := FEntSysObj.Transaction.thDrCrGL;
End; { Get_thDrCrGL }

procedure TCOMTransaction.Set_thDrCrGL(Value: Integer);
Begin { Set_thDrCrGL }
  FEntSysObj.Transaction.thDrCrGL := Value;
End; { Set_thDrCrGL }

{-----------------------------------------}

function TCOMTransaction.Get_thJobCode: WideString;
Begin { Get_thJobCode }
  Result := FEntSysObj.Transaction.thJobCode;
End; { Get_thJobCode }

procedure TCOMTransaction.Set_thJobCode(const Value: WideString);
Begin { Set_thJobCode }
  FEntSysObj.Transaction.thJobCode := Value;
End; { Set_thJobCode }

{-----------------------------------------}

function TCOMTransaction.Get_thJobAnal: WideString;
Begin { Get_thJobAnal }
  Result := FEntSysObj.Transaction.thJobAnal;
End; { Get_thJobAnal }

procedure TCOMTransaction.Set_thJobAnal(const Value: WideString);
Begin { Set_thJobAnal }
  FEntSysObj.Transaction.thJobAnal := Value;
End; { Set_thJobAnal }

{-----------------------------------------}

function TCOMTransaction.Get_thTotOrderOS: Double;
Begin { Get_thTotOrderOS }
  Result := FEntSysObj.Transaction.thTotOrderOS;
End; { Get_thTotOrderOS }

procedure TCOMTransaction.Set_thTotOrderOS(Value: Double);
Begin { Set_thTotOrderOS }
  FEntSysObj.Transaction.thTotOrderOS := Value;
End; { Set_thTotOrderOS }

{-----------------------------------------}

function TCOMTransaction.Get_thUser1: WideString;
Begin { Get_thUser1 }
  Result := FEntSysObj.Transaction.thUser1;
End; { Get_thUser1 }

procedure TCOMTransaction.Set_thUser1(const Value: WideString);
Begin { Set_thUser1 }
  FEntSysObj.Transaction.thUser1 := Value;
End; { Set_thUser1 }

{-----------------------------------------}

function TCOMTransaction.Get_thUser2: WideString;
Begin { Get_thUser2 }
  Result := FEntSysObj.Transaction.thUser2;
End; { Get_thUser2 }

procedure TCOMTransaction.Set_thUser2(const Value: WideString);
Begin { Set_thUser2 }
  FEntSysObj.Transaction.thUser2 := Value;
End; { Set_thUser2 }

{-----------------------------------------}

function TCOMTransaction.Get_thLastLetter: SmallInt;
Begin { Get_thLastLetter }
  Result := FEntSysObj.Transaction.thLastLetter;
End; { Get_thLastLetter }

procedure TCOMTransaction.Set_thLastLetter(Value: SmallInt);
Begin { Set_thLastLetter }
  FEntSysObj.Transaction.thLastLetter := Value;
End; { Set_thLastLetter }

{-----------------------------------------}

function TCOMTransaction.Get_thUnTagged: WordBool;
Begin { Get_thUnTagged }
  Result := FEntSysObj.Transaction.thUnTagged;
End; { Get_thUnTagged }

procedure TCOMTransaction.Set_thUnTagged(Value: WordBool);
Begin { Set_thUnTagged }
  FEntSysObj.Transaction.thUnTagged := Value;
End; { Set_thUnTagged }

{-----------------------------------------}

function TCOMTransaction.Get_thUser3: WideString;
Begin { Get_thUser3 }
  Result := FEntSysObj.Transaction.thUser3;
End; { Get_thUser3 }

procedure TCOMTransaction.Set_thUser3(const Value: WideString);
Begin { Set_thUser3 }
  FEntSysObj.Transaction.thUser3 := Value;
End; { Set_thUser3 }

{-----------------------------------------}

function TCOMTransaction.Get_thUser4: WideString;
Begin { Get_thUser4 }
  Result := FEntSysObj.Transaction.thUser4;
End; { Get_thUser4 }

procedure TCOMTransaction.Set_thUser4(const Value: WideString);
Begin { Set_thUser4 }
  FEntSysObj.Transaction.thUser4 := Value;
End; { Set_thUser4 }

{-----------------------------------------}

function TCOMTransaction.Get_thInvVATAnal(Index: TVATIndex): Double;
Var
  I : cuVatIndex;
Begin { Get_thInvVATAnal }
  I := cuVatIndex(Ord(Index));
  Result := FEntSysObj.Transaction.thInvVATAnal[I]
End; { Get_thInvVATAnal }

procedure TCOMTransaction.Set_thInvVATAnal(Index: TVATIndex; Value: Double);
Var
  I : cuVatIndex;
Begin { Set_thInvVATAnal }
  I := cuVatIndex(Ord(Index));
  FEntSysObj.Transaction.thInvVATAnal[I] := Value;
End; { Set_thInvVATAnal }

{-----------------------------------------}

function TCOMTransaction.Get_thDelAddr(Index: Integer): WideString;
Begin { Get_thDelAddr }
  Result := FEntSysObj.Transaction.thDelAddr[Index]
End; { Get_thDelAddr }

procedure TCOMTransaction.Set_thDelAddr(Index: Integer; const Value: WideString);
Begin { Set_thDelAddr }
  FEntSysObj.Transaction.thDelAddr[Index] := Value;
End; { Set_thDelAddr }

{-----------------------------------------}

function TCOMTransaction.Get_thDocLSplit(Index: Integer): Double;
Begin { Get_thDocLSplit }
  Result := FEntSysObj.Transaction.thDocLSplit[Index]
End; { Get_thDocLSplit }

procedure TCOMTransaction.Set_thDocLSplit(Index: Integer; Value: Double);
Begin { Set_thUser4 }
  FEntSysObj.Transaction.thDocLSplit[Index] := Value;
End; { Set_thUser4 }

{-----------------------------------------}

function TCOMTransaction.Get_thLines: ICOMTransactionLines;
Begin { Get_thLines }
  If (Not Assigned(FTransLinesO)) Then Begin
    { Create and initialise Transaction Details }
    FTransLinesO := TCOMTransactionLines.Create;
    FTransLinesO.InitLines(FEntSysObj);

    FTransLinesI := FTransLinesO;
  End; { If (Not Assigned(FTransLinesO)) }

  Result := FTransLinesI;
End; { Get_thLines }

{-------------------------------------------------------------------------------------------------}

//
// ICOMTransaction2 properties
//

function TCOMTransaction.Get_thTagNo: Integer;
begin
  Result := FEntSysObj.Transaction.thTagNo;
end;

procedure TCOMTransaction.Set_thTagNo(Value: Integer);
begin
  FEntSysObj.Transaction.thTagNo := Value;
end;

//-------------------------------------------------------------------------

//
// ICOMTransaction3 properties
//

function TCOMTransaction.Get_thCISTaxDue: Double;
begin
  Result := FEntSysObj.Transaction2.thCISTaxDue;
end;

procedure TCOMTransaction.Set_thCISTaxDue(Value: Double);
begin
  FEntSysObj.Transaction2.thCISTaxDue := Value;
end;

//------------------------------

function TCOMTransaction.Get_thCISTaxDeclared: Double;
begin
  Result := FEntSysObj.Transaction2.thCISTaxDeclared;
end;

procedure TCOMTransaction.Set_thCISTaxDeclared(Value: Double);
begin
  FEntSysObj.Transaction2.thCISTaxDeclared := Value;
end;

//------------------------------

function TCOMTransaction.Get_thCISManualTax: WordBool;
begin
  Result := FEntSysObj.Transaction2.thCISManualTax;
end;

procedure TCOMTransaction.Set_thCISManualTax(Value: WordBool);
begin
  FEntSysObj.Transaction2.thCISManualTax := Value;
end;

//------------------------------

function TCOMTransaction.Get_thCISDate: WideString;
begin
  Result := FEntSysObj.Transaction2.thCISDate;
end;

procedure TCOMTransaction.Set_thCISDate(const Value: WideString);
begin
  FEntSysObj.Transaction2.thCISDate := Value;
end;

//------------------------------

function TCOMTransaction.Get_thCISEmployee: WideString;
begin
  Result := FEntSysObj.Transaction2.thCISEmployee;
end;

procedure TCOMTransaction.Set_thCISEmployee(const Value: WideString);
begin
  FEntSysObj.Transaction2.thCISEmployee := Value;
end;

//------------------------------

function TCOMTransaction.Get_thCISTotalGross: Double;
begin
  Result := FEntSysObj.Transaction2.thCISTotalGross;
end;

procedure TCOMTransaction.Set_thCISTotalGross(Value: Double);
begin
  FEntSysObj.Transaction2.thCISTotalGross := Value;
end;

//------------------------------

function TCOMTransaction.Get_thCISSource: Integer;
begin
  Result := FEntSysObj.Transaction2.thCISSource;
end;

procedure TCOMTransaction.Set_thCISSource(Value: Integer);
begin
  FEntSysObj.Transaction2.thCISSource := Value;
end;

//------------------------------

function TCOMTransaction.Get_thTotalCostApport: Double;
begin
  Result := FEntSysObj.Transaction2.thTotalCostApport;
end;

procedure TCOMTransaction.Set_thTotalCostApport(Value: Double);
begin
  FEntSysObj.Transaction2.thTotalCostApport := Value;
end;

//------------------------------

function TCOMTransaction.Get_thNOMVATIO: TNOMVATIOType;
Begin
  With (FEntSysObj.Transaction2 As TAbsInvoice3) Do
    // Convert between DLL and COM enumerated types
    Case thNOMVATIO Of
      CustAbsU.nvioNA     : Result := Enterprise_TLB.nvioNA;
      CustAbsU.nvioInput  : Result := Enterprise_TLB.nvioInput;
      CustAbsU.nvioOutput : Result := Enterprise_TLB.nvioOutput;
    Else
      Raise Exception.Create ('TCOMTransaction.Get_thNOMVATIO: Unhandled Value (' + IntToStr(Ord(thNOMVATIO)) + ')');
    End; { Case FLineObj.tlNOMVATType }
End;

procedure TCOMTransaction.Set_thNOMVATIO(Value: TNOMVATIOType);
Begin
  With (FEntSysObj.Transaction2 As TAbsInvoice3) Do
    // Convert between COM and DLL enumerated types
    Case Value Of
      Enterprise_TLB.nvioNA     : thNOMVATIO := CustAbsU.nvioNA;
      Enterprise_TLB.nvioInput  : thNOMVATIO := CustAbsU.nvioInput;
      Enterprise_TLB.nvioOutput : thNOMVATIO := CustAbsU.nvioOutput;
    Else
      Raise Exception.Create ('TCOMTransaction.Set_thNOMVATIO: Unhandled Value (' + IntToStr(Ord(Value)) + ')');
    End; { Case FLineObj.tlNOMVATType }
End;

//------------------------------

function TCOMTransaction.Get_thTSHExported: WordBool;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice4).thTSHExported;
end;

procedure TCOMTransaction.Set_thTSHExported(Value: WordBool);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice4).thTSHExported := Value;
end;

//------------------------------

function TCOMTransaction.Get_thWeekMonth: Integer;
Begin // Get_thWeekMonth
  Result := (FEntSysObj.Transaction2 As TAbsInvoice6).thWeekMonth;
End; // Get_thWeekMonth
procedure TCOMTransaction.Set_thWeekMonth(Value: Integer);
Begin // Set_thWeekMonth
  (FEntSysObj.Transaction2 As TAbsInvoice6).thWeekMonth := Value;
End; // Set_thWeekMonth

//------------------------------

function TCOMTransaction.Get_thWorkflowState: Integer;
Begin // Get_thWorkflowState
  Result := (FEntSysObj.Transaction2 As TAbsInvoice6).thWorkflowState;
End; // Get_thWorkflowState
procedure TCOMTransaction.Set_thWorkflowState(Value: Integer);
Begin // Set_thWorkflowState
  (FEntSysObj.Transaction2 As TAbsInvoice6).thWorkflowState := Value;
End; // Set_thWorkflowState

//------------------------------

function TCOMTransaction.Get_thOverrideLocation: WideString;
Begin // Get_thOverrideLocation
  Result := (FEntSysObj.Transaction2 As TAbsInvoice7).thOverrideLocation;
End; // Get_thOverrideLocation
procedure TCOMTransaction.Set_thOverrideLocation(const Value: WideString);
Begin // Set_thOverrideLocation
  (FEntSysObj.Transaction2 As TAbsInvoice7).thOverrideLocation := Value;
End; // Set_thOverrideLocation

//=========================================================================

function TCOMTransaction.Get_thUser10: WideString;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice8).thUser10;
end;

function TCOMTransaction.Get_thUser5: WideString;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice8).thUser5;
end;

function TCOMTransaction.Get_thUser6: WideString;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice8).thUser6;
end;

function TCOMTransaction.Get_thUser7: WideString;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice8).thUser7;
end;

function TCOMTransaction.Get_thUser8: WideString;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice8).thUser8;
end;

function TCOMTransaction.Get_thUser9: WideString;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice8).thUser9;
end;

procedure TCOMTransaction.Set_thUser10(const Value: WideString);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice8).thUser10 := Value;
end;

procedure TCOMTransaction.Set_thUser5(const Value: WideString);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice8).thUser5 := Value;
end;

procedure TCOMTransaction.Set_thUser6(const Value: WideString);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice8).thUser6 := Value;
end;

procedure TCOMTransaction.Set_thUser7(const Value: WideString);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice8).thUser7 := Value;
end;

procedure TCOMTransaction.Set_thUser8(const Value: WideString);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice8).thUser8 := Value;
end;

procedure TCOMTransaction.Set_thUser9(const Value: WideString);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice8).thUser9 := Value;
end;

//-------------------------------------------------------------------------

// ICOMTransaction9  MH 15/10/2013 v7.0.7
function TCOMTransaction.Get_thDeliveryPostCode: WideString;
Begin // Get_thDeliveryPostCode
  Result := (FEntSysObj.Transaction2 As TAbsInvoice9).thDeliveryPostCode;
End; // Get_thDeliveryPostCode
procedure TCOMTransaction.Set_thDeliveryPostCode(const Value: WideString);
Begin // Set_thDeliveryPostCode
  (FEntSysObj.Transaction2 As TAbsInvoice9).thDeliveryPostCode := Value;
End; // Set_thDeliveryPostCode

//------------------------------

function TCOMTransaction.Get_thOriginator: WideString;
Begin // Get_thOriginator
  Result := (FEntSysObj.Transaction2 As TAbsInvoice9).thOriginator;
End; // Get_thOriginator
procedure TCOMTransaction.Set_thOriginator(const Value: WideString);
Begin // Set_thOriginator
  (FEntSysObj.Transaction2 As TAbsInvoice9).thOriginator := Value;
End; // Set_thOriginator

//------------------------------

function TCOMTransaction.Get_thCreationTime: WideString;
Begin // Get_thCreationTime
  Result := (FEntSysObj.Transaction2 As TAbsInvoice9).thCreationTime;
End; // Get_thCreationTime
procedure TCOMTransaction.Set_thCreationTime(const Value: WideString);
Begin // Set_thCreationTime
  (FEntSysObj.Transaction2 As TAbsInvoice9).thCreationTime := Value;
End; // Set_thCreationTime

//------------------------------

function TCOMTransaction.Get_thCreationDate: WideString;
Begin // Get_thCreationDate
  Result := (FEntSysObj.Transaction2 As TAbsInvoice9).thCreationDate;
End; // Get_thCreationDate
procedure TCOMTransaction.Set_thCreationDate(const Value: WideString);
Begin // Set_thCreationDate
  (FEntSysObj.Transaction2 As TAbsInvoice9).thCreationDate := Value;
End; // Set_thCreationDate

//-------------------------------------------------------------------------

// ICOMTransaction10 - MH 27/03/2015 v7.0.14 ABSEXCH-16284: Added new Prompt Payment Discount fields
function TCOMTransaction.Get_thPPDPercentage: Double;
Begin // Get_thPPDPercentage
  Result := (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDPercentage
End; // Get_thPPDPercentage
procedure TCOMTransaction.Set_thPPDPercentage(Value: Double);
Begin // Set_thPPDPercentage
  (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDPercentage := Value;
End; // Set_thPPDPercentage

//------------------------------

function TCOMTransaction.Get_thPPDDays: SmallInt;
Begin // Get_thPPDDays
  Result := (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDDays
End; // Get_thPPDDays
procedure TCOMTransaction.Set_thPPDDays(Value: SmallInt);
Begin // Set_thPPDDays
  (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDDays := Value;
End; // Set_thPPDDays

//------------------------------

function TCOMTransaction.Get_thPPDGoodsValue: Double;
Begin // Get_thPPDGoodsValue
  Result := (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDGoodsValue
End; // Get_thPPDGoodsValue
procedure TCOMTransaction.Set_thPPDGoodsValue(Value: Double);
Begin // Set_thPPDGoodsValue
  (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDGoodsValue := Value;
End; // Set_thPPDGoodsValue

//------------------------------

function TCOMTransaction.Get_thPPDVATValue: Double;
Begin // Get_thPPDVATValue
  Result := (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDVATValue
End; // Get_thPPDVATValue
procedure TCOMTransaction.Set_thPPDVATValue(Value: Double);
Begin // Set_thPPDVATValue
  (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDVATValue := Value;
End; // Set_thPPDVATValue

//------------------------------

function TCOMTransaction.Get_thPPDTakenStatus: TTransactionPPDTakenStatus;
Begin // Get_thPPDTakenStatus
  Case (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDTakenStatus Of
    ptPPDNotTaken          : Result := Enterprise_TLB.ptPPDNotTaken;
    ptPPDTaken             : Result := Enterprise_TLB.ptPPDTaken;
    ptPPDTakenOutsideTerms : Result := Enterprise_TLB.ptPPDTakenOutsideTerms;
  End; // Case (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDTaken
End; // Get_thPPDTakenStatus
procedure TCOMTransaction.Set_thPPDTakenStatus(Value: TTransactionPPDTakenStatus);
Begin // Set_thPPDTakenStatus
  Case Value Of
    Enterprise_TLB.ptPPDNotTaken          : (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDTakenStatus := CustABSU.ptPPDNotTaken;
    Enterprise_TLB.ptPPDTaken             : (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDTakenStatus := CustABSU.ptPPDTaken;
    Enterprise_TLB.ptPPDTakenOutsideTerms : (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDTakenStatus := CustABSU.ptPPDTakenOutsideTerms;
  End; // Case (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDTaken
End; // Set_thPPDTakenStatus

//------------------------------

function TCOMTransaction.Get_thPPDCreditNote: WordBool;
Begin // Get_thPPDCreditNote
  Result := (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDCreditNote
End; // Get_thPPDCreditNote
procedure TCOMTransaction.Set_thPPDCreditNote(Value: WordBool);
Begin // Set_thPPDCreditNote
  (FEntSysObj.Transaction2 As TAbsInvoice10).thPPDCreditNote := Value;
End; // Set_thPPDCreditNote

//------------------------------

function TCOMTransaction.Get_thBatchPayPPDStatus: Integer;
Begin // Get_thBatchPayPPDStatus
  Result := (FEntSysObj.Transaction2 As TAbsInvoice10).thBatchPayPPDStatus
End; // Get_thBatchPayPPDStatus
procedure TCOMTransaction.Set_thBatchPayPPDStatus(Value: Integer);
Begin // Set_thBatchPayPPDStatus
  (FEntSysObj.Transaction2 As TAbsInvoice10).thBatchPayPPDStatus := Value;
End; // Set_thBatchPayPPDStatus

//-------------------------------------------------------------------------

// ICOMTransaction10  MH 22/09/2014 Order Payments
function TCOMTransaction.Get_thOrderPaymentOrderRef: WideString;
Begin // Get_thOrderPaymentOrderRef
  Result := (FEntSysObj.Transaction2 As TAbsInvoice11).thOrderPaymentOrderRef
End; // Get_thOrderPaymentOrderRef

//------------------------------

function TCOMTransaction.Get_thOrderPaymentElement: TTransactionOrderPaymentElement;
Begin // Get_thOrderPaymentElement
  //
  // Note: Direct mapping between TTransactionOrderPaymentElement and cuTransactionOrderPaymentElement
  //
  Result := TTransactionOrderPaymentElement((FEntSysObj.Transaction2 As TAbsInvoice11).thOrderPaymentElement)
End; // Get_thOrderPaymentElement

//------------------------------

function TCOMTransaction.Get_thOrderPaymentFlags: Integer;
Begin // Get_thOrderPaymentFlags
  Result := (FEntSysObj.Transaction2 As TAbsInvoice11).thOrderPaymentFlags
End; // Get_thOrderPaymentFlags

//------------------------------

function TCOMTransaction.Get_thCreditCardType: WideString;
Begin // Get_thCreditCardType
  Result := (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardType
End; // Get_thCreditCardType

procedure TCOMTransaction.Set_thCreditCardType(const Value: WideString);
Begin // Set_thCreditCardType
  (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardType := Value
End; // Set_thCreditCardType

//------------------------------

function TCOMTransaction.Get_thCreditCardNumber: WideString;
Begin // Get_thCreditCardNumber
  Result := (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardNumber
End; // Get_thCreditCardNumber

procedure TCOMTransaction.Set_thCreditCardNumber(const Value: WideString);
Begin // Set_thCreditCardNumber
  (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardNumber := Value
End; // Set_thCreditCardNumber

//------------------------------

function TCOMTransaction.Get_thCreditCardExpiry: WideString;
Begin // Get_thCreditCardExpiry
  Result := (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardExpiry
End; // Get_thCreditCardExpiry

procedure TCOMTransaction.Set_thCreditCardExpiry(const Value: WideString);
Begin // Set_thCreditCardExpiry
  (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardExpiry := Value
End; // Set_thCreditCardExpiry

//------------------------------

function TCOMTransaction.Get_thCreditCardAuthorisationNo: WideString;
Begin // Get_thCreditCardAuthorisationNo
  Result := (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardAuthorisationNo
End; // Get_thCreditCardAuthorisationNo

procedure TCOMTransaction.Set_thCreditCardAuthorisationNo(const Value: WideString);
Begin // Set_thCreditCardAuthorisationNo
  (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardAuthorisationNo := Value
End; // Set_thCreditCardAuthorisationNo

//------------------------------

function TCOMTransaction.Get_thCreditCardReferenceNo: WideString;
Begin // Get_thCreditCardReferenceNo
  Result := (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardReferenceNo
End; // Get_thCreditCardReferenceNo

procedure TCOMTransaction.Set_thCreditCardReferenceNo(const Value: WideString);
Begin // Set_thCreditCardReferenceNo
  (FEntSysObj.Transaction2 As TAbsInvoice11).thCreditCardReferenceNo := Value
End; // Set_thCreditCardReferenceNo

//------------------------------

function TCOMTransaction.Get_thCustomData1: WideString;
Begin // Get_thCustomData1
  Result := (FEntSysObj.Transaction2 As TAbsInvoice11).thCustomData1
End; // Get_thCustomData1

procedure TCOMTransaction.Set_thCustomData1(const Value: WideString);
Begin // Set_thCustomData1
  (FEntSysObj.Transaction2 As TAbsInvoice11).thCustomData1 := Value
End; // Set_thCustomData1

//-------------------------------------------------------------------------

// ICOMTransaction10 MH 26/11/2014 ABSEXCH-15836: Added Country Codes
function TCOMTransaction.Get_thDeliveryCountry: WideString;
Begin // Get_thDeliveryCountry
  Result := (FEntSysObj.Transaction2 As TAbsInvoice11).thDeliveryCountry
End; // Get_thDeliveryCountry
procedure TCOMTransaction.Set_thDeliveryCountry(const Value: WideString);
Begin // Set_thDeliveryCountry
  (FEntSysObj.Transaction2 As TAbsInvoice11).thDeliveryCountry := Value
End; // Set_thDeliveryCountry

//-------------------------------------------------------------------------

// MH 20/01/2016 Exch2016-R1: Intrastat enhancements - ICOMTransaction12
function TCOMTransaction.Get_thIntrastatOutOfPeriod: WordBool;
Begin // Get_thIntrastatOutOfPeriod
  Result := (FEntSysObj.Transaction2 As TAbsInvoice12).thIntrastatOutOfPeriod
End; // Get_thIntrastatOutOfPeriod
procedure TCOMTransaction.Set_thIntrastatOutOfPeriod(Value: WordBool);
Begin // Set_thIntrastatOutOfPeriod
  (FEntSysObj.Transaction2 As TAbsInvoice12).thIntrastatOutOfPeriod := Value
End; // Set_thIntrastatOutOfPeriod

//-------------------------------------------------------------------------

// MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
function TCOMTransaction.Get_thUser11: WideString;
Begin // Get_thUser11
  Result := (FEntSysObj.Transaction2 As TAbsInvoice13).thUser11
End; // Get_thUser11
procedure TCOMTransaction.Set_thUser11(const Value: WideString);
Begin // Set_thUser11
  (FEntSysObj.Transaction2 As TAbsInvoice13).thUser11 := Value
End; // Set_thUser11

//-----------------------------------

function TCOMTransaction.Get_thUser12: WideString;
Begin // Get_thUser12
  Result := (FEntSysObj.Transaction2 As TAbsInvoice13).thUser12
End; // Get_thUser12
procedure TCOMTransaction.Set_thUser12(const Value: WideString);
Begin // Set_thUser12
  (FEntSysObj.Transaction2 As TAbsInvoice13).thUser12 := Value
End; // Set_thUser12

//-----------------------------------

//RB 22/11/2017 2018-R1 ABSEXCH-19400: GDPR (POST 19347) - 8.3.1.1.1 - DLL + COM Customisation Support
function TCOMTransaction.Get_thAnonymised: WordBool;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice14).thAnonymised;
end; //Get_thAnonymised
procedure TCOMTransaction.Set_thAnonymised(Value: WordBool);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice14).thAnonymised := Value;
end; //Set_thAnonymised

//-----------------------------------

function TCOMTransaction.Get_thAnonymisedDate: WideString;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice14).thAnonymisedDate;
end; //Get_thAnonymisedDate
procedure TCOMTransaction.Set_thAnonymisedDate(const Value: WideString);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice14).thAnonymisedDate := Value;
end; //Set_thAnonymisedDate

//-----------------------------------

function TCOMTransaction.Get_thAnonymisedTime: WideString;
begin
  Result := (FEntSysObj.Transaction2 As TAbsInvoice14).thAnonymisedTime;
end; //Get_thAnonymisedTime
procedure TCOMTransaction.Set_thAnonymisedTime(const Value: WideString);
begin
  (FEntSysObj.Transaction2 As TAbsInvoice14).thAnonymisedTime := Value;
end; //Set_thAnonymisedTime

//=========================================================================

end.

