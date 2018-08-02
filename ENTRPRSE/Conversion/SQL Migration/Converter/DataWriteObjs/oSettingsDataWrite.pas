Unit oSettingsDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TSettingsDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    f_field_1Param, f_field_3Param, image_0Param : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TSettingsDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils;

//=========================================================================

Constructor TSettingsDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TSettingsDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TSettingsDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].Settings (' +
                                               'f_field_1, ' +
                                               'f_field_3, ' +
                                               'image_0' +
                                               ') ' +
              'VALUES (' +
                       ':f_field_1, ' +
                       ':f_field_3, ' +
                       ':image_0' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    f_field_1Param := FindParam('f_field_1');
    f_field_3Param := FindParam('f_field_3');
    image_0Param := FindParam('image_0');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TSettingsDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Type
  // Artificial structure duplicating the SQL Structure of Settings.Dat under the emulator
  TFormSettingsRec = record
    fsRecType : char;
    fsLookup : String[120];
    fsData : Array [1..673] of Byte;
  End; // TFormSettingsRec
Var
  DataRec : ^TFormSettingsRec;
  sTemp : ShortString;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    f_field_1Param.Value := Ord(fsRecType);                                // SQL=int, Delphi=char

    // For unknown reasons the fsLookup field has been stripped of trailing Chr(0)'s in the database
    // when added through the SQL Emulator
    sTemp := fsLookup;
    While (sTemp[Length(sTemp)] = #0) Do
      Delete (sTemp, Length(sTemp), 1);
    f_field_3Param.Value := sTemp;                                      // SQL=varchar, Delphi=String[120]

    image_0Param.Value := CreateVariantArray (@fsData, SizeOf(fsData));    // SQL=image, Delphi=Array [1..673] of Byte
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

