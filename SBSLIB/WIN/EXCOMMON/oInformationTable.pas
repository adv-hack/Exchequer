Unit oInformationTable;

Interface

Const
  ccyEdProfessional = 0;  // Single-Currency
  ccyEdEuro = 1;          // Euro
  ccyEdGlobal = 2;        // Multi-Currency
  CurrencyEditions : Array [0..2] Of String = ('Professional', 'Euro', 'Global');

Type
  // Generic interface for objects which implement a specific import type
  IExchequerConfigurationInformation = Interface
    ['{0E42CA09-79F0-4F7E-AAD4-17E93CCBB2E6}']
    // --- Internal Methods to implement Public Properties ---
    Function GetAccountStockAnalysis : Boolean;
    Procedure SetAccountStockAnalysis (Value : Boolean);
    Function GetImporter : Boolean;
    Procedure SetImporter (Value : Boolean);
    Function GetJobCosting : Boolean;
    Procedure SetJobCosting (Value : Boolean);
    Function GetODBC : Boolean;
    Procedure SetODBC (Value : Boolean);
    Function GetReportWriter : Boolean;
    Procedure SetReportWriter (Value : Boolean);
    Function GetTelesales : Boolean;
    Procedure SetTelesales (Value : Boolean);
    Function GetToolkitRuntime : Boolean;
    Procedure SetToolkitRuntime (Value : Boolean);
    Function GeteBusiness : Boolean;
    Procedure SeteBusiness (Value : Boolean);
    Function GetPaperlessModule : Boolean;
    Procedure SetPaperlessModule (Value : Boolean);
    Function GetOLESaveFunctions : Boolean;
    Procedure SetOLESaveFunctions (Value : Boolean);
    Function GetCommitmentAccounting : Boolean;
    Procedure SetCommitmentAccounting (Value : Boolean);
    Function GetTradeCounter : Boolean;
    Procedure SetTradeCounter (Value : Boolean);
    Function GetStandardWorksOrderProcessing : Boolean;
    Procedure SetStandardWorksOrderProcessing (Value : Boolean);
    Function GetProfessionalWorksOrderProcessing : Boolean;
    Procedure SetProfessionalWorksOrderProcessing (Value : Boolean);
    Function GetSentimail : Boolean;
    Procedure SetSentimail (Value : Boolean);
    Function GetEnhancedSecurity : Boolean;
    Procedure SetEnhancedSecurity (Value : Boolean);
    Function GetJobCostingCISRCT : Boolean;
    Procedure SetJobCostingCISRCT (Value : Boolean);
    Function GetJobCostingAppsVals : Boolean;
    Procedure SetJobCostingAppsVals (Value : Boolean);
    Function GetFullStock : Boolean;
    Procedure SetFullStock (Value : Boolean);
    Function GetVisualReportWriter : Boolean;
    Procedure SetVisualReportWriter (Value : Boolean);
    Function GetGoodsReturns : Boolean;
    Procedure SetGoodsReturns (Value : Boolean);
    Function GeteBanking : Boolean;
    Procedure SeteBanking (Value : Boolean);
    Function GetOutlookDynamicDashboard : Boolean;
    Procedure SetOutlookDynamicDashboard (Value : Boolean);
    Function GetExchequerEdition : ShortString;
    Procedure SetExchequerEdition (Value : ShortString);
    Function GetStock : Boolean;
    Procedure SetStock (Value : Boolean);
    Function GetSPOP : Boolean;
    Procedure SetSPOP (Value : Boolean);
    Function GetCurrencyEdition : ShortString;
    Procedure SetCurrencyEdition (Value : ShortString);

    Function GetLastErrorString : ANSIString;

    // ------------------ Public Properties ------------------
    Property eciAccountStockAnalysis : Boolean Read GetAccountStockAnalysis Write SetAccountStockAnalysis;
    Property eciImporter : Boolean Read GetImporter Write SetImporter;
    Property eciJobCosting : Boolean Read GetJobCosting Write SetJobCosting;
    Property eciODBC : Boolean Read GetODBC Write SetODBC;
    Property eciReportWriter : Boolean Read GetReportWriter Write SetReportWriter;
    Property eciTelesales : Boolean Read GetTelesales Write SetTelesales;
    Property eciToolkitRuntime : Boolean Read GetToolkitRuntime Write SetToolkitRuntime;
    Property ecieBusiness : Boolean Read GeteBusiness Write SeteBusiness;
    Property eciPaperlessModule : Boolean Read GetPaperlessModule Write SetPaperlessModule;
    Property eciOLESaveFunctions : Boolean Read GetOLESaveFunctions Write SetOLESaveFunctions;
    Property eciCommitmentAccounting : Boolean Read GetCommitmentAccounting Write SetCommitmentAccounting;
    Property eciTradeCounter : Boolean Read GetTradeCounter Write SetTradeCounter;
    Property eciStandardWorksOrderProcessing : Boolean Read GetStandardWorksOrderProcessing Write SetStandardWorksOrderProcessing;
    Property eciProfessionalWorksOrderProcessing : Boolean Read GetProfessionalWorksOrderProcessing Write SetProfessionalWorksOrderProcessing;
    Property eciSentimail : Boolean Read GetSentimail Write SetSentimail;
    Property eciEnhancedSecurity : Boolean Read GetEnhancedSecurity Write SetEnhancedSecurity;
    Property eciJobCostingCISRCT : Boolean Read GetJobCostingCISRCT Write SetJobCostingCISRCT;
    Property eciJobCostingAppsVals : Boolean Read GetJobCostingAppsVals Write SetJobCostingAppsVals;
    Property eciFullStock : Boolean Read GetFullStock Write SetFullStock;
    Property eciVisualReportWriter : Boolean Read GetVisualReportWriter Write SetVisualReportWriter;
    Property eciGoodsReturns : Boolean Read GetGoodsReturns Write SetGoodsReturns;
    Property ecieBanking : Boolean Read GeteBanking Write SeteBanking;
    Property eciOutlookDynamicDashboard : Boolean Read GetOutlookDynamicDashboard Write SetOutlookDynamicDashboard;
    Property eciExchequerEdition : ShortString Read GetExchequerEdition Write SetExchequerEdition;
    Property eciStock : Boolean Read GetStock Write SetStock;
    Property eciSPOP : Boolean Read GetSPOP Write SetSPOP;
    Property eciCurrencyEdition : ShortString Read GetCurrencyEdition Write SetCurrencyEdition;

    Property LastErrorString : ANSIString Read GetLastErrorString;

    // ------------------- Public Methods --------------------
    Function Save : Integer;
  End; // IExchequerConfigurationInformation


