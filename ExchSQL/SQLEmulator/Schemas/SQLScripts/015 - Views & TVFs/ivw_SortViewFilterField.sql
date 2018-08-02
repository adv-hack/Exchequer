--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ivw_SortViewFilterField.sql
--// Author		: Glen Jones
--// Date		: 4 July 2012
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ivw_SortViewFilterField view
--//                  Puts the valid Filter fields for a SortView List into table form
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1	: 4 July 2012 : Glen Jones   : File Creation
--//  2 : 4 December 2013 : Chris Sandow : Added Consumer list type (15)
--//  3 : 29 July 2015 : Glen Jones   : ABSEXCH-16459 : Added Order Payment Status 
--//  4 : 15 March 2016 :HV : 2016-R2 ABSEXCH-13215: Stock Reorder Sort Views do not filter correctly for Cost Centres/Departments.
--//  5 : 08 April 2016 :HV : 2016-R2 ABSEXCH-15408: Introduce a filter to permit the daybooks to be sorted by transaction currency.
--//  6 : 19 April 2016 :HV : 2016-R2 ABSEXCH-9497 : Drop down list be added when Status is selected to avoid mis-typing the three valid options
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[ivw_SortViewFilterField]'))
DROP VIEW [common].[ivw_SortViewFilterField]
GO

CREATE VIEW [common].[ivw_SortViewFilterField]
AS
    -- Customer/Consumer Fields

SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 0
     , SortViewFilterFieldDescription = 'Area Code'
     , SortViewFilterFieldName        = 'acArea'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 1
     , SortViewFilterFieldDescription = 'User Defined Field 1'
     , SortViewFilterFieldName        = 'acUserDef1'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 2
     , SortViewFilterFieldDescription = 'User Defined Field 2'
     , SortViewFilterFieldName        = 'acUserDef2'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 3
     , SortViewFilterFieldDescription = 'User Defined Field 3'
     , SortViewFilterFieldName        = 'acUserDef3'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 4
     , SortViewFilterFieldDescription = 'User Defined Field 4'
     , SortViewFilterFieldName        = 'acUserDef4'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 5
     , SortViewFilterFieldDescription = 'Profit To Date'
     , SortViewFilterFieldName        = 'ifn_GetCustValue'
	 , SortViewFilterFieldDataType    = 'float'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 6
     , SortViewFilterFieldDescription = 'Cost Centre'
     , SortViewFilterFieldName        = 'acCostCentre'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 7
     , SortViewFilterFieldDescription = 'Department'
     , SortViewFilterFieldName        = 'acDepartment'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 8
     , SortViewFilterFieldDescription = 'Report Code/Account Type'
     , SortViewFilterFieldName        = 'acAccType'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 9
     , SortViewFilterFieldDescription = 'Status'
     , SortViewFilterFieldName        = 'acAccStatus'
	 , SortViewFilterFieldDataType    = 'int'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 10
     , SortViewFilterFieldDescription = 'User Defined Field 5'
     , SortViewFilterFieldName        = 'acUserDef5'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 11
     , SortViewFilterFieldDescription = 'User Defined Field 6'
     , SortViewFilterFieldName        = 'acUserDef6'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 12
     , SortViewFilterFieldDescription = 'User Defined Field 7'
     , SortViewFilterFieldName        = 'acUserDef7'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 13
     , SortViewFilterFieldDescription = 'User Defined Field 8'
     , SortViewFilterFieldName        = 'acUserDef8'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 14
     , SortViewFilterFieldDescription = 'User Defined Field 9'
     , SortViewFilterFieldName        = 'acUserDef9'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 15
     , SortViewFilterFieldDescription = 'User Defined Field 10'
     , SortViewFilterFieldName        = 'acserDef10'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (0, 15)

    -- Supplier Fields
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 0
     , SortViewFilterFieldDescription = 'Area Code'
     , SortViewFilterFieldName        = 'acArea'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 1
     , SortViewFilterFieldDescription = 'User Defined Field 1'
     , SortViewFilterFieldName        = 'acUserDef1'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 2
     , SortViewFilterFieldDescription = 'User Defined Field 2'
     , SortViewFilterFieldName        = 'acUserDef2'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 3
     , SortViewFilterFieldDescription = 'User Defined Field 3'
     , SortViewFilterFieldName        = 'acUserDef3'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 4
     , SortViewFilterFieldDescription = 'User Defined Field 4'
     , SortViewFilterFieldName        = 'acUserDef4'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 5
     , SortViewFilterFieldDescription = 'Profit To Date'
     , SortViewFilterFieldName        = 'ifn_GetCustValue'
	 , SortViewFilterFieldDataType    = 'float'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 6
     , SortViewFilterFieldDescription = 'Cost Centre'
     , SortViewFilterFieldName        = 'acCostCentre'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 7
     , SortViewFilterFieldDescription = 'Department'
     , SortViewFilterFieldName        = 'acDepartment'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 8
     , SortViewFilterFieldDescription = 'Report Code/Account Type'
     , SortViewFilterFieldName        = 'acAccType'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 9
     , SortViewFilterFieldDescription = 'Status'
     , SortViewFilterFieldName        = 'acAccStatus'
	 , SortViewFilterFieldDataType    = 'int'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 10
     , SortViewFilterFieldDescription = 'User Defined Field 5'
     , SortViewFilterFieldName        = 'acUserDef5'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 11
     , SortViewFilterFieldDescription = 'User Defined Field 6'
     , SortViewFilterFieldName        = 'acUserDef6'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 12
     , SortViewFilterFieldDescription = 'User Defined Field 7'
     , SortViewFilterFieldName        = 'acUserDef7'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 13
     , SortViewFilterFieldDescription = 'User Defined Field 8'
     , SortViewFilterFieldName        = 'acUserDef8'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 14
     , SortViewFilterFieldDescription = 'User Defined Field 9'
     , SortViewFilterFieldName        = 'acUserDef9'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 15
     , SortViewFilterFieldDescription = 'User Defined Field 10'
     , SortViewFilterFieldName        = 'acserDef10'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 1

