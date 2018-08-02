--/////////////////////////////////////////////////////////////////////////////
--// Filename		: trgCurrencyUpdate.sql
--// Author		: Simon Molloy / Chris Sandow
--// Date		: 30 August 2011
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add trigger for the 6.8 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	30 August 2011:	File Creation - Simon Molloy / Chris Sandow
--//	2	27 January 2014:	File Amendment - Glen Jones / Chris Sandow
--//                      Amended to check for changes to actual currency rows
--//
--/////////////////////////////////////////////////////////////////////////////

-- Create trigger
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[trgCurrencyUpdate]'))
drop trigger [!ActiveSchema!].trgCurrencyUpdate
go

create trigger [!ActiveSchema!].trgCurrencyUpdate on [!ActiveSchema!].exchqss
after insert, update, delete
as
begin
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  -- Only do this for Currency related rows
  
  IF EXISTS(SELECT TOP 1 1 FROM inserted WHERE SUBSTRING(CAST([IDCode] AS VARCHAR),2,4) IN ('CUR','CU2','CU3','GCR','GC2','GC3' ))
  BEGIN
    -- Local variables
    declare @strSQL varchar(max)

    -- Empty the table
    set @strSQL ='
          delete from [!ActiveSchema!].CURRENCY           
          '
    exec sp_sqlexec @strSQL

    -- Control variable
    declare @intCounter int
    set @intCounter = 0
    declare @strIntCounter varchar(2)
    declare @strRatesPosition varchar(max)

    while @intCounter <= 30
    begin
        set @strIntCounter = right('0'+cast(@intCounter as varchar(2)),2)       
        set @strSQL='
              insert into [!ActiveSchema!].CURRENCY
                    (
                    CurrencyCode,
                    Description,
                    ScreenSymbol,
                    PrintSymbol,
                    CompanyRate,
                    DailyRate
              )
              SELECT
                    ' + @strIntCounter + ',
                    MainCurrency' + @strIntCounter + 'Desc,
                    MainCurrency' + @strIntCounter + 'ScreenSymbol, 
                    MainCurrency' + @strIntCounter + 'PrintSymbol, 
                    common.ifn_ExchRnd(MainCurrency' + @strIntCounter + 'CompanyRate, 6),
                    common.ifn_ExchRnd(MainCurrency' + @strIntCounter + 'DailyRate, 6)
              FROM
                    [!ActiveSchema!].[EXCHQSS] 
              WHERE SUBSTRING(CAST([IDCode] AS VARCHAR),2,4) = ''CUR''
  
              union all

              SELECT
                    ' + CAST((31 + @intCounter) as varchar) + ',
                    ExtCurrency' + @strIntCounter + 'Desc,
                    ExtCurrency' + @strIntCounter + 'ScreenSymbol, 
                    ExtCurrency' + @strIntCounter + 'PrintSymbol, 
                    common.ifn_ExchRnd(ExtCurrency' + @strIntCounter + 'CompanyRate, 6),
                    common.ifn_ExchRnd(ExtCurrency' + @strIntCounter + 'DailyRate, 6)
              FROM
                    [!ActiveSchema!].[EXCHQSS] 
              WHERE SUBSTRING(CAST([IDCode] AS VARCHAR),2,4) = ''CU2''

                    -- Reproducing bug in Exchequer where last element of CU2 is
                    -- overwritten by 1st element of CU3, i.e. 61st currency is overwritten       
                    and ' + @strIntCounter + ' < 30

              union all

              SELECT
                    ' + CAST((61 + @intCounter) as varchar) + ',
                    ExtCurrency' + @strIntCounter + 'Desc,
                    ExtCurrency' + @strIntCounter + 'ScreenSymbol, 
                    ExtCurrency' + @strIntCounter + 'PrintSymbol, 
                    common.ifn_ExchRnd(ExtCurrency' + @strIntCounter + 'CompanyRate, 6),
                    common.ifn_ExchRnd(ExtCurrency' + @strIntCounter + 'DailyRate, 6)
              FROM
                    [!ActiveSchema!].[EXCHQSS] 
              WHERE SUBSTRING(CAST([IDCode] AS VARCHAR),2,4) = ''CU3''
              '           
        exec sp_sqlexec @strSQL


        -- Now update with the tri euro values, if any        
        set @strSQL='
              update [!ActiveSchema!].CURRENCY
              set   
                    TriInverted       =
                          CAST(sys.fn_varbintohexsubstring(0,[GCR_triInvert], ' + cast((@intCounter + 1) as varchar) + ', 1) AS bit),
                    TriRate                 = 
                          common.ifn_ExchRnd(
                                common.ifn_HexFloat2Float(sys.fn_varbintohexsubstring(0, [GCR_triRates], ' + cast(((@intCounter * 8) + 1) as varchar) + ', 8), 1)
                                ,6),
                    TriCurrencyCode   = 
                          common.ifn_HexToInt(sys.fn_varbintohexsubstring(0, [GCR_triEuro], ' + cast((@intCounter + 1) as varchar) + ', 1)),                           
                    IsFloating        =
                          CAST(sys.fn_varbintohexsubstring(0, [GCR_triFloat], ' + cast((@intCounter + 1) as varchar) + ', 1) AS bit)
              from
                    [!ActiveSchema!].[EXCHQSS] 
              WHERE 
                    SUBSTRING(CAST([IDCode] AS VARCHAR),2,4) in (''GCR'',''GC2'',''GC3'')
                    and CurrencyCode = 
                          case SUBSTRING(CAST([IDCode] AS VARCHAR),2,4)
                                when ''GCR'' then ' + @strIntCounter + '
                                when ''GC2'' then ' + cast((@intCounter + 31) as varchar) + '
                                when ''GC3'' then ' + cast((@intCounter + 61) as varchar) + '
                          end ' 

        --print isnull(@strSQL,'It''s null')
        exec sp_sqlexec @strSQL       

        -- Set non-provided rates as null so can isnull in main stored procedure
        set @strSQL='
              update [!ActiveSchema!].Currency
              set 
                    TriRate                 = null,
                    TriCurrencyCode   = null
              where
                    TriCurrencyCode = 0'
        exec sp_sqlexec @strSQL       

        -- All done for this position. Loop around
        set @intCounter = @intCounter + 1
    end
  END
end

GO

-- Force the trigger to fire to populate the table
update [!ActiveSchema!].EXCHQSS 
set MainCurrency00CompanyRate=MainCurrency00CompanyRate 
where MainCurrency00CompanyRate is not null

