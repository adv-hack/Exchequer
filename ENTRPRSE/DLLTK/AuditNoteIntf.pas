unit AuditNoteIntf;

//PR: 28/10/2010 v6.9 As saves in both toolkits always go through the global files,
//we can implement a global Audit Note object as a singleton.

interface

uses
  AuditNotes;

var

  //PR: 28/10/2010 v6.9
  //Toolkit user allows LIVE team to specify a user for the current session.
  ToolkitUser : string;
  function AuditNote : TAuditNote;
  procedure ClearAuditNoteObject;


implementation

uses
  SysUtils, BtrvU2, VarConst;

var
  oAuditNote : TAuditNote;

function AuditNote : TAuditNote;

  function GetToolkitUser : string;
  begin
    if ToolkitUser = '' then
    {$IFDEF WANTEXE}
       Result := 'COM Toolkit'
    {$ELSE}
       Result := ExtractFileName(ParamStr(0))
    {$ENDIF}
    else
      Result := ToolkitUser;
  end;

begin
  if not Assigned(oAuditNote) then
     oAuditNote := TAuditNote.Create(GetToolkitUser, @F[PWrdF]);

  Result := oAuditNote;
end;

//Called when we close a data set, so if we're changing company the object
//will be recreated with the correct data file
procedure ClearAuditNoteObject;
begin
  FreeAndNil(oAuditNote);
end;


Initialization
  ToolkitUser := '';
  oAuditNote := nil;

end.
