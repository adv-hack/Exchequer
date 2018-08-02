unit zSetupJC;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMSetupCISRate = class(TAutoIntfObject, ICOMSetupCISRate)
  private
    FD5Setup   : TAbsCISRateSetup;
  protected
    function Get_cisrCode: WideString; safecall;
    function Get_cisrDescription: WideString; safecall;
    function Get_cisrRate: Double; safecall;
    function Get_cisrGLCode: Integer; safecall;
    function Get_cisrCostCentre: WideString; safecall;
    function Get_cisrDepartment: WideString; safecall;
  public
    Constructor Create(D5Setup : TAbsCISRateSetup);
  End; { TCOMSetupCISRate }

  //------------------------------

  TCOMSetupCISVoucherCounter = class(TAutoIntfObject, ICOMSetupCISVoucherCounter)
  private
    FD5Setup   : TAbsCISCounterSetup;
  protected
    function Get_cvPrefix: WideString; safecall;
    function Get_cvCounter: WideString; safecall;
  public
    Constructor Create(D5Setup : TAbsCISCounterSetup);
  End; { TCOMSetupCISVoucherCounter }

  //------------------------------

  TCOMSetupCIS = class(TAutoIntfObject, ICOMSetupCIS, ICOMSetupCIS2)
  private
    FCISRates    : Array [cuCISTaxType] Of ICOMSetupCISRate;
    FCISVouchers : Array [cuCISVoucherType] Of ICOMSetupCISVoucherCounter;

    FD5Setup   : TAbsCISSetup2;
  protected
    function Get_cisInterval: Integer; safecall;
    function Get_cisAutoSetPeriod: WordBool; safecall;
    function Get_cisReturnDate: WideString; safecall;
    function Get_cisTaxRef: WideString; safecall;
    function Get_cisDefaultVatCode: WideString; safecall;
    function Get_cisFolioNumber: Integer; safecall;
    function Get_cisVoucherCounter(VoucherType: TCISVoucherType): ICOMSetupCISVoucherCounter; safecall;
    function Get_cisRate(TaxType: TCISTaxType): ICOMSetupCISRate; safecall;

    // ICOMSetupCIS2
    function Get_cisContractorCertNo: WideString; safecall;
    function Get_cisContractorCertExpiry: WideString; safecall;
    function Get_cisContractorCertType: Integer; safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure InitSetup(D5Setup : TAbsCISSetup2);
  End; { TCOMSetupCIS }

  //------------------------------

  TCOMSetupJobCosting = class(TAutoIntfObject, ICOMSetupJobCosting)
  private
    FD5Setup   : TAbsJobCostingSetup;
  protected
    function Get_ssUsePPIsForTimeSheets: WordBool; safecall;
    function Get_ssSplitJobBudgetsByPeriod: WordBool; safecall;
    function Get_ssPPISupAccount: WideString; safecall;
    function Get_ssCheckJobBudget: WordBool; safecall;
    function Get_ssJobCategory(Index: TJobCategoryType): WideString; safecall;
    function Get_ssJobCostingGLCtrlCodes(Index: TJobGLCtrlType): Integer; safecall;
  public
    Constructor Create;

    Procedure InitSetup(D5Setup : TAbsJobCostingSetup);
  End; { TCOMSetupJobCosting }

  //------------------------------

implementation

uses ComServ, CustIntU;

//=========================================================================

Constructor TCOMSetupCISRate.Create(D5Setup : TAbsCISRateSetup);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMSetupCISRate);

  FD5Setup := Nil;
  FD5Setup := D5Setup;
End; { Create }

{-----------------------------------------}

function TCOMSetupCISRate.Get_cisrCode: WideString;
Begin
  Result := FD5Setup.cisrCode;
End;

//------------------------------

function TCOMSetupCISRate.Get_cisrDescription: WideString;
Begin
  Result := FD5Setup.cisrDescription;
End;

//------------------------------

function TCOMSetupCISRate.Get_cisrRate: Double;
Begin
  Result := FD5Setup.cisrRate;
End;

//------------------------------

function TCOMSetupCISRate.Get_cisrGLCode: Integer;
Begin
  Result := FD5Setup.cisrGLCode;
End;

//------------------------------

function TCOMSetupCISRate.Get_cisrCostCentre: WideString;
Begin
  Result := FD5Setup.cisrCostCentre;
End;

//------------------------------

function TCOMSetupCISRate.Get_cisrDepartment: WideString;
Begin
  Result := FD5Setup.cisrDepartment;
End;

//=========================================================================

Constructor TCOMSetupCISVoucherCounter.Create(D5Setup : TAbsCISCounterSetup);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMSetupCISVoucherCounter);

  FD5Setup := Nil;
  FD5Setup := D5Setup;
End; { Create }

