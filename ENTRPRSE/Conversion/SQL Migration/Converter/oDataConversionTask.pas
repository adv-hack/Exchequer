Unit oDataConversionTask;

Interface

Uses oConvertOptions;

// Returns a new IDataConversionTask object for the specified TaskId
Function CreateDataConversionTask (Const TaskId : TDataConversionTasks) : IDataConversionTask;

Implementation

Uses SyncObjs;

Type
  TFileCompanyPresenceStatus = (fpRootOnly=0, fpAllCompanies=1);
  TFileOptionalStatus = (fosMandatory=0, fosOptional=1);
  TTaskThreadingStatus = (ttsAnyThread=0, ttsSingleThread=1);

  TDataConversionTask = Class(TInterfacedObject, IDataConversionTask)
  Private
    FTaskId : TDataConversionTasks;
    FPresenceStatus : TFileCompanyPresenceStatus;
    FOptionalStatus : TFileOptionalStatus;
    FThreadStatus : TTaskThreadingStatus;
    FPervasiveFilename : ShortString;
    FImportZIPFile : ShortString;

    // Progress properties
    FStatus : TDataConversionTaskStatus;
    FTotalRecords : Integer;
    FTotalRead : Integer;
    FTotalWritten : Integer;
    FRecordLength : Integer;

    Function GetTaskId : TDataConversionTasks;
    Function GetTaskDescription : ShortString;
    Function GetPervasiveFilename : ShortString;
    Function GetRootCompanyOnly : Boolean;
    Function GetSingleThreadOnly : Boolean;
    Function GetOptionalFile : Boolean;
    Function GetImportZIPFile : ShortString;
    Function GetRecordLength : Integer;

    Function GetStatus : TDataConversionTaskStatus;
    Function GetTotalRecords : Integer;
    Function GetTotalRead : Integer;
    Function GetTotalWritten : Integer;

    // Marks the task as 'In Progress' and initialises the total number of records to be converted
    Procedure StartTask (Const TotalRecords, RecordLength : Integer);
    // Updates dctTotalRead in a thread-safe manner
    Procedure UpdateReadProgress (Const TotalRecordsRead : Integer);
    // Increments the dctTotalWritten property in a thread-safe manner [Thread Safe]
    Procedure UpdateTotalWritten;
  Public
    Constructor Create (Const TaskId : TDataConversionTasks;
                        Const ThreadStatus : TTaskThreadingStatus;
                        Const PresenceStatus : TFileCompanyPresenceStatus;
                        Const OptionalStatus : TFileOptionalStatus;
                        Const PervasiveFilename : ShortString;
                        Const ImportZIPFile : ShortString = '');

  End; // TDataConversionTask

Var
  TaskCriticalSection : TCriticalSection;
{ TODO : Will making this local to the task improve performance? Probably not noticably as threads should be working on the same task mostly }

//=========================================================================

// Returns a new IDataConversionTask object for the specified TaskId
Function CreateDataConversionTask (Const TaskId : TDataConversionTasks) : IDataConversionTask;
Begin // DataConversionTasks
  Case TaskId Of
    // Root company only tables
    dmtCompany         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosMandatory, 'Company.Dat');
    dmtGroupCmp        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosMandatory, 'GroupCmp.Dat');
    dmtGroups          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosMandatory, 'Groups.Dat');
    dmtGroupUsr        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosMandatory, 'GroupUsr.Dat');
    dmtContact         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'Contact.Dat',           'Contact.zip');
    dmtEbus            : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'Ebus.Dat',              'eBusiness.zip');
    dmtEmpPay          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'JC\EmpPay.Dat',         'JobCard.zip');
    dmtFaxes           : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'FaxSrv\Faxes.Dat',      'FaxSvr.zip');
    dmtImportJob       : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'Misc\ImportJob.Dat',    'Importer.zip');
    dmtMCPay           : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'JC\MCPay.Dat',          'JobCard.zip');
    dmtPAAuth          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'Workflow\PAAuth.Dat',   'Authorise.zip');
    dmtPAComp          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'Workflow\PAComp.Dat',   'Authorise.zip');
    dmtPAEAR           : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'Workflow\PAEAR.Dat',    'Authorise.zip');
    dmtPAGlobal        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'Workflow\PAGlobal.Dat', 'Authorise.zip');
    dmtPAUser          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'Workflow\PAUser.Dat',   'Authorise.zip');
    dmtSchedCfg        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosMandatory, 'SchedCfg.Dat');
