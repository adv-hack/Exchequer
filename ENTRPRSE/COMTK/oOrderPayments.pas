unit oOrderPayments;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     Contnrs, ExBtth1U, oOPPayment, oOrderPaymentsRefundManager, VarConst,
     oOrderPaymentsSRC, OrderPaymentsInterfaces, oOrderPaymentRefundPayments, oToolkit,
     MiscFunc, oAccountContact, ContactsManager, EnterpriseBeta_TLB, ExceptIntf;

//PR: 17/09/2014 Order Payments T103/T104
type

  TDataAccessHelper = Class
  private
    FTransaction : InvRec;
    FExLocal : TdPostExLocalPtr;
    FClientID : Integer;
    FPaymentValue : Double;
    function GetExLocal : TdPostExLocalPtr;
  public
    constructor Create(const ATransaction : InvRec);
    destructor Destroy; override;
    property ExLocal : TdPostExLocalPtr Read GetExLocal;
    property PaymentValue : Double write FPaymentValue;
  end;

  //Credit card details
  TCreditCardDetailsRec = Record
    CardType: String;
    CardNumber: String;
    CardExpiry: String;
    AuthorisationNo: String;
    ReferenceNo: String;
  end;


  TCreditCardDetails = Class(TAutoIntfObjectEx, ICreditCardDetails)
  protected
    FDetails : TCreditCardDetailsRec;
    function Get_ccdCardType: WideString; safecall;
    procedure Set_ccdCardType(const Value: WideString); safecall;
    function Get_ccdCardNumber: WideString; safecall;
    procedure Set_ccdCardNumber(const Value: WideString); safecall;
    function Get_ccdCardExpiry: WideString; safecall;
    procedure Set_ccdCardExpiry(const Value: WideString); safecall;
    function Get_ccdAuthorisationNo: WideString; safecall;
    procedure Set_ccdAuthorisationNo(const Value: WideString); safecall;
    function Get_ccdReferenceNo: WideString; safecall;
    procedure Set_ccdReferenceNo(const Value: WideString); safecall;
  public
    constructor Create;
  end;

  //Fields needed for a payment
  TPaymentRec = Record
    Amount: Double;
    GLCode: Integer;
    CostCentre: string;
    Department: string;
    PaymentReference: string[70];
    CreditCardAction: TCreditCardAction;
    WindowHandle : Integer;
    ContactName : string;

    //Internal use only
    Provider : Int64;
    MerchantID : Int64;
  end;

  TOrderPaymentPayment = Class(TAutoIntfObjectEx, IOrderPaymentTakePayment, IBetaOP)
  protected
    FCreditCardDetailsO : TCreditCardDetails;
    FCreditCardDetailsI: ICreditCardDetails;
    FPayment : TPaymentRec;
    FTransaction : InvRec;
    FAccount : CustRec;
    FContactO : TAccountContact;
    FContactI : IAccountContact;
    oContactsManager : TContactsManager;

    //PR: 22/01/2015 Creating SRC for disaster recovery
    FSRCRef       : string;
    FSRCYear      : Byte;
    FSRCPeriod    : Byte;
    FSRCTransDate : string;

    FCompanyCode : String;
    function Get_oppValue: Double; safecall;
    procedure Set_oppValue(Value: Double); safecall;
    function Get_oppGLCode: Integer; safecall;
    procedure Set_oppGLCode(Value: Integer); safecall;
    function Get_oppCostCentre: WideString; safecall;
    procedure Set_oppCostCentre(const Value: WideString); safecall;
    function Get_oppDepartment: WideString; safecall;
    procedure Set_oppDepartment(const Value: WideString); safecall;
    function Get_oppPaymentReference: WideString; safecall;
    procedure Set_oppPaymentReference(const Value: WideString); safecall;
    function Get_oppCreditCardAction: TCreditCardAction; safecall;
    procedure Set_oppCreditCardAction(Value: TCreditCardAction); safecall;
    function Get_oppCreditCardDetails: ICreditCardDetails; safecall;
    function Get_oppContact: IAccountContact; safecall;
    procedure Set_oppContact(const Value: IAccountContact); safecall;
    function Get_oppWindowHandle: Integer; safecall;
    procedure Set_oppWindowHandle(Value: Integer); safecall;

    function Get_oppContactName: WideString; safecall;
    procedure Set_oppContactName(const Value: WideString); safecall;

    procedure SetContact(ContactId : Integer);
    function ValidateFields : Integer;
    function Execute: Integer; safecall;

    //PR: 22/01/2015 IBetaOP
    function Get_SRCRef: WideString; safecall;
    procedure Set_SRCRef(const Value: WideString); safecall;
    function Get_SRCYear: Integer; safecall;
    procedure Set_SRCYear(Value: Integer); safecall;
    function Get_SRCPeriod: Integer; safecall;
    procedure Set_SRCPeriod(Value: Integer); safecall;
    function Get_SRCTransDate: WideString; safecall;
    procedure Set_SRCTransDate(const Value: WideString); safecall;

    procedure ImportDefaults; safecall;

  public
    constructor Create(const ATransaction : InvRec; const AnAccount : CustRec);
    destructor Destroy; override;
  end;


  TOrderPaymentRefundRec = Record
    RefundReason: string[50];
    CreditCardAction : TCreditCardAction;
    Windowhandle : Integer;
  end;

  TOrderPaymentRefund = Class(TAutoIntfObjectEx, IOrderPaymentGiveRefund, IBetaOP)
  protected
    FRefund : TOrderPaymentRefundRec;

    FCreditCardDetailsO : TCreditCardDetails;
    FCreditCardDetailsI : TCreditCardDetails;

    FDataAccess : TDataAccessHelper;

    FOPPaymentInfo : IOrderPaymentsTransactionPaymentInfo;

    FTransaction : InvRec;
    FTransO : TObject;

    FAccount : CustRec;

    FIntfType : TInterfaceMode;

    FPaymentsO : TOrderPaymentRefundPaymentList;
    FPaymentsI : IOrderPaymentRefundPaymentList;
    FCompanyCode : string;

    //PR: 22/01/2015 Creating SRC for disaster recovery
    FSRCRef       : string;
    FSRCYear      : Byte;
    FSRCPeriod    : Byte;
    FSRCTransDate : string;

    function Get_oprValue: Double; safecall;
    function Get_oprRefundReason: WideString; safecall;
    procedure Set_oprRefundReason(const Value: WideString); safecall;
    function Get_oprCreditCardAction: TCreditCardAction; safecall;
    procedure Set_oprCreditCardAction(Value: TCreditCardAction); safecall;
    function Get_oprWindowHandle: Integer; safecall;
    procedure Set_oprWindowHandle(Value: Integer); safecall;

    function Get_oprCreditCardDetails: ICreditCardDetails; safecall;

    function Get_oprPayments: IOrderPaymentRefundPaymentList; safecall;


    //PR: 22/01/2015 IBetaOP
    function Get_SRCRef: WideString; safecall;
    procedure Set_SRCRef(const Value: WideString); safecall;
    function Get_SRCYear: Integer; safecall;
    procedure Set_SRCYear(Value: Integer); safecall;
    function Get_SRCPeriod: Integer; safecall;
    procedure Set_SRCPeriod(Value: Integer); safecall;
    function Get_SRCTransDate: WideString; safecall;
    procedure Set_SRCTransDate(const Value: WideString); safecall;

    procedure SetFullRefund; safecall;

    procedure LoadPayments;
    function RefundValue(iPayment : Integer) : Double;

    function Execute: Integer; safecall;

    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean;


  public
    constructor Create(const ATransaction : TObject; const AnAccount : CustRec; const AToolkit : TToolkit);
    destructor Destroy; override;
  end;


