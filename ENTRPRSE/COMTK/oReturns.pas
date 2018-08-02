unit oReturns;

{$ALIGN 1}
interface

uses
  {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
   ComObj, ComServ, VarCnst3, oTrans, oLine, VarConst, oB2B,
   ExceptIntf;


type

  TReturnCreate = Class(TAutoIntfObjectEx, IReturnCreate, IConversionLibrary)
  protected
    FCreateRec : TBatchReturnCreateRec;

    FParentO : TTransaction;
    FParentI : ITransaction;

    FParentLineO : TTransactionLine;
    FParentLineI : ITransactionLine;

    FToolkit : IToolkit;

    //PR: 24/11/2011
    FLibraryLoaded : Boolean;

    function GetDocType : TDocTypes;
    function Get_rcUnderWarranty: WordBool; safecall;
    procedure Set_rcUnderWarranty(Value: WordBool); safecall;
    function Get_rcDate: WideString; safecall;
    procedure Set_rcDate(const Value: WideString); safecall;
    function Get_rcPeriod: Integer; safecall;
    procedure Set_rcPeriod(Value: Integer); safecall;
    function Get_rcYear: Integer; safecall;
    procedure Set_rcYear(Value: Integer); safecall;
    function Get_rcYourRef: WideString; safecall;
    procedure Set_rcYourRef(const Value: WideString); safecall;
    function Get_rcReason: Integer; safecall;
    procedure Set_rcReason(Value: Integer); safecall;
    function Get_rcQty: Double; safecall;
    procedure Set_rcQty(Value: Double); safecall;
    function Get_rcSetReturnedQty: WordBool; safecall;
    procedure Set_rcSetReturnedQty(Value: WordBool); safecall;
    function Get_rcAddToExistingReturn: WordBool; safecall;
    procedure Set_rcAddToExistingReturn(Value: WordBool); safecall;
    function Get_rcReturnOurRef: WideString; safecall;
    procedure Set_rcReturnOurRef(const Value: WideString); safecall;
    function Get_rcSupplier: WideString; safecall;
    procedure Set_rcSupplier(const Value: WideString); safecall;
    function Get_rcDirectCustomerRepair: WordBool; safecall;
    procedure Set_rcDirectCustomerRepair(Value: WordBool); safecall;
    function Get_rcLocation: WideString; safecall;
    procedure Set_rcLocation(const Value: WideString); safecall;

    //IConversionLibrary 24/11/2011
    procedure Finalize; safecall;


    procedure InitObjects;
  public
    property Toolkit : IToolkit read FToolkit write FToolkit;
  end;

  TReturnCreateFromTrans = Class(TReturnCreate, ITransactionReturnCreate)
  protected
    function Execute : Integer; safecall;
  public
    constructor Create(Parent : TTransaction; const Toolkit : IToolkit);
    destructor Destroy; override;
  end;

  TReturnCreateFromLine = Class(TReturnCreate, ITransactionLineReturnCreate)
  protected
    function Get_rcStatus: Integer; safecall;
    function Execute : ITransaction; safecall;
  public
    constructor Create(Parent : TTransactionLine; const Toolkit : IToolkit);
    destructor Destroy; override;
  end;

  TReturnAction = Class(TAutoIntfObjectEx, IReturnAction, IConversionLibrary)
  private
    FActionRec : TBatchReturnActionRec;
    FParentO : TTransaction;

    FB2BO : TBackToBackOrder;
    FB2BI : IBackToBackOrder;
    FToolkit : TObject;

    //PR: 24/11/2011
    FLibraryLoaded : Boolean;
  protected
    function Get_raAllocCreditToOriginalDoc: WordBool; safecall;
    procedure Set_raAllocCreditToOriginalDoc(Value: WordBool); safecall;
    function Get_raReplacementDocType: TDocTypes; safecall;
    procedure Set_raReplacementDocType(Value: TDocTypes); safecall;
    function Get_raAction: TReturnActionType; safecall;
    procedure Set_raAction(Value: TReturnActionType); safecall;
    function Get_raApplyRestockingCharge: WordBool; safecall;
    procedure Set_raApplyRestockingCharge(Value: WordBool); safecall;
    function Get_raReturnedItems: TReturnedItemsDisposalType; safecall;
    procedure Set_raReturnedItems(Value: TReturnedItemsDisposalType); safecall;
    function Get_raApplyCurrentPrice: WordBool; safecall;
    procedure Set_raApplyCurrentPrice(Value: WordBool); safecall;
    function Get_raBackToBack: IBackToBackOrder; safecall;
    function Execute: Integer; safecall;
    procedure InitObjects;

    //IConversionLibrary 24/11/2011
    procedure Finalize; safecall;


    function CheckForValidLines(const oTrans : ITransaction) : Integer;
  public
    constructor Create(ParentO : TTransaction; Const Toolkit : TObject);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils, SpDlIntf, EtStrU, MiscFunc, DllErrU, GlobVar, oToolkit, Dialogs;

{ TReturnCreate }

function TReturnCreate.Get_rcAddToExistingReturn: WordBool;
begin
  Result := FCreateRec.AddToExistingReturn;
end;

function TReturnCreate.Get_rcDate: WideString;
begin
  Result := FCreateRec.CreateDate;
end;

function TReturnCreate.Get_rcReturnOurRef: WideString;
begin
  Result := FCreateRec.ReturnOurRef;
end;

function TReturnCreate.Get_rcPeriod: Integer;
begin
  Result := FCreateRec.Period;
end;

function TReturnCreate.Get_rcQty: Double;
begin
  Result := FCreateRec.Qty;
end;

function TReturnCreate.Get_rcReason: Integer;
begin
  Result := FCreateRec.Reason;
end;

function TReturnCreate.Get_rcSetReturnedQty: WordBool;
begin
  Result := FCreateRec.SetReturnedQty;
end;

function TReturnCreate.Get_rcUnderWarranty: WordBool;
begin
  Result := FCreateRec.UnderWarranty;
end;

function TReturnCreate.Get_rcYear: Integer;
begin
  Result := FCreateRec.Year;
end;

function TReturnCreate.Get_rcYourRef: WideString;
begin
  Result := FCreateRec.YourRef;
end;

procedure TReturnCreate.Set_rcAddToExistingReturn(Value: WordBool);
begin
  FCreateRec.AddToExistingReturn := Value;
end;

procedure TReturnCreate.Set_rcDate(const Value: WideString);
begin
  FCreateRec.CreateDate := Value;
end;

procedure TReturnCreate.Set_rcReturnOurRef(
  const Value: WideString);
begin
  FCreateRec.ReturnOurRef := Value;
end;

procedure TReturnCreate.Set_rcPeriod(Value: Integer);
begin
  FCreateRec.Period := Value;
end;

procedure TReturnCreate.Set_rcQty(Value: Double);
begin
  FCreateRec.Qty := Value;
end;

procedure TReturnCreate.Set_rcReason(Value: Integer);
begin
  FCreateRec.Reason := Value;
end;

procedure TReturnCreate.Set_rcSetReturnedQty(Value: WordBool);
begin
  FCreateRec.SetReturnedQty := Value;
end;

procedure TReturnCreate.Set_rcUnderWarranty(Value: WordBool);
begin
  FCreateRec.UnderWarranty := Value;
end;

procedure TReturnCreate.Set_rcYear(Value: Integer);
begin
  FCreateRec.Year := Value;
end;

procedure TReturnCreate.Set_rcYourRef(const Value: WideString);
begin
  FCreateRec.YourRef := Value;
end;


procedure TReturnCreate.InitObjects;
begin
  FParentO := nil;
  FParentI := nil;

  FParentLineO := nil;
  FParentLineI := nil;

  FToolkit := nil;
end;

function TReturnCreate.GetDocType: TDocTypes;
var
  ParentType : TDocTypes;
begin
  Result := dtSRN;
  if Assigned(FParentI) then
    ParentType := FParentI.thDocType
  else
    ParentType := (FParentLineI as ITransactionLine2).tlDocType;

  Case ParentType of
    dtPIN, dtPDN,
    dtSRN         :  Result := dtPRN;
    dtSIN, dtSDN  :  Result := dtSRN;
  end;
end;


//=======================================================================

constructor TReturnCreateFromTrans.Create(Parent: TTransaction; const Toolkit : IToolkit);
var
  Res : SmallInt;
  Path : PChar;
  sPath : string;
  si : SmallInt;
  MC : WordBool;
begin
  if RetMOn then
  begin
    Inherited Create (ComServer.TypeLib, ITransactionReturnCreate);
    InitObjects;
    FParentO := Parent;
    FParentI := FParentO;
    FillChar(FCreateRec, SizeOf(FCreateRec), 0);
    FCreateRec.CreateDate := FParentI.thTransDate;
    FCreateRec.Period := FParentI.thPeriod;
    FCreateRec.Year := FParentI.thYear;
    FCreateRec.ParentOurRef := FParentI.thOurRef;

    Path := StrAlloc(255);
    Try
      with Toolkit do
      begin
        sPath := Configuration.DataDirectory;
        si := Enterprise.enCurrencyVersion;
      end;

      if si in [1, 2] then
        MC := True
      else
        MC := False;

      StrPCopy(Path, sPath);


      Res := SP_INITDLLPATH(Path, MC);
    {  if Res <> 0 then
        raise Exception.Create('Unable to load library ENTDLLSP.DLL');}
    Finally
      StrDispose(Path);
      Res := SetSPBackDoor;
      if Res = 0 then
        Res := SP_INITDLL;

      //PR: 24/11/2011
      FLibraryLoaded := Res = 0;

      if Res = -1 then
        raise Exception.Create('Unable to load library ENTDLLSP.DLL')
      else
      if Res <> 0 then
        raise Exception.Create('Error ' + IntToStr(Res) + ' opening SPToolkit');
    End;
  end
  else
    raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Goods Returns');
end;



function TReturnCreateFromTrans.Execute: Integer;
var
  TransRec : InvRec;
begin
  //PR: 24/11/2011 Added check that object hasn't been finalised
  if FLibraryLoaded then
  begin
    TransRec := FParentO.Trans;
    if not FCreateRec.AddToExistingReturn then
      Blank(FCreateRec.ReturnOurRef, SizeOf(FCreateRec.ReturnOurRef));

    Result := SP_CreateReturn(@FCreateRec, SizeOf(FCreateRec), @TransRec, SizeOf(TransRec));
  end
  else
    Result := 20000;

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (611, Result);
end;

destructor TReturnCreateFromTrans.Destroy;
begin
  InitObjects;
  //PR: 24/11/2011
  if FLibraryLoaded then
    SP_CloseDll;
  inherited;
end;

//=========================================================================

constructor TReturnCreateFromLine.Create(Parent : TTransactionLine; const Toolkit : IToolkit);
var
  Res : SmallInt;
  Path : PChar;
  sPath : string;
  si : SmallInt;
  MC : WordBool;
begin
  if RetMOn then
  begin
    Inherited Create (ComServer.TypeLib, ITransactionLineReturnCreate);
    InitObjects;
    FParentLineO := Parent;
    FParentLineI := FParentLineO;

    FParentO := FParentLineO.ParentTrans as TTransaction;
    FParentI := FParentO;
    FillChar(FCreateRec, SizeOf(FCreateRec), 0);
    FCreateRec.CreateDate := FParentI.thTransDate;
    FCreateRec.Period := FParentI.thPeriod;
    FCreateRec.ParentOurRef := FParentI.thOurRef;
    FCreateRec.Year := FParentI.thYear;
    FCreateRec.rcAbsLineNo := Parent.TL.ABSLineNo;

    Path := StrAlloc(255);
    Try
      with Toolkit do
      begin
        sPath := Configuration.DataDirectory;
        si := Enterprise.enCurrencyVersion;
      end;

      if si in [1, 2] then
        MC := True
      else
        MC := False;

      StrPCopy(Path, sPath);


      Res := SP_INITDLLPATH(Path, MC);
    {  if Res <> 0 then
        raise Exception.Create('Unable to load library ENTDLLSP.DLL');}
    Finally
      StrDispose(Path);
      Res := SetSPBackDoor;
      if Res = 0 then
        Res := SP_INITDLL;

      //PR: 24/11/2011
      FLibraryLoaded := Res = 0;

      if Res = -1 then
        raise Exception.Create('Unable to load library ENTDLLSP.DLL')
      else
      if Res <> 0 then
        raise Exception.Create('Error ' + IntToStr(Res) + ' opening SPToolkit');
    End;
  end
  else
    raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Goods Returns');
end;


destructor TReturnCreateFromLine.Destroy;
begin
  InitObjects;
  //PR: 24/11/2011
  if FLibraryLoaded then
    SP_CloseDll;
  inherited;
end;

function TReturnCreateFromLine.Execute: ITransaction;
var
  TransRec : InvRec;
  Res : SmallInt;
  OldPos : longint;
  OldIdx : TTransactionIndex;
begin
  Result := nil;
  //PR: 24/11/2011 Added check that object hasn't been finalised
  if FLibraryLoaded then
  begin
    TransRec := FParentO.Trans;
    if not FCreateRec.AddToExistingReturn then
      Blank(FCreateRec.ReturnOurRef, SizeOf(FCreateRec.ReturnOurRef));

    Res := SP_CreateReturn(@FCreateRec, SizeOf(FCreateRec), @TransRec, SizeOf(TransRec));
    FCreateRec.rcStatus := Res;

    if Res = 0 then
    begin
      OldIdx := FToolkit.Transaction.Index;
      FToolkit.Transaction.SavePosition;
      OldPos := FToolkit.Transaction.Position;
      FToolkit.Transaction.Index := thIdxOurRef;
      Res := FToolkit.Transaction.GetEqual(FToolkit.Transaction.BuildOurRefIndex(FCreateRec.ReturnOurRef));

      if Res = 0 then
        Result := FToolkit.Transaction.Update;

      FToolkit.Transaction.Index := OldIdx;
      FToolkit.Transaction.Position := OldPos;
      FToolkit.Transaction.RestorePosition;

    end;
  end
  else
    Res := 20000;

  If (Res <> 0) Then
    LastErDesc := Ex_ErrorDescription (611, Res);
end;

function TReturnCreateFromLine.Get_rcStatus: Integer;
begin
  Result := FCreateRec.rcStatus;
end;

function TReturnCreate.Get_rcDirectCustomerRepair: WordBool;
begin
  Result := FCreateRec.DirectCustomerRepair;
end;

function TReturnCreate.Get_rcSupplier: WideString;
begin
  Result := FCreateRec.Supplier;
end;

procedure TReturnCreate.Set_rcDirectCustomerRepair(Value: WordBool);
begin
  FCreateRec.DirectCustomerRepair := Value;
end;

procedure TReturnCreate.Set_rcSupplier(const Value: WideString);
begin
  FCreateRec.Supplier := Value;
end;

function TReturnCreate.Get_rcLocation: WideString;
begin
  Result := FCreateRec.Location;
end;

procedure TReturnCreate.Set_rcLocation(const Value: WideString);
begin
  FCreateRec.Location := Value;
end;

procedure TReturnCreate.Finalize;
begin
  //PR: 24/11/2011 Explicitly unload conversion dll - needed by .net programs where garbage collection might not
  //destroy the object in a timely manner.
  if FLibraryLoaded then
  begin
    SP_CLOSEDLL;
    FLibraryLoaded := False;
  end;
end;

{ TReturnAction }

constructor TReturnAction.Create(ParentO: TTransaction; const Toolkit : TObject);
var
  Res : SmallInt;
  Path : PChar;
  sPath : string;
  si : SmallInt;
  MC : WordBool;
begin
  if RetMOn then
  begin
    InitObjects;
    Inherited Create (ComServer.TypeLib, IReturnAction);

    FToolkit := Toolkit;
    FParentO := ParentO;

    FillChar(FActionRec, SizeOf(FActionRec), 0);
    Path := StrAlloc(255);
    Try
      with Toolkit as TToolkit do
      begin
        sPath := ConfigI.DataDirectory;
        si := EnterpriseI.enCurrencyVersion;
      end;

      if si in [1, 2] then
        MC := True
      else
        MC := False;

      StrPCopy(Path, sPath);


      Res := SP_INITDLLPATH(Path, MC);
    {  if Res <> 0 then
        raise Exception.Create('Unable to load library ENTDLLSP.DLL');}
    Finally
      StrDispose(Path);
      Res := SetSPBackDoor;
      if Res = 0 then
        Res := SP_INITDLL;

      //PR: 24/11/2011
      FLibraryLoaded := Res = 0;

      if Res = -1 then
        raise Exception.Create('Unable to load library ENTDLLSP.DLL')
      else
      if Res <> 0 then
        raise Exception.Create('Error ' + IntToStr(Res) + ' opening SPToolkit');
    End;
  end
  else
    raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Goods Returns');
end;

destructor TReturnAction.Destroy;
begin
  //PR: 24/11/2011
  if FLibraryLoaded then
    SP_CloseDll;
  InitObjects;
  inherited;
end;

function TReturnAction.Execute: Integer;
var
  TransRec : InvRec;
  oTrans : ITransaction;
begin
  //PR: 24/11/2011 Added check that object hasn't been finalised
  if FLibraryLoaded then
  begin
    TransRec := FParentO.Trans;
    oTrans := FParentO;
    if FActionRec.Action = raRepair then
    begin
      if TransRec.InvDocHed = PRN then
        FActionRec.ReturnDocType := dtPIN
      else
        FActionRec.ReturnDocType := dtSIN;
    end;
    Result := CheckForValidLines(oTrans);
    if Result = 0 then
      Result := SP_ActionReturn(@FActionRec, SizeOf(FActionRec), @TransRec, SizeOf(TransRec));

    if (Result = 0) and (FActionRec.ReturnDocType = dtPOR) then
    begin
      if Assigned(FB2BI) then
        FB2BI := nil;

      FB2BO := TBackToBackOrder.Create;
      FB2BI := FB2BO;
      FB2BO.LCount := FActionRec.B2BSORLineCount;
      FB2BO.OurRef := FActionRec.B2BSORRef;
      FB2BO.Toolkit := FToolkit;
      FB2BO.SPOpen := True;
    end;
  end
  else
    Result := 20000;


  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (610, Result);

end;


function TReturnAction.Get_raAllocCreditToOriginalDoc: WordBool;
begin
  Result := FActionRec.CreditOriginal;
end;


function TReturnAction.Get_raAction: TReturnActionType;
begin
  Result := TReturnActionType(FActionRec.Action);
end;

function TReturnAction.Get_raApplyCurrentPrice: WordBool;
begin
  Result := FActionRec.ApplyCurrentPrice;
end;

function TReturnAction.Get_raApplyRestockingCharge: WordBool;
begin
  Result := FActionRec.ApplyRestockingCharge;
end;

function TReturnAction.Get_raReplacementDocType: TDocTypes;
begin
  Result := TDocTypes(FActionRec.ReturnDocType);
end;

function TReturnAction.Get_raReturnedItems: TReturnedItemsDisposalType;
begin
  Result := TReturnedItemsDisposalType(FActionRec.ReturnedItems);
end;

procedure TReturnAction.Set_raAllocCreditToOriginalDoc(Value: WordBool);
begin
  FActionRec.CreditOriginal := Value;
end;


procedure TReturnAction.Set_raAction(Value: TReturnActionType);
begin
  if Value in [raCreditAndWriteOff..raIssueBackToStock] then
    FActionRec.Action := Value
  else
    raise EValidation.Create('Invalid ActionType (' + IntToStr(Value) + ')');
end;

procedure TReturnAction.Set_raApplyCurrentPrice(Value: WordBool);
begin
  FActionRec.ApplyCurrentPrice := Value;
end;

procedure TReturnAction.Set_raApplyRestockingCharge(Value: WordBool);
begin
  FActionRec.ApplyRestockingCharge := Value;
end;

procedure TReturnAction.Set_raReplacementDocType(Value: TDocTypes);
begin
  if Value in [dtSIN, dtSOR, dtSDN, dtPIN, dtPOR, dtPDN] then
    FActionRec.ReturnDocType := Value
  else
    raise EValidation.Create('Invalid DocType (' + IntToStr(Value) + ')');
end;

procedure TReturnAction.Set_raReturnedItems(
  Value: TReturnedItemsDisposalType);
begin
  FActionRec.ReturnedItems := Value;
end;

function TReturnAction.CheckForValidLines(
  const oTrans: ITransaction): Integer;
//Check that we have at least one line with woff or repair qty
var
  i : integer;
  FoundRepairLine,
  FoundWoffLine : Boolean;

  function RepairWanted : Boolean;
  begin
    Result := (FActionRec.Action in [raRepair, raIssueBackToStock]) or
              ((FActionRec.Action in [raCreditAndReplace, raCreditAndWriteOff]) and (FActionRec.ReturnedItems = 1));
  end;

  function WriteOffWanted : Boolean;
  begin
    Result := ((FActionRec.Action in [raCreditAndWriteOff, raWriteOff]) and (FActionRec.ReturnedItems = 0)) or
              ((FActionRec.Action = raCreditAndReplace) and (FActionRec.ReturnedItems = 0));
  end;

begin
  FoundRepairLine := False;
  FoundWoffLine := False;

  with oTrans do
  for i := 1 to thLines.thLineCount do
  begin
    with (thLines[i] as ITransactionLine4).tlAsReturn do
    begin
      FoundRepairLine := FoundRepairLine or
     ((Abs(tlrQtyRepaired) > 0) and RepairWanted);
     FoundWoffLine := FoundWoffLine or
     ((Abs(tlrQtyWrittenOff) > 0) and WriteOffWanted);
    end;
  end;

  if RepairWanted and not FoundRepairLine then
    Result := 30001
  else
  if WriteOffWanted and not FoundWoffLine then
    Result := 30002
  else
    Result := 0;

end;

function TReturnAction.Get_raBackToBack: IBackToBackOrder;
begin
  Result := FB2BI;
end;

procedure TReturnAction.InitObjects;
begin
  FB2BO := nil;
  FB2BI := nil;
end;

procedure TReturnAction.Finalize;
begin
  //PR: 24/11/2011 Explicitly unload conversion dll - needed by .net programs where garbage collection might not
  //destroy the object in a timely manner.
  if FLibraryLoaded then
  begin
    SP_CLOSEDLL;
    FLibraryLoaded := False;
  end;
end;

end.
