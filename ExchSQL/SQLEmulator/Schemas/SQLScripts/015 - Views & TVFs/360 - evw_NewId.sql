IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_NewId]'))
DROP VIEW [common].[evw_NewId]
GO


CREATE VIEW common.evw_NewId
AS SELECT NewId = NewId()

GO