unit ZLine;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMTransactionLine = class(TAutoIntfObject, ICOMTransactionLine,
                                               ICOMTransactionLine2,
                                               ICOMTransactionLine3,
                                               ICOMTransactionLine4,
                                               ICOMTransactionLine5,
                                               ICOMTransactionLine6,
                                               ICOMTransactionLine7,
                                               ICOMTransactionLine8,
                                               ICOMTransactionLine9,
                                               ICOMTransactionLine10)
  private
    FEntSysObj : TEnterpriseSystem;
    FLineObj : TAbsInvLine10;
  protected
    function  Get_AccessRights: TRecordAccessStatus; safecall;
    function  Get_DataChanged: WordBool; safecall;
    function  Get_tlFolio: Integer; safecall;
    procedure Set_tlFolio(Value: Integer); safecall;
    function  Get_tlLinePos: Integer; safecall;
    procedure Set_tlLinePos(Value: Integer); safecall;
    function  Get_tlRunNo: Integer; safecall;
    procedure Set_tlRunNo(Value: Integer); safecall;
    function  Get_tlGLCode: Integer; safecall;
    procedure Set_tlGLCode(Value: Integer); safecall;
    function  Get_tlShowInGL: Smallint; safecall;
    procedure Set_tlShowInGL(Value: Smallint); safecall;
    function  Get_tlCurrency: TCurrencyType; safecall;
    procedure Set_tlCurrency(Value: TCurrencyType); safecall;
    function  Get_tlYear: Smallint; safecall;
    function  Get_tlPeriod: Smallint; safecall;
    function  Get_tlCostCentre: WideString; safecall;
    procedure Set_tlCostCentre(const Value: WideString); safecall;
    function  Get_tlDepartment: WideString; safecall;
    procedure Set_tlDepartment(const Value: WideString); safecall;
    function  Get_tlStockCode: WideString; safecall;
    procedure Set_tlStockCode(const Value: WideString); safecall;
    function  Get_tlLineNo: Integer; safecall;
    procedure Set_tlLineNo(Value: Integer); safecall;
    function  Get_tlLineClass: WideString; safecall;
    function  Get_tlDocType: TDocTypes; safecall;
    function  Get_tlQty: Double; safecall;
    procedure Set_tlQty(Value: Double); safecall;
    function  Get_tlQtyMul: Double; safecall;
    procedure Set_tlQtyMul(Value: Double); safecall;
    function  Get_tlNetValue: Double; safecall;
    procedure Set_tlNetValue(Value: Double); safecall;
    function  Get_tlDiscount: Double; safecall;
    procedure Set_tlDiscount(Value: Double); safecall;
    function  Get_tlVATCode: WideString; safecall;
    procedure Set_tlVATCode(const Value: WideString); safecall;
    function  Get_tlVATAmount: Double; safecall;
    procedure Set_tlVATAmount(Value: Double); safecall;
    function  Get_tlPayStatus: WideString; safecall;
    procedure Set_tlPayStatus(const Value: WideString); safecall;
    function  Get_tlPrevGLBal: Double; safecall;
    procedure Set_tlPrevGLBal(Value: Double); safecall;
    function  Get_tlRecStatus: Smallint; safecall;
    procedure Set_tlRecStatus(Value: Smallint); safecall;
    function  Get_tlDiscFlag: WideString; safecall;
    procedure Set_tlDiscFlag(const Value: WideString); safecall;
    function  Get_tlQtyWOFF: Double; safecall;
    procedure Set_tlQtyWOFF(Value: Double); safecall;
    function  Get_tlQtyDel: Double; safecall;
    procedure Set_tlQtyDel(Value: Double); safecall;
    function  Get_tlCost: Double; safecall;
    procedure Set_tlCost(Value: Double); safecall;
    function  Get_tlAcCode: WideString; safecall;
    function  Get_tlTransDate: WideString; safecall;
    procedure Set_tlTransDate(const Value: WideString); safecall;
    function  Get_tlItemNo: WideString; safecall;
    procedure Set_tlItemNo(const Value: WideString); safecall;
    function  Get_tlDescr: WideString; safecall;
    procedure Set_tlDescr(const Value: WideString); safecall;
    function  Get_tlJobCode: WideString; safecall;
    procedure Set_tlJobCode(const Value: WideString); safecall;
    function  Get_tlJobAnal: WideString; safecall;
    procedure Set_tlJobAnal(const Value: WideString); safecall;
    function  Get_tlCompanyRate: Double; safecall;
    procedure Set_tlCompanyRate(Value: Double); safecall;
    function  Get_tlDailyRate: Double; safecall;
    procedure Set_tlDailyRate(Value: Double); safecall;
    function  Get_tlUnitWeight: Double; safecall;
    procedure Set_tlUnitWeight(Value: Double); safecall;
    function  Get_tlStockDeductQty: Double; safecall;
    procedure Set_tlStockDeductQty(Value: Double); safecall;
    function  Get_tlBOMKitLink: Integer; safecall;
    procedure Set_tlBOMKitLink(Value: Integer); safecall;
    function  Get_tlOrderFolio: Integer; safecall;
    procedure Set_tlOrderFolio(Value: Integer); safecall;
    function  Get_tlOrderLineNo: Integer; safecall;
    procedure Set_tlOrderLineNo(Value: Integer); safecall;
    function  Get_tlLocation: WideString; safecall;
    procedure Set_tlLocation(const Value: WideString); safecall;
    function  Get_tlQtyPicked: Double; safecall;
    procedure Set_tlQtyPicked(Value: Double); safecall;
    function  Get_tlQtyPickedWO: Double; safecall;
    procedure Set_tlQtyPickedWO(Value: Double); safecall;
    function  Get_tlUseQtyMul: WordBool; safecall;
    procedure Set_tlUseQtyMul(Value: WordBool); safecall;
    function  Get_tlNoSerialNos: Double; safecall;
    procedure Set_tlNoSerialNos(Value: Double); safecall;
    function  Get_tlCOSGL: Integer; safecall;
    procedure Set_tlCOSGL(Value: Integer); safecall;
    function  Get_tlOurRef: WideString; safecall;
    function  Get_tlLineType: Integer; safecall;
    procedure Set_tlLineType(Value: Integer); safecall;
    function  Get_tlPriceByPack: WordBool; safecall;
    procedure Set_tlPriceByPack(Value: WordBool); safecall;
    function  Get_tlQtyInPack: Double; safecall;
    procedure Set_tlQtyInPack(Value: Double); safecall;
    function  Get_tlClearDate: WideString; safecall;
    procedure Set_tlClearDate(const Value: WideString); safecall;
    function  Get_tlUserDef1: WideString; safecall;
    procedure Set_tlUserDef1(const Value: WideString); safecall;
    function  Get_tlUserDef2: WideString; safecall;
    procedure Set_tlUserDef2(const Value: WideString); safecall;
    function  Get_tlUserDef3: WideString; safecall;
    procedure Set_tlUserDef3(const Value: WideString); safecall;
    function  Get_tlUserDef4: WideString; safecall;
    procedure Set_tlUserDef4(const Value: WideString); safecall;
    function  entInvLTotal(UseDisc: WordBool; SetlDisc: Double): Double; safecall;
    procedure Delete; safecall;
    procedure Save; safecall;
    function  LinkToStock: WordBool; safecall;

    // ICOMTransactionLine2
    function Get_tlLineSource: Integer; safecall;
    procedure Set_tlLineSource(Value: Integer); safecall;
    function Get_tlCISRateCode: WideString; safecall;
    procedure Set_tlCISRateCode(const Value: WideString); safecall;
    function Get_tlCISRate: Double; safecall;
    procedure Set_tlCISRate(Value: Double); safecall;
    function Get_tlCostApport: Double; safecall;
    procedure Set_tlCostApport(Value: Double); safecall;
    function Get_tlVATInclValue: Double; safecall;
    procedure Set_tlVATInclValue(Value: Double); safecall;

    // HM 04/06/03 - ICOMTransactionLine3
    function Get_tlNOMVATType: TNOMLineVATType; safecall;
    procedure Set_tlNOMVATType(Value: TNOMLineVATType); safecall;

    // HM 23/03/04 - ICOMTransactionLine4
    function Get_tlCISAdjustments: Double; safecall;
    procedure Set_tlCISAdjustments(Value: Double); safecall;
    function Get_tlAppsDeductType: Integer; safecall;
    procedure Set_tlAppsDeductType(Value: Integer); safecall;

    // HM 27/07/05 - ICOMTransactionLine4
    function Get_tlSerialReturnQty: Double; safecall;
    procedure Set_tlSerialReturnQty(Value: Double); safecall;
    function Get_tlBinReturnQty: Double; safecall;
    procedure Set_tlBinReturnQty(Value: Double); safecall;

    // v6.01 - 08/05/09 - Added ICOMTransactionLine6 as a wrapper around TAbsInvLine6 for Advanced Discounts fields
    function Get_tlMultiBuyDiscount: Double; safecall;
    procedure Set_tlMultiBuyDiscount(Value: Double); safecall;
    function Get_tlMultiBuyDiscountFlag: WideString; safecall;
    procedure Set_tlMultiBuyDiscountFlag(const Value: WideString); safecall;
    function Get_tlTransValueDiscount: Double; safecall;
    procedure Set_tlTransValueDiscount(Value: Double); safecall;
    function Get_tlTransValueDiscountFlag: WideString; safecall;
    procedure Set_tlTransValueDiscountFlag(const Value: WideString); safecall;
    function Get_tlTransValueDiscountType: Smallint; safecall;
    procedure Set_tlTransValueDiscountType(Value: Smallint); safecall;
    function entCalcLineDiscount(SettlementDiscount: Double; const SettlementDiscountType: WideString): Double; safecall;

    // v6.2 - 20/08/09 - Added new fields for EC Services support
    function Get_tlECService: WordBool; safecall;
    procedure Set_tlECService(Value: WordBool); safecall;
    function Get_tlServiceStartDate: WideString; safecall;
    procedure Set_tlServiceStartDate(const Value: WideString); safecall;
    function Get_tlServiceEndDate: WideString; safecall;
    procedure Set_tlServiceEndDate(const Value: WideString); safecall;
    function Get_tlECSalesTaxReported: Double; safecall;
    procedure Set_tlECSalesTaxReported(Value: Double); safecall;
    function Get_tlPurchaseServiceTax: Double; safecall;
    procedure Set_tlPurchaseServiceTax(Value: Double); safecall;

    // v6.3 - 02/02/10 - Added new fields for Web Extensions support
    function Get_tlReference: WideString; safecall;
    procedure Set_tlReference(const Value: WideString); safecall;
    function Get_tlReceiptNo: WideString; safecall;
    procedure Set_tlReceiptNo(const Value: WideString); safecall;
    function Get_tlFromPostCode: WideString; safecall;
    procedure Set_tlFromPostCode(const Value: WideString); safecall;
    function Get_tlToPostCode: WideString; safecall;
    procedure Set_tlToPostCode(const Value: WideString); safecall;

    //v6.9 07/10/2011 ICOMTransactionLine9 New User Defined Fields
    function Get_tlUserDef5: WideString; safecall;
    procedure Set_tlUserDef5(const Value: WideString); safecall;
    function Get_tlUserDef6: WideString; safecall;
    procedure Set_tlUserDef6(const Value: WideString); safecall;
    function Get_tlUserDef7: WideString; safecall;
    procedure Set_tlUserDef7(const Value: WideString); safecall;
    function Get_tlUserDef8: WideString; safecall;
    procedure Set_tlUserDef8(const Value: WideString); safecall;
    function Get_tlUserDef9: WideString; safecall;
    procedure Set_tlUserDef9(const Value: WideString); safecall;
    function Get_tlUserDef10: WideString; safecall;
    procedure Set_tlUserDef10(const Value: WideString); safecall;

    // MH 20/01/2016 Exch2016-R1: Intrastat enhancements - ICOMTransactionLine10
    function Get_tlIntrastatOverride: WordBool; safecall;
    procedure Set_tlIntrastatOverride(Value: WordBool); safecall;
    function Get_tlIntrastatCommodityCode: WideString; safecall;
    procedure Set_tlIntrastatCommodityCode(const Value: WideString); safecall;
    function Get_tlIntrastatStockUnits: Double; safecall;
    procedure Set_tlIntrastatStockUnits(Value: Double); safecall;
    function Get_tlIntrastatCountry: WideString; safecall;
    procedure Set_tlIntrastatCountry(const Value: WideString); safecall;
    function Get_tlIntrastatNoTC: WideString; safecall;
    procedure Set_tlIntrastatNoTC(const Value: WideString); safecall;
    function Get_tlIntrastatUplift: Double; safecall;
    procedure Set_tlIntrastatUplift(Value: Double); safecall;
  public
    Constructor Create;

    Procedure InitLine(EntSysObj : TEnterpriseSystem; LineObj : TAbsInvLine);
  End; { TCOMTransactionLine }

