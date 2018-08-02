unit ZCust;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMCustomer = class(TAutoIntfObject, ICOMCustomer, ICOMCustomer2, ICOMCustomer3,
                                        ICOMCustomer4, ICOMCustomer5, ICOMCustomer6,
                                        ICOMCustomer7, ICOMCustomer8, ICOMCustomer9,
                                        ICOMCustomer10, ICOMCustomer11)
  private
    FAcType    : Char;
    FEntSysObj : TEnterpriseSystem;
    FAccount   : TAbsCustomer10;
  protected
    { Property methods }
    function  Get_AccessRights: TRecordAccessStatus; safecall;
    function  Get_acCode: WideString; safecall;
    procedure Set_acCode(const Value: WideString); safecall;
    function  Get_acCompany: WideString; safecall;
    procedure Set_acCompany(const Value: WideString); safecall;
    function  Get_acArea: WideString; safecall;
    procedure Set_acArea(const Value: WideString); safecall;
    function  Get_acAccType: WideString; safecall;
    procedure Set_acAccType(const Value: WideString); safecall;
    function  Get_acStatementTo: WideString; safecall;
    procedure Set_acStatementTo(const Value: WideString); safecall;
    function  Get_acVATRegNo: WideString; safecall;
    procedure Set_acVATRegNo(const Value: WideString); safecall;
    function  Get_acDelAddr: WordBool; safecall;
    procedure Set_acDelAddr(Value: WordBool); safecall;
    function  Get_acContact: WideString; safecall;
    procedure Set_acContact(const Value: WideString); safecall;
    function  Get_acPhone: WideString; safecall;
    procedure Set_acPhone(const Value: WideString); safecall;
    function  Get_acFax: WideString; safecall;
    procedure Set_acFax(const Value: WideString); safecall;
    function  Get_acTheirAcc: WideString; safecall;
    procedure Set_acTheirAcc(const Value: WideString); safecall;
    function  Get_acOwnTradTerm: WordBool; safecall;
    procedure Set_acOwnTradTerm(Value: WordBool); safecall;
    function  Get_acCurrency: Smallint; safecall;
    procedure Set_acCurrency(Value: Smallint); safecall;
    function  Get_acVATCode: WideString; safecall;
    procedure Set_acVATCode(const Value: WideString); safecall;
    function  Get_acPayTerms: Smallint; safecall;
    procedure Set_acPayTerms(Value: Smallint); safecall;
    function  Get_acCreditLimit: Double; safecall;
    procedure Set_acCreditLimit(Value: Double); safecall;
    function  Get_acDiscount: Double; safecall;
    procedure Set_acDiscount(Value: Double); safecall;
    function  Get_acCreditStatus: Smallint; safecall;
    procedure Set_acCreditStatus(Value: Smallint); safecall;
    function  Get_acCostCentre: WideString; safecall;
    procedure Set_acCostCentre(const Value: WideString); safecall;
    function  Get_acDiscountBand: WideString; safecall;
    procedure Set_acDiscountBand(const Value: WideString); safecall;
    function  Get_acDepartment: WideString; safecall;
    procedure Set_acDepartment(const Value: WideString); safecall;
    function  Get_acECMember: WordBool; safecall;
    procedure Set_acECMember(Value: WordBool); safecall;
    function  Get_acStatement: WordBool; safecall;
    procedure Set_acStatement(Value: WordBool); safecall;
    function  Get_acSalesGL: Integer; safecall;
    procedure Set_acSalesGL(Value: Integer); safecall;
    function  Get_acLocation: WideString; safecall;
    procedure Set_acLocation(const Value: WideString); safecall;
    function  Get_acAccStatus: TAccountStatus; safecall;
    procedure Set_acAccStatus(Value: TAccountStatus); safecall;
    function  Get_acPayType: WideString; safecall;
    procedure Set_acPayType(const Value: WideString); safecall;
    function  Get_acBankSort: WideString; safecall;
    procedure Set_acBankSort(const Value: WideString); safecall;
    function  Get_acBankAcc: WideString; safecall;
    procedure Set_acBankAcc(const Value: WideString); safecall;
    function  Get_acBankRef: WideString; safecall;
    procedure Set_acBankRef(const Value: WideString); safecall;
    function  Get_acPhone2: WideString; safecall;
    procedure Set_acPhone2(const Value: WideString); safecall;
    function  Get_acCOSGL: Integer; safecall;
    procedure Set_acCOSGL(Value: Integer); safecall;
    function  Get_acDrCrGL: Integer; safecall;
    procedure Set_acDrCrGL(Value: Integer); safecall;
    function  Get_acLastUsed: WideString; safecall;
    procedure Set_acLastUsed(const Value: WideString); safecall;
    function  Get_acUserDef1: WideString; safecall;
    procedure Set_acUserDef1(const Value: WideString); safecall;
    function  Get_acUserDef2: WideString; safecall;
    procedure Set_acUserDef2(const Value: WideString); safecall;
    function  Get_acInvoiceTo: WideString; safecall;
    procedure Set_acInvoiceTo(const Value: WideString); safecall;
    function  Get_acSOPAutoWOff: WordBool; safecall;
    procedure Set_acSOPAutoWOff(Value: WordBool); safecall;
    function  Get_acFormSet: Smallint; safecall;
    procedure Set_acFormSet(Value: Smallint); safecall;
    function  Get_acBookOrdVal: Double; safecall;
    procedure Set_acBookOrdVal(Value: Double); safecall;
    function  Get_acDirDebMode: Smallint; safecall;
    procedure Set_acDirDebMode(Value: Smallint); safecall;
    function  Get_acAltCode: WideString; safecall;
    procedure Set_acAltCode(const Value: WideString); safecall;
    function  Get_acPostCode: WideString; safecall;
    procedure Set_acPostCode(const Value: WideString); safecall;
    function  Get_acUserDef3: WideString; safecall;
    procedure Set_acUserDef3(const Value: WideString); safecall;
    function  Get_acUserDef4: WideString; safecall;
    procedure Set_acUserDef4(const Value: WideString); safecall;
    function  Get_acEmailAddr: WideString; safecall;
    procedure Set_acEmailAddr(const Value: WideString); safecall;
    function  Get_acCCStart: WideString; safecall;
    procedure Set_acCCStart(const Value: WideString); safecall;
    function  Get_acCCEnd: WideString; safecall;
    procedure Set_acCCEnd(const Value: WideString); safecall;
    function  Get_acCCName: WideString; safecall;
    procedure Set_acCCName(const Value: WideString); safecall;
    function  Get_acCCNumber: WideString; safecall;
    procedure Set_acCCNumber(const Value: WideString); safecall;
    function  Get_acCCSwitch: WideString; safecall;
    procedure Set_acCCSwitch(const Value: WideString); safecall;
    function  Get_acTradeTerms(Index: Integer): WideString; safecall;
    procedure Set_acTradeTerms(Index: Integer; const Value: WideString); safecall;
    function  Get_acAddress(Index: Integer): WideString; safecall;
    procedure Set_acAddress(Index: Integer; const Value: WideString); safecall;
    function  Get_acDelAddress(Index: Integer): WideString; safecall;
    procedure Set_acDelAddress(Index: Integer; const Value: WideString); safecall;

    // ICOMCustomer2 properties
    function  Get_acDefTagNo: Integer; safecall;
    procedure Set_acDefTagNo(Value: Integer); safecall;
    function Get_acDefSettleDisc: Double; safecall;
    procedure Set_acDefSettleDisc(Value: Double); safecall;
    function Get_acDefSettleDays: Integer; safecall;
    procedure Set_acDefSettleDays(Value: Integer); safecall;
    function Get_acDocDeliveryMode: Integer; safecall;
    procedure Set_acDocDeliveryMode(Value: Integer); safecall;
    function Get_acEbusPword: WideString; safecall;
    procedure Set_acEbusPword(const Value: WideString); safecall;
    function Get_acUseForEbus: Integer; safecall;
    procedure Set_acUseForEbus(Value: Integer); safecall;
    function Get_acWebLiveCatalog: WideString; safecall;
    procedure Set_acWebLiveCatalog(const Value: WideString); safecall;
    function Get_acWebPrevCatalog: WideString; safecall;
    procedure Set_acWebPrevCatalog(const Value: WideString); safecall;
    function Get_acInclusiveVATCode: WideString; safecall;
    procedure Set_acInclusiveVATCode(const Value: WideString); safecall;
    function Get_acLastOperator: WideString; safecall;
    procedure Set_acLastOperator(const Value: WideString); safecall;
    function Get_acSendHTML: WordBool; safecall;
    procedure Set_acSendHTML(Value: WordBool); safecall;
    function Get_acSendReader: WordBool; safecall;
    procedure Set_acSendReader(Value: WordBool); safecall;
    function Get_acZIPAttachments: Integer; safecall;
    procedure Set_acZIPAttachments(Value: Integer); safecall;
    function Get_acSSDDeliveryTerms: WideString; safecall;
    procedure Set_acSSDDeliveryTerms(const Value: WideString); safecall;
    function Get_acSSDModeOfTransport: Integer; safecall;
    procedure Set_acSSDModeOfTransport(Value: Integer); safecall;
    function Get_acTimeStamp: WideString; safecall;
    procedure Set_acTimeStamp(const Value: WideString); safecall;

    // ICOMCustomer3
    function Get_acStateDeliveryMode: Integer; safecall;
    procedure Set_acStateDeliveryMode(Value: Integer); safecall;
    function Get_acHeadOffice: Integer; safecall;
    procedure Set_acHeadOffice(Value: Integer); safecall;

    // ICOMCustomer4 v6.9
    function Get_acUserDef5: WideString; safecall;
    procedure Set_acUserDef5(const Value: WideString); safecall;
    function Get_acUserDef6: WideString; safecall;
    procedure Set_acUserDef6(const Value: WideString); safecall;
    function Get_acUserDef7: WideString; safecall;
    procedure Set_acUserDef7(const Value: WideString); safecall;
    function Get_acUserDef8: WideString; safecall;
    procedure Set_acUserDef8(const Value: WideString); safecall;
    function Get_acUserDef9: WideString; safecall;
    procedure Set_acUserDef9(const Value: WideString); safecall;
    function Get_acUserDef10: WideString; safecall;
    procedure Set_acUserDef10(const Value: WideString); safecall;

    // ICOMCustomer5 MH 10/09/2013 v7.0.6
    function Get_acBankSortCode: WideString; safecall;
    procedure Set_acBankSortCode(const Value: WideString); safecall;
    function Get_acBankAccountCode: WideString; safecall;
    procedure Set_acBankAccountCode(const Value: WideString); safecall;
    function Get_acMandateID: WideString; safecall;
    procedure Set_acMandateID(const Value: WideString); safecall;
    function Get_acMandateDate: WideString; safecall;
    procedure Set_acMandateDate(const Value: WideString); safecall;

    // ICOMCustomer6 MH 15/10/2013 v7.0.7
    function Get_acDeliveryPostCode: WideString; safecall;
    procedure Set_acDeliveryPostCode(const Value: WideString); safecall;

    // ICOMCustomer7 MH 26/11/2013 v7.0.8
    function Get_acSubType: WideString; safecall;
    function Get_acLongACCode: WideString; safecall;
    procedure Set_acLongACCode(const Value: WideString); safecall;

    // ICOMCustomer8 MH 11/05/2015 ABSEXCH-16419: Merged v7.0.14 changes in
    function Get_acPPDMode: Enterprise_TLB.TCustomerPPDMode; safecall;
    procedure Set_acPPDMode(Value: Enterprise_TLB.TCustomerPPDMode); safecall;

    // ICOMCustomer8 MH 22/09/2014 Order Payments
    function Get_acAllowOrderPayments: WordBool; safecall;
    procedure Set_acAllowOrderPayments(Value: WordBool); safecall;
    function Get_acOrderPaymentsGLCode: Integer; safecall;
    procedure Set_acOrderPaymentsGLCode(Value: Integer); safecall;
    // ICOMCustomer9 MH 26/11/2014 ABSEXCH-15836: Added Country Codes
    function Get_acCountry: WideString; safecall;
    procedure Set_acCountry(const Value: WideString); safecall;
    function Get_acDeliveryCountry: WideString; safecall;
    procedure Set_acDeliveryCountry(const Value: WideString); safecall;

    // MH 20/01/2016 Exch2016R1 ABSEXCH-17114: Customisation mods for Intrastat changes - ICOMCustomer10
    function Get_acDefaultToQR: WordBool; safecall;
    procedure Set_acDefaultToQR(Value: WordBool); safecall;

    //RB 21/11/2017 2018-R1 ABSEXCH-19390: GDPR (POST 19346) - 8.3.1.1.1 - DLL + COM Customisation Support
    function Get_acAnonymisationStatus: Enterprise_TLB.TEntityAnonymisationStatus ; safecall;
    procedure Set_acAnonymisationStatus(Value: Enterprise_TLB.TEntityAnonymisationStatus); safecall;
    function Get_acAnonymisedDate: WideString; safecall;
    procedure Set_acAnonymisedDate(const Value: WideString); safecall;
    function Get_acAnonymisedTime: WideString; safecall;
    procedure Set_acAnonymisedTime(const Value: WideString); safecall;
    
  public
    Constructor Create;

    Procedure InitAccount(AcType : Char; EntSysObj : TEnterpriseSystem);
  End; { TComCustomer }

