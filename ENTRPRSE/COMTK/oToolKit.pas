unit oToolKit;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARN SYMBOL_PLATFORM OFF}

interface

uses ActiveX, Classes, ComObj, Dialogs, Forms, StdVcl, SysUtils, Windows,
     GlobVar, VarConst, VarCnst3, VarToolk,
     {$IFNDEF WANTEXE04}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     EnterpriseBeta_TLB, MiscFunc, oCust,
     oTrans, oSetup, oFuncs, oStock, oConfig, oEntrprs, oGL, oLoc, oCCDept,
     oCompany, oJobCost, oEBus, oUser, oDetails, oSysProc, GlobList, VarRec2U,
     oBanking, oVAT100, Messages;

type
  TObjInitType = (itFull, itCloseTK);

  TToolkit = class(TAutoObject, IToolkit, IToolkit2, IToolkit3, ICSNFToolkit)
  private
    FToolkitStatus : TToolkitStatus;

    // Multi-Company Manager object
    FCompanyO      : TCompanyManager;
    FCompanyI      : ICompanyManager;

    // Configuration Sub-object
    FConfigO       : TConfiguration;
    FConfigI       : IConfiguration;

    // Cost Centre sub-object
    FCCO           : TCCDept;
    FCCI           : ICCDept;

    // Customer sub-object
    FCustomerO     : TAccount;
    FCustomerI     : IAccount;

    // Department sub-object
    FDeptO         : TCCDept;
    FDeptI         : ICCDept;

    // eBusiness sub-object
    FEBusO         : TEBusiness;
    FEBusI         : IEBusiness;

    // Enterprise sub-object
    FEnterpriseO   : TEnterprise;
    FEnterpriseI   : IEnterprise;

    // Functions sub-object
    FFunctionO     : TFunctions;
    FFunctionI     : IFunctions;

    // General Ledger/Nominal sub-object
    FGLO           : TGeneralLedger;
    FGLI           : IGeneralLedger;

    // Job Costing sub-object
    FJCostO        : TJobCosting;
    FJCostI        : IJobCosting;

    // Location sub-object
    FLocO          : TLocation;
    FLocI          : ILocation;

    // Stock sub-object
    FStockO        : TStock;
    FStockI        : IStock;

    // Supplier sub-object
    FSupplierO     : TAccount;
    FSupplierI     : IAccount;

    // System Setup sub-object
    FSetupO        : TSystemSetup;
    FSetupI        : ISystemSetup;

    // Transaction sub-object
    FTransactionO  : TTransaction;
    FTransactionI  : ITransaction;

    FSystemProcessesO : TSystemProcesses;
    FSystemProcessesI : ISystemProcesses;


    //IToolkit2 objects

    //User Profile sub-object
    FUserProfileO  : TUserProfile;
    FUserProfileI  : IUserProfile;

    //Transaction Details sub-object
    FTransDetailsO : TTransactionDetails;
    FTransDetailsI : ITransactionDetails;

    //BtrIntf for LineSerialBatch
    FSerialNoBtrIntf : TCtkTdPostExLocalPtr;
    FMultiBinBtrIntf : TCtkTdPostExLocalPtr;

    FBankingO : TBanking;
    FBankingI : IBanking;

    // VAT100 sub-object
    FVAT100O : TVAT100;
    FVAT100I : IVAT100;

    FCompanyCode : string;

    procedure FindEnterpriseDir;
    procedure LoadIniFile;
    procedure InitObjs (Const InitType : TObjInitType);
    function GetCompanyCode: string;
  protected
    { Protected declarations }
    function Get_Version: WideString; Safecall;
    function Get_Customer: IAccount; Safecall;
    function Get_Transaction: ITransaction; safecall;
    function  Get_Status: TToolkitStatus; safecall;
    function  OpenToolkit: Integer; safecall;
    function  CloseToolkit: Integer; safecall;
    function  Get_Functions: IFunctions; safecall;
    function  Get_SystemSetup: ISystemSetup; safecall;
    function  Get_Stock: IStock; safecall;
    function  Get_Configuration: IConfiguration; safecall;
    function  Get_LastErrorString: WideString; safecall;
    function  Get_Enterprise: IEnterprise; safecall;
    function  Get_Supplier: IAccount; safecall;
    function  Get_GeneralLedger: IGeneralLedger; safecall;
    function  Get_Location: ILocation; safecall;
    function  Get_CostCentre: ICCDept; safecall;
    function  Get_Department: ICCDept; safecall;
    function  Get_Company: ICompanyManager; safecall;
    function  Get_JobCosting: IJobCosting; safecall;
    function  Get_eBusiness: IEBusiness; safecall;
    //IToolkit2 methods
    function Get_UserProfile: IUserProfile; safecall;
    function Get_TransactionDetails: ITransactionDetails; safecall;
    function Get_SystemProcesses: ISystemProcesses; safecall;
    //IToolkit3
    function Get_Banking: IBanking; safecall;

    // Local methods
    Function GetCustomer : TAccount;
    Function GetLocation : TLocation;
    Function GetStock : TStock;
    Function GetSupplier : TAccount;
    Function GetSystemSetupO : TSystemSetup;
    Function GetSystemSetupI : ISystemSetup;
    Function GetJobCosting : TJobCosting;
    Function GetConfigurationI : IConfiguration;
    function GetFunctionsI : IFunctions;
    function GetTransactionO : TTransaction;
    function GetEnterpriseI : IEnterprise;
    function GetUserI : IUserProfile;
    function GetSerialNoBtrIntf : TCtkTdPostExLocalPtr;
    function GetMultiBinBtrIntf : TCtkTdPostExLocalPtr;
    function GetJobCostingI : IJobCosting;
    function Get_VAT100: IVAT100; safecall;
  public
    procedure Initialize; override;
    Destructor Destroy; override;

    Procedure EnterpriseDirChanged;

    Property ConfigI : IConfiguration Read GetConfigurationI;
    Property CustomerO : TAccount Read GetCustomer;
    Property LocationO : TLocation Read GetLocation;
    Property Status : TToolkitStatus Read FToolkitStatus;
    Property StockO : TStock Read GetStock;
    Property SupplierO : TAccount Read GetSupplier;
    Property SystemSetupO : TSystemSetup Read GetSystemSetupO;
    Property SystemSetupI : ISystemSetup Read GetSystemSetupI;
    Property JobCostingO : TJObCosting Read GetJobCosting;
    property FuncsI : IFunctions read GetFunctionsI;
    property TransactionO : TTransaction read GetTransactionO;
    property EnterpriseI : IEnterprise read GetEnterpriseI;
    property UserI : IUserProfile read GetUserI;
    property SerialNoBtrIntf : TCtkTdPostExLocalPtr read GetSerialNoBtrIntf;
    property MultiBinBtrIntf : TCtkTdPostExLocalPtr read GetMultiBinBtrIntf;
    property JobCostingI : IJobCosting read GetJobCostingI;
    property CompanyCode : string read GetCompanyCode;
    property VAT100: IVAT100 read Get_VAT100;
  end;

  var
    DummyBool : Boolean;

