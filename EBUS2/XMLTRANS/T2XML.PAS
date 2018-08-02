unit T2XML;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ComObj, ActiveX, Enterprise03_TLB, StdVcl, t2xAdd, t2xlines, t2xline, xmlTrans, t2xWrite,
  xNarrtve, xmSerial, Dialogs, LogFile;


type

  //PR: 01/02/2013 ABSEXCH-13134 Added IXmlTransaction3 with UDFs 5-10
  //PR: 16/10/2013 ABSEXCH-14703 IXmlTransaction4 thDeliveryPostcode
  TXmlTransaction = class(TLogAutoIntf, IXmlTransaction, IXmlTransaction2, IXmlTransaction3, IXmlTransaction4,
                          IXmlTransaction5)
  private
    // Transaction Object
    FTH             : TBatchTHRec;
    THLinesRec : TBatchLinesRec;

    //Auxiliary storage for standalone stuff;
    FAuxRec         : t2xAuxHeadRec;

    // Delivery Address sub-object
    FDelAddrO       : TXmlAddress;
    FDelAddrI       : IXmlAddress;

    FInvAddrO       : TXmlAddress;
    FInvAddrI       : IxmlAddress;

    FSysAddrO       : TXmlAddress;
    FSysAddrI       : IxmlAddress;

    // Transaction Line Interface
    FTHLinesO       : TXmlTransactionLines; //TXmlTransactionLines;
    FTHLinesI       : IXmlTransactionLines; //ITransactionLines;

    // Notes sub-object
    FNarrativeO         : TXmlNarrative;
    FNarrativeI         : IXmlNarrative;

    FParent             : TObject; //Parent XmlWriter as object to avoid circular ref

    FOutDir : string;
    procedure InitObjects;
  protected
    function Get_thOurRef: WideString; safecall;
    procedure Set_thOurRef(const Value: WideString); safecall;
    function Get_thAcCode: WideString; safecall;
    function Get_thAmountSettled: Double; safecall;
    function Get_thAnalysisCode: WideString; safecall;
    function Get_thBatchDiscAmount: Double; safecall;
    function Get_thCompanyRate: Double; safecall;
    function Get_thControlGL: Integer; safecall;
    function Get_thCurrency: Smallint; safecall;
    function Get_thDailyRate: Double; safecall;
    function Get_thDelAddress: IXmlAddress; safecall;
    function Get_thDeliveryTerms: WideString; safecall;
    function Get_thDocType: TXmlDocTypes; safecall;
    function Get_thDueDate: WideString; safecall;
    function Get_thEmployeeCode: WideString; safecall;
    function Get_thFixedRate: WordBool; safecall;
    function Get_thHoldFlag: Smallint; safecall;
    function Get_thJobCode: WideString; safecall;
    function Get_thLongYourRef: WideString; safecall;
    function Get_thManualVAT: WordBool; safecall;
    function Get_thNetValue: Double; safecall;
    function Get_thNoLabels: Smallint; safecall;
    function Get_thOperator: WideString; safecall;
    function Get_thOutstanding: WideString; safecall;
    function Get_thPeriod: Smallint; safecall;
    function Get_thPORPickSOR: WordBool; safecall;
    function Get_thPostedDate: WideString; safecall;
    function Get_thPrePost: Integer; safecall;
    function Get_thPrinted: WordBool; safecall;
    function Get_thSettleDiscAmount: Double; safecall;
    function Get_thSettleDiscDays: Smallint; safecall;
    function Get_thSettleDiscPerc: Double; safecall;
    function Get_thSettleDiscTaken: WordBool; safecall;
    function Get_thSource: Integer; safecall;
    function Get_thTagged: WordBool; safecall;
    function Get_thTotalCost: Double; safecall;
    function Get_thTotalLineDiscount: Double; safecall;
    function Get_thTotalOrderOS: Double; safecall;
    function Get_thTotalVAT: Double; safecall;
    function Get_thTotalWeight: Double; safecall;
    function Get_thTransDate: WideString; safecall;
    function Get_thTransportMode: Smallint; safecall;
    function Get_thTransportNature: Smallint; safecall;
    function Get_thUserField1: WideString; safecall;
    function Get_thUserField2: WideString; safecall;
    function Get_thUserField3: WideString; safecall;
    function Get_thUserField4: WideString; safecall;
    function Get_thYear: Smallint; safecall;
    function Get_thYourRef: WideString; safecall;
    procedure Set_thAcCode(const Value: WideString); safecall;
    procedure Set_thAnalysisCode(const Value: WideString); safecall;
    procedure Set_thBatchDiscAmount(Value: Double); safecall;
    procedure Set_thCompanyRate(Value: Double); safecall;
    procedure Set_thControlGL(Value: Integer); safecall;
    procedure Set_thCurrency(Value: Smallint); safecall;
    procedure Set_thDailyRate(Value: Double); safecall;
    procedure Set_thDeliveryTerms(const Value: WideString); safecall;
    procedure Set_thDueDate(const Value: WideString); safecall;
    procedure Set_thEmployeeCode(const Value: WideString); safecall;
    procedure Set_thFixedRate(Value: WordBool); safecall;
    procedure Set_thHoldFlag(Value: Smallint); safecall;
    procedure Set_thJobCode(const Value: WideString); safecall;
    procedure Set_thLongYourRef(const Value: WideString); safecall;
    procedure Set_thManualVAT(Value: WordBool); safecall;
    procedure Set_thNetValue(Value: Double); safecall;
    procedure Set_thNoLabels(Value: Smallint); safecall;
    procedure Set_thOperator(const Value: WideString); safecall;
    procedure Set_thPeriod(Value: Smallint); safecall;
    procedure Set_thPORPickSOR(Value: WordBool); safecall;
    procedure Set_thPrePost(Value: Integer); safecall;
    procedure Set_thSettleDiscAmount(Value: Double); safecall;
    procedure Set_thSettleDiscDays(Value: Smallint); safecall;
    procedure Set_thSettleDiscPerc(Value: Double); safecall;
    procedure Set_thSettleDiscTaken(Value: WordBool); safecall;
    procedure Set_thTagged(Value: WordBool); safecall;
    procedure Set_thTotalCost(Value: Double); safecall;
    procedure Set_thTotalLineDiscount(Value: Double); safecall;
    procedure Set_thTotalOrderOS(Value: Double); safecall;
    procedure Set_thTotalVAT(Value: Double); safecall;
    procedure Set_thTotalWeight(Value: Double); safecall;
    procedure Set_thTransDate(const Value: WideString); safecall;
    procedure Set_thTransportMode(Value: Smallint); safecall;
    procedure Set_thTransportNature(Value: Smallint); safecall;
    procedure Set_thUserField1(const Value: WideString); safecall;
    procedure Set_thUserField2(const Value: WideString); safecall;
    procedure Set_thUserField3(const Value: WideString); safecall;
    procedure Set_thUserField4(const Value: WideString); safecall;
    procedure Set_thYear(Value: Smallint); safecall;
    procedure Set_thYourRef(const Value: WideString); safecall;
    procedure InitTransRec; safecall;
    function ValidateCurrencyNo(Value : SmallInt) : SmallInt; safecall;
    procedure Set_thDocType(Value: TXmlDocTypes); safecall;
    function Get_thLines: IXmlTransactionLines; safecall;
    procedure WriteXML(const APath: WideString); safecall;
    function Get_thCustSuppAddress: IXmlAddress; safecall;
    function Get_thCustSuppName: WideString; safecall;
    function Get_thOurAddress: IXmlAddress; safecall;
    function Get_thOurName: WideString; safecall;
    procedure Set_thCustSuppName(const Value: WideString); safecall;
    procedure Set_thOurName(const Value: WideString); safecall;
    function Get_thOurVatReg: WideString; safecall;
    procedure Set_thOurVatReg(const Value: WideString); safecall;
    function Get_thUseCCDept: WordBool; safecall;
    procedure Set_thUseCCDept(Value: WordBool); safecall;
    function Get_thXslUrl: WideString; safecall;
    procedure Set_thXslUrl(const Value: WideString); safecall;
    function Get_thCurrencyCode: WideString; safecall;
    function Get_thCurrencyName: WideString; safecall;
    procedure Set_thCurrencyCode(const Value: WideString); safecall;
    procedure Set_thCurrencyName(const Value: WideString); safecall;
    function Get_thContactName: WideString; safecall;
    procedure Set_thContactName(const Value: WideString); safecall;
    function Get_thContactFax: WideString; safecall;
    function Get_thContactPhone: WideString; safecall;
    procedure Set_thContactFax(const Value: WideString); safecall;
    procedure Set_thContactPhone(const Value: WideString); safecall;
    function Get_thCostDecPlaces: Integer; safecall;
    function Get_thPriceDecPlaces: Integer; safecall;
    function Get_thQuantDecPlaces: Integer; safecall;
    procedure Set_thCostDecPlaces(Value: Integer); safecall;
    procedure Set_thPriceDecPlaces(Value: Integer); safecall;
    procedure Set_thQuantDecPlaces(Value: Integer); safecall;
    function Get_thCalcLineTotals: WordBool; safecall;
    procedure Set_thCalcLineTotals(Value: WordBool); safecall;

    function Get_thNarrative: IxmlNarrative; safecall;
    procedure Clear; safecall;

    function  Get_thContactPhone2: WideString; safecall;
    procedure Set_thContactPhone2(const Value: WideString); safecall;

    function Get_thTheirCodeForUs: WideString; safecall;
    procedure Set_thTheirCodeForUs(const Value: WideString); safecall;

    function Get_thTagNo: Integer; safecall;
    procedure Set_thTagNo(Value: Integer); safecall;

    //PR: 01/02/2013 ABSEXCH-13134 Add UDFs 5-10
    function Get_thUserField5: WideString; safecall;
    procedure Set_thUserField5(const Value: WideString); safecall;
    function Get_thUserField6: WideString; safecall;
    procedure Set_thUserField6(const Value: WideString); safecall;
    function Get_thUserField7: WideString; safecall;
    procedure Set_thUserField7(const Value: WideString); safecall;
    function Get_thUserField8: WideString; safecall;
    procedure Set_thUserField8(const Value: WideString); safecall;
    function Get_thUserField9: WideString; safecall;
    procedure Set_thUserField9(const Value: WideString); safecall;
    function Get_thUserfield10: WideString; safecall;
    procedure Set_thUserfield10(const Value: WideString); safecall;

    //PR: 16/10/2013 ABSEXCH-14703 IXmlTransaction4
    function Get_thDeliveryPostcode: WideString; safecall;
    procedure Set_thDeliveryPostcode(const Value: WideString); safecall;

    //PR: 05/06/2015 v7.0.14 IXmlTransaction5
    function Get_thPPDPercentage: Double; safecall;
    procedure Set_thPPDPercentage(Value: Double); safecall;
    function Get_thPPDDays: SmallInt; safecall;
    procedure Set_thPPDDays(Value: SmallInt); safecall;
    function Get_thPPDGoodsValue: Double; safecall;
    procedure Set_thPPDGoodsValue(Value: Double); safecall;
    function Get_thPPDVATValue: Double; safecall;
    procedure Set_thPPDVATValue(Value: Double); safecall;
    function Get_thPPDTaken: TPPDTakenMode; safecall;
    procedure Set_thPPDTaken(Value: TPPDTakenMode); safecall;

  public
    constructor Create(const AParent : TObject);
