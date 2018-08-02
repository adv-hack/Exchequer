unit TMapsClass;

{******************************************************************************}
{   The TMaps object provides various helper functions for manipulating        }
{   .map files.                                                                }
{   Map files contain the Field Definitions for a particular format of         }
{   import file.                                                               }
{                                                                              }
{   TMaps knows nothing about Exchequer. Future amendments should ensure that  }
{   this remains the case.                                                     }
{******************************************************************************}

interface

uses TIniClass, classes, GlobalTypes, TImportToolkitClass;

type

  TMap = record
    RecordType:   string;
    FieldDefs:    TArrayOfFieldDefs;
  end;

  TArrayOfMaps = array of TMap;

  TMaps = class(TObject)
  private
{* internal fields *}
    FMaps: TArrayOfMaps;
    MapIx: integer; // index into the first dimension of the FMaps array
    DefIx: integer; // index into the second dimension of the FMaps array
{* property fields *}
    FAutoIncIx:      integer;
    FCurrIncIx:       integer;
    FErrorMessage:   string;
    FImportFileType: TImportFileType;
    FMapFiles:       TStringList;
    FRecordTypes:    TStringList;
    FStdOffset:      integer;
    FStdWidth:       integer;
{* procedural methods *}
    function  CalcStdOffset: integer;
    function  ModifyOffsets: integer;
    function  RepeatField(i: integer; DefIx: integer): integer;
    function  ReturnATypeFieldDefs(const ARecordType: string; AFieldDefs: TStringList): integer;
    function  ReturnFTypeFieldDefs(const ARecordType: string; AFieldDefs: TStringList): integer;
    function  ReturnSTypeFieldDefs(const ARecordType: string; AFieldDefs: TStringList): integer;
    function  DumpMaps: integer;
{* getters and setters *}
    function  GetFieldDef: TFieldDef;
    procedure SetErrorMessage(const Value: string);
    procedure SetImportFileType(const Value: TImportFileType);
    function  GetEndOfFieldDefs: boolean;
    function  GetSortRequired: boolean;
    function  GetValidFieldDef: boolean;
    function  GetValidMap: boolean;
    function  GetAutoInc: boolean;
    function  GetCurrInc: boolean;
    function  GetIgnoreField: boolean;
    function  GetAutoIncIx: integer;
    function  GetCurrIncIx: integer;
    function  GetMap: TMap;
    function  GetAutoGen: boolean;
    function  GetFixed: boolean;
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(const Value: string);
    function  GetInclude: boolean;
    function  GetReadOnlyOrNotUsed: boolean;
  public
    constructor create;
    destructor destroy; override;
    function  CreateMaps: integer;
    function  FindMap(RecordType: string): integer;
    function  FirstFieldDef: integer;
    function  NextFieldDef: integer;
    property  AutoGen: boolean read GetAutoGen;
    property  AutoInc: boolean read GetAutoInc;
    property  AutoIncIx: integer read GetAutoIncIx;
    property  CurrInc: boolean read GetCurrInc;
    property  CurrIncIx: integer read GetCurrIncIx;
    property  EndOfFieldDefs: boolean read GetEndOfFieldDefs;
    property  ErrorMessage: string read FErrorMessage write SetErrorMessage;
    property  FieldDef: TFieldDef read GetFieldDef; // returns the current Field Def as defined by the values of MapIx and DefIx
    property  Fixed: boolean read GetFixed;
    property  IgnoreField: boolean read GetIgnoreField;
    property  ImportFileType: TImportFileType read FImportFileType write SetImportFileType; // set by TBuildImportJobs before calling CreateMaps
    property  IncludeField: boolean read GetInclude;
    property  Map: TMap read GetMap;
    property  MapFiles: TStringList read FMapFiles; // set by TBuildImportJobs before calling CreateMaps
    property  ReadOnlyOrNotUsed: boolean read GetReadOnlyOrNotUsed;
    property  RecordTypes: TStringList read FRecordTypes write FRecordTypes; // set by TBuildImportJobs before calling CreateMaps
    property  SortRequired: boolean read GetSortRequired;
    property  StdOffset: integer read FStdOffset;
    property  StdWidth: integer read FStdWidth;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
    property  ValidFieldDef: boolean read GetValidFieldDef;
    property  ValidMap: boolean read GetValidMap;
  end;

