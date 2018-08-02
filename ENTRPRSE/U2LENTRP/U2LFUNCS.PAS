unit U2LFuncs;

{ prutherford440 08:53 25/03/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  Windows, Dialogs, SysUtils, UFFuncs;


const NumFunctions = 77; //the number of custom functions defined here
const ErrBadNumInt1 = 1;
const ErrBadNumInt2 = 2;


//the following are our defined functions - will be called from Crystal
{ Miscellaneous Functions }
function GetLibVers(ParamBlock : PUFParamBlock) : UFError; stdcall;
function ConvertIToD(ParamBlock : PUFParamBlock) : UFError; stdcall;
Function DocSign (ParamBlock : PUFParamBlock) : UFError; stdcall;

{ Customer/Supplier Functions }
function GetCustBalance(ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetCustNetSales(ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetCustCosts(ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetCustMargin(ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetCustDebits(ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetCustCredits(ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetCustBudget(ParamBlock : PUFParamBlock) : UFError; stdcall;

{ General Ledger Functions }
Function GetGLBudget (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLBudget2 (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLActual (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLDebit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLCredit (ParamBlock : PUFParamBlock) : UFError; stdcall;

Function GetGLCCBudget (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLCCBudget2 (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLCCActual (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLCCDebit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLCCCredit (ParamBlock : PUFParamBlock) : UFError; stdcall;

Function GetGLDpBudget (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLDpBudget2 (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLDpActual (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLDpDebit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLDpCredit (ParamBlock : PUFParamBlock) : UFError; stdcall;

{ HM 08/03/00: Added Committed functions for GL }
Function GetGLCOMActual (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLCOMDebit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLCOMCredit (ParamBlock : PUFParamBlock) : UFError; stdcall;

Function GetGLCCCOMActual (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLCCCOMDebit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLCCCOMCredit (ParamBlock : PUFParamBlock) : UFError; stdcall;

Function GetGLDpCOMActual (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLDpCOMDebit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetGLDpCOMCredit (ParamBlock : PUFParamBlock) : UFError; stdcall;

{ Stock Functions }
Function GetStkQtySold (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkSales (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkCosts (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkMargin (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkBudget (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkPosted (ParamBlock : PUFParamBlock) : UFError; stdcall;

Function GetStkLocQtySold (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkLocSales (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkLocCosts (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkLocMargin (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkLocBudget (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStkLocPosted (ParamBlock : PUFParamBlock) : UFError; stdcall;

{ Job Costing Functions }
function GetJCCatDesc(ParamBlock : PUFParamBlock) : UFError; stdcall;

Function GetJBQuantity (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetJBBudget (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetJBRevBudgQty (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetJBRevBudget (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetJBActualQty (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetJBActual (ParamBlock : PUFParamBlock) : UFError; stdcall;

Function GetJCBudget (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetJCRevBudget (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetJCActual (ParamBlock : PUFParamBlock) : UFError; stdcall;

Function ConvertDate (ParamBlock : PUFParamBlock) : UFError; stdcall;

{ HM 24/09/98: Added Stock Qty functions }
Function GetStockQty (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStockLocQty (ParamBlock : PUFParamBlock) : UFError; stdcall;

{ HM 22/03/00: Added for DL }
Function GetStockString (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStockInt (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetStockDbl (ParamBlock : PUFParamBlock) : UFError; stdcall;

{ HM 08/03/01: Added Customer String interface to shutup some Irish gits }
Function GetAccountString (ParamBlock : PUFParamBlock) : UFError; stdcall;

{PR 17/05/01: Added customer integer & Double interface}
Function GetAccountInt (ParamBlock : PUFParamBlock) : UFError; stdcall;
Function GetAccountDbl (ParamBlock : PUFParamBlock) : UFError; stdcall;

{PR 17/05/01 Add CCDeptName function}
function GetCCDepName (ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetJobString (ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetLocationName (ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetCurrencyName (ParamBlock : PUFParamBlock) : UFError; stdcall;

function GetJobInt (ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetJobDbl (ParamBlock : PUFParamBlock) : UFError; stdcall;

function GetAnalDesc (ParamBlock : PUFParamBlock) : UFError; stdcall;

function GetCustStkQty (ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetCustStkSales (ParamBlock : PUFParamBlock) : UFError; stdcall;

function GetDailyRate (ParamBlock : PUFParamBlock) : UFError; stdcall;
function GetCompanyRate (ParamBlock : PUFParamBlock) : UFError; stdcall;

//PR 6/8/2002
//Added login function
function DefaultLogin (ParamBlock : PUFParamBlock) : UFError; stdcall;


//Function templates definitions - we have to specify the number of parameters
var FunctionTemplates :  array[1..NumFunctions+1] of UFFunctionTemplates =
(
(Functemplate:'EntConvertDate(!)'),

(Functemplate:'EntCustBalance (!,,,)'),
(Functemplate:'EntCustBudget (!,,,)'),
(Functemplate:'EntCustCosts (!,,,)'),
(Functemplate:'EntCustCredits (!,,,)'),
(Functemplate:'EntCustDebits (!,,,)'),
(Functemplate:'EntCustMargin (!,,,)'),
(Functemplate:'EntCustNetSales (!,,,)'),

(Functemplate:'EntDocSign(!DocType)'),
(Functemplate:'EntDouble (!,)'),

(Functemplate:'EntGLActual (!,,,,)'),
(Functemplate:'EntGLBudget (!,,,,)'),
(Functemplate:'EntGLBudget2 (!,,,,)'),
(Functemplate:'EntGLCredit (!,,,,)'),
(Functemplate:'EntGLDebit (!,,,,)'),

(Functemplate:'EntGLComActual (!,,,,)'),
(Functemplate:'EntGLComCredit (!,,,,)'),
(Functemplate:'EntGLComDebit (!,,,,)'),

(Functemplate:'EntGLCCActual (!,,,,,)'),
(Functemplate:'EntGLCCBudget (!,,,,,)'),
(Functemplate:'EntGLCCBudget2 (!,,,,,)'),
(Functemplate:'EntGLCCCredit (!,,,,,)'),
(Functemplate:'EntGLCCDebit (!,,,,,)'),

(Functemplate:'EntGLCCComActual (!,,,,,)'),
(Functemplate:'EntGLCCComCredit (!,,,,,)'),
(Functemplate:'EntGLCCComDebit (!,,,,,)'),

(Functemplate:'EntGLDpActual (!,,,,,)'),
(Functemplate:'EntGLDpBudget (!,,,,,)'),
(Functemplate:'EntGLDpBudget2 (!,,,,,)'),
(Functemplate:'EntGLDpCredit (!,,,,,)'),
(Functemplate:'EntGLDpDebit (!,,,,,)'),

(Functemplate:'EntGLDpComActual (!,,,,,)'),
(Functemplate:'EntGLDpComCredit (!,,,,,)'),
(Functemplate:'EntGLDpComDebit (!,,,,,)'),

(Functemplate:'EntJBudget(!,,,,,)'),
(Functemplate:'EntJBudgetActQty(!,,,,,)'),
(Functemplate:'EntJBudgetActual(!,,,,,)'),
(Functemplate:'EntJBudgetQty(!,,,,,)'),
(Functemplate:'EntJBudgetRev(!,,,,,)'),
(Functemplate:'EntJBudgetRevQty(!,,,,,)'),
(Functemplate:'EntJCCatDesc(!,)'),
(Functemplate:'EntJComBudget(!,,,,,)'),
(Functemplate:'EntJComBudgetActual(!,,,,,)'),
(Functemplate:'EntJComBudgetRev(!,,,,,)'),

(Functemplate:'EntLibVer!'),

(Functemplate:'EntStkBudget(!,,,,)'),
(Functemplate:'EntStkCosts(!,,,,)'),
(Functemplate:'EntStkMargin(!,,,,)'),
(Functemplate:'EntStkPosted(!,,,,)'),
(Functemplate:'EntStkQty(!,)'),
(Functemplate:'EntStkQtySold(!,,,,)'),
(Functemplate:'EntStkSales(!,,,,)'),

(Functemplate:'EntStkLocBudget(!,,,,,)'),
(Functemplate:'EntStkLocCosts(!,,,,,)'),
(Functemplate:'EntStkLocMargin(!,,,,,)'),
(Functemplate:'EntStkLocPosted(!,,,,,)'),
(Functemplate:'EntStkLocQty(!,,)'),
(Functemplate:'EntStkLocQtySold(!,,,,,)'),
(Functemplate:'EntStkLocSales(!,,,,,)'),

(Functemplate:'EntStkStr(!,,,)'),
(Functemplate:'EntStkInteger(!,,,,)'),
(Functemplate:'EntStkDouble(!,,,,)'),

(Functemplate:'EntAccountStr(!,,,)'),
(Functemplate:'EntAccountInteger(!,,,)'),
(Functemplate:'EntAccountDouble(!,,,)'),

(Functemplate:'EntCCDepName(!,,)'),
(Functemplate:'EntJobStr(!,,)'),
(Functemplate:'EntLocationName(!,)'),
(Functemplate:'EntCurrencyName(!,)'),
(Functemplate:'EntJobInteger(!,,)'),
(Functemplate:'EntJobDouble(!,,)'),
(Functemplate:'EntAnalDesc(!,)'),

(Functemplate:'EntCustStkQty(!,,,,,,,,)'),
(Functemplate:'EntCustStkSales(!,,,,,,,,)'),

(Functemplate:'EntDailyRate(!,)'),
(Functemplate:'EntCompanyRate(!,)'),

(Functemplate:'EntDefaultLogin(!,)'),

(Functemplate:nil)
);

//Function examples definitions
const FunctionExamples : array[1..NumFunctions+1] of UFFunctionExamples =
(
(FuncExample:#09'EntConvertDate (DateString)'),

(FuncExample:#09'EntCustBalance (Company,CustCode,Year,Period)'),
(FuncExample:#09'EntCustBudget (Company,CustCode,Year,Period)'),
(FuncExample:#09'EntCustCosts (Company,CustCode,Year,Period)'),
(FuncExample:#09'EntCustCredits (Company,CustCode,Year,Period)'),
(FuncExample:#09'EntCustDebits (Company,CustCode,Year,Period)'),
(FuncExample:#09'EntCustMargin (Company,CustCode,Year,Period)'),
(FuncExample:#09'EntCustNetSales (Company,CustCode,Year,Period)'),

(FuncExample:#09'EntDocSign(DocType)'),
(FuncExample:#09'EntDouble (NumInt1,NumInt2)'),

(FuncExample:#09'EntGLActual (Company,GLCode,Year,Period,Currency)'),
(FuncExample:#09'EntGLBudget (Company,GLCode,Year,Period,Currency)'),
(FuncExample:#09'EntGLBudget2 (Company,GLCode,Year,Period,Currency)'),
(FuncExample:#09'EntGLCredit (Company,GLCode,Year,Period,Currency)'),
(FuncExample:#09'EntGLDebit (Company,GLCode,Year,Period,Currency)'),

(FuncExample:#09'EntGLComActual (Company,GLCode,Year,Period,Currency)'),
(FuncExample:#09'EntGLComCredit (Company,GLCode,Year,Period,Currency)'),
(FuncExample:#09'EntGLComDebit (Company,GLCode,Year,Period,Currency)'),

(FuncExample:#09'EntGLCCActual (Company,GLCode,Year,Period,Currency,CostCentre)'),
(FuncExample:#09'EntGLCCBudget (Company,GLCode,Year,Period,Currency,CostCentre)'),
(FuncExample:#09'EntGLCCBudget2 (Company,GLCode,Year,Period,Currency,CostCentre)'),
(FuncExample:#09'EntGLCCCredit (Company,GLCode,Year,Period,Currency,CostCentre)'),
(FuncExample:#09'EntGLCCDebit (Company,GLCode,Year,Period,Currency,CostCentre)'),

(FuncExample:#09'EntGLCCComActual (Company,GLCode,Year,Period,Currency,CostCentre)'),
(FuncExample:#09'EntGLCCComCredit (Company,GLCode,Year,Period,Currency,CostCentre)'),
(FuncExample:#09'EntGLCCComDebit (Company,GLCode,Year,Period,Currency,CostCentre)'),

(FuncExample:#09'EntGLDpActual (Company,GLCode,Year,Period,Currency,Department)'),
(FuncExample:#09'EntGLDpBudget (Company,GLCode,Year,Period,Currency,Department)'),
(FuncExample:#09'EntGLDpBudget2 (Company,GLCode,Year,Period,Currency,Department)'),
(FuncExample:#09'EntGLDpCredit (Company,GLCode,Year,Period,Currency,Department)'),
(FuncExample:#09'EntGLDpDebit (Company,GLCode,Year,Period,Currency,Department)'),

(FuncExample:#09'EntGLDpComActual (Company,GLCode,Year,Period,Currency,Department)'),
(FuncExample:#09'EntGLDpComCredit (Company,GLCode,Year,Period,Currency,Department)'),
(FuncExample:#09'EntGLDpComDebit (Company,GLCode,Year,Period,Currency,Department)'),

(FuncExample:#09'EntJBudget (Company,JobCode,HistFolio,Year,Period,Currency)'),
(FuncExample:#09'EntJBudgetActQty (Company,JobCode,HistFolio,Year,Period,Currency)'),
(FuncExample:#09'EntJBudgetActual (Company,JobCode,HistFolio,Year,Period,Currency)'),
(FuncExample:#09'EntJBudgetQty (Company,JobCode,HistFolio,Year,Period,Currency)'),
(FuncExample:#09'EntJBudgetRev (Company,JobCode,HistFolio,Year,Period,Currency)'),
(FuncExample:#09'EntJBudgetRevQty (Company,JobCode,HistFolio,Year,Period,Currency)'),
(FuncExample:#09'EntJCCatDesc (Company,DescNo)'),
(FuncExample:#09'EntJComBudget (Company,JobCode,HistFolio,Year,Period,Currency)'),
(FuncExample:#09'EntJComBudgetActual (Company,JobCode,HistFolio,Year,Period,Currency)'),
(FuncExample:#09'EntJComBudgetRev (Company,JobCode,HistFolio,Year,Period,Currency)'),

(FuncExample:#09'EntLibVer'),

(FuncExample:#09'EntStkBudget (Company,StockCode,Year,Period,Currency)'),
(FuncExample:#09'EntStkCost (Company,StockCode,Year,Period,Currency)'),
(FuncExample:#09'EntStkMargin (Company,StockCode,Year,Period,Currency)'),
(FuncExample:#09'EntStkPosted (Company,StockCode,Year,Period,Currency)'),
(FuncExample:#09'EntStkQty (Company,StockCode)'),
(FuncExample:#09'EntStkQtySold (Company,StockCode,Year,Period,Currency)'),
(FuncExample:#09'EntStkSales (Company,StockCode,Year,Period,Currency)'),

(FuncExample:#09'EntStkLocBudget (Company,StockCode,Year,Period,Currency,Location)'),
(FuncExample:#09'EntStkLocCost (Company,StockCode,Year,Period,Currency,Location)'),
(FuncExample:#09'EntStkLocMargin (Company,StockCode,Year,Period,Currency,Location)'),
(FuncExample:#09'EntStkLocPosted (Company,StockCode,Year,Period,Currency,Location)'),
(FuncExample:#09'EntStkLocQty (Company,StockCode,Location)'),
(FuncExample:#09'EntStkLocQtySold (Company,StockCode,Year,Period,Currency,Location)'),
(FuncExample:#09'EntStkLocSales (Company,StockCode,Year,Period,Currency,Location)'),

(FuncExample:#09'EntStkStr (Company,StockCode,Location,Field)'),
(FuncExample:#09'EntStkInteger (Company,StockCode,Location,Field,SalesBand)'),
(FuncExample:#09'EntStkDouble (Company,StockCode,Location,Field,SalesBand)'),

(FuncExample:#09'EntAccountStr (Company,AccountCode,AccountType,Field)'),
(FuncExample:#09'EntAccountInteger (Company,AccountCode,AccountType,Field)'),
(FuncExample:#09'EntAccountDouble (Company,AccountCode,AccountType,Field)'),

(FuncExample:#09'EntCCDepName (Company,CCDepType,CCDepCode)'),
(FuncExample:#09'EntJobStr (Company,JobCode,Field)'),
(FuncExample:#09'EntLocationName (Company,LocCode)'),
(FuncExample:#09'EntCurrencyName (Company,CurrCode)'),
(FuncExample:#09'EntJobInteger (Company,JobCode,Field)'),
(FuncExample:#09'EntJobDouble (Company,JobCode,Field)'),
(FuncExample:#09'EntAnalDesc (Company,AnalCode)'),

(FuncExample:#09'EntCustStkQty (Company,CustCode,StockCode,Currency,Year,Period,CostCentre,Dept,LocCode)'),
(FuncExample:#09'EntCustStkSales (Company,CustCode,StockCode,Currency,Year,Period,CostCentre,Dept,LocCode)'),

(FuncExample:#09'EntDailyRate (Company,CurrCode)'),
(FuncExample:#09'EntCompanyRate (Company,CurrCode)'),

(FuncExample:#09'EntDefaultLogin (UserID,Password)'),

(FuncExample:nil)
);


//Function definitions -
//The FuncDefString is the function declaration (like C - first is the return value,
//     then the function name and then the parameters in brackets
//The UFEntry is a pointer to our function.
//The UFMemCalcFunc is eventually implemented to return the size of the return value

const FunctionDefStrings : array [1..NumFunctions+1] of UFFunctionDefStrings =
(
(FuncDefString:'String EntConvertDate (String)';UFEntry:ConvertDate;UFMemCalcFunc: nil),

(FuncDefString:'Number EntCustBalance (String,String,Number,Number)';UFEntry:GetCustBalance;UFMemCalcFunc: nil),
(FuncDefString:'Number EntCustBudget (String,String,Number,Number)';UFEntry:GetCustBudget;UFMemCalcFunc: nil),
(FuncDefString:'Number EntCustCosts (String,String,Number,Number)';UFEntry:GetCustCosts;UFMemCalcFunc: nil),
(FuncDefString:'Number EntCustCredits (String,String,Number,Number)';UFEntry:GetCustCredits;UFMemCalcFunc: nil),
(FuncDefString:'Number EntCustDebits (String,String,Number,Number)';UFEntry:GetCustDebits;UFMemCalcFunc: nil),
(FuncDefString:'Number EntCustMargin (String,String,Number,Number)';UFEntry:GetCustMargin;UFMemCalcFunc: nil),
(FuncDefString:'Number EntCustNetSales (String,String,Number,Number)';UFEntry:GetCustNetSales;UFMemCalcFunc: nil),

(FuncDefString:'Number EntDocSign(String)';UFEntry:DocSign;UFMemCalcFunc: nil),
(FuncDefString:'Number EntDouble (Number, Number)';UFEntry:ConvertIToD;UFMemCalcFunc: nil),

(FuncDefString:'Number EntGLActual (String,Number,Number,Number,Number)';UFEntry:GetGLActual;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLBudget (String,Number,Number,Number,Number)';UFEntry:GetGLBudget;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLBudget2 (String,Number,Number,Number,Number)';UFEntry:GetGLBudget2;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLCredit (String,Number,Number,Number,Number)';UFEntry:GetGLCredit;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLDebit (String,Number,Number,Number,Number)';UFEntry:GetGLDebit;UFMemCalcFunc: nil),

(FuncDefString:'Number EntGLComActual (String,Number,Number,Number,Number)';UFEntry:GetGLComActual;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLComCredit (String,Number,Number,Number,Number)';UFEntry:GetGLComCredit;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLComDebit (String,Number,Number,Number,Number)';UFEntry:GetGLComDebit;UFMemCalcFunc: nil),

(FuncDefString:'Number EntGLCCActual (String,Number,Number,Number,Number,String)';UFEntry:GetGLCCActual;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLCCBudget (String,Number,Number,Number,Number,String)';UFEntry:GetGLCCBudget;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLCCBudget2 (String,Number,Number,Number,Number,String)';UFEntry:GetGLCCBudget2;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLCCCredit (String,Number,Number,Number,Number,String)';UFEntry:GetGLCCCredit;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLCCDebit (String,Number,Number,Number,Number,String)';UFEntry:GetGLCCDebit;UFMemCalcFunc: nil),

(FuncDefString:'Number EntGLCCComActual (String,Number,Number,Number,Number,String)';UFEntry:GetGLCCComActual;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLCCComCredit (String,Number,Number,Number,Number,String)';UFEntry:GetGLCCComCredit;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLCCComDebit (String,Number,Number,Number,Number,String)';UFEntry:GetGLCCComDebit;UFMemCalcFunc: nil),

(FuncDefString:'Number EntGLDpActual (String,Number,Number,Number,Number,String)';UFEntry:GetGLDpActual;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLDpBudget (String,Number,Number,Number,Number,String)';UFEntry:GetGLDpBudget;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLDpBudget2 (String,Number,Number,Number,Number,String)';UFEntry:GetGLDpBudget2;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLDpCredit (String,Number,Number,Number,Number,String)';UFEntry:GetGLDpCredit;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLDpDebit (String,Number,Number,Number,Number,String)';UFEntry:GetGLDpDebit;UFMemCalcFunc: nil),

(FuncDefString:'Number EntGLDpComActual (String,Number,Number,Number,Number,String)';UFEntry:GetGLDpComActual;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLDpComCredit (String,Number,Number,Number,Number,String)';UFEntry:GetGLDpComCredit;UFMemCalcFunc: nil),
(FuncDefString:'Number EntGLDpComDebit (String,Number,Number,Number,Number,String)';UFEntry:GetGLDpComDebit;UFMemCalcFunc: nil),

(FuncDefString:'Number EntJBudget (String,String,Number,Number,Number,Number)';UFEntry:GetJBBudget;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJBudgetActQty (String,String,Number,Number,Number,Number)';UFEntry:GetJBActualQty;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJBudgetActual (String,String,Number,Number,Number,Number)';UFEntry:GetJBActual;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJBudgetQty (String,String,Number,Number,Number,Number)';UFEntry:GetJBQuantity;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJBudgetRev (String,String,Number,Number,Number,Number)';UFEntry:GetJBRevBudget;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJBudgetRevQty (String,String,Number,Number,Number,Number)';UFEntry:GetJBRevBudgQty;UFMemCalcFunc: nil),
(FuncDefString:'String EntJCCatDesc (String,Number)';UFEntry:GetJCCatDesc;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJComBudget (String,String,Number,Number,Number,Number)';UFEntry:GetJCBudget;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJComBudgetActual (String,String,Number,Number,Number,Number)';UFEntry:GetJCActual;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJComBudgetRev (String,String,Number,Number,Number,Number)';UFEntry:GetJCRevBudget;UFMemCalcFunc: nil),

(FuncDefString:'String EntLibVer';UFEntry:GetLibVers;UFMemCalcFunc: nil),

(FuncDefString:'Number EntStkBudget (String,String,Number,Number,Number)';UFEntry:GetStkBudget;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkCosts (String,String,Number,Number,Number)';UFEntry:GetStkCosts;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkMargin (String,String,Number,Number,Number)';UFEntry:GetStkMargin;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkPosted (String,String,Number,Number,Number)';UFEntry:GetStkPosted;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkQty (String,String)';UFEntry:GetStockQty;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkQtySold (String,String,Number,Number,Number)';UFEntry:GetStkQtySold;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkSales (String,String,Number,Number,Number)';UFEntry:GetStkSales;UFMemCalcFunc: nil),

(FuncDefString:'Number EntStkLocBudget (String,String,Number,Number,Number,String)';UFEntry:GetStkLocBudget;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkLocCosts (String,String,Number,Number,Number,String)';UFEntry:GetStkLocCosts;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkLocMargin (String,String,Number,Number,Number,String)';UFEntry:GetStkLocMargin;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkLocPosted (String,String,Number,Number,Number,String)';UFEntry:GetStkLocPosted;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkLocQty (String,String,String)';UFEntry:GetStockLocQty;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkLocQtySold (String,String,Number,Number,Number,String)';UFEntry:GetStkLocQtySold;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkLocSales (String,String,Number,Number,Number,String)';UFEntry:GetStkLocSales;UFMemCalcFunc: nil),

(FuncDefString:'String EntStkStr (String,String,String,Number)';UFEntry:GetStockString;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkInteger (String,String,String,Number,String)';UFEntry:GetStockInt;UFMemCalcFunc: nil),
(FuncDefString:'Number EntStkDouble (String,String,String,Number,String)';UFEntry:GetStockDbl;UFMemCalcFunc: nil),

(FuncDefString:'String EntAccountStr (String,String,String,Number)';UFEntry:GetAccountString;UFMemCalcFunc: nil),
(FuncDefString:'Number EntAccountInteger (String,String,String,Number)';UFEntry:GetAccountInt;UFMemCalcFunc: nil),
(FuncDefString:'Number EntAccountDouble (String,String,String,Number)';UFEntry:GetAccountDbl;UFMemCalcFunc: nil),

(FuncDefString:'String EntCCDepName (String,String,String)';UFEntry:GetCCDepName;UFMemCalcFunc: nil),
(FuncDefString:'String EntJobStr (String,String,Number)';UFEntry:GetJobString;UFMemCalcFunc: nil),
(FuncDefString:'String EntLocationName (String,String)';UFEntry:GetLocationName;UFMemCalcFunc: nil),
(FuncDefString:'String EntCurrencyName (String,Number)';UFEntry:GetCurrencyName;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJobInteger (String,String,Number)';UFEntry:GetJobInt;UFMemCalcFunc: nil),
(FuncDefString:'Number EntJobDouble (String,String,Number)';UFEntry:GetJobDbl;UFMemCalcFunc: nil),
(FuncDefString:'String EntAnalDesc (String,String)';UFEntry:GetAnalDesc;UFMemCalcFunc: nil),

(FuncDefString:'Number EntCustStkQty (String,String,String,Number,Number,Number,String,String,String)';UFEntry:GetCustStkQty;UFMemCalcFunc: nil),
(FuncDefString:'Number EntCustStkSales (String,String,String,Number,Number,Number,String,String,String)';UFEntry:GetCustStkSales;UFMemCalcFunc: nil),

(FuncDefString:'Number EntDailyRate (String,Number)';UFEntry:GetDailyRate;UFMemCalcFunc: nil),
(FuncDefString:'Number EntCompanyRate (String,Number)';UFEntry:GetCompanyRate;UFMemCalcFunc: nil),

(FuncDefString:'Number EntDefaultLogin (String,String)';UFEntry:DefaultLogin;UFMemCalcFunc: nil),

(FuncDefString:nil;UFEntry:nil;UFMemCalcFunc: nil)
);


ErrorTable : array [0..38] of PChar =
(
 'No Error',
 'Unknown Error',
 'Invalid Nominal/General Ledger Code',
 'Invalid Year',
 'Invalid Period',
 'Invalid Currency Number',
 'Invalid Customer Code',
 'Invalid Company Code',
 'Invalid From GL Code',
 'Invalid To GL Code',
 'Invalid Cost Centre Code',
 'Invalid Department Code',
 'Invalid Job Code',
 'Invalid Job Analysis',
 'Invalid Stock Code',
 'Invalid Price Band',
 'Invalid Value',
 'Invalid Supplier',
 'Invalid Location',
 'Permission Denied - User not authorised to use this function',
 'Record Locked',
 'Btrieve Error',
 'Range Check Error converting to 2-Byte Integer',
 'Range Check Error converting to 4-Byte Integer',
 'Invalid Document Type',

 'Invalid Budget Type',
 'Invalid Rate Type',
 'Invalid Start Date',
 'Invalid End Date',
 'Invalid Account Code',
 'Unknown Error',
 'Aborted By User',
 'Invalid Ageing Date',
 'Invalid Quantity',
 'Invalid Aging Units',
 'Invalid Ageing Interval',
 'Invalid Line Number',
 'Exchequer OLE Server Error',
 'Invalid Account Type'
);

//Initializations for a job - will be called by Crystal
procedure InitForJob (jobId : Integer);

//cleanup for a job - will be called by Crystal
procedure TermForJob (jobId : Integer);

implementation

Uses History;

Var
  DoneOnce : Boolean;

Function DoubleToInt2 (Const TheDub : Double;
                       Var   Int2   : SmallInt) : SmallInt; StdCall; External 'EntFuncs.Dll';
Function DoubleToInt4 (Const TheDub : Double;
                       Var   Int4   : LongInt) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntVersion : ShortString; StdCall; External 'EntFuncs.Dll';

Function EntConvertInts (Const Int2 : SmallInt;
                         Const Int4 : LongInt) : Double; StdCall; External 'EntFuncs.Dll';

Function EntDocSign (Const DocType : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntCustValue(Const WantValue : SmallInt;
                      Const Company   : ShortString;
                      Const CustCode  : ShortString;
                      Const Year      : SmallInt;
                      Const Period    : SmallInt;
                      Var   CustBal   : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntGLValue(Const WantValue : SmallInt;
                    Const SubType   : SmallInt;
                    Const Company   : ShortString;
                    Const GLCode    : LongInt;
                    Const Year      : SmallInt;
                    Const Period    : SmallInt;
                    Const Currency  : SmallInt;
                    Const CCDep     : ShortString;
                    Const Committed : SmallInt;
                    Var   GLBal     : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntStockValue(Const WantValue : SmallInt;
                       Const Company   : ShortString;
                       Const StkCode   : ShortString;
                       Const LocCode   : ShortString;
                       Const Year      : SmallInt;
                       Const Period    : SmallInt;
                       Const Currency  : SmallInt;
                       Var   StkBal    : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntJCSummCat(Const WantValue : SmallInt;
                      Const Company   : ShortString;
                      Var   TotalStr  : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntJobBudgetValue(Const WantValue : SmallInt;
                           Const Company   : ShortString;
                           Const JobCode   : ShortString;
                           Const HistFolio : LongInt;
                           Const Year      : SmallInt;
                           Const Period    : SmallInt;
                           Const Currency  : SmallInt;
                           Const Commit    : WordBool;
                           Var   HistVal   : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntStockQty (Const Company   : ShortString;
                      Const StockCode : ShortString;
                      Const LocCode   : ShortString;
                      Var   HistVal   : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntStockStr(Const Company   : ShortString;
                     Const StkCode   : ShortString;
                     Const LocCode   : ShortString;
                     Const ValueIdx  : SmallInt;
                       Var ReturnStr : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntStockInt(Const Company   : ShortString;
                     Const StkCode   : ShortString;
                     Const LocCode   : ShortString;
                     Const ValueIdx  : SmallInt;
                     Const SalesBand : ShortString;
                       Var ReturnInt : LongInt) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntStockVal(Const Company   : ShortString;
                     Const StkCode   : ShortString;
                     Const LocCode   : ShortString;
                     Const ValueIdx  : SmallInt;
                     Const SalesBand : ShortString;
                       Var ReturnVal : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntAccountStr(Const Company   : ShortString;
                       Const AcCode    : ShortString;
                       Const AcType    : ShortString;
                       Const ValueIdx  : SmallInt;
                       Var   ReturnStr : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntAccountInt(Const Company   : ShortString;
                       Const AcCode    : ShortString;
                       Const AcType    : ShortString;
                       Const ValueIdx  : SmallInt;
                       Var   ReturnInt : longint) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntAccountVal(Const Company   : ShortString;
                       Const AcCode    : ShortString;
                       Const AcType    : ShortString;
                       Const ValueIdx  : SmallInt;
                       Var   ReturnDbl : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntCCDepName(Const Company  : ShortString;
                      Const CCDpType : ShortString;
                      Const CCDpCode : ShortString;
                      Var   CCDpName : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';

function EntJobStr(const Company : ShortString;
                   const JobCode : ShortString;
                   const ValueIdx : SmallInt;
                   var   ReturnStr : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';

function EntLocationName(const Company : ShortString;
                         const LocCode : ShortString;
                         var   LocName : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';

function EntCurrencyName(const Company  : ShortString;
                         const CurrCode : SmallInt;
                         var   CurrName : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntJobInt(Const Company   : ShortString;
                   Const JobCode   : ShortString;
                   Const ValueIdx  : SmallInt;
                   Var   ReturnInt : longint) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntJobVal(Const Company   : ShortString;
                   Const JobCode   : ShortString;
                   Const ValueIdx  : SmallInt;
                   Var   ReturnDbl : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

function EntAnalDesc(const Company  : ShortString;
                     const AnalCode : ShortString;
                     var   AnalDesc : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';

function EntCustStkQty(Const Company    : ShortString;
                       Const CustCode   : ShortString;
                       Const StkCode    : ShortString;
                       Const Currency   : SmallInt;
                       Const Year       : SmallInt;
                       Const Period     : SmallInt;
                       Const CostCentre : ShortString;
                       Const Dept       : ShortString;
                       Const LocCode    : ShortString;
                       Var   ReturnVal  : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

function EntCustStkSales(Const Company    : ShortString;
                         Const CustCode   : ShortString;
                         Const StkCode    : ShortString;
                         Const Currency   : SmallInt;
                         Const Year       : SmallInt;
                         Const Period     : SmallInt;
                         Const CostCentre : ShortString;
                         Const Dept       : ShortString;
                         Const LocCode    : ShortString;
                         Var   ReturnVal  : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

function EntCurrencyValue(Const ValueReq : SmallInt;
                          Const Company  : ShortString;
                          Const Currency : SmallInt;
                            var ReturnVal : Double) : SmallInt; StdCall; External 'EntFuncs.Dll';

Function EntDefaultLogin (Const UserId : ShortString;
                          Const PWord  : ShortString) : SmallInt; StdCall; External 'EntFuncs.Dll';








{ Initializations for a job }
procedure InitForJob (jobId : Integer);
begin
  { Dummy procedure required by Crystal Reports }
end;


{ cleanup for a job }
procedure TermForJob (jobId : Integer);
begin
  { Dummy procedure required by Crystal Reports }
end;


{ Translates an error returned by the OLE Server into a Crystal Error Message }
Function TransErrorCode(Const Res : SmallInt) : SmallInt;
Begin
  Case Res Of
    500      : Result := 37; { OLE Server Error }

    511      : Result := 2;  { Invalid Nominal/General Ledger Code }
    512      : Result := 3;  { Invalid Year }
    513      : Result := 4;  { Invalid Period }
    514      : Result := 5;  { Invalid Currency Number }
    515      : Result := 6;  { Invalid Customer Code }
    516      : Result := 7;  { Invalid Company Code }
    517      : Result := 8;  { Invalid From GL Code }
    518      : Result := 9;  { Invalid To GL Code }
    519      : Result := 10; { Invalid Cost Centre Code }
    520      : Result := 11; { Invalid Department Code }
    521      : Result := 12; { Invalid Job Code }
    522      : Result := 13; { Invalid Job Analysis }
    523      : Result := 14; { Invalid Stock Code }
    524      : Result := 15; { Invalid Price Band }
    525      : Result := 16; { Invalid Value }
    526      : Result := 17; { Invalid Supplier }
    527      : Result := 18; { Invalid Location }
    528      : Result := 19; { Permission Denied - User not authorised to use this function }

    530      : Result := 25; { Invalid Budget Type }
    532      : Result := 26; { Invalid Rate Type }
    534      : Result := 27; { Invalid Start Date }
    535      : Result := 28; { Invalid End Date }
    536      : Result := 29; { Invalid Account Code }
    537      : Result := 30; { Unknown Error }
    538      : Result := 31; { Aborted By User }
    539      : Result := 32; { Invalid Ageing Date }
    540      : Result := 33; { Invalid Quantity }
    541      : Result := 34; { Invalid Aging Units }
    542      : Result := 35; { Invalid Ageing Interval }
    543      : Result := 36; { Invalid Line Number }

    600      : Result := 20; { Record Locked }
    601..699 : Result := 21; { Base Error for btrieve - 601 -> }

    800      : Result := 22; { Range Check Error converting to 2-Byte Integer }
    801      : Result := 23; { Range Check Error converting to 4-Byte Integer }
  Else
    Result := 1;
  End; { Case }
End;


{------------------------------------------------------------------------------}


{ Returns the version of this library and the EntFuncs.DLL library }
function GetLibVers(ParamBlock : PUFParamBlock) : UFError; stdcall;
Var
  RetStr : ShortString;
Begin { GetLibVers }
  RetStr := 'U2L: ' + CurrVersion_U2L + ' / DLL: ' + EntVersion;

  StrPCopy(ParamBlock^.ReturnValue.ReturnString, RetStr);
  Result := UFNoError;
End; { GetLibVers }


{ Converts the 2 Integer fields of a Real into a Double }
Function ConvertIToD (ParamBlock : PUFParamBlock) : UFError;
Var
  Param1 : PUFParamListElement; //a pointer to the first parameter
  Param2 : PUFParamListElement; //a pointer to the second parameter
  dInt2, dInt4 : Double;
  Int2   : SmallInt;
  Int4   : LongInt;
  Res    : SmallInt;
Begin { ConvertIToD }
  Param1 := GetParam (ParamBlock, 1); //the first param is the string to trim
  Param2 := GetParam (ParamBlock, 2); //the second param is the character to trim

  { check if the correct number of parameters is passed to the function }
  If (Param1 <> nil) And (Param2 <> nil) Then Begin
    { Convert Double to 2-byte Integer - automatically divides by 100 }
    dInt2 := Param1^.Parameter.ParamNumber;
    Res := DoubleToInt2 (dInt2, Int2);
    If (Res = 0) Then Begin
      { Convert Double to 4-byte Integer - automatically divides by 100 }
      dInt4 := Param2^.Parameter.ParamNumber;
      Res := DoubleToInt4 (dInt4, Int4);
      If (Res = 0) Then Begin
        { Call EntFuncs.DLL to convert Integers to Double }
        ParamBlock^.ReturnValue.ReturnNumber := EntConvertInts (Int2, Int4) * 100;
        Result := UFNoError;
      End { If }
      Else Begin
        { Error converting to 2-byte integer }
        ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
        Result := UFUserError;
      End; { Else }
    End { If }
    Else Begin
      { Error converting to 2-byte integer }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { ConvertIToD }


{ Returns the sign of the document amount }
Function DocSign (ParamBlock : PUFParamBlock) : UFError;
Var
  Param1 : PUFParamListElement; //a pointer to the first parameter
  DocType : ShortString;
Begin { DocSign }
  Param1 := GetParam (ParamBlock, 1); //the first param is the string

  { check if the correct number of parameters is passed to the function }
  If (Param1 <> nil) Then Begin
    DocType := Param1^.Parameter.ParamString;
    If (Trim(DocType) <> '') Then Begin
      ParamBlock^.ReturnValue.ReturnNumber := EntDocSign (DocType) * 100;
      Result := UFNoError;

      If (ParamBlock^.ReturnValue.ReturnNumber = 0) Then Begin
        { Invalid Document Type }
        ParamBlock.ReturnValue.UFReturnUserError := 24;
        Result := UFUserError;
      End; { If }
    End { If }
    Else Begin
      { Invalid Document Type }
      ParamBlock.ReturnValue.UFReturnUserError := 24;
      Result := UFUserError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { DocSign }


{------------------------------------------------------------------------------}


{ Gets a specified customer value }
Function GetCustValue (Const WantVal    : SmallInt;
                             ParamBlock : PUFParamBlock) : UFError;
Var
  Param1, Param2, Param3, Param4 : PUFParamListElement;
  Period, Res, Year, WVal        : SmallInt;
  CustBal, TempDub               : Double;
  CompCode, CCode                : ShortString;
Begin { GetCustValue }
  Param1 := GetParam (ParamBlock, 1); { Company }
  Param2 := GetParam (ParamBlock, 2); { CustCode }
  Param3 := GetParam (ParamBlock, 3); { Year }
  Param4 := GetParam (ParamBlock, 4); { Period }

  { check if the correct number of parameters is passed to the function }
  If (Param1 <> nil) And (Param2 <> nil) And (Param3 <> nil) And (Param4 <> nil) Then Begin
    { Get Company Code }
    CompCode  := Param1^.Parameter.ParamString;

    { Get Customer Code }
    CCode  := Param2^.Parameter.ParamString;

    { Get Year }
    TempDub := Param3^.Parameter.ParamNumber;
    Res := DoubleToInt2 (TempDub, Year);

    If (Res = 0) Then Begin
      { Get Period }
      TempDub := Param4^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TempDub, Period);
    End; { If }

    If (Res = 0) Then Begin
      { Call function to get history details }
      WVal := WantVal;
      Res := EntCustValue(WVal, CompCode, CCode, Year, Period, CustBal);
    End; { If }

    If (Res = 0) Then Begin
      { AOK - Return Balance }
      ParamBlock^.ReturnValue.ReturnNumber := CustBal * 100;
      Result := UFNoError;
    End { If }
    Else Begin
      { Bummer - Return error status }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetCustValue }

{ Gets the Customer Balance for a specified Period }
Function GetCustBalance (ParamBlock : PUFParamBlock) : UFError;
Begin { GetCustBalance }
  Result := GetCustValue (0, ParamBlock);
End; { GetCustBalance }

{ Gets the Customer Net Sales for a specified Period }
function GetCustNetSales(ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetCustNetSales }
  Result := GetCustValue (1, ParamBlock);
End; { GetCustNetSales }

{ Gets the Customer Costs for a specified Period }
function GetCustCosts(ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetCustCosts }
  Result := GetCustValue (2, ParamBlock);
End; { GetCustCosts }

{ Gets the Customer Margin for a specified Period }
function GetCustMargin(ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetCustMargin }
  Result := GetCustValue (3, ParamBlock);
End; { GetCustMargin }

{ Gets the Customer Debits for a specified Period }
function GetCustDebits(ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetCustDebits }
  Result := GetCustValue (4, ParamBlock);
End; { GetCustDebits }

{ Gets the Customer Credits for a specified Period }
function GetCustCredits(ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetCustCredits }
  Result := GetCustValue (5, ParamBlock);
End; { GetCustCredits }

{ Gets the Customer Budget for a specified Period }
function GetCustBudget(ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetCustBudget }
  Result := GetCustValue (6, ParamBlock);
End; { GetCustBudget }


{------------------------------------------------------------------------------}


{ Gets a specified General Ledger History value  }
{   WantVal:   1=Budget1, 2=Budget2, 3=Actuals,  }
{              4=Debit, 5=Credit                 }
{   SubType:   0=GL, 1=GLCC, 2=GLDP              }
{   Committed: 0-Normal, 1-Committed             }
Function GetGLCOMValue (Const WantVal, SubType, Committed : SmallInt;
                              ParamBlock                  : PUFParamBlock) : UFError;
Var
  Param1, Param2, Param3, Param4, Param5, Param6 : PUFParamListElement;
  Period, Res, Year, WVal, SType, Curr, Cmit     : SmallInt;
  GLCode                                         : LongInt;
  GLBal, TempDub                                 : Double;
  CompCode, CCCode                               : ShortString;
Begin { GetGLValue }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { GLCode }
  Param3 := GetParam (ParamBlock, 3);  { Year }
  Param4 := GetParam (ParamBlock, 4);  { Period }
  Param5 := GetParam (ParamBlock, 5);  { Currency }
  If (SubType > 0) Then
    Param6 := GetParam (ParamBlock, 6) { Cost Centre / Department }
  Else
    Param6 := Param5;

  { check if the correct number of parameters is passed to the function }
  If (Param1 <> nil) And (Param2 <> nil) And (Param3 <> nil) And
     (Param4 <> nil) And (Param5 <> nil) And (Param6 <> nil) Then Begin
    { Get Company Code }
    CompCode  := Param1^.Parameter.ParamString;

    { Get GL Code }
    TempDub := Param2^.Parameter.ParamNumber;
    Res := DoubleToInt4 (TempDub, GLCode);

    If (Res = 0) Then Begin
      { Get Year }
      TempDub := Param3^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TempDub, Year);
    End; { If }

    If (Res = 0) Then Begin
      { Get Period }
      TempDub := Param4^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TempDub, Period);
    End; { If }

    If (Res = 0) Then Begin
      { Get Currency }
      TempDub := Param5^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TempDub, Curr);
    End; { If }

    If (Res = 0) And (SubType > 0) Then Begin
      { Cost Centre / Department Code }
      CCCode  := Param6^.Parameter.ParamString;
    End { If }
    Else
      CCCode := '';

    Cmit := Committed;

    If (Res = 0) Then Begin
      { Call function to get history details }
      WVal := WantVal;
      SType := SubType;
      Res := EntGLValue(WVal, SType, CompCode, GLCode, Year, Period, Curr, CCCode, Cmit, GLBal);
    End; { If }

    If (Res = 0) Then Begin
      { AOK - Return Balance }
      ParamBlock^.ReturnValue.ReturnNumber := GLBal * 100;
      Result := UFNoError;
    End { If }
    Else Begin
      { Bummer - Return error status }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetGLValue }

Function GetGLValue (Const WantVal,
                           SubType    : SmallInt;
                           ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLValue }
  Result := GetGLCOMValue(WantVal, SubType, 0, ParamBlock);
End; { GetGLValue }

{ Gets the GL Code's Budget1 value for a specified Period }
Function GetGLBudget (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLBudget1 }
  Result := GetGLValue (1, 0, ParamBlock);
End; { GetGLBudget1 }

{ Gets the GL Code's Budget2 value for a specified Period }
Function GetGLBudget2 (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLBudget2 }
  Result := GetGLValue (2, 0, ParamBlock);
End; { GetGLBudget2 }

{ Gets the GL Code's Actuals value for a specified Period }
Function GetGLActual (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLActuals }
  Result := GetGLValue (3, 0, ParamBlock);
End; { GetGLActuals }

{ Gets the GL Code's Budget2 value for a specified Period }
Function GetGLDebit (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLDebit }
  Result := GetGLValue (4, 0, ParamBlock);
End; { GetGLDebit }

{ Gets the GL Code's Budget2 value for a specified Period }
Function GetGLCredit (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLCredit }
  Result := GetGLValue (5, 0, ParamBlock);
End; { GetGLCredit }

{ Gets the GL Code's Budget1 value for a specified Period and Cost Centre }
Function GetGLCCBudget (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLCCBudget1 }
  Result := GetGLValue (1, 1, ParamBlock);
End; { GetGLCCBudget1 }

{ Gets the GL Code's Budget2 value for a specified Period and Cost Centre }
Function GetGLCCBudget2 (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLCCBudget2 }
  Result := GetGLValue (2, 1, ParamBlock);
End; { GetGLCCBudget2 }

{ Gets the GL Code's Actuals value for a specified Period and Cost Centre }
Function GetGLCCActual (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLCCActuals }
  Result := GetGLValue (3, 1, ParamBlock);
End; { GetGLCCActuals }

{ Gets the GL Code's Budget2 value for a specified Period and Cost Centre }
Function GetGLCCDebit (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLCCDebit }
  Result := GetGLValue (4, 1, ParamBlock);
End; { GetGLCCDebit }

{ Gets the GL Code's Budget2 value for a specified Period and Cost Centre }
Function GetGLCCCredit (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLCCCredit }
  Result := GetGLValue (5, 1, ParamBlock);
End; { GetGLCCCredit }

{ Gets the GL Code's Budget1 value for a specified Period and Department }
Function GetGLDpBudget (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLDpBudget }
  Result := GetGLValue (1, 2, ParamBlock);
End; { GetGLDpBudget }

{ Gets the GL Code's Budget2 value for a specified Period and Department }
Function GetGLDpBudget2 (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLDpBudget2 }
  Result := GetGLValue (2, 2, ParamBlock);
End; { GetGLDpBudget2 }

{ Gets the GL Code's Actuals value for a specified Period and Department }
Function GetGLDpActual (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLDpActuals }
  Result := GetGLValue (3, 2, ParamBlock);
End; { GetGLDpActuals }

{ Gets the GL Code's Budget2 value for a specified Period and Department }
Function GetGLDpDebit (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLDpDebit }
  Result := GetGLValue (4, 2, ParamBlock);
End; { GetGLDpDebit }

{ Gets the GL Code's Budget2 value for a specified Period and Department }
Function GetGLDpCredit (ParamBlock : PUFParamBlock) : UFError;
Begin { GetGLDpCredit }
  Result := GetGLValue (5, 2, ParamBlock);
End; { GetGLDpCredit }

{ HM 08/03/00: Added Committed functions for GL }
Function GetGLCOMActual (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetGLCOMActual }
  Result := GetGLCOMValue (3, 0, 1, ParamBlock);
End; { GetGLCOMActual }

Function GetGLCOMDebit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetGLCOMDebit }
  Result := GetGLCOMValue (4, 0, 1, ParamBlock);
End; { GetGLCOMDebit }

Function GetGLCOMCredit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetGLCOMCredit }
  Result := GetGLCOMValue (5, 0, 1, ParamBlock);
End; { GetGLCOMCredit }

Function GetGLCCCOMActual (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetGLCCCOMActual }
  Result := GetGLCOMValue (3, 1, 1, ParamBlock);
End; { GetGLCCCOMActual }

Function GetGLCCCOMDebit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetGLCCCOMDebit }
  Result := GetGLCOMValue (4, 1, 1, ParamBlock);
End; { GetGLCCCOMDebit }

Function GetGLCCCOMCredit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetGLCCCOMCredit }
  Result := GetGLCOMValue (5, 1, 1, ParamBlock);
End; { GetGLCCCOMCredit }

Function GetGLDPCOMActual (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetGLDPCOMActual }
  Result := GetGLCOMValue (3, 2, 1, ParamBlock);
End; { GetGLDPCOMActual }

Function GetGLDPCOMDebit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetGLDPCOMDebit }
  Result := GetGLCOMValue (4, 2, 1, ParamBlock);
End; { GetGLDPCOMDebit }

Function GetGLDPCOMCredit (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetGLDPCOMCredit }
  Result := GetGLCOMValue (5, 2, 1, ParamBlock);
End; { GetGLDPCOMCredit }

{------------------------------------------------------------------------------}


{ Gets a specified customer value }
Function GetStockValue (Const WantVal    : SmallInt;
                        Const IsLoc      : Boolean;
                              ParamBlock : PUFParamBlock) : UFError;
Var
  Param1, Param2, Param3, Param4, Param5, Param6 : PUFParamListElement;
  Period, Res, Year, WVal, Curr                  : SmallInt;
  StkBal, TempDub                                : Double;
  CompCode, StkCode, LocCode                     : ShortString;
Begin { GetStockValue }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Stock Code }
  Param3 := GetParam (ParamBlock, 3);  { Year }
  Param4 := GetParam (ParamBlock, 4);  { Period }
  Param5 := GetParam (ParamBlock, 5);  { Currency }
  If IsLoc Then
    Param6 := GetParam (ParamBlock, 6) { Location }
  Else
    Param6 := Param5;

  { check if the correct number of parameters is passed to the function }
  If (Param1 <> nil) And (Param2 <> nil) And (Param3 <> nil) And
     (Param4 <> nil) And (Param4 <> nil) And (Param6 <> nil) Then Begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Stock Code }
    StkCode := Param2^.Parameter.ParamString;

    { Get Year }
    TempDub := Param3^.Parameter.ParamNumber;
    Res := DoubleToInt2 (TempDub, Year);

    If (Res = 0) Then Begin
      { Get Period }
      TempDub := Param4^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TempDub, Period);
    End; { If }

    If (Res = 0) Then Begin
      { Get Currency }
      TempDub := Param5^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TempDub, Curr);
    End; { If }

    If (Res = 0) And IsLoc Then Begin
      { Cost Centre / Department Code }
      LocCode  := Param6^.Parameter.ParamString;
    End { If }
    Else
      LocCode := '';

    If (Res = 0) Then Begin
      { Call function to get history details }
      WVal := WantVal;
      Res := EntStockValue(WVal, CompCode, StkCode, LocCode, Year, Period, Curr, StkBal);
    End; { If }

    If (Res = 0) Then Begin
      { AOK - Return Balance }
      ParamBlock^.ReturnValue.ReturnNumber := StkBal * 100;
      Result := UFNoError;
    End { If }
    Else Begin
      { Bummer - Return error status }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetStockValue }

{ Gets the Stock Code's Quantity Sold value for a specified Period }
Function GetStkQtySold (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkQtySold }
  Result := GetStockValue (1, False, ParamBlock);
End; { GetStkQtySold }

{ Gets the Stock Code's Sales value for a specified Period }
Function GetStkSales (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkSales }
  Result := GetStockValue (2, False, ParamBlock);
End; { GetStkSales }

{ Gets the Stock Code's Costs value for a specified Period }
Function GetStkCosts (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkCosts }
  Result := GetStockValue (3, False, ParamBlock);
End; { GetStkCosts }

{ Gets the Stock Code's Margin value for a specified Period }
Function GetStkMargin (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkMargin }
  Result := GetStockValue (4, False, ParamBlock);
End; { GetStkMargin }

{ Gets the Stock Code's Budget value for a specified Period }
Function GetStkBudget (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkBudget }
  Result := GetStockValue (5, False, ParamBlock);
End; { GetStkBudget }

{ Gets the Stock Code's Posted Stock Level value for a specified Period and Department }
Function GetStkPosted (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkPosted }
  Result := GetStockValue (10, False, ParamBlock);
End; { GetStkPosted }


{ Gets the Stock Code's Quantity Sold value for a specified Period and location }
Function GetStkLocQtySold (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkLocQtySold }
  Result := GetStockValue (1, True, ParamBlock);
End; { GetStkLocQtySold }

{ Gets the Stock Code's Sales value for a specified Period and location }
Function GetStkLocSales (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkLocSales }
  Result := GetStockValue (2, True, ParamBlock);
End; { GetStkLocSales }

{ Gets the Stock Code's Costs value for a specified Period and location }
Function GetStkLocCosts (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkLocCosts }
  Result := GetStockValue (3, True, ParamBlock);
End; { GetStkLocCosts }

{ Gets the Stock Code's Margin value for a specified Period and location }
Function GetStkLocMargin (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkLocMargin }
  Result := GetStockValue (4, True, ParamBlock);
End; { GetStkLocMargin }

{ Gets the Stock Code's Budget value for a specified Period and location }
Function GetStkLocBudget (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkLocBudget }
  Result := GetStockValue (5, True, ParamBlock);
End; { GetStkLocBudget }

{ Gets the Stock Code's Posted Stock Level value for a specified Period and location }
Function GetStkLocPosted (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStkLocPosted }
  Result := GetStockValue (10, True, ParamBlock);
End; { GetStkLocPosted }


{------------------------------------------------------------------------------}


{ Returns a Job Costing summary Category Description }
function GetJCCatDesc(ParamBlock : PUFParamBlock) : UFError; stdcall;
Var
  Param1   : PUFParamListElement; //a pointer to the first parameter
  Param2   : PUFParamListElement; //a pointer to the second parameter
  dInt2    : Double;
  Int2     : SmallInt;
  Res      : SmallInt;
  CompCode, RetStr : ShortString;
Begin { ConvertIToD }
  Param1 := GetParam (ParamBlock, 1); //the first param is the company
  Param2 := GetParam (ParamBlock, 2); //the second param is the description number

  { check if the correct number of parameters is passed to the function }
  If (Param1 <> nil) And (Param2 <> nil) Then Begin
    { Convert Double to 2-byte Integer - automatically divides by 100 }
    dInt2 := Param2^.Parameter.ParamNumber;
    Res := DoubleToInt2 (dInt2, Int2);
    If (Res = 0) Then Begin
      { Get Company Code }
      CompCode := Param1^.Parameter.ParamString;

      { call description function }
      Res := EntJCSummCat(Int2, CompCode, RetStr);
      If (Res = 0) Then Begin
        { Got String }
        StrPCopy(ParamBlock^.ReturnValue.ReturnString, RetStr);
        Result := UFNoError;
      End { If }
      Else Begin
        { Error converting to 2-byte integer }
        ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
        Result := UFUserError;
      End; { Else }
    End { If }
    Else Begin
      { Error converting to 2-byte integer }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetJCCatDesc }


{ Gets a specified customer value }
Function GetJobBudgetValue (Const WantVal    : SmallInt;
                            Const Commit     : Boolean;
                                  ParamBlock : PUFParamBlock) : UFError;
Var
  Param1, Param2, Param3, Param4, Param5, Param6 : PUFParamListElement;
  Period, Res, Year, WVal, Curr                  : SmallInt;
  HistBal, TempDub                               : Double;
  CompCode, JobCode                              : ShortString;
  HistFolio                                      : LongInt;
  Committed                                      : WordBool;
Begin { GetJobBudgetValue }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Job Code }
  Param3 := GetParam (ParamBlock, 3);  { History Folio }
  Param4 := GetParam (ParamBlock, 4);  { Year }
  Param5 := GetParam (ParamBlock, 5);  { Period }
  Param6 := GetParam (ParamBlock, 6);  { Currency }

  { check if the correct number of parameters is passed to the function }
  If (Param1 <> nil) And (Param2 <> nil) And (Param3 <> nil) And
     (Param4 <> nil) And (Param4 <> nil) And (Param6 <> nil) Then Begin
    { Set Committed }
    Committed := Commit;

    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Job Code }
    JobCode := Param2^.Parameter.ParamString;

    { Get History Folio - Convert Double to 4-byte Integer - automatically divides by 100 }
    TempDub := Param3^.Parameter.ParamNumber;
    Res := DoubleToInt4 (TempDub, HistFolio);

    If (Res = 0) Then Begin
      { Get Year }
      TempDub := Param4^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TempDub, Year);
    End; { If }

    If (Res = 0) Then Begin
      { Get Period }
      TempDub := Param5^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TempDub, Period);
    End; { If }

    If (Res = 0) Then Begin
      { Get Currency }
      TempDub := Param6^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TempDub, Curr);
    End; { If }

    If (Res = 0) Then Begin
      { Call function to get history details }
      WVal := WantVal;
      Res := EntJobBudgetValue(WVal, CompCode, JobCode, HistFolio, Year, Period, Curr, Committed, HistBal);
    End; { If }

    If (Res = 0) Then Begin
      { AOK - Return Balance }
      ParamBlock^.ReturnValue.ReturnNumber := HistBal * 100;
      Result := UFNoError;
    End { If }
    Else Begin
      { Bummer - Return error status }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetJobBudgetValue }


{ Gets the Job Budgets' Budget Quantity value for a specified Period }
Function GetJBQuantity (ParamBlock : PUFParamBlock) : UFError;
Begin { GetJBQuantity }
  Result := GetJobBudgetValue (1, False, ParamBlock);
End; { GetJBQuantity }

{ Gets the Job Budgets' Budget value for a specified Period }
Function GetJBBudget (ParamBlock : PUFParamBlock) : UFError;
Begin { GetJBBudget }
  Result := GetJobBudgetValue (2, False, ParamBlock);
End; { GetJBBudget }

{ Gets the Job Budgets' Revised Budget Quantity value for a specified Period }
Function GetJBRevBudgQty (ParamBlock : PUFParamBlock) : UFError;
Begin { GetJBRevBudgQty }
  Result := GetJobBudgetValue (3, False, ParamBlock);
End; { GetJBRevBudgQty }

{ Gets the Job Budgets' Revised Budget value for a specified Period }
Function GetJBRevBudget (ParamBlock : PUFParamBlock) : UFError;
Begin { GetJBRevBudget }
  Result := GetJobBudgetValue (4, False, ParamBlock);
End; { GetJBRevBudget }

{ Gets the Job Budgets' Actual Quantity value for a specified Period }
Function GetJBActualQty (ParamBlock : PUFParamBlock) : UFError;
Begin { GetJBActualQty }
  Result := GetJobBudgetValue (5, False, ParamBlock);
End; { GetJBActualQty }

{ Gets the Job Budgets' Actual value for a specified Period }
Function GetJBActual (ParamBlock : PUFParamBlock) : UFError;
Begin { GetJBActual }
  Result := GetJobBudgetValue (6, False, ParamBlock);
End; { GetJBActual }


{ Gets the Job Budgets' Budget value for a specified Period }
Function GetJCBudget (ParamBlock : PUFParamBlock) : UFError;
Begin { GetJCBudget }
  Result := GetJobBudgetValue (2, True, ParamBlock);
End; { GetJCBudget }

{ Gets the Job Budgets' Revised Budget value for a specified Period }
Function GetJCRevBudget (ParamBlock : PUFParamBlock) : UFError;
Begin { GetJCRevBudget }
  Result := GetJobBudgetValue (4, True, ParamBlock);
End; { GetJCRevBudget }

{ Gets the Job Budgets' Actual value for a specified Period }
Function GetJCActual (ParamBlock : PUFParamBlock) : UFError;
Begin { GetJCActual }
  Result := GetJobBudgetValue (6, True, ParamBlock);
End; { GetJCActual }


Function ConvertDate (ParamBlock : PUFParamBlock) : UFError;
Var
  Param1  : PUFParamListElement;
  DateStr : ShortString;
  RetStr  : String;
Begin { ConvertDate }
  { Extract Date Parameter }
  Param1 := GetParam (ParamBlock, 1);
  DateStr := Param1^.Parameter.ParamString;

  { Reformat date }
  RetStr := Copy (DateStr, 7, 2) + '/' +
            Copy (DateStr, 5, 2) + '/' +
            Copy (DateStr, 1, 4);

  { return date string }
  StrPCopy(ParamBlock^.ReturnValue.ReturnString, RetStr);
  Result := UFNoError;
End; { ConvertDate }


{-----------------------------------------------------------------------------}


{ Gets a specified integer value from the stock/loc record }
Function GetStkLocQty (Const IsLoc      : Boolean;
                             ParamBlock : PUFParamBlock) : UFError;
Var
  Param1, Param2, Param3        : PUFParamListElement;
  StkBal                        : Double;
  CompCode, StkCode, LocCode    : ShortString;
  Res                           : SmallInt;
Begin { GetStockValue }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Stock Code }
  If IsLoc Then
    Param3 := GetParam (ParamBlock, 3) { Location }
  Else
    Param3 := Param2;

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) And Assigned(Param3) Then Begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Stock Code }
    StkCode := Param2^.Parameter.ParamString;

    If IsLoc Then Begin
      { Cost Centre / Department Code }
      LocCode  := Param3^.Parameter.ParamString;
    End { If IsLoc }
    Else Begin
      LocCode  := '';
    End; { Else }

    { Call function to get details }
    Res := EntStockQty (CompCode, StkCode, LocCode, StkBal);

    If (Res = 0) Then Begin
      { AOK - Return Balance }
      ParamBlock^.ReturnValue.ReturnNumber := StkBal * 100;
      Result := UFNoError;
    End { If }
    Else Begin
      { Bummer - Return error status }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetStockValue }

Function GetStockQty (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStockQty }
  Result := GetStkLocQty (False, ParamBlock);
End; { GetStockQty }

Function GetStockLocQty (ParamBlock : PUFParamBlock) : UFError; stdcall;
Begin { GetStockLocQty }
  Result := GetStkLocQty (True, ParamBlock);
End; { GetStockLocQty }

{----------------------------------------------------------------------------}

Function GetStockString (ParamBlock : PUFParamBlock) : UFError;
Var
  Param1, Param2, Param3, Param4     : PUFParamListElement;
  CompCode, StkCode, LocCode, StkStr : ShortString;
  Res, FIdx                          : SmallInt;
  TmpDub                             : Double;
Begin { GetStockString }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Stock Code }
  Param3 := GetParam (ParamBlock, 3);  { Location }
  Param4 := GetParam (ParamBlock, 4);  { Field Idx }

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) And Assigned(Param3) And Assigned(Param4) Then Begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Stock Code }
    StkCode := Param2^.Parameter.ParamString;
    If (Trim(StkCode) <> '') Then Begin
      { Get Location Code }
      LocCode  := Param3^.Parameter.ParamString;

      { Get Field Index }
      TmpDub := Param4^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TmpDub, FIdx);
      If (Res = 0) Then Begin
        { Call function to get details }
        Res := EntStockStr(CompCode, StkCode, LocCode, FIdx, StkStr);

        If (Res = 0) Then Begin
          { AOK - Return String }
          StrPCopy (ParamBlock^.ReturnValue.ReturnString, StkStr);
          Result := UFNoError;
        End { If }
        Else Begin
          If (Res = 523) Then Begin
            { Bummer - Invalid Stock Code - Return blank string }
            ParamBlock^.ReturnValue.ReturnString := '';
            Result := UFNoError;
          End { If }
          Else Begin
            { Bummer - Return error status }
            ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
            Result := UFUserError;
          End; { Else }
        End; { Else }
      End { If }
      Else Begin
        { Bummer - Return error status }
        ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
        Result := UFUserError;
      End; { Else }
    End { If }
    Else Begin
      { No Stock Code - Return Empty String }
      ParamBlock^.ReturnValue.ReturnString := '';
      Result := UFNoError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetStockString }

{----------------------------------------------------------------------------}

Function GetStockNumber (ParamBlock : PUFParamBlock; IsInt : Boolean) : UFError;
Var
  Param1, Param2, Param3, Param4, Param5    : PUFParamListElement;
  CompCode, StkCode, LocCode, SBand         : ShortString;
  Res, FIdx                                 : SmallInt;
  StkDbl, TmpDub                            : Double;
  StkInt                                    : LongInt;

  Procedure SetResult (IntRes : LongInt; DblRes : Double);
  Begin { SetResult }
    If IsInt Then
      ParamBlock^.ReturnValue.ReturnNumber := IntRes * 100
    Else
      ParamBlock^.ReturnValue.ReturnNumber := DblRes * 100;
  End; { SetResult }

Begin { GetStockInt }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Stock Code }
  Param3 := GetParam (ParamBlock, 3);  { Location }
  Param4 := GetParam (ParamBlock, 4);  { Field Idx }
  Param5 := GetParam (ParamBlock, 5);  { Sales Band }

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) And Assigned(Param3) And Assigned(Param4) And Assigned(Param5) Then Begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Stock Code }
    StkCode := Param2^.Parameter.ParamString;
    If (Trim(StkCode) <> '') Then Begin
      { Get Location Code }
      LocCode  := Param3^.Parameter.ParamString;

      { Get Field Index }
      TmpDub := Param4^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TmpDub, FIdx);
      If (Res = 0) Then Begin
        { Get Sales Band }
        SBand := Param5^.Parameter.ParamString;

        { Call function to get details }
        If IsInt Then
          Res := EntStockInt(CompCode, StkCode, LocCode, FIdx, SBand, StkInt)
        Else
          Res := EntStockVal(CompCode, StkCode, LocCode, FIdx, SBand, StkDbl);

        If (Res = 0) Then Begin
          { AOK - Return String }
          SetResult (StkInt, StkDbl);
          Result := UFNoError;
        End { If }
        Else Begin
          If (Res = 523) Then Begin
            { Bummer - Invalid Stock Code - Return blank string }
            SetResult (0, 0);
            Result := UFNoError;
          End { If }
          Else Begin
            { Bummer - Return error status }
            ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
            Result := UFUserError;
          End; { Else }
        End; { Else }
      End { If }
      Else Begin
        { Bummer - Return error status }
        ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
        Result := UFUserError;
      End; { Else }
    End { If }
    Else Begin
      { No Stock Code - Return Empty String }
      SetResult (0, 0);
      Result := UFNoError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetStockInt }

Function GetStockInt (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStockInt }
  Result := GetStockNumber(ParamBlock, True);
End; { GetStockInt }

Function GetStockDbl (ParamBlock : PUFParamBlock) : UFError;
Begin { GetStockDbl }
  Result := GetStockNumber(ParamBlock, False);
End; { GetStockDbl }

{----------------------------------------------------------------------------}

{ HM 08/03/01: Added Customer String interface to shutup some Irish gits }
Function GetAccountString (ParamBlock : PUFParamBlock) : UFError; stdcall;
Var
  Param1, Param2, Param3, Param4   : PUFParamListElement;
  CompCode, AcCode, AcType, AcStr  : ShortString;
  Res, FIdx                        : SmallInt;
  TmpDub                           : Double;
Begin { GetAccountString }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Account Code }
  Param3 := GetParam (ParamBlock, 3);  { Account Type }
  Param4 := GetParam (ParamBlock, 4);  { Field Idx }

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) And Assigned(Param3) And Assigned(Param4) Then Begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Account Code }
    AcCode := Param2^.Parameter.ParamString;
    If (Trim(AcCode) <> '') Then Begin
      { Get Account Type character }
      AcType := Param3^.Parameter.ParamString;
      If (Trim(AcType) = 'C') Or (Trim(AcType) = 'S') Then Begin
        { Get Field Index }
        TmpDub := Param4^.Parameter.ParamNumber;
        Res := DoubleToInt2 (TmpDub, FIdx);
        If (Res = 0) Then Begin
          { Call function to get details }
          Res := EntAccountStr(CompCode, AcCode, AcType, FIdx, AcStr);

          If (Res = 0) Then Begin
            { AOK - Return String }
            StrPCopy (ParamBlock^.ReturnValue.ReturnString, AcStr);
            Result := UFNoError;
          End { If }
          Else Begin
            If (Res = 515) Or (Res = 526) Then Begin
              { Bummer - Invalid Customer or Supplier Code - Return blank string }
              ParamBlock^.ReturnValue.ReturnString := '';
              Result := UFNoError;
            End { If }
            Else Begin
              { Bummer - Return error status }
              ParamBlock.ReturnValue.UFReturnUserError := 38;
              Result := UFUserError;
            End; { Else }
          End; { Else }
        End { If }
        Else Begin
          { Bummer - Return error status }
          ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
          Result := UFUserError;
        End; { Else }
      End { If (Trim(AcType) = 'C') Or (Trim(AcType) = 'S') }
      Else Begin
        { Invalid Account Type }
        ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
        Result := UFUserError;
      End; { Else }
    End { If }
    Else Begin
      { No Account Code - Return Empty String }
      ParamBlock^.ReturnValue.ReturnString := '';
      Result := UFNoError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetAccountString }

{----------------------------------------------------------------------------}

Function GetAccountNumber (ParamBlock : PUFParamBlock; IsInt : Boolean) : UFError; stdcall;
Var
  Param1, Param2, Param3, Param4   : PUFParamListElement;
  CompCode, AcCode, AcType, AcStr  : ShortString;
  Res, FIdx                        : SmallInt;
  TmpDub, ResDub                   : Double;
  ResInt                           : longint;

  Procedure SetResult (IntRes : LongInt; DblRes : Double);
  Begin { SetResult }
    If IsInt Then
      ParamBlock^.ReturnValue.ReturnNumber := IntRes * 100
    Else
      ParamBlock^.ReturnValue.ReturnNumber := DblRes * 100;
  End; { SetResult }

Begin { GetAccountInt }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Account Code }
  Param3 := GetParam (ParamBlock, 3);  { Account Type }
  Param4 := GetParam (ParamBlock, 4);  { Field Idx }

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) And Assigned(Param3) And Assigned(Param4) Then Begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Account Code }
    AcCode := Param2^.Parameter.ParamString;
    If (Trim(AcCode) <> '') Then Begin
      { Get Account Type character }
      AcType := Param3^.Parameter.ParamString;
      If (Trim(AcType) = 'C') Or (Trim(AcType) = 'S') Then Begin
        { Get Field Index }
        TmpDub := Param4^.Parameter.ParamNumber;
        Res := DoubleToInt2 (TmpDub, FIdx);
        If (Res = 0) Then Begin
          { Call function to get details }

          Case IsInt of
            True :
               Res := EntAccountInt(CompCode, AcCode, AcType, FIdx, ResInt);
            False :
               Res := EntAccountVal(CompCode, AcCode, AcType, FIdx, ResDub);
          end; //Case

          If (Res = 0) Then Begin
            { AOK - Return String }
            SetResult(ResInt, ResDub);
            Result := UFNoError;
          End { If }
          Else Begin
            If (Res = 515) Or (Res = 526) Then Begin
              { Bummer - Invalid Customer or Supplier Code - Return blank string }
              ParamBlock^.ReturnValue.UFReturnUserError := TransErrorCode(Res);
              Result := UFNoError;
            End { If }
            Else Begin
              { Bummer - Return error status }
              ParamBlock.ReturnValue.UFReturnUserError := 38;
              Result := UFUserError;
            End; { Else }
          End; { Else }
        End { If }
        Else Begin
          { Bummer - Return error status }
          ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
          Result := UFUserError;
        End; { Else }
      End { If (Trim(AcType) = 'C') Or (Trim(AcType) = 'S') }
      Else Begin
        { Invalid Account Type }
        ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
        Result := UFUserError;
      End; { Else }
    End { If }
    Else Begin
      { No Account Code - Return Empty String }
      ParamBlock^.ReturnValue.ReturnNumber := 0;
      Result := UFNoError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetAccountInt }

Function GetAccountInt (ParamBlock : PUFParamBlock) : UFError; stdcall;
begin
  Result := GetAccountNumber(ParamBlock, True);
end;

Function GetAccountDbl (ParamBlock : PUFParamBlock) : UFError; stdcall;
begin
  Result := GetAccountNumber(ParamBlock, False);
end;

function GetCCDepName (ParamBlock : PUFParamBlock) : UFError; stdcall;
Var
  Param1, Param2, Param3   : PUFParamListElement;
  CompCode, CDCode, CDType, ResStr  : ShortString;
  Res                        : SmallInt;
Begin { GetAccountString }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { CC Dept Code }
  Param3 := GetParam (ParamBlock, 3);  { CCDep Type }

  ResStr := '';

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) And Assigned(Param3)  Then
  begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Account Code }
    CDCode := Param3^.Parameter.ParamString;
    If (Trim(CDCode) <> '') Then
    Begin
      { Get Account Type character }
      CDType := Param2^.Parameter.ParamString;
      If (Trim(CDType) = 'C') Or (Trim(CDType) = 'D') Then
      Begin
        //Call entfuncs
        Res := EntCCDepName(CompCode, CDType, CDCode, ResStr);
        If (Res = 0) Then
        begin
          { AOK - Return String }
          StrPCopy (ParamBlock^.ReturnValue.ReturnString, ResStr);
          Result := UFNoError;
        End { If }
        Else
        begin
          If (Res = 519) Or (Res = 520) Then
          Begin
            { Bummer - Invalid CC or Dept Code - Return blank string }
            ParamBlock^.ReturnValue.ReturnString := '';
            Result := UFNoError;
          End { If }
          Else
          Begin
            { Bummer - Return error status }
            ParamBlock.ReturnValue.UFReturnUserError := 38;
            Result := UFUserError;
          End; { Else }
        End; { Else }
      End { If (Trim(AcType) = 'C') Or (Trim(AcType) = 'S') }
      Else
      Begin
        { Invalid Account Type }
        ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
        Result := UFUserError;
      End; { Else }
    End { If }
    Else
    Begin
      { No CCD Code - Return Empty String }
      ParamBlock^.ReturnValue.ReturnString := '';
      Result := UFNoError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetAccountString }

function GetJobString (ParamBlock : PUFParamBlock) : UFError; stdcall;
Var
  Param1, Param2, Param3    : PUFParamListElement;
  CompCode, JobCode, ResStr : ShortString;
  Res, FIdx                 : SmallInt;
  TmpDub                    : Double;
Begin { GetAccountString }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { JobCode }
  Param3 := GetParam (ParamBlock, 3);  { Field wanted }

  ResStr := '';

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) And Assigned(Param3)  Then
  begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Account Code }
    JobCode := Param2^.Parameter.ParamString;

    if Trim(JobCode) <> '' then
    begin
        { Get Field Index }
      TmpDub := Param3^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TmpDub, FIdx);

      if Res = 0 then
      begin

        Res := EntJobStr(CompCode, JobCode, FIdx, ResStr);

        If (Res = 0) Then
        Begin
          { AOK - Return String }
          StrPCopy (ParamBlock^.ReturnValue.ReturnString, ResStr);
          Result := UFNoError;
        End { If }
        Else
        Begin
          If (Res = 521) Then
          Begin
            { Bummer - Invalid Job Code - Return blank string }
            ParamBlock^.ReturnValue.ReturnString := '';
            Result := UFNoError;
          End { If }
          Else
          Begin
            { Bummer - Return error status }
            ParamBlock.ReturnValue.UFReturnUserError := 38;
            Result := UFUserError;
          End; { Else }
        End; { Else }
      end
      else
      begin
        { Bummer - Return error status }
        ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
        Result := UFUserError;
      end;
    end
    else
    begin
      { Bummer - Return error status }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    end;
  end
  else
    Result := UFNotEnoughParameters;
end;

function GetLocationName (ParamBlock : PUFParamBlock) : UFError; stdcall;
Var
  Param1, Param2   : PUFParamListElement;
  CompCode, JobCode, ResStr  : ShortString;
  Res                        : SmallInt;
Begin { GetAccountString }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Job Code }

  ResStr := '';

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) Then
  begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Account Code }
    JobCode := Param2^.Parameter.ParamString;
    If (Trim(JobCode) <> '') Then
    Begin

      //Call entfuncs
      Res := EntLocationName(CompCode, JobCode, ResStr);
      If (Res = 0) Then
      begin
        { AOK - Return String }
        StrPCopy (ParamBlock^.ReturnValue.ReturnString, ResStr);
        Result := UFNoError;
      End { If }
      Else
      begin
        If (Res = 527) Then
        Begin
          { Bummer - Invalid Location Code - Return blank string }
          ParamBlock^.ReturnValue.ReturnString := '';
          Result := UFNoError;
        End { If }
        Else
        Begin
          { Bummer - Return error status }
          ParamBlock.ReturnValue.UFReturnUserError := 38;
          Result := UFUserError;
        End; { Else }
      End; { Else }
    End { If }
    Else
    Begin
      { No CCD Code - Return Empty String }
      ParamBlock^.ReturnValue.ReturnString := '';
      Result := UFNoError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetAccountString }

function GetCurrencyName (ParamBlock : PUFParamBlock) : UFError; stdcall;
Var
  Param1, Param2   : PUFParamListElement;
  CompCode, ResStr : ShortString;
  Res, CurrCode    : SmallInt;
  TmpDub           : Double;
Begin { GetAccountString }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { JobCode }

  ResStr := '';

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) Then
  begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;


    //Get Currency Code
    TmpDub := Param2^.Parameter.ParamNumber;
    Res := DoubleToInt2 (TmpDub, CurrCode);

    if Res = 0 then
    begin

      Res := EntCurrencyName(CompCode, CurrCode, ResStr);

      If (Res = 0) Then
      Begin
        { AOK - Return String }
        StrPCopy (ParamBlock^.ReturnValue.ReturnString, ResStr);
        Result := UFNoError;
      End { If }
      Else
      Begin
        If (Res = 514) Then
        Begin
          { Bummer - Invalid currency number - Return blank string }
          ParamBlock^.ReturnValue.ReturnString := '';
          Result := UFNoError;
        End { If }
        Else
        Begin
          { Bummer - Return error status }
          ParamBlock.ReturnValue.UFReturnUserError := 38;
          Result := UFUserError;
        End; { Else }
      End; { Else }
    end
    else
    begin
      { Bummer - Return error status }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    end;
  end
  else
    Result := UFNotEnoughParameters;
end;

Function GetJobNumber (ParamBlock : PUFParamBlock; IsInt : Boolean) : UFError; stdcall;
Var
  Param1, Param2, Param3   : PUFParamListElement;
  CompCode, JobCode        : ShortString;
  Res, FIdx                : SmallInt;
  TmpDub, ResDub           : Double;
  ResInt                   : longint;

  Procedure SetResult (IntRes : LongInt; DblRes : Double);
  Begin { SetResult }
    If IsInt Then
      ParamBlock^.ReturnValue.ReturnNumber := IntRes * 100
    Else
      ParamBlock^.ReturnValue.ReturnNumber := DblRes * 100;
  End; { SetResult }

Begin { GetAccountInt }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Account Code }
  Param3 := GetParam (ParamBlock, 3);  { Field wanted }

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) And Assigned(Param3) Then
  Begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Job Code }
    JobCode := Param2^.Parameter.ParamString;
    If (Trim(JobCode) <> '') Then
    Begin
      { Get Field Index }
      TmpDub := Param3^.Parameter.ParamNumber;
      Res := DoubleToInt2 (TmpDub, FIdx);
      If (Res = 0) Then Begin
        { Call function to get details }

        Case IsInt of
          True :
             Res := EntJobInt(CompCode, JobCode, FIdx, ResInt);
          False :
             Res := EntJobVal(CompCode, JobCode, FIdx, ResDub);
        end; //Case

        If (Res = 0) Then Begin
          { AOK - Return String }
          SetResult(ResInt, ResDub);
          Result := UFNoError;
        End { If }
        Else Begin
          If (Res = 521) Then Begin
            { Bummer - Invalid Job Code - Return blank string }
            ParamBlock^.ReturnValue.UFReturnUserError := TransErrorCode(Res);
            Result := UFNoError;
          End { If }
          Else Begin
            { Bummer - Return error status }
            ParamBlock.ReturnValue.UFReturnUserError := 38;
            Result := UFUserError;
          End; { Else }
        End; { Else }
      End { If }
      Else Begin
        { Bummer - Return error status }
        ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
        Result := UFUserError;
      End; { Else }
    End { If }
    Else Begin
      { No Account Code - Return Empty String }
      ParamBlock^.ReturnValue.ReturnNumber := 0;
      Result := UFNoError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetAccountInt }

function GetJobInt (ParamBlock : PUFParamBlock) : UFError; stdcall;
begin
  Result := GetJobNumber(ParamBlock, True);
end;

function GetJobDbl (ParamBlock : PUFParamBlock) : UFError; stdcall;
begin
  Result := GetJobNumber(ParamBlock, False);
end;

function GetAnalDesc (ParamBlock : PUFParamBlock) : UFError; stdcall;
Var
  Param1, Param2   : PUFParamListElement;
  CompCode, AnalCode, ResStr  : ShortString;
  Res                        : SmallInt;
Begin { GetAccountString }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Job Code }

  ResStr := '';

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) Then
  begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Account Code }
    AnalCode := Param2^.Parameter.ParamString;
    If (Trim(AnalCode) <> '') Then
    Begin

      //Call entfuncs
      Res := EntAnalDesc(CompCode, AnalCode, ResStr);
      If (Res = 0) Then
      begin
        { AOK - Return String }
        StrPCopy (ParamBlock^.ReturnValue.ReturnString, ResStr);
        Result := UFNoError;
      End { If }
      Else
      begin
        If (Res = 522) Then
        Begin
          { Bummer - Invalid Analysis Code - Return blank string }
          ParamBlock^.ReturnValue.ReturnString := '';
          Result := UFNoError;
        End { If }
        Else
        Begin
          { Bummer - Return error status }
          ParamBlock.ReturnValue.UFReturnUserError := 38;
          Result := UFUserError;
        End; { Else }
      End; { Else }
    End { If }
    Else
    Begin
      { No CCD Code - Return Empty String }
      ParamBlock^.ReturnValue.ReturnString := '';
      Result := UFNoError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetAccountString }

function GetCustStkNo (ParamBlock : PUFParamBlock; WhichNo : integer) : UFError;
{whichno = 1 - qty
         = 2 - sales}
Var
  Params : Array[1..9] of PUFParamListElement;

  Company, CustCode, StkCode  : ShortString;
  CostCentre, Dept, LocCode   : ShortString;
  Year, Period, Currency      : SmallInt;
  ResultVal, TmpDub           : Double;

  Res, i                      : SmallInt;
  ParamsOK : Boolean;

begin
  FillChar(Params, SizeOf(Params), #0);
  ParamsOK := True;
  for i := 1 to 9 do
  begin
    Params[i] := GetParam(ParamBlock, i);
    if not Assigned(Params[i]) then
      ParamsOK := False;
  end;



  if ParamsOK then
  begin
    Company := Params[1]^.Parameter.ParamString;
    CustCode := Params[2]^.Parameter.ParamString;
    StkCode := Params[3]^.Parameter.ParamString;

    Res := 0;
    TmpDub :=  Params[4]^.Parameter.ParamNumber;
    Res := Res or DoubleToInt2 (TmpDub, Currency);
    TmpDub := Params[5]^.Parameter.ParamNumber;
    Res := Res or DoubleToInt2 (TmpDub, Year);
    TmpDub := Params[6]^.Parameter.ParamNumber;
    Res := Res or DoubleToInt2 (TmpDub, Period);

    CostCentre := Params[7]^.Parameter.ParamString;
    Dept := Params[8]^.Parameter.ParamString;
    LocCode := Params[9]^.Parameter.ParamString;

    if Res = 0 then
    begin

      if (CustCode = '') or (StkCode = '') then
      begin
        ParamBlock.ReturnValue.ReturnNumber := 0;
        Result := UFNoError;
      end
      else
      begin
        Case whichNo of
          1 :
           Res := EntCustStkQty(Company, CustCode, StkCode,
                                Currency, Year, Period,
                                CostCentre, Dept, LocCode,
                                ResultVal);
          2 :
           Res := EntCustStkSales(Company, CustCode, StkCode,
                                  Currency, Year, Period,
                                  CostCentre, Dept, LocCode,
                                  ResultVal);
        end; //case

        if Res = 0 then
        begin
          ParamBlock.ReturnValue.ReturnNumber := ResultVal * 100;
          Result := UFNoError;
        end
        else
        begin
          //problem with function
          ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
          Result := UFUserError;
        end;
      end;

    end
    else
    begin
      //invalid number
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    end;

  end {if paramsOk}
  else
    Result := UFNotEnoughParameters;

end;

function GetCustStkQty (ParamBlock : PUFParamBlock) : UFError;
begin
  Result := GetCustStkNo(ParamBlock, 1);
end;

function GetCustStkSales (ParamBlock : PUFParamBlock) : UFError;
begin
  Result := GetCustStkNo(ParamBlock, 2);
end;

Function GetCurrencyNumber (ParamBlock : PUFParamBlock; WhichNo : SmallInt) : UFError; stdcall;
Var
  Param1, Param2   : PUFParamListElement;
  CompCode         : ShortString;
  CurrCode         : SmallInt;
  TmpDub, ResDub   : Double;
  Res              : Smallint;

Begin { GetAccountInt }
  Param1 := GetParam (ParamBlock, 1);  { Company }
  Param2 := GetParam (ParamBlock, 2);  { Account Code }

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) Then
  Begin
    { Get Company Code }
    CompCode := Param1^.Parameter.ParamString;

    { Get Currency Code }
    TmpDub := Param2^.Parameter.ParamNumber;

    Res := DoubleToInt2 (TmpDub, CurrCode);
    If (Res = 0) Then
    Begin
        { Call function to get details }
      Res := EntCurrencyValue(WhichNo, CompCode, CurrCode, ResDub);
      If (Res = 0) Then
      Begin
        ParamBlock^.ReturnValue.ReturnNumber := ResDub * 100;
        Result := UFNoError;
      End { If }
      Else
      Begin
        If (Res = 514) Then
        Begin
          { Bummer - Invalid currency number - Return blank string }
          ParamBlock^.ReturnValue.ReturnNumber := 0.0;
          Result := UFNoError;
        End { If }
        Else
        Begin
          { Bummer - Return error status }
          ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
          Result := UFUserError;
        End; { Else }
      End { If }
    End { If }
    Else Begin
      { No Account Code - Return Empty String }
      ParamBlock^.ReturnValue.ReturnNumber := 0;
      Result := UFNoError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; { GetAccountInt }


function GetDailyRate (ParamBlock : PUFParamBlock) : UFError;
begin
  Result := GetCurrencyNumber(ParamBlock, 1);
end;

function GetCompanyRate (ParamBlock : PUFParamBlock) : UFError; stdcall;
begin
  Result := GetCurrencyNumber(ParamBlock, 0);
end;

Function DefaultLogin (ParamBlock : PUFParamBlock) : UFError;
Var
  Param1, Param2        : PUFParamListElement;
  Uid, PWord : ShortString;
  Res                           : SmallInt;
Begin { DefaultLogin }
  Param1 := GetParam (ParamBlock, 1);  { User ID}
  Param2 := GetParam (ParamBlock, 2);  { Password }

  { check if the correct number of parameters is passed to the function }
  If Assigned(Param1) And Assigned(Param2) Then Begin
    { User ID }
    Uid := Param1^.Parameter.ParamString;

    { Password }
    PWord := Param2^.Parameter.ParamString;


    { Call function to get details }
    Res := EntDefaultLogin (Uid, PWord);

    If (Res = 0) Then Begin
      ParamBlock^.ReturnValue.ReturnNumber := Res;
      Result := UFNoError;
    End { If }
    Else Begin
      { Bummer - Return error status }
      ParamBlock.ReturnValue.UFReturnUserError := TransErrorCode(Res);
      Result := UFUserError;
    End; { Else }
  End { If }
  Else
    Result := UFNotEnoughParameters;
End; {Default Login}



Initialization
  DoneOnce := False;
end.



