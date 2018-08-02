IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[efn_StockHierarchy]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[efn_StockHierarchy]
GO

CREATE FUNCTION !ActiveSchema!.efn_StockHierarchy ()
RETURNS @StockHierarchy TABLE 
                    ( StockId          INT PRIMARY KEY
                    , StockCode        VARCHAR(50)
                    , ParentStockId    INT         NULL
                    , ParentStockCode  VARCHAR(50) NULL
                    , StockHierarchy   VARCHAR(500)
                    , HierarchyLevel   INT
                    , Level0StockCode  VARCHAR(50) NULL
                    , Level1StockCode  VARCHAR(50) NULL
                    , Level2StockCode  VARCHAR(50) NULL
                    , Level3StockCode  VARCHAR(50) NULL
                    , Level4StockCode  VARCHAR(50) NULL
                    , Level5StockCode  VARCHAR(50) NULL
                    , Level6StockCode  VARCHAR(50) NULL
                    , Level7StockCode  VARCHAR(50) NULL
                    , Level8StockCode  VARCHAR(50) NULL
                    , Level9StockCode  VARCHAR(50) NULL
                    )
AS
BEGIN

DECLARE @ThisLevel INT = 0
      , @Rows      INT = 1

-- Insert TOP Level Stock

INSERT INTO @StockHierarchy
          ( StockId
          , StockCode
          , ParentStockId
          , ParentStockCode
          , StockHierarchy
          , HierarchyLevel
          , Level0StockCode
          )
SELECT StockId
     , StockCode
     , ParentStockId    = CONVERT(INT, NULL)
     , ParentStockCode  = CONVERT(VARCHAR(50), '')
     , StockHierarchy   = CONVERT(VARCHAR(max), '~' + StockCode + '~')
     , HierarchyLevel = 0
     , Level0StockCode  = StockCode
FROM   !ActiveSchema!.evw_Stock S
WHERE  ISNULL(S.ParentStockCode, '') = ''

SELECT @Rows = @@ROWCOUNT

WHILE @ThisLevel < 10 AND @Rows > 0
BEGIN

  SET @ThisLevel = @ThisLevel + 1

  INSERT INTO @StockHierarchy
  SELECT S.StockId
       , S.StockCode
       , ParentStockId    = SH.StockId
       , ParentStockCode  = CONVERT(VARCHAR(50), SH.StockCode)
       , StockHierarchy   = SH.StockHierarchy + CONVERT(VARCHAR(max), S.StockCode + '~')
       , HierarchyLevel   = @ThisLevel
       , Level0StockCode  = SH.Level0StockCode
       , Level1StockCode  = CASE 
                            WHEN @ThisLevel = 1 THEN S.StockCode
                            ELSE SH.Level1StockCode
                            END
       , Level2StockCode  = CASE 
                            WHEN @ThisLevel = 2 THEN S.StockCode
                            ELSE SH.Level2StockCode
                            END
       , Level3StockCode  = CASE 
                            WHEN @ThisLevel = 3 THEN S.StockCode
                            ELSE SH.Level3StockCode
                            END
       , Level4StockCode  = CASE 
                            WHEN @ThisLevel = 4 THEN S.StockCode
                            ELSE SH.Level4StockCode
                            END
       , Level5StockCode  = CASE 
                            WHEN @ThisLevel = 5 THEN S.StockCode
                            ELSE SH.Level5StockCode
                            END
       , Level6StockCode  = CASE 
                            WHEN @ThisLevel = 6 THEN S.StockCode
                            ELSE SH.Level6StockCode
                            END
       , Level7StockCode  = CASE 
                            WHEN @ThisLevel = 7 THEN S.StockCode
                            ELSE SH.Level7StockCode
                            END
       , Level8StockCode    = CASE 
                            WHEN @ThisLevel = 8 THEN S.StockCode
                            ELSE SH.Level8StockCode
                            END
       , Level9StockCode  = CASE 
                            WHEN @ThisLevel = 9 THEN S.StockCode
                            ELSE SH.Level9StockCode
                            END
       
  FROM   !ActiveSchema!.evw_Stock S
  JOIN   @StockHierarchy sH ON SH.StockCode = S.ParentStockCode COLLATE SQL_Latin1_General_CP1_CI_AS
  WHERE  SH.HierarchyLevel = @ThisLevel - 1

  SET @Rows = @@ROWCOUNT

END

RETURN

END

GO