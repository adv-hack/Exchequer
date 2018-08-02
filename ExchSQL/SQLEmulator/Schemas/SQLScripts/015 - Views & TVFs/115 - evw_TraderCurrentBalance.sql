/****** Object:  View [!ActiveSchema!].[evw_TraderCurrentBalance]    Script Date: 23/03/2015 15:14:48 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_TraderCurrentBalance]'))
DROP VIEW [!ActiveSchema!].[evw_TraderCurrentBalance]
GO

CREATE VIEW !ActiveSchema!.evw_TraderCurrentBalance
AS
SELECT TH.TraderCode 
     , BalanceAmount
 FROM   !ActiveSchema!.evw_TraderHistory TH
 JOIN (SELECT TraderCode
            , MaxHistoryPeriodKey = MAX(HistoryPeriodKey)
       FROM   !ActiveSchema!.evw_TraderHistory MTH
       WHERE  MTH.HistoryClassificationCode = 'U'
       AND    MTH.HistoryPeriod             = 255
       AND    MTH.ControlGLNominalCode      IS NULL
       GROUP BY TraderCode) MPK ON MPK.TraderCode = TH.TraderCode
                               AND MPK.MaxHistoryPeriodKey = TH.HistoryPeriodKey
WHERE   TH.HistoryClassificationCode = 'U'
AND     TH.ControlGLNominalCode      IS NULL

GO