Unit oPPDebtDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TPPDebtDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    ppdFolioNoParam, ppdCustCodeParam, ppdValueFromParam, ppdValueToParam, 
    ppdChargeParam, ppdDummyCharParam, ppdValueFromStrParam, ppdSpareParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TPPDebtDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils;

//=========================================================================

Constructor TPPDebtDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TPPDebtDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TPPDebtDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].PPDebt (' + 
                                             'ppdFolioNo, ' + 
                                             'ppdCustCode, ' + 
                                             'ppdValueFrom, ' + 
                                             'ppdValueTo, ' + 
                                             'ppdCharge, ' + 
                                             'ppdDummyChar, ' + 
                                             'ppdValueFromStr, ' + 
                                             'ppdSpare' + 
                                             ') ' + 
              'VALUES (' + 
                       ':ppdFolioNo, ' + 
                       ':ppdCustCode, ' + 
                       ':ppdValueFrom, ' + 
                       ':ppdValueTo, ' + 
                       ':ppdCharge, ' + 
                       ':ppdDummyChar, ' + 
                       ':ppdValueFromStr, ' + 
                       ':ppdSpare' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    ppdFolioNoParam := FindParam('ppdFolioNo');
    ppdCustCodeParam := FindParam('ppdCustCode');
    ppdValueFromParam := FindParam('ppdValueFrom');
    ppdValueToParam := FindParam('ppdValueTo');
    ppdChargeParam := FindParam('ppdCharge');
    ppdDummyCharParam := FindParam('ppdDummyChar');
    ppdValueFromStrParam := FindParam('ppdValueFromStr');
    ppdSpareParam := FindParam('ppdSpare');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TPPDebtDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Type
  TPPDebtRec = record
    ppdFolioNo : LongInt;
    ppdCustCode : string[6];
    ppdValueFrom : Double;
    ppdValueTo : Double;
    ppdCharge : Double;
    ppdDummyChar : char;
    ppdValueFromStr4SQL : string[25]; // Added to fix SQL problems with floating point indexes
    ppdSpare : Array [1..74] of Char;
  end;{TPPDeptRec}

Var
  DataRec : ^TPPDebtRec;
  sTemp : ShortString;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    ppdFolioNoParam.Value := ppdFolioNo;                                                      // SQL=int, Delphi=LongInt
    ppdCustCodeParam.Value := CreateVariantArray (@ppdCustCode, SizeOf(ppdCustCode));         // SQL=varbinary, Delphi=string[6]
    ppdValueFromParam.Value := ppdValueFrom;                                                  // SQL=float, Delphi=Double
    ppdValueToParam.Value := ppdValueTo;                                                      // SQL=float, Delphi=Double
    ppdChargeParam.Value := ppdCharge;                                                        // SQL=float, Delphi=Double
    ppdDummyCharParam.Value := Ord(ppdDummyChar);                                             // SQL=int, Delphi=char
    ppdValueFromStrParam.Value := ppdValueFromStr4SQL;                                        // SQL=varchar, Delphi=string[25]
    ppdSpareParam.Value := CreateVariantArray (@ppdSpare, SizeOf(ppdSpare));                  // SQL=varbinary, Delphi=Array [1..74] of Char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