implementation

uses
  ComServ, CurrncyU, oOPVATPayBtrieveFile, oOrderPaymentsTransactionInfo, oBtrieveFile, GlobVar, EtStrU,
  StrUtils, EtMiscU,
  oCreditCardGateway, AccountContactRoleUtil,
  BtSupU2, oOrderPaymentsTransactionPaymentInfo, OTrans, BtrvU2, BTSupU1, BtKeys1U, DllErrU,
  CreditCardUtils, SQLUtils, TxStatusF;

var
  ClientIds : TBits;

{ TOrderPaymentPayment }

constructor TOrderPaymentPayment.Create(const ATransaction : InvRec; const AnAccount : CustRec);
begin
  inherited Create(ComServer.TypeLib, IOrderPaymentTakePayment);


  FillChar(FPayment, SizeOf(FPayment), 0);

  //Default from customer
  FPayment.GLCode := AnAccount.acOrderPaymentsGLCode;
  FPayment.CostCentre := AnAccount.CustCC;
  FPayment.Department := AnAccount.CustDep;

  FCreditCardDetailsO := nil;
  FCreditCardDetailsI := nil;

  FContactO := nil;
  FContactI := nil;

  FTransaction := ATransaction;
  FAccount := AnAccount;

  if not Assigned(STDCurrList) then
    Init_STDCurrList;

  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
