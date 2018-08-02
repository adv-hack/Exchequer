Unit oJobHeadDataWrite;

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TJobHeadDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    JobCodeParam, JobDescParam, JobFolioParam, CustCodeParam, JobCatParam, 
    JobAltCodeParam, CompletedParam, ContactParam, JobManParam, ChargeTypeParam, 
    SpareParam, QuotePriceParam, CurrPriceParam, StartDateParam, EndDateParam, 
    RevEDateParam, SORRefParam, NLineCountParam, ALineCountParam, Spare3Param, 
    VATCodeParam, DepartmentParam, CostCentreParam, JobAnalParam, JobTypeParam, 
    JobStatParam, UserDef1Param, UserDef2Param, UserDef3Param, UserDef4Param, 
    DefRetCurrParam, JPTOurRefParam, JSTOurRefParam, JQSCodeParam, UserDef5Param,
    UserDef6Param, UserDef7Param, UserDef8Param, UserDef9Param, UserDef10Param : TParameter;
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    jrAnonymisedParam, jrAnonymisedDateParam, jrAnonymisedTimeParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobHeadDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TJobHeadDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TJobHeadDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TJobHeadDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].JOBHEAD (' + 
                                              'JobCode, ' + 
                                              'JobDesc, ' + 
                                              'JobFolio, ' + 
                                              'CustCode, ' + 
                                              'JobCat, ' + 
                                              'JobAltCode, ' + 
                                              'Completed, ' + 
                                              'Contact, ' + 
                                              'JobMan, ' + 
                                              'ChargeType, ' +
                                              'Spare, ' +
                                              'QuotePrice, ' +
                                              'CurrPrice, ' +
                                              'StartDate, ' +
                                              'EndDate, ' +
                                              'RevEDate, ' +
                                              'SORRef, ' +
                                              'NLineCount, ' +
                                              'ALineCount, ' +
                                              'Spare3, ' +
                                              'VATCode, ' +
                                              'Department, ' +
                                              'CostCentre, ' +
                                              'JobAnal, ' +
                                              'JobType, ' +
                                              'JobStat, ' +
                                              'UserDef1, ' +
                                              'UserDef2, ' +
                                              'UserDef3, ' +
                                              'UserDef4, ' +
                                              'DefRetCurr, ' +
                                              'JPTOurRef, ' +
                                              'JSTOurRef, ' +
                                              'JQSCode, ' +
                                              'UserDef5, ' +
                                              'UserDef6, ' +
                                              'UserDef7, ' +
                                              'UserDef8, ' +
                                              'UserDef9, ' +
                                              'UserDef10, ' +
                                              // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                                              'jrAnonymised, ' +
                                              'jrAnonymisedDate, ' +
                                              'jrAnonymisedTime' +
                                              ') ' +
              'VALUES (' +
                       ':JobCode, ' + 
                       ':JobDesc, ' + 
                       ':JobFolio, ' + 
                       ':CustCode, ' + 
                       ':JobCat, ' + 
                       ':JobAltCode, ' + 
                       ':Completed, ' + 
                       ':Contact, ' + 
                       ':JobMan, ' + 
                       ':ChargeType, ' + 
                       ':Spare, ' + 
                       ':QuotePrice, ' + 
                       ':CurrPrice, ' + 
                       ':StartDate, ' + 
                       ':EndDate, ' + 
                       ':RevEDate, ' + 
                       ':SORRef, ' + 
                       ':NLineCount, ' + 
                       ':ALineCount, ' + 
                       ':Spare3, ' + 
                       ':VATCode, ' + 
                       ':Department, ' + 
                       ':CostCentre, ' + 
                       ':JobAnal, ' + 
                       ':JobType, ' + 
                       ':JobStat, ' + 
                       ':UserDef1, ' + 
                       ':UserDef2, ' + 
                       ':UserDef3, ' + 
                       ':UserDef4, ' + 
                       ':DefRetCurr, ' + 
                       ':JPTOurRef, ' + 
                       ':JSTOurRef, ' + 
                       ':JQSCode, ' + 
                       ':UserDef5, ' + 
                       ':UserDef6, ' + 
                       ':UserDef7, ' + 
                       ':UserDef8, ' +
                       ':UserDef9, ' +
                       ':UserDef10, ' +
                       // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                       ':jrAnonymised, ' +
                       ':jrAnonymisedDate, ' +
                       ':jrAnonymisedTime' +
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    JobCodeParam := FindParam('JobCode');
    JobDescParam := FindParam('JobDesc');
    JobFolioParam := FindParam('JobFolio');
    CustCodeParam := FindParam('CustCode');
    JobCatParam := FindParam('JobCat');
    JobAltCodeParam := FindParam('JobAltCode');
    CompletedParam := FindParam('Completed');
    ContactParam := FindParam('Contact');
    JobManParam := FindParam('JobMan');
    ChargeTypeParam := FindParam('ChargeType');
    SpareParam := FindParam('Spare');
    QuotePriceParam := FindParam('QuotePrice');
    CurrPriceParam := FindParam('CurrPrice');
    StartDateParam := FindParam('StartDate');
    EndDateParam := FindParam('EndDate');
    RevEDateParam := FindParam('RevEDate');
    SORRefParam := FindParam('SORRef');
    NLineCountParam := FindParam('NLineCount');
    ALineCountParam := FindParam('ALineCount');
    Spare3Param := FindParam('Spare3');
    VATCodeParam := FindParam('VATCode');
    DepartmentParam := FindParam('Department');
    CostCentreParam := FindParam('CostCentre');
    JobAnalParam := FindParam('JobAnal');
    JobTypeParam := FindParam('JobType');
    JobStatParam := FindParam('JobStat');
    UserDef1Param := FindParam('UserDef1');
    UserDef2Param := FindParam('UserDef2');
    UserDef3Param := FindParam('UserDef3');
    UserDef4Param := FindParam('UserDef4');
    DefRetCurrParam := FindParam('DefRetCurr');
    JPTOurRefParam := FindParam('JPTOurRef');
    JSTOurRefParam := FindParam('JSTOurRef');
    JQSCodeParam := FindParam('JQSCode');
    UserDef5Param := FindParam('UserDef5');
    UserDef6Param := FindParam('UserDef6');
    UserDef7Param := FindParam('UserDef7');
    UserDef8Param := FindParam('UserDef8');
    UserDef9Param := FindParam('UserDef9');
    UserDef10Param := FindParam('UserDef10');

    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    jrAnonymisedParam := FindParam('jrAnonymised');
    jrAnonymisedDateParam := FindParam('jrAnonymisedDate');
    jrAnonymisedTimeParam := FindParam('jrAnonymisedTime');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TJobHeadDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^JobRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    JobCodeParam.Value := JobCode;                                          // SQL=varchar, Delphi=String[10]
    JobDescParam.Value := JobDesc;                                          // SQL=varchar, Delphi=String[30]
    JobFolioParam.Value := JobFolio;                                        // SQL=int, Delphi=LongInt
    CustCodeParam.Value := CustCode;                                        // SQL=varchar, Delphi=String[10]
    JobCatParam.Value := JobCat;                                            // SQL=varchar, Delphi=String[10]
    JobAltCodeParam.Value := JobAltCode;                                    // SQL=varchar, Delphi=String[10]
    CompletedParam.Value := Completed;                                      // SQL=int, Delphi=LongInt
    ContactParam.Value := Contact;                                          // SQL=varchar, Delphi=string[25]
    JobManParam.Value := JobMan;                                            // SQL=varchar, Delphi=String[25]
    ChargeTypeParam.Value := ChargeType;                                    // SQL=int, Delphi=SmallInt
    SpareParam.Value := Spare;                                              // SQL=varchar, Delphi=String[10]
    QuotePriceParam.Value := QuotePrice;                                    // SQL=float, Delphi=Double
    CurrPriceParam.Value := CurrPrice;                                      // SQL=int, Delphi=Byte
    StartDateParam.Value := StartDate;                                      // SQL=varchar, Delphi=LongDate
    EndDateParam.Value := EndDate;                                          // SQL=varchar, Delphi=LongDate
    RevEDateParam.Value := RevEDate;                                        // SQL=varchar, Delphi=LongDate
    SORRefParam.Value := SORRef;                                            // SQL=varchar, Delphi=String[10]
    NLineCountParam.Value := NLineCount;                                    // SQL=int, Delphi=LongInt
    ALineCountParam.Value := ALineCount;                                    // SQL=int, Delphi=LongInt
    Spare3Param.Value := Spare3;                                            // SQL=varchar, Delphi=String[10]
    VATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(VATCode);         // SQL=varchar, Delphi=Char
    DepartmentParam.Value := CCDep[False];                                    // SQL=varchar, Delphi=String[3]
    CostCentreParam.Value := CCDep[True];                                    // SQL=varchar, Delphi=String[3]
    JobAnalParam.Value := JobAnal;                                          // SQL=varchar, Delphi=String[3]
    JobTypeParam.Value := ConvertCharToSQLEmulatorVarChar(JobType);         // SQL=varchar, Delphi=Char
    JobStatParam.Value := JobStat;                                          // SQL=int, Delphi=LongInt
    UserDef1Param.Value := UserDef1;                                        // SQL=varchar, Delphi=String[20]
    UserDef2Param.Value := UserDef2;                                        // SQL=varchar, Delphi=String[20]
    UserDef3Param.Value := UserDef3;                                        // SQL=varchar, Delphi=String[20]
    UserDef4Param.Value := UserDef4;                                        // SQL=varchar, Delphi=String[20]
    DefRetCurrParam.Value := DefRetCurr;                                    // SQL=int, Delphi=Byte
    JPTOurRefParam.Value := JPTOurRef;                                      // SQL=varchar, Delphi=String[10]
    JSTOurRefParam.Value := JSTOurRef;                                      // SQL=varchar, Delphi=String[10]
    JQSCodeParam.Value := JQSCode;                                          // SQL=varchar, Delphi=String[20]
    UserDef5Param.Value := UserDef5;                                        // SQL=varchar, Delphi=String[30]
    UserDef6Param.Value := UserDef6;                                        // SQL=varchar, Delphi=String[30]
    UserDef7Param.Value := UserDef7;                                        // SQL=varchar, Delphi=String[30]
    UserDef8Param.Value := UserDef8;                                        // SQL=varchar, Delphi=String[30]
    UserDef9Param.Value := UserDef9;                                        // SQL=varchar, Delphi=String[30]
    UserDef10Param.Value := UserDef10;                                      // SQL=varchar, Delphi=String[30]

    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    jrAnonymisedParam.Value := jrAnonymised;
    jrAnonymisedDateParam.Value := jrAnonymisedDate;
    jrAnonymisedTimeParam.Value := jrAnonymisedTime;
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

