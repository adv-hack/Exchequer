unit SQLH_MemMap;

interface

{$ALIGN 1}

Uses Classes, Dialogs, Forms, SysUtils, Windows;

Const
  VariableNameLen = 50;
  VariableValueLength = 255;

  // Function Constants
  fnCreateSQLDatabase = 1;
  fnCreateSQLCompany  = 2;
  fnSQLDataImport     = 3;
  fnSQLImportCompData = 4;
  fnReplicateFiles    = 5;
  fnConvertData       = 6;
  fnSetupLicence      = 7;
  fnSetupCompanyCount = 8;
  fnEntCompanyWizard  = 9;
  fnReplicateLicence  = 10;
  fnDataCopyWizard    = 11;
  fnCopyMainSecurity  = 12;
  fnCheckCompanyCount = 13;  // Non-WISE Function called from DirDlg4.Pas
  fnCompanyExists     = 14;  // Non-WISE Function called from Company Details dialog
  fnCheckSQLObject    = 15;  // Non-WISE Function called from SQL Server Info dialog
  fnArchiveFiles      = 16;
  fnCheckSQLDBCLR     = 17;  // Non-WISE Function called from SQL Server Location dialog
  fnCheckSQLAuthMode  = 18;  // Non-WISE Function called from SQL Server Location dialog
  fnImportCommonData  = 19;
  fnGetConnectionInfo = 20;  // Non-WISE Function called from Pervasive to SQL Conversion
  fnCheckSQLOLEAuto   = 21;  // Non-WISE Function called from SQL Server Location dialog
  fnGenRootLocFiles   = 22;
  fnGenLocFiles       = 23;
  fnInitImporterJobs  = 24;
  fnCreateAuditTrail  = 25;  // MH 03/03/2011 v6.7 ABSEXCH-10687
  fnCreateVAT100Dirs  = 26;  // MH 25/07/2013 v7.0.5 ABSEXCH-13793
  fnExpireAuthWebpage = 27;  // PR 14/10/2016 v2017 R1 ABSEXCH-17
  // MH 07/04/2017 2017-R1 ABSEXCH-18512: Example VRW Reports
  fnReplicateFilesInDir = 28;
  // MH 08/01/2018 2017-R1 ABSEXCH-19316: Initialise SQL Posting Flags
  fnInitialiseSQLPostingFlags = 29;

