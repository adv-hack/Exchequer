unit FaxClass;

// Auxiliary fax classes

interface

uses
  Classes, VarConst;

type
  TQueuedFaxInfo =
    record
      QueuedStatus       : TFaxStatus;
      QueuedFaxNumber,
      QueuedAPFFileName,
      QueuedRecipient,
      QueuedSender,
      QueuedTitle        : string;
    end;
  PQueuedFaxInfo = ^TQueuedFaxInfo;

  TQueuedFaxInfoList = class(TList)
    public
      function FindStatus(Status : TFaxStatus) : integer;
      procedure RemoveItem(Index : integer);
      destructor Destroy; override;
  end;

  TStringListPartialMatch = class(TStringList)
    public
      function FindPartial(const S: string; LengthMatch : integer; var Index: Integer): boolean;
  end;

//=======================================================================

implementation

uses
  SysUtils;

function TStringListPartialMatch.FindPartial(const S: string; LengthMatch : integer;
  var Index: Integer): boolean;
// Pre   : LengthMatch = The number of characters from the start of the string to match
// Notes : Code originally copied from Classes.PAS TStringList.Find method
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := AnsiCompareText(copy(Strings[I],1,LengthMatch), copy(S,1,LengthMatch));
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

//=======================================================================

function TQueuedFaxInfoList.FindStatus(Status : TFaxStatus) : integer;
// Post : Returns the last item in the list with a particular status
var
  Posn : integer;
  Found : boolean;
begin
  Posn := Count -1;
  Found := false;
  while (Posn >= 0) and not Found do
  begin
    Found := TQueuedFaxInfo(Items[Posn]^).QueuedStatus = Status;
    dec(Posn);
  end;
  if Found then
    Result := Posn +1
  else
    Result := -1;
end; // TQueuedFaxInfoList.FindStatus

//-----------------------------------------------------------------------

procedure TQueuedFaxInfoList.RemoveItem(Index : integer);
begin
  if (Index >= 0) and (Index < Count) then
    if Assigned(Items[Index]) then
      dispose(PQueuedFaxInfo(Items[Index]));
end;

//-----------------------------------------------------------------------

destructor TQueuedFaxInfoList.Destroy;
var
  i : integer;
begin
  for i := 0 to Count -1 do
    RemoveItem(i);
  inherited Destroy;
end;

//=======================================================================


end.
