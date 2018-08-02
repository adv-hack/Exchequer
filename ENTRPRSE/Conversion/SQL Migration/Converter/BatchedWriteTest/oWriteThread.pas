unit oWriteThread;

{$WARN SYMBOL_PLATFORM OFF}

interface

Uses Classes, SysUtils, Windows, Messages, DateUtils, oConvertOptions, oDataPacket;

type
  // IWriteThreadPool provides access to the array of SQL Write Threads
  IWriteThreadPool = Interface
    ['{7C8F0B50-8DFB-41CF-8065-4813C211AA25}']
    // --- Internal Methods to implement Public Properties ---

    // ------------------ Public Properties ------------------

    // ------------------- Public Methods --------------------
    // Identifies the best a thread to add the data to and adds it
    Procedure QueueData (Const DataPacket : TDataPacket);

    // Returns TRUE if all the SQL Write Threads have completed, i.e. QueueCount = 0
    Function AllThreadsCompleted : Boolean;

    // Called from the Read Thread to destroy the Write threads once they are all suspended
    Procedure DestroyThreads;
  End; // IWriteThreadPool

  //------------------------------

// Returns a reference to the write thread pool
Function WriteThreadPool : IWriteThreadPool;

implementation

Uses ActiveX, ADODB, StrUtils, SyncObjs, LoggingUtils, oBaseDataWrite, psAPI, SQLConvertUtils;

//=========================================================================

Const
  // Default number of SQL Write Threads
  DefaultNumberOfThreads = 3;

  // Default minimum amount of Free Memory
  DefaultMinAvailableFreeMemory = 50 * 1024000;

Type
  TSQLWriteThread = class(TThread)
  Private
    FThreadDescr : ShortString;
    FCriticalSection : TCriticalSection;
    FDataPacketQueue : TList;

    FCurrentCompanyCode : ShortString;
    FCurrentTaskId : Integer;  // NOTE: Uses an Integer instead of a TDataConversionTasks so we can initialise it to an invalid Task Id
    FADOConnection : TADOConnection;
    FDataWrite : TBaseDataWrite;

    // Internal flags for monitoring performance
    FTotalPackets : Int64;
    FPeakQueue : Int64;

    Function GetQueueCount : Integer;

    Procedure ProcessDataPacket (Const DataPacket : TDataPacket);

    // Sleeps for 1 second - split out for Performance Profiling purposes
    procedure SleepPendingPackets;
    // Acquires the Write Thread's Critical Section to prevent multi-thread execution - split out for Performance Profiling purposes
    procedure AcquireCriticalSection;
    // Releases the Write Thread's Critical Section to re-enable multi-thread execution - split out for Performance Profiling purposes
    procedure ReleaseCriticalSection;
  protected
    procedure Execute; override;
  public
    Property ThreadDescription : ShortString Read FThreadDescr;

    // Returns TRUE id the thread is suspended [Thread Safe]
    // Returns the number of items within the thread's write queue [Thread Safe]
    Property QueueCount : Integer Read GetQueueCount;

    Constructor Create (Const ThreadDescr : ShortString);
    Destructor Destroy; Override;

    // Adds the data into this thread's queue
    Procedure QueueData (Const DataPacket : TDataPacket);
  End; // TSQLWriteThread

  //------------------------------

  TWriteThreadPool = Class(TInterfacedObject, IWriteThreadPool)
  Private
    FMaxMemoryLimit : Int64;
    FTotalQueuedItems : Int64;
    FCheckNextTime : Boolean;
    FTotalThreads : Integer;
    FWriteThreads : Array of TSQLWriteThread;

    Function GetNumberOfThreads : Int64;
    Function GetMaxMemoryUsageInMB : Int64;
  Protected
    // Identifies the best a thread to add the data to and adds it [Thread Safe]
    Procedure QueueData (Const DataPacket : TDataPacket);

    // Returns TRUE if all the SQL Write Threads have completed, i.e. QueueCount = 0
    Function AllThreadsCompleted : Boolean;
    // Called from the Read Thread to destroy the Write threads once they are all suspended
    Procedure DestroyThreads;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TWriteThreadPool

  //------------------------------

Var
  WriteThreadPoolObj : TWriteThreadPool;
  WriteThreadPoolIntf : IWriteThreadPool;

//=========================================================================