implementation

uses ComServ, CustIntU, ZUtils;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMTransactionLine.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMTransactionLine10);

End; { Create }

{-----------------------------------------}

Procedure TCOMTransactionLine.InitLine(EntSysObj : TEnterpriseSystem; LineObj : TAbsInvLine);
Begin { InitLine }
  FEntSysObj := EntSysObj;
  FLineObj := LineObj As TAbsInvLine10;
End; { InitLine }

{-----------------------------------------}

function TCOMTransactionLine.Get_AccessRights: TRecordAccessStatus;
Begin { Get_AccessRights }
  Result := Ord(FLineObj.AccessRights);
End; { Get_AccessRights }

{-----------------------------------------}

function TCOMTransactionLine.Get_DataChanged: WordBool;
Begin { Get_DataChanged }
  Result := FLineObj.DataChanged;
End; { Get_DataChanged }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlFolio: Integer;
Begin { Get_tlFolio }
  Result := FLineObj.tlFolio;
End; { Get_tlFolio }

procedure TCOMTransactionLine.Set_tlFolio(Value: Integer);
Begin { Set_tlFolio }
  FLineObj.tlFolio := Value;
End; { Set_tlFolio }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlLinePos: Integer;
Begin { Get_tlLinePos }
  Result := FLineObj.tlLinePos;