//    dmtSentSys         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'SentSys.Dat',           'Sentimail.zip');
    dmtTillName        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosOptional,  'Trade\TillName.Dat',    'TradeCounter.zip');
    dmtTools           : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpRootOnly,     fosMandatory, 'Tools.Dat');
    dmtCCDeptV         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'CCDeptV.Dat',           'CCDeptV.zip');
    dmtColSet          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\ColSet.Dat');
    dmtCommssn         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'SalesCom\Commssn.Dat',  'SalesCommission.zip');
    // MH 22/08/2012: CustomFields needs to run in a single thread so that it can clear down the rows automatically inserted on creation
    dmtCustomFields    : Result := TDataConversionTask.Create(TaskId, ttsSingleThread, fpAllCompanies, fosMandatory, 'Misc\CustomFields.Dat');
    dmtCurrencyHistory : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'CurrencyHistory.Dat');
    dmtCustSupp        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Cust\CustSupp.Dat');
    dmtDetails         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Trans\Details.Dat');
    dmtDocument        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Trans\Document.Dat');
    dmtEbusDetl        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Ebus\EbusDetl.Dat',     'eBusiness.zip');
    dmtEbusDoc         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Ebus\EbusDoc.Dat',      'eBusiness.zip');
    dmtEbusLkup        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Ebus\EbusLkup.Dat',     'eBusiness.zip');
    dmtEbusNote        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Ebus\EbusNote.Dat',     'eBusiness.zip');
    dmtExchqChk        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\ExchqChk.Dat');
    dmtExchqNum        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'ExchqNum.Dat');
    // MH: ExchqSS needs to run in a single thread as the Trigger causes SQL errors when run from multiple threads simultaneously
    dmtExchqSS         : Result := TDataConversionTask.Create(TaskId, ttsSingleThread, fpAllCompanies, fosMandatory, 'ExchqSS.Dat');
    dmtExStkChk        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\ExStkChk.Dat');
    dmtGLBudgetHistory : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Trans\GLBudgetHistory.Dat');
    dmtHistory         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Trans\History.Dat');
    dmtHistPurge       : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional, 'Trans\HistPrge.Dat');
    dmtJobCtrl         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Jobs\JobCtrl.Dat');
    dmtJobDet          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Jobs\JobDet.Dat');
    dmtJobHead         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Jobs\JobHead.Dat');
    dmtJobMisc         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Jobs\JobMisc.Dat');
    dmtLBin            : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Trade\LBin.Dat',        'TradeCounter.zip');
    dmtLHeader         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Trade\LHeader.Dat',     'TradeCounter.zip');
    dmtLLines          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Trade\LLines.Dat',      'TradeCounter.zip');
    dmtLSerial         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Trade\LSerial.Dat',     'TradeCounter.zip');
    dmtMLocStk         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Stock\MLocStk.Dat');
    dmtMultiBuy        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\MultiBuy.Dat');
    dmtNominal         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Trans\Nominal.Dat');
    dmtNomView         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Trans\NomView.Dat');
    dmtPaprSize        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Forms\PaprSize.Dat');
    dmtParSet          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\ParSet.Dat');
    dmtPPCust          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'PromPay\PPCust.Dat',    'PromptPayment.zip');
    dmtPPDebt          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'PromPay\PPDebt.Dat',    'PromptPayment.zip');
    dmtPPSetup         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'PromPay\PPSetup.Dat',   'PromptPayment.zip');
    dmtQtyBreak        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\QtyBreak.Dat',     'BlankQtyBreak.zip');
    dmtSaleCode        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'SalesCom\SaleCode.Dat', 'SalesCommission.zip');
    dmtSchedule        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Schedule\Schedule.Dat');
    dmtSCType          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'SalesCom\SCType.Dat',   'SalesCommission.zip');
    dmtSent            : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Smail\Sent.Dat',        'Sentimail.zip');
    dmtSentLine        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Smail\SentLine.Dat',    'Sentimail.zip');
    dmtSettings        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\Settings.Dat');
    dmtSortView        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\SortView.Dat');
    dmtStock           : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Stock\Stock.Dat');
    dmtSVUsrDef        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\SVUsrDef.Dat');
    // MH 26/01/2017 2017-R1 ABSEXCH-18202: Run the SystemSetup table through a single thread to ensure they are inserted in sysId order #OCD
    dmtSystemSetup     : Result := TDataConversionTask.Create(TaskId, ttsSingleThread, fpAllCompanies, fosMandatory, 'Misc\SystemSetup.Dat');
    dmtUDEntity        : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'UDEntity.Dat',          'UDFields.zip');
    dmtUDField         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'UDField.Dat',           'UDFields.zip');
    dmtUDItem          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'UDItem.Dat',            'UDFields.zip');
    dmtVat100          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\Vat100.Dat');
    dmtVatOpt          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'VatPer\VatOpt.Dat',     'VATPeriod.zip');
    dmtVatPrd          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'VatPer\VatPrd.Dat',     'VATPeriod.zip');
    dmtVRWSec          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Reports\VRWSec.Dat',    'VrwWrw.zip');
    dmtVRWTree         : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosOptional,  'Reports\VRWTree.Dat',   'VrwWrw.zip');
    dmtWinSet          : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\WinSet.Dat');
    // CJS 28/01/2014: AccountContact and AccountContactRole must be added sequentially, so use a single thread for them
    dmtAccountContact  : Result := TDataConversionTask.Create(TaskId, ttsSingleThread,    fpAllCompanies, fosMandatory, 'Cust\AccountContact.Dat');
    dmtAccountContactRole : Result := TDataConversionTask.Create(TaskId, ttsSingleThread, fpAllCompanies, fosMandatory, 'Cust\AccountContactRole.Dat');
    // MH 24/10/2014: Added support for new Order Payments fields
    dmtOrdPayVATPayments  : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Trans\OPVATPay.Dat');
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    dmtAnonymisationDiary : Result := TDataConversionTask.Create(TaskId, ttsAnyThread,    fpAllCompanies, fosMandatory, 'Misc\AnonymisationDiary.dat');
  Else
    Result := NIL;
  End; // Case TaskId
