--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ivw_SortViewListType.sql
--// Author		: Glen Jones
--// Date		: 4 July 2012
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ivw_SortViewListType view.
--//                  Puts the valid SortView Lists into table form
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 4 July 2012 : Glen Jones : File Creation
--//  2 : 4 December 2013 : Chris Sandow : Added Consumer list type (15)
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[ivw_SortViewListType]'))
DROP VIEW [common].[ivw_SortViewListType]
GO

CREATE VIEW common.ivw_SortViewListType
AS
SELECT SortViewListTypeId = 0
     , SortViewListTypeDescription = 'Customer'
UNION 
SELECT SortViewListTypeId = 1
     , SortViewListTypeDescription = 'Supplier'
UNION 
SELECT SortViewListTypeId = 2
     , SortViewListTypeDescription = 'Customer Ledger'
UNION 
SELECT SortViewListTypeId = 3
     , SortViewListTypeDescription = 'Supplier Ledger'
UNION 
SELECT SortViewListTypeId = 4
     , SortViewListTypeDescription = 'Stock List'
UNION 
SELECT SortViewListTypeId = 5
     , SortViewListTypeDescription = 'Stock ReOrder'
UNION 
SELECT SortViewListTypeId = 6
     , SortViewListTypeDescription = 'Stock Take'
UNION 
SELECT SortViewListTypeId = 7
     , SortViewListTypeDescription = 'Stock Ledger'
UNION 
SELECT SortViewListTypeId = 8
     , SortViewListTypeDescription = 'Job Ledger'
UNION 
SELECT SortViewListTypeId = 9
     , SortViewListTypeDescription = 'Main Sales Daybook'
UNION 
SELECT SortViewListTypeId = 10
     , SortViewListTypeDescription = 'Sales Quotes Daybook'
UNION 
SELECT SortViewListTypeId = 11
     , SortViewListTypeDescription = 'Sales Orders Daybook'
UNION 
SELECT SortViewListTypeId = 12
     , SortViewListTypeDescription = 'Main Purchase Daybook'
UNION 
SELECT SortViewListTypeId = 13
     , SortViewListTypeDescription = 'Purchase Quotes Daybook'
UNION 
SELECT SortViewListTypeId = 14
     , SortViewListTypeDescription = 'Purchase Order Daybook'
UNION 
SELECT SortViewListTypeId = 15
     , SortViewListTypeDescription = 'Consumer'
GO