// Returns a reference to the write thread pool
Function WriteThreadPool : IWriteThreadPool;
Begin // WriteThreadPool
  If (Not Assigned(WriteThreadPoolObj)) Then
  Begin
    // Create the singleton Thread Pool object
    WriteThreadPoolObj := TWriteThreadPool.Create;
    WriteThreadPoolIntf := WriteThreadPoolObj;
  End; // If (Not Assigned(WriteThreadPoolObj))

  Result := WriteThreadPoolIntf
End; // WriteThreadPool

//=========================================================================

Constructor TWriteThreadPool.Create;
Var
  iThread : Integer;
Begin // Create
  Inherited Create;

  // Check the command line parameters for the number of threads to use
  FTotalThreads := GetNumberOfThreads;

  // Check the command line parameters for the amount of caching in the queue
  FMaxMemoryLimit := GetMaxMemoryUsageInMB * 1024000;

  Logging.DebugMessage ('TWriteThreadPool.Create ' + Logging.ThreadIdString, 'Write Thread Pool Created (' + IntToStr(FTotalThreads) + ' threads, Cache=' + IntToStr(FMaxMemoryLimit) + ')');

  // Dynamically size the thread array and create the threads
  SetLength (FWriteThreads, FTotalThreads);
  For iThread := Low (FWriteThreads) To High (FWriteThreads) Do
  Begin
    FWriteThreads[iThread] := TSQLWriteThread.Create ('SWT' + IntToStr(iThread+1));
  End; // For iThread

  FTotalQueuedItems := 0;
  FCheckNextTime := False;
End; // Create

//------------------------------

Destructor TWriteThreadPool.Destroy;
Begin // Destroy
  Logging.DebugMessage ('TWriteThreadPool.Destroy ' + Logging.ThreadIdString, 'TotalQueuedItems=' + IntToStr(FTotalQueuedItems));
  DestroyThreads;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TWriteThreadPool.GetNumberOfThreads : Int64;
Var
  sParams, sNumber : ShortString;
  I, iPos : Integer;
Begin // GetNumberOfThreads
  // Set default number of threads
  Result := DefaultNumberOfThreads;

  // Check for command line switch adjusting the number of threads
  sParams := CmdLine;
  iPos := Pos('/Threads:', sParams);
  If (iPos > 0) Then
  Begin
    // Run through the string and extract the number for conversion
    sNumber := '';
    For I := (iPos + 9) To Length(sParams) Do
    Begin
      If (sParams[I] In ['0'..'9']) Then
      Begin
        sNumber := sNumber + sParams[I];
      End // If (sParams[I] In ['0',,'9'])
      Else
        Break;
    End; // For I
    Result := StrToIntDef (sNumber, DefaultNumberOfThreads);
  End; // If (iPos > 0)

  // Sanity check the resulting number
  If (Result <= 0) Then
    Result := 1
  Else If (Result > 99) Then
    Result := 99;
End; // GetNumberOfThreads

//-------------------------------------------------------------------------

Function TWriteThreadPool.GetMaxMemoryUsageInMB : Int64;
Var
  sParams, sNumber : ShortString;
  I, iPos : Integer;
  DefaultMax : Int64;
Begin // GetMaxMemoryUsageInMB
  // Set default max amount of memory in MB to be used by the app to 50% of available memory
  DefaultMax := AvailableMemoryInBytes Div 2048000;  // Div 2 to half the available memory, Div 1024000 to convert Bytes to MB

  Result := DefaultMax;

  // Check for command line switch adjusting the cache size
  sParams := CmdLine;
  iPos := Pos('/MaxMemMB:', sParams);
  If (iPos > 0) Then
  Begin
    // Run through the string and extract the number for conversion
    sNumber := '';
    For I := (iPos + 10) To Length(sParams) Do
    Begin
      If (sParams[I] In ['0'..'9']) Then
      Begin
        sNumber := sNumber + sParams[I];
      End // If (sParams[I] In ['0',,'9'])
      Else
        Break;
    End; // For I
    Result := StrToIntDef (sNumber, DefaultMax);
  End; // If (iPos > 0)

  // Sanity check the resulting number
  If (Result < 50) Then
    Result := 50;

  // MH 28/08/2012 ABSEXCH-13346: Limit max memory to 1000Mb as WJ has experienced issues whenever running with more than that
  If (Result > 1000) Then
    Result := 1000;
