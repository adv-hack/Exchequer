Unit oCommssnDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TCommssnDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    cmFolioNoParam, cmSalesCodeFolioNoParam, cmByParam, cmCustCodeParam, 
    cmProductCodeParam, cmPGroupCodeParam, cmByQtyParam, cmQtyFromParam, 
    cmQtyToParam, cmByCurrencyParam, cmCurrencyParam, cmByDateParam, cmStartDateParam, 
    cmEndDateParam, cmCommissionBasisParam, cmCommissionParam, cmCommissionTypeParam, 
    cmDummyCharParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCommssnDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils;

//=========================================================================

Constructor TCommssnDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TCommssnDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCommssnDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].Commssn (' + 
                                              'cmFolioNo, ' + 
                                              'cmSalesCodeFolioNo, ' + 
                                              'cmBy, ' + 
                                              'cmCustCode, ' + 
                                              'cmProductCode, ' + 
                                              'cmPGroupCode, ' + 
                                              'cmByQty, ' + 
                                              'cmQtyFrom, ' + 
                                              'cmQtyTo, ' + 
                                              'cmByCurrency, ' + 
                                              'cmCurrency, ' + 
                                              'cmByDate, ' + 
                                              'cmStartDate, ' + 
                                              'cmEndDate, ' +
                                              'cmCommissionBasis, ' + 
                                              'cmCommission, ' + 
                                              'cmCommissionType, ' + 
                                              'cmDummyChar' + 
                                              ') ' + 
              'VALUES (' + 
                       ':cmFolioNo, ' + 
                       ':cmSalesCodeFolioNo, ' + 
                       ':cmBy, ' + 
                       ':cmCustCode, ' + 
                       ':cmProductCode, ' + 
                       ':cmPGroupCode, ' + 
                       ':cmByQty, ' + 
                       ':cmQtyFrom, ' + 
                       ':cmQtyTo, ' + 
                       ':cmByCurrency, ' + 
                       ':cmCurrency, ' + 
                       ':cmByDate, ' + 
                       ':cmStartDate, ' + 
                       ':cmEndDate, ' + 
                       ':cmCommissionBasis, ' + 
                       ':cmCommission, ' + 
                       ':cmCommissionType, ' + 
                       ':cmDummyChar' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    cmFolioNoParam := FindParam('cmFolioNo');
    cmSalesCodeFolioNoParam := FindParam('cmSalesCodeFolioNo');
    cmByParam := FindParam('cmBy');
    cmCustCodeParam := FindParam('cmCustCode');
    cmProductCodeParam := FindParam('cmProductCode');
    cmPGroupCodeParam := FindParam('cmPGroupCode');
    cmByQtyParam := FindParam('cmByQty');
    cmQtyFromParam := FindParam('cmQtyFrom');
    cmQtyToParam := FindParam('cmQtyTo');
    cmByCurrencyParam := FindParam('cmByCurrency');
    cmCurrencyParam := FindParam('cmCurrency');
    cmByDateParam := FindParam('cmByDate');
    cmStartDateParam := FindParam('cmStartDate');
    cmEndDateParam := FindParam('cmEndDate');
    cmCommissionBasisParam := FindParam('cmCommissionBasis');
    cmCommissionParam := FindParam('cmCommission');
    cmCommissionTypeParam := FindParam('cmCommissionType');
    cmDummyCharParam := FindParam('cmDummyChar');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TCommssnDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Type
  // Note: This structure has been copied from U:\BESPOKE\EXCHEQR\PromPay\Shared\BTFile.Pas
  // as it isn't possible for the SQL Data Migration to reference that code directly.
  TCommissionRec = record
    cmFolioNo  : LongInt;
    cmSalesCodeFolioNo  : LongInt;
    cmBy              : LongInt; // 0 = Customer
                                // 1 = Customer + Product
                                // 2 = Customer + Product Group
                                // 3 = Product
                                // 4 = Product Group
    cmCustCode          : string[6];
    cmProductCode       : string[16];
    cmPGroupCode        : string[16];

    cmByQty             : boolean;
    cmQtyFrom           : double;
    cmQtyTo             : double;

    cmByCurrency        : boolean;
    cmCurrency          : LongInt;

    cmByDate            : boolean;
    cmStartDate         : string[8];
    cmEndDate           : string[8];

    cmCommissionBasis   : Byte;         // 0 = Total Value, 1 = Margin
    cmCommission        : double;
    cmCommissionType    : byte;         // 0 = Percentage, 1 = Amount

    cmDummyChar         : char;
    cmSpare             : Array [1..300] of Char;
  end;{TCommissionRec}

Var
  DataRec : ^TCommissionRec;
  sTemp : ShortString;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    cmFolioNoParam.Value := cmFolioNo;                           // SQL=int, Delphi=LongInt
    cmSalesCodeFolioNoParam.Value := cmSalesCodeFolioNo;         // SQL=int, Delphi=LongInt
    cmByParam.Value := cmBy;                                     // SQL=int, Delphi=LongInt
    cmCustCodeParam.Value := cmCustCode;                         // SQL=varchar, Delphi=string[6]
    cmProductCodeParam.Value := cmProductCode;                   // SQL=varchar, Delphi=string[16]
    cmPGroupCodeParam.Value := cmPGroupCode;                     // SQL=varchar, Delphi=string[16]
    cmByQtyParam.Value := cmByQty;                               // SQL=bit, Delphi=boolean
    cmQtyFromParam.Value := cmQtyFrom;                           // SQL=float, Delphi=double
    cmQtyToParam.Value := cmQtyTo;                               // SQL=float, Delphi=double
    cmByCurrencyParam.Value := cmByCurrency;                     // SQL=bit, Delphi=boolean
    cmCurrencyParam.Value := cmCurrency;                         // SQL=int, Delphi=LongInt
    cmByDateParam.Value := cmByDate;                             // SQL=bit, Delphi=boolean
    cmStartDateParam.Value := cmStartDate;                       // SQL=varchar, Delphi=string[8]
    cmEndDateParam.Value := cmEndDate;                           // SQL=varchar, Delphi=string[8]
    cmCommissionBasisParam.Value := cmCommissionBasis;           // SQL=int, Delphi=Byte
    cmCommissionParam.Value := cmCommission;                     // SQL=float, Delphi=double
    cmCommissionTypeParam.Value := cmCommissionType;             // SQL=int, Delphi=byte
    cmDummyCharParam.Value := Ord(cmDummyChar);                  // SQL=int, Delphi=char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

