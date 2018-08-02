unit SpecialFunction;

interface

uses Controls, SFHeaderU;

{ Returns the title for this function. This will be displayed in the Special
  Functions selection list. }
function Title: ShortString;

{ Carries out the actual function. }
function Execute(Mode: Integer; Callback: TProgressCallback; OutputCallback: TOutputCallback): Boolean;

implementation

uses SysUtils;

function Title: ShortString;
begin
  Result := 'This title must be changed. It should be a user-friendly name for the special function.';
end;

function Execute(Mode: Integer; Callback: TProgressCallback; OutputCallback: TOutputCallback): Boolean;
begin
  Result := True;
  OutputCallback(Title, osHeader);
  {
    // Do processing. Call the callback to update the progress bar, and to
    // check that the user has not cancelled.
    while not Done do
    begin
      ...
      if not Callback(MaxRecords, CurrentPosition) then
      begin
        OutputCallback('DLL function cancelled');
        Result := False;
        Break;
      end;
    end;
  }
  OutputCallback('DLL function completed', osNormal);
end;

end.
