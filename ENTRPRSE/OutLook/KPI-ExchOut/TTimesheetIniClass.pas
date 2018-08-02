unit TTimesheetIniClass;

interface

uses
  TBigIniClass, SysUtils;

type
  TTimesheetIni = class(TObject)
  private
    FCompanyDataPath: string;
    FEmpCode: string;
    FIniFile: TBigIniFile;
    FILockedTheSettingsFile: boolean;

    function  SettingsFileName: string;
    function  SettingsSection: string;
    function  GetSettingsValue(ValueName: string; Default: string = ''): string;
    procedure PutSettingsValue(ValueName: string; ValueData: string);

// property getters and setters
    function GetShowTHUDF1: boolean;
    function GetShowTHUDF2: boolean;
    function GetShowTHUDF3: boolean;
    function GetShowTHUDF4: boolean;
    function GetShowTLUDF1: boolean;
    function GetShowTLUDF2: boolean;
    procedure SetShowTHUDF1(const Value: boolean);
    procedure SetShowTHUDF2(const Value: boolean);
    procedure SetShowTHUDF3(const Value: boolean);
    procedure SetShowTHUDF4(const Value: boolean);
    procedure SetShowTLUDF1(const Value: boolean);
    procedure SetShowTLUDF2(const Value: boolean);

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    function GetShowTHUDF5: boolean;
    function GetShowTHUDF6: boolean;
    function GetShowTHUDF7: boolean;
    function GetShowTHUDF8: boolean;
    function GetShowTHUDF9: boolean;
    function GetShowTHUDF10: boolean;
    function GetShowTLUDF5: boolean;
    function GetShowTLUDF6: boolean;
    function GetShowTLUDF7: boolean;
    function GetShowTLUDF8: boolean;
    function GetShowTLUDF9: boolean;
    function GetShowTLUDF10: boolean;
    procedure SetShowTHUDF5(const Value: boolean);
    procedure SetShowTHUDF6(const Value: boolean);
    procedure SetShowTHUDF7(const Value: boolean);
    procedure SetShowTHUDF8(const Value: boolean);
    procedure SetShowTHUDF9(const Value: boolean);
    procedure SetShowTHUDF10(const Value: boolean);
    procedure SetShowTLUDF5(const Value: boolean);
    procedure SetShowTLUDF6(const Value: boolean);
    procedure SetShowTLUDF7(const Value: boolean);
    procedure SetShowTLUDF8(const Value: boolean);
    procedure SetShowTLUDF9(const Value: boolean);
    procedure SetShowTLUDF10(const Value: boolean);

    function GetShowChargeOutRate: boolean;
    procedure SetShowChargeOutRate(const Value: boolean);
    function GetAutoGenNoteStatus: string;
    function GetAutoGenNoteText: string;
    function GetDefaultAnalysisCode: string;
    function GetDefaultCostCentre: string;
    function GetDefaultCurrency: integer;
    function GetDefaultDepartment: string;
    function GetDefaultRateCode: string;
    function GetDefaultTimesheetStatus: string;
    function GetShowAnalysisCode: boolean;
    function GetShowCostCentre: boolean;
    function GetShowCostPerHour: boolean;
    function GetShowDepartment: boolean;
    function GetShowRateCode: boolean;
    procedure SetAutoGenNoteStatus(const Value: string);
    procedure SetAutoGenNoteText(const Value: string);
    procedure SetDefaultAnalysisCode(const Value: string);
    procedure SetDefaultCostCentre(const Value: string);
    procedure SetDefaultCurrency(const Value: integer);
    procedure SetDefaultDepartment(const Value: string);
    procedure SetDefaultRateCode(const Value: string);
    procedure SetDefaultTimesheetStatus(const Value: string);
    procedure SetShowAnalysisCode(const Value: boolean);
    procedure SetShowCostCentre(const Value: boolean);
    procedure SetShowCostPerHour(const Value: boolean);
    procedure SetShowDepartment(const Value: boolean);
    procedure SetShowRateCode(const Value: boolean);
    function YesOrNo(ABoolean: boolean): string;
    function GetIsAdministrator(AUserName: string): boolean;
    procedure SetIsAdministrator(AUserName: string; const Value: boolean);
    function GetAssociatedUserID(AUserName: string): string;
    procedure SetAssociatedUserID(AUserName: string; const Value: string);
    function GetDefaultsSet(AnEmpCode: string): boolean;
    function GetShowTotalCharge: boolean;
    function GetShowTotalHours: boolean;
    procedure SetShowTotalCharge(const Value: boolean);
    procedure SetShowTotalHours(const Value: boolean);
    function GetLocked: boolean;
    function PlainOut: boolean;
    function GetDefaultJobCode: string;
    procedure SetDefaultJobCode(const Value: string);
    function GetShowTotalCost: boolean;
    procedure SetShowTotalCost(const Value: boolean);
  public
    constructor Create(ADataPath: string);
    Destructor Destroy; override;
    function  LockSettingsFile: boolean;
    procedure UnlockSettingsFile;
    procedure UpdateFile;
    function CanView(AUserID: string; AnEmpCode: string): boolean;
    procedure SetCanView(AUserID: string; AnEmpCode: string; YesNo: boolean);
    property AssociatedUserID[AUserName: string]: string read GetAssociatedUserID write SetAssociatedUserID; // IProfile.upUserID
    property AutoGenNoteStatus: string read GetAutoGenNoteStatus write SetAutoGenNoteStatus;
    property AutoGenNoteText: string read GetAutoGenNoteText write SetAutoGenNoteText;
    property CompanyDataPath: string read FCompanyDataPath write FCompanyDataPath;
    property DefaultAnalysisCode: string read GetDefaultAnalysisCode write SetDefaultAnalysisCode;
    property DefaultCostCentre: string read GetDefaultCostCentre write SetDefaultCostCentre;
    property DefaultCurrency: integer read GetDefaultCurrency write SetDefaultCurrency;
    property DefaultDepartment: string read GetDefaultDepartment write SetDefaultDepartment;
    property DefaultJobCode: string read GetDefaultJobCode write SetDefaultJobCode;
    property DefaultRateCode: string read GetDefaultRateCode write SetDefaultRateCode;
    property DefaultsSet[AnEmpCode: string]: boolean read GetDefaultsSet;
    property DefaultTimesheetStatus: string read GetDefaultTimesheetStatus write SetDefaultTimesheetStatus;
    property EmpCode: string read FEmpCode write FEmpCode;                                // IEmployee.emCode
    property ILockedTheSettingsFile: boolean read FILockedTheSettingsFile write FILockedTheSettingsFile; // "but I didn't shoot the deputy..." la la la etc.
    property IsAdministrator[UserName: string]: boolean read GetIsAdministrator write SetIsAdministrator;
    property Locked: boolean read GetLocked;
    property ShowAnalysisCode: boolean read GetShowAnalysisCode write SetShowAnalysisCode;
    property ShowChargeOutRate: boolean read GetShowChargeOutRate write SetShowChargeOutRate;
    property ShowCostCentre: boolean read GetShowCostCentre write SetShowCostCentre;
    property ShowCostPerHour: boolean read GetShowCostPerHour write SetShowCostPerHour;
    property ShowDepartment: boolean read GetShowDepartment write SetShowDepartment;
    property ShowRateCode: boolean read GetShowRateCode write SetShowRateCode;
    property ShowTHUDF1: boolean read GetShowTHUDF1 write SetShowTHUDF1;
    property ShowTHUDF2: boolean read GetShowTHUDF2 write SetShowTHUDF2;
    property ShowTHUDF3: boolean read GetShowTHUDF3 write SetShowTHUDF3;
    property ShowTHUDF4: boolean read GetShowTHUDF4 write SetShowTHUDF4;
    property ShowTLUDF1: boolean read GetShowTLUDF1 write SetShowTLUDF1;
    property ShowTLUDF2: boolean read GetShowTLUDF2 write SetShowTLUDF2;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    property ShowTHUDF5: boolean read GetShowTHUDF5 write SetShowTHUDF5;
    property ShowTHUDF6: boolean read GetShowTHUDF6 write SetShowTHUDF6;
    property ShowTHUDF7: boolean read GetShowTHUDF7 write SetShowTHUDF7;
    property ShowTHUDF8: boolean read GetShowTHUDF8 write SetShowTHUDF8;
    property ShowTHUDF9: boolean read GetShowTHUDF9 write SetShowTHUDF9;
    property ShowTHUDF10: boolean read GetShowTHUDF10 write SetShowTHUDF10;
    property ShowTLUDF5: boolean read GetShowTLUDF5 write SetShowTLUDF5;
    property ShowTLUDF6: boolean read GetShowTLUDF6 write SetShowTLUDF6;
    property ShowTLUDF7: boolean read GetShowTLUDF7 write SetShowTLUDF7;
    property ShowTLUDF8: boolean read GetShowTLUDF8 write SetShowTLUDF8;
    property ShowTLUDF9: boolean read GetShowTLUDF9 write SetShowTLUDF9;
    property ShowTLUDF10: boolean read GetShowTLUDF10 write SetShowTLUDF10;

    property ShowTotalHours: boolean read GetShowTotalHours write SetShowTotalHours;
    property ShowTotalCharge: boolean read GetShowTotalCharge write SetShowTotalCharge;
    property ShowTotalCost: boolean read GetShowTotalCost write SetShowTotalCost;
  end;

