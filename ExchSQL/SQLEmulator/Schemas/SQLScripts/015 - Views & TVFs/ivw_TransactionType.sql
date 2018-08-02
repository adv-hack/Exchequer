--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ivw_TransactionType.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ivw_TransactionType view
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[ivw_TransactionType]'))
DROP VIEW [common].[ivw_TransactionType]
GO

/*
   Translation of hard-coded Document Types (Transaction Types) into a table-like format

*/
CREATE VIEW common.ivw_TransactionType 
AS
SELECT TransactionTypeId          = 0
     , TransactionTypeDescription = 'Sales Invoice'
     , TransactionTypeCode        = 'SIN'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 1
     , TransactionTypeDescription = 'Sales Receipt'
     , TransactionTypeCode        = 'SRC'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 2
     , TransactionTypeDescription = 'Sales Credit Note'
     , TransactionTypeCode        = 'SCR'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 3
     , TransactionTypeDescription = 'Sales Journal Invoice'
     , TransactionTypeCode        = 'SJI'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 4
     , TransactionTypeDescription = 'Sales Journal Credit Note'
     , TransactionTypeCode        = 'SJC'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 5
     , TransactionTypeDescription = 'Sales Refund'
     , TransactionTypeCode        = 'SRF'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 6
     , TransactionTypeDescription = 'Sales Receipt Invoice'
     , TransactionTypeCode        = 'SRI'
     , TransactionTypeSign        = -1 
     , ParentTransactionTypeId    = 100       
UNION
SELECT TransactionTypeId          = 7
     , TransactionTypeDescription = 'Sales Quotation'
     , TransactionTypeCode        = 'SQU'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 8
     , TransactionTypeDescription = 'Sales Order'
     , TransactionTypeCode        = 'SOR'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 9
     , TransactionTypeDescription = 'Sales Delivery Note'
     , TransactionTypeCode        = 'SDN'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 10
     , TransactionTypeDescription = 'Sales Batch'
     , TransactionTypeCode        = 'SBT'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 11
     , TransactionTypeDescription = 'Settlement Discounts Given'
     , TransactionTypeCode        = 'SDG'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 12
     , TransactionTypeDescription = 'Standard Discounts Given'
     , TransactionTypeCode        = 'NDG'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 13
     , TransactionTypeDescription = 'Output VAT'
     , TransactionTypeCode        = 'OVT'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 14
     , TransactionTypeDescription = 'Debtors Controls A/C'
     , TransactionTypeCode        = 'DEB'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 15
     , TransactionTypeDescription = 'Purchase Invoice'
     , TransactionTypeCode        = 'PIN'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 16
     , TransactionTypeDescription = 'Purchase Payment'
     , TransactionTypeCode        = 'PPY'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 101     
UNION
SELECT TransactionTypeId          = 17
     , TransactionTypeDescription = 'Purchase Credit Note'
     , TransactionTypeCode        = 'PCR'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 18
     , TransactionTypeDescription = 'Purchase Journal Invoice'
     , TransactionTypeCode        = 'PJI'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 19
     , TransactionTypeDescription = 'Purchase Journal Credit Note'
     , TransactionTypeCode        = 'PJC'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 20
     , TransactionTypeDescription = 'Purchase Refund'
     , TransactionTypeCode        = 'PRF'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 21
     , TransactionTypeDescription = 'Purchase Payment with Invoice'
     , TransactionTypeCode        = 'PPI'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 22
     , TransactionTypeDescription = 'Purchase Quotation'
     , TransactionTypeCode        = 'PQU'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 23
     , TransactionTypeDescription = 'Purchase Order'
     , TransactionTypeCode        = 'POR'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 24
     , TransactionTypeDescription = 'Purchase Delivery Note'
     , TransactionTypeCode        = 'PDN'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 25
     , TransactionTypeDescription = 'Purchase Batch'
     , TransactionTypeCode        = 'PBT'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 26
     , TransactionTypeDescription = 'Settlement Discounts Taken'
     , TransactionTypeCode        = 'SDT'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 27
     , TransactionTypeDescription = 'Standard Discounts Taken'
     , TransactionTypeCode        = 'NDT'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 28
     , TransactionTypeDescription = 'Input VAT'
     , TransactionTypeCode        = 'IVT'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 29
     , TransactionTypeDescription = 'Creditors Control A/C'
     , TransactionTypeCode        = 'CRE'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 30
     , TransactionTypeDescription = 'Nominal Transfer'
     , TransactionTypeCode        = 'NMT'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 31
     , TransactionTypeDescription = 'Posting Run'
     , TransactionTypeCode        = 'RUN'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 32
     , TransactionTypeDescription = 'Folion Number'
     , TransactionTypeCode        = 'FOL'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 33
     , TransactionTypeDescription = 'Automatic Folio Number'
     , TransactionTypeCode        = 'AFL'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 34
     , TransactionTypeDescription = 'Automatic Document'
     , TransactionTypeCode        = 'ADC'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 35
     , TransactionTypeDescription = 'Stock Adjustment'
     , TransactionTypeCode        = 'ADJ'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 36
     , TransactionTypeDescription = 'Automatic Cheque Number'
     , TransactionTypeCode        = 'ACQ'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 37
     , TransactionTypeDescription = 'Automatic Pay-in Ref.'
     , TransactionTypeCode        = 'API'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 38
     , TransactionTypeDescription = 'Stock Folio Number'
     , TransactionTypeCode        = 'SKF'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 39
     , TransactionTypeDescription = 'Job Folio Number'
     , TransactionTypeCode        = 'JBF'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 40
     , TransactionTypeDescription = 'Works Order'
     , TransactionTypeCode        = 'WOR'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 41
     , TransactionTypeDescription = 'Timesheet'
     , TransactionTypeCode        = 'TSH'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 42
     , TransactionTypeDescription = 'Job Posting Run'
     , TransactionTypeCode        = 'JRN'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 43
     , TransactionTypeDescription = 'Works Issue Note'
     , TransactionTypeCode        = 'WIN'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = NULL
UNION
SELECT TransactionTypeId          = 44
     , TransactionTypeDescription = 'Sales Return Note'
     , TransactionTypeCode        = 'SRN'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 100
UNION
SELECT TransactionTypeId          = 45
     , TransactionTypeDescription = 'Purchase Return Note'
     , TransactionTypeCode        = 'PRN'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 101
UNION
SELECT TransactionTypeId          = 46
     , TransactionTypeDescription = 'Job Contract Terms'
     , TransactionTypeCode        = 'JCT'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 102
UNION
SELECT TransactionTypeId          = 47
     , TransactionTypeDescription = 'Job Sales Terms'
     , TransactionTypeCode        = 'JST'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 102
UNION
SELECT TransactionTypeId          = 48
     , TransactionTypeDescription = 'Job Purchase Terms'
     , TransactionTypeCode        = 'JPT'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 102
UNION
SELECT TransactionTypeId          = 49
     , TransactionTypeDescription = 'Job Sales Application'
     , TransactionTypeCode        = 'JSA'
     , TransactionTypeSign        = -1
     , ParentTransactionTypeId    = 102
UNION
SELECT TransactionTypeId          = 50
     , TransactionTypeDescription = 'Job Purchase Application'
     , TransactionTypeCode        = 'JPA'
     , TransactionTypeSign        = 1
     , ParentTransactionTypeId    = 102