End; // GetMaxMemoryUsageInMB

//-------------------------------------------------------------------------

// Returns TRUE if all the SQL Write Threads have completed, i.e. QueueCount = 0
Function TWriteThreadPool.AllThreadsCompleted : Boolean;
Var
  iThread : Integer;
Begin // AllThreadsCompleted
  iThread := -1;
  Result := True;
  Try
    For iThread := Low (FWriteThreads) To High (FWriteThreads) Do
    Begin
      // Check each threads status
      If (FWriteThreads[iThread].QueueCount > 0) Then
      Begin
        Result := False;
        Break;
      End; // If (FWriteThreads[iThread].QueueCount > 0)
    End; // For iThread
  Except
    On E:Exception Do
    Begin
      Logging.Exception ('TWriteThreadPool.AllThreadsCompleted ' + Logging.ThreadIdString, 'Checking Thread ' + IntToStr(iThread), E.Message);
      ConversionOptions.Abort('The following exception occurred in TWriteThreadPool.AllThreadsCompleted:- ' + QuotedStr(E.Message));
    End; // On E:Exception
  End; // Try..Except
End; // AllThreadsCompleted

//-------------------------------------------------------------------------

// Called from the Read Thread to destroy the Write threads once they are all suspended
Procedure TWriteThreadPool.DestroyThreads;
Var
  iThread : Integer;
Begin // DestroyThreads
  iThread := -1;
  Try
    // Destroy the Write Threads if they still exist - normally they should be shutdown
    // at the end of the data conversion section and will be NIL by now
    For iThread := Low (FWriteThreads) To High (FWriteThreads) Do
    Begin
      If Assigned(FWriteThreads[iThread]) Then
      Begin
        Logging.DebugMessage ('TWriteThreadPool.DestroyThreads ' + Logging.ThreadIdString, 'Destroying thread ' + FWriteThreads[iThread].ThreadDescription);

        FWriteThreads[iThread].FreeOnTerminate := True;
        FWriteThreads[iThread].Terminate;

        FWriteThreads[iThread] := NIL;
      End; // If Assigned(FWriteThreads[iThread])
    End; // For iThread

    // Eliminates compiler warning about iThread being undefined
    iThread := -2;
  Except
    On E:Exception Do
    Begin
      Logging.Exception ('TWriteThreadPool.DestroyThreads', 'Destroying Thread ' + IntToStr(iThread), E.Message);
      ConversionOptions.Abort('The following exception occurred in TWriteThreadPool.DestroyThreads:- ' + QuotedStr(E.Message));
    End; // On E:Exception
  End; // Try..Except
End; // DestroyThreads

//-------------------------------------------------------------------------

Procedure TWriteThreadPool.QueueData (Const DataPacket : TDataPacket);
Var
  iThread, iLowestThread, iQueuedItems, iThreadQueueCount : Integer;
  TotalAppMemory  : Int64;
  FreeMemory : LongWord;

  //------------------------------

  // Get the Working Set size from Windows
  Function GetWorkingSetSize: longint;
  Var
    pmc: TProcessMemoryCounters;
    cb: Integer;
  Begin // GetWorkingSetSize
    cb := SizeOf(pmc);
    pmc.cb := cb;
    if GetProcessMemoryInfo(GetCurrentProcess(), @pmc, cb) then
      Result:= Longint(pmc.WorkingSetSize)
    Else
      Result := 0;
  End; // GetWorkingSetSize

  //------------------------------

