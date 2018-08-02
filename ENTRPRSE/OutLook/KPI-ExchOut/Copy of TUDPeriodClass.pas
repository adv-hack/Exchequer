unit TUDPeriodClass;

interface

uses Windows, SysUtils, dialogs;

type
//  TGetUDPeriodYear = function(sDataPath, sDate: string; var iPeriod: Byte; var iYear: Byte): boolean; stdcall;
//  TUseUDPeriods    = function(pDataPath: pChar): smallint; stdcall;

  TUDPeriod = class(TObject)
  private
    FDLL: THandle;
    FGlobalPeriod: integer;
    FGlobalYear: integer;
    FDataPath: string;
    FAutoSetPeriod: boolean;
//    FGetUDPeriodYear: TGetUDPeriodYear;
//    FUseUDPeriods: TUseUDPeriods;
    FSetTransPeriodByDate: boolean;
    function DLLFilename: string;
  public
//    function DLLExists: boolean;
    function GetPeriod(ADate: string; ShowErrorMessage: boolean): integer;
    function GetYear(ADate: string; ShowErrorMessage: boolean): integer;
//    function LoadDLL: integer;
//    function UnloadDLL: boolean;
    property AutoSetPeriod: boolean read FAutoSetPeriod;                // ReadOnly based on whether the UDPeriod plugin returns a pr/yr
    property SetTransPeriodByDate: boolean write FSetTransPeriodByDate; // from Exchequer System Setup  = WriteOnly
    property DataPath:     string   read FDataPath      write FDataPath;
    property GlobalPeriod: integer  read FGlobalPeriod  write FGlobalPeriod;
    property GlobalYear:   integer  read FGlobalYear    write FGlobalYear;
  end;

function UDPeriod(ADataPath: string = ''): TUDPeriod;

implementation

uses VAOUtil, PerUtil;

var FUDPeriod: TUDPeriod;
    FShowErrorMessage: boolean;

function UDPeriod(ADataPath: string = ''): TUDPeriod;
begin
  if FUDPeriod = nil then
    FUDPeriod := TUDPeriod.Create;

  if ADataPath <> '' then
    FUDPeriod.DataPath := ADataPath;

  result := FUDPeriod;
end;

{ TUDPeriod }

{function TUDPeriod.DLLExists: boolean;
begin
  result := FileExists(DLLFilename);
end;}

function TUDPeriod.DLLFilename: string;
begin
  result := VAOInfo.VAOAppsDir + 'udperiod.dll';
end;

procedure LocalMessageDlg(sMessage : string);
begin
  if FShowErrorMessage then ShowMessage(sMessage);
end;

function TUDPeriod.GetPeriod(ADate: string; ShowErrorMessage: boolean): integer;
begin
  result         := FGlobalPeriod;
  FAutoSetPeriod := FSetTransPeriodByDate;
  FShowErrorMessage := ShowErrorMessage;
  try
    if not FAutoSetPeriod then EXIT;

    if FDataPath = '' then begin
      ShowMessage('Company data path not set for user-defined period plug-in');
      EXIT;
    end;

    with TPeriodCalc.Create(FDataPath) do begin
      try
        EntMessageDlg := LocalMessageDlg;
        if not UsePlugIn then EXIT;
        TransDate := ADate;
        if ConvertDateToPeriod then begin
          result := Period;
          FAutoSetPeriod := false;
          EXIT;
        end;
      finally
        free;
      end;
    end;

{    if not DLLExists then EXIT;

    if LoadDLL = 0 then EXIT;

    if not assigned(FUseUDPeriods) then EXIT;

    if FUseUDPeriods(pchar(FDataPath)) <> 1 then EXIT;

    if not assigned(FGetUDPeriodYear) then EXIT;

    if not FGetUDPeriodYear(FDataPath, ADate, period, year) then begin
      ShowMessage('Specified timesheet date not configured within User-Defined Period Plug-In'#13#10'Please verify Period and Year on transaction in Exchequer');
      EXIT;
    end;
}
    FAutoSetPeriod := false;
  finally
//    result := period
  end;
end;

function TUDPeriod.GetYear(ADate: string; ShowErrorMessage: boolean): integer;
begin
  result            := FGlobalYear;
  FAutoSetPeriod    := FSetTransPeriodByDate;
  FShowErrorMessage := ShowErrorMessage;
  try
    if not FAutoSetPeriod then EXIT;

    if FDataPath = '' then begin
      ShowMessage('Company data path not set for user-defined period plug-in');
      EXIT;
    end;

    with TPeriodCalc.Create(FDataPath) do begin
      try
        EntMessageDlg := LocalMessageDlg;
        if not UsePlugIn then EXIT;
        TransDate := ADate;
        if ConvertDateToPeriod then begin
          result := Year;
          FAutoSetPeriod := false;
          EXIT;
        end;
      finally
        free;
      end;
    end;

//    if not DLLExists then EXIT;

//    if LoadDLL = 0 then EXIT;

//    if not assigned(FUseUDPeriods) then EXIT;

//    if FUseUDPeriods(pchar(FDataPath)) <> 1 then EXIT;

//    if not assigned(FGetUDPeriodYear) then EXIT;

//    if not FGetUDPeriodYear(FDataPath, ADate, period, year) then begin
//      ShowMessage('Specified timesheet date not configured within User-Defined Period Plug-In'#13#10'Please verify Period and Year on transaction in Exchequer');
//      EXIT;
//    end;

    FAutoSetPeriod := false;
  finally
//    result := year;
  end;
end;

{function TUDPeriod.LoadDLL: integer;
begin
  result := 0;
  if not DLLExists then EXIT;
  if FDLL = 0 then
    FDLL := LoadLibrary(pchar(DLLFilename));
  result := FDLL;
  if FDLL = 0 then
    ShowMessage('Cannot load User-Defined Period library'#13#10'"' + SysErrorMessage(GetLastError) + '"')
  else begin
    if not assigned(FGetUDPeriodYear) then
      FGetUDPeriodYear := GetProcAddress(FDLL, 'GetUDPeriodYear');
    if not assigned(FUseUDPeriods) then
      FUseUDPeriods := GetProcAddress(FDLL, 'UseUDPeriods');
  end;
end;}

{function TUDPeriod.UnloadDLL: boolean;
begin
  result := FreeLibrary(FDLL);
end;}

initialization
  FUDPeriod := nil;

finalization
  if FUDPeriod <> nil then begin
//    FUDPeriod.UnloadDLL;
    FUDPeriod.Free;
  end;
end.
