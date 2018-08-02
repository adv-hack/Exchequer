unit TIniClass;

{******************************************************************************}
{ The TIni class is for reading a modified version of the regular ini file     }
{ format developed for Importer.                                               }
{                                                                              }
{ As you know, an INI file contains Sections, Value Names and Values.          }
{ Using the standard ini file API calls you would specifiy the section and     }
{ value name on each call, e.g.  ReadString(Section, ValueName, '');           }
{ TIni encapsulates this slightly differently in that you first specify the    }
{ section that you will be working on (a bit like doing an OpenKey) and then   }
{ work on the value names.                                                     }
{    E.g. LoadSection('Setup');                                                }
{         MyDateFormat := CurrentSectionValue['DateFormat'];                   }
{         MyDefPath    := CurrentSectionValue['MyDefPath'];                    }
{                                                                              }
{ A TIni file can be a mixture of regular ini file sections as well as         }
{ sections whose records conform to the TFieldDef type.                        }
{                                                                              }
{ Standard ini file sections can contain a semi-colon followed by a comment    }
{ like the old Win3.1 INI files, e.g......                                     }
{ FieldDefs=NO         ; this section doesn't define Fields                    }
{                                                                              }
{ Loadxxxx methods read information from the ini file into TIni's internal     }
{ data stores. The currently loaded section must be taken into account when    }
{ calling these methods.                                                       }
{ Returnxxxx methods read information from the ini file and return it          }
{ directly to the caller without modifying TIni's internal data stores.        }
{                                                                              }
{ 12/2005 Modified to use BigIni instead of the standard IniFiles.             }
{ BigIni follows the standard functionality in all but two major respects:-    }
{ 1. BigIni allows any size ini file on all Windows platforms - current file is}
{    over 200K so this allows Importer to be used on pre-Windows 2000 systems. }
{ 2. During Create, BigIni reads the entire ini file into memory. Other than   }
{    when the TBigIni object is Freed, TBigIni.FlushFile is only called during }
{    WriteString and WriteAnsiString (and then only if null key values are     }
{    passed as parameters), LaunchInEditor and UpdateFile.                     }
{    Importer avoids each of these cases so the ini file is only read during   }
{    Create and only written during Destroy. This allows us to DecryptIniFile  }
{    while the TBigIni object is created and immediately EncryptIniFile.       }
{    We do exactly the same when the object is freed so that updates can be    }
{    written to the file.                                                      }
{                                                                              }
{  Importer's main settings ini file is encrypted and renamed with a .dat      }
{  extension to prevent users meddling with it.                                }
{******************************************************************************}

interface

uses classes, {IniFiles, }Utils, uMultilist, GlobalTypes, TBigIniClass, dialogs;


type

  TIni = class(TObject)
  private
{* internal fields *}
    FIniFile: TBigIniFile;
    FIniStream: TFileStream; // used to encrypt/decrypt the file and keep it locked while decrypted
    FFieldDefCopy: TFieldDef;
    FCurrentRecordNo: integer;
    FCurrentSection: string;
    FFieldDefs: boolean;
    FRecordTypes: TStringList;
    FMemStream: TMemoryStream; // v.064
    FIniSL: TStringList;       // v.064
{* property fields *}
    FCurrentSectionValueComment: string;
    FCurrentSectionValues: TStringList;
    FFieldDef: TFieldDef;
    FIniFileName: string;
    FIniSections: TStringList;
{* procedural methods *}
    procedure CreateIniFile;
    procedure FindIniFile;
    procedure ReadIniSections;
{* getters and setters *}
    function  GetCurrentSectionValuesCount: integer;
    function  GetCurrentSectionValue(const AName: string): string;
    function  GetCurrentSectionValueName(index: integer): string;
    function  GetImportRecordSize: integer;
    function  GetRecordSize: integer;
    function  GetfdFieldNo: string;
    function  GetfdFieldDefType: string;
    function  GetfdFieldName: string;
    function  GetfdOccurs: string;
    function  GetfdCommentEquals: string;
    function  GetfdUsage: string;
    function  GetfdDefaultEquals: string;
    function  GetfdFieldComment: string;
    function  GetfdFieldDefault: string;
    function  GetfdFieldDesc: string;
    function  GetfdFieldType: string;
    function  GetfdFieldWidth: string;
    function  GetfdDelphiDef: string;
    function  GetfdEquals: string;
    function  GetfdDot: string;
    function  GetfdRecordType: string;
    function  GetSortRequired: boolean;
    function  GetfdOffset: string;
    function  GetfdNotUsed: boolean;
    function  GetfdReadOnly: boolean;
    procedure SetfdOccurs(const Value: string);
    procedure SetfdFieldDefType(const Value: string);
    procedure SetfdFieldName(const Value: string);
    procedure SetfdFieldNo(const Value: string);
    procedure SetfdCommentEquals(const Value: string);
    procedure SetfdCritera(const Value: string);
    procedure SetfdDefaultEquals(const Value: string);
    procedure SetfdFieldComment(const Value: string);
    procedure SetfdFieldDefault(const Value: string);
    procedure SetfdFieldDesc(const Value: string);
    procedure SetfdFieldType(const Value: string);
    procedure SetfdFieldWidth(const Value: string);
    procedure SetfdEquals(const Value: string);
    procedure SetfdDot(const Value: string);
    procedure SetfdRecordType(const Value: string);
    procedure SetfdOffset(const Value: string);
    procedure SetCurrentSectionValue(const AName: string; const Value: string);
    procedure SetIniFileName(const Value: string);
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(const Value: string);
    function  GetCurrentSectionRecord(ARecordNo: integer): string;
    function  GetSectionExists(const ASection: string): boolean;
    function  GetValueNameExists(const ASection: string; AValueName: string): boolean;
    function  GetVersion: string;
    procedure SetfdFieldSys(const Value: string);
    function  GetfdFieldSys: string;
    procedure WriteFileWithRetry(const AStream : TMemoryStream;
                                 const Filename : string);
  public
    constructor create;
    constructor CreateWithPath(const sPath : string); //PR: 11/11/2009 Added to allow install to update settings file
    destructor  destroy; override;
    procedure FieldDefBeginUpdate;
    procedure FieldDefCancelUpdate;
    function  DecryptIniFile(AIniFileName: string; ToStream: boolean): TMemoryStream;
    procedure EncryptIniFile(AIniFileName: string);
    function  FindFieldDesc(AFieldDesc: string): string;
    procedure LockIniFile;
    procedure UnLockIniFile;
// Load methods populate TIni's internal data stores
    function  LoadIniSectionValues(const ASection: string): integer;
    function  LoadRecord(RecordNo: integer): integer;
    function  LoadRecordTypes: integer;
// Return methods return data to the caller via the supplied parameter
    function  ReturnDataInFieldDef(DataValue: string; var OutRecord: TFieldDef): integer;
    function  ReturnFieldDefInString(const FieldDef: TFieldDef): string;
    function  ReturnFieldDefInML(ML: TMultiList): integer;
    function  ReturnCurrentSectionNamesAndValues(Names: TStrings; Values: TStrings): integer;
    function  ReturnValue(const ASection: string; const AName: string): string; // except this one !
    function  ReturnValuesInList(const ASection: string; AStringList: TStringList): integer;
// Standard TIniFile methods
    function  DeleteKey(const ASection, AIdent: String): integer;
    function  EraseSection(const ASection: string): integer;
    function  ReadString(const ASection, AName, ADefault: String): string;
    function  WriteString(const ASection: string; const AName: string; const AValue: string): integer;
// others
    function  WriteFieldDef(RecordNo: integer; WriteToFile: boolean): integer;
    function  ValidFieldDef(AFieldDef: TFieldDef): boolean;
    property  fdDelphiDef: string read GetfdDelphiDef;
    property  fdFieldDefType: string read GetfdFieldDefType write SetfdFieldDefType;
    property  fdFieldNo: string read GetfdFieldNo write SetfdFieldNo;
    property  fdEquals: string read GetfdEquals write SetfdEquals;
    property  fdRecordType: string read GetfdRecordType write SetfdRecordType;
    property  fdDot: string read GetfdDot write SetfdDot;
    property  fdFieldName: string read GetfdFieldName write SetfdFieldName;
    property  fdOffset: string read GetfdOffset write SetfdOffset;
    property  fdOccurs: string read GetfdOccurs write SetfdOccurs;
    property  fdFieldType: string read GetfdFieldType write SetfdFieldType;
    property  fdFieldWidth: string read GetfdFieldWidth write SetfdFieldWidth;
    property  fdUsage: string read GetfdUsage write SetfdCritera;
    property  fdFieldSys: string read GetfdFieldSys write SetfdFieldSys;
    property  fdFieldDesc: string read GetfdFieldDesc write SetfdFieldDesc;
    property  fdDefaultEquals: string read GetfdDefaultEquals write SetfdDefaultEquals;
    property  fdFieldDefault: string read GetfdFieldDefault write SetfdFieldDefault;
    property  fdCommentEquals: string read GetfdCommentEquals write SetfdCommentEquals;
    property  fdFieldComment: string read GetfdFieldComment write SetfdFieldComment;
    property  fdNotUsed:  boolean read GetfdNotUsed;
    property  fdReadOnly: boolean read GetfdReadOnly;
    property  IniFileName: string read FIniFileName write SetIniFileName;
    property  FieldDef: TFieldDef read FFieldDef;
    property  IniSections: TStringList read FIniSections;
    property  CurrentSection: string read FCurrentSection; // v.064
    property  CurrentSectionRecord[ARecordNo: integer]: string read GetCurrentSectionRecord;
    property  CurrentSectionValue[const AName: string]: string read GetCurrentSectionValue write SetCurrentSectionValue;
    property  CurrentSectionValueComment: string read FCurrentSectionValueComment;
    property  CurrentSectionValues: TStringList read FCurrentSectionValues;
    property  CurrentSectionValuesCount: integer read GetCurrentSectionValuesCount;
    property  CurrentSectionValueName[index: integer]: string read GetCurrentSectionValueName;
    property  ImportRecordSize: integer read GetImportRecordSize;
    property  RecordSize: integer read GetRecordSize;
    property  SectionExists[const ASection: string]: boolean read GetSectionExists;
    property  SortRequired: boolean read GetSortRequired;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
    property  ValueNameExists[const ASection: string; AValueName: string]: boolean read GetValueNameExists;
    property  Version: string read GetVersion;
  end;

var
  IniFile: TIni;  // a global instance of TIni which all units use

implementation

uses SysUtils, GlobalConsts, TErrors, BlowFish;

const
  IMPORTER_INIFILE = 'importer.dat';

{ TIni }

constructor TIni.create;
begin
  inherited;

  FindIniFile;     // Get the default file name
  CreateIniFile;   // create the internal TIniFile object that TIni operates on
  ReadIniSections; // Read all the section names into a TStringList
  LoadRecordTypes; // get all the valid two-character record types.
end;

destructor TIni.destroy;
begin
  DecryptIniFile(FIniFileName, false);
  if assigned(FIniFile) then begin
    FIniFile.Free; // causes any changes to be written to the file
    FIniFile := nil;
  end;
  if not PlainOut then
    EncryptIniFile(FIniFileName);

  FreeObjects([FIniSections, FCurrentSectionValues, FRecordTypes, FMemStream, FIniSL]); // v.064 added FMemStream and FIniSL;

  inherited;
end;

{* Procedural Methods *}

procedure TIni.CreateIniFile;
// creates the internal TIniFile object that TIni operates on
// TBigIniFile loads the ini file into memory by calling it's AppendFromFile method
// which is a side effect of setting the file name in SetFileName;
// TBigIniFile reads from the ini file during Create and writes changes to the
// file during Destroy. At all other times the ini file is not open.
begin
  DecryptIniFile(FIniFileName, false);
  FIniFile := TBigIniFile.Create(IniFileName);
  if not PlainOut then
    EncryptIniFile(FIniFileName);
end;

function TIni.DeleteKey(const ASection, AIdent: String): integer;
begin
  result := -1;
  try
    FIniFile.DeleteKey(ASection, AIdent);
  except
  end;
  result := 0;
end;

function TIni.EraseSection(const ASection: string): integer;
begin
  result := -1;
  try
    FIniFile.EraseSection(ASection);
  except
  end;
  result := 0;
end;

procedure TIni.FindIniFile;
// Sets the IniFileName property to the default file name
begin
  SetIniFileName(GetExePath + IMPORTER_INIFILE);
end;

function TIni.LoadRecord(RecordNo: integer): integer;
// Mimics reading a record from a file of type TFieldDef, except that this way
// allows our incoming records to be variable length so FieldComment doesn't need to be padded out
// to the exact length of TFieldDef and we do the padding here.
// The whole "file" is stored in a standard INI file section.
var
  NameValue: string;
begin
  result := 0;
  if RecordNo = -1 then exit;
  
  NameValue := FCurrentSectionValues[RecordNo];
  ReturnDataInFieldDef(NameValue, FFieldDef);

  FCurrentRecordNo := RecordNo;
end;

function TIni.DecryptIniFile(AIniFileName: string; ToStream: boolean): TMemoryStream;
// 1. Reads the encrypted ini file into the input stream,
// 2. decrypts the input stream to the output stream,
// 3. Writes the decrypted output stream back to the ini file.
// The ini file should always start with a section.
// Knowing this, we can check for a valid decryption before overwriting the file.
// Also, if Importer crashes, e.g. with a BTrieve conflict, it can leave the settings
// file in the wrong state. The integrity checks ensure that the file doesn't become
// corrupted by decrypting an already decrypted file.
// If the caller wants access to the decrypted stream we pass it back as the result
// and its up to the caller to free it. We don't save the decrypted contents to disk.
// DO NOT CHANGE THE INITIALISE STRING !
var
  BlowFish: TBlowFish;
  MSI, MSO: TMemoryStream;
  StreamKey: char;
begin
  result := nil;
  if not FileExists(AIniFileName) then exit;
try
  BlowFish := TBlowFish.Create(nil);
  try
    BlowFish.CipherMode := ECB;
//    BlowFish.LoadIVString('F2ABC392'); // only for CBC, CFB and OFB cipher modes
//    BlowFish.InitialiseString('8F3319');
    BlowFish.InitialiseString('050242617A7A612021030604'); // a  seemingly random sequence of ascii Hex codes

    MSI := TMemoryStream.Create;
    MSO := TMemoryStream.Create;
    try
      MSI.LoadFromFile(AIniFileName); // load the file into the stream
      MSI.Seek(0, soFromBeginning);   // ReadBuffer operates from the current position so back up
      MSI.ReadBuffer(StreamKey, SizeOf(StreamKey));  // read the first few characters
      MSI.Seek(0, soFromBeginning);   // Back up again
      result := MSI;  // set the result to the input stream in case it's not encrypted and ToStream=True
      if StreamKey = '[' then exit; // file isn't encrypted

      BlowFish.DecStream(MSI, MSO);   // decrypt input stream to output stream
      MSO.Seek(0, soFromBeginning);   // go to start of output stream
      MSO.ReadBuffer(StreamKey, SizeOf(StreamKey));  // read the first few characters
      if StreamKey <> '[' then // Check that it decrypted ok before overwriting file
        raise exception.Create('Cannot read ' + AIniFileName);
      MSO.Seek(0, soFromBeginning);   // go to start of output stream for caller to use
      result := MSO;
      if not ToStream then
                                        // save the decrypted file back to disk ready for TBigIni to read or write
                                        // but only now we know the contents are valid
        //PR: 16/02/2018 ABSEXCH-19822 Remove call to MSO.SaveToFile and use retry procedure instead
        WriteFileWithRetry(MSO, AIniFilename);

    finally
      if (result = MSO) or not ToStream then
        MSI.Free;                       // caller won't be using this so needs to be freed here
      if (result = MSI) or not ToStream then
        MSO.Free;                       // caller won't be using this so needs to be freed here
    end;

    BlowFish.Burn;
  finally
    BlowFish.Free;
  end;
except on e:exception do
  ShowMessage(e.Message + ' while reading ' + AIniFileName);
end;
end;

procedure TIni.EncryptIniFile(AIniFileName: string);
// 1. Reads the plain ini file into the input stream,
// 2. Encrypts the input stream to the output stream,
// 3. Writes the encrypted output stream back to the ini file.
// The ini file should always start with a section.
// Knowing this, we can check for a valid encryption before overwriting the file.
// Also, if Importer crashes, e.g. with a BTrieve conflict, it can leave the settings
// file in the wrong state. The integrity checks ensure that the file doesn't become
// corrupted by encrypting an already encrypted file.
// DO NOT CHANGE THE INITIALISE STRING !
const
  CryptKey: string[9] = chr($7A) + chr($A4) + chr($97) + chr($09) + chr($0C) + chr($55) + chr($3B) + chr($D1) + chr($16);
var
  BlowFish: TBlowFish;
  MSI, MSO: TMemoryStream;
  StreamKey: char;
begin
  if not FileExists(AIniFileName) then exit;
try
  BlowFish := TBlowFish.Create(nil);
  try
    BlowFish.CipherMode := ECB;
//    BlowFish.LoadIVString('F2ABC392');  // only for CBC, CFB and OFB cipher modes
//    BlowFish.InitialiseString('8F3319');
    BlowFish.InitialiseString('050242617A7A612021030604'); // a seemingly random sequence of ascii Hex codes

    MSI := TMemoryStream.Create;
    MSO := TMemoryStream.Create;
    try
      MSI.LoadFromFile(AIniFileName); // load the file into the input stream
      MSI.Seek(0, soFromBeginning);   // ReadBuffer operates from the current position so back up
      MSI.ReadBuffer(StreamKey, SizeOf(StreamKey));   // read the first few characters
      if StreamKey <> '[' then exit; // it's already encrypted

      MSI.Seek(0, soFromBeginning);   // back to top again
      BlowFish.EncStream(MSI, MSO);   // encrypt the input stream to the output stream
      MSO.Seek(0, soFromBeginning);   // back to the start of the output stream
      MSO.ReadBuffer(StreamKey, SizeOf(StreamKey));   // read the first few characters

      if StreamKey = '[' then   // check that it encrypted ok before overwriting file
        raise exception.Create('Cannot write ' + AIniFileName);
                                      // save the encrypted file over the top of the original disk file
                                      // but only now we know the contents are valid
        //PR: 16/02/2018 ABSEXCH-19822 Remove call to MSO.SaveToFile and use retry procedure instead
        WriteFileWithRetry(MSO, AIniFilename);
    finally
      MSI.Free;
      MSO.Free;
    end;

    BlowFish.Burn;
  finally
    BlowFish.Free;
  end;
except on e:exception do
  ShowMessage(e.Message + ' while writing ' + AIniFileName);
end;
end;

procedure TIni.LockIniFile;
// The original idea was to DecryptIniFile and LockIniFile upon program startup
// Then UnlockIniFile and LockIniFile each time it was written to.
// This way the user can't open the unencrypted version in Notepad while the program's running.
// Finally, on program close, do UnlockIniFile and EncryptIniFile.
// However, a program crash would leave the file unencrypted and upon re-running
// the program, DecryptIniFile would immediately fail.
// Therefore, we DecryptIniFile when we need to read or write to it and
// immediately EncryptIniFile.
// So LockIniFile and UnlockIniFile aren't used.
begin
  FIniStream := TFileStream.Create(FIniFileName, fmOpenRead or fmShareExclusive);
end;

procedure TIni.UnLockIniFile;
// see LockIniFile
begin
  if assigned(FIniStream) then
    FIniStream.Free;
end;

procedure TIni.ReadIniSections;
// reads all the [section] names into FIniSections
begin
  if not assigned(FIniSections) then
    FIniSections := TStringList.Create;

  FIniFile.ReadSections(FIniSections);
end;

function TIni.ReadString(const ASection, AName, ADefault: String): string;
begin
  result := FIniFile.ReadString(ASection, AName, ADefault);
end;

function TIni.LoadIniSectionValues(const ASection: string): integer;
// reads all the name=value pairs from a given section in the INI file
begin
  result := 0;
  if not assigned(FCurrentSectionValues) then
    FCurrentSectionValues := TStringlist.Create;

  FCurrentSectionValues.Clear;
  FIniFile.ReadSectionValues(ASection, FCurrentSectionValues);
  FCurrentSection := ASection;
  FCurrentRecordNo := -1; // no record selected yet, v.064

  FFieldDefs := ReadString(FIELD_DEFS, ASection, 'No') = 'Yes'; // is this a FieldDefs section ?
end;

function TIni.ValidFieldDef(AFieldDef: TFieldDef): boolean;
// For INI file sections which describe an Exchequer Record layout all records in the section
// should conform to a TFieldDef record type (described at the top of this unit).
// This function provides a quick and dirty check that the Ini file record is well-formed,
// i.e. all the data is in the correct columns etc.
// A prior call to LoadRecord should have established the record to be tested.
begin
  with FieldDef do
    result := (FieldDefType  in ['S', 'A', 'F'])
          and (FieldNo[1]    in ['0'..'9'])
          and (FieldNo[2]    in ['0'..'9'])
          and (FieldNo[3]    in ['0'..'9'])
          and (equals        = '=')
          and (FRecordTypes.IndexOfName(RecordType) <> -1)
          and (dot           = '.')
          and (FieldName     <> '')
          and (blank1        = ' ')
          and (offset[1]     in ['0'..'9', ' '])
          and (offset[2]     in ['0'..'9', ' '])
          and (offset[3]     in ['0'..'9', ' '])
          and (offset[4]     in ['0'..'9', ' '])
          and (blank2        = ' ')
          and (occurs[1]     in ['0'..'9', ' '])
          and (occurs[2]     in ['0'..'9', ' '])
          and (blank3        = ' ')
          and (FieldType     in ['S', 'C', 'W', 'I', 'D', 'L', 'B', 'b'])
          and (blank4        = ' ')
          and (FieldWidth[1] in ['0'..'9'])
          and (FieldWidth[2] in ['0'..'9'])
          and (FieldWidth[3] in ['0'..'9'])
          and (FieldWidth[4] in ['0'..'9'])
          and (blank5        = ' ')
          and (FieldUsage    in ['M', 'O', 'F', 'N', 'R', '1'..'9', 'A'..'C'])
          and (blank6        = ' ')
          and (FieldSys      in ['X', 'I', ' '])
          and (blank7        = ' ')
          and (FieldDesc     <> '')
          and (blank8        = ' ')
          and (DefaultEquals = 'default=')
          and (blank9        = ' ')
          and (CommentEquals = 'comment=');
end;

function TIni.ReturnCurrentSectionNamesAndValues(Names, Values: TStrings): integer;
// For the current INI file section (which was loaded by LoadCurrentSectionValues),
// read the name= parts into the Names parameter, read the =value parts into the Values parameter.
// This was written with the loading of two columns of a TMultiList specifically in mind:-
// e.g. LoadIniSectionNamesValues(ML.DesignColumns[0].items, ML.DesignColumns[1].items)
var
  i: integer;
begin
  result := 0;
  for i := 0 to CurrentSectionValuesCount - 1 do begin
    Names.Add(CurrentSectionValueName[i]);
    Values.Add(CurrentSectionValue[CurrentSectionValueName[i]]);
  end;
end;

function TIni.WriteFieldDef(RecordNo: integer; WriteToFile: boolean): integer;
// Writes the current contents of the TFieldDef to the INI file and replaces the record in memory.
// The appropriate section will have been read by LoadCurrentSectionValues and the contents of FFieldDef will
// have been set by LoadRecord. Thereafter, changes will have been applied to FFieldDef by
// setting the fdxxxxxxx properties or setting the entire value via CurrentSectionValue.
const
  Offset = SizeOf(FFieldDef.FieldDefType) + SizeOf(FFieldDef.FieldNo) + SizeOf(FFieldDef.equals)
           { SizeOf(FFieldDef.RecordType) + SizeOf(FFieldDef.dot)}+ 1;
var
  ValueName: string;
  NameValue: array[0..SizeOf(FFieldDef) - SizeOf(FFieldDef.FieldDefType) - SizeOf(FFieldDef.FieldNo) - SizeOf(FFieldDef.Equals)] of char;
begin
  result := 0;
  ValueName := fdFieldDefType + fdFieldNo;
  FillChar(NameValue, SizeOf(NameValue), #32);
  StrLCopy(NameValue, @FFieldDef.AsArray[Offset], SizeOf(NameValue) - 1);
  CurrentSectionValue[ValueName] := NameValue;
  if WriteToFile then
    FIniFile.WriteString(FCurrentSection, ValueName, string(NameValue));
end;

procedure TIni.FieldDefBeginUpdate;
// takes a copy of the current FieldDef. The caller can then amend the current record
// using the fdxxxxx properties. If the user cancels the edit the copy should be restored
// by calling FieldDefCancelUpdate;
begin
  FFieldDefCopy := FFieldDef;
end;

procedure TIni.FieldDefCancelUpdate;
// restores the copy of the current FieldDef taken by FieldDefBeginUpdate;
begin
  FFieldDef := FFieldDefCopy;
end;

function TIni.FindFieldDesc(AFieldDesc: string): string;
// reads thru the entire settings INI file to find a Field Def that contains
// the given FieldDesc.
// The function returns the section, i.e. the record type, that contains the
// field.
// If no such field is found it returns an empty string.
var
  i: integer;
  CurrentSection: string;
  CurrentLine: string;
  FieldDef: TFieldDef;
begin
  if not assigned(FMemStream) then begin
    FMemStream := DecryptIniFile(FIniFileName, true); // get the entire settings file as a stream
    FIniSL := TStringList.create;
    FIniSL.LoadFromStream(FMemStream); // load the stream into stringlist
  end;

  AFieldDesc := trim(AFieldDesc);

  CurrentSection := ''; // default result

  for i := 0 to FIniSL.Count - 1 do begin
    CurrentLine := trim(FIniSL[i]);
    if CurrentLine = '' then continue; // ignore blank lines

    if CurrentLine[1] = '[' then begin            // here's a section name
      CurrentSection := copy(CurrentLine, 2, pos(']', CurrentLine) - 2);
      result := CurrentSection;
      continue;
    end;

    if CurrentSection = '' then continue; // find the first section header

    ReturnDataInFieldDef(CurrentLine, FieldDef); // structure the data

    if trim(FieldDef.FieldDesc) = AFieldDesc then exit; // found it. result already set to current section.
  end;

  result := ''; // leave empty-handed
end;

function TIni.ReturnFieldDefInML(ML: TMultiList): integer;
// Load the columns of the ML with the fields of the current record
// This procedure expects the ML to have been defined with the following columns (!)
begin
  result := 0;
  with ML do begin
    DesignColumns[0].Items.add(fdFieldDefType + fdFieldNo);
    DesignColumns[1].Items.add(fdRecordType);
    DesignColumns[2].items.add(fdFieldName);
    DesignColumns[3].Items.add(fdOffset);
    DesignColumns[4].Items.add(fdOccurs);
    DesignColumns[5].Items.add(fdFieldType);
    DesignColumns[6].Items.add(fdFieldWidth);
    DesignColumns[7].Items.add(fdUsage);
    DesignColumns[8].Items.add(fdFieldSys);
    DesignColumns[9].Items.add(fdFieldDesc);
    DesignColumns[10].Items.add(fdDefaultEquals);
    DesignColumns[11].Items.add(fdFieldDefault);
    DesignColumns[12].Items.add(fdCommentEquals);
    DesignColumns[13].Items.add(fdFieldComment);
  end;
end;

function TIni.ReturnValuesInList(const ASection: string; AStringList: TStringList): integer;
// loads all the values for a given section into the supplied StringList
begin
  result := -1;
  FIniFile.ReadSectionValues(trim(ASection), AStringList);
  result := 0;
end;

function TIni.WriteString(const ASection: string; const AName: string; const AValue: string): integer;
begin
  result := 0;
  if (AName = '') and (AValue = '') then begin
    FIniFile.WriteString(ASection, 'dummy', 'dummy');
    FIniFile.DeleteKey(ASection, 'dummy');
  end
  else
    FIniFile.WriteString(ASection, AName, AValue);
  if FIniSections.IndexOf(ASection) = -1 then
    ReadIniSections;
end;

function TIni.LoadRecordTypes: integer;
// Populates the FRecordTypes stringlist with all the "CU=Customer"-type settings.
begin
  result := 0;
  if not assigned(FRecordTypes) then
    FRecordTypes := TStringList.create;

  ReturnValuesInList(RECORD_TYPES, FRecordTypes);
end;

function TIni.ReturnDataInFieldDef(DataValue: string; var OutRecord: TFieldDef): integer;
// Mimics reading a record from a file of type TFieldDef, except that this way
// allows our incoming records to be variable length so FieldComment doesn't need to be padded out
// to the exact length of TFieldDef and we do the padding here.
// The whole "file" is stored in a standard INI file section.
var
  FieldDef: array[0..SizeOf(TFieldDef)] of char;
  NewDataValue: string;
begin
  result := -1;
try
  NewDataValue := CheckForOldFieldDef(DataValue);
  if NewDataValue <> '' then
    DataValue := NewDataValue;
  FillChar(FieldDef, SizeOf(FieldDef), #32);
  StrLCopy(FieldDef, pchar(DataValue), SizeOf(TFieldDef)); // The incoming INI line will be truncated if its too long
  if length(DataValue) <= SizeOf(TFieldDef) then
    FieldDef[length(DataValue)] := #32; // blank the null terminator of a short line
  Move(FieldDef, OutRecord, SizeOf(TFieldDef));
  result := 0;
except on e:exception do
  SetSysMsg('Error in ReturnDataInFieldDef: ' + e.message);
end;
end;

function TIni.ReturnFieldDefInString(const FieldDef: TFieldDef): string;
// Does the exact opposite of ReturnDataInFieldDef.
// Typically, a TFieldDef record will have been read from a file and passed to ReturnDataInFieldDef.
// Changes will have been applied to FFieldDef by changing the individual fields (fd properties).
// This function now returns the amended TFieldDef as a string.
// Both functions bypass any of TIni's internal data and can therefore be used independently of
// any other TIni processing that is in progress.
const
  Offset = SizeOf(FFieldDef.FieldDefType) + SizeOf(FFieldDef.FieldNo) + SizeOf(FFieldDef.equals)
           { SizeOf(FFieldDef.RecordType) + SizeOf(FFieldDef.dot)}+ 1;
var
  ValueName: string;
  NameValue: array[0..SizeOf(FFieldDef) - SizeOf(FFieldDef.FieldDefType) - SizeOf(FFieldDef.FieldNo) - SizeOf(FFieldDef.Equals)] of char;
begin
  ValueName := FieldDef.FieldDefType + FieldDef.FieldNo;
  FillChar(NameValue, SizeOf(NameValue), #32);
  StrLCopy(NameValue, @FieldDef.AsArray[Offset], SizeOf(NameValue) - 1);
  result := ValueName + '=' + NameValue;
end;

function TIni.ReturnValue(const ASection, AName: string): string;
// performs a standard ReadString on the ini file given the section and key name
// If the value contains a comment it will be stripped.
// For some reason this Returnxxxx function doesn't follow the convention of
// returning the result in one of the supplied parameters. Sorry 'bout that.
var
  PosSemiColon: integer;
begin
  result := FIniFile.ReadString(ASection, AName, '');
  PosSemiColon := pos(';', result);
  if PosSemiColon > 0 then begin
    FCurrentSectionValueComment := trim(copy(result, PosSemiColon + 1, (length(result) - PosSemiColon) + 1)); // set the comment property
    result := copy(result, 1, PosSemiColon - 1);
  end;
end;

{* getters and setters *}

function TIni.GetCurrentSectionValueName(index: integer): string;
// returns the specified name= in the 0-based list of name=value pairs.
begin
  result := FCurrentSectionValues.Names[index];
end;

function TIni.GetfdDelphiDef: string;
// If an INI section defines an Exchequer Record layout, each "record" in the section
// conforms to a TFieldDef type (defined at the top of this unit) and defines one field
// of an Exchequer record.
// This function will return the field definition as it would appear in a Delphi field definition:-
// For example, a field defined as name=Addr / occurs=5 / type=S / width = 30  would be returned as
// Addr: array[1..5] of string[30];
// It currently only caters for the eight data types used in ExchDLL.INC
var
  DelphiDef: string;
  occurs: string;
  width: string;
begin
try
  occurs := fdOccurs;
  if occurs <> '' then
    if occurs[1] = '0' then
      delete(occurs, 1, 1); // delete a leading zero if present
  if Occurs <> '' then
    DelphiDef := 'array[1..' + Occurs + '] of ';

  width := fdFieldWidth;
  while (length(width) > 0) and (width[1] = '0') do
    delete(width, 1, 1); // delete leading zeros if present

  case FFieldDef.FieldType of
    'S': DelphiDef := DelphiDef + 'string[' + width + ']'; // all Exchequer Record strings are short strings
    'C': if StrToInt(width) = 1 then
           DelphiDef := DelphiDef + 'char'
         else
           DelphiDef := DelphiDef + 'array[1..' + width + '] of char';
    'W': DelphiDef := DelphiDef + 'WordBool';
    'L': DelphiDef := DelphiDef + 'LongInt';
    'I': DelphiDef := DelphiDef + 'SmallInt';
    'B': if StrToInt(width) = 1 then
           DelphiDef := DelphiDef + 'byte'
         else
           DelphiDef := DelphiDef + 'array[1..' + width + '] of byte';
    'b': DelphiDef := DelphiDef + 'boolean';
    'D': DelphiDef := DelphiDef + 'Double';
  end;

  result := trim(fdFieldName) + ': ' + DelphiDef + ';';
except
  result := 'Invalid Def';
end;
end;

function TIni.GetfdReadOnly: boolean;
begin
  result := fdUsage = 'R';
end;

function TIni.GetfdNotUsed: boolean;
begin
  result := fdUsage = 'N';
end;

function TIni.GetRecordSize: integer;
// Calculates the size of the Exchequer record defined in the current ini section.
// this routine loads every record in turn, so we save the current record number
// and reload the current record at the end.
// This value is used in IniMaint.pas
var
  i: integer;
  RecordSize: integer;
  Occurs: integer;
  StoredCurrentRecordNo: integer;
begin
  StoredCurrentRecordNo := FCurrentRecordNo;
try

  RecordSize := 0;

  for i := 0 to CurrentSectionValuesCount - 1 do begin
    LoadRecord(i); // Sets FCurrentRecordNo in TIni !!!

//    if fdFieldNo = '000' then continue; // ignore our additions to the Exchequer record - *** possibly obsolete ***

    if fdOccurs <> '' then
      occurs := StrToInt(fdOccurs)
    else
      occurs := 1;

    RecordSize := RecordSize + (Occurs * StrToInt(fdFieldWidth));

    if fdFieldType = 'S' then
      RecordSize := RecordSize + Occurs; // add 1 length-byte for each string
  end;

  result := RecordSize;
except
  result := -1; // Probably caused by invalid characters in fdOccurs
end;
  LoadRecord(StoredCurrentRecordNo);
end;

function TIni.GetImportRecordSize: integer;
// Calculates the size of the Exchequer record defined in the current ini section.
// this routine loads every record in turn, so we save the current record number
// and reload the current record at the end.
// I have no idea what this section was supposed to do differently from GetRecordSize.
// The label in IniMaint.pas that this value gets displayed on is set to visible=false.
// 06/06/06: GetRecordSize calculates the size of an Exchequer record which should match
// its corresponding TBatchRec definition.
// GetImportRecordSize was intended to calculate the overall size of the same record as
// it would appear in a std import file. However, this is irrelevant as they're always
// 2048-bytes in length. So I'm not sure what I was thinking here.
var
  i: integer;
  RecordSize: integer;
  Occurs: integer;
  StoreCurrentRecordNo: integer;
begin
  StoreCurrentRecordNo := FCurrentRecordNo;
try

  RecordSize := 0;

  for i := 0 to CurrentSectionValuesCount - 1 do begin
    LoadRecord(i); // Sets FCurrentRecordNo !!! Which is why we've stored the current record no.

    if fdOccurs <> '' then
      occurs := StrToInt(fdOccurs)
    else
      occurs := 1;

    RecordSize := RecordSize + (Occurs * FieldWidth(fdFieldType[1], StrToInt(fdFieldWidth)));

  end;

  result := RecordSize;
except
  result := -1; // Probably caused by invalid characters in fdOccurs
end;
  LoadRecord(StoreCurrentRecordNo); // restore the current record no
end;

function TIni.GetCurrentSectionValuesCount: integer;
// returns the number of name=value pairs in the current section (set by LoadCurrentSectionValues)
begin
  result := FCurrentSectionValues.Count;
end;

function TIni.GetCurrentSectionValue(const AName: string): string;
// returns the =value part of a given name= pair. A prior call to LoadCurrentSectionValues will have
// set the current INI file section.
// If the value part contains a semi-colon, FCurrentSectionValueComment is populated with whatever follows it.
// The caller can therefore use the CurrentSectionValue property immediately followed by the CurrentSectionValueComment property.
var
  PosSemiColon: integer;
begin
  result := FCurrentSectionValues.Values[AName]; // determines the =value part
  if not FFieldDefs then begin // comments can only be present in standard ini file sections.
    PosSemiColon := pos(';', result); // anything following a ; is treated as a comment like the old Win3.1 INI files
    if PosSemiColon > 0 then begin
      FCurrentSectionValueComment := trim(copy(result, PosSemiColon + 1, (length(result) - PosSemiColon) + 1)); // set the comment property
      result := trim(copy(result, 1, PosSemiColon - 1)); // modifies =value if it contains a comment
    end;
  end;
end;

function TIni.GetSortRequired: boolean;
begin
  result := fdUsage[1] in ['1'..'9'];
end;

function TIni.GetfdOffset: string;
begin
  result := trim(FFieldDef.Offset);
end;

function TIni.GetfdDot: string;
begin
  result := FFieldDef.dot;
end;

function TIni.GetfdRecordType: string;
begin
  result := FFieldDef.RecordType;
end;

function TIni.GetfdEquals: string;
begin
  result := FFieldDef.equals;
end;

function TIni.GetfdCommentEquals: string;
begin
  result := trim(FFieldDef.CommentEquals);
end;

function TIni.GetfdUsage: string;
begin
  result := trim(FFieldDef.FieldUsage);
end;

function TIni.GetfdDefaultEquals: string;
begin
  result := trim(FFieldDef.DefaultEquals);
end;

function TIni.GetfdFieldComment: string;
begin
  result := trim(FFieldDef.FieldComment);
end;

function TIni.GetfdFieldDefault: string;
begin
  result := trim(FFieldDef.FieldDefault);
end;

function TIni.GetfdFieldDesc: string;
begin
  result := trim(FFieldDef.FieldDesc);
end;

function TIni.GetfdFieldType: string;
begin
  result := trim(FFieldDef.FieldType);
end;

function TIni.GetfdFieldWidth: string;
begin
  result := trim(FFieldDef.FieldWidth);
end;

function TIni.GetfdFieldDefType: string;
begin
  result := trim(FFieldDef.FieldDefType);
end;

function TIni.GetfdFieldNo: string;
begin
  result := trim(FFieldDef.FieldNo);
end;

function TIni.GetfdFieldName: string;
begin
  result := trim(FFieldDef.FieldName);
end;

function TIni.GetfdOccurs: string;
begin
  result := trim(FFieldDef.Occurs);
end;

procedure TIni.SetCurrentSectionValue(const AName: string; const Value: string);
// A prior call to LoadCurrentSectionValues will have set the current INI file section.
begin
  FCurrentSectionValues.Values[AName] := value; // change the name=value pair to name=new value
  LoadRecord(FCurrentSectionValues.IndexOfName(AName)); // Load the changes into TFieldDef
end;

procedure TIni.SetfdFieldDefType(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetfdFieldNo(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetIniFileName(const Value: string);
// not currently used in the Importer project
begin
  FIniFileName := Value;
end;

procedure TIni.SetfdFieldName(const Value: string);
// not currently used in the Importer project
begin
end;

procedure TIni.SetfdEquals(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetfdDot(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetfdRecordType(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetfdOffset(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetfdOccurs(const Value: string);
begin
  move(value[1], FFieldDef.Occurs[1], SizeOf(FFieldDef.Occurs)); // populate the CommentEquals field of the TFieldDef record
end;

procedure TIni.SetfdCommentEquals(const Value: string);
begin
  move(value[1], FFieldDef.CommentEquals[1], SizeOf(FFieldDef.CommentEquals)); // populate the CommentEquals field of the TFieldDef record
  WriteFieldDef(FCurrentRecordNo, false); // Only write the changes in-memory, not to disk
end;

procedure TIni.SetfdCritera(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetfdDefaultEquals(const Value: string);
begin
  move(value[1], FFieldDef.DefaultEquals[1], SizeOf(FFieldDef.DefaultEquals)); // populate the DefaultEquals field of the TFieldDef record
  WriteFieldDef(FCurrentRecordNo, false); // Only write the changes in-memory, not to disk
end;

procedure TIni.SetfdFieldComment(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetfdFieldDefault(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetfdFieldDesc(const Value: string);
var
  NewValue: string;
begin
  NewValue := Value;
  if length(NewValue) > SizeOf(FFieldDef.FieldDesc) then
    NewValue := copy(NewValue, 1, SizeOf(FFieldDef.FieldDesc));
  FillChar(FFieldDef.FieldDesc, SizeOf(FFieldDef.FieldDesc), #32);
  move(NewValue[1], FFieldDef.FieldDesc[1], length(NewValue));
  WriteFieldDef(FCurrentRecordNo, false); // Only write the changes in-memory, not to disk
end;

procedure TIni.SetfdFieldType(const Value: string);
// not currently used in the Importer project
begin

end;

procedure TIni.SetfdFieldWidth(const Value: string);
// not currently used in the Importer project
begin

end;

function TIni.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TIni.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TIni.SetSysMsg(const Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

function TIni.GetCurrentSectionRecord(ARecordNo: integer): string;
begin
  result := FCurrentSectionValues[ARecordNo];
end;

function TIni.GetSectionExists(const ASection: string): boolean;
begin
  result := FIniFile.SectionExists(ASection);
end;

function TIni.GetValueNameExists(const ASection: string; AValueName: string): boolean;
begin
  result := FIniFile.ValueExists(ASection, AValueName);
end;

function TIni.GetVersion: string;
begin
  result := FIniFile.ReadString('Version', 'Version', '');
end;

procedure TIni.SetfdFieldSys(const Value: string);
begin
// not currently used in the Importer project
end;

function TIni.GetfdFieldSys: string;
begin
  result := trim(FFieldDef.FieldSys);
end;
//PR: 11/11/2009 Added to allow install to update settings file
constructor TIni.CreateWithPath(const sPath: string);
begin
  inherited Create;

  SetIniFileName(sPath + IMPORTER_INIFILE);
  CreateIniFile;   // create the internal TIniFile object that TIni operates on
  ReadIniSections; // Read all the section names into a TStringList
  LoadRecordTypes; // get all the valid two-character record types.
end;

//PR: 16/02/2018 ABSEXCH-19822 Retry the write of the ini file
procedure TIni.WriteFileWithRetry(const AStream: TMemoryStream;
  const Filename: string);
const
  RETRY_COUNT = 5;
var
  Tries : integer;
  Success : Boolean;
begin
  Success := False;
  Tries := 0;
  while not Success and (Tries <= RETRY_COUNT) do
  begin
    Try
      AStream.SaveToFile(Filename);
      Success := True;
    Except
      Success := False;
      inc(Tries);
      Sleep(5);
    End;
  end;

  //Try save again to get the exception raised
  if not Success then
    AStream.SaveToFile(Filename);

end;

initialization
  IniFile := TIni.create;

finalization
  FreeObjects([IniFile]);

end.