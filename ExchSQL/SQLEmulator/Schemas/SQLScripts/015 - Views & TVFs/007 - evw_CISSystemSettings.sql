
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_CISSystemSettings]'))
DROP VIEW [!ActiveSchema!].evw_CISSystemSettings
GO

CREATE VIEW !ActiveSchema!.evw_CISSystemSettings WITH VIEW_METADATA
AS
SELECT CISAutoSetPeriod  = SS.CISAutoSetPr
     , CISCurrentDate    = SS.CISCurrPeriod
     , CISInterval       = SS.CISInterval
     , CISLoaded         = SS.CISLoaded

FROM   [!ActiveSchema!].EXCHQSS SS
WHERE  common.GetString(IDCode, 1) = 'CIS'

GO