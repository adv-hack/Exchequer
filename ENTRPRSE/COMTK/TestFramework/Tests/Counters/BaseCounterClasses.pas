unit BaseCounterClasses;

interface

uses
  EnterpriseBeta_TLB, Enterprise04_TLB;

type
  TRecordCounter = Class
  private
    function GetEndKey: string;
    function GetStartKey: string;
    procedure SetEndKey(const Value: string);
    procedure SetStartKey(const Value: string);
  protected
    FStartKey : string;
    FEndKey : string;
    FDatabaseFunctions : IDataBaseFunctions;
    FRecordCount : Integer;
    FToolkit : IToolkit;
    function Count : Boolean; virtual;
    function IncludeRecord : Boolean; virtual;
  public
    function Execute : Boolean; virtual;
    property RecordCount : Integer read FRecordCount;
    property Toolkit : IToolkit read FToolkit write FToolkit;
    property DatabaseFunctions : IDatabaseFunctions read FDatabaseFunctions write FDatabaseFunctions;

    property StartKey : string read GetStartKey write SetStartKey;
    property EndKey : string read GetEndKey write SetEndKey;
  end;


  TSubObjectCounter = Class
  protected
    FCode : string;
    FCounter : TRecordCounter;
    FRecordCount : Integer;
    FToolkit : IToolkit;
    function GetRecordCount: Integer;
  public
    function Execute : Boolean; virtual; abstract;
    property RecordCount : Integer read GetRecordCount;
    property Toolkit : IToolkit read FToolkit write FToolkit;
    property Code : string read FCode write FCode;
  end;




implementation

{ TRecordCounter }

function TRecordCounter.Count : Boolean;
var
  Res : Integer;
begin
  Try
    FRecordCount := 0;
    Res := FDatabaseFunctions.GetFirst;
    while (Res = 0) do
    begin
      if IncludeRecord then
        inc(FRecordCount);
      Res := FDatabaseFunctions.GetNext;
    end;
    Result := Res in [4, 9];
  Except
    Result := False;
  End;
end;

function TRecordCounter.Execute: Boolean;
begin
  Result := Count;
end;

function TRecordCounter.GetEndKey: string;
begin
  Result := FEndKey;
end;

function TRecordCounter.GetStartKey: string;
begin
  Result := FStartKey;
end;

function TRecordCounter.IncludeRecord : Boolean;
begin
  Result := True;
end;

procedure TRecordCounter.SetEndKey(const Value: string);
begin
  FEndKey := Value;
end;

procedure TRecordCounter.SetStartKey(const Value: string);
begin
  FStartKey := Value;
end;

{ TSubObjectCounter }

function TSubObjectCounter.GetRecordCount: Integer;
begin
  Result := FRecordCount;
end;







end.
