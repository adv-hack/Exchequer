unit TKTTDCalc;

interface

uses
  TTDCalc, VarConst;

type
  TGetLineFunc = function(WhichLine : Integer; Var LID : IDetail) : Boolean;

  TToolkitTTDCalculator = Class(TTTDCalculator)
  private
    FCount : Integer;
    FGetLine : TGetLineFunc;
    procedure SetGetLine(const Value: TGetLineFunc);
  Protected
    // Load the transaction lines into cache to work with
    Procedure LoadLines; override;
  public
    property GetLine : TGetLineFunc read FGetLine write SetGetLine;
    property Count : Integer read FCount write FCount;
  end;


implementation

{ TToolkitTTDCalculator }


procedure TToolkitTTDCalculator.LoadLines;
var
  i : integer;
  pLID : ^IDetail;
begin
  for i := 1 to FCount do
    if Assigned(FGetLine) then
    begin
      New(pLID);
      FillChar(pLID^, SizeOf(pLID^), 0);
      if FGetLine(i, pLID^) then
        CacheLine(pLID^)
      else
        Dispose(pLID);
    end;
end;

procedure TToolkitTTDCalculator.SetGetLine(const Value: TGetLineFunc);
begin
  FGetLine := Value;
  if Assigned(FGetLine) then
    LoadLines;
end;

end.
 