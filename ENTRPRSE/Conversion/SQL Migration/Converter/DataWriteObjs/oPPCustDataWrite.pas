Unit oPPCustDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TPPCustDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    ppcCustCodeParam, ppcDefaultRateParam, ppcInterestVarianceParam, ppcCreditDaysOffsetParam, 
    ppcMinInvoiceValueParam, ppcInterestGLCodeParam, ppcDebtChargeGLCodeParam, 
    ppcCostCentreParam, ppcDepartmentParam, ppcDebitChargeBasisParam, ppcActiveParam, 
    ppcSyncGLCodesParam, ppcDummyCharParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TPPCustDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils;

//=========================================================================

Constructor TPPCustDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TPPCustDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TPPCustDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].PPCust (' + 
                                             'ppcCustCode, ' + 
                                             'ppcDefaultRate, ' + 
                                             'ppcInterestVariance, ' + 
                                             'ppcCreditDaysOffset, ' + 
                                             'ppcMinInvoiceValue, ' + 
                                             'ppcInterestGLCode, ' + 
                                             'ppcDebtChargeGLCode, ' + 
                                             'ppcCostCentre, ' + 
                                             'ppcDepartment, ' + 
                                             'ppcDebitChargeBasis, ' + 
                                             'ppcActive, ' + 
                                             'ppcSyncGLCodes, ' + 
                                             'ppcDummyChar' + 
                                             ') ' + 
              'VALUES (' + 
                       ':ppcCustCode, ' + 
                       ':ppcDefaultRate, ' + 
                       ':ppcInterestVariance, ' + 
                       ':ppcCreditDaysOffset, ' + 
                       ':ppcMinInvoiceValue, ' + 
                       ':ppcInterestGLCode, ' + 
                       ':ppcDebtChargeGLCode, ' + 
                       ':ppcCostCentre, ' + 
                       ':ppcDepartment, ' + 
                       ':ppcDebitChargeBasis, ' + 
                       ':ppcActive, ' + 
                       ':ppcSyncGLCodes, ' + 
                       ':ppcDummyChar' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    ppcCustCodeParam := FindParam('ppcCustCode');
    ppcDefaultRateParam := FindParam('ppcDefaultRate');
    ppcInterestVarianceParam := FindParam('ppcInterestVariance');
    ppcCreditDaysOffsetParam := FindParam('ppcCreditDaysOffset');
    ppcMinInvoiceValueParam := FindParam('ppcMinInvoiceValue');
    ppcInterestGLCodeParam := FindParam('ppcInterestGLCode');
    ppcDebtChargeGLCodeParam := FindParam('ppcDebtChargeGLCode');
    ppcCostCentreParam := FindParam('ppcCostCentre');
    ppcDepartmentParam := FindParam('ppcDepartment');
    ppcDebitChargeBasisParam := FindParam('ppcDebitChargeBasis');
    ppcActiveParam := FindParam('ppcActive');
    ppcSyncGLCodesParam := FindParam('ppcSyncGLCodes');
    ppcDummyCharParam := FindParam('ppcDummyChar');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TPPCustDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Type
  TPPCustRec = record
    ppcCustCode : string[6];
    ppcDefaultRate : Double;
    ppcInterestVariance : Double;
    ppcCreditDaysOffset : LongInt;
    ppcMinInvoiceValue : Double;
    ppcInterestGLCode : LongInt;
    ppcDebtChargeGLCode : LongInt;
    ppcCostCentre : string[3];
    ppcDepartment : string[3];
    ppcDebitChargeBasis : byte; // 0 = N/A / 1 = per Transaction / 2 = perProcess
    ppcActive : Boolean;
    ppcSyncGLCodes : Boolean;
    ppcDummyChar : char;
    ppcSpare            : Array [1..200] of Char;
  end;{TPPCustRec}

Var
  DataRec : ^TPPCustRec;
  sTemp : ShortString;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    ppcCustCodeParam.Value := CreateVariantArray (@ppcCustCode, SizeOf(ppcCustCode));         // SQL=varbinary, Delphi=string[6]
    ppcDefaultRateParam.Value := ppcDefaultRate;                                              // SQL=float, Delphi=Double
    ppcInterestVarianceParam.Value := ppcInterestVariance;                                    // SQL=float, Delphi=Double
    ppcCreditDaysOffsetParam.Value := ppcCreditDaysOffset;                                    // SQL=int, Delphi=LongInt
    ppcMinInvoiceValueParam.Value := ppcMinInvoiceValue;                                      // SQL=float, Delphi=Double
    ppcInterestGLCodeParam.Value := ppcInterestGLCode;                                        // SQL=int, Delphi=LongInt
    ppcDebtChargeGLCodeParam.Value := ppcDebtChargeGLCode;                                    // SQL=int, Delphi=LongInt
    ppcCostCentreParam.Value := ppcCostCentre;                                                // SQL=varchar, Delphi=string[3]
    ppcDepartmentParam.Value := ppcDepartment;                                                // SQL=varchar, Delphi=string[3]
    ppcDebitChargeBasisParam.Value := ppcDebitChargeBasis;                                    // SQL=int, Delphi=byte
    ppcActiveParam.Value := ppcActive;                                                        // SQL=bit, Delphi=Boolean
    ppcSyncGLCodesParam.Value := ppcSyncGLCodes;                                              // SQL=bit, Delphi=Boolean
    ppcDummyCharParam.Value := Ord(ppcDummyChar);                                             // SQL=int, Delphi=char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

