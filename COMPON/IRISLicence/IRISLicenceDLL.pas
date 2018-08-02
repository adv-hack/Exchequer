unit IRISLicenceDLL;

interface

uses SysUtils, Windows, classes;

type
  TShowLicence = function(ALicenceFile: pchar): integer; stdcall;
  TEncryptLicenceFile = function(AnInputFile: pchar; AnOutputFile: pchar): integer; stdcall;
  TDecryptLicenceFile = function(AnInputFile: pchar; AnOutputFile: pchar): integer; stdcall;
  TReadAcceptanceData = function(AnInputFile: pchar): pchar; stdcall;
  TWriteAcceptanceData = function(AnOutputFile: pchar; Data: pchar): integer; stdcall;

  TIRISLicence = class(TObject)
  private
    FDLLPath: ShortString;
    FLicenceDLL: THandle;
    FShowLicence: TShowLicence;
    FEncryptLicenceFile: TEncryptLicenceFile;
    FDecryptLicenceFile: TDecryptLicenceFile;
    FReadAcceptanceData: TReadAcceptanceData;
    FWriteAcceptanceData: TWriteAcceptanceData;
    function ExePath: ShortString;
    function FindProc(AProcName: pchar): integer;
    procedure SetDLLPath(APath: pchar);
  public
    constructor Create(APath: pchar);
    destructor Destroy; override;
    function LoadDLL(APath: pchar): integer;
    function DecryptLicenceFile(AnInputFile: pchar; AnOutputFile: pchar): integer;
    function EncryptLicenceFile(AnInputFile: pchar; AnOutputFile: pchar): integer;
    function ShowLicence(ALicenceFile: pchar): integer;
    function ReadAcceptanceData(AnInputFile: pchar): pchar;
    function WriteAcceptanceData(AnOutputFile: pchar; Data: pchar): integer;
  end;

implementation

{ TIRISLicence }

constructor TIRISLicence.Create(APath: pchar);
begin
  inherited Create;

  SetDLLPath(APath);
end;

function TIRISLicence.DecryptLicenceFile(AnInputFile, AnOutputFile: pchar): integer;
begin
  result := -1;
  FDecryptLicenceFile := TDecryptLicenceFile(FindProc('DecryptLicenceFile'));
  FDecryptLicenceFile(AnInputFile, AnOutputFile);
  result := 0;
end;

destructor TIRISLicence.Destroy;
begin
  if FLicenceDLL <> 0 then
    FreeLibrary(FLicenceDLL);

  inherited Destroy;
end;

function TIRISLicence.EncryptLicenceFile(AnInputFile, AnOutputFile: pchar): integer;
begin
  result := -1;
  FEncryptLicenceFile := TEncryptLicenceFile(FindProc('EncryptLicenceFile'));
  FEncryptLicenceFile(AnInputFile, AnOutputFile);
  result := 0;
end;

function TIRISLicence.ExePath: ShortString;
begin
  result := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
end;

function TIRISLicence.FindProc(AProcName: pchar): integer;
begin
  result := integer(GetProcAddress(FLicenceDLL, AProcName));
end;

function TIRISLicence.LoadDLL(APath: pchar): integer;
begin
  result := 0;
  SetDLLPath(APath);
  FLicenceDLL := LoadLibrary(pchar(FDLLPath + 'ExchLicence.dll'));
  if FLicenceDLL = 0 then
    result := -1
  else
    result := FLicenceDLL;
end;

function TIRISLicence.ReadAcceptanceData(AnInputFile: pchar): pchar;
begin
  result := '';
  FReadAcceptanceData := TReadAcceptanceData(FindProc('ReadAcceptanceData'));
  result := FReadAcceptanceData(AnInputFile);
end;

procedure TIRISLicence.SetDLLPath(APath: pchar);
begin
  if FDLLPath <> '' then EXIT;
  if trim(APath) <> '' then
    FDLLPath := IncludeTrailingBackslash(APath)
  else
    FDLLPath := ExePath;
end;

function TIRISLicence.ShowLicence(ALicenceFile: pchar): integer;
begin
  result := -1;
  FShowLicence := TShowLicence(FindProc('ShowLicence'));

  result := FShowLicence(ALicenceFile);
end;

function TIRISLicence.WriteAcceptanceData(AnOutputFile: pchar; Data: pchar): integer;
begin
  result := -1;
  FWriteAcceptanceData := TWriteAcceptanceData(FindProc('WriteAcceptanceData'));
  result := FWriteAcceptanceData(AnOutputFile, Data);
end;

end.
