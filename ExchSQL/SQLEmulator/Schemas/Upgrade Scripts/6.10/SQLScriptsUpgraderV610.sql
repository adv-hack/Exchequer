--/////////////////////////////////////////////////////////////////////////////
--// Filename		: SQLScriptsUpgraderV610.sql
--// Author			: C Sandow
--// Date				: 20 March 2012
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.10 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	20 March 2012:	File Creation - C Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Check for obsolete scripts, and delete them if found
IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[common].[ifn_HexReverse]') AND
        type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[ifn_HexReverse]
GO

IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[common].[ifn_HexStringToBinary]') AND
        type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[ifn_HexStringToBinary]
GO

IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_Report_GetMatchingDocumentsValue]') AND
        type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_Report_GetMatchingDocumentsValue]
GO

IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[common].[ifn_Report_GetTransactionTotal]') AND
        type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[ifn_Report_GetTransactionTotal]
GO

IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_Report_TrialBalance_GetGLCodeValue]') AND
        type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_Report_TrialBalance_GetGLCodeValue]
GO

IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[common].[ifn_Split]') AND
  type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[ifn_Split]
GO

IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[common].[ifn_Report_AgedDebtors_Consolidated_GetTransactionTotal]') AND
  type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[ifn_Report_AgedDebtors_Consolidated_GetTransactionTotal]
GO

IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_Report_AgedDebtorsConsolidated_Online]') AND
  type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[isp_Report_AgedDebtorsConsolidated_Online]
GO

IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_Report_TrialBalanceFull_Online]') AND
  type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[isp_Report_TrialBalanceFull_Online]
GO

IF EXISTS (
  SELECT * FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_Report_TrialBalanceSimplified_Online]') AND
  type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[isp_Report_TrialBalanceSimplified_Online]
GO

SET NOCOUNT OFF

