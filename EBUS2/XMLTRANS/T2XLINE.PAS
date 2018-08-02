unit t2xline;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ComObj, Enterprise03_TLB, xmlTrans, xmSerial, Logfile;



type
  TXmlTransactionLine = class(TLogAutoIntf, IXmlTransactionLine)
  private
    // Parent Transaction Object (as TObject to avoid circular references)
    FTransaction : TObject;
    // Parent Transaction Lines Object (as TObject to avoid circular references)
    FTHLines     : TObject;

    // Unique Id Number to identify this object in the lines area
    FIdNo        : LongInt;

    // Toolkit Transaction Line
    FTL          : TBatchTLRec;

    FAuxLine    : p2xAuxLineRec;

    //SerialBatch sub-object
    FSerialO   :  TXmlSerialBatch;
    FSerialI   :  IXmlSerialBatch;



  protected
    // ITransactionLine
    function  Get_tlLineNo: Integer; safecall;
    procedure Set_tlLineNo(Value: Integer); safecall;
    function  Get_tlGLCode: Integer; safecall;
    procedure Set_tlGLCode(Value: Integer); safecall;
    function  Get_tlCurrency: Integer; safecall;
    procedure Set_tlCurrency(Value: Integer); safecall;
    function  Get_tlCompanyRate: Double; safecall;
    procedure Set_tlCompanyRate(Value: Double); safecall;
    function  Get_tlDailyRate: Double; safecall;
    procedure Set_tlDailyRate(Value: Double); safecall;
    function  Get_tlCostCentre: WideString; safecall;
    procedure Set_tlCostCentre(const Value: WideString); safecall;
    function  Get_tlDepartment: WideString; safecall;
    procedure Set_tlDepartment(const Value: WideString); safecall;
    function  Get_tlStockCode: WideString; safecall;
    procedure Set_tlStockCode(const Value: WideString); safecall;
    function  Get_tlQty: Double; safecall;
    procedure Set_tlQty(Value: Double); safecall;
    function  Get_tlQtyMul: Double; safecall;
    procedure Set_tlQtyMul(Value: Double); safecall;
    function  Get_tlNetValue: Double; safecall;
    procedure Set_tlNetValue(Value: Double); safecall;
    function  Get_tlDiscount: Double; safecall;
    procedure Set_tlDiscount(Value: Double); safecall;
    function  Get_tlDiscFlag: WideString; safecall;
    procedure Set_tlDiscFlag(const Value: WideString); safecall;
    function  Get_tlVATCode: WideString; safecall;
    procedure Set_tlVATCode(Const Value: WideString); safecall;
    function  Get_tlVATAmount: Double; safecall;
    procedure Set_tlVATAmount(Value: Double); safecall;
    function  Get_tlPayment: WordBool; safecall;
    procedure Set_tlPayment(Value: WordBool); safecall;
    function  Get_tlQtyWOFF: Double; safecall;
    procedure Set_tlQtyWOFF(Value: Double); safecall;
    function  Get_tlQtyDel: Double; safecall;
    procedure Set_tlQtyDel(Value: Double); safecall;
    function  Get_tlCost: Double; safecall;
    procedure Set_tlCost(Value: Double); safecall;
    function  Get_tlLineDate: WideString; safecall;
    procedure Set_tlLineDate(const Value: WideString); safecall;
    function  Get_tlItemNo: WideString; safecall;
    procedure Set_tlItemNo(const Value: WideString); safecall;
    function  Get_tlDescr: WideString; safecall;
    procedure Set_tlDescr(const Value: WideString); safecall;
    function  Get_tlJobCode: WideString; safecall;
    procedure Set_tlJobCode(const Value: WideString); safecall;
    function  Get_tlAnalysisCode: WideString; safecall;
    procedure Set_tlAnalysisCode(const Value: WideString); safecall;
    function  Get_tlUnitWeight: Double; safecall;
    procedure Set_tlUnitWeight(Value: Double); safecall;
    function  Get_tlLocation: WideString; safecall;
    procedure Set_tlLocation(const Value: WideString); safecall;
    function  Get_tlChargeCurrency: Integer; safecall;
    procedure Set_tlChargeCurrency(Value: Integer); safecall;
    function  Get_tlAcCode: WideString; safecall;
    function  Get_tlLineType: TXmlTransactionLineType; safecall;
    procedure Set_tlLineType(Value: TxmlTransactionLineType); safecall;
    function  Get_tlFolioNum: Integer; safecall;
    function  Get_tlLineClass: WideString; safecall;
    function  Get_tlRecStatus: Smallint; safecall;
    procedure Set_tlRecStatus(Value: Smallint); safecall;
    function  Get_tlSOPFolioNum: Integer; safecall;
    procedure Set_tlSOPFolioNum(Value: Integer); safecall;
    function  Get_tlSOPABSLineNo: Integer; safecall;
    procedure Set_tlSOPABSLineNo(Value: Integer); safecall;
    function  Get_tlABSLineNo: Integer; safecall;
    function  Get_tlUserField1: WideString; safecall;
    procedure Set_tlUserField1(const Value: WideString); safecall;
    function  Get_tlUserField2: WideString; safecall;
    procedure Set_tlUserField2(const Value: WideString); safecall;
    function  Get_tlUserField3: WideString; safecall;
    procedure Set_tlUserField3(const Value: WideString); safecall;
    function  Get_tlUserField4: WideString; safecall;
    procedure Set_tlUserField4(const Value: WideString); safecall;
    function  Get_tlSSDUpliftPerc: Double; safecall;
    procedure Set_tlSSDUpliftPerc(Value: Double); safecall;
    function  Get_tlSSDCommodCode: WideString; safecall;
    procedure Set_tlSSDCommodCode(const Value: WideString); safecall;
    function  Get_tlSSDSalesUnit: Double; safecall;
    procedure Set_tlSSDSalesUnit(Value: Double); safecall;
    function  Get_tlSSDUseLineValues: WordBool; safecall;
    procedure Set_tlSSDUseLineValues(Value: WordBool); safecall;
    function  Get_tlPriceMultiplier: Double; safecall;
    procedure Set_tlPriceMultiplier(Value: Double); safecall;
    function  Get_tlQtyPicked: Double; safecall;
    procedure Set_tlQtyPicked(Value: Double); safecall;
    function  Get_tlQtyPickedWO: Double; safecall;
    procedure Set_tlQtyPickedWO(Value: Double); safecall;
    function  Get_tlSSDCountry: WideString; safecall;
    procedure Set_tlSSDCountry(const Value: WideString); safecall;
    function  Get_tlInclusiveVATCode: WideString; safecall;
    procedure Set_tlInclusiveVATCode(const Value: WideString); safecall;
    function  Get_tlBOMKitLink: Integer; safecall;
    procedure Set_tlBOMKitLink(Value: Integer); safecall;
    function  Get_tlOurRef: WideString; safecall;
    procedure Save; safecall;
    function  Get_tlVatRate: Double; safecall;
    procedure Set_tlVatRate(Value: Double); safecall;
    function  Get_tlUOMQuantityDesc: WideString; safecall;
    procedure Set_tlUOMQuantityDesc(const Value: WideString); safecall;
    function  Get_tlUOMPriceDesc: WideString; safecall;
    procedure Set_tlUOMPriceDesc(const Value: WideString); safecall;
    function  Get_tlLineTotal: Double; safecall;
    procedure Set_tlLineTotal(Value: Double); safecall;
    function  Get_tlXmlSerialBatch: IXmlSerialBatch; safecall;

    Procedure InitObjects;
  public
    Constructor Create(Const IdNo        : LongInt;
                       Const ParentTrans : TObject;
                       Const ParentLines : TObject;
                       Const TL          : TBatchTLRec);
    Destructor Destroy; override;

    Procedure InitNewLine;
    Property IdNo : LongInt Read FIdNo;
    Property TL : TBatchTLRec Read FTL Write FTL;
    property AuxLine : p2xAuxLineRec read FAuxLine write FAuxLine;
  End; { TXmlTransactionLine }


