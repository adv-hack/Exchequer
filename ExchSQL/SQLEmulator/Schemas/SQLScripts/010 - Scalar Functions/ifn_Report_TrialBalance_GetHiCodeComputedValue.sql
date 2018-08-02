--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_Report_TrialBalance_GetHiCodeComputedValue.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ifn_Report_TrialBalance_GetHiCodeComputedValue function
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[ifn_Report_TrialBalance_GetHiCodeComputedValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	drop function [common].[ifn_Report_TrialBalance_GetHiCodeComputedValue]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [common].[ifn_Report_TrialBalance_GetHiCodeComputedValue]
(
	@intNominalCode		int,
	@strCostCentre		nvarchar(3),
	@strDepartment		nvarchar(3),
	@bitCommitted		bit
)
RETURNS VARBINARY(8000) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [IRIS.ExchequerSQL.ClrExtensions].[IRIS.ExchequerSQL.ClrExtensions.SQLCLRFunctions].[GetHiCodeComputedValue]

GO