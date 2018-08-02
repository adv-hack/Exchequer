IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_DiscountType]'))
DROP VIEW [common].[evw_DiscountType]
GO


CREATE VIEW common.evw_DiscountType WITH VIEW_METADATA
AS
SELECT *
FROM ( VALUES ( 'Q', 'Qty Breaks' )
            , ( 'B', 'Band price (less discount)' )
            , ( 'P', 'Special Price' )
            , ( 'M', 'Margin %' )
            , ( 'U', 'Markup %' )
            ) Dtype ( DiscountType
                    , DiscountTypeDescription)

GO
              