IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_CISSubType]'))
DROP VIEW [common].[evw_CISSubType]
GO

CREATE VIEW common.evw_CISSubType WITH VIEW_METADATA
AS
SELECT CST.*
FROM ( VALUES (0, 'N/A', 'N/A')
            , (1, 'S',   'Sole Trader')
            , (2, 'P',   'Partnership')
            , (3, 'T',   'Trust')
            , (4, 'C',   'Company')
        ) CST ( CISSubTypeId
              , CISSubTypeCode
              , CISSubTypeDescription
              )
GO
