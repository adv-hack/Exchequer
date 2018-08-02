unit logFileRtn;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  sysutils;
                               {11111111112222222222333333333344444444445}
const                {012345678901234567890123456789012345678901234567890}
  PageHeader       = 'Export To Earnie Error Log 	Date : %s';
  PageHeader2      = '_____________________________________________________________________________________________________________';

  ErrorLineHeader  = 'Our Ref             Error Message';

  PageFooter       = 'END OF LOG FILE';

  CheckWeekErr     = 1;
  GetEmployeeErr   = 2;
  PayRollNoErr     = 3;
  PayDetailsErr    = 4;
  AbortErr         = 5;
  ExportRecCreationError = 6;

  error1 = 'Field ''DiscDays'' of transaction record does not meet user selection for Week/Month No';
  error2 = 'Failed to get employee details with transaction employee Code';
  error3 = 'Employee Rec PayRollno is Invalid';
  error4 = 'Failed to get employee paydetails';
  error5 = 'Aborted by User intervention';
  Error6 = 'Could not dynamically create a TExport Record ';

  ErrorArray : array[CheckWeekErr..ExportRecCreationError] of string = (error1,error2,error3,error4,error5,error6);

  EarnieLog = '\Earnie.log';

  function  Err(ErrorCode : integer) : String;
  procedure WriteHeader(var logFile : TextFile);
  Procedure WriteFooter(var logfile : TextFile);
  Procedure WriteError(var LogFile : TextFile;ErrorCode : Integer;ourref : String);

implementation

  function Err(ErrorCode : integer) : String;
  begin
    try
      result := errorArray[errorcode];
    except
      result := 'An Error Occured attempting to discover the log error!';
    end
  end;

  procedure WriteHeader(var logFile : TextFile);
  begin
    try
      Writeln(LogFile,format(PageHeader,[datetimetostr(now)]));
      Writeln(LogFile,pageHeader2);
      WriteLn(LogFile,ErrorLineHeader);
      Writeln(Logfile);
    except on E:EinOutError do
      begin


      end;
    end;
  end;

  Procedure WriteFooter(var logfile : TextFile);
  begin
    try
     writeln(LogFile,PageFooter);
     except on E:EinOutError do
     begin


     end;
   end;
  end;

  Procedure WriteError(var LogFile : TextFile;ErrorCode : integer;ourref : String);
  begin
    try
      Write(LogFile,ourref);Write(LogFile,stringOfChar(' ',20-length(ourref)));
      WriteLn(LogFile,Err(ErrorCode));
    except on E:EinOutError do
      begin


      end;
    end;
  end;

end.
