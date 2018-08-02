IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_EmployeeType]'))
DROP VIEW [common].[evw_EmployeeType]
GO

CREATE VIEW common.evw_EmployeeType WITH VIEW_METADATA
AS
SELECT ET.*
FROM ( VALUES (1, 'P', 'Production')
            , (2, 'S', 'Sub-Contract')
            , (3, 'O', 'Overhead')
        ) ET ( EmployeeTypeId
             , EmployeeTypeCode
             , EmployeeTypeDescription
             )
GO
