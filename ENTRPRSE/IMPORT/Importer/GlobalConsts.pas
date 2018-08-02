unit GlobalConsts;

{******************************************************************************}
{                          Global Constants                                    }
{******************************************************************************}
interface

uses graphics;

const

  ML_COLUMN_COLOR         = clSkyBlue; // all superseded by the "properties" context-menu item for each ML
  ML_FONT_COLOR           = cl3DDkShadow;
  ML_FONT_STYLE           = [fsBold];
  ML_HEADERFONT_COLOR     = clNavy;
  ML_HEADERFONT_STYLE     = [fsBold];
  ML_HIGHLIGHTFONT_COLOR  = clWhite;
  ML_HIGHLIGHTFONT_STYLE  = [fsBold];

  STD_IMPORT_FILE_RECORD_LENGTH = 2048;

  BLANKCHAR               = #255;

  ADMINMODE_KEY           = '##sysadmin##';
  APPLOGFILE              = 'Importer.log';

// Commonly used IniFile sections in Importer's settings file and SAV files.
  IMPORT_SETTINGS         = 'Import Settings';
  JOB_SETTINGS            = 'Job Settings';
  SYSTEM_SETTINGS         = 'System Settings';
  FIELD_MAPS              = 'Field Maps';
  FIELD_DEFS              = 'Field Defs';
  IMPORT_LIST             = 'Import List';
  AUTOINCRESET            = 'AutoIncReset';
  RECORD_TYPES            = 'Record Types';
  SCHEDULE                = 'Schedule';         
  USER_SECTIONS           = 'User Sections';
  HEADER_RECS             = 'Header Recs';
  DETAIL_RECS             = 'Detail Recs';
  HEADERS                 = 'Headers';
  IAO_RECS                = 'IAO Recs';
  BLANK_CHAR              = 'Blank Char';

  LEN_REC_NO              = 5;      // number of characters to format an import record number to (for error logs)
  LOG_PROCFILE            = 'Processing file'; // entry in log file to search for to determine which file was processed
  MAX_TRANS_LINES         = 2000;


var
  DebugIt:          boolean;    // they're honourary constants
  SchedulerMode:    boolean;    // If they want their own unit they'll
  PlainOut:         boolean;    // have to chip in for one.
  TKTestMode:       boolean;
  madExceptOff:     boolean;
  StartInAdminMode: boolean;    // only effective if project built with ADMIN conditional set
  ZeroJobNo:        boolean;    // only effective if you delete ImportJob.dat before running an import job.
  ShowTime:         boolean;
  NoLogo:           boolean;
  MainClientWidth:  integer;
  MainClientTop:    integer;
  MainClientBottom: integer;

  //PR: 20/11/2013 Moved here from Login.pas to allow other units to use it
  LoginUserName: AnsiString;
  //SS
  LoginDisplayName: AnsiString;

  function AppVersion : AnsiString;

implementation

uses SysUtils, Utils, ExchequerRelease;

const
  BuildNo = '178';

function AppVersion : AnsiString;
begin
  Result := ExchequerModuleVersion(emImporter, BuildNo);
end;

initialization
  DebugIt          := FindCmdLineSwitch('DEBUG', ['/', '-'], true);     // writes internal field maps out to text files
  SchedulerMode    := FindCmdLineSwitch('SCHEDULER', ['/', '-'], true); // run in sytem tray with limited functionality.
  PlainOut         := FindCmdLineSwitch('PLAINOUT', ['/', '-'], true);  // the program writes out unencrypted settings, job and field map files
  madExceptOff     := FindCmdLineSwitch('MADOFF', ['/', '-'], true);    // run without madExcept. MadExcept removed altogether now.
  TKTestMode       := FindCmdLineSwitch('TESTMODE', ['/', '-'], true);  // put toolkit into test mode
  ZeroJobNo        := FindCmdLineSwitch('ZEROJOBNO', ['/', '-'], true); // resets the JobNo in ImportJob.dat to zero
  ShowTime         := FindCmdLineSwitch('SHOWTIME', ['/', '-'], true);  // on logs, show elapsed time split between Importer and Toolkit
  NoLogo           := FindCmdLineSwitch('NOLOGO', ['/', '-'], true);    // suppresses significant bitmaps for Terminal Services or Citrix environments
  StartInAdminMode := FindCmdLineSwitch('ADMIN', ['/', '-'], true);     // Start in Admin Mode

end.
