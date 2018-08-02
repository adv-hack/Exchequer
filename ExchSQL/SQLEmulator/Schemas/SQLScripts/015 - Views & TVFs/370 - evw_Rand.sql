IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_Rand]'))
DROP VIEW [common].[evw_Rand]
GO


CREATE VIEW common.evw_Rand
AS SELECT rand = rand()

GO


