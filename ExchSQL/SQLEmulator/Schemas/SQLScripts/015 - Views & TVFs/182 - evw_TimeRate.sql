IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_TimeRate]'))
DROP VIEW [!ActiveSchema!].[evw_TimeRate]
GO

CREATE VIEW !ActiveSchema!.evw_TimeRate WITH VIEW_METADATA
AS
SELECT TimeRateId              = PositionId
     , TimeRateCode            = EStockCode
     , TimeRateDescription     = PayRDesc
     , TimeRateType            = SubType
     , TimeRateTypeDescription = CASE
                                 WHEN NewSubType = 'R' THEN 'Employee Time Rate'
                                 WHEN NewSubType = 'E' THEN 'Global Time Rate'
                                 WHEN NewSubType = 'J' THEN 'Job Time Rate'
                                 ELSE 'Unknown'
                                 END
     , CostCurrencyId          = CostCurr
     , Cost
     , ChargeCurrencyId        = ChargeCurr
     , ChargeOut
     
     , AnalysisCode            = EAnalCode
     , EmployeeCode            = CASE
                                 WHEN NewSubType = 'R' THEN JC.EmpCode
                                 ELSE ''
                                 END
     , JobCode                 = CASE
                                 WHEN NewSubType = 'J' THEN JC.EmpCode
                                 ELSE ''
                                 END
     , PayrollFactor           = PayRFact
     , PayrollCode             = PayRRate
     
FROM !ActiveSchema!.JOBCTRL JC
CROSS APPLY ( VALUES ( ( CASE
                         WHEN SubType = 'E' AND EmpCode LIKE '%' + CHAR(255) + '%'     THEN 'E'
                         WHEN SubType = 'E' AND EmpCode NOT LIKE '%' + CHAR(255) + '%' THEN 'J'
                         ELSE 'R'
                         END
                       )
                     )
            ) NST (NewSubType)
WHERE RecPfix = 'J' 
AND  (SubType = 'E' 
OR    SubType = 'R')

GO