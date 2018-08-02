IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_CreateNominalHistoryCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_CreateNominalHistoryCode]
GO


CREATE FUNCTION [common].[efn_CreateNominalHistoryCode] ( @iv_NominalCode              INT
                                                        , @iv_CostCentreDepartmentFlag VARCHAR(1) = NULL
                                                        , @iv_CostCentreCode           VARCHAR(3) = NULL
                                                        , @iv_DepartmentCode           VARCHAR(3) = NULL
                                                        , @iv_IsCommitment                 BIT    = 0
                                                        )
RETURNS VARBINARY(21)
AS
BEGIN
  DECLARE @BinCode            VARCHAR(10)
        , @NominalHistoryCode VARBINARY(21)
        , @CommitmentString   VARCHAR(6)
  
  IF @iv_IsCommitment = 1 SET @CommitmentString = ('CMT' + CHAR(2) + CHAR(2) + '!')

  SET @BinCode = CONVERT(VARCHAR, CONVERT(VARBINARY(21), @iv_NominalCode), 2)
  
  SET @NominalHistoryCode = CONVERT(VARBINARY(21),
                            0x14 
                          + CONVERT(VARBINARY(max), ISNULL(@CommitmentString, ''))
                          + CONVERT(VARBINARY(max), ISNULL(@iv_CostCentreDepartmentFlag, ''))
                          + CONVERT(VARBINARY(max), SUBSTRING(@BinCode, 7, 2), 2)
                          + CONVERT(VARBINARY(max), SUBSTRING(@BinCode, 5, 2), 2)
                          + CONVERT(VARBINARY(max), SUBSTRING(@BinCode, 3, 2), 2)
                          + CONVERT(VARBINARY(max), SUBSTRING(@BinCode, 1, 2), 2)
                          + CASE
                            WHEN @iv_CostCentreDepartmentFlag = 'C' THEN CONVERT(VARBINARY(max), CONVERT(CHAR(3), ISNULL(@iv_CostCentreCode, '')))
                            WHEN @iv_CostCentreDepartmentFlag = 'D' THEN CONVERT(VARBINARY(max), CONVERT(CHAR(3), ISNULL(@iv_DepartmentCode, '')))
                            ELSE CONVERT(VARBINARY(max), '')
                            END
                          + CASE
                            WHEN @iv_CostCentreDepartmentFlag = 'C' AND @iv_DepartmentCode IS NOT NULL THEN 0x02 + CONVERT(VARBINARY(max), CONVERT(CHAR(3), ISNULL(@iv_DepartmentCode, '')))
                            WHEN @iv_CostCentreDepartmentFlag = 'D' AND @iv_CostCentreCode IS NOT NULL THEN 0x01 + CONVERT(VARBINARY(max), CONVERT(CHAR(3), ISNULL(@iv_CostCentreCode, '')))
                            ELSE CONVERT(VARBINARY(max), '')
                            END
                          + CONVERT(VARBINARY(max), SPACE(21))
                            )
  RETURN @NominalHistoryCode
END

GO


