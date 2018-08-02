Unit oBaseDataClasses;

Interface

Uses Classes, Contnrs, SysUtils, DataFileInfo;

Type
  // Base class for analysis of a data file and storage of information, this will be overriden
  // with SQL and Pervasive specific variants implementing the analysis and providing additional
  // storage
  TDataFile = Class(TObject)
  Protected
    FDataFileInfo : IExchequerDataFileInfo;

    // Size in bytes of SQL Table or Btrieve File (including any extension files)
    FFileSize : Int64;

    // Number of rows/records in the Table/File
    FRecordCount : Int64;

    // Textual description of analysis status
    FStatus : ShortString;

    // String list to store additional details generated in AnalyseFileContents
    FAdditionalXML : TStringList;

    Function GetFileSize : Int64; Virtual;
  Public
    Property Size : Int64 Read GetFileSize;

    Constructor Create (Const DataFileInfo : IExchequerDataFileInfo);
    Destructor Destroy; Override;

    //Procedure AnalyseDataFile (Const DataPath : ShortString); Virtual; Abstract;
    Procedure WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString); Virtual; Abstract;
  End; // TDataFile

  //------------------------------

  // Generic storage for TDataFile objects
  TDatafileList = Class(TObject)
  Private
    FDataFiles : TObjectList;

    Function GetDataFileCount : Integer;
    Function GetDataFile (Index : Integer) : TDataFile;
    Function GetTotalSize : Int64;
  Public
    Property DataFileCount : Integer Read GetDataFileCount;
    Property DataFiles [Index : Integer] : TDataFile Read GetDataFile;
    Property TotalSize : Int64 Read GetTotalSize;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure Add (Const DataFile : TDataFile);
    Procedure WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString);
  End; // TDatafileList

  //------------------------------

  TCompanyInfo = Class(TDatafileList)
  Private
    FCompanyCode : ShortString;
    FCompanyName : ShortString;
    FCompanyPath : ShortString;
  Public
    Property coCode : ShortString Read FCompanyCode;
    Property coName : ShortString Read FCompanyName;
    Property coPath : ShortString Read FCompanyPath;

    Constructor Create (Const CompanyCode, CompanyName, CompanyPath : ShortString); 
    Procedure WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString);
  End; // TCompanyInfo

  //------------------------------

  // Base class for storing the information about the companies and data files, separate
  // descendants will be written for SQL and Pervasive to provide specifi implementations
  // of the ScanInstallation method.
  TInstallationData = Class(TObject)
  Protected
    FCommonData : TDatafileList;
    FCompanies : TObjectList;

    // String list to store additional details generated about the database
    FAdditionalXML : TStringList;

    Function GetCompanyCount : Integer;
    Function GetCompany (Index : Integer) : TCompanyInfo;
  Public
    Property CommonData : TDatafileList Read FCommonData;

    Property CompanyCount : Integer Read GetCompanyCount;
    Property Companies [Index : Integer] : TCompanyInfo Read GetCompany;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure ScanInstallation; Virtual; Abstract;
    Procedure WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString);
  End; // TInstallationData

  //------------------------------

Implementation

Uses ConvUtil;

//=========================================================================

Constructor TDataFile.Create (Const DataFileInfo : IExchequerDataFileInfo);
Begin // Create
  Inherited Create;
  FDataFileInfo := DataFileInfo;
  FFileSize := -1;
  FRecordCount := -1;
  FStatus := 'OK';

  // String list to store additional details generated in AnalyseFileContents
  FAdditionalXML := TStringList.Create;
End; // Create

//------------------------------

Destructor TDataFile.Destroy;
Begin // Destroy
  FDataFileInfo := NIL;
  FreeAndNIL(FAdditionalXML);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TDataFile.GetFileSize : Int64;
Begin // GetFileSize
  Result := FFileSize;
End; // GetFileSize

//=========================================================================

Constructor TDatafileList.Create;
Begin // Create
  Inherited Create;
  FDataFiles := TObjectList.Create;
End; // Create

//------------------------------

Destructor TDatafileList.Destroy;
Begin // Destroy
  FreeAndNIL(FDataFiles);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TDatafileList.GetDataFileCount : Integer;
Begin // GetDataFileCount
  Result := FDataFiles.Count;
End; // GetDataFileCount

//------------------------------

Function TDatafileList.GetDataFile (Index : Integer) : TDataFile;
Begin // GetDataFile
  If (Index >= 0) And (Index < FDataFiles.Count) Then
  Begin
    Result := TDataFile(FDataFiles.Items[Index])
  End // If (Index >= 0) And (Index < FDataFiles.Count)
  Else
    Raise Exception.Create ('TDatafileList.GetDataFile: Invalid Index (' + IntToStr(Index) + ')');
