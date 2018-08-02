unit Utils;

{******************************************************************************}
{            Provides various auxiliary functions which are used               }
{             in several units throughout the Importer project.                }
{******************************************************************************}

interface

uses uMultiList, controls, types, GlobalTypes, classes, menus, windows, messages,
     StdCtrls, ComObj, Enterprise01_TLB, dialogs, DateUtils, BlowFish, IniFiles,
     forms;

function  AdminModeChanged(Key: char): boolean;
function  AdminKey(Key: char): boolean;
{$IFDEF ADMIN} procedure AdminSet(AdminMode: boolean); {$ENDIF}
function  AutoIncCounter(const AValue: string): boolean;
function  AppLogFileName: string;
function  BlowFishDecrypt(const Encrypted: string): string;
function  BlowFishEncrypt(const Plain: string): string;
function  CheckForOldFieldDef(FieldDef: string): string;
function  CheckImportFileType(FileName: string): TImportFileType;
function  CleanDateTime(DateTime: TDateTime): string;
function  CompanyDataPath(const ACompany: string; AToolkit: IToolkit): string;
function  ConvertData(const FieldValue: string; FieldType: char; FieldLen: word; var VarOut): boolean; overload;
function  ConvertData(const FieldValue: string; FieldType: char; FieldLen: word;
                      Offset: word; var ExchRec: TExchequerRec): boolean; overload;
function  ConvertField(ValueIn: TArrayOfChar;
                       FieldType: char;
                       FieldLen: word;
                       var ValueOut: TArrayOfchar): boolean;
function  DataTypeDescription(DataType: char): string;
function  DataTypeFromSettingType(ASettingType: TSettingType): char;
function  EnterToTab(Key: char; handle: HWND): char;
function  ExpandFileName(RelFileName: String): String;
function  FieldWidth(FieldType: char; FieldLen: byte): byte;
function  FindRecordTypes(const AFileName: string; ARecordTypes: TStringList; AHeaderRecordPresent: boolean; AGlobalRecordType: string): integer; // v.067
function  FormatRunDateTime(RunDateTime: TDateTime): string;
procedure FormLoadSettings(Form: TForm; Control: TControl);
procedure FormSaveSettings(Form: TForm; Control: TControl);
function  FreeObjects(Objects: array of pointer): boolean;
function  GetExePath: string;
function  GetLongPathName(const AShortPathName: string): string;
function  GetScreenPoint(AControl: TControl): TPoint;
function  InAdminMode: boolean;
function  IncludeField(const AValue: string): boolean;
function  IsolateIniSection(AIniLines: TStringList; AIniSection: string): integer;
function  LoadFromStream(const AFileName: string; AStrings: TStrings): integer;
procedure LBInit(LB: TListBox);
procedure MenuPopup(APopupMenu: TPopupMenu; AControl: TControl);
procedure MLDeleteRow(ML: TMultiList; ARow: integer);
procedure MLDeleteSelectedRow(ML: TMultiList);
procedure MLEditProperties(ML: TMultiList; Form: TForm; Control: TControl);
procedure MLInit(ML: TMultiList);
procedure MLLoadSettings(ML: TMultiList; Form: TForm);
procedure MLSaveSettings(ML: TMultiList; Form: TForm);
procedure MLSelectFirst(ML: TMultiList);
procedure MLSelectLast(ML: TMultiList);
procedure MLSelectRow(ML: TMultiList; ARow: integer);
procedure MLMoveSelectedRowDown(ML: TMultiList);
procedure MLMoveSelectedRowUp(ML: TMultiList);
procedure MLSortColumn(ML: TMultiList; AColumn: integer; Ascending: boolean);
function  MyExpandFileName(BasePath, RelFileName: String): String;
function  PercentDiskFree(const APath: string): integer;
function  RelativePath(AFullPath: string): string;
function  RemoveSpaces(AString: string): string;
procedure SetConstraints(Constraints: TSizeConstraints; height: integer; width: integer);
function  SettingTypeFromString(const ASettingType: string): TSettingType;
function  SettingTypeFromDataType(DataType: char): TSettingType;
procedure ShiftFocus(handle: HWND; WinControl: TWinControl);
function  SettingTF(Setting: string): boolean;
function  StorageSize(FieldType: char; FieldLen: word): word;
function  SwapFields(FieldDefs: TStringList): boolean; // v.075
function  ValidKeyPress(Key: char; DataType: char; PosDot: integer): char;
procedure WindowMoving(var msg: TMessage; height: integer; width: integer);
function  WindowsUserName: string;
{$IFNDEF SQLHELPER}
procedure WriteIniLogonInfo(IniFile: TMemIniFile);
{$ENDIF SQLHELPER}

implementation

uses SysUtils, GlobalConsts, graphics, TErrors, TIniClass, {$IFNDEF SQLHELPER}LoginF,{$ENDIF} FileUtil, uSettings;

var
  FAdminMode: boolean;
  FAdminKey:  string;

  ValueIn:  TArrayOfChar;
  ValueOut: TArrayOfChar;


function  AdminKey(Key: char): boolean;
// return TRUE if the last n characters typed match the required pass key
begin
  FAdminKey := FAdminKey + Key;
  if length(FAdminKey) > length(ADMINMODE_KEY) then
    FAdminKey := copy(FAdminKey, 2, length(ADMINMODE_KEY));

  result := FAdminKey = ADMINMODE_KEY;
  if FAdminKey = '##harkcom##' then
    ShowMessage('Hello Barry !');
end;

