unit SpecialFunction;

interface

uses Controls, SFHeaderU;

{ Returns the title for this function. This will be displayed in the Special
  Functions selection list. }
function Title: ShortString;

{ Carries out the actual function. }
function Execute(Mode: Integer; Callback: TProgressCallback; OutputCallback: TOutputCallback): Boolean;

implementation

uses SysUtils, Forms;

function Title: ShortString;
begin
  Result := 'Test DLL';
end;

function Execute(Mode: Integer; Callback: TProgressCallback; OutputCallback: TOutputCallback): Boolean;
var
  i, j: Integer;
begin
  Result := True;
  OutputCallback('Call to DLL Function', osSubHeader);
  for i := 1 to 10000 do
  begin
    for j := 1 to 10000 do
    begin
      Application.ProcessMessages;
    end;
    if not Callback(10000, i) then
    begin
      Result := False;
      Break;
    end;
  end;
  OutputCallback('DLL function finished', osNormal);
end;

end.