End; // GetDataFile

//------------------------------

Function TDatafileList.GetTotalSize : Int64;
Var
  TotalSize : Int64;
  I : Integer;
Begin // GetTotalSize
  Result := 0;
  For I := 0 To (FDataFiles.Count - 1) Do
    Result := Result + GetDataFile(I).Size;
End; // GetTotalSize

//-------------------------------------------------------------------------

Procedure TDatafileList.Add (Const DataFile : TDataFile);
Begin // Add
  FDataFiles.Add(DataFile);
End; // Add

//-------------------------------------------------------------------------

Procedure TDatafileList.WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString);
Var
  I : Integer;
Begin // WriteXML
  For I := 0 To (FDataFiles.Count - 1) Do
  Begin
    GetDataFile(I).WriteXML(SurveyResults, IndentBy);
  End; // For I
End; // WriteXML

//=========================================================================

Constructor TCompanyInfo.Create (Const CompanyCode, CompanyName, CompanyPath : ShortString);
Begin // Create
  Inherited Create;

  FCompanyCode := CompanyCode;
  FCompanyName := CompanyName;
  FCompanyPath := CompanyPath;
End; // Create

//-------------------------------------------------------------------------

Procedure TCompanyInfo.WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString);
Begin // WriteXML
  With SurveyResults Do
  Begin
    Add (IndentBy + '<Dataset Code="' + Trim(FCompanyCode) +
                           '" Name="' + Trim(FCompanyName) +
                           '" Path="' + Trim(FCompanyPath) +
                           '" FileCount="' + IntToStr(FDataFiles.Count) +
                           '" TotalFilesMB="' + IntToStr(ToMB(TotalSize)) + '">');
    Inherited WriteXML(SurveyResults, IndentBy + '  ');
    Add (IndentBy + '</Dataset>');
  End; // With SurveyResults
End; // WriteXML

//=========================================================================

Constructor TInstallationData.Create;
Begin // Create
  Inherited Create;

  FCommonData := TDatafileList.Create;
  FCompanies := TObjectList.Create;

  // String list to store additional details generated in AnalyseFileContents
  FAdditionalXML := TStringList.Create;
End; // Create

//------------------------------

Destructor TInstallationData.Destroy;
Begin // Destroy
  FreeAndNIL(FAdditionalXML);
  FreeAndNIL(FCompanies);
  FreeAndNIL(FCommonData);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TInstallationData.GetCompanyCount : Integer;
Begin // GetCompanyCount
  Result := FCompanies.Count;
End; // GetCompanyCount

//------------------------------

Function TInstallationData.GetCompany (Index : Integer) : TCompanyInfo;
Begin // GetCompany
  If (Index >= 0) And (Index < FCompanies.Count) Then
  Begin
    Result := TCompanyInfo(FCompanies.Items[Index])
  End // If (Index >= 0) And (Index < FCompanies.Count)
  Else
    Raise Exception.Create ('TInstallationData.GetCompany: Invalid Index (' + IntToStr(Index) + ')');
End; // GetCompany

//-------------------------------------------------------------------------

Procedure TInstallationData.WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString);
Var
  I : Integer;
Begin // WriteXML
  With SurveyResults Do
  Begin
    Add (IndentBy + '<Data>');
    If (FAdditionalXML.Count > 0) Then
    Begin
      For I := 0 To (FAdditionalXML.Count - 1) Do
      Begin
        Add (IndentBy + '  ' + FAdditionalXML.Strings[I]);
      End; // For I
    End; // If (FAdditionalXML.Count > 0)
    Add (IndentBy + '  <CommonData FileCount="' + IntToStr(FCommonData.DataFileCount) + '" TotalFilesMB="' + IntToStr(ToMB(FCommonData.TotalSize)) + 'MB">');
    FCommonData.WriteXML(SurveyResults, IndentBy + '    ');
    Add (IndentBy + '  </CommonData>');
    Add (IndentBy + '  <CompanyDatasets DatasetCount="' + IntToStr(FCompanies.Count) + '">');
    For I := 0 To (FCompanies.Count - 1) Do
    Begin
      GetCompany(I).WriteXML(SurveyResults, IndentBy + '    ');
    End; // For I
    Add (IndentBy + '  </CompanyDatasets>');
    Add (IndentBy + '</Data>');
  End; // With SurveyResults
End; // WriteXML

//=========================================================================

End.