//-------------------------------------------------------------------------

function TCOMSetupCISVoucherCounter.Get_cvPrefix: WideString;
Begin
  Result := FD5Setup.cvPrefix;
End;

//------------------------------

function TCOMSetupCISVoucherCounter.Get_cvCounter: WideString;
Begin
  Result := IntToStr(FD5Setup.cvCounter);
End;

//=========================================================================

Constructor TCOMSetupCIS.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMSetupCIS);

  FD5Setup := Nil;
End; { Create }

//------------------------------

Destructor TCOMSetupCIS.Destroy;
Begin { Destroy }
  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TCOMSetupCIS.InitSetup(D5Setup : TAbsCISSetup2);
Var
  oCISRate : TCOMSetupCISRate;
Begin { InitSetup }
  FD5Setup := D5Setup;

  FCISRates[CustAbsU.cisttConstruction] := TCOMSetupCISRate.Create(D5Setup.cisRate[CustAbsU.cisttConstruction]);
  FCISRates[CustAbsU.cisttTechnical] := TCOMSetupCISRate.Create(D5Setup.cisRate[CustAbsU.cisttTechnical]);

  FCISVouchers[CustAbsU.cvt23] := TCOMSetupCISVoucherCounter.Create (D5Setup.cisVoucherCounter[CustAbsU.cvt23]);
  FCISVouchers[CustAbsU.cvt24] := TCOMSetupCISVoucherCounter.Create (D5Setup.cisVoucherCounter[CustAbsU.cvt24]);
  FCISVouchers[CustAbsU.cvt25] := TCOMSetupCISVoucherCounter.Create (D5Setup.cisVoucherCounter[CustAbsU.cvt25]);
End; { InitSetup }

//-------------------------------------------------------------------------

function TCOMSetupCIS.Get_cisInterval: Integer;
Begin
  Result := FD5Setup.cisInterval;
End;

//------------------------------

function TCOMSetupCIS.Get_cisAutoSetPeriod: WordBool;
Begin
  Result := FD5Setup.cisAutoSetPeriod;
End;

//------------------------------

function TCOMSetupCIS.Get_cisReturnDate: WideString;
Begin
  Result := FD5Setup.cisReturnDate;
End;

//------------------------------

function TCOMSetupCIS.Get_cisTaxRef: WideString;
Begin
  Result := FD5Setup.cisTaxRef;
End;

//------------------------------

function TCOMSetupCIS.Get_cisDefaultVatCode: WideString;
Begin
  Result := FD5Setup.cisDefaultVatCode;
End;

//------------------------------

function TCOMSetupCIS.Get_cisFolioNumber: Integer;
Begin
  Result := FD5Setup.cisFolioNumber;
End;

//------------------------------

function TCOMSetupCIS.Get_cisContractorCertNo: WideString;
Begin
  Result := FD5Setup.cisContractorCertNo;
End;

//------------------------------

function TCOMSetupCIS.Get_cisContractorCertExpiry: WideString;
Begin
  Result := FD5Setup.cisContractorCertExpiry;
End;

//------------------------------

function TCOMSetupCIS.Get_cisContractorCertType: Integer;
Begin
  Result := FD5Setup.cisContractorCertType;
End;

//------------------------------

function TCOMSetupCIS.Get_cisVoucherCounter(VoucherType: TCISVoucherType): ICOMSetupCISVoucherCounter;
Begin
  Case VoucherType Of
    Enterprise_TLB.cvt23 : Result := FCISVouchers[CustAbsU.cvt23];
    Enterprise_TLB.cvt24 : Result := FCISVouchers[CustAbsU.cvt24];
    Enterprise_TLB.cvt25 : Result := FCISVouchers[CustAbsU.cvt25];
  Else
    Raise Exception.Create ('zSetupJC.TCOMSetupCIS.Get_cisVoucherCounter: VoucherType (' + IntToStr(Ord(VoucherType)) + ') Not Supported');
  End; { Case TaxType }
End;

//------------------------------

function TCOMSetupCIS.Get_cisRate(TaxType: TCISTaxType): ICOMSetupCISRate;
Begin
  Case TaxType Of
    Enterprise_TLB.cisttConstruction : Result := FCISRates[CustAbsU.cisttConstruction];
    Enterprise_TLB.cisttTechnical    : Result := FCISRates[CustAbsU.cisttTechnical];
  Else
    Raise Exception.Create ('zSetupJC.TCOMSetupCIS.Get_cisRate: TaxType (' + IntToStr(Ord(TaxType)) + ') Not Supported');
  End; { Case TaxType }
End;

//=========================================================================

Constructor TCOMSetupJobCosting.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMSetupJobCosting);

  FD5Setup := Nil;
End; { Create }

//-------------------------------------------------------------------------

