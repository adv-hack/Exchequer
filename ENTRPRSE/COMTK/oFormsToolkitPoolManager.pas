Unit oFormsToolkitPoolManager;

Interface

Uses Classes, DateUtils, SysUtils, COMObj, Windows, EnterpriseForms_TLB;

Type
  // Generic interface for objects which implement a specific import type
  IFormsToolkitPoolManager = Interface
    ['{29B55491-8009-4C5A-BA2A-55C6D5040CC8}']
    // --- Internal Methods to implement Public Properties ---
    // ------------------ Public Properties ------------------
    // ------------------- Public Methods --------------------

    // Returns an instance of the Forms Toolkit. It will either return an
    // available instance from the pool or create a new instance
    Function GetFormsToolkit : IEFPrintingToolkit;

    // Returns an instance that is no longer being used to the Pool
    Procedure ReturnToPool (Const FormsToolkit : IEFPrintingToolkit);

    // Removes any cached Forms Toolkit instances from the pool
    Procedure Flush;
  End; // IFormsToolkitPoolManager

  //------------------------------

// Returns a reference to the Forms Toolkit Pool Manager
Function FormsToolkitPoolManager : IFormsToolkitPoolManager;

// Flushes down the Forms Toolkit Pool Manager if it is running
Procedure FlushFormsToolkitPoolManager;

Implementation

Type
  TFormsToolkitPoolManager = Class(TInterfacedObject, IFormsToolkitPoolManager)
  Private
    FPool : TInterfaceList;

    // IFormsToolkitPoolManager

    // Returns an instance of the Forms Toolkit. It will either return an
    // available instance from the pool or create a new instance
    Function GetFormsToolkit : IEFPrintingToolkit;
    // Returns an instance that is no longer being used to the Pool
    Procedure ReturnToPool (Const FormsToolkit : IEFPrintingToolkit);
    // Removes any cached Forms Toolkit instances from the pool
    Procedure Flush;
  Public
    Constructor Create;
    Destructor Destroy; override;
  End; // TFormsToolkitPoolManager

  //------------------------------

Var
  FormsToolkitPoolManagerIntf : IFormsToolkitPoolManager;

//=========================================================================

Function FormsToolkitPoolManager : IFormsToolkitPoolManager;
Begin // FormsToolkitPoolManager
  If Not Assigned(FormsToolkitPoolManagerIntf) Then
    FormsToolkitPoolManagerIntf := TFormsToolkitPoolManager.Create;
  Result := FormsToolkitPoolManagerIntf;
End; // FormsToolkitPoolManager

//-------------------------------------------------------------------------

// Flushes down the Forms Toolkit Pool Manager if it is running
Procedure FlushFormsToolkitPoolManager;
Begin // FlushFormsToolkitPoolManager
  If Assigned(FormsToolkitPoolManagerIntf) Then
    FormsToolkitPoolManagerIntf.Flush;
End; // FlushFormsToolkitPoolManager

//=========================================================================

Constructor TFormsToolkitPoolManager.Create;
Begin // Create
  Inherited Create;

  FPool := TInterfaceList.Create;
End; // Create

//------------------------------

Destructor TFormsToolkitPoolManager.Destroy;
Begin // Destroy
  // Remove references to any Forms Toolkit instance in the pool, which should cause them to
  // automatically destroy, and then destroy the list
  FPool.Clear;
  FPool.Free;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Returns an instance of the Forms Toolkit. It will either return an
// available instance from the pool or create a new instance
Function TFormsToolkitPoolManager.GetFormsToolkit : IEFPrintingToolkit;
Var
  TimeOutTime : TDateTime;
  Bored : Boolean;
Begin // GetFormsToolkit
  If (FPool.Count > 0) Then
  Begin
    // Return the first entry in the pool and remove it from the pool
    Result := FPool.First As IEFPrintingToolkit;
    FPool.Remove(Result);
  End // If (FPool.Count > 0)
  Else
  Begin
    // Create and return a new Forms Toolkit instance
    Bored := False;
    TimeOutTime := IncSecond(Now, 10);  // Loop for 10 secs
    Repeat
      Try
        Result := CreateOleObject ('EnterpriseForms.PrintingToolkit') As IEFPrintingToolkit;
      Except
        Result := NIL;
      End; // Try..Except

      If (Result = Nil) Then
      Begin
        Bored := (Now > TimeOutTime);
        If (Not Bored) Then
          Sleep(10);
      End; // If (Result = Nil)
    Until Assigned(Result) Or Bored;
  End; // Else
End; // GetFormsToolkit

//-------------------------------------------------------------------------

// Returns an instance that is no longer being used to the Pool
Procedure TFormsToolkitPoolManager.ReturnToPool (Const FormsToolkit : IEFPrintingToolkit);
Var
  FormsToolkitMemoryUsage : Int64;
Begin // ReturnToPool
  // Due to unknown memory leaks somewhere in the Form Printing check how much memory
  // is being used and drop the instance if it is over a specific threshold
  FormsToolkitMemoryUsage := (FormsToolkit As IEFPrintingToolkit2).MemoryUsage;
  If (FormsToolkitMemoryUsage < 60000000) Then
  Begin
    // Call the reset method on the Forms Toolkit to re-initialise it and reduce its
    // memory footprint
    (FormsToolkit As IEFPrintingToolkit2).Reset;

    // Add it into the pool for future use
    FPool.Add (FormsToolkit);
  End; // If (FormsToolkitMemoryUsage < 40940000)
End; // ReturnToPool

//-------------------------------------------------------------------------

// Removes any cached Forms Toolkit instances from the pool
Procedure TFormsToolkitPoolManager.Flush;
Begin // Flush
  FPool.Clear;
End; // Flush

//=========================================================================

Initialization
  FormsToolkitPoolManagerIntf := NIL;
Finalization
  FormsToolkitPoolManagerIntf := NIL;
End.
