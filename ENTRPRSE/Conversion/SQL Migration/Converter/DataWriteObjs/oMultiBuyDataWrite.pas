Unit oMultiBuyDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TMultiBuyDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    mbdOwnerTypeParam, mbdAcCodeParam, mbdStockCodeParam, mbdBuyQtyStringParam, 
    mbdCurrencyParam, mbdDiscountTypeParam, mbdStartDateParam, mbdEndDateParam, 
    mbdUseDatesParam, mbdBuyQtyParam, mbdRewardValueParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMultiBuyDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, MultiBuyVar;

//=========================================================================

Constructor TMultiBuyDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TMultiBuyDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMultiBuyDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].MULTIBUY (' + 
                                               'mbdOwnerType, ' + 
                                               'mbdAcCode, ' + 
                                               'mbdStockCode, ' + 
                                               'mbdBuyQtyString, ' + 
                                               'mbdCurrency, ' + 
                                               'mbdDiscountType, ' + 
                                               'mbdStartDate, ' + 
                                               'mbdEndDate, ' + 
                                               'mbdUseDates, ' + 
                                               'mbdBuyQty, ' + 
                                               'mbdRewardValue' + 
                                               ') ' + 
              'VALUES (' + 
                       ':mbdOwnerType, ' + 
                       ':mbdAcCode, ' + 
                       ':mbdStockCode, ' + 
                       ':mbdBuyQtyString, ' + 
                       ':mbdCurrency, ' + 
                       ':mbdDiscountType, ' + 
                       ':mbdStartDate, ' + 
                       ':mbdEndDate, ' + 
                       ':mbdUseDates, ' + 
                       ':mbdBuyQty, ' + 
                       ':mbdRewardValue' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    mbdOwnerTypeParam := FindParam('mbdOwnerType');
    mbdAcCodeParam := FindParam('mbdAcCode');
    mbdStockCodeParam := FindParam('mbdStockCode');
    mbdBuyQtyStringParam := FindParam('mbdBuyQtyString');
    mbdCurrencyParam := FindParam('mbdCurrency');
    mbdDiscountTypeParam := FindParam('mbdDiscountType');
    mbdStartDateParam := FindParam('mbdStartDate');
    mbdEndDateParam := FindParam('mbdEndDate');
    mbdUseDatesParam := FindParam('mbdUseDates');
    mbdBuyQtyParam := FindParam('mbdBuyQty');
    mbdRewardValueParam := FindParam('mbdRewardValue');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TMultiBuyDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TMultiBuyDiscount;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    mbdOwnerTypeParam.Value := ConvertCharToSQLEmulatorVarChar(mbdOwnerType);               // SQL=char, Delphi=Char
    mbdAcCodeParam.Value := mbdAcCode;                          // SQL=varchar, Delphi=String[6]
    mbdStockCodeParam.Value := mbdStockCode;                    // SQL=varchar, Delphi=String[16]
    mbdBuyQtyStringParam.Value := mbdBuyQtyString;              // SQL=varchar, Delphi=String[20]
    mbdCurrencyParam.Value := mbdCurrency;                      // SQL=int, Delphi=Byte
    mbdDiscountTypeParam.Value := ConvertCharToSQLEmulatorVarChar(mbdDiscountType);         // SQL=char, Delphi=Char
    mbdStartDateParam.Value := mbdStartDate;                    // SQL=varchar, Delphi=LongDate
    mbdEndDateParam.Value := mbdEndDate;                        // SQL=varchar, Delphi=LongDate
    mbdUseDatesParam.Value := mbdUseDates;                      // SQL=bit, Delphi=Boolean
    mbdBuyQtyParam.Value := mbdBuyQty;                          // SQL=float, Delphi=Double
    mbdRewardValueParam.Value := mbdRewardValue;                // SQL=float, Delphi=Double
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

