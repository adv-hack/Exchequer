unit FuncList;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

Const
  MaxFuncs = 80;

Type
  // This Enumerated Type groups similar functions together and identifies what
  // to do when the function is Drilled to.
  TEnumFunctionCategory = (fcGLHistory,
                           fcGLCCHistory,
                           fcGLDpHistory,
                           fcGLCCDpHistory,
                           fcGLCOMHistory,
                           fcGLCCDpCOMHistory,
                           fcGLJobActual,
                           fcJCAnalActual,
                           fcJCAnalActualQty,
                           fcJCStkActual,
                           fcJCStkActualQty,
                           fcJCTotActual,
                           fcJCTotActualQty,

                          { Stock Items }
                           fcStkQtyOnOrder,
                           fcStkQtySold,
                           fcStkQtyAllocated,
                           fcStkQtyOSSOR,
                           fcStkQtyInStock,
                           fcStkQtyPicked,
                           fcStkQtyUsed,

                          { Works Order Stock Items }
                           fcStkWORQtyAllocated,
                           fcStkWORQtyIssued,
                           fcStkWORQtyPicked,

                          { Stock Items by Location }
                           fcStkLocQtyAllocated,
                           fcStkLocQtyInStock,
                           fcStkLocQtyOnOrder,
                           fcStkLocQtyOSSOR,
                           fcStkLocQtyPicked,
                           fcStkLocQtySold,
                           fcStkLocQtyUsed,

                          { Works Order Stock Items by Location }
                           fcStkLocWORQtyAllocated,
                           fcStkLocWORQtyIssued,
                           fcStkLocWORQtyPicked,

                           { Customer drill-down }
                           fcCustStkQty,
                           fcCustStkSales,
                           fcCustAgedBalance,
                           fcCustBalance,
                           fcCustCommitted,
                           fcCustNetSales,

                           { Supplier drill-down }
                           fcSuppCommitted,
                           fcSuppAgedBalance,
                           fcSuppBalance,

                           { GL View drill-down }
                           fcGLViewHistory,

                           fcDataSelection);

  // This enumeration is used to indicated which type of data selection is required
  TDataSelectType       = (dstCostCentre,
                           dstCustomer,
                           dstDepartment,
                           dstGLCode,
                           dstLocation,
                           dstStock,
                           dstSupplier,
                           dstJob,
                           dstEmployee,
                           dstAnalysis,
                           dstJobType);


  // This record is used en-masse in the TFunctionListArray to store the details
  // of all the supported functions that can be drilled to.  To minimise memory
  // footprint this structure should be kept as small as possible without hindering
  // performance of the parsing/drill-down routines.
  TFunctionDetailsType = Record
    fdName       : String[40];              // Function Name
    fdCategory   : TEnumFunctionCategory;   // Category - indicates what to do
    fdParamCount : Byte;                    // Number of parameters on function
    fdData       : LongInt;                 // Misc Data Field
  End; { TFunctionDetailsType }


  // Array structure to store the records containing function specific details,
  // the array is stored in heap and loaded programmatically during the Create
  // of TFunctionList using the TFunctionList.AddFunction method.
  TFunctionListArray = Array [1..MaxFuncs] Of TFunctionDetailsType;


  // Interface to publish the Function Details through the Functions property of
  // TFunctionList.  An interface is used so that TFunctionDetails is destroyed
  // automaticallyy once it falls out of scope
  IFunctionDetails = Interface
  ['{4B5C1B0B-5B87-47E5-9BB0-62F0532F9482}']
    // Internal Methods
    Function Get_fdName : ShortString;
    Function Get_fdCategory : TEnumFunctionCategory;
    Function Get_fdParamCount : Byte;
    Function Get_fdData : LongInt;

    // Properties
    Property fdName : ShortString Read Get_fdName;
    Property fdCategory : TEnumFunctionCategory Read Get_fdCategory;
    Property fdParamCount : Byte Read Get_fdParamCount;
    Property fdData : LongInt Read Get_fdData;

    // Methods
  End; { IFunctionDetails }


  // Implements IFunctionDetails and is used to publish the Function Details
  // through the Functions property of TFunctionList.  An Interface is used to
  // control the free'ing of the object automatically once scope is lost
  TFunctionDetails = Class (TInterfacedObject, IFunctionDetails)
  Private
    // Pointer to the Function list setup by the parent TFuncionList object
    FFunctionList  : ^TFunctionListArray;

    // Functions Index within the FFunctionList Array
    FFunctionIndex : SmallInt;
  Protected
    Function Get_fdName : ShortString;
    Function Get_fdCategory : TEnumFunctionCategory;
    Function Get_fdParamCount : Byte;
    Function Get_fdData : LongInt;
  Public
    Constructor Create (Const FuncListPtr : Pointer; Const FuncIdx : SmallInt);
    Destructor Destroy; Override;
  End; { TFunctionDetails }


  // The FunctionList object is a wrapper around a list of supported function names
  // and provides category and validation information on each function to allow the
  // Drill-Down routines to be more generic.
  TFunctionList = Class(TObject)
  Private
    // Index of next available element in the FunctionList array for when building
    // the list initially.
    FNextFunc : SmallInt;

    // FunctionList Array stores details of all the OLE functions supported by
    // the drill-down routines
    FFunctionList : ^TFunctionListArray;
  Protected
    Procedure AddFunction (Const FuncName : ShortString;
                           Const FuncCat  : TEnumFunctionCategory;
                           Const ParamCnt : Byte;
                           Const FuncData : LongInt = 0);
    Function Get_Functions(Index: SmallInt) : IFunctionDetails;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Properties
    Property Functions [Index: SmallInt] : IFunctionDetails Read Get_Functions;

    // Methods
    Function IndexOf (FunctionName : ShortString) : SmallInt;
  End; { TFunctionList }


