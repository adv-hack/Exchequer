{-----------------------------------------------------------------------------
 Unit Name: uDSRDeleteDir
 Author:    vmoura
 Purpose:
 History:

 special thread to delete files and remove directories
-----------------------------------------------------------------------------}
Unit uDSRDeleteDir;

Interface

Uses Classes;

Type
  {a thread to delete directories without compromise performance}
  TDSRDeleteDir = Class(TThread)
  Private
    fDir: String;
  Public
    Constructor Create(Const pDir: String);
    Destructor Destroy; Override;
    Procedure Execute; Override;
  End;

Implementation

Uses Sysutils,
  uCommon, uConsts;

{ TDSRDeleteDir }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRDeleteDir.Create(Const pDir: String);
Begin
  Inherited Create(False);
  FreeOnTerminate := True;
  Priority := tpLowest;
  fDir := pDir;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRDeleteDir.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura

  delete all files and the directory itself
-----------------------------------------------------------------------------}
Procedure TDSRDeleteDir.Execute;
Begin
  If fDir <> '' Then
  Begin
    {delete cis return files}
    If _DirExists(IncludeTrailingPathDelimiter(fDir) + cCISRETDIR) Then
    Try
      _DelDirFiles(IncludeTrailingPathDelimiter(fDir) + cCISRETDIR);
    Finally
      _DelDir(IncludeTrailingPathDelimiter(fDir) + cCISRETDIR);
    End;

    {delete inbox/outbox dir}
    Try
      _DelDirFiles(fDir);
    Finally
      _DelDir(fDir);
    End;
  End; {If fDir <> '' Then}

  Terminate;
End;

End.

