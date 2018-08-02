unit AddNote;

interface
 uses enterprise04_tlb;

type TAddNote = Class
 protected
  fNote, FAddNote : INotes;
  fToolkit : IToolKit;
  fExpectedResult, fDocType : Integer;  
  fNoteType : TNotesType;
  procedure SetNoteProperties;
  function FindParentInterface : Integer; virtual; abstract;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  property NoteType : TNotesType read fNoteType write fNoteType;
  function SaveNote : integer; virtual;
 end;

type TAddCustomerNote = class(TAddNote)
public
 function FindParentInterface : integer; override;
end;

type TAddTransactionNote = class(TAddNote)
public
 function FindParentInterface : integer; override;
end;

type TAddStockNote = class(TAddNote)
public
 function FindParentInterface : integer; override;
end;

type TAddJobNote = class(TAddNote)
public
 function FindParentInterface : integer; override;
end;

type TAddEmployeeNote = class(TAddNote)
public
 function FindParentInterface : integer; override;
end;

type TAddLocationNote = class(TAddNote)
public
 function FindParentInterface : integer; override;
end;

type TAddCostCentreNote = class(TAddNote)
public
 function FindParentInterface : integer; override;
end;

type TAddSerialBatchNote = class(TAddNote)
public
 function FindParentInterface : integer; override;
end;

type TAddAltStockCodeNote = class(TAddNote)
public
 function FindParentInterface : integer; override;
end;

function GetNoteObject(docType : Integer) : TAddNote;

implementation

function GetNoteObject(docType : Integer) : TAddNote;
begin
  Case docType of
    0 : Result := TAddCustomerNote.Create;
    1 : Result := TAddTransactionNote.Create;
    2 : Result := TAddStockNote.Create;
    3 : Result := TAddJobNote.Create;
    4 : Result := TAddEmployeeNote.Create;
    5 : Result := TAddLocationNote.Create;
    6 : Result := TAddCostCentreNote.Create;
    7 : Result := TAddSerialBatchNote.Create;
    8 : Result := TAddAltStockCodeNote.Create;
    else
      Result := nil;
  end;
end;

function TAddNote.SaveNote : integer;
begin
 Result := FindParentInterface;

 if Result = 0 then
 begin
   SetNoteProperties;
   Result := FAddNote.Save;
 end;
 
end;

procedure TAddNote.SetNoteProperties;
var
 lineNo : integer;
begin
 fNote.ntType := fNoteType;

 with fNote do
 begin
  GetLast;
  lineNo := fNote.ntLineNo;
 end;

 FAddNOte := fNote.Add;
 with fAddNote do
 begin
    ntLineNo := lineNo;
    ntDate := '20/07/2011';
    ntAlarmDate  := '21/08/2011';
    ntAlarmUser := 'Manager';
    ntText := 'Note Text';
    ntOperator := 'Manager';

    case fExpectedResult of
     30004 : ntLineNo := 0;
     30005 : ntDate := '12/12/9999';
     30006 : ntAlarmDate := '12/12/9999';
     30007 : ntAlarmUser := 'NotAUser';
    end;
 end;
end;

function TAddCustomerNote.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Customer do
  begin
    Index := acIdxCode;
    searchKey := BuildCodeIndex('ABAP01');
    result := GetEqual(searchKey);

    fNote := acNotes;
  end;
end;

function TAddTransactionNote.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Transaction do
  begin
   Index := acIdxCode;
   searchKey := 'SIN008255';
   result := GetEqual(searchKey);

   fNote := thNotes;
  end;
end;

function TAddStockNote.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Stock do
  begin
   Index := acIdxCode;
   searchKey := BuildCodeIndex('BAT-1.5AA-ALK');
   result := GetEqual(searchKey);

   fNote := stNotes;
  end;
end;

function TAddJobNote.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.JobCosting.Job do
  begin
    Index := acIdxCode;
    searchKey := BuildCodeIndex('BRID - PH1');
    result := GetEqual(searchKey);

    fNote := jrNotes;
  end;
end;

function TAddEmployeeNote.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.JobCosting.Employee as IEmployee2 do
  begin
   result := GetFirst;

   fNote := emNotes;
  end;
end;

function TAddLocationNote.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Location as ILocation2 do
  begin
   Index := acIdxCode;
   searchKey := BuildCodeIndex('AAA');
   result := GetEqual(searchKey);

   fNote := loNotes;
  end;
end;

function TAddCostCentreNote.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.CostCentre as ICCDept3 do
  begin
   Index := acIdxCode;
   searchKey := BuildCodeIndex('DS1');
   result := GetEqual(searchKey);

   fNote := cdNotes;
  end;
end;

function TAddSerialBatchNote.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Stock do
  begin
   Index := acIdxCode;
   searchKey := BuildCodeIndex('ALARMSYS-DOM-5');
   result := GetEqual(searchKey);

   if(stValuationMethod = stValSerial) or (stValuationMethod = stValSerialAvgCost) then
   begin
     with stSerialBatch do
      fNote := stNotes
   end
   else
     result := -1;
  end;
end;

function TAddAltStockCodeNote.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Stock as IStock2 do
  begin
   Index := acIdxCode;
   searchKey := BuildCodeIndex('BAT-1.5AA-ALK');

   result := GetEqual(searchKey);

   with stAltStockCode do
   begin
    fNote := stNotes;
   end;
  end;
end;

end.
