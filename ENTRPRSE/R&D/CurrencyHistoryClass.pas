unit CurrencyHistoryClass;

interface

uses
  CurrencyHistoryVar, VarConst, VarRec2U, GlobVar;

type

  //Class for accessing new currency history table.
  TCurrencyHistory = Class
  private
    FDataRec : TCurrencyHistoryRec;
    FClientId : Pointer;
    FIndex : Integer;
    function GetClientId: Pointer;
    function GetCompanyRate: Double;
    function GetCurrNumber: SmallInt;
    function GetDailyRate: Double;
    function GetDateChanged: string;
    function GetDescription: string;
    function GetFloat: Boolean;
    function GetInvert: Boolean;
    function GetSymbolPrint: string;
    function GetSymbolScreen: string;
    function GetTimeChanged: string;
    function GetTriangulationNumber: Smallint;
    function GetTriangulationRate: Double;
    function GetUser: string;
    procedure SetClientId(const Value: Pointer);
    procedure SetCompanyRate(const Value: Double);
    procedure SetCurrNumber(const Value: SmallInt);
    procedure SetDailyRate(const Value: Double);
    procedure SetDescription(const Value: string);
    procedure SetFloat(const Value: Boolean);
    procedure SetInvert(const Value: Boolean);
    procedure SetSymbolPrint(const Value: string);
    procedure SetSymbolScreen(const Value: string);
    procedure SetTriangulationNumber(const Value: Smallint);
    procedure SetTriangulationRate(const Value: Double);
    function GetIndex: Integer;
    procedure SetIndex(const Value: Integer);
    function TranslateCurrencySymbol(const s : string) : string;
  public
   property chDateChanged  : string read GetDateChanged;
   property chTimeChanged  : string read GetTimeChanged;
   property chCurrNumber   : SmallInt read GetCurrNumber write SetCurrNumber;
   property chDailyRate    : Double read GetDailyRate write SetDailyRate;
   property chCompanyRate  : Double read GetCompanyRate write SetCompanyRate;
   property chInvert       : Boolean read GetInvert write SetInvert;
   property chFloat        : Boolean read GetFloat write SetFloat;
   property chTriangulationNumber : Smallint read GetTriangulationNumber write SetTriangulationNumber;
   property chTriangulationRate : Double read GetTriangulationRate write SetTriangulationRate;
   property chDescription  : string read GetDescription write SetDescription;
   property chSymbolScreen : string read GetSymbolScreen write SetSymbolScreen;
   property chSymbolPrint  : string read GetSymbolPrint write SetSymbolPrint;
   property chUser         : string read GetUser;

   property ClientId : Pointer read GetClientId write SetClientId;
   property Index : Integer read GetIndex write SetIndex;

   constructor Create;
   function FindRec(Op : Integer; var sKey : Str255) : Integer;
   function Save : integer;
   function Clone : TCurrencyHistory;
   procedure SetDataRec(const CRec : CurrType; const GhostRec : GCurType; Index : Integer);
   procedure ExportCurrencyHistory(const Filename : string; StartKey : string = '');
  end;

implementation

uses
  BtrvU2, SysUtils, Dialogs, EtDateU, StrUtil;


{ TCurrencyHistory }

function TCurrencyHistory.Clone: TCurrencyHistory;
begin
  Result := TCurrencyHistory.Create;
  Result.FDataRec := FDataRec;
end;

constructor TCurrencyHistory.Create;
begin
  inherited;
  FClientId := nil;
  FIndex := 0;

  FillChar(FDataRec, SizeOf(FDataRec), 0);
end;

procedure TCurrencyHistory.ExportCurrencyHistory(const Filename : string; StartKey : string = '');
var
  F : TextFile;
  Res : Integer;
  sKey : Str255;

  procedure WriteHeaderLine;
  begin
    WriteLn(F, 'CurrencyNumber,Date,Time,Screen Symbol,PrintSymbol,Daily Rate,Company Rate,Invert,Float,Triangulation,Rate');
  end;

  procedure WriteDetailLine;
  begin
    WriteLn(F, Format('%d,%s,%s,%s,%s,%8.6f,%8.6f,%s,%s,%d,%8.6f',  [chCurrNumber,
                                                                     POutDate(chDateChanged), //EtDateU.pas
                                                                     Str6ToScreenTime(chTimeChanged), //StrUtils.pas
                                                                     chSymbolScreen,
                                                                     chSymbolPrint,
                                                                     chDailyRate,
                                                                     chCompanyRate,
                                                                     BoolToStr(chInvert, True),
                                                                     BoolToStr(chFloat, True),
                                                                     chTriangulationNumber,
                                                                     chTriangulationRate]));
  end;

  function KeepGoing : Boolean;
  begin
    Result := (StartKey = '') or (Copy(sKey, 1, 2) = StartKey);
  end;

begin
  AssignFile(F, Filename);
  Rewrite(F);
  Try
    sKey := StartKey;
    WriteHeaderLine;
    Res := FindRec(B_GetGEq, sKey);
    while (Res = 0) and KeepGoing do
    begin
      WriteDetailLine;

      Res := FindRec(B_GetNext, sKey);
    end;
  Finally
    CloseFile(F);
  End;
end;

function TCurrencyHistory.FindRec(Op: Integer; var sKey: Str255): Integer;
begin
  Result := Find_RecCID(Op, F[CurrencyHistoryF], CurrencyHistoryF, FDataRec, FIndex, sKey, FClientId);
