unit HideMadExcept;

interface

var
  BugReportName : string;

implementation

uses madExcept, Dialogs, LogF, SysUtils;


procedure HideMadExceptDialog(const exceptIntf : IMEException;
                              var handled      : boolean);
begin
  DoLog(#10#13 + exceptIntf.BugReport);
  BugReportName := ExtractFilePath(ParamStr(0)) + 'SchedSrvBugReport.txt';
  exceptIntf.BugReportFile := BugReportName;
  handled := True;
end;

initialization
  RegisterExceptionHandler(HideMadExceptDialog, stDontSync);

finalization
end.
