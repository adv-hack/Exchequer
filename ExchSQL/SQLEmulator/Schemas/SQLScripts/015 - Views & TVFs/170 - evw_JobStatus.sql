IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_JobStatus]'))
DROP VIEW [common].[evw_JobStatus]
GO

CREATE VIEW common.evw_JobStatus WITH VIEW_METADATA
AS
SELECT *
FROM ( VALUES ( 1, 'Quotation')
            , ( 2, 'Active')
            , ( 3, 'Suspended')
            , ( 4, 'Completed')
            , ( 5, 'Closed')
              
     ) JS ( JobStatusId
          , JobStatusDescription
          )
GO