Function ExchequerConfigurationInformation : IExchequerConfigurationInformation;

Implementation

Uses DB, ADODB, SysUtils, StrUtils, Math, SQLUtils, SQLCallerU,ExchConnect;

Const
  IdxAccountStockAnalysis = 1;
  IdxImportModule = 2;
  IdxJobCosting = 3;
  IdxODBC = 4;
  IdxReportWriter = 5;
  IdxTelesales = 6;
  IdxToolkitRuntime = 8;
  IdxeBusiness = 9;
  IdxPaperless = 10;
  IdxOLESaveFunctions = 11;
  IdxCommitmentAccounting = 12;
  IdxTradeCounter = 13;
  IdxStandardWOP = 14;
  IdxProfessionalWOP = 15;
  IdxSentimail = 16;
  IdxEnhancedSecurity = 17;
  IdxCISRCT = 18;
  IdxAppsVals = 19;
  IdxFullStock = 20;
  IdxVisualReportWriter = 21;
  IdxGoodsReturns = 22;
  IdxeBanking = 23;
  IdxOutlookDynamicDashboard = 24;
  IdxExchequerEdition = 100;
  IdxStock = 101;
  IdxSPOP = 102;
  IdxCurrency = 103;

Type
  TExchequerConfigurationDetailsRecordType = Record
    // Unique Constant ID Number
    ecdId   : Integer;
    // Human Readable Description
    ecdName : ShortString;
    // Default Value for new rows
    ecdDefaultValue : ShortString;

    // Indicates whether this property was laoded from the database
    ecdLoadedFromDB : Boolean;
    // Original Database Value
    ecdOriginalDBValue : ShortString;
    // Current Value set in the code
    ecdCurrentValue : ShortString;
  End; // TExchequerConfigurationDetailsRecordType

  //-----------------------------------

  TExchequerConfigurationInformation = Class(TInterfacedObject, IExchequerConfigurationInformation)
  Private
    FLastErrorString : ANSIString;
    FConfigurationValues : Array Of TExchequerConfigurationDetailsRecordType;

    // Internal Methods -----------------------------------------------

    // load the supported values into the ConfigurationValues array
    Procedure AddDefaults;

    // Load the current values from the DB into the ConfigurationValues array
    Procedure LoadAllSettings;

    // Returns the Index Number of the specified Id in the ConfigurationValues array, -1 if not found
    Function IndexOf (Const Id : Integer) : Integer;

    // Sets the Current Value for the specified Id in the ConfigurationValues array
    Procedure SetCurrentValue (Const Id : Integer; Const CurrentValue : ShortString);

    // Property Getter/Ssetter funcs
    Function GetConfigurationInformationProperty (Const Id : Integer) : Boolean;
    Procedure SetConfigurationInformationProperty (Const Id : Integer; Const Value : Boolean);
    Function GetStringConfigurationInformationProperty (Const Id : Integer) : ShortString;
    Procedure SetStringConfigurationInformationProperty (Const Id : Integer; Value : ShortString);

    // IExchequerConfigurationInformatio Methods ----------------------
    Function GetAccountStockAnalysis : Boolean;
    Procedure SetAccountStockAnalysis (Value : Boolean);
    Function GetImporter : Boolean;
    Procedure SetImporter (Value : Boolean);
    Function GetJobCosting : Boolean;
    Procedure SetJobCosting (Value : Boolean);
    Function GetODBC : Boolean;
    Procedure SetODBC (Value : Boolean);
    Function GetReportWriter : Boolean;
    Procedure SetReportWriter (Value : Boolean);
    Function GetTelesales : Boolean;
    Procedure SetTelesales (Value : Boolean);
    Function GetToolkitRuntime : Boolean;
    Procedure SetToolkitRuntime (Value : Boolean);
    Function GeteBusiness : Boolean;
    Procedure SeteBusiness (Value : Boolean);
    Function GetPaperlessModule : Boolean;
    Procedure SetPaperlessModule (Value : Boolean);
    Function GetOLESaveFunctions : Boolean;
    Procedure SetOLESaveFunctions (Value : Boolean);
    Function GetCommitmentAccounting : Boolean;
    Procedure SetCommitmentAccounting (Value : Boolean);
    Function GetTradeCounter : Boolean;
    Procedure SetTradeCounter (Value : Boolean);
    Function GetStandardWorksOrderProcessing : Boolean;
    Procedure SetStandardWorksOrderProcessing (Value : Boolean);
    Function GetProfessionalWorksOrderProcessing : Boolean;
    Procedure SetProfessionalWorksOrderProcessing (Value : Boolean);
    Function GetSentimail : Boolean;
    Procedure SetSentimail (Value : Boolean);
    Function GetEnhancedSecurity : Boolean;
    Procedure SetEnhancedSecurity (Value : Boolean);
    Function GetJobCostingCISRCT : Boolean;
    Procedure SetJobCostingCISRCT (Value : Boolean);
    Function GetJobCostingAppsVals : Boolean;
    Procedure SetJobCostingAppsVals (Value : Boolean);
    Function GetFullStock : Boolean;
    Procedure SetFullStock (Value : Boolean);
    Function GetVisualReportWriter : Boolean;
    Procedure SetVisualReportWriter (Value : Boolean);
    Function GetGoodsReturns : Boolean;
    Procedure SetGoodsReturns (Value : Boolean);
    Function GeteBanking : Boolean;
    Procedure SeteBanking (Value : Boolean);
    Function GetOutlookDynamicDashboard : Boolean;
    Procedure SetOutlookDynamicDashboard (Value : Boolean);
    Function GetExchequerEdition : ShortString;
    Procedure SetExchequerEdition (Value : ShortString);
    Function GetStock : Boolean;
    Procedure SetStock (Value : Boolean);
    Function GetSPOP : Boolean;
    Procedure SetSPOP (Value : Boolean);
    Function GetCurrencyEdition : ShortString;
    Procedure SetCurrencyEdition (Value : ShortString);
    Function GetLastErrorString : ANSIString;

    Function Save : Integer;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TExchequerConfigurationInformation

Var
  lExchequerConfigurationInformation : IExchequerConfigurationInformation;

//=========================================================================

Function ExchequerConfigurationInformation : IExchequerConfigurationInformation;
Begin // ExchequerConfigurationInformation
  // Only create an instance for the MSSQL Edition if it doesn't already exist
  If SQLUtils.UsingSQL And (lExchequerConfigurationInformation = NIL) Then
    lExchequerConfigurationInformation := TExchequerConfigurationInformation.Create;

  Result := lExchequerConfigurationInformation;
End; // ExchequerConfigurationInformation

//=========================================================================

Constructor TExchequerConfigurationInformation.Create;
Begin // Create
  Inherited Create;

  FLastErrorString := '';

  // Build the array of supported Configuration Values
  AddDefaults;

  // Load any pre-existing values from the DB
  LoadAllSettings;
End; // Create

//-----------------------------------

Destructor TExchequerConfigurationInformation.Destroy;
Begin // Destroy
  // De-allocate the dynamic array
  FConfigurationValues := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// load the supported values into the ConfigurationValues array
Procedure TExchequerConfigurationInformation.AddDefaults;

  //-----------------------------------

  Procedure AddDefault (Const Id : Integer; Const Name, DefaultValue : ShortString);
  Begin // AddDefault
    // Add a new entry into the array
    SetLength(FConfigurationValues, Length(FConfigurationValues) + 1);

    FillChar(FConfigurationValues[High(FConfigurationValues)], SizeOf(TExchequerConfigurationDetailsRecordType), #0);
    With FConfigurationValues[High(FConfigurationValues)] Do
    Begin
      ecdId := Id;
      ecdName := Name;
      ecdDefaultValue := DefaultValue;
    End; // With FConfigurationValues[High(FConfigurationValues)]
  End; // AddDefault

  //-----------------------------------

Begin // AddDefaults
  AddDefault (IdxAccountStockAnalysis,    'Account Stock Analysis',                'N');
  AddDefault (IdxImportModule,            'Import Module',                         'N');
  AddDefault (IdxJobCosting,              'Job Costing',                           'N');
  AddDefault (IdxODBC,                    'ODBC',                                  'N');
  AddDefault (IdxReportWriter,            'Report Writer',                         'N');
  AddDefault (IdxTelesales,               'Telesales',                             'N');
  AddDefault (IdxToolkitRuntime,          'Toolkit Runtime',                       'N');
  AddDefault (IdxeBusiness,               'eBusiness',                             'N');
  AddDefault (IdxPaperless,               'Paperless Module',                      'N');
  AddDefault (IdxOLESaveFunctions,        'OLE Save Functions',                    'N');
  AddDefault (IdxCommitmentAccounting,    'Commitment Accounting',                 'N');
  AddDefault (IdxTradeCounter,            'Trade Counter',                         'N');
  AddDefault (IdxStandardWOP,             'Standard Works Order Processing',       'N');
  AddDefault (IdxProfessionalWOP,         'Professional Works Order Processing',   'N');
  AddDefault (IdxSentimail,               'Sentimail Module',                      'N');
  AddDefault (IdxEnhancedSecurity,        'Enhanced Security',                     'N');
  AddDefault (IdxCISRCT,                  'Job Costing CIS/RCT',                   'N');
  AddDefault (IdxAppsVals,                'Job Costing Applications & Valuations', 'N');
  AddDefault (IdxFullStock,               'Full Stock',                            'N');
  AddDefault (IdxVisualReportWriter,      'Visual Report Writer',                  'N');
  AddDefault (IdxGoodsReturns,            'Goods Returns',                         'N');
  AddDefault (IdxeBanking,                'eBanking',                              'N');
  AddDefault (IdxOutlookDynamicDashboard, 'Outlook Dynamic Dashboard',             'N');
  AddDefault (IdxExchequerEdition,        'Exchequer Edition',                     'Standard');
  AddDefault (IdxStock,                   'Stock',                                 'N');
  AddDefault (IdxSPOP,                    'Sales/Purchase Order Processing',       'N');
  AddDefault (IdxCurrency,                'Currency Edition',                      CurrencyEditions[ccyEdGlobal]);    // Default to Global as the most common
End; // AddDefaults

//-------------------------------------------------------------------------

// Returns the Index Number of the specified Id in the ConfigurationValues array, -1 if not found
Function TExchequerConfigurationInformation.IndexOf (Const Id : Integer) : Integer;
Var
  I : Integer;
Begin // IndexOf
  Result := -1;

  // Run through the dynamic array and return the index of the matching Id (if found)
  If (Length(FConfigurationValues) > 0) Then
    For I := Low(FConfigurationValues) To High(FConfigurationValues) Do
      If (FConfigurationValues[I].ecdId = Id) Then
      Begin
        Result := I;
        Break;
      End; // If (FConfigurationValues[I].ecdId = Id)
End; // IndexOf

//-------------------------------------------------------------------------

// Sets the Current Value for the specified Id in the ConfigurationValues array
Procedure TExchequerConfigurationInformation.SetCurrentValue (Const Id : Integer; Const CurrentValue : ShortString);
Var
  Idx : Integer;
Begin // SetCurrentValue
  Idx := IndexOf(Id);
  If (Idx >= 0) Then
    With FConfigurationValues[Idx] Do
    Begin
      ecdLoadedFromDB := True;
      ecdOriginalDBValue := CurrentValue;
      ecdCurrentValue := CurrentValue;
    End; // With FConfigurationValues[Idx]
End; // SetCurrentValue

//-------------------------------------------------------------------------

// Load the current values from the DB into the ConfigurationValues array
Procedure TExchequerConfigurationInformation.LoadAllSettings;
Var
  sConnectionString,
  lPassword : WideString;
  oADOConnection : TExchConnection;
  FID : TIntegerField;
  FValue : TStringField;
Begin // LoadAllSettings
  // Setup a ADO Connection for the Common tables
  If (GetCommonConnectionStringWOPass(sConnectionString, lPassword) = 0) Then
  Begin
    oADOConnection := TExchConnection.Create(Nil);
    Try
      oADOConnection.ConnectionString := sConnectionString;
      oADOConnection.Password := lPassword;
      oADOConnection.Open;

      With TSQLCaller.Create(oADOConnection) Do
      Begin
        Try
          // Load all the existing settings from the common.etb_Information and update
          // the internal FConfigurationValues array with the values
          Select('SELECT InformationId, InformationValue FROM common.etb_Information', '');
          If (ErrorMsg = '') And (Records.RecordCount > 0) Then
          Begin
            Records.First;

            // Use typecast references to the fields to avoid variant performance hits
            FID := Records.FieldByName('InformationId') As TIntegerField;
            FValue := Records.FieldByName('InformationValue') As TStringField;

            While (Not Records.EOF) Do
            Begin
              SetCurrentValue (FId.Value, FValue.Value);

              Records.Next;
            End; // While (Not Records.EOF)
          End; // If (ErrorMsg = '') And (Records.RecordCount > 0)
        Finally
          Free;
        End; // Try..Finally
      End; // With TSQLCaller.Create(oADOConnection)
    Finally
      oADOConnection.Free;
    End; // Try..Finally
  End; // If (GetCommonConnectionString(sConnectionString: AnsiString) = 0)
End; // LoadAllSettings

//-------------------------------------------------------------------------

Function TExchequerConfigurationInformation.Save : Integer;
Var
  sConnectionString,
  lPassword : WideString;
  oADOConnection : TExchConnection;
  oSQLCaller : TSQLCaller;
  I, Res : Integer;
  sSQL : AnsiString;
Begin // Save
  Result := 0;

  oADOConnection := NIL;
  oSQLCaller := NIL;

  // Run through the properties check for changes or items that need to be inserted
  If (Length(FConfigurationValues) > 0) Then
  Begin
    For I := Low(FConfigurationValues) To High(FConfigurationValues) Do
    Begin
      If (Not FConfigurationValues[I].ecdLoadedFromDB) Or
         (FConfigurationValues[I].ecdOriginalDBValue <> FConfigurationValues[I].ecdCurrentValue) Then
      Begin
        // Create the ADO Connection and TSQLCaller on demand
        If (Not Assigned(oADOConnection)) Then
        Begin
          // Setup a ADO Connection for the Common tables
          GetCommonConnectionStringWOPass(sConnectionString, lPassword);

          oADOConnection := TExchConnection.Create(Nil);
          oADOConnection.ConnectionString := sConnectionString;
          oADOConnection.Password := lPassword;
          oADOConnection.Open;

          oSQLCaller := TSQLCaller.Create(oADOConnection);
        End; // If (Not Assigned(oADOConnection))

        If (Not FConfigurationValues[I].ecdLoadedFromDB) Then
        Begin
          // Insert
          sSQL := 'INSERT INTO common.etb_Information (InformationId, InformationName, InformationValue) ' +
                  'VALUES (' + IntToStr(FConfigurationValues[I].ecdId) + ', ' +
                               QuotedStr(FConfigurationValues[I].ecdName) + ', ';

          // Work out whether to use the default or current value
          If (FConfigurationValues[I].ecdCurrentValue <> FConfigurationValues[I].ecdOriginalDBValue) Then
            // CurrentValue has been changed so use it
            sSQL := sSQL + QuotedStr(FConfigurationValues[I].ecdCurrentValue) + ')'
          Else
            // Value not changed - use the default value
            sSQL := sSQL + QuotedStr(FConfigurationValues[I].ecdDefaultValue) + ')';
        End // If (Not FConfigurationValues[I].ecdLoadedFromDB)
        Else
        Begin
          // Update
          sSQL := 'UPDATE common.etb_Information ' +
                  'SET InformationValue=' + QuotedStr(FConfigurationValues[I].ecdCurrentValue) + ' ' +
                  'WHERE (InformationId=' + IntToStr(FConfigurationValues[I].ecdId) + ')';
        End; // Else

        FLastErrorString := '';
        Res := oSQLCaller.ExecSQL(sSQL, '');
        If (Res <> 0) Then
        Begin
          FLastErrorString := oSQLCaller.ErrorMsg;
          // Set the Error Code to InformationId * 1,000 plus 1 for an Insert and 2 for an Update
          Result := (FConfigurationValues[I].ecdId * 1000) + IfThen(FConfigurationValues[I].ecdLoadedFromDB, 2, 1);
          Break;
        End; // If (Res <> 0)
      End; // If (Not FConfigurationValues[I].ecdLoadedFromDB) Or ...
    End; // For I

    If Assigned(oSQLCaller) Then
    Begin
      FreeAndNIL(oSQLCaller);
      FreeAndNIL(oADOConnection);

      // Clear down the existing ConfigurationValues array and reload the details to endure the singleton is up-to-date
      FConfigurationValues := NIL;
      AddDefaults;
      LoadAllSettings;
    End; // If Assigned(oSQLCaller)
  End; // If (Length(FConfigurationValues) > 0)
End; // Save

//-------------------------------------------------------------------------

Function TExchequerConfigurationInformation.GetConfigurationInformationProperty (Const Id : Integer) : Boolean;
Var
  Idx : Integer;
Begin // GetConfigurationInformationProperty
  Idx := IndexOf (Id);
  If (Idx >= 0) Then
    Result := UpperCase(FConfigurationValues[Idx].ecdCurrentValue) = 'Y'
  Else
    Result := False; // shouldn't ever happen
End; // GetConfigurationInformationProperty

Procedure TExchequerConfigurationInformation.SetConfigurationInformationProperty (Const Id : Integer; Const Value : Boolean);
Var
  Idx : Integer;
Begin // SetConfigurationInformationProperty
  Idx := IndexOf (Id);
  If (Idx >= 0) Then
    FConfigurationValues[Idx].ecdCurrentValue := IfThen(Value, 'Y', 'N');
End; // SetConfigurationInformationProperty

//-----------------------------------

Function TExchequerConfigurationInformation.GetStringConfigurationInformationProperty (Const Id : Integer) : ShortString;
Var
  Idx : Integer;
Begin // GetStringConfigurationInformationProperty
  Idx := IndexOf (Id);
  If (Idx >= 0) Then
    Result := FConfigurationValues[Idx].ecdCurrentValue
  Else
    Result := ''; // shouldn't ever happen
End; // GetStringConfigurationInformationProperty

Procedure TExchequerConfigurationInformation.SetStringConfigurationInformationProperty (Const Id : Integer; Value : ShortString);
Var
  Idx : Integer;
Begin // SetStringConfigurationInformationProperty
  Idx := IndexOf (Id);
  If (Idx >= 0) Then
    FConfigurationValues[Idx].ecdCurrentValue := Value;
End; // SetStringConfigurationInformationProperty

//-----------------------------------

Function TExchequerConfigurationInformation.GetAccountStockAnalysis : Boolean;
Begin // GetAccountStockAnalysis
  Result := GetConfigurationInformationProperty (IdxAccountStockAnalysis);
End; // GetAccountStockAnalysis
Procedure TExchequerConfigurationInformation.SetAccountStockAnalysis (Value : Boolean);
Begin // SetAccountStockAnalysis
  SetConfigurationInformationProperty (IdxAccountStockAnalysis, Value);
End; // SetAccountStockAnalysis

//-----------------------------------

Function TExchequerConfigurationInformation.GetImporter : Boolean;
Begin // GetImporter
  Result := GetConfigurationInformationProperty (IdxImportModule);
End; // GetImporter
Procedure TExchequerConfigurationInformation.SetImporter (Value : Boolean);
Begin // SetImporter
  SetConfigurationInformationProperty (IdxImportModule, Value);
End; // SetImporter

//-----------------------------------

Function TExchequerConfigurationInformation.GetJobCosting : Boolean;
Begin // GetJobCosting
  Result := GetConfigurationInformationProperty (IdxJobCosting);
End; // GetJobCosting
Procedure TExchequerConfigurationInformation.SetJobCosting (Value : Boolean);
Begin // SetJobCosting
  SetConfigurationInformationProperty (IdxJobCosting, Value);
End; // SetJobCosting

//-----------------------------------

Function TExchequerConfigurationInformation.GetODBC : Boolean;
Begin // GetODBC
  Result := GetConfigurationInformationProperty (IdxODBC);
End; // GetODBC
Procedure TExchequerConfigurationInformation.SetODBC (Value : Boolean);
Begin // SetODBC
  SetConfigurationInformationProperty (IdxODBC, Value);
End; // SetODBC

//-----------------------------------

Function TExchequerConfigurationInformation.GetReportWriter : Boolean;
Begin // GetReportWriter
  Result := GetConfigurationInformationProperty (IdxReportWriter);
End; // GetReportWriter
Procedure TExchequerConfigurationInformation.SetReportWriter (Value : Boolean);
Begin // SetReportWriter
  SetConfigurationInformationProperty (IdxReportWriter, Value);
End; // SetReportWriter

//-----------------------------------

Function TExchequerConfigurationInformation.GetTelesales : Boolean;
Begin // GetTelesales
  Result := GetConfigurationInformationProperty (IdxTelesales);
End; // GetTelesales
Procedure TExchequerConfigurationInformation.SetTelesales (Value : Boolean);
Begin // SetTelesales
  SetConfigurationInformationProperty (IdxTelesales, Value);
End; // SetTelesales

//-----------------------------------

Function TExchequerConfigurationInformation.GetToolkitRuntime : Boolean;
Begin // GetToolkitRuntime
  Result := GetConfigurationInformationProperty (IdxToolkitRuntime);
End; // GetToolkitRuntime
Procedure TExchequerConfigurationInformation.SetToolkitRuntime (Value : Boolean);
Begin // SetToolkitRuntime
  SetConfigurationInformationProperty (IdxToolkitRuntime, Value);
End; // SetToolkitRuntime

//-----------------------------------

Function TExchequerConfigurationInformation.GeteBusiness : Boolean;
Begin // GeteBusiness
  Result := GetConfigurationInformationProperty (IdxeBusiness);
End; // GeteBusiness
Procedure TExchequerConfigurationInformation.SeteBusiness (Value : Boolean);
Begin // SeteBusiness
  SetConfigurationInformationProperty (IdxeBusiness, Value);
End; // SeteBusiness

//-----------------------------------

Function TExchequerConfigurationInformation.GetPaperlessModule : Boolean;
Begin // GetPaperlessModule
  Result := GetConfigurationInformationProperty (IdxPaperless);
End; // GetPaperlessModule
Procedure TExchequerConfigurationInformation.SetPaperlessModule (Value : Boolean);
Begin // SetPaperlessModule
  SetConfigurationInformationProperty (IdxPaperless, Value);
End; // SetPaperlessModule

//-----------------------------------

Function TExchequerConfigurationInformation.GetOLESaveFunctions : Boolean;
Begin // GetOLESaveFunctions
  Result := GetConfigurationInformationProperty (IdxOLESaveFunctions);
End; // GetOLESaveFunctions
Procedure TExchequerConfigurationInformation.SetOLESaveFunctions (Value : Boolean);
Begin // SetOLESaveFunctions
  SetConfigurationInformationProperty (IdxOLESaveFunctions, Value);
End; // SetOLESaveFunctions

//-----------------------------------

Function TExchequerConfigurationInformation.GetCommitmentAccounting : Boolean;
Begin // GetCommitmentAccounting
  Result := GetConfigurationInformationProperty (IdxCommitmentAccounting);
End; // GetCommitmentAccounting
Procedure TExchequerConfigurationInformation.SetCommitmentAccounting (Value : Boolean);
Begin // SetCommitmentAccounting
  SetConfigurationInformationProperty (IdxCommitmentAccounting, Value);
End; // SetCommitmentAccounting

//-----------------------------------

Function TExchequerConfigurationInformation.GetTradeCounter : Boolean;
Begin // GetTradeCounter
  Result := GetConfigurationInformationProperty (IdxTradeCounter);
End; // GetTradeCounter
Procedure TExchequerConfigurationInformation.SetTradeCounter (Value : Boolean);
Begin // SetTradeCounter
  SetConfigurationInformationProperty (IdxTradeCounter, Value);
End; // SetTradeCounter

//-----------------------------------

Function TExchequerConfigurationInformation.GetStandardWorksOrderProcessing : Boolean;
Begin // GetStandardWorksOrderProcessing
  Result := GetConfigurationInformationProperty (IdxStandardWOP);
End; // GetStandardWorksOrderProcessing
Procedure TExchequerConfigurationInformation.SetStandardWorksOrderProcessing (Value : Boolean);
Begin // SetStandardWorksOrderProcessing
  SetConfigurationInformationProperty (IdxStandardWOP, Value);
End; // SetStandardWorksOrderProcessing

//-----------------------------------

Function TExchequerConfigurationInformation.GetProfessionalWorksOrderProcessing : Boolean;
Begin // GetProfessionalWorksOrderProcessing
  Result := GetConfigurationInformationProperty (IdxProfessionalWOP);
End; // GetProfessionalWorksOrderProcessing
Procedure TExchequerConfigurationInformation.SetProfessionalWorksOrderProcessing (Value : Boolean);
Begin // SetProfessionalWorksOrderProcessing
  SetConfigurationInformationProperty (IdxProfessionalWOP, Value);
End; // SetProfessionalWorksOrderProcessing

//-----------------------------------

Function TExchequerConfigurationInformation.GetSentimail : Boolean;
Begin // GetSentimail
  Result := GetConfigurationInformationProperty (IdxSentimail);
End; // GetSentimail
Procedure TExchequerConfigurationInformation.SetSentimail (Value : Boolean);
Begin // SetSentimail
  SetConfigurationInformationProperty (IdxSentimail, Value);
End; // SetSentimail

//-----------------------------------

Function TExchequerConfigurationInformation.GetEnhancedSecurity : Boolean;
Begin // GetEnhancedSecurity
  Result := GetConfigurationInformationProperty (IdxEnhancedSecurity);
End; // GetEnhancedSecurity
Procedure TExchequerConfigurationInformation.SetEnhancedSecurity (Value : Boolean);
Begin // SetEnhancedSecurity
  SetConfigurationInformationProperty (IdxEnhancedSecurity, Value);
End; // SetEnhancedSecurity

//-----------------------------------

Function TExchequerConfigurationInformation.GetJobCostingCISRCT : Boolean;
Begin // GetJobCostingCISRCT
  Result := GetConfigurationInformationProperty (IdxCISRCT);
End; // GetJobCostingCISRCT
Procedure TExchequerConfigurationInformation.SetJobCostingCISRCT (Value : Boolean);
Begin // SetJobCostingCISRCT
  SetConfigurationInformationProperty (IdxCISRCT, Value);
End; // SetJobCostingCISRCT

//-----------------------------------

Function TExchequerConfigurationInformation.GetJobCostingAppsVals : Boolean;
Begin // GetJobCostingAppsVals
  Result := GetConfigurationInformationProperty (IdxAppsVals);
End; // GetJobCostingAppsVals
Procedure TExchequerConfigurationInformation.SetJobCostingAppsVals (Value : Boolean);
Begin // SetJobCostingAppsVals
  SetConfigurationInformationProperty (IdxAppsVals, Value);
End; // SetJobCostingAppsVals

//-----------------------------------

Function TExchequerConfigurationInformation.GetFullStock : Boolean;
Begin // GetFullStock
  Result := GetConfigurationInformationProperty (IdxFullStock);
End; // GetFullStock
Procedure TExchequerConfigurationInformation.SetFullStock (Value : Boolean);
Begin // SetFullStock
  SetConfigurationInformationProperty (IdxFullStock, Value);
End; // SetFullStock

//-----------------------------------

Function TExchequerConfigurationInformation.GetVisualReportWriter : Boolean;
Begin // GetVisualReportWriter
  Result := GetConfigurationInformationProperty (IdxVisualReportWriter);
End; // GetVisualReportWriter
Procedure TExchequerConfigurationInformation.SetVisualReportWriter (Value : Boolean);
Begin // SetVisualReportWriter
  SetConfigurationInformationProperty (IdxVisualReportWriter, Value);
End; // SetVisualReportWriter

//-----------------------------------

Function TExchequerConfigurationInformation.GetGoodsReturns : Boolean;
Begin // GetGoodsReturns
  Result := GetConfigurationInformationProperty (IdxGoodsReturns);
End; // GetGoodsReturns
Procedure TExchequerConfigurationInformation.SetGoodsReturns (Value : Boolean);
Begin // SetGoodsReturns
  SetConfigurationInformationProperty (IdxGoodsReturns, Value);
End; // SetGoodsReturns

//-----------------------------------

Function TExchequerConfigurationInformation.GeteBanking : Boolean;
Begin // GeteBanking
  Result := GetConfigurationInformationProperty (IdxeBanking);
End; // GeteBanking
Procedure TExchequerConfigurationInformation.SeteBanking (Value : Boolean);
Begin // SeteBanking
  SetConfigurationInformationProperty (IdxeBanking, Value);
End; // SeteBanking

//-----------------------------------

Function TExchequerConfigurationInformation.GetOutlookDynamicDashboard : Boolean;
Begin // GetOutlookDynamicDashboard
  Result := GetConfigurationInformationProperty (IdxOutlookDynamicDashboard);
End; // GetOutlookDynamicDashboard
Procedure TExchequerConfigurationInformation.SetOutlookDynamicDashboard (Value : Boolean);
Begin // SetOutlookDynamicDashboard
  SetConfigurationInformationProperty (IdxOutlookDynamicDashboard, Value);
End; // SetOutlookDynamicDashboard

//-----------------------------------

Function TExchequerConfigurationInformation.GetExchequerEdition : ShortString;
Begin // GetExchequerEdition
  Result := GetStringConfigurationInformationProperty (IdxExchequerEdition);
End; // GetExchequerEdition
Procedure TExchequerConfigurationInformation.SetExchequerEdition (Value : ShortString);
Begin // SetExchequerEdition
  SetStringConfigurationInformationProperty (IdxExchequerEdition, Value);
End; // SetExchequerEdition

//-----------------------------------

Function TExchequerConfigurationInformation.GetStock : Boolean;
Begin // GetStock
  Result := GetConfigurationInformationProperty (IdxStock);
End; // GetStock
Procedure TExchequerConfigurationInformation.SetStock (Value : Boolean);
Begin // SetStock
  SetConfigurationInformationProperty (IdxStock, Value);
End; // SetStock

//-----------------------------------

Function TExchequerConfigurationInformation.GetSPOP : Boolean;
Begin // GetSPOP
  Result := GetConfigurationInformationProperty (IdxSPOP);
End; // GetSPOP
Procedure TExchequerConfigurationInformation.SetSPOP (Value : Boolean);
Begin // SetSPOP
  SetConfigurationInformationProperty (IdxSPOP, Value);
End; // SetSPOP

//-----------------------------------

Function TExchequerConfigurationInformation.GetCurrencyEdition : ShortString;
Begin // GetCurrencyEdition
  Result := GetStringConfigurationInformationProperty (IdxCurrency);
End; // GetCurrencyEdition
Procedure TExchequerConfigurationInformation.SetCurrencyEdition (Value : ShortString);
Begin // SetCurrencyEdition
  SetStringConfigurationInformationProperty (IdxCurrency, Value);
End; // SetCurrencyEdition

//-----------------------------------

Function TExchequerConfigurationInformation.GetLastErrorString : ANSIString;
Begin // GetLastErrorString
  Result := FLastErrorString;
End; // GetLastErrorString

//=========================================================================

Initialization
  lExchequerConfigurationInformation := NIL;
Finalization
  lExchequerConfigurationInformation := NIL;
End.