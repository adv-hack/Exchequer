unit uUpdatePaths;

interface

//Used by Installer to update paths in Default Settings file & Example Job files.
procedure UpdateImporterPaths(const ExchequerPath : string;
                              const CompanyCode   : string;
                              const CompanyName   : string);


//Functions used by Internal systems.
procedure DecryptJobFile(const sFileName : string);
procedure EncryptJobFile(const sFileName : string);
procedure PrepareDefaultSettingsFile;
procedure PrepareExampleJobFile(const JobFile : string);

implementation

uses
  TIniClass, SysUtils, Classes, StrUtils, IniFiles;

const
  S_IMPORTPATH = 'Import\';
  S_SETTINGS = 'Importer.dat';
  S_EXCHEQUER = 'Exchequer Company';

  S_MAPS    = 'FieldMaps';
  S_JOBS    = 'ImportJobs';
  S_FILES   = 'ImportFiles';
  S_ARCHIVE = 'Archive';
  S_LOGS    = 'Logs';

  TAG_MAPS    = '%MAPS%';
  TAG_JOBS    = '%JOBS%';
  TAG_FILES   = '%IMPORTFILES%';
  TAG_ARCHIVE = '%ARCHIVE%';
  TAG_LOGS    = '%LOGS%';
  TAG_COMPANY = '%COMPANY%';

  I_MAPS    = 1;
  I_JOBS    = 2;
  I_FILES   = 3;
  I_ARCHIVE = 4;
  I_LOGS    = 5;

  S_MAPFOLDER     = 'MAP Folder';
  S_JOBFOLDER     = 'Job Folder';
  S_IMPORTFOLDER  = 'Import Folder';
  S_ARCHIVEFOLDER = 'Archive Folder';
  S_LOGFOLDER     = 'Log File Folder';

  S_SYSTEMSETTINGS  = 'System Settings';
  S_JOBSETTINGS     = 'Job Settings';
  S_IMPORTSETTINGS  = 'Import Settings';

  S_IMPORTLIST      = 'Import List';
  S_FIELDMAPS       = 'Field Maps';



var
  TheIni : TIni;

procedure DecryptJobFile(const sFileName : string);
begin
  TheIni := TIni.Create;
  Try
    if FileExists(sFileName) then
      TheIni.DecryptIniFile(sFileName, false);
  Finally
    TheIni.Free;
  End;
end;

procedure EncryptJobFile(const sFileName : string);
begin
  TheIni := TIni.Create;
  Try
    if FileExists(sFileName) then
      TheIni.EncryptIniFile(sFileName);
  Finally
    TheIni.Free;
  End;
end;

procedure PrepareDefaultSettingsFile;
begin
  TheIni := TIni.Create;
  Try
    TheIni.WriteString(S_SYSTEMSETTINGS, S_IMPORTFOLDER, TAG_FILES);
    TheIni.WriteString(S_SYSTEMSETTINGS, S_JOBFOLDER, TAG_JOBS);
    TheIni.WriteString(S_SYSTEMSETTINGS, S_MAPFOLDER, TAG_MAPS);
    TheIni.WriteString(S_SYSTEMSETTINGS, S_LOGFOLDER, TAG_LOGS);

    TheIni.WriteString(S_JOBSETTINGS, S_ARCHIVEFOLDER, TAG_ARCHIVE);
  Finally
    TheIni.Free;
  End;

end;

//Called from the maintenance program to place Tokens into a job file.
procedure PrepareExampleJobFile(const JobFile : string);
var
  sTemp : string;
  SectionKeys, SectionValues, SectionResults : TStringList;
  FIniFile : TMemIniFile;
  sImporterPath : string;

  procedure ReplaceSectionStrings(const sSection, sTag : string);
  var
    i : integer;
    sFilename : string;
  begin
    FIniFile.ReadSection(sSection, SectionKeys);
    FIniFile.ReadSectionValues(sSection, SectionValues);
    for i := 0 to SectionKeys.Count - 1 do // load the entire list
    begin
      if Trim(SectionValues.Values[SectionKeys[i]]) <> '' then
      begin
        sFilename := ExtractFilename(SectionValues.Values[SectionKeys[i]]);
        SectionValues.Values[SectionKeys[i]] := sTag + '\' + sFilename;
      end;
    end;

    FIniFile.EraseSection(sSection); // save the whole list to a new version of the ImportList section
    for i := 0 to SectionKeys.Count - 1 do
         FIniFile.WriteString(sSection, SectionKeys[i],SectionValues.Values[SectionKeys[i]]);
  end;

begin
  TheIni := TIni.Create;
  Try
    if FileExists(JobFile) then
    begin
      TheIni.DecryptIniFile(JobFile, false);
      FIniFile := TMemIniFile.Create(JobFile); // needed if we're reading from an existing job file
      Try
        SectionKeys := TStringList.create;
        SectionValues := TStringList.create;
        SectionResults := TStringList.create;
        try
          //Import Files - can be any number
          ReplaceSectionStrings(S_IMPORTLIST, TAG_FILES);
          SectionValues.Clear;

          //Job Settings - Archive Folder only
          FIniFile.WriteString(S_JOBSETTINGS, S_ARCHIVEFOLDER, TAG_ARCHIVE);

          //Map Files - any number
          ReplaceSectionStrings(S_FIELDMAPS, TAG_MAPS);

          //Company Code & Name
          FIniFile.WriteString(S_IMPORTSETTINGS, S_EXCHEQUER, TAG_COMPANY);

        Finally
          SectionResults.Free;
          SectionValues.Free;
          SectionKeys.Free;
        End;
      Finally
        FIniFile.UpdateFile;
        FIniFile.Free;
        TheIni.EncryptIniFile(JobFile);
      End;
    end;
  Finally
    TheIni.Free;
  End;
