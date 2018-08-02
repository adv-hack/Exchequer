unit GuiVar;

interface

uses
  GlobVar, Classes;

Type
  {$IFDEF GUI}
  TGUIFieldRec = Record
    FieldNo     : Longint;
    DecPlaces   : Byte;
    CalcField   : Boolean;
    FieldLen    : Integer;
    Currency    : Byte;
    Period,
    Year        : String[5];
    SortType    : String[2];
    RecSel      : String[100];
    VarRef      : String[10];
    Value       : String[100];
    Calculation : String[100];
    FormatMask  : String[2];
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

  {$ENDIF}


implementation

end.
