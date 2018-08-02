
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_SupplierDiscount]'))
DROP VIEW [!ActiveSchema!].[evw_SupplierDiscount]
GO

CREATE VIEW !ActiveSchema!.evw_SupplierDiscount WITH VIEW_METADATA
AS
SELECT PositionId
     , SupplierCode   = DCCode
     , StockCode    = Exstchkvar2Trans1
     , Currency     = CustQBCurr
     , DiscountType = CustQBType
     , Price        = CustQSPrice
     , Band         = CustQBand
     , DiscountP    = CustQDiscP
     , DiscountA    = CustQDiscA
     , Markup       = CustQMUMG
     , UseDates     = CUseDates
     , StartDate    = CStartD
     , EndDate      = CEndD
     , QtyBreakFolio

FROM   !ActiveSchema!.ExStkChk
WHERE RecMfix = 'C'
AND   SubType = 'S'

GO