IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_ExchequerNumber]'))
DROP VIEW [!ActiveSchema!].[evw_ExchequerNumber]
GO

CREATE VIEW !ActiveSchema!.evw_ExchequerNumber
AS
SELECT CountId   = N.PositionId
     , CountType = N.ssCountType
     , NextCount = N.ssNextCount
     , LastValue = N.ssLastValue
     , FormattedNextCount
FROM   !ActiveSchema!.EXCHQNUM N
CROSS APPLY ( VALUES ( ( CASE
                         WHEN ssNextCount < 1000000 AND N.ssCountType <> 'ADC' THEN '000000'
                         WHEN ssNextCount > 1000000 AND N.ssCountType = 'ADC'  THEN '0000'
                         ELSE '00000'
                         END
                       )
                     , ( CASE
                         WHEN N.ssCountType = 'ADC' THEN 'A'
                         ELSE ''
                         END
                       )
                     )
            ) LZ ( LeadingZeros
                 , AdjChar
                 )
CROSS APPLY ( VALUES ( ( CASE
                         WHEN N.ssCountType = 'ADC' THEn 'xxx'
                         ELSE N.ssCountType
                         END
                       + CASE
                         WHEN ssNextCount < 1000000 THEN ''  + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 6)
                         WHEN ssNextCount < 1100000 THEN 'A' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 1200000 THEN 'B' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 1300000 THEN 'C' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 1400000 THEN 'D' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 1500000 THEN 'E' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 1600000 THEN 'F' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 1700000 THEN 'G' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 1800000 THEN 'H' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 1900000 THEN 'J' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2000000 THEN 'K' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2100000 THEN 'L' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2200000 THEN 'M' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2300000 THEN 'N' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2400000 THEN 'P' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2500000 THEN 'Q' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2500000 THEN 'R' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2700000 THEN 'T' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2800000 THEN 'U' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 2900000 THEN 'V' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 3000000 THEN 'W' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 3100000 THEN 'X' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 3200000 THEN 'Y' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         WHEN ssNextCount < 3300000 THEN 'Z' + RIGHT(LeadingZeros + CONVERT(VARCHAR(7), ssNextCount) + AdjChar, 5)
                         END
                       )
                     )
            ) FC ( FormattedNextCount
                 )

GO
