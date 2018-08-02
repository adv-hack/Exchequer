--/////////////////////////////////////////////////////////////////////////////
--// Filename		: idx_HISTORY_Index_OLE.sql
--// Author		: James Waygood
--// Date		: 13th February 2013
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script used by isp_SaveNominalValue
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'HISTORY_Index_OLE')
DROP INDEX [HISTORY_Index_OLE] ON [!ActiveSchema!].[HISTORY] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [HISTORY_Index_OLE] ON [!ActiveSchema!].[HISTORY] 
(
	[hiCode] ASC,
	[hiExCLass] ASC,
	[hiCurrency] ASC,
	[hiYear] ASC,
	[hiPeriod] ASC
)
INCLUDE ( [hiBudget],
	[hiRevisedBudget1],
	[hiRevisedBudget2],
	[hiRevisedBudget3],
	[hiRevisedBudget4],
	[hiRevisedBudget5],
[PositionId]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


