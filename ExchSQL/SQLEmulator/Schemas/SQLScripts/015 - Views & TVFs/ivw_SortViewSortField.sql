--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ivw_SortViewSortField.sql
--// Author		: Glen Jones
--// Date		: 4 July 2012
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ivw_SortViewSortField view.
--//                  Puts the valid Sort fields for a SortView List into table form
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 4 July 2012 : Glen Jones : File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[ivw_SortViewSortField]'))
DROP VIEW [common].[ivw_SortViewSortField]
GO

CREATE VIEW common.ivw_SortViewSortField
AS
    -- 23rd July 2012: Sorting not relevent at this point, but may be required in the future.  CS/GJ
    -- Customer Fields

SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 0
     , SortViewSortFieldDescription = 'Account Code'
     , SortViewSortFieldName        = 'acCode'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 0
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 1
     , SortViewSortFieldDescription = 'Company Name'
     , SortViewSortFieldName        = 'acCompany'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 0
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 2
     , SortViewSortFieldDescription = 'Balance'
     , SortViewSortFieldName        = 'ifn_GetCustValue'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 0
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 3
     , SortViewSortFieldDescription = 'Telephone'
     , SortViewSortFieldName        = 'acPhone'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 0

    -- Supplier Fields
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 0
     , SortViewSortFieldDescription = 'Account Code'
     , SortViewSortFieldName        = 'acCode'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 1
     , SortViewSortFieldDescription = 'Company Name'
     , SortViewSortFieldName        = 'acCompany'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 2
     , SortViewSortFieldDescription = 'Balance'
     , SortViewSortFieldName        = 'ifn_GetCustValue'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 3
     , SortViewSortFieldDescription = 'Telephone'
     , SortViewSortFieldName        = 'acPhone'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1

    -- Stock List Fields
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 0
     , SortViewSortFieldDescription = 'Stock Code'
     , SortViewSortFieldName        = 'stCode'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 1
     , SortViewSortFieldDescription = 'Stock Description'
     , SortViewSortFieldName        = ''
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 2
     , SortViewSortFieldDescription = 'In Stock Quantity'
     , SortViewSortFieldName        = ''
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 3
     , SortViewSortFieldDescription = 'Free Stock Quantity'
     , SortViewSortFieldName        = ''
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 4
     , SortViewSortFieldDescription = 'On Order Quantity'
     , SortViewSortFieldName        = ''
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4

 -- Daybook Fields
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 0
     , SortViewSortFieldDescription = 'Our Reference'
     , SortViewSortFieldName        = 'thOurRef'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId IN (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 1
     , SortViewSortFieldDescription = 'Transaction Date'
     , SortViewSortFieldName        = 'thTransDate'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId IN (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 2
     , SortViewSortFieldDescription = 'Customer/Supplier Code'
     , SortViewSortFieldName        = 'thAcCode'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId IN (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 3
     , SortViewSortFieldDescription = 'Amount'
     , SortViewSortFieldName        = '(CASE
                WHEN thDocType IN (5, 20, 2, 17, 4, 19, 1, 16) 
				THEN ((thNetValue + thTotalVAT) - thTotalLineDiscount - (thSettleDiscAmount * thSettleDiscTaken)) * -1
				ELSE CASE 
				     WHEN thDocType IN (8, 23) THEN thTotalOrderOS
					 ELSE (thNetValue + thTotalVAT) - thTotalLineDiscount - (thSettleDiscAmount * thSettleDiscTaken)
				     END
				END)'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId IN (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 4
     , SortViewSortFieldDescription = 'Hold Flag'
     , SortViewSortFieldName        = '(thHoldFlag - (thHoldFlag & 160))'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId IN (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewSortFieldId          = 5
     , SortViewSortFieldDescription = 'Your Reference'
     , SortViewSortFieldName        = 'thYourRef'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId IN (9, 10, 11, 12, 13, 14)

GO
