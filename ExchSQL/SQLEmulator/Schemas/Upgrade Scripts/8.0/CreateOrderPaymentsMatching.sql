--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateOrderPaymentsMatching.sql
--// Author     : Chris Sandow
--// Date       : 7 August 2014
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description    : SQL Script to create table for the 7.x Order Payments release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 7th August 2014:  File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].OrderPaymentsMatching')) 
          )
BEGIN
  SELECT
    PositionId,
    CAST(SUBSTRING(EXCHQCHKcode1, 2, 9) AS VARCHAR(9)) AS DocRef,
    CAST(SUBSTRING(EXCHQCHKcode3, 2, 9) AS VARCHAR(9)) AS PayRef,
    common.EntDouble(SUBSTRING(EXCHQCHKCode3, 12, 1) + SettledVal, 0) AS SettledVal,
    OwnCVal,
    MCurrency,
    MatchType,  
    OldAltRef,  
    RCurrency,
    RecOwnCVal,
    AltRef 
  INTO
    [!ActiveSchema!].OrderPaymentsMatching 
  FROM
    [!ActiveSchema!].EXCHQCHK
  WHERE
    RecPFix = 'T' AND
    SubType = ASCII('R')
  -- Create primary index
  CREATE UNIQUE INDEX OrderPaymentsMatching_Index_Identity ON [!ActiveSchema!].OrderPaymentsMatching(PositionId);
  -- Create other indexes
  CREATE UNIQUE INDEX OrderPaymentsMatching_Index0 ON [!ActiveSchema!].OrderPaymentsMatching(DocRef, PositionId);
  CREATE UNIQUE INDEX OrderPaymentsMatching_Index1 ON [!ActiveSchema!].OrderPaymentsMatching(PayRef, PositionId);
  -- Delete the original records
  DELETE FROM [!ActiveSchema!].EXCHQCHK WHERE RecPFix = 'T' AND SubType = ASCII('R');
END

SET NOCOUNT OFF
