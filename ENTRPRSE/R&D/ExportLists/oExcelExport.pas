Unit oExcelExport;

Interface

// MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists

Uses SysUtils, Dialogs, Registry, Windows, ExportListIntf, XLUtils_TLB;


// Returns TRUE if Excel is installed
Function ExcelInstalled : Boolean;
// Returns TRUE if our .NET Assembly that wraps Excel is registered
Function ExcelWrapperInstalled : Boolean;

// Returns a new instance of an "Export Btrieve List To Excel" object
Function NewExcelListExport : IExportListData;

Implementation

Uses VarConst,
     {$IFDEF MC_On}
       CurrncyU, BTSupU2,
     {$ENDIF MC_On}
     ETDateU, StrUtil;

Type
  TExportBtrieveListDataToExcel = Class(TInterfacedObject, IExportListData)
  private
    // Reference to Exchequer.ExcelUtilities COM Object
    ExcelUtilsIntf : IExchequerExcelUtilities;

    Procedure BreakDownNumber (Const ColumnData : ANSIString;
                               Var   CurrencySymbol, Number : ANSIString;
                               Const ExtractCurrency : Boolean = False);

    Function CreateNumberFormat (Const CurrencySymbol : ANSIString;
                                 Const DecimalPlaces : Integer) : ANSIString;
  protected
    FExportTitle : ANSIString;

    // IExportListData
    Function GetExportTitle : ANSIString;
    Procedure SetExportTitle (Value : ANSIString);

    Function StartExport : Boolean;
    Procedure FinishExport;

    Procedure AddColumnTitle (Const ColumnTitle, MetaData : ANSIString);
    Procedure AddColumnData (Const ColumnData, MetaData : ANSIString);
    Procedure NewRow;

  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TExportBtrieveListDataToExcel


//=========================================================================

Procedure ODS (DebugString : ANSIString);
Begin // ODS
//  DebugString := 'Exchequer.' + DebugString;
//  OutputDebugString (PCHAR(DebugString));
End; // ODS

//=========================================================================

// Returns TRUE if Excel is installed
Function ExcelInstalled : Boolean;
Begin // ExcelInstalled
  With TRegistry.Create Do
   Try
     Access := KEY_READ;
     RootKey := HKEY_CLASSES_ROOT;

     // Look for the registry key of the Excel Automation COM Object
     Result := KeyExists ('Excel.Application');
   Finally
     Free;
   End;
End; // ExcelInstalled

//-------------------------------------------------------------------------

// Returns TRUE if our .NET Assembly that wraps Excel is registered
Function ExcelWrapperInstalled : Boolean;
Begin // ExcelWrapperInstalled
  With TRegistry.Create Do
   Try
     Access := KEY_READ;
     RootKey := HKEY_CLASSES_ROOT;

     // Look for the registry key of the Exchequer .NET Assembly wrapping Excel.Application
     Result := KeyExists ('Exchequer.ExcelUtilities');
   Finally
     Free;
   End;
End; // ExcelWrapperInstalled

//=========================================================================

// Returns a new instance of an "Export Btrieve List To Excel" object
Function NewExcelListExport : IExportListData;
Begin // NewExcelListExport
  Result := TExportBtrieveListDataToExcel.Create;
End; // NewExcelListExport

//-------------------------------------------------------------------------

Constructor TExportBtrieveListDataToExcel.Create;
Begin // Create
  Inherited Create;
  ExcelUtilsIntf := Nil;
End; // Create

//-----------------------------------

Destructor TExportBtrieveListDataToExcel.Destroy;
Begin // Destroy
  ExcelUtilsIntf := Nil;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TExportBtrieveListDataToExcel.StartExport : Boolean;
Begin // StartExport
  Try
    // Connect to Excel Utilities COM Object
    ExcelUtilsIntf := CoExcelUtilities.Create;

    // Link to Excel
    If ExcelUtilsIntf.ConnectToExcel Then
    Begin
      // Create new worksheet
      ExcelUtilsIntf.CreateWorksheet(FExportTitle);

      Result := True;
    End // If ExcelUtilsIntf.ConnectToExcel
    Else
      Result := False;
  Except
    Result := False;
    ExcelUtilsIntf := NIL;
  End; // Try..Finally
