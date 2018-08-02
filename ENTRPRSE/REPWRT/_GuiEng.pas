unit GuiEng;

interface

uses
  RepObjCU, MCParser, Classes, RwOpenF, Contnrs, GuiVar;

const

  //Input types
  itDate = 1;
  itPeriod = 2;
  itValue = 3;
  itAscii = 4;
  itCurrency = 5;
  itDocCode = 6;
  itCustCode = 7;
  itSuppCode = 8;
  itGLCode = 9;
  itStockCode = 10;
  itCCCode = 11;
  itDepCode = 12;
  itLocCode = 13;
  itJobCode = 17;
  itBinCode = 18;

type
  TRWFieldObject = Class
  private
    FFieldRec : TGUIFieldRec;
  protected
    function GetVarName : string;
    procedure SetVarName(const Value : string);
    function GetCalcField : Boolean;
    procedure SetCalcField(Value : Boolean);
    function GetCalculation : string;
    procedure SetCalculation(const Value : string);
    function GetDecPlaces : Byte;
    procedure SetDecPlaces(Value : Byte);
    function GetFilter : string;
    procedure SetFilter(const Value : string);
    function GetSortOrder : string;
    procedure SetSortOrder(const Value : string);
    function GetValue : string;
    function GetPeriod : string;
    procedure SetPeriod(Value : string);
    function GetYear : string;
    procedure SetYear(Value : string);
    function GetCurrency : Byte;
    procedure SetCurrency(Value : Byte);
    function GetIndex : Integer;
  public
    constructor Create;
    property VarName : string read GetVarName write SetVarName;
    property CalcField : Boolean read GetCalcField write SetCalcField;
    property DecPlaces : Byte read GetDecPlaces write SetDecPlaces;
    property Filter : string read GetFilter write SetFilter;
    property SortOrder : string read GetSortOrder write SetSortOrder;
    property Period : string read GetPeriod write SetPeriod;
    property Year : string read GetYear write SetYear;
    property Currency : Byte read GetCurrency write SetCurrency;
    property Value : String read GetValue;
    property Calculation : string read GetCalculation write SetCalculation;
    property Index : Integer read GetIndex;
  end;

  TRWInputObject = Class
  private
    FInputRec : TGUIInputRec;
  protected
    function GetInputType : Byte;
    procedure SetInputType(Value : Byte);
    function GetStringRange(Index : Integer) : string;
    procedure SetStringRange(Index : Integer; const Value : string);
    function GetDateRange(Index : Integer) : string;
    procedure SetDateRange(Index : Integer; const Value : string);
    function GetValueRange(Index : Integer) : Double;
    procedure SetValueRange(Index : Integer; const Value : Double);

    function GetIndex : Integer;
  public
    property InputType : Byte read GetInputType write SetInputType;
    property StringFrom : string Index 1 read GetStringRange write SetStringRange;
    property StringTo : string Index 2 read GetStringRange write SetStringRange;

    property ValueFrom : Double Index 1 read GetValueRange write SetValueRange;
    property ValueTo : Double Index 2 read GetValueRange write SetValueRange;

    property DateFrom : string Index 1 read GetDateRange write SetDateRange;
    property DateTo : string Index 2 read GetDateRange write SetDateRange;

  end;

  TReportWriterEngine = Class
  private
    FFirstStageFinished : Boolean;
    FRepObj  : RepCtrlPtr;
    FColList : TObjectList;
    FInputList : TObjectList;
    FRepGen : RepGenRec;
    FFieldCount : Integer;
    FInputCount : Integer;
    FOnCheckRecord : TOnCheckRecordProc;
    FOnSelectionsDone : TNotifyEvent;
    function PutField(var GRec : TGUIFieldRec) : Integer;
    function PutInput(var GRec : TGUIInputRec) : Integer;
    procedure Set_OnCheckRecord(Value : TOnCheckRecordProc);
    procedure SetFileNo(Value : Integer);
    procedure SetIndexNo(Value : Integer);
    procedure GetRecord(ARec : TStrings);
    function GetField(Index : Integer) : TRWFieldObject;
    function GetInput(Index : Integer) : TRWInputObject;
    function GetFieldCount : Integer;
    function GetInputCount : Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function AddField : TRWFieldObject;
    function AddInput : TRWInputObject;
    procedure Execute;
    function GetFirst : Boolean;
    function GetNext : Boolean;
    property OnCheckRecord : TOnCheckRecordProc write Set_OnCheckRecord;
    property FileNo : Integer write SetFileNo;
    property IndexNo : Integer write SetIndexNo;
    property Fields [Index : Integer] : TRWFieldObject read GetField;
    property Inputs [Index : Integer] : TRWInputObject read GetInput;
    property OnSelectionsDone : TNotifyEvent write FOnSelectionsDone;
    property FieldCount : Integer read GetFieldCount;
    property InputCount : Integer read GetInputCount;
  end;


