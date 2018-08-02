--/////////////////////////////////////////////////////////////////////////////
--// Filename   : CreateSystemSetup.sql
--// Author     : Chris Sandow
--// Date       : 6 May 2015
--// Copyright Notice : (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description    : SQL Script to create table for the 7.0.14 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 6th May 2015:  File Creation - Chris Sandow
--//  2 16th September 2015: Added version row - Chris Sandow
--//  3 25/05/2017 2017-R1:ABSEXCH-18573 - Added 'ssCurrImportTol' row for
--//    Currency Tolerance Editable field under system set-up.- Sanjay Sonani
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check that table does not already exist.
DECLARE @SetupExists INT
SELECT  @SetupExists = 1 

IF NOT EXISTS (
            SELECT  *
            FROM    sysobjects tab
            WHERE   (tab.id = object_id('[!ActiveSchema!].SystemSetup'))
          )
BEGIN
  SELECT @SetupExists = 0
END

IF @SetupExists = 0
BEGIN
  CREATE TABLE [!ActiveSchema!].[SystemSetup](
    [sysId] [int] NOT NULL,
    [sysName] [varchar](30) NOT NULL,
    [sysDescription] [varchar](255) NOT NULL,
    [sysValue] [varchar](255) NOT NULL,
    [sysType] [varchar](30) NOT NULL,
    PositionId int IDENTITY(1,1) NOT NULL
  ) ON [PRIMARY]
  
  -- Create main Emulator index
  CREATE UNIQUE INDEX SystemSetup_Index_Identity ON [!ActiveSchema!].SystemSetup(PositionId)
  CREATE UNIQUE INDEX SystemSetup_Index0 ON [!ActiveSchema!].SystemSetup([sysId], [PositionId])
  
END

