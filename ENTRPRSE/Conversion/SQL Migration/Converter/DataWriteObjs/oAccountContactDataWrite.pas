unit oAccountContactDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TAccountContactDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    FTableName: string;
    acoContactIdParam,
    acoAccountCodeParam,
    acoContactNameParam,
    acoContactJobTitleParam,
    acoContactPhoneNumberParam,
    acoContactFaxNumberParam,
    acoContactEmailAddressParam,
    acoContactHasOwnAddressParam,
    acoContactAddressLine1Param,
    acoContactAddressLine2Param,
    acoContactAddressLine3Param,
    acoContactAddressLine4Param,
    acoContactAddressLine5Param,
    acoContactPostCodeParam : TParameter;
    // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
    acoContactCountryParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Method to 
    //  (a) populate the ADO Query with the data from the DataPacket
    //  (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TAccountContactDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, oAccountContactBtrieveFile;

// -----------------------------------------------------------------------------

Constructor TAccountContactDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
  FTableName := 'AccountContact';
End; // Create

// -----------------------------------------------------------------------------

Destructor TAccountContactDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

// -----------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TAccountContactDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].' + FTableName + ' (' +
                                               'acoContactId, ' +           
                                               'acoAccountCode, ' +         
                                               'acoContactName, ' +         
                                               'acoContactJobTitle, ' +     
                                               'acoContactPhoneNumber, ' +
                                               'acoContactFaxNumber, ' +    
                                               'acoContactEmailAddress, ' + 
                                               'acoContactHasOwnAddress, ' +
                                               'acoContactAddress1, ' +
                                               'acoContactAddress2, ' +
                                               'acoContactAddress3, ' +
                                               'acoContactAddress4, ' +
                                               'acoContactAddress5, ' +
                                               'acoContactPostCode, ' +
                                               // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
                                               'acoContactCountry' +
                                               ') ' +
              'VALUES (' +
                       ':acoContactId, ' +
                       ':acoAccountCode, ' +
                       ':acoContactName, ' +
                       ':acoContactJobTitle, ' +
                       ':acoContactPhoneNumber, ' +
                       ':acoContactFaxNumber, ' +
                       ':acoContactEmailAddress, ' +
                       ':acoContactHasOwnAddress, ' +
                       ':acoContactAddress1, ' +
                       ':acoContactAddress2, ' +
                       ':acoContactAddress3, ' +
                       ':acoContactAddress4, ' +
                       ':acoContactAddress5, ' +
                       ':acoContactPostCode, ' +
                       // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
                       ':acoContactCountry' +
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    acoContactIdParam            := FindParam('acoContactId');
    acoAccountCodeParam          := FindParam('acoAccountCode');
    acoContactNameParam          := FindParam('acoContactName');
    acoContactJobTitleParam      := FindParam('acoContactJobTitle');
    acoContactPhoneNumberParam   := FindParam('acoContactPhoneNumber');
    acoContactFaxNumberParam     := FindParam('acoContactFaxNumber');
    acoContactEmailAddressParam  := FindParam('acoContactEmailAddress');
    acoContactHasOwnAddressParam := FindParam('acoContactHasOwnAddress');
    acoContactAddressLine1Param  := FindParam('acoContactAddress1');
    acoContactAddressLine2Param  := FindParam('acoContactAddress2');
    acoContactAddressLine3Param  := FindParam('acoContactAddress3');
    acoContactAddressLine4Param  := FindParam('acoContactAddress4');
    acoContactAddressLine5Param  := FindParam('acoContactAddress5');
    acoContactPostCodeParam      := FindParam('acoContactPostCode');
    // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
    acoContactCountryParam       := FindParam('acoContactCountry');
  End; // With FADOQuery.Parameters
End; // Prepare

// -----------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TAccountContactDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^AccountContactRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    acoContactIdParam.Value            := acoContactId;
    acoAccountCodeParam.Value          := acoAccountCode;
    acoContactNameParam.Value          := acoContactName;
    acoContactJobTitleParam.Value      := acoContactJobTitle;
    acoContactPhoneNumberParam.Value   := acoContactPhoneNumber;
    acoContactFaxNumberParam.Value     := acoContactFaxNumber;
    acoContactEmailAddressParam.Value  := acoContactEmailAddress;
    acoContactHasOwnAddressParam.Value := acoContactHasOwnAddress;
    acoContactAddressLine1Param.Value  := acoContactAddress[1];
    acoContactAddressLine2Param.Value  := acoContactAddress[2];
    acoContactAddressLine3Param.Value  := acoContactAddress[3];
    acoContactAddressLine4Param.Value  := acoContactAddress[4];
    acoContactAddressLine5Param.Value  := acoContactAddress[5];
    acoContactPostCodeParam.Value      := acoContactPostCode;
    // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
    acoContactCountryParam.Value       := acoContactCountry;
  End; // With DataRec^
End; // SetParameterValues

// -----------------------------------------------------------------------------

end.