End; { Get_tlLinePos }

procedure TCOMTransactionLine.Set_tlLinePos(Value: Integer);
Begin { Set_tlLinePos }
  FLineObj.tlLinePos := Value;
End; { Set_tlLinePos }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlRunNo: Integer;
Begin { Get_tlRunNo }
  Result := FLineObj.tlRunNo;
End; { Get_tlRunNo }

procedure TCOMTransactionLine.Set_tlRunNo(Value: Integer);
Begin { Set_tlRunNo }
  FLineObj.tlRunNo := Value;
End; { Set_tlRunNo }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlGLCode: Integer;
Begin { Get_tlGLCode }
  Result := FLineObj.tlGLCode;
End; { Get_tlGLCode }

procedure TCOMTransactionLine.Set_tlGLCode(Value: Integer);
Begin { Set_tlGLCode }
  FLineObj.tlGLCode := Value;
End; { Set_tlGLCode }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlShowInGL: SmallInt;
Begin { Get_tlShowInGL }
  Result := FLineObj.tlShowInGL;
End; { Get_tlShowInGL }

procedure TCOMTransactionLine.Set_tlShowInGL(Value: SmallInt);
Begin { Set_tlShowInGL }
  FLineObj.tlShowInGL := Value;
End; { Set_tlShowInGL }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlCurrency: TCurrencyType;
Begin { Get_tlCurrency }
  Result := FLineObj.tlCurrency;
End; { Get_tlCurrency }

procedure TCOMTransactionLine.Set_tlCurrency(Value: TCurrencyType);
Begin { Set_tlCurrency }
  FLineObj.tlCurrency := Value;
End; { Set_tlCurrency }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlYear: SmallInt;
Begin { Get_tlYear }
  Result := FLineObj.tlYear;
End; { Get_tlYear }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlPeriod: SmallInt;
Begin { Get_tlPeriod }
  Result := FLineObj.tlPeriod;
End; { Get_tlPeriod }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlCostCentre: WideString;
Begin { Get_tlCostCentre }
  Result := FLineObj.tlCostCentre;
End; { Get_tlCostCentre }

procedure TCOMTransactionLine.Set_tlCostCentre(const Value: WideString);
Begin { Set_tlCostCentre }
  FLineObj.tlCostCentre := Value;
End; { Set_tlCostCentre }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlDepartment: WideString;
Begin { Get_tlDepartment }
  Result := FLineObj.tlDepartment;
End; { Get_tlDepartment }

procedure TCOMTransactionLine.Set_tlDepartment(const Value: WideString);
Begin { Set_tlDepartment }
  FLineObj.tlDepartment := Value;
End; { Set_tlDepartment }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlStockCode: WideString;
Begin { Get_tlStockCode }
  Result := FLineObj.tlStockCode;
End; { Get_tlStockCode }

procedure TCOMTransactionLine.Set_tlStockCode(const Value: WideString);
Begin { Set_tlStockCode }
  FLineObj.tlStockCode := Value;
End; { Set_tlStockCode }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlLineNo: Integer;
Begin { Get_tlLineNo }
  Result := FLineObj.tlLineNo;
End; { Get_tlLineNo }

procedure TCOMTransactionLine.Set_tlLineNo(Value: Integer);
Begin { Set_tlLineNo }
  FLineObj.tlLineNo := Value;
End; { Set_tlLineNo }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlLineClass: WideString;
Begin { Get_tlLineClass }
  Result := FLineObj.tlLineClass;
End; { Get_tlLineClass }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlDocType: TDocTypes;
Begin { Get_tlDocType }
  Result := Ord(FLineObj.tlDocType);
End; { Get_tlDocType }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlQty: Double;
Begin { Get_tlQty }
  Result := FLineObj.tlQty;
End; { Get_tlQty }

procedure TCOMTransactionLine.Set_tlQty(Value: Double);
Begin { Set_tlQty }
  FLineObj.tlQty := Value;
End; { Set_tlQty }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlQtyMul: Double;
Begin { Get_tlQtyMul }
  Result := FLineObj.tlQtyMul;
End; { Get_tlQtyMul }

