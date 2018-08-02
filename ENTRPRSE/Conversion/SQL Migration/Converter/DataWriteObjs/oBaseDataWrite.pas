Unit oBaseDataWrite;

Interface

Uses ADODB, SysUtils, oConvertOptions, oDataPacket;

Type
  // Base class for the data specific Data Write Objects
  TBaseDataWrite = Class(TObject)
  Private
    FPrepared : Boolean;
  Protected
    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Virtual; Abstract;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Virtual;
    // Called from the SQL Write Threads to write the Data Packet to the SQL Database
    Procedure WriteData (Const DataPacket : TDataPacket);
  End; // TBaseDataWrite

  //PR: 07/09/2016 ABSEXCH-15014 Base class to create SQL table
  TCreateTable = Class
  public
    Procedure Execute(Const oCompany : TConversionCompany); virtual; abstract;
  end;

  //PR: 07/09/2016 ABSEXCH-15014 Descendant to create HistPrge table
  TCreatePurgeHistory = Class(TCreateTable)
  public
    Procedure Execute(Const oCompany : TConversionCompany); override;
  end;

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
     oHistoryDataWrite, oCustomFieldsDataWrite, oDocumentDataWrite,
     oDetailsDataWrite, oEbusDataWrite, {oEbusDocDataWrite,} oEbusDetlDataWrite,
     oEbusLkupDataWrite, oNomViewDataWrite, oEbusNoteDataWrite, oToolsDataWrite,
     oLBinDataWrite, oLHeaderDataWrite, oFaxesDataWrite, oImportJobDataWrite,
     oLLinesDataWrite, oLSerialDataWrite, oTillNameDataWrite, oSortViewDataWrite,
     oSettingsDataWrite, oPaAuthDataWrite, oPaCompDataWrite, oPaEArDataWrite,
     oPaGlobalDataWrite, oPaUserDataWrite, oSVUserDefDataWrite, oPPCustDataWrite,
     oPPDebtDataWrite, oPPSetupDataWrite, oSchedCFGDataWrite, oScheduleDataWrite,
     oContactDataWrite, oCCDeptVDataWrite, oCommssnDataWrite, oSCTypeDataWrite,
     oSaleCodeDataWrite, oVRWSecDataWrite, oVRWTreeDataWrite, oSentDataWrite,
     oSentLineDataWrite, oEmpPayDataWrite, oMCPayDataWrite, oCurrencyHistoryDataWrite,
     oGLBudgetHistoryDataWrite, oAccountContactDataWrite, oAccountContactRoleDataWrite,
     oSystemSetupDataWrite,
     // MH 24/10/2014: Added support for new Order Payments fields
     oOPVATPayDataWrite, oVAT100DataWrite,
     // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
     oAnonymisationDiaryDataWrite;

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
    dmtAccountContact  : Result := TAccountContactDataWrite.Create; // AccountContact.Dat
    dmtAccountContactRole: Result := TAccountContactRoleDataWrite.Create; // AccountContactRole.Dat
    dmtCCDeptV         : Result := TCCDeptVDataWrite.Create;      // CCDeptV.Dat
    dmtColSet          : Result := TColSetDataWrite.Create;       // Misc\ColSet.Dat
    dmtCommssn         : Result := TCommssnDataWrite.Create;      // SalesCom\Commssn.Dat
    dmtCustomFields    : Result := TCustomFieldsDataWrite.Create; // Misc\CustomFields.Dat
    dmtCurrencyHistory : Result := TCurrencyHistoryDataWrite.Create;   // CurrencyHistory.Dat
    dmtCustSupp        : Result := TCustSuppDataWrite.Create;     // Cust\CustSupp.Dat
    dmtDetails         : Result := TDetailsDataWrite.Create(False);      // Trans\Details.Dat
    dmtDocument        : Result := TDocumentDataWrite.Create(False);     // Trans\Document.Dat
    dmtEbusDetl        : Result := TDetailsDataWrite.Create(True);     // Ebus\EbusDetl.Dat
    dmtEbusDoc         : Result := TDocumentDataWrite.Create(True);      // Ebus\EbusDoc.Dat
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
    dmtSystemSetup     : Result := TSystemSetupDataWrite.Create;  // Misc\SystemSetup.Dat
    dmtUDEntity        : Result := TUDEntityDataWrite.Create;     // UDEntity.Dat
    dmtUDField         : Result := TUDFieldDataWrite.Create;      // UDField.Dat
    dmtUDItem          : Result := TUDItemDataWrite.Create;       // UDItem.Dat
    dmtVAT100          : Result := TVAT100DataWrite.Create;       // Misc\VAT100.Dat
    dmtVatOpt          : Result := TVATOptDataWrite.Create;       // VatPer\VatOpt.Dat
    dmtVatPrd          : Result := TVATPrdDataWrite.Create;       // VatPer\VatPrd.Dat
    dmtVRWSec          : Result := TVRWSecDataWrite.Create;    // Reports\VRWSec.Dat
    dmtVRWTree         : Result := TVRWTreeDataWrite.Create;    // Reports\VRWTree.Dat
    dmtWinSet          : Result := TWinSetDataWrite.Create;       // Misc\WinSet.Dat
    // MH 24/10/2014: Added support for new Order Payments fields
    dmtOrdPayVATPayments  : Result := TOPVATPayDataWrite.Create;  // Trans\OPVATPay.Dat
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    dmtAnonymisationDiary : Result := TAnonymisationDiaryDataWrite.Create; // Misc\AnonymisationDiary.dat
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
End; // Create

