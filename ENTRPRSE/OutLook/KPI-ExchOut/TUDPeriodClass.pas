unit TUDPeriodClass;

interface

uses Windows, SysUtils, dialogs;

type
  TUDPeriod = class(TObject)
  private
    FGlobalPeriod: integer;
    FGlobalYear: integer;
    FDataPath: string;
    FAutoSetPeriod: boolean;
    FSetTransPeriodByDate: boolean;
    function GetUsePlugin(index: string): boolean;
    procedure SetSetTransPeriodByDate(const Value: boolean);
  public
    function GetPeriod(ADate: string; ShowErrorMessage: boolean): integer;
    function GetYear(ADate: string; ShowErrorMessage: boolean): integer;
    property AutoSetPeriod: boolean read FAutoSetPeriod;                // ReadOnly based on whether the UDPeriod plugin returns a pr/yr
    property SetTransPeriodByDate: boolean write SetSetTransPeriodByDate; // from Exchequer System Setup  = WriteOnly
    property DataPath:     string   read FDataPath      write FDataPath;
    property GlobalPeriod: integer  read FGlobalPeriod  write FGlobalPeriod;
    property GlobalYear:   integer  read FGlobalYear    write FGlobalYear;
    property UsePlugin[index: string]: boolean read GetUsePlugin;       // index = datapath
  end;

function UDPeriod(ADataPath: string = ''): TUDPeriod;

implementation

uses PerUtil;

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

    FAutoSetPeriod := false;
  finally
  end;
end;

function TUDPeriod.GetUsePlugin(index: string): boolean;
begin
  FShowErrorMessage := false;
  with TPeriodCalc.Create(index) do begin
    try
      EntMessageDlg := LocalMessageDlg;
      result := UsePlugIn;
    finally
      free;
    end;
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

    FAutoSetPeriod := false;
  finally
  end;
end;

procedure TUDPeriod.SetSetTransPeriodByDate(const Value: boolean);
begin
  FSetTransPeriodByDate := Value;
  FAutoSetPeriod        := Value;
end;

initialization
  FUDPeriod := nil;

finalization
  if FUDPeriod <> nil then
    FUDPeriod.Free;

end.
