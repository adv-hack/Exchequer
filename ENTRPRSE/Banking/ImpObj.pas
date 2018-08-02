unit ImpObj;

interface

uses
  Classes, Enterprise04_TLB, Csvp;

type
  TProgressProc = procedure (Sender : TObject; CurrentRec, TotalRec : longint) of Object;
  TImportFileType = (iftCSV, iftFixedLength);

  TStatementImporter = Class
  private
    FParser   : TCSVFileParser;
    FMapFile  : TStringList;
    FMapFileName,
    FFilename : string;
    FOnProgress : TProgressProc;
    FTotalLines : longint;
    FBankAccount : IBankAccount;
    FStatement : IBankStatement;
    FConvertDate : Boolean; //If true then date is not in yyyymmdd format so we need to convert
    FDateFormat,
    FDateSeparator : string;
    FHeaderLines, FFooterLines : Byte;
    FToolkit : IToolkit;
    FLineNo : longint;
    FFileType : TImportFileType;
    FFixedParser : TFixedLengthLineParser;
    FIgnoreList, FCreditTypeList : TStringList;
    FValueDivisor : Integer;
    FUseTransTypeForSign : Boolean;

    //PR: 13/03/2013 ABSEXCH-14104 Add delimiter
    FDelimiter : String;
    function LoadMapFile : Boolean;
    function CheckFile : Boolean;
    function ParseFixedLine : Integer;
    procedure ReadLine(LineNo : longint; AList : TStrings; var Abort : Boolean);
    procedure EndOfFile(Sender : TObject);
    function ConvertDate(const OldDate : string): string;
    procedure DeleteStatement;
    function ConvertStringToDate(DateString : string;
                                 DateFormat : string;
                                 Separator  : string) : TDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute : Integer;
    property FileName : string read FFilename write FFilename;
    property MapFileName : string read FMapFilename write FMapFilename;
    property OnProgress : TProgressProc read FOnProgress write FOnProgress;
    property BankAccount : IBankAccount read FBankAccount write FBankAccount;
    property Toolkit : IToolkit read FToolkit write FToolkit;
  end;

implementation

uses
  SysUtils, StrUtils, Dialogs, IniFiles, StatRef, ApiUtil, DateUtils, StrUtil;

const
  NoOfMapCols = 8;
  MapCols : Array[1..NoOfMapCols] of String[15] =
                            ('VALUE DATE', 'ENTRY DATE', 'BANK REFERENCE', 'DR/CR AMOUNT',
                              'REFERENCE 2', 'TRANS TYPE', 'PAYMENT AMOUNT', 'RECEIPT AMOUNT');

function TStatementImporter.ConvertDate(const OldDate : string): string;
var
  TempDate : TDateTime;
begin
  if FConvertDate then
  begin
    TempDate := ConvertStringToDate(OldDate, FDateFormat, FDateSeparator);
    Result := FormatDateTime('yyyymmdd', TempDate);
  end
  else
    Result := OldDate;

end;

{ TStatementImporter }

function TStatementImporter.CheckFile: Boolean;
begin
  Result := FileExists(FFilename);
  if Result then
  Try
    FMapFile.LoadFromFile(FFilename);
    FTotalLines := FMapFile.Count;
    FMapFile.Clear;
  Except
  End;
end;

constructor TStatementImporter.Create;
begin
  FParser := TCSVFileParser.Create(nil);
  FMapFile  := TStringList.Create;
  FConvertDate := False;
  FHeaderLines := 0;
  FLineNo := 0;
  FFileType := iftCSV;
  FFixedParser := nil;
  FIgnoreList  := TStringList.Create;
  FCreditTypeList  := TStringList.Create;
end;

destructor TStatementImporter.Destroy;
begin
  FParser.Free;
  FMapFile.Free;
  if Assigned(FFixedParser) then
    FFixedParser.Free;
  if Assigned(FIgnoreList) then
    FIgnoreList.Free;
  if Assigned(FCreditTypeList) then
    FCreditTypeList.Free;
end;

procedure TStatementImporter.EndOfFile(Sender: TObject);
var
  Res : Integer;
begin
{  Res := FStatement.Save;
  if Res <> 0 then
    ShowMessage('Unable to save Bank Statement. Error code ' + IntToStr(Res));}
end;

function TStatementImporter.Execute: Integer;
var
  StatDate, StatRef : string;
  Res : Integer;
