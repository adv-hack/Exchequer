--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_GetHistoryClearedQty.sql
--// Author		: Nilesh Desai 
--// Date		: 27th Jun 2008
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: This function will return Quatity of Cleared for Current YTD Year and Previous Year 	
--//		  	  (Recursively loops through it for records up to previous year ) 
--// Note		: I take return value as "TABLE", so that i can use this function as OUTER APPLY and will be called 
--//			  one time for each row. And value will be assign to multiple fields at a time.		
--// Execute		: SELECT [ZZZZ01].[ifn_GetHistoryClearedQty] ('P', 117, 'AAA', 107, 8)
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS ( SELECT TOP 1 1  
			 FROM	dbo.sysobjects 
			 WHERE	id = OBJECT_ID(N'[!ActiveSchema!].[ifn_GetHistoryClearedQty]') 
			 AND xtype in (N'FN', N'IF', N'TF')
			)

	DROP FUNCTION [!ActiveSchema!].[ifn_GetHistoryClearedQty]

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

CREATE FUNCTION [!ActiveSchema!].[ifn_GetHistoryClearedQty]
(
	  @iv_stType		CHAR(1)
	, @iv_stFolioNum	INT
	, @iv_LocationCode	VARCHAR(3)
	, @iv_CurrentYear	INT
	, @iv_hiPeriod		INT
)
RETURNS @ov_HistoryClearedQty TABLE
( 
	  hiCleared FLOAT 
)
AS
BEGIN	

	--DECLARE Constants 
	DECLARE	  @c_hiPeriodYTD			INT
			, @c_hiCurrency				INT
			, @c_HistoryLocationFilter	VARCHAR(1)
			, @c_HistoryClassOffSet		INT		

	-- Assigning values to Constants
	SELECT	  @c_hiPeriodYTD			= 255		
			, @c_hiCurrency				= 0
			, @c_HistoryLocationFilter	= 'L'			
			, @c_HistoryClassOffSet		= 159

	-- DECLARE local variables
	DECLARE	  @PreviousYear		INT
			, @Previous_hiYear	INT
	
	-- Assign Values to local variable		
	SELECT	  @PreviousYear = (@iv_CurrentYear - 1)

	-- Fetching Previous Year which should exist records and last Previous year assigning to local variable and will be use to 
	-- get previous year History Cleared quantity
	SELECT		@Previous_hiYear = hiYear 
	FROM		( SELECT	MAX(hiYear) AS hiYear
						  ,	SUM(hiCleared) AS hiCleared
				  FROM		[!ActiveSchema!].HISTORY HST					
				  WHERE		HST.hiExClass		= (ASCII(@iv_stType)+@c_HistoryClassOffSet)
				  AND		HST.hiCodeComputed	= ( CONVERT(VARBINARY(1), @c_HistoryLocationFilter) + 
													CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4),@iv_stFolioNum),1,4))) + 
													CONVERT(VARBINARY(3), @iv_LocationCode) + 
													CONVERT(VARBINARY(16), SPACE(20 - LEN(convert(VARBINARY(1),@c_HistoryLocationFilter) + 
													CONVERT(varbinary(4), REVERSE(SUBSTRING(CONVERT(varbinary(4),@iv_stFolioNum),1,4))) + 
													CONVERT(VARBINARY(3), @iv_LocationCode))))
												   )
				  AND		HST.hiCurrency		= @c_hiCurrency
				  AND 		HST.hiYear			<= @PreviousYear
				  AND		HST.hiPeriod		= @c_hiPeriodYTD		
				  GROUP BY	hiCodeComputed
						  , hiExClass
						  , hiYear
				 ) Data

	-- Getting Cleared History value for Year to date + Previous Year and will be end to get Final balance quantity
	INSERT INTO @ov_HistoryClearedQty
	(
		hiCleared
	)
	SELECT		SUM(hiCleared) 
	FROM		[!ActiveSchema!].HISTORY HST		
	WHERE		HST.hiExClass		= (ASCII(@iv_stType)+@c_HistoryClassOffSet)
	AND			HST.hiCodeComputed	= ( CONVERT(VARBINARY(1), @c_HistoryLocationFilter) + 
										CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4),@iv_stFolioNum),1,4))) + 
										CONVERT(VARBINARY(3), @iv_LocationCode) + 
										CONVERT(VARBINARY(16), SPACE(20 - LEN(convert(VARBINARY(1),@c_HistoryLocationFilter) + 
										CONVERT(varbinary(4), REVERSE(SUBSTRING(CONVERT(varbinary(4),@iv_stFolioNum),1,4))) + 
										CONVERT(VARBINARY(3), @iv_LocationCode))))
									   )			  
	AND			HST.hiCurrency		= @c_hiCurrency
	AND			((HST.hiYear		= @iv_CurrentYear AND HST.hiPeriod <= @iv_hiPeriod) 
	OR			(HST.hiYear			= @Previous_hiYear AND HST.hiPeriod = @c_hiPeriodYTD))		

	RETURN	
END