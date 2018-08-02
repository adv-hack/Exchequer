IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[efn_Period]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[efn_Period]
GO

CREATE FUNCTION !ActiveSchema!.efn_Period ()
RETURNS @etb_Period TABLE
      ( PeriodKey               INT
      , PeriodDescription       VARCHAR(100)
      , PeriodYear              INT
      , PeriodYearDescription   VARCHAR(10)
      , ExchequerYear           INT
      , PeriodNo                INT
      , CalendarDesciption      VARCHAR(100) NULL
      , CalendarFullDescription VARCHAR(100) NULL
      , CalendarMonthShortName  VARCHAR(10)  NULL
      , CalendarMonthLongName   VARCHAR(20)  NULL
      , QuarterCode             VARCHAR(2)   NULL
      , QuarterNo               INT          NULL
      , QuarterDescription      VARCHAR(20)  NULL
      , IsCurrentPeriod         BIT          NULL
      , IsCurrentYear           BIT          NULL
      , HasTransactions         BIT          NULL
      UNIQUE CLUSTERED (PeriodKey)
      )
AS
BEGIN
DECLARE @CurrentPeriodKey INT
      , @MinYear          INT
      , @MaxYear          INT
      , @ThisPeriod       INT
      , @ThisYear         INT
      , @NoOfPeriods      INT
      , @PeriodOffset     INT
      , @PeriodDate       DATE

SELECT @CurrentPeriodKey = CurrentPeriodKey
     , @MinYear       = ISNULL(YEAR(SystemStartDate), 1900)
     , @MaxYear       = CurrentYear + 10
     , @NoOfPeriods   = NoOfPeriodsInYear
     , @PeriodOffset  = MONTH(SystemStartDate) - 1

FROM   !ActiveSchema!.evw_SystemSettings


SET @ThisYear = @MinYear
SET @ThisPeriod = 1

WHILE @ThisYear < @MaxYear
BEGIN
  WHILE @ThisPeriod <= @NoOfPeriods
  BEGIN

    SET @PeriodDate = CASE
                      WHEN @NoOfPeriods = 12 AND @ThisPeriod <= 12 
                      THEN CONVERT(DATE, CONVERT(VARCHAR(10), ((@ThisYear * 10000) + (@ThisPeriod * 100) + 1)))
                      ELSE CONVERT(DATE, NULL)
                      END
    
    INSERT INTO @etb_Period
    SELECT PeriodKey               = (@ThisYear * 1000) + @ThisPeriod
         , PeriodDescription       = RIGHT('0' + CONVERT(VARCHAR, @ThisPeriod), 2) + '/' + CONVERT(VARCHAR, @ThisYear)
         , PeriodYear              = @ThisYear
         , PeriodYearDescription   = CONVERT(VARCHAR, @ThisYear)
         , ExchequerYear           = (@ThisYear - 1900)
         , PeriodNo                = @ThisPeriod
         , CalendarDescription     = LEFT(DATENAME(MONTH, DATEADD(MM, @PeriodOffset, @PeriodDate)) , 3)
                                   + ' ' 
                                   + DATENAME(YEAR, DATEADD(MM, @PeriodOffset, @PeriodDate))
         , CalendarFullDescription = DATENAME(MONTH, DATEADD(MM, @PeriodOffset, @PeriodDate))
                                   + ' ' 
                                   + DATENAME(YEAR, DATEADD(MM, @PeriodOffset, @PeriodDate))
         , CalendarMonthShortName  = LEFT(DATENAME(MONTH, DATEADD(MM, @PeriodOffset, @PeriodDate)) , 3)
         , CalendarMonthLongName   = DATENAME(MONTH, DATEADD(MM, @PeriodOffset, @PeriodDate))
         , QuarterCode             = 'Q' + CONVERT(VARCHAR(1), CONVERT(INT, 
	                                 CASE
	                                 WHEN @ThisPeriod < 250 THEN CEILING(CONVERT(NUMERIC(10,2), @ThisPeriod) / (CONVERT(NUMERIC(10,2), @NoOfPeriods) / 4.0))
		                             ELSE CONVERT(NUMERIC(10,2), NULL)
		                             END))
         , QuarterNo               = CASE
	                             WHEN @ThisPeriod < 250 THEN CEILING(CONVERT(NUMERIC(10,2), @ThisPeriod) / (CONVERT(NUMERIC(10,2), @NoOfPeriods) / 4.0))
		                     ELSE CONVERT(NUMERIC(10,2), NULL)
		                     END
         , QuarterDescription      = CASE
	                             WHEN @ThisPeriod >= 250 THEN NULL
	                             WHEN CEILING(CONVERT(NUMERIC(10,2), @ThisPeriod) / (CONVERT(NUMERIC(10,2), @NoOfPeriods) / 4.0)) = 1 THEN '1st Quarter'
				     WHEN CEILING(CONVERT(NUMERIC(10,2), @ThisPeriod) / (CONVERT(NUMERIC(10,2), @NoOfPeriods) / 4.0)) = 2 THEN '2nd Quarter'
				     WHEN CEILING(CONVERT(NUMERIC(10,2), @ThisPeriod) / (CONVERT(NUMERIC(10,2), @NoOfPeriods) / 4.0)) = 3 THEN '3rd Quarter'
				     ELSE '4th Quarter'
				     END
         , IsCurrentPeriod         = CASE
                                     WHEN (@ThisYear * 1000) + @ThisPeriod = @CurrentPeriodKey THEN 1
                                     ELSE 0
                                     END
         , IsCurrentYear           = CASE
                                     WHEN @ThisYear = FLOOR(@CurrentPeriodKey / 1000) THEN 1
                                     ELSE 0
                                     END
         , HasTransactions         = ISNULL( (SELECT TOP 1 1
                                              FROM   !ActiveSchema!.DOCUMENT D
                                              WHERE  D.thYear   = (@ThisYear - 1900)
                                              AND    D.thPeriod = @ThisPeriod
                                             )
                                           , 0)
                                     
     
    SET @ThisPeriod = @ThisPeriod + 1
  END

  SET @ThisYear   = @ThisYear + 1
  SET @ThisPeriod = 1
END

RETURN
END

GO

