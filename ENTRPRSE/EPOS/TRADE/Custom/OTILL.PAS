unit oTill;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, EPOSCnst, oDrawer, oPrnting
  , oCards, oSysLoc, oCompany, StdCtrls, EPOSProc, CLasses, CustomP, MiscUtil
  , SysUtils;

type
  TTCMSetupTillPropertyIndex = (pIdxssCreateTransType);

  TTradeTCMSetupTill = class(TAutoIntfObject, ITradeTCMSetupTill)
  private
    FDataChanged : Boolean;

    lSetupRecord : TEposSetupRec;
    lsTillName : string;
    liTillNo : integer;

    FCashDrawerO : TTradeTCMSetupCashDrawer;
    FCashDrawerI : ITradeTCMSetupCashDrawer;

    FPrintingO : TTradeTCMSetupPrinting;
    FPrintingI : ITradeTCMSetupPrinting;

    FCreditCardsO : TTradeTCMSetupCreditCards;
    FCreditCardsI : ITradeTCMSetupCreditCards;

    FLocationO : TTradeLocation;
    FLocationI : ITradeLocation;

    FCompanyO : TTradeCompany;
    FCompanyI : ITradeCompany;

    oEventData : TObject;
  protected
    function Get_ssTillName: WideString; safecall;
    function Get_ssCompanyCode: WideString; safecall;
    function Get_ssAfterTender: TTradeAfterTender; safecall;
    function Get_ssDefaultAccountCode: WideString; safecall;
    function Get_ssTillCurrency: Integer; safecall;
    function Get_ssCashGLCode: Integer; safecall;
    function Get_ssChequeGLCode: Integer; safecall;
    function Get_ssSSDDeliveryTerms: WideString; safecall;
    function Get_ssSSDModeOfTransport: Integer; safecall;
    function Get_ssStockLocation: WideString; safecall;
    function Get_ssWriteOffGLCode: Integer; safecall;
    function Get_ssNonStockGLCode: Integer; safecall;
    function Get_ssCashOnlyCustType: WideString; safecall;
    function Get_ssAutoAddLine: WordBool; safecall;
    function Get_ssAllowModifyVATRate: WordBool; safecall;
    function Get_ssRoundChange: WordBool; safecall;
    function Get_ssRoundChangeTo: Double; safecall;
    function Get_ssCreateTransType: TTradeCreateTXType; safecall;
    function Get_ssCreateNegTransType: TTradeCreateNegTXType; safecall;
    function Get_ssDiscountType: TTradeDiscountType; safecall;
    function Get_ssUseDefaultAccountCode: WordBool; safecall;
    function Get_ssFilterSerialNoByLocation: WordBool; safecall;
    function Get_ssTakeNonStockDefaultFrom: TTradeTakeNonStockDefaultFrom; safecall;
    function Get_ssNonStockItemCode: WideString; safecall;
    function Get_ssNonStockVATCode: WideString; safecall;
    function Get_ssCCDeptMode: TTradeCCDeptMode; safecall;
    function Get_ssCostCentre: WideString; safecall;
    function Get_ssDepartment: WideString; safecall;
    function Get_ssAllowDepositsOnCashCust: WordBool; safecall;
    function Get_ssCashDrawer: ITradeTCMSetupCashDrawer; safecall;
    function Get_ssPrinting: ITradeTCMSetupPrinting; safecall;
    function Get_ssCreditCards: ITradeTCMSetupCreditCards; safecall;
    function Get_ssLocation: ITradeLocation; safecall;
    function Get_ssCompany: ITradeCompany; safecall;
    function Get_ssTransactionTagNo: Integer; safecall;
//    procedure Set_ssCreateTransType(Value: TTradeCreateTXType); safecall;

//    Procedure AuthoriseProperty (Const PropertyIdx : TTCMSetupTillPropertyIndex; const PropName : ShortString);
//    Function GetDataChanged : Boolean;

  public
//    Property DataChanged : Boolean Read GetDataChanged; // DataChanged flag indicates whether Plug-Ins made any changes to

    Constructor Create(SetupRec : TEposSetupRec; sTillName : string; iTillNo : integer);
    Destructor Destroy; override;

//    Procedure Assign(EventData : TObject);
//    Procedure Assign(EventData : TObject; ASetupRec : TEposSetupRec);
  End; { TTradeTCMSetupTill }

implementation