function  AdminModeChanged(Key: char): boolean;
// Check if the admin key has been entered.
// If the program was in admin mode and its just been turned off, return true.
// If the program wasn't in admin mode and its just been turned on, return true.
// Otherwise return false.
begin
  result := false;
  if not FAdminMode then begin
    FAdminMode := AdminKey(key);
    if FAdminMode then result := true; // we weren't, now we are
  end
  else begin
    FAdminMode := not AdminKey(key); // entering the key a second time turns off AdminMode
    if not FAdminMode then result := true; // we were, now we aren't
  end;
end;

procedure AdminSet(AdminMode: boolean);
begin
  FAdminMode := AdminMode;
end;

function AppLogFileName: string;
// determine the full path and file name of the main application log file
begin
  result := IncludeTrailingPathDelimiter(IniFile.ReadString(SYSTEM_SETTINGS, 'Log File Folder', '')) + APPLOGFILE;
end;

function AutoIncCounter(const AValue: string): boolean;
begin
  result := false;
  if length(AValue) < 2 then exit;

  result := (pos('[A', AValue) > 0) or (pos('[C', AValue) > 0); // [AutoIncx] or [CurrIncx]
end;

function BlowFishDecrypt(const Encrypted: string): string;
// Return the Encrypted string decrypted
// The blowfish initialisation strings match those in BlowFishEncrypt
// DO NOT CHANGE THE INITIALISATION STRINGS !
var
  BlowFish: TBlowFish;
  Decrypted: string;
begin
  BlowFish := TBlowFish.Create(nil);
  try
    BlowFish.CipherMode := ECB;
    BlowFish.StringMode := smEncode;
    BlowFish.LoadIVString('F2ABC392');
    BlowFish.InitialiseString('8F3319');
    BlowFish.DecString(Encrypted, Decrypted);
    result := Decrypted;
    BlowFish.Burn;
  finally
    BlowFish.free;
  end;
end;

function BlowFishEncrypt(const Plain: string): string;
// return the unencrypted string encrypted
// The blowfish initialisation strings match those in BlowFishDecrypt
// DO NOT CHANGE THE INITIALISATION STRINGS !
var
  BlowFish: TBlowFish;
  Encrypted: string;
begin
  BlowFish := TBlowFish.Create(nil);
  try
    BlowFish.CipherMode := ECB;
    BlowFish.StringMode := smEncode;
    BlowFish.LoadIVString('F2ABC392');
    BlowFish.InitialiseString('8F3319');
    BlowFish.EncString(Plain, Encrypted);
    result := Encrypted;
    BlowFish.Burn;
  finally
    BlowFish.free;
  end;
end;

function  CheckForOldFieldDef(FieldDef: string): string;
// The FieldSys column was added in v.062 after the v.059 release.
// Field Maps created prior to v.062 will need to have two characters inserted
// before the FieldDesc column.
// If the "d" of "default" is in the wrong place, we can safely assume that we've
// been passed an old FieldDef and we can insert the two new characters.
// This simple solution will only work this time round. With any subsequent versions
// of TFieldDef we will need to calculate where "default" is in relation to where
// it is expected and insert the appropriate number of spaces to compensate.
// This new solution will therefore cater for v.059, v.062 and v.?? field maps.
var
  posFieldSys: integer;
  posDefault: integer;
  FFieldDef: TFieldDef;
begin
  result := '';


// v.064 This function also gets called from TIni.ReturnDataInFieldDef when the user presses the "Set Default=" button
// in IniRecMaint.pas. At that point, FieldDef doesn't yet contain "default=", unlike a field map file.
// So this check prevents inserting an extra space into what the user typed.
  if pos('default=', FieldDef) = 0 then
    exit;

  posFieldSys := integer(@FFieldDef.FieldSys) - integer(@FFieldDef) + 1;      // position of FieldSys column in TFieldDef
  posDefault  := integer(@FFieldDef.DefaultEquals) - integer(@FFieldDef) + 1; // position of DefaultEquals column in TFieldDef
  if FieldDef[posDefault] <> 'd'  then begin    // "default" is two columns further to the left than it should be
    insert('  ', FieldDef, posFieldSys);        // upgrade map to v.062 by inserting the new FieldSys and blank7 columns
    result := FieldDef;
  end;
end;

function CheckImportFileType(FileName: string): TImportFileType;
// if the size of a file is exactly divisible by the Std record length then its probably a std import file.
// otherwise its probably a user-defined layout (e.g. a CSV file).
// if a user ever creates a CSV file containing exactly n * STD_IMPORT_FILE_RECORD_LENGTH bytes then
// we have a problem. Actually, I should probably go and work out how likely that is. Hold on......
// 09/12/2005: Changed to identify the file type purely using the file extension. Even though the above
// scenario is unlikely it's bound to happen, so I might as well change it now rather than later.
var
  sr: TSearchRec;
  rc: integer;

  StdImportExt: string;
  FileExt: string;
begin
  result := ftUserDef; // v.086 - no more IMP files, Yay !
  EXIT;

  StdImportExt := IniFile.ReadString(SYSTEM_SETTINGS, 'Std Import Ext', '');
  FileExt      := ExtractFileExt(FileName);
  if (length(FileExt) > 0) and (FileExt[1] = '.') then
    Delete(FileExt, 1, 1);
  if SameText(FileExt, StdImportExt) then
    result := ftStdImport
  else
    result := ftUserDef;

  EXIT;

  result := ftUserDef;
  rc := FindFirst(FileName, faAnyFile, sr);
  if rc = 0 then begin
    if (sr.Size mod STD_IMPORT_FILE_RECORD_LENGTH) = 0 then
      result := ftStdImport
  end
  else
    SetSysMsg(format('File "%s" does not exist', [FileName]));
  FindClose(sr);
end;

function  CleanDateTime(DateTime: TDateTime): string;
// removes all characters from a TDateTime except digits and spaces
var
  i: integer;
