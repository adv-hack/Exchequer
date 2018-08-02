--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ivw_CreateHistoryViews.sql
--// Author		: Simon Molloy 
--// Date		: 14 September 2011 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: isp_TotalProfitToDate SQL performance modifications.
--//                  Drops all existing history views and functions and replaces with just one view and function. 
--//                	Stored procedure modified to reflect changes.
--//        	        Reduced number of schema bound views should improve write speed whilst use of binary input parameter
--//        	        and exact match and no casting in where clause dramatically improves performance for reads.
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 14 September 2011: Simon Molloy : File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

--
-- Drop all existing views
--------------------------

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_56]'))
DROP VIEW [!ActiveSchema!].[HISTORY_56]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_57]'))
DROP VIEW [!ActiveSchema!].[HISTORY_57]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_69_0x01]'))
DROP VIEW [!ActiveSchema!].[HISTORY_69_0x01]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_69_0x02]'))
DROP VIEW [!ActiveSchema!].[HISTORY_69_0x02]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_69_0x41]'))
DROP VIEW [!ActiveSchema!].[HISTORY_69_0x41]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_69_Other]'))
DROP VIEW [!ActiveSchema!].[HISTORY_69_Other]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_74]'))
DROP VIEW [!ActiveSchema!].[HISTORY_74]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_85]'))
DROP VIEW [!ActiveSchema!].[HISTORY_85]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_86]'))
DROP VIEW [!ActiveSchema!].[HISTORY_86]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_90]'))
DROP VIEW [!ActiveSchema!].[HISTORY_90]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_236]'))
DROP VIEW [!ActiveSchema!].[HISTORY_236]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_239]'))
DROP VIEW [!ActiveSchema!].[HISTORY_239]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_247]'))
DROP VIEW [!ActiveSchema!].[HISTORY_247]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_Other]'))
DROP VIEW [!ActiveSchema!].[HISTORY_Other]
GO

--
-- Create new single view
-------------------------
IF  NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_All]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [!ActiveSchema!].[HISTORY_All]
WITH SCHEMABINDING
AS
SELECT hiExClass
     , hiCodeComputed
     , hiCurrency
     , hiYear
     , hiPeriod
     , hiSales
     , hiPurchases
     , hiBudget
     , hiCleared
     , hiRevisedBudget1
     , hiRevisedBudget2
     , hiRevisedBudget3
     , hiRevisedBudget4
     , hiRevisedBudget5
     , hiValue1
     , hiValue2
FROM [!ActiveSchema!].[HISTORY]
'

--
-- Clustered index on view
--------------------------
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_All]') AND name = N'HISTORY_All_Clustered_Index')
CREATE UNIQUE CLUSTERED INDEX [HISTORY_All_Clustered_Index] ON [!ActiveSchema!].[HISTORY_All] 
(
	[hiExClass] ASC,
	[hiCodeComputed] ASC,
	[hiCurrency] ASC,
	[hiYear] ASC,
	[hiPeriod] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
