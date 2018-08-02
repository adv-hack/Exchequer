IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_Currency]'))
DROP VIEW [!ActiveSchema!].[evw_Currency]
GO

CREATE VIEW !ActiveSchema!.evw_Currency
AS
SELECT C.*
     , UseCompanyRate
     , UseDailyRate
     , ConversionRate
FROM   !ActiveSchema!.CURRENCY C
CROSS JOIN !ActiveSchema!.evw_SystemSettings SS

CROSS APPLY ( VALUES ( (CASE
                        WHEN CurrencyCode NOT IN (0, 1) AND UseCompanyRate = 1 THEN C.CompanyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND UseCompanyRate = 0 THEN C.DailyRate
                        ELSE 1
                        END
                       )
                     )
            ) Rates ( ConversionRate
                    )
GO