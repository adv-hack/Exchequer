{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVDataField;

interface

uses
  {$IFDEF Linux}
  QControls,
  {$ELSE}
  Controls,
  {$ENDIF}
  Classes, RPDefine, RVDefine, RVClass;

type
  {$IFDEF Linux}
  TDate = TDateTime;
  TTime = TDateTime;
  {$ENDIF}

  TDataRowType = (rtFirst,rtMiddle,rtLast);

  TRaveDataRow = class
  public
    DataPtr: PChar; { Binary array of data }
    DataSize: longint; { Size of DataPtr }
    DataRowType: TDataRowType;
    Next: TRaveDataRow;

    destructor Destroy; override;
    procedure MoveTo(Dest: TRaveDataRow);
    procedure Clear;
    procedure Init(Size: longint);
    function GetNativePtr(FieldIdx: integer): pointer;
    function GetFormattedPtr(FieldIdx: integer): pointer;
    procedure GetNativeData(    FieldIdx: integer;
                            var CalcPtr: pointer;
                            var CalcSize: longint);
    function GetFormattedData(FieldIdx: integer): string;
  end; { TRaveDataRow }

  TRaveDataField = class(TRaveComponent)
  protected
    FDataIndex: integer; { Index into DataRow.FormatData, starts at 0 }
    FDataType: TRPDataType;
    FFieldName: string;
    FSize: integer;
    FFullName: string;
    FDescription: TRaveMemoString;
    FNullText: string;
    FCalculated: boolean;

    function GetDataType: TRPDataType; virtual; abstract;
    function GetAsString: string; virtual;
    function GetAsBoolean: boolean; virtual;
    function GetAsInteger: longint; virtual;
    function GetAsInt64: Int64; virtual;
    function GetAsFloat: extended; virtual;
    function GetAsCurrency: currency; virtual;
    function GetAsDateTime: TDateTime; virtual;
    function GetAsDate: TDate; virtual;
    function GetAsTime: TTime; virtual;
    function GetAsBlob: pointer; virtual;
    function GetDataSize: longint;
    function GetIsNull: boolean;
    procedure SetFieldName(Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DataType: TRPDataType read GetDataType;
    property DataIndex: integer read FDataIndex write FDataIndex;
    property AsString: string read GetAsString;
    property AsBoolean: boolean read GetAsBoolean;
    property AsInteger: longint read GetAsInteger;
    property AsInt64: Int64 read GetAsInt64;
    property AsFloat: extended read GetAsFloat;
    property AsCurrency: currency read GetAsCurrency;
    property AsDateTime: TDateTime read GetAsDateTime;
    property AsDate: TDate read GetAsDate;
    property AsTime: TTime read GetAsTime;
    property AsBlob: pointer read GetAsBlob;
    property DataSize: longint read GetDataSize;
    property IsNull: boolean read GetIsNull;
  published
    property Calculated: boolean read FCalculated write FCalculated default false;
    property Description: TRaveMemoString read FDescription write FDescription;
    property FieldName: string read FFieldName write SetFieldName;
    property FullName: string read FFullName write FFullName;
    property NullText: string read FNullText write FNullText;
    property Size: integer read FSize write FSize default 10;
  end; { TRaveDataField }
  TRaveDataFieldClass = class of TRaveDataField;

  TRaveFormattedField = class(TRaveDataField)
  protected
    FDisplayFormat: string;
  published
    property DisplayFormat: string read FDisplayFormat write FDisplayFormat;
  end; { TRaveFormattedField }

  TRaveStringField = class(TRaveDataField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
  end; { TRaveStringField }

  TRaveBooleanField = class(TRaveDataField)
  protected
    FTextTrue: string;
    FTextFalse: string;
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
    function GetAsBoolean: boolean; override;
  published
    property TextTrue: string read FTextTrue write FTextTrue;
    property TextFalse: string read FTextFalse write FTextFalse;
  end; { TRaveBooleanField }

  TRaveIntegerField = class(TRaveFormattedField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
    function GetAsInteger: longint; override;
    function GetAsInt64: Int64; override;
    function GetAsFloat: extended; override;
    function GetAsCurrency: currency; override;
  end; { TRaveIntegerField }

  TRaveInt64Field = class(TRaveFormattedField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
    function GetAsInteger: longint; override;
    function GetAsInt64: Int64; override;
    function GetAsFloat: extended; override;
    function GetAsCurrency: currency; override;
  end; { TRaveInt64Field }

  TRaveFloatField = class(TRaveFormattedField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
    function GetAsInteger: longint; override;
    function GetAsInt64: Int64; override;
    function GetAsFloat: extended; override;
    function GetAsCurrency: currency; override;
  end; { TRaveFloatField }

  TRaveCurrencyField = class(TRaveFormattedField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
    function GetAsInteger: longint; override;
    function GetAsInt64: Int64; override;
    function GetAsFloat: extended; override;
    function GetAsCurrency: currency; override;
  end; { TRaveCurrencyField }

  TRaveBCDField = class(TRaveCurrencyField)
  protected
    function GetDataType: TRPDataType; override;
  end; { TRaveBCDField }

  TRaveDateTimeField = class(TRaveFormattedField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
    function GetAsFloat: extended; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDate: TDate; override;
    function GetAsTime: TTime; override;
  end; { TRaveDateTimeField }

  TRaveDateField = class(TRaveDateTimeField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDate: TDate; override;
    function GetAsTime: TTime; override;
  end; { TRaveDateField }

  TRaveTimeField = class(TRaveDateTimeField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDate: TDate; override;
    function GetAsTime: TTime; override;
  end; { TRaveTimeField }

  TRaveBlobField = class(TRaveDataField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
  end; { TRaveBlobField }

  TRaveMemoField = class(TRaveBlobField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
  end; { TRaveMemoField }

  TRaveGraphicField = class(TRaveBlobField)
  protected
    function GetDataType: TRPDataType; override;
    function GetAsString: string; override;
  end; { TRaveGraphicField }

const
  DataFieldTypes: array[TRPDataType] of TRaveDataFieldClass =
   (TRaveStringField,TRaveIntegerField,TRaveBooleanField,TRaveFloatField,
   TRaveCurrencyField,TRaveBCDField,TRaveDateField,TRaveTimeField,
   TRaveDateTimeField,TRaveBlobField,TRaveMemoField,TRaveGraphicField,
   TRaveInt64Field);

  procedure RaveRegister;

implementation

uses
  RVData,
{$IFDEF DESIGNER}
  RVTool,
{$ENDIF}
  RVUtil,
  SysUtils;

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRaveComponents('',[TRaveStringField,TRaveIntegerField,
     TRaveBooleanField,TRaveFloatField,TRaveCurrencyField,TRaveBCDField,
     TRaveDateField,TRaveTimeField,TRaveDateTimeField,TRaveBlobField,
     TRaveMemoField,TRaveGraphicField]);
    RegisterRaveModuleClasses('RVData',[TRaveStringField,
     TRaveIntegerField,TRaveBooleanField,TRaveFloatField,TRaveCurrencyField,
     TRaveBCDField,TRaveDateField,TRaveTimeField,TRaveDateTimeField,
     TRaveBlobField,TRaveMemoField,TRaveGraphicField]);

  {$IFDEF DESIGNER}
    RegisterRaveProperties(TRaveDataField,
     {Beginner}     'FieldName;FullName;Description;DisplayFormat',
     {Intermediate} 'Calculated,NullText;Size',
     {Developer}    '',
     {Hidden}       '');

    SetPropDesc(TRaveDataField,{Trans-}'Calculated',Trans('!!!'));
    SetPropDesc(TRaveDataField,{Trans-}'Description',Trans('A description of the data field, ' +
     'usually paragraph-sized, that can be used to tell the purpose and usage of the ' +
     'field data.'));
    SetPropDesc(TRaveDataField,{Trans-}'FieldName',Trans('Defines the name of the field that ' +
     'the field component will retrieve the data from.'));
    SetPropDesc(TRaveDataField,{Trans-}'FullName',Trans('A single line descriptive name of ' +
     'the data field. Unlike the Name property, any letters including spaces can be used.'));
    SetPropDesc(TRaveDataField,{Trans-}'NullText',Trans('Defines the text to be printed ' +
     'if the field data is null (undefined).'));
    SetPropDesc(TRaveDataField,{Trans-}'Size',Trans('Defines the character width of the ' +
     'data field. This is normally used with design time activities such as ' +
     'dragging and dropping datatext components to determine an approximate ' +
     'width that it will take to print the component.'));

    SetPropDesc(TRaveFormattedField,{Trans-}'DisplayFormat',Trans('Defines the format codes ' +
     'that will be used to create a string representation of the field data.  See ' +
     'Appendix F in the Rave documentation for more details on formatting codes.'));

    SetPropDesc(TRaveBooleanField,{Trans-}'TextFalse',Trans('Defines the text that will be' +
     'printed if the field value is false.'));
    SetPropDesc(TRaveBooleanField,{Trans-}'TextTrue',Trans('Defines the text that will be' +
     'printed if the field value is true.'));
  {$ENDIF}
  {TransOn}
  end;  { RaveRegister }

(*****************************************************************************}
( class TRaveDataRow
(*****************************************************************************)

  destructor TRaveDataRow.Destroy;

  begin { Destroy }
    Clear;
    inherited Destroy;
  end;  { Destroy }

  procedure TRaveDataRow.MoveTo(Dest: TRaveDataRow);

  begin { MoveTo }
    Dest.Init(DataSize);
    Move(DataPtr^,Dest.DataPtr^,DataSize);
    Clear;
  end;  { MoveTo }

  procedure TRaveDataRow.Clear;

  begin { Clear }
    If Assigned(DataPtr) then begin
      FreeMem(DataPtr,DataSize);
      DataPtr := nil;
    end; { if }
    DataSize := 0;
  end;  { Clear }

  procedure TRaveDataRow.Init(Size: longint);

  begin { Init }
    Clear;
    DataSize := Size;
    GetMem(DataPtr,DataSize);
  end;  { Init }

  function TRaveDataRow.GetNativePtr(FieldIdx: integer): pointer;

  var
    I1: integer;

  begin { GetNativePtr }
    Result := nil;
    If not Assigned(DataPtr) then Exit;
    I1 := integer(pointer(DataPtr + (FieldIdx * 8))^);
    If I1 >= 0 then begin
      Result := DataPtr + I1;
    end; { if }
  end;  { GetNativePtr }

  function TRaveDataRow.GetFormattedPtr(FieldIdx: integer): pointer;

  var
    I1: integer;

  begin { GetFormattedPtr }
    I1 := integer(pointer(DataPtr + (4 + FieldIdx * 8))^);
    If I1 = 0 then begin
      Result := nil;
    end else begin
      Result := DataPtr + I1;
    end; { else }
  end;  { GetFormattedPtr }

  procedure TRaveDataRow.GetNativeData(    FieldIdx: integer;
                                       var CalcPtr: pointer;
                                       var CalcSize: longint);

  begin { GetNativeData }
    CalcPtr := GetNativePtr(FieldIdx);
    If Assigned(CalcPtr) then begin
      CalcSize := longint(CalcPtr^);
      Inc(PChar(CalcPtr),4);
    end else begin
      CalcSize := 0;
    end; { else }
  end;  { GetNativeData }

  function TRaveDataRow.GetFormattedData(FieldIdx: integer): string;

  var
    P1: pointer;
    I1: longint;

  begin { GetFormattedData }
    P1 := GetFormattedPtr(FieldIdx);
    If Assigned(P1) then begin
      I1 := longint(P1^);
      SetLength(Result,I1);
      If I1 > 0 then begin
        Inc(PChar(P1),4);
        Move(P1^,Result[1],I1);
      end; { if }
    end else begin
      Result := '';
    end; { else }
  end;  { GetFormattedData }

(*****************************************************************************}
( class TRaveDataField
(*****************************************************************************)

  constructor TRaveDataField.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    FSize := 10;
  end;  { Create }

  destructor TRaveDataField.Destroy;

  begin { Destroy }
    inherited Destroy;
  end;  { Destroy }

  function TRaveDataField.GetAsString: string;

  begin { GetAsString }
    Result := (Parent as TRaveBaseDataView).ActiveDataRow.GetFormattedData(DataIndex);
  end;  { GetAsString }

  function TRaveDataField.GetAsBoolean: boolean;

  begin { GetAsBoolean }
    Result := (AsInteger <> 0);
  end;  { GetAsBoolean }

  function TRaveDataField.GetAsInteger: longint;

  begin { GetAsInteger }
    Result := StrToIntDef(AsString,0);
  end;  { GetAsInteger }

  function TRaveDataField.GetAsInt64: Int64;

  begin { GetAsInt64 }
    Result := StrToInt64Def(AsString,0);
  end;  { GetAsInt64 }

  function TRaveDataField.GetAsFloat: extended;

  begin { GetAsFloat }
    Result := StrToFloatDef(AsString,0.0);
  end;  { GetAsFloat }

  function TRaveDataField.GetAsCurrency: currency;

  begin { GetAsCurrency }
    try
      Result := StrToCurr(AsString);
    except
      on EConvertError do Result := 0.0;
    end; { tryx }
  end;  { GetAsCurrency }

  function TRaveDataField.GetAsDate: TDate;

  begin { GetAsDate }
    try
      Result := StrToDate(AsString);
    except
      on EConvertError do Result := 0.0;
    end; { tryx }
  end;  { GetAsDate }

  function TRaveDataField.GetAsTime: TTime;

  begin { GetAsTime }
    try
      Result := StrToTime(AsString);
    except
      on EConvertError do Result := 0.0;
    end; { tryx }
  end;  { GetAsTime }

  function TRaveDataField.GetAsDateTime: TDateTime;

  begin { GetAsDateTime }
    try
      Result := StrToDateTime(AsString);
    except
      on EConvertError do Result := 0.0;
    end; { tryx }
  end;  { GetAsDateTime }

  function TRaveDataField.GetAsBlob: pointer;

  begin { GetAsBlob }
    Result := (Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex);
    If Assigned(Result) and (DataType in [dtString,dtBlob,dtMemo,dtGraphic]) then begin
      Result := PChar(Result) + 4;
    end; { if }
  end;  { GetAsBlob }

  function TRaveDataField.GetDataSize: longint;

  var
    DataPtr: pointer;

  begin { GetDataSize }
    Case DataType of
      dtInteger: Result := SizeOf(longint);
      dtBoolean: Result := Sizeof(boolean);
      dtFloat: Result := SizeOf(extended);
      dtCurrency,dtBCD: Result := SizeOf(currency);
      dtDate: Result := SizeOf(TDate);
      dtTime: Result := SizeOf(TTime);
      dtDateTime: Result := SizeOf(TDateTime);
      else begin { String, Blob, Memo or Graphic }
        (Parent as TRaveBaseDataView).ActiveDataRow.GetNativeData(DataIndex,DataPtr,
         Result)
      end;
    end; { case }
  end;  { GetDataSize }

  function TRaveDataField.GetIsNull: boolean;

  begin { GetIsNull }
    Result := (Parent as TRaveBaseDataView).Empty or not
     Assigned((Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex));
  end;  { GetIsNull }

  procedure TRaveDataField.SetFieldName(Value: string);

  begin { SetFieldName }
    If Value <> FFieldName then begin
      If FullName = StripJoinChars(FFieldName) then begin
        FullName := StripJoinChars(Value);
      end; { if }
      FFieldName := AddJoinChars(Value);
    end; { if }
  end;  { SetFieldName }

(*****************************************************************************}
( class TRaveStringField
(*****************************************************************************)

  function TRaveStringField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtString;
  end;  { GetDataType }

  function TRaveStringField.GetAsString: string;

  var
    CalcPtr: pointer;
    CalcSize: longint;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      Result := inherited GetAsString;
      If Result = '' then begin { Get data from native format }
        (Parent as TRaveBaseDataView).ActiveDataRow.GetNativeData(DataIndex,CalcPtr,
         CalcSize);
        SetLength(Result,CalcSize);
        If CalcSize > 0 then begin
          Move(CalcPtr^,Result[1],CalcSize);
        end; { if }
      end; { if }
    end; { else }
  end;  { GetAsString }

(*****************************************************************************}
( class TRaveIntegerField
(*****************************************************************************)

  function TRaveIntegerField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtInteger;
  end;  { GetDataType }

  function TRaveIntegerField.GetAsString: string;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      If DisplayFormat <> '' then begin
        Result := FormatFloat(DisplayFormat,AsInteger);
      end else begin
        Result := inherited GetAsString;
        If Result = '' then begin { Get data from native format }
          Result := IntToStr(AsInteger);
        end; { if }
      end; { else }
    end; { else }
  end;  { GetAsString }

  function TRaveIntegerField.GetAsInteger: longint;

  var
    P1: pointer;

  begin { GetAsInteger }
    P1 := (Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex);
    If Assigned(P1) then begin
      Result := longint(P1^);
    end else begin
      Result := StrToIntDef(NullText,0);
    end; { else }
  end;  { GetAsInteger }

  function TRaveIntegerField.GetAsInt64: Int64;

  begin { GetAsInt64 }
    Result := AsInteger;
  end;  { GetAsInt64 }

  function TRaveIntegerField.GetAsFloat: extended;

  begin { GetAsFloat }
    Result := AsInteger;
  end;  { GetAsFloat }

  function TRaveIntegerField.GetAsCurrency: currency;

  begin { GetAsCurrency }
    Result := AsInteger;
  end;  { GetAsCurrency }

(*****************************************************************************}
( class TRaveInt64Field
(*****************************************************************************)

  function TRaveInt64Field.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtInt64;
  end;  { GetDataType }

  function TRaveInt64Field.GetAsString: string;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      If DisplayFormat <> '' then begin
        Result := FormatFloat(DisplayFormat,AsInt64);
      end else begin
        Result := inherited GetAsString;
        If Result = '' then begin { Get data from native format }
          Result := IntToStr(AsInt64);
        end; { if }
      end; { else }
    end; { else }
  end;  { GetAsString }

  function TRaveInt64Field.GetAsInteger: longint;

  begin { GetAsInteger }
    Result := AsInt64;
  end;  { GetAsInteger }

  function TRaveInt64Field.GetAsInt64: Int64;

  var
    P1: pointer;

  begin { GetAsInt64 }
    P1 := (Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex);
    If Assigned(P1) then begin
      Result := Int64(P1^);
    end else begin
      Result := StrToInt64Def(NullText,0);
    end; { else }
  end;  { GetAsInt64 }

  function TRaveInt64Field.GetAsFloat: extended;

  begin { GetAsFloat }
    Result := AsInt64;
  end;  { GetAsFloat }

  function TRaveInt64Field.GetAsCurrency: currency;

  begin { GetAsCurrency }
    Result := AsInt64;
  end;  { GetAsCurrency }

(*****************************************************************************}
( class TRaveBooleanField
(*****************************************************************************)

  function TRaveBooleanField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtBoolean;
  end;  { GetDataType }

  function TRaveBooleanField.GetAsString: string;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      Result := inherited GetAsString;
      If AsBoolean then begin
        If TextTrue = '' then begin
          If Result = '' then begin
            Result := {Trans-}'True';
          end; { if }
        end else begin
          Result := TextTrue;
        end; { else }
      end else begin
        If TextFalse = '' then begin
          If Result = '' then begin
            Result := {Trans-}'False';
          end; { if }
        end else begin
          Result := TextFalse;
        end; { else }
      end; { else }
    end; { else }
  end;  { GetAsString }

  function TRaveBooleanField.GetAsBoolean: boolean;

  var
    P1: pointer;

  begin { GetAsBoolean }
    P1 := (Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex);
    If Assigned(P1) then begin
      Result := boolean(P1^);
    end else begin
      Result := (CompareStr(NullText,TextTrue) = 0);
    end; { else }
  end;  { GetAsBoolean }

(*****************************************************************************}
( class TRaveFloatField
(*****************************************************************************)

  function TRaveFloatField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtFloat;
  end;  { GetDataType }

  function TRaveFloatField.GetAsString: string;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      If DisplayFormat <> '' then begin
        Result := FormatFloat(DisplayFormat,AsFloat);
      end else begin
        Result := inherited GetAsString;
        If Result = '' then begin { Get data from native format }
          Result := FloatToStr(AsFloat);
        end; { if }
      end; { else }
    end; { else }
  end;  { GetAsString }

  function TRaveFloatField.GetAsInteger: longint;

  begin { GetAsInteger }
    Result := Trunc(AsFloat);
  end;  { GetAsInteger }

  function TRaveFloatField.GetAsInt64: Int64;

  begin { GetAsInt64 }
    Result := Trunc(AsFloat);
  end;  { GetAsInt64 }

  function TRaveFloatField.GetAsFloat: extended;

  var
    P1: pointer;

  begin { GetAsFloat }
    P1 := (Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex);
    If Assigned(P1) then begin
      Result := extended(P1^);
    end else begin
      Result := StrToFloatDef(NullText,0.0);
    end; { else }
  end;  { GetAsFloat }

  function TRaveFloatField.GetAsCurrency: currency;

  begin { GetAsCurrency }
    Result := AsFloat;
  end;  { GetAsCurrency }

(*****************************************************************************}
( class TRaveCurrencyField
(*****************************************************************************)

  function TRaveCurrencyField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtCurrency;
  end;  { GetDataType }

  function TRaveCurrencyField.GetAsString: string;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      If DisplayFormat <> '' then begin
        Result := FormatCurr(DisplayFormat,AsCurrency);
      end else begin
        Result := inherited GetAsString;
        If Result = '' then begin { Get data from native format }
          Result := CurrToStr(AsCurrency);
        end; { if }
      end; { else }
    end; { else }
  end;  { GetAsString }

  function TRaveCurrencyField.GetAsInteger: longint;

  begin { GetAsInteger }
    Result := Trunc(AsCurrency);
  end;  { GetAsInteger }

  function TRaveCurrencyField.GetAsInt64: Int64;

  begin { GetAsInt64 }
    Result := Trunc(AsCurrency);
  end;  { GetAsInt64 }

  function TRaveCurrencyField.GetAsFloat: extended;

  begin { GetAsFloat }
    Result := AsCurrency;
  end;  { GetAsFloat }

  function TRaveCurrencyField.GetAsCurrency: currency;

  var
    P1: pointer;

  begin { GetAsCurrency }
    P1 := (Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex);
    If Assigned(P1) then begin
      Result := currency(P1^);
    end else begin
      Result := StrToCurrDef(NullText,0.0);
    end; { else }
  end;  { GetAsCurrency }

(*****************************************************************************}
( class TRaveBCDField
(*****************************************************************************)

  function TRaveBCDField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtBCD;
  end;  { GetDataType }

(*****************************************************************************}
( class TRaveDateTimeField
(*****************************************************************************)

  function TRaveDateTimeField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtDateTime;
  end;  { GetDataType }

  function TRaveDateTimeField.GetAsString: string;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      If DisplayFormat <> '' then begin
        Result := FormatDateTime(DisplayFormat,AsDateTime);
      end else begin
        Result := inherited GetAsString;
        If Result = '' then begin { Get data from native format }
          Result := FormatDateTime('c',AsDateTime);
        end; { if }
      end; { else }
    end; { else }
  end;  { GetAsString }

  function TRaveDateTimeField.GetAsDateTime: TDateTime;

  var
    P1: pointer;

  begin { GetAsDateTime }
    P1 := (Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex);
    If Assigned(P1) then begin
      Result := TDateTime(P1^);
    end else begin
      Result := StrToDateTimeDef(NullText,0.0);
    end; { else }
  end;  { GetAsDateTime }

  function TRaveDateTimeField.GetAsDate: TDate;

  begin { GetAsDate }
    Result := Int(AsDateTime);
  end;  { GetAsDate }

  function TRaveDateTimeField.GetAsTime: TTime;

  begin { GetAsTime }
    Result := Frac(AsDateTime);
  end;  { GetAsTime }

  function TRaveDateTimeField.GetAsFloat: extended;

  begin { GetAsFloat }
    Result := AsDateTime;
  end;  { GetAsFloat }

(*****************************************************************************}
( class TRaveDateField
(*****************************************************************************)

  function TRaveDateField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtDate;
  end;  { GetDataType }

  function TRaveDateField.GetAsString: string;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      If DisplayFormat <> '' then begin
        Result := FormatDateTime(DisplayFormat,AsDate);
      end else begin
        Result := inherited GetAsString;
        If Result = '' then begin { Get data from native format }
          Result := FormatDateTime({Trans-}'ddddd',AsDate);
        end; { if }
      end; { else }
    end; { else }
  end;  { GetAsString }

  function TRaveDateField.GetAsDateTime: TDateTime;

  begin { GetAsDateTime }
    Result := AsDate;
  end;  { GetAsDateTime }

  function TRaveDateField.GetAsDate: TDate;

  var
    P1: pointer;

  begin { GetAsDate }
    P1 := (Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex);
    If Assigned(P1) then begin
      Result := TDate(P1^);
    end else begin
      Result := Int(StrToDateTimeDef(NullText,0.0));
    end; { else }
  end;  { GetAsDate }

  function TRaveDateField.GetAsTime: TTime;

  begin { GetAsTime }
    Result := 0.0;
  end;  { GetAsTime }

(*****************************************************************************}
( class TRaveTimeField
(*****************************************************************************)

  function TRaveTimeField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtTime;
  end;  { GetDataType }

  function TRaveTimeField.GetAsString: string;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      If DisplayFormat <> '' then begin
        Result := FormatDateTime(DisplayFormat,AsTime);
      end else begin
        Result := inherited GetAsString;
        If Result = '' then begin { Get data from native format }
          Result := FormatDateTime('t',AsTime);
        end; { if }
      end; { else }
    end; { else }
  end;  { GetAsString }

  function TRaveTimeField.GetAsDateTime: TDateTime;

  begin { GetAsDateTime }
    Result := AsTime;
  end;  { GetAsDateTime }

  function TRaveTimeField.GetAsDate: TDate;

  begin { GetAsDate }
    Result := 0.0;
  end;  { GetAsDate }

  function TRaveTimeField.GetAsTime: TTime;

  var
    P1: pointer;

  begin { GetAsTime }
    P1 := (Parent as TRaveBaseDataView).ActiveDataRow.GetNativePtr(DataIndex);
    If Assigned(P1) then begin
      Result := TTime(P1^);
    end else begin
      Result := Frac(StrToDateTimeDef(NullText,0.0));
    end; { else }
  end;  { GetAsTime }

(*****************************************************************************}
( class TRaveBlobField
(*****************************************************************************)

  function TRaveBlobField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtBlob;
  end;  { GetDataType }

  function TRaveBlobField.GetAsString: string;

  var
    CalcPtr: pointer;
    CalcSize: longint;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      (Parent as TRaveBaseDataView).ActiveDataRow.GetNativeData(DataIndex,CalcPtr,
       CalcSize);
      SetLength(Result,CalcSize);
      If CalcSize > 0 then begin
        Move(CalcPtr^,Result[1],CalcSize);
      end; { if }
    end; { else }
  end;  { GetAsString }

(*****************************************************************************}
( class TRaveMemoField
(*****************************************************************************)

  function TRaveMemoField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtMemo;
  end;  { GetDataType }

  function TRaveMemoField.GetAsString: string;

  var
    CalcPtr: pointer;
    CalcSize: longint;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      (Parent as TRaveBaseDataView).ActiveDataRow.GetNativeData(DataIndex,CalcPtr,
       CalcSize);
      SetLength(Result,CalcSize);
      If CalcSize > 0 then begin
        Move(CalcPtr^,Result[1],CalcSize);
      end; { if }
    end; { else }
  end;  { GetAsString }

(*****************************************************************************}
( class TRaveGraphicField
(*****************************************************************************)

  function TRaveGraphicField.GetDataType: TRPDataType;

  begin { GetDataType }
    Result := dtGraphic;
  end;  { GetDataType }

  function TRaveGraphicField.GetAsString: string;

  begin { GetAsString }
    If IsNull then begin
      Result := NullText;
    end else begin
      Result := inherited GetAsString;
      If Result = '' then begin { Get data from native format }
        Result := {Trans-}'(Graphic)';
      end; { if }
    end; { else }
  end;  { GetAsString }

initialization
  RegisterProc('RVCL',RaveRegister);
end.