function TimesheetSettings(ADataPath: string = ''): TTimesheetIni;

implementation

uses classes, BlowFish, dialogs;

const
  SETTINGS_FILE_NAME = 'Timesheets.dat';

var
  FTimesheetIni: TTimesheetIni;

function TimesheetSettings(ADataPath: string = ''): TTimesheetIni;
begin
  if FTimesheetIni = nil then
    FTimesheetIni := TTimesheetIni.Create(ADataPath);

  result := FTimesheetIni;
end;

function DecryptIniFile(AIniFileName: string; ToStream: boolean): TMemoryStream;
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
        MSO.SaveToFile(AIniFileName);   // save the decrypted file back to disk ready for TBigIni to read or write
                                        // but only now we know the contents are valid
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

procedure EncryptIniFile(AIniFileName: string);
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
      MSO.SaveToFile(AIniFileName);   // save the encrypted file over the top of the original disk file
                                      // but only now we know the contents are valid
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

{ TTimesheetIni }

constructor TTimesheetIni.Create(ADataPath: string);
begin
  inherited Create;

  CompanyDataPath := ADataPath;
  DecryptIniFile(SettingsFileName, false);
  FIniFile := TBigIniFile.Create(SettingsFileName); // forces an AppendFromFile
  if not PlainOut then EncryptIniFile(SettingsFileName);
