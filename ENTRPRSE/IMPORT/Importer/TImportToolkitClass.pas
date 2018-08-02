unit TImportToolkitClass;

{******************************************************************************}
{ The IImportToolkit interface allows a caller to access both the COM and DLL  }
{ toolkits through a common set of properties and functions. 11/01/2006 NO it doesn't !}
{ IImportToolkit.ToolkitConfiguration returns an IImportToolkitConfiguration   }
{ interface which is used to set toolkit operation options. In the opposite    }
{ direction, e.g. getting Exchequer's system setup, information is got directly}
{ from IImportToolkit properties.                                              }
{ 12/01/2006: TImportToolkit uses the COM Toolkit for it's own purposes. All   }
{ importing is done with direct calls to the functions which the DLL Toolkit   }
{ exposes. As such, TImportToolkit is now Importer's own toolkit equivalent.   }
{ 10/2006: Apps & Vals records are imported using the COM toolkit.             }
{******************************************************************************}

interface

uses GlobalTypes, oAccountContactRoles;

type
  IImportToolkitConfiguration = interface
    ['{24B463B7-08A7-46B3-9A3D-B2BB1976A970}']

    // Internal Methods to implement Public Properties
    function  Get_AutoSetPeriod: boolean;
    procedure Set_AutoSetPeriod(const Value: boolean);
    function  Get_ImportMode: integer;
    function  Get_TrialImport: boolean;
    procedure Set_TrialImport(const Value: boolean);
    function  Get_CalcTHTotals: boolean;
    procedure Set_CalcTHTotals(const Value: boolean);
    function  Get_AutoSetTHOurRef: boolean;
    procedure Set_AutoSetTHOurRef(const Value: boolean);
    function  Get_AutoSetTHLineCount: boolean;
    procedure Set_AutoSetTHLineCount(const Value: boolean);
    function  Get_AutoSetTLLineNo: boolean;
    procedure Set_AutoSetTLLineNo(const Value: boolean);
    function  Get_AutoSetTLRefFromTH: boolean;
    procedure Set_AutoSetTLRefFromTH(const Value: boolean);
    function  Get_DefaultNominalCode: integer;
    procedure Set_DefaultNominalCode(const Value: integer);
    function  Get_DefaultCostCentre: string;
    procedure Set_DefaultCostCentre(const Value: string);
    function  Get_DefaultDepartment: string;
    procedure Set_DefaultDepartment(const Value: string);
    function  Get_DefaultVATCode: string;
    procedure Set_DefaultVATCode(const Value: string);
    function  Get_AutoSetStockCost: boolean;
    procedure Set_AutoSetStockCost(const Value: boolean);
    function  Get_DeductBOMStock: boolean;
    procedure Set_DeductBOMStock(const Value: boolean);
    function  Get_OverwriteNotepad: boolean;
    procedure Set_OverwriteNotepad(const Value: boolean);
    function  Get_AutoSetCurrencyRates: boolean;
    procedure Set_AutoSetCurrencyRates(const Value: boolean);
    function  Get_AllowTransactionEditing: boolean;
    procedure Set_AllowTransactionEditing(const Value: boolean);
    function  Get_DefaultCurrency: integer;
    procedure Set_DefaultCurrency(const Value: integer);
    function  Get_UpdateAccountBalances: boolean;
    procedure Set_UpdateAccountBalances(const Value: boolean);
    function  Get_UpdateStockLevels: boolean;
    procedure Set_UpdateStockLevels(const Value: boolean);
    function  Get_ValidateJobCostingFields: boolean;
    procedure Set_ValidateJobCostingFields(const Value: boolean);
    function  Get_DeductMultiLocationStock: boolean;
    procedure Set_DeductMultiLocationStock(const Value: boolean);
    function  Get_MultiCurrency: boolean;
    procedure Set_MultiCurrency(const Value: boolean);
    function  Get_UseJobBudgets: boolean;
    procedure Set_UseJobBudgets(const Value: boolean);
    function  Get_ApplyVBD : Boolean;
    procedure Set_ApplyVBD(const Value : Boolean);
    function  Get_ApplyMBD : Boolean;
    procedure Set_ApplyMBD(const Value : Boolean);
    function  Get_OverwriteDiscountDates : Boolean;
    procedure Set_OverwriteDiscountDates(const Value : Boolean);
    // Public Properties
    property  tcAllowTransactionEditing: boolean read Get_AllowTransactionEditing write Set_AllowTransactionEditing;
    property  tcAutoSetCurrencyRates: boolean read Get_AutoSetCurrencyRates write Set_AutoSetCurrencyRates;
    property  tcAutoSetTHLineCount: boolean read Get_AutoSetTHLineCount write Set_AutoSetTHLineCount;
    property  tcAutoSetTLLineNo: boolean read Get_AutoSetTLLineNo write Set_AutoSetTLLineNo;
    property  tcAutoSetTLRefFromTH: boolean read Get_AutoSetTLRefFromTH write Set_AutoSetTLRefFromTH;
    property  tcAutoSetPeriod: boolean read Get_AutoSetPeriod write Set_AutoSetPeriod;
    property  tcAutoSetStockCost: boolean read Get_AutoSetStockCost write Set_AutoSetStockCost;
    property  tcDeductBOMStock: boolean read Get_DeductBOMStock write Set_DeductBOMStock;
    property  tcDeductMultiLocationStock: boolean read Get_DeductMultiLocationStock write Set_DeductMultiLocationStock;
    property  tcDefaultCostCentre: string read Get_DefaultCostCentre write Set_DefaultCostCentre;
    property  tcDefaultCurrency: integer read Get_DefaultCurrency write Set_DefaultCurrency;
    property  tcDefaultDepartment: string read Get_DefaultDepartment write Set_DefaultDepartment;
    property  tcDefaultNominalCode: integer read Get_DefaultNominalCode write Set_DefaultNominalCode;
    property  tcDefaultVATCode: string read Get_DefaultVATCode write Set_DefaultVATCode;
    property  tcImportMode: integer read Get_ImportMode;
    property  tcTrialImport: boolean read Get_TrialImport write Set_TrialImport;
    property  tcUpdateAccountBalances: boolean read Get_UpdateAccountBalances write Set_UpdateAccountBalances;
    property  tcUpdateStockLevels: boolean read Get_UpdateStockLevels write Set_UpdateStockLevels;
    property  tcCalcTHTotals: boolean read Get_CalcTHTotals write Set_CalcTHTotals;
    property  tcAutoSetTHOurRef: boolean read Get_AutoSetTHOurRef write Set_AutoSetTHOurRef;
    property  tcOverwriteNotepad: boolean read Get_OverwriteNotepad write Set_OverwriteNotepad;
    property  tcValidateJobCostingFields: boolean read Get_ValidateJobCostingFields write Set_ValidateJobCostingFields;
    property  tcMultiCurrency: boolean read Get_MultiCurrency write Set_MultiCurrency;
    property  tcUseJobBudgets: boolean read Get_UseJobBudgets write Set_UseJobBudgets;
    property  tcApplyVBD : boolean read Get_ApplyVBD write Set_ApplyVBD;
    property  tcApplyMBD : boolean read Get_ApplyMBD write Set_ApplyMBD;
    property  tcOverwriteDiscountDates : boolean read Get_OverwriteDiscountDates write Set_OverwriteDiscountDates;
    // Public Methods
  end;

  IImportToolkit = interface
    ['{2FF52F0C-FD60-48F9-8A9F-497F199F4151}']

    // Internal Methods to implement Public Properties
    function  Get_CompanyDataPath: string;
    function  Get_Configuration: IImportToolkitConfiguration;
    function  Get_CostPriceDPs: integer;
    function  Get_CurrencyVarianceGLCode: integer;
    function  Get_ExchequerCompany: string;
    procedure Set_ExchequerCompany(const Value: string);
    function  Get_LastErrorDesc: string;
    function  Get_LiveStockCOSVal: boolean; // v.075
    function  Get_QtyDPs: integer;
    function  Get_SalesPriceDPs: integer;
    function  Get_ToolkitOpen: boolean;
    function  Get_UserName: string;
    procedure Set_UserName(const Value: string);
    function  Get_Password: string;
    procedure Set_Password(const Value: string);
    function  Get_ElapsedTime: cardinal;
    function  Get_IsSPOP : Boolean;
    // Public Properties
    property  ToolkitConfiguration: IImportToolkitConfiguration read Get_Configuration;
    property  itExchequerCompany: string read Get_ExchequerCompany write Set_ExchequerCompany;
    property  itCompanyDataPath: string read Get_CompanyDataPath;
    property  itCostPriceDPs: integer read Get_CostPriceDPs;
    property  itCurrencyVarianceGLCode: integer read Get_CurrencyVarianceGLCode;
    property  itLastErrorDesc: string read Get_LastErrorDesc;
    property  itLiveStockCOSVal: boolean read Get_LiveStockCOSVal;
    property  itSalesPriceDPs: integer read Get_SalesPriceDPs;
    property  itQtyDPs: integer read Get_QtyDPs;
    property  itToolkitOpen: boolean read Get_ToolkitOpen;
    property  itUserName: string read Get_UserName write Set_UserName;
    property  itPassword: string read Get_Password write Set_Password;
    property  itElapsedTime: cardinal read Get_ElapsedTime;
    property  itIsSpop : Boolean read Get_IsSPOP;
    // Public Methods
    function  CheckLogin(const AUsername: string; const APassword: string): integer;
    function  CloseImportToolkit: integer;
    function  ConfigureTheToolkit: integer;
    function  GetAccount(P: pointer; PSize: integer; SearchKey: ShortString; SearchPath: integer; SearchMode: smallint; AcctType: smallint; Lock: boolean): integer;
    FUNCTION  GETLINETOTAL(P      : POINTER; PSIZE  : SMALLINT; USEDISCOUNT : WORDBOOL; SETTLEDISC : DOUBLE;
                         VAR LINETOTAL : DOUBLE): SMALLINT;
    function  GetRecordAddress(FileNum: smallint; var RecAddress: longint): smallint;
    function  GetRecWithAddress(FileNum: smallint; KeyPath: smallint; TRecAddr: longint): smallint;
    function  GetSerialBatch(P: pointer; PSize: integer; SearchMode: smallint): integer;
    function  GetSystemSetup: integer;
    function  GetStock(P: pointer; PSize: integer; SearchKey: ShortString; SearchPath: integer; SearchMode: smallint; Lock: boolean): integer;
    function  GetTrans(PH: pointer; PL: pointer; PHSize: integer; PLSize: integer; SearchKey: ShortString; SearchPath: integer; SearchMode: smallint; Lock: boolean): integer;
    function  NextTransNo(const ADocType: string): string;
    function  OpenImportToolkit: integer;
    function  RoundUp(InputValue: double; DecimalPlaces: smallint): double;
    function  StoreAccount(P: pointer; PSize: integer): integer;
    function  StoreAutoBank(P: pointer; PSize: integer): integer;
    function  StoreCCDep(P: pointer; PSize: integer): integer;
    function  StoreDiscMatrix(P: pointer; PSize: integer): integer;
    function  StoreEachBOMLine(P: pointer; PSize: integer): integer;
    function  StoreGLAccount(P: pointer; PSize: integer): integer;
    function  StoreJob(P: pointer; PSize: integer): integer;
    function  StoreJobAnalysis(P: pointer; PSize: integer): integer;
    function  StoreJobEmployee(P: pointer; PSize: integer): integer;
    function  StoreJobTimeRate(P: pointer; PSize: integer): integer;
    function  StoreLocation(P: pointer; PSize: integer): integer;
    function  StoreMatch(P: pointer; PSize: integer): integer;
    function  StoreMultiLocation(P: pointer; PSize: integer): integer;
    function  StoreNotes(P: pointer; PSize: integer): integer;
    function  StoreMultiBin(P: pointer; PSize: integer): integer;
    function  StoreSerialBatch(P: pointer; PSize: integer): integer;
    function  StoreStkAlt(P: pointer; PSize: integer): integer;
    function  StoreStock(P: pointer; PSize: integer): integer;
    function  StoreTrans(PH: pointer; PL: pointer; PHSize: integer; PLSize: integer): integer;
    function  UseSerialBatch(P: pointer; PSize: integer): integer;
	//SSK 13/09/2016 2016-R3 ABSEXCH-15502: This function added to extract BOM Component stocks
    function  GetStockBOMRec(P: pointer; PSize: integer;SearchKey: Shortstring; SearchMode: smallint): integer;

{* Apps and Vals *}
    function  StoreAVJob(P: TBatchAVJobRec): integer;
    function  StoreAVAnalysisBudget(P: TBatchAVABRec): integer;
    function  StoreAVTrans(PH: TManagedRec; PL: TArrayOfManagedRec; ALineCount:integer): integer;
    function StoreMultiBuyDiscount(P : Pointer; PSize : Integer) : integer;
    function StoreContact(P : PImporterAccountContactRec) : Integer;
    function StoreContactRole(P : PImporterAccountContactRoleRec) : Integer;
  end;

function  ImportToolkit: IImportToolkit;
procedure ResetImportToolkit;

implementation

uses Enterprise01_TLB, ComObj, CTKUtil, Utils, dialogs, SysUtils, EntLicence, VAOUtil,oSystemSetup, VarConst,
     InitDLLU, DLLTh_Up, DLL01U, DLLMiscU, DLLSrBOM, DLLJobU, DLLSK01U, DLLBin,
     GlobVar, Crypto, DLLErrU, GlobalConsts, Windows, SecCodes, DllMultiBuy, AuditNoteIntf, LogInF;

type

  TImportToolkitConfiguration = class(TInterfacedObject, IImportToolkitConfiguration)
  private
{* Internal Fields *}
{* Property Fields *}
    FAllowTransactionEditing: boolean;
    FAutoSetCurrencyRates: boolean;
    FAutoSetPeriod: boolean;
    FAutoSetStockCost: boolean;
    FAutoSetTHLineCount: boolean;
    FAutoSetTLLineNo: boolean;
    FAutoSetTLRefFromTH: boolean;
    FDeductBOMStock: boolean;
    FDeductMultiLocationStock: boolean;
    FDefaultCostCentre: string;
    FDefaultCurrency: integer;
    FDefaultDepartment: string;
    FDefaultNominalCode: integer;
    FOverwriteNotepad: boolean;
    FDefaultVATCode: string;
    FUpdateAccountBalances: boolean;
    FUpdateStockLevels: boolean;
    FImportMode: integer;
    FTrialImport: boolean;
    FCalcTHTotals: boolean;
    FAutoSetTHOurRef: boolean;
    FValidateJobCostingFields: boolean;
    FMultiCurrency: boolean;
    FUseJobBudgets: boolean;
    FApplyVBD,
    FApplyMBD : Boolean;
    FOverWriteDiscountDates : Boolean;
{* Getters and Setters *}
    function  Get_AutoSetPeriod: boolean;
    procedure Set_AutoSetPeriod(const Value: boolean);
    function  Get_ImportMode: integer;
    function  Get_TrialImport: boolean;
    procedure Set_TrialImport(const Value: boolean);
    function  Get_CalcTHTotals: boolean;
    procedure Set_CalcTHTotals(const Value: boolean);
    function  Get_AutoSetTHOurRef: boolean;
    procedure Set_AutoSetTHOurRef(const Value: boolean);
    function  Get_AutoSetTHLineCount: boolean;
    procedure Set_AutoSetTHLineCount(const Value: boolean);
    function  Get_AutoSetTLLineNo: boolean;
    procedure Set_AutoSetTLLineNo(const Value: boolean);
    function  Get_AutoSetTLRefFromTH: boolean;
    procedure Set_AutoSetTLRefFromTH(const Value: boolean);
    function  Get_DefaultNominalCode: integer;
    procedure Set_DefaultNominalCode(const Value: integer);
    function  Get_DefaultCostCentre: string;
    procedure Set_DefaultCostCentre(const Value: string);
    function  Get_DefaultDepartment: string;
    procedure Set_DefaultDepartment(const Value: string);
    function  Get_DefaultVATCode: string;
    procedure Set_DefaultVATCode(const Value: string);
    function  Get_AutoSetStockCost: boolean;
    procedure Set_AutoSetStockCost(const Value: boolean);
    function  Get_DeductBOMStock: boolean;
    procedure Set_DeductBOMStock(const Value: boolean);
    function  Get_OverwriteNotepad: boolean;
    procedure Set_OverwriteNotepad(const Value: boolean);
    function  Get_AutoSetCurrencyRates: boolean;
    procedure Set_AutoSetCurrencyRates(const Value: boolean);
    function  Get_AllowTransactionEditing: boolean;
    procedure Set_AllowTransactionEditing(const Value: boolean);
    function  Get_DefaultCurrency: integer;
    procedure Set_DefaultCurrency(const Value: integer);
    function  Get_UpdateAccountBalances: boolean;
    procedure Set_UpdateAccountBalances(const Value: boolean);
    function  Get_UpdateStockLevels: boolean;
    procedure Set_UpdateStockLevels(const Value: boolean);
    function  Get_ValidateJobCostingFields: boolean;
    procedure Set_ValidateJobCostingFields(const Value: boolean);
    function  Get_DeductMultiLocationStock: boolean;
    procedure Set_DeductMultiLocationStock(const Value: boolean);
    function  Get_MultiCurrency: boolean;
    procedure Set_MultiCurrency(const Value: boolean);
    function Get_UseJobBudgets: boolean;
    procedure Set_UseJobBudgets(const Value: boolean);
    function  Get_ApplyVBD : Boolean;
    procedure Set_ApplyVBD(const Value : Boolean);
    function  Get_ApplyMBD : Boolean;
    procedure Set_ApplyMBD(const Value : Boolean);
    function  Get_OverwriteDiscountDates : Boolean;
    procedure Set_OverwriteDiscountDates(const Value : Boolean);
  public
    property  tcAllowTransactionEditing: boolean read Get_AllowTransactionEditing write Set_AllowTransactionEditing;
    property  tcAutoSetCurrencyRates: boolean read Get_AutoSetCurrencyRates write Set_AutoSetCurrencyRates;
    property  tcAutoSetTHLineCount: boolean read Get_AutoSetTHLineCount write Set_AutoSetTHLineCount;
    property  tcAutoSetTLLineNo: boolean read Get_AutoSetTLLineNo write Set_AutoSetTLLineNo;
    property  tcAutoSetTLRefFromTH: boolean read Get_AutoSetTLRefFromTH write Set_AutoSetTLRefFromTH;
    property  tcAutoSetPeriod: boolean read Get_AutoSetPeriod write Set_AutoSetPeriod;
    property  tcAutoSetStockCost: boolean read Get_AutoSetStockCost write Set_AutoSetStockCost;
    property  tcDeductBOMStock: boolean read Get_DeductBOMStock write Set_DeductBOMStock;
    property  tcDeductMultiLocationStock: boolean read Get_DeductMultiLocationStock write Set_DeductMultiLocationStock;
    property  tcDefaultCostCentre: string read Get_DefaultCostCentre write Set_DefaultCostCentre;
    property  tcDefaultCurrency: integer read Get_DefaultCurrency write Set_DefaultCurrency;
    property  tcDefaultDepartment: string read Get_DefaultDepartment write Set_DefaultDepartment;
    property  tcDefaultNominalCode: integer read Get_DefaultNominalCode write Set_DefaultNominalCode;
    property  tcDefaultVATCode: string read Get_DefaultVATCode write Set_DefaultVATCode;
    property  tcImportMode: integer read Get_ImportMode;
    property  tcTrialImport: boolean read Get_TrialImport write Set_TrialImport;
    property  tcUpdateAccountBalances: boolean read Get_UpdateAccountBalances write Set_UpdateAccountBalances;
    property  tcUpdateStockLevels: boolean read Get_UpdateStockLevels write Set_UpdateStockLevels;
    property  tcCalcTHTotals: boolean read Get_CalcTHTotals write Set_CalcTHTotals;
    property  tcAutoSetTHOurRef: boolean read Get_AutoSetTHOurRef write Set_AutoSetTHOurRef;
    property  tcOverwriteNotepad: boolean read Get_OverwriteNotepad write Set_OverwriteNotepad;
    property  tcValidateJobCostingFields: boolean read Get_ValidateJobCostingFields write Set_ValidateJobCostingFields;
    property  tcMultiCurrency: boolean read Get_MultiCurrency write Set_MultiCurrency;
    property  tcUseJobBudgets: boolean read Get_UseJobBudgets write Set_UseJobBudgets;
    property  tcApplyVBD : boolean read Get_ApplyVBD write Set_ApplyVBD;
    property  tcApplyMBD : boolean read Get_ApplyMBD write Set_ApplyMBD;
    property  tcOverwriteDiscountDates : boolean read Get_OverwriteDiscountDates write Set_OverwriteDiscountDates;
  end;

  TImportToolkit = class(TInterfacedObject, IImportToolkit)
  private
{* Internal Fields *}
    FComToolkit: IToolkit;
    FCOMToolkitOpen: boolean;
    FDLLToolkitOpen: boolean;
    FStartTime: cardinal;
    FElapsedTime: cardinal;
    FPrevTrialImport: integer;
{* Property Fields *}
    FAutoSetPeriod: boolean;
    FExchequerCompany: string;
    FToolkitConfiguration: IImportToolkitConfiguration;
    FCostPriceDPs: integer;
    FCurrencyVarianceGLCode: integer;
    FExchequerDataPath: string;
    FKey: array[0..255] of char;
    FQtyDPs: integer;
    FSalesPriceDPs: integer;
    FUserName: string;
    FPassword: string;
    FLiveStockCOSVal: boolean; // v.075
{* Procedural Methods *}
    procedure CheckImportMode;
    function  COMToolkit: IToolkit;
    function  CloseCOMToolkit: integer;
    function  CloseDLLToolkit: integer;
    function  OpenCOMToolkit: integer;
    function  OpenDLLToolkit: integer;
    function  PopulateJCTfromJPT(Job: IJob4; JCTHead: ITransaction3): integer;
    function  PopulateJPAfromJCT(Job: IJob4; JPAHead: ITransaction3): integer;
    function  PopulateJSAfromJST(Job: IJob4; JSAHead: ITransaction3): integer;
    procedure Shutdown;
    function  Startup: integer;
    procedure StartTimer;
    procedure StopTimer;
{* Property Methods *}
    function  Get_CompanyDataPath: string;
    function  Get_Configuration: IImportToolkitConfiguration;
    function  Get_CostPriceDPs: integer;
    function  Get_CurrencyVarianceGLCode: integer;
    function  Get_ExchequerCompany: string;
    procedure Set_ExchequerCompany(const Value: string);
    function  Get_LastErrorDesc: string;
    function  Get_QtyDPs: integer;
    function  Get_SalesPriceDPs: integer;
    function  Get_ToolkitOpen: boolean;
    function  Get_AutoSetPeriod: boolean;
    procedure Set_AutoSetPeriod(const Value: boolean);
    function  Get_UserName: string;
    procedure Set_UserName(const Value: string);
    function  Get_Password: string;
    procedure Set_Password(const Value: string);
    function  Get_ElapsedTime: cardinal;
    function  Get_LiveStockCOSVal: boolean; // v.075
    function  Get_IsSPOP : Boolean;
  public
    constructor create;
    destructor destroy; override;
    // Public Properties
    property  ToolkitConfiguration: IImportToolkitConfiguration read Get_Configuration;
    property  itExchequerCompany: string read Get_ExchequerCompany write Set_ExchequerCompany;
    property  itCompanyDataPath: string read Get_CompanyDataPath;
    property  itCostPriceDPs: integer read Get_CostPriceDPs;
    property  itCurrencyVarianceGLCode: integer read Get_CurrencyVarianceGLCode;
    property  itLastErrorDesc: string read Get_LastErrorDesc;
    property  itLiveStockCOSVal: boolean read Get_LiveStockCOSVal; // v.075
    property  itQtyDPs: integer read Get_QtyDPs;
    property  itSalesPriceDPs: integer read Get_SalesPriceDPs;
    property  itToolkitOpen: boolean read Get_ToolkitOpen;
    property  itUserName: string read Get_UserName write Set_UserName;
    property  itPassword: string read Get_Password write Set_Password;
    property  itElapsedTime: cardinal read Get_ElapsedTime;
    property  itIsSpop : Boolean read Get_IsSPOP;
    // Public Methods
    function  CheckLogin(const AUsername: string; const APassword: string): integer;
    function  CloseImportToolkit: integer;
    function  ConfigureTheToolkit: integer;
    function  GetAccount(P: pointer; PSize: integer; SearchKey: ShortString; SearchPath: integer; SearchMode: smallint; AcctType: smallint; Lock: boolean): integer;
    FUNCTION  GETLINETOTAL(P      : POINTER; PSIZE  : SMALLINT; USEDISCOUNT : WORDBOOL; SETTLEDISC : DOUBLE;
                         VAR LINETOTAL : DOUBLE): SMALLINT;
    function  GetRecordAddress(FileNum: smallint; var RecAddress: integer): smallint;
    function  GetRecWithAddress(FileNum: smallint; KeyPath: smallint; TRecAddr: integer): smallint;
    function  GetSerialBatch(P: pointer; PSize: integer; SearchMode: smallint): integer;
    function  GetSystemSetup: integer;
    function  GetStock(P: pointer; PSize: integer; SearchKey: Shortstring; SearchPath: integer; SearchMode: smallint; Lock: boolean): integer;
    function  GetTrans(PH: pointer; PL: pointer; PHSize: integer; PLSize: integer; SearchKey: ShortString; SearchPath: integer; SearchMode: smallint; Lock: boolean): integer;
    function  NextTransNo(const ADocType: string): string;
    function  OpenImportToolkit: integer;
    function  RoundUp(InputValue: double; DecimalPlaces: smallint): double;
    function  StoreAccount(P: pointer; PSize: integer): integer;
    function  StoreAutoBank(P: pointer; PSize: integer): integer;
    function  StoreCCDep(P: pointer; PSize: integer): integer;
    function  StoreDiscMatrix(P: pointer; PSize: integer): integer;
    function  StoreEachBOMLine(P: pointer; PSize: integer): integer;
    function  StoreGLAccount(P: pointer; PSize: integer): integer;
    function  StoreJob(P: pointer; PSize: integer): integer;
    function  StoreJobAnalysis(P: pointer; PSize: integer): integer;
    function  StoreJobEmployee(P: pointer; PSize: integer): integer;
    function  StoreJobTimeRate(P: pointer; PSize: integer): integer;
    function  StoreLocation(P: pointer; PSize: integer): integer;
    function  StoreMatch(P: pointer; PSize: integer): integer;
    function  StoreMultiLocation(P: pointer; PSize: integer): integer;
    function  StoreNotes(P: pointer; PSize: integer): integer;
    function  StoreMultiBin(P: pointer; PSize: integer): integer;
    function  StoreSerialBatch(P: pointer; PSize: integer): integer;
    function  StoreStkAlt(P: pointer; PSize: integer): integer;
    function  StoreStock(P: pointer; PSize: integer): integer;
    function  StoreTrans(PH: pointer; PL: pointer; PHSize: integer; PLSize: integer): integer;
    function  UseSerialBatch(P: pointer; PSize: integer): integer;
    //SSK 13/09/2016 2016-R3 ABSEXCH-15502: This function added to extract BOM Component stocks
    function  GetStockBOMRec(P: pointer; PSize: integer;SearchKey: Shortstring; SearchMode: smallint): integer;

{* Apps and Vals *}
    function  StoreAVJob(P: TBatchAVJobRec): integer;
    function  StoreAVAnalysisBudget(P: TBatchAVABRec): integer;
    function  StoreAVTrans(PH: TManagedRec; PL: TArrayOfManagedRec; ALineCount:integer): integer;
    function StoreMultiBuyDiscount(P : Pointer; PSize : Integer) : integer;
    function StoreContact(P : PImporterAccountContactRec) : Integer;
    function StoreContactRole(P : PImporterAccountContactRoleRec) : Integer;
  end;

{$I EXDLLBT.INC}
//{$I VARREC.PAS}

var
  Toolkit: IImportToolkit;

function  ImportToolkit: IImportToolkit;
// return an instance of the ImportToolkit
begin
  if not assigned(Toolkit) then
    Toolkit := TImportToolkit.create;

  result := Toolkit;
end;

procedure ResetImportToolkit;
begin
  Toolkit := nil;
end;

{ TImportToolkit }

procedure TImportToolkit.CheckImportMode;
// Only call the COM Toolkit when the value of tcTrialImport changes.
// Otherwise, we'll be calling it for every record.
var
  a, b, c: longint;
begin
  if FPrevTrialImport <> ord(ToolkitConfiguration.tcTrialImport) then begin
    if ToolkitConfiguration.tcTrialImport then
      EncodeOpCode(65, a, b, c)  // turn off saves
    else
      EncodeOpCode(66, a, b, c);  // turn on saves
    ComToolkit.Configuration.SetDebugMode(a, b, c);
    FPrevTrialImport := ord(ToolkitConfiguration.tcTrialImport);
  end;
end;

function TImportToolkit.CheckLogin(const AUsername: string; const APassword: string): integer;
var
  OpenedHere: boolean;
begin
  OpenedHere := not FDLLToolkitOpen;

  if not FDLLToolkitOpen then begin
    result := OpenDLLToolkit;
    if result <> 0 then exit;
  end;

  //SS:10/10/2017:ABSEXCH-19378:Importer: When Running the Job: It gives error related to Invalid User Name or Password.
  if VAOInfo.vaoSubCompanyDir <>  itCompanyDataPath then
  begin
    VAOInfo.vaoSubCompanyDir := itCompanyDataPath;
    SystemSetup(True);
  end;     

  StartTimer;
  result := EX_CheckPassword(pchar(AUserName), pchar(APassword));
  //SS:10/10/2017:2017-R2:ABSEXCH-19432:'Windows User ID' is displayed in Exchequer instead of 'Username' of the User when data is Imported using Importer
  if result = 0 then
  begin
    LoginDisplayName := BlowFishEncrypt(Trim(MLocCtrl^.PassDefRec.Login));
  end;

  StopTimer;

  if OpenedHere then // we opened it here, so we close it again
    CloseDLLToolkit;
end;

function TImportToolkit.CloseCOMToolkit: integer;
begin
  Result := 0;
  if FCOMToolkitOpen then
    if assigned(FCOMToolkit) then
      result := FCOMToolkit.CloseToolkit;

  FCOMToolkitOpen := result <> 0;
  if not FCOMToolkitOpen then
    FCOMToolkit := nil; // decrement reference count
end;

function TImportToolkit.CloseDLLToolkit: integer;
// can't call EX_CLOSEDLL now that we're picking up the form coordinates and
// multilist colours from oSettings because EX_CLOSEDLL terminates BTrieve.
// 07/04/2006: Should have been calling EX_CLOSEDATA anyway so all ok now.
begin
  result := 0;
//  exit;

  StartTimer;

  if FDLLToolkitOpen then
//    result := EX_CLOSEDLL;
    result := EX_CLOSEDATA;

  StopTimer;

  FDLLToolkitOpen := result <> 0;
end;

function TImportToolkit.CloseImportToolkit: integer;
begin
  result := CloseDLLToolkit;
  if assigned(FCOMToolkit) then
    result := CloseCOMToolkit;
end;

constructor TImportToolkit.create;
begin
  inherited create;
  Startup;
end;

destructor TImportToolkit.destroy;
begin
  Shutdown;
  inherited destroy;
end;

function TImportToolkit.GetSystemSetup: integer;
var
  OpenedHere: boolean;
begin
  result := -1;
  OpenedHere := not FCOMToolkitOpen;
  if not FCOMToolkitOpen then
    if OpenCOMToolkit <> 0 then exit;

  with FCOMToolkit.SystemSetup do begin
    FSalesPriceDPs          := ssSalesDecimals;
    FCostPriceDPs           := ssCostDecimals;
    FQtyDPs                 := ssQtyDecimals;
    FCurrencyVarianceGLCode := ssGLCtrlCodes[ssGLCurrencyVariance];
    FLiveStockCOSVal        := ssLiveStockCOSVal; // v.075
  end;

//  with ToolkitConfiguration do begin
//    tcMultiCurrency := EnterpriseLicence.elIsMultiCcy;
//  end;

  if OpenedHere then
    CloseCOMToolkit;
  result := 0;
end;

function TImportToolkit.NextTransNo(const ADocType: string): string;
var
  DocType: array[0..255] of char;
  NextNo: array[0..10] of char;
  rc: integer;
begin
  StrPCopy(DocType, ADocType);

  StartTimer;
  rc := EX_GETNEXTTRANSNO(DocType, NextNo, not FToolkitConfiguration.tcTrialImport);
  StopTimer;

  if rc = 0 then
    result := NextNo
  else
    result := '';
end;

function TImportToolkit.OpenCOMToolkit: integer;
begin
 result := 0;
  if FCOMToolkitOpen then exit;

  if not assigned(FComToolkit) then begin
    FComToolkit := OpenToolkit(FExchequerDataPath, true); // use backdoor
    if not assigned(FCOMToolkit) then begin
      result := -1;
      exit;
    end;
  end;

  FCOMToolkitOpen := result = 0;
end;

function TImportToolkit.OpenDLLToolkit: integer;
begin
  result := 0;
//  if FDLLToolkitOpen then ShowMessage('Toolkit already open');
  if (FDLLToolkitOpen) then exit;

  StartTimer;

  if result = 0 then
    result := Ex_InitDLL; // We don't really use the DLL but still need to call this to open the tables.

  if TKTestMode then
    EX_TESTMODE(TKTestMode); // set test mode on if /testmode is included in the command line

  StopTimer;

  FDLLToolkitOpen := result = 0;
end;

function TImportToolkit.OpenImportToolkit: integer;
begin
  result := OpenDLLToolkit;
end;

procedure TImportToolkit.Shutdown;
begin
  if FCOMToolkitOpen then CloseCOMToolkit;
  if FDLLToolkitOpen then CloseDLLToolkit;
  FToolkitConfiguration := nil;
end;

function TImportToolkit.Startup: integer;
begin
  Result := 0;
  FToolkitConfiguration := TImportToolkitConfiguration.create;
  with ToolkitConfiguration do begin
    tcMultiCurrency := EnterpriseLicence.elIsMultiCcy;
  end;
  FPrevTrialImport := -1;

  //PR: 24/01/2012 Added to allow Audit Notes to include user name (ABSEXCH-12346)
  if not SchedulerMode then
    ToolkitUser := BlowfishDecrypt(LoginUserName)
  else
    ToolkitUser := 'Importer';
end;

function TImportToolkit.StoreAccount(P: pointer; PSize: integer): integer;
var
  BatchCURec: TBatchCURec;
begin
  with PExchequerRec(P).BatchCURec do begin
    SSDDelTerms := trim(SSDDelTerms);
  end;

  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STOREACCOUNT(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    StrPCopy(FKey, PExchequerRec(P).BatchCURec.CustCode);
    result := EX_GETACCOUNT(@BatchCURec, PSize, FKey, 0, B_GetEQ, 0, false);
    if result <> 0 then {not found}
      result := EX_STOREACCOUNT(P, PSize, 0, b_insert)
    else
      result := EX_STOREACCOUNT(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreAutoBank(P: pointer; PSize: integer): integer;
begin
  with PExchequerRec(P).BatchAutoBankRec do begin
    BankRef := trim(BankRef);
  end;

  StartTimer;
  result := EX_STOREAUTOBANK(P, PSize, ToolkitConfiguration.tcImportMode);
  StopTimer;
end;


//PR: Multiple changes to allow Discount records with date ranges to be overwritten or added to (ABSEXCH-2666)
function TImportToolkit.StoreDiscMatrix(P: pointer; PSize: integer): integer;
const
  MiscF = 9;
var
  BatchDiscRec, DiscCheckRec: TBatchDiscRec;
  RecAddress: longint;

  function StrMatch(const s1 : string; const s2 : string) : Boolean;
  begin
    Result := UpperCase(Trim(s1)) = UpperCase(Trim(s2));
  end;

  //Returns True if the Record in the dbase matches the record passed in for Account, Stock - and currency if required
  function Belongs(CheckCurrency : Boolean = True) : Boolean;
  begin
    Result := StrMatch(BatchDiscRec.CustCode, DiscCheckRec.CustCode) and
              StrMatch(BatchDiscRec.StockCode, DiscCheckRec.StockCode);

    //Check currency if required
    if Result and CheckCurrency then
       Result := Result and (BatchDiscRec.SPCurrency = DiscCheckRec.SPCurrency);

    if Result and CheckCurrency and DiscCheckRec.QtyBreak and
                                    BatchDiscRec.QtyBreak then
       Result := Result and (BatchDiscRec.QtyTo = DiscCheckRec.QtyTo);
  end;

  function DeleteDiscounts : Integer;
  begin
    Result := 0;
    while (Result = 0) and Belongs(False) do
    begin
      //Don't delete if no date range on this record
      if BatchDiscRec.UseDates and Belongs then
      begin
        EX_GETRECORDADDRESS(MiscF, RecAddress);
        Result := EX_DELETEDISCMATRIX(@BatchDiscRec, SizeOf(BatchDiscRec), 0, RecAddress);

       if Result = 0 then
          Result := EX_GETDISCMATRIX(@BatchDiscRec, PSize, 0, B_GetGEq, false);
     end
     else
     if Belongs(False) then
       Result := EX_GETDISCMATRIX(@BatchDiscRec, PSize, 0, B_GetNext, false);

    end;
  end;

  function BothNoDate : Boolean;
  begin
    Result := not BatchDiscRec.UseDates and not DiscCheckRec.UseDates;
  end;

  function FindNDMatch : Boolean;
  var
    Res : Integer;
  begin
     Result := False;
     res := EX_GETDISCMATRIX(@BatchDiscRec, PSize, 0, B_GetGEq, false); 	// v.060
     while (Res = 0) and not Result and Belongs(False) do
     begin
       Result := (Res = 0) and Belongs and BothNoDate;

       if not Result then
         Res := EX_GETDISCMATRIX(@BatchDiscRec, PSize, 0, B_GetNext, false);
     end; //while
  end;

begin
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
  begin
    result := EX_STOREDISCMATRIX(P, PSize, ToolkitConfiguration.tcImportMode);
    if (result = 30011) and ToolkitConfiguration.tcOverWriteDiscountDates then
      Result := 0;  //If Date error then we only care if we're not overwriting existing dates
  end
  else
  begin
    Move(P^, BatchDiscRec, PSize);
    DiscCheckRec := BatchDiscRec;

    if not DiscCheckRec.UseDates then
    begin
      //Record coming in doesn't have a date range - find existing non-date range record - if there, update else add.
      if FindNDMatch then
      begin
        EX_GETRECORDADDRESS(MiscF, RecAddress);                  // v.060
        TBatchDiscRec(P^).RecordPos := RecAddress;               // v.060
        result := EX_STOREDISCMATRIX(P, PSize, b_update); 			// v.060
      end
      else
        result := EX_STOREDISCMATRIX(P, PSize, b_insert);  			// v.059
    end
    else
    begin
      //Find first belongin record
      result := EX_GETDISCMATRIX(@BatchDiscRec, PSize, 0, B_GetGEq, false);
      if (result <> 0) or not Belongs then {not found} 									// v.060
        result := EX_STOREDISCMATRIX(P, PSize, b_insert)  			// v.059
      else
      begin
        if not BatchDiscRec.UseDates then //Date range coming in, postitioned on non-date range record in db, so find next
          Result:= EX_GETDISCMATRIX(@BatchDiscRec, PSize, 0, B_GetNext, false);

        if (Result <> 0) or not Belongs or not ToolkitConfiguration.tcOverWriteDiscountDates then  //just add the discount
          result := EX_STOREDISCMATRIX(P, PSize, b_insert)
        else
        begin //remove previous date range discounts then add the discount
          DeleteDiscounts;
          Result := EX_STOREDISCMATRIX(P, PSize, b_insert);
        end;
      end;																			// v.060
    end;
  end;
  StopTimer;
end;

function TImportToolkit.StoreEachBOMLine(P: pointer; PSize: integer): integer;
begin
  StartTimer;
  result := EX_STOREEACHBOMLINE(P, PSize, ToolkitConfiguration.tcImportMode);
  StopTimer;
end;

function TImportToolkit.StoreGLAccount(P: pointer; PSize: integer): integer;
var
  BatchNomRec: TBatchNomRec;
  GLCode: string;
begin
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STOREGLACCOUNT(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    GLCode := IntToStr(PExchequerRec(P).BatchNomRec.NomCode);
    StrPCopy(FKey, GLCode);
    result := EX_GETGLACCOUNT(@BatchNomRec, PSize, FKey, 0, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STOREGLACCOUNT(P, PSize, 0, b_insert)
    else
      result := EX_STOREGLACCOUNT(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreJob(P: pointer; PSize: integer): integer;
var
  BatchJHRec: TBatchJHRec;
begin
  with PExchequerRec(P).BatchJHRec do begin
    EndDate  := trim(EndDate);
    RevEDate := trim(RevEDate);
  end;

  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STOREJOB(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    StrPCopy(FKey, PExchequerRec(P).BatchJHRec.JobCode);
    result := EX_GETJOB(@BatchJHRec, PSize, FKey, 0, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STOREJOB(P, PSize, 0, b_insert)
    else
      result := EX_STOREJOB(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreJobAnalysis(P: pointer; PSize: integer): integer;
var
  BatchJobAnalRec: TBatchJobAnalRec;
begin
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STOREJOBANALYSIS(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    StrPCopy(FKey, PExchequerRec(P).BatchJobAnalRec.JAnalCode);
    result := EX_GETJOBANALYSIS(@BatchJobAnalRec, PSize, FKey, 0, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STOREJOBANALYSIS(P, PSize, 0, b_insert)
    else
      result := EX_STOREJOBANALYSIS(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreJobEmployee(P: pointer; PSize: integer): integer;
var
  BatchEmplRec: TBatchEmplRec;
begin
  with PExchequerRec(P).BatchEmplRec do begin // v.079 trim the spaces off these fields or they screw up the HMRC CIS returns XML validation - not good
    ENINo          := trim(ENINo);
    UTRCode        := trim(UTRCode);
    VerificationNo := trim(VerificationNo);
    CertNo         := trim(CertNo);
  end;
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STOREJOBEMPLOYEE(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    StrPCopy(FKey, PExchequerRec(P).BatchEmplRec.EmpCode);
    result := EX_GETJOBEMPLOYEE(@BatchEmplRec, PSize, FKey, 0, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STOREJOBEMPLOYEE(P, PSize, 0, b_insert)
    else
      result := EX_STOREJOBEMPLOYEE(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreJobTimeRate(P: pointer; PSize: integer): integer;
var
  BatchJobRateRec: TBatchJobRateRec;
begin
  with PExchequerRec(P).BatchJobRateRec do begin
    PayRate := PayRollCode; // these both map to the same db field so we only expose PayRollCode to Importer's users.
  end;

  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STOREJOBTIMERATE(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    BatchJobRateRec.JEmpCode  := trim(PExchequerRec(P).BatchJobRateRec.JEmpCode);
    BatchJobRateRec.JRateCode := trim(PExchequerRec(P).BatchJobRateRec.JRateCode);
    result := EX_GETJOBTIMERATE(@BatchJobRateRec, PSize, 0, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STOREJOBTIMERATE(P, PSize, 0, b_insert)
    else
      result := EX_STOREJOBTIMERATE(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreLocation(P: pointer; PSize: integer): integer;
var
  BatchMLocRec: TBatchMLocRec;
begin
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STORELOCATION(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    StrPCopy(FKey, PExchequerRec(P).BatchMLocRec.loCode);
    result := EX_GETLOCATION(@BatchMLocRec, PSize, FKey, 0, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STORELOCATION(P, PSize, 0, b_insert)
    else
      result := EX_STORELOCATION(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreMatch(P: pointer; PSize: integer): integer;
var
  BatchMatchRec: TBatchMatchRec;
begin
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STOREMATCH(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    StrPCopy(FKey, PExchequerRec(P).BatchMatchRec.DebitRef);
    result := EX_GETMATCH(@BatchMatchRec, PSize, FKey, 0, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STOREMATCH(P, PSize, 0, b_insert)
    else
      result := EX_STOREMATCH(P, PSIZE, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreMultiBin(P: pointer; PSize: integer): integer;
var
  BatchBinRec: TBatchBinRec;
  BatchSKRec: TBatchSKRec;
begin
  StrPCopy(FKey, PExchequerRec(P).BatchBinRec.brStockCode);
  StartTimer;
  result := EX_GETSTOCK(@BatchSKRec, SizeOf(BatchSKRec), FKey, 0, B_GetEQ, false);
  StopTimer;

  if result <> 0 then begin
    result := -99001;
    exit;
  end;

  with PExchequerRec(P).BatchBinRec do begin
    brStockFolio := BatchSKRec.StockFolio;
    brInDate     := trim(brInDate);
  end;

  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STOREMULTIBIN(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    BatchBinRec.brBinCode    := PExchequerRec(P).BatchBinRec.brBinCode; // setup the key fields
    BatchBinRec.brInLocation := PExchequerRec(P).BatchBinRec.brInLocation;
    BatchBinRec.brStockFolio := PExchequerRec(P).BatchBinRec.brStockFolio;
    result := EX_GETMULTIBIN(@BatchBinRec, PSize, 2, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STOREMULTIBIN(P, PSize, 0, b_insert)
    else
      result := EX_STOREMULTIBIN(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreMultiLocation(P: pointer; PSize: integer): integer;
var
  BatchSLRec: TBatchSLRec;
  StockCode: array[0..255] of char;
  LocCode:   array[0..255] of char;
begin
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STORESTOCKLOC(P, PSize, ToolkitConfiguration.tcImportMode)
  else begin
    StrPCopy(StockCode, PExchequerRec(P).BatchSLRec.lsStkCode);
    StrPCopy(LocCode, PExchequerRec(P).BatchSLRec.lsLocCode);
    result := EX_GETSTOCKLOC(@BatchSLRec, PSize, StockCode, LocCode, false);
    if result <> 0 then {not found}
      result := EX_STORESTOCKLOC(P, PSize, b_insert)
    else
      result := EX_STORESTOCKLOC(P, PSize, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreNotes(P: pointer; PSize: integer): integer;
var
  BatchNotesRec: TBatchNotesRec;
begin
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STORENOTES(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    FillChar(FKey, SizeOf(FKey), #32);
    FillChar(BatchNotesRec, SizeOf(BatchNotesRec), #0);
    with PExchequerRec(P).BatchNotesRec do begin
      StrPCopy(FKey, NoteCode);
      BatchNotesRec.NoteSort := NoteSort;
      BatchNotesRec.NoteType := NoteType;
    end;
    result := EX_GETNOTES(@BatchNotesRec, PSize, FKey, 0, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STORENOTES(P, PSize, 0, b_insert)
    else
      result := EX_STORENOTES(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.GetSerialBatch(P: pointer; PSize: integer; SearchMode: smallint): integer;
begin
  StartTimer;
  result := EX_GETSERIALBATCH(P, PSize, SearchMode);
  StopTimer;
end;

function TImportToolkit.StoreSerialBatch(P: pointer; PSize: integer): integer;
// NOT CURRENTLY AVAILABLE IN IMPORTER // v5.71.073 Used in TDBAClass for adding BatchSerial records but SN record type still not available to the user
begin
  StartTimer;
  result := EX_STORESERIALBATCH(P, PSize, ToolkitConfiguration.tcImportMode);
  StopTimer;
end;

function TImportToolkit.UseSerialBatch(P: pointer; PSize: integer): integer;
begin
  StartTimer;
  result := EX_USESERIALBATCH(P, PSize, ToolkitConfiguration.tcImportMode);
  StopTimer;
end;

function TImportToolkit.StoreStkAlt(P: pointer; PSize: integer): integer;
// v.090: rewritten to read through all records for the given StockCode and AltCode to find if a record for the given SuppCode already exists.
// If it does, its updated, otherwise the new supplied record is inserted.
var
  BatchSkAltRec: TBatchSkAltRec;
  FoundSuppCode: boolean; // v.090
begin
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STORESTKALT(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    StrPCopy(FKey, PExchequerRec(P).BatchSkAltRec.StockCode);               // v.090 changed AltCode to StockCode
    BatchSkAltRec.AltCode := PExchequerRec(P).BatchSkAltRec.AltCode;        // v.090 provide AltCode via passed-in record
    FoundSuppCode := false;                                                 // v.090
    result := EX_GETSTKALT(@BatchSKAltRec, PSize, FKey, 1, B_GetEQ, false); // v.090 changed SearchPath from 0 to 1: StockCode and AltCode
    while (result = 0) and not FoundSuppCode do begin                                    // v.091
      FoundSuppCode := BatchSkAltRec.SuppCode = PExchequerRec(P).BatchSkAltRec.SuppCode; // v.091
      if not FoundSuppCode then                                                          // v.091
        result := EX_GETSTKALT(@BatchSKAltRec, PSize, FKey, 1, B_GetNext, false);        // v.091
    end;                                                                                 // v.091

    if FoundSuppCode then begin                                                          // v.091
      PExchequerRec(P).BatchSkAltRec.FolioNum := BatchSKAltRec.FolioNum;                 // v.091
      result := EX_STORESTKALT(P, PSize, 0, b_update);
    end
    else                                                                                 
      result := EX_STORESTKALT(P, PSize, 0, b_insert);
  end;
  StopTimer;
end;

function TImportToolkit.StoreStock(P: pointer; PSize: integer): integer;
var
  BatchSKRec: TBatchSKRec;
begin
  StartTimer;
  if ToolkitConfiguration.tcTrialImport then
    result := EX_STORESTOCK(P, PSize, 0, ToolkitConfiguration.tcImportMode)
  else begin
    StrPCopy(FKey, PExchequerRec(P).BatchSKRec.StockCode);
    result := EX_GETSTOCK(@BatchSKRec, PSize, FKey, 0, B_GetEQ, false);
    if result <> 0 then {not found}
      result := EX_STORESTOCK(P, PSize, 0, b_insert)
    else
      result := EX_STORESTOCK(P, PSize, 0, b_update);
  end;
  StopTimer;
end;

function TImportToolkit.StoreTrans(PH, PL: pointer; PHSize, PLSize: integer): integer;
begin
  StartTimer;
  result := EX_STORETRANS(PH, PL, PHSize, PLSize, 0, ToolkitConfiguration.tcImportMode);
  StopTimer;
end;

procedure TImportToolkit.StartTimer;
begin
  FStartTime := GetTickCount;
end;

procedure TImportToolkit.StopTimer;
begin
  inc(FElapsedTime, GetTickCount - FStartTime);
end;

{* Getters and Setters *}

function  TImportToolkit.Get_CompanyDataPath: string;
// FExchequerCompany is in the format "CoCode - CoName"
// Returns the data path for the given company.
var
  Code, Name: string;
  i: integer;
  Toolkit: IToolkit;
begin
  result := '';
  if FExchequerCompany = '' then exit;

  Code := copy(FExchequerCompany, 1, pos('-', FExchequerCompany) - 2);
  Code := format('%-6s', [code]); // pad to 6 characters to match the COM toolkit's coCode field below else it won't be found (error 12)
  Name := copy(FExchequerCompany, pos('-', FExchequerCompany) + 2, length(FExchequerCompany));

  Toolkit := COMToolkit; // get an instance of the COM Toolkit and increment it's reference count

  if not assigned(Toolkit) then exit
  else begin
    with Toolkit.Company do begin // no need to open the toolkit
      if cmCount > 0 then
        for i := 1 to cmCount do
          with cmCompany[i] do begin
            if (coCode = Code) and (coName = Name) then begin
              result := IncludeTrailingPathDelimiter(trim(coPath));
              break;
            end;
          end;
    end;
  end;

  Toolkit := nil; // decrement the reference count. Will go out of scope anyway, but looks right.
end;

function TImportToolkit.Get_CurrencyVarianceGLCode: integer;
begin
  result := FCurrencyVarianceGLCode;
end;

function TImportToolkit.Get_ExchequerCompany: string;
begin
  result := FExchequerCompany;
end;

procedure TImportToolkit.Set_ExchequerCompany(const Value: string);
begin
  if FExchequerCompany <> Value then begin
    FExchequerCompany  := Value;
    FExchequerDataPath := itCompanyDataPath; // do this now, as it's required by both toolkits
  end;
end;

function TImportToolkit.Get_CostPriceDPs: integer;
begin
  result := FCostPriceDPs;
end;

function TImportToolkit.Get_QtyDPs: integer;
begin
  result := FQtyDPs;
end;

function TImportToolkit.Get_SalesPriceDPs: integer;
begin
  result := FSalesPriceDPs;
end;

function TImportToolkit.Get_ToolkitOpen: boolean;
begin
  result := FDLLToolkitOpen;
end;

function TImportToolkit.Get_AutoSetPeriod: boolean;
begin
 result := FAutoSetPeriod;
end;

procedure TImportToolkit.Set_AutoSetPeriod(const Value: boolean);
begin
  FAutoSetPeriod := Value;
end;

procedure ToolKitOK;
const
  CODE = #238 + #27 + #236 + #131 + #174 + #38 + #110 + #208 + #185 + #168 + #157;
var
  pCode : array[0..255] of char;
begin
  ChangeCryptoKey(19701115);
  StrPCopy(pCode, Decode(CODE));
  Ex_SetReleaseCode(pCode);
end;


function TImportToolkit.Get_Configuration: IImportToolkitConfiguration;
begin
  if not assigned(FToolkitConfiguration) then
    FToolkitConfiguration := TImportToolkitConfiguration.create;

  result := FToolkitConfiguration;
end;

function  TImportToolkit.ConfigureTheToolkit: integer;
// pass the toolkit-specific properties on to the toolkit
  procedure ConfigureDLLToolkit(ToolkitOpen: boolean);
       function YesOrNo(ABoolean: boolean): pchar;
       const
         YesNo: array[false..true] of pchar = ('NO', 'YES');
       begin
         result := YesNo[ABoolean];
       end;
       procedure Check(AReturnCode: integer);
       begin
         if AReturnCode <> 0 then result := AReturnCode;
       end;
  begin
    result := 0;
    with ToolkitConfiguration do begin
      if not ToolkitOpen then begin
        Check(EX_INITDLLPATH(pchar(FExchequerDataPath), tcMultiCurrency)); // Multi_Currency
      end else begin
        Check(EX_OVERRIDEINI('Auto_Set_Period', YesOrNo(tcAutoSetPeriod)));
        Check(EX_OVERRIDEINI('Default_Nominal', pchar(IntToStr(tcDefaultNominalCode))));
        Check(EX_OVERRIDEINI('Default_Cost_Centre', pchar(tcDefaultCostCentre)));
        Check(EX_OVERRIDEINI('Default_Department', pchar(tcDefaultDepartment)));
        Check(EX_OVERRIDEINI('Default_VAT_Code', pchar(tcDefaultVATCode)));
        Check(EX_OVERRIDEINI('Auto_Set_Stock_Cost', YesOrNo(tcAutoSetStockCost)));
        Check(EX_OVERRIDEINI('Deduct_BOM_Stock', YesOrNo(tcDeductBOMStock)));
        Check(EX_OVERRIDEINI('Overwrite_Trans_No', YesOrNo(tcAutoSetTHOurRef)));
        Check(EX_OVERRIDEINI('Overwrite_Note_Pad', YesOrNo(tcOverwriteNotepad)));
        Check(EX_OVERRIDEINI('Use_Ex_Currency', YesOrNo(tcAutoSetCurrencyRates)));
        Check(EX_OVERRIDEINI('Allow_Trans_Edit', YesOrNo(tcAllowTransactionEditing)));
        Check(EX_OVERRIDEINI('Default_Currency', pchar(IntToStr(tcDefaultCurrency))));
        Check(EX_OVERRIDEINI('Update_Account_Bal', YesOrNo(tcUpdateAccountBalances)));
        Check(EX_OVERRIDEINI('Update_Stock_Levels', YesOrNo(tcUpdateStockLevels)));
        Check(EX_OVERRIDEINI('Ignore_JobCost_Validation', YesOrNo(not tcValidateJobCostingFields)));

        //PR: 23/06/2009 Added new fields for Importer & Advanced Discounts
        Check(EX_OVERRIDEINI('Apply_VBD', YesOrNo(tcApplyVBD)));
        Check(EX_OVERRIDEINI('Apply_MBD', YesOrNo(tcApplyMBD)));
      end;
    end;
  end;
begin
  FElapsedTime := 0; // as this is the first thing that TImportJobs do
  StartTimer;
  result := EX_INITBTRIEVE;
  if result = 0 then begin
    ToolkitOK;
    ConfigureDLLToolkit(false); // items that need to be set before the toolkit is opened
    if result = 0 then begin
      result := OpenDLLToolkit;
      if result = 0 then
        ConfigureDLLToolkit(true); // items that need to be set after the toolkit is opened
    end;
  end;
  StopTimer;
end;

function TImportToolkit.COMToolkit: IToolkit;
// returns an instance of the COMToolkit. Methods which call this function
// need an instance of the COMToolkit but don't need the toolkit to be open.
// If the toolkit has already been opened then the existing instance is returned
// otherwise we create an instance which the caller should dereference to free
// the object.
begin
  if FCOMToolkitOpen then
    result := FCOMToolkit
  else
    result := CreateOleObject('Enterprise01.Toolkit') as IToolkit;

  if not assigned(result) then
    raise exception.create('No COM Toolkit instance available');
end;

//PR: 01/06/2010 Changed to use ShortString for SeachKey and allocate PChar of required length - avoids bounds error.
function TImportToolkit.GetTrans(PH, PL: pointer; PHSize, PLSize: integer;
  SearchKey: ShortString; SearchPath: integer; SearchMode: smallint; Lock: boolean): integer;
var
  SKey : PChar;
begin
  StartTimer;
  SKey := StrAlloc(255);
  Try
    FillChar(SKey^, 255, 0);
    StrPCopy(SKey, SearchKey);
    result := EX_GETTRANS(PH, PL, PHSize, PLSize, SKey, SearchPath, SearchMode, Lock);
  Finally
    StrDispose(SKey);
  End;
  StopTimer;
end;

//PR: 01/06/2010 Changed to use ShortString for SeachKey and allocate PChar of required length - avoids bounds error.
function TImportToolkit.GetStock(P: pointer; PSize: integer;
  SearchKey: Shortstring; SearchPath: integer; SearchMode: smallint;
  Lock: boolean): integer;
var
  SKey : PChar;
begin
  StartTimer;
  SKey := StrAlloc(255);
  Try
    FillChar(SKey^, 255, 0);
    StrPCopy(SKey, SearchKey);
    result := EX_GETSTOCK(P, PSize, SKey, SearchPath, SearchMode, Lock);
  Finally
    StrDispose(SKey);
  End;
  StopTimer;
end;

function TImportToolkit.GETLINETOTAL(P: POINTER; PSIZE: SMALLINT;
  USEDISCOUNT: WORDBOOL; SETTLEDISC: DOUBLE;
  var LINETOTAL: DOUBLE): SMALLINT;
begin
  StartTimer;
  result := EX_GETLINETOTAL(P, PSize, UseDiscount, SettleDisc, LineTotal);
  StopTimer;
end;

function TImportToolkit.Get_LastErrorDesc: string;
begin
  StartTimer;
  result := EX_GETLASTERRORDESC;
  if (result = '') and assigned(FCOMToolkit) then
    result := FComToolkit.LastErrorString;
  StopTimer;
end;

function TImportToolkit.Get_ElapsedTime: cardinal;
begin
  result := FElapsedTime;
end;

function TImportToolkit.RoundUp(InputValue: double; DecimalPlaces: smallint): double;
begin
  StartTimer;
  result := EX_ROUNDUP(InputValue, DecimalPlaces);
  StopTimer;
end;

function NotBlank(AField: pointer): boolean;
begin
  result := string(AField)[1] <> BLANKCHAR;
end;

{* Apps and Vals functions *}
function TImportToolkit.StoreAVJob(P: TBatchAVJobRec): integer;
var
  Job: IJob4;
  JobAddUpdate: IJob4;
  rc: integer;
begin
  OpenComToolkit;  CheckImportMode;

  Job := ComToolkit.JobCosting.Job as IJob4;

  with Job do begin
    Index := jrIdxCode;
    rc    := GetEqual(BuildCodeIndex(p.jrCode));
    if rc <> 0 then
      JobAddUpdate := Job.Add as IJob4
    else
      JobAddUpdate := Job.update as IJob4;
  end;

  with JobAddUpdate do begin
    jrCode           := trim(P.jrCode);
    if NotBlank(@p.jrDesc) then
      jrDesc           := trim(P.jrDesc);
    if NotBlank(@p.jrAcCode) then
      jrAcCode         := trim(p.jrAcCode);
    if NotBlank(@p.jrParent) then
      jrParent         := trim(p.jrParent);
    if NotBlank(@p.jrAltCode) then
      jrAltCode        := trim(p.jrAltCode);
    if NotBlank(@p.jrCompleted) then
      jrCompleted      := p.jrCompleted;
    if NotBlank(@p.jrContact) then
      jrContact        := trim(p.jrContact);
    if NotBlank(@p.jrContact) then
      jrManager        := trim(p.jrManager);
    if NotBlank(@p.jrChargeType) then
      jrChargeType     := p.jrChargeType;
    if NotBlank(@p.jrQuotePrice) then
      jrQuotePrice     := p.jrQuotePrice;
    if NotBlank(@p.jrQuotePriceCurr) then
      jrQuotePriceCurr := p.jrQuotePriceCurr;
    if NotBlank(@p.jrStartDate) then
      jrStartDate      := p.jrStartDate;
    if NotBlank(@p.jrEndDate) then
      jrEndDate        := p.jrEndDate;
    if NotBlank(@p.jrRevisedEndDate) then
      jrRevisedEndDate := p.jrRevisedEndDate;
    if NotBlank(@p.jrSORNumber) then
      jrSORNumber      := trim(p.jrSORNumber);
    if NotBlank(@p.jrJobType) then
      jrJobType        := p.jrJobType;
    if NotBlank(@p.jrType) then
      jrType           := p.jrType;
    if NotBlank(@p.jrStatus) then
      jrStatus         := p.jrStatus;
    if NotBlank(@p.jrUserField1) then
      jrUserField1     := trim(p.jrUserField1);
    if NotBlank(@p.jrUserField2) then
      jrUserField2     := trim(p.jrUserField2);
    if NotBlank(@p.jrUserField3) then
      jrUserField3     := trim(p.jrUserField3);
    if NotBlank(@p.jrUserField4) then
      jrUserField4     := trim(p.jrUserField4);
    result := Save;
  end;
end;

function TImportToolkit.StoreAVAnalysisBudget(P: TBatchAVABRec): integer;
var
  Job: IJob4;
  JobAnalysisBudget: {$IFDEF IAJB3} IAnalysisJobBudget3 {$ELSE} IAnalysisJobBudget2 {$ENDIF}; // v082
  rc: integer;
begin
  OpenCOMToolkit; CheckImportMode;

  with ComToolkit.JobCosting.Job do begin // find the job code
    Index := jrIdxCode;
    rc    := GetEqual(BuildCodeIndex(p.jrCode));
    if rc <> 0 then begin
      result := -99002;
      exit;
    end;
  end;

  Job := ComToolkit.JobCosting.Job as IJob4;

  //PR: 14/09/2010 Check whether budget exists - if so then we need to update it
  with Job.jrAnalysisBudget do
    rc := GetEqual(BuildAnalysisCodeIndex(p.jbAnalysisCode));

  if rc = 0 then
    JobAnalysisBudget := Job.jrAnalysisBudget.Update as {$IFDEF IAJB3} IAnalysisJobBudget3 {$ELSE} IAnalysisJobBudget2 {$ENDIF}
  else
    JobAnalysisBudget := Job.jrAnalysisBudget.Add as {$IFDEF IAJB3} IAnalysisJobBudget3 {$ELSE} IAnalysisJobBudget2 {$ENDIF}; // v082

  if Assigned(JobAnalysisBudget) then
  with JobAnalysisBudget do begin
    if NotBlank(@p.jbAnalysisCode) then
      jbAnalysisCode      := trim(p.jbAnalysisCode);
    if NotBlank(@p.jbAnalysisType) then
      jbAnalysisType      := p.jbAnalysisType;
    if NotBlank(@p.jbApplicationBasis) then
      jbApplicationBasis  := p.jbApplicationBasis;
    if NotBlank(@p.jbApplyPercent) then
      jbApplyPercent      := p.jbApplyPercent;
    if NotBlank(@p.jbCategory) then
      jbCategory          := p.jbCategory;
    if NotBlank(@p.jbCostOverhead) then
      jbCostOverhead      := p.jbCostOverhead;
    if NotBlank(@p.jbOriginalQty) then
      jbOriginalQty       := p.jbOriginalQty;
    if NotBlank(@p.jbOriginalValuation) then
      jbOriginalValuation := p.jbOriginalValuation;
    if NotBlank(@p.jbOriginalValue) then
      jbOriginalValue     := p.jbOriginalValue;
    if NotBlank(@p.jbPeriod) then
      jbPeriod            := p.jbPeriod;
    if NotBlank(@p.jbRecharge) then
      jbRecharge          := p.jbRecharge;
    if NotBlank(@p.jbRevisedQty) then
      jbRevisedQty        := p.jbRevisedQty;
    if NotBlank(@p.jbRevisedValuation) then
      jbRevisedValuation  := p.jbRevisedValuation;
    if NotBlank(@p.jbRevisedValue) then
      jbRevisedValue      := p.jbRevisedValue;
    if NotBlank(@p.jbUnitPrice) then
      jbUnitPrice         := p.jbUnitPrice;
    if NotBlank(@p.jbUplift) then
      jbUplift            := p.jbUplift;
    if NotBlank(@p.jbYear) then
      jbYear              := p.jbYear;
{$IFDEF IAJB3}
    if NotBlank(@p.jbCurrency) then           // v082
      jbCurrency          := p.jbCurrency;    // v082
{$ENDIF}
    result := save;
  end  //if Assigned(JobAnalysisBudget)
  else
    Result := 84;
end;

function TImportToolkit.PopulateJCTfromJPT(Job: IJob4; JCTHead: ITransaction3): integer;
var
  JPTHead: ITransaction3;
  JPTLine: ITransactionLine3;
  JPTLineCount: integer;
  JCTLine: ITransactionLine3;
  i: integer;
begin
  Result := 0;
  JPTHead := Job.jrApplications.jbaPurchaseTerms;
  if JPTHead = nil then
    exit;

  with JCTHead.thAsApplication do
    tpParentTerms := JPTHead.thAsApplication.tpOurRef;

  JPTLineCount := JPTHead.thLines.thLineCount;

  for i := 1 to JPTLineCount do begin // add budget record lines
    JPTLine := JPTHead.thLines.thLine[i] as ITransactionLine3;
    JCTLine := JCTHead.thLines.Add as ITransactionLine3;
    with JCTLine do begin
      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';
      with tlAsApplication do begin
        tplAnalysisCode := JPTLine.tlAsApplication.tplAnalysisCode;
        tplTermsLineNo  := JPTLine.tlABSLineNo;
        ImportDefaults;
        tplQty          := JPTLine.tlAsApplication.tplQty;
        tplBudgetJCT    := JPTLine.tlAsApplication.tplBudgetJCT;
      end;
      save;
    end;
  end;

  JPTLineCount := JPTHead.thAsApplication.tpDeductionLines.thLineCount;

  for i := 1 to JPTLineCount do begin // add deduction record lines
    JPTLine := JPTHead.thAsApplication.tpDeductionLines.thLine[i] as ITransactionLine3;
    JCTLine := JCTHead.thAsApplication.tpDeductionLines.Add as ITransactionLine3;
    with JCTLine do begin
      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';
      tlAsApplication.tplAnalysisCode := JPTLine.tlAsApplication.tplAnalysisCode;
      ImportDefaults;
      save;
    end;
  end;

  JPTLineCount := JPTHead.thAsApplication.tpRetentionLines.thLineCount;

  for i := 1 to JPTLineCount do begin // add retention record lines
    JPTLine := JPTHead.thAsApplication.tpRetentionLines.thLine[i] as ITransactionLine3;
    JCTLine := JCTHead.thAsApplication.tpRetentionlines.Add as ITransactionLine3;
    with JCTLine do begin
        tlCostCentre := 'AAA';
        tlDepartment := 'AAA';
        tlAsApplication.tplAnalysisCode := JPTLine.tlAsApplication.tplAnalysisCode;
        ImportDefaults;
        tlAsApplication.tplRetention := JPTLine.tlAsApplication.tplRetention;
      save;
    end;
  end;
end;

function TImportToolkit.PopulateJSAfromJST(Job: IJob4; JSAHead: ITransaction3): integer;
var
  JSTHead: ITransaction3;
  JSTLine: ITransactionLine3;
  JSTLineCount: integer;
  JSALine: ITransactionLine3;
  i: integer;
begin
  Result := 0;
  JSTHead := Job.jrApplications.jbaMasterSalesTerms;
  if JSTHead = nil then
    exit;

  with JSAHead.thAsApplication do
    tpParentTerms := JSTHead.thAsApplication.tpOurRef;

  JSTLineCount := JSTHead.thLines.thLineCount;

  for i := 1 to JSTLineCount do begin // add budget record lines
    JSTLine := JSTHead.thLines.thLine[i] as ITransactionLine3;
    JSALine := JSAHead.thLines.Add as ITransactionLine3;
    with JSALine do begin
      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';
      with tlAsApplication do begin
        tplAnalysisCode := JSTLine.tlAsApplication.tplAnalysisCode;
        ImportDefaults;
        tplTermsLineNo  := JSTLine.tlABSLineNo;
        tplQty          := JSTLine.tlAsApplication.tplQty;
      end;
      save;
    end;
  end;

  JSTLineCount := JSTHead.thAsApplication.tpDeductionLines.thLineCount;

  for i := 1 to JSTLineCount do begin // add deduction record lines
    JSTLine := JSTHead.thAsApplication.tpDeductionLines.thLine[i] as ITransactionLine3;
    JSALine := JSAHead.thAsApplication.tpDeductionLines.Add as ITransactionLine3;
    with JSALine do begin
      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';
      tlAsApplication.tplAnalysisCode := JSTLine.tlAsApplication.tplAnalysisCode;
      ImportDefaults;
      save;
    end;
  end;

  JSTLineCount := JSTHead.thAsApplication.tpRetentionLines.thLineCount;

  for i := 1 to JSTLineCount do begin // add retention record lines
    JSTLine := JSTHead.thAsApplication.tpRetentionLines.thLine[i] as ITransactionLine3;
    JSALine := JSAHead.thAsApplication.tpRetentionlines.Add as ITransactionLine3;
    with JSALine do begin
      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';
      with tlAsApplication do begin
        tplAnalysisCode := JSTLine.tlAsApplication.tplAnalysisCode;
        JSALine.ImportDefaults;
        tplRetention := JSTLine.tlAsApplication.tplRetention;
      end;
      save;
    end;
  end;
end;

function TImportToolkit.PopulateJPAfromJCT(Job: IJob4; JPAHead: ITransaction3): integer;
var
  JCTHead: ITransaction3;
  JCTLine: ITransactionLine3;
  JCTLineCount: integer;
  JPALine: ITransactionLine3;
  i: integer;
  rc: integer;
begin
  Result := 0;
  JCTHead := Job.jrApplications.jbaContractTerms.Item;
  if JCTHead = nil then
    exit;

  rc := JCTHead.GetFirst;

  while rc = 0 do begin
    if (JCTHead.thAsApplication.tpEmployeeCode = JPAHead.thAsApplication.tpEmployeeCode) then begin
      with JPAHead.thAsApplication do
        tpParentTerms := JCTHead.thAsApplication.tpOurRef;

      JCTLineCount := JCTHead.thLines.thLineCount;

      for i := 1 to JCTLineCount do begin // add budget record lines
        JCTLine := JCTHead.thLines.thLine[i] as ITransactionLine3;
        JPALine := JPAHead.thLines.Add as ITransactionLine3;
        with JPALine do begin
          tlCostCentre := 'AAA';
          tlDepartment := 'AAA';
          with tlAsApplication do begin
            tplAnalysisCode := JCTLine.tlAsApplication.tplAnalysisCode;
            ImportDefaults;
            tplTermsLineNo  := JCTLine.tlABSLineNo;
            tplQty          := JCTLine.tlAsApplication.tplQty;
            tplBudgetJCT    := JCTLine.tlAsApplication.tplBudgetJCT;
          end;
          save;
        end;
      end;

      JCTLineCount := JCTHead.thAsApplication.tpDeductionLines.thLineCount;

      for i := 1 to JCTLineCount do begin // add deduction record lines
        JCTLine := JCTHead.thAsApplication.tpDeductionLines.thLine[i] as ITransactionLine3;
        JPALine := JPAHead.thAsApplication.tpDeductionLines.Add as ITransactionLine3;
  	     with JPALine do begin
          tlCostCentre := 'AAA';
          tlDepartment := 'AAA';
          tlAsApplication.tplAnalysisCode := JCTLine.tlAsApplication.tplAnalysisCode;
          ImportDefaults;
          save;
        end;
      end;

      JCTLineCount := JCTHead.thAsApplication.tpRetentionLines.thLineCount;

      for i := 1 to JCTLineCount do begin // add retention record lines
        JCTLine := JCTHead.thAsApplication.tpRetentionLines.thLine[i] as ITransactionLine3;
        JPALine := JPAHead.thAsApplication.tpRetentionlines.Add as ITransactionLine3;
        with JPALine do begin
          tlCostCentre := 'AAA';
          tlDepartment := 'AAA';
          with tlAsApplication do begin
            tplAnalysisCode := JCTLine.tlAsApplication.tplAnalysisCode;
            JPALine.ImportDefaults;
            tplRetention := JCTLine.tlAsApplication.tplRetention;
          end;
          save;
        end;
      end;
    end;
    rc := JCTHead.GetNext;
  end;
end;

function TImportToolkit.StoreAVTrans(PH: TManagedRec; PL: TArrayOfManagedRec; ALineCount:integer): integer;
var
  Job: IJob4;
  JxxHead: ITransaction3;
  JxxLine: ITransactionLine3;
  rc: integer;
  i: integer;
  RT: string;
  dr: TBatchAVDDRec; // deduction or retention rec
  tr: TBatchAVHRec;  // terms rec
begin
  OpenCOMToolkit; CheckImportMode;

  tr := PH.ExchequerRec.BatchAVHRec;

  with ComToolkit.JobCosting.Job do begin // find the job code
    Index := jrIdxCode;
    rc    := GetEqual(BuildCodeIndex(tr.jrCode));
    if rc <> 0 then begin
      result := -99002;
      exit;
    end;
  end;

  Job := ComToolkit.JobCosting.Job as IJob4;

  RT := PH.RecordType;

  if RT = 'PT' then begin
    JxxHead := Job.jrApplications.jbaPurchaseTerms as ITransaction3;
    if JxxHead = nil then
      JxxHead := Job.jrApplications.AddPurchaseTerms(ToolkitConfiguration.tcUseJobBudgets) as ITransaction3;
  end
  else
  if RT = 'ST' then begin
    JxxHead := Job.jrApplications.jbaMasterSalesTerms as ITransaction3;
    if JxxHead = nil then
      JxxHead := Job.jrApplications.AddMasterSalesTerms(ToolkitConfiguration.tcUseJobBudgets) as ITransaction3;
  end
  else
  if RT = 'CT' then
    JxxHead := Job.jrApplications.jbaContractTerms.Add as ITransaction3 else
  if RT = 'SA' then
    JxxHead := Job.jrApplications.jbaSalesApplication.Add as ITransaction3 else
  if RT = 'PA' then
    JxxHead := Job.jrApplications.jbaPurchaseApplication.Add as ITransaction3;

  with JxxHead do begin
    if NotBlank(@tr.thFixedRate) then
      thFixedRate := tr.thFixedRate;
    with thAsApplication do begin
      ImportDefaults;
      if NotBlank(@tr.tpEmployeeCode) then
        tpEmployeeCode := tr.tpEmployeeCode;
      if NotBlank(@tr.tpAcCode) then
        tpAcCode := tr.tpAcCode;
      if NotBlank(@tr.tpAppsInterimFlag) then
        tpAppsInterimFlag := tr.tpAppsInterimFlag;
      if NotBlank(@tr.tpATR) then
        tpATR := tr.tpATR;
      if NotBlank(@tr.tpCertified) then
        tpCertified := tr.tpCertified;
//***      if NotBlank(@tr.tpCertifiedValue) then
//***        tpCertifiedValue := tr.tpCertifiedValue; // READ-ONLY
      if NotBlank(@tr.tpCISDate) then
        tpCISDate := tr.tpCISDate;
      if NotBlank(@tr.tpCISManualTax) then
        tpCISManualTax := tr.tpCISManualTax;
//***      if NotBlank(@tr.tpCISSource) then
//***        JxxHead.thCISSource := tr.tpCISSource; // READ-ONLY
//***      if NotBlank(@tr.tpCISTaxDeclared) then
//***        JxxHead.thCISTaxDeclared := tr.tpCISTaxDeclared; // Set directly on HEADER
      if NotBlank(@tr.tpCISTaxDue) then
        tpCISTaxDue := tr.tpCISTaxDue;
      if NotBlank(@tr.tpCompanyRate) then
        tpCompanyRate := tr.tpCompanyRate;
      if NotBlank(@tr.tpCurrency) then
        tpCurrency := tr.tpCurrency;
      if NotBlank(@tr.tpDailyRate) then
        tpDailyRate := tr.tpDailyRate;
      if NotBlank(@tr.tpDate) then
        tpDate := tr.tpDate;
      if NotBlank(@tr.tpDeferVAT) then
        tpDeferVAT := tr.tpDeferVat;
      if NotBlank(@tr.tpManualVAT) then
        tpManualVAT := tr.tpManualVAT;
      if NotBlank(@tr.tpOurRef) then
        tpOurRef := tr.tpOurRef;
      if NotBlank(@tr.tpParentTerms) then
        tpParentTerms := tr.tpParentTerms;
      if NotBlank(@tr.tpPeriod) then
        tpPeriod := tr.tpPeriod;
      if NotBlank(@tr.tpTermsInterimFlag) then
        tpTermsInterimFlag := tr.tpTermsInterimFlag;
      if NotBlank(@tr.tpUserField1) then
        tpUserField1 := tr.tpUserField1;
      if NotBlank(@tr.tpUserField2) then
        tpUserField2 := tr.tpUserField2;
      if NotBlank(@tr.tpUserField3) then
        tpUserField3 := tr.tpUserField3;
      if NotBlank(@tr.tpUserField4) then
        tpUserfield4 := tr.tpUserField4;

      if NotBlank(@tr.tpParentTerms) then
        if RT = 'CT' then PopulateJCTfromJPT(Job, JxxHead) else
        if RT = 'SA' then PopulateJSAfromJST(Job, JxxHead) else
        if RT = 'PA' then PopulateJPAfromJCT(Job, JxxHead);

      for i := 1 to ALineCount do begin
        dr := PL[i].ExchequerRec.BatchAVDDRec; // same as BatchAVRRRec so use either to access fields.
        if PL[i].RecordType = 'DD' then
          JxxLine := tpDeductionLines.Add as ITransactionLine3
        else
        if PL[i].RecordType = 'RR' then
          JxxLine := tpRetentionLines.Add as ITransactionLine3
        else
        if PL[i].RecordType = 'BB' then
          JxxLine := JxxHead.thLines.Add as ITransactionLine3;
        with JxxLine.tlAsApplication do begin
          if NotBlank(@dr.tplAnalysisCode) then
            tplAnalysisCode := dr.tplAnalysisCode;
          JxxLine.ImportDefaults;
          if (RT <> 'SA') and (RT <> 'PA') then
            if NotBlank(@dr.tplBudgetJCT) then
              tplBudgetJCT := dr.tplBudgetJCT;
          if NotBlank(@dr.tplAppliedYTD) then
            tplAppliedYTD := dr.tplAppliedYTD;
          if NotBlank(@dr.tplCalcBeforeRetention) then
            tplCalculateBeforeRetention := dr.tplCalcBeforeRetention;
//***          if NotBlank(@dr.tplCertified) then
//***           tplCertified := dr.tplCertified; // READ-ONLY
          if NotBlank(@dr.tplCertifiedYTD) then
            tplCertifiedYTD := dr.tplCertifiedYTD;
          if NotBlank(@dr.tplCostCentre) then
            tplCostCentre := dr.tplCostCentre;
          if NotBlank(@dr.tplDeductionAppliesTo) then
            tplDeductionAppliesTo := dr.tplDeductionAppliesTo;
          if NotBlank(@dr.tplDeductionType) then
            tplDeductionType := dr.tplDeductionType;
          if NotBlank(@dr.tplDeductValue) then
            tplDeductValue := dr.tplDeductValue;
          if NotBlank(@dr.tplDepartment) then
            tplDepartment := dr.tplDepartment;
          if NotBlank(@dr.tplDescr) then
            tplDescr := dr.tplDescr;
//          if NotBlank(@dr.tplJobCode) then
//            tplJobCode := dr.tplJobCode;
          if NotBlank(@dr.tplLineType) then
            tplLineType := dr.tplLineType;
          if NotBlank(@dr.tplQty) then
            tplQty := dr.tplQty;
          if NotBlank(@dr.tplRetention) then
            tplRetention := dr.tplRetention;
          if NotBlank(@dr.tplRetentionExpiry) then
            tplRetentionExpiry := dr.tplRetentionExpiry;
          if NotBlank(@dr.tplRetentionExpiryBasis) then
            tplRetentionExpiryBasis := dr.tplRetentionExpiryBasis;
          if NotBlank(@dr.tplRetentionType) then
            tplRetentionType := dr.tplRetentionType;
          if NotBlank(@dr.tplTermsLineNo) then
            tplTermsLineNo := dr.tplTermsLineNo;
          if NotBlank(@dr.tplUserField1) then
            JxxLine.tlUserField1 := dr.tplUserField1;
          if NotBlank(@dr.tplUserField2) then
            JxxLine.tlUserField2 := dr.tplUserField2;
          if NotBlank(@dr.tplUserField3) then
            JxxLine.tlUserField3 := dr.tplUserField3;
          if NotBlank(@dr.tplUserField4) then
            JxxLine.tlUserField4 := dr.tplUserField4;
          if NotBlank(@dr.tlVATCode) then
            JxxLine.tlVATCode := dr.tlVATCode; // set directly on line
          JxxLine.Save;
        end;
      end;
    end;
    result := Save(true);
  end;
end;

//PR: 01/06/2010 Changed to use ShortString for SeachKey and allocate PChar of required length - avoids bounds error.
function TImportToolkit.GetAccount(P: pointer; PSize: integer;
  SearchKey: ShortString; SearchPath: integer; SearchMode: smallint; AcctType: smallint;
  Lock: boolean): integer;
var
  SKey : PChar;
begin
  StartTimer;
  SKey := StrAlloc(255);
  Try
    FillChar(SKey^, 255, 0);
    StrPCopy(SKey, SearchKey);
    result := EX_GETACCOUNT(P, PSize, SKey, SearchPath, SearchMode, AcctType, Lock);
  Finally
    StrDispose(SKey);
  End;
  StopTimer;
end;

function TImportToolkit.GetRecordAddress(FileNum: smallint; var RecAddress: Integer): smallint;
begin
  result := EX_GETRECORDADDRESS(Filenum, RecAddress);
end;

function TImportToolkit.GetRecWithAddress(FileNum: smallint; KeyPath: smallint; TRecAddr: Integer): smallint;
begin
  result := EX_GETRECWITHADDRESS(FileNum, KeyPath, TRecAddr);
end;

function TImportToolkit.Get_LiveStockCOSVal: boolean; // v.075
begin
  result := FLiveStockCOSVal;
end;

function TImportToolkit.StoreCCDep(P: pointer; PSize: integer): integer;
var
  CCDepType: smallint;
begin
  CCDepType := 0;
  case PExchequerRec(P).BatchCCDepRec.ImporterCCDepInd of
    'C': CCDepType := 0;
    'D': CCDepType := 1;
  end;
  StartTimer;
  result := EX_STORECCDEP(P, PSize, ToolkitConfiguration.tcImportMode, CCDepType);
  StopTimer;
end;

function TImportToolkit.StoreMultiBuyDiscount(P : Pointer; PSize : Integer) : integer;
begin
  StartTimer;
  result := EX_STOREMULTIBUY(P, PSize, 0, ToolkitConfiguration.tcImportMode);
  StopTimer;
end;

function TImportToolkit.StoreContact(
  P: PImporterAccountContactRec): Integer;
begin
  Result := StoreAccountContact(P, ToolkitConfiguration.tcTrialImport);
end;

function TImportToolkit.StoreContactRole(
  P: PImporterAccountContactRoleRec): Integer;
begin
  Result := StoreAccountContactRole(P, ToolkitConfiguration.tcTrialImport);
end;

function TImportToolkit.Get_IsSPOP: Boolean;
begin
  GetSystemSetup; //opens toolkit if it isn't already open
  Result := FCOMToolkit.Enterprise.enModuleVersion >= enModSPOP;
end;

//SSK 13/09/2016 2016-R3 ABSEXCH-15502: This function added to extract BOM Component stocks
function TImportToolkit.GetStockBOMRec(P: pointer; PSize: integer;SearchKey: Shortstring; SearchMode: smallint): integer;
var
  SKey : PChar;
begin
  StartTimer;
  SKey := StrAlloc(255);
  Try
    FillChar(SKey^, 255, 0);
    StrPCopy(SKey, SearchKey);
    result := EX_GETSTOCKBOM(P, PSize, SKey, SearchMode);
  Finally
    StrDispose(SKey);
  End;
  StopTimer;
end;


{ TImportToolkitConfiguration }

function TImportToolkitConfiguration.Get_AutoSetPeriod: boolean;
begin
  result := FAutoSetPeriod;
end;

procedure TImportToolkitConfiguration.Set_AutoSetPeriod(const Value: boolean);
begin
  FAutoSetPeriod := Value;
end;

function TImportToolkitConfiguration.Get_TrialImport: boolean;
begin
  result := FImportMode = 100;
end;

procedure TImportToolkitConfiguration.Set_TrialImport(const Value: boolean);
begin
  FTrialImport := Value;
  if FTrialImport then
      FImportMode := 100
  else
    FImportMode := 200;        // v.086 uncommented back in - DLL toolkit will do a b_insert or b_update depending on whether the record exists or not.
//    FImportMode := b_insert; // v.086 commented back out
end;

function TImportToolkitConfiguration.Get_ImportMode: integer;
begin
  result := FImportMode;
end;

function TImportToolkitConfiguration.Get_CalcTHTotals: boolean;
begin
  result := FCalcTHTotals;
end;

function TImportToolkitConfiguration.Get_AutoSetTHOurRef: boolean;
begin
  result := FAutoSetTHOurRef;
end;

function TImportToolkitConfiguration.Get_AutoSetTHLineCount: boolean;
begin
  result := FAutoSetTHLineCount;
end;

function TImportToolkitConfiguration.Get_AutoSetTLLineNo: boolean;
begin
  result := FAutoSetTLLineNo;
end;

function TImportToolkitConfiguration.Get_AutoSetTLRefFromTH: boolean;
begin
  result := FAutoSetTLRefFromTH;
end;

procedure TImportToolkitConfiguration.Set_CalcTHTotals(const Value: boolean);
begin
  FCalcTHTotals := Value;
end;

procedure TImportToolkitConfiguration.Set_AutoSetTHOurRef(const Value: boolean);
begin
  FAutoSetTHOurRef := Value;
end;

procedure TImportToolkitConfiguration.Set_AutoSetTHLineCount(const Value: boolean);
begin
  FAutoSetTHLineCount := Value;
end;

procedure TImportToolkitConfiguration.Set_AutoSetTLLineNo(const Value: boolean);
begin
  FAutoSetTLLineNo := Value;
end;

procedure TImportToolkitConfiguration.Set_AutoSetTLRefFromTH(const Value: boolean);
begin
  FAutoSetTLRefFromTH := Value;
end;

function TImportToolkit.Get_Password: string;
begin
  result := FPassword;
end;

function TImportToolkit.Get_UserName: string;
begin
  result := FUserName;
end;

procedure TImportToolkit.Set_Password(const Value: string);
begin
  FPassword := Value;
end;

procedure TImportToolkit.Set_UserName(const Value: string);
begin
  FUserName := Value;
end;

function TImportToolkitConfiguration.Get_DefaultNominalCode: integer;
begin
  result := FDefaultNominalCode;
end;

procedure TImportToolkitConfiguration.Set_DefaultNominalCode(const Value: integer);
begin
  FDefaultNominalCode := Value;
end;

function TImportToolkitConfiguration.Get_AllowTransactionEditing: boolean;
begin
  result := FAllowTransactionEditing;
end;

function TImportToolkitConfiguration.Get_AutoSetCurrencyRates: boolean;
begin
  result := FAutoSetCurrencyRates;
end;

function TImportToolkitConfiguration.Get_AutoSetStockCost: boolean;
begin
  result := FAutoSetStockCost;
end;

function TImportToolkitConfiguration.Get_DeductBOMStock: boolean;
begin
  result := FDeductBOMStock;
end;

function TImportToolkitConfiguration.Get_DeductMultiLocationStock: boolean;
begin
  result := FDeductMultiLocationStock;
end;

function TImportToolkitConfiguration.Get_DefaultCostCentre: string;
begin
  result := FDefaultCostCentre;
end;

function TImportToolkitConfiguration.Get_DefaultCurrency: integer;
begin
  result := FDefaultCurrency;
end;

function TImportToolkitConfiguration.Get_DefaultDepartment: string;
begin
  result := FDefaultDepartment;
end;

function TImportToolkitConfiguration.Get_DefaultVATCode: string;
begin
  result := FDefaultVATCode;
end;

function TImportToolkitConfiguration.Get_OverwriteNotepad: boolean;
begin
  result := FOverwriteNotepad;
end;

function TImportToolkitConfiguration.Get_UpdateAccountBalances: boolean;
begin
  result := FUpdateAccountBalances;
end;

function TImportToolkitConfiguration.Get_UpdateStockLevels: boolean;
begin
  result := FUpdateStockLevels;
end;

function TImportToolkitConfiguration.Get_ValidateJobCostingFields: boolean;
begin
  result := FValidateJobCostingFields;
end;

procedure TImportToolkitConfiguration.Set_AllowTransactionEditing(const Value: boolean);
begin
  FAllowTransactionEditing := Value;
end;

procedure TImportToolkitConfiguration.Set_AutoSetCurrencyRates(const Value: boolean);
begin
  FAutoSetCurrencyRates := Value;
end;

procedure TImportToolkitConfiguration.Set_AutoSetStockCost(const Value: boolean);
begin
  FAutoSetStockCost := Value;
end;

procedure TImportToolkitConfiguration.Set_DeductBOMStock(const Value: boolean);
begin
  FDeductBOMStock := Value;
end;

procedure TImportToolkitConfiguration.Set_DeductMultiLocationStock(const Value: boolean);
begin
  FDeductMultiLocationStock := Value;
end;

procedure TImportToolkitConfiguration.Set_DefaultCostCentre(const Value: string);
begin
  FDefaultCostCentre := Value;
end;

procedure TImportToolkitConfiguration.Set_DefaultCurrency(const Value: integer);
begin
  FDefaultCurrency := Value;
end;

procedure TImportToolkitConfiguration.Set_DefaultDepartment(const Value: string);
begin
  FDefaultDepartment := Value;
end;

procedure TImportToolkitConfiguration.Set_DefaultVATCode(const Value: string);
begin
  FDefaultVATCode := Value;
end;

procedure TImportToolkitConfiguration.Set_OverwriteNotepad(const Value: boolean);
begin
  FOverwriteNotepad := Value;
end;

procedure TImportToolkitConfiguration.Set_UpdateAccountBalances(const Value: boolean);
begin
  FUpdateAccountBalances := Value;
end;

procedure TImportToolkitConfiguration.Set_UpdateStockLevels(const Value: boolean);
begin
  FUpdateStockLevels := Value;
end;

procedure TImportToolkitConfiguration.Set_ValidateJobCostingFields(const Value: boolean);
begin
  FValidateJobCostingFields := Value;
end;

function TImportToolkitConfiguration.Get_MultiCurrency: boolean;
begin
  result := FMultiCurrency;
end;

procedure TImportToolkitConfiguration.Set_MultiCurrency(const Value: boolean);
begin
  FMultiCurrency := Value;
end;

function TImportToolkitConfiguration.Get_UseJobBudgets: boolean;
begin
  result := FUseJobBudgets
end;

procedure TImportToolkitConfiguration.Set_UseJobBudgets(const Value: boolean);
begin
  FUseJobBudgets := Value;
end;



function TImportToolkitConfiguration.Get_ApplyMBD: Boolean;
begin
  Result := FApplyMBD;
end;

function TImportToolkitConfiguration.Get_ApplyVBD: Boolean;
begin
  Result := FApplyVBD;
end;

procedure TImportToolkitConfiguration.Set_ApplyMBD(const Value: Boolean);
begin
  FApplyMBD := Value;
end;

procedure TImportToolkitConfiguration.Set_ApplyVBD(const Value: Boolean);
begin
  FApplyVBD := Value;
end;

function TImportToolkitConfiguration.Get_OverwriteDiscountDates: Boolean;
begin
  Result := FOverwriteDiscountDates;
end;

procedure TImportToolkitConfiguration.Set_OverwriteDiscountDates(const Value: Boolean);
begin
  FOverwriteDiscountDates := Value;
end;


initialization
  Toolkit := nil;

finalization
  Toolkit := nil;

end.
