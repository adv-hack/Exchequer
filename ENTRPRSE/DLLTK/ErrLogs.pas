unit ErrLogs;

interface

Type
  ILoginErrorLog = Interface
    ['{A687B3A4-9255-4D9C-B97D-C7B37A1D82DE}']
    // --- Internal Methods to implement Public Properties ---
    // ------------------ Public Properties ------------------
    // ------------------- Public Methods --------------------
    Procedure RemoveLog;
  End; // ILoginErrorLog

Function New_ILoginErrorLog (Const UserId, ComputerId : ShortString) : ILoginErrorLog;

// CloseDll/CloseToolkit Error Log
Procedure AddCloseErrorLog (Const ErrNo : LongInt; Const ErrText, FuncName : ShortString);

// InitDll/OpenToolkit Exclusivity Check Error Log
Procedure AddExclusiveErrorLog (Const ErrNo : LongInt);

// InitDll/OpenToolkit Error Log
Procedure AddInitErrorLog (Const ErrNo : LongInt; Const ErrText : ShortString);

// Error when Resetting the User Counts after Exclusive Check
Procedure ResetUserCountErrorLog (Const ErrNo : LongInt; Const ErrText : ShortString);

// User Count Corruption Error Log
Procedure AddUCCErrorLog (Const CompanyUsers, MCMUsers : SmallInt);

// Error in RemoveLoginRef when closing the Toolkit
Procedure RemoveLoginRefErrorLog (Const ErrNo : LongInt; Const UserId, ComputerId : ShortString);

// General Error Log
Procedure AddErrorLog (Const Func, Msg : ShortString);


implementation

Uses Classes, Forms, SysUtils, APIUtil,
     {$IFDEF COMTK}
     COMTKVer,
     {$ENDIF} // COMTK
    {$IFDEF SOPDLL}
     SpDlInit,
    {$ENDIF}
     GlobVar;

{$IFNDEF COMTK}
{$I Version.Inc}
{$ENDIF} // COMTK

Type

  // Created to keep track of the log file created for the user count when it is
  // allocated and delete it when the user count is released, if not released then
  // the log file should be left intact
  TLoginErrorLog = Class(TInterfacedObject, ILoginErrorLog)
  Private
    FLogName : ShortString;
    Procedure RemoveLog;
  Public
    Constructor Create (Const UserId, ComputerId : ShortString);
  End; // TLoginErrorLog

  //------------------------------

  TLogFile = Class(TStringList)
  Private
    FSavedName : ShortString;
  Public
    Property SavedName : ShortString Read FSavedName;

    Constructor Create;
    Procedure SaveLog;
  End; // TLogFile

Var
  // Random number in range 1-999 used to group log files for a session together
  iUser : SmallInt;

//=========================================================================

// Internal function to return a log file name, creates the LOGS directory if missing
Function GetNewLogName : ShortString;
Var
  sFileName : ShortString;
  iFile     : SmallInt;
Begin // GetNewLogName
  // Check the Logs directory exists
  Result := IncludeTrailingPathDelimiter(SetDrive) + 'Logs\';
  If (Not DirectoryExists(Result)) Then
  Begin
    ForceDirectories (Result);
  End; // If (Not DirectoryExists(Result))

  // Generate a unique filename within the directory
  iFile := 1;
  Repeat
    sFileName := 'E' + IntToStr(iUser) + IntToStr(iFile) + '.Log';
    Inc(iFile);
  Until (Not FileExists(Result + sFileName)) Or (iFile > 9999);

  Result := Result + sFileName;
End; // GetNewLogName

//=========================================================================

Function New_ILoginErrorLog (Const UserId, ComputerId : ShortString) : ILoginErrorLog;
Begin // New_ILoginErrorLog
  Result := TLoginErrorLog.Create(UserId, ComputerId);
End; // New_ILoginErrorLog

//=========================================================================

Constructor TLoginErrorLog.Create (Const UserId, ComputerId : ShortString);
Begin // Create
  Inherited Create;

  With TLogFile.Create Do
  Begin
    Try
      Add ('Log Type : Toolkit Application Running');
      Add ('');
      Add ('Company: ' + SetDrive);
      Add ('Logged In User: ' + UserId);
      Add ('Logged In Workstation: ' + ComputerId);
      SaveLog;

      // Record the log name so it can be deleted
      FLogName := SavedName;
    Finally
      Free;
    End; // Try..Finally
  End; // With TLogFile.Create
End; // Create

//-------------------------------------------------------------------------

Procedure TLoginErrorLog.RemoveLog;
Begin // RemoveLog
  If FileExists(FLogName) Then
    DeleteFile (FLogName);
End; // RemoveLog

//=========================================================================

Constructor TLogFile.Create;
Begin // Create
  Inherited Create;

  FSavedName := '';
  {$IFDEF SOPDLL}
     Add ('Exchequer COM Toolkit SPDll ' + SP_VERSION);
  {$ELSE}
    {$IFDEF COMTK}
    Add ('Exchequer COM Toolkit ' + COMTKVersion);
    {$ELSE}
    Add ('Exchequer Toolkit Dll ' + Ver);
    {$ENDIF}
  {$ENDIF}
  Add (Application.ExeName);
  Add (FormatDateTime ('DD/MM/YY - HH:MM:SS', Now) +
                 '    Computer: ' +  WinGetComputerName +
                 '    User: ' +  WinGetUserName);
  Add ('---------------------------------------------------------------');
End; // Create

//-------------------------------------------------------------------------

Procedure TLogFile.SaveLog;
Var
  sLogName : ShortString;
  iSave    : SmallInt;
Begin // SaveLog
  // Identify Filename and save - give it a few goes to ensure a unique filename
  For iSave := 1 To 5 Do
  Begin
    sLogName := GetNewLogName;
    If (Not FileExists(sLogName)) Then
    Begin
      FSavedName := sLogName;
      SaveToFile (sLogName);
      Break;
    End // If (Not FileExists(LogName))
    Else
      Sleep(50);
  End; // For iSave
End; // SaveLog

//=========================================================================

// User Count Corruption Error Log
Procedure AddUCCErrorLog (Const CompanyUsers, MCMUsers : SmallInt);
Begin // AddUCCErrorLog
  With TLogFile.Create Do
  Begin
    Try
      Add ('Log Type : Toolkit User Count Corruption');
      Add ('');
      Add ('Company Dataset: ' + SetDrive);
      Add ('Company User Count: ' + IntToStr(CompanyUsers));
      Add ('Master User Count: ' + IntToStr(MCMUsers));
      SaveLog;
    Finally
      Free;
    End; // Try..Finally
  End; // With TLogFile.Create
End; // AddUCCErrorLog

//=========================================================================

// InitDll/OpenToolkit Error Log
Procedure AddInitErrorLog (Const ErrNo : LongInt; Const ErrText : ShortString);
Begin // AddInitErrorLog
  With TLogFile.Create Do
  Begin
    Try
      {$IFDEF SOPDLL}
        Add ('Log Type : SP_InitDll Error ' + IntToStr(ErrNo) + ' - ' + ErrText);
      {$ELSE}
        {$IFDEF COMTK}
        Add ('Log Type : OpenToolkit Error ' + IntToStr(ErrNo) + ' - ' + ErrText);
        {$ELSE}
        Add ('Log Type : Ex_InitDll Error ' + IntToStr(ErrNo) + ' - ' + ErrText);
        {$ENDIF}
      {$ENDIF}
      SaveLog;
    Finally
      Free;
    End; // Try..Finally
  End; // With TLogFile.Create
End; // AddInitErrorLog

//=========================================================================

// CloseDll/CloseToolkit Error Log
Procedure AddCloseErrorLog (Const ErrNo : LongInt; Const ErrText, FuncName : ShortString);
Begin // AddCloseErrorLog
  With TLogFile.Create Do
  Begin
    Try
      {$IFDEF COMTK}
      Add ('Log Type : CloseToolkit Error ' + IntToStr(ErrNo) + ' - ' + ErrText);
      {$ELSE}
      Add ('Log Type : ' + FuncName + ' Error ' + IntToStr(ErrNo) + ' - ' + ErrText);
      {$ENDIF}
      SaveLog;
    Finally
      Free;
    End; // Try..Finally
  End; // With TLogFile.Create
End; // AddCloseErrorLog

//=========================================================================

// Error in RemoveLoginRef when closing the Toolkit
Procedure RemoveLoginRefErrorLog (Const ErrNo : LongInt; Const UserId, ComputerId : ShortString);
Begin // RemoveLoginRefErrorLog
  With TLogFile.Create Do
  Begin
    Try
      Add ('Log Type : Remove Logged-In User Error ' + IntToStr(ErrNo));
      Add ('');
      Add ('Company: ' + SetDrive);
      Add ('Logged In User: ' + UserId);
      Add ('Logged In Workstation: ' + ComputerId);
      SaveLog;
    Finally
      Free;
    End; // Try..Finally
  End; // With TLogFile.Create
End; // RemoveLoginRefErrorLog

//=========================================================================

// InitDll/OpenToolkit Exclusivity Check Error Log
Procedure AddExclusiveErrorLog (Const ErrNo : LongInt);
Begin // AddExclusiveErrorLog
  With TLogFile.Create Do
  Begin
    Try
      Add ('Log Type : Exclusive Check Error ' + IntToStr(ErrNo));
      SaveLog;
    Finally
      Free;
    End; // Try..Finally
  End; // With TLogFile.Create
End; // AddExclusiveErrorLog

//=========================================================================

// Error when Resetting the User Counts after Exclusive Check
Procedure ResetUserCountErrorLog (Const ErrNo : LongInt; Const ErrText : ShortString);
Begin // AddExclusiveErrorLog
  With TLogFile.Create Do
  Begin
    Try
      Add ('Log Type : Exclusive Reset Error ' + IntToStr(ErrNo) + ' - ' + ErrText);
      Add ('');
      Add ('Company: ' + SetDrive);
      SaveLog;
    Finally
      Free;
    End; // Try..Finally
  End; // With TLogFile.Create
End; // AddExclusiveErrorLog

//=========================================================================

//General error - Func should be the function in which the error occurred, Msg should be the error message
Procedure AddErrorLog (Const Func, Msg : ShortString);
Begin // AddExclusiveErrorLog
  With TLogFile.Create Do
  Begin
    Try
      Add ('Log Type : Error in ' + Func + ' - ' + Msg);
      SaveLog;
    Finally
      Free;
    End; // Try..Finally
  End; // With TLogFile.Create
End; // AddExclusiveErrorLog


//=========================================================================


Initialization
  Randomize;
  iUser := Random(998) + 1;  // Generate random Id in range 1-999
end.
