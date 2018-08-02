(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit Msdef;

{$I msdef.inc}

interface

uses Classes,SysUtils,Messages,msConst;

const
  msVersion = '2.1';

const
  WM_IMSBASE = WM_USER+1122;
  WM_ASYNCNOTIFICATION = WM_IMSBASE;

var
  LocalTimeZoneString : ShortString;

type
  EmsTimedOutError = class(Exception)
    constructor Create;
  end;

  EmsCanceledError = class(Exception)
    constructor Create;
  end;

  EmsTooMuchDataError = class(Exception)
    constructor Create;
  end;

  EmsServerError = class(Exception);

  EmsMessageError = class(Exception);

  EmsFTPTransferError = class(Exception);

  EmsMIMEError = class(Exception);

  EmsError = class(Exception);

implementation

constructor EmsTimedOutError.Create;
begin
  inherited Create('Operation timed out');
end;

constructor EmsCanceledError.Create;
begin
  inherited Create('Operation has been canceled');
end;

constructor EmsTooMuchDataError.Create;
begin
  inherited Create('Buffer is full. Will disconnect.');
end;

end.