Type
  pGlobalSetupData = ^TGlobalSetupData;

  //------------------------------

  TGlobalSetupVariableData = Record // 308 Bytes
    gvdName     : String[VariableNameLen];
    gvdValue    : String[VariableValueLength];
    gvdChanged  : Boolean;
  End; { TGlobalSetupVariableData }

  //------------------------------

  TGlobalSetupData = Record  // 50000 bytes
    gsdDefined         : Boolean;
    gsdVersion         : Byte;

    // Parameters from WISE function call in script - usually used for security purposes
    gsdParams          : ShortString;

    // Function for SQLHelpr.Exe to execute
    gsdFunctionId      : LongInt;

    // Number of elements in the gsdVariables array
    gsdVariableCount   : LongInt;

    // Array of successfull Company Login Data
    gsdVariables       : Array [1..100] Of TGlobalSetupVariableData;  // 30800 bytes

    // Return value from functions
    gsdResult          : Boolean;

    // MH 25/06/08: Added so calling routines know an exception has been raised - needs
    //              to be explicitely set in helper routines.
    gsdExceptionRaised : Boolean;

    // For future expandibility
    gsdSpare           : Array [1..18932] Of Byte;
  End; { TGlobalSetupData }

  //------------------------------

  // Generic interface for objects which implement a specific import type
  ISetupMemoryMapVariableDetails = Interface
    ['{058979FE-BFF0-41F0-B041-B70B63335FBC}']
    // --- Internal Methods to implement Public Properties ---
    Function GetName : ShortString;
    Function GetValue : ShortString;
    Procedure SetValue (Value : ShortString);
    Function GetChanged : Boolean;

    // ------------------ Public Properties ------------------
    Property vdName : ShortString Read GetName;
    Property vdValue : ShortString Read GetValue Write SetValue;
    Property vdChanged : Boolean Read GetChanged;

    // ------------------- Public Methods --------------------
  End; // ISetupMemoryMapVariableDetails

  //------------------------------

  TSetupMemoryMapVariableDetails = Class(TInterfacedObject, ISetupMemoryMapVariableDetails)
  Private
    FGlobalData : pGlobalSetupData;
    FVariableIdx : LongInt;
  Protected
    Function GetName : ShortString;
    Function GetValue : ShortString;
    Procedure SetValue (Value : ShortString);
    Function GetChanged : Boolean;
  Public
    Constructor Create (Const GlobalData : pGlobalSetupData; Const Idx : LongInt);
    Destructor Destroy; OverRide;
  End; { TSetupMemoryMapVariableDetails }

  //------------------------------

  TSetupMemoryMap = Class(TObject)
  Private
    FGlobalData : pGlobalSetupData;
    FMapHandle  : THandle;
    FInitGlobalData : Boolean;
    FParams : ANSIString;
  Protected
    Function ConvertName (Const VariableName : ShortString) : ShortString;
    Function GetDefined : Boolean;
    Function GetExceptionRaised : Boolean;
    Function GetFunctionId : LongInt;
    Procedure SetFunctionId(Value : LongInt);
    Function GetMemMapData : TGlobalSetupData;
    Procedure SetMemMapData(Value : TGlobalSetupData);
    Function GetParams : ANSIString;
    Procedure SetParams(Value : ANSIString);
    Function GetResult : Boolean;
    Procedure SetResult(Value : Boolean);
    Function GetVariableCount : LongInt;
    Function GetVariables(Index: LongInt): ISetupMemoryMapVariableDetails;
    Procedure SetException (Value : SysUtils.Exception);
    Procedure InitMemMap(Const InitSettings : Boolean);
  Public
    Constructor Create (Const InitGlobalData : Boolean);
    Destructor Destroy; OverRide;
    Procedure AddVariable (VariableName, VariableValue : ShortString);
    Procedure Clear;

    Property Defined : Boolean Read GetDefined;
    Property Exception : SysUtils.Exception Write SetException;
    Property ExceptionRaised : Boolean Read GetExceptionRaised;
    Property FunctionId : LongInt Read GetFunctionId Write SetFunctionId;
    Property MemMapData : TGlobalSetupData Read GetMemMapData Write SetMemMapData;
    Property Params : ANSIString Read GetParams Write SetParams;
    Property Result : Boolean Read GetResult Write SetResult;
    Property VariableCount : LongInt Read GetVariableCount;
    Property Variables [Index: LongInt] : ISetupMemoryMapVariableDetails Read GetVariables;

    Function IndexOf (VariableName : ShortString) : LongInt;
  End; { TSetupMemoryMap }

  //------------------------------

Var
  GlobalSetupMap : TSetupMemoryMap;

Implementation

//=========================================================================

Constructor TSetupMemoryMapVariableDetails.Create (Const GlobalData : pGlobalSetupData; Const Idx : LongInt);
Begin // Create
  Inherited Create;

  FGlobalData := GlobalData;
  FVariableIdx := Idx;
End; // Create

//------------------------------

Destructor TSetupMemoryMapVariableDetails.Destroy;
Begin // Destroy
  FGlobalData := NIL;
  FVariableIdx := 0;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TSetupMemoryMapVariableDetails.GetName : ShortString;
Begin // GetName
  Result := FGlobalData.gsdVariables[FVariableIdx].gvdName;
End; // GetName

//------------------------------

Function TSetupMemoryMapVariableDetails.GetValue : ShortString;
Begin // GetValue
  Result := FGlobalData.gsdVariables[FVariableIdx].gvdValue;
End; // GetValue
Procedure TSetupMemoryMapVariableDetails.SetValue (Value : ShortString);
Begin // SetValue
  With FGlobalData.gsdVariables[FVariableIdx] Do
  Begin
    gvdValue := Value;
    gvdChanged := True;
  End; // With FGlobalData.gsdVariables[FVariableIdx]
End; // SetValue

//------------------------------

Function TSetupMemoryMapVariableDetails.GetChanged : Boolean;
Begin // GetChanged
  Result := FGlobalData.gsdVariables[FVariableIdx].gvdChanged;
