Unit oBaseDataWrite;

Interface

Uses ADODB, Classes, SysUtils, oConvertOptions, oDataPacket;

Const
  DefaultMultiValuePacketThreshold = 100;

Type
  // MH 21/08/2013 PoC: Experimental mods to improve Insert performance by using a multiple value style insert
  TDataWriteType = (dwtPrepared, dwtMultiValue);

  //------------------------------

  // Base class for the data specific Data Write Objects
  TBaseDataWrite = Class(TObject)
  Private
    // MH 21/08/2013 PoC: Experimental mods to improve Insert performance by using a multiple value style insert
    FType : TDataWriteType;
    FPrepared : Boolean;

    Function GetDataWriteType : TDataWriteType;
  Protected
    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Virtual; Abstract;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // MH 21/08/2013 PoC: Experimental mods to improve Insert performance by using a multiple value style insert
    Property DataWriteType : TDataWriteType Read GetDataWriteType;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Virtual;
    // Called from the SQL Write Threads to write the Data Packet to the SQL Database
    Procedure WriteData (Const DataPacket : TDataPacket); Virtual;
    // Called from the write threads prior to desctruction to allow any data to be written
    Procedure FlushInsert; Virtual;
  End; // TBaseDataWrite

  //------------------------------

  TMultiValueDataWrite = Class(TBaseDataWrite)
  Private
    FCompanyCode : ShortString;
    // Stores the list of data packets being inserted by the next Multi-Value Insert call
    FDataPacketList : TList;
    Procedure ClearDataPacketList (Const MarkAsComplete : Boolean);
  Protected
    FADOQuery : TADOQuery;
    FSQLQuery : ANSIString;

    // Implemented in descendants to setup the basic 'Insert Into ...' part of the query
    Procedure InitialiseInsert; Virtual; Abstract;
    // Implemented in descendants to append the data values to the existing Insert statement
    Procedure AppendToInsert (Const DataPacket : TDataPacket; Const FirstPacket : Boolean); Virtual; Abstract;
    // Override in descendants which need to be able to skip obsolete records, e.g. Variant files
    Function WantDataPacket(Const DataPacket : TDataPacket) : Boolean; Virtual;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;
    // Called from the SQL Write Threads to write the Data Packet to the SQL Database
    Procedure WriteData (Const DataPacket : TDataPacket); Override;
    // Called from the write threads prior to destruction to allow any data to be written
    Procedure FlushInsert; Override;
  End; // TMultiValueDataWrite


Function GetDataWriteObject (Const ConversionTask : TDataConversionTasks) : TBaseDataWrite;

Implementation

Uses LoggingUtils, DataConversionWarnings, oCompanyDataWrite, oCustSuppDataWrite,
     oExchqSSDataWrite, oExchqChkDataWrite, oExStkChkDataWrite, oMLocStkDataWrite,
     oNominalDataWrite, oStockDataWrite, oVATOptDataWrite, oVATPrdDataWrite,
     oUDEntityDataWrite, oUDFieldDataWrite, oUDItemDataWrite,
     oColSetDataWrite, oParSetDataWrite, oWinSetDataWrite,
     oGroupsDataWrite, oGroupCmpDataWrite, oGroupUsrDataWrite,
     oExchqNumDataWrite, oPaprSizeDataWrite, oJobHeadDataWrite, oJobCtrlDataWrite,
     oQtyBreakDataWrite, oJobDetDataWrite, oJobMiscDataWrite, oMultiBuyDataWrite,
//   oHistoryDataWrite,
     oHistoryMultiValueDataWrite,
     oCustomFieldsDataWrite, oDocumentDataWrite,
     oDetailsDataWrite, oEbusDataWrite, oEbusDocDataWrite, oEbusDetlDataWrite,
     oEbusLkupDataWrite, oNomViewDataWrite, oEbusNoteDataWrite, oToolsDataWrite,
     oLBinDataWrite, oLHeaderDataWrite, oFaxesDataWrite, oImportJobDataWrite,
     oLLinesDataWrite, oLSerialDataWrite, oTillNameDataWrite, oSortViewDataWrite,
     oSettingsDataWrite, oPaAuthDataWrite, oPaCompDataWrite, oPaEArDataWrite,
     oPaGlobalDataWrite, oPaUserDataWrite, oSVUserDefDataWrite, oPPCustDataWrite,
     oPPDebtDataWrite, oPPSetupDataWrite, oSchedCFGDataWrite, oScheduleDataWrite,
     oContactDataWrite, oCCDeptVDataWrite, oCommssnDataWrite, oSCTypeDataWrite,
     oSaleCodeDataWrite, oVRWSecDataWrite, oVRWTreeDataWrite, oSentDataWrite,
     oSentLineDataWrite, oEmpPayDataWrite, oMCPayDataWrite, oCurrencyHistoryDataWrite,
     oGLBudgetHistoryDataWrite;

