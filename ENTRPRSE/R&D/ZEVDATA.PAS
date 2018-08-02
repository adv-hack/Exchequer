unit ZEvData;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU,
  ZBatch, ZCCDept, ZCust, ZGL, zMiscDat, ZJob, ZStock, ZTrans,
  zBin,zTeleHdr, zJobCost, zLoc, zStkLoc, zPaper;

type
  TCOMEventData = class(TAutoIntfObject, ICOMEventData, ICOMEventData01,
                                         ICOMEventData2, ICOMEventData3,
                                         ICOMEventData4)
  private
    hEntSysObj    : TEnterpriseSystem;

    { Sub Classes - Objects }
    FBatchO       : TCOMBatchSerial;    { ICOMEventData01 }
    FBinO         : TComMutliBin;       { ICOMEventData3 }
    FCostCentreO  : TComCCDept;         { ICOMEventData }
    FCustomerO    : TComCustomer;       { ICOMEventData }
    FDepartmentO  : TComCCDept;         { ICOMEventData }
    FGLCodeO      : TComGLCode;         { ICOMEventData }
    FJobO         : TComJob;            { ICOMEventData }
    FJobCostingO  : TComJobCosting;     { ICOMEventData }
    FLocationO    : TCOMLocation;       { ICOMEventData4 }
    FPaperlessO   : TCOMPaperless;      { ICOMEventData4 }
    FStockO       : TComStock;          { ICOMEventData }
    FStockLocO    : TCOMStockLocation;  { ICOMEventData4 }
    FSupplierO    : TComCustomer;       { ICOMEventData }
    FTeleSalesO   : TCOMTelesales;      { ICOMEventData }
    FTransO       : TComTransaction;    { ICOMEventData }
    FMiscDataO    : TComMiscData;       { ICOMEventData }

    { Sub Classes - Interfaces }
    FBatchI       : ICOMBatchSerial3;   { ICOMEventData03 }
    FBinI         : ICOMMultiBin2;
    FCostCentreI  : IComCCDept;         { ICOMEventData }
    FCustomerI    : IComCustomer3;      { ICOMEventData }
    FDepartmentI  : IComCCDept;         { ICOMEventData }
    FGLCodeI      : IComGLCode;         { ICOMEventData }
    FJobI         : IComJob2;           { ICOMEventData }
    FJobCostingI  : IComJobCosting;     { ICOMEventData }
    FLocationI    : ICOMLocation;       { ICOMEventData4 }
    FPaperlessI   : ICOMPaperless;      { ICOMEventData4 }
    FStockI       : IComStock4;         { ICOMEventData03 }
    FStockLocI    : ICOMStockLocation;  { ICOMEventData4 }
    FSupplierI    : IComCustomer3;      { ICOMEventData }
    FTeleSalesI   : ICOMTelesales;      { ICOMEventData }
    FTransI       : IComTransaction3;   { ICOMEventData }
    FMiscDataI    : IComMiscData;       { ICOMEventData }

    Procedure InitSubObjects;
  protected
    { ICOMEventData }
    function  Get_WindowId: Integer; safecall;
    function  Get_HandlerId: Integer; safecall;
    function  Get_Customer: ICOMCustomer; safecall;
    function  Get_Supplier: ICOMCustomer; safecall;
    function  Get_CostCentre: ICOMCCDept; safecall;
    function  Get_Department: ICOMCCDept; safecall;
    function  Get_GLCode: ICOMGLCode; safecall;
    function  Get_Stock: ICOMStock; safecall;
    function  Get_Transaction: ICOMTransaction; safecall;
    function  Get_Job: ICOMJob; safecall;
    function  Get_MiscData: ICOMMiscData; safecall;
    function  Get_ValidStatus: WordBool; safecall;
    procedure Set_ValidStatus(Value: WordBool); safecall;
    function  Get_BoResult: WordBool; safecall;
    procedure Set_BoResult(Value: WordBool); safecall;
    function Get_DblResult: Double; safecall;
    function Get_IntResult: Integer; safecall;
    function Get_StrResult: WideString; safecall;
    function Get_VarResult: OleVariant; safecall;
    procedure Set_DblResult(Value: Double); safecall;
    procedure Set_IntResult(Value: Integer); safecall;
    procedure Set_StrResult(const Value: WideString); safecall;
    procedure Set_VarResult(Value: OleVariant); safecall;
    function Get_InEditMode: WordBool; safecall;

    { ICOMEventData01 }
    function  Get_BatchSerial: ICOMBatchSerial; safecall;

    // ICOMEventData2
    function Get_Customer2: ICOMCustomer3; safecall;
    function Get_JobCosting: ICOMJobCosting; safecall;
    function Get_Supplier2: ICOMCustomer3; safecall;
    function Get_Telesales: ICOMTelesales; safecall;
    function Get_Transaction2: ICOMTransaction3; safecall;

    function Get_BatchSerial2: ICOMBatchSerial2; safecall;
    function Get_Bin: ICOMMultiBin; safecall;
    function Get_Stock3: ICOMStock3; safecall;

    // ICOMEventData4
    function Get_BatchSerial3: ICOMBatchSerial3; safecall;
    function Get_Bin2: ICOMMultiBin2; safecall;
    function Get_Location: ICOMLocation; safecall;
    function Get_Paperless: ICOMPaperless; safecall;
    function Get_Stock4: ICOMStock4; safecall;
    function Get_StockLocation: ICOMStockLocation; safecall;

    // Internal Methods
    function  Get_Job2: ICOMJob2;
  public
    Property JobI : ICOMJob2 Read Get_Job2;

    Constructor Create;
    Destructor Destroy; override;

    Procedure InitEventData (Const EntSys : TEnterpriseSystem);
  End; { TCOMEventData }