Begin // QueueData
  // NOTE: A critical section is not required as all items are either unchanging private/local vars
  //       or properties of the thread sub-objects which are protected with critical sections internally

  FTotalQueuedItems := FTotalQueuedItems + 1;

  // If there is only 1 thread then add it into that or if the task has to be run
  // sequentially within a single thread, e.g. ExchqSS because of the trigger, add
  // it into the first thread
  If (FTotalThreads = 1) Or DataPacket.TaskDetails.dctSingleThreadOnly Then
  Begin
    // 1 thread - use that one
    iLowestThread := Low(FWriteThreads);
  End // If (FTotalThreads = 1)
  Else
  Begin
    // Multiple threads - run through the array and identify the thread with the least queued items
    iLowestThread := -1;
    iQueuedItems := 0;
    For iThread := Low (FWriteThreads) To High (FWriteThreads) Do
    Begin
      // Copy the thread's queue count into a local variable to minimise CriticalSection usage within QueueCount
      iThreadQueueCount := FWriteThreads[iThread].QueueCount;
      If (iLowestThread = -1) Or (iThreadQueueCount < iQueuedItems) Then
      Begin
        iLowestThread := iThread;
        iQueuedItems := iThreadQueueCount;
      End; // If (iLowestThread = -1) Or (iThreadQueueCount < iQueuedItems)
    End; // For iThread
  End; // Else

  //------------------------------

  // Check the amount of free memory available to Windows - if it drops below a specified
  // threshold (Default = 50Mb) then pause until it rises above it - this is running in the
  // Read Thread so the Write Threads should be clearing down their Queue's whilst this is
  // paused.
  FreeMemory := AvailableMemoryInBytes;
  While (Not ConversionOptions.GlobalAbort) And (FreeMemory < DefaultMinAvailableFreeMemory) Do
  Begin
    // Post a message to the UI to inform the user - the UI will monitor the messages
    // and control the display to ensure the user isn't being continuously spammed
    PostMessage (ConversionOptions.hProgressTree, WM_LowMemoryWarning, 0, 0);

    // Sleep for 10 seconds to allow the Write Threads to free memory and the user to do something
    Sleep(10000);

    FreeMemory := AvailableMemoryInBytes;
  End; // While (Not ConversionOptions.GlobalAbort) And (FreeMemory < DefaultMinAvailableFreeMemory)

  //------------------------------

  // Check the amount of memory in use within the thread queues - delay if it exceeds specification
  TotalAppMemory := GetWorkingSetSize;
  While (Not ConversionOptions.GlobalAbort) And (TotalAppMemory > FMaxMemoryLimit) Do
  Begin
    // Max Cache exceeded - wait for 2 seconds to allow the Write threads time to do stuff - 1 second was found to be inadequate during testing
    Logging.DebugMessage ('TWriteThreadPool.QueueData ' + Logging.ThreadIdString, 'Sleeping - Max Mem Size Exceeded (' + IntToStr(TotalAppMemory) + '/' + IntToStr(FMaxMemoryLimit) + ')');
    Sleep(2000);
    TotalAppMemory := GetWorkingSetSize;
  End; // While (Not ConversionOptions.GlobalAbort) And (TotalAppMemory > FMaxMemoryLimit)

  //------------------------------

  // Add the task into the thread
  FWriteThreads[iLowestThread].QueueData(DataPacket);
End; // QueueData

//=========================================================================

Constructor TSQLWriteThread.Create (Const ThreadDescr : ShortString);
Begin // Create
  Inherited Create(True);  // Start suspended

  Logging.DebugMessage ('TSQLWriteThread.Create', 'Thread ' + ThreadDescr + ' created ' + Logging.ThreadIdString(Self.ThreadId));

  FreeOnTerminate := False;
  Priority := tpNormal;

  FThreadDescr := ThreadDescr;
  FCriticalSection := TCriticalSection.Create;
  FDataPacketQueue := TList.Create;

  // Internal flags for monitoring performance
  FTotalPackets := 0;
  FPeakQueue := 0;
End; // Create

//------------------------------

Destructor TSQLWriteThread.Destroy;
Var
  oDataPacket : TDataPacket;
Begin // Destroy
  // Destroy any outstanding Data Packet objects - this should only happen
  // if the conversion aborted or was aborted by the user
  If (FDataPacketQueue.Count > 0) Then
  Begin
    Logging.DebugMessage ('TSQLWriteThread.Destroy', 'Thread ' + FThreadDescr + ' - ' + IntToStr(FDataPacketQueue.Count) + ' Data Packets remaining in queue');

    While (FDataPacketQueue.Count > 0) Do
    Begin
      oDataPacket := TDataPacket(FDataPacketQueue.Items[0]);
      oDataPacket.Free;
      FDataPacketQueue.Delete(0);
    End; // While (FDataPacketQueue.Count > 0)
  End; // If (FDataPacketQueue.Count > 0)
  FDataPacketQueue.Free;

  FCriticalSection.Free;

  // Report internal flags for monitoring performance
  Logging.DebugMessage ('TSQLWriteThread.Destroy', 'Thread ' + FThreadDescr + ' - Total Packets=' + IntToStr(FTotalPackets) + ' ' + Logging.ThreadIdString(Self.ThreadId));
  Logging.DebugMessage ('TSQLWriteThread.Destroy', 'Thread ' + FThreadDescr + ' - Peak Queue=' + IntToStr(FPeakQueue) + ' ' + Logging.ThreadIdString(Self.ThreadId));

  Logging.DebugMessage ('TSQLWriteThread.Destroy', 'Thread ' + FThreadDescr + ' destroyed ' + Logging.ThreadIdString(Self.ThreadId));

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Sleeps for 1 second - split out for Performance Profiling purposes
procedure TSQLWriteThread.SleepPendingPackets;
Begin // SleepPendingPackets
  Sleep(1000);
