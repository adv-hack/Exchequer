IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_AnonymisationStatus]'))
DROP VIEW [common].[evw_AnonymisationStatus]
GO

CREATE VIEW common.evw_AnonymisationStatus WITH VIEW_METADATA
AS
SELECT *
FROM ( VALUES (  0, 'Not Requested')
            , (  1, 'Pending')
            , (  2, 'Anonymised')
     ) AnonStat ( AnonymisationStatusId
				, AnonymisationStatusDescription
				)
GO