//=========================================================================

Function GetDataWriteObject (Const ConversionTask : TDataConversionTasks) : TBaseDataWrite;
Begin // GetDataWriteObject
  Case ConversionTask Of
    dmtCompany         : Result := TCompanyDataWrite.Create;      // Company.Dat
    dmtGroupCmp        : Result := TGroupCmpDataWrite.Create;     // GroupCmp.Dat
    dmtGroups          : Result := TGroupsDataWrite.Create;       // Groups.Dat
    dmtGroupUsr        : Result := TGroupUsrDataWrite.Create;     // GroupUsr.Dat
    dmtContact         : Result := TContactDataWrite.Create;      // Contact.Dat
    dmtEbus            : Result := TEbusDataWrite.Create;         // Ebus.Dat
    dmtEmpPay          : Result := TEmpPayDataWrite.Create;    // JC\EmpPay.Dat
    dmtFaxes           : Result := TFaxesDataWrite.Create;        // FaxSrv\Faxes.Dat
    dmtImportJob       : Result := TImportJobDataWrite.Create;    // Misc\ImportJob.Dat
    dmtMCPay           : Result := TMCPayDataWrite.Create;    // JC\MCPay.Dat
    dmtPAAuth          : Result := TPaAuthDataWrite.Create;       // Workflow\PAAuth.Dat
    dmtPAComp          : Result := TPaCompDataWrite.Create;       // Workflow\PAComp.Dat
    dmtPAEAR           : Result := TPaEArDataWrite.Create;        // Workflow\PAEAR.Dat
    dmtPAGlobal        : Result := TPaGlobalDataWrite.Create;     // Workflow\PAGlobal.Dat
    dmtPAUser          : Result := TPaUserDataWrite.Create;       // Workflow\PAUser.Dat
    dmtSchedCfg        : Result := TSchedCFGDataWrite.Create;     // SchedCfg.Dat
