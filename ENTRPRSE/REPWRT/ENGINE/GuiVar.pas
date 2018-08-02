unit GuiVar;

interface

uses
  GlobVar, Classes, SysUtils, GlobType;

const
  {constants for filter validation}
  veBadInput    = 1;
  veBadField    = 2;
  veBadLogic    = 3;
  veBadOperator = 4;
  veBadSyntax   = 5;
  veBadElement  = 6;
  veStackSize   = 7;
  veMissingBracket = 8;
  veNoCustomFunc = 9;


Type

  TGUIFieldRec = Record
    FieldNo     : Longint;
    VarNo       : longint;
    DecPlaces   : Byte;
    CalcField   : Boolean;
    FieldLen    : Integer;
    Currency    : Byte;
    Period,
    Year        : String[5];
    SortType    : String[2];
    RecSel      : ShortString;
    Filter      : ShortString;
    PrintSel    : ShortString;
    PrintFilter : ShortString;
    RangeFilter : ShortString;
    VarRef      : String[10];
    Value       : ShortString;
    Calculation : ShortString;
    CalcHolder  : ShortString;
    FormatMask  : String[2];
    PeriodField : Boolean;
    Name   : ShortString;
    DataType : Byte;
    FInputLink : Integer;
  end;


  TGUIInputRec = Record
    InputType : Byte;
    InputNo : Byte;
    Case Byte of
      1  :  (VarSubSplit  :  String[100]);
      2  :  (ASCStr       :  Array[1..2] of String[30]); {Input Values}
      3  :  (DRange       :  Array[1..2] of LongDate);
      4  :  (VRange       :  Array[1..2] of Real);
      5  :  (PrRange      :  Array[1..2,1..2] of Byte);
      6  :  (PrIRange     :  Array[1..4] of Byte);
      7  :  (CrRange      :  Array[1..2] of Byte);
  end;

  TGetFieldEvent = function (var GRec : TGUIFieldRec) : Integer of Object;
  TGetInputEvent = function (var GRec : TGUIInputRec) : Integer of Object;

  TOnSelectRecordProc = procedure(ARec : TStrings) of Object;
  TOnCheckRecordProc = procedure(Count, Total : integer; Var Abort : Boolean) of Object;
  TGetCustomValueFunc = function (const ValueIdentifier, ValueName : string;
                                    var ErrorCode : SmallInt;
                                    var ErrorString : ShortString;
                                    var ErrorWord : ShortString) : ResultValueType of Object;
  TFieldNotifyProc = procedure (const FieldName : String) of Object;
  TFieldProc = procedure (FieldNo : Integer) of Object;

  TFieldFromNameProc = function (const AName : string) : TGUIFieldRec of Object;
  TFieldValueByNameProc = procedure(const FieldName  : string;
                              const FieldValue : string) of Object;
  TFieldValueByNumberProc = procedure(FieldNo : Integer;
                              const FieldValue : string) of Object;

  //PR: 10/11/2015 ABSEXCH-15491 Function to check SQL records for line count in selection
  TCheckRecordSQLFunc = function : Boolean of Object;


  //PR: 22/02/2011
  TDrillDownRec = Record
    OffSet : Integer;
    FileNo : Byte;
    IndexNo : Byte;
  end;

  TPrintIfObj = Class
    WantPrint : Boolean;
    DrillDownRec : TDrillDownRec;
    DrillDownKey : ShortString;
  end;

  EInvalidInput = Class(Exception);


const
  LINE_COUNTER = 90002;

implementation

end.
