Unit oOPVATPayDataWrite;

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TOPVATPayDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    vpOrderRefParam, vpReceiptRefParam, vpTransRefParam, vpLineOrderNoParam,
    vpSORABSLineNoParam, vpTypeParam, vpCurrencyParam, vpDescriptionParam,
    vpVATCodeParam, vpGoodsValueParam, vpVATValueParam, vpUserNameParam,
    vpDateCreatedParam, vpTimeCreatedparam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TOPVATPayDataWrite

Implementation

Uses oOPVATPayBtrieveFile;

//=========================================================================

Constructor TOPVATPayDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TOPVATPayDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TOPVATPayDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].OPVATPay (' +
                                               'vpOrderRef, ' +
                                               'vpReceiptRef, ' +
                                               'vpTransRef, ' +
                                               'vpLineOrderNo, ' +
                                               'vpSORABSLineNo, ' +
                                               'vpType, ' +
                                               'vpCurrency, ' +
                                               'vpDescription, ' +
                                               'vpVATCode, ' +
                                               'vpGoodsValue, ' +
                                               'vpVATValue, ' +
                                               'vpUserName, ' +
                                               'vpDateCreated, ' +
                                               'vpTimeCreated' +
                                               ') ' +
            'VALUES (' +
                     ':vpOrderRef, ' +
                     ':vpReceiptRef, ' +
                     ':vpTransRef, ' +
                     ':vpLineOrderNo, ' +
                     ':vpSORABSLineNo, ' +
                     ':vpType, ' +
                     ':vpCurrency, ' +
                     ':vpDescription, ' +
                     ':vpVATCode, ' +
                     ':vpGoodsValue, ' +
                     ':vpVATValue, ' +
                     ':vpUserName, ' +
                     ':vpDateCreated, ' +
                     ':vpTimeCreated' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    vpOrderRefParam := FindParam('vpOrderRef');
    vpReceiptRefParam := FindParam('vpReceiptRef');
    vpTransRefParam := FindParam('vpTransRef');
    vpLineOrderNoParam := FindParam('vpLineOrderNo');
    vpSORABSLineNoParam := FindParam('vpSORABSLineNo');
    vpTypeParam := FindParam('vpType');
    vpCurrencyParam := FindParam('vpCurrency');
    vpDescriptionParam := FindParam('vpDescription');
    vpVATCodeParam := FindParam('vpVATCode');
    vpGoodsValueParam := FindParam('vpGoodsValue');
    vpVATValueParam := FindParam('vpVATValue');
    vpUserNameParam := FindParam('vpUserName');
    vpDateCreatedParam := FindParam('vpDateCreated');
    vpTimeCreatedParam := FindParam('vpTimeCreated');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TOPVATPayDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^OrderPaymentsVATPayDetailsRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  vpOrderRefParam.Value := DataRec^.vpOrderRef;
  vpReceiptRefParam.Value := DataRec^.vpReceiptRef;
  vpTransRefParam.Value := DataRec^.vpTransRef;
  vpLineOrderNoParam.Value := DataRec^.vpLineOrderNo;
  vpSORABSLineNoParam.Value := DataRec^.vpSORABSLineNo;
  vpTypeParam.Value := DataRec^.vpType;
  vpCurrencyParam.Value := DataRec^.vpCurrency;
  vpDescriptionParam.Value := DataRec^.vpDescription;
  vpVATCodeParam.Value := DataRec^.vpVATCode;
  vpGoodsValueParam.Value := DataRec^.vpGoodsValue;
  vpVATValueParam.Value := DataRec^.vpVATValue;
  vpUserNameParam.Value := DataRec^.vpUserName;
  vpDateCreatedParam.Value := DataRec^.vpDateCreated;
  vpTimeCreatedParam.Value := DataRec^.vpTimeCreated;
End; // SetParameterValues

//=========================================================================

End.

