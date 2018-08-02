unit TSCom2;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseSecurity_TLB, IRISTimesheets_TLB, StdVcl, dialogs, sysutils, Windows;

type
  TODDTimesheets = class(TAutoObject, IODDTimesheets)
  protected
    procedure Startup(const A, B: WideString); safecall;
  public
    destructor Destroy; override;
  end;

var
  GA: WideString;
  GB: WideString;

implementation

uses ComServ;

destructor TODDTimesheets.Destroy;
var
  ThirdParty: IThirdParty;
begin
  ThirdParty := CreateOleObject('EnterpriseSecurity.ThirdParty') as IThirdParty;
  with ThirdParty do
  begin
    tpSystemIdCode := GA;
    tpSecurityCode := GB;
    tpDescription  := 'Outlook Dynamic Dashboard Timesheets';
    tpSecurityType := SecUserCountOnly; //
    if RemoveUserCount <> 0
      then MessageBox(GetDesktopWindow, pchar(format('ODD Timesheet error %s', [#13#10 + Get_LastErrorString])), 'ODD Timesheets', MB_OK);
  end;
  ThirdParty := nil;

  inherited;
end;

procedure TODDTimesheets.Startup(const A, B: WideString);
begin
  GA := A;
  GB := B;
//  ShowMessage(format('Received %s and %s', [GA, GB]));
end;

initialization
  TAutoObjectFactory.Create(ComServer, TODDTimesheets, Class_ODDTimesheets,
    ciSingleInstance, tmApartment);
end.