implementation

uses ComServ, CustIntU;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMEventData.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMEventData4);

  InitSubObjects;
End; { Create }

{-----------------------------------------}

Destructor TCOMEventData.Destroy;
Begin { Destroy }
  InitSubObjects;

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TCOMEventData.InitSubObjects;
Begin { InitSubObjects }
  hEntSysObj := Nil;

  FBatchO := Nil;
  FBatchI := Nil; { Setting Interface to Nil will cause Destroy }

  FBinO := NIL;
  FBinI := NIL;  { Setting Interface to Nil will cause Destroy }

  FCostCentreO := Nil;
  FCostCentreI := Nil; { Setting Interface to Nil will cause Destroy }

  FCustomerO := Nil;
  FCustomerI := Nil; { Setting Interface to Nil will cause Destroy }

  FDepartmentO := Nil;
  FDepartmentI := Nil; { Setting Interface to Nil will cause Destroy }

  FGLCodeO := Nil;
  FGLCodeI := Nil; { Setting Interface to Nil will cause Destroy }

  FJobO := Nil;
  FJobI := Nil; { Setting Interface to Nil will cause Destroy }

  FJobCostingO := Nil;
  FJobCostingI := Nil; { Setting Interface to Nil will cause Destroy }

  FLocationO := NIL;
  FLocationI := Nil; { Setting Interface to Nil will cause Destroy }

  FPaperlessO := NIL;
  FPaperlessI := Nil; { Setting Interface to Nil will cause Destroy }

  FStockO := Nil;
  FStockI := Nil; { Setting Interface to Nil will cause Destroy }

  FStockLocO := Nil;
  FStockLocI := Nil; { Setting Interface to Nil will cause Destroy }

  FSupplierO := Nil;
  FSupplierI := Nil; { Setting Interface to Nil will cause Destroy }

  FTeleSalesO := NIL;
  FTeleSalesI := Nil; { Setting Interface to Nil will cause Destroy }

  FTransO := Nil;
  FTransI := Nil; { Setting Interface to Nil will cause Destroy }

  FMiscDataO := Nil;
  FMiscDataI := Nil; { Setting Interface to Nil will cause Destroy }
End; { InitSubObjects }

{-----------------------------------------}