End; // GetChanged

//=========================================================================

Constructor TSetupMemoryMap.Create (Const InitGlobalData : Boolean);
const
  cMMFileName : PChar = 'AKULA971';
Var
  Size: Integer;
Begin { Create }
  Inherited Create;

  FInitGlobalData := InitGlobalData;

  { Get the size of the data to be mapped. }
  Size := SizeOf(TGlobalSetupData);

  { Now get a memory-mapped file object. Note the first parameter passes
    the value $FFFFFFFF or DWord(-1) so that space is allocated from the system's
    paging file. This requires that a name for the memory-mapped
    object get passed as the last parameter. }

  FMapHandle := CreateFileMapping(DWord(-1), nil, PAGE_READWRITE, 0, Size, cMMFileName);

  If (FMapHandle <> 0) Then
  Begin
    { Now map the data to the calling process's address space and get a
      pointer to the beginning of this address }
    FGlobalData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, Size);

    If (Not Assigned(FGlobalData)) Then
    Begin
      // Error
      CloseHandle(FMapHandle);
      RaiseLastOSError;
    End { If (Not Assigned(FGlobalData)) }
    Else
      // OK
      If FInitGlobalData Then InitMemMap(True);
  End { If (FMapHandle <> 0) }
  Else
    { CreateFileMapping generated an error }
    RaiseLastOSError;
End; { Create }

//------------------------------