implementation

uses ComServ, t2xml, t2xlines, SysUtils, t2xConst;

{-------------------------------------------------------------------------------------------------}

Constructor TXmlTransactionLine.Create(Const IdNo        : LongInt;
                                    Const ParentTrans : TObject;
                                    Const ParentLines : TObject;
                                    Const TL          : TBatchTLRec);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IXmlTransactionLine);

  // Initialise variables
  InitObjects;

  FIdNo := IdNo;

  FTransaction := ParentTrans;
  FTHLines := ParentLines;

  FillChar (FTL, SizeOf(FTL), #0);
  FTL := TL;

  FTL.SSDUseLine := True;

  New(FAuxLine);
  FillChar(FAuxLine^, SizeOf(FAuxLine^), #0);

End; { Create }

{-----------------------------------------}

Destructor TXmlTransactionLine.Destroy;
Begin { Destroy }
  { Destroy sub-objects }
  InitObjects;

  Dispose(FAuxLine);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}


Procedure TXmlTransactionLine.InitObjects;
Begin { InitObjects }
  // Reference to parent TTransaction object (as TObject to avoid circular references) }
  FTransaction := Nil;

  // Reference to parent TTransaction Lines object (as TObject to avoid circular references) }
  FTHLines := Nil;

  //Serial number objects
  FSerialO := nil;
  FSerialI := nil;


End; { InitObjects }

{-----------------------------------------}

Procedure TXmlTransactionLine.InitNewLine;
Var
  IdDocHed : String[3];
Begin { InitNewLine }
  With (FTransaction As TxmlTransaction), FTL Do Begin
    // Line Number set in thLines before object creation

    // Currency
    Currency := TH.Currency;

    // Quantity
    QtyMul := 1.0;
    Qty := 1.0;

    // Job Code & Analysis Code
    JobCode := TH.DJobCode;
    AnalCode := TH.DJobAnal;

    LineDate := TH.TransDate;
    VatCode := 'S';

    // Filter out non-account based transactions

  End; { With FTL }
End; { InitNewLine }

{-----------------------------------------}

function TXmlTransactionLine.Get_tlLineNo: Integer;
begin
  Result := FTL.LineNo;
end;

procedure TXmlTransactionLine.Set_tlLineNo(Value: Integer);
begin
  FTL.LineNo := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlABSLineNo: Integer;
begin
  Result := FTL.ABSLineNo;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlAcCode: WideString;
begin
  Result := FTL.CustCode;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlAnalysisCode: WideString;
begin
  Result := FTL.AnalCode;
end;

procedure TXmlTransactionLine.Set_tlAnalysisCode(const Value: WideString);
begin
  FTL.AnalCode := UpperCase(Value);
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlBOMKitLink: Integer;
begin
  Result := FTL.KitLink
end;

procedure TXmlTransactionLine.Set_tlBOMKitLink(Value: Integer);
begin
  FTL.KitLink := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlChargeCurrency: Integer;
begin
  Result := FTL.TSHCCurr;
end;

procedure TXmlTransactionLine.Set_tlChargeCurrency(Value: Integer);
begin
  FTL.TSHCCurr := {ValidateCurrencyNo} (Value);
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlCompanyRate: Double;
begin
  Result := FTL.CoRate;
end;

procedure TXmlTransactionLine.Set_tlCompanyRate(Value: Double);
begin
  FTL.CoRate := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlCost: Double;
begin
  Result := FTL.CostPrice;
end;

procedure TXmlTransactionLine.Set_tlCost(Value: Double);
begin
  FTL.CostPrice := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlCostCentre: WideString;
begin
  Result := FTL.CC;
end;

procedure TXmlTransactionLine.Set_tlCostCentre(const Value: WideString);
begin
  FTL.CC := UpperCase(Value);
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlCurrency: Integer;
begin
  Result := FTL.Currency;
end;

procedure TXmlTransactionLine.Set_tlCurrency(Value: Integer);
begin
  FTL.Currency := {ValidateCurrencyNo}(Value);
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlDailyRate: Double;
begin
  Result := FTL.VATRate;
end;

procedure TXmlTransactionLine.Set_tlDailyRate(Value: Double);
begin
  FTL.VATRate := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlDepartment: WideString;
begin
  Result := FTL.Dep;
end;

procedure TXmlTransactionLine.Set_tlDepartment(const Value: WideString);
begin
  FTL.Dep := (UpperCase(Value));
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlDescr: WideString;
begin
  Result := FTL.Desc;
end;

procedure TXmlTransactionLine.Set_tlDescr(const Value: WideString);
begin
  FTL.Desc := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlDiscFlag: WideString;
begin
  Result := FTL.DiscountChr;
end;

procedure TXmlTransactionLine.Set_tlDiscFlag(const Value: WideString);
begin
  FTL.DiscountChr := ExtractChar(Value, ' ');
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlDiscount: Double;
begin
  Result := FTL.Discount;
end;

procedure TXmlTransactionLine.Set_tlDiscount(Value: Double);
begin
  FTL.Discount := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlFolioNum: Integer;
begin
  Result := FTL.FolioNum;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlGLCode: Integer;
begin
  Result := FTL.NomCode;
end;

procedure TXmlTransactionLine.Set_tlGLCode(Value: Integer);
begin
  FTL.NomCode := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlInclusiveVATCode: WideString;
begin
  Result := FTL.VATIncFlg;
end;

procedure TXmlTransactionLine.Set_tlInclusiveVATCode(const Value: WideString);
begin
  FTL.VATIncFlg := ExtractChar(Value, ' ');
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlItemNo: WideString;
begin
  Result := FTL.Item;
end;

procedure TXmlTransactionLine.Set_tlItemNo(const Value: WideString);
begin
  FTL.Item := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlJobCode: WideString;
begin
  Result := FTL.JobCode;
end;

procedure TXmlTransactionLine.Set_tlJobCode(const Value: WideString);
begin
  FTL.JobCode := (UpperCase(Value));
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlLineClass: WideString;
begin
  Result := FTL.LineType;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlLineDate: WideString;
begin
  Result := FTL.LineDate;
end;

procedure TXmlTransactionLine.Set_tlLineDate(const Value: WideString);
begin
  FTL.LineDate := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlLineType: TXmlTransactionLineType;
begin
  Case FTL.DocLTLink of
    0 : Result := tlTypeNormal;
    1 : Result := tlTypeLabour;
    2 : Result := tlTypeMaterials;
    3 : Result := tlTypeFreight;
    4 : Result := tlTypeDiscount;
  Else
    Raise Exception.Create ('Invalid Line Type ' + QuotedStr(IntToStr(FTL.DocLTLink)));
  End; { Case }
end;

procedure TXmlTransactionLine.Set_tlLineType(Value: TXmlTransactionLineType);
begin
  Case Value of
    tlTypeNormal    :  FTL.DocLTLink := 0;
    tlTypeLabour    :  FTL.DocLTLink := 1;
    tlTypeMaterials :  FTL.DocLTLink := 2;
    tlTypeFreight   :  FTL.DocLTLink := 3;
    tlTypeDiscount  :  FTL.DocLTLink := 4;
  Else
    Raise Exception.Create ('Invalid LineType ' + IntToStr(Ord(Value)));
  End; { Case }
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlLocation: WideString;
begin
  Result := FTL.MLocStk;
end;

procedure TXmlTransactionLine.Set_tlLocation(const Value: WideString);
begin
  FTL.MLocStk := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlNetValue: Double;
begin
  Result := FTL.NetValue;
end;

procedure TXmlTransactionLine.Set_tlNetValue(Value: Double);
begin
  FTL.NetValue := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlPayment: WordBool;
begin
  Result := FTL.Payment;
end;

procedure TXmlTransactionLine.Set_tlPayment(Value: WordBool);
begin
  FTL.Payment := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlPriceMultiplier: Double;
begin
  Result := FTL.PriceMulx;
end;

procedure TXmlTransactionLine.Set_tlPriceMultiplier(Value: Double);
begin
  FTL.PriceMulx := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlQty: Double;
begin
  Result := FTL.Qty;
end;

procedure TXmlTransactionLine.Set_tlQty(Value: Double);
begin
  FTL.Qty := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlQtyDel: Double;
begin
  Result := FTL.QtyDel;
end;

procedure TXmlTransactionLine.Set_tlQtyDel(Value: Double);
begin
  FTL.QtyDel := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlQtyMul: Double;
begin
  Result := FTL.QtyMul;
end;

procedure TXmlTransactionLine.Set_tlQtyMul(Value: Double);
begin
  FTL.QtyMul := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlQtyPicked: Double;
begin
  Result := FTL.QtyPick;
end;

procedure TXmlTransactionLine.Set_tlQtyPicked(Value: Double);
begin
  FTL.QtyPick := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlQtyPickedWO: Double;
begin
  Result := FTL.QtyPWOff;
end;

procedure TXmlTransactionLine.Set_tlQtyPickedWO(Value: Double);
begin
  FTL.QtyPWOff := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlQtyWOFF: Double;
begin
  Result := FTL.QtyWOff;
end;

procedure TXmlTransactionLine.Set_tlQtyWOFF(Value: Double);
begin
  FTL.QtyWOff := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlRecStatus: Smallint;
begin
  Result := FTL.Reconcile;
end;

procedure TXmlTransactionLine.Set_tlRecStatus(Value: Smallint);
begin
  FTL.Reconcile := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlSOPABSLineNo: Integer;
begin
  Result := FTL.SOPLineNo;
end;

procedure TXmlTransactionLine.Set_tlSOPABSLineNo(Value: Integer);
begin
  FTL.SOPLineNo := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlSOPFolioNum: Integer;
begin
  Result := FTL.SOPLink;
end;

procedure TXmlTransactionLine.Set_tlSOPFolioNum(Value: Integer);
begin
  FTL.SOPLink := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlSSDCommodCode: WideString;
begin
  Result := FTL.SSDCommod;
end;

procedure TXmlTransactionLine.Set_tlSSDCommodCode(const Value: WideString);
begin
  FTL.SSDCommod := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlSSDCountry: WideString;
begin
  Result := FTL.SSDCountry;
end;

procedure TXmlTransactionLine.Set_tlSSDCountry(const Value: WideString);
begin
  FTL.SSDCountry := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlSSDSalesUnit: Double;
begin
  Result := FTL.SSDSPUnit;
end;

procedure TXmlTransactionLine.Set_tlSSDSalesUnit(Value: Double);
begin
  FTL.SSDSPUnit := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlSSDUpliftPerc: Double;
begin
  Result := FTL.SSDUplift;
end;

procedure TXmlTransactionLine.Set_tlSSDUpliftPerc(Value: Double);
begin
  FTL.SSDUplift := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlSSDUseLineValues: WordBool;
begin
  Result := FTL.SSDUseLine;
end;

procedure TXmlTransactionLine.Set_tlSSDUseLineValues(Value: WordBool);
begin
  FTL.SSDUseLine := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlStockCode: WideString;
begin
  Result := FTL.StockCode;
end;

procedure TXmlTransactionLine.Set_tlStockCode(const Value: WideString);
begin
  FTL.StockCode := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlUnitWeight: Double;
begin
  Result := FTL.LWeight;
end;

procedure TXmlTransactionLine.Set_tlUnitWeight(Value: Double);
begin
  FTL.LWeight := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlUserField1: WideString;
begin
  Result := FTL.LineUser1;
end;

procedure TXmlTransactionLine.Set_tlUserField1(const Value: WideString);
begin
  FTL.LineUser1 := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlUserField2: WideString;
begin
  Result := FTL.LineUser2;
end;

procedure TXmlTransactionLine.Set_tlUserField2(const Value: WideString);
begin
  FTL.LineUser2 := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlUserField3: WideString;
begin
  Result := FTL.LineUser3;
end;

procedure TXmlTransactionLine.Set_tlUserField3(const Value: WideString);
begin
  FTL.LineUser3 := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlUserField4: WideString;
begin
  Result := FTL.LineUser4;
end;

procedure TXmlTransactionLine.Set_tlUserField4(const Value: WideString);
begin
  FTL.LineUser4 := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlVATAmount: Double;
begin
  Result := FTL.VAT;
end;

procedure TXmlTransactionLine.Set_tlVATAmount(Value: Double);
begin
  FTL.VAT := Value;
end;

{-----------------------------------------}

function TXmlTransactionLine.Get_tlVATCode: WideString;
begin
  Result := FTL.VATCode;
end;

procedure TXmlTransactionLine.Set_tlVATCode(Const Value: WideString);
begin
  FTL.VATCode := ExtractChar(Value, ' ');
end;

{-----------------------------------------}


function TXmlTransactionLine.Get_tlOurRef: WideString;
begin
  Result := FTL.TransRefNo;
end;

{-----------------------------------------}

// Save method to add new lines into thLines list
Procedure TXmlTransactionLine.Save;
Begin { Save }
    With FTHLines As TXmlTransactionLines Do
      AddNewLine (Self)
End; { Save }

{-----------------------------------------}


function  TXmlTransactionLine.Get_tlVatRate: Double; safecall;
begin
  Result := FAuxLine.axVatRate;
end;

procedure TXmlTransactionLine.Set_tlVatRate(Value: Double); safecall;
begin
  FAuxLine.axVatRate := Value;
end;

function  TXmlTransactionLine.Get_tlUOMQuantityDesc: WideString; safecall;
begin
  Result := FAuxLine.axUOMQuantDesc;
end;

procedure TXmlTransactionLine.Set_tlUOMQuantityDesc(const Value: WideString); safecall;
begin
  FAuxLine.axUOMQuantDesc := Value;
end;

function  TXmlTransactionLine.Get_tlUOMPriceDesc: WideString; safecall;
begin
  Result := FAuxLine.axUOMPriceDesc;
end;

procedure TXmlTransactionLine.Set_tlUOMPriceDesc(const Value: WideString); safecall;
begin
  FAuxLine.axUOMPriceDesc := Value;
end;

function  TXmlTransactionLine.Get_tlLineTotal: Double; safecall;
begin
  Result := FAuxLine.axLineTotal;
end;

procedure TXmlTransactionLine.Set_tlLineTotal(Value: Double); safecall;
begin
  FAuxLine.axLineTotal := Value;
end;

function  TXmlTransactionLine.Get_tlXmlSerialBatch : IXmlSerialBatch;
begin
  if not Assigned(FSerialO) then
  begin
    FSerialO := TXmlSerialBatch.Create;
    FSerialO.LineNo := FTL.LineNo;

    FSerialI := FSerialO;
  end;

  Result := FSerialI;

end;







{-----------------------------------------}


end.
