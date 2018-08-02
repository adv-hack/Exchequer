--/////////////////////////////////////////////////////////////////////////////
--// Filename		: TransactionNoteCreator.sql
--// Author			: Chris Sandow
--// Date				: 5 January 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	5th January 2010:	File Creation - Chris Sandow
--//  2 20th May 2010: Added TRY...CATCH - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

BEGIN TRY
  DECLARE @ErrorMessage   NVARCHAR(1000)
        , @DisplayMessage NVARCHAR(1000)
        , @ErrorNumber    INT
        , @ErrorSeverity  INT
        , @ErrorState     INT
        , @ErrorLine      INT
        , @ErrorProcedure NVARCHAR(400)
        , @ReturnValue    INT

  -- Check that table does not already exist.
  IF NOT EXISTS (
              SELECT  *
              FROM    sysobjects tab 
              WHERE   (tab.id = object_id('[!ActiveSchema!].TRANSACTIONNOTE')) 
            )
  BEGIN
    SELECT
      PositionId,
      COMMON.GetFolio(exchqchkcode1,1) AS NoteFolio,
    --CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), NoteFolio),2,4))) AS INTEGER) AS NoteFolio,
      CAST(SUBSTRING(EXCHQCHKCode2, 2, 8) AS VARCHAR(8)) AS NoteDate,
      CAST(SUBSTRING(EXCHQCHKCode3, 2, 8) AS VARCHAR(8)) AS NoteAlarm,
      NType AS NoteType,
      LineNumber,
      NoteLine,
      NoteUser,
      TmpImpCode,
      ShowDate, 
      RepeatNo, 
      NoteFor
    INTO
      [!ActiveSchema!].TransactionNote
    FROM
      [!ActiveSchema!].EXCHQCHK
    WHERE
      RecPFix = 'N' AND
      SubType = ASCII('D');
    -- Create primary index
    CREATE UNIQUE INDEX TransactionNote_Index_Identity ON [!ActiveSchema!].TransactionNote(PositionId);
    -- Create other indexes
    CREATE UNIQUE INDEX TransactionNote_Index0 ON [!ActiveSchema!].TransactionNote(NoteFolio, NoteType, LineNumber, PositionId);
    -- Delete the original records
    DELETE FROM [!ActiveSchema!].EXCHQCHK WHERE RecPFix = 'N' AND SubType = ASCII('D');
    -- Set blank NoteAlarms to empty strings
    UPDATE [!ActiveSchema!].TransactionNote SET NoteAlarm = '' WHERE CAST(NoteAlarm AS VARBINARY) = 0x0000000000000000;
  END
  
END TRY
BEGIN CATCH
  -- Assign variables to error-handling functions to 
  -- capture information for RAISERROR.

  SELECT @ErrorNumber    = ISNULL(ERROR_NUMBER(), -1)
       , @ErrorSeverity  = ISNULL(ERROR_SEVERITY(), 1)
       , @ErrorState     = ISNULL(ERROR_STATE(), 1)
       , @ErrorLine      = ISNULL(ERROR_LINE(), 1)
       , @ErrorMessage   = ISNULL(ERROR_MESSAGE(), '')
       , @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '')

  -- parameter of RAISERROR.
  RAISERROR (   @ErrorMessage
              , @ErrorSeverity 
              , 1
              , @ErrorNumber    -- parameter: original error number.
              , @ErrorSeverity  -- parameter: original error severity.
              , @ErrorState     -- parameter: original error state.
              , @ErrorProcedure -- parameter: original error procedure name.
              , @ErrorLine      -- parameter: original error line number.
            )   WITH NOWAIT

END CATCH

SET NOCOUNT OFF

