unit oStkLoc;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     oAddr, MiscFunc, BtrvU2, ExBtTH1U, oStock2, GlobList;

type
  TStockLocation = class(TBtrieveFunctions, IStockLocation, IStockLocation2, IBrowseInfo)
  private
    // Note: All properties protected to allow descendants access
    FStkLoc    : TBatchSLRec;

    FStartKey  : ShortString;
    FCodeLen   : Byte;

    FKillBtr     : Boolean;

    FIntfType  : TInterfaceMode;
    FParentSL  : TStockLocation;
    FToolkit   : TObject;

    // Sales Bands sub-objects
    FSalesBandO : Array[1..8] Of TStockSalesBand;
    FSalesBandI : Array[1..8] Of IStockSalesBand;
  protected
    // IStockLocation
    function  Get_slStockCode: WideString; safecall;
    procedure Set_slStockCode(const Value: WideString); safecall;
    function  Get_slLocationCode: WideString; safecall;
    procedure Set_slLocationCode(const Value: WideString); safecall;
    function  Get_slQtyInStock: Double; safecall;
    function  Get_slQtyOnOrder: Double; safecall;
    function  Get_slQtyAllocated: Double; safecall;
    function  Get_slQtyPicked: Double; safecall;
    function  Get_slQtyMin: Double; safecall;
    procedure Set_slQtyMin(Value: Double); safecall;
    function  Get_slQtyMax: Double; safecall;
    procedure Set_slQtyMax(Value: Double); safecall;
    function  Get_slQtyFreeze: Double; safecall;
    function  Get_slReorderQty: Double; safecall;
    procedure Set_slReorderQty(Value: Double); safecall;
    function  Get_slReorderCur: Smallint; safecall;
    procedure Set_slReorderCur(Value: Smallint); safecall;
    function  Get_slReorderPrice: Double; safecall;
    procedure Set_slReorderPrice(Value: Double); safecall;
    function  Get_slReorderDate: WideString; safecall;
    procedure Set_slReorderDate(const Value: WideString); safecall;
    function  Get_slReorderCostCentre: WideString; safecall;
    procedure Set_slReorderCostCentre(const Value: WideString); safecall;
    function  Get_slReorderDepartment: WideString; safecall;
    procedure Set_slReorderDepartment(const Value: WideString); safecall;
    function  Get_slCostCentre: WideString; safecall;
    procedure Set_slCostCentre(const Value: WideString); safecall;
    function  Get_slDepartment: WideString; safecall;
    procedure Set_slDepartment(const Value: WideString); safecall;
    function  Get_slBinLocation: WideString; safecall;
    procedure Set_slBinLocation(const Value: WideString); safecall;
    function  Get_slCostPriceCur: Integer; safecall;
    procedure Set_slCostPriceCur(Value: Integer); safecall;
    function  Get_slCostPrice: Double; safecall;
    procedure Set_slCostPrice(Value: Double); safecall;
    function  Get_slBelowMinLevel: WordBool; safecall;
    procedure Set_slBelowMinLevel(Value: WordBool); safecall;
    function  Get_slSuppTemp: WideString; safecall;
    procedure Set_slSuppTemp(const Value: WideString); safecall;
    function  Get_slSupplier: WideString; safecall;
    procedure Set_slSupplier(const Value: WideString); safecall;
    function  Get_slSupplierI: IAccount; safecall;
    function  Get_slLastUsed: WideString; safecall;
    function  Get_slQtyPosted: Double; safecall;
    function  Get_slQtyStockTake: Double; safecall;
    procedure Set_slQtyStockTake(Value: Double); safecall;
    function  Get_slTimeChange: WideString; safecall;
    function  Get_slSalesGL: Integer; safecall;
    procedure Set_slSalesGL(Value: Integer); safecall;
    function  Get_slCostOfSalesGL: Integer; safecall;
    procedure Set_slCostOfSalesGL(Value: Integer); safecall;
    function  Get_slPandLGL: Integer; safecall;
    procedure Set_slPandLGL(Value: Integer); safecall;
    function  Get_slBalSheetGL: Integer; safecall;
    procedure Set_slBalSheetGL(Value: Integer); safecall;
    function  Get_slWIPGL: Integer; safecall;
    procedure Set_slWIPGL(Value: Integer); safecall;
    function  Get_slSalesBands(const Band: WideString): IStockSalesBand; safecall;
    function  Get_slQtyFree: Double; safecall;

    function  Get_slStockCodeI: IStock; safecall;
    function  Get_slLocationCodeI: ILocation; safecall;

    //22/7/05 - 5.70
    function Get_slPurchaseReturnGL: Integer; safecall;
    procedure Set_slPurchaseReturnGL(Value: Integer); safecall;
    function Get_slPurchaseReturnQty: Double; safecall;
    function Get_slManufacturerWarrantyLength: Integer; safecall;
    procedure Set_slManufacturerWarrantyLength(Value: Integer); safecall;
    function Get_slManufacturerWarrantyUnits: TWarrantyUnitsType; safecall;
    procedure Set_slManufacturerWarrantyUnits(Value: TWarrantyUnitsType); safecall;
    function Get_slRestockCharge: Double; safecall;
    procedure Set_slRestockCharge(Value: Double); safecall;
    function Get_slSalesReturnGL: Integer; safecall;
    procedure Set_slSalesReturnGL(Value: Integer); safecall;
    function Get_slSalesReturnQty: Double; safecall;
    function Get_slSalesWarrantyLength: Integer; safecall;
    procedure Set_slSalesWarrantyLength(Value: Integer); safecall;
    function Get_slSalesWarrantyUnits: TWarrantyUnitsType; safecall;
    procedure Set_slSalesWarrantyUnits(Value: TWarrantyUnitsType); safecall;
    function Get_slWOPIssuedWIPGL: Integer; safecall;
    procedure Set_slWOPIssuedWIPGL(Value: Integer); safecall;



    //PR: 24/02/2010 Added new functions to deal with SQL Caching in redirect tables
    function LoadTheCache : Integer; override;
    function GetRedirectedDataRec(const BtrOp : SmallInt; const SearchKey : string) : Integer;

    function  BuildCodeIndex(const Code: WideString): WideString; safecall;

    function  Add: IStockLocation; safecall;
    function  Update: IStockLocation; safecall;
    function  Clone: IStockLocation; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;

    Function  GetSalesBandPrice (Const BandNo : Byte) : Double;
    Procedure SetSalesBandPrice (Const BandNo : Byte; Const Value : Double);
    Function  GetSalesBandCcy (Const BandNo : Byte) : Integer;
    Procedure SetSalesBandCcy (Const BandNo : Byte; Const Value : Integer);

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    // Local Methods
    Function  AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CloneDetails (Const StkLocDets : TBatchSLRec);
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Procedure InitNewStkLoc (Const FCode : ShortString);
    Procedure InitObjects;
    Procedure LoadDetails (Const StkLocDets : TBatchSLRec; Const LockPos : LongInt);
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const ParentSL : TStockLocation;
                        Const BtrIntf  : TCtkTdPostExLocalPtr;
                        Const CodeLen, IdxNo : Byte;
                        Const KillBtr  : Boolean);

    Destructor Destroy; override;

    Procedure SetStartKey (Const StartKey : ShortString);
  End; { TStockLocation }


