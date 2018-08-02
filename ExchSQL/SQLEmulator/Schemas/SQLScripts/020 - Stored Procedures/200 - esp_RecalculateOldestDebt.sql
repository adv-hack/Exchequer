/****** Object:  StoredProcedure [!ActiveSchema!].[esp_ReCalculateOldestDebt]    Script Date: 20/05/2016 10:16:12 ******/
/******  HV 20/05/2016 2016-R2 ABSEXCH-17430: Recalculate Trader Oldest Debt Only ******/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateOldestDebt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateOldestDebt]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--

-- Recalculate Trader Oldest Debt

--

-- To reset an Individual Trader pass in the Trader Code otherwise resets all Traders that require resetting. 

CREATE PROCEDURE [!ActiveSchema!].[esp_RecalculateOldestDebt] ( @iv_TraderCode VARCHAR(10) = NULL)

AS

BEGIN 

  DECLARE @ss_AgeingMode                   INT 

  SELECT @ss_AgeingMode = AgeingMode

  FROM !ActiveSchema!.evw_SystemSettings 

  IF OBJECT_ID('tempdb..#Traders') IS NOT NULL

  DROP TABLE #Traders 

  CREATE TABLE #Traders ( TraderCode       VARCHAR(10)

                        , ParentTraderCode VARCHAR(10) 

                        , IsHeadOffice     BIT

                        )     

  IF ISNULL(@iv_TraderCode, '') <> ''

  BEGIN 

    DECLARE @TraderCode VARCHAR(10) 

    SELECT @TraderCode = PCS.acCode

    FROM   !ActiveSchema!.CUSTSUPP CCS

    JOIN   !ActiveSchema!.CUSTSUPP PCS ON CCS.acInvoiceTo  = PCS.acCode

                              AND PCS.acOfficeType = 1

    WHERE  CCS.acCode = @iv_TraderCode 

    IF ISNULL(@TraderCode, '') = '' SET @TraderCode = @iv_TraderCode    

    -- Insert Trader Code

    INSERT INTO #Traders

    SELECT TraderCode       = CCS.acCode

         , ParentTraderCode = ''

         , IsHeadOffice     = CASE

                              WHEN acOfficeType = 1 THEN 1

                              ELSE 0

                              END

 

    FROM   !ActiveSchema!.CUSTSUPP CCS

    WHERE  CCS.acCode = @TraderCode 

    -- Insert Any Children

    INSERT INTO #Traders

    SELECT TraderCode       = acCode

         , ParentTraderCode = T.TraderCode

         , IsHeadOffice     = 0

    FROM   !ActiveSchema!.CUSTSUPP CS

    JOIN   #Traders T ON CS.acInvoiceTo = T.TraderCode COLLATE Latin1_General_CI_AS 

  END

  ELSE

  BEGIN

    -- Insert ALL Traders 

    INSERT INTO #Traders

    SELECT TraderCode       = CCS.acCode

         , ParentTraderCode = CASE

                              WHEN PCS.acCode IS NOT NULL THEN PCS.acCode

                              ELSE ''

                              END

         , IsHeadOffice     = CASE

                              WHEN PCS.acCode IS NOT NULL THEN 1

                              ELSE 0

                              END

 

    FROM   !ActiveSchema!.CUSTSUPP CCS

    LEFT JOIN !ActiveSchema!.CUSTSUPP PCS ON CCS.acInvoiceTo  = PCS.acCode

                                 AND PCS.acOfficeType = 1 

  END 

  UPDATE T

     SET acCreditStatus = ISNULL(CASE

                          WHEN @ss_AgeingMode IN (1, 3, 5) THEN CASE WHEN OldestDebtDays > 32767
																		THEN 32767
																	 ELSE OldestDebtDays
															    END

                          ELSE CASE WHEN OldestDebtWeeks > 32767
										THEN 32767
									ELSE OldestDebtWeeks
							   END

                          END,0)

  FROM   !ActiveSchema!.CUSTSUPP T

  RIGHT OUTER JOIN   #Traders TR ON TR.TraderCode = T.acCode COLLATE Latin1_General_CI_AS

  FULL OUTER JOIN (SELECT TH.TraderCode

             , OldestDueDate = MIN(TH.DueDate)

        FROM  !ActiveSchema!.evw_TransactionHeader TH

        JOIN   #Traders T ON TH.TraderCode = T.TraderCode COLLATE Latin1_General_CI_AS

        WHERE TH.TransactionTypeCode IN ('SIN','SJI','SBT','PIN','PJI','PPI','PBT') 

        AND   TH.DueDate <> ''

        AND   TH.DueDate <  CONVERT(DATE, GETDATE())

        AND   TH.TotalOutstandingAmount <> 0

        GROUP BY TH.TraderCode) TH ON T.acCode = TH.TraderCode

  CROSS APPLY ( SELECT MIN(OldestDebtDays)

                     , MIN(OldestDebtWeeks)

                FROM ( SELECT OldestDebtDays  = DATEDIFF(DAY, CONVERT(DATE, OldestDueDate), GETDATE())

                            , OldestDebtWeeks = DATEDIFF(WEEK, CONVERT(DATE, OldestDueDate), GETDATE())

					   ) OData

              ) OldDebt ( OldestDebtDays

                        , OldestDebtWeeks)     

END


 