implementation

uses ComServ, Registry, BtrvU2, InitDLLU, DllErrU, LogFile, COMTKVer, ErrLogs, VAOUtil, oBankAcc,
  EntLicence {$IFDEF WANTEXE},CtkUtil04{$ELSE},CtkUtil{$ENDIF}, MultiBuyVar,
  AuditInfo,
  //PR: 15/02/2012 ABSEXCH-9795
  QtyBreakVar,
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  MadExcept,

  //PR: 06/11/2014 ABSEXCH-15700
  SQLUtils,

  // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Modified printing to keep a pool of Forms Toolkit
  //                                           instances to improve printing speed
  oFormsToolkitPoolManager,
  LogUtil;

{-------------------------------------------------------------------------------------------------}

// Wish List


Procedure InitCompDllEx (DataPath : ShortString); external 'EntComp2.dll';

{-------------------------------------------------------------------------------------------------}

procedure TToolkit.Initialize;
Var
  Res : SmallInt;
begin { Initialize }
  inherited Initialize;

  LogF.AddLogMessage ('IToolkit', 'Initialise');
  FSerialNoBtrIntf := nil; //just to make sure
  InitObjs (itFull);

  FToolkitStatus := tkClosed;

  LastErDesc := '';

  // Start Btrieve interface
  Ex_InitBtrieve;

  // Find and load ExchDLL.Ini settings
  LoadIniFile;

  // Find Enterprise directory
  FindEnterpriseDir;
  if DummyBool then
    InitCompDllEx('');

  InitAudit;
  
  LogF.AddLogMessage ('IToolkit', 'Initialise 2');