end;

function TCurrencyHistory.GetClientId: Pointer;
begin
  Result := FClientId;
end;

function TCurrencyHistory.GetCompanyRate: Double;
begin
  Result := FDataRec.chCompanyRate;
end;

function TCurrencyHistory.GetCurrNumber: SmallInt;
begin
  Result := FDataRec.chCurrNumber;
end;

function TCurrencyHistory.GetDailyRate: Double;
begin
  Result := FDataRec.chDailyRate;
end;

function TCurrencyHistory.GetDateChanged: string;
begin
  Result := FDataRec.chDateChanged;
end;

function TCurrencyHistory.GetDescription: string;
begin
  Result := FDataRec.chDescription;
end;

function TCurrencyHistory.GetFloat: Boolean;
begin
  Result := FDataRec.chFloat;
end;

function TCurrencyHistory.GetIndex: Integer;
begin
  Result := FIndex;
end;

function TCurrencyHistory.GetInvert: Boolean;
begin
  Result := FDataRec.chInvert;
end;

function TCurrencyHistory.GetSymbolPrint: string;
begin
  Result := FDataRec.chSymbolPrint;
end;

function TCurrencyHistory.GetSymbolScreen: string;
begin
  Result := FDataRec.chSymbolScreen;
end;

function TCurrencyHistory.GetTimeChanged: string;
begin
  Result := FDataRec.chTimeChanged;
end;

function TCurrencyHistory.GetTriangulationNumber: Smallint;
begin
  Result := FDataRec.chTriangulationNumber;
end;

function TCurrencyHistory.GetTriangulationRate: Double;
begin
  Result := FDataRec.chTriangulationRate;
end;

function TCurrencyHistory.GetUser : string;
begin
  Result := FDataRec.chUser;
end;

function TCurrencyHistory.Save: integer;
begin
  //Set standard fields.
  FDataRec.chStopKey := '!';
  FDataRec.chDateChanged := FormatDateTime('yyyymmdd', Date);
  FDataRec.chTimeChanged := FormatDateTime('hhnnss', Time);
  {$IFDEF GUP}
  //If we're upgrading then we don't have a user
  FDataRec.chUser := 'Upgrade';
  {$ELSE}
    {$IFNDEF EXDLL}
      FDataRec.chUser := UserProfile^.UserName;
     {$ELSE}
      FDataRec.chUser := 'Toolkit'; //no user in toolkit
     {$ENDIF}
  {$ENDIF}

  Result := Add_RecCID(F[CurrencyHistoryF], CurrencyHistoryF, FDataRec, 0, FClientId);
end;

procedure TCurrencyHistory.SetClientId(const Value: Pointer);
begin
  FClientId := Value;
end;

procedure TCurrencyHistory.SetCompanyRate(const Value: Double);
begin
  FDataRec.chCompanyRate := Value;
end;

procedure TCurrencyHistory.SetCurrNumber(const Value: SmallInt);
begin
  FDataRec.chCurrNumber := Value;
end;

procedure TCurrencyHistory.SetDailyRate(const Value: Double);
begin
  FDataRec.chDailyRate := Value;
end;

procedure TCurrencyHistory.SetDataRec(const CRec: CurrType;
  const GhostRec: GCurType; Index: Integer);
begin
   FillChar(FDataRec, SizeOf(FDataRec), 0);
   chCurrNumber   := Index;
   chDailyRate    := CRec[Index].CRates[True];
   chCompanyRate  := CRec[Index].CRates[False];
   chDescription  := CRec[Index].Desc;
   chSymbolScreen := CRec[Index].SSymb;
   chSymbolPrint  := CRec[Index].PSymb;

   chInvert       := GhostRec.TriInvert[Index];
   chFloat        := GhostRec.TriFloat[Index];
   chTriangulationNumber := GhostRec.TriEuro[Index];
   chTriangulationRate := GhostRec.TriRates[Index];
end;

procedure TCurrencyHistory.SetDescription(const Value: string);
begin
  FDataRec.chDescription := Value;
end;

procedure TCurrencyHistory.SetFloat(const Value: Boolean);
begin
  FDataRec.chFloat := Value;
end;

procedure TCurrencyHistory.SetIndex(const Value: Integer);
begin
  FIndex := Value;
end;

procedure TCurrencyHistory.SetInvert(const Value: Boolean);
begin
  FDataRec.chInvert := Value;
end;

procedure TCurrencyHistory.SetSymbolPrint(const Value: string);
begin
  FDataRec.chSymbolPrint := TranslateCurrencySymbol(Value);
end;

procedure TCurrencyHistory.SetSymbolScreen(const Value: string);
begin
  FDataRec.chSymbolScreen := TranslateCurrencySymbol(Value);
end;

procedure TCurrencyHistory.SetTriangulationNumber(const Value: Smallint);
begin
  FDataRec.chTriangulationNumber := Value;
end;

procedure TCurrencyHistory.SetTriangulationRate(const Value: Double);
begin
  FDataRec.chTriangulationRate := Value;
end;


function TCurrencyHistory.TranslateCurrencySymbol(const s: string): string;
var
  i : integer;
begin
  Result := s;
  i := Pos(#156, Result);
  while i <> 0 do
  begin
    Result[i] := '£';

    i := Pos(#156, Result);
  end;
end;

end.