end;


//====================================================================================

function IsNewSettingsFile : Boolean;
//Checks if the Importer.Dat file we're working on has been modified by the user. It does this
//by reading the Import Folder value and seeing if it contains TAG_FILES. If so then
//this is a newly installed file and the function returns True.
var
  s : string;
begin
  s := TheIni.ReturnValue(S_SYSTEMSETTINGS, S_IMPORTFOLDER);
  Result := Pos(TAG_FILES, s) > 0;
end;

function UpdateSettingsPaths(const ExchPath : string) : Boolean;
var
  sImporterPath : string;
begin

  Result := False;
  sImporterPath := IncludeTrailingBackslash(ExchPath) + S_IMPORTPATH;
  TheIni := TIni.CreateWithPath(sImporterPath);
  Try
    if IsNewSettingsFile then
    begin
      sImporterPath := IncludeTrailingBackslash(ExchPath) + S_IMPORTPATH;
      TheIni.WriteString(S_SYSTEMSETTINGS, S_IMPORTFOLDER, sImporterPath + S_FILES);
      TheIni.WriteString(S_SYSTEMSETTINGS, S_JOBFOLDER, sImporterPath + S_JOBS);
      TheIni.WriteString(S_SYSTEMSETTINGS, S_MAPFOLDER, sImporterPath + S_MAPS);
      TheIni.WriteString(S_SYSTEMSETTINGS, S_LOGFOLDER, sImporterPath + S_LOGS);

      TheIni.WriteString(S_JOBSETTINGS, S_ARCHIVEFOLDER, sImporterPath + S_ARCHIVE);
      Result := True;
    end;
  Finally
    TheIni.Free;
  End;
end;

function UpdateJobPaths(const ExchPath : string; const CompanyCode : string; const JobFile : string) : Boolean;
var
  sTemp : string;
  SectionKeys, SectionValues : TStringList;
  FIniFile : TMemIniFile;
  sImporterPath : string;

  procedure ReplaceSectionStrings(const sSection, sTag, sValue : string);
  var
    i : integer;
  begin
    FIniFile.ReadSection(sSection, SectionKeys);
    FIniFile.ReadSectionValues(sSection, SectionValues);
    for i := 0 to SectionKeys.Count - 1 do // load the entire list
      SectionValues.Values[SectionKeys[i]] := AnsiReplaceText(SectionValues.Values[SectionKeys[i]],
                                            sTag, sImporterPath + sValue);

    FIniFile.EraseSection(sSection); // save the whole list to a new version of the ImportList section
    for i := 0 to SectionKeys.Count - 1 do
         FIniFile.WriteString(sSection, SectionKeys[i],SectionValues.Values[SectionKeys[i]]);
  end;

begin
  TheIni := TIni.Create;
  Try
    if FileExists(JobFile) then
    begin
      sImporterPath := IncludeTrailingBackslash(ExchPath) + S_IMPORTPATH;
      TheIni.DecryptIniFile(JobFile, false);
      FIniFile := TMemIniFile.Create(JobFile); // needed if we're reading from an existing job file
      Try
        SectionKeys := TStringList.create;
        SectionValues := TStringList.create;
        try
          //Import Files - can be any number
          ReplaceSectionStrings(S_IMPORTLIST, TAG_FILES, S_FILES);
          SectionValues.Clear;

          //Job Settings - Archive Folder only
          sTemp := FIniFile.ReadString(S_JOBSETTINGS, S_ARCHIVEFOLDER, '');
          if Pos(TAG_ARCHIVE, sTemp) > 0 then
          begin
            sTemp := AnsiReplaceStr(sTemp, TAG_ARCHIVE, S_ARCHIVE);
            FIniFile.WriteString(S_JOBSETTINGS, S_ARCHIVEFOLDER, sImporterPath + sTemp);
          end;

          //Map Files - any number
          ReplaceSectionStrings(S_FIELDMAPS, TAG_MAPS, S_MAPS);

          //Company Code & Name
          sTemp := FIniFile.ReadString(S_IMPORTSETTINGS, S_EXCHEQUER, '');
          if Pos(TAG_COMPANY, sTemp) > 0 then
            FIniFile.WriteString(S_IMPORTSETTINGS, S_EXCHEQUER, CompanyCode);

        Finally
                  SectionValues.Free;
          SectionKeys.Free;
        End;
      Finally
        FIniFile.UpdateFile;
        FIniFile.Free;
        TheIni.EncryptIniFile(JobFile);
      End;
    end;
  Finally
    TheIni.Free;
  End;
end;

procedure UpdateImporterPaths(const ExchequerPath : string;
                              const CompanyCode   : string;
                              const CompanyName   : string);
//Procedure to update default settings and example job files, replacing tokens such as %MAPS% with the full path
//to the appropriate folder. Any files without tokens in will be updated but without effect.
//To be called from Installer.
var
  sCompany : string;
  sSearchDir : string;
  Res : Integer;
  S : TSearchRec;
begin
  //Company Code and name are stored together in each JOB file.
  sCompany := CompanyCode + ' - ' + CompanyName;

  //Updates Default Settings file (Importer.Dat)
  UpdateSettingsPaths(ExchequerPath);

  //Find and update all Job files in Importer\ImportJobs
  sSearchDir := IncludeTrailingBackslash(ExchequerPath) + S_IMPORTPATH + S_JOBS + '\';
  Res := FindFirst(sSearchDir + '*.JOB', faAnyFile, S);
  Try
    while Res = 0 do
    begin
      //Update Job file
      UpdateJobPaths(ExchequerPath, sCompany, sSearchDir + S.Name);

      //Get next
      Res := FindNext(S);
    end;
  Finally
    //Free resources
    FindClose(S);
  End;
end;


end.
