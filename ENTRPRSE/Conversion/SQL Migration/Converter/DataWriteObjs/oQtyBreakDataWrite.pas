Unit oQtyBreakDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TQtyBreakDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    qbFolioParam, qbAcCodeParam, qbStockFolioParam, qbCurrencyParam, qbStartDateParam, 
    qbEndDateParam, qbQtyToStringParam, qbQtyToParam, qbQtyFromParam, qbBreakTypeParam, 
    qbPriceBandParam, qbSpecialPriceParam, qbDiscountPercentParam, qbDiscountAmountParam, 
    qbMarginOrMarkupParam, qbUseDatesParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TQtyBreakDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, QtyBreakVar;

//=========================================================================

Constructor TQtyBreakDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TQtyBreakDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TQtyBreakDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].QtyBreak (' + 
                                               'qbFolio, ' + 
                                               'qbAcCode, ' + 
                                               'qbStockFolio, ' + 
                                               'qbCurrency, ' + 
                                               'qbStartDate, ' + 
                                               'qbEndDate, ' + 
                                               'qbQtyToString, ' + 
                                               'qbQtyTo, ' + 
                                               'qbQtyFrom, ' + 
                                               'qbBreakType, ' + 
                                               'qbPriceBand, ' + 
                                               'qbSpecialPrice, ' + 
                                               'qbDiscountPercent, ' + 
                                               'qbDiscountAmount, ' +
                                               'qbMarginOrMarkup, ' + 
                                               'qbUseDates' + 
                                               ') ' + 
              'VALUES (' + 
                       ':qbFolio, ' + 
                       ':qbAcCode, ' + 
                       ':qbStockFolio, ' + 
                       ':qbCurrency, ' + 
                       ':qbStartDate, ' + 
                       ':qbEndDate, ' + 
                       ':qbQtyToString, ' + 
                       ':qbQtyTo, ' + 
                       ':qbQtyFrom, ' + 
                       ':qbBreakType, ' + 
                       ':qbPriceBand, ' + 
                       ':qbSpecialPrice, ' + 
                       ':qbDiscountPercent, ' + 
                       ':qbDiscountAmount, ' + 
                       ':qbMarginOrMarkup, ' + 
                       ':qbUseDates' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    qbFolioParam := FindParam('qbFolio');
    qbAcCodeParam := FindParam('qbAcCode');
    qbStockFolioParam := FindParam('qbStockFolio');
    qbCurrencyParam := FindParam('qbCurrency');
    qbStartDateParam := FindParam('qbStartDate');
    qbEndDateParam := FindParam('qbEndDate');
    qbQtyToStringParam := FindParam('qbQtyToString');
    qbQtyToParam := FindParam('qbQtyTo');
    qbQtyFromParam := FindParam('qbQtyFrom');
    qbBreakTypeParam := FindParam('qbBreakType');
    qbPriceBandParam := FindParam('qbPriceBand');
    qbSpecialPriceParam := FindParam('qbSpecialPrice');
    qbDiscountPercentParam := FindParam('qbDiscountPercent');
    qbDiscountAmountParam := FindParam('qbDiscountAmount');
    qbMarginOrMarkupParam := FindParam('qbMarginOrMarkup');
    qbUseDatesParam := FindParam('qbUseDates');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TQtyBreakDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TQtyBreakRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    qbFolioParam.Value := qbFolio;                                                  // SQL=int, Delphi=longint
    qbAcCodeParam.Value := qbAcCode;                                                // SQL=varchar, Delphi=String[6]
    qbStockFolioParam.Value := qbStockFolio;                                        // SQL=int, Delphi=longint
    qbCurrencyParam.Value := qbCurrency;                                            // SQL=int, Delphi=Byte
    qbStartDateParam.Value := qbStartDate;                                          // SQL=varchar, Delphi=LongDate
    qbEndDateParam.Value := qbEndDate;                                              // SQL=varchar, Delphi=LongDate
    qbQtyToStringParam.Value := qbQtyToString;                                      // SQL=varchar, Delphi=string[16]
    qbQtyToParam.Value := qbQtyTo;                                                  // SQL=float, Delphi=Double
    qbQtyFromParam.Value := qbQtyFrom;                                              // SQL=float, Delphi=Double
    qbBreakTypeParam.Value := qbBreakType;                                          // SQL=int, Delphi=Byte
    qbPriceBandParam.Value := ConvertCharToSQLEmulatorVarChar(qbPriceBand);         // SQL=varchar, Delphi=Char
    qbSpecialPriceParam.Value := qbSpecialPrice;                                    // SQL=float, Delphi=Double
    qbDiscountPercentParam.Value := qbDiscountPercent;                              // SQL=float, Delphi=Double
    qbDiscountAmountParam.Value := qbDiscountAmount;                                // SQL=float, Delphi=Double
    qbMarginOrMarkupParam.Value := qbMarginOrMarkup;                                // SQL=float, Delphi=Double
    qbUseDatesParam.Value := qbUseDates;                                            // SQL=bit, Delphi=Boolean
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