procedure TCOMTransactionLine.Set_tlQtyMul(Value: Double);
Begin { Set_tlQtyMul }
  FLineObj.tlQtyMul := Value;
End; { Set_tlQtyMul }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlNetValue: Double;
Begin { Get_tlNetValue }
  Result := FLineObj.tlNetValue;
End; { Get_tlNetValue }

procedure TCOMTransactionLine.Set_tlNetValue(Value: Double);
Begin { Set_tlNetValue }
  FLineObj.tlNetValue := Value;
End; { Set_tlNetValue }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlDiscount: Double;
Begin { Get_tlDiscount }
  Result := FLineObj.tlDiscount;
End; { Get_tlDiscount }

procedure TCOMTransactionLine.Set_tlDiscount(Value: Double);
Begin { Set_tlDiscount }
  FLineObj.tlDiscount := Value;
End; { Set_tlDiscount }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlVATCode: WideString;
Begin { Get_tlVATCode }
  Result := FLineObj.tlVATCode;
End; { Get_tlVATCode }

procedure TCOMTransactionLine.Set_tlVATCode(const Value: WideString);
Begin { Set_tlVATCode }
  FLineObj.tlVATCode := WideStrToChar (Value, ' ');
End; { Set_tlVATCode }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlVATAmount: Double;
Begin { Get_tlVATAmount }
  Result := FLineObj.tlVATAmount;
End; { Get_tlVATAmount }

procedure TCOMTransactionLine.Set_tlVATAmount(Value: Double);
Begin { Set_tlVATAmount }
  FLineObj.tlVATAmount := Value;
End; { Set_tlVATAmount }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlPayStatus: WideString;
Begin { Get_tlPayStatus }
  Result := FLineObj.tlPayStatus;
End; { Get_tlPayStatus }

procedure TCOMTransactionLine.Set_tlPayStatus(const Value: WideString);
Begin { Set_tlPayStatus }
  FLineObj.tlPayStatus := WideStrToChar (Value, ' ');
End; { Set_tlPayStatus }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlPrevGLBal: Double;
Begin { Get_tlPrevGLBal }
  Result := FLineObj.tlPrevGLBal;
End; { Get_tlPrevGLBal }

procedure TCOMTransactionLine.Set_tlPrevGLBal(Value: Double);
Begin { Set_tlPrevGLBal }
  FLineObj.tlPrevGLBal := Value;
End; { Set_tlPrevGLBal }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlRecStatus: SmallInt;
Begin { Get_tlRecStatus }
  Result := FLineObj.tlRecStatus;
End; { Get_tlRecStatus }

procedure TCOMTransactionLine.Set_tlRecStatus(Value: SmallInt);
Begin { Set_tlRecStatus }
  FLineObj.tlRecStatus := Value;
End; { Set_tlRecStatus }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlDiscFlag: WideString;
Begin { Get_tlDiscFlag }
  Result := FLineObj.tlDiscFlag;
End; { Get_tlDiscFlag }

procedure TCOMTransactionLine.Set_tlDiscFlag(const Value: WideString);
Begin { Set_tlDiscFlag }
  FLineObj.tlDiscFlag := WideStrToChar (Value, ' ');
End; { Set_tlDiscFlag }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlQtyWOFF: Double;
Begin { Get_tlQtyWOFF }
  Result := FLineObj.tlQtyWOFF;
End; { Get_tlQtyWOFF }

procedure TCOMTransactionLine.Set_tlQtyWOFF(Value: Double);
Begin { Set_tlQtyWOFF }
  FLineObj.tlQtyWOFF := Value;
End; { Set_tlQtyWOFF }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlQtyDel: Double;
Begin { Get_tlQtyDel }
  Result := FLineObj.tlQtyDel;
End; { Get_tlQtyDel }

procedure TCOMTransactionLine.Set_tlQtyDel(Value: Double);
Begin { Set_tlQtyDel }
  FLineObj.tlQtyDel := Value;
End; { Set_tlQtyDel }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlCost: Double;
Begin { Get_tlCost }
  Result := FLineObj.tlCost;
End; { Get_tlCost }

procedure TCOMTransactionLine.Set_tlCost(Value: Double);
Begin { Set_tlCost }
  FLineObj.tlCost := Value;
End; { Set_tlCost }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlAcCode: WideString;
Begin { Get_tlAcCode }
  Result := FLineObj.tlAcCode;
End; { Get_tlAcCode }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlTransDate: WideString;
Begin { Get_tlTransDate }
  Result := FLineObj.tlTransDate;
End; { Get_tlTransDate }

procedure TCOMTransactionLine.Set_tlTransDate(const Value: WideString);
Begin { Set_tlTransDate }
  FLineObj.tlTransDate := Value;
End; { Set_tlTransDate }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlItemNo: WideString;
Begin { Get_tlItemNo }
  Result := FLineObj.tlItemNo;
End; { Get_tlItemNo }

procedure TCOMTransactionLine.Set_tlItemNo(const Value: WideString);
Begin { Set_tlItemNo }
  FLineObj.tlItemNo := Value;
End; { Set_tlItemNo }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlDescr: WideString;
Begin { Get_tlDescr }
  Result := FLineObj.tlDescr;
End; { Get_tlDescr }

procedure TCOMTransactionLine.Set_tlDescr(const Value: WideString);
Begin { Set_tlDescr }
  FLineObj.tlDescr := Value;
End; { Set_tlDescr }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlJobCode: WideString;
Begin { Get_tlJobCode }
  Result := FLineObj.tlJobCode;
End; { Get_tlJobCode }

procedure TCOMTransactionLine.Set_tlJobCode(const Value: WideString);
Begin { Set_tlJobCode }
  FLineObj.tlJobCode := Value;
End; { Set_tlJobCode }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlJobAnal: WideString;
Begin { Get_tlJobAnal }
  Result := FLineObj.tlJobAnal;
End; { Get_tlJobAnal }

procedure TCOMTransactionLine.Set_tlJobAnal(const Value: WideString);
Begin { Set_tlJobAnal }
  FLineObj.tlJobAnal := Value;
End; { Set_tlJobAnal }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlCompanyRate: Double;
Begin { Get_tlCompanyRate }
  Result := FLineObj.tlCompanyRate;