end;

destructor TOrderPaymentPayment.Destroy;
begin
  FCreditCardDetailsO := nil;
  FCreditCardDetailsI := nil;

  FContactI := nil;

  // CJS 2015-08-03 - Move these lines into finalisation as the list is still
  // being used under some circumstances (apparently when the Toolkit is used
  // from .NET)
//  if Assigned((STDCurrList)) then
//     FreeAndNil(STDCurrList);

  if Assigned(oContactsManager) then
    oContactsManager.Free;

  inherited;
end;

function TOrderPaymentPayment.Execute: Integer;
var
  iPayment : IOrderPaymentsPayment;
  FOrderPaymentsTransaction : IOrderPaymentsTransactionInfo;
  FakeAccountContact : TAccountContact;
begin
  If Syss.ssEnableOrderPayments And FAccount.acAllowOrderPayments Then
  Begin
    //Validate GL, CC, Dept.
    Result := ValidateFields;

    if Result = 0 then
    begin
      // Calculate the SOR details and lock it to protect the payment operation
      FOrderPaymentsTransaction := OPTransactionInfo (FTransaction, FAccount);
      Try
        // Check there is something to pay and that sufficient funds are available
        If FOrderPaymentsTransaction.CanTakePayment Then
        Begin
          // Get a record lock
          If FOrderPaymentsTransaction.LockTransaction Then
          Begin
            //If necessary, then set window handle on credit card gateway singleton
            if FPayment.CreditCardAction <> ccaNone then
            begin
              CreditCardPaymentGateway.SetOwnerHandle(FPayment.WindowHandle);
              CreditCardPaymentGateway.SetCompanyCode(FCompanyCode);
            end;

            iPayment := NewOrderPayment;
            iPayment.oppOrderPaymentTransInfo := FOrderPaymentsTransaction;

            if Round_Up(FPayment.Amount, 2) <= Round_Up(FOrderPaymentsTransaction.optMaxPayment, 2) then
            begin
              if Round_Up(FPayment.Amount, 2) = Round_Up(FOrderPaymentsTransaction.optMaxPayment, 2) then
                iPayment.oppPaymentType := ptFull
              else
                iPayment.oppPaymentType := ptPart;

              iPayment.oppPaymentValue := Round_Up(FPayment.Amount, 2);
              iPayment.oppPaymentGLCode := FPayment.GLCode;
              iPayment.oppPaymentReference := FPayment.PaymentReference;
              iPayment.oppCreditCardAction := enumCreditCardAction(FPayment.CreditCardAction);

              iPayment.oppPaymentCostCentre := FPayment.CostCentre;
              iPayment.oppPaymentDepartment := FPayment.Department;

              if Assigned(FContactO) then
                iPayment.SetContactDetails(FContactO)
              else
              begin
                //
                FakeAccountContact := TAccountContact.Create;
                FakeAccountContact.contactDetails.acoContactName := FPayment.ContactName;
                FakeAccountContact.contactDetails.acoContactPhoneNumber := Trim(FOrderPaymentsTransaction.optAccount.Phone);
                FakeAccountContact.contactDetails.acoContactEmailAddress := Trim(FOrderPaymentsTransaction.optAccount.EmailAddr);
                FakeAccountContact.contactDetails.acoContactHasOwnAddress := False;
                iPayment.SetContactDetails(FakeAccountContact);
              end;

              if FSRCYear <> 0 then
              begin
                iPayment.oppSRCRef := FSRCRef;
                iPayment.oppSRCYear := FSRCYear;
                iPayment.oppSRCPeriod := FSRCPeriod;
                iPayment.oppSRCTransDate := FSRCTransDate;
              end;

              if (FPayment.Provider <> 0) and (FPayment.MerchantId <> 0) then
              begin
                iPayment.oppProvider := FPayment.Provider;
                iPayment.oppMerchantId := FPayment.MerchantId;

              end;

              Result := iPayment.CreatePayment;

            end
            else  //PR: 27/01/2015 ABSEXCH-16070
              Result := 30010;

          End // If iOrderPaymentsTransaction.LockTransaction
          Else
            Result := 84;
        End // If FOrderPaymentsTransaction.CanTakePayment
        else //PR: 27/01/2015 ABSEXCH-16071
          Result := 30009;
      Finally
        FOrderPaymentsTransaction := nil;
      End;
    end; //If Result = 0 (ValidateFields)
  End //
  Else
    REsult := 30001;

  //Set error message

  //If it's a credit card validation error then set from the shared error message function in
  //oCreditCardGateway.pas otherwise use the standard function in DllErrU.pas
  if (ccValidationErrors(Result) >= veInvalidPaymentProvider) and
     (ccValidationErrors(Result) <= veInvalidGrossTotal) then
  begin
    LastErDesc := CCGatewayErrorMessage(Result);
    Result := Result + 30000; //Bring return code into usual toolkit range
  end
  else
  begin
    if (Result in [TOKEN_STATUS_NOT_AUTHORISED..TOKEN_STATUS_ERROR]) then
      Result := 30200 + Result;
    LastErDesc := EX_ERRORDESCRIPTION(630, Result);
  end;


