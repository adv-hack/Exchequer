IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_TimeRateRule]'))
DROP VIEW [common].[evw_TimeRateRule]
GO

CREATE VIEW common.evw_TimeRateRule WITH VIEW_METADATA
AS
SELECT TRR.*
FROM ( VALUES (0, 'GOJ', 'Global/Own/Job')
            , (1, 'OWN', 'Own Rates Only')
            , (2, 'GJO', 'Global/Job/Own')
            , (3, 'JOB', 'Job Rates Only')
        ) TRR ( TimeRateRuleId
              , TimeRateRuleCode
              , TimeRateRuleDescription
              )
GO