implementation

uses SysUtils, IniFiles, utils, GlobalConsts, TErrors;

{ TMapFile }

constructor TMaps.create;
begin
  inherited;

  FRecordTypes := TStringList.create;
  FMapFiles    := TStringList.create;
end;

destructor TMaps.destroy;
begin
  FreeObjects([FRecordTypes, FMapFiles]);

  inherited;
end;

{* Procedural Methods *}

function TMaps.CalcStdOffset: integer;
// For a StdImport file, the entire meta-data definition of the target
// Exchequer record is used as the map.
// As the Field Defs of the map are cycled through, CalcStdOffset keeps track
// of where each corresponding field would start on a Std Import file.
// {For Std Import files, the map will only contain S-Type and F-Type Field Defs.
// None of the F-Type fields will be F000 (ignored field).}
// This is necessary because, e.g. Address [*] array entries will have been
// exploded into Address [1], Address [2] etc, but because they have been copied
// from the original they will have the overall offset of the array which is
// now wrong. If that's as clear as mud, run Importer and look at an Address [*] entry in the
// settings file and compare it to what gets written to the map file when you
// select all five address lines in MapMaint - the offsets for each field will be wrong.
// 12/2005: Actually, there are now correct. They get corrected when MapMaint loads the Exchequer
// record definition in MapMaint.LoadFieldDefs. They need to be correct when saved to the map file
// in case the user selects only the middle element of an array.Once you've lost access to the
// original array definition [*] in the main settings file you don't know at what offset the
// array starts. MapMaint removes the "occurs" so that no code will try to readjust already
// adjusted offsets.
begin
  result := -1;
try
  if DefIx > high(FMaps[MapIx].FieldDefs) then exit;

  FStdOffset := FStdOffset + FStdWidth; // plus the width of the previous field gives us the offset of this one.
                                        // For the first field def, FStdOffset := 0 + 0, which is correct.

{* calculate the width of this field so it can be used in the preceding line next time this function is called *}
  FStdWidth  := FieldWidth(FMaps[MapIx].FieldDefs[DefIx].FieldType,
                                        StrToInt(FMaps[MapIx].FieldDefs[DefIx].FieldWidth));
  result := 0;
except on e:exception do
  SetSysMsg('Error in CalcStdOffset: ' + e.message);
end;
end;

function TMaps.ReturnSTypeFieldDefs(const ARecordType: string; AFieldDefs: TStringList): integer;
// Called from CreateMaps.
// Fetches the Sxxx Field Defs from the main settings file. These are defined in [xx] sections
// where xx is the Record Type, e.g. [CU]. These fields are defined at [S]ystem level and cannot
// be overridden by the user. Hence, they never appear in a user's map file.
var
  tmpFieldDefs: TStringList;
begin
  result := -1;
try
  tmpFieldDefs := TStringList.create;
  try
    if IniFile.ReturnValuesInList(ARecordType, tmpFieldDefs) <> 0 then exit; // Fetch S-Types from main settings file
    AFieldDefs.AddStrings(tmpFieldDefs);
  finally
    tmpFieldDefs.free;
  end;
  result := 0;
except on e:exception do
  SetSysMsg('Error in ReturnSType: ' + e.message);
end;
end;

function TMaps.ReturnATypeFieldDefs(const ARecordType: string; AFieldDefs: TStringList): integer;
// Called from CreateMaps.
// Pick up any A-Type Field Defs from the Map file for this record type.
// otherwise pick them up from the main settings file.
var
  AutoGenSection: string;
  MapFile: TMemIniFile;
  MapFileName: string;
  tmpFieldDefs: TStringList;
  MS: TMemoryStream;
begin
  result := -1;