End; { Get_tlCompanyRate }

procedure TCOMTransactionLine.Set_tlCompanyRate(Value: Double);
Begin { Set_tlCompanyRate }
  FLineObj.tlCompanyRate := Value;
End; { Set_tlCompanyRate }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlDailyRate: Double;
Begin { Get_tlDailyRate }
  Result := FLineObj.tlDailyRate;
End; { Get_tlDailyRate }

procedure TCOMTransactionLine.Set_tlDailyRate(Value: Double);
Begin { Set_tlDailyRate }
  FLineObj.tlDailyRate := Value;
End; { Set_tlDailyRate }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlUnitWeight: Double;
Begin { Get_tlUnitWeight }
  Result := FLineObj.tlUnitWeight;
End; { Get_tlUnitWeight }

procedure TCOMTransactionLine.Set_tlUnitWeight(Value: Double);
Begin { Set_tlUnitWeight }
  FLineObj.tlUnitWeight := Value;
End; { Set_tlUnitWeight }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlStockDeductQty: Double;
Begin { Get_tlStockDeductQty }
  Result := FLineObj.tlStockDeductQty;
End; { Get_tlStockDeductQty }

procedure TCOMTransactionLine.Set_tlStockDeductQty(Value: Double);
Begin { Set_tlStockDeductQty }
  FLineObj.tlStockDeductQty := Value;
End; { Set_tlStockDeductQty }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlBOMKitLink: Integer;
Begin { Get_tlBOMKitLink }
  Result := FLineObj.tlBOMKitLink;
End; { Get_tlBOMKitLink }

procedure TCOMTransactionLine.Set_tlBOMKitLink(Value: Integer);
Begin { Set_tlBOMKitLink }
  FLineObj.tlBOMKitLink := Value;
End; { Set_tlBOMKitLink }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlOrderFolio: Integer;
Begin { Get_tlOrderFolio }
  Result := FLineObj.tlOrderFolio;
End; { Get_tlOrderFolio }

procedure TCOMTransactionLine.Set_tlOrderFolio(Value: Integer);
Begin { Set_tlOrderFolio }
  FLineObj.tlOrderFolio := Value;
End; { Set_tlOrderFolio }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlOrderLineNo: Integer;
Begin { Get_tlOrderLineNo }
  Result := FLineObj.tlOrderLineNo;
End; { Get_tlOrderLineNo }

procedure TCOMTransactionLine.Set_tlOrderLineNo(Value: Integer);
Begin { Set_tlOrderLineNo }
  FLineObj.tlOrderLineNo := Value;
End; { Set_tlOrderLineNo }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlLocation: WideString;
Begin { Get_tlLocation }
  Result := FLineObj.tlLocation;
End; { Get_tlLocation }

procedure TCOMTransactionLine.Set_tlLocation(const Value: WideString);
Begin { Set_tlLocation }
  FLineObj.tlLocation := Value;
End; { Set_tlLocation }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlQtyPicked: Double;
Begin { Get_tlQtyPicked }
  Result := FLineObj.tlQtyPicked;
End; { Get_tlQtyPicked }

procedure TCOMTransactionLine.Set_tlQtyPicked(Value: Double);
Begin { Set_tlQtyPicked }
  FLineObj.tlQtyPicked := Value;
End; { Set_tlQtyPicked }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlQtyPickedWO: Double;
Begin { Get_tlQtyPickedWO }
  Result := FLineObj.tlQtyPickedWO;
End; { Get_tlQtyPickedWO }

procedure TCOMTransactionLine.Set_tlQtyPickedWO(Value: Double);
Begin { Set_tlQtyPickedWO }
  FLineObj.tlQtyPickedWO := Value;
End; { Set_tlQtyPickedWO }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlUseQtyMul: WordBool;
Begin { Get_tlUseQtyMul }
  Result := FLineObj.tlUseQtyMul;
End; { Get_tlUseQtyMul }

procedure TCOMTransactionLine.Set_tlUseQtyMul(Value: WordBool);
Begin { Set_tlUseQtyMul }
  FLineObj.tlUseQtyMul := Value;
End; { Set_tlUseQtyMul }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlNoSerialNos: Double;
Begin { Get_tlNoSerialNos }
  Result := FLineObj.tlNoSerialNos;
End; { Get_tlNoSerialNos }

procedure TCOMTransactionLine.Set_tlNoSerialNos(Value: Double);
Begin { Set_tlNoSerialNos }
  FLineObj.tlNoSerialNos := Value;
End; { Set_tlNoSerialNos }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlCOSGL: Integer;
Begin { Get_tlCOSGL }
  Result := FLineObj.tlCOSGL;
End; { Get_tlCOSGL }

procedure TCOMTransactionLine.Set_tlCOSGL(Value: Integer);
Begin { Set_tlCOSGL }
  FLineObj.tlCOSGL := Value;
End; { Set_tlCOSGL }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlOurRef: WideString;
Begin { Get_tlOurRef }
  Result := FLineObj.tlOurRef;
End; { Get_tlOurRef }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlLineType: Integer;
Begin { Get_tlLineType }
  Result := FLineObj.tlLineType;
End; { Get_tlLineType }

procedure TCOMTransactionLine.Set_tlLineType(Value: Integer);
Begin { Set_tlLineType }
  FLineObj.tlLineType := Value;
End; { Set_tlLineType }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlPriceByPack: WordBool;
Begin { Get_tlPriceByPack }
  Result := FLineObj.tlPriceByPack;
End; { Get_tlPriceByPack }

procedure TCOMTransactionLine.Set_tlPriceByPack(Value: WordBool);
Begin { Set_tlPriceByPack }
  FLineObj.tlPriceByPack := Value;
End; { Set_tlPriceByPack }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlQtyInPack: Double;
Begin { Get_tlQtyInPack }
  Result := FLineObj.tlQtyInPack;
End; { Get_tlQtyInPack }

procedure TCOMTransactionLine.Set_tlQtyInPack(Value: Double);
Begin { Set_tlQtyInPack }
  FLineObj.tlQtyInPack := Value;
End; { Set_tlQtyInPack }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlClearDate: WideString;
Begin { Get_tlClearDate }
  Result := FLineObj.tlClearDate;
