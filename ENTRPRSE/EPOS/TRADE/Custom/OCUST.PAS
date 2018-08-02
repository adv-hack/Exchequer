// Implementation of the "thCustomer" COM Object
unit oCust;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, EPOSProc
  , VarConst, CustomP, oAddr, DLLInc;


type

  TCustFunctionIndex = (fIdxUnknownfunction);
  TCustPropertyIndex = (pIdxNeverAuthorise, pIdxacAccStatus, pIdxacAccType
  , pIdxacAltCode, pIdxacArea, pIdxacBankAcc, pIdxacBankRef, pIdxacBankSort
  , pIdxacBookOrdVal, pIdxacCCEnd, pIdxacCCName, pIdxacCCNumber, pIdxacCCStart
  , pIdxacCCSwitch, pIdxacCode, pIdxacCompany, pIdxacContact, pIdxacCOSGL
  , pIdxacCostCentre, pIdxacCreditLimit, pIdxacCreditStatus, pIdxacCurrency
  , pIdxacDefSettleDays, pIdxacDefSettleDisc, pIdxacDepartment, pIdxacDirDebMode
  , pIdxacDiscount, pIdxacDiscountBand, pIdxacDocDeliveryMode, pIdxacDrCrGL
  , pIdxacEBusPword, pIdxacECMember, pIdxacEmailAddr, pIdxacFax, pIdxacFormSet
  , pIdxacInclusiveVATCode, pIdxacInvoiceTo, pIdxacLastOperator, pIdxacLocation
  , pIdxacOwnTradTerm, pIdxacPayTerms, pIdxacPayType, pIdxacPhone, pIdxacPostCode
  , pIdxacSalesGL, pIdxacSendHTML, pIdxacSendReader, pIdxacSOPAutoWOff
  , pIdxacSSDDeliveryTerms, pIdxacSSDModeOfTransport, pIdxacStateDeliveryMode
  , pIdxacStatement, pIdxacStatementTo, pIdxacTheirAcc, pIdxacTradeTerms
  , pIdxacUseForEbus, pIdxacUserDef1, pIdxacUserDef2, pIdxacUserDef3, pIdxacUserDef4
  , pIdxacVATCode, pIdxacVATRegNo, pIdxacWebLiveCatalog, pIdxacWebPrevCatalog
  , pIdxacZIPAttachments);

  TTradeEventCustomer = class(TAutoIntfObject, ITradeEventCustomer)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    FCustAddrO : TTradeAddress;
    FCustAddrI : ITradeAddress;

    FDelAddrO : TTradeAddress;
    FDelAddrI : ITradeAddress;

    oEventData : TObject;

  protected
    function Get_acCode: WideString; safecall;
    procedure Set_acCode(const Value: WideString); safecall;
    function Get_acCompany: WideString; safecall;
    procedure Set_acCompany(const Value: WideString); safecall;
    function Get_acArea: WideString; safecall;
    procedure Set_acArea(const Value: WideString); safecall;
    function Get_acAccType: WideString; safecall;
    procedure Set_acAccType(const Value: WideString); safecall;
    function Get_acStatementTo: WideString; safecall;
    procedure Set_acStatementTo(const Value: WideString); safecall;
    function Get_acVATRegNo: WideString; safecall;
    procedure Set_acVATRegNo(const Value: WideString); safecall;
    function Get_acAddress: ITradeAddress; safecall;
    function Get_acDelAddress: ITradeAddress; safecall;
    function Get_acContact: WideString; safecall;
    procedure Set_acContact(const Value: WideString); safecall;
    function Get_acPhone: WideString; safecall;
    procedure Set_acPhone(const Value: WideString); safecall;
    function Get_acFax: WideString; safecall;
    procedure Set_acFax(const Value: WideString); safecall;
    function Get_acTheirAcc: WideString; safecall;
    procedure Set_acTheirAcc(const Value: WideString); safecall;
    function Get_acOwnTradTerm: WordBool; safecall;
    procedure Set_acOwnTradTerm(Value: WordBool); safecall;
    function Get_acTradeTerms(Index: Integer): WideString; safecall;
    procedure Set_acTradeTerms(Index: Integer; const Value: WideString); safecall;
    function Get_acCurrency: Smallint; safecall;
    procedure Set_acCurrency(Value: Smallint); safecall;
    function Get_acVATCode: WideString; safecall;
    procedure Set_acVATCode(const Value: WideString); safecall;
    function Get_acPayTerms: Smallint; safecall;
    procedure Set_acPayTerms(Value: Smallint); safecall;
    function Get_acCreditLimit: Double; safecall;
    procedure Set_acCreditLimit(Value: Double); safecall;
    function Get_acDiscount: Double; safecall;
    procedure Set_acDiscount(Value: Double); safecall;
    function Get_acCreditStatus: Smallint; safecall;
    procedure Set_acCreditStatus(Value: Smallint); safecall;
    function Get_acCostCentre: WideString; safecall;
    procedure Set_acCostCentre(const Value: WideString); safecall;
    function Get_acDiscountBand: WideString; safecall;
    procedure Set_acDiscountBand(const Value: WideString); safecall;
    function Get_acDepartment: WideString; safecall;
    procedure Set_acDepartment(const Value: WideString); safecall;
    function Get_acECMember: WordBool; safecall;
    procedure Set_acECMember(Value: WordBool); safecall;
    function Get_acStatement: WordBool; safecall;
    procedure Set_acStatement(Value: WordBool); safecall;
    function Get_acSalesGL: Integer; safecall;
    procedure Set_acSalesGL(Value: Integer); safecall;
    function Get_acLocation: WideString; safecall;
    procedure Set_acLocation(const Value: WideString); safecall;
    function Get_acAccStatus: TTradeAccountStatus; safecall;
    procedure Set_acAccStatus(Value: TTradeAccountStatus); safecall;
    function Get_acPayType: WideString; safecall;
    procedure Set_acPayType(const Value: WideString); safecall;
    function Get_acBankSort: WideString; safecall;
    procedure Set_acBankSort(const Value: WideString); safecall;
    function Get_acBankAcc: WideString; safecall;
    procedure Set_acBankAcc(const Value: WideString); safecall;
    function Get_acBankRef: WideString; safecall;
    procedure Set_acBankRef(const Value: WideString); safecall;
    function Get_acLastUsed: WideString; safecall;
    function Get_acPhone2: WideString; safecall;
    procedure Set_acPhone2(const Value: WideString); safecall;
    function Get_acUserDef1: WideString; safecall;
    procedure Set_acUserDef1(const Value: WideString); safecall;
    function Get_acUserDef2: WideString; safecall;
    procedure Set_acUserDef2(const Value: WideString); safecall;
    function Get_acInvoiceTo: WideString; safecall;
    procedure Set_acInvoiceTo(const Value: WideString); safecall;
    function Get_acSOPAutoWOff: WordBool; safecall;
    procedure Set_acSOPAutoWOff(Value: WordBool); safecall;
    function Get_acBookOrdVal: Double; safecall;
    procedure Set_acBookOrdVal(Value: Double); safecall;
    function Get_acCOSGL: Integer; safecall;
    procedure Set_acCOSGL(Value: Integer); safecall;
    function Get_acDrCrGL: Integer; safecall;
    procedure Set_acDrCrGL(Value: Integer); safecall;
    function Get_acDirDebMode: Smallint; safecall;
    procedure Set_acDirDebMode(Value: Smallint); safecall;
    function Get_acCCStart: WideString; safecall;
    procedure Set_acCCStart(const Value: WideString); safecall;
    function Get_acCCEnd: WideString; safecall;
    procedure Set_acCCEnd(const Value: WideString); safecall;
    function Get_acCCName: WideString; safecall;
    procedure Set_acCCName(const Value: WideString); safecall;
    function Get_acCCNumber: WideString; safecall;
    procedure Set_acCCNumber(const Value: WideString); safecall;
    function Get_acCCSwitch: WideString; safecall;
    procedure Set_acCCSwitch(const Value: WideString); safecall;
    function Get_acDefSettleDays: Integer; safecall;
    procedure Set_acDefSettleDays(Value: Integer); safecall;
    function Get_acDefSettleDisc: Double; safecall;
    procedure Set_acDefSettleDisc(Value: Double); safecall;
    function Get_acFormSet: Smallint; safecall;
    procedure Set_acFormSet(Value: Smallint); safecall;
    function Get_acStateDeliveryMode: Integer; safecall;
    procedure Set_acStateDeliveryMode(Value: Integer); safecall;
    function Get_acEmailAddr: WideString; safecall;
    procedure Set_acEmailAddr(const Value: WideString); safecall;
    function Get_acSendReader: WordBool; safecall;
    procedure Set_acSendReader(Value: WordBool); safecall;
    function Get_acEBusPword: WideString; safecall;
    procedure Set_acEBusPword(const Value: WideString); safecall;
    function Get_acAltCode: WideString; safecall;
    procedure Set_acAltCode(const Value: WideString); safecall;
    function Get_acPostCode: WideString; safecall;
    procedure Set_acPostCode(const Value: WideString); safecall;
    function Get_acUseForEbus: Integer; safecall;
    procedure Set_acUseForEbus(Value: Integer); safecall;
    function Get_acZIPAttachments: TTradeEmailAttachmentZIPType; safecall;
    procedure Set_acZIPAttachments(Value: TTradeEmailAttachmentZIPType); safecall;
    function Get_acUserDef3: WideString; safecall;
    procedure Set_acUserDef3(const Value: WideString); safecall;
    function Get_acUserDef4: WideString; safecall;
    procedure Set_acUserDef4(const Value: WideString); safecall;
    function Get_acTimeStamp: WideString; safecall;
    function Get_acSSDDeliveryTerms: WideString; safecall;
    procedure Set_acSSDDeliveryTerms(const Value: WideString); safecall;
    function Get_acInclusiveVATCode: WideString; safecall;
    procedure Set_acInclusiveVATCode(const Value: WideString); safecall;
    function Get_acSSDModeOfTransport: Integer; safecall;
    procedure Set_acSSDModeOfTransport(Value: Integer); safecall;
    function Get_acLastOperator: WideString; safecall;
    procedure Set_acLastOperator(const Value: WideString); safecall;
    function Get_acDocDeliveryMode: Integer; safecall;
    procedure Set_acDocDeliveryMode(Value: Integer); safecall;
    function Get_acSendHTML: WordBool; safecall;
    procedure Set_acSendHTML(Value: WordBool); safecall;
    function Get_acWebLiveCatalog: WideString; safecall;
    procedure Set_acWebLiveCatalog(const Value: WideString); safecall;
    function Get_acWebPrevCatalog: WideString; safecall;
    procedure Set_acWebPrevCatalog(const Value: WideString); safecall;
    property acCode: WideString read Get_acCode write Set_acCode;
    property acCompany: WideString read Get_acCompany write Set_acCompany;
    property acArea: WideString read Get_acArea write Set_acArea;
    property acAccType: WideString read Get_acAccType write Set_acAccType;
    property acStatementTo: WideString read Get_acStatementTo write Set_acStatementTo;
    property acVATRegNo: WideString read Get_acVATRegNo write Set_acVATRegNo;
    property acAddress: ITradeAddress read Get_acAddress;
    property acDelAddress: ITradeAddress read Get_acDelAddress;
    property acContact: WideString read Get_acContact write Set_acContact;
    property acPhone: WideString read Get_acPhone write Set_acPhone;
    property acFax: WideString read Get_acFax write Set_acFax;
    property acTheirAcc: WideString read Get_acTheirAcc write Set_acTheirAcc;
    property acOwnTradTerm: WordBool read Get_acOwnTradTerm write Set_acOwnTradTerm;
    property acTradeTerms[Index: Integer]: WideString read Get_acTradeTerms write Set_acTradeTerms;
    property acCurrency: Smallint read Get_acCurrency write Set_acCurrency;
    property acVATCode: WideString read Get_acVATCode write Set_acVATCode;
    property acPayTerms: Smallint read Get_acPayTerms write Set_acPayTerms;
    property acCreditLimit: Double read Get_acCreditLimit write Set_acCreditLimit;
    property acDiscount: Double read Get_acDiscount write Set_acDiscount;
    property acCreditStatus: Smallint read Get_acCreditStatus write Set_acCreditStatus;
    property acCostCentre: WideString read Get_acCostCentre write Set_acCostCentre;
    property acDiscountBand: WideString read Get_acDiscountBand write Set_acDiscountBand;
    property acDepartment: WideString read Get_acDepartment write Set_acDepartment;
    property acECMember: WordBool read Get_acECMember write Set_acECMember;
    property acStatement: WordBool read Get_acStatement write Set_acStatement;
    property acSalesGL: Integer read Get_acSalesGL write Set_acSalesGL;
    property acLocation: WideString read Get_acLocation write Set_acLocation;
    property acAccStatus: TTradeAccountStatus read Get_acAccStatus write Set_acAccStatus;
    property acPayType: WideString read Get_acPayType write Set_acPayType;
    property acBankSort: WideString read Get_acBankSort write Set_acBankSort;
    property acBankAcc: WideString read Get_acBankAcc write Set_acBankAcc;
    property acBankRef: WideString read Get_acBankRef write Set_acBankRef;
    property acLastUsed: WideString read Get_acLastUsed;
    property acPhone2: WideString read Get_acPhone2 write Set_acPhone2;
    property acUserDef1: WideString read Get_acUserDef1 write Set_acUserDef1;
    property acUserDef2: WideString read Get_acUserDef2 write Set_acUserDef2;
    property acInvoiceTo: WideString read Get_acInvoiceTo write Set_acInvoiceTo;
    property acSOPAutoWOff: WordBool read Get_acSOPAutoWOff write Set_acSOPAutoWOff;
    property acBookOrdVal: Double read Get_acBookOrdVal write Set_acBookOrdVal;
    property acCOSGL: Integer read Get_acCOSGL write Set_acCOSGL;
    property acDrCrGL: Integer read Get_acDrCrGL write Set_acDrCrGL;
    property acDirDebMode: Smallint read Get_acDirDebMode write Set_acDirDebMode;
    property acCCStart: WideString read Get_acCCStart write Set_acCCStart;
    property acCCEnd: WideString read Get_acCCEnd write Set_acCCEnd;
    property acCCName: WideString read Get_acCCName write Set_acCCName;
    property acCCNumber: WideString read Get_acCCNumber write Set_acCCNumber;
    property acCCSwitch: WideString read Get_acCCSwitch write Set_acCCSwitch;
    property acDefSettleDays: Integer read Get_acDefSettleDays write Set_acDefSettleDays;
    property acDefSettleDisc: Double read Get_acDefSettleDisc write Set_acDefSettleDisc;
    property acFormSet: Smallint read Get_acFormSet write Set_acFormSet;
    property acStateDeliveryMode: Integer read Get_acStateDeliveryMode write Set_acStateDeliveryMode;
    property acEmailAddr: WideString read Get_acEmailAddr write Set_acEmailAddr;
    property acSendReader: WordBool read Get_acSendReader write Set_acSendReader;
    property acEBusPword: WideString read Get_acEBusPword write Set_acEBusPword;
    property acAltCode: WideString read Get_acAltCode write Set_acAltCode;
    property acPostCode: WideString read Get_acPostCode write Set_acPostCode;
    property acUseForEbus: Integer read Get_acUseForEbus write Set_acUseForEbus;
    property acZIPAttachments: TTradeEmailAttachmentZIPType read Get_acZIPAttachments write Set_acZIPAttachments;
    property acUserDef3: WideString read Get_acUserDef3 write Set_acUserDef3;
    property acUserDef4: WideString read Get_acUserDef4 write Set_acUserDef4;
    property acTimeStamp: WideString read Get_acTimeStamp;
    property acSSDDeliveryTerms: WideString read Get_acSSDDeliveryTerms write Set_acSSDDeliveryTerms;
    property acInclusiveVATCode: WideString read Get_acInclusiveVATCode write Set_acInclusiveVATCode;
    property acSSDModeOfTransport: Integer read Get_acSSDModeOfTransport write Set_acSSDModeOfTransport;
    property acLastOperator: WideString read Get_acLastOperator write Set_acLastOperator;
    property acDocDeliveryMode: Integer read Get_acDocDeliveryMode write Set_acDocDeliveryMode;
    property acSendHTML: WordBool read Get_acSendHTML write Set_acSendHTML;
    property acWebLiveCatalog: WideString read Get_acWebLiveCatalog write Set_acWebLiveCatalog;
    property acWebPrevCatalog: WideString read Get_acWebPrevCatalog write Set_acWebPrevCatalog;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TCustPropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TCustFunctionIndex; const FuncName : ShortString);
    Function GetDataChanged : Boolean;
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(const EventData : TObject);

  End; { TTradeEventCustomer }

