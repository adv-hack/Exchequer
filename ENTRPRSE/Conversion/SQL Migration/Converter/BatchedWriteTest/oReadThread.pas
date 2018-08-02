unit oReadThread;

interface

Uses Classes, SysUtils, Windows, oConvertOptions;

type
  TBtrieveReadThread = class(TThread)
  Private
    FDataPacketCount : Int64;
    Procedure ReadBtrieveFile (Const oCompany : TConversionCompany; Const oTask : IDataConversionTask);
  protected
    procedure Execute; override;
  public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TBtrieveReadThread

implementation

Uses oGenericBtrieveFile, oDataPacket, oWriteThread, LoggingUtils;

Const
  sLoggingDescr = 'Btrieve Read Thread';

//=========================================================================

Constructor TBtrieveReadThread.Create;
Begin // Create
  Inherited Create(True);

  Logging.DebugMessage ('TBtrieveReadThread.Create', 'Thread Created ' + Logging.ThreadIdString(Self.ThreadId));

  FreeOnTerminate := False;
  Priority := tpNormal;

  FDataPacketCount := 0;
End; // Create

//------------------------------

Destructor TBtrieveReadThread.Destroy;
Begin // Destroy
  Logging.DebugMessage ('TBtrieveReadThread.Destroy', 'DataPacketCount=' + IntToStr(FDataPacketCount));
  Logging.DebugMessage ('TBtrieveReadThread.Destroy', 'Thread Destroyed ' + Logging.ThreadIdString(Self.ThreadId));

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

procedure TBtrieveReadThread.Execute;
Var
  oCompany : TConversionCompany;
  oTask : IDataConversionTask;
  iCompany, iTask : Integer;
  StartTime : TDateTime;
Begin // Execute
  // Log start time for elapsed time calculation
  StartTime := Now;

  Try
    // Run through the list of companies processing the tasks
    For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
    Begin
      oCompany := ConversionOptions.coCompanies[iCompany];
      Try
        Logging.DebugMessage ('TBtrieveReadThread.Execute ' + Logging.ThreadIdString, 'Processing Company ' + Trim(oCompany.ccCompanyCode) + ' - ' + Trim(oCompany.ccCompanyName));

        // Run through Company's Conversion Tasks adding them into the tree as children
        For iTask := 0 To (oCompany.ccConversionTaskCount - 1) Do
        Begin
          oTask := oCompany.ccConversionTasks[iTask];
          Try
            ReadBtrieveFile (oCompany, oTask);
          Finally
            oTask := NIL;
          End; // Try..Finally

          // Check global Abort flag
          If ConversionOptions.GlobalAbort Then
            Break;
        End; // For iTask
      Finally
        oCompany := NIL;
      End; // Try..Finally

      // Check global Abort flag
      If ConversionOptions.GlobalAbort Then
        Break;
    End; // For I

    // Wait until all the SQL Write thread queues are empty - this means that there are
    // no outstanding Data Packets and all the data has been written - or the GlobalAbort
    // flag is set indicating a non-recoverable error or User Abort
    Repeat
      Sleep(500);
    Until WriteThreadPool.AllThreadsCompleted Or ConversionOptions.GlobalAbort;
    WriteThreadPool.DestroyThreads;

    // Log Finish time for elapsed time calculation
    ConversionOptions.ElapsedDataConversionTime := Now - StartTime;

    // Post a message back to the progress window to indicate completion
    PostMessage (ConversionOptions.hProgressTree, WM_DataConversionFinished, 0, 0);
  Except
    On E:Exception Do
    Begin
      Logging.Exception ('TBtrieveReadThread.Execute', '', E.Message);
      ConversionOptions.Abort('The following exception occurred in TBtrieveReadThread.Execute:- ' + QuotedStr(E.Message));
    End; // On E:Exception
  End; // Try..Except
End; // Execute

//------------------------------