implementation

uses ComServ, CustIntU, ZUtils;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMCustomer.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMCustomer11);

  FAcType := ' ';
  FEntSysObj := Nil;
  FAccount := Nil;
End; { Create }

{-----------------------------------------}

Procedure TCOMCustomer.InitAccount(AcType : Char; EntSysObj : TEnterpriseSystem);
Begin { InitAccount }
  FAcType := AcType;
  FEntSysObj := EntSysObj;

  Case FAcType Of
    'C' : FAccount := FEntSysObj.Customer as TAbsCustomer10;
    'S' : FAccount := FEntSysObj.Supplier as TAbsCustomer10;
  Else
    MessageDlg ('TCOMCustomer.InitAccount - Invalid Account Type ''' + AcType + ''' passed',
                mtError, [mbOk], 0);
  End; { Case }
End; { InitAccount }

{-------------------------------------------------------------------------------------------------}

function TCOMCustomer.Get_AccessRights: TRecordAccessStatus;
Begin { Get_AccessRights }
  Result := Ord(FAccount.AccessRights);
End; { Get_AccessRights }

{-----------------------------------------}

function TCOMCustomer.Get_acCode: WideString;
Begin { Get_acCode }
  Result := FAccount.acCode;
End; { Get_acCode }

procedure TCOMCustomer.Set_acCode(const Value: WideString);
Begin { Set_acCode }
  FAccount.acCode := Value;
End; { Set_acCode }

{-----------------------------------------}

function TCOMCustomer.Get_acCompany: WideString;
Begin { Get_acCompany }
  Result := FAccount.acCompany;
End; { Get_acCompany }

procedure TCOMCustomer.Set_acCompany(const Value: WideString);
Begin { Set_acCompany }
  FAccount.acCompany := Value;
End; { Set_acCompany }

{-----------------------------------------}

function TCOMCustomer.Get_acArea: WideString;
Begin { Get_acArea }
  Result := FAccount.acArea;
End; { Get_acArea }

procedure TCOMCustomer.Set_acArea(const Value: WideString);
Begin { Set_acArea }
  FAccount.acArea := Value;
End; { Set_acArea }

{-----------------------------------------}

function TCOMCustomer.Get_acAccType: WideString;
Begin { Get_acAccType }
  Result := FAccount.acAccType;
End; { Get_acAccType }

procedure TCOMCustomer.Set_acAccType(const Value: WideString);
Begin { Set_acAccType }
  FAccount.acAccType := Value;
End; { Set_acAccType }

{-----------------------------------------}

function TCOMCustomer.Get_acStatementTo: WideString;
Begin { Get_acStatementTo }
  Result := FAccount.acStatementTo;
End; { Get_acStatementTo }

procedure TCOMCustomer.Set_acStatementTo(const Value: WideString);
Begin { Set_acStatementTo }
  FAccount.acStatementTo := Value;
End; { Set_acStatementTo }

{-----------------------------------------}

function TCOMCustomer.Get_acVATRegNo: WideString;
Begin { Get_acVATRegNo }
  Result := FAccount.acVATRegNo;
End; { Get_acVATRegNo }

procedure TCOMCustomer.Set_acVATRegNo(const Value: WideString);
Begin { Set_acVATRegNo }
  FAccount.acVATRegNo := Value;
End; { Set_acVATRegNo }

{-----------------------------------------}

function TCOMCustomer.Get_acDelAddr: WordBool;
Begin { Get_acDelAddr }
  Result := FAccount.acDelAddr;
End; { Get_acDelAddr }

procedure TCOMCustomer.Set_acDelAddr(Value: WordBool);
Begin { Set_acDelAddr }
  FAccount.acDelAddr := Value;
End; { Set_acDelAddr }

{-----------------------------------------}

function TCOMCustomer.Get_acContact: WideString;
Begin { Get_acContact }
  Result := FAccount.acContact;
End; { Get_acContact }

procedure TCOMCustomer.Set_acContact(const Value: WideString);
Begin { Set_acContact }
  FAccount.acContact := Value;
End; { Set_acContact }

{-----------------------------------------}

function TCOMCustomer.Get_acPhone: WideString;
Begin { Get_acPhone }
  Result := FAccount.acPhone;
End; { Get_acPhone }

procedure TCOMCustomer.Set_acPhone(const Value: WideString);
Begin { Set_acPhone }
  FAccount.acPhone := Value;
End; { Set_acPhone }

{-----------------------------------------}

function TCOMCustomer.Get_acFax: WideString;
Begin { Get_acFax }
  Result := FAccount.acFax;
End; { Get_acFax }

procedure TCOMCustomer.Set_acFax(const Value: WideString);
Begin { Set_acFax }
  FAccount.acFax := Value;
End; { Set_acFax }

{-----------------------------------------}

function TCOMCustomer.Get_acTheirAcc: WideString;
Begin { Get_acTheirAcc }
  Result := FAccount.acTheirAcc;
End; { Get_acTheirAcc }

procedure TCOMCustomer.Set_acTheirAcc(const Value: WideString);
Begin { Set_acTheirAcc }
  FAccount.acTheirAcc := Value;
End; { Set_acTheirAcc }

{-----------------------------------------}

function TCOMCustomer.Get_acOwnTradTerm: WordBool;
Begin { Get_acOwnTradTerm }
  Result := FAccount.acOwnTradTerm;
End; { Get_acOwnTradTerm }

procedure TCOMCustomer.Set_acOwnTradTerm(Value: WordBool);
Begin { Set_acOwnTradTerm }
  FAccount.acOwnTradTerm := Value;
End; { Set_acOwnTradTerm }

{-----------------------------------------}

function TCOMCustomer.Get_acCurrency: SmallInt;
Begin { Get_acCurrency }
  Result := FAccount.acCurrency;
End; { Get_acCurrency }

procedure TCOMCustomer.Set_acCurrency(Value: SmallInt);
Begin { Set_acCurrency }
  FAccount.acCurrency := Value;
End; { Set_acCurrency }

{-----------------------------------------}

function TCOMCustomer.Get_acVATCode: WideString;
Begin { Get_acVATCode }
  Result := FAccount.acVATCode;
End; { Get_acVATCode }

procedure TCOMCustomer.Set_acVATCode(const Value: WideString);
Var
  TheChar : Char;
  TmpStr : String;
Begin { Set_acVATCode }
  If (Length(Value) > 0) Then Begin
    TmpStr := Value;
    TheChar := TmpStr[1];
    FAccount.acVATCode := TheChar;
  End; { If (Length(Value) > 0) }
End; { Set_acVATCode }

{-----------------------------------------}

function TCOMCustomer.Get_acPayTerms: SmallInt;
Begin { Get_acPayTerms }
  Result := FAccount.acPayTerms;
End; { Get_acPayTerms }

procedure TCOMCustomer.Set_acPayTerms(Value: SmallInt);
Begin { Set_acPayTerms }
  FAccount.acPayTerms := Value;
End; { Set_acPayTerms }

{-----------------------------------------}

function TCOMCustomer.Get_acCreditLimit: Double;
Begin { Get_acCreditLimit }
  Result := FAccount.acCreditLimit;
End; { Get_acCreditLimit }

procedure TCOMCustomer.Set_acCreditLimit(Value: Double);
Begin { Set_acCreditLimit }
  FAccount.acCreditLimit := Value;
End; { Set_acCreditLimit }

{-----------------------------------------}

function TCOMCustomer.Get_acDiscount: Double;
Begin { Get_acDiscount }
  Result := FAccount.acDiscount;
End; { Get_acDiscount }

procedure TCOMCustomer.Set_acDiscount(Value: Double);
Begin { Set_acDiscount }
  FAccount.acDiscount := Value;
End; { Set_acDiscount }

{-----------------------------------------}

function TCOMCustomer.Get_acCreditStatus: SmallInt;
Begin { Get_acCreditStatus }
  Result := FAccount.acCreditStatus;
End; { Get_acCreditStatus }

procedure TCOMCustomer.Set_acCreditStatus(Value: SmallInt);
Begin { Set_acCreditStatus }
  FAccount.acCreditStatus := Value;
End; { Set_acCreditStatus }

{-----------------------------------------}

function TCOMCustomer.Get_acCostCentre: WideString;
Begin { Get_acCostCentre }
  Result := FAccount.acCostCentre;
End; { Get_acCostCentre }

procedure TCOMCustomer.Set_acCostCentre(const Value: WideString);
Begin { Set_acCostCentre }
  FAccount.acCostCentre := Value;
End; { Set_acCostCentre }

{-----------------------------------------}

function TCOMCustomer.Get_acDiscountBand: WideString;
Begin { Get_acDiscountBand }
  Result := FAccount.acDiscountBand;
End; { Get_acDiscountBand }

procedure TCOMCustomer.Set_acDiscountBand(const Value: WideString);
Var
  TheChar : Char;
  TmpStr : String;
Begin { Set_acDiscountBand }
  If (Length(Value) > 0) Then Begin
    TmpStr := Value;
    TheChar := TmpStr[1];
    FAccount.acDiscountBand := TheChar;
  End; { If (Length(Value) > 0) }
End; { Set_acDiscountBand }

{-----------------------------------------}

function TCOMCustomer.Get_acDepartment: WideString;
Begin { Get_acDepartment }
  Result := FAccount.acDepartment;
End; { Get_acDepartment }

procedure TCOMCustomer.Set_acDepartment(const Value: WideString);
Begin { Set_acDepartment }
  FAccount.acDepartment := Value;
End; { Set_acDepartment }

{-----------------------------------------}

function TCOMCustomer.Get_acECMember: WordBool;
Begin { Get_acECMember }
  Result := FAccount.acECMember;
End; { Get_acECMember }

procedure TCOMCustomer.Set_acECMember(Value: WordBool);
Begin { Set_acECMember }
  FAccount.acECMember := Value;
End; { Set_acECMember }

{-----------------------------------------}

function TCOMCustomer.Get_acStatement: WordBool;
Begin { Get_acStatement }
  Result := FAccount.acStatement;
End; { Get_acStatement }

procedure TCOMCustomer.Set_acStatement(Value: WordBool);
Begin { Set_acStatement }
  FAccount.acStatement := Value;
End; { Set_acStatement }

{-----------------------------------------}

function TCOMCustomer.Get_acSalesGL: Integer;
Begin { Get_acSalesGL }
  Result := FAccount.acSalesGL;
End; { Get_acSalesGL }

procedure TCOMCustomer.Set_acSalesGL(Value: Integer);
Begin { Set_acSalesGL }
  FAccount.acSalesGL := Value;
End; { Set_acSalesGL }

{-----------------------------------------}

function TCOMCustomer.Get_acLocation: WideString;
Begin { Get_acLocation }
  Result := FAccount.acLocation;
End; { Get_acLocation }

procedure TCOMCustomer.Set_acLocation(const Value: WideString);
Begin { Set_acLocation }
  FAccount.acLocation := Value;
End; { Set_acLocation }

{-----------------------------------------}

function TCOMCustomer.Get_acAccStatus: TAccountStatus;
Begin { Get_acAccStatus }
  Result := FAccount.acAccStatus;
End; { Get_acAccStatus }

procedure TCOMCustomer.Set_acAccStatus(Value: TAccountStatus);
Begin { Set_acAccStatus }
  FAccount.acAccStatus := Value;
End; { Set_acAccStatus }

{-----------------------------------------}

function TCOMCustomer.Get_acPayType: WideString;
Begin { Get_acPayType }
  Result := FAccount.acPayType;
End; { Get_acPayType }

procedure TCOMCustomer.Set_acPayType(const Value: WideString);
Var
  TheChar : Char;
  TmpStr : String;
Begin { Set_acPayType }
  If (Length(Value) > 0) Then Begin
    TmpStr := Value;
    TheChar := TmpStr[1];
    FAccount.acPayType := TheChar;
  End; { If (Length(Value) > 0) }
End; { Set_acPayType }

{-----------------------------------------}

function TCOMCustomer.Get_acBankSort: WideString;
Begin { Get_acBankSort }
  // ICOMCustomer5 MH 10/09/2013 v7.0.6: Added longer Bank Sort Code for SEPA/IBAN
  Result := Get_acBankSortCode;
End; { Get_acBankSort }

procedure TCOMCustomer.Set_acBankSort(const Value: WideString);
Begin { Set_acBankSort }
  // ICOMCustomer5 MH 10/09/2013 v7.0.6: Added longer Bank Sort Code for SEPA/IBAN
  Set_acBankSortCode(Value);
End; { Set_acBankSort }

{-----------------------------------------}

function TCOMCustomer.Get_acBankAcc: WideString;
Begin { Get_acBankAcc }
  // ICOMCustomer5 MH 10/09/2013 v7.0.6: Added longer Bank Account Number for SEPA/IBAN
  Result := Get_acBankAccountCode;
End; { Get_acBankAcc }

procedure TCOMCustomer.Set_acBankAcc(const Value: WideString);
Begin { Set_acBankAcc }
  // ICOMCustomer5 MH 10/09/2013 v7.0.6: Added longer Bank Account Number for SEPA/IBAN
  Set_acBankAccountCode(Value);
End; { Set_acBankAcc }

{-----------------------------------------}

function TCOMCustomer.Get_acBankRef: WideString;
Begin { Get_acBankRef }
  Result := FAccount.acBankRef;
End; { Get_acBankRef }

procedure TCOMCustomer.Set_acBankRef(const Value: WideString);
Begin { Set_acBankRef }
  FAccount.acBankRef := Value;
End; { Set_acBankRef }

{-----------------------------------------}

function TCOMCustomer.Get_acPhone2: WideString;
Begin { Get_acPhone2 }
  Result := FAccount.acPhone2;
End; { Get_acPhone2 }

procedure TCOMCustomer.Set_acPhone2(const Value: WideString);
Begin { Set_acPhone2 }
  FAccount.acPhone2 := Value;
End; { Set_acPhone2 }

{-----------------------------------------}

function TCOMCustomer.Get_acCOSGL: Integer;
Begin { Get_acCOSGL }
  Result := FAccount.acCOSGL;
End; { Get_acCOSGL }

procedure TCOMCustomer.Set_acCOSGL(Value: Integer);
Begin { Set_acCOSGL }
  FAccount.acCOSGL := Value;
End; { Set_acCOSGL }

{-----------------------------------------}

function TCOMCustomer.Get_acDrCrGL: Integer;
Begin { Get_acDrCrGL }
  Result := FAccount.acDrCrGL;
End; { Get_acDrCrGL }

procedure TCOMCustomer.Set_acDrCrGL(Value: Integer);
Begin { Set_acDrCrGL }
  FAccount.acDrCrGL := Value;
End; { Set_acDrCrGL }

{-----------------------------------------}

function TCOMCustomer.Get_acLastUsed: WideString;
Begin { Get_acLastUsed }
  Result := FAccount.acLastUsed;
End; { Get_acLastUsed }

procedure TCOMCustomer.Set_acLastUsed(const Value: WideString);
Begin { Set_acLastUsed }
  FAccount.acLastUsed := Value;
End; { Set_acLastUsed }

{-----------------------------------------}

function TCOMCustomer.Get_acUserDef1: WideString;
Begin { Get_acUserDef1 }
  Result := FAccount.acUserDef1;
End; { Get_acUserDef1 }

procedure TCOMCustomer.Set_acUserDef1(const Value: WideString);
Begin { Set_acUserDef1 }
  FAccount.acUserDef1 := Value;
End; { Set_acUserDef1 }

{-----------------------------------------}

function TCOMCustomer.Get_acUserDef2: WideString;
Begin { Get_acUserDef2 }
  Result := FAccount.acUserDef2;
End; { Get_acUserDef2 }

procedure TCOMCustomer.Set_acUserDef2(const Value: WideString);
Begin { Set_acUserDef2 }
  FAccount.acUserDef2 := Value;
End; { Set_acUserDef2 }

{-----------------------------------------}

function TCOMCustomer.Get_acInvoiceTo: WideString;
Begin { Get_acInvoiceTo }
  Result := FAccount.acInvoiceTo;
End; { Get_acInvoiceTo }

procedure TCOMCustomer.Set_acInvoiceTo(const Value: WideString);
Begin { Set_acInvoiceTo }
  FAccount.acInvoiceTo := Value;
End; { Set_acInvoiceTo }

{-----------------------------------------}

function TCOMCustomer.Get_acSOPAutoWOff: WordBool;
Begin { Get_acSOPAutoWOff }
  Result := FAccount.acSOPAutoWOff;
End; { Get_acSOPAutoWOff }

procedure TCOMCustomer.Set_acSOPAutoWOff(Value: WordBool);
Begin { Set_acSOPAutoWOff }
  FAccount.acSOPAutoWOff := Value;
End; { Set_acSOPAutoWOff }

{-----------------------------------------}

function TCOMCustomer.Get_acFormSet: SmallInt;
Begin { Get_acFormSet }
  Result := FAccount.acFormSet;
End; { Get_acFormSet }

procedure TCOMCustomer.Set_acFormSet(Value: SmallInt);
Begin { Set_acFormSet }
  FAccount.acFormSet := Value;
End; { Set_acFormSet }

{-----------------------------------------}

function TCOMCustomer.Get_acBookOrdVal: Double;
Begin { Get_acBookOrdVal }
  Result := FAccount.acBookOrdVal;
End; { Get_acBookOrdVal }

procedure TCOMCustomer.Set_acBookOrdVal(Value: Double);
Begin { Set_acBookOrdVal }
  FAccount.acBookOrdVal := Value;
End; { Set_acBookOrdVal }

{-----------------------------------------}

function TCOMCustomer.Get_acDirDebMode: SmallInt;
Begin { Get_acDirDebMode }
  Result := FAccount.acDirDebMode;
End; { Get_acDirDebMode }

procedure TCOMCustomer.Set_acDirDebMode(Value: SmallInt);
Begin { Set_acDirDebMode }
  FAccount.acDirDebMode := Value;
End; { Set_acDirDebMode }

{-----------------------------------------}

function TCOMCustomer.Get_acAltCode: WideString;
Begin { Get_acAltCode }
  Result := FAccount.acAltCode;
End; { Get_acAltCode }

procedure TCOMCustomer.Set_acAltCode(const Value: WideString);
Begin { Set_acAltCode }
  FAccount.acAltCode := Value;
End; { Set_acAltCode }

{-----------------------------------------}

function TCOMCustomer.Get_acPostCode: WideString;
Begin { Get_acPostCode }
  Result := FAccount.acPostCode;
End; { Get_acPostCode }

procedure TCOMCustomer.Set_acPostCode(const Value: WideString);
Begin { Set_acPostCode }
  FAccount.acPostCode := Value;
End; { Set_acPostCode }

{-----------------------------------------}

function TCOMCustomer.Get_acUserDef3: WideString;
Begin { Get_acUserDef3 }
  Result := FAccount.acUserDef3;
End; { Get_acUserDef3 }

procedure TCOMCustomer.Set_acUserDef3(const Value: WideString);
Begin { Set_acUserDef3 }
  FAccount.acUserDef3 := Value;
End; { Set_acUserDef3 }

{-----------------------------------------}

function TCOMCustomer.Get_acUserDef4: WideString;
Begin { Get_acUserDef4 }
  Result := FAccount.acUserDef4;
End; { Get_acUserDef4 }

procedure TCOMCustomer.Set_acUserDef4(const Value: WideString);
Begin { Set_acUserDef4 }
  FAccount.acUserDef4 := Value;
End; { Set_acUserDef4 }

{-----------------------------------------}

function TCOMCustomer.Get_acEmailAddr: WideString;
Begin { Get_acEmailAddr }
  Result := FAccount.acEmailAddr;
End; { Get_acEmailAddr }

procedure TCOMCustomer.Set_acEmailAddr(const Value: WideString);
Begin { Set_acEmailAddr }
  FAccount.acEmailAddr := Value;
End; { Set_acEmailAddr }

{-----------------------------------------}

function TCOMCustomer.Get_acCCStart: WideString;
Begin { Get_acCCStart }
  Result := FAccount.acCCStart;
End; { Get_acCCStart }

procedure TCOMCustomer.Set_acCCStart(const Value: WideString);
Begin { Set_acCCStart }
  FAccount.acCCStart := Value;
End; { Set_acCCStart }

{-----------------------------------------}

function TCOMCustomer.Get_acCCEnd: WideString;
Begin { Get_acCCEnd }
  Result := FAccount.acCCEnd;
End; { Get_acCCEnd }

procedure TCOMCustomer.Set_acCCEnd(const Value: WideString);
Begin { Set_acCCEnd }
  FAccount.acCCEnd := Value;
End; { Set_acCCEnd }

{-----------------------------------------}

function TCOMCustomer.Get_acCCName: WideString;
Begin { Get_acCCName }
  Result := FAccount.acCCName;
End; { Get_acCCName }

procedure TCOMCustomer.Set_acCCName(const Value: WideString);
Begin { Set_acCCName }
  FAccount.acCCName := Value;
End; { Set_acCCName }

{-----------------------------------------}

function TCOMCustomer.Get_acCCNumber: WideString;
Begin { Get_acCCNumber }
  Result := FAccount.acCCNumber;
End; { Get_acCCNumber }

procedure TCOMCustomer.Set_acCCNumber(const Value: WideString);
Begin { Set_acCCNumber }
  FAccount.acCCNumber := Value;
End; { Set_acCCNumber }

{-----------------------------------------}

function TCOMCustomer.Get_acCCSwitch: WideString;
Begin { Get_acCCSwitch }
  Result := FAccount.acCCSwitch;
End; { Get_acCCSwitch }

procedure TCOMCustomer.Set_acCCSwitch(const Value: WideString);
Begin { Set_acCCSwitch }
  FAccount.acCCSwitch := Value;
End; { Set_acCCSwitch }

{-----------------------------------------}

function TCOMCustomer.Get_acAddress(Index: Integer): WideString;
Begin { Get_acAddress }
  Result := FAccount.acAddress[Index];
End; { Get_acAddress }

procedure TCOMCustomer.Set_acAddress(Index: Integer; const Value: WideString);
Begin { Set_acAddress }
  FAccount.acAddress[Index] := Value;
End; { Set_acAddress }

{-----------------------------------------}

function TCOMCustomer.Get_acDelAddress(Index: Integer): WideString;
Begin { Get_acDelAddress }
  Result := FAccount.acDelAddress[Index];
End; { Get_acDelAddress }

procedure TCOMCustomer.Set_acDelAddress(Index: Integer; const Value: WideString);
Begin { Set_acDelAddress }
  FAccount.acDelAddress[Index] := Value;
End; { Set_acDelAddress }

{-----------------------------------------}

function TCOMCustomer.Get_acTradeTerms(Index: Integer): WideString;
Begin { Get_acTradeTerms }
  Result := FAccount.acTradeTerms[Index];
End; { Get_acTradeTerms }

procedure TCOMCustomer.Set_acTradeTerms(Index: Integer; const Value: WideString);
Begin { Set_acTradeTerms }
  FAccount.acTradeTerms[Index] := Value;
End; { Set_acTradeTerms }

{-------------------------------------------------------------------------------------------------}

//
// ICOMCustomer2 properties
//

Function TCOMCustomer.Get_acDefTagNo: Integer;
Begin { Get_acDefTagNo }
  Result := FAccount.acDefTagNo;
End; { Get_acDefTagNo }

Procedure TCOMCustomer.Set_acDefTagNo(Value: Integer);
Begin { Set_acDefTagNo }
  FAccount.acDefTagNo := Value;
End; { Set_acDefTagNo }

{-----------------------------------------}

function TCOMCustomer.Get_acDefSettleDisc: Double;
begin
  Result := FAccount.acDefSettleDisc;
end;

procedure TCOMCustomer.Set_acDefSettleDisc(Value: Double);
begin
  FAccount.acDefSettleDisc := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acDefSettleDays: Integer;
begin
  Result := FAccount.acDefSettleDays;
end;

procedure TCOMCustomer.Set_acDefSettleDays(Value: Integer);
begin
  FAccount.acDefSettleDays := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acDocDeliveryMode: Integer;
begin
  Result := FAccount.acDocDeliveryMode;
end;

procedure TCOMCustomer.Set_acDocDeliveryMode(Value: Integer);
begin
  FAccount.acDocDeliveryMode := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acEbusPword: WideString;
begin
  Result := FAccount.acEbusPword;
end;

procedure TCOMCustomer.Set_acEbusPword(const Value: WideString);
begin
  FAccount.acEbusPword := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acUseForEbus: Integer;
begin
  Result := FAccount.acUseForEbus;
end;

procedure TCOMCustomer.Set_acUseForEbus(Value: Integer);
begin
  FAccount.acUseForEbus := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acWebLiveCatalog: WideString;
begin
  Result := FAccount.acWebLiveCatalog;
end;

procedure TCOMCustomer.Set_acWebLiveCatalog(const Value: WideString);
begin
  FAccount.acWebLiveCatalog := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acWebPrevCatalog: WideString;
begin
  Result := FAccount.acWebPrevCatalog;
end;

procedure TCOMCustomer.Set_acWebPrevCatalog(const Value: WideString);
begin
  FAccount.acWebPrevCatalog := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acInclusiveVATCode: WideString;
begin
  Result := FAccount.acInclusiveVATCode;
end;

procedure TCOMCustomer.Set_acInclusiveVATCode(const Value: WideString);
begin
  FAccount.acInclusiveVATCode := WideStrToChar (Value, ' ');
end;

{-----------------------------------------}

function TCOMCustomer.Get_acLastOperator: WideString;
begin
  Result := FAccount.acLastOperator;
end;

procedure TCOMCustomer.Set_acLastOperator(const Value: WideString);
begin
  FAccount.acLastOperator := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acSendHTML: WordBool;
begin
  Result := FAccount.acSendHTML;
end;

procedure TCOMCustomer.Set_acSendHTML(Value: WordBool);
begin
  FAccount.acSendHTML := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acSendReader: WordBool;
begin
  Result := FAccount.acSendReader;
end;

procedure TCOMCustomer.Set_acSendReader(Value: WordBool);
begin
  FAccount.acSendReader := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acZIPAttachments: Integer;
begin
  Result := FAccount.acZIPAttachments;
end;

procedure TCOMCustomer.Set_acZIPAttachments(Value: Integer);
begin
  FAccount.acZIPAttachments := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acSSDDeliveryTerms: WideString;
begin
  Result := FAccount.acSSDDeliveryTerms;
end;

procedure TCOMCustomer.Set_acSSDDeliveryTerms(const Value: WideString);
begin
  FAccount.acSSDDeliveryTerms := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acSSDModeOfTransport: Integer;
begin
  Result := FAccount.acSSDModeOfTransport;
end;

procedure TCOMCustomer.Set_acSSDModeOfTransport(Value: Integer);
begin
  FAccount.acSSDModeOfTransport := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acTimeStamp: WideString;
begin
  Result := FAccount.acTimeStamp;
end;

procedure TCOMCustomer.Set_acTimeStamp(const Value: WideString);
begin
  FAccount.acTimeStamp := Value;
end;

{-----------------------------------------}

function TCOMCustomer.Get_acStateDeliveryMode: Integer;
begin
  Result := FAccount.acStateDeliveryMode;
end;

procedure TCOMCustomer.Set_acStateDeliveryMode(Value: Integer);
begin
  FAccount.acStateDeliveryMode := Value;
end;

//------------------------------

function TCOMCustomer.Get_acHeadOffice: Integer;
begin
  Result := FAccount.acHeadOffice;
end;

procedure TCOMCustomer.Set_acHeadOffice(Value: Integer);
begin
  FAccount.acHeadOffice := Value;
end;

//=========================================================================

function TCOMCustomer.Get_acUserDef10: WideString;
begin
  Result := FAccount.acUserDef10;
end;

function TCOMCustomer.Get_acUserDef5: WideString;
begin
  Result := FAccount.acUserDef5;
end;

function TCOMCustomer.Get_acUserDef6: WideString;
begin
  Result := FAccount.acUserDef6;
end;

function TCOMCustomer.Get_acUserDef7: WideString;
begin
  Result := FAccount.acUserDef7;
end;

function TCOMCustomer.Get_acUserDef8: WideString;
begin
  Result := FAccount.acUserDef8;
end;

function TCOMCustomer.Get_acUserDef9: WideString;
begin
  Result := FAccount.acUserDef9;
end;

procedure TCOMCustomer.Set_acUserDef10(const Value: WideString);
begin
  FAccount.acUserDef10 := Value;
end;

procedure TCOMCustomer.Set_acUserDef5(const Value: WideString);
begin
  FAccount.acUserDef5 := Value;
end;

procedure TCOMCustomer.Set_acUserDef6(const Value: WideString);
begin
  FAccount.acUserDef6 := Value;
end;

procedure TCOMCustomer.Set_acUserDef7(const Value: WideString);
begin
  FAccount.acUserDef7 := Value;
end;

procedure TCOMCustomer.Set_acUserDef8(const Value: WideString);
begin
  FAccount.acUserDef8 := Value;
end;

procedure TCOMCustomer.Set_acUserDef9(const Value: WideString);
begin
  FAccount.acUserDef9 := Value;
end;

//------------------------------

// ICOMCustomer5 MH 10/09/2013 v7.0.6
function TCOMCustomer.Get_acBankSortCode: WideString;
Begin // Get_acBankSortCode
  Result := FAccount.acBankSortCode;
End; // Get_acBankSortCode
procedure TCOMCustomer.Set_acBankSortCode(const Value: WideString);
Begin // Set_acBankSortCode
  FAccount.acBankSortCode := Value;
End; // Set_acBankSortCode

//------------------------------

// ICOMCustomer5 MH 10/09/2013 v7.0.6
function TCOMCustomer.Get_acBankAccountCode: WideString;
Begin // Get_acBankAccountCode
  Result := FAccount.acBankAccountCode;
End; // Get_acBankAccountCode
procedure TCOMCustomer.Set_acBankAccountCode(const Value: WideString);
Begin // Set_acBankAccountCode
  FAccount.acBankAccountCode := Value;
End; // Set_acBankAccountCode

//------------------------------

// ICOMCustomer5 MH 10/09/2013 v7.0.6
function TCOMCustomer.Get_acMandateID: WideString;
Begin // Get_acMandateID
  Result := FAccount.acMandateID;
End; // Get_acMandateID
procedure TCOMCustomer.Set_acMandateID(const Value: WideString);
Begin // Set_acMandateID
  FAccount.acMandateID := Value;
End; // Set_acMandateID

//------------------------------

// ICOMCustomer5 MH 10/09/2013 v7.0.6
function TCOMCustomer.Get_acMandateDate: WideString;
Begin // Get_acMandateDate
  Result := FAccount.acMandateDate;
End; // Get_acMandateDate
procedure TCOMCustomer.Set_acMandateDate(const Value: WideString);
Begin // Set_acMandateDate
  FAccount.acMandateDate := Value;
End; // Set_acMandateDate

//-------------------------------------------------------------------------

// ICOMCustomer6 MH 15/10/2013 v7.0.7
function TCOMCustomer.Get_acDeliveryPostCode: WideString;
Begin // Get_acDeliveryPostCode
  Result := FAccount.acDeliveryPostCode;
End; // Get_acDeliveryPostCode
procedure TCOMCustomer.Set_acDeliveryPostCode(const Value: WideString);
Begin // Set_acDeliveryPostCode
  FAccount.acDeliveryPostCode := Value;
End; // Set_acDeliveryPostCode

//-------------------------------------------------------------------------

// ICOMCustomer7 MH 26/11/2013 v7.0.8
function TCOMCustomer.Get_acSubType: WideString;
Begin // Get_acSubType
  Result := FAccount.acSubType;
End; // Get_acSubType

//------------------------------

function TCOMCustomer.Get_acLongACCode: WideString;
Begin // Get_acLongACCode
  Result := FAccount.acLongACCode;
End; // Get_acLongACCode
procedure TCOMCustomer.Set_acLongACCode(const Value: WideString);
Begin // Set_acLongACCode
  FAccount.acLongACCode := Value;
End; // Set_acLongACCode

//-------------------------------------------------------------------------

// ICOMCustomer8 MH 11/05/2015 ABSEXCH-16419: Merged v7.0.14 changes in
function TCOMCustomer.Get_acPPDMode: Enterprise_TLB.TCustomerPPDMode;
Begin // Get_acPPDMode
  Case FAccount.acPPDMode Of
    CustABSU.pmPPDDisabled                         : Result := Enterprise_TLB.pmPPDDisabled;
    CustABSU.pmPPDEnabledWithAutoJournalCreditNote : Result := Enterprise_TLB.pmPPDEnabledWithAutoJournalCreditNote;
    CustABSU.pmPPDEnabledWithAutoCreditNote        : Result := Enterprise_TLB.pmPPDEnabledWithAutoCreditNote;
    CustABSU.pmPPDEnabledWithManualCreditNote      : Result := Enterprise_TLB.pmPPDEnabledWithManualCreditNote;
  End; // Case FAccount.acPPDMode
End; // Get_acPPDMode
procedure TCOMCustomer.Set_acPPDMode(Value: Enterprise_TLB.TCustomerPPDMode);
Begin // Set_acPPDMode
  Case Value Of
    Enterprise_TLB.pmPPDDisabled                         : FAccount.acPPDMode := CustABSU.pmPPDDisabled;
    Enterprise_TLB.pmPPDEnabledWithAutoJournalCreditNote : FAccount.acPPDMode := CustABSU.pmPPDEnabledWithAutoJournalCreditNote;
    Enterprise_TLB.pmPPDEnabledWithAutoCreditNote        : FAccount.acPPDMode := CustABSU.pmPPDEnabledWithAutoCreditNote;
    Enterprise_TLB.pmPPDEnabledWithManualCreditNote      : FAccount.acPPDMode := CustABSU.pmPPDEnabledWithManualCreditNote;
  End; // Case FAccount.acPPDMode
End; // Set_acPPDMode

//-------------------------------------------------------------------------

// ICOMCustomer8 MH 22/09/2014 Order Payments
function TCOMCustomer.Get_acAllowOrderPayments: WordBool;
Begin // Get_acAllowOrderPayments
  Result := FAccount.acAllowOrderPayments
End; // Get_acAllowOrderPayments

procedure TCOMCustomer.Set_acAllowOrderPayments(Value: WordBool);
Begin // Set_acAllowOrderPayments
  FAccount.acAllowOrderPayments := Value
End; // Set_acAllowOrderPayments

//-----------------------------

function TCOMCustomer.Get_acOrderPaymentsGLCode: Integer;
Begin // Get_acOrderPaymentsGLCode
  Result := FAccount.acOrderPaymentsGLCode
End; // Get_acOrderPaymentsGLCode

procedure TCOMCustomer.Set_acOrderPaymentsGLCode(Value: Integer);
Begin // Set_acOrderPaymentsGLCode
  FAccount.acOrderPaymentsGLCode := Value
End; // Set_acOrderPaymentsGLCode

//-------------------------------------------------------------------------

// ICOMCustomer8 MH 26/11/2014 ABSEXCH-15836: Added Country Codes
function TCOMCustomer.Get_acCountry: WideString;
Begin // Get_acCountry
  Result := FAccount.acCountry
End; // Get_acCountry
procedure TCOMCustomer.Set_acCountry(const Value: WideString);
Begin // Set_acCountry
  FAccount.acCountry := Value;
End; // Set_acCountry

//------------------------------

function TCOMCustomer.Get_acDeliveryCountry: WideString;
Begin // acDeliveryCountry
  Result := FAccount.acDeliveryCountry
End; // acDeliveryCountry
procedure TCOMCustomer.Set_acDeliveryCountry(const Value: WideString);
Begin // acDeliveryCountry
  FAccount.acDeliveryCountry := Value
End; // acDeliveryCountry

//-------------------------------------------------------------------------

// MH 20/01/2016 Exch2016R1 ABSEXCH-17114: Customisation mods for Intrastat changes - ICOMCustomer10
function TCOMCustomer.Get_acDefaultToQR: WordBool;
Begin // Get_acDefaultToQR
  Result := FAccount.acDefaultToQR;
End; // Get_acDefaultToQR
procedure TCOMCustomer.Set_acDefaultToQR(Value: WordBool);
Begin // Set_acDefaultToQR
  FAccount.acDefaultToQR := Value;
End; // Set_acDefaultToQR

//-------------------------------------------------------------------------

//RB 21/11/2017 2018-R1 ABSEXCH-19390: GDPR (POST 19346) - 8.3.1.1.1 - DLL + COM Customisation Support
function TCOMCustomer.Get_acAnonymisationStatus: Enterprise_TLB.TEntityAnonymisationStatus;
begin
  case FAccount.acAnonymisationStatus of
    CustABSU.asNotRequested : Result := Enterprise_TLB.asNotRequested;
    CustABSU.asPending : Result := Enterprise_TLB.asPending;
    CustABSU.asAnonymised : Result := Enterprise_TLB.asAnonymised;
  end;
end;
procedure TCOMCustomer.Set_acAnonymisationStatus(
  Value: TEntityAnonymisationStatus);
begin
  Case Value Of
    Enterprise_TLB.asNotRequested  : FAccount.acAnonymisationStatus := CustABSU.asNotRequested;
    Enterprise_TLB.asPending       : FAccount.acAnonymisationStatus := CustABSU.asPending;
    Enterprise_TLB.asAnonymised    : FAccount.acAnonymisationStatus := CustABSU.asAnonymised;
  End;
end;

//-------------------------------------------------------------------------

function TCOMCustomer.Get_acAnonymisedDate: WideString;
begin
  Result := FAccount.acAnonymisedDate;
end;
procedure TCOMCustomer.Set_acAnonymisedDate(const Value: WideString);
begin
  FAccount.acAnonymisedDate := Value;
end;

//-------------------------------------------------------------------------

function TCOMCustomer.Get_acAnonymisedTime: WideString;
begin
  Result := FAccount.acAnonymisedTime;
end;
procedure TCOMCustomer.Set_acAnonymisedTime(const Value: WideString);
begin
  FAccount.acAnonymisedTime := Value;
end;

//=========================================================================
end.

