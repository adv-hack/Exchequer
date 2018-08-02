IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_StockHierarchy]'))
DROP VIEW [!ActiveSchema!].[evw_StockHierarchy]
GO

CREATE VIEW !ActiveSchema!.evw_StockHierarchy
AS
SELECT *
FROM !ActiveSchema!.efn_StockHierarchy()

GO


