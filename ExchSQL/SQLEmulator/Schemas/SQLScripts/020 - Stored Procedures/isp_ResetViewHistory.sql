--/////////////////////////////////////////////////////////////////////////////
--// Filename    : isp_ResetViewHistory.sql
--// Author    : Nilesh Desai
--// Date    : 8 July 2008
--// Copyright Notice  : (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description  : SQL Script to add isp_ResetViewHistory stored procedure.
--//                  This SP will runs through the Nom View Lines and reset 
--//                  the History records for each one.  It can be run in two 
--//                  modes, firstly it can be run against a specific GL View 
--//                  and secondly it will run against all GL Views
--// Usage : EXEC @ReturnValue = [common].[isp_ResetViewHistory] 'ZZZZ01',1
--//         EXEC [common].[isp_ResetViewHistory] 'ZZZZ01',1
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1  : File Creation
--//  2  : Modifed for 5 Revised Budgets - 5th May 2016
--//
--/////////////////////////////////////////////////////////////////////////////

IF EXISTS ( SELECT  TOP 1 1 FROM dbo.sysobjects WHERE  id = OBJECT_ID(N'[common].[isp_ResetViewHistory]') 
                                                AND    OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [common].[isp_ResetViewHistory]
GO

CREATE PROCEDURE [common].[isp_ResetViewHistory] 
               ( @iv_CompanyCode      VARCHAR(6)  
               , @iv_NomViewNo      INT = NULL
               )
AS
BEGIN
  DECLARE @CRLF             NVARCHAR(5)  
        , @ReturnCode       INT
        , @UpdateScript     VARCHAR(MAX)
        , @SelectScript     VARCHAR(MAX)  
        , @c_RecPfix        CHAR(1)
        , @c_SubType        CHAR(1)
        , @PrefixForHexaDec VARCHAR(2)

  -- Declare CONSTANTS
  SELECT @ReturnCode       = 0  
       , @CRLF             = CHAR(13) + CHAR(10)
       , @c_RecPfix        = 'N'
       , @c_SubType        = 'V'  
       , @PrefixForHexaDec = '0x'

  -- Building update query for table HISTORY [clearing out values]
  SELECT @UpdateScript = ''
      + @CRLF + ' UPDATE    HST '
      + @CRLF + ' SET      hiSales = 0 '      
      + @CRLF + '        , hiPurchases = 0 '
      + @CRLF + '        , hiCleared = 0 '
      + @CRLF + '        , hiValue1 = 0 '
      + @CRLF + '        , hiValue2 = 0 '
      + @CRLF + '        , hiValue3 = 0 '
      + @CRLF + '        , hiBudget         = CASE WHEN IncBudget = 1 THEN 0 ELSE hiBudget  END '
      + @CRLF + '        , hiRevisedBudget1 = CASE WHEN IncBudget = 1 THEN 0 ELSE hiRevisedBudget1 END '
      + @CRLF + '        , hiRevisedBudget2 = CASE WHEN IncBudget = 1 THEN 0 ELSE hiRevisedBudget2 END '
      + @CRLF + '        , hiRevisedBudget3 = CASE WHEN IncBudget = 1 THEN 0 ELSE hiRevisedBudget3 END '
      + @CRLF + '        , hiRevisedBudget4 = CASE WHEN IncBudget = 1 THEN 0 ELSE hiRevisedBudget4 END '
      + @CRLF + '        , hiRevisedBudget5 = CASE WHEN IncBudget = 1 THEN 0 ELSE hiRevisedBudget5 END '
      + @CRLF + ' FROM    ' + LTRIM(RTRIM(@iv_CompanyCode)) + '.HISTORY HST '   
      + @CRLF + ' JOIN    ' + LTRIM(RTRIM(@iv_CompanyCode)) + '.NOMVIEW  NV   ON ASCII(NV.ViewType)= HST.hiExClass '
      + @CRLF + '                       AND NV.NomViewNo    = Cast(Cast(Cast(Reverse(SubString(HST.hiCode, 4, 4)) As Char(4)) As Binary(4)) As int) '
      + @CRLF + '                       AND NV.ABSViewIdx    = [common].[GetCompLineNo](''' + @PrefixForHexaDec + '''' + '+CONVERT(VARCHAR(4),SUBSTRING(HST.hiCode, 8, 4)),16)'
      + @CRLF + '                        AND NV.RecPfix    = ''' + @c_RecPfix + ''''
      + @CRLF + '                        AND NV.SubType    = ''' + @c_SubType + ''''

  IF @iv_NomViewNo IS NULL OR @iv_NomViewNo = 0 
  BEGIN  

    DECLARE @NomViewNo     INT
          , @ListNomViewNo VARCHAR(MAX)

    SELECT @SelectScript = ''
      + @CRLF + ' DECLARE  cur_DistinctNomViewNo CURSOR STATIC FOR '
      + @CRLF + ' SELECT  DISTINCT NomViewNo '      
      + @CRLF + '  FROM ' + LTRIM(RTRIM(@iv_CompanyCode)) + '.NomView '
      + @CRLF + '  WHERE  RecPfix = ''' + @c_RecPfix + ''''
      + @CRLF + '  AND    SubType  = ''' + @c_SubType + ''''
      + @CRLF + '  AND    NomViewNo IS NOT NULL '

    EXEC ( @SelectScript )
      
    OPEN cur_DistinctNomViewNo  
    
    FETCH NEXT FROM cur_DistinctNomViewNo INTO   @NomViewNo  
        
    SELECT @ListNomViewNo = ''
    WHILE @@fetch_status = 0
    BEGIN
      SELECT  @ListNomViewNo = @ListNomViewNo + CONVERT(VARCHAR(MAX), @NomViewNo) + ','
      FETCH NEXT FROM cur_DistinctNomViewNo INTO   @NomViewNo  
    END

    SELECT  @ListNomViewNo = SUBSTRING(@ListNomViewNo,1, LEN(@ListNomViewNo)-1)

     SELECT   @UpdateScript = @UpdateScript + ''
    + @CRLF + ' WHERE    Cast(Cast(Cast(Reverse(SubString(HST.hiCode, 4, 4)) As Char(4)) As Binary(4)) As int) IN ' + '(' +  @ListNomViewNo + ')'
  END
  ELSE
  BEGIN
    SELECT   @UpdateScript = @UpdateScript + '' 
      + @CRLF + ' WHERE    Cast(Cast(Cast(Reverse(SubString(HST.hiCode, 4, 4)) As Char(4)) As Binary(4)) As int) = ' + CONVERT(VARCHAR(MAX),@iv_NomViewNo)
  END

  BEGIN TRY
    EXEC ( @UpdateScript )
  END TRY
  BEGIN CATCH
         -- Execute error logging routine
      EXEC common.isp_RaiseError   @iv_IRISExchequerErrorMessage = 'Procedure [common].[isp_ResetViewHistory]'  -- Include optional message...?
    -- SP failed - error raised
    SET @ReturnCode = -1  
    END CATCH

  SET NOCOUNT OFF
  RETURN @ReturnCode
END
GO
