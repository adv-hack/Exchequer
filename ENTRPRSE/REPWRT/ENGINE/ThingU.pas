unit thingU;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  GlobType, RwRecurse, MCParser, DicLnk2U, GuiVar;

type
  TGetPeriodProc = function(const DBFCode : string) : DictLinkType of Object;

  TThing = Class
    { Events called by Parser }
  private
    Recurse        : TRecurseCheck;
    FWantPeriod    : Boolean;
    FDicLink       : DictLinkType;
    Function  GetFieldText (Const ShortCode : String;
                            Const TheDecs   : Byte;
                            Const PixWidth  : LongInt;
                            Const BlankZero : Boolean) : ResultValueType;
    Function  GetFormulaText (Const TheFormula : String;
                              Const TheDecs    : Byte;
                              Const PixWidth   : LongInt;
                              Const BlankZero : Boolean) : ResultValueType;

  public
    DrivingFile : Integer;
    StringRec : fdFormStringsType;
    PixWidth : longint;
    TestMode : Boolean;
    LinePtr : RepLinePtr;
    GetPeriod : TGetPeriodProc;

    constructor Create;
    destructor Destroy; override;
    Function  GetDBFEvent (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType;
    Function  GetFMLEvent (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType;
    Function FormatDate (Const DateCode : String;
                         Const Units    : SmallInt;
                         Const OffUnits : Char;
                         Const Format   : SmallInt) : ResultValueType;
    procedure SetPeriodDetails(DicLink : DictLinkType; WantPeriod : Boolean);
  end;

implementation

uses
  RwOpenF, VarConst, {DataDict,} SysUtils, DicLinkU, Parser, EtMiscU,
  TEditVal, BTSupU1, EtDateU, GlobVar, Ddfuncs, Dialogs;

const
  FormWidth = 80;

Function IsNumFormat(Const NumStr : ShortString) : Boolean;
Var
  I : SmallInt;
Begin
  Result := False;

  If (Length(NumStr) > 0) Then Begin
    Result := True;

    For I := 1 To Length(NumStr) Do
      If Not (NumStr[I] In ['.', ',', '+', '-', '0'..'9']) Then Begin
        { Invalid Character }
        Result := False;
        Break;
      End; { If }
  End; { If }
End;


function LJVar(const Value : ShortString; len : integer) : ShortString;
begin
  Result := Value + StringOfChar(' ', len);
  Result := Copy(Result, 1, len);
end;

constructor TThing.Create;
begin
  inherited Create;
  TestMode := False;
  Recurse := TRecurseCheck.Create;
end;

destructor TThing.Destroy;
begin
  if Assigned(Recurse) then
    Recurse.Free;
  inherited Destroy;
end;



Function TThing.GetDBFEvent (Const FieldCode : String;
                             Const Decs  : Byte) : ResultValueType;
begin
  Result := GetFieldText (LJVar(FieldCode, 8), Decs, FormWidth, False);
end;

Function TThing.GetFMLEvent (Const FieldCode : String;
                             Const Decs  : Byte) : ResultValueType;
Var
  I : Integer;
  Formula : string;
Begin
{DBug.MsgI (0, 'GetFMLEvent: ' + FieldCode, 3);}
  Result.StrResult := '';
  Result.DblResult := 0.00;

  If Recurse.StartCheck(FieldCode) Then Begin
    { Find the formula field }

(*    If (Formulas.Count > 0) Then
      For I := 0 To (Formulas.Count - 1) Do
        With TFormDefListObjType(Formulas.Items[I]), FormDef Do Begin
          If (UpperCase(Trim(fdControlId)) = UpperCase(Trim(FieldCode))) Then
            { Check it should be printed }
            If WantPrint (FormDef) Then
              { Calculate the formula value }
              Result := GetFormulaText (Formula.ffFormula, Formula.ffDecs{Decs}, FormWidth, False);
{        End; { With }   *)

    Recurse.EndCheck(FieldCode);
  End; { If }

end;


Function TThing.GetFieldText (Const ShortCode : String;
                                       Const TheDecs   : Byte;
                                       Const PixWidth  : LongInt;
                                       Const BlankZero : Boolean) : ResultValueType;
Var
  DictLink     : DictLinkType;
  DataRec      : DataDictRec;
  FieldMask    : Str255;
  SourceFile   : Integer;
  TmpDriveFile : Integer;
//  StringRec    : fdFormStringsType;
Begin
{DBug.MsgI (0, 'GetFieldText: ' + ShortCode, 3);}
  Result.StrResult := '';
  Result.DblResult := 0.00;

  { Get Dictionary Record }
  If GetDDField (UpperCase(ShortCode), DictRec^) Then Begin

    if DictRec^.DataVarRec.PrSel then
    begin
{      if FWantPeriod then
        DictLink := FDicLink
      else}
        DictLink := GetPeriod({ShortCode + }IntToStr(FieldNumber));
    end;
(*    With DictLink Do Begin
      DCr  := 0;
      DPr  := {99}254;
      DYr  := {149}Syss.CYr;
    End; { With } *)

    { Need to pass in a Report Writer file number for some of }
    { the relational linking. Otherwise it will be looking at }
    { the wrong record and give us rubbish                    }
(*    Case FormPurpose Of
      fmDocSerialNo     : Begin
                            TmpDriveFile := IDetailF;
                            SourceFile := 4; { Report Writer Document Details }
                          End;
      fmStateAgeMnth    : Begin
                            TmpDriveFile := InvF;
                            SourceFile := 3; { Report Writer Document Header }
                          End;
      // HM 15/02/01: Added support ADJ Hidden lines and Sorting turned on
      fmADJSort         : Begin
                            TmpDriveFile := IdetailF;
                            SourceFile := 4; { Report Writer Document Header }
                          End;
     // HM 15/02/01: Added support for sorting Transaction Lines
     fmTransSort        : Begin
                            TmpDriveFile := IdetailF;
                            SourceFile := 4; { Report Writer Document Header }
                          End;
    Else *)
      TmpDriveFile := DrivingFile;
      If (TmpDriveFile = IDetailF) Then
        SourceFile := 4
      else
        SourceFile := 0;
(*    End; { Else }*)

    { Get field value from database - in string format }
 //   DDosMode := False;
    Result.StrResult := Link_Dict(DictRec^.DataVarRec.VarNo,
                                  DictLink,
                                  StringRec,
                                  PixWidth,
                                  TmpDriveFile{DrivingFile},
                                  SourceFile,
                                  '');

    { Reformat according to type }
    Case DictRec^.DataVarRec.VarType Of
      { String }
      1       : Begin
                 //PR: 7/3/03 - Was causing a problem with numberic ac or stk codes
                 (* If IsNumFormat(Result.StrResult) Then Begin
                    { Return numerical value, if any, as well }
                    Result.DblResult := DoubleStr(Result.StrResult);
                    Result.DblResult := Round_Up(Result.DblResult, TheDecs);
                  End { If }
                  Else *)
                    Result.DblResult := 0.0;
                End;
      { Real, Double }
      2, 3    : Begin
                  { Get value of field from string }
                  Result.DblResult := DoubleStr(Result.StrResult);
                  Result.DblResult := Round_Up(Result.DblResult, TheDecs);

                  If BlankZero And (Result.DblResult = 0.0) Then
                    { Blank if value is 0 }
                    Result.StrResult := ''
                  Else Begin
                    { Generate a new mask with the correct decimals }
                    FieldMask := FormatDecStrSD (TheDecs, GenRealMask, BOff);

                    { reformat field into what it should look like }
                    Result.StrResult := FormatFloat (FieldMask, Result.DblResult);
                  End; { If }
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

                  If BlankZero And (Result.DblResult = 0.0) Then
                    { Blank if value is 0 }
                    Result.StrResult := '';
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
  End { If }
  Else
  begin
    Result.StrResult := 'Error!';
    LinePtr^.VErrCode := veBadField;
    LinePtr^.VErrMsg  := 'Invalid database field ' + QuotedStr(Trim(ShortCode));
    LinePtr^.VErrWord := Trim(ShortCode);
  end;
{DBug.Msg (0, 'StrResult: ' + Result.StrResult);
DBug.Msg (0, 'DblResult: ' + FloatToStr(Result.DblResult));
DBug.Indent (-3);}
End;


{************************************************************************}
{* GetFormulaText: Returns a string containing the text for the formula *}
{************************************************************************}
Function TThing.GetFormulaText (Const TheFormula : String;
                                         Const TheDecs    : Byte;
                                         Const PixWidth   : LongInt;
                                         Const BlankZero  : Boolean) : ResultValueType;
Var
  ParserObj : TParserObj;
  IVType    : Byte;
  TmpStr    : ShortString;
Begin
{DBug.MsgI (0, 'GetFormulaText: ' + TheFormula, 3);}
 // FormWidth := PixWidth;

  { Create new instance of the parser object }
  ParserObj := TParserObj.Create;

  { Set event links }
  ParserObj.GetDBFEvent := GetDBFEvent;
  ParserObj.GetFMLEvent := GetFMLEvent;
{  ParserObj.GetTBCEvent := GetTBCEvent;
  ParserObj.GetTBPEvent := GetTBPEvent;
  ParserObj.GetTBTEvent := GetTBTEvent;
  ParserObj.GetTRWEvent := GetTRWEvent;}
{  ParserObj.GetDocSignEvent := GetDocSign;
  ParserObj.GetCustNoteEvent := GetCustNote;
  ParserObj.GetSuppNoteEvent := GetSuppNote;
  ParserObj.GetInvNoteEvent := GetInvNote;
  ParserObj.GetStockNoteEvent := GetStockNote;
  ParserObj.GetSNoNoteEvent := GetSNoNote;
  ParserObj.GetJobNoteEvent := GetJobNote;
  ParserObj.GetPageNoEvent := GetPageNo;
  ParserObj.GetIdQtyEvent := GetIdQtyNo;
  ParserObj.GetFmtDateEvent := FormatDate;
  ParserObj.GetCcyEvent := GetCurrRate;
  ParserObj.GetCcyAgeEvent := GetCurrAgeing;}

  { Add Formula into Recursion Checking }
  Recurse.SetFormula(2, TheFormula);

  { Parse the formula }
  Result.StrResult := ParserObj.SetFormula(TheFormula, TheDecs, IVType, False);

  { Check to see if its a number }
  If IsNumFormat(Result.StrResult) Then Begin
    { Reformat StrResult if necessary for DoubleStr to work}
    If (Result.StrResult[Length(Result.StrResult)] = '-') Then
      { Need to move - sign to start }
      TmpStr := Result.StrResult[Length(Result.StrResult)] + Copy (Result.StrResult, 1, Length(Result.StrResult) - 1)
    Else
      TmpStr := Result.StrResult;
    Result.DblResult := DoubleStr(TmpStr);

    { Set To Blank If Zero }
    If BlankZero And (Result.DblResult = 0.00) And (Not (TheFormula[1] In ['"', '~'])) Then Begin
      Result.StrResult := '';
    End; { If }
  End { If }
  Else
    Result.DblResult := 0.0;

  { Free the parser }
  ParserObj.Free;
{DBug.Msg (0, 'StrResult: ' + Result.StrResult);
DBug.Msg (0, 'DblResult: ' + FloatToStr(Result.DblResult));
DBug.Indent (-3);}
End;

Function TThing.FormatDate (Const DateCode : String;
                            Const Units    : SmallInt;
                            Const OffUnits : Char;
                            Const Format   : SmallInt) : ResultValueType;
type
  PDayTable = ^TDayTable;
  TDayTable = array[1..12] of Word;

Var
  DataDRec      : {^DataDict.}^RWOpenF.DataDictRec;
  tDD, tMM, tYY : Word;
  DictLink      : DictLinkType;
  SourceFile    : Integer;
  TmpDriveFile  : Integer;
  DelphiDate    : TDateTime;
  TmpStr        : ShortString;

  function IsLeapYear(Year: Word): Boolean;
  begin
    Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
  end;

  function GetDayTable(Year: Word): PDayTable;
  const
    DayTable1: TDayTable = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    DayTable2: TDayTable = (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    DayTables: array[Boolean] of PDayTable = (@DayTable1, @DayTable2);
  begin
    Result := DayTables[IsLeapYear(Year)];
  end;

Begin
{DBug.MsgI (0, 'FormatDate Begin', 3);
DBug.Msg (1, '  DateCode: ' + DateCode);
DBug.Msg (1, '  Units: ' + IntToStr(Units));
DBug.Msg (1, '  OffUnits: ' + OffUnits);
DBug.Msg (1, '  Format: ' + IntToStr(Format));}

  Try
    New(DataDRec);

    Result.StrResult := 'FormatDate('+DateCode+','+IntToStr(Units)+','+OffUnits+','+IntToStr(Format)+')';
    Result.DblResult := 0.0;

    { Get Data Dictionary record }
    If GetDDField (DateCode, DataDRec^) Then Begin
      { check its a date }
      If (DataDRec^.DataVarRec.VarType = 4) Then Begin
        { Retrieve date - have to call directly to avoid formatting }
        With DictLink Do Begin
          DCr  := 0;
          DPr  := 254;
          DYr  := Syss.CYr;
        End; { With }

        { Need to pass in a Report Writer file number for some of }
        { the relational linking. Otherwise it will be looking at }
        { the wrong record and give us rubbish                    }
(*        Case FormPurpose Of
          fmDocSerialNo     : Begin
                                TmpDriveFile := IDetailF;
                                SourceFile := 4; { Report Writer Document Details }
                              End;
          fmStateAgeMnth    : Begin
                                TmpDriveFile := InvF;
                                SourceFile := 3; { Report Writer Document Header }
                              End;
        Else          *)
          TmpDriveFile := DrivingFile;
          If (TmpDriveFile = IDetailF) Then
            SourceFile := 4
          else
            SourceFile := 0;
{        End; { Else }

        { Get field value from database - in string format }
        DDosMode := False;
        Result.StrResult := Link_Dict(DataDRec^.DataVarRec.VarNo,
                                      DictLink,
                                      StringRec,
                                      1000,
                                      TmpDriveFile,
                                      SourceFile,
                                      '');
        if TestMode then
          Result.StrResult := '20010101';
        DateStr(Result.StrResult, tDD, tMM, tYY);

{DBug.Msg (1, '  tDD: ' + IntToStr(tDD));
DBug.Msg (1, '  tMM: ' + IntToStr(tMM));
DBug.Msg (1, '  tYY: ' + IntToStr(tYY));}

        { Calulate any offset }
        If (OffUnits In ['D', 'F', 'L', 'M', 'Y']) Then Begin
          { Adjust }
          Case OffUnits Of
            'D' : If (Units <> 0) Then Begin { Day Offset }
                    { adjust }
                    JulCal(CalJul(tDD,tMM,tYY)+Units,tDD,tMM,tYY);
                  End;
            'F' : Begin { First Of Month }
                    If (Units <> 0) Then Begin
                      AdjMnth(tMM, tYY, Units);
                    End; { If }

                    tDD := 1;
                  End;
            'L' : Begin { Last Of Month }
                    If (Units <> 0) Then Begin
                      AdjMnth(tMM, tYY, Units);
                    End; { If }

                    tDD := GetDayTable(tYY)[tMM];
                  End;
            'M' : If (Units <> 0) Then Begin { Month Offset }
                    AdjMnth(tMM, tYY, Units);

                    If (tDD > GetDayTable(tYY)[tMM]) Then
                      tDD := GetDayTable(tYY)[tMM];
                  End;
            'Y' : If (Units <> 0) Then Begin { Year Offset }
                    tYY := tYY + Units;
                  End;
          End; { Case }
        End; { If }


{DBug.Msg (1, '  tDD: ' + IntToStr(tDD));
DBug.Msg (1, '  tMM: ' + IntToStr(tMM));
DBug.Msg (1, '  tYY: ' + IntToStr(tYY));}

        { Convert to specified format }
        Case Format Of
          { Standard Enterprise }
          1  : Begin
                 Result.StrResult := POutDate(StrDate(tYY,tMM,tDD));
               End;

          { 2  : Windows Short }
          { 3  : Windows Long }
          { 4  : Enterprise Internal }
          { 5  : Julian }

          { 10 : Day }
          { 11 : Day with leading zero }
          { 12 : Day - Short String }
          { 13 : Day - Long String }
          { 14 : Day -

          { 20 : Month }
          { 21 : Month with leading zero }
          { 22 : Month - Short String }
          { 23 : Month - Long String }

          { 30 : 2 digit year }
          { 31 : 4 digit year }
          2..5,
          10..14,
          20..23,
          30,31  : Begin
                     { Convert to a Delphi format Date }
                     DelphiDate := EncodeDate(tYY, tMM, tDD);

                     Case Format Of
                       2  : Result.StrResult := FormatDateTime({Orig_}ShortDateFormat, DelphiDate);
                       3  : Result.StrResult := FormatDateTime(LongDateFormat, DelphiDate);
                       4  : Result.StrResult := FormatDateTime('YYYYMMDD', DelphiDate);
                       5  : Begin
                              Result.StrResult := SysUtils.Format('%0.0f', [DelphiDate]);
                              Result.DblResult := DelphiDate;
                            End;

                       10 : Result.StrResult := FormatDateTime('d', DelphiDate);
                       11 : Result.StrResult := FormatDateTime('dd', DelphiDate);
                       12 : Result.StrResult := FormatDateTime('ddd', DelphiDate);
                       13 : Result.StrResult := FormatDateTime('dddd', DelphiDate);
                       14 : Begin
                              Result.StrResult := IntToStr(tDD);

                              If (tdd In [1, 21, 31]) Then
                                { st }
                                Result.StrResult := Result.StrResult + 'st'
                              Else
                                If (tdd In [2, 22]) Then
                                  { nd }
                                  Result.StrResult := Result.StrResult + 'nd'
                                Else
                                  If (tdd In [3, 23]) Then
                                    { rd }
                                    Result.StrResult := Result.StrResult + 'rd'
                                  Else
                                    If (tdd In [4..20, 24..30]) Then
                                      { th }
                                      Result.StrResult := Result.StrResult + 'th';
                            End;

                       20 : Result.StrResult := FormatDateTime('m', DelphiDate);
                       21 : Result.StrResult := FormatDateTime('mm', DelphiDate);
                       22 : Result.StrResult := FormatDateTime('mmm', DelphiDate);
                       23 : Result.StrResult := FormatDateTime('mmmm', DelphiDate);

                       30 : Result.StrResult := FormatDateTime('yy', DelphiDate);
                       31 : Result.StrResult := FormatDateTime('yyyy', DelphiDate);
                     Else
                       { Enterprise Standard }
                       Result.StrResult := POutDate(StrDate(tYY,tMM,tDD));
                     End; { Case }
                   End;
        Else
          { Unknown - use standard enterprise format }
          Result.StrResult := POutDate(StrDate(tYY,tMM,tDD));
        End; { Case }
      End; { If }
    End; { If }

    Dispose(DataDRec);
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occurred in FMTDATE(' + Trim(DateCode) + ',' +
                                                               IntToStr(Units) + ',' +
                                                               OffUnits + ',' +
                                                               IntToStr(Format) + '):' + #13#13 +
                  '"' + Ex.Message + '".', mtError, [mbOk], 0);
  End;

{DBug.Indent (-3);
DBug.Msg (0, 'FormatDate End');}
End;




procedure TThing.SetPeriodDetails(DicLink: DictLinkType; WantPeriod : Boolean);
begin
  FWantPeriod := WantPeriod;
  if FWantPeriod then
    FDicLink := DicLink
  else
    FillChar(FDicLink, SizeOf(FDicLink), 0);
end;

end.