-- Stock List Fields
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 0
     , SortViewFilterFieldDescription = 'Cost Centre'
     , SortViewFilterFieldName        = 'stCostCentre'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 1
     , SortViewFilterFieldDescription = 'Department'
     , SortViewFilterFieldName        = 'stDepartment'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 2
     , SortViewFilterFieldDescription = 'User Field 1'
     , SortViewFilterFieldName        = 'stUserField1'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 3
     , SortViewFilterFieldDescription = 'User Field 2'
     , SortViewFilterFieldName        = 'stUserField2'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 4
     , SortViewFilterFieldDescription = 'User Field 3'
     , SortViewFilterFieldName        = 'stUserField3'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 5
     , SortViewFilterFieldDescription = 'User Field 4'
     , SortViewFilterFieldName        = 'stUserField4'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 6
     , SortViewFilterFieldDescription = 'Stock Type'
     , SortViewFilterFieldName        = 'stType'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 7
     , SortViewFilterFieldDescription = 'Stock Location'
     , SortViewFilterFieldName        = 'stLocation'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 8
     , SortViewFilterFieldDescription = 'Bin Location'
     , SortViewFilterFieldName        = 'stBinLocation'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 9
     , SortViewFilterFieldDescription = 'User Field 5'
     , SortViewFilterFieldName        = 'stUserField5'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 10
     , SortViewFilterFieldDescription = 'User Field 6'
     , SortViewFilterFieldName        = 'stUserField6'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 11
     , SortViewFilterFieldDescription = 'User Field 7'
     , SortViewFilterFieldName        = 'stUserField7'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 12
     , SortViewFilterFieldDescription = 'User Field 8'
     , SortViewFilterFieldName        = 'stUserField8'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 13
     , SortViewFilterFieldDescription = 'User Field 9'
     , SortViewFilterFieldName        = 'stUserField9'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 14
     , SortViewFilterFieldDescription = 'User Field 10'
     , SortViewFilterFieldName        = 'stUserField10'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 4

