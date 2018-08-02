IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_NoteType]'))
DROP VIEW [common].[evw_NoteType]
GO

CREATE VIEW common.evw_NoteType WITH VIEW_METADATA
AS
SELECT *
FROM ( VALUES ( 65, 'A', 'Customer/Supplier Notes')
            , ( 66, 'B', 'Alternate Stock Code Notes')
            , ( 68, 'D', 'Transaction Notes')
            , ( 69, 'E', 'Employee Notes')
            , ( 74, 'J', 'Job Notes')
            , ( 76, 'L', 'Location & Stock Location Notes')
            , ( 80, 'P', 'Department Notes')
            , ( 82, 'R', 'Serial/Batch Notes')
            , ( 83, 'S', 'Stock Notes')
            , ( 84, 'T', 'Cost Centre Notes')
            , (  2, '2', 'Notes added via Workflow Diary')
     ) NT ( NoteTypeId
          , NoteTypeCode
          , NoteTypeDescription
          )
GO