//    dmtSentSys         : Result := T???.Create;    // SentSys.Dat
    dmtTillName        : Result := TTillNameDataWrite.Create;     // Trade\TillName.Dat
    dmtTools           : Result := TToolsDataWrite.Create;        // Tools.Dat
    dmtCCDeptV         : Result := TCCDeptVDataWrite.Create;      // CCDeptV.Dat
    dmtColSet          : Result := TColSetDataWrite.Create;       // Misc\ColSet.Dat
    dmtCommssn         : Result := TCommssnDataWrite.Create;      // SalesCom\Commssn.Dat
    dmtCustomFields    : Result := TCustomFieldsDataWrite.Create; // Misc\CustomFields.Dat
    dmtCurrencyHistory : Result := TCurrencyHistoryDataWrite.Create;   // CurrencyHistory.Dat
    dmtCustSupp        : Result := TCustSuppDataWrite.Create;     // Cust\CustSupp.Dat
    dmtDetails         : Result := TDetailsDataWrite.Create;      // Trans\Details.Dat
    dmtDocument        : Result := TDocumentDataWrite.Create;     // Trans\Document.Dat
    dmtEbusDetl        : Result := TEbusDetlDataWrite.Create;     // Ebus\EbusDetl.Dat
    dmtEbusDoc         : Result := TEbusDocDataWrite.Create;      // Ebus\EbusDoc.Dat
    dmtEbusLkup        : Result := TEbusLKUpDataWrite.Create;     // Ebus\EbusLkup.Dat
    dmtEbusNote        : Result := TEbusNoteDataWrite.Create;     // Ebus\EbusNote.Dat
    dmtExchqChk        : Result := TExchqChkDataWrite.Create;     // Misc\ExchqChk.Dat
    dmtExchqNum        : Result := TExchqNumDataWrite.Create;     // ExchqNum.Dat
    dmtExchqSS         : Result := TExchqSSDataWrite.Create;      // ExchqSS.Dat
    dmtExStkChk        : Result := TExStkChkDataWrite.Create;     // Misc\ExStkChk.Dat
    dmtGLBudgetHistory : Result := TGLBudgetHistoryDataWrite.Create;   // GLBudgetHistory.Dat
    dmtHistory         : Result := THistoryDataWrite.Create;      // Trans\History.Dat
    dmtHistPurge       : Result := THistoryDataWrite.CreateForPurge;    // Trans\HistPrge.Dat
    dmtJobCtrl         : Result := TJobCtrlDataWrite.Create;      // Jobs\JobCtrl.Dat
    dmtJobDet          : Result := TJobDetDataWrite.Create;       // Jobs\JobDet.Dat
    dmtJobHead         : Result := TJobHeadDataWrite.Create;      // Jobs\JobHead.Dat
    dmtJobMisc         : Result := TJobMiscDataWrite.Create;      // Jobs\JobMisc.Dat
    dmtLBin            : Result := TLBinDataWrite.Create;         // Trade\LBin.Dat
    dmtLHeader         : Result := TLHeaderDataWrite.Create;      // Trade\LHeader.Dat
    dmtLLines          : Result := TLLinesDataWrite.Create;       // Trade\LLines.Dat
    dmtLSerial         : Result := TLSerialDataWrite.Create;      // Trade\LSerial.Dat
    dmtMLocStk         : Result := TMLocStkDataWrite.Create;      // Stock\MLocStk.Dat
    dmtMultiBuy        : Result := TMultiBuyDataWrite.Create;     // Misc\MultiBuy.Dat
    dmtNominal         : Result := TNominalDataWrite.Create;      // Trans\Nominal.Dat
    dmtNomView         : Result := TNomViewDataWrite.Create;      // Trans\NomView.Dat
    dmtPaprSize        : Result := TPaprSizeDataWrite.Create;     // Forms\PaprSize.Dat
    dmtParSet          : Result := TParSetDataWrite.Create;       // Misc\ParSet.Dat
    dmtPPCust          : Result := TPPCustDataWrite.Create;       // PromPay\PPCust.Dat
    dmtPPDebt          : Result := TPPDebtDataWrite.Create;       // PromPay\PPDebt.Dat
    dmtPPSetup         : Result := TPPSetupDataWrite.Create;      // PromPay\PPSetup.Dat
    dmtQtyBreak        : Result := TQtyBreakDataWrite.Create;     // Misc\QtyBreak.Dat
    dmtSaleCode        : Result := TSaleCodeDataWrite.Create;     // SalesCom\SaleCode.Dat
    dmtSchedule        : Result := TScheduleDataWrite.Create;     // Schedule\Schedule.Dat
    dmtSCType          : Result := TSCTypeDataWrite.Create;       // SalesCom\SCType.Dat
    dmtSent            : Result := TSentDataWrite.Create;    // Smail\Sent.Dat
    dmtSentLine        : Result := TSentLineDataWrite.Create;    // Smail\SentLine.Dat
    dmtSettings        : Result := TSettingsDataWrite.Create;     // Misc\Settings.Dat
    dmtSortView        : Result := TSortViewDataWrite.Create;     // Misc\SortView.Dat
    dmtStock           : Result := TStockDataWrite.Create;        // Stock\Stock.Dat
    dmtSVUsrDef        : Result := TSVUserDefDataWrite.Create;    // Misc\SVUsrDef.Dat
    dmtUDEntity        : Result := TUDEntityDataWrite.Create;     // UDEntity.Dat
    dmtUDField         : Result := TUDFieldDataWrite.Create;      // UDField.Dat
    dmtUDItem          : Result := TUDItemDataWrite.Create;       // UDItem.Dat
    dmtVatOpt          : Result := TVATOptDataWrite.Create;       // VatPer\VatOpt.Dat
    dmtVatPrd          : Result := TVATPrdDataWrite.Create;       // VatPer\VatPrd.Dat
    dmtVRWSec          : Result := TVRWSecDataWrite.Create;    // Reports\VRWSec.Dat
    dmtVRWTree         : Result := TVRWTreeDataWrite.Create;    // Reports\VRWTree.Dat
    dmtWinSet          : Result := TWinSetDataWrite.Create;       // Misc\WinSet.Dat
  Else
    ConversionOptions.Abort ('GetDataWriteObject - Unhandled ConversionTask (' + IntToStr(Ord(ConversionTask)) + ')');
    Raise Exception.Create ('GetDataWriteObject - Unhandled ConversionTask (' + IntToStr(Ord(ConversionTask)) + ')');
  End; // Case ConversionTask
