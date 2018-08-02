IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_NominalType]'))
DROP VIEW [common].[evw_NominalType]
GO

CREATE VIEW common.evw_NominalType WITH VIEW_METADATA
AS
SELECT NT.*
FROM ( VALUES (1, 'A', 'Profit & Loss')
            , (2, 'B', 'Balance Sheet')
            , (3, 'C', 'Control Codes')
            , (4, 'H', 'Nominal Header')
            , (5, 'F', 'Carried Forward')
        ) NT ( NominalTypeId
             , NominalTypeCode
             , NominalTypeDescription
             )
GO