Procedure TCOMEventData.InitEventData (Const EntSys : TEnterpriseSystem);
Begin { Get_WindowId }
  hEntSysObj := EntSys;

  If Assigned(FBatchO) Then FBatchO.InitBatch(hEntSysObj);
  If Assigned(FBinO) Then FBinO.InitMultiBin(hEntSysObj);
  If Assigned(FCostCentreO) Then FCostCentreO.InitCCDept('C', hEntSysObj);
  If Assigned(FCustomerO) Then FCustomerO.InitAccount('C', hEntSysObj);
  If Assigned(FDepartmentO) Then FDepartmentO.InitCCDept('D', hEntSysObj);
  If Assigned(FGLCodeO) Then FGLCodeO.InitGLCode(hEntSysObj);
  If Assigned(FJobO) Then FJobO.InitJob(hEntSysObj);
  If Assigned(FJobCostingO) Then FJobCostingO.InitJobCosting(hEntSysObj);
  If Assigned(FLocationO) Then FLocationO.InitLocation(hEntSysObj);
  If Assigned(FPaperlessO) Then FPaperlessO.InitPaperless(hEntSysObj);
  If Assigned(FStockO) Then FStockO.InitStock(hEntSysObj);
  If Assigned(FStockLocO) Then FStockLocO.InitStockLocation(hEntSysObj);
  If Assigned(FSupplierO) Then FSupplierO.InitAccount('S', hEntSysObj);
  If Assigned(FTelesalesO) Then FTelesalesO.InitTelesales(hEntSysObj);
  If Assigned(FTransO) Then FTransO.InitTrans(hEntSysObj);
  If Assigned(FMiscDataO) Then FMiscDataO.InitMiscData(hEntSysObj);
End; { Get_WindowId }

{-----------------------------------------}

function TCOMEventData.Get_WindowId: Integer;
Begin { Get_WindowId }
  Result := hEntSysObj.WinId;
End; { Get_WindowId }

{-----------------------------------------}

function TCOMEventData.Get_HandlerId: Integer;
Begin { Get_HandlerId }
  Result := hEntSysObj.HandlerId;
End; { Get_HandlerId }

{-----------------------------------------}

function TCOMEventData.Get_CostCentre: ICOMCCDept;
begin
  If (Not Assigned(FCostCentreO)) Then Begin
    { Create and initialise Cost Centre Details }
    FCostCentreO := TComCCDept.Create;
    FCostCentreO.InitCCDept('C', hEntSysObj);

    FCostCentreI := FCostCentreO;
  End; { If (Not Assigned(FCostCentreO)) }

  Result := FCostCentreI;
end;

{-----------------------------------------}

function TCOMEventData.Get_Customer2: ICOMCustomer3;
Begin { Get_Customer }
  If (Not Assigned(FCustomerO)) Then Begin
    { Create and initialise Customer Details }
    FCustomerO := TComCustomer.Create;
    FCustomerO.InitAccount('C', hEntSysObj);

    FCustomerI := FCustomerO;
  End; { If (Not Assigned(FCustomer)) }

  Result := FCustomerI;
End; { Get_Customer }

Function TCOMEventData.Get_Customer: ICOMCustomer;
Begin
  Result := Get_Customer2;
End;

{-----------------------------------------}

function TCOMEventData.Get_Department: ICOMCCDept;
begin
  If (Not Assigned(FDepartmentO)) Then Begin
    { Create and initialise Department Details }
    FDepartmentO := TComCCDept.Create;
    FDepartmentO.InitCCDept('D', hEntSysObj);

    FDepartmentI := FDepartmentO;
  End; { If (Not Assigned(FDepartmentO)) }

  Result := FDepartmentI;
end;

{-----------------------------------------}

function TCOMEventData.Get_GLCode: ICOMGLCode;
begin
  If (Not Assigned(FGLCodeO)) Then Begin
    { Create and initialise GL Code Details }
    FGLCodeO := TComGLCode.Create;
    FGLCodeO.InitGLCode(hEntSysObj);

    FGLCodeI := FGLCodeO;
  End; { If (Not Assigned(FGLCodeO)) }

  Result := FGLCodeI;
end;

{-----------------------------------------}

function TCOMEventData.Get_Job2: ICOMJob2;
Begin { Get_Job2 }
  If (Not Assigned(FJobO)) Then Begin
    { Create and initialise Customer Details }
    FJobO := TComJob.Create;
    FJobO.InitJob(hEntSysObj);

    FJobI := FJobO;
  End; { If (Not Assigned(FJob)) }

  Result := FJobI;