End; // SleepPendingPackets

//------------------------------

// Acquires the Write Thread's Critical Section to prevent multi-thread execution - split out for Performance Profiling purposes
procedure TSQLWriteThread.AcquireCriticalSection;
Begin // AcquireCriticalSection
  FCriticalSection.Acquire;
End; // AcquireCriticalSection

//------------------------------

// Releases the Write Thread's Critical Section to re-enable multi-thread execution - split out for Performance Profiling purposes
procedure TSQLWriteThread.ReleaseCriticalSection;
Begin // ReleaseCriticalSection
  FCriticalSection.Release;
End; // ReleaseCriticalSection

//------------------------------

procedure TSQLWriteThread.Execute;
Var
  oDataPacket : TDataPacket;
Begin // Execute
  // Set here as referenced by Exception handler
  oDataPacket := NIL;
  Try
    // Need to initialise COM within the thread so we can use ADO
    CoInitialize(Nil);
    Try
      FADOConnection := NIL;
      FDataWrite := NIL;
      FCurrentCompanyCode := '';
      FCurrentTaskId := -1;

      Repeat
        // Don't technically need this - but I'm paranoid
        oDataPacket := NIL;

        // Use a critical section to control multi-threaded access to the Data Packet Queue and Memory Used property
        AcquireCriticalSection;
        Try
          // Check to see if there is anything on the Queue and that the user hasn't
          // aborted the conversion or that an error has occurred
          If (QueueCount > 0) Then
          Begin
            //Logging.DebugMessage ('TSQLWriteThread.Execute', 'Thread ' + FThreadDescr + ' Processing Packet (Queue=' + IntToStr(QueueCount) + ') ' + Logging.ThreadIdString(Self.ThreadId));

            // Pull a Data Packet object off the list for processing
            oDataPacket := TDataPacket(FDataPacketQueue.Items[0]);
            FDataPacketQueue.Delete(0);
          End; // If (QueueCount > 0)
        Finally
          ReleaseCriticalSection
        End; // Try..Finally

        If Assigned(oDataPacket) Then
        Begin
// Test Exception for logging test purposes
//Raise Exception.Create('+++Error At Address: 14, Treacle Mine Road, Ankh-Morpork+++');
          // Process the Data Packet outside of the critical section to avoid locking out QueueData
          ProcessDataPacket (oDataPacket);

          // MH 21/08/2013 PoC: Experimental mods to improve Insert performance by using a multiple value style insert
          If (FDataWrite.DataWriteType = dwtPrepared) Then
          Begin
            FreeAndNIL(oDataPacket);
          End; // If (FDataWrite.DataWriteType = dwtPrepared)
        End // If Assigned(oDataPacket)
        Else
        Begin
          // Nothing on the Queue - sleep
          //Logging.DebugMessage ('TSQLWriteThread.Execute', 'Thread ' + FThreadDescr + ' Sleeping ' + Logging.ThreadIdString(Self.ThreadId));
          SleepPendingPackets;
        End; // Else
      Until Terminated Or ConversionOptions.GlobalAbort;

      // Drop the current Data Write Object if it exists
      If Assigned(FDataWrite) Then
      Begin
        // Write any remaining data to the database
        If (Not ConversionOptions.GlobalAbort) Then
          FDataWrite.FlushInsert;
        FreeAndNIL(FDataWrite);
      End; // If Assigned(FDataWrite)

      // Drop the ADO Connection if it exists
      If Assigned(FADOConnection) Then
      Begin
        If FADOConnection.Connected Then
          FADOConnection.Close;
        FreeAndNIL(FADOConnection);
      End; // If Assigned(FADOConnection)

      // Log reason for ending loop
      If Terminated Then
        Logging.DebugMessage ('TSQLWriteThread.Execute', 'Thread ' + FThreadDescr + ' Terminated ' + Logging.ThreadIdString(Self.ThreadId))
      Else If ConversionOptions.GlobalAbort Then
        Logging.DebugMessage ('TSQLWriteThread.Execute', 'Thread ' + FThreadDescr + ' GlobalAbort Detected ' + Logging.ThreadIdString(Self.ThreadId));
    Finally
      CoUninitialize;
    End; // Try..Finally
  Except
    On E:Exception Do
    Begin
      ConversionOptions.Abort('The following exception occurred in TSQLWriteThread.Execute for thread ' + FThreadDescr + ':- ' + QuotedStr(E.Message));

      // If a data packet is available try to log the details of what we were processing
      If Assigned(oDataPacket) Then
        Logging.Exception ('TSQLWriteThread.Execute ' + FThreadDescr + ' ' + Logging.ThreadIdString(Self.ThreadId), oDataPacket.DumpToFile, E.Message)
      Else
        Logging.Exception ('TSQLWriteThread.Execute ' + FThreadDescr + ' ' + Logging.ThreadIdString(Self.ThreadId), '', E.Message);
    End; // On E:Exception
  End; // Try..Except