begin
  result := DateTimeToStr(DateTime);
  for i := length(result) downto 1 do
    if not (result[i] in ['0'..'9', ' ']) then
      delete(result, i, 1);
end;

function  CompanyDataPath(const ACompany: string; AToolkit: IToolkit): string;
// ACompany is in the format "CoCode - CoName"
// Accesses the COM Toolkit and returns the data path for the given company
// If the caller already has an instance of the COM Toolkit we use it otherwise
// we instantiate our own.
// As Login.pas has its own version of this code, this function doesn't appear
// to get called.
var
  Toolkit: IToolkit;
  Code, Name: string;
  i: integer;
begin
  Code := copy(ACompany, 1, pos('-', ACompany) - 2);
  Name := copy(ACompany, pos('-', ACompany) + 2, length(ACompany));
  if assigned(AToolkit) then
    Toolkit := AToolkit
  else
    Toolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  if not assigned(Toolkit) then
    ShowMessage('Cannot create COM Toolkit instance')
  else begin
    with Toolkit.Company do begin // no need to open toolkit
      if cmCount > 0 then
        for i := 1 to cmCount do
          with cmCompany[i] do begin
            if (coCode = Code) and (coName = Name) then begin
              result := IncludeTrailingPathDelimiter(trim(coPath));
              break;
            end;
          end;
    end;
    Toolkit := nil; // decrement reference count
  end;
end;

function ConvertData(const FieldValue: string; FieldType: char; FieldLen: word; var VarOut): boolean; overload;
// Convert FieldValue and populate VarOut with the appropriate number of bytes for the field type.
var
  ValueIn:  TArrayOfChar;
  ValueOut: TArrayOfChar;
