unit TErrorsClass;

{******************************************************************************}
{   TErrors implements a simple mechanism for setting an error condition and   }
{   an associated error message. This allows functions and procedures to set   }
{   the error condition and exit. It is then up to the caller to check if an   }
{   error condition has been set.                                              }
{   Individual object classes expose two properties to callers:-               }
{    1. SysMsg: string read GetSysMsg; which returns TErrorsU.SysMsg           }
{    2. SysMsgSet: boolean read GetSysMsgSet; which returns TErrorsU.SysMsgSet }
{   Each object class also implements a SetSysMsg(Value: string) procedure     }
{   which in turn calls TErrorsU.SetSysMsg(Value);                             }
{                                                                              }
{   A call to SysMsg to return the current error message will clear the error  }
{   condition but will not clear the error message.                            }
{                                                                              }
{   This unit was originally going to expose a global instance of a TErrors    }
{   object class, hence the Object Pascal naming conventions.                  }
{******************************************************************************}

interface

function  SysMsg: string;
function  SysMsgNoClear: string;
procedure SetSysMsg(Value: string);
function  SysMsgSet: boolean;

implementation

var
  FSysMsg: string;
  FSysMsgSet: boolean;

procedure ClearSysMsg;
begin
  FSysMsgSet := false;
end;

function  SysMsg: string;
begin
  result := FSysMsg;
  ClearSysMsg;
end;

function  SysMsgNoClear: string;
begin
  result := FSysMsg;
end;

procedure SetSysMsg(Value: string);
begin
  FSysMsg    := Value;
  FSysMsgSet := true;
end;

function  SysMsgSet: boolean;
begin
  result := FSysMsgSet;
end;

initialization
  FSysMsgSet := false;
  FSysMsg    := '';

end.
