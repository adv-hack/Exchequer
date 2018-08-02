--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DOCUMENTUpgraderV4.sql
--// Author			: Chris Sandow / Simon Molloy
--// Date				: 2011-09-30
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.9 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2011-09-30:	File Creation - Chris Sandow
--//  2 2011-11-01: Added new index - Simon Molloy / Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column already exists in the table. This is
-- because all the upgrade scripts are run every time the system is upgraded,
-- so we must be careful not to try to make amendments which have already been
-- done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].DOCUMENT'))
                 AND   (col.name = 'thUserField5')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].DOCUMENT
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    thUserField5  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField6  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField7  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField8  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField9  varchar(30) NOT NULL DEFAULT CHAR(0),
    thUserField10 varchar(30) NOT NULL DEFAULT CHAR(0)
END
GO

-- Create index for this report if not already in existence
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') AND name = N'DOCUMENT_Index10_Report_GLPrePosting')
	CREATE NONCLUSTERED INDEX [DOCUMENT_Index10_Report_GLPrePosting] ON [!ActiveSchema!].[DOCUMENT]
	(
		[thRunNo] ASC,
		[thFolioNum] ASC,
		[thOurRef] ASC
	)
	INCLUDE
	(
		[thHoldFlag]
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 4
WHERE     SchemaName = 'DOCUMENT_Final.xml' AND Version = 3

SET NOCOUNT OFF