End; // GetDataWriteObject

//=========================================================================

Constructor TBaseDataWrite.Create;
Begin // Create
  Inherited Create;

  FPrepared := False;
  FType := dwtPrepared;
End; // Create

//------------------------------

Destructor TBaseDataWrite.Destroy;
Begin // Destroy
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TBaseDataWrite.GetDataWriteType : TDataWriteType;
Begin // GetDataWriteType
  Result := FType;
End; // GetDataWriteType

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TBaseDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  // Called from descendants
End; // Prepare

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to write the Data Packet to the SQL Database
Procedure TBaseDataWrite.WriteData (Const DataPacket : TDataPacket);
Var
  ADOQuery : TADOQuery;
  SkipRecord : Boolean;
  iError, Res : Integer;
  sDumpFile : ShortString;
Begin // WriteData
  ADOQuery := NIL;
  Try
    // Populate the prepared query with the data from this DataPacket and retrieve
    // the ADOQuery instance (which for Variant files requires the RecPfix/SubType
    SkipRecord := False;
    SetQueryValues (ADOQuery, DataPacket, SkipRecord);

    // Crash out if we don't have a valid ADO connection - shouldn't happen
    If (Not SkipRecord) And (Not Assigned(ADOQuery)) Then
      Raise Exception.Create ('ADOQuery=NIL');
  Except
    On E:Exception Do
    begin
      // Log error and continue conversion
      SkipRecord := True;
      sDumpFile := DataPacket.DumpToFile;
      If Assigned(ADOQuery) Then
        ConversionWarnings.AddWarning(TSQLExecutionExceptionWarning.Create (DataPacket, sDumpFile, ADOQuery.SQL.Text, E.Message))
      Else
        ConversionWarnings.AddWarning(TSQLExecutionExceptionWarning.Create (DataPacket, sDumpFile, 'ADOQuery=NIL', E.Message));
      Logging.Exception ('TBaseDataWrite.WriteData ' + Logging.ThreadIdString, 'Populating Query Values - ' + sDumpFile, E.Message)
    end;
  End; // Try..Except

  // Execute the Insert/Update query
  If (Not SkipRecord) And Assigned(ADOQuery) Then
  Begin
    Try
      Res := ADOQuery.ExecSQL;
      If (Res <> 1) Or (ADOQuery.Connection.Errors.Count > 0) Then
      Begin
        // Log error and continue conversion
        sDumpFile := DataPacket.DumpToFile;
        ConversionWarnings.AddWarning(TSQLExecutionErrorWarning.Create (DataPacket, sDumpFile, ADOQuery.SQL.Text, Res, ADOQuery.Connection));
        Logging.SQLError ('TBaseDataWrite.WriteData ' + Logging.ThreadIdString, ADOQuery.SQL.Text, sDumpFile, Res, ADOQuery.Connection);
      End; // If (Res <> 1) Or (ADOQuery.Connection.Errors.Count > 0)
    Except
      On E:Exception Do
      begin
        // Log error and continue conversion
        sDumpFile := DataPacket.DumpToFile;
        ConversionWarnings.AddWarning(TSQLExecutionExceptionWarning.Create (DataPacket, sDumpFile, ADOQuery.SQL.Text, E.Message));
        Logging.SQLException ('TBaseDataWrite.WriteData ' + Logging.ThreadIdString, ADOQuery.SQL.Text, sDumpFile, E.Message)
      end;
    End; // Try..Except
  End; // If (Not SkipRecord) And Assigned(ADOQuery)
End; // WriteData

//-------------------------------------------------------------------------

// Called from the write threads prior to desctruction to allow any data to be written
Procedure TBaseDataWrite.FlushInsert;
Begin // FlushInsert
  // No action required for the based prepared insert
End; // FlushInsert

//=========================================================================

Constructor TMultiValueDataWrite.Create;
Begin // Create
  Inherited Create;

  FADOQuery := TADOQuery.Create(NIL);
  FDataPacketList := TList.Create;
  FType := dwtMultiValue;
  FSqlQuery := '';
End; // Create

//------------------------------

Destructor TMultiValueDataWrite.Destroy;
Begin // Destroy
  ClearDataPacketList (False);
  FreeAndNIL(FDataPacketList);
  FreeAndNIL(FADOQuery);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TMultiValueDataWrite.ClearDataPacketList (Const MarkAsComplete : Boolean);
Var
  oDataPacket : TDataPacket;