End; // StartExport

//-------------------------------------------------------------------------

Procedure TExportBtrieveListDataToExcel.FinishExport;
Begin // FinishExport
  // Close the link from the COM object to Excel and then shutdown the COM object
  If Assigned(ExcelUtilsIntf) Then
    ExcelUtilsIntf.DisconnectFromExcel;
  ExcelUtilsIntf := NIL;
End; // FinishExport

//-------------------------------------------------------------------------

Procedure TExportBtrieveListDataToExcel.AddColumnTitle (Const ColumnTitle, MetaData : ANSIString);
Begin // AddColumnTitle
ODS ('AddColumnTitle(' + ColumnTitle + ', ' + MetaData + ')');
  If Assigned(ExcelUtilsIntf) Then
    ExcelUtilsIntf.AddColumnTitle(ColumnTitle, MetaData);
End; // AddColumnTitle

//-----------------------------------

Procedure TExportBtrieveListDataToExcel.BreakDownNumber (Const ColumnData : ANSIString;
                                                         Var   CurrencySymbol, Number : ANSIString;
                                                         Const ExtractCurrency : Boolean = False);
Var
  bNegative : Boolean;
  I, cStart : Integer;
  sCurrSymbol : ShortString;
Begin // BreakDownNumber
  CurrencySymbol := '';
  Number := '';

  {$IFDEF MC_On}
  // MH 10/05/2018 2018-R1.1 ABSEXCH-20500: Modified to match against the Currency List for the Currency Symbol
  //                                        instead of just taking any non-numerial prefix as the currency
  If ExtractCurrency Then
  Begin
    // Run through the currency list looking for a match
    For I := 1 To High(SyssCurr^.Currencies) Do
      If IsCurrencyUsed (I) Then
      Begin
        sCurrSymbol := Trim(TxLatePound(SyssCurr^.Currencies[I].SSymb, True));
        If (Pos(sCurrSymbol, ColumnData) = 1) Then
        Begin
          CurrencySymbol := sCurrSymbol;
          Break;
        End; // If (Pos(SyssCurr^.Currencies[I].SSymb, ColumnData) = 1)
      End; // If IsCurrencyUsed (I)
  End; // If ExtractCurrency
  {$ENDIF}

  // Skip any extracted currency symbol
  cStart := Length(CurrencySymbol) + 1;
  bNegative := False;
  For I := cStart To Length(ColumnData) Do
  Begin
    If (ColumnData[I] = '-') Then
      // Check for negative sign
      bNegative := True
    Else
      // Otherwise must be part of the number
      Number := Number + ColumnData[I];
  End; // For cStart

  // Excel requires the negative sign to be at the start of the number
  If bNegative Then
    Number := '-' + Number;
End; // BreakDownNumber

//-----------------------------------

//
// Separate Currency and Number elements, examples of incoming ColumnData:-
//
//   £12,006.86
//   £240.00-
//   NZD261.00
//   €704.20
//   1,234.567
Function TExportBtrieveListDataToExcel.CreateNumberFormat (Const CurrencySymbol : ANSIString;
                                                           Const DecimalPlaces : Integer) : ANSIString;
Var
  I : Integer;
Begin // CreateNumberFormat
  Result := '#,##0';

  If (CurrencySymbol <> '') Then
    // Insert the currency symbol at the start with the required symbol/text in double-quotes
    Result := '"' + CurrencySymbol + '"' + Result;

  If (DecimalPlaces > 0) Then
  Begin
    // Add the required number of decimal places
    Result := Result + '.';
    For I := 1 To DecimalPlaces Do
      Result := Result + '0';
  End; // If (DecimalPlaces > 0)
End; // CreateNumberFormat

//-----------------------------------

Procedure TExportBtrieveListDataToExcel.AddColumnData (Const ColumnData, MetaData : ANSIString);
Var
  CurrencySymbol, Number, NumberFormat : ANSIString;
  ModifiedColumnData : ANSIString;
  I : Integer;