Procedure TCOMSetupJobCosting.InitSetup(D5Setup : TAbsJobCostingSetup);
Begin { InitSetup }
  FD5Setup := D5Setup;
End; { InitSetup }

//-------------------------------------------------------------------------

function TCOMSetupJobCosting.Get_ssUsePPIsForTimeSheets: WordBool;
Begin
  Result := FD5Setup.ssUsePPIsForTimeSheets;
End;

//------------------------------

function TCOMSetupJobCosting.Get_ssSplitJobBudgetsByPeriod: WordBool;
Begin
  Result := FD5Setup.ssSplitJobBudgetsByPeriod;
End;

//------------------------------

function TCOMSetupJobCosting.Get_ssPPISupAccount: WideString;
Begin
  Result := FD5Setup.ssPPISupAccount;
End;

//------------------------------

function TCOMSetupJobCosting.Get_ssCheckJobBudget: WordBool;
Begin
  Result := FD5Setup.ssCheckJobBudget;
End;

//------------------------------

function TCOMSetupJobCosting.Get_ssJobCategory(Index: TJobCategoryType): WideString;
Begin
  Case Index Of
    Enterprise_TLB.jcRevenue        : Result := FD5Setup.ssJobCategory[CustAbsU.jcRevenue];
    Enterprise_TLB.jcLabour         : Result := FD5Setup.ssJobCategory[CustAbsU.jcLabour];
    Enterprise_TLB.jcDirectExpense1 : Result := FD5Setup.ssJobCategory[CustAbsU.jcDirectExpense1];
    Enterprise_TLB.jcDirectExpense2 : Result := FD5Setup.ssJobCategory[CustAbsU.jcDirectExpense2];
    Enterprise_TLB.jcStockIssues    : Result := FD5Setup.ssJobCategory[CustAbsU.jcStockIssues];
    Enterprise_TLB.jcOverheads      : Result := FD5Setup.ssJobCategory[CustAbsU.jcOverheads];
    Enterprise_TLB.jcReceipts       : Result := FD5Setup.ssJobCategory[CustAbsU.jcReceipts];
    Enterprise_TLB.jcWorkInProgress : Result := FD5Setup.ssJobCategory[CustAbsU.jcWorkInProgress];
    Enterprise_TLB.jcRetentionsSL   : Result := FD5Setup.ssJobCategory[CustAbsU.jcRetentionsSL];
    Enterprise_TLB.jcRetentionsPL   : Result := FD5Setup.ssJobCategory[CustAbsU.jcRetentionsPL];
    // 23/03/04: Extended for Apps & Vals Categories
    Enterprise_TLB.jcSubContractLabour    : Result := FD5Setup.ssJobCategory[CustAbsU.jcSubContractLabour];
    Enterprise_TLB.jcMaterials2           : Result := FD5Setup.ssJobCategory[CustAbsU.jcMaterials2];
    Enterprise_TLB.jcOverheads2           : Result := FD5Setup.ssJobCategory[CustAbsU.jcOverheads2];
    Enterprise_TLB.jcSalesDeductions      : Result := FD5Setup.ssJobCategory[CustAbsU.jcSalesDeductions];
    Enterprise_TLB.jcSalesApplications    : Result := FD5Setup.ssJobCategory[CustAbsU.jcSalesApplications];
    Enterprise_TLB.jcPurchaseApplications : Result := FD5Setup.ssJobCategory[CustAbsU.jcPurchaseApplications];
    Enterprise_TLB.jcPurchaseDeductions   : Result := FD5Setup.ssJobCategory[CustAbsU.jcPurchaseDeductions];
  Else
    Raise Exception.Create ('zSetupJC.TCOMSetupJobCosting.Get_ssJobCategory: Index (' + IntToStr(Ord(Index)) + ') Not Supported');
  End; { Case TaxType }
End;

//------------------------------

function TCOMSetupJobCosting.Get_ssJobCostingGLCtrlCodes(Index: TJobGLCtrlType): Integer;
Begin
  Case Index Of
    Enterprise_TLB.ssjGLOverhead    : Result := FD5Setup.ssJobCostingGLCtrlCodes[CustAbsU.ssjGLOverhead];
    Enterprise_TLB.ssjGLProdution   : Result := FD5Setup.ssJobCostingGLCtrlCodes[CustAbsU.ssjGLProdution];
    Enterprise_TLB.ssjGLSubContract : Result := FD5Setup.ssJobCostingGLCtrlCodes[CustAbsU.ssjGLSubContract];
  Else
    Raise Exception.Create ('zSetupJC.TCOMSetupJobCosting.Get_ssJobCostingGLCtrlCodes: Index (' + IntToStr(Ord(Index)) + ') Not Supported');
  End; { Case TaxType }
End;

//=========================================================================

end.
