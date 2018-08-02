unit PerUtil;

{ nfrewer440 15:19 19/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes;


type
  TPeriodCalcError = (perOK, perNoData, perDateOutOfRange, perErrorInData, perPeriodOutOfRange);

  TEntMessageDlg = procedure(sMessage : string);

  TPeriodCalc = class
    private
      fPeriodError : TPeriodCalcError;
      fEntVersion,
      fLoggedInUser,
      fCompanyDirectory,
      fTransDate,
      fStartDate,
      fEndDate : string;
      fPeriod,
      fYear : smallint;
      fPeriodsList : TStringList;
      fAfterPeriodHookError : TNotifyEvent;
      procedure SetString(const Index : integer; const Value : string);
      procedure SetPeriodError(const Value: TPeriodCalcError);
      procedure SetSmallInt(const Index: Integer; const Value: smallint);
      procedure SetAfterPeriodHookError(Value : TNotifyEvent);
    protected
      class function DisplayDate(const strDate : string) : string;
      class function GetIniLineValue(IniLine : string) : string;
      procedure ReadFromINIFile;
      function  GetLogFileName : string;
      procedure NotifyErrors;
      procedure WriteToErrorLog(const Msg : string);
      property  PeriodError : TPeriodCalcError read fPeriodError write SetPeriodError;
    public

      UsePlugIn : boolean;

      EntMessageDlg : TEntMessageDlg;

      constructor Create(sPath : string);
      destructor Destroy; override;
      function ConvertDateToPeriod : boolean;
      function ConvertPYToDate : boolean;
      function ConvertPYToEndDate : boolean;
      property AfterPeriodHookError : TNotifyEvent read fAfterPeriodHookError write SetAfterPeriodHookError;
      property EntVersion : string index 1 read fEntVersion write SetString;
//      property CompanyDirectory : string index 2 read fCompanyDirectory write SetString;
      property LoggedInUser : string index 3 read fLoggedInUser write SetString;
      property TransDate : string index 4 read fTransDate write SetString;
      property Period : smallint index 1 read fPeriod write SetSmallInt;
      property Year : smallint index 2 read fYear write SetSmallInt;
  end;


implementation

uses
  DateUtils, StrUtil, Forms, SysUtils, IniFiles, Dialogs, Windows;

const
  PERIODS_INI_FILE = 'Periods.INI';
  SECTION_NAME = 'Periods';
  END_DATE = 'EndDate';

//------------------------------------------------------------------------------

procedure TPeriodCalc.SetString(const Index: integer; const Value: string);
begin
  case Index of
    1 : fEntVersion := Value;
//    2 : fCompanyDirectory := Value;
    3 : fLoggedInUser := Value;
    4 : fTransDate := Value;
  end;
end; // TPeriodCalc.SetString

//------------------------------------------------------------------------------

procedure TPeriodCalc.SetSmallInt(const Index: Integer; const Value: smallint);
begin
  case Index of
    1 : fPeriod := Value;
    2 : fYear := Value;
  end;
end; // TPeriodCalc.SetSmallInt

//------------------------------------------------------------------------------

procedure TPeriodCalc.SetPeriodError(const Value: TPeriodCalcError);
begin
  // If there's no data then other errors are meaningless
  if fPeriodError <> perNoData then
    fPeriodError := Value;
end;

//------------------------------------------------------------------------------

procedure TPeriodCalc.SetAfterPeriodHookError(Value: TNotifyEvent);
begin
  fAfterPeriodHookError := Value;
end;

//------------------------------------------------------------------------------

class function TPeriodCalc.DisplayDate(const strDate : string) : string;
// Pre  : strDate = Date in format yyyymmdd
// Post : Returns a date in the ShortDateFormat
var
  dtDate : TDateTime;
begin
  dtDate := EncodeDate(StrToInt(copy(strDate,1,4)), StrToInt(copy(strDate,5,2)),
    StrToInt(copy(strDate,7,2)));
  Result := DateToStr(dtDate);
end;

//------------------------------------------------------------------------------

class function TPeriodCalc.GetIniLineValue(IniLine : string) : string;
// Pre  : IniLine is a string in the form Key=Value
// Post : Returns the value part of the string i.e. after the = symbol
var
  EqualsAt : integer;
begin
  EqualsAt := LastDelimiter('=', IniLine);
  Result := copy(IniLine, EqualsAt + 1, length(IniLine) - EqualsAt);
end; // TPeriodCalc.GetPeriodStartDate

//------------------------------------------------------------------------------

function TPeriodCalc.GetLogFileName : string;
// Action : Generates a random log file name, pathed to appropriate Enterprise company
const
  LOGS_DIR = 'LOGS';
var
  Prefix   : string;
  i : integer;
begin
  Result := '';
  Randomize;
  Prefix := IncludeTrailingBackslash(IncludeTrailingBackslash(fCompanyDirectory) + LOGS_DIR) +
    Format('E%3.3d', [Random(999)]);

  for i := 1 To 9999 do
  begin
    Result := Prefix + IntToStr(i) + '.LOG';
    if not FileExists(Result) then
      Break;
  end;
end; // TPeriodCalc.GetLogFileName

//------------------------------------------------------------------------------

procedure TPeriodCalc.NotifyErrors;
// Action : Visually warn user and set error message for use in error log
const
  CRLF = #13#10;
var
  Msg : string;
{  Dialog : TForm;}
begin
  case PeriodError of
    perNoData : Msg := 'No user-defined period data has been set-up.';
    perErrorInData : Msg := 'Error in the user-defined period data';
    perDateOutOfRange :
      Msg := 'Date outside user-defined period data range' + CRLF +
             'Date : ' + DisplayDate(TransDate) + CRLF +
             'Period range starts : ' + DisplayDate(fStartDate) + CRLF +
             'Period range ends   : ' + DisplayDate(fEndDate);
    perPeriodOutOfRange :
      Msg := 'Period outside user-defined period range' + CRLF +
             'Period : ' + IntToStr(fPeriod) + CRLF +
             'Period range : 1 - ' + IntToStr(fPeriodsList.Count);
  end;

  EntMessageDlg(Msg);

{ Unfortunately, doesn't work with Windows 2000 ...
  Dialog := CreateMessageDialog(Msg, mtError, [mbOK]);
  try
    SetForegroundWindow(Dialog.Handle);
    Dialog.ShowModal;
  finally
    Dialog.Release;
  end; }

  if Assigned(AfterPeriodHookError) then
    AfterPeriodHookError(self);
  WriteToErrorLog(Msg);
end; // TPeriodCalc.NotifyErrors

//------------------------------------------------------------------------------

procedure TPeriodCalc.WriteToErrorLog(const Msg : string);
// Action : Create an error log
var
  LogFile : TextFile;
begin
  AssignFile(LogFile, GetLogFileName);
  try
    rewrite(LogFile);
    try
      writeln(LogFile, 'Exchequer Version : ' + EntVersion);
      writeln(LogFile, Application.ExeName);
      writeln(LogFile, Format('%s %s User : %s DataDir : %s',
        [DateToStr(Now), TimeToStr(Now), LoggedInUser, fCompanyDirectory]));
      writeln(LogFile, StringOfChar('-', 63));
      writeln(LogFile, 'Log Type : Warning. ' + Msg);
    finally
      CloseFile(LogFile);
    end;
  except ;
    // As this is an error log file, just trap any further file writing errors
  end;
end; // TPeriodCalc.WriteToLogFile;

//------------------------------------------------------------------------------

procedure TPeriodCalc.ReadFromINIFile;
// Action : Read the user-define period data from the INI file
begin

  with TIniFile.Create(fCompanyDirectory + PERIODS_INI_FILE) do
//  with TIniFile.Create(ExtractFilePath(Application.ExeName) + PERIODS_INI_FILE) do
    try
      UpdateFile;
      ReadSectionValues(SECTION_NAME, fPeriodsList);
      fEndDate := ReadString(SECTION_NAME, END_DATE, '');
      UsePlugIn := UpperCase(ReadString('Settings', 'UsePlugIn', 'FALSE')) = 'TRUE'; // BJH - was defaulting to TRUE when udperiod plugin not installed
    finally
      Free;
    end;

  with fPeriodsList do
    if Count = 0 then
      PeriodError := perNoData
    else
    begin
      fStartDate := GetIniLineValue(Strings[0]);
      // Remove the End Date from the list
      Delete(IndexofName(END_DATE));
    end;
end; // TfrmPeriodList.ReadFromINIFile

//------------------------------------------------------------------------------

function TPeriodCalc.ConvertDateToPeriod : boolean;
// Action : Converts the date stored in TransDate to the appropriate (financial)
//          Year and Period. Warns the user of and logs errors.
var
  Posn : integer;
begin
  Result := false;
  if (TransDate >= fStartDate) and (TransDate <= fEndDate) and (PeriodError <> perNoData) then
  begin
    Posn := 0;
    while (Posn < fPeriodsList.Count-1) and
      (TransDate >= GetIniLineValue(fPeriodsList[Posn+1])) do
      inc(Posn);
    try
      fPeriod := StrToInt(copy(fPeriodsList.Names[Posn],1,2));
      // Year 2000 = 100
      fYear := StrToInt(copy(fPeriodsList.Names[Posn],3,4)) - 1900;
      Result := true;
    except
      PeriodError := perErrorInData;
    end;
  end
  else
    PeriodError := perDateOutOfRange;

  if not Result then
    NotifyErrors;
end; // TPeriodCalc.ConvertDateToPeriod

function TPeriodCalc.ConvertPYToDate : boolean;
// Action : Converts the date stored in TransDate to the appropriate (financial)
//          Year and Period. Warns the user of and logs errors.
var
  iPos : integer;
begin
  Result := false;
//  PeriodError := ?;
  if (fPeriod > 0) and (fPeriod <= fPeriodsList.Count)
  and (PeriodError <> perNoData) then
  begin
    for iPos := 0 to fPeriodsList.Count-1 do
    begin
      if Copy(fPeriodsList[iPos],1,6) = PadString(psLeft,IntToStr(fPeriod),'0',2)
      + IntToStr(fYear + 1900) then
      begin
        fTransDate := Copy(fPeriodsList[iPos],8,8);
        Result := TRUE;
        break;
      end;{if}
    end;{for}
  end
  else
    PeriodError := perPeriodOutOfRange;

// As This is normally called in a thread it is not advisable to display any messages
{  if not Result then
    NotifyErrors;}

end; // TPeriodCalc.ConvertDateToPeriod

//------------------------------------------------------------------------------

function TPeriodCalc.ConvertPYToEndDate : boolean;
// Action : Converts the Period/Year stored in fPeriod/fYear to the appropriate
//          end date of that period.
var
  iEndDay, iMonth, iYear, iPos : integer;
begin
  Result := false;
//  PeriodError := ?;
  if (fPeriod > 0) and (fPeriod <= fPeriodsList.Count)
  and (PeriodError <> perNoData) then
  begin
    for iPos := 0 to fPeriodsList.Count-1 do
    begin
      if Copy(fPeriodsList[iPos],1,6) = PadString(psLeft,IntToStr(fPeriod),'0',2)
      + IntToStr(fYear + 1900) then
      begin
        // Found Period/Year

        if iPos = fPeriodsList.Count-1 then
        begin
          // Last period in the list
          fTransDate := fEndDate;
        end else
        begin
          // Date = the start date of the next period - 1
          iEndDay := StrToIntDef(Copy(fPeriodsList[iPos+1],14,2),0);
          if iEndDay < 1 then
          begin
            // error;
            break;
          end else
          begin
            iYear := StrToIntDef(Copy(fPeriodsList[iPos+1],8,4),0);
            iMonth := StrToIntDef(Copy(fPeriodsList[iPos+1],12,2),0);
            if (iYear < 1900) or (iYear > 2100) or (iMonth < 1) or (iMonth > 12) then break;

            if iEndDay = 1 then
            begin
              if iMonth = 1 then
              begin
                iMonth := 12;
                iYear := iYear -1;
              end else
              begin
                iMonth := iMonth - 1;
              end;{if}
              iEndDay := DaysInAMonth(iYear, iMonth)
            end else
            begin
              iEndDay := iEndDay - 1;
            end;
            fTransDate := IntToStr(iYear) + PadString(psLeft, IntToStr(iMonth), '0', 2)
            + PadString(psLeft, IntToStr(iEndDay), '0', 2);
          end;{if}
        end;{if}
        Result := TRUE;
        break;
      end;{if}
    end;{for}
  end
  else
    PeriodError := perPeriodOutOfRange;
end; // TPeriodCalc.ConvertDateToPeriod

//------------------------------------------------------------------------------

constructor TPeriodCalc.Create(sPath : string);
begin
  inherited Create;
  PeriodError := perOK;
  fPeriodsList := TStringList.Create;
  fCompanyDirectory := sPath;
  ReadFromIniFile;
end;

//------------------------------------------------------------------------------

destructor TPeriodCalc.Destroy;
begin
  fPeriodsList.Free;
  inherited Destroy;
end;

end.
