--/////////////////////////////////////////////////////////////////////////////
--// Filename		    : CustsuppCollateUpgraderV8.sql
--// Author			    : Trapti Gupta	
--// Date				: 13 June 2017
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2016. All rights reserved.
--// Description		: SQL Script to upgrade table for the 9.1 release
SET NOCOUNT ON

--Validating weather or not the columns to be operated exists.

IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
          )
   AND
   EXISTS (
            SELECT *
            FROM   sysobjects tab INNER JOIN
            syscolumns col ON tab.id = col.id
            WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
            AND   (col.name = 'acAccType')
          )
	AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acAddressLine1')
            )	
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acAddressLine2')
            )	
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acAddressLine3')
            )	
	AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acAddressLine4')
            )	
	AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acAddressLine5')
            )
	AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acArea')
            )
	AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acContact')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acDeliveryPostCode')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acDespAddressLine1')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acDespAddressLine2')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acDespAddressLine3')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acDespAddressLine4')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acDespAddressLine5')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acTradeTerms1')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acTradeTerms2')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef1')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef2')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef3')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef4')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef5')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef6')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef7')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef8')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef9')
            )
    AND
	EXISTS (
             SELECT *
             FROM   sysobjects tab INNER JOIN
             syscolumns col ON tab.id = col.id
             WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
             AND   (col.name = 'acUserDef10')
            )
    
BEGIN

--Altering All the columns so to be collated SQL_Latin1_General_CP1_CI_AS
--CP1 - Codepage 1
--CI - Case Insensitive
--AS - Accent Sensitive.

ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acAccType varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acAddressLine1 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acAddressLine2 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acAddressLine3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acAddressLine4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acAddressLine5 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acArea varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acContact varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acDeliveryPostCode varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acDespAddressLine1 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acDespAddressLine2 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acDespAddressLine3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acDespAddressLine4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acDespAddressLine5 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acTradeTerms1 varchar(80) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acTradeTerms2 varchar(80) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef1 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef2 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef3 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef4 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef5 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef6 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef7 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef8 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef9 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS
ALTER TABLE [!ActiveSchema!].[CustSupp] ALTER COLUMN acUserDef10 varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS

END 

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 8
WHERE     SchemaName = 'CustSupp_final.xml' AND Version = 7


SET NOCOUNT OFF