try
  tmpFieldDefs := TStringList.create;
  try
    MapFileName := FMapFiles.Values[ARecordType]; // get the file name of the Map file for this record type
    if (MapFileName = '') or not FileExists(MapFileName) then begin
      SetSysMsg(format('No Field Map for record type "%s"', [ARecordType]));
      exit;
    end;
    IniFile.DecryptIniFile(MapFileName, false);
    MapFile := TMemIniFile.Create(MapFileName);
    if not PlainOut then
      IniFile.EncryptIniFile(MapFileName);
    try
      AutoGenSection := 'Auto' + ARecordType; // get name of autogen section for this rec type
      if MapFile.SectionExists(AutoGenSection) then begin
        MS := IniFile.DecryptIniFile(MapFileName, true);
        if MS = nil then begin
          SetSysMsg('Nil Stream in ReturnAType');
          exit;
        end;
        tmpFieldDefs.LoadFromStream(MS); MS.Free;
        if IsolateIniSection(tmpFieldDefs, AutoGenSection) <> 0 then exit;
        AFieldDefs.AddStrings(tmpFieldDefs); // tack onto the end of what we've got so far
      end;
    finally
      MapFile.free;
    end;

    if tmpFieldDefs.Count = 0 then begin // if there were no A-Type field defs in the map file...(try main settings file)...
      AutoGenSection := 'Auto' + ARecordType; // get name of autogen section for this rec type
      if IniFile.SectionExists[AutoGenSection] then begin
        if IniFile.ReturnValuesInList(AutoGenSection, tmpFieldDefs) <> 0 then exit; // get all field defs from this section
        AFieldDefs.AddStrings(tmpFieldDefs); // tack onto the end of what we've got so far
      end;
    end;
  finally
    tmpFieldDefs.free;
  end;
  result := 0;
except on e:exception do
  SetSysMsg('Error in ReturnAType: ' + e.message);
end;
end;

function TMaps.ReturnFTypeFieldDefs(const ARecordType: string; AFieldDefs: TStringList): integer;
// Called from CreateMaps.
// Pick up the F-Type Field Defs from the Map file for this record type.
// otherwise get them from the main settings file.
// For StdImportFiles we ignore any map files and get the full Exchequer rec
// definition from the main settings file.
// 15/12/2005: The user can now create a map file for a StdImport file so that
// they can set up default values.
// 16/12/2005: Good idea, but StdImport files aren't used much so the accompanying
// functionality in MapMaint is hidden from the user.
var
  FieldDefSection: string;
  MapFileName: string;
  MapFieldDefs: TStringList; // Field Defs picked up from the map file
  DefFieldDefs: TStringList; // Field Defs picked up from the main settings file
  MS: TMemoryStream;
begin
  result := -1;
try
  MapFieldDefs := TStringList.create;
  DefFieldDefs := TStringList.create;
  try
    MapFileName := FMapFiles.Values[ARecordType]; // get the file name of the Map file for this record type
    if (MapFileName = '') or not FileExists(MapFileName) then begin              // not specified by the user
      if FImportFileType = ftUserDef then begin   // that's only ok for a StdImport file
        SetSysMsg(format('No Field Map for record type "%s"', [ARecordType]));
        exit;
      end
    end
    else begin
      MS := IniFile.DecryptIniFile(MapFileName, true);
      if MS = nil then begin
        SetSysMsg('Nil Stream in ReturnFType');
        exit;
      end;
      MapFieldDefs.LoadFromStream(MS); MS.Free;
      if IsolateIniSection(MapFieldDefs, ARecordType) <> 0 then begin // any lines in this section ?
        SetSysMsg(format('Field Map file %s does not contain a Field Map for record type "%s"', [MapFileName, ARecordType]));
        exit;
      end;
      AFieldDefs.AddStrings(MapFieldDefs);                            // tack onto the end of what we've got so far
    end;

    if MapFieldDefs.Count = 0 then begin // if there were no F-Type field defs in the map file...(try main settings file)...
      FieldDefSection := IniFile.ReturnValue(RECORD_TYPES, ARecordType); // get name of FieldDef section for this rec type
      if FieldDefSection <> '' then begin
        if IniFile.ReturnValuesInList(FieldDefSection, DefFieldDefs) <> 0 then exit;// get all field defs from this section
        AFieldDefs.AddStrings(DefFieldDefs);                              // tack onto the end of what we've got so far
      end;
    end;
  finally
    MapFieldDefs.free;
    DefFieldDefs.free;
  end;
  result := 0;
except on e:exception do
  SetSysMsg('Error in ReturnFType: ' + e.message);
