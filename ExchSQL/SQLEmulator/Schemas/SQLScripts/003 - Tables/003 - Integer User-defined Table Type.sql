IF  NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'edt_Integer' AND ss.name = N'common')

CREATE TYPE common.edt_Integer AS TABLE
     ( IntegerValue      INT
     )

GO