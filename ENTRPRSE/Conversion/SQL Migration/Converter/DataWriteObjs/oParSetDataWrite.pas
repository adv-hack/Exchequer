Unit oParSetDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TParSetDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    psExeNameParam, psUserNameParam, psWindowNameParam, psNameParam, psBackgroundColorParam, 
    psFontNameParam, psFontSizeParam, psFontColorParam, psFontStyleParam, 
    psHeaderBackgroundColorParam, psHeaderFontNameParam, psHeaderFontSizeParam, 
    psHeaderFontColorParam, psHeaderFontStyleParam, psHighlightBackgroundColorParam, 
    psHighlightFontColorParam, psHighlightFontStyleParam, psMultiSelectBackgroundColorParam, 
    psMultiSelectFontColorParam, psMultiSelectFontStyleParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TParSetDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils;

//=========================================================================

Constructor TParSetDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TParSetDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TParSetDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ParSet (' + 
                                             'psExeName, ' + 
                                             'psUserName, ' + 
                                             'psWindowName, ' + 
                                             'psName, ' + 
                                             'psBackgroundColor, ' + 
                                             'psFontName, ' + 
                                             'psFontSize, ' + 
                                             'psFontColor, ' + 
                                             'psFontStyle, ' + 
                                             'psHeaderBackgroundColor, ' + 
                                             'psHeaderFontName, ' + 
                                             'psHeaderFontSize, ' + 
                                             'psHeaderFontColor, ' + 
                                             'psHeaderFontStyle, ' + 
                                             'psHighlightBackgroundColor, ' + 
                                             'psHighlightFontColor, ' + 
                                             'psHighlightFontStyle, ' + 
                                             'psMultiSelectBackgroundColor, ' + 
                                             'psMultiSelectFontColor, ' + 
                                             'psMultiSelectFontStyle' + 
                                             ') ' + 
              'VALUES (' + 
                       ':psExeName, ' + 
                       ':psUserName, ' + 
                       ':psWindowName, ' + 
                       ':psName, ' + 
                       ':psBackgroundColor, ' + 
                       ':psFontName, ' + 
                       ':psFontSize, ' + 
                       ':psFontColor, ' + 
                       ':psFontStyle, ' + 
                       ':psHeaderBackgroundColor, ' + 
                       ':psHeaderFontName, ' + 
                       ':psHeaderFontSize, ' + 
                       ':psHeaderFontColor, ' + 
                       ':psHeaderFontStyle, ' + 
                       ':psHighlightBackgroundColor, ' + 
                       ':psHighlightFontColor, ' +
                       ':psHighlightFontStyle, ' + 
                       ':psMultiSelectBackgroundColor, ' + 
                       ':psMultiSelectFontColor, ' + 
                       ':psMultiSelectFontStyle' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    psExeNameParam := FindParam('psExeName');
    psUserNameParam := FindParam('psUserName');
    psWindowNameParam := FindParam('psWindowName');
    psNameParam := FindParam('psName');
    psBackgroundColorParam := FindParam('psBackgroundColor');
    psFontNameParam := FindParam('psFontName');
    psFontSizeParam := FindParam('psFontSize');
    psFontColorParam := FindParam('psFontColor');
    psFontStyleParam := FindParam('psFontStyle');
    psHeaderBackgroundColorParam := FindParam('psHeaderBackgroundColor');
    psHeaderFontNameParam := FindParam('psHeaderFontName');
    psHeaderFontSizeParam := FindParam('psHeaderFontSize');
    psHeaderFontColorParam := FindParam('psHeaderFontColor');
    psHeaderFontStyleParam := FindParam('psHeaderFontStyle');
    psHighlightBackgroundColorParam := FindParam('psHighlightBackgroundColor');
    psHighlightFontColorParam := FindParam('psHighlightFontColor');
    psHighlightFontStyleParam := FindParam('psHighlightFontStyle');
    psMultiSelectBackgroundColorParam := FindParam('psMultiSelectBackgroundColor');
    psMultiSelectFontColorParam := FindParam('psMultiSelectFontColor');
    psMultiSelectFontStyleParam := FindParam('psMultiSelectFontStyle');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TParSetDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TParentSettingsRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    psExeNameParam.Value := psExeName;                                               // SQL=varchar, Delphi=string[20]
    psUserNameParam.Value := psUserName;                                             // SQL=varchar, Delphi=string[10]
    psWindowNameParam.Value := psWindowName;                                         // SQL=varchar, Delphi=string[40]
    psNameParam.Value := psName;                                                     // SQL=varchar, Delphi=string[40]
    psBackgroundColorParam.Value := psBackgroundColor;                               // SQL=int, Delphi=TColor
    psFontNameParam.Value := psFontName;                                             // SQL=varchar, Delphi=string[40]
    psFontSizeParam.Value := psFontSize;                                             // SQL=int, Delphi=LongInt
    psFontColorParam.Value := psFontColor;                                           // SQL=int, Delphi=TColor
    psFontStyleParam.Value := psFontStyle;                                           // SQL=int, Delphi=Byte
    psHeaderBackgroundColorParam.Value := psHeaderBackgroundColor;                   // SQL=int, Delphi=TColor
    psHeaderFontNameParam.Value := psHeaderFontName;                                 // SQL=varchar, Delphi=string[40]
    psHeaderFontSizeParam.Value := psHeaderFontSize;                                 // SQL=int, Delphi=LongInt
    psHeaderFontColorParam.Value := psHeaderFontColor;                               // SQL=int, Delphi=TColor
    psHeaderFontStyleParam.Value := psHeaderFontStyle;                               // SQL=int, Delphi=Byte
    psHighlightBackgroundColorParam.Value := psHighlightBackgroundColor;             // SQL=int, Delphi=TColor
    psHighlightFontColorParam.Value := psHighlightFontColor;                         // SQL=int, Delphi=TColor
    psHighlightFontStyleParam.Value := psHighlightFontStyle;                         // SQL=int, Delphi=Byte
    psMultiSelectBackgroundColorParam.Value := psMultiSelectBackgroundColor;         // SQL=int, Delphi=TColor
    psMultiSelectFontColorParam.Value := psMultiSelectFontColor;                     // SQL=int, Delphi=TColor
    psMultiSelectFontStyleParam.Value := psMultiSelectFontStyle;                     // SQL=int, Delphi=Byte
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