Function CreateTStockLocation (Const ClientId       : Integer;
                               Const Toolkit        : TObject;
                               Const CodeLen, IdxNo : Byte) : TStockLocation;

implementation

uses ComServ, oToolkit, DLLSK01U, DllErrU, BtsupU1, BtKeys1U, EtStrU, SQLStructuresU, TKSQL;

{-------------------------------------------------------------------------------------------------}

Function CreateTStockLocation (Const ClientId       : Integer;
                               Const Toolkit        : TObject;
                               Const CodeLen, IdxNo : Byte) : TStockLocation;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTStockLocation }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by Stock-Location object
  BtrIntf^.Open_System(MLocF, MLocF);

  // Create base TStockLocation object
  Result := TStockLocation.Create(imGeneral, Toolkit, Nil, BtrIntf, CodeLen, IdxNo, True);
End; { CreateTStockLocation }

{-------------------------------------------------------------------------------------------------}

Constructor TStockLocation.Create (Const IType    : TInterfaceMode;
                                   Const Toolkit  : TObject;
                                   Const ParentSL : TStockLocation;
                                   Const BtrIntf  : TCtkTdPostExLocalPtr;
                                   Const CodeLen, IdxNo : Byte;
                                   Const KillBtr  : Boolean);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IStockLocation2, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := MLocF;
  FKillBtr := KillBtr;

  FCodeLen := CodeLen;

  // Initialise variables
  FillChar (FStkLoc, SizeOf(FStkLoc), #0);
  InitObjects;

  // Setup Link for child SL objects to parent SL object
  FIntfType := IType;
  FToolkit := Toolkit;
  If Assigned(ParentSL) Then
    FParentSL := ParentSL
  Else
    FParentSL := Self;

  // HM 15/03/01: Changed to set index directly, as was causing an exception
  // when creating a clone object.
  //Set_Index(IdxNo);
  FIndex := TranslateIndex (IdxNo, True);
  FObjectID := tkoStockLocation;
  if CodeLen = StkKeyLen then
    FRecordSubType := 'L' //Belongs to Location
  else
    FRecordSubType := 'S'; //Belongs to Stock
End; { Create }

{-----------------------------------------}

Destructor TStockLocation.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  If Assigned (FBtrIntf) And (FIntfType = imGeneral) And FKillBtr Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TStockLocation.InitObjects;
Var
  I : Byte;
Begin { InitObjects }
  For I := Low(FSalesBandO) To High(FSalesBandO) Do Begin
    FSalesBandO[I] := NIL;
    FSalesBandI[I] := NIL;
  End; { For I }

  FParentSL := Nil;
  FToolkit := Nil;
End; { InitObjects }

{-----------------------------------------}

Procedure TStockLocation.SetStartKey (Const StartKey : ShortString);
begin
  FStartKey := StartKey;
  FSQLParentKey := StartKey;
end;

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TStockLocation.AuthoriseFunction (Const FuncNo     : Byte;
                                           Const MethodName : String;
                                           Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as MLocF is shared file }

    5..99     : Result := (FIntfType = imGeneral);

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

Procedure TStockLocation.CopyDataRecord;
Begin { CopyDataRecord }
  CopyExStockLocToTKStockLoc(FBtrIntf^.LMLocCtrl.MStkLoc, FStkLoc)
End; { CopyDataRecord }

{-----------------------------------------}

Function TStockLocation.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  if UsingRedirectCache then
    Result := GetRedirectedDataRec(BtrOp, SearchKey)
  else
  With FBtrIntf^ Do Begin
    // General index including Location, StkLoc, AltStk, Telesales, etc... records

    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, CostCCode + CSubCode[False] + FStartKey + SearchKey);

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := CostCCode + CSubCode[False] + FStartKey + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := CostCCode + CSubCode[False] + FStartKey + #255;
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    KeyChk := CostCCode + CSubCode[False] + FStartKey;

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;

      //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
      If (Not CheckKey(KeyS, KeyChk, Length(KeyChk), True)) and (BtrOp <> B_GetEq) Then
        // Not a CC/Dept record - abandon operation
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or CheckKey(KeyS, KeyChk, Length(KeyChk), True);

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LMLocCtrl.RecPFix = CostCCode) And (LMLocCtrl.SubType = CSubCode[False]) Then
        // Convert to Toolkit structure
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (70, Result);
End; { GetDataRecord }

