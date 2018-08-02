
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_VATSystemSettings]'))
DROP VIEW [!ActiveSchema!].evw_VATSystemSettings
GO

CREATE VIEW !ActiveSchema!.evw_VATSystemSettings WITH VIEW_METADATA
AS
SELECT VATCurrency         = (SELECT VATCurr FROM !ActiveSchema!.EXCHQSS WHERE common.GetString(IDCode, 1) = 'SYS')
     , VATScheme           = VATScheme
     , VATCurrentPeriod    = CP.CurrentPeriod
     , VATInterval         = VATInterval
     , VATNextPeriod       = CASE
                             WHEN MONTH(DATEADD(MM, VATInterval, CONVERT(DATE, CP.CurrentPeriod))) = 2
                              AND DAY(DATEADD(MM, VATInterval, CONVERT(DATE, CP.CurrentPeriod)))   = 29
                             THEN CONVERT(VARCHAR(8), DATEADD(DD, -1, DATEADD(MM, VATInterval, CONVERT(DATE, CP.CurrentPeriod))), 112)
                             ELSE CONVERT(VARCHAR(8), DATEADD(MM, VATInterval, CONVERT(DATE, CP.CurrentPeriod)), 112)
                             END
     , VATEnableECServices = SS.EnableECServices
FROM   !ActiveSchema!.EXCHQSS SS
CROSS APPLY (SELECT CurrentPeriod = CASE 
                                    WHEN ISDATE(CurrPeriod) = 0 THEN CASE
                                                                     WHEN ISNUMERIC(CurrPeriod) = 1 THEN CONVERT(VARCHAR(8), CurrPeriod - 1)
                                                                     ELSE CONVERT(VARCHAR(8), NULL)
                                                                     END
                                    ELSE CurrPeriod
                                    END
            ) CP
WHERE   common.GetString(IDCode, 1) = 'VAT'

GO