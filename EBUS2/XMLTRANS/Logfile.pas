unit Logfile;

interface

uses
  ComObj, ActiveX;

type
  TLogAutoIntf = Class(TAutoIntFObject)
  private
    FID : longint;
  public
    constructor Create(const TypeLib: ITypeLib; const DispIntf: TGUID);
    destructor Destroy; override;
  end;

procedure LogIt(const s : string);
procedure InitLogFile;

var
  LogFileOn : Boolean;

implementation

uses
  Windows, SysUtils, Forms;

var
  F : TextFile;
  ObjectsCreated : longint;

function MemFreeString : String;
var
  M : MemoryStatus;
  V : Double;
begin
  FillChar(M, SizeOF(M), #0);
  M.dwLength := SizeOf(M);
  GlobalMemoryStatus(M);
  V := (M.dwAvailVirtual div 1024);
  Result := Format('Available virtual memory: %9.0nkb', [V]);
end;


procedure InitLogFile;
begin
  AssignFile(F, ExtractFilePath(Application.ExeName) +
                  'xmllog' + FormatDateTime('hhnnss', Time) + '.txt');
  Rewrite(F);
  WriteLn(F, 'XML Writer Log');
  WriteLn(F, '=========================');
  WriteLn(F, '   ');
  CloseFile(F);

end;

procedure LogIt(const s : string);
begin
  if LogFileOn then
  begin
    Append(F);
    WriteLn(F, s + ' ' + MemFreeString);
    CloseFile(F);
  end;
end;

{ TLogAutoIntf }

constructor TLogAutoIntf.Create(const TypeLib: ITypeLib;
  const DispIntf: TGUID);
begin
  inherited Create(TypeLib, DispIntf);
  Inc(ObjectsCreated);
  FID := ObjectsCreated;
  LogIt('Object created: ' + ClassName + ' ' + IntToStr(FID));
end;

destructor TLogAutoIntf.Destroy;
begin
  LogIt('Object destroyed: ' + ClassName + ' ' + IntToStr(FID));

  Dec(ObjectsCreated);
  inherited;
end;

Initialization
  ObjectsCreated := 0;
Finalization
  LogIt(' ');
  LogIt('Objects created and not destroyed: ' + IntToStr(ObjectsCreated));
end.
