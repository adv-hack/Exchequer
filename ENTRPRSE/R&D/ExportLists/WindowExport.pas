Unit WindowExport;

Interface

Uses Classes, Forms, SysUtils, Messages, Windows;

Const
  // Constant posted to EParentU to refresh the List Export button
  WM_ReevaluateListExportStatus = WM_USER + $211;

Type
  TBooleanEvent = Function : Boolean of Object;
  TExecuteEvent = Procedure (Const CommandID : Integer; Const ProgressHWnd : HWnd) of Object;
  TStringEvent = Function : String of Object;

  //-----------------------------------

  TWindowExportCommand = Class(TObject)
  Private
    FCommandId : Integer;
    FCommandDescription : String;
  Public
    Property wecCommandId : Integer Read FCommandId Write FCommandId;
    Property wecCommandDescription : String Read FCommandDescription Write FCommandDescription;
  End; // TWindowExportCommand

  //-----------------------------------

  TWindowExport = Class(TComponent)
  Private
    FExportCommands : TList;

    FOnEnableExport : TBooleanEvent;
    FOnExecuteCommand : TExecuteEvent;
    FOnGetExportDescription : TStringEvent;

    Procedure ClearCommands;

    Function GetEnableExport : Boolean;

    Function GetExportCommandCount : Integer;
    Function GetExportCommand(Index:Integer) : TWindowExportCommand;
  Public
    Constructor Create (AOwner: TComponent); Override;
    Destructor Destroy; Override;

    // Called from the OnEnableExport event handler to add entries into the
    // ExportCommands array.
    Procedure AddExportCommand (Const CommandID : Integer; Const Command : String);

    Procedure ExecuteCommand (Const CommandID : Integer; Const ProgressHWnd : HWnd);

    // Posts a message to the main window to cause to to re-evaluate the enabled status
    // of the export button
    Procedure ReevaluateExportStatus;

    Property EnableExport : Boolean Read GetEnableExport;

    Property ExportCommandCount : Integer Read GetExportCommandCount;
    Property ExportCommands[Index: Integer] : TWindowExportCommand Read GetExportCommand;
  Published
    Property OnEnableExport : TBooleanEvent Read FOnEnableExport Write FOnEnableExport;
    Property OnExecuteCommand : TExecuteEvent Read FOnExecuteCommand Write FOnExecuteCommand;
    Property OnGetExportDescription : TStringEvent Read FOnGetExportDescription Write FOnGetExportDescription;
  End; // TWindowExport

procedure Register;

Implementation

//=========================================================================

procedure Register;
Begin // Register
  RegisterComponents('SBS', [TWindowExport]);
End; // Register

//=========================================================================

Constructor TWindowExport.Create (AOwner: TComponent);
Begin // Create
  Inherited Create(AOwner);

  FExportCommands := TList.Create;
End; // Create

Destructor TWindowExport.Destroy;
Begin // Destroy
  ClearCommands;
  FreeAndNIL(FExportCommands);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TWindowExport.ClearCommands;
Var
  WEC : TWindowExportCommand;
Begin // ClearCommands
  While (FExportCommands.Count > 0) Do
  Begin
    WEC := TWindowExportCommand(FExportCommands.Items[0]);
    WEC.Free;
    FExportCommands.Delete(0);
  End; // While (FExportCommands.Count > 0)
End; // ClearCommands

//-------------------------------------------------------------------------

Procedure TWindowExport.ExecuteCommand (Const CommandID : Integer; Const ProgressHWnd : HWnd);
Begin // ExecuteCommand
  If Assigned(FOnExecuteCommand) Then
    FOnExecuteCommand(CommandID, ProgressHWnd);
End; // ExecuteCommand

//-------------------------------------------------------------------------

// Posts a message to the main window to cause to to re-evaluate the enabled status
// of the export button
Procedure TWindowExport.ReevaluateExportStatus;
Begin // ReevaluateExportStatus
  PostMessage (Application.MainForm.Handle, WM_ReevaluateListExportStatus, 0, 0);
End; // ReevaluateExportStatus

//-------------------------------------------------------------------------

Function TWindowExport.GetEnableExport : Boolean;
Begin // GetEnableExport
  // Clear down the list of commands - it will be rebuilt in the event handler
  ClearCommands;

  // Call the event handler to determine whether an export is allowed
  If Assigned(FOnEnableExport) Then
    Result := FOnEnableExport
  Else
    Result := False;
End; // GetEnableExport

//-------------------------------------------------------------------------

Procedure TWindowExport.AddExportCommand (Const CommandID : Integer; Const Command : String);
Var
  WEC : TWindowExportCommand;
Begin // AddExportCommand
  WEC := TWindowExportCommand.Create;
  WEC.wecCommandId := CommandId;
  WEC.wecCommandDescription := Command;
  FExportCommands.Add(WEC);
End; // AddExportCommand

//-----------------------------------

Function TWindowExport.GetExportCommandCount : Integer;
Begin // GetExportCommandCount
  Result := FExportCommands.Count
End; // GetExportCommandCount

//-----------------------------------

Function TWindowExport.GetExportCommand(Index:Integer) : TWindowExportCommand;
Begin // GetExportCommand
  If (Index >= 0) And (Index < FExportCommands.Count) Then
    Result := TWindowExportCommand(FExportCommands.Items[Index])
  Else
    Raise Exception.Create ('TWindowExport.GetExportCommand: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FExportCommands.Count) + ')');
End; // GetExportCommand

//-------------------------------------------------------------------------

End.