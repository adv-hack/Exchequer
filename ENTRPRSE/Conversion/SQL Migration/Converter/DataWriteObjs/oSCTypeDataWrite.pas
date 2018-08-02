Unit oSCTypeDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TSCTypeDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    sctFolioNoParam, sctDescriptionParam, sctDummyCharParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TSCTypeDataWrite

Implementation

Uses Graphics, Variants, SQLConvertUtils;

//=========================================================================

Constructor TSCTypeDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TSCTypeDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TSCTypeDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].SCType (' + 
                                             'sctFolioNo, ' + 
                                             'sctDescription, ' + 
                                             'sctDummyChar' + 
                                             ') ' + 
              'VALUES (' + 
                       ':sctFolioNo, ' + 
                       ':sctDescription, ' + 
                       ':sctDummyChar' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    sctFolioNoParam := FindParam('sctFolioNo');
    sctDescriptionParam := FindParam('sctDescription');
    sctDummyCharParam := FindParam('sctDummyChar');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TSCTypeDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Type
  // Note: This structure has been copied from U:\BESPOKE\EXCHEQR\PromPay\Shared\BTFile.Pas
  // as it isn't possible for the SQL Data Migration to reference that code directly.
  TSalesCodeTypeRec = record
    sctFolioNo          : LongInt;
    sctDescription      : string[10];
    sctDummyChar        : char;
    sctSpare            : Array [1..200] of Char;
  end;{TSalesCodeTypeRec}

Var
  DataRec : ^TSalesCodeTypeRec;
  sTemp : ShortString;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    sctFolioNoParam.Value := sctFolioNo;                  // SQL=int, Delphi=LongInt
    sctDescriptionParam.Value := sctDescription;          // SQL=varchar, Delphi=string[10]
    sctDummyCharParam.Value := Ord(sctDummyChar);         // SQL=int, Delphi=char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

