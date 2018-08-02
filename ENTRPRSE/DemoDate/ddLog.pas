unit ddLog;

interface

type

  TLogFile = Class
  private
    FFile : TextFile;
    FHasEntries : Boolean;
    FFileName : string;
  public
    constructor Create(const FileName : string);
    destructor Destroy; override;
    procedure Add(const s : string);
    property HasEntries : Boolean read FHasEntries;
    property Filename : string read FFilename;
  end;


implementation

{ TLogFile }

procedure TLogFile.Add(const s: string);
begin
  WriteLn(FFile, s);
  FHasEntries := True;
end;

constructor TLogFile.Create(const FileName: string);
begin
  inherited Create;
  FHasEntries := False;
  AssignFile(FFile, Filename);
  Rewrite(FFile);
  FFilename := Filename;
end;

destructor TLogFile.Destroy;
begin
  CloseFile(FFile);
  inherited;
end;

end.