//------------------------------

Destructor TBaseDataWrite.Destroy;
Begin // Destroy
  Inherited Destroy;
End; // Destroy

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

//=========================================================================

{ TPurgeHistoryCreate }

procedure TCreatePurgeHistory.Execute(Const oCompany : TConversionCompany);
var
  FADOQuery : TADOQuery;
  sqlQuery: ANSIString;
begin
  FADOQuery := TADOQuery.Create(NIL);
  Try
    // Link the ADO Connection into the Query so it can access the data
    FADOQuery.ConnectionString := oCompany.ccAdminConnectionString;

    //Query copied from THistoryDataWrite.CreateHistPrge to create HistPrge table
    sqlQuery := 'IF NOT EXISTS (SELECT * FROM sys.objects                                        ' +
                '               WHERE object_id = OBJECT_ID(N''[COMPANY].[HISTPRGE]'') AND       ' +
                '                     type in (N''U''))                                          ' +
                'CREATE TABLE [COMPANY].[HISTPRGE](                                              ' +
                '	[hiCode] [varbinary](21) NOT NULL,                                       ' +
                '	[hiExCLass] [int] NOT NULL,                                              ' +
                '	[hiCurrency] [int] NOT NULL,                                             ' +
                '	[hiYear] [int] NOT NULL,                                                 ' +
                '	[hiPeriod] [int] NOT NULL,                                               ' +
                '	[hiSales] [float] NOT NULL,                                              ' +
                '	[hiPurchases] [float] NOT NULL,                                          ' +
                '	[hiBudget] [float] NOT NULL,                                             ' +
                '	[hiCleared] [float] NOT NULL,                                            ' +
                '	[hiRevisedBudget1] [float] NOT NULL,                                     ' +
                '	[hiValue1] [float] NOT NULL,                                             ' +
                '	[hiValue2] [float] NOT NULL,                                             ' +
                '	[hiValue3] [float] NOT NULL,                                             ' +
                '	[hiRevisedBudget2] [float] NOT NULL,                                     ' +
                '	[hiRevisedBudget3] [float] NOT NULL,                                     ' +
                '	[hiRevisedBudget4] [float] NOT NULL,                                     ' +
                '	[hiRevisedBudget5] [float] NOT NULL,                                     ' +
                '	[hiSpareV] [float] NOT NULL,                                             ' +
                '	[PositionId] [int] IDENTITY(1,1) NOT NULL,                               ' +
                '	[hiCodeComputed] AS                                                      ' +
                '   (CONVERT([varbinary](20),substring([hiCode],(2),(20)),0)) PERSISTED,    ' +
                '       [hiBudget2]  AS ([hiRevisedBudget1])                               ' +
                ') ON [PRIMARY]';

    FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(oCompany.ccCompanyCode) + ']', [rfReplaceAll]);
    FADOQuery.ExecSQL;

    sqlQuery := {$I HistPurgeIndexes.inc}
    FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(oCompany.ccCompanyCode) + ']', [rfReplaceAll]);
    FADOQuery.ExecSQL;
  Finally
    FADOQuery.Free;
  End;
end;


End.