implementation
uses
  oEvent, ComServ,

  //PR: 11/09/2013 ABSEXCH-14598
  EncryptionUtils;

//---------------------------------------------------------------------------

Constructor TTradeEventCustomer.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FCustAddrO := TTradeAddress.Create;
  FCustAddrI := FCustAddrO;

  FDelAddrO := TTradeAddress.Create;
  FDelAddrI := FDelAddrO;

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventCustomer.Destroy;
Begin { Destroy }

  FCustAddrO := nil;
  FCustAddrI := nil;

  FDelAddrO := nil;
  FDelAddrI := nil;

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventCustomer.Assign(const EventData : TObject);

begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;

  oEventData := EventData;

  // Assign sub-objects
  FCustAddrO.Assign (oEventData, waCustomer);
  FDelAddrO.Assign (oEventData, waCustomerDelivery);

end; { Assign }

//---------------------------------------------------------------------------

Procedure TTradeEventCustomer.AuthoriseProperty (Const PropertyIdx : TCustPropertyIndex; const PropName : ShortString);
Var
  Authorised : Boolean;
Begin

  with TTradeEventData(oEventData) do begin
    Authorised := FALSE;
    // Check for specific enablement of fields

{    Case PropertyIdx Of
      pIdxacAccStatus, pIdxacAccType
      , pIdxacAltCode, pIdxacArea, pIdxacBankAcc, pIdxacBankRef, pIdxacBankSort
      , pIdxacBookOrdVal, pIdxacCCEnd, pIdxacCCName, pIdxacCCNumber, pIdxacCCStart
      , pIdxacCCSwitch, pIdxacCode, pIdxacCompany, pIdxacContact, pIdxacCOSGL
      , pIdxacCostCentre, pIdxacCreditLimit, pIdxacCreditStatus, pIdxacCurrency
      , pIdxacDefSettleDays, pIdxacDefSettleDisc, pIdxacDepartment, pIdxacDirDebMode
      , pIdxacDiscount, pIdxacDiscountBand, pIdxacDocDeliveryMode, pIdxacDrCrGL
      , pIdxacEBusPword, pIdxacECMember, pIdxacEmailAddr, pIdxacFax, pIdxacFormSet
      , pIdxacInclusiveVATCode, pIdxacInvoiceTo, pIdxacLastOperator, pIdxacLocation
      , pIdxacOwnTradTerm, pIdxacPayTerms, pIdxacPayType, pIdxacPhone, pIdxacPostCode
      , pIdxacSalesGL, pIdxacSendHTML, pIdxacSendReader, acSOPAutoWOff, pIdxacSOPAutoWOff
      , pIdxacSSDDeliveryTerms, pIdxacSSDModeOfTransport, pIdxacStateDeliveryMode
      , pIdxacStatement, pIdxacStatementTo, pIdxacTheirAcc, pIdxacTradeTerms
      , pIdxacUseForEbus, pIdxacUserDef1, pIdxacUserDef2, pIdxacUserDef3, pIdxacUserDef4
      , pIdxacVATCode, pIdxacVATRegNo, pIdxacWebLiveCatalog, pIdxacWebPrevCatalog
      , pIdxacZIPAttachments : begin
        Authorised := ((FWindowId = twiTransaction) and (FHandlerId = 101)); // Custom Button 1
      end;
    End; { Case }



    if (not Authorised) then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeEventCustomer for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}