// Access function for a global FunctionList object which is automatically
// created by the routine the first time it is called.
Function FunctionList : TFunctionList;


implementation

Var
  oFuncList : TFunctionList;

//=========================================================================

Function FunctionList : TFunctionList;
Begin { FunctionList }
  If (Not Assigned(oFuncList)) Then
    oFuncList := TFunctionList.Create;

  Result := oFuncList;
End; { FunctionList }

//=========================================================================

Constructor TFunctionDetails.Create (Const FuncListPtr : Pointer; Const FuncIdx : SmallInt);
Begin { Create }
  Inherited Create;

  FFunctionList := FuncListPtr;
  FFunctionIndex := FuncIdx;
End; { Create }

//--------------------------

Destructor TFunctionDetails.Destroy;
Begin { Destroy }
  FFunctionList := NIL;

  Inherited;
End; { Destroy }

//-------------------------------------------------------------------------

Function TFunctionDetails.Get_fdName : ShortString;
begin
  Result := FFunctionList^[FFunctionIndex].fdName;
end;

//--------------------------

Function TFunctionDetails.Get_fdCategory : TEnumFunctionCategory;
begin
  Result := FFunctionList^[FFunctionIndex].fdCategory;
end;

//--------------------------

Function TFunctionDetails.Get_fdParamCount : Byte;
begin
  Result := FFunctionList^[FFunctionIndex].fdParamCount;
end;

//--------------------------

Function TFunctionDetails.Get_fdData : LongInt;
begin
  Result := FFunctionList^[FFunctionIndex].fdData;
end;

//=========================================================================

