unit HideMadExcept;

interface

var
  BugReportName : string;

implementation

uses madExcept, Dialogs;

procedure HideMadExceptDialog(const exceptIntf : IMEException;
                              var handled      : boolean);
begin
  exceptIntf.BugReportFile := BugReportName;
  handled := True;
end;

initialization
  RegisterExceptionHandler(HideMadExceptDialog, stDontSync);
end.
