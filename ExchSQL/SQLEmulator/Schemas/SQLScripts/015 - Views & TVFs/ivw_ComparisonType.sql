--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ivw_ComparisonType.sql
--// Author		: Glen Jones
--// Date		: 4 July 2012
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ivw_ComparisonType view
--//                  Puts the valid field comparisons into table form - used in SortView
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 4 July 2012 : Glen Jones : File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[ivw_ComparisonType]'))
DROP VIEW [common].[ivw_ComparisonType]
GO

CREATE VIEW common.ivw_ComparisonType
AS
SELECT ComparisonTypeId          = -1
     , ComparisonTypeDescription = 'Not Defined'
     , ComparisonOperator        = ''
UNION
SELECT ComparisonTypeId          = 0
     , ComparisonTypeDescription = 'Equal'
     , ComparisonOperator        = '='
UNION
SELECT ComparisonTypeId          = 1
     , ComparisonTypeDescription = 'Not Equal'
     , ComparisonOperator        = '<>'
UNION
SELECT ComparisonTypeId          = 2
     , ComparisonTypeDescription = 'Less Than'
     , ComparisonOperator        = '<'
UNION
SELECT ComparisonTypeId          = 3
     , ComparisonTypeDescription = 'Less Than Or Equal'
     , ComparisonOperator        = '<='
UNION
SELECT ComparisonTypeId          = 4
     , ComparisonTypeDescription = 'Greater Than'
     , ComparisonOperator        = '>'
UNION
SELECT ComparisonTypeId          = 5
     , ComparisonTypeDescription = 'Greater Than Or Equal'
     , ComparisonOperator        = '>='
UNION
SELECT ComparisonTypeId          = 6
     , ComparisonTypeDescription = 'Starts With'
     , ComparisonOperator        = 'LIKE'
UNION
SELECT ComparisonTypeId          = 7
     , ComparisonTypeDescription = 'Contains'
     , ComparisonOperator        = 'LIKE'
     
GO