-- Stock Reorder Fields
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 0
     , SortViewFilterFieldDescription = 'Cost Centre'
     , SortViewFilterFieldName        = 'stReorderCostCentre'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 1
     , SortViewFilterFieldDescription = 'Department'
     , SortViewFilterFieldName        = 'stReorderDepartment'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 2
     , SortViewFilterFieldDescription = 'User Field 1'
     , SortViewFilterFieldName        = 'stUserField1'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 3
     , SortViewFilterFieldDescription = 'User Field 2'
     , SortViewFilterFieldName        = 'stUserField2'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 4
     , SortViewFilterFieldDescription = 'User Field 3'
     , SortViewFilterFieldName        = 'stUserField3'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 5
     , SortViewFilterFieldDescription = 'User Field 4'
     , SortViewFilterFieldName        = 'stUserField4'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 6
     , SortViewFilterFieldDescription = 'User Field 5'
     , SortViewFilterFieldName        = 'stUserField5'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 7
     , SortViewFilterFieldDescription = 'User Field 6'
     , SortViewFilterFieldName        = 'stUserField6'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 8
     , SortViewFilterFieldDescription = 'User Field 7'
     , SortViewFilterFieldName        = 'stUserField7'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 9
     , SortViewFilterFieldDescription = 'User Field 8'
     , SortViewFilterFieldName        = 'stUserField8'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 10
     , SortViewFilterFieldDescription = 'User Field 9'
     , SortViewFilterFieldName        = 'stUserField9'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 11
     , SortViewFilterFieldDescription = 'User Field 10'
     , SortViewFilterFieldName        = 'stUserField10'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 5

-- Stock Take Fields
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 0
     , SortViewFilterFieldDescription = 'Cost Centre'
     , SortViewFilterFieldName        = 'stCostCentre'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 1
     , SortViewFilterFieldDescription = 'Department'
     , SortViewFilterFieldName        = 'stDepartment'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 2
     , SortViewFilterFieldDescription = 'User Field 1'
     , SortViewFilterFieldName        = 'stUserField1'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 3
     , SortViewFilterFieldDescription = 'User Field 2'
     , SortViewFilterFieldName        = 'stUserField2'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 4
     , SortViewFilterFieldDescription = 'User Field 3'
     , SortViewFilterFieldName        = 'stUserField3'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 5
     , SortViewFilterFieldDescription = 'User Field 4'
     , SortViewFilterFieldName        = 'stUserField4'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 6
     , SortViewFilterFieldDescription = 'User Field 5'
     , SortViewFilterFieldName        = 'stUserField5'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 7
     , SortViewFilterFieldDescription = 'User Field 6'
     , SortViewFilterFieldName        = 'stUserField6'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 8
     , SortViewFilterFieldDescription = 'User Field 7'
     , SortViewFilterFieldName        = 'stUserField7'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 9
     , SortViewFilterFieldDescription = 'User Field 8'
     , SortViewFilterFieldName        = 'stUserField8'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 10
     , SortViewFilterFieldDescription = 'User Field 9'
     , SortViewFilterFieldName        = 'stUserField9'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 11
     , SortViewFilterFieldDescription = 'User Field 10'
     , SortViewFilterFieldName        = 'stUserField10'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 6

-- Stock Ledger Fields
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 0
     , SortViewFilterFieldDescription = 'User Field 1'
     , SortViewFilterFieldName        = 'tlUserField1'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 1
     , SortViewFilterFieldDescription = 'User Field 2'
     , SortViewFilterFieldName        = 'tlUserField2'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 2
     , SortViewFilterFieldDescription = 'User Field 3'
     , SortViewFilterFieldName        = 'tlUserField3'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 3
     , SortViewFilterFieldDescription = 'User Field 4'
     , SortViewFilterFieldName        = 'tlUserField4'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 4
     , SortViewFilterFieldDescription = 'User Field 5'
     , SortViewFilterFieldName        = 'tlUserField5'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 5
     , SortViewFilterFieldDescription = 'User Field 6'
     , SortViewFilterFieldName        = 'tlUserField6'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 6
     , SortViewFilterFieldDescription = 'User Field 7'
     , SortViewFilterFieldName        = 'tlUserField7'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 7
     , SortViewFilterFieldDescription = 'User Field 8'
     , SortViewFilterFieldName        = 'tlUserField8'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 8
     , SortViewFilterFieldDescription = 'User Field 9'
     , SortViewFilterFieldName        = 'tlUserField9'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 9
     , SortViewFilterFieldDescription = 'User Field 10'
     , SortViewFilterFieldName        = 'tlUserField10'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 7

