--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DetailsUpgraderV4.sql
--// Author			: Chris Sandow
--// Date				: 07 July 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.4 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	7 July 2010:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////
--// This actually updates EBUSDETL, which shares the same schema as DETAILS,
--// but has not previously been updated with new fields which have been added
--// to DETAILS.

SET NOCOUNT ON

IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].EBUSDETL')) 
          )
BEGIN          
  IF NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL')) 
                  AND   (col.name = 'tlDiscount2') 
              ) 
  BEGIN
    ALTER TABLE [!ActiveSchema!].EBUSDETL
    ADD                
      tlDiscount2          float NOT NULL DEFAULT 0.0,
      tlDiscount2Chr       char NOT NULL DEFAULT CHAR(0),
      tlDiscount3          float NOT NULL DEFAULT 0.0,
      tlDiscount3Chr       char NOT NULL DEFAULT CHAR(0),
      tlDiscount3Type      int NOT NULL DEFAULT 0
  END
  
  IF NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL')) 
                  AND   (col.name = 'tlECService') 
              ) 
  BEGIN
    ALTER TABLE [!ActiveSchema!].EBUSDETL
    ADD                
    tlECService          bit NOT NULL DEFAULT 0,
    tlServiceStartDate   varchar(8) NOT NULL DEFAULT CHAR(0),
    tlServiceEndDate     varchar(8) NOT NULL DEFAULT CHAR(0),
    tlECSalesTaxReported float NOT NULL DEFAULT 0.0,
    tlPurchaseServiceTax float NOT NULL DEFAULT 0.0
  END
  
  IF NOT EXISTS (
                 SELECT *
                 FROM   sysobjects tab INNER JOIN
                        syscolumns col ON tab.id = col.id
                 WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL')) 
                  AND   (col.name = 'tlReference') 
              ) 
  BEGIN
    ALTER TABLE [!ActiveSchema!].EBUSDETL
    ADD                
    tlReference          varchar(20) NOT NULL DEFAULT CHAR(0),
    tlReceiptNo          varchar(20) NOT NULL DEFAULT CHAR(0),
    tlFromPostCode       varchar(15) NOT NULL DEFAULT CHAR(0),
    tlToPostCode         varchar(15) NOT NULL DEFAULT CHAR(0)
  END
  
END

-- Now we update the Version number for Details_final.xml in the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 4
WHERE     SchemaName = 'Details_Final.xml' AND Version = 3

SET NOCOUNT OFF