Procedure TBtrieveReadThread.ReadBtrieveFile (Const oCompany : TConversionCompany; Const oTask : IDataConversionTask);
Var
  oBtrieveDataFile : TGenericBtrieveFile;
  sFileName, sDumpFile : ShortString;
  Res, iRecCount : Integer;
Begin // ReadBtrieveFile
  Try
    // Calculate path of file - also used in error logging
    sFileName := IncludeTrailingPathDelimiter(Trim(oCompany.ccCompanyPath)) + oTask.dctPervasiveFilename;

    Logging.DebugMessage ('TBtrieveReadThread.ReadBtrieveFile ' + Logging.ThreadIdString, 'Processing Company Task ' + oTask.dctTaskDescription + ' (' + sFileName + ')');

// Test Exception for logging purposes
//Raise Exception.Create('+++Divide By Cucumber Error. Please Reinstall Universe And Reboot +++');

    oBtrieveDataFile := TGenericBtrieveFile.Create;
    Try
      // Open the source Btrieve file in read-only mode
      Res := oBtrieveDataFile.OpenFile (sFileName, False, 'V600', -2);
      If (Res = 0) Then
      Begin
        Try
          // Get total number of records and mark the task as in progress and set the data length for the generic code
          oCompany.StartTask;
          oTask.StartTask (oBtrieveDataFile.GetRecordCount, oBtrieveDataFile.GetRecordLength);
          Logging.DebugMessage ('TBtrieveReadThread.Execute ' + Logging.ThreadIdString, IntToStr(oTask.dctTotalRecords) + ' records found');

          If (oTask.dctTotalRecords > 0) Then
          Begin
{ TODO : remove this! }
// For testing purposes limit the data being processed to reduce testing times
//If True Then
If (oTask.dctTaskId In [
//                         dmtCompany, dmtCustSupp, dmtExchqSS, dmtExchqChk//, dmtExStkChk //, dmtMLocStk, dmtNominal, dmtStock}
//                         //dmtVATOpt, dmtVATPrd
//                         dmtUDEntity, dmtUDField, dmtUDItem
//                           dmtExchqNum
//                           dmtColSet, dmtParSet, dmtWinSet
//                          dmtGroupCmp, dmtGroups, dmtGroupUsr
//                          dmtPaprSize
//                          dmtQtyBreak
//                         dmtSettings
//                         dmtPPCust, dmtPPDebt, dmtPPSetup
//                           dmtCommssn, dmtSaleCode, dmtSCType
                        dmtHistory
//                        dmtDocument
                       ]) Then
Begin
            // NOTE: Defaults to Index 0 so we don't need to set it
            iRecCount := 0;

// Experimental mod for improving read performance
If (oTask.dctTaskId In [dmtCustSupp, dmtDocument, dmtDetails, dmtHistory, dmtJobHead, dmtNominal, dmtStock]) Then
  Res := oBtrieveDataFile.StepFirst
Else
  Res := oBtrieveDataFile.GetFirst;
            //Res := oBtrieveDataFile.GetFirst;

            // MH 28/08/2012: Use this instead to jump to a position reported in a DataPacket
            //Res := oBtrieveDataFile.RestorePosition (4142168);

            While (Res = 0) And (Not ConversionOptions.GlobalAbort) Do
            Begin
              // Package the record up in a DataPacket with ID info and use the SQL Write Thread Pool
              // object to select an appropriate SQL Write Thread and queue the data.
              // Also supply SearchKey and Position info to give greater options for tracking down problematic source data.
              WriteThreadPool.QueueData(TDataPacket.Create (oCompany, oTask, oBtrieveDataFile.RecordPointer, oBtrieveDataFile.SearchKey, oBtrieveDataFile.Position));

              // Increment the DataPacket count - the count is record here instead of within the DataPacket class/unit
              // as DataPackets can be duplicated from different threads for conversion warnings so it would then
              // require a critical section in order to be thread safe, etc...
              FDataPacketCount := FDataPacketCount + 1;

              // Update progress info - reduce updates to every 25 records from 1000 records as Write progress was
              // overtaking Read progress due to faster updating - looked a bit weird!
              iRecCount := iRecCount + 1;
              If (iRecCount = 1) Or ((iRecCount Mod 25) = 0) Then
              Begin
                oTask.UpdateReadProgress (iRecCount);
              End; // If (iRecCount = 1) Or ((iRecCount Mod 25) = 0)

              //PR: 06/09/2012 Some records in PaAuth.dat are 394 bytes, others are 494, so we need to
              //reset the record length to 494 before each call to avoid 22 being returned.
              if oTask.dctTaskID = dmtPAAuth then
                oBtrieveDataFile.DataRecLen := 494;