-- Job Ledger Fields
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 0
     , SortViewFilterFieldDescription = 'Document User Field 1'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField1'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 1
     , SortViewFilterFieldDescription = 'Document User Field 2'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField2'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 2
     , SortViewFilterFieldDescription = 'Document User Field 3'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField3'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 3
     , SortViewFilterFieldDescription = 'Document User Field 4'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField4'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 4
     , SortViewFilterFieldDescription = 'User Field 1'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField1'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 5
     , SortViewFilterFieldDescription = 'User Field 2'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField2'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 6
     , SortViewFilterFieldDescription = 'User Field 3'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField3'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 7
     , SortViewFilterFieldDescription = 'User Field 4'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField4'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 8
     , SortViewFilterFieldDescription = 'Document Type'
     , SortViewFilterFieldName        = 'SUBSTRING(DOCUMENT.thOurRef, 1, 3)'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 9
     , SortViewFilterFieldDescription = 'Document User Field 5'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField5'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 10
     , SortViewFilterFieldDescription = 'Document User Field 6'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField6'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 11
     , SortViewFilterFieldDescription = 'Document User Field 7'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField7'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 12
     , SortViewFilterFieldDescription = 'Document User Field 8'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField8'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 13
     , SortViewFilterFieldDescription = 'Document User Field 9'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField9'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 14
     , SortViewFilterFieldDescription = 'Document User Field 10'
     , SortViewFilterFieldName        = 'DOCUMENT.thUserField10'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 15
     , SortViewFilterFieldDescription = 'User Field 5'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField5'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 16
     , SortViewFilterFieldDescription = 'User Field 6'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField6'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 17
     , SortViewFilterFieldDescription = 'User Field 7'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField7'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 18
     , SortViewFilterFieldDescription = 'User Field 8'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField8'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 19
     , SortViewFilterFieldDescription = 'User Field 9'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField9'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 20
     , SortViewFilterFieldDescription = 'User Field 10'
     , SortViewFilterFieldName        = 'DETAILS.tlUserField10'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId = 8

-- DayBook Fields

UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 0
     , SortViewFilterFieldDescription = 'Transaction Customer Code'
     , SortViewFilterFieldName        = 'thAcCode'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 1
     , SortViewFilterFieldDescription = 'Customer Area'
     , SortViewFilterFieldName        = 'acArea'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 2
     , SortViewFilterFieldDescription = 'Customer Account Status'
     , SortViewFilterFieldName        = '(CASE acAccStatus WHEN 1 THEN ''See notes'' WHEN 2 THEN ''On hold'' WHEN 3 THEN ''Closed'' ELSE '''' END)'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 3
     , SortViewFilterFieldDescription = 'Our Reference'
     , SortViewFilterFieldName        = 'thOurRef'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 4
     , SortViewFilterFieldDescription = 'Your Reference'
     , SortViewFilterFieldName        = 'thYourRef'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 5
     , SortViewFilterFieldDescription = 'Document Type'
     , SortViewFilterFieldName        = 'SUBSTRING(thOurRef, 1, 3)'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 6
     , SortViewFilterFieldDescription = 'Transaction Date '
     , SortViewFilterFieldName        = 'thTransDate'
	 , SortViewFilterFieldDataType    = 'int'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 7
     , SortViewFilterFieldDescription = 'Transaction Year/Period (MMYYYY)'
     , SortViewFilterFieldName        = '(((thYear + 1900) * 100) + thPeriod)'
	 , SortViewFilterFieldDataType    = 'int'
     --, SortViewFilterFieldName        = 'RIGHT(''0'' + CONVERT(VARCHAR, (thPeriod * 10000) + (thYear + 1900)), 6)'
	 --, SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 8
     , SortViewFilterFieldDescription = 'Transaction Currency'
     , SortViewFilterFieldName        = 'ThCurrency'
	 , SortViewFilterFieldDataType    = 'int'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (9, 10, 11, 12, 13, 14)
UNION
SELECT SortViewListTypeId
     , SortViewListTypeDescription
     , SortViewFilterFieldId          = 9
     , SortViewFilterFieldDescription = 'Order Payment Status'
     , SortViewFilterFieldName        = 'OrderPaymentStatus'
	 , SortViewFilterFieldDataType    = 'varchar'
FROM   common.ivw_SortViewListType
WHERE  SortViewListTypeId in (11)

GO