begin
  Result := 0;
  if CheckFile then
  begin
    if LoadMapFile then
    begin
      FStatement := FBankAccount.baStatement.Add;
      StatRef := 'ST' + FormatDateTime('yyyymmddhhmm', Now);
      if GetStatementReference(StatRef, StatDate) then
      begin
        FStatement.bsReference := StatRef;
        FStatement.bsDate := StatDate;
        FStatement.bsStatus := 0;
        Res := FStatement.Save;
        if Res <> 0 then
        begin
          ShowMessage('Unable to save Bank Statement. Error code ' + IntToStr(Res));
          Result := 3;
        end
        else
        begin
          //PR: 13/03/2013 ABSEXCH-14104 Set delimiter if needed
          if Length(FDelimiter) > 0 then
            FParser.Delimiter := FDelimiter;
            
          FParser.FileName := FFilename;
          FParser.OnReadLine := ReadLine;
          FParser.OnEOF := EndOfFile;
          if FFileType = iftFixedLength then
            FParser.ParseLine := ParseFixedLine;
          if FHeaderLines > 0 then
            FParser.StartLine := FHeaderLines + 1;
          if FParser.Execute <> 0 then
          begin
            Result := 4;
            DeleteStatement;
          end;
        end;
      end;
    end
    else
      Result := 2;
  end
  else
    Result := 1;
end;

function TStatementImporter.LoadMapFile: Boolean;
var
  i, FieldCount : integer;
  sTemp : string;
begin
  Result := False;
  with TIniFile.Create(FMapFileName) do
  Try
    FDateFormat := ReadString('Date', 'Format', '');
    FDateSeparator := ReadString('Date', 'Separator', '');
    FHeaderLines := ReadInteger('Header', 'Header', 0);
    FFooterLines := ReadInteger('Header', 'Footer', 0);
    FConvertDate := FDateFormat <> '';
    FFileType := TImportFileType(ReadInteger('File', 'Type', 0));
    FValueDivisor := ReadInteger('Value', 'Divisor', 1);
    FUseTransTypeForSign := ReadBool('Value','UseTransTypeForSign', False);
    if FUseTransTypeForSign then
    begin
      sTemp := ReadString('Value','CreditTypes','');
      if Length(sTemp) > 0 then
        FCreditTypeList.CommaText := sTemp;
    end;

    //PR: 13/03/2013 ABSEXCH-14104 Read delimiter char
    FDelimiter := ReadString('Delimiter', 'Char', '');

    if FFileType = iftFixedLength then
    begin
      FieldCount := ReadInteger('Fixed Length', 'FieldCount', 0);
      if FieldCount = 0 then
        raise Exception.Create('No field count found for fixed length file');
      FFixedParser := TFixedLengthLineParser.Create;
      FFixedParser.FieldCount := FieldCount;
      for i := 0 to FieldCount -1 do
      begin
        FFixedParser.Field[i] := ReadInteger('Fixed Length', 'Length' + IntToStr(i), 0);
        if FFixedParser.Field[i] = 0 then
          raise Exception.Create('Map file error - Invalid field length for fixed length file');
      end;
      sTemp := ReadString('Fixed Length','Ignore', '');
      if Length(sTemp) > 0 then
        FIgnoreList.CommaText := sTemp;
    end;
  Finally
    Free;
  End;
  Try
    if FileExists(FMapFilename) then
    begin
      FMapFile.LoadFromFile(FMapFilename);


      for i := 0 to FMapFile.Count - 1 do
        FMapFile[i] := UpperCase(FMapFile[i]);

      while (FMapFile.Count > 0) and (Pos('[FIELDS]', FMapFile[0]) <> 1) do
        FMapFile.Delete(0);

      if FMapFile.Count > 0 then
      begin
        if Pos('[FIELDS]', FMapFile[0]) = 1 then
          FMapFile.Delete(0);

        Result := True;
      end
      else
        ShowMessage('Invalid Map file - [Fields] identifier not found');
    end;
  Except
    on E:Exception do
      MsgBox('An error occurred reading the map file ' + FMapFileName + #10 +
              QuotedStr(E.Message), mtError, [mbOK], mbOK, 'Import Bank Statement');
  End;
end;

procedure TStatementImporter.ReadLine(LineNo: Integer; AList: TStrings;
  var Abort: Boolean);