End;{AuthoriseProperty}

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventCustomer.AuthoriseFunction (Const FunctionIdx : TCustFunctionIndex; const FuncName : ShortString);
begin

  //
  // This section needs to be coded once some functions are added in
  //
  Raise Exception.Create ('TTradeEventCustomer.AuthoriseFunction Not Implemented - Please notify your technical support');

  { TODO -cDO : TTradeEventCustomer.AuthoriseFunction Not Implemented }

end;

// Returns TRUE if any properties within the eventdata have been changed
Function TTradeEventCustomer.GetDataChanged : Boolean;
Begin { GetDataChanged }
  Result := FDataChanged or FCustAddrO.DataChanged or FDelAddrO.DataChanged;
End; { GetDataChanged }


function TTradeEventCustomer.Get_acAccStatus: TTradeAccountStatus;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.AccStatus;
end;

procedure TTradeEventCustomer.Set_acAccStatus(Value: TTradeAccountStatus);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacAccStatus, 'acAccStatus');
  TTradeEventData(oEventData).LTXRec.LCust.AccStatus := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.AccStatus, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acAccType: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.RepCode;
end;

procedure TTradeEventCustomer.Set_acAccType(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacAccType, 'acAccType');
  TTradeEventData(oEventData).LTXRec.LCust.RepCode := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.RepCode, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acAddress: ITradeAddress;