end;

function TOrderPaymentPayment.Get_oppValue: Double;
begin
  Result := FPayment.Amount;
end;

function TOrderPaymentPayment.Get_oppCostCentre: WideString;
begin
  Result := FPayment.CostCentre;
end;

function TOrderPaymentPayment.Get_oppCreditCardAction: TCreditCardAction;
begin
  Result := FPayment.CreditCardAction;
end;

function TOrderPaymentPayment.Get_oppCreditCardDetails: ICreditCardDetails;
begin
  if not Assigned(FCreditCardDetailsO) then
  begin
    FCreditCardDetailsO := TCreditCardDetails.Create;

    FCreditCardDetailsI := FCreditCardDetailsO;
  end;

  Result := FCreditCardDetailsI;
end;

function TOrderPaymentPayment.Get_oppDepartment: WideString;
begin
  Result := FPayment.Department;
end;

function TOrderPaymentPayment.Get_oppGLCode: Integer;
begin
  Result := FPayment.GLCode;
end;

function TOrderPaymentPayment.Get_oppPaymentReference: WideString;
begin
  Result := FPayment.PaymentReference;
end;


procedure TOrderPaymentPayment.Set_oppValue(Value: Double);
begin
  FPayment.Amount := Value;
end;

procedure TOrderPaymentPayment.Set_oppCostCentre(const Value: WideString);
begin
  FPayment.CostCentre := Value;
end;

procedure TOrderPaymentPayment.Set_oppCreditCardAction(
  Value: TCreditCardAction);
begin
  FPayment.CreditCardAction := Value;
end;

procedure TOrderPaymentPayment.Set_oppDepartment(const Value: WideString);
begin
  FPayment.Department := Value;
end;

procedure TOrderPaymentPayment.Set_oppGLCode(Value: Integer);
begin
  FPayment.GLCode := Value;
end;

procedure TOrderPaymentPayment.Set_oppPaymentReference(
  const Value: WideString);
begin
  FPayment.PaymentReference := Value;
end;

function TOrderPaymentPayment.ValidateFields: Integer;
var
  KeyS : Str255;
  Res : Integer;
  iContact : Integer;
  oContactList : TArrayOfAccountContacts;
  Found : Boolean;