{-----------------------------------------}

function TStockLocation.BuildCodeIndex(const Code: WideString): WideString;
begin
  Result := LJVar(UpperCase(Copy(Code, 1, FCodeLen)), FCodeLen);
end;

{-----------------------------------------}

function TStockLocation.Get_slStockCodeI: IStock;
begin
  With FToolkit As TToolkit Do
    Result := StockO.GetCloneInterface(FStkLoc.lsStkCode);
end;

{-----------------------------------------}

function TStockLocation.Get_slLocationCodeI: ILocation;
begin
  With FToolkit As TToolkit Do
    Result := LocationO.GetCloneInterface(FStkLoc.lsLocCode);
end;

{-----------------------------------------}

function TStockLocation.Get_slLocationCode: WideString;
begin
  Result := FStkLoc.lsLocCode;
end;

procedure TStockLocation.Set_slLocationCode(const Value: WideString);
begin
  FStkLoc.lsLocCode := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slStockCode: WideString;
begin
  Result := FStkLoc.lsStkCode;
end;

procedure TStockLocation.Set_slStockCode(const Value: WideString);
begin
  FStkLoc.lsStkCode := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slBalSheetGL: Integer;
begin
  Result := FStkLoc.lsDefNom[4];
end;

procedure TStockLocation.Set_slBalSheetGL(Value: Integer);
begin
  FStkLoc.lsDefNom[4] := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slBelowMinLevel: WordBool;
begin
  Result := FStkLoc.lsMinFlg;
end;

procedure TStockLocation.Set_slBelowMinLevel(Value: WordBool);
begin
  FStkLoc.lsMinFlg := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slBinLocation: WideString;
begin
  Result := FStkLoc.lsBinLoc;
end;

procedure TStockLocation.Set_slBinLocation(const Value: WideString);
begin
  FStkLoc.lsBinLoc := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slCostCentre: WideString;
begin
  Result := FStkLoc.lsCC;
end;

procedure TStockLocation.Set_slCostCentre(const Value: WideString);
begin
  FStkLoc.lsCC := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TStockLocation.Get_slCostOfSalesGL: Integer;
begin
  Result := FStkLoc.lsDefNom[2];
end;

procedure TStockLocation.Set_slCostOfSalesGL(Value: Integer);
begin
  FStkLoc.lsDefNom[2] := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slCostPrice: Double;
begin
  Result := FStkLoc.lsCostPrice;
end;

procedure TStockLocation.Set_slCostPrice(Value: Double);
begin
  FStkLoc.lsCostPrice := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slCostPriceCur: Integer;
begin
  Result := FStkLoc.lsPCurrency;
end;

procedure TStockLocation.Set_slCostPriceCur(Value: Integer);
begin
  FStkLoc.lsPCurrency := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TStockLocation.Get_slDepartment: WideString;
begin
  Result := FStkLoc.lsDep;
end;

procedure TStockLocation.Set_slDepartment(const Value: WideString);
begin
  FStkLoc.lsDep := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TStockLocation.Get_slLastUsed: WideString;
begin
  Result := FStkLoc.lsLastUsed;
end;

{-----------------------------------------}

function TStockLocation.Get_slPandLGL: Integer;
begin
  Result := FStkLoc.lsDefNom[3];
end;

procedure TStockLocation.Set_slPandLGL(Value: Integer);
begin
  FStkLoc.lsDefNom[3] := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyAllocated: Double;
begin
  Result := FStkLoc.lsQtyAlloc;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyFreeze: Double;
begin
  Result := FStkLoc.lsQtyFreeze;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyInStock: Double;
begin
  Result := FStkLoc.lsQtyInStock;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyMax: Double;
begin
  Result := FStkLoc.lsQtyMax;
end;

procedure TStockLocation.Set_slQtyMax(Value: Double);
begin
  FStkLoc.lsQtyMax := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyMin: Double;
begin
  Result := FStkLoc.lsQtyMin;
end;

procedure TStockLocation.Set_slQtyMin(Value: Double);
begin
  FStkLoc.lsQtyMin := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyOnOrder: Double;
begin
  Result := FStkLoc.lsQtyOnOrder;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyPicked: Double;
begin
  Result := FStkLoc.lsQtyPicked;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyPosted: Double;
begin
  Result := FStkLoc.lsQtyPosted;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyStockTake: Double;
begin
  Result := FStkLoc.lsQtyTake;
end;

procedure TStockLocation.Set_slQtyStockTake(Value: Double);
begin
  FStkLoc.lsQtyTake := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slReorderCostCentre: WideString;
begin
  Result := FStkLoc.lsROCC;
end;

procedure TStockLocation.Set_slReorderCostCentre(const Value: WideString);
begin
  FStkLoc.lsROCC := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TStockLocation.Get_slReorderCur: Smallint;
begin
  Result := FStkLoc.lsROCurrency;
end;

procedure TStockLocation.Set_slReorderCur(Value: Smallint);
begin
  FStkLoc.lsROCurrency := ValidateCurrencyNo (Value);;
end;

{-----------------------------------------}

function TStockLocation.Get_slReorderDate: WideString;
begin
  Result := FStkLoc.lsRODate;
end;

procedure TStockLocation.Set_slReorderDate(const Value: WideString);
begin
  FStkLoc.lsRODate := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slReorderDepartment: WideString;
begin
  Result := FStkLoc.lsRODep;
end;

procedure TStockLocation.Set_slReorderDepartment(const Value: WideString);
begin
  FStkLoc.lsRODep := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TStockLocation.Get_slReorderPrice: Double;
begin
  Result := FStkLoc.lsROPrice;
end;

procedure TStockLocation.Set_slReorderPrice(Value: Double);
begin
  FStkLoc.lsROPrice := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slReorderQty: Double;
begin
  Result := FStkLoc.lsROQty;
end;

procedure TStockLocation.Set_slReorderQty(Value: Double);
begin
  FStkLoc.lsROQty := Value;
end;

{-----------------------------------------}

Function TStockLocation.GetSalesBandPrice (Const BandNo : Byte) : Double;
begin
  Result := FStkLoc.lsSaleBands[BandNo].SalesPrice;
end;

Procedure TStockLocation.SetSalesBandPrice (Const BandNo : Byte; Const Value : Double);
begin
  FStkLoc.lsSaleBands[BandNo].SalesPrice := Value;
end;

Function TStockLocation.GetSalesBandCcy (Const BandNo : Byte) : Integer;
begin
  Result := FStkLoc.lsSaleBands[BandNo].Currency;
end;

Procedure TStockLocation.SetSalesBandCcy (Const BandNo : Byte; Const Value : Integer);
begin
  FStkLoc.lsSaleBands[BandNo].Currency := ValidateCurrencyNo (Value);
end;

function TStockLocation.Get_slSalesBands(const Band: WideString): IStockSalesBand;
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

function TStockLocation.Get_slSalesGL: Integer;
begin
  Result := FStkLoc.lsDefNom[1];
end;

procedure TStockLocation.Set_slSalesGL(Value: Integer);
begin
  FStkLoc.lsDefNom[1] := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slSupplier: WideString;
begin
  Result := FStkLoc.lsSupplier
end;

procedure TStockLocation.Set_slSupplier(const Value: WideString);
begin
  FStkLoc.lsSupplier := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slSupplierI: IAccount;
begin
  With FToolkit As TToolkit Do
    Result := CustomerO.GetCloneInterface(FStkLoc.lsSupplier);
end;

{-----------------------------------------}

function TStockLocation.Get_slSuppTemp: WideString;
begin
  Result := FStkLoc.lsTempSupp;
end;

procedure TStockLocation.Set_slSuppTemp(const Value: WideString);
begin
  FStkLoc.lsTempSupp := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slTimeChange: WideString;
begin
  Result := FStkLoc.lsLastTime;
end;

{-----------------------------------------}

function TStockLocation.Get_slWIPGL: Integer;
begin
  Result := FStkLoc.lsDefNom[5];
end;

procedure TStockLocation.Set_slWIPGL(Value: Integer);
begin
  FStkLoc.lsDefNom[5] := Value;
end;

{-----------------------------------------}

function TStockLocation.Get_slQtyFree: Double;
Var
  SetupI : ISystemSetup;
begin
  With FToolkit As TToolkit Do
    If SystemSetupI.ssFreeStockExcludesSOR Then
      Result := FStkLoc.lsQtyInStock
    Else Begin
      If SystemSetupI.ssPickingOrderAllocatesStock Then
        Result := FStkLoc.lsQtyInStock - FStkLoc.lsQtyPicked
      Else
        Result := FStkLoc.lsQtyInStock - FStkLoc.lsQtyAlloc;
    End; { Else }
end;

{-----------------------------------------}

Procedure TStockLocation.InitNewStkLoc (Const FCode : ShortString);
Begin { InitNewStkLoc }
  FillChar (FStkLoc, SizeOf(FStkLoc), #0);
  With FStkLoc Do Begin
    If (FCodeLen = MLocKeyLen) Then Begin
      { Adding a Location Record for a Stock item }
      lsStkCode := FCode;
    End { If (FCodeLen = MLocKeyLen) }
    Else Begin
      { Adding a Stock Record for a location }
      lsLocCode := FCode;
    End; { Else }


  End; { With FLocation }
End; { InitNewStkLoc }

{-----------------------------------------}

function TStockLocation.Add: IStockLocation;
Var
  AddO : TStockLocation;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TStockLocation.Create(imAdd, FToolkit, FParentSL, FBtrIntf, FCodeLen, FIndex, False);
  AddO.InitNewStkLoc (FStartKey);

  Result := AddO;
end;

{-----------------------------------------}

procedure TStockLocation.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{-----------------------------------------}

Procedure TStockLocation.CloneDetails (Const StkLocDets : TBatchSLRec);
begin
  FStkLoc := StkLocDets;
end;

{-----------------------------------------}

function TStockLocation.Clone: IStockLocation;
Var
  CloneO : TStockLocation;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Stock-Location details object and initialise
  CloneO := TStockLocation.Create(imClone, FToolkit, FParentSL, FBtrIntf, FCodeLen, FIndex, False);
  CloneO.CloneDetails(FStkLoc);

  Result := CloneO;
end;

{-----------------------------------------}

function TStockLocation.Save: Integer;
Var
  SaveInfo    : TBtrieveFileSavePos;
  SaveInfo2   : TBtrieveFileSavePos;
  BtrOp, Res  : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save Current Position in global file
  SaveMainPos(SaveInfo);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Res := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Res := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Res = 0) Then Begin
    // Add/Update Stock-Location
    SaveExLocalPos(SaveInfo2);
    Res := Ex_StoreStockLoc(@FStkLoc,            // P
                            SizeOf (FStkLoc),    // PSIZE
                            BtrOp);              // SEARCHMODE
    RestoreExLocalPos(SaveInfo2);
  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

{-----------------------------------------}

Procedure TStockLocation.LoadDetails (Const StkLocDets : TBatchSLRec; Const LockPos : LongInt);
begin
  FStkLoc := StkLocDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

{-----------------------------------------}

function TStockLocation.Update: IStockLocation;
Var
  UpdateO : TStockLocation;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TStockLocation.Create(imUpdate, FToolkit, FParentSL, FBtrIntf, FCodeLen, FIndex, False);

    // Pass current Location Record and Locking Details into sub-object
    UpdateO.LoadDetails(FStkLoc, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

function TStockLocation.Get_slPurchaseReturnGL: Integer;
begin
  Result := FStkLoc.lsPurchRetGL;
end;

function TStockLocation.Get_slPurchaseReturnQty: Double;
begin
  Result := FStkLoc.lsPurchRetQty;
end;

function TStockLocation.Get_slManufacturerWarrantyLength: Integer;
begin
  Result := FStkLoc.lsPurchWarranty;
end;

function TStockLocation.Get_slManufacturerWarrantyUnits: TWarrantyUnitsType;
begin
  Result := TWarrantyUnitsType(FStkLoc.lsPurchWarrantyType);
end;

function TStockLocation.Get_slRestockCharge: Double;
begin
  Result := FStkLoc.lsRestockCharge;
end;

function TStockLocation.Get_slSalesReturnGL: Integer;
begin
  Result := FStkLoc.lsSalesRetGL;
end;

function TStockLocation.Get_slSalesReturnQty: Double;
begin
  Result := FStkLoc.lsSalesRetQty;
end;

function TStockLocation.Get_slSalesWarrantyLength: Integer;
begin
  Result := FStkLoc.lsSalesWarranty;
end;

function TStockLocation.Get_slSalesWarrantyUnits: TWarrantyUnitsType;
begin
  Result := TWarrantyUnitsType(FStkLoc.lsSalesWarrantyType);
end;

procedure TStockLocation.Set_slPurchaseReturnGL(Value: Integer);
begin
  FStkLoc.lsPurchRetGL := Value;
end;

procedure TStockLocation.Set_slManufacturerWarrantyLength(Value: Integer);
begin
  FStkLoc.lsPurchWarranty := Value;
end;

procedure TStockLocation.Set_slManufacturerWarrantyUnits(
  Value: TWarrantyUnitsType);
begin
  if Value in [wtDays..wtYears] then
    FStkLoc.lsPurchWarrantyType := Ord(Value)
  else
    raise EValidation.Create ('Invalid stManufacturerWarrantyType (' + IntToStr(Value) + ')');
end;

procedure TStockLocation.Set_slRestockCharge(Value: Double);
begin
  if (Value >= 0) and (Value <= 100) then
    FStkLoc.lsRestockCharge := Value
  else
    raise EValidation.Create ('Invalid Restock Charge (' + FloatToStr(Value) + '). Must be between 0 and 100');

end;

procedure TStockLocation.Set_slSalesReturnGL(Value: Integer);
begin
  FStkLoc.lsSalesRetGL := Value;
end;

procedure TStockLocation.Set_slSalesWarrantyLength(Value: Integer);
begin
  FStkLoc.lsSalesWarranty := Value;
end;

procedure TStockLocation.Set_slSalesWarrantyUnits(Value: TWarrantyUnitsType);
begin
  if Value in [wtDays..wtYears] then
    FStkLoc.lsSalesWarrantyType := Ord(Value)
  else
    raise EValidation.Create ('Invalid stSalesWarrantyType (' + IntToStr(Value) + ')');
end;


{-----------------------------------------}

//IBrowseInfo
function TStockLocation.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;


function TStockLocation.Get_slWOPIssuedWIPGL: Integer;
begin
  Result := FStkLoc.lsWOPWIPGL;
end;

procedure TStockLocation.Set_slWOPIssuedWIPGL(Value: Integer);
begin
  FStkLoc.lsWOPWIPGL := Value;
end;

    Function Full_MLocSKey(lc  :  Str10;
                           sc  :  Str20)  :  Str30;


    Begin

      Full_MLocSKey:=FullStockCode(sc)+Full_MLocKey(lc);

    end;

    Function Full_MLocLKey(lc  :  Str10;
                           sc  :  Str20)  :  Str30;


    Begin

      Full_MLocLKey:=Full_MLocKey(lc)+FullStockCode(sc);

    end;



function TStockLocation.GetRedirectedDataRec(const BtrOp: SmallInt;
  const SearchKey: string): Integer;
var
  DataRec : TStockLocationRec;
  sKey : Str255;
begin
  sKey := SetKeyString(BtrOp, SearchKey);
  Result := FSQLRedirect.GetData(BtrOp, FIndex, sKey, @DataRec, SizeOf(DataRec));

  if Result = 0 then
  begin
    FBtrIntf^.LMLocCtrl.RecPfix := CostCCode;
    FBtrIntf^.LMLocCtrl.SubType := CSubCode[False];
    FBtrIntf^.LMLocCtrl.MStkLoc.lsCode1 := Full_MLocSKey(DataRec.lsLocCode, DataRec.lsStkCode);
    FBtrIntf^.LMLocCtrl.MStkLoc.lsCode2 := Full_MLocLKey(DataRec.lsLocCode, DataRec.lsStkCode);
    Move(DataRec, FBtrIntf^.LMLocCtrl.MStkLoc.lsStkCode, SizeOf(DataRec));


    CopyDataRecord;

    FKeyString := sKey;
  end;
end;

function TStockLocation.LoadTheCache: Integer;
var
  DefaultWhere : string;
begin
  Result:= 0;
  if not UsingRedirectCache then
  begin
    FSQLRedirect := TSQLRedirect.Create;
    FSQLRedirect.FileNo := F_STOCK_LOCATION;
    FSQLRedirect.WhereClause := FullQuery;;
    FSQLRedirect.FieldList := FColumns;
    FSQLRedirect.ClientID := FBtrIntf^.ExClientID;
    Result := FSQLRedirect.Open;
  end;
end;

end.
