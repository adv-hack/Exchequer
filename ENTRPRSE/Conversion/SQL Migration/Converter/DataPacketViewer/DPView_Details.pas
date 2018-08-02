unit DPView_Details;

interface

Uses SysUtils, StdCtrls;

Procedure ProcessDetails(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);

implementation

Uses VarConst, DpViewFuncs;

//=========================================================================

Procedure ProcessDetails(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);
Begin // ProcessDetails
  If (DataBlockLen = SizeOf(Id)) Then
  Begin
    Move (DataBlock^, Id, SizeOf(Id));

    OutputMemo.Lines.Add ('Details');
    OutputMemo.Lines.Add ('-------');

    OutputInteger (OutputMemo, 'FolioRef',      Id.FolioRef);
    OutputInteger (OutputMemo, 'LineNo',        Id.LineNo);
    OutputInteger (OutputMemo, 'PostedRun',     Id.PostedRun);
    OutputInteger (OutputMemo, 'NomCode',       Id.NomCode);
    OutputInteger (OutputMemo, 'NomMode',       Id.NomMode);
    OutputInteger (OutputMemo, 'Currency',      Id.Currency);
    OutputInteger (OutputMemo, 'PYr',           Id.PYr);
    OutputInteger (OutputMemo, 'PPr',           Id.PPr);
    OutputString  (OutputMemo, 'CCDep[False]',  Id.CCDep[False], SizeOf(Id.CCDep[False]) - 1);
    OutputString  (OutputMemo, 'CCDep[True]',   Id.CCDep[True],  SizeOf(Id.CCDep[True]) - 1);
    OutputString  (OutputMemo, 'StockCode',     Id.StockCode,    SizeOf(Id.StockCode) - 1);
    OutputInteger (OutputMemo, 'ABSLineNo',     Id.ABSLineNo);
    OutputChar    (OutputMemo, 'LineType',      Id.LineType);
    OutputInteger (OutputMemo, 'IdDocHed',      Ord(Id.IdDocHed));
    (*
    DLLUpdate  :  Byte;        { Flag to indicated rec being editied by DLL Toolkit! }
    OldSerQty  :  SmallInt;     { No of Serial Items Required }
    *)
    OutputDouble  (OutputMemo, 'Qty',           Id.Qty, 2);
    OutputDouble  (OutputMemo, 'QtyMul',        Id.QtyMul, 2);
    OutputDouble  (OutputMemo, 'NetValue',      Id.NetValue, 2);
    OutputDouble  (OutputMemo, 'Discount',      Id.Discount, 2);
    OutputChar    (OutputMemo, 'VATCode',       Id.VATCode);
    OutputDouble  (OutputMemo, 'VAT',           Id.VAT, 2);
    OutputChar    (OutputMemo, 'Payment',       Id.Payment);
    (*
    OldPBal    :  Real;        { Nominal Value Before Posting as of v4.31, now spare! }
    *)
    OutputInteger (OutputMemo, 'Reconcile',     Id.Reconcile);
    OutputChar    (OutputMemo, 'DiscountChr',   Id.DiscountChr);
    OutputDouble  (OutputMemo, 'QtyWOFF',       Id.QtyWOFF, 2);
    OutputDouble  (OutputMemo, 'QtyDel',        Id.QtyDel, 2);
    OutputDouble  (OutputMemo, 'CostPrice',     Id.CostPrice, 2);
    OutputString  (OutputMemo, 'CustCode',      Id.CustCode, SizeOf(Id.CustCode) - 1);
    OutputString  (OutputMemo, 'PDate',         Id.PDate, SizeOf(Id.PDate) - 1);
    OutputString  (OutputMemo, 'Item',          Id.Item, SizeOf(Id.Item) - 1);
    OutputString  (OutputMemo, 'Desc',          Id.Desc, SizeOf(Id.Desc) - 1);
    OutputString  (OutputMemo, 'JobCode',       Id.JobCode, SizeOf(Id.JobCode) - 1);
    OutputString  (OutputMemo, 'AnalCode',      Id.AnalCode, SizeOf(Id.AnalCode) - 1);
    OutputDouble  (OutputMemo, 'CXrate[False]', Id.CXRate[False], 2);
    OutputDouble  (OutputMemo, 'CXrate[True]',  Id.CXRate[True], 2);
    OutputDouble  (OutputMemo, 'LWeight',       Id.LWeight, 2);
    OutputDouble  (OutputMemo, 'DeductQty',     Id.DeductQty, 2);
    OutputInteger (OutputMemo, 'KitLink',       Id.KitLink);
    OutputInteger (OutputMemo, 'SOPLink',       Id.SOPLink);
    OutputInteger (OutputMemo, 'SOPLineNo',     Id.SOPLineNo);
    OutputString  (OutputMemo, 'MLocStk',       Id.MLocStk, SizeOf(Id.MLocStk) - 1);
    OutputDouble  (OutputMemo, 'QtyPick',       Id.QtyPick, 2);
    OutputDouble  (OutputMemo, 'QtyPWOff',      Id.QtyPWoff, 2);
    (*
    UsePack    :  Boolean;     { Include Qty Mul in Line Calc }
    *)
    OutputDouble  (OutputMemo, 'SerialQty',     Id.SerialQty, 2);
    OutputInteger (OutputMemo, 'COSNomCode',    Id.COSNomCode);
    OutputString  (OutputMemo, 'DocPRef',       Id.DocPRef, SizeOf(Id.DocPRef) - 1);
    OutputInteger (OutputMemo, 'DocLTLink',     Id.DocLTLink);
    (*
    PrxPack    :  Boolean;     { Price is a total price }
    *)
    OutputDouble  (OutputMemo, 'QtyPack',       Id.QtyPack, 2);
    OutputString  (OutputMemo, 'ReconDate',     Id.ReconDate, SizeOf(Id.ReconDate) - 1);
    (*
    ShowCase   :  Boolean;
    *)
    OutputInteger (OutputMemo, 'sdbFolio',      Id.sdbFolio);
    OutputDouble  (OutputMemo, 'OBaseEquiv',    Id.OBaseEquiv, 2);
    OutputInteger (OutputMemo, 'UseORate',      Id.UseORate);
    OutputString  (OutputMemo, 'LineUser1',     Id.LineUser1, SizeOf(Id.LineUser1) - 1);
    OutputString  (OutputMemo, 'LineUser2',     Id.LineUser2, SizeOf(Id.LineUser2) - 1);
    OutputString  (OutputMemo, 'LineUser3',     Id.LineUser3, SizeOf(Id.LineUser3) - 1);
    OutputString  (OutputMemo, 'LineUser4',     Id.LineUser4, SizeOf(Id.LineUser4) - 1);
    OutputDouble  (OutputMemo, 'SSDUplift',     Id.SSDUplift, 2);
    OutputString  (OutputMemo, 'SSDCountry',    Id.SSDCountry, SizeOf(Id.SSDCountry) - 1);
    OutputString  (OutputMemo, 'SSDCountry',    Id.SSDCountry, SizeOf(Id.SSDCountry) - 1);
    OutputChar    (OutputMemo, 'VATIncFlg',     Id.VATIncFlg);
    OutputString  (OutputMemo, 'SSDCommod',     Id.SSDCommod, SizeOf(Id.SSDCommod) - 1);
    OutputDouble  (OutputMemo, 'SSDSPUnit',     Id.SSDSPUnit, 2);
    OutputDouble  (OutputMemo, 'PriceMulx',     Id.PriceMulx, 2);
    OutputInteger (OutputMemo, 'B2BLink',       Id.B2BLink);
    OutputInteger (OutputMemo, 'B2BLineNo',     Id.B2BLineNo);
    (*
    CurrTriR   :  TriCurType;  { Details of Main Triangulation }
    SSDUseLine :  Boolean;     { Take the ssd values from the line }
    *)
    OutputDouble  (OutputMemo, 'PreviousBal',   Id.PreviousBal, 2);
    (*
    LiveUplift :  Boolean;     { Flag to tell recon report to include any uplift }
    *)
    OutputDouble  (OutputMemo, 'COSConvRate',   Id.COSConvRate, 2);
    OutputDouble  (OutputMemo, 'IncNetValue',   Id.IncNetValue, 2);
    OutputInteger (OutputMemo, 'AutoLineType',  Id.AutoLineType);
    OutputChar    (OutputMemo, 'CISRateCode',   Id.CISRateCode);
    OutputDouble  (OutputMemo, 'CISRate',       Id.CISRate, 2);
    OutputDouble  (OutputMemo, 'CostApport',    Id.CostApport, 2);
    OutputInteger (OutputMemo, 'NOMIOFlg',      Id.NOMIOFlg);
    OutputDouble  (OutputMemo, 'BinQty',        Id.BinQty, 2);
    OutputDouble  (OutputMemo, 'CISAdjust',     Id.CISAdjust, 2);
    OutputInteger (OutputMemo, 'JAPDedType',    Id.JAPDedType);
    OutputDouble  (OutputMemo, 'SerialRetQty',  Id.SerialRetQty, 2);
    OutputDouble  (OutputMemo, 'BinRetQty',     Id.binRetQty, 2);
    OutputDouble  (OutputMemo, 'Discount2',     Id.Discount2, 2);
    OutputChar    (OutputMemo, 'Discount2Chr',  Id.Discount2Chr);
    OutputDouble  (OutputMemo, 'Discount3',     Id.Discount3, 2);
    OutputChar    (OutputMemo, 'Discount3Chr',  Id.Discount3Chr);
    OutputInteger (OutputMemo, 'Discount3Type', Id.Discount3Type);
    (*
    ECService          : Boolean;
    *)
    OutputString  (OutputMemo, 'ServiceStartDate',   Id.ServiceStartDate, SizeOf(Id.ServiceStartDate) - 1);
    OutputString  (OutputMemo, 'ServiceEndDate',     Id.ServiceEndDate,   SizeOf(Id.ServiceEndDate) - 1);
    OutputDouble  (OutputMemo, 'ECSalesTaxReported', Id.ECSalesTaxReported, 2);
    OutputDouble  (OutputMemo, 'PurchaseServiceTax', Id.PurchaseServiceTax, 2);
    OutputString  (OutputMemo, 'tlReference',    Id.tlReference, SizeOf(Id.tlReference) - 1);
    OutputString  (OutputMemo, 'tlReceiptNo',    Id.tlReceiptNo, SizeOf(Id.tlReceiptNo) - 1);
    OutputString  (OutputMemo, 'tlFromPostCode', Id.tlFromPostCode, SizeOf(Id.tlFromPostCode) - 1);
    OutputString  (OutputMemo, 'tlToPostCode',   Id.tlToPostCode, SizeOf(Id.tlToPostCode) - 1);
    (*
    LineUser5  : String[30];  { Line user def }
    LineUser6  : String[30];  { Line user def }
    LineUser7  : String[30];  { Line user def }
    LineUser8  : String[30];  { Line user def }
    LineUser9  : String[30];  { Line user def }
    LineUser10 : String[30];  { Line user def }
    tlThresholdCode : String[12];  // LIVE Threshold Code
    tlMaterialsOnlyRetention: Boolean; // For JSA/JST transactions
    Spare2     : Array[1..159] of Byte;
    *)
  End // If (DataBlockLen = SizeOf(Id))
  Else
    OutputMemo.Lines.Add ('*** Document - Id Invalid Size - ' + IntToStr(SizeOf(Id)) + ' expected, ' + IntToStr(DataBlockLen) + ' received');
End; // ProcessDetails

end.
