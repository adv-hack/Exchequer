

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostRunSummaryReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostRunSummaryReport
GO

-- Usage: EXEC !ActiveSchema!.esp_PostRunSummaryReport 1007


CREATE PROCEDURE !ActiveSchema!.esp_PostRunSummaryReport ( @iv_RunNo INT )
AS
BEGIN

  SET NOCOUNT ON;

  -- Declare Constants

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  SELECT RunNo                       = RS.RunNo
       , PAT.PostAnalysisCategory
       , PostAnalysisType            = RS.PostAnalysisType
       , PAT.PostAnalysisDescription
       , BFwdValue                   = ISNULL(RS.BFwdAmount, 0)
       , RunValue                    = ISNULL(RS.PostAmount, 0)
       , CFwdValue                   = ISNULL(RS.BFwdAmount, 0) + ISNULL(RS.PostAmount, 0)
  FROM !ActiveSchema!.etb_PostingRunSummary RS 
  JOIN common.evw_PostanalysisType PAT ON PAT.PostAnalysisType = RS.PostAnalysisType
  WHERE RS.RunNo = @iv_RunNo

  ORDER BY PAT.PostAnalysisOrder

END
GO

