unit GuiEng2;

interface

uses
  RepObjCU, MCParser, Classes, RwOpenF, Contnrs, GuiVar, ExBtTh1U;

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
    function GetPrintFilter : string;
    procedure SetPrintFilter(const Value : string);
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
    function GetDrillDownInfo : TRWDrillDownInfo;
  public
    constructor Create;
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
    property Value : String read GetValue;
    property Calculation : string read GetCalculation write SetCalculation;
    property Index : Integer read GetIndex;
    property DriveFile : SmallInt read FDriveFile write FDriveFile;
    property DrillDownInfo : TRWDrillDownInfo read GetDrillDownInfo;
    property Print : Boolean read FPrint write FPrint;
  end;

  TRWInputObject = Class
  private
    FInputRec : TGUIInputRec;
    FName : string;
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

    property Name : string read GetName write SetName;

  end;

//  TReportWriterEngine = Class
  PReportWriterEngine = ^TReportWriterEngine;
  TReportWriterEngine = Object(TThreadQueue)
    FOwner : TObject;
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
    Settings : TRepSettings;
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
    function ReplaceTokens(s : string) : string;
    function ReplaceInputs(s : string) : string;
    function BracketCount(const s : string; BracketChar : string) : Integer;
//    constructor Create;
    Constructor Create(AOwner  :  TObject);
    destructor Destroy; virtual;
    function AddField : TRWFieldObject;
    function AddInput : TRWInputObject;
    function Start : Boolean; virtual;
    procedure Process; virtual;
    procedure AllDone;
    function GetFirst : Boolean;
    function GetNext : Boolean;
    procedure ClearFields;
    procedure ClearInputs;
    function ValidateFilter(const AFilter : string; IsCalc : Boolean = False) :   Integer;
    function ValidateCalculation(const ACalc : string) : Integer;
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
  end;


implementation

uses
  SysUtils, RepLine, ThingU, DataDict;

const
  DicLen = 8;


function ReplaceBrackets(s : string) : string;
var
  i, j, k : integer;
  s1 : string;
  BrackCount : integer;
  b : byte;
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

      if IsNewFunc(s1, b) then
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
end;

function TRWFieldObject.GetIndex : Integer;
begin
  Result := FFieldRec.FieldNo;
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
  FFieldRec.Filter := UpperCase(Value);
  FFilter := Value;
end;

function TRWFieldObject.GetPrintFilter : string;
begin
  Result := FFieldRec.PrintFilter;
end;

procedure TRWFieldObject.SetPrintFilter(const Value : string);
begin
  FFieldRec.PrintFilter := UpperCase(Value);
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
  Result := FFieldRec.Value;
end;

function TRWFieldObject.GetCalculation : string;
begin
  Result := FFieldRec.CalcHolder;
end;
procedure TRWFieldObject.SetCalculation(const Value : string);
begin
  FFieldRec.CalcHolder := UpperCase(Value);
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

//============================Report Engine========================================
constructor TReportWriterEngine.Create(AOwner : TObject);
begin
  inherited Create(AOwner);
  FOwner := AOwner;
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
  Result.DriveFile := FRepGen.ReportHed.DriveFile;
  FColList.Add(Result);
end;

function TReportWriterEngine.AddInput : TRWInputObject;
begin
  Result := TRWInputObject.Create;
  Result.FInputRec.InputNo := FInputList.Count + 1;
  FInputList.Add(Result);
end;


function TReportWriterEngine.Start : Boolean;
var
  i : integer;
begin
  Result := True;
  for i := 0 to FColList.Count - 1 do
  begin
    Fields[i].FFieldRec.RecSel := ReplaceTokens(Fields[i].Filter);
    Fields[i].FFieldRec.PrintSel := ReplaceTokens(Fields[i].PrintFilter);
    Fields[i].FFieldRec.Calculation := ReplaceTokens(Fields[i].Calculation);
    Fields[i].FFieldRec.Value := '';
  end;
  if Assigned(FRepObj) then
    Dispose(FRepObj);
  with Settings do
  begin
    rsTestMode := FTestMode;
    rsSampleCount := FSampleCount;
    rsFirstPos := FFirstPos;
    rsLastPos := FLastPos;
    rsRefreshFirst := FRefreshFirst;
    rsRefreshLast := FRefreshLast;
  end;
  New(FRepObj, Create(FOwner, FRepGen, PutField, PutInput, @Settings));
  MTExLocal := FRepObj.MTExLocal;
  FRepObj.OnSelectRecord := GetRecord;
  FRepObj.OnCheckRecord := FOnCheckRecord;