begin
  Result := FCustAddrI;
end;


function TTradeEventCustomer.Get_acAltCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CustCode2;
end;

procedure TTradeEventCustomer.Set_acAltCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacAltCode, 'acAltCode');
  TTradeEventData(oEventData).LTXRec.LCust.CustCode2 := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CustCode2, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acArea: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.AreaCode;
end;

procedure TTradeEventCustomer.Set_acArea(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacArea, 'acArea');
  TTradeEventData(oEventData).LTXRec.LCust.AreaCode := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.AreaCode, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acBankAcc: WideString;
begin
  //PR: 11/09/2013 ABSEXCH-14598 Changed to use new field
  Result := DecryptBankAccountCode(TTradeEventData(oEventData).LTXRec.LCust.acBankAccountCode);
end;

procedure TTradeEventCustomer.Set_acBankAcc(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacBankAcc, 'acBankAcc');
  TTradeEventData(oEventData).LTXRec.LCust.acBankAccountCode :=
     EncryptBankAccountCode(CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.acBankAccountCode, Value, FDataChanged));
end;


function TTradeEventCustomer.Get_acBankRef: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.BankRef;
end;

procedure TTradeEventCustomer.Set_acBankRef(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacBankRef, 'acBankRef');
  TTradeEventData(oEventData).LTXRec.LCust.BankRef := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.BankRef, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acBankSort: WideString;
