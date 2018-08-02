Unit oPaCompDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TPaCompDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    companyParam, spauthsquParam, spauthpquParam, spauthporParam, spauthpinParam, 
    spsquformParam, sppquformParam, spporformParam, sppinformParam, spauthmodeParam, 
    spallowprintParam, spflooronpinsParam, spauthonconvertParam, sppintoleranceParam, 
    splastpincheckParam, sppincheckintervalParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TPaCompDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, BtrvU2, AuthVar;

//=========================================================================

Constructor TPaCompDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TPaCompDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TPaCompDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text :=  'INSERT INTO common.PaComp (' +
                                             'company, ' +
                                             'spauthsqu, ' +
                                             'spauthpqu, ' +
                                             'spauthpor, ' +
                                             'spauthpin, ' +
                                             'spsquform, ' +
                                             'sppquform, ' +
                                             'spporform, ' +
                                             'sppinform, ' +
                                             'spauthmode, ' +
                                             'spallowprint, ' +
                                             'spflooronpins, ' +
                                             'spauthonconvert, ' +
                                             'sppintolerance, ' +
                                             'splastpincheck, ' +
                                             'sppincheckinterval' +
                                             ') ' +
              'VALUES (' +
                       ':company, ' +
                       ':spauthsqu, ' +
                       ':spauthpqu, ' +
                       ':spauthpor, ' +
                       ':spauthpin, ' +
                       ':spsquform, ' +
                       ':sppquform, ' +
                       ':spporform, ' +
                       ':sppinform, ' +
                       ':spauthmode, ' +
                       ':spallowprint, ' +
                       ':spflooronpins, ' +
                       ':spauthonconvert, ' +
                       ':sppintolerance, ' +
                       ':splastpincheck, ' +
                       ':sppincheckinterval' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    companyParam := FindParam('company');
    spauthsquParam := FindParam('spauthsqu');
    spauthpquParam := FindParam('spauthpqu');
    spauthporParam := FindParam('spauthpor');
    spauthpinParam := FindParam('spauthpin');
    spsquformParam := FindParam('spsquform');
    sppquformParam := FindParam('sppquform');
    spporformParam := FindParam('spporform');
    sppinformParam := FindParam('sppinform');
    spauthmodeParam := FindParam('spauthmode');
    spallowprintParam := FindParam('spallowprint');
    spflooronpinsParam := FindParam('spflooronpins');
    spauthonconvertParam := FindParam('spauthonconvert');
    sppintoleranceParam := FindParam('sppintolerance');
    splastpincheckParam := FindParam('splastpincheck');
    sppincheckintervalParam := FindParam('sppincheckinterval');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TPaCompDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);

Var
  DataRec : ^TpaCompanySysParams;
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
    companyParam.Value := Company;                               // SQL=varchar, Delphi=String[6]
    spauthsquParam.Value := spAuthSQU;                           // SQL=bit, Delphi=Boolean
    spauthpquParam.Value := spAuthPQU;                           // SQL=bit, Delphi=Boolean
    spauthporParam.Value := spAuthPOR;                           // SQL=bit, Delphi=Boolean
    spauthpinParam.Value := spAuthPIN;                           // SQL=bit, Delphi=Boolean
    spsquformParam.Value := spSQUForm;                           // SQL=varchar, Delphi=String[8]
    sppquformParam.Value := spPQUForm;                           // SQL=varchar, Delphi=String[8]
    spporformParam.Value := spPORForm;                           // SQL=varchar, Delphi=String[8]
    sppinformParam.Value := spPINForm;                           // SQL=varchar, Delphi=String[8]
    spauthmodeParam.Value := spAuthMode;                         // SQL=int, Delphi=Byte
    spallowprintParam.Value := spAllowPrint;                     // SQL=bit, Delphi=Boolean
    spflooronpinsParam.Value := spFloorOnPins;                   // SQL=bit, Delphi=Boolean
    spauthonconvertParam.Value := spAuthOnConvert;               // SQL=bit, Delphi=Boolean
    sppintoleranceParam.Value := spPINTolerance;                 // SQL=float, Delphi=Double
    splastpincheckParam.Value := DateTimeToSQLDateTimeOrNull(spLastPINCheck); // SQL=datetime, Delphi=TDateTime
    sppincheckintervalParam.Value := spPINCheckInterval;         // SQL=int, Delphi=SmallInt
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

