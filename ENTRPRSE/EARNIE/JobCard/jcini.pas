unit jcini;

interface

uses
  IniFiles, FileUtil;

type
  TJCIniObject = Class
  private
    FFile : TIniFile;
  protected
    function GetString(Index : Integer) : string;
    procedure SetString(Index : Integer; Value : string);
    function GetBool(Index : Integer) : Boolean;
    procedure SetBool(Index : Integer; Value : Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    property EntDir : string Index 0 read GetString write SetString;
    property PayDir : string Index 1 read GetString write SetString;
    property LogDir : string Index 2 read GetString write SetString;
    property LogFileName : string Index 3 read GetString;
    property LastTimeSheet : string Index 4 read GetString write SetString;
    property LineTypeFromAnalysisType : Boolean index 0 read GetBool write SetBool;
    property OverwritePayments : Boolean index 1 read GetBool write SetBool;
  end;

var
  TheIni : TJCIniObject;

implementation

uses
  JcFuncs, SysUtils;

function NextTSH(const s : string) : string;
var
  i :  longint;
begin
  Try
    i := StrToInt(Copy(s, 4, 6));
    inc(i);
    Result := IntToStr(i);
  Except
    Result := '';
  End;

  while Length(Result) < 6 do
    Result := '0' + Result;

  Result := 'TSH' + Result;

end;


constructor TJCIniObject.Create;
begin
  inherited;
  FFile := TIniFile.Create(GetEnterpriseDirectory + 'JC\Dir.ini');
end;

destructor TJCIniObject.Destroy;
begin
  FFile.Free;
  inherited Destroy;
end;

function TJCIniObject.GetBool(Index: Integer): Boolean;
begin
  Case Index of
    0  : Result := FFile.ReadBool('Settings', 'LineTypeFromAnalysisType', True);
    1  : Result := FFile.ReadBool('Settings', 'OverWritePayments', True);
  end;
end;

function TJCIniObject.GetString(Index : Integer) : string;
var
  i : integer;
begin
  Case Index of
    0  : Result := FFile.ReadString('Directory', 'Enterprise', '');
    1  : Result := FFile.ReadString('Directory', 'Payroll', '');
    2  : Result := FFile.ReadString('Directory', 'Logs', '');
    3  : begin //log filename
           i := FFile.ReadInteger('Settings','LogFileNo', 0);
           FFile.WriteInteger('Settings','LogFileNo', i + 1);
           Result := 'Exp' + ZerosAtFront(i, 5) + '.log';
         end;
    4  : Result := FFile.ReadString('Settings', 'LastTimeSheet', 'TSH000001');
  end;
end;

procedure TJCIniObject.SetBool(Index: Integer; Value: Boolean);
begin
  Case Index of
    0 : FFile.WriteBool('Settings', 'LineTypeFromAnalysisType', Value);
    1 : FFile.WriteBool('Settings', 'OverwritePayments', Value);
  end;

end;

procedure TJCIniObject.SetString(Index : Integer; Value : string);
begin
  Case Index of
    0  : FFile.WriteString('Directory', 'Enterprise', Value);
    1  : FFile.WriteString('Directory', 'Payroll', Value);
    2  : FFile.WriteString('Directory', 'Logs', Value);
    4  : FFile.WriteString('Settings', 'LastTimeSheet', NextTSH(Value));
  end;

end;




end.
