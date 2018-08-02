IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_PostAnalysisType]'))
DROP VIEW [common].[evw_PostAnalysisType]
GO


CREATE VIEW common.evw_PostAnalysisType
AS
  SELECT PostAnalysisType
       , PostAnalysisDescription
       , PostAnalysisCategory
       , PostAnalysisOrder
  FROM ( VALUES ( 'PIN', 'Purchase Invoices', 'Purchase', 1)
              , ( 'PPY', 'Purchase Payments', 'Purchase', 2)
              , ( 'PCR', 'Purchase Credit Notes', 'Purchase', 3)
              , ( 'PJI', 'Purchase Journal Invoices', 'Purchase', 4)
              , ( 'PJC', 'Purchase Journal Credits', 'Purchase', 5)
              , ( 'SDT', 'Settlement Discount Taken', 'Purchase', 6)
              , ( 'NDT', 'Standard Discount Taken', 'Purchase', 7)
              , ( 'IVT', 'Input VAT', 'Purchase', 8)
              , ( 'CRE', 'Creditors Control A/C', 'Purchase', 9)
              , ( 'SIN', 'Sales Invoices', 'Sales', 101)
              , ( 'SRC', 'Sales Receipts', 'Sales', 102)
              , ( 'SCR', 'Sales Credit Notes', 'Sales', 103)
              , ( 'SJI', 'Sales Journal Invoices', 'Sales', 104)
              , ( 'SJC', 'Sales Journal Credits', 'Sales', 105)
              , ( 'SDG', 'Settlement Discounts Given', 'Sales', 106)
              , ( 'NDG', 'Standard Discounts Given', 'Sales', 107)
              , ( 'OVT', 'Output VAT', 'Sales', 108)
              , ( 'DEB', 'Debtors Control A/C','Sales', 109)
       ) PAT ( PostAnalysisType
             , PostAnalysisDescription
             , PostAnalysisCategory
             , PostAnalysisOrder
             )
GO