unit oVAT100DataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TVAT100DataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    FTableName: string;

    vatCorrelationIDParam,
    vatIRMarkParam,
    vatDateSubmittedParam,
    vatDocumentTypeParam,
    vatPeriodParam,
    vatUserNameParam,
    vatStatusParam,
    vatPollingIntervalParam,
    vatDueOnOutputsParam,
    vatDueOnECAcquisitionsParam,
    vatTotalParam,
    vatReclaimedOnInputsParam,
    vatNetParam,
    vatNetSalesAndOutputsParam,
    vatNetPurchasesAndInputsParam,
    vatNetECSuppliesParam,
    // MH 25/08/2015 2015-R1 ABSEXCH-16788: Corrected typo in field name
    vatNetECAcquisitionsParam,
    vatHMRCNarrativeParam,
    vatNotifyEmailParam: TParameter;
    // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing VAT100 field
    vatPollingURLParam: TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Method to
    //  (a) populate the ADO Query with the data from the DataPacket
    //  (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TVAT100DataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, VarConst,
  oVAT100BtrieveFile;

// ---------------------------------------------------------------------------

Constructor TVAT100DataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
  FTableName := 'VAT100';
End; // Create

// ---------------------------------------------------------------------------

Destructor TVAT100DataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

// ---------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TVAT100DataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].' + FTableName + ' (' +
                                               'vatCorrelationID, ' +
                                               'vatIRMark, ' +
                                               'vatDateSubmitted, ' +
                                               'vatDocumentType, ' +
                                               'vatPeriod, ' +
                                               'vatUserName, ' +
                                               'vatStatus, ' +
                                               'vatPollingInterval, ' +
                                               'vatDueOnOutputs, ' +
                                               'vatDueOnECAcquisitions, ' +
                                               'vatTotal, ' +
                                               'vatReclaimedOnInputs, ' +
                                               'vatNet, ' +
                                               'vatNetSalesAndOutputs, ' +
                                               'vatNetPurchasesAndInputs, ' +
                                               'vatNetECSupplies, ' +
                                               // MH 25/08/2015 2015-R1 ABSEXCH-16788: Corrected typo in field name
                                               'vatNetECAcquisitions, ' +
                                               'vatHMRCNarrative, ' +
                                               'vatNotifyEmail, ' +
                                               // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing VAT100 field
                                               'vatPollingURL' +
                                               ') ' +
              'VALUES (' +
                       ':vatCorrelationID, ' +
                       ':vatIRMark, ' +
                       ':vatDateSubmitted, ' +
                       ':vatDocumentType, ' +
                       ':vatPeriod, ' +
                       ':vatUserName, ' +
                       ':vatStatus, ' +
                       ':vatPollingInterval, ' +
                       ':vatDueOnOutputs, ' +
                       ':vatDueOnECAcquisitions, ' +
                       ':vatTotal, ' +
                       ':vatReclaimedOnInputs, ' +
                       ':vatNet, ' +
                       ':vatNetSalesAndOutputs, ' +
                       ':vatNetPurchasesAndInputs, ' +
                       ':vatNetECSupplies, ' +
                       // MH 25/08/2015 2015-R1 ABSEXCH-16788: Corrected typo in field name
                       ':vatNetECAcquisitions, ' +
                       ':vatHMRCNarrative, ' +
                       ':vatNotifyEmail, ' +
                       // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing VAT100 field
                       ':vatPollingURL' +
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    vatCorrelationIDParam         := FindParam('vatCorrelationID');
    vatIRMarkParam                := FindParam('vatIRMark');
    vatDateSubmittedParam         := FindParam('vatDateSubmitted');
    vatDocumentTypeParam          := FindParam('vatDocumentType');
    vatPeriodParam                := FindParam('vatPeriod');
    vatUserNameParam              := FindParam('vatUserName');
    vatStatusParam                := FindParam('vatStatus');
    vatPollingIntervalParam       := FindParam('vatPollingInterval');
    vatDueOnOutputsParam          := FindParam('vatDueOnOutputs');
    vatDueOnECAcquisitionsParam   := FindParam('vatDueOnECAcquisitions');
    vatTotalParam                 := FindParam('vatTotal');
    vatReclaimedOnInputsParam     := FindParam('vatReclaimedOnInputs');
    vatNetParam                   := FindParam('vatNet');
    vatNetSalesAndOutputsParam    := FindParam('vatNetSalesAndOutputs');
    vatNetPurchasesAndInputsParam := FindParam('vatNetPurchasesAndInputs');
    vatNetECSuppliesParam         := FindParam('vatNetECSupplies');
    // MH 25/08/2015 2015-R1 ABSEXCH-16788: Corrected typo in field name
    vatNetECAcquisitionsParam     := FindParam('vatNetECAcquisitions');
    vatHMRCNarrativeParam         := FindParam('vatHMRCNarrative');
    vatNotifyEmailParam           := FindParam('vatNotifyEmail');
    // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing VAT100 field
    vatPollingURLParam            := FindParam('vatPollingURL');
  End; // With FADOQuery.Parameters
End; // Prepare

// ---------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TVAT100DataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^VAT100RecType;
  // MH 25/01/2017 2017-R1 ABSEXCH-18200: HMRC Narrative field not being converted to VarBinary correctly
  //Narrative: AnsiString;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // MH 25/01/2017 2017-R1 ABSEXCH-18200: HMRC Narrative field not being converted to VarBinary correctly
  // We can't copy the vatHMRCNarrative array[] of char directly to a variant
  // (which is the type used by the Param.Value fields), so we'll copy it to a
  // plain string first.
  //Narrative := DataRec.vatHMRCNarrative;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    vatCorrelationIDParam.Value          := vatCorrelationID;
    vatIRMarkParam.Value                 := vatIRMark;
    vatDateSubmittedParam.Value          := vatDateSubmitted;
    vatDocumentTypeParam.Value           := vatDocumentType;
    vatPeriodParam.Value                 := vatPeriod;
    vatUserNameParam.Value               := vatUserName;
    vatStatusParam.Value                 := vatStatus;
    vatPollingIntervalParam.Value        := vatPollingInterval;
    vatDueOnOutputsParam.Value           := vatDueOnOutputs;
    vatDueOnECAcquisitionsParam.Value    := vatDueOnECAcquisitions;
    vatTotalParam.Value                  := vatTotal;
    vatReclaimedOnInputsParam.Value      := vatReclaimedOnInputs;
    vatNetParam.Value                    := vatNet;
    vatNetSalesAndOutputsParam.Value     := vatNetSalesAndOutputs;
    vatNetPurchasesAndInputsParam.Value  := vatNetPurchasesAndInputs;
    vatNetECSuppliesParam.Value          := vatNetECSupplies;
    // MH 25/08/2015 2015-R1 ABSEXCH-16788: Corrected typo in field name
    vatNetECAcquisitionsParam.Value      := vatNetECAcquisition;
    // MH 25/01/2017 2017-R1 ABSEXCH-18200: HMRC Narrative field not being converted to VarBinary correctly
    // vatHMRCNarrativeParam.Value          := Narrative;
    vatHMRCNarrativeParam.Value          := CreateVariantArray (@DataRec^.vatHMRCNarrative, SizeOf(DataRec^.vatHMRCNarrative));
    vatNotifyEmailParam.Value            := vatNotifyEmail;
    // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing VAT100 field
    vatPollingURLParam.Value             := vatPollingURL;
  End; // With DataRec^
End; // SetParameterValues

// -----------------------------------------------------------------------------

End.

