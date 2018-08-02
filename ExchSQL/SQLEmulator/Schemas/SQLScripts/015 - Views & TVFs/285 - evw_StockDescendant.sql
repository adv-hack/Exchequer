
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_StockDescendant]'))
DROP VIEW [!ActiveSchema!].[evw_StockDescendant]
GO

CREATE VIEW !ActiveSchema!.evw_StockDescendant
AS
SELECT N.StockCode
     , SH.HierarchyLevel
     , DescendantStockCode
     , DescendantHierarchyLevel
FROM !ActiveSchema!.evw_Stock N
CROSS APPLY ( (SELECT StockCode
                    , HierarchyLevel
               FROM !ActiveSchema!.evw_StockHierarchy NH
               WHERE NH.StockHierarchy LIKE '%~' + CONVERT(VARCHAR(50), N.StockCode) + '~%')
               ) NA ( DescendantStockCode
                    , DescendantHierarchyLevel)
LEFT JOIN !ActiveSchema!.evw_StockHierarchy SH ON SH.StockCode = N.StockCode
GO