begin
  //PR: 11/09/2013 ABSEXCH-14598 Changed to use new field
  Result := DecryptBankSortCode(TTradeEventData(oEventData).LTXRec.LCust.acBankSortCode);
end;

procedure TTradeEventCustomer.Set_acBankSort(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacBankSort, 'acBankSort');
  //PR: 11/09/2013 ABSEXCH-14598 Changed to use new field
  TTradeEventData(oEventData).LTXRec.LCust.acBankSortCode :=
              EncryptBankSortCode(CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.acBankSortCode, Value, FDataChanged));
end;


function TTradeEventCustomer.Get_acBookOrdVal: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.BOrdVal;
end;

procedure TTradeEventCustomer.Set_acBookOrdVal(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacBookOrdVal, 'acBookOrdVal');
  TTradeEventData(oEventData).LTXRec.LCust.BOrdVal := CustomSetReal(TTradeEventData(oEventData).LTXRec.LCust.BOrdVal, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCCEnd: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CCDEDate;
end;

procedure TTradeEventCustomer.Set_acCCEnd(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCCEnd, 'acCCEnd');
  TTradeEventData(oEventData).LTXRec.LCust.CCDEDate := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CCDEDate, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCCName: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CCDName;
end;

procedure TTradeEventCustomer.Set_acCCName(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCCName, 'acCCName');
  TTradeEventData(oEventData).LTXRec.LCust.CCDName := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CCDName, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCCNumber: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CCDCardNo;
end;

procedure TTradeEventCustomer.Set_acCCNumber(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCCNumber, 'acCCNumber');
  TTradeEventData(oEventData).LTXRec.LCust.CCDCardNo := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CCDCardNo, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCCStart: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CCDSDate;
end;

procedure TTradeEventCustomer.Set_acCCStart(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCCStart, 'acCCStart');
  TTradeEventData(oEventData).LTXRec.LCust.CCDSDate := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CCDSDate, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCCSwitch: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CCDSARef;
end;

procedure TTradeEventCustomer.Set_acCCSwitch(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCCSwitch, 'acCCSwitch');
  TTradeEventData(oEventData).LTXRec.LCust.CCDSARef := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CCDSARef, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CustCode;
end;

procedure TTradeEventCustomer.Set_acCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCode, 'acCode');
  TTradeEventData(oEventData).LTXRec.LCust.CustCode := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CustCode, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCompany: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.Company;
