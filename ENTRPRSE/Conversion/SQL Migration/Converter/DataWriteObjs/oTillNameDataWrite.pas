Unit oTillNameDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TTillNameDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    f_field_1Param, f_field_2Param, image_0Param : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TTillNameDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils;

//=========================================================================

Constructor TTillNameDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TTillNameDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TTillNameDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO common.TILLNAME (' +
                                            'f_field_1, ' +
                                            'f_field_2, ' +
                                            'image_0' +
                                            ') ' +
              'VALUES (' +
                       ':f_field_1, ' +
                       ':f_field_2, ' +
                       ':image_0' +
                       ')';
  FADOQuery.SQL.Text := sqlQuery;
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    f_field_1Param := FindParam('f_field_1');
    f_field_2Param := FindParam('f_field_2');
    image_0Param := FindParam('image_0');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TTillNameDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
type
  TTillNamesRec = Record
    RecPfix: Char;
    Name: string[30];
    Image: array[1..4065] of Byte;
  end;{TTillNamesRec}
Var
  DataRec : ^TTillNamesRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    f_field_1Param.Value := Ord(RecPFix);                                         // SQL=int, Delphi=
    f_field_2Param.Value := CreateVariantArray (@Name, SizeOf(Name));// SQL=varbinary, Delphi=
    image_0Param.Value := CreateVariantArray(@Image, SizeOf(Image));                                           // SQL=image, Delphi=
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