IF @SetupExists = 0
BEGIN
  SET IDENTITY_INSERT [!ActiveSchema!].[SYSTEMSETUP] ON 
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (0, N'DataVersionNo', N'Data Version Number', N'0', N'varchar(20)', 0)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (1, N'ssSettlementWriteOffCtrlGL', N'Settlement Write-Off GL Control Code', N'0', N'int', 1)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (2, N'PPDRedDays', N'PPD Expiry - Upper Limit of days for ''Red'' category', N'5', N'int', 2)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (3, N'PPDAmberDays', N'PPD Expiry - Upper Limit of days for ''Amber'' category', N'15', N'int', 3)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (4, N'PPDExpiredBackgroundColour', N'PPD Expiry - Expired Background Colour', N'12632256', N'int', 4)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (5, N'PPDExpiredFontColour', N'PPD Expiry - Expired Font Colour', N'0', N'int', 5)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (6, N'PPDExpiredFontStyle', N'PPD Expiry - Expired Font Style (1=Bold / 2=Underline / 4=Italic / 8=Strikeout)', N'4', N'int', 6)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (7, N'PPDRedBackgroundColour', N'PPD Expiry - ''Red'' Background Colour', N'255', N'int', 7)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (8, N'PPDRedFontColour', N'PPD Expiry - ''Red'' Font Colour', N'16777215', N'int', 8)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (9, N'PPDRedFontStyle', N'PPD Expiry - ''Red'' Font Style (1=Bold / 2=Underline / 4=Italic / 8=Strikeout)', N'1', N'int', 9)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (10, N'PPDAmberBackgroundColour', N'PPD Expiry - ''Amber'' Background Colour', N'8454143', N'int', 10)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (11, N'PPDAmberFontColour', N'PPD Expiry - ''Amber'' Font Colour', N'0', N'int', 11)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (12, N'PPDAmberFontStyle', N'PPD Expiry - ''Amber'' Font Style (1=Bold / 2=Underline / 4=Italic / 8=Strikeout)', N'0', N'int', 12)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (13, N'PPDGreenBackgroundColour', N'PPD Expiry - ''Green'' Background Colour', N'8454016', N'int', 13)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (14, N'PPDGreenFontColour', N'PPD Expiry - ''Green'' Font Colour', N'0', N'int', 14)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (15, N'PPDGreenFontStyle', N'PPD Expiry - ''Green'' Font Style (1=Bold / 2=Underline / 4=Italic / 8=Strikeout)', N'0', N'int', 15)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (16, N'isShowDeliveryTerms', N'Show Delivery Terms', N'1', N'int', 16)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (17, N'isShowModeOfTransport', N'Show Mode of Transport',  N'1', N'int', 17)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (18, N'isLastClosedArrivalsDate', N'Last Closed Intrastat Arrivals Date', N'', N'varchar(8)', 18)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (19, N'isLastClosedDispatchesDate', N'Last Closed Intrastat Dispatches Date', N'', N'varchar(8)', 19)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (20, N'isLastReportPeriodYear', N'Last Intrastat Report Period Year', N'', N'varchar(4)', 20)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (21, N'isLastReportFromDate', N'Last Intrastat Report From Date', N'', N'varchar(8)', 21)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (22, N'isLastReportToDate', N'Last Intrastat Report To Date', N'', N'varchar(8)', 22)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (23, N'isLastReportMode', N'Last Intrastat Report Mode',  N'0', N'int', 23)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (24, N'isTaxHomeRegion', N'Tax - Home Region ID',  N'0', N'int', 24)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (25, N'ssCurrImportTol', N'Currency Import Tolerance',  N'0', N'float', 25)
  --< TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)--> 
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (26, N'AuthenticationMode', N'Authentication Mode',  N'Exchequer', N'Varchar(20)', 26)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (27, N'MinimumPasswordLength', N'Minimum Password Length',  N'0', N'int', 27)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (28, N'RequireUppercase', N'Require Uppercase',  N'0', N'Bit', 28)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (29, N'RequireLowercase', N'Require Lowercase',  N'0', N'Bit', 29)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (30, N'RequireNumeric', N'Require Numeric',  N'0', N'Bit', 30)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (31, N'RequireSymbol', N'Require Symbol',  N'0', N'Bit', 31)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (32, N'SuspendUsersAfterLoginFailures', N'Suspend Users After Login Failures',  N'0', N'Bit', 32)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (33, N'SuspendUsersLoginFailureCount', N'Suspend Users Login Failure Count',  N'3', N'int', 33)
  --< HV 13-11-2017 2018 R1: ABSEXCH-19344: GDPR - New SystemSetup Rows - Database Changes >  
  --<A3.2.1 Company Anonymisation Flag >
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (34, N'Anonymised', N'Data has been Anonymised',  N'0', N'Bit', 34)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (35, N'AnonymisedDate', N'Anonymisation Date (YYYYMMDD)',  N'', N'Varchar(8)', 35)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (36, N'AnonymisedTime', N'Anonymisation Time (HHMMSS)',  N'', N'Varchar(6)', 36)
  --<A3.2.2 GDPR Configuration > -- A3.2.2.1 Trader Settings
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (37, N'GDPRTraderRetentionPeriod', N'GDPR - Trader - Retention Period (Years)',  N'6', N'int', 37)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (38, N'GDPRTraderDisplayPIITree', N'GDPR - Trader - Display PII Tree on Close',  N'0', N'Bit', 38)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (39, N'GDPRTraderAnonNotesOption', N'GDPR – Trader – Anonymisation - Notes Option',  N'2', N'int', 39)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (40, N'GDPRTraderAnonLettersOption', N'GDPR – Trader – Anonymisation - Letters Option',  N'3', N'int', 40)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (41, N'GDPRTraderAnonLinksOption', N'GDPR – Trader – Anonymisation - Links Option',  N'2', N'int', 41)
  -- A3.2.2.2 Employee Settings
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (42, N'GDPREmployeeRetentionPeriod', N'GDPR - Employee - Retention Period (Years)',  N'6', N'int', 42)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (43, N'GDPREmployeeDisplayPIITree', N'GDPR - Employee - Display PII Tree on Close',  N'0', N'Bit', 43)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (44, N'GDPREmployeeAnonNotesOption', N'GDPR – Employee – Anonymisation - Notes Option',  N'2', N'int', 44)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (45, N'GDPREmployeeAnonLettersOption', N'GDPR – Employee – Anonymisation - Letters Option',  N'3', N'int', 45)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (46, N'GDPREmployeeAnonLinksOption', N'GDPR – Employee – Anonymisation - Links Option',  N'2', N'int', 46)
  -- A3.2.2.3 Notification Settings
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (47, N'NotificationWarningColour', N'Warning Notification Colour',  N'43506', N'int', 47)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (48, N'NotificationWarningFontColour', N'Warning Notification Font Colour',  N'16777215', N'int', 48)
  --A3.2.2.4 Company Anonymisation
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (49, N'GDPRCompanyAnonLocations', N'GDPR – Company - Locations contain PII Data',  N'0', N'Bit', 49)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (50, N'GDPRCompanyAnonCostCentres', N'GDPR – Company - Cost Centres contain PII Data',  N'0', N'Bit', 50)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (51, N'GDPRCompanyAnonDepartment', N'GDPR – Company - Departments contain PII Data',  N'0', N'Bit', 51)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (52, N'GDPRCompanyNotesOption', N'GDPR – Company - Anonymisation - Notes Option',  N'2', N'int', 52)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (53, N'GDPRCompanyLettersOption', N'GDPR – Company - Anonymisation - Letters Option',  N'3', N'int', 53)
  INSERT [!ActiveSchema!].[SYSTEMSETUP] ([sysId], [sysName], [sysDescription], [sysValue], [sysType], [PositionId]) VALUES (54, N'GDPRCompanyLinksOption', N'GDPR – Company - Anonymisation - Links Option',  N'2', N'int', 54)
  
  
  SET IDENTITY_INSERT [!ActiveSchema!].[SYSTEMSETUP] OFF
END;

SET NOCOUNT OFF
