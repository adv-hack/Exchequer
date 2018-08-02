Unit oNomViewDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TNomViewDataWrite_ViewCtrlVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields

    // Variant specific fields
    RecPfixParam, SubTypeParam, VCCode1Param, VCCode2Param, VCCode3Param,
    VCCode4Param, NomViewNoParam, nvc_code5Param, DefCurrParam, DefPeriodParam,
    DefPeriodToParam, DefYearParam, ViewCtrlNoParam, LastPeriodParam,
    LastYearParam, CtrlDepartmentParam, CtrlCostCentreParam, CtrlBudgetParam,
    CtrlCommitParam, CtrlUnpostedParam, AutoStructParam, LastPRunNoParam,
    SparePadParam, LastUpdateParam, LastOpoParam, InActiveParam, DefCurrTxParam,
    DefYTDParam, DefUseF6Param, LoadedOkParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TNomViewDataWrite_ViewCtrlVariant

  //------------------------------

  TNomViewDataWrite_ViewLineVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields

    // Variant specific fields
    RecPfixParam, SubTypeParam, NVCode1Param, NVCode2Param, NVCode3Param,
    NVCode4Param, NomViewNoParam, nvc_code5Param, ViewCodeParam, ViewIdxParam,
    ViewCatParam, ViewTypeParam, CarryFParam, AltCodeParam, LinkViewParam,
    LinkGLParam, LinkDepartmentParam, LinkCostCentreParam, IncBudgetParam,
    IncCommitParam, IncUnpostedParam, AutoDescParam, LinkTypeParam, ABSViewIdxParam: TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TNomViewDataWrite_ViewLineVariant

  //------------------------------

  TNomViewDataWrite = Class(TBaseDataWrite)
  Private
    FViewCtrlVariant : TNomViewDataWrite_ViewCtrlVariant;
    FViewLineVariant : TNomViewDataWrite_ViewLineVariant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TNomViewDataWrite

  //------------------------------

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TNomViewDataWrite.Create;
Begin // Create
  Inherited Create;
  FViewCtrlVariant := TNomViewDataWrite_ViewCtrlVariant.Create;
  FViewLineVariant := TNomViewDataWrite_ViewLineVariant.Create;
End; // Create

//------------------------------

