Unit DataConversionWarnings;

Interface

Uses Classes, Contnrs, SysUtils, Windows, ADODB, oDataPacket;

Const
  MaxWarnings = 300;

Type
  // Base class for wanring objects - don't use directly
  TBaseDataConversionWarning = Class(TObject)
  Private
    FTimeStamp : TDateTime;
    FThreadId : ShortString;

    FDataPacket : TDataPacket;
    FDumpFileName : ShortString;

    Function GetSourceFile : ShortString;
  Public
    Property DataPacket : TDataPacket Read FDataPacket;
    Property DumpFileName : ShortString Read FDumpFileName;
    Property SourceFile : ShortString Read GetSourceFile;

    Constructor Create (Const DataPacket : TDataPacket; Const DumpFileName : ShortString);
    Destructor Destroy; Override;
  End; // TBaseDataConversionWarning

  //------------------------------

  // Class used to encapsulare warnings caused by unknown RecPFix/SubType combinations when processing variant files
  TSQLUnknownVariantWarning = Class(TBaseDataConversionWarning)
  Private
    FVariant : ANSIString;
  Public
    Property Variant : ANSIString Read FVariant;
    Constructor Create (Const DataPacket : TDataPacket; Const DumpFileName : ShortString; Const Variant : ANSIString);
  End; // TSQLUnknownVariantWarning

  //------------------------------

  // Class used to encapsulare warnings caused by Exceptions raised when executing the SQL Insert
  TSQLExecutionExceptionWarning = Class(TBaseDataConversionWarning)
  Private
    FSQLQuery : ANSIString;
    FExceptionMessage : ANSIString;
  Public
    Property SQLQuery : ANSIString Read FSQLQuery;
    Property ExceptionMessage : ANSIString Read FExceptionMessage;

    Constructor Create (Const DataPacket : TDataPacket; Const DumpFileName : ShortString; Const SQLQuery, ExceptionMessage : ANSIString);
  End; // TSQLExecutionExceptionWarning

  //------------------------------

  // Class used to encapsulate warnings caused by ADO returning errors when inserting the data
  TSQLExecutionErrorWarning = Class(TBaseDataConversionWarning)
  Private
    FSQLQuery : ANSIString;
    FSQLResult : Integer;
    FSQLErrors : TStringList;
  Public
    Property SQLErrors : TStringList Read FSQLErrors;
    Property SQLQuery : ANSIString Read FSQLQuery;
    Property SQLResult : Integer Read FSQLResult;

    Constructor Create (Const DataPacket : TDataPacket; Const DumpFileName : ShortString; Const SQLQuery : ANSIString; Const SQLResult : Integer; Const ADOConnection : TADOConnection);
    Destructor Destroy; Override;
  End; // TSQLExecutionExceptionWarning

  //------------------------------

  //
  TDataConversionWarnings = Class(TObject)
  Private
    FWarnings : TObjectList;
    // Total number of calls to AddWarning including those suppressed after passing MaxWarnings
    FTotalWarnings : Integer;

    Function GetCount : Integer;
    Function GetWarning (Index : Integer) : TBaseDataConversionWarning;
  Public
    // Number of warnings in the Warnings array
    Property Count : Integer Read GetCount;
    // Array of Warning detail objects descending from TBaseDataConversionWarning
    Property Warnings [Index : Integer] : TBaseDataConversionWarning Read GetWarning;
    // Total number of warnings logged including any ignored once MaxWarnings was passed
    Property TotalWarningsLogged : Integer Read FTotalWarnings;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure AddWarning (Const WarningObject : TBaseDataConversionWarning);

    // Empties the Warnings List to minimise memory usage
    Procedure ClearList;
  End; // TDataConversionWarnings

  //------------------------------

// Returns a reference to the ConversionWarnings singleton
Function ConversionWarnings : TDataConversionWarnings;

Implementation

Uses LoggingUtils;

Var
  oConversionWarnings : TDataConversionWarnings;

//=========================================================================

// Returns a reference to the ConversionWarnings singleton
Function ConversionWarnings : TDataConversionWarnings;
Begin // ConversionWarnings
  If (Not Assigned(oConversionWarnings)) Then
  Begin
    oConversionWarnings := TDataConversionWarnings.Create;
  End; // If (Not Assigned(oConversionWarnings)

  Result := oConversionWarnings;
End; // ConversionWarnings

//=========================================================================