End; { Get_tlClearDate }

procedure TCOMTransactionLine.Set_tlClearDate(const Value: WideString);
Begin { Set_tlClearDate }
  FLineObj.tlClearDate := Value;
End; { Set_tlClearDate }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlUserDef1: WideString;
Begin { Get_tlUserDef1 }
  Result := FLineObj.tlUserDef1;
End; { Get_tlUserDef1 }

procedure TCOMTransactionLine.Set_tlUserDef1(const Value: WideString);
Begin { Set_tlUserDef1 }
  FLineObj.tlUserDef1 := Value;
End; { Set_tlUserDef1 }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlUserDef2: WideString;
Begin { Get_tlUserDef2 }
  Result := FLineObj.tlUserDef2;
End; { Get_tlUserDef2 }

procedure TCOMTransactionLine.Set_tlUserDef2(const Value: WideString);
Begin { Set_tlUserDef2 }
  FLineObj.tlUserDef2 := Value;
End; { Set_tlUserDef2 }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlUserDef3: WideString;
Begin { Get_tlUserDef3 }
  Result := FLineObj.tlUserDef3;
End; { Get_tlUserDef3 }

procedure TCOMTransactionLine.Set_tlUserDef3(const Value: WideString);
Begin { Set_tlUserDef3 }
  FLineObj.tlUserDef3 := Value;
End; { Set_tlUserDef3 }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlUserDef4: WideString;
Begin { Get_tlUserDef4 }
  Result := FLineObj.tlUserDef4;
End; { Get_tlUserDef4 }

procedure TCOMTransactionLine.Set_tlUserDef4(const Value: WideString);
Begin { Set_tlUserDef4 }
  FLineObj.tlUserDef4 := Value;
End; { Set_tlUserDef4 }

{-----------------------------------------}

function TCOMTransactionLine.entInvLTotal(UseDisc: WordBool; SetlDisc: Double): Double;
Begin { entInvLTotal }
  Result := FLineObj.entInvLTotal(UseDisc, SetlDisc);
End; { entInvLTotal }

{-----------------------------------------}

procedure TCOMTransactionLine.Delete;
Begin { Delete }
  FLineObj.Delete;
End; { Delete }

{-----------------------------------------}

procedure TCOMTransactionLine.Save;
Begin { Save }
  FLineObj.Save;
End; { Save }

{-----------------------------------------}

function TCOMTransactionLine.LinkToStock: WordBool;
Begin { LinkToStock }
  Result := FLineObj.LinkToStock;
End; { LinkToStock }

{-----------------------------------------}

function TCOMTransactionLine.Get_tlLineSource: Integer;
Begin
  Result := FLineObj.tlLineSource;
End;

procedure TCOMTransactionLine.Set_tlLineSource(Value: Integer);
Begin
  FLineObj.tlLineSource := Value;
End;

//------------------------------

function TCOMTransactionLine.Get_tlCISRateCode: WideString;
Begin
  Result := FLineObj.tlCISRateCode;
End;

procedure TCOMTransactionLine.Set_tlCISRateCode(const Value: WideString);
Begin
  FLineObj.tlCISRateCode := WideStrToChar (Value, ' ');
End;

//------------------------------

function TCOMTransactionLine.Get_tlCISRate: Double;
Begin
  Result := FLineObj.tlCISRate;
End;

procedure TCOMTransactionLine.Set_tlCISRate(Value: Double);
Begin
  FLineObj.tlCISRate := Value;
End;

//------------------------------

function TCOMTransactionLine.Get_tlCostApport: Double;
Begin
  Result := FLineObj.tlCostApport;
End;

procedure TCOMTransactionLine.Set_tlCostApport(Value: Double);
Begin
  FLineObj.tlCostApport := Value;
End;

//------------------------------

function TCOMTransactionLine.Get_tlVATInclValue: Double;
Begin
  Result := FLineObj.tlVATInclValue;
End;

procedure TCOMTransactionLine.Set_tlVATInclValue(Value: Double);
Begin
  FLineObj.tlVATInclValue := Value;
End;

//------------------------------

function TCOMTransactionLine.Get_tlNOMVATType: TNOMLineVATType;
Begin
  // Convert between DLL and COM enumerated types
  Case FLineObj.tlNOMVATType Of
    CustAbsU.nlvNA     : Result := Enterprise_TLB.nlvNA;
    CustAbsU.nlvAuto   : Result := Enterprise_TLB.nlvAuto;
    CustAbsU.nlvManual : Result := Enterprise_TLB.nlvManual;
  Else
    Raise Exception.Create ('TCOMTransactionLine.Get_tlNOMVATType: Unhandled Value (' + IntToStr(Ord(FLineObj.tlNOMVATType)) + ')');
  End; { Case FLineObj.tlNOMVATType }
End;

procedure TCOMTransactionLine.Set_tlNOMVATType(Value: TNOMLineVATType);
Begin
  // Convert between COM and DLL enumerated types
  Case Value Of
    Enterprise_TLB.nlvNA     : FLineObj.tlNOMVATType := CustAbsU.nlvNA;
    Enterprise_TLB.nlvAuto   : FLineObj.tlNOMVATType := CustAbsU.nlvAuto;
    Enterprise_TLB.nlvManual : FLineObj.tlNOMVATType := CustAbsU.nlvManual;
  Else
    Raise Exception.Create ('TCOMTransactionLine.Set_tlNOMVATType: Unhandled Value (' + IntToStr(Ord(Value)) + ')');
  End; { Case FLineObj.tlNOMVATType }
End;

//------------------------------

function TCOMTransactionLine.Get_tlCISAdjustments: Double;
Begin
  Result := FLineObj.tlCISAdjustments;
End;

procedure TCOMTransactionLine.Set_tlCISAdjustments(Value: Double);
Begin
  FLineObj.tlCISAdjustments := Value;
End;

//------------------------------

function TCOMTransactionLine.Get_tlAppsDeductType: Integer;
Begin
  Result := FLineObj.tlAppsDeductType;
End;

procedure TCOMTransactionLine.Set_tlAppsDeductType(Value: Integer);
Begin
  FLineObj.tlAppsDeductType := Value;
