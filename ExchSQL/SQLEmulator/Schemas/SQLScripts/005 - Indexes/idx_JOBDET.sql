--/////////////////////////////////////////////////////////////////////////////
--// Filename		: idx_JOBDET.sql
--// Author		: Glen Jones, Chris Sandow
--// Date		: 2014-07-07
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to upgrade table for the v7.0.11 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2014-07-07:	File Creation - Glen Jones, Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check to see if the new columns already exist in the table. This is
-- because all the upgrade/install scripts are run every time the system is
-- installed or upgraded, so we must be careful not to try to make amendments 
-- which have already been done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].JOBDET'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].JOBDET'))
                 AND   (col.name = 'CurrencyId')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].JOBDET ADD
       CurrencyId AS (CONVERT([int],substring([var_code10],(1),(1)),(0))) PERSISTED ,
       JobTranYear AS (CONVERT([int],substring([var_code10],(2),(1)),(0))) PERSISTED ,
       JobTranPeriod AS (CONVERT([int],substring([var_code10],(3),(1)),(0))) PERSISTED 
END
GO

-- Create the new index
DECLARE @table_id INT
SET @table_id = object_id('[!ActiveSchema!].[JOBDET]')

IF NOT EXISTS (
	SELECT name FROM sys.indexes
	WHERE object_id = @table_id
	  AND name = 'idx_JOBDET'
)
BEGIN
  
  CREATE NONCLUSTERED INDEX [idx_JOBDET] ON [!ActiveSchema!].[JOBDET] 
  (
        [RecPfix] ASC,
        [SubType] ASC,
        [Posted] ASC,
        [JobCode] ASC,
        [OrigNCode] ASC,
        [JDDT] ASC
  )
  INCLUDE ( [var_code4],
  [var_code5],
  [LineFolio],
  [LineNUmber],
  [StockCode],
  [CurrencyId],
  [JobTranYear],
  [JobTranPeriod]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
END
GO

SET NOCOUNT OFF
