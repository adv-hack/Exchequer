IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_CreateTraderHistoryCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_CreateTraderHistoryCode]
GO

CREATE FUNCTION [common].[efn_CreateTraderHistoryCode]
              ( @iv_TraderCode   VARCHAR(10)
              , @iv_NominalCode  INT = NULL
              )
RETURNS VARBINARY(21)
AS
BEGIN
  DECLARE @TraderHistoryCode VARBINARY(21)
        , @BinCode           VARCHAR(10)

  SET @BinCode = CONVERT(VARCHAR, CONVERT(VARBINARY(21), @iv_NominalCode), 2)

  IF @iv_NominalCode IS NULL
  BEGIN
    SET @TraderHistoryCode = CONVERT(VARBINARY(21),
                                      0x14 
                                    + CONVERT(VARBINARY(21), CONVERT(CHAR(6), @iv_TraderCode))
                                    + CONVERT(VARBINARY(21), SPACE(14))
                                    )
  END
  ELSE
  BEGIN
    SET @TraderHistoryCode = CONVERT(VARBINARY(21),
                             0x14 
                           + CONVERT(VARBINARY(21), CONVERT(CHAR(6), @iv_TraderCode))
                           + CONVERT(VARBINARY(max), SUBSTRING(@BinCode, 7, 2), 2)
                           + CONVERT(VARBINARY(max), SUBSTRING(@BinCode, 5, 2), 2)
                           + CONVERT(VARBINARY(max), SUBSTRING(@BinCode, 3, 2), 2)
                           + CONVERT(VARBINARY(max), SUBSTRING(@BinCode, 1, 2), 2) 
                           + CONVERT(VARBINARY(21), SPACE(14))
                           )
  END

  RETURN @TraderHistoryCode
END

GO