unit oSurveyDataFile;

interface

Uses SysUtils;

Type
  TExchequerDataFile = Class(TObject)
  Private
    FCompanyDataSet : TObject;
    FDBEngine : ShortString;
    FFileFormat : ShortString;
    FFileName : ShortString;
    FFileSize : Int64;
    FLastExtension : ShortString;
    FRecordCount : LongInt;
    FStatus : ShortString;
  Protected

  Public
    Property dfDBEngine : ShortString Read FDBEngine;
    Property dfFileFormat : ShortString Read FFileFormat;
    Property dfFileName : ShortString Read FFileName;
    Property dfFileSize : Int64 Read FFileSize;
    Property dfLastExtension : ShortString Read FLastExtension;
    Property dfRecordCount : LongInt Read FRecordCount;
    Property dfStatus : ShortString Read FStatus;

    Constructor Create (Const CompanyDataSet : TObject; Const FilePath : ShortString);
    Destructor Destroy; Override;
  End; // TExchequerDataFile

implementation

Uses oSurveyDataSet, oBtrieveFile, oGenericBtrieveFile, ConvUtil;

//=========================================================================

Constructor TExchequerDataFile.Create (Const CompanyDataSet : TObject; Const FilePath : ShortString);
Var
  sPath : ShortString;
  oBtrFile : TGenericBtrieveFile;
  lRes : LongInt;
  Version, SubVersion : SmallInt;
  EngineType : Char;
Begin // Create
  Inherited Create;

  FCompanyDataSet := CompanyDataSet;
  FFilename := FilePath;
  FRecordCount := -1;
  FStatus := 'Ok';
  FFileSize := 0;
  FFileFormat := '';
  FDBEngine := '';
  FLastExtension := '';

  sPath := TExchequerDataSet(FCompanyDataSet).CompPath + FFilename;

  If FileExists(sPath) Then
  Begin
    FFileSize := TBtrieveFileUtilities.Size (sPath);
    FLastExtension := TBtrieveFileUtilities.LastExtensionFile(sPath);

    oBtrFile := TGenericBtrieveFile.Create;
    Try
      lRes := oBtrFile.OpenFile (sPath, False, v571Owner);
      If (lRes = 0) Then
      Begin
        FRecordCount := oBtrFile.GetRecordCount;
        FFileFormat := 'v' + IntToStr(oBtrFile.FileVersion);
        If (oBtrFile.FileVersion < 6) Then
          FStatus := 'Rebuild';

        // CJS: 26/11/2007: The EngineType was sometimes #0, resulting in the
        // string being truncated.
        oBtrFile.GetEngineVersion (Version, SubVersion, EngineType, 1);
        FDBEngine := IntToStr(Version) + '.' + IntToStr(SubVersion) + Trim(EngineType) + '/';
        oBtrFile.GetEngineVersion (Version, SubVersion, EngineType, 2);
        FDBEngine := FDBEngine + IntToStr(Version) + '.' + IntToStr(SubVersion) + Trim(EngineType) + '/';
        oBtrFile.GetEngineVersion (Version, SubVersion, EngineType, 3);
        FDBEngine := FDBEngine + IntToStr(Version) + '.' + IntToStr(SubVersion) + Trim(EngineType);

        oBtrFile.CloseFile;
      End // If (lRes = 0)
      Else
        FStatus := 'Error ' + IntToStr(lRes) + ' opening file';
    Finally
      FreeAndNIL(oBtrFile);
    End; // Try..Finally
  End // If FileExists(sPath)
  Else
    FStatus := 'Missing';
End; // Create

//------------------------------

Destructor TExchequerDataFile.Destroy;
Begin // Destroy

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------




end.