var
  oLine : IBankStatementLine;
  j, Res : integer;
  ThisSign : SmallInt;

  function IgnoreLine : Boolean;
  var
    c : integer;
  begin
    Result := False;
    for c := 0 to FIgnoreList.Count -1 do
      if Pos(FIgnoreList[c], AList[0]) = 1 then
      begin
        Result := True;
        Break;
      end;
  end;

  function ColumnIndex(ColPosition : Integer) : Integer;
  //Returns position of column in MapCols array. If not found returns -1. If 'Ignore' returns 0.
  var
    i : integer;
  begin
    Result := -1;
    if Pos('IGNORED', FMapFile[ColPosition]) = 0 then
    begin
      for i := 1 to NoOfMapCols do
        if Trim(FMapFile[ColPosition]) = MapCols[i] then
        begin
          Result := i;
          Break;
        end;

    end
    else
      Result := 0;

  end;

  function MakeNegative(aValue : Double) : Double;
  begin
    if aValue < 0 then
      Result := aValue
    else
      Result := -aValue;
  end;

  function SetSign(const TransType : string) : SmallInt;
  var
    c : integer;
  begin
    Result := -1;
    for c := 0 to FCreditTypeList.Count - 1 do
      if TransType = FCreditTypeList[c] then
      begin
        Result := 1;
        Break;
      end;
  end;

  //PR: 02/07/2014 ABSEXCH-15457 Amended StrToFloat to MoneyStrToFloatDef to deal with currency codes included in
  //                             same field as values.
  procedure SetLineProperty(Index : integer);
  begin
    Case ColumnIndex(Index) of
       1  : oLine.bslLineDate := ConvertDate(AList[Index]);       //Value Date
       2  : if Trim(oLine.bslLineDate) = '' then                  //Entry Date
              oLine.bslLineDate := ConvertDate(AList[Index]);
       3  : oLine.bslReference := AList[Index];                   //Ref
       4  : oLine.bslValue := (MoneyStrToFloatDef(AList[Index], 0) / FValueDivisor) * ThisSign;           //Value (+/-)
       5  : oLine.bslReference2 := AList[Index];                  //Ref 2
       6  : begin
			  if FUseTransTypeForSign then
             // AP : 3/10/2016 : ABSEXCH-14932 Importing Statements for Bank Of Scotland shows all values as Debit Values
             begin
               ThisSign := SetSign(AList[Index]);
               oLine.bslValue := oLine.bslValue*ThisSign;
             end;
            end;
       7  : if Trim(AList[Index]) <> '' then
              oLine.bslValue := MakeNegative(MoneyStrToFloatDef(AList[Index], 0) / FValueDivisor);          //Value -
       8  : if Trim(AList[Index]) <> '' then
              oLine.bslValue := MoneyStrToFloatDef(AList[Index], 0) / FValueDivisor;           //Value +
    end;
  end;

begin
  if IgnoreLine then
    Exit;
  ThisSign := 1;
  if LineNo <= FTotalLines - FFooterLines then
  with FStatement do
  begin
    oLine := bsStatementLine.Add;
    for j := 0 to AList.Count - 1 do
    Try
      SetLineProperty(j);
    Except
      on E:Exception do
      begin
        Abort := True;
        MsgBox(Format('An error occurred reading line number %d of statement file %s', [LineNo, FParser.FileName]) + #10 +
                 QuotedStr(E.Message), mtError, [mbOK], mbOK, 'Import Bank Statement');
      end;
    End;

    if not Abort and (oLine.bslValue <> 0.00) then
    begin
      Inc(FLineNo);
      oLine.bslLineNo := FLineNo;
      Res := oLine.Save;

      if Res <> 0 then
      begin
        Abort := True;
        MsgBox(Format('An error occurred storing line number %d of statement file %s', [LineNo, FParser.FileName]) + #10 +
          QuotedStr(FToolkit.LastErrorString), mtError, [mbOK], mbOK, 'Import Bank Statement');
      end;
    end;

  end;

  if Abort then
    DeleteStatement
  else
  if Assigned(FOnProgress) then
    FOnProgress(Self, LineNo, FTotalLines - FHeaderLines - FFooterLines);


  Sleep(10);
end;

procedure TStatementImporter.DeleteStatement;
var
  Res : Integer;
begin
  with FToolkit as IToolkit3 do
  begin
    Res := Banking.BankAccount.baStatement.GetEqual(Banking.BankAccount.baStatement.BuildDateAndFolioIndex(FStatement.bsDate,
                     FStatement.bsFolio));
    if Res = 0 then
      Banking.BankAccount.baStatement.Delete;
  end;
  FStatement := nil;
end;

function TStatementImporter.ConvertStringToDate(DateString, DateFormat,
  Separator: string): TDateTime;
