unit ExceptIntf;

interface

uses
 ComObj;

{ TAutoInftObjectEx is designed to intercept Exception handling and create
  a MadExcept bug report from the exception object before returning control
  to the standard COM exception handling system. The method will also use
  OutputDebugString to send the exception message to any debug viewers that
  are running.

  Toolkit objects which are currently descended from TAutoIntfObject will be
  changed to descend from TAutoInftObjectEx in order to implement this
  functionality. Future toolkit objects should also be descended from
  TAutoInftObjectEx.
}

type
  TAutoIntfObjectEx = Class(TAutoIntfObject)
  public
    function SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult; override;
  end;

implementation

uses
  SysUtils, madExcept, Windows;

{ TAutoIntfObjectEx }

function TAutoIntfObjectEx.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
var
  sExceptionMessage : AnsiString;
begin
  if ExceptObject is Exception then
  begin
    sExceptionMessage := Exception(ExceptObject).Message;
    OutputDebugString(PChar(sExceptionMessage));
    AutoSaveBugReport(CreateBugReport(etNormal, ExceptObject, ExceptAddr));
  end;
  Result := inherited SafeCallException(ExceptObject, ExceptAddr);
end;

end.