implementation

uses
  SysUtils, RepLine;

const
  DicLen = 8;

function LJVar(const Val : string; Len : Integer) : string;
begin
  Result := Copy(Val + StringOfChar(' ', Len), 1, Len);
end;

Constructor TRWFieldObject.Create;
begin
  inherited Create;
  FillChar(FFieldRec, SizeOf(FFieldRec), #0);
  FFieldRec.FieldLen := 45;
end;

function TRWFieldObject.GetIndex : Integer;
begin
  Result := FFieldRec.FieldNo;
end;

function TRWFieldObject.GetVarName : string;
begin
  Result := FFieldRec.VarRef;
end;

procedure TRWFieldObject.SetVarName(const Value : string);
begin
  FFieldRec.VarRef := LJVar(Value, DicLen);
end;

function TRWFieldObject.GetCalcField : Boolean;
begin
  Result := FFieldRec.CalcField;
end;

procedure TRWFieldObject.SetCalcField(Value : Boolean);
begin
  FFieldRec.CalcField := Value;
end;

function TRWFieldObject.GetDecPlaces : Byte;
begin
  Result := FFieldRec.DecPlaces;
end;

procedure TRWFieldObject.SetDecPlaces(Value : Byte);
begin
  FFieldRec.DecPlaces := Value;
end;

function TRWFieldObject.GetFilter : string;
begin
  Result := FFieldRec.RecSel;
end;

procedure TRWFieldObject.SetFilter(const Value : string);
begin
  FFieldRec.RecSel := Value;
end;

function TRWFieldObject.GetSortOrder : string;
begin
  Result := FFieldRec.SortType;
end;

procedure TRWFieldObject.SetSortOrder(const Value : string);
begin
  if (Length(Value) = 2) and (Value[1] in ['1'..'9']) and (Value[2] in ['A','D']) then
    FFieldRec.SortType := Value
  else
    raise Exception.Create('Invalid sort order ' + QuotedStr(Value));
end;

function TRWFieldObject.GetValue : string;
begin
  Result := FFieldRec.Value;
end;

function TRWFieldObject.GetCalculation : string;
begin
  Result := FFieldRec.Calculation;
end;
procedure TRWFieldObject.SetCalculation(const Value : string);
begin
  FFieldRec.Calculation := Value;
end;

function TRWFieldObject.GetPeriod : string;
begin
  Result := FFieldRec.Period;
end;

procedure TRWFieldObject.SetPeriod(Value : string);
begin
  FFieldRec.Period := Value;
end;

function TRWFieldObject.GetYear : string;
begin
  Result := FFieldRec.Year;
end;

procedure TRWFieldObject.SetYear(Value : string);
begin
  FFieldRec.Year := Value;
end;

function TRWFieldObject.GetCurrency : Byte;
begin
  Result := FFieldRec.Currency;
end;

procedure TRWFieldObject.SetCurrency(Value : Byte);
begin
  FFieldRec.Currency := Value;
end;

//============================Input Object========================================

function TRWInputObject.GetInputType : Byte;
begin
  Result := FInputRec.InputType;
end;

function TRWInputObject.GetIndex : Integer;
begin
  Result := FInputRec.InputNo;
end;

procedure TRWInputObject.SetInputType(Value : Byte);
begin
  FInputRec.InputType := Value;
end;

function TRWInputObject.GetStringRange(Index : Integer) : string;
begin
  Result := FInputRec.AscStr[Index];
end;

procedure TRWInputObject.SetStringRange(Index : Integer; const Value : string);
begin
  FInputRec.AscStr[Index] := Value;
end;

function TRWInputObject.GetDateRange(Index : Integer) : string;
begin
  Result := FInputRec.DRange[Index];
end;

procedure TRWInputObject.SetDateRange(Index : Integer; const Value : string);
begin
  FInputRec.DRange[Index] := Value;
end;

function TRWInputObject.GetValueRange(Index : Integer) : Double;
begin
  Result := FInputRec.VRange[Index];
end;

procedure TRWInputObject.SetValueRange(Index : Integer; const Value : Double);
begin
  FInputRec.VRange[Index] := Value;
end;

//============================Report Engine========================================
constructor TReportWriterEngine.Create;
begin
  inherited Create;

  FColList := TObjectList.Create;
  FInputList := TObjectList.Create;

  FFieldCount := 0;
  FInputCount := 0;

  FFirstStageFinished := False;

  FRepObj := nil;

end;

destructor TReportWriterEngine.Destroy;
var
  i : integer;
begin
{  for i := 0 to FColList.Count - 1 do
    FColList.Items[i].Free;}

  FColList.Free;
  FInputList.Free;

  if Assigned(FRepObj) then
    Dispose(FRepObj);
end;

function TReportWriterEngine.AddField : TRWFieldObject;
begin
  Result := TRWFieldObject.Create;
  Result.FFieldRec.FieldNo := FColList.Count + 1;
  FColList.Add(Result);
end;

function TReportWriterEngine.AddInput : TRWInputObject;
begin
  Result := TRWInputObject.Create;
  Result.FInputRec.InputNo := FInputList.Count + 1;
  FInputList.Add(Result);
end;


procedure TReportWriterEngine.Execute;
begin
  if Assigned(FRepObj) then
    Dispose(FRepObj);
  New(FRepObj, Create(Self, FRepGen, PutField, PutInput));
  FRepObj.OnSelectRecord := GetRecord;
  FRepObj.OnCheckRecord := FOnCheckRecord;
  FRepObj.Process_Report;
  if Assigned(FOnSelectionsDone) then
    FOnSelectionsDone(Self);
end;

function TReportWriterEngine.PutField(var GRec : TGUIFieldRec) : Integer;
begin
  if FFieldCount <= FColList.Count - 1 then
  begin
    GRec := TRWFieldObject(FColList.Items[FFieldCount]).FFieldRec;
    inc(FFieldCount);
    Result := 0;
  end
  else
  begin
    FFieldCount := 0; //ready for next call
    Result := 9;
  end;
end;

function TReportWriterEngine.PutInput(var GRec : TGUIInputRec) : Integer;
begin
  if FInputCount <= FInputList.Count - 1 then
  begin
    GRec := TRWInputObject(FInputList.Items[FInputCount]).FInputRec;
    inc(FInputCount);
    Result := 0;
  end
  else
  begin
    FInputCount := 0; //ready for next call
    Result := 9;
  end;
end;


procedure TReportWriterEngine.Set_OnCheckRecord(Value : TOnCheckRecordProc);
begin
  FOnCheckRecord := Value;
end;

procedure TReportWriterEngine.SetFileNo(Value : Integer);
begin
  FRepGen.ReportHed.DriveFile := Value;
end;

procedure TReportWriterEngine.SetIndexNo(Value : Integer);
begin
  FRepGen.ReportHed.DrivePath := Value;
end;

function TReportWriterEngine.GetField(Index : Integer) : TRWFieldObject;
begin
  if (Index >= 0) and (Index < FColList.Count) then
    Result := TRWFieldObject(FColList[Index])
  else
    raise ERangeError.Create('Index out of range (' + IntToStr(Index) + ')');
end;

function TReportWriterEngine.GetInput(Index : Integer) : TRWInputObject;
begin
  if (Index >= 0) and (Index < FInputList.Count) then
    Result := TRWInputObject(FInputList[Index])
  else
    raise ERangeError.Create('Index out of range (' + IntToStr(Index) + ')');
end;


function TReportWriterEngine.GetFirst : Boolean;
begin
  Result := FRepObj.GetFirst;
end;

function TReportWriterEngine.GetNext : Boolean;
begin
  Result := FRepObj.GetNext;
end;

procedure TReportWriterEngine.GetRecord(ARec : TStrings);
var
  i : integer;
begin
  for i := 0 to ARec.Count - 1 do
    TRWFieldObject(FColList[i]).FFieldRec.Value := Trim(ARec[i]);
end;

function TReportWriterEngine.GetFieldCount : Integer;
begin
  Result := FColList.Count;
end;

function TReportWriterEngine.GetInputCount : Integer;
begin
  Result := FInputList.Count;
end;





end.