Begin // AddColumnData
ODS ('AddColumnData(' + ColumnData + ', ' + MetaData + ')');
  If Assigned(ExcelUtilsIntf) Then
  Begin
    // Quantity field --------------------------------------
    If (Pos(emtQuantity, MetaData) > 0) Then
    Begin
      // Process the supplied values and redirect to AddColumnDataNumber to allow a formatted number
      BreakDownNumber (ColumnData, CurrencySymbol, Number);
      NumberFormat := CreateNumberFormat (CurrencySymbol, Syss.NoQtyDec);
//      ShowMessage ('Qty(ColumnData=''' + ColumnData + ''', MetaData=''' + MetaData + ''', CurrencySymbol=''' + CurrencySymbol + ''', Number=''' + Number + ''', NumberFormat=''' + NumberFormat + ''')');
      ExcelUtilsIntf.AddColumnDataNumber(Number, NumberFormat, MetaData);
    End // If (Pos(emtQuantity, MetaData) > 0)

    // Currency and Non-Currency fields --------------------
    Else If (Pos(emtCurrencyAmount, MetaData) > 0) Or (Pos(emtNonCurrencyAmount, MetaData) > 0) Then
    Begin
      // Process the supplied values and redirect to AddColumnDataNumber to allow a formatted number
      BreakDownNumber (ColumnData, CurrencySymbol, Number, Pos(emtCurrencyAmount, MetaData) > 0);

      // Look for flags indicating Cost/Sales decimal places
      If (Pos(emtCostPrice, MetaData) > 0) Then
        NumberFormat := CreateNumberFormat (CurrencySymbol, Syss.NoCosDec)
      Else If (Pos(emtSalesPrice, MetaData) > 0) Then
        NumberFormat := CreateNumberFormat (CurrencySymbol, Syss.NoNetDec)
      Else
        NumberFormat := CreateNumberFormat (CurrencySymbol, 2);

//      ShowMessage ('Amount(ColumnData=''' + ColumnData + ''', MetaData=''' + MetaData + ''', CurrencySymbol=''' + CurrencySymbol + ''', Number=''' + Number + ''', NumberFormat=''' + NumberFormat + ''')');
      ExcelUtilsIntf.AddColumnDataNumber(Number, NumberFormat, MetaData);
    End // Else If (Pos(emtCurrencyAmount, MetaData) > 0) Or (Pos(emtNonCurrencyAmount, MetaData) > 0)

    // Date fields -----------------------------------------
    Else If (Pos(emtDate, MetaData) > 0) Then
    Begin
      // Need to reformate the date as Exchequer doesn't support 3 character months, e.g. Jan, so Excel
      // crashes when ShortDateFormat is set to a 3 character month and Exchequer supplies a 2 digit month
      ModifiedColumnData := '';
      // Strip out any separators from the formatted date
      For I := 1 To Length(ColumnData) Do
        If (ColumnData[I] In ['0'..'9']) Then
          ModifiedColumnData := ModifiedColumnData + ColumnData[I];

      // Reformat in US Format for MS Excel
      If (ModifiedColumnData <> '') Then
        ModifiedColumnData := FormatDateTime('mm/dd/yyyy', ToDateTime(Date2Store(ModifiedColumnData)));

      ExcelUtilsIntf.AddColumnData(ModifiedColumnData, MetaData);
    End // Else If (Pos(emtDate, MetaData) > 0)

    // Default handling ------------------------------------
    Else
      ExcelUtilsIntf.AddColumnData(ColumnData, MetaData);
  End; // If Assigned(ExcelUtilsIntf)
End; // AddColumnData

//-----------------------------------

Procedure TExportBtrieveListDataToExcel.NewRow;
Begin // NewRow
  If Assigned(ExcelUtilsIntf) Then
    ExcelUtilsIntf.NewRow;
End; // NewRow

//-------------------------------------------------------------------------

Function TExportBtrieveListDataToExcel.GetExportTitle : ANSIString;
Begin // GetExportTitle
  Result := FExportTitle;
End; // GetExportTitle
Procedure TExportBtrieveListDataToExcel.SetExportTitle (Value : ANSIString);
Begin // SetExportTitle
  FExportTitle := Value;
End; // SetExportTitle

//=========================================================================

End.
