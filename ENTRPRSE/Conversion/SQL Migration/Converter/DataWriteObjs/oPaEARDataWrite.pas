Unit oPaEarDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TPaEarDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    CompanyParam, reEARParam, reOurRefParam, reUserIDParam, reTimeStampParam, 
    reTotalValueParam, reStatusParam, reApprovedByParam, reAuthoriserParam, 
    reFolioParam, reDocTypeParam, reSupplierParam, reLineCountParam, reCheckSumParam, 
    reApprovalDateTimeParam, reAdminNotifiedParam, reAlreadySentParam, 
    rePrevDateParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TPaEarDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, BtrvU2, AuthVar;

//=========================================================================

Constructor TPaEarDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TPaEarDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TPaEarDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.PaEAR (' +
                                            'Company, ' +
                                            'reEAR, ' +
                                            'reOurRef, ' +
                                            'reUserID, ' +
                                            'reTimeStamp, ' +
                                            'reTotalValue, ' +
                                            'reStatus, ' +
                                            'reApprovedBy, ' +
                                            'reAuthoriser, ' +
                                            'reFolio, ' +
                                            'reDocType, ' +
                                            'reSupplier, ' +
                                            'reLineCount, ' +
                                            'reCheckSum, ' +
                                            'reApprovalDateTime, ' +
                                            'reAdminNotified, ' +
                                            'reAlreadySent, ' +
                                            'rePrevDate' +
                                            ') ' + 
              'VALUES (' + 
                       ':Company, ' + 
                       ':reEAR, ' + 
                       ':reOurRef, ' + 
                       ':reUserID, ' + 
                       ':reTimeStamp, ' + 
                       ':reTotalValue, ' + 
                       ':reStatus, ' + 
                       ':reApprovedBy, ' + 
                       ':reAuthoriser, ' + 
                       ':reFolio, ' + 
                       ':reDocType, ' + 
                       ':reSupplier, ' + 
                       ':reLineCount, ' + 
                       ':reCheckSum, ' +
                       ':reApprovalDateTime, ' + 
                       ':reAdminNotified, ' + 
                       ':reAlreadySent, ' + 
                       ':rePrevDate' + 
                       ')';



  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    CompanyParam := FindParam('Company');
    reEARParam := FindParam('reEAR');
    reOurRefParam := FindParam('reOurRef');
    reUserIDParam := FindParam('reUserID');
    reTimeStampParam := FindParam('reTimeStamp');
    reTotalValueParam := FindParam('reTotalValue');
    reStatusParam := FindParam('reStatus');
    reApprovedByParam := FindParam('reApprovedBy');
    reAuthoriserParam := FindParam('reAuthoriser');
    reFolioParam := FindParam('reFolio');
    reDocTypeParam := FindParam('reDocType');
    reSupplierParam := FindParam('reSupplier');
    reLineCountParam := FindParam('reLineCount');
    reCheckSumParam := FindParam('reCheckSum');
    reApprovalDateTimeParam := FindParam('reApprovalDateTime');
    reAdminNotifiedParam := FindParam('reAdminNotified');
    reAlreadySentParam := FindParam('reAlreadySent');
    rePrevDateParam := FindParam('rePrevDate');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TPaEarDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);

Var
  DataRec : ^TpaRequestRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  //As the FaxDetails record is the only variant which corresponds with the SQL key fields, we'll
  //use it for all variants.
  With DataRec^ Do
  Begin
    CompanyParam.Value := Company;                               // SQL=varchar, Delphi=String[6]
    reEARParam.Value := reEAR;                                   // SQL=varchar, Delphi=String[50]
    reOurRefParam.Value := reOurRef;                             // SQL=varchar, Delphi=String[10]
    reUserIDParam.Value := reUserID;                             // SQL=varchar, Delphi=String[10]
    reTimeStampParam.Value := reTimeStamp;                       // SQL=varchar, Delphi=String[12]
    reTotalValueParam.Value := reTotalValue;                     // SQL=float, Delphi=Double
    reStatusParam.Value := reStatus;                             // SQL=int, Delphi=Byte
    reApprovedByParam.Value := reApprovedBy;                     // SQL=varchar, Delphi=String[60]
    reAuthoriserParam.Value := reAuthoriser;                     // SQL=varchar, Delphi=String[60]
    reFolioParam.Value := reFolio;                               // SQL=int, Delphi=longint
    reDocTypeParam.Value := reDocType;                           // SQL=int, Delphi=Byte
    reSupplierParam.Value := reSupplier;                         // SQL=varchar, Delphi=String[6]
    reLineCountParam.Value := reLineCount;                       // SQL=int, Delphi=SmallInt
    reCheckSumParam.Value := reCheckSum;                         // SQL=bigint, Delphi=Int64
    reApprovalDateTimeParam.Value
      := DateTimeToSQLDateTimeOrNull(reApprovalDateTime);         // SQL=datetime, Delphi=TDateTime
    reAdminNotifiedParam.Value := reAdminNotified;               // SQL=bit, Delphi=Boolean
    reAlreadySentParam.Value := reAlreadySent;                   // SQL=bit, Delphi=Boolean
    rePrevDateParam.Value := rePrevDate;                         // SQL=varchar, Delphi=string[12]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

