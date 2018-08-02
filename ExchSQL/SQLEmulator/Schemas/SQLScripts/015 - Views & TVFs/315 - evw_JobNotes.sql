
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobNotes]'))
DROP VIEW [!ActiveSchema!].evw_JobNotes
GO

CREATE VIEW !ActiveSchema!.evw_JobNotes WITH VIEW_METADATA
AS
SELECT NoteId         = PositionId
     , JobFolioNumber = N.Exchqchkcode1Trans5
     , NoteFolio
     , NoteDate       = Exchqchkcode2Trans1
     , NoteType       = NType
     , NoteAlarm      = CONVERT(BIT, CASE
                                     WHEN N.Exchqchkcode3Trans2 = 0 THEN 0
                                     ELSE 1
                                     END)
     , NoteAlarmDate  = CASE
                        WHEN N.Exchqchkcode3Trans2 = 0 THEN ''
                        ELSE N.Exchqchkcode3Trans3
                        END
     , LineNumber
     , NoteLine
     , NoteUser
     , TmpImpCode
     , ShowDate
     , RepeatNo
     , NoteFor
  
FROM   !ActiveSchema!.EXCHQCHK N
WHERE N.RecPfix = 'N'
AND   N.SubType = ASCII('J')
GO