end; { Initialize }

{-----------------------------------------}

Destructor TToolkit.Destroy;
Begin { Destroy }
  LogF.AddLogMessage ('IToolkit', 'Destroy');
  FinalizeMultiBacs;
  If (FToolkitStatus = tkOpen) Then
    // shutdown Toolkit
    CloseToolkit;

  { Destroy sub-objects }
  InitObjs (itFull);
  ResetVAOInfo;
  LogF.AddLogMessage ('IToolkit', 'Destroy 2');
  {$IFDEF WANTEXE}
  PostMessage(Application.MainForm.Handle, WM_Close, 0, 0);
  {$ENDIF}
  inherited Destroy;

End; { Destroy }

{-----------------------------------------}

procedure TToolkit.InitObjs (Const InitType : TObjInitType);
begin
  LogF.AddLogMessage ('IToolkit', 'InitObjs');

  { Check for type of initialisaton - some objects should remain intact if only a Toolkit Close }
  If (InitType <> itCloseTK) Then Begin
    // Multi-Company Manager object
    FCompanyO := NIL;
    FCompanyI := NIL;

    // Configuration
    FConfigO := NIL;
    FConfigI := NIL;

    // Enterprise link sub-object
    FEnterpriseO := NIL;
    FEnterpriseI := NIL;
  End; { If (InitType <> itCloseTK) }

  // Cost Centre sub-object
  FCCO := Nil;
  FCCI := Nil;

  // Customer
  FCustomerO := Nil;
  FCustomerI := Nil;

  // Department sub-object
  FDeptO := NIL;
  FDeptI := NIL;

  // eBusiness sub-object
  FEBusO := NIL;
  FEBusI := NIL;

  // Functions
  FFunctionO := Nil;
  FFunctionI := Nil;

  // General Ledger/Nominal sub-object
  FGLO := Nil;
  FGLI := Nil;

  // Job Costing sub-object
  FJCostO := NIL;
  FJCostI := NIL;

  // Location sub-object
  FLocO := Nil;
  FLocI := Nil;

  // Stock
  FStockO := Nil;
  FStockI := Nil;

  // Supplier sub-object
  FSupplierO := Nil;
  FSupplierI := Nil;

  // System Setup
  FSetupO    := Nil;
  FSetupI    := Nil;

  // Transaction
  FTransactionO := Nil;
  FTransactionI := Nil;

  FUserProfileO  := nil;
  FUserProfileI  := nil;

  //Transaction Details sub-object
  FTransDetailsO := nil;
  FTransDetailsI := nil;

  //Banking
  FBankingO := nil;
  FBankingI := nil;

  // VAT100
  FVAT100O := nil;
  FVAT100I := nil;

  if Assigned(FSerialNoBtrIntf) then
    Dispose(FSerialNoBtrIntf, Destroy);
  FSerialNoBtrIntf := nil;

end;

{-----------------------------------------}

// Find and load ExchDLL.Ini settings
procedure TToolkit.LoadIniFile;
Var
  IniPath : ShortString;
  Res     : SmallInt;
begin { LoadIniFile }
  // Get path of .INI file
  IniPath := FindExchDllIniFile;
  If FileExists (IniPath) Then Begin
    // Initialise the ExchDll.Ini flags
    InitExSyss;

    // File exists - load details
    Res := Process_File(IniPath);
    If (Res <> 0) Then
      // Error Reading ExchDll.Ini file
      Raise Exception.Create ('Exchequer.Toolkit: Error ' + IntToStr(Res) + ' reading ExchDll.Ini configuration file, ' + QuotedStr(IniPath));
  End { If FileExists (IniPath)  }
  Else
    // No ExchDll.Ini
    Raise Exception.Create ('Exchequer.Toolkit: Cannot find the ExchDll.Ini configuration file');
end; { LoadIniFile }

{-----------------------------------------}

// HM 17/08/04: Modified for VAO support
// Find Enterprise Programs directory and Company.Dat directory
Procedure TToolkit.FindEnterpriseDir;
//Var
//  ComTkDir, ErrStr : ShortString;
//  ModuleNameBuffer : Array [0..255] of char;
//  LengthModuleName : Integer;
Begin { FindEnterpriseDir }
  ExSyss.BatchPath := VAOInfo.vaoCompanyDir;