End; // Execute

//-------------------------------------------------------------------------

Procedure TSQLWriteThread.ProcessDataPacket (Const DataPacket : TDataPacket);
Const
  sCommonCompany = #255#255#255#255#255#255;
Var
  ConnectionString : AnsiString;
Begin // ProcessDataPacket
  Try
    // Check for changes in destination company
    If (DataPacket.TaskDetails.dctRootCompanyOnly And (FCurrentCompanyCode <> sCommonCompany))
       Or
       ((Not DataPacket.TaskDetails.dctRootCompanyOnly) And (FCurrentCompanyCode <> Trim(DataPacket.CompanyDetails.ccCompanyCode))) Then
    Begin
      Logging.DebugMessage ('TSQLWriteThread.ProcessDataPacket', 'Company Changed ' + FThreadDescr + ' ' + Logging.ThreadIdString(Self.ThreadId));

      // Drop the current Data Write Object first as it used the current ADO Connection
      If Assigned(FDataWrite) Then
      Begin
        // Write any remaining data to the database
        FDataWrite.FlushInsert;
        FreeAndNIL(FDataWrite);
      End; // If Assigned(FDataWrite)

      // Drop the current ADO Connection as it is linked to the old company
      If Assigned(FADOConnection) Then
      Begin
        If FADOConnection.Connected Then
          FADOConnection.Close;
        FreeAndNIL(FADOConnection);
      End; // If Assigned(FADOConnection)
    End; // If (DataPacket.TaskDetails.dctRootCompanyOnly And (FCurrentCompanyCode <> sCommonCompany)) Or ...

    // Check for changes in Task Type
    If Assigned(FDataWrite) And (Ord(DataPacket.TaskDetails.dctTaskId) <> FCurrentTaskId) Then
    Begin
      Logging.DebugMessage ('TSQLWriteThread.ProcessDataPacket', 'Task Changed ' + FThreadDescr + ' ' + Logging.ThreadIdString(Self.ThreadId));
      // Write any remaining data to the database
      FDataWrite.FlushInsert;
      FreeAndNIL(FDataWrite);
    End; // If Assigned(FDataWrite) And (Ord(DataPacket.TaskDetails.dctTaskId) <> FCurrentTaskId)

    // Create a new ADO Connection for the current destination company if required
    If (Not Assigned(FADOConnection)) Then
    Begin
      // Get Connection String
      If DataPacket.TaskDetails.dctRootCompanyOnly Then
      Begin
        // Get Common connection string
        FCurrentCompanyCode := sCommonCompany;
        ConnectionString := ConversionOptions.coCommonConnectionString;
      End // If DataPacket.TaskDetails.dctRootCompanyOnly
      Else
      Begin
        // Get Company specific connection string
        FCurrentCompanyCode := DataPacket.CompanyDetails.ccCompanyCode;
        ConnectionString := DataPacket.CompanyDetails.ccAdminConnectionString;
      End; // Else

      // Create and configure the connection string
      FADOConnection := TADOConnection.Create(nil);
      FADOConnection.ConnectionString := ConnectionString;
      FADOConnection.Open;
      If (FADOConnection.Errors.Count > 0) Then
      Begin
        Logging.DebugMessage ('TSQLWriteThread.ProcessDataPacket', 'ADO Connection Failed for thread ' + FThreadDescr + ' ' + Logging.ThreadIdString(Self.ThreadId));
        Raise Exception.Create ('ADO Connection Failed');
      End; // If (FADOConnection.Errors.Count > 0)
    End; // If (Not Assigned(FADOConnection))

    // Create a new Data Write object for the destination file/table
    If (Not Assigned(FDataWrite)) Then
    Begin
      FDataWrite := GetDataWriteObject (DataPacket.TaskDetails.dctTaskId);
      FDataWrite.Prepare (FADOConnection, DataPacket.CompanyDetails.ccCompanyCode);

      //Record the current Task ID so we can detect changes in task and drop/recreate the Data Write object
      FCurrentTaskId := Ord(DataPacket.TaskDetails.dctTaskId);
    End; // If (Not Assigned(FDataWrite))

    // Write the data to the MS SQL database
    FDataWrite.WriteData (DataPacket);

    // MH 21/08/2013 PoC: Experimental mods to improve Insert performance by using a multiple value style insert
    If (FDataWrite.DataWriteType = dwtPrepared) Then
    Begin
      // Mark task as complete
      DataPacket.TaskDetails.UpdateTotalWritten;
      If (DataPacket.TaskDetails.dctStatus = ctsComplete) Then
      Begin
        // Check to see if the Company Status should be changed
        DataPacket.CompanyDetails.CheckForCompletion;
      End; // If (DataPacket.TaskDetails.dctStatus = ctsComplete)
    End; // If (FDataWrite.DataWriteType = dwtPrepared)
  Except
    On E:Exception Do
    Begin
      ConversionOptions.Abort('The following exception occurred in TSQLWriteThread.ProcessDataPacket for thread ' + FThreadDescr + ':- ' + QuotedStr(E.Message));
      Logging.Exception ('TSQLWriteThread.ProcessDataPacket ' + FThreadDescr + ' ' + Logging.ThreadIdString(Self.ThreadId), DataPacket.DumpToFile, E.Message)
    End; // On E:Exception; // On E:Exception
  End; // Try..Except
