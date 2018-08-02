unit GLBudgetHistoryClass;

interface

uses
  BudgetHistoryVar, GlobVar;

type
  TGLBudgetHistory = Class
  private
    FBudgetHistory : TBudgetHistoryRec;
    function GetbhChange: Double;
    function GetbhDateChanged: string;
    function GetbhGLCode: longint;
    function GetbhPeriod: Byte;
    function GetbhTimeChanged: string;
    function GetbhUser: string;
    function GetbhValue: Double;
    function GetbhYear: Byte;
    procedure SetbhChange(const Value: Double);
    procedure SetbhGLCode(const Value: longint);
    procedure SetbhPeriod(const Value: Byte);
    procedure SetbhValue(const Value: Double);
    procedure SetbhYear(const Value: Byte);
    function GetbhCurrency: Byte;
    procedure SetbhCurrency(const Value: Byte);
  public
    constructor Create;
    function FindRec(Op : Integer; var sKey : Str255) : Integer;
    function Save : integer;
    function Clone : TGLBudgetHistory;
    property bhGLCode       : longint read GetbhGLCode write SetbhGLCode;
    property bhYear         : Byte read GetbhYear write SetbhYear;
    property bhPeriod       : Byte read GetbhPeriod write SetbhPeriod;
    property bhCurrency     : Byte read GetbhCurrency write SetbhCurrency;
    property bhDateChanged  : string read GetbhDateChanged;
    property bhTimeChanged  : string read GetbhTimeChanged;
    property bhValue        : Double  read GetbhValue write SetbhValue;
    property bhChange       : Double read GetbhChange write SetbhChange;
    property bhUser         : string read GetbhUser;
  end;


implementation

uses
  VarConst, BtrvU2, SysUtils, Dialogs;

{ TGLBudgetHistory }


function TGLBudgetHistory.Clone: TGLBudgetHistory;
begin
  Result := TGLBudgetHistory.Create;
  Result.FBudgetHistory := FBudgetHistory;
end;

constructor TGLBudgetHistory.Create;
begin
  FBudgetHistory.bhDateChanged := FormatDateTime('yyyymmdd', Date);
  FBudgetHistory.bhTimeChanged := FormatDateTime('hhnnss', Time);
  FBudgetHistory.bhUser        := UserProfile^.UserName;
end;

function TGLBudgetHistory.FindRec(Op: Integer; var sKey: Str255): Integer;
begin
  Result := Find_Rec(Op, F[BudgetHistoryF], BudgetHistoryF, FBudgetHistory, 0, sKey);
end;

function TGLBudgetHistory.GetbhChange: Double;
begin
  Result := FBudgetHistory.bhChange;
end;

function TGLBudgetHistory.GetbhCurrency: Byte;
begin
  Result := FBudgetHistory.bhCurrency;
end;

function TGLBudgetHistory.GetbhDateChanged: string;
begin
  Result := FBudgetHistory.bhDateChanged;
end;

function TGLBudgetHistory.GetbhGLCode: longint;
begin
  Result := FBudgetHistory.bhGLCode;
end;

function TGLBudgetHistory.GetbhPeriod: Byte;
begin
  Result := FBudgetHistory.bhPeriod;
end;

function TGLBudgetHistory.GetbhTimeChanged: string;
begin
  Result := FBudgetHistory.bhTimeChanged;
end;

function TGLBudgetHistory.GetbhUser: string;
begin
  Result := FBudgetHistory.bhUser;
end;

function TGLBudgetHistory.GetbhValue: Double;
begin
  Result := FBudgetHistory.bhValue;
end;

function TGLBudgetHistory.GetbhYear: Byte;
begin
  Result := FBudgetHistory.bhYear;
end;

function TGLBudgetHistory.Save: integer;
begin
  Result := Add_Rec(F[BudgetHistoryF], BudgetHistoryF, FBudgetHistory, bhGLCodeK);
end;

procedure TGLBudgetHistory.SetbhChange(const Value: Double);
begin
  FBudgetHistory.bhChange := Value;
end;

procedure TGLBudgetHistory.SetbhCurrency(const Value: Byte);
begin
  FBudgetHistory.bhCurrency := Value;
end;

procedure TGLBudgetHistory.SetbhGLCode(const Value: longint);
begin
  FBudgetHistory.bhGLCode := Value;
end;

procedure TGLBudgetHistory.SetbhPeriod(const Value: Byte);
begin
  FBudgetHistory.bhPeriod := Value;
end;

procedure TGLBudgetHistory.SetbhValue(const Value: Double);
begin
  FBudgetHistory.bhValue := Value;
end;

procedure TGLBudgetHistory.SetbhYear(const Value: Byte);
begin
  FBudgetHistory.bhYear := Value;
end;

end.