End; // DataConversionTasks

//=========================================================================

Constructor TDataConversionTask.Create (Const TaskId : TDataConversionTasks;
                                        Const ThreadStatus : TTaskThreadingStatus;
                                        Const PresenceStatus : TFileCompanyPresenceStatus;
                                        Const OptionalStatus : TFileOptionalStatus;
                                        Const PervasiveFilename : ShortString;
                                        Const ImportZIPFile : ShortString = '');
Begin // Create
  Inherited Create;

  FTaskId := TaskId;
  FPresenceStatus := PresenceStatus;
  FOptionalStatus := OptionalStatus;
  FThreadStatus := ThreadStatus;
  FPervasiveFilename := PervasiveFilename;
  FImportZIPFile := ImportZIPFile;

  FStatus := ctsNotStarted;
  FTotalRecords := 0;
  FTotalRead := 0;
  FTotalWritten := 0;
  FRecordLength := 0;
End; // Create

//-------------------------------------------------------------------------

// Marks the task as 'In Progress' and initialises the total number of records to be converted
Procedure TDataConversionTask.StartTask (Const TotalRecords, RecordLength : Integer);
Begin // StartTask
  TaskCriticalSection.Acquire;
  Try
    FRecordLength := RecordLength;

    FTotalRecords := TotalRecords;
    If (FTotalRecords > 0) Then
      FStatus := ctsInProgress
    Else
      FStatus := ctsComplete;
  Finally
    TaskCriticalSection.Release;
  End; // Try..Finally
