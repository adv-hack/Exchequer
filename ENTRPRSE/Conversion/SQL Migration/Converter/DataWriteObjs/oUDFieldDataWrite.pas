Unit oUDFieldDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TUDFieldDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    fiFolioNoParam, fiEntityFolioParam, fiLineNoParam, fiDescriptionParam, 
    fiValidationModeParam, fiWindowCaptionParam, fiLookupRefParam, fiDummyCharParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TUDFieldDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

Type
  // Import the structures for the User Defined Fields Plug-In - have to use short file names
  {$I X:\PlugIns\UserDe~1\COMMON\UDStructures.Inc}

//=========================================================================

Constructor TUDFieldDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TUDFieldDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TUDFieldDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].udfield (' + 
                                              'fiFolioNo, ' + 
                                              'fiEntityFolio, ' + 
                                              'fiLineNo, ' + 
                                              'fiDescription, ' + 
                                              'fiValidationMode, ' + 
                                              'fiWindowCaption, ' + 
                                              'fiLookupRef, ' + 
                                              'fiDummyChar' + 
                                              ') ' + 
              'VALUES (' + 
                       ':fiFolioNo, ' + 
                       ':fiEntityFolio, ' + 
                       ':fiLineNo, ' + 
                       ':fiDescription, ' + 
                       ':fiValidationMode, ' + 
                       ':fiWindowCaption, ' + 
                       ':fiLookupRef, ' + 
                       ':fiDummyChar' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    fiFolioNoParam := FindParam('fiFolioNo');
    fiEntityFolioParam := FindParam('fiEntityFolio');
    fiLineNoParam := FindParam('fiLineNo');
    fiDescriptionParam := FindParam('fiDescription');
    fiValidationModeParam := FindParam('fiValidationMode');
    fiWindowCaptionParam := FindParam('fiWindowCaption');
    fiLookupRefParam := FindParam('fiLookupRef');
    fiDummyCharParam := FindParam('fiDummyChar');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TUDFieldDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TFieldRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    fiFolioNoParam.Value := fiFolioNo;                       // SQL=int, Delphi=LongInt
    fiEntityFolioParam.Value := fiEntityFolio;               // SQL=int, Delphi=LongInt
    fiLineNoParam.Value := fiLineNo;                         // SQL=int, Delphi=LongInt
    fiDescriptionParam.Value := fiDescription;               // SQL=varchar, Delphi=string[60]
    fiValidationModeParam.Value := fiValidationMode;         // SQL=int, Delphi=LongInt
    fiWindowCaptionParam.Value := fiWindowCaption;           // SQL=varchar, Delphi=string[60]
    fiLookupRefParam.Value := fiLookupRef;                   // SQL=varchar, Delphi=String[20]
    fiDummyCharParam.Value := Ord(fiDummyChar);              // SQL=int, Delphi=char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

