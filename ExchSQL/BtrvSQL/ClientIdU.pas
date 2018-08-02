unit ClientIdU;
{
  Types and classes for maintaining a list of Client IDs and the company paths
  that they relate to. Used by BtrvSQL for determining when companies should
  be opened.
}
interface

uses SysUtils, Classes;

type
  { Copy of ClientIdType record structure from BtrvU2.pas }
  TClientId = record
    Reserved: array[1..12] of Byte;
    AppId   : array[1..2] of Char;
    TaskId  : SmallInt;
  end;
  PClientID = ^TClientId;

  { Record linking company path to Client ID. }
  TClientIDLink = record
    IsMainSession: Boolean;
    AppID: array[1..2] of Char;
    TaskID: SmallInt;
    Path: string;
  end;
  PClientIDLink = ^TClientIDLink;

  { Object to maintain list of client IDs. There will always be at least one
    client ID link record, which will hold nil for the Client ID and will
    represent no client ID (in other words, it represents the main session). }
  TClientIDs = class(TObject)
  private

    { List of Client ID link records. }
    List: TList;

    { Field holding a pointer to the record for the main session, to prevent
      having to search the list every time we need to access this. }
    MainSessionRecord: PClientIDLink;

    { Adds a Client ID link record to represent the main session. This will be
      used whenever the ClientID supplied to the other methods of this class is
      nil. }
    procedure AddMainSessionRecord;

  public
    constructor Create;
    destructor Destroy; override;

    { Adds a new Client ID link record using the supplied Client ID details,
      provided no existing record can be found matching the details. Returns
      the newly added record, or the existing record if one was found. Does
      nothing if ClientID is nil (and returns nil). }
    function AddID(ClientID: Pointer; Path: string): PClientIDLink;

    { Clears the list of Client ID Link records. }
    procedure Clear;

    { Locates and returns the Client ID link record matching the details in
      the supplied Client ID. Returns nil if no matching entry can be found. }
    function ID(ClientID: Pointer): PClientIDLink;

    { Locates and returns the path from the Client ID link record matching the
      details in the supplied Client ID. Returns an empty string if no
      matching entry can be found. }
    function IDPath(ClientID: Pointer): string;

    { Removes the Client ID link record matching the supplied details. Does
      nothing if a matching record cannot be found. }
    procedure RemoveID(ClientID: Pointer; Remove: Boolean = True);

  end;

implementation

var
  IDCallProtector: TMultiReadExclusiveWriteSynchronizer;

// =============================================================================
// TClientIDs
// =============================================================================
function TClientIDs.AddID(ClientID: Pointer; Path: string): PClientIDLink;
var
  i: Integer;
  Found: Boolean;
  LinkRecord: PClientIDLink;
begin
  Result := nil;
  if (Pointer(ClientID) <> nil) then
  begin
    IDCallProtector.BeginRead;
    try
      { Look for an existing entry matching the Client ID details. }
      Found := False;
      for i := 0 to List.Count - 1 do
      begin
        if (PClientIDLink(List[i]).AppId = PClientID(ClientID).AppId) and
           (PClientIDLink(List[i]).TaskId = PClientID(ClientID).TaskId) then
        begin
          Found := True;
          Result := PClientIDLink(List[i]);
          Break;
        end;
      end;
    finally
      IDCallProtector.EndRead;
    end;
    { If no entry was found, add a new entry. }
    if not Found then
    begin
      IDCallProtector.BeginWrite;
      try
        New(LinkRecord);
        LinkRecord.AppID[1] := PClientID(ClientID).AppId[1];
        LinkRecord.AppID[2] := PClientID(ClientID).AppId[2];
        LinkRecord.TaskID   := PClientID(ClientID).TaskId;
        LinkRecord.IsMainSession := False;
        LinkRecord.Path     := Path;
        List.Add(LinkRecord);
        Result := LinkRecord;
      finally
        IDCallProtector.EndWrite;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TClientIDs.AddMainSessionRecord;
var
  LinkRecord: PClientIDLink;
begin
  IDCallProtector.BeginWrite;
  try
    New(LinkRecord);
    LinkRecord.IsMainSession := True;
    LinkRecord.AppID := #0#0;
    LinkRecord.TaskID := 0;
    LinkRecord.Path := '';
    List.Add(LinkRecord);
    MainSessionRecord := LinkRecord;
  finally
    IDCallProtector.EndWrite;
  end;
end;

// -----------------------------------------------------------------------------

procedure TClientIDs.Clear;
var
  i: Integer;
begin
  IDCallProtector.BeginWrite;
  try
    for i := List.Count - 1 downto 0 do
    begin
      Dispose(List[i]);
      List[i] := nil;
    end;
    List.Clear;
  finally
    IDCallProtector.EndWrite;
  end;
end;

// -----------------------------------------------------------------------------

constructor TClientIDs.Create;
begin
  inherited Create;
  if (IDCallProtector = nil) then
    IDCallProtector := TMultiReadExclusiveWriteSynchronizer.Create;
  List := TList.Create;
  AddMainSessionRecord;
end;

// -----------------------------------------------------------------------------

destructor TClientIDs.Destroy;
begin
  Clear;
  List.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TClientIDs.ID(ClientID: Pointer): PClientIDLink;
var
  i: Integer;
begin
  Result := nil;
  IDCallProtector.BeginRead;
  try
    if (Pointer(ClientID) <> nil) then
    begin
      for i := 0 to List.Count - 1 do
      begin
        if (PClientIDLink(List[i]).AppId = PClientID(ClientID).AppId) and
           (PClientIDLink(List[i]).TaskId = PClientID(ClientID).TaskId) then
        begin
          Result := List[i];
          Break;
        end;
      end;
    end
    else
      Result := MainSessionRecord;
  finally
    IDCallProtector.EndRead;
  end;
end;

// -----------------------------------------------------------------------------

function TClientIDs.IDPath(ClientID: Pointer): string;
var
  LinkRecord: PClientIDLink;
begin
  IDCallProtector.BeginRead;
  try
    LinkRecord := ID(ClientID);
    if (LinkRecord <> nil) then
      Result := LinkRecord.Path
    else
      Result := '';
  finally
    IDCallProtector.EndRead;
  end;
end;

// -----------------------------------------------------------------------------

procedure TClientIDs.RemoveID(ClientID: Pointer; Remove: Boolean);
var
  i: Integer;
begin
  IDCallProtector.BeginWrite;
  try
    for i := 0 to List.Count - 1 do
    begin
      if (PClientIDLink(List[i]).AppId = PClientID(ClientID).AppId) and
         (PClientIDLink(List[i]).TaskId = PClientID(ClientID).TaskId) then
      begin
        if not PClientIDLink(List[i]).IsMainSession then
        begin
          if (Remove) then
            Dispose(List[i]);
          List.Delete(i);
        end;
        Break;
      end;
    end;
  finally
    IDCallProtector.EndWrite;
  end;
end;

// -----------------------------------------------------------------------------

initialization

finalization

  if Assigned(IDCallProtector) then
    IDCallProtector.Free;

end.
