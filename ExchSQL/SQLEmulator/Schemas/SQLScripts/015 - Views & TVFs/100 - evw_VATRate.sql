
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_VATRate]'))
DROP VIEW [!ActiveSchema!].[evw_VATRate]
GO

CREATE VIEW !ActiveSchema!.evw_VATRate
AS
SELECT VATRates.VATRateId
     , VATRates.VATRateCode
     , VATRates.VATRateDescription
     , VATRates.VATInclude
     , VATRate = common.efn_ConvertToReal48(VATRates.VATRate)
FROM  !ActiveSchema!.EXCHQSS
CROSS APPLY ( SELECT VATRateId              = 1
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate1Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate1Desc)
                   , VATInclude         = CONVERT(bit, VATRate1Include)
                   , VatRate            = VATRate1Rate
              UNION
              SELECT VATRateId              = 2
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate2Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate2Desc)
                   , VATInclude         = CONVERT(bit, VATRate2Include)
                   , VatRate            = VATRate2Rate
              UNION
              SELECT VATRateId              = 3
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate3Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate3Desc)
                   , VATInclude         = CONVERT(bit, VATRate3Include)
                   , VatRate            = VATRate3Rate
              UNION
              SELECT VATRateId              = 4
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate4Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate4Desc)
                   , VATInclude         = CONVERT(bit, VATRate4Include)
                   , VatRate            = VATRate4Rate
              UNION
              SELECT VATRateId              = 5
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate5Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate5Desc)
                   , VATInclude         = CONVERT(bit, VATRate5Include)
                   , VatRate            = VATRate5Rate
              UNION
              SELECT VATRateId              = 6
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate6Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate6Desc)
                   , VATInclude         = CONVERT(bit, VATRate6Include)
                   , VatRate            = VATRate6Rate
              UNION
              SELECT VATRateId              = 7
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate7Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate7Desc)
                   , VATInclude         = CONVERT(bit, VATRate7Include)
                   , VatRate            = VATRate7Rate
              UNION
              SELECT VATRateId              = 8
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate8Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate8Desc)
                   , VATInclude         = CONVERT(bit, VATRate8Include)
                   , VatRate            = VATRate8Rate
              UNION
              SELECT VATRateId              = 9
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate9Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate9Desc)
                   , VATInclude         = CONVERT(bit, VATRate9Include)
                   , VatRate            = VATRate9Rate
              UNION
              SELECT VATRateId              = 10
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate10Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate10Desc)
                   , VATInclude         = CONVERT(bit, VATRate10Include)
                   , VatRate            = VATRate10Rate
              UNION
              SELECT VATRateId              = 11
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate11Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate11Desc)
                   , VATInclude         = CONVERT(bit, VATRate11Include)
                   , VatRate            = VATRate11Rate
              UNION
              SELECT VATRateId              = 12
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate12Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate12Desc)
                   , VATInclude         = CONVERT(bit, VATRate12Include)
                   , VatRate            = VATRate12Rate
              UNION
              SELECT VATRateId              = 13
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate13Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate13Desc)
                   , VATInclude         = CONVERT(bit, VATRate13Include)
                   , VatRate            = VATRate13Rate
              UNION
              SELECT VATRateId              = 14
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate14Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate14Desc)
                   , VATInclude         = CONVERT(bit, VATRate14Include)
                   , VatRate            = VATRate14Rate
              UNION
              SELECT VATRateId              = 15
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate15Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate15Desc)
                   , VATInclude         = CONVERT(bit, VATRate15Include)
                   , VatRate            = VATRate15Rate
              UNION
              SELECT VATRateId              = 16
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate16Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate16Desc)
                   , VATInclude         = CONVERT(bit, VATRate16Include)
                   , VatRate            = VATRate16Rate
              UNION
              SELECT VATRateId              = 17
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate17Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate17Desc)
                   , VATInclude         = CONVERT(bit, VATRate17Include)
                   , VatRate            = VATRate17Rate
              UNION
              SELECT VATRateId              = 18
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATRate18Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50), VATRate18Desc)
                   , VATInclude         = CONVERT(bit, VATRate18Include)
                   , VatRate            = VATRate18Rate
              UNION
              SELECT VATRateId              = 19  
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATStandardCode)
                   , VATRateDescription = CONVERT(NVARCHAR(50),VATStandardDesc)
                   , VATInclude         = CONVERT(bit, VATStandardInclude)
                   , VatRate            = VATStandardRate 
              UNION
              SELECT VATRateId              = 20  
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATExemptCode)
                   , VATRateDescription = CONVERT(NVARCHAR(50),VATExemptDesc)
                   , VATInclude         = CONVERT(bit, VATExemptInclude)
                   , VatRate            = VATExemptRate     
              UNION
              SELECT VATRateId              = 21  
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATZeroCode)
                   , VATRateDescription = CONVERT(NVARCHAR(50),VATZeroDesc)
                   , VATInclude         = CONVERT(bit, VATZeroInclude)
                   , VatRate            = VATZeroRate
/*
              UNION
              SELECT VATRateId              = 22  
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATIAdjCode)
                   , VATRateDescription = CONVERT(NVARCHAR(50),VATIAdjDesc)
                   , VATInclude         = CONVERT(bit, VATIAdjInclude)
                   , VatRate            = VATIAdjRate                   
              UNION
              SELECT VATRateId              = 23  
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATOAdjCode)
                   , VATRateDescription = CONVERT(NVARCHAR(50),VATOAdjDesc)
                   , VATInclude         = CONVERT(bit, VATOAdjInclude)
                   , VatRate            = VATOAdjRate
*/
              UNION
              SELECT VATRateId              = 88
                   , VATRateCode        = CONVERT(NVARCHAR(50), VATSpare8Code)
                   , VATRateDescription = CONVERT(NVARCHAR(50),VATSpare8Desc)
                   , VATInclude         = CONVERT(bit, VATSpare8Include)
                   , VatRate            = VATSpare8Rate

            ) VATRates ( VATRateId
                       , VATRateCode
                       , VATRateDescription
                       , VATInclude
                       , VATRate
                       )

WHERE common.GetString(IDCode, 1) = 'VAT'

GO