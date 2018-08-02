unit CtrlPrms;

{$ALIGN 1}

interface

uses
  Dialogs, SysUtils, Types;

type
  TCtrlType = ( BASE_CONTROL, REPORT_TEXT, REPORT_LINE, REPORT_FORMULA, REPORT_DB_FIELD, REPORT_ROW,
                  REPORT_TEXT_BOX, REPORT_IMAGE, LAST_CONTROL );
                  
  TLineOrientation = ( VERTICAL, HORIZONTAL );

  TAlignType = ( ALIGN_TOP, ALIGN_BOTTOM, ALIGN_LEFT, ALIGN_RIGHT );

  TControlStatus = word;

  TCtrlNumber = Smallint;

  PRegionParams = ^TRegionParams;
  TRegionParams = record
    rpRegionName : string[250]; // 251 bytes
    cFiller : Char;
    rpWidth : Integer;  // 4 bytes
    rpTop   : Integer;  // 4 bytes
    rpHeight : Integer; // 4 bytes
    rpRegionVisible : Boolean; // 1 byte
    rpNextCtrlNumber : TCtrlNumber; // 2 bytes
  end;

  TFontParams = record  // 265 bytes
    Name : Shortstring; // 256 bytes
    Size : integer;     // 4 bytes
    Style : byte;       // 1 byte - enumerated type
    Color : integer;    // 4 bytes
  end;

  TPenParams = record // 10 bytes
    Color : integer;  // 4 bytes
    Mode  : byte;     // 1 byte - enumerated type
    Style : byte;     // 1 byte - enumerated type
    Width : integer;  // 4 bytes
  end;

  TTextParams = record
    cpCaption : ShortString;  // 256 bytes
    cpFont    : TFontParams;  // 265 bytes
    Filler : array[1..1508] of char; // 2029 bytes in total
  end;

  TLineParams = record
    LineOrientation : TLineOrientation; // 1 byte - enumerated type
    LineLength : Integer;               // 4 bytes
    PenParams : TPenParams;             // 10 bytes
    Filler : array[1..2014] of char; // 2029 bytes in total
  end;

  TTotalType = (NO_TOTAL, TOTAL_FIELD, COUNT_FIELD, RANGE_FILTER_FIELD, CALC_FIELD );

  TFormulaParams = record
    cpCaption : string[30];  // 31 bytes
    cpComments : string[250]; // 251 bytes
    cpFont    : TFontParams; // 265 bytes
    cpFormulaDefinition : string[255]; // 256 bytes
    cpDecimalPlaces : Byte;
    cpTotalType : TTotalType; // 1 byte
    cpFieldFormat : string[5]; // 6 bytes
    cpPrintIfCriteria : string[120]; // 121 bytes
    cpFormulaName : string[30]; // 31 bytes
    cpSortOrder : string[5]; // 6 bytes
    cpPrintField : Boolean; // 1 byte
    cpFieldIdx : SmallInt; // 2 bytes
    cpPeriod : string[9]; // 10 bytes       // HM 08/03/05: Added Period/Year to Formula Controls
    cpYear : string[9];   // 10 bytes       // HM 08/03/05: Added Period/Year to Formula Controls
    cpCurrency : Byte;    // 1 byte
    Filler : array[1..1036] of char; // 2029 bytes in total
  end;

  TInputLineRecord = record      // 412 bytes
    ssID: Integer;
    ssName : String[50];    // 51 bytes
    ssDescription : ShortString; // 256 bytes
    siType : SmallInt;           // 2 bytes
    bAlwaysAsk : Boolean;        // 1 byte
    ssFromValue, ssToValue : String[50]; // 51 bytes ea.
  end;
  PInputLineRecord = ^TInputLineRecord;

  TDBFieldParams = record
    cpCaption : ShortString;   // 256 bytes
    cpFont    : TFontParams;   // 265 bytes
    cpDBFieldName : string[35];// 36 bytes
    cpSortOrder   : string[5]; // 6 bytes
    cpFieldFormat : string[5]; // 6 bytes
    cpSelectCriteria  : string[120]; // 121 bytes
    cpPrintIfCriteria : string[120]; // 121 bytes
    cpPrintField  : Boolean;   // 1 byte
    cpSubTotal    : Boolean;   // 1 byte
    cpPageBreak   : Boolean;   // 1 byte
    cpRecalcBreak : Boolean;   // 1 byte
    cpSelectSummary : Boolean; // 1 byte
    cpInputLine : TInputLineRecord;  // 412 bytes
    cpVarNo : LongInt;       // 4 bytes
    cpVarLen : Byte;         // 1 byte
    cpVarDesc : string[30];  // 31 bytes
    cpVarType : Byte;        // 1 byte
    cpVarNoDecs : Byte;      // 1 byte
    cpPeriodField : Boolean; // 1 byte
    cpPeriod : string[9]; // 10 bytes
    cpYear : string[9];   // 10 bytes
    cpParsedInputLine : ShortString; // 256 bytes
    cpCurrency : Byte;    // 1 byte
    cpFieldIdx : SmallInt; // 2 bytes
    Filler : array[1..483] of char; // 2029 bytes in total     
  end;

  TDBRowParams = record
    Filler : array[1..2029] of char; // 2029 bytes in total
  end;

  PTextBoxParams = ^TTextBoxParams;
  TTextBoxParams = record
    Filler : array[1..2029] of char; // 2029 bytes in total
  end;

  PImageParams = ^TImageParams;
  TImageParams = record
    BitMapWidth : Integer;  // 4 bytes
    BitMapHeight : Integer; // 4 bytes
    // used to indentify the bitmap in the list of bitmaps that will be stored at the end of the report file.
    // read the image parameters and then read the bitmaps from the end of the file. Once a list of bitmaps
    // has been created match up the bitmap list with the bitmap parameters.
    BitMapFolio : string[8]; // 9 bytes
    Filler : array[1..2012] of char; // 2029 bytes in total
  end;

  PCtrlParams = ^TCtrlParams;
  TCtrlParams = record        // 2048 bytes in total
    cpCtrlType : TCtrlType;   // 1 byte  - enumerated type
    cpRegionPoint : TPoint;   // 8 bytes - TPoint is a record of two LongInts
    cpCtrlWidth,              // 4 bytes
    cpCtrlHeight : Integer;   // 4 bytes
    cpZOrder : SmallInt;      // 2 bytes
    case TCtrlType of
      REPORT_TEXT     : (TextParams : TTextParams);
      REPORT_LINE     : (LineParams : TLineParams);
      REPORT_FORMULA  : (FormulaParams : TFormulaParams);
      REPORT_DB_FIELD : (DBFieldParams : TDBFieldParams);
      REPORT_ROW      : (DBRowParams : TDBRowParams);
      REPORT_TEXT_BOX : (TextBoxParams : TTextBoxParams);
      REPORT_IMAGE    : (ImageParams : TImageParams);
      LAST_CONTROL    : (Filler : array[1..2029] of char);
  end;

  TInputParamObj = class(TObject)
  public
    DBFieldName : ShortString;
    InputParams : TInputLineRecord;
    DBVarType : Byte;

    constructor Create;
    destructor Destroy; override;
  end;


implementation

constructor TInputParamObj.Create;
begin
  inherited Create;

  DBFieldName := '';
  with InputParams do
  begin
    ssName := '';
    ssDescription := '';
    siType := 0;
    bAlwaysAsk := TRUE;
    ssFromValue := '';
    ssToValue := '';
  end;
  DBVarType := 0;
end;

destructor TInputParamObj.Destroy;
begin
  inherited Destroy;
end;

Initialization
  If (SizeOf(TFormulaParams) <> 2029) Then ShowMessage ('CtrlPrms Error: TFormulaParams is ' + IntToStr(SizeOf(TFormulaParams)) + ' bytes');
end.