Constructor TDataConversionWarnings.Create;
Begin // Create
  Inherited Create;

  FTotalWarnings := 0;

  FWarnings := TObjectList.Create;
  FWarnings.OwnsObjects := True;
End; // Create

//------------------------------

Destructor TDataConversionWarnings.Destroy;
Begin // Destroy
  FreeAndNIL(FWarnings);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TDataConversionWarnings.AddWarning (Const WarningObject : TBaseDataConversionWarning);
Begin // AddWarning
  // Limit total number of warnings recorded in detail to prevent the app using all available memory
  If (FWarnings.Count < MaxWarnings) Then
    // Add warning into the list
    FWarnings.Add (WarningObject);

  FTotalWarnings := FTotalWarnings + 1;
End; // AddWarning

//-------------------------------------------------------------------------

// Empties the Warnings List to minimise memory usage
Procedure TDataConversionWarnings.ClearList;
Begin // ClearList
  FWarnings.Clear;
End; // ClearList

//-------------------------------------------------------------------------

Function TDataConversionWarnings.GetCount : Integer;
Begin // GetCount
  Result := FWarnings.Count;
End; // GetCount

//------------------------------

Function TDataConversionWarnings.GetWarning (Index : Integer) : TBaseDataConversionWarning;
Begin // GetWarning
  If (Index >= 0) And (Index < FWarnings.Count) Then
  Begin
    Result := TBaseDataConversionWarning(FWarnings.Items[Index])
  End // If (Index >= 0) And (Index < FWarnings.Count)
  Else
    Raise Exception.Create ('TDataConversionWarnings.GetWarning: Invalid Index (' + IntToStr(Index) + ')');
End; // GetWarning

//=========================================================================

Constructor TBaseDataConversionWarning.Create (Const DataPacket : TDataPacket; Const DumpFileName : ShortString);
Begin // Create
  Inherited Create;

  FTimeStamp := Now;
  FThreadId := Logging.ThreadIdString;
  FDumpFileName := DumpFileName;

  If Assigned(DataPacket) Then
  Begin
    // Create a new DataPacket object to store a copy of the specified DataPacket as that
    // will probably be destroyed shortly after this object is created
    FDataPacket := TDataPacket.Create(DataPacket);
  End; // If Assigned(DataPacket)
End; // Create

//------------------------------

Destructor TBaseDataConversionWarning.Destroy;
Begin // Destroy
  If Assigned(FDataPacket) Then
  Begin
    FDataPacket.Free;
  End; // If Assigned(DataPacket)
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TBaseDataConversionWarning.GetSourceFile : ShortString;
Begin // GetSourceFile
  Result := '?';//FDataPacket.
End; // GetSourceFile


//=========================================================================

Constructor TSQLUnknownVariantWarning.Create (Const DataPacket : TDataPacket; Const DumpFileName : ShortString; Const Variant : ANSIString);
Begin // Create
  Inherited Create (DataPacket, DumpFileName);
  FVariant := Variant;
End; // Create

//=========================================================================

Constructor TSQLExecutionExceptionWarning.Create (Const DataPacket : TDataPacket; Const DumpFileName : ShortString; Const SQLQuery, ExceptionMessage : ANSIString);
Begin // Create
  Inherited Create (DataPacket, DumpFileName);
  FSQLQuery := SQLQuery;
  FExceptionMessage := ExceptionMessage;
End; // Create

//=========================================================================

Constructor TSQLExecutionErrorWarning.Create (Const DataPacket : TDataPacket; Const DumpFileName : ShortString; Const SQLQuery : ANSIString; Const SQLResult : Integer; Const ADOConnection : TADOConnection);
Var
  iError : Integer;
Begin // Create
  Inherited Create (DataPacket, DumpFileName);
  FSQLQuery := SQLQuery;
  FSQLResult := SQLResult;

  FSQLErrors := TStringList.Create;
  For iError := 0 To (ADOConnection.Errors.Count - 1) Do
  Begin
    FSQLErrors.Add (ADOConnection.Errors.Item[iError].Description);
  End; // For iError

  // Log for later reference
End; // Create

//------------------------------

Destructor TSQLExecutionErrorWarning.Destroy;
Begin // Destroy
  FreeAndNIL(FSQLErrors);
  Inherited Destroy;
End; // Destroy

//=========================================================================



Initialization
  oConversionWarnings := NIL;
Finalization
  If Assigned(oConversionWarnings) Then
    FreeAndNIL(oConversionWarnings);
End.
