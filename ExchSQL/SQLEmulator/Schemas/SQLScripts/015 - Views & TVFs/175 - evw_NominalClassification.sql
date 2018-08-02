IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_NominalClassification]'))
DROP VIEW [common].[evw_NominalClassification]
GO


CREATE VIEW common.evw_NominalClassification WITH VIEW_METADATA
AS
SELECT NC.*
FROM ( VALUES (10, 'BA', 'Bank Account')
            , (20, 'CS', 'Closing Stock')
            , (30, 'FG', 'Finished Goods')
            , (40, 'SV', 'Stock Value')
            , (50, 'WW', 'WOP WIP')
            , (60, 'OH', 'Overheads')
            , (70, 'MISC', 'Miscellaneous')
            , (80, 'SR', 'Sales Return')
            , (90, 'PR', 'Purchase Return')
        ) NC ( NominalClassificationId
             , NominalClassificationCode
             , NominalClassificationDescription
             )

GO