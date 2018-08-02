
-- [!ActiveSchema!].[evw_AutoTransaction]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_AutoTransaction]'))
DROP VIEW !ActiveSchema!.[evw_AutoTransaction]
GO

CREATE VIEW !ActiveSchema!.evw_AutoTransaction WITH VIEW_METADATA
AS
SELECT HeaderPositionId              = PositionId
     , OurReference                  = thOurRef
     , HeaderFolioNumber             = thFolioNum
     , RunNo                         = thRunNo
     , HoldStatuId                   = thHoldFlag
     , HS.HoldStatusDescription
     , HS.OnHold
     , TraderCode                    = thAcCode
     , TransactionTypeId
     , TransactionTypeCode
     , TransactionTypeDescription
     , AutoCreateWhenPosting         = thAutoPost
     , IncrementBy                   = thAutoIncrement
     , IncrementType                 = thAutoIncrementType
     , IncrementTypeDescription      = CASE thAutoIncrementType
                                       WHEN 'D' THEN 'Days'
                                       WHEN 'P' THEN 'Periods'
                                       END

     , AutoCreateTransDueDate        = thDueDate
     , AutoCreateTransNextDate       = thTransDate
     , AutoCreateTransNextPeriod     = thPeriod
     , AutoCreateTransNextYear       = thYear
     , AutoCreateTransNextPeriodKey  = ((thYear + 1900) * 1000) + thPeriod

     , AutoCreateTransUntilDate      = thUntilDate
     , AutoCreateTransUntilPeriod    = thUntilPeriod
     , AutoCreateTransUntilYear      = thUntilYear
     , AutoCreateTransUntilPeriodKey = ((thUntilYear + 1900) * 1000) + thUntilPeriod
     
FROM   !ActiveSchema!.DOCUMENT DOC
JOIN   common.evw_TransactionType TT ON DOC.thDocType = TT.TransactionTypeId
JOIN   common.evw_HoldStatus      HS ON DOC.thHoldFlag = HS.HoldStatusId
WHERE  thRunNo IN (-1, -2)

GO
