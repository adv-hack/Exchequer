unit oCust;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve, oAddr,
     MiscFunc, BtrvU2, oCustBal, ExBtTh1U, oNotes, oAcDisc, GlobList, oLinks, oCSAnal, oMultiBuy,

     oAccountContact;

type
  TAccount = class(TBtrieveFunctions, IAccount, IBrowseInfo, IAccount2, IAccount3, IAccount4, IAccount5, IAccount6,
                   IAccount7, IAccount8, IAccount9, IAccount10, IAccount11, IAccount12)
  protected
    // Note: All properties protected to allow descendants access
    FAccountRec     : TBatchCURec;

    FAddressO       : TAddress;
    FAddressI       : IAddress;

    FDelAddrO       : TAddress;
    FDelAddrI       : IAddress;

    FDiscountO      : TAccountDiscount;
    FDiscountI      : IAccountDiscount;

    FHistoryO       : TAccountBalance;
    FHistoryI       : IAccountBalance;

    FNotesO         : TNotes;
    FNotesI         : INotes;

    FMultiBuyO      : TMultiBuy;
    FMultiBuyI      : IMultiBuy;



    FAccType        : Char;       // 'C'=Customer, 'S'=Supplier
    FIntfType       : TInterfaceMode;
    FParentAc       : TAccount;
    FToolkit        : TObject;

    FLinksO         : TLinks;
    FLinksI         : ILinks;

    FSalesAnalysisO : TCustomerSalesAnalysis;
    FSalesAnalysisI : ICustomerSalesAnalysis;

    //PR: 27/01/2014 ABSEXCH-14974
    ContactsListO   : TAccountContactsList;
    ContactsListI   : IAccountContactsList;

    // IAccountBase
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
    function  Get_acAddress: IAddress; safecall;
    function  Get_acDelAddress: IAddress; safecall;
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
    function  Get_acTradeTerms(Index: Integer): WideString; safecall;
    procedure Set_acTradeTerms(Index: Integer; const Value: WideString); safecall;
    function  Get_acCurrency: Smallint; safecall;
    procedure Set_acCurrency(Value: Smallint); safecall;
    function  Get_acVATCode: WideString; safecall;
    procedure Set_acVATCode(Const Value: WideString); safecall;
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
    function  Get_acLastUsed: WideString; safecall;
    procedure Set_acLastUsed(const Value: WideString); safecall;
    function  Get_acPhone2: WideString; safecall;
    procedure Set_acPhone2(const Value: WideString); safecall;
    function  Get_acUserDef1: WideString; safecall;
    procedure Set_acUserDef1(const Value: WideString); safecall;
    function  Get_acUserDef2: WideString; safecall;
    procedure Set_acUserDef2(const Value: WideString); safecall;
    function  Get_acInvoiceTo: WideString; safecall;
    procedure Set_acInvoiceTo(const Value: WideString); safecall;
    function  Get_acSOPAutoWOff: WordBool; safecall;
    procedure Set_acSOPAutoWOff(Value: WordBool); safecall;
    function  Get_acBookOrdVal: Double; safecall;
    procedure Set_acBookOrdVal(Value: Double); safecall;
    function  Get_acCOSGL: Integer; safecall;
    procedure Set_acCOSGL(Value: Integer); safecall;
    function  Get_acDrCrGL: Integer; safecall;
    procedure Set_acDrCrGL(Value: Integer); safecall;
    function  Get_acDirDebMode: Smallint; safecall;
    procedure Set_acDirDebMode(Value: Smallint); safecall;
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
    function  Get_acDefSettleDays: Integer; safecall;
    procedure Set_acDefSettleDays(Value: Integer); safecall;
    function  Get_acDefSettleDisc: Double; safecall;
    procedure Set_acDefSettleDisc(Value: Double); safecall;
    function  Get_acFormSet: Smallint; safecall;
    procedure Set_acFormSet(Value: Smallint); safecall;
    function  Get_acStateDeliveryMode: Integer; safecall;
    procedure Set_acStateDeliveryMode(Value: Integer); safecall;
    function  Get_acEmailAddr: WideString; safecall;
    procedure Set_acEmailAddr(const Value: WideString); safecall;
    function  Get_acSendReader: WordBool; safecall;
    procedure Set_acSendReader(Value: WordBool); safecall;
    function  Get_acEBusPword: WideString; safecall;
    procedure Set_acEBusPword(const Value: WideString); safecall;
    function  Get_acAltCode: WideString; safecall;
    procedure Set_acAltCode(const Value: WideString); safecall;
    function  Get_acPostCode: WideString; safecall;
    procedure Set_acPostCode(const Value: WideString); safecall;
    function  Get_acUseForEbus: Integer; safecall;
    procedure Set_acUseForEbus(Value: Integer); safecall;
    function  Get_acZIPAttachments: TEmailAttachmentZIPType; safecall;
    procedure Set_acZIPAttachments(Value: TEmailAttachmentZIPType); safecall;
    function  Get_acUserDef3: WideString; safecall;
    procedure Set_acUserDef3(const Value: WideString); safecall;
    function  Get_acUserDef4: WideString; safecall;
    procedure Set_acUserDef4(const Value: WideString); safecall;
    function  Get_acTimeStamp: WideString; safecall;
    function  Get_acSSDDeliveryTerms: WideString; safecall;
    procedure Set_acSSDDeliveryTerms(const Value: WideString); safecall;
    function  Get_acInclusiveVATCode: WideString; safecall;
    procedure Set_acInclusiveVATCode(const Value: WideString); safecall;
    function  Get_acSSDModeOfTransport: Integer; safecall;
    procedure Set_acSSDModeOfTransport(Value: Integer); safecall;
    function  Get_acLastOperator: WideString; safecall;
    procedure Set_acLastOperator(const Value: WideString); safecall;
    function  Get_acDocDeliveryMode: Integer; safecall;
    procedure Set_acDocDeliveryMode(Value: Integer); safecall;
    function  Get_acSendHTML: WordBool; safecall;
    procedure Set_acSendHTML(Value: WordBool); safecall;
    function  Get_acWebLiveCatalog: WideString; safecall;
    procedure Set_acWebLiveCatalog(const Value: WideString); safecall;
    function  Get_acWebPrevCatalog: WideString; safecall;
    procedure Set_acWebPrevCatalog(const Value: WideString); safecall;
    function  Get_acHistory: IAccountBalance; safecall;
    function  Get_acNotes: INotes; safecall;
    function  Get_acDiscounts: IAccountDiscount; safecall;

    //IAccount2 interface
    function Get_acDefTagNo: Integer; safecall;
    procedure Set_acDefTagNo(Value: Integer); safecall;
    function Get_acOfficeType: TAccountOfficeType; safecall;
    procedure Set_acOfficeType(Value: TAccountOfficeType); safecall;
    function Get_acOrderConsolidationMode: TOrderConsolidationModeType; safecall;
    procedure Set_acOrderConsolidationMode(Value: TOrderConsolidationModeType); safecall;
    function Get_acVATCountryCode: WideString; safecall;
    procedure Set_acVATCountryCode(const Value: WideString); safecall;
    function Get_acLinks: ILinks; safecall;
    function Get_acSalesAnalysis: ICustomerSalesAnalysis; safecall;
    function Print(PrintAs: TAccountPrintMode): IPrintJob; safecall;

    //PR: 14/04/2009 IAccount3 interface
    function Get_acMultiBuy: IMultiBuy; safecall;

    function  BuildCodeIndex(const AccountCode: WideString): WideString; safecall;
    function  BuildNameIndex(const AccountName: WideString): WideString; safecall;
    function  BuildAltCodeIndex(const AlternateCode: WideString): WideString; safecall;
    function  BuildVatRegIndex(const VatRegNo: WideString; const AccountCode: WideString): WideString; safecall;
    function  BuildEmailIndex(const EmailAddr: WideString): WideString; safecall;
    function  BuildPhoneIndex(const PhoneNo: WideString): WideString; safecall;
    function  BuildPostCodeIndex(const PostCode: WideString): WideString; safecall;
    function  BuildOurCodeIndex(const OurCode: WideString): WideString; safecall;
    function  BuildInvoiceToIndex(const AccountCode: WideString): WideString; safecall;


    //PR: 25/10/2011 IAccount4 interface v6.9
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

    //PR: 10/09/2013 ABSEXCH-14598 IAccount5 interface v7.0.6
    function Get_acMandateID: WideString; safecall;
    procedure Set_acMandateID(const Value: WideString); safecall;
    function Get_acMandateDate: WideString; safecall;
    procedure Set_acMandateDate(const Value: WideString); safecall;


    //PR: 14/10/2013 MRD 2.5.18 v7.0.7 IAccount6
    function Get_acDeliveryPostCode: WideString; safecall;
    procedure Set_acDeliveryPostCode(const Value: WideString); safecall;


    //PR: 14/11/2013 MRD 1.1.43
    function Get_acSubType: TAccountSubType; safecall;
    procedure Set_acSubType(Value: TAccountSubType); safecall;
    function Get_acLongACCode: WideString; safecall;
    procedure Set_acLongACCode(const Value: WideString); safecall;

    //PR: 28/11/2013 ABSEXCH-14797 New Indexes for consumer changes
    function BuildSubTypeAndCodeIndex(SubType: TAccountSubType; const Code: WideString): WideString; safecall;
    function BuildSubTypeAndLongCodeIndex(SubType: TAccountSubType; const LongCode: WideString): WideString; safecall;
    function BuildSubTypeAndNameIndex(SubType: TAccountSubType; const CoName: WideString): WideString; safecall;
    function BuildSubTypeAndAltCodeIndex(SubType: TAccountSubType; const AltCode: WideString): WideString; safecall;

    //PR: 27/01/2014 ABSEXCH-14974 IAccount8
    function Get_acContacts: IAccountContactsList; safecall;

    //PR: 12/05/2015 ABSEXCH-16284 IAccount9 v7.0.14
    function Get_acPPDMode: TAccountPPDMode; safecall;
    procedure Set_acPPDMode(Value: TAccountPPDMode); safecall;

    // CJS 2014-08-04 - v7.x Order Payments - T097 - IAccount9 - new fields
    function Get_acAllowOrderPayments: WordBool; safecall;
    procedure Set_acAllowOrderPayments(Value: WordBool); safecall;
    function Get_acOrderPaymentsGLCode: Integer; safecall;
    procedure Set_acOrderPaymentsGLCode(Value: Integer); safecall;

    //PR: 22/01/2016 ABSEXCH-17112 v2016 R1 IAccount11 Default to QR field for Intrastat
    function Get_acDefaultToQR: WordBool; safecall;
    procedure Set_acDefaultToQR(Value: WordBool); safecall;

    //AP: 15/11/2017 ABSEXCH-19389 v2018 R1 IAccount12 : New fileds introduced for GDPR
    function Get_acAnonymisationStatus: TEntityAnonymisationStatusType; safecall;
    function Get_acAnonymisedDate: WideString; safecall;
    function Get_acAnonymisedTime: WideString; safecall;

    function  Get_Index: TAccountIndex; safecall;
    procedure Set_Index(Value: TAccountIndex); safecall;


    function Add: IAccount; safecall;
    function Clone: IAccount; safecall;
    function Update: IAccount; safecall;

    // IAccountAdd
    function Save: Integer; safecall;

    // IAccountUpdate
    {function Save: Integer; safecall;}  { Implemented for Add }
    procedure Cancel; safecall;

    // IAddress / TAddress implementation
    //PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
    function GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
    Procedure SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Function TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt; OverRide;

    // Local Methods
    Procedure CloneDetails (Const AccDets : TBatchCURec);
    Procedure InitNewAccount;
    Procedure InitObjects;
    Procedure LoadDetails (Const AccDets : TBatchCURec; Const LockPos : LongInt);

    //PR: 16/01/2015 ABSEXCH-16044 Default from system
    function CountryCodeFromEALCountryNumber : string;

  public
    ObjDescr : ShortString;

    Constructor Create (Const AcType   : Char;
                        Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const ParentAc : TAccount;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;

    Function GetCloneInterface (Const AcCode : ShortString) : IAccount;
  End; { TAccount }


Function CreateTAccount (Const Toolkit  : TObject; Const AcType : Char; Const ClientId : Integer) : TAccount;

implementation

uses ComServ, DLL01U, DllErrU, BtKeys1U, EtStrU,
     EnterpriseForms_TLB,    // Type Library for Form Printing Toolkit
     oPrntJob,               // COM Toolkit Print Job Object
     VarRec2U,
     SQLFields,
     MultiBuyVar,
     ConsumerUtils;

{-------------------------------------------------------------------------------------------------}

Function CreateTAccount (Const Toolkit  : TObject; Const AcType : Char; Const ClientId : Integer) : TAccount;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TAccount object
  BtrIntf^.Open_System(CustF,  CustF);
  BtrIntf^.Open_System(PwrdF,  PwrdF);   { Account Notes }
  BtrIntf^.Open_System(MiscF,  MiscF);   { Account Discounts }
  BtrIntf^.Open_System(StockF, StockF);  { Account Discounts }
  BtrIntf^.Open_System(MlocF, MLocF);  { Sales Analysis }
  BtrIntf^.Open_System(NHistF, NHistF);  { Sales Analysis History}
  BtrIntf^.Open_System(MultiBuyF, MultiBuyF);  {Multi-Buy Discounts}


  // Create bas TAccount object
  Result := TAccount.Create(AcType, imGeneral, Toolkit, Nil, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([CustF, PwrdF, StockF, MLocF, NHistF, MiscF]);

End; { CreateTAccount }

{-------------------------------------------------------------------------------------------------}

Constructor TAccount.Create (Const AcType   : Char;
                             Const IType    : TInterfaceMode;
                             Const Toolkit  : TObject;
                             Const ParentAc : TAccount;
                             Const BtrIntf  : TCtkTdPostExLocalPtr);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IAccount12, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := CustF;

  // Initialise variables
  FillChar (FAccountRec, SizeOf(FAccountRec), #0);
  InitObjects;

  FToolkit := Toolkit;

  // Setup Link for child Customer objects to parent custom object
  FAccType  := AcType;
  FIntfType := IType;
  If Assigned(ParentAc) Then Begin
    FParentAc := ParentAc;
    FIndex := FParentAc.FIndex;
  End { If Assigned(ParentAc) }
  Else Begin
    FParentAc := Self;
    Set_Index(acIdxCode);
  End; { Else }

  If (FAccType = 'C') Then
  begin
    ObjDescr := 'Customer';
    FObjectID := tkoCustomer;
  end
  Else
  begin
    ObjDescr := 'Supplier';
    FObjectID := tkoSupplier;
  end;

End; { Create }

{-----------------------------------------}

Destructor TAccount.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TAccount.InitObjects;
Begin { Destroy }
  FAddressO := Nil;
  FAddressI := Nil;

  FDelAddrO := Nil;
  FDelAddrI := Nil;

  FDiscountO := NIL;
  FDiscountI := NIL;

  FHistoryO := Nil;
  FHistoryI := Nil;

  FNotesO := NIL;
  FNotesI := NIL;

  FParentAc := Nil;

  FToolkit := NIL;

  FLinksO := nil;
  FLinksI := nil;

  FMultiBuyO :=nil;
  FMultiBuyI :=nil;

  ContactsListO := nil;
  ContactsListI := nil;

End; { Destroy }

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TAccount.AuthoriseFunction (Const FuncNo     : Byte;
                                     Const MethodName : String;
                                     Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as CustF is shared file }

    5..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);

    // .acNotes property
    201       : Result := (FIntfType = imGeneral);

    // .acDiscounts property
    202       : Result := (FIntfType In [imGeneral, imClone]);

    // .acLinks property
    203       : Result := (FIntfType = imGeneral);

    // .acSalesAnalysis
    204       : Result := (FAccType = 'C') and (FIntfType in [imGeneral, imClone]);

    // .acMultiBuy property
    205       : Result := (FIntfType In [imGeneral, imClone]);

    // .acMandateID/acMandateDate properties - apply to customer only
    206       : Result := (FAccType = 'C');



  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
End; { AuthoriseFunction }

{-----------------------------------------}

// Used by btrieve ancestor class to convert the interface index
// number into the actual Btrieve index number
Function TAccount.TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt;
begin { TranslateIndex }
  If FromTLB Then Begin
    // Converting a TLB Index number into an Enterprise File Index Number
    Case IdxNo Of
      acIdxCode     : Result := 5;
      acIdxName     : Result := 6;
      acIdxAltCode  : Result := 7;
      acIdxVATRegNo : Result := 2;
      acIdxEmail    : Result := 11;
      acIdxPhone    : Result := 3;
      acIdxPostCode : Result := 8;
      acIdxOurCode  : Result := 9;
      acIdxInvTo    : Result := 10;

      //PR: 28/11/2013 ABSEXCH-14797 New Indexes for consumer changes
      acIdxSubTypeAndCode     : Result := CustACCodeK;
      acIdxSubTypeAndLongCode : Result := CustLongACCodeK;
      acIdxSubTypeAndName     : Result := CustNameK;
      acIdxSubTypeAndAltCode  : Result := CustAltCodeK;
    Else
      Raise EInvalidIndex.Create ('Index ' + IntToStr(IdxNo) + ' is not valid in the ' + ObjDescr + ' object');
    End; { Case }
  End { If FromTLB  }
  Else Begin
    // Converting an Enterprise File Index Number into a TLB Index Number
    Case IdxNo Of
      5  : Result := acIdxCode;
      6  : Result := acIdxName;
      7  : Result := acIdxAltCode;
      2  : Result := acIdxVATRegNo;
      11 : Result := acIdxEmail;
      3  : Result := acIdxPhone;
      8  : Result := acIdxPostCode;
      9  : Result := acIdxOurCode;
      10 : Result := acIdxInvTo;

      //PR: 28/11/2013 ABSEXCH-14797 New Indexes for consumer changes
      CustACCodeK     : Result := acIdxSubTypeAndCode;
      CustLongACCodeK : Result := acIdxSubTypeAndLongCode;
      CustNameK       : Result := acIdxSubTypeAndName;
      CustAltCodeK    : Result := acIdxSubTypeAndAltCode;
    Else
      Raise EInvalidIndex.Create ('The ' + ObjDescr + ' object is using an invalid index');
    End; { Case }
  End; { Else }
End; { TranslateIndex }

{-----------------------------------------}

Procedure TAccount.CopyDataRecord;
Begin { CopyDataRecord }
  CopyExCustToTKCust(FBtrIntf^.LCust, FAccountRec)
End; { CopyDataRecord }

{-----------------------------------------}

Function TAccount.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  With FBtrIntf^ Do Begin

    // Check to see if we are using a general index or a Customer/Supplier specific index
    If (FIndex In [2, 5, 6, 7, 11]) Then Begin
      // Index based on 'C'/'S' flag - translate Btrieve operations where necessary
      Case BtrOp Of
        B_GetFirst    : Begin
                          KeyS := FAccType + #0;
                          BtrOpCode := B_GetGEq;
                        End; { B_GetFirst }
        B_GetLast     : Begin
                          KeyS := FAccType + #255;
                          BtrOpCode := B_GetLessEq;
                        End; { B_GetLast }
      Else
        // B_GetNext, B_GetPrev,
        KeyS := FAccType + SetKeyString(BtrOp, SearchKey);
        BtrOpCode := BtrOp;
      End; { Case BtrOp }

      // Get record
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      FKeyString := Copy (KeyS, 2, Length(KeyS));
    End { If (FIndex In [2, 5, 6, 7, 11]) }
    Else Begin
      // General index including both Customer and Supplier records

      Loop := True;
      Case BtrOp of
        // Moving forward through file
        B_GetGEq,
        B_GetGretr,
        B_GetNext,
        B_GetFirst   : BtrOpCode2 := B_GetNext;

        // Moving backward through file
        B_GetLess,
        B_GetLessEq,
        B_GetPrev,
        B_GetLast    : BtrOpCode2 := B_GetPrev;

        // Looking for exact match - do it and finish
        B_GetEq      : Loop := False;
      Else
        Raise Exception.Create ('Invalid Btrieve Operation');
      End; { Case BtrOp}

      BtrOpCode := BtrOp;
      KeyS := SetKeyString(BtrOp, SearchKey);

      Repeat
        Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

        BtrOpCode := BtrOpCode2;
      Until (Result <> 0) Or (Not Loop) Or (LCust.CustSupp=FAccType);

      FKeyString := KeyS;
    End; { Else }

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LCust.CustSupp = FAccType) Then
        // Convert to Toolkit structure
        CopyDataRecord
      Else
      //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
      Begin
        If BtrOp = B_GetEq Then
          Result := 4
        else
          Result := 9; 
      End;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (3, Result);
End; { GetDataRecord }

{-------------------------------------------------------------------------------------------------}

Procedure TAccount.InitNewAccount;
Begin { InitNewAccount }
  FillChar (FAccountRec, SizeOf(FAccountRec), #0);
  With FAccountRec Do Begin
    // Account Type
    CustSupp := FAccType;

    // Currency
    If ExSyss.MCMode Then
      Currency := 1          // Euro or Global
    Else
      Currency := 0;         // Professional

    // VAT Code
    VATCode := Syss.VATCode;

    // Payment Type
    PayType := 'C';         // Cash

    // Payment Terms
    PayTerms := Syss.PayTerms;

    // Despatch Address?
    DespAddr := False;

    // Send Statement?
    IncStat := (FAccType = 'C');

    // Terms Of Trade
    STerms[1] := Syss.TermsofTrade[1];
    STerms[2] := Syss.TermsofTrade[2];

    // Settlement Discount
    // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
    DefSetDisc := 0.0; //Syss.SettleDisc;
    DefSetDDays := 0; //Syss.SettleDays;

    //AP : 15/12/2016 ABSEXCH-17609 : COM Toolkit is initialising new IAccount objects with intrastat fields
    // Removed default initialization of values of 'SSDDelTerms' and 'SSDModeTr' while Intrastat is "On" from here 

    // Web / Paperless
    EmlSndRdr := BOn;

    //PR: 16/01/2015 ABSEXCH-16044 Default country from config is set, otherwise from system
    if Trim(ExSyss.DefaultCountryCode) <> '' then
      acCountry := ExSyss.DefaultCountryCode
    else
      acCountry := CountryCodeFromEALCountryNumber;

    //Set delivery country to the same
    acDeliveryCountry := acCountry;


  End; { With FAccountRec }
End; { InitNewAccount }

{-----------------------------------------}

function TAccount.Add: IAccount;
Var
  FAccountO : TAccount;
begin { Add }
  AuthoriseFunction(100, 'Add');

  FAccountO := TAccount.Create(FAccType, imAdd, FToolkit, FParentAc, FBtrIntf);
  FAccountO.InitNewAccount;

  Result := FAccountO;
end; { Add }

{-----------------------------------------}

Procedure TAccount.LoadDetails (Const AccDets : TBatchCURec; Const LockPos : LongInt);
begin
  FAccountRec := AccDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

{-----------------------------------------}

function TAccount.Update: IAccount;
Var
  FAccountO : TAccount;
  FuncRes   : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    FAccountO := TAccount.Create(FAccType, imUpdate, FToolkit, FParentAc, FBtrIntf);

    // Pass current Account Record and Locking Details into sub-object
    FAccountO.LoadDetails(FAccountRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := FAccountO;
  End; { If (FuncRes = 0) }
end; { Update }

{-----------------------------------------}

Procedure TAccount.CloneDetails (Const AccDets : TBatchCURec);
begin
  FAccountRec := AccDets;
end;

{-----------------------------------------}

Function TAccount.GetCloneInterface (Const AcCode : ShortString) : IAccount;
Var
  SaveInfo : TBtrieveFileSavePos;
  lAcCode  : ShortString;
  Res      : LongInt;
Begin { GetCloneInterface }
  Result := NIL;

  // Reformat as valid account code
  lAcCode := FullCustCode(AcCode);

  // Check not blank
  If (Trim(lAcCode) <> '') Then Begin
    // Save Current Position and index
    SaveExLocalPosRec (SaveInfo, @FAccountRec, SizeOf(FAccountRec));

    // Find record for AcCode
    Set_Index(acIdxCode);
    Res := GetDataRecord (B_GetEq, lAcCode);
    If (Res = 0) Then Begin
      // Got Record - generate and return a Clone interface
      Result := Clone;
    End; { If (Res = 0) }

    // Restore Original Index and position
    RestoreExLocalPosRec (SaveInfo, @FAccountRec, SizeOf(FAccountRec));
  End; { If (Trim(lAcCode) <> '') }
End; { GetCloneInterface }

{-----------------------------------------}

function TAccount.Clone: IAccount;
Var
  FAccountO : TAccount;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Customer Account object and initialise
  FAccountO := TAccount.Create(FAccType, imClone, FToolkit, FParentAc, FBtrIntf);
  FAccountO.CloneDetails(FAccountRec);

  Result := FAccountO;
End; { Clone }

{-----------------------------------------}

function TAccount.Save: Integer;
Var
  SaveInfo     : TBtrieveFileSavePos;
  SaveInfo2    : TBtrieveFileSavePos;
  BtrOp, Res   : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save Current Position in global customer file
  SaveMainPos(SaveInfo);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Res := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Res := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Res = 0) Then Begin
    // Add/Update Stock
    SaveExLocalPos(SaveInfo2);
    Res := Ex_StoreAccount (@FAccountRec,           // P
                            SizeOf(FAccountRec),    // PSize
                            FIndex,                 // SearchPath
                            BtrOp);                 // SearchMode
    RestoreExLocalPos(SaveInfo2);
  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

{-----------------------------------------}

procedure TAccount.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{-------------------------------------------------------------------------------------------------}

{ IAccount }
function TAccount.Get_acCode: WideString;
begin
  Result := FAccountRec.CustCode;
end;

procedure TAccount.Set_acCode(const Value: WideString);
begin
  If (FIntfType = imAdd) Then
    FAccountRec.CustCode := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCompany: WideString;
begin
  Result := FAccountRec.Company;
end;

procedure TAccount.Set_acCompany(const Value: WideString);
begin
  FAccountRec.Company := Value;
end;

{-----------------------------------------}

function TAccount.Get_acArea: WideString;
begin
  Result := FAccountRec.AreaCode;
end;

procedure TAccount.Set_acArea(const Value: WideString);
begin
  FAccountRec.AreaCode := Value;
end;

{-----------------------------------------}

function TAccount.Get_acAccType: WideString;
begin
  Result := FAccountRec.RepCode;
end;

procedure TAccount.Set_acAccType(const Value: WideString);
begin
  FAccountRec.RepCode := Value;
end;

{-----------------------------------------}

function TAccount.Get_acStatementTo: WideString;
begin
  Result := FAccountRec.RemitCode;
end;

procedure TAccount.Set_acStatementTo(const Value: WideString);
begin
  FAccountRec.RemitCode := Value;

  // Validate Account Code here ?
end;

{-----------------------------------------}

function TAccount.Get_acVATRegNo: WideString;
begin
  Result := FAccountRec.VATRegNo;
end;

procedure TAccount.Set_acVATRegNo(const Value: WideString);
begin
  FAccountRec.VATRegNo := Value;
end;

{-----------------------------------------}
//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
//PR: 26/11/2014 Order Payments Add Country Codes
function TAccount.GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
begin
  With FAccountRec Do
    Case AddrIdx Of
      { Address }
      1  :  if Idx = IDX_COUNTRY then
              Result := acCountry
            else
              Result := Addr[Idx];

      { Delivery Address }
      //PR: 15/10/2013 MRD 2.5.18 Redirect to postcode field if required
      2  : if Idx = IDX_COUNTRY then
             Result := acDeliveryCountry
           else
           if DirectToLines or (Idx <> 5) or (ExSyss.AddressPostcodeMapping = pmDeliveryAddressLine5) then
             Result := DAddr[Idx]
           else
             Result := acDeliveryPostcode;
    Else
      Result := '';
    End; { Case AddrIdx }
end;

//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
//PR: 26/11/2014 Order Payments Add Country Code
Procedure TAccount.SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);
begin
  With FAccountRec Do
    Case AddrIdx Of
      { Address }
      1  :   if Idx = IDX_COUNTRY then //Set Country Code
               acCountry := Value
             else
               Addr[Idx] := Value;

      { Delivery Address }
      //PR: 15/10/2013 MRD 2.5.18 Redirect to postcode field if required
      2  : if Idx = IDX_COUNTRY then  //Set Country Code
             acDeliveryCountry := Value
           else
           if DirectToLines or (Idx <> 5) or (ExSyss.AddressPostcodeMapping = pmDeliveryAddressLine5) then
             DAddr[Idx] := Value
           else
             acDeliveryPostcode := Value;
    End; { Case AddrIdx }
end;

function TAccount.Get_acAddress: IAddress;
begin
  If (Not Assigned(FAddressO)) Then Begin
    { Create and initialise Customer Address Sub-Object}
    FAddressO := TAddress.Create(1, GetAddrLine, SetAddrLine);

    FAddressI := FAddressO;
  End; { If (Not Assigned(FAddressO)) }

  Result := FAddressI;
end;

{-----------------------------------------}

function TAccount.Get_acDelAddress: IAddress;
begin
  If (Not Assigned(FDelAddrO)) Then Begin
    { Create and initialise Customer Delivery Address Sub-Object}
    FDelAddrO := TAddress.Create(2, GetAddrLine, SetAddrLine);

    FDelAddrI := FDelAddrO;
  End; { If (Not Assigned(FDelAddrO)) }

  Result := FDelAddrI;
end;

{-----------------------------------------}

function TAccount.Get_acContact: WideString;
begin
  Result := FAccountRec.Contact;
end;

procedure TAccount.Set_acContact(const Value: WideString);
begin
  FAccountRec.Contact := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCostCentre: WideString;
begin
  Result := FAccountRec.CustCC;
end;

procedure TAccount.Set_acCostCentre(const Value: WideString);
begin
  FAccountRec.CustCC := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCreditLimit: Double;
begin
  Result := FAccountRec.CreditLimit;
end;

procedure TAccount.Set_acCreditLimit(Value: Double);
begin
  FAccountRec.CreditLimit := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCreditStatus: Smallint;
begin
  Result := FAccountRec.CreditStatus;
end;

procedure TAccount.Set_acCreditStatus(Value: Smallint);
begin
  FAccountRec.CreditStatus := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCurrency: Smallint;
begin
  Result := FAccountRec.Currency;
end;

procedure TAccount.Set_acCurrency(Value: Smallint);
begin
  FAccountRec.Currency := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TAccount.Get_acDepartment: WideString;
begin
  Result := FAccountRec.CustDep;
end;

procedure TAccount.Set_acDepartment(const Value: WideString);
begin
  FAccountRec.CustDep := Value;
end;

{-----------------------------------------}

function TAccount.Get_acDiscount: Double;
begin
  Result := FAccountRec.Discount;
end;

procedure TAccount.Set_acDiscount(Value: Double);
begin
  FAccountRec.Discount := Value;
end;

{-----------------------------------------}

function TAccount.Get_acDiscountBand: WideString;
begin
  Result := FAccountRec.CDiscCh;
end;

procedure TAccount.Set_acDiscountBand(const Value: WideString);
Var
  CharVal : Char;
begin
{PR: Passing an empty string or a space was causing a range-check error as the space was removed by trim.
 Change position of Trim to fix.}
//  CharVal := UpperCase(Trim(Copy(Value + ' ', 1, 1)))[1];
  CharVal := UpperCase(Copy(Trim(Value) + ' ', 1, 1))[1];

  If (CharVal In [' ', '%', 'A'..'H']) Then
    FAccountRec.CDiscCh := CharVal
  Else
    Raise EValidation.Create ('Invalid Discount Band (' + CharVal + ')');
end;

{-----------------------------------------}

function TAccount.Get_acFax: WideString;
begin
  Result := FAccountRec.Fax;
end;

procedure TAccount.Set_acFax(const Value: WideString);
begin
  FAccountRec.Fax := Value;
end;

{-----------------------------------------}

function TAccount.Get_acOwnTradTerm: WordBool;
begin
  Result := FAccountRec.TradTerm;
end;

procedure TAccount.Set_acOwnTradTerm(Value: WordBool);
begin
  FAccountRec.TradTerm := Value;
end;

{-----------------------------------------}

function TAccount.Get_acPayTerms: Smallint;
begin
  Result := FAccountRec.PayTerms;
end;

procedure TAccount.Set_acPayTerms(Value: Smallint);
begin
  FAccountRec.PayTerms := Value;
end;

{-----------------------------------------}

function TAccount.Get_acPhone: WideString;
begin
  Result := FAccountRec.Phone;
end;

procedure TAccount.Set_acPhone(const Value: WideString);
begin
  FAccountRec.Phone := Value;
end;

{-----------------------------------------}

function TAccount.Get_acTheirAcc: WideString;
begin
  Result := FAccountRec.RefNo;
end;

procedure TAccount.Set_acTheirAcc(const Value: WideString);
begin
  FAccountRec.RefNo := Value;
end;

{-----------------------------------------}

function TAccount.Get_acTradeTerms(Index: Integer): WideString;
begin
  Result := FAccountRec.STerms[Index];
end;

procedure TAccount.Set_acTradeTerms(Index: Integer; const Value: WideString);
begin
  FAccountRec.STerms[Index] := Value;
end;

{-----------------------------------------}

function TAccount.Get_acVATCode: WideString;
begin
  Result := FAccountRec.VATCode;
end;

procedure TAccount.Set_acVATCode(Const Value: WideString);
begin
  FAccountRec.VATCode := ExtractChar (Value, ' ');
end;

{-----------------------------------------}

function TAccount.Get_acAccStatus: TAccountStatus;
begin
  Case FAccountRec.AccStatus Of
    0 : Result := asOpen;
    1 : Result := asNotes;
    2 : Result := asOnHold;
    3 : Result := asClosed;
  Else
    Raise EUnknownValue.Create ('Unknown Account Status for ' + FAccountRec.CustCode);
  End; { Case }
end;

procedure TAccount.Set_acAccStatus(Value: TAccountStatus);
begin
  Case Value Of
    0 : FAccountRec.AccStatus := asOpen;
    1 : FAccountRec.AccStatus := asNotes;
    2 : FAccountRec.AccStatus := asOnHold;
    3 : FAccountRec.AccStatus := asClosed;
  Else
    Raise EValidation.Create ('Invalid Account Status (' + IntToStr(Value) + ')');
  End; { Case }
end;

{-----------------------------------------}

function TAccount.Get_acAltCode: WideString;
begin
  Result := FAccountRec.CustCode2;
end;

procedure TAccount.Set_acAltCode(const Value: WideString);
begin
  FAccountRec.CustCode2 := Value;
end;

{-----------------------------------------}

function TAccount.Get_acBankAcc: WideString;
begin
  //PR: 09/09/2013 ABSEXCH-14598
  Result := FAccountRec.acBankAccountCode;
end;

procedure TAccount.Set_acBankAcc(const Value: WideString);
begin
  //PR: 09/09/2013 ABSEXCH-14598
  FAccountRec.acBankAccountCode := Value;
end;

{-----------------------------------------}

function TAccount.Get_acBankRef: WideString;
begin
  Result := FAccountRec.BankRef;
end;

procedure TAccount.Set_acBankRef(const Value: WideString);
begin
  FAccountRec.BankRef := Value;
end;

{-----------------------------------------}

function TAccount.Get_acBankSort: WideString;
begin
  //PR: 09/09/2013 ABSEXCH-14598
  Result := FAccountRec.acBankSortCode;
end;

procedure TAccount.Set_acBankSort(const Value: WideString);
begin
  //PR: 09/09/2013 ABSEXCH-14598
  FAccountRec.acBankSortCode := Value;
end;

{-----------------------------------------}

function TAccount.Get_acBookOrdVal: Double;
begin
  Result := FAccountRec.BOrdVal;
end;

procedure TAccount.Set_acBookOrdVal(Value: Double);
begin
  FAccountRec.BOrdVal := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCCEnd: WideString;
begin
  Result := FAccountRec.CCDEDate;
end;

procedure TAccount.Set_acCCEnd(const Value: WideString);
begin
  FAccountRec.CCDEDate := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCCName: WideString;
begin
  Result := FAccountRec.CCDName;
end;

procedure TAccount.Set_acCCName(const Value: WideString);
begin
  FAccountRec.CCDName := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCCNumber: WideString;
begin
  Result := FAccountRec.CCDCardNo;
end;

procedure TAccount.Set_acCCNumber(const Value: WideString);
begin
  FAccountRec.CCDCardNo := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCCStart: WideString;
begin
  Result := FAccountRec.CCDSDate;
end;

procedure TAccount.Set_acCCStart(const Value: WideString);
begin
  FAccountRec.CCDSDate := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCCSwitch: WideString;
begin
  Result := FAccountRec.CCDSARef;
end;

procedure TAccount.Set_acCCSwitch(const Value: WideString);
begin
  FAccountRec.CCDSARef := Value;
end;

{-----------------------------------------}

function TAccount.Get_acCOSGL: Integer;
begin
  Result := FAccountRec.DefCOSNom;
end;

procedure TAccount.Set_acCOSGL(Value: Integer);
begin
  FAccountRec.DefCOSNom := Value;
end;

{-----------------------------------------}

function TAccount.Get_acDefSettleDays: Integer;
begin
  Result := FAccountRec.DefSetDDays;
end;

procedure TAccount.Set_acDefSettleDays(Value: Integer);
begin
  FAccountRec.DefSetDDays := Value;
end;

{-----------------------------------------}

function TAccount.Get_acDefSettleDisc: Double;
begin
  Result := FAccountRec.DefSetDisc;
end;

procedure TAccount.Set_acDefSettleDisc(Value: Double);
begin
  FAccountRec.DefSetDisc := Value;
end;

{-----------------------------------------}

function TAccount.Get_acDirDebMode: Smallint;
begin
  Result := FAccountRec.DirDeb;
end;

procedure TAccount.Set_acDirDebMode(Value: Smallint);
begin
  FAccountRec.DirDeb := Value;
end;

{-----------------------------------------}

function TAccount.Get_acDocDeliveryMode: Integer;
begin
  Result := FAccountRec.InvDMode;
end;

procedure TAccount.Set_acDocDeliveryMode(Value: Integer);
begin
  FAccountRec.InvDMode := Value;
end;

{-----------------------------------------}

function TAccount.Get_acDrCrGL: Integer;
begin
  Result := FAccountRec.DefCtrlNom;
end;

procedure TAccount.Set_acDrCrGL(Value: Integer);
begin
  FAccountRec.DefCtrlNom := Value;
end;

{-----------------------------------------}

function TAccount.Get_acEBusPword: WideString;
begin
  Result := FAccountRec.EBusPwrd;
end;

procedure TAccount.Set_acEBusPword(const Value: WideString);
begin
  FAccountRec.EBusPwrd := Value;
end;

{-----------------------------------------}

function TAccount.Get_acECMember: WordBool;
begin
  Result := FAccountRec.EECMember;
end;

procedure TAccount.Set_acECMember(Value: WordBool);
begin
  FAccountRec.EECMember := Value;
end;

{-----------------------------------------}

function TAccount.Get_acEmailAddr: WideString;
begin
  Result := FAccountRec.EmailAddr;
end;

procedure TAccount.Set_acEmailAddr(const Value: WideString);
begin
  FAccountRec.EmailAddr := Value;
end;

{-----------------------------------------}

function TAccount.Get_acFormSet: Smallint;
begin
  Result := FAccountRec.DefFormNo;
end;

procedure TAccount.Set_acFormSet(Value: Smallint);
begin
  FAccountRec.DefFormNo := Value;
end;

{-----------------------------------------}

function TAccount.Get_acInvoiceTo: WideString;
begin
  Result := FAccountRec.SOPInvCode;
end;

procedure TAccount.Set_acInvoiceTo(const Value: WideString);
begin
  if (Trim(Value) = '') or (FAccountRec.SOPConsHO = 0) then
    FAccountRec.SOPInvCode := Value
  else
    raise Exception.Create('Invoice To property cannot be set for Head Office account');
end;

{-----------------------------------------}

function TAccount.Get_acLastOperator: WideString;
begin
  Result := FAccountRec.LastOpo;
end;

procedure TAccount.Set_acLastOperator(const Value: WideString);
begin
  FAccountRec.LastOpo := Value;
end;

{-----------------------------------------}

function TAccount.Get_acLastUsed: WideString;
begin
  Result := FAccountRec.LastUsed;
end;

procedure TAccount.Set_acLastUsed(const Value: WideString);
begin
  FAccountRec.LastUsed := Value;
end;

{-----------------------------------------}

function TAccount.Get_acLocation: WideString;
begin
  Result := FAccountRec.DefMLocStk;
end;

procedure TAccount.Set_acLocation(const Value: WideString);
begin
  FAccountRec.DefMLocStk := LJVar(Value,MLocKeyLen);
end;

{-----------------------------------------}

function TAccount.Get_acPayType: WideString;
begin
  Result := FAccountRec.PayType;
end;

procedure TAccount.Set_acPayType(const Value: WideString);
begin
  FAccountRec.PayType := ExtractChar(Value, ' ');
end;

{-----------------------------------------}

function TAccount.Get_acPhone2: WideString;
begin
  Result := FAccountRec.Phone2;
end;

procedure TAccount.Set_acPhone2(const Value: WideString);
begin
  FAccountRec.Phone2 := Value;
end;

{-----------------------------------------}

function TAccount.Get_acPostCode: WideString;
begin
  Result := FAccountRec.PostCode;
end;

procedure TAccount.Set_acPostCode(const Value: WideString);
begin
  FAccountRec.PostCode := Value;
end;

{-----------------------------------------}

function TAccount.Get_acSalesGL: Integer;
begin
  Result := FAccountRec.DefNomCode;
end;

procedure TAccount.Set_acSalesGL(Value: Integer);
begin
  FAccountRec.DefNomCode := Value;
end;

{-----------------------------------------}

function TAccount.Get_acSendHTML: WordBool;
begin
  Result := FAccountRec.EmlSndHtml;
end;

procedure TAccount.Set_acSendHTML(Value: WordBool);
begin
  FAccountRec.EmlSndHtml := Value;
end;

{-----------------------------------------}

function TAccount.Get_acSendReader: WordBool;
begin
  Result := FAccountRec.EmlSndRdr;
end;

procedure TAccount.Set_acSendReader(Value: WordBool);
begin
  FAccountRec.EmlSndRdr := Value;
end;

{-----------------------------------------}

function TAccount.Get_acSOPAutoWOff: WordBool;
begin
  Result := FAccountRec.SOPAutoWOff;
end;

procedure TAccount.Set_acSOPAutoWOff(Value: WordBool);
begin
  FAccountRec.SOPAutoWOff := Value;
end;

{-----------------------------------------}

function TAccount.Get_acSSDDeliveryTerms: WideString;
begin
  Result := FAccountRec.SSDDelTerms;
end;

procedure TAccount.Set_acSSDDeliveryTerms(const Value: WideString);
begin
  FAccountRec.SSDDelTerms := Value;
end;

{-----------------------------------------}

function TAccount.Get_acSSDModeOfTransport: Integer;
begin
  Result := FAccountRec.SSDModeTr;
end;

procedure TAccount.Set_acSSDModeOfTransport(Value: Integer);
begin
  FAccountRec.SSDModeTr := Value;
end;

{-----------------------------------------}

function TAccount.Get_acStateDeliveryMode: Integer;
begin
  Result := FAccountRec.StatDMode;
end;

procedure TAccount.Set_acStateDeliveryMode(Value: Integer);
begin
  FAccountRec.StatDMode := Value;
end;

{-----------------------------------------}

function TAccount.Get_acStatement: WordBool;
begin
  Result := FAccountRec.IncStat;
end;

procedure TAccount.Set_acStatement(Value: WordBool);
begin
  FAccountRec.IncStat := Value;
end;

{-----------------------------------------}

function TAccount.Get_acTimeStamp: WideString;
begin
  Result := FAccountRec.TimeChange;
end;

{-----------------------------------------}

function TAccount.Get_acUseForEbus: Integer;
begin
  Result := FAccountRec.AllowWeb;
end;

procedure TAccount.Set_acUseForEbus(Value: Integer);
begin
  FAccountRec.AllowWeb := Value;
end;

{-----------------------------------------}

function TAccount.Get_acUserDef1: WideString;
begin
  Result := FAccountRec.UserDef1;
end;

procedure TAccount.Set_acUserDef1(const Value: WideString);
begin
  FAccountRec.UserDef1 := Value;
end;

{-----------------------------------------}

function TAccount.Get_acUserDef2: WideString;
begin
  Result := FAccountRec.UserDef2;
end;

procedure TAccount.Set_acUserDef2(const Value: WideString);
begin
  FAccountRec.UserDef2 := Value;
end;

{-----------------------------------------}

function TAccount.Get_acUserDef3: WideString;
begin
  Result := FAccountRec.UserDef3;
end;

procedure TAccount.Set_acUserDef3(const Value: WideString);
begin
  FAccountRec.UserDef3 := Value;
end;

{-----------------------------------------}

function TAccount.Get_acUserDef4: WideString;
begin
  Result := FAccountRec.UserDef4;
end;

procedure TAccount.Set_acUserDef4(const Value: WideString);
begin
  FAccountRec.UserDef4 := Value;
end;

{-----------------------------------------}

function TAccount.Get_acInclusiveVATCode: WideString;
begin
  Result := FAccountRec.CVATIncFlg;
end;

procedure TAccount.Set_acInclusiveVATCode(Const Value: WideString);
begin
  FAccountRec.CVATIncFlg := ExtractChar (Value, ' ');
end;

{-----------------------------------------}

function TAccount.Get_acWebLiveCatalog: WideString;
begin
  Result := FAccountRec.WebLiveCat;
end;

procedure TAccount.Set_acWebLiveCatalog(const Value: WideString);
begin
  FAccountRec.WebLiveCat := Value;
end;

{-----------------------------------------}

function TAccount.Get_acWebPrevCatalog: WideString;
begin
  Result := FAccountRec.WebPrevCat;
end;

procedure TAccount.Set_acWebPrevCatalog(const Value: WideString);
begin
  FAccountRec.WebPrevCat := Value;
end;

{-----------------------------------------}

function TAccount.Get_acZIPAttachments: TEmailAttachmentZIPType;
begin
  If FAccountRec.EmlZipAtc Then
    If FAccountRec.EmlUseEDZ Then
      Result := emZIPEDZ
    Else
      Result := emZIPPKZIP
  Else
    Result := emZIPNone
end;

procedure TAccount.Set_acZIPAttachments(Value: TEmailAttachmentZIPType);
begin
  FAccountRec.EmlZipAtc := (Value In [emZIPPKZIP, emZIPEDZ]);
  FAccountRec.EmlUseEDZ := (Value = emZIPEDZ);
end;

{-----------------------------------------}

function TAccount.Get_acHistory: IAccountBalance;
Begin
  { Check History sub-object has been initialised }
  If (Not Assigned(FHistoryO)) Then Begin
    { Create and initialise Customer Details }
    FHistoryO := TAccountBalance.Create(@FAccountRec);

    FHistoryI := FHistoryO;
  End; { If (Not Assigned(FHistoryO)) }

  Result := FHistoryI;
End;

{-----------------------------------------}

function TAccount.BuildCodeIndex(const AccountCode: WideString): WideString;
begin
  Result := FullCustCode(AccountCode);
end;

{-----------------------------------------}

function TAccount.BuildNameIndex(const AccountName: WideString): WideString;
begin
  Result := FullCompKey(AccountName);
end;

{-----------------------------------------}

function TAccount.BuildAltCodeIndex(const AlternateCode: WideString): WideString;
begin
  Result := FullCustCode2(AlternateCode);
end;

{-----------------------------------------}

function TAccount.BuildEmailIndex(const EmailAddr: WideString): WideString;
begin
  Result := FullEmailAddr(EmailAddr);  //SSK 06/10/2016 2017-R1 ABSEXCH-14087: BtKeys1U.FullEmailAddr used for padding to 100 characters
end;

{-----------------------------------------}

function TAccount.BuildInvoiceToIndex(const AccountCode: WideString): WideString;
begin
  Result := FullCustCode(AccountCode);
end;

{-----------------------------------------}

function TAccount.BuildOurCodeIndex(const OurCode: WideString): WideString;
begin
  Result := FullRefNo(OurCode);  //SSK 06/10/2016 2017-R1 ABSEXCH-14087: BtKeys1U.FullRefNo used for padding OurCode to 10 characters
end;

{-----------------------------------------}

function TAccount.BuildPhoneIndex(const PhoneNo: WideString): WideString;
begin
  Result := FullCustPhone(PhoneNo);  //SSK 06/10/2016 2017-R1 ABSEXCH-14087: BtKeys1U.FullCustPhone used for padding PhoneNo to 30 characters
end;

{-----------------------------------------}

function TAccount.BuildPostCodeIndex(const PostCode: WideString): WideString;
begin
  Result := FullPostCode(PostCode);  //SSK 06/10/2016 2017-R1 ABSEXCH-14087: BtKeys1U.FullPostCode used for padding postcode to 20 characters
end;

{-----------------------------------------}

function TAccount.BuildVatRegIndex(const VatRegNo, AccountCode: WideString): WideString;
begin
  Result := FullCVATKey(VatRegNo) + FullCustCode(AccountCode);
end;

{-----------------------------------------}

function TAccount.Get_Index: TAccountIndex;
begin
  Result := Inherited Get_Index;
end;

procedure TAccount.Set_Index(Value: TAccountIndex);
begin
  Inherited Set_Index (Value);
end;

{-----------------------------------------}

function TAccount.Get_acNotes: INotes;
begin
  AuthoriseFunction(201, 'acNotes', 1);

  { Check Notes sub-object has been initialised }
  If (Not Assigned(FNotesO)) Then Begin
    { Create and initialise Customer Details }
    FNotesO := TNotes.Create(imGeneral,
                             FToolkit,
                             FBtrIntF,
                             'ACC',
                             '2',
                             False);

    FNotesI := FNotesO;
  End; { If (Not Assigned(FNotesO)) }

  FNotesO.SetStartKey (FullCustCode(FAccountRec.CustCode),
                       NoteTCode + NoteCCode + FullNCode(FAccountRec.CustCode));

  Result := FNotesI;
end;

{-----------------------------------------}

function TAccount.Get_acDiscounts: IAccountDiscount;
begin
  AuthoriseFunction(202, 'acDiscounts', 1);

  { Check Account Discounts sub-object has been initialised }
  If (Not Assigned(FDiscountO)) Then Begin
    { Create and initialise Customer Details }
    FDiscountO := TAccountDiscount.Create(imGeneral,
                                          FToolkit,
                                          FBtrIntF,
                                          FAccType);

    FDiscountI := FDiscountO;
  End; { If (Not Assigned(FDiscountO)) }

  FDiscountO.SetStartKey (FAccountRec.CustCode);

  Result := FDiscountI;
end;

{-----------------------------------------}

function TAccount.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TAccount.Get_acDefTagNo: Integer;
begin
  Result := FAccountRec.DefTagNo;
end;

procedure TAccount.Set_acDefTagNo(Value: Integer);
begin
  //PR: 03/02/2009 20090202114522 Changed to allow DefTagNo of 0.
  if (Value >= 0) and (Value <= 99) then
//  if (Value >= 1) and (Value <= 99) then
    FAccountRec.DefTagNo := Value
  else
    raise ERangeError.Create('Tag No Value out of range (' + IntToStr(Value) + ')');
end;

function TAccount.Get_acOfficeType: TAccountOfficeType;
begin
  Result := FAccountRec.SOPConsHO;
end;

procedure TAccount.Set_acOfficeType(Value: TAccountOfficeType);
begin
  if (Value <= aotHeadOffice) then
  begin
    if (Trim(FAccountRec.SOPInvCode) = '') or (Value = aotOffice) then
      FAccountRec.SOPConsHO := Value
    else
      raise Exception.Create('Cannot change account to Head Office while Invoice To property is set');
  end
  else
    raise EValidation.Create ('Invalid Office Type (' + IntToStr(Value) + ')');
end;

function TAccount.Get_acOrderConsolidationMode: TOrderConsolidationModeType;
begin
  Result := TOrderConsolidationModeType(FAccountRec.OrderConsMode);
end;

procedure TAccount.Set_acOrderConsolidationMode(Value: TOrderConsolidationModeType);
begin
  if (Value <= ocmInvoicesNeverDeliveries) then
    FAccountRec.OrderConsMode := Ord(Value)
  else
    raise EValidation.Create ('Invalid Order Consolidation Mode (' + IntToStr(Value) + ')');
end;

function TAccount.Get_acVATCountryCode: WideString;
begin
  //For future use
end;

procedure TAccount.Set_acVATCountryCode(const Value: WideString);
begin
  //For future use
end;

function TAccount.Get_acLinks: ILinks; safecall;
begin
  AuthoriseFunction(203, 'acLinks', 1);

  if Not Assigned(FLinksO) then
  begin
    FLinksO := TLinks.Create(imGeneral, FBtrIntf, FAccountRec.CustSupp, FAccountRec.CustCode, 0);

    FLinksI := FLinksO;
  end;

  FLinksO.OwnerType := FAccountRec.CustSupp;
  FLinksO.OwnerCode := FAccountRec.CustCode;
  FLinksO.OwnerFolio := 0;
  Result := FLinksI;
end;

function TAccount.Get_acSalesAnalysis: ICustomerSalesAnalysis;
begin
  AuthoriseFunction(204, 'acSalesAnalysis', 1);

  if not Assigned(FSalesAnalysisO) then
  begin
    FSalesAnalysisO := TCustomerSalesAnalysis.Create(imGeneral, FToolkit, FBtrIntf, saCustomer, FAccountRec.CustCode);

    FSalesAnalysisI := FSalesAnalysisO;
  end;
  FSalesAnalysisO.Code := FAccountRec.CustCode;
  Result := FSalesAnalysisI;
end;

//-------------------------------------------------------------------------

function TAccount.Print(PrintAs: TAccountPrintMode): IPrintJob;
Var
  oPrintJob  : TPrintJob;
Begin // Print
  // Only allow printing for general object and clone objects
  If (FIntfType In [imGeneral, imClone]) Then
  Begin
    Case PrintAs Of
      acpmAccountWithNotes : Begin
                               // Create and initialise the PrintJob object
                               oPrintJob := TPrintJob.Create(FToolkit, fmAccountDetails, defTypeAccountWithNotes, jtForm);
                               With oPrintJob Do
                               Begin
                                 // Configure to print the transaction
                                 MainFileNum  := CustF;
                                 MainKeyPath  := CustCodeK;
                                 MainKeyRef   := FullCustCode (FAccountRec.CustCode);

                                 TableFileNum := PWrdF;
                                 TableKeyPath := PWK;
                                 TableKeyRef  := NoteTCode + NoteCCode + FullNCode(FAccountRec.CustCode);

                                 DefaultAcc   := FAccountRec.CustCode;
                               End; // With oPrintJob
                             End; // acpmAccountWithNotes
      acpmStatement        : Begin
                               // Create and initialise the PrintJob object
                               oPrintJob := TPrintJob.Create(FToolkit, fmStatement, defTypeAccountStatement, jtForm);
                               With oPrintJob Do
                               Begin
                                 // Configure to print the transaction
                                 MainFileNum  := CustF;
                                 MainKeyPath  := CustCodeK;
                                 MainKeyRef   := FullCustCode (FAccountRec.CustCode);

                                 TableFileNum := InvF;
                                 TableKeyPath := InvCustK;
                                 TableKeyRef  := MainKeyRef + FAccountRec.CustSupp;

                                 DefaultAcc   := FAccountRec.CustCode;
                               End; // With oPrintJob
                             End; // acpmStatement
      acpmTradingLedger    : Begin
                               // Create and initialise the PrintJob object
                               oPrintJob := TPrintJob.Create(FToolkit, fmTradeHistory, defTypeAccountTradingLedger, jtForm);
                               With oPrintJob Do
                               Begin
                                 // Configure to print the transaction
                                 MainFileNum  := CustF;
                                 MainKeyPath  := CustCodeK;
                                 MainKeyRef   := FullCustCode (FAccountRec.CustCode);

                                 TableFileNum := InvF;
                                 TableKeyPath := InvCustK;
                                 TableKeyRef  := MainKeyRef + FAccountRec.CustSupp;

                                 DefaultAcc   := FAccountRec.CustCode;
                               End; // With oPrintJob
                             End; // acpmTradingLedger
      acpmAccountLabel     : Begin
                               // Create and initialise the PrintJob object
                               oPrintJob := TPrintJob.Create(FToolkit, fmLabel, defTypeAccountLabel, jtLabel);
                               With oPrintJob Do
                               Begin
                                 // Configure to print the transaction
                                 MainFileNum  := CustF;
                                 MainKeyPath  := CustCodeK;
                                 MainKeyRef   := FullCustCode (FAccountRec.CustCode);

                                 TableFileNum := MainFileNum;
                                 TableKeyPath := MainKeyPath;
                                 TableKeyRef  := MainKeyRef;

                                 DefaultAcc   := FAccountRec.CustCode;
                               End; // With oPrintJob
                             End; // acpmAccountLabel
      acpmCustomTradingList: Begin
                               // Create and initialise the PrintJob object
                               oPrintJob := TPrintJob.Create(FToolkit, fmCustomTradeHistory, defTypeAccountTradingLedger, jtForm);
                               With oPrintJob Do
                               Begin
                                 // Configure to print the transaction
                                 MainFileNum  := CustF;
                                 MainKeyPath  := CustCodeK;
                                 MainKeyRef   := FullCustCode (FAccountRec.CustCode);

                                 TableFileNum := ReportF;
                                 TableKeyPath := RpK;
                                 TableKeyRef  := FullNomKey(2001);

                                 DefaultAcc   := FAccountRec.CustCode;
                               End; // With oPrintJob
                             End; // acpmCustomTradingList
    Else
      Raise Exception.Create ('TAccount.Print: Unknown PrintAs Mode (' + IntToStr(Ord(PrintAs)) + ')');
    End; // Case PrintAs

    // Return reference to interface - object will be automatically destroyed when
    // user reference to it is lost
    Result := oPrintJob;
  End // If (FIntfType In [imGeneral, imClone])
  Else
  Begin
    Raise EInvalidMethod.Create ('The Print method is not available in this object')
  End; // Else
End; // Print

//-------------------------------------------------------------------------

function TAccount.Get_acMultiBuy: IMultiBuy;
begin
  AuthoriseFunction(205, 'acMultiBuy', 1);

  If (Not Assigned(FMultiBuyO)) Then Begin
    FMultiBuyO := TMultiBuy.Create(imGeneral, FToolkit, FAccType, FBtrIntf);

    FMultiBuyI := FMultiBuyO;
  End; { If (Not Assigned(FMultiBuyO)) }

  FMultiBuyO.SetStartKey(FAccountRec.CustCode);

  Result := FMultiBuyI;
end;

function TAccount.Get_acUserDef10: WideString;
begin
  Result := FAccountRec.UserDef10;
end;

function TAccount.Get_acUserDef5: WideString;
begin
  Result := FAccountRec.UserDef5;
end;

function TAccount.Get_acUserDef6: WideString;
begin
  Result := FAccountRec.UserDef6;
end;

function TAccount.Get_acUserDef7: WideString;
begin
  Result := FAccountRec.UserDef7;
end;

function TAccount.Get_acUserDef8: WideString;
begin
  Result := FAccountRec.UserDef8;
end;

function TAccount.Get_acUserDef9: WideString;
begin
  Result := FAccountRec.UserDef9;
end;

procedure TAccount.Set_acUserDef10(const Value: WideString);
begin
  FAccountRec.UserDef10 := Value;
end;

procedure TAccount.Set_acUserDef5(const Value: WideString);
begin
  FAccountRec.UserDef5 := Value;
end;

procedure TAccount.Set_acUserDef6(const Value: WideString);
begin
  FAccountRec.UserDef6 := Value;
end;

procedure TAccount.Set_acUserDef7(const Value: WideString);
begin
  FAccountRec.UserDef7 := Value;
end;

procedure TAccount.Set_acUserDef8(const Value: WideString);
begin
  FAccountRec.UserDef8 := Value;
end;

procedure TAccount.Set_acUserDef9(const Value: WideString);
begin
  FAccountRec.UserDef9 := Value;
end;

function TAccount.Get_acMandateID: WideString;
begin
  Result := FAccountRec.acMandateID;
end;

procedure TAccount.Set_acMandateDate(const Value: WideString);
begin
  AuthoriseFunction(206, 'acMandateDate', 1);
  FAccountRec.acMandateDate := Value;
end;

function TAccount.Get_acLongACCode: WideString;
begin
  Result := FAccountRec.acLongACCode;
end;

procedure TAccount.Set_acLongACCode(const Value: WideString);
begin
  FAccountRec.acLongACCode := Value;
end;

function TAccount.Get_acSubType: TAccountSubType;
begin
  Result := TraderTypeFromSubType(FAccountRec.acSubType);
end;

procedure TAccount.Set_acSubType(Value: TAccountSubType);
begin
  FAccountRec.acSubType := SubTypeFromTraderType(Value);
end;

function TAccount.Get_acDeliveryPostCode: WideString;
begin
  Result := FAccountRec.acDeliveryPostCode
end;

procedure TAccount.Set_acDeliveryPostCode(const Value: WideString);
begin
  FAccountRec.acDeliveryPostCode := Value;
end;


function TAccount.Get_acMandateDate: WideString;
begin
  Result := FAccountRec.acMandateDate;
end;

procedure TAccount.Set_acMandateID(const Value: WideString);
begin
  AuthoriseFunction(206, 'acMandateID', 1);
  FAccountRec.acMandateID := Value;
end;

//PR: 28/11/2013 ABSEXCH-14797 New Indexes for consumer changes
function TAccount.BuildSubTypeAndAltCodeIndex(SubType: TAccountSubType;
  const AltCode: WideString): WideString;
begin
  Result := FullSubTypeAltCodeKey(SubTypeFromTraderType(SubType), AltCode);
end;

function TAccount.BuildSubTypeAndCodeIndex(SubType: TAccountSubType;
  const Code: WideString): WideString;
begin
  Result := FullSubTypeAcCodeKey(SubTypeFromTraderType(SubType), Code);
end;

function TAccount.BuildSubTypeAndLongCodeIndex(SubType: TAccountSubType;
  const LongCode: WideString): WideString;
begin
  Result := FullSubTypeLongAcCodeKey(SubTypeFromTraderType(SubType), LongCode);
end;

function TAccount.BuildSubTypeAndNameIndex(SubType: TAccountSubType;
  const CoName: WideString): WideString;
begin
  Result := FullSubTypeNameKey(SubTypeFromTraderType(SubType), CoName);
end;

function TAccount.Get_acContacts: IAccountContactsList;
begin
  if not Assigned(ContactsListO) then
  begin
    ContactsListO := TAccountContactsList.Create;

    ContactsListI := ContactsListO;
  end;

  ContactsListO.AccountCode := Get_acCode;
  Result := ContactsListI;
end;

function TAccount.Get_acAllowOrderPayments: WordBool;
begin
  Result := FAccountRec.acAllowOrderPayments;
end;

function TAccount.Get_acPPDMode: TAccountPPDMode;
begin
  Case FAccountRec.acPPDMode of
    0 : Result := pmPPDDisabled;
    1 : Result := pmPPDEnabledWithAutoJournalCreditNote;
    2 : Result := pmPPDEnabledWithAutoCreditNote;
    3 : Result := pmPPDEnabledWithManualCreditNote;
  end;
end;

function TAccount.Get_acOrderPaymentsGLCode: Integer;
begin
  Result := FAccountRec.acOrderPaymentsGLCode;
end;

procedure TAccount.Set_acAllowOrderPayments(Value: WordBool);
begin
  FAccountRec.acAllowOrderPayments := Value;
end;

procedure TAccount.Set_acOrderPaymentsGLCode(Value: Integer);
begin
  FAccountRec.acOrderPaymentsGLCode := Value;
end;

//PR: 16/01/2015 ABSEXCH-16044 Default from system
function TAccount.CountryCodeFromEALCountryNumber: string;
var
  CountryNo : Integer;
begin
  Try
    CountryNo := StrToInt(Trim(Syss.USRCntryCode));
  Except
    CountryNo := 0;
  End;

  Case CountryNo of
    27 : Result := 'ZA';
    44 : Result := 'GB';
    61 : Result := 'AU';
    64 : Result := 'NZ';
    65 : Result := 'SG';
   353 : Result := 'IE';
   else
     Result := 'GB';
  end;
end;

procedure TAccount.Set_acPPDMode(Value: TAccountPPDMode);
begin
  Case Value of
    pmPPDDisabled                         : FAccountRec.acPPDMode := 0;
    pmPPDEnabledWithAutoJournalCreditNote : FAccountRec.acPPDMode := 1;
    pmPPDEnabledWithAutoCreditNote        : FAccountRec.acPPDMode := 2;
    pmPPDEnabledWithManualCreditNote      : FAccountRec.acPPDMode := 3;
  end;
end;

//PR: 22/01/2016 ABSEXCH-17112 v2016 R1 IAccount11 Default to QR field for Intrastat
function TAccount.Get_acDefaultToQR: WordBool;
begin
  Result := FAccountRec.acDefaultToQR;
end;

procedure TAccount.Set_acDefaultToQR(Value: WordBool);
begin
  FAccountRec.acDefaultToQR := Value;
end;

//AP: 15/11/2017 ABSEXCH-19389 v2018 R1 IAccount12 : New fileds introduced for GDPR
function TAccount.Get_acAnonymisationStatus: TEntityAnonymisationStatusType;
begin
  Result := Ord(FAccountRec.acAnonymisationStatus);
end;

function TAccount.Get_acAnonymisedDate: WideString;
begin
  Result := FAccountRec.acAnonymisedDate;
end;

function TAccount.Get_acAnonymisedTime: WideString;
begin
  Result := FAccountRec.acAnonymisedTime;
end;

end.

