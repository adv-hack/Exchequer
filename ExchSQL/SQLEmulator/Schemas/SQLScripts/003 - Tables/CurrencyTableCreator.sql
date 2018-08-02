--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CurrencyTableCreator.sql
--// Author		: Simon Molloy / Chris Sandow
--// Date		: 30 August 2011
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add Currency table for the 6.8 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	30 August 2011:	File Creation - Simon Molloy / Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

-- Create currency table if doesn't already exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[CURRENCY]') AND type in (N'U'))
	create table [!ActiveSchema!].[CURRENCY]
	(
		[CurrencyCode]		int				not null	primary key,
		[Description]		varchar(11),
		[ScreenSymbol]		varchar(3),
		[PrintSymbol]		varchar(3),
		[CompanyRate]		float,
		[DailyRate]			float,				
		[TriInverted]		bit,		
		[TriRate]			float,
		[TriCurrencyCode]	int,
		[IsFloating]		bit
	)	
go

