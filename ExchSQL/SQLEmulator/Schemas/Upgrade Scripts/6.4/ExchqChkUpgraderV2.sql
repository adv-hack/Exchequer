--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ExchqChkUpgraderV2.sql
--// Author			: Chris Sandow
--// Date				: 9 July 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to update the table structure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	9th July 2010:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

DECLARE @ErrorMessage   NVARCHAR(1000)
      , @DisplayMessage NVARCHAR(1000)
      , @ErrorNumber    INT
      , @ErrorSeverity  INT
      , @ErrorState     INT
      , @ErrorLine      INT
      , @ErrorProcedure NVARCHAR(400)
      , @ReturnValue    INT

-- First we check to see if the new column exists in table
IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].EXCHQCHK')) 
          )
   AND
   NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].EXCHQCHK')) 
                  AND   (col.name = 'YourRef') 
              ) 
BEGIN
  ALTER TABLE [!ActiveSchema!].EXCHQCHK
  ADD 
    YourRef VARCHAR(20)
END

-- Now we update the Version number in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'EXCHQCHK_Final.xml' AND Version = 1

SET NOCOUNT OFF
