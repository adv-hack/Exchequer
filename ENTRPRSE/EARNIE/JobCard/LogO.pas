unit LogO;

interface

uses
  Classes;

type
  TJCLog = Class
  private
    FFile : TextFile;
    FFileName : string;
  public
    procedure Logit(const s : string);
    function Open(RunID : string; IsImport : Boolean = False) : integer;
    destructor Destroy; override;
    property Filename : string read FFilename write FFilename;
  end;

var
  TheLog : TJCLog;

implementation

uses
  SysUtils, JcVar;

procedure TJCLog.Logit(const s : string);
begin
  WriteLn(FFile, {FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) +} '>' + s);
end;

function TJCLog.Open(RunID : string; IsImport : Boolean = False) : integer;
begin
  Result := -1;
  AssignFile(FFile, FFileName);
  Rewrite(FFile);
  Result := 0;
//  if RunID <> '' then
  begin
    if not IsImport then
      WriteLn(FFile, ExportString + ' - Error log')
    else
      WriteLn(FFile, ImportString + ' - Error log');
    WriteLn(FFile, '======================================');
    WriteLn(FFile, ' ');
    WriteLn(FFile, 'Company/Payroll ID: ' + RunID);
    WriteLn(FFile, ' ');
    WriteLn(FFile, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
    WriteLn(FFile, '======================================');
    WriteLn(FFile, ' ');
  end;
end;

destructor TJCLog.Destroy;
begin
  CloseFile(FFile);
  inherited;
end;


end.