end;

procedure TTradeEventCustomer.Set_acCompany(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCompany, 'acCompany');
  TTradeEventData(oEventData).LTXRec.LCust.Company := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.Company, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acContact: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.Contact;
end;

procedure TTradeEventCustomer.Set_acContact(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacContact, 'acContact');
  TTradeEventData(oEventData).LTXRec.LCust.Contact := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.Contact, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCOSGL: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.DefCOSNom;
end;

procedure TTradeEventCustomer.Set_acCOSGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCOSGL, 'acCOSGL');
  TTradeEventData(oEventData).LTXRec.LCust.DefCOSNom := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.DefCOSNom, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCostCentre: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CustCC;
end;

procedure TTradeEventCustomer.Set_acCostCentre(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCostCentre, 'acCostCentre');
  TTradeEventData(oEventData).LTXRec.LCust.CustCC := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CustCC, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCreditLimit: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CreditLimit;
end;

procedure TTradeEventCustomer.Set_acCreditLimit(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCreditLimit, 'acCreditLimit');
  TTradeEventData(oEventData).LTXRec.LCust.CreditLimit := CustomSetReal(TTradeEventData(oEventData).LTXRec.LCust.CreditLimit, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acCreditStatus: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CreditStatus;
end;

procedure TTradeEventCustomer.Set_acCreditStatus(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCreditStatus, 'acCreditStatus');
  TTradeEventData(oEventData).LTXRec.LCust.CreditStatus := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.CreditStatus, Value, FDataChanged);
end;

function TTradeEventCustomer.Get_acCurrency: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.Currency;
end;

procedure TTradeEventCustomer.Set_acCurrency(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacCurrency, 'acCurrency');
  TTradeEventData(oEventData).LTXRec.LCust.Currency := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.Currency, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acDefSettleDays: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.DefSetDDays;
end;

procedure TTradeEventCustomer.Set_acDefSettleDays(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacDefSettleDays, 'acDefSettleDays');
  TTradeEventData(oEventData).LTXRec.LCust.DefSetDDays := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.DefSetDDays, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acDefSettleDisc: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.DefSetDisc;
end;

procedure TTradeEventCustomer.Set_acDefSettleDisc(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacDefSettleDisc, 'acDefSettleDisc');
  TTradeEventData(oEventData).LTXRec.LCust.DefSetDisc := CustomSetReal(TTradeEventData(oEventData).LTXRec.LCust.DefSetDisc, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acDelAddress: ITradeAddress;
begin
  Result := FDelAddrI;
end;


function TTradeEventCustomer.Get_acDepartment: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CustDep;
end;

procedure TTradeEventCustomer.Set_acDepartment(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacDepartment, 'acDepartment');
  TTradeEventData(oEventData).LTXRec.LCust.CustDep := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CustDep, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acDirDebMode: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.DirDeb;
end;

procedure TTradeEventCustomer.Set_acDirDebMode(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacDirDebMode, 'acDirDebMode');
  TTradeEventData(oEventData).LTXRec.LCust.DirDeb := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.DirDeb, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acDiscount: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.Discount;
end;

procedure TTradeEventCustomer.Set_acDiscount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacDiscount, 'acDiscount');
  TTradeEventData(oEventData).LTXRec.LCust.Discount := CustomSetReal(TTradeEventData(oEventData).LTXRec.LCust.Discount, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acDiscountBand: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CDiscCh;
end;

procedure TTradeEventCustomer.Set_acDiscountBand(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacDiscountBand, 'acDiscountBand');
  TTradeEventData(oEventData).LTXRec.LCust.CDiscCh := ExtractChar(CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CDiscCh, Value, FDataChanged), #255);
end;


function TTradeEventCustomer.Get_acDocDeliveryMode: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.InvDMode;
end;

procedure TTradeEventCustomer.Set_acDocDeliveryMode(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacDocDeliveryMode, 'acDocDeliveryMode');
  TTradeEventData(oEventData).LTXRec.LCust.InvDMode := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.InvDMode, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acDrCrGL: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.DefCtrlNom;
end;

procedure TTradeEventCustomer.Set_acDrCrGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacDrCrGL, 'acDrCrGL');
  TTradeEventData(oEventData).LTXRec.LCust.DefCtrlNom := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.DefCtrlNom, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acEBusPword: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.EBusPwrd;
end;

procedure TTradeEventCustomer.Set_acEBusPword(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacEBusPword, 'acEBusPword');
  TTradeEventData(oEventData).LTXRec.LCust.EBusPwrd := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.EBusPwrd, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acECMember: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.EECMember;
end;

procedure TTradeEventCustomer.Set_acECMember(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacECMember, 'acECMember');
  TTradeEventData(oEventData).LTXRec.LCust.EECMember := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.LCust.EECMember, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acEmailAddr: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.EmailAddr;