end;
end;

function TMaps.RepeatField(i: integer; DefIx: integer): integer;
// This function is really a sub-function of CreateMaps but moving it to
// a separate function has made it easier to read both.
// CreateMaps is reading through the FieldDefs stringlist and populating the
// two dimensions of the FMaps array of TFieldDef.
// The index into the first dimension is i which is CreateMaps "for" counter.
// DefIx is the index into the second dimension of the array.
// The most recent entry into the array contains a repeat field, e.g. "Address
// Line [*]" and the "occurs" field specifies how many times the field is repeated.
// RepeatField extends the length of the array by the required number of repeats,
// and copies the FieldDef into the new array elements.
// "Address Line [*]" is replaced by "Address Line [1]", "Address Line [2]" etc
// on each occurrence.
// The new value of DefIx which represents high(FMaps[i].FieldDefs) is returned
// to CreateMaps which continues its loop with the next FieldDef.
var
  occurs:  integer;
  FieldName: string;
  NewFieldName: string;
  PosLBracket: integer;
  k: integer;
begin
  result := -1;
try
  FieldName := trim(FMaps[i].FieldDefs[DefIx].FieldDesc);                   // get the Field Desc (friendly name)
  PosLBracket := pos('[', FieldName);
  delete(FieldName, PosLBracket, (length(FieldName) - PosLBracket) + 1);    // remove from [ to the end
  NewFieldName := FieldName + '[1]';                                        // New field name = e.g. Address Line [1]

  FillChar(FMaps[i].FieldDefs[DefIx].FieldDesc, SizeOf(FMaps[i].FieldDefs[DefIx].FieldDesc), #32); // blank the original
  Move(NewFieldName[1], FMaps[i].FieldDefs[DefIx].FieldDesc, length(NewFieldName)); // change the field name

  occurs := StrToInt(trim(FMaps[i].FieldDefs[DefIx].Occurs));               // how many repeats ?
  SetLength(FMaps[i].FieldDefs, length(FMaps[i].FieldDefs) + (occurs - 1)); // need more elements then
  FillChar(FMaps[i].FieldDefs[DefIx].Occurs, SizeOf(FMaps[i].FieldDefs[DefIx].Occurs), #32); // blank the original occurs

  for k := 1 to occurs - 1 do begin // repeat the preceeding field def for the other occurrences
    FMaps[i].FieldDefs[DefIx + k] := FMaps[i].FieldDefs[DefIx];             // copy the original to the new
    NewFieldName := FieldName + '[' + IntToStr(k + 1) + ']';                // generate a new field name
    FillChar(FMaps[i].FieldDefs[DefIx + k].FieldDesc, SizeOf(FMaps[i].FieldDefs[DefIx].FieldDesc), #32); // blank the original name
    Move(NewFieldName[1], FMaps[i].FieldDefs[DefIx + k].FieldDesc, length(NewFieldName)); // replace [*] etc with [2] to [n]
  end;
  result := DefIx + (occurs - 1);   // return the new value of DefIx
except on e:exception do
  SetSysMsg('Error in RepeatField: ' + e.message);
end;
end;

function TMaps.CreateMaps: integer;
// Creates a Field Def Map for each of the record types in the RecordTypes property.
// There are three types of field defs - each picked up from different areas
// S-Type: These are System-defined fields which must appear at the start of each record, e.g. Record Type.
//         They are defined in the [xx] section of the main settings file, where xx is the Record Type.
// A-Type: Auto-gen types. These are fields of a different record type (to the F-Fields) in the import file
//         which appear after the S-Types and before the F-Types.
//         These can be found in the main settings file by reading the
//         "[Autoxx]" section where xx is the Record Type. If this value is found in the MAP file
//         add the contents to the FieldDefs and ignore the main settings file.
// F-Type: Fields present in the import file. For std import files, these will be the whole Exchequer record definition
//         in the main settings file. For user-defined files (e.g. CSV) the map file will contain only those fields
//         which the user has stated will be present.

// This function builds what is essentially a two-dimensional array with the first dimension denoting the record type
// and the second dimension containing the FieldDefs for the record type.
var
  FieldDefs: TStringList;
  i, j: integer;
  DefIx: integer;
begin
  result := -1;
try
  FieldDefs := TStringList.create;
  SetLength(FMaps, 0); // clear out any previous contents
  SetLength(FMaps, RecordTypes.count);
  try
    for i := 0 to RecordTypes.Count - 1 do begin             // cycle thru the 2-char record types.
      if ReturnSTypeFieldDefs(RecordTypes[i], FieldDefs) <> 0 then exit;
      if ImportFileType = ftUserDef then                     // AutoGen fields don't appear in stdImport files
        if ReturnATypeFieldDefs(RecordTypes[i], FieldDefs) <> 0 then exit;
      if ReturnFTypeFieldDefs(RecordTypes[i], FieldDefs) <> 0 then exit;
      for j := FieldDefs.Count - 1 downto 0 do    // remove any blank lines
        if trim(FieldDefs[j]) = '' then
          FieldDefs.Delete(j);
      SwapFields(FieldDefs); // v.075 replace any obsolete field defs with their new replacement // v.076
      if DebugIt then FieldDefs.SaveToFile(GetExePath + 'MapFiles\zDef' + RecordTypes[i] + '.txt');

      FMaps[i].RecordType   := RecordTypes[i];                               // setup the FMaps array 1st dimension
      if length(FMaps[i].FieldDefs) < FieldDefs.Count then
        SetLength(FMaps[i].FieldDefs, FieldDefs.count);                     // resize if shorter than reqd
      DefIx := -1;
      for j := 0 to FieldDefs.Count - 1 do begin                           // setup the FMaps array 2nd dimension
        inc(DefIx);
        if IniFile.ReturnDataInFieldDef(FieldDefs[j], FMaps[i].FieldDefs[DefIx]) <> 0 then exit; // populate the field def
        if trim(FMaps[i].FieldDefs[DefIx].Occurs) <> '' then begin             // is there an occurrence number ?
          DefIx := RepeatField(i, DefIx);                                // repeat the field def for each occurrence
          if SysMsgSet then exit; // an error occurred in RepeatField
        end;
      end;
      FieldDefs.Clear;
    end;
    if ImportFileType <> ftUserDef then // 2006/02/02 - the .map file offsets are already corrected in MapMaint
      if ModifyOffsets <> 0 then exit; // check for repeating groups, e.g. Address Line[2] and correct the offset
  finally
    FieldDefs.Free;
  end;
  result := 0;
  if DebugIt then DumpMaps;
except on e:exception do
  SetSysMsg('Error in CreateMaps: ' + e.message);
end;
end;

function TMaps.DumpMaps: integer; // for ***TEST*** purposes only
// dumps the generated maps to text files
var
  rec: array[0..SizeOf(TFieldDef)] of char;
  i, j: integer;
  tmpStringList: TStringList;
begin
  result := -1;
try
  tmpStringList := TStringList.Create;
  try
    for i := low(FMaps) to high(FMaps) do begin
      for j := low(FMaps[i].FieldDefs) to high(FMaps[i].FieldDefs) do begin
        move(FMaps[i].FieldDefs[j].FieldDefType, rec, SizeOf(TFieldDef));
        rec[SizeOf(TFieldDef)] := #0;
        tmpStringList.Add(rec);
      end;
      tmpStringList.SaveToFile(GetExePath + 'MapFiles\zMap' + FMaps[i].RecordType + '.txt');
      tmpStringList.clear;
    end;
  finally
    tmpStringList.free;
  end;

  result := 0;
except on e:exception do
  SetSysMsg('Error in DumpMaps: ' + e.message);
end;
end;

function TMaps.FindMap(RecordType: string): integer;
// set the MapIx for the given Record Type
var
  i: integer;
begin
  result := -1; // stays as is if Record Type not found
  for i := low(FMaps) to high(FMaps) do
    if FMaps[i].RecordType = RecordType then begin
      MapIx := i;
      result := 0;
      break;
    end;
end;

function TMaps.NextFieldDef: integer;
begin
  result := -1;

  inc(DefIx);
  if FImportFileType = ftStdImport then begin
    while ReadOnlyOrNotUsed do
      inc(DefIx);
    if CalcStdOffset <> 0 then exit; // calculates where this field should be on a Std Import File record
  end;

  result := 0;
end;

function TMaps.FirstFieldDef: integer;
begin
  result     := -1;

  DefIx      := 0;
  FStdOffset := 0;
  FStdWidth  := 0;

  if FImportFileType = ftStdImport then begin  // ignore any ReadOnly or NotUsed
    while ReadOnlyOrNotUsed do
      inc(DefIx);
    if CalcStdOffset <> 0 then exit; // calculates where this field should be on a Std Import File record
  end;

  result := 0;
end;


function TMaps.ModifyOffsets: integer;
// A field's offset is its byte-position in the target Exchequer record.
// This function recalculates the offset in the field def according to whether
// the field is part of a repeating group.
// E.g. Address lines might be defined as 5 occurrences of "Address Line [*]" and expanded
// when displayed to the user for selection as "Address Line [1]", "Address Line [2]" etc.
// If the user specifies that these first two are in the file being imported then
// they will appear in the map as "Address Line [1]", "Address Line [2]".
// However, the offset field in the map will be the same for both of them
// since they were both generated from the same meta-data record.
// Obviously, the offset needs to be modified for occurrence 2 onwards.
// This procedure is called once at the end of CreateMaps.
var
  i, j: integer;
  PosLBracket: integer;
  PosRBracket: integer;
  offset: string;
  NewOffset: integer;
  NewOffsetStr: string;
  Occurrence:  integer;

        function ModifiedOffset: integer;
        // The occurrence is located in square brackets in the FieldDesc.
        // NewOffset := CurOffset + ([occurrence - 1] * utils.StorageSize(FieldType, FieldWidth))
        begin
        try
          result := StrToInt(FMaps[i].FieldDefs[j].Offset); // return the offset in the field def
          if pos('[', FMaps[i].FieldDefs[j].FieldDesc) = 0 then exit; // quick get out for the majority of calls

          PosLBracket := pos('[', FMaps[i].FieldDefs[j].FieldDesc);
          PosRBracket := pos(']', FMaps[i].FieldDefs[j].FieldDesc);
          Occurrence  := StrToInt(copy(FMaps[i].FieldDefs[j].FieldDesc,
                                       PosLBracket + 1,
                                       PosRBracket - PosLBracket - 1)); // find n in [n]

          result := result + ((occurrence - 1)
                           * StorageSize(FMaps[i].FieldDefs[j].FieldType,
                                  StrToInt(FMaps[i].FieldDefs[j].FieldWidth)));
        except on e:exception do begin
          SetSysMsg('Error in ModifiedOffset: ' + e.Message);
          result := -1;
        end; end;
        end;
begin
  result := -1;
try
  for i := low(FMaps) to high(FMaps) do
    for j := low(FMaps[i].FieldDefs) to high(FMaps[i].FieldDefs) do begin
      offset := trim(FMaps[i].FieldDefs[j].Offset);
      if Offset <> '' then begin                    // some fields like F000 don't have anything in the offset
        NewOffSet := ModifiedOffset;
        if SysMsgSet then exit;
        NewOffSetStr := format('%.4d', [NewOffset]);
        move(NewOffsetStr[1], FMaps[i].FieldDefs[j].Offset, 4);
      end;
    end;
  result := 0;
except on e:exception do
  SetSysMsg('Error in ModifyOffsets: ' + e.message);
end;
end;

{* getters and setters *}

function TMaps.GetFieldDef: TFieldDef;
// returns the Field Def defined by the current values of MapIx and DefIx
begin
  result := FMaps[MapIx].FieldDefs[DefIx];
end;

procedure TMaps.SetErrorMessage(const Value: string);
begin
  FErrorMessage := Value;
end;

procedure TMaps.SetImportFileType(const Value: TImportFileType);
begin
  FImportFileType := Value;
end;

function TMaps.GetEndOfFieldDefs: boolean;
// is DefIx now greater than the highest FieldDef in the current map ?
begin
  result := (DefIx > high(FMaps[MapIx].FieldDefs));
end;

function TMaps.GetSortRequired: boolean;
// if a sort is required, built Exchequer records are written to a temporary BTrieve file
// and then read back in in key sequence before being written to Exchequer via the DLL Toolkit.
var
  i, j: integer;
begin
  result := false;
  for i := low(FMaps) to high(FMaps) do
    for j := low(FMaps[i].FieldDefs) to high(FMaps[i].FieldDefs) do
      if FMaps[i].FieldDefs[j].FieldUsage in ['1'..'9'] then begin // any such FieldDef means a sort is required.
        result := true;
        break;
      end;
end;

function TMaps.GetValidFieldDef: boolean;
// does the current Field Def conform to the TFieldDef record layout ?
begin
  result := IniFile.ValidFieldDef(FieldDef);
end;

function TMaps.GetValidMap: boolean;
// did previous call to FindMap find a matching Record Type ?
begin
  result := MapIx <> -1;
end;

function TMaps.GetAutoInc: boolean;
// determines whether the current field doesn't appear in the import file
// and should have a unique value generated for it.
var
  i: integer;
  Default: string;
begin
  result := false;
  if pos('[A', trim(FMaps[MapIx].FieldDefs[DefIx].FieldDefault)) = 0 then exit;

  Default := trim(FMaps[MapIx].FieldDefs[DefIx].FieldDefault);
  for i := 0 to 9 do begin
    result := Default = format('[AutoInc%d]', [i]);
    if result then begin
      FAutoIncIx := i; // side effect of this function is set which AutoInc counter the default value of this field specifies
      break;
    end;
  end;
end;

function TMaps.GetCurrInc: boolean;
// determines whether the current field doesn't appear in the import file
// and should use the current AutoInc value as its value
var
  i: integer;
  Default: string;
begin
  result := false;
  if pos('[C', trim(FMaps[MapIx].FieldDefs[DefIx].FieldDefault)) = 0 then exit;

  Default := trim(FMaps[MapIx].FieldDefs[DefIx].FieldDefault);
  for i := 0 to 9 do begin
    result := Default = format('[CurrInc%d]', [i]);
    if result then begin
      FCurrIncIx := i;  // side effect of this function is set which AutoInc counter the default value of this field specifies
      break;
    end;
  end;
end;

function TMaps.GetIgnoreField: boolean;
// If the map contains an F000 field def, the corresponding value in the user-
// defined file will be ignored
begin
  result := FMaps[Mapix].FieldDefs[DefIx].FieldNo = '000';
end;

function TMaps.GetAutoIncIx: integer;
// if default=[AutoIncx], where x is 0 to 9, then FAutoIncIx is x
begin
  result := FAutoIncIx;
end;

function TMaps.GetCurrIncIx: integer;
// if default=[CurrIncx], where x is 0 to 9, then FCurrIncIx is x
begin
  result := FCurrIncIx;
end;

function TMaps.GetMap: TMap;
begin
  result := FMaps[MapIx];
end;

function TMaps.GetAutoGen: boolean;
begin
  result := FMaps[MapIx].FieldDefs[DefIx].FieldDefType = 'A';
end;

function TMaps.GetFixed: boolean;
begin
  result := (FMaps[MapIx].FieldDefs[DefIx].FieldUsage = 'F')
            or (
               (FMaps[MapIx].FieldDefs[DefIx].FieldUsage in ['0'..'9', 'A'..'C'])     // its a sort field...
               and (trim(FMaps[MapIx].FieldDefs[DefIx].FieldDefault) <> '') // ...with a default value in the main settings file
               );
end;

function TMaps.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TMaps.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TMaps.SetSysMsg(const Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

function TMaps.GetInclude: boolean;
begin
  result := pos('[I]', trim(FMaps[MapIx].FieldDefs[DefIx].FieldDefault)) = 1;
end;

function TMaps.GetReadOnlyOrNotUsed: boolean;
// ReadOnly, NotUsed, {AutoInc and CurrInc} fields do not appear in Std Import Files
// Any such Field Defs will be ignored when reading these files.
begin
  result := false;
  if EndOfFieldDefs then exit;
  
  result := (FMaps[MapIx].FieldDefs[DefIx].FieldUsage = 'R')
         or (FMaps[MapIx].FieldDefs[DefIx].FieldUsage = 'N');
//         or AutoInc or CurrInc;
end;

end.
