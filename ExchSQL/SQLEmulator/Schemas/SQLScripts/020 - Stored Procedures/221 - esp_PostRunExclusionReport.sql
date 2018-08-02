
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostRunExclusionReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostRunExclusionReport
GO

-- Produces a list of Excluded Transactions for a given Run No

CREATE PROCEDURE !ActiveSchema!.esp_PostRunExclusionReport ( @iv_RunNo INT )
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

  SELECT RunNo
       , OurReference
       , ExclusionReason
       , DateModified
       , ExchequerLogonId

  FROM  !ActiveSchema!.etb_PostingRunExclusion PREX
  WHERE (PREX.RunNo = @iv_RunNo 
     OR @iv_RunNo   = 0)

END
GO
