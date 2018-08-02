
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[efn_CalculateVATPeriod]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[efn_CalculateVATPeriod]
GO



CREATE FUNCTION [!ActiveSchema!].efn_CalculateVATPeriod (@iv_TransactionDate VARCHAR(8) )
RETURNS VARCHAR(8)
AS
BEGIN

  DECLARE @VATCurrentPeriod VARCHAR(8)
        , @VATInterval      INT
        , @DiffMonths       INT        = 0
        , @NewInterval      INT

  SELECT @VATCurrentPeriod = VATCurrentPeriod
       , @VATInterval      = VATInterval
  FROM [!ActiveSchema!].evw_VATSystemSettings 

  IF @iv_TransactionDate > @VATCurrentPeriod
  BEGIN

    SET @DiffMonths  = DATEDIFF(mm, CONVERT(DATE, @VATCurrentPeriod), CONVERT(DATE, @iv_TransactionDate))
    SET @NewInterval = @DiffMonths + CASE
                                     WHEN (@DiffMonths % @VATInterval) <= 0 THEN 0
                                     ELSE (@VATInterval - (@DiffMonths % @VATInterval))
                                     END
    SET @VATCurrentPeriod = CONVERT(VARCHAR(8), DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,DATEADD(MM, @NewInterval, CONVERT(DATE, @VATCurrentPeriod)))+1,0)), 112)

  END

  RETURN @VATCurrentPeriod
END
GO