End;

//------------------------------

function TCOMTransactionLine.Get_tlSerialReturnQty: Double;
begin
  Result := FLineObj.tlSerialReturnQty;
end;
procedure TCOMTransactionLine.Set_tlSerialReturnQty(Value: Double);
begin
  FLineObj.tlSerialReturnQty := Value;
end;

//------------------------------

function TCOMTransactionLine.Get_tlBinReturnQty: Double;
begin
  Result := FLineObj.tlBinReturnQty;
end;
procedure TCOMTransactionLine.Set_tlBinReturnQty(Value: Double);
begin
  FLineObj.tlBinReturnQty := Value;
end;

//------------------------------

function TCOMTransactionLine.Get_tlMultiBuyDiscount: Double;
Begin // Get_tlMultiBuyDiscount
  Result := FLineObj.tlMultiBuyDiscount;
End; // Get_tlMultiBuyDiscount
procedure TCOMTransactionLine.Set_tlMultiBuyDiscount(Value: Double);
Begin // Set_tlMultiBuyDiscount
  FLineObj.tlMultiBuyDiscount := Value;
End; // Set_tlMultiBuyDiscount

//------------------------------

function TCOMTransactionLine.Get_tlMultiBuyDiscountFlag: WideString;
Begin // Get_tlMultiBuyDiscountFlag
  Result := FLineObj.tlMultiBuyDiscountFlag;
End; // Get_tlMultiBuyDiscountFlag
procedure TCOMTransactionLine.Set_tlMultiBuyDiscountFlag(const Value: WideString);
Begin // Set_tlMultiBuyDiscountFlag
  FLineObj.tlMultiBuyDiscountFlag := WideStrToChar (Value, ' ');
End; // Set_tlMultiBuyDiscountFlag

//------------------------------

function TCOMTransactionLine.Get_tlTransValueDiscount: Double;
Begin // Get_tlTransValueDiscount
  Result := FLineObj.tlTransValueDiscount;
End; // Get_tlTransValueDiscount
procedure TCOMTransactionLine.Set_tlTransValueDiscount(Value: Double);
Begin // Set_tlTransValueDiscount
  FLineObj.tlTransValueDiscount := Value;
End; // Set_tlTransValueDiscount

//------------------------------

function TCOMTransactionLine.Get_tlTransValueDiscountFlag: WideString;
Begin // Get_tlTransValueDiscountFlag
  Result := FLineObj.tlTransValueDiscountFlag;
End; // Get_tlTransValueDiscountFlag
procedure TCOMTransactionLine.Set_tlTransValueDiscountFlag(const Value: WideString);
Begin // Set_tlTransValueDiscountFlag
  FLineObj.tlTransValueDiscountFlag := WideStrToChar (Value, ' ');
End; // Set_tlTransValueDiscountFlag

//------------------------------

function TCOMTransactionLine.Get_tlTransValueDiscountType: Smallint;
Begin // Get_tlTransValueDiscountType
  Result := FLineObj.tlTransValueDiscountType;
End; // Get_tlTransValueDiscountType
procedure TCOMTransactionLine.Set_tlTransValueDiscountType(Value: Smallint);
Begin // Set_tlTransValueDiscountType
  FLineObj.tlTransValueDiscountType := Value;
End; // Set_tlTransValueDiscountType

//-------------------------------------------------------------------------