end;

procedure TTradeEventCustomer.Set_acEmailAddr(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacEmailAddr, 'acEmailAddr');
  TTradeEventData(oEventData).LTXRec.LCust.EmailAddr := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.EmailAddr, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acFax: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.Fax;
end;

procedure TTradeEventCustomer.Set_acFax(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacFax, 'acFax');
  TTradeEventData(oEventData).LTXRec.LCust.Fax := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.Fax, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acFormSet: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.FDefPageNo;
end;

procedure TTradeEventCustomer.Set_acFormSet(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacFormSet, 'acFormSet');
  TTradeEventData(oEventData).LTXRec.LCust.FDefPageNo := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.FDefPageNo, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acInclusiveVATCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.CVATIncFlg;
end;

procedure TTradeEventCustomer.Set_acInclusiveVATCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacInclusiveVATCode, 'acInclusiveVATCode');
  TTradeEventData(oEventData).LTXRec.LCust.CVATIncFlg := ExtractChar(CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.CVATIncFlg, Value, FDataChanged), #255);
end;


function TTradeEventCustomer.Get_acInvoiceTo: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.SOPInvCode;
end;

procedure TTradeEventCustomer.Set_acInvoiceTo(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacInvoiceTo, 'acInvoiceTo');
  TTradeEventData(oEventData).LTXRec.LCust.SOPInvCode := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.SOPInvCode, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acLastOperator: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.LastOpo;
end;

procedure TTradeEventCustomer.Set_acLastOperator(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacLastOperator, 'acLastOperator');
  TTradeEventData(oEventData).LTXRec.LCust.LastOpo := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.LastOpo, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acLastUsed: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.LastUsed;
end;


function TTradeEventCustomer.Get_acLocation: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.DefMLocStk;
end;

procedure TTradeEventCustomer.Set_acLocation(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacLocation, 'acLocation');
  TTradeEventData(oEventData).LTXRec.LCust.DefMLocStk := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.DefMLocStk, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acOwnTradTerm: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.TradTerm;
end;

procedure TTradeEventCustomer.Set_acOwnTradTerm(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacOwnTradTerm, 'acOwnTradTerm');
  TTradeEventData(oEventData).LTXRec.LCust.TradTerm := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.LCust.TradTerm, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acPayTerms: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.PayTerms;
end;

procedure TTradeEventCustomer.Set_acPayTerms(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacPayTerms, 'acPayTerms');
  TTradeEventData(oEventData).LTXRec.LCust.PayTerms := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.PayTerms, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acPayType: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.PayType;
end;

procedure TTradeEventCustomer.Set_acPayType(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacPayType, 'acPayType');
  TTradeEventData(oEventData).LTXRec.LCust.PayType := ExtractChar(CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.PayType, Value, FDataChanged),#255);
end;


function TTradeEventCustomer.Get_acPhone: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.Phone;
end;

procedure TTradeEventCustomer.Set_acPhone(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacPhone, 'acPhone');
  TTradeEventData(oEventData).LTXRec.LCust.Phone := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.Phone, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acPhone2: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.Phone2;
end;

procedure TTradeEventCustomer.Set_acPhone2(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxNeverAuthorise, 'acPhone2');
  TTradeEventData(oEventData).LTXRec.LCust.Phone := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.Phone, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acPostCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.PostCode;
end;

procedure TTradeEventCustomer.Set_acPostCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacPostCode, 'acPostCode');
  TTradeEventData(oEventData).LTXRec.LCust.PostCode := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.PostCode, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acSalesGL: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.DefNomCode;
end;

procedure TTradeEventCustomer.Set_acSalesGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacSalesGL, 'acSalesGL');
  TTradeEventData(oEventData).LTXRec.LCust.DefNomCode := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.DefNomCode, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acSendHTML: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.EmlSndHtml;
end;

procedure TTradeEventCustomer.Set_acSendHTML(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacSendHTML, 'acSendHTML');
  TTradeEventData(oEventData).LTXRec.LCust.EmlSndHtml := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.LCust.EmlSndHtml, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acSendReader: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.EmlSndRdr;
end;

procedure TTradeEventCustomer.Set_acSendReader(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacSendReader, 'acSendReader');
  TTradeEventData(oEventData).LTXRec.LCust.EmlSndRdr := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.LCust.EmlSndRdr, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acSOPAutoWOff: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.SOPAutoWOff;
end;

procedure TTradeEventCustomer.Set_acSOPAutoWOff(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacSOPAutoWOff, 'acSOPAutoWOff');
  TTradeEventData(oEventData).LTXRec.LCust.SOPAutoWOff := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.LCust.SOPAutoWOff, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acSSDDeliveryTerms: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.SSDDelTerms;
end;

procedure TTradeEventCustomer.Set_acSSDDeliveryTerms(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacSSDDeliveryTerms, 'acSSDDeliveryTerms');
  TTradeEventData(oEventData).LTXRec.LCust.SSDDelTerms := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.SSDDelTerms, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acSSDModeOfTransport: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.SSDModeTr;
end;

