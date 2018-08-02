IF  NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'edt_Varchar' AND ss.name = N'common')

CREATE TYPE common.edt_Varchar AS TABLE
     ( VarcharValue      VARCHAR(max)
     )

GO