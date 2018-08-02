IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_StockAscendant]'))
DROP VIEW [!ActiveSchema!].[evw_StockAscendant]
GO

CREATE VIEW !ActiveSchema!.evw_StockAscendant
AS
SELECT StockCode               = DescendantStockCode
     , HierarchyLevel          = DescendantHierarchyLevel
     , AscendantStockCode      = StockCode
     , AscendantHierarchyLevel = HierarchyLevel
FROM   !ActiveSchema!.evw_StockDescendant

GO