End; { Get_Job2 }

function TCOMEventData.Get_Job: ICOMJob;
Begin
  Result := Get_Job2;
End;

{-----------------------------------------}

function TCOMEventData.Get_JobCosting: ICOMJobCosting;
begin
  If (Not Assigned(FJobCostingO)) Then Begin
    { Create and initialise the Job Costing sub-object }
    FJobCostingO := TCOMJobCosting.Create(Self);
    FJobCostingO.InitJobCosting(hEntSysObj);

    FJobCostingI := FJobCostingO;
  End; { If (Not Assigned(FJobCostingO)) }

  Result := FJobCostingI;
End; { Get_JobCosting }

{-----------------------------------------}

function TCOMEventData.Get_Location: ICOMLocation;
Begin // Get_Location
  If (Not Assigned(FLocationO)) Then
  Begin
    // Create and initialise Location object
    FLocationO := TCOMLocation.Create;
    FLocationO.InitLocation(hEntSysObj);

    FLocationI := FLocationO;
  End; // If (Not Assigned(FLocationO))

  Result := FLocationI;
End; // Get_Location

{-----------------------------------------}

function TCOMEventData.Get_MiscData: ICOMMiscData;
begin
  If (Not Assigned(FMiscDataO)) Then Begin
    { Create and initialise Misc data object }
    FMiscDataO := TComMiscData.Create;
    FMiscDataO.InitMiscData(hEntSysObj);

    FMiscDataI := FMiscDataO;
  End; { If (Not Assigned(FMiscDataO)) }

  Result := FMiscDataI;
end;

{-----------------------------------------}

function TCOMEventData.Get_Paperless: ICOMPaperless;
Begin // Get_Paperless
  If (Not Assigned(FPaperlessO)) Then
  Begin
    // Create and initialise Paperless object
    FPaperlessO := TCOMPaperless.Create;
    FPaperlessO.InitPaperless(hEntSysObj);

    FPaperlessI := FPaperlessO;
  End; // If (Not Assigned(FPaperlessO))

  Result := FPaperlessI;
End; // Get_Paperless

{-----------------------------------------}

function TCOMEventData.Get_Stock4: ICOMStock4;
begin
  If (Not Assigned(FStockO)) Then Begin
    { Create and initialise Stock Details }
    FStockO := TComStock.Create;
    FStockO.InitStock(hEntSysObj);

    FStockI := FStockO;
  End; { If (Not Assigned(FStockO)) }

  Result := FStockI;
end;

function TCOMEventData.Get_Stock3: ICOMStock3;
begin
  Result := Get_Stock4;
End;

function TCOMEventData.Get_Stock: ICOMStock;
begin
  Result := Get_Stock4;
End;

{-----------------------------------------}

function TCOMEventData.Get_StockLocation: ICOMStockLocation;
Begin // Get_StockLocation
  If (Not Assigned(FStockLocO)) Then
  Begin
    // Create and initialise StockLoc object
    FStockLocO := TCOMStockLocation.Create;
    FStockLocO.InitStockLocation(hEntSysObj);

    FStockLocI := FStockLocO;
  End; // If (Not Assigned(FStockLocO))

  Result := FStockLocI;
End; // Get_StockLocation

{-----------------------------------------}

function TCOMEventData.Get_Supplier2: ICOMCustomer3;
begin
  If (Not Assigned(FSupplierO)) Then Begin
    { Create and initialise Customer Details }
    FSupplierO := TComCustomer.Create;
    FSupplierO.InitAccount('S', hEntSysObj);

    FSupplierI := FSupplierO;
  End; { If (Not Assigned(FCustomer)) }

  Result := FSupplierI;
end;

function TCOMEventData.Get_Supplier: ICOMCustomer;
begin
  Result := Get_Supplier2;
End;

{-----------------------------------------}

function TCOMEventData.Get_Telesales: ICOMTelesales;
begin
  If (Not Assigned(FTelesalesO)) Then Begin
    { Create and initialise Transaction Details }
    FTelesalesO := TComTelesales.Create;
    FTelesalesO.InitTelesales(hEntSysObj);

    FTelesalesI := FTelesalesO;
  End; { If (Not Assigned(FTelesalesO)) }

  Result := FTelesalesI;
