unit CheckForExchComponents;

interface

Uses Classes, Dialogs, SysUtils, Windows;

Type
  TCheckedComponents = (ccCoreEnter1, ccToolkit, ccTradeCounter);

  //------------------------------

  // Generic interface for objects which implement a specific import type
  ICheckForRunningExchequerComponents = Interface
    ['{8D51F955-22AF-48A3-B44D-175E993B3362}']
    // --- Internal Methods to implement Public Properties ---
    Function GetComponentRunning (Index : TCheckedComponents) : Boolean;

    // ------------------ Public Properties ------------------
    Property ComponentRunning [Index : TCheckedComponents] : Boolean Read GetComponentRunning;

    // ------------------- Public Methods --------------------
    // Run through the list of running processes and the DLL's they have loaded
    // to work out which Exchequer components are in use
    Procedure CheckForComponents;
  End; // ICheckForRunningExchequerComponents

  //------------------------------

// Singleton to execute searches for running components and store the results
Function RunningExchequerComponents : ICheckForRunningExchequerComponents;

implementation

Uses TlHelp32; // Toolhelp API

Type
  TCheckForRunningExchequerComponents = Class(TInterfacedObject, ICheckForRunningExchequerComponents)
  Private
    FComponentRunning : Array [TCheckedComponents] of Boolean;
    Function GetComponentRunning (Index : TCheckedComponents) : Boolean;
    // Examine the module details to determine whether it is an Exchequer component we are interested in
    Function CheckModule (Const ModuleDetails : TModuleEntry32) : Boolean;

    // ICheckForRunningExchequerComponents methods

    // Run through the list of running processes and the DLL's they have loaded
    // to work out which Exchequer components are in use
    Procedure CheckForComponents;
  Public
    Constructor Create;
  End; // TCheckForRunningExchequerComponents

Var
  iRunningComponents : ICheckForRunningExchequerComponents;

//=========================================================================

// Singleton to execute searches for running components and store the results
Function RunningExchequerComponents : ICheckForRunningExchequerComponents;
Begin // RunningExchequerComponents
  If Not Assigned(iRunningComponents) Then
    iRunningComponents := TCheckForRunningExchequerComponents.Create;
  Result := iRunningComponents;
End; // RunningExchequerComponents

//=========================================================================

Constructor TCheckForRunningExchequerComponents.Create;
Var
  I : TCheckedComponents;
Begin // Create
  Inherited Create;

  // Initialise the running components to TRUE so if the check isn't performed
  // we assume they are in use
  For I := Low(FComponentRunning) To High(FComponentRunning) Do
    FComponentRunning[I] := True;
End; // Create

//-------------------------------------------------------------------------

Function TCheckForRunningExchequerComponents.GetComponentRunning (Index : TCheckedComponents) : Boolean;
Begin // GetComponentRunning
  Result := FComponentRunning[Index];
End; // GetComponentRunning

//-------------------------------------------------------------------------

// Examine the module details to determine whether it is an Exchequer component we are interested in
Function TCheckForRunningExchequerComponents.CheckModule (Const ModuleDetails : TModuleEntry32) : Boolean;
Var
  sModule : ShortString;
  I : TCheckedComponents;
Begin // CheckModule
  // Convert the module name to uppercase for comparison
  sModule := UpperCase(ModuleDetails.szModule);

  // Check for Exchequer components
  //
  // Note: It could be a long or short filename
  //
  If (sModule = 'ENTER1.EXE') Then
    FComponentRunning[ccCoreEnter1] := True
  // Toolkit components - not possible to work out whether the toolkit is backdoored or not, so
  // backdoored apps will be listed and prevent the user counts being reset
  Else If (sModule = 'ENTDLL32.DLL') Or (sModule = 'ENTTOOLK.DLL') Or (sModule = 'ENTTOOLK.EXE') Or (sModule = 'ENTFORMS.EXE') Then
    FComponentRunning[ccToolkit] := True
  // Trade Counter components
  Else If (sModule = 'POSSETUP.EXE') Or (sModule = 'TRADE.EXE') Then
    FComponentRunning[ccTradeCounter] := True;

  // Return TRUE if all components have been found so we can exit the list of modules early
  Result := True;
  For I := Low(FComponentRunning) To High(FComponentRunning) Do
  Begin
    If (Not FComponentRunning[I]) Then
    Begin
      Result := False;
      Break;
    End; // If (Not FComponentRunning[I])
  End; // For I
End; // CheckModule

//-------------------------------------------------------------------------

// Run through the list of running processes and the DLL's they have loaded
// to work out which Exchequer components are in use
Procedure TCheckForRunningExchequerComponents.CheckForComponents;
Var
  hProcessesSnapshot : THandle;
  ProcessDetails : TProcessEntry32;
  FoundProcess : BOOL;

  hModuleSnapshot : THandle;
  ModuleDetails : TModuleEntry32;
  FoundModule : BOOL;

  ExitLoop : Boolean;
Begin // CheckForComponents
  // Turn off all the Running Component flags before performing the checks 
  FillChar(FComponentRunning, SizeOf(FComponentRunning), #0);

  // Get a snapshot of the currently running processes
  hProcessesSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  Try
    // Run through the list of process in the snapshot retrieving the process details
    ProcessDetails.dwSize := SizeOf(ProcessDetails);
    FoundProcess := Process32First(hProcessesSnapshot, ProcessDetails);
    While FoundProcess Do
    Begin
      // For each process run through conponents loaded within the process - this will include the
      // .exe that caused the process so we don't need to look at the process details

      // Get a snapshot of the modules loaded within the process
      hModuleSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessDetails.th32ProcessID);
      Try
        // Run through the list of modules within the process - this will include .exe, .dll,
        // .ocx, .drv, etc...
        ExitLoop := False;
        ModuleDetails.dwSize := SizeOf(ModuleDetails);
        FoundModule := Module32First(hModuleSnapshot, ModuleDetails);
        While FoundModule And (Not ExitLoop) Do
        Begin
          // Check the module
          ExitLoop := CheckModule (ModuleDetails);

          // Get the next module details
          FoundModule := Module32Next(hModuleSnapshot, ModuleDetails);
        End; // While FoundModule And (Not ExitLoop)
      Finally
        CloseHandle(hModuleSnapshot);
      End; // Try..Finally

      // Get the next process details
      FoundProcess := Process32Next(hProcessesSnapshot, ProcessDetails);
    End; // While FoundProcess
  Finally
    // Release the snapshot
    CloseHandle(hProcessesSnapshot);
  End; // Try..Finally
End; // CheckForComponents

//=========================================================================

Initialization
  iRunningComponents := NIL;
Finalization
  iRunningComponents := NIL;
end.
