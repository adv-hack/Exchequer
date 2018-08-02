unit DrillLog;

interface

Uses Classes, SysUtils;

Type
  // DrillLog Object for recording details of the Drill-Down processing
  // so that errors can be traced easily through the Help|About dialog
  TDrillLog = Class(TObject)
  Private
    FLogStrings : TStringList;
    function GetLines: TStrings;
  Protected

  Public
    Constructor Create;
    Destructor Destroy; Override;

    Property Lines : TStrings Read GetLines;

    // Adds a String into the Log
    Procedure AddString (Const DrillStr : ShortString);

    // Adds a Blank Line into the Log
    Procedure BlankLine;

    // Clears out any pre-existing log details
    Procedure ClearLog;
  End; { TDrillLog }


// Access function for a global DrillLog object which is automatically
// created by the routine the first time it is called.
Function DrillDownLog : TDrillLog;

implementation

Var
  // local object published through the DrillDownLog function
  oDrillLog : TDrillLog;

//=========================================================================

Function DrillDownLog : TDrillLog;
Begin { DrillDownLog }
  If (Not Assigned(oDrillLog)) Then
    oDrillLog := TDrillLog.Create;

  Result := oDrillLog;
End; { DrillDownLog }

//=========================================================================

constructor TDrillLog.Create;
begin
  Inherited Create;

  FLogStrings := TStringList.Create;
end;

//------------------------------

destructor TDrillLog.Destroy;
begin
  FreeAndNIL(FLogStrings);

  inherited Destroy;
end;

//-------------------------------------------------------------------------

function TDrillLog.GetLines: TStrings;
begin
  Result := FLogStrings;
end;

//-------------------------------------------------------------------------

// Adds a String into the Log
procedure TDrillLog.AddString(const DrillStr: ShortString);
begin
  FLogStrings.Add (DrillStr);
end;

//-------------------------------------------------------------------------

// Adds a Blank Line into the Log
procedure TDrillLog.BlankLine;
begin
  AddString('');
end;

//-------------------------------------------------------------------------

// Clears out any pre-existing log details
procedure TDrillLog.ClearLog;
begin
  FLogStrings.Clear;
end;

//-------------------------------------------------------------------------

end.