//  ExSyss.BatchPath := '';
//
//  // Extract COM Toolkit Path and Name from Windows
//  FillChar(ModuleNameBuffer, SizeOf(ModuleNameBuffer), #0);
//  LengthModuleName := GetModuleFileName(HInstance, ModuleNameBuffer, SizeOf(ModuleNameBuffer));
//  If (LengthModuleName > 0) Then
//    ComTkDir := IncludeTrailingBackslash(ExtractFileDir(ModuleNameBuffer));
//
//  If ValidateEnterpriseDirectory (ComTkDir, ErrStr) Then Begin
//    // Enough files to make COM Tk happy
//    ExSyss.BatchPath := ComTkDir;
//  End { If FileExists (ExSyss.EntProgDir + 'ENTER1.EXE') }
//  Else Begin
//    // No programs in COM TK dir - look for registered Enterprise dir in Registry
//    With TRegistry.Create Do
//      Try
//        Access := KEY_READ;
//        RootKey := HKEY_LOCAL_MACHINE;
//
//        If OpenKey('Software\Exchequer\Enterprise', False) Then Begin
//          { Key opened ok }
//          ComTKDir := IncludeTrailingBackslash (Trim(ReadString ('LastDir')));
//
//          If ValidateEnterpriseDirectory (ComTkDir, ErrStr) Then
//            // Enough files to make COM Tk happy
//            ExSyss.BatchPath := ComTkDir;
//        End; { If OpenKey('Software\Exchequer\Enterprise', False) }
//      Finally
//        CloseKey;
//        Free;
//      End;
//  End; { Else }
End; { FindEnterpriseDir }

{-----------------------------------------}

function TToolkit.OpenToolkit: Integer;
var
  FileNums : TFileNumSet;
  ErrStr   : ShortString;
  I        : Integer;
  KeyS : Str255;
Begin { OpenToolkit }
  LogF.AddLogMessage ('IToolkit', 'OpenToolkit');
  OutputDebug('COM Toolkit OpenToolkit Start');

  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    Result := -1;

    If (FToolkitStatus = tkClosed) Then Begin
      // HM 05/11/04: Added instance locking to prevent data corruption
      If (GlobalTKLock = 0) Then
      Begin
        Inc (GlobalTKLock);

        // Check Btrieve is available
        If Check4BtrvOk Then Begin
          // Set Data Path
          SetDrive := ExSyss.ExPath;
          If ValidateDataDirectory (SetDrive, ErrStr) Then Begin
            // Set Currency Version
            ExSyss.MCMode := FileExists (IncludeTrailingBackslash(SetDrive) + 'DEFMC044.SYS');

            // Build set of files to open
            FileNums := [];
            For I := 1 To SysF Do Include(FileNums, I);
            Include(FileNums, MultiBuyF);

            //PR: 15/02/2012 ABSEXCH-9795
            Include(FileNums, QtyBreakF);

            FindEnterpriseDir;

            // Open Toolkit
            Result := InitialiseDLLMain(FileNums, 3);

            If (Result = 0) Then
            begin
              FToolkitStatus := tkOpen;

              //PR: 02/03/2015 ABSEXCH-15880 Do GetGEq for redirected customer discount file to let
              //                             BtrvSQL create a redirector for the global files.
              //                             Patch copied from v7.0.10 ABSEXCH-5700
              if SQLUtils.UsingSQL then
              begin
                KeyS := CDDiscCode + 'C';
                Find_Rec(B_GetGEq, F[MiscF], MiscF, RecPtr[MiscF]^, 0, KeyS);
              end;

            end
            Else
              LastErDesc := Ex_ErrorDescription(1, Result);
          End { If Check4BtrvOk }
          Else Begin
            // Invalid Data Directory
            Result := -4;
            LastErDesc := ErrStr;
          End; { If ValidateDataDirectory (SetDrive) }
        End { If Check4BtrvOk }
        Else Begin
          // Btrieve not available
          Result := -3;
          LastErDesc := 'Btrieve Not Available';
        End; { Else }
      End // If (GlobalTKLock = 0)
      Else
      Begin
        // Toolkit already in use
        Result := 32762;
        LastErDesc := 'This instance of the Toolkit is already in use';
      End; // Else
    End { If }
    Else Begin
      { Toolkit already open }
      Result := -2;
      LastErDesc := 'The COM Toolkit is already open';
    End; { Else }

    // HM 05/11/04: Added result logging into OpenToolkit
    If (Result <> 0) Then AddInitErrorLog (Result, LastErDesc);

    if Result = 0 then
      FCompanyCode := CompanyCodeFromPath(Self as IToolkit, ExSyss.ExPath);

    OutputDebug('COM Toolkit OpenToolkit End');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End; { OpenToolkit }

{-----------------------------------------}

function TToolkit.CloseToolkit: Integer;
begin { CloseToolkit }
  LogF.AddLogMessage ('IToolkit', 'CloseToolkit');

  // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Clear out the Forms Toolkit Pool Manager if it is running
  FlushFormsToolkitPoolManager;

  {Call the CloseAll method on the Global list object to close any open data files}
  GlobalBtrList.CloseAll;
  { Destroy any Btrieve using sub-objects }
  InitObjs (itCloseTK);

  { End link to Toolkit }
  Result := Ex_CloseData;
  FToolkitStatus := tkClosed;
end; { CloseToolkit }

{-----------------------------------------}

function TToolkit.Get_Version: WideString;
begin
  //
  // See History.Txt for a detailed list of the changes
  //
  //Result := 'TKCOM-b500.111';          // Beta Version
  //Result := 'TKCOM-v5.00.113';       // Release Version

  // HM 02/04/02 - Modified version layout to allow comparison between beta and non-beta versions
  //Result := 'TKCOM-560.245';       // Release Version

  // HM 05/11/04: Moved version number out of oToolkit.Pas so it could be
  // referenced by the error logging
  Result := COMTKVersion;   // Now stored in COMTKVer.Pas
end;

{-----------------------------------------}

Function TToolkit.GetCustomer : TAccount;
Var
  DummyI : IAccount;
begin
  // Check Customer sub-object exists
  If Not Assigned(FCustomerO) Then
    // Force creation of Customer Object and Interface
    DummyI := Get_Customer;

  // Return reference to Customer Object
  Result := FCustomerO;
end;

{-----------------------------------------}

function TToolkit.Get_Customer: IAccount;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    If (Not Assigned(FCustomerO)) Then Begin
      { Create and initialise Customer Details }
      //FCustomerO := TAccount.Create('C', imGeneral, Nil, 1);
      FCustomerO := CreateTAccount (Self, 'C', 1);

      FCustomerI := FCustomerO;
    End; { If (Not Assigned(FCustomerO)) }

    Result := FCustomerI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the Customer object is available');
end;

{-----------------------------------------}

function TToolkit.Get_Transaction: ITransaction;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    If (Not Assigned(FTransactionO)) Then Begin
      { Create and initialise Transaction Details }
      //FTransactionO := TTransaction.Create(imGeneral, Self, Nil, 4);
      FTransactionO := CreateTTransaction (Self, 4);

      FTransactionI := FTransactionO;
    End; { If (Not Assigned(FTransactionO)) }

    Result := FTransactionI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the Transactions object is available');
end;

{-----------------------------------------}

function TToolkit.Get_Status: TToolkitStatus;
begin
  Result := FToolkitStatus;
end;

{-----------------------------------------}

function TToolkit.Get_Functions: IFunctions;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    If (Not Assigned(FFunctionO)) Then Begin
      { Create and initialise Transaction Details }
      FFunctionO := TFunctions.Create;

      FFunctionI := FFunctionO;
    End; { If (Not Assigned(FFunctionO)) }

    Result := FFunctionI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the Functions object is available');
end;

{-----------------------------------------}

Function TToolkit.GetSystemSetupO : TSystemSetup;
Var
  DummyI : ISystemSetup;
begin
  // Check System Setup sub-object exists
  If Not Assigned(FSetupO) Then
    // Force creation of System Setup Object and Interface
    DummyI := Get_SystemSetup;

  // Return reference to System Setup Object
  Result := FSetupO;
end;

{-----------------------------------------}

Function TToolkit.GetSystemSetupI : ISystemSetup;
begin
  Result := Get_SystemSetup;
end;

{-----------------------------------------}

function TToolkit.Get_SystemSetup: ISystemSetup;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    If (Not Assigned(FSetupO)) Then Begin
      { Create and initialise System Setup sub-object }
      FSetupO := TSystemSetup.Create;

      FSetupI := FSetupO;
    End; { If (Not Assigned(FSetupO)) }

    { Return Setup interface }
    Result := FSetupI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the SystemSetup object is available');
end;

{-----------------------------------------}

Function TToolkit.GetStock : TStock;
Var
  DummyI : IStock;
begin
  // Check stock sub-object exists
  If Not Assigned(FStockO) Then
    // Force creation of Stock Object and Interface
    DummyI := Get_Stock;

  // Return reference to Stock Object
  Result := FStockO;
end;

{-----------------------------------------}

function TToolkit.Get_Stock: IStock;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    if StockOn then
    begin
      { Check that Stock object is already initialised }
      If (Not Assigned(FStockO)) Then Begin
        { Create and initialise Stock sub-object }
        //FStockO := TStock.Create(imGeneral, Self, Nil, 3);
        FStockO := CreateTStock (Self, 3);

        FStockI := FStockO;
      End; { If (Not Assigned(FStockO)) }

      { Return Stock interface }
      Result := FStockI;
    end //if StockOn
    else
      raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Stock');
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the Stock object is available');
end;

{-----------------------------------------}

function TToolkit.Get_Configuration: IConfiguration; safecall;
begin
  If (Not Assigned(FConfigO)) Then Begin
    { Create and initialise the toolkit Configuration sub-object }
    FConfigO := TConfiguration.Create(Self);

    FConfigI := FConfigO;
  End; { If (Not Assigned(FConfigO)) }

  Result := FConfigI;
end;

{-----------------------------------------}

function TToolkit.Get_LastErrorString: WideString;
begin
  Result := LastErDesc;
end;

{-----------------------------------------}

function TToolkit.Get_Enterprise: IEnterprise;
begin
  If (Not Assigned(FEnterpriseO)) Then Begin
    { Create and initialise the toolkit Enterprise sub-object }
    FEnterpriseO := TEnterprise.Create(Self);

    FEnterpriseI := FEnterpriseO;
  End; { If (Not Assigned(FEnterpriseO)) }

  Result := FEnterpriseI;
end;

{-----------------------------------------}

Function TToolkit.GetSupplier : TAccount;
Var
  DummyI : IAccount;
begin
  // Check Supplier sub-object exists
  If Not Assigned(FSupplierO) Then
    // Force creation of Supplier Object and Interface
    DummyI := Get_Supplier;

  // Return reference to Supplier Object
  Result := FSupplierO;
end;

{-----------------------------------------}

function TToolkit.Get_Supplier: IAccount;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    If (Not Assigned(FSupplierO)) Then Begin
      { Create and initialise Supplier Details }
      //FSupplierO := TAccount.Create('S', imGeneral, Nil, 2);
      FSupplierO := CreateTAccount (Self, 'S', 2);

      FSupplierI := FSupplierO;
    End; { If (Not Assigned(FSupplierO)) }

    Result := FSupplierI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the Supplier object is available');
end;

{-----------------------------------------}

// General Ledger/Nominal sub-object
function TToolkit.Get_GeneralLedger: IGeneralLedger;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    If (Not Assigned(FGLO)) Then Begin
      { Create and initialise Gerneal Ledger Details }
      FGLO := CreateTGeneralLedger (5);

      FGLI := FGLO;
    End; { If (Not Assigned(FGLO)) }

    Result := FGLI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the General Ledger object is available');
end;

{-----------------------------------------}

Function TToolkit.GetLocation : TLocation;
Var
  DummyI : ILocation;
begin
  // Check Customer sub-object exists
  If Not Assigned(FLocO) Then
    // Force creation of Customer Object and Interface
    DummyI := Get_Location;

  // Return reference to Customer Object
  Result := FLocO;
end;

{-----------------------------------------}

// General Location sub-object
function TToolkit.Get_Location: ILocation;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    if StockOn then
    begin
      If (Not Assigned(FLocO)) Then Begin
        { Create and initialise Location Details }
        FLocO := CreateTLocation (6, Self);

        FLocI := FLocO;
      End; { If (Not Assigned(FLocO)) }

      Result := FLocI;
    end //If StockOn
    else
      raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Stock');

  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the Location object is available');
end;

{-----------------------------------------}

function TToolkit.Get_CostCentre: ICCDept;
Begin { Get_CostCentre }
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    If (Not Assigned(FCCO)) Then Begin
      { Create and initialise Cost Centre Details }
      FCCO := CreateTCCDept (7, CostCCode, CSubCode[True]);

      FCCI := FCCO;
    End; { If (Not Assigned(FCCO)) }

    Result := FCCI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the Cost Centre object is available');
End; { Get_CostCentre }

{-----------------------------------------}

// Department sub-object
function TToolkit.Get_Department: ICCDept;
Begin { Get_Department }
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    If (Not Assigned(FDeptO)) Then Begin
      { Create and initialise Department Details }
      FDeptO := CreateTCCDept (8, CostCCode, CSubCode[False]);

      FDeptI := FDeptO;
    End; { If (Not Assigned(FDeptO)) }

    Result := FDeptI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the Department object is available');
End; { Get_Department }

{-----------------------------------------}

// Multi-Company Manager Interface
function TToolkit.Get_Company: ICompanyManager;
Var
  Path, ErrStr : ShortString;
Begin { Get_Company }
  { Check Enterprise Directory is valid }
  Path := ExSyss.BatchPath;
  If ValidateEnterpriseDirectory(Path, ErrStr) Then Begin
    // Create MCM object if necessary
    If (Not Assigned(FCompanyO)) Then Begin
      FCompanyO := TCompanyManager.Create;

      // Update Company list if required
      //MH/PR 21/04/2008 Moved this line into the not assigned section as it was building the list every time the property was accessed
      FCompanyO.BuildCompanyList(EntDirToCompDir(ExSyss.BatchPath));

      FCompanyI := FCompanyO;
    End; { If (Not Assigned(FCompanyO)) }


    Result := FCompanyI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EValidation.Create (ErrStr);
End; { Get_Company }

{-----------------------------------------}

function TToolkit.Get_JobCosting: IJobCosting;
Begin { Get_JobCosting }
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    if JBCostOn then
    begin
      If (Not Assigned(FJCostO)) Then Begin
        { Create and initialise the Job Costing sub-object }
        FJCostO := TJobCosting.Create(Self);

        FJCostI := FJCostO;
      End; { If (Not Assigned(FJCostO)) }

      Result := FJCostI;
    end //If JBCostOn
    else
      raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Job Costing');
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the JobCosting object is available');
End; { Get_JobCosting }

{-----------------------------------------}

function TToolkit.Get_eBusiness: IEBusiness;
Begin { Get_eBusiness }
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin

    { TODO : Check eBusiness Release Code before giving access to eBusiness sub-object}

    If (Not Assigned(FEBusO)) Then Begin
      { Create and initialise the Job Costing sub-object }
      FEBusO := TEBusiness.Create(Self);

      FEBusI := FEBusO;
    End; { If (Not Assigned(FEBusO)) }

    Result := FEBusI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the eBusiness object is available');
End; { Get_eBusiness }

{-----------------------------------------}

Function TToolkit.GetJobCosting : TJobCosting;
Var
  DummyI : IJobCosting;
begin
  // Check Supplier sub-object exists
  If Not Assigned(FJCostO) Then
    // Force creation of Supplier Object and Interface
    DummyI := Get_JobCosting;

  // Return reference to Supplier Object
  Result := FJCostO;
end;

{-----------------------------------------}

// Called by Configuration object whenever the Enterprise path is changed
Procedure TToolkit.EnterpriseDirChanged;
Begin { EnterpriseDirChanged }
  If Assigned (FEnterpriseO) Then
    FEnterpriseO.LoadEntLicence;
End; { EnterpriseDirChanged }

{-----------------------------------------}

function TToolkit.Get_UserProfile: IUserProfile;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    { Check that Stock object is already initialised }
    If (Not Assigned(FUserProfileO)) Then Begin
      { Create and initialise Stock sub-object }
      FUserProfileO := CreateTUserProfile (Self, 23);

      FUserProfileI := FUserProfileO;
    End; { If (Not Assigned(FStockO)) }

    { Return UserProfle interface }
    Result := FUserProfileI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the UserProfile object is available');
end;

{-----------------------------------------}

function TToolkit.Get_TransactionDetails: ITransactionDetails; safecall;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    { Check that Stock object is already initialised }
    If (Not Assigned(FTransDetailsO)) Then Begin
      { Create and initialise Stock sub-object }
      FTransDetailsO := CreateTTransactionDetails (Self, 24);

      FTransDetailsI := FTransDetailsO;
    End; { If (Not Assigned(FStockO)) }

    { Return UserProfle interface }
    Result := FTransDetailsI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the TransactionDetails object is available');
end;

function TToolkit.Get_SystemProcesses: ISystemProcesses;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    { Check that SysProc object is already initialised }
    If (Not Assigned(FSystemProcessesO)) Then Begin
      { Create and initialise Stock sub-object }
      FSystemProcessesO := TSystemProcesses.Create(Get_Transaction, Self);

      FSystemProcessesI := FSystemProcessesO;
    End; { If (Not Assigned(FStockO)) }

    { Return SystemProcesses interface }
    Result := FSystemProcessesI;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the SystemProcesses object is available');
end;

{-----------------------------------------}

function TToolkit.GetConfigurationI: IConfiguration;
begin
  // Return reference to Configuration Object
  Result := Get_Configuration;
end;

function TToolkit.GetFunctionsI : IFunctions;
begin
  // Return reference to Functions Object
  Result := Get_Functions;
end;

function TToolkit.GetTransactionO : TTransaction;
var
  DummyI : ITransaction;
begin
  If Not Assigned(FTransactionO) Then
    // Force creation of Supplier Object and Interface
    DummyI := Get_Transaction;

  // Return reference to Supplier Object
  Result := FTransactionO;
end;

function TToolkit.GetEnterpriseI : IEnterprise;
begin
  Result := Get_Enterprise;
end;

function TToolkit.GetUserI : IUserProfile;
begin
  Result := Get_UserProfile;
end;

function TToolkit.GetJobCostingI : IJobCosting;
begin
  Result := Get_JobCosting;
end;

function TToolkit.GetSerialNoBtrIntf : TCtkTdPostExLocalPtr;
begin
  if not Assigned(FSerialNoBtrIntf) then
  begin
    New(FSerialNoBtrIntf, Create(22));

    // Open files needed by TStock object
    FSerialNoBtrIntf^.Open_System(StockF, StockF);  { Stock }
    FSerialNoBtrIntf^.Open_System(MiscF,  MiscF);   { Serial/Batch }
    FSerialNoBtrIntf^.Open_System(PwrdF,  PwrdF);   { Serial/Batch Notes }
  end;
  Result := FSerialNoBtrIntf;
end;

function TToolkit.GetMultiBinBtrIntf : TCtkTdPostExLocalPtr;
begin
  if not Assigned(FMultiBinBtrIntf) then
  begin
    New(FMultiBinBtrIntf, Create(38));

    FMultiBinBtrIntf^.Open_System(MLocF,  MLocF);   { Serial/Batch }
    FMultiBinBtrIntf^.Open_System(StockF,  StockF);   { Serial/Batch }
  end;
  Result := FMultiBinBtrIntf;
end;



{-----------------------------------------}

function TToolkit.Get_Banking: IBanking;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin
    if EBankOn or EnterpriseLicence.IsLITE then
    begin

      If (Not Assigned(FBankingO)) Then Begin
        FBankingO := TBanking.Create(Self);

        FBankingI := FBankingO;
      End; { If (Not Assigned(FBankingO)) }

      Result := FBankingI;
    end
    else
      raise EInvalidMethod.Create('This installation of Exchequer is not licenced for eBanking');

  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the Banking object is available');
end;

function TToolkit.GetCompanyCode: string;
begin
  Result := FCompanyCode;
end;

function TToolkit.Get_VAT100: IVAT100;
begin
  { Check Toolkit DLL has been initialised }
  If (FToolkitStatus = tkOpen) Then Begin

    If (Not Assigned(FVAT100O)) Then Begin
      { Create and initialise the VAT100 sub-object }
      FVAT100O := TVAT100.Create(imGeneral, self, VAT_100_ID_GENERAL);

      FVAT100I := FVAT100O;
    End; { If (Not Assigned(FVAT100O)) }

    Result := FVAT100I;
  End { If (FToolkitStatus = tkOpen) }
  Else
    Raise EInvalidMethod.Create ('The Toolkit must be opened before the VAT100 object is available');
end;

initialization
  DummyBool := False;

  TAutoObjectFactory.Create(ComServer, TToolkit, Class_Toolkit,
    ciSingleInstance, tmApartment);

{ShowMessage ('AppPath: ' + Application.ExeName + #13 +
             'CurDir: ' + GetCurrentDir);}
end.