function TCOMTransactionLine.entCalcLineDiscount(SettlementDiscount: Double; const SettlementDiscountType: WideString): Double;
Begin // entCalcLineDiscount
  Result := FLineObj.entCalcLineDiscount(SettlementDiscount, WideStrToChar (SettlementDiscountType, #0));
End; // entCalcLineDiscount

//-------------------------------------------------------------------------

function TCOMTransactionLine.Get_tlECService: WordBool;
Begin // Get_tlECService
  Result := FLineObj.tlECService;
End; // Get_tlECService
procedure TCOMTransactionLine.Set_tlECService(Value: WordBool);
Begin // Set_tlECService
  FLineObj.tlECService := Value;
End; // Set_tlECService

//------------------------------

function TCOMTransactionLine.Get_tlServiceStartDate: WideString;
Begin // Get_tlServiceStartDate
  Result := FLineObj.tlServiceStartDate;
End; // Get_tlServiceStartDate
procedure TCOMTransactionLine.Set_tlServiceStartDate(const Value: WideString);
Begin // Set_tlServiceStartDate
  FLineObj.tlServiceStartDate := Value;
End; // Set_tlServiceStartDate

//------------------------------

function TCOMTransactionLine.Get_tlServiceEndDate: WideString;
Begin // Get_tlServiceEndDate
  Result := FLineObj.tlServiceEndDate;
End; // Get_tlServiceEndDate
procedure TCOMTransactionLine.Set_tlServiceEndDate(const Value: WideString);
Begin // Set_tlServiceEndDate
  FLineObj.tlServiceEndDate := Value;
End; // Set_tlServiceEndDate

//------------------------------

function TCOMTransactionLine.Get_tlECSalesTaxReported: Double;
Begin // Get_tlECSalesTaxReported
  Result := FLineObj.tlECSalesTaxReported;
End; // Get_tlECSalesTaxReported
procedure TCOMTransactionLine.Set_tlECSalesTaxReported(Value: Double);
Begin // Set_tlECSalesTaxReported
  FLineObj.tlECSalesTaxReported := Value;
End; // Set_tlECSalesTaxReported

//------------------------------

function TCOMTransactionLine.Get_tlPurchaseServiceTax: Double;
Begin // Get_tlPurchaseServiceTax
  Result := FLineObj.tlPurchaseServiceTax;
End; // Get_tlPurchaseServiceTax
procedure TCOMTransactionLine.Set_tlPurchaseServiceTax(Value: Double);
Begin // Set_tlPurchaseServiceTax
  FLineObj.tlPurchaseServiceTax := Value;
End; // Set_tlPurchaseServiceTax

//------------------------------

function TCOMTransactionLine.Get_tlReference: WideString;
Begin // Get_tlReference
  Result := FLineObj.tlReference
End; // Get_tlReference
procedure TCOMTransactionLine.Set_tlReference(const Value: WideString);
Begin // Set_tlReference
  FLineObj.tlReference := Value;
End; // Set_tlReference

//------------------------------

function TCOMTransactionLine.Get_tlReceiptNo: WideString;
Begin // Get_tlReceiptNo
  Result := FLineObj.tlReceiptNo
End; // Get_tlReceiptNo
procedure TCOMTransactionLine.Set_tlReceiptNo(const Value: WideString);
Begin // Set_tlReceiptNo
  FLineObj.tlReceiptNo := Value;
End; // Set_tlReceiptNo

//------------------------------

function TCOMTransactionLine.Get_tlFromPostCode: WideString;
Begin // Get_tlFromPostCode
  Result := FLineObj.tlFromPostCode
End; // Get_tlFromPostCode
procedure TCOMTransactionLine.Set_tlFromPostCode(const Value: WideString);
Begin // Set_tlFromPostCode
  FLineObj.tlFromPostCode := Value;
End; // Set_tlFromPostCode

//------------------------------

function TCOMTransactionLine.Get_tlToPostCode: WideString;
Begin // Get_tlToPostCode
  Result := FLineObj.tlToPostCode
End; // Get_tlToPostCode
procedure TCOMTransactionLine.Set_tlToPostCode(const Value: WideString);
Begin // Set_tlToPostCode
  FLineObj.tlToPostCode := Value;
End; // Set_tlToPostCode

//-------------------------------------------------------------------------

function TCOMTransactionLine.Get_tlUserDef10: WideString;
begin
  Result := FLineObj.tlUserDef10;
end;

function TCOMTransactionLine.Get_tlUserDef5: WideString;
begin
  Result := FLineObj.tlUserDef5;
end;

function TCOMTransactionLine.Get_tlUserDef6: WideString;
begin
  Result := FLineObj.tlUserDef6;
end;

function TCOMTransactionLine.Get_tlUserDef7: WideString;
begin
  Result := FLineObj.tlUserDef7;
end;

function TCOMTransactionLine.Get_tlUserDef8: WideString;
begin
  Result := FLineObj.tlUserDef8;
end;

function TCOMTransactionLine.Get_tlUserDef9: WideString;
begin
  Result := FLineObj.tlUserDef9;
end;

procedure TCOMTransactionLine.Set_tlUserDef10(const Value: WideString);
begin
  FLineObj.tlUserDef10 := Value;
end;

procedure TCOMTransactionLine.Set_tlUserDef5(const Value: WideString);
begin
  FLineObj.tlUserDef5 := Value;
end;

procedure TCOMTransactionLine.Set_tlUserDef6(const Value: WideString);
begin
  FLineObj.tlUserDef6 := Value;
end;

procedure TCOMTransactionLine.Set_tlUserDef7(const Value: WideString);
begin
  FLineObj.tlUserDef7 := Value;
end;

procedure TCOMTransactionLine.Set_tlUserDef8(const Value: WideString);
begin
  FLineObj.tlUserDef8 := Value;
end;

procedure TCOMTransactionLine.Set_tlUserDef9(const Value: WideString);
begin
  FLineObj.tlUserDef9 := Value;
end;

//-------------------------------------------------------------------------

// MH 20/01/2016 Exch2016-R1: Intrastat enhancements - ICOMTransactionLine10
function TCOMTransactionLine.Get_tlIntrastatOverride: WordBool;
Begin // Get_tlIntrastatOverride
  Result := FLineObj.tlIntrastatOverride
End; // Get_tlIntrastatOverride
procedure TCOMTransactionLine.Set_tlIntrastatOverride(Value: WordBool);
Begin // Set_tlIntrastatOverride
  FLineObj.tlIntrastatOverride := Value
End; // Set_tlIntrastatOverride

//------------------------------

function TCOMTransactionLine.Get_tlIntrastatCommodityCode: WideString;
Begin // Get_tlIntrastatCommodityCode
  Result := FLineObj.tlIntrastatCommodityCode
End; // Get_tlIntrastatCommodityCode
procedure TCOMTransactionLine.Set_tlIntrastatCommodityCode(const Value: WideString);
Begin // Set_tlIntrastatCommodityCode
  FLineObj.tlIntrastatCommodityCode := Value
End; // Set_tlIntrastatCommodityCode

//------------------------------

function TCOMTransactionLine.Get_tlIntrastatStockUnits: Double;
Begin // Get_tlIntrastatStockUnits
  Result := FLineObj.tlIntrastatStockUnits
End; // Get_tlIntrastatStockUnits
procedure TCOMTransactionLine.Set_tlIntrastatStockUnits(Value: Double);
Begin // Set_tlIntrastatStockUnits
  FLineObj.tlIntrastatStockUnits := Value
End; // Set_tlIntrastatStockUnits

//------------------------------

function TCOMTransactionLine.Get_tlIntrastatCountry: WideString;
Begin // Get_tlIntrastatCountry
  Result := FLineObj.tlIntrastatCountry
End; // Get_tlIntrastatCountry
procedure TCOMTransactionLine.Set_tlIntrastatCountry(const Value: WideString);
Begin // Set_tlIntrastatCountry
  FLineObj.tlIntrastatCountry := Value
End; // Set_tlIntrastatCountry

//------------------------------

function TCOMTransactionLine.Get_tlIntrastatNoTC: WideString;
Begin // Get_tlIntrastatNoTC
  Result := FLineObj.tlIntrastatNoTC
End; // Get_tlIntrastatNoTC
procedure TCOMTransactionLine.Set_tlIntrastatNoTC(const Value: WideString);
Begin // Set_tlIntrastatNoTC
  FLineObj.tlIntrastatNoTC := Value
End; // Set_tlIntrastatNoTC

//------------------------------

function TCOMTransactionLine.Get_tlIntrastatUplift: Double;
Begin // Get_tlIntrastatUplift
  Result := FLineObj.tlIntrastatUplift
End; // Get_tlIntrastatUplift
procedure TCOMTransactionLine.Set_tlIntrastatUplift(Value: Double);
Begin // Set_tlIntrastatUplift
  FLineObj.tlIntrastatUplift := Value
End; // Set_tlIntrastatUplift

//=========================================================================

end.

