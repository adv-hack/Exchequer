{$STACKFRAMES ON} // This, and a few others like it, appear to be needed
                  // for proper compilation

library U2LEntrp;

{$REALCOMPATIBILITY ON}

uses
  Windows,
  UFFuncs in 'Uffuncs.pas',
  U2LFuncs in 'U2LFuncs.pas';

var FunctionDefStringList  : UFFunctionDefStringList;

var FunctionTemplateList   : UFFunctionTemplateList;

var FunctionExampleList    : UFFunctionExampleList;

function UFInitialize : UFError;stdcall;
begin
  Result :=  UFNoError;
end;

function UFGetVersion : UFTInt16u;stdcall;
begin
  Result := CurVersionNumber;
end;

function UFTerminate : UFError;stdcall;
begin
  Result :=  UFNoError;
end;

function UFGetFunctionTemplates : PUFFunctionTemplateList;stdcall;
begin
  Result :=  @FunctionTemplateList;
end;

function UFGetFunctionExamples : PUFFunctionExampleList;stdcall;
begin
  Result :=  @FunctionExampleList;
end;

function UFGetFunctionDefStrings  : PUFFunctionDefStringList;stdcall;
begin
  Result :=  @FunctionDefStringList;
end;

function UFErrorRecovery (paramPtr : PUFParamBlock; errN : UFError) : PChar;stdcall;
begin
  Result :=  ErrorTable [paramPtr^.ReturnValue.UFReturnUserError];
end;

procedure UFStartJob (jobId : UFTInt32u) ;stdcall;
begin
 // initialize any job-related data structures
  InitForJob (jobId);
end;

procedure UFEndJob (jobId : UFTInt32u );stdcall;
begin
  // clean up any job-related data structures
  TermForJob (jobId);
end;


exports
    UFInitialize,
    UFTerminate,
    UFGetVersion,
    UFStartJob,
    UFEndJob,
    UFGetFunctionDefStrings,
    UFGetFunctionExamples,
    UFGetFunctionTemplates,
    UFErrorRecovery,

    { U2LFuncs.Pas }
    GetCustBalance,
    GetCustNetSales,
    GetCustCosts,
    GetCustMargin,
    GetCustDebits,
    GetCustCredits,
    GetCustBudget,

    GetGLBudget,
    GetGLBudget2,
    GetGLActual,
    GetGLDebit,
    GetGLCredit,
    GetGLCOMActual,
    GetGLCOMDebit,
    GetGLCOMCredit,

    GetGLCCBudget,
    GetGLCCBudget2,
    GetGLCCActual,
    GetGLCCDebit,
    GetGLCCCredit,
    GetGLCCCOMActual,
    GetGLCCCOMDebit,
    GetGLCCCOMCredit,

    GetGLDpBudget,
    GetGLDpBudget2,
    GetGLDpActual,
    GetGLDpDebit,
    GetGLDpCredit,
    GetGLDpCOMActual,
    GetGLDpCOMDebit,
    GetGLDpCOMCredit,

    ConvertIToD,
    GetLibVers,
    GetStkQtySold,
    GetStkSales,
    GetStkCosts,
    GetStkMargin,
    GetStkBudget,
    GetStkPosted,
    GetStkLocQtySold,
    GetStkLocSales,
    GetStkLocCosts,
    GetStkLocMargin,
    GetStkLocBudget,
    GetStkLocPosted,
    GetJCCatDesc,
    GetJBQuantity,
    GetJBBudget,
    GetJBRevBudgQty,
    GetJBRevBudget,
    GetJBActualQty,
    GetJBActual,
    GetJCBudget,
    GetJCRevBudget,
    GetJCActual,

    ConvertDate,

    GetStockString,
    GetStockInt,
    GetStockDbl,

    GetAccountString,

    GetStockQty,
    GetStockLocQty,
    DefaultLogin;

begin

  FunctionDefStringList.StructSize := SizeOf(UFFunctionDefStringList);
  FunctionDefStringList.UFFunctionDefStrPtr := PUFFunctionDefStrings(@FunctionDefStrings);

  FunctionTemplateList.StructSize := SizeOf (UFFunctionTemplateList);
  FunctionTemplateList.UFFuncTemplatePtr := PUFFunctionTemplates(@FunctionTemplates);

  FunctionExampleList.StructSize := SizeOf (UFFunctionExampleList);
  FunctionExampleList.FuncExample := PUFFunctionExamples(@FunctionExamples);


end.