Destructor TSetupMemoryMap.Destroy;
Begin { Destroy }
  If FInitGlobalData Then
    // Remove settings
    InitMemMap(False);

  UnmapViewOfFile(FGlobalData);
  CloseHandle(FMapHandle);

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TSetupMemoryMap.InitMemMap(Const InitSettings : Boolean);
Begin { InitMemMap }
  FillChar (FGlobalData^, SizeOf(FGlobalData^), #0);
  If InitSettings Then
    With FGlobalData^ Do
    Begin
      gsdDefined := True;
      gsdVersion := 1;
    End; { With FGlobalData^ }
End; { InitMemMap }

//------------------------------

// NOTE: Added for use by Test Harness to allow multiple calls
Procedure TSetupMemoryMap.Clear;
Begin // Clear
  InitMemMap(True);
End; // Clear

//-------------------------------------------------------------------------

Function TSetupMemoryMap.GetDefined : Boolean;
begin
  Result := FGlobalData^.gsdDefined;
end;

//------------------------------

Function TSetupMemoryMap.GetExceptionRaised : Boolean;
Begin // GetExceptionRaised
  Result := FGlobalData^.gsdExceptionRaised;
End; // GetExceptionRaised

//------------------------------

Function TSetupMemoryMap.GetFunctionId : LongInt;
Begin // GetFunctionId
  Result := FGlobalData^.gsdFunctionId;
End; // GetFunctionId
Procedure TSetupMemoryMap.SetFunctionId(Value : LongInt);
Begin // SetFunctionId
  FGlobalData^.gsdFunctionId := Value;
End; // SetFunctionId

//------------------------------

Function TSetupMemoryMap.GetMemMapData : TGlobalSetupData;
Begin // GetMemMapData
  Result := FGlobalData^;
End; // GetMemMapData
Procedure TSetupMemoryMap.SetMemMapData(Value : TGlobalSetupData);
Begin // SetMemMapData
  FGlobalData^ := Value;
End; // SetMemMapData

//------------------------------

Function TSetupMemoryMap.GetParams : ANSIString;
Begin // GetParams
  FParams := FGlobalData^.gsdParams;
  Result := FParams;
End; // GetParams
Procedure TSetupMemoryMap.SetParams(Value : ANSIString);
Begin // SetParams
  FParams := Value;
  FGlobalData^.gsdParams := Value;
End; // SetParams

//------------------------------

Function TSetupMemoryMap.GetResult : Boolean;
Begin // GetResult
  Result := FGlobalData^.gsdResult;
End; // GetResult
Procedure TSetupMemoryMap.SetResult(Value : Boolean);
Begin // SetResult
  FGlobalData^.gsdResult := Value;
End; // SetResult

//------------------------------

Function TSetupMemoryMap.GetVariableCount : LongInt;
Begin // GetVariableCount
  Result := FGlobalData^.gsdVariableCount;
End; // GetVariableCount

//------------------------------

Function TSetupMemoryMap.GetVariables(Index: LongInt): ISetupMemoryMapVariableDetails;
Begin // GetVariables
  With FGlobalData^ Do
    If (Index >= Low(gsdVariables)) And (Index <= High(gsdVariables)) Then
      Result := TSetupMemoryMapVariableDetails.Create (FGlobalData, Index)
    Else
      Raise SysUtils.Exception.Create('TSetupMemoryMap.GetVariables: Invalid Index (' + IntToStr(Index) + ')');
End; // GetVariables

//------------------------------

Procedure TSetupMemoryMap.SetException (Value : SysUtils.Exception);
Begin // SetException
  FGlobalData^.gsdExceptionRaised := True;
End; // SetException

//-------------------------------------------------------------------------

Function TSetupMemoryMap.ConvertName (Const VariableName : ShortString) : ShortString;
Begin // ConvertName
  Result := UpperCase(Trim(VariableName));
End; // ConvertName

//-------------------------------------------------------------------------

Function TSetupMemoryMap.IndexOf (VariableName : ShortString) : LongInt;
Var
  I       : SmallInt;
Begin { IndexOf }
  Result := 0;

  With FGlobalData^ Do
  Begin
    // Check there are some entries to test
    If gsdDefined And (gsdVariableCount > 0) Then
    Begin
      // Convert to common format
      VariableName := ConvertName (VariableName);

      // Run through the array checking for it
      For I := Low(gsdVariables) To gsdVariableCount Do
      Begin
        If (gsdVariables[I].gvdName = VariableName) Then
        Begin
          // Match - Return Index and finish loop now
          Result := I;
          Break;
        End; // If (gsdVariables[I].gsdVariableName = VariableName)
      End; // For I
    End; { If godDefined And (godLoginCount > 0) }

    //If (Result = 0) Then ShowMessage ('TSetupMemoryMap.IndexOf: ' + VariableName);
  End; // With FGlobalData^
End; { IndexOf }

//-------------------------------------------------------------------------

Procedure TSetupMemoryMap.AddVariable (VariableName, VariableValue : ShortString);
Begin { AddLogin }
  With FGlobalData^ Do
  Begin
    // Check for space to add another login
    If gsdDefined And (gsdVariableCount < High(gsdVariables)) Then
    Begin
      // Convert to common format
      VariableName := ConvertName (VariableName);

      // check length is within supported limits
      If (Length(VariableName) > VariableNameLen) Then
        ShowMessage ('TSetupMemoryMap.AddVariable: Max Function Name Length exceeded for ' + VariableName + ' - Length=' + IntToStr(Length(VariableName)));

      // first check to see if it already exists - highly unlikely but just in case
      If (IndexOf (VariableName) = 0) Then
      Begin
        // Setup the next free element in the array
        Inc (gsdVariableCount);
        With gsdVariables[gsdVariableCount] Do
        Begin
          gvdName    := VariableName;
          gvdValue   := VariableValue;
          gvdChanged := False;
        End; // With gsdVariables[gsdVariableCount]
      End // If (IndexOf (VariableName) = 0)
      Else
        ShowMessage ('TSetupMemoryMap.AddVariable: Function Name already exists in cache - ' + VariableName);
    End; // If gsdDefined And (gsdVariableCount < High(gsdVariables))
  End; // With FGlobalData^
End; { AddLogin }

//=========================================================================

Initialization
  GlobalSetupMap := NIL;

  // Ensure the size never changes - 45k
  If (SizeOf(TGlobalSetupData) <> 50000) Then
    ShowMessage ('MemMap.Pas - Incorrect TGlobalSetupData Size (' + IntToStr(SizeOf(TGlobalSetupData)) + ')');

  {$IF Defined(CREATEMAP)}
    // Master Application -
    GlobalSetupMap := TSetupMemoryMap.Create(True);
  {$ELSE}
    // Client - SQLHelpr.Exe
    GlobalSetupMap := TSetupMemoryMap.Create(False);
  {$IFEND}
Finalization
  FreeAndNil(GlobalSetupMap);
end.