uses
  oEvent, ComServ, TXHead;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeTCMSetupTill.Create(SetupRec : TEposSetupRec; sTillName : string
; iTillNo : integer);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeTCMSetupTill);

  lSetupRecord := SetupRec;

  lsTillName := sTillName;
  liTillNo := iTillNo;

  FCashDrawerO := TTradeTCMSetupCashDrawer.create(lSetupRecord);
  FCashDrawerI := FCashDrawerO;

  FPrintingO := TTradeTCMSetupPrinting.create(lSetupRecord);
  FPrintingI := FPrintingO;

  FCreditCardsO := TTradeTCMSetupCreditCards.Create(lSetupRecord.CreditCards);
  FCreditCardsI := FCreditCardsO;

  FLocationO := TTradeLocation.Create(lSetupRecord.DefStockLocation);
  FLocationI := FLocationO;

  FCompanyO := TTradeCompany.Create(lSetupRecord.TillCompany, slCompanies);
  FCompanyI := FCompanyO;

  FDataChanged := False;
End; { Create }

Destructor TTradeTCMSetupTill.Destroy;
Begin { Destroy }

  FCashDrawerO := nil;
  FCashDrawerI := nil;

  FPrintingO := nil;
  FPrintingI := nil;

  FCreditCardsO := nil;
  FCreditCardsI := nil;

  FLocationO := nil;
  FLocationI := nil;

  FCompanyO := nil;
  FCompanyI := nil;

  Inherited;
End; { Destroy }