If (oTask.dctTaskId In [dmtCustSupp, dmtDocument, dmtDetails, dmtHistory, dmtJobHead, dmtNominal, dmtStock]) Then
  Res := oBtrieveDataFile.StepNext
Else
  Res := oBtrieveDataFile.GetNext;
              //Res := oBtrieveDataFile.GetNext;
            End; // While (Res = 0) And (Not ConversionOptions.GlobalAbort)
End // If (oTask.dctTaskId In [...
Else
Begin
  Res := 9;
  iRecCount := oTask.dctTotalRecords;
End; // Else

            // Check and log any unexpected database errors - Res should always be 9 - End of File
            If (Not ConversionOptions.GlobalAbort) And (Res <> 9) Then
            Begin
              // Unexpected Database Error - dump whatever we have got to file and report
              With TDataPacket.Create (oCompany, oTask, oBtrieveDataFile.RecordPointer, oBtrieveDataFile.SearchKey, oBtrieveDataFile.Position) Do
              Begin
                Try
                  sDumpFile := DumpToFile;
                Finally
                  Free;
                End; // Try..Finally
              End; // With TDataPacket.Create (...

              Logging.BtrieveError ('TBtrieveReadThread.ReadBtrieveFile', 'Reading Data - see ' + sDumpFile, Trim(oCompany.ccCompanyCode), sFileName, Res);
              ConversionOptions.Abort ('An error ' + IntToStr(Res) + ' was returning reading ' + oTask.dctPervasiveFilename + ' in company ' + Trim(oCompany.ccCompanyCode));
            End; // If (Not ConversionOptions.GlobalAbort) And (Res <> 9)

            // Mark read progress as complete
            oTask.UpdateReadProgress (oTask.dctTotalRecords);
            Logging.DebugMessage ('TBtrieveReadThread.Execute ' + Logging.ThreadIdString, IntToStr(iRecCount) + ' records Processed');
          End; // If (oTask.dctTotalRecords > 0)
        Finally
          // Close the Btrieve data file
          oBtrieveDataFile.CloseFile;
        End; // Try..Finally
      End // If (Res = 0)
      Else
      Begin
        // Error opening file
        Logging.BtrieveError ('TBtrieveReadThread.ReadBtrieveFile', 'Opening File', Trim(oCompany.ccCompanyCode), sFileName, Res);
        ConversionOptions.Abort ('An error ' + IntToStr(Res) + ' was returning opening ' + oTask.dctPervasiveFilename + ' in company ' + Trim(oCompany.ccCompanyCode));
      End; // Else
    Finally
      oBtrieveDataFile.Free;
    End; // Try..Finally
  Except
    On E:Exception Do
    Begin
      Logging.Exception ('TBtrieveReadThread.ReadBtrieveFile', 'Processing ' + sFileName, E.Message);
      ConversionOptions.Abort('The following exception occurred in TBtrieveReadThread.ReadBtrieveFile whilst processing ' + sFileName + ':- ' + QuotedStr(E.Message));
    End; // On E:Exception
  End; // Try..Except
End; // ReadBtrieveFile

//-------------------------------------------------------------------------

End.
