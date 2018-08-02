IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_TableFromList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_TableFromList]
GO

CREATE FUNCTION common.efn_TableFromList ( @iv_List VARCHAR(max)
                                         )
RETURNS @ListTable TABLE 
      ( ListValue VARCHAR(max)
      )
AS
BEGIN

  SET @iv_List = REPLACE(@iv_List, ', ',',')

  DECLARE @ListXML XML

  SET @ListXML = CAST('<L>' + REPLACE(@iv_List, ',', '</L><L>') + '</L>' AS XML)
  
  INSERT INTO @ListTable
  SELECT ListValue 
  FROM ( SELECT ListValue = l.value('.', 'varchar(max)')
         FROM   @ListXML.nodes('/L') AS x(l)
       ) List
  WHERE ListValue <> ''
  
  RETURN
END

GO

