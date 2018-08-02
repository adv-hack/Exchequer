--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_Report_AgedDebtorsDocuments.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_Report_AgedDebtorsDocuments stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

-- Remove the previous (no longer used) Aged Debtors script
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_Report_AgedDebtorsConsolidated_Online]') AND type in (N'P', N'PC'))
	drop procedure [!ActiveSchema!].[isp_Report_AgedDebtorsConsolidated_Online]
go

-- Remove the current version of this script, ready to re-install it
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_Report_AgedDebtorsDocuments]') AND type in (N'P', N'PC'))
	drop procedure [!ActiveSchema!].[isp_Report_AgedDebtorsDocuments]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [!ActiveSchema!].[isp_Report_AgedDebtorsDocuments]
	(
	@strReportType					varchar(1)		= 'C',	-- S for Suppliers, C for Customers
	@intYear						int,					-- Actual year, e.g. 2011.
	@intPeriod						int,
	@intCurrency					int				= 0,
	@strAccountCode					varchar(max)	= '',
	@intControlAccount				int				= 0,
	@strCostCentre					varchar(max)	= '',
	@strDepartment					varchar(max)	= '',
	@bitBackdateToYearPeriod		bit				= 0,
	@bitIsMultiCurrencySetup		bit				= 1
	)
as

set nocount on
/*
-- Debug code
declare
	@strReportType					varchar(1)		= 'C',	-- S for Suppliers, C for Customers
	@intYear						int,					-- Actual year, e.g. 2011.
	@intPeriod						int,
	@intCurrency					int				= 0,
	@strAccountCode					varchar(max)	= '',
	@intControlAccount				int				= 0,
	@strCostCentre					varchar(max)	= '',
	@strDepartment					varchar(max)	= '',
	@bitBackdateToYearPeriod		bit				= 0,
	@bitIsMultiCurrencySetup		bit				= 1

*/
declare @IsDefaultDebtorCreditorControl BIT

set @IsDefaultDebtorCreditorControl = 0

--
-- Wild card character replacement
----------------------------------
-- Replace any wild card characters with SQL recognised character. Char(0) is literal character for select like below.
if len(ltrim(rtrim(@strCostCentre)))>0
begin
	set @strCostCentre = replace(replace(replace(replace(@strCostCentre, '%', char(0)+'%'), '_', char(0)+'_'), '*','%'),'?','_')
end

if len(ltrim(rtrim(@strDepartment)))>0
begin
	set @strDepartment = replace(replace(replace(replace(@strDepartment, '%', char(0)+'%'), '_', char(0)+'_'), '*','%'),'?','_')
end

--
-- System settings
------------------

-- If passed in a control account, check if one of the system control accounts for this report type
-- If so then set to 0 to include in filter
if @intControlAccount > 0
begin
	if exists
		(
		select
			case @strReportType
				when 'C' then NomCtrlDebtors
				when 'S' then NomCtrlCreditors
			end
		from [!ActiveSchema!].EXCHQSS
		where
			@intControlAccount =
				case @strReportType
					when 'C' then NomCtrlDebtors
					when 'S' then NomCtrlCreditors
				end
		and IDCode=0x03535953			-- Translates to SYS
		)
		begin
			--set @intControlAccount = 0
			set @IsDefaultDebtorCreditorControl = 1
		end
end

-- Determine whether to
-- 1. Use TransDate or DueDate for report date and ageing date
-- 2. Use Company Rate or Daily Rate for currency conversion
-- 3. Has system been purged? Determines how to back date payments if no matches found
declare @bitUseTransDate			bit
declare @bitUseCompanyCurrencyRate	bit
declare @bitIsPurged				bit
select
	@bitUseTransDate =
		case @strReportType
			when 'C' then s.StaUIDate
			when 'S' then s.PurchUIDate
		end,
	@bitUseCompanyCurrencyRate =
		case s.TotalConv
			when 'V' then 0
			else 1
		end,
	@bitIsPurged =
		case
			when s.AuditYr > 10 then 1
			else 0
		end
