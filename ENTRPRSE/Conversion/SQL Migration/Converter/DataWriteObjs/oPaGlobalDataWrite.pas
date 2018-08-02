Unit oPaGlobalDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TPaGlobalDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    spCompanyParam, spFrequencyParam, spAccountNameParam, spAccountPWordParam, 
    spEMailParam, spAdminEMailParam, spOfflineStartParam, spOfflineFinishParam, 
    spEARTimeOutParam, spPasswordParam, spServerParam, spUseMapiParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TPaGlobalDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, BtrvU2, AuthVar;

//=========================================================================

Constructor TPaGlobalDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TPaGlobalDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TPaGlobalDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text :=  'INSERT INTO common.PaGlobal (' +
                                               'spCompany, ' + 
                                               'spFrequency, ' + 
                                               'spAccountName, ' + 
                                               'spAccountPWord, ' + 
                                               'spEMail, ' + 
                                               'spAdminEMail, ' + 
                                               'spOfflineStart, ' + 
                                               'spOfflineFinish, ' + 
                                               'spEARTimeOut, ' + 
                                               'spPassword, ' + 
                                               'spServer, ' + 
                                               'spUseMapi' + 
                                               ') ' + 
              'VALUES (' + 
                       ':spCompany, ' + 
                       ':spFrequency, ' + 
                       ':spAccountName, ' + 
                       ':spAccountPWord, ' + 
                       ':spEMail, ' + 
                       ':spAdminEMail, ' + 
                       ':spOfflineStart, ' + 
                       ':spOfflineFinish, ' + 
                       ':spEARTimeOut, ' + 
                       ':spPassword, ' + 
                       ':spServer, ' + 
                       ':spUseMapi' + 
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    spCompanyParam := FindParam('spCompany');
    spFrequencyParam := FindParam('spFrequency');
    spAccountNameParam := FindParam('spAccountName');
    spAccountPWordParam := FindParam('spAccountPWord');
    spEMailParam := FindParam('spEMail');
    spAdminEMailParam := FindParam('spAdminEMail');
    spOfflineStartParam := FindParam('spOfflineStart');
    spOfflineFinishParam := FindParam('spOfflineFinish');
    spEARTimeOutParam := FindParam('spEARTimeOut');
    spPasswordParam := FindParam('spPassword');
    spServerParam := FindParam('spServer');
    spUseMapiParam := FindParam('spUseMapi');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TPaGlobalDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);

Var
  DataRec : ^TpaGlobalSysParams;
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
    spCompanyParam.Value := spCompany;                     // SQL=varchar, Delphi=string[6]
    spFrequencyParam.Value := spFrequency;                 // SQL=int, Delphi=SmallInt
    spAccountNameParam.Value := spAccountName;             // SQL=varchar, Delphi=String[100]
    spAccountPWordParam.Value := spAccountPWord;           // SQL=varchar, Delphi=String[100]
    spEMailParam.Value := spEMail;                         // SQL=varchar, Delphi=String[100]
    spAdminEMailParam.Value := spAdminEMail;               // SQL=varchar, Delphi=string[100]
    spOfflineStartParam.Value := DateTimeToSQLDateTimeOrNull(spOfflineStart);           // SQL=datetime, Delphi=TDateTime
    spOfflineFinishParam.Value := DateTimeToSQLDateTimeOrNull(spOfflineFinish);         // SQL=datetime, Delphi=TDateTime
    spEARTimeOutParam.Value := spEARTimeOut;               // SQL=int, Delphi=SmallInt
    spPasswordParam.Value := spPassword;                   // SQL=varchar, Delphi=String[8]
    spServerParam.Value := spServer;                       // SQL=varchar, Delphi=String[100]
    spUseMapiParam.Value := spUseMapi;                     // SQL=bit, Delphi=Boolean
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

