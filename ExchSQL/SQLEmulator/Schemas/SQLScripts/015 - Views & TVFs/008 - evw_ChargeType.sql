IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_ChargeType]'))
DROP VIEW [common].[evw_ChargeType]
GO

CREATE VIEW common.evw_ChargeType WITH VIEW_METADATA
AS
SELECT *
FROM ( VALUES (  1, 'Time & Materials')
            , (  2, 'Fixed Price')
            , (  3, 'Cost plus %')
            , (  4, 'Non-Productive Job')
     ) CT ( ChargeTypeId
          , ChargeTypeDescription
          )
GO