procedure TTradeEventCustomer.Set_acSSDModeOfTransport(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacSSDModeOfTransport, 'acSSDModeOfTransport');
  TTradeEventData(oEventData).LTXRec.LCust.SSDModeTr := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.SSDModeTr, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acStateDeliveryMode: Integer;
begin
//  Result := TTradeEventData(oEventData).LTXRec.LCust.SSDDelTerms;
  Result := TTradeEventData(oEventData).LTXRec.LCust.StatDMode;
end;

procedure TTradeEventCustomer.Set_acStateDeliveryMode(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacStateDeliveryMode, 'acStateDeliveryMode');
  TTradeEventData(oEventData).LTXRec.LCust.StatDMode := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.StatDMode, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acStatement: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.IncStat;
end;

procedure TTradeEventCustomer.Set_acStatement(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacStatement, 'acStatement');
  TTradeEventData(oEventData).LTXRec.LCust.IncStat := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.LCust.IncStat, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acStatementTo: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.RemitCode;
end;

procedure TTradeEventCustomer.Set_acStatementTo(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacStatementTo, 'acStatementTo');
  TTradeEventData(oEventData).LTXRec.LCust.RemitCode := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.RemitCode, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acTheirAcc: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.RefNo;
end;

procedure TTradeEventCustomer.Set_acTheirAcc(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxacTheirAcc, 'acTheirAcc');
  TTradeEventData(oEventData).LTXRec.LCust.RefNo := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.RefNo, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acTimeStamp: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.TimeChange;
end;


function TTradeEventCustomer.Get_acTradeTerms(Index: Integer): WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.STerms[Index];
end;

procedure TTradeEventCustomer.Set_acTradeTerms(Index: Integer; const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacTradeTerms, 'acTradeTerms');
  TTradeEventData(oEventData).LTXRec.LCust.STerms[Index] := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.STerms[Index], Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acUseForEbus: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.AllowWeb;
end;

procedure TTradeEventCustomer.Set_acUseForEbus(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacUseForEbus, 'acUseForEbus');
  TTradeEventData(oEventData).LTXRec.LCust.AllowWeb := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.AllowWeb, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acUserDef1: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.UserDef1;
end;

procedure TTradeEventCustomer.Set_acUserDef1(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacUserDef1, 'acUserDef1');
  TTradeEventData(oEventData).LTXRec.LCust.UserDef1 := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.UserDef1, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acUserDef2: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.UserDef2;
end;

procedure TTradeEventCustomer.Set_acUserDef2(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacUserDef2, 'acUserDef2');
  TTradeEventData(oEventData).LTXRec.LCust.UserDef2 := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.UserDef2, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acUserDef3: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.UserDef3;
end;

procedure TTradeEventCustomer.Set_acUserDef3(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacUserDef3, 'acUserDef3');
  TTradeEventData(oEventData).LTXRec.LCust.UserDef3 := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.UserDef3, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acUserDef4: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.UserDef4;
end;

procedure TTradeEventCustomer.Set_acUserDef4(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacUserDef4, 'acUserDef4');
  TTradeEventData(oEventData).LTXRec.LCust.UserDef4 := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.UserDef4, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acVATCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.VATCode;
end;

procedure TTradeEventCustomer.Set_acVATCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacVATCode, 'acVATCode');
  TTradeEventData(oEventData).LTXRec.LCust.VATCode := ExtractChar(CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.VATCode, Value, FDataChanged), #255);
end;


function TTradeEventCustomer.Get_acVATRegNo: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.VATRegNo;
end;

procedure TTradeEventCustomer.Set_acVATRegNo(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacVATRegNo, 'acVATRegNo');
  TTradeEventData(oEventData).LTXRec.LCust.VATRegNo := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.VATRegNo, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acWebLiveCatalog: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.WebLiveCat;
end;

procedure TTradeEventCustomer.Set_acWebLiveCatalog(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacWebLiveCatalog, 'acWebLiveCatalog');
  TTradeEventData(oEventData).LTXRec.LCust.WebLiveCat := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.WebLiveCat, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acWebPrevCatalog: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.WebPrevCat;
end;

procedure TTradeEventCustomer.Set_acWebPrevCatalog(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacWebPrevCatalog, 'acWebPrevCatalog');
  TTradeEventData(oEventData).LTXRec.LCust.WebPrevCat := CustomSetString(TTradeEventData(oEventData).LTXRec.LCust.WebPrevCat, Value, FDataChanged);
end;


function TTradeEventCustomer.Get_acZIPAttachments: TTradeEmailAttachmentZIPType;
begin
  Result := TTradeEventData(oEventData).LTXRec.LCust.EmlZipAtc;
end;

procedure TTradeEventCustomer.Set_acZIPAttachments(Value: TTradeEmailAttachmentZIPType);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxacZIPAttachments, 'acZIPAttachments');
  TTradeEventData(oEventData).LTXRec.LCust.EmlZipAtc := CustomSetInteger(TTradeEventData(oEventData).LTXRec.LCust.EmlZipAtc, Value, FDataChanged);
end;

end.