end;

destructor TTimesheetIni.Destroy;
begin
  DecryptIniFile(SettingsFileName, false);
  if assigned(FIniFile) then begin
    FIniFile.Free; // causes any changes to be written to the file by forcing a Flush
    FIniFile := nil;
  end;
  if not PlainOut then EncryptIniFile(SettingsFileName);
  UnlockSettingsFile;

  inherited;
  FTimesheetIni := nil;
end;

function TTimesheetIni.GetAutoGenNoteStatus: string;
begin
  result := GetSettingsValue('AutoGenNoteStatus');
end;

function TTimesheetIni.GetAutoGenNoteText: string;
begin
  result := GetSettingsValue('AutoGenNoteText');
end;

function TTimesheetIni.GetDefaultAnalysisCode: string;
begin
  result := GetSettingsValue('DefaultAnalysisCode');
end;

function TTimesheetIni.GetDefaultCostCentre: string;
begin
  result := GetSettingsValue('DefaultCostCentre');
end;

function TTimesheetIni.GetDefaultCurrency: integer;
begin
  result := StrToIntDef(GetSettingsValue('DefaultCurrency'), 0);
end;

function TTimesheetIni.GetDefaultDepartment: string;
begin
  result := GetSettingsValue('DefaultDepartment');
end;

function TTimesheetIni.GetDefaultRateCode: string;
begin
  result := GetSettingsValue('DefaultRateCode');
