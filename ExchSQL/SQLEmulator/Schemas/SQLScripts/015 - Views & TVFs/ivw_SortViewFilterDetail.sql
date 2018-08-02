--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ivw_SortViewFilterDetail.sql
--// Author		: Glen Jones
--// Date		: 4 July 2012
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ivw_SortViewFilterDetail view.
--//                  Normalises the de-normalised SORTVIEW table - Filter Detail Record
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 4 July 2012 : Glen Jones : File Creation
--//
--/////////////////////////////////////////////////////////////////////////////
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ivw_SortViewFilterDetail]'))
DROP VIEW [!ActiveSchema!].[ivw_SortViewFilterDetail]
GO

CREATE VIEW [!ActiveSchema!].ivw_SortViewFilterDetail
AS
SELECT PositionId
     , svrViewId
     , RowNo               = 1
     , ListTypeId          = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled           = svfEnabled01
     , FieldId             = svfFieldId01
     , FieldName           = SVF.SortViewFilterFieldName
	 , FieldDataType       = SVF.SortViewFilterFieldDataType
     , ComparisonTypeId    = svfComparison01
     , ComparisonOperator
     , ComparisonValue     = svfValue01

FROM   [!ActiveSchema!].[SORTVIEW]       SV
JOIN   common.ivw_ComparisonType         CT  ON svfComparison01 = CT.ComparisonTypeId
LEFT JOIN common.ivw_SortViewListType    LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewFilterField SVF ON SV.svfFieldId01 = SVF.SortViewFilterFieldId
                                            AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svfEnabled01 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo               = 2
     , ListTypeId          = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled           = svfEnabled02
     , FieldId             = svfFieldId02
     , FieldName           = SVF.SortViewFilterFieldName
	 , FieldDataType       = SVF.SortViewFilterFieldDataType
     , ComparisonTypeId    = svfComparison02
     , ComparisonOperator
     , ComparisonValue     = svfValue02

FROM   [!ActiveSchema!].[SORTVIEW]       SV
JOIN   common.ivw_ComparisonType         CT  ON svfComparison02 = CT.ComparisonTypeId
LEFT JOIN common.ivw_SortViewListType    LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewFilterField SVF ON SV.svfFieldId02 = SVF.SortViewFilterFieldId
                                            AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svfEnabled02 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo               = 3
     , ListTypeId          = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled           = svfEnabled03
     , FieldId             = svfFieldId03
     , FieldName           = SVF.SortViewFilterFieldName
	 , FieldDataType       = SVF.SortViewFilterFieldDataType
     , ComparisonTypeId    = svfComparison03
     , ComparisonOperator
     , ComparisonValue     = svfValue03
     
FROM   [!ActiveSchema!].[SORTVIEW]       SV
JOIN   common.ivw_ComparisonType         CT  ON svfComparison03 = CT.ComparisonTypeId
LEFT JOIN common.ivw_SortViewListType    LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewFilterField SVF ON SV.svfFieldId03 = SVF.SortViewFilterFieldId
                                            AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svfEnabled03 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo               = 4
     , ListTypeId          = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled           = svfEnabled04
     , FieldId             = svfFieldId04
     , FieldName           = SVF.SortViewFilterFieldName
	 , FieldDataType       = SVF.SortViewFilterFieldDataType
     , ComparisonTypeId    = svfComparison04
     , ComparisonOperator
     , ComparisonValue     = svfValue04
     
FROM   [!ActiveSchema!].[SORTVIEW]       SV
JOIN   common.ivw_ComparisonType         CT  ON svfComparison04 = CT.ComparisonTypeId
LEFT JOIN common.ivw_SortViewListType    LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewFilterField SVF ON SV.svfFieldId04 = SVF.SortViewFilterFieldId
                                            AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svfEnabled04 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo               = 5
     , ListTypeId          = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled           = svfEnabled05
     , FieldId             = svfFieldId05
     , FieldName           = SVF.SortViewFilterFieldName
	 , FieldDataType       = SVF.SortViewFilterFieldDataType
     , ComparisonTypeId    = svfComparison05
     , ComparisonOperator
     , ComparisonValue     = svfValue05

FROM   [!ActiveSchema!].[SORTVIEW]       SV
JOIN   common.ivw_ComparisonType         CT  ON svfComparison05 = CT.ComparisonTypeId
LEFT JOIN common.ivw_SortViewListType    LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewFilterField SVF ON SV.svfFieldId05 = SVF.SortViewFilterFieldId
                                            AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svfEnabled05 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo               = 6
     , ListTypeId          = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled           = svfEnabled06
     , FieldId             = svfFieldId06
     , FieldName           = SVF.SortViewFilterFieldName
	 , FieldDataType       = SVF.SortViewFilterFieldDataType
     , ComparisonTypeId    = svfComparison06
     , ComparisonOperator
     , ComparisonValue     = svfValue06

FROM   [!ActiveSchema!].[SORTVIEW]       SV
JOIN   common.ivw_ComparisonType         CT  ON svfComparison06 = CT.ComparisonTypeId
LEFT JOIN common.ivw_SortViewListType    LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewFilterField SVF ON SV.svfFieldId06 = SVF.SortViewFilterFieldId
                                            AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svfEnabled06 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo               = 7
     , ListTypeId          = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled           = svfEnabled07
     , FieldId             = svfFieldId07
     , FieldName           = SVF.SortViewFilterFieldName
	 , FieldDataType       = SVF.SortViewFilterFieldDataType
     , ComparisonTypeId    = svfComparison07
     , ComparisonOperator
     , ComparisonValue     = svfValue07     

FROM   [!ActiveSchema!].[SORTVIEW]       SV
JOIN   common.ivw_ComparisonType         CT  ON svfComparison07 = CT.ComparisonTypeId
LEFT JOIN common.ivw_SortViewListType    LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewFilterField SVF ON SV.svfFieldId07 = SVF.SortViewFilterFieldId
                                            AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svfEnabled07 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo               = 8
     , ListTypeId          = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled           = svfEnabled08
     , FieldId             = svfFieldId08
     , FieldName           = SVF.SortViewFilterFieldName
	 , FieldDataType       = SVF.SortViewFilterFieldDataType
     , ComparisonTypeId    = svfComparison08
     , ComparisonOperator
     , ComparisonValue     = svfValue08
     
FROM   [!ActiveSchema!].[SORTVIEW]       SV
JOIN   common.ivw_ComparisonType         CT  ON svfComparison08 = CT.ComparisonTypeId
LEFT JOIN common.ivw_SortViewListType    LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewFilterField SVF ON SV.svfFieldId08 = SVF.SortViewFilterFieldId
                                            AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svfEnabled08 = 1

GO
