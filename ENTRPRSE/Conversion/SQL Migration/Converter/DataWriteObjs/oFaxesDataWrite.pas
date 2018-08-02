Unit oFaxesDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TFaxesDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    PrefixParam, FaxesCode1Param, FaxesCode2Param, FaxesCode3Param, image_0Param : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TFaxesDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, BtrvU2;

  {$I w:\Fax\Shared\FaxVar.pas}

//=========================================================================

Constructor TFaxesDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TFaxesDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TFaxesDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.FAXES (' +
                                            'Prefix, ' +
                                            'FaxesCode1, ' +
                                            'FaxesCode2, ' +
                                            'FaxesCode3, ' +
                                            'image_0' +
                                            ') ' +
              'VALUES (' +
                       ':Prefix, ' +
                       ':FaxesCode1, ' +
                       ':FaxesCode2, ' +
                       ':FaxesCode3, ' +
                       ':image_0' +
                       ')';

  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    PrefixParam := FindParam('Prefix');
    FaxesCode1Param := FindParam('FaxesCode1');
    FaxesCode2Param := FindParam('FaxesCode2');
    FaxesCode3Param := FindParam('FaxesCode3');
    image_0Param := FindParam('image_0');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TFaxesDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TFaxRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  //As the FaxDetails record is the only variant which corresponds with the SQL key fields, we'll
  //use it for all variants.
  With DataRec^, FaxDetails Do
  Begin
    PrefixParam.Value := ConvertCharToSQLEmulatorVarChar(FaxRecType);                        // SQL=varchar, Delphi=char
    FaxesCode1Param.Value := CreateVariantArray (@FaxDocName, SizeOf(FaxDocName));// SQL=varbinary, Delphi=string[80]
    FaxesCode2Param.Value := CreateVariantArray (@FaxAPFName, SizeOf(FaxAPFName));// SQL=varbinary, Delphi=string[12]
    FaxesCode3Param.Value := CreateVariantArray (@FaxUserName, SizeOf(FaxUserName));// SQL=varbinary, Delphi=string[20]
    image_0Param.Value := CreateVariantArray(@FaxCancel, 864);     //864 = 980 - 1 - 81 - 13 - 21                                                    // SQL=image, Delphi=boolean
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

