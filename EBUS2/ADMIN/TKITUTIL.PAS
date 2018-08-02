unit TKitUtil;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  VarConst, UseTKit;

procedure TransLineToTKitTransLine(const FileLine : IDetail; var TKitLine : TBatchTLRec);

implementation

uses
  EBusUtil, CurrncyU, TKUtil;

{
  Don't THINK need to do this ???
type
  WordBool = smallint;
}

procedure TransLineToTKitTransLine(const FileLine : IDetail; var TKitLine : TBatchTLRec);
begin
  FillChar(TKitLine, SizeOf(TKitLine), 0);
  with TKitLine do
  begin

    TransRefNo := FileLine.DocPRef;
    FolioNum := FileLine.FolioRef;
    LineNo := FileLine.LineNo;
    NomCode := FileLine.NomCode;
    Currency := FileLine.Currency;

    if IsMultiCurrency then
      CoRate:=XRate(FileLine.CXRate,UseCoDayRate,FileLine.Currency)
    else
      CoRate:=FileLine.CXRate[false];
    VATRate := FileLine.CXRate[true];

    CC := FileLine.CCDep[true];
    Dep:=FileLine.CCDep[false];

    Payment := {ord}(FileLine.LineNo=RecieptCode);
    StockCode:=FileLine.StockCode;

(*  This is the original Toolkit code - presumably OK to just use
    the straight assignment above as only working with SIN, PIN, SOR and POR
    If (Payment <> 0) then
      if FileLine.PostedRun > 0 then
        StockCode := Extract_PayRef2(Id.StockCode)
      else
        StockCode := Extract_PayRef1(Id.StockCode)
    else
      StockCode:=Id.Stockcode;

    If (Payment <> 0) and (Id.IDDocHed In StkAdjSplit) then
      StockCode:=Id.StockCode; *)

    Qty := FileLine.Qty;
    QtyMul := FileLine.QtyMul;
    NetValue := FileLine.NetValue;
    Discount := FileLine.Discount;
    VATCode := FileLine.VATCode;
    VAT := FileLine.VAT;

    DiscountChr := FileLine.DiscountChr;
    QtyWOff := FileLine.QtyWOff;
    QtyDel:=FileLine.QtyDel;
    CostPrice:=FileLine.CostPrice;
    CustCode:=FileLine.CustCode;
    LineDate:=FileLine.PDate;
    Item:=FileLine.Item;
    Desc:=FileLine.Desc;
    LWeight:=FileLine.LWeight;
    MLocStk:=FileLine.MLocStk;
    JobCode:=FileLine.JobCode;
    AnalCode:=FileLine.AnalCode;
    If (FileLine.IdDocHed In TSTSplit) then
      TSHCCurr := FileLine.Reconcile
    else
      Reconcile := FileLine.Reconcile;

    DocLTLink:=FileLine.DocLTLink;
    KitLink:=FileLine.KitLink;

    LineType:=FileLine.LineType;

    SOPLink:=FileLine.SOPLink;
    SOPLineNo:=FileLine.SOPLineNo;

    ABSLineNo:=FileLine.ABSLineNo;

    LineUser1:=FileLine.LineUser1;
    LineUser2:=FileLine.LineUser2;
    LineUser3:=FileLine.LineUser3;
    LineUser4:=FileLine.LineUser4;

    SSDUplift:=FileLine.SSDUplift;
    SSDCommod:=FileLine.SSDCommod;
    SSDSPUnit:=FileLine.SSDSPUnit;
    SSDCountry:=FileLine.SSDcountry;

    SSDUseLine:={ord}(FileLine.SSDUseLine);
    PriceMulx:=FileLine.PriceMulx;
    VATIncFlg:=FileLine.VATIncFlg;
    QtyPick:=FileLine.QtyPick;

    //PR: 26/05/2009 Advanced Discount fields
    tlMultiBuyDiscount := FileLine.Discount2;
    tlMultiBuyDiscountChr := FileLine.Discount2Chr;
    tlTransValueDiscount := FileLine.Discount3;
    tlTransValueDiscountChr := FileLine.Discount3Chr;
    tlTransValueDiscountType := FileLine.Discount3Type;

  end;
end;


end.