Begin // ClearDataPacketList
  While (FDataPacketList.Count > 0) Do
  Begin
    oDataPacket := TDataPacket(FDataPacketList.Items[0]);

    If MarkAsComplete Then
    Begin
      // Mark task as complete
      oDataPacket.TaskDetails.UpdateTotalWritten;

      // For the last Data Packet update the Company level status
      If (FDataPacketList.Count = 1) And (oDataPacket.TaskDetails.dctStatus = ctsComplete) Then
      Begin
        // Check to see if the Company Status should be changed
        oDataPacket.CompanyDetails.CheckForCompletion;
      End; // If (DataPacket.TaskDetails.dctStatus = ctsComplete)
    End; // If MarkAsComplete

    oDataPacket.Free;
    FDataPacketList.Delete(0);
  End; // While (FDataPacketList.Count > 0)
End; // ClearDataPacketList

//-------------------------------------------------------------------------

Procedure TMultiValueDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  FCompanyCode := CompanyCode;
End; // Prepare

//-------------------------------------------------------------------------

// Override in descendants which need to be able to skip obsolete records, e.g. Variant files
Function TMultiValueDataWrite.WantDataPacket(Const DataPacket : TDataPacket) : Boolean;
Begin // WantDataPacket
  Result := True;
End; // WantDataPacket

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to write the Data Packet to the SQL Database
Procedure TMultiValueDataWrite.WriteData (Const DataPacket : TDataPacket);
Begin // WriteData
  // Check we want the packet
  If WantDataPacket(DataPacket) Then
  Begin
    // If local packet list count = 0 then, initialize the SQL Insert statement as this is
    // the first data packet for the Data Write object OR we have just written a batch
    If (FDataPacketList.Count = 0) Then
    Begin
      // Initialise the Multi-Value Insert statement
      InitialiseInsert;
    End; // If (FDataPacketList.Count = 0)

    // Add into local Packet List
    FDataPacketList.Add (DataPacket);

    // Append the Data Packet to the existing multi-values Insert statement being generated
    AppendToInsert (DataPacket, FDataPacketList.Count = 1);

    // Check for the write count threshold being exceeded
    If (FDataPacketList.Count >= DefaultMultiValuePacketThreshold) Then
    Begin
      // Insert the data
      FlushInsert;
    End; // If (FDataPacketList.Count >= DefaultMultiValuePacketThreshold)
  End; // If WantDataPacket(DataPacket)
End; // WriteData

//-------------------------------------------------------------------------

// Writes the accumulated rows in the SQL Insert to SQL Server
Procedure TMultiValueDataWrite.FlushInsert;
Var
  oDataPacket : TDataPacket;
  Res : Integer;
  //sDumpFile : ShortString;
Begin // FlushInsert
  // Execute the Insert Statement
  Try
    FADOQuery.SQL.Text := StringReplace(FSQLQuery, '[COMPANY]', '[' + Trim(FCompanyCode) + ']', [rfReplaceAll]);
    Res := FADOQuery.ExecSQL;
    // Res should be equal to the number of rows inserted
    If (Res <> FDataPacketList.Count) Or (FADOQuery.Connection.Errors.Count > 0) Then
    Begin
      // Log error and continue conversion
      //sDumpFile := DataPacket.DumpToFile;
      oDataPacket := FDataPacketList.Items[0];
      ConversionWarnings.AddWarning(TSQLExecutionErrorWarning.Create (oDataPacket, '', FADOQuery.SQL.Text, Res, FADOQuery.Connection));
      Logging.SQLError ('TBaseDataWrite.WriteData ' + Logging.ThreadIdString, FADOQuery.SQL.Text, '', Res, FADOQuery.Connection);
    End; // If (Res <> 1) Or (FADOQuery.Connection.Errors.Count > 0)

    // Clear down the packet list and setup for the next multi-values insert
    ClearDataPacketList (True);
    FSqlQuery := '';
  Except
    On E:Exception Do
    begin
      // Log error and continue conversion
      //sDumpFile := DataPacket.DumpToFile;
      oDataPacket := FDataPacketList.Items[0];
      ConversionWarnings.AddWarning(TSQLExecutionExceptionWarning.Create (oDataPacket, '', FADOQuery.SQL.Text, E.Message));
      Logging.SQLException ('TBaseDataWrite.WriteData ' + Logging.ThreadIdString, FADOQuery.SQL.Text, '', E.Message)
    end;
  End; // Try..Except
End; // FlushInsert

//=========================================================================


End.