begin
{  SetLength(ValueIn, FieldWidth(FieldType, FieldLen));               // enough chars to accept ValueIn
  SetLength(ValueOut, StorageSize(FieldType, FieldLen));             // the appropriate number of bytes for the resultant field type
  FillChar(ValueIn[0], length(ValueIn), #32); }
  FillChar(ValueIn[0], 255, #32);                       // Blank the entire field
  FillChar(ValueOut[0], 255, #0);                       // Blank the entire field
  if FieldValue <> '' then
    Move(FieldValue[1], ValueIn[0], length(FieldValue));  // Populate ValueIn with the FieldValue
  result := ConvertField(ValueIn, FieldType, FieldLen, ValueOut);    // Convert ValueIn to ValueOut
  move(ValueOut[0], VarOut, StorageSize(FieldType, FieldLen));       // Pass back ValueOut via VarOut
end;

function ConvertData(const FieldValue: string; FieldType: char; FieldLen: word;
                     Offset: word; var ExchRec: TExchequerRec): boolean; overload;
// Convert FieldValue and move the appropriate number of bytes for the field type to ExchRec[Offset]
var
{  ValueIn:  TArrayOfChar;
  ValueOut: TArrayOfChar;}
  MaxLen: integer;
begin
  //PR: 28/05/2010 Change dynamic arrays to static array to try to reduce memory leak.
{  SetLength(ValueIn, FieldWidth(FieldType, FieldLen));               // enough chars to accept ValueIn
  SetLength(ValueOut, StorageSize(FieldType, FieldLen));             // the appropriate number of bytes for the resultant field type
  FillChar(ValueIn[0], length(ValueIn), #32); }
  FillChar(ValueIn[0], 255, #32);                       // Blank the entire field
  FillChar(ValueOut[0], 255, #0);                       // Blank the entire field
  MaxLen := length(FieldValue);
  if MaxLen > length(ValueIn) then
    MaxLen := length(ValueIn); // in case duff data gets through, at least we won't get an invalid pointer
  if FieldValue <> '' then
    Move(FieldValue[1], ValueIn[0], MaxLen);  // Populate ValueIn with the FieldValue
//    Move(FieldValue[1], ValueIn[0], length(FieldValue));  // Populate ValueIn with the FieldValue
  //PR: 01/06/2010 Changed so that string fields aren't automatically padded - leave to the toolkit code to pad where needed.
  if (FieldType = 'S') and (Length(FieldValue) < FieldLen) then
    result := ConvertField(ValueIn, FieldType, Length(FieldValue), ValueOut)    // Convert ValueIn to ValueOut
  else
    result := ConvertField(ValueIn, FieldType, FieldLen, ValueOut);    // Convert ValueIn to ValueOut

  move(ValueOut[0], ExchRec.AsRecord[Offset], StorageSize(FieldType, FieldLen)); // Copy ValueOut to correct position in the record
end;

function ConvertField(ValueIn: TArrayOfChar;
                       FieldType: char;
                       FieldLen: word;
                       var ValueOut: TArrayOfchar): boolean;
// Converts the incoming stream of characters to the datatype specified by FieldType.
// FieldLen specifies the correct number of bytes required for the internal storage of a value of FieldType.
// The correct number of bytes are copied from the local variable to ValueOut.
var
  aDouble:   double;
  aSmallInt: smallint;
  aWordBool: word;
  aLongInt:  longint;
  aByte:     byte;
  aBoolean:  byte;
begin
  result := true;
  try
    case FieldType of
    'S':          begin
                    ValueOut[0] := chr(FieldLen);
                    Move(ValueIn[0], ValueOut[1], FieldLen);
                  end;
    'D':          begin
                    aDouble := StrToFloat(trim(string(ValueIn)));
                    move(aDouble, ValueOut[0], FieldLen);
                  end;
    'I':          begin
                    aSmallint := StrToInt(trim(string(ValueIn)));
                    move(aSmallint, ValueOut[0], FieldLen);
                  end;
    'C':          begin
                    move(ValueIn[0], ValueOut[0], FieldLen);
                  end;
    'W':          begin
                    aWordBool := StrToInt(trim(string(ValueIn)));
                    move(aWordBool, ValueOut[0], FieldLen);
                  end;
    'L':          begin
                    aLongInt := StrToInt(trim(string(ValueIn)));
                    move(aLongInt, ValueOut[0], FieldLen);
                  end;
    'B':          begin
                    aByte := StrToInt(trim(string(ValueIn)));
                    move(aByte, ValueOut[0], FieldLen);
                  end;
    'b':          begin
                    aBoolean := StrToInt(trim(string(ValueIn)));
                    move(aBoolean, ValueOut[0], FieldLen);
                  end;
    end;
  except on EConvertError do
    result := false;
  end;
end;

function  DataTypeDescription(DataType: char): string;
// Return a user-friendly description of the type of field being edited
begin
  case DataType of
    'S':  result := 'Alphanumeric';
    'D':  result := 'Decimal';
    'I':  result := 'Numeric';
    'C':  result := 'Alphanumeric';
    'W':  result := 'True or False / Yes or No';
    'L':  result := 'Numeric';
    'B':  result := 'Numeric';
    'b':  result := 'True or False / Yes or No';
    'P':  result := '';    // full path to folder
    'F':  result := '';    // full path to file name
    'M':  result := '';    // full path to folder with file mask
    'T':  result := 'Time';
  else
    result := '';
  end;
end;

function  DataTypeFromSettingType(ASettingType: TSettingType): char;
// takes a TSettingType, e.g. stFolder and returns an edit type that
// can be passed to ValidKeyPress to check if the user has pressed an
// appropriate key
begin
  case ASettingType of
    stUnknown:            result := 'S';
    stFreeText:           result := 'S';
    stFixedList:          result := ' ';
    stFolder:             result := 'P';
    stFile:               result := 'F';
    stDataPath:           result := 'S'; // changed from path to company code and name
    stFileorPathWithMask: result := 'M';
    stTime:               result := 'T';
    stDouble:             result := 'D';
    stSmallInt:           result := 'I';
    stChar:               result := 'C';
    stWordBool:           result := 'W';
    stLongInt:            result := 'L';
    stByte:               result := 'B';
    stBoolean:            result := 'b'
//   stHidden not relevant
  else
    result := 'S';
  end;
end;

function  EnterToTab(Key: char; handle: HWND): char;
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    result := #0;
  end
  else
    result := Key;
end;

function  ExpandFileName(RelFileName: String): String;
// returns the full path using the EnterpriseDirectory as the base.
begin
  result := MyExpandFileName(GetLongPathName(GetEnterpriseDirectory), RelFileName);
end;

function FieldWidth(FieldType: char; FieldLen: byte): byte;
// returns the maximum number of ascii characters that can be used to describe the value
// of a given data type
const
  DoubleFieldLen   = 18;  // 16 significant digits plus a . and a - (or +)
  SmallIntFieldLen = 06;  // -32768 to +32767
  LongIntFieldLen  = 11;  // -2147483648 to +2147483647
  WordBoolFieldLen = 01;  // (0 or 1) or (Y or N) or (T or F)
  ByteFieldLen     = 03;  // 0 to 255;
  BooleanFieldLen  = 01;  // (0 or 1) or (Y or N) or (T or F)
begin
  result := 0; // suppress compiler warning
  case FieldType of
  'S':  result := FieldLen;          // the length of the string itself
  'D':  result := DoubleFieldLen;
  'I':  result := SmallIntFieldLen;
  'C':  result := FieldLen;          // 1 if char; else FieldLen if array[1..FieldLen] of char;
  'W':  result := WordBoolFieldLen;
  'L':  result := LongIntFieldlen;
  'B':  result := ByteFieldLen;
  'b':  result := BooleanFieldLen;
  end;
end;

function FindRecordTypes(const AFileName: string; ARecordTypes: TStringList; AHeaderRecordPresent: boolean; AGlobalRecordType: string): integer; // v.067
// does a quick read through the file to find out what Record Types are present and populates the stringlist with them.
// Returns the number of records in the file or -1 if an I/O error occurred.
var
  StdImportF: file of TImportFileRec;
  UserDefF: text;
  StdImportRec: TImportFileRec;
  S: string;
  RT: string;
  RecordCount: integer;
begin
  result := -1;
  ARecordTypes.Clear;
  RecordCount := 0;
  if CheckImportFileType(AFileName) = ftStdImport then begin
    AssignFile(StdImportF, AFileName);
    try
      reset(StdImportF);
      while {(IOResult = 0) and} not EOF(StdImportF) do begin
        read(StdImportF, StdImportRec);
        if AGlobalRecordType <> '' then // v.067
          RT := AGlobalRecordType       // v.067
        else                            // v.067
          RT := StdImportRec.RecordType;
        if ARecordTypes.IndexOf(RT) = -1 then // apparently there are bugs with duplicates=dupIgnore
          ARecordTypes.Add(RT);               // so we'll manually add any we haven't yet got
        inc(RecordCount);
      end;
      CloseFile(StdImportF);
    except on EInOutError do begin
      SetSysMsg(format('File "%s", Record %d: %s', [AFileName, RecordCount, SysErrorMessage(GetLastError)]));
      exit;
    end; end;
  end
  else begin
    AssignFile(UserDefF, AFilename);
    try
      reset(UserDefF);
      if AHeaderRecordPresent then begin
        ReadLn(UserDefF);
        inc(RecordCount);
      end;
      while {(IOResult = 0) and} not EOF(UserDefF) do begin
        ReadLn(UserDefF, S);
        if AGlobalRecordType <> '' then // v.067
          RT := AGlobalRecordType       // v.067
        else                            // v.067
        if (length(S) > 1) and (S[1] = '"') then     // record type is double-quoted   // v.065
          RT := copy(S, 2, 2)                                                          // v.065
        else
          RT := copy(S, 1, 2);

        if ARecordTypes.IndexOf(RT) = -1 then
          ARecordTypes.Add(RT);
        inc(RecordCount);
      end;
      CloseFile(UserDefF);
    except on EInOutError do begin
      SetSysMsg(format('File "%s", Record %d: %s', [AFileName, RecordCount, SysErrorMessage(GetLastError)]));
      exit;
    end; end;
  end;
  result := RecordCount;
end;

function FormatRunDateTime(RunDateTime: TDateTime): string;
// Formats a datetime using Today and Tomorrow if appropriate and only
// displaying whole minutes
begin
  if Trunc(RunDateTime) = Today then
    result := 'Today at ' + FormatDateTime('hh:nn', RunDateTime)
  else
    if Trunc(RunDateTime) = Tomorrow then
      result := 'Tomorrow at ' + FormatDateTime('hh:nn', RunDateTime)
    else
      result := FormatDateTime('dddd', RunDateTime) + ' ' + DateToStr(RunDateTime) + ' at ' + FormatDateTime('hh:nn', RunDateTime);
end;

procedure FormLoadSettings(Form: TForm; Control: TControl);
begin
  oSettings.LoadForm(Form);
  if Control <> nil then begin
    oSettings.LoadParentToControl(Form.Name, Form.Name, Control);
    oSettings.ColorFieldsFrom(Control, Control.Parent);
  end;
end;

procedure FormSaveSettings(Form: TForm; Control: TControl);
begin
  oSettings.SaveForm(Form);
  if Control <> nil then
    oSettings.SaveParentFromControl(Control, Form.Name);
end;

function FreeObjects(Objects: array of pointer): boolean;
// Allows several objects to be freed at once.
// Personally I've always thought it was a bit risky giving objects their
// freedom, so as you can imagine, freeing several of them at once is anathema
// to me. But I know I'm in the minority on this point, so you go ahead and free
// as many of the litte critters as you like. Just don't say I didn't warn you.
var
  i: integer;
begin
  result := false;
  try
    for i := low(Objects) to high(Objects) do
      if assigned(TObject(Objects[i])) then begin
        TObject(Objects[i]).Free;
      end;
  except
    exit; // could be an exception here which madExcept isn't trapping. Importer just disappears. This try/except is a test only
  end;
  result := true;
end;

function GetExePath: string;
// not sure
begin
  result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

function  GetLongPathName(const AShortPathName: string): string;
// if AShortPathName is the name of a folder we remove the trailing backslash
// and treat it as the file name.
var
  sr: TSearchRec;
  rc: integer;
  Dir: string;
  FN: string;
begin
  Dir := ExcludeTrailingPathDelimiter(AShortPathName);
  Dir := ExtractFilePath(Dir);
  FN  := ExtractFileName(ExcludeTrailingPathDelimiter(AShortPathName));
  rc := FindFirst(Dir + FN, faAnyFile, sr);
  if rc = 0 then
    FN := sr.Name;
  FindClose(sr);
  result := Dir + FN;
end;

function GetScreenPoint(AControl: TControl): TPoint;
// translates the Control's idea of where (0,0) is into screen co-ordinates.
// As Popup requires screen coordinates, this allows me to position a popup
// menu exactly over the top-left pixel of a button.
begin
  result := point(0,0);
  result := AControl.ClientToScreen(result);
end;

function  InAdminMode: boolean;
begin
  result := FAdminMode;
end;

function IncludeField(const AValue: string): boolean;
begin
  result := pos('[I]', AValue) = 1;
end;

function IsolateIniSection(AIniLines: TStringList; AIniSection: string): integer;
// The StringList contains all the lines from an ini file.
// This function deletes all lines which aren't name=value pairs from the specified section.
// Such that:-
//     IniLines.LoadFromFile('myfile.ini');
//     IsolateIniSection(IniLines, 'mysection');
// is then equivalent to
//     IniFile.LoadSectionValues('mysection', IniLines);
// except that we can have duplicate key names in the ini file which the windows API
// would otherwise have not included in IniLines.
var
  ix: integer;
begin
  result := -1;
try
  if AIniSection[1] <> '[' then
    AIniSection := '[' + AIniSection + ']';
  while (AIniLines.count > 0) and (AIniLines[0] <> AIniSection) do
    AIniLines.Delete(0); // delete until we find the [section] header

  if AIniLines.count = 0 then exit; // there was no such section

  AIniLines.Delete(0); // delete the [section] header

  ix := 0;
  while (ix <= AIniLines.count -1) and ((length(AIniLines[ix]) = 0) or (AIniLines[ix][1] <> '[')) do
    inc(ix);  // find the next [section] header, or the end of the list

  while (ix <= AIniLines.Count - 1) do
    AIniLines.Delete(ix); // delete from the next [section] header to the end

  for ix := AIniLines.count -1 downto 0 do // remove any blank lines
    if trim(AIniLines[ix]) = '' then
      AIniLines.Delete(ix);

  result := 0;
except on e:exception do
  SetSysMsg('Error in IsolateIniSection: ' + e.message);
end;
end;

procedure LBInit(LB: TListBox);
// not used
begin
  LB.Color      := ML_COLUMN_COLOR;
  LB.Font.Color := ML_FONT_COLOR;
  LB.Font.Style := ML_FONT_STYLE;
end;

function LoadFromStream(const AFileName: string; AStrings: TStrings): integer;
// TStrings.LoadFromFile in classes.pas opens the file as fmShareDenyWrite which
// causes problems if jobs are still running in the background, particularly
// when viewing the main Importer.log.
// So instead we create our own stream and load from that instead.
var
  Stream: TStream;
begin
  result := -1;
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    AStrings.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
  result := 0;
end;

procedure MLInit(ML: TMultiList);
// Sets the Multilist to the standard colours and font styles
//var
//  i: integer;
begin
//  ML.Font.Color          := ML_FONT_COLOR;
//  ML.Font.Style          := ML_FONT_STYLE;
//  ML.HeaderFont.Color    := ML_HEADERFONT_COLOR;
//  ML.HeaderFont.Style    := ML_HEADERFONT_STYLE;
//  ML.HighlightFont.Color := ML_HIGHLIGHTFONT_COLOR;
//  ML.HighlightFont.Style := ML_HIGHLIGHTFONT_STYLE;

//  for i := 0 to ML.columns.Count - 1 do
//    ML.DesignColumns[i].Color := ML_COLUMN_COLOR;

  ML.ForceXPButtons;
end;

procedure MLSelectFirst(ML: TMultiList);
// select the first row of a multilist
begin
  application.ProcessMessages;
  if ML.ItemsCount > 0 then
    ML.Selected := 0;
end;

procedure MLSelectLast(ML: TMultiList);
// select the last row of a multilist
begin
  application.ProcessMessages;
  if ML.ItemsCount > 0 then
    ML.Selected := ML.ItemsCount - 1;
end;

procedure MLSelectRow(ML: TMultiList; ARow: integer);
// select the given row of a multilist
begin
  application.ProcessMessages;
  ML.Selected := ARow;
end;

procedure MLSortColumn(ML: TMultiList; AColumn: integer; Ascending: boolean);
// sort the given column of a multilist
begin
  if ML.DesignColumns[AColumn].Items.Count > 0 then
    ML.SortColumn(AColumn, Ascending);
end;

procedure MenuPopup(APopupMenu: TPopupMenu; AControl: TControl);
// popup a menu positioned exactly on the top-left pixel of the Control.
// Popup requires screen coordinates so we call GetScreenPoint to get
// the position of the control.
begin
  APopupMenu.PopUp(GetScreenPoint(AControl).x, GetScreenPoint(AControl).y);
end;

procedure MLDeleteRow(ML: TMultiList; ARow: integer);
// delete the given row from the multilist
begin
  if ARow = -1 then exit;

  application.ProcessMessages;
  ML.DeleteRow(ARow);
end;

procedure MLDeleteSelectedRow(ML: TMultiList);
// deletes the selected row.
// if thats the last row, TMultiList doesn't leave a row selected
// so we try to select the previous row if there is one otherwise
// we select the first row (if there is one);
var
  ix : integer;
begin
  if ML.Selected = -1 then exit;

  application.ProcessMessages;
  ix := ML.Selected - 1;
  ML.DeleteRow(ML.Selected);
  if ML.ItemsCount = 0 then exit;

  if (ix <= ML.ItemsCount - 1) and (ix <> -1) then
    ML.Selected := ix
  else
    if ML.ItemsCount > 0 then
      ML.Selected := 0;
end;

procedure MLEditProperties(ML: TMultiList; Form: TForm; Control: TControl);
begin
  case oSettings.Edit(ML, Form.Name, Control) of
    mrOK : begin
             if Control <> nil then
               oSettings.ColorFieldsFrom(Control, Control.Parent);
             MLSaveSettings(ML, Form);
           end;
    mrRestoreDefaults : begin
      if Control <> nil then
        oSettings.RestoreParentDefaults(Control.Parent, Form.Name);
      oSettings.RestoreFormDefaults(Form.Name);
      oSettings.RestoreListDefaults(ML, Form.Name);
    end;
  end;
end;

procedure MLLoadSettings(ML: TMultiList; Form: TForm);
begin
  oSettings.LoadList(ML, Form.Name);
end;

procedure MLSaveSettings(ML: TMultiList; Form: TForm);
begin
  oSettings.SaveList(ML, Form.Name);
end;

procedure MLMoveSelectedRowDown(ML: TMultiList);
// move the currently selected row of the multilist down one
begin
  application.ProcessMessages;
  if ML.selected = ML.ItemsCount then exit;
  ML.MoveRow(ML.Selected, ML.Selected + 1);
  ML.Selected := ML.Selected + 1;
end;

procedure MLMoveSelectedRowUp(ML: TMultiList);
// move the currently selected row the multilist up one
begin
  if ML.selected < 1 then exit;
  application.ProcessMessages;
  ML.MoveRow(ML.Selected, ML.Selected - 1);
  ML.Selected :=ML.Selected - 1;
end;

function MyExpandFileName(BasePath, RelFileName: String): String;
// SysUtils.ExpandFileName calls Win32 API GetFullPathName.
// This takes a relative path and returns a full path but relative to GetCurrentDir.
// This means changing the system's current directory each time you want to expand a relative path.
// MyExpandFileName allows you to specify the base path so that this function is the inverse
// of SysUtils.ExtractRelativePath(BasePath, FullPath).
// Credit goes to Jens Gruschel@pegtop.net 2003. First one to meet him buy him a beer !
var
  I, J, Start: Integer;
begin
  if Pos(':', RelFileName) > 0 then Result := RelFileName
  else begin
    Result := BasePath;
    if (Result = '') or (Result[Length(Result)] <> '\') then Result := Result + '\';
    Start := 1;
    for I := 1 to Length(RelFileName) do begin
      if RelFileName[I] = '\' then begin
        if (I - Start = 1) and (Copy(RelFileName, Start, I - Start) = '.')  then begin
          // nothing happens
        end
        else if (I - Start = 2) and (Copy(RelFileName, Start, I - Start) =  '..') then begin
          // erase last subdir from result:
          J := Length(Result) - 1;
          while (J > 0) and (Result[J] <> '\') do Dec(J);
          SetLength(Result, J);
        end
        else if (I - Start > 0) then begin
          // add new subdir to result:
          Result := Result + Copy(RelFileName, Start, I - Start + 1);
        end;
        Start := I + 1;
      end;
    end;
    // add filename to result:
    Result := Result + Copy(RelFileName, Start, Length(RelFileName) - Start + 1);
  end;
end;

function  PercentDiskFree(const APath: string): integer;
var
  Drive: char;
  DriveNo: integer;
  SizeDisk: Int64;
  FreeDisk: Int64;
begin
  result := 0;
  if APath = '' then exit;
  
  Drive      := UpperCase(APath[1])[1];
  DriveNo    := ord(Drive) - 64;
  SizeDisk   := DiskSize(DriveNo);
  if SizeDisk < -1 then
    SizeDisk := MaxLongInt + SizeDisk;

  FreeDisk   := DiskFree(DriveNo);
  if FreeDisk < -1 then
    FreeDisk := MaxLongInt + FreeDisk;

  result := round(FreeDisk / SizeDisk * 100);
end;

function  RelativePath(AFullPath: string): string;
// If AFullPath is the name of a folder, callers must ensure that it ends with
// a trailing slash or this function will assume its ends in a file name and
// remove it.
begin
  result := AFullPath;
  if length(AFullPath) = 0 then exit;
  if AFullPath[length(AFullPath)] <> '\' then
    AFullPath := ExtractFilePath(AFullPath);
  result := ExtractRelativePath(GetEnterpriseDirectory, AFullPath);
end;

function  RemoveSpaces(AString: string): string;
// no idea what this does
var
  i: integer;
begin
  for i := length(AString) downto 1 do
    if AString[i] = #32 then
      delete(AString, i, 1);
  result := AString;
end;

procedure SetConstraints(Constraints: TSizeConstraints; height: integer; width: integer);
begin
  Constraints.MinHeight := height;
  Constraints.MaxHeight := height;
  Constraints.MinWidth  := width;
  Constraints.MaxWidth  := width;
end;

function SettingTF(Setting: string): boolean;
// determines whether a boolean value in an ini file denotes TRUE or FALSE
begin
  Setting := LowerCase(Setting);
  result := (Setting = 'y') or (Setting = 'yes') or (Setting = 'on') or (Setting = '1');
end;

function  SettingTypeFromString(const ASettingType: string): TSettingType;
// ASettingType comes from a Type=??? entry in the main settings file.
// This translates it to a TSettingType for use in case/if statements.
begin
  if ASettingType = 'FixedList' then
    result := stFixedList
  else
  if ASettingType = 'Folder' then
    result := stFolder
  else
  if ASettingType = 'File' then
    result := stFile
  else
  if ASettingType = 'ExchComp' then
    result := stDataPath
  else
  if ASettingType = 'Time' then
    result := stTime
  else
  if ASettingType = 'SmallInt' then
    result := stSmallInt
  else
  if ASettingType = 'LongInt' then
    result := stLongInt
  else
  if ASettingType = 'Decimal' then
    result := stDouble
  else
    result := stFreeText;
end;

function  SettingTypeFromDataType(DataType: char): TSettingType;
begin
  case DataType of
    'S':  result := stFreeText; // string
    'D':  result := stDouble;   // double
    'I':  result := stSmallInt; // smallint
    'C':  result := stChar;     // char
    'W':  result := stWordBool; // wordbool
    'L':  result := stLongInt;  // longint
    'B':  result := stByte;     // byte
    'b':  result := stBoolean;  // boolean

    'T':  result := stTime;     // time
    'P':  result := stDataPath; // path - no longer used 
    'F':  result := stFile;     // File name
    'M':  result := stFileorPathWithMask; // file name with mask
  else
    result := stUnknown;
  end;
end;

procedure ShiftFocus(handle: HWND; WinControl: TWinControl);
// Used primarily to get round a problem of TMultiLists retaining the focus
// after a double-click when we've tried to move the focus somewhere else.
// Subsequently changed to also override the default behaviour of highlighting
// all the text in a TEdit when it receives focus.
// Of limited use now that all the original edit boxes in the wizard have been
// replaced with TfrmEditBox.
begin
  if WinControl.Visible and WinControl.Enabled then begin
//    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    WinControl.SetFocus;
    if WinControl is TEdit then
      with WinControl as TEdit do begin
        SelLength := 0; // don't highlight the whole value
        SelStart  := length(text); // position the caret at the end of the text
      end;
  end;
end;

function StorageSize(FieldType: char; FieldLen: word): word;
// returns the storage size for a given data type of a given length
begin
  result := 0; // suppress compiler warning
  case FieldType of
  'S':  result := FieldLen + 1;      // number of characters plus a length byte
  'D':  result := SizeOf(Double);
  'I':  result := SizeOf(SmallInt);
  'C':  result := FieldLen;          // 1 if char; else FieldLen if array[1..FieldLen] of char;
  'W':  result := SizeOf(WordBool);
  'L':  result := SizeOf(LongInt);
  'B':  result := SizeOf(Byte);
  'b':  result := SizeOf(boolean);
  end;
end;

function SwapFields(FieldDefs: TStringList): boolean; // v.075
// Determine if a record type has any fields which have been superseded by new ones, e.g. YourRef on a Transaction Header.
// If the user has a field map containing the old field, replace the old field def with the new one.
// v.076 forgot to allow for A013-type fields on  a OL and RL record types as opposed to F013-type fields.
var
  i: integer;
  OldFieldDef: TFieldDef;
  NewFieldDef: TFieldDef;
  OriginalFieldDefault: string;
  OldFieldNo: string;
  NewFieldNo: string;
  SwapSection: string;
  RecordSection: string;
  NewFieldDefValue: string;
begin
  result := false;
  for i := 0 to FieldDefs.Count - 1 do begin
    IniFile.ReturnDataInFieldDef(FieldDefs[i], OldFieldDef);
    OldFieldNo := OldFieldDef.FieldNo;                                // e.g. F013 // e.g. 013, v.076
    SwapSection := 'Swap' + OldFieldDef.RecordType;                   // e.g. [SwapTH]
    NewFieldNo := IniFile.ReadString(SwapSection, OldFieldNo, '');    // e.g. F111 // e.g. 111, v.076
    if NewFieldNo <> '' then begin
      OriginalFieldDefault := OldFieldDef.FieldDefault;
      RecordSection        := IniFile.ReturnValue(DETAIL_RECS, OldFieldDef.RecordType);  // e.g. "TH=Trans Header" returns "Trans Header"
      NewFieldDefValue     := IniFile.ReturnValue(RecordSection, 'F' + NewFieldNo); // e.g. [Trans Header].F111="<record value>" // v.076
      NewFieldDefValue     := OldFieldDef.FieldDefType + NewFieldNo + '=' + NewFieldDefValue;  // formulate a new F111=<record value> entry string // v.076
      IniFile.ReturnDataInFieldDef(NewFieldDefValue, NewFieldDef);            // populate the new TFieldDef from the string
      NewFieldDef.FieldDefault := OldFieldDef.FieldDefault;                   // Use the user's default from their field map file
      FieldDefs[i] := IniFile.ReturnFieldDefInString(NewFieldDef);            // Get the TFieldDef as a string and write over the original
      result := true;                                                         // fields have been swapped
    end;
  end;
end;

function  ValidKeyPress(Key: char; DataType: char; PosDot: integer): char;
// if the typed character is in the set of valid characters for the type of
// data then it is returned, otherwise return character zero to suppress it.
begin
  result := Key;
  if Key in [#8, #127] then exit; // always allow Backspace and Del
  case DataType of
    'S':                                                     exit;                // string
    'D':  if (Key in ['+', '-', '0'..'9']) or ((Key = '.') and (PosDot = 0))  then exit;                // double
    'I':  if Key in ['+', '-', '0'..'9']                then exit;                // smallint
    'C':                                                     exit;                // char
    'W':  if Key in ['1', '0', 't', 'f', 'T', 'F', 'y', 'n', 'Y', 'N'] then exit; // wordbool
    'L':  if Key in ['+', '-', '0'..'9']                then exit;                // longint
    'B':  if Key in ['0'..'9']                          then exit;                // byte
    'b':  if Key in ['1', '0', 't', 'f', 'T', 'F', 'y', 'n', 'Y', 'N'] then exit; // boolean

    'T':  if Key in ['0'..'9', ':']                     then exit;                // time
    'P':  if not (Key in ['/', '*', '?', '"', '<', '>', '|']) then exit;          // path
    'F':  if not (Key in ['\', '/', ':', '*', '?', '"', '<', '>', '|']) then exit;// File name
    'M':  if not (Key in ['\', '/', ':', '?', '"', '<', '>', '|']) then exit;// File name with mask
  end;
  result := #0;
end;

procedure WindowMoving(var msg: TMessage; height: integer; width: integer);
// prevent an MDIChild from being moved outside of the visible boundaries of the
// MDIForm.
// Rect contains the top/left position and bottom/right size of the window.
var
  Rect: PRect;
begin
  EXIT; // works, but not wanted.

  if SchedulerMode then exit;
  Rect := PRect(msg.LParam);
  if Rect^.Left < 2 then begin
    Rect^.Left := 2;
    Rect^.right := Rect^.Left + width; // stops the window from resizing
  end;
  if Rect^.Top < MainClientTop then begin
    Rect^.Top := MainClientTop;
    Rect^.Bottom := Rect^.Top + height; // stops the window from resizing
  end;
  if Rect^.Left > (MainClientWidth - 2) - width then begin
    Rect^.Left  := MainClientWidth - 2 - width;
    Rect^.Right := Rect^.Left + width; // stops the window from resizing
  end;
  if Rect^.Bottom > MainClientBottom - 1 then begin
    Rect^.Top := MainClientBottom - height;
    Rect^.Bottom := Rect^.Top + height; // stops the window from resizing
  end;

  msg.LParam := integer(Rect);
end;

function  WindowsUserName: string;
var
  UserName: array[0..30] of char;
  BufLen: dword;
begin
  BufLen := 30;
  GetUserName(UserName, BufLen);
  result := string(UserName);
end;

{$IFNDEF SQLHELPER}
procedure WriteIniLogonInfo(IniFile: TMemIniFile);
// Writes the company login info to the IniFile which would normally be a job file
begin
  IniFile.WriteString(IMPORT_SETTINGS, 'Exchequer Company', LoginCompany);
  IniFile.WriteString(IMPORT_SETTINGS, 'UserName', LoginUserName); // LoginUserName is encrypted
  IniFile.WriteString(IMPORT_SETTINGS, 'Password', LoginPassword); // LoginPassword is encrypted
  
  //SS:10/10/2017:2017-R2:ABSEXCH-19432:'Windows User ID' is displayed in Exchequer instead of 'Username' of the User when data is Imported using Importer
  IniFile.WriteString(IMPORT_SETTINGS, 'LoginDisplayName', LoginDisplayName); // LoginDisplayName is encrypted
end;
{$ENDIF SQLHELPER}

initialization
  FAdminMode := false;
  sMiscDirLocation := GetEnterpriseDirectory;

end.
