--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ivw_SortViewHeader.sql
--// Author		: Glen Jones
--// Date		: 4 July 2012
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ivw_SortViewHeader view.
--//                  Normalises the de-normalised SORTVIEW table - Header Record
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 4 July 2012 : Glen Jones : File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ivw_SortViewHeader]'))
DROP VIEW [!ActiveSchema!].[ivw_SortViewHeader]
GO

CREATE VIEW [!ActiveSchema!].ivw_SortViewHeader
AS
SELECT DISTINCT
       svrViewId
     , svrUserId
     , svrListType
     , SortViewListTypeDescription
     , svrDescr
     
FROM   [!ActiveSchema!].[SORTVIEW] SV
JOIN   common.ivw_SortViewListType svlt ON SV.svrListType = svlt.SortViewListTypeId