End; // ProcessDataPacket

//-------------------------------------------------------------------------

// Adds the data into this thread's queue
Procedure TSQLWriteThread.QueueData (Const DataPacket : TDataPacket);
Begin // QueueData
  Try
    // Add the DataPacket into the thread's queue and update the total
    // memory used by the thread's queue
    AcquireCriticalSection;
    Try
      // Add the Data Packet into the queue for processing
      FDataPacketQueue.Add (DataPacket);

      // Update internal flags for monitoring performance
      FTotalPackets := FTotalPackets + 1;
      If (FDataPacketQueue.Count > FPeakQueue) Then
        FPeakQueue := FDataPacketQueue.Count;

      // Start the thread if required
      If Suspended Then
      Begin
        Logging.DebugMessage ('TSQLWriteThread.Execute', 'Thread ' + FThreadDescr + ' Resumed ' + Logging.ThreadIdString(Self.ThreadId));
        Resume;
      End; // If Suspended
    Finally
      ReleaseCriticalSection
    End; // Try..Finally
  Except
    On E:Exception Do
    Begin
      ConversionOptions.Abort('The following exception occurred in TSQLWriteThread.QueueData for thread ' + FThreadDescr + ':- ' + QuotedStr(E.Message));
      Logging.Exception ('TSQLWriteThread.QueueData ' + FThreadDescr + ' ' + Logging.ThreadIdString(Self.ThreadId), DataPacket.DumpToFile, E.Message)
    End; // On E:Exception; // On E:Exception
  End; // Try..Except
End; // QueueData

//-------------------------------------------------------------------------

Function TSQLWriteThread.GetQueueCount : Integer;
Begin // GetQueueCount
  AcquireCriticalSection;
  Try
    Result := FDataPacketQueue.Count;
  Finally
    ReleaseCriticalSection
  End; // Try..Finally
End; // GetQueueCount

//=========================================================================

Initialization
  WriteThreadPoolObj := NIL;
  WriteThreadPoolIntf := NIL;
Finalization
  WriteThreadPoolObj := NIL;
  WriteThreadPoolIntf := NIL;  // This should cause it to self-destruct if it still exists
End.
