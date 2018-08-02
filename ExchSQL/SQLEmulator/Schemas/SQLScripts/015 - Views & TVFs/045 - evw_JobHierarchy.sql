IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobHierarchy]'))
DROP VIEW [!ActiveSchema!].[evw_JobHierarchy]
GO

CREATE VIEW !ActiveSchema!.evw_JobHierarchy
AS
SELECT *
FROM !ActiveSchema!.efn_JobHierarchy()

GO


