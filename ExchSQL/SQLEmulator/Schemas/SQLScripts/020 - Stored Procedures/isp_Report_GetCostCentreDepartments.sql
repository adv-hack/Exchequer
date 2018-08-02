--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_Report_GetCostCentreDepartments.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_Report_GetCostCentreDepartments stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//    2   : Corrected issue with CC or Dept combinations, tagged & untagged
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_Report_GetCostCentreDepartments]') AND type in (N'P', N'PC'))
	drop procedure [!ActiveSchema!].[isp_Report_GetCostCentreDepartments]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [!ActiveSchema!].[isp_Report_GetCostCentreDepartments]
	(
	@strCostCentre				varchar(max)	= '',
	@strDepartment				varchar(max)	= '',
	@bitShowTaggedOnly			bit				= 0
	)	
as

declare @CCDeptCombos table 
(CostCentre				varchar(max),
 CostCentreDescription	varchar(max),
 Department				varchar(max),
 DepartmentDescription  varchar(max))

-- Replace any wild card characters with SQL recognised character
if len(ltrim(rtrim(@strCostCentre)))>0
begin	
	set @strCostCentre = replace(replace(replace(replace(@strCostCentre, '%', char(0)+'%'), '_', char(0)+'_'), '*','%'),'?','_')
end

if len(ltrim(rtrim(@strDepartment)))>0
begin	
	set @strDepartment = replace(replace(replace(replace(@strDepartment, '%', char(0)+'%'), '_', char(0)+'_'), '*','%'),'?','_')
end

-- 	If not passed a parameter then supress that field so get distinct values for the field passed in only
-- e.g. if pass in AAA, get 1 record for AAA cost centre, NOT 7 records, all for AAA with distinct departments

-- If tagged set true then if either parameter not provided then set it to be all wildcards to explicitly output
--if @bitShowTaggedOnly = 1
--begin
--	if LEN(@strCostCentre) = 0
--		set @strCostCentre = '%%'
		
--	if LEN(@strDepartment) = 0 
--		set @strDepartment = '%%'
--end

-- If pass in nothing for either then get nothing back but that's fine.

if LEN(rtrim(@strCostCentre)) = 0 and LEN(rtrim(@strDepartment)) = 0 and @bitShowTaggedOnly = 1
begin

	INSERT @CCDeptCombos SELECT distinct
	 ex.EXCHQCHKcode1Trans1	 as 'CostCentre',
	 ex.CCDescTrans as 'CostCentreDescription',  
	'' as 'Department',
	'' as 'DepartmentDescription'
FROM 
	[!ActiveSchema!].[EXCHQCHK] ex
where
	ex.RecPfix = 'C' and ex.SubType= 67	

	and ex.CCTag=1 
		
order by 
	CostCentre	

INSERT @CCDeptCombos SELECT DISTINCT 
	'' as 'CostCentre',
	'' as 'CostCentreDescription', 
	ex1.Exchqchkcode1Trans1 as 'Department',
	ex1.CCDescTrans as 'DepartmentDescription'
FROM 
	[!ActiveSchema!].[EXCHQCHK] ex1 
where
	ex1.RecPfix = 'C' and ex1.SubType= 68	

	-- Dept filters	
	and ex1.CCTag=1 
order by 
	Department

end
else if LEN(rtrim(@strCostCentre)) = 0
begin
	INSERT @CCDeptCombos SELECT DISTINCT 
	'' as 'CostCentre',
	'' as 'CostCentreDescription', 
	case @strDepartment 
		when '' then ''
		else ex1.Exchqchkcode1Trans1
	end							as 'Department',
	case @strDepartment 
		when '' then ''
		else ex1.CCDescTrans
	end							as 'DepartmentDescription'
FROM 
	[!ActiveSchema!].[EXCHQCHK] ex1 
where
	ex1.RecPfix = 'C' and ex1.SubType= 68	

	-- Dept filters	
	and ((LEN(@strDepartment)>0 and ex1.EXCHQCHKcode1Trans1 like @strDepartment escape (char(0))) or len(@strDepartment)=0)
	and ((ex1.CCTag=1 and @bitShowTaggedOnly=1) or @bitShowTaggedOnly=0)
order by 
	Department


end
else if LEN(rtrim(@strDepartment)) = 0
begin
	INSERT @CCDeptCombos SELECT distinct
	case @strCostCentre 
		when ''	then ''
		else ex.EXCHQCHKcode1Trans1	
	end							as 'CostCentre',
	case @strCostCentre 
		when '' then ''
		else ex.CCDescTrans
	end							as 'CostCentreDescription',  
	'' as 'Department',
	'' as 'DepartmentDescription'
FROM 
	[!ActiveSchema!].[EXCHQCHK] ex
where
	ex.RecPfix = 'C' and ex.SubType= 67	

	-- CC filters	
	and ((LEN(@strCostCentre)>0 and ex.EXCHQCHKcode1Trans1 like @strCostCentre escape (char(0))) or len(@strCostCentre)=0)
	and ((ex.CCTag=1 and @bitShowTaggedOnly=1) or @bitShowTaggedOnly=0)
		
order by 
	CostCentre
end
else
INSERT @CCDeptCombos SELECT distinct
	case @strCostCentre 
		when ''	then ''
		else ex.EXCHQCHKcode1Trans1	
	end							as 'CostCentre',
	case @strCostCentre 
		when '' then ''
		else ex.CCDescTrans
	end							as 'CostCentreDescription', 
	case @strDepartment 
		when '' then ''
		else ex1.Exchqchkcode1Trans1
	end							as 'Department',
	case @strDepartment 
		when '' then ''
		else ex1.CCDescTrans
	end							as 'DepartmentDescription'
FROM 
	[!ActiveSchema!].[EXCHQCHK] ex
cross join
	[!ActiveSchema!].[EXCHQCHK] ex1 
where
	ex.RecPfix = 'C' and ex.SubType = 67
	and ex1.RecPfix = 'C' and ex1.SubType= 68	

	-- CC filters	
	and ((LEN(@strCostCentre)>0 and ex.EXCHQCHKcode1Trans1 like @strCostCentre escape (char(0))) or len(@strCostCentre)=0)
	and ((ex.CCTag=1 and @bitShowTaggedOnly=1) or @bitShowTaggedOnly=0)
		
	-- Dept filters	
	and ((LEN(@strDepartment)>0 and ex1.EXCHQCHKcode1Trans1 like @strDepartment escape (char(0))) or len(@strDepartment)=0)
	and ((ex1.CCTag=1 and @bitShowTaggedOnly=1) or @bitShowTaggedOnly=0)
order by 
	CostCentre, Department

SELECT * FROM @CCDeptCombos