from
	[!ActiveSchema!].EXCHQSS s
where
	IDCode=0x03535953			-- Translates to SYS

--
-- Temporary table needed to insert posted balance and
-- backdated payment records
-- Note. Need to specify collation as, on my machine at least,
-- tempdb collation is Latin1_General_CI_AS but all Excheuquer
-- Dbs appear to be SQL_Latin1_General_CP1_CI_AS
--------------------------------------------------------------
create table #tblTransactions
	(
	AccountCode					varchar(10)		collate SQL_Latin1_General_CP1_CI_AS,
	Reference					varchar(10)		collate SQL_Latin1_General_CP1_CI_AS,
	YourReference				varchar(20),
	CurrencyId					int,
	TransactionYear				int,
	TransactionPeriod			int,
	DisplayDate					datetime,
	ReceiptDate					datetime,
	RemitNo						varchar(10),
	DocType						int,
	NetValue					float,
	TotalVat					float,
	TotalLineDiscount			float,
	RevalueAdj					float,
	TotalReserved				float,
	SettleDiscAmount			float,
	SettleDiscTaken				bit,
	Variance					float,
	PostDiscAm					float,
	AmountSettled				float,
	CurrSettled					float,
	thCurrency					int,
	thDailyRate					float,
	thCompanyRate				float,
	thUseOriginalRates			int,
	IsPostedBalanceRow			bit,
	IsMatchingDocumentsRow		bit,
	PostedBalance				float,
	HoldStatus					varchar(max),
	DiscountStatus				varchar(1),
	HasUnpostedBalance			bit,
	HasEuroConversions			bit,
	-- MH 06/10/2014: Added new field for Order Payments
	OrderPaymentElement			int
	)
create index idxAccountCode on #tblTransactions(AccountCode)

--
-- Select data
--------------
insert into #tblTransactions
select
	d.thAcCode																		as AccountCode,
	d.thOurRef																		as Reference,
	d.thYourRef																		as YourReference,
	d.thCurrency																	as CurrencyId,
	d.thYear																		as TransactionYear,
	d.thPeriod																		as TransactionPeriod,
	case @bitUseTransDate
		when 1 then convert(datetime,d.thTransDate,103)
		else convert(datetime,d.thDueDate,103)
	end																				as DisplayDate,
	null																			as ReceiptDate,
	d.thRemitNo																		as RemitNo,
	d.thDocType																		as DocType,
	d.thNetValue																	as NetValue,
	d.thTotalVAT																	as TotalVAT,
	d.thTotalLineDiscount															as TotalLineDiscount,
	d.thRevalueAdj																	as RevalueAdj,
	d.thTotalReserved																as TotalReserved,
	d.thSettleDiscAmount															as SettleDiscAmount,
	d.thSettleDiscTaken																as SettleDiscTaken,
	d.thVariance																	as Variance,
	d.PostDiscAm																	as PostDiscAm,
	d.thAmountSettled																as AmountSettled,
	d.thCurrSettled																	as CurrSettled,
	d.thCurrency,
	d.thDailyRate,
	d.thCompanyRate,
	d.thUseOriginalRates,
	0																				as IsPostedBalanceRow,
	0																				as IsMatchingDocumentsRow,
	0																				as PostedBalance,
	case (d.thHoldFlag & 128)
		when 128 then 'Suspend'
		else
			case d.thHoldFlag
				when 32 then 'Notes'		-- Only return 'Notes' if 32 bit set AND no others, hence why not performing bitwise 'and'
				when 1 then 'Query'
				when 2 then 'UntilAlloc'
				when 3 then 'Authorise'
				when 4 then 'Wait Stk'
				when 5 then 'WaitAllStk'
				when 6 then 'Credit Hld'
				when 33 then 'Query'
				when 34 then 'UntilAlloc'
				when 35 then 'Authorise'
				when 36 then 'Wait Stk'
				when 37 then 'WaitAllStk'
				when 38 then 'Credit Hld'
				else ''
			end
	end																				as HoldStatus,
	case
		when abs(d.thSettleDiscTaken) > 0	then 'Y'
		when abs(d.thSettleDiscAmount) > 0	then 'A'
		else ''
	end																				as DiscountStatus,
	case
		when d.thRunNo > 0 then 0
		else 1
	end																				as HasUnpostedBalance,
	case
		when abs(
			case @bitUseCompanyCurrencyRate
				when 1 then d.thOldCompanyRate
				else d.thOldDailyRate
			end) > 0 then 1
		else 0
	end																				as HasEuroConversions,
	-- MH 06/10/2014: Added new field for Order Payments
	d.thOrderPaymentElement                                                                                                                                         as OrderPaymentElement                     
from
	[!ActiveSchema!].DOCUMENT d
inner join [!ActiveSchema!].CUSTSUPP c
	on c.acCode = d.thAcCode
where
	-- Document type is as specified, C for customer, S for supplier
	d.thCustSupp = @strReportType

	-- Specific customer, if provided
	and
		(
			@strAccountCode = ''
		or
			(@strAccountCode <> '' and d.thAcCode = @strAccountCode)
		)

	-- Run number non negative
	and (d.thRunNo >= 0)

	-- Document type not SQU or PQU
	and (d.thDocType not in (7,22))

	-- Document hold not set.
	and
		(
			d.thRunNo > 0
		or
			(not d.thHoldFlag in (1, 33, 129))
		)

	-- Date stuff, if backdating
	and
		(
			(@bitBackdateToYearPeriod = 1 and
				(
					(d.thYear < @intYear - 1900 )
					or
					(d.thYear = @intYear - 1900 and d.thPeriod <= @intPeriod)
				)
			)
			or (@bitBackdateToYearPeriod = 0)
		)

	-- Control codes.
	and
		(
			@intControlAccount = 0
		or
			(@IsDefaultDebtorCreditorControl = 0 AND  d.thControlGL = @intControlAccount)
	    or
	        (@IsDefaultDebtorCreditorControl = 1 AND  d.thControlGL IN (0, @intControlAccount))
		)

	-- Specific currency, if provided
	and
		(
			@intCurrency = 0
		or
			(d.thCurrency = @intCurrency)
		)

	-- Cost centre match. TODO Check if quicker to shift to a pre check, as may greatly reduce processing time
	and
		(
			(@strCostCentre = '')
		or
			(@strCostCentre <> '' and c.acCostCentre like @strCostCentre escape(char(0)))
		)

	-- Department match. TODO Check if quicker to shift to a pre check, as may greatly reduce processing time
	and
		(
			(@strDepartment = '')
		or
			(@strDepartment <> '' and c.acDepartment like @strDepartment escape(char(0)))
		)

	-- Exclude auto transactions
	and d.thNomAuto = 1


--
-- Posted Balance Rows
---------------------------------------------------

-- Insert posted balance rows. One for each account.
-- Piggybacking the HasEuroConversions row in here as well for use in summary report
insert into #tblTransactions
	(
	AccountCode,
	PostedBalance,
	IsPostedBalanceRow
	)
select
	AccountCode,
	common.ifn_ExchRnd(isnull([!ActiveSchema!].ifn_Report_GetPostedBalance
		(
			AccountCode,
			@intYear,
			@intPeriod,
			@intCurrency
		),0),2),
	1
from
	#tblTransactions
group by
	AccountCode

