Unit oPaUserDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TPaUserDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    usCompanyParam, usUserIDParam, usUserNameParam, usEMailParam, usFloorLimitParam, 
    usAuthNameParam, usSendOptionsParam, usDefaultApproverParam, usDefaultAuthoriserParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TPaUserDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, BtrvU2, AuthVar;

//=========================================================================

Constructor TPaUserDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TPaUserDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TPaUserDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.PaUser (' +
                                             'usCompany, ' +
                                             'usUserID, ' +
                                             'usUserName, ' +
                                             'usEMail, ' +
                                             'usFloorLimit, ' +
                                             'usAuthName, ' +
                                             'usSendOptions, ' +
                                             'usDefaultApprover, ' +
                                             'usDefaultAuthoriser' +
                                             ') ' +
              'VALUES (' +
                       ':usCompany, ' +
                       ':usUserID, ' +
                       ':usUserName, ' +
                       ':usEMail, ' +
                       ':usFloorLimit, ' +
                       ':usAuthName, ' +
                       ':usSendOptions, ' +
                       ':usDefaultApprover, ' +
                       ':usDefaultAuthoriser' +
                       ')';


  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    usCompanyParam := FindParam('usCompany');
    usUserIDParam := FindParam('usUserID');
    usUserNameParam := FindParam('usUserName');
    usEMailParam := FindParam('usEMail');
    usFloorLimitParam := FindParam('usFloorLimit');
    usAuthNameParam := FindParam('usAuthName');
    usSendOptionsParam := FindParam('usSendOptions');
    usDefaultApproverParam := FindParam('usDefaultApprover');
    usDefaultAuthoriserParam := FindParam('usDefaultAuthoriser');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TPaUserDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);

Var
  DataRec : ^TpaUserRec;
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
    usCompanyParam.Value := usCompany;                                                  // SQL=varchar, Delphi=String[6]
    usUserIDParam.Value := usUserID;                                                    // SQL=varchar, Delphi=String[10]
    usUserNameParam.Value := usUserName;                                                // SQL=varchar, Delphi=String[30]
    usEMailParam.Value := usEMail;                                                      // SQL=varchar, Delphi=string[100]
    usFloorLimitParam.Value := usFloorLimit;                                            // SQL=float, Delphi=Double
    usAuthNameParam.Value := usAuthAmount;                                              // SQL=float, Delphi=Double
    usSendOptionsParam.Value := ConvertCharToSQLEmulatorVarChar(usSendOptions);         // SQL=varchar, Delphi=Char
    usDefaultApproverParam.Value := usDefaultApprover;                                  // SQL=varchar, Delphi=string[60]
    usDefaultAuthoriserParam.Value := usDefaultAuthoriser;                              // SQL=varchar, Delphi=string[60]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

