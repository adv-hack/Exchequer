
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_Notes]'))
DROP VIEW [!ActiveSchema!].evw_Notes
GO

CREATE VIEW !ActiveSchema!.evw_Notes WITH VIEW_METADATA
AS
SELECT NoteId          = PositionId
     , NoteCode        = CASE 
                         WHEN NT.NoteTypeCode IN ('A', 'E', 'L', 'P','T', '2') THEN N.Exchqchkcode1Trans7
                         END
     , FolioNumber     = CASE 
                         WHEN NT.NoteTypeCode IN ('B', 'D', 'J', 'S', 'R') THEN N.Exchqchkcode1Trans5
                         END
     , NT.NoteTypeCode
     , NT.NoteTypeDescription
     , NoteAlarm      = CONVERT(BIT, CASE
                                     WHEN N.Exchqchkcode3Trans2 = 0 THEN 0
                                     ELSE 1
                                     END)
     , NoteAlarmDate  = CASE
                        WHEN N.Exchqchkcode3Trans2 = 0 THEN ''
                        ELSE N.Exchqchkcode3Trans3
                        END
     , NoteDate       = N.Exchqchkcode2Trans1
     , NType
     , LineNumber
     , NoteLine
     , NoteUser
     , TmpImpCode
     , ShowDate
     , RepeatNo
     , NoteFor
  
FROM   !ActiveSchema!.EXCHQCHK N
LEFT JOIN   common.evw_NoteType NT ON N.SubType = NT.NoteTypeId
WHERE RecPfix = 'N'
GO