//  FRepObj.OnFinished := AllDone;
{  FRepObj.Process_Report;
  for i := 0 to FColList.Count - 1 do
    Fields[i].Reset;
  FFirstPos := Settings.rsFirstPos;
  FLastPos := Settings.rsLastPos;}
end;

procedure TReportWriterEngine.AllDone;
var
 i : integer;
begin
//  inherited Finish;
  for i := 0 to FColList.Count - 1 do
    Fields[i].Reset;
  FFirstPos := Settings.rsFirstPos;
  FLastPos := Settings.rsLastPos;
{  if Assigned(FOnFinish) then
    FOnFinish;}
end;


procedure TReportWriterEngine.Process;
begin
  FRepObj.ThreadRec := ThreadRec;
  inherited Process;
  FRepObj.Process;
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
  begin
    TRWFieldObject(FColList[i]).FFieldRec.Value := Trim(ARec[i]);
    TRWFieldObject(FColList[i]).Print := TPrintIfObj(ARec.Objects[i]).WantPrint;
  end;
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
                   //OldStr     NewStr
  ReplaceStrings(s, 'DBFIELD[', 'DBF[');
  ReplaceStrings(s, 'FORMULA[', 'FML[');
  ReplaceStrings(s, 'INP[', 'INPUTFIELD[');

  Result := ReplaceInputs(ReplaceBrackets(s));

end;

function TReportWriterEngine.ReplaceInputs(s : string) : string;
var
  i, j, FieldLen : integer;
  InpName : string;
  InpPos : Byte;
  InpNumber : Integer;

begin
  j := Pos('INPUTFIELD', s);
  while j > 0 do
  begin
    i := j;
    while (i < Length(s)) and (s[i] <> ']') do inc(i);
    FieldLen := i - j + 1;
    i := j + 12;
    while (i < Length(s)) and (s[i] <> ',') do inc(i);
    InpName := Trim(Copy(s, j + 11, i - j - 11));
    inc(i);
    while s[i] = ' ' do inc(i);
    if Copy(s, i, 3) = 'END' then
      InpPos := 2
    else
      InpPos := 1;

    InpNumber := -1;
    for i := 0 to FInputList.Count -1 do
      if Inputs[i].Name = InpName then
      begin
        InpNumber := i + 1;
        Break;
      end;
    if InpNumber = -1 then
    begin
      FValidationErrorString := 'Unknown Input Field Name: ' + QuotedStr(InpName);
      FValidationErrorWord := InpName;
      raise EInvalidInput.Create(FValidationErrorString);
    end;

    Delete(s, j, FieldLen);
    Insert('I' + IntToStr(InpNumber) + '[' + IntToStr(InpPos) + ']', s, j);

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
  TempS : String[100];
  s : string;
begin
  Result := 0;
  Try
    TempS := ReplaceTokens(UpperCase(AFilter));
  Except
    on E:EInvalidInput do
      Result := veBadInput;
  End;

  Result := BracketCount(AFilter, '()');
  if Result = 0 then
    Result := BracketCount(AFilter, '[]');

  if Result = 0 then
  begin
    New(TmpRepObj, Create(FOwner, FRepGen, nil, nil, nil));
    Try
      TmpRepObj^.LineCtrl.VErrCode := 0;
      TmpRepObj^.LineCtrl.VErrMsg := '';
      if IsCalc then
        TmpRepObj^.LineCtrl.Parse(TempS, ErrFlagW, s)
      else
        TmpRepObj^.LineCtrl.Evaluate_Expression(TempS, ErrFlag, True);
      Result := TmpRepObj^.LineCtrl.VErrCode;
      FValidationErrorString := TmpRepObj^.LineCtrl.VErrMsg;
      FValidationErrorWord := TmpRepObj^.LineCtrl.VErrWord;
    Finally
      Dispose(TmpRepObj);
    End;
  end;
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


Initialization


end.
