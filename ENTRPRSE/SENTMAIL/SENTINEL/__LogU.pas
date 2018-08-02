unit LogU;

interface

uses
  Classes;

var
  LogFile : TStringList = nil;

  procedure LogIt(const s : string);

implementation

const
  FName = 'c:\servlog.txt';


  procedure LogIt(const s : string);
  begin
  {$IFDEF SERVICE}
    if not Assigned(LogFile) then
      LogFile := TSTringList.Create;
    LogFile.LoadFromFile(FName);
    LogFile.Add(s);
    LogFile.SaveToFile(FName);
  {$ENDIF}
  end;

Initialization
    if not Assigned(LogFile) then
      LogFile := TSTringList.Create;
    LogIt('LogU.Initialization');
Finalization
  LogIt('LogU.Finalization');
//  LogFile.Free;

end.
