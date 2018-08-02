IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_TransactionVATAnalysis]'))
DROP VIEW [!ActiveSchema!].[evw_TransactionVATAnalysis]
GO


CREATE VIEW !ActiveSchema!.evw_TransactionVATAnalysis
AS
SELECT HeaderPositionId = PositionId
     , TLV.VATCode
     , TLV.VATAmount
     
FROM   !ActiveSchema!.DOCUMENT DOC

CROSS APPLY ( SELECT VATCode   = '1'
                   , VATAmount = DOC.thVATAnalysisRate1
              UNION
              SELECT VATCode   = '2'
                   , VATAmount = DOC.thVATAnalysisRate2
              UNION
              SELECT VATCode   = '3'
                   , VATAmount = DOC.thVATAnalysisRate3
              UNION
              SELECT VATCode   = '4'
                   , VATAmount = DOC.thVATAnalysisRate4
              UNION
              SELECT VATCode   = '5'
                   , VATAmount = DOC.thVATAnalysisRate5
              UNION
              SELECT VATCode   = '6'
                   , VATAmount = DOC.thVATAnalysisRate6
              UNION
              SELECT VATCode   = '7'
                   , VATAmount = DOC.thVATAnalysisRate7
              UNION
              SELECT VATCode   = '8'
                   , VATAmount = DOC.thVATAnalysisRate8
              UNION
              SELECT VATCode   = '9'
                   , VATAmount = DOC.thVATAnalysisRate9
              UNION
              SELECT VATCode   = 'T'
                   , VATAmount = DOC.thVATAnalysisRateT
              UNION
              SELECT VATCode   = 'X'
                   , VATAmount = DOC.thVATAnalysisRateX
              UNION
              SELECT VATCode   = 'B'
                   , VATAmount = DOC.thVATAnalysisRateB
              UNION
              SELECT VATCode   = 'C'
                   , VATAmount = DOC.thVATAnalysisRateC
              UNION
              SELECT VATCode   = 'F'
                   , VATAmount = DOC.thVATAnalysisRateF
              UNION
              SELECT VATCode   = 'G'
                   , VATAmount = DOC.thVATAnalysisRateG
              UNION
              SELECT VATCode   = 'R'
                   , VATAmount = DOC.thVATAnalysisRateR
              UNION
              SELECT VATCode   = 'W'
                   , VATAmount = DOC.thVATAnalysisRateW
              UNION
              SELECT VATCode   = 'Y'
                   , VATAmount = DOC.thVATAnalysisRateY
              UNION
              SELECT VATCode   = 'S'
                   , VATAmount = DOC.thVATAnalysisStandard
              UNION
              SELECT VATCode   = 'E'
                   , VATAmount = DOC.thVATAnalysisExempt
              UNION
              SELECT VATCode   = 'Z'
                   , VATAmount = DOC.thVATAnalysisZero
              ) TLV
WHERE TLV.VATAmount <> 0

GO