Constructor TFunctionList.Create;
Begin { Create }
  Inherited;

  New(FFunctionList);
  FillChar (FFunctionList^, SizeOf(FFunctionList^), #0);

  // Build the list of functions - Order is unimportant except slight performance
  // improvement from functions being at the start - probably not noticible in the
  // real world.
  FNextFunc := Low(FFunctionList^);

  // Basic GL History Functions
  AddFunction ('EntGLActual', fcGLHistory, 5);
  AddFunction ('EntGLCredit', fcGLHistory, 5);
  AddFunction ('EntGLDebit',  fcGLHistory, 5);

  // GL+Cost Centre History Functions
  AddFunction ('EntGLCCActual', fcGLCCHistory, 6);
  AddFunction ('EntGLCCCredit', fcGLCCHistory, 6);
  AddFunction ('EntGLCCDebit',  fcGLCCHistory, 6);

  // GL+Department History Functions
  AddFunction ('EntGLDpActual', fcGLDpHistory, 6);
  AddFunction ('EntGLDpCredit', fcGLDpHistory, 6);
  AddFunction ('EntGLDpDebit',  fcGLDpHistory, 6);

  // GL+CostCentre+Department History Functions
  AddFunction ('EntGLCCDpActual', fcGLCCDpHistory, 7);
  AddFunction ('EntGLCCDpCredit', fcGLCCDpHistory, 7);
  AddFunction ('EntGLCCDpDebit',  fcGLCCDpHistory, 7);

  // Basic Committed GL History Functions
  AddFunction ('EntGLCOMActual', fcGLCOMHistory, 5);
  AddFunction ('EntGLCOMCredit', fcGLCOMHistory, 5);
  AddFunction ('EntGLCOMDebit',  fcGLCOMHistory, 5);

  // Committed GL+CostCentre+Department History Functions
  AddFunction ('EntGLCCDpCOMActual', fcGLCCDpCOMHistory, 7);
  AddFunction ('EntGLCCDpCOMCredit', fcGLCCDpCOMHistory, 7);
  AddFunction ('EntGLCCDpCOMDebit',  fcGLCCDpCOMHistory, 7);

  // Job Costing Functions
  AddFunction ('EntGLJobActual',     fcGLJobActual,     14);
  AddFunction ('EntJCAnalActual',    fcJCAnalActual,     7);
  AddFunction ('EntJCAnalActualQty', fcJCAnalActualQty,  6);
  AddFunction ('EntJCStkActual',     fcJCStkActual,      7);
  AddFunction ('EntJCStkActualQty',  fcJCStkActualQty,   6);
  AddFunction ('EntJCTotActual',     fcJCTotActual,      7);
  AddFunction ('EntJCTotActualQty',  fcJCTotActualQty,   6);

  // Stock Items
  AddFunction ('EntStkQtyOnOrder',      fcStkQtyOnOrder,    2);
  AddFunction ('EntStkQtySold',         fcStkQtySold,       5);
  AddFunction ('EntStkQtyAllocated',    fcStkQtyAllocated,  2);
  AddFunction ('EntStkQtyOSSOR',        fcStkQtyOSSOR,      2);
  AddFunction ('EntStkQtyInStock',      fcStkQtyInStock,    2);
  AddFunction ('EntStkQtyPicked',       fcStkQtyPicked,     2);
  AddFunction ('EntStkQtyUsed',         fcStkQtyUsed,       5);

  // Works Order Stock Items
  AddFunction ('EntStkWORQtyAllocated', fcStkWORQtyAllocated,  2);
  AddFunction ('EntStkWORQtyIssued',    fcStkWORQtyIssued,     2);
  AddFunction ('EntStkWORQtyPicked',    fcStkWORQtyPicked,     2);

  // Stock Items by Location
  AddFunction ('EntStkLocQtyAllocated', fcStkLocQtyAllocated,  3);
  AddFunction ('EntStkLocQtyInStock',   fcStkLocQtyInStock,    3);
  AddFunction ('EntStkLocQtyOnOrder',   fcStkLocQtyOnOrder,    3);
  AddFunction ('EntStkLocQtyOSSOR',     fcStkLocQtyOSSOR,      3);
  AddFunction ('EntStkLocQtyPicked',    fcStkLocQtyPicked,     3);
  AddFunction ('EntStkLocQtySold',      fcStkLocQtySold,       6);
  AddFunction ('EntStkLocQtyUsed',      fcStkLocQtyUsed,       6);

  // Works Order Stock Items by Location
  AddFunction ('EntStkLocWORQtyAllocated', fcStkLocWORQtyAllocated,  3);
  AddFunction ('EntStkLocWORQtyIssued',    fcStkLocWORQtyIssued,     3);
  AddFunction ('EntStkLocWORQtyPicked',    fcStkLocWORQtyPicked,     3);

  // Customer drill-down
  AddFunction ('EntCustStkQty',       fcCustStkQty,       9);
  AddFunction ('EntCustStkSales',     fcCustStkSales,     9);
  AddFunction ('EntCustAgedBalance',  fcCustAgedBalance,  6);
  AddFunction ('EntCustBalance',      fcCustBalance,      4);
  AddFunction ('EntCustCommitted',    fcCustCommitted,    4);
  AddFunction ('EntCustNetSales',     fcCustNetSales,     4);

  // Supplier drill-down
  AddFunction ('EntSuppCommitted',    fcSuppCommitted,    4);
  AddFunction ('EntSuppAgedBalance',  fcSuppAgedBalance,  6);
  AddFunction ('EntSuppBalance',      fcSuppBalance,      4);

  // GL View drill-down
  AddFunction ('EntGLViewActual',     fcGLViewHistory,    6);
  AddFunction ('EntGLViewCredit',     fcGLViewHistory,    6);
  AddFunction ('EntGLViewDebit',      fcGLViewHistory,    6);

  // Data Selection Functions
  AddFunction ('EntSelectCostCentre', fcDataSelection, 2, Ord(dstCostCentre));
  AddFunction ('EntSelectCustomer',   fcDataSelection, 2, Ord(dstCustomer));
  AddFunction ('EntSelectDepartment', fcDataSelection, 2, Ord(dstDepartment));
  AddFunction ('EntSelectGLCode',     fcDataSelection, 2, Ord(dstGLCode));
  AddFunction ('EntSelectLocation',   fcDataSelection, 2, Ord(dstLocation));
  AddFunction ('EntSelectStock',      fcDataSelection, 2, Ord(dstStock));
  AddFunction ('EntSelectSupplier',   fcDataSelection, 2, Ord(dstSupplier));
  AddFunction ('EntSelectJob',        fcDataSelection, 2, Ord(dstJob));
  AddFunction ('EntSelectEmployee',   fcDataSelection, 2, Ord(dstEmployee));
  AddFunction ('EntSelectAnalysis',   fcDataSelection, 2, Ord(dstAnalysis));
  AddFunction ('EntSelectJobTypes',   fcDataSelection, 2, Ord(dstJobType));

End; { Create }

//-------------------------------------------------------------------------

Destructor TFunctionList.Destroy;
Begin { Destroy }
  Dispose(FFunctionList);

  Inherited;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TFunctionList.AddFunction (Const FuncName : ShortString;
                                     Const FuncCat  : TEnumFunctionCategory;
                                     Const ParamCnt : Byte;
                                     Const FuncData : LongInt = 0);
Begin { AddFunction }
  If (FNextFunc >= Low(FFunctionList^)) And (FNextFunc <= High(FFunctionList^)) Then Begin
    With FFunctionList^[FNextFunc] Do Begin
      fdName       := UpperCase(FuncName);
      fdCategory   := FuncCat;
      fdParamCount := ParamCnt;
      fdData       := FuncData;
    End; { With FFunctionList^[FuncId] }

    Inc (FNextFunc);
  End { If (FNextFunc >= Low(FFunctionList^)) And (FNextFunc <= High(FFunctionList^)) }
  Else
    MessageDlg ('TFunctionList.AddFunction - FNextFunc (' + IntToStr(FNextFunc) + ') out of FunctionList Array Bounds', mtError, [mbOk], 0);
End; { AddFunction }

//-------------------------------------------------------------------------

// Runs through the function list and returns the index of the function, returns
// -1 if the FunctionName was not found
Function TFunctionList.IndexOf (FunctionName : ShortString) : SmallInt;
Var
  I : SmallInt;
Begin { IndexOf }
  Result := -1;

  // Convert param to uppercase for the comparisons
  FunctionName := UpperCase(FunctionName);

  // Run through the complete list of functions checking for the name
  For I := Low(FFunctionList^) To High(FFunctionList^) Do
    If (FFunctionList^[I].fdName = FunctionName) Then Begin
      Result := I;
      Break;
    End; { If (FFunctionList^[I] = FunctionName) }
End; { IndexOf }

//-------------------------------------------------------------------------

Function TFunctionList.Get_Functions(Index: SmallInt) : IFunctionDetails;
begin
  Result := TFunctionDetails.Create(FFunctionList, Index);
end;

//=========================================================================

Initialization
  oFuncList := NIL;
Finalization
  FreeAndNIL(oFuncList);
end.

