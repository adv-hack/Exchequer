Unit oNominalDataWrite;

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TNominalDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    glCodeParam, glNameParam, glParentParam, glTypeParam, glPageParam,
    glSubtotalParam, glTotalParam, glCarryFwdParam, glRevalueParam, glAltCodeParam,
    glPrivateRecParam, glCurrencyParam, glForceJobCodeParam, glInactiveParam,
    glClassParam, glSpareParam, glNomStrParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TNominalDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TNominalDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TNominalDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TNominalDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].Nominal (' + 
                                              'glCode, ' + 
                                              'glName, ' + 
                                              'glParent, ' + 
                                              'glType, ' + 
                                              'glPage, ' + 
                                              'glSubtotal, ' + 
                                              'glTotal, ' + 
                                              'glCarryFwd, ' + 
                                              'glRevalue, ' + 
                                              'glAltCode, ' + 
                                              'glPrivateRec, ' + 
                                              'glCurrency, ' + 
                                              'glForceJobCode, ' + 
                                              'glInactive, ' + 
                                              'glClass, ' + 
                                              'glSpare, ' + 
                                              'glNomStr' + 
                                              ') ' + 
              'VALUES (' + 
                       ':glCode, ' + 
                       ':glName, ' + 
                       ':glParent, ' + 
                       ':glType, ' + 
                       ':glPage, ' + 
                       ':glSubtotal, ' + 
                       ':glTotal, ' + 
                       ':glCarryFwd, ' + 
                       ':glRevalue, ' + 
                       ':glAltCode, ' + 
                       ':glPrivateRec, ' + 
                       ':glCurrency, ' + 
                       ':glForceJobCode, ' + 
                       ':glInactive, ' + 
                       ':glClass, ' + 
                       ':glSpare, ' + 
                       ':glNomStr' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    glCodeParam := FindParam('glCode');
    glNameParam := FindParam('glName');
    glParentParam := FindParam('glParent');
    glTypeParam := FindParam('glType');
    glPageParam := FindParam('glPage');
    glSubtotalParam := FindParam('glSubtotal');
    glTotalParam := FindParam('glTotal');
    glCarryFwdParam := FindParam('glCarryFwd');
    glRevalueParam := FindParam('glRevalue');
    glAltCodeParam := FindParam('glAltCode');
    glPrivateRecParam := FindParam('glPrivateRec');
    glCurrencyParam := FindParam('glCurrency');
    glForceJobCodeParam := FindParam('glForceJobCode');
    glInactiveParam := FindParam('glInactive');
    glClassParam := FindParam('glClass');
    glSpareParam := FindParam('glSpare');
    glNomStrParam := FindParam('glNomStr');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TNominalDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^NominalRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    glCodeParam.Value := NomCode;                                             // SQL=int, Delphi=Longint
    glNameParam.Value := Desc;                                                // SQL=varchar, Delphi=String[40]
    glParentParam.Value := Cat;                                               // SQL=int, Delphi=LongInt
    glTypeParam.Value := ConvertCharToSQLEmulatorVarChar(NomType);            // SQL=varchar, Delphi=Char
    glPageParam.Value := NomPage;                                             // SQL=bit, Delphi=Boolean
    glSubtotalParam.Value := SubType;                                         // SQL=bit, Delphi=Boolean
    glTotalParam.Value := Total;                                              // SQL=bit, Delphi=Boolean
    glCarryFwdParam.Value := CarryF;                                          // SQL=int, Delphi=LongInt
    glRevalueParam.Value := ReValue;                                          // SQL=bit, Delphi=Boolean
    glAltCodeParam.Value := AltCode;                                          // SQL=varchar, Delphi=String[50]
    glPrivateRecParam.Value := PrivateRec;                                    // SQL=int, Delphi=Byte
    glCurrencyParam.Value := DefCurr;                                         // SQL=int, Delphi=Byte
    glForceJobCodeParam.Value := ForceJC;                                     // SQL=bit, Delphi=Boolean
    glInactiveParam.Value := HideAC;                                          // SQL=int, Delphi=Byte
    glClassParam.Value := NomClass;                                           // SQL=int, Delphi=Byte
    glSpareParam.Value := CreateVariantArray (@Spare, SizeOf(Spare));         // SQL=varbinary, Delphi=Array[1..47] of Byte
    glNomStrParam.Value := NomCodeStr;                                        // SQL=varchar, Delphi=Str20
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

