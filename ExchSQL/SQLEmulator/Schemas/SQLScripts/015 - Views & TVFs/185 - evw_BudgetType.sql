IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_BudgetType]'))
DROP VIEW [common].[evw_BudgetType]
GO

CREATE VIEW common.evw_BudgetType WITH VIEW_METADATA
AS
SELECT BT.*
FROM ( VALUES (0, 'N/A', 'N/A')
            , (1, 'REV', 'Revenue')
            , (2, 'OVH', 'Overhead')
            , (3, 'MTL', 'Materials')
            , (4, 'LAB', 'Labour')
        ) BT ( BudgetTypeId
             , BudgetTypeCode
             , BudgetTypeDescription
             )
GO
