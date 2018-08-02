IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_Period]'))
DROP VIEW [!ActiveSchema!].[evw_Period]
GO

CREATE VIEW !ActiveSchema!.evw_Period WITH VIEW_METADATA
AS
SELECT *
FROM !ActiveSchema!.efn_Period()

GO