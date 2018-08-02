--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CustomerStockAnalysisCreator.sql
--// Author			: Chris Sandow
--// Date				: 1 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	1st February 2010:	File Creation - Chris Sandow
--//	2	7th April 2010:	    Added CsIndex column - Chris Sandow
--//	3 8th April 2010:	    Added CsIndexComputed column - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].CustomerStockAnalysis')) 
          )
BEGIN
  CREATE TABLE [!ActiveSchema!].[CustomerStockAnalysis](
    [PositionId] [int] IDENTITY(1,1) NOT NULL,
    [CsIndex] [varbinary](27) NOT NULL,
    [CsCustCode] [varchar](10) NOT NULL,
    [CsStockCode] [varchar](20) NOT NULL,
    [CsStkFolio] [int] NOT NULL,
    [CsSOQty] [float] NOT NULL,
    [CsLastDate] [varchar](8) NOT NULL,
    [CsLineNo] [int] NOT NULL,
    [CsLastPrice] [float] NOT NULL,
    [CsLPCurr] [int] NOT NULL,
    [CsJobCode] [varchar](10) NOT NULL,
    [CsJACode] [varchar](10) NOT NULL,
    [CsLocCode] [varchar](5) NOT NULL,
    [CsNomCode] [int] NOT NULL,
    [CsDepartment] [varchar](3) NOT NULL,
    [CsCostCentre] [varchar](3) NOT NULL,
    [CsQty] [float] NOT NULL,
    [CsNetValue] [float] NOT NULL,
    [CsDiscount] [float] NOT NULL,
    [CsVATCode] [varchar](1) NOT NULL,
    [CsCost] [float] NOT NULL,
    [CsDesc1] [varchar](35) NOT NULL,
    [CsDesc2] [varchar](35) NOT NULL,
    [CsDesc3] [varchar](35) NOT NULL,
    [CsDesc4] [varchar](35) NOT NULL,
    [CsDesc5] [varchar](35) NOT NULL,
    [CsDesc6] [varchar](35) NOT NULL,
    [CsVAT] [float] NOT NULL,
    [CsPrxPack] [bit] NOT NULL,
    [CsQtyPack] [float] NOT NULL,
    [CsQtyMul] [float] NOT NULL,
    [CsDiscCh] [varchar](1) NOT NULL,
    [CsEntered] [bit] NOT NULL,
    [CsUsePack] [bit] NOT NULL,
    [CsShowCase] [bit] NOT NULL,
    [CsLineType] [int] NOT NULL,
    [CsPriceMulX] [float] NOT NULL,
    [CsVATIncFlg] [varchar](1) NOT NULL,
    [CsIndexComputed] AS (substring([CsIndex],(2),(26)))
  )

  INSERT INTO [!ActiveSchema!].CustomerStockAnalysis
  (
     [CsIndex]
    ,[CsCustCode]
    ,[CsStockCode]
    ,[CsStkFolio]
    ,[CsSOQty]
    ,[CsLastDate]
    ,[CsLineNo]
    ,[CsLastPrice]
    ,[CsLPCurr]
    ,[CsJobCode]
    ,[CsJACode]
    ,[CsLocCode]
    ,[CsNomCode]
    ,[CsDepartment]
    ,[CsCostCentre]
    ,[CsQty]
    ,[CsNetValue]
    ,[CsDiscount]
    ,[CsVATCode]
    ,[CsCost]
    ,[CsDesc1]
    ,[CsDesc2]
    ,[CsDesc3]
    ,[CsDesc4]
    ,[CsDesc5]
    ,[CsDesc6]
    ,[CsVAT]
    ,[CsPrxPack]
    ,[CsQtyPack]
    ,[CsQtyMul]
    ,[CsDiscCh]
    ,[CsEntered]
    ,[CsUsePack]
    ,[CsShowCase]
    ,[CsLineType]
    ,[CsPriceMulX]
    ,[CsVATIncFlg]
  )
  SELECT  SUBSTRING(varCode2, 1, 27)
         ,CsCustCode
         ,CsStockCode
         ,CsStkFolio
         ,ISNULL(CsSOQty, 0)
         ,ISNULL(CsLastDate, '')
         ,CsLineNo
         ,ISNULL(CsLastPrice, 0)
         ,ISNULL(CsLPCurr, 0)
         ,ISNULL(CsJobCode, '')
         ,ISNULL(CsJACode, '')
         ,ISNULL(CsLocCode, '')
         ,ISNULL(CsNomCode, 0)
         ,ISNULL(CsDepartment, '')
         ,ISNULL(CsCostCentre, '')
         ,ISNULL(CsQty, 0)
         ,ISNULL(CsNetValue, 0)
         ,ISNULL(CsDiscount, 0)
         ,ISNULL(CsVATCode, ' ')
         ,ISNULL(CsCost, 0)
         ,ISNULL(CsDesc1, '')
         ,ISNULL(CsDesc2, '')
         ,ISNULL(CsDesc3, '')
         ,ISNULL(CsDesc4, '')
         ,ISNULL(CsDesc5, '')
         ,ISNULL(CsDesc6, '')
         ,ISNULL(CsVAT, 0)
         ,ISNULL(CsPrxPack, 0)
         ,ISNULL(CsQtyPack, 0)
         ,ISNULL(CsQtyMul, 0)
         ,ISNULL(CsDiscCh, ' ')
         ,ISNULL(CsEntered, 0)
         ,ISNULL(CsUsePack, 0)
         ,ISNULL(CsShowCase, 0)
         ,ISNULL(CsLineType, 0)
         ,ISNULL(CsPriceMulX, 0)
         ,ISNULL(CsVATIncFlg, ' ')
  FROM [!ActiveSchema!].[MLOCSTK]
  WHERE RecPfix = 'T' AND SubType = 'P'
  -- Create primary index
  CREATE UNIQUE INDEX CustomerStockAnalysis_Index_Identity ON [!ActiveSchema!].CustomerStockAnalysis(PositionId);
  -- Create other indexes
  CREATE UNIQUE INDEX CustomerStockAnalysis_Index0 ON [!ActiveSchema!].CustomerStockAnalysis(CsCustCode, CsLineNo, PositionId);
  CREATE UNIQUE INDEX CustomerStockAnalysis_Index1 ON [!ActiveSchema!].CustomerStockAnalysis(CsIndexComputed, PositionId);
  CREATE UNIQUE INDEX CustomerStockAnalysis_Index2 ON [!ActiveSchema!].CustomerStockAnalysis(CsStockCode, CsCustCode, PositionId);
  -- Delete the original records
--  DELETE FROM [!ActiveSchema!].MLOCSTK WHERE (RecPfix = 'T') AND (SubType = 'P');
END

SET NOCOUNT OFF

