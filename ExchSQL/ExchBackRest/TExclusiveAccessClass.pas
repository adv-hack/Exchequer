unit TExclusiveAccessClass;

interface

uses Classes, Controls, TLoggerClass, Enterprise01_TLB, CTKUtil, SQLUtils, dialogs, SysUtils;

type
  TErrorType = (etLogIt, etIgnore, etShowIt);

  TExclusiveAccess = class(TObject)
  private
    FToolkit: IToolkit;
    FFirstError: boolean;
    FErrorLines: TStringList;
    function COMToolkit: IToolkit;
    procedure ErrorCo(CoCode: string; CoName: string);
  public
    constructor Create;
    destructor Destroy;
    function HaveI(CoCode: string): boolean;
    procedure ReportErrors(ErrorType: TErrorType);

    {
      ReportErrorsWithOverride should only be used when the backup is run
      manually. It includes a 'Continue anyway?' option, and returns True if
      the user selects this option.
    }
    function ReportErrorsWithOverride: Boolean;
  end;


function ExclusiveAccess: TExclusiveAccess;

implementation

var
  FExclusiveAccess: TExclusiveAccess;

function ExclusiveAccess: TExclusiveAccess;
begin
  if FExclusiveAccess = nil then
    FExclusiveAccess := TExclusiveAccess.Create;

  result := FExclusiveAccess;
end;

{ TExclusiveAccess }

function TExclusiveAccess.COMToolkit: IToolkit;
begin
  if FToolkit = nil then
    FToolkit := CreateToolkitWithBackdoor;

  result := FToolkit;
end;

constructor TExclusiveAccess.Create;
begin
  inherited;

  FFirstError := true;
  FErrorLines := TStringList.Create;
end;

destructor TExclusiveAccess.Destroy;
begin                                                                                 
  if FErrorLines <> nil then
    FErrorLines.Free;

  inherited;
end;

procedure TExclusiveAccess.ErrorCo(CoCode, CoName: string);
begin
  if FFirstError then begin
    FErrorLines.Add('The following companies are in use:');
    FFirstError := false;
  end;

  FErrorLines.Add(format('     %-10s%s', [CoCode + ':', CoName]));
end;

function TExclusiveAccess.HaveI(CoCode: string): boolean;
var
  i: integer;
begin
  result := true;
  FErrorLines.Clear;
  FFirstError := true;

  with ComToolkit.Company do begin
    for i := 1 to cmCount do begin
      if not SQLUtils.ExclusiveAccess(cmCompany[i].coPath) then begin
        ErrorCo(cmCompany[i].coCode, cmCompany[i].coName);
        if UpperCase(trim(cmCompany[i].coCode)) = UpperCase(trim(CoCode)) then
          result := false; // list all the companies in use but only fail if the required one is one of them.
      end;
    end;
  end;

end;

procedure TExclusiveAccess.ReportErrors(ErrorType: TErrorType);
var
  i: integer;
  ErrorMsg: string;
begin
  case ErrorType of
    etLogIt:  for i := 0 to FErrorLines.Count - 1 do
                Logger.LogLine(FErrorLines[i]);
    etIgnore: begin
                for i := 0 to FErrorLines.Count - 1 do
                  Logger.LogLine(FErrorLines[i]);
                Logger.LogLine('Continuing anyway (override requested).');
              end;
    etShowIt: begin
                ErrorMsg := 'Database Backups and Restores cannot be performed against'#13#10;
                ErrorMsg := ErrorMsg + 'companies which are in use.'#13#10#13#10;
                for i := 0 to FErrorLines.Count - 1 do
                  ErrorMsg := ErrorMsg + FErrorLines[i] + #13#10;
                ShowMessage(ErrorMsg);
              end;
  end;
end;

function TExclusiveAccess.ReportErrorsWithOverride: Boolean;
var
 i: Integer;
 ErrorMsg: string;
begin
  ErrorMsg := 'Database Backups against companies which are in use might fail ' +
              'or omit data. ' +
              #13#10#13#10;
  for i := 0 to FErrorLines.Count - 1 do
  begin
    ErrorMsg := ErrorMsg + FErrorLines[i] + #13#10;
  end;
  ErrorMsg := ErrorMsg + #13#10 + 'Continue anyway?';
  Result := MessageDlg(ErrorMsg, mtError, [mbYes, mbNo], 0) = mrYes;
end;

initialization
  FExclusiveAccess := nil;

finalization
  if FExclusiveAccess <> nil then
    FExclusiveAccess.Free;

end.
