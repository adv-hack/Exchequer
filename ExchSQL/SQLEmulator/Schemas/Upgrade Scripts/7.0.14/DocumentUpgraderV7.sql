--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DOCUMENTUpgraderV7.sql
--// Author			: Chris Sandow
--// Date				: 23 March 2015
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 7.0.14 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	23 March 2015:	Added new fields for Prompt Payment Discounts - Chris Sandow
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
                 AND   (col.name = 'thOrderPaymentOrderRef')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].DOCUMENT
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    thOrderPaymentOrderRef      varchar(10)   NOT NULL DEFAULT CHAR(0),
    thOrderPaymentElement       int           NOT NULL DEFAULT 0,
    thOrderPaymentFlags         int           NOT NULL DEFAULT 0,
    thCreditCardType            varchar(4)    NOT NULL DEFAULT CHAR(0),
    thCreditCardNumber          varchar(4)    NOT NULL DEFAULT CHAR(0),
    thCreditCardExpiry          varchar(4)    NOT NULL DEFAULT CHAR(0),
    thCreditCardAuthorisationNo varchar(20)   NOT NULL DEFAULT CHAR(0),
    thCreditCardReferenceNo     varchar(70)   NOT NULL DEFAULT CHAR(0),
    thCustomData1               varchar(30)   NOT NULL DEFAULT CHAR(0),
    thDeliveryCountry           varchar(2)    NOT NULL DEFAULT CHAR(0),
    thPPDPercentage             float         NOT NULL DEFAULT 0.0,
    thPPDDays                   int           NOT NULL DEFAULT 0,
    thPPDGoodsValue             float         NOT NULL DEFAULT 0.0,
    thPPDVATValue               float         NOT NULL DEFAULT 0.0,
    thPPDTaken                  int           NOT NULL DEFAULT 0,
    thPPDCreditNote             bit           NOT NULL DEFAULT 0,
    thBatchPayPPDStatus         int           NOT NULL DEFAULT 0
END
GO

-- Also add the field to EBUSDOC
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDOC'))
                 AND   (col.name = 'thOrderPaymentOrderRef')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDOC
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    thOrderPaymentOrderRef      varchar(10)   NOT NULL DEFAULT CHAR(0),
    thOrderPaymentElement       Integer       NOT NULL DEFAULT 0,
    thOrderPaymentFlags         Integer       NOT NULL DEFAULT 0,
    thCreditCardType            varchar(4)    NOT NULL DEFAULT CHAR(0),
    thCreditCardNumber          varchar(4)    NOT NULL DEFAULT CHAR(0),
    thCreditCardExpiry          varchar(4)    NOT NULL DEFAULT CHAR(0),
    thCreditCardAuthorisationNo varchar(20)   NOT NULL DEFAULT CHAR(0),
    thCreditCardReferenceNo     varchar(70)   NOT NULL DEFAULT CHAR(0),
    thCustomData1               varchar(30)   NOT NULL DEFAULT CHAR(0),
    thDeliveryCountry           varchar(2)    NOT NULL DEFAULT CHAR(0),
    thPPDPercentage             float         NOT NULL DEFAULT 0.0,
    thPPDDays                   int           NOT NULL DEFAULT 0,
    thPPDGoodsValue             float         NOT NULL DEFAULT 0.0,
    thPPDVATValue               float         NOT NULL DEFAULT 0.0,
    thPPDTaken                  int           NOT NULL DEFAULT 0,
    thPPDCreditNote             bit           NOT NULL DEFAULT 0,
    thBatchPayPPDStatus         int           NOT NULL DEFAULT 0
END
GO

-- Now we update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 7
WHERE     SchemaName = 'DOCUMENT_Final.xml' AND Version = 6

SET NOCOUNT OFF