--
-- Backdating
-------------
-- If backdating then return details from FinancialMatching table
if @bitBackdateToYearPeriod = 1
begin
	insert into #tblTransactions
		(
		AccountCode,
		Reference,
		DisplayDate,
		ReceiptDate,
		DocType,
		CurrencyId,
		AmountSettled,
		CurrSettled,
		thCurrency,
		thCompanyRate,
		thDailyRate,
		thUseOriginalRates,
		IsPostedBalanceRow,
		IsMatchingDocumentsRow
		)
	select
		t.AccountCode,
		t.Reference,
		t.DisplayDate,
		case d1.thOurRef
			when null then null
			else
				case @bitUseTransDate
					when 1 then convert(datetime,d1.thTransDate,103)
					else convert(datetime,d1.thDueDate,103)
				end
		end as ReceiptDate,
		d1.thDocType,
		f.MCurrency,
		-- CJS 05/07/2013 - removed previous change
		f.SettledVal,
		f.OwnCVal,
		d1.thCurrency,
		d1.thCompanyRate,
		d1.thDailyRate,
		d1.thUseOriginalRates,
		0,
		1
	from
		[!ActiveSchema!].[FinancialMatching] f
	inner join #tblTransactions t
		on f.DocRef = t.Reference
	left join [!ActiveSchema!].[DOCUMENT] d1
		on f.PayRef = d1.thOurRef
	where
		f.MatchType = 'A'
		and
		(
			-- No matching doc found. Assume purged and include in matching docs
			d1.thOurRef is null
			or
			(
				(d1.thYear < @intYear - 1900 )
				or
				(d1.thYear = @intYear - 1900 and d1.thPeriod <= @intPeriod)
			)
		)

	union all

	select
		t.AccountCode,
		t.Reference,
		t.DisplayDate,
		case d2.thOurRef
			when null then null
			else
				case @bitUseTransDate
					when 1 then convert(datetime,d2.thTransDate,103)
					else convert(datetime,d2.thDueDate,103)
				end
		end as ReceiptDate,
		d2.thDocType,
		f.MCurrency,
		f.SettledVal,
		f.OwnCVal,
		d2.thCurrency,
		d2.thCompanyRate,
		d2.thDailyRate,
		d2.thUseOriginalRates,
		0,
		1
	from
		[!ActiveSchema!].[FinancialMatching] f
	inner join #tblTransactions t
		on f.PayRef = t.Reference
	left join [!ActiveSchema!].[DOCUMENT] d2
		on f.DocRef = d2.thOurRef
	where
		f.MatchType = 'A'
		and
		(
			-- No matching doc found. Assume purged and include in matching docs
			d2.thOurRef is null
			or
			(
				(d2.thYear < @intYear - 1900 )
				or
				(d2.thYear = @intYear - 1900 and d2.thPeriod <= @intPeriod)
			)
		)

end


-- Debug code
--select * from #tblTransactions

--
-- Return the data
------------------
set nocount off
select
	t.AccountCode,
	c.acCompany,
	c.acAltCode,
	c.acPhone,
	t.Reference,
	t.YourReference,
	t.CurrencyId,
	t.TransactionYear,
	t.TransactionPeriod,
	case IsMatchingDocumentsRow
		when 1 then null
		else t.DisplayDate
	end as DisplayDate,
	case IsMatchingDocumentsRow
		when 1 then t.ReceiptDate
		else null
	end as ReceiptDate,
	t.RemitNo,
	t.DocType,
	t.NetValue,
	t.TotalVat,
	t.TotalLineDiscount,
	t.RevalueAdj,
	t.TotalReserved,
	t.SettleDiscAmount,
	t.SettleDiscTaken,
	t.Variance,
	t.PostDiscAm,
	t.AmountSettled,
	t.CurrSettled,
	t.thCurrency,
	t.thDailyRate,
	t.thCompanyRate,
	t.thUseOriginalRates,
	t.IsPostedBalanceRow,
	t.IsMatchingDocumentsRow,
	t.PostedBalance,
	t.HoldStatus,
	t.DiscountStatus,
	t.HasUnpostedBalance,
	t.HasEuroConversions,
	-- MH 06/10/2014: Added new field for Order Payments
	t.OrderPaymentElement	
from
	#tblTransactions t
inner join [!ActiveSchema!].CUSTSUPP c
	on t.AccountCode = c.acCode
order by
	t.AccountCode, t.IsPostedBalanceRow, t.DisplayDate, t.Reference, t.IsMatchingDocumentsRow


-- All done. Tidy up
---------------------
drop table #tblTransactions


go

