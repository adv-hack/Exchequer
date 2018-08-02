unit SchedulerDllInterface;

interface

uses
  Forms, VarConst;

const
  SchedulerInterval = 5 * 60; //5 minutes leeway to begin with
  

  function GetSchedulerTimeStamp : TDateTime;

  //PR: 18/04/2011 Added Screen parameter to avoid dialog in dll hiding when help is shown. ABSEXCH-11266
  function  AddScheduledPost(const App       : TApplication;
                             const Scr       : TScreen;
                             const DataPath  : ShortString;
                             const UserId    : ShortString;
                             const EmailAddr : ShortString;
                             DTypes          : DocSetType;
                             bProtectedMode  : Boolean;
                             bSeparate       : Boolean;
                             WhichPost       : Byte;
                             JobOptions      : Byte) : integer;

  procedure LibraryNotLoaded;


implementation

uses
  ApiUtil, FileUtil, Windows, Dialogs, SysUtils;

const
  sLibName = 'Schedule';
  sAddPostProc = 'AddScheduledPost';
  sTimeStampProc = 'GetSchedulerTimeStamp';

var

  _AddScheduledPost : function  (const App       : TApplication;
                                 const Scr       : TScreen;
                                 const DataPath  : ShortString;
                                 const UserId    : ShortString;
                                 const EmailAddr : ShortString;
                                 DTypes          : DocSetType;
                                 bProtectedMode  : Boolean;
                                 bSeparate       : Boolean;
                                 WhichPost       : Byte;
                                 JobOptions      : Byte) : integer; stdcall;

  _GetSchedulerTimeStamp : function  : TDateTime; stdcall;

  HSchedulerLibrary : THandle;

procedure LibraryNotLoaded;
begin
  msgbox('The file ' + QuotedStr(GetEnterpriseDirectory + sLibName + '.dll') +  ' was not found - this file is needed to schedule a daybook post.' +
          #10#10'Please contact your technical support.',
         mtWarning, [mbOK], mbOK, 'Schedule Daybook Post');
end;

function LoadSchedulerLibrary : Boolean;
begin
  if HSchedulerLibrary = 0 then
  begin
    HSchedulerLibrary := LoadLibrary(sLibName);
    if HSchedulerLibrary > HInstance_Error then
    begin
      _GetSchedulerTimeStamp := GetProcAddress(HSchedulerLibrary, sTimeStampProc);
      _AddScheduledPost := GetProcAddress(HSchedulerLibrary, sAddPostProc);
    end;
  end;
  Result := (HSchedulerLibrary > HInstance_Error) and Assigned(_GetSchedulerTimeStamp) and Assigned(_AddScheduledPost);
end;

function GetSchedulerTimeStamp : TDateTime;
begin
  if LoadSchedulerLibrary then
    Result := _GetSchedulerTimeStamp
  else
    Result := 1;
end;

function  AddScheduledPost(const App       : TApplication;
                           const Scr       : TScreen;
                           const DataPath  : ShortString;
                           const UserId    : ShortString;
                           const EmailAddr : ShortString;
                           DTypes          : DocSetType;
                           bProtectedMode  : Boolean;
                           bSeparate       : Boolean;
                           WhichPost       : Byte;
                           JobOptions      : Byte) : integer;
begin
  if LoadSchedulerLibrary then
    Result := _AddScheduledPost(App, Scr, DataPath, UserId, EmailAddr, DTypes, bProtectedMode, bSeparate, WhichPost, JobOptions)
  else
  begin
    Result := -1;
    LibraryNotLoaded;
  end;
end;


Initialization
  HSchedulerLibrary := 0;

Finalization

  if HSchedulerLibrary > HInstance_Error then
    FreeLibrary(HSchedulerLibrary);
end.