End; // StartTask

//-------------------------------------------------------------------------

// Updates dctTotalRead in a thread-safe manner
Procedure TDataConversionTask.UpdateReadProgress (Const TotalRecordsRead : Integer);
Begin // UpdateReadProgress
  TaskCriticalSection.Acquire;
  Try
    FTotalRead := TotalRecordsRead;
  Finally
    TaskCriticalSection.Release;
  End; // Try..Finally
End; // UpdateReadProgress

//-------------------------------------------------------------------------

// Increments the dctTotalWritten property in a thread-safe manner [Thread Safe]
Procedure TDataConversionTask.UpdateTotalWritten;
Begin // UpdateTotalWritten
  TaskCriticalSection.Acquire;
  Try
    FTotalWritten := FTotalWritten + 1;

    // If we reach the total number of records in the original source file then mark the job as complete
    If (FTotalWritten >= FTotalRecords) Then
      FStatus := ctsComplete;
  Finally
    TaskCriticalSection.Release;
  End; // Try..Finally
End; // UpdateTotalWritten

//-------------------------------------------------------------------------

Function TDataConversionTask.GetTaskId : TDataConversionTasks;
Begin // GetTaskId
  Result := FTaskId;
End; // GetTaskId

//------------------------------

Function TDataConversionTask.GetTaskDescription : ShortString;
Begin // GetTaskDescription
  // For now just return the Pervasive Filename
  Result := FPervasiveFilename;
End; // GetTaskDescription

//------------------------------

Function TDataConversionTask.GetPervasiveFilename : ShortString;
Begin // GetPervasiveFilename
  Result := FPervasiveFilename;
End; // GetPervasiveFilename

//------------------------------

Function TDataConversionTask.GetRootCompanyOnly : Boolean;
Begin // GetRootCompanyOnly
  Result := (FPresenceStatus = fpRootOnly);
End; // GetRootCompanyOnly

//------------------------------

Function TDataConversionTask.GetSingleThreadOnly : Boolean;
Begin // GetSingleThreadOnly
  Result := (FThreadStatus = ttsSingleThread);
End; // GetSingleThreadOnly

//------------------------------

Function TDataConversionTask.GetOptionalFile : Boolean;
Begin // GetOptionalFile
  Result := (FOptionalStatus = fosOptional);
End; // GetOptionalFile

//------------------------------

Function TDataConversionTask.GetImportZIPFile : ShortString;
Begin // GetImportZIPFile
  Result := FImportZIPFile;
End; // GetImportZIPFile

//------------------------------

Function TDataConversionTask.GetRecordLength : Integer;
Begin // GetRecordLength
  Result := FRecordLength;
End; // GetRecordLength

//------------------------------

Function TDataConversionTask.GetStatus : TDataConversionTaskStatus;
Begin // GetStatus
  TaskCriticalSection.Acquire;
  Try
    Result := FStatus;
  Finally
    TaskCriticalSection.Release;
  End; // Try..Finally
End; // GetStatus

//------------------------------

Function TDataConversionTask.GetTotalRecords : Integer;
Begin // GetTotalRecords
  TaskCriticalSection.Acquire;
  Try
    Result := FTotalRecords;
  Finally
    TaskCriticalSection.Release;
  End; // Try..Finally
End; // GetTotalRecords

//------------------------------

Function TDataConversionTask.GetTotalRead : Integer;
Begin // GetTotalRead
  TaskCriticalSection.Acquire;
  Try
    Result := FTotalRead
  Finally
    TaskCriticalSection.Release;
  End; // Try..Finally
End; // GetTotalRead

//------------------------------

Function TDataConversionTask.GetTotalWritten : Integer;
Begin // GetTotalWritten
  TaskCriticalSection.Acquire;
  Try
    Result := FTotalWritten
  Finally
    TaskCriticalSection.Release;
  End; // Try..Finally
End; // GetTotalWritten

//-------------------------------------------------------------------------

Initialization
  TaskCriticalSection := TCriticalSection.Create;
Finalization
  TaskCriticalSection.Free;
End.
