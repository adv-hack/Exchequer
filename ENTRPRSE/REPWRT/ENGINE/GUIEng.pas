unit GuiEng;

interface

uses
  RepObjCU, MCParser, Classes, VarConst, RwOpenF, Contnrs, GuiVar, GlobType;

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

  SPC = '<SPACE>';

type

  TRWDrillDownInfo = Class
  private
    FLevelNo,
    FMode : Byte;
    FKeyString : ShortString;
    FFileNo, FIndexNo : SmallInt;
  public
    constructor Create;
    procedure Assign(const Info : TRWDrillDownInfo);
    property LevelNo : Byte read FLevelNo write FLevelNo;
    property Mode : Byte read FMode write FMode;
    property KeyString : ShortString read FKeyString write FKeyString;
    property FileNo : SmallInt read FFileNo write FFileNo;
    property IndexNo : SmallInt read FIndexNo write FIndexNo;
  end;

  TRWFieldObject = Class
  private
    FFieldRec : TGUIFieldRec;
    FCalc, FFilter, FPrintFilter : String;
    FDriveFile : SmallInt;
    FDrillDown : TRWDrillDownInfo;
    FPrint : Boolean;
    FPosition : Integer;
    function DoSpaces(const s : string) : string;
    function GetPeriodField: Boolean;
    procedure SetPeriodField(const Value: Boolean);
    function GetRangeFilter: string;
    procedure SetRangeFilter(const Value: string);
    function GetDataType: Byte;
    function GetPrintSelect: String;
  protected
    function GetVarName : string;
    procedure SetVarName(const Value : string);
    function GetName : string;
    procedure SetName(const Value : string);
    function GetCalcField : Boolean;
    procedure SetCalcField(Value : Boolean);
    function GetCalculation : string;
    procedure SetCalculation(const Value : string);
    function GetDecPlaces : Byte;
    procedure SetDecPlaces(Value : Byte);
    function GetFilter : string;
    procedure SetFilter(const Value : string);
    function GetPrintFilter : string;
    procedure SetPrintFilter(const Value : string);
    function GetSortOrder : string;
    procedure SetSortOrder(const Value : string);
    function GetValue : string;
    procedure SetValue(const Value : string);
    function GetPeriod : string;
    procedure SetPeriod(Value : string);
    function GetYear : string;
    procedure SetYear(Value : string);
    function GetCurrency : Byte;
    procedure SetCurrency(Value : Byte);
    function GetIndex : Integer;
    procedure SetIndex (Value : Integer);
    function GetDrillDownInfo : TRWDrillDownInfo;
    function GetInputLink : Integer;
    procedure SetInputLink(Value : Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Reset;
    property VarName : string read GetVarName write SetVarName;
    property CalcField : Boolean read GetCalcField write SetCalcField;
    property DecPlaces : Byte read GetDecPlaces write SetDecPlaces;
    property Filter : string read GetFilter write SetFilter;
    property PrintFilter : string read GetPrintFilter write SetPrintFilter;
    property SortOrder : string read GetSortOrder write SetSortOrder;
    property Period : string read GetPeriod write SetPeriod;
    property Year : string read GetYear write SetYear;
    property Currency : Byte read GetCurrency write SetCurrency;
    property Value : String read GetValue write SetValue;
    property Calculation : string read GetCalculation write SetCalculation;
    property Index : Integer read GetIndex write SetIndex;
    property DriveFile : SmallInt read FDriveFile write FDriveFile;
    property DrillDownInfo : TRWDrillDownInfo read GetDrillDownInfo;
    property Print : Boolean read FPrint write FPrint;
    property PeriodField : Boolean read GetPeriodField write SetPeriodField;
    property RangeFilter : string read GetRangeFilter write SetRangeFilter;
    property Name : string read GetName write SetName;
    property DataType : Byte read GetDataType;
    property PrintSelect : String read GetPrintSelect;
    property InputLink : Integer read GetInputLink write SetInputLink;
    //PR: 16/10/2014 Added position for Order Payments
    property Position : Integer read FPosition write FPosition;
  end;

  TRWInputObject = Class
  private
    FInputRec : TGUIInputRec;
    FName : string;
    function GetPeriodRange(const Index: Integer): SmallInt;
    procedure SetPeriodRange(const Index: Integer; const Value: SmallInt);
    function GetCurrencyRange(const Index: Integer): Byte;
    procedure SetCurrencyRange(const Index: Integer; const Value: Byte);
  protected
    function GetInputType : Byte;
    procedure SetInputType(Value : Byte);
    function GetStringRange(Index : Integer) : string;
    procedure SetStringRange(Index : Integer; const Value : string);
    function GetDateRange(Index : Integer) : string;
    procedure SetDateRange(Index : Integer; const Value : string);
    function GetValueRange(Index : Integer) : Double;
    procedure SetValueRange(Index : Integer; const Value : Double);

    function GetName : string;
    procedure SetName(const Value : string);

    function GetIndex : Integer;
  public
    property InputType : Byte read GetInputType write SetInputType;
    property StringFrom : string Index 1 read GetStringRange write SetStringRange;
    property StringTo : string Index 2 read GetStringRange write SetStringRange;

    property ValueFrom : Double Index 1 read GetValueRange write SetValueRange;
    property ValueTo : Double Index 2 read GetValueRange write SetValueRange;

    property DateFrom : string Index 1 read GetDateRange write SetDateRange;
    property DateTo : string Index 2 read GetDateRange write SetDateRange;

    property PeriodFrom : SmallInt Index 1 read GetPeriodRange write SetPeriodRange;
    property PeriodTo : SmallInt Index 2 read GetPeriodRange write SetPeriodRange;

    property YearFrom : SmallInt Index 3 read GetPeriodRange write SetPeriodRange;
    property YearTo : SmallInt Index 4 read GetPeriodRange write SetPeriodRange;

    property CurrencyFrom : Byte Index 1 read GetCurrencyRange write SetCurrencyRange;
    property CurrrencyTo : Byte Index 2 read GetCurrencyRange write SetCurrencyRange;

    property Name : string read GetName write SetName;

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
    FValidationErrorString,
    FValidationErrorWord : string;
    FTestMode : Boolean;
    FSampleCount : longint;
    FFirstPos, FLastPos : longint;
    FRefreshFirst, FRefreshLast : Boolean;
    FInputLink : string;
    FCheckOnly : Boolean;
    FRecordCount : Longint;
    FCustomIDs : Array of string;
    FGetCustomValue : TGetCustomValueFunc;
    FNotifyField : TFieldNotifyProc;
    FNotifyFieldValue : TFieldValueByNameProc;
    function PutField(var GRec : TGUIFieldRec) : Integer;
    function PutInput(var GRec : TGUIInputRec) : Integer;
    procedure Set_OnCheckRecord(Value : TOnCheckRecordProc);
    procedure SetFileNo(Value : Integer);
    procedure SetIndexNo(Value : Integer);
    procedure GetRecord(ARec : TStrings);
    function GetField(Index : Integer) : TRWFieldObject;
    function GetInput(Index : Integer) : TRWInputObject;
    function GetFieldFromName(const AName : string) : TGuiFieldRec;
    function GetFieldCount : Integer;
    function GetInputCount : Integer;
    function ReplaceTokens(s : string) : string;
    function ReplaceInputs(s : string) : string;
    function ReplaceBrackets(s : string) : string;
    function BracketCount(const s : string; BracketChar : string) : Integer;
    function GetInputValue(Index : Integer; WhichPos : Byte) : string;
    function GetFieldName(Index : Integer) : string;
    procedure NotifyFieldNumber(Index : Integer);
    Function Is_CustomID(RepStr   :  String;
                         Var FormLen  :  Word;
                         Var FormName :  ShortString)  :  Boolean;
    procedure NotifyFieldValueByNumber(FieldNumber : Integer; const FieldValue : string);
    //PR: 01/06/2010 Added new handler for the parser to get fields from the cached file rather than the database on the second pass
    function GetDBFEvent (Const FieldCode : String;
                          Const Decs  : Byte) : ResultValueType;

    procedure SortFields;

    //PR: 10/11/2015 ABSEXCH-15491 Function to heck SQL records for line count in selection
    function CheckRecordForSQL : Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function AddField : TRWFieldObject;
    function AddInput : TRWInputObject;
    function InputNumber(const InpName : string) : longint;
    procedure Execute;
    function GetFirst : Boolean;
    function GetNext : Boolean;
    function GetPrevious : Boolean;
    procedure ClearFields;
    procedure ClearInputs;
    function ValidateFilter(const AFilter : string; IsCalc : Boolean = False) :   Integer;
    function ValidateCalculation(const ACalc : string) : Integer;
    function CustomParse(StringToParse : string; const Identifiers : Array of string;
                         CallbackFunc : TGetCustomValueFunc; FieldNo : Integer; var ErrorCode : SmallInt) : ResultValueType;
    procedure SetCustomIDs(const IDs : Array of string);
    property OnCheckRecord : TOnCheckRecordProc write Set_OnCheckRecord;
    property FileNo : Integer write SetFileNo;
    property IndexNo : Integer write SetIndexNo;
    property Fields [Index : Integer] : TRWFieldObject read GetField;
    property Inputs [Index : Integer] : TRWInputObject read GetInput;
    property FieldCount : Integer read GetFieldCount;
    property InputCount : Integer read GetInputCount;
    property ValidationErrorString : string read FValidationErrorString;
    property ValidationErrorWord : string read FValidationErrorWord;
    property TestMode : Boolean read FTestMode write FTestMode;
    property SampleCount : Integer read FSampleCount write FSampleCount;
    property FirstPos : longint read FFirstPos write FFirstPos;
    property LastPos : longint read FLastPos write FLastPos;
    property RefreshFirst : Boolean read FRefreshFirst write FRefreshFirst;
    property RefreshLast : Boolean read FRefreshLast write FRefreshLast;
    property InputLink : string read FInputLink write FInputLink;
    property RecordCount : longint read FRecordCount;
    property GetCustomValue : TGetCustomValueFunc read FGetCustomValue write FGetCustomValue;
    property NotifyField : TFieldNotifyProc read FNotifyField write FNotifyField;
    property NotifyFieldValue : TFieldValueByNameProc read FNotifyFieldValue write FNotifyFieldValue;
  end;


implementation

uses
  SysUtils, RepLine, ThingU, {DataDict,} DDFuncs, StrUtil, EtStrU, EtMiscU, SQLUtils,
  OrderPaymentsVar;

const
  DicLen = 8;


function SensibleUpperCase(s: string): string;
var
  TmpS : string;
  StartQuotePos, QuoteLength, i : Integer;
begin
  i := 2;
  TmpS := s;
  s := UpperCase(s);
  while (i < Length(s)) do
  begin
    while (i < Length(s)) and (s[i] <> '"') do inc(i);
    if (i < Length(s)) then
    begin
      StartQuotePos := i;
      inc(i);
    end;
    while (i < Length(s)) and (s[i] <> '"') do inc(i);
    if (i < Length(s))  or (s[i] = '"') then
    begin
      QuoteLength := i - StartQuotePos;
      inc(i);
      s := Copy(s, 1, StartQuotePos - 1) +
           Copy(TmpS, StartQuotePos, QuoteLength) +
           Copy(s, StartQuotePos + QuoteLength, Length(s));
    end;
  end;
  Result := s;
end;

function ContainsOperator(const s : string) : Boolean;
const
  Ops : Array[1..10] of string[3] = ('AND', 'OR', 'XOR', '=', '>', '<', '<>', #1, #2, #3 );
var
  i : integer;
begin
  Result := False;
  for i := 1 to 10 do
    if Trim(s) = Ops[i] then
      Result := True;
end;

procedure CheckSpaces(var s : string; const Brackets : string);
//Remove spaces after Brackets[1] and before Brackets[2] eg where Brackets is '()' and
//s is 'Substring( Blah,1,1 )' we'll end up with 'Substring(Blah,1,1)' which the parser can deal with
//If Brackets[1] or [2] is '*', ignore it.
var
  i, j, k : integer;
  TmpS : string;
begin
  i := 1;
  while i < Length(s) do
  begin
    if (Brackets[1] <> '*') and (s[i] = Brackets[1]) then
    begin
      inc(i);
      while (i < Length(s)) and (s[i] = ' ') do
        Delete(s, i, 1);
    end
    else
    if (Brackets[2] <> '*') and (s[i] = Brackets[2]) then
    begin
      j := i - 1;
      inc(i);
      while (j > 0) and (s[j] = ' ') do
      begin
        Delete(s, j, 1);
        Dec(j);
      end;

      //Extra check for operators - eg if we had '(a = b) or (c = d)', we'd now have
      //'(a = b) or(c = d)' so we need to replace the space between 'or' and the open bracket
      if Brackets[2] = '(' then
      begin
        k := j;
        while (j > 0) and (s[j] <> ' ') do
          Dec(j);
        if j > 0 then
        begin
          TmpS := Copy(s, j + 1, k - j);
          if ContainsOperator(TmpS) then
            Insert(' ', s, k + 1);
        end;
      end;

    end
    else
      inc(i);

  end;

end;

procedure AddSpacesAround(var s : string; const c : string);
var
 i : integer;

  function CharOK(const ch : char) : Boolean;
  begin
    Result := ch in [' '];
  end;

begin
  i := 2;
  while i < length(s) - 1 do
  begin
    if s[i] = c then
    begin
      if not (CharOK(s[i-1])) then
      begin
        Insert(' ', s, i);
        inc(i);
      end;
      if not (CharOK(s[i+1]))then
        Insert(' ', s, i+1);
    end;
    inc(i);
  end;

end;

function TReportWriterEngine.ReplaceBrackets(s : string) : string;
var
  i, j, k : integer;
  s1 : string;
  BrackCount : integer;
  b : byte;
  FLen : Word;
  FName : ShortString;
begin
  for i := 2 to Length(s) do
  begin
    if (s[i] = '(') then
    begin
      //Find if func name
      k := i - 1;
      while (k > 0) and (s[k] in ['A'..'Z', 'a'..'z']) do
        dec(k);
      s1 := Copy(s, k + 1, i - k);

      if IsNewFunc(s1, b) or Is_CustomID(s1, FLen, FName) then
      begin
        BrackCount := 1;
        j := i + 1;
        while (j <= Length(s)) and (BrackCount > 0) do
        begin
          if s[j] = '(' then
            inc(BrackCount)
          else
          if s[j] = ')' then
            dec(BrackCount);

          inc(j);

        end;
        s[i] := '[';
        s[j-1] := ']';

      end;
    end;
  end;
  Result := s;
end;

procedure ReplaceStrings(var s : string;
                       const OldStr, NewStr : string);
var
  i : integer;
begin
  i := Pos(OldStr, s);
  while i > 0 do
  begin
    Delete(s, i, Length(OldStr));
    Insert(NewStr, s, i);

    i := Pos(OldStr, s);
  end;
end;

function LJVar(const Val : string; Len : Integer) : string;
begin
  Result := Copy(Val + StringOfChar(' ', Len), 1, Len);
end;

Constructor TRWFieldObject.Create;
begin
  inherited Create;
  FillChar(FFieldRec, SizeOf(FFieldRec), #0);
  FFieldRec.FieldLen := 45;
  FDrillDown := TRWDrillDownInfo.Create;
  FFieldRec.PeriodField := False;
end;

destructor TRWFieldObject.Destroy;
begin
  if Assigned(FDrillDown) then
    FDrillDown.Free;
  inherited;
end;

function TRWFieldObject.GetIndex : Integer;
begin
  Result := FFieldRec.FieldNo;
end;

procedure TRWFieldObject.SetIndex (Value : Integer);
begin
  FFieldRec.FieldNo := Value;
end;

procedure TRWFieldObject.Reset;
begin
  FFieldRec.Filter := FFilter;
  FFieldRec.PrintFilter := FFilter;
  FFieldRec.CalcHolder := FCalc;
end;

function TRWFieldObject.GetVarName : string;
begin
  Result := FFieldRec.VarRef;
end;

procedure TRWFieldObject.SetVarName(const Value : string);
var
  d : DataDictRec;
begin
  FFieldRec.VarRef := LJVar(Value, DicLen);
  GetDDField(FFieldRec.VarRef, d);
  FFieldRec.VarNo := d.DataVarRec.VarNo;
  FFieldRec.DataType := d.DataVarRec.VarType;
  FFieldRec.FieldLen := d.DataVarRec.VarLen;
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
  Result := FFieldRec.Filter;
end;

procedure TRWFieldObject.SetFilter(const Value : string);
begin
  FFieldRec.Filter := SensibleUpperCase(Value);
  FFilter := Value;
end;

function TRWFieldObject.GetPrintFilter : string;
begin
  Result := FFieldRec.PrintFilter;
end;

procedure TRWFieldObject.SetPrintFilter(const Value : string);
begin
  FFieldRec.PrintFilter := SensibleUpperCase(Value);
  FPrintFilter := Value;
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
  Result := DoSpaces(FFieldRec.Value);
end;

function TRWFieldObject.GetCalculation : string;
begin
  Result := FFieldRec.CalcHolder;
end;
procedure TRWFieldObject.SetCalculation(const Value : string);
begin
  FFieldRec.CalcHolder := SensibleUpperCase(Value);
  FCalc := Value;
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

function TRWFieldObject.GetDrillDownInfo : TRWDrillDownInfo;
var
  LNo, AMode : Byte;
  FNo, IdxNo : SmallInt;
  KeyS : ShortString;
begin
  Result := nil;
  if not FFieldRec.CalcField then
  begin
    if SQLUtils.UsingSQL then
      Result := FDrillDown
    else
    if AddDrillDownInfo(FFieldRec.VarNo, FDriveFile, LNo, AMode,KeyS, FNo, IdxNo) then
    begin
      with FDrillDown do
      begin
        LevelNo := LNo;
        Mode := AMode;
        KeyString := KeyS;
        FileNo := FNo;
        IndexNo := IdxNo;
      end;
      Result := FDrillDown;
    end;
  end;
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

function TRWInputObject.GetName : string;
begin
  Result := FName;
end;

procedure TRWInputObject.SetName(const Value : string);
begin
  FName := UpperCase(Value);
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

function TRWInputObject.GetPeriodRange(const Index: Integer): SmallInt;
begin
  Case Index of
    1, 2 : Result := FInputRec.PrRange[Index, 1];
    3, 4 : begin
             Result := FInputRec.PrRange[Index-2, 2];
             if Result < 1900 then
               Result := Result + 1900;
           end;
  end;
end;

procedure TRWInputObject.SetPeriodRange(const Index: Integer;
  const Value: SmallInt);
begin
  Case Index of
    1, 2 : FInputRec.PrRange[Index, 1] := Value;
    3, 4 : begin
             if Value > 1900 then
               FInputRec.PrRange[Index-2, 2] := Value - 1900
             else
               FInputRec.PrRange[Index-2, 2] := Value;
           end;
  end;
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

  FillChar(FRepGen, SizeOf(FRepGen), 0);

  FTestMode := False;
  FRefreshFirst := False;
  FRefreshLast := False;

  FCheckOnly := False;

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
    Dispose(FRepObj, Destroy);
end;

function TReportWriterEngine.AddField : TRWFieldObject;
begin
  Result := TRWFieldObject.Create;
  Result.FFieldRec.FieldNo := FColList.Count + 1;
  Result.DriveFile := FRepGen.ReportHed.DriveFile;
  FColList.Add(Result);
end;

function TReportWriterEngine.AddInput : TRWInputObject;
begin
  Result := TRWInputObject.Create;
  Result.FInputRec.InputNo := FInputList.Count + 1;
  FInputList.Add(Result);
end;


procedure TReportWriterEngine.Execute;
var
  i : integer;
  Settings : TRepSettings;
begin
  //PR: 15/10/2014 Order payments. Initialise Link Transaction Ref
  OPLinkTransaction := '';

  //PR:
  SortFields;

  for i := 0 to FColList.Count - 1 do
  begin
    Fields[i].FFieldRec.RecSel := ReplaceTokens(Fields[i].Filter);
    Fields[i].FFieldRec.PrintSel := ReplaceTokens(Fields[i].PrintFilter);
    Fields[i].FFieldRec.Calculation := ReplaceTokens(Fields[i].Calculation);
    Fields[i].FFieldRec.RangeFilter := ReplaceTokens(Fields[i].RangeFilter);
    Fields[i].FFieldRec.Value := '';
  end;
  if Assigned(FRepObj) then
  begin
    Dispose(FRepObj, Destroy);
    FRepObj := nil;
  end;
  with Settings do
  begin
    rsTestMode := FTestMode;
    rsSampleCount := FSampleCount;
    rsFirstPos := FFirstPos;
    rsLastPos := FLastPos;
    rsRefreshFirst := FRefreshFirst;
    rsRefreshLast := FRefreshLast;
  end;
  FRepGen.ReportHed.FNDXInpNo := InputNumber(FInputLink);
  New(FRepObj, Create(Self, FRepGen, PutField, PutInput, GetFieldFromName,
                            NotifyFieldNumber, NotifyFieldValueByNumber,@Settings));
  FRepObj^.LineCtrl.VErrCode := 0;
  FRepObj^.LineCtrl.VErrMsg := '';
  FRepObj^.LineCtrl.VErrWord := '';

  FRepObj.OnSelectRecord := GetRecord;
  FRepObj.OnCheckRecord := FOnCheckRecord;
  FRepObj.FirstPass := True;
  with FRepObj.LineCtrl^ do
  begin
    GetCustomValue := FGetCustomValue;
    SetLength(CustomIDs, Succ(High(FCustomIDs)));
    for i := Low(FCustomIDs) to High(FCustomIDs) do
      CustomIDs[i] := UpperCase(FCustomIDs[i]);
  end;
  if FRepGen.ReportHed.FNDXInpNo > 0 then
  begin
    FRepObj.InpStart := GetInputValue(FRepGen.ReportHed.FNDXInpNo - 1, 1);
    FRepObj.InpEnd := GetInputValue(FRepGen.ReportHed.FNDXInpNo - 1, 2);
  end;
  FRepObj.Process_Report;
  for i := 0 to FColList.Count - 1 do
    Fields[i].Reset;
  FFirstPos := Settings.rsFirstPos;
  FLastPos := Settings.rsLastPos;
  FRecordCount := FRepObj^.NoOfRecsFound;
  FValidationErrorString := FRepObj^.LineCtrl.VErrMsg;
  FValidationErrorWord := FRepObj^.LineCtrl.VErrWord;

  //PR: 15/10/2014 Order payments. Initialise Link Transaction Ref before printing
  OPLinkTransaction := '';
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
  //PR: 01/06/2010 Assign 2nd pass dbf event handler to get fields from cached file rather than db
  if SQLUtils.UsingSQL then
  begin
    FRepObj.GetDBField := GetDBFEvent;

    //PR: 10/11/2015 ABSEXCH-15491
    FRepObj.CheckRecordSQL := CheckRecordForSQL;
  end;
  Result := FRepObj.GetFirst;
end;

function TReportWriterEngine.GetNext : Boolean;
begin
  Result := FRepObj.GetNext;
end;

function TReportWriterEngine.GetPrevious : Boolean;
begin
  Result := FRepObj.GetPrevious;
end;

procedure TReportWriterEngine.GetRecord(ARec : TStrings);
var
  i : integer;
begin
  for i := 0 to ARec.Count - 1 do
  begin
    TRWFieldObject(FColList[i]).FFieldRec.Value := Trim(ARec[i]);
    TRWFieldObject(FColList[i]).Print := TPrintIfObj(ARec.Objects[i]).WantPrint;

    //PR: 22/02/2011 DrillDown info is stored on the first pass
    if SQLUtils.UsingSQL then
    begin
      if TRWFieldObject(FColList[i]).DrillDownInfo <> nil then
      begin
        TRWFieldObject(FColList[i]).DrillDownInfo.FileNo := TPrintIfObj(ARec.Objects[i]).DrillDownRec.FileNo;
        TRWFieldObject(FColList[i]).DrillDownInfo.IndexNo := TPrintIfObj(ARec.Objects[i]).DrillDownRec.IndexNo;
        TRWFieldObject(FColList[i]).DrillDownInfo.KeyString := TPrintIfObj(ARec.Objects[i]).DrillDownKey;

        TRWFieldObject(FColList[i]).DrillDownInfo.Mode := 0;
        TRWFieldObject(FColList[i]).DrillDownInfo.LevelNo := 1;
      end;
    end;  //If using sql
  end;
  if SQLUtils.UsingSQL then
    ARec.Free; //PR: 22/02/2011 StringList wasn't being freed.
end;

function TReportWriterEngine.GetFieldCount : Integer;
begin
  Result := FColList.Count;
end;

function TReportWriterEngine.GetInputCount : Integer;
begin
  Result := FInputList.Count;
end;

function TReportWriterEngine.ReplaceTokens(s : string) : string;
const
  MaxOps = 3;
  Ops : Array[1..MaxOps] of String[10] = ('BEGINSWITH', 'CONTAINS', 'ENDSWITH');
var
  i, j, k : integer;
begin
  for i := 1 to MaxOps do
  begin
    j := Pos(Ops[i], UpperCase(s));
    while j > 0 do
    begin
      Delete(s, j, Length(Ops[i]));
      Insert(Char(i), s, j);

      j := Pos(Ops[i], UpperCase(s));
    end;
  end;


  //The parser is very sensitive to position of spaces, so remove any spaces
  //in positions that will cause problems
  CheckSpaces(s, '()');
  CheckSpaces(s, '[]');
  CheckSpaces(s, '*[');
  CheckSpaces(s, '*(');
  CheckSpaces(s, ',*');
  CheckSpaces(s, '*,');

                   //OldStr     NewStr
  ReplaceStrings(s, 'DBFIELD[', 'DBF[');
  ReplaceStrings(s, 'FORMULA[', 'FML[');
  ReplaceStrings(s, 'INP[', 'INPUTFIELD[');
//  ReplaceStrings(s, 'RF[', 'INPUTFIELD[');


  Result := ReplaceInputs(ReplaceBrackets(s));

end;

function TReportWriterEngine.ReplaceInputs(s : string) : string;
var
  i, j, k, FieldLen : integer;
  InpName, ReplaceStr : string;
  InpPos : Byte;
  InpNumber : Integer;
  IsPeriod : Boolean;
  PeriodOrYear : String;

begin
  j := Pos('INPUTFIELD', s);
  while j > 0 do
  begin
    IsPeriod := False;
    i := j;
    while (i < Length(s)) and (s[i] <> ']') do inc(i);
    FieldLen := i - j + 1;
    i := j + 12;      //PR: 08/07/2009 Added ']' to check
    while (i < Length(s)) and not (s[i] in [',', ']']) do inc(i);
    InpName := Trim(Copy(s, j + 11, i - j - 11));
    inc(i);
    while (i < Length(s)) and (s[i] = ' ') do inc(i);
    if Copy(s, i, 3) = 'END' then
    begin
      InpPos := 2;
      i := i + 3;
    end
    else
    begin
      InpPos := 1;
      i := i + 5;
    end;

    InpNumber := InputNumber(InpName);
    if InpNumber > 0 then
    begin
      IsPeriod := Inputs[InpNumber - 1].InputType = 2;
    end
    else
    begin
      FValidationErrorString := 'Unknown Input Field Name: ' + QuotedStr(InpName);
      FValidationErrorWord := InpName;
      raise EInvalidInput.Create(FValidationErrorString);
    end;

    if IsPeriod then
    begin
      while (i < Length(s)) and (s[i] = ' ') do inc(i);
      if (i < Length(s)) and (s[i] = ',') then
      begin
        inc(i);
        while (s[i] = ' ') do inc(i);
        Case s[i] of
          '1','P' : PeriodOrYear := ',1';
          '2','Y' : PeriodOrYear := ',2';
          else
            PeriodOrYear := '';
        end;
      end
      else
        PeriodOrYear := '';
    end;

    ReplaceStr := 'I' + IntToStr(InpNumber) + '[' + IntToStr(InpPos) + PeriodOrYear + ']';

    Delete(s, j, FieldLen);
    Insert(ReplaceStr, s, j);

    j := Pos('INPUTFIELD', s);
  end;

  Result := s;
end;

procedure TReportWriterEngine.ClearFields;
begin
  FColList.Clear;
end;

procedure TReportWriterEngine.ClearInputs;
begin
  FInputList.Clear;
end;

function TReportWriterEngine.ValidateFilter(const AFilter : string; IsCalc : Boolean = False) : Integer;
var
  ErrFlag : Byte;
  ErrFlagW : Word;
  TmpRepObj : RepCtrlPtr;
  TempS : String;
  s : string;
  i : integer;
begin
  FCheckOnly := True;
  Try
    Result := 0;
    Try
      TempS := ReplaceTokens(SensibleUpperCase(AFilter));
    Except
      on E:EInvalidInput do
        Result := veBadInput;
    End;

    if Result = 0 then
      Result := BracketCount(AFilter, '()');

    if Result = 0 then
      Result := BracketCount(AFilter, '[]');

    if Result = 0 then
    begin
      New(TmpRepObj, Create(Self, FRepGen, PutField, PutInput,
                            GetFieldFromName, NotifyFieldNumber, NotifyFieldValueByNumber, nil));
      Try
        TmpRepObj^.LineCtrl.VErrCode := 0;
        TmpRepObj^.LineCtrl.VErrMsg := '';
        with TmpRepObj.LineCtrl^ do
        begin
          GetCustomValue := FGetCustomValue;
          SetLength(CustomIDs, Succ(High(FCustomIDs)));
          for i := Low(FCustomIDs) to High(FCustomIDs) do
            CustomIDs[i] := UpperCase(FCustomIDs[i]);
        end;
        if IsCalc then
        begin
          if Pos('"', TempS) = 1 then
            TmpRepObj^.LineCtrl.SetFormula(TempS, 0, ErrFlag)
          else
            TmpRepObj^.LineCtrl.Parse(TempS, ErrFlagW, s);
        end
        else
          TmpRepObj^.LineCtrl.Evaluate_Expression(TempS, ErrFlag, True);

 //       if IsCalc then
          Result := TmpRepObj^.LineCtrl.VErrCode;
{        else
          if TmpRepObj^.LineCtrl.SelErr then
            Result := 1
          else
            Result := 0;}
        FValidationErrorString := TmpRepObj^.LineCtrl.VErrMsg;
        FValidationErrorWord := TmpRepObj^.LineCtrl.VErrWord;
      Finally
        Dispose(TmpRepObj, Destroy);
      End;
    end;
  Finally
    FCheckOnly := False;
  End;
end;

function TReportWriterEngine.ValidateCalculation(const ACalc : string) : Integer;
begin
  Result := ValidateFilter(ACalc, True);
end;

function TReportWriterEngine.BracketCount(const s : string; BracketChar : string) : Integer;
var
  OChar, CChar : char;
  Count, i : integer;
begin
  Count := 0;
  Result := 0;
  OChar := BracketChar[1];
  CChar := BracketChar[2];

  for i := 1 to Length(s) do
    if s[i] = OChar then
      inc(Count)
    else
    if s[i] = CChar then
      dec(Count);

  if Count > 0 then
    FValidationErrorWord := CChar
  else
  if Count < 0 then
    FValidationErrorWord := OChar;

  if Count <> 0 then
  begin
    FValidationErrorString := 'Missing bracket ' + QuotedStr(FValidationErrorWord);
    Result := veMissingBracket;
  end;
end;

//===============================================================================================
constructor TRWDrillDownInfo.Create;
begin
  inherited Create;
  FMode := 0;
  FLevelNo := 1;
  FKeyString := '';
  FFileNo := 0;
  FIndexNo := 0;
end;

procedure TRWDrillDownInfo.Assign(const Info : TRWDrillDownInfo);
begin
  if Assigned(Info) then
  begin
    FMode := Info.Mode;
    FLevelNo := Info.LevelNo;
    FKeyString := Info.KeyString;
    FFileNo := Info.FileNo;
    FIndexNo := Info.IndexNo;
  end
  else
    Raise Exception.Create('Nil object passed to TRWDrillDownInfo.Assign');
end;


function TRWFieldObject.DoSpaces(const s: string): string;
begin
  Result := s;
  if Length(s) > 0 then
    if s[1] <> '"' then
      ReplaceStr(Result, '<SPACE>', ' ');
end;

function TRWFieldObject.GetPeriodField: Boolean;
begin
  Result := FFieldRec.PeriodField;
end;

procedure TRWFieldObject.SetPeriodField(const Value: Boolean);
begin
  FFieldRec.PeriodField := Value;
end;

function TReportWriterEngine.InputNumber(const InpName: string): longint;
var
  k : longint;
begin
  Result := 0;
  for k := 0 to FInputList.Count -1 do
    if UpperCase(Inputs[k].Name) = UpperCase(InpName) then
    begin
      Result := k + 1;
      Break;
    end;
end;


function TRWFieldObject.GetRangeFilter: string;
begin
  Result := FFieldRec.RangeFilter;
end;

procedure TRWFieldObject.SetRangeFilter(const Value: string);
begin
  FFieldRec.RangeFilter := Value;
end;

function TReportWriterEngine.GetInputValue(Index: Integer;
  WhichPos: Byte): string;
var
  y, p : Byte;

begin
  Case  Inputs[Index].InputType of
      1   :  Case WhichPos of
               1 : Result := Inputs[Index].DateFrom;
               2 : Result := Inputs[Index].DateTo;
             end;
      2   :  begin
                //Need to make sure year has three digits
                y := Inputs[Index].FInputRec.PrRange[WhichPos, 2];
                if y >= 100 then
                  Result := IntToStr(y)
                else
                  Result := '0' + IntToStr(y);
                Result := Result + IntToStr(Inputs[Index].FInputRec.PrRange[WhichPos, 1]);
             end;
      3   :  Case WhichPos of
               1 : Result := Format('%8.2f', [Inputs[Index].ValueFrom]);
               2 : Result := Format('%8.2f', [Inputs[Index].ValueTo]);
             end;
      4,   // ASCII
      6,   // document no
      7,   // customer code
      8,   // supplier code
      9,   // nominal code
      10,  // stock code
      11,  // cost centre code
      12,  // department code
      13,  // location code
      17,  // Job Code
      18  // Bin Code
         :  Case WhichPos of
             1 : Result := Inputs[Index].StringFrom;
             2 : Result := Inputs[Index].StringTo;
            end;
      else
      Case WhichPos of
        1 : Result := Inputs[Index].StringFrom;
        2 : Result := Inputs[Index].StringTo;
      end;

  end;

end;

function TRWInputObject.GetCurrencyRange(const Index: Integer): Byte;
begin
  Result := FInputRec.CrRange[Index];
end;

procedure TRWInputObject.SetCurrencyRange(const Index: Integer;
  const Value: Byte);
begin
  FInputRec.CrRange[Index] := Value;
end;

function TRWFieldObject.GetName: string;
begin
  Result := FFieldRec.Name;
end;

procedure TRWFieldObject.SetName(const Value: string);
begin
  FFieldRec.Name := Value;
end;

function TReportWriterEngine.GetFieldFromName(const AName: string): TGuiFieldRec;
var
  i : integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  if FCheckOnly then
    Result.Calculation := '1 * 1'
  else
  for i := 0 to FColList.Count - 1 do
  begin
    if Trim(UpperCase(AName)) =
       Trim(UpperCase(TRWFieldObject(FColList.Items[i]).Name)) then
    begin
      Result := TRWFieldObject(FColList.Items[i]).FFieldRec;
      Break;
    end;
  end;
end;

{TReportWriterEngine.CustomParse

Parameters
  StringToParse : string; //The string to be parsed. Any custom tags should have their argument(s)
                          //enclosed in square brackets as we currently do with FML[] & DBF[]

  Identifiers   : Array of String; //An open array of strings. This should contain any tags
                                   //that are to be used - eg Total, Count, etc.

  CallbackFunc  : TGetCustomValueFunc; //This should be a function which the parser can call to
                                       //get the appropriate values for the tags. The parameters
                                       //passed in will be the tag and the contents of the square
                                       //brackets belonging to the tag. (Both will be in upper case.)

  ErrorCode     : SmallInt; //This will be zero if the parse was successful, otherwise it will
                            //contain the appropriate error code. In this case, Validation
                            //ErrorString and ValidationWord will also be populated.

}
function TReportWriterEngine.CustomParse(StringToParse: string;
  const Identifiers: array of string; CallbackFunc: TGetCustomValueFunc;
   FieldNo : Integer; var ErrorCode: SmallInt): ResultValueType;
var
  i : integer;
  Att : Word;
  ErrFlag : Byte;
  HasErr : Boolean;
  StrRes : string;
  Settings : TRepSettings;
  R : TParserStateRec;
begin
  if Assigned(CallBackFunc) then
  begin
    if not Assigned(FRepObj) then
        New(FRepObj, Create(Self, FRepGen, PutField, PutInput,
                            GetFieldFromName, NotifyFieldNumber, NotifyFieldValueByNumber, @Settings));

    with FRepObj.LineCtrl^ do
    begin
      ErrorCode := 0;
      HasErr := False;
      GetCustomValue := CallbackFunc;
      SetLength(CustomIDs, Succ(High(Identifiers)));
      for i := Low(Identifiers) to High(Identifiers) do
        CustomIDs[i] := UpperCase(Identifiers[i]);
      SaveParser(R);
      FieldNumber := FieldNo + 1;
      if FRepObj.LineCtrl.Evaluate_Expression(TRWFieldObject(FColList.Items[FieldNo]).PrintSelect, ErrFlag) then
      begin
        if StringToParse[1] = '"' then //PR: 08/07/2009 Added ReplaceTokens
          Result.StrResult :=  FRepObj.LineCtrl.ConcatCalc(ReplaceTokens(ReplaceBrackets(UpperCase(StringToParse))), ErrFlag, HasErr)
        else
        begin
          Result.DblResult  := Parse(ReplaceTokens(ReplaceBrackets(UpperCase(StringToParse))), Att, StrRes);
          Result.StrResult := StrRes;
        end;
      end
      else
      begin
        Result.DblResult := 0;
        Result.StrResult := '';
      end;
      RestoreParser(R);
      ErrorCode := VErrCode;
      FValidationErrorString := VErrMsg;
      FValidationErrorWord := VErrWord;

    end;
  end
  else
    ErrorCode := veNoCustomFunc;
end;

function TRWFieldObject.GetDataType: Byte;
begin
  Result := FFieldRec.DataType;
end;

procedure TReportWriterEngine.SetCustomIDs(const IDs: array of string);
var
  i : integer;
begin
  SetLength(FCustomIDs, Succ(High(IDs)));
  for i := Low(Ids) to High(Ids) do
    FCustomIDs[i] := UpperCase(Ids[i]);
end;


function TReportWriterEngine.GetFieldName(Index: Integer): string;
begin
  if (Index > 0) and (Index <= FColList.Count) then
    Result := TRWFieldObject(FColList[Index-1]).FFieldRec.Name
  else
    Result := '';
end;

procedure TReportWriterEngine.NotifyFieldNumber(Index: Integer);
begin
  if Assigned(FNotifyField) then
    FNotifyField(GetFieldName(Index));
end;

procedure TReportWriterEngine.NotifyFieldValueByNumber(FieldNumber : Integer; const FieldValue : string);
begin
  if Assigned(FNotifyFieldValue) then
    FNotifyFieldValue(GetFieldName(FieldNumber), FieldValue);
end;


function TReportWriterEngine.Is_CustomID(RepStr: String; var FormLen: Word;
  var FormName: ShortString): Boolean;
var
  i : integer;
Begin
  { Return not found as default }
  Result := False;
  if Length(FCustomIds) > 0 then
    for i := Low(FCustomIds) to High(FCustomIds) do
      if Pos(FCustomIds[i], RepStr) = 1 then
      begin
        Result := True;
        Break;
      end;

end;

function TRWFieldObject.GetPrintSelect: String;
begin
  Result := FFieldRec.PrintSel;
end;

function TRWFieldObject.GetInputLink: Integer;
begin
  Result := FFieldRec.FInputLink;
end;

procedure TRWFieldObject.SetInputLink(Value: Integer);
begin
  FFieldRec.FInputLink := Value;
end;

function TReportWriterEngine.GetDBFEvent(const FieldCode: String;
  const Decs: Byte): ResultValueType;
var
  s : string;
  i : Integer;
  Found : Boolean;
begin
  i := 0;
  Found := False;
  while (i < FColList.Count) and not Found do
  begin
    Found := (Trim(FieldCode) = Trim(TRWFieldObject(FColList[i]).VarName));
    if not Found then
      inc(i);
  end;
  if Found then
  begin
    Result.StrResult := TRWFieldObject(FColList[i]).Value;
    Case TRWFieldObject(FColList[i]).DataType Of
      { String }
      1       : Begin
                  Result.DblResult := 0.0;
                End;
      { Real, Double }
      2, 3    : Begin
                  { Get value of field from string }
                  Result.DblResult := DoubleStr(Result.StrResult);
                  Result.DblResult := Round_Up(Result.DblResult, Decs);
                End; { With }

      { Date }   {PR 22/3/05 - change so that formatting is done in
                  mcparser.FillObject - as between here and there we may
                  need to compare the date, so needs to stay as yyyymmdd}
      4       : {If (Result.StrResult <> '') Then
                  Result.StrResult := POutDate(Result.StrResult)};

      { Char }
      5       : { Its already a string} ;

      { Longint, Integer, Byte }
      6, 7, 8 : Begin
                  { String format OK - just get value }
                  Result.DblResult := IntStr(Result.StrResult);
                End;

      { Currency }   { MH 09/12/96 - Unnecessary. maybe! }
      {9       : Begin
                  Result.StrResult := SSymb(IntStr(Result.StrResult));
                End;}

      { Period }
      10      : { no action required };

      { Yes/No }
      11      : { no action required };

      { Time }
      12      : { no action required };
    End; { Case }
  end;
end;

//PR: 16/10/2014 function to sort fields based on postion property, which denotes the order they should be processed in
function  SortFieldsByPosition(Item1, Item2 : Pointer) : Integer;
begin
  Result := TRWFieldObject(Item1).Position - TRWFieldObject(Item2).Position;
end;


procedure TReportWriterEngine.SortFields;
var
  i : integer;
begin
  //Sort the list
  FColList.Sort(@SortFieldsByPosition);

  //Fields have to know where they are in the list, so update
  for i := 0 to FColList.Count - 1 do
    TRWFieldObject(FColList[i]).Index := i + 1;
end;

//PR: 10/11/2015 ABSEXCH-15491 Function to heck SQL records for line count in selection
function TReportWriterEngine.CheckRecordForSQL: Boolean;
var
  i : integer;
  ErrFlag : Byte;
  TempParser : TParserStateRec;

  function DoParse(const StringToParse : string) : string;
  var
    dResult : Double;
    Att : Word;
  begin
    dResult := FRepObj.LineCtrl.Parse(StringToParse, Att, Result);
  end;
  
begin
  Result := True;
  SaveParser(TempParser);
  Try

    //Run through columns checking for any that have selection criteria
    for i := 0 to FColList.Count - 1 do
    begin
      if Trim(TRWFieldObject(FColList[i]).Filter) <> '' then
      begin
        //do we have line count in the selection? If so, need to evaluate it now
        if Pos('SYSREPC', TRWFieldObject(FColList[i]).Filter) > 0 then
          Result := FRepObj.LineCtrl.Evaluate_Expression(TRWFieldObject(FColList.Items[i]).Filter, ErrFlag);

        if not Result
          then Break;
      end;

      if TRWFieldObject(FColList[i]).CalcField then
      begin
        if Pos('SYSREPC', TRWFieldObject(FColList[i]).Calculation) > 0 then
          with TRWFieldObject(FColList[i]) do
            Value := DoParse(Calculation);
      end;

    end;
  Finally
    RestoreParser(TempParser);
  End;
end;

procedure TRWFieldObject.SetValue(const Value: string);
begin
  FFieldRec.Value := Value;
end;

Initialization


end.
