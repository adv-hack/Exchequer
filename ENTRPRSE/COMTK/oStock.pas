unit oStock;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve, oAddr,
     MiscFunc, BtrvU2, oStock2, oStkLoc, oNotes, ExBtTH1U, oQtyBrk,
     oStkBOM, oStkBOML, oSerial, GlobList, oLinks, oAltStk, oMultBin,
     oCSAnal, oMultiBuy, MultiBuyVar;

type
  TStock = class(TBtrieveFunctions, IStock, IBrowseInfo, IStock2, IStock3, IStock4, IStock5, IStock6, IStock7)
  protected
    // Note: All properties protected to allow descendants access
    FStock    : TBatchSKRec;

    // Bill Of Materials sub-object
    {FBillMatO : TStockBOM;
    FBillMatI : IStockBOMKit;}
    FBillMatO : TStockBOMList;
    FBillMatI : IStockBOMList;

    // Cover sub-object
    FCoverO   : TStockCover;
    FCoverI   : IStockCover;

    // Intrastat sub-object
    FIntraO   : TStockIntrastat;
    FIntraI   : IStockIntrastat;

    // Quantity Breaks sub-object
    FQtyBrkO     : TQuantityBreak;
    FQtyBrkI     : IQuantityBreak;

    // Re-order sub-object
    FReorderO : TStockReorder;
    FReorderI : IStockReorder;

    // Sales Bands sub-objeccts
    FSalesBandO : Array[1..8] Of TStockSalesBand;
    FSalesBandI : Array[1..8] Of IStockSalesBand;

    // Serial/Batch Numbers sub-object
    FSerialO  : TSerialBatch;
    FSerialI  : ISerialBatch;

    // Stock Location sub-object
    FStkLocO  : TStockLocation;
    FStkLocI  : IStockLocation;

    FAltStockO : TAltStockCode;
    FAltStockI : IAltStockCode;

    FEquivStockO : TAltStockCode;
    FEquivStockI : IAltStockCode2;

    FSuperStockO : TAltStockCode;
    FSuperStockI : IAltStockCode2;

    FOppStockO : TAltStockCode;
    FOppStockI : IAltStockCode2;


    // Where Used sub-object
    FWhereO   : TStockBOM;
    FWhereI   : IStockWhereUsed;

    FNotesO   : TNotes;
    FNotesI   : INotes;

    FIntfType : TInterfaceMode;
    FToolkit  : TObject;
    FParentSK : TStock;

    FLinksO   : TLinks;
    FLinksI   : ILinks;

    FBinO     : TMultiBin;
    FBinI     : IMultiBin;

    FSalesAnalysisO : TStockSalesAnalysis;
    FSalesAnalysisI : IStockSalesAnalysis;

    FMultiBuyO      : TMultiBuy;
    FMultiBuyI      : IMultiBuy;


    FRefreshBOM : Boolean;

    // IStock
    function  Get_stCode: WideString; safecall;
    procedure Set_stCode(const Value: WideString); safecall;
    function  Get_stDesc(Index: Integer): WideString; safecall;
    procedure Set_stDesc(Index: Integer; const Value: WideString); safecall;
    function  Get_stAltCode: WideString; safecall;
    procedure Set_stAltCode(const Value: WideString); safecall;
    function  Get_stType: TStockType; safecall;
    procedure Set_stType(Value: TStockType); safecall;
    function  Get_stSalesGL: Integer; safecall;
    procedure Set_stSalesGL(Value: Integer); safecall;
    function  Get_stCOSGL: Integer; safecall;
    procedure Set_stCOSGL(Value: Integer); safecall;
    function  Get_stPandLGL: Integer; safecall;
    procedure Set_stPandLGL(Value: Integer); safecall;
    function  Get_stBalSheetGL: Integer; safecall;
    procedure Set_stBalSheetGL(Value: Integer); safecall;
    function  Get_stWIPGL: Integer; safecall;
    procedure Set_stWIPGL(Value: Integer); safecall;
    function  Get_stBelowMinLevel: WordBool; safecall;
    procedure Set_stBelowMinLevel(Value: WordBool); safecall;
    function  Get_stFolioNum: Integer; safecall;
    function  Get_stParentCode: WideString; safecall;
    procedure Set_stParentCode(const Value: WideString); safecall;
    function  Get_stSuppTemp: WideString; safecall;
    procedure Set_stSuppTemp(const Value: WideString); safecall;
    function  Get_stUnitOfStock: WideString; safecall;
    procedure Set_stUnitOfStock(const Value: WideString); safecall;
    function  Get_stUnitOfSale: WideString; safecall;
    procedure Set_stUnitOfSale(const Value: WideString); safecall;
    function  Get_stUnitOfPurch: WideString; safecall;
    procedure Set_stUnitOfPurch(const Value: WideString); safecall;
    function  Get_stCostPriceCur: Integer; safecall;
    procedure Set_stCostPriceCur(Value: Integer); safecall;
    function  Get_stCostPrice: Double; safecall;
    procedure Set_stCostPrice(Value: Double); safecall;
    function  Get_stSalesUnits: Double; safecall;
    procedure Set_stSalesUnits(Value: Double); safecall;
    function  Get_stPurchUnits: Double; safecall;
    procedure Set_stPurchUnits(Value: Double); safecall;
    function  Get_stVATCode: WideString; safecall;
    procedure Set_stVATCode(const Value: WideString); safecall;
    function  Get_stCostCentre: WideString; safecall;
    procedure Set_stCostCentre(const Value: WideString); safecall;
    function  Get_stDepartment: WideString; safecall;
    procedure Set_stDepartment(const Value: WideString); safecall;
    function  Get_stQtyInStock: Double; safecall;
    function  Get_stQtyPosted: Double; safecall;
    function  Get_stQtyAllocated: Double; safecall;
    function  Get_stQtyOnOrder: Double; safecall;
    function  Get_stQtyMin: Double; safecall;
    procedure Set_stQtyMin(Value: Double); safecall;
    function  Get_stQtyMax: Double; safecall;
    procedure Set_stQtyMax(Value: Double); safecall;
    function  Get_stBinLocation: WideString; safecall;
    procedure Set_stBinLocation(const Value: WideString); safecall;
    function  Get_stCover: IStockCover; safecall;
    function  Get_stIntrastat: IStockIntrastat; safecall;
    function  Get_stReorder: IStockReorder; safecall;
    function  Get_stAnalysisCode: WideString; safecall;
    procedure Set_stAnalysisCode(const Value: WideString); safecall;
    function  Get_stSalesBands(const Band: WideString): IStockSalesBand; safecall;
    function  Get_stTimeChange: WideString; safecall;
    function  Get_stInclusiveVATCode: WideString; safecall;
    procedure Set_stInclusiveVATCode(const Value: WideString); safecall;
    function  Get_stOperator: WideString; safecall;
    procedure Set_stOperator(const Value: WideString); safecall;
    function  Get_stSupplier: WideString; safecall;
    procedure Set_stSupplier(const Value: WideString); safecall;
    function  Get_stSupplierI: IAccount; safecall;
    function  Get_stDefaultLineType: TTransactionLineType; safecall;
    procedure Set_stDefaultLineType(Value: TTransactionLineType); safecall;
    function  Get_stValuationMethod: TStockValuationType; safecall;
    procedure Set_stValuationMethod(Value: TStockValuationType); safecall;
    function  Get_stQtyPicked: Double; safecall;
    function  Get_stLastUsed: WideString; safecall;
    function  Get_stBarCode: WideString; safecall;
    procedure Set_stBarCode(const Value: WideString); safecall;
    function  Get_stLocation: WideString; safecall;
    procedure Set_stLocation(const Value: WideString); safecall;
    function  Get_stPricingMethod: TStockPricingMethod; safecall;
    procedure Set_stPricingMethod(Value: TStockPricingMethod); safecall;
    function  Get_stShowQtyAsPacks: WordBool; safecall;
    procedure Set_stShowQtyAsPacks(Value: WordBool); safecall;
    function  Get_stUseKitPrice: WordBool; safecall;
    procedure Set_stUseKitPrice(Value: WordBool); safecall;
    function  Get_stUserField1: WideString; safecall;
    procedure Set_stUserField1(const Value: WideString); safecall;
    function  Get_stUserField2: WideString; safecall;
    procedure Set_stUserField2(const Value: WideString); safecall;
    function  Get_stUserField3: WideString; safecall;
    procedure Set_stUserField3(const Value: WideString); safecall;
    function  Get_stUserField4: WideString; safecall;
    procedure Set_stUserField4(const Value: WideString); safecall;
    function  Get_stShowKitOnPurchase: WordBool; safecall;
    procedure Set_stShowKitOnPurchase(Value: WordBool); safecall;
    function  Get_stImageFile: WideString; safecall;
    procedure Set_stImageFile(const Value: WideString); safecall;
    function  Get_stWebLiveCatalog: WideString; safecall;
    procedure Set_stWebLiveCatalog(const Value: WideString); safecall;
    function  Get_stWebPrevCatalog: WideString; safecall;
    procedure Set_stWebPrevCatalog(const Value: WideString); safecall;
    function  Get_stUseForEbus: WordBool; safecall;
    procedure Set_stUseForEbus(Value: WordBool); safecall;
    function  Get_stLocationList: IStockLocation; safecall;
    function  Get_stNotes: INotes; safecall;
    function  Get_stQtyFree: Double; safecall;
    function  Get_stQtyBreaks: IQuantityBreak; safecall;
    function  Get_stAnalysisCodeI: IJobAnalysis; safecall;
    function  Get_stWhereUsed: IStockWhereUsed; safecall;
    function  Get_stBillOfMaterials: IStockBOMList; safecall;
    function  Get_stSerialBatch: ISerialBatch; safecall;

    //IStock2 methods
    function Get_stBOMProductionTime: Integer; safecall;
    function Get_stQtyAllocWOR: Double; safecall;
    function Get_stQtyFreeze: Double; safecall;
    function Get_stQtyIssuedWOR: Double; safecall;
    function Get_stQtyPickedWOR: Double; safecall;
    function Get_stQtyStockTake: Double; safecall;
    procedure Set_stQtyStockTake(Value: Double); safecall;
    function Get_stWOPAssemblyDays: Integer; safecall;
    procedure Set_stWOPAssemblyDays(Value: Integer); safecall;
    function Get_stWOPAssemblyHours: Integer; safecall;
    procedure Set_stWOPAssemblyHours(Value: Integer); safecall;
    function Get_stWOPAssemblyMins: Integer; safecall;
    procedure Set_stWOPAssemblyMins(Value: Integer); safecall;
    function Get_stWOPAutoCalcTime: WordBool; safecall;
    procedure Set_stWOPAutoCalcTime(Value: WordBool); safecall;
    function Get_stWOPIssuedWIPGL: Integer; safecall;
    procedure Set_stWOPIssuedWIPGL(Value: Integer); safecall;
    function Get_stWOPMinEconBuild: Double; safecall;
    procedure Set_stWOPMinEconBuild(Value: Double); safecall;
    function Get_stWOPRoLeadTime: Integer; safecall;
    procedure Set_stWOPRoLeadTime(Value: Integer); safecall;
    function Get_stUsesBins: WordBool; safecall;
    procedure Set_stUsesBins(Value: WordBool); safecall;
    function Get_stStockTakeQtyChanged: WordBool; safecall;
    function Get_stShowKitOnSales: WordBool; safecall;
    procedure Set_stShowKitOnSales(Value: WordBool); safecall;
    function Get_stLinks: ILinks; safecall;
    function Get_stAltStockCode: IAltStockCode; safecall;
    function Get_stMultiBin: IMultiBin; safecall;
    function Get_stSalesAnalysis: IStockSalesAnalysis; safecall;
    function Print(PrintAs: TStockPrintMode): IPrintJob; safecall;
    function Discontinue(RetainComponents: WordBool): Integer; safecall;
    function DoDiscontinue(const StockCode : string; RetainComponents: WordBool): Integer;

    //IStock3
    function Get_stEquivalent: IAltStockCode2; safecall;
    function Get_stSupersededBy: IAltStockCode2; safecall;
    function Get_stOpportunity: IAltStockCode2; safecall;

    function  Add: IStock; safecall;
    function  Update: IStock; safecall;
    function  Clone: IStock; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;

    function  Get_Index: TStockIndex; safecall;
    procedure Set_Index(Value: TStockIndex); safecall;

    function  BuildCodeIndex(const StockCode: WideString): WideString; safecall;
    function  BuildFolioIndex(Folio: Integer): WideString; safecall;
    function  BuildParentIndex(const ParentCode: WideString; const ChildCode: WideString): WideString; safecall;
    function  BuildDescIndex(const Desc: WideString): WideString; safecall;
    function  BuildSupplierIndex(const AccountCode: WideString;
                                       CostCurrency: Integer;
                                 const StockCode: WideString): WideString; safecall;
    function  BuildPandLIndex(PandLGL: Integer; const StockCode: WideString): WideString; safecall;
    function  BuildAltCodeIndex(const AlternateCode: WideString): WideString; safecall;
    function  BuildBinLocIndex(const BinLocation: WideString): WideString; safecall;
    function  BuildBarCodeIndex(const BarCode: WideString): WideString; safecall;

    Function  GetSalesBandPrice (Const BandNo : Byte) : Double;
    Procedure SetSalesBandPrice (Const BandNo : Byte; Const Value : Double);
    Function  GetSalesBandCcy (Const BandNo : Byte) : Integer;
    Procedure SetSalesBandCcy (Const BandNo : Byte; Const Value : Integer);

    //IStock4
    function Get_stSalesWarrantyLength: Integer; safecall;
    procedure Set_stSalesWarrantyLength(Value: Integer); safecall;
    function Get_stSalesWarrantyUnits: TWarrantyUnitsType; safecall;
    procedure Set_stSalesWarrantyUnits(Value: TWarrantyUnitsType); safecall;
    function Get_stManufacturerWarrantyLength: Integer; safecall;
    procedure Set_stManufacturerWarrantyLength(Value: Integer); safecall;
    function Get_stManufacturerWarrantyUnits: TWarrantyUnitsType; safecall;
    procedure Set_stManufacturerWarrantyUnits(Value: TWarrantyUnitsType); safecall;
    function Get_stSalesReturnGL: Integer; safecall;
    procedure Set_stSalesReturnGL(Value: Integer); safecall;
    function Get_stPurchaseReturnGL: Integer; safecall;
    procedure Set_stPurchaseReturnGL(Value: Integer); safecall;
    function Get_stRestockCharge: Double; safecall;
    procedure Set_stRestockCharge(Value: Double); safecall;
    function Get_stSalesReturnQty: Double; safecall;
    function Get_stPurchaseReturnQty: Double; safecall;
    function Get_stRestockFlag: TRestockChargeType; safecall;
    procedure Set_stRestockFlag(Value: TRestockChargeType); safecall;

    //IStock5
    function Get_stMultiBuy: IMultiBuy; safecall;

    //PR: 25/10/2011 v6.9 IStock6
    function Get_stUserField5: WideString; safecall;
    procedure Set_stUserField5(const Value: WideString); safecall;
    function Get_stUserField6: WideString; safecall;
    procedure Set_stUserField6(const Value: WideString); safecall;
    function Get_stUserField7: WideString; safecall;
    procedure Set_stUserField7(const Value: WideString); safecall;
    function Get_stUserField8: WideString; safecall;
    procedure Set_stUserField8(const Value: WideString); safecall;
    function Get_stUserField9: WideString; safecall;
    procedure Set_stUserField9(const Value: WideString); safecall;
    function Get_stUserField10: WideString; safecall;
    procedure Set_stUserField10(const Value: WideString); safecall;

    // MH 09/09/2014 v7.1 ABSEXCH-15052: IStock7
    function Get_stIsService: WordBool; safecall;
    procedure Set_stIsService(Value: WordBool); safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;
    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Function TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt; Override;

    // Internal methods
    Procedure CloneDetails (Const SKDets : TBatchSKRec);
    Procedure InitNewStock;
    Procedure InitObjects;
    Procedure LoadDetails (Const StkDets : TBatchSKRec; Const LockPos : LongInt);
    Function GetAltStock : TAltStockCode;
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const ParentSK : TStock;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);
    Destructor Destroy; override;

    Function GetCloneInterface (Const StkCode : ShortString) : IStock;
    procedure RefreshBOMList;
    property AltStock : TAltStockCode read GetAltStock;
  End; { TStock }

  Function CreateTStock (Const Toolkit : TObject; Const ClientId : Integer) : TStock;

implementation

uses ComServ, DLLSK01U, ETStrU, BtKeys1U, DllErrU, oToolkit,
     EnterpriseForms_TLB,    // Type Library for Form Printing Toolkit
     oPrntJob,               // COM Toolkit Print Job Object
     Varrec2U,
     Profile,

     //PR: 14/02/2012 ABSEXCH-9795
     QtyBreakVar,

     //PR: 17/02/2014 ABSEXCH-14477
     HistoryFuncs, SysU2;

{-------------------------------------------------------------------------------------------------}

Function CreateTStock (Const Toolkit : TObject; Const ClientId : Integer) : TStock;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTStock }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TStock object
  BtrIntf^.Open_System(StockF, StockF);
  BtrIntf^.Open_System(PwrdF,  PwrdF);   { Stock Notes }

  //PR: 14/02/2012 Change to use new file ABSEXCH-9795
  BtrIntf^.Open_System(QtyBreakF,  QtyBreakF);   { Quantity Breaks }

  //PR: 12/11/2012 ABSEXCH-12635 Still need MiscF for Links
  BtrIntf^.Open_System(MiscF,  MiscF);   { Quantity Breaks }
  BtrIntf^.Open_System(MLocF,  MLocF);   { Sales Analysis }
  BtrIntf^.Open_System(NHistF, NHistF);   { Sales Analysis History}
  BtrIntf^.Open_System(MultiBuyF, MultiBuyF);  {Multi-Buy Discounts}

  // Create bas TAccount object
  Result := TStock.Create(imGeneral, Toolkit, Nil, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([StockF, MLocF, PwrdF, NHistF, MiscF]);

End; { CreateTStock }

{-------------------------------------------------------------------------------------------------}

Constructor TStock.Create (Const IType    : TInterfaceMode;
                           Const Toolkit  : TObject;
                           Const ParentSK : TStock;
                           Const BtrIntf  : TCtkTdPostExLocalPtr);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IStock7, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := StockF;

  // Initialise variables
  FillChar (FStock, SizeOf(FStock), #0);
  InitObjects;

  // Setup Link for child Stock objects to parent object
  FIntfType := IType;
  FToolkit := Toolkit;
  FRefreshBOM := False;
  If Assigned(ParentSK) Then Begin
    FParentSK := ParentSK;
    FIndex := ParentSK.FIndex;
  End { If Assigned(ParentSK) }
  Else Begin
    FParentSK := Self;
    Set_Index(stIdxCode);
  End; { Else }

  FObjectID := tkoStock;
End; { Create }

{-----------------------------------------}

Destructor TStock.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TStock.InitObjects;
Var
  I : Byte;
Begin { Destroy }
  // Bill Of Materials sub-object
  FBillMatO := NIL;
  FBillMatI := NIL;

  // Cover sub-object
  FCoverO := NIL;
  FCoverI := NIL;

  // Intrastat sub-object
  FIntraO := NIL;
  FIntraI := NIL;

  FNotesO := NIL;
  FNotesI := NIL;

  // Quantity Breaks sub-object
  FQtyBrkO := NIL;
  FQtyBrkI := NIL;

  // Re-order sub-object
  FReorderO := NIL;
  FReorderI := NIL;

  For I := Low(FSalesBandO) To High(FSalesBandO) Do Begin
    FSalesBandO[I] := NIL;
    FSalesBandI[I] := NIL;
  End; { For I }

  // Serial/Batch Numbers sub-object
  FSerialO := NIL;
  FSerialI := NIL;

  FStkLocO := Nil;
  FStkLocI := Nil;

  // Where Used sub-object
  FWhereO := NIL;
  FWhereI := NIL;

  FParentSK := Nil;
  FToolkit := Nil;

  FLinksO := nil;
  FLinksI := nil;

  FSalesAnalysisO := nil;
  FSalesAnalysisI := nil;

  FMultiBuyO  := nil;
  FMultiBuyI  := nil;

End; { Destroy }

{-----------------------------------------}

Procedure TStock.CopyDataRecord;
Begin { CopyDataRecord }
  CopyExStockToTkStock(FBtrIntf^.LStock, FStock);
End; { CopyDataRecord }

{-----------------------------------------}

// Used by Btrieve functions to interface to Toolkit
Function TStock.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode : SmallInt;                     
  KeyS      : Str255;
oPos, nPos : LongInt;
begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';

  With FBtrIntf^ Do Begin
    KeyS := SetKeyString(BtrOp, SearchKey);
    BtrOpCode := BtrOp;

(** HM 10/08/01: Debugging added when attempting to determine why GetNext was jumoping back to the first record
FBtrIntF^.LGetPos(FFileNo, oPos);
FBtrIntF^.LGetDirect(FFileNo, FIndex, 0);
FBtrIntF^.LGetPos(FFileNo, nPos);
If (oPos <> nPos) Then ShowMessage ('.GetDataRecord pos changed by Ex_StoreStock');
**)

    // Get record
    Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

    If (Result = 0) Then
      // Convert to Toolkit structure
      CopyDataRecord;

    FKeyString := KeyS;
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (30, Result);
End; { GetDataRecord }

{-----------------------------------------}

function TStock.Get_stCode: WideString;
begin
  Result := FStock.StockCode;
end;

procedure TStock.Set_stCode(const Value: WideString);
begin
  FStock.StockCode := FullStockCode(Value);
end;

{-----------------------------------------}

function TStock.Get_stAltCode: WideString;
begin
  Result := FStock.AltCode;
end;

procedure TStock.Set_stAltCode(const Value: WideString);
begin
  FStock.AltCode := Value;
end;

{-----------------------------------------}

function TStock.Get_stAnalysisCode: WideString;
begin
  Result := FStock.JAnalCode;
end;

procedure TStock.Set_stAnalysisCode(const Value: WideString);
begin
  FStock.JAnalCode := FullJACode(UpperCase(Value));
end;

{-----------------------------------------}

function TStock.Get_stBalSheetGL: Integer;
begin
  Result := FStock.NomCodes[4];
end;

procedure TStock.Set_stBalSheetGL(Value: Integer);
begin
  FStock.NomCodes[4] := Value;
end;

{-----------------------------------------}

function TStock.Get_stBarCode: WideString;
begin
  Result := FStock.stBarCode;
end;

procedure TStock.Set_stBarCode(const Value: WideString);
begin
  FStock.stBarCode := Value;
end;

{-----------------------------------------}

function TStock.Get_stBelowMinLevel: WordBool;
begin
  Result := FStock.MinFlg;
end;

procedure TStock.Set_stBelowMinLevel(Value: WordBool);
begin
  FStock.MinFlg := Value;
end;

{-----------------------------------------}

function TStock.Get_stBinLocation: WideString;
begin
  Result := FStock.BinLoc;
end;

procedure TStock.Set_stBinLocation(const Value: WideString);
begin
  FStock.BinLoc := Value;
end;

{-----------------------------------------}

function TStock.Get_stCOSGL: Integer;
begin
  Result := FStock.NomCodes[2];
end;

procedure TStock.Set_stCOSGL(Value: Integer);
begin
  FStock.NomCodes[2] := Value;
end;

{-----------------------------------------}

function TStock.Get_stCostCentre: WideString;
begin
  Result := FStock.CC;
end;

procedure TStock.Set_stCostCentre(const Value: WideString);
begin
  FStock.CC := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TStock.Get_stCostPrice: Double;
begin
  Result := FStock.CostPrice;
end;

procedure TStock.Set_stCostPrice(Value: Double);
begin
  FStock.CostPrice := Value;
end;

{-----------------------------------------}

function TStock.Get_stCostPriceCur: Integer;
begin
  Result := FStock.PCurrency;
end;

procedure TStock.Set_stCostPriceCur(Value: Integer);
begin
  FStock.PCurrency := ValidateCurrencyNo(Value);

  If Assigned(FBillMatO) Then
    FBillMatO.SetParentCostCcy(FStock.PCurrency);
end;

{-----------------------------------------}

function TStock.Get_stCover: IStockCover;
begin
  { Check Cover sub-object has been initialised }
  If (Not Assigned(FCoverO)) Then Begin
    { Create and initialise Cover sub-object }
    FCoverO := TStockCover.Create(@FStock);

    FCoverI := FCoverO;
  End; { If (Not Assigned(FCoverO)) }

  Result := FCoverI;
end;

{-----------------------------------------}

function TStock.Get_stDefaultLineType: TTransactionLineType;
begin
  Case FStock.StkLinkLT of
    0 : Result := tlTypeNormal;
    1 : Result := tlTypeLabour;
    2 : Result := tlTypeMaterials;
    3 : Result := tlTypeFreight;
    4 : Result := tlTypeDiscount;
  Else
    Raise EUnknownValue.Create ('Invalid Line Type ' + QuotedStr(IntToStr(FStock.StkLinkLT)));
  End; { Case }
end;

procedure TStock.Set_stDefaultLineType(Value: TTransactionLineType);
begin
  Case Value of
    tlTypeNormal    :  FStock.StkLinkLT := 0;
    tlTypeLabour    :  FStock.StkLinkLT := 1;
    tlTypeMaterials :  FStock.StkLinkLT := 2;
    tlTypeFreight   :  FStock.StkLinkLT := 3;
    tlTypeDiscount  :  FStock.StkLinkLT := 4;
  Else
    Raise EUnknownValue.Create ('Invalid LineType ' + IntToStr(Ord(Value)));
  End; { Case }
end;

{-----------------------------------------}

function TStock.Get_stDepartment: WideString;
begin
  Result := FStock.Dep;
end;

procedure TStock.Set_stDepartment(const Value: WideString);
begin
  FStock.Dep := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TStock.Get_stDesc(Index: Integer): WideString;
begin
  Result := FStock.Desc[Index];
end;

procedure TStock.Set_stDesc(Index: Integer; const Value: WideString);
begin
  FStock.Desc[Index] := Value;
end;

{-----------------------------------------}

function TStock.Get_stFolioNum: Integer;
begin
  Result := FStock.StockFolio;
end;

{-----------------------------------------}

function TStock.Get_stImageFile: WideString;
begin
  Result := FStock.ImageFile;
end;

procedure TStock.Set_stImageFile(const Value: WideString);
begin
  FStock.ImageFile := Value;
end;

{-----------------------------------------}

function TStock.Get_stInclusiveVATCode: WideString;
begin
  Result := FStock.SVATIncFlg;
end;

procedure TStock.Set_stInclusiveVATCode(const Value: WideString);
begin
  FStock.SVATIncFlg := ExtractChar(Value, ' ');;
end;

{-----------------------------------------}

function TStock.Get_stIntrastat: IStockIntrastat;
begin
  { Check Intrastat sub-object has been initialised }
  If (Not Assigned(FIntraO)) Then Begin
    { Create and initialise Intrastat sub-object }
    FIntraO := TStockIntrastat.Create(@FStock);

    FIntraI := FIntraO;
  End; { If (Not Assigned(FIntraO)) }

  Result := FIntraI;
end;

{-----------------------------------------}

function TStock.Get_stLastUsed: WideString;
begin
  Result := FStock.LastUsed;
end;

{-----------------------------------------}

function TStock.Get_stLocation: WideString;
begin
  Result := FStock.stLocation;
end;

procedure TStock.Set_stLocation(const Value: WideString);
begin
  FStock.stLocation := LJVar(Value,MLocKeyLen);
end;

{-----------------------------------------}

function TStock.Get_stOperator: WideString;
begin
  Result := FStock.LastOpo;
end;

procedure TStock.Set_stOperator(const Value: WideString);
begin
  FStock.LastOpo := Value;
end;

{-----------------------------------------}

function TStock.Get_stPandLGL: Integer;
begin
  Result := FStock.NomCodes[3];
end;

procedure TStock.Set_stPandLGL(Value: Integer);
begin
  FStock.NomCodes[3] := Value;
end;

{-----------------------------------------}

function TStock.Get_stParentCode: WideString;
begin
  Result := FStock.StockCat;
end;

procedure TStock.Set_stParentCode(const Value: WideString);
begin
  FStock.StockCat := FullStockCode(Value)
end;

{-----------------------------------------}

function TStock.Get_stPricingMethod: TStockPricingMethod;
begin
  With FStock Do
    If PriceByStkUnit then
      Result := spmByStockUnit
    else
      If StPricePack then
        Result := spmBySplitPack
      else
        Result := spmBySalesUnit;
end;

procedure TStock.Set_stPricingMethod(Value: TStockPricingMethod);
begin
  With FStock Do Begin
    PriceByStkUnit := (Value = spmByStockUnit);
    StPricePack    := (Value = spmBySplitPack);
  End; { With FStock }
end;

{-----------------------------------------}

function TStock.Get_stPurchUnits: Double;
begin
  Result := FStock.BuyUnit;
end;

procedure TStock.Set_stPurchUnits(Value: Double);
begin
  FStock.BuyUnit := Value;
end;

{-----------------------------------------}

function TStock.Get_stQtyAllocated: Double;
begin
  Result := FStock.QtyAllocated;
end;

{-----------------------------------------}

function TStock.Get_stQtyInStock: Double;
begin
  Result := FStock.QtyInStock;
end;

{-----------------------------------------}

function TStock.Get_stQtyMax: Double;
begin
  Result := FStock.QtyMax;
end;

procedure TStock.Set_stQtyMax(Value: Double);
begin
  FStock.QtyMax := Value;
end;

{-----------------------------------------}

function TStock.Get_stQtyMin: Double;
begin
  Result := FStock.QtyMin;
end;

procedure TStock.Set_stQtyMin(Value: Double);
begin
  FStock.QtyMin := Value;
end;

{-----------------------------------------}

function TStock.Get_stQtyOnOrder: Double;
begin
  Result := FStock.QtyOnOrder;
end;

{-----------------------------------------}

function TStock.Get_stQtyPicked: Double;
begin
  Result := FStock.QtyPicked;
end;

{-----------------------------------------}

function TStock.Get_stQtyPosted: Double;
begin
  Result := FStock.QtyPosted;
end;

{-----------------------------------------}

function TStock.Get_stReorder: IStockReorder;
begin
  { Check Reorder sub-object has been initialised }
  If (Not Assigned(FReorderO)) Then Begin
    { Create and initialise Customer Details }
    FReorderO := TStockReorder.Create(@FStock);

    FReorderI := FReorderO;
  End; { If (Not Assigned(FReorderO)) }

  Result := FReorderI;
end;

{-----------------------------------------}

Function TStock.GetSalesBandPrice (Const BandNo : Byte) : Double;
begin
  Result := FStock.SaleBands[BandNo].SalesPrice;
end;

Procedure TStock.SetSalesBandPrice (Const BandNo : Byte; Const Value : Double);
begin
  FStock.SaleBands[BandNo].SalesPrice := Value;
end;

Function TStock.GetSalesBandCcy (Const BandNo : Byte) : Integer;
begin
  Result := FStock.SaleBands[BandNo].Currency;
end;

Procedure TStock.SetSalesBandCcy (Const BandNo : Byte; Const Value : Integer);
begin
  FStock.SaleBands[BandNo].Currency := ValidateCurrencyNo (Value);
end;

function TStock.Get_stSalesBands(const Band: WideString): IStockSalesBand;
Var
  BandChar : Char;
  BandNo   : Byte;
begin
  // Decode Band Number
  BandChar := ExtractChar(UpperCase(Band), #255);
  If (BandChar In ['A'..'H']) Then Begin
    BandNo := Ord(BandChar) - Ord('A') + 1;

    { Check Sales Band sub-object has been initialised }
    If (Not Assigned(FSalesBandO[BandNo])) Then Begin
      { Create and initialise Sales Band sub-object }
      FSalesBandO[BandNo] := TStockSalesBand.Create(BandNo,
                                                    GetSalesBandPrice,
                                                    SetSalesBandPrice,
                                                    GetSalesBandCcy,
                                                    SetSalesBandCcy);

      FSalesBandI[BandNo] := FSalesBandO[BandNo];
    End; { If (Not Assigned(FSalesBandO[BandNo]))  }

    Result := FSalesBandI[BandNo];
  End { If (BandChar In ['A'..'H']) }
  Else
    Raise EUnknownValue.Create ('Invalid Sales Band Index (' + BandChar + ')');
end;

{-----------------------------------------}

function TStock.Get_stSalesGL: Integer;
begin
  Result := FStock.NomCodes[1];
end;

procedure TStock.Set_stSalesGL(Value: Integer);
begin
  FStock.NomCodes[1] := Value;
end;

{-----------------------------------------}

function TStock.Get_stSalesUnits: Double;
begin
  Result := FStock.SellUnit;
end;

procedure TStock.Set_stSalesUnits(Value: Double);
begin
  FStock.SellUnit := Value;
end;

{-----------------------------------------}

function TStock.Get_stShowKitOnPurchase: WordBool;
begin
  Result := FStock.stKitOnPurch;
end;

procedure TStock.Set_stShowKitOnPurchase(Value: WordBool);
begin
  FStock.stKitOnPurch := Value;
end;

{-----------------------------------------}

function TStock.Get_stShowQtyAsPacks: WordBool;
begin
  Result := FStock.stDPackQty;
end;

procedure TStock.Set_stShowQtyAsPacks(Value: WordBool);
begin
  FStock.stDPackQty := Value;
end;

{-----------------------------------------}

function TStock.Get_stSupplier: WideString;
begin
  Result := FStock.Supplier;
end;

procedure TStock.Set_stSupplier(const Value: WideString);
begin
  FStock.Supplier := FullCustCode(Value)
end;

{-----------------------------------------}

function TStock.Get_stSupplierI: IAccount;
begin
  With FToolkit As TToolkit Do
    Result := SupplierO.GetCloneInterface(FStock.Supplier);
end;

{-----------------------------------------}

function TStock.Get_stSuppTemp: WideString;
begin
  Result := FStock.SuppTemp;
end;

procedure TStock.Set_stSuppTemp(const Value: WideString);
begin
  FStock.SuppTemp := FullCustCode(Value)
end;

{-----------------------------------------}

function TStock.Get_stTimeChange: WideString;
begin
  Result := FStock.TimeChange;
end;

{-----------------------------------------}

function TStock.Get_stType: TStockType;
begin
  Case FStock.StockType Of
    'G' : Result := stTypeGroup;
    'P' : Result := stTypeProduct;
    'D' : Result := stTypeDescription;
    'M' : Result := stTypeBillOfMaterials;
    'X' : Result := stTypeDiscontinued;
  Else
    Raise EUnknownValue.Create ('Invalid Stock Type (' + FStock.StockType + ')');
  End; { Case }
end;

procedure TStock.Set_stType(Value: TStockType);
begin
  Case Value Of
    stTypeGroup           : FStock.StockType := 'G';
    stTypeProduct         : FStock.StockType := 'P';
    stTypeDescription     : FStock.StockType := 'D';
    stTypeBillOfMaterials : FStock.StockType := 'M';
    stTypeDiscontinued    : FStock.StockType := 'X';
  Else
    Raise EUnknownValue.Create ('Invalid Stock Type (' + IntToStr(Ord(Value)) + ')');
  End; { Case }
end;

{-----------------------------------------}

function TStock.Get_stUnitOfPurch: WideString;
begin
  Result := FStock.UnitP;
end;

procedure TStock.Set_stUnitOfPurch(const Value: WideString);
begin
  FStock.UnitP := Value;
end;

{-----------------------------------------}

function TStock.Get_stUnitOfSale: WideString;
begin
  Result := FStock.UnitS;
end;

procedure TStock.Set_stUnitOfSale(const Value: WideString);
begin
  FStock.UnitS := Value;
end;

{-----------------------------------------}

function TStock.Get_stUnitOfStock: WideString;
begin
  Result := FStock.UnitK;
end;

procedure TStock.Set_stUnitOfStock(const Value: WideString);
begin
  FStock.UnitK := Value;
end;

{-----------------------------------------}

function TStock.Get_stUseForEbus: WordBool;
begin
  Result := (FStock.WebInclude <> 0);
end;

procedure TStock.Set_stUseForEbus(Value: WordBool);
begin
  // NOTE: Can't Ord COM WordBools as COM WordBool True = 65536!
  If Value Then
    FStock.WebInclude := 1
  Else
    FStock.WebInclude := 0;
end;

{-----------------------------------------}

function TStock.Get_stUseKitPrice: WordBool;
begin
  Result := FStock.StKitPrice;
end;

procedure TStock.Set_stUseKitPrice(Value: WordBool);
begin
  FStock.StKitPrice := Value;
end;

{-----------------------------------------}

function TStock.Get_stUserField1: WideString;
begin
  Result := FStock.StStkUser1;
end;

procedure TStock.Set_stUserField1(const Value: WideString);
begin
  FStock.StStkUser1 := Value;
end;

{-----------------------------------------}

function TStock.Get_stUserField2: WideString;
begin
  Result := FStock.StStkUser2;
end;

procedure TStock.Set_stUserField2(const Value: WideString);
begin
  FStock.StStkUser2 := Value;
end;

{-----------------------------------------}

function TStock.Get_stUserField3: WideString;
begin
  Result := FStock.StkUser3;
end;

procedure TStock.Set_stUserField3(const Value: WideString);
begin
  FStock.StkUser3 := Value;
end;

{-----------------------------------------}

function TStock.Get_stUserField4: WideString;
begin
  Result := FStock.StkUser4;
end;

procedure TStock.Set_stUserField4(const Value: WideString);
begin
  FStock.StkUser4 := Value;
end;

{-----------------------------------------}

function TStock.Get_stValuationMethod: TStockValuationType;
begin
  //PR 5/3/03: serialav cost needs to be R rather than A
  Case FStock.StkValType Of
    'A' : {If (FStock.SerNoWAvg = 1) Then
            Result := stValSerialAvgCost
          Else}
            Result := stValAverage;
    'C' : Result := stValLastCost;
    'F' : Result := stValFIFO;
    'L' : Result := stValLIFO;
    'R' : If (FStock.SerNoWAvg = 1) Then
            Result := stValSerialAvgCost
          Else
            Result := stValSerial;
    'S' : Result := stValStandard;
  Else
    Raise EUnknownValue.Create ('Invalid Stock Valuation Method (' + FStock.StkValType + ')');
  End; { Case }
end;

procedure TStock.Set_stValuationMethod(Value: TStockValuationType);
begin
  FStock.SerNoWAvg := 0;
  Case Value Of
    stValStandard      : FStock.StkValType := 'S';
    stValLastCost      : FStock.StkValType := 'C';
    stValFIFO          : FStock.StkValType := 'F';
    stValLIFO          : FStock.StkValType := 'L';
    stValAverage       : FStock.StkValType := 'A';
    stValSerial        : FStock.StkValType := 'R';
    stValSerialAvgCost : Begin
                          //PR 5/3/03: serialav cost needs to be R rather than A
                           FStock.StkValType := 'R';
                           //FStock.StkValType := 'A';
                           FStock.SerNoWAvg := 1;
                         End;
  Else
    Raise EUnknownValue.Create ('Invalid Stock Valuation Method (' + IntToStr(Ord(Value)) + ')');
  End;
end;

{-----------------------------------------}

function TStock.Get_stVATCode: WideString;
begin
  Result := FStock.VATCode;
end;

procedure TStock.Set_stVATCode(const Value: WideString);
begin
  FStock.VATCode := ExtractChar (Value, ' ');
end;

{-----------------------------------------}

function TStock.Get_stWebLiveCatalog: WideString;
begin
  Result := FStock.WebLiveCat;
end;

procedure TStock.Set_stWebLiveCatalog(const Value: WideString);
begin
  FStock.WebLiveCat := Value;
end;

{-----------------------------------------}

function TStock.Get_stWebPrevCatalog: WideString;
begin
  Result := FStock.WebPrevCat;
end;

procedure TStock.Set_stWebPrevCatalog(const Value: WideString);
begin
  FStock.WebPrevCat := Value;
end;

{-----------------------------------------}

function TStock.Get_stWIPGL: Integer;
begin
  Result := FStock.NomCodes[5];
end;

procedure TStock.Set_stWIPGL(Value: Integer);
begin
  FStock.NomCodes[5] := Value;
end;

{-----------------------------------------}

function TStock.Get_stQtyFree: Double;
Var
  SetupI : ISystemSetup;
begin
  With FToolkit As TToolkit Do
    If SystemSetupI.ssFreeStockExcludesSOR Then
      Result := FStock.QtyInStock
    Else Begin
      If SystemSetupI.ssPickingOrderAllocatesStock Then
        Result := FStock.QtyInStock - FStock.QtyPicked
      Else
        Result := FStock.QtyInStock - FStock.QtyAllocated;
    End; { Else }
end;

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TStock.AuthoriseFunction (Const FuncNo     : Byte;
                                   Const MethodName : String;
                                   Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    1..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);
    // .Discontinue method
    105       : Result := (FIntfType = imGeneral);

    // .stLocationList property
    201       : Result := (FIntfType = imGeneral);

    // .stNotes property
    202       : Result := (FIntfType = imGeneral);
    // .stQtyBreaks property
    203       : Result := (FIntfType = imGeneral);
    // .stAltStockCode property
    204       : Result := (FIntfType = imGeneral);
    // .stLinks property
    205       : Result := (FIntfType = imGeneral);
    // .stSalesAnalysis property
    206       : Result := (FIntfType = imGeneral);
    // .stEquivalent property
    207       : Result := (FIntfType = imGeneral);
    // .stSupersededBy property
    208       : Result := (FIntfType = imGeneral);
    // .stOpportunity property
    209       : Result := (FIntfType = imGeneral);

    // .stMultiBuy property
    210       : Result := (FIntfType = imGeneral);

  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
End; { AuthoriseFunction }

{-----------------------------------------}

Procedure TStock.InitNewStock;
Var
  I : Byte;
Begin { InitNewAccount }
  With FStock Do Begin
    // Type
    FStock.StockType := 'P';  // Product;

    // VAT Code
    VATCode := Syss.VATCode;

    // Valuation Method
    StkValType := Syss.AutoStkVal;

    // Currency
    For I := Low(SaleBands) To High(SaleBands) Do
      SaleBands[I].Currency := 1;
    PCurrency := 1;
    ROCurrency := 1;

    // Units
    UnitK := 'each';
    UnitS := 'each';
    UnitP := 'each';
    SellUnit := 1.0;
    BuyUnit := 1.0;

    // Intrastat
    SuppSUnit := 1.0;

    // Cover
    CovPr:=Syss.PrInYr;
    If (Syss.PrInYr<25) then
      CovPrUnit:='M'
    Else
      CovPrUnit:='W';

  End; { With FStock }
End; { InitNewAccount }

function TStock.Add: IStock;
Var
  FStockO : TStock;
begin { Add }
  AuthoriseFunction(100, 'Add');

  FStockO := TStock.Create(imAdd, FToolkit, FParentSK, FBtrIntf);
  FStockO.InitNewStock;

  Result := FStockO;
end;

{-----------------------------------------}

Procedure TStock.LoadDetails (Const StkDets : TBatchSKRec; Const LockPos : LongInt);
begin
  FStock := StkDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

function TStock.Update: IStock;
Var
  FStockO : TStock;
  FuncRes  : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    FStockO := TStock.Create(imUpdate, FToolkit, FParentSK, FBtrIntf);

    // Pass current Stock Record and Locking Details into sub-object
    FStockO.LoadDetails(FStock, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := FStockO;
  End; { If (FuncRes = 0) }
end;

{-----------------------------------------}

Function TStock.GetCloneInterface (Const StkCode : ShortString) : IStock;
Var
  SaveInfo : TBtrieveFileSavePos;
  lStkCode : ShortString;
  Res      : LongInt;
Begin { GetCloneInterface }
  Result := NIL;

  // Reformat as valid account code
  lStkCode := FullStockCode(StkCode);

  // Check not blank
  If (Trim(lStkCode) <> '') Then Begin
    // Save Current Position and index
    SaveExLocalPosRec (SaveInfo, @FStock, SizeOf(Stock));

    // Find record for AcCode
    Set_Index(stIdxCode);
    Res := GetDataRecord (B_GetEq, lStkCode);
    If (Res = 0) Then
      // Got Record - generate and return a Clone interface
      Result := Clone;

    // Restore Original Index and position
    RestoreExLocalPosRec (SaveInfo, @FStock, SizeOf(Stock));
  End; { If (Trim(lAcCode) <> '') }
End; { GetCloneInterface }

{-----------------------------------------}

Procedure TStock.CloneDetails (Const SKDets : TBatchSKRec);
begin
  FStock := SkDets;
end;

function TStock.Clone: IStock;
Var
  FStockO : TStock;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Stock object and initialise
  FStockO := TStock.Create(imClone, FToolkit, FParentSK, FBtrIntf);
  FStockO.CloneDetails(FStock);

  Result := FStockO;
End; { Clone }

{-----------------------------------------}

function TStock.Save: Integer;
Var
  SaveInfo : TBtrieveSavePosType;
  BtrOp    : SmallInt;
SaveInfo2 : TBtrieveFileSavePos;
//oPos, nPos : LongInt;
begin
  AuthoriseFunction(102, 'Save');
  Profiler.StartFunc('IStock.Save');
  // Save current file positions in main files
  SaveInfo := SaveSystemFilePos ([]);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Result := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Result := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Result = 0) Then Begin
    // Add/Update Stock
    SaveExLocalPos(Saveinfo2);

    Result := Ex_StoreStock (@FStock, SizeOf(FStock), FIndex, BtrOp);

    RestoreExLocalPos(SaveInfo2);

    If (Result = 0) And (FIntfType = imUpdate) And Assigned(FBillMatO) Then
    begin
      // Save any changes made to the Bill Of Materials
      Result := 100000 + FBillMatO.SaveChanges (FStock.StockFolio);
      If (Result = 100000) Then Result := 0;
      TToolkit(FToolkit).StockO.RefreshBOMList;
    end;

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    //PR: 23/02/2016 v2016 R1 ABSEXCH-17328 Moved from above so that bom list gets saved
    if Result = 0 then
      FIntfType := imClone;
  End; { If (Res = 0) }
Profiler.EndFunc('IStock.Save');
  // Restore original file positions
  RestoreSystemFilePos (SaveInfo);
end;

{-----------------------------------------}

procedure TStock.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{-----------------------------------------}

// Translate the Toolkit Index number into the proper Enterprise Index number
Function TStock.TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt;
Begin { TranslateIndex }
  If FromTLB Then Begin
    // Converting a TLB Index number into an Enterprise File Index Number
    Case IdxNo Of
      stIdxCode      : Result := 0;
      stIdxFolio     : Result := 1;
      stIdxParent    : Result := 2;
      stIdxDesc      : Result := 3;
      stIdxSupplier  : Result := 4;
      stIdxPandLGL   : Result := 5;
      stIdxAltCode   : Result := 6;
      stIdxBinLoc    : Result := 7;
      stIdxBarCode   : Result := 8;
    Else
      Raise EInvalidIndex.Create ('Index ' + IntToStr(IdxNo) + ' is not valid in the Stock object');
    End; { Case }
  End { If FromTLB  }
  Else Begin
    // Converting an Enterprise File Index Number into a TLB Index Number
    Case IdxNo Of
      0  : Result := stIdxCode;
      1  : Result := stIdxFolio;
      2  : Result := stIdxParent;
      3  : Result := stIdxDesc;
      4  : Result := stIdxSupplier;
      5  : Result := stIdxPandLGL;
      6  : Result := stIdxAltCode;
      7  : Result := stIdxBinLoc;
      8  : Result := stIdxBarCode;
    Else
      Raise EInvalidIndex.Create ('The Stock object is using an invalid index');
    End; { Case }
  End; { Else }
End; { TranslateIndex }

{-----------------------------------------}

// Build a Stock Code index
function TStock.BuildCodeIndex(const StockCode: WideString): WideString;
Begin { BuildCodeIndex }
  // Index 0 - Code  (StockCodeK)
  Result := FullStockCode(StockCode);
End; { BuildCodeIndex }

{-----------------------------------------}

// Build a Stock Folio index
function TStock.BuildFolioIndex(Folio: Integer): WideString;
Begin { BuildFolioIndex }
  // Index 1 - StockFolio  (StockFolioK)
  Result := FullNomKey(Folio);
End; { BuildFolioIndex }

{-----------------------------------------}

// Build a Stock Parent index - used for the Stock Tree
function TStock.BuildParentIndex(const ParentCode: WideString; const ChildCode: WideString): WideString;
Begin { BuildParentIndex }
  // Index 2 - StockCat+StockCode (StockCATK)
  Result := FullStockTree (ParentCode, ChildCode);
End; { BuildParentIndex }

{-----------------------------------------}

// Build a Stock Description index
function TStock.BuildDescIndex(const Desc: WideString): WideString;
Begin { BuildDescIndex }
  // Index 3 - Desc[1] (StockDescK) }
  Result := UpperCase(LJVar(Desc,StkDesKLen));
End; { BuildDescIndex }

{-----------------------------------------}

// Build a Stock Supplier index
function TStock.BuildSupplierIndex(const AccountCode: WideString;
                                         CostCurrency: Integer;
                                   const StockCode: WideString): WideString;
begin
  // Index 4 - Supplier + PCurrency + StockCode  (StockMinK)
  Result := FullCustCode(AccountCode) + Chr(CostCurrency) + FullStockCode(StockCode);
end;

{-----------------------------------------}

// Build a Stock P&L GL index
function TStock.BuildPandLIndex(PandLGL: Integer; const StockCode: WideString): WideString;
begin
  // Index 5 - BNomCode+StockCode (StockValK)
  Result := FullNomKey(PandLGL) + FullStockCode(StockCode);
end;

{-----------------------------------------}

// Build a Stock AltCode index
function TStock.BuildAltCodeIndex(const AlternateCode: WideString): WideString;
begin
  // Index 6 - AltCode (StockAltK)
  Result := FullStockCode(AlternateCode);
end;

{-----------------------------------------}

// Build a Stock AltCode index
function TStock.BuildBinLocIndex(const BinLocation: WideString): WideString;
begin
  // Index 7 - BinLoc (StockBinK)
  Result := LJVar(BinLocation,BinLocLen);
end;

{-----------------------------------------}

function TStock.BuildBarCodeIndex(const BarCode: WideString): WideString;
begin
  // Index 8 - BarCode (StkBarCK)
  Result := FullBarCode(BarCode);  //SSK 06/10/2016 2017-R1 ABSEXCH-14087: BtKeys1U.FullBarCode used for padding BarCode to 20 characters
end;

{-----------------------------------------}

function TStock.Get_Index: TStockIndex;
begin
  Result := Inherited Get_Index;
end;

procedure TStock.Set_Index(Value: TStockIndex);
begin
  Inherited Set_Index (Value);
end;

{-----------------------------------------}

function TStock.Get_stLocationList: IStockLocation;
begin
  AuthoriseFunction(201, 'stLocationList', 1);

  If (Not Assigned(FStkLocO)) Then Begin
    { Create and initialise Stock-Location Sub-Object}
    FStkLocO := CreateTStockLocation (10, FToolkit, MLocKeyLen, 0);

    FStkLocI := FStkLocO;
  End; { If (Not Assigned(FStkLocO)) }

  FStkLocO.SetStartKey (FullStockCode(FStock.StockCode));

  Result := FStkLocI;
end;

{-----------------------------------------}

function TStock.Get_stAltStockCode: IAltStockCode; safecall;
begin
  AuthoriseFunction(204, 'stAltStockCode', 1);

  If (Not Assigned(FAltStockO)) Then Begin
    { Create and initialise Stock-Location Sub-Object}
    FAltStockO := CreateTAltStockCode (36, FToolkit, FStock.StockFolio, FStock.StockCode);

    FAltStockI := FAltStockO;
  End; { If (Not Assigned(FStkLocO)) }

  // HM 10/09/04: Added StockCode property because otherwise new AltStk items are
  // created using the Stock Code that was passed into the constructor
  FAltStockO.StockCode := FStock.StockCode;
  FAltStockO.StockFolio := FStock.StockFolio;
  Result := FAltStockI;
end;

{-----------------------------------------}

function TStock.Get_stNotes: INotes;
begin
  AuthoriseFunction(202, 'stNotes', 1);

  { Check Notes sub-object has been initialised }
  If (Not Assigned(FNotesO)) Then Begin
    { Create and initialise Customer Details }
    FNotesO := TNotes.Create(imGeneral,
                             FToolkit,
                             FBtrIntF,
                             'STK',
                             '2',
                             False);

    FNotesI := FNotesO;
  End; { If (Not Assigned(FNotesO)) }

  FNotesO.SetStartKey (FStock.StockCode, NoteTCode + NoteSCode + FullNCode(FullNomKey(FStock.StockFolio)));

  Result := FNotesI;
end;

{-----------------------------------------}

function TStock.Get_stQtyBreaks: IQuantityBreak;
Var
  DiscDets : CustDiscType;
begin
  AuthoriseFunction(203, 'stQtyBreaks', 1);
  // Check Qty Break sub-object has been initialised
  If (Not Assigned(FQtyBrkO)) Then Begin
    FQtyBrkO := TQuantityBreak.Create(imGeneral, FToolkit, FBtrIntf, QBDiscSub, False);

    FQtyBrkI := FQtyBrkO;
  End; { If (Not Assigned(FQtyBrkO)) }

  FillChar (DiscDets, SizeOf(DiscDets), #0);
  With DiscDets Do Begin
    QStkCode := FStock.StockCode;
  End; { With DiscDets }

  //PR: 14/02/2012 Change to use new Qty Break record ABSEXCH-9795

  FQtyBrkO.SetStartKey (DiscDets, LJVar('', CustKeyLen) + FullNomKey(FStock.StockFolio), 0);

  Result := FQtyBrkI;
end;

{-----------------------------------------}

function TStock.Get_stAnalysisCodeI: IJobAnalysis;
begin
  With FToolkit As TToolkit Do
    Result := JobCostingO.JobAnalysisO.GetCloneInterface(Get_stAnalysisCode);
end;

{-----------------------------------------}

function TStock.Get_stWhereUsed: IStockWhereUsed;
begin
  // Check Where Used sub-object has been initialised
  If (Not Assigned(FWhereO)) Then Begin
    FWhereO := CreateTStockBOM (bomWhereUsed, 17, FToolkit);

    FWhereI := FWhereO;
  End; { If (Not Assigned(FWhereO)) }

  FWhereO.SetStartKey (FullNomKey(FStock.StockFolio));

  Result := FWhereI;
end;

{-----------------------------------------}

function TStock.Get_stBillOfMaterials: IStockBOMList;
begin
  If (FIntfType <> imAdd) Then Begin
    // Check Bill Of Materials sub-object has been initialised
    If (Not Assigned(FBillMatO)) Then Begin
      FBillMatO := CreateTStockBOMList (18, FIntFType, FToolkit);

      FBillMatI := FBillMatO;
    End; { If (Not Assigned(FBillMatO)) }

    FBillMatO.BuildList(FStock.StockCode, FStock.StockFolio, FStock.PCurrency, FRefreshBOM);

    Result := FBillMatI;
  End { If (FIntfType <> imAdd) }
  Else
    Raise EInvalidMethod.Create ('The Stock stBillOfMaterials property is not available when adding a Stock Record');
end;

{-----------------------------------------}

function TStock.Get_stSerialBatch: ISerialBatch;
begin
  If (FIntfType <> imAdd) Then Begin
    // Check the current stock item is a Serial/Batch type
    If (FStock.StkValType = 'R') Or ((FStock.StkValType = 'A') And (FStock.SerNoWAvg = 1)) Then Begin
      // Check Serial/Batch Number sub-object has been initialised
      If (Not Assigned(FSerialO)) Then Begin
        FSerialO := CreateTSerialBatch (21, FToolkit);

        FSerialI := FSerialO;
      End; { If (Not Assigned(FSerialO)) }

      FSerialO.SetStockKeys(FStock.StockCode, FStock.StockFolio);

      Result := FSerialI;
    End { If (FStock.StkValType = 'R') Or ... }
    Else
      Raise EInvalidMethod.Create ('The Stock stSerialBatch property is not available as the current Stock Item does not use Serial or Batch Numbers');
  End { If (FIntfType <> imAdd) }
  Else
    Raise EInvalidMethod.Create ('The Stock stSerialBatch property is not available when adding a Stock Record');
end;

{-----------------------------------------}
function TStock.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

{-----------------------------------------}

function TStock.Get_stBOMProductionTime: Integer;
begin
  Result := FStock.BomProdTime;
end;

function TStock.Get_stQtyAllocWOR: Double;
begin
  Result := FStock.QtyAllocWOR;
end;

function TStock.Get_stQtyFreeze: Double;
begin
  Result := FSTock.QtyFreeze;
end;

function TStock.Get_stQtyIssuedWOR: Double;
begin
  Result := FStock.QtyIssueWOR;
end;

function TStock.Get_stQtyPickedWOR: Double;
begin
  Result := FStock.QtyPickWOR;
end;

function TStock.Get_stQtyStockTake: Double;
begin
  Result := FStock.QtyStockTake;
end;

procedure TStock.Set_stQtyStockTake(Value: Double);
begin
  if FStock.QtyStockTake <> Value then
  begin
    FStock.QtyStockTake := Value;
    FStock.QtyStockTakeChanged := True;
  end;
end;

function TStock.Get_stWOPAssemblyDays: Integer;
begin
  Result := FStock.WOPProdTimeDays;
end;

procedure TStock.Set_stWOPAssemblyDays(Value: Integer);
begin
  FStock.WOPProdTimeDays := Value;
end;

function TStock.Get_stWOPAssemblyHours: Integer;
begin
  Result := FStock.WOPProdTimeHours;
end;

procedure TStock.Set_stWOPAssemblyHours(Value: Integer);
begin
  FStock.WOPProdTimeHours := Value;
end;

function TStock.Get_stWOPAssemblyMins: Integer;
begin
  Result := FStock.WOPProdTimeMins;
end;

procedure TStock.Set_stWOPAssemblyMins(Value: Integer);
begin
  FStock.WOPProdTimeMins := Value;
end;

function TStock.Get_stWOPAutoCalcTime: WordBool;
begin
  Result := FStock.WOPCalcProdTime;
end;

procedure TStock.Set_stWOPAutoCalcTime(Value: WordBool);
begin
  FStock.WOPCalcProdTime := Value;
end;

function TStock.Get_stWOPIssuedWIPGL: Integer;
begin
  Result := FStock.WOPIssuedWIPGL;
end;

procedure TStock.Set_stWOPIssuedWIPGL(Value: Integer);
begin
  FStock.WOPIssuedWIPGL := Value;
end;

function TStock.Get_stWOPMinEconBuild: Double;
begin
  Result := FStock.WOPMinEcQty;
end;

procedure TStock.Set_stWOPMinEconBuild(Value: Double);
begin
  FStock.WOPMinEcQty := Value;
end;

function TStock.Get_stWOPRoLeadTime: Integer;
begin
  Result := FStock.WOPLeadTime;
end;

procedure TStock.Set_stWOPRoLeadTime(Value: Integer);
begin
  FStock.WOPLeadTime := Value;
end;

function TStock.Get_stUsesBins: WordBool;
begin
  Result := FStock.UsesBins;
end;

procedure TStock.Set_stUsesBins(Value: WordBool);
begin
  FStock.UsesBins := Value;
end;

function TStock.Get_stStockTakeQtyChanged: WordBool;
begin
  Result := FStock.QtyStockTakeChanged;
end;

function TStock.Get_stShowKitOnSales: WordBool;
begin
  Result := FStock.ShowAsKit;
end;

procedure TStock.Set_stShowKitOnSales(Value: WordBool);
begin
  FStock.ShowAsKit := Value;
end;

function TStock.Get_stLinks: ILinks;
begin
  AuthoriseFunction(205, 'stLinks', 1);

  if Not Assigned(FLinksO) then
  begin
    FLinksO := TLinks.Create(imGeneral, FBtrIntf, 'K', '', FStock.StockFolio);

    FLinksI := FLinksO;
  end;

  FLinksO.OwnerType := 'K';
  FLinksO.OwnerCode := '';
  FLinksO.OwnerFolio := FStock.StockFolio;

  Result := FLinksI;
end;

function TStock.Get_stMultiBin: IMultiBin;
begin
  If (FIntfType <> imAdd) Then Begin
    // Check the current stock item is a Serial/Batch type
    If (FStock.UsesBins) Then Begin
      // Check Serial/Batch Number sub-object has been initialised
      If (Not Assigned(FBinO)) Then Begin
        FBinO := CreateTMultiBin (37, FToolkit);

        FBinI := FBinO;
      End; { If (Not Assigned(FSerialO)) }

      FBinO.SetStockKeys(FStock.StockCode, FStock.StockFolio);

      Result := FBinI;
    End { If (FStock.StkValType = 'R') Or ... }
    Else
      Raise EInvalidMethod.Create ('The Stock stMultiBin property is not available as the current Stock Item does not use Serial or Batch Numbers');
  End { If (FIntfType <> imAdd) }
  Else
    Raise EInvalidMethod.Create ('The Stock stMultiBin property is not available when adding a Stock Record');
end;

function TStock.Get_stSalesAnalysis: IStockSalesAnalysis;
begin
  AuthoriseFunction(206, 'stSalesAnalysis', 1);

  if not Assigned(FSalesAnalysisO) then
  begin
    FSalesAnalysisO := TStockSalesAnalysis.Create(imGeneral, FToolkit, FBtrIntf, saStock,
                                               FStock.StockCode);

    FSalesAnalysisI := FSalesAnalysisO;
  end;
  FSalesAnalysisO.Code := FStock.StockCode;
  FSalesAnalysisO.StockFolio := FStock.StockFolio;
  FSalesAnalysisO.StockType := FStock.StockType;
  Result := FSalesAnalysisI;
end;

Function TStock.GetAltStock : TAltStockCode;
Var
  DummyI : IAltStockCode;
begin
  // Check stock sub-object exists
  If Not Assigned(FAltStockO) Then
    // Force creation of Stock Object and Interface
    DummyI := Get_stAltStockCode;

  // Return reference to Stock Object
  Result := FAltStockO;
end;

procedure TStock.RefreshBOMList;
begin
  FRefreshBOM := True;
end;

//-------------------------------------------------------------------------

function TStock.Print(PrintAs: TStockPrintMode): IPrintJob;
Var
  oPrintJob  : TPrintJob;
Begin // Print
  // Only allow printing for general object and clone objects
  If (FIntfType In [imGeneral, imClone]) Then
  Begin
    Case PrintAs Of
      stpmStockWithBOM   : Begin
                             // Create and initialise the PrintJob object
                             oPrintJob := TPrintJob.Create(FToolkit, fmStockDetails, defTypeStockWithBOM, jtForm);
                             With oPrintJob Do
                             Begin
                               // Configure to print the transaction
                               MainFileNum  := StockF;
                               MainKeyPath  := StkCodeK;
                               MainKeyRef   := FullStockCode (FStock.StockCode);

                               TableFileNum := PWrdF;
                               TableKeyPath := PWK;
                               TableKeyRef  := BillMatTCode + BillMatSCode + FullNomKey(FStock.StockFolio);
                             End; // With oPrintJob
                           End;
      stpmStockWithNotes : Begin
                             // Create and initialise the PrintJob object
                             oPrintJob := TPrintJob.Create(FToolkit, fmStockNotes, defTypeStockWithNotes, jtForm);
                             With oPrintJob Do
                             Begin
                               // Configure to print the transaction
                               MainFileNum  := StockF;
                               MainKeyPath  := StkCodeK;
                               MainKeyRef   := FullStockCode (FStock.StockCode);

                               TableFileNum := PWrdF;
                               TableKeyPath := PWK;
                               TableKeyRef  := NoteTCode + NoteSCode + FullNCode(FullNomKey(FStock.StockFolio));
                             End; // With oPrintJob
                           End;
      stpmStockLabel     : Begin
                             // Create and initialise the PrintJob object
                             oPrintJob := TPrintJob.Create(FToolkit, fmLabel, defTypeStockLabel, jtLabel);
                             With oPrintJob Do
                             Begin
                               // Configure to print the transaction
                               MainFileNum  := StockF;
                               MainKeyPath  := StkCodeK;
                               MainKeyRef   := FullStockCode (FStock.StockCode);

                               TableFileNum := MainFileNum;
                               TableKeyPath := MainKeyPath;
                               TableKeyRef  := MainKeyRef;
                             End; // With oPrintJob
                           End;
    Else
      Raise Exception.Create ('TStock.Print: Unknown PrintAs Mode (' + IntToStr(Ord(PrintAs)) + ')');
    End; // Case PrintAs

    // Return reference to interface - object will be automatically destroyed when
    // user reference to it is lost
    Result := oPrintJob;
  End // If (FIntfType In [imGeneral, imClone])
  Else
  Begin
    Raise EInvalidMethod.Create ('The Print method is not available in this object')
  End; // Else
End; // Print

function TStock.Discontinue(RetainComponents: WordBool): Integer;
begin
  AuthoriseFunction(105, 'Discontinue');

  Result := DoDiscontinue(FStock.StockCode, RetainComponents);
end;

function TStock.DoDiscontinue(const StockCode : string; RetainComponents: WordBool): Integer;
var
  LockRes : Boolean;
  SaveInfo2 : TBtrieveFileSavePos;
  KeyS       :  Str255;
  Locked     :  Boolean;
  LockStr    :  Str255;
  WasType    :  Char;
  LocalBillMatO : TStockBOMList;
  LocalBillMatI : IStockBOMList;
  i : integer;
begin
  Result := 0;
  WasType := #0;
  SaveExLocalPos(Saveinfo2);

  with FBtrIntf^ do
  begin
    KeyS := StockCode;
    LockRes := LGetMultiRec(B_GetEq, B_SingLock,KeyS,0,StockF,True,Locked);
    if LockRes then
    begin
      WasType := LStock.StockType;
      LStock.StockType := 'X';
      Result := LPut_Rec(StockF, 0);
    end
    else
      Result := 30001;

    if (Result = 0) and (WasType = 'M') and not RetainComponents then
    begin
      LocalBillMatO := CreateTStockBOMList (18, imGeneral, FToolkit);

      LocalBillMatI := LocalBillMatO;

      LocalBillMatO.DeleteList(LStock.StockFolio);

      LocalBillMatI := nil;
    end; //if bom

    //PR: 17/02/2014 ABSEXCH-14477 Change values in history table.
    if Result = 0 then
    begin
      {* Change Normal History *}

      Change_Hist(WasType,'X',LStock.StockFolio);

      {* Change Budget / Posted History *}

      Change_Hist(Calc_AltStkHCode(WasType),Calc_AltStkHCode('X'),LStock.StockFolio);
    end;
  end; //with btrintf
  RestoreExLocalPos(SaveInfo2);
end;

//-------------------------------------------------------------------------


function TStock.Get_stEquivalent: IAltStockCode2;
begin
  AuthoriseFunction(207, 'stEquivalent', 1);

  If (Not Assigned(FEquivStockO)) Then Begin
    { Create and initialise Stock-Location Sub-Object}
    FEquivStockO := CreateTAltStockCode (45, FToolkit, FStock.StockFolio, FStock.StockCode);

    FEquivStockI := FEquivStockO;
  End; { If (Not Assigned(FStkLocO)) }

  // HM 10/09/04: Added StockCode property because otherwise new AltStk items are
  // created using the Stock Code that was passed into the constructor
  FEquivStockO.StockCode := FStock.StockCode;
  FEquivStockO.StockFolio := FStock.StockFolio;
  Result := FEquivStockI;
end;

function TStock.Get_stSupersededBy: IAltStockCode2;
begin
  AuthoriseFunction(208, 'stSupersededBy', 1);

  If (Not Assigned(FSuperStockO)) Then Begin
    { Create and initialise Stock-Location Sub-Object}
    FSuperStockO := CreateTAltStockCode (46, FToolkit, FStock.StockFolio, FStock.StockCode);

    FSuperStockI := FSuperStockO;
  End; { If (Not Assigned(FStkLocO)) }

  // HM 10/09/04: Added StockCode property because otherwise new AltStk items are
  // created using the Stock Code that was passed into the constructor
  FSuperStockO.StockCode := FStock.StockCode;
  FSuperStockO.StockFolio := FStock.StockFolio;
  Result := FSuperStockI;
end;

function TStock.Get_stOpportunity: IAltStockCode2;
begin
  AuthoriseFunction(209, 'stOpportunity', 1);

  If (Not Assigned(FOppStockO)) Then Begin
    { Create and initialise Stock-Location Sub-Object}
    FOppStockO := CreateTAltStockCode (47, FToolkit, FStock.StockFolio, FStock.StockCode);

    FOppStockI := FOppStockO;
  End; { If (Not Assigned(FStkLocO)) }

  // HM 10/09/04: Added StockCode property because otherwise new AltStk items are
  // created using the Stock Code that was passed into the constructor
  FOppStockO.StockCode := FStock.StockCode;
  FOppStockO.StockFolio := FStock.StockFolio;
  Result := FOppStockI;
end;

function TStock.Get_stPurchaseReturnGL: Integer;
begin
  Result := FStock.PurchRetGL;
end;

function TStock.Get_stPurchaseReturnQty: Double;
begin
  Result := FStock.PurchRetQty;
end;

function TStock.Get_stManufacturerWarrantyLength: Integer;
begin
  Result := FStock.PurchWarranty;
end;

function TStock.Get_stManufacturerWarrantyUnits: TWarrantyUnitsType;
begin
  Result := TWarrantyUnitsType(FStock.PurchWarrantyType);
end;

function TStock.Get_stRestockCharge: Double;
begin
  Result := FStock.RestockCharge;
end;

function TStock.Get_stSalesReturnGL: Integer;
begin
  Result := FStock.SalesRetGL;
end;

function TStock.Get_stSalesReturnQty: Double;
begin
  Result := FStock.SalesRetQty;
end;

function TStock.Get_stSalesWarrantyLength: Integer;
begin
  Result := FStock.SalesWarranty;
end;

function TStock.Get_stSalesWarrantyUnits: TWarrantyUnitsType;
begin
  Result := TWarrantyUnitsType(FStock.SalesWarrantyType);
end;

procedure TStock.Set_stPurchaseReturnGL(Value: Integer);
begin
  FStock.PurchRetGL := Value;
end;

procedure TStock.Set_stManufacturerWarrantyLength(Value: Integer);
begin
  if (Value >= 0) and (Value <= 99) then
    FStock.PurchWarranty := Value
  else
    raise EValidation.Create('Invalid Manufacturer Warranty Length. Must be between 0 and 99');
end;

procedure TStock.Set_stManufacturerWarrantyUnits(
  Value: TWarrantyUnitsType);
begin
  if Value in [wtDays..wtYears] then
    FStock.PurchWarrantyType := Ord(Value)
  else
    raise EValidation.Create ('Invalid stManufacturerWarrantyType (' + IntToStr(Value) + ')');
end;

procedure TStock.Set_stRestockCharge(Value: Double);
begin
  if (Value >= 0) and (Value <= 100) then
    FStock.RestockCharge := Value
  else
    raise EValidation.Create ('Invalid Restock Charge (' + FloatToStr(Value) + '). Must be between 0 and 100');

end;

procedure TStock.Set_stSalesReturnGL(Value: Integer);
begin
  FStock.SalesRetGL := Value;
end;

procedure TStock.Set_stSalesWarrantyLength(Value: Integer);
begin
  if (Value >= 0) and (Value <= 99) then
    FStock.SalesWarranty := Value
  else
    raise EValidation.Create('Invalid Sales Warranty Length. Must be between 0 and 99');
end;

procedure TStock.Set_stSalesWarrantyUnits(Value: TWarrantyUnitsType);
begin
  if Value in [wtDays..wtYears] then
    FStock.SalesWarrantyType := Ord(Value)
  else
    raise EValidation.Create ('Invalid stSalesWarrantyType (' + IntToStr(Value) + ')');
end;

function TStock.Get_stRestockFlag: TRestockChargeType;
begin
  if FStock.RestockFlag = '%' then
    Result := rcPercentage
  else
    Result := rcValue;
end;

procedure TStock.Set_stRestockFlag(Value: TRestockChargeType);
begin
  if Value = rcPercentage then
    FStock.RestockFlag := '%'
  else
    FStock.RestockFlag := #0;
end;

function TStock.Get_stMultiBuy: IMultiBuy;
begin
  AuthoriseFunction(210, 'stMultiBuy', 1);

  If (Not Assigned(FMultiBuyO)) Then Begin
    FMultiBuyO := TMultiBuy.Create(imGeneral, FToolkit, 'T', FBtrIntf);

    FMultiBuyI := FMultiBuyO;
  End; { If (Not Assigned(FMultiBuyO)) }

  FMultiBuyO.SetStartKey(FStock.StockCode);

  Result := FMultiBuyI;
end;

function TStock.Get_stUserField10: WideString;
begin
  Result := FStock.StkUser10;
end;

function TStock.Get_stUserField5: WideString;
begin
  Result := FStock.StkUser5;
end;

function TStock.Get_stUserField6: WideString;
begin
  Result := FStock.StkUser6;
end;

function TStock.Get_stUserField7: WideString;
begin
  Result := FStock.StkUser7;
end;

function TStock.Get_stUserField8: WideString;
begin
  Result := FStock.StkUser8;
end;

function TStock.Get_stUserField9: WideString;
begin
  Result := FStock.StkUser9;
end;

procedure TStock.Set_stUserField10(const Value: WideString);
begin
  FStock.StkUser10 := Value;
end;

procedure TStock.Set_stUserField5(const Value: WideString);
begin
  FStock.StkUser5 := Value;
end;

procedure TStock.Set_stUserField6(const Value: WideString);
begin
  FStock.StkUser6 := Value;
end;

procedure TStock.Set_stUserField7(const Value: WideString);
begin
  FStock.StkUser7 := Value;
end;

procedure TStock.Set_stUserField8(const Value: WideString);
begin
  FStock.StkUser8 := Value;
end;

procedure TStock.Set_stUserField9(const Value: WideString);
begin
  FStock.StkUser9 := Value;
end;

//------------------------------

function TStock.Get_stIsService: WordBool;
begin
  Result := FStock.StkIsService;
end;

procedure TStock.Set_stIsService(Value: WordBool);
begin
  FStock.StkIsService := Value;
end;

//------------------------------

end.

