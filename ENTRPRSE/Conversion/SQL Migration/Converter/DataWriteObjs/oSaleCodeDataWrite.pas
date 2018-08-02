Unit oSaleCodeDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TSaleCodeDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    scFolioNoParam, scSalesCodeParam, scDescriptionParam, scSalesCodeTypeParam, 
    scDefCommissionBasisParam, scStatusParam, scEntSupplierCodeParam, scEntGLCodeParam, 
    scEntCostCentreParam, scEntDepartmentParam, scEntInvCurrencyParam, 
    scDefCommissionParam, scDefCommissionTypeParam, scDummyCharParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TSaleCodeDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils;

//=========================================================================

Constructor TSaleCodeDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TSaleCodeDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TSaleCodeDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].SaleCode (' + 
                                               'scFolioNo, ' + 
                                               'scSalesCode, ' + 
                                               'scDescription, ' + 
                                               'scSalesCodeType, ' + 
                                               'scDefCommissionBasis, ' + 
                                               'scStatus, ' + 
                                               'scEntSupplierCode, ' + 
                                               'scEntGLCode, ' + 
                                               'scEntCostCentre, ' + 
                                               'scEntDepartment, ' + 
                                               'scEntInvCurrency, ' + 
                                               'scDefCommission, ' + 
                                               'scDefCommissionType, ' + 
                                               'scDummyChar' + 
                                               ') ' + 
              'VALUES (' + 
                       ':scFolioNo, ' + 
                       ':scSalesCode, ' + 
                       ':scDescription, ' + 
                       ':scSalesCodeType, ' + 
                       ':scDefCommissionBasis, ' + 
                       ':scStatus, ' + 
                       ':scEntSupplierCode, ' + 
                       ':scEntGLCode, ' + 
                       ':scEntCostCentre, ' + 
                       ':scEntDepartment, ' + 
                       ':scEntInvCurrency, ' + 
                       ':scDefCommission, ' + 
                       ':scDefCommissionType, ' + 
                       ':scDummyChar' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    scFolioNoParam := FindParam('scFolioNo');
    scSalesCodeParam := FindParam('scSalesCode');
    scDescriptionParam := FindParam('scDescription');
    scSalesCodeTypeParam := FindParam('scSalesCodeType');
    scDefCommissionBasisParam := FindParam('scDefCommissionBasis');
    scStatusParam := FindParam('scStatus');
    scEntSupplierCodeParam := FindParam('scEntSupplierCode');
    scEntGLCodeParam := FindParam('scEntGLCode');
    scEntCostCentreParam := FindParam('scEntCostCentre');
    scEntDepartmentParam := FindParam('scEntDepartment');
    scEntInvCurrencyParam := FindParam('scEntInvCurrency');
    scDefCommissionParam := FindParam('scDefCommission');
    scDefCommissionTypeParam := FindParam('scDefCommissionType');
    scDummyCharParam := FindParam('scDummyChar');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TSaleCodeDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Type
  // Note: This structure has been copied from U:\BESPOKE\EXCHEQR\PromPay\Shared\BTFile.Pas
  // as it isn't possible for the SQL Data Migration to reference that code directly.
  TSalesCodeRec = record
    scFolioNo           : LongInt;
    scSalesCode         : string[10];
    scDescription       : string[60];
    scSalesCodeType     : LongInt;
    scDefCommissionBasis       : Byte;  // 0 = Total Value, 1 = Margin
    scStatus            : Byte;         // 0 = Inactive, 1 = Active
    scEntSupplierCode   : string[6];
    scEntGLCode         : LongInt;
    scEntCostCentre     : String[3];
    scEntDepartment     : String[3];
    scEntInvCurrency    : Byte;
    scDefCommission     : double;
    scDefCommissionType : byte;         // 0 = Percentage, 1 = Amount
    scDummyChar         : char;
    scSpare             : Array [1..500] of Char;
  end;{TSalesCodeTypeRec}

Var
  DataRec : ^TSalesCodeRec;
  sTemp : ShortString;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    scFolioNoParam.Value := scFolioNo;                               // SQL=int, Delphi=LongInt
    scSalesCodeParam.Value := scSalesCode;                           // SQL=varchar, Delphi=string[10]
    scDescriptionParam.Value := scDescription;                       // SQL=varchar, Delphi=string[60]
    scSalesCodeTypeParam.Value := scSalesCodeType;                   // SQL=int, Delphi=LongInt
    scDefCommissionBasisParam.Value := scDefCommissionBasis;         // SQL=int, Delphi=Byte
    scStatusParam.Value := scStatus;                                 // SQL=int, Delphi=Byte
    scEntSupplierCodeParam.Value := scEntSupplierCode;               // SQL=varchar, Delphi=string[6]
    scEntGLCodeParam.Value := scEntGLCode;                           // SQL=int, Delphi=LongInt
    scEntCostCentreParam.Value := scEntCostCentre;                   // SQL=varchar, Delphi=String[3]
    scEntDepartmentParam.Value := scEntDepartment;                   // SQL=varchar, Delphi=String[3]
    scEntInvCurrencyParam.Value := scEntInvCurrency;                 // SQL=int, Delphi=Byte
    scDefCommissionParam.Value := scDefCommission;                   // SQL=float, Delphi=double
    scDefCommissionTypeParam.Value := scDefCommissionType;           // SQL=int, Delphi=byte
    scDummyCharParam.Value := Ord(scDummyChar);                      // SQL=int, Delphi=char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

