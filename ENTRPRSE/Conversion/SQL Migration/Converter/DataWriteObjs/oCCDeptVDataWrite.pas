Unit oCCDeptVDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TCCDeptVDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    cdtypeParam, cdglcodeParam, cdcostcentreParam, cddepartmentParam, cddummycharParam, 
    cdvatcodeParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCCDeptVDataWrite

Implementation

Uses Graphics, Variants, SQLConvertUtils;

//=========================================================================

Constructor TCCDeptVDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TCCDeptVDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCCDeptVDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].CCDeptV (' + 
                                              'cdtype, ' + 
                                              'cdglcode, ' + 
                                              'cdcostcentre, ' + 
                                              'cddepartment, ' + 
                                              'cddummychar, ' + 
                                              'cdvatcode' + 
                                              ') ' + 
              'VALUES (' + 
                       ':cdtype, ' + 
                       ':cdglcode, ' + 
                       ':cdcostcentre, ' + 
                       ':cddepartment, ' + 
                       ':cddummychar, ' + 
                       ':cdvatcode' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    cdtypeParam := FindParam('cdtype');
    cdglcodeParam := FindParam('cdglcode');
    cdcostcentreParam := FindParam('cdcostcentre');
    cddepartmentParam := FindParam('cddepartment');
    cddummycharParam := FindParam('cddummychar');
    cdvatcodeParam := FindParam('cdvatcode');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TCCDeptVDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Type
  // Note: This structure has been copied from svn://bmtdev1/generic/CCDeptValidation/trunk/COMMON/BTFile.pas
  // as it isn't possible for the SQL Data Migration to reference that code directly.
  TCCDeptRec = record
    cdType             : char;
    cdGLCode           : LongInt;
    cdCostCentre       : String[3];
    cdDepartment       : String[3];
    cdDummyChar        : char;
    cdVATCode          : char;
    cdSpare            : Array [1..499] of byte;
  end;{TCCDeptRec}

Var
  DataRec : ^TCCDeptRec;
  sTemp : ShortString;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    cdtypeParam.Value := ConvertCharToSQLEmulatorVarChar(cdType);         // SQL=varchar, Delphi=char
    cdglcodeParam.Value := cdGLCode;                                      // SQL=int, Delphi=LongInt
    cdcostcentreParam.Value := cdCostCentre;                              // SQL=varchar, Delphi=String[3]
    cddepartmentParam.Value := cdDepartment;                              // SQL=varchar, Delphi=String[3]
    cddummycharParam.Value := Ord(cdDummyChar);                           // SQL=int, Delphi=char
    cdvatcodeParam.Value := Ord(cdVATCode);                               // SQL=int, Delphi=char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

