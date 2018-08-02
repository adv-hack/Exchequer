unit NoteAdder;

interface
 uses enterprise04_tlb;

type TAddNote = Class
 protected
  fNote, FAddNote : INotes;
  fToolkit : IToolKit;
  procedure SetNoteProperties(param : integer);
  function SaveNote(fObj, fParam : integer) : integer;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
 end;

implementation

procedure TAddNote.SetNoteProperties(param : integer);
begin
 fNote.ntType := 0;

 FAddNote := fNote.Add;

 with fNote do
 begin
    ntLineNo := 5;
    ntDate := '12/07/2011';
    ntAlarmDate  := '12/08/2011';
    ntAlarmUser := 'Manager';

    case param of
     30004 : ntLineNo := 0;
     30005 : ntDate := '12/12/9999';
     30006 : ntAlarmDate := '12/12/9999';
     30007 : ntAlarmUser := 'NotAUser';
    end;
 end;
end;

function TAddNote.SaveNote(fObj, fParam : integer) : integer;
var
 searchKey : longint;
begin
   SetNoteProperties(fParam);

   case fObj of
      0 :  with fToolkit.Customer do
           begin
               Index := acIdxCode;
               searchKey := BuildCodeIndex('ABAP01');
               funcRes := GetEqual(searchKey);

               fNote := acNotes.Add;
           end;
      2 :  with fToolkit.Stock do
           begin
               Index := acIdxCode;
               searchKey := BuildCodeIndex('BAT-1.5AA-ALK');
               funcRes := GetEqual(searchKey);

               fNote := stNotes.Add;
           end;
   end;

   result := fNote.Save;
end;

end.
 