program ExchDeleteTempFiles;

//RB 07/06/2017 2017-R2 ABSEXCH-14156: Temporary Data Files limited to 255 files
// - Causing Form Printing to Crash (Exch365)

{$R *.RES}
{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows,
  Forms,
  DateUtils,
  Dialogs,
  StrUtils;

var
  lSearchRec: TSearchRec;
  lSystemTime: TSystemTime;
  lEncodedDate: TDateTime;
  lDirToClean: String;
  lNoOfDaysOld: Integer;
begin
  //Fetch Values from from Parameters
  lDirToClean := IncludeTrailingBackslash(ParamStr(1));
  lNoOfDaysOld := StrToInt(ParamStr(2));

  //Loop through the every files in /Swap directory and Delete the file which are older
  //than the Number of days passed in Parameter
  if FindFirst(lDirToClean + '*.*', faAnyFile, lSearchRec) = 0 then
  begin
    try
      repeat
        if (lSearchRec.Name <> '.') and (lSearchRec.Name <> '..') then
        begin
          FileTimeToSystemTime(lSearchRec.FindData.ftCreationTime, lSystemTime);
          lEncodedDate := EncodeDate(lSystemTime.wYear, lSystemTime.wMonth, lSystemTime.wDay);
          //We don't want to delete any other files other than these
          if (DaysBetween(Now, lEncodedDate) > lNoOfDaysOld) AND
              (AnsiEndsText('.SWP', lSearchRec.Name) or
               AnsiEndsText('.SWF', lSearchRec.Name) or
               AnsiEndsText('.DAT', lSearchRec.Name)) then
            DeleteFile(PChar(lDirToClean + lSearchRec.Name));
        end;
      until (FindNext(lSearchRec) <> 0);
    finally
      SysUtils.FindClose(lSearchRec);
      Application.Terminate;
    end;
  end;
end.
