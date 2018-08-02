--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ivw_SortViewSortDetail.sql
--// Author		: Glen Jones
--// Date		: 4 July 2012
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ivw_SortViewSortDetail view.
--//                  Normalises the de-normalised SORTVIEW table - Sort Detail Record
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 4 July 2012 : Glen Jones : File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ivw_SortViewSortDetail]'))
DROP VIEW [!ActiveSchema!].[ivw_SortViewSortDetail]
GO

CREATE VIEW [!ActiveSchema!].ivw_SortViewSortDetail
AS
--23rd July 2012: Sorting not relevent at this point, but may be required in the future.  CS/GJ
SELECT PositionId
     , svrViewId
     , RowNo       = 1
     , ListTypeId  = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled   = svsEnabled01
     , FieldId     = svsFieldId01
     , FieldName   = SVF.SortViewSortFieldName
     , IsAscending = svsAscending01

FROM   [!ActiveSchema!].[SORTVIEW]     SV
LEFT JOIN common.ivw_SortViewListType  LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewSortField SVF ON SV.svsFieldId01 = SVF.SortViewSortFieldId
                                          AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svsEnabled01 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo       = 2
     , ListTypeId  = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled   = svsEnabled02
     , FieldId     = svsFieldId02
     , FieldName   = SVF.SortViewSortFieldName
     , IsAscending = svsAscending02

FROM   [!ActiveSchema!].[SORTVIEW] SV
LEFT JOIN common.ivw_SortViewListType  LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewSortField SVF ON SV.svsFieldId02 = SVF.SortViewSortFieldId
                                          AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svsEnabled02 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo       = 3
     , ListTypeId  = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled   = svsEnabled03
     , FieldId     = svsFieldId03
     , FieldName   = SVF.SortViewSortFieldName
     , IsAscending = svsAscending03

FROM   [!ActiveSchema!].[SORTVIEW] SV
LEFT JOIN common.ivw_SortViewListType  LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewSortField SVF ON SV.svsFieldId03 = SVF.SortViewSortFieldId
                                          AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svsEnabled03 = 1
UNION
SELECT PositionId
     , svrViewId
     , RowNo       = 4
     , ListTypeId  = SV.svrListType
     , ListTypeDescription = LT.SortViewListTypeDescription
     , IsEnabled   = svsEnabled04
     , FieldId     = svsFieldId04
     , FieldName   = SVF.SortViewSortFieldName
     , IsAscending = svsAscending04

FROM   [!ActiveSchema!].[SORTVIEW] SV
LEFT JOIN common.ivw_SortViewListType  LT  ON SV.svrListType  = LT.SortViewListTypeId
LEFT JOIN common.ivw_SortViewSortField SVF ON SV.svsFieldId04 = SVF.SortViewSortFieldId
                                          AND SV.svrListType  = SVF.SortViewListTypeId
WHERE  svsEnabled04 = 1

GO

