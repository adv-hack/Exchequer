
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_StockType]'))
DROP VIEW [common].[evw_StockType]
GO

CREATE VIEW common.evw_StockType WITH VIEW_METADATA
AS
SELECT *
FROM   ( VALUES ('G', 'Group')
              , ('P', 'Product')
              , ('D', 'Description Only')
              , ('M', 'Bill of Material')
              , ('X', 'Discontinued')
       ) StockTypes ( StockTypeCode
                    , StockTypeDescription)

GO