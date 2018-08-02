unit LocalDrv;

interface

Uses Classes, Forms, SysUtils, Windows, SetupU;

// Returns FALSE if V_MAINDIR points to a local hard disk, TRUE if it points to Floppy,
// CD, Network, etc... or if V_MAINDIR is not a valid path
function IsNotLocalDrive (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

Uses FileCtrl, Dialogs;

// Returns FALSE if V_MAINDIR points to a local hard disk, TRUE if it points to Floppy,
// CD, Network, etc... or if V_MAINDIR is not a valid path
function IsNotLocalDrive (var DLLParams: ParamRec): LongBool;
Var
  DriveType : TDriveType;
  W_MainDir : ANSIString;
Begin // IsNotLocalDrive
  // MH 24/04/2008: Removed DirectoryExists and changed to use Drive only as we are often installing to directories that do not exist
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  W_MainDir := IncludeTrailingPathDelimiter(Copy(W_MainDir,1,2));
  //If DirectoryExists(W_MainDir) Then
  Begin
    // Get drive type and retun TRUE if it is a local hard disk
    DriveType := TDriveType(GetDriveType(PCHAR(W_MainDir)));
    Result := (DriveType <> dtFixed);
  End; // If DirectoryExists(V_MainDir)
  //Else
  //  Result := TRUE;
End; // IsNotLocalDrive


end.