end;

function TTimesheetIni.GetDefaultTimesheetStatus: string;
begin
  result := GetSettingsValue('DefaultTimesheetStatus');
end;

function TTimesheetIni.GetShowAnalysisCode: boolean;
begin
  result := GetSettingsValue('ShowAnalysisCode') = YesOrNo(true);
end;

function TTimesheetIni.GetShowChargeOutRate: boolean;
begin
  result := GetSettingsValue('ShowChargeOutRate') = YesOrNo(true);
end;

function TTimesheetIni.GetShowCostCentre: boolean;
begin
  result := GetSettingsValue('ShowCostCentre') = YesOrNo(true);
end;

function TTimesheetIni.GetShowCostPerHour: boolean;
begin
  result := GetSettingsValue('ShowCostPerHour') = YesOrNo(true);
end;

function TTimesheetIni.GetShowDepartment: boolean;
begin
  result := GetSettingsValue('ShowDepartment') = YesOrNo(true);
end;

function TTimesheetIni.GetShowRateCode: boolean;
begin
  result := GetSettingsValue('ShowRateCode') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTHUDF1: boolean;
begin
  result := GetSettingsValue('ShowTHUDF1') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTHUDF2: boolean;
begin
  result := GetSettingsValue('ShowTHUDF2') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTHUDF3: boolean;
begin
  result := GetSettingsValue('ShowTHUDF3') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTHUDF4: boolean;
begin
  result := GetSettingsValue('ShowTHUDF4') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTLUDF1: boolean;
begin
  result := GetSettingsValue('ShowTLUDF1') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTLUDF2: boolean;
begin
  result := GetSettingsValue('ShowTLUDF2') = YesOrNo(true);
end;

procedure TTimesheetIni.SetAutoGenNoteStatus(const Value: string);
begin
  PutSettingsValue('AutoGenNoteStatus', Value);
end;

procedure TTimesheetIni.SetAutoGenNoteText(const Value: string);
begin
  PutSettingsValue('AutoGenNoteText', Value);
end;

procedure TTimesheetIni.SetDefaultAnalysisCode(const Value: string);
begin
  PutSettingsValue('DefaultAnalysisCode', Value);
end;

procedure TTimesheetIni.SetDefaultCostCentre(const Value: string);
begin
  PutSettingsValue('DefaultCostCentre', Value);
end;

procedure TTimesheetIni.SetDefaultCurrency(const Value: integer);
begin
  PutSettingsValue('DefaultCurrency', IntToStr(Value));
end;

procedure TTimesheetIni.SetDefaultDepartment(const Value: string);
begin
  PutSettingsValue('DefaultDepartment', Value);
end;

procedure TTimesheetIni.SetDefaultRateCode(const Value: string);
begin
  PutSettingsValue('DefaultRateCode', Value);
end;

procedure TTimesheetIni.SetDefaultTimesheetStatus(const Value: string);
begin
  PutSettingsValue('DefaultTimeSheetStatus', Value);
end;

