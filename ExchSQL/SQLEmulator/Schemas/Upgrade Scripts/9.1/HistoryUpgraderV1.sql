--/////////////////////////////////////////////////////////////////////////////
--// Filename		: HistoryUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 2016-05-05
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 2016 R2 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	5th May 2016:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Because the HISTORY_All view is schema bound this need to be dropped before columns can be renamed

IF EXISTS(SELECT TOP 1 1 FROM sys.tables WHERE object_id = OBJECT_ID('!ActiveSchema!.HISTORY'))
BEGIN

    IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY_All]'))
    DROP VIEW [!ActiveSchema!].[HISTORY_All]
    
    
    IF NOT EXISTS (SELECT TOP 1 1
                   FROM   sys.columns
                   WHERE  OBJECT_SCHEMA_NAME(object_id) = '!ActiveSchema!'
                   AND    OBJECT_NAME(object_id)        = 'HISTORY'
                   AND    name = 'hiRevisedBudget1')
    BEGIN
      EXEC sp_rename '!ActiveSchema!.HISTORY.hiBudget2','hiRevisedBudget1','COLUMN'
    END
    
    
    IF NOT EXISTS (SELECT TOP 1 1
                   FROM   sys.columns
                   WHERE  OBJECT_SCHEMA_NAME(object_id) = '!ActiveSchema!'
                   AND    OBJECT_NAME(object_id)        = 'HISTORY'
                   AND    name = 'hiRevisedBudget2')
    BEGIN
      EXEC sp_rename '!ActiveSchema!.HISTORY.hiSpareV1','hiRevisedBudget2','COLUMN'
    END
    
    
    IF NOT EXISTS (SELECT TOP 1 1
                   FROM   sys.columns
                   WHERE  OBJECT_SCHEMA_NAME(object_id) = '!ActiveSchema!'
                   AND    OBJECT_NAME(object_id)        = 'HISTORY'
                   AND    name = 'hiRevisedBudget3')
    BEGIN
      EXEC sp_rename '!ActiveSchema!.HISTORY.hiSpareV2','hiRevisedBudget3','COLUMN'
    END
    
    
    IF NOT EXISTS (SELECT TOP 1 1
                   FROM   sys.columns
                   WHERE  OBJECT_SCHEMA_NAME(object_id) = '!ActiveSchema!'
                   AND    OBJECT_NAME(object_id)        = 'HISTORY'
                   AND    name = 'hiRevisedBudget4')
    BEGIN
      EXEC sp_rename '!ActiveSchema!.HISTORY.hiSpareV3','hiRevisedBudget4','COLUMN'
    END
    
    
    IF NOT EXISTS (SELECT TOP 1 1
                   FROM   sys.columns
                   WHERE  OBJECT_SCHEMA_NAME(object_id) = '!ActiveSchema!'
                   AND    OBJECT_NAME(object_id)        = 'HISTORY'
                   AND    name = 'hiRevisedBudget5')
    BEGIN
      EXEC sp_rename '!ActiveSchema!.HISTORY.hiSpareV4','hiRevisedBudget5','COLUMN'
    END
    
    
    IF NOT EXISTS (SELECT TOP 1 1
                   FROM   sys.columns
                   WHERE  OBJECT_SCHEMA_NAME(object_id) = '!ActiveSchema!'
                   AND    OBJECT_NAME(object_id)        = 'HISTORY'
                   AND    name = 'hiSpareV')
    BEGIN
      EXEC sp_rename '!ActiveSchema!.HISTORY.hiSpareV5','hiSpareV','COLUMN'
    END
    
    
    -- Add new calculated column for hiBudget2 for backward compatibility for Exchequer Analytics and Exchequer LIVE
    IF NOT EXISTS (SELECT TOP 1 1
                   FROM   sys.columns
                   WHERE  OBJECT_SCHEMA_NAME(object_id) = '!ActiveSchema!'
                   AND    OBJECT_NAME(object_id)        = 'HISTORY'
                   AND    name = 'hiBudget2')
    BEGIN
      ALTER TABLE !ActiveSchema!.HISTORY
            ADD hiBudget2 AS hiRevisedBudget1
    END  
    ;
    
    -- Recreate HISTORY_All View
    EXEC sp_executesql N'
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
    FROM   [!ActiveSchema!].[HISTORY]
    '
    
    -- Create History View Index
    EXEC sp_executesql N'
    CREATE UNIQUE CLUSTERED INDEX [HISTORY_All_Clustered_Index] ON [!ActiveSchema!].[HISTORY_All]
    (
         [hiExClass] ASC,
         [hiCodeComputed] ASC,
         [hiCurrency] ASC,
         [hiYear] ASC,
         [hiPeriod] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
    '
END

--/////////////////////////////////////////////////////////////////////////////
-- Update the Version number for the SchemaVersion table
--/////////////////////////////////////////////////////////////////////////////
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 1
WHERE     SchemaName = 'History_Final.xml' AND Version = 0

SET NOCOUNT OFF

