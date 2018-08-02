unit dll_abstl;

interface


procedure CreateExistingLineNos;
procedure FreeExistingLineNos;
function AddExistingLineNo(ELNo : longint) : Boolean;
function LineNoExists(LNo : longint) : Boolean;
function NewAbsLineNo(var LineCount : longint) : longint;

implementation

uses
  Classes, SysUtils;

const
  IncBits = 64;

var
  ExistingLineNos : TBits;

procedure CreateExistingLineNos;
begin
  ExistingLineNos := TBits.Create;
  ExistingLineNos.Size := IncBits;
  ExistingLineNos[0] := True;
end;

procedure FreeExistingLineNos;
begin
  FreeAndNil(ExistingLineNos);
end;

function AddExistingLineNo(ELNo : longint) : Boolean;
begin
  if ELNo >= ExistingLineNos.Size then
  begin
    ExistingLineNos.Size := ElNo + IncBits;
    Result := True;
  end
  else
    Result := not ExistingLineNos[ELNo];

  if Result then
    ExistingLineNos[ELNo] := True;
end;

function LineNoExists(LNo : longint) : Boolean;
begin
  Result := ExistingLineNos[LNo];
end;

function NewAbsLineNo(var LineCount : longint) : longint;
//Function to allocate a new AbsLineNo for a transaction
var
  i : integer;
begin
  //LineCount is Inv.ILineCount which should be set to the next AbsLineNo to be allocated
  if LineCount >= ExistingLineNos.Size then
    ExistingLineNos.Size := LineCount + IncBits;

  //If there is already an AbsLineNo equal to LineCount, increase LineCount until there isn't
  while ExistingLineNos[LineCount] do
  begin
    inc(LineCount);
    if LineCount >= ExistingLineNos.Size then
      ExistingLineNos.Size := LineCount + IncBits;
  end;

  ExistingLineNos[LineCount] := True;
  Result := LineCount;

  //Set LineCount to next AbsLineNo
  inc(LineCount);
end;


end.