(*
Procedure TTradeTCMSetupTill.AuthoriseProperty (Const PropertyIdx : TTCMSetupTillPropertyIndex; const PropName : ShortString);
Var
  bAuthorised : Boolean;
Begin { AuthoriseProperty }

  // Check for specific enablement of fields
  bAuthorised := FALSE;

  with TTradeEventData(oEventData) do begin

    // Authorise if appropriate
    case PropertyIdx of
      pIdxssCreateTransType : bAuthorised := HookIsTenderOnTender;
    end; { Case }

    If (Not bAuthorised) Then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      Raise ERightsError.Create (Format('Customisation Error in ITradeTCMSetupTill for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}
End; { AuthoriseProperty }

Procedure TTradeTCMSetupTill.Assign(EventData : TObject; ASetupRec : TEposSetupRec);
begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;
  lSetupRecord := ASetupRec;

  // Assign Sub Objects
//  FStockO.Assign(oEventData, Self);
//  FSerialsO.Assign(oEventData, Self);
//  FLocationO.Assign(oEventData, Self);
end; { Assign }

// Returns TRUE if any properties within the eventdata have been changed
Function TTradeTCMSetupTill.GetDataChanged : Boolean;
Begin { GetDataChanged }
  Result := FDataChanged;
End; { GetDataChanged }
*)
function TTradeTCMSetupTill.Get_ssAfterTender: TTradeAfterTender;
begin
  case lSetupRecord.AfterTender of
    0 : Result := atNewTransaction;
    1 : Result := atReturnToLogin;
  end;{case}
end;

function TTradeTCMSetupTill.Get_ssAllowDepositsOnCashCust: WordBool;
begin
  Result := not lSetupRecord.NoDepositsOnCashCust;
end;

function TTradeTCMSetupTill.Get_ssAllowModifyVATRate: WordBool;
begin
  Result := lSetupRecord.AllowModifyVATRate;
end;

function TTradeTCMSetupTill.Get_ssAutoAddLine: WordBool;
begin
  Result := lSetupRecord.AutoAddLine;
end;

function TTradeTCMSetupTill.Get_ssCashDrawer: ITradeTCMSetupCashDrawer;
begin
  Result := FCashDrawerI;
end;

function TTradeTCMSetupTill.Get_ssCashGLCode: Integer;
begin
  Result := lSetupRecord.MOPNomCodes[pbCash];
end;

function TTradeTCMSetupTill.Get_ssCashOnlyCustType: WideString;
begin
  Result := lSetupRecord.CashCustType;
end;

function TTradeTCMSetupTill.Get_ssCCDeptMode: TTradeCCDeptMode;
begin
  case lSetupRecord.CCDeptMode of
    0 : Result := ccCustomer;
    1 : Result := ccEnterpriseRules;
    2 : Result := ccSystemSetupDefaults;
  end;{case}
end;

function TTradeTCMSetupTill.Get_ssChequeGLCode: Integer;
begin
  Result := lSetupRecord.MOPNomCodes[pbCheque];
end;

function TTradeTCMSetupTill.Get_ssCompany: ITradeCompany;
begin
  Result := FCompanyI;
end;

function TTradeTCMSetupTill.Get_ssCompanyCode: WideString;
begin
  Result := lSetupRecord.TillCompany;
end;

function TTradeTCMSetupTill.Get_ssCostCentre: WideString;
begin
  Result := lSetupRecord.DefCostCentre;
end;

function TTradeTCMSetupTill.Get_ssCreateNegTransType: TTradeCreateNegTXType;
begin
  case lSetupRecord.NegativeTXType of
    0 : Result := cnSINSRI;
    1 : Result := cnSRFSCR;
  end;{case}
end;

function TTradeTCMSetupTill.Get_ssCreateTransType: TTradeCreateTXType;
begin
  case lSetupRecord.TransactionType of
    TX_SINs : Result := ctSINSRI;
    TX_PICKED_SORs : Result := ctPickedSOR;
    TX_UNPICKED_SORs : Result := ctUnpickedSOR;
  end;{case}
end;

function TTradeTCMSetupTill.Get_ssCreditCards: ITradeTCMSetupCreditCards;
begin
  Result := FCreditCardsI;
end;

function TTradeTCMSetupTill.Get_ssDefaultAccountCode: WideString;
begin
  Result := lSetupRecord.DefaultAccountCode;
end;

function TTradeTCMSetupTill.Get_ssDepartment: WideString;
begin
  Result := lSetupRecord.DefDepartment;
end;

function TTradeTCMSetupTill.Get_ssDiscountType: TTradeDiscountType;
begin
  case lSetupRecord.DiscountType of
    0 : Result := dtAdditionalTCMDiscounts;
    1 : Result := dtEnterpriseDiscounts;
  end;{case}
end;

function TTradeTCMSetupTill.Get_ssFilterSerialNoByLocation: WordBool;
begin
  Result := lSetupRecord.FilterSerialBinByLocation = 1;
end;

function TTradeTCMSetupTill.Get_ssLocation: ITradeLocation;
begin
  Result := FLocationI;
end;

function TTradeTCMSetupTill.Get_ssNonStockGLCode: Integer;
begin
  Result := lSetupRecord.DefNonStockNomCode;
end;

function TTradeTCMSetupTill.Get_ssNonStockItemCode: WideString;
begin
  Result := lSetupRecord.NonStockItemCode;
end;

function TTradeTCMSetupTill.Get_ssNonStockVATCode: WideString;
begin
  Result := lSetupRecord.NonStockVATCode;
end;

function TTradeTCMSetupTill.Get_ssPrinting: ITradeTCMSetupPrinting;
begin
  Result := FPrintingI;
end;

function TTradeTCMSetupTill.Get_ssRoundChange: WordBool;
begin
  Result := lSetupRecord.RoundChange;
end;

function TTradeTCMSetupTill.Get_ssRoundChangeTo: Double;
begin
  Result := lSetupRecord.RoundChangeTo;
end;

function TTradeTCMSetupTill.Get_ssSSDDeliveryTerms: WideString;
begin
  Result := lSetupRecord.DefSSDDeliveryTerms;
end;

function TTradeTCMSetupTill.Get_ssSSDModeOfTransport: Integer;
begin
  Result := lSetupRecord.DefSSDModeOfTrans;
end;

function TTradeTCMSetupTill.Get_ssStockLocation: WideString;
begin
  Result := lSetupRecord.DefStockLocation;
end;

function TTradeTCMSetupTill.Get_ssTakeNonStockDefaultFrom: TTradeTakeNonStockDefaultFrom;
begin
  case lSetupRecord.TakeNonStockDefaultFrom of
    0 : Result := nsSystemSetup;
    1 : Result := nsStockItem;
  end;{case}
end;

function TTradeTCMSetupTill.Get_ssTillCurrency: Integer;
begin
  Result := lSetupRecord.TillCurrency;
end;

function TTradeTCMSetupTill.Get_ssTillName: WideString;
begin
  Result := lsTillName;
end;

function TTradeTCMSetupTill.Get_ssTransactionTagNo: Integer;
begin
  Result := lSetupRecord.TransactionTagNo;
end;

function TTradeTCMSetupTill.Get_ssUseDefaultAccountCode: WordBool;
begin
  Result := lSetupRecord.UseDefAccCode = 1;
end;

function TTradeTCMSetupTill.Get_ssWriteOffGLCode: Integer;
begin
  Result := lSetupRecord.WriteOffNomCode;
end;
{
procedure TTradeTCMSetupTill.Set_ssCreateTransType(
  Value: TTradeCreateTXType);
begin
  // Check this property can be written to for this event
//  AuthoriseProperty(pIdxssCreateTransType, 'ssCreateTransType');

  // Set Value
  lSetupRecord.TransactionType := CustomSetInteger(lSetupRecord.TransactionType, Value, FDataChanged);
end;
}
end.