Destructor TNomViewDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FViewCtrlVariant);
  FreeAndNIL(FViewLineVariant);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TNomViewDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FViewCtrlVariant.Prepare (ADOConnection, CompanyCode);
  FViewLineVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TNomViewDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^NomViewRec;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Check the RecPFix/SubType to determine what to do
  If (DataRec.RecPFix = 'N') And (DataRec.SubType = 'C') Then
  Begin
    // Control Line
    FViewCtrlVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End
  Else If (DataRec.RecPFix = 'N') And (DataRec.SubType = 'V') Then
  Begin
    // View Line
    FViewLineVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End
  Else
  Begin
    // Unknown Data - Log error and continue conversion
    SkipRecord := True;
    sDumpFile := DataPacket.DumpToFile;
    ConversionWarnings.AddWarning(TSQLUnknownVariantWarning.Create (DataPacket, sDumpFile, ToHexString(@DataRec^.RecPFix, 2 {RecMFix + SubType})));
    Logging.UnknownVariant(Trim(DataPacket.CompanyDetails.ccCompanyPath) + DataPacket.TaskDetails.dctPervasiveFilename, ToHexString(@DataRec^.RecPFix, 2 {RecMFix + SubType}), sDumpFile);
  End; // Else
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TNomViewDataWrite_ViewCtrlVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].NomView (' +
                                              'RecPfix, ' +
                                              'SubType, ' +
                                              'VCCode1, ' +
                                              'VCCode2, ' +
                                              'VCCode3, ' +
                                              'VCCode4, ' +
                                              'NomViewNo, ' +
                                              'nvc_code5, ' +
                                              'DefCurr, ' + 
                                              'DefPeriod, ' + 
                                              'DefPeriodTo, ' + 
                                              'DefYear, ' +
                                              'ViewCtrlNo, ' +
                                              'LastPeriod, ' + 
                                              'LastYear, ' + 
                                              'CtrlDepartment, ' + 
                                              'CtrlCostCentre, ' + 
                                              'CtrlBudget, ' + 
                                              'CtrlCommit, ' + 
                                              'CtrlUnposted, ' +
                                              'AutoStruct, ' +
                                              'LastPRunNo, ' +
                                              'SparePad, ' +
                                              'LastUpdate, ' +
                                              'LastOpo, ' +
                                              'InActive, ' +
                                              'DefCurrTx, ' +
                                              'DefYTD, ' +
                                              'DefUseF6, ' +
                                              'LoadedOk' +
                                              ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':VCCode1, ' +
                       ':VCCode2, ' +
                       ':VCCode3, ' +
                       ':VCCode4, ' +
                       ':NomViewNo, ' +
                       ':nvc_code5, ' +
                       ':DefCurr, ' +
                       ':DefPeriod, ' +
                       ':DefPeriodTo, ' +
                       ':DefYear, ' +
                       ':ViewCtrlNo, ' +
                       ':LastPeriod, ' +
                       ':LastYear, ' +
                       ':CtrlDepartment, ' +
                       ':CtrlCostCentre, ' +
                       ':CtrlBudget, ' +
                       ':CtrlCommit, ' +
                       ':CtrlUnposted, ' +
                       ':AutoStruct, ' +
                       ':LastPRunNo, ' +
                       ':SparePad, ' +
                       ':LastUpdate, ' +
                       ':LastOpo, ' +
                       ':InActive, ' +
                       ':DefCurrTx, ' +
                       ':DefYTD, ' +
                       ':DefUseF6, ' +
                       ':LoadedOk' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    VCCode1Param := FindParam('VCCode1');
    VCCode2Param := FindParam('VCCode2');
    VCCode3Param := FindParam('VCCode3');
    VCCode4Param := FindParam('VCCode4');
    NomViewNoParam := FindParam('NomViewNo');
    nvc_code5Param := FindParam('nvc_code5');
    DefCurrParam := FindParam('DefCurr');
    DefPeriodParam := FindParam('DefPeriod');
    DefPeriodToParam := FindParam('DefPeriodTo');
    DefYearParam := FindParam('DefYear');
    ViewCtrlNoParam := FindParam('ViewCtrlNo');
    LastPeriodParam := FindParam('LastPeriod');
    LastYearParam := FindParam('LastYear');
    CtrlDepartmentParam := FindParam('CtrlDepartment');
    CtrlCostCentreParam := FindParam('CtrlCostCentre');
    CtrlBudgetParam := FindParam('CtrlBudget');
    CtrlCommitParam := FindParam('CtrlCommit');
    CtrlUnpostedParam := FindParam('CtrlUnposted');
    AutoStructParam := FindParam('AutoStruct');
    LastPRunNoParam := FindParam('LastPRunNo');
    SparePadParam := FindParam('SparePad');
    LastUpdateParam := FindParam('LastUpdate');
    LastOpoParam := FindParam('LastOpo');
    InActiveParam := FindParam('InActive');
    DefCurrTxParam := FindParam('DefCurrTx');
    DefYTDParam := FindParam('DefYTD');
    DefUseF6Param := FindParam('DefUseF6');
    LoadedOkParam := FindParam('LoadedOk');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TNomViewDataWrite_ViewCtrlVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^NomViewRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, DataRec^.ViewCtrl Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                  // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                  // SQL=varchar, Delphi=Char
    // *** BINARY ***
    VCCode1Param.Value := CreateVariantArray (@VCCode1, SizeOf(VCCode1));// SQL=varbinary, Delphi=String[60]
    // *** BINARY ***
    VCCode2Param.Value := CreateVariantArray (@VCCode2, SizeOf(VCCode2));// SQL=varbinary, Delphi=String[10]
    // *** BINARY ***
    VCCode3Param.Value := CreateVariantArray (@VCCode3, SizeOf(VCCode3));// SQL=varbinary, Delphi=String[20]
    // *** BINARY ***
    VCCode4Param.Value := CreateVariantArray (@VCCode4, SizeOf(VCCode4));// SQL=varbinary, Delphi=String[60]
    NomViewNoParam.Value := IndexLInt;
    nvc_code5Param.Value := ViewDesc;
    DefCurrParam.Value := DefCurr;                                                   // SQL=int, Delphi=Byte
    DefPeriodParam.Value := DefPeriod;                                               // SQL=int, Delphi=Byte
    DefPeriodToParam.Value := DefPeriodTo;                                           // SQL=int, Delphi=Byte
    DefYearParam.Value := DefYear;                                                   // SQL=int, Delphi=Byte
    ViewCtrlNoParam.Value := ViewCtrlNo;                                             // SQL=int, Delphi=LongInt
    LastPeriodParam.Value := LastPeriod;                                             // SQL=int, Delphi=Byte
    LastYearParam.Value := LastYear;                                                 // SQL=int, Delphi=Byte
    CtrlDepartmentParam.Value := LinkCCDep[False];                                   // SQL=varchar, Delphi=CCDepType
    CtrlCostCentreParam.Value := LinkCCDep[True];                                    // SQL=varchar, Delphi=CCDepType
    CtrlBudgetParam.Value := IncBudget;                                              // SQL=bit, Delphi=Boolean
    CtrlCommitParam.Value := IncCommit;                                              // SQL=bit, Delphi=Boolean
    CtrlUnpostedParam.Value := IncUnposted;                                          // SQL=int, Delphi=Byte
    AutoStructParam.Value := AutoStruct;                                             // SQL=bit, Delphi=Boolean
    LastPRunNoParam.Value := LastPRunNo;                                             // SQL=int, Delphi=LongInt
    // *** BINARY ***
    SparePadParam.Value := CreateVariantArray (@SparePad, SizeOf(SparePad));// SQL=varbinary, Delphi=Array[1..29] of Byte
    LastUpdateParam.Value := LastUpdate;                                             // SQL=varchar, Delphi=LongDate
    LastOpoParam.Value := LastOpo;                                                   // SQL=varchar, Delphi=String[10]
    InActiveParam.Value := InActive;                                                 // SQL=bit, Delphi=Boolean
    DefCurrTxParam.Value := DefCurrTx;                                               // SQL=bit, Delphi=Boolean
    DefYTDParam.Value := DefYTD;                                                     // SQL=bit, Delphi=Boolean
    DefUseF6Param.Value := DefUseF6;                                                 // SQL=bit, Delphi=Boolean
    LoadedOkParam.Value := LoadedOk;                                                 // SQL=bit, Delphi=Boolean
  End; // With DataRec^.CustDiscRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TNomViewDataWrite_ViewLineVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].NomView (' +
                                              'RecPfix, ' +
                                              'SubType, ' +
                                              'VCCode1, ' +
                                              'VCCode2, ' +
                                              'VCCode3, ' +
                                              'VCCode4, ' +
                                              'NomViewNo, ' +
                                              'nvc_code5, ' +
                                              'ViewCode, ' +
                                              'ViewIdx, ' +
                                              'ViewCat, ' +
                                              'ViewType, ' +
                                              'CarryF, ' +
                                              'AltCode, ' +
                                              'LinkView, ' +
                                              'LinkGL, ' +
                                              'LinkDepartment, ' +
                                              'LinkCostCentre, ' +
                                              'IncBudget, ' +
                                              'IncCommit, ' +
                                              'IncUnposted, ' +
                                              'AutoDesc, ' +
                                              'LinkType, ' +
                                              'ABSViewIdx' +
                                              ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':NVCode1, ' +
                       ':NVCode2, ' +
                       ':NVCode3, ' +
                       ':NVCode4, ' +
                       ':NomViewNo, ' +
                       ':nvc_code5, ' +
                       ':ViewCode, ' +
                       ':ViewIdx, ' +
                       ':ViewCat, ' +
                       ':ViewType, ' +
                       ':CarryF, ' +
                       ':AltCode, ' +
                       ':LinkView, ' +
                       ':LinkGL, ' +
                       ':LinkDepartment, ' +
                       ':LinkCostCentre, ' +
                       ':IncBudget, ' +
                       ':IncCommit, ' +
                       ':IncUnposted, ' +
                       ':AutoDesc, ' +
                       ':LinkType, ' +
                       ':ABSViewIdx ' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    NVCode1Param := FindParam('NVCode1');
    NVCode2Param := FindParam('NVCode2');
    NVCode3Param := FindParam('NVCode3');
    NVCode4Param := FindParam('NVCode4');
    NomViewNoParam := FindParam('NomViewNo');
    nvc_code5Param := FindParam('nvc_code5');
    ViewCodeParam := FindParam('ViewCode');
    ViewIdxParam := FindParam('ViewIdx');
    ViewCatParam := FindParam('ViewCat');
    ViewTypeParam := FindParam('ViewType');
    CarryFParam := FindParam('CarryF');
    AltCodeParam := FindParam('AltCode');
    LinkViewParam := FindParam('LinkView');
    LinkGLParam := FindParam('LinkGL');
    LinkDepartmentParam := FindParam('LinkDepartment');
    LinkCostCentreParam := FindParam('LinkCostCentre');
    IncBudgetParam := FindParam('IncBudget');
    IncCommitParam := FindParam('IncCommit');
    IncUnpostedParam := FindParam('IncUnposted');
    AutoDescParam := FindParam('AutoDesc');
    LinkTypeParam := FindParam('LinkType');
    ABSViewIdxParam := FindParam('ABSViewIdx');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TNomViewDataWrite_ViewLineVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^NomViewRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, DataRec^.NomViewLine Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                  // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                  // SQL=varchar, Delphi=Char
    // *** BINARY ***
    NVCode1Param.Value := CreateVariantArray (@NVCode1, SizeOf(NVCode1));// SQL=varbinary, Delphi=String[60]
    // *** BINARY ***
    NVCode2Param.Value := CreateVariantArray (@NVCode2, SizeOf(NVCode2));// SQL=varbinary, Delphi=String[10]
    // *** BINARY ***
    NVCode3Param.Value := CreateVariantArray (@NVCode3, SizeOf(NVCode3));// SQL=varbinary, Delphi=String[20]
    // *** BINARY ***
    NVCode4Param.Value := CreateVariantArray (@NVCode4, SizeOf(NVCode4));// SQL=varbinary, Delphi=String[60]
    NomViewNoParam.Value := NomViewNo;                                               // SQL=int, Delphi=LongInt
    nvc_code5Param.Value := Desc;                                                    // SQL=varchar, Delphi=String[100]
    ViewCodeParam.Value := ViewCode;                                                 // SQL=varchar, Delphi=String[50]
    ViewIdxParam.Value := ViewIdx;                                                   // SQL=int, Delphi=LongInt
    ViewCatParam.Value := ViewCat;                                                   // SQL=int, Delphi=LongInt
    ViewTypeParam.Value := ConvertCharToSQLEmulatorVarChar(ViewType);                // SQL=varchar, Delphi=Char
    CarryFParam.Value := CarryF;                                                     // SQL=int, Delphi=LongInt
    AltCodeParam.Value := AltCode;                                                   // SQL=varchar, Delphi=String[50]
    LinkViewParam.Value := LinkView;                                                 // SQL=int, Delphi=LongInt
    LinkGLParam.Value := LinkGL;                                                     // SQL=int, Delphi=LongInt
    LinkDepartmentParam.Value := LinkCCDep[False];                                   // SQL=varchar, Delphi=CCDepType
    LinkCostCentreParam.Value := LinkCCDep[True];                                    // SQL=varchar, Delphi=CCDepType
    IncBudgetParam.Value := IncBudget;                                               // SQL=bit, Delphi=Boolean
    IncCommitParam.Value := IncCommit;                                               // SQL=bit, Delphi=Boolean
    IncUnpostedParam.Value := IncUnposted;                                           // SQL=int, Delphi=Byte
    AutoDescParam.Value := AutoDesc;                                                 // SQL=bit, Delphi=Boolean
    LinkTypeParam.Value := ConvertCharToSQLEmulatorVarChar(LinkType);                // SQL=varchar, Delphi=Char
    ABSViewIdxParam.Value := ABSViewIdx;                                             // SQL=int, Delphi=LongInt
  End; // With DataRec^, CustDiscRec
End; // SetQueryValues

//=========================================================================

End.

