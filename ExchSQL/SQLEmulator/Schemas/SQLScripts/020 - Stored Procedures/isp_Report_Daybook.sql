--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_Report_Daybook.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_Report_Daybook stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_Report_Daybook]') AND type in (N'P', N'PC'))
	drop procedure [!ActiveSchema!].[isp_Report_Daybook]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [!ActiveSchema!].[isp_Report_Daybook]
	(
	@intReportMode					int,						-- See comment below
	@intExchYearFrom				int,						-- Exchequer year, e.g. 110
	@intPeriodFrom					int,
	@intExchYearTo					int,						-- Exchequer year, e.g. 110
	@intPeriodTo					int,
	@intCurrency					int				= 0,
	@strCostCentre					varchar(max)	= '',
	@strDepartment					varchar(max)	= '',
	@strAccountCode					varchar(max)	= '',
	@strFilter						varchar(max)	= ''
	)
as

/*
ReportMode
==========
0	Document		No doc type filter
10	Sales			SIN,SCR,SJI,SJC,SRF,SRI
20	Purchase		PIN,PCR,PJI,PJC,PRF,PPI
30	Receipts		SRC, SRF, SRI
40	Payments		PPY, PRF, PPI
50	Sales Order		SOR, SDN
60	Purchase Order	POR, PDN
70	Nominal			NOM
*/

--
-- Select the data
------------------
set nocount off
select 
	d.thOurRef,
	d.thAcCode,
	cs.acCompany,
	d.thYourRef,
	d.thYear,
	d.thPeriod,	
	d.thTransDate,
	d.thDueDate,
	d.thDocType,	
	d.thNetValue,
	d.thTotalVAT,
	d.thTotalLineDiscount,
	d.thRevalueAdj,
	d.thTotalReserved,
	d.thSettleDiscAmount,
	d.thSettleDiscTaken,
	d.thVariance,
	d.PostDiscAm,	
	d.thTotalOrderOS,
	d.thCurrency,
	d.thDailyRate,
	d.thCompanyRate,
	d.thOriginalCompanyRate,
	d.thOriginalDailyRate,
	d.thUseOriginalRates
from 
	[!ActiveSchema!].DOCUMENT d 
left join									-- Left join as Nominal Report has no link to CUSTSUPP
	[!ActiveSchema!].CUSTSUPP cs on d.thAcCode = cs.acCode 
where
	-- Only posted transactions, i.e. Run number greater than zero
	-- except for SOR, POR, SDN, PDN transactions which have a negative run number	
	-- or PQU, SQU which have a zero run (included in ReportMode = 0)
	(		
		(d.thRunNo > 0)
		or
		(d.thRunNo in (-40, -50) and @intReportMode in (50, 60))
		or
		(d.thDocType in (8, 9, 23, 24, 7, 22) and @intReportMode = 0)
	)
	
	-- Report mode dictates which doc types can appear.
	-- Whilst this looks a bit horrid it, perhaps surprisingly, performs better across the range of variables
	-- than creating a temp table and doing an inner join	
	and
	(
		@intReportMode = 0
		or
		(
			charindex(',' + cast(d.thDocType as varchar) + ',', 
			(
			case @intReportMode
				when 10 then ',0,2,3,4,5,6,'				-- SIN(0), SCR(2), SJI(3), SJC(4), SRF(5), SRI(6)
				when 20 then ',15,17,18,19,20,21,'			-- PIN(15),PCR(17),PJI(18),PJC(19),PRF(20),PPI(21)
				when 30 then ',1,5,6,'						-- SRC(1), SRF(5), SRI(6)
				when 40 then ',16,20,21,'					-- PPY(16),PRF(20),PPI(21)
				when 50 then ',8,9,'						-- SOR(8), SDN(9)
				when 60 then ',23,24,'						-- POR(23),PDN(24)
				when 70 then ',30,'							-- NOM(30)
			end
			)) >0
		)
	)	
	
	-- Currency. Return all if zero (consolidated) else specified only
	and
	(
		@intCurrency = 0 
		or 
		(@intCurrency > 0 and d.thCurrency = @intCurrency)
	)
		
	-- Start year
	-- Including year seperately as should reduce the amount of data before 
	-- period processing requiring varchar casting below
	and 
		d.thYear between @intExchYearFrom and @intExchYearTo 
		
	-- Start period. 
	-- Need to cast as concatenated varchar to cater for 
	--				Scenario 1		Scenario 2		Scenario 3	Scenrio 4
	--		From	12/2011			06/2011			01/2011		03/2011
	--		To		01/2012			07/2012			02/2011		01/2013
	-- Performance here not likely to be very good. If very poor then consider computed colummn
	-- for YearPeriod combined	
	and 
	(
		(
			(cast(d.thYear as varchar) + right('0' + cast(d.thPeriod as varchar), 2))
			>= (cast(@intExchYearFrom as varchar) + right('0' + cast(@intPeriodFrom as varchar), 2))
		)
		and
		(
			(cast(d.thYear as varchar) + right('0' + cast(d.thPeriod as varchar), 2))
			<= (cast(@intExchYearTo as varchar) + right('0' + cast(@intPeriodTo as varchar), 2))
		)
	)
	
	-- Cost centre (if specified)
	and
	(
		@strCostCentre = ''
		or
		(@strCostCentre <> '' and cs.acCostCentre = @strCostCentre)
	)
		
	-- Department (if specified)
	and
	(
		@strDepartment = ''
		or
		(@strDepartment <> '' and cs.acDepartment = @strDepartment)
	)
		
	-- Account code
	and
	(
		@strAccountCode = ''
		or
		(@strAccountCode <> '' and d.thAcCode = @strAccountCode)
	)
		
	-- Document filter
	and
	(
		@strFilter = ''
		or
		(@strFilter <> '' and d.thOurRef like @strFilter + '%')
	)
order by
	d.thOurRef 

go