var
  i, iPos : integer;
  yy, mm, dd : Word;
  sy, sm, sd, sTemp : string;
  YStart, MStart, DStart,
  YLen, MLen, DLen : Byte;
  MonthIsWord : Boolean;

  procedure SetDateComponent;
  begin
    Case DateFormat[i-1] of
      'Y'  :  yy := StrToInt(sTemp);
      'M'  :  mm := StrToInt(sTemp);
      'D'  :  dd := StrToInt(sTemp);
    end;
  end;

  procedure ParseDateString;
  begin
    sTemp := Copy(DateString, 1, i-1);
    SetDateComponent;
    Delete(DateString, 1, i);
    Delete(DateFormat, 1, i);
  end;

  procedure DoException;
  begin
    raise Exception.Create('Invalid date: ' + QuotedStr(DateString));
  end;

  procedure GetComponentDetails(const s : string;
                                const  WhichPart : String;
                                  var StartPos,
                                      Len  : Byte);
  //Finds the length and starting position of the d, m, or y section of the date format
  var
    j : integer;
  begin
    StartPos := Pos(WhichPart, s);
    j := StartPos;
    While (j <= Length(s)) and (s[j] = WhichPart[1]) do
      inc(j);
    Len := j - StartPos;
  end;

  function GetMonth(const s : string) : Integer;
  //Returns the month number corresponding to the month name passed in. Tries short names first then long names.
  var
    j : integer;
  begin
    Result := 0;
    for j := 1 to 12 do
      if s = UpperCase(ShortMonthNames[j]) then
      begin
        Result := j;
        Break;
      end;
    if Result =0 then
      for j := 1 to 12 do
        if s = UpperCase(Copy(LongMonthNames[j], 1, Length(s))) then
        begin
          Result := j;
          Break;
        end;
  end;

  function IrishDate(sDate : String) : TDateTime;
  //takes date in format yyddd and returns TDateTime
  var
    AYear, ADay : Integer;
  begin
    if (Length(sDate) <> 5) then
      raise Exception.Create('Invalid date for format yyddd: ' + sDate);
    AYear := StrToInt(Copy(sDate, 1, 2));
    if AYear > 80 then
      AYear := 1900 + AYear
    else
      AYear := 2000 + AYear;
    ADay := StrToInt(Copy(sDate, 3, 3));
    if not TryEncodeDateDay(AYear, ADay, Result) then
      raise Exception.Create('Invalid date for format yyddd: ' + sDate);
  end;

begin
  Result := 0;
  DateString := UpperCase(DateString);
  DateFormat := UpperCase(DateFormat);
  if DateFormat = 'YYDDD' then
  begin
    Result := IrishDate(DateString);
    Exit;
  end;
  AnsiReplaceStr(DateFormat, '-', Separator);
  //Remove any time from date string
  if Pos(TimeSeparator, Separator) = 0 then
  begin
    i := Pos(TimeSeparator, DateString);
    if i > 0 then
      Delete(DateString, i - 2, Length(DateString));
  end;

  i := Pos(Separator, DateString);

  if i > 0 then
  begin
    ParseDateString;
    i := Pos(Separator, DateString);

    if i > 0 then
    begin
      ParseDateString;

      i := 2;
      sTemp := DateString;
      if Length(sTemp) > 0 then
      begin
        SetDateComponent;
        //Check for 2-digit year
        if yy < 100 then
        begin
          if yy <= 80 then
            yy := yy + 2000
          else
            yy := yy + 1900;
        end;
        Result := EncodeDate(yy, mm, dd);
      end
      else
        DoException;
    end
    else
      DoException;

  end
  else
  begin
    GetComponentDetails(DateFormat, 'D', DStart, DLen);
    GetComponentDetails(DateFormat, 'M', MStart, MLen);
    GetComponentDetails(DateFormat, 'Y', YStart, YLen);

    if DStart > 0 then
      dd := StrToInt(Copy(DateString, DStart, DLen));

    if YStart > 0 then
      yy := StrToInt(Copy(DateString, YStart, YLen));

    if MStart > 0 then
    begin
      sTemp := Copy(DateString, MStart, MLen);

      MonthIsWord := False;
      for i := 1 to Length(sTemp) do
        if not (sTemp[i] in ['0'..'9']) then
          MonthIsWord := True;

      if MonthIsWord then
        mm := GetMonth(sTemp)
      else
        mm := StrToInt(sTemp);
    end;
    if yy < 100 then
    begin
      if yy <= 80 then
        yy := yy + 2000
      else
        yy := yy + 1900;
    end;
    Result := EncodeDate(yy, mm, dd);

  end;
end;

function TStatementImporter.ParseFixedLine: Integer;
begin
  FFixedParser.Line := FParser.Line;
  FFixedParser.Values := FParser.ValueList;
  Result := FFixedParser.Execute;

end;

end.