begin
  Result := 0;
  oContactList := nil;

  //PR: 29/01/2015 ABSEXCH-16096 Payment must be more than 0
  if Round_Up(FPayment.Amount, 2) <= 0 then
    Result := 30011;

  if Result = 0 then
  begin
    //Validate GL Code
    if CheckRecExsists(Strip('R',[#0], FullNomKey(FPayment.GLCode)), NomF, NomCodeK) then
    begin   //Must be balance sheet - if using classes then must be bank a/c
      if (Nom.NomType <> 'B') or (Syss.UseGLClass and (Nom.NomClass <> 10 {Bank A/C})) then
        Result := 30002;
    end
    else
      Result := 30002;
  end;

  if (Result = 0) and Syss.UseCCDep then
  begin
    //Validate CostCentre
    KeyS := CostCCode+CSubCode[True]+ FullCCDepKey(UpperCase(FPayment.CostCentre));
    Res := Find_Rec(B_GetEq, F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK, KeyS);
    if Res <> 0 then
      Result := 30003;

    if Result = 0 then
    begin
      //Validate Department
      //PR: 28/01/2015 ABSEXCH-16084 Was using CC subtype
      KeyS := CostCCode+CSubCode[False]+ FullCCDepKey(UpperCase(FPayment.Department));
      Res := Find_Rec(B_GetEq, F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK, KeyS);
      if Res <> 0 then
        Result := 30004;
    end;
  end;

  if (Result = 0) and Assigned(FContactO) then
  begin
    //Contact needs to be for this account
    if Trim(FContactO.contactDetails.acoAccountCode) <> Trim(FAccount.Custcode) then
      Result := 30005;

    if (Result = 0) and Assigned(oContactsManager) then
    begin
      //Contact needs to be credit card contact
      oContactList := oContactsManager.GetContactListByRole(riCreditCardPayment);

      Found := False;
      for iContact := 0 to Length(oContactList) do
        Found := FcontactO.contactDetails.acoContactId = oContactList[iContact].contactDetails.acoContactId;

      if not Found then
        Result := 30005;
    end;
  end;

  //If we want to make a credit card payment/authorisation/refund then make sure the plug-in is installed
  if (Result = 0) and (FPayment.CreditCardAction <> ccaNone) then
  begin
    if not CreditCardPluginInstalled(FCompanyCode) then
      Result := 30006;

    if (Result = 0) and
    not (FPayment.CreditCardAction in [ccaAuthorisationOnly, ccaPayment, ccaPaymentUsingAuthorisation]) then
      Result := 30007;

    if (Result = 0) and (FPayment.WindowHandle = 0) then
      Result := 30008;

  end;

end;

procedure TOrderPaymentPayment.ImportDefaults;
begin
  if (FPayment.CreditCardAction <> ccaNone) and CreditCardPluginInstalled(FCompanyCode) then
  with FTransaction do
  begin
    CreditCardPaymentGateway.GetPaymentDefaults(FPayment.GLcode, FPayment.Provider, FPayment.MerchantId, FPayment.CostCentre,
                                                FPayment.Department, DocUser5, DocUser6, DocUser7,
                                                DocUser8, DocUser9, DocUser10);

  end
  else
  begin
    //PR: 03/03/2015 ABSEXCH-16212 CC Plugin not installed - take defaults from customer
    FPayment.GLCode := FAccount.acOrderPaymentsGLCode;
    FPayment.CostCentre := FAccount.CustCC;
    FPayment.Department := FAccount.CustDep;
  end;
end;

function TOrderPaymentPayment.Get_oppContact: IAccountContact;
begin
  Result := FContactI;
end;

procedure TOrderPaymentPayment.Set_oppContact(
  const Value: IAccountContact);
begin
  if Assigned(Value) then
  begin
    FContactI := Value;
    SetContact(FContactI.acoContactID);
  end;
end;

procedure TOrderPaymentPayment.SetContact(ContactId: Integer);
var
  oContact : TAccountContact;
begin
  oContactsManager := NewContactsManager;
  FContactO := oContactsManager.GetContactById(ContactId);
end;

function TOrderPaymentPayment.Get_oppWindowHandle: Integer;
begin
  Result := FPayment.WindowHandle;
end;

procedure TOrderPaymentPayment.Set_oppWindowHandle(Value: Integer);
begin
  FPayment.WindowHandle := Value;
end;


function TOrderPaymentPayment.Get_SRCRef: WideString;
begin
  Result := FSRCRef;
end;

procedure TOrderPaymentPayment.Set_SRCRef(const Value: WideString);
begin
  FSRCRef := Value;
end;

function TOrderPaymentPayment.Get_SRCPeriod: Integer;
begin
  Result := FSRCPeriod;
end;

function TOrderPaymentPayment.Get_SRCTransDate: WideString;
begin
  Result := FSRCTransDate;
end;

function TOrderPaymentPayment.Get_SRCYear: Integer;
begin
  Result := FSRCYear;
end;

procedure TOrderPaymentPayment.Set_SRCPeriod(Value: Integer);
begin
  FSRCPeriod := Value;
end;

procedure TOrderPaymentPayment.Set_SRCTransDate(const Value: WideString);
begin
  FSRCTransDate := Value;
end;

procedure TOrderPaymentPayment.Set_SRCYear(Value: Integer);
begin
  FSRCYear := Value;
end;

function TOrderPaymentPayment.Get_oppContactName: WideString;
begin
  Result := FPayment.ContactName;
end;

procedure TOrderPaymentPayment.Set_oppContactName(const Value: WideString);
begin
  FPayment.ContactName := Value;
end;

{ TCreditCardDetails }

constructor TCreditCardDetails.Create;
begin
  inherited Create(ComServer.TypeLib, ICreditCardDetails);
  FillChar(FDetails, SizeOf(FDetails), 0);
end;

function TCreditCardDetails.Get_ccdAuthorisationNo: WideString;
begin
  Result := FDetails.AuthorisationNo;
end;

function TCreditCardDetails.Get_ccdCardExpiry: WideString;
begin
  Result := FDetails.CardExpiry;
end;

function TCreditCardDetails.Get_ccdCardNumber: WideString;
begin
  Result := FDetails.CardNumber;
end;

function TCreditCardDetails.Get_ccdCardType: WideString;
begin
  Result := FDetails.CardType;
end;

function TCreditCardDetails.Get_ccdReferenceNo: WideString;
begin
  Result := FDetails.ReferenceNo;
end;

procedure TCreditCardDetails.Set_ccdAuthorisationNo(
  const Value: WideString);
begin
  FDetails.AuthorisationNo := Value;
end;

procedure TCreditCardDetails.Set_ccdCardExpiry(const Value: WideString);
begin
  FDetails.CardExpiry := Value;
end;

procedure TCreditCardDetails.Set_ccdCardNumber(const Value: WideString);
begin
  FDetails.CardNumber := Value;
end;

procedure TCreditCardDetails.Set_ccdCardType(const Value: WideString);
begin
  FDetails.CardType := Value;
end;

procedure TCreditCardDetails.Set_ccdReferenceNo(const Value: WideString);
begin
  FDetails.ReferenceNo := Value;
end;

{ TOrderPaymentRefund }

constructor TOrderPaymentRefund.Create(const ATransaction : TObject; const AnAccount : CustRec; const AToolkit : TToolkit);
begin
  inherited Create(ComServer.TypeLib, IOrderPaymentGiveRefund);
  FIntfType := imGeneral;

  FillChar(FRefund, SizeOf(FRefund), 0);

  FCreditCardDetailsO := nil;
  FCreditCardDetailsI := nil;


  FTransO := ATransaction;

  FTransaction := TTransaction(FTransO).Trans;
  FAccount := AnAccount;

  FDataAccess := TDataAccessHelper.Create(FTransaction);
  FPaymentsO := TOrderPaymentRefundPaymentList.Create;
  FPaymentsI := FPaymentsO;
  LoadPayments;

  if not Assigned(STDCurrList) then
    Init_STDCurrList;

  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
end;

destructor TOrderPaymentRefund.Destroy;
begin
  FCreditCardDetailsO := nil;
  FCreditCardDetailsI := nil;

  // CJS 2015-08-03 - Move these lines into finalisation as the list is still
  // being used under some circumstances (apparently when the Toolkit is used
  // from .NET)
//  if Assigned((STDCurrList)) then
//     FreeAndNil(STDCurrList);

  FDataAccess.Free;

  FPaymentsO := nil;
  FPaymentsI := nil;

  inherited;
end;

function TOrderPaymentRefund.Execute: Integer;
var
  oRefundManager : TOrderPaymentsRefundManager;
   oPaymentInfo : IOrderPaymentsTransactionPaymentInfoPaymentHeader;
  i : Integer;
  RefundMade : Boolean; //PR: 30/01/2015 ABSEXCH-16081 Used to keep track of whether any refunds have been made.
begin
  AuthoriseFunction(100, 'Execute');
  RefundMade := False;

  If Syss.ssEnableOrderPayments And FAccount.acAllowOrderPayments Then
  Begin
    oRefundManager := TOrderPaymentsRefundManager.Create (FOPPaymentInfo.ExLocal);
    Try
      oRefundManager.rmAccount := FAccount;
      Result := 0;
      i := 0;

      //If we want to make a credit card payment/authorisation/refund then make sure the plug-in is installed
      if (FRefund.CreditCardAction <> ccaNone) then
      begin
        if not CreditCardPluginInstalled(FCompanyCode) then
          Result := 30006;

        if (Result = 0) and (FRefund.CreditCardAction <> ccaRefund) then
          Result := 30007;

        if (Result = 0) and (FRefund.WindowHandle = 0) then
          Result := 30008;


        //If necessary, then set window handle on credit card gateway singleton
        if (Result = 0) and (FOPPaymentInfo.oppiPaymentCount > 0) then
           CreditCardPaymentGateway.SetOwnerHandle(FRefund.WindowHandle);
      end;

      //Iterate through payments - if any have a refund value then do that refund
      while (i < FOPPaymentInfo.oppiPaymentCount) and (Result = 0) do
      begin
        if FOPPaymentInfo.oppiPayments[i].opphRefundValue > 0.0 then
        begin
          oRefundManager.rmPaymentInfo := FOPPaymentInfo;
          oRefundManager.rmPaymentTransaction := FOPPaymentInfo.oppiPayments[i];
          oRefundManager.rmCreditCardAction := enumCreditCardAction(FRefund.CreditCardAction);
          oRefundManager.rmRefundReason := FRefund.RefundReason;

          Result := oRefundManager.ExecuteRefund;

          if Result = 0 then
          begin
            //Set OurRef for refund transaction
            FPaymentsO.GetPaymentObject(i + 1).RefundOurRef := oRefundManager.rmRefundSRCOurRef;
            FIntfType := imClone;
            RefundMade := True; //Record that we've made a refund
          end;
        end;

        inc(i);
      end;
    Finally
      oRefundManager := nil;
    End;

    if (Result = 0) and not RefundMade then
      Result := 30009;  //No refunds made - must be already fully refunded

  end
  else
    Result := 30001;

  //Set error message
  //If it's a credit card validation error then set from the shared error message function in
  //oCreditCardGateway.pas otherwise use the standard function in DllErrU.pas
  if (ccValidationErrors(Result) >= veInvalidPaymentProvider) and
     (ccValidationErrors(Result) <= veInvalidGrossTotal) then
  begin
    LastErDesc := CCGatewayErrorMessage(Result);
    Result := Result + 30000; //Bring return code into usual toolkit range
  end
  else
  begin
    if (Result in [TOKEN_STATUS_NOT_AUTHORISED..TOKEN_STATUS_ERROR]) then
      Result := 30200 + Result;
    LastErDesc := EX_ERRORDESCRIPTION(631, Result);
  end;
end;

function TOrderPaymentRefund.Get_oprValue: Double;
var
  i : Integer;
begin
  Result := 0;

  for i := 0 to FOPPaymentInfo.oppiPaymentCount -1 do
    Result := Result + FOPPaymentInfo.oppiPayments[i].opphRefundValue;
end;

function TOrderPaymentRefund.Get_oprCreditCardAction: TCreditCardAction;
begin
  Result := FRefund.CreditCardAction;
end;

function TOrderPaymentRefund.Get_oprCreditCardDetails: ICreditCardDetails;
begin
  if not Assigned(FCreditCardDetailsO) then
  begin
    FCreditCardDetailsO := TCreditCardDetails.Create;

    FCreditCardDetailsI := FCreditCardDetailsO;
  end;

  Result := FCreditCardDetailsI;
end;

function TOrderPaymentRefund.Get_oprPayments: IOrderPaymentRefundPaymentList;
begin
  Result := FPaymentsO;
end;

function TOrderPaymentRefund.Get_oprRefundReason: WideString;
begin
  Result := FRefund.RefundReason;
end;

procedure TOrderPaymentRefund.LoadPayments;
var
  i : Integer;
begin
  FOPPaymentInfo := OPTransactionPaymentInfo (FTransaction);

  For I := 0 To (FOPPaymentInfo.oppiPaymentCount - 1) Do
  begin
    FPaymentsO.Add(ITransaction(TTransaction(FtransO)).Clone,
                   TTransaction(FtransO).GetCloneInterface(FOPPaymentInfo.oppiPayments[i].opphOurRef),
                   FOPPaymentInfo.oppiPayments[i], TTransaction(FtransO));
  end;

end;

function TOrderPaymentRefund.RefundValue(iPayment : Integer): Double;
begin
  Result := FOPPaymentInfo.oppiPayments[iPayment].opphRefundValue;
end;

procedure TOrderPaymentRefund.Set_oprCreditCardAction(
  Value: TCreditCardAction);
begin
  FRefund.CreditCardAction := Value;
end;

procedure TOrderPaymentRefund.Set_oprRefundReason(const Value: WideString);
begin
  FRefund.RefundReason := Value;
end;


constructor TDataAccessHelper.Create(const ATransaction : InvRec);
begin
  inherited Create;

  FTransaction := ATransaction;
  FClientId := ClientIds.OpenBit;

  ClientIds.Bits[FClientId] := True;
  New(FExLocal, Create(FClientId, 'TO')); //Use a 'TO' client id to keep it distinct

  // Open required Data Files - minimise number of files being opened to reduce overhead
  FExLocal.Open_System(CustF,CustF);
  FExLocal.Open_System(InvF,IDetailF);
  FExLocal.Open_System(NHistF,NHistF); // Customer balances
  FExLocal.Open_System(PwrdF,PwrdF);   // Audit notes, Matching
  FExLocal.Open_System(IncF,IncF);     // Doc Numbers
end;

destructor TDataAccessHelper.Destroy;
begin
  ClientIDs[FClientID] := False;

  FExLocal.Close_Files;
  Dispose(FExLocal, Destroy);

  inherited;
end;

function TDataAccessHelper.GetExLocal: TdPostExLocalPtr;
begin
  Result := FExLocal;
end;

procedure TOrderPaymentRefund.SetFullRefund;
var
  i : integer;
begin
  for i := 1 to FPaymentsI.oprpCount do
    FPaymentsI.oprpPayments[i].SetFullRefund;
end;

function TOrderPaymentRefund.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte): Boolean;
begin
  Case FuncNo Of
    //Execute method
    100       : Result := (FIntfType = imGeneral);
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
end;

function TOrderPaymentRefund.Get_oprWindowHandle: Integer;
begin
  Result := FRefund.WindowHandle;
end;

procedure TOrderPaymentRefund.Set_oprWindowHandle(Value: Integer);
begin
  FRefund.WindowHandle := Value;
end;

function TOrderPaymentRefund.Get_SRCRef: WideString;
begin
  Result := FSRCRef;
end;

procedure TOrderPaymentRefund.Set_SRCRef(const Value: WideString);
begin
  FSRCRef := Value;
end;

function TOrderPaymentRefund.Get_SRCPeriod: Integer;
begin
  Result := FSRCPeriod;
end;

function TOrderPaymentRefund.Get_SRCTransDate: WideString;
begin
  Result := FSRCTransDate;
end;

function TOrderPaymentRefund.Get_SRCYear: Integer;
begin
  Result := FSRCYear;
end;

procedure TOrderPaymentRefund.Set_SRCPeriod(Value: Integer);
begin
  FSRCPeriod := Value;
end;

procedure TOrderPaymentRefund.Set_SRCTransDate(const Value: WideString);
begin
  FSRCTransDate := Value;
end;

procedure TOrderPaymentRefund.Set_SRCYear(Value: Integer);
begin
  FSRCYear := Value;
end;

Initialization
  // Use the ClientIds TBits to generate unique Client Id numbers across multiple instances
  // of the object
  ClientIds := TBits.Create;
  ClientIds[0] := True;  // Reserve so we start at 1
Finalization
  FreeAndNIL(ClientIds);

  // CJS 2015-08-03 - Move these lines into finalization section
  if Assigned((STDCurrList)) then
     FreeAndNil(STDCurrList);

end.