end;

{-----------------------------------------}

function TCOMEventData.Get_Transaction2: ICOMTransaction3;
begin
  If (Not Assigned(FTransO)) Then Begin
    { Create and initialise Transaction Details }
    FTransO := TComTransaction.Create;
    FTransO.InitTrans(hEntSysObj);

    FTransI := FTransO;
  End; { If (Not Assigned(FTransO)) }

  Result := FTransI;
end;

function TCOMEventData.Get_Transaction: ICOMTransaction;
Begin
  Result := Get_Transaction2;
End;

{-----------------------------------------}

function TCOMEventData.Get_BatchSerial3: ICOMBatchSerial3;
Begin // Get_BatchSerial3
  If (Not Assigned(FBatchO)) Then Begin
    { Create and initialise Batch/Serial Details }
    FBatchO := TCOMBatchSerial.Create;
    FBatchO.InitBatch(hEntSysObj);

    FBatchI := FBatchO;
  End; { If (Not Assigned(FBatchO)) }

  Result := FBatchI;
End; // Get_BatchSerial3

function TCOMEventData.Get_BatchSerial2: ICOMBatchSerial2;
Begin { Get_BatchSerial }
  Result := Get_BatchSerial3;
End; { Get_BatchSerial }

function TCOMEventData.Get_BatchSerial: ICOMBatchSerial;
Begin { Get_BatchSerial }
  Result := Get_BatchSerial3;
End; { Get_BatchSerial }

{-----------------------------------------}

function TCOMEventData.Get_Bin2: ICOMMultiBin2;
Begin { Get_Bin2 }
  If (Not Assigned(FBinO)) Then Begin
    { Create and initialise Bin Details }
    FBinO := TCOMMutliBin.Create;
    FBinO.InitMultiBin(hEntSysObj);

    FBinI := FBinO;
  End; { If (Not Assigned(FBinO)) }

  Result := FBinI;
End; { Get_Bin2 }

function TCOMEventData.Get_Bin: ICOMMultiBin;
Begin // Get_Bin
  Result := Get_Bin2;
End; // Get_Bin

{-----------------------------------------}

function TCOMEventData.Get_ValidStatus: WordBool;
Begin { Get_ValidStatus }
  Result := hEntSysObj.ValidStatus;
End; { Get_ValidStatus }

procedure TCOMEventData.Set_ValidStatus(Value: WordBool);
Begin { Set_ValidStatus }
  hEntSysObj.ValidStatus := Value;
End; { Set_ValidStatus }

{-----------------------------------------}

function TCOMEventData.Get_BoResult: WordBool;
Begin { Get_BoResult }
  Result := hEntSysObj.BoResult;
End; { Get_BoResult }

procedure TCOMEventData.Set_BoResult(Value: WordBool);
Begin { Set_BoResult }
  hEntSysObj.BoResult := Value;
End; { Set_BoResult }

{-----------------------------------------}

function TCOMEventData.Get_DblResult: Double;
begin
  Result := hEntSysObj.DblResult;
end;

procedure TCOMEventData.Set_DblResult(Value: Double);
begin
  hEntSysObj.DblResult := Value;
end;

{-----------------------------------------}

function TCOMEventData.Get_IntResult: Integer;
begin
  Result := hEntSysObj.IntResult;
end;

procedure TCOMEventData.Set_IntResult(Value: Integer);
begin
  hEntSysObj.IntResult := Value;
end;

{-----------------------------------------}

function TCOMEventData.Get_StrResult: WideString;
begin
  Result := hEntSysObj.StrResult;
end;

procedure TCOMEventData.Set_StrResult(const Value: WideString);
begin
  hEntSysObj.StrResult := Value;
end;

{-----------------------------------------}

function TCOMEventData.Get_VarResult: OleVariant;
begin
  Result := hEntSysObj.VarResult;
end;

procedure TCOMEventData.Set_VarResult(Value: OleVariant);
begin
  hEntSysObj.VarResult := Value;
end;

{-----------------------------------------}

function TCOMEventData.Get_InEditMode: WordBool;
begin
  Result := hEntSysObj.InEditMode;
end;

{-----------------------------------------}



end.