//    procedure Initialize; override;
    destructor Destroy; override;
    function GetAddrLine (AddrIdx, Idx : Byte) : String;
    Procedure SetAddrLine(AddrIdx, Idx : Byte; Value : String);
    function GetCSAddrLine (AddrIdx, Idx : Byte) : String;
    Procedure SetCSAddrLine(AddrIdx, Idx : Byte; Value : String);
    function GetOurAddrLine (AddrIdx, Idx : Byte) : String;
    Procedure SetOurAddrLine(AddrIdx, Idx : Byte; Value : String);
    procedure SetDefaults;
    Property TH : TBatchTHRec Read FTH;

  end;

implementation

uses ComServ, Classes, MathUtil, SysUtils, Xml_Writ, XMLConst;

var
  Count : Integer;

constructor TXmlTransaction.Create(const AParent : TObject);
begin
  //PR: 16/10/2013 ABSEXCH-14703 IXmlTransaction4
  //PR: 05/06/2015 v7.0.14 IXmlTransaction5
  Inherited Create (ComServer.TypeLib, IXmlTransaction5);
  FParent := AParent;
  FillChar(FAuxRec, SizeOf(FAuxRec), #0);
  //Defaults for decimal places
  SetDefaults;

  InitTransRec;
  InitObjects;

end;

destructor TXmlTransaction.Destroy;
begin
  InitObjects;
  inherited Destroy;
end;

Procedure TXmlTransaction.InitObjects;
Begin { Destroy }
  // Delivery Address sub-object
  FDelAddrO := Nil;
  FDelAddrI := Nil;

  // Transaction Line sub-object
  FTHLinesO := Nil;
  FTHLinesI := Nil;

  FNarrativeO := Nil;
  FNarrativeI := Nil;

  FInvAddrO := Nil;
  FInvAddrI := Nil;

  FSysAddrO := Nil;
  FSysAddrI := Nil;


End; { Destroy }

procedure TXmlTransaction.SetDefaults;
begin
  FAuxRec.CostDP := 2;
  FAuxRec.PriceDP := 2;
  FAuxRec.QuantityDP := 0;

  FOutDir := '';

end;


function TXmlTransaction.Get_thOurRef: WideString;
begin
  Result := FTH.OurRef;
end;

procedure TXmlTransaction.Set_thOurRef(const Value: WideString);
begin
  FTH.OurRef := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thYourRef: WideString;
begin
  Result := FTH.YourRef;
end;

procedure TXmlTransaction.Set_thYourRef(const Value: WideString);
begin
  FTH.YourRef := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thAcCode: WideString;
begin
  Result := FTH.CustCode;
end;

procedure TXmlTransaction.Set_thAcCode(const Value: WideString);
begin
  FTH.CustCode := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thAmountSettled: Double;
begin
  Result := FTH.Settled;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thAnalysisCode: WideString;
begin
  Result := FTH.DJobAnal;
end;

procedure TXmlTransaction.Set_thAnalysisCode(const Value: WideString);
begin
  FTH.DJobAnal := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thBatchDiscAmount: Double;
begin
  Result := FTH.BDiscount;
end;

procedure TXmlTransaction.Set_thBatchDiscAmount(Value: Double);
begin
  FTH.BDiscount := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thCompanyRate: Double;
begin
  Result := FTH.CoRate;
end;

procedure TXmlTransaction.Set_thCompanyRate(Value: Double);
begin
  FTH.CoRate := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thControlGL: Integer;
begin
  Result := FTH.CtrlNom;
end;

procedure TXmlTransaction.Set_thControlGL(Value: Integer);
begin
  FTH.CtrlNom := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thCurrency: Smallint;
begin
  Result := FTH.Currency;
end;

procedure TXmlTransaction.Set_thCurrency(Value: Smallint);
begin
  FTH.Currency := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TXmlTransaction.Get_thDailyRate: Double;
begin
  Result := FTH.VATRate;
end;

procedure TXmlTransaction.Set_thDailyRate(Value: Double);
begin
  FTH.VATRate := Value;
end;

{-----------------------------------------}

function TXmlTransaction.GetAddrLine (AddrIdx, Idx : Byte) : String;
begin
  Result := FTH.DAddr[Idx];
end;

Procedure TXmlTransaction.SetAddrLine(AddrIdx, Idx : Byte; Value : String);
begin
  FTH.DAddr[Idx] := Value;
end;

function TXmlTransaction.Get_thDelAddress: IXmlAddress;
begin
  If (Not Assigned(FDelAddrO)) Then Begin
    { Create and initialise Customer Address Sub-Object}
    FDelAddrO := TXmlAddress.Create(1, GetAddrLine, SetAddrLine);

    FDelAddrI := FDelAddrO;
  End; { If (Not Assigned(FDelAddrO)) }

  Result := FDelAddrI;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thDeliveryTerms: WideString;
begin
  Result := FTH.DelTerms;
end;

procedure TXmlTransaction.Set_thDeliveryTerms(const Value: WideString);
begin
  FTH.DelTerms := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thDocType: TXmlDocTypes;
var
  s : string;
begin
  s := FTH.TransDocHed;
  if s = 'PIN' then Result := dtPIN else
  if s = 'POR' then Result := dtPOR else
  if s = 'SIN' then Result := dtSIN else
  if s = 'SOR' then Result := dtSOR;


end;

{-----------------------------------------}

function TXmlTransaction.Get_thDueDate: WideString;
begin
  Result := FTH.DueDate;
end;

procedure TXmlTransaction.Set_thDueDate(const Value: WideString);
begin
  FTH.DueDate := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thFixedRate: WordBool;
begin
  Result := FTH.SOPKeepRate;
end;

procedure TXmlTransaction.Set_thFixedRate(Value: WordBool);
begin
  FTH.SOPKeepRate := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thHoldFlag: Smallint;
begin
  Result := FTH.HoldFlg;
end;

procedure TXmlTransaction.Set_thHoldFlag(Value: Smallint);
begin
  FTH.HoldFlg := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thJobCode: WideString;
begin
  Result := FTH.DJobCode;
end;

procedure TXmlTransaction.Set_thJobCode(const Value: WideString);
begin
  FTH.DJobCode := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thManualVAT: WordBool;
begin
  Result := FTH.ManVAT;
end;

procedure TXmlTransaction.Set_thManualVAT(Value: WordBool);
begin
  FTH.ManVAT := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thNetValue: Double;
begin
  Result := FTH.InvNetVal;
end;

procedure TXmlTransaction.Set_thNetValue(Value: Double);
begin
  FTH.InvNetVal := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thNoLabels: Smallint;
begin
  Result := FTH.thNoLabels;
end;

procedure TXmlTransaction.Set_thNoLabels(Value: Smallint);
begin
  FTH.thNoLabels := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thOutstanding: WideString;
begin
  Result := FTH.AllocStat;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thPeriod: Smallint;
begin
  Result := FTH.AcPr;
end;

procedure TXmlTransaction.Set_thPeriod(Value: Smallint);
begin
  FTH.AcPr := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thPORPickSOR: WordBool;
begin
  Result := FTH.PORPickSOR;
end;

procedure TXmlTransaction.Set_thPORPickSOR(Value: WordBool);
begin
  FTH.PORPickSOR := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thPostedDate: WideString;
begin
  Result := FTH.PostDate;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thPrePost: Integer;
begin
  Result := FTH.PrePostFlg;
end;

procedure TXmlTransaction.Set_thPrePost(Value: Integer);
begin
  FTH.PrePostFlg := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thPrinted: WordBool;
begin
  Result := FTH.PrintedDoc;
end;

{-----------------------------------------}


function TXmlTransaction.Get_thSettleDiscAmount: Double;
begin
  Result := FTH.DiscSetAm;
end;

procedure TXmlTransaction.Set_thSettleDiscAmount(Value: Double);
begin
  FTH.DiscSetAm := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thSettleDiscDays: Smallint;
begin
  Result := FTH.DiscDays;
end;

procedure TXmlTransaction.Set_thSettleDiscDays(Value: Smallint);
begin
  FTH.DiscDays := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thSettleDiscPerc: Double;
begin
  Result := FTH.DiscSetl;
end;

procedure TXmlTransaction.Set_thSettleDiscPerc(Value: Double);
begin
  FTH.DiscSetl := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thSettleDiscTaken: WordBool;
begin
  Result := FTH.DiscTaken;
end;

procedure TXmlTransaction.Set_thSettleDiscTaken(Value: WordBool);
begin
  FTH.DiscTaken := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thSource: Integer;
begin
  Result := FTH.ExtSource;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thTagged: WordBool;
begin
  Result := FTH.Tagged <> 0;
end;

procedure TXmlTransaction.Set_thTagged(Value: WordBool);
begin
  if Value then
    FTH.Tagged := 1
  else
    FTH.Tagged := 0;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thTotalCost: Double;
begin
  Result := FTH.TotalCost;
end;

procedure TXmlTransaction.Set_thTotalCost(Value: Double);
begin
  FTH.TotalCost := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thTotalLineDiscount: Double;
begin
  Result := FTH.DiscAmount;
end;

procedure TXmlTransaction.Set_thTotalLineDiscount(Value: Double);
begin
  FTH.DiscAmount := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thTotalOrderOS: Double;
begin
  Result := FTH.TotOrdOS;
end;

procedure TXmlTransaction.Set_thTotalOrderOS(Value: Double);
begin
  FTH.TotOrdOS := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thTotalVAT: Double;
begin
  Result := FTH.InvVAT;
end;

procedure TXmlTransaction.Set_thTotalVAT(Value: Double);
begin
  FTH.InvVAT := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thTotalWeight: Double;
begin
  Result := FTH.TotalWeight;
end;

procedure TXmlTransaction.Set_thTotalWeight(Value: Double);
begin
  FTH.TotalWeight := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thTransDate: WideString;
begin
  Result := FTH.TransDate;
end;

procedure TXmlTransaction.Set_thTransDate(const Value: WideString);
begin
  FTH.TransDate := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thTransportMode: Smallint;
begin
  Result := FTH.TransMode;
end;

procedure TXmlTransaction.Set_thTransportMode(Value: Smallint);
begin
  FTH.TransMode := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thTransportNature: Smallint;
begin
  Result := FTH.TransNat;
end;

procedure TXmlTransaction.Set_thTransportNature(Value: Smallint);
begin
  FTH.TransNat := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thOperator: WideString;
begin
  Result := FTH.OpName;
end;

procedure TXmlTransaction.Set_thOperator(const Value: WideString);
begin
  FTH.OpName := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thUserField1: WideString;
begin
  Result := FTH.DocUser1;
end;

procedure TXmlTransaction.Set_thUserField1(const Value: WideString);
begin
  FTH.DocUser1 := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thUserField2: WideString;
begin
  Result := FTH.DocUser2;
end;

procedure TXmlTransaction.Set_thUserField2(const Value: WideString);
begin
  FTH.DocUser2 := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thUserField3: WideString;
begin
  Result := FTH.DocUser3;
end;

procedure TXmlTransaction.Set_thUserField3(const Value: WideString);
begin
  FTH.DocUser3 := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thUserField4: WideString;
begin
  Result := FTH.DocUser4;
end;

procedure TXmlTransaction.Set_thUserField4(const Value: WideString);
begin
  FTH.DocUser4 := Value;
end;

{-----------------------------------------}


function TXmlTransaction.Get_thYear: Smallint;
begin
  Result := FTH.AcYr;
end;

procedure TXmlTransaction.Set_thYear(Value: Smallint);
begin
  FTH.AcYr := Value;
end;

{-----------------------------------------}

function TXmlTransaction.Get_thLongYourRef: WideString;
begin
  Result := FTH.LongYrRef;
end;

procedure TXmlTransaction.Set_thLongYourRef(Const Value: WideString);
begin
  FTH.LongYrRef := Value;
end;
{-----------------------------------------}

function TXmlTransaction.Get_thLines: IXmlTransactionLines;
begin
  If (Not Assigned(FTHLinesO)) Then Begin
    { Create and initialise the Transaction Lines sub-object }
    FTHLinesO := TXmlTransactionLines.Create(Self);

    FTHLinesI := FTHLinesO;
  End; { If (Not Assigned(FTHLinesO)) }

  Result := FTHLinesI;
end;

{-----------------------------------------}


procedure TXmlTransaction.InitTransRec;
begin
  FillChar (FTH, SizeOf(FTH), #0);
end;



{-----------------------------------------}

function TXmlTransaction.Get_thEmployeeCode: WideString;
begin
  Result := FTH.EmpCode;
end;

procedure TXmlTransaction.Set_thEmployeeCode(Const Value: WideString);
begin
  FTH.EmpCode := Value;
end;

{-----------------------------------------}

{-----------------------------------------}

procedure TXmlTransaction.Set_thDocType(Value: TxmlDocTypes);
begin
  Case Value of
    dtPIN  : FTH.TransDocHed := 'PIN';
    dtPOR  : FTH.TransDocHed := 'POR';
    dtSIN  : FTH.TransDocHed := 'SIN';
    dtSOR  : FTH.TransDocHed := 'SOR';
    dtSCR  : FTH.TransDocHed := 'SCR';
    else
    {  raise Exception.};
  end;{case}
end;

function TXmlTransaction.ValidateCurrencyNo(Value : SmallInt) : SmallInt;
begin
  Result := Value;
end;

procedure TXmlTransaction.WriteXML(const APath: WideString);
var
  i, j, c  : integer;
  poLine : pTransLineType;
  oLine : TXmlTransactionLine;
  FAuxLines : t2xAuxLines;
  SetVat : Boolean;
  Res : integer;
  ErrorString : string;
  NarrRec : TXmlNarrativeRec;
  Serialrec : TXmlSerialBatchDetailRec;
  NCount, SBCount : longint;
  NarrPtr, SerialPtr : Pointer;
  RecPos : longint;
  RecOffset : longint;
  OutPath, OutFile : string;
  AllocatedMem : Int64;
begin
  Res := STATUS_NO_TRANSACTIONS;//Until we know better
  inc(Count);
  if Assigned(FThLinesO) then
  begin
    //get default output dir from xmlwriter.configuration
    FOutDir := TXMLWriter(FParent).ConfigurationObject.OutputDir;
    //Check parameter for file name & path;
    OutFile := ExtractFileName(APath);
    OutPath := ExtractFilePath(APath);
    if OutPath = '' then
      OutPath := FOutDir;

    FAuxRec.SaveDir := OutPath;
    FAuxRec.SaveFileName := OutFile;

    if TXMLWriter(FParent).ConfigurationObject.TransferMode = xrReplication then
      FAuxRec.TransferMode := tfrReplication;
    SetVat := ZeroFloat(FTH.InvVat);
    FTH.LineCount := FThLinesI.thLineCount;
    c := FTH.LineCount;
    if FTH.LineCount > 0 then
    begin
      FillChar(THLinesRec, SizeOf(THLinesRec), #0);
//      for i := 1 to FTH.LineCount do
      i := 1;
      while i <= c do
//      for i := 1 to c do
      begin
        poLine := FThLinesO.Lines.Items[i-1];
        oLine := poLine^.TLO;
        THLinesRec[i] := oLine.TL;
        FAuxLines[i] := oLine.AuxLine;
        if SetVat then
          FTH.InvVat := FTH.InvVat + THLinesRec[i].VAT;

        FTH.InvNetVal := FTH.InvNetVal + (THLinesRec[i].Qty * THLinesRec[i].NetValue);
        inc(i);
      end;
      NCount := 0;
      NarrPtr := nil;
      if Assigned(FNarrativeO) then
      begin
        NCount := FNarrativeI.ntLineCount;
        if  NCount > 0 then
        begin
          GetMem(NarrPtr, NCount * SizeOf(TXmlNarrativeRec));
          for i := 0 to NCount - 1 do
          begin
            FillChar(NarrRec, SizeOf(NarrRec), #0);
            NarrRec.Text := FNarrativeI.ntLine[i];

            RecPos:=LongInt(NarrPtr)+( i* SizeOf(NarrRec));
            Move(NarrRec,Pointer(RecPos)^,SizeOf(NarrRec));
          end;
        end;
      end;

      //Pass through the serial number records for all lines as one block of
      //memory
      SerialPtr := nil;
      SbCount := 0;
      RecOffSet := 0;
      for j := 1 to FTH.LineCount do
        sbCount := sbCount + FThLinesI.thLine[j].tlXmlSerialBatch.sbLineCount;
        //sbCount now has total no of Serial Recs

        if  sbCount > 0 then
        begin
          GetMem(SerialPtr, SbCount * SizeOf(TXmlSerialBatchDetailRec));

          for j := 1 to FTH.LineCount do
          begin
            for i := 0 to FThLinesI.thLine[j].tlXmlSerialBatch.sbLineCount - 1 do
            begin
              FillChar(SerialRec, SizeOf(SerialRec), #0);
              SerialRec.FLineNo := FThLinesI.thLine[j].tlLineNo;
              SerialRec.FType := FThLinesI.thLine[j].tlXmlSerialBatch.sbLine[i].snType;
              SerialRec.FSerialNo := FThLinesI.thLine[j].tlXmlSerialBatch.sbLine[i].snSerialNo;
              SerialRec.FBatchNo := FThLinesI.thLine[j].tlXmlSerialBatch.sbLine[i].snBatchNo;


              RecPos:=LongInt(SerialPtr)+ RecOffset;
              Move(SerialRec,Pointer(RecPos)^,SizeOf(SerialRec));

              RecOffSet := RecOffSet +  SizeOf(SerialRec);

            end; //for i
          end;  //for j
        end;  //if sbcount > 0



      Res := WriteXmlTransactionFile(@FTH, @THLinesRec,
                                     SizeOf(FTH), SizeOf(THLinesRec),
                                     @FAuxRec, @FAuxLines,
                                     SizeOf(FAuxRec), SizeOf(FAuxLines),
                                     NarrPtr, SizeOf(TXmlNarrativeRec) *
                                      NCount,
                                     SerialPtr, SizeOf(TXmlSerialBatchDetailRec) *
                                      SBCount );
          if NCount > 0 then
            FreeMem(NarrPtr, NCount * SizeOf(TXmlNarrativeRec));
          if SbCount > 0 then
            FreeMem(SerialPtr, SbCount * SizeOf(TXmlSerialBatchDetailRec));


    end;//LineCount > 0
  end;
  if Res <> 0 then
  begin
    Case Res of
        STATUS_NOT_IMPLEMENTED : ErrorString :=
                                    'Function not implemented';
        STATUS_INVALID_OUTPUT_DIR :
                                 ErrorString :=
                                     'Invalid Output Directory';
        STATUS_INVALID_TRANS_TYPE : ErrorString :=
                                     'Invalid Transaction Type';
        STATUS_INVALID_OUTPUT_FILE :
                                 ErrorString :=
                                     'Invalid Output File';
        STATUS_NO_TRANSACTIONS : ErrorString :=
                                      'No Transactions to write';

        STATUS_INVALID_HEADER_SIZE..STATUS_INVALID_SERIAL_SIZE :
                              ErrorString :=
                                'Invalid ' + SizeErr[Res] + ' record size';
    end;{case}
    Raise Exception.Create(ErrorString);
  end;{Res <> 0}

end;


function TXmlTransaction.Get_thCustSuppAddress: IXmlAddress;
begin
  If (Not Assigned(FInvAddrO)) Then Begin
    { Create and initialise Customer Address Sub-Object}
    FInvAddrO := TXmlAddress.Create(1, GetCSAddrLine, SetCSAddrLine);

    FInvAddrI := FInvAddrO;
  End; { If (Not Assigned(FDelAddrO)) }

  Result := FInvAddrI;
end;

function TXmlTransaction.Get_thCustSuppName: WideString;
begin
  Result := FAuxRec.CustSuppName;
end;

function TXmlTransaction.Get_thOurAddress: IXmlAddress;
begin
  If (Not Assigned(FSysAddrO)) Then Begin
    { Create and initialise Customer Address Sub-Object}
    FSysAddrO := TXmlAddress.Create(1, GetOurAddrLine, SetOurAddrLine);

    FSysAddrI := FSysAddrO;
  End; { If (Not Assigned(FDelAddrO)) }

  Result := FSysAddrI;


end;

function TXmlTransaction.Get_thOurName: WideString;
begin
  Result := FAuxRec.OurName;
end;

procedure TXmlTransaction.Set_thCustSuppName(const Value: WideString);
begin
  FAuxRec.CustSuppName := Copy(Value, 1, 45);
end;

procedure TXmlTransaction.Set_thOurName(const Value: WideString);
begin
  FAuxRec.OurName := Copy(Value, 1, 45);
end;

function TXmlTransaction.GetCSAddrLine (AddrIdx, Idx : Byte) : String;
begin
  Result := FAuxRec.CustSuppAdd[Idx];
end;

Procedure TXmlTransaction.SetCSAddrLine(AddrIdx, Idx : Byte; Value : String);
begin
  FAuxRec.CustSuppAdd[Idx] := Value;
end;

function TXmlTransaction.GetOurAddrLine (AddrIdx, Idx : Byte) : String;
begin
  Result := FAuxRec.OurAdd[Idx];
end;

Procedure TXmlTransaction.SetOurAddrLine(AddrIdx, Idx : Byte; Value : String);
begin
  FAuxRec.OurAdd[Idx] := Value;
end;



function TXmlTransaction.Get_thOurVatReg: WideString;
begin
  Result := FAuxRec.OurVatReg;
end;

procedure TXmlTransaction.Set_thOurVatReg(const Value: WideString);
begin
  FAuxRec.OurVatReg := Value;
end;

function TXmlTransaction.Get_thUseCCDept: WordBool;
begin
  Result := FAuxRec.UseCCDept;
end;

procedure TXmlTransaction.Set_thUseCCDept(Value: WordBool);
begin
  FAuxRec.UseCCDept := Value;
end;

function TXmlTransaction.Get_thXslUrl: WideString;
begin
  Result := FAuxRec.XslLocation;
end;

procedure TXmlTransaction.Set_thXslUrl(const Value: WideString);
begin
  FAuxRec.XslLocation := Value;
end;

function TXmlTransaction.Get_thCurrencyCode: WideString;
begin
  Result := FAuxRec.CurrCode;
end;

function TXmlTransaction.Get_thCurrencyName: WideString;
begin
  Result := FAuxRec.CurrName;
end;

procedure TXmlTransaction.Set_thCurrencyCode(const Value: WideString);
begin
  FAuxRec.CurrCode := Value;
end;

procedure TXmlTransaction.Set_thCurrencyName(const Value: WideString);
begin
  FAuxRec.CurrName := Value;
end;

function TXmlTransaction.Get_thContactName: WideString;
begin
  Result := FAuxRec.ContactName;
end;

procedure TXmlTransaction.Set_thContactName(const Value: WideString);
begin
  FAuxRec.ContactName := Value;
end;

function TXmlTransaction.Get_thContactFax: WideString;
begin
  Result := FAuxRec.ContactFax;
end;

function TXmlTransaction.Get_thContactPhone: WideString;
begin
  Result := FAuxRec.ContactPhone;
end;

procedure TXmlTransaction.Set_thContactFax(const Value: WideString);
begin
  FAuxRec.ContactFax := Value;
end;

procedure TXmlTransaction.Set_thContactPhone(const Value: WideString);
begin
  FAuxRec.ContactPhone := Value;
end;

function TXmlTransaction.Get_thCostDecPlaces: Integer;
begin
  Result := FAuxRec.CostDP;
end;

function TXmlTransaction.Get_thPriceDecPlaces: Integer;
begin
  Result := FAuxRec.PriceDP;
end;

function TXmlTransaction.Get_thQuantDecPlaces: Integer;
begin
  Result := FAuxRec.QuantityDP;
end;

procedure TXmlTransaction.Set_thCostDecPlaces(Value: Integer);
begin
  FAuxRec.CostDP := Value;
end;

procedure TXmlTransaction.Set_thPriceDecPlaces(Value: Integer);
begin
  FAuxRec.PriceDP := Value;
end;

procedure TXmlTransaction.Set_thQuantDecPlaces(Value: Integer);
begin
    FAuxRec.QuantityDP := Value;
end;

function TXmlTransaction.Get_thCalcLineTotals: WordBool;
begin
end;

procedure TXmlTransaction.Set_thCalcLineTotals(Value: WordBool);
begin
end;

function TXmlTransaction.Get_thNarrative: IXmlNarrative;
begin
  if not Assigned(FNarrativeO) then
  begin
    FNarrativeO := TXmlNarrative.Create;

    FNarrativeI := FNarrativeO;
  end;

  Result := FNarrativeI;

end;


procedure TXmlTransaction.Clear;
begin
  FillChar(FTH, SizeOf(FTH), #0);
  FillChar(FAuxRec, SizeOf(FAuxRec), #0);

  //Now set everything to nil;
  InitObjects;
  //Set dec places, etc.
  SetDefaults;
end;

function  TXmlTransaction.Get_thContactPhone2: WideString;
begin
  Result := FAuxRec.ContactPhone2;
end;

procedure TXmlTransaction.Set_thContactPhone2(const Value: WideString);
begin
  FAuxRec.ContactPhone2 := Value;
end;

function TXmlTransaction.Get_thTheirCodeForUs: WideString;
begin
  Result := FAuxRec.TheirCodeForUs;
end;

procedure TXmlTransaction.Set_thTheirCodeForUs(const Value: WideString);
begin
  FAuxRec.TheirCodeForUs := Value;
end;

function TXmlTransaction.Get_thTagNo: Integer;
begin
  Result := FTH.Tagged;
end;

procedure TXmlTransaction.Set_thTagNo(Value: Integer);
begin
  FTH.Tagged := Value;
end;



//PR: 01/02/2013 ABSEXCH-13134 Add UDFs 5-10
function TXmlTransaction.Get_thUserfield10: WideString;
begin
  Result := FTH.DocUser10;
end;

function TXmlTransaction.Get_thUserField5: WideString;
begin
  Result := FTH.DocUser5;
end;

function TXmlTransaction.Get_thUserField6: WideString;
begin
  Result := FTH.DocUser6;
end;

function TXmlTransaction.Get_thUserField7: WideString;
begin
  Result := FTH.DocUser7;
end;

function TXmlTransaction.Get_thUserField8: WideString;
begin
  Result := FTH.DocUser8;
end;

function TXmlTransaction.Get_thUserField9: WideString;
begin
  Result := FTH.DocUser9;
end;

procedure TXmlTransaction.Set_thUserfield10(const Value: WideString);
begin
  FTH.DocUser10 := Value;
end;

procedure TXmlTransaction.Set_thUserField5(const Value: WideString);
begin
  FTH.DocUser5 := Value;
end;

procedure TXmlTransaction.Set_thUserField6(const Value: WideString);
begin
  FTH.DocUser6 := Value;
end;

procedure TXmlTransaction.Set_thUserField7(const Value: WideString);
begin
  FTH.DocUser7 := Value;
end;

procedure TXmlTransaction.Set_thUserField8(const Value: WideString);
begin
  FTH.DocUser8 := Value;
end;

procedure TXmlTransaction.Set_thUserField9(const Value: WideString);
begin
  FTH.DocUser9 := Value;
end;
//PR: 16/10/2013 ABSEXCH-14703 IXmlTransaction4 thDeliveryPostcode
function TXmlTransaction.Get_thDeliveryPostcode: WideString;
begin
  Result := FTH.thDeliveryPostcode;
end;

procedure TXmlTransaction.Set_thDeliveryPostcode(const Value: WideString);
begin
  FTH.thDeliveryPostcode := Value;
end;

//PR: 24/01/2015 v7.0.14 ABSEXCH-16284 ITransaction12 New fields for Prompt Payment Discount
function TXMLTransaction.Get_thPPDPercentage: Double; safecall;
begin
  Result := FTH.thPPDPercentage;
end;

procedure TXMLTransaction.Set_thPPDPercentage(Value: Double); safecall;
begin
  FTH.thPPDPercentage := Value;
end;

function TXMLTransaction.Get_thPPDDays: SmallInt; safecall;
begin
  Result := FTH.thPPDDays;
end;

procedure TXMLTransaction.Set_thPPDDays(Value: SmallInt); safecall;
begin
  FTH.thPPDDays := Value;
end;

function TXMLTransaction.Get_thPPDVATValue: Double; safecall;
begin
  Result := FTH.thPPDVATValue;
end;

function TXMLTransaction.Get_thPPDTaken: TPPDTakenMode; safecall;
begin
  Result := FTH.thPPDTaken;
end;

procedure TXMLTransaction.Set_thPPDTaken(Value: TPPDTakenMode); safecall;
begin
  FTH.thPPDTaken := Value;
end;

function TXMLTransaction.Get_thPPDGoodsValue: Double; safecall;
begin
  Result := FTH.thPPDGoodsValue;
end;

procedure TXmlTransaction.Set_thPPDGoodsValue(Value: Double);
begin
  FTH.thPPDGoodsValue := Value;
end;

procedure TXmlTransaction.Set_thPPDVATValue(Value: Double);
begin

end;

Initialization
    Count := 0;
end.
