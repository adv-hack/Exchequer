--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CustSuppUpgraderV5.sql
--// Author		: Chris Sandow
--// Date		: 5 May 2015
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description	: SQL Script to upgrade table for the 7.0.14 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	5th May 2015:	File Creation - Chris Sandow
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
            WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].CustSupp'))
                 AND   (col.name = 'acAllowOrderPayments')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].CustSupp
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    acAllowOrderPayments  bit        NOT NULL DEFAULT 0,
    acOrderPaymentsGLCode INT        NOT NULL DEFAULT 0,
    acCountry             VARCHAR(2) NOT NULL DEFAULT CHAR(0),
    acDeliveryCountry     VARCHAR(2) NOT NULL DEFAULT CHAR(0),
    acPPDMode             INT        NOT NULL DEFAULT -1
END
GO

-- Customers with an existing Settlement Discount value or Settlement Discount
-- days set should have the PPD Mode set to 1
UPDATE [!ActiveSchema!].CustSupp
SET acPPDMode = 1
WHERE (acPPDMode = - 1) AND (acCustSupp = 'C') AND ((acDefSettleDays > 0) OR (acDefSettleDisc > 0))

-- Suppliers with an existing Settlement Discount value or Settlement Discount
-- days set should have the PPD Mode set to 3
UPDATE [!ActiveSchema!].CustSupp
SET acPPDMode = 3
WHERE (acPPDMode = -1) AND (acCustSupp = 'S') AND ((acDefSettleDays > 0) OR (acDefSettleDisc > 0))

-- For all other cases, set the PPD Mode to 0
UPDATE [!ActiveSchema!].CustSupp
SET acPPDMode = 0
WHERE (acPPDMode = -1)

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 5
WHERE     SchemaName = 'CustSupp_Final.xml' AND Version = 4

SET NOCOUNT OFF