procedure TTimesheetIni.SetShowAnalysisCode(const Value: boolean);
begin
  PutSettingsValue('ShowAnalysisCode', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowChargeOutRate(const Value: boolean);
begin
  PutSettingsValue('ShowChargeOutRate', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowCostCentre(const Value: boolean);
begin
  PutSettingsValue('ShowCostCentre', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowCostPerHour(const Value: boolean);
begin
  PutSettingsValue('ShowCostPerHour', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowDepartment(const Value: boolean);
begin
  PutSettingsValue('ShowDepartment', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowRateCode(const Value: boolean);
begin
  PutSettingsValue('ShowRateCode', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTHUDF1(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF1', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTHUDF2(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF2', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTHUDF3(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF3', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTHUDF4(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF4', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTLUDF1(const Value: boolean);
begin
  PutSettingsValue('ShowTLUDF1', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTLUDF2(const Value: boolean);
begin
  PutSettingsValue('ShowTLUDF2', YesOrNo(Value));
end;

function TTimesheetIni.SettingsFileName: string;
begin
  result := IncludeTrailingBackslash(trim(CompanyDataPath)) + SETTINGS_FILE_NAME;
end;

function TTimesheetIni.SettingsSection: string;
begin
  result := {UserID; // + '-' + }EmpCode;
end;

function TTimesheetIni.GetSettingsValue(ValueName: string; Default: string): string;
begin
  result := FIniFile.ReadString(SettingsSection, ValueName, Default);
end;

procedure TTimesheetIni.PutSettingsValue(ValueName: string; ValueData: string);
begin
  FIniFile.WriteString(SettingsSection, ValueName, ValueData);
end;

function TTimesheetIni.YesOrNo(ABoolean: boolean): string;
const
  YesNo: array[false..true] of string = ('No', 'Yes');
begin
  result := YesNo[ABoolean];
end;

procedure TTimesheetIni.UpdateFile;
begin
  DecryptIniFile(SettingsFileName, false);
  if assigned(FIniFile) then
    FIniFile.UpdateFile;
  if not PlainOut then EncryptIniFile(SettingsFileName);
end;

function TTimesheetIni.CanView(AUserID, AnEmpCode: string): boolean;
begin
  result := AUserID = 'MANAGER'; // or IsAdministrator(AUserID);
  if not result then
    result := FIniFile.ReadString(AUserID + '-CanView', AnEmpCode, 'No') = YesOrNo(True);
end;

procedure TTimesheetIni.SetCanView(AUserID, AnEmpCode: string; YesNo: boolean);
begin
  if AUserID = '' then EXIT;
  FIniFile.WriteString(AUserID + '-CanView', AnEmpCode, YesOrNo(YesNo));
end;

function TTimesheetIni.GetIsAdministrator(AUserName: string): boolean;
begin
  result := AUserName = 'MANAGER';
  if not result then
    result := FIniFile.ReadString(AUserName, 'IsAdministrator', 'No') = 'Yes';
end;

procedure TTimesheetIni.SetIsAdministrator(AUserName: string; const Value: boolean);
begin
  FIniFile.WriteString(AUserName, 'IsAdministrator', YesOrNo(Value));
end;

function TTimesheetIni.GetAssociatedUserID(AUserName: string): string;
begin
  result := FIniFile.ReadString(AUserName, 'AssociatedUserID', '');
end;

procedure TTimesheetIni.SetAssociatedUserID(AUserName: string; const Value: string);
begin
  if (AUserName = '') or (Value = '') then EXIT;
  FIniFile.WriteString(AUserName, 'AssociatedUserID', Value);
end;

function TTimesheetIni.GetDefaultsSet(AnEmpCode: string): boolean;
begin
  result := FIniFile.SectionExists(AnEmpCode);
end;

function TTimesheetIni.GetShowTotalCharge: boolean;
begin
  result := GetSettingsValue('ShowTotalCharge') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTotalHours: boolean;
begin
  result := GetSettingsValue('ShowTotalHours') = YesOrNo(true);
end;

procedure TTimesheetIni.SetShowTotalCharge(const Value: boolean);
begin
  PutSettingsValue('ShowTotalCharge', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTotalHours(const Value: boolean);
begin
  PutSettingsValue('ShowTotalHours', YesOrNo(Value));
end;

procedure TTimesheetIni.UnlockSettingsFile;
begin
  if not FILockedTheSettingsFile then EXIT;
  FILockedTheSettingsFile := false;
  DeleteFile(ChangeFileExt(SettingsFileName, '.lck'));
end;

function TTimesheetIni.LockSettingsFile: boolean;
begin
  result := FILockedTheSettingsFile;
  if FileExists(ChangeFileExt(SettingsFileName, '.lck')) then EXIT;
  FileClose(FileCreate(ChangeFileExt(SettingsFileName, '.lck')));
  FILockedTheSettingsFile := true;
  result := true;
end;

function TTimesheetIni.GetLocked: boolean; // is the settings file locked by someone else ?
begin
  result := not FILockedTheSettingsFile and FileExists(ChangeFileExt(SettingsFileName, '.lck'));
end;

function TTimesheetIni.PlainOut: boolean;
begin
  result := FileExists(ChangeFileExt(SettingsFileName, '.pln'));
end;

function TTimesheetIni.GetDefaultJobCode: string;
begin
  result := GetSettingsValue('DefaultJobCode');
end;

procedure TTimesheetIni.SetDefaultJobCode(const Value: string);
begin
  PutSettingsValue('DefaultJobCode', Value);
end;

function TTimesheetIni.GetShowTotalCost: boolean;
begin
  result := GetSettingsValue('ShowTotalCost') = YesOrNo(true);
end;

procedure TTimesheetIni.SetShowTotalCost(const Value: boolean);
begin
  PutSettingsValue('ShowTotalCost', YesOrNo(Value));
end;

{ CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
function TTimesheetIni.GetShowTHUDF10: boolean;
begin
  result := GetSettingsValue('ShowTHUDF10', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTHUDF5: boolean;
begin
  result := GetSettingsValue('ShowTHUDF5', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTHUDF6: boolean;
begin
  result := GetSettingsValue('ShowTHUDF6', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTHUDF7: boolean;
begin
  result := GetSettingsValue('ShowTHUDF7', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTHUDF8: boolean;
begin
  result := GetSettingsValue('ShowTHUDF8', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTHUDF9: boolean;
begin
  result := GetSettingsValue('ShowTHUDF9', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTLUDF10: boolean;
begin
  result := GetSettingsValue('ShowTLUDF10', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTLUDF5: boolean;
begin
  result := GetSettingsValue('ShowTLUDF5', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTLUDF6: boolean;
begin
  result := GetSettingsValue('ShowTLUDF6', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTLUDF7: boolean;
begin
  result := GetSettingsValue('ShowTLUDF7', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTLUDF8: boolean;
begin
  result := GetSettingsValue('ShowTLUDF8', 'Yes') = YesOrNo(true);
end;

function TTimesheetIni.GetShowTLUDF9: boolean;
begin
  result := GetSettingsValue('ShowTLUDF9', 'Yes') = YesOrNo(true);
end;

procedure TTimesheetIni.SetShowTHUDF10(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF10', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTHUDF5(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF5', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTHUDF6(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF6', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTHUDF7(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF7', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTHUDF8(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF8', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTHUDF9(const Value: boolean);
begin
  PutSettingsValue('ShowTHUDF9', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTLUDF10(const Value: boolean);
begin
  PutSettingsValue('ShowTLUDF10', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTLUDF5(const Value: boolean);
begin
  PutSettingsValue('ShowTLUDF5', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTLUDF6(const Value: boolean);
begin
  PutSettingsValue('ShowTLUDF6', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTLUDF7(const Value: boolean);
begin
  PutSettingsValue('ShowTLUDF7', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTLUDF8(const Value: boolean);
begin
  PutSettingsValue('ShowTLUDF8', YesOrNo(Value));
end;

procedure TTimesheetIni.SetShowTLUDF9(const Value: boolean);
begin
  PutSettingsValue('ShowTLUDF9', YesOrNo(Value));
end;

initialization
  FTimesheetIni := nil;

end.
