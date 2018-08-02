IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_CISType]'))
DROP VIEW [common].[evw_CISType]
GO

CREATE VIEW common.evw_CISType WITH VIEW_METADATA
AS
SELECT CT.*
FROM ( VALUES (0, 'N/A',   'N/A')
            , (1, 'CIS4',  'High')
            , (2, 'CIS5',  'Zero')
            , (3, 'CIS6',  'CIS 6 Group')
            , (4, 'CIS4P', 'Low')
            , (5, 'CIS5P', 'CIS 5 Partner')
        ) CT ( CISTypeId
             , CISTypeCode
             , CISTypeDescription
             )
GO
