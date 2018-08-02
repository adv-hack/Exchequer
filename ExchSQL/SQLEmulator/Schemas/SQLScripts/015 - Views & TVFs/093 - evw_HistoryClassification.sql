IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_HistoryClassification]'))
DROP VIEW [common].[evw_HistoryClassification]
GO

CREATE VIEW common.evw_HistoryClassification
AS
SELECT *
FROM (VALUES ('A', ASCII('A'), 'Profit & Loss', 'Nominal', CONVERT(BIT, 1), CONVERT(BIT, 0) )
           , ('B', ASCII('B'), 'Balance Sheet', 'Nominal', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('C', ASCII('C'), 'Control Codes', 'Nominal', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('D', ASCII('D'), 'Stock Location', 'Stock', CONVERT(BIT, 1), CONVERT(BIT, 0) )
           , ('E', ASCII('E'), 'Trader Stock History', 'Trader Stock Analysis', CONVERT(BIT, 1), CONVERT(BIT, 0) )
           , ('F', ASCII('F'), 'Carried Forward Nominal values', 'Nominal', CONVERT(BIT, 1), CONVERT(BIT, 1) )
           , ('G', ASCII('G'), 'Stock Group', 'Stock', CONVERT(BIT, 1), CONVERT(BIT, 0) )
           , ('H', ASCII('H'), 'Nominal Headers', 'Nominal', CONVERT(BIT, 1), CONVERT(BIT, 1) )
           , ('I', ASCII('I'), 'Input VAT', 'VAT', CONVERT(BIT, 0), CONVERT(BIT, 0) )
           , ('J', ASCII('J'), 'Job Actuals', 'Job', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('K', ASCII('K'), 'Contract Actuals', 'Job', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('M', ASCII('M'), 'Bill of Materials', 'Stock', CONVERT(BIT, 1), CONVERT(BIT, 0) )
           , ('O', ASCII('O'), 'Output VAT', 'VAT', CONVERT(BIT, 0), CONVERT(BIT, 0) )
           , ('P', ASCII('P'), 'Stock Items', 'Stock', CONVERT(BIT, 1), CONVERT(BIT, 0) )
           , ('S', ASCII('S'), 'Unknown','Unknown', CONVERT(BIT, 1), CONVERT(BIT, 1) )
           , ('T', ASCII('T'), 'Unknown','Unknown', CONVERT(BIT, 1), CONVERT(BIT, 1) )
           , ('U', ASCII('U'), 'Trader History', 'Trader', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('V', ASCII('V'), 'Trader History - Postings Only', 'Trader', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('W', ASCII('W'), 'Trader GP History', 'Trader', CONVERT(BIT, 1), CONVERT(BIT, 0) )
           , ('X', ASCII('X'), 'Delisted Stock', 'Stock', CONVERT(BIT, 1), CONVERT(BIT, 0) )
           , ('Z', ASCII('Z'), 'Unknown', 'Unknown', CONVERT(BIT, 1), CONVERT(BIT, 1) )
           , ('\', ASCII('\'), 'Employee', 'Job', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('[', ASCII('['), 'Job Costing Analysis', 'Job', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('227', 227, 'Description-only Stock Items', 'Stock', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('230', 230, 'Stock Group Header', 'Stock', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('236', 236, 'Bill of Materials - Quantity Only', 'Stock', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('239', 239, 'Stock - Quantity Only', 'Stock', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('247', 247, 'Delisted Stock', 'Stock', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('248', 248, 'Delisted Stock - Quantity Only', 'Stock', CONVERT(BIT, 0), CONVERT(BIT, 1) )
           , ('8', 56, 'Unknown', 'Unknown', CONVERT(BIT, 1), CONVERT(BIT, 1) )
           , ('9', 57, 'Unknown', 'Unknown', CONVERT(BIT, 1), CONVERT(BIT, 1) )

     ) HClass ( HistoryClassificationCode
              , HistoryClassificationId
              , HistoryClassificationDescription
              , HistoryClassificationGroup
              , HasYTD
              , HasCTD
              )

GO

