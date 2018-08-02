IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_CreateStockHistoryCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_CreateStockHistoryCode]
GO

CREATE FUNCTION [common].[efn_CreateStockHistoryCode]
              ( @iv_FolioNumber  INT
              , @iv_LocationCode VARCHAR(10)
              )
RETURNS VARBINARY(21)
AS
BEGIN
  DECLARE @StockhistoryCode VARBINARY(21)
  
  IF @iv_LocationCode = '' 
     SET @StockhistoryCode = 0x14 + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), MAX(@iv_FolioNumber) )) )
                                 + CONVERT(VARBINARY(21), CONVERT(CHAR(16), ISNULL(@iv_LocationCode,'') ))
  ELSE
     SET @StockhistoryCode = 0x144C + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), MAX(@iv_FolioNumber) )) )
                                    + CONVERT(VARBINARY(21), CONVERT(CHAR(16), ISNULL(@iv_LocationCode,'') ))

   RETURN @StockHistoryCode
